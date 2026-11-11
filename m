Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C558606A320
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=A5sS8+8u
Received: by kanga.kvack.org (Postfix)
	id 7F8546B05B0; Wed, 11 Nov 2026 03:01:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A88B6B05B2; Wed, 11 Nov 2026 03:01:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 698716B05C6; Wed, 11 Nov 2026 03:01:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 409BE6B05B0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:01:35 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C17F0160224
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:01:34 +0000 (UTC)
X-FDA: 85422093708.26.FF63379
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id DF9CF4000A
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:01:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A5sS8+8u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794384090;
	b=XZjiK9rxRBEgjy5ezOVlp4GRXibMx1j1Kb0Q4ihJe+XytG57/FL0h3ifQTbW4nc0ZC5us6
	WjYzT3kLpHzLG2vzty5e7oB3wSwbWBfPG5fMKY2JE2Lgc0LOgW2e66DUqrypemxJQ5hGCH
	70Bx83xCnRqc7Ho1ZMbgQdP9cHxd+MQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794384090;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gFD8GxCW8TaX600NUsdqPsT5QbgfQppQ+86XjlXuBB8=;
	b=aiLAJEQBvJLm6JtelOfxUkzBl2v1qo2VRO28dBAdZxkv32yEQ4Ot/i9Ai9cIxTY56fnc9t
	Xa1Vpc8iRU9sbV9+O2U9X8vA6YBGpe5INFW1S9G95marbmYlhmxk4+C5YO6C5xgMcMbo4r
	mlA8vU05zwV2fsHqfThEfVT8yVB3C6A=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A5sS8+8u;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6F2716112A;
	Wed, 11 Nov 2026 08:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A022C1F00A08;
	Wed, 11 Nov 2026 08:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794384089;
	bh=gFD8GxCW8TaX600NUsdqPsT5QbgfQppQ+86XjlXuBB8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=A5sS8+8uY+DdCHXQg9bRdOYPz96TIc0INTUnO+kkKrJHaM26c1xrNB1zhn38ZR5XQ
	 a7PPfIg8HknZg+PMAMVRgWVp6MK3YnB4FQW+7eT4e61afhSVfAcWXe0Jj+tperG+J6
	 Dba1+3LJCt6ArpYAnkXiJLliqL/5LdetKFFAbKNh32rFyso25fblbBhUjhL8FDI1li
	 EZAo5C/9n0lU3+Vx9r00gWq5QjPkLLy6n+P9F8Oda8sotn3CotI3ynZdBEcdwNAIS0
	 L0UuXPmy9Yt9YTLvvnkx9jHVGoKUDxjn9siexv4zzcPe9rKUdzNcSyzFT1PdQDeB9J
	 k5fMTXuIOAW1Q==
Date: Wed, 11 Nov 2026 10:01:23 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: pasha.tatashin@soleen.com, pratyush@kernel.org, graf@amazon.com,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH] kho: Prevent reuse of preserved pages after a
 reservation failure
Message-ID: <avQg0_jFY3get3wG@kernel.org>
References: <avQUquBK6cO6tUUI@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <avQUquBK6cO6tUUI@chrisdown.name>
X-Rspamd-Queue-Id: DF9CF4000A
X-Rspamd-Server: rspam12
X-Stat-Signature: ow7no3g9gzxy45uw6pbz5qidq1htbg6g
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794384089-602522
X-HE-Meta: U2FsdGVkX1+ny0Kk4rst9C5SuhQYEXBUdH07s6rTs1BQQAc4KcUK1IW0MJ6kAbf5COXb0nwkK+u4QVR2hZH+PKQZrZPIyINXjULefy6rPAKWHV3+/sgNfgqM3qb1jefFRlaluvahSZdAy91WiGIlVlkWudEnxmY4S/J/uP8M6Au3ladBYYejh4qJVggE4o5ac3f0v1bJnjrrfZh+Nk0IAGrTqqUs6HrA6siUMueiKq0Nn8WroC+vjWUafSdsuWwwTp8IBU05rcuAN3eGjsg2SZGaxgJXbb+9rVpO7uMP0bdbvxYJHbW4x80L0wtJQWHbbSFTbzQh2hkVZ6ouv/cxNFRe0sUNCeX+YQ93WPppoW08jEW0zFyae8PYUnSzy3Rp2CVJTalce+4tKkfkEuZ/nuK+0ydul2wxzYozz1NAn8OUf0qb+9ciRp1+onIcMYR183V6TY2R7RotYR2FYfKrAueENivHNSDQpRrG10HA5lW3DVhplKO8yVzVgB4nAEOunI7+P+ir5ItIjld3/sWyyVdtXcO0/dSkJ5elBap0VRQsJY7e7sg/Q7MTury3JthtRy1Vb9GkJHYxeInBrWAECFSXWyJimPdq91FoIK4FEkmkcE2WUnfdqdg0HrRFDhuS/GEoff3jfRI8kYCcqafK/1fAsRPbbVFINakgdMZgD/pYd4uQ5aNxRYWCUWI5Mgc3bLaHg7YULL8FDos8C//PRT5lLyVhn2xcqjaD9xT0GaMr6dbMAgVTKPRVs3noeQuxjww107lSfQ6YRDbqEJeDw5FXh+iEekKJl3S5d7oTtoPooC7PWrguyJRRR3cteVwH1BFS6EX0tbcrCnJsb64X7nMGK1Fd6JPQp+sSl/pw0sguPICLiyyWa8edpeh+obLnI/xAiRtdK13YDFGIFTiyLygxl23pUcl2tabnCbDMKB8O+TlkNiEygDH8+dkbTToHtPBh72RiPyZlpsF2Qq0
 Ng4iJeBA
 8T26Br11o9xLB5TGQPGLFZ5QDzZ5BfaUnVSmbxgzWrknmCZNJWSb3jONzxnaYgXzdVlIwKuVju9xgV1TxMtYkuDQFBJ3eOCPMax1ur1m/NnVEDKQuRexeeGbHIS9cYcbIKl0LphwqYhHFQMyukxmekBpquD+LEBFLFFgFd2sxPVhMGKP5UvG3VxBbpJCZJCeX/hikpDxwg/KT4KqPZZUj1VvRwmnRRTtOf+Odrc5gxS8ggeso2hB8oOw1FEXn9g9uii8EaK8f989iAQ4HPDCBjXAaYSQLGY0enAm5JJ5THMIl0gHlFpG5vGKarTIi4K4JNXUqAd465M+3MKfiQXPG3gWLIjDv9nspYtcGAN7ptQCTb3NgE/B7mAe2ynepIAXaQNtrSbB80X4e5Su399TlCSSxsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

On Tue, Nov 10, 2026 at 11:09:30PM -0800, Chris Down wrote:
> kho_preserved_memory_reserve() reserves each range of preserved memory
> in memblock and marks it noinit, but ignores both return values. Either
> can fail when memblock has to grow its reserved array and can't find
> room, which at this point in boot it may only take from KHO bootmem.

Is it an LLM analysis or you seen this happen?

> The boot then goes on as if the range were reserved, and two things
> can follow:
 
> - If the reservation failed, memblock_free_all() hands the range to the
>   page allocator with the previous kernel's data still in it, while its
>   KHO user still expects to restore it. A memfd preserved through LUO
>   can then get back pages that belong to someone else. Oh dear!
> - If only the noinit marking failed, the struct pages can be
>   initialised later, wiping the KHO magic, so restoring the range fails.
> 
> Dropping the handover at this point isn't safe either. reserve_mem=
> revives its regions from the handover before mm_core_init(), and
> relies on this walk to reserve them.

reserve_mem_kho_revive() can memblock_reserve() its memory itself and we
can carry on, can't we?
 
> Carrying on could hand out private data, so let's panic if either call
> fails.
> 
> Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
> Signed-off-by: Chris Down <chris@chrisdown.name>
> ---
>  kernel/liveupdate/kexec_handover.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index eeec298aa9d6..0faa21ebb0cf 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -629,9 +629,14 @@ static int __init kho_preserved_memory_reserve(unsigned long key, void *data)
>  	sz = 1UL << (order + PAGE_SHIFT);
>  	page = kho_get_preserved_page(phys, order);
>  
> -	/* Reserve the memory preserved in KHO in memblock */
> -	memblock_reserve(phys, sz);
> -	memblock_reserved_mark_noinit(phys, sz);
> +	/*
> +	 * Reserve the memory preserved in KHO in memblock. It's too late to
> +	 * drop the handover if that fails: reserve_mem may already have revived
> +	 * regions from it.
> +	 */
> +	if (memblock_reserve(phys, sz) || memblock_reserved_mark_noinit(phys, sz))
> +		panic("KHO: failed to reserve preserved memory %pa+%#llx\n",
> +		      &phys, sz);
>  	info.magic = KHO_PAGE_MAGIC;
>  	info.order = order;
>  	page->private = info.page_private;
> 
> base-commit: a0dc8eddbfdb6dd9c5c2b70eb66ab49cb1978425
> -- 
> 2.54.0
> 

-- 
Sincerely yours,
Mike.

