Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28A57CD4840
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 16:29:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92B116B00CC; Mon, 11 May 2026 12:29:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 902676B00CF; Mon, 11 May 2026 12:29:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83F516B00D0; Mon, 11 May 2026 12:29:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 75A926B00CC
	for <linux-mm@kvack.org>; Mon, 11 May 2026 12:29:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 40DAF1201DD
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:29:51 +0000 (UTC)
X-FDA: 84755675382.23.A8A4F78
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7DC2F1C000B
	for <linux-mm@kvack.org>; Mon, 11 May 2026 16:29:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=egVBQ4+R;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778516989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8GMj/1wLInkljUL5nVDeSjbOV+vFkgGYEZ5pzymmDLI=;
	b=NHk3e92z5q7TNX8he2MRAjlQ26GJ6+tlUgkRcBQsRKenZdKHDtzWSmkbJbGQlth4lHNDmW
	kwxkqeqC56VJj3AWDZnyfgWhQ8l8S0dKy8lisqJRy4LohgN7dWB3fDGojpz9GON++TAtA8
	TqRS1c4vSdvD0GUJPimv+SgzCfLfndQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=egVBQ4+R;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778516989; a=rsa-sha256;
	cv=none;
	b=3B9EFt8xQAP8aZqiUggRSZ001QbwUU1H5ZtySmnVXaGzmUWckq4hIXy+u7bZNxGxNxxVlZ
	H+LGt+hGUQ6+aWVNf8gy/BNpqo+YKwOYoimgXNV6/m/nhCKKvCZOpwuqaMRlueIyZijc/v
	y1jMwWn9N3vJmnD+0kmeUrXlFPG36LU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A5E14444B0;
	Mon, 11 May 2026 16:29:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84394C2BCB0;
	Mon, 11 May 2026 16:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778516988;
	bh=wdE3JPHxJ3hZag9XX0bZPFLgBo7cw90AisqIGfRFSzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=egVBQ4+Rbpedq0zgVohnDvYzFsTILgrEfYYktcK/2PsoYr05V79ExklgkWlJs2XmG
	 bHcoXlLNosEo+rey4/pGgGGJe7/vGUbhkdWAxoY/pcxAj4czjUGQzqvVDHQEGHHbft
	 wa9besSvHoisXVL+i5FTkcCxmtCjyrAr0TC/kqZnC1NHIDCgQCvcNPGu7tRYQPXT+X
	 gz5SF/Q+3/p9resyTj5iIs7BsklFn7jbwOVixTyvwUFLesdedEx2IPqcEvhRhPGrTv
	 5+q5cvJeMrUWHRAMLaWz7rsT6LSUG9ELI4erxAB3ZNOc9g5kXYYyneMonqtMpbt8Yo
	 kgp5mFITn64/g==
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
	Li Wang <li.wang@linux.dev>,
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
Subject: [PATCH v4 09/55] selftests/mm: hugetlb-vmemmap: use kselftest framework
Date: Mon, 11 May 2026 19:27:53 +0300
Message-ID: <20260511162840.375890-10-rppt@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511162840.375890-1-rppt@kernel.org>
References: <20260511162840.375890-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7DC2F1C000B
X-Stat-Signature: xprxm3abmtqwjrycqg3jzhfjho8hdm61
X-HE-Tag: 1778516989-542118
X-HE-Meta: U2FsdGVkX1/ntkUfi4idl7P9snYJAlKadX7h4H9ZN1YF/fXs5GVwqn5ZvRxf/n8QpjpRAZtASsJ7PfPn+chA+IHrUeKpu7Kit/8URovrtHmSTbiaMfJFP5ylkud4Ruf5z67uG1HGSRGfqInVfXnmfXsjFBNDLi5zWIB7Sz2torvmahU6k4AW9HgKMKyOdw+kr61mpB0PUSlMxckuw0ywe7dqZ42UY6txpruh2wUl+O6eBL5JoKiCtve/0+R7BaZDR8hF6x8BLunCco8sYTMAZF4SintBTMqlfTmiymKLIUJwjnfJwdSEXBfcLO9Z9m4MeQR1DQZpzOXG5Gis1HJ/Y/STg10OyAw0BjZLbGXWUD6tLnuDLVNPd/XoiQ72TpS5sG/3zzS8nOxhTzn3vOc5HatHOrnrt34wOPXEIHklehc0nzoSk3jN+EjsCRJ4jAFZYvYxu7EUpUpwn2wm17NHFWt47Eq2+EAUmjSJFkXZDQ8m1408m3SdODJD+AELPKTtX/af77WmYnhg59bDXAQrrUAkzjhnTCE/LNEziMijgrw7M+GqFK4kUzXRp6vBPnpZrnRwymdnjThzXJ1fkxvorTnd69crhfZpeWFTXo+TBmHVdWWanxzAoa89lceq+Q96zsCxcpS5LTdm8y0lLWzPqvli6FSVe8h1+ceB5H8adoDOrzwLnpA5awYrcXohbgMib0XDvJ+SadMzPMI/ZF6S4v0rLCpCx0EIjyy5ikTSiixZj3VMcCCKQjA2MzOqG5gHCB4tfrBcbVOFX8QXY2TTU8SIMv5YjlJY/NdqgEdbR66z0fuejLJbL3tIDiC9ClRUp0KYkprrA5lGjzZCW/W/Etj+OJ3tnsNYi9scYLwLxgAF0z7bEG3NdALtG8E7QqqFYHVe5pbL6eMosvfJfV+4sXHVXQ8P27zDvhqVfV7i5m91WB8RAoX+BhjWeIKcnPCQbAJhlJ6uRuI9t1MRpnf
 sGgsO+Vp
 ixsH2xmGcov4vgSYxmqyfcQFpDLXzdYyg8AY7pkeS23ImvJnkozJmEmCka2akOJOhGXbChJjV020aw6k9Hj+L1YwwHXV+AUy2LeM+ye4D1+TGm0jcLn0Mu7UVdKBqaw1AL+vPMyU8gWeZXwDPirDusXyamcb89U4MJET1SiXs85Zd5WPJkozsPN4mZUsi+mhZByDU4ZcCdHCTo7ZbxBfu4l2wUGsXG2DdowDI6Z98ISOw8F7r1G8Q9VKBSXxxpyQ3/Il3dbEGvIM+7aFov61MsvMwSvIjH2DgN3uVMUnBDz7xtciTQG1JROYI/v1ocOYx34jhmfMITSW6vbwrnclr88Kxgw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Convert hugetlb-vmemmap test to use kselftest framework for reporting
and tracking successful and failing runs.

Reviewed-by: Donet Tom <donettom@linux.ibm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
Tested-by: Luiz Capitulino <luizcap@redhat.com>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 tools/testing/selftests/mm/hugetlb-vmemmap.c | 42 +++++++++-----------
 1 file changed, 18 insertions(+), 24 deletions(-)

diff --git a/tools/testing/selftests/mm/hugetlb-vmemmap.c b/tools/testing/selftests/mm/hugetlb-vmemmap.c
index df366a4d1b92..485a6978b40f 100644
--- a/tools/testing/selftests/mm/hugetlb-vmemmap.c
+++ b/tools/testing/selftests/mm/hugetlb-vmemmap.c
@@ -63,7 +63,7 @@ static int check_page_flags(unsigned long pfn)
 	read(fd, &pageflags, sizeof(pageflags));
 	if ((pageflags & HEAD_PAGE_FLAGS) != HEAD_PAGE_FLAGS) {
 		close(fd);
-		printf("Head page flags (%lx) is invalid\n", pageflags);
+		ksft_print_msg("Head page flags (%lx) is invalid\n", pageflags);
 		return -1;
 	}
 
@@ -77,7 +77,7 @@ static int check_page_flags(unsigned long pfn)
 		if ((pageflags & TAIL_PAGE_FLAGS) != TAIL_PAGE_FLAGS ||
 		    (pageflags & HEAD_PAGE_FLAGS) == HEAD_PAGE_FLAGS) {
 			close(fd);
-			printf("Tail page flags (%lx) is invalid\n", pageflags);
+			ksft_print_msg("Tail page flags (%lx) is invalid\n", pageflags);
 			return -1;
 		}
 	}
@@ -91,44 +91,38 @@ int main(int argc, char **argv)
 {
 	void *addr;
 	unsigned long pfn;
+	int ret;
+
+	ksft_print_header();
+	ksft_set_plan(1);
 
 	pagesize  = psize();
 	maplength = default_huge_page_size();
-	if (!maplength) {
-		printf("Unable to determine huge page size\n");
-		exit(1);
-	}
+	if (!maplength)
+		ksft_exit_skip("Unable to determine huge page size\n");
 
 	addr = mmap(NULL, maplength, PROT_READ | PROT_WRITE,
 			MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
-	if (addr == MAP_FAILED) {
-		perror("mmap");
-		exit(1);
-	}
+	if (addr == MAP_FAILED)
+		ksft_exit_fail_perror("mmap");
 
 	/* Trigger allocation of HugeTLB page. */
 	write_bytes(addr, maplength);
 
 	pfn = virt_to_pfn(addr);
 	if (pfn == -1UL) {
+		ksft_perror("virt_to_pfn");
 		munmap(addr, maplength);
-		perror("virt_to_pfn");
-		exit(1);
+		ksft_exit_fail();
 	}
 
-	printf("Returned address is %p whose pfn is %lx\n", addr, pfn);
+	ksft_print_msg("Returned address is %p whose pfn is %lx\n", addr, pfn);
 
-	if (check_page_flags(pfn) < 0) {
-		munmap(addr, maplength);
-		perror("check_page_flags");
-		exit(1);
-	}
+	ret = check_page_flags(pfn);
 
-	/* munmap() length of MAP_HUGETLB memory must be hugepage aligned */
-	if (munmap(addr, maplength)) {
-		perror("munmap");
-		exit(1);
-	}
+	if (munmap(addr, maplength))
+		ksft_exit_fail_perror("munmap");
 
-	return 0;
+	ksft_test_result(!ret, "HugeTLB vmemmap page flags\n");
+	ksft_finished();
 }
-- 
2.53.0


