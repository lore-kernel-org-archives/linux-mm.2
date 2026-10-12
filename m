Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88BBECA9ED0
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 17:13:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 756E36B0096; Mon, 12 Oct 2026 13:13:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707976B0098; Mon, 12 Oct 2026 13:13:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61E4D6B0099; Mon, 12 Oct 2026 13:13:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 40A5D6B0096
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 13:13:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B5BC31210FF
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:13:15 +0000 (UTC)
X-FDA: 85314619950.22.B5A0660
Received: from mta1.migadu.com (out-140.mta1.migadu.com [95.215.58.140])
	by imf04.hostedemail.com (Postfix) with ESMTP id AA2DB4000A
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 17:13:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qFNE5HMt;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.140 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791825194;
	b=2bnKaOywCBJUUux4pfvX4wWmKnjqsNk5tpyV6Xz2CqqK4/v18116u/1vwyhvuJ1fcumG7e
	AqdgkakGNFdd6rTz8Jb0P2BnJcRVuBM8QDyR2edRDeZF+PaiBQF9ChhY2Zcdvze2ihzAEL
	ADSHTSgywJw77KBPBs+oHi57+L0NgN8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qFNE5HMt;
	spf=pass (imf04.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.140 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791825194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ewAUwQh9V9wBYnmHFNwDRtCG2iHLmxe7PSTHA3L7mEA=;
	b=YU77PTYK8srYfcanB8CuZzlNWP/dnGQNTPJA6kWf1DaeFYJM/aOqZq90uDBKvYHMvPWqoC
	7z+WouIjUrzykEBdU/ZEwT7iSFaLL/8uWrTToM2GBvLTkf//bGlLvDvCA4xB3+LNDcsnN1
	2GanX/DnO/V0zoqL/EqXD5TNYxXgnds=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ic4+7nPuzg/HmHoJ2BxucAspSzm/umEUsEWucPmNFHQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791825189; v=1; x=1792429989;
 b=qFNE5HMtbFxz883WiyZ3x0GRHUPE206w1D/n00pVadaEgk/rJaUJLcJFHroAV+dHoiDQepfQ
 lts+BQC58EQ4d0FmE48+1nqWB62J+oLr0ljqOnKI4sIyPiPm+IZRxiRr8e6OYSBj60DBZbHnDX4
 dMa7HdQCfAcy4o3Lau0dj3jQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5adfa5a0e15eca74;
	Mon, 12 Oct 2026 17:13:08 +0000
X-Mizu-Trace-ID: 5adfa5a0e15eca74
X-Migadu-Flow: FLOW_OUT
Date: Mon, 12 Oct 2026 10:13:06 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH for-7.5 1/5] memcg: move memory.high enforcement out of
 try_charge_memcg()
Message-ID: <as0U-erMrDTG9fkt@linux.dev>
References: <20261010210957.1350874-1-shakeel.butt@linux.dev>
 <20261010210957.1350874-2-shakeel.butt@linux.dev>
 <aszdXDpqLUX1S4Qq@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aszdXDpqLUX1S4Qq@thinkstation>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AA2DB4000A
X-Rspam-User: 
X-Stat-Signature: pot7fnrqxwjdin15dhokdq94mmowo55s
X-HE-Tag: 1791825193-107156
X-HE-Meta: U2FsdGVkX18joq0u/5tFP1sWsJ649RXJVDLkYfWk6aYWt5iFoUb7xfVcJ+PS7GlC6sxezVXvuXEyq/dQn0oZe1pY1SRQNjiTVUk1WuUwl66NQsXiOCiQCLj3nVcf61TPaW/vd5Fq194IKg7/+jJOKW2hsTPBLNFJUjnv0k5/dh6Ad5jd3ljYT7c2jD5iN1WKOfjgfpvWATLhMUbJ5i9N2zMtPY5YmWKmSg/L9pw7nhkmLuJf/qmc6EVcW0TIhI3N/rddYqVP8i/aL/hx4OZ/7dgkm9gkReacg3jR2WyMts7e5xD9DtFEAL59o64+kA50d96MmuK3egM9p10KMWLDyEGM9Ize437WqLIqSA7OR7bEuOxd5jn2vi2jo35s9TUTCW1dfjEpAt5WSz7rD1tejlluJlx0I9PGFIg3JhE60SAPsmt9LoREdzY1OMBoHnDC/ZORX7BlNSSNP6BeRume+S/n0mFJTOigRGKyBu9NMd0ZBrYuosWIc/8XWc5t7gJGMwOH218Y+Szp6WrPNTx3QaLF+JgqSZjlczYRS2qGq79w7Eh3f90cDwUWA5DcuXfkM3f0E3TcQovFlg+Xq6VGt5pVp++K8mGlZ8AsYdJX3/uIf7VqKpvL5hhUCz7JEWkJ4qvutEqhXjQY3vsZwtaVB2O/Er4G/WPpHh0jJ5ML2jNAmB2Ns1Jl/zIMUn0I8XP1aTH1yUafy0Pj7J5WpJqYdZInr36AkWPl6zRFrRmmjcmmLTby7ayQJSrTFZ2h6RSclZHZvyWztW/KqJB+xGFNStN1ik9n5n5u9/mUaBpmUCRHm4BhPtkX94x5p6IbABsJdU6tEuZgezbTFSOvczAVAw5V4jyjaOkMcBlUxrBg/wNUZWGDqYLxMAVEUjMRRskiLqPSDzsGZCSTW1Lkfn6HD82rv+HMf5VyZBTs3HFWzIAP67iBB9QTz3+3zZuQ3v1waDJI5Xj4LeXXAi9p5y/
 ENwFf+EM
 R0h5yCRwxvTFGbtHlZxRrD5AnRPE1C9ywz2bKCYPd9ulMpUGUx0qsHNRRVaYjU5oIUBkDxMIe8WizQV4q9XGGZDgwsJiIMdnizZMR5nKVl/4FUp+1Ducf9Eh86MiG/MWh6OgFQ7l8Ei63UYfYf75h9J/Krog3USp9UhwN1plEKtbNa7eWpf7Lcsddi4VW9iLz4orcNdF1L3dzclcmAG6/oDNpKiX1lQcPoqXS3LiRcNFTr4p0BocZqkfifVemQv2tJuWSY78/6rs0gf1c8/24YPZJrmiFw2uQJPlbWH4ZVB194DjEh86LbeVS3Icrz0txGhYqyHexdjXGcECPOX6dsRQjCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 02:22:40PM +0100, Harry Yoo wrote:
> On Sat, Oct 10, 2026 at 02:09:53PM -0700, Shakeel Butt wrote:
> > try_charge_memcg() does a lot. It charges the page counters, reclaims
> > when a limit is hit, may call the OOM killer, and at the end it checks
> > and enforces memory.high. Move the memory.high part into a new function,
> > memcg_enforce_high(), so that try_charge_memcg() is shorter and the
> > memory.high code is easier to read and change.
> > 
> > The code and its comments move as they are. The only difference is that
> > the new function gets allow_spinning from gfp_mask itself.
> > 
> > No functional change.
> > ---
> 
> Missing Signed-off-by: ?

Oh I don't know how I missed this.

> 
> Otherwise LGTM.
> Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

Thanks for the review.

