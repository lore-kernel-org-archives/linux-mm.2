Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C8E1CD6E7D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 17:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A91E26B0005; Fri,  5 Jun 2026 13:12:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A693C6B0092; Fri,  5 Jun 2026 13:12:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97F666B0093; Fri,  5 Jun 2026 13:12:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 83E4B6B0005
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 13:12:29 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4AF83C132A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:12:29 +0000 (UTC)
X-FDA: 84846502818.07.36CEE32
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0DC8840009
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 17:12:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Zz2xYX0G;
	spf=pass (imf11.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780679547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbDn0l7MCqGrATagRYR/CBho/Q+7UgNMgo5uDntFVrI=;
	b=g/ubydO1v0R1UlugtVJOhc9nBNsJCtUJWtBVdvBubCpIbklIueU64CNqBkc3YScv6lYXLn
	xG8BapNIhlHnjfm1Rm+Hd6hL9MSy32tiSzKVB8vgDP2lh5Pde+jIVCG0JDrzr1Neqanlsk
	3mTwsitKd/ghT7DFvAaUGNSxC8TCyYs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780679547;
	b=1a2q9F5ex+W8hAgMU+9AKnt2yhAiU4IA/+EZMwJVXSufZKBql6vpvh7fUZaC4AoayK8UX6
	VA+WD80QngrTS+R2cOrlDawtR+6dt7+5rsQUx1D+i231t3TdXXE69G/07s6Yhdt+0i0Pla
	dcI/kpMurQQv8/mNr1LXh2V91Py3480=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Zz2xYX0G;
	spf=pass (imf11.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.52 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org;
	dmarc=none
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-bdb3fd39045so276464566b.3
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:12:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780679545; x=1781284345; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zbDn0l7MCqGrATagRYR/CBho/Q+7UgNMgo5uDntFVrI=;
        b=Zz2xYX0GBira/eZAn4tbuVFU7oXprlVVBXvWCw7+9GlWxDLKq8lkswaTAzfnvXFye+
         QBUiGG9FFcFKSjKEtKcjmilrugKADAyr1ksr+tiJEUh2rfvoAwBmtHGcnfNrtwGIM2H6
         +GQvCYN9W8m5QPuc+Syetv3/AtoOx5Id1dNmk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780679545; x=1781284345;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zbDn0l7MCqGrATagRYR/CBho/Q+7UgNMgo5uDntFVrI=;
        b=Ssuwgu3ndrnjCjDg8YHOIAy8wz/7y0LN8BBR55WfFZissUt2JyngIzO+bA+aUEl0q7
         8TNCZiMpIFVWfeAv7z1cafdiieKbl8hM14uW7zKmw23zTK8iVCXd2jBqWbE2kQJj79h9
         ZuEU51xTOrl367MWNDFls0fufAlVHH4ATGtayonSPdHUw5Bure3xnZZim1ZvKv+JJLF0
         JYRLilDKb8LcXxiYkKqDJCCyxAFeVlpF6ehMXd1N8lXgOu4rV1c+o11+eGEMt05VGuz8
         VArwvEi3a2rJ9e8CsZWnwuAIpCHi8ETEBTPdUGYHfp3zil/YHTKPExRHGzS273Mbd6wR
         fb5A==
X-Forwarded-Encrypted: i=1; AFNElJ9i7Ey5gBeNK34FFiAvuw4zKiV9w+Fb5vtGShccfvl3sNgDUQ9pLtLuaExTTzNZvZi6S++53Eh58w==@kvack.org
X-Gm-Message-State: AOJu0YwtboG0frWuKdKvlGAHfpK8i2eo2NK6JvIynHrTXV0MWNJnq8Hk
	jDlicYkc4tU1bXOT7h/oQkChvwQ3ggcEJqJqssGwuufidFpAiO8VjvPCQt4PnstKtA0BiYu3H9X
	8nIjN6hkpDA==
X-Gm-Gg: Acq92OFFqalZPPSMlRYulBHPrsVLPYe/qyHVFAX5zHPlqPRpo4GfmU3heN7jjPq9MIR
	wGats0/e/ZAU17rji03KQ2tupCbUYSnvv+b7z2ZOELnFiw29OBonpiHtxS8BjqDIEsVuYSml6xy
	yma1XLbXNjv5S3wNm9BNBcEpcCKsjN1IzPcz9oaWjdDuD6zmjbQVR3Q193fNSM+r+RH5SSIsIjx
	149nzrEEyGZKBFogsSR669Os/9e8AQoPU7KilpSZHPCJmF9IKUBKvTAgwRif10/M19hRDnpffLM
	Cht/ClFklFTfZxvjrHGIYH+7tGXFE02DvIGLhyGGnQGR5/oFhZjFmy2cmO8+XikDZuUDoDSaBu3
	aCV5HtVO8NgSe6/iPPrbTmzVfzeEqA5ujhWKriIE5mZt7lJ74MMVHGXS32KcHa5hxEW86/fy2+C
	GHnocN4ykJMLXZ5OV/QVb+GDfFgbkfKFBDop3SqpxtXH9cCcg9DQy2kMvOpTeADRwvxH/s5Xj1n
	a7QnDnR0fQ=
X-Received: by 2002:a17:907:9686:b0:bee:323d:1239 with SMTP id a640c23a62f3a-bf372e1e4fdmr280009166b.38.1780679545281;
        Fri, 05 Jun 2026 10:12:25 -0700 (PDT)
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com. [209.85.218.49])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-bf0558f3885sm483642166b.54.2026.06.05.10.12.23
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Jun 2026 10:12:24 -0700 (PDT)
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-bdb3fd39045so276459966b.3
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 10:12:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ8KBW0kzPeGQjgF1jLqmXteEAPez+w63JVTYSvfk8ICYoxDew3e5ZdPBL4iXCpvFQJzXr8wKuxcrA==@kvack.org
X-Received: by 2002:a17:907:2d92:b0:bf0:59a2:4ccc with SMTP id
 a640c23a62f3a-bf36fd9bc68mr283989066b.3.1780679543586; Fri, 05 Jun 2026
 10:12:23 -0700 (PDT)
MIME-Version: 1.0
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
 <20260603211736.755139-1-safinaskar@gmail.com> <20260604100609.6b37f500@pumpkin>
 <CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
 <20260604183829.63c35fd9@pumpkin> <CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
 <20260604223216.73468830@pumpkin> <CAHk-=wh1Avi8FGbWkt9k0Z-KXWB0spo5mQyowO8PB2sJ3unbkw@mail.gmail.com>
 <87se71jps4.fsf@oldenburg.str.redhat.com> <CAHk-=wjkZSAhxykvG6tQM5DnBoS30_XCKkYpCsQwEGcxJb=i3Q@mail.gmail.com>
 <87wlwdhrvr.fsf@oldenburg.str.redhat.com>
In-Reply-To: <87wlwdhrvr.fsf@oldenburg.str.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 5 Jun 2026 10:12:05 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiTQr4YYYUH38srGvWAq3_UpDeAPR+qZWVyf-ZU7z8Hzw@mail.gmail.com>
X-Gm-Features: AVVi8CckZsnJXSGEqzilnfJFExIfoQ08Dq0LHvA2PxDFlkolpXQtrHtyU3UQHDE
Message-ID: <CAHk-=wiTQr4YYYUH38srGvWAq3_UpDeAPR+qZWVyf-ZU7z8Hzw@mail.gmail.com>
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Florian Weimer <fweimer@redhat.com>
Cc: David Laight <david.laight.linux@gmail.com>, Askar Safin <safinaskar@gmail.com>, metze@samba.org, 
	akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org, 
	david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0DC8840009
X-Rspam-User: 
X-Stat-Signature: q9qeebcoaffuke83na3s5gnkddu5c9yx
X-Rspamd-Server: rspam08
X-HE-Tag: 1780679546-64931
X-HE-Meta: U2FsdGVkX199Np34znPudO4PPjPCh/oStmcgFxcoKe/3gCyZ1Y3DsiUgitS+jXi04mk+JxWAisoUqnPD+J1rWYiU281s2J24aRr0km3bvgUbHjpvN91UwcqHTVoWlwfIDTjARU4C0deYQ9EA+3uSDRMWgtTuYj5EsSzD//CiLv5CiNZQh7rAoddKTEbpZqnsdwYu2kOv5PNcFCPFua000xZ0YmJ1zkMQQd+99GefYV75GAnggZB2XJiIJcWVvfsIrnYmKZcJeENXYTXoD24wWEoacz9YGAPzcaUG9mgjqChxlEbjFnvfLJaveicOPzj4tt5u2MUFZ4mDymVDgOLwEh4WIXiqIVFhVDfg6T5mdA5QEHU5Oz3Wm+mHLOC4PqCLiwVXAOorPQ2A/zk6icsRey7Z39VoHlOf2e0qHvaOInx60Xgtd3ANbhU7T7y3d7vHJ37yEzqn2Iyl27bqAfi0sGi779VbgHGcy4T6wiODG8t8hSPOd5nu9jg0JJj6IxOPeFIgAnBNtXrELoe9LGAFZAEo9Kl/TfGRGN44Ezwx2KuvV+1zeqSLJEoH/pY9mDH0ODoHkeSlXE1hA92a63+uIB/o1A7v7HfYJRsYujMIv+yNhv/3Au8NGcmA/++E0geMoPYzUj2WQd8rdDMmJxAYPzvb4XSkAghyZgbE1q648BUYgRvUxCpUlixANpOwg6iNYKgYxuX4BdfAhbIUVRuz0SFLtJnAgjVf1+evNS7KfHVpCJS3W9naLGVzPdAp5e8n/5NgjlFtZc4IWuAyXT/lr8OIrHKwQMaJZwOBZ7ITaljelx4zM6tjpJX+spqzKMnHxckftfsdM/xl6gk90nF4VE3xOL1gfuv+s0s49PqjPsdbGbzgVn2LleWnij52SmLygny431jASJaRJl4pr2j0JqGIkpr4yX+pkIF8efAFTwxDnHDUdB7d/iXSnF64rYG0YUtTqO1VMREKspNHTT1
 X4hlBu3B
 +9hlQBUpDChBku2iRnXX7WQXT98HLhJ6UWTLEEa6kOX0LLyJfVj9/qcF8GwwjWDL2eCCMUIUw4oWniZlMkHGQdsHjZPRdzEqrKsZuky895dQRrXKFWf4akZQpxbVq+yIyUi+9CvuZcEs14PXh8R7UME3ZlMH8XRSmh5/sHVD5S2Z0s70a2Fv7e7Ijl3cSqV9lW0jSpu4uAjnQEx96EasY1PtPEBxI6wxDbqyT5F4Gk14ihQ89JKF+xqextgPbKGGXlKUw1J9uRPAPPYCWMXDajkLtzE8XZBSAY4fJFCnfgSDJgbXqn2CFAZRo75FYco3Gd94oCNNKgXx51cIDQaKI+CJuxSTM51FhdS8evmR8XeAT3+rtG4JQA4/wwQCtn6XlFoL1xRNleIcnWicwHSZHjHVNHRprWcXlkVX5lnWGm+Z/sbYhOKsI1Sn5xrlySID3NmbvvqNpxNdMgc+nfqBKA0OvryziuLiBD/VjGtXQgi3ENNC5XOGGaF504fPH5V7AcEHT0ZDGgFzQ75Qj1oolSbC/NCpDRQ6SAcuxmuXIM2leOr9x2UadHgVhSruc3LJehFY8BuUkJr8uWHW91r4+M7QX8JcEYB5onKQv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 5 Jun 2026 at 09:30, Florian Weimer <fweimer@redhat.com> wrote:
>
> > Uhhuh. But that is only specific to 'bool', right?
>
> Also char and short.

That sounds like a complete ABI violation as far as I can tell.

Scary. Because I would not be surprised if we have code that assumes otherwise.

Now, the kernel *seldom* uses char/short types, and since compilers
are typically at least self-consistent in those cases and we don't
interact directly with untrusted sources.

The system call interface is special, but we wrap that for other
reasons so deeply these days that we'd not be impacted.

But we also do have various assembler code, and I certainly wasn't
aware that apparently compilers have been walking away from the old
ABI rules.

I did find assembler code that clearly uses just 8-bit register
accesses and function calls, but it was all _entirely_ within
assembler. The low-level debug printing in

    arch/x86/kernel/relocate_kernel_64.S

puts the character values in %al and then calls pr_char_8250() or
pr_char_8250_mmio32() with it, but that is *all* in asm code.

I didn't find anything obvious that calls C code with that kind of
argument though (which makes sense - we typically call the other way:
C code calling into asm code, not the other way around).

So at a guess we're fine, but it's still somewhat unsettling.

And maybe others were aware of this, and it's just me that has old
32-bit x86 code in mind.

              Linus

