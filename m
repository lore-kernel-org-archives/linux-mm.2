Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAAD9D68BF6
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 10:24:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F38176B0088; Thu, 18 Dec 2025 05:24:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE5D36B0089; Thu, 18 Dec 2025 05:24:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC7696B008A; Thu, 18 Dec 2025 05:24:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB1276B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 05:24:13 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 777025B986
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:24:13 +0000 (UTC)
X-FDA: 84232206786.17.38FE3D8
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8E867C0011
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 10:24:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jIIG0HZU;
	spf=pass (imf28.hostedemail.com: domain of elver@google.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766053451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WslnZ1panE0zhxGDe3aCJhXLiwIja75afp2ehy4KLwk=;
	b=iSo8BrcURuS/bMGT/3BoK2FzAeU5hENgL5naYgQM6T0k0AoWN82Ut7g8ntK93IIrO3QJ/a
	fge4yyuUmc4esOnvURl07JygVr6yg+dociEDIDqosBqWJSJdFYglwvp0t0GrhAie3IhY6F
	PaEcBpfyeUporDhl6x4yM5IGIFKMAWM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766053451; a=rsa-sha256;
	cv=none;
	b=mWY6Boh4zqKdaRS7iZjl/wBo4lE9CSWRSc+fP6hCraAPboX76+Ag+MoforxJoo27BiQKuf
	/3uBKQBjWjrUUtA7fdxQYFaVxQTd3QRpG6g7K4QL68mnuxSAc4i00yQwsOoRJh5Ysh2Qj2
	kPXEhwajonnrwFbxjHAQSMVJcfMkZU8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jIIG0HZU;
	spf=pass (imf28.hostedemail.com: domain of elver@google.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=elver@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7b9387df58cso839365b3a.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:24:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766053450; x=1766658250; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WslnZ1panE0zhxGDe3aCJhXLiwIja75afp2ehy4KLwk=;
        b=jIIG0HZU2ZJQjcW87NWDp/Ex69ygolaV663xZdpvrq7X8/DnbEDlonnz1UdWbv29kD
         99dasJmDvQpNrTO4MIQzAeugnnSe08Cicg4ZUdpN6BfhLDzu5s/g0UnWPny8jfiO34AY
         0gE/f8mjBRmkHJ3lcqUrs30Bi6NdgcHpoF9A86FTC+zNhwTt3MMHqRNKgra4brJh02Bs
         CLnwpOhlWB3wsfQlHS69nZgOLqtoe5Wil5FzW/K1gZahwt116J5XBlyafwMD0sw+YTfY
         91uPqqHlIpAObSkpLtP3j5Qggz+vIzUMrtpMlrKEHix5IuBjgolaf46Da6csIXcr9nwM
         1tkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766053450; x=1766658250;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WslnZ1panE0zhxGDe3aCJhXLiwIja75afp2ehy4KLwk=;
        b=V79TxpwvvjSX7irakT+dqAljd7Rou/deT2ftAOaQAJRQneS5SBQxMq/WJBNdM+V0XF
         tgCGTkh/yJx5lj4mboCRK4VmULOQ4bJ2iV4T4Sz+r1aSpSTVe8nWg0/Fm/DyqyLr06ys
         qLV6qPm+7HpY7BcG3Aw1vgOZo1QBmBgVV3TU1ALZp4AFnE5mctouxeA4YOTUdLHRJ0VS
         YVq89bW49mLrYic55gn+yrRIcxr8A3RyLCF6J48jQ74JiBBt/nEzZUIYaFk/99AZszo8
         SGPxOhzaCH3Ffxnmb11PlAPQzoD2FeP7utr61OMYKwtSBT6TrRTI97SQD+IG502aeYww
         V98Q==
X-Forwarded-Encrypted: i=1; AJvYcCXNDDvzbz/7iMKnusiD2ubgOBB2w3jkF9o0z42svxYQBmkj3sgz43QoTBinQtdrN6U1PAjjSGaD5Q==@kvack.org
X-Gm-Message-State: AOJu0Ywu1Urb6kGZ+WOE2PZJiYOvDxWOEWhMyjlat6+xMKNgK2cOlcei
	fNQituHYox8tSCTqga4AwVxpgXidwt6mVtP+wHNL6U82IcinvCMEGEnvBeE39+C6TBGr5LpprTi
	Q+SjeMyfEQcq0K8yUjP0eFynMKhCGPZV2p2u3uVuO
X-Gm-Gg: AY/fxX65YTdOa0ljAWCJO/1elMqXrV87WoiNxhC+Iek2T+YYtlFiismJplbpvCHrxyO
	7PEP6YFEONE4L5SPtojLfvsXkEE1+1gz32lqRDCI0lEs8WojMSLBtcbH8Eqg5BSzqVcWLMNlWOX
	hMJ67+MEQAIIUt9CYUH7cW0/UcxUabRryibkT75oHLSMQNeSrQfmFz3S0RDAfzb57S/AWvYnfq/
	ZRrmn89ryPVF1RX/9aHZm72pXHYZW85SlwJ6DMi/ehg5fOZ80SxDNPuJbxQS/KM57NjY2UeLEVe
	+wI1e45A02YHUfShK7agvVQaSRxMXivWTyzK0w==
X-Google-Smtp-Source: AGHT+IE3XdpIoC/X1A6+tWvYnN30WmVoW6ll1XvyGtof86Vu1FcZWimVqNDhIQGXBSpdKroKdRnMo1bxnzQC1Vs4On8=
X-Received: by 2002:a05:7022:f503:b0:119:e56b:c75b with SMTP id
 a92af1059eb24-11f34c2625amr13304701c88.32.1766053449983; Thu, 18 Dec 2025
 02:24:09 -0800 (PST)
MIME-Version: 1.0
References: <20251218063916.1433615-1-yuanlinyu@honor.com> <20251218063916.1433615-3-yuanlinyu@honor.com>
 <aUPB18Xeh1BhF9GS@elver.google.com> <7334df3287534327a3e4a09c5c8d9432@honor.com>
In-Reply-To: <7334df3287534327a3e4a09c5c8d9432@honor.com>
From: Marco Elver <elver@google.com>
Date: Thu, 18 Dec 2025 11:23:33 +0100
X-Gm-Features: AQt7F2ri_watnVgJFp6cbP7eAfmz1Mi-buK4oLrIxtfdr5TG5N1pjsoHb_vA5KU
Message-ID: <CANpmjNMmiXjifpc9LdCVi5jzzKU3sgb0iJn7P7TMFMNqDH7TbA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] kfence: allow change number of object by early parameter
To: yuanlinyu <yuanlinyu@honor.com>
Cc: Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Huacai Chen <chenhuacai@kernel.org>, 
	WANG Xuerui <kernel@xen0n.name>, 
	"kasan-dev@googlegroups.com" <kasan-dev@googlegroups.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: yo6dbd1cq5mupwgfdgo8yoeczse9foey
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8E867C0011
X-Rspam-User: 
X-HE-Tag: 1766053451-812015
X-HE-Meta: U2FsdGVkX1/te3vC+iwt2uYW3vY/WKc7Jwcg+vXppcFY8u6Bv1qM4hc5Zqm2abuBto9OZKo7BgITCjRSJmE/OJZv0KubLOQCbgT5naz/RPcQTZHbF3xJjWJ1SKCYVqJI06/Xs/vMAXoNVrLRLL9OlIVsCHrm8W09cH4vPXfIrYL/MQ/hlaSog9xBhEwqUZ2nHB7oFKEmG36L5KxZw8+CJruzokoiMoUF5JufcAd4LcHNb+ewfojOKqIzxGmNaUmSkDPkWj8TGXkhTR0G99Df7+f4J3Usvoj+kIlxEDKmtFPRiM573Zq0iH5Qu2B6wmbB4dHZZD/z2qeFh1dAJxQRHS00iOp1+V5lNOMIFlTLoyent9ps4fbAjfM4MwjEn9sZNPmP6CbUPU2IX0+nEs2UFiArYbRtQOX+cRZbTeDqJ0WVk+W0sw9D5TolHK5ij6Cl26bjw9b/hUZI82XtdwQQnHXq+Jsm6YGIWSs661NMK8a7lCfBhU6sUZ4V1uXz+nFzBnNy3LzfHc8Z5TcbqhwMAPSbS1Q4lhzgPq6tnz8wQJKGorskShXkd887/+JAafyWIIA0iho37HIVE7goj+Yyzv2IEzhZFaZ0n/JWAp7t76RS2vHXVJrjGiAqXO+vH+5QDU18tqDoCufKICjBTWF40NvPt8CxPJrh+9GWso1ZG6HPDWadHsZt+kpBCll3Guf0DM32xo/11HH5PUmznXY7vafiua6CfGxQ4zxOEhA0VVDqMbL2xanfgolFV4e0IfYsKEQYsoOgFt9RcnB01vNParW9E7I02/qF1WP44xGg+3GZZW/pHzTn9m4WffSFBdmqDipEvd2dFvkN6q+z2PWwIpJ7D2by8Gw93tSjIsY8C51Gmt9ihAHyzGFvYkmvRZ/c7KTM9jXDW/HvBlPbE7Irufu0lTd+GhfA1P93CKzC4IXwAeCXw5jb5BPqvgjq1oynPeVOprOl+gfg9wZAy7+
 4FNT6ycM
 DIYmIviJjRP5vRtRslOS9POqRJDY6pZDmn15Vl233R0W/k2ZzCz4L2nFwu5e4DLR9CRACwqqJvAnpOItREufQgJyfkBJkyqwfft9Y8bn+ds0aYHj2djkaBOgqq/y7js0GJJ98Huo1sKk/RORdcuOcNSQBBKF8NDQxjQwVl0ZyXUiEq38dxfZNwyI9MFxU7us7dQrFMqmvWx2GbtCKJKatnzaJBxydryga7phxmeiJhbjIZaryKMXVHiyY4qf7TbrY082lFb/ytPpqfrtWoDvA6TxWnb+5tZccgEpCEX9jwXQJroAI+qDpQqGC2Lxvl9nbkjcsjCdBNENvGsyETsCK/WyDtajSj6Docwmf3W97jS3eOP07Ld0AQw8+HCx8thTFXchpPpzybiE/j0GEEbGuc4yC6ouZAtNW/3i8LKz45IlJsaHcQsoBanSc9PsKS9HKbRBhFuPqUByGhlI8fyaoWe4yfPkie/isqVrDDyTfDPyeAitra4KNaQ8kEcWN3/1fsVWQC+g0F6NhDQ2paXLDLVim+pxkd+FBS4UtJkqUFP2x10OC9kdLAD15mX9FI3+QOyVL+x9GnMHEUOMf2s4+4c9ZKSCKJ5Zec376BrTIWsi/fND8M0WG2Jq8gGreo0LxzTh5D83Qqs4sGE6wXSjRqZ9zB5TuOwEx6bh5iT3X4NaSDK9y86SKDGqGUg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Dec 2025 at 11:18, yuanlinyu <yuanlinyu@honor.com> wrote:
>
> > From: Marco Elver <elver@google.com>
> > Sent: Thursday, December 18, 2025 4:57 PM
> > To: yuanlinyu <yuanlinyu@honor.com>
> > Cc: Alexander Potapenko <glider@google.com>; Dmitry Vyukov
> > <dvyukov@google.com>; Andrew Morton <akpm@linux-foundation.org>;
> > Huacai Chen <chenhuacai@kernel.org>; WANG Xuerui <kernel@xen0n.name>;
> > kasan-dev@googlegroups.com; linux-mm@kvack.org; loongarch@lists.linux.dev;
> > linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH v2 2/2] kfence: allow change number of object by early
> > parameter
> >
> > On Thu, Dec 18, 2025 at 02:39PM +0800, yuan linyu wrote:
> > > when want to change the kfence pool size, currently it is not easy and
> > > need to compile kernel.
> > >
> > > Add an early boot parameter kfence.num_objects to allow change kfence
> > > objects number and allow increate total pool to provide high failure
> > > rate.
> > >
> > > Signed-off-by: yuan linyu <yuanlinyu@honor.com>
> > > ---
> > >  include/linux/kfence.h  |   5 +-
> > >  mm/kfence/core.c        | 122
> > +++++++++++++++++++++++++++++-----------
> > >  mm/kfence/kfence.h      |   4 +-
> > >  mm/kfence/kfence_test.c |   2 +-
> > >  4 files changed, 96 insertions(+), 37 deletions(-)
> > >
> > > diff --git a/include/linux/kfence.h b/include/linux/kfence.h
> > > index 0ad1ddbb8b99..920bcd5649fa 100644
> > > --- a/include/linux/kfence.h
> > > +++ b/include/linux/kfence.h
> > > @@ -24,7 +24,10 @@ extern unsigned long kfence_sample_interval;
> > >   * address to metadata indices; effectively, the very first page serves as an
> > >   * extended guard page, but otherwise has no special purpose.
> > >   */
> > > -#define KFENCE_POOL_SIZE ((CONFIG_KFENCE_NUM_OBJECTS + 1) * 2 *
> > PAGE_SIZE)
> > > +extern unsigned int __kfence_pool_size;
> > > +#define KFENCE_POOL_SIZE (__kfence_pool_size)
> > > +extern unsigned int __kfence_num_objects;
> > > +#define KFENCE_NUM_OBJECTS (__kfence_num_objects)
> > >  extern char *__kfence_pool;
> > >
> >
> > You have ignored the comment below in this file:
> >
> >       /**
> >        * is_kfence_address() - check if an address belongs to KFENCE pool
> >        * @addr: address to check
> >        *
> >       [...]
> >        * Note: This function may be used in fast-paths, and is performance
> > critical.
> >        * Future changes should take this into account; for instance, we want to
> > avoid
> >    >>  * introducing another load and therefore need to keep
> > KFENCE_POOL_SIZE a
> >    >>  * constant (until immediate patching support is added to the kernel).
> >        */
> >       static __always_inline bool is_kfence_address(const void *addr)
> >       {
> >               /*
> >                * The __kfence_pool != NULL check is required to deal with the case
> >                * where __kfence_pool == NULL && addr < KFENCE_POOL_SIZE.
> > Keep it in
> >                * the slow-path after the range-check!
> >                */
> >               return unlikely((unsigned long)((char *)addr - __kfence_pool) <
> > KFENCE_POOL_SIZE && __kfence_pool);
> >       }
>
> Do you mean performance critical by access global data ?
> It already access __kfence_pool global data.
> Add one more global data acceptable here ?
>
> Other place may access global data indeed ?

is_kfence_address() is used in the slub fast path, and another load is
one more instruction in the fast path. We have avoided this thus far
for this reason.

> I don't know if all linux release like ubuntu enable kfence or not.
> I only know it turn on default on android device.

This is irrelevant.

> > While I think the change itself would be useful to have eventually, a
> > better design might be needed. It's unclear to me what the perf impact
>
> Could you share the better design idea ?

Hot-patchable constants, similar to static branches/jump labels. This
had been discussed in the past (can't find the link now), but it's not
trivial to implement unfortunately.

> > is these days (a lot has changed since that comment was written). Could
> > you run some benchmarks to analyze if the fast path is affected by the
> > additional load (please do this for whichever arch you care about, but
> > also arm64 and x86)?
> >
> > If performance is affected, all this could be guarded behind another
> > Kconfig option, but it's not great either.
>
> what kind of option ?
> It already have kconfig option to define the number of objects, here just provide
> a parameter for the same option which user can change.

An option that would enable/disable the command-line changeable number
of objects, i.e one version that avoids the load in the fast path and
one version that enables all the bits that you added here. But I'd
rather avoid this if possible.

As such, please do benchmark and analyze the generated code in the
allocator fast path (you should see a load to the new global you
added). llvm-mca [1] might help you with analysis.

[1] https://llvm.org/docs/CommandGuide/llvm-mca.html

