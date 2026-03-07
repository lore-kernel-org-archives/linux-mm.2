Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD5A2FC9EC4
	for <linux-mm@archiver.kernel.org>; Sat,  7 Mar 2026 01:39:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0758C6B0005; Fri,  6 Mar 2026 20:39:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 023406B0089; Fri,  6 Mar 2026 20:39:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E46E56B008A; Fri,  6 Mar 2026 20:39:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CD2E76B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 20:39:34 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 684A8160731
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 01:39:34 +0000 (UTC)
X-FDA: 84517559868.07.8FA3CDE
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	by imf18.hostedemail.com (Postfix) with ESMTP id 66F1E1C0004
	for <linux-mm@kvack.org>; Sat,  7 Mar 2026 01:39:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=miM9c7hw;
	spf=pass (imf18.hostedemail.com: domain of jiakaipeanut@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=jiakaipeanut@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772847572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WUt9V96pGWBeEnbjx1PAHPx8YoZ8MwGfywkRHa4eCJ8=;
	b=kGxIcIafSbsOpJr3Mxy4poL/Oo9jD1b4p7hNDTMIAbuDRMEZSZiChujK02iA17W9V7PG4e
	OaBFPY0LEDMMMbgRxUVirFGAYN0PWUtqIDTdnYjT1KJQnQ5mJ8mYuXzeiXjGkmKZhyhzwt
	dSGzFxvwjqhLdzzxy6fr4/dlrpNRS/A=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=miM9c7hw;
	spf=pass (imf18.hostedemail.com: domain of jiakaipeanut@gmail.com designates 209.85.161.51 as permitted sender) smtp.mailfrom=jiakaipeanut@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772847572; a=rsa-sha256;
	cv=pass;
	b=HLVY1KFI/1k0SGixp5ufqNK9MXo87gIJ7tLCZ2iaN4cYX8HZet98zum7+VjxDXyvi6KJI4
	zgCc6BRoBNDCOmgokssSqSxFP0WSs7rFHG+9lMRVyUyTXOqkBXbhfLcOdSva27f7vhUkxe
	PGo41sMnXJT+wc6b3h7jJ7tf3XEdT/4=
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-66f3e7d9eccso6308205eaf.1
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 17:39:32 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772847571; cv=none;
        d=google.com; s=arc-20240605;
        b=BtFhpw+68nvn3rJ3QChWV1LhYhZnWn6bq9ljLz+uZwhQEbQPXKVuPIre5BjnNE7/oJ
         jNEKx4tZIdmsvGCyd5vNp7Qr3HL1b2Iiv2xiOK/gBETNWUO7P+GPrhzEnsbW6Jy5tkq6
         WrcTYXtt3eB0aYbo9/4M/7PcHlPqZ6UXEyv7WEQ8jQr+QQRJlw7emD1K82IPVjMU3Fro
         YBg8QMNsWWEqMQxn9+g5CDMKyynH+ef2BPJArMrZ63CJU9/Fewxc8Ybwf6ZaeCnugPii
         wockQ4AxhGliaJQFkO1Fr1GbSzvXUkUiw9PCKdV+oy5mL7B5vS7T4VWXzMFyRCmy8IRB
         kjTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WUt9V96pGWBeEnbjx1PAHPx8YoZ8MwGfywkRHa4eCJ8=;
        fh=x4iAhA8jlzPKEj58IQQH4v5LA/5xHezC/oZPmUgQ+YU=;
        b=VVYlx5uu1hCercBTD1eYLk0cioXJoRUl+bYFkJ/Wf1UI1KKgkxbIM+jQvBVp3vqoCf
         o5qBQF+P/vQRyK2IiFzFLVcoFJb3kn2jEgrOj8iVDrmDkbGJEuge15ZW9Kw4zXQFknVS
         XmQa4loIvbh4fXntiyo0OXQtYikk+Brt8qnNOGMikyZcJXUvAfT8ZswelU972K9oTcPK
         /lBHJAIJYEtH5Erlv9dTr9XExqLQ9G598mtRbopEN2PHc8DlfObtNL/2SaLBasCXqUGr
         ZO5okIx4lkWKzB3rA4McP82kkgLVMXtkRj7yGnDa7s/UgXuQAqMB1pw3CtqG5rQoWVtj
         jhuQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772847571; x=1773452371; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WUt9V96pGWBeEnbjx1PAHPx8YoZ8MwGfywkRHa4eCJ8=;
        b=miM9c7hwvsAkYTJTdBUEzYDPdOkGzDI7thKwkP4XINFvgoNx4+gEVdOe/E5hqBx7LV
         165O4Ltmp0Hd+hCHGnsVWjuVX72/Yl7qRPBWdbqgvYkMGZRQdb29gr4N/58jcnrXEvn6
         CAXLMlNA/vvWKSiYkNlOkyjE9z1i34RmlZhfrbHJhoukWYB+dLRqtc7TXs+ykVOekB0x
         +GViwSEORcQ2Mx5SRSjUnQYn7u0vxHtNsn+bow6IroYZaQWdWZQibbYY/onFq87gDIiA
         KL+pbBYnmZ2gfUWA2HlXmpWfvaLdaxuzMoYT0Sw7o251JBePt+iMnuMsNFKV3KeqRrQj
         E39w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772847571; x=1773452371;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WUt9V96pGWBeEnbjx1PAHPx8YoZ8MwGfywkRHa4eCJ8=;
        b=Ft6oYSpQpTol6jgQ9PcZVSt0Jm+SHaoq1ovSiL6o7YhElND50V+wKDyJJsygc+0rAG
         VJQRatrmfOrr0Wv/pffVWoH1gE+BMibbG6IzMPStrwVaNHxuIds2ruQa+z58K/bUUuMf
         /EL/yA2eLPPPLiuYzUENpa2BpNTWU5k1st4bmeQHSBJUTIJ7uBH4eoiSoemSn4FnzQE7
         aKSZexEBbp0i+FrU1tjUe1j4i05L70igOgMwKJkfWQ9YPG3umxWIbg/+uP9SUwlMld6g
         dCeGTGZ2lWYIsBt3QYeVQdBZfzLhP4UpOJdPZkg+7EiEtlu77uenZ0fxpbbUEWkDNHzi
         nODA==
X-Forwarded-Encrypted: i=1; AJvYcCUYuBxzKxWoBgtb0vQuosGfGf3eVmj9R+ShHvI9kov1sfSR+fnusDvwKRyUKbLqlacMKxkJzZamQg==@kvack.org
X-Gm-Message-State: AOJu0Yx5z0Tc7LveRSzuNOLon0lYNL7xJ70KG4BCL2ZPfl/gWtowTMqn
	/RDTF4nKWUvTQ/Yeos480SLI7xJZn0QBkaCJtOeu6LHf8ETBFArQ6x7/CXhEQ5nwcb7EE1sjD6y
	Z3eUfYgTXD6YBsFayN/eGbcBvUrf2Vb4=
X-Gm-Gg: ATEYQzy0fblCZPB0m7wkTCiA65lPYd2J5XHtbg3G3RHN8zv8uhisKitpTVJA+X5NH3t
	reAHpQ7mYiXhRXMShIUGWveAXymihIfx4RlAOfhBBbvOZBGXDzOgEACdpHvZiFlAyDR56/rwfmJ
	4eM2ixgCa2nIoi9QM2Ve1XLyopbGvmpx6wK3Ama8HPhdFJvL1bjIH6ZabAN+zkuIJ0p9yWnIbfa
	9rU+yt1P1SSl0S3o8FNbwwRcoOyjd2L+JYk7OE/QkT8Hq3zsbMT4NjlZvLNdTmIOwIdZ3OAOWpx
	ym+DaGHu22lLZ5I29rZ+lYDjZtqln+N23Zn93gTLeoXyuGIPAw==
X-Received: by 2002:a05:6820:98e:b0:67a:381:d0bc with SMTP id
 006d021491bc7-67b9bd7fbd0mr2495746eaf.72.1772847571210; Fri, 06 Mar 2026
 17:39:31 -0800 (PST)
MIME-Version: 1.0
References: <20260112192827.25989-4-ethan.w.s.graham@gmail.com>
 <20260306094459.973-1-jiakaiPeanut@gmail.com> <CANgxf6yMNZ3=xm9xVhPZDuxMc__7pQk=mti-CyD1QjUOgTJLEA@mail.gmail.com>
 <CAFb8wJvmnPv96o9Kr9VAh=cL9zMr8-5eCEmmkjtgX02_Ypa4nw@mail.gmail.com> <CANgxf6wjPOoYemsK9EKrFM-eSpOgSUQvZ6kX5JyDTfC5J62Ufg@mail.gmail.com>
In-Reply-To: <CANgxf6wjPOoYemsK9EKrFM-eSpOgSUQvZ6kX5JyDTfC5J62Ufg@mail.gmail.com>
From: Jiakai Xu <jiakaipeanut@gmail.com>
Date: Sat, 7 Mar 2026 09:39:20 +0800
X-Gm-Features: AaiRm50KpdlvXzopHVFRmT8nMLKcn3vW_ZNiGHxd8-Gph5tiqofDNvJc5-PXCCs
Message-ID: <CAFb8wJsyKF3m=WQDkjFSLPeCL1peUA-G1__aByz8vQ-kw3wZ8A@mail.gmail.com>
Subject: Re: Question about "stateless or low-state functions" in KFuzzTest doc
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: akpm@linux-foundation.org, andreyknvl@gmail.com, andy.shevchenko@gmail.com, 
	andy@kernel.org, brauner@kernel.org, brendan.higgins@linux.dev, 
	davem@davemloft.net, davidgow@google.com, dhowells@redhat.com, 
	dvyukov@google.com, ebiggers@kernel.org, elver@google.com, glider@google.com, 
	gregkh@linuxfoundation.org, herbert@gondor.apana.org.au, ignat@cloudflare.com, 
	jack@suse.cz, jannh@google.com, johannes@sipsolutions.net, 
	kasan-dev@googlegroups.com, kees@kernel.org, kunit-dev@googlegroups.com, 
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lukas@wunner.de, mcgrof@kernel.org, rmoar@google.com, 
	shuah@kernel.org, sj@kernel.org, skhan@linuxfoundation.org, 
	tarasmadan@google.com, wentaoz5@illinois.edu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 66F1E1C0004
X-Stat-Signature: qqwjfbe5j7t4dosyhaomtnto1qm9aezk
X-Rspam-User: 
X-HE-Tag: 1772847572-438980
X-HE-Meta: U2FsdGVkX18voXTZfLJIyjrNJ09yXcndua9XHeY3dPwBmw3C8sk0uFyZRhgb2vgjGahzbmzC7wicbdwap3DUO1vjUVFp39yH2st0OySB06T4WQ+qrrbXL4jw2iiybhQsZr/+yMbbEHnSPOysZ8WwyJD+cZOqll2hHeaoFEq/QyNDKs/wT7T8uZ1Dhg5dJ1k+b8Mf1fm4pupx37tC3T6pSHL/HsCK++qp2QzVcpA+qTmv6mufMBWx1kemBfLxs5Wb5RPs8XWR8YxGZwpNghnunBOEutvjqyZ/CT1fH5WT8vV1l6fxATYoJzfdSK34ei4VZRfvwLnfcAiI3ynxUe+FvN5Yic/B2L5ppMweW0kLchWcumbIA6UMXoAv3buJTITJsLD2EyLJ7Ld1CBXxXNnouibKIiJQeoVkMEB6C9BNPtKL+pLeHIkoMlCezVmOzAWAl3kNKQGk05mOQQ568Dmzfx+J3SYhsfdAYKUe2PTaAbBdJt/ywmMxzJAllHvu7lmZgwboF7v8NssU13druML6SZ7uXuAQcCLM4YcUfORxL66r0NJPHHwBISuG63oAzuQVVzzQUtwG1fr1Xh4MLOFfmrA4Ewro/gne0LNd8aUXL2YNmbgXZADZWJcYCmd4v6vLOQn5AcAIfeAufouDgPFt8gYN9E85QTFchQ4u63bFxi2/CeGq+KXakpx5pib1FSCFD9WbuZRQHyIRYFoZ4s99OQ9O++1F/SWl6GQEnPn4ns3Uo88JM5aOwyJORz9lywEO1IYu93R5oadfRp/eq36CB75wTEl6wgz8A4owLe3LLcx8hyJzocHzL36oVCnGPrtVxz4nHOP85B26BUg2kXPNxlAPICrJ2GmsS7mvSvfnTJQbheTozDfm9Xof+BrvnZU83fSyKfRUckWlRa4sVS6r4DRyvGweTkBT331xrmS3+2lLBnav2UHv5+MVsNMjMGwwg4sOSkmA9vYkemDD21j
 vDszBWcd
 4dI9JTEIFqxklXr2ldlka8Or6dbcwQ12hnbfA6qiicji6D0jQhy/SAG5w++oqVa3KT3x4aEdxOkQOOrSL/dpBsE65rl15PnaGU7gWAQ8G0SWOpwqq+Ys1oge43DyJNgSiN2nqyfBlO9V/KWpQzJmYVeQJqVQygreVu/f907NaT4TTd7WYhBWly8srCWEurCJ4FEYPpYIs4PoJQt9BD8FXQQMpvbmkDCxjXXJ8Mrej6PkdAKzWgEHIIm8oro+/NzlUi6CRrlrWIw9yXDL2pHwfRyNkJn4pl7++7kKPo1y8EjQ0RLZznG9qcLwT076VKq/OUIlhAzc+jQyUlnilEkcXxLTBJC/MSgO1Jy1rmYI1meS0cPDOYGBqK0k4Y/GRAEIxV4ggzikybUy+USk8O039t5vMFOJyhYKkut6P/F8dYO6nn2kJkGzFgVr+8cFTQYA2VLj/VsQcJgSclYGwpMExslNanDfwcHnrEBESjBOaNy1OnP8aj2oYG52uKqWv4vv15YvM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Ethan,

Thanks so much for the patient and detailed explanation. Your clarification
has resolved the questions I had, and I now have a much better understandin=
g
of KFuzzTest's design philosophy and approach.

I'm very interested in the design and implementation of KFuzzTest. Thanks
again for the explanation and for proposing KFuzzTest.

Best regards,
Jiakai

On Sat, Mar 7, 2026 at 12:53=E2=80=AFAM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> On Fri, Mar 6, 2026 at 12:04=E2=80=AFPM Jiakai Xu <jiakaipeanut@gmail.com=
> wrote:
> >
> > Hi Ethan,
>
> Hi Jiakai,
>
> > Thanks for the detailed explanation.
> >
> > Would it be fair to say that KFuzzTest is not well suited for testing
> > kernel functions that are heavily influenced by or have a significant
> > impact on kernel state?
>
> With the current fuzzer support (see the PR in the syzkaller repo [1])
> this is a fair assessment, but with a caveat.
>
> It really depends on how you are fuzzing. KFuzzTest itself is just the
> conduit. Whether or not your fuzzer can meaningfully reproduce
> bugs/crashes related to complex state is somewhat out of KFuzzTest's
> hands. However as of v4 the framework only supports blob-based
> fuzzing, I would advise against targeting heavily stateful functions righ=
t
> now. You are welcome to experiment to see if there is a way to meaningful=
ly
> fuzz more stateful functions, but with just binary buffers as inputs, I d=
on't
> reckon that there will be too many candidates.
>
> > I agree with your point that "the goal of the framework is to fuzz real
> > functions with realistic inputs." One thing I've been thinking about,
> > though, is how we determine what counts as "realistic" input for a give=
n
> > function. If the generated inputs that a function would never actually
> > receive in practice, we'd likely end up chasing false-positive crashes
> > that don't represent real bugs.
>
> I would argue that just because an input isn't "realistic" in the current
> kernel context (i.e., the current upstream code only calls into the libra=
ry
> after performing sanity checks and/or validation) doesn't mean that a
> crash isn't problematic.
>
> Code can and does get reused and refactored over time. If an internal
> parser can cause a panic or OOB access when handed certain inputs,
> it is inherently fragile. Even if that code path is shielded today, it co=
uld
> be exposed by a new caller tomorrow. Our baseline assumption here is
> that if a function accepts a blob as input, it should be resilient to all=
 types
> of blobs.
>
> However your concerns about false positives is justified, and something
> that we have thought about. In previous iterations of this work, we relie=
d
> on a constraints system for encoding input semantics and performing
> validation inside the fuzz harness. While we stepped back from that due
> to its inherent complexity, instead favoring a more simple blob-only desi=
gn,
> adding constraints to better define "realistic" inputs is a good idea tha=
t may
> need to be revisited in the future.
>
> Hope this helps clarify the design philosphy!
>
> [1] related syzkaller PR for KFuzzTest:
> https://github.com/google/syzkaller/pull/6280
>
> > Thanks,
> > Jiakai
> >
> >
> > On Fri, Mar 6, 2026 at 6:29=E2=80=AFPM Ethan Graham <ethan.w.s.graham@g=
mail.com> wrote:
> > >
> > > On Fri, Mar 6, 2026 at 10:45=E2=80=AFAM Jiakai Xu <jiakaipeanut@gmail=
.com> wrote:
> > > >
> > > > Hi Ethan and all,
> > >
> > > Hi Jiakai
> > >
> > > > I've been reading the KFuzzTest documentation patch (v4 3/6) with g=
reat
> > > > interest. I have some questions about the scope and applicability o=
f this
> > > > framework that I'd like to discuss with the community.
> > > >
> > > > The documentation states:
> > > > > It is intended for testing stateless or low-state functions that =
are
> > > > > difficult to reach from the system call interface, such as routin=
es
> > > > > involved in file format parsing or complex data transformations.
> > > >
> > > > I'm trying to better understand what qualifies as a "stateless or
> > > > low-state function" in the kernel context. How do we define or iden=
tify
> > > > whether a kernel function is stateless or low-state?
> > > >
> > > > Also, I'm curious - what proportion of kernel functions would we
> > > > estimate falls into this category?
> > >
> > > I would define it based on "practical heuristics". A function is prob=
ably a
> > > good candidate for KFuzzTest if it fits these loose criteria:
> > >
> > > - Minimal setup: KFuzzTest currently supports blob-based fuzzing, so =
the
> > >   function should consume raw data (or a thin wrapper struct) and not
> > >   require a complex web of pre-initialized objects or deep call-chain
> > >   prerequisites.
> > > - Manageable teardown: if the function allocates memory or creates
> > >   objects, the fuzzing harness must be able to cleanly free or revert
> > >   that state before the next iteration. An example of this can be fou=
nd
> > >   in the pkcs7 example in patch 5/6 [1].
> > > - Non-destructive global impact: it's okay if the function touches gl=
obal
> > >   state in minor ways (e.g., writing to the OID registry logs as is d=
one
> > >   by the crypto/ functions that are fuzzed by the harnesses in patch =
5/6),
> > >   but what matters is that the kernel isn't left in a broken state be=
fore the
> > >   next fuzzing iteration, meaning no leaked global locks, no corrupte=
d
> > >   shared data structures, and no deadlocks.
> > >
> > > These loose criteria are just suggestions, as you can technically fuz=
z
> > > anything that you want to - KFuzzTest won't stop you. The danger is
> > > that the kernel isn't designed to have raw userspace inputs shoved
> > > into deep stateful functions out of nowhere. If a harness or function
> > > relies on complex ad-hoc state management or strict preconditions,
> > > fuzzing it out of context will likely just result in false positives,=
 panics,
> > > and ultimately bogus harnesses.
> > >
> > > The goal of the framework is to fuzz real functions with realistic in=
puts
> > > without accidentally breaking other parts of the kernel that the func=
tion
> > > wasn't meant to touch. Therefore ideal targets (like the PKCS7 exampl=
e)
> > > are ones with minimal setup (just passing a blob), have manageable
> > > teardown (like freeing a returned object on success) and don't
> > > destructively impact global state (even if they do minor things like
> > > printing to logs).
> > >
> > > That said, I'm curious to see what you come up with! I'm sure there a=
re
> > > other use cases that I haven't thought of.
> > >
> > > [1] PKCS7 message parser fuzzing harness:
> > > https://lore.kernel.org/all/20260112192827.25989-6-ethan.w.s.graham@g=
mail.com/

