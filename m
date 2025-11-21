Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19C9FCFA469
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 01:55:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 713846B0012; Thu, 20 Nov 2025 20:55:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EB0F6B0022; Thu, 20 Nov 2025 20:55:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6277C6B0023; Thu, 20 Nov 2025 20:55:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 518C76B0012
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 20:55:21 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 96C7A14045B
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:55:18 +0000 (UTC)
X-FDA: 84132946716.27.CC0292B
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf08.hostedemail.com (Postfix) with ESMTP id AD905160009
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 01:55:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=PDZB8LOL;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.169 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763690116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0cRcbbQEo02KH4rKMcz4LZIg4tF9mtZw5O21Ocz75yQ=;
	b=m+xQGk6lNpEXjCDbf9N5hj+FAjWMdQgBPnp75qr7l4mOxRZPq4gftqCV32IJTS+KKzI9z7
	FUKfObOAs3OGyDdqzgzJdQCZfjnWF3LAlF0+vwE+DNhVxK+H4lQFoTWnw4we8/ICtvHzJ1
	YhYUZjWDGYKUwrLpljHoQPffUe0eC6Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763690116; a=rsa-sha256;
	cv=none;
	b=yDtGtnfxaGl4rNJGdRWBdW1mDmV6zRPUSJe5tcBV0a4oIR7y5dI0xUDvZ6EPhruC1wrRX4
	AcTOCvtagSWX7DtS0rsq21fyr5m6rxm5uaXUgVhwtCRolkjZbNX0X+s9ChALIvfZ98/54b
	vPPNLtgVM9FK2QzqMl+2JBIE2PjZzxk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=PDZB8LOL;
	spf=pass (imf08.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.169 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7bf0ad0cb87so1406123b3a.2
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 17:55:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763690115; x=1764294915; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0cRcbbQEo02KH4rKMcz4LZIg4tF9mtZw5O21Ocz75yQ=;
        b=PDZB8LOLwCVhAznzLEUTINIJ/1heuLYU/jiYILx9wZlzXj1S3LqxmP03PGS0sYcFdh
         glnL2TXfu+ksaMh+eXoIdwMqHsJvkAy9Ualb5DGmq0g6CgY7N1GKgzs5ySXnDpuVbXPV
         NktPcTQT3KsqMjMXvElKes/KDdvSncWJIJ2BA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763690115; x=1764294915;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0cRcbbQEo02KH4rKMcz4LZIg4tF9mtZw5O21Ocz75yQ=;
        b=wbKRJUxkATQh9lBAQS+LHP60+PMZWsPCf1LtX4VUdM1DzQo084aZgZFBLj53tLW7xI
         u5K81sx/A4xFiByY2lNXSjo1IC+pR/DDV7DoLoLIQhechdAGJgXehIoFyr5sybTjDawn
         AtILVkXj8p4r+/xFMBqMOxdkDT+TZFyQTsF0DJ2wmP6+Id53JFDd6s0Peue57ySC0Ege
         Nbxqg+nXA/HvjxuHi9+7xPbcePcPw5QScocWMiY8LNrFh9T33n/QCxo/DrY/yxtaQePD
         e1dY6aqMl7tEEr8HsYNLiYU4lL/xhTQ4sqp3IoI1Ph14viYQtqzekcXjKtyUFN5nHMuR
         s9QQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpn8ZYHkhfWTsgaHB9v0Y23hQMTiW6fZZD/mhfqUnxw+7iKiqhT+iF6PN5xbIPX492jnepiI5n6g==@kvack.org
X-Gm-Message-State: AOJu0Yz17sg5IoVtpggI2B6xVskoXcGk1AXNoz29kP0b95iOlEgepKeX
	ngydO8lK2FcS7PU46Nugtl2n5UXCfSQVDhqhQ/mNyHK9eSlXBpsaq4bqeTnkeTGHSw==
X-Gm-Gg: ASbGncv08fONaOR3nUc5zDxW22IiRSsDLOcHgRp5aE5MRSDhlfWWp807+uzPkm3fsuo
	X/XcfsYefMujy5+WzqBwNwSH0CuoNjEcStuksan5Y+7s9cvQwtwRcjnn7dF6S4CRsU0SOE/fNHl
	Gu3gkKbF/OH0WzmUhWQJ0vKu7OP5gg0Yt4blr3YqJcuWDnRCGQ3X+fxPXGR2UWs5Q3e13FWGVSx
	pMwJo8oYddtGltuBzj1ZnFm3F4tOh2IwLEZ1YGQa2gV7qFKSJy+/efARt593L12vAAIzXLrVD6h
	fszLjsqhzlqtXXfSP/pbolOK8AaNrCd/dbAT87QMbZVfalAWYE6HM4mouEEhHahBW6UO2gs6jjb
	MvvKQdTHWvymGtRBl3GFuVQshCxvagaJ4pbVSURGT4Bay1a1hCdyPHOZizfTXz2Lr8qrV5LXPsv
	MeNUKcLQurMQpeuqA=
X-Google-Smtp-Source: AGHT+IEvvkY/BeYS5a/KZXMhWOVlpWXxEj6JWJCOYUYmnHxLc5zFggPXEr/viHMNnTU+HaR8K5bXkg==
X-Received: by 2002:a05:6a20:5483:b0:343:6f53:e97 with SMTP id adf61e73a8af0-36150f2e004mr354483637.48.1763690115547;
        Thu, 20 Nov 2025 17:55:15 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:6762:7dba:8487:43a1])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7c3ed37ab3fsm4187857b3a.22.2025.11.20.17.55.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 17:55:15 -0800 (PST)
Date: Fri, 21 Nov 2025 10:55:10 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Minchan Kim <minchan@kernel.org>, Yuwen Chen <ywen.chen@foxmail.com>, 
	Richard Chang <richardycc@google.com>, Brian Geffon <bgeffon@google.com>, 
	Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-block@vger.kernel.org
Subject: Re: [PATCHv4 2/6] zram: add writeback batch size device attr
Message-ID: <birguuoazoxjeijvnnxjlpv2avd5cgptf4cylmdaj2a2sdhhem@svegzn74fjr7>
References: <20251118073000.1928107-1-senozhatsky@chromium.org>
 <20251118073000.1928107-3-senozhatsky@chromium.org>
 <20251120171738.84516c55e4aaeea0bf3b7725@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251120171738.84516c55e4aaeea0bf3b7725@linux-foundation.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AD905160009
X-Stat-Signature: z63xe4kwjqgccbejt531o8s4edohe6nf
X-Rspam-User: 
X-HE-Tag: 1763690116-895141
X-HE-Meta: U2FsdGVkX18+lVmJKLXYLKl4Wp0vcI8PHELQj/dv1O63XkS6J4NaCfBJZQzO/H8052mRty+d1cLHTaLA3vFatf1bUQOwc8esxLZI7+/Nroi8gkF5fsMAOPqo0o6n2eLSoxkJoIqjiaRQmJK1slRgjeYW2KvBeLbTEuiBusGjYxf0R2KzPSCYUbyDBfvFQHKiiQ/sh3ZyrHxvyavtM9AZBnYtZ/55Q29SCh3Jy0VHZEMxXMEZg6c8g4pvZ2lQsNiL94cyaNALUB02E9k5XW1E7riI8Xc2RdYNrvOZtJMb80MltKhsLacJjI2cAUFwozSrw3X3IS8imy2Oa1377ZgS+2CPeUy88AyVoE70b70YK+gTWU38z3lq7YA5j84Y4koyINl6XjNWZRSPzrGWKtluMjxQqnGJ5RvinY8C9881JvQ6lu3CsGFP57wnVZ7kFryzIA37od3iBgdnSAQJc80QYntZlfxyDDaxNM4gST2liWo+gUlR/tIaV+9IQjBkMlihzMERsDA+H5+aRLYYtfBRt9UtFvv+jtcQnj4r8+4v+gUJqW/y0lUJ6t32cHNxK9RDha3RBnu1Ak8oJmCCSHsP3xamrl+/kAMxdQOe14iyPFU/N0J2Jexeml/KjZj75rsvLrUJPszeZx7SztOXsGSzYWG5NFcf7ARjp5Vs7AWH9+JgMP47Nji7l5j6KX3cjv34SQq7mi0p7ojQhWIBHp+e6/08GS8L4iWYG2jic7JakmpeCn9hO9qOB88LU7vM6gmN7xvf+/XKgi1emn1AoBaUOGg2J70ZbFrBxPHqlqh788QT3H6xcBP75xONETEBk5XXyCoPPhN/a+mgqTDrmml7LHL+9ZbIZeUa7dk8NWf8u6S/I1uqiAy9yM+7X7794qrkEfyOnUb2d04bGNq2NGYXRSwtwKiwAgEMHZ9nV1DyVbDL9+N1h2N34ZDN1Z/3E7dMAmRUa4/SwpYsnZpvB9N
 ADhpMUBo
 tfpd8VCW2ghf2+mcNrWb41hmBFrcpt+sf0AiK6IjwEqPZcSfEgIEyXnyGWP7d9Je0WdhVT9G8AKLkjlsWS5KIOVJZ2xf8kU6RI/5LBa9aX/14Y2jko+euOiJDp+25vE4bMiG0oFD+dNFEPhpbwH+4sAqqr5uNSGrdXL9I/FPDxkggaFn9yvhpRH5Fsxnp9TStGEQfbWUlePb50N6Fx0dwon3bJQOHTuNSF1CLA4QRceoenNc0bppKUIBLZ9KJiKi+RxknuWN8HhHYxNgmfEc6nPdXMTwtB7wFKGRCe8t67vM5oIIERqRbvYoe0NcDFdA0GzZaKZ5BSmXqGtdQZBhkPipDNC4aDG07Gyo6SelXdv+UfPE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/20 17:17), Andrew Morton wrote:
> > +static ssize_t writeback_batch_size_store(struct device *dev,
> > +					  struct device_attribute *attr,
> > +					  const char *buf, size_t len)
> > +{
> > +	struct zram *zram = dev_to_zram(dev);
> > +	u32 val;
> > +	ssize_t ret = -EINVAL;
> > +
> > +	if (kstrtouint(buf, 10, &val))
> > +		return ret;
> > +
> > +	if (!val)
> > +		val = 1;
> > +
> > +	down_read(&zram->init_lock);
> 
> down_write()?

Indeed.  Thanks!

