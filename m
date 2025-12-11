Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 144DCD3E79D
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 07:39:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6409A6B0007; Thu, 11 Dec 2025 02:39:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F1526B0008; Thu, 11 Dec 2025 02:39:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52E5F6B000A; Thu, 11 Dec 2025 02:39:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 42A366B0007
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 02:39:01 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0ACAD13BC55
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:39:01 +0000 (UTC)
X-FDA: 84206388882.19.6F9D243
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3A5B22000D
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:38:59 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dw24EPde;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765438739; a=rsa-sha256;
	cv=none;
	b=SsN7xmLCVLjHouAyHThsFPJsKVvHhY5k3Zp4n/1ROQ8Pdg8p+5CBPai8CCeMfMz4BftEQ/
	u4081HqjO/ZBqndktvdnwvp98lSSvOAv5z2J2Dmg/qXfxhk1FUosxFCF9kJmnIoLfL+KSB
	gBGGkQ1jAZf240KNj2AkMcfeWjSFO7U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Dw24EPde;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of rgbi3307@gmail.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=rgbi3307@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765438739;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qNo3c9NxnL7bsmTxmb83lgmRtKUwugbuBdQv6CrEYfQ=;
	b=nZ97T1jErw5pQsbPrDsHdDDvJ5z6N+MCPKaoVVfGheTEtKHJPMvbINZk59z/gPbUif8hfU
	1hcYJNW+uC5TWZKaCC0w3gychDaC3zb96c8p17REGkAmyNGWN+zzoeN0VnsLSAvfvZEAmC
	r1ZIGtEekB+AUtyJCcvF3W5vUOZ93Ps=
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-6446d7a8eadso609893d50.0
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 23:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765438738; x=1766043538; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qNo3c9NxnL7bsmTxmb83lgmRtKUwugbuBdQv6CrEYfQ=;
        b=Dw24EPdeNZN1I04NlNq2D8zm8J/YPr7PXSWfvl0nB1Gg8cfujQWbc8d/cSOfLKKeRw
         ID3jcXa6cbiorkZAREp1+cd1sewlk4r5k1s+T5Vtinq+ks/zq7JAgdpAEGfYlQg4JPcP
         WQxwsfhmwU5rKzSBTkvdfIFGqHrZyFTkMswVOSAE8agn6a+jnraZ7TVEOYKCKyBoNq0c
         5e8pxfcSS1G3WAynJPCexONHE3U2si99JzjNf5TU3hTT0c1Vza9xU/mZRVQRsHt5nIBH
         Vk6pVFvv9H2w9qYRZXfVcSiUwrgn8/QABAF/WycC7p1TRlCgwknurmt+nkFF+T0pu6FO
         U6aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765438738; x=1766043538;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qNo3c9NxnL7bsmTxmb83lgmRtKUwugbuBdQv6CrEYfQ=;
        b=i1XZdRd1iIGFWGwytdl8oQTCjV6LTKprs5jYZ8jCsHHhHW2SGxhjlOcsgeg5s0f1Pr
         05IMntydsNtUHw5BnRyttfhwOaHA/7qMVgN/8ei4OE/2C9n7VOlara1MXSl+xm4DMKOy
         wUsxw2yGy08/xEQucaC5IV9r8KXPMxMxIU+ETqOqRWz2HLUhLsg4ISv6TUX43ohFcaKV
         Dvsg3A+yFtIIf2+AaaLr7zjYeIKi8kGSIRIadn6iVgF9mhK0lq/mlb/JFKYRfm+wAjtA
         8zTufBHKlydR/yNCJXq1LFC0LG+D5xUGpRybhnJ/3tsW8NLQ9NuluHnFsz49gqiMqL63
         JaFg==
X-Forwarded-Encrypted: i=1; AJvYcCXIryBMaeXfNNc4V3UrEQLlGo5gLfVvi43m5WhmmtisHiuJdUwv7atIhnExwcku53kmMr0M+2ag/w==@kvack.org
X-Gm-Message-State: AOJu0YxThqRZZ4a6E0IssYqifoKBOSZ+GAI2zgPzqxhYfb0zZ3fDzZin
	Wo7kMadVL9tX13AzuRDhJuGq9bvCi/iX5y8rhIgLQIsOjBbf31npzNMEYXnEb2XhoV0WKyRR3c1
	j9ceHpP5YFdEWQeNWe9HRbKPccaSelYk=
X-Gm-Gg: AY/fxX4W96LL83+xo0rEwh43TYDj+tN0q6wdSqcEUPbcxx7wBC8JfKP5JXTjfcl/kBC
	ybrLO0fHGUSBwXYCrXUUkALD7386/0ZBoxarnaxhe5Kog8TUVWR/Rt5zWSEZhfBjrTNLAavIKTf
	jrGySopqVP/A5lUS/VhGjGoYE77CsJjcD5KcsNzeaY01MzreGPDZDcYWsgK+Qv91ZoiLWw+0nQx
	1hvD6As1L3kG8p70B/9QjSQ4QmM48Zw3AmYw8yxGDmj8hVWQHi3qzXacandPWdmWcZPyTIj
X-Google-Smtp-Source: AGHT+IHPJDzZkPfFWBRgIOOZ07OMuTeR68RB/IPPWWNP79q/gQ1l2vZiSyv0mLlqZr6Mb12rmnfV7LhG5GwljUcSfyE=
X-Received: by 2002:a05:690e:1345:b0:644:4259:9b62 with SMTP id
 956f58d0204a3-6446e8fc163mr4180596d50.1.1765438738281; Wed, 10 Dec 2025
 23:38:58 -0800 (PST)
MIME-Version: 1.0
References: <CAHOvCC6bJLf=LuBpm90n5poz8Sqhz9wjXtk5ypbPwkvhb1ptag@mail.gmail.com>
 <20251211060413.60534-1-sj@kernel.org>
In-Reply-To: <20251211060413.60534-1-sj@kernel.org>
From: JaeJoon Jung <rgbi3307@gmail.com>
Date: Thu, 11 Dec 2025 16:38:46 +0900
X-Gm-Features: AQt7F2qkI0dCCYHs9Len6GIYpErZ3A-Zu8QVXmNkIzVYVohQsczhTaiydbVhr4w
Message-ID: <CAHOvCC7epLcuK-58kaROWMof9dq3ZCm2WV218KGv7kcDMf7q-Q@mail.gmail.com>
Subject: Re: [PATCH] mm/damon: modified damon_call_control from static to kmalloc
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3A5B22000D
X-Stat-Signature: jnf5zp47m8856bcuek6hjjdwbt8wekma
X-Rspam-User: 
X-HE-Tag: 1765438739-324748
X-HE-Meta: U2FsdGVkX18UzNpYNuw0zP52ZzxzTSpTLXef6ZSvILzgxmqzdJAXKUd0lvriRxFU35Nqfsd+9NGmC+fYY3YgX8rDYkV79CTVIB21ogl4uQIJLwxN7B2yKwghYcUlqNXoTFjFcmYjedFuzGIYvv83L0lqCnk1hcgOO61rY+920X0xcy1sZmK3bbTCOiPGW+3shEL4M8suTU+Gp4zs77QkI/Tp7EyBGAboX3UZKsPoemIf8e4u4SSzwjgrCqaxxknvAmMtFIYmPOXyB7jmG+pNUSaNP6diZ8uqpoWkrt5oRTOj4tOEC2B8OhbWA7rOX7nwXgg5Yyw0n9eRDna3Uqjq7Sjn696YN4DCZkJYTpwrJscMvOqwFoX0RNp7XRhXMVyt1rdyYi4OZRn6FOkEfltOW7qpZ82MSBNC4omEHtCTArOaS66qyDUUDmSY4lUV2RIa/crBxGShMLt4SciU98gKc4TThoDNIOGZZ7K1Uze5JPJs00CXn+37SIjXYQArzl4vjO0iMP1t7hiZ/6edlzBiYweNMwk6jW9Ui7o1basPn1mR7C+fBjVJy4KGZLL1iNIKCDNwoUOzNKVm7ky4O+PRTrIyELSxMSRb63gVYtDHydf25hpE+Lt+H/h+maZd47AAG89zj+jR+2XjHSNog/GSIm9VF99T2tcK3ogb/p60CAnAb8gDm5SOR7QR8F7smUZoEgFucLJFoyn1k3zeMALY8BTMq6GsCDo1ni40DbORf4MdkH+Hl8hgXtqJ+ivDKWM5sYLXZTSaVN5MrUutC5FKWtxjiTgo/+2BoSzGsdtZ8L6gam2ahZoyYbm7wr1aRzLdd6ECrAdQF4us1rmIMDWp6U3Av0HKh/L8D7PnUv69ABvGWhzC1J8LkqNYQ6hndbgffCiTvCgOOtL3x41dKzWx6c6PyN+LJyoiCbdAfi9HypnUhopFht7KT1QXIh4gLPSG4QsZTN+G6/0/TKe5A9D
 nlIeO6hO
 zelM6aMT/Jtq4IE5vtSNdOkcXHXT/EWAush5iP4Ub9SJfFupZnODz9QIxJR+Bg1uVwwEPSpu/JrPKCkedC3jI4mlpAyM/I98FE5kGN7opUa/1ENfnPOzS5vXzkaYiAhDSZwVVsIEK/FUcn2QK2g9qRqzqcX+RLx00IyWxYiBULoNSKeO6BuSe7eKATE/MxY9Lf9hWmvfF7DYcZOIpEZrMK40ved1Q647HhkKi079vL0NQT+3SUEibRbv9DUYFp0puAmo4RfhE2lHzyhFkT/hzo73pgISBP3PKKE35oFCOy9XowDXrBkiHD0Qxy8F1hD3JgOuzTIabCemyoOOv5vCAExmijOFGFWeJggn5dAtpiUA6ZElp3tGr1OOQqgDMGAHCG9JapyNBRFEdX46lkNEsf1IfVg0dgVv1HfwQqfT+kO3UMZe7xbPJ+w94PIh+4qeDYfcL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 11 Dec 2025 at 15:04, SeongJae Park <sj@kernel.org> wrote:
>
> On Thu, 11 Dec 2025 12:29:59 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
>
> > On Wed, 10 Dec 2025 at 11:54, SeongJae Park <sj@kernel.org> wrote:
> > >
> > > On Tue, 9 Dec 2025 21:20:42 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> [...]
> > I suggested removing the dealloc_on_cancel condition from the patch.
> > When using the damon_call_control structure, if you only use kmalloc()/kfree()
> > when canceled without dealloc_on_cancel.  However, currently, in other modules,
> > since it is static struct damon_call_control { ... }, kfree() is not allowed,
> > so dealloc_on_cancel condition is additionally required.
> > Because kmalloc()/kfree() and static are mixed together,
> > dealloc_on_cancel condition is required.
> > As you pointed out in the previous email, kmalloc()/kfree() has the burden of
> > memory allocation and deallocation, and static has the disadvantage of
> > increasing
> > the code size.  Both have their pros and cons.
> > Among these, I proposed unifying them into kmalloc()/kfree() methods and
> > removing the dealloc_on_cancel
>
> Thank you for kindly clarifying this, JeaJoon!
>
> >
> > >
> > > Meanwhile I find the feature might look complicated, or not well documented.
> > > Specifically, dealloc_on_cancel should be set on only dynamic-allocated
> > > damon_call_control object, but that is not well documented on the kernel-doc
> > > comments.  Are you saying removing it is an advantage because it makes reading
> > > code easier?  If that's the case, how about improving the documentation?
> > >
> >
> > dealloc_on_cancel is only used in mm/damon/sysfs.c.  Here, since kmalloc
> > the damon_call_control structure, the dealloc_on_cancel=true condition is
> > required.  If you want to keep the current code as is and only change the
> > comment, it would be clearer to comment it out like this:
> >
> > De-allocate when canceled.
> > --> To perform kfree() if allocated with kmalloc() when canceled.
>
> Sounds good.  Would you mind sending a patch for that?

Would you like me to send you the patch with only the comments corrected?

Thanks,
JaeJoon

>
>
> Thanks,
> SJ
>
> [...]

