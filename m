Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D38CCC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88D5A6B009F; Wed,  9 Sep 2026 09:18:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83DD76B00A0; Wed,  9 Sep 2026 09:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 753DB6B00A2; Wed,  9 Sep 2026 09:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4500B6B009F
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:18:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9CF131C12B3
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:18:27 +0000 (UTC)
X-FDA: 85194277854.13.23F9667
Received: from mail-yx2-f12.google.com (mail-yx2-f12.google.com [74.125.224.140])
	by imf20.hostedemail.com (Postfix) with ESMTP id C20011C0004
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:18:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MpIaOO0c;
	spf=pass (imf20.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788959905;
	b=HTkAvLfsvM189+tRzVdOeqeE/0QQSXVnnPVc5UKcJ4hrDPokxrIlGTRFWbAYgO4Uo6gf8D
	ZbZ0UsD+4Y14Q1qwv0BaXgjzT6LB5pMt7A26OrIUJjnWKEQFn4XgOqrh4hHMKXw0KLtYG7
	rNBXI0P40sxPEtbCSQH5rDH+sOWhFnI=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=MpIaOO0c;
	spf=pass (imf20.hostedemail.com: domain of sunjunchao@bytedance.com designates 74.125.224.140 as permitted sender) smtp.mailfrom=sunjunchao@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788959905;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dB9s3FYZowUuXLZgEMY+0LbMoABpg3BhWeFIHXgpTgA=;
	b=Hew8KPIcrsgm7cLhXCkqRdEK+kglYykK1Sz/LwmUsuZtHB1hH0Qw4WtGqXo7cN6ge+brAU
	kSBqPPynCkkiiPGUvKdjy6nAdVlCOR/JvzRcxr5EAbndq8mIhL/Yi4eVhj1batyi/GVOB0
	fLcNHXhEOpGL6aAYuWiTa/lgqeTXXlA=
Received: by mail-yx2-f12.google.com with SMTP id 00721157ae682-85d4eb63f0aso13025457b3.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 06:18:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788959903; cv=none;
        d=google.com; s=arc-20260327;
        b=sD9xcEMA5n3GhU07S+LpovlDyoYeQXq+5DFDoY5rBNHZoLivwjJUSayDVh1LO4Wqf8
         VnAbenuWqZ6FGn020N3ZrHaPefQ60jB7iSxnxmKI+eDpZn06IW7LYqTeWmMUuSxp3/+T
         wcvxlPiSRumYxxYmJt9pHwA3o/ennrQKwYaMdgBR9ocqxHn3Y8Lk+iMvtnvo6yOQp1I2
         VqgEW80gFy1KwlrIemejxoU60CMzQ9ox47Zrj9s8UaQZrKET81gBYzxsKndEq68ExGPD
         VTjN9Ps1xba1tVKZCkOjZEjLFVsFUz6NK/B8ynT81A+eE8Z5Jhp0H7swtMiLHZpYAT4b
         Bybg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dB9s3FYZowUuXLZgEMY+0LbMoABpg3BhWeFIHXgpTgA=;
        fh=UTjlEAtHeLp4BELgHeuEjnh51+jO4ZRGaRK5QME5pk0=;
        b=dyHRREll8GM/jeldmu1Y4XYc9h9zQxQvYcDjbnsheOAAHqyUjSY8tP8nHUeaiZfxwK
         1cKKXCrN0vsQS6xX+tftbXJXXsoE1MEAXrGpMpf7FeFq45J1LxFXeiw2QSNPWPm/xO3/
         dmPHj9QdTAa6RhiYyIg4678lmtudKwgkJVFKHmcDQ3r+nzMIo7BDD0zQb04TbvO2GWa8
         HbxNlMH8hMnmp/pOJ7B2V11b9d9dBSeNJqXDxd/Ofq72L7pC1avsgY+FFpVjajmOPcsE
         udfIHdNf3fV63m7o17t+tkIPfdFQwuTMpSeuhG5zsofm+BXQTJ5UEiw+7Iua4ud0RACy
         iT5g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1788959903; x=1789564703; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=dB9s3FYZowUuXLZgEMY+0LbMoABpg3BhWeFIHXgpTgA=;
        b=MpIaOO0cWwZN66qa5nf2Ns+dG+aeg6o4wzxoi7i82J7h3M9maiYK19PepHnI4+Td+z
         DVb4sjGvqHd7Y10D2t5yCxDadoM1Ro26NzPIe5vaPGyaYwcTbE6aGJSfZTEzedI2B1uq
         oqnkcy8zRICRjoJOcMiKVtP/7aNWKGPnU9UJ6D4GbS3OwV4Mb6tKROnVi9yv4EwT8FQN
         b80jgW4hKZRANVoDbgOQm3tyqw+qOrkiaR7bFkvTUGKLiIeYGyKZ400rBUvmpCZ3GdtO
         VDqZ2uEg4aBtCqOp1j2qt0hnLHUGMJGm46RsqAsy5vLNjaoYLGZpKDyDUkmgpGMMI2je
         RN/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788959903; x=1789564703;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dB9s3FYZowUuXLZgEMY+0LbMoABpg3BhWeFIHXgpTgA=;
        b=bLi6W/a59ctSUPFF1fGo9nJ0jmAu0KAU7rqvR6upGHNRqhS+xZVKaefDL6OrfKHDiz
         Fl9RnYz7vjcLu4cZpkI9fO+cl8EkhmigediqXG8UdPWKkS/txV+4w0hUur6qXYe52Vhz
         FHysiZe3Q88sLAQhbD1OVEhmDV+vRerQiQ9QoHpzQJqiFtwlDIlIEoYlMAXEMyU+UqWI
         gM6cAhDPpzCyz1I4pkhJf5Vek2GUDaRPau5VEzgBq0C59xyCFzDfj4UQIvQq/M3GNr6x
         APrMQ6RVHf/7tSW77EkbOKMgs5ZXoD7qRBoCkfDI1dE4/gliLfWUfUBiOBu9qOyiLzMg
         98Gg==
X-Gm-Message-State: AFuF++l5Q5YurKQI5nZCHCLXNz0WpEpyP0hyswfNao4huCXwv+aB+XDs
	s4joAZayB2fJ5GshmoSHCUeuIops7Cxi8t8QHtCANvmYgPt1Na8AYsdJFDvwOBDR4+vQgzkX4HD
	Jj4vZ4IM0dWgT8DiuI0tehLzbcwpNTr3GYh1t+v9pvg==
X-Gm-Gg: AYBFou0p/fKWV0accu8Loa0MuWyfx5fFAWByBPRq6VZO02Fywpj4ehPTpk5cmm1ZB7J
	1uLTXwQMQ+5FeQ4SqY2HKsOC7HAVacmA5xiM18BARUGg+Q9PHSACcqkNXPLxaLPHC/KEMhB8Axm
	5twWLL5HOppQGYz/8/jdFxo4uMXFeP8J87jRMv8MCcGj7lOdNxDFGaZ8NhdX96iTCECt0XePwW7
	QhXvmt3RGqYaklu8KQIxPOh/DlmsFsycaEHT/4c6OivegcqTX4dgF557tgXnixnBfxgffuNiLGq
	b000kKMQoptKBbfxuQS56WOj4HyUt06iXUuX5udV+Odxu9koBn/wB98Qk2ThLkViyEhd
X-Received: by 2002:a05:690c:a687:b0:873:5c6b:a329 with SMTP id
 00721157ae682-87c0f4ed202mr29037297b3.35.1788959903404; Wed, 09 Sep 2026
 06:18:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260909034343.340703-1-sunjunchao@bytedance.com> <iqvi6yo62ydxzshad2mhi55rxhyskfsoo62ji2curbldrg5cc4@z3wju4r6c3ab>
In-Reply-To: <iqvi6yo62ydxzshad2mhi55rxhyskfsoo62ji2curbldrg5cc4@z3wju4r6c3ab>
From: Julian Sun <sunjunchao@bytedance.com>
Date: Wed, 9 Sep 2026 21:18:11 +0800
X-Gm-Features: AcwNN1URoKkZXd_A9WMykFjRGrValQDMpxYfrhpq6USFcen05i6L89OzgmnMZJM
Message-ID: <CAHSKhtcvaWgGHY_NWW242vYHHiSet0v-qsj4MsXGiwZJFrdUnQ@mail.gmail.com>
Subject: Re: [External] Re: [PATCH v3] writeback, memcg: skip foreign dirty
 tracking for bdev inodes
To: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, axboe@kernel.dk, 
	tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C20011C0004
X-Stat-Signature: qwrkycggg7wx69isz7snu33k84smihja
X-HE-Tag: 1788959904-987012
X-HE-Meta: U2FsdGVkX1/PJ8kskir7Vswk8jFRd3NN8zcj2By6Ctezo6su4dm2frxXgugXa4TqX0YwA34A57HAEWQSdlPGj5UTmbc3k60BLyCRUvLibpA983K9yBxzTSs0EGJO5Qm+8Zgxk5tQLOXvlYjGPYZ2OGNxTF1r11KkwBzFg/Xqb3IeO5efkV76Q8+NzPxMdrnAsEmeS6n7lxuY8wglHNWcFbkq2FzkV6e+U7ZH5Nbnn04BA8oXEb2BPb8ld3L/0UANQaG+hAhPx64pi4p3vzcLqEARKDVu/ocb72Xx/NWca15DczwDPnC9CkO/bV8+t3kkxJ5jxiiku9Q99wOi3ReFicKv56KNMVLFTQa/sEasMwag1Nrue0TE5y6VN4TFtN9i48NDb1ShLnVjZwDdhM1x7K5oty0mhzzlUyPyeOon4yPywXUKGMCtelSXOZLmOTzHVPpBDuUuDoy+rysPVUnPKYd5e/SEVjpl82t8w7dJvbTdynqLGZbvbredSamceR2Fj5xaI+WKVvni1v8CGHfjB7B5GXZBKQ3ETdBKyeW6npeZzbHlIxJlSKSzu2jZ4YFijpTdJfk8IL8w4MheurNqQftiYpHCCGZqTvoszhY0kx34oeW2+lrY34UVNBpPYQtIUnakVvbPceiWV26xUi+qhOulWFPgwQbN6U91oRMKcwQCy/tZSlYUBONAGtP45+ogoLQ+Dq/FTTaNdHbnHr9AymENBPLqCfvwW4DH1AiteKfsNWh4RRwQmk6YUZwkJZHjgqE2qwxC5RafAdEpMzYntPsQjO3hL/yx8pc42s7Sbw2f3UUaucEZtR8wgwP5BFd9kcZ6oxFQfGOprre611LPRxUuzuomDE7k0I0Z1PriFMgwe0+x5Zu/eybHZ4vnYKA3KQ+oBwJj8vn/8QPKPFiqt8EykBQ21/x/UJCRX1DM6Ru+mLcC1Wy9HEHzmz0Vl6hbjfVaPIvM7T555KU3/AH
 h1LRo1pv
 KLr+q7O24bQmZInC83MAWIr+nKeKiILtr5TQI2KXw/B8hj7zCMcvzNWvfUPN2JQtioc/59j0RIGU/O0YC9VHcho+pbvFKjTkad/oYjv8R/UvIMr79IiAOiiIaxXUL4y0CQZDEP/L51g9hijNne0kSVqcP0lSdgumVl/JQGoN4N7V+QkiYUNWjgNrxlFJ2ToCFcgfdGDJMtSIidj37mA1Z8NSBpp5AzDsnYaxD4PtY0R23dyb4is1s0ind1ze0kF9HRd6LMBvUPnMUn7qAg0P2tA9jDEDroRGqQEttdBUGhaErk6M+6H8UvGWSmVL20TEBIxino80Ij35dHJJgbD1DIsJQXCfmh9VXHd74
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 9, 2026 at 7:13=E2=80=AFPM Jan Kara <jack@suse.cz> wrote:
>
> On Wed 09-09-26 11:43:43, Julian Sun wrote:
> > The expectation in wbc_detach_inode() that "concurrent write sharing of=
 an
> > inode is expected to be very rare" does not hold for bdev inodes. On ex=
t4,
> > metadata from many memcgs shares the same bdev inode, so dirty throttli=
ng
> > in those memcgs can repeatedly trigger foreign flushes of the owner wb.
> > These flushes can also write ordinary file data, reducing overwrite
> > coalescing under continuous buffered overwrites. The resulting extra I/=
O
> > leaves less device bandwidth for other workloads.
>
> Hum. Are you aware of [1]? The guy is from the same company so I was
> assuming you two are working together on the problem :).

Yes, Xin and I are on the same team, and we are looking at different
ways to mitigate this issue.

We will continue trying to gather more evidence from production to
better understand its actual impact. The number of calls to
`balance_dirty_pages()` and the time spent in it might be useful
metrics for this purpose.

Jan, if we can show that this patch provides a measurable improvement
in production, would you consider accepting it? Or do you think we
should still look for a better approach? If you think there is a
better way to address this, we'd be very interested in your
suggestion.

>
> [1] https://lore.kernel.org/all/cover.1788836830.git.yinxin.x@bytedance.c=
om
>
> > Skip foreign dirty tracking for bdev inodes. Ordinary writeback and
> > foreign dirty tracking for non-bdev inodes are unchanged.
>
> Frankly, I'm not yet convinced this is worth the risk of regressions. The
> gains are nice but both the winning and the loosing loads are synthetic a=
nd
> none of them is like "this is definitely what most people are going to
> hit".
>
> I think what [1] is proposing is more in the direction where we might go
> (although the second patch in its current form isn't acceptable to me
> either). But what I miss from both your approaches is the verification th=
at
> the change actually helps your *production* workloads. Unless it is an
> obvious fix (like was the case of patch 1 in the series [1]) I'm very
> reluctant to approve any additional heuristics unless it is proven they
> actually help production loads. These heuristics are never going to be
> perfect so you can always come up with a synthetic load breaking it in on=
e
> way or another. The art is in tuning them so they work for the practical
> cases :)
>
>                                                                 Honza
>
> >
> > In a synthetic ext4 test with cgroup v2 (QEMU/KVM, 4 vCPUs, 8 GiB RAM),
> > device writes are capped at 200 MiB/s. fio repeatedly overwrites a 256 =
MiB
> > file in the root wb while four memory- and I/O-limited memcgs generate
> > metadata and trigger foreign flushes through dirty throttling. A concur=
rent
> > fio performs 16 GiB of sequential direct writes on the same filesystem.
> > Across five pairs with 9 GiB of buffered overwrites per run, mean resul=
ts
> > are:
> >
> >                                       Baseline    Skip bdev
> >   Overwritten-file device writes       5.60 GiB     1.70 GiB (-69.6%)
> >   Foreground completion time           104.2 s      89.1 s   (-14.4%)
> >   Foreground bandwidth                 157.3 MiB/s 183.8 MiB/s
> >   Foreground p99 completion latency     1434 ms      480 ms
> >
> > The tradeoff is that memcgs with dirty bdev folios lose this way of
> > requesting writeback to relieve dirty pressure. In a separate uncapped =
ext4
> > test, a memcg with memory.high=3D256 MiB creates 60,000 files paced at =
4,000
> > files/s, each with a distinct 128-byte xattr, and makes occasional buff=
ered
> > data writes. The xattrs use external 4 KiB blocks. Across two pairs,
> > completion is 31-33% slower including final sync, while device writes
> > remain about 524 MiB.
> >
> > With 64-byte xattrs stored within the inode, the same paced workload
> > showed no substantial completion-time regression, including at
> > memory.high=3D16 or 32 MiB where the baseline triggered dirty throttlin=
g
> > and foreign flushes.
> >
> > I believe this external-xattr-heavy workload under memory pressure is
> > relatively uncommon in practice, and expect the benefits to outweigh th=
e
> > regression. I therefore consider this an acceptable workaround.
> >
> > Core fio commands for the overwrite test:
> >
> >     fio --name=3Dhotspot --filename=3D"$dir/hot.data" --rw=3Dwrite \
> >         --bs=3D64K --ioengine=3Dpsync --direct=3D0 --thread=3D1 \
> >         --size=3D256M --io_size=3D9216M --rate=3D64M \
> >         --refill_buffers=3D1 --invalidate=3D0 --eta=3Dnever \
> >         --output-format=3Djson --output=3D"$out/target.json" &
> >     hot_pid=3D$!
> >
> >     sleep 8
> >     fio --name=3Dforeground --filename=3D"$dir/foreground.data" \
> >         --rw=3Dwrite --bs=3D1M --ioengine=3Dlibaio --iodepth=3D32 \
> >         --direct=3D1 --thread=3D1 --invalidate=3D0 --size=3D4096M \
> >         --io_size=3D16384M --eta=3Dnever --output-format=3Djson \
> >         --output=3D"$out/foreground.json"
> >     wait "$hot_pid"
> >
> > In the log below, base is the original kernel and skip includes this
> > patch. hot_GiB is device writes for the repeatedly overwritten file,
> > including final sync; the other performance columns describe foreground
> > fio.
> >
> > Full five-pair log:
> > nohup: ignoring input
> > [2026-09-05 17:52:10] RESULTS=3D/tmp/cgwb-20260905-175145; WARNING: ref=
ormats /dev/nvme5n1; 5 pair(s), limit=3D200 MiB/s
> > [2026-09-05 17:52:10] round-001-base: booting
> > [2026-09-05 17:52:20] round-001-base: running workload
> > [2026-09-05 17:55:36] round-001-skip: booting
> > [2026-09-05 17:55:45] round-001-skip: running workload
> > [2026-09-05 17:58:57] ROUND 1: kind     seconds    MiB/s      IOPS   me=
an_ms    p99_ms   hot_GiB WARN
> > [2026-09-05 17:58:57]          base    104.574   156.67    156.67    20=
3.82   1434.45     5.862    0
> > [2026-09-05 17:58:57]          skip     89.125   183.83    183.83    17=
3.62    480.25     1.656    0
> > [2026-09-05 17:58:57] skip vs base: bandwidth +17.33%, time -14.77%, ho=
tspot IO -71.75%
> > [2026-09-05 17:58:57] round-002-skip: booting
> > [2026-09-05 17:59:06] round-002-skip: running workload
> > [2026-09-05 18:02:18] round-002-base: booting
> > [2026-09-05 18:02:27] round-002-base: running workload
> > [2026-09-05 18:05:42] ROUND 2: kind     seconds    MiB/s      IOPS   me=
an_ms    p99_ms   hot_GiB WARN
> > [2026-09-05 18:05:42]          base    103.533   158.25    158.25    20=
1.75   1434.45     5.493    0
> > [2026-09-05 18:05:42]          skip     89.124   183.83    183.83    17=
3.65    480.25     1.730    0
> > [2026-09-05 18:05:42] skip vs base: bandwidth +16.17%, time -13.92%, ho=
tspot IO -68.50%
> > [2026-09-05 18:05:42] round-003-base: booting
> > [2026-09-05 18:05:52] round-003-base: running workload
> > [2026-09-05 18:09:06] round-003-skip: booting
> > [2026-09-05 18:09:15] round-003-skip: running workload
> > [2026-09-05 18:12:28] ROUND 3: kind     seconds    MiB/s      IOPS   me=
an_ms    p99_ms   hot_GiB WARN
> > [2026-09-05 18:12:28]          base    104.648   156.56    156.56    20=
3.96   1434.45     5.334    1
> > [2026-09-05 18:12:28]          skip     89.243   183.59    183.59    17=
3.92    480.25     1.824    0
> > [2026-09-05 18:12:28] skip vs base: bandwidth +17.26%, time -14.72%, ho=
tspot IO -65.80%
> > [2026-09-05 18:12:28] WARN: runtime diagnostics present; inspect each d=
ata/dmesg before using this pair.
> > [2026-09-05 18:12:28] round-004-skip: booting
> > [2026-09-05 18:12:37] round-004-skip: running workload
> > [2026-09-05 18:15:50] round-004-base: booting
> > [2026-09-05 18:16:00] round-004-base: running workload
> > [2026-09-05 18:19:15] ROUND 4: kind     seconds    MiB/s      IOPS   me=
an_ms    p99_ms   hot_GiB WARN
> > [2026-09-05 18:19:15]          base    103.565   158.20    158.20    20=
1.84   1434.45     5.497    0
> > [2026-09-05 18:19:15]          skip     89.124   183.83    183.83    17=
3.57    480.25     1.648    0
> > [2026-09-05 18:19:15] skip vs base: bandwidth +16.20%, time -13.94%, ho=
tspot IO -70.01%
> > [2026-09-05 18:19:15] round-005-base: booting
> > [2026-09-05 18:19:24] round-005-base: running workload
> > [2026-09-05 18:22:41] round-005-skip: booting
> > [2026-09-05 18:22:50] round-005-skip: running workload
> > [2026-09-05 18:26:03] ROUND 5: kind     seconds    MiB/s      IOPS   me=
an_ms    p99_ms   hot_GiB WARN
> > [2026-09-05 18:26:03]          base    104.567   156.68    156.68    20=
3.78   1434.45     5.830    1
> > [2026-09-05 18:26:03]          skip     89.035   184.02    184.02    17=
3.47    480.25     1.648    0
> > [2026-09-05 18:26:03] skip vs base: bandwidth +17.44%, time -14.85%, ho=
tspot IO -71.72%
> > [2026-09-05 18:26:03] WARN: runtime diagnostics present; inspect each d=
ata/dmesg before using this pair.
> > [2026-09-05 18:26:03] DONE: 5 pair(s); all test VMs stopped
> >
> > Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushin=
g")
> > Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
> > ---
> >  mm/memcontrol.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 1271d390b617..6e8f7ff7d44a 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -3898,6 +3898,15 @@ void mem_cgroup_track_foreign_dirty_slowpath(str=
uct folio *folio,
> >       u64 oldest_at =3D now;
> >       int oldest =3D -1;
> >       int i;
> > +     struct address_space *mapping =3D folio_mapping(folio);
> > +     struct inode *bdev_inode =3D mapping ? mapping->host : NULL;
> > +
> > +     /*
> > +      * Bdev inodes are usually shared by many memcgs so foreign
> > +      * tracking leads to frequent flushes which is counterproductive.
> > +      */
> > +     if (bdev_inode && sb_is_blkdev_sb(bdev_inode->i_sb))
> > +             return;
> >
> >       trace_track_foreign_dirty(folio, wb);
> >
> > --
> > 2.39.5
> >
> --
> Jan Kara <jack@suse.com>
> SUSE Labs, CR


Thanks,
--=20
Julian Sun <sunjunchao@bytedance.com>

