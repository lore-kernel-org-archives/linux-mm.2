Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44ECEFCD0CC
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 08:17:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E6B86B0121; Wed, 18 Mar 2026 04:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BDF26B0123; Wed, 18 Mar 2026 04:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5326B0124; Wed, 18 Mar 2026 04:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6CA756B0121
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 04:17:49 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19B5259973
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:17:49 +0000 (UTC)
X-FDA: 84558480258.26.C530056
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 57553100011
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 08:17:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=idZ1h2Z7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773821867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lhzzfCj1ANnHdOqoemeaPAs6qvoyeAN8adgBufC0gbU=;
	b=5taAKYFdXGJDD1JYEvR74xUK6xSHcQqui75LqwaDO6Ez/vnSj1GsphiBnAyZHoY7ltCsB8
	0mXlivQasU1/YAUS3M+XZIzy1bNdxDfdzS6baEnlBlDo2XQ7bkHMpRPreAKVvKrnYn0FVw
	UbbutFkBULmupziBZimzRMxZPJT0mO0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773821867; a=rsa-sha256;
	cv=none;
	b=M4O/kExlF8mlzQZThmbKI/wpP/8JFeF5m4Yj4vBfbWiYUjQnMbK2K2pdKDMLOh48OpMM/f
	TJ6x0ff3sEsYIZKG3uGB/N9Eb0p3vAvrFcv/+crbTSJykaILo3C2ZpBk7/xw64wy41MKVV
	vA/kp5X7dulrFn2Qht7f5CxW8zCZm6k=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=idZ1h2Z7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 96752600AE;
	Wed, 18 Mar 2026 08:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72F3FC19421;
	Wed, 18 Mar 2026 08:17:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773821866;
	bh=BzUEDaUVyZC2ezAxkwUtmSG+RgFKaKbOHSVqXk7J60A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=idZ1h2Z7GUr72Wjmzbp18MvqPvCXf8h1CAbzzIn6FYZy2l/51v9A2lzLbeqe2B9OF
	 FiHeCtzRHff/2oOOYOHH1XPfklHBD4ILoM2Heg4hjpkjsYRxOOWsNc4rgcd503jRN5
	 uCYEEOdHOOYwzBiwgWT/MVxsNHfZnSj6qaJZ0i2DkIxSXqb9C/IUy8pW9lHZBInptm
	 uv6tc2R3EsmvME9JoJE0aWrLIsjUiKO+w2sVYA8zPOPx2OGES1sGwbCJ1RFA8Svetq
	 ULihY1lJvgrnfWYmUV1Yz/hZD1CowkWnmsxA5Y2bj55DK+c0R3UPH7Eod8xQemATVu
	 iK1VlXJvXVhjw==
Message-ID: <f635585f-7488-4bfe-8566-1c19f493c6a3@kernel.org>
Date: Wed, 18 Mar 2026 09:17:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] selftests/mm: Fix soft-dirty kselftest supported check
To: Audra Mitchell <audra@redhat.com>
Cc: linux-kselftest@vger.kernel.org, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, shuah@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260218184210.206466-1-audra@redhat.com>
 <c1b6f8eb-602b-4306-ad60-7a181fd94a45@kernel.org> <abludfGu4upPcyRI@fedora>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <abludfGu4upPcyRI@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 57553100011
X-Stat-Signature: ygrdp6qftsomtwzt446sh55gr38oyqoa
X-Rspam-User: 
X-HE-Tag: 1773821867-37158
X-HE-Meta: U2FsdGVkX19O9OSzBS3vOmxgfaqpRSb3ADyYKnSijLzBjpuuE7Goyha6+C/YeZwIBtUcsC0MWt6pkbTjy7NAfZci62eRAShlLUQYIoSO9a4AgK+Yzd2yLCf/iuTMuUkz+1vqugfhwgQ9VlzU6ZSSKpzffjg0CMrbL9CW/k5b7xBabIV17gOlUW7SjcgWi3zInLy8ER7FWoOFgQsXGBv8FfhIed6Ah3SpLmgv29ggtw5rdRZu+FmkxGdXVk09xaWQ6JjURqsjJI63pk4zQ9UWG9b806nK05nXGZ8TX0OeBDIskgg6GU6e0/E0WQnYl0ZkKGT5/gdQdSKnbJRYv5hQRwVCNydgj/+0kgb87n2zajpBmRdsswSoUByTy7U5uiGRNxvYkLX6vhAUi2v1SI2hIsyu3hCBUKN6mGOb4PvE2E8g6UEEb1AcuJOVFerI8aQb5jZsfDJkX6254GRNqyH+2lglqcb7pfv7YvEB89v9B8KxEXXJESf8hOWkjvFQp5TMSAVAPZ21Xy379//F/kKQzjMR4DaSn/LpFmN4oQ8pMw7k0inKdp79b4yh2U5AnWHOWUC6RnMGNO2gDRruGVyfy4QqTEATTXGcUcGZ5DBVXHXOAozGo8Kr7BscW6w2ALlQO+BBEp63uYNzLO8N0U7p1GsYeHe1W1MvcmUDTuemi9SyuHKBXueWh13ynvxINrIJ/kTSl2/wVbnxN6FXJOMES/yk+g+lCriC9ravEw5HXiylDc/nLJx+Sm46/WbB+0uA5N3WfK5bnCzIGShiDxnEBYIHlN8ygmAbdRWKHYvZVw/vXIj8lBX4XRdssL/XFriNXcrfoK+tQuhD4KkP4uv7CFvooTRfFzdPIXXbEzSkEkkSVfzwZ+rQAOkuGmxIIdl9EBzOjRH+XEUUVEl6Vg22H/98c7SPk6b4BVHMkepI7phMfn49R/3ycF3e597hdOpBMMw+reKAvrKUS6xDhJh
 7wdUQof3
 yPlcOiA4NT2ch1Wjg0keZBh+ECI0cO/zRZHKfqKRrO1Ez7yavCR00ifC6pTHutTkPUGDoM5mV3SRDTmgvPlXD8iafu1QRIDUE2rf7XQBTI9cVjvttRoRQSbOJUWS5TECpQcw9a1nYkALnFMh5+ZUbdUBv/zY/o09DFCIFPy8mL3sF35fFYlASbTEdXYJtEPb8xjj0EJt1sr2TF5K16Sb6Z+zKyp4wpeFfijnPPhTpTnl9yMI6VWw4V0h4Sgf/ikFKOkvZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/17/26 16:08, Audra Mitchell wrote:
> Sorry! I missed this email so never responded!
> 
> On Tue, Feb 24, 2026 at 05:15:14PM +0100, David Hildenbrand (Arm) wrote:
>> On 2/18/26 19:42, Audra Mitchell wrote:
>>> On architectures with separate user address space, such as s390 or
>>> those without an MMU, the call to __access_ok will return true.
>>
>> Where is this __access_ok() you mention here? Somewhere in
>> fs/proc/task_mmu.c?
>>
>> Where in the soft-dirty test is that triggered?
>>
>> I'm wondering whether the soft-dirty test should be adjusted, but I did
>> not yet understand from where this behavior is triggered.
> 
> The problem arises when we are checking to see what features/categories are
> supported. The call chain for the soft-dirty program goes:
> 
>   main()
>     ->test_simple()
>       ->pagemap_is_softdirty()
>         ->page_entry_is()
>           ->pagemap_scan_supported()
>             ->__pagemap_scan_get_categories()
>               ->ioctl()
>   
> We enter the kernel with an ioctl, expecting to have an EFAULT returned (see
> the comment from pagemap_scan_get_categories():
>     
>           /* Provide an invalid address in order to trigger EFAULT. */
>         ret = __pagemap_scan_get_categories(fd, start, (struct page_region *) ~0UL);
> 
> Once we enter the kernel, we will check the arguments passed which includes the
> call to access_ok: 
> 
>   do_pagemap_cmd()
>     ->do_pagemap_scan()
>       ->pagemap_scan_get_args()
>         ->access_ok()
> 
> Here is the path within pagemap_scan_get_args where we expect to fail return
> the EFAULT:
> 
>         if (arg->vec && !access_ok((void __user *)(long)arg->vec,
>                                    size_mul(arg->vec_len, sizeof(struct page_region))))
>                 return -EFAULT;
>                 
> However, if CONFIG_ALTERNATE_USER_ADDRESS_SPACE is enabled or if CONFIG_MMU is
> NOT enabled, then we just return true:
> 
>         if (IS_ENABLED(CONFIG_ALTERNATE_USER_ADDRESS_SPACE) ||
>             !IS_ENABLED(CONFIG_MMU))
>                 return true;
> 
> The intent appears to be just getting the categories available to us and
> verifying that we have the feature available for testing. However, this corner
> case means the soft-dirty test will fail with the following:
> 

Thanks for the information, we should clarify that in the patch description.

>   # --------------------
>   # running ./soft-dirty
>   # --------------------
>   # TAP version 13
>   # 1..15
>   # Bail out! PAGEMAP_SCAN succeeded unexpectedly
>   # # Totals: pass:0 fail:0 xfail:0 xpass:0 skip:0 error:0
>   # [FAIL]
>   not ok 1 soft-dirty # exit=1
>   # SUMMARY: PASS=0 SKIP=0 FAIL=1
>   1..1
>   
> Since the intent is just to validate that the features are available to us for
> testing, I think we can just modify the check so that we don't fail if we
> return 0.
>   
> Let me know what you think, or if you have more questions!

What about simply testing for success on a test area, wouldn't that be more reliable
and clearer?

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index a6d4ff7dfdc0..489a8d4d915d 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -67,21 +67,26 @@ static uint64_t pagemap_scan_get_categories(int fd, char *start)
 }
 
 /* `start` is any valid address. */
-static bool pagemap_scan_supported(int fd, char *start)
+static bool pagemap_scan_supported(int fd)
 {
+	const size_t pagesize = getpagesize();
 	static int supported = -1;
-	int ret;
+	struct page_region r;
+	void *test_area;
 
 	if (supported != -1)
 		return supported;
 
-	/* Provide an invalid address in order to trigger EFAULT. */
-	ret = __pagemap_scan_get_categories(fd, start, (struct page_region *) ~0UL);
-	if (ret == 0)
-		ksft_exit_fail_msg("PAGEMAP_SCAN succeeded unexpectedly\n");
-
-	supported = errno == EFAULT;
-
+	test_area = mmap(0, pagesize, PROT_READ | PROT_WRITE,
+		    MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
+	if (test_area == MAP_FAILED) {
+		ksft_print_msg("WARN: mmap() failed: %s\n", strerror(errno));
+		supported = 0;
+	} else {
+		supported = __pagemap_scan_get_categories(fd, test_area, &r) >= 0;
+		ksft_print_msg("errno: %d\n", errno);
+		munmap(test_area, pagesize);
+	}
 	return supported;
 }
 
@@ -90,7 +95,7 @@ static bool page_entry_is(int fd, char *start, char *desc,
 {
 	bool m = pagemap_get_entry(fd, start) & pagemap_flags;
 
-	if (pagemap_scan_supported(fd, start)) {
+	if (pagemap_scan_supported(fd)) {
 		bool s = pagemap_scan_get_categories(fd, start) & pagescan_flags;
 
 		if (m == s)
-- 
2.43.0


> 
>> Do we have a Fixes: tag?
> 
> I always hesistate to add a Fixes tag on situations like this since this is a
> corner case that was not considered by the original author. If we need a
> fixes tag, then it would be:
> 
> Fixes: 600bca580579 ("selftests/mm: check that PAGEMAP_SCAN returns correct categories")

Yes, please add that. We nowadays also add proper Fixes tags for tests.

-- 
Cheers,

David

