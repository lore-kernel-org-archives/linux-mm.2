Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6FB6C79FBD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 17:23:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E9E76B0099; Wed,  9 Sep 2026 13:23:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1E46B00A0; Wed,  9 Sep 2026 13:23:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8716B00A1; Wed,  9 Sep 2026 13:23:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 600106B00A0
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:23:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C6761802B3
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:23:24 +0000 (UTC)
X-FDA: 85194895128.08.654B63E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0638420002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 17:23:22 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bDYa0m6y;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788974603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MCHSdPZk4zbn59kxK4VxfMJiTngtjItSycfJsFzJGs4=;
	b=fMSuDsRAUaWpN3bAUcHsL2WijuUb+m91zuGG2t5Y8+9UCvrKotkDlCxz6acXeuf5bgdfw3
	QW7SzJG/jQtSDSxujbREs8yxzceqHqnq6utnfSeUW7tL52B46Qir4OaDFSkROktMt5/O5d
	ExhFcU3hE/+4rtIvT7K2LqobmTJEv+M=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788974603;
	b=D7rIrJky6LJzCWJnzMd3qkaItOc6F5hljhhHMGKaNKGFqxG4Hd196aaokRRuyVjYe2IH99
	VkQMDugNl8oRp4+7hZGaTJTfROT1rbSaT7LX+WG+sJQLLlTVbplU2felZia4in5Pcv4Uvw
	4SQnKd3Fb1xMrOG83KeZYPMn/rYb1gk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bDYa0m6y;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4D8EA43D6A;
	Wed,  9 Sep 2026 17:23:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 563E01F000FF;
	Wed,  9 Sep 2026 17:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788974602;
	bh=MCHSdPZk4zbn59kxK4VxfMJiTngtjItSycfJsFzJGs4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bDYa0m6ymveTw0HTGhDflIHkFJVZ6GnutFwAxlS0dnTV93M0i+vTGPjDB/xLJrUNQ
	 1a0DPsSCrlJe2SPeOdeGGqCukduQ+BHvb6mMYVy4+V4ZLwJWeT2XDAckf22U215/P7
	 hUHXF+M1stjZ7/4DPBQw9qxLMfak2L3FlpuRHlpJ+c/2EgbEpz2gLU0GyRgmO92zlA
	 ZNKBf+MuuUntdCZet/bCi1BSWnv0+EUx0ZcJJd6V4JezjZRGitiNmaGuuxRIZk+BGw
	 SHxdlwNKF5h85NTEXdvIIhjzcNbqGPJEdvLZVa73xGq4hC7cfgCi68gUdJfX87c1eO
	 MlaqchPPFVn/Q==
Message-ID: <19e428e5-d8bc-4abb-b052-e23442464cba@kernel.org>
Date: Wed, 9 Sep 2026 19:23:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] proc/task_mmu: read proc/pid/smaps_rollup under
 per-vma lock
To: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org,
 willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
References: <20260907063918.3432401-1-surenb@google.com>
 <20260907063918.3432401-5-surenb@google.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260907063918.3432401-5-surenb@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 93byxpmoobo5b1c6gd36esh8e6cuf6m3
X-Rspam-User: 
X-Rspamd-Queue-Id: 0638420002
X-Rspamd-Server: rspam03
X-HE-Tag: 1788974602-888370
X-HE-Meta: U2FsdGVkX196lkHOKHdjv758UP7EQ/VggD8gkW1bbEY6+NaqBAY2/Xinv0cQVgQqhSpOvrm7vswI/jRAaFc3UDL6qWlKHulYHkmXDjpAW8x8me8moFRAiBUVGKAriRQiI0YLJIUN/UFNAqhMWFjf2NbjOEQ5tVdnbfq+926xaGdLiXNsIKiHRJeQ1gar7CX0/npOKEr2ARO5dtCOgpJuD4QC3vEO8Hn1Rvmp5V6LwmRvo4WGIyGWC5JOsG+n2MIrmEcqSonzqBdR466fytSb+kxAeqUv+WRRgs1BsysivvBTKPd++ItEYhmUV3QiuqfxzcHCEsVsk1+IotEwrfypaOFIjrNxZRhZlBP7Ujtiq+uLSo0L+AlhwAuVDT32FHgcAYUMFTMScIkgnGExg60V3vf24iqoYQLKYNyoRO/kq69ecirbpEbL8i40ZpAJpd6nu2R2wLix0RxmgJqBdrDLpcqMTpayJPy/o6x51Lj7eBig1wFwLrc2HyDbkrbANkhuDgjK/51lb01mj/z+Hap24EXERtuwluRi/eCJ3s7cBlflZWPD6FUZUT7FlhvhSd+iPnWx0VgGwD9NiD3Qm91nSSy0j+9SYr9F37/0WHyYRHWkbU6/1lCKGcs4tT9KJxjZgrlTlo8QrmgNDPZAklsYLhczPQKDf4ZfglhY3lPRsy2uohafoIlY83FEwCyeywX37LaWXqXDneIXuPmoUQ3j2FMRJyjak6Y58J+1888HHj/LBaaV+r1lTM6hY6QwnVmVcxuVfqyDK5wGOYyDk5iUG0uxr6aCNoJaNlDsXpAzVOYdk2aw8Yi0oJ2HBHQjyEpDoUBaHF270yiiTRIKgafku0HOM22Oj1ThTqbIMBwn+8G/IFrIUvj/ddKmmJBqBWmNidJNhXJv4RgvWnuuZX9Rj9X7hQZnB8ZlLoXfGVHXjAWS7G6j3FQfoYJg3Get2wMyFOPSjxJ7SDkxFlgTTRk
 g9HuVrLe
 Iz22MxteBpxvQQYYV5TZ+FNLGOEQh9e2b2Gm4gf2EOI2h2SCJskBkH+ewtAav/3FH/KxJysKwSZrub370/If/3K+Mcv/6yiBiayJYTpEBi345Jriqy8rgQFHYCU9M97Plk/ecLqeeIkugWXcVZqzs4rSxvdB0uvBEwS7Vks6b//g0hO9TvBN9FyJLs7/jqiwxAvC6vMWXCg5JTISxvJfiM4lfQw46lk/OBcBdab9R+S9pSAMhqK8ibWMh7iQdDqT0RsrU3nMWkwN/yyjOgn2ihdgEXjzfDIU1XtppBwM3N1D9B7g2mY35EBEV6A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> -	vma_start = vma->vm_start;
> -	do {
> -		smap_gather_stats(priv, vma, &mss, vma->vm_start);
> -		last_vma_end = vma->vm_end;
> +	if (!IS_ERR(vma) && vma != get_gate_vma(lock_ctx->mm))
> +		vma_start = vma->vm_start;
> +
> +	while (vma) {
> +		if (IS_ERR(vma)) {
> +			ret = PTR_ERR(vma);
> +			goto out_unlock;
> +		}
> +

Can we add a comment whey we break (and not e.g., continue) whenw e hit the gate
VMA?

(I seriously don't kmow ... should I know? :) )

> +		if (vma == get_gate_vma(lock_ctx->mm))
> +			break;
>  
>  		/*
> -		 * Release mmap_lock temporarily if someone wants to
> -		 * access it for write request.
> +		 * If after retaking the lock, already reported VMA grew or
> +		 * merged with the next one, smap_gather_stats() will gather
> +		 * stats for the remaining portion by starting at last_vma_end.
>  		 */
> -		if (mmap_lock_is_contended(mm)) {
> -			vma_iter_invalidate(&vmi);
> -			unlock_ctx_mm(&priv->lock_ctx);
> -			ret = lock_ctx_mm(&priv->lock_ctx);
> -			if (ret) {
> -				release_task_mempolicy(priv);
> -				goto out_put_mm;
> -			}
> +		smap_gather_stats(priv, vma, &mss, last_vma_end);
> +		last_vma_end = vma->vm_end;

I skimmed over the remaining bits, hoping the VMA lock experts will review in
detail :)

-- 
Cheers,

David

