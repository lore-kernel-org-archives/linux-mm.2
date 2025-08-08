Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CBC4C87FD3
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 14:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FF018E0002; Fri,  8 Aug 2025 10:01:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AFA68E0001; Fri,  8 Aug 2025 10:01:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29EE78E0002; Fri,  8 Aug 2025 10:01:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 154FF8E0001
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 10:01:54 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 090341602BF
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:01:53 +0000 (UTC)
X-FDA: 83753753706.27.8E3DA96
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 25DDA4001A
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 14:01:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=iCmYGGKC;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754661711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cgf3Gf6pf2QyMmdIpvCgXWMeWxUvQmvcME2UoQnjQWw=;
	b=J9QttrSVl9Dl+O/rk+5PeCWn4myTayDohrIZeKIFqgULX79gYNI23/nZc9TDcMA2Vr07o1
	B4BfHGsA3fp4F/MMS9Sd0aFDgGUWjkLiVnpSCgpsfVpGEyczmexPHbj3b5Lsw/xh6Ds0/7
	ZSeo9hxmeEa/4zwACQ00lyQTET5WRgQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754661711; a=rsa-sha256;
	cv=none;
	b=Qj/PCFVllQfA43l4qQnx77Amr4/u5J0jQQsHiIFGO/5VWEOiacZj/aURKD92WhoruMZp1h
	RhmZQ/As6+G4tCEGj5/nssYAn3KiBNfPO2iQanPWX7IFVzm7kyWoRM5GmVkd4nTMm8WEoH
	HHgqDnCWUy/Atk4qJ4CJvyDe2ZZBTGI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=iCmYGGKC;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b07275e0a4so25427221cf.3
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 07:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754661710; x=1755266510; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cgf3Gf6pf2QyMmdIpvCgXWMeWxUvQmvcME2UoQnjQWw=;
        b=iCmYGGKC0NLb4Hc+CVxPVHTsg9WPiCp493KjSdcR9UTjCJrUxPAd7gEQiVQjCAaOnG
         rSSOJuUaXQjYuY13voytT4JDQ/Jv1F0TmfFHFKva5v/W64tCNSqaW9FLc340/caOrzDp
         RyMkRp8+BwEL18SaxEWJLHh2+8i0/Lv96XKA4BK/QzemKjU8TOZD3LQVFN6WILJlVOmK
         49S/CT5ZwDNxzt6P/mEZxbmae9hrJQn10ntKDfVXfCXzr+GYZ6xCCF2FkmWIjkmv0xRk
         oQw9orOdPpHGAF6PqfM5neony8/bAE7eEuyXVSAIbiHlssvHJsjPugacJqHT64EJ71pr
         m9Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754661710; x=1755266510;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Cgf3Gf6pf2QyMmdIpvCgXWMeWxUvQmvcME2UoQnjQWw=;
        b=WJXWvCTareUX+87eW3KqmZZA4CPK7xJNDCCYYEHTwm8NTOEAxRv3B+ocO7yyJky2DN
         J1Swxb9qp0gh0jixFX74ABU+T0Ne9Krs1nf56o0o+EWrvEwQLimydCeaRDZ/A5PPPpDR
         EQaXByLog18iEv+c59UI/Wjzxu0M6/OeDPovFWHe1ci8Ru9KIVaJJXX+yLFfQwmwBIG8
         +IrNunV5/xIrZX8ps9Q8yxlSgEsWQIr7vJnisTh7YOjwG6zYJTYns1vrPHS0pWXE/qI2
         VHuUS9PhpivZ6cxx/xwOlSnG31lCZLG4RJZWC08SkgYxOKC4WOgpuiL0nR+en52HmL6V
         +zPg==
X-Forwarded-Encrypted: i=1; AJvYcCWq5tZAPgzoMsbsv/bkyidCjqT7VsxSJsEk+cpbC1bPltkVUaJcuI1LYGCn8cqXGn/LaX+E/r+sxg==@kvack.org
X-Gm-Message-State: AOJu0Yw55hrwWEN7Jm3xwGx6gJJpsFNONthAz36SnI+YaKgV5evHWGao
	xnx9TPfvfms/zrOcquUIA+SQGKPOlyTyxwFCI0+AiLJYK1e3uxF6MlJC6bMn6COBiwjLSbf+hYj
	DoZpOkpzjC5vw/7MNgKm1TR+9M7loBFnfg+cQ5fX4og==
X-Gm-Gg: ASbGnctiNHNVwJmOAMmR5RHbIqfADMnrC/vwCKS5MyMQyLKLcuAYae+FBtLJf8iLrbU
	2z3gldjeoqVV1+LVsXvWal+V83Y3h2J3mu2m+FU56Zsg4lA+Z5VsqgPa4c21WUiBQ7SdCg9uo4d
	L1F8IBJblTUBfbJBFlxrcyjBiadTgObtUfaMvxoiGnMcc+GrUFsGAL9vwg50E6fn6+tfwG+ERL8
	Onm
X-Google-Smtp-Source: AGHT+IEH1BqMSX1yIRX4eK9XjBPS6pkTO1kxH3JapIOH8TKb2ESrqoA/iZRqQ2exr79E4dgeMXF8CiLL82TWwqJhOYQ=
X-Received: by 2002:a05:622a:258e:b0:4ae:cc75:4703 with SMTP id
 d75a77b69052e-4b0aee5afb9mr42782921cf.58.1754661709835; Fri, 08 Aug 2025
 07:01:49 -0700 (PDT)
MIME-Version: 1.0
References: <20250807014442.3829950-1-pasha.tatashin@soleen.com>
 <20250807014442.3829950-3-pasha.tatashin@soleen.com> <mafs0jz3eavci.fsf@kernel.org>
In-Reply-To: <mafs0jz3eavci.fsf@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 8 Aug 2025 14:01:13 +0000
X-Gm-Features: Ac12FXzfZzUeYL8qqgO-oYE8dxdNMTs6gp9itdpmGem1pHDL8sFl_NAXG2JwrAk
Message-ID: <CA+CK2bCqos=z0q+YsmFK_kFQ8PLyLQw32TkJB5SK2y4Y1kVErg@mail.gmail.com>
Subject: Re: [PATCH v3 02/30] kho: mm: Don't allow deferred struct page with KHO
To: Pratyush Yadav <pratyush@kernel.org>
Cc: jasonmiu@google.com, graf@amazon.com, changyuanl@google.com, 
	rppt@kernel.org, dmatlack@google.com, rientjes@google.com, corbet@lwn.net, 
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com, kanie@linux.alibaba.com, 
	ojeda@kernel.org, aliceryhl@google.com, masahiroy@kernel.org, 
	akpm@linux-foundation.org, tj@kernel.org, yoann.congal@smile.fr, 
	mmaurer@google.com, roman.gushchin@linux.dev, chenridong@huawei.com, 
	axboe@kernel.dk, mark.rutland@arm.com, jannh@google.com, 
	vincent.guittot@linaro.org, hannes@cmpxchg.org, dan.j.williams@intel.com, 
	david@redhat.com, joel.granados@kernel.org, rostedt@goodmis.org, 
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn, 
	linux@weissschuh.net, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de, 
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org, 
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org, 
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com, 
	myungjoo.ham@samsung.com, yesanishhere@gmail.com, Jonathan.Cameron@huawei.com, 
	quic_zijuhu@quicinc.com, aleksander.lobakin@intel.com, ira.weiny@intel.com, 
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de, 
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com, 
	stuart.w.hayes@gmail.com, lennart@poettering.net, brauner@kernel.org, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, saeedm@nvidia.com, 
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com, leonro@nvidia.com, 
	witu@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 25DDA4001A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: i5sd1jtn56p5f661he5kst49jxyydwga
X-HE-Tag: 1754661710-882426
X-HE-Meta: U2FsdGVkX18AId+4Dsrq/etku/Fc0ikkT0Oq634iXzJIuf+XcH4hi59tMUVsRzQQfasjZugFgI6QSPx0f7yLmu+oStB+MzUOf95nTwK+JU0CinNaF56G7KBt13r92AzaJ6Vp9Zv1XCzD6oPf2bb3SNUPjYptz2EW87tu8kOndcYBEvKqduMdT2dfHZjriH7vqIlnykkc2XSqZ8u0xJdWmVgY45iJK1EJfMniapWvVlQfhrAdxXGaRYaICe+xr3NI53l4JCQydGFCequPj6Ie1o1djPLiLUJlUpq+4KPMSrdMNFNf7E1AMXU4PyReEhqpAYhhhI0UaQOZPutWnJEmafrRuFq2JJur894aQnNMvv5kaH55abycWWCKKnUxwoMu4PIGrWs+ynr1khdyyigADgrc4Pcv1YhJWCbR5s46AlABIE+9NOUllmMfsuPCPwiFPBzHM1+kAstvmy3eUyZKKko19CZPKsbZfNL/wGzHYXBi20wb6QspvX8ibpoAV6ZKsxm4MkWZPEGkABvEbfFwF2H07CzjMLDe/lINNqJLRzfR0bZ01JVZC8uj5Rl3t5uezMAs6U575W9znfHDSEyN/GmFj3n0M2oBoRfjyBitRTvfZ4rTKJRYyJM0wpoKSBk2V0n7KJDM766OTgohZ7/bQ0YlxUgofQayPAp/sMwzm2Z5tB3wmmP0sHkuz1IQeEFzBg9t6h8Qau7FIDpHl0NMGjjjtem8oduIDSxmCLt5WrDstwMlQPiV3UqCcgruw7zZIygWwTP9giumTKzm7rw8mS5smocldZL2I05smZCqFNUK8NJcqFWmXsx7IygAmL5d6PR2GTa9ZpcSV8s/9NLcYIeHNHesXFbLOhaaHflXy69VfluYXTUSSoJJzS884o3kjTsXYpD4rLf2cZ+eKfYwmQBSwPOalfyuk8qnLTdH9A1n8gzDmTYEIW4W9Gs1MpEhk5tExFwz7CigswNZbip
 zBYP7aRx
 cRyO4YwKhzRs65LPBb9OskojxFU2w1WFo57co3KFvwFPRIOJJrbXRSfhXKUWxj43wiy6c63n0gwgjZiLP4q2wTQw5LRcxr5r7iIosFcSGbnqYu9wGrpwH07acMKo55t+rbynyNx6NMCaq65U7Iq6T1chQPo8OYNgxG80i4IgFF6PDcSVa5KUiCkUTI9zKmVXMQWt8n4ioWGK45TpuifbUDA9yeZLj193Vc/wt3naRpdbMD0SM8TgziEbTH4bqNIDZQWR2tDMpOlf0kgH5fgxyFnkrlzf9lvAqypvVswrtfOUEKVCA08lWP+aww2uYTKdEGdLxWDCbPAz2BBUQv+dZS5BYjQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 8, 2025 at 11:47=E2=80=AFAM Pratyush Yadav <pratyush@kernel.org=
> wrote:
>
> On Thu, Aug 07 2025, Pasha Tatashin wrote:
>
> > KHO uses struct pages for the preserved memory early in boot, however,
> > with deferred struct page initialization, only a small portion of
> > memory has properly initialized struct pages.
> >
> > This problem was detected where vmemmap is poisoned, and illegal flag
> > combinations are detected.
> >
> > Don't allow them to be enabled together, and later we will have to
> > teach KHO to work properly with deferred struct page init kernel
> > feature.
> >
> > Fixes: 990a950fe8fd ("kexec: add config option for KHO")
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>
> Nit: Drop the blank line before fixes. git interpret-trailers doesn't

Makes sense.

> seem to recognize the fixes otherwise, so this may break some tooling.
> Try it yourself:
>
>     $ git interpret-trailers --parse commit_message.txt
>
> Other than this,
>
> Acked-by: Pratyush Yadav <pratyush@kernel.org>

Thank you for the review.

Pasha

>
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > ---
> >  kernel/Kconfig.kexec | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
> > index 2ee603a98813..1224dd937df0 100644
> > --- a/kernel/Kconfig.kexec
> > +++ b/kernel/Kconfig.kexec
> > @@ -97,6 +97,7 @@ config KEXEC_JUMP
> >  config KEXEC_HANDOVER
> >       bool "kexec handover"
> >       depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FI=
LE
> > +     depends on !DEFERRED_STRUCT_PAGE_INIT
> >       select MEMBLOCK_KHO_SCRATCH
> >       select KEXEC_FILE
> >       select DEBUG_FS
>
> --
> Regards,
> Pratyush Yadav

