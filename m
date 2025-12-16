Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4894BD637B3
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 23:24:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E4AA6B0088; Tue, 16 Dec 2025 18:24:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6921E6B0089; Tue, 16 Dec 2025 18:24:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5736F6B008A; Tue, 16 Dec 2025 18:24:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 472296B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 18:24:08 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C32F960777
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 23:24:07 +0000 (UTC)
X-FDA: 84226914534.21.B56DC54
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7FA2140006
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 23:24:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vdd4D/w2";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765927446; a=rsa-sha256;
	cv=none;
	b=xKQ+TUDjFS4qWJ/8hb8H6WRsdc/KiQgXefOCuOBjODRUa27kEyPZ+UZ5VM2XSPI0dc+uQ8
	5eC2TtgySbxcIhMAKjKImkLlgrdE2KwUwXw3wppWBnEhwwXg12jkbvHsBcReSGRv+7+m+Z
	Dq+7gtRfVukRTBCA727nuzQuxTHLN/s=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vdd4D/w2";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765927446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G31AkpMZemEUvcQ+pR++1/nOv6ZIsNUGB/faxeF8AQE=;
	b=cGQjK8QpAN1PElgv23SB+3rNcN3hBj/ZveH/pwTuSDs1FZW4Oie0HG8TOy140KnDlvscvB
	6RxqXgCikcDv3zETkNEZL2zVF7qEMuDeIi6fQ/I71b/5/w6dxWtpxwcpDGu3W337vCCKA8
	lcNmMQDYDTcZVSZ8f60HokeeVHu6ZWE=
Date: Tue, 16 Dec 2025 15:23:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765927438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=G31AkpMZemEUvcQ+pR++1/nOv6ZIsNUGB/faxeF8AQE=;
	b=vdd4D/w2Y4vy2dn5sy4fDWEsqgbkF6bNKUoKAm3lH7x4SHyySSzN9PwQ5OKem0Y2duHIqf
	1+eBiaqTGhuvPQkJTbXX5oSKxgDkcm4Vi1YbmOhB7XEWYUz0seeBukaNr2z7O92dmc4yHZ
	w6DIyi1uvfAl5BIvZ92mjq3HvNUE3Dw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Deepanshu Kartikey <kartikey406@gmail.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: retiring laptop_mode? was Re: [PATCH] mm: vmscan: always allow
 writeback during memcg reclaim
Message-ID: <gweo3wdh3agfavhiky5cloweu4m2hvgzk2j2euckbka5x7n47e@ezjmx7eq7ks5>
References: <20251213083639.364539-1-kartikey406@gmail.com>
 <20251215041200.GB905277@cmpxchg.org>
 <aT-xv1BNYabnZB_n@infradead.org>
 <20251215200838.GC905277@cmpxchg.org>
 <aUENEydFvVvxZK8r@infradead.org>
 <20251216185201.GH905277@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216185201.GH905277@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7FA2140006
X-Stat-Signature: cxo8ukeyaf6kgrhcu1fxdcg99fshab8a
X-HE-Tag: 1765927445-159055
X-HE-Meta: U2FsdGVkX18vzFfd+5FNYw1j3VjQCibLEIctLFXrkMcI595Vzl0LnokabzGbNyXIKGqx49O49qR2knNNgbXT2hOXVE5Byj1ydEMQUjSc7X9pBohsX/DghO9cRFpNZLvXQoRCbdNm60nX1IGYb2mJ6xEAN+FXOywHpJXCf7qVAK1ENuRYUCEqGCNnVA57554UkjyKl1OTLiD6FSQpDasK959SvY2c2tC+9Jdto/B2/9h/JmSpWWHiPYm6F4CSMUbPCq4WkSHqsbxrHh78Djtc14DMSetLG3ogSRMu3V42lqFRb9bPhdQFMJa90d1NdzOgQxGBb/a857GoV6hJx2yBafjFVRsN1DdSTT8z9pPQzXn9kNlIrww/jzSEPya6piQ+6a39lnxpcyCa03FMD7ZdSC6SKPKP91UeE4EAP05er8cZzZvhjI2PDM4d8gO2F2B6cJIgv/gebHFoeL2MO2jDx6+pDbNXWoAe3IxVF1s6unRwGLnk9d+WzsUNDwFig8d8zViIBqObT1/VZze7ok1pM9lSaQNoT2MUyJUaNqYsN96RBrm08wBD24PR1cKIACu0GFpHNRlg6qML9SI+f4d8VUQ7j/fRrtycvMQ8GuTznMFk2nxE1Blh0CZHKVJZaSy1Jc+/cYAfgpP/xsQs53enN+QRBlf9J7KnaHRqpy7ksKfwh/UplEBEPLfF13fkgV+FruLyXMWqo+/vVIh5ex7oWYo/4etdB9+lJ6h4Ta7uT5h9ogRu+vKD9JN/x5pNug4VXlC0dA4x7ojxfDYd04ojHyO0E36ROZsOxpv2aAQgOMj74TkAXjivxe7XwGB14uRjno4CoUIlpbPA0tPkVY90b2bwJVdU6pT6FDhOfM90K5sFFdJRbgYs+vGODb5ELNtnA8zLPYfrBmUUqr25ldHv2M7YZqMgOrsIxOjpUp94y4B/h8vM5wEv90MCWPQ6hfj5XCSbNUFEWMejyXWOssU
 Sne8zNBL
 f7TGmxgXUzWZzE0B80mPjOdLJsHtO2orfuiIMGXrEWI9GQky7zAB3xwxlZ8CgmaJbnlVQqrKYvs0qT2+THy84H/zWWoLrumMiq+A8R87V0/6uORtJu3WUeVAAaCqFiXcydVV0fMgI/OcdGtzsSBQGIi0IadGpCTa8ydx0+j5HPg/LQIr29m8g64e6CtkGFfrBZ3EuyKOz0w+Dr/LRDhKFsvlrueqwXZHTMvmF9aW2xZKrK/5WVPSdXMptv/RSsXGJ3TcLpl0ZZwtWoKoOU117vm18+1cIhL7XWIry3an5rmgH+fPMdtzhIwSbHXdjTPGGrDmD01avfvG28trhG5KK9/t/wrZVD4isPE66B7y0UToEDVe0jxctvx7/WV9BULW8hhy1Z5zOaktRa9bKLKy/fNq1aUx1l2ihc+eS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 01:52:01PM -0500, Johannes Weiner wrote:
[...]
> 
> From 087f10b8046864f71ebc3a3f3316b097932cbded Mon Sep 17 00:00:00 2001
> From: Johannes Weiner <hannes@cmpxchg.org>
> Date: Mon, 15 Dec 2025 12:57:53 -0500
> Subject: [PATCH] mm/block/fs: remove laptop_mode
> 
> Laptop mode was introduced to save battery, by delaying and
> consolidating writes and thereby maximize the time rotating hard
> drives wouldn't have to spin.
> 
> Luckily, rotating hard drives, with their high spin-up times and power
> draw, are a thing of the past for battery-powered devices. Reclaim has
> also since changed to not write single filesystem pages anymore, and
> regular filesystem writeback is lumpy by design.
> 
> The juice doesn't appear worth the squeeze anymore. The footprint of
> the feature is small, but nevertheless it's a complicating factor in
> mm, block, filesystems. Developers don't think about it, and it likely
> hasn't been tested with new reclaim and writeback changes in years.
> 
> Let's sunset it. Keep the sysctl with a deprecation warning around for
> a few more cycles, but remove all functionality behind it.
> 
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Message-ID: <aT-xv1BNYabnZB_n@infradead.org>

Is there a need for above message ID? Why not put the whole lore link?

> Acked-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

One nit below and other than that you can add:

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

> --- a/include/uapi/linux/sysctl.h
> +++ b/include/uapi/linux/sysctl.h
> @@ -183,7 +183,7 @@ enum
>  	VM_LOWMEM_RESERVE_RATIO=20,/* reservation ratio for lower memory zones */
>  	VM_MIN_FREE_KBYTES=21,	/* Minimum free kilobytes to maintain */
>  	VM_MAX_MAP_COUNT=22,	/* int: Maximum number of mmaps/address-space */
> -	VM_LAPTOP_MODE=23,	/* vm laptop mode */
> +

There are 8 earlier enums here with names like VM_UNUSED* along with
the information on what were they. Should we have something similar for
this one? Something like:

	VM_UNUSED10=23, /* was vm laptop mode */


