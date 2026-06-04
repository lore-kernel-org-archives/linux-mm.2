Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 005F9CD6E6E
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 21:32:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC5F36B0005; Thu,  4 Jun 2026 17:32:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9D656B0088; Thu,  4 Jun 2026 17:32:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDAA66B008A; Thu,  4 Jun 2026 17:32:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D37676B0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 17:32:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8936F1A02A5
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 21:32:22 +0000 (UTC)
X-FDA: 84843528924.22.C8FEB58
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf25.hostedemail.com (Postfix) with ESMTP id 996ABA0005
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 21:32:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hLYfYn0b;
	spf=pass (imf25.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780608740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IQN7agybo6gzy0fVoImTNH+8qqV3opcO9FSCB/3Heuk=;
	b=M0aPjxdDHqfXNZqQRGheEjv8ZOqWh2dIShQJ5M8ozo/ODxnfyIss1MXi5tvTsci7NLEZTa
	W7lOEIOATFEbNXKaTdDx2Ux4K400Jm9+jtaWd6fWDvzLB2NeNW0GcSzMh9v+Y3pWHpXk0n
	L7BYxyUeA5agVHB1QU7Lv8PVk0Llj7A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=hLYfYn0b;
	spf=pass (imf25.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780608740;
	b=lOnPzARG8zUOjGwkrh5++lgkL3f4RHCoqrqfUcLpG7RKvmmehJLsiVMnN90Gcv/LPlPOcv
	ptRDCwp7mxM3vNHOiTJESnsS08Z63aDRzS1wstlH+m7wfku82w1MxiNxtM5kZSd7TsqaUs
	1Kwtp1abuzqEjYN4jtdt0+SmjFaQ74I=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490bc6a7958so12604135e9.1
        for <linux-mm@kvack.org>; Thu, 04 Jun 2026 14:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780608739; x=1781213539; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IQN7agybo6gzy0fVoImTNH+8qqV3opcO9FSCB/3Heuk=;
        b=hLYfYn0byi+VWoQcfCfDS3FjHQSwUnIEzUvH86iRzgtz0MDb6HMfUop4H0cEE+Sydt
         NCKsClpw1ifkC6G7lNz+n/X0+xnYGYPq8EOugZMtXJgzYkAaYYyk52F5iJmbN1JLvumm
         0DKdUOOdykL+TAubxOzFv1p/1tj281GcmS6WU5mU2ngnh6XJJbbT0pUeeSlzb2+Xt4xh
         bH6FK4vBLVNXhEdWXyJOvY6XzdHcWMJXsCYQ8mojJKjC4J/VLiOcF167b4x7rK2mRkjd
         aj8V8O+HX/iRA4F5VkQ/D93SZ7HogfnI1rRsKuLMZSgYk3NoKRhTFzm0+TRusUCWGPVD
         3tlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780608739; x=1781213539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IQN7agybo6gzy0fVoImTNH+8qqV3opcO9FSCB/3Heuk=;
        b=XnI+t162CBe+E/lnhD1+zFOKbiwWxAph8k8AZXYCP4uyXhdiIBU112VY6rbUr34iCd
         PZT+a/OUWz3dtj6R6/sh39dQCwLbArUmz3V0VDI3ocnZWdlv11tXgVOsJ2vGyTSolj6p
         DWC8HmzkWQQi0QdJCfctX6gpw1kzPl5/9/nSYJsB9h0ar4XZyPw6XInuN3nykxCeeiYT
         msiEElpuLRwUU2QmoY00tnNnSe9qOQpxnWw4AXFI23m5kH5Fd51mOYS8srumdTZlS/hC
         gCC0fqh3Rotm7hFh5bCvuc8188lPhJZn+PaSDnDLnVZ9I+mS6i8qOWuoA9ZS+yPtj+yO
         jkQA==
X-Forwarded-Encrypted: i=1; AFNElJ/ghdYWc1HwdwDsxbzUXlTfOsev/GFNu79kH7WZlzRLY6rYE2J3+opORHwwv70RaFGOknFh05ih0A==@kvack.org
X-Gm-Message-State: AOJu0YywOlY1BR6BCdBPrIlgEghFdy6UXSfrZt1nl7m5h1EOYabXojpZ
	vgKqCvcvp1wdzn1E02oWT6NvGfPMAR3er+ekBkjTU0zv7uOl2hu/fgmg
X-Gm-Gg: Acq92OFbESdA9aUabaXfkQ+bgzYu5nwgLoULquINGzs9aga0lalrftt8PeDHkc2iEla
	aLZZV7KFhaCy/jkmOEPe9p4F2z+FLnM5A8zfl7A223zPrakjspTxlDrpmbZAy9gH8S0dX5f7Hxa
	+Akh3qHHoS1ht5zmnyfxyd0Hv69fhG2s6kNfw4w1wJt0orQ8DI9hWpOHube8JbDiWgsvrS0/vmE
	o+Hp2DhUxd/vY8hOztBSR8a/ufy9KmUmmQY3PcTgci9hMApiZXeOOsi8WchaVik7tE2cfxIq40k
	VEodXeDNVzFuXS2ITadeuuhYKRyGXjbANAEMRERk/ybALERdOB5CdUrkuqtHHHRsc5b7ra4ExEt
	P28uD8bWs05e8Rd3mCvkNYyz8CPH4bEqTVkcHHZP8Gf45OmeijgbgbTjhMWjH3kPKwrkVP6M2Qe
	2QJqpexW+9l3p+ebvYb7T/y9vLLB4WoiDXQgVzigqCFZFgWi2WuuVEVseegi/uYy52KEbekXI=
X-Received: by 2002:a05:600c:348f:b0:490:4b89:5372 with SMTP id 5b1f17b1804b1-490c25e2739mr4133095e9.11.1780608738825;
        Thu, 04 Jun 2026 14:32:18 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3918fcsm111713545e9.3.2026.06.04.14.32.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 14:32:18 -0700 (PDT)
Date: Thu, 4 Jun 2026 22:32:16 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Askar Safin <safinaskar@gmail.com>, metze@samba.org,
 akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org,
 david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz,
 linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu,
 netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de,
 viro@zeniv.linux.org.uk, willy@infradead.org
Subject: Re: [PATCH 2/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260604223216.73468830@pumpkin>
In-Reply-To: <CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
References: <f919874c-065e-48be-ac5b-300c4ab86d4e@samba.org>
	<20260603211736.755139-1-safinaskar@gmail.com>
	<20260604100609.6b37f500@pumpkin>
	<CAHk-=wjvb56qo27-axALOKCY-CjLsj9_294zeBovPVJaYm14dA@mail.gmail.com>
	<20260604183829.63c35fd9@pumpkin>
	<CAHk-=wip3mwLOHOYJ9TtjDxOaq9YUXmuCg2AycyASGgeY6qqUw@mail.gmail.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 996ABA0005
X-Stat-Signature: z4abxp4effr6qq9bac9oyyt773souw49
X-Rspam-User: 
X-HE-Tag: 1780608740-769012
X-HE-Meta: U2FsdGVkX188FnMdmhUtEP9SsZRbz0Fo0earhqaNqL79+LiCRmPO9PAIOUqlmp1fkN6bW1HCg56uNCS7XGcIbQ9frxqSztEPDhH2qV5z9/v3u1Ovfvxy99HBQ9ESElRwEUKb+iqvumTYabLbjQoHSgl2mBujNtUXDtu+LZrv6k8GAr7AG79Uy6hvH/ZqMjvtvbOWTYVIzUOlOGGU+sQEDXbpeoEQLXKMoZdir29uz4IC7OrDwglWr4CgOwoz4vAoRss7mTEaWvtzPWyeVFG5Kv+hNGrFCdH5GfjOINxpX4/+RuXBdRkWpJPQ7xaXr1JRgF0uukBttDcfpSpDb4+tpPm6pNw7RcqFEmuEMeWvMF9Isoz/08Hsh5jpwDdOMrVBols9U0/2WrE1Edbba2+jJN/8rjWi6DvGLqkEX51cT0BfzRB1tUkUXQnsgTUpMRJDI9NFLnzyP6lC2HQrU9wV8T7442uA0upGFmyC7d6Ielk6z1ulzVP+vbkAI3OD4o15G/Wd8EiL1uav92/hDxuVGN1Z+f5uYDt+x3DPR+yv7QWYtQBVxoK8RV2t1LDJ7Dfg5/VfJYslzT2apgYb437jBRZ+s+kjWpkQMXTj22NRiSZ0Iqgtrww04sD3CUVeVza+1dwAlYPbNJyhDP1gTpAkuJCztQenpeevAxruxJ3vpFBt+IPmHITEP6eo4mlCs04AoaMRDTHCugvYUg8kwdKbQkOoeE8+o70G9xPqug2vusPEY9JHeDXmD0bCMGmz6RGaahC458HACN3HmcLdn2MlbCTc0NvctuGObSpXS46yMj+Sq4M/uS1xaVhfAQBOXuMG6ywqrUBoxho2m9vom5dDB/ipWd38CYc8GVEtdM5RRMT1FZ9+0J2P6OVdrLhhl7cDrEGl5z2JOuCTeBa8ZvM2/JFkfY5/9+fgZA+xY64IPOvzNc4IIcSVjGxYjjJ0HjLPTkOB+FYa9ah39B1z4y9
 gQT/7r/f
 Ypq3x2xvfTD/9Oskn8lFYMmoQDqCnC0+xgZdCDSFGd8ikf5UoHixPFtDpvy54q3qDr//TBw+w1vXzoaEvCPlN1gXYMesHDQh4IgKmLLV3sdbhFkBxNf1Mo8bq4aJ1rmP8dwL9AFUm0pC8ToMnrl1csouN+I+MrvjuBFdoZO8a6hAzPyJfMd/kPQD1TUrty0FSJgf56vbKOfgHtrgOfIbSjiR3VSUJbeXJ5wUyX3lFVoj5Hm6v6XtAeh3K0zy9iKiLnEMdNOFo3bq3Q2RK83AS0W9jJ3/7JwUNBRt9MIOFHDWVuUcEmCCcQyqnY5PSX51Dokkukgkx9PSEhPmJB9ShkyQQZLgjSdOVI/4HIYaWJklXrsA/TcQQ8ZJckgat2W0OujN9t00Z2epeNp7OBCmiUni6T6YCg0EZfSTMZvQGfaWSUjusQmHX9mY/ydk2LaSUh3lLa5EM8Aa/Cr6m6Air1HRWVxnPOkWJK24utjaLX0ydl7xsvc3aYZDSbYcoBINEcXNkGrqFQdF9mVUwvxW0jiGHeAAVgASbyiBSkQbVizuB11OG5KLYlgZ+fV3GfEKzZvrL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Jun 2026 12:30:30 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, 4 Jun 2026 at 10:38, David Laight <david.laight.linux@gmail.com> wrote:
> >
> > Bool is another matter entirely, (IIRC from a couple of weeks ago)
> > gcc will assume that the low 8 bits of the parameter register are
> > either 0 or 1 and clang assumes that the low 32 bits are 0 or 1.
> > You can't even check with 'if ((u32)bool_param > 1) error()' because
> > the compiler 'knows' it can't be false.  
> 
> Nobody should ever use 'bool' as a system call argument. Anything that
> takes a boolean should take a 'flags' field with bits.

I was thinking of more generally, not syscall arguments.
In C you can't really guarantee that a 'bool' variable will always
contain 0 or 1.

Even if you write: https://godbolt.org/z/81P87vv7o
int f(char *p, _Bool b)
{
    return p[b ? 1 : 0];
}
you get *(p + b), neither (int)b, !!b or (b & 1) make any difference.

Talking of broken compilers, had you noticed that:
struct foo {
    int a;
    char c[32];
};

int b(struct foo *f)
{
    return __builtin_object_size(f->c, 1);
}
returns -1 (size unknown/indefinite).
You can't use __builtin_object_size() to stop code running off the end
of anything referenced by address - even when the size is constant.


> But this is basically what a lot of the SYSCALL_DEFINEx() macros are
> all about - sorting out ABI assumptions.
> 
> For example, on powerpc (iirc - maybe it was 390), a 32-bit argument
> is always sign-extended by the ABI, and the compiler *depends* on
> that.

I think riscv might sign extend 32bit values in 64bit registers.
x86 and arm both zero extend.
Zero extending is more friendly to the kernel where pretty much
all values are non-negative.
I think I've used signed variables slightly more often than fp in the
last 47+ years.

-- David

> But at system call boundaries we can't trust that the user side
> actually follows the ABI, so SYSCALL_DEFINEx() will actually take a
> 'unsigned long' and turn it into a 32-bit argument so that things like
> this are well-defined and you can't fool the kernel by not following
> the ABI rules.
> 
> The same would be the case if some system call actually takes bool
> (but I don't think such garbage exists). The SYSCALL_DEFINE() macro
> magic would take the full register content and *force* it to follow
> the ABI conventions, whatever they are on that platform.
> 
>               Linus


