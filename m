Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D83B6C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 00:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 118306B009C; Tue, 22 Jul 2025 20:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A1216B009E; Tue, 22 Jul 2025 20:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E83796B009F; Tue, 22 Jul 2025 20:29:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D3AB36B009C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 20:29:17 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 367C5591B7
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 00:29:17 +0000 (UTC)
X-FDA: 83693645154.12.83AF8DB
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 40FD6140005
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 00:29:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B4vsgDXv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753230555; a=rsa-sha256;
	cv=none;
	b=ou9WwsY78fGWlV4wqW5ctfbhXwqqal6r4sXqAQugA496EbveeoHygJEiPJhIUmkYBEevIJ
	VtGepbb9aE5+I2iFUxfbWEeh/xzaygA6RkEsYGpRI4amscrpwJW0AhpiVUJSXIIJY6tKA3
	rFZpYeP5HhXoSZQZSrteQLcpQj40zqE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B4vsgDXv;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753230555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ya/iMqP+L9J9OUdonPqQ6BajrGRFzQbsY8dxwMUGMDQ=;
	b=aY5fMrfEl+vuRUYonsYaYWYkJIlbVXVLnOLz6jb8oPcsE0gchy+X3dcUOc++CxQ1CwfF0Z
	jOuyRoh2slruCKUaL0MvLsO4zkcY494AfaKZpv4MVcG+LkYhtpLIkPDtg96XMRxTE2A4cp
	pNasvSThpZedTsChyx9HV/DHF92kyC4=
Date: Tue, 22 Jul 2025 17:29:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753230552;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ya/iMqP+L9J9OUdonPqQ6BajrGRFzQbsY8dxwMUGMDQ=;
	b=B4vsgDXvvTZuPekKEvlBPO/rcadIYkXZRtK1VWBTBeIq8ySKpTBHPE5nbhUJ8NveiKFnoB
	AT/Lq/U7xhSK5nAGAUh2GnfvB0/T+yUWCoT3N5eROHXYeL7yJd7UpQh2K5LOZIdKEiz7tH
	TA5ZtxEMHLFsdhPw43GKQSyLFlJfFfM=
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
Message-ID: <jmbszz4m7xkw7fzolpusjesbreaczmr4i64kynbs3zcoehrkpj@lwso5soc4dh3>
References: <20250721203624.3807041-1-kuniyu@google.com>
 <20250721203624.3807041-14-kuniyu@google.com>
 <z7kkbenhkndwyghwenwk6c4egq3ky4zl36qh3gfiflfynzzojv@qpcazlpe3l7b>
 <CANn89iLg-VVWqbWvLg__Zz=HqHpQzk++61dbOyuazSah7kWcDg@mail.gmail.com>
 <jc6z5d7d26zunaf6b4qtwegdoljz665jjcigb4glkb6hdy6ap2@2gn6s52s6vfw>
 <CAAVpQUAJCLaOr7DnOH9op8ySFN_9Ky__easoV-6E=scpRaUiJQ@mail.gmail.com>
 <p4fcser5zrjm4ut6lw4ejdr7gn2gejrlhy2u2btmhajiiheoax@ptacajypnvlw>
 <CAAVpQUAk4F__D7xdWpt0SEE4WEM_-6V1P7DUw9TGaV=pxZ+tgw@mail.gmail.com>
 <xjtbk6g2a3x26sqqrdxbm2vxgxmm3nfaryxlxwipwohsscg7qg@64ueif57zont>
 <CAAVpQUAL09OGKZmf3HkjqqkknaytQ59EXozAVqJuwOZZucLR0Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVpQUAL09OGKZmf3HkjqqkknaytQ59EXozAVqJuwOZZucLR0Q@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 40FD6140005
X-Stat-Signature: 68r5swntxns9ezbj5o1by5nkah3w99nj
X-HE-Tag: 1753230554-687993
X-HE-Meta: U2FsdGVkX1/dZ5p9GOesaft8uQ/BFOxMXZ6lYSKwgFmiR3lhaugHlX6A3IBlx704KvwwtUUXKYT5VJU+0KPhavA+mDDPiVcJt60PrI5eTIRKuu6GYXJP8MEPH3VecdnXjM6QkKX4AYNTYRU9QjwAIxndSKW5JRHY+LPZzNghrujTLDewogyBo4OMhfPywtOo8v+wBTHr2Y4xINz4n5ry+p7Qa8KjXPoRnE3Dgf96p8+bmZ76UmO5IXZZvHFty11YS8kkYuSHJAVaJKAJpHJO9HSmNGW9exqlpAZroFSOFXQsMYlzwmA1dVA+EmLeUgnDo8kBsyZK/XbkVzas+sy1TF3c0+pu/XOyrqNK+THDauT8a2ECKDB84iEDafpv16+EzGDye4GY9/9ZcugoK4AbWFo8+zInFWpqWEn4fdjifGOxGib9E7j4y7lnehWHkBz0CRqbsmFsSOf0m8x0M35zW/Tw4GTuGOg057o7QCizO3f1c9Wda7q+bFIsb4v9Drl/RrW1wRSh7JrSe4xw4vRThlpY/vaNv3BI1sKwwGwSEynMMAjseHqC5VLwIpILzfPtj6EnImwvTES+rl8dvbuw2NyRTCDZLcJDU00PjlD15tojd5Yb1RkfsTXtGTZIVT6h2QpXcqa/geHBLf9eTlYeeRbcH4IacPtqbY5+gWsHVd0H/tB4EeWf3p8oSBj5Nn1po7X1M+7B92nl1XEH5k45IdhaIh2vUTpQakQDUkKOK8FePYHTuQt44Z4l0O0alO/Tk6Rs5ZJLatVbXFNyPLh7tbSwQ0beu9eKr6PFH7h9aMwejw6OPTypnXGYr6HYOqm6bpOKzcsv6cjRK0lnfy5zQdZBmIjfGvsawZ0KwkLoTTmAIOB02vQxDnPD3tkTm7D7DiOtxRMtc3IixXFDM0icHX6wM8GN51x3o4RG3bGrdMhL3JbDz6oxFY0OcA+6NEyQrjmQY3ISsGcCl5SBq7c
 bUIVIYNl
 +/Y/Nn2mCCPy+8ZWQWY3QvLonBA+sAbUCTOy/dvx/AK86CcDwhFufQxDpas59U/x9rnbOfq7dDyL3EtvKI4992340G1y6bk3iQY86Hi8WfbTa9LlV05b9DeDxJpr8x9DZmU5LPA6LP50UKq0wGwhj0PyahpkmZ6WC/ZmbBcxqiPMSwGKfB72U/+aHw/vvYS0Z5uFVDJ6CioJUCzQ7KVincd8INvEP7T+MomNkiBl0mXX1lvdhGOrQOnc6sA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 02:59:33PM -0700, Kuniyuki Iwashima wrote:
> On Tue, Jul 22, 2025 at 12:56 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Tue, Jul 22, 2025 at 12:03:48PM -0700, Kuniyuki Iwashima wrote:
> > > On Tue, Jul 22, 2025 at 11:48 AM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > >
> > > > On Tue, Jul 22, 2025 at 11:18:40AM -0700, Kuniyuki Iwashima wrote:
> > > > > >
> > > > > > I expect this state of jobs with different network accounting config
> > > > > > running concurrently is temporary while the migrationg from one to other
> > > > > > is happening. Please correct me if I am wrong.
> > > > >
> > > > > We need to migrate workload gradually and the system-wide config
> > > > > does not work at all.  AFAIU, there are already years of effort spent
> > > > > on the migration but it's not yet completed at Google.  So, I don't think
> > > > > the need is temporary.
> > > > >
> > > >
> > > > From what I remembered shared borg had completely moved to memcg
> > > > accounting of network memory (with sys container as an exception) years
> > > > ago. Did something change there?
> > >
> > > AFAICS, there are some workloads that opted out from memcg and
> > > consumed too much tcp memory due to tcp_mem=UINT_MAX, triggering
> > > OOM and disrupting other workloads.
> > >
> >
> > What were the reasons behind opting out? We should fix those
> > instead of a permanent opt-out option.
> >

Any response to the above?

> > > >
> > > > > >
> > > > > > My main concern with the memcg knob is that it is permanent and it
> > > > > > requires a hierarchical semantics. No need to add a permanent interface
> > > > > > for a temporary need and I don't see a clear hierarchical semantic for
> > > > > > this interface.
> > > > >
> > > > > I don't see merits of having hierarchical semantics for this knob.
> > > > > Regardless of this knob, hierarchical semantics is guaranteed
> > > > > by other knobs.  I think such semantics for this knob just complicates
> > > > > the code with no gain.
> > > > >
> > > >
> > > > Cgroup interfaces are hierarchical and we want to keep it that way.
> > > > Putting non-hierarchical interfaces just makes configuration and setup
> > > > hard to reason about.
> > >
> > > Actually, I tried that way in the initial draft version, but even if the
> > > parent's knob is 1 and child one is 0, a harmful scenario didn't come
> > > to my mind.
> > >
> >
> > It is not just about harmful scenario but more about clear semantics.
> > Check memory.zswap.writeback semantics.
> 
> zswap checks all parent cgroups when evaluating the knob, but
> this is not an option for the networking fast path as we cannot
> check them for every skb, which will degrade the performance.

That's an implementation detail and you can definitely optimize it. One
possible way might be caching the state in socket at creation time which
puts some restrictions like to change the config, workload needs to be
restarted.

> 
> Also, we don't track which sockets were created with the knob
> enabled and how many such sockets are still left under the cgroup,
> there is no way to keep options consistent throughout the hierarchy
> and no need to try hard to make the option pretend to be consistent
> if there's no real issue.
> 
> 
> >
> > >
> > > >
> > > > >
> > > > > >
> > > > > > I am wondering if alternative approches for per-workload settings are
> > > > > > explore starting with BPF.
> > > > > >
> > > >
> > > > Any response on the above? Any alternative approaches explored?
> > >
> > > Do you mean flagging each socket by BPF at cgroup hook ?
> >
> > Not sure. Will it not be very similar to your current approach? Each
> > socket is associated with a memcg and the at the place where you need to
> > check which accounting method to use, just check that memcg setting in
> > bpf and you can cache the result in socket as well.
> 
> The socket pointer is not writable by default, thus we need to add
> a bpf helper or kfunc just for flipping a single bit.  As said, this is
> overkill, and per-memcg knob is much simpler.
> 

Your simple solution is exposing a stable permanent user facing API
which I suspect is temporary situation. Let's discuss it at the end.

> 
> >
> > >
> > > I think it's overkill and we don't need such finer granularity.
> > >
> > > Also it sounds way too hacky to use BPF to correct the weird
> > > behaviour from day0.
> >
> > What weird behavior? Two accounting mechanisms. Yes I agree but memcgs
> > with different accounting mechanisms concurrently is also weird.
> 
> Not that weird given the root cgroup does not allocate sk->sk_memcg
> and are subject to the global tcp memory accounting.  We already have
> a mixed set of memcgs.

Running workloads in root cgroup is not normal and comes with a warning
of no isolation provided.

I looked at the patch again to understand the modes you are introducing.
Initially, I thought the series introduced multiple modes, including an
option to exclude network memory from memcg accounting. However, if I
understand correctly, that is not the case—the opt-out applies only to
the global TCP/UDP accounting. That’s a relief, and I apologize for the
misunderstanding.

If I’m correct, you need a way to exclude a workload from the global
TCP/UDP accounting, and currently, memcg serves as a convenient
abstraction for the workload. Please let me know if I misunderstood.

Now memcg is one way to represent the workload. Another more natural, at
least to me, is the core cgroup. Basically cgroup.something interface.
BPF is yet another option.

To me cgroup seems preferrable but let's see what other memcg & cgroup
folks think. Also note that for cgroup and memcg the interface will need
to be hierarchical.

