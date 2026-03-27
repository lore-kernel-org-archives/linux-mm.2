Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5D1210F284F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:57:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 137C86B0096; Fri, 27 Mar 2026 12:57:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 110046B0098; Fri, 27 Mar 2026 12:57:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 025566B0099; Fri, 27 Mar 2026 12:57:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E93E36B0096
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:57:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9B10D1A0E1F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:57:13 +0000 (UTC)
X-FDA: 84592448346.21.C116B2C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 0E3B31C0010
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:57:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RJCM2Xe/";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774630632;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U+NKjS4Ygopo+eznbt3xIwvVeoqDIpJpuPx2yOdJJhg=;
	b=Xrv4LZO2e5R7vG5HCbs2AYhjnj79WuaBt+g785wq8+qItv7pgeSceFZlLGvBrHpC0p2xYP
	Ds12an/hruEBvy9gYQ+tj1Wd91kN6hiT8GFXJRgTTizZTYF++13Jqoq53+wOpqJ2YdB7oT
	2e+87IYZbCN7YL/doFx2Mx+f/9CWNo8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="RJCM2Xe/";
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774630632; a=rsa-sha256;
	cv=none;
	b=8ENwWazZbntElRylIrZXu1KdI4ZN9zPiRX6tMWkdmtoKKCNEhBDWC9KDAM7YiPI5oWduwG
	BEp9Io+ix0QjKWxVQ9Vn3gc8NhE+881OGn7A5/zM+8LWQ1zaNtWbz0tLJ5vippKyymMoku
	h8rIfqYOo72VxbZPymSSV7RMwOw+SoQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5393660054;
	Fri, 27 Mar 2026 16:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D690C19423;
	Fri, 27 Mar 2026 16:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774630631;
	bh=tewTlAfQ3NfyHAyVP63RBnCHjQJ2G7MM/v5u44/+dyE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RJCM2Xe/t/XgpG0euJgwFM7ipgJImehlk5+JXxy8aawzPm/LoeWOdY+G7jDNAgr2X
	 W/PnqgH1fHpwBjKamHpBh3sRAGFf+cGgRBts7jsbgLtE+SpV8VW8ZrvgQajJPSbiPZ
	 jjsgOXt9qCB/sh60a2NpoD7H/PoR+MnsOCEJE4Be+KnLDF6AweXA+BOyct0lk+LhpH
	 0YXHkg+b10uPpuskyXTkoLEEtTVRxkJZT+8/WNquBNW5T64q2ceqfS26oXZmedj1sp
	 rZetRkX/sDC3pKYjvFlp8no4VpqLzGPUa9JpHhmYMTnwigAFUMhgg37Of1vfVYu09T
	 5YYOgJl80STSg==
Message-ID: <d82c61ed-32ba-47ed-bb85-9facdee7c26f@kernel.org>
Date: Fri, 27 Mar 2026 17:57:06 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes] mm/mseal: update VMA end correctly on merge
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Jeff Xu <jeffxu@chromium.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 antonius <bluedragonsec2023@gmail.com>
References: <20260327090640.146308-1-ljs@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260327090640.146308-1-ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: wrf54x9rkyn8hda8jq9mkdk4rtmuuegr
X-Rspamd-Queue-Id: 0E3B31C0010
X-Rspamd-Server: rspam09
X-HE-Tag: 1774630631-456094
X-HE-Meta: U2FsdGVkX18Z+YTMNcP8pbKqb4I5yo3rZ1Y6uiAUIPdNuBGPpEEewDF4AGzTq7HIkLkVtLo5HtzsftNJR1bL7HkGojHoUWy3qWAF2aWnSfsJPunxmDVjyMdxYwDki+s/mB5iGz16Ii5DWSC3YJ4W1y7iKzSXDhYVqi2+/9rzs/UieopEoh2SwAbObcXpJd23HOY4qQW+s7dZiwUuLSaCz5KnwlyY4YjlDqoTVHnQNW9bcQRT3iY7OIeQQlCAlvFXTRW3LTHLUaMg03lSpMvnnIKd4hQCjymVULQHIbCSf0EKO6PyNgpbXKRYH/P8H/vBtUfSVlbkmVJIVEkufrVfpwbLkxh+gO0rWUB7DPXeOqyYG9FeEY7AYoEA0kkQ+Tfz43P0B0bP1EIA58mvqEzz8LOF75H52OQge7MgrLzQiIl5l9D4Y38XuHUml0SzjRb8xHvDhfQeU48FDcaV589bDyifd0kpGFnAW1HxOBMK+7rHdb1G8HqYggfO8NYzDVidE5wGU/CG4H2Zx975N7yWTo/rn/MZ+WH+Szy7WnVczmN0bgjZji1m8kjc3/zO41/DahKs4HmXewo1r3Q2ReVdxf3xKy1XQUSH+DWw3g+0Qbx6S/dAGzUyQlJoZKx4afUhS2dcwF14g855u4ZNeIqOgBfhrHa5sY57/SL0MRsaljaBnyjE25xQ2PZ+Yj0Mo6MxvWqfV9fYBPTscDQ1VRTWRBrt2fvhwotLpl2/5CZ+7Yq6+0tip8/Ys2ZncG3YKJbosbjygCDGQ2Uua71OaHnCFOi6SlNiksMc1j4ARux7VM1LRrbX2ti3X4VsGuDT2dy9d0f7CV+SVdhAnxLsk75e2zxQN9404vu/xlu7w50UJU62fFY9mN+qkb5jAmYKWrflM01pF52wyGsqXOzp9RpDh94xHlJwbbW1RW5hx45bsO7AjkVjooeKRd+Ncr6BYTYyI4Bh955bSKACxLMZk3h
 90A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 10:06, Lorenzo Stoakes (Oracle) wrote:
> Previously we stored the end of the current VMA in curr_end, and then upon
> iterating to the next VMA updated curr_start to curr_end to advance to the
> next VMA.
> 
> However, this doesn't take into account the fact that a VMA might be
> updated due to a merge by vma_modify_flags(), which can result in curr_end
> being stale and thus, upon setting curr_start to curr_end, ending up with
> an incorrect curr_start on the next iteration.
> 
> Resolve the issue by setting curr_end to vma->vm_end unconditionally to
> ensure this value remains updated should this occur.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Fixes: 6c2da14ae1e0 ("mm/mseal: rework mseal apply logic")
> Cc: <stable@vger.kernel.org>
> Reported-by: Antonius <antonius@bluedragonsec.com>
> Closes: https://lore.kernel.org/linux-mm/CAK8a0jyHXqBpt8Xe8v9SNDbnRiwz7OthA8SKY=NLRY7smPEP3Q@mail.gmail.com/
> ---
>  mm/mseal.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/mseal.c b/mm/mseal.c
> index 316b5e1dec78..2d72a15d8ea1 100644
> --- a/mm/mseal.c
> +++ b/mm/mseal.c
> @@ -66,7 +66,7 @@ static int mseal_apply(struct mm_struct *mm,
>  		prev = vma;
> 
>  	for_each_vma_range(vmi, vma, end) {
> -		const unsigned long curr_end = MIN(vma->vm_end, end);
> +		unsigned long curr_end = MIN(vma->vm_end, end);
> 
>  		if (!(vma->vm_flags & VM_SEALED)) {
>  			vm_flags_t vm_flags = vma->vm_flags | VM_SEALED;
> @@ -76,6 +76,7 @@ static int mseal_apply(struct mm_struct *mm,
>  			if (IS_ERR(vma))
>  				return PTR_ERR(vma);
>  			vm_flags_set(vma, VM_SEALED);
> +			curr_end = vma->vm_end; /* Merge may have updated. */
>  		}


I was a bit confused why curr_start is allowed to not start within the VMA,
but before it. Then I recalled that range_contains_unmapped() checks for no holes.


Would the following also sort out the problem and even simplify the code?

diff --git a/mm/mseal.c b/mm/mseal.c
index 603df53ad267..e2093ae3d25c 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -56,7 +56,6 @@ static int mseal_apply(struct mm_struct *mm,
                unsigned long start, unsigned long end)
 {
        struct vm_area_struct *vma, *prev;
-       unsigned long curr_start = start;
        VMA_ITERATOR(vmi, mm, start);
 
        /* We know there are no gaps so this will be non-NULL. */
@@ -66,6 +65,7 @@ static int mseal_apply(struct mm_struct *mm,
                prev = vma;
 
        for_each_vma_range(vmi, vma, end) {
+               const unsigned long curr_start = MAX(vma->vm_start, start);
                const unsigned long curr_end = MIN(vma->vm_end, end);
 
                if (!vma_test(vma, VMA_SEALED_BIT)) {
@@ -82,7 +82,6 @@ static int mseal_apply(struct mm_struct *mm,
                }
 
                prev = vma;
-               curr_start = curr_end;
        }
 
        return 0;
diff --git a/mm/page_alloc.c b/mm/page_alloc.c


I might be wrong about that, I've been staring at the screen for too long today.


-- 
Cheers,

David

