Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9823FC982DC
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 12:25:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522806B0092; Fri, 18 Sep 2026 08:25:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FA136B0093; Fri, 18 Sep 2026 08:25:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410236B0095; Fri, 18 Sep 2026 08:25:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 243636B0092
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:25:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 697371C2DED
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:25:49 +0000 (UTC)
X-FDA: 85226804418.25.22290E6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3E21A1C0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:25:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J6Yr5t9j;
	spf=pass (imf20.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789734347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yWzWK+i3KP2Ocq7CGn2LNxEVDtASSsMy49G+OWE8g+g=;
	b=SQu5F+bhaL0HdHVXb3X1k0rb6r/CV9IYk81h1eR2E2Io8Hb6lGhIcgfQp5C2CTPqt4z3Vv
	liCYm5ZCUjRv37TybZl6gXS1CvQfhbbjE6YtmMJK3UuKxOaBRa9H/6n+jJPQ7/gvb8c0iK
	3I8B0L2i/DDXUcuNcAba79UaIeWDOXc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J6Yr5t9j;
	spf=pass (imf20.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789734347;
	b=QhMEfIRtOO7X8n8anLQCuMabD56J0NFtnqOXGraD5IOLcJh2LQH3M+TMzJx6nQvoEfh4Jg
	qRhWLj/DOp9oPfdfTn7xZf+hVKgnDbd1P9PXuuXlPuN76GLCvQvW3gmU0rsGfbjgDX8Ean
	qkRiojxwSsl4RoHJkuW/bEBZnkzI2Vs=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8DEA2168F;
	Fri, 18 Sep 2026 05:25:42 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C5F223F86F;
	Fri, 18 Sep 2026 05:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789734346; bh=bzLjVbV2XLshhPh87slsfNupz1y3zpt+smqxp/pTH6E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J6Yr5t9jOHufl2Hjx55B6CUtsmoGSJkiZNp3ty7YyOQ789q6L3J/hEyTjh9dj/T3s
	 lVGkdOZmKzRKHURxizUKFUkeVaVfK4NHxPl+UXNlgRa99qTclq23pmBEtuOkXQpgjZ
	 QkcEm7i1eGR3tTmvJygym8i+Vxa2Mt+KlUeGCixw=
Message-ID: <937939c3-ae9a-4148-a601-0f8876216423@arm.com>
Date: Fri, 18 Sep 2026 17:55:36 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 1/6] selftests/mm: make file helpers return errors
To: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Mark Brown <broonie@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260918112234.195857-1-sarthak.sharma@arm.com>
 <20260918112234.195857-2-sarthak.sharma@arm.com>
Content-Language: en-US
From: Sarthak Sharma <sarthak.sharma@arm.com>
In-Reply-To: <20260918112234.195857-2-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3E21A1C0002
X-Stat-Signature: 1upwpjjpagn7x7u3gc9oo8f6r6an6tn1
X-Rspam-User: 
X-HE-Tag: 1789734347-405471
X-HE-Meta: U2FsdGVkX1+MzYnhsR+F78sGGOMPs+pC6Ql4C/O7+BcRICLCLEAEbsDP56zS1OxOaOUjprwfwih+RU52tAN4lBA024ftiOYvbQUnd8zIr5VSNKZZMKGE4OHTYPGC1buva92CyYGEFQ9tWoHjJY+3+C40KUNQGfaYxNUMraH7n9jIRKwhWggeMpRYEVGz1WcEZZ2Z74ny0nWJqkH9oUsjts4YvqmA4WupGbxoCdi8go13fTv546coT8IWB2M8YjmmmybjO2Cc2WQxFDVRPRzGzqH747KKxucS4qAfRN3Zn9l74+FlIjfdqi06nsG1jWsQy+jFKJt+l2IzlQ9bJY3fbofctIqoqYhfkUNEGVCACy9kzgvEI51T6JxJyhOf666xbcHwlAlA3PbLe+qzi4RKzsBbIz4K2WFJFfPQGn2L/I2ZbRm6WreEzeXm7BU0nJtdfMUqwyOxJwl+yS6C1JO1qZHOsV3I4RCyuQkbwX0R2V9iRnGS1Mcakx/78wzImr3eOAs69NlJzOQRpV9EPKHJt5aNy0JPXMWOBDbv7qSbdqjFfYe24hfTXCU5yo59asjbqqYENDgaIw38GyiGXYhjR8l1PkzHERGVpqXOQePRVnx3L9+Gj5Oqvw8nBE6sqMUhXcsQcjLE1WGXTdyZCXNrR8dsR4+hDNkt3pZYD4WSlWJpTSTBz2MZL6shpYNL9QxnoRuy6ao72bXxXDnsx/FXnOKLEnKaEUo/GOfFSVLH00j/n7vnq6ScaAJkReH682U40GHCddh4DRYSUI8XUfQ/S7ItiMamgWnno6NfFFSQGE6bKa0/vK/a4oFULDan2TF1spdCmwWTPFj9fify6idz2Uzd12dfBdjoOSVz5jLGK6ixsKYiRpmc+qsLKUxTF+MNFH7nAIyLCw1AdvrMncDVHzge3lUxftUM7S4GQ7JXYstusHbePTv3ogTBIuVuCsyf1k06IYY0NHRGaCs4NJd
 pDaSnuMH
 p08oE75Ix17L9YOKFjtf3R5PIKSQKBZpIMuiT/CTzjQbPPqD/daekjOy9GpzvVWfjN2cn+KRf3jlPcHXsKZChO+auv4SZ4AfCpun8vEqpTvO0LbkPB/kAUR7E65PtrLXxmJOzchdAMU9YgRWCBQOZ0vmbXiGEpuXycVhoLJVpNBs7Uw3Fxa6t2lpYI7JfayH0JBr/5wMURgZfV1NelZDFUFzfNnNFSwmzsbD/kqzKGl+IruNsmRKuq9tc9x4inIuGgzqCENDm/UW6ErmYOIzrgQ2boNB9egUApS4l/70ZE4EeoKwbKBaqzLzNxO/uf+eXfdYh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/18/26 4:52 PM, Sarthak Sharma wrote:
> Change read_file(), write_file(), read_num(), write_num() and
> write_num_ignore_einval() in vm_util.c to report failures to callers
> instead of exiting from the helper.
> 
> Make read_file() return a negative errno on failure and 0 on success, so
> callers can distinguish a successful read from an I/O error. Also make
> read_num() reject negative and malformed values.
> 
> Keep write_num_ignore_einval() silent for -EINVAL while returning other
> errors to its caller.
> 
> Update callers to print diagnostics and fail wherever required. Modify
> a comment which implies write_num() uses ksft_exit_fail_msg(). Also add
> a helper print_file_access_error() in hugepage_settings.c to print
> TAP-compatible errors without a kselftest dependency. This prepares the
> helpers to be moved to tools/lib/mm without a kselftest dependency.
> 
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---
Hi Andrew!

This fixes an MM selftest build failure in patch 1/6: read_num() changed
its interface, but hugetlb_nr_resv_pages() was missed during the caller
conversion. I'm sorry for missing this.

Can you please apply this fixlet after this patch and before the next
one? Sorry for the inconvenience again.


From f7cfae95a1d0554ea03df320d91641979a9ac473 Mon Sep 17 00:00:00 2001
From: Sarthak Sharma <sarthak.sharma@arm.com>
Date: Fri, 18 Sep 2026 17:40:50 +0530
Subject: [PATCH] fixup! selftests/mm: make file helpers return errors

Convert hugetlb_nr_resv_pages(), which was missed when read_num()
changed to return an error and store the parsed value through an output
pointer.

Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
---
 tools/testing/selftests/mm/hugepage_settings.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/hugepage_settings.c
b/tools/testing/selftests/mm/hugepage_settings.c
index 9a63420d0744..6f3abd357385 100644
--- a/tools/testing/selftests/mm/hugepage_settings.c
+++ b/tools/testing/selftests/mm/hugepage_settings.c
@@ -515,10 +515,18 @@ unsigned long hugetlb_free_pages(unsigned long size)
 unsigned long hugetlb_nr_resv_pages(unsigned long size)
 {
 	char path[PATH_MAX];
+	unsigned long nr;
+	int ret;

 	hugetlb_sysfs_path(path, sizeof(path), size, "resv_hugepages");

-	return read_num(path);
+	ret = read_num(path, &nr);
+	if (ret) {
+		print_file_access_error(path, ret);
+		exit(EXIT_FAILURE);
+	}
+
+	return nr;
 }

 static bool __hugetlb_setup(unsigned long size, unsigned long nr)
-- 
2.53.0

