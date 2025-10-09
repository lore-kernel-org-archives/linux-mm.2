Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18194CCA471
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 04:17:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 021238E004C; Thu,  9 Oct 2025 00:17:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F14868E0002; Thu,  9 Oct 2025 00:17:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E50D58E004C; Thu,  9 Oct 2025 00:17:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D457E8E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 00:17:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5ABE71609B3
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 04:17:18 +0000 (UTC)
X-FDA: 83977266156.20.070418B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 92122C000F
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 04:17:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uQa7EfYx;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759983436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kn9h52EVNKUD2SfRXi8X+QqXG6ZckuT7TbKH/to4uwQ=;
	b=MID9pBrPYcx0W8syoyZ3UQ3oC/wM7g68TvYqBURlDtLount2zhjIaPa+Z6JSA/2q5/uiyq
	C7jSL48Mi1GQ1Y/gOH1fW8rosetrzuPSKf3213JTUDm06MrQs/u49bmF2vJG6bPJ4xHWgJ
	CsDHz9kU1JQ5DTBxj+1L50QKPC+twj8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759983436; a=rsa-sha256;
	cv=none;
	b=svNLnEFPxSEuJ9z2GHgV6Cohp7pPyhl/bHksKMxo91Xvt/PCn+mPIti510KcCR/ZEGg+jY
	wNpoy+CCOZELZZ3zlqc4OrxX394zIFi1BIBI1/ijnxeZkYDuiKs+MirpOjQ8EU+6Ri5v6R
	1+Te9cmiAlIPUiynOSGocMwQoeY9QFE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=uQa7EfYx;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1AE5344503;
	Thu,  9 Oct 2025 04:17:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B67C4CEE7;
	Thu,  9 Oct 2025 04:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1759983435;
	bh=3uG/Vs/0psPbLhiDn8iBOyy3csJVGPxngDZ9WLc2d2U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=uQa7EfYx+Z7ahsddpGbj6XGhDKy2ExftXPTZ1vR+AXbdfB5egqQyvwH4Hl4rg/jXD
	 F+IU56sCCYgMpZ/5cQnza9ud0LbmMXB3F8x4CD0wVHNYZ+V0PH73Ycl+aCH3bXKGjP
	 yjn2gziGhnryGoY4+jS8lrQv/OSD4Ks/w/XRQpKY=
Date: Wed, 8 Oct 2025 21:17:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Yadong Qi <yadong.qi@linux.alibaba.com>
Cc: urezki@gmail.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 ying.huang@linux.alibaba.com
Subject: Re: [PATCH] mm: vmalloc: BUG_ON if mapping size is not PAGE_SIZE
 aligned
Message-Id: <20251008211714.5a8b9fbb57dbe454cd4a9c6d@linux-foundation.org>
In-Reply-To: <20251009035943.526-1-yadong.qi@linux.alibaba.com>
References: <20251009035943.526-1-yadong.qi@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: e5g8grzfbyxeeym6rji8yu9iz48i66a9
X-Rspam-User: 
X-Rspamd-Queue-Id: 92122C000F
X-HE-Tag: 1759983436-938884
X-HE-Meta: U2FsdGVkX18jg8xfTgNzSr9M3ErKxY4QqQzY7gP2Nb47CwF1KU9KluWRyVE04RG51bkfpXZXIAt0ttYlRV5iqew1b+XRsufLFznbURQjYtERjJRNZr/vg1e6bhnAUoxIxkMGSF89La7KdNZc0wHqdUqh9kOxxUXW4p5XpRdWwF6d/JX8hdDPxg3lbohfpWiSWHhNc5aSGaWnY2YEtGQcQo0k9UlE0gD6S6IeQpTVL1y9mwekVgEBFSaj0xu/Qu3giepOL0zY2jZ4hXybEiRbNyWpw5/hmocgOjvNNXtgtFMzGycDeSvPYwSsWL6hfOGfIE3f2WOQMr73fLMI+V26uWf4AyiIC4sVgHU04Qh0GMjlRxZa04rc63+xnKqPljBiYRQSLAotXFXnngp2QZShkJmE5ew4SzHjMq59b3AieWyLcSPndjriRebawJ1K4Ugh4gBZxFS5SJ85EgybAjseIbILwPiOFXg9XbZREpVySJ5qr9txsIKT4ngalwRnOOpPmkMX9ESNxXexrs3Qy9myoCiaHXFyEZwsCZsS844TtMHqiNM+6tdPuXJsO8w7AJU/l07uML4uc4A7W4txTKyBN7PNSavIdNzMa4IRCtvbnPJfy4oqZtbf5Z1g6MYgt8AhJ+CG71Hg8l5nCmatZINZgN+VIopcaT721ty0+Pg5pJW+7oX+QlrqyxDLpjgasJ0TcEghP0nHBIGUG6+xlLiRQunj3gM86seBK+gWZ3XxBOfoUDZG65SE83ljSaEcT/uImsgHoPBRI8oiLoRMkDNz11LC3c49a/5WYhd2stD9Ukn9gmefKZYtL8S5k76Z1VVIdxTZ6I7/UKR+wgoIOTUEMY+YiYQtzW9BSqJkxk8uKZ/Kqj60A9w9m/ohO36AJ2m+r5TQteGjyXJ4l6zsEAS5xubOt89anC54Xf3MBaxFrKrYIZyfCW0CNcYaZ7Xwxj5Ju/L1pF/siEQsev8GOJ5
 ILqi610z
 uV4T07Q3A2wXS1RFOYFFPQ2lVkpKqKF4yobNDoRJGfr+Dd4rLA//exJHPmhuuU2CtgfHYQH0laBCOXijdmBT0Pa4+5DFRdjyAqNJKEcab1BTZTRUripxfUfhPlB1r/HFO+DiAfOE+2laxGsLMWy4ekhilTwJSjGqd9ux8245JbUgIzGEQFgsh3vcXR9kUgS05n4Pm7e+uzNUQm92M+Iwo9EJEydAz57HBK606eLyqB/x4kV9BX5KNX1plMpyiW5czcxCjNgF7bm9aMdNKBM7d8xWZuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  9 Oct 2025 11:59:43 +0800 Yadong Qi <yadong.qi@linux.alibaba.com> wrote:

> In mm/vmalloc.c, the function vmap_pte_range() assumes that the
> mapping size is aligned to PAGE_SIZE. If this assumption is
> violated, the loop will become infinite because the termination
> condition (`addr != end`) will never be met. This can lead to
> overwriting other VA ranges and/or random pages physically follow
> the page table.
> 
> It's the caller's responsibility to ensure that the mapping size
> is aligned to PAGE_SIZE. However, the memory corruption is hard
> to root cause. To identify the programming error in the caller
> easier, check whether the mapping size is PAGE_SIZE aligned with
> BUG_ON().
> 
> ..
>
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -100,6 +100,8 @@ static int vmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
>  	struct page *page;
>  	unsigned long size = PAGE_SIZE;
>  
> +	BUG_ON(!PAGE_ALIGNED(end - addr));
> +
>  	pfn = phys_addr >> PAGE_SHIFT;
>  	pte = pte_alloc_kernel_track(pmd, addr, mask);
>  	if (!pte)

We try to avoid adding BUG()s - deliberately crashing the kernel is
pretty cruel to the user.  It's far better to WARN and to continue in
some fashion so the user can at least gather logs, etc.

How about

	if (WARN_ON(!PAGE_ALIGNED(end - addr)))
		return -ENOMEM;

?

(Or VM_WARN_ON)

