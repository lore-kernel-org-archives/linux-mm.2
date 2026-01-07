Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 526B2CF6BE4
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 02:22:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B83D56B0093; Tue,  6 Jan 2026 21:22:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2DDB6B0095; Tue,  6 Jan 2026 21:22:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A46E06B0096; Tue,  6 Jan 2026 21:22:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 94D9C6B0093
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:22:48 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 502B2D0FEA
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:22:48 +0000 (UTC)
X-FDA: 84303569616.12.C2D351D
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 71EDB1C0008
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 02:22:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=RCGecQ1O;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767752566; a=rsa-sha256;
	cv=none;
	b=YQScYfJKCb0v75SUE8NDUQSDBHXRs92ho1NO+d7OxzblYDgj33aLVOQ8dCXq2VWnMoahk2
	ycuTgjrjj/2pp+K3zplY9E9SZY/9DptL8Zar4xkxuf+RnVrvCjS+XGikj7hOh8w405N1dS
	/aHRJuQC86ThTbKfqqR0rqgfjd+TcPs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=RCGecQ1O;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767752566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6qNQY/1cbrAgw6PenHCAduoE6jEXlXO91fhInBLR2CU=;
	b=jd4d7cSVvTNommrGfwMn2FezxqSVQMhWEuR0PqVmUYuYIFTvwZYj9QUQzycLjAdlmamiMU
	rBcUGHtZI4UVPo0EwpG7JZRw00HW4ksbb4gNHxGhg0VN2H0wAEAAZ8VAJgVDu6NgzGJ1qK
	sdKgakSv+3WNruh2yPSc5PT/uHVzcv4=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7b7828bf7bcso1487181b3a.2
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 18:22:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1767752565; x=1768357365; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6qNQY/1cbrAgw6PenHCAduoE6jEXlXO91fhInBLR2CU=;
        b=RCGecQ1OA0x5VhtTFgnvM5zTDoz2AJuIjc6ylq1+aAuNOwaa/bsmKXwtmCHvAUcuxO
         lVdFX5Ed5Yw1slXNEAVasctO+Oj6pd8RpbHuCVxql4qJ/4pkKCqhgWy4MMARAdFYgYNB
         2tRZ6KjMSSfwEdjRvj/GwtgLECQzFH3ZYE8IU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767752565; x=1768357365;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6qNQY/1cbrAgw6PenHCAduoE6jEXlXO91fhInBLR2CU=;
        b=jwHeJKK7kQTwqzMB7t0z1/W1fVM9alYnPzNpzGCbA1SuU2MKiKo5alziMVkjnQ9r1c
         fCIXaz2SklAv090NNqYyDlmifRqDQeIza1pcvkI03wexfjcnZF2d5Yfo1J0q+YSLOPe8
         5jW1ffvpIo+Ch5Paa2yr26GOzI9H8Ep/Yoih4yv6CJj6L00PMKleqxyitBJ/jxsqrftu
         p4ioOLyDTMNOUC+j1gIYt0ylKil6KNvA8Jyi3tNdGlWE8iX4U/7hMaV7TLBRG50HI3ug
         Bl4KTTDkafCzMgXq1B65ihiuKyntOXOqJ8f2uoDXibNrCmOGflMcU87cqG80tX2O8Lnz
         rbKA==
X-Forwarded-Encrypted: i=1; AJvYcCVTCSBAhAxsFlPAbMI4S3x2DH6XfDVB7hwQyhzB7IWQ7pxjI/ETk4ECRFvaCjWjxiGj61MnDWm1pg==@kvack.org
X-Gm-Message-State: AOJu0Yy97aomgFtzm90EOeLxpE+H6+FUFWeC72fag/D/CC4YMrAtqk5E
	OmQ86haMMul7lvah4wGLy9zPyqvXFgISQWlnSDqIDFJn2XGspEGNKpmEWbMYdwMl+Q==
X-Gm-Gg: AY/fxX5uFMKNtKTSBRSUHvnC+CkvgElJdM7fbm4ipLqpeg9Za+Hn4NtDczsPXDFDY0n
	UMk0PEn0cRliR6MIufI1/nS3R55puX2jy+O+7Zb3AWhJPqEIS4AUAS5AYOzg878jgnrWPCilHoh
	iVcNAzVls3AxvZ8uHbB1luK84YluZ5+dVl4KoXLaVKh3qnGJjsBoICrN6nXeYkbTc8ZUYotdoLz
	ELqZS8d2cjSWMoGSjYI2gpIj6ae/mtKCGJSyl2bXKJxYKMe8NTvJzA5MG3ExuXVViqas5Tmx3SV
	psdfRnhgn2ndY7rFt5Qila9pU1cxkFIphc8PfB4eJeJVkzIIBV2+g0WkRPHzKoRtVGU3uVBLuhn
	nTM41Sjw/RAfyhwOI8WK9ermG3Lm3Zh9xxUee9+C77PPmtNF1KwTLnF+5G7QbaLpsduxTgNAX4q
	Xfvmj8q7AvjCHBzeNoqnPA8aIDFP7tSqUO2NojM3fxFpbEBVg4HPw=
X-Google-Smtp-Source: AGHT+IHQAIVX/b/hKB+gMcH7GDPoOjzFSsNC4qeoW78ORNzfSGWGB96zSou69U2ob1+Mh+jfPrFv9A==
X-Received: by 2002:a05:6a00:2999:b0:7e8:4398:b372 with SMTP id d2e1a72fcca58-81b7ffd81c8mr1015998b3a.69.1767752565365;
        Tue, 06 Jan 2026 18:22:45 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:9f6a:2617:8891:93ff])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-819c5edc5e8sm3255185b3a.65.2026.01.06.18.22.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Jan 2026 18:22:44 -0800 (PST)
Date: Wed, 7 Jan 2026 11:22:40 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [PATCH] zsmalloc: use actual object size to detect spans
Message-ID: <d2kzb6n5qfrgweka2lowrituhdhgugyfgcstlz5u46g4z6xxv5@fkqvm7rzn4eq>
References: <20260106042507.2579150-1-senozhatsky@chromium.org>
 <qh2p3k5c2ulb5g2zmckhrm4o2eoruatb5lnumkrwrvmsxwcn3s@nh5vx4kjn5in>
 <og2yztajena3ywyvus6xgc5vlrrecjaynyezygpsrt64kjkqlv@agceajv57eet>
 <vkhwvmazwys7dz7m67fil7xlhevdsc4xbvq3h6nknb7rqojjis@vx2c57ylvl44>
 <ofjlah554fgcc43e66djtysmnagd7gduqutueyauipovs35qb7@mw7keptebqau>
 <5smqbald5bollibqjsvqw2tfngdoiiucurikdgqtz6xjb7u7vz@7p6hskoixaak>
 <lupjar4x2wz25knuntywor5oyx3ksyhh7g7yv4apmztn47ayep@sncrwg4gjlut>
 <tzppylvpaq7lk4re33h4niofgfwiziibp3jdoos2ofeepxx5yh@sh2doyzze25z>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tzppylvpaq7lk4re33h4niofgfwiziibp3jdoos2ofeepxx5yh@sh2doyzze25z>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 71EDB1C0008
X-Stat-Signature: nzjsuqkmu3exke3gfqfoestzfot58o7p
X-Rspam-User: 
X-HE-Tag: 1767752566-656185
X-HE-Meta: U2FsdGVkX1+9Kqusn8CB/5XKc+T0cmtH1BEc5QfarDIY9+74uSEiSzoSjnnMlObsjeLyo95pBmJ+qwvV5fbpZ8un1XV65FeADMnue2b2Oa6RptK1WT6ghJ7dRAP8ZOZSjKJAN8fquXmJd09PDjyg2QFgtdgxIJH7laKhhtGxJDfKo3fsGQK6A6Xi/eyjkiEHQ1fuYjvASkpKbAKeY6TYZvlwMfwRT/MyGiQ/Zwg+W0hN7k1OVnfVERwXTjIoha+qqAtmXYKcrLZYIwZdIISmJJ2IKj7OXeJLCFYO7+lTUTN4PTvkMrvKwRG016F4FaV//YH1hBrIDJvDE4eWuyWcv9zXXfmWcWlzwacSQIIock6xJmYdSszrzssoh6olgxbvwgf1POiKHrTd0gV8q6TFDjfWmXRuCXEAN4FYkVY1LECEFV37tXK3+nxgWHmbzB6y9THm9sfJWwP/VeSt2163vXjuEb35OVlZ3ETcVO6UP3GX9YxCs+0srE+Esg3pYTFR2CyY4gbjqvlyLAWNAUJARFieN0WJMpjN5eOCjuQ/FpPu2p4wuC4/64LJSiw3Me78mgkzEs0JR5lE1dDqfllP5vSTJpjlKmxmuvsuqWQcD56WHkup39B6GYlLjMc+PBwP5Vtr1/BesYhvIDhN6bX3Z+82YjL/QfhgPuaWKCtfP6mwg7Zws8Jlo+uSsJLfWyFJXYHDm2q8scCiFo9yGw+ZbKKSEArzWU/XWOijfbBxw+fNQrcoar9giH2efGOmydVRtBarcWJ7rnMVOK7wxoZWXnDStQahjY+7JsyRPFx7D0s5FLHuUyy3WbntUUHyP8lr9FEXrPYd9q2G5Frpvf16bp+goiTXNDnyLiCZPX/Lm/QJeG6/4OhFRr9nBFkSLR1aH0a8V4doBcwiaf1elAiXdpgoEhvLSZj6liawg9g0sj/7pMt6Gw6tuawFZRMcQimDTe5lz1cEB0XDyctBecd
 O24EeV96
 cFpQ4nd4qYbkHRkKq2hXAqVDcW8A2HqxdwMTlZv/0muKvZDXuVh5tAeZbeAYgJ6LQGHBkp+x5l19aDF93yOJVAxNn6NAriY8/HPoyPX46O+5u4NFc9O238/JyUnZu78h2Sop/4e621SF4Vry6uXPT+4z1rsm32Z2F1iecB0Uq2MEQfEHK+v/ELOFLsuRFRNnxI8TC3u6IUbDGEOG0o5X9Jkn6KcromQCAJsoaXA2gxbf4+q9C4tZx6bMZM/q+fDmUZHsgk7XSGFlOo+Vb2G3OKM4bfYKqjgJkxl2sZK/a5yLTlxEZ85ZAF0R1sEW6sWTyVDXY8IApzPGjKtcbcdrYUiBC37p86NvvcwMyS0duBTUr6NI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/07 11:20), Sergey Senozhatsky wrote:
> It seems there is no second page, it's a pow-of-two size class

Oh, class 48.  That's certainly not quite pow of 2...

