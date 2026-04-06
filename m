Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8731FF46C46
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 14:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3DA86B00D4; Mon,  6 Apr 2026 10:21:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEE8D6B00D5; Mon,  6 Apr 2026 10:21:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2B746B00D6; Mon,  6 Apr 2026 10:21:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D45266B00D4
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 10:21:11 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9484D1B7F8A
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:11 +0000 (UTC)
X-FDA: 84628343142.09.83C0898
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id C644CC000D
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 14:21:09 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qrhCPB/F";
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775485269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xZoDhbWNEouwgaGlkfkUpjJoSc42y7xWd91vFax7+2Q=;
	b=HuUcXH2TotHdVOTcTF0oHZc5fPFWtWOIm0/Q46ubJka6XmkgzoXhG2/ob9uU5oiX4uG40Y
	+6PdjOPuLyFgyMNGs85DVV6t/+gPJzy0t2l9KHB+2SEym85MdZUK7CWPWCq0j0C//EmnUt
	Eb6kzYvbZ+kZxiNOFqzLBLu/ejsJZas=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775485269; a=rsa-sha256;
	cv=none;
	b=BDpdJMzycA0jzsWKr77gylMc+GeEpp7kugX01jqa6wmpKj329+SpCIjbKTdi9Nt3hnL2/3
	WrhkNvD8/rgc8Ri/QPrp6zPEvgBkNAknripFqEgLw+9hOElrBGUB6h/XfESZE1ovNEnjOG
	4748tuZbryg++hgYAjexjHkYSdzyU30=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="qrhCPB/F";
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 48E3460126;
	Mon,  6 Apr 2026 14:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B40E3C2BC9E;
	Mon,  6 Apr 2026 14:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775485269;
	bh=ib9LXsJztlT6AS3f5wMdXHDwOYMXkAdeN957x1qT4BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qrhCPB/FE7s2ugmzDIClFZRLbmXSI3xuwtYWqEPSGSVk1TtwGU/zlHwfAvweZA5Nu
	 +Q2X2k2WPj3tP/z1wLJB3WZUSueCYfsscrlR429FKIgjD9RKyfK4T6CqLa8zr73Uis
	 JK6agm4Zu12BfZeghE6aGlt3hRZNZmPYdsKbLNKP+VokL/8wx2W7MzcG4W4raVH+sP
	 KpYP8Y2kgkaH99ILDISZc6VKbre0IKaEeuZ3vQanXV1v7wC4ubCwj6Ukccvruzdkih
	 CLVUrwnWtuFZBIPaztH3vJ/b1Pk+KAPzLqZQeKdpn8NXboMhiavOOFJSW7VuwIQT1E
	 A194Z+beJpUpA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
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
	Shuah Khan <shuah@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 35/53] selftests/mm: hugetlb_fault_after_madv: add setup of HugeTLB pages
Date: Mon,  6 Apr 2026 17:17:17 +0300
Message-ID: <20260406141735.2179309-36-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260406141735.2179309-1-rppt@kernel.org>
References: <20260406141735.2179309-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C644CC000D
X-Stat-Signature: hgkmq9wror714t7ckaqsfa6t6456465w
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775485269-573348
X-HE-Meta: U2FsdGVkX1/83L8LWIg7Mvb1FwpKtBKALAhjzcpXXyZGgftQjoB/aAeOf1vHnZgizUASyOAUTgY/7OqH4XXOAqgbMvwIN2lhU3viE1SscyK6YlyLRKVVu7MqXqmVhEycuDH+aOGk0ly6wtyQ9a5O4brywYOrqMGUJBh89B/xdREGm3H2wZX/KjrStXwbiFOvaHZDknsHKomkDNlzgW9Fr2bS08xagM+8yWDkNmUVYBXiGZ0ybKSIH+ZiZNsFmxEXyYj2bSAJD7lM5LN5zh1kW3uuMBxpKWGS7B3idZ995+zOchgCbrB9MlDLK1HAKl8KhpmSfgjfzJJdk3AfihD++4x+gb4o99MxKfKXyRqAvidQzvAkOVxCduWCaKzVq9srfkRC2l4efUyiIbfsTgbGMnl6b8VoQXjXEL+gcofcElbp4bk7418HqyATCpXr3dpJxBQaGh/nW6koab1ottz2L3Q1AifkSgTaAnD6IDydY0Uak6S7a8ewUSHeFT9cSAhOoGeHmUfidWNwEjlnIwvaDqy3LpO2TbvI5q1jFH/PDKav9ATDVIHxikFRfivWQg9odkAwc8uEj/lqjsjGMrcxIJHauRs3pSk7DlIVJHDWFqdtor8JYl9TG1WQhXX1XNiMVpP29OwVHXPikIjOjpAKA4Cp9bNB6Oy0YZi572232ztzHRLi4CONGsE/S76y2hFu1Ko024K10N70sRqR7eWuXE7A8kCvzkGaOkd0YeAwRwOFSZ/8h2ojk22b5dBGKKHsj/AlcMNZnCgeuBcCPzd7nnE6iw8YthSeFjCaOvSXkliV6igUIaQFAksAjmWVx9wRvviagd4HL04GnOk508cvqdjMux7MFRDurxP5zK9WqB8w+il2DK3F4kpe+q4hH/OFghRJN4htTIQGNDfH9WKJh0Knqa6jsmPNWAd1jut0mAr0jwjBCEcZsDhbpw9Hw+7crmGhGtDTjUH9vsw4vcT
 CYy7gePj
 NHYYshup/l6DxIaxz0DkS39h9lVjPK8Ou7G15tdmkcCAwhc9QWmABmpQUkuoaWj4c/QhDXIstwro7DtrDv7LxfYFvw5FQA0Ziwf4Vy/jyF1uhsloVC81X/CqSl+0z6IjW1z6nGi3Q6TkJ4t262qZodcVTR9xU11yXY5dMWjuiZoxuOsFi3Dn8i/ldISva16eBQ5KW7g2bZ/gy+5cnuAWarKf79wwfnPIUrFUuqjOtw3pn/LeKQGsWXeTJLmYVpdBt90ViD3dJNjTWbfh9ArFoikXj+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

hugetlb_fault_after_madv test skips testing if there are no free huge
pages prepared by a wrapper script.

Add setup of HugeTLB pages to the test and make sure that the original
settings are restored on the test exit.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb_fault_after_madv.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
index c718dd065d53..481863cc5fda 100644
--- a/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
+++ b/tools/testing/selftests/mm/hugetlb_fault_after_madv.c
@@ -54,7 +54,6 @@ void *madv(void *unused)
 
 int main(void)
 {
-	unsigned long free_hugepages;
 	pthread_t thread1, thread2;
 	/*
 	 * On kernel 6.4, we are able to reproduce the problem with ~1000
@@ -78,10 +77,9 @@ int main(void)
 	ksft_print_msg("[INFO] detected default hugetlb page size: %zu KiB\n",
 		       huge_page_size / 1024);
 
-	free_hugepages = hugetlb_free_default_pages();
-	if (free_hugepages != 1) {
+	if (!hugetlb_setup_default(1)) {
 		ksft_exit_skip("This test needs one and only one page to execute. Got %lu\n",
-			       free_hugepages);
+			       hugetlb_free_default_pages());
 	}
 
 	while (max--) {
-- 
2.53.0


