Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67BF0F459EF
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 17:00:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 95E636B0005; Fri, 10 Apr 2026 13:00:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90EF86B0092; Fri, 10 Apr 2026 13:00:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D7146B008A; Fri, 10 Apr 2026 13:00:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A4776B0088
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:00:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4BE1BA1D6
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:00:56 +0000 (UTC)
X-FDA: 84643260912.18.82CE86E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id AA64F4001E
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:00:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E8SU44fs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775840455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kuCe1IChcs40hj6ob7wGzY/q7/dhHbWnN7FfloNYs2c=;
	b=5YckxzEsObeP5Bh3QaZpMeVxlvB8KbhUl+KU274YYl2dp+Ntuzr5OwLYn/Tdcrzy6whzA2
	8aoPjY157h94CqIEk1i7029EklmK2jGIWzInXNqY2CciPuk0cL61cqzokkwvOYFbpAkmMK
	IE6nPH+0KDrZ1wtdNf0dDwLPQ1pV+Ow=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775840455; a=rsa-sha256;
	cv=none;
	b=ETKq7UGQ2KZ02rtUWkG3eN85OgLQuBHSdIxPKTypnypu5l/huWG/3zB8BHoq9beNMrvk/J
	KIzBs5cuIUkJpDkQS2kLHrIvB1GoOWWSnffSIDd+9MDzABtH4+n5whVbByPuS2oKs/Tpzb
	RzhZE7eSctVHFOFq/436cBj0sFGk2zY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E8SU44fs;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0375A60141;
	Fri, 10 Apr 2026 17:00:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82E31C19421;
	Fri, 10 Apr 2026 17:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775840452;
	bh=U6eJt+lB9XtV2TYcmB/Cyxool90IKNFvE1dIXTnnx3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E8SU44fsIhMHJ4svmNcyINgZUNbjcsINUv9z9dnk4ZkaKhNRJdGRHBQkn/a3MYRUt
	 kDGV0EDXQvGJVcgKb9yA485U/NqzvhosPQnOQt9pDieVqApBDBG4BVOemP1fD+rhBA
	 TxWpZLp7MjkCkxM4KexT45ETpvBxoUnDJG5H0b2eoN5ApKAn+necVCco5xiiDRMpud
	 N9qlU/RG8JeYOR4C7A/HaQU4Tw1+TG3NYPRMVfLwfLwp8HU51xpbrwnZUotUEL0Yiv
	 zE32hgbty2QHvtY5jU+BJ868LBwRo+ghkaQmgXcfgwu/sf6TNAv0AP1D4Q+ys6jL/8
	 RgOzYEQmOC4Jg==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [PATCH v4 1/2] mm/damon/lru_sort: validate min_region_size to be power of 2
Date: Fri, 10 Apr 2026 10:00:50 -0700
Message-ID: <20260410170051.51008-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410164610.6764-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AA64F4001E
X-Stat-Signature: npmxsmfpc4g6gxwimke6kw78iu799yt6
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775840453-935964
X-HE-Meta: U2FsdGVkX1/pC5vVho2aoQF5SvqqWQIXzDmhBgmn0AB2cVFWYTPPPR+Waw9/C9NPvoU9bWGSTj4bjHR64wCs3l+8t6o/N/pLwu6ZCrP52wLjw0vo99TLi8jhcWSSuF8nmuKPXJfkwavO8xMrXCB1raJ24ndybG8AOTJ7m+lifktX0p4RMDllWXPGV42XcS23JzPGobiArosQocy4rtsXSGrAat1PfcD4iFsnP5jQwBH4y3jDmXUcq0vJxf3kaSsYr8mEfW17Vc1f5N+mIqMVkGhPILlXu2JFWT/8OhXOON0BOp2UFXGKjx3LzmsXUhAdUdO2RZ+3ajqH2pvkxIB4QC5mZLWxW8fsYXN8Mwk/XYob44+BfPf80tH8FZJ6z0JdQR/fSc2T3LaGs7eNg1OGBdE3VOW78Wo3hboxLzN9c+BvBaSSzf9BciTe5CU1gnYAqadf0BI6x7B5HPuzEeJltJLZcAdP0qtuTx8zT77+YWsZeoKvGZmxrhHc2fSXiga5X9LmIJ9053NcKwEhoGdw+WGrQl+m2Lr+EGn7ykNL6jIc5a00y2Y1KwEfSu7LdAyewGG9QxC6GOFU9zo/kLEqMjgU6thpd/cKEVTwP115zwGPOfizaMddH3dx436HfK5OgOIiCwAN9V+1Oodp/siT5VnitlS/gsVln4sCK0yIwSIwobP+Q9WokL0E7lLKgcofKuloZMKRMSRGIxDNMu4FmjJUmJ1Af5yxfKDZqe0Ihn9I7hRfyCAnD4bs65a7CUfgsaiJGFMMxcLFkiyqRB+p9pjwjvvaX+wlI/UUCXoTiwvBOQExDCFylzaQKkqqM+TLgJuV8kZmn2mdaPBnYB2Dr6O/pyTAxZ1cqf3eFm35A/Ed6HpAOOTcKN2X3/0xJwsiR+e/pPBlcdIHly7/9tDLwT+UJ3WkP+mT4sN96BnWS3wgaCtrMivY3bzRn7+8sjuaQ1AGMl66HKPU1HqHGKM
 aaxfTeCn
 FT2J0Eq8UrYspgSssQEaKnm64WoLtVvVPqLoBvb+33hSlUUbm3+O5NcTB926mZk0eUsa9xVT0pH8GW2OfuyvbftmgDDNww2QtgVnpdrQWJO82immoyQ6ZhBHQN38zvuV39169/qvHqBmZYRAs7UNDWhWnyVv3gtIJ1HzJvcSqV8B/05yleXgQPe3oQfQXeKO9YLcpDf8Jqeg2InD1NU7cdACmvmpACCRtk1AYjvy7FH7eHuaX4+bqbv5lR3kdfy4owpraTEYGno61ouBHgBW/4jRPbX3Hu4Y13rNqECOmaKv8Xu4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 11 Apr 2026 00:46:10 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Fri, 10 Apr 2026 06:55:00 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Fri, 10 Apr 2026 17:40:04 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > 
> > > Sashiko found some issues.
> > 
> > Clarifying what is the following action for the sashiko finding would be
> > helpful.  For example, if you say "Sashiko found some issues, so I will post a
> > new versiuon soon", and if I'm busy, I can save my time by saying "Ok, then I
> > will skip or delaying review of this version and wait for your next review".
> 
> Okay, I will keep that in mind next time I foward a Sashiko's Review.
> Thank you for you suggestion.
> 
> > [...]
> > 
> > Agreed.  This was unclear to me in previous disucssions, though.  I still agree
> > it is out of the scope of this patch.  But now I think we need to let users
> > force-restart.  Adding this to my todo list.
> 
> Just to make sure - is this the same issue that my recent RFC patch [1]
> aims to address? I want to make sure we're not duplicating efforts.

Hmm, this makes me confused about how we ended up working on this series, then.

> 
> I'm still actively working on that patch, and I plan to send the next
> version next week. I've been holding off because I didn't want to send
> multiple patches in parallel.

Ok, seems I dropped a ball.  I was working like AI bot that only works with
limited and nearly fresh context for each mail that on my inbox.  I will work
on making another thing for tracking this kind of parallel works with good
context.  But since I already dropped the ball for this, I'd like to make sure
we are on the same page.  So I'd suggest below.

1. Let's hold this patch series.  Andrew, please don't merge this for now until
   this discussion is completed.
2. Please summarize your parallel works in progress with the context about how
   you decided to do that in the way, with summaries of our previous
   discussions.

Could you please do those, Liew?

> 
> [1] https://lore.kernel.org/20260330164347.12772-1-aethernet65535@gmail.com


Thanks,
SJ

[...]

