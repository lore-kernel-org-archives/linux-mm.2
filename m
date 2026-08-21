Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D84AAC5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 16:32:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89B946B0095; Fri, 21 Aug 2026 12:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84D936B009B; Fri, 21 Aug 2026 12:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73B536B009D; Fri, 21 Aug 2026 12:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 435726B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 12:32:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AF6B6C01AE
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:32:18 +0000 (UTC)
X-FDA: 85125819156.11.217FBA8
Received: from mail-pj2-f10.google.com (mail-pj2-f10.google.com [74.125.227.138])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8C317140014
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 16:32:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rgJRJEEx;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787329936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uKrunJMg40NjeuxUGrFsyHBAkzDtHd4//4PJzcyrA7w=;
	b=JRQzgDld9RKxThref1hZzR6FuNOrgkmPdQOyUK1mnPda0xXAk4X6wvB+fPao9e118FPEjf
	hjU4zuH/ySfoHfpEzlwTybfv+kcrlGrMzHDwwJQ7vxk7qLbn8kP7QEqGwX5e+7Tl3GGkfp
	aZC4tM0mQZe8rsodD2aRjb2AEQuCmWg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rgJRJEEx;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.227.138 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787329936;
	b=I0wg054vtSb8jSgLC+iqGzKmKpvpyJpGULg165qht+wbrc/a2AK1s0rZkX4S1rqeFCihEw
	D1sVYotcRn+ON2yKiRiTwO5FriqnMXvBrU2w6CXlAff3xy8BKEXgmbA+zAUq4wWmzw/SZ0
	4gR4496IA7/8spQQ2QiOH6Jz3uLV/YQ=
Received: by mail-pj2-f10.google.com with SMTP id 98e67ed59e1d1-38dc4f9462cso362164a91.0
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 09:32:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787329935; cv=none;
        d=google.com; s=arc-20260327;
        b=JmPsjiEgqlzMamC+tCMeZFiz0r/AewVQTgQj08CkDOWnOXg5yvmddmWSgDWLCRm8vr
         eq6PQk0OupsqD1g5I7lxDLAx+eOizI7TLxB/u4/6TC0A9BoIqEgraSrJGpRH8EfFExmc
         hF7MQ3L2tqosLM96UJEviMosF86WJdrAghhuASy3am4IUNAU02gsVB6xhdfX9M47crAM
         5OnPk19g4ptV9+FLjfhHDHZ5QPEUc7fvMgddX8frCxT+PMYVakwc9sF47A5qNTR4D2k7
         RFJdC8XixK5iGnh/KSSP3zqC6byTDiflS4kt8pLw+eIxZhH7i16/OX7lfAKqgeKkJqix
         wLBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uKrunJMg40NjeuxUGrFsyHBAkzDtHd4//4PJzcyrA7w=;
        fh=JOfgaPqyQhvZhlrH6YqYCuK3bFH25DdfNaXqKgSLQ0Q=;
        b=ZhZ4GjuoKgXIa9HN26bTYBbZY4eLORdV+5IPO4zpawjfMBnWUeBHj3bQyVgYagaWDo
         hJyxSjzrwCpTkLGo3FvGtG6nxxW17Kob/ekxyJ6zqBTe3bB10KqHjjz8RG0W3RCdu0Ml
         uDi5s2ePQTJXa5+wEDRBYrYKuSFIlczrtA48fDDJ0/I/oN90j5MKl7vrGgHd6nBr8iIM
         NJWpGWF34d6wsmKgm9E9aPbE4Zztsm2vmNrm/TaGCslcrbvURZznuHdVdiiz287vHi7n
         MZUqitdZVlvQOVz3uiVsO+R9H6Uf2WhCQk7jsy780FSmr2gZwmkGUxWpdW8vRr2ssmAH
         pvWw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787329935; x=1787934735; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uKrunJMg40NjeuxUGrFsyHBAkzDtHd4//4PJzcyrA7w=;
        b=rgJRJEExQclO5/g5teogxNemHukvtpV5d+qjBGb5uzhAFTZfFLr0A2VlmceqmRIRdm
         6ABEHTO2dywaQqfZRuMdfbFNqjLD+/Ihyr0++wh3Ie4J55G5+r8CnTzxwNabZME8kEVU
         WIig3VaEVIS+wDlHtIJBwYOWksJzBAM9pJZ38elFwD3+D6W2rrdbgZAUkYVxc90clC1T
         Dxp2BcFIBp+vQ9I31h0cVqHb7aDWu9VPB9tnEu0eImKrAnMOTxawY8SkT/Rb7Sui9C7H
         ECZuuxmXG8ZMy9de240WEcfKW7zJbbOUACyQ97SOf+LSzSRcGSE0227ymTt/cbByjeJI
         Cevw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787329935; x=1787934735;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uKrunJMg40NjeuxUGrFsyHBAkzDtHd4//4PJzcyrA7w=;
        b=OOtBPFIbkjo7VDpsIGJHZr8Qepcs3up0Ve32e+ZyjKdNyRubl1IlhVTOkCKCw3JSE7
         FdRB/QUYThgk09BOkli9Cx+BpYRcMqEj9l4z0/WzmaELJvzZauw9gm076A53TbigO1Xt
         m/I4VF1joqjqp9kT+OCCfQ5UK6CfgQ4/itiITnZtmaIOPovcqsYWENKFCc1wEWWt0ojm
         B2MaaOAh9Lvc2WsyuD8ZDuPkYJki5uUGs8VEN/PILG7e/XGtKlx16XIrPpmij6CyjodZ
         DYDSXD5Rprfvejc0an0cyYaoTuj5DRn8T+RNivVu7ZIkQ8aQG+aNFhMs1B9mgxOJtUCH
         6QrQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq05/CEFs3yRFoPF3QKnEDf8dbWzHY7grpFFnI09YmKGzKTUsH/NQOTGVuSIqOWUn1ZnRnDdKWbiA==@kvack.org
X-Gm-Message-State: AFuF++k4MRGjyZXejjx3djf0FiJZKfpSGPFhV/NREmEHyu0YUQhpRb44
	NtApdMuQVJ5VOd0cexH9xwIwi9B2cTk3QthpCfZH7g1qvV/6mutKxsdeYTNwgMJsJVRQB+Vv7wb
	J5ODXPeA+cDWLASASNjS4VuAhmQosHg==
X-Gm-Gg: AR+sD13AyGa0+QMVTsIyc/I9pSQECf1wUg86tFGalk8XyRGKgEs2jFlTxrpwpUmmFAn
	BkT9YIf6wamhvU723jpaLvCwKSO32wcaFxV4nh6bZCXwYNbtdRbMDqkACIe/Cv0Myu/3m2Q4iYk
	vfPYzzqGtb17clJgYLtsBlmDn/Scqy3eXg4Iiv63iFh64vjeoPcWqK7WV4k+vp2Vz/A3gWxdsrS
	tROCma6gezNXRP0g2I2w+C/Q3VW8XklUtJKnDb/q56ZR4hXiYb8CNtUG0Lt8AvmZkObyLuSrrIM
	4KbatD3QMCCEfiR8rRzfMN9EbitNgF9dle3UBnqmScn/QkIudxk1gAQp5dI=
X-Received: by 2002:a17:90b:55cd:b0:38e:97f0:aa4b with SMTP id
 98e67ed59e1d1-395c35f0a85mr14515030a91.13.1787329935050; Fri, 21 Aug 2026
 09:32:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260529165640.820-1-ravis.opensrc@gmail.com> <20260818073546.832476-1-kunwu.chan@linux.dev>
 <CALa+Y16xODsaFZDfh7ZeP3gWbycK92gvP5N8_NFpOvW=R2BWbg@mail.gmail.com> <CAN_Opa_h2W1hRimy2YXPC4EgueCi2UNwnZ5gSYV=cr8M7yfCmA@mail.gmail.com>
In-Reply-To: <CAN_Opa_h2W1hRimy2YXPC4EgueCi2UNwnZ5gSYV=cr8M7yfCmA@mail.gmail.com>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Fri, 21 Aug 2026 09:32:02 -0700
X-Gm-Features: AcwNN1W_2JZ34i4ktwhmNpUgZM8oH3GEFi2Bi6orDDuwSTf-FJjTXej5NTLTNnE
Message-ID: <CALa+Y15zNhpubyH5GQgu_BHesrwRdH0B8k5cqT3o_U0h5A2e-w@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] mm/damon: hardware-sampled access reports
To: KunWu Chan <kunwu.chan@gmail.com>
Cc: Kunwu Chan <kunwu.chan@linux.dev>, sj@kernel.org, akinobu.mita@gmail.com, 
	damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, akpm@linux-foundation.org, corbet@lwn.net, 
	bijan311@gmail.com, ajayjoshi@micron.com, honggyu.kim@sk.com, 
	yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: abuf8eiqgs4tepm1rz8ry4p8hz3khw9s
X-Rspamd-Queue-Id: 8C317140014
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787329936-6183
X-HE-Meta: U2FsdGVkX1/dax/RBNIOFO1F79FF/NA97/KN8LhfHNJ7GVlMx8GiPg/ZjDa8Cs1x2ZpBk/IqA9WbyzM9QeaFs8u82TydD59cKw8681FDhx6kqcfByEeZtC1fjAaadTZb5ieNcOWJGR2EHIi+FVH79X0pzM6PVZsEvy/tGTO2h0ZcE9lxSJZ4fv6zC4SpWPdHGfTYcNh74QrwXAvzIgWWHbJ85SHdHPEC3+r9YV/7omVMgP+GAYPOx3l5zkU/ALKJaF41UXd9hFQ1NyH1aZclupc1KwcZVztFASnrWOfTfFHLEKburBZYpnSI2BGYIFXMVBMFSD4GHWpNd4qwWOInMscAvayGOThQIvzJLH1CLHdNbX41p/uPL4MrI1bZXQ/6Kmio9UfIb6jptmqqyfdOQHb4YKj5k8oQ2MygApl9c4+HlGPiEGRhk5yMPpxJIv3OM1dmaE5I7cW1X2coLWhPKRx25VaX682votR0NvS9Uywghb/y+YkCxCUHZG6hhXGjQjIMl942mkMoRMYBfMPAuHNXH1pV5HglSmN5J/iK/MAsLt82rBTdwP11rBX1MBioTD0As+nvwQDkr3gsZmDx2/yHKmws7aj9FF8REnptVMhWjeAChsGGOasEwvq+vTtRg097Zt7+ijySKAfIxQERfwabgNBNivwC9L9aqICD0oAt4SdfKbmlYmqNZYDVY/NU6yAXAwgDOrhSj/iFD92fb53konrUMTyUHmloD1M+cLRiHT3Naqb4bXaHhr/+s7mbTUGUa7pp3KjS0wDPPZVucFsrR8gRfFM95thcIIgYatuT4nh2s9er6dSEWJENEAxK1ULSqNPhcE4/DbvLd7OalYcAgrkWUIde6ZupjGkK1U0l5E1bssDzQe+oPMrpr+41CNoIaH+4B7CdEW5la+cNT/lFFbYNxzGz80wSokud1qZmPMtExVBHDrJnmstMD3LyemmHetNFoZBTFS+MoFz
 IjA6Zwfr
 RP0HEsL8wRF88VVK+rYwKYw6OwL0EAVcKPHjFA+z7IgOovT0qWj52vIgXNjNgOoLaTBppbKCa+77kysO1o/ytW3M8EIxPFPn8H7mKGLyNFybiYoJI79tpsFeZgVlItJO9v4bxQp4OuU6U6zUX4xHeuYa4LQRqaOy2WJXxgUomp9unra77hu2RFy3x5IGZQbj1HctP11csNw1WGvkG8NigcaoI5SD7eSjU+wpa3anPYCy8sf1plz12pu7khzwIdei7uwdlO/izpwI3e4ATlxsmTTt3EZEul+ywIHsXjD6q6iW+Ho+F5M47e0mQ9TQYOQhey+wclsrjBu8OTZHntSLbKsurq07jIt9pkDZTOwZaNncYKPxX1hD781KqLbgi7VCGOvMQo1Ih5CyAr2MH9AfaClyST/ZJ6aeOun5GDreFYsE2txCKK1RT78CvnaB186eHweEdEmFODwNo6hbc8Qvp/resI8aO/6Bpjh8TOxEoppjbm2Fg6Y8SO4uZ50YqdwWkmmy7cBxpTRJ0Mlo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 2:55=E2=80=AFAM KunWu Chan <kunwu.chan@gmail.com> w=
rote:
>
> Hi Ravi,
>
> Thanks for the detailed reply.  The fan-in diagnosis makes perfect sense.
>
> > Your series is based on the v1 substrate, and the way an event is
> > configured is the part that moves most.
> >
> > [...]
>
> Glad to hear v2 is on the way.  The probe-based model is actually
> something I encountered while building the AUX backend. When multiple
> sources can feed the same region (e.g. PTE scanning + SPE/IBS), the
> question of how to combine their reports becomes interesting.
>
> For example, CXL tiering may care about physical-address locality, while
> per-process monitoring may need virtual-address attribution.  How do you
> see probe weights being determined =E2=80=94 is that expected to be
> scenario-specific, or is there a more general principle behind the
> weighting?

Hello KunWu,

SJ can answer that authoritatively -- the probe and weight interface
is his. Here is my understanding which SJ can confirm later:

Weights are relative, and only among probes. A context can hold up to four;
each report carries its probe index and credits that probe's own hit count,
so two PMU-based probes in one context are scored in proportion to their
weights, and that is where a scenario-specific choice belongs.

What does not mix is a weighted probe with the other two sources. Any
nonzero weight switches the whole context to probe-weighted scoring, which
turns page-table access checking off -- so SPE cannot be blended with PTE
scanning, it replaces it. Page-fault reports carry no probe index; they
credit the region's access rate but have no hit count, so under weighted
scoring they are not part of the score either. Both coexist with a probe
only at weight zero, where everything feeds the same access rate and is
indistinguishable afterwards.

So for your case I would read it as: PA locality and VA attribution are
different targets and different address kinds, which points at separate
contexts rather than one context with tuned weights.

>
> > 2. The 67.9% drop rate is fan-in, not sizing
> >
> > ---
> >
> > [...]
>
> I completely missed this.  The observability framework showed the
> symptom (67.9% drop) but got the root cause wrong =E2=80=94 it's not a ri=
ng
> sizing issue, it's a fan-in problem.  With a single kdamond thread
> draining the per-CPU sources, the samples effectively get funneled
> into a single ring, which explains the numbers.
>
> The per-CPU drain approach using `system_percpu_wq` and `queue_work_on()`
> looks like the right fix.  Our AUX backend already carries a CPU argument
> through the ops, so adapting it should be straightforward.  I'll take a
> look at your v2 branch and re-test with the per-CPU drain.
>
> Two questions:
> 1. Is `damon/perf-rfc-v2-08-20-26` ready for me to rebase the
>    AUX backend and observability framework on top of it?  I'd like to
>    validate the per-CPU drain fix with real SPE hardware.
>

Yes:

  https://github.com/ravis-opensrc/linux.git
  branch damon/perf-rfc-v2-08-20-26, tip 9c0410564596

That is the branch I used to exercise the AUX path. It carries all five of
your AUX kernel-consumer API patches unmodified, and from the SPE series,
patch 1/4 plus the generic half of 2/4. 2/4's SPE backend and parser, and
3/4 and 4/4 which test them, are SPE-specific and I used an x86 box
with virtual PMU.

The branch is force-updated post fixing two trailers please re-fetch
if necessary.

None of it is meant for my v2 posting.
This branch is only the vehicle for testing the AUX report path.

The SHAs you will care about:

  808519650a7a  the per-CPU report side
  e3323a3bdc75  your AUX interface, ported to the probe model
  1c347519c626  parse each CPU's AUX buffer on that CPU
  9c0410564596  perf/core: balance the AUX buffer reference on kernel
                release

1c347519c626 drains with one work item per CPU in the event's cpumask, via
queue_work_on() on system_percpu_wq -- system_wq would not do, being
unbound it silently ignores the CPU targeting.

Two things came out of a quick test in a VM:

- spe_backend_init() calls perf_event_setup_aux(), but I could not find any
  path calling perf_event_release_aux() -- spe_backend_cleanup() frees only
  st->win, and your kerneldoc says the release must happen before
  perf_event_release_kernel(). Left alone on my branch.

- 9c0410564596: the explicit ring_buffer_put() in perf_event_release_aux()
  is one too many, since ring_buffer_attach(event, NULL) just above already
  drops the event's reference.

> 2. For the probe-based configuration, does the `prep_action =3D "perf_eve=
nt"`
>    model preserve the same event lifecycle?  Our AUX path needs to create
>    and bind the event during apply, keep it disabled initially, and enabl=
e
>    it when kdamond starts.
>

Yes -- created disabled during apply, bound, then enabled. Per CPU, on the
kdamond turn-on path:

  perf_event_create_kernel_counter()   attr has .pinned =3D 1, .disabled =
=3D 1,
                                       so the counter is installed but not
                                       yet schedulable
  ops->init(event, cpu, perf_event)    your backend attaches the AUX buffer
                                       here, via perf_event_setup_aux()
  perf_event_enable()                  only now can the PMU be scheduled in

So the buffer is always attached before the counter starts. If ops->init()
fails the counter is released without ever being enabled.
kernel/watchdog_perf.c uses the same pinned + disabled-then-enable pairing.

Sanity-tested both report paths in a VM.

Best Regards,
Ravi.

> Thanks,
> KunWu

