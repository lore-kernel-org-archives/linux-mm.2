Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3808DEDEBF5
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 21:12:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B0F26B0088; Tue,  3 Mar 2026 16:12:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95EA66B008A; Tue,  3 Mar 2026 16:12:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88E746B0088; Tue,  3 Mar 2026 16:12:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7A8186B0088
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 16:12:29 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E9895C17A5
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 21:12:28 +0000 (UTC)
X-FDA: 84506000376.22.CA3BC57
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7675BC0013
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 21:12:25 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fMZKh+zX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772572347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J8f/rq0JhKVWLGrnHUIGFAM5wHzDzd/4yc+djUCeWPk=;
	b=tv6EDsmAcMFWgzboGxnIEcPUKDlngP2sA2pOghEQg/3fnO82jo1qSvOVyVAJkMEGBd/usa
	WslFvxHISYznM586uDPh9IB9NBjsqnBFgFJ8RlkMjUlNIczvpwV47/9P5wqTBhMFjKKnPZ
	JaFp4dIHuA4OqU+4UWKW+CfvDbAf+jo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772572347; a=rsa-sha256;
	cv=none;
	b=qj1c7oijeebc8nPtVVzhpxTEOZ5/jOzlu5aJFyklnNxZNBkA8ugwGQ9Gvq5MFaPfcKjvsZ
	LFhD9J24qpGwuJnYyBIUYo5uyZbckYGMlR97x0rRNsvNU1aBX2PHywUoewhBtmXBEVlMLg
	Mn0DpqaZBRmN+8q2SZYHlOqBgDGzw3g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fMZKh+zX;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772572340;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J8f/rq0JhKVWLGrnHUIGFAM5wHzDzd/4yc+djUCeWPk=;
	b=fMZKh+zXIRa4g+vPYHT+JmDcAci63QcbjFjDp/Q90FjR5PZwCYwKI/kRoLm5RySjpdPeiS
	GV8Qd0rm1ZEqEklz/ok5TYdBNwk0TYREAqhEdvg/DFEAN17Jv3JF3O6PTbFkJjyaWH6Lau
	s0OkucNUKrjGor9LcxS2kFFn3OnpMk4=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Hao Li <hao.li@linux.dev>,
  Michal Hocko <mhocko@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,
  Vlastimil Babka <vbabka@suse.cz>,  Harry Yoo <harry.yoo@oracle.com>,
  linux-mm@kvack.org,  cgroups@vger.kernel.org,
  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5]: memcg: obj stock and slab stat caching cleanups
In-Reply-To: <20260302195305.620713-1-hannes@cmpxchg.org> (Johannes Weiner's
	message of "Mon, 2 Mar 2026 14:50:13 -0500")
References: <20260302195305.620713-1-hannes@cmpxchg.org>
Date: Tue, 03 Mar 2026 21:11:49 +0000
Message-ID: <7ia4pl5kpqi2.fsf@castle.c.googlers.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7675BC0013
X-Stat-Signature: kyo1kxct1q61dd4fjx88pjx8fiwj9twq
X-Rspam-User: 
X-HE-Tag: 1772572345-945124
X-HE-Meta: U2FsdGVkX1+U8Z1ltxw/iHh375beFbD0T7Z7BmxRBlCsLtla5jfL/yZ22oUjVCTFHoU1bsQ3TuHNpghCzprpzyn4u5IQ5C0he/nFSee8f3OU4tEeWfzITAXhinuzAECDM43ZBYbuS4eECUUodXT4sKdvlw+MoyuZ7OAROJnNOgqUok9L2vQiWIWolepS+IL4b4/RbxwrYNnE3WL3gN5CzUrtK3qW2pm5hgWP1rkBKAccWYxMVDyDUoce0oSsfkZc6yejkgmZZ2R9/UCRVRcKzBjHx5RqgbBzat0Ac3gFqYaGzpu3ncPuzQpoL9wkog1gEnzoV5GJKDO3QviQyJ0FQncG43OYf3QT72YBzsig+35HhEngiGwpess7rmv1BEzi+IWi4lbLUtRi1/3pXeifpbZ3jp5hnzdsx0m3H2+FoWt/9PLghzoaAgDKTXntvlSJJGAGnzQrXKpxD6KW9xc4EdA0bhCXfttGQv51LdqBfW+P3P1oydaBL+7+Mg6y9YN1yQnXsEI8gFB6ORDU+jZSxbDf3zPtfnpZh0AmmWg7WlvArI5+Y5lx+Fuj4S2qGQaggG7tYgAHabFdlTqxlVyQJuZrXAhdQmM3ctH8wW5SVfOwFcZM9rmwYJ7t/ms+8nrajkCQJgofPioXzrotouZTG1b7vJvjdG0jm7yfpzFsPxR0LfEpQY6KgBLjyy84tOrnG+iQW87w6AqzrTPVrEX8xeQgFJCcXAAOFExgZF/sgH/jrASxERbJTDdQOhacg3UgUQs3QYcdF5Rm4rsSW2W08jGlh9gSyOsUJQdZw9Z6z6NKF0/olvRHZJVLPaSIdRQsIsuuP+NWaydim98vF1/gnjjROTiLVM9q1hzL2eMynDguXi6YgZaeXd1yM1xxyHZ8AxwSATv5a2AX0OCzU89uAwIsr0tKk1LgR5aPYrThdnNw1ILi5+EM33zFhIPzzxVH0im38fYpPeF5om7+6bf
 MEzMr8SA
 u/SLHIiAc27GKEh3CHYMCqIapMeS42fVvzYKcyAw4gBYFC2DG6QeHPSvCzTAJjAYPOJISdMC+CgLrMQKk0sHqVQXfqRgUO2TutcqjBeiAc/NY8FtyA1vGqka3PdPLb2ub6YK1ZbFIJtxcytIrlXuBGEzHH2Lxy2z0DfRRcmopAgRZh2XXvGdGYZlC1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Johannes Weiner <hannes@cmpxchg.org> writes:

> This is a follow-up to `[PATCH] memcg: fix slab accounting in
> refill_obj_stock() trylock path`. The way the slab stat cache and the
> objcg charge cache interact appears a bit too fragile. This series
> factors those paths apart as much as practical.

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
for the series.

My ai review bot is also entirely happy with it.

Thanks!

