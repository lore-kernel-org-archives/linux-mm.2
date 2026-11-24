Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B2AC606A334
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 18:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=I/HJu2pX
Received: by kanga.kvack.org (Postfix)
	id BE8BF6B081D; Tue, 24 Nov 2026 13:09:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B98DE6B081F; Tue, 24 Nov 2026 13:09:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87466B0820; Tue, 24 Nov 2026 13:09:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8745C6B081D
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:09:20 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 212ECA0B08
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:09:20 +0000 (UTC)
X-FDA: 85470799680.03.CA8F444
Received: from mta0.migadu.com (out-228.mta0.migadu.com [91.218.175.228])
	by imf03.hostedemail.com (Postfix) with ESMTP id 813BF20004
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 18:09:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="I/HJu2pX";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.228 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795543758;
	b=0MDSEl+3a/YFaMpZXgdGrqmhw1so14QebDJGgzgpg8bsCnQHYrZNVLqMISxYFabidM7AFf
	xiyA7LnlLqxvWcaJX67dcpylBZFmLuJGK4gA93zCvqDQQjdII+FIFLVUW8QNt5ozBgrluC
	d7zpI/43K0E6+vtfLccbjaAI7JnvCQ4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795543758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rmGe/t/C0SL9g8ULw+bwhnr2ClafaU36qS6ic4NOFiA=;
	b=eZ52ivPLO3yTWPKmzmltx8O5yGgpdWqg4sKZZSQoY4Uofjq8g3MWhfPbpxcMgucwEKakQ1
	XTI0FWB7gLXHukUwHmWs/gf+TEFrm1QkfHDY3rAHRlMLYf1ZkhamYU4xSREbbA45DESbuC
	iYa2+4kQMyaB63Q9iW5tRSvjeTmKxYY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="I/HJu2pX";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.228 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4gdXdhSPnpdDcm1qThNOazm32H/ntbl45f/Fx2FZymA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795543754; v=1; x=1796148554;
 b=I/HJu2pXaxA/6D92tMNPKFdLiJ5r+MKziuqlC/PgID1/SHOBpu2BDjWISwD1IunHoLyYQrAX
 VEBr6VKwlWhBr/lrh5uACCpBBafsN7uqkmb2Zj88Xo6dmhmTCbhSpQG0ju6jk0JKrOsudu7xxfJ
 XCgbcvJwF/9NkoEodPo2lAT8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5399617d78ec6d7d;
	Tue, 24 Nov 2026 18:09:14 +0000
X-Mizu-Trace-ID: 5399617d78ec6d7d
X-Migadu-Flow: FLOW_OUT
Date: Tue, 24 Nov 2026 10:09:12 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: warn when memory cgroup IDs run out
Message-ID: <awXPkCxVlQMAIUWx@linux.dev>
References: <20261124020800.2313930-1-shakeel.butt@linux.dev>
 <awVQShRRwF1IfEws@tiehlicka>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awVQShRRwF1IfEws@tiehlicka>
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 813BF20004
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 6uk5rd8x73r5fu36dww4dsw6yhbr7a4c
X-HE-Tag: 1795543756-777638
X-HE-Meta: U2FsdGVkX1+IsKUgyQowjwy1ic4UfK7QNI3T19BqU0tn0dhU0BBvGJ3I355lFukTVjbuGv9bpNz8+mnOIUrJ5dTuHpnR5GSFzRYnMoRdbxh++EmBIirtO5XDgTJJXDcwtZ/usT6cwJT5UvN3LNXIQfE1P/72y9ek6Tgvbz9EKQ0ltCzUXpiJMyp0akRp/HIB1jwsVLBxiRKby1LbiRpIefLe6Q8bX2TOtaodFVj2Eo/PKVefPoDHz3mfZOKvNFypp0hJ5gC3VNEqGyUyU+RgnON7NZq2A8jIMJEqzavPB3ocigIrjNLCe8NqLA8YB/360lLPN292q6d0hczeqXhsvCkMjjTPFKZJL9aaLR0W1g1soIW0PZChTTgSQMGItYNhMOfXpBm6FU+vqLNiv8cyHox06fxboMZ6PJBXvhtI/KBOxDWKiGg9zWYazQyqh2tO0MJAnAY2oH44lSA/u6TQoiMvApnB5EAVQJMCd9oL1sL1zBsWqAuj6GbjpJmA3W0OafDi1SFP8MSDqB0ZfdqdN4/Q41IA7u76W8D2pi6u8DvH0KrCfw4lhTSZHGeBLjd3vpFcO0yIjugytv7tz9dSuwelXajkUiXLIIbHUv9fJAOX4lztyTLmnTL7E14Xz07w3zuIjpN/pf1hC+73ulYxBEePoEZBf2dftyI7edlypMPlMvLXFpLVVyT0ofy52VksPlAAw/VefVsn8VHcoxQZTAMPC3pYWKgZPGA16NGqhkljkU1+vUki85KLpBcvnbnBfqS9glO7PucaNRBbzaGKSPLz1mywzJgpLVcNW1eS5zdbgqT2T5SGWrW0ubG16xGUK2a4scTc+wEFHSN9Cx3rwD9n7SBzOi7qhiASknNHm2FNgfFdknX4Ydyye4Q3iNHQjcoyBwh9IpQ5mIoMVkUr/F8PpBbheut0NwdMwz7czmKlNflILBqCmTCc8SIGaM8RZrHXkl3GLV0uMGLkW1F
 zZ1iEtrm
 qT8JdLTOJhBA+78RNINtQ0zU8BsX3vFLaYI1ugJ1ee6dclxLjM6ve0RD9s/+/ylzjZML23QJNkcl8HvrwUZnGvZKMLBslKePqEyKw/yduNigGJKF5ywSyMMff1Z4dR0hK5ZJfONgzflzDNluvoQ40Zl+0kxzniqXHXmRaOmDVVcJIdX/HscGfcGj2pg+T9gQQ+ZN+3vliFSs9J3lLwXTA+HLZezwF9wlPg2e962XMeeM5pJlJ5yMVCgjkl6rmNSgMdhlhHYTrCJ3w+Jkg//igcmQmPfncJWp37sue8vFyxfyLjiFPPQkbNIhJJ8qHn+GwvyCHvSnUrh56Z6jpVMHO8Zzxgj9OcqjvqdIdvIO597LCxMwK5vIUR2giX1xAfmcKp7b0wabYGkLKsapES6VU2Vpj+MUos7JiTZ3fhVeptuqZfhAMUaB0CBYmN8fntrmiE5J+uB0/hqvDyN/fhMDfFxpH5ViwHuz8IClqB8o8L8WFDHg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 09:52:26AM +0100, Michal Hocko wrote:
> On Mon 23-11-26 18:08:00, Shakeel Butt wrote:
> > Every memory cgroup gets a 16-bit private ID, so a host can have at most
> > 65,535 of them at a time, counting dead ones. A dead memcg keeps its ID
> > as long as any swap slot still records it. On Meta hosts that create
> > many short-lived cgroups, dead cgroups held this way filled the whole ID
> > space. After that, every mkdir of a cgroup with the memory controller
> > failed with -EBUSY: systemd could not start units, and container setup
> > failed.
> > 
> > This was hard to see:
> > 
> > - Nothing is logged when the ID allocation fails. The only sign is
> >   -EBUSY from mkdir.
> > - Since commit 8290f45995f5 ("memcg: move memcg private ID refcount to
> >   objcg"), a dead memcg is freed even while swap still holds its ID. So
> >   nr_dying_subsys_memory in cgroup.stat can be 0 while the IDs run out.
> > 
> > Print a rate limited warning when the ID allocation fails because all
> > IDs are in use.
> 
> Not that I am against but isn't the issue clear by observing EBUSY from
> mkdir?

There are multiple software layers (binaries and libraries) between mkdir
operation and the folks debugging the failures. Not all software creating
cgroups log the returned errors. Also I am not sure EBUSY can only be when
we are out of memcg IDs. These errors can be transient as well. Initially I was
thinking of adding a vmstat but decided to go with a warning first.


