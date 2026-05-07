Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D12E0CD343F
	for <linux-mm@archiver.kernel.org>; Thu,  7 May 2026 17:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F132C6B0005; Thu,  7 May 2026 13:18:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEAEE6B008A; Thu,  7 May 2026 13:18:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E00CB6B008C; Thu,  7 May 2026 13:18:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D10F46B0005
	for <linux-mm@kvack.org>; Thu,  7 May 2026 13:18:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1480A1405A1
	for <linux-mm@kvack.org>; Thu,  7 May 2026 17:18:01 +0000 (UTC)
X-FDA: 84741281562.14.0F173EE
Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0BECE40004
	for <linux-mm@kvack.org>; Thu,  7 May 2026 17:17:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Y9h1/VvX";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778174279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oQ95DAIAT7HQ2/6EmHLuku1/vpvwJv7aaYFyhQrbGh8=;
	b=0KQahxbhOx6W52KzuiDR2sf2o3i0kxUrEN8DQA34tza/lxHxLMgcJyMVJVyV9k3RxcMxlG
	kz6ro7X/Nw9usiclEE8Cf6VAUZSkWmnJ2ckS4QmP+ejyhRFMJ53h+djWruxteyYYx8WsLc
	qseEALfkJl9De5nnhaEIHE4+oLczbQc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778174279; a=rsa-sha256;
	cv=none;
	b=R7rh/iQUFjQ+s5kOrUqgdlrNHbXV1oKtIRn3/IO0/KURWtL56YGryqy9d+ieynIj6QwMbo
	mA6/dvFvICS3YfpfHzuknhokotzZgeWrn3DeFbd3NAoaxLaZ+uCRRnlnAxJw/KVaZmQZnz
	Vf00vcoD+jm8erzH7WRi0bnWoGL2ALI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Y9h1/VvX";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.173 as permitted sender) smtp.mailfrom=urezki@gmail.com
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-393800586aeso23192871fa.1
        for <linux-mm@kvack.org>; Thu, 07 May 2026 10:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778174277; x=1778779077; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oQ95DAIAT7HQ2/6EmHLuku1/vpvwJv7aaYFyhQrbGh8=;
        b=Y9h1/VvXvA/lL1Wfwsl5ygj7qPdbFla7WLQ21Vzr88r2+gch9DE/lGkoNLBRCK3DTN
         SXO9J0PsJIJ14IdHxYkr6RCkEty2boCnPLveAmE0SMijaEzW3llYiAdPQhtcOuQUmGxJ
         cz8iIyKSwpKXISofJhvPEZUtvYUzxdjW2qkS48z2Wo5zbebCPqM+MPsz7xqwfHSa9Qsp
         hgQbWUxYF7DXNz0rm8sue+kF8SiV+6YcGt2Yb5bQ1p8ES9MzUi4BuGBGmqIefr7rDfMe
         gINhw6/0PbAYEsmi9econQB+klWM6HZThaJdeOBSsQ1QbzIkSs6yqQNrMlGG+/o01Q+f
         lWpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778174277; x=1778779077;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oQ95DAIAT7HQ2/6EmHLuku1/vpvwJv7aaYFyhQrbGh8=;
        b=LdeGVyK2KlFJFLXz/Qeq4yg6r/wmnM5IBkgln2jLNpgheNnYWWqQWSQUOH+bwWsyT5
         UhhhMCIui4iHhrTMXuHV2LW5CcHuDOzJeC8yZRCn0nvyxDfGYdebf2km3XEv4qPiMZ4F
         peYAWsYhd4DhsFVlMSNp3A0OOXl7Ss462gFNt5HXEu6a7H4GuONlQkfdBThFLACPiL+o
         ADt566BQ401w9k6H+wW/YKPdtyNd9L0ozpcuFNJiAIBSc/FT4tcq5+gYWxxNRpG7zwdm
         2HxabLYKKeEOt7R6bRG0HxHluFzrDRS1M0G2pk7ko9J0pM5wsZzUigd2iZAVEl9iBM+b
         o+4Q==
X-Forwarded-Encrypted: i=1; AFNElJ9j2JOPHdA/Ko/qX9XjbrZpQgN+0oaous50Lv1kR1799iHqDLgiWyzURdrm9nP6NCdE3ixzDc7XIw==@kvack.org
X-Gm-Message-State: AOJu0Yw5oYe8bCQ3mOMo7rFI6wvxqlKAhqBVnCY/3C8Q25y8AFdlhczV
	38q/3YXJJCCoHlZzAH4PSwU8AgxmwdvOjryQRR8Q+miS/go4nABljvxr
X-Gm-Gg: AeBDieuhJpkGId2LLylLU9qCCy0w/O0wnC/ZgTz+TNztULqoigwNgwn4wDs8RvO5mm0
	qEEFK6cI+DVFFhvXefcREM7oF3vCE0KXlVrhOdQAPM9z/OLDLGWfgygqScXCU0LD8qlMaIdMH5G
	pZBldCzDhEs/eqP3jBXjrfe1Gr4HXIs3fbbkH+C/1vs2fD31GRlvwuSwHd9EOicSKFR3iV5Pk+V
	BDLznta0MHb5gI4Le38lrrIbj0ySKt5KLjXPPeI+CVazJbr7OMthLueJjcEBTjkOf7bzQ5tmMnN
	4QESnWvyzlspb3hkavJoZ8qfn/7A3w/0qEuW+K8gtFH7sTURKxN9TATpQ4q3AVYVFMKyM86rg1o
	MAqEwQRvwmUqqSNQ678vYmuVJIXpg11AgsoQmyV24BTAlmHvpMtcfA+1/HV7P3Zqv
X-Received: by 2002:a05:651c:4114:b0:38a:3498:e2f5 with SMTP id 38308e7fff4ca-393db07a074mr7377371fa.15.1778174276795;
        Thu, 07 May 2026 10:17:56 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-393ef2c7aaesm857451fa.22.2026.05.07.10.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 May 2026 10:17:56 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 7 May 2026 19:17:54 +0200
To: Jill Ravaliya <jillravaliya@gmail.com>
Cc: akpm@linux-foundation.org, urezki@gmail.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Shivam Kalra <shivamkalra98@zohomail.in>
Subject: Re: [PATCH 1/2] mm/vmalloc: free unused pages when shrinking
 vrealloc() allocation
Message-ID: <afzJQlfTYbFAN8Wl@milan>
References: <20260507114854.41117-1-jillravaliya@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260507114854.41117-1-jillravaliya@gmail.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0BECE40004
X-Stat-Signature: kdtwjz4hptqshc7y6jeihutj5jbciigm
X-Rspam-User: 
X-HE-Tag: 1778174278-246993
X-HE-Meta: U2FsdGVkX190qU6nO8hDIBiCCkgmcVUmkeZ1Hgx4bZrt0gkI1wTTqH0lB+Kjjf19x3ehCPRpp/ifwWKok0zeJ3lKOtaOi+55UBhH+RlT4oKjSz6eCNFmRhekpp+ct1hcM9BtaZBULmFvru2qz19wyODEGUyMcJj7bahXzOlc/9Erbo8+cxsKBeF/6ig+ojGcxAZzBpUSZIliOQPS1YCCVXdT9JaJmFcNbxFfcG9Tx25aXIbbP63Mz0XjYyBxnj9CiyiqPsRGjq9BKRdXoZpaHsnTxv3ryFXQu2TR3kjOzV7CuLUHP5us+6ge55RjsGkvInuJFgA9moPM788ZLi84XfFz3OjlbZMl0cnBTOJlL6niBnwK1AO6SM2k1nvUMvH/vNqpchbBqy1FbUSUltfFmLTNkJ8SNB+WFo5az0slOxw8cqcGVYHnBc9NbHFlHY+kXwFHahXbBw/GRYAi2TDM3n37fO5K8WFNTlIV6zn8sczrLHTc/tSMaKM8Qtl3Rql7Qies+pwhqYJKUe69V1goY+OSXAVZ8CUqD0HBlC2ZnH+TcTssETdPg6TpfKDCpnQPcTfOH7LGft7nKu9vXBF66rjuAkfLDUxnQ037h47oxDsyIXWKRB7MonQ/O3BlV7IPAgmOPz70IThk0S5/OVyyx5aOnzmVzja2UaHimj73bORdm8IY7RY3VzGqrPuT0m2s4OXEw9Z8/8QEvNIirklCovRvVm9cz2h6eaT0o9j5+zbCCrobXdPO37pU6Tsd/VnEn5LuQMl3zsIVb7+aMv9re7hc4PLSngK37wtUJw0211ZLt3oZ0x2FL+zgmp4a1kkAPXlclbKRwOWLz9ITL6PEASrgLz7UiyO6iT5e6L50MTjx2rsEa0PIhtvDg9t1IHOgcaZxcf22G5aDAmKufcX9pHOqaQxvoyl+FDR9WveMPA+f0dIOZbnDMbXr49wDT7Be1cozy0NAE64XOBwaAjc
 y58jqIJW
 ldSn/Gy26WBeVoUlEyYrjtlUCI/cCeduaYLxv62+offNgeXPsbQMiyksyRK1OM3LYku8wYdQoiPDYVhko9MMrQjAUEIRWJ/Q6ZNTAzdHIceW867zcaFalLb0uo6tC2i/GYqhl6IeCIxS8rEie3R1TD2DzLvz3TcefoQvLT0t3z4qeIwd1u5uXooArjBWVtY1u5Y+mteJ62iA3hC03rgjnoa4lfgEKSW4St2xAafXrSBgmuva9GgFR2UrUNjVGQFnliVgCOlP4MdeF0auwPCKG7/Ig4WQPCT8sNdT483Tjrg6NOkAhF4VrbzD/qfEoLHNnBvRHuxO5nxSfbRdoqteUYvHTcu/t/wztaXBuNYmx8G+tTwsgH1CUtLyPhXy/2f33pUSAna/bnhFb4TyVFjlCUQFCTCcGj8zOSebMu3pa0Dk1fsPt9SfeKpAUoZ2mXzBsJohtWVp0EIl65xdU02C4bJ67GfmDFIAYRuiQz4bBg5WJsro=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 07, 2026 at 05:18:53PM +0530, Jill Ravaliya wrote:
> vrealloc() shrink path zeros unused memory and updates
> vm->requested_size, but never frees the physical pages,
> removes page table mappings, or flushes the TLB for the
> unused range.
> 
> When a caller shrinks a vmalloc allocation, physical pages
> backing the unused portion remain allocated until vfree()
> is eventually called, wasting real RAM.
> 
> Fix this by unmapping the unused virtual range using
> vunmap_range() which also flushes the TLB, freeing each
> unused physical page back to the buddy allocator, and
> updating vm->nr_pages to reflect the new page count.
> 
> Signed-off-by: Jill Ravaliya <jillravaliya@gmail.com>
> ---
>  mm/vmalloc.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index aa08651ec..a8cedfc5d 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4336,6 +4336,27 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
>  			memset((void *)p + size, 0, old_size - size);
>  		vm->requested_size = size;
>  		kasan_vrealloc(p, old_size, size);
> +
> +		/* Shrink the vm_area: unmap and free unused pages. */
> +		if (size < alloced_size) {
> +			unsigned long new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
> +			unsigned long i;
> +
> +			/* Unmap unused virtual range and flush TLB. */
> +			vunmap_range((unsigned long)p + PAGE_ALIGN(size),
> +				     (unsigned long)p + alloced_size);
> +
> +			/* Free unused physical pages back to buddy allocator. */
> +			for (i = new_nr_pages; i < vm->nr_pages; i++) {
> +				mod_lruvec_page_state(vm->pages[i],
> +						      NR_VMALLOC, -1);
> +				__free_page(vm->pages[i]);
> +				vm->pages[i] = NULL;
> +			}
> +
> +			vm->nr_pages = new_nr_pages;
> +		}
> +
>  		return (void *)p;
>  	}
>  
> -- 
> 2.43.0
> 
There is already work to address this: https://lore.kernel.org/all/20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in/

--
Uladzislau Rezki

