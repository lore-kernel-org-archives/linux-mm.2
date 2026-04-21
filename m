Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54C3DF94CA0
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 18:25:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BAD56B0088; Tue, 21 Apr 2026 14:25:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76BDF6B0089; Tue, 21 Apr 2026 14:25:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65A796B008A; Tue, 21 Apr 2026 14:25:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 557EE6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 14:25:34 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C68C9C6318
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:25:33 +0000 (UTC)
X-FDA: 84683390946.07.501E9D1
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id BBF921C000D
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 18:25:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iK87Wgbo;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776795931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NGNVm9zrX5VPxV9fNljn1MfMSVg92KMIPymCnJ6l6Fg=;
	b=blWapJehwkJnz1X17eKfmLMPqs8jjvOuHH+qZzRJ7DSritQxO8Y+3lGAgHsIsW+PI5aXiU
	KJwqKHcmRRw3NuZMoJ3sigUAyThX+PFsFElJ2+FQYEWLgkLFnHU2vu++OfniYiDCOWN2N1
	SIgiY+k/trLTg3sOrDIjFkiAkVVvNDE=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=iK87Wgbo;
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776795931; a=rsa-sha256;
	cv=pass;
	b=kBsw9+f38sHvIPb0tnQjMDRAIOXpQyaApGko22nJpVZijR4vUTqMSpK9RI3nbR9Ahr+uYg
	6AZQnAZ3/2SHQ/5CzZ4bvYWi2+Ka3xkMie2zPN32dQ42y/7rkGv3aQJGjlSEtjVojkOb+Z
	s4t8qbg7VHH3mUNBMh6mOw907MBWHzk=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4891d7164ddso16357985e9.3
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 11:25:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776795930; cv=none;
        d=google.com; s=arc-20240605;
        b=jqsUOnHPF2LQHlkV5rlU2PTL6TK1CBLXU4UvbY6jeoveKxRk8dEFmITCcssiiwfedh
         xw20MHqRddfJIDVfXC832i4J5HzVjb15EY6bJrWZJ83cu4ZqAgtS7nB07SJfydNmrGVd
         oVO6Cq9mNMBkRRivsm0R4S0Ikwt84drZa/g/n6blMtDUrfzKpe8sQzpyNY08Ocr3zpHx
         9RtA3fxffsZNk1bdbq824lVHhlpp92I0P6p+hqU/oQNz+xv1ArEpHYpRfPwBbiGMg1OT
         9Q5tzaTFFx2FYG+8UtUvt8By37LTZPuKYB78wVxYtzmhQTSpFzqzfKK+LfESFuY41va/
         JWUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NGNVm9zrX5VPxV9fNljn1MfMSVg92KMIPymCnJ6l6Fg=;
        fh=reCrielsiQd9jUpZ0C7yChG+HHKqrp1ARLJnBhOPt68=;
        b=KmnSNH3LbI2ehTocGJgZE1jBQoL8VwxyIFX6CZ3uJzDLK6L2S45Sd+3i/d8sBDq0Wu
         3lclw+Ml3szi65ucbDVBwZx4rDGLJC2yw6gixNgwDruNz1pIBaea3SubBrqHKUCO5jWZ
         yI1tsLoQZ6svDRmpaXkMquJy4mbrY30pUOWSMJUVaQoGSoGmlESZV2h8gchXG1lI9LPq
         PTDb5sQLehhyu5sMDRlKu7EySEo55w0mAclbY+CKRP6TFE4FLZRnS8HR0nmiei5skAYQ
         1yUAIOpqyLl+QQI5wQMw6fs0GRuBQFkpC4UrP4rnEa5EaJl4W0ZYb75riygG0qg8jAI1
         hpog==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776795930; x=1777400730; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NGNVm9zrX5VPxV9fNljn1MfMSVg92KMIPymCnJ6l6Fg=;
        b=iK87WgbomMfy3Ap1YLwfAOaIJ1B8N36napVrTjc0pj1K7n+rgcf0KkZ7ZkfVwpuiXy
         fN4ApCU9t87k5qssZP5rGTZEr/ICaBx+RVPACukkdvsdsFfpCMxyfIPMdzHZl0mWIlZV
         PdZn17F2NEdTc9TbV11ShJC4KJd6SGK8YCHYLB/M5SZcHlJ33Wlp7veIqeb8buvG3pPM
         YW7Y8xaZz8mGnlBhWQ1y+Itakx3UTAg8Paw9FK40VTgkM7Igws2CfRML2KWq4DPUKFIP
         9e5M9udd3W9BnHev91ddAcIyjthRq21N/PiGpURiZzY0DoVN/MTpRTA22WfmIKd+6761
         XAOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776795930; x=1777400730;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NGNVm9zrX5VPxV9fNljn1MfMSVg92KMIPymCnJ6l6Fg=;
        b=dztpp4c8am5OF3uF455VFfkFhesPfufgFxBO4JyWPUvDpBU/mseNs0+NB7aozdR14x
         kA93s3y3+T3cyNK4z57WeP8Oi7fGeowVHzwiHd1ntR/g+UvW4q3qk4f5MlhgBstHryPI
         QXI8SH4M86YF62S0IJgqPDV02ihNJwOuQEtpRbAKTzr/Z+evesq7XSbmYPEM3Cm6mlOW
         qXjlrua/sZWb5DRqzWTqb/lmF+gCYtQIFGAPFwMyWEEyWK4zkIKx9dCoOqOaE26rIb1G
         N9/zZD2HTR7kosP8OhD1DBKNt5aGHHglILOpLa/xmBsQVgpTAjEDxF2LNkLBVlML3ndA
         r1bA==
X-Forwarded-Encrypted: i=1; AFNElJ+5bynxQ2Y6MHcu6a/M/wFT+zzsJiUck9yIHC1eTk8Y+kNGjOLvLyY5jgaD1knBR7bnXJB5hekyBA==@kvack.org
X-Gm-Message-State: AOJu0YwN8T8wRamxsX8cohG0vsx7U70BHAXYixPsRwr7jiJG6y1AUZw/
	wlRQHzuE+LTujzLWpfdRdAwKNMX7xOLhLyyLaXUYRbk8yo1mwt/UxVjK8ajhVc9mvttqTSrwBne
	qiYNA0XpZDvWd5OV/MlEF/r2mY73VikU=
X-Gm-Gg: AeBDieuPb1KG50er+Z2GMmpAjsWFYTM7yQ2dKuRPiZhax0e6Ly6uVwH+kpqyzmy+DYS
	KDHLHtiVJqULXpbGFhDP18b6yjU3k9A2V+eN6FYlV0AjiQjHpabgNCg9OHNujcucHUJrMUrkpR3
	lgSaLV6v2rrvDKTJGixhn1KTiHXcnExApW5iQrOuCV2fs7hDBcoJQZWZQM4VDdOVd/H4FYuKnw8
	wwuGW4E7dvJ1xInjWxGjfy5RC+Gc3rionPuqNfzgvwAf6c/MJv3c+GFrptw/CxuGb2UL+eoqVOT
	z4sv22goFLxggWYKXaWnyGVo6LzKpH7xUEscYZ3u4nS6HwhyIi/tBaE7CAPm4gL3Bw==
X-Received: by 2002:a05:600c:4f0c:b0:489:1c1f:35e6 with SMTP id
 5b1f17b1804b1-4891c1f38c8mr155126095e9.6.1776795930023; Tue, 21 Apr 2026
 11:25:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
 <CAKEwX=M5YpR0cQrryX_y4pm_BuxyUWZ_8MbhWodwbf1Fe=gzew@mail.gmail.com>
 <CAMgjq7Ae_VH6mLQito5MFnxmp7ScZvF9xw4P-yU-yUBkPZ9_YQ@mail.gmail.com> <CAKEwX=PkFiP+u+ThrzjTKBi+usQf2uuhTZcfB2BNNA8RboOFDQ@mail.gmail.com>
In-Reply-To: <CAKEwX=PkFiP+u+ThrzjTKBi+usQf2uuhTZcfB2BNNA8RboOFDQ@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 21 Apr 2026 11:25:17 -0700
X-Gm-Features: AQROBzC-rJgxzCf4AEfBtKywwh9ODlZ3G4_DuI0Dp7qwX0yZHQjPPr7bI0C_LBc
Message-ID: <CAKEwX=P6L=CeJCXkC+cKbZKYk_ORho3pLy476c8=BbDianx=vg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/zsmalloc: reduce zs_free() latency on swap
 release path
To: Kairui Song <ryncsn@gmail.com>
Cc: Wenchao Hao <haowenchao22@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Yosry Ahmed <yosry@kernel.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Barry Song <baohua@kernel.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: e1fwg3xq5ex44rsjm4w86irjgsxcop6o
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BBF921C000D
X-HE-Tag: 1776795931-653073
X-HE-Meta: U2FsdGVkX1/sbaPKFaTmP/uAL8W4tPS6uy27Rsk7Xo63M776uU1F5s0EmgxF+/dUTC2jrqPpYrZVucqIRACQzhOs11oiz12+Cb5OvMhFPyOXG+Kf0gXB+ZBVwBFSSOPY+/BBp8RdCTR48Mxwf9oo3X22klrCbPAAHHrZHQ8i/K7T+Kz8WiUeRbnr0jO85EA+6FfxFH1BJbymDSz5ymQeOhI6w5SreC5JOzXi81HaBHNIgBQhVQZWjj8sHRmTrIr9hEoRmvzubISoAzNIqZMJh45YFrRk24+Na2M7QAk+e00R+VD6+Pad481SXxlJD1Qn1whgijib1hcN8iR/rD/bLGbLe3JXg5FfGbEWiq831VN9qZXSqRJxWTdPISZF1JITqhwURyM6Ec2tZsEpLUKg+cQYjDOdDmLJg1MBmh7w1AmnBz2/aT0g9GWGG5FGfEBHo4SnXkvKhmWkjYk9hfyndupcgNXvuGzve6+bjGFwgHWzz4FiUrWQhUHoZQhdZUtaphjnfcFDJ4XeLKSEPxOi0U/m47F0bePhjoDeX6Bb/pG8OoONXd+owkXIjx9m193niNOYec2OjSHEEx6VPesuARiFa3WfmhhNqQquaZY52bpGaHTe92WaYP1NLGhVdvdfswALUMr0EIqhsPOZeXkYYXH47Alc6sRz324U/0m36svUm15kMJNZ2xGnsSpkM1jkrhMOVTon1ajs02r7ifKbGpJhkx+yeHkorsE8Svbq/1QTXmjyWMMLHnXav5Dr+d6VI+oBqjoQ0GZTsNwMlbA1ooCDxKciXLb0jxjeYhCbvsMP/gzYMNVJsacAt0/+4s/pPEXec0YqI8EqIa0FjV757RvTn13tmDvTbPD173J17bfRtASw755/k0XIDQTWW83/3UTOcgVaqFFmIntYe7eL3XCgUQQJ8DOJ5EDBfalns+LNyHrT1C6kT63pRBgu7KqxNx3XhbaeDKwgcB2OVsR
 SCKTwwpK
 6AkLqDng8hI8yKrF8fU4jI4wI4d+W9sx3gva8Vrxnljn6uwBohbtFmFV+jLGT73mXguA+e2E0dhTILP2H5XP1IxD14M0nLk8us3zJLCRoZVCsT4VYd45ehBtVpRZ/ffsN4oxssUokuxECP0QyhLUIAMvf6VBz6USLM7SzNgFfwA4I0unSPFGTQQYtxCUpt7bcc6V+X2Gjl3H80LWwVvcFMf4C0NOo/8+Ole98oZlJmUZSlmJm7sI6VqjqrhUrr3KmjPo4vgGAqP1A3ZCVfTWKs26g6qJ1eD7tped+pgtlOYh7ANsGGmrt8uPGKua7wAxSQ7Ho+1OxwBRlsBriGp5zFc/tXCY4cs9T8cnmS7gXu4J0/C/YZW37GMe/Sb3bmM1ksVa9V8ZNOo91fE9Xu9QyKxBlbb8M7rBTu5yW7sacVnsQv1YNCFRD8G28AX7qP2csLqVsMujMpGlRBwGsbjQtvxMUYRWpHY6EkgMPin9jDQOvnerfV7elmo8jLFh20c5VjtDsFx1OR27Xb/lzn09BDSklRt6lggmZc/NipirUFCLDKFPMeIEcOfAgnb53lD/cK/7CXZot7/fCfdYcenRBabI9l1qMdiqdJVzZ8G8vTc7p2bE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 11:07=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wrot=
e:
>
> On Tue, Apr 21, 2026 at 10:18=E2=80=AFAM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > On Tue, Apr 21, 2026 at 11:55=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> =
wrote:
> > >
> >
> > Thanks for adding me to the Cc list :), Barry started this idea with
> > ZRAM, which looks very interesting to me.
> >
> > > On Tue, Apr 21, 2026 at 5:16=E2=80=AFAM Wenchao Hao <haowenchao22@gma=
il.com> wrote:
> > > >
> > > > Swap freeing can be expensive when unmapping a VMA containing
> > > > many swap entries. This has been reported to significantly
> > > > delay memory reclamation during Android's low-memory killing,
> > > > especially when multiple processes are terminated to free
> > > > memory, with slot_free() accounting for more than 80% of
> > > > the total cost of freeing swap entries.
> > > >
> > > > Two earlier attempts by Lei and Zhiguo added a new thread in the mm=
 core
> > > > to asynchronously collect and free swap entries [1][2], but the
> > > > design itself is fairly complex.
> > > >
> > > > When anon folios and swap entries are mixed within a
> > > > process, reclaiming anon folios from killed processes
> > > > helps return memory to the system as quickly as possible,
> > > > so that newly launched applications can satisfy their
> > > > memory demands. It is not ideal for swap freeing to block
> > > > anon folio freeing. On the other hand, swap freeing can
> > > > still return memory to the system, although at a slower
> > > > rate due to memory compression.
> > >
> > > Is this correct? I don't think we do decompression in
> > > zswap_invalidate() path. We do decompression in zswap_load(), but as =
a
> > > separate step from zswap_invalidate().
> >
> > It's not about decompression. I think what Wenchao means here is that:
> > freeing the swap entry also releases the backing compression data, but
> > compared to freeing an actual folio (which bring back a free folio to
> > reduce memory pressure), you may need to free a lot of swap entries to
> > free one whole folio, because the compressed data could be much
> > smaller than folio and with fragmentation. And swap entry freeing is
> > still not fast enough to be ignored.
>
> Ah I see yeah. That's the not "as much bang-for-your-buck" as folio
> freeing category. I agree on this point.
>
> >
> > >
> > > zswap/zsmalloc entry freeing is decoupled from decompression. For
> > > example, on process teardown, we free the zsmalloc memory but never
> > > decompress (if we do then it's a bug to be fixed lol, but I doubt it)=
.
> > >
> > > Zsmalloc freeing might not be worth as much bang-for-your-buck wise
> > > compared to anon folio freeing, but if it's "expensive", then I think
> > > that points to a different root-cause: zsmalloc's poor scalability in
> > > the free path.
> >
> > That's a very nice insight. I had an idea previously that can we have
> > something like a zs free bulk? Freeing handles one by one does seem
> > expensive.
> > https://lore.kernel.org/linux-mm/adt3Q_SRToF6fb3W@KASONG-MC4/
> >
> > It might be tricky to do so though.
> >
> > It will be best if we can speed up everything, doing things async
> > doesn't reduce the total amount of work, and might cause more trouble
> > like worker overhead or delayed freeing causing more memory pressure,
> > if the workqueue didn't run in time. Or maybe a process is almost
> > completely swapped out, then this won't help at all.
> >
> > I'm not against the async idea, they might combine well.
>
> Completely agree! I was thinking about batching the free operations
> for zsmalloc. Right now seems like even if we have a contiguous range
> of swap slots to be freed, we call one
> zram_slot_free_notify/zswap_invalidate at a time, which then call
> zs_free one at a time? I wonder if there's any batching opportunity
> here. Might be complicated with the pool lock and class lock dance in
> zs_free() though :)
>
> And yeah the async stuff is orthogonal too.
>
> >
> > >
> > > I've stared at this code path for a bit, because my other patch serie=
s
> > > (vswap - see [1]) was reported to display regression on the free path
> > > on the usemem benchmark. And one of the issues was the contention
> > > between compaction (both systemwide compaction, i.e zs_page_migrate,
> > > and zsmalloc's internal compaction, but mostly the former).:
> > >
> > > * zs_free read-acquires pool->lock, and compaction write-acquires the
> > > same lock. So the compaction thread will make all zs free-ers wait fo=
r
> > > it. I saw this read lock delay when I perfed the free step of usemem.
> > >
> > > * If this lock has fair queue-ing semantics (I have not checked), the=
n
> > > if there a compaction is behind a bunch of zs_free in the queue, then
> > > all the subsequent zs_free's ers are blocked :)
> > >
> > > * I'm also curious about cache-friendliness of this rwlock, bouncing
> > > across CPUs, if you have multiple processes being torn down
> > > concurrently.
> >
> > That's interesting, when I mentioned zs free bulk I was thinking that,
> > if we have a percpu queue, at least we may try read lock that on every
> > enqueue, free the whole queue if successful, then release the lock.
> > I'm sure there are more ways to optimize that, just a random idea :)
>
> Yep! Would be nice to have some perf trace to pinpoint where the overhead=
 is.
>

Ah OK - I found this thread now:

https://lore.kernel.org/linux-mm/20260414054930.225853-1-xueyuan.chen21@gma=
il.com/

Hmm, free_zspage() and kmem_cache_free().

* kmem_cache_free() is just handle freeing. Bulk-freeing?

* free_zspage() looks like just ordinary teardown work :( Seems like
we're not spinning any lock here - we just try lock the backing pages,
and the rest is normal work. Not sure how to optimize this - perhaps
deferring is the only way.

