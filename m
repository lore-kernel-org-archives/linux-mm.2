Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F9C4C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 18:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12DFA6B00C8; Mon, 13 Jul 2026 14:38:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 105F16B00D8; Mon, 13 Jul 2026 14:38:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 042A46B00D9; Mon, 13 Jul 2026 14:38:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C39216B00C8
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 14:38:02 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5108740172
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:38:02 +0000 (UTC)
X-FDA: 84984612804.14.9EC639E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5B74F120006
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:38:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z99g5SgR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783967880;
	b=HR8+mu3K8atDcqbdAF1rv8/Xvyp2WUP93X1kLLYYfjbcM8XS2riuGrKvGoTAT43NzWWe01
	TpigAbmBtWngqN583vMlpxpVVNlIJLoJqqshShkeqzDcfBbGpXiNsOLS6HZYmE1gWqavEE
	FCKkY3lmHoJnzSchLQZGGWrp3TLcdkw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z99g5SgR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783967880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zu8862SqZ538zojnz2dlrBi5N5x5yHiHFbkXnoXgzXI=;
	b=0R2a12kvEA7ZJJV0npsgxU8QNdrzb3Gj/PFvJWgkuYIqCJPfD+vUWNhHBdeyTMWKfd2ZCF
	s/VRaWNrvEuxO938WRFclFeeX2RtoUd5uJo2YxwxTh82qUW53OGA0K3VMHmRAZjr6mFVXO
	POhsBiDhSWA+mLvGN8VlX+7fh94Lko8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F7884168B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:37:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2671F0155B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783967879;
	bh=zu8862SqZ538zojnz2dlrBi5N5x5yHiHFbkXnoXgzXI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Z99g5SgRQle79CAoNoJHX2Kgt8akKv59y6/jiTGr1vRTDX/Prf4rDu7NB+KQwqleA
	 zROsA1ERgSPivo30vlbtZ3dpf8dK7rVqqdX8VhahKUnL+dOEXn3DfngegAIFqMQWc5
	 KCPMrrLA/5xladWU6+Xm8L42Zktq1VC85nKbb2ENyxmkFF3NS3fnTGmr4afJORto3x
	 /h92bM97eqjwFve93Fo3CdMlOrLaPSSLcd4L7PB4vN0KJVQwagloXJPlk7ZMoUVjUC
	 nDSjT3r9IYAzibmRaOn2xZrLllYZqRIk25oykrsoee41ozJfsPmvdMk5i551HVe0j6
	 /mOAk3BXOvF3g==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c15b33f7b23so496027766b.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 11:37:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+x0RK9xKJPuJkRBUwvJu4Hvc5oCXjXfXXC1Ekj0V4GIKrguUKg5OjzoH6Q1EECuud85ToUeck6DQ==@kvack.org
X-Gm-Message-State: AOJu0YyzdM9PGYbONQJ3bNg4n8JcJRcgXfaw5icnGOOer7Qdj5uy9lwN
	Hn5UXmWO16ySOJL4bLrXCHZRYQO5Qvp3AKdMcqa6erhosEbo/evFVUwWU5NuV9dN8Ly1E2z4dSH
	lmlIPQXPjc7mKCrmkCMyH/1vY9yDh7kw=
X-Received: by 2002:a17:907:1b1d:b0:c12:8f7c:6157 with SMTP id
 a640c23a62f3a-c161e92de06mr409348166b.8.1783967878291; Mon, 13 Jul 2026
 11:37:58 -0700 (PDT)
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330> <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <CACePvbX1U3pLRqCP-k9x9bvbn+sXCexnbqXjwXcdvwbH+qD6sA@mail.gmail.com>
 <CAO9r8zPtcne97wQKZFsNoMS-4zpTFvaA3EU8ghnEHPfwD28zoQ@mail.gmail.com> <CACePvbWOm3EL6Ph+A_NgAp80GcQt2N-qW1qbyxOVDL3EZSAh8g@mail.gmail.com>
In-Reply-To: <CACePvbWOm3EL6Ph+A_NgAp80GcQt2N-qW1qbyxOVDL3EZSAh8g@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 13 Jul 2026 11:37:46 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO4uW=SX7se154Z6+DrxfawZfAiRO6Ar5rUm3T78x5HUw@mail.gmail.com>
X-Gm-Features: AVVi8CcWv8EoLw-Em1Z7wx-Z6siyea0fJELbRRX7-n8iFKarKLOG60WzcrGFVms
Message-ID: <CAO9r8zO4uW=SX7se154Z6+DrxfawZfAiRO6Ar5rUm3T78x5HUw@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Chris Li <chrisl@kernel.org>
Cc: Youngjun Park <youngjun.park@lge.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, 
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com, 
	baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5B74F120006
X-Rspam-User: 
X-Stat-Signature: qszxsmjcc6y1pxxdo9jnc5jqofcw7q6d
X-Rspamd-Server: rspam03
X-HE-Tag: 1783967880-301630
X-HE-Meta: U2FsdGVkX18zVrSJ9panpU/kP9FTjjYgBqjc4UsY85Dmj8xw4rxYQlZZKNAVfzUnHXQoDlYK0x0pPd1kHtjGhIjhfYfh/+E3Y6w/qJc0Pjl4DE/8gLV7B8s4GBNjKExtodNbOtldyDjJrg868VmRNknYsufBlBYRfvhaZlqNVwOhdiVlcGlGUe+B3XM7zwETgiUGQHAnCTSqrhWxgElnm56LKbCtgfSfoj0wc1XlpODjRHDC7djTq7MS7m8yCH+nH5mE+NIHhM6Du5tjig+31FJ0rqmVZHNWQDPvRQB/TWTuapMUOWXlcWTFRxfV0SQlf+FnFitbZMuRgk+Mj6/5/N2zjgJVtzlLpCJJyN3iz4Z/TtmQmY1sf3OPFXe0u4KcktHMT8Ya3+Oy+iu9tGVZJdtEF7gjKH6TB4h/7CFjfZhP0hBXressAuxCQYBZ5p3NogVxN5q3r8EdwHVmf8nJ3v0mPykyWMqEMZjEy3dTBGPfNa9wXD/cnEtGj38vDsPcZY36AH8FivzSdzaTCc6gSIRgwBo1ibEFrNzR64rlg7TIOta5vOUGGXAQbXYPXdE5c5ZVQ+kBPmF4tO7PV6wIwJEsZZPl4XAEdbfRdw4bErMAa1QxebCvPHZJG0TUFfO8QQZfQW1bqBlKR5k4DdyfP1PZFghMwOqLJqE77pIa0KVx929qEVYQDMK8qdJ/ve7PrTshN0ABhDj8JVFfWsySF6d6NtXTPZJGNpToxR/DItBs3TRU2b3xzeTwSbzJVewDzB40M8W1oFV7qnk/hkULMzNPZNmwJfFdtZX5pyfv2ieXOSNLhqFaxkF+U8wfccnUGPCKzt20B7kmjirLqBQJ0q+9YdhbWLvSew6nVq4h9ovelf17imKMfwKzQHhVp7CClD6xSso8a/1CawZPYGU0OLTKRfSDaWNcX0/SxbI/EgYXGKNPG0TKJYM9mzgyTJOoG9sFrR5DmujNHjayZQq
 RqQ3TBki
 uo7hcjR+hGuCDB9rz8SrxHLwo62d5qdfwOBuLMAqR+gmW18zc1zAEg186eA+Qistvd391BpBySkPIDKjk9IghWVdupXXi9RvEr8o/Y7e+1rVbxdkYnJWqZbB5tFiBtJF+PttdSEjUsZFnh5lRdh1i7aU7lT55p6ZnhIszE+AWB1ZMoZu1kJQUtzqR/FqhKtE9I3VuP33+szDeXtyFhJ7Q3uCFoXoe+HLAgI3uN174KTyc9G+F3A8mZEa+4eAdtSHMugWJV+I/KopQeYx4uNYVidFVvPv+q06KCRsMieAhs98rE1/O/mWCUihHMFB1/pGDKLK9uIFnPOr6jvtJOVQBM9u2dBpcF8G/lBZDl740/Ra1ias=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > > Zswap will not be introduced as a tier. The existing user interface
> > > makes zswap not exactly compatible with the tier ordering because it
> > > sits in front of every swapfile. If we change that, we break the user
> > > interface. I suggest we keep zswap working as it is now.
> >
> > The goal from making zswap a swap tier is to have a single framework
> > to configure swapping for a cgroup, instead of configuring zswap
> > separately. Yes, zswap currently sits in front of all swap
> > devices/tiers, but we are heading in the direction of changing that
> > such that zswap is standalone, at which point it becomes more
> > obviously a swap tier. If you want us to wait until that happens
> > before adding zswap as a tier, I don't necessarily object, but I want
> > to make sure that nothing will break if we add zswap as a tier later.
>
> I'm afraid your zswap user interface will have to break. I don't see a
> way around breaking your zswap user interface to fit the swap tiering.
> Once we move to the swap tier world, I don't think we should continue
> using zswap.writeback to control the tier write back behavior. We will
> need to rethink this new world.

I wasn't talking about the existing zswap interfaces. I want to make
sure that if we introduce tiering initially without zswap as a tier,
then add zswap as a tier, the semantics of tiering and user-visible
zswap behavior doesn't break.

That being said, the existing zswap interfaces don't have to break
with tiering, why do they? We may end up with redundant interfaces,
which is unfortunate, and we can work to deprecate some of them over
time. But I don't see why we have to break them?

>
> > An advantage of adding zswap as a tier right away is the proactive
> > writeback use case. It naturally fits in the tiering framework as
> > proactive demotion between swap tiers, which I expect may be useful in
> > non-zswap use cases as well. Without zswap as a tier, we'll have to
> > use a different interface for proactive writeback, and then if/when
> > zswap becomes a tier, we'll have multiple ways to do proactive
> > writeback which isn't ideal.
>
> I am looking forward to abstracting a more common write back behavior
> in the swap tier world. The classic zswap behavior will be preserved.

Right, but this requires zswap being a tier, which you seem to be opposed to :)

