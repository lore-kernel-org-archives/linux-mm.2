Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A64B9EB5955
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 03:07:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0BD66B0005; Tue, 10 Feb 2026 22:07:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE0166B0089; Tue, 10 Feb 2026 22:07:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1A786B008A; Tue, 10 Feb 2026 22:07:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C29C36B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 22:07:38 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9730C1C0AC
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:07:38 +0000 (UTC)
X-FDA: 84430690596.27.1500DA4
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf30.hostedemail.com (Postfix) with ESMTP id B17CA80006
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:07:36 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=cmGwWh+G;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770779256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2kdwUSceZmDAkePxcpaC3kPf3XjbthHmmdDCwpY/AiM=;
	b=YuU2z9qbd8zydD0CXxjQOF+kT7tnctBhtiQRU26YRF3FjNW992XqZoBMIFMnSCXQs3PoQU
	VD+JSwjLYUh/vBlBLdWRYgg0IdiXJHPQ3v2yrHLmzIP+1XyRFbhff7lgPBSHMYyyQEL4Pa
	Nhd9AlQ+pRdmT2I02s9aUjXlQsbaKUo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=cmGwWh+G;
	spf=pass (imf30.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.179 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770779256; a=rsa-sha256;
	cv=none;
	b=4tKwpU9RXuuhTJsjI3GZQeIBTBADnqMczoZBgjB6PkmmsYlSNLWYEhfHmtIijKkLPXbL7V
	4T/wWPgnFzbf94+ckDZFN/N9ennN0W+++x95VuBCTGuW1QKQbrT9Y67hgy7pjwLNUFCUD/
	mQvWK8PnbtLhkHv/2hKJ15RfIT9YkP8=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-82418b0178cso917273b3a.1
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 19:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1770779255; x=1771384055; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2kdwUSceZmDAkePxcpaC3kPf3XjbthHmmdDCwpY/AiM=;
        b=cmGwWh+Gu3NPVtswP1JnmFJV3lL6Qp9X+LIK4MLR5KpFRiwPB/QacMKjBwMMObNl4Z
         T/UjYwmb9iIENq1DZwtwrrRs1OYWy/B9K4yO6EPYlHI/ofXsp8YE8yUWYBEw+9HTGXnC
         rKGx9qS7/Qr+haxUjr9PNt/kPBjMQCmhgBdSM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770779255; x=1771384055;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2kdwUSceZmDAkePxcpaC3kPf3XjbthHmmdDCwpY/AiM=;
        b=I62r8yqPYcVhUR6+Yqs8famd1V6N52OFeCAQcQ8lWUnWoYcb3Vt4TMA2CO80kkcY7U
         ttTJII2dyWpc2PI5ziF1iINQfjI6ijAymB9gI/tHV+Kds0jRBMrau2b7laqEd90bs9K/
         S56Dm9j89834q/x9JlCpQsNoScOqKFEFNoQ+jOG1/1u1B/q8esartx+2HJvdH77vNc5a
         OafCkxDtEjGEcXYeLGje0MrUKeGlKsVKG56wmMlduVZmPwUBxISAmhBWUhMFxhMWZ/rn
         Cjcio1pC75oMMeSqJCUsZZ+Lvl5A5ObASuQRN1WD/9FRULFHZ9PJrXlW7ApzjguVnQkE
         K4pQ==
X-Forwarded-Encrypted: i=1; AJvYcCUR4FvWS7R/GNAiUuNIC8Ik39vmCIFZtT4i/wLE8SGEIyU5Qjw5SayTQgpvzdPIbUJM+dXFJqutzw==@kvack.org
X-Gm-Message-State: AOJu0YxRqMdZVMdMaZ6DFsZBL9FyCG50BCZXHGEDOpXeTsaOsFPHMfvY
	3YYXMAnN/xdMPv5vO8ythrKdvnsFdtandMVdt8p3ulqCyeNknhOKUOOR+maa+I8AQw==
X-Gm-Gg: AZuq6aKtOT9DjLcRXkjcjBJaQo6CCy3HwEbIcP3X2iD4BCuROZeNsqh8NMOcncFbs3V
	dqFW93udhPsZ0GKgnp73ft8rf572SICe23vG5ppUMCTaMR9ueHkFcGygcV03BMrVWeVReMkMv8L
	rlbjdqMjGr+jwRefW0cxCEs4jveoSMEkcxYEOtQKJj8YC3lg3BPz4o801P0Q93j/jAMZ5zbrYN2
	x2Kr7ZRoNOtPRpNitDMZRQSf1CJnZHVZyaUEUN2CjGU0hCbmJFGwIlz3qxrIXT1h8kKzqxvhVqB
	yUGhbM9R6ldEdK8RkF7KCw1H/PQwC2+xCf9sBuOMjGn5OfI/Ld/OVQ/r5Rq4H7OvpnhxmtJ2yJL
	wPzArbH+j+6ijbRFqtYvp6oGmTHnyKXjlqnYUrk8IgSC0w06nCEs6QW/UzcIged4EgsyyERD9iZ
	f63hLefOM7fvGwACynTF42KPga/2rbTwLhfY6I/r8xC4R7Hssz2mJAGFY5zYnJIw==
X-Received: by 2002:a05:6a00:3014:b0:822:1dbc:e75d with SMTP id d2e1a72fcca58-8244160a9d0mr14781080b3a.1.1770779255616;
        Tue, 10 Feb 2026 19:07:35 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:ec5:3497:e96b:e7be])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8249e3af080sm423001b3a.15.2026.02.10.19.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 19:07:34 -0800 (PST)
Date: Wed, 11 Feb 2026 12:07:31 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Matthew Wilcox <willy@infradead.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Brian Geffon <bgeffon@google.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-mm@kvack.org, Richard Chang <richardycc@google.com>, 
	David Stevens <stevensd@google.com>
Subject: Re: [PATCH] zram: drop slot trylock and miss_free
Message-ID: <d2wp2s3jj4lm6shynryqwkvamyrpn3g5larn6z3yeyplel6by4@5ew3ii7v5sjz>
References: <20260210035045.3817297-1-senozhatsky@chromium.org>
 <aYtAz5vQTod7DXqV@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aYtAz5vQTod7DXqV@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: B17CA80006
X-Rspamd-Server: rspam07
X-Stat-Signature: cmorsjrpgqja8eyb3ck9ukybkb36iygu
X-HE-Tag: 1770779256-279195
X-HE-Meta: U2FsdGVkX194NiboXQLk9B1/uiD1q+R/QyT7dAEai7YAgKVV9l7f0B7tKKYS+c5LNaJP1OuM91vtC//9ONiHXiD0wnOM4vg60br9aYR3Os7FG9izIs2fXH7ljfBpqoxnrigw7LqpFyErGR1z7fw506rJJ/9ZIIGPQsQR5+GXjrwqTri8vBOqLMGgChP8xl8QVUeFHNs/h2qkA6y1CIzgRtzULfhOxHCbS6MJL3ua2P0GVlOeSId9gNC0qC2w6j0NOopLxzqRc0waDFEOEnzhq8mcjvqmjiOpCF4sPDb65LVt0PF6EdnYuz8mTAtXt6UCpfI8WpMHTZ+UUmc8oCXQ0m9c7KBa9dIhvG66NUsHqDTYxoWjGt7eRZBicQdiMQbXsAzsi1qF2DyUHgl9ZFyV873OqoudP1E1yoY5xoMnJipPk8nQeeYqW1x+fzMwKNdzMMJTj+sto6KLq2TXxbv/jtlO5fnkBnAh1W5Lgm3lSLUA2pFeIdlTepp/wuIen4m4/2KyUQ2oc9In2aTPC+fTQQZTllGX1LZiV0U4XhPnrl15lhCmPHHQyhCQDYm65ADAYd9/MKiw23vOSZ263PTfagWyk9j2eKvbla1r8K9lMgTP34252VE9LduHxnB8OO9BxyoACATpl09boFXeBO1PNmseQR+ArLzbXRvx5/8THS/Srk+J4pAndkf/LzMJWcaOSe4qbPLJrIrgG8K5R/fV4sE06Pa7WXY6a09iPZ2GOom3mXry5Qv2QDwb0bjncen8BJys7Y7yswVQNhoqEQu9bSR4mkO6jYi+Y1pq3jSsDINryhKlEy3Itnr9BprpVSi29G0yUOlWfhx5Fu9a0mwO7/bFFVp3Plykj8IAsF3Nlvlb1AtRqRe9UsE9FHK1yLFFfb+JoIag+1a1iorTbExGYdOrcSe4QssQcRuR44qEa9vQtosNfNj+moUr/NU7VGeNgQeRBqpFcqSDYRR88h3
 pw7OhXNJ
 CCkHPrcy1RRbHl52JpFguLElC7jnE9IwJpz+HuuNsDcAjQscaOrbC7jXkels6suDC0na7vMqUbj2TmC1OQG7zdHzJV0Q4oCm2uPE/MZUGldl3f8TkAiGqxxvWyfqrZSaTbWqJU5Z1jDknRbIR8gFSlPYzZ6y8w1HemnS8ozxwKYOi2OQmYSRVLLboYwUYz3UZBARXPYJ6D9K4QIgHFzBTo8gmpkJQjzAp8gvV5iGD6zp2mpRXU8Ar58xyfPdSPOLqkV3cteJ05QCFt/Eg8jZmFT0lLHb0PlO1bK4ftOowYIud1CScKsog9yhp+/TKiMnexps/CW78uVRgF0um56wrsGaHfyKdpyYxEtk7aHYwj969utmkJHtUYIheQ3LZDCRW/cYqxh1QeknrWrVN0x50UoYILg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/02/10 14:29), Matthew Wilcox wrote:
> On Tue, Feb 10, 2026 at 12:50:37PM +0900, Sergey Senozhatsky wrote:
> > @@ -1943,15 +1927,9 @@ static ssize_t debug_stat_show(struct device *dev,
> >  {
> >  	int version = 1;
> >  	struct zram *zram = dev_to_zram(dev);
> > -	ssize_t ret;
> >  
> >  	guard(rwsem_read)(&zram->dev_lock);
> > -	ret = sysfs_emit(buf,
> > -			"version: %d\n0 %8llu\n",
> > -			version,
> > -			(u64)atomic64_read(&zram->stats.miss_free));
> > -
> > -	return ret;
> > +	return sysfs_emit(buf, "version: %d\n0 0\n", version);
> >  }
> 
> You don't need the dev_lock any more to just report the version.

True.  I'll think if I want to send out a v2 with just miss_free
removal.  The objective was to remove trylock (and all the things
around it), but trylock has to stay.  While we cannot have

	slot_lock(42)
	<IRQ>
	slot_lock(42)

any more, the slot-free-notify is still called under spin_lock, and
slot_lock() might_sleep().  So trylock has to stay around.

> And should the version be changed now that you've changed the format to
> not include miss_free?

The idea was to bump the version only when the format changes.  You
normally (well, technically "always", since e914d8f00391) would see
0 miss_free, and with the patch it's just a hard-coded 0.

Thanks for taking a look, Matthew.

