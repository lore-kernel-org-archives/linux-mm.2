Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C58DC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 15:53:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AB486B0096; Fri, 24 Jul 2026 11:53:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 083986B0098; Fri, 24 Jul 2026 11:53:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8E086B0099; Fri, 24 Jul 2026 11:53:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C54656B0096
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:53:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5EA82A1204
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:53:20 +0000 (UTC)
X-FDA: 85024114560.12.EDA0EFA
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 55A42120008
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:53:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PCpg4SE7;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784908398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06uCIXsveTpkvDVkD9nXslULujIABwBfAiluqsvUQbg=;
	b=V/3cTQMETemkRyoyfCLxxjLAssBH/IFKBHhCSKhpyiPwBLzjOPnlk4ReLw//dqNjYJGpc+
	RDoQkShigKTMHQIaVqglI5y5ZTsiEro5p/3nFC5V+VsCCvVYzu1DASDMtYnsMK+bWZnm9L
	oJK/N4Nzl9wbQ8QPoN62zhpgh4RkS3Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784908398;
	b=gUQ8+n17Zykc/QDP2KL7zzI4yGE92rZn/W8TOsscqZ0mW38GjypRg8UhpsNOcsvxZaGXZr
	drlQoi7YftGBJPxqXndlMTNt7cQJWGAQhGdXCI4h3dcLGYnJSDVqVZ0x3LC47bMdGqN5//
	zovB/YjWrCVvDnYO+4G1+ciddVY6z14=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PCpg4SE7;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Fri, 24 Jul 2026 08:53:09 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784908396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=06uCIXsveTpkvDVkD9nXslULujIABwBfAiluqsvUQbg=;
	b=PCpg4SE7KPs5gD4m8VAbzQQyvn+j9kFS8RF04pCPP14S8Aj6j8jhN19WHt+nEZqTgsK93m
	bkVm9wC9xdo4U4FGGGLIJ0THEQZSQYbg+2yoZOKvwJPg6c50FzmXsqhkoc9Wszyl+qZNtS
	kicIpxgWjnJm4AElvDP1xik7717SOyY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Ridong <ridong.chen@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Song Hu <husong@kylinos.cn>, Ridong Chen <chenridong@xiaomi.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH -v4 2/2] mm: vmscan: fix node reclaim ignoring swappiness
 parameter
Message-ID: <amOKS3Ze3SgmgWMY@linux.dev>
References: <20260723032434.2016749-1-ridong.chen@linux.dev>
 <20260723032434.2016749-3-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260723032434.2016749-3-ridong.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 55A42120008
X-Stat-Signature: 4e8fz3xtwa3dxbffzzp599ea675dxf49
X-Rspam-User: 
X-HE-Tag: 1784908398-229940
X-HE-Meta: U2FsdGVkX1+kpBeYJxCTxo3C/ivWdTwv9jJqcvYJdIADpr0c6aGuhN6eq/sNJnLcJdJKGIsxT/LqdPjTPlVET2FK5ug7WdiFSHK7B+Fki5+s2L82RHmCZXyVWhp6JM5kLdSJownfB9yHzKGCLU2oN8eQrLch8+YAwZDUzVq6x3tpTkBh212eArBywhGNBHSi/1nHQVZ8P/fK2HXB4IK7eCI20xA96Wo56sD+Idc8IQreITU4OIjeSxnCiKryzlOxrpK5hhddhOVymNuYIkhi9qhfKhBFj0pS75JFSAjNzZkTpzvvYleZFMDEcKL0UooVVmogIfXCUlANCNI49I8J7sTrQU9OBt81EVuY0SyDFuIke7aromcnWYEwHoROA1lidiZ4IK7xO5/5vyF5as7XEe9OhMHkYVNnkI7o/wROOf41TskXr915VVbb0wZcUALmK8kV6Kmvlkrs3+4Jal3y7dkySG0RvnVLZ61NKoiudxyrOneR4ifv8UcYJpPLjwWgbsm4yFxzQRu4BIxv+iw9WPnfsZG9F0N3CYqu5KMwmN/YvhHKfQ/5sIQlaAZ1K1fvx8Q2m7itflAgZyaXXklji66oCoeyE1U+1sZvvlUvjdAAiyZmm0u8Xkd/Z4Q/4gx4ZZiFTL8FZfilH/FyOKbgokYwlUz3YCc7ivzqbjRXwvJWrLgjERfw7dLfV8yxpr1e5kPbC58i01wTuOk4YfAbx6dLR5PrsH14nbaqN89xS4gINWj0Q64ogpmco752eAsKnlriqW0Z5q0VP/QLryTItQDANdcJDK+e/xHjoDY2xAqigZxeh+5FoMIblJH6rFexICeCoR/4Pwo1F/kOi0ePZVn4RmYvK6FyNxqNOzhb9xZvZ2uJLKsbZq8TWHLQA1JaayjmnnQrGsfP5V0QsbFMx2tY0NmigZA6iWieZ/oNCBGWsIOSTN2DnQ5vYDM7UX0W+GLSljL2W8MiFO+Rz1I
 TCIBmaDw
 qsThP64b8NRx6dRXWmG8DvENDUXAQRKpaAfmyQkU22VSWc4rWTK2rtTBgoHSmdNg6x96EZsKNvrcwj7kqCqvL7IOI6LM0pHKRjlbLs+jAo5PaCA5CXGYjz6EToBZxbld+J5Ohz0o64uzKZPn1sPSJzq9xUHcYVP0KX1NIQD4c4aqBxd2L5KON+jrZvUaFrbS3hfBicdRnWP5410ipgXaExYHwCUfDwXaz7bnGY66Ky3FGqNJRkEB+3z9e9jTzbEuNs6uN0XOXeJ+K35HBLhaYnnE1pxokNqWNhGV69CwL5dH84gtqRCA3Kfo0f3XekfC/wAU+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 11:24:34AM +0800, Ridong wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> sc_swappiness() had two separate definitions depending on
> CONFIG_MEMCG. The !CONFIG_MEMCG variant simply returned
> vm_swappiness, ignoring the proactive_swappiness value passed
> through scan_control. This caused the swappiness parameter
> written to /sys/devices/system/node/nodeX/reclaim to have no
> effect when CONFIG_MEMCG is disabled.
> 
> Fix this by consolidating sc_swappiness() into a single definition
> that checks sc->proactive_swappiness first, then falls back to
> mem_cgroup_swappiness() which already handles both CONFIG_MEMCG
> and !CONFIG_MEMCG.
> 
> Before fix (swappiness=max ignored, mostly file pages reclaimed):
> 
>     # cat /proc/sys/vm/swappiness
>     60
>     # cat /proc/vmstat | grep pgsteal
>     pgsteal_kswapd 0
>     pgsteal_direct 0
>     pgsteal_khugepaged 0
>     pgsteal_proactive 1840
>     pgsteal_anon 25
>     pgsteal_file 1815
>     # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
>     # cat /proc/vmstat | grep pgsteal
>     pgsteal_kswapd 0
>     pgsteal_direct 0
>     pgsteal_khugepaged 0
>     pgsteal_proactive 18013
>     pgsteal_anon 337
>     pgsteal_file 17676
> 
> After fix (swappiness=max honored, anon pages reclaimed as expected):
> 
>     # cat /proc/vmstat | grep pgsteal
>     pgsteal_kswapd 0
>     pgsteal_direct 0
>     pgsteal_khugepaged 0
>     pgsteal_proactive 0
>     pgsteal_anon 0
>     pgsteal_file 0
>     # echo "64M swappiness=max" > /sys/devices/system/node/node0/reclaim
>     # cat /proc/vmstat | grep pgsteal
>     pgsteal_kswapd 0
>     pgsteal_direct 0
>     pgsteal_khugepaged 0
>     pgsteal_proactive 16283
>     pgsteal_anon 16283
>     pgsteal_file 0
> 
> Cc: stable@vger.kernel.org # 6.17+
> Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> Tested-by: Song Hu <husong@kylinos.cn>
> Reviewed-by: Song Hu <husong@kylinos.cn>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

