Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C241094465
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 09:24:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7C9D6B008A; Sat, 21 Mar 2026 05:24:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2DD16B0092; Sat, 21 Mar 2026 05:24:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9440D6B0093; Sat, 21 Mar 2026 05:24:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 829AD6B008A
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 05:24:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13F721B812D
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 09:24:20 +0000 (UTC)
X-FDA: 84569534280.14.D1B5CA8
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2FB1B20004
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 09:24:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IDpej73c;
	spf=pass (imf13.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774085058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Hj6a13EYucDZ+CMGYDSkcJt6QV/xbeGsZkPLM9UtYKQ=;
	b=PNki04WBpJwJKbTtxfFhig4KQxYNFdIVyPBAriifZOve7dPHTS+MB1r7K9f0FSf6/6pI38
	tk7VEpF9xwpKqTyYu4vWFo09VECcKpVpc2c23+A8Sj6j2Q5NOlaDG8Eq847At+HJryadDs
	8AroiBUWDmdqTe9HFgX1u/s5U8Xs+dw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IDpej73c;
	spf=pass (imf13.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774085058; a=rsa-sha256;
	cv=none;
	b=ATlEfYllwcivN0jMIXJFID6m2GUBK0fNGmggiwpRnJnk891aWyIo8H+zQxOz5TbBod/Q/y
	CRDA0oVbvZI5CBsW+iwtfZfPyPs7sAkKm64BoNqnGpJOXxSbQbKKiq9AyeOuKmtR2jrhpr
	pcMXbnJGanBK8dabPBQSwP86pul1ifM=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48704db565eso2454455e9.1
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 02:24:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774085056; x=1774689856; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hj6a13EYucDZ+CMGYDSkcJt6QV/xbeGsZkPLM9UtYKQ=;
        b=IDpej73cmBwL6P94Rhxs5wNqT/1dCCcQ00c7bmM2/+G8hecuf9I5hwuYbdk2waAHxS
         mudbetFF2gi4aDHtHy+tQUkm7tLutIi/ge1jp4NipqIPgSn8NIo41+WP0zcP9lBTcbro
         aRvdmHGrD5zf2xk1YrZBr7RX9Jpk1Aln2N4np8gQe1+IOOKCi84J08mJExrg/m4k1mvs
         dFKt2SW2kIDl2DCQJhB5EJYVI6UL33LcEDWAcxlUqRgXTuAuyQKXbnuPFz898clojcui
         BL/eEycqzzKUNXnEc4aJW2SzpblWybFYZr6ZIceFLoqWSubyjDx4+Cq2mmJ+eZXCPftu
         axHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774085056; x=1774689856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Hj6a13EYucDZ+CMGYDSkcJt6QV/xbeGsZkPLM9UtYKQ=;
        b=NPuJhZX8HaWAh7Y8zWd8nv5D49zfqU3ie15xXDilbr+D0MwOy9S78zht313C9UhJfx
         z1E+UHyoh+hUuWP1whM71+O1iPPXpb/x8fGhSmyxa5VWZruoNN9BfrvdgirkL995bj+8
         1oM4BmuuXgpDdWKsXI3EFf/M6lno7DqLuSs92F5Epb4ouUbWg/74eoEaigNFYgYj/jJH
         VJe0EfOOn0kG7MhzqUhrxiSYPwk/0suUcoXyxjc5AH9ftc74wBaKrIFpaGrCqni6pFdQ
         cvIL2uN/Ixh+FHltzlVFlb7mwH6UriESXXd1x7nDXXlm459fL7hiu7ZzRZT3vVWItDbX
         Ue0A==
X-Forwarded-Encrypted: i=1; AJvYcCWQKksW5ULwlyamRbtPOfu0fDYd8PR1FZqVarWX7HLv5qzlu3g/72Ba7zz6xRLGdF5lPZElcnTTMw==@kvack.org
X-Gm-Message-State: AOJu0YzV4vbwr3KlQ+i4UE9Jl457QlGbJ352VriKg5glGp4671s1rv5v
	iRwwm9e2EAtwTcpS6eoalhi7w+ZOl0uaqMtWsY6FNLNDb8uFEg9rU82x
X-Gm-Gg: ATEYQzzYpvBu2igITgFJ9k1X3WXicD5nhw0oOXp8ZKft0X/CMQGqCmmOsGWq4FRuE8q
	XD9ZMPh/kJAXgGDvOO7qJcqSs2QKTEhxxvTeKuu/uXq3GJrY/LtsT7uDwMyhtkYCuiCEavileVd
	eAMm/55EcUtmwcvmc8/oY41EIEbMN6GVz81lHjCTsqY8RAfV5ugM5+xlDSh0wjmxW6KbZeRrhtj
	/PhcIxHCNs+HKT7vFCoDPxkHcp9Thh0SVizBgnOtmqqiofBprsK3tONg7Xi3wZEe0BtGIJjKdFF
	9n4O7XGms2ilwvjLE88hiHk2c8AZAiu+8X4VWl8fqlYdgYhHXNeYhfsmGRwm9ANmQp4BB7d8YQy
	5llVyZ68bOCzMtHyL1l7l1Z6/RzN8nSyF25k2zlqHO9OcQjzw+QHYb4ixgYibiHCP3MO8fsDFkp
	DOz0256gk4UX/5HHzJfbDgytTy1RrcFsx2poetJtUFuLYu8l+x0cpITyOV5KCFeqv3CRv4E7Xur
	CQ=
X-Received: by 2002:a05:600c:8207:b0:485:3ff1:d5c3 with SMTP id 5b1f17b1804b1-486febb449bmr76203835e9.5.1774085056253;
        Sat, 21 Mar 2026 02:24:16 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486fc61dd4asm160164665e9.14.2026.03.21.02.24.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 02:24:15 -0700 (PDT)
Date: Sat, 21 Mar 2026 09:24:14 +0000
From: David Laight <david.laight.linux@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev, linux-kernel@vger.kernel.org, Andrew
 Morton <akpm@linux-foundation.org>, Linux Memory Management List
 <linux-mm@kvack.org>, Nicolas Pitre <npitre@baylibre.com>
Subject: Re: div64.c:(.text.mul_u64_add_u64_div_u64+0x40): undefined
 reference to `__multi3'
Message-ID: <20260321092414.542ad642@pumpkin>
In-Reply-To: <202603211216.YTKRdi1b-lkp@intel.com>
References: <202603211216.YTKRdi1b-lkp@intel.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ag14fwek5ecs1uyh61zf44eocmb3i3ye
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 2FB1B20004
X-HE-Tag: 1774085057-824510
X-HE-Meta: U2FsdGVkX19qWf7Hi489A4eGG+AKhj6/oSdi6D9Fj3K1QQH0brIWvKr8puaxEbf2sgqPE1mzos0vkolNwpjMf2EYwrXAlvZOrLng+3lhY1pI0TUL6QGXOML7Vtkkg/C7Hfic6gbBhbNVQrH4JBQ0kB9KVnrtGDHzKv6JbrxDsdY6FuAxRJMShlCxbyuujcSdTDduC3nZomZMu9LYWDxI5107mSzSsArWq8kRac1CToBqEg91d/Y0VDSL8ITOUQU8JwdTFnXbJz48/uNLc61bhUMbzGvllhfijrxjXlf8bRU5Qf1JLmHAACJSunVms0H806DDX2LICq+lEdBfzADNSPW3Pe9bC7ediD2RBmbawETY2L1gKnccTrcxqjtxHRRPDHo7rA148ACpOlsfxIfhwQz8BICgQgaXV7PAlUMJ1oxxrkCJtmX3s1VlqejKJXXyOEpKGo9S/cCYsuinNpUZLBiO0BPJ7hgEAT5PkQz5wPsGb6mftj+iAZJoXN5fauWf2jfWUs2wl3Zy4ppSrgZwg8miisxTNMS/SE8OhDih55co1SQQfUemnQlK8hE820N8ECwogwTptxbeRQEOr2U5VjL8MavDNuTqJ5KMxTuDj1Z+5D7OHvG0DPoZcJ69hSs7fhVihBfcYJerajwboMqIf5N445wJFKRIIqCqT9pGFDoFhoeqr2Pb2DeJ1qzC3HQdZNZjMPxdrAlUceQhmIKwEOuTtKauLUxaN1Hm+02o++hqblG3guRNVsxv/bDkWBzUciBAmghNas6daQ8pOtMtRNhaaN7lbuIw/cfVtoVb6nBWf6WvrLFo22jbHn1oeU97FrJIDCmsjLiELHUhgKPtGlVLmqfePRMp0fI0On+zpi5Max6pBN0JxvAxDhTWrlWOVBqFTnNyfy4YRfh1GZAhZQBEuDD8UVfDbxzKS6xgq9O9NZjyhm9ZwvCmf7YLNjLKbFljvorFQNTL6YGx1Zs
 6zCUmaHC
 989kugCAOaKy743PuJVvCv6cb4RNyKJTlGXrXpuhKEHOpio4D2maj3rfoGdOOaDlU6tiV1quDJBvbdtwpiMTACz4y9Y0DReBZX92/8wyQSLAT6PlmDI+geBAdhmEkV2eeK2g42Z5mKrYjC2zm+P5PODl++Luk6yLBHYrs3XH/6YIDeoF6pgopkqB+duO7h+WEuykFqin25pLtHfFoYmcWHn6maA4vJrci2C7yD02SEYpbBZJmgTvZQEIHoyKsjYXhHZZJwr3fNKR4U/FbH42BfpArvJw7cFKw9QlzwySSq3pOcvIPLPtVE+jrqLJ4bAlkA+gxKUqi2zIstYe8wkMK1xT4NE2t3PzDXeu+nG6enJp6PUmWUhg8Vm7wE5unEuz1FCGlihotZJfX4Y0uxUf0t9xK5RQkUF+Xo9Firj4+1wTKg1zOuP7QQOpklTd/vGg8xl9lMs/ttjznEl5txryFlhXlEWJ3ncdu7LVa32HAF25ZwOr11sJ+9leSqG4v0SryrYlydKX2lcLsPq4Xnc+fpAOrLEmVhSRCdgM+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Mar 2026 12:48:23 +0800
kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   42bddab0563fe67882b2722620a66dd98c8dbf33
> commit: 6480241f31f543333ed0c7a209962412461f6e41 lib: add mul_u64_add_u64_div_u64() and mul_u64_u64_div_u64_roundup()
> date:   4 months ago
> config: mips-randconfig-r122-20260321 (https://download.01.org/0day-ci/archive/20260321/202603211216.YTKRdi1b-lkp@intel.com/config)
> compiler: mips64-linux-gcc (GCC) 8.5.0
> sparse: v0.6.5-rc1
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260321/202603211216.YTKRdi1b-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202603211216.YTKRdi1b-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    mips64-linux-ld: lib/math/div64.o: in function `mul_u64_add_u64_div_u64':
> >> div64.c:(.text.mul_u64_add_u64_div_u64+0x40): undefined reference to `__multi3'  
> 

I thought someone was going to change the #if so that __multi3 was defined
for compilers after (IIRC) 7.1 until at (also IIRC) 10.5.
But for __mips why worry that much - the function is quite small.
Just enable it unconditionally.

While this code only wants the 128bit product of two 64bit integers
(which is a single instruction) the full 128x128 product looks
faster than the fallback code that uses 32bit multiples.

More interesting is sparc64 - where __multi3 can also get called.
That function looks horrid - I presume it is carefully optimised!
Without any comment it is hard to see what it is doing.
(Not helped by me only knowing sparc32 from 1988.)

	David

