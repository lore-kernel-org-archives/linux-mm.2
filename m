Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3AF17606A326
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 05:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=IS0dH4Fe
Received: by kanga.kvack.org (Postfix)
	id 2DE0E6B05F4; Tue, 24 Nov 2026 00:24:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28F4E6B05F5; Tue, 24 Nov 2026 00:24:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17F066B05F6; Tue, 24 Nov 2026 00:24:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D8A566B05F4
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 00:24:46 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4ECFF140AA9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:24:46 +0000 (UTC)
X-FDA: 85468872972.22.5244C39
Received: from mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3848B180002
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 05:24:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IS0dH4Fe;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795497884;
	b=SZjrpyMQXhD9Sp0Lbi3g4kqPax3oTRvj8h5KGYlEWyWuP1RRsEl4GQS2CY/1BYKeABWbVT
	KjjOQ0mhlZNfV2Qd5yVy761oyn68Om6YDKPCWS5ZAXe+Jt4TkEXsREV44eSPYaQck4hvAA
	gaa2zk7V3hoqE2MxPaeU2yOkdbAmCHQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795497884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EUbnCTk25H/cREetncbitvhF60S/wmbBZLPLU9DM/r4=;
	b=djbFYGohEHY3+l7b7lcV+iuZ/2bRjrSYMsIP8yhCa8JsAusXVJUJAoa6WTDY6G9kUNriBR
	sraXN34suEp6l13sL4ddm+Syw+VlWoh2rgUHhAGl2Ng3aGacEuvwUGLsvjU7JXnEhRkHNf
	IlBtPK3oMt9EiMM7l9wgkVBsY/UY5k8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IS0dH4Fe;
	spf=pass (imf16.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=g2dnbFx4/3WtLU6XELgiDkbskvVUDKsGs2lr4KoV968=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795497882; v=1; x=1796102682;
 b=IS0dH4FedNpDBmQ8dYuxofkWbRzbn7d7qcFSg1O40Vp+YlvwAAA9HJRPxp4PwqC3ksPz/YpR
 S179VFCkr5/OjQNV0mekkonJDVxbpj0Lj6Z4GeRyqiS1MUJK3fpJ1rPL+Wl/9rtYCUbMdac8DZ+
 Ngg8I33O5wJbYRWd+F32dcig=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4bed5c34e88d1cd2;
	Tue, 24 Nov 2026 05:24:42 +0000
X-Mizu-Trace-ID: 4bed5c34e88d1cd2
X-Migadu-Flow: FLOW_OUT
Date: Mon, 23 Nov 2026 21:24:37 -0800
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Muchun Song <muchun.song@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: free the private ID of a memcg that never comes
 online
Message-ID: <20261124052054.GC555944@shakeel.butt@linux.dev>
References: <20261124000439.967403-1-shakeel.butt@linux.dev>
 <F39B4A81-BB17-4C5D-851E-2740EBBBBA8B@linux.dev>
 <awUTKy9tx8nWJgXf@linux.dev>
 <2FE2D209-FB57-4191-A324-F179B2394DB1@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2FE2D209-FB57-4191-A324-F179B2394DB1@linux.dev>
X-Stat-Signature: 4rwse8sceu6eig6x8sbmmunxdhx6ri96
X-Rspam-User:
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MSGID_MULTIPLE_AT,SPF_HELO_PASS,SPF_PASS
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3848B180002
X-HE-Tag: 1795497883-457457
X-HE-Meta: U2FsdGVkX1/2B/95ZYwW0wiWFRgYeiA+wYHpvmxCvByRieyaVZWDT3BHY8AP1SwVP0N2EYv3dyXrVPq2dEk/I8CU1xCLY+gNiSN/BEB6wI3+Ql6lFjB8X7p28OcgsrmRqzWenFLZpgeKBuKvbZshIql6gqCldRI13v0uYIlcY7e4X13CzShcSDlNTayb4ZRqNZlfjQ9RxaiWGYCIGyr1npR1iRxCgxUml9oyT2xgq02wgekdwbZTryBWQLmzgPD9EYXA38vvFO6MKtguZp/hLTGwpA3p6nw8sRmENXiVnr5iCGuQuzbWn/gPBe1gTQpoybHxQ7vp+4jYtEHEFBHJFbEB9uRrP3zaU72JbJxUlYFSKBsffsjxh112NvZoZZvHs1MJjsGiDhXpmgduLX4DnpaNf4zDQadt3w0tmbvwLRB3lVDLjJpigsNBvR47vUtvtgkLwOMPopS63pLyXXSrW433qBIJ6CUWOaHCQehdD/yCz4dhDSjJKVEr5UxlDYUWfFoo2m8QBL9KG2j3r3VkwvU2ZaapM+hJgwdel5SWzwF92RohT1lWhediigC7Xly0hqezpWnU+a7XxQSocyfjliXrHxrujcs6+NFF2e8FuDcDtShB+lvxg+X/Sb+qGWJ0noEE+ZJqWcSa6b30LX6Saw4vsLnywyW96UzhOfcCAaZAmX3hueGiMJeT77SZPY2o/RTs3hB0Y48HqWtRuDjjpays+Ue6AHDD3tOz5pSzYWcIRKpOdw2b5LCz/9Re/TPefGdBKlXywCl5nHolwqSkALbYuqccf20Cw1YgrGCAjw+qYURs4UHha2IFMpN+7nfqfZ8TXLJQ2y0jPibcvlN8rFgcwenshXSswUgt7m9Cm8Q1WGexY/EjARVN+yEK9Iq9cnOrlnz/Asgjt3gVs13uYE64AcAZWDa3ho80GGIYHoFCWID2tWqGxrI95NYQNkEqVjyY49cPVI59FvOlzpy
 HI+DvduD
 NarAZ0kSdUPvQaL6UVY640lRtlZUWqV6jVYEqZhwZnTfgXSAEyh5gilhckqOgnpnzpSwwlaA/oOH920domir+ltP7l+8j7/XO72YmogFI4vgs1lgmCifenNloX05lsXrQFzZ9hXygfyI12nbrfNdp9FBBvgMDarSHS6U2CzkJKMu7nsg7cfVD+mDmYWI2LUuwXNeL20EE2eRTo4lRSWOmS1amzAYcKEgZVJyJqou5bBljYU0LOsXGYXzUJf6HuEn1E4XivY59r69P6qoQg8g3fjMvS+Xd2Qn4H2dRVtCLuDkkeFwso45OITFzFcBj5eIs7PA5+3aI8xQEoCPVRoY7KjfgNQWUosGTGJkOB1t6B+EAA2Jw/pJeb3QAr6XC7Si6Ws4+dCj07y5U1+/56bh2N7nRS+9DxrXkpUUdhBZ+hfDdZkc2x3L2Q9Aj1VvRyY9B/ddk9i43Pm2BCNELzbzy4R3napufkX+byeMQVb/Tda5x/jyj9rQlidOiTd0vdG/JiGs8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 12:52:41PM +0800, Muchun Song wrote:
> 
> 
> > On Nov 24, 2026, at 12:33, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> > 
> > On Tue, Nov 24, 2026 at 10:50:00AM +0800, Muchun Song wrote:
> >> 
> >> 
> >>> On Nov 24, 2026, at 08:04, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> >>> 
> > [...]
> >> 
> >> The leak analysis and the fix look correct to me. However, using
> >> CSS_RELEASED here makes the private ID cleanup depend on a generic CSS
> >> teardown state, and adds an accessor solely for this failure path.
> >> 
> >> The private ID is not needed until mem_cgroup_css_online(), so could we
> >> instead reserve it at the beginning of that callback? Failures in
> >> css_create() before ->css_online() would then never own a private ID,
> >> while failures after the reservation would continue to use the existing
> >> mem_cgroup_private_id_remove() cleanup.
> >> 
> >> This would also make the private ID lifecycle more explicit: reserve and
> >> publish it during online, then drop the initial reference during offline.
> >> It would avoid both the new css_is_released() helper and special handling
> >> in mem_cgroup_css_free().
> > 
> > Thanks Muchun. Nothing needs the private ID before ->css_online(), so
> > reserving it there would work. But it moves the out-of-IDs failure from
> > ->css_alloc() to ->css_online(). By then css_create() has linked the
> > css into the parent's children list and css_idr, so mem_cgroup_iter()
> > can css_tryget() it and cache it in iter->position. A css that fails
> > online is freed without ->css_released(), so
> > invalidate_reclaim_iterators() never runs, and the free does not wait
> > for those references. Today memcg's ->css_online() fails only when a
> > small allocation fails. With the move, every mkdir on a system that is
> > out of IDs would take that path. I would rather keep failing in
> > ->css_alloc(), before anything is visible.
> > 
> > To drop the CSS_RELEASED dependency, I can test the ID's own state:
> > !memcg->private_id_objcg means the ID was never published and the memcg
> > still owns the reservation. Let me know if that works for you.
> 
> You're right. I missed that the css is visible to mem_cgroup_iter()
> before ->css_online() completes. Using private_id_objcg to track whether
> the reservation was published makes sense to me. Thanks Shakeel!
> 

Oh I just noticed that private_id_objcg is introduced in 7.4, so to
backport the fix to previous stable kernels, we will still need to use
CSS_RELEASED or something else there.

