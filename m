Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D80BCD343F
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 23:07:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 480186B0005; Mon, 18 May 2026 19:07:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 409AF6B0088; Mon, 18 May 2026 19:07:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F8836B008C; Mon, 18 May 2026 19:07:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1A1436B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 19:07:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 88FE61409AA
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:07:54 +0000 (UTC)
X-FDA: 84782080068.28.012BE99
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9840E1C0010
	for <linux-mm@kvack.org>; Mon, 18 May 2026 23:07:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xjxliwVI;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779145673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=43OgO2OF5H7R43ZRhOnt2E+DP2ym+ONP1Bx6PELiuxQ=;
	b=cQn8afZ8tJn2T24D75yoPP90BD1x+r8L0VeRJjGk4HN0orIRtHzRhb4tHTWxcf0S/ERoK+
	3QaZRRL79zaYT5Y4qhM3GtfvK1CpQp01JaTJ6smD01p8r2GXaG+tcwkrxsL+P3T1EmPDN0
	d0PEgkDesUa3PG0oUTb1MXh4Xc41LpE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xjxliwVI;
	spf=pass (imf20.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779145673; a=rsa-sha256;
	cv=none;
	b=FneQXqz1dLrI9Nh4S+TiLGywPmRwkttDBv/mDmkzNwi8zaPcu44n/TEuSS/hoAmQlE7FK+
	tIkmTevcwkxJlUMcTB26SPUWkb8k/qGO/3bfv5bv2b20LxEEPUmM3Yqtc6E8zy49XOfIs+
	uQ85R2dDG5qnJ/POAYPZ/E0aYpGKwj0=
Date: Mon, 18 May 2026 16:07:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779145670;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=43OgO2OF5H7R43ZRhOnt2E+DP2ym+ONP1Bx6PELiuxQ=;
	b=xjxliwVIsTVqpRoDu9W+fAcJvEIbnG0t9OxUSP3cg6HlVZskMXA6QNBB3X+o63maJnj+9H
	vQQpAkHZJLWuVQeW3/Q+dnNPwK0iZCHLtZh5RB6IjW9L7VqDpSoR1Z3e5L3ctzgQX44gzj
	TpYT2Lwyz6vbUVd12Ys23u5fpg93vfw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Qing Ming <a0yami@mailbox.org>, Josef Bacik <josef@toxicpanda.com>, 
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Hao Luo <haoluo@google.com>, 
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2] cgroup/rstat: validate cpu before css_rstat_cpu()
 access
Message-ID: <agubZePrBmStHxhH@linux.dev>
References: <20260515122952.59209-1-a0yami@mailbox.org>
 <20260516070849.106141-1-a0yami@mailbox.org>
 <64f59b64664f769661a8b8cd587c85f8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64f59b64664f769661a8b8cd587c85f8@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9840E1C0010
X-Stat-Signature: r1x78pnx95hjieueyjhxqqwxr61qj6uh
X-HE-Tag: 1779145672-612948
X-HE-Meta: U2FsdGVkX1+BZ4cwaXN2RhpxTtFZ6ldZ5HU00vuNMg38jiH8qVZ4b2pWoVPQPagvU7lJxaN17buL5VSvkU0f147kYK3PCP0o4BiTMHpaYCbhfHPuPtPOEqIyvJocCbSFpfHTfMatrH7EnhTlHc7LoioZ7GPmyucVRmkATghswwrQjvvYWHzTjy+VnMDsR7CCFrHUumh7s6Yp5yauAWOaFvWmdAwZf7MnSHHZEePbFTJ0rR8N1am87dVu4LSWDshgevQNp7KtzJyzUBo03Hj9NxaE8K75FHU8TzMTW0BnOD2msvqTQRjpGZxYIVEJgnoHFw5d0EePWwXW4MGJ2vRfdToR8EPVdAv0aA/kPahWjK02WT3KPkzrB2bL1kbqbY8bvFCrIQI+s/gEpxYdLFWxX2rKr1O/s/wPGzFFYU0jRh2TIvonMy9ZeQxQRGdj9LX8iHTBj/uxYrrUhf2QLV5TnPbTtaAEIw1gtUxAzxE22xqSRR89kLOzQNhFgFuziLshVDEQdO934E8WfpB/b9I0u794HfrA2Nk0WyuVgDRQ6Z5BfxneUtIQvHarNlAoTFAoJtDc4s0YJ1IsbOx/yFroyV45xYbnmI1h+4r6wRaZ2FYHGxxQjL4SCp59fVfHxmWnfbkDtFHczYA9XrY239ofrJ8BCSFqW8oKsEak43PxxHnsMpjnVjyGBrPiBskgC0PWFTptTFu0YzTXdF9LLVoIxp1kY2APi1d9YVw/MndGu6KFQVvLAbW20eVPUVZBPgYUQ5nejCTDTTYoFGB/+Nw8fLvxfMJ31QmyiscLrFXqI5p89HYdEnhVmAo5A71FKPnBCGRAAmAkjKBCBWedCWkOySjD3MnTiIzzQLVmqDnPiYzAp3FSEI7oDJFVMDITAtG4B6F6Bf/igwnp0HAuXEd1ZcaV6uVeEUeCG7KqEWn+NzZzt9XyZr7qhbakvsIMwlsXZ7geEkcN0LpiyN/jATZ
 iI623cTD
 NN07yy0F5hWm8tyNYbhS9S071O7qxmbODDrF4eXzRZLhI8ytY5LPXSgbJsPCyjaadkq4d0KSYLiusTvT2YqcNL+YVF2UtciOqVaJItzfsNp2sJgJB4GroVrkLoeQZfFcyUt9DSyZLiGFPl8PCiYfzqc4+AXJEiF38U7vK5jBP02fdfK6fU4J+wqrrE/qotBRIN8GrQDWAWQQ3XtETI6JvaQRL9vZ0BeHWraNVSeYYrH38qSn0oqpjak1KHvIphAmN3Nw5/EpJWVY+LAlGC0RBxXK09nWzL6EX38ES
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 18, 2026 at 09:36:36AM -1000, Tejun Heo wrote:
> Hello,
> 
> > Qing Ming (1):
> >   cgroup/rstat: validate cpu before css_rstat_cpu() access
> 
> Applied to cgroup/for-7.1-fixes.
> 
> In hindsight, we should have added a separate kfunc wrapper from the
> start instead of tagging css_rstat_updated() with __bpf_kfunc directly,
> which would have avoided the rename. Oh well, it is what it is.

Is it frown upon to change the kfunc signature or remove __bpf_kfunc from a
function? I am assuming we can but better not to, correct?

