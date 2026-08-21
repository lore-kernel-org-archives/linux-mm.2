Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7938C5DF88
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 05:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57826B0095; Fri, 21 Aug 2026 01:45:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B08516B009B; Fri, 21 Aug 2026 01:45:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1DD56B009D; Fri, 21 Aug 2026 01:45:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7660A6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 01:45:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8419E1C0873
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:45:44 +0000 (UTC)
X-FDA: 85124189808.12.DC22DBA
Received: from mail-pj2-f8.google.com (mail-pj2-f8.google.com [74.125.227.136])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9444D40007
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 05:45:42 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xfgv3Ubt;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787291142;
	b=yTNzkZtMBLDLPDdvHVq5ydZmy5BdgaDUEV4XcDByVaGVfdBCuvUIzSig8Xz2eUFDnDYl5M
	pgQwGfmYdHNgKR9v7ygngjyCMnZ8IXyK9WxGQ5Ep66oFaarEeVQ60WFXfIrDBfjNuPxazl
	oAiTXHvEeihxysUdCqpgbhjwFR0jgz0=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Xfgv3Ubt;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.227.136 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787291142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ROW98uhKqBpi1d3PuLKKH072x+hvcaVcm5AXC+FLU20=;
	b=gIMLrBMVzvG69ne0fzon0MDz+NALniOvafp/YANh3H6yuPvvo9+tzmXhQE2WWjVMRn7o9K
	Fs+WuIba4QOYJbrQrsHHEdCQUzmRSo00OaodBfC3jLVCzsrG0hkd1VFXu8jFxjHhuv3t3j
	+6aNNFVPhEg6R2gjQjSlQpbf8HBq5EE=
Received: by mail-pj2-f8.google.com with SMTP id 98e67ed59e1d1-392a608284dso193474a91.1
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 22:45:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787291141; cv=none;
        d=google.com; s=arc-20260327;
        b=LbbniBDzFrWc/UdxygyN0/fLJWf4kKPUeQYLT2MTSjIo9RRFW2rvCf1rhETIP6KDpy
         EpDk6cF+ZsbEE993ZcAcpTmU6DxSH0dFkefVK+6Ur4tBqzkjCjGyyQdjo2vGE4goPblm
         aJpEYLmh/DYvKz4hg0hJemUE6FM28ccc8qgNbo6bV6KqJmZ+OpPx/3A0KJY3Cx5+qMyE
         sIBKGJtSuhZrbWYl2lSD+W/DWMQLyAmzJfSL2T5G+pRcy6sKUOWiyMaN0tg6JZuyzybG
         glUF1khKSzzkWgquFhdYck9z51xkPpR2BS/rQwjdslEwvcHC9/fiXTFs7kjPfmIykPnV
         nXcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ROW98uhKqBpi1d3PuLKKH072x+hvcaVcm5AXC+FLU20=;
        fh=wwkvg5oIMMQYYRiBf2spEOLtissVDiqn0OO0LzlTa/g=;
        b=fIgdgZMMFtiKRICyDVRv0f0W6YuTYtLMad7S7s2ga7KDYDhQxQYnOgnh8QHsBgzmTn
         DsOFJgvhbf4ZdGo5Zpv/+Xj7NUmmT3NL8jTeZP/GaVxKTrxx4QtJdOwQ8dndeI8Pj77R
         aer9XAX7t0p9ZkeaFkYDGX8+AuVLjGhs3bfQNY1A7QE2A/NDkaXhcqr6A8fbvWXcgNI5
         YmlYXAA5/PKvW1rXIlNBmIII6KrTykdjbWlttOGYDHfWYP9pJKppw7uTl5pgHFipzMU6
         kw9Ddyu8dCmAgzwZSL+VxvhJ0TOXU2RRwLtQTRQHnGJn4MQZxoGzoUjvGPEqF+/lgi/l
         skxw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787291141; x=1787895941; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ROW98uhKqBpi1d3PuLKKH072x+hvcaVcm5AXC+FLU20=;
        b=Xfgv3UbtCqtP1xPmGelQKHr3QCCHl476G9KakXNUgM8Yzh5A7PuK1j44hRgdJK1un5
         ZFxvTLH9goYgj8ypbRIG4iFnnDuXbhxO8QnaCEqfIsFfz5dep8mowl43kBWqaPQ3Kuxd
         erhslC8zPgnJ3GYjhoRSv3OqQEtLGOCmxhVyV+ZJRzkRk1kZRoWRPgEYbVYBLjm3HQhy
         F3gdrsDStFQU7qoyL+em1iaucZkQfbh5qdvPQ5gHI1hKDD2xq9h+c1EVkDFuom++5Nql
         qVnE44V3hzbL0u8cIbjdQAkJdfLFWTJKS9r51iV7maANjBXnYD7K+hA7nyWtNrcglDBW
         Hszw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787291141; x=1787895941;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ROW98uhKqBpi1d3PuLKKH072x+hvcaVcm5AXC+FLU20=;
        b=aPgRuv7N43jb8LnG7lUX/UG5M7Dle5nIMOUX+/kZqIH0mcfWQ99UFK4JsnVJ7e27xX
         ZMiV8gxarGEQiy2Y1CWed/XAiXpGBWRxZcWdNAjsXt77rZgqGO8QyvDrHOBqp4stWSEL
         kIwy45+gn7DYqb8KlImCIoBmMN/4oK4QYQ22U9JIGbm7sFEnqecW2cqkkvxcvZTtDr9j
         OkC2goMmn1GVmg9mcrF026JINRDQYhemhcXC6tYSC8ZIUv2CTtmeWcmqITjXttcqqLzu
         CLV5ujYCgOZSxlngFzrYYESBzZthuk68Q5CaBwlWy41fOXr3l/83yHbAVo1MHIiBDgdT
         3OzA==
X-Forwarded-Encrypted: i=1; AHgh+RqPPkQX45MN1y19dasY/2uQ6tu80liwXK5WHV1QjaRzstIO1Z7unaQxXM3sf5UF33ykadW8sEk6YQ==@kvack.org
X-Gm-Message-State: AFuF++maMMvg2jIQfwPxpNPfjmrRJ5e9Kh/3JgqgfSXLH8FXR2slwdKL
	iDgGu2a00tq9bmq2NmDDWTwhsemlTm+xEBAhbNcF1CDAHuj2/Us4i5JPKotmqC3DSi8Sn6I83YD
	l35fn1b9tdDC1llIAaWWlcGa8AwdZDw==
X-Gm-Gg: AR+sD10cvaTuIoNQdEVw22rBNHB1tsW0lOnIb8o4pENR2t61ENano/Bi1KLTnwfjI30
	JaUZ/FThR2s37xH2nNDBh962Y8Q0YF2SpNZI7j5qJDWNG/eJc49FtRfs7sWoLxoyGMzVpU9//yr
	BcOp+v6vBEMv4D6KZy7oYQF3CENfeJBafRdoS5Ed6gRaBw/dAOM8DHpYkeW/t2JT4isLeCPr9mm
	QlCEJr6uzr5yG/4NMglamN+cx+QkzLEX8uYMUrTHQHrv9gvX7q8yPEcRDm35T6CWFauf2aNVzYx
	LRu+Nc7Fljf5vPEQLx6Bs3mOfplf+/gF8aI1w7v0FTs=
X-Received: by 2002:a17:90b:5646:b0:38d:f5bb:e0f4 with SMTP id
 98e67ed59e1d1-395c33367ebmr7628908a91.1.1787291141208; Thu, 20 Aug 2026
 22:45:41 -0700 (PDT)
MIME-Version: 1.0
References: <20260529165640.820-1-ravis.opensrc@gmail.com> <20260818073546.832476-1-kunwu.chan@linux.dev>
In-Reply-To: <20260818073546.832476-1-kunwu.chan@linux.dev>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Thu, 20 Aug 2026 22:45:29 -0700
X-Gm-Features: AcwNN1XTH3yf2lIUJKRgEj9C_pmU-GAS-OSXTPMCUhXxZy1uKBamL6-BlgamdhU
Message-ID: <CALa+Y16xODsaFZDfh7ZeP3gWbycK92gvP5N8_NFpOvW=R2BWbg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] mm/damon: hardware-sampled access reports
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: Kunwu Chan <kunwu.chan@linux.dev>, sj@kernel.org, akinobu.mita@gmail.com, 
	damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9444D40007
X-Rspam-User: 
X-Stat-Signature: x8pr8mkc6xfdxcgy1nh439o4w3kzosgn
X-Rspamd-Server: rspam06
X-HE-Tag: 1787291142-918528
X-HE-Meta: U2FsdGVkX1/Rd2YrHwGTgZNBG7uzRAgtXS4EaAUg9aZqL1jfnfL5eiGbLCOIEx84ZLqZ5DxCYuybFJjkC6ku59ymmWwFSxexJ4LrRKWemjj3aDOKKea0tGkKwE8Tp/bwUP9y5h6d4J7ZGlwrehFRUcR1lsN31HMFLRWsZCZlEoC5cnxI4LPc4E/AULUk7hFo8+N7O7I4vpHFfw95PKZ9LUlYMwz7F7kFk4B48SYzGPxML3ml1zrGkv1UYfaDd+Z+rUoafUYh8kEIkNoO7jiy/9mzNi/H/KetKTY+752vT14KvZ2N1l/qBMLgWWw4YnyOFbleF0toqvqFBRSZcKO5IcWPBPMCyK4Ni44FGAWlu+1Rmo2ZlFkvxBw1cHh9Do9RTQeTCM5CIqiCPhXQWKIQIdPXlWedtEwtg/IAAknnpS9OoXhNNqq9d00z2QnJOPIVrL2vZ84wkm0paeCDIun/YsHNc0f9ocLiFJ24Tyo5HA95iPPXGdM3FdiHC1ebPfCoRYFOk+ivtPsdzhMLHqmD6Z1KbyeukDZuqvE7ir6AtzjxHIAVhlGN1lPOpSHu6PS48nRTz8Cu8n7zEn7yIk6w6aOh9Y8dBIRNixo/OMeugO/H1grlG6w3wER1CelPzZkH6+BlmpWPiz92h+LqFAYS3kR2st4PJHq5CW5YRrHO/XVImYncx7CszCXV4fKVCDWSoOyG/cmypZ/ufhAHIkJ7gvmnlpXQn16//H8IUuWjeUwQYi5BlPACPBAMkL9f/KZUf+iVb8cVA/1v0L6mi5NJuer7rwK2VCaQrdNob/ncpNCwavXbTjqZQEbsvuz3MjyIWFWjxCjyfJCtpavFphIVjPvcsx4zduln1bHgf069NFajwU5uw79J6O3RMKVCNw2goRMVvUCq6uM2ECmrHy5dmy/n9Q4wwnh8KBeUuTRzBDZTE5MDGpQYw3PNH5svRRuSJWDaPqfiF1no3QJagXj
 An7hZYAd
 zH/Wm5q0vv5HGTyU5Wf3/R3IoP4a3nv/W6t5+aBSTes9VCCjWCkALqLpn2JNq2KL2LyCAEzeMihIfLTVYPGXxjNx4FdIll1ZnJE9nfLQWR8fhbEGqeFD9oUSsPj0C8Pvhgy8ri8v0fI2+o5ZZkwdIW9TTbRk7A0/9kOgdKoaF0D+3VzmeKH51LRUQAmaDFuZahsHCXDHbHtiCy0NK13ylj8ChwSnkBSOpI2o3uEXjdaZlc652DydIxDDCZWLexh7aISIz3zNXEiAi/+ZBjn7FSdCBq9JuBR4VmohFJk60VBjaSCOjk/PcFz5fV8Q8dOkMETBZR0BFEkTxbgMspeXD6AHhgqZCt2eXEUOedWHeHn1YPFwQyi+ZCdJQZRU1im8woeW8zzu8YjsXw1WL9JxCWgUzfDwM7MsnAhQ2Z8L7ocTXXdtsdAM8Ij3b+GDaxw9lFNKCVFElt+erNlaKBlKwa3X4/geP2Y496jeJfSb+IrWFyNngbdC4yy3jq7Rm4Aq9BnEw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 18, 2026 at 12:36=E2=80=AFAM Kunwu Chan <kunwu.chan@gmail.com> =
wrote:
>
> On Fri, 29 May 2026 09:56:34 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
>
> Hi Ravi,
>
> I've been building on your RFC [1] to add ARM SPE support to DAMON,
> and wanted to share what we've implemented and where things stand.
>
> Your series provides the vendor- and PMU-agnostic reporting substrate,
> including the per-CPU SPSC ring and kdamond drain:
>
> > This series introduces a vendor and PMU-agnostic substrate inside DAMON
> > that consumes hardware-sampled access reports through the standard
> > perf-event interface.  Userspace selects the PMU through sysfs (raw
> > type/config knobs), driving either Intel PEBS L3-miss sampling or AMD
> > IBS Op sampling.
> >
> > Why a unified perf-event substrate
> >
> > Earlier hardware-sampled access-monitoring proposal [1] took an AMD IBS
> > specific module path backend, owning its own probe configuration,
> > sysfs knobs, and lifecycle.
> >
> > SeongJae Park has previously highlighted the advantage of Akinobu
> > Mita's perf-event proposal [2]: let DAMON register kernel-counter perf
> > events and consume samples from any sampling PMU that perf core knows
> > about.  This series builds on that direction with the changes we
> > needed to run it cross-vendor:
> >
> >   - a per-CPU lockless ring between the NMI sample handler and the
> >     kdamond drain,
> >   - per-CPU events that follow CPU hotplug cleanly,
> >   - events fire only while the monitor is running -- created disabled,
> >     armed when kdamond starts, disarmed and drained when it stops,
> >   - all-or-nothing init across CPUs: a partial-CPU create failure rolls
> >     the whole event back rather than leaving silent gaps,
> >   - safe handling of vendor sample-validity flags so a stale or
> >     unpopulated address is never mistaken for a valid sample.
> >
> > What the series adds
> >
> > Patch 1 introduces the substrate's data types: a per-event
> > configuration struct and a per-context list to hang them on.  A
> > CONFIG_PERF_EVENTS=3Dn build folds to no-op stubs.
> >
> > Patch 2 exposes those types through sysfs.  Each entry maps to one
> > perf event and lets userspace pick the PMU and how to sample it: the
> > raw PMU type/config, addressing flags, and period or frequency.  The
> > defaults are tuned for Intel PEBS; userspace overrides them for other
> > PMUs.
> >
> > Patch 3 wires the sysfs apply path so configured events get attached
> > to the running monitoring context.
> >
> > Patch 4 is the core of the series.  It replaces the mutex-protected
> > report queue with a per-CPU lockless ring fed from NMI by the perf
> > overflow handler and drained once per sample tick by the kdamond.
> > Drained reports are matched to monitored regions by binary search
> > over a per-tick snapshot.  The patch also wires the per-event
> > lifecycle into kdamond: events arm when the monitor starts, disarm
> > and drain when it stops, roll back cleanly when per-CPU init fails on
> > some CPUs, and a second context that asks for the substrate while
> > it is in use is rejected with -EBUSY.
>
> ARM SPE delivers samples through the AUX trace buffer rather than the
> regular perf overflow callback, so `perf_event_create_kernel_counter()`
> does not provide a way to consume the SPE AUX trace stream directly.
> To close this gap, we developed two pieces:
>
> 1. A perf AUX kernel-consumer API [2] that allows in-kernel code to
>    consume AUX trace data.
>
> 2. A DAMON ARM SPE AUX backend [3] that feeds the decoded access reports
>    into `damon_report_access()`.  This is a transport layer and does not
>    change DAMON's matching logic; it provides another way for hardware
>    samples to enter the existing reporting pipeline.
>
> While bringing up the SPE backend, we kept hitting the same question:
> "why does the PMU report zero accesses?"  The answer could be anywhere in
> the pipeline =E2=80=94 event creation, binding, enabling, the PMU itself,=
 the
> ring, or the drain =E2=80=94 and without per-stage visibility, the only p=
ractical
> way to debug this was to add printk instrumentation throughout the
> pipeline.
>
> So we also developed a lightweight PMU-agnostic observability framework
> [4] that instruments the pipeline with per-CPU monotonic counters and
> tracepoints.  It immediately helped diagnose the initial SPE issue:
> event creation, binding and enabling all passed, while the PMU produced
> no samples.  This pointed to a PMU-level issue rather than a DAMON
> pipeline issue, and confirmed that SPE needed an AUX-based backend.
>
> We used the framework throughout the AUX backend development to verify
> each stage of the pipeline.  With the completed AUX backend, the same
> framework showed a functional end-to-end pipeline: 27/0/0 selftest
> results, 47,248 callbacks, with all seven stages observed as expected.
>
> One interesting observation is that the framework's ring counters showed
> 32,087 dropped reports.  This is about 68% of the 47,248 callbacks.  The
> current `DAMON_REPORT_RING_SIZE=3D256` and drain interval were designed
> around much lower sampling rates, while SPE can produce
> samples at a much higher rate.  On the current Kunpeng 920 setup, the SPE
> sample rate can fill the 256-entry ring much faster than the
> current drain interval.
>
> This looks more like a throughput/rate mismatch than a correctness
> issue with the reporting path.  For high-rate PMUs such as SPE, do you
> think the ring size or drain interval should eventually be tunable?
>
> The observability framework is PMU-agnostic and is posted as a standalone
> series [4], so that other PMU backends can reuse the same instrumentation=
.
>
> The relationship between the pieces is roughly:
>
> Ravi's hardware-sampled reporting infrastructure
>                     |
>           +---------+---------+
>           |                   |
>     perf overflow        ARM SPE AUX
>           |                   |
>           |             AUX kernel consumer
>           |                   |
>           |              SPE AUX backend
>           |                   |
>           +---------+---------+
>                     |
>           damon_report_access()
>                     |
>                 report ring
>                     |
>                 kdamond drain
>

Hello Kunwu,
     Thanks for this, and sorry for the slow reply. I have been off for a c=
ouple
of days this week.

      The shape you picked is exactly the one the RFC was hoping for:
a new transport feeding the same damon_report_access() sink.
Reaching an AUX-only PMU from an in-kernel consumer is a real gap,
and closing it with a small generic API in perf/core is the right layering.
Good to see the substrate turn out to be useful this way.

Two things to flag:

1. The event-configuration surface changes in my upcoming v2
------------------------------------------------

Your series is based on the v1 substrate, and the way an event is
configured is the part that moves most.

In v1 a perf event is a property of the sampling attributes: a flat
array under

  monitoring_attrs/sample/perf_events/nr_perf_events
  monitoring_attrs/sample/perf_events/<N>/{type,config,freq,sample_period}

which is what your selftest drives, and struct damon_perf_event is the
in-kernel object.

In v2 the configuration hangs off a *probe* instead.  A probe is the unit
of "one thing DAMON measures about a region", it carries a weight, and
the region score is the weighted sum over probes.  A perf event is then
one kind of *prep* action on a probe -- prep_action =3D "perf_event" -- so
the same probe machinery covers both a PTE-scanning probe and a
hardware-sampled one, and several can coexist and be weighted against
each other:

  monitoring_attrs/probes/nr_probes
  monitoring_attrs/probes/<N>/weight
  monitoring_attrs/probes/<N>/filters/...
  monitoring_attrs/probes/<N>/preps/nr_preps
  monitoring_attrs/probes/<N>/preps/<M>/prep_action     <- "perf_event"
  monitoring_attrs/probes/<N>/preps/<M>/{type,config,config1,config2,
      sample_period,sample_freq,freq,wakeup_events,precise_ip,
      sample_phys_addr,sample_weight_struct,exclude_kernel,exclude_hv,
      single_instance}

So for SPE the freq=3D0 / sample_period=3D256 pair your selftest sets keeps
the same names, just under preps/<M>/ rather than perf_events/<N>/.

This is done as part of the roadmap plan of SJ.
https://lore.kernel.org/damon/20260816165630.84808-1-sj@kernel.org/

2. The 67.9% drop rate is fan-in, not sizing
--------------------------------------------

You asked whether DAMON_REPORT_RING_SIZE and the drain interval should
become tunable.  I don't think either knob is the fix here.

- The cause is where the drain runs, not how big the ring is.
  damon_report_access() picks the ring with this_cpu_ptr(), i.e. by the
  CPU of the caller.  Decoding every CPU's AUX buffer from the single
  kdamond thread therefore funnels the whole machine into one ring, so
  capacity per aggregation tick is 255 rather than 255 * nCPUs.

- I avoided it by draining on the source CPU -- per-CPU parse work
  queued over the cpumask, so each ring keeps a single producer and the
  ring geometry stays as is.  One detail worth knowing: it has to be
  system_percpu_wq, since an unbound queue silently ignores
  queue_work_on()'s CPU targeting.  Your ops already carry a cpu
  argument, so it should be a contained change.

- I did a quick sanity test on a plain QEMU guest with a virtual PMU in
  AUX mode on the branch below with your RFC patches.

  https://github.com/ravis-opensrc/linux.git
  branch damon/perf-rfc-v2-08-20-26

Thanks again for taking this on and sharing your results.

Best Regards,
Ravi.

> The observability framework is orthogonal to these transport paths and
> can observe both of them.
>
> Everything has been tested on Kunpeng 920 (256 CPUs, ARM SPE).  The DAMON
> AUX backend [3] and the observability framework [4] are separate RFC
> series, both based on the infrastructure from [1].
>
> Would appreciate any feedback on the approach, especially on extending
> the reporting infrastructure from perf overflow samples to AUX-based
> PMUs.
>
> Thanks for the foundation =E2=80=94 the per-CPU reporting and drain
> infrastructure provided a useful base for the AUX path.
>
> [1] https://lore.kernel.org/linux-mm/20260529165640.820-1-ravis.opensrc@g=
mail.com/
> [2] https://lore.kernel.org/all/20260814144927.489172-1-kunwu.chan@linux.=
dev/
> [3] https://lore.kernel.org/all/20260816142222.689624-1-kunwu.chan@linux.=
dev/
> [4] https://lore.kernel.org/all/20260818061031.827057-1-kunwu.chan@linux.=
dev/
>
>
> >
> > Patch 5 is the perf-event backend.  Two stateless overflow handlers
> > (one vaddr-keyed, one paddr-keyed) are picked at event creation time
> > and submit samples into the per-CPU ring.  Vendor-specific sample
> > validity is honored at this layer.
> >
> > Patch 6 adds a tracepoint at every node_eligible_mem_bp quota-goal
> > evaluation so userspace can watch goal convergence without polling
> > sysfs.
> >
> > Userspace setup model
> >
> > Userspace selects the sampling PMU by pointing the perf event's
> > `type` / `config` at it, and chooses the scheme topology that suits
> > the address space the PMU reports on.  No module load or unload step
> > is involved; `echo on > state` arms the substrate, `echo off > state`
> > disarms it.
> >
> > Two configurations were used for validation.
> >
> > Configuration A: AMD IBS Op, paddr ops, system-wide PULL+PUSH tiering
> >
> >   IBS Op stamps samples with physical addresses, so DAMON reasons over
> >   every backing page in the system regardless of which task or guest
> >   touched it -- the substrate becomes a system-wide tiering controller.
> >
> >   Setup (abridged; `D=3D/sys/kernel/mm/damon/admin/kdamonds/0`):
> >
> >     echo 1     > /sys/kernel/mm/damon/admin/kdamonds/nr_kdamonds
> >     echo 1     > $D/contexts/nr_contexts
> >     echo paddr > $D/contexts/0/operations
> >
> >     # Two regions, one per NUMA node (DRAM + CXL).  PA ranges
> >     # are derived per host from /proc/iomem; omitted here.
> >     echo 1 > $D/contexts/0/targets/nr_targets
> >     echo 2 > $D/contexts/0/targets/0/regions/nr_regions
> >     echo <DRAM_LO> > $D/contexts/0/targets/0/regions/0/start
> >     echo <DRAM_HI> > $D/contexts/0/targets/0/regions/0/end
> >     echo <CXL_LO>  > $D/contexts/0/targets/0/regions/1/start
> >     echo <CXL_HI>  > $D/contexts/0/targets/0/regions/1/end
> >
> >     # IBS Op event, period-based, paddr-stamped:
> >     PE=3D$D/contexts/0/monitoring_attrs/sample/perf_events
> >     echo 1 > $PE/nr_perf_events
> >     echo $(cat /sys/bus/event_source/devices/ibs_op/type) > $PE/0/type
> >     echo 0      > $PE/0/config
> >     echo 1      > $PE/0/sample_phys_addr
> >     echo 0      > $PE/0/freq
> >     echo 262144 > $PE/0/sample_period
> >     echo 0      > $PE/0/exclude_kernel
> >     echo 0      > $PE/0/exclude_hv
> >
> >     # PULL scheme: migrate_hot toward DRAM, gated on
> >     # node_eligible_mem_bp(nid=3DDRAM) goal target_value=3DTARGET_BP.
> >     # addr filter restricts source to the CXL range.
> >     # PUSH scheme: migrate_hot toward CXL, gated on
> >     # node_eligible_mem_bp(nid=3DCXL) target_value=3D10000-TARGET_BP.
> >     # addr filter restricts source to the DRAM range.
> >     # Both schemes are migrate_hot; they converge from opposite
> >     # directions on the same hot working set.
> >
> >     echo on > $D/state
> >
> >   Userspace tunes the steady-state DRAM:CXL split by writing the goal
> >   `target_value`s; DAMON's quota autotuner drives migration intensity
> >   to match.
> >
> >   Workload: a QEMU/KVM guest pinned to one NUMA node, running 32
> >   multichase multiload threads each touching a 4 GiB working set
> >   (~128 GiB aggregate) with the memcpy-libc kernel.  The guest sees
> >   a flat single-NUMA layout and has no direct view of the host's
> >   tiering topology, yet its hot pages are migrated to DRAM and cold
> >   pages pushed to CXL by host-side DAMON acting on IBS-stamped
> >   physical addresses -- the application inside the guest benefits
> >   from tiering it never had to be aware of.  Validated on AMD Turin
> >   (132-CPU EPYC).  The configuration converged to its target ratio
> >   in seconds and remained stable for 7+ hours continuously, with no
> >   perf core auto-throttle and no measurable drift in the achieved
> >   interleave ratio.
> >
> > Configuration B: Intel PEBS L3-miss, vaddr ops, per-PID weighted-dest
> >
> >   PEBS reports vaddr samples in the context of the running task.
> >   DAMON's vaddr ops monitors a specific PID.
> >
> >   Setup (abridged):
> >
> >     echo 1     > /sys/kernel/mm/damon/admin/kdamonds/nr_kdamonds
> >     echo 1     > $D/contexts/nr_contexts
> >     echo vaddr > $D/contexts/0/operations
> >
> >     echo 1     > $D/contexts/0/targets/nr_targets
> >     echo $PID  > $D/contexts/0/targets/0/pid_target
> >     echo 0     > $D/contexts/0/targets/0/regions/nr_regions
> >
> >     # PEBS MEM_LOAD_RETIRED.L3_MISS, frequency-based, vaddr-stamped:
> >     echo 1      > $PE/nr_perf_events
> >     echo 4      > $PE/0/type           # PERF_TYPE_RAW
> >     echo 0x20d1 > $PE/0/config         # umask=3D0x20 event=3D0xd1
> >     echo 0      > $PE/0/sample_phys_addr
> >     echo 1      > $PE/0/freq
> >     echo 5003   > $PE/0/sample_freq
> >     echo 2      > $PE/0/precise_ip
> >     echo 1      > $PE/0/wakeup_events
> >
> >     # Single migrate_hot scheme with two weighted destinations
> >     # (DRAM + CXL).  Userspace tunes the steady-state interleave by
> >     # writing dests/{0,1}/weight.
> >
> >     echo on > $D/state
> >
> >   Workload: 32 multichase multiload threads with a 4 GiB working set
> >   each (~128 GiB aggregate) running directly on the host, monitored
> >   by DAMON via the multiload PID.  Validated on Intel Granite Rapids
> >   (144-CPU).  Convergence is fast and the system is stable.
> >
> > [1] https://lore.kernel.org/linux-mm/20260516223439.4033-1-ravis.opensr=
c@gmail.com/
> > [2] https://lore.kernel.org/20260423004211.7037-1-akinobu.mita@gmail.co=
m
> >
> > Ravi Jonnalagadda (6):
> >   mm/damon: add struct damon_perf_event{,_attr} and per-ctx perf_events
> >     list
> >   mm/damon/sysfs-sample: expose perf_events configuration via sysfs
> >   mm/damon/sysfs: install perf_events on apply
> >   mm/damon/core: per-CPU SPSC ring drain and damon_perf_event lifecycle
> >   mm/damon/vaddr: implement perf-event access check
> >   mm/damon: add damos_node_eligible_mem_bp tracepoint
> >
> >  include/linux/damon.h        |  80 +++++
> >  include/trace/events/damon.h |  49 +++
> >  mm/damon/core.c              | 403 ++++++++++++++++++++----
> >  mm/damon/ops-common.h        |  39 +++
> >  mm/damon/sysfs-common.h      |   6 +
> >  mm/damon/sysfs-sample.c      | 579 +++++++++++++++++++++++++++++++++++
> >  mm/damon/sysfs.c             |   3 +
> >  mm/damon/vaddr.c             | 267 ++++++++++++++++
> >  8 files changed, 1370 insertions(+), 56 deletions(-)
> >
> >
> > base-commit: 4c8ad15abf15eb480d3ad85f902001e35465ef18
> > --
> > 2.43.0
> >
> >
>
> Sent using hkml (https://github.com/sjp38/hackermail)

