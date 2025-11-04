Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3549CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 16:31:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 380B78E0007; Tue,  4 Nov 2025 11:31:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3312D8E0002; Tue,  4 Nov 2025 11:31:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26EAD8E0007; Tue,  4 Nov 2025 11:31:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 13A468E0002
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 11:31:04 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB6694AF3D
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 16:31:03 +0000 (UTC)
X-FDA: 84073464006.19.B1880A2
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf26.hostedemail.com (Postfix) with ESMTP id 73E00140012
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 16:31:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DM64kJOs;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762273861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1K41FpSTyMhMwpjnLkzdwN+5hJNCqA+l7aOYaDJpwGQ=;
	b=D5Zi+4zQUS/0WGGR7WvBtuxvvT2+fjG0Ns2yswVo6KF7ZezJO9cKJrIBGy5pXagK4aGy8t
	feISYRCl80kT8Fd0ESwg3ENpWHuHdTxYuZm47pSPPzIAalkNBFP6vWfGasV49Y7moF3wSt
	YoX/ePJm8SOIAHGAzWrzRtfCWyHSkZs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DM64kJOs;
	spf=pass (imf26.hostedemail.com: domain of urezki@gmail.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762273861; a=rsa-sha256;
	cv=none;
	b=N0f/km6jVltJ1fj5yYvdHCyFFcyacbSxlDgSt8kUE5XswuNF5ugta7uhla1CzqGHGcVheE
	q7z6IFKsmyfQwrgH5qhouTn0OPjWtKz2Ps3+deiu/mwYKlZGFEfbbQGWjr4g030Aigy1Kk
	9medNR42L9w4wq7o7SXtsYrKiQlu/iI=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5942ee7bc9dso1991588e87.2
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 08:31:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762273860; x=1762878660; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1K41FpSTyMhMwpjnLkzdwN+5hJNCqA+l7aOYaDJpwGQ=;
        b=DM64kJOsiKtSpuQp0/m2Om9AFx/8s+zLNaQ3HH91E/tP1Jg7xTznP1xwkP/oq3zqch
         f+S5Qq8LluwwR+WzOHt0E8IkW2rPIwKlgMTYqFxLlbFftmDfVzaE2Gz8nDduGmhIq1Fu
         sw7/zsTM8M/xRNlIdZ9MFN54LbkdN8X3NXiUU2yhXyK+is4mPS2y8qFC4XuAmyMcACJG
         YKOYkJw1becjHnP7YnkQ69WWCv/InQVAi1QOHeoFJdGdZPd2Vfu6j8V5B6u8RXLoq0Fb
         iOTCVdEBZ/jBjGumWS6sRKmSriSo7Dw2R/G/tV0wQgHRCbF66ldp4msHOxqf+jEzb9eo
         Q7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762273860; x=1762878660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1K41FpSTyMhMwpjnLkzdwN+5hJNCqA+l7aOYaDJpwGQ=;
        b=gwKY+a7j4d127+6QoQJkJxgB3z/1kUd09MBCm8FSQc5c9NGmKRQWqb8E/n6eYi/KC3
         wHjCGWegwajcGwvIZ/qlxajClw4nlvAvTeLLV4TPkh8F0Z3VG+ubqbiT+Py8iC83XjYV
         WTjYloyxtGVMHr+oCcx25PYGIUEf0ib/VulMqxAqCLuHaLkf/Lqj+zbgyahsN6DFIkCd
         hPFhkjzvBYQ93ddoDZY453uxvzkZeKWUeGFchhegCi0hN4wYsxuK5nemrYBdsf2ZTvUt
         eQVcElKSxNJHOs2iGWMxPyj+Qb8R8z4mQgdjqp7UK2kouJlrRq3o76Ff/zGdk3Qrz75i
         bgPw==
X-Forwarded-Encrypted: i=1; AJvYcCVk6v2EgzcFCi+ym0cSVsVf4kc20hKDNO2f/zStwiM5p0DzCZ6kve/FLvvbzY0gdiJm46CAJR7U8w==@kvack.org
X-Gm-Message-State: AOJu0YwkgFFfdXL9zO++/4I+/V0RORCI6il35gVdeVeKte01PCa2JxUe
	sOkVXmyjlPi0y3hmD2KTyA1nFYhHh9l2lEbEY4y+S2o0pfYGttEtmB9uS8g22hc3
X-Gm-Gg: ASbGncuH5lbc0GfufKg0Sz61Ie57tEz37npaq5dhyMMyJii1WG4dcaTCimb+DZWxzw4
	Rux952S1bxzQGE19chzWIOfPiFRqR8181VYkbaYs+eNiKFrviPKbIE1p49bRWxvR0e4+nkRZ9mH
	juSLJYjASEDxzTWOTG2+D+GlHHGy9BxqAbVSNw/MyixpPx0yTt8Cu4NmoZMGIYdGMTMGc6XkKV0
	6/X4iUXkfLrRAimReSedHb6qxqwudAeYqNdEnYWMgTcVszhQfhHHZDq8iwpOFojExrkS83MZp5s
	xmyW0/xfuBO2LKN0yxQ1YIpdDE76XWG61eWuHXCP3LZQsbSMMg1HVWwTQtS8Yh2AalRA6ieRvaB
	pk9x/6vmM+P2FT/lgQb4bXcLDH1GY9Y+LTIDgR/VlL75jv7HgOU6oJyO/yIITuriSyKmOtDF7XK
	eyE7NbsszTxs3UD1u4JcBVqwTO90szlA==
X-Google-Smtp-Source: AGHT+IFmbm2Fq3kzbdScH8XjwPnhJY3J4MjrwW1Qn2hrU2H4RmtJEUs+hgkoN/wai1HlbLQs7HFPBA==
X-Received: by 2002:a05:6512:ea2:b0:560:932a:c3c7 with SMTP id 2adb3069b0e04-5941d51cf58mr4683850e87.13.1762273859298;
        Tue, 04 Nov 2025 08:30:59 -0800 (PST)
Received: from pc636 (host-90-233-197-228.mobileonline.telia.com. [90.233.197.228])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-59434390fd4sm839403e87.31.2025.11.04.08.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Nov 2025 08:30:58 -0800 (PST)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@pc636>
Date: Tue, 4 Nov 2025 17:30:56 +0100
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC PATCH v2 4/4] mm/vmalloc: cleanup gfp flag use in
 new_vmap_block()
Message-ID: <aQoqQA8jGygmOCpD@pc636>
References: <20251103190429.104747-1-vishal.moola@gmail.com>
 <20251103190429.104747-5-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251103190429.104747-5-vishal.moola@gmail.com>
X-Rspamd-Queue-Id: 73E00140012
X-Stat-Signature: o6mcgjbpscbncejw6td7z6emxx85w8q3
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762273861-455470
X-HE-Meta: U2FsdGVkX1/OKADxMxHuDgyZMaDIr98wBajbOJlEH2SAU3BHnUsH/mON0Zc110zjZEWISHHL4ytm6w4N/foJi9uDq79eRR9KCnI3FlaAiX6JylG7Ug6hrEBfilmDibY/woYXTabDiximwnMJjqVAzOhMxmGLFc4G8JDYaLm5gGguvsOfSxur74gcsR9CYFEgZURVVEfZRg3MD0gfZj6+YA41IX0dZHPVHbwx+tRO5Wft2fdgqd68TLTkYdtis4kpxl4QCpc9rz+le4RkZDVEF7ZN4qPC/hREP47l6MUjG8Q/e8hN7Ap7or/8mmTajUMIsAWY5lUr0acZu8QjyLy7uQ9T8toKnkGun2GRf/xRRo7W20LRbchSX6yNwC/BgKgfN0xuJG1UlrioyThGkn1EHi6ncodlM0HoLu+JN7ElCt8xzwwojAI6BJbmI4MWyQKm8mEtYk4Qtt9KVIxQtV4mF0dO7iYYBbQjPmZBuCDlOI+XVeknUBM2oXWZgbSIKMmNEvWXwc0DJ5j5G1E+DNAHUMktuRssSQV6CeHELGreH4pWP49AFsnKZ5oFO9AhlYzxLNyMz1iO9jt4U/JsEjBEWgVjesPMdzv56EyKRDMLhk0FhCsuAau6oLju3LXdP0d1kBIQk+67z3x7GNM/I9WYtST07Vkpl/QLjCDCJSJ1T3CrbVZkREyhGYJrOShcNkfM1xTRuzEYuJT8kuGB+WJA9OfgwCBRgRveALWxpcucefWvArEhcuaPzLktWCJ7TaUXvngtVpRNumQImfX6ZLZeUlCcKzJZycPrwWyxCmTaq9NSD/o65Ntvq5hwWNI2hLYxgGKwOnKDjq+bwTkxVBlviRGTx93at+aKzl1hSjhlzSTyl8qDmcBJdzHfP+rSTKVfRTnsABq1PQLuCcrmLfZvt61pA+samku24QnXqTNZH1BO3PYUkDR3VgsdHxxolsg0EsbZ4phTWRdAWxUGh5u
 uCHzVRiF
 oCtNdo4zLkDGTSwY5cDPsBqptT5gQmpJ2F0evDj/ngvwUxHFISo8957J0C/bo/yMJzISzsBsH0kaj5SI5pKApD6xiREyxTc64qKyiKGv9IrHeRGLHJS826QOB8hb9zYs0o7Hv4ifiPZcF61qpRW7vBnCK/hZPY74qrSu8tiF0q1T20TqByuQLjR1GzCkZWvHNft2ILYZsgCr6qdWpZLXfnxhqCQZtn/Rg7B8w3L+A0RnaDF69TUTsG02oCGHlyTXrXzlqyUnEp7WbOnp0WQPRgnxeu0/hr3tnYQcsQOPaV36zqROTvQispSNbZ1QUJWMxZ6+bXaa7fH1bxv26stIa6mLDNZfhRHFF9OKgQkT5dwJB/G2NS1QZsmwl5oRPueO0mvqjsMtgjJhHVmQdtKbw7L7c+QvciFL/KUqVqpsLX1BEVU9Z1sBjKucrACPzdshCW8Q2a22ao8KCZ5SC/aSkVOHOe+E+XMxBXtN9KV77APLiLsV5Uun/CzG3hzVUrioiEdfZTQHNTZpfumtGffKQ1WBFOlNDNjXfZ2jYanhU8RAmblVdtSwRUOHKAOrzf4mVpnssrxYlAbNr5WoJ+l6synmk7hzC9fCY9Wc2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 03, 2025 at 11:04:29AM -0800, Vishal Moola (Oracle) wrote:
> The only caller, vb_alloc(), passes GFP_KERNEL into new_vmap_block()
> which is a subset of GFP_RECLAIM_MASK. Since there's no reason to use
> this mask here, remove it.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>  mm/vmalloc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index ced77fc65ce3..e6cca6219e48 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -2699,8 +2699,7 @@ static void *new_vmap_block(unsigned int order, gfp_t gfp_mask)
>  
>  	node = numa_node_id();
>  
> -	vb = kmalloc_node(sizeof(struct vmap_block),
> -			gfp_mask & GFP_RECLAIM_MASK, node);
> +	vb = kmalloc_node(sizeof(struct vmap_block), gfp_mask, node);
>  	if (unlikely(!vb))
>  		return ERR_PTR(-ENOMEM);
>  
> -- 
> 2.51.1
> 
LGTM:

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>

--
Uladzislau Rezki

