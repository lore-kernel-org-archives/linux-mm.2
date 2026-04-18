Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F0C1F99C79
	for <linux-mm@archiver.kernel.org>; Sat, 18 Apr 2026 11:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8DEF6B0288; Sat, 18 Apr 2026 07:00:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3E816B028A; Sat, 18 Apr 2026 07:00:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2E326B028B; Sat, 18 Apr 2026 07:00:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 917FD6B0288
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 07:00:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4CA3258AB5
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:00:10 +0000 (UTC)
X-FDA: 84671382180.04.F3E3716
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 90AE91A0012
	for <linux-mm@kvack.org>; Sat, 18 Apr 2026 11:00:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a828fHzw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776510008; a=rsa-sha256;
	cv=none;
	b=jEF/VMoidFeyPQz1VvMUMnK+47vkYZJGTK/1HHGf786FMSqzM8kc0PbB6vFNTuK9iPnjYB
	9gcGrXx2NWh8zbSR6TUid5PY/P+Je6MO1RxBeF50I1u2buTTWPYULM//qokXji3TJX74TH
	wXYVSXHFtdNnmAsbenp2ypTQ3kcwo8Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a828fHzw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776510008;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=82j2GDo8UgUUYolGlm6QTZNMCQT1YWNRMIaDJGByQog=;
	b=ZT4coih/9bZKQVbwTLW4+zHdj9zXmNLfFgCYFcXf4PUdyrONNpu7dvZZOuz/X554A13tek
	Z/wnKp5DS7zPsct1s0WZS1QGXQIWo2jANpjLiXbCqiE4LkdsgN4bVeh6/Wgj2Q7hrnikHP
	GOkagHQ+2QzqCRpW+0NYc7gIvILdg60=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B8EAD42A8B;
	Sat, 18 Apr 2026 11:00:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323DAC2BCB3;
	Sat, 18 Apr 2026 11:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776510007;
	bh=XUYa2AHXODnUwL+2gtS49wymmJEGg8QhpNWWbUz0fDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a828fHzwlb5IeS7ppg9114zWrP/dPpKznsStLingEc6fRprm4rG3LZLICQ20GlPRS
	 krWXPvo3vgbpepoaKQNWlq2III3LfIT+8N0FJikQDlTaD2NV80CxoH9sJSUJHdABDZ
	 D+vkQxCNDe9xB5XpwL3D5iX2rK3tbykCyfCSIQTPR6E2efIMa8fnOPD1zzzKDWugNq
	 ikqBKUJfXafAtw/9tjjsrGqWXGHC0peW6wJAsdhVKDjqKXhTk72wGraMTDBwZ9KHUp
	 iA6NF+vAczkmCM5Froohi75GJHUl0i725VW990BHmnEpPoVhUctCjGNW+08RZdz5x0
	 6EZPY4D5PaZVA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Donet Tom <donettom@linux.ibm.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lance Yang <lance.yang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Peter Xu <peterx@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Sarthak Sharma <sarthak.sharma@arm.com>,
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 42/53] selftests/mm: hugetlb-vmemmap: add setup of HugeTLB pages
Date: Sat, 18 Apr 2026 13:55:27 +0300
Message-ID: <20260418105539.1261536-43-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260418105539.1261536-1-rppt@kernel.org>
References: <20260418105539.1261536-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 90AE91A0012
X-Rspamd-Server: rspam12
X-Stat-Signature: 46acruqbyojh7uupw7ef9uuamqwx4jbk
X-Rspam-User: 
X-HE-Tag: 1776510008-459786
X-HE-Meta: U2FsdGVkX1+MtLU5mH/shvnLfYz4Q6GeLuu2gPEUXJZokuBJy8CAVa4CG9s4VjGf4lRdMsyPYgOLyvTaS0+nSDDbc3FA/FBxwxKgjW6SB1VXwFGa/FGm2hXnwNex4dQoSxxvM1ToICmNtAQ4UEXqcfuv+y3YlkMd6EmZivvES9z2YEh8uzbUQT1V9OMer4+HYDbn3vBphLXs6QfjED7pAND+xs6QyFl4fOTMSRze0yiiLFJz35i/kJ4pvYv4synkS3QpRIFnTg58ALlaPuI20oaBPvAMCepnOJ70hw7hnRVD9gWPXZdceF6hegRxDURx/wxclVDVWaJJ58X5D0kfHh5L5PBzPie13IKdIVw2QTjbRvLIm7dILAYwQjM2pbu8O2G0R83XB2fpDx92e2uJXaeTdm9Wjhm0wFKhXR+tgPjzGG2GXobjyFMMrzGnc8rI9VUOoPD3RS/Oou78WjvHBkCiCfaYQZnnQ0u6W70hN/V/SOFiwl5zIhG1zPr76zi/RQX60owjIiQ+Uy5qazKi/My4YpdTS5A2rMT9JARbbAywdfE6jnR9f1EjrKYDUo4+jN8sNDlHLnnZhggkknFIb3+vvLbb8sDjROk54ji44oa2RnUnSOryue3c5lsF62JbQfnSRnXGpT5tBoKpbt5fRK8muuxFjitRfGAU3N+WmtalltS1zXCirW2mTUeglkOHPo8P6aVQnnUZbl6Aas5xnQJDPQ5WB5+6oHproRxsw3fCJGipX92OCp1Nw1ClRM5orjWhk9VH2UGVHIawVp1y5yNuMqA5NkBFuZCQv39GdwhiZnEmiLLlyO4YGmnyx+YS4lVD+b3dlHNgOZtKWawaNjBgOFkGhAtHGopKSBFAJO/LbdAifSU4lNc5MTlUc2m234jHtkwKp/AkE3gXhz2Pcil75Ti+fct/1q4A9drbqSvdMOMrUKo9EDgVXBcYGz6v/d9wcMcdr1jhDXU1Zzh
 MP39DUHo
 c0XkLIttyEEhuiyXdzcq2t1367E/oVFJiIrBGJQsWrUcsgtQlFCt4Yk5jOol/fSgkEQBESIVBQCOQMoLsoZ3L6CKxl0sV9tQLwXaeF0hS3JJ3NHNkhwNlojsJuhZ2/7hjGiN0ojd3ONkkmbIAECxTtrf9JWwAlCfNyNgaX5SnW1fcRuGWm/SGt13JueNlMPwaQMa82OQIaSPDqFFcq4RAE4OFHOe1EDXqK7Zp7Cg8Cdj8CQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb-vmemmap test fails if there are no free huge pages prepared by a
wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-vmemmap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/mm/hugetlb-vmemmap.c b/tools/testing/selftests/mm/hugetlb-vmemmap.c
index af5786bebfd1..507df78a158d 100644
--- a/tools/testing/selftests/mm/hugetlb-vmemmap.c
+++ b/tools/testing/selftests/mm/hugetlb-vmemmap.c
@@ -97,6 +97,9 @@ int main(int argc, char **argv)
 	ksft_print_header();
 	ksft_set_plan(1);
 
+	if (!hugetlb_setup_default(1))
+		ksft_exit_skip("Not enough free huge pages\n");
+
 	pagesize  = psize();
 	maplength = default_huge_page_size();
 	if (!maplength)
-- 
2.53.0


