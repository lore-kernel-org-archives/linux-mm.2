Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A81DFF8875
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 08:48:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A68D16B0092; Thu, 30 Apr 2026 04:48:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1A1C6B0093; Thu, 30 Apr 2026 04:48:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 933966B0095; Thu, 30 Apr 2026 04:48:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 80AF26B0092
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:48:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D0A71B9C3D
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:48:22 +0000 (UTC)
X-FDA: 84714595644.17.B25FED6
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf20.hostedemail.com (Postfix) with ESMTP id 85B2F1C0008
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:48:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j1F7FdeA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of hughd@google.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=hughd@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777538900;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5cpQQUFBL8l0VqMVQ4YrAMrg3HPLL942mRLvZnJiUfg=;
	b=wj4S38GIl5xqg0gWSBWH5aP5rfUCvdQiLG6X3eqk35PdrWaY2G0iOIIN1ptI399NY+iUzm
	8z03J7Ee7UpklDg9LfzCp7DsGr9LD+oH4Uryz2ijsUw+rEdBwvAJfyvIyarIf7h03broOt
	UM+AGj3/Hup8V60FNIEBvkwl5kspkOo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777538900; a=rsa-sha256;
	cv=none;
	b=iAQEUkcdCqd61lHW08tIVeWzd43vxS6YiiPwKxKYJRiFtw8uJv4BldKeIwJE5ep1oIO7Wz
	zdcZqlXHqvWs+IVIUfBr8TbMcXxOMFoDOfxTD9IkEo6Y1Yarl6XoSozlJMvXggWlT4QX1x
	EMey80mrcZv806xGjUAy5HjhCfc+0P8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=j1F7FdeA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of hughd@google.com designates 74.125.224.52 as permitted sender) smtp.mailfrom=hughd@google.com
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-651bf695701so672263d50.2
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 01:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777538899; x=1778143699; darn=kvack.org;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5cpQQUFBL8l0VqMVQ4YrAMrg3HPLL942mRLvZnJiUfg=;
        b=j1F7FdeATnrMmYCzUrZqMB1xXro26/rOfAa3H9SoWt78nRflMBEA8CHULtVZ6Jrrcn
         3WM+ayYAii/A34YilUGIFVO8vmlPk3CV+8OwM0f1JWLT8vRJgMXtbnZY8vGwjbKG6FZ6
         QRIkU6D1HPub+WRWjP30b7JE9emEIJEEbHwImcQ2NhWxfCUi0q0LDFh7UN7DUS/gV5AH
         cZ4qqSR1XiXDAWC+/junN3Yh9xn6abcVlAvgjkw/DajVMUNbR1UpsU7bXjYLSbBRKL3G
         LumynuLbSJCVOCJtpTa/PpntG0Feq7nA6572TlAunOWm8SHAYd6NahvceGQnE1u13Q1/
         4f8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777538899; x=1778143699;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5cpQQUFBL8l0VqMVQ4YrAMrg3HPLL942mRLvZnJiUfg=;
        b=eihxbXKmVwNCUOsfoapS+WeWjQ/rHRBVQfyCCwBOmCwlicE/hyYbU5H/8K1J4yb0oJ
         8JWB8GxttXGW8/aOrySSDSqZOQarWPeGF9FV1wZYyUEJxrvT6mkoxSLu3a8P8YAoQE2n
         z0e3d6CzcC9jWxdTzUj3HScg9fFdmMUSDYBVpMFBcs6iG3fIaXL1aZQZNp70m1/JVkuW
         rkyrpJr49LbFWZ+3oGsnzRPuCGfedV2r5dRwoBrMbjcSw371JJMIr+nrU+HOcihY2PdN
         GkfNb4CL3veyiJHz8if2jsAT1GAysD4ZOH8NlOjrre72YtWhxCRRgqwwUk8jccXvnwnw
         W6Yw==
X-Forwarded-Encrypted: i=1; AFNElJ9jI+puAxpGOVbN5+2nB6MKsv0ag/dhxaeJLzLZPXDoonEqQLej33kAtguykpeoxBWSIyYNbfwEZw==@kvack.org
X-Gm-Message-State: AOJu0YyOKJSoLxNQZl77eJg9ZY6u0/Gu13itTUyl80g1JDaIV6br1s4w
	0k4sZxxdiaURpofhLp/f/dWsuxXMSJOX+JEDSyFDCUoy4O3X255chFeIDLqLqlFtmA==
X-Gm-Gg: AeBDievtS9FeVHXoSfjobdG2uddcC2fLLntw1utpfgTT19zg0ivBKy4tS82BgrsaF0h
	G7rAvQq7E+HCX2ce4Q7gbj//mEnFeexEnLMIZ/Zrjhj+X3tG5iWeW1fn/lJUZ90O3n/UW/SWRYu
	aAiFRzFwqUfHaxLpm27WEBpeZVM6gA4C1Bl5PgZvR3lxqF7MLiFWwSc7TyKyVFNSOMJ3ztmOnLe
	htB7ZviOL6j6Ko7DQ47tFowoNUZ3ihH1iN1x+hten/xjL6MvIElOjlFZj4gM7RdlGcdzgXm02aS
	qnf98vdBYSTK0RmhW3y/BWAtJm9cVA9Cqm83vQ6G11smolSWm/gJrlikTd9a7xTZUwEerX5QA0R
	ijjhLn+6eHu+gkW3P8G85UVThG+20oM3bMfNRtNZ0JjKr1br4/rpmoahBNp/1WjOisAC/qJXwnI
	cPUexJhoqThApm/AqoHcGfbfe4+d1/VolK/odFImI7+NpP5ywZpUybh+ao6JxEfTcKnZhfD3TpZ
	hUyr/d6DLNIwZ+Xbw4OvJZblEqsFdqz
X-Received: by 2002:a53:eacf:0:b0:64f:fc0d:624b with SMTP id 956f58d0204a3-65c18fd2d1emr1130723d50.56.1777538899040;
        Thu, 30 Apr 2026 01:48:19 -0700 (PDT)
Received: from darker.attlocal.net (172-10-233-147.lightspeed.sntcca.sbcglobal.net. [172.10.233.147])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-65bff4fb88esm2383544d50.5.2026.04.30.01.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 01:48:18 -0700 (PDT)
Date: Thu, 30 Apr 2026 01:48:05 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
cc: Lance Yang <lance.yang@linux.dev>, hughd@google.com, 
    akpm@linux-foundation.org, baolin.wang@linux.alibaba.com, 
    baohua@kernel.org, dev.jain@arm.com, liam.howlett@oracle.com, 
    ljs@kernel.org, mhocko@suse.com, rppt@kernel.org, npache@redhat.com, 
    zhengqi.arch@bytedance.com, ryan.roberts@arm.com, surenb@google.com, 
    ziy@nvidia.com, linux-mm@kvack.org
Subject: Re: [PATCH hotfix] mm: fix pmd_special() fallback to observe
 huge_zero
In-Reply-To: <4d950326-6944-409b-b108-a4e67256857f@kernel.org>
Message-ID: <e92e45df-0821-1d67-e026-88c57960814f@google.com>
References: <e7cbc92b-ce9d-432a-ae5b-c8715dcd922f@kernel.org> <20260429065743.67054-1-lance.yang@linux.dev> <ea1453a6-14c9-4334-ac7e-2758586393b2@kernel.org> <aa3937bb-7f06-4136-ba36-ce4a06acf80a@linux.dev> <4d950326-6944-409b-b108-a4e67256857f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: 85B2F1C0008
X-Rspamd-Server: rspam04
X-Stat-Signature: b5443zgf4u3igfdo3w1gqcr8wbwhnhoa
X-HE-Tag: 1777538900-492157
X-HE-Meta: U2FsdGVkX19d4zvOpCIKkZr9kerc7kWDEp5FIrbfZ2HRv6PS+pYkmpJFK9oe25qD4m9K4Wp87EPH0UtSUKbZ59so2A4ODPry3rRIyFx7aA2l/XdfO4e0idaRpeWIJOKMial+D/Eg9sjynGudcKVD54hU/n79EX1cthp7YUXZkVpJyk/dpuP1aPlmzAsJDImqchyUORiiUXAxk0jcB/Fqc5tc7+g1wVmsYvQypywzYhbreJ0DTCmgZiDivjhNEtszVhsAIJj3hXCDyYlJ0It9q5h9bpY6/FbNtGwl7L94c4rN7oqJakFP/P5BUNnyPxqwcOhWwIiE+KDMPQrI4wNJfn9XJHRaLxFmec0/AGhb2pCApoeMjZOXe4vnzzUKD4R4AggTmE0A8781DZWwdYz0729+9x2v0mFzDrontG1LxG/GBrxkYb8QKSLdApav/Fkbq27Nn/zGskuobvPN+/JcDSSYczBZxEucaQamtqv/Q9t19mNwVuEFfJLT7Ru4CboO/GEeK+y2BTTZ1ZQk2XHvXbM3sAM/BiUNjcjFfoAZfqF6KMl4tZwkznRMheG0aZTuV8RYV2VAgWfE+8sgv51+MCTUzOViE+NKSBnvVLkW2mk4iB9e7K3/3jolM7Ilt4+wQmoJjHy8u9gi1GyzbPnyzaxMcZQKRRzeQ6e+NQ3qbYzjtSlaZ5JEnESYwA5x2CKDXH8FdYTTChuaCtc4LU6o+scVH5f1hpKiCg/3HW3wpOPyNwBOG55Yj1V+QtCMOKSTQqZs+CcouYE7QF7g2h0jaGqT4rm3vbVKXOyzZ4/LGOcCkhK2Hx3VMDoc1rXUWDAkV/xtvGQhvGD2Ur9TXbxz0RJilHYydwTK7+4Mcp60XJ2h8HOzrVp/ieZLmNExrqnYaWXi91Mw9EpwP7SbZpGO9LCK/gaNiRQThhO0ubykLFzhClwLKlq7Dw/QFwTGjcij3hahobg8P2VGBjLTDYf
 KX3pdD1f
 D8s/SKokDdkX1rQOV+FQYJzEjLoftF1GipF89Js7nhBWQzrKEKfyCOvx1hUUw2Kl3pQ4hdwEf33cWHtv0MprGhbaFwIa/jJRXX+MsshgauznPvAc9VbEZfPQDlRu8xuSaEGXfCrxjcZietrdv4RLeN4TpCeSU9JPdCQJWX/vP2+xbmbUAZ4n0FAPQH3ryVPSDPMUzIsUQGI9VS3x77d3gBw2hnqmkUzWOvcsNuIjBOp21n0uSMoUi+NOCYuWVAOo9e5O7cfwC2IM3w33QrJlRsCPdF0Teq5Jol6yWoDG97we8MNMJOh0a2t7trlNg5iGmwsw857hHuUyXoi3X6jeZp/6JEefAPY3KY1ghvtBn749oXARqBi3l8bed4xC/saNpAlEV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Apr 2026, David Hildenbrand (Arm) wrote:
> 
> Okay, I'd say we do the following:
> 
> From fd9ead548f102f7c257980ccc7b96cce7e42a570 Mon Sep 17 00:00:00 2001
> From: Hugh Dickins <hughd@google.com>
> Date: Thu, 30 Apr 2026 07:35:31 +0200
> Subject: [PATCH] mm: fix pmd_special() fallback to observe huge_zero

No to those lines, this patch of yours is quite different.

> 
> On x86 32-bit with THP enabled, zap_huge_pmd() is seen to generate a
> "WARNING: mm/memory.c:735 at __vm_normal_page+0x6a/0x7d", from the
> VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn)); followed
> by "BUG: Bad rss-counter state"s, then later "BUG: Bad page state"s
> when reclaim gets to call shrink_huge_zero_folio_scan().
> 
> It's as if the _PAGE_SPECIAL bit never got set in the huge_zero pmd:
> and indeed, whereas pte_special() and pte_mkspecial() are subject to a
> dedicated CONFIG_ARCH_HAS_PTE_SPECIAL, pmd_special() and pmd_mkspecial()
> are subject to CONFIG_ARCH_SUPPORTS_PMD_PFNMAP, which is never enabled
> on any 32-bit architecture.
> 
> While the problem was exposed through d80a9cb1a64a ("mm/huge_memory: add
> and use normal_or_softleaf_folio_pmd()"), it was an oversight in
> af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
> and would result in other problems:
> * huge zero folio accounted in smaps, pagemap (PAGE_IS_FILE) and
>   numamaps as file-backed THP
> * folio_walk_start() returning the folio even without FW_ZEROPAGE set.
>   Callers seem to tolerate that, though.

Yes, I hadn't thought to check other uses when I posted yesterday;
but later took a look through, and was coming to exactly the conclusion
you reach in that paragraph (well, I gave up before following through
far enough on damon: perhaps it could also have been affected).

> 
> ... and triggering the VM_WARN_ON_ONE(), although never reported so far.
> 
> To fix it, teach vm_normal_page_pmd()/vm_normal_page_pud() whether
> pmd_special/pud_special is actually implemented.
> 
> Fixes: af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")

Agreed.  My Fixes tag (where my bisection arrived) was correct for the
common zap_huge_pmd() symptom I was seeing (Lorenzo's commit removed
an independent is_huge_zero_pmd() check from it, so it now relies on
vm_normal_folio_pmd() to give the right answer).  But you've chased
up other usages, and realized it goes back further.  You could just as
well blame the other commit mentioned in this thread, the d82d09e48219
("mm/huge_memory: mark PMD mappings of the huge zero folio special"),
because in come configs it is not doing what it expects to be doing.
But af38538801c6 is where effects start appearing, so fine to blame
it (and both come from the same 6.18 series, do it doesn't matter).

> Signed-off-by: Hugh Dickins <hughd@google.com>>
> Co-developed-by: David Hildenbrand (Arm) <david@kernel.org>

That's generous, but the patch is not mine at all, and I'll
happily let you grab my two paragraphs above.  Please, just
Reported-by: Hugh Dickins <hughd@google.com>

> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  mm/memory.c | 17 ++++++++++++++++-
>  1 file changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 7322a40e73b9..a60bc07b48b2 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -612,6 +612,21 @@ static void print_bad_page_map(struct vm_area_struct *vma,
>  	dump_stack();
>  	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
>  }
> +
> +static inline bool pgtable_level_has_pxx_special(enum pgtable_level level)
> +{
> +	switch (level) {
> +	case PGTABLE_LEVEL_PTE:
> +		return IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL);
> +	case PGTABLE_LEVEL_PMD:
> +		return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP);
> +	case PGTABLE_LEVEL_PUD:
> +		return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP);
> +	default:
> +		return false;
> +	}
> +}
> +
>  #define print_bad_pte(vma, addr, pte, page) \
>  	print_bad_page_map(vma, addr, pte_val(pte), page, PGTABLE_LEVEL_PTE)
>  
> @@ -684,7 +699,7 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
>  		unsigned long addr, unsigned long pfn, bool special,
>  		unsigned long long entry, enum pgtable_level level)
>  {
> -	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
> +	if (pgtable_level_has_pxx_special(level)) {
>  		if (unlikely(special)) {
>  #ifdef CONFIG_FIND_NORMAL_PAGE
>  			if (vma->vm_ops && vma->vm_ops->find_normal_page)

That block ends with a comment on CONFIG_ARCH_HAS_PTE_SPECIAL:
perhaps better reworded now - but I don't know what to suggest!

This patch seems okay, but TBH I have no enthusiasm for it -
it forces me to think too hard, and I prefer my own one-liner
(iwhich Lance found odd: odd if you're thinking pmd_special(pmd)
means pmd has the _PAGE_SPECIAL bit set, yes, but not odd if you
think it means that pmd is of a special folio).

But whatever, you and Lance prefer this one: thanks for the fix!
Hugh

