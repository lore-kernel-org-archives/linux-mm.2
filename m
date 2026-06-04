Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19D8FCD6E57
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 09:06:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C8C06B0005; Thu,  4 Jun 2026 05:06:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A8A6B0088; Thu,  4 Jun 2026 05:06:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAA686B008A; Thu,  4 Jun 2026 05:06:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D8BC56B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:06:15 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 799B21A0709
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 09:06:15 +0000 (UTC)
X-FDA: 84841648710.23.E3298C4
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 81E3F40011
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 09:06:13 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EkJk5IOi;
	spf=pass (imf01.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780563973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EdFuwsES54dFvGT6zPCTaZ+yF4K8AlHGY+rBuqBIdh4=;
	b=erNjKfvhigSzYmHncn1LCo2TYGEXt4al4cMwwCZ25hz8AZ3fYJQqki3NdD+6KxKpulhjaF
	Bb41liAxZ04C/RpoSDqWzE/+y4jHI1stysr4qhJ10E+qpQl+W0FLlEl/jLRA6tAM/oLa2c
	XPt7s3RTly4NoAf83lgeEBkonOyw8/g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780563973;
	b=0qNJqq/gu/uxWoFyDjU+H2ONgBq0GItd3aFqAjvrbIY5E6Cu5/4l4zTjzqzI1L8EARGYaO
	PMtuhOmQPUnI9tITUp3GMbz0v6WA9Ux75o/Lz10d3qdmfdjqJ4/0CrCh/othrv97V9YNXy
	aNkWbLEMHuc8LDsjkHJp6jF8e76NXsU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=EkJk5IOi;
	spf=pass (imf01.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490af320e2aso5374415e9.2
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 02:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780563972; x=1781168772; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EdFuwsES54dFvGT6zPCTaZ+yF4K8AlHGY+rBuqBIdh4=;
        b=EkJk5IOiSxbtUwpBfA0eCXm1WG5VPAoph2t//JXgvXDRgl/zp3hcEJ5qMeKp+bi/7O
         p5ZdUnsUizyScyiXnRrrxwjGaiRBhtmeQInFeY6mK+rBAvWz6MW1op5PsBuOlCHcw8eW
         mEGlXcGoaQvKPcPXSkdEGLNyeUeTdg9luoLn00hie5zfla1JeYCHMZWx/ORgz32zqabn
         c9qZ+eoeIGOg2WxNv5BRhCyWPQujp1Op5LgR1MA1qH4TCY2sx9/3SH/2SyfeeKReET5s
         CXcpMgnGzrr0XRrnrCIgpSBago6cgGnL9waYrLKUB49184kWPYyBDvhPi1+Hgjhqwfmo
         hQRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780563972; x=1781168772;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EdFuwsES54dFvGT6zPCTaZ+yF4K8AlHGY+rBuqBIdh4=;
        b=HVRshJcJFcvyEfBKDU5aIVOkiA85ZvqE+eBYz0bNoMQq6dq69/Blve3OUn8Bns157i
         TRTCdEVxpK8eWMdKrApFbacZ7QQe1mi/TH476uX5Oc2yHJL66RjFDVQn9coD9KB9PaNJ
         R4HJBzadEIDPdWNlNjBOngKKfyeDPeB1ew6P4NBUKtSrNdF9QGfzUstIAF9ziUqCYx7I
         YPkMngmeW3y25twKA3kTUblMA4EJBzWyCjE3N49GrwwulUxUIGNyN33FfzT/5Y/wbvg0
         WiDT8f3NIQEv0u4YOV95bYmgJnTcBbRgLN36u0+N3lwADcdeYOP96gD45RN2kBBNbbMb
         N3PA==
X-Forwarded-Encrypted: i=1; AFNElJ++/8WcKcjvIzfxGBCpOZH6FFFmSwgGSxvSM0EkPrjvmaf0y/8oDgUtK5xD4ORIi1N2KK6m8uXWiw==@kvack.org
X-Gm-Message-State: AOJu0YxW9NpJjFivJ6mH5/Bp3mQiutW7ojorY8emv/iK3J/MzOALmQVc
	+1M7/twci14fSUGIPf505KWjo7n63qyOaEHaxhzk3RKVYvGYLSTzTA2G
X-Gm-Gg: Acq92OHcCcya29pS/IbmEz6+viuuDlYeJ9s9c8mUjBtEhtF49dbzzZrOPgnEbbQspbW
	RXoj1m1+TOQR5TVuy9g+hXj+CXtLA+wYK0OOOTWYVhnNo/4gbtaW/vdBA05iq8BVu6E7n6Y2twI
	WXOEeAKnmgv7V+0ooY/sxoEB1+B8wtEN5L5B0jTHjQhwcns9CnaOkzrH1JlBDIrBU/JMZIx3CMV
	JeMgSCqBJgn9D5sWB3+stXkcmhfdA6E3rJEmhgeLzP6SykKe0ak9ikdy2oVnkztsBtVNSoeIxrI
	0Zkf0pZUOvwwufgPcN9Sq+v0uLYMMIW57vvZbvPpgVGUiMYzDl1ZC49JAN2N6MpCyHY2uC7V83S
	eN8QSIzBU28XaSq71VPCq2jzPrlrltU5/fN+5L/Q6GxSgQj3rMZRKCQT2xFVfP3U1BTiO1C3R+S
	ggiW/csFBngbhnA/23wGqscvlBJWYQsz8borcYAj/CrgGiEQYpLWGhlTAg377T2Pne2GxiLFEyE
	PpiOTLsMQ==
X-Received: by 2002:a05:600c:8184:b0:490:5cd8:d213 with SMTP id 5b1f17b1804b1-490b5eb44f8mr113527135e9.15.1780563971711;
        Thu, 04 Jun 2026 02:06:11 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490b7e6c774sm70203515e9.1.2026.06.04.02.06.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 02:06:11 -0700 (PDT)
Date: Thu, 4 Jun 2026 10:06:09 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Askar Safin <safinaskar@gmail.com>
Cc: metze@samba.org, akpm@linux-foundation.org, axboe@kernel.dk,
 brauner@kernel.org, david@kernel.org, dhowells@redhat.com,
 hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org,
 patches@lists.linux.dev, pfalcato@suse.de, torvalds@linux-foundation.org,
 viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260604100609.6b37f500@pumpkin>
In-Reply-To: <20260603211736.755139-1-safinaskar@gmail.com>
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
	<20260603211736.755139-1-safinaskar@gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 81E3F40011
X-Rspam-User: 
X-Stat-Signature: rmo3rzoy4ay56sy9ndtqeo9ms37wx4ur
X-Rspamd-Server: rspam08
X-HE-Tag: 1780563973-79308
X-HE-Meta: U2FsdGVkX19m+Dz4tUJCmugbxrPqAXZZqasMqRmgnE1IDggw8EMt8iMfsfO5aEv5EpNVnP0tGKhtW7l4+6zRRoCLM1QMD76Y4rSnoADoKcZ0KQnLWFdo83qWPMZ4nsXH8MWRnOv6812lEnhCnU8R3tm0QceiYbfqMrIieCWRjrnKo+IPVZ8KcNBzRLPPTV2ag735NgyRLPLhXg9DrkCtOYP+2DGYk8LpOOfKQVWgPymM7mc7X9aztO7izwUf1/BKjLgF+EvhaaGepio2IcgvshjuN8sRRvCJGwRDxnswCfwtsneukkgaMVoOi8kWVvGE3P9/X3GiKRsazPCFh74tI0BhhrYHfjTlNwRxEXdxKxcSZ70iNsqrIzwig0I+WrLnOXV2rmkX4NgbapvggDmduA+Xz0uXUa3Sfq8aLZLRycUmUDl1BBtYKyBprQcr5Fe8niAAjH68SINb1gqbvm8+YSGmkewNqxdvKZYi2BqRC8q+LBffwskck9P5Toox76feZaGBMJMFmIHGT6t4d/HoMIOapkvfX2c6yq8vhHQYOFWWilhCMZdnfZgv/ru/Pgvw3+S229Wck2N3oGwClVF3OQJbCD2sezfego+dtImI6h3nHDK1ZjF4UMwjBpZwunK1ik+KEN0FWgUeD1xojHVwt9g4J/wGfy8a4PVDYbvZ9D8kaUBkSucH12OGVRpepeSEfvaRP/fwNUpN00wreyB1OL/rC47KrOb/yDAQrQwTzNlcgoYrr5J52w/cg4tm4DJyNvSdfCfCQUxP99rntM2SGEssCq3nr7Cg4gqAkYpxQw08OCiuj23rn4j5oXeb6WBwk3oob+MfXNlANvHAeBxs1AgGPqMc1BYXyxFGxtNwqO5vbRdMcNOq5uqUt3/qB4dy95R+2RExTvQbir0T2B3c+0ZEoDnT606dNzHNWGA2PcyA/Q0GljzC7DQ+umJ5tkrBNBFyVmTI/uxlJnk32gW
 FJ0cg3AC
 fA8e6tzDtF8EuWSP6mQe7zfuSgR9kxADtrrVE5w/bA5A5bnKMks0HmvvXzanMqhIv540NOBhvkyeVyW4ij+TPfZEh+9AmAkQv9C+kGOfDPrk6f2FtRVDK1v/nwDogoyuWFRxa7nA8WX2C6j2hqYoGBHoT0EZw/QmqEG3cuwuEOlA89qlhxKqCZtX2FE+9qMYwUptMWONX7unkF2NVxKK5902Vw9McDydVR7K9qqSJZXtHOpWtoqz+eAU6qFnUjjwzibDb8Z99jYUa96xBJx0JXJxvoEGshYQfcDv9m/wdNntWBCZnPbDIc9la+zwwsXGNtUcM+wfwJZvCXEQ/bC2NAgU0FfuDwdU4zHudRiw5+fnUKFLl5eqdi3wHqj3we3FoYrJnlROKfH9r129TpMb/Nzl4l24PeENuHsiyhVWDph8E1eEJiHpX6SJDUKV/LU9p4DQjEvKxioF+gnphrE3B7RU2Y5nZQcJSz8w/dzsgChCgz8ro8z1ykgcXGestrUqTUBRu2LltXcFO418=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  4 Jun 2026 00:17:36 +0300
Askar Safin <safinaskar@gmail.com> wrote:

> Stefan Metzmacher <metze@samba.org>:
> > Why is 'int fd' changed to 'unsigned long fd'?  
> 
> Because preadv2 and pwritev2 take "unsigned long". I want vmsplice
> to be as similar as possible to preadv2 and pwritev2.

Something needs to ensure that the high 32bits of the fd get masked off
on 64bit systems.
They can be non-zero in the register that comes from userspace.

-- David

> 
> > Should that be its own commit if the change is desired?  
> 
> Yes, possibly. But this patchset already got to next.
> 


