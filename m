Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15B58CE9D7D
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 16:50:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CA1D6B0093; Tue,  6 Jan 2026 11:50:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78A756B0095; Tue,  6 Jan 2026 11:50:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 689D26B0096; Tue,  6 Jan 2026 11:50:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5201A6B0093
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:50:22 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EBA1813B275
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:50:21 +0000 (UTC)
X-FDA: 84302127042.11.3A15CAD
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf23.hostedemail.com (Postfix) with ESMTP id 05AE7140008
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:50:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H57AzpyA;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767718220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EV1/7g27OqAnKH1HEhXIWq4jwD3/NhMQm4HUZLHQWo4=;
	b=eiSSerT1SGNk9gSmchibsdi55aMcH4Y2fmEjcS5WJvvA04xYCecWlaWJewsfqmp2OlCpWI
	Uer/0/D5/h/24xPJa6uiy26MIbM5OXEayfp/2KzUoNsq6M1HyO5UzUIYcUV5WKq9diDK2j
	Q+0WeGA7U+hlEQHTv3k7tdAX3FNAOhg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=H57AzpyA;
	spf=pass (imf23.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767718220; a=rsa-sha256;
	cv=none;
	b=qnxuydOH8bcwkXc5Ge4r9ln+RINaq9hDbck640KhzUY5UUF/bzECYCCTTVSy8YYj2P+w9F
	rZGMXvIYhONjils5N2eXr6Ale1oLSqRgZah8P9OWJmQnYrOKzUZqJ45YNU8RPZdDthhJSL
	LDEADTIGduG+ThwZqaJndLTiJGGF2jo=
Date: Tue, 6 Jan 2026 08:50:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767718217;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EV1/7g27OqAnKH1HEhXIWq4jwD3/NhMQm4HUZLHQWo4=;
	b=H57AzpyA7hzF8Iam56J4codlkXJbaNKtoF6FeI5R8kBN3YKGOk9cITwTdfJ089k85tPUyB
	a8Q++YPA41YXzL1B3SpcP8UGq1K1Yfjp00jhOE3v5Vdu7krkiCJsyNpU1P2vaV8+qpg/K1
	T7tdt8nZhTdvp84ljO194cL2SDdTApo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, linux-mm@kvack.org, 
	Jiayuan Chen <jiayuan.chen@shopee.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/vmscan: mitigate spurious kswapd_failures reset
 from direct reclaim
Message-ID: <rlibyovqzrcir3egfa5pzjn3rgk6ctav63okppevjpsp5fu4lx@rerujqrjf2j6>
References: <20251222122022.254268-1-jiayuan.chen@linux.dev>
 <4owaeb7bmkfgfzqd4ztdsi4tefc36cnmpju4yrknsgjm4y32ez@qsgn6lnv3cxb>
 <2e574085ed3d7775c3b83bb80d302ce45415ac42@linux.dev>
 <u2llnnpmpsgarwrt74ffgo3cuwe4apdbeh5hkclzbh5gykwltb@whb7uuj7ub5i>
 <e93c75cb1a46a60ec415215c555312c82b9145ac@linux.dev>
 <gd7qbyakigogdbfxkujtc2ewwfzbwudn2l6vqkbkttv46wkfrd@nqseltiu2do5>
 <d7df4e26841d83154f2cc2487d5acbaf2ff2cc27@linux.dev>
 <aVzaqAZ5Wagh5cDQ@tiehlicka>
 <52cc0b2671b068903c6580b7431db0f22982ae86@linux.dev>
 <aV0HI2-iRXuQ4MGv@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aV0HI2-iRXuQ4MGv@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 05AE7140008
X-Stat-Signature: b39conndhzoqnkwfq67mzfkbiur6ofs3
X-HE-Tag: 1767718219-338183
X-HE-Meta: U2FsdGVkX18TXMJxecpKKtXF7wvtzM7p1tuZWYh77gEHcZpeqaIup7oiHVRDj3zprMSZ07yeh2pnPgdEDjn5cDMqJJPiaex8Z5rzTAkao9wCYRdpwYeV0jtV6yTftNu/iZ5YdN16YlzmfzSxmYAA7/OS5oTzYl47Wg2/37wOg2VyKG1disfQTrYZGS83iMo1tkeqc429IAxeNpWFqpS5OL2ydiYX8fAlC0//c9L1qmSajOgwAiepzrb78XnGy5m4D7QO2iPIuQx4qQc5aOrBKajIkpYtTkifHCyd5nfEVivAJSv5Tp9tdvea/pQZf014Ir9MNln3FiqKe2KG3zNVH25dAWoJoBgYK+me+pkP1S6mu5vZlksBo5ZHyf2LwG5O5OQd82+3UpDMjyTyeF/0crrxewqhZMIF5HGdtyj8Vn13+GEs04np3TRTfKEaMV2A+l8krQoe+FSyuLcY8PQnNJfizdbm2ldnc1xGO+J2Vt2YnI4DnExDkSrq+RCBNtvspk3M6XelwSTgx7bPZtNijYmYNF86mnpEXvMJ2OHY40B3tBaiUxU7YxvzSTbgoVZiGXvZD1Yg4/oQ0Ojhp8tS30nrvYYjBcobGx958AHrc5s/pdVPYuTgbOGr+ESVoiZWt7bVgColrvM8N6J+IQ1Nl6D6ASm8tFLb4KA4Cyhe3f+Fx4eBKkmO/zBoPtIqF92vWuFUW6VpiqJoji5zLpmkV6OwfMWpiP5uWfkNV/rl5wswvJr7bFYkvUeIrt1N+mmZtOJIkxwtoI3TaLMTmYSnrPFgtBXQSx9ScxfI6d3Aam2dcsNg2Sn1Xi54nZ/PpO/vZn62FnnQ+xa0GKToQu+90yF69MuF25kJzlYa8ibjWE576hNioNn5+/2hbgJ4hgMaXmdGETal/rj35ZZYhnH4b4zd3NLCsHBGdjBlIZ9m0xErWoiit2E4oR21Ugdi5qPAT2lb/2Mv3T7uLic0tyI
 fUlENemZ
 CxMG9Cy9t5+yl4Kf0bVgern6qu8L0aF5W/a2RV+5//4eWeMpXyDd8YyEQn7vY8p3xSWO55w0ryZPKdK3TBa4JM9oodSvDfJCgTK70MY7y9WaHcLEhTURZRaKuMiEF6Ud0pQioUE2Y70UvklM3q3zDsaIFGEjO6I1HhIUe7TxvfYZRjYHAmrHiLPEEh1xWVqg3iPl5WmHqiSzNp2j00Tt1PLY4jYB8ilkk4ifmv+AGkF/rfUAZvMOx4o0L0Io6AooZhM1VjSh4wJ1ta3FsZNsO9FrVPwHigyNe5zXiIeZaLmUSJGQL6qMQ7rs9MW+f8ftxT3jzdMMSKn0aB+hJdIOSVwdO5iqsqlwNxXXl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 01:59:15PM +0100, Michal Hocko wrote:
> On Tue 06-01-26 11:19:21, Jiayuan Chen wrote:
> > January 6, 2026 at 17:49, "Michal Hocko" <mhocko@suse.com mailto:mhocko@suse.com?to=%22Michal%20Hocko%22%20%3Cmhocko%40suse.com%3E > wrote:
> > 
> > 
> > > 
> > > On Tue 06-01-26 05:25:42, Jiayuan Chen wrote:
> > > 
> > > > 
> > > > That said, I believe this patch is still a valid fix on its own - resetting kswapd_failures
> > > >  when the node is not actually balanced doesn't seem like correct behavior regardless of the
> > > >  broader context.
> > > > 
> > > Originally I was more inclined to opt out memcg reclaim from reseting
> > > kswapd retry counter but the more I am thiking about that the more your
> > > patch makes sense to me. 
> > > 
> > > The reason being that it handles both memcg and global direct reclaims
> > > in the same way which makes the logic easier to follow. Afterall the
> > > primary purpose is to resurrect kswapd after we can see there is a
> > > better chance to reclaim something for kswapd. Until that moment direct
> > > reclaim is the only reclaim mechanism.
> > > 
> > > Relying on pgdat_balanced might lead to re-enabling kswapd way much
> > > later while memory reclaim would be still mostly direct reclaim bound -
> > > thus increase allocation latencies.
> > > If we wanted to do better we would need to evaluate recent
> > > refaults/thrashing behavior but even then I am not sure we can make a
> > > good cut off.
> > > 
> > > So in the end pgdat_balanced approach seems worth trying and see whether
> > > this could cause any corner cases.
> > 
> > Thanks Michal.
> > 
> > Regarding the allocation latency concern - we are already
> > in the direct reclaim slowpath, so a little extra overhead
> > from the pgdat_balanced check should be negligible.
> 
> Yes, I do not think that pgdat_balanced call itself adds to the latency
> in the reclaim (slow) path. Mine main concern regarding latencies is
> about direct reclaim as a sole source of reclaim itself (as kswapd is
> not active).

Yes we will be punting on direct reclaimers to collectively balance the
node which I think is fine for such cases i.e. high kswapd_failures.
However I still think the high kswapd_failures is most probably caused
by misconfiguration of the system by the users (like overcommitting zones
or nodes with unreclaimable memory or very memory.min). Yes, we can
reduce the suffering of such misconfigurations like this patch but
somehow the user should be notified that the system is misconfigured.
Anyways, I think we can proceed with this path.

Juayuan, have you tested this patch on your production environment? 

