Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0EDED2502F
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 05:07:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DD166B0088; Mon, 12 Jan 2026 00:07:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28AE76B0089; Mon, 12 Jan 2026 00:07:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16C786B008A; Mon, 12 Jan 2026 00:07:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 054A66B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 00:07:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 694C01402E4
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:07:33 +0000 (UTC)
X-FDA: 84322128786.28.3DC8FA6
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7B1D840009
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:07:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="M8/SVLLd";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768194451; a=rsa-sha256;
	cv=none;
	b=L4rDzBla0YhZeDN/BztY3j+ew4Lk5TKkkIdrWpd4B3+SDATBrtT5wrA+/3O/pgKY/fbpPP
	W4CpW3wyP65nRK+ngvQTMRFBpT6nFT414fQFOASmzaqxRGipAH4AXMyu3y3MhSfV1VnR/W
	AgU2OKpxPqoup9whqHmatWNR/szEcG4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="M8/SVLLd";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf07.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768194451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b6PkyjLG1/r3P6ppIG7FBbw5ZG7f4C08APQiACeSomY=;
	b=xf9HEGt+Ymbe5XkWil+vNfX/rIbTA5AAI/G32Ks7Kct+rjsr0FDFpwlD0Je5t8lZo7UgZQ
	iU4UA+YkrpethbVSTMMAU4eBoqnYXyfgxq3Sf1zQ+NbcA3tmR/1dkOoKhSmpClq1UDK9dW
	+hpSweuyhweMvzNTrQ078bsbLFs5ZQ8=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-29f0f875bc5so49079035ad.3
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 21:07:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768194450; x=1768799250; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=b6PkyjLG1/r3P6ppIG7FBbw5ZG7f4C08APQiACeSomY=;
        b=M8/SVLLdh8WPZpGLZHD0jpbXXdTIbViWuFv2VHVBhwo9d/0WeJt4kT3oAIERi0vswL
         PUTtu7FpsAkNJA/T1WAI76tc1A0hJSFuBkp+5s9NDHeQBLCMj2QlcMA3Pstqg2iSBm5R
         I+28u25PYcBidEPvwync0NEjGX9Km/LwAmbTA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768194450; x=1768799250;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b6PkyjLG1/r3P6ppIG7FBbw5ZG7f4C08APQiACeSomY=;
        b=dUu4rDuNyp6/W0fabzXk/HZeycreL/7ly6ZiDFzEbk6Dt6eoCzvKqgbe3uj/Rqh1X6
         Pb4CFgdehcMLDIVJP6UCVfWNk5Znoz8r8UvUrks6Q1RmDI1S8SRxUjakG4UeIpspdLCk
         CrcjrEeTWR8ld1Sa7h2fKPPv+jlkMKoywkX2qMcddAPZIbdpCnc2qo+WUnyujtjS4XDC
         5I8kVEhJGC/BFa5nH0mDv5NR2bxokZoUeMq3VxNNlnyD9GnwrVNG3b27zyAiQAYIwNzb
         HsoLyjERpU8vYWpmnQALVR1onO8ezHU/u0NhZ474+bdhieaCsm7UrUWG6FIOgeyMmIwe
         Jcvw==
X-Forwarded-Encrypted: i=1; AJvYcCVUtMo21p1FhU75Kg0R/lsYm9AnfeWZy12vsOmnV7Df6xjSjnOOLA5+N4kg42EXiwAjWKMMpZ5UEg==@kvack.org
X-Gm-Message-State: AOJu0Ywsg7T4ZBi9AzLAq0nDyHqH6sX4uuliPFyMlm7BrTuF0Rkpks1d
	qXp8HvWgP/o02ow1e6SJFqoZTLfnCy/szSyrHsora1KB3ZTS0/ku+Urxh2t2OorXSfpzdZ7zwgi
	3MP4u3A==
X-Gm-Gg: AY/fxX4eRPzOiZmtZmyVNHcX7/kDsJPgAat5GnmjYXTVQOGApWqzeoC0AMiiL8J/dZi
	c7NWQhE8A+vsPNV0IR1RQ0EDfwf3qK4SUl8/khXjrRYTLXWQ0nrFyMu/PUgPZAPSYLGPPFWa2hJ
	IFQ2KCgdxwHG+CZjySQnZE7E8Mw40OylxK6w5RMuJcFIOakmXwRaNlDLzduyPuuUO0f1ACGCPhq
	xnhSE3zr1QElEDhPTRjmj8q8MGozySojQnYt5UP3VZuOWWtl5MALOIS2NlmPGWA7ZLEimKWW+ni
	qqAmCT/aIbXd49sIrn11uraFm62SFFs1FUTVt6YGXYNIGolOlQdxqU4bHZkasmeRVU9ufbzCA/C
	aYT+UroX9N7g7G6M7w1JkBKOuWwsgYwZnQNLug7ChzRdARy2Id3ck8hyyEaErHZ5I9EE2BuzoEh
	jsCoFXr0oEMBQ5W9xaQwJVjkh0JiRbF6OjtaecbM1HLetZsx+juQ==
X-Google-Smtp-Source: AGHT+IF3OBhKT7Yb2wm4YMmUXzUl9PyhQKaAZd+tz2ej+9fYgB/fXBXxWcTml3sDw/ZT4htds3zi0g==
X-Received: by 2002:a17:903:3204:b0:297:c71d:851c with SMTP id d9443c01a7336-2a3ee4e83c6mr145907495ad.36.1768194450186;
        Sun, 11 Jan 2026 21:07:30 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:e4c9:1271:e310:135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a3e3cc88fcsm160169225ad.83.2026.01.11.21.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 21:07:29 -0800 (PST)
Date: Mon, 12 Jan 2026 14:07:24 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <xjykydutkvth5k6vqbxhv4tozudw44dipqphnotpkrolx65wka@ugubqmsfu2ln>
References: <dou7g3n5fpynsab7hmxf4bgmqdewtdhkkiriwlghxzyduick7h@bsi3q2kivvbs>
 <aV3uXguDCaVAbY53@gondor.apana.org.au>
 <9b7d6e6292c64f21b8d09def1b6723f02faffe88@linux.dev>
 <53zplsrqc66z4ea64cosy53zvttuuhgxr2ik7uw6i2zgluegyz@d3ulgntwnyw4>
 <llj3jf5evsp7f2wl2hmm6mouqzwzolvdnu4yquhxbgsgaqvsda@ltct5tqpzmyo>
 <utnvn4oupcmohosp6d3qti54qmdppg2xfw622dq6zz7t66a6ma@2pentzdw3zgk>
 <yxpn4gan74uryy6huzulsqvqvbsqiehdqe6lu7m3hjf3tjjdop@a6cifoycstso>
 <2iophcy2e6vk72ypxeshmen66e7jhr52zr34parn4uw6vdyjef@frnpfrltrky2>
 <mldy4ayvdlmdz2c6spsmbuwiekvqtnxoj2lzg2ktehmdefsees@wdi7vw7kliuq>
 <aWSAF4s7SYjWP9mq@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWSAF4s7SYjWP9mq@gondor.apana.org.au>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7B1D840009
X-Stat-Signature: n59hwtsnserst565x9f4r3ui6xjdky1q
X-Rspam-User: 
X-HE-Tag: 1768194451-232943
X-HE-Meta: U2FsdGVkX1+F/+FtnMZXbTeH2LvI45c1XqbI4akS2EGDLIZDgGo8ARt3Ex79Klnp42CK8BTNoyaFph/g4DxxSp/pQRejfNTYngrc0RY0cDKstxHjcSynnJOikgPpqDjddyKRx03xxJxQUMImc/vnGLvsONEhToQ+ph/LmMyQRlM7fh9gPGN6x19oiJBupVq+kW36DGcXsK3io42EVmDYijtdyVk24U+mysfqk1NImZOltWpyKrgyN7LTNj+ujHF+720xq7cgphqlA967hbFEB/72jhfNVTjiyNODDu1SVMKPV8fUH5ni9CquHCuie7yCowsnGbjXclYmTQwxhZ0yTYD5H6ob3tqvIXsX/zGryrJLG1BR3DjuP/87wKJMnS4Hvl/2QvUAa7q8qQEaAQg3RiDJGIrllLub5eZbNG+Z91ZaSmSGilK1mxVFxo+EwzxnRTrMtY8J/5iXE1Y8XSK5eEWKKg+PS4HEpUa0axal+XWsNXRPe6lblhoE1LowgyI3Kh3GlzPkWNka5x+/075b5i7H5GFxGljpMgixtL6Q+w487r9RHgoL+78OI0vnYQarqk++bdWdN5v59Y7GGmgXTJLVffDvcVg58zBKBZBa60s3wS9QE+A5PzHbVNlWdCWifBSy/wv4C4o4lGDHq+7gq2CJer7gazR9z81hz+a4v35w7uP1hdoGxOPtK31R2dAauuMP8sjAEFd7ltPZkFbJfhn2VA0vWCTHfs5mWMIO5Hh2phaeDpihRc9+E+7ccDuAzZ5RSGVsquzdW5ZUdSk9DGwM7M9CcPmor8jPyQD/cFLbel/H/tPjRhOURcEvIwXRZI0m+kt1CFA0+2yXhV868tOMEkacs6qXw0NI8e1S5depOaO++zjgvHfbZEyh5v+3yaKUkzxyFkz/oU1xHNf4+hd2CfohsTU2u2Bx5eAvvqlerktVgCEBhzthVXQFH0HLPBS/zWg0OZpajeJk41n
 1N9F4C0U
 2jWBegZ4wENSIkYWtS+WMFjjkrWNlvVfyIUFUZrKe4tjsAR90t8qAaL+9boa4dTN8K7rBwsXwgtZsTu7ZxrnpprI+UvtQalvMgtSkZ3Sxq8Ay723Vh7O+6V3Yzr6GxYsWwlH/hEwl4Ng3vK75gWBqbmxjtXIIQdtEyCKTQEXSZge7gs6vHfOM9QKOZyAjDuKyzIJiO5VvYchBicImiuo175p03wLOUQOnEBnFGiIF1dE7+3PCLYnOYi5wn2BEuf8z72XnFvP8btytCjvzP0iPTsa6bvcn1Fh4VKrb+nJgNWeiEHls79ly7YssV6ROoDCG9+kystN+rrtFaJR6xVBlK+b0nHT4ve14Y3wvR41jnwpROxY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/12 13:01), Herbert Xu wrote:
> On Fri, Jan 09, 2026 at 04:02:51PM +0000, Yosry Ahmed wrote:
> > 
> > Herbert, do you mind taking a look at this? It looks sane to me except
> > for one question below.
> 
> Looks alright to me too.
> 
> > > +		size_t sizes[2];
> > > +
> > > +		/* this object spans two pages */
> > > +		sizes[0] = PAGE_SIZE - off;
> > > +		sizes[1] = mem_len - sizes[0];
> > > +
> > > +		sg_init_table(sg, 2);
> > > +		sg_set_page(sg, zpdesc_page(zpdesc), sizes[0], off);
> > > +
> > > +		zpdesc = get_next_zpdesc(zpdesc);
> > > +		sg = sg_next(sg);
> > 
> > Is this stateful? Will the SG list be returned pointing at the second
> > page now?
> 
> It makes no difference because we just called sg_init_table(sg, 2),
> so sg_next(sg) is equivalent to &sg[1].

I did it this way for (sort of) consistency: sg next follows zpdesc next.

