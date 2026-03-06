Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DFECFCB624
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 16:53:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E8E766B00AA; Fri,  6 Mar 2026 11:53:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58E66B00AD; Fri,  6 Mar 2026 11:53:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D85B36B00AE; Fri,  6 Mar 2026 11:53:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C10F76B00AA
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:53:51 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A1F9BA581
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:53:51 +0000 (UTC)
X-FDA: 84516235062.14.B6D262F
Received: from mail-dl1-f44.google.com (mail-dl1-f44.google.com [74.125.82.44])
	by imf29.hostedemail.com (Postfix) with ESMTP id 719ED120010
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 16:53:49 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VOuVYjXz;
	spf=pass (imf29.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772816029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d55lq5uPJ8gGFWTrhAL2DxmhHj1adF25qQQ5iMiqqsE=;
	b=otlmfJJB6ZM0ttnpUJoJz7LbUQta4CKVH4fuNvaaS34itPRgt9l4fCpB9P8f+kfza62m73
	ZE93CqrqfiE5+szFarDFoYWPrmsqKULZ0Z7sPmBehaR3c+thW520ZZGI8m3/D4zblGjhp/
	l2ZpYsF4yEW0ExXrWvq6OrLu4PfI7a0=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VOuVYjXz;
	spf=pass (imf29.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 74.125.82.44 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772816029; a=rsa-sha256;
	cv=pass;
	b=mLY5DcUtvlu5r//HIBDNpbSuoCFjlljU44Mctw0iJwuYIiD0RvG7ZP5LJuF/6fbmtVk+kr
	0j86vyi85nQxlEngvu4ofB0cElOzF2reXePcnRQgz7qbnfhUi5zHyNs9opN9QQ82MQ+rzz
	7mYa3JfGdQ4Vjcge2yuarM8uNKn2LDw=
Received: by mail-dl1-f44.google.com with SMTP id a92af1059eb24-126ea4b77adso12219686c88.1
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 08:53:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772816028; cv=none;
        d=google.com; s=arc-20240605;
        b=kXtuF8aPmxZuhAkjDxTxQjjKBgn7R55weY4Au6rBUFcSxuzZVhKCVT29KrvxRI1fW5
         MxeKLvqIPaQfCQlNJ3o6IDBjkFXnovhPSMlqtjbFCJN66TQG+oF+M85PenEbE+so5/bt
         5trF9hY7oeeXcJ7N0OqFbvgIkgsPwN/crvPeSIXV3sRdYP0IeAsBYSPF676LkyGTpfx1
         /febZEGGQ8BTqPKkQBbJw0NxRzVuCDn9gwduN7QuY6G3I08ovt1XWOWQZX/rRXVXIppN
         UOQyhWscPnQjGgkqFSoDMJzknknFRr4a2bU1faJEMWETBtI2deS1CActHYlEsrn2cBk0
         HM+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=d55lq5uPJ8gGFWTrhAL2DxmhHj1adF25qQQ5iMiqqsE=;
        fh=w+LuE5LyM0E/8KrPSZ3SWO/52U9KcE6ms01uaTeEXzw=;
        b=bdDC1QVTOXFwJGyZBYVil2zDIywoHQDGMeWkkqeTAOjMhyDRblFPGrk6Yhg+Pldjoa
         olO++r7h9USk7qGvmINtPyGXvSaqQGS8muP76U0VMwJ8Jn+DYYfWTDjL7Fb+zT1FZczq
         bXTieZyMst6aN+N0M859C+SCxA9iqd9t0FMwGdz97/OnbxhhXLNv8t7RiuVxYcDPn92N
         PirjaC6hZcyWpHGU4wvCVtvOdc9PZWWYBnhYzViRH+QqqK7zPoe8D1FUptpOznFPTG9m
         nRjh/7h05yQRK0LZnetTCTXvOpBpRqjK8cOuI5oerirCP0JSSgAY7nNWkc2F+jvgqTai
         TReA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772816028; x=1773420828; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d55lq5uPJ8gGFWTrhAL2DxmhHj1adF25qQQ5iMiqqsE=;
        b=VOuVYjXzYGSJCoGq4duyi284FPMsY7gc+xnrfGOoo/AbSkNO+DAjsop5cWfGGq5/Hj
         JWNDLQ38kusj5e2aMcJEq5Fvok3sssfLGiJljYpEFlwoZ7OzMkhjWrCBBegp3csA9VcV
         5sc8X6uCVXfqBCfEL1zmZq1ltfaL+WMG2Zb/HrNwIahDE3MGK07vHBpdMOR7aK021qSl
         Q8qJYdFG5AO1NgkqMbMBb5JPBRDd3dqnReK0TvXLs+63kGq8RXSSD/vHu10HP4AQCKXA
         e9aiaGxj16NPRPooAW0jdXVuzMzWccrvKixBaMT9phTveoy4NMeVGj7CIMc1wxxEAzdD
         V9NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772816028; x=1773420828;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=d55lq5uPJ8gGFWTrhAL2DxmhHj1adF25qQQ5iMiqqsE=;
        b=CQ9w++jpWoywe3YrDtwkVGSK1mVXaOjAvCoNJPTe+VLVRQ85+aZu9x451q/J1MS67D
         G4ERHG5/CmaPit2nRg66QxwNM4knb6t6LjvIWir8h+y1uQQ7DkDrsDe1KB4wJL8PeUdF
         Bux3a0BJUaq45mavdTc3XVhCqVhMeEEemsrIsvC8K2yQqTbvrEtVxsrBG/HaLZd8QpBn
         0bTj4pMB+YVrT9AYjuM7gVFy2H93cwLdfW99yYOeYnV0QY5L5/9R6CYgFh1sYHvI7s2C
         UwgjNrPmBSeFgPaAg1Gnr2u6FpiPTXPSRZ5a452GAWymllQD4OqFxosjy3dZEtVHp12L
         zJhw==
X-Forwarded-Encrypted: i=1; AJvYcCUVoUvfKautd5k0bhRfONuozkYM8AjBMJSV9Tbv/afIf5RRhIQp2wBkvrPhPsSqkUtUlWaSt53rFw==@kvack.org
X-Gm-Message-State: AOJu0YybUD0A78Yd4vOcj4oHWsJ+q9SadwGw12Mc3TzVkef0zN7+47Dk
	3uFVhiE0sHyw9S3Kt3DrFB36Sw06sm9opby+YlevosG8Xra4sXNM9ITZhv1n1mnRbMbGMBSuKC2
	16WZMpQqQZ5gn3QpANMqg8KfnTJBtkfM=
X-Gm-Gg: ATEYQzwS/p6nRHNU6TF6hvlbfr9PCHvy8w/OC2xqfmdaTvOGGAKrgEpJqz3yaFiYgZk
	3+1YCmn3om2tkXG3Mwmj2bux+OJByqa+zkNlnJitDJwi/aMwMqNg5UgZFqX/0efUMQubpj/I39R
	FPFnqxa1/SmQHPmku7lyEXBq0t05vhjyyrJ3KnXNFl2IzQlqPqH2APVCbDAXVJVwFzlAGCJnFOh
	8TelyDKO65FM4meoszS95PEf2FBjsfydHXAcIt62K6090DZ1EK/nx611qW9kRVJgU0Bfi4fVqTt
	/IzQbudztR0175DFW87bKF9/b0c=
X-Received: by 2002:a05:7022:2381:b0:123:330b:3b5 with SMTP id
 a92af1059eb24-128c2e8cce8mr927019c88.30.1772816027931; Fri, 06 Mar 2026
 08:53:47 -0800 (PST)
MIME-Version: 1.0
References: <20260112192827.25989-4-ethan.w.s.graham@gmail.com>
 <20260306094459.973-1-jiakaiPeanut@gmail.com> <CANgxf6yMNZ3=xm9xVhPZDuxMc__7pQk=mti-CyD1QjUOgTJLEA@mail.gmail.com>
 <CAFb8wJvmnPv96o9Kr9VAh=cL9zMr8-5eCEmmkjtgX02_Ypa4nw@mail.gmail.com>
In-Reply-To: <CAFb8wJvmnPv96o9Kr9VAh=cL9zMr8-5eCEmmkjtgX02_Ypa4nw@mail.gmail.com>
From: Ethan Graham <ethan.w.s.graham@gmail.com>
Date: Fri, 6 Mar 2026 17:53:36 +0100
X-Gm-Features: AaiRm520AP3BKAgH-rViiwWeXF81JB5TY519npbH34QQ3iWXw2jRnyHpyWWp2eg
Message-ID: <CANgxf6wjPOoYemsK9EKrFM-eSpOgSUQvZ6kX5JyDTfC5J62Ufg@mail.gmail.com>
Subject: Re: Question about "stateless or low-state functions" in KFuzzTest doc
To: Jiakai Xu <jiakaipeanut@gmail.com>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 719ED120010
X-Rspamd-Server: rspam08
X-Stat-Signature: qz3su741hsbudrnygurtcqpjfweqqwam
X-HE-Tag: 1772816029-498960
X-HE-Meta: U2FsdGVkX18aWO2rH8dT6TO5+n3imJlNfXYuajl5l9M/dHGI4TuM1bHZTns2t3voE+W4BdSYL5Bz12UoBKGR3CXTvZdKZE5itcUmJtvunVSgR5qcrDmE6uEEY0gj67G94U/VfoMxLrXEwBRvN9Cug5kWQdytyKk3ZrucWbo4hbdSZ+V0YNduPZxS5Kv0v34EUgfjJvQrYclwKzk5lSnH4+WSM1EBg0uxvQp1V4kO3SabViu4vtJmQucAUJaPNqN/h594RbodwwRaRm8mZ3iDxG1EERxA6GJF1eINsaoBc7JnLNBdG9rxYsm0ndfhs1zQsvPsDQi/vDrNwSj4c4Tyjx21XdaEHravjtwc/ypoW+rqVZCPfjAqNQ39VDScBrYGdKF33p27GzlFKlPwxnfNTxK59ei05PwrCGdwL9YUte9uIYNi+O9dOmXqtVKCVpWU/f5QM9bNbDKlDXF3oRF4pFLb0t9EuqJp8Tg5iAnM8Lj118hwXvR61/oaAtKq76QjAMzgd1gkjyk5Sg/cw4BUFjP1FAmnvd2RpowiKKqOYHy55AfNmWo/YuFcY1yCusfjrkZ6MkCXzfXbWXFdugosZkpI2cxpkWgx6sLJNQqoSYbaquWpAmriAWlqmiuH0heagoH8q2/a/3T1jOIdL2N58rXlloGKo/bN5yfn0nXQGNgGdfwn8YXkMAqBJDu1pxvh2+J3o8QE0T8xLCgPAueChi4jU3xAsHBqp7Pa8QUKs2XELfyAIUo9HwzWu9IV2bn/G/Oz+gCXm/6KEg2qP3GaFkEIxl3943vz4ua2XGFF8SygUfTzc9Z/HMmFBs+kY0tXfqtEnTO+tZynB0mX44pk62rfw5vFOvFVLz9HPrfbcJlgWxgUFiSlrEnZ7kGJoG7ABv+CDNSYgEBWn16hChpcnUo8zxpjRSmPc2STF+xcHbDPw/80EmQqSUhQBkHs/113RCTSooaQOfhHQNZ4YeF
 EilG12V+
 3HdXeH6sPS8GgVmuwAeTy7jyWYRqmWxtplWwmx0b+4cIyUaJjyCkGECwxi6b8De/1TroSFwPqskVlIeztoXgnXUcuLP1ph7Joa5aXy5NIDlbwsLsqnOIWHZmdZKZmF6nBVWr0wVuwX57tcv8Z48qaNjSLwlFULgwdQ7e9vE9qv/yURY4R1Pow4SD0UL6iPc1uETw1hKb7lakIStuMmHeuIlgz9ne3LmqzKHtskTR0C4MUc9p1QCDH+rta3KkT6lHZlCAgR3TwjHFOeMS8rRbqqt2PBXr9ZU40D/vhEJpQZg+z6rKfN+NgGxNThP9n7Evdil3t4GVlkPgTrJdPX/jMybuE+NF2HiUZa9yAACCDppb4MVWQOvKmTJxMbCqP8deihndZi8pIwNPrd/+V9sbJlKjVQGVOAsDGuRxagv4pKtuKBrgdb6P+jq6csgdmJgLvNQjcRMY0c4LB5KggQcjulV/DFZ8Pl1wHyQ8fuCAUUg2qrLn+YDK+hcPPbkadEfjfnIz/wfKgyopz6gZB7aNWwUA4B9oGoWloWr7b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 6, 2026 at 12:04=E2=80=AFPM Jiakai Xu <jiakaipeanut@gmail.com> =
wrote:
>
> Hi Ethan,

Hi Jiakai,

> Thanks for the detailed explanation.
>
> Would it be fair to say that KFuzzTest is not well suited for testing
> kernel functions that are heavily influenced by or have a significant
> impact on kernel state?

With the current fuzzer support (see the PR in the syzkaller repo [1])
this is a fair assessment, but with a caveat.

It really depends on how you are fuzzing. KFuzzTest itself is just the
conduit. Whether or not your fuzzer can meaningfully reproduce
bugs/crashes related to complex state is somewhat out of KFuzzTest's
hands. However as of v4 the framework only supports blob-based
fuzzing, I would advise against targeting heavily stateful functions right
now. You are welcome to experiment to see if there is a way to meaningfully
fuzz more stateful functions, but with just binary buffers as inputs, I don=
't
reckon that there will be too many candidates.

> I agree with your point that "the goal of the framework is to fuzz real
> functions with realistic inputs." One thing I've been thinking about,
> though, is how we determine what counts as "realistic" input for a given
> function. If the generated inputs that a function would never actually
> receive in practice, we'd likely end up chasing false-positive crashes
> that don't represent real bugs.

I would argue that just because an input isn't "realistic" in the current
kernel context (i.e., the current upstream code only calls into the library
after performing sanity checks and/or validation) doesn't mean that a
crash isn't problematic.

Code can and does get reused and refactored over time. If an internal
parser can cause a panic or OOB access when handed certain inputs,
it is inherently fragile. Even if that code path is shielded today, it coul=
d
be exposed by a new caller tomorrow. Our baseline assumption here is
that if a function accepts a blob as input, it should be resilient to all t=
ypes
of blobs.

However your concerns about false positives is justified, and something
that we have thought about. In previous iterations of this work, we relied
on a constraints system for encoding input semantics and performing
validation inside the fuzz harness. While we stepped back from that due
to its inherent complexity, instead favoring a more simple blob-only design=
,
adding constraints to better define "realistic" inputs is a good idea that =
may
need to be revisited in the future.

Hope this helps clarify the design philosphy!

[1] related syzkaller PR for KFuzzTest:
https://github.com/google/syzkaller/pull/6280

> Thanks,
> Jiakai
>
>
> On Fri, Mar 6, 2026 at 6:29=E2=80=AFPM Ethan Graham <ethan.w.s.graham@gma=
il.com> wrote:
> >
> > On Fri, Mar 6, 2026 at 10:45=E2=80=AFAM Jiakai Xu <jiakaipeanut@gmail.c=
om> wrote:
> > >
> > > Hi Ethan and all,
> >
> > Hi Jiakai
> >
> > > I've been reading the KFuzzTest documentation patch (v4 3/6) with gre=
at
> > > interest. I have some questions about the scope and applicability of =
this
> > > framework that I'd like to discuss with the community.
> > >
> > > The documentation states:
> > > > It is intended for testing stateless or low-state functions that ar=
e
> > > > difficult to reach from the system call interface, such as routines
> > > > involved in file format parsing or complex data transformations.
> > >
> > > I'm trying to better understand what qualifies as a "stateless or
> > > low-state function" in the kernel context. How do we define or identi=
fy
> > > whether a kernel function is stateless or low-state?
> > >
> > > Also, I'm curious - what proportion of kernel functions would we
> > > estimate falls into this category?
> >
> > I would define it based on "practical heuristics". A function is probab=
ly a
> > good candidate for KFuzzTest if it fits these loose criteria:
> >
> > - Minimal setup: KFuzzTest currently supports blob-based fuzzing, so th=
e
> >   function should consume raw data (or a thin wrapper struct) and not
> >   require a complex web of pre-initialized objects or deep call-chain
> >   prerequisites.
> > - Manageable teardown: if the function allocates memory or creates
> >   objects, the fuzzing harness must be able to cleanly free or revert
> >   that state before the next iteration. An example of this can be found
> >   in the pkcs7 example in patch 5/6 [1].
> > - Non-destructive global impact: it's okay if the function touches glob=
al
> >   state in minor ways (e.g., writing to the OID registry logs as is don=
e
> >   by the crypto/ functions that are fuzzed by the harnesses in patch 5/=
6),
> >   but what matters is that the kernel isn't left in a broken state befo=
re the
> >   next fuzzing iteration, meaning no leaked global locks, no corrupted
> >   shared data structures, and no deadlocks.
> >
> > These loose criteria are just suggestions, as you can technically fuzz
> > anything that you want to - KFuzzTest won't stop you. The danger is
> > that the kernel isn't designed to have raw userspace inputs shoved
> > into deep stateful functions out of nowhere. If a harness or function
> > relies on complex ad-hoc state management or strict preconditions,
> > fuzzing it out of context will likely just result in false positives, p=
anics,
> > and ultimately bogus harnesses.
> >
> > The goal of the framework is to fuzz real functions with realistic inpu=
ts
> > without accidentally breaking other parts of the kernel that the functi=
on
> > wasn't meant to touch. Therefore ideal targets (like the PKCS7 example)
> > are ones with minimal setup (just passing a blob), have manageable
> > teardown (like freeing a returned object on success) and don't
> > destructively impact global state (even if they do minor things like
> > printing to logs).
> >
> > That said, I'm curious to see what you come up with! I'm sure there are
> > other use cases that I haven't thought of.
> >
> > [1] PKCS7 message parser fuzzing harness:
> > https://lore.kernel.org/all/20260112192827.25989-6-ethan.w.s.graham@gma=
il.com/

