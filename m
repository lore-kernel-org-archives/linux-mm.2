Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF0A6CCFA03
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 08:10:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC74D8E0006; Thu,  6 Nov 2025 03:10:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9EFA8E0002; Thu,  6 Nov 2025 03:10:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDB958E0006; Thu,  6 Nov 2025 03:10:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AD41F8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:10:02 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6D3D712C81B
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 08:10:02 +0000 (UTC)
X-FDA: 84079459044.07.8F0149F
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5CC7A20009
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 08:10:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UsIg8ruL;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762416600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lfRQ4eBcjmm2Bq3zjTX5qrRFTj0WFq+LzwsImYnihBs=;
	b=w+C3EprpHl3D+Od/+QDlo6uVdg+T7k+9VqSpBj/9djCvOf695NPakaz6ar88ptE4Pjwy6J
	EHa5xRyJBYg6LV6rirUTLKF5QY23jsSlplX1lxDKMqrvokAXS1jKTwEw/o1tvmjdNzMooG
	9HT8XuRrCRHLxrDtE2tcNed9SBaYixU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762416600; a=rsa-sha256;
	cv=none;
	b=JPJFxjIkQR+LmW/ILV9td/T6Q0PQLU4OBDfbHPOXvZxiS8ZMsl22CbmVk2nd+gYMC3ZNiY
	Ksc7bmbOM7iIELGawcLqG1cB/+T2lnYrUwRVmMiEyNFgLZPNDptfoL1BcN6zBV7yTmCoTN
	ZZvFdzRax5Cz7eFeyrGkj1V7dYRB+1E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=UsIg8ruL;
	spf=pass (imf03.hostedemail.com: domain of mhocko@suse.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-afcb7ae6ed0so109115066b.3
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 00:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762416599; x=1763021399; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=lfRQ4eBcjmm2Bq3zjTX5qrRFTj0WFq+LzwsImYnihBs=;
        b=UsIg8ruLzgbKiPuTqbmf4qQGhTUyLQSHkXnm/Ch85W4gFwgMP6aUVZ41hO/j8TVRmW
         X+DFJSgxbKSxk553rYhp2PJbicHu0KjCWIJbsBtyc+Lr5HL+2yY4XaqKAH8zBPc5yrW1
         +O4CeoIUK/TKHeQojCp/kRwVArONTEmSR9tydoO+MVXBj/yTCWWO8s3LviGmVrf9bcSf
         zH/V6ZKwEVXSg30XlXSl2Gq4lqDljsmQMcYpmxS0xdN+VWTzB5teDFpj4mH5ajKu+KIO
         IZUNjkqbKc+2dLnrRDIVpRF8hBweqPJTrrSFLckZs793GlUIZ/Kt1mXDxko3NLApbvS9
         JP9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762416599; x=1763021399;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lfRQ4eBcjmm2Bq3zjTX5qrRFTj0WFq+LzwsImYnihBs=;
        b=ljsjXUbag2NOp1gIX/7Yu8eM2S5XeLgSUO2aajKTggxw2soxRUbE8SwapnSDNmqg7a
         ZMY565BbpBwmggkogD/npZ2vE18Wa8vmZ/IwbZqYT0+1xne2ANN+j+fgi/3xVTdp65Ud
         PaDWus2fuu2bkmFRmNgKjGSpXLA4CVKDvACctVYRVKHzbjpotiMEEH28tKOpvTeMGv79
         7qTdYYOZufLiSyTf6DvRVIc7HD9D2khYbf0ljblkkMENh9+rr079f0IOcJA4KQu6h9+Y
         dD7OySNy9fNktaOBA9vRsaMB6+6h7Y9pc+LsnCJjEvQBhgIvCcuzKkQpVO85YHAR9ISu
         60FQ==
X-Gm-Message-State: AOJu0YxNcifXibVGBhe3Gngjhj04Kn3mHrQ7I2sR70laLGFSOdTYAit6
	bhj0SXEu0grWIwy1jUE0NIRR5R+eWULRQq1+Idwj7g/uhyFxTjcJ5hyR1APnRNKEaZQBea96F0C
	VvuKH
X-Gm-Gg: ASbGncvW3s1kx8C1Pwvl389ZzZjYfNiVPNeVhzxjaTmu1KKyFKg87LU4YadHa2PgL13
	qlNo91rFlQ8vB1bMnTbbF4Vg/8OWCYQ/4XUMOZAs4H/gh35d/6KXloKXyr6flxTII0JBJQo2GDg
	LR5REuESVkAkrCzOC39V6K6Syk6mHeoHlICj7zmTJb6NB4fmLXDOKJuTnFk7YgRrnU/k5mtVILy
	oJ+MhiCVMxA1R3AQ86pRaW9g+f89wGvm8eEUy28v7N7ZO/d1bhAkorQIRnzpC67h6exPiG8BiLz
	Md1795B4Rs+6taf6tHmYQXDawPT/ypXCs+9ZGtzGjoEnz1UhTcTmq05zxVzQdRoi2Ki91zIs9SF
	yeNb2HcLBuwjL4Sc3qdEoY1dKdTuL0Mn1H1LLN8XvuXSZBd62U0VbLxT+He8RFgIVG/UkEiAqaL
	ufXdqRRzx1cS8TjX5Y+LnwRS0b
X-Google-Smtp-Source: AGHT+IEo2DMbd1CJeXhEfOo3Lj6cQEv/ZFkX4Hv0G5JRAe6kcb6PCnhyhUmPNd+1xBCZ+FWTBl74sg==
X-Received: by 2002:a17:907:2da3:b0:b5b:2c82:7dc6 with SMTP id a640c23a62f3a-b72654ce3ffmr706771766b.40.1762416598738;
        Thu, 06 Nov 2025 00:09:58 -0800 (PST)
Received: from localhost (109-81-31-109.rct.o2.cz. [109.81.31.109])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6411f8578d4sm1211858a12.18.2025.11.06.00.09.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 00:09:58 -0800 (PST)
Date: Thu, 6 Nov 2025 09:09:56 +0100
From: Michal Hocko <mhocko@suse.com>
To: Robert Dinse <nanook@eskimo.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: Folio Related Stability Crashes in 6.17.5 and 6.17.6
Message-ID: <aQxX1HdOnVZJAERp@tiehlicka>
References: <b964df0f-45e3-4fea-a84d-852869b49502@eskimo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b964df0f-45e3-4fea-a84d-852869b49502@eskimo.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CC7A20009
X-Stat-Signature: pwsj4g8dfd1ike4bxzdrxhur5ib3qm4u
X-HE-Tag: 1762416600-78818
X-HE-Meta: U2FsdGVkX19uvMYnk4LyIp/axOYRzYmcGZbld2XU0zUn6tWYRANlBSEK8O69yCD9iEwebZP+8w2YJhMcSr7dil3hM9vl2kSX094ngXbzy2Jd/YsZS+OmPJILx7nXwFqIXVJd3UjdN70wmwEMv5kI6dQPQS0oOuZmO2UPZeUjuTp9uqyYmN8ernMd0PfFa5MvovZmhH23BW1snlE8KaT+1viqPSK17m1h6hhdPsdcaoqz8KiZ/sfePc8Hd6paBSWs/bf8iq8bPxM5Y5VDlq4P/kWdvFZT7mIQ8beE67JlWcudS/FTeNTsic3zj/j3jtdixcHOw/QvUrEK07vbQ05YWhP0Rppw1KEMw0kNUCAM0zJGg+RG4gXbURb/SuFRdrU2ztNXzD9K+I3bDnqWZUB1W8CzH22gOx4DBulu/1cbKs8C/kE9kOBHx8C5mYhTfx1e634lqQeU/mQdmQdqXIJcb0hED9M3c9eAz6PZBldxkst0lFLpOHAqgdwSBVz2IE7fkO0lUDGV39LDVf/u2n57Ob2A09vr2g3xqASG969xQjv+bUM7AQgMlp0jg5CIw238WHeXf63hUwuOALhA8VKqT4Wiyo9CKkM8TKUsDwoRV6fiBggdjFvYM9Vd8zosjDjvPYzJrEh2eebR1/TYK4985A0xrW4SxLqXccGC5xqWg0jazGbXP+Fth+tCrFkcUrDUitNl0I8FxiyiXFENQd7lp6Yg5kYPtxNeUx/S2kL/cIqmGDSvMCn9wBPhitlr5aDgYymixuzKLprxnUlpAhIqQo1R5cmQhPEDgNzZiYjHZBJzGKZJ3U3SiVy1sYnz25IQ7XCzG6MlUUBKFejw44oHOuxglvSF8kWFjYT1W9Uv30+gOWTfMjFQchNeYUJoZkiw/dQGWnJkqitSGCbHFG0whVu8Rmc1jkldW77tvG3MBbhLpS/YOJaYng9vFhYIp3nAJa9zlSCw+RoL5gRHk83
 jfjL0J63
 nIOnFhP8pqRIDP0chtV+8Eup/gSgQMzzF90Lln9xgfYWIYtpS95z/XVk9jgZtO17ay5YGQq0OBH49smI+Wq+04fNqfIo9ATG5nqObDilppLDhc21p2lkWDTkIQYp+hX4M/tOS/j/4+Az/T+pkSyaW9OyHEUPELAihG1P+n63OJbBj3bS68NC41FDpLvoISZ/uF2QZ+QibES4fD40O+Zy+6xEGhijvOMFkPv2Ac3H2zDf4lqWo17pO+bYOFBbZUuZfL9z22hdq9u3mc7FRnX9KvGidCEJCQJGUR9IHdq9S2nMeAlPN07W+NlLb4To9HyqMQIuHluTCO18VTOf+LtGe5NA18yvGLZ839Lkv+whgUyXgBYBTnO1oBh/PfKS1FSXqbRl1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 05-11-25 19:19:17, Robert Dinse wrote:
>       Since 6.17.5 I have twice had one of my servers lock up in a state
> where it still routed network traffic and responded to pings but no user
> programs are running.

Can you reproduce with the current Linus tree?
-- 
Michal Hocko
SUSE Labs

