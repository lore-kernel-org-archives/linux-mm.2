Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CB23606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 12:12:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XXXJ2R0J
Received: by kanga.kvack.org (Postfix)
	id BCCA36B05B1; Wed, 18 Nov 2026 07:12:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7D266B05B2; Wed, 18 Nov 2026 07:12:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A93386B05B3; Wed, 18 Nov 2026 07:12:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89F9B6B05B1
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:12:28 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 04D991406DB
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:12:27 +0000 (UTC)
X-FDA: 85448127576.07.7F08380
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 68BED40009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:12:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XXXJ2R0J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795003946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=epBVrGZiw1creBvuYOePhoSdCzgWgXCOkWpLld3FPh8=;
	b=Aa4q3Z7nnUWrb+401jtx77P/M9GB3LZETTs4h+QktYgSs7z3qp3XvNEaTQyw+DE6gyfvPr
	AM3/hm8eAu/FDbK91MOOqIFUScJhnAbU+OhpC5gRvFb1zL93ADNHzm/T8HlJ2sgcXw6KFx
	cCm46HXe57TD4BgMErTdnkgp+ZywqCE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XXXJ2R0J;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795003946;
	b=QSiItsEWrpdoQrNyc6Pmn1oQVrwX5//Hhudm38zMu/O3qMHS7Hy540lm1+d491Ny2ahRC/
	NYR1csi4zDuvjxCgam3eil464BduDoLheiZL0TgPP2AIZLZcgLvQX3aHikn8sQ+Z69/bRt
	eCbgOw9y8M1hv5dwD8YgOPd2g9YMs3M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D88676216F;
	Wed, 18 Nov 2026 12:12:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C04FF1F000C6;
	Wed, 18 Nov 2026 12:12:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795003945;
	bh=epBVrGZiw1creBvuYOePhoSdCzgWgXCOkWpLld3FPh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XXXJ2R0J07MlKzGSwWu2Ztiv4YkTe+gqNLjFMOxXUTiqc4KhcH/eJEWxVN7VQM116
	 cNXqLxlFhUHJ8b+uND7+oerzPM38gJdjj0EIHS5jjoV26s5vq9ie2EDCKWGMd28ES9
	 Hczw4PXnJ9cJTSDkjHo/lQpCxhKXGuIbLH9GClLCRri2llSYafn1JTyhTibDDUQaoE
	 7p31kQGSigBrTorB0Aso2vAFqpbRvlZegUa3yhW6vEEzmvMx28m0TIejxJFrFf0+3m
	 MXoGpnzAjwGpCfwhPDQn2qu1O8ze7DwTbiDl6RFv80riVktXjfpwU/hcwj/tAKPR0S
	 oHS/+luRr9Oiw==
Date: Wed, 18 Nov 2026 12:12:20 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	ahuang12@lenovo.com
Subject: Re: [PATCH mm-unstable v2 1/1] fs/proc/task_mmu: avoid spurious
 seq_file warning on interrupted VMA lookup
Message-ID: <av2V-JWdu8GqKtMT@gremlin>
References: <20261118103421.776-1-adrianhuang0701@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118103421.776-1-adrianhuang0701@gmail.com>
X-Rspamd-Queue-Id: 68BED40009
X-Stat-Signature: 357z3kxfyagq8gegpborwupe95hg7ji1
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795003946-167658
X-HE-Meta: U2FsdGVkX1/M8opnjzIaQTPOWtpNyKSA4kTZH1d90hMnTHNG6J2O9Scj10U5psUiirYGLY1qZh7hcl4qUW9zzrNsiGNTORR2l80+b82MRNTsMCCr39oj8/RVz/p8HwzQp9pdCW3ROvN6Ox3lhQF99ZJ1MP8yF6Q+TJTQ6exYyRQzbSpE2uyoA2HtIa/kw0/eBfpSvfs0+UvPZ0GgF9IG+fzkskSSDS23DsFGfup3sY0l04cGX85khUMYpcAlEC6Az3X97k4mBOePFWyoLVlCf46Ymd/OW3KgQrEfoSWhiY9II2jrm486F2Rb045vir2x02LO63WIdjL5ii2B+nDz9RpB18kYGV70gFOP93DudzdIE1yp9YzmtYEJPs8lK6Es6JGQOQLGyzGFxpY69e+RLtc6IvukdKTv4kcc/1S+Dy0bX2V9vHgeBTadondZ2bHPMfC0GM+y2XcXnw60pBa7EIM+HCTebNaie9sl5gLRu0wQ5gliDngIdTxtq0G1Un3kJIBLxofsr/LTXuz3uLmMIOlrfXwW/DRySA64Ta+6yY0oSxW/RBHseMuCsAUNSPDvOrgnbPMFBrV0Iw2Pc8ZdoCXWatqR4Zr8IyJHG70rP/u4zSI20TpvnxRyfw8vO7rz9aMW05OeHy9OF22Elxx69BMaMhmaRNBtG6ZUL7se/bYCTy9mU7Z/Lh2ow222NeiX6xFuQuq6fcOBfus+gOWeWwJcNeHVesBd4llpsBxLngjEsqcUdt9J4IRLrJzAT8tMuSLb0lKGaUzcMB+FMNoJCNzcMlhA+Y4zrDuBhF0LhAdQa8NncfcqfpXeDvdns34A93hnGHckkF8zIUMpbL2g1U96qxA/Z6LA3qwZlnUbmNREZjly+y+RkqT8lPFaEbbDgdCcriwaKuoZgWvvRiI/iYCOOCFl+tHpIucPTucjMjqv4leJD65W2t4Ryx7GEAPbI0bO2zhKSUa/H2aX0mE
 O/Baz8Re
 44dihA2cCWRE/VAgP4M1vY2ZNCCqXVZgnerWJ2ar5sDMwN45X5woXoHJjubvF6AdodmABpbOm+mIFZyB3tbionUEraAYPr8P8uOB1QcIhOAlQTNp8W3HSGXTOUIk4e6EvBBMPLW6fJxLYp4jgaAF9BP8oGcarU1p7LW8B6s1EMIxvtu032Ao1q0LBZOal4p1gzabMaOUg870AHPQ5v+7l4vPSRxGE0j5FZqvD7R/8capEc6yjtQV82pUTJ2usJtqNsLCOGtJOLiXWVjwD00PfPC2WUUbAt4BTYkQUEJ6HlZVl69sxkF/x3d3qrBfEm3dtbbMm/cBvRQCtieVVkXpCPWFNvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

(micro-nit - no need to say 1/1 for a single patch :)

On Wed, Nov 18, 2026 at 06:34:21PM +0800, Adrian Huang (Lenovo) wrote:
> Commit 5631da56c9a8 ("fs/proc/task_mmu: read proc/pid/maps under
> per-vma lock") introduced the possibility of returning -EINTR from
> proc_get_vma() when a fatal signal interrupts mmap_read_lock_killable().
>
> The issue can be reproduced using stress-ng's VMA stressor, which reads
> /proc/self/maps while concurrently modifying VMAs and periodically
> terminates child processes with SIGKILL. The reproduced command is:
>
>   # stress-ng --vma 0 -t 60
>
> When the VMA lookup is interrupted, proc_get_vma() returns an error
> pointer without advancing the position index. Consequently,
> seq_read_iter() emits the following rate-limited informational message:
>
>   seq_file: buggy .next function m_next did not update position index
>
> Save the current position in priv->last_pos before checking the VMA
> lookup result, allowing it to be reused by both successful and error
> paths. Advance the position index when returning an error to avoid
> the spurious warning, while preserving the original error handling.
>
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Adrian Huang (Lenovo) <adrianhuang0701@gmail.com>

LGTM and:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> Changes since v1:
>   - Simplify the error handling and comments as suggested by Lorenzo.
>   - Clarify the fatal-signal trigger and the cosmetic nature of the warning.
>
>  fs/proc/task_mmu.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 22361607020d..564e52f7ddc6 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -216,16 +216,17 @@ static struct vm_area_struct *proc_get_vma(struct seq_file *m, loff_t *ppos)
>
>  retry:
>  	vma = get_next_vma(priv, *ppos);
> -	/* EINTR of EAGAIN is possible */
> +	/* Store previous position to be able to restart if needed */
> +	priv->last_pos = *ppos;
>  	if (IS_ERR(vma)) {
>  		if (PTR_ERR(vma) == -EAGAIN && fallback_to_mmap_lock(priv, *ppos))
>  			goto retry;
>
> +		/* Advance to avoid spurious buggy seq warning in dmesg */
> +		(*ppos)++;
>  		return vma;
>  	}
>
> -	/* Store previous position to be able to restart if needed */
> -	priv->last_pos = *ppos;
>  	if (vma) {
>  		/*
>  		 * Track the end of the reported vma to ensure position changes
> --
> 2.43.0
>

--
Cheers, Lorenzo

