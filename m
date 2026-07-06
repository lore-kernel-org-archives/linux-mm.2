Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09E83C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 13:04:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D94F16B00B5; Mon,  6 Jul 2026 09:04:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D46536B00B6; Mon,  6 Jul 2026 09:04:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5C646B00BE; Mon,  6 Jul 2026 09:04:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A345F6B00B5
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 09:04:23 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 227121684E4
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:04:23 +0000 (UTC)
X-FDA: 84958370406.07.FAA429E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2F1DD40007
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:04:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J7LiCBl5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783343061;
	b=TelCY6X8VmOOSWRETRVyxAzXdCprredIVH2tcP81m7owCDPUaS2FM7won2vqJA+Q7Bw0TB
	rPQnj8GSehMXSr/O8t5s4itIs3iQnhkrxVFPv+Ksx7/30P9trD+vg1CVy7xvbWtoL/DT2m
	y44S/hyr134zZ/TgJrxd0aWhQXFTdHA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J7LiCBl5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783343061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=03m1i1njTYKshtMRdqLIQtrRPKyxLQ0WpIMYuekAZ+I=;
	b=YE9qSJrysp5a/y/8gx3krZEZNGkl8tAAakUwLITpFg8pZ0unlq2VZFxZzg9vdEasFtBPga
	rMn1rT3v8eg+BcmDm6b1NWowi3DbIvzHav+tqNC6y/x/pbPpP89j9/zuOeF6xcR2Dc0Rzn
	ZELLLrLfQb16tccbYOgsZkurSIt0c9k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B326B600C3
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:04:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699281F000E9
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 13:04:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783343060;
	bh=03m1i1njTYKshtMRdqLIQtrRPKyxLQ0WpIMYuekAZ+I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=J7LiCBl5XvTWPEvGs3gPzG1AdIvohJgZqzV94OVb/y+CKRQOflBlh86G0e2AMEFY+
	 YzzDsGQfvRDqHEWE0N3pY80hZRX5LNVBLwbu7gbTzgcDOBKErd3AE3Fc5KiiyC37cJ
	 elBaGXSiIBJNjJYKkB51bkFFYLEIobS+DD5J0F0pHVrwPtGoBh0YmT9ML4I1BZ3jFD
	 Ad+LkpWAlcjmhtG+k0IQ/2rUhvyC1bBydMye2EHAjJku/k/7c4/QtRtp8BYxsOuSYV
	 W/HaSF6HSjciZ//vvB15sSguyThc3VJTu3OynOPNDVj4SWsuur60+MWNX+sSUo1ddt
	 y0vy2nAykL3eA==
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e5cb052edso220408685a.2
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 06:04:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqwGbl/9qmDTjozWlosjZRZNXSPNE4910xAVbg0GgRSMwa9M0WMXeMTpOWlUxeXqtm/XIRd96OS6w==@kvack.org
X-Gm-Message-State: AOJu0YzwIIrJhwGRdY6jWZSNyU8xO4qYId2Ph2XHyiRXnO9uotRLTHv5
	TDGHZqiH4e83Tr5dcVMUtM/vp1AtHyPdKBfpgOOxGljcxhJ/hmiI/HbOl+R2NdY9BgptvQHeRBK
	PRIP+J+uqoCssKgIv+LOmhLNMrRa4RlQ=
X-Received: by 2002:a05:620a:19a4:b0:916:1806:302d with SMTP id
 af79cd13be357-92ebb60cc71mr55371685a.58.1783343058102; Mon, 06 Jul 2026
 06:04:18 -0700 (PDT)
MIME-Version: 1.0
References: <173f3fd983d735155d47e9e39d27f0c2d62a7c31.1783307463.git.baolin.wang@linux.alibaba.com>
 <CAMgjq7AQcyypJ-VhJ_CxY6fdEph64fxjOzzYU-=EkMrHemkpzA@mail.gmail.com> <8ef0b72e-a0e8-4913-8d30-519335305260@linux.alibaba.com>
In-Reply-To: <8ef0b72e-a0e8-4913-8d30-519335305260@linux.alibaba.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 6 Jul 2026 21:04:06 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z5N6FSfWt5WUZ5YmqhCzLcd3Cj1sc9B79WYX9ZbDH8Gw@mail.gmail.com>
X-Gm-Features: AVVi8Cc4-cCPMWvrStzPGpTwA44_ETQ7K94w2ZYd1ngI74f-KWgZnyW5L8IF4f8
Message-ID: <CAGsJ_4z5N6FSfWt5WUZ5YmqhCzLcd3Cj1sc9B79WYX9ZbDH8Gw@mail.gmail.com>
Subject: Re: [PATCH 6.18.y] mm: shmem: fix potential livelock issue for shmem
 direct swapin
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Kairui Song <ryncsn@gmail.com>, akpm@linux-foundation.org, hughd@google.com, 
	stable@vger.kernel.org, machao26@xiaomi.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2F1DD40007
X-Rspam-User: 
X-Stat-Signature: q6of3o61mnixhsc93isxcq73c4p6fw6b
X-Rspamd-Server: rspam03
X-HE-Tag: 1783343061-604253
X-HE-Meta: U2FsdGVkX1/qKnGNVfKNYOp+B3lnJWexTo2o1/Fkn9AaGvVHuqRFScFmvb5Y3GA0wIiZ/mErCv1hdRh34AOX2yHm9iI62Ke4pJlmwiacWrMnNh7wa2Z4FdXAz72YFHpepCkGMg+L2inYORtv3r1J64HSK3Tn/RmK2iNUc+Vxyz6qPXqRjkPGOSCMl9ZJQKbJ7Gm0X4Pize6CHETuOSCMaAoHI+fU8XIW6DWg2m6goH9KlztJZ/Cfc7EO2wFdYiznDWBtnR2TasMvFJoXaN2VB32ykjBgSBUrDRuoCjR0C/UpaiCRc9T3BmughEP2YfM0ECWKepiLlaP2DpkspDWwHYfUv3VSq9SYbxe58t2q22oCVfFK7ekne8b4jnqnNDxLAjaSzhxGXZ9k7ZOt4ia76Os/lXDRxTCjHi99Dfh4V0p/7Z7y+kVG0exsSTOQq7ER6jI4crkFBkXu0l+dT3Z5ERofzcAXWFu15yyQRx7yGUs1C6OyYhCWnZ09wXeKDUdaAO4dME47QKhEUxscyyr5YTnczfF7MOJAKXLtwnhrZ5IOv3L6bjHzdE69DXikWQfO4tR4psxOcltFBHr8m0UNmtDZGgE3A+eVr7mLGazp12SkVyOTyy48+lmap4XiRt0BZQb7LXI6qyicqq0KEiuwVtSCYhn8GH1j1+uOGVk6HQlUYSUR0gc65Dks+zgQDckfEwDekl06u/xoxM1/lStjpxHDBK/OZNmFaPkDewne0mOuHKY5C+wLesSGq3CvCZPiuJTeehgalzRt20I9eBuIo1ctS9kI6qUx6hmmBwkkqFLq+6o+7gB1p0KtY2s+9DNDn4CmiN0kgbFmILYOLNvC5LaYNqudHKr1I2r0y9wp3kRTUTW7wxCPAiZwRuPpUslBS2lqJWmugtHW3hT1G0ev2I/0ncFZsyLQ1nEUyHF03NO7r6KF6t30k7hScnfu/gBXge4dJgHlFbQAkKAg0wJ
 xE9mVYim
 P3q8ZPM2z/OHO7X/hNuN53WLBYDRK13mPAjgacfGE1C8GlmI4MtqYhEhP1pal/xUBFgnmCE7Y5w46oGoQLKXVPbFnbC1hEq2ns2IIF/TG4e6DgpOpH/BrgS8OwuOgSOp0TyLDTJZtP9G3Wz35wz3ITwxk+tGXMMM20s/9FLxQcbWokysU2nAPHEiRbSS5dDrsB50uWHxGSE+ltM+W6NWnCxYudXoG1qeW8Ox54wRexaU/A2K+MR78gC7X94I5Nw1Tdssgj6nOCStmFUVb3csm6jXJag+4oopaciq05clrQPAl8x4+gCiuG8mbYzULfqJASBjUEic35Lpk7lgO6T5dhIx1L+FDeTx8h74z27wqZxZokaeQxfkz/Dx0rQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 6, 2026 at 8:08=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 7/6/26 1:59 PM, Kairui Song wrote:
> > On Mon, Jul 6, 2026 at 11:25=E2=80=AFAM Baolin Wang
> > <baolin.wang@linux.alibaba.com> wrote:
> >>
> >> When skipping swapcache for synchronous IO swap devices, swapcache_pre=
pare()
> >> is used to prevent parallel swapin from proceeding with the swap cache=
 flag.
> >> However, on PREEMPT kernels this can lead to a livelock, as reported b=
y Chao[1]:
> >>
> >> Thread A starts direct swapin of a shmem folio and calls swapcache_pre=
pare()
> >> to set SWAP_HAS_CACHE. It may then be preempted inside workingset_refa=
ult().
> >> Meanwhile, a higher priority thread B also attempts direct swapin of t=
he same
> >> shmem swap entry. Since swapcache_prepare() already marks the entry, t=
hread B
> >> repeatedly gets -EEXIST and busy-loops waiting for thread A to finish.=
 But as
> >> thread B runs at higher priority, thread A cannot preempt it, resultin=
g in
> >> starvation and a livelock.
> >>
> >> Fix it by yielding the CPU with schedule_timeout_uninterruptible(1) wh=
en
> >> swapcache_prepare() fails, following the same approach used in commits
> >> 029c4628b2eb ("mm: swap: get rid of livelock in swapin readahead") and
> >> 13ddaf26be32 ("mm/swap: fix race when skipping swapcache").
> >>
> >> Note that mainline does not have this potential issue, which has alrea=
dy been
> >> resolved by Kairui's swap refactoring work[2].
> >>
> >> [1] https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@xiaom=
i.com/
> >> [2] https://lore.kernel.org/all/20260517-swap-table-p4-v5-0-88ae43e064=
c7@tencent.com/
> >> Fixes: 1dd44c0af4fa ("mm: shmem: skip swapcache for swapin of synchron=
ous swap device")
> >> Reported-by: Ma Chao <machao26@xiaomi.com>
> >> Closes: https://lore.kernel.org/all/700a2cbf90a2484f979aac858f08f5d4@x=
iaomi.com/
> >> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >> ---
> >> Hi Chao, could you try this patch to check if it fixes your issue? Tha=
nks.
> >> ---
> >>   mm/shmem.c | 2 ++
> >>   1 file changed, 2 insertions(+)
> >>
> >> diff --git a/mm/shmem.c b/mm/shmem.c
> >> index 94c5b0d78ac3..d4cb57b3b0ef 100644
> >> --- a/mm/shmem.c
> >> +++ b/mm/shmem.c
> >> @@ -2066,6 +2066,8 @@ static struct folio *shmem_swap_alloc_folio(stru=
ct inode *inode,
> >>          if (swapcache_prepare(entry, nr_pages)) {
> >>                  folio_put(new);
> >>                  new =3D ERR_PTR(-EEXIST);
> >> +               /* Relax a bit to prevent rapid repeated page faults *=
/
> >> +               schedule_timeout_uninterruptible(1);
> >>                  /* Try smaller folio to avoid cache conflict */
> >>                  goto fallback;
> >>          }
> >> --
> >> 2.47.3
> >>
> >
> > Thanks! That's much more simpler than I expected. Do we need a wakeup
> > queue like the one in commit 01626a1823024? Perhaps the reporter can
> > help confirm and test? I personally prefer to keep it simple if shmem
> > users aren't as sensitive as anon users.
>
> I agree. I'd like to keep the bugfix as simple as possible, if the
> reporter's scenario isn't latency-sensitive.

On Android, we don't see much shmem; it's much less common
than anon. So the chance of this concurrency happening should
be lower than for anon. However, shmem can be shared by
multiple processes, so could this still happen if process A is
blocked by process B?

I'm not really sure. Only large-scale data can tell. :-)

