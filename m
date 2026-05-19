Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEEE8CD343F
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 00:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1AC3B6B0092; Mon, 18 May 2026 20:38:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 183706B0093; Mon, 18 May 2026 20:38:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C19B6B0095; Mon, 18 May 2026 20:38:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E76A36B0092
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:38:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9754916017A
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:38:28 +0000 (UTC)
X-FDA: 84782308296.18.057BFA3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 011572000D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:38:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sqAq29rG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779151107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gF53HM/1MblSPPZyWFvR3qkmGf194P8/47FDzT+qfAc=;
	b=FKfpeY3hroVOuI3wa/SCcCMAYXeEhs5A/R7SmeCySMeJoU1n9g41CIHuYdyyGFCPyaDmSH
	wEb+P5VgC5/887CVXlpGuHekeboqqvi7tpUEjpOOh3jmTX55Xfr9ciCxDMZMuwFlfB5QMU
	h9n1uTYw9NxU2L4jH6eVkVvnsq5867Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779151107; a=rsa-sha256;
	cv=none;
	b=KfnUIBjQAk9FFXwvY/UqPESx/z5LfRQWsSOqV7UVsTzRA7C3ip+DOYm0TYuBi/sU325WvJ
	/3Om8QhZEVJOojvKaSGL63uP4w/hQEVR/MtYHJFihSZwH8xpbpldIWIUIV+H+fViLR0/+l
	eS1zzbQ80rgwFdA3jNCF1D4Ttrw7Wu8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sqAq29rG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 617F0601FC;
	Tue, 19 May 2026 00:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9515CC2BCB7;
	Tue, 19 May 2026 00:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779151106;
	bh=dLXATdWeDSOf90S8HMR8NRXCMaR+PI2JbsB1ZSuiKQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sqAq29rGfrXDj64i1THzbhpWcgmaVJOwLO9wc/4a8BCKsDImTd4wp5jCszDqZ+weH
	 cEIKFmCQjenJQPRhLk3MQ9/QZkk5AE6SaJ8FY4qTgp6pszrgwApBGd4XJ4Ose5YnsP
	 Kmt9I16Bv2sAn+I4esI4WBDSVfUq2FwQGNodak6o1e1BO99E1fwoNr6TLj5eE07UDe
	 iSUjYL1fhoBcFxZnI3VPgUbciizHm4vBLWI4qmn+PW31pukvDt4cTUq2eWH1TwGyrA
	 zSrCwzjgIhyztmmXP2fX/Guv7kTrG9eOYXxVx8F4ByLjUJzRNftBgqOdzjYpNz4vyU
	 be3unufwToIVw==
From: SeongJae Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [RFC PATCH 2/5] mm/damon/core: cap effective quota size to total monitored memory
Date: Mon, 18 May 2026 17:38:16 -0700
Message-ID: <20260519003818.99779-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CALa+Y14PXA_anNdvJCzx4RfKoKj6hNmEG39KUvMALtOBznprkw@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 011572000D
X-Stat-Signature: hset5xwodad5owjahdrs5weopfxg9x1e
X-Rspam-User: 
X-HE-Tag: 1779151106-70469
X-HE-Meta: U2FsdGVkX18wEzfTnRyJ4ukD6G8bFJLjXIhr6411lSoJMw5n+wqKYcyq+P37qrXXPllHw2ruKBT0oROIrmL3bl1eAmTq3uyeRjz8+oXq/SjQsddCaVIoW69HCkuOzm8U3khD846wvBMV80l7mJaNWXxTZGJrt8/9uq5wuayHKsLS+Xupo03kLX6lYIFWepP0gJOxzMcs8QUkNQrVAP8GKuxMT8zGDuNgUbKzPfYoAYiXrVu+aAeY4GM6bWZSBRbTOQkSjsokIOXv6viD5OQthoMPjKTsOEuiB314Mu7nb3pFZjjQQO6D0YKRCoB6V/VsOrHprtmdJilg+EtPSTwmw4IN71ohMeFr8QqCoambo2AnkOqBWr0v1/YHMAXFCdWFxJF7Kvp4rfPizEHm7AHFYC13NT4ogjBQ7IcBJa1IGwW9PBWOC9O2zDMpeVnA0aKEVuPl87/cIYEVuIjWdQo9uqv04e3ISluIVpi2RJ6Kra+hEchJGK45JbjsjUGYfNSI9NlbyotCePnY1ClTFxCHfd6bLfgYR5+aJvaiTrWAM2ejmrqmTwvLNinRh0MjB3j3avUu6NsF6NJTAwIOw1dL++FzDBSCqPrl56PLFxq7MLjVRpyZZ1/Vaz+PeveWAHnmgT3J2eJb/lzpccpVfEMwLTvhIUxU0Q4vqrDtflCqa2DbfLT4hxfhuGhF4DnmdK+lGXr9U5scG0ARKnZwPhRiF4ViVOcAETpzWEujMDa0iMU4y1/CwKK5bf6WEqc6PoUTg8aMwqFK4nvu1kNJuSBwi/6LvvsV4xgMoK6w3J9ckHKvZJR5e0Vclw18NlcphP7FoCS3+FE3NVkiUaEAUic+YmwWiI2gyTP7b9yx6ssN8mhJx+vl0JFG6uSr+0SHESR7Nloeh3xEeEmc6D5q0TheiKbMG9OgGO04/ovb+P0kn3Bcq3EnJba8H0ECpkP+KW7ezJIGFARXATNhKOMNzAh
 wb0Q0zm+
 a8kueQZLlGfLpCV7n875C/AMVtmCFACObch2QfVL7iQbKQtxuPGGPfXSiordcYsQtaA4JS1rEXKVcam7M6Dxby7B1CyhxrFnReeIUkPUKyeNuzrFiF+nayhoN20QCbxpqjTiUKhMvYfRZ+PzOSIAy8JAOQlLU8AW3cd9eee2Ft8XNQ/uwFErFveR5rJ2p1SAx1jOB1jIBVVFm1PI67LkafdvseitX113Kky7oNxt7G8hfsL+mG17v6vz7wdAna2SiTBu7T3FIMWepfRPFg1l7BwHfNyyr5bRO4YXLMYl4zmLSk96vBa4Cwi2wlPnxL+3LYj8KygC+LX0qnCKXShfb9pFKCBNIxWDgZ9omKVDX2C6ZpNc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 17 May 2026 22:22:34 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> On Sun, May 17, 2026 at 11:37 AM SeongJae Park <sj@kernel.org> wrote:
> >
> > Hello Ravi,
> >
> > On Sat, 16 May 2026 14:03:54 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:
> >
> > > The DAMOS quota goal tuner can compute an effective size (esz) larger
> > > than the total monitored memory because it integrates over cumulative
> > > deltas without bounding by the actual workload size.  Once esz exceeds
> > > total monitored memory, the per-tick "remaining quota" arithmetic
> > > stops being meaningful: any scheme can apply to the entire monitored
> > > space and "remaining" stays positive indefinitely.
> >
> > Nice finding!
> >
> > >
> > > Cap esz to the total size of all currently monitored regions as a
> > > final bound after all other quota calculations.  Add
> > > damon_ctx_total_monitored_sz() helper that sums region sizes across
> > > all targets.
> >
> > You could also make an arbitrary cap by setting the static size quota.  That
> > is, if there are not only quota goal but also the size quota and/or time quota,
> > and the different types of quotas disagree about the real quota, DAMOS uses
> > smallest quota.  You could read damos_set_effective_quota() code and kernel-doc
> > comment of 'struct damos_quota' for more details.
> >
> > So you could apply the total monitoring region size cap by setting the size
> > quota of the total monitoring region size.  Could that work for you?
> >
> > Adding the total monitoring region size cap makes sense to me, and I think that
> > will make user experience better.  But, if the size quota based cap works, that
> > could also be handled on user space in an easier and even a betetr way.  If so,
> > I'd prefer the direction, to reduce kernel code complexity.  What do you think?
> 
> Hello SJ,
> 
> Agreed.  quota->sz combined with the smallest-quota-wins rule in
> damos_set_effective_quota does express this cap from userspace
> without kernel changes, and keeping the kernel side clean is the
> right call.
> 
> If the UX argument carries weight later, I'm happy to respin v2
> with sashiko fixes addressed.

Makes sense.  I find no change on the weight for now.  If someone else
including myself or you in the future claims again, we could revisit.


Thanks,
SJ

[...]

