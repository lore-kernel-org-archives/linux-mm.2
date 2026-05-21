Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3482CD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 16:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E1C636B00A9; Thu, 21 May 2026 12:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF4146B00AA; Thu, 21 May 2026 12:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D320E6B00AB; Thu, 21 May 2026 12:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C3A066B00A9
	for <linux-mm@kvack.org>; Thu, 21 May 2026 12:40:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C0C9C241E
	for <linux-mm@kvack.org>; Thu, 21 May 2026 16:40:40 +0000 (UTC)
X-FDA: 84791990640.27.5220DA7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id CA44680005
	for <linux-mm@kvack.org>; Thu, 21 May 2026 16:40:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fG/Z7QUp";
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779381638;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2YGGMyXe7SMejzK+iwa7+2TNKMnNR9YtdBRWN/ulgbU=;
	b=Nzz7FJAOvfjXI02J8o6kYId68hxG7cuIIg+2p7CWcoIdc7MSb7fJzDNLabOPkdmz1dVTFj
	ZYIMx5Iyd0NukF9Ga+BQ0KOm0Dn/nBSvqy1LQkeDHmkKb7EdmA+LwWnioZDO1vDAvfAWgz
	V16sg38booVlheq2P6TzkiefsqmVfCE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="fG/Z7QUp";
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779381638; a=rsa-sha256;
	cv=none;
	b=BWD2Jdd7DErcvBVZlTt2OPhGud14Ix/2kvnG8bXrWKSc3ZeWyY1K1bkaMztZOxEeU5ccfI
	udRiywMTl/E6rp4Sdntj6S42dIMF+ZK2VQkjf0yi2Qfuxy7M6zHKBa3hTU6zGiPkxCLzk8
	YpouXCe/a7obLz9mvXM3h81p+8F8WXE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5802360098;
	Thu, 21 May 2026 16:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8051F000E9;
	Thu, 21 May 2026 16:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779381638;
	bh=2YGGMyXe7SMejzK+iwa7+2TNKMnNR9YtdBRWN/ulgbU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=fG/Z7QUpeZCEYhug5SVVxPYIo0JfhG3m2rPSBOkh2oi7CZgxxvB9zjFWuTOIVy5cY
	 WibkXJmWrgbFkp7QHACq5F6Iem5WFdybG71CCCQXQRLn6OhOj1sqIbllxlDq9rWych
	 k/HgBFcenei9SY6H7SZBfeYEoV3FeNc6blqLlL/dLvy1wOk+hF5rkTY6FpmDroESSW
	 5gLmhOhlH1x6Gh56UTM5lm9dycJvAAQL04TK+0rmz+Rz4Y2SqPQWmV9PN+UGN/P2dB
	 +kLiHstSBHah9ZoE5aC8tSp9SoddkWbQWO5752L+NPURwmmY3x7o3FCOiC+dqEGYM5
	 I58LauGj0TyDQ==
Date: Thu, 21 May 2026 17:40:32 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Waiman Long <longman@redhat.com>
Cc: Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-rt-devel@lists.linux.dev, Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/2] gfp_types: Introduce a new GFP_ATOMIC_RT gfp flag
Message-ID: <ag8zX5KJUKo70TvG@lucifer>
References: <20260520204628.933654-1-longman@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520204628.933654-1-longman@redhat.com>
X-Stat-Signature: xn1zmrin453w95m533ihz1cjot14knoq
X-Rspamd-Queue-Id: CA44680005
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779381638-417295
X-HE-Meta: U2FsdGVkX19dFB+TPRHEXJZehnRGyq0kyygGFGbqr7Gftu7GycVnXNzBHFmrV/BKIINSaKGsXufBXjnf8n62en0/HQjCey6BXefc/E0WswVH0cHcvNkkUfVF10AzkQo9JBPIbCNkmEbFs4w3Zq17X6o97nii/S+zrSW4hXlUmBT38Cl6TmuDIXfLO2C7wOXLEAHq7mojGlQhd/Q5GCmcaGOmAkX9C1SyqSiRHXu31fimzYSsBXSEVjS5uXfWoFIxavSIWPdX0dS2atCJtHk3CGFlZCrKoaMgO/NNPo5dW02Bjpl4hY8lNelg+C/jm4m+NHVUrXVHYRsJPXD4YyQR33hiEQ+aU/nSViBGbozp3mm9r7jds7jK7RIOHchuXsqcP/9B1Be/kAOZe4WpcLLfz729JmujJNkstHyyGQBYDqTii49MojkNg1C4Z1BGdDDiOv2KbKjWOKSky0SbBiroHtTYxwjve7oqwNnol0Wu0SjDKBCfH9oBCxuhOkBa7LnHEM7Viqz2JtAo5QlFx/haC2OIpOxuX2x2oXaAAyD7nNE/RPsuYChcj6zuGo6EOXdImd9DTZncN1lba/sHEPSjdHeyeLlYT/6QBx35MUQiPlSe7Kal6GoJr9pASXc4GWtzMx0V2A22DnuXgtVbGJ+39wKmVoN/mGO1OUkyxWtGKvb4dZxfAUGCXqzRRy7ukbE28lSVNukTaxb8FEa8WAqhryBTkpV2+KTMGfM1Sx2CGkjGTkP/3SMDbVbrRxltUAUAn/QUPdLXkREqyn65WpU+AkltfuUadXuncREGDTaPnbrOrOMksluHtwFaxqLMqo98Ymqgspe6Ob3LqaoA6HRZFle3LBfC34BGFVJmgtCo2jLjvitg7JXnAMuawm7+UucuyCM3YEruNk0AqNmM+td/fnNe03Wk2OjFweK7Sj4R8IAefnctT1UxkPyzGVUezloz/vq/dvUImkByDIIC5ap
 CHQNvyjP
 cNpzJFNbSRqzvM6plyWEB/VgtlvggrM9FZ/4A91HJ4nsdhP+5tGZt0MEPl53FlIetKAb4uw2RVnTko2/0pep9sl4KcT2PcgkMKcazJ/BRZizbwos21ljx9qG4jTrdjjOzSSkGURnIU7EW8gQ5rH9u0oxzb1OhUaWzMZQVhNF5pdaW3gq/gGZx69rcJWZE0d7UMMfl7SR/hN/phZfGLeBZJoRb5v3bP6sXPSnbozofJdKQOSF9JGcFWfhJZB2Fmav48y44F60ikdIW3ztctpD7zK/w4vg7p7h7WesyfyjWYhQcVxpk5r1MsiyNvAUfhdxEEgXp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+cc Matthew who has fairly strong opinions on GFP flags and such :)

Also, please don't send 2 patch series with 2/2 in-reply-to 1/2, use a
cover letter + have patches reply to that :) [yes it's one of those
subjective things that people differ on a lot but generally how we do in
mm]

On Wed, May 20, 2026 at 04:46:27PM -0400, Waiman Long wrote:
> The GFP_ATOMIC flag is to be used in atomic context where user cannot
> sleep and need the allocation to succeed. However, it does not support
> contexts where preemption or interrupt is disabled under PREEMPT_RT
> like raw_spin_lock_irqsave() or plain preempt_disable().
>
> With the advance of the ALLOC_TRYLOCK allocation flag in the v7.1
> kernel, it is possible to allocate memory under such contexts by using
> spin_trylock to acquire the spinlock in the memory allocation path. This
> does increase the chance that the allocation can fail due to the presence
> of concurrent memory allocation requests. So its users must be able to
> handle such memory allocation failure gracefully.
>
> The ALLOC_TRYLOCK flag will only be enabled if none of the
> ___GFP_DIRECT_RECLAIM and ___GFP_KSWAPD_RECLAIM flags are set.
>
> Introduce a new GFP_ATOMIC_RT gfp flag for those PREEMPT_RT
> atomic contexts.  This new flag will fall back to GFP_ATOMIC in
> non-PREEMPT_RT kernel. GFP_ATOMIC can continue to be used in contexts
> where preemption and interrupt are not disabled in PREEMPT_RT kernel
> like spin_lock_irqsave().

This seems like the wrong place for the solution, now we have to remember
to use a specific GFP flag but only in one specific place in some IRQ code,
yet RT is fine with this in any other scenario?

This is really confusing.

Wouldn't we better off with a way of actively detecting this context
somehow in the page allocator?

It just instinctively feels like this is the wrong level of abstraction for
a fix here :)

>
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  include/linux/gfp_types.h | 13 +++++++++++++
>  1 file changed, 13 insertions(+)
>
> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> index cd4972a7c97c..ac30882b6cd4 100644
> --- a/include/linux/gfp_types.h
> +++ b/include/linux/gfp_types.h
> @@ -316,6 +316,13 @@ enum {
>   * preempt_disable() - see "Memory allocation" in
>   * Documentation/core-api/real-time/differences.rst for more info.
>   *
> + * %GFP_ATOMIC_RT is similar to %GFP_ATOMIC with the addition that it can also
> + * be used in context where preemption and/or interrupt is disabled under
> + * PREEMPT_RT, but not in NMI or hardirq contexts. The allocation is more

I'm not sure 'GFP_ATOMIC_RT' really communicates all of this information.

> + * likely to fail under PREEMPT_RT due to the spin_trylock() nature of lock
> + * acquisition. So the caller must be ready to handle memory allocation failure
> + * gracefully.
> + *
>   * %GFP_KERNEL is typical for kernel-internal allocations. The caller requires
>   * %ZONE_NORMAL or a lower zone for direct access but can direct reclaim.
>   *
> @@ -388,4 +395,10 @@ enum {
>  			 __GFP_NOMEMALLOC | __GFP_NOWARN) & ~__GFP_RECLAIM)
>  #define GFP_TRANSHUGE	(GFP_TRANSHUGE_LIGHT | __GFP_DIRECT_RECLAIM)
>
> +#ifdef CONFIG_PREEMPT_RT
> +# define GFP_ATOMIC_RT	__GFP_HIGH
> +#else
> +# define GFP_ATOMIC_RT	GFP_ATOMIC
> +#endif
> +
>  #endif /* __LINUX_GFP_TYPES_H */
> --
> 2.54.0
>

Cheers, Lorenzo

