Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B1CAC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 13:50:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D0D36B00A5; Tue,  5 Aug 2025 09:50:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A82D6B00A6; Tue,  5 Aug 2025 09:50:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE366B00A7; Tue,  5 Aug 2025 09:50:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6ABEB6B00A5
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 09:50:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CDA481A0744
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:50:25 +0000 (UTC)
X-FDA: 83742838410.27.621F2B6
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf04.hostedemail.com (Postfix) with ESMTP id DB91940005
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 13:50:23 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Gh7A9m2x;
	spf=pass (imf04.hostedemail.com: domain of jannh@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754401824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OM5Sak9VYNXA/4oFKKbDTzSyVDrMPAA9ankjux7yv0E=;
	b=lsWueAzwxlV+KHcKjW6SLYGvHeh8x82TPO+Vk7sPFKdRLV/pgcCsRPXkszww2XKlpySQPX
	ueC1BN1oRn7v1IEa9PfWcqKE8lxqQmf2R0CtEsu1iXDcpzFtcF1SlEjSpAER16rIHRb5r7
	G37OpDgJhym2MDkgCxUrNSz4NFlK/CI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754401824; a=rsa-sha256;
	cv=none;
	b=qV6h6ryPFag9eX5MHGNylrpvcZRFe6U0B68WLAx0TkWyFr+lpX5/MOCeLSuCLSHIGadvNe
	rrOg5AEZQVN/UNVCDmCItVqKpuwcNaCMkZNe4wvHQ3Ow8n1xvzhl+nADnC6wM/fvPS3Ajs
	qfpBz2TYsfe/dPviHJwR+cqLIN0XL8A=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Gh7A9m2x;
	spf=pass (imf04.hostedemail.com: domain of jannh@google.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6154c7b3ee7so14082a12.0
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 06:50:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754401822; x=1755006622; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OM5Sak9VYNXA/4oFKKbDTzSyVDrMPAA9ankjux7yv0E=;
        b=Gh7A9m2xOi7a5Xq1zNCILDJnEeNia4QJuts6Mm35d0g2PBQZRcGiHKhOMNRfjtV3Wh
         osG7gTyB81wXtddQEM1ztxtCrEX+hb2EiJ5lWLI5G0tcQErxsNO+PwIaVd3SGwHJbimt
         cW00+YzUtPttMTjwkB8NwJPvWBD4TUIAL/GfMew4jqegkGYI19naFwQypJ+l1JQ7H1Gq
         28OtIQNYvL6rZKE9BLUFdPrXj/pyHXjzS7cSbI/Jm3dUesW44GZygoQEAJJ+hPPOqXQE
         LPbxOy007/41HZEHHznzIJzcdWNEAkk2ZQDb21YxSilPNJ4JJnIryDvf6zZifrtMzJGl
         HMsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754401822; x=1755006622;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OM5Sak9VYNXA/4oFKKbDTzSyVDrMPAA9ankjux7yv0E=;
        b=f7pOa9Xrhz824sdR5PHCdCPyq6MD90wPr3Re1zZLKy0N5D7ctZCTYZSHKku5h2TXsD
         NbzmBIaD/DE3Z5ML8tt8ul445aw4HNGxWl8MZz0CDJPmXt2KFt3ZufOKekFof0JbZ6qx
         IAbp04pxDd073lFbS0Ytytjb7Ree5dUSrPvgq947BFt9w0uGT1rLJmrlTA5H+NNXSMTL
         f9gEPqLQ0ozEQFIx030d8hcQzCMEvcFMnmXcyWkX8gvrABE+o0SkuLi5r5BG51zk97mQ
         I55X25DLjSkA9YxvBalER9YVmq9N6PJLSTczcLTmS50LWPLBx1b3gMtQodSjYPfmRUGN
         6QNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVMj6QexdiwLXtM51yYaPSwJNpOwuQCwI6SCOhvU6jlDnnMlqvLqg2VAagBdulAmKpX+4003i36vg==@kvack.org
X-Gm-Message-State: AOJu0YxIF5IBYaJyERSTTZ2KhfubztHVhGOVU4Oy7dUYSI4dcUerpjMh
	kmqkgHn6b7YBEfht0SEqbaW/CwzwBGjMsaLxDmV4LrnAumR09IR9qxDn+l3FLvmRxG0BGShtIqH
	HqNAd8EyqjCviJQaT02STzxctd5Z29lMv3+/a2Aji
X-Gm-Gg: ASbGncu64By8rfpMC+lnC4jlhmRonD1A3kYDbVYT0sicIY4Qxk/aga8jF7ue1h/4dCn
	hrlcOcWb5i27ASuZr3gbxJCEkVYqXzphkkyQg28Y7dubr/s7Zby7A65s9umfbLFZ9kJ91/MFJ5j
	69wuhSORKlScj/43//STKnsmsjAe9FofAR9Yp7Sj8Cl4cMb/yaelg/BagdmvsK5Ut8mZtt1Ka8+
	R3TlvMkHbj8By9i/0MO9i8pP0QW0SUfNDM=
X-Google-Smtp-Source: AGHT+IHkUewzm/8PTdOyIiW/iPVhbXcnpy+KcxT34FnucOdRizqHQ5Mn+Gui7Bqb6LBcfhucb4rfr5500SDXDs4vrhI=
X-Received: by 2002:a05:6402:325a:b0:615:3fe5:a925 with SMTP id
 4fb4d7f45d1cf-617848372e4mr53602a12.7.1754401821913; Tue, 05 Aug 2025
 06:50:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250804-kasan-via-kcsan-v1-0-823a6d5b5f84@google.com>
 <20250804-kasan-via-kcsan-v1-2-823a6d5b5f84@google.com> <CANpmjNOJxJ+kM4J7O5J8meSD_V=4uAa6SwFCiG83Vv_8kn56sw@mail.gmail.com>
In-Reply-To: <CANpmjNOJxJ+kM4J7O5J8meSD_V=4uAa6SwFCiG83Vv_8kn56sw@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 5 Aug 2025 15:49:45 +0200
X-Gm-Features: Ac12FXy65DGv8cn62c1xeecD1pKxLWVWZniqqA9hR2KQYd_-HuNZowNKVDRPddo
Message-ID: <CAG48ez2_HrKjRuH+5KSB+vK_9dGeNnh2O6qAN0ePr4BRnt3xzw@mail.gmail.com>
Subject: Re: [PATCH early RFC 2/4] kbuild: kasan: refactor open coded cflags
 for kasan test
To: Marco Elver <elver@google.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Nathan Chancellor <nathan@kernel.org>, 
	Nicolas Schier <nicolas.schier@linux.dev>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
	linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DB91940005
X-Stat-Signature: btndotuyuws84hoj8ejass9pwwysaks9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754401823-664903
X-HE-Meta: U2FsdGVkX19UEAR8+KP7+IlDxp93Eu5KsomDRX+/QOuG66HHYdWiNbMynh3H9XKZkm5NGqe9XVlMz2QRwWAwFabL/Wq+6Tqnidcsv9DDsr/1sliLwYAD9ymzvuiQ9mn1LJ9mpSTSmkyim0U62OByQDV+nCyzs4rf7Bz0Gf0NYmBm/jT2mZ0/X8LFd2Kw3f6wMlhD52rnJk9CneVM7XYcx8mvBzu/U6U9TKm7Bmf7XTyr9J967c6N5TfshPXcTwdPShtxkyFMr61VJdbXK//LAZgfQRguv7IvvFwEHEIX/e84zO/e22IkrzCvRYQWEgb7If6EJPaSWgo/NL09YXF8YiK41u4JYZ9qmJHZ2RtCA2cs38zJikAQ8KjmqKhSbOqaJzYkW0D2vbuFSWTNDVj+PwKpQ/7Vk2aBdCXlVMkoo2CNF1MPeje1c0HXPWx/ERz4scZhNA3xWSWnAGNjzPirTuTtkQ/6i7/EvUgBDpwjzbyVHyk4u5lPvL8M2y2RoWcjFX3GWpDY7lw6oWPflyzt7mz6sZ27HmWHevotTRMJYvm1c+j8ao7yjVp03Fv28ChnKT0vcJOO9jwvDJvUq90Qxv99xqhaxwCyN7rKMptniGcEeXJI0781tavCjPfAhU0OBQkmPx1i2NlgHE++kc3phna6sr1Nki2Xyw6mjle+a2qd+fhEgm5t5QGA0dXThSv3cG+XAfnWt5uHC0wwWYNOrYjqBVcnk9+hlwUvh5hUe5deyW3OX+9kAIpOwffBmHuhN1Io9kEUvuSe3wSmHA8oNrlbrWo9nmtV5oXjHOiJVbsM+ZLAVpE31dVSHcsMs0fmODDO+FOdq4ES1jX/ZkyWkm6HwBbjVFuMCbUqvS686DIAz5xXiNEfv6WaDfKHG+/hDjOtmRIQ9/Z+/3d0XzaADYR/8jZ3d09pbOQ9Qeg/mwmVoeqeanazJmy4PnkLdFrYsaXKt/S7UuHPBYYH1j3
 1tmLx8BJ
 mr8yb3as4Nt2ldN/n6hO2IVOubVQZh6zmbNYk0+11voyJnY2WZvlCCTF97L3uHnjtYV1MGpbCjf6FnFtClKX7vre02raeVNOzLn+wGK8g5rlfq096lwrJ12XCWt2xgkDQ0nOVlWVs54AQB2WNrByGtsse1SDEpQ28ByGPGn4mvslc9bE58hLAhICZ4SiVKwxZ7ewFdReruXa0r9UoENs/BtOhPQGZO9vIn5b7MzYlIIfxtJUKLXW4S9chd4OPyD1bnvpuII18krMWfOef0l1KiLemjqbWB5vQuIvk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 2:31=E2=80=AFPM Marco Elver <elver@google.com> wrote=
:
> On Mon, 4 Aug 2025 at 21:18, Jann Horn <jannh@google.com> wrote:
> > In the Makefile for mm/kasan/, KASAN is broadly disabled to prevent the
> > KASAN runtime from recursing into itself; but the KASAN tests must be
> > exempt from that.
> >
> > This is currently implemented by duplicating the same logic that is als=
o
> > in scripts/Makefile.lib. In preparation for changing that logic,
> > refactor away the duplicate logic - we already have infrastructure for
> > opting in specific files inside directories that are opted out.
> >
> > Signed-off-by: Jann Horn <jannh@google.com>
> > ---
> >  mm/kasan/Makefile | 12 ++----------
> >  1 file changed, 2 insertions(+), 10 deletions(-)
> >
> > diff --git a/mm/kasan/Makefile b/mm/kasan/Makefile
> > index dd93ae8a6beb..922b2e6f6d14 100644
> > --- a/mm/kasan/Makefile
> > +++ b/mm/kasan/Makefile
> > @@ -35,18 +35,10 @@ CFLAGS_shadow.o :=3D $(CC_FLAGS_KASAN_RUNTIME)
> >  CFLAGS_hw_tags.o :=3D $(CC_FLAGS_KASAN_RUNTIME)
> >  CFLAGS_sw_tags.o :=3D $(CC_FLAGS_KASAN_RUNTIME)
> >
> > -CFLAGS_KASAN_TEST :=3D $(CFLAGS_KASAN)
> > -ifndef CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX
> > -# If compiler instruments memintrinsics by prefixing them with __asan/=
__hwasan,
> > -# we need to treat them normally (as builtins), otherwise the compiler=
 won't
> > -# recognize them as instrumentable. If it doesn't instrument them, we =
need to
> > -# pass -fno-builtin, so the compiler doesn't inline them.
> > -CFLAGS_KASAN_TEST +=3D -fno-builtin
>
> Has the -fno-builtin passed to test if
> !CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX become redundant?

... oh, bleh, good catch. Somehow I had convinced myself that
scripts/Makefile.kasan did this, but no, that only sets -fno-builtin
for uninstrumented code... I misunderstood what was going on here.

