Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84D6ECD98CE
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 05:15:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A12B6B0005; Mon, 15 Jun 2026 01:15:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 851906B008A; Mon, 15 Jun 2026 01:15:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7199F6B008C; Mon, 15 Jun 2026 01:15:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5C2666B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 01:15:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E9F31408FB
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 05:15:05 +0000 (UTC)
X-FDA: 84880982970.21.D131220
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id ED5A51A0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 05:15:03 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GvE95Juu;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781500504;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3gNBX5x2LhwOmIQQDlsDq2J8ZH2ZLBGWp0xwFaRLaiY=;
	b=2tFFUnCaQLFWZaJ3VcKxSxW1o0/16WT0keNQFJLSzlfLA2seva7JGFeM6cJEbfYnBDIADX
	D//PIjCiduGh+cDmMiy5p7j43xrrDTykLltxE8Ae0Qm/W3Yt8SR+j/TS9ByhcQooZ7P88S
	QjZBgT0DJWImIbsXKmfS1CEAYZuIOIs=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GvE95Juu;
	spf=pass (imf19.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781500504;
	b=fi022c9BLfbr8R4B7THfJ7cc/n0CaRE0oOHcHwQap4Hk3p3v5tU2eYS/uMuar2SFPiV1zC
	e09IQpwpsDFDngoaI5M2TIGRcVa1QtXWPWK0KFFRazRIF30h04xsOsZONjoM63sa5XZsJh
	f5QvuRCEMLCH4puqAE4/uFy3HFLXVj8=
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-5175d339e8bso830991cf.0
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 22:15:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781500503; cv=none;
        d=google.com; s=arc-20240605;
        b=iKD0+Sg8t2SWTCgPGJ+n7yTn/Cn1xASQ1wUBtSntBjpWwI3uaV3rri5iQvc88yNNsQ
         T6E42xE5RkgN8YXTBq3/mh6ydfj7ErUkqtacZNQnFstVfWE2Enomsg8T2Wmpi0QbfBE+
         +5CkgQ3XAaWSyZ55I3AgHd8WEnR1LHaiCf5+ejSfn/ZmEiZGUN9KR/X0KZGvIwd0akxf
         M2InBQtUyf/IKM3y6onvBjchPJPfbzSOTBnc0uKjadGj4NszzD1ZqURmURYEOCWshYt0
         y0WrA/6hAVu9V0sxYuYy/Is3pmQK6Sp9qYbSxwaoCPbgcjthEgssosXM9X2NdGwVL1Sf
         dkPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3gNBX5x2LhwOmIQQDlsDq2J8ZH2ZLBGWp0xwFaRLaiY=;
        fh=6iFKSoPikXvZwsGjGXCpTrc3AZ8ymjVmnqUbp+yTo2M=;
        b=VpJcPTSdnz/jmGtmNr6o+JyMh/NK5mKrzdyXU6FhXKzircFAbzzvXaeeE0k2aZ83vS
         eVJXiqcRxi6kGk7D6bduBIGbkPsXl9Ph//dJsulRwoWw1XDBOtwMcAMQsZGGYZOKw/qU
         l9xuXaQ96uM1hweuY4gBnAkbaQi9ZjxQgOjiGyvX+fzlJLJBDPON8IWSycxTZq2NzjpH
         qyypuc3lK5yvqeeYL/TxqB7iqvIsvnG956F1N2DWHG41uaFxTQzXDPElHWJa34rSOaQ0
         +fpGbMRAUCpSqqV+iXrEEZtyhEp6CC+F/DlS7w7pRvqVs0nWyHjsnc4s2SG4TOLI7wd/
         9diA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781500503; x=1782105303; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3gNBX5x2LhwOmIQQDlsDq2J8ZH2ZLBGWp0xwFaRLaiY=;
        b=GvE95JuuSnqDq7Y+3otZJQ750+SAetq8TOOb8qP7115j5T/tE3kGZL+hsR1zCWa2qP
         XVXegR4h6sT96iMOHu5HoWwxoRozGqHXTMPTTVaIC04jt0g0KvOQ5+p+q8erhGPsK55k
         gu1HY5z7ahofQ5kCvaHJT8i+mSdmOpiIjWxXQVACgfv2jxKSenBkz99bB+W31iEsRC5+
         73kRe+8tqQzlKtvNBZCB2cMjVk9nqstVfcpzMJS0QOzaT2en7VzL+Vj+Gc3WfH8oRWQy
         ReIdvYlkGeeyFKZ8qypIXdn3Vyx5Nt2zTqlcmAwphSYEPjRn9hs0dmL/LmGjHKADTNuI
         m4bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781500503; x=1782105303;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3gNBX5x2LhwOmIQQDlsDq2J8ZH2ZLBGWp0xwFaRLaiY=;
        b=JJszi6k2W/pgEekvOVOKTC2TKoiU0D6PqNaWC7BtoKJ2dIGl05lGsN38Ya8kvG0TrA
         G3CAxPP5Lkl5dTEYuimfL0vlmpKCTk0Ss2wQMQ4BUcrmOOew7Ld9zCzKH0sY53bNicLI
         GlbGxfYHEK6hRrIQ9M0RJv5Y89y5afnnej82Ny/CTXUsMxHTtN3L+J9uuuLRWilxfjoC
         NC8pDLxMoK/xsSlVf10Z4TLK0qohbUtZT2pU8FKedFQXfZ/4TKJeHZ90zwtlGUMZlW4M
         j36t0aU9+mZCPVjJEphbWSIPmkOKzcOOb32p1pTDTmniKZ2oSe3nhB1wOajoqZIDHHbb
         /YUg==
X-Forwarded-Encrypted: i=1; AFNElJ9Q1eJX18M7epFpcbwSfEcfvaspGg2lnzRxl+LdbRFIDMR4EONNvobNy5vdF+tja2QJNt3SH9IAkQ==@kvack.org
X-Gm-Message-State: AOJu0YzyMMzRKlmZbxzFWnegs4QxqA3idxTSASQjiO3anufc17p/PiTE
	oNGQjcEqu+MWBewzej7ldpt4kn76BoJPfgejcFjqC6/f7G4xBx/kN+LFeEjlzDcfX1PHlnFkJmB
	xfkU6JNDqbn4tfdUjgiwpPm1ZzL6EIMrQmvvRR9IK
X-Gm-Gg: Acq92OEre3Zzk9dWdLscH/j0yLSr4Zk4PC87nnxWqKkwyQ+PBKAb5FlJQxuECPSQW9B
	SAdpI0U7j43J1th7BBpJ98M3GQfYmeIlSvdCO+5437Wpjb8i0q47Pdyc6LN3wv3ofgJxLkLrpz3
	JZefthSQfk6OBZ8RS/bPD2E6EB46ABPfyFhrDb8q5yeeUrX4ivSCh6UcU2IdcO3fM4F2cFQh4Cm
	od8pMdxK3w0C4YFblUW7u6bNH5bxAsgrD1RHrma8yBbzu9wJVPFXSt7bKT1/qPw6YPwEHJtcgYK
	40HKvg==
X-Received: by 2002:a05:622a:30e:b0:50f:ce97:3b84 with SMTP id
 d75a77b69052e-519549c5a9dmr13031241cf.6.1781500502356; Sun, 14 Jun 2026
 22:15:02 -0700 (PDT)
MIME-Version: 1.0
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-14-7190909db118@kernel.org> <aiu8W3EQhalCP9HW@fedora>
In-Reply-To: <aiu8W3EQhalCP9HW@fedora>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 14 Jun 2026 22:14:49 -0700
X-Gm-Features: AVVi8Cc8iefsPrhDpy6jKSpZmymgWH6dzb08vFxAcF-2MAS_up0x9W_1CMPzClM
Message-ID: <CAJuCfpF4f5=e+y0di=skS3a8_e1e4Ymtk=hSsc_dTNpmLhywEg@mail.gmail.com>
Subject: Re: [PATCH v2 14/16] mm/slab: introduce kmalloc_flags()
To: Hao Li <hao.li@linux.dev>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: ED5A51A0005
X-Stat-Signature: ze9qqgj7k868ru5zedatshkrh61sdykq
X-Rspam-User: 
X-HE-Tag: 1781500503-390409
X-HE-Meta: U2FsdGVkX1/qDAdHxgTxOshf31/c/OyMBu86jXRfBDBHnt3g/ilrX9NE6aMLIWYwpMswHNHJ31JF++MV4Z2UzyAS7Nb5C/II1eo+36qWVZ6eNGR510a/9EkQEFa2zRW0g6xdwkqcnHmcJAaAePIbrr+NNx3GYssTRTQ9VYLVr2vL8TR3/xZ76M/ut1AkxFHdaTnn9/Dvmjme4yqRntD5BJehwbPBsWbzk5TmeY+hfK7K2jMMLE9SLDYvZfhK+ZEycdAdDWHM5oCkjaVDgSwygo1IkRLSGMkSmlvzyJXwuUMeW2iWjPll7aebf9hUZyCxlxV+S8USUtSdWNm8CWQmhWKx851QWx1qP51pJg0VGlHWwHYRhzkHvVuoDDzFwCwqCKT2nK7IJXi+lz0ZbX4zEQcHbFYes/VrDu2TLAzrUPYmlvZQlDZrLjl7FbUsM1fhfF23LFxlOyKjQExM4zuiigPKglA/ILoAtbdCQhpTpiMh72DtUQEaWY4maFE/pL+tD0zdRuTUazSlsf/jcMBW0j7mgpdjKWZx2YLl0iiXYh7TwU0fiiOqGLhYmez8te4Z793gc04Kr/n4wrdUS3sFyPXDyDydorXxxO7huOMM4bZQG37m5eWi+8+dDoDYlpluiNwMXDLe8GeCbTWjvnsW9OMPcPCTfsuVujvVWXv9vHYdfwofr3QR0MBwM8sWxF+nfdI334enuxPe9bFLooLflIgzGZotl/QBo326OT7uervYzJv6IQ/Bt/Un4V7uOW7udujsIrqDy/zNKlmO0JyicQYTQUfvrUqAOHnV7y26fszjwa5CvFyU990yvkzpQ4m0WzbepzwNxUBMHUeieSxBwr/entKdPZbInsCOaOIHpmRWtJwBez1e8/m42VCLlrPeL0K6TEcpZBD/pDUuli7pMfUa+N+jhB9UwVBpStobB2Mt+mi4Gjq+qZRoCWopRCb8u8FmJTKzUF6eXzm1U4I
 huZElZXE
 UzbC2mG7pEoIbKWddc0gw3N8xzHAkxnNI6eyogclpR5XJ2gXEXzotSsFYdHioqADGQ6OrnxeXEWt2oMZwx3QIqrPX10sb2HbxZCnLsP0g5xKa1aWx34yUZL1KgGqpPB6+YVRtlMrPj1RlR0zLD/FqFO8/YeNvUpgYwGsSXD0/10NoqObVTMHR/V3B5SgPT5iL3+g2ObHyXuVXOkXX3Mcvz+M5tDlc/4dtrmrFvvZ6FnkAvyG9xMBRoH7jTotVAwtgIvwNOh34z1VBhaeGSpt1vxmZx4rLYg83yes/IZ1/T0TwxwrY/ZJ3yMvS9qTZNHsPV8GibCCcyd8vRFw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 1:03=E2=80=AFAM Hao Li <hao.li@linux.dev> wrote:
>
> On Wed, Jun 10, 2026 at 05:40:16PM +0200, Vlastimil Babka (SUSE) wrote:
> > With alloc_flags usage in slab, we can replace __GFP_NO_OBJ_EXT with an
> > alloc flag that prevents kmalloc recursion. For that we need a version
> > of kmalloc() that takes alloc_flags and use it in places that perform
> > these potentially recursive kmalloc allocations (of sheaves or obj_ext
> > arrays).
> >
> > Add this function, named kmalloc_flags(). Right now it's only useful fo=
r
> > these nested allocations, so it doesn't need to optimize build-time
> > constant sizes like kmalloc() or kmalloc_buckets.
> >
> > Since we need it to support both normal and non-spinning
> > kmalloc_nolock() context through the SLAB_ALLOC_TRYLOCK flag, split out
> > most of the special _kmalloc_nolock_noprof() implementation to
> > __kmalloc_nolock_noprof() that takes a slab_alloc_context, and make
> > _kmalloc_nolock_noprof() a simple tail calling wrapper with the proper
> > context.
> >
> > kmalloc_flags() can thus determine whether to call
> > __kmalloc_nolock_noprof() or __do_kmalloc_node(), based on the
> > given alloc_flags.
> >
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> > ---
>
> Reviewed-by: Hao Li <hao.li@linux.dev>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Thanks,
> Hao

