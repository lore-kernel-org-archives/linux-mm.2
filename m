Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C801CA5FFF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 21:53:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46D436B0088; Wed,  7 Oct 2026 17:53:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41E426B008C; Wed,  7 Oct 2026 17:53:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B406B0092; Wed,  7 Oct 2026 17:53:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 15FFB6B0088
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 17:53:34 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E936A7840
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 21:53:33 +0000 (UTC)
X-FDA: 85297182306.30.2203070
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id A00391C0007
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 21:53:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ASBFPsZW;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791410011;
	b=RKBxaw1XcRP/6CHE4gG/iY0ODMn9DG1UG4thEQjRZaSKCg4lQ4EVTqulz+8nW2XKz+OIUx
	IkZo0Zf60XAVRlr3VWYP6M16gL5aEFlSaVqDDKG08+dw6MKYJOMcvceIV+sabnJuodMJr6
	MGoi7cCqjADlLw03Tao7K+2pj2Ju9YI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ASBFPsZW;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791410011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jT1L+BywClITywCWFZ9MOXvq5XIqR36SrLF3w65PlSM=;
	b=b6tG2tNlhL/XXpoZHktjzfvgMpo+52RBifZ2Ci0hHuyszFxMF5fFEVV1VrY/8H8uFOwVXw
	rzcJRi8rYlCvFE8bBDMIUVoY4121FGH48Eln1AZ1ldy6lqzbS9DiV7QMr5YAQF/UugPbcY
	yPceVNCAa49KzwVrJvTV/5TryDXkZXw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AFA5E44503;
	Wed,  7 Oct 2026 21:53:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5849A1F00893;
	Wed,  7 Oct 2026 21:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1791410010;
	bh=jT1L+BywClITywCWFZ9MOXvq5XIqR36SrLF3w65PlSM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ASBFPsZW3zEXVhJIZOeQRX1MGBQEqkcFNOH6WBhMDGBbntuahWb2E5XQNoPpSZEZx
	 PYsmGKNV4pjc09CcqdJ5SFzYcrQXfpkg8K7Hx0alnXbm5JrayoziaAMP37yieNDF/n
	 HKhLQN0082RcqjyIwdQ1tOBZHhqKtM5VhX/nVm1o=
Date: Wed, 7 Oct 2026 14:53:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Keri <okerixx@gmail.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vma: keep the unlinked VMA off the file across
 unmap on mmap hook failure
Message-Id: <20261007145329.dd944233d7986bc0f5b2d63c@linux-foundation.org>
In-Reply-To: <20261007194708.2009-1-okerixx@gmail.com>
References: <20261007101800.58d50b1b20a10738e630bfd5@linux-foundation.org>
	<20261007194708.2009-1-okerixx@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A00391C0007
X-Rspam-User: 
X-Stat-Signature: 9et9kf8xxric9igz4tq8irmmse5ituhd
X-HE-Tag: 1791410011-332627
X-HE-Meta: U2FsdGVkX18qWuizoCy5EUHJarl2aZcedLEQrkrAOIDkfFq2ph0PGinnDiLlKMhpJ6ZnqPGrlD6bKokNiR9vNyktiTj07ozNiLNhZOJHVLJaSf1eKLkkus/A13cbXW+vgxV96fRT1dUcDsLrBjWhrCut4T5DXwmbUXfoKQAtOfJMQ0ZPZnXDi9HVKXNNiEpeJb6MZT+uZAPQgIS8z2qwTVMgxgnhKShJ0riAdTIDOmvqhca1uiT93qbHfS2OQBeR4iwESS6MUNgCZmjWzO9rP+DBKbhbOVSlJs+bg7Ynxl6r0PvJCW9iZsiMz4UH58XicOv2dBWoVSShLOOkZxbXNJmqLT6UElp/O28/EJ0YGOwNNzr/HDlaAlFIuCInVLGf4iuvra7lJU3IjfWeFlL+CYtSvk7fhdvnvQOoC+vfeBuAkHii55+wfd21o6GlG/raxdj2NJ+Csb1jbvGvYYtASmimHoSAMPKPdY78sWUdp1MFTANxwz1e72czhsrmhsI5zyrcJ2+rFXgtpdnarkNdFJ0EapVBYPTQnj/rVWQovia7mxFj1lbMb/JrgpFOqZlz4Mn4cocNcaEnhYbnanaDmuSP02yfFOWiAk9Hq+oTKhbGltbJBAOqljza+6L0GZZYNHS9fteI6z6kqr+9Xw2zwEgPRIrZmBwTCqnw9oe9G1QD9JR6xRgIVOHmrUx1KPnIOEzTrnYLISLvsuGydJh4J4HEGL26SsuH0Vpto4ft4A+06MvUxcLvvJ6WwOZ+ZYXUzPky57XDVrQFjOMfdU0zqXcr4mVRioXI5kBbJaxo8qsPi/uxt2lSKRr49neq+/G5jlrr09FG3dFvAzj+B+Q+pjgCLHechNbaDSsucSpC/2iDRva12winKvXhKhBIv8OKunfsD1SJeBwb5zS1yWbi07cI5Zma/cIOs1ZvLwT94rSJxK0pGmvkQEO0W/ehXY9HfI4D6dYkRrluTNrADyt
 Cmrv9mkH
 Y/DWsLDT+SkU732y+fce49qSOfz2Hy1pFvSvCvXI3W7ACkdlTFCrX7UxmPVYNiMpxrlpKaQYRLHK/H/nTrvuaxStj+9/wRe9FC43eOmgrqnClz4hyPac3sv9oUBWSIl5BleTSjwsSLYtd5izztgsIiqmanjYD+HewU6//ndnDOUjemh14MGNswMZvArJblC/kCmfLtbOjNVuMUVEqTvaAkfUsQyqCKDlk5dCJxqmgOQgz3EgdADIud2VVMG9NnXLVQDv8T0Yaw0CD0j2zJFyQrKkn5Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  7 Oct 2026 21:47:08 +0200 Oleg Keri <okerixx@gmail.com> wrote:

> Since commit 2ceb21171dd9 ("mm: consistently validate VMA state after
> mmap[_prepare] hooks"), the mmap error path clears vma->vm_file only
> after unmap_region(), so free_pgtables() unlinks the never-linked VMA
> and drops i_mmap_writable. Once it goes negative, every later shared
> writable mmap of that file fails with -EPERM until reboot.
> 
> Clear vm_file across unmap_region() only, so that free_pgtables() does
> not unlink a VMA that was never linked to the file, and restore it for
> vma_close(): when the hook succeeded and the validation failed, the
> driver's close() still runs and may use vma->vm_file.
> 
> ...
> 
> Seen on next-20261006: one refused PCM mmap probe from alsa-lib left the
> device unmappable, so PipeWire could not play anything.

Thanks.

> --- a/mm/vma.c
> +++ b/mm/vma.c
> @@ -2616,12 +2616,15 @@ static int __mmap_new_file_vma(struct mmap_state *map,
>  	map->vm_file = vma->vm_file;
>  
>  	if (error) {
> +		struct file *file = vma->vm_file;
>  		UNMAP_STATE(unmap, vmi, vma, vma->vm_start, vma->vm_end,
>  			    map->prev, map->next);
>  
> +		vma->vm_file = NULL;
>  		vma_iter_set(vmi, vma->vm_end);
>  		/* Undo any partial mapping done by a device driver. */
>  		unmap_region(&unmap);
> +		vma->vm_file = file;
>  		/* Only safe once unmapped. */
>  		vma_close(vma);

Signaling the unmap code in this fashion and the effect of this on
__zap_vma_range()'s uprobe_munmap() ->vm_file test needs thinking
about.  Perhaps a new bool in unmap_desc would be better.

But that's why we have Lorenzo.  I'll queue this for now to keep
linux-next happier.

