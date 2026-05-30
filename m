Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB0D1CD6E4A
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 05:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9608C6B0005; Sat, 30 May 2026 01:03:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 911AE6B0088; Sat, 30 May 2026 01:03:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8002F6B008A; Sat, 30 May 2026 01:03:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 69D346B0005
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:03:41 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E0E75C1591
	for <linux-mm@kvack.org>; Sat, 30 May 2026 05:03:40 +0000 (UTC)
X-FDA: 84822893400.30.D4F0000
Received: from mail-dl1-f67.google.com (mail-dl1-f67.google.com [74.125.82.67])
	by imf14.hostedemail.com (Postfix) with ESMTP id DA0DC10000F
	for <linux-mm@kvack.org>; Sat, 30 May 2026 05:03:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BZECnotK;
	spf=pass (imf14.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1780117418; a=rsa-sha256;
	cv=pass;
	b=Rx+XFwpRWrTxoEgm8acypfF0BbuyhZUYEDF8gSyL16SNiWT5mU4C5xGYTACsUdgBnhkKQH
	SasNnDAxBf7n0MHDatkoCPMVEFOO3FWCf+qAvG1JeeBXDk76HLtiWOC+BLZK4+2VRdITfJ
	k6gwFHe8EICFO01UIV79piGb1Qw/JQ8=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BZECnotK;
	spf=pass (imf14.hostedemail.com: domain of ravis.opensrc@gmail.com designates 74.125.82.67 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780117418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9n5VFTrMNd6YBtbd1bShwa8dQ8GLzFxXej7zql3nMRU=;
	b=n2r1UxmCUSc+6Q/j0vswdaUILhQI7GDrJreNTT2UVUtioOMNabxaDVMkvPldxH2QDco6Nm
	STGDUg+Yfs92VWwee7Zxl2gDs5/8/X+5dK5HuRkzCZeWy2TYvx983DqBA4XGFhSp34aw+4
	aNAjB1h3KEs4Chj+bQDUrtcfV2Wfr1k=
Received: by mail-dl1-f67.google.com with SMTP id a92af1059eb24-1378943cd4aso4820203c88.0
        for <linux-mm@kvack.org>; Fri, 29 May 2026 22:03:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780117417; cv=none;
        d=google.com; s=arc-20240605;
        b=a/jjU0yoVjYZ8A3rPiiFEMxK3Ll03nt9h/X3TJZmfjB2i4WmCPWqYuVg6Nx9qn3P7F
         2aBepyREH3f/SO9oueNSSbucaTCc0zn6p8k9WPKbt15+LNPmZBP9RGqzGCIuxtIOsphn
         NcPxzrP+hhH4LwtdeMLb5eRMq/2WZiTAyqjTSxGVhWMLMn1Tlye6u2YdgwqTUpWEJ1jT
         9j/aUNXp5V/BO1s54Vzh4E5AZtVu2+W1n3golkve6RN5wYsuDVJGLe58T1wAzv7+2X0L
         A0Qne2tC0kauB4Gyo33iOoZ75qbY29Lm7YhOSVSXWiKr7P5C8M4v2JBKDDAQRW9J/3u5
         7Kfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9n5VFTrMNd6YBtbd1bShwa8dQ8GLzFxXej7zql3nMRU=;
        fh=5vEq++UPJIYrIocqqwicmfXt3dpp9vhhNBnF8eOcFiM=;
        b=g6/qrIUjVvargOnyfb4Ag5b9i0nBSwiMcOLiNYLn6fhKJJpk4uvB/g+GVlMAQ4rsZD
         DieZRoX/vImKRApRuITbs9BCCNvxffkJZEQIJum+76Z6WBCTB5aReC+NLsmNWADozwdh
         flmOL8DySgXwXqUCFlsDgt8MP3Xh3wxpoeQiJ+F6fFmJDokQ9wT7XqDoWEIUCKdQVqPo
         8RhsvSZrNsHNTxktkHOUZWMxxPJSQT5/nIeQXepjb17NVe5qxOqCkrCRlqXvIvRO2uC8
         hz2WDfSRmMkDrI1cMz8okc6yRgGRA0uKypn3Y31NxF6t/SrvcvDl0ynEquAbIP6F6RG3
         um5Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780117417; x=1780722217; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9n5VFTrMNd6YBtbd1bShwa8dQ8GLzFxXej7zql3nMRU=;
        b=BZECnotK2ewYG2beGuC6xYu9YCDFuc2gLRS8j1PZEhNzV+4U7vMvtuSWlM51b09jW3
         YNv6SQM0UyQW/acbpYaO4MpETt6XveabSS//eMmqrFdSOqYg65ymirw9WzU6s40LuAPd
         1i+pcde6BeepH2EBEGIPWY5X+B6eXhWB5gPjXXLnvBEbXQfSMocLOwO3l9xNRZCeNJKt
         Q7X91ormyvi58T0ffq/JyTVhglnQf70RFK1JYaIAw9DCIfyu6YiGoUnELIHKKggwhjE3
         uWz6LknNsQAwA5U9GC6nx51qoDYXpEKbV8zwQdfgdAIkI/w/69TRNDT3kYAfhD000o+G
         UERg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780117417; x=1780722217;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9n5VFTrMNd6YBtbd1bShwa8dQ8GLzFxXej7zql3nMRU=;
        b=dM8B9/ylqd4suupOzsKAiumebeBDURi7wISxTjA4zaTVcDHlAEhE+6dHTJLzoO2jQg
         vfmnEW95atCZQOTU9abWWDZiFBXNtaccud1i0uDSPA/zF1mEtL8+EcFs3be0z6rUbEOX
         //FvHP45YuBompvEaYdP1tu/SoBpEHjavAcEkJAZSBLj6RDq/ygI4teakh1RwywGYr67
         eqmWc0B/Rces/sNPji6+7AufYzK85od/zAbmI2CmW4KB2ltncqYzuqLgHyO83qTsa7Qv
         SyUKYG3tEz8cWRlt9lDCTux2QYCgiaw1KwERtthCwjlnjXmv//+8uPyMvUQT2BmnbKel
         DwKg==
X-Forwarded-Encrypted: i=1; AFNElJ9k+SkzvkrygCrBJO+PISVOQfJ+PVvrRlCqunZyXQCJQ07aenIa4wpGixLuPyYMnG4Ed/OxuC2PQQ==@kvack.org
X-Gm-Message-State: AOJu0YyfenA3E8N+nhNgfepuvXQNWmZYpUlo58LpTtdhR8RZlisWBFRH
	c54R7fxvzDzx94BBz+q+fxzl2hWbuCVBXXRgE2Uw/lajGMd3gotEJg1q36bMKrdfSMqmeJuz1px
	ppppzD2BoQ2xwhDwBmNCTtlrnR4vmMw==
X-Gm-Gg: Acq92OFTsWq8lnusC2LdpZD/6xVcVh4YhwU5ZzjdP8/UbgrUz84fWCXdnV6JzEIiM32
	q+7JvvPyoOcqY6t8SgjqfLRwJUI8Kyh6Zq4D2CYA1NNHvJGkFRGQVypNeC6Va9de5imiH11lNLp
	GwLSmgFlalqLBVjMc6FaD4n63w/KnEFvaFYqs3mhOuNyH5veuJub9OlDqP+izPpsC4w4OGQ2faX
	LBpRCPHt+NCKPaBDAYaT/OSr3PcVEEB4w7EL9xV4dkrD5pFZ+o/Eqz8A34weVCpNRcimzMchw4z
	dzSKMdSGCDUC/2MSVg==
X-Received: by 2002:a05:701a:c96f:b0:136:9ebf:3c04 with SMTP id
 a92af1059eb24-137d42618c3mr1072346c88.25.1780117417296; Fri, 29 May 2026
 22:03:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260529165640.820-1-ravis.opensrc@gmail.com> <20260530000500.87407-1-sj@kernel.org>
 <CAC5umyhej9QKKOHcf5bbRw97gsoOfEOMLkpcAk-Lm_fL-4rHgA@mail.gmail.com>
In-Reply-To: <CAC5umyhej9QKKOHcf5bbRw97gsoOfEOMLkpcAk-Lm_fL-4rHgA@mail.gmail.com>
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Date: Fri, 29 May 2026 22:03:24 -0700
X-Gm-Features: AVHnY4JXS74PTwdU7Sx8vuVmvj4oiQo1ykOiRjgSM_AC7ERSn1VNxkdT75L30-A
Message-ID: <CALa+Y15eREjK-bdw1ekpp95tkjT+KJ-133GjvVENC-=TmVKsxw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/6] mm/damon: hardware-sampled access reports
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: SeongJae Park <sj@kernel.org>, damon@lists.linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	akpm@linux-foundation.org, corbet@lwn.net, bijan311@gmail.com, 
	ajayjoshi@micron.com, honggyu.kim@sk.com, yunjeong.mun@sk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: DA0DC10000F
X-Rspamd-Server: rspam03
X-Stat-Signature: jepdjwzham9qr5396576zj3i44wq6rch
X-HE-Tag: 1780117418-783146
X-HE-Meta: U2FsdGVkX1/wSxfHFL7CNNAvA3IXda7QLO/fBCx8e3WjZ8sihY9YyUtNuOB7eHuENTABxAkxdYpxJGioiAkXLe/VQV3UBCBZTIAo5JR+uiW6+48D2EUPwNijZqSLZWXcsVzxYyrJ9JdLCV8ONbXY3EXIfdv+b9vV0NXHamjK1L4xg0O9Cm7myVpMHQPOXAHkX/8SdRSY3+O6Qz8wwVbc/kRTHut1dXBF46puBkWbh/mc6bS74NNg/4Pths/sGb/p2h4L9V1CjU247nRd9pW0ilKMpZrQ4xbcw9e9YNh24ATSwSc9wrDQyS2vISLhV7YEZIBaRQFed0tN9BkkBS7NjGBYsbk/SQMAz+PbW5VA3OJjyxw9kyQzdR4bXcla71x/2dUKslPo8G1/IxXduFBkEGvWpCEuSUtfDC4WRK2L3nSGNsnvw0dm8mzUcjBKEVsrHjm23SuA7FmFM1X+gOcvEcxTvMF1LlxGr2sxpWK/QgTRU50kSw1JynDTVRAxmrb6c9qdtF7sE3mkXr+k60Ym96XZIZHx4nY90p5Q1Jfknt63xLcdgQ6/ckFSxsHsuKv01Mq7tl45bstMrOP0Sc2+WGz0JfOcTfDXHDH5F5dvBxIO2j8mH/uOLIrdMWSdSGFAx3NaykuMFthGb+tVUyLHAoIbBxNUiE7SFEkpIoDcI5sy3cLEEi+mBKcrw0DoJKlsfRsPzUjcJBZ59TTW7snN9vaDqsUwIPB9Y9GCAQxAIAIP6JKr4AeyJWiXCeBjftoqJM15KWAZLCHBXdVBuB71012ks6ZTXj7M3PdT+EOLu9iD7F4iqTUw+ulg43v6KQFyEo3W50KGQxApQAzLvYwHrM+223Rc66we0rduEZbiL467aK0SsOh2I8GDbH3a6UrecHVd43VJepZZOqkZ4Xhm/HyscR/OFRn9yTDUOgGFgnAO1e/COPUnXp+MuccU39pFiC4k8AIuwZXgSZv19eW
 n6o+Enq5
 lbdG1KZ91v/W2lJtIoWrDkERmxgxapQ8ibEsXULO4Qm8LylF3aygq1QbyWJHZWz5+GrNDsl3PpJN3NxCrbC+J8zyd++EV13aOTCwCoyry33W1VH++2+jRfMA9Qd2DVTJe/+AR6Q31KL8LdXh6KMSjGyP9tvF46y5++ImFjQSUP7ghY8vf/x3g9jcf/76FQjmn0swzAHc0OowjlXsFA9kX9MkCHyQyS/ggcPYrLn96ZI49pRrWHAidK0C8hQdGdOC5pznvdb8rg7Tz+bbcL4IoxxvLuE6cShUNEjy6WRgSf0tkUtPxtPVMzOqZQGKOM0owQrmhEtWMnn93Y6hsbfLfav58vb1Pb78qSaV8iCjSIPuk6WeHJApFvgkIlNfH8w4DH4gY/4IVysu4Wjxe1FqpmuwciKsMl9zPdIGEM+5NnQhxH7Uo0Yh6D04YePY6GQZCCcwOcGl3dvGX0JPgGeib2pHvJmkJVlxEovJ9I46bvXG0h3o8D0yfa2o/ay2I5FyYkGilKODj/+TjDkpAT9nxcVCvxeSI/BmKmWf0u4+2vL0ViSNWsRxQTL3c4t/AIpl2RZR0e6PUxBPWuTYslt3lF0KpJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae and Akinobu,

  Thank you both for the warm reception and for the clear direction.

On Fri, May 29, 2026 at 8:02=E2=80=AFPM Akinobu Mita <akinobu.mita@gmail.co=
m> wrote:
>
> Hello Ravi and SeongJae,
>
> 2026=E5=B9=B45=E6=9C=8830=E6=97=A5(=E5=9C=9F) 9:05 SeongJae Park <sj@kern=
el.org>:
> >
> > On Fri, 29 May 2026 09:56:34 -0700 Ravi Jonnalagadda <ravis.opensrc@gma=
il.com> wrote:
> >
> > > This series introduces a vendor and PMU-agnostic substrate inside DAM=
ON
> > > that consumes hardware-sampled access reports through the standard
> > > perf-event interface.  Userspace selects the PMU through sysfs (raw
> > > type/config knobs), driving either Intel PEBS L3-miss sampling or AMD
> > > IBS Op sampling.
> > >
> > > Why a unified perf-event substrate
> > >
> > > Earlier hardware-sampled access-monitoring proposal [1] took an AMD I=
BS
> > > specific module path backend, owning its own probe configuration,
> > > sysfs knobs, and lifecycle.
> > >
> > > SeongJae Park has previously highlighted the advantage of Akinobu
> > > Mita's perf-event proposal [2]: let DAMON register kernel-counter per=
f
> > > events and consume samples from any sampling PMU that perf core knows
> > > about.  This series builds on that direction
> >
> > Ah great, so we have no unclear challenge (additional loadable module s=
upport
> > and conflicts with other IBS modules) on our road for now!  That is, we=
 can
> > reuse the stable perf event interface and achieve all our goals!  As I
> > previously shared [1], it would take time, but I'm very optimistic abou=
t the
> > success of this project.  I don't like promising too much, but this pro=
ject
> > looks like something that we can "consider it done".
> >
> > We can also say that the current candidate of the first
> > damon_report_access()-based data attributes monitoring (milestone 2 [1]=
 final
> > deliverable) is the perf event based monitoring.

Glad this aligns with the milestone roadmap.

>
> That's good!
>
> From a quick look, it seems to have all the features I need, so I'd like =
to
> evaluate it based on Ravi's patch.  If any extensions require changes, I =
will
> let you know as feedback.

Great, please do.  Happy to fold any feedback into v2.

>
> Ravi,
> You can also add my Co-developed-by and Signed-off-by tags to the appropr=
iate
> patch, so please post to the mailing list.
>

Will do.  In v2 will add Co-developed-by and Signed-off-by tags
  to patches 1, 4, and 5:

    - Patch 1 (`struct damon_perf_event{,_attr}` + per-ctx list)
    - Patch 4 (per-CPU SPSC ring drain + perf-event lifecycle)
    - Patch 5 (vaddr/paddr perf-event backend)

Patches 2 and 3 are the sysfs surface that will move to the
probes/filters interface; patch 6 is the unrelated
`damos_node_eligible_mem_bp` tracepoint.

> I am currently working on a change to allow selecting perf events from th=
e damo
> tool by specifying the event name, similar to the perf record -e option (=
e.g.,
> "cpu/mem-loads,ldlat=3D30,freq=3D5000/P" or "cpu/mem-stores,freq=3D5000/P=
").
>
> I'll share the progress once it reaches a certain point.  A change to the=
 perf
> file, as shown in the attachment, will be necessary, but I believe it can=
 be
> handled without changing Ravi's current patch set.

Nice. When the damo side is ready I will rerun the existing AMD IBS
and Intel PEBS configurations through it.

>
> > > with the changes we
> > > needed to run it cross-vendor:
> > >
> > >   - a per-CPU lockless ring between the NMI sample handler and the
> > >     kdamond drain,
> > >   - per-CPU events that follow CPU hotplug cleanly,
> > >   - events fire only while the monitor is running -- created disabled=
,
> > >     armed when kdamond starts, disarmed and drained when it stops,
> > >   - all-or-nothing init across CPUs: a partial-CPU create failure rol=
ls
> > >     the whole event back rather than leaving silent gaps,
> > >   - safe handling of vendor sample-validity flags so a stale or
> > >     unpopulated address is never mistaken for a valid sample.
> > >
> > > What the series adds
> > >
> > > Patch 1 introduces the substrate's data types: a per-event
> > > configuration struct and a per-context list to hang them on.  A
> > > CONFIG_PERF_EVENTS=3Dn build folds to no-op stubs.
> > >
> > > Patch 2 exposes those types through sysfs.  Each entry maps to one
> > > perf event and lets userspace pick the PMU and how to sample it: the
> > > raw PMU type/config, addressing flags, and period or frequency.  The
> > > defaults are tuned for Intel PEBS; userspace overrides them for other
> > > PMUs.
> > >
> > > Patch 3 wires the sysfs apply path so configured events get attached
> > > to the running monitoring context.
> > >
> > > Patch 4 is the core of the series.  It replaces the mutex-protected
> > > report queue with a per-CPU lockless ring fed from NMI by the perf
> > > overflow handler and drained once per sample tick by the kdamond.
> > > Drained reports are matched to monitored regions by binary search
> > > over a per-tick snapshot.  The patch also wires the per-event
> > > lifecycle into kdamond: events arm when the monitor starts, disarm
> > > and drain when it stops, roll back cleanly when per-CPU init fails on
> > > some CPUs, and a second context that asks for the substrate while
> > > it is in use is rejected with -EBUSY.
> > >
> > > Patch 5 is the perf-event backend.  Two stateless overflow handlers
> > > (one vaddr-keyed, one paddr-keyed) are picked at event creation time
> > > and submit samples into the per-CPU ring.  Vendor-specific sample
> > > validity is honored at this layer.
> > >
> > > Patch 6 adds a tracepoint at every node_eligible_mem_bp quota-goal
> > > evaluation so userspace can watch goal convergence without polling
> > > sysfs.
> > >
> > > Userspace setup model
> > >
> > > Userspace selects the sampling PMU by pointing the perf event's
> > > `type` / `config` at it, and chooses the scheme topology that suits
> > > the address space the PMU reports on.  No module load or unload step
> > > is involved; `echo on > state` arms the substrate, `echo off > state`
> > > disarms it.
> > >
> > > Two configurations were used for validation.
> > >
> > > Configuration A: AMD IBS Op, paddr ops, system-wide PULL+PUSH tiering
> > >
> > >   IBS Op stamps samples with physical addresses, so DAMON reasons ove=
r
> > >   every backing page in the system regardless of which task or guest
> > >   touched it -- the substrate becomes a system-wide tiering controlle=
r.
> > >
> > >   Setup (abridged; `D=3D/sys/kernel/mm/damon/admin/kdamonds/0`):
> > >
> > >     echo 1     > /sys/kernel/mm/damon/admin/kdamonds/nr_kdamonds
> > >     echo 1     > $D/contexts/nr_contexts
> > >     echo paddr > $D/contexts/0/operations
> > >
> > >     # Two regions, one per NUMA node (DRAM + CXL).  PA ranges
> > >     # are derived per host from /proc/iomem; omitted here.
> > >     echo 1 > $D/contexts/0/targets/nr_targets
> > >     echo 2 > $D/contexts/0/targets/0/regions/nr_regions
> > >     echo <DRAM_LO> > $D/contexts/0/targets/0/regions/0/start
> > >     echo <DRAM_HI> > $D/contexts/0/targets/0/regions/0/end
> > >     echo <CXL_LO>  > $D/contexts/0/targets/0/regions/1/start
> > >     echo <CXL_HI>  > $D/contexts/0/targets/0/regions/1/end
> > >
> > >     # IBS Op event, period-based, paddr-stamped:
> > >     PE=3D$D/contexts/0/monitoring_attrs/sample/perf_events
> > >     echo 1 > $PE/nr_perf_events
> > >     echo $(cat /sys/bus/event_source/devices/ibs_op/type) > $PE/0/typ=
e
> > >     echo 0      > $PE/0/config
> > >     echo 1      > $PE/0/sample_phys_addr
> > >     echo 0      > $PE/0/freq
> > >     echo 262144 > $PE/0/sample_period
> > >     echo 0      > $PE/0/exclude_kernel
> > >     echo 0      > $PE/0/exclude_hv
> >
> > FYI, and as you may already know, the current plan [1] is to use the at=
tributes
> > probe interface.  With it, the above IBS Op event setup part would look=
 like,
> >
> > mon_attr=3D/sys/kernel/mm/damon/admin/kdamonds/0/contexts/0/monitoring_=
attrs
> > echo 1 > $mon_attr/probes/nr_probes
> > probe=3D$mon_attr/probes/0
> > echo 1 > $probe/filters/nr_filters
> > filter=3D$probe/filters/0
> > echo perf_event > $filter/type
> > echo ibs_op > $filter/perf_event_type
> > echo Y > $filter/allow
> >
> > Of course, more details could change later.

Understood. will hold for milestone 1.

> >
> > >
> > >     # PULL scheme: migrate_hot toward DRAM, gated on
> > >     # node_eligible_mem_bp(nid=3DDRAM) goal target_value=3DTARGET_BP.
> > >     # addr filter restricts source to the CXL range.
> > >     # PUSH scheme: migrate_hot toward CXL, gated on
> > >     # node_eligible_mem_bp(nid=3DCXL) target_value=3D10000-TARGET_BP.
> > >     # addr filter restricts source to the DRAM range.
> > >     # Both schemes are migrate_hot; they converge from opposite
> > >     # directions on the same hot working set.
> > >
> > >     echo on > $D/state
> > >
> > >   Userspace tunes the steady-state DRAM:CXL split by writing the goal
> > >   `target_value`s; DAMON's quota autotuner drives migration intensity
> > >   to match.
> > >
> > >   Workload: a QEMU/KVM guest pinned to one NUMA node, running 32
> > >   multichase multiload threads each touching a 4 GiB working set
> > >   (~128 GiB aggregate) with the memcpy-libc kernel.  The guest sees
> > >   a flat single-NUMA layout and has no direct view of the host's
> > >   tiering topology, yet its hot pages are migrated to DRAM and cold
> > >   pages pushed to CXL by host-side DAMON acting on IBS-stamped
> > >   physical addresses -- the application inside the guest benefits
> > >   from tiering it never had to be aware of.  Validated on AMD Turin
> > >   (132-CPU EPYC).  The configuration converged to its target ratio
> > >   in seconds and remained stable for 7+ hours continuously, with no
> > >   perf core auto-throttle and no measurable drift in the achieved
> > >   interleave ratio.
> > >
> > > Configuration B: Intel PEBS L3-miss, vaddr ops, per-PID weighted-dest
> > >
> > >   PEBS reports vaddr samples in the context of the running task.
> > >   DAMON's vaddr ops monitors a specific PID.
> > >
> > >   Setup (abridged):
> > >
> > >     echo 1     > /sys/kernel/mm/damon/admin/kdamonds/nr_kdamonds
> > >     echo 1     > $D/contexts/nr_contexts
> > >     echo vaddr > $D/contexts/0/operations
> > >
> > >     echo 1     > $D/contexts/0/targets/nr_targets
> > >     echo $PID  > $D/contexts/0/targets/0/pid_target
> > >     echo 0     > $D/contexts/0/targets/0/regions/nr_regions
> > >
> > >     # PEBS MEM_LOAD_RETIRED.L3_MISS, frequency-based, vaddr-stamped:
> > >     echo 1      > $PE/nr_perf_events
> > >     echo 4      > $PE/0/type           # PERF_TYPE_RAW
> > >     echo 0x20d1 > $PE/0/config         # umask=3D0x20 event=3D0xd1
> > >     echo 0      > $PE/0/sample_phys_addr
> > >     echo 1      > $PE/0/freq
> > >     echo 5003   > $PE/0/sample_freq
> > >     echo 2      > $PE/0/precise_ip
> > >     echo 1      > $PE/0/wakeup_events
> > >
> > >     # Single migrate_hot scheme with two weighted destinations
> > >     # (DRAM + CXL).  Userspace tunes the steady-state interleave by
> > >     # writing dests/{0,1}/weight.
> > >
> > >     echo on > $D/state
> > >
> > >   Workload: 32 multichase multiload threads with a 4 GiB working set
> > >   each (~128 GiB aggregate) running directly on the host, monitored
> > >   by DAMON via the multiload PID.  Validated on Intel Granite Rapids
> > >   (144-CPU).  Convergence is fast and the system is stable.
> >
> > Thank you so much for sharing the great prototype implementation and te=
st
> > results!
> >
> > I will try to make fast progress on milestone 1.  I will hold reviewing=
 details
> > of this series for now, as there could be more changes.  But in the hig=
h level,
> > this looks promising.
> >
> > >
> > > [1] https://lore.kernel.org/linux-mm/20260516223439.4033-1-ravis.open=
src@gmail.com/
> > > [2] https://lore.kernel.org/20260423004211.7037-1-akinobu.mita@gmail.=
com
> >
> > [1] https://lore.kernel.org/20260525225208.1179-1-sj@kernel.org/
> >
> >
> > Thanks,
> > SJ
> >
> > [...]

Thanks,
Ravi.

