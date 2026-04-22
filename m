Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E255AF9EDC9
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 13:21:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05CC86B0088; Wed, 22 Apr 2026 09:21:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00DB26B008A; Wed, 22 Apr 2026 09:21:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6C096B008C; Wed, 22 Apr 2026 09:21:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D5B286B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 09:21:39 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 602FC1601B6
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 13:21:39 +0000 (UTC)
X-FDA: 84686253918.05.530CEC2
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6B68410000A
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 13:21:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JYqwc4in;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776864097; a=rsa-sha256;
	cv=none;
	b=DditTm2mp7ZhtQ7r3gYmK6szuoyLtep7rVIsIVdNxy70cXRPqksj4hYzmK70YWQCVksBiK
	Lbg2vVudWbFrfcFyEZiVDOaFZEed1GV7fUtGVUUyNOD74XBE0E8sND91cOovLFOT8qfcCc
	ksTsDkosjPkOe0gqQEfCYuG62FJZaxs=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=JYqwc4in;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf05.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776864097;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HtfU7kcxqI72jMjDfOUY/EtxokO0MhMlb2SDKp/eX0k=;
	b=ccYJedpcl0oBmtYnyHG6WLVy+2orxOWPiM/5K83ofnS3wbn6eZuv6VrDkgyf3IdmTSrLbn
	KI8KDMoe09PTtawVDFpwwNhlclS9wRw62VwRaqZ9Z6T3XZpOlgr1U1anFXjLnC3RaQMsiU
	68hVFeAO+azkOVU1WREpK6bHW+sD/+0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B5DA22D9;
	Wed, 22 Apr 2026 06:21:30 -0700 (PDT)
Received: from [10.57.89.34] (unknown [10.57.89.34])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E8873FD46;
	Wed, 22 Apr 2026 06:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776864096; bh=SUhegrWOX2svV6mP7JpNfDMarrvi6LsYsdK7yk17+VU=;
	h=Date:From:Subject:To:References:In-Reply-To:From;
	b=JYqwc4inV6mHPq9hN6YI3+EkaNg0zntDPZFli+fquHEtjJdrWF/oJ5zhx8l8amFZt
	 75lBDJU26hCuf55I0FuvZTs90Wt0Z76/DiSrzpQgsEu2PvtFoTrgN5ba58f1cvF76i
	 /OPYInSuiknn1QL1DIDErtNh4sFAgF1KfVoDDCYk=
Message-ID: <727df89e-2069-4a7d-b3c0-88f89cd3dcf8@arm.com>
Date: Wed, 22 Apr 2026 14:21:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v2 1/3] vmalloc: add __GFP_SKIP_KASAN support
To: Muhammad Usama Anjum <usama.anjum@arm.com>, Arnd Bergmann
 <arnd@arndb.de>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrey Konovalov <andreyknvl@gmail.com>, Marco Elver <elver@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 david.hildenbrand@arm.com
References: <20260324132631.482520-1-usama.anjum@arm.com>
 <20260324132631.482520-2-usama.anjum@arm.com>
Content-Language: en-GB
In-Reply-To: <20260324132631.482520-2-usama.anjum@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: x86w4hbw8sy3o9hnyjcppps4o8orkjt4
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B68410000A
X-HE-Tag: 1776864097-543312
X-HE-Meta: U2FsdGVkX1/Gl2kG+vWe9/Id3CfyGvL2PC6jcg2JSmF5pUL9Hn0YieMF2IgYIPbG28hKQBenx2USEx9pLxignKB9R5X5JVY94A9FvpWWUFt32urGkhNL18QZutC4LTEKKyEgG5ieqDMnctsAxmhwZrCLe0K/igXjtQRxFhS2ew+7z3+ZVpzX41OjEnCDj1TQemXIHNjVlPWhlkBgwgY3v4AS1d1vAQORf8p8lFi+550qDfHEB8rZSf6YTWBcslvxlkrk/XirqcDtIrVqoU6xQuFAVApVEbKTMi3FP6DEtMdOD8/522dJwyUY3plUgKQKSkv0QuC98qDjdn0AnqmcF0AooRDmVe2MccSdjFJKTAmdKYN1+bygrfS9i0TRS9X2oKCejBvVtr1nIhdid9KISMEcEdsAtNpRvBsDBuCMBOHWJFwJRhTBDw5NPIsWlXrDg6+G5mpvLwwfHwheq4GCxz/jjNDbSQ1yY4Ty+JHJRwz5FW+jLSk+Z8mkj6QMierr8KW5YdWsXk7/YmQHeC0kDViL1X4+KVx58umCQPYHk3L4oQhF2k22VzAGoiIOAQ8GS6tzIKmcw3fau8ZE+oRE8VG/Fz5MfRdmrC4J+jN/giP/Uc/8J/axbcQspvGkaI/fOe8YO3zEtdCxYA4Ji0djqyyXKpborngpjt0gDLS00/k4hjRMtRaXh8I/0UOlBYHUJYyrLGGkPMwxljdGWXxjgpgrcqN1mosY+7AugI5hQ3zTMmQ8HzITykWPTX5ieFqkY2OJf+ZQ0CSDbxG2468V7a0Cje0+cevx8PiB9Kz1uMTUYbfySOdDRPWF3gG53L9nlIc9U9U6r0EeDCrPt9XL9kJ6X/xxRMh9Lwe93YagMfHbX3aWZ6r+8JI6kb2mngdQQIkCtHtQKE/NDy9z3Ymw3qBw1oWLQdCjPpB0DnBowLV6HjXECY4uQIUKsG/Sz1SD5pWn7ltmQ7b3x9uz/4p
 YVndV3d7
 q5Rmeb2xfFxCb3x2h8srpc6YQRxXgtCHlB1NwgnVImLXNdNWGSQ15Tv7Xak+TKoahk75LMraivHlXSp3OEUpF4o0LXz6tUHznH2m7TPYgXJgsk2EY19i/KZmvUN7nk2xj8JSrjaN5QskvqeoswlNR+S6LealkyZUigxneyNoJ4x9dnO3XHScqN51nL3iLJVfma1kRiqNjBcr0/JifJPt15O9vAnOO58oZuNHtKR48pVEaWW1pgZt9Te+fGjrnvIQ3hGZilHzwlfz4JMkPyGqW0KFtw3nt5yH7E7LnwPeynq94yfhAf4WLkCAQyGVhFvQTISPiRyO0nzCXgbqIYusKkz9zveMTkjU0J9QqeKXCLb90hzc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24/03/2026 13:26, Muhammad Usama Anjum wrote:
> For allocations that will be accessed only with match-all pointers
> (e.g., kernel stacks), setting tags is wasted work. If the caller
> already set __GFP_SKIP_KASAN, don’t skip zeroing the pages and
> don’t set KASAN_VMALLOC_PROT_NORMAL so kasan_unpoison_vmalloc()
> returns early without tagging.
> 
> Before this patch, __GFP_SKIP_KASAN wasn't being used with vmalloc
> APIs. So it wasn't being checked. Now its being checked and acted
> upon. Other KASAN modes are unchanged because __GFP_SKIP_KASAN isn't
> defined there.
> 
> This is a preparatory patch for optimizing kernel stack allocations.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
> Changes since v1:
> - Simplify skip conditions based on the fact that __GFP_SKIP_KASAN
>   is zero in non-hw-tags mode.
> - Add __GFP_SKIP_KASAN to GFP_VMALLOC_SUPPORTED list of flags
> ---
>  mm/vmalloc.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index c607307c657a6..69ae205effb46 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3939,7 +3939,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  				__GFP_NOFAIL | __GFP_ZERO |\
>  				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
>  				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
> -				GFP_USER | __GFP_NOLOCKDEP)
> +				GFP_USER | __GFP_NOLOCKDEP | __GFP_SKIP_KASAN)
>  
>  static gfp_t vmalloc_fix_flags(gfp_t flags)
>  {
> @@ -3980,6 +3980,8 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
>   *
>   * %__GFP_NOWARN can be used to suppress failure messages.
>   *
> + * %__GFP_SKIP_KASAN can be used to skip poisoning

You mean skip *un*poisoning, I think? But you would only want this to apply to
the actaul pages mapped by vmalloc. You wouldn't want to skip unpoisoning for
any allocated meta data; I think that is currently possible since the gfp_flags
that are passed into __vmalloc_node_range_noprof() are passed down to
__get_vm_area_node() unmdified. You probably want to explicitly ensure
__GFP_SKIP_KASAN is clear for that internal call?

> + *
>   * Can not be called from interrupt nor NMI contexts.
>   * Return: the address of the area or %NULL on failure
>   */
> @@ -4041,7 +4043,9 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>  	 * kasan_unpoison_vmalloc().
>  	 */
>  	if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL)) {
> -		if (kasan_hw_tags_enabled()) {
> +		bool skip_kasan = gfp_mask & __GFP_SKIP_KASAN;
> +
> +		if (kasan_hw_tags_enabled() && !skip_kasan) {
>  			/*
>  			 * Modify protection bits to allow tagging.
>  			 * This must be done before mapping.
> @@ -4057,7 +4061,8 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>  		}
>  
>  		/* Take note that the mapping is PAGE_KERNEL. */
> -		kasan_flags |= KASAN_VMALLOC_PROT_NORMAL;
> +		if (!skip_kasan)
> +			kasan_flags |= KASAN_VMALLOC_PROT_NORMAL;

It's pretty ugly to use the absence of this flag to rely on
kasan_unpoison_vmalloc() not unpoisoning. Perhaps it is preferable to just not
call kasan_unpoison_vmalloc() for the skip_kasan case?

>  	}
>  
>  	/* Allocate physical pages and map them into vmalloc space. */

Perhaps something like this would work:

---8<---
diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c31a8615a8328..c340db141df57 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3979,6 +3979,8 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
  * under moderate memory pressure.
  *
  * %__GFP_NOWARN can be used to suppress failure messages.
+
+ * %__GFP_SKIP_KASAN skip unpoisoning of mapped pages (when prot=PAGE_KERNEL).
  *
  * Can not be called from interrupt nor NMI contexts.
  * Return: the address of the area or %NULL on failure
@@ -3993,6 +3995,9 @@ void *__vmalloc_node_range_noprof(unsigned long size,
unsigned long align,
 	kasan_vmalloc_flags_t kasan_flags = KASAN_VMALLOC_NONE;
 	unsigned long original_align = align;
 	unsigned int shift = PAGE_SHIFT;
+	bool skip_kasan = gfp_mask & __GFP_SKIP_KASAN;
+
+	gfp_mask &= ~__GFP_SKIP_KASAN;
  	if (WARN_ON_ONCE(!size))
 		return NULL;
@@ -4041,7 +4046,7 @@ void *__vmalloc_node_range_noprof(unsigned long size,
unsigned long align,
 	 * kasan_unpoison_vmalloc().
 	 */
 	if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL)) {
-		if (kasan_hw_tags_enabled()) {
+		if (kasan_hw_tags_enabled() && !skip_kasan) {
 			/*
 			 * Modify protection bits to allow tagging.
 			 * This must be done before mapping.
@@ -4054,6 +4059,12 @@ void *__vmalloc_node_range_noprof(unsigned long size,
unsigned long align,
 			 * poisoned and zeroed by kasan_unpoison_vmalloc().
 			 */
 			gfp_mask |= __GFP_SKIP_KASAN | __GFP_SKIP_ZERO;
+		} else if (skip_kasan) {
+			/*
+			 * Skip page_alloc unpoisoning physical pages backing
+			 * VM_ALLOC mapping, as requested by caller.
+			 */
+			gfp_mask |= __GFP_SKIP_KASAN;
 		}
  		/* Take note that the mapping is PAGE_KERNEL. */
@@ -4078,7 +4089,8 @@ void *__vmalloc_node_range_noprof(unsigned long size,
unsigned long align,
 	    (gfp_mask & __GFP_SKIP_ZERO))
 		kasan_flags |= KASAN_VMALLOC_INIT;
 	/* KASAN_VMALLOC_PROT_NORMAL already set if required. */
-	area->addr = kasan_unpoison_vmalloc(area->addr, size, kasan_flags);
+	if (!skip_kasan)
+		area->addr = kasan_unpoison_vmalloc(area->addr, size, kasan_flags);
  	/*
 	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED

---8<---

Thanks,
Ryan


