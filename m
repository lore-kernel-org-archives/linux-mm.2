Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C74B2CCFA0D
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 01:19:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07CF98E0007; Wed,  5 Nov 2025 20:19:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02D998E0002; Wed,  5 Nov 2025 20:19:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85D08E0007; Wed,  5 Nov 2025 20:19:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D26208E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 20:19:14 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7A3EE4B01E
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 01:19:14 +0000 (UTC)
X-FDA: 84078423828.23.E488B62
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id AAC5910000C
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 01:19:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mOnry2p1;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762391952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZnRMpnL4bAiOhL8yWk+I3kysj/17LsVDm4UhPGPGtv4=;
	b=U4sMnXpMvaMxxL+5aCaOFTB34HYDX7mDvKcG/0T7+/ryoDlVfC1miDKk6gtY6FWVEf/VRy
	2xf5HxAPflMPZwmovTxyAPk+rOqp5MAlAj2IIfaG6sUvAO+T2V0Ixhsmc4r9iFVozejzkH
	MO79oPUu8G1CjJIeCrdLtmU0u8F6c3U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mOnry2p1;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762391952; a=rsa-sha256;
	cv=none;
	b=vp0jk5Lhze62aXogr+CkibnEVzsNsQ63BATwSdFLgbn1X68A44NJhOz4fdikCLZ2tUG+v8
	U2yuPz5xkjpul2wSIU+H31bjwY85mOnsBomdVlvHaKJM/e8sFZSn6BbhJMM9kkk0/5BIMf
	w49ayi4CRGxZ23fxCptcayc658JZkbw=
Date: Wed, 5 Nov 2025 17:19:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762391948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZnRMpnL4bAiOhL8yWk+I3kysj/17LsVDm4UhPGPGtv4=;
	b=mOnry2p1ie0P8EBhhaXgljXMfwXpy1/R1n++WgQqr/oRrX8xIdtOgG+Rn2FiLGsyJ8IA8F
	P2ks1VfHs3p02mGfR7JXr0Ao2CqckyibWVEGNErlgbG58dWih3TlDoX+ACjKF8Zpb4WxUV
	Mu8cruvPgnOeIq6EYAphgyAQCjW9kbc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Leon Huang Fu <leon.huangfu@shopee.com>
Cc: linux-mm@kvack.org, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org, 
	joel.granados@kernel.org, jack@suse.cz, laoar.shao@gmail.com, mclapinski@google.com, 
	kyle.meyer@hpe.com, corbet@lwn.net, lance.yang@linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	JP Kobryn <inwardvessel@gmail.com>
Subject: Re: [PATCH mm-new v2] mm/memcontrol: Flush stats when write stat file
Message-ID: <6kh6hle2xp75hrtikasequ7qvfyginz7pyttltx6pkli26iir5@oqjmglatjg22>
References: <20251105074917.94531-1-leon.huangfu@shopee.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251105074917.94531-1-leon.huangfu@shopee.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: AAC5910000C
X-Stat-Signature: zognwekpmogc6oef13sem37q8kih866c
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762391952-846534
X-HE-Meta: U2FsdGVkX1/KIeLaouvIoCIkLGOIdvLo5cIGCILxWixLjx3EA4hH5xgaCLqlIuPfWg1CLycbdruaZaSIK/wbAbfuIHtpOEPifS0DrfH95/2yakPWPZrCypCYXLYo2fGPsDUUKT2QE3YYr1dqEf60ZTRu0nx6aSOiM5YEni+u2oTTBz05rVpoJghFKKlQT/vWhkzxikdQiDCVFXtWMcTBUe5AoGZFVZ96O/tIhiutkAXOCzHoHYBe4c9zAeo9S2VKI5HbTJDmVK0MgX8P1/GLKiKwmgDJl0q6musEm+25tGR6lJeJa6uWZuRvPIAw8I04p7WSnFFCslkLS0tcm1gSczW1ZqO4lP8JB5hWhEOjI6pBVl9pwk4pec4HlnnMFquIW3jeodXDgYn6zrl8DOo0XAhW2FAiYtcBP8nO5JAeOch743qkD/tOZwpFfn7kto+kcD1vJ0U1OUvoX4jncUk3i5HI8WXo/2pOTQfS3URXOoseL55bERnh4ifXT0nJ1LZUKkekhc4QaGptx3Z1tMO0II6wo/iekqVf2yTybL9hh661dYiQTojf3tjowoZb6vQ7/2Hgp1zAouaUOW5GtN3LlKBQK1wHLU1PR+yy6d2y07dbFReywfCFUONRmYMlwYxrUF2dRS+tA9x/IH0svA6ho9HYpkIA3jwv31uFraDMC9W9WHcFHCTKMKEGolp1v0HECd//9Rkyahm/YU0xlW4ffiHhxj8TzfbuGErTW5Qf9YUjbf1m3isKqIKTV9sWylBGWZcDB7P7RYBYyZUnWlUibiNqNw1sjJMsEryzc7HW5bf4vt2OM5sW01cENzp4+DsZoEyFhyO4flKUW8DamRfzfsauPKBYO1UVbq6UXzkYf9HUAWcBvlDI1DzltfUwYuP1zSouAWfQyNYQI7L1IGQ/sj56JzhL6vCpJmnjYeLjQAtPnjFR0TeEiVTreNS+l61puufHeyGsiZfGs9KT+kS
 nRQvp2RT
 JFu1pKkwKEZu1h2cNv6BsbzSRA4McPgBtjn91/dS9ukyzwTm0Zp77dwwdlYhMo0e1lA+QdxW/U4nDFmVv4OK9dgMspacBZwa1FaFYDBuzDa+Wgr9066BBMt3cLsVyKkJRS2H7ZMAc4Azw/oAnyYE3S6oa85iiTdb71kdXAAVYCXcScs2aG1N1IpHKafM+of9EsUt1g7lSr4GLE1u7sYeykeQ8O2uih6dmByLbZMiom5pQDyCoeYZphLbZwClWK0DTDYKlI5UoJsZkSBS+NkEI1PrCJA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

+Yosry, JP

On Wed, Nov 05, 2025 at 03:49:16PM +0800, Leon Huang Fu wrote:
> On high-core count systems, memory cgroup statistics can become stale
> due to per-CPU caching and deferred aggregation. Monitoring tools and
> management applications sometimes need guaranteed up-to-date statistics
> at specific points in time to make accurate decisions.

Can you explain a bit more on your environment where you are seeing
stale stats? More specifically, how often the management applications
are reading the memcg stats and if these applications are reading memcg
stats for each nodes of the cgroup tree.

We force flush all the memcg stats at root level every 2 seconds but it
seems like that is not enough for your case. I am fine with an explicit
way for users to flush the memcg stats. In that way only users who want
to has to pay for the flush cost.


