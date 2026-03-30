Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 119CBFF4923
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 01:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C08B6B0092; Sun, 29 Mar 2026 21:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 398706B0095; Sun, 29 Mar 2026 21:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4DB6B0096; Sun, 29 Mar 2026 21:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1AD106B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 21:14:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C28C2BA901
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 01:14:45 +0000 (UTC)
X-FDA: 84600959730.23.D72CBDF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 339B1C0003
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 01:14:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IYiJrErn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774833284; a=rsa-sha256;
	cv=none;
	b=fyAUqUaTkhA54AIfR3H1187FwCKXRgT2aDBA11QAqj5nX8dnIjlwMzEv/6Dn/aSK19X2zc
	desM2rKcNvdxigIxC8ecX7BJTmNLpLE+3OXLM7BYiDdWbjYkCCLLbGdhcPkunCEdeS+zk/
	5qcuZd9HlAb6We9zO9b95tUCRafBTMg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IYiJrErn;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774833284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q51MN9+ThAL+8FspZX5BqRE5XvkacQFVt9GFPA/wdFg=;
	b=4X0gbWHRB6jyaOXyHRxy2i0fBABA9Zbs25nA/4Lqb7Ib3ADcHWXpHspbJ4Gbp2B3x2Mc0X
	mAHs93CIZ4GpKdttfJaZcMU8K3mTbvzTleinx9gUtBBYVrx34PN0LwTeNsLVmAGGBRREFG
	PbmzFngIve1ojc6wmH5ThL+igQufZ8Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F41560054;
	Mon, 30 Mar 2026 01:14:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F4DC116C6;
	Mon, 30 Mar 2026 01:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774833282;
	bh=/7Ah5Z1SHMv8GNRrUzsyDmEAabM4k91FZBwln3xVPjo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IYiJrErnEQtj4VKVHg9arGLvc5YcEblwezF0skuNGBch+e+dPjfRzy2zGe/vKAE8n
	 oBb2fhlNZcR2TBRYJEz0+Wm5I96MNdyRxpy/idA5zk4qt5LuO7uWYaTBSlk0ZOP+Fv
	 V45XM3qLh8wPrVYSjNDL1eVBPyzCYQ4Xh+YVCG82SRrEMNdx3iAOpsjI/LlUBR4D+4
	 V+yTRtkCDD/WGA4Y84PwmO30LPadgjoFeTPdm505StBqZzNYrkaPum9Mv90LSzaCf1
	 VOVnKXMwNImqT6rdsH4uYXqyIhNiIBH466qgL4O4JOAYU03YH/oEEjvOMNqBoOj9Hc
	 7myEjjq3zafag==
Date: Mon, 30 Mar 2026 10:14:40 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org,
	ziy@nvidia.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com,
	mkoutny@suse.com, akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 1/3] mm: memcontrol: correct the type of stats_updates
 to unsigned long
Message-ID: <acnOgEK3KMLiF5wg@hyeyoo>
References: <cover.1774604356.git.zhengqi.arch@bytedance.com>
 <a5b0b468e7b4fe5f26c50e36d5d016f16d92f98f.1774604356.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5b0b468e7b4fe5f26c50e36d5d016f16d92f98f.1774604356.git.zhengqi.arch@bytedance.com>
X-Stat-Signature: htip33dr1mkbep1a6mjm7wthqw4k3eco
X-Rspamd-Queue-Id: 339B1C0003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774833284-837716
X-HE-Meta: U2FsdGVkX1/nuYOFQnp98S/87QamJYUDjdPpwkHaoWyhpS6u4ty/YTuRdV3P6Dr8am2x+pjYxeX7DHkW1loHcdU3HKpzZqKsdPZSXiRIiBCkU9pKWnOiMFopqoaI59pPVNR1Tok+2wKBcTfGvhnu/p/6X69D+zp8S1G5+gJZEKIXg2Qo1IHjuD791xspGbsw0qixpcRiu8ZI8kRb2YVZ7aMi0wTzzAXdE5D4DxtbtwSRtTCa4y/nIfpHpEnHtY3B57QlP3U7UeKo1szE57isl+ejkQVg6M+Zq8orALxEPn2CzZ7ZaBHmivF6pg4wcS9NZvEqiXCr6Rm2ur4smmzkXrUww5torU4nxlSncH/8UNEG9+BuqRyAcoxLHOkVEI7vW8UAMzTzsA94f3niiegWesR7lXoZ73WYxobVZ/wXUcFbDsGZPV33jn6ti50DzwbrLjgOfoeajAAlQr4EAW/2HmIWU0vJFdg+STqGtjUvGHUUe2vtjvHmsa2dw3J2q6BE//YTTosrtZgkJNq8V5Z1Zh4Y8VY4Upe+OgHG7tPez1CMjJYIRyH7M97RN3mXTotENXWCk8U0neoabVcwtNVAB4FHeCXgBaxWv0/PK9iNndiubHJ/w6ny+SyuiqAIE7XyB/U9huEb2AxOae4tmRAfzx40pL89nS0lvNPxNWc6Ib9AYg9eJlZalM7rOzk/EDEJ38KdCDZvS4dsYRxN/q08NUwzlMzceWKtsTmOLX/xEwxYw5JASk3GniKzjbdBD0fJ89ldtboBpCv1Vw1e+/Xi6D5GsKkxmL2NS/iuEWkEs1Ur1M77B0uej6R6CbvCsBAdvYsy713o1+6WV+rpcfPCP5L30lOkwOh+gYaarC+qxTS7Td83NdrmtSAL5igPuGrRRa7xlDs6lkV+eF17uA9QpxXEz32stDKvWZbqN0pQnjhsrndjgdYF59lWeC0JRN0lRZZkgQ0z4Wd6dPrVSyU
 g4SaMImD
 MUwHuTta99dk5KNUEIdKJGA/HXPBxLZ3kuraSsTTzfZinT/dSzId7RLEXsI8usHvfUMrjp45PhPC9yWzE9oRIX6tiZ25gNtXbppoLJuPLCu5BVuqoR74tb7Cp19thxZyv+XeYLC750ZJOCtPHcXs6rWQcDh4ZSxbufpy341RB+UdOcy+gnW0njYx6JEFExZX1Lia4ybz6BKyyF4WJaznlqOQorXrGrqfjYmeXz0OyFp+ATkXJH5NVOUEDuvmSFui0jfqcWzwJUFuG4HeQoKD8hsE2MzhLqr9nlVNkhTGqvSjbQW4eQvr1wNJ2LdDGzIGMd/zlvSW05a7pZne11VUrmZzcVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 06:16:28PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The memcg_rstat_updated() tracks updates for vmstats_percpu->state
> and lruvec_stats_percpu->state. Since these state values are of type long,
> change the val parameter passed to memcg_rstat_updated() to long as well.
> 
> Correspondingly, change the type of stats_updates in struct
> memcg_vmstats_percpu and struct memcg_vmstats from unsigned int and
> atomic_t to unsigned long and atomic_long_t respectively to prevent
> potential overflow when handling large state updates during the
> reparenting of LRU folios.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

