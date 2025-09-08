Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D50E8CAC582
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 20:19:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FE928E0012; Mon,  8 Sep 2025 16:19:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5C58E0001; Mon,  8 Sep 2025 16:19:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EBA08E0012; Mon,  8 Sep 2025 16:19:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CFC88E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 16:19:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CE77E1DAE44
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:19:25 +0000 (UTC)
X-FDA: 83867197890.13.7724D7F
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf03.hostedemail.com (Postfix) with ESMTP id DE6FF2000B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 20:19:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z+USXrc0;
	spf=pass (imf03.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757362764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wK9/DwHmthANAPoxGvgtMIu4IcfAIwwBdfEzyf7aCYc=;
	b=VwFWnU1t5SUc8V8Uvqi3526Ibh8JEaKsCwU3jZdd4dEg9pTSVCVaO5AYOeBUDnEnKei5HI
	E3NtodeCu8tvB5s30aNfSaRugvvNRu5rGB6DgCH8t3P3rmNspX+M7cyBaYOhejqz+zLaW9
	E0ngfcMlyKHqPKSudjxRDf7k1tekATA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757362764; a=rsa-sha256;
	cv=none;
	b=IsumZEIs5U72RfRQuc1FW9na9KxeDHtgxcCunlbP30c0Zy9EbojCfmc3EJ8GkCKb7GBfLD
	9h4WNqvgDMCjQ+tkujvUhLcjTmUXo44OSQafYpaEiSMDQPUIVsMucmHrHXL8wDPL06WFMh
	T29UhlARjzymOR0KkvzUNfuAdaY1ZM4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z+USXrc0;
	spf=pass (imf03.hostedemail.com: domain of andreyknvl@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=andreyknvl@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-45de1f2cdeeso11344315e9.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 13:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757362762; x=1757967562; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wK9/DwHmthANAPoxGvgtMIu4IcfAIwwBdfEzyf7aCYc=;
        b=Z+USXrc0tMhB4hFC04eBf5hvVqf+N4V7pWHu4knae89o0SYx/SbLl11AZMrxDxhRx8
         t5Hb+6DY3WME9Sb4ldfisnv8SQ1llW4lAL2wJMjRNzx69bNoyzS+IjFG4RMMuy7BUH/z
         P6nRgCwb7lSCRoSFZJ5sbW865YK4rYlgSuqyC1+iCbjpFC78/55spPvlsSqLrn5KDzDO
         7DyZAaGCAPBmSeFRnaV6jOR6ipk3RyulevcslkRk6bXgbHuhGUb0B+B2DbrqT90ZDJlu
         DMIWvPgjVkR98DtXguctpOGnLhqIY5n7zrvZ3yGM8NhayQtUVfdzeYXWklwL1BCvHPfo
         NcAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757362762; x=1757967562;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wK9/DwHmthANAPoxGvgtMIu4IcfAIwwBdfEzyf7aCYc=;
        b=pA+DYDPfJova5NmKg10/jys4EXhi4+/hGIu/2bEHiFUsATAnYbphy3YOR3SA5jgd/j
         8INzuuZTpYhL+5Zfv8ara/zoiifWaloj3iOUE5LiSHGC8jysshoMqRFG/985lXACXWdH
         enNVkd10OWjqnMVMq93ZG45QpWDaDHGTVT8H3CBZz6AlQeOL7K/SEeIZYACz4rtTL+95
         8j9Ma8hEGT0YHMXemCqcXBColzA7XoVqEgrR5ZKr14VWcbyqCjzKbVtIzYj33a3WcG+x
         N1S7Y+BPBav7PiHqNnw1Nrbgh3LoMaOShaBlOE3NoTaMro9huRnfMX4LTPoaiCM+7Zea
         nmFw==
X-Forwarded-Encrypted: i=1; AJvYcCVBjHv11EbA5RHkinp7GgnQu3fdB19w+9ZPqzUoCwh89zcKqHmRLMDSIHYOU11SvczTG9g8YroEvg==@kvack.org
X-Gm-Message-State: AOJu0Yw6/hw3zz8G/Cto4P79NXUnnAqyDFmQZxIRdXOxRBsmi5lRfUHm
	D7a9UZdTMruGJF8bj/kAXaIz9OVwSJdulQnbgEkzOuZj/zRJ8fnB82h0ia1pP2Sbwe0EQH9isIT
	HvHHcCGfHYTTzBQCe+1XdCboFqNJHvLQ=
X-Gm-Gg: ASbGncuhEx6Ss0ulNMiEMu7p2M2iU2a+vmxU7gor1n3Bk7mSlP3jKQPz9NeMkeZcdUT
	bczXSJsIT6pAIlDZgws51hhlQU55HvJW2sDpIUWHiXNgz728aMCsP57/KKXA1M9pRWyJtWAcZDV
	Z1AkOBeySkNsJLdCByclrh8mC0Sb3EYyxiipzt6lHNQg/G9H6QdBvyoXIfaS8OrxSTz7vgv+DgL
	ZwlW1NWnbYvHifhB/pf4Gaw3h5X0g==
X-Google-Smtp-Source: AGHT+IGZZE8d/HSpoC7P4Nb+5HTeJindRu57Gsc+Nhd8qWOwEu57WmXSWCXboRHxBoCyR49CB3xV2W8zqJ5HdS1yk+8=
X-Received: by 2002:a05:600c:1c97:b0:45d:e54b:fa0c with SMTP id
 5b1f17b1804b1-45de54bfc44mr65122055e9.17.1757362762024; Mon, 08 Sep 2025
 13:19:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1756151769.git.maciej.wieczor-retman@intel.com>
 <2f8115faaca5f79062542f930320cbfc6981863d.1756151769.git.maciej.wieczor-retman@intel.com>
 <CA+fCnZf1YeWzf38XjkXPjTH3dqSCeZ2_XaK0AGUeG05UuXPAbw@mail.gmail.com> <cfz7zprwfird7gf5fl36zdpmv3lmht2ibcfwkeulqocw3kokpl@u6snlpuqcc5k>
In-Reply-To: <cfz7zprwfird7gf5fl36zdpmv3lmht2ibcfwkeulqocw3kokpl@u6snlpuqcc5k>
From: Andrey Konovalov <andreyknvl@gmail.com>
Date: Mon, 8 Sep 2025 22:19:11 +0200
X-Gm-Features: AS18NWCIvLKT4zY1Ax7hHZz8nFS_pHxT1rFM_aQWd_F5XVIT_8vgGZz-WQhHzM8
Message-ID: <CA+fCnZe52tKCuGUP0LzbAsxqiukOXyLFT4Zc6_c0K1mFCXJ=dQ@mail.gmail.com>
Subject: Re: [PATCH v5 15/19] kasan: x86: Apply multishot to the inline report handler
To: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>
Cc: sohil.mehta@intel.com, baohua@kernel.org, david@redhat.com, 
	kbingham@kernel.org, weixugc@google.com, Liam.Howlett@oracle.com, 
	alexandre.chartre@oracle.com, kas@kernel.org, mark.rutland@arm.com, 
	trintaeoitogc@gmail.com, axelrasmussen@google.com, yuanchu@google.com, 
	joey.gouly@arm.com, samitolvanen@google.com, joel.granados@kernel.org, 
	graf@amazon.com, vincenzo.frascino@arm.com, kees@kernel.org, ardb@kernel.org, 
	thiago.bauermann@linaro.org, glider@google.com, thuth@redhat.com, 
	kuan-ying.lee@canonical.com, pasha.tatashin@soleen.com, 
	nick.desaulniers+lkml@gmail.com, vbabka@suse.cz, kaleshsingh@google.com, 
	justinstitt@google.com, catalin.marinas@arm.com, 
	alexander.shishkin@linux.intel.com, samuel.holland@sifive.com, 
	dave.hansen@linux.intel.com, corbet@lwn.net, xin@zytor.com, 
	dvyukov@google.com, tglx@linutronix.de, scott@os.amperecomputing.com, 
	jason.andryuk@amd.com, morbo@google.com, nathan@kernel.org, 
	lorenzo.stoakes@oracle.com, mingo@redhat.com, brgerst@gmail.com, 
	kristina.martsenko@arm.com, bigeasy@linutronix.de, luto@kernel.org, 
	jgross@suse.com, jpoimboe@kernel.org, urezki@gmail.com, mhocko@suse.com, 
	ada.coupriediaz@arm.com, hpa@zytor.com, leitao@debian.org, 
	peterz@infradead.org, wangkefeng.wang@huawei.com, surenb@google.com, 
	ziy@nvidia.com, smostafa@google.com, ryabinin.a.a@gmail.com, 
	ubizjak@gmail.com, jbohac@suse.cz, broonie@kernel.org, 
	akpm@linux-foundation.org, guoweikang.kernel@gmail.com, rppt@kernel.org, 
	pcc@google.com, jan.kiszka@siemens.com, nicolas.schier@linux.dev, 
	will@kernel.org, jhubbard@nvidia.com, bp@alien8.de, x86@kernel.org, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
	linux-kbuild@vger.kernel.org, kasan-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: mhuiq4qopfjgzsnxfbsztn6f8wy9gd91
X-Rspam-User: 
X-Rspamd-Queue-Id: DE6FF2000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1757362763-667898
X-HE-Meta: U2FsdGVkX1+81HBPImOHf4Kw4pfNaoV3ZnEcsh2jMs7F6Lsi/RaqTrfwn2k8hdy53jVIQDg8Y7KK5B8OJl7GO6Ey5WUBPamUhdEjLnKQJPqAvXdQsV2NtV1cOO3jbLGxOYIzlKcKIkr1MpTT9vXNJkkd7d7z0ElhMPyTjNyafEZUGWqNj9f/Z0J0nrGNVcZBww7xyFd5aaTIiGNwc+0I1jIDvFbqN13MkRd2UlAP9YS1qTqeYMXLEdVbdPu14kD8kQtTwXto0/6kE7VEXXOswTOxiHaQGLkEM/pm/zqrV5lr4lijvJ617KnnsZa7qPg3vPCRWcx/Aaxjspgl83oNTDoYrvgocBKsMVi3Vpr1xiSWajokUzYFTD0Tn0B8prF7GM/6Sb6XFYe+pvVPybhk6aGkYILHUfJ4ho2PN/lvoeXeSBGTM+0Hy9ZBjOsT4cLvvJ6J5kTrZ/8e5Ik4WgqC3aMG0k9fsWA+HDLojQIPYjm4opn+2JoM5DUoT8r75jQUbR7s6gL8p0FFTctfbEcI2on4ctFlAm2c6FKkIzLQ0auIvAAcBrRuixLw7QXrMTCr42TlWebYypfT7ipLnOXLNSJYdGwXJ0IP7cK7xQiC5hNb/CI8iOnuQpQkXglwrdUvG2t9DF69RONu0qHmgFx2F3l0DZyoVjNIhQg5plpdi2C2ux1jyq4gNmm2RtkBEEYpgUFfEFSwxVF9iyJA2Z2tRqSsdscILa3HbVSgNsBhnSLEvgBAn1u1+EykMgKK2lT7rYbUuvc/IqrCCF9KfALdZFD8YLJA+NRswv+pX1ts1A2AK0/a5fEM+4wgHeNFb7c6i5K+v7+wY8Y0nyjkBhWegDmEWTFOeN31SYz+fkD0KQ7tsQr3nf1+dDpAU2oGyUs2je+p+l8L1SikBSQ36pg09bYmbsen1jpZs8XLfoX/BWu6tArVQney+0AjWqGvAVcypX2Rflkp2tL2clfeV0G
 Bv7r1F8V
 GwwLYiyhsxeOaY2r4OY7AzUDzrEbt/FqjV1hSE06YZiHk5VN3KFelFdQecErN3LypVSL1WUuYviStNBiwnW5A7ZcbfXRmpPgBdeIEfFZQ0sCUUFJ8SlYTnYVoffQ1iZQl6e6uFICq4RWKMwgDBESIb2SB8UrMr3OY9KUV0t16ZzPt2EMXIb5QJci5EItDrV/y4eyo8bOWFQSnXGJunUGZONl5sYepQks+YrsOvHxO4Z/5EKMuE/CoZnnslz5jRcONqbFctTwo5iW2r/oZCS9/SF7UueLBJNbX1zcb9nQGrS8xR3J4w2Oj6180DkJS78wBKxzJpeJuVkrlBwrLSHDQqQY4T4V30bm4oDbAhyTFy3iTjiqYhwB9pkyVQ2fGmYMgMK+GH+wLzBM8kAXN2LkIRu6JM1sFgjbyCmKwGEi7OmXY4tppAh9sYKrPNdHjj8zzAI5jzteh2PwMDJI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 3:04=E2=80=AFPM Maciej Wieczor-Retman
<maciej.wieczor-retman@intel.com> wrote:
>
> >> +       if (kasan_multi_shot_enabled())
> >> +               return true;
> >
> >It's odd this this is required on x86 but not on arm64, see my comment
> >on the patch that adds kasan_inline_handler().
> >
>
> I think this is needed if we want to keep the kasan_inline_recover below.
> Because without this patch, kasan_report() will report a mismatch, an the=
n die()
> will be called. So the multishot gets ignored.

But die() should be called only when recovery is disabled. And
recovery should always be enabled.

But maybe this is the problem with when kasan_inline_handler(), see my
comment on the the patch #13.

