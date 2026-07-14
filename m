Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B34DC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 22:26:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B39F6B009E; Tue, 14 Jul 2026 18:26:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78B8C6B00A0; Tue, 14 Jul 2026 18:26:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C80D6B00A1; Tue, 14 Jul 2026 18:26:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4AA8D6B009E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 18:26:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9C223C04D1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:26:23 +0000 (UTC)
X-FDA: 84988817046.03.ADFF691
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6B69380003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 22:26:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i42a4VKV;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784067982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XW3L66ASo6nPb0QYUT2YcX697e32EmDld90wK/FIsA=;
	b=FeIhDw+tE87SC25wgUAj3HiNDLOgQlXFDuL9YMrXNmsck4EM6cJvLiqgYXUWeBZ66fxosX
	JZubgEbr6+hNLBW9GYIvbJMBKPYnHqgTJSrgwmKyI4uZ3QGubD/OAZTfPd8caYcfSznuGu
	+k4jFesAFr6905dyxDpm3SAXqLmfY5c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784067982;
	b=1lM95toQ9S5ffMTkXV1B2evjiLPKkN4MG2JsdxpOgD7MFzaus1WEYugWQ23eV7QLQXel0i
	dspCQ9R/zI9utE2c4SgaaQCDNY+qzWkExE065IP8W4j0DMy28BxLD+M3UtRBarQjTAkBal
	8xlwF6eDHdKghk9kI33kFhqRe5ev8YI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i42a4VKV;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 14 Jul 2026 15:25:40 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784067979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8XW3L66ASo6nPb0QYUT2YcX697e32EmDld90wK/FIsA=;
	b=i42a4VKVo5N20vlVKTvopu/hg8gbxNnHB9LGHEJLwYkKQDRHA9C7BCJ7ncjziBV6nDqfoS
	1SQp/XZCif3gOzGjh9r9WAYq4iNoe9yd430Lpvxo8WTxPIgKv/dlPWL9ivdXVnFQYZPHrx
	2bSJu/0FMyYADnrDNvuOJLi9nUvVGw8=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>, akpm@linux-foundation.org, 
	chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, gunho.lee@lge.com, 
	taejoon.song@lge.com, hyungjun.cho@lge.com, baver.bae@lge.com, her0gyugyu@gmail.com
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <alawYov0c7a0Q6_l@linux.dev>
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330>
 <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330>
 <alae-LIRwEFUjgs1@linux.dev>
 <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6B69380003
X-Stat-Signature: qy7nrfhdoi1woy3wg1gs4e1zy71q9dzn
X-HE-Tag: 1784067981-614539
X-HE-Meta: U2FsdGVkX1/F04KqAmar9Z+EU0CxGSyFfGhGHxQ3AEU9HGLglG5EfHX7ioBSqG3DKU5+IG5LaOHHFnV7Kuhm/u6iO3ZX+TUMY2BhoAN2sUU+JnREGmjuxBn2hiHHYpf0jk3iFt9Kpy1W6URoinYHhNdwk+++AFLNAzt0CbcS8uEfb5oEhbowJn4J4FDMgbwKFOKYRNt7MyzqfPB+DGFXW9vyMkZWcW20cFYNCSFirXkW30EmusW4IN+64jOxiS5luIfcRrL6C/miHvIBYyLQTxcr3evKQibWk8mm/yAwPbPv0GqOaKGbwtFCs57zKrlrJI/1BuCr9LUGCN2ZdETRPxlhU/kL2AU3Llza8CB3+iuoDNvFbuTCzNnLsyrZI6qKtXGa3/TW44cVp2DnSrVlThqPKvkSPlYEoVQWPSTJTBT8//5K7MtDI7qZUhtv3lZxlNlDg9DK1K0bejfNlS/o9weGsBhiPA0D4meb5VeZsMVcRlw2ENCpL4nNpL4ViCL/p7CsL296A/7b/mnGmEQTNhWDTau43s4PJmsW9LvFuS1d+E0CUlodJR1+kIM+sfGvchzz4PoHnZj0RjfHwAIc84++BGmaoLt1xVRfYC/3ouUc5W2KtpvVBwKvf4NJzg4c8NhqKHhYhI6olxY0CsikRIlNm3VdQXrlrfIxY5Xqc1As6R209j1awSCwDgzwxSesHscwtUxSY0Wm63Rx2BDLyA2AGNj1MZbIJxbiOuMCNdykbKJnzC61NT7SUnx06RwSCptN7e7nhUNvQ4Mkr4q2CNOttHEcqSEk0Bm8WpuaORN+IJosrhdwug4jAVPB/vvqly5dG/43gYZvny3z0rAC8kylqudtzcj63r0gR4h4Cu/cKIEadITE2aa1SGf46b02QmbMavVzzolUMfHvSZC5VcXFFuYacv1tb/VBvjOXC4E5PTvp0ofgFUaR5BmLp8mQsyHW9gG3nOvvZshfPg6
 Vf5TRme/
 TBx6sXSA4WCQhDtqRJvtI+nXqNFZYDQWmuJ6YqUnWz2M3+/AfHdKapDlQk6Yf1uBy3A/sdmt1K6fNHQCEhaMoYOBBEUxFwtkclznQZJIwM3N0KVjvzUbuThPy4snpHqNJs/KAhpaixQStrg+XFg0DnS/1vq1DQos7M8a4RJKySKO4661I8/CqrsD4iKKUnTySkTLoOmvcFP2+dIRPriFF52RWFW9kCeT+E8R25p5ceWHp5nYEkWJr12zHhPgiu+hw+ZSXXX8fLpzDqDZJge9XIB5R0q5VTPwjwFoZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 01:52:14PM -0700, Yosry Ahmed wrote:
[...]
> >
> > Yosry, what is needed to enable zswap as a swap tier? What will be the minimum
> > requirements for that?
> 
> From zswap's perspective, we just need to skip zswap is zswap as a
> tier is disallowed. Could just be a check in zswap_store() similar to
> the check if zswap is enabled. I am assuming that if a swap tier is
> disabled, nothing happens to the existing swapped out pages in this
> tier, but new pages do not get swapped out to it. This is the same
> behavior that happens if zswap is disabled at runtime.
> 
> From the tiering perspective, we need to accept "zswap" as a possible
> tier, or maybe creating it as a tier by default if zswap is configured
> would be better to avoid handling the case where the user doesn't
> create a tier for zswap. 

Default tier if zswap is configured makes sense. Should zswap be treated as
having 32767 (or maybe 32768) as priority as it sits infront of all swap
devices today? Also whichever swap tier has priority range containing 32767,
will have zswap in it.

> We also need to disallow zswap being the only
> tier as that combination cannot work without vswap.

Do we need to do anything explicitly for this? I am assuming in a kernel with
swap tier support, there always exist a swap tier if there is even a single swap
device configured i.e. a tier with the full priority range.

> 
> I think this should be enough to support "zswap" as a tier and allow
> disabling/enabling zswap per-memcg (or globally?) through tiering.
> 
> In the future, if/when swap demotion is added, we need to figure out
> how that would work with zswap. For example, if pages should go to
> swap device A then swap device B, then an entry in zswap using a swap
> slot in device B should not skip device A and be written back directly
> to B. vswap would naturally give us a solution for this problem.

This seems reasonable to me. Punting demotion/writeback to future.

Youngjun, what do you think? Is this reasonable amount of additional work or do
you envision some complexity here?

> 
> > If that is not too much, we can make that part of this series.
> 
> Yeah I think it's better if we agree on the design and zswap support
> before landing partial support.

