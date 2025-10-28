Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 490D8CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 17:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9090880197; Tue, 28 Oct 2025 13:39:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DFD38013F; Tue, 28 Oct 2025 13:39:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F5B180197; Tue, 28 Oct 2025 13:39:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 67E678013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:39:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18B5FC03A1
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:39:25 +0000 (UTC)
X-FDA: 84048234690.08.30D05CD
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2E34C1A0013
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 17:39:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xNSvccYw;
	spf=pass (imf19.hostedemail.com: domain of glider@google.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761673163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e5GKgH/UTKYoqeaateNe5qxhNdabeLnlG8oSSdUoad4=;
	b=ltNZCGxnW2MJqDdYc6W1LpAH1+VIKPyx2T9W0QzoWFD2z+2YeIhtZ2ShNPFDUzGis79RF4
	EGCTffY5oncBHjGwgs+y8MMyhbj6iXbh6rrtGTDWjdWsji+QV2kq7mxCk63F94ou+/RStB
	/9tB3lUgpMsDRlzFNwYCNmFdt3S3kf0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761673163; a=rsa-sha256;
	cv=none;
	b=SN2/AWlLL12MdKkpOaDzTs2LPEc6oZ3UIT3vfgbIFT7JQBSkbKh052UJrK+1kq7VgPGWm6
	w5eGTekcb/CZT3pp2moCyP32woC5glrDZQ0AQqGD4U746yFbwlkqyr6AzaKLnRl2AfHaGw
	+OcaFw4UIbJS3HYN0lAVKEIp2ujszBU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xNSvccYw;
	spf=pass (imf19.hostedemail.com: domain of glider@google.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-87c167c0389so70251936d6.3
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761673162; x=1762277962; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e5GKgH/UTKYoqeaateNe5qxhNdabeLnlG8oSSdUoad4=;
        b=xNSvccYwnoWI+n4CbHhh+38kpuRT5PH+LEbmHhrd99vSw3IBh0LxlCQht6hosfbC1c
         VBoHVDTMddqsL2ckETBkATrz3tOk5o3jPFmuGhQfzfVeBTNxh4MErmxuTaKThw1aPzuq
         uQCH1ml+R3nzHHy5ypH0Mqiy468OIRB41nHvaTxFJrlsUMrs+cQ5KUXMqTnNhTvTB26I
         7gsPwTDe1ZCuU/dhEYLNgUjZxJdIH9z113vMXMpkUks+Hl2zjY0iq5uJ/ip+150Wspj0
         IsXil1EuLFEhfh/q3rElmsELKb/ZZS/rejPIs6oTLPv6TikIRjVhfoicrfCSn8xofMms
         gDJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761673162; x=1762277962;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=e5GKgH/UTKYoqeaateNe5qxhNdabeLnlG8oSSdUoad4=;
        b=Ex9yczkAJbHVTVaL9QbjFUkKsKOWfFsAYLOgATloOD8afUFaFDPhCLXpWVgq/okt/z
         dqBte3Pu3pW4gCQU2cefKm3sRHWmjcBq77SFb46oqiW4lnhNftfPs22PR7fVKHwC11AR
         qh3zQoCJmYmo3q/m7U5SmV5o7upt7LxFrcrsm63yrjZv3KB9C1S/rkDxyHCX2FK6nJUd
         RdYq2IFxxqByxw2qM6KgStNRQUX3Lx6iLRAbrlcmx4m8tGR/msfjUuGJzHE5/DnAM703
         goWaPsslFk4nkmXA3C+xCV946ZjrPd9WBPnB6Nz7RAndyJvyv8/GGuA9vA/D6ynPPosY
         fLbw==
X-Forwarded-Encrypted: i=1; AJvYcCUnogH5U4NvkeT+PSna5PFKC8zJl5y8cqCUcLIBEFO16GhuSXcimxdbNKfPHaemBYn3bk4B7yKppw==@kvack.org
X-Gm-Message-State: AOJu0Yx8cBgGBvtm1oeN2xDMy/7WAr3SMRVBr6xuy9CIFAJyuZ85Ial3
	evwuBSF2ztK2mbHsC3jA+8K6opVvB52RAleVOHMan24QCvtLCoBxWinAQ7Is03+U9H4gEdxVur7
	+GKVszGZF/hHMvCK3UW1txllDH970Ju76nfREsrjp
X-Gm-Gg: ASbGncuxR6ZU37ppoOoAT7im/4xAI5AWUZ4r7yWFF5zvPIa/2U4DanQ6+H1xyqneG9p
	T3Vjy/JKLfu9G9ZIzU1EFwRXh+2ucCzaZ1+AyUPVuEdxkf1xXn5+EYUIc2fLcnbS7Zse4if2KOd
	JN/ElauCKkVmLVkIriyWiGc+vCABlPD5g7VDPKi4pmShRnd7W8UvOhQEXScd/UxIJ5U0Dt5hneq
	m4XKpvTjKT1XR+1Ms87muUpNNLSx3bZjkOJtuqBtcOFxx3EK8ST/ujZqdBmDZqYHvCK8bYGcyiY
	1bh7KUGlNPIPyk8/fCExiuvZyQ==
X-Google-Smtp-Source: AGHT+IEzLhRvjAVm4Cta7u3gqBbuXxGfYAu/L56wiWh0qQYwqjYD99avpLnvK5jAgeVXmSt4Qiq0dgGWWZjR3bNU3C4=
X-Received: by 2002:a05:6214:40d:b0:87c:2b29:2613 with SMTP id
 6a1803df08f44-87ffb13ae3fmr67954756d6.50.1761673161744; Tue, 28 Oct 2025
 10:39:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250919145750.3448393-1-ethan.w.s.graham@gmail.com>
 <3562eeeb276dc9cc5f3b238a3f597baebfa56bad.camel@sipsolutions.net>
 <CANgxf6xOJgP6254S8EgSdiivrfE-aJDEQbDdXzWi7K4BCTdrXg@mail.gmail.com> <438ff89e22a815c81406c3c8761a951b0c7e6916.camel@sipsolutions.net>
In-Reply-To: <438ff89e22a815c81406c3c8761a951b0c7e6916.camel@sipsolutions.net>
From: Alexander Potapenko <glider@google.com>
Date: Tue, 28 Oct 2025 18:38:43 +0100
X-Gm-Features: AWmQ_bnW72aQYooWWGflqdYTwRU7KZczsY8iNyINpHaHoghSdwZyWmyrA5jTR-Q
Message-ID: <CAG_fn=XSUw=4tVpKE7Q+R2qsBzbA5+_XC1xH=goxAUZiRD7iyQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/10] KFuzzTest: a new kernel fuzzing framework
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Ethan Graham <ethan.w.s.graham@gmail.com>, ethangraham@google.com, 
	andreyknvl@gmail.com, andy@kernel.org, brauner@kernel.org, 
	brendan.higgins@linux.dev, davem@davemloft.net, davidgow@google.com, 
	dhowells@redhat.com, dvyukov@google.com, elver@google.com, 
	herbert@gondor.apana.org.au, ignat@cloudflare.com, jack@suse.cz, 
	jannh@google.com, kasan-dev@googlegroups.com, kees@kernel.org, 
	kunit-dev@googlegroups.com, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, lukas@wunner.de, 
	rmoar@google.com, shuah@kernel.org, sj@kernel.org, tarasmadan@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: 14o4qibmsn6dnyffffo86zko1mak3of1
X-Rspam-User: 
X-Rspamd-Queue-Id: 2E34C1A0013
X-HE-Tag: 1761673163-671229
X-HE-Meta: U2FsdGVkX19zW8sF5/AL/s/Oyy2Ha6+JDV1hNvYBJ4Pwy0JWO78oyipciyC5vHvtlnQBJW23cEaDrS3+Q7982xty/k17dRCema7RTpXkHrCj7QIpd2fOrvsxZjjuxu+4vKD5+J4dHRQdG7qf2M6i+lO0heAXGKQpSleqqXeb5PFZkIaFe3z6MegENQ/ilgp0n3nkSCb9j3+P+mASEuwxEF293XE/wNQX1hsVzyzhaOJBbrN/+q4ZdXMLVBDws9/bb78drmv26NC6fhEvx8NppGyJQ+tEbjWzIs9nSNDwbIvw2YHfaoXIS88syqG2nKKNpo8dXhXLCEsjaxM83ZldS3oBW1TqoHZYgwlrsaS9pwR2Ofno8SRI/ywLwGTgQPTQYvYULxg2roIGdSn937tjBZYui2gvFXOJ3xU60KhsiaaMZg8zemY1Jcrxo1hRrjjJxSlI3JAgdYGPgiyfiQKZZ6hFqa+g9df1PIsq4tzU+e2HwKgnGHuDA69FUy0Qoofj400UzEWbhR73Z++BjsLn25+jL/F8526E8ecdGQ3DK2HVctrFO97HDOZTwcIXVYfjxg+XpzXzgSCYqNE/uzMKDsKdwvGJhzLj1uC9U9/JmNSwDX0vvWMhNJv02ZlK619VptzFMEWg5lMQQydixBiW5sigELEPQh5l3lZ8fWFlKtb435cd7tskJPU6sSWr/iPL2famWd23T6tdojgbbcZoEP/5FUu+vxyjMqTBboTyPv8/DHsZOh5kOiL2L8rqZnFRZCl1N0lxT7WUBFjJi7ATYwNbUinxDRFIq4GRyJmQrVdAo974zrnayjZm59GM/wSkVW9GibeNmFjueJrNDjqpdkaQjWV0Be2VwaCDZak6iZmTVfDMjJHLYqCQ8ip29SvFbgh1fxVy9dy3e4DegUdW14SPAlU+2EwlywFNDSlw1YHyrIr17TZYjxvMYJsTd3M5UFBVzLP++DU6OP260/5
 PfjTRnmU
 KsuiNTFGddLYkLfPprt0UcENJEOdcIe5eRFctgINCaTQCDUhpqeqPY5kBA4pzSc5IpR2Y90jleC6piMquxhfj1hES9dD0xYf2osKOPUozxBFAzbB404Lqh5C91xa3YYP0Zkhzf22OYaoyX1MoO30l3NeWwxgW51l5iuUsbKnNNmEWhYPLwdX2LfUQtj5OsU9R8IrD6GMrrLDOUMrPCe0RZ1GIFiLCayeItzi8pIsmB+BMCGtnzS+eYJpXhpwH4CEDA0mYYzYZzNA68ybdlK5m5iJvlqACLQK21SRiei4WMox2VOgLTBjXH+rRoWAYvDEPJaUYrEa+hP7DksqR85gBffoi1A6Ep/K2ExDujjDtjAIQwZfHnq6n3UJ9UI44YwazkuSAAGLEMBAGLH9f/zih9ukuhyQco04Dmedo2eNiZw/pBBZ+6e+Bn5wOE1uOaI5UguHXurpJF9/yR600+iGue1XhNbXE76+RsLvl+MAGIdusW55f6E1STLR45mfB5bSKcuXTw89yeCRiY/Ul8WAmfriUjy0ooGDoZxq20GHufJ1+KeM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 10:38=E2=80=AFAM Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> Hi Ethan, all,


Hi Johannes,

> > I would argue that it only depends on syzkaller because it is currently
> > the only fuzzer that implements support for KFuzzTest. The communicatio=
n
> > interface itself is agnostic.
>
> Yeah I can see how you could argue that. However, syzkaller is also
> effectively the only fuzzer now that supports what you later call "smart
> input generation", and adding it to any other fuzzer is really not
> straight-forward, at least to me. No other fuzzer seems to really have
> felt a need to have this, and there are ... dozens?

Structure-aware fuzzing is not unique to syzkaller, nor are domain
constraints for certain values.
https://github.com/google/fuzztest is one example of a fuzzer that
supports both.
libFuzzer also supports custom mutators
(https://github.com/google/fuzzing/blob/master/docs/structure-aware-fuzzing=
.md)

> > Since a KFuzzTest target is
> > invoked when you write encoded data into its debugfs input file, any
> > fuzzer that is able to do this is able to fuzz it - this is what syzkal=
ler
> > does. The bridge tool was added to provide an out-of-the-box tool
> > for fuzzing KFuzzTest targets with arbitrary data that doesn't depend
> > on syzkaller at all.
>
> Yes, I understand, I guess it just feels a bit like a fig-leaf to me to
> paper over "you need syzkaller" because there's no way to really
> (efficiently) use it for fuzzing.

When designing KFuzzTest, we anticipated two potential user scenarios:
1. The code author develops the fuzz test and runs it locally to
ensure its sanity and catch obvious errors.
2. The fuzz test lands upstream and syzkaller runs it continuously.

Ethan initially developed tools for both scenarios on the syzkaller
side, prioritizing simplicity of use over the diversity of potential
non-default fuzzing engines.
However, because smoke testing does not require a syzkaller
dependency, he added the bridge utility (I believe David Gow suggested
it).
That utility is easy to use for smoke testing, as it requires only a
one-line structure description.
I understand it may not be suitable for users who want to extensively
fuzz a particular test on their own machine without involving
syzkaller.

I agree we can do a better job by implementing some of the following option=
s:
1. For tests without nested structures, or for tests that request it
explicitly, allow a simpler input format via a separate debugfs file.
2. Export the constraints/annotations via debugfs in a string format
so that fuzzers do not need vmlinux access to obtain them.
3. Export the fuzz test input structure as a string. (We've looked
into this and deemed it infeasible because test inputs may reference C
structures, and we don't have a reflection mechanism that would allow
us to dump the contents of existing structs).


> > This is exactly right. It's not used by syzkaller, but this is how it's
> > intended to work when it's used as a standalone tool, or for bridging
> > between KFuzzTest targets and an arbitrary fuzzer that doesn't
> > implement the required encoding logic.
>
> Yeah I guess, but that still requires hand-coding the descriptions (or
> writing a separate parser), and notably doesn't work with a sort of in-
> process fuzzing I was envisioning for ARCH=3Dum. Which ought to be much
> faster, and even combinable with fork() as I alluded to in earlier
> emails.

Can you describe the interface between the fuzz test and the fuzzing
engine that you have in mind?
For ARCH=3Dum, if you don't need structure awareness, I think the
easiest solution would be to make FUZZ_TEST wrap the code into
something akin to LLVMFuzzerTestOneInput()
(https://llvm.org/docs/LibFuzzer.html) that would directly pass random
data into the function under test. The debugfs interface is probably
excessive in this case.

But let's say we want to run in-kernel fuzzing with e.g. AFL++ - will
a simplified debugfs interface solve the problem?
What special cases can we omit to simplify the interface?

> I mean, yeah, I guess but ... Is there a fuzzer that is able generate
> such input? I haven't seen one. And running the bridge tool separately
> is going to be rather expensive (vs. in-process like I'm thinking
> about), and some form of data extraction is needed to make this scale at
> all.
>
> Sure, I can do it all manually for a single test, but is it really a
> good idea that syzkaller is the only thing that could possibly run this
> at scale?

Adding more fuzzing engines will not automatically allow us to run
this at scale.
For that, we'll need a continuous fuzzing system to manage the kernels
and corpora, report bugs, find reproducers, and bisect the causes.
I don't think building one for another fuzzing engine will be worth it.
That said, we can help developers better fuzz their code during local
runs by not always requiring the serialization format.

> > You're right that the provided examples don't leverage the feature of
> > being able to pass more complex nested data into the kernel. Perhaps
> > for a future iteration, it might be worth adding a target for a functio=
n
> > that takes more complex input. What do you think?
>
> Well, I guess my thought is that there isn't actually going to be a good
> example that really _requires_ all this flexibility. We're going to want
> to test (mostly?) functions that consume untrusted data, but untrusted
> data tends to come in the form of a linear blob, via the network, from a
> file, from userspace, etc. Pretty much only the syscall boundary has
> highly structured untrusted data, but syzkaller already fuzzes that and
> we're not likely to write special kfuzztests for syscalls?

We are not limited to fuzzing parsers of untrusted data. The idea
behind KFuzzTest is to validate that a piece of code can cope with any
input satisfying the constraints.
We could just as well fuzz a sorting algorithm or the bitops.
E.g. Will Deacon had the idea of fuzzing a hypervisor, which
potentially has many parameters, not all of which are necessarily
blobs.

> > I'm not sure how much of the kernel complexity really could be reduced
> > if we decided to support only simpler inputs (e.g., linear buffers).
> > It would certainly simplify the fuzzer implementation, but the kernel
> > code would likely be similar if not the same.
>
> Well, you wouldn't need the whole custom serialization format and
> deserialization code for a start, nor the linker changes around
> KFUZZTEST_TABLE since run-time discovery would likely be sufficient,
> though of course those are trivial. And the deserialization is almost
> half of the overall infrastructure code?

We could indeed organize the code so that simpler test cases (e.g. the
examples provided in this series) do not require the custom
serialization format.
I am still not convinced the whole serialization idea is useless, but
perhaps having a simplified version will unblock more users.

>
> Anyway, I don't really know what to do. Maybe this has even landed by
> now ;-) I certainly would've preferred something that was easier to use
> with other fuzzers and in-process fuzzing in ARCH=3Dum, but then that'd
> now mean I need to plug it in at a completely different level, or write
> a DWARF parser and serializer if I don't want to have to hand-code each
> target.
>
> I really do want to do fuzz testing on wifi, but with kfuzztest it
> basically means I rely on syzbot to actually run it or have to run
> syzkaller myself, rather than being able to integrate it with other
> fuzzers say in ARCH=3Dum. Personally, I think it'd be worthwhile to have
> that, but I don't see how to integrate it well with this infrastructure.

Can you please share some potential entry points you have in mind?
Understanding which functions you want to fuzz will help us simplify the fo=
rmat.

Thank you for your input!

> Also, more generally, it seems unlikely that _anyone_ would ever do
> this, and then it's basically only syzbot that will ever run it.
>
> johannes
>
> --
> You received this message because you are subscribed to the Google Groups=
 "kasan-dev" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to kasan-dev+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/kasan-dev=
/438ff89e22a815c81406c3c8761a951b0c7e6916.camel%40sipsolutions.net.



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Liana Sebastian
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg

