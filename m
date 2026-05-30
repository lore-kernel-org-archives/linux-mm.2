Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A899BCD6E52
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 03:02:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 797416B0005; Fri, 29 May 2026 23:02:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 748526B0088; Fri, 29 May 2026 23:02:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6374A6B008A; Fri, 29 May 2026 23:02:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5205B6B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 23:02:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0E5BA02D3
	for <linux-mm@kvack.org>; Sat, 30 May 2026 03:02:12 +0000 (UTC)
X-FDA: 84822587304.07.71F3D8C
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 04DCB120002
	for <linux-mm@kvack.org>; Sat, 30 May 2026 03:02:10 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bRxBO3GG;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780110131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dFnUlGJksSYSOwCKqq2mmNxuP1CCr0OgydxaPm40SIk=;
	b=ZCIbC65FEkQahvPkPxDJu5zwoMmmVuYzcBeDPT/xMZJYhUFyN1dIuGqG9jibpgezr/obXH
	wQFrqZ+Ze48mxWpazlpj+L6KbGngECQaOyZlIWdKb89EwHgI4m0VkwxcDSICWDya/Ljn9D
	qqnRKJSNU+8fHqN3Gbl/EMYhiqTpQEI=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780110131; a=rsa-sha256;
	cv=pass;
	b=6UGXo25pucep4HN1h2akW+a2tvqJmV1IlcPHQift1xFx4rwyvqWwf92QMjB0kKkaYf5AZE
	9cbth4jpCbW588YOvDLCc/yZ1GB6V/iupNWLQNbtr6TfPwujDhtkLtMgIZ8gPsAOcKi3g1
	rGUnV7Be78KJGlWQURnHHIdEJ6oToLU=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bRxBO3GG;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf29.hostedemail.com: domain of akinobu.mita@gmail.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=akinobu.mita@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-50e5bea4045so113957821cf.3
        for <linux-mm@kvack.org>; Fri, 29 May 2026 20:02:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780110130; cv=none;
        d=google.com; s=arc-20240605;
        b=iXDGjuL7v9LlO5lly0bs0ABccK+3UdifsbKInV31w/1pN5sRc7iTocXgFoORgx+yBh
         NmQRVicnMyFbY0HoL0nSlGYbwZxutR/GfwqWqlw4xptv+AWC6GP1d9aIKsOi8wDBuq40
         Rhq/cWfNCLMJZgRsp216Sy4AynCFPs2zpkwo5CsY8H9x9bGntbbsIF5mqbZex0jRwc7T
         8lI36rx536SB0Gtu46tnOqdmEzQCRb2+/3ptYdBr592dESrG+JejLOQMKiy6unFqepB1
         U+ZcIpKV6HOSCjCXE6S6FyEZCUwm06u5IcbGyYf1NmXv5Z1VktQbyjuRn2Wj8RNNiSFq
         Eaqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=dFnUlGJksSYSOwCKqq2mmNxuP1CCr0OgydxaPm40SIk=;
        fh=XJuvSIudX/3WCoNTT0pjR84nGjrkejoY65dDQF8iwAc=;
        b=aV36IVVFtS4BUWND/v8nHbsJruMu9XjDqavGG5i3dir2DFTqOWd2IvBhsHGIMZ3Wmb
         O2E1e/yIJ+x3Eos9lgiDTMECbYc1JuK7xSWzsn7//tCwbYctkMNRogsdJVQy5GUfNlKP
         uTPTZidnWYcfV3ptXCRdDUTU1afzkj6oee45aOaFEmMQiabys6QtSCSRI+GbSuzuCqfq
         jgTb4lzXmf9ETjN4K23V9z6i530GjiUpJWHHYrp6keAyOhtYZZqLE3GmVRJRul4sVr4d
         KOWCtmX4WGaZ7Jt4wkCYt5E5/NY2kpr6Re1mCJ1La7fNDkd/JMf1vn37S5FnBkddbKpV
         FG5A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780110130; x=1780714930; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=dFnUlGJksSYSOwCKqq2mmNxuP1CCr0OgydxaPm40SIk=;
        b=bRxBO3GGkmhSD9RGovem0i/B7QQdKNSb6BK25imCvSdQMH1TFA6HQAweLdcVJCcfXx
         TMigoNaj1habLOkXKpiWeSOH4f+dQASq9rpXkKgms44ntzE0TY0dnyLXcvKpjeKMr3AI
         jkGABBq3ex1FF9Khsf9qsqDlhFCFAydW9en5U2kRXyn9W2wI/Qu09INEUf/Cf3Tuvd/f
         nhdm/auX/KxrpWhAZhOv/dwwyJTVLfyXqehazq5VcBiwK8EaouiPx0oETBEJ3Y/yOeeR
         evHbk93Tqp3KpTgpbxu82e2onlCsCImIu/Mcb3guchBad0wRsytirOn7HaSBVRN0rXLI
         wxag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780110130; x=1780714930;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dFnUlGJksSYSOwCKqq2mmNxuP1CCr0OgydxaPm40SIk=;
        b=nvqkO5kVx/zZpTp9wVH0OoxYlLQnMoGraVGgJzE7lkiukh8Go9/1z3UkHQBaK1auwt
         /BVz4XZjpNezfgRypZw588lKd2sVlkPmJks3cy/D0JIgJ++y6UbO0lX+NvCGiIlVnM2R
         bTzUjApzgWHid4nFjDsMas/uE30scRr5cUAxylEnlqk9GGMXyz9DvHrtn6iB8TgAJaRr
         eM17MApE0ip9kbooLgKouYhtqsbMdB03Qhh3LRHudpLcWi7FTKJj+2RL5u+H8FTRYLB2
         0Sd/Relnl0jhvRFEHajr+867GAwmAGJIoIEDYuTfcZAChl46qm1oa8rmdTTmZyywpHHM
         GDvA==
X-Forwarded-Encrypted: i=1; AFNElJ+xoxXxPXF/CiF/WBlfBC2CHQrKoRRydNFMUjBI7mqmUA8Ph7bBzDQcjhv1MMEMOLf7IN1qUlSLEQ==@kvack.org
X-Gm-Message-State: AOJu0Yx3II7hDFVuMucdFkboDIt1Oml3kATBnJI/tRXS5sIlcFxn+54c
	j0o0ewM5VBgNSjCtBYU1bY+GX4/UuUK/BayU6AQgGMW/yU4kcZXlCfcxCC4GqD8kzhE1+O/G5qK
	hrCEQI0r4jvI1nqG5hXiFdFsrguleD+w=
X-Gm-Gg: Acq92OFyJ7bt97+WPFm0EtoRa607SZlt4qcL9U4A3kuLUkj4lK7qb1kpcoMIdax7cV2
	ACfCqspV7KD/6ckZ+8IVm4eYMvq0RuPkwbdcjuKOdzXstjkKNCXBZjhju1V8i9d8f9xeHF76VWE
	cXZo27pdx1HCA4yn0++EaVYEAZTlYh1YDNUESMB12UWcZlYyecM39qnT6ltBqPDuzTGJMOcBsNk
	ZvKli1XTUIJC+Mz9G5C4a5mRE2fLLDQKwv7iL9ExIMGl1Jyquo8xNbCusZkgNL+SoMYZAoyrHpy
	F0eNEG4aHX5Id5BmXKi0SyOpF1RqHCPwb+Rh1JDhC3JS1Q==
X-Received: by 2002:a05:622a:2289:b0:516:e833:64f2 with SMTP id
 d75a77b69052e-5173a61b308mr35165141cf.12.1780110129871; Fri, 29 May 2026
 20:02:09 -0700 (PDT)
MIME-Version: 1.0
References: <20260529165640.820-1-ravis.opensrc@gmail.com> <20260530000500.87407-1-sj@kernel.org>
In-Reply-To: <20260530000500.87407-1-sj@kernel.org>
From: Akinobu Mita <akinobu.mita@gmail.com>
Date: Sat, 30 May 2026 12:01:58 +0900
X-Gm-Features: AVHnY4IOaEk-LMA2tNNfp68UTFhBewxlgDEMjypO9pe34LsPseJjoV905YQ2OdI
Message-ID: <CAC5umyhej9QKKOHcf5bbRw97gsoOfEOMLkpcAk-Lm_fL-4rHgA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] mm/damon: hardware-sampled access reports
To: SeongJae Park <sj@kernel.org>
Cc: Ravi Jonnalagadda <ravis.opensrc@gmail.com>, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	akpm@linux-foundation.org, corbet@lwn.net, bijan311@gmail.com, 
	ajayjoshi@micron.com, honggyu.kim@sk.com, yunjeong.mun@sk.com
Content-Type: multipart/mixed; boundary="000000000000f3e0330653002fca"
X-Rspamd-Server: rspam11
X-Stat-Signature: i1nai6howykmki7o5toufjhmj17ygc9t
X-Rspamd-Queue-Id: 04DCB120002
X-Rspam-User: 
X-HE-Tag: 1780110130-514547
X-HE-Meta: U2FsdGVkX18anuFUIX2fDGprfcpOa3wFjqiKllNxcJkO6Nz9sKX5mZSBfvQsohEMOZmf/u/LhAawZFUP4XuCN0pct2Xmkustuh5sBTJf6eKGj3Aa1gTe3plKU+mPfdQIWUUEEdfIj6MFvjxyyRh3WsG8UvJ57PwBUZyQtLKs8H5aixaModNtpEJhafV4CFt89YPUivkk8+5qPOayEgSGLyWn4InlKf6k/HZw3GagYrcMlCksEIMIegAO2uVEw8QK9GHm6u7uxi/92y0Lv608FFuM8htTF4rW0pAig3/oo/eXSXV1JFXrCehvATEbhUQAEUCc7mjrs2MqQYCQJxFHIOHLRLW7LKAf4XkDGqFN6ZpUWQHZZ6BqIC0uUlXE8iAX7FGqjn3hhRY1GONviexDQRVt4X0G68pUkDMOOhDJQlDDT277aV5ZXhhTNMcgJE5YSNtrk+bDfgWrK0WF72tXS94yec8cREFkc9qQDVpsZAhFfvxMmlZeRg5j3ICHua87DdHhD+A3cgu1I+1Bi9GqqswqdND6DkIW0KhwUAjYKIlQDfKKbOp8BRZEDoVuPn/O550OgRr38sG+tymr5z69DxjD2/ItuP7NYvyTsB0JBDvHVCa5k/6hQb5rsmmLizkxQwjs0vf1ctjF1zYKtlr6HYeILpWzh4o+CDUN+54BfPBG1ox6ZWFe70qoWOzCXTn6aqlkSa0qqVISB2aqWXjsXuIHRQSRUNb6UlYfbn4RWbVWRydDDCfFptnkWw2s0mpS5j/PdgRxsB6E85OBm0HL9wcQXWjvJqGI+qxtfc+0ObJDudTV3tCMYmlf3JJbHCmD/8PY3kI6rzw4FNCUaW1T846zK6nzkCUl1oirpUyHfYDzDE93lBzTYRZ9Xmh6HO59dxK4CThy+/8tHWj7yQZGgZzeChTWdPndPP5fez353F1wTLMu46kIkwivcEB2Hv/P3b+v9GxyBH3ODPmnSZA
 G4UFaMSj
 mFjFIj1M/reNB3gzFpBEJkbkB8z89EKiGJshb3PqrRBUZxoAR6qygTzuoxERb96+FbuX+4bYvrv/5FFiqysKvGxPoUeuiTTrA9BQxRMQ+Qn3iOptuWSEyApEQHJPK28CZdVK78fEHKfXJWaw2xsxbU4ldk0FXMWqYUE2pHpuS0hZtktPvZUB7+3XlAUuL0P5oxhuPD7dYMHInkY6TacdTecKzSuaTpvw+qA4Rcz4sFp5oiaQ5slFzjsd0Rv0epud1z51F/+nPYEorRen4MoZ/FWIC4Xjk8F97oiiUWwH4N3ibkEOygFzCe3RhHS+62s5RSUqC3k8OcJ5IpGObP/T6vIB+p71tlsIRtVS+VU1byt/z+9ef9pwVsoab+bzzIIvCHur3w8qCtUHzvrgAkbFFZrrfuKaRQCbFLuBYHkckiZrI0PS8lzJ2a37YjQRqvEwMsZXmbVVQYxmovmEYePnfBaFr7pktubQE9arfCRL696LfDnt0LUIFcRHEfLsjs7ZWj6CnmLj69TuEHfcOf4RCiTjt3q7miR8nJl2ZrdLKUQIr0mAMuP3MdiQs2d5Vt8IFqOJbtqMd2FQ2YUMXfTaaAtohOylWz80aVuzuyszhQtHU+e/XK8KXnm8F9pX17wk4vZNKXoTSirI3slHv2MZC6cp87wj2jLZZSGaC4mraWyqUD4I/wo9iYF8dnH0tkQGn301zYayo6SzfQ9Me+vJU/cbK/LilEs1vZEg0jyblUMb55scySdzNPRi/IzsCtcfVzRia
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000f3e0330653002fca
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello Ravi and SeongJae,

2026=E5=B9=B45=E6=9C=8830=E6=97=A5(=E5=9C=9F) 9:05 SeongJae Park <sj@kernel=
.org>:
>
> On Fri, 29 May 2026 09:56:34 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail=
.com> wrote:
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
> > about.  This series builds on that direction
>
> Ah great, so we have no unclear challenge (additional loadable module sup=
port
> and conflicts with other IBS modules) on our road for now!  That is, we c=
an
> reuse the stable perf event interface and achieve all our goals!  As I
> previously shared [1], it would take time, but I'm very optimistic about =
the
> success of this project.  I don't like promising too much, but this proje=
ct
> looks like something that we can "consider it done".
>
> We can also say that the current candidate of the first
> damon_report_access()-based data attributes monitoring (milestone 2 [1] f=
inal
> deliverable) is the perf event based monitoring.

That's good!

From a quick look, it seems to have all the features I need, so I'd like to
evaluate it based on Ravi's patch.  If any extensions require changes, I wi=
ll
let you know as feedback.

Ravi,
You can also add my Co-developed-by and Signed-off-by tags to the appropria=
te
patch, so please post to the mailing list.

I am currently working on a change to allow selecting perf events from the =
damo
tool by specifying the event name, similar to the perf record -e option (e.=
g.,
"cpu/mem-loads,ldlat=3D30,freq=3D5000/P" or "cpu/mem-stores,freq=3D5000/P")=
.

I'll share the progress once it reaches a certain point.  A change to the p=
erf
file, as shown in the attachment, will be necessary, but I believe it can b=
e
handled without changing Ravi's current patch set.

> > with the changes we
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
>
> FYI, and as you may already know, the current plan [1] is to use the attr=
ibutes
> probe interface.  With it, the above IBS Op event setup part would look l=
ike,
>
> mon_attr=3D/sys/kernel/mm/damon/admin/kdamonds/0/contexts/0/monitoring_at=
trs
> echo 1 > $mon_attr/probes/nr_probes
> probe=3D$mon_attr/probes/0
> echo 1 > $probe/filters/nr_filters
> filter=3D$probe/filters/0
> echo perf_event > $filter/type
> echo ibs_op > $filter/perf_event_type
> echo Y > $filter/allow
>
> Of course, more details could change later.
>
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
>
> Thank you so much for sharing the great prototype implementation and test
> results!
>
> I will try to make fast progress on milestone 1.  I will hold reviewing d=
etails
> of this series for now, as there could be more changes.  But in the high =
level,
> this looks promising.
>
> >
> > [1] https://lore.kernel.org/linux-mm/20260516223439.4033-1-ravis.opensr=
c@gmail.com/
> > [2] https://lore.kernel.org/20260423004211.7037-1-akinobu.mita@gmail.co=
m
>
> [1] https://lore.kernel.org/20260525225208.1179-1-sj@kernel.org/
>
>
> Thanks,
> SJ
>
> [...]

--000000000000f3e0330653002fca
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0010-perf-python-Add-member-access-to-config1-and-config2.patch"
Content-Disposition: attachment; 
	filename="0010-perf-python-Add-member-access-to-config1-and-config2.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_mprrim1a0>
X-Attachment-Id: f_mprrim1a0

RnJvbSBiMTFiYjQ0ZDIyOGQ1MTI3MmM2MTM4NTU5Y2I3NzIyOTdiYTQ3MWFjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBa2lub2J1IE1pdGEgPG1pdGFAZml4c3RhcnMuY29tPgpEYXRl
OiBXZWQsIDI3IE1heSAyMDI2IDE5OjAwOjQxICswOTAwClN1YmplY3Q6IFtQQVRDSCAxMC8xMF0g
cGVyZiBweXRob246IEFkZCBtZW1iZXIgYWNjZXNzIHRvIGNvbmZpZzEgYW5kIGNvbmZpZzIKIG9m
IGV2c2VsCgpUaGlzIGNoYW5nZSBpcyBuZWNlc3NhcnkgdG8gc3BlY2lmeSB0aGUgc2FtZSBQTVUg
ZXZlbnQgc2VsZWN0aW9uIGFzIHRoZQoncGVyZiByZWNvcmQnIC1lIG9wdGlvbiBmcm9tIERBTU9O
J3MgdXNlcnNwYWNlIHRvb2xzLgoKRm9yIGV4YW1wbGUsIGEgUHl0aG9uIHNjcmlwdCBsaWtlIHRo
ZSBmb2xsb3dpbmcgd2lsbCBhbGxvdyB5b3UgdG8gb2J0YWluCnRoZSB2YWx1ZXMgdG8gYmUgc2V0
IGluIHRoZSB0eXBlLCBjb25maWcsIGNvbmZpZzEsIGFuZCBjb25maWcyIG1lbWJlcnMgb2YKcGVy
Zl9ldmVudF9hdHRyIGJ5IHByb3ZpZGluZyBhIHN5bWJvbGljIGV2ZW50IG5hbWUuCgppbXBvcnQg
cGVyZgoKaWYgX19uYW1lX18gPT0gJ19fbWFpbl9fJzoKICAgIGV2bGlzdCA9IHBlcmYucGFyc2Vf
ZXZlbnRzKCJjcHUvbWVtLWxvYWRzLGxkbGF0PTMwL1AiKQogICAgZm9yIGV2c2VsIGluIGV2bGlz
dDoKICAgICAgICBwcmludChmIntldnNlbH06IHR5cGU9e2V2c2VsLnR5cGV9IGNvbmZpZz17ZXZz
ZWwuY29uZmlnfSIsCiAgICAgICAgICAgICAgZiJjb25maWcxPXtldnNlbC5jb25maWcxfSBjb25m
aWcyPXtldnNlbC5jb25maWcyfSIpCgpTaWduZWQtb2ZmLWJ5OiBBa2lub2J1IE1pdGEgPGFraW5v
YnUubWl0YUBnbWFpbC5jb20+Ci0tLQogdG9vbHMvcGVyZi91dGlsL3B5dGhvbi5jIHwgMiArKwog
MSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKQoKZGlmZiAtLWdpdCBhL3Rvb2xzL3BlcmYv
dXRpbC9weXRob24uYyBiL3Rvb2xzL3BlcmYvdXRpbC9weXRob24uYwppbmRleCBjYzEwMTlkMjlh
NWQuLjU2OTAzNjE3YmE0YyAxMDA2NDQKLS0tIGEvdG9vbHMvcGVyZi91dGlsL3B5dGhvbi5jCisr
KyBiL3Rvb2xzL3BlcmYvdXRpbC9weXRob24uYwpAQCAtMTI0MSw2ICsxMjQxLDggQEAgc3RhdGlj
IFB5TWVtYmVyRGVmIHB5cmZfZXZzZWxfX21lbWJlcnNbXSA9IHsKIAlldnNlbF9hdHRyX21lbWJl
cl9kZWYoc2FtcGxlX3R5cGUsIFRfVUxPTkdMT05HLCAiYXR0cmlidXRlIHNhbXBsZV90eXBlLiIp
LAogCWV2c2VsX2F0dHJfbWVtYmVyX2RlZihyZWFkX2Zvcm1hdCwgVF9VTE9OR0xPTkcsICJhdHRy
aWJ1dGUgcmVhZF9mb3JtYXQuIiksCiAJZXZzZWxfYXR0cl9tZW1iZXJfZGVmKHdha2V1cF9ldmVu
dHMsIFRfVUlOVCwgImF0dHJpYnV0ZSB3YWtldXBfZXZlbnRzLiIpLAorCWV2c2VsX2F0dHJfbWVt
YmVyX2RlZihjb25maWcxLCBUX1VMT05HTE9ORywgImF0dHJpYnV0ZSBjb25maWcxLiIpLAorCWV2
c2VsX2F0dHJfbWVtYmVyX2RlZihjb25maWcyLCBUX1VMT05HTE9ORywgImF0dHJpYnV0ZSBjb25m
aWcyLiIpLAogCXsgLm5hbWUgPSBOVUxMLCB9LAogfTsKIAotLSAKMi40My4wCgo=
--000000000000f3e0330653002fca--

