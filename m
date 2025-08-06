Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A312AC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 23:34:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33CA46B0093; Wed,  6 Aug 2025 19:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ECCC6B0095; Wed,  6 Aug 2025 19:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 201D46B0096; Wed,  6 Aug 2025 19:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 13A2A6B0093
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:34:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 936471606F7
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 23:34:43 +0000 (UTC)
X-FDA: 83747939646.05.0788F21
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf18.hostedemail.com (Postfix) with ESMTP id AA5A31C0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 23:34:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="j/hWS0wr";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754523282; a=rsa-sha256;
	cv=none;
	b=CRaz/DssY9VbtY+uS5y3irgBW/poVVNiLE3WvqCetzWDFrTgVXBR6mmQ1+TmWsC4sZa6C+
	df//mVHSUGrDrmkLq1x5lTjq1jIg465vaIqIid7/CcB08lvkC9PGBtKBtVPx6fGlOSMiti
	cLMuo7juBIeqwXqv6+JX4vXfd52ceGI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="j/hWS0wr";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754523281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qvRGbUoxHQXYC8T8tbdVGdWHSxSOXMjp8BJoimfjlLU=;
	b=eUMMNuLPIjP3iseYqrIEAzwgdbdVTxi7v/yXSRVGWMjsyCPlj1tI8N/fAOf/atjI2Idjb6
	DE6unOtvW9i9OEQfqHr+6VThmiQUNTYGBhfHvU5ugKgA7nsNefjOSsJ5PMkY4Ek1Xs7E81
	y2DQQsyUjD3lknkRHWNIHR9aGvPxB+c=
Date: Wed, 6 Aug 2025 16:34:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754523270;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qvRGbUoxHQXYC8T8tbdVGdWHSxSOXMjp8BJoimfjlLU=;
	b=j/hWS0wrDoTsiYRXQLmUw2nBIRG9ovVttyd4dmFzAA401tGH2U/YCnIHLc25FLDAxcDloT
	bkyLMiL/xuyI3prrBVHRVdoSs1GQj1pqURUmBqusj4pNpZ5dfWcb39NvA5dGlrFIecP9pd
	tBbUPmoREKxIaMnSE8Z2niGmZ6jXeSY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Daniel Sedlak <daniel.sedlak@cdn77.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
Message-ID: <chb7znbpkbsf7pftnzdzkum63gt7cajft2lqiqqfx7zol3ftre@7cdg4czr5k4j>
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
 <fcnlbvljynxu5qlzmnjeagll7nf5mje7rwkimbqok6doso37gl@lwepk3ztjga7>
 <CAAVpQUBrNTFw34Kkh=b2bpa8aKd4XSnZUa6a18zkMjVrBqNHWw@mail.gmail.com>
 <nju55eqv56g6gkmxuavc2z2pcr26qhpmgrt76jt5dte5g4trxs@tjxld2iwdc5c>
 <CAAVpQUCCg-7kvzMeSSsKp3+Fu8pvvE5U-H5wkt=xMryNmnF5CA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAVpQUCCg-7kvzMeSSsKp3+Fu8pvvE5U-H5wkt=xMryNmnF5CA@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AA5A31C0003
X-Stat-Signature: 8yumqi9oskngu65tetted6d7pnhfj8h3
X-Rspam-User: 
X-HE-Tag: 1754523281-507001
X-HE-Meta: U2FsdGVkX18Cvri3kKBpIaRr/pRwu2M3854KTkxVVkmzRiaAcKCHhNulQIkf+HBahGIrhduxFDt2WaEQPir0BMk3TW/4x1oR9TgIFqJT2y3xA6dqxdo9X0ASKgW9GQgytSUwQJjuWemoxpDLhpxCTOZ4NF63ZjDlmef1iLvgabNr2tdeLwGnLeLanJPNI6uPhvrqup3Uoq2vCQNpLYwPTYOgnOYTYWA9apBerbYuVXVHwU4FWLbsiW4ryQzgJM0RcVEfXAWM9pfvJVC90gdISDQ88hSBcwoulbQ+7NHuTAposR2lrgjvXdVHjvX0b/5EJy8VfScteakbZKL+JKCIRKgpIrmI7RKIHnIULBS2YFZeRYsI6yvgMpfG77QjhzMWnJpZ0gDTlEIW2dP9oJvO+PC+oCLPfKGGH6phS9U158mkONm3ip3pWopPbgJ23cDtFmfbDtXVygkYdCQ8fsCgEjRUrpL8sovh9NBfoIKjxcZlKySbvvh90yEMdZch59AZU6QZa/ayUYfYrTNv0obag1cvPGS/XUr2Q3Ec13+AvdZW4KPo+UvkOFmwuW1WNrzezkBypvHkkqKns6C6lGXWVNxO/wmeIlikEsnKRTvfvUQJdTcByAfFNSFcsmK0/Rn/pejhDsKh25RoT+5zJ/6oxoPQJIWPtIYNX+iXHvNo+HWuhjlVQ83y+MSJkKhUKR+5Ao5O26NFQRXKBnVwQxoR7caELAB9FXeOvXX0xsA4USz0QrcQRzF2BdR0Yb04BYndMctULqhsmmmINSW560d+mSN0Kk7aQJeZV3sRuqsRhSaPZJXzk36xxEuVy1dpQTUEKUn70U6o8oGov8Nlkvolfa486wzmijPWAAOdhETNCmrazUvgLoQKaVbzgf23cjzOxCeYL0zsn+X9CO9DXLHHZqSF8ebzEcoLSfRetWaQ6j3pfAMSGENDir0O7ATGF7ZX82wfjNWhs+VNhXyPs8G
 +kT+AiAR
 FHR3zDBdo9QWkBau7tBonCfoAIJ0PT5GifIpn6nff7pTn9Ea96XhofcFCy/FwQFC63hTCcj2hpolhhYx41aoNUflBaqTW9w7lSoA4DOrf+2LcxnwOcy9rhyB8LKgLzpGc9UxKe8mT3+HguTrpHOLP5gFMiOKbynPKjykmeAGIUDFBHySVv+gTso74sXGPI3kX2Phz3MgLv1oGkMZ0y6hcs544T11+nUBgfy7VFdZCVTobivM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 03:01:44PM -0700, Kuniyuki Iwashima wrote:
> On Wed, Aug 6, 2025 at 2:54 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >
> > On Wed, Aug 06, 2025 at 12:20:25PM -0700, Kuniyuki Iwashima wrote:
> > > > > -                     WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
> > > > > +                     socket_pressure = jiffies + HZ;
> > > > > +
> > > > > +                     jiffies_diff = min(socket_pressure - READ_ONCE(memcg->socket_pressure), HZ);
> > > > > +                     memcg->socket_pressure_duration += jiffies_to_usecs(jiffies_diff);
> > > >
> > > > KCSAN will complain about this. I think we can use atomic_long_add() and
> > > > don't need the one with strict ordering.
> > >
> > > Assuming from atomic_ that vmpressure() could be called concurrently
> > > for the same memcg, should we protect socket_pressure and duration
> > > within the same lock instead of mixing WRITE/READ_ONCE() and
> > > atomic?  Otherwise jiffies_diff could be incorrect (the error is smaller
> > > than HZ though).
> > >
> >
> > Yeah good point. Also this field needs to be hierarchical. So, with lock
> > something like following is needed:
> >
> >         if (!spin_trylock(memcg->net_pressure_lock))
> >                 return;
> >
> >         socket_pressure = jiffies + HZ;
> >         diff = min(socket_pressure - READ_ONCE(memcg->socket_pressure), HZ);
> 
> READ_ONCE() should be unnecessary here.
> 
> >
> >         if (diff) {
> >                 WRITE_ONCE(memcg->socket_pressure, socket_pressure);
> >                 // mod_memcg_state(memcg, MEMCG_NET_PRESSURE, diff);
> >                 // OR
> >                 // while (memcg) {
> >                 //      memcg->sk_pressure_duration += diff;
> >                 //      memcg = parent_mem_cgroup(memcg);
> 
> The parents' sk_pressure_duration is not protected by the lock
> taken by trylock.  Maybe we need another global mutex if we want
> the hierarchy ?

We don't really need lock protection for sk_pressure_duration. The lock
is only giving us consistent value of diff. Once we have computed the
diff, we can add it to sk_pressure_duration of a memcg and all of its
ancestor without lock.


