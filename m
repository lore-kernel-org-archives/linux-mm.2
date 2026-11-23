Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B62D606A331
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GgxVl97e
Received: by kanga.kvack.org (Postfix)
	id 537E86B05B1; Mon, 23 Nov 2026 13:47:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E94B6B05B3; Mon, 23 Nov 2026 13:47:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FFC86B05B6; Mon, 23 Nov 2026 13:47:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1C63B6B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:47:34 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 826CEC099F
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:47:33 +0000 (UTC)
X-FDA: 85467267186.07.9447695
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id E1D7E4000C
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:47:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GgxVl97e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795459652;
	b=NMWTfrZ8rPKwB6CePxdrQtESKDcsqCg0fdcSja7nII66ZvuTtlgnIwd03BvXm07hiVDoL7
	zrHj1NLb6S1oVpfKRJVqKMGZ6B3g9N9tNG+/4PRPXUu3veNF/3p0cIp2GPXs7iAhmPHdWq
	sDRj8FIYRFyvC/ifc2d6T7O1KN3q1bI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795459652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aSALYuTxlI9FeESjO7ECbl+uracOgIb0rur/G8EWRyQ=;
	b=cHaMZ9/M0yMWjsNShBp2CW50HvdTOw7xqrjC+EMDAm+f3TWpivak6RBWrWF53j43wz63YT
	4xMCfNhUSA+h0qBXIkFvqBHTSelHxCAdFSDu7EXfnfthJs6AckI66Dannh336Ik89gyHB/
	/PlKnbNQnxyqGL/gkgVECSZnlQKCjiY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GgxVl97e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5838860F13;
	Mon, 23 Nov 2026 18:47:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6071F000C0;
	Mon, 23 Nov 2026 18:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795459650;
	bh=aSALYuTxlI9FeESjO7ECbl+uracOgIb0rur/G8EWRyQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=GgxVl97eZ3AUEyjHNcn367UVnLOH6rapiXfmJG3lNlByBsLNBaLobvSUJO7giH+83
	 pyFW3GW0CGzHTcHvCeNtwBB89xNEgueKTAvNLXCQbZBPyx2e2GDqNtfQvP3P+EOWCR
	 g4SD3jz4+DV/Sx6IwFwrIcr1ifMqVMhbx4LHa5DIyGJhpmsLdObKaLQFGQV6dNRcvu
	 yby66ii73BD3ayfJtRDK/r/sDGvt+/irzHH9AEzO+tPX9ETAl7u9p0AKlNDNs5247H
	 MDWhBZunKRtmIB35P++dhs91qi4EYqfVjglAXIJhf7e8R48Se0Jl/hTdIWl8ssagdk
	 B7ov1lMR/pcqw==
Date: Mon, 23 Nov 2026 18:47:28 +0000
From: Harry Yoo <harry@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v4 1/2] mm/page_alloc: move the kswapd node skip check
 into a helper
Message-ID: <awSJ7G7nf3nmL4zx@thinkstation>
References: <20261123181829.4065581-1-joshua.hahnjy@gmail.com>
 <20261123181829.4065581-2-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123181829.4065581-2-joshua.hahnjy@gmail.com>
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E1D7E4000C
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: thiwm6hu1uejg4riqw4fg545m4h41p39
X-HE-Tag: 1795459651-806234
X-HE-Meta: U2FsdGVkX19UBNweGR3594RZmAxNLipb3gCgIBVcRN2+2V8q3i/EhENF5T8Y++Zd1tBHfQmNlP5xaXVMpy00Ahfp/OMjqXJDe7pKPHjjmNKlL8nRS0B6UUCTonTPPWJoqqZt1fRpSU35csFMPyE5SD72OOCdu670pKIkYAN50g9VmvTy82awHmbTVnthDzDnx7V6qcOZ2/uHvrZEXTlWeIrUS9TL101EAJ7E32d5qfvs+HKhcgLwD1KO32lsAta5mFhuLkZTIDugo5QREbuhyhme/OH4m7gwABUi7/Ir/3vJndCK8aGaBxBqHtkwj02HSg+67syIZkb3qnYDb0YTxgzsStzqfTDBMJ2KMZYdZlyJaYgAhKLu8iTEHz5XlID5H/TbZldP+AgIOJozvhzWrhyOX8foXQJUC+rVJ8DSgpkYWcx9Op8qaX6Dg86rtrwXpopadaWqyn2fBG3HPibfjiT7fu7SJVWoFUMwH6gaRJjeZ28Hv1KqdGmuNqB7hUsVEE2PzVTT47EJPvhTPa/zS9ILB9q4APtRtGQgUMKso4BEdgP/WL76MiY7wSul1NlOGqy9cpL42rpeZN5q7HH+ZaaG/hfF9j7SmOuyzkTsAhiY5F2YvFTTH4/yBGMF0KzmT0qbIUIit81XvNzN5XTTlOXWewOJupBaAC78dAqjFXOYL97/uP6egu7HmvyCRWJVrcPWHnCoJWyXAiC3m6gTpAhJmyVLx2+JrkLfUwLig1G6ONz08W/kzOTfEws+VLAC0WRyDxxUjqyMMGqow1mxJ3EUtWGmpSn7gvzK5fp1p9HEVTE1xDt4yBybT2sqan7LtwgqbNaIWzy1XV3Du3cz0Cw4sYPPXVU85InCCHlnrQZ00k3H7SsUTBI4NB7dN+gYuyWIPsTDGX0V/oaP0FlQ3nkGUn6pII0H7eSOAtIb913etSrhboBgEvMlraHgTIG7y8T/NDOsy4yUcQ9Giwr
 gUvC3OxD
 VtFMfyhnnbAQAQWYIw6fb383w2okAPKpJpO/Ngk4ZnCNiikNFOqKCHYeKlmKLY8qfBcEPYGD2LBPSf3uxvv56BrlwUh1n9NvKFya2gTwzewr5rye7QxCbeWa+OCXGNZLgTFWoCfPqAUO0/OjXBGmsGSnvQCYiynHnz+8vd0xQEpmRLf3AKaagPCpHt58jmv3Z8YSFdneiKtOrPiKCpoRXaaV0jMHhZPCELf2MBJpjS/4/6QFlM1F6hHuJ3vip9f2DynU66SlcfE1K4CFEM8s29eIvgbaadiOjQNmY05tJuwOilCxq0wIBBzC1OGIgmW384pqC0yMHlEH3z5IgqYAuc+MmAtWUAaqo62MkIC3+JMG2f5LSOov+f9wqz09SRDdRPJS/4wTlTdPPDe2ZDiOlv+rxQUV9gHXg2UbhUq4NMD3jibHjYuybqr3lUVrGKA8unrQbnvgs306wz0RwDlvNnWdChqcMZVQNlAOEFF/3PYkgWUvlBvkeFDrG35ZQO6BFa2B3I+vBAwPe9VdAkdP6Vk4HI69yDd1e7UA0POf6hk+bF1gv2u9teXn0KBLJFyEfuvVfNb/aiAUg8nzrqXBQw6KWKpRcA7xMXS6cND7zUAmQpfC8MOCLwN8MOAFF3c5JCxmxBx5/7qHLD8T9NYGv9HxApVLFB6H+syYf/yLK0dktounpqx6y+3eELGNbemjKHKeA2858YXcxUmfbs2Hh9KT98XzK6+jpBGOEBrYo8DEizGt/MCK88ccl61J+ko1c7yB7pOsnWAs71ileC+vtOgLairsbdNIXk6gg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 10:18:27AM -0800, Joshua Hahn wrote:
> get_page_from_freelist() checks many conditions for each zone, often
> with a big comment block explaining the conditions.
> 
> Move the kswapd check and its comment into should_skip_kswapd_zone() to
> make the zone iteration cleaner to read.
> 
> While moving this, also resolve a checkpatch warning which complains of
> a waitqueue_active() call with no corresponding comment explaining why
> the lockless use is OK in this case.
> 
> No functional change intended.
> 
> Reviewed-by: SJ Park <sj@kernel.org>
> Reviewed-by: Chris Down <chris@chrisdown.name>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> Tested-by: Chris Down <chris@chrisdown.name>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

