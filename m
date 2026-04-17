Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C1E6F8E4A0
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 02:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD5BD6B0005; Thu, 16 Apr 2026 22:41:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86B06B0089; Thu, 16 Apr 2026 22:41:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B75C36B008A; Thu, 16 Apr 2026 22:41:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A602A6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 22:41:17 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3D65FC3320
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:41:17 +0000 (UTC)
X-FDA: 84666496194.20.4DE2E0D
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3E2624000A
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 02:41:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TOQ7ULbQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776393675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xE4TThKuYzkhlWIVTCJZ18ghCGkVJD88HoP2yiGEL78=;
	b=mfha3iMEImzdTfWoJsBM+lnHDK7xRiVvwUZTImnuRFeG5bOYGh58XD7GLGmdOXdVeirjK5
	gYvpwadPOxGoY/nYUmDS6vLRECoS4p4oRHb+u3KUlDt3ujjHsGHTrYyaIM1eLhh48UeWn1
	VahYe2f/qHKt4D3A53qaidM+Ku4YEEo=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TOQ7ULbQ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.51 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776393675; a=rsa-sha256;
	cv=pass;
	b=sjlmVtJChXSJk6e9G4LFpOE+5g0iadaDGiKXcgMmSoRLSpQGUuvdk1iA6uDfzEpXdJT5T2
	c/N9OiBYOal1AxDCccHgL/AGgq+6Pv7Vg13WluCuDTYjJxSZMecmvBnhsUDT0TYKx9Ze++
	tevP7NpYH/9z8GQKD5Po5ln0aoxG+eM=
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-43cfd1f9fd1so74330f8f.3
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 19:41:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776393673; cv=none;
        d=google.com; s=arc-20240605;
        b=Da1JnCJzAkCiWqHut9g7EEbRtMsBx8Xwh1sYSzLEOg9M2fQ7md1m6/8SqvcxqoaLNf
         805unZ/aWZG+UbeFIlaiAXWi5XLY4lBZF+blhsvG3790FOMBgH6wLhgqrQy4uOkRlIxy
         rXm/++aKzn9Z1GCF1yHTjyopPxT/K6WsL71a93jxt+TNLjmnh0bFnveIONvaoZ6JvLyT
         wZ25rV1YIHzIUOVhIKJqGoCb6woriexklMUomG19n8HvPYsraL1IzVbQxTaijGjXx7cP
         x3a2dH3XHkZC9OoCN50ipoO1r8hsjImN3AzWKUt3YcRB/SNABALdQLT42Wvm2QytTe1S
         iHiw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xE4TThKuYzkhlWIVTCJZ18ghCGkVJD88HoP2yiGEL78=;
        fh=QvcH/O1zmB00PMFjqG/h9Ye0+ZZHzPN2K7iy+UekaPw=;
        b=NRA1qG5PZ+m5wixBdOJVaCBNufZXWBkgzu8MulsCV0Idmo4aoUFGM6hX+Q9Kbs5/Nk
         EzSDrstsp0o3CKpWHCHHo2GbnchEdi5YYvcPAKkQFO2oUgGmgBxsJTFr/1a2wUT8nmO2
         cu52Qge7+znO/vljve4Thia/OdTrZnkxib2iYL4bMJqQ0gdW4IFRthxoGpa1gBbcfKVm
         FLnQC4CE+FcajdretKZdI89b2DDLzrgDJcOfC49oAvrOyvU2coSTPbeU9d0blsxArg5p
         zMvU0FuAnoOfen/CS3Gl08lPRaBKDiXbQw7AP1P8SpAPLx+F5KFuFYoBKjidrUVZMs4h
         uTbA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776393673; x=1776998473; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xE4TThKuYzkhlWIVTCJZ18ghCGkVJD88HoP2yiGEL78=;
        b=TOQ7ULbQIoY8wrUdRKukvnyAxTOGRhY/8jhDSTAjbKlhZ81UsV3sh7SrStHWm3YiRB
         gkSOGqc1+Oxc5W7UTvVSub41yeOdAkwBh+u9Mz4kjfHRM1by/iTQP0Xk+ewkiCAOPql8
         SMo1nDe4pA2zpZGdA7rzkO5NkrYFiCHlOmYjcbp6dIYIeHvlGftLZgez3mH+FWGXapx9
         foeHvW2aElsREAzmOtI8+F0zVGq0h085JxAOqu+OGq+Ri6j1ENKmUH73IkdDlSrCE6Xw
         0TClzHyD8Mbcou8xdmBOr/Bvysp4Lpg/oNfdPvavqocmKmWh55Pu3FYt1PaCEy6AUeJw
         vbqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776393673; x=1776998473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xE4TThKuYzkhlWIVTCJZ18ghCGkVJD88HoP2yiGEL78=;
        b=P2tXvTpLgttdUjQ1GJBoBfxd7jUcO8gEHHkoJefioDtpbRTDVKiieGDJb4oYMIuBx2
         FtP/xsuaQ9QIV0C67mQj2NpkjQOAdD8EOmQjSABDE2qwrtX8br/rr00/9CFWXxENWnLk
         UBf5veYndLMVVrf3azhV3vQC3kVI7+FfzQFF4XA+Ts3eTeJjrf5sDWR1hHqTGW5E+7q1
         dN/PN82WP08BLTelj4Ms0grVhC2O51ElrBwIoBRSckGdp0Fi586Lq2H01NQ1eQdJ/6zZ
         pZ29Y679NbcBmbTI0pTNI82hphZZpCSeMq5SnThsvcjBY21wd60MqiTouBfs6CEmsTSW
         TKfA==
X-Forwarded-Encrypted: i=1; AFNElJ8KmEvlWT9BFtm1DU1QcEkOD+/l7hZqrasX8O4h+ZaCEFORLwdKtlT9GFOYh6bCAi15Br2L0YSsYg==@kvack.org
X-Gm-Message-State: AOJu0YztlKW0OemtWVjp/kfCQq3E0UiM0Sp2KmA34AZDromElKRuvipf
	5U4HfZ/WHsIzvaZM8cV/C5qfLWg96ATcFaYHhcdjF5p/54GsfvTIeT0h7YdQ4kbVLfPnZLfi+5G
	xHliYiI5FgGtWkYLhSG49M0bqVC6f/p8=
X-Gm-Gg: AeBDietSQs2tt/F/slzxTdPvDKbUQfI5Q4eUDuOA6ozNhCtM6qa3ayYuyd2uUXZhR1E
	niL4tOEQ8WMAPcZ64wYUg3ch4nDoxeSuw6UFKdK9v1Fi3qFgdVowkahOo8Lel/blSMjqMH1nqBx
	bzdTEr2qzkJke6ixkOcH6jmTygYwZFrDAXX9Ov6899KA0G5yklSjErb7tSIxWy5MQ4VRVPSKUIm
	LBQTIwHLLk1c4gBL5A45tr5KeF9IBUBxNlhVe6XezMKV2NW+M2IpjsnMH8IHkRO9axVaL2aj0lg
	5jeoi9rCy0lHU0ypicCs51172ZXrIVNDDgpwUTnezcmKA2x5LAHKaTvKeaxLRobYPdI6+uxqL1z
	ovulmgXClLqAL3HAE4OsXPWiTEelGn2+tlezo
X-Received: by 2002:a05:6000:22c5:b0:43d:4b00:9ee7 with SMTP id
 ffacd0b85a97d-43fe3e10b0dmr1165369f8f.33.1776393673340; Thu, 16 Apr 2026
 19:41:13 -0700 (PDT)
MIME-Version: 1.0
References: <d762c46b-36f0-471a-b5b4-23c8cf5628ae@suse.cz> <aZAWGwZP_Z75YHKt@casper.infradead.org>
 <ad_cqe51pvr1WaDg@hyeyoo> <af3a7fa9-b368-4ffd-964d-9e4fcba863a8@kernel.org>
 <DHUNDMZS4YQ0.24SZXD72JIMCE@gmail.com> <aeDzovGHlFmPFpNt@hyeyoo>
 <CAADnVQLc_6SfF0h+-W+-sa-Qfvn8a02b6sbELJwpQcG7CFNqAA@mail.gmail.com> <aeGcHXmbCuZ8cNis@hyeyoo>
In-Reply-To: <aeGcHXmbCuZ8cNis@hyeyoo>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Thu, 16 Apr 2026 19:41:02 -0700
X-Gm-Features: AQROBzDG_dK2ysCmE426oeDsAcmTYlt5fDqJLAwW-dFQfRpICr3Cs9eW2BGt56k
Message-ID: <CAADnVQKLNDitD+WfNCr-nB955GVO7YZeHMjkuOs-=sqnvYyTxw@mail.gmail.com>
Subject: Re: [RFC] making nested spin_trylock() work on UP?
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Will Deacon <will@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
	LKML <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Waiman Long <longman@redhat.com>, 
	Mel Gorman <mgorman@techsingularity.net>, Steven Rostedt <rostedt@goodmis.org>, 
	Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3E2624000A
X-Stat-Signature: gujmrqt3jgzpsy4k9h73f9t5i8kpr3qj
X-Rspam-User: 
X-HE-Tag: 1776393674-422787
X-HE-Meta: U2FsdGVkX18ruICshelg7Kuw+HnVNPJfYKN3YqqWh3gtDBiGOYGjsDFISlgY/ypynhwaCm6duz+KI2fbVPnVWQQasOT/W7+Rrqt4j2RQsLJE50l4s4cqXgysKZJkL5zEPGsXLwJMsLvG27u+48CmkWaIwZuC4i+KDwtIkDc5KPVdb+LuVLRRkQcd9HprGdpyT14Db/KNDYdtlW3pnwY9YjR79XMMoFZI2t0C+QE0elMr7eMO6v/smAzVo3VQRw1flZThq7esoLjhcSlu9fPmmY2kU7gL7g1l28e0gANm65LshLatdZag913UQIQN8jLfBOLlBSQJ8zXC9wbKYl63uOLQGeKCKF8o+NJaiji5kYVuZpTuvEzebCm+KX4LAwGYbx/ACnDhCDt/sdaqyywh79IbHzf97/62Z/k9TXR23cl9uwjANKZ5bGqSz68wut3YLyxKDSoaGRvYpzObxBiy87CBt80W64ldnhD7yfDPV4tX9Yw5R8BvJ9llO9OWGGyXHdYh84fmAxdrx8WIItBeus0wb8yDOzU27L+fm4EPfWYp8tSAde8FgvBXJOTPBuIQ3GOmas7ZZovTnb9/8nbR9S++oEScG8Qh6KR5wvEd99nbUtmbc2yV3bgVVL5l3hQ5Ob0J/0H85neKLdSSmvP/FrLNVb/89juKrRLZm8iZ+WEUL2rVPpeyiOM68Tz0OZR+p1JgJFn3jK4ROe8tqp2tlUxACkLfnOaIZ95jSfRO5Kx3V9GXe++qQqaBdbFFI+el2Cq5yud3J4/4vtgwjmmP9X1S9lGvaIaOWPvl7L4ZfPaW6hLlrpZLvJlqhvpG7qPiolQJr1BZIMRCFpIkeVqM6eXClqyD4kskMya4Kz+0U591kiV8kYiqYaGS8qdkT6JYlKVfWy2FnK6dYy4e9xi929PC0x+XOVyOdrP3O7ZlgftZXZ/1rEO8UFmflVbFXl/trV2T/9+1iO9ay9Swxvi
 78daMEK5
 gOyeg50hUDjTdsswDwtAH5aOanfmVJA9GE8NBOtc7FJzYDS+uY8DARH78GwAh2Vh0BKmS5LeKg6XwaM1crcSLtg2QzAoVg2Z8fOStxSSPk6tNT6KTU85y6dx9LqkOTTsGv403GocRfCTHsb73CZEvgHATyYMWTycXG4Ia1kpuNCYKqFUJqsRaKMfSoM/4Y/tI7iCuph2okq0MOJMpK3M2/6G8wqtEwxSwNVMQbsKf8BGbsPvtG96Zigz+bu+7Janf9FXOO/Mz0+Iw4LjP2i5RGoConn4iWDPRVZazOQCZbz/UQQzB6+M/JMUdNon49TwFDKJPN4TW5cciL3cDtItWVaEqHMUrzga6LUlEw9zW5RK0xNZNRdRGdxXNzigRIzXwBjI1Xx4NB3nkv5HakU4SeV9Mzf2PlBb+DfSOwKA3ze628i+p5TcyXluqPKiM+okfcPIy5vfxnTO+SJKNPOscSYSAxrR9m7a7mJ5QS0bQ2E0crEXkfLx9XIv4diRfNiNtweGFWaSU2LmUl8oZYPgTVLGsRmxadCqT7G1ySqJzYvRNznozB8PAbO7r6zRt7vGZmZQTDQOWMJNqpc4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 7:34=E2=80=AFPM Harry Yoo (Oracle) <harry@kernel.or=
g> wrote:
>
> On Thu, Apr 16, 2026 at 07:37:49AM -0700, Alexei Starovoitov wrote:
> > On Thu, Apr 16, 2026 at 7:35=E2=80=AFAM Harry Yoo (Oracle) <harry@kerne=
l.org> wrote:
> > >
> > > On Thu, Apr 16, 2026 at 07:26:36AM -0700, Alexei Starovoitov wrote:
> > > > On Thu Apr 16, 2026 at 3:05 AM PDT, Vlastimil Babka (SUSE) wrote:
> > > > >> I think we need a special spinlock type that wraps something lik=
e this
> > > > >> and use them when spinlocks can be trylock'd in an unknown conte=
xt:
> > > > >> pcp lock, zone lock, per-node partial slab list lock,
> > > > >> per-node barn lock, etc.
> > > > >
> > > > > Soudns like a lot of hassle for a niche config (SMP=3Dn) where no=
body would
> > > > > use e.g. bpf tracing anyway. We already have this in kmalloc_nolo=
ck():
> > > > >
> > > > >         /*
> > > > >          * See the comment for the same check in
> > > > >          * alloc_frozen_pages_nolock_noprof()
> > > > >          */
> > > > >         if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hard=
irq()))
> > > > >                 return NULL;
> > > > >
> > > > > It would be trivial to extend this to !SMP. However it wouldn't c=
over the
> > > > > kprobe context. Any idea Alexei?
> > >
> > > I think Vlastimil meant it'd be trivial to do:
> > >
> > > if ((IS_ENABLED(CONFIG_PREEMPT_RT) || !IS_ENABLED(CONFIG_SMP))
> > >                 && (in_nmi() || in_hardirq()))
> > >         return NULL;
> >
> > This one.
>
> Thanks for clarifying. You mean not covering the kprobe context is fine.
>
> But I have to ask; how is that fine? Wouldn't this leave a small
> possibility for a kmalloc_nolock() caller to trigger
> e.g.) use-after-free bug even without noticing? (yeah, very unlikely
> for somebody to trigger in practice, but not impossible)
>
> If it's unlikely to use bpf tracing on UP anyway, it'd be safer to just
> disallow that to happen to begin with.

Don't fix what is not broken :)
I'm sure there are millions of other issues with UP,
so there is little to zero chance that anyone can repro such a scenario.

