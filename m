Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BE94FD4609
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 02:40:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA7736B0088; Wed, 25 Feb 2026 21:40:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E55D86B0089; Wed, 25 Feb 2026 21:40:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D61146B008A; Wed, 25 Feb 2026 21:40:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C02FD6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 21:40:20 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 601A713AB4D
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:40:20 +0000 (UTC)
X-FDA: 84485053800.12.A896560
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id 95692180005
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:40:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QI0TE1dJ;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772073618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rB/Yufk4Q59hquQidpF2pzxYz6y4Be21NRg66TSUZCc=;
	b=J0teumTT+nU9CL8+33zmL6TL9KJCksIBq6+ypzrBqPYKDlhaO57kwdv1xsihGDyMAKcRXv
	9JPFcgbMDhKJDOuhsR1RqO+Op1wxgTWB/h68oUPzm6vk/6sHppCdwDLLV7Z8JhWjywlvIy
	8ovvtjZxWjwhg+pWxMrp02V3b2DK8dg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QI0TE1dJ;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772073618; a=rsa-sha256;
	cv=none;
	b=J6BUPedCFuQkXSC1ME1tbawFk3z/2piV+9caUfd6KsJK4jI6Ywpc9Vtx1tTRyMtlqb0rYW
	OFifZhpCd0sU23JpovTjfcNBAoZ3bGJowmUzNkJN0XPSrUpLV2Rre8uC8fjT3L1897r5Ck
	e+0Urx5JgDYqAtPCs2EYvB5PYoc4SU8=
Date: Wed, 25 Feb 2026 18:40:07 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772073616;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=rB/Yufk4Q59hquQidpF2pzxYz6y4Be21NRg66TSUZCc=;
	b=QI0TE1dJoXpxiwq1XSFant4T8pZYqEYop53rdpYR8nNzwyzDrCPmtUcpYN78Syex43PlXA
	+2oebGbF8N3FxEHRRGG66B7Gfjdp3Rt3J0XJQD3A8JflGla3e6J1r2geNn0XvO43ZIDCat
	0AvxBYHL/+m65guD0Aa572jFfDjO4Eg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, yosry.ahmed@linux.dev, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com, mkoutny@suse.com, 
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, 
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, 
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v5 31/32] mm: memcontrol: eliminate the problem of dying
 memory cgroup for LRU folios
Message-ID: <aZ-yctMtmVYVawK-@linux.dev>
References: <cover.1772005110.git.zhengqi.arch@bytedance.com>
 <ff5a945386f168faa877901d569296592cdaadc3.1772005110.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff5a945386f168faa877901d569296592cdaadc3.1772005110.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 95692180005
X-Stat-Signature: 8wsjjg48y3ytcbj7w666rrcymzj5ihy7
X-HE-Tag: 1772073618-204219
X-HE-Meta: U2FsdGVkX18oQE5EKnIxLj7uvWYjmGhqaDyEaOcwYsG3I3a5FdsHoZ8KLCLEX6/NDMN9ZEjzJkP8xEFV7xBGmAOzpg97gUls/Ti2R/o8GWQKg1edvAq2GvbFj8T7yyOIfNd9CrG/Jvp0i2qaAOjecvAZhbNwBg415E/kdf6G1U2i5+REaqI7WXyzLMIpz05QwOsDqUYl4NEMc0vO1UxEzP5nZO/zdfxhDYcASPvlo8aPX5k8ckhbwnkDTCUKMMbpMZdcd12Vy8wdjZkr9CHSOsvdQb8zyYicYmiyQJFlc4X77hr1ROBX1DGqtbadpBS8jcSJw1tr9xrCP8ixLsoPkEjhGlq0kn7aBgB7CrBKiHU1Gxia9lVPVAQE0v6kb35Na18LvPIUohMtN2i7DMYEG6hFX3TaQm52x1WerGwp6guTwF9rwwpfgB5aXp2u9oEYaUuaoXKN7bEDhcQCFuqGe2hsOJ7K+yYJWt4j2cDJTdHs0iWaS4Z+Y7Be4DSCgwxrHgruEBkpwVR124+BWi6ik9ZDuIcqgceBSzi2iFLV19KtcWdjJGLOJfAjTeuhPI9cl9H5PuqQKAUgQ6UMzVssNy/WGYex7HHne9ahodyzCf5ZW/WJwdedhhwjmyh6v2NTri4EquglL3Uj1j1PqH3PidEpDG14gm13ZKOjrudBXeK3j3jlHT86zbXLZ3+dJbZWTDcEvikJFG5Cl6r3nrUbA2i1nqEdj8SaKrHMxaov8mkaFcHLwenBl6YxeXi/9XWt8biJQy17Qkl08lBvjGJWp/mqBEJYDwfkQ6/Ggz+FwLjh0MXwa6g8lFwDd0+czJXJ0EvNZBxZGvZgeRQcENv4jEXHIMr6ZnmWtcyevQYgd/pGzDn0PiTEKG/lMmtNpdpoG/kyQ9Br7iTFQs6cnGfgtPxbK7ZM24ad/SbcnbhbUt2fkA2eQJZsETaQr54Fmu06nUdO6fYGHS0+lAf4KTv
 4e22TAaP
 T5Ja8DlX9jx4FK2cDtfTSJhIQzPakkCpHDlDhCIYB6kH1fz9GPtvzLRGkkziZ65/6lSZ+GSMv6D3OrhrJ6XvUuWt33o7MjeGDhH6GNRrNTMZ0R/nuM+1fh05Ox0WFCVRKG6byo66ep/TVzPegwApfmnCI81uacJYYkAQCr1zceD+aETgmrItfOYj9RBomRn3RxHF+pF9TVedAQlFpIXFkg5/wkVDPMj7p7KDDPY/pOJSPDV3dFo3Ju1Cg6dj2xFLgYQpats3W+qa1XEU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 03:53:14PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> Now that everything is set up, switch folio->memcg_data pointers to
> objcgs, update the accessors, and execute reparenting on cgroup death.
> 
> Finally, folio->memcg_data of LRU folios and kmem folios will always
> point to an object cgroup pointer. The folio->memcg_data of slab
> folios will point to an vector of object cgroups.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

