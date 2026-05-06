Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D275CCD342F
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 03:37:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 134DB6B008A; Tue,  5 May 2026 23:37:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10D996B0095; Tue,  5 May 2026 23:37:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F3DE66B0098; Tue,  5 May 2026 23:37:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E31096B008A
	for <linux-mm@kvack.org>; Tue,  5 May 2026 23:37:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AE9FD406C2
	for <linux-mm@kvack.org>; Wed,  6 May 2026 03:37:09 +0000 (UTC)
X-FDA: 84735584178.14.297C8C8
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf25.hostedemail.com (Postfix) with ESMTP id BDE38A0008
	for <linux-mm@kvack.org>; Wed,  6 May 2026 03:37:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YRqIJstE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778038627; a=rsa-sha256;
	cv=none;
	b=twiLY6tPuT5FHaz1U6Q8CBTP0PO4N/mU1M88pBS8wgMFdwcQsr+yQzI/AJpDnBsFtBFvnp
	j5NENt2Zjv6JaOiKdw+BWiAXetAhUAaG8p6K3DvHk4OXE6Wp8EDZmMmsrOMghtVnGgfVbe
	3/+514/WOD6rG7cV7oyR7QFo0nSMOF8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YRqIJstE;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778038627;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fCDCxjBslsLzg12I6kYRv855qs8zfp4TUfhArChtOWM=;
	b=Rk1k8QJHO8UXp5csCqqvM9VFWQ7j4I+S4n+uG4euqOUDu4LKXVmkjwSj6j5c1xtivy2Os4
	3127VFhgFRW/kYpw3xh1QNif3nEDNOsb83hPCOAN+isMUquqOoz9xL5KZTJ32DeudvChE5
	FHLovuYDtu0WHsoWLUpRub37ZLh9u+s=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48984d29fe3so84663325e9.0
        for <linux-mm@kvack.org>; Tue, 05 May 2026 20:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778038626; x=1778643426; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fCDCxjBslsLzg12I6kYRv855qs8zfp4TUfhArChtOWM=;
        b=YRqIJstEMGTY7fV44uRxmNcNgNLDG3Wf3tJVjNMP2sjfmFRNrEnPBz5Dmd3+ACDTab
         B7fbo6YqPDXGu4Fy8bA5JKA6KCOYZXYdz6YgIWKzclsXLbYZdHOvuwbaTPuT0ZbuSmz/
         GFwuJ4GSQ7EngE7FNSFnB+7iPOwuxbNnQ3mpsErRlpCgeYyyzp9Kk6NSlDsl20p6d+N0
         4KRPLM5xQOzD3KLwppZb6vwsx7qL9xeb7C4Lpj6R1CG4vLR1cdvOTF3Jb+RCy+QDaRuc
         v690DXyzf6oqSe5QBhUhBgyZB/vBLupDe/jVj3/tR0We4H41vNrJjS1PFzqQ1T6sch3O
         LPQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778038626; x=1778643426;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fCDCxjBslsLzg12I6kYRv855qs8zfp4TUfhArChtOWM=;
        b=ov+RA5Wc+vWfUY2BcviQJpg5q/JOZjmxheIVI6C6Nu0ndJCz1AmsL0y/hW4TOBAhI2
         BMzrF7Spm3Va1K75fIRy2mkutCInxE1RwTbSIeCeP/ypd3EGuLcorG0CepyEq2b5IacP
         7yF6CNq7CtF/1+FsdBSDZ93seQT90oyWc4gi3Vx+eRwcBDfZlAJF1ZqMvu/rC1aNNgpz
         OpWwtVNH/FHLLFnkLHhiiFS5jLFGGnD5ikIthDl0wwjb2fzd4MMydQA388LNrlHti1M+
         dZp1hJD/dFbaD+6CvFMNpmqCMraNYDj6wXOc5bqjiirQCVFNpWMDMzfD4pwav/06d2v/
         4wQA==
X-Forwarded-Encrypted: i=1; AFNElJ+VBMaU/D1zRTnUwllqLLZSZ4IGMRp91cFmJqEByFPmG85yPl/GZ7V7alefzt5qAlcKEDqBDlKpTw==@kvack.org
X-Gm-Message-State: AOJu0Yym/fFZ2+/kK1VYSMwe2cC8PsXYJIgLgk+X0ToL4FDHz/gN9mPk
	zvLqQGUT/d21TzsRX8dVezYl2uSN00ZatEVY7z8BedGL/8Y8Be/p89/x
X-Gm-Gg: AeBDieu7WaHcC/PPk7i4bzWSeIMRuxx3HpsXDWxEpDsqz4fPqB+H+NWGUNVOgmUZ2XU
	07jQVDe/DxoKxt3wcSXWses7IKMa3z4nlyGFSovX0C6+609Iemg8w7URABwfwRE41soMUVvsT/D
	jHgtohfC44Q28k1BU7ALH4sYVNs02P6ZsO4DgNph/1hVa/d9XVqp2UCKOZEQ5MgHHRSL9gUrWYk
	VtGjBGMfgg6ZqO1j3MC+D+1PQlACOyjOrRVrm/A/W+/6OOBJZr5MHlN4BjByYMQ0WeBbwGY4183
	deKE0nHFgdZWgcVJ9ZUXe+gEzTUKEhMUJJi9BM5DJN2ycsHPHnugI6e7DWWR289M6MDz2Toy7PB
	WUGPcswkmbLmplcXsX5NeVNkBzm8zpoYXFUBGqi4izuT/88CSirOBSxB4tJy0fmLx0j/m+3Q5Fr
	tJNPk8+7hR/B+Q1OL/qrW5msCv8kdmdbVA
X-Received: by 2002:a05:600c:3e05:b0:488:9ed3:1492 with SMTP id 5b1f17b1804b1-48e51f2a997mr29947945e9.10.1778038625870;
        Tue, 05 May 2026 20:37:05 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48e530b19besm7463115e9.7.2026.05.05.20.37.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 05 May 2026 20:37:05 -0700 (PDT)
Date: Wed, 6 May 2026 03:37:04 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Maxwell Doose <m32285159@gmail.com>
Cc: rppt@kernel.org, richard.weiyang@gmail.com, linux-gpio@vger.kernel.org,
	open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	Lucas Poupeau <lucasp.linux@gmail.com>
Subject: Re: [RFC] Precarious macro in tools/include/linux/string.h
Message-ID: <20260506033704.bpqcp2ydhoc45yda@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <CAKqfh0HqJoFRPrgvQG84iFt-0-vQd0fz3x6EPhzTgikss+XiWg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKqfh0HqJoFRPrgvQG84iFt-0-vQd0fz3x6EPhzTgikss+XiWg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Stat-Signature: 8rnyrt5sxbhkwuw8x4b7sj4ngxiaouta
X-Rspam-User: 
X-Rspamd-Queue-Id: BDE38A0008
X-Rspamd-Server: rspam07
X-HE-Tag: 1778038627-257153
X-HE-Meta: U2FsdGVkX19MUAu/rSbV9++3Dcq/+ryyTfsZ44YkyxYvU7LsE7GqC7znysCITDiQUPHhXb5XfkrcOuSRoLI2smYv1fTuLcCF61NxdDo/nBGuB+mY4/3l5fxkyg9qtGWjRUdMqBUjwBqz5GTqM1bAPheDZjp/TBclc1K8qe+OMwiOBK6OeLgCxjsMxg/4CgKjpctbEjXuShXzW/K+Vnc2Hf2nIFh71JfFQqFol5xre5sByiZbAgLx7Yr+Q09p9ZEIzLFUJMBXYH1Hf/monKa9s9NygeZnWN8okxF0nrPUlZ89F0hxh15yBviCEyjRL3E6UhzUBsAh2U6rboszrcgN2UMovw/FRo9taFaGtBTucCSBtN/GvCc/YRJVcLk6S9tmb557dU0MV+xvtkjcy7dYbPH+6rXrU0wrbwmUKbTkTDeiIm96fyCgf5skdh4bdzH6SSEf3iXRify2IxEMTH3++pLgVNaZtRext3S1Sf9AfvM9DpDi6BhOdckKbPUjMVhFNTef4B0zjO7nrZYtqNjv01uIDsAHBEeSwhuET6laEVf/1t7p005LSp4KvEBTlXqvaWvYcez9emuPi/Z67S1Xv0vx3p8Z924tHbxdJfg9ofw1u75BA5b0Bl9YBDQCTENPe64+lmQjxxhdDvrC6+BXQ0ak+1308pkCPiGLkOIX2Csxtn0VNU1FFzpIjXJkAIqikkJuJgIvgVlB/SvHUB090zzgnnq9kx2f9MUcxPHsAO4WSX+cZxM2IqoUBF3CwHAp/auAeWweWJDya/6EiYoJFZkV0Bma+leZ24qLLHQl34XQM2y9EJRjqVESJDW/LLqWxsDS7svAwvpfpFSJQIBLDZv5xEWSZ8XN0umq9BnsafymdTiGwos4lPeVwqAG2m0u8n55cxhp6S4PQg3I8lPDmRWHVXYzH5RzOyYl8cNWttY4x8GgyrC+akufbg1aTsogjBVk+YYiuHdbIW0f3v0
 KosSQQSN
 x6RH47TLDTq6yY2ow5R1usaj38hOVpW6X80JWsXfV8vgUB0VoxG+IRAVq2eLwECBvDoLmY0OMr3d/TVyup8tt22+oY3/1vkUKgVRACCtKI8BXgx7KJ82QNeUCFjxazPu/0EazepO1ONFdMRJzyz+prIzvP4eAb6A8ISspP22ai07X4v7FZVUn7Kt2uAyWEkvsHioDlBl8vS8BoF2JiuVNfZ9ANLNX0w+E2c5WIgdgDBrnss5g8iMt96xT9Q5iGJYH7rDc+5ZuGngXZFUlw2LtX2BDr2wsRtXTn6Lz7oFi7ufg+FyZgfa7G0fjH02BaQUwFvsimrx/1NLPN5n727zOHBE/iF6pC2CZ6F2stzoyCwIoSGpvnO2Co+vwfHirhTnHRpVsFp5dIzxAM+RDtiTdDeEDXm4cEKlsfNagyQNLI55vaDCDAQBynXZdxRwWoPeIojJ5WIMVMvnGHXmZWZ8+JvNy2s1ykBk/+3HYCgo9tNq2JzfY6/es1HlQ9/aKEyrZYBJ5iBDkgktCRfakH17GSPbJEA1fsNzuZ7fr4t0Prl6htYNl6AX2gYTxmcXqpDrbTuCuJvCjnkQALVGMWmiKREs0gr7vh2NYXrqG/FsA3hbQgjbC98i8UniFqo1hXgNzyIg/ou90NY3bTiHNFYVlIpb3wFbY4lW6iWAE4bDwVnEdICTpep8+irRQH53AmSI4IwI1z3WpsCJacxQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04, 2026 at 11:21:35PM -0500, Maxwell Doose wrote:
>Hello Wei and Mike,
>
>I was recently helping a new contributor with their patch replacing
>strcpy() with strscpy() in tools/gpio. After some research I put a
>hold on that and realized that strscpy was defined as strcpy, which is
>extremely precarious and goes against the ideas the kernel has been
>fighting for for years, and I traced that change back to commit
>9e3d665 authored by Wei and merged by Mike. I'm currently working with
>said contributor to get this alias removed and the proper function
>definition added, just wanted to give you a heads up.

Thanks for the effort.

>
>Are there any tools or dependencies that rely on strscpy() being
>aliased to strcpy() before we replace it with the real definition?
>

The alias is introduced to fix the test case in tools/testing/memblock, since
reserved_mem_add() use strscpy() but there is no definition in tools/.

So replace the alias with proper function definition looks good to me.

>best regards,
>max

-- 
Wei Yang
Help you, Help me

