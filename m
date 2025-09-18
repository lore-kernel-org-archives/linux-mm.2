Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AFCFACAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 12:48:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF2D68E0106; Thu, 18 Sep 2025 08:48:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA32A8E0093; Thu, 18 Sep 2025 08:48:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB96B8E0106; Thu, 18 Sep 2025 08:48:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B7EF98E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 08:48:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 474A11A01B6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 12:48:38 +0000 (UTC)
X-FDA: 83902349916.30.129DA45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 81A17A000D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 12:48:36 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758199716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YZ0NfGJRq2tFfwOVanBGqxtnfQQCUaZv/aphNtTj7xo=;
	b=gtLdQgkIvH/TtDEd5rylm2TtbiOYDez6+5UXrdYQpz8gXR+nOqE99UgyqnNOrTu2TSvkMC
	ivGhP7Koan5RQe4QMhJYXoqaAnK2tkJ3hhu0+V/fZhip4cyUwByqgfwUugGTtGsFLOzvv0
	e61LylQ9Mych+Yi0nd28nzF4WgS4s4g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of cmarinas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=cmarinas@kernel.org;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=arm.com (policy=none)
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758199716; a=rsa-sha256;
	cv=none;
	b=7KKuyzjKufeCY99mQiFbqf6lFy334UmJmhnXURpa3yNEq+XaGkgEsdohtTs5HkE2lAJLOT
	JO1bOLAZbEUPJrz+nE1ohpBF78/pG+Gx+H+wcXIqSl1mpsX2gk81+vzEkHgMXigVwitMCL
	/hWh+BE/lV7zPmIuPYb3886XodbPQVc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7CD0E6020E;
	Thu, 18 Sep 2025 12:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC16C4CEE7;
	Thu, 18 Sep 2025 12:48:32 +0000 (UTC)
Date: Thu, 18 Sep 2025 13:48:30 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Yang Shi <yang@os.amperecomputing.com>
Cc: will@kernel.org, ryan.roberts@arm.com, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com, ardb@kernel.org,
	dev.jain@arm.com, scott@os.amperecomputing.com, cl@gentwo.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v8 5/5] arm64: kprobes: call set_memory_rox() for kprobe
 page
Message-ID: <aMv_nhEuCSHKp5J6@arm.com>
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <20250917190323.3828347-6-yang@os.amperecomputing.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250917190323.3828347-6-yang@os.amperecomputing.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 81A17A000D
X-Stat-Signature: qah8nj9niq51gsqskgy5kqps5w1gpgxg
X-HE-Tag: 1758199716-27148
X-HE-Meta: U2FsdGVkX190aGJmgt7mKsHIwf0vYx0qwJ0aKnYXaYg15iEx8KdCafMs2T4TDte6CEzGOJQCtVXoFyxZNZ6/cINqiae4F3BnKdb6FK2bAum4fKcZCO76s4DthdjwSxTKEiLP+cKRXvNwXWR+QTPqmQUPplYGwfNiu6/a2JJ+z/s6SenNNmfmb9YSOTnleFADOpzrdwZxFGJasbqYwm8WFw1cvFcs5kIveuX2/lH111iJ7AwljkTDNzl1Kys6yIuNPhLNbk0wF8lacYBGV9Nssvp3Ftd7U38aLI0owsTcnAxIgzahVCer5y41URPNL0GqXS7qMJ0s1mVJYma9UrpN95a7ud2NXPAXBrf7A/+CJyJ2JsOLs+S2THQgTF638QWP8bW+H8gkmyYNTP6oYbhXvemCIK17XX/Heifvr7+2kRq64Abyt+fQw9h4AfaPlwDMlotnJ3bqlKcyborWOrRyLaIqLKFn0FOpkTI0baPv/L7ezy3abEg1gixtEFlcTo9kOEEpIoA8lK1xtBEk1U71sPvpckKuh/ygVbrckBCuMzqw4x8JWqpuCpLJMsJegYW2sdH6f9H1k+hAvLG0+jMRXIRzWjA5zHuU2WcTJ5VTWHiaRyAzSqAZa8zfYJfWEKlwxWeQUR5SHLajoNUGtYxtGcQJzMbKhZCJz69FUaMYr7da+QHjjGHHjfJ2CnDxOusGE1lVxskcCvqbCwCifd+fBTDZJitFHSsLAAj2z4IRPMeO2OIDn4C2795MIitB3bu5GLPDeIP8JOexRifvz505ZOnRIuSRh8Fuxd2AcBCRtB8nc2ZQMDblWTVKepWH58IbTN7Pm+rwAf2QGmvZTDgmOBZsiP/JSe56PQUySbLc8CJps165cF4OOzRn0NAeWa7i7i+TGSP13uwlw5sD2NgL52+7x305uinY0vESmqtbT2pV5+8Uvgrw37IE38Wh4b7LMhau21H55AzZTLH1I+Q
 MzHV/9VQ
 lLpUDF3AunM3y+7tx9DFzduhzUtkm5sa25NmHGyAB5f1jm5K08ENo4q8Clmj6jp2pXQOHOC80L2+gZHAAVoBGBFNn1K2F4Wmkno6bw2UYUoZCIs3KlPXXzdaMjlc6SL7MZxVTDQYm/sYPBk4lecaPTAhhcLOQ8qOW2w0sXHOyikyJ8xdK6e6MfdnFh0y7g/eI1S8tYFhpr4aXBTfE7IjMV0oETKsKgDComMmsuUNF2yxP3OA9EBKMvfd3eAELxXLuBeUFj2u/92QGItV6JoBADqUlZdgh2J7CqpN2JLmqLwmxKp4vy0mNVE0cDxARm6kSD9cmQY2aMapbWS/LCgDZMrljCQP51ARczSwDYQpbmFUav6GS67mwNX+SspOzvDMI9/pYD7A7XYkBdQom65cQe7s4mAKK8uaA0tTGvGjPd7QUMVhPhXtQxzqFlivJzG97VssSpcvGF+KLCSqp9G4bSiXBj2UNMkkWCJy/JOPydMtqwIs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 12:02:11PM -0700, Yang Shi wrote:
> The kprobe page is allocated by execmem allocator with ROX permission.
> It needs to call set_memory_rox() to set proper permission for the
> direct map too. It was missed.
> 
> And the set_memory_rox() guarantees the direct map will be split if it
> needs so that set_direct_map calls in vfree() won't fail.
> 
> Fixes: 10d5e97c1bf8 ("arm64: use PAGE_KERNEL_ROX directly in alloc_insn_page")
> Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
> ---
>  arch/arm64/kernel/probes/kprobes.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/arch/arm64/kernel/probes/kprobes.c b/arch/arm64/kernel/probes/kprobes.c
> index 0c5d408afd95..c4f8c4750f1e 100644
> --- a/arch/arm64/kernel/probes/kprobes.c
> +++ b/arch/arm64/kernel/probes/kprobes.c
> @@ -10,6 +10,7 @@
>  
>  #define pr_fmt(fmt) "kprobes: " fmt
>  
> +#include <linux/execmem.h>
>  #include <linux/extable.h>
>  #include <linux/kasan.h>
>  #include <linux/kernel.h>
> @@ -41,6 +42,17 @@ DEFINE_PER_CPU(struct kprobe_ctlblk, kprobe_ctlblk);
>  static void __kprobes
>  post_kprobe_handler(struct kprobe *, struct kprobe_ctlblk *, struct pt_regs *);
>  
> +void *alloc_insn_page(void)
> +{
> +	void *page;

Nit: I'd call this 'addr'. 'page' makes me think of a struct page.

> +
> +	page = execmem_alloc(EXECMEM_KPROBES, PAGE_SIZE);
> +	if (!page)
> +		return NULL;
> +	set_memory_rox((unsigned long)page, 1);

It's unfortunate that we change the attributes of the ROX vmap first to
RO, then to back to ROX so that we get the linear map changed. Maybe
factor out some of the code in change_memory_common() to only change the
linear map.

Otherwise it looks fine.

-- 
Catalin

