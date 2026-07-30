Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CA96C531D0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 07:43:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9B236B0088; Thu, 30 Jul 2026 03:43:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C734C6B008A; Thu, 30 Jul 2026 03:43:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B88FF6B008C; Thu, 30 Jul 2026 03:43:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B1EE6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 03:43:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 44B8FA1E6A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:43:10 +0000 (UTC)
X-FDA: 85044652140.07.ADC163E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9C109140004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:43:08 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S7kdUwet;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785397388;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pDaJ/+nIgmvu6q0pTtI9cFKoi+A+/DB+ehPxk3gGQPo=;
	b=vgc6H1T6xME6wa8HDEAKkOS28uG2Z4C180WwfiMZvHxKhjdOLR8mSpmkNj+NLbaOnlQmg1
	wqsRf1Vik4INs9vuOoyWTN5DEGKdan6mwbOtd2QKHD3xKL27cPL/ucoWmB506Y6PoO6hwy
	LYEPe3w+N/tSAzKLo9kJGyJl82jtRos=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S7kdUwet;
	spf=pass (imf23.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785397388;
	b=XGXG0h9aYebP3IWB9vOmC8r2g2tiIwJjmtGnpwMdZgQ3QJc2m/SiBdZrcKrDtJoqahHwbc
	6ZGJiR9oLOr228E870f1SldgiHuwBHKrhF3iY0r1LFzmnKj8c8sNFPNPVyMB52wEJK5pK+
	OdYJPNpt9Ay/naXHAT1FjVIS9yOzWkk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B515240B7A;
	Thu, 30 Jul 2026 07:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B641D1F000E9;
	Thu, 30 Jul 2026 07:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785397387;
	bh=pDaJ/+nIgmvu6q0pTtI9cFKoi+A+/DB+ehPxk3gGQPo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S7kdUwetvww4fJ0G3Bdg5GUTedAKkvPoQaJewy0YPJGJOVFkEvvV2daTtrz53T4AW
	 zwvZgYrYcX/R1TlstajiEiNBWIB4D5mRK9LDjQFBtw6WryYG0JemrTKfGZ9WLyqEID
	 Q93JjVAm39Y5DVbBOmHOO+Pn9JcG88/aIeT0A8Z10B3Src+vfsCNHQbXL2lmH9FP9t
	 Cg+73GjuYaswY1fN8JtyuqzzCCb78gWn4RPkfMBjWrtfdre2PYXYPzZ6y41aJLnVSq
	 dDnmvsn/8K5GDJ+eR2HkB4ZpTkCXGaJq3FrSxCJkg21umtCsrGGKtiInJph2SGD9Ac
	 a+kP0sF0xrX4Q==
Date: Thu, 30 Jul 2026 08:42:49 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Avi Weiss <thnkslprpt@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Soheil Hassas Yeganeh <soheil@google.com>, Arjun Roy <arjunroy@google.com>, 
	Eric Dumazet <edumazet@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: return -ENOMEM for page-table allocation failure in
 insert_pages()
Message-ID: <amr9zoSncZguF_uu@lucifer>
References: <20260730071323.964321-1-thnkslprpt@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730071323.964321-1-thnkslprpt@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9C109140004
X-Stat-Signature: z73py68r8xbzutbdxc5s5t3mk9fwe94i
X-HE-Tag: 1785397388-178369
X-HE-Meta: U2FsdGVkX18GO7ajVfImV5XxhJGteQKvoTC2wiQilfbOGPV7b6bJpw1mdSbxaz39zA56ZBvCWF9RaCvytoeMm1ekKigDKqwtSljhHQLeZJg3kmEmlSrb6Ev/gLCOVMA+UKzXlljjcGhq3j8t5IUGc7Dq43+ICZCt335eZX84uaFHRTs7Q/zs2Irr3LJZDmltT3eNgb+b6DP7RHxLTcjn2bFubE/5+m3nL6yrutCAq1mWiKCFozlMejqKXXA0wHXuAB257fVQ3Mh+V7O5LbGmlnkAt016wB61n0DSkTOg5nCdvRuTqK/Ibn1BOI92L+iy2UKsCkbyuRj81MZxjdZQMuVQuXBU8O2IsmRnTCzL5M0UTbMepWbyS2SCvNrIBjnf5BYl5YX6jUeQHK0i73JXsCvZlx9c1O7FoX4VTgYwwNiJbxer2FPZ/a8bItyRV6d9hiYzRKMllKegYDx5srOKYHxdoHH2EIG3T7eoSBKhQAkT3sI4nDOYfRSXuKtjXV++G3/9+noogBhWYO8Js4zZSt0Sa2lIEyZCrCHHD5xeFeLtIPrdkkZc4yEQtDvy9zTOCcN/azTWeSEuasHVqIhgijJUzNn0/8n0Au+NBerEWWbLJZ5JGrl56TrKgvm1QbWi3bLD/1uX8aHFK3BfFgkRaWjnu6QYerSXE6nKMvtsFhV3DgyQpMruD0Pt+46PuD5bUvmeSjU3rv40lYtj+AnE2Pv2nj/aGMFztcVdF36al+2k/OepO51j8bEhhklXsuns7dHKpJPOHYwLgo8MXeLkub2BCUV+o98IZr1KdTOCsvm1mGgGrIwxw58mlBP+bzXKRM8c0/9NyN+Pfkg8REqRYITGZtbMRqJyncFhxz/tV5EXJ/Ffcv9ACBkMeADQ8VS/Vx1EZGxHVaf5EKyXiGm2dbjNrPE+OxtBX1+hs0c8uopeCExyFqlEYVrTvl1nNDFPtEGtiyyfWX+yOClCF3k
 M1arX9ip
 6QWTqNQcBFyfJgSOGhftGpe6lT5PnsjnCo+VSzEPhp5nDHcVLsP55H36tk6q9OJaNQqJ5f/LZShX0wwjPh5AiJOeiOn/zE2HOItQKypXWznr3m8dTZ5T17FShZVMljuZrKG0NGOMVEzUIRHArxLEfAsJGEnywGhT2enwmSaFwjObCDGaPMfIwCAzeJ3kuTK0k4EZrDslasNckGvO8HAs/VMD8C1pa1alK9wWEiCMpcQ0OgdYDgkEBv6N38MhCzR3d0Gri42KIG9l2eQWJnuAbgEcl0qC/E5QNkA94QKCtKBzLGrkletmBidfkUClhphUy92jy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 10:13:23AM +0300, Avi Weiss wrote:
> walk_to_pmd() returns NULL only when p4d_alloc(), pud_alloc(), or
> pmd_alloc() fails. These are page-table allocation failures, but
> insert_pages() currently reports them as -EFAULT.
>
> Return -ENOMEM instead, consistent with the subsequent pte_alloc()
> failure and with the single-page insert_page() path, which reports
> failure of the same page-table allocation chain as -ENOMEM.
>
> Address and range validation failures in vm_insert_pages() continue to
> return -EFAULT. Keep the later -EFAULT return for
> pte_offset_map_lock(), which is not an allocation failure.
>
> Fixes: 8cd3984d81d5 ("mm/memory.c: add vm_insert_pages()")

Hmm :)

This isn't really a fix. Anybody relying on this returning -ENOMEM
vs. -EFAULT here is in a state of sin anyway (unless you can point to
specific users who are broken).

Drop the tag.

> Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>

This is correct, walk

> ---
>  mm/memory.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index ff338c2abe92..d8eddca8e251 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2436,7 +2436,7 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
>  	unsigned long pages_to_write_in_pmd;
>  	int ret;
>  more:
> -	ret = -EFAULT;
> +	ret = -ENOMEM;
>  	pmd = walk_to_pmd(mm, addr);

walk_to_pmd() is horribly named, it's allocating... populate_to_pmd() would
be better can you rename it?

>  	if (!pmd)
>  		goto out;

Looking down:

	pages_to_write_in_pmd = min_t(unsigned long,
		remaining_pages_total, PTRS_PER_PTE - pte_index(addr));

	/* Allocate the PTE if necessary; takes PMD lock once only. */
	ret = -ENOMEM; <------------------------------ set it again?
	if (pte_alloc(mm, pmd))
		goto out;

The way this function is written is horrible in general, I hate 'preset default
return value' as a pattern.

So could you instead change it so the ret is set at the point of error, and
while you're at it rename ret to err, e.g.:

	int err = 0;

	...

	pmd = populate_to_pmd(mm, addr);
	if (!pmd) {
		err = -ENOMEM;
		goto out;
	}

etc.

Also ignoring pte_alloc()'s error code (which will be -ENOMEM anyway) and
setting manually is stupid further down so:

-	ret = -ENOMEM;
-	if (pte_alloc(mm, pmd))
-		goto out;
+	err = pte_alloc(mm, pmd);
+	if (err)
+		goto out;

Obviously:

		for (pte = start_pte; pte_idx < batch_size; ++pte, ++pte_idx) {
			int err = insert_page_in_batch_locked(vma, pte,
				addr, pages[curr_page_idx], prot);

->

		for (pte = start_pte; pte_idx < batch_size; ++pte, ++pte_idx) {
			err = ...

Remove horrible ret = err and ret = 0 assignment later.

All this would improve it a lot thanks! :)

> --
> 2.43.0
>

Cheers, Lorenzo

