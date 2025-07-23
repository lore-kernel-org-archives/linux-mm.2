Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E276C83F17
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 17:54:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A45C26B0127; Wed, 23 Jul 2025 13:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1DC56B0128; Wed, 23 Jul 2025 13:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95AA86B012C; Wed, 23 Jul 2025 13:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 852CA6B0127
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 13:54:26 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4F4BF1601AF
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:54:26 +0000 (UTC)
X-FDA: 83696278932.01.C8D67EE
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id 71FF418000E
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 17:54:24 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UO7tdZ57;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753293264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4Gwff2VE8d4007wYdTiGPmJ4gJfFC6HAzVdL8zXdtRw=;
	b=rQWI86F1m3OGAf7ieRuqM4NawEpDH7aE8fJhzkXmtVSeuV93rRsotgrWsd/ReZbGCE+kpO
	Vv2FsGK7kCce6hcv5uRX6Ot2f0fgwoXRys5kkavHlHXsWRSL7614KMWr4EGVD5eHMF90Ox
	j0De4PJKonVkniuG/o/FawtLkcLWnNM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753293264; a=rsa-sha256;
	cv=none;
	b=p5ptwg0tzufqc4DXy1ZnbFklg4GkGwPWmUul20JAwbupOP0O1BTrGHAhxKU6tY2NTGhMWE
	HRm2HPUTFH0VI58mRnnutMgNmlNGhm2kSUab2TAGL/jPqpIqfiE4kqE+XPm95iREK4iXB3
	4bx3SpMFfkzt3pd3jjBA0D7iPeUOwyM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UO7tdZ57;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Wed, 23 Jul 2025 10:54:11 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753293262;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4Gwff2VE8d4007wYdTiGPmJ4gJfFC6HAzVdL8zXdtRw=;
	b=UO7tdZ57wlRfHAi9qqc4+fBjZIliVIfL8CcZnGE7Dt4F/OxBOsALVh2F/P3WDk69tO2UKS
	8+Sc7TpBfq+LtvQPupBRgAwJ/feO/lVwEvRhBhkS7ES0uhxldk5zZvH5sUCQBMLqoMrmQ7
	n4l+H/rXj7gJ/r4fe31yB6uWoKsF45Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Daniel Sedlak <daniel.sedlak@cdn77.com>
Cc: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v3] memcg: expose socket memory pressure in a cgroup
Message-ID: <irvyenjca4czrxfew4c7nc23luo5ybgdw3lquq7aoadmhmfu6h@h4mx532ls26h>
References: <20250722071146.48616-1-daniel.sedlak@cdn77.com>
 <ni4axiks6hvap3ixl6i23q7grjbki3akeea2xxzhdlkmrj5hpb@qt3vtmiayvpz>
 <telhuoj5bj5eskhicysxkblc4vr6qlcq3vx7pgi6p34g4zfwxw@6vm2r2hg3my4>
 <CAAVpQUBwS3DFs9BENNNgkKFcMtc7tjZBA0PZ-EZ0WY+dCw8hrA@mail.gmail.com>
 <4g63mbix4aut7ye7b7s4m5q7aewfxq542i2vygniow7l5a3zmd@bvis5wmifscy>
 <CAAVpQUCOwFksmo72p_nkr1uJMLRcRo1VAneADon9OxDLoRH0KA@mail.gmail.com>
 <jj5w7cpjjyzxasuweiz64jqqxcz23tm75ca22h3wvfj3u4aums@gnjarnf5gpgq>
 <yruvlyxyy6gsrf2hhtyja5hqnxi2fmdqr63twzxpjrxgffov32@l7gqvdxijs5c>
 <878ca484-a045-4abb-a5bd-7d5ae82607de@cdn77.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <878ca484-a045-4abb-a5bd-7d5ae82607de@cdn77.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 71FF418000E
X-Stat-Signature: 6pipwozxgwk9acozewps6sw7mfkusw7d
X-Rspam-User: 
X-HE-Tag: 1753293264-465291
X-HE-Meta: U2FsdGVkX19E5+VBSm7lDQfg2ir3vbmWtDoO5fCYB9j7vz6o10Ry3X1odH7DE5uwWX4+dOrvSGeGRB0ND7jsE42sbLs0C4y9UR+wr5ktVfHxuxxy2Kk+SZRaLyEPd5zZ+Rl6nMFdwn7uyKlkkpEXnTddfB0pW2eUvOIbLwtHddmRd1BlvuEG990wC/8HDKleQ/jzfc7oTbJwHYMzUiuwmanpH8STJzGJfwvZgNT1ECnyqVwra0l90h+PkWPpBCEGI2vgzcrzC/9E3JWScwzyvgWggbR4dANtwG9V2hbcJHMk0my9PXHxm/fx/cBE4H/6w02yuSBC2znMJ2wYCsex2wfTQLkeKf2V80CB5EBrVRybGCRkGlTQa/fqSKS7oFg6bq86jbRlipX7Esp6rb2dx2cEBYjssADOJ4v9zGH1XtxCfMjM8XPbsbzqJzTsQhKUSZnlrd7q56AHfD0Qvoi4UVap/NKZaPTARhFC4i+M2ooDIXvr+q3Yz3NmVb6P9UM+x0MTzZICA5tjyeRs+mTH5jV04FfGuVUQia0L1ohs9boAzg9KYheJX+RbgWmNSKFp6hTRRyJid3Q/ByuZnIs+AIwQuY6IHW1BtpmT8gFOH1WEzRhRt5o71xRrfg57zKUmnMcJk3XHGUUIj49iS7TSS6nELrL0rZWcexVBQs7QpyHx1L171E34HPihhMj8m1Zcs6nODDl+Tt3P3xfA8RBfZdGFDMyjILwGdqaiP5zEIMOI1yMr1Sr+lhQlPLTy7vGLIXtLNIy1n/rEqa7T+nckYrDDLVan0pTKYtZKrvQ5sweRpFA4jItOFznKdNlQ6rXitzo6zPLaAZ9CGUB0SNcWM5ykbcTo0POU0ei5xqSWnO5h6l+FXhyraum+JBmGvIkU5FV4+5Wfdw+r3PUMCxQ52plvHBzLoPbJdfe8Cy449fa9jYv7Mt98dbMpvnWvfHloKQZoj76JySSQLME5lVc
 /LVnqYi9
 AhEJeB6ji5N34Pd7mkDPUwpQwYVr7P3PGkaSiMfbec3liCc3Sy7m/pnRkKz31EdMPZ/s8J5mBdyJoDpcUDLHbOkG2UumqhH/I6p6yWLXjhSBePZU65EjAQgXRYlju95CLKDCVs5i73Ip9gUhZa1MSYSVb8ADBx9m66tUS9rl9csyHuJq8hlcnqEtxxjwVM4oJ1XwIz9tqmq29SHoI/UsFyl9QHFGZZDLMD6ZlGOD+1jPhKCXyeDeG4vy8iQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 10:58:10AM +0200, Daniel Sedlak wrote:
> On 7/23/25 10:38 AM, Michal Koutný wrote:
> > On Tue, Jul 22, 2025 at 01:11:05PM -0700, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > > > > 1 second is the current implementation and it can be more if the memcg
> > > > > remains in memory pressure. Regarding usefullness I think the periodic
> > > > > stat collectors (like cadvisor or Google's internal borglet+rumbo) would
> > > > > be interested in scraping this interface.
> > > > 
> > > > I think the cumulative counter suggested above is better at least.
> > > 
> > > It is tied to the underlying implementation. If we decide to use, for
> > > example, PSI in future, what should this interface show?
> > 
> > Actually, if it was exposed as cummulative time under pressure (not
> > cummulative events), that's quite similar to PSI.
> 
> I think overall the cumulative counter is better than just signaling 1 or 0,
> but it lacks the time information (if not scraped periodically). In
> addition, it may oscillate between under_pressure=true/false rather quickly
> so the cumulative counter would catch this.

Yes cumulative counter would not miss small bursts.

> 
> To me, introducing the new PSI for sockets (like for CPU, IO, memory), would
> be slightly better than cumulative counter because PSI can have the timing
> information without frequent periodic scrapes. So it may help with live
> debugs.

How would this PSI for sockets work? What would be the entry and exit
points?

> 
> However, if we were to just add a new counter to the memory.stat in each
> cgroup, then it would be easier to do so?

