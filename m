Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 808A8C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 15:15:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 005456B0088; Wed, 26 Aug 2026 11:15:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF7BC6B008A; Wed, 26 Aug 2026 11:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE6456B008C; Wed, 26 Aug 2026 11:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B916E6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 11:15:37 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B474D1A0152
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:15:35 +0000 (UTC)
X-FDA: 85143769830.17.5270E56
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf25.hostedemail.com (Postfix) with ESMTP id D3C75A0006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 15:15:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gWZl7co3;
	spf=pass (imf25.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787757333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iabL4kgmT7SgLzPah6x1/xIKKVEsvB6N2EyVIOlzTHg=;
	b=Me1hqWhqfXSaFf/Eipytz6l76ma5Rf2vocT6g/8cILeBjnzow1synyoW0YJ2yf79tTmNVF
	JQw038lx1XFt6My6eAe0p0ho3GayUBm8UItDWK8YlCyMvlDj8TtzCHxg/bu/nSf6OyY0hw
	TYkJthibbRM1Qg82NhjCmg4be+jBS0Y=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gWZl7co3;
	spf=pass (imf25.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787757333;
	b=jDtNDOwg0SPjyxXTM5Aclby2TbitwFv2f6XhIF/ZXJ066fEOum1NdMUcb+/VZPtJcXSvoa
	ItHgpGjb1KXcnCH8mH7brrfFzELd731r6A5rbNQh2SO8hy1VGmB63397+orWRFANs8sdRC
	f/LF4cIktIKXGwFvMKsTTFrOgq0WrWs=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cace91f112so13267015ad.0
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 08:15:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787757332; x=1788362132; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iabL4kgmT7SgLzPah6x1/xIKKVEsvB6N2EyVIOlzTHg=;
        b=gWZl7co34ToXDCRctVfZMC/ujlZ7tvvzYbt1PTWSrmiskFWqO/Am/RQ3nNZRqjpbVV
         7lobGMVRP4mHH8O0viCXjM38ihlp9ufG1ToCjm3nj/sgRqj5eYSAB/olK5fL5N87f0CR
         /3FJgRiPwX5PY/i6gcp0Hz+zkzsHzgUylUOZPj1WP1uGnbfyDnndfBlCVapKTLezXGXW
         bItZegrs0yft2cZbNYWoT7r93JoNkkm8R43COfMrM4Nezw+SJtndL7y2kz4kR4rAkVN7
         1frT68ktrjsrdUASMhrI3UKG24P/hBGlxlmNXC9JqDwFyoa5IBjD7MbshfFmFeijtCsN
         hxMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787757332; x=1788362132;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iabL4kgmT7SgLzPah6x1/xIKKVEsvB6N2EyVIOlzTHg=;
        b=WfbhFqDEtKgwddK46E4QxwIAT9P9GE2FQk6H1yre5Le+r9IIFEhkK9+1bCHkBkxfZ3
         0qQM1m3NwHZ+75iH6u0eo3rpQFG6tFw2FWweZrMocua1j16uqjH/OzjgQGUIf/N1Nuvf
         uHdEVjla9FWuvXBZqIuhmzdSwrecAdI7J2vBsxddQG8ZzXiedVJpClC119OQEdHWTyKS
         anEFn2X5a0nTNfdYkak0xzQh2FWWG1J5EkMeeT/Wtl5dcgLbXn3vDOvaQmxzHzse4rW9
         N6c1FvRIzQDiHnXvIQAzJrrqC8SVvQWTe0CYGdsMD6bhiqpcNMlycw/k2I+YrEVTK2gK
         CSjg==
X-Forwarded-Encrypted: i=1; AHgh+RoGb0yLoJChr64v7tC+Yy/cqzd1zXAMN5LGEAy1sc7oQ7iTs9wF8yWjbawvUaIPMDo9Xw9CKlAVfw==@kvack.org
X-Gm-Message-State: AFuF++nlkSfcImJ2A4pwFaLgEMGQWPCTz3wgkhp2dLsz4R+VncYpv0UZ
	w4bYdSMu2As8cWlW/nbrL8UHgq3QMOSZggnp3kYnc23x2c5F71bJwRu1
X-Gm-Gg: AR+sD13EBhygSL6IPq+MynfEGWyRVgAD8xhGgAK76BsQCWJSPlhPYOJR6QYkMPTkxzu
	/axMWIeVFqd3B5B/BjzRfpxb2jbU74at7S8HVVK2TzsZvQ9hODSVhyRgcjb8xkdiKFQNIlchLvn
	V/lW70GCtveTxfqpnZsZWkKe+ivH49P6zn5wAGXIe894r5suHflAZ8cBBdcf4o5ZIlw3DumifJQ
	blZFGfPsl0mckLFEnn3OcBZ7X1h+BGcu8cpr6cscbOD7YYdlMptADQxRLLuhEKYtzOC2NqzueAD
	yTO8DIEFIS3WUPriey9eMhmZo3PVgCCN9wswv+hKm+PFZRmpWfkUOj+7lOZhQi7SLhY+adu5G58
	PInJsBpsoCTrEJ+CXTZlh6YJrSFwB7CDYNiqPaGQo3tMC31QEvboSL2hi0/ArE+Ao1Q3+obVhmx
	tAAUkUpPsJzfjoFZ/wvm26XQ61tqobejtU9jUzixNa9tHsujhmbJHroPD6xXpTqtzfp6pI3kaJZ
	ayEMcU=
X-Received: by 2002:a17:903:2c03:b0:2d6:ee6b:1b08 with SMTP id d9443c01a7336-2d707a2f363mr134001285ad.3.1787757331763;
        Wed, 26 Aug 2026 08:15:31 -0700 (PDT)
Received: from kernel.tail6741c6.ts.net ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d704baa758sm8932645ad.52.2026.08.26.08.15.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 08:15:31 -0700 (PDT)
From: Kunwu Chan <kunwu.chan@gmail.com>
X-Google-Original-From: Kunwu Chan <kunwu.chan@linux.dev>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Kunwu Chan <kunwu.chan@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Li Xinhai <lixinhai.lxh@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+f12658786a4153df5113@syzkaller.appspotmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/mremap: reset unfaulted VMA page offset for MREMAP_DONTUNMAP
Date: Wed, 26 Aug 2026 23:15:18 +0800
Message-ID: <20260826151520.202465-1-kunwu.chan@linux.dev>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260825-fix-mremap-dontunmap-pgoff-v1-1-39a40b2c98b3@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: u1nf557e8wk81hq3oszas3oi3xhori9p
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D3C75A0006
X-Rspam-User: 
X-HE-Tag: 1787757333-276270
X-HE-Meta: U2FsdGVkX1//16H4CF6oFBdVFLcjHDsvwRgtN7wT9M87o1+RTu0PjUX2QiWbq2ebhgfI35wTbu43+WEIbYN4rUyftVW8JFSP0wTxySRdS2UIW8tW1f9qLlJTraPYcoTffa2LrBT7QkpaWRe/HuZmJ/czyUeb8wVbsl4AonWlzJ1MerB6o5fHykKJ5Fl1440PQhkIaCEW++abPfwOoehouGO4NkGjJTXle6z1IT/qV/Ls94Eza5hyuPw/MKyTw/Jyk6aDdAcN1yvHBq7J0l770ePZmMwg2gyuqInojovQ7hfQ+HmRLRiSWtgI7jc481A6vyav61j+JMHRSd0W4kg++Bn2l7kc7cuE15PseWYBM1edPDXJNUMGw62HuVUWCIuLT0FewFW2c5U6AQH3lxG5HDSoEYhhZ5I2+0nxFDpiY5G+XqLwRf8FSbAdN0Rwd0Y36DTDKlUWbGn9MsVhhyQG8PMdV0OYuoJ/r4TirW55kmpnNvwXGsoDdx+e+z1Z44uqEQlojnhIB2S3eCbpsi1l1l4ycY2vPrm57PtJisekNLi+yfB/wtBb/1yBE9K4s4PtZU0zEXOaqnW69FK37OnESemasowlcY9d2ckj8Upwpn4+OfUjyxub8Q7UMao6yerjUIcgKnuDG1VYJ/GHzd/RXy43nznw+0C7T4qwR4mYZznK/qrhRGZzVEe+g2fAOz0sD0hJTHrsq3Q0KCMnbjp5LUBez0Sx2yQ6Edlj6d5DoV/e7Lo7NV1aMZG5yJAR5YEOuFlkghJWjhYaVGXiCZWZft8hmL3Nwk/zDOixzxWuv8hZEuZvELB1XvuJLB1dZqzIA67CWPtH5YF1BbuLwSBSYIFkAeuX+CZVscYjbc37zry9Dc+sATUcdjsYGLekCfvbIjyV8FB1JkRO3RBvxaw6L4otiN2uQ/6yG9rO9pJD4Sty2/RyQmt9KoSy9HtX/xWCuC+WGttUQ/XOpWJzTA9
 /l8F4rQJ
 hsVFufYHLfS4EAPDrg0kYz0DH+6es/8pG2KPg9JLSHYuSak01h4wD1Wxu8FD8OsRdgjolf7JaEN/XSQPNKNYSqOji60JI8Tvrbq04VAiw8shN9MqtcPIWBlxJ8tB3l7jWiCMydW5jsF6us4j9fxI/se/lOcyYZ8+gaendoO8oyQ3lupvF+Yx904GYztb2g3htiTBXO5P+M7LKLF7+/sxi4SdKxemeVDFbT0t6/9bholL5IBYygjOn3KLtmX4bkNEMUIrolJEJTFnuQJ8Yovcqx/5DJHF5x+6HeW1wsEB4y/Y7QTc2uSm+/kI+yXJ5D2Obrjyt+8btRV3YKuNfhYtFKZP2l9dtvepF2xEY+ZDyv2Y1wB8DKUH0B8k+mX5Jh9U7VC2qJ3fYPVhs48WIHuB1eDUBwvLNS+xpsP/XIc6w/BGH3s12b/1+MUoVA5X/eE6s52JT2sPrNzTCke+kb9s0+DwGIe1UEBVOClOpnq2RF2ftStA7Oo3wdxfOJuAdvo3PVr4hxYVR4MxFr2Wqn28wSZWia0A/Oz/MiUHxsBWz0s42NjIQDEyBdDhOnG0drtgi1FNsC0DVpEZte7YS3VaifjhZIpRaOO1FqBougsbr8djOcKvVHGpEVIJR9/V5vIb7n29o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026 08:55:26 +0100 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Uniquely an mremap() invocation using the MREMAP_DONTUNMAP flag can reset
> a faulted VMA into an unfaulted one.
> 
> It does so after the page tables have been moved to the copied VMA with
> MREMAP_DONTUNMAP leaving the old VMA in place which is naturally unfaulted
> as the page tables it had are no longer present.
> 
> However, in doing so, it violates the invariant that the anonymous page
> offset of an unfaulted VMA is vma->vm_start >> PAGE_SHIFT.
> 
> This is because a VMA may have been faulted in, mremap()'d (causing a delta
> between its page offset and vma->vm_start >> PAGE_SHIFT), and then
> mremap()'d again with MREMAP_DONTUNMAP resulting in the unfaulting.
> 
> This condition is a violation of a fundamental assumption in mm, but now
> also triggers an assert in assert_sane_pgoff() which explicitly checks for
> this condition.
> 
> Correct it by resetting the VMA's page offset at the point of completing
> the MREMAP_DONTUNMAP operation.
> 
> Reported-by: syzbot+f12658786a4153df5113@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/6a87853b.ae6ddae5.3da009.0023.GAE@google.com/
> Fixes: 1583aa278f5f ("mm: mremap: unlink anon_vmas when mremap with MREMAP_DONTUNMAP success")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  mm/mremap.c | 22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index e8df5cdb0ac9..2b4b523a86b8 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -1331,18 +1331,30 @@ static void dontunmap_complete(struct vma_remap_struct *vrm,
>  {
>  	unsigned long start = vrm->addr;
>  	unsigned long end = vrm->addr + vrm->old_len;
> -	unsigned long old_start = vrm->vma->vm_start;
> -	unsigned long old_end = vrm->vma->vm_end;
> +	struct vm_area_struct *vma = vrm->vma;
> +	unsigned long old_start = vma->vm_start;
> +	unsigned long old_end = vma->vm_end;
>  
>  	/* We always clear VMA_LOCKED[ONFAULT]_BIT on the old VMA. */
> -	vma_clear_flags_mask(vrm->vma, VMA_LOCKED_MASK);
> +	vma_clear_flags_mask(vma, VMA_LOCKED_MASK);
>  
>  	/*
>  	 * anon_vma links of the old vma is no longer needed after its page
>  	 * table has been moved.
>  	 */
> -	if (new_vma != vrm->vma && start == old_start && end == old_end)
> -		unlink_anon_vmas(vrm->vma);
> +	if (new_vma != vma && start == old_start && end == old_end) {
> +		const pgoff_t pgoff_unfaulted = vma->vm_start >> PAGE_SHIFT;
> +
> +		unlink_anon_vmas(vma);
> +		/*
> +		 * The VMA is now unfaulted and it is an invariant that
> +		 * unfaulted anonymous VMAs have page offset equal to
> +		 * vma->vm_start >> PAGE_SHIFT.
> +		 */
> +		vma_set_anon_pgoff(vma, pgoff_unfaulted);
> +		if (vma_is_anonymous(vma) && !vma->vm_file)
> +			vma_set_pgoff(vma, pgoff_unfaulted);


Hi Lorenzo,

I think the fix makes sense. One thing I wanted to make sure 
I understand correctly is the distinction between anon_pgoff 
and vm_pgoff here. 
Is the intention that anon_pgoff should be reset when the 
VMA becomes unfaulted, while vm_pgoff should only be reset 
for a truly anonymous VMA, since it may retain file-offset 
semantics for VMAs with a vm_file?

Thanks,
KunWu

> +	}
>  
>  	/* Because we won't unmap we don't need to touch locked_vm. */
>  }
> 
> ---
> base-commit: efecab401cb15fd3bb9bc05990609acb6b267ff2
> change-id: 20260824-fix-mremap-dontunmap-pgoff-a687134e995e
> 
> Best regards,
> -- 
> Lorenzo Stoakes (ARM) <ljs@kernel.org>
> 
> 


