Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 813ADCA1010
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 01:02:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4E2D8E0008; Wed,  3 Sep 2025 21:02:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFEF38E0001; Wed,  3 Sep 2025 21:02:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B14798E0008; Wed,  3 Sep 2025 21:02:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9C2528E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 21:02:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D2688699A
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 01:02:39 +0000 (UTC)
X-FDA: 83849767638.21.AA205BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2EBC64000B
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 01:02:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cftMC5e3;
	spf=pass (imf17.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756947757;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZPCuCoHnE2xN7MvZJM39hRDZjUFLfe3xbedCGZhz/hI=;
	b=AmUnuSLtWxZw++uzoxTY3hby5PXspJ0eK9HlKC8YHETFV57cx8I0H+9E7TjEB8TyupM8zZ
	zIkvHvAIWcy1CDXlM/Vo5KBaOhQkZN/8Uthu5e32bcAxrjsnsmr97FvRc4SJWTCbTwMoOC
	kzDRenAyhDJqERxYand95ttpCbHwU7k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756947757; a=rsa-sha256;
	cv=none;
	b=7B0Q84MY99mfauOIuIfrABoumDeBrVOUcLP3aYODWqO182WZoms8Bw8tZ4sfYdLySKuL7l
	DWyrR8kc8GE2Y8P9eyhkJzV7p9zkgSAEv+MLKPbly2RI1PJlNJNnJA6/SiVSPQt9XOrxpp
	3av96iKG0bqFP2p0Kzc1P+/ZAcYETIw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cftMC5e3;
	spf=pass (imf17.hostedemail.com: domain of mhiramat@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=mhiramat@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CFF874468B;
	Thu,  4 Sep 2025 01:02:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBABBC4CEE7;
	Thu,  4 Sep 2025 01:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756947755;
	bh=8nAczwppKWkmFx31kmIPa7xy1KYrypF3ToB6n147+gg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=cftMC5e3pTJknQ88YxQ8XMWYUvbmiioDE+LmlC6whHTtQihOKlFkD0DgXwRskIAQP
	 oipGG9uaqXtXJdE67auCilCzPxOQig5NUJI+BS4nyRf6nb4W7Dx1xYV1SC8eB+W1ug
	 GDhXKkTNEH89m60LLZBO6hE3rEMMmXYX839IJhrz0J8RTNXvM9M4p4FhKkK4Ybkl/l
	 hYzNeVNk/VXdO+zRuq6TpsM1Yn3NLAMgVaYOMEtnrYfF9+BFmLwmJU24PmNYvemT7x
	 54dxqqEu1B8w3MPckq4A/5dFhCIJtfOxcbyMYurVADyZivTq9O4hoAtM5sxa461dLh
	 qGpNidom8scKg==
Date: Thu, 4 Sep 2025 10:02:31 +0900
From: Masami Hiramatsu (Google) <mhiramat@kernel.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: akpm@linux-foundation.org, naveen@kernel.org, davem@davemloft.net,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 02/13] x86/HWBP: Add arch_reinstall_hw_breakpoint()
 for atomic updates
Message-Id: <20250904100231.e0bb08d069db31520a6e0435@kernel.org>
In-Reply-To: <5a6dde06-11ee-4ce7-9cb5-f0b8096e42ed@gmail.com>
References: <20250818122720.434981-1-wangjinchao600@gmail.com>
	<20250818122720.434981-2-wangjinchao600@gmail.com>
	<20250818122720.434981-3-wangjinchao600@gmail.com>
	<20250901160602.e25f0107e7b0ef4af1078fb7@kernel.org>
	<284d5eef-447f-4e12-a121-3742d708c96f@gmail.com>
	<20250902231152.442041a74774d888cec39201@kernel.org>
	<5a6dde06-11ee-4ce7-9cb5-f0b8096e42ed@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2EBC64000B
X-Stat-Signature: 4x7p17kch1x7td9cx5rfnzzqfp1ibcdo
X-HE-Tag: 1756947756-653983
X-HE-Meta: U2FsdGVkX1/FfgvSFq3NKv/Iu64SPl/oWlatLlKhdtZfXpy7XIUPK4tiztGAD/wW4hRrKtftYXjRZ0u6H5/381j62DW4TLNKq4hlhmigXL6vWA5iFjsn9YVOa2ncagOlYQPeZa0XVYPHvZ8n5aNmLveaDlCQXHqGwMfCv9+BWgb97oV4xoEMCxDnnCNvHqIlTCJ6yNs87SsSmw8VtMGe+OL+Voz5Eqqo9+PAzt3zmWw2b7N7tDSuERmDU+RgxE5VaVlX/PuenU1aqSEZpv+jA4oqHE/YALtdV/9CQmDXMETauaRuBmJMwuusVmR3rqZp+aqyG0Ism7AJ9cM7rtCAn4BFfMDwXwD/9Wb0WnDCoqvCt4O+sN0I9uteDWAyOEXQmcw5kTAy6034l5HYIYpeMalNpgMaUHIstg/SQYJi2FtTwxNXagGr9DzRH6wRJqdx9W8J50bRKQD+Zp3CN8SfH6NQIIhdybE1GiYSuYU9aTkUEvKdO9fpD+efUPDG4pQ9VQSMZQWTvWxussH6n+odNoKkam5IlJJACdcpbzXLLxap9ZTOfC54sXOxQJJdSGCtMjAeovg/HnEoEtpmaJLj/+3Yo7eqbeItxdKaCSXvzhDqTOIFkLwFIOZ470uozfBAyoAtQAlVETcu86NfkVufRDArHsWydR2gDg1NRJLfmyttVTWWLKe719jScKiWwy9rI6raJjOernaV6aKcyWxkB4u60mHGNc7XSU3jb6nALrFDET6frP+MdCYwzLnLztU3348VstmnfBhHxY7997gO43gz1ewO8mcc66lS+iuseBWDehOMB/+C9oqMU/eBGJivyeVWm948/d4OoKbrykuHB+WGrtgSYhEtwi3+rAWNu0Yqg1zvKRMdDFKrZcYkk9B6qTnStmTW8EPKkiAIxGGJc6mOb2kYMYZSXkpvX2ONzKOMKFAObpAQvoojE9R0OPxbZx18lG6oD1u/FVam9hj
 qIVyF39s
 T7VbLvyva8m0bXuZSbVVU6Yu6inOEtS+Hz1ZGnBUDWOmEePNzxy9w+M/1j4vblDsGfGv1AxG0htrK+4zKtXjFOSuXMpZ27HL6Ra72qKJx4g+uNgwaHtf+jx7EuvPGEMdGOGlcGAFZtBWZ0imuTfxfnINWL2IUjMBhACFQSAH5wg/U0jxpy6QCoIFsDbm7tKUSUzbN/SnhSlykC1UBNyxCBBuvqE3y/PDFx8TvsZFb35sdDzEh8YyfWEHTaoSFa9jyQSjU19SodKnur1+n6fwypsZg2Or4+EimeUO4RXVR2P2CSIHwPkcFxgJVLyOfU4YQ0njcK8u6pQQCWkwZzMz5B3LB4A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 3 Sep 2025 15:58:44 +0800
Jinchao Wang <wangjinchao600@gmail.com> wrote:

> On 9/2/25 22:11, Masami Hiramatsu (Google) wrote:
> > On Mon, 1 Sep 2025 18:23:44 +0800
> > Jinchao Wang <wangjinchao600@gmail.com> wrote:
> > 
> >> On 9/1/25 15:06, Masami Hiramatsu (Google) wrote:
> >>> Hi Jinchao,
> >>>
> >> Hi Masami,
> >>
> >>> On Mon, 18 Aug 2025 20:26:07 +0800
> >>> Jinchao Wang <wangjinchao600@gmail.com> wrote:
> >>>
> >>>> Add arch_reinstall_hw_breakpoint() to enable atomic context modification
> >>>> of hardware breakpoint parameters without deallocating and reallocating
> >>>> the breakpoint slot.
> >>>>
> >>>> The existing arch_install_hw_breakpoint() allocates a new debug register
> >>>> slot, while arch_uninstall_hw_breakpoint() deallocates it. However, some
> >>>> use cases require modifying breakpoint parameters (address, length, type)
> >>>> atomically without losing the allocated slot, particularly when operating
> >>>> in atomic contexts where allocation might fail or be unavailable.
> >>>>
> >>>> This is particularly useful for debugging tools like kstackwatch that
> >>>> need to dynamically update breakpoint targets in atomic contexts while
> >>>> maintaining consistent hardware state.
> >>>>
> >>>
> >>> I'm also trying to find this interface for my wprobe. So the idea is good.
> >>> But this looks hacky and only for x86. I think the interface should be
> >>> more generic and do not use this arch internal function directly.
> >>>
> >>
> >> I agree with your point about the architectural dependency. I have been
> >> considering this problem not only for the hardware breakpoint
> >> reinstallation,
> >> but also for other related parts of the series, such as canary finding and
> >> stack address resolving. These parts also rely on arch-specific code.
> > 
> > Yes, even though, the hw-breakpoint is an independent feature.
> > Directly using arch_*() functions (which are expected to be used
> > internally) introduces a hidden dependency between these two
> > components and looses maintainability.
> 
> Yes, I am trying to improve this in the v3 series.
> 
> > 
> >>> It seems that the slot is allocated by "type", thus, if this reinstall
> >>> hwbp without deallocate/allocate slot, it must NOT change the type.
> >>> See __modify_bp_slot. Also, provide CONFIG_HAVE_... option for checking
> >>> whether the architecture support that interface.
> >>>
> >> Regarding the slot allocation, I would like to clarify my point. I
> >> believe the
> >> event->attr.type should not be changed when reinstalling a hardware
> >> breakpoint, as this defines the fundamental nature of the event. The type
> >> must always be PERF_TYPE_BREAKPOINT.
> >>
> >> The event->attr.bp_type, however, can be changed. For example, from a
> >> HW_BREAKPOINT_W to a HW_BREAKPOINT_RW without needing to deallocate and
> >> reallocate the slot. This is useful for future applications, even though the
> >> current use case for KStackWatch only requires HW_BREAKPOINT_W.
> > 
> > I understand your point, so it also needs another wrapper which checks
> > the type is compatible on the architecture.
> > 
> 
> I think the wrapper should handle the type by type_slot, something like[1]:
> 

Ah, that's a good idea!

> diff --git a/kernel/events/hw_breakpoint.c b/kernel/events/hw_breakpoint.c
> index 1db2c5e24d0e..6fed9521baf2 100644
> --- a/kernel/events/hw_breakpoint.c
> +++ b/kernel/events/hw_breakpoint.c
> @@ -752,6 +752,7 @@ modify_user_hw_breakpoint_check(struct perf_event 
> *bp, struct perf_event_attr *a
>   {
>   	struct arch_hw_breakpoint hw = { };
>   	int err;
> +	enum bp_type_idx old_type_idx, new_type_idx;
> 
>   	err = hw_breakpoint_parse(bp, attr, &hw);
>   	if (err)
> @@ -766,7 +767,9 @@ modify_user_hw_breakpoint_check(struct perf_event 
> *bp, struct perf_event_attr *a
>   			return -EINVAL;
>   	}
> 
> -	if (bp->attr.bp_type != attr->bp_type) {
> +	old_type_idx = find_slot_idx(bp->attr.bp_type);
> +	new_type_idx = find_slot_idx(attr->bp_type);
> +	if (old_type_idx != new_type_idx) {
>   		err = modify_bp_slot(bp, bp->attr.bp_type, attr->bp_type);
>   		if (err)
>   			return err;
> 
> For kernel breakpoints, we might also consider introducing a
> modify_kernel_hw_breakpoint() helper, similar to
> modify_user_hw_breakpoint(), to encapsulate the kernel-specific case.
> 
> [1]https://lore.kernel.org/all/20250903075144.3722848-3-wangjinchao600@gmail.com/

Hmm, it seems that there is *user_hw_breakpoint() and *wide_hw_breakpoint()
(maybe it means system-wide) so it is better to call modify_wide_hw_breakpoint().
(anyway it is only for kernel address space...)

Thank you!

> 
> >>
> >> By the way, I have sent an updated series.
> >> https://lore.kernel.org/all/20250828073311.1116593-1-wangjinchao600@gmail.com/
> > 
> > Yeah, OK, let me review the series. Thanks for update!
> > 
> >>
> >> Thank you again for your valuable review.
> >> -- 
> >> Best regards,
> >> Jinchao
> > 
> > 
> 
> 
> -- 
> Best regards,
> Jinchao


-- 
Masami Hiramatsu (Google) <mhiramat@kernel.org>

