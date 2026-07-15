Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31281C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 17:27:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBB596B008C; Wed, 15 Jul 2026 13:27:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6CF96B0092; Wed, 15 Jul 2026 13:27:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B832A6B0093; Wed, 15 Jul 2026 13:27:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8A66A6B008C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 13:27:52 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1591212015F
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:27:52 +0000 (UTC)
X-FDA: 84991693584.05.044944F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2CF5AA0011
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:27:50 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JbSBg3xA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784136470;
	b=3xRt7rnUGtXiZwmf2zdr+12l79mY634FmXHmd9wpaOy6xoIjFVpDC/8W57zXYk2S/DcdTM
	7dwjowEP0//aGzQN79dpB4h+guFxYvPE0awXybGc6hp9Ol8y/xlmyTl9QeMidiSdEaEA5R
	flRwbyjd9DioqSiK72pEr8W9af42i2A=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JbSBg3xA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784136470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NR8w0dFy7e0Mw1zCteSq/0BgsGyG302q7jjwjUv8Bqc=;
	b=c+P6ixLH+tpJuQvENfvcpSMZfCU2TiNGPqqgat7b7shbONOpLbMtu5KOMn77aWPK2ohWbp
	tNYdbfv3017C4CK4Gfb2gW4mjuz6RX0qquIsOnlD9vvlHNXWgW3BMB3HHQOO5dV2mCjWpZ
	d46BQOAg+flB9eyyitrFT1ZI2BgEZ0Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8E43561836
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44AAC1F00A3D
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784136469;
	bh=NR8w0dFy7e0Mw1zCteSq/0BgsGyG302q7jjwjUv8Bqc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JbSBg3xAuVHEwGYnVFJpZ6OwQ9JeOeZz3MNNxr/dTaDouD3+PI1rvYHLiLMpAARZm
	 lEh8/c/K/zukxxMq6tZGmhbLxEq23t7GhJk2114rXki0CvYNy45Yw4fWYnr9xZv1J7
	 IZknqzImbcMicrHmFXuK1ueB5qlN5PgaNeFASnZLmg7xbBUpfCdN/ROyXeSNJdgZw8
	 3+WaSzbzLAN+nwOGMIc32D7v+wluOIuhqhKHfDPUgb3KI+NE2ZJVm1uE0B6097wEpI
	 npIf0IG786qwfzBpAWsSP60PG9aDh9bdHk4JRefniMbEQluKC3Vub+Gke/Ernepp5z
	 W/yHYqAhliIcg==
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-81ed27fe974so8264887b3.2
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:27:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrUKKyYOCf237ONs6DrpHOhit6EmL0c7zwGe6lFiYPiUxqZh7Vkk+iN2PZI8OX2N/rV+nmQAsgXpA==@kvack.org
X-Gm-Message-State: AOJu0YzKwWeX0PwzoPnmJscWHig0p9nlk0AllD0BwQFHoeUG/3E/1L7+
	h0Sq0lKtgfMmxCorqFHE0BYaA2dA7E9vn53uPFhNiLmnEcb2ZQvEUjgPRFTZgmugFiIA9aSP4dy
	p/g+acKhRecEVBxGhH+IFzmAGEpTWi6rWHiHHpTAuVg==
X-Received: by 2002:a05:690c:7347:b0:81c:bd45:478a with SMTP id
 00721157ae682-81e90139bb3mr142898527b3.41.1784136468624; Wed, 15 Jul 2026
 10:27:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260713025644.170839-1-youngjun.park@lge.com>
 <CAO9r8zNJfhirbzvJzDWRaBQOM7XZcf_Jk0Bz=Y4dB4QK4W-MwQ@mail.gmail.com>
 <alUK8DWRy4LPxTpY@yjaykim-PowerEdge-T330> <CAO9r8zPvWKgQ8+ABxSnVnC452-enyMqCjBTA4pfNDVxsoJr25g@mail.gmail.com>
 <alUQ0ksPP00PVwew@yjaykim-PowerEdge-T330> <alae-LIRwEFUjgs1@linux.dev>
 <CAO9r8zNfp-T19cYyZxKHBY-FnmQ_9=fbP4JYPPFgYtUCo5fZyg@mail.gmail.com>
 <alawYov0c7a0Q6_l@linux.dev> <alchYX43oV9KybWx@yjaykim-PowerEdge-T330>
In-Reply-To: <alchYX43oV9KybWx@yjaykim-PowerEdge-T330>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 15 Jul 2026 10:27:37 -0700
X-Gmail-Original-Message-ID: <CACePvbXiWzrDeLMKLoTO7T9wzi6si3i8afgMTg4ER654+A+o0g@mail.gmail.com>
X-Gm-Features: AUfX_mzxPNZ5biQu3ZF_BuRC46X4fkCz7J6L2acTm1IDYuzpm6tY8gmpKlppCqU
Message-ID: <CACePvbXiWzrDeLMKLoTO7T9wzi6si3i8afgMTg4ER654+A+o0g@mail.gmail.com>
Subject: Re: [PATCH v10 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
To: Youngjun Park <youngjun.park@lge.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, akpm@linux-foundation.org, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, joshua.hahnjy@gmail.com, 
	gunho.lee@lge.com, taejoon.song@lge.com, hyungjun.cho@lge.com, 
	baver.bae@lge.com, her0gyugyu@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2CF5AA0011
X-Rspam-User: 
X-Stat-Signature: gepq438xyk53sqp4aqta8wr6ngokcsp8
X-Rspamd-Server: rspam03
X-HE-Tag: 1784136470-912864
X-HE-Meta: U2FsdGVkX1/bGoQCPeQasOQahbEP4PPznXLwin5ifhoFpaFHmYzTT7+N6dIdfomLsD0083stQCXHEidcGtFp2DX4h5gkjFWfok5dkcQ5E41cwNMYXKpkvBbffeQbTd6FlncpJoRaOX6l9QabH4nctGD3SuyXY9PRnDnR7fbJUJ828r3m7RbZfIMr1xyNXXIZbLwB8haZwafHYLVCrZZVEJLrznNClH0GO6HXIVwRINtp2yF2CW/zOUkkWRqdI/ml/vtcj11EJ1JuQFI0eU7PMJhORwzPzVU3oLovsY5JNMrqZj3coWjR/ZCEKuH/Mo3ub3pKKNb340jGuQy1e3rvh6rhHhoN3spP85cT+Za5Q6K8t0tffGnjmM0eIGoSTv3+tRM+j9V7qVgv1ORCxWqrYd/nIJk2Sr4Ef7Y5GHsTJ3gVnBV/ypEuZK+B/ws+bOYfWH01wMXYCL/TJARbzSXMOZv0Pq3c3fpDt9dYJVzwwzrQTtdH4AEHTNwIUc0j04NyHQ+SM8MzOB4JW5jqFXHwVcJZ84Kr+vbOcy/9lXbdSnypZmkLnQDJaCzOhZ1CjDaM6DTuFrv+hwHkj8Yo2VW5b3ubRfXcu2btlFqr1zALmso4YSr+dC3Y3NdlZ2L/w7o5g+nLduEQD5wkD/yC5Hdb+KF8f4oQvwhvB/6c1snmOtoVPBIYR2FiqSPum52uwAk/FzpCP9LsdHyLXBqesacAwzQ8+rmK57qTHmf4MfvbPNd/K0WpKxiy3L/ab3qQNWsaNHs7bF5vMYqC18/DgyKTCdFtGQItynLK7y4Q+yffKuInQ0Ac8s6MUw7S3kL0YjhFMgJJl8tHBtBLPOddR+1ciBzWDeSXWy0zPFCExnFsv0NyjQabJpLQmAbylyh+SpRxqdC3sKCLlF+/herLP+ewtYfmr8t4KeDNcZxOzgGJ+/x3jkuavgblR5cvMPYxwCoC/DUDgh2apqgnt1vmPvK
 rjyGjytJ
 o7STtUJ2DoHn7FjsCOoj2yiUE+1U2POUxrvMExwU0rTUqbDChL4HyrKkrZ2Mx0E8+ajo8kpgAHPjTLHXl0FiGseKxUfayYC4Vd1Z/7jt4Mc558wi1J4jmwwtoreX6kL2peaGgdWgqUet9O/idOf8eMekA401tSvura670o4wwII49SAl4TY8rpAi6NCbDppGFM7FCRzjbQ0vvcYNBOFfKOg2nSXmy1HYBjEagvl182XcIZBxUNHvUjEmJN7ulGyia9i8Fph0mGwmoX141GOmJ+FTqYbKW4boAphYI4b6i8ZQ8aBFOR9EpT1i/ZwgPzppSzLEjDTqMMWKLwTBhBFdiJl2iRXp0lkahji6OcUEGvkd9BNPn1Nvv3lcU0ZPv57j5nTZR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 10:58=E2=80=AFPM Youngjun Park <youngjun.park@lge.c=
om> wrote:
>
> On Tue, Jul 14, 2026 at 03:25:40PM -0700, Shakeel Butt wrote:
> > On Tue, Jul 14, 2026 at 01:52:14PM -0700, Yosry Ahmed wrote:
> > [...]
> > > >
> > > > Yosry, what is needed to enable zswap as a swap tier? What will be =
the minimum
> > > > requirements for that?
> > >
> > > From zswap's perspective, we just need to skip zswap is zswap as a
> > > tier is disallowed. Could just be a check in zswap_store() similar to
> > > the check if zswap is enabled. I am assuming that if a swap tier is
> > > disabled, nothing happens to the existing swapped out pages in this
> > > tier, but new pages do not get swapped out to it. This is the same
> > > behavior that happens if zswap is disabled at runtime.
> > >
> > > From the tiering perspective, we need to accept "zswap" as a possible
> > > tier, or maybe creating it as a tier by default if zswap is configure=
d
> > > would be better to avoid handling the case where the user doesn't
> > > create a tier for zswap.
> >
> > Default tier if zswap is configured makes sense. Should zswap be treate=
d as
> > having 32767 (or maybe 32768) as priority as it sits infront of all swa=
p
> > devices today? Also whichever swap tier has priority range containing 3=
2767,
> > will have zswap in it.
>
> Maybe we can handle zswap as an internally reserved tier which is always
> preferred over swap devices.

See my other email. Zswap shouldn't even be in the list of swap tiers
to search for swap slots, so this priority is builtin we don't need to
specify it.

> I do not think there is a strong use case for grouping zswap together wit=
h a
> swap device that happens to use the highest priority. Also, using a visib=
le
> priority value for zswap may have a small side effect that one priority v=
alue
> effectively becomes unavailable to users.
>
> That said, if zswap is represented as a tier, I agree that it should be t=
he
> top tier. The exact priority value or whether it is internally reserved s=
hould
> be adjustable when we implement it.

Just leave it alone and the order will happen naturally.

> > > We also need to disallow zswap being the only
> > > tier as that combination cannot work without vswap.
> >
> > Do we need to do anything explicitly for this? I am assuming in a kerne=
l with
> > swap tier support, there always exist a swap tier if there is even a si=
ngle swap
> > device configured i.e. a tier with the full priority range.
> >
> > >
> > > I think this should be enough to support "zswap" as a tier and allow
> > > disabling/enabling zswap per-memcg (or globally?) through tiering.
> > >
> > > In the future, if/when swap demotion is added, we need to figure out
> > > how that would work with zswap. For example, if pages should go to
> > > swap device A then swap device B, then an entry in zswap using a swap
> > > slot in device B should not skip device A and be written back directl=
y
> > > to B. vswap would naturally give us a solution for this problem.
> >
> > This seems reasonable to me. Punting demotion/writeback to future.
>
> I agree this is reasonable. I can treat the demotion/writeback interactio=
n as
> future work and follow up separately.
>
> > Youngjun, what do you think? Is this reasonable amount of additional wo=
rk or do
> > you envision some complexity here?
>
> I sent a note with some thoughts about making zswap a tier. Since Chris a=
lso
> raised concerns around this area, I think it would be better to discuss i=
t a
> bit more and evaluate the details carefully.
>
> At this point, there does not seem to be an immediate use case that requi=
res
> zswap tiering in this series. So my preference is to keep this as future =
work
> for now, and follow up with an RFC after verifying that introducing zswap=
 as a
> tier on top of this patchset does not cause problems.

The minimal change is just giving zswap a bool to enable it in a swap
tier or not. Personally I don't think it is needed. But if others want
it we can add it as one off thing.

Chris

