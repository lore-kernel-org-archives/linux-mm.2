Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B1DEC44507
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 00:10:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20CA56B0088; Wed, 15 Jul 2026 20:10:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 196986B008A; Wed, 15 Jul 2026 20:10:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05F396B008C; Wed, 15 Jul 2026 20:10:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB1266B0088
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 20:10:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2D43F120360
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 00:10:43 +0000 (UTC)
X-FDA: 84992708766.09.7778115
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id 585F5180002
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 00:10:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mLJAIlrW;
	spf=pass (imf06.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784160641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P4jDzMSQG0md28knM5bL5uqnp/M0FWc4W2jCI8EKDHM=;
	b=SqWnPym/LwGdN65yOuhMRb+0puHu7TKqCJbQwLQNFAMCpCjn1ZrhprvApw3waLn3rhIPjH
	SW0IwRWXKISAYJBrB0HbJKXw6eAcW28GLXSEhWy2uQ4WIwM9xANUzfddZq5flmkmLVi4CE
	hVYfKi44yDUBT6ZyOqEOlrXZ/tioZTU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mLJAIlrW;
	spf=pass (imf06.hostedemail.com: domain of farid.m.zakaria@gmail.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=farid.m.zakaria@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784160641;
	b=csDAupJ14VyzqDwdRQVlkUmQt8nEyXaIza8v8ugxhmWEzenfceJC5fKlhwjRtTl8f/gSNF
	h8uxeaOfZ4pyNWx3CBWB7/ILgjPwTJyANihBthSkt1d4dTmxelBx6YI6aVR+GfznUIw9Z6
	wy6Z5OvVUg6OTuutjpY5C+zm3YmYu/g=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-381216921aaso6216237a91.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:10:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784160640; x=1784765440; darn=kvack.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=P4jDzMSQG0md28knM5bL5uqnp/M0FWc4W2jCI8EKDHM=;
        b=mLJAIlrW7/2Taw6BfU+8G9dqQErVToZlQAe6Bk5GazOgt5BHeWrOkF0pXHlEs+L+3r
         na1naS1Q0x3qcP9E+hGc5VfJ547DHCSO1Nh/6O/rt9eIUuQM8Lw989Gfxkkz8xdbgAGr
         FWkv4N4LSJzLdRpKk7r44jLYe50ThywhakC5xY1Dr84LNzaEvkAF//WQPpw0+nLiqGlg
         ASzmWC9DONPFsnqzAxkLuf4iRdHFMFxQ97gRIzU13wgZbAvkCoMUfwiY7gS6Q5wan7Nr
         X3XUATvm4PizItMyKnTRvdhPAJTLIvoI0bZTDME0Cvzddbh8l12LuvulaHoXUo14MGQe
         tntQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784160640; x=1784765440;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P4jDzMSQG0md28knM5bL5uqnp/M0FWc4W2jCI8EKDHM=;
        b=YT5zO5BHaAcC2w2+5CqQyv/CCLY8FJDWKU7/rivb8n2p2Vf7tpDWCaIovmV+7/kJjL
         nPtHUT6w9BPH1mw15hWmJlh1Hfp9sUojJLtet4Od3t8COVwC5cqfacxtnwVn923lnRRv
         Cmx/7fnSlBMWFijxE8HfHUF84ef0d9fPqzakkehq9dEKEKNk1gqcDzplfiO6D25ArOat
         s+lCjx23Ply9NfYUxAvngwSkpvuU3HAyNZPvnOGbgfYCPaL+3zoCI6GE/Rl3LhFbV36u
         k5nSggtddUUz5OoxeUZJJw/TRdAicpGqJUqInZ6a4MHvjQKk4/k0lRxjfjIdZjg8vLFJ
         F1Hg==
X-Forwarded-Encrypted: i=1; AHgh+RpxjuGNVsacTnff8OgTf+n5fOTuI3yBG2wc5FXstkN7c4DLb0naUUVeZmzlFTCrX48BwYsTUcYSlg==@kvack.org
X-Gm-Message-State: AOJu0YyU/PEj8XGDJ4LRTLe5K0q/EcJ0rBGY6gTMwvWSjTIwTmm+a177
	a8SKsfR5fYep5a7JkSd0BFpYF/NH7f/XOhFeJur8X1bRjZGINTQX+Cp/
X-Gm-Gg: AfdE7cmFSbetnTBVW9LeeyZaZbCIuN9rws1Lfkz0oH6nyja+Wlmi3Xw0RNWlKoaAOhi
	92sokzKov9vrCAzb9MnET9sF804mXii1+e8o2MEJZ0QMOOUDBZXT9DEBjZGk705Ko3tWlPLIWFO
	coDCaLInjHV1Lgq2Cr7Qd0Wl6WzuOzWboffetd0SEefPDXisBmugMpy5S6XqlmBCG2XOZg3xae8
	2KuA+lkwx6S4euo7+dhx+4Nuk9VlznVjo6CF0lWKaIUq8gf2a2MLK/YooxsmGs5PBtZYXa+cQTG
	FUcdKzV+jTGtLIilfO841QhBhIWmL1sJXYKuhX+EsSt5w16Obb59dtySBh0UuaLmtnH79D+tr72
	jX8CJ/59jaY3ZxJK8NGGllqEK4bCgF/eKGlDpBVipJfATspeQd8rW7HY+yCM3EyGefdpJcvy+tC
	arXi8=
X-Received: by 2002:a17:90b:2ec7:b0:37c:774c:77ba with SMTP id 98e67ed59e1d1-38e1afbf5abmr8173040a91.21.1784160639936;
        Wed, 15 Jul 2026 17:10:39 -0700 (PDT)
Received: from localhost ([98.35.8.117])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e6ebe98sm4999273eec.26.2026.07.15.17.10.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2026 17:10:39 -0700 (PDT)
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 15 Jul 2026 17:10:38 -0700
Message-Id: <DJZK5TY3IXQC.2XKA1X9IEGJDO@gmail.com>
To: "Christian Brauner" <brauner@kernel.org>, "Farid Zakaria"
 <farid.m.zakaria@gmail.com>
Cc: "Daniel Borkmann" <daniel@iogearbox.net>, "Alexei Starovoitov"
 <ast@kernel.org>, "Kees Cook" <kees@kernel.org>, "Alexander Viro"
 <viro@zeniv.linux.org.uk>, "Jan Kara" <jack@suse.cz>, "Jonathan Corbet"
 <corbet@lwn.net>, <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
 <bpf@vger.kernel.org>, <jannh@google.com>, <mail@johnericson.me>
Subject: Re: [PATCH v2 0/9] binfmt_misc: bpf-backed binary type handlers
From: "Farid Zakaria" <farid.m.zakaria@gmail.com>
X-Mailer: aerc 0.21.0
References: <20260714-work-bpf-binfmt_misc-v2-0-57b7529c002c@kernel.org>
 <178407531866.2243172.12944140194021045628.b4-review@b4>
 <20260715-reorganisation-umtausch-radiergummi-8b38ca81ebb0@brauner>
In-Reply-To: <20260715-reorganisation-umtausch-radiergummi-8b38ca81ebb0@brauner>
X-Stat-Signature: 69bwciddptey5w69ejyopuwsuo64tsyx
X-Rspamd-Queue-Id: 585F5180002
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784160641-951919
X-HE-Meta: U2FsdGVkX18agC4pkNko2GfZdVksn3tLimlttavKBHnysTDG8m1OjWW95yslwvgJFNn4p6j7bsDesKsemqpPptpYwzI7dZE3hh8+LY8/V35tJU7FL/S5otXl4YWujo9vi/0s/MQuQH/GeKXGLXOZ6LLwRnCJrKtQWG4pL8b5J5/99CQ4Waa5NtiPJpm8mE2h1Y+s2HS8B/T522vByk3+IF/L9npwvtzy/8sbs4ayjpnX6orlyqr21tSsUx5u5IcmsCWHIFqTnykdW6Cqu8CsZqhPExXw6Fvb0jiMHZRY+PoMd99vyykFaIxBcMUdFwK8+eLC7+7IJuxi1wR2P+C5JsAqbOHfqI9PuUux5pKLmkf2AeEvYhgJ/iTvWkPIK1a4eO1EO5rRLz9g0KGOuR72p1caCNhLpuFHEgPzz6bmodOpNhIrb2XpnQXZBdoSfx14KNV49tJJHA0V6xpjfrAMgCi7vi99yQKBcTVCY0sDsBONMOSTAT/KkRCcpircMC9Xb91+t2vpHZEgntuk1voJfDwFIvU3Qne35FdD9husG+oo1D6YB9up9yl4umnywS+15deqcFMktwCsfniNfsuuEO4uQetQzli6xcz2ctuHWiMjAlHuj2Szlm0OBrMkfa9bxZq1PUoGCA4OMr+ojKymHEbhmoFConBj2jDGfwYDWxpej6Yu6dFH13U2U3SXn8VBMTpxhyZnULrt3glgdDbn1Gz8Za6DtUtSd0zBs947QbD2JoFgTy+q7phPKXWJaepOmjmrZgUAV/NAKCz2WjZkXiSHMhUwQ1A+CAR15yw+NOxO6EsrrIcTdaXkxJnxWsi6UykhDFPNxi2BU44uBH6JQ6+75l3Sq8QZ1VD7nhgstVR+WW+xhuZlq+cGnPw8AwKTJHEydDhgFBwc0FyNFX3hiq+G9YlTJnhEN0ymISleyEY9jyjHoBDrAHYeMkpunqq6cFgas7Pum9APHaM0ZKQ
 rTAI+U9c
 g5c8VnNqIARHIyIFmQdEOdkQfg7CHVABVtL5jK0GL6NefJO9a340vaywqS7cjJklMv/QKGDcOvrvBdA30fZUNV7Nw/J7DLzDaYYzhMcsoO43DwGkq/OOjSl2mUQ96rnEmZANW1MpDH7cZbO8GrTgXMPHEY4S1ShdtiTPTkC5QgNsXYgm4FIoqhvAeRRpiPDdX9s3hLCivqzPgWNfbYdKh/m2MdH3xwkLZKlKbhsvewlKRCsbgaFFu///KLl7Y+d1bNsPLHwkgEzlN/HhWGjPMFgv0wbnndj9fdpHnG4WPFyUQrqOO204je97mhCzpHdyMTXRuvOYbNnWu2feKS1RjCGjKJgTjiqC9FReR6XY1a5MktDtiRsj0ZAVKmSNgOVeV49aoe2+Xz34M6XwEDk12BKYv1vERKRhhayYoVKfYR46RNE/kvhicU+cfm8/TnN00KRaNtjZdzLSW8xrBTYdcxO+PjTuDYazwnuL5BaNUfOjDhXPCpguJQmu7YJtoMPuT6JQ9JfdNLcE2PprbXzPk+8pnirYZ39r/1tbQF6g98A6LEzUYCxfrnNpyimB0Txjz589dyApi89JuOYJ3sD2DxguGbz/ozkEVtldKQyeIjVmnCUJc3UaVhpgpg7Zw/92YFaGwpXKM6oEs3jk4LZMCn23WcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Jul 15, 2026 at 1:40 AM PDT, Christian Brauner wrote:
> On 2026-07-14 17:28 -0700, Farid Zakaria wrote:
>> On Tue, 14 Jul 2026 21:58:05 +0200, Christian Brauner <brauner@kernel.or=
g> wrote:
>> > [...]
>> > 		.load =3D (void *)nix_load,
>> > 		.name =3D "nix",
>> > 	};
>> >=20
>> > Farid, this should slot underneath your qemu demo from [4] with the
>> > program ported to struct_ops. Feel free to take it from here.
>>=20
>> Thanks for the recent update.
>> Is it still "take it from here" or was this left-over from the previous
>> series.
>
> Leftover from the previous series. :) Sorry.
>

No problem -- just checking.

>> I think you've done the majority of the work here with the validation of
>> the few selftests and mentioning the gap for shebangs.
>
> It was a nice joint effort imo. I think this is in general an
> interesting idea. I'm also working on some glibc loader patches. One
> of the patches in this series allows for "transparent binary execution"
> if the loader supports it.
>
> In this mode you can pass AT_EXECFD to an interpreter and don't change
> the command line. An exec like this is indistinguishable from a "native"
> exec.
>

This sounds super interesting (orthogonal to binfmt_misc and BPF work right=
?)
but a neat feature nonetheless. I wonder if this makes it easier for
tools like perf to attribute the correct binary or they have already
handled interpreters in the cmdline well enough.

>> Please let me know what you would like me to do next. I just tested
>> reviewing the series with b4 + AI -- pretty cool. Was a little clunky to
>> get it to work but overall a good experience. (I need to tinker with it
>> a little for NixOS vim setup etc..)
>>=20
>> I shared this patch series at my workplace as well.=20
>> I think there is some interest in the work.
>> (If you are curious as to why, I can elaborate on that as well).
>
> Sure, happy to hear other use-cases. I have a plan to make it possible
> to pre-open a set of interpreters (pin them essentially) when
> registering the handler in binfmt_misc and then bpf would be able to
> select from a set of pre-opened interpreters but that's for the future.
>

This is assuming that in prior calls to the BPF it returned the path
string to be pinned?

As for the use case, we use buck2 --
a build system similar to Google's Bazel and does many things in spirit
to Nix by leveraging RUN_PATH to create links to the shared-libraries.

We have customized our interpreter however the lack of $ORIGIN means
that we've had to maintain a single glibc versioning across our machines as
a platform since glibc has tight coupling between the loader and the
libc.

This has been a pain point for upgrading. I think the ability for the
loader to now be relative to $ORIGIN meanst hat each binary could
diverge glibc/ld.so and not affect the rest of the machines.

tl;dr; ld.so from $ORIGIN itself is not only useful but since it's
intimately tied to glibc, it allows for more flexibililty across our
builds (very similar to NixOS in spirit).

>> I hope you are enjoying your vacation.
>
> Thanks!


