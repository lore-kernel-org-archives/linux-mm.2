Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA9D2C44501
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 12:34:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44B396B0093; Mon, 13 Jul 2026 08:34:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D3266B0095; Mon, 13 Jul 2026 08:34:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C2F86B0096; Mon, 13 Jul 2026 08:34:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 112016B0093
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:34:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A6220168266
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:34:54 +0000 (UTC)
X-FDA: 84983697708.12.01412A8
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf20.hostedemail.com (Postfix) with ESMTP id D7BA61C000C
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:34:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=upOGX7wO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783946093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lHypyUNn2HVnK1SWBb4ieypi03fXxl2jL6EyCeQIuUw=;
	b=xglkZLV+17y01B6T8mE1nHxNUFEtkoqM89+IDL0gchnIcvboNzQ6wlW7b/IZuu6dUmZADR
	BlFksW8LZ7iIqYxv0n1iNTob5ayyak6nT2IGE1YGSIxz+XcSeiE671wqoyA7URoIAtgWhu
	b5fbejY5zoFpAXD9736yG6X/WC7sx6Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=upOGX7wO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783946093;
	b=qIYQ5i89VlFr3JM1+zsMHpEHAbJ8FmwXidLVwcFFwOJ+Y2v5fuRjucoyC8oTDEjz8K2SpA
	paGvgSM/JBHTSNy8gCyDxNpQOKW+4nxFL+THxPtm6fpasSshBS878dWuOD7j8/zYL4M0q8
	5ACnIHVCmbfGzsKt5OpbL9Vlm0oL250=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783946091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lHypyUNn2HVnK1SWBb4ieypi03fXxl2jL6EyCeQIuUw=;
	b=upOGX7wOzhWGgpudj11Mxbp9JfS5C7idfCct/CWgItwz6yiESe7f9bF5/CPTKMjaIboxnr
	ogsLMVm068Qh/mKIhWwKZ7c3Eet0iUNESFG1ywQqF+pR0XHDKuGOVxwew6PraN4Q3T7XNf
	LwbgzJX/8jCWTvzN96/xBOBpvEcM0Pw=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm: memcg-v1: make mem_cgroup_oom_notify_cb() return void
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260713093737.3299646-1-guopeng.zhang@linux.dev>
Date: Mon, 13 Jul 2026 20:34:14 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Guopeng Zhang <zhangguopeng@kylinos.cn>
Content-Transfer-Encoding: 7bit
Message-Id: <F7C69746-C0A3-41AC-95EB-BCE6D73C2FF1@linux.dev>
References: <20260713093737.3299646-1-guopeng.zhang@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D7BA61C000C
X-Stat-Signature: 1tipawrsc8qri6wky57g7yrcue1jjacw
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783946092-841041
X-HE-Meta: U2FsdGVkX1+C2BM0ImX3Np/7uX4BG5Bqszrh85yRKFd9Ve9trJ4lff5TbdJoWQAQPPl4ndk0UnQ0V9InSHXnu5cgs1Lt2Q9LnJge53RddmUZ0hZntg32M590PHvHmpZKSl6AJ7ruR6suUb1i+L6hrmc7aUuVtMHQYy+Hmh2SaAerqZRAbsPZMmzLj0u8zPpHLt+19XQb9E5DF3z92FjTzkB7/FFfCZAkt9yFb04+Kmu978DbEJI08QcM8L0lPdoMhiFypGNmiGQd5gQa0AhQt026kWY79OYZNWufX/elIgJEw7/QlFTYUwsw0O9YKsbjUPVwXsJEg0Np/uSF6o+Hmz6eOAH4Pp4SKyhR27IYhPy1xGB4XIAHbRRhv5PsP5wAfHBPTpTm3867yctoX9/JhnmpgcOAS/xlJFVBAacr29Mz+UCwM8hDSCOt2QKdv7DJZQwyyqslbgI6w/rwDck2o8fo4J9veX04BrJS+iUIMZKrsOAAqUXYqDjSnn+QPJx373SONBFroaGM1c4/Ho/BffKIm6KDTkY0g+PJn2yd8NIPBBav3rj23rOy0UfKDvOYyKukQLxZv29UMrQGPMVQ8aR605mQj8Hdo6hpN4h39UL1/OF091EWGx0gcrAGx45rGr3yV6j1p6OHSt5Ks/CKbk+n0qkAQaXsXg+kDIeI8zR1zlt3ghL8vyHPPDwHPbYq5iz1t0v/SFliEN4lEN82N/207qdgooNWrPVmxcWjrCN/bOg6VTiZ5GPGNoGRZv+U3zEHIjCcmte5gEMM3ZYGQ+Ns8dGqld0PstLnFWXx7JkFS7h0EAVZDM+bxsJYfyFfMmdzaA8p0geypo98kukSoO9PQ3IPtpavs5RniT82v/D7GuTUtNE+xuSRe1zmUSi6jRz/13xuslOvrRBvyMdn2dKmbMUM2ZVs8nifpeKgDK9uimHINiCe42MOtzn6apzBzwk72/VmCB7ybUzm0h9
 LRTb4a3U
 g1uHEAxKt4fj0Htz6rojsq7u/bN7B5jglHIfoVpcNLJvEyYDGVaN/DfA0/fqKM0yy+qBWZgBC4V41/Tbl8rTgR2AFaVzsO0Cdi9qm4CYFOrInK1g1o1YPvNwIz/2GWFPLNOqzW8Y8PWQu2AsvXmgPHVOHWhmwDQ0FsAtIUb8tuYwQKwmhMkcXV3fXRgFtDiZ9bJ6sVa/ZCFs4aLRFkfIqgEIk6YybSffAmJenPrck86awVt4e9HECiT/IJ40nTbAQ2DdyrLhdb2dWWQb1aCvpD08p/LJ9Q5dnjKBC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 13, 2026, at 17:37, Guopeng Zhang <guopeng.zhang@linux.dev> wrote:
> 
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Commit 7d74b06f240f ("memcg: use for_each_mem_cgroup") replaced the
> mem_cgroup_walk_tree() call in mem_cgroup_oom_notify() with
> for_each_mem_cgroup_tree(), but left mem_cgroup_oom_notify_cb() with the
> int return type required by the old callback interface.
> 
> The function now has a single direct caller and no failure path. Make it
> return void.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>



