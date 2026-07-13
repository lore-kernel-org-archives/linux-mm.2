Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96D63C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 16:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 776A46B0095; Mon, 13 Jul 2026 12:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 700956B0096; Mon, 13 Jul 2026 12:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C9206B009B; Mon, 13 Jul 2026 12:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 226876B0095
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:13:04 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2622B401C2
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:54:15 +0000 (UTC)
X-FDA: 84984200070.29.A5FE16F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 41A0718000B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:54:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VORZTIQ4;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783958053;
	b=51FHp5hCNuPEKVgwlBKGXw2LhnkVHUrcKLnqzgCjztjY2NkDFDSCZF7ecqtqbDblSREP+t
	g8vlp/76QMv5k1C4y3ApkbZ0zwDL9d4ogqmYV3Y6SAdUjuzAWbd2cWiGlNABCQLJ+Q5R5s
	wu7k29tQA6sFhbGS+SX+AOwpF1Ib7ic=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VORZTIQ4;
	spf=pass (imf16.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783958053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Wi+BDV+Li2I45KRRyhG/JcQYyz2VMwpLgz+pmqRyH0=;
	b=Gc2msRL9G2XtebAdH+mhGqfwcXhFi86oXc2WYhbajUgwGxhKRHTIqXtXCQ/9bSWtx3t9iQ
	Bfk2+DbB46GnR0iwZtWGLUtKGNQWMwq0YkY/tIT4y8IAuy1FL5H1QwMAR9dwLRxA7L07oX
	OkKQRMHSiQsBscFhmWd51Cj6Yt00984=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AFDAA601DE
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F511F00ADE
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 15:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783958052;
	bh=7Wi+BDV+Li2I45KRRyhG/JcQYyz2VMwpLgz+pmqRyH0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VORZTIQ4sVCUpJp9aFjnW5D6DZw9sxWvTk990TFyhM1TCzV7UHqITSDUyKLxh1G0G
	 oX3qPRK53kPcmgoEY1wKO5YqoQyirtrVCFxtff3y7awk2AJaH4GiNZyMJISGNMNa+8
	 8+LqGpEM5Xr0OXDAP7jBrfwgElGP2cerm279gm5b6/ncTIf6NcWHV6XIrOgMGbqbSu
	 dDKQi3cpHs2UkcacMc56vn8Rctjj0az7Pj3bEa6LOlOCMtMWs/nV4rl7UPHZoSf3kc
	 Fdqg1yMy8Fm9crYWr9gFEv+5K0WvdJXTzd183EGvtdjV2NLCPOlnVf6wDBtq4v4gPA
	 BSWn4r2kPT7mA==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c15ec1da77aso378788866b.2
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:54:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpJHiD9wop6IE2ZPMhMp7B9IgmGMl8eSsK6XPtWvlGaOhnORZsEr3l2XdRTJffrPkFzNsc+kB9kVw==@kvack.org
X-Gm-Message-State: AOJu0Yyby/UQ8b1o+85DqzN0+L6jawh6PYa6xjnQNp4K6if1r0ptFnXH
	/jMkOKU0ieN5SFVij+i9SPfNtfb0WsBl/Vem0lsGd532FOfkY4Op3k0jxPQpmw4j1jGALMl8UaK
	EF6Y8pg4dPImHNpQhxhqAhSJjlw8ZtSA=
X-Received: by 2002:a17:907:ea5:b0:c16:63c:a749 with SMTP id
 a640c23a62f3a-c161e8b39b5mr412150066b.18.1783958051252; Mon, 13 Jul 2026
 08:54:11 -0700 (PDT)
MIME-Version: 1.0
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
 <20260629112032.20423-5-jiahao.kernel@gmail.com> <akMJ8UfeZXrVe5LN@google.com>
 <cbbdf506-b67d-193c-2c94-bacf828d559f@gmail.com> <CAO9r8zNCEis2QHROEsM5QZsb_H4ofNjA_sE-pM7SVxtgHg_rqg@mail.gmail.com>
 <4ec2bd64-af40-8ebf-b8a8-2dd7421a1100@gmail.com> <5ce4035b-7f56-d1d2-2d2a-668446d870e8@gmail.com>
 <CAO9r8zOLe5eJfNmoszCX3rtD=6YEa_7xrvDV1acVDOtZg4vWYA@mail.gmail.com>
 <bf14cfe5-e98e-c20a-231e-37b3a2489040@gmail.com> <CAO9r8zNzRWxCvUok7FJTZZOp6pS9D-Qdrsbi10rLBn4QRhw81A@mail.gmail.com>
 <30c8df43-9464-8fa0-3614-0ca06b97862e@gmail.com>
In-Reply-To: <30c8df43-9464-8fa0-3614-0ca06b97862e@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 13 Jul 2026 08:53:58 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNu=JPZG4be9beJUdBEGRgX6YaD_cpZw2P8WieDY=c06g@mail.gmail.com>
X-Gm-Features: AVVi8Cc-M6D8QIj5nYsgvnSdHgSG_Ul8Jzmth_aCqS10AAfg94WJe5GDwQuLPLM
Message-ID: <CAO9r8zNu=JPZG4be9beJUdBEGRgX6YaD_cpZw2P8WieDY=c06g@mail.gmail.com>
Subject: Re: [PATCH v5 4/6] mm/zswap: Implement proactive writeback
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 41A0718000B
X-Stat-Signature: z3siws8dyp381ynbx9976pcp8kehrfzw
X-HE-Tag: 1783958053-883642
X-HE-Meta: U2FsdGVkX18y33C7nEISv9MX2DzoE7dc7JEnKJQzjn8Iy3XBEOOncdiDE+CF5q5WG6+0sbugmrJ25WXesdR5OAxM26tb+hyhkvqgHhdle+Vakl+Q6mtyysqJHsAW4y7TEulZ7H+rkrnDT42XbhUtmQmbbFYeZ7UtrgGRExM5S/mEUEYUw/tKoItShD77PakIyVyn7cpRivYg40TBnB8NsPtoXwynMJzu4m2E7qyxtDm9Am3IWfQQCzrRNpxGVv31ci/I7GmY8yfVN2FZoou8O6VXXUjaQZv6afwJO4OiOCdJN8dYpWAnofen0eenxrWPmOfFqp/Z1z1hsTMgHINd0FbgkSiKcxKL62FoUM4RMmVYTY4Q7xikVV1YRrnPRTi7BeOw3XEhYtrS/Wa9Bmo6As3QQUfurAsQhuOjhfL5FqHigFUN7tfBnh422fMFWrEUqJkqEwhr/S1XBC+WI3Fw4juu4ZGHarElImY7v8dqhxS+suYrfccQjesGr0y5O4ErXt9tUI7jRA4GGmTc1bFGvxwSd3NJn8tIogbWBFXzNgJWGfmZJzazVO9O79/a6yKheOAs5cyEEG1OsOQD7WZQXjraNH1BusO16fqkMVMVVWWVLhMJHKFPYuGRE+kx6/mYtNnb9Oa8e481EDSFdpIC7XGPAtF5JtYr1jnq7H0oSqOdpiAhldkPO77L4uuvvaFRgJsyhp+ilIpdGIKhIE3IeFswjrnH3/j51Wv1FGitPmUj1TFNc87R86hjLBB59/NN9SRyEY6KoErhqFrEJUCUL+bUJWtkHF7hHQ0wwLY+6+Cpl/ZrlheGk7p4Td5ABhmMaZqazN1kPufKA40a+nzNHLIR6aUZpP6CurmXy8+zgs7cP0m+Og55y3dQxZz0FcJZyfsO+oZ+eEkmlBIiQ3fCIuarBcwaoKhjIwVFWPwOtlXi1wwt+5FpS+tqiz3EhvgASCFx+VoaCnwNGwBG60U
 DIpBeOMP
 ULv9DBMaI+viUjK0UiMqBBw7gNy0XXn+JMlkrHbKPpPul0RsQchzFYCSsemDcDHZZoZSx/W3oDm0LR0UU4LT3pv2qYvSwtXBgsv/o77bykBJhKBk1c6c3mBrhHMb89AaUnHMRtkMdlcE4fIg7h4F4L8/o0SutjWpm/S9Qjr94VJcG+Bti0MfQ0Ohc69pPeAlCMRU1fhziNV8pm0eh/lLYm4cBn+uGhGUdeka9aHHDS7BrBryJKw2mZzwdoxykbBJjWlt3tzc3aa2ovG6MqU1yI3v9XUI+gFwx/T5K5hEvR+ZWJpuKxme1KAZmBPFvavQMm1M48NRYv6N/dDm/LWIl3wVHojIenMrAGW+r5A9jX6cQiu4nmJ6Ts4KST22P/LvGGYH5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 3:04=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com> w=
rote:
>
>
>
> On 2026/7/10 04:44, Yosry Ahmed wrote:
> > On Wed, Jul 8, 2026 at 7:15=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.com=
> wrote:
> >>
> >>
> >>
> >> On 2026/7/7 03:33, Yosry Ahmed wrote:
> >>> On Thu, Jul 2, 2026 at 5:32=E2=80=AFAM Hao Jia <jiahao.kernel@gmail.c=
om> wrote:
> >>>>
> >>>>
> >>>>
> >>>> On 2026/7/1 19:45, Hao Jia wrote:
> >>>>>
> >>>>>
> >>>>> On 2026/7/1 00:10, Yosry Ahmed wrote:
> >>>>>>>> Before going through more versions we need to figure out if this=
 will
> >>>>>>>> pivot to be a proactive demotion interfcae for swap tiering.
> >>>>>>>>
> >>>>>>>
> >>>>>>> Yes. Should I drop patches 4-6 in the next version and wait for s=
wap
> >>>>>>> tiering to be finalized?
> >>>>>>> We can try to get the non-memcg parts (patches 1-3) merged upstre=
am
> >>>>>>> first. This would also give them plenty of time to bake and catch=
 any
> >>>>>>> potential regressions. Thoughts?
> >>>>>>
> >>>>>> Patches 1-2 can be sent and merged separately, yes. For patch 2,
> >>>>>> please include some numbers for the writeback performance before a=
nd
> >>>>>> after batching.
> >>>>>
> >>>>> I'd love to collect some performance data. Do you have any recommen=
ded
> >>>>> benchmarks for this?
> >>>>>
> >>>>
> >>>> Perhaps the following test case could work?
> >>>>
> >>>> Test Setup:
> >>>> - Total memory: 32 GB
> >>>> - zswap settings: max_pool_percent=3D1, accept_threshold_percent=3D5=
0,
> >>>> shrinker_enabled=3DN
> >>>> - cgroup constraint: memory.max=3D1G
> >>>> - Workload: Run the following stress-ng command inside the cgroup fo=
r
> >>>> 120s to
> >>>>      continuously force zswap store failures and trigger shrink_work=
er():
> >>>>
> >>>>      bash -c 'echo $$ > /sys/fs/cgroup/zswaptest/cgroup.procs ; \
> >>>>      exec stress-ng --vm 4 --vm-bytes 4G --vm-keep --vm-method rand-=
set -t
> >>>> 120s -q'
> >>>>
> >>>> The following comparison results were collected over multiple runs v=
ia
> >>>> bpftrace
> >>>> and the 'written_back_pages' sysfs interface:
> >>>>
> >>>>                             Baseline         Patched
> >>>> ---------------------------------------------------
> >>>> shrink_worker wakeups       5,587             878
> >>>> shrink_memcg calls      7,823,853       2,347,320
> >>>> written_back                  257         781,214
> >>>>
> >>>> Conclusion:
> >>>> Under the same workload and duration, the patched kernel shows a
> >>>> significant reduction
> >>>> in both shrink_worker wakeups and shrink_memcg calls, while successf=
ully
> >>>> executing a
> >>>> much higher volume of page writebacks.
> >>>
> >>> Hmm this is actually a bit concerning. Yes, we are invoking the
> >>> shrinker less, but we're writing back *a lot* more memory, orders of
> >>> magnitude more. We are using a batch size of 64, and making ~1/3 of
> >>> the calls to shrink_memcg(), so the number of written back pages
> >>> should be ~20x more, not 3000x more? I think I am missing something.
> >>>
> >>> Also, ideally, the batching wouldn't result in significantly more
> >>> writeback, but a similar amount of writeback over less shrinker
> >>> invocations. If we are writing back significantly more pages then the
> >>> batching logic is probably too aggressive?
> >>
> >> Apologies, I think the test I constructed has a bit of a problem. This
> >> test has very, very heavy memory pressure and is already a very abnorm=
al
> >> case.
> >>
> >> The zswap entry returns the first time because of "second chance" afte=
r
> >> setting referenced to false. For the baseline, it scans 1 page per nod=
e
> >> each time for 16 loops. During the test, shrink_worker() basically exi=
ts
> >> at about 16 pages each time.
> >>
> >> Since stress-ng periodically and randomly writes to this 4G memory, it
> >> keeps triggering zswapin and then waiting to zswapout new zswap entrie=
s
> >> after falling below the pool threshold. When the speed of zswapin/out =
is
> >> far greater than the scanning speed of shrink_worker(), a large number
> >> of zswap entries cannot wait until the second scan for writeback. New
> >> entries are stored on the zswap LRU list again, and the referenced of
> >> the new zswap entries is set to true again. During the test, it was
> >> found that 99.21% of the return values of shrink_memcg_cb() in the
> >> baseline kernel were LRU_ROTATE.
> >
> > Hmm if I understand correctly, you are saying that the current
> > upstream code is actually failing to writeback when it should in the
> > previous test case with very high memory pressure, but it is with
> > batching? If that's the case, I think it's actually really good data
> > to include. However, we should make sure that's what's actually
> > happening. If the current shrinker is not keeping up and failing to
> > writeback, we should observe:
> > 1. shrink_worker() hitting MAX_RECLAIM_RETRIES continuously and bailing=
.
> > 2. zswap usage consistently remains at/near the limit, and not going
> > down to the acceptance threshold.
> > 3. zswap_store() failing to accept pages and the pages going directly
> > to disk, causing an LRU inversion (hotter pages on disk, colder pages
> > in zswap).
> >
> > Can you confirm that this is what's observed with the high pressure tes=
t case?
> >
>
> Apologies, my previous explanation might not have been very clear.
>
> For an entry to be written back, the shrinker must scan the *same* entry
> twice: the first scan sets referenced to false and returns ROTATE, and
> only during the second scan can it be written back.
>
> If a swap entry is zswapin'd between the first and second scan (meaning
> the entry is no longer on the zswap LRU), then this swap entry will not
> be written back by the shrinker. Therefore, the second scan must occur
> before this entry is zswapin'd for it to be possible to be written back.
> So, if the baseline scanning speed is far slower than the lifecycle
> speed of the swap entries, it results in only scanning once. In the
> baseline kernel, 99.21% of the return values of shrink_memcg_cb() are
> LRU_ROTATE, while the patched kernel's shrink_worker() scans at least 64
> * 16 entries in a single pass, resulting in only 58.7% of the return
> values of shrink_memcg_cb() being LRU_ROTATE.

Right, my question is, is the high rate of LRU_ROTATE leading to
failure to writeback in a way that causes zswap store failures (and
pages skipping zswap and going directly to swap)?

>
>               Baseline         Patched
> ---------------------------------------------------
> zswapin       929,096          281,196   <----
> zswapout      982,731        1,058,746
>
> After modifying the kernel to remove the "second chance" algorithm, the
> test data of the baseline kernel roughly conforms to our expectations.
>
> Therefore, the constructed test has a bit of a problem. The second test
> case in my previous email can ensure that the entries on the zswap LRU
> are relatively stable.
>
> It is worth noting that the capacity of the zswap pool will not remain
> constant all the time. Since stress-ng periodically writes to and reads
> from this 4G memory, accessing the pages in the zswap pool will trigger
> zswapin, causing the zswap pool size to decrease. Other pages attempting
> to zswapout into zswap via zswap_store() will fail (until the zswap pool
> size becomes 160M (accept_threshold_percent=3D50)), but the zswap_store()
> path will wake up shrink_worker() to try to perform scanning and
> writeback. Then stress-ng will continue to read and write memory,
> continuously triggering zswapin to further reduce the zswap pool size
> until the threshold, at which point shrink_memcg() will also stop. Then,
> new zswap entries (with referenced as true) are added to the zswap LRU
> again via zswap_store(), until the zswap pool size reaches 320MB (32 GB
> (Total memory) * 1%). This process repeats continuously during the test.
>
> Thanks,
> Hao
>

