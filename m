Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBCE9C61DCB
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 13:39:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC6516B008C; Fri, 28 Aug 2026 09:39:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C76A86B0092; Fri, 28 Aug 2026 09:39:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B64496B0095; Fri, 28 Aug 2026 09:39:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9AF716B008C
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 09:39:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9AC5B14026F
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:39:22 +0000 (UTC)
X-FDA: 85150784964.10.5AF3F0D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id D5B1820002
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 13:39:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IPyEOCE+;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787924360;
	b=eRa4jXE6czsju6f2RDjasscXr/B7lwGXnmmTSWziV8LlcOtFI3BLqnMwUtUMdoUtNOI9eY
	ayuMCCzwbb6N/15/+/HWGTfhlJQxlTbRIGAZXnccd/CXkFS/Cu41FKjZKy0jPFiEGnsQAR
	etTZkn4e7CtUvrx5MoQtuMdcAUrJnLc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IPyEOCE+;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787924360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b0hzVh3T1ie/l+echYOTxDwBFiYljL9L1zhrFVNqVTU=;
	b=rOCDjKKdGdvWV/FXn6wMARLfyxa/5gSL/gbiOQwxsUwt0QOGopCGQJ8RElii6VN3d1zPy7
	Y3848AEKdnXQVka8yOUTsmDHFtc055MvPFrrsHZ4oZeX7oNH1ZSQa7biDkwcOtltmQUx0n
	XRgfVCnkNuDFtFEe/fV2BQApkZmx/cg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D8B7601FD;
	Fri, 28 Aug 2026 13:39:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2401F1F000E9;
	Fri, 28 Aug 2026 13:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787924360;
	bh=b0hzVh3T1ie/l+echYOTxDwBFiYljL9L1zhrFVNqVTU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=IPyEOCE+wJogby2iD7btLPv5bw8L2eSwAF0KHaqkK0cfSy++TZ2YhnUeGXLr7Q60p
	 ZpvU2Js7ig2hmZQGCpxYBCbWlDS8XMs2YFmQhw12xx30gJAHz4WMwsB638JcYZxDfF
	 2NKhPDdZoXz704AcHNc0Zksan9xGkPURKKivPeNJxUiDOvVqMdWu5sPmBKtrnnuW2k
	 ZLDuMozhaEsW9yMJL3mL0Ah+GtdL76pOrNnIF5pmnFdCSn4iwqezJ+L1RbtHqgtKCu
	 +bilRr4Z0srOH7haNjhDuSpceGVAcG3CeWKszQEH5XXx86B7p5uaHzOitzDr71Nvwm
	 o3E2yudiEHCNA==
Message-ID: <5e09ebb1-5dc9-44ce-b997-3b545db727cb@kernel.org>
Date: Fri, 28 Aug 2026 15:39:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mremap: account mm->locked_vm correctly for
 MREMAP_DONTUNMAP
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <liam@infradead.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 sashiko-bot <sashiko-bot@kernel.org>, Kunwu Chan <kunwu.chan@gmail.com>,
 stable@vger.kernel.org
References: <20260828-mremap-fix-locked-vm-v1-1-c80be7505d1e@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260828-mremap-fix-locked-vm-v1-1-c80be7505d1e@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D5B1820002
X-Stat-Signature: aq31pppywfz1phutm6541753qz9keupp
X-HE-Tag: 1787924360-240731
X-HE-Meta: U2FsdGVkX19xiAGizBosUdyGDz6mWD3v6zCCqsRTpN8Zesj07R8gvH+tW7lKeQ4vbDwwBD5c1BF9pHsY8aQeiav9/Qdm5SXbqiGNuEiN4KmUdxU2yDb/04xn1OqOYerrAn6CJsOMtvtHXQRJ8L9vKU5H4nlQsopE3zpAFgAu4DCnvN1FmfsGjmxRmGhZZCpIKKhVnh6wCVypV3Im6B3X8WH89hdY1ovfnBwVLbGhdmJdN9QMrsjkh+j7x8C7BO+RrXkC9KjmCD0KwfkPB5/jdsesiOctTu/oiFmc+YfhfTqmnpxCY1x6ZHP7UB8QAp8mrarhVO0xGvSY/X28EvfGVVzMq3ABV8+LXBhfgCI/LZ69nMeiq+JfLzeGUAkjzB6FXpcXRESRScLsUdWkc9k5t6k1B4SVJ6U0VofoJwp8ArFCuEjTFHXCcItA/6ygakdDDhGMIik41EYdsoxmMFh86HHsNf3WIvdkF0sa9Ns/94W0IpuzemDMWQnFGrRwf5iRi1X5f1ebQuLPWYrUhFIhyfep2b/2+CxtppteaHuyQbtbCp0lkJXYtSuYZkF5va7XENOPEeFWfFTUusQ2TJWz/PKNKAU4ezvph0hOiAM7FNg4TT0+H1CLFUtEVxNRjE+receikzaijRBBbs6e6xlHBpBbdZIKcn9rbYF8i6g9cTk294+T5B0bhhSG1q6Av4DUsEAVljoZNMDHWmLwyF+32UTquLxD5dfuDZh4G/67X3uAyRXqssEbl/dZ4cWOv5SdqGaIvrXFtYZ+GDHbAqYgHxMpBG2+oO58mcfDDvvkFvkA25i5Llw3JwEkhYxxgCz6CEUbKNKRsEVvGJXJCz+jGoGAbmpl655xhcikWrin3lnwmlb4/kgkcmofmAlZxQ7TQJy+X0f5v44kk6tPYI4d+Fs0wIcaXVjM+YrXzLOE0LVRdAQFqZMCiGikKh3LXSu4AIyVfRuLDOTPQmmgMV5
 Lb5QiYsW
 J8PHeq/x2dpUPW1uBw4tVbawyWaWDE3IhOppUxdHDVKzdz6AM42DXgkLPGPPR3fgk/zkuOKd/kuZuYGqWvnDNKKJSfgpcbNzJeyRQoTrGj1WkDtvZ4sXU15s8FhxL3fLmdajUStx114kNu1j/UoNIkoBlgHSd4mWq8EyT8O7qM2rTzLCq1LsdePExQPM9ln62kEObMVpM5eYqN6oSGxQMHpJ1D77eJE0NaXABN583ve8GnKKHV21BZM5LTJWYnarpW4I0ZbVboJ8GocXB09vXBE4LnPPUL1XSIMWyPG0lD1GFAK8T1jgL9CSyaFNLgZefmxLPUWoqt9ARz4Wm8rjV2ipthwqF+pNFrIai3BRdSddlKhqcv3CFVldYQGKG/MghCQxZB+PoApZWfEIlGUe6WLAYfWF7A86THzqWG25FBBtOeLfbQdB+kmyGuVYzmOfcXcJ174yBZPOcZ50cKnHN8KZbI5kgIeQF09DuTxfwTVWy4oE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/28/26 13:20, Lorenzo Stoakes (ARM) wrote:
> When a VMA is mremap()'d with MREMAP_DONTUNMAP set, that results in the VMA
> being copied, but the source VMA not being unmapped.
> 
> If the VMA is mlock()'d this is a legal operation, though the source VMA
> has its VMA_LOCKED_BIT cleared.
> 
> However this is done in dontunmap_complete(), after mm->locked_vm was
> incremented via vrm_stat_account(), resulting in double-counting.
> 
> Worse, this is not even corrected when source VMA is unmapped, due to
> the VMA_LOCKED_BIT flag having been cleared.
> 
> This all works fine in the usual mremap() case (without MREMAP_DONTUNMAP),
> as the source VMA is unmapped with VMA_LOCKED_BIT intact, at which time
> mm->locked_vm is decremented accordingly.
> 
> Resolve the issue by invoking vrm_stat_account() only after
> dontunmap_complete() has run.
> 
> Note that MREMAP_DONTUNMAP requires old_len == new_len, so no need to
> account for a delta in size in this case.
> 
> The bug was introduced by commit b714ccb02a76 ("mm/mremap: complete
> refactor of move_vma()") which incorrectly reordered the accounting and the
> clearing of the VMA_LOCKED_BIT flag.
> 
> Reported-by: sashiko-bot <sashiko-bot@kernel.org>
> Closes: https://sashiko.dev/#/patchset/20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org
> Reported-by: Kunwu Chan <kunwu.chan@gmail.com>
> Closes: https://lore.kernel.org/all/20260828094823.594279-1-kunwu.chan@linux.dev/
> Fixes: b714ccb02a76 ("mm/mremap: complete refactor of move_vma()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/mremap.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 2b4b523a86b8..7c368440fafe 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1355,12 +1355,11 @@ static void dontunmap_complete(struct vma_remap_struct *vrm,
>  		if (vma_is_anonymous(vma) && !vma->vm_file)
>  			vma_set_pgoff(vma, pgoff_unfaulted);
>  	}
> -
> -	/* Because we won't unmap we don't need to touch locked_vm. */
>  }
>  
>  static unsigned long move_vma(struct vma_remap_struct *vrm)
>  {
> +	const bool is_dontunmap = vrm->flags & MREMAP_DONTUNMAP;
>  	struct mm_struct *mm = current->mm;
>  	struct vm_area_struct *new_vma;
>  	unsigned long hiwater_vm;
> @@ -1401,10 +1400,10 @@ static unsigned long move_vma(struct vma_remap_struct *vrm)
>  	 */
>  	hiwater_vm = mm->hiwater_vm;
>  
> -	vrm_stat_account(vrm, vrm->new_len);
> -	if (unlikely(!err && (vrm->flags & MREMAP_DONTUNMAP)))
> +	if (unlikely(is_dontunmap && !err))
>  		dontunmap_complete(vrm, new_vma);
> -	else
> +	vrm_stat_account(vrm, vrm->new_len);
> +	if (!is_dontunmap || err)
>  		unmap_source_vma(vrm);
>  
>  	mm->hiwater_vm = hiwater_vm;
> 
> ---
> base-commit: aeddb4d52acfcc5ce5e988acd48f2906fe966ca3
> change-id: 20260828-mremap-fix-locked-vm-b8991ffc4181
> 
> Best regards,


