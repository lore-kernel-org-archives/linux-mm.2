Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7277FF886D
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 20:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DC336B00EA; Tue, 28 Apr 2026 16:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B47C6B00EB; Tue, 28 Apr 2026 16:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CA356B00EC; Tue, 28 Apr 2026 16:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 15EC96B00EA
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 16:47:37 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D66681B974D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:47:36 +0000 (UTC)
X-FDA: 84709150512.20.6A2ABDE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 55EE440017
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 20:47:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MgHLvtOj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777409255; a=rsa-sha256;
	cv=none;
	b=6WwCTk4HfadYAY3mG99HDJ64ac5F1a+7hCS0FPDf7221ej3SpoE6nXR5PL1OzDmLGJbltS
	VW6B7Ltny7thvgoMpMJjzgpl8S7+5KdWsHVOGw4h9uH3fCAIJz9HS6AAx5ykxME8zNQEH2
	ihIFmkWxyHOy0xHrQAgElYaEVVIr77w=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MgHLvtOj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777409255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=82j2GDo8UgUUYolGlm6QTZNMCQT1YWNRMIaDJGByQog=;
	b=ZVd7Q4L2FwnNPTLbGGxpiX/C74rEvzMtfIws8T9+PRPab2KvJGoCIc6aD4UUywL4+fDi8/
	hYQM4XKfgS13usKOPAfaK9w4BmrOZD5KGO2aNTrj3f7ARRDhjiC9QMcvnz/ZhPJNTcfmzG
	2nmHfHxPVPY/D0KfTaNfD+BBHjyQGXM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CC30061146;
	Tue, 28 Apr 2026 20:47:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730C2C2BCC4;
	Tue, 28 Apr 2026 20:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777409254;
	bh=XUYa2AHXODnUwL+2gtS49wymmJEGg8QhpNWWbUz0fDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MgHLvtOj0Tc6HSaWko38b56B0Y5qzXyNyTnJk8Mao4SXWgeXfbhpanH30CpFlozrp
	 576l/OCiy1eQ8FWChM82uSAzhuqjVTC3nDEzm3IDhzrV06r53ZqpRfPXg1LWyO2adh
	 Z42GCKeMC5pFyErrdhlpS3lOWo+QYKf3tAavsgBDUTSvX4eytqaTS4hUCO9fGevUfE
	 cSCwPpggYmaunAiSaWShpXNzZKZR+l1LbijpPvVh/yNP/iPzyGO2CNdqBBzyQPf4Uq
	 YzzIwHNFecj8x+lE6Ctx+JQKLgIUYbPj/1UT7Q5ewud8/TM6aZDrF/ZdnjUr1iXId/
	 msq9YyiZpG06w==
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
	Luiz Capitulino <luizcap@redhat.com>,
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
Subject: [PATCH v3 43/54] selftests/mm: hugetlb-vmemmap: add setup of HugeTLB pages
Date: Tue, 28 Apr 2026 23:42:29 +0300
Message-ID: <20260428204240.1924129-44-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260428204240.1924129-1-rppt@kernel.org>
References: <20260428204240.1924129-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 99imzkd87h4497ssgwc5i5dofyme9uu7
X-Rspam-User: 
X-Rspamd-Queue-Id: 55EE440017
X-Rspamd-Server: rspam07
X-HE-Tag: 1777409255-978575
X-HE-Meta: U2FsdGVkX19T1N5WkyyO9HrpTG4DaxLootB2RSeBUgm+B2xGMNFiiKDC4MkNh2LZZNAGG3BaiNiSNcpHP07hLB1JkeDBOA2YkLspIhBl4/YqhZvmsaWrKmW9lAP1SJ3+M6YRBpkmfhSmHWjYoHD50+oEg6d+J000bfJKkwGRllXNSL7I6lXvPaZJ5YEwSMf/u9ZZ0v3JQAddDJdhIcCmSHJrCS3k2LXMjHbmu3ic1BvmAe11nu3xMf32xW5H8k3wbv5GX6zwE4C8yrTeDPBKFtrQ88es1fVKJpyzSI8/X5uk8PTo9oHOkYNCMCd4krb5y90YsF+tWKQ41KUvMLRK8pZWe8SN3fRuyj6yawNJ7Ar48ry9Jeyw498TFOQRn9l6toEo+amHqw7IaTvuHYMVb34qM9i8kJ0aMxxeyiSkjwQUhPYtm9Q0adz8lhh96Z5bdFr5Sin+adUr8t0a8/jI3PxOSCDpZQGmAu4YLJUM6Td3XmMYVgbbGt3fSB15xg84UBNlvExgp78NmUDjZGYzze1afNEFQA9MZQu/4/nerUjIw9ilGhtt/S5B8zFaRD6xvpftVVs2jAetqfTEYDBIIGjhxneaBh3kJsGBW0agBwLjfEfDNAlkj/YPnCPtzWxwAjjZJvL8kEY+mEyi4BaGcLIDoN1h/VTJQ0zYNKDje+7Dr+qWz/ukcSliALX0xf9vh7iJAaqrnp711Hd7dCMtoHHYBsBxyn8A5xfGiolDA9vN2OR173akxzlzyVfIcaE2vJjKUWx6gkBvEMgx6tMFHdp3uPW0OSqG9n/ThpWTBJDwJ5uUG3a0jLbzCRLr5AcV71xFNtu7Qm2wBC9c/996jQcPwbCkdpGMYhyPOSszvVppyF3IYK/GZTQHMVdaHDScldIZszZyAqlvjPu0CUPHQyn7RTXPVNJJA2nl7pVJ/rKGJI/VMvj4lIYkA7r/fscySzH3uUgbYsfEgSyfbio
 jbtIIaYk
 ydH2QXdDw3lVr7cRDzXKS1LNhBK9m/kJHhtJmYu+55WIi7sxSD9xXbxh79PeyGSEGRf3ZjYWB+SRf8owXTyQIGSrJMGx5HjR5U2POAZnI4iXedS+ZU4Tneh/NigEH4Jt4cK2fBJk1Rxc75Oqsp8gtV8yXbGLLdajD68dMKiV1pp0PGQvEaUIp1TlQIOfICwL+JyKgFhyga4IB23Fk6CrvIQ3dAfpRC7ed5iY5TfCzxrVWaV4=
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


