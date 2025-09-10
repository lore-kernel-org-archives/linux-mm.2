Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 511F0CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 10:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595D46B0006; Wed, 10 Sep 2025 06:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 548F46B0007; Wed, 10 Sep 2025 06:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45B7A6B0023; Wed, 10 Sep 2025 06:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 342ED6B0006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 06:41:27 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D4CA41A0454
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:41:26 +0000 (UTC)
X-FDA: 83872998972.23.73E966D
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf30.hostedemail.com (Postfix) with ESMTP id 053BE80006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 10:41:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NGifrNin;
	spf=pass (imf30.hostedemail.com: domain of glider@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757500885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ep6DHmBHgd1kpbChAS+R+dvVahzWEZwGQlVUAbmwU28=;
	b=H6osJGaBvWVzY/r0ZCZL0mIALuatOcHkwn9F8dKPZhbIVOplcit1/BeEiq/szpA73gEM5X
	WzxYOg15H7wzl3tL2pqd8tGq/qgeZMfkuPFuaoc4sRNB9bccCztF0ryIM+1QkV+NmpSAs/
	csW14la0ZGWX+ndcTyzIKq5Ss/TStfg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NGifrNin;
	spf=pass (imf30.hostedemail.com: domain of glider@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757500885; a=rsa-sha256;
	cv=none;
	b=qM5Nh9oxc8i2XO3jTGldHYSmihXWnw/VeCZ717ae83gZgJdwI16XhsJG+kilF+oL0ejy0g
	IUU5n2gMfQKDdaLGR8JnQsJ7sfaegQqMhHgvIerr68KDPKaHROZ3gB9eAGDqLO6Hxj2iOR
	ekUN4EUKr4qS+1shh8cr3EJIHApa2aA=
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b548745253so93409111cf.0
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 03:41:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757500884; x=1758105684; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ep6DHmBHgd1kpbChAS+R+dvVahzWEZwGQlVUAbmwU28=;
        b=NGifrNinNXVky4xeyOalczUuvSXKdNL93iSNw18y7dKbASQFNyGAMnzeX0pybW/VPe
         8GV9dTu18W7WjQhCbuAdlN08oRrb1g9dOhtewlVBe/xtbsY3B8Ye1UzyTPrb/JT9foGB
         8mdVq9rdVgVBto3KKfpsozSQUvTuOO8pyKk/h24CcSEYwDsTOXFERVyO0J1kMkD5KWdQ
         nkZjn5/kK8BPE8Ed9237jaUUxLIpuL2qpF4ZscCWbrdnz+Z4AfkhRvV9qSnQBp/ZkIX5
         EUctjkUl6lpFZB9YMKXGzkXMmurE3lF2W4pL9eus2bgBpPrfawC+59ctRHXSVMIxWjLC
         q82Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757500884; x=1758105684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ep6DHmBHgd1kpbChAS+R+dvVahzWEZwGQlVUAbmwU28=;
        b=hcTnTW5ILptMgFwsLF5Sop55xwOqfDwyNJWOEvrbt+Y73GoAY+WbNOdDPgcn1bZ7f0
         CPkdvonrDokWZpOKqr31rXL5KZz4uoNBlGSVm8fF5h9+INY431xhWGJzFXO7M4ho4FGm
         155ZctoMlYUKkfBWjB1dm9J/J+O9XNE1Dwjy57Gg+Cq8NApv3r2gnZDbX5LS+MfPiRQs
         5HvXQbRsQcLpEhOpuGC6pTXGg+DRCnbbLEVqYIqJxHxNIEqctQtiFqHKIW57VrGRH0UZ
         jnCxZLw84zAY+fs9+vwy2Z9h6v1hoZL0TNp7FI7GXj8WQwEsYZ/FdfeMHL6Su4tQ+is1
         5k6g==
X-Forwarded-Encrypted: i=1; AJvYcCXHJPfkwP1I/byW9l/9e4AF9evL41aBps9c38XuVjHlNZYpPp9eQ79La9efb1AZsveHUVTmDbfwNg==@kvack.org
X-Gm-Message-State: AOJu0YwJh0QsWz6qNATOVCedVa15Imk731yWLmp9osJkic+TyWNy5su/
	NGwxWDy6Hui7odkUH7Od5zjstXTL7UCMV0iM/ERSVnWAENmTbSwAax0C4/1rbNB4Kdp9YG4yrYz
	W36ziY7SOdlp9soM4m5fj0jz25xh1UVaFEET6soJo
X-Gm-Gg: ASbGncuQuz89bXxtd226n6Ny72iRHaZnPookPFH4DVSKnbPRGSetr7YTOD/s4VV1jiI
	bGHhzhEnrBvdfpJPzpNFu5fSIe8yYhLkVCiyKl3SbVUo1xyBpSccRVpszi23lnjdkSPaGDHmJNR
	rrWL5tcHLC2pMy2u0MgPojsUakx85+zxMZKST0EOeCSUE55vaJKnHU3R7D4hd1osM8+MiM8IDcX
	aJv8VLtKGyRssiWzSH+R8uX7MjVySNLmrN60lMvjArn
X-Google-Smtp-Source: AGHT+IH+/cbUHy8aAQiP5y+HLOOkI7jZTVO1M0xIDiJAFbe2JLcrCl7FbgVqf5O3wrtsPiVVxFILCO1nutxZp4kGACw=
X-Received: by 2002:a05:622a:40e:b0:4b5:e49d:8076 with SMTP id
 d75a77b69052e-4b5f84676e8mr170436381cf.56.1757500883119; Wed, 10 Sep 2025
 03:41:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com> <513c854db04a727a20ad1fb01423497b3428eea6.camel@sipsolutions.net>
In-Reply-To: <513c854db04a727a20ad1fb01423497b3428eea6.camel@sipsolutions.net>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 10 Sep 2025 12:40:46 +0200
X-Gm-Features: AS18NWD9OOMFghsEyUOQIKKsq3tKxaVXVh2dSpezbvyYolCB64CRn-65yckShSU
Message-ID: <CAG_fn=Vco04b9mUPgA1Du28+P4q4wgKNk6huCzU34XWitCL8iQ@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 0/7] KFuzzTest: a new kernel fuzzing framework
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com, 
	andreyknvl@gmail.com, brendan.higgins@linux.dev, davidgow@google.com, 
	dvyukov@google.com, jannh@google.com, elver@google.com, rmoar@google.com, 
	shuah@kernel.org, tarasmadan@google.com, kasan-dev@googlegroups.com, 
	kunit-dev@googlegroups.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	dhowells@redhat.com, lukas@wunner.de, ignat@cloudflare.com, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 053BE80006
X-Rspamd-Server: rspam05
X-Stat-Signature: suz8itdy7dkwbsnhpcmstqtunyd9k4o6
X-Rspam-User: 
X-HE-Tag: 1757500884-609132
X-HE-Meta: U2FsdGVkX1+bMH2wLBnb+m3vZ7VtB5aLMaecPzTVZIpdkR/14t+O077jyWYLGTKKhNzW6mAvWFxxthjsOLIThHpIXNWoIvYy0LKlNAicwVO2G4trq9KRETI1JUW6QnHdr+sPBGxarp6RK5alWIPcgyNXVtq1ZreZjtveuceILCyu4aQ/q592li5ENBeiLPu4gAeivNeXKpmeS/+6eefzcoiHeQ4jAPjhVPXQfVMiVTkVcXdQ2DnHXbg+u98hH9i+HhqczelSmePxGtkDH0JteJNTbXo5xDeFq/iT5xk1y87JK1gYeO64y0Q63cl0LrcBDHdVl/EDZ4liXvlaZjkAVpb/imf1RRldn+Ubn6Y77ioWcrH1x/d+a3DR/ewHJd/DkbwJzEet0UMO2LS5QfbEBKPpA+DMTqskh+F3ue/mzmI+eX5Dd58uh/Mv25gJciLAclgMQnsrsJNVhEhr+AK7IHYl4mF+41Vxj6xmeRAs0diJtHCHb4CVaFjH9Un33inqyKr46vGuMb9PG34y5j4Nbr+j2gpOGDSNxCA4v5tr0HXtZ2EUKyZGgCe+0NFHnrI2FvxO8qMiM9j2vBx76CxHc/k9xVMIOU/esSKXxiTwIRe8vSw50JKdZD5Tav744dZ24qBw6MEfIWELFAp8bfBRHexRquFdHXgL0bvB9bVdvBhXSgR5dTmsLs2uP4+/q1CXcZPzfIfqlqAm7ZblivYWuLkKh8dOnjMkHH5mAlvXrvuufSCbuog3adpjKyHkttcoZeKoXLSLFDDDEL8YPmPpcR7+09m2tsT1sbYsoPopmr0jHWgk3+kj2eTZqx3kdFBtRNB/ROvTCCP0HJ9qyJGwy5rgwFb5EpX0hHF4Oxf6G5/3IanSGSrGAKVrKmulGjMpWXEEdVOuAAsmgDH4csrQMqNFbIDPz1TIztUlKcBMdERJP44vkmj0KSqN42Rh9lgk4Kxy7xmG3mjIJJgc4UW
 yeFqosDL
 hZSRf2Zd0j79V/Og8MxFbE53GxcE6KODqsqhVQdZHyw9gV3pOdEKsbxeib3dIn5qJUQkUryzck2CWQQ4501rLLW57h/kgVjZU8pJYivR71Ot4vUKKjCzNGaYHilLl48csh33atD5X9pnM7etoXVGOsC+J7sfsNra7gAgF4u48ouiS0qQLJFO+rYXXzgSmxVM2943z7spYHWzs7TfINiDma89zozjEiut0ofED6Cft5nn9DQ5ibYhvLL6gVFxMORD0hE7C4TOXQLEhInKfAfGD00WwjgZDJFtX4oCW1WdzmYqJzBLU5gc8nXfdoPRa60Pz5HSE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 8, 2025 at 3:11=E2=80=AFPM Johannes Berg <johannes@sipsolutions=
.net> wrote:
>
> Hi Ethan,

Hi Johannes,

> Since I'm looking at some WiFi fuzzing just now ...
>
> > The primary motivation for KFuzzTest is to simplify the fuzzing of
> > low-level, relatively stateless functions (e.g., data parsers, format
> > converters)
>
> Could you clarify what you mean by "relatively" here? It seems to me
> that if you let this fuzz say something like
> cfg80211_inform_bss_frame_data(), which parses a frame and registers it
> in the global scan list, you might quickly run into the 1000 limit of
> the list, etc. since these functions are not stateless. OTOH, it's
> obviously possible to just receive a lot of such frames over the air
> even, or over simulated air like in syzbot today already.

While it would be very useful to be able to test every single function
in the kernel, there are limitations imposed by our approach.
To work around these limitations, some code may need to be refactored
for better testability, so that global state can be mocked out or
easily reset between runs.

I am not very familiar with the code in
cfg80211_inform_bss_frame_data(), but I can imagine that the code
doing the actual frame parsing could be untangled from the code that
registers it in the global list.
The upside of doing so would be the ability to test that parsing logic
in modes that real-world syscall invocations may never exercise.

>
> As far as the architecture is concerned, I'm reading this is built
> around syzkaller (like) architecture, in that the fuzzer lives in the
> fuzzed kernel's userspace, right?
>

This is correct.

> > We would like to thank David Gow for his detailed feedback regarding th=
e
> > potential integration with KUnit. The v1 discussion highlighted three
> > potential paths: making KFuzzTests a special case of KUnit tests, shari=
ng
> > implementation details in a common library, or keeping the frameworks
> > separate while ensuring API familiarity.
> >
> > Following a productive conversation with David, we are moving forward
> > with the third option for now. While tighter integration is an
> > attractive long-term goal, we believe the most practical first step is
> > to establish KFuzzTest as a valuable, standalone framework.
>
> I have been wondering about this from another perspective - with kunit
> often running in ARCH=3Dum, and there the kernel being "just" a userspace
> process, we should be able to do a "classic" afl-style fork approach to
> fuzzing.

This approach is quite popular among security researchers, but if I'm
understanding correctly, we are yet to see continuous integration of
UML-based fuzzers with the kernel development process.

> That way, state doesn't really (have to) matter at all. This is
> of course both an advantage (reproducing any issue found is just the
> right test with a single input) and disadvantage (the fuzzer won't
> modify state first and then find an issue on a later round.)

From our experience, accumulated state is more of a disadvantage that
we'd rather eliminate altogether.
syzkaller can chain syscalls and could in theory generate a single
program that is elaborate enough to prepare the state and then find an
issue.
However, because resetting the kernel (rebooting machines or restoring
VM snapshots) is costly, we have to run multiple programs on the same
kernel instance, which interfere with each other.
As a result, some bugs that are tricky to trigger become even trickier
to reproduce, because one can't possibly replay all the interleavings
of those programs.

So, yes, assuming we can build the kernel with ARCH=3Dum and run the
function under test in a fork-per-run model, that would speed things
up significantly.

>
> I was just looking at what external state (such as the physical memory
> mapped) UML has and that would need to be disentangled, and it's not
> _that_ much if we can have specific configurations, and maybe mostly
> shut down the userspace that's running inside UML (and/or have kunit
> execute before init/pid 1 when builtin.)

I looked at UML myself around 2023, and back then my impression was
that it didn't quite work with KASAN and KCOV, and adding an AFL
dependency on top of that made every fuzzer a one-of-a-kind setup.

> Did you consider such a model at all, and have specific reasons for not
> going in this direction, or simply didn't consider because you're coming
> from the syzkaller side anyway?

We did consider such a model, but decided against it, with the
maintainability of the fuzzers being the main reason.
We want to be sure that every fuzz target written for the kernel is
still buildable when the code author turns back on it.
We also want every target to be tested continuously and for the bugs
to be reported automatically.
Coming from the syzkaller side, it was natural to use the existing
infrastructure for that instead of reinventing the wheel :)

That being said, our current approach doesn't rule out UML.
In the future, we could adapt the FUZZ_TEST macro to generate stubs
that link against AFL, libFuzzer, or Centipede in UML builds.
The question of how to run those targets continuously would still be
on the table, though.

