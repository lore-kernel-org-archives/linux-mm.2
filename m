Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13C38CAC5A0
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 10:21:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E5638E0002; Sat, 20 Sep 2025 06:21:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 196968E0001; Sat, 20 Sep 2025 06:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05DAA8E0002; Sat, 20 Sep 2025 06:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E13A58E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 06:21:29 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7F3F05BDCA
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 10:21:29 +0000 (UTC)
X-FDA: 83909236698.03.8250337
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf24.hostedemail.com (Postfix) with ESMTP id 815D118000F
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 10:21:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XfoeRtYE;
	spf=pass (imf24.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758363687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P0vYXtUQVOuP2mhoWd4ropfz+61/nK8dVG+VKmZf9qg=;
	b=sPJuX41IiHQXmjcUcRggtdz2TRwXQr63jyftufjONRenqEjE80ZBifYLqRBwkLtlHi3G0D
	Vr3jrA6SZre+Adg3thRE8Pw6kiQsdOcx9NYqOcjwVW3KQzsKOKo1tfzBi1fo3mJot+rZfV
	JpxdoIJaAZ5Z2AJ9m6wuKgr4GeuMOZ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758363687; a=rsa-sha256;
	cv=none;
	b=dO24TMHs1YLHacbiA74zJ39QyknEg+1OSKrHVbo+xbA0PyMjKDk5+RfoGrdM/A/nuO9+2l
	gv5IeU03Zwb7GTYsVZ/VSw5CtW1uOg9jAnWn1gLlY3aSgrQFj9AwR8qLqp3T4LgOdISt9/
	9zUqQADT7JrXuV/OzwYA+syWS5oQwOI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XfoeRtYE;
	spf=pass (imf24.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45dfb8e986aso25173145e9.0
        for <linux-mm@kvack.org>; Sat, 20 Sep 2025 03:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758363686; x=1758968486; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P0vYXtUQVOuP2mhoWd4ropfz+61/nK8dVG+VKmZf9qg=;
        b=XfoeRtYE2q6NOMJ/Jd5u4L6a1uL8GLWZu1TqXUHjMzQ8a/yfIPGXjPGDkOXrB5OHhN
         S3Kx+gq1z9a7qGHDRLIaAN2ppyqtbc9sZ6T4JbIWHL/bkoQVsnh2hDlK36pb8yMxBan5
         hl85cbvWAr7EIVSeJXGiOY+6YF7T7vvoFk05+NaMRs4iUd7bA1h1pAPkb1iHC/X80tR9
         jMk9Yl9dyJF6r3X6cauqXQflDeIg3IuUmaIh64jhHBDYIqCt3ecEVvfIBCyk7hbPkY93
         vfF+BCWfuho45Rzse3wNwGCbqINbmr90/BXY4e1B3234CeZDITjmJK8x273mdVUocQfY
         UDeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758363686; x=1758968486;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P0vYXtUQVOuP2mhoWd4ropfz+61/nK8dVG+VKmZf9qg=;
        b=oZH7jsmhJq6WEj/2AuJtcgJzN8U74aLRFUExH+KZg5dEQDjgZr54hG4qaTITlRlK8l
         +mec6OROZnZPpXfOWNdAaVx4jZoh6wfmU/EL030jmXkBesbMdP8gNgEqqMZjt4Q/ha2q
         QzU4iiBAuVhpa1OtU8SK2/bqT2JoH0nZsEUFikBsQ2Jqpr/jd8PiGu2WVRYXvddV9/Hg
         pX1dIvSwJqj4mGRWfdpBzG7Y+/1C5n+vkq9bGDqIE8nIKvxvfv/w3OirWtNxDrKAjmlS
         N+jnh32VwvXg12TY3S3c42NRKwPJLdoWMZQiCB0C1TusBLG97wypWFQwjhIuwfngGe+k
         u/AA==
X-Forwarded-Encrypted: i=1; AJvYcCXzjDz4NJ5j/TKomyM1inr623HkblmG4lpF+tvCbN/8KranmIQx4Q3x0cTOW8XpiyOfYLAVHE020w==@kvack.org
X-Gm-Message-State: AOJu0Yxk1p+pHX67RPWIdYAOzrKBrMBy+UF+mxYkVvZQQGmpZMD92VRf
	0TlkPxfN9bnmFuslOzUF92efe4wL+woIqcFp47nIZ9dEpMDcnGj4dXfT
X-Gm-Gg: ASbGncsm/zgrVGUnn8Bf2vh6RFSGXsXZPwJzJ0DCFkM8ioOKNVX1mRkcBb5aA3eK9x3
	GIZznrmrjpraAu/ziZ8tbcZF7ZGKogUaHiqB5d0Y1Zq4/XhyfOtVivZl/n0rXLWV/jO2kqGrrHx
	gT2mH4U1rkpizeyJtpeAHkCGuJE5/hWvYrUZx2ZBI+4aJRRQq0GL5AJntxAbd1VaXgJqux9zZgF
	w67ZnGFtX6I+Gs4ADH+Xy/3dzYmEnp+9gCmDqluQgKEDxihqwP0fWsSZ7BCBG+3TPNHFibWuReO
	gKg36fgwfPBiXRjoFdg0ywnBGDh3nmop0qxwjxENs+czgLyOlryPEOHeHwNE1H5Dxr1zlzH5cZO
	mHgXQEkzxkVCsY5VZ8ALDk4M6oSdiaZn38WrdJ0Fkn6zjVdI4JGEVPTOBp/tF
X-Google-Smtp-Source: AGHT+IFiz+7GSgFF/mIUUp0ndfipkNQ39jr+2XK+PXUAveDTslyL1Wu67txaLfdop4/qCEdAg/m1vQ==
X-Received: by 2002:a05:600c:c8f:b0:45f:2919:5e6c with SMTP id 5b1f17b1804b1-467e6f37d8dmr76782405e9.16.1758363685327;
        Sat, 20 Sep 2025 03:21:25 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3f0e28c83d6sm5624389f8f.56.2025.09.20.03.21.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Sep 2025 03:21:25 -0700 (PDT)
Date: Sat, 20 Sep 2025 11:21:22 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Christian =?UTF-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: linux@armlinux.org.uk, jdike@addtoit.com,
 anton.ivanov@cambridgegreys.com, dave.hansen@linux.intel.com,
 peterz@infradead.org, tglx@linutronix.de, x86@kernel.org, hpa@zytor.com,
 tony.luck@intel.com, qiuxu.zhuo@intel.com, mchehab@kernel.org,
 james.morse@arm.com, rric@kernel.org, harry.wentland@amd.com,
 sunpeng.li@amd.com, alexander.deucher@amd.com, airlied@linux.ie,
 daniel@ffwll.ch, evan.quan@amd.com, james.qian.wang@arm.com,
 liviu.dudau@arm.com, mihail.atanassov@arm.com, brian.starkey@arm.com,
 maarten.lankhorst@linux.intel.com, mripard@kernel.org, tzimmermann@suse.de,
 robdclark@gmail.com, sean@poorly.run, dmitry.torokhov@gmail.com,
 agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, rajur@chelsio.com,
 davem@davemloft.net, kuba@kernel.org, peppe.cavallaro@st.com,
 alexandre.torgue@st.com, joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
 malattia@linux.it, hdegoede@redhat.com, mgross@linux.intel.com,
 intel-linux-scu@intel.com, artur.paszkiewicz@intel.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, sakari.ailus@linux.intel.com,
 gregkh@linuxfoundation.org, dushistov@mail.ru, luc.vanoostenryck@gmail.com,
 rostedt@goodmis.org, pmladek@suse.com, sergey.senozhatsky@gmail.com,
 andriy.shevchenko@linux.intel.com, linux@rasmusvillemoes.dk,
 akpm@linux-foundation.org, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
 pablo@netfilter.org, kadlec@netfilter.org, jmaloy@redhat.com,
 ying.xue@windriver.com, willy@infradead.org, sashal@kernel.org,
 ruanjinjie@huawei.com, David.Laight@ACULAB.COM, herve.codina@bootlin.com,
 Jason@zx2c4.com, bvanassche@acm.org, keescook@chromium.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-um@lists.infradead.org, linux-edac@vger.kernel.org,
 amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
 linux-hwmon@vger.kernel.org, linux-input@vger.kernel.org,
 linux-media@vger.kernel.org, netdev@vger.kernel.org,
 linux-stm32@st-md-mailman.stormreply.com,
 platform-driver-x86@vger.kernel.org, linux-scsi@vger.kernel.org,
 linux-staging@lists.linux.dev, linux-btrfs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-sparse@vger.kernel.org,
 linux-mm@kvack.org, netfilter-devel@vger.kernel.org,
 coreteam@netfilter.org, tipc-discussion@lists.sourceforge.net,
 stable@vger.kernel.org, jonnyc@amazon.com
Subject: Re: [PATCH 00/27 5.10.y] Backport minmax.h updates from v6.17-rc6
Message-ID: <20250920111904.6d9ecb17@pumpkin>
In-Reply-To: <184ce83f-0063-43a0-a1c8-da23c5d03cf7@amd.com>
References: <20250919101727.16152-1-farbere@amazon.com>
	<184ce83f-0063-43a0-a1c8-da23c5d03cf7@amd.com>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: xkq5ix1wipu9f7snf6i6r9nhsoqbproq
X-Rspam-User: 
X-Rspamd-Queue-Id: 815D118000F
X-Rspamd-Server: rspam10
X-HE-Tag: 1758363687-226015
X-HE-Meta: U2FsdGVkX19/H3w8vqUP23bxswBINSBf9/UscgHTi95Z8YRtxIUlkDxLZf4Rwv6V+Ty3mMx4QnfMZM+NMiVvTUCLkVq+eTN+C4POpakxwsJYz13Abr9lqXQHTXVWwCQxWGYIc6oLQ/YMPvK6loZnnu4epDN1Au3RS3Tk5PeFIv2bmUEC3M4rEJ10DpNg09nj+4zFyykiNcH0uSPPzrZ2qJZATg8lwK5h6aT+jIPZSu1/XvZe70gPWOc10UfIL4KAdATZTVwoHwuH8q7EkhttFWgqXwPzUUNpynQWasbCP1F9HjhuEmD3ZOY0Yo6sC/dbpSax/yS6pYUwqctzaj/6Z8yog7W+IvqmKoWGQwSkPpsF9OSK/Ehh3pUT8rtr8AMH1k0UOQNspLouOYeRjorGWv3Qnn6cn0Saf6G5HP5qzc8cf3nuiKsO6zJKMUtVF9QZXGFnpouvvfB7xGGVlH3oESgBSq5BDEan0a///XzW364nvuQGa+0LFiCHnzFlI7gq6uC9+DLlSoZS9Y73qnSyShUcLOed2H5D6hRnF/Hnh3GON9Bag/bKGSR1B4xdRTKt3XFvDQedsUTzhkBU6tXnKG449q6P+/tZ5VhCWv5k9ZbP2C7pKgpl/C7YcX+z+1UahCyTgqXc5E8hhUXD0X08bRQDFsh9Wn170lmP5CHGFxLBLSNdPY5TTf6A67L5y0X8lPMHkJ77/XKHnAqQwrKS28Tav/F4eE9h81bW1zgPtksVyVAnJmTp3rv0q+kPgW0R2kR1FgzfsGwc6PcjPKo9dw+T8X9UEdSGGnciVVtLSlRpO1HS6t9sHLaFIa7GGV6y0U1mpQjKPqDIAL853xk3Y1eBAX7IHpNWXyIwzhSjuTS23Byx1WPXX/wWvkzmDqwRqay6rdHOGdxrTHBVAPnB8z8uAGQdKaRotJiBFPiulOsUS34jf/xp7voudO8saP+TJvdo5HIZUvifHwUMkC1
 5ZoG3iOZ
 tleHE3aKsyKHej5hxZjJSIsEE4F+btcSoUSn52jcTl+5wtH7lyEENMIQnDT7YKIWAARyis9Snm7MTH+ibspxJc07ePoF6YKYggukENu88ocQqwon/GVpe7+qqCt5J4/pwHg/SQyx8L8B1NmuCajlRqE2txCpDKwxtNBFDSEXcUL290+Je43KCWOtlYcLXMw3e/Mb6tJG9yT9lr4gaKEPJKN1e7hiGJkr9/BgGvBH2ScscxgFlrLUw8cCK5g2ThG85rAUyhsiWfGbZZ7tiEK/V/I/vqiZuorbvolvQ+lTISHNsDGb169eVAbdNwG1gIJFGfsxqVYZ0yAN12rX7o4Ry1uqOcdndG1uoByBf6pAvye23XKZfNNJVpKFchhNXBUiuIuMnaawv72xJTIeJxQQU87kKZ3r7qT2QNcO/MV/VfY9jUoghAYIvBb1zrvo+lW0x5yvR4YLhkp3Hd0m79UvEynFIjFFmybcYTMAlV6NCCYM0RDc35WVOnJR5xfEDLeKi9BZBjR4SfFnBgr7+0LYv6mFMBQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 19 Sep 2025 14:11:37 +0200
Christian K=C3=B6nig <christian.koenig@amd.com> wrote:

> On 19.09.25 12:17, Eliav Farber wrote:
> > This series includes a total of 27 patches, to align minmax.h of
> > v5.15.y with v6.17-rc6.
> >=20
> > The set consists of 24 commits that directly update minmax.h:
> > 1) 92d23c6e9415 ("overflow, tracing: Define the is_signed_type() macro
> >    once")
> > 2) 5efcecd9a3b1 ("minmax: sanity check constant bounds when clamping")
> > 3) 2122e2a4efc2 ("minmax: clamp more efficiently by avoiding extra
> >    comparison")
> > 4) f9bff0e31881 ("minmax: add in_range() macro")
> > 5) c952c748c7a9 ("minmax: Introduce {min,max}_array()")
> > 6) 5e57418a2031 ("minmax: deduplicate __unconst_integer_typeof()")
> > 7) f6e9d38f8eb0 ("minmax: fix header inclusions")
> > 8) d03eba99f5bf ("minmax: allow min()/max()/clamp() if the arguments
> >    have the same signedness.")
> > 9) f4b84b2ff851 ("minmax: fix indentation of __cmp_once() and
> >    __clamp_once()")
> > 10) 4ead534fba42 ("minmax: allow comparisons of 'int' against 'unsigned
> >     char/short'")
> > 11) 867046cc7027 ("minmax: relax check to allow comparison between
> >     unsigned arguments and signed constants")
> > 12) 3a7e02c040b1 ("minmax: avoid overly complicated constant
> >     expressions in VM code")
> > 14) 017fa3e89187 ("minmax: simplify and clarify min_t()/max_t()
> >     implementation")
> > 15) 1a251f52cfdc ("minmax: make generic MIN() and MAX() macros
> >     available everywhere")
> > 18) dc1c8034e31b ("minmax: simplify min()/max()/clamp()
> >     implementation")
> > 19) 22f546873149 ("minmax: improve macro expansion and type
> >     checking")
> > 20) 21b136cc63d2 ("minmax: fix up min3() and max3() too")
> > 21) 71ee9b16251e ("minmax.h: add whitespace around operators and after
> >     commas")
> > 22) 10666e992048 ("minmax.h: update some comments")
> > 23) b280bb27a9f7 ("minmax.h: reduce the #define expansion of min(),
> >     max() and clamp()")
> > 24) a5743f32baec ("minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi
> >     test in clamp()")
> > 25) c3939872ee4a ("minmax.h: move all the clamp() definitions after the
> >     min/max() ones")
> > 26) 495bba17cdf9 ("minmax.h: simplify the variants of clamp()")
> > 27) 2b97aaf74ed5 ("minmax.h: remove some #defines that are only
> >     expanded once")
> >=20
> > 2 prerequisite commits that adjust users of MIN and MAX macros (to
> > prevent compilation issues):
> > 13) 4477b39c32fd ("minmax: add a few more MIN_T/MAX_T users")
> > 17) cb04e8b1d2f2 ("minmax: don't use max() in situations that want a C
> >     constant expression")
> >=20
> > 1 additional commit introduced to resolve a build failures during the
> > backport:
> > 16) lib: zstd: drop local MIN/MAX macros in favor of generic ones
> >=20
> > The primary motivation is to bring in commit (8).
> > In mainline, this change allows min()/max()/clamp() to accept mixed
> > argument types when both share the same signedness.
> > Backported patches to v5.10.y that use such forms trigger compiler
> > warnings, which in turn cause build failures when -Werror is enabled.
> >=20
> > Originaly I aligned 5.10.y to 5.15.y, but David Laight commented that I
> > need to pick up the later changes (from Linus) as well.
> >=20
> > Andy Shevchenko (2):
> >   minmax: deduplicate __unconst_integer_typeof()
> >   minmax: fix header inclusions
> >=20
> > Bart Van Assche (1):
> >   overflow, tracing: Define the is_signed_type() macro once
> >=20
> > David Laight (11):
> >   minmax: allow min()/max()/clamp() if the arguments have the same
> >     signedness.
> >   minmax: fix indentation of __cmp_once() and __clamp_once()
> >   minmax: allow comparisons of 'int' against 'unsigned char/short'
> >   minmax: relax check to allow comparison between unsigned arguments and
> >     signed constants
> >   minmax.h: add whitespace around operators and after commas
> >   minmax.h: update some comments
> >   minmax.h: reduce the #define expansion of min(), max() and clamp()
> >   minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()
> >   minmax.h: move all the clamp() definitions after the min/max() ones
> >   minmax.h: simplify the variants of clamp()
> >   minmax.h: remove some #defines that are only expanded once
> >=20
> > Eliav Farber (1):
> >   lib: zstd: drop local MIN/MAX macros in favor of generic ones
> >=20
> > Herve Codina (1):
> >   minmax: Introduce {min,max}_array()
> >=20
> > Jason A. Donenfeld (2):
> >   minmax: sanity check constant bounds when clamping
> >   minmax: clamp more efficiently by avoiding extra comparison
> >=20
> > Linus Torvalds (8):
> >   minmax: avoid overly complicated constant expressions in VM code
> >   minmax: add a few more MIN_T/MAX_T users
> >   minmax: simplify and clarify min_t()/max_t() implementation
> >   minmax: make generic MIN() and MAX() macros available everywhere
> >   minmax: don't use max() in situations that want a C constant
> >     expression
> >   minmax: simplify min()/max()/clamp() implementation
> >   minmax: improve macro expansion and type checking
> >   minmax: fix up min3() and max3() too
> >=20
> > Matthew Wilcox (Oracle) (1):
> >   minmax: add in_range() macro
> >=20
> >  arch/arm/mm/pageattr.c                        |   6 +-
> >  arch/um/drivers/mconsole_user.c               |   2 +
> >  arch/x86/mm/pgtable.c                         |   2 +- =20
>=20
> >  drivers/edac/sb_edac.c                        |   4 +-
> >  drivers/edac/skx_common.h                     |   1 -
> >  .../drm/amd/display/modules/hdcp/hdcp_ddc.c   |   2 +
> >  .../drm/amd/pm/powerplay/hwmgr/ppevvmath.h    |  14 +-
> >  .../drm/arm/display/include/malidp_utils.h    |   2 +-
> >  .../display/komeda/komeda_pipeline_state.c    |  24 +-
> >  drivers/gpu/drm/drm_color_mgmt.c              |   2 +-
> >  drivers/gpu/drm/msm/adreno/a6xx_gmu.c         |   6 -
> >  drivers/gpu/drm/radeon/evergreen_cs.c         |   2 +
> >  drivers/hwmon/adt7475.c                       |  24 +-
> >  drivers/input/touchscreen/cyttsp4_core.c      |   2 +-
> >  drivers/md/dm-integrity.c                     |   2 +-
> >  drivers/media/dvb-frontends/stv0367_priv.h    |   3 +
> >  .../net/ethernet/chelsio/cxgb3/cxgb3_main.c   |  18 +-
> >  .../net/ethernet/stmicro/stmmac/stmmac_main.c |   2 +-
> >  drivers/net/fjes/fjes_main.c                  |   4 +-
> >  drivers/nfc/pn544/i2c.c                       |   2 -
> >  drivers/platform/x86/sony-laptop.c            |   1 -
> >  drivers/scsi/isci/init.c                      |   6 +- =20
>=20
> I do see the value to backport the infrastructure, but why are driver spe=
cific changes backported as well?

They will be about removing local definitions of MIN() and MAX() freeing
them up for simple implementations (usable as constant initialisers) and th=
en
using them in places where the compound statements in min() and max() can't
be used.

Linus did all those changes - so he didn't have to wait for the maintainers
to apply the changes (etc).

	David
=20
>=20
> I mean the changes are most likely correct but also not valuable in anywa=
y as bug fix.
>=20
> Regards,
> Christian.
>=20
> >  .../pci/hive_isp_css_include/math_support.h   |   5 -
> >  fs/btrfs/misc.h                               |   2 -
> >  fs/btrfs/tree-checker.c                       |   2 +-
> >  fs/ext2/balloc.c                              |   2 -
> >  fs/ext4/ext4.h                                |   2 -
> >  fs/ufs/util.h                                 |   6 -
> >  include/linux/compiler.h                      |  15 +
> >  include/linux/minmax.h                        | 267 ++++++++++++++----
> >  include/linux/overflow.h                      |   1 -
> >  include/linux/trace_events.h                  |   2 -
> >  kernel/trace/preemptirq_delay_test.c          |   2 -
> >  lib/btree.c                                   |   1 -
> >  lib/decompress_unlzma.c                       |   2 +
> >  lib/logic_pio.c                               |   3 -
> >  lib/vsprintf.c                                |   2 +-
> >  lib/zstd/zstd_internal.h                      |   2 -
> >  mm/zsmalloc.c                                 |   1 -
> >  net/ipv4/proc.c                               |   2 +-
> >  net/ipv6/proc.c                               |   2 +-
> >  net/netfilter/nf_nat_core.c                   |   6 +-
> >  net/tipc/core.h                               |   2 +-
> >  net/tipc/link.c                               |  10 +-
> >  44 files changed, 306 insertions(+), 164 deletions(-)
> >  =20
>=20
>=20


