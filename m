Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD81C606A332
	for <linux-mm@archiver.kernel.org>; Sun, 22 Nov 2026 15:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=ryjLIK6w
Received: by kanga.kvack.org (Postfix)
	id C724C6B05C4; Sun, 22 Nov 2026 10:55:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C21946B05C7; Sun, 22 Nov 2026 10:55:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B133E6B05C8; Sun, 22 Nov 2026 10:55:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 77C5D6B05C4
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 10:55:20 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6192EA838A
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:55:17 +0000 (UTC)
X-FDA: 85463204274.09.1DB8EBE
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7E6EC4000D
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 15:55:15 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ryjLIK6w;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795362915;
	b=Iu+rY90W0DOFBiqGtlGkGxcHVzYJMaxdFAGZEUIjIWKinoxyaJrulYuNNCOisrFzf/0k8f
	0gtkNkRqlP70P7hRP1j1+DLNCcht5Q4JeVs6c+kvPj0HTwWfFpVc6I+JPMegpMbCKxzL3V
	2Xk0yzEdtPgM+mbBWH6PqA/K7Dv4Oos=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795362915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+uDV1lXj3AvoHsrklYuKinbzjoCQBGsYSjr36ZrsvEY=;
	b=aqilognP9nPgIVwrTE1hzPaDs7tTpEXGx9/O82egsjaLGGJv+Gv4rMjppSnv/QwVfTc4tC
	NODRdXW/4fOuMjWBAjKwgHHejS6rMfLQ62WUwsu84ifty7H7t46982V2y1wzSQp9ivV/24
	Tr41Y0pOIJHDAZTfmBQixQSjgOdIDz0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ryjLIK6w;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.174 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93f20b304c0so250421885a.3
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 07:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1795362915; x=1795967715; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=+uDV1lXj3AvoHsrklYuKinbzjoCQBGsYSjr36ZrsvEY=;
        b=ryjLIK6wusKPyAszGkciZzBai5UcKicN05LkXm3Ef3IoPdj2KMBvu0rbjYANqwwdSk
         8LWLBiLWlmOLahg4h0bD1JF2FbSr/ymHNLzLcB4of0uTn/y8Skh280erIg+g1Mx5frIV
         kmuBLASFAx9LIm4Om7lyqxFRDRMV/a/ghc/KP317D2EJBbSZG3Ky2n//z/d3q5a/p1qm
         90XYkLiMd8OZ6sHgSwuDPYbQjdNxvHNVs81qNafS03J7lY9MPufCUbh0F3Tbyd+Nwo8c
         X9EXoYGdgmdOoz/3nJJACbIeuAqJzbGUNZrcET823a73W+D5YF0pJFqeSEYxr9uaOBcn
         eISg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795362915; x=1795967715;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+uDV1lXj3AvoHsrklYuKinbzjoCQBGsYSjr36ZrsvEY=;
        b=UvIoctMrxNtQWpbcpQYb99/jSAjKXPg7xTqZy8POLNMUzMuZ2jI8OpcWLxoYDRyu8d
         uF1Sr10h4w8imTNRr8XlwJah1lkqRG8u6whQO21iINjihmSUHj7p3f7ezRjdPbIoDtpQ
         T+FZE/0HYxpprAyeUeuVxxAaODiPV/ioloKl5zZTYCVdFsMcctonwBnnUICv9Xhh9HQT
         iPyzLEqVvWFStKQEDtZ9gn5+EDhV6CuF0DsTDGWkTkLEz8cnkOjguI26L3Jbmc7RvwSH
         35Z3e8jRt99IDHcS8/BzB4puPneb7ZP38jdYe/9kk5OEekLZFWzaG9FUtiitVMXbU8sL
         T7CQ==
X-Forwarded-Encrypted: i=1; AL+hErEOBTbionkeyCNEccAyRYkjZOWE7nCHca2gT15dcaNHrHwGmLqCXFd69/q0Q9Mq9dxKIeMGFCOj9A==@kvack.org
X-Gm-Message-State: APuU4Z+cK2EhC3i0Av943ndsg81stSpiEyj0CndoV+UecNA5EQiQ1zgd
	3NOXAw0mnA+MVB00l6o0VlmvGkBvtFUGLacC9CGsuHZXfqGsvyZF2TDFLRQJQm63uAE=
X-Gm-Gg: AZFdTZf7BAgpaFMRp4RGIIa1vwyvswKtXcE5lFdAi/kRLlFq5xsfDLyeDn/juW3G0/O
	8sVKWlPwFta335ACCIBy7C/6Fcb06peHc7w+WF3Sc+8ltDMxkTva7/uDjn/FT4ZI7UzGRdDRjyg
	wRs1zihoY0bhOWPg0zR01Zjzsj+SFpTt3eNiBoIUKJOlYUcVeLWrMEUgcuW33F63Rctulbkl8q2
	f61FSBacivNTPyjwqKRZqIardhkoTxk7AtCp3xcdLYM9hvf4esdezna/Mhc8CdLV7ufPxhKlMFo
	fu2sU2yERhxvGEUL2OMyI87k0tK3hyzdP+oHFh6tu35VxkGu2ag7piEhz2unUuJdbF2iCOjgGPH
	uaYR6pkv39Jias2+cN0BKR3WzeHqQ7Dzu0U7bOn7sB8iWzU3ME4lS/9LA85edgCyJ1Up2S5tn6p
	i0wRwz+0r9mHzQC844s8scelEon+fCLd5QlcRrmukbtIKhZrocSgzZ6MkTMFafzGL2gfFX/cO1d
	1/09yrE4Sv7I2wON95Rx8vW5tXj2t2IPjlvjn5Bo6DTwOy7PG3wZFsU+FxldYFwbll2FOMuE24G
	FERFJaAAOZgwXv/qtUNyLYlL6ATmNytZmj7rhCT7tyx3wkGku5bOvNmdQdpb2eWxc/kvQdwjFLA
	Xivh7lv6++/i2GNNIGOKEKjjqIpn0UA==
X-Received: by 2002:a05:620a:40c2:b0:949:5db7:b32a with SMTP id af79cd13be357-949ba9be85fmr1561480885a.43.1795362914014;
        Sun, 22 Nov 2026 07:55:14 -0800 (PST)
Received: from [192.168.50.231] (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb3c2abesm622434985a.26.2026.11.22.07.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Nov 2026 07:55:13 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/7] mm/vma: error out on invalid bounds in
 unmapped_area_topdown()
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, 
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, linux-mm@kvack.org, 
 Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
 stable@vger.kernel.org
In-Reply-To: <20261121-some-more-ai-fixes-v1-1-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
 <20261121-some-more-ai-fixes-v1-1-236e925d9b64@kernel.org>
Date: Sun, 22 Nov 2026 10:55:12 -0500
Message-Id: <179536291280.412063.6169498898856535364.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Stat-Signature: 7qaccjnndyocxhq5puknx447azh7r5et
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7E6EC4000D
X-HE-Tag: 1795362915-120904
X-HE-Meta: U2FsdGVkX1+HEEwqYNO+CUjKMOMGpJGU3k9fKogCnzZdzK54zOeMern51U160ySuYEpowc9qRZ2Qup3R0jYL6cPi9DKsUE88oohAWkV94F80pacO/XSBSxtnltzfNShmOVnh0iYs7oWw+mG3SLZfY99Qn9q7qaY/qGPaOvlbbXqb4rbnquRXSKU79BOx5Z8iBcN6mBzbc1T2iJERF2MksZRwnc0UhBj0lNXu5j87e+rL1Sy2SDEFR3+GaJxEhKK+bRqxSJH4yFpWy5PRw+Qdp7xL/Bp9SiiYRbCAkxhKJSxyV2CpAH9YMRhrKnrWOdcFgzR3bxQ3iyg/i6oyV9+ze/cX0xss5Fi8pSsbJN/IxnOaMxAokwvgWjckWZVuod5Gf8yasn/MPgL76Or4YFOcO8UgIBEwa4RX7pGsoG+UU5Tm+YdBwX6nxDV+NISnXuJRkpO8WG1Z5YyQiDCV8gbD+V+w+oX4fw7/viqsOoVAnf1hD0pmROLeXmguM4uOCBGHkCQFBEXFDjimpj+LtCcaq/7zGCuh5Rq2JVbYMefZ0emh16zyv5BEEVYcyjkSqU8UmMvf37Oz6n2qHRyWF7R238s7+4yaKvNdO0ju+CdBJGWciAiysUyhxS61Qcx48M/MQy07Eqm7deHON4qMp/8NJpumDPhBUAiAeTk3pjOmZhVZ6rmy6CmNuYwDh4OLnQ70/GIZJqHIlNeew09WTUgRO3bV3LTixuHsLalDu8yN6TT6pGyj7rJYdlniVK0T03sAhveuikN83MZOKvbosIMeSrNRW//aU10ixtmUGyZ1pSF9lCZ5A9SoPQj9wfCLuY+Lc3LwfSg2oX8CR3Mpqcm0oAtYdw3hf68yBlxhQMBtpDwE5rU9/Wkzeh/1B7ZOfAKrGLM216XkuprLFZvAXs8/h2n/eNMpBVgFo/DIfCYJxOz/BVP/thtwo3qZ9OcTpBOcWkouXxd9kPPisy+Q39l
 j25WEWg6
 GpueeDCR+sHYsqW/6JFNxYGPftIlDKTLTPb44YdRvOBtWDqY4R2x7rMChOwueamgJPIVVaYINQMeJAnNHbslYCDyYtqE+b1ZkMm/VZBw8WnOjHmF5yxbRCFFiNlEeX+cyqTNxTRxpphFWRggv4Awy0vLRCCTYbqVcNw7VOQymNDOCyJfGZQhC4rUlCox38UnlKmS/OVL2hsM36UYdsV++fjk6Lrhh9tkSGgJJYyeG3sqQS9GUIybqW+3E4jZ67r1OBtc8cvaxR2jvpNHk8cPwox3eCLIX11hmF7P1OsHj452wNwuvMCVEBrKb172Jza8QCjLniqjyhvz4DO02sM6bSog6ewk1BID7BWt7mGY2qnxsOiHlMwHtqTmQE5NGJ62xoSRAC3MuiXdWRYSCpe4jUCqmEJ++md94+qWXpDvc7qh7sPn7kI83t7Ni76Btu0zKaiXDpGri0esZNLFjRQEPZA5wFgbj4XhsSXzVJorR7dqnYUjgz0ud4BZM6uo0zDhUF/yUPn+6jbA9AI4zFP5ZDO3lKX9DUCOecImxxc6SlURWmlWZ3H7Ywel2aJNhzb9b1Apj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-21 16:02 +0000, Lorenzo Stoakes (ARM) wrote:
> unmapped_area_topdown() suffers from a class of bug arising from a mismatch
> between how maple tree functions and VMA iterator functions express ranges
> - the former inclusively, the latter exclusively.
> 
> This is problematic with an exclusive upper bound of 0, as it translates
> to an inclusive upper bound of ULONG_MAX, that is a range which extends to
> the end of the address space, and start < end or equivalent comparisons
> evaluate false in a situation where in fact the expression should evaluate
> true.
> 
> unmapped_area_topdown() calls vma_iter_area_highest() to position the VMA
> iterator into the next highest empty range spanning [low_limit,
> high_limit), iteratively reducing high_limit without checking whether it
> has reached 0.
> 
> This can result in a [low_limit, 0) pair being passed to
> vma_iter_area_highest() and thus unexpected underflow. Consider:
> 
>     vm_start        = 0x30000
>     stack_guard_gap = 0x100000
>     info->length    = 0x1000
>     high_limit      = vm_start_gap() = 0
>     high_limit - 1  = ULONG_MAX
>     window          = [low_limit, ULONG_MAX]
>     vma_iter_end()  = ULONG_MAX + 1 = 0
>     gap             = 0 - info->length = 0xfffffffffffff000
> 
> The result is page aligned and below the IS_ERR_VALUE() range, so it
> does not look like an error. What follows depends on the caller:
> 
>  - mmap() with no hint can fail with -ENOMEM while space is free. The
>    bottom-up fallback is skipped, and __get_unmapped_area() refuses the
>    address as above TASK_SIZE.
>  - On x86-64, find_nearest_trampoline() can pick the address for the
>    uprobe trampoline. _install_special_mapping() then inserts a VMA
>    whose vm_end is 0, and exit_mmap() frees kernel page tables that
>    every mm shares.
>  - On powerpc64 with the hash MMU, slice_get_unmapped_area() can pass
>    the address to alloc_extended_context(), which then writes out of
>    bounds of mm->context.extended_id[].
> 
> mmap() can succeed with an address from the wrapped window where the
> range above TASK_SIZE is too short for the request and its alignment
> padding. On s390 that range is one page, so this takes no more than the
> default stack_guard_gap.
> 
> Fix the issue by converting the loop into one that explicitly tests
> low_limit < high_limit.
> 
> Additionally, simplify the logic by declaring the VMA iterator in the
> loop (it is reset on each iteration anyway) and exiting with the correct
> output value on success rather than performing a goto when an iteration is
> required.
> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: 58c5d0d6d522 ("mm/mmap: regression fix for unmapped_area{_topdown}")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


