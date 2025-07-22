Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C89BFC83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 19:56:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61BE76B007B; Tue, 22 Jul 2025 15:56:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CCE96B0088; Tue, 22 Jul 2025 15:56:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BB396B00A4; Tue, 22 Jul 2025 15:56:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 37CB56B007B
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:56:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 096DB1404AC
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:56:31 +0000 (UTC)
X-FDA: 83692957782.23.DA9854E
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id 660F71A000F
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:56:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fB4uUC3C;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753214189; a=rsa-sha256;
	cv=none;
	b=rZmgQDeCRixZUvIaOs6mu8o4n6vONlCNVexFm2fBZehXFWm/d/9tQ+e4N08eQCrDxousDG
	3BPdISmOIiLyGGdFB14zY+eUkPlNiLl+oIwF0rgShA2M4+shOOg10yuKRMaRoE4I8SYke7
	1trnxpl0qFx8nNJ1f33wi7sMx+7slaE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fB4uUC3C;
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753214189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AXWJpOE0ioSzjIOOhzGMWDhyF2zmDNKzi4GlW9Rwppo=;
	b=ThKxTefPsKaQ31zlzWPE0lP/C0pBBqKveWXTbZ/D/LYqb2bQPSWv+I7R/ZoRBTRxv7/v4R
	bMcV1L4c7CFCwTPeOece2WlVeI17Zp3oQmvv7uJiG3gRROLYEbsN6yVAS7MjvK67DChPf+
	H08DloApn1KAohm5zAp4N3ajEnyhUDs=
Date: Tue, 22 Jul 2025 12:56:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753214185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AXWJpOE0ioSzjIOOhzGMWDhyF2zmDNKzi4GlW9Rwppo=;
	b=fB4uUC3C9EsMYzQAhmDN3jh97gz3KD0V5/k59Mrg+UJ45xI8+h/RkdiTDGu6YOzRovTJwm
	a1DiSXgOSPK+br4PQa6lD9H3NO2FpLWstorUhwEvlGYINWIUDpTVEwo0u3ICr045l4gbBH
	0FOePTuhlvWdYxqq2ct/NaVHUefVjIE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Eric Dumazet <edumazet@google.com>, 
	"David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg from
 global protocol memory accounting.
Message-ID: <xjtbk6g2a3x26sqqrdxbm2vxgxmm3nfaryxlxwipwohsscg7qg@64ueif57zont>
References: <20250721203624.3807041-1-kuniyu@google.com>
 <20250721203624.3807041-14-kuniyu@google.com>
 <z7kkbenhkndwyghwenwk6c4egq3ky4zl36qh3gfiflfynzzojv@qpcazlpe3l7b>
 <CANn89iLg-VVWqbWvLg__Zz=HqHpQzk++61dbOyuazSah7kWcDg@mail.gmail.com>
 <jc6z5d7d26zunaf6b4qtwegdoljz665jjcigb4glkb6hdy6ap2@2gn6s52s6vfw>
 <CAAVpQUAJCLaOr7DnOH9op8ySFN_9Ky__easoV-6E=scpRaUiJQ@mail.gmail.com>
 <p4fcser5zrjm4ut6lw4ejdr7gn2gejrlhy2u2btmhajiiheoax@ptacajypnvlw>
 <CAAVpQUAk4F__D7xdWpt0SEE4WEM_-6V1P7DUw9TGaV=pxZ+tgw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVpQUAk4F__D7xdWpt0SEE4WEM_-6V1P7DUw9TGaV=pxZ+tgw@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 660F71A000F
X-Stat-Signature: y78rhszh8yfjo3phqfe5apcjauxz1175
X-HE-Tag: 1753214187-48936
X-HE-Meta: U2FsdGVkX18juqxsXG1KBGFxbbNZUdyZr1A61KZLNLshXIHb0nGx/fNdq/lSUWFlrrVPnUEQgltvPOGpds/iJB3z25fLkm2SfIGUFKyP0B4e/Ut4bjicVjXciPI5q5YZ9TMZOhSncPM+BwmAk5lpg8n2wAfBGyXoqvW5S0Rxq2rLjcB6z2hwtPblHNIjTWE9EuuUYUifjPQe+WP4YN8SAqC2Tmi9qqkaTOVZhaMz2GvfLndZeyDjTEE+HyPzsRwOZtfsRkpgDMW87qsyw3Uk3ToMEzjPgKspvB/1SHwr8ilsO41PuBKPDN/pInygEpRNPuXVa5DcYL+yAff7jC5MZMy2Zhdl3+1jlLBVA7qZ6tI2Kpl9xMlg9SNDwvtyrfL5D0+pDtWnZJCrBeIBufMt4l+d2g7U8khurl0mnmBy1TtiorC7z4Aa4moB5Zqmk/mjCvuA0oL0P1DMYQMOJ16Yg9P1A4u/Ra19DqIetwoPthqbJUc5S9lYGlpyMrjaBW6dd9+ixgXmgksLoWizPblAs3yZ9LAMTbWRJzMrNFbFS8zLf8bKRtn8ApcaX56X5kptoMly5g31ZSaoOLNG6B1Rv8m8riVrEICB+blbEQu0lkmLVXb02J750Z4ahVxxxVGTJy2cDFJ0/tmXX2trZXzXSw98vkTfqjJsdkKnZo/LEpsX/5eedsAn0TRzpzWigJdkGeFyucNCMWwWyLuTacrmiMyn4LuuP8edO6caR1/iUwR6z89XSyOHUZetopoC98l8yYmHrsFx+LWL7xUYYhlrmZQBckT9WgvktUnzou3z1ENDTrss9ZaWtFvaZDf7r570mbDICwKKs49aEKMIv3ne4Z5k51pUSAqn93a1R9WZhqZPG1R3msHCglXNI0hJLYId+GTgFTyLshS1dRLL2+St7rwoTY++K4iCFSKLz7TVdOuDopiHXhrrjBV1hRIhyxNGfWFALbF+q2pHBKnrRCH
 SqNupDAN
 0XEZyjbxRjs7MBzr76Wi0C3Ln1zmFXVJvgPDAlUJv5QQxUtUBcm20OnQt/tVSRYgivoV7xzi8gCxw512ZiFkJUYbo1U6CddTXvOJkfLKbYVXBB0EIZtTmdFbl/LbAnKaPrStZ4CkTrqXn3MbMzWwXL7LOK1RU6l5FV2mlRDcTtVjtAXP6e0ap5Bhnl1k0CXsDxiuIR/MYoB//eiXCCxQUNEDAwp8ip4EcfDh5IHVfvACea52tArNuhwmQ+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 12:03:48PM -0700, Kuniyuki Iwashima wrote:
> On Tue, Jul 22, 2025 at 11:48 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Tue, Jul 22, 2025 at 11:18:40AM -0700, Kuniyuki Iwashima wrote:
> > > >
> > > > I expect this state of jobs with different network accounting config
> > > > running concurrently is temporary while the migrationg from one to other
> > > > is happening. Please correct me if I am wrong.
> > >
> > > We need to migrate workload gradually and the system-wide config
> > > does not work at all.  AFAIU, there are already years of effort spent
> > > on the migration but it's not yet completed at Google.  So, I don't think
> > > the need is temporary.
> > >
> >
> > From what I remembered shared borg had completely moved to memcg
> > accounting of network memory (with sys container as an exception) years
> > ago. Did something change there?
> 
> AFAICS, there are some workloads that opted out from memcg and
> consumed too much tcp memory due to tcp_mem=UINT_MAX, triggering
> OOM and disrupting other workloads.
> 

What were the reasons behind opting out? We should fix those
instead of a permanent opt-out option.

> >
> > > >
> > > > My main concern with the memcg knob is that it is permanent and it
> > > > requires a hierarchical semantics. No need to add a permanent interface
> > > > for a temporary need and I don't see a clear hierarchical semantic for
> > > > this interface.
> > >
> > > I don't see merits of having hierarchical semantics for this knob.
> > > Regardless of this knob, hierarchical semantics is guaranteed
> > > by other knobs.  I think such semantics for this knob just complicates
> > > the code with no gain.
> > >
> >
> > Cgroup interfaces are hierarchical and we want to keep it that way.
> > Putting non-hierarchical interfaces just makes configuration and setup
> > hard to reason about.
> 
> Actually, I tried that way in the initial draft version, but even if the
> parent's knob is 1 and child one is 0, a harmful scenario didn't come
> to my mind.
> 

It is not just about harmful scenario but more about clear semantics.
Check memory.zswap.writeback semantics.

> 
> >
> > >
> > > >
> > > > I am wondering if alternative approches for per-workload settings are
> > > > explore starting with BPF.
> > > >
> >
> > Any response on the above? Any alternative approaches explored?
> 
> Do you mean flagging each socket by BPF at cgroup hook ?

Not sure. Will it not be very similar to your current approach? Each
socket is associated with a memcg and the at the place where you need to
check which accounting method to use, just check that memcg setting in
bpf and you can cache the result in socket as well.

> 
> I think it's overkill and we don't need such finer granularity.
> 
> Also it sounds way too hacky to use BPF to correct the weird
> behaviour from day0.

What weird behavior? Two accounting mechanisms. Yes I agree but memcgs
with different accounting mechanisms concurrently is also weird.

> We should have more generic way to
> control that.  I know this functionality is helpful for some workloads
> at Amazon as well.

The reason I am against this permanent opt-out interface is if we add
this interface then we will never fix the underlying issues blocking the
full conversion to memcg accounting of network memory. I am ok with some
temporary measures to allow opt-out impacted workload until the
underlying issue is fixed.




