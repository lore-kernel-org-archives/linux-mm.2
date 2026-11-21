Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A52C606A337
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 03:11:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=BS/bHeTg
Received: by kanga.kvack.org (Postfix)
	id E69236B05B1; Fri, 20 Nov 2026 22:11:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1A586B05B2; Fri, 20 Nov 2026 22:11:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D097A6B05B3; Fri, 20 Nov 2026 22:11:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A89456B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:11:27 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 24492802B4
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 03:11:27 +0000 (UTC)
X-FDA: 85457650614.04.E8C637A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 440A1100003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 03:11:25 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="BS/bHeTg";
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795230685;
	b=8biVizhGoi/GrlYGkRF8Pgd5xAJnbg8at1H1XjzyKfz/cIv0iCh4RR6qq7lZuzifxpzM5u
	88UPSaW/ICJUspagQaky7pJAAgwUn/1H6WgZWqEglVlN22Bvysn8lL3EeOsjVWJCjCx9FT
	kC4gFP+ctLT5k62no8YIuOq2kW5+KzY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795230685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r1VxHdvjTAQqwIi48lBUjfmQrAuXiHwG2H/BM8QNl/s=;
	b=m34IQeZybV7w78x/gMwtm+CPLegHbpdb8pv/oXQ4dRbC5iQ/bAWYcj4kpKEjy/kPMlthdc
	j2kK4RycPBLUuH2nuAiUkuzfdnZfRdUIyeVr5MM+6wy5A1ecZoI62GPfLMvJdGOUlz6svr
	6zVGNq5HBquYy48K2hsXvN6iWvUD3ZM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="BS/bHeTg";
	dmarc=none;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F33EE40B62;
	Sat, 21 Nov 2026 03:11:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 367791F000D3;
	Sat, 21 Nov 2026 03:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795230683;
	bh=r1VxHdvjTAQqwIi48lBUjfmQrAuXiHwG2H/BM8QNl/s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BS/bHeTg3i9yU0iRDPP1R3YfsQF2x6YPJyg+rvwjV5aN7f+0+yUx8P8u9mlS80Oo3
	 BPCIXLXGgacppWIdgofzZFrDrkTqR4JQQFDYA5YxFgLRH4arI9Fwo+StBe/bXn2zuW
	 l+TWeOp7WX0bejBF9sukOBw4cN+yK2Evl673poBs=
Date: Fri, 20 Nov 2026 19:11:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, mkoutny@suse.com,
 david@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev, david@fromorbit.com, qi.zheng@linux.dev,
 yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev,
 xlpang@linux.alibaba.com, ryncsn@gmail.com, gourry@gourry.net,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 RESEND 0/5] mm: restore per-memcg reclaim for NONSLAB
 shrinkers under nokmem
Message-Id: <20261120191122.f31167fc1c987196e5a0b86b@linux-foundation.org>
In-Reply-To: <565e4075-2788-4310-8309-7739b9ee94ed@linux.alibaba.com>
References: <20261105092233.3558950-1-qinyuntan@linux.alibaba.com>
	<20261109215053.85df5685da951ab47ef858f1@linux-foundation.org>
	<565e4075-2788-4310-8309-7739b9ee94ed@linux.alibaba.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 440A1100003
X-Rspam-User:
X-Stat-Signature: fjfg77faica855d5ze9kwkpfkapz9d1t
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795230685-847957
X-HE-Meta: U2FsdGVkX19vSuvxfiONkR8nZ+4Rb+Lu4lCcaw/jhlSZE4qPex75VkQxXDtbenyr/mG48f8uwaDTYQuE6G+r1t0gd1lC4Quuh576xKelFVtwu9aq793Knd3F0IkB521BGlq4Rge65zmi6nWuNbgCQxNSGfLz53GlGDDIJfzPzGkzZ+0c2wPb9P7Ar1DCXJg5PXJdaMDX0v4QV+lRKGpqK5TdFD+vEFEGZ4SUW6AHJnl+X2hbUR2reZM0ImBXGB6JrUuaDD+uwP0ifzERKUtoqunqMvrYt4P4Lf+o40KaWA1qbeU8KGlElhBkkmb9XS3UL3Rv7UqAfx7TP7t7aFsxpUZEcUw/Es1gZzd4cpmTkKmFVcJD8F7KdMwrQgF+hDIj1g3lrCasOUZUpTbw4MxBt+vPDwffJ+/SknImVv8tGFOm67VGdhuR16TisCsSS6y0mNH9LvYbEMw75xRxmo/brqnSb67ezPZQqgikXrsBpDLx+/CYUVvqdHCacDWv0pZ0XOsg7aea30umUhomNjeRBHA3h3HrdYphgnI1LbVvBsT6PC1Y5bk1fANkeIywtGF64osgZIfiuAYqLW1SpDV7DuYSsqd3ptS9PittcXeUPLK3UR8Vm383IovlOVqbZe4Zkshf56U8G/QYXaplPDtE3PVpAgWBJg+Ihx5/Mcx2TytI4KP8Oiq4cagUX4jnuS4upkHgA/Ix+N9S8StPGvpargo2IIuXVqzjnyP8dgxm3y2q+v+5IB7i9YCkkKVYXgmQ7WGcfmIzT4IAUpRby7z64Ix+MIJ+m3UqgtJ1nshAJ9zQaeK1mEKcM90zAUnrNi02PjhtR8GzpfNYYQKdhzPu9JV9NyEP8IbSV8YjTeCBuPMKyX5HxmfzUcKnjvbcNGWjkqUHg7wlIjBVwADKIoIFd/kwGFq4aOTamv0yfUU3a5VdDN4IX4axfHNj6VI45PwpynEYuF5L3nvKC8aj6zS
 pYTtLHge
 orHHpBUaFwjNXlMu3O3H9Z05bb3qcPOvjbg8KeGIp7ITD7DbstT0VGuq8xb0OtxxGiJdW3UUcvLAftxBB2aIrUu3QidvleR/OmVKt6oWFsXfaO892vsyx/W2POT3jFOPYES2UiW0LBhXfPMtLoVipg+GywQZToQznQprWKcqMXZacCYD+RzMYPwYEQhfDqEQWb8FKfssrQtoXHh1XNas2rPVctE8PRvPLrGCBIkfcVlzygiig1sU6Hhuv6uU0thIZsfgRSqnPIQF8NxPC5D31R+FCtOBaH9ZvTivYzGPcmYALTegzP7HZKhJA9bnA1tBeygldoqreXaDzEtX+z2Ec4hbD4G00wZkzq+f5oohBDWVr6+ZzP6zP5JbvG3E/XZdC/b6yOD1qOiinhZE1U773yMpJjc0OzUIuyFc1V5V7v3kfvVdtDoAwqGzukm9RSYPXvOmlYMc/iQcvemfXxMXEK/AceKJ2TNATW1Mlc/foK9wa3flrPbSAtj4GRBWrXe0Mm8XH6wbIU9Qrpbw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 20 Nov 2026 15:04:37 +0800 Qinyun Tan <qinyuntan@linux.alibaba.com> wrote:

> 
> >> objects of all cgroups share one list per node: the per-memcg
> >> shrinker bit is only set for whichever memcg happens to repopulate
> >> the empty list, so pressure in other cgroups may not even trigger
> >> the scan, and when it does, the scan walks everyone's objects.
> > 
> > Thanks.  Sashiko still has significant-sounding things to say:
> > 
> > 	https://sashiko.dev/#/patchset/20261105092233.3558950-1-qinyuntan@linux.alibaba.com
> > 
> > It also says "failed" for reasons I don't understand and it doesn't
> > seem to have emailed anyone.  Please check it out?
> 
> 
> Hi Andrew,
> 
> Sorry it's taken me this long to get back to you. I've had a very busy
> couple of weeks.
> 
> Thanks for pointing me to the report. I looked into the two issues
> Sashiko flagged in patch 2/5.
> 
> Sashiko pointed out that mem_cgroup_id() identifies the cgroup
> directory. We reproduced the ID collision on v4: after disabling and
> re-enabling the memory controller on the same cgroup, the old and new
> memcgs had the same mem_cgroup_id(). Once the new memcg has its own
> LRU list, a lookup for the old memcg can therefore find the new list.
> 
> I think memcg->css.id would be a better fit for the list_lru index.
> Each per-memcg list belongs to a particular memory CSS, and its ID can
> only be reused after the last reference to that CSS is dropped and an
> RCU grace period has elapsed. That keeps the indices distinct for as
> long as the old CSS can still be accessed.

Yes, it sounds like ->css.id better matches the lifetime needs.  And
the root memcg list_lru retains index=0?

> The second finding is the same race that Shakeel's patch [1] addresses.
> It predates this series: a folio can move to the root memcg between
> the two lookups in folio_memcg_list_lru_alloc(). Shakeel's patch
> rechecks whether allocation is needed after taking the memcg reference.
> That also prevents the unnecessary allocation at index 0 that Sashiko
> flagged in v4.
> 
> Does using the CSS ID for the list_lru index sound reasonable? I'd be
> happy to incorporate any suggestions and send a v5.

Shakeel has a couple of related fixes in mm-usable ("mm: list_lru: fix
NULL deref when a folio moves to the root memcg" and "mm: list_lru:
don't use a new memcg's lists for an offline memcg") so please base on
that.

