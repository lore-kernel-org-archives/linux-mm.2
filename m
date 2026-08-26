Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3588AC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 18:30:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B15816B0088; Wed, 26 Aug 2026 14:30:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9FC06B008A; Wed, 26 Aug 2026 14:30:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 968BD6B008C; Wed, 26 Aug 2026 14:30:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6926E6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 14:30:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B997C140201
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 18:30:41 +0000 (UTC)
X-FDA: 85144261482.17.BBC2347
Received: from mta0.migadu.com (out-131.mta0.migadu.com [91.218.175.131])
	by imf21.hostedemail.com (Postfix) with ESMTP id B0A951C000E
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 18:30:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ovaPIb8T;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.131 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787769040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gHPKshCwaYU1PIJ6YYF00DBrXw+7ULahesTK5ozZdnI=;
	b=IGdwlCL8TU+OzKhcgW8LhJ5ZKv9jIRdJk+ocUZRXI9spTAkhQgQ8yVzzba3+dYHusZPaBI
	LgO1ePW/9gn/+UUg2f6rz9/sLVOUmTkcfCx7ufDZJxZLuQZkcb5EIwI8sy+1u8c8Jd4A5H
	XDhvq/yIAq9rX2eeNLsaNu5KzgXBblA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ovaPIb8T;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.131 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787769040;
	b=gSuxWTIBXU7J8KCu1hXaLe8mlYeRPMFsLUB0gqQ8kM2Kdl36XY2PDM/nA2Pjm0FVjWOtKi
	Esn7YEnWemcI/hOfm8D3Dh4mVOptC2g1IaFIG9Eoza0EoKUhmvExKyvjTyAGWRFC/QVjUJ
	BFaXHp8KFFlown6n1gGJ9XJ8ROQYSfg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=sRp/KET3iYMwTo3XmECBCWWEcdW7TQWTf+Msi3bdCOU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787769038; v=1; x=1788373838;
 b=ovaPIb8TvskgL8WDU9ja1T6dEM57U/m4FBjcA/glxJXH+shadcKUF6iApMrCpMKuER/oRTtb
 LIMMQ/Nhq9KAsx1BCTOp7HFAGcmMLrx/LXKJ8Z0HKFI3kaGZUz9AvwEpKrxwoni0KsBkrjhy8EH
 PRdNjNGMQoS3RqUTREhcvbwM=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:51::)
	by smtp.migadu.com with ESMTPS id cf2c048dfc5b5d89;
	Wed, 26 Aug 2026 18:30:37 +0000
X-Mizu-Trace-ID: cf2c048dfc5b5d89
X-Migadu-Flow: FLOW_OUT
Date: Wed, 26 Aug 2026 11:30:36 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH] mm/vmscan: drop the combined limit gate in
 __node_reclaim()
Message-ID: <ao8wt1YA6ahtQb7W@linux.dev>
References: <20260826124409.35569-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260826124409.35569-1-ridong.chen@linux.dev>
X-Stat-Signature: pistxghsbrsgunb8bufgmfx8gurns5wk
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B0A951C000E
X-Rspam-User: 
X-HE-Tag: 1787769039-913602
X-HE-Meta: U2FsdGVkX1/d+1YSh5fIqHd3sseOSyVY+cTRXwJz6/glqfh4lV8GGY+3konXAUdVc+X3VgEBQTLd/thJ2TWTtD8TnsNkD1hndHNkfkQjaEGhrrT6+2mXwlyDT3cMTIYRI+Jro7qb3glwFl78JG4B1ghbIWXY+S5nimHxzV5Frtk3HtDU+LzWK9GJI/lO+66qCdPq2HXTecCP7lL627VfO5158VoNGpAw5sIvehRPuEsCTUE0aaw8OMdR8VxfcU9EeixBhRgg1eiChYm8wzFT9+odGnjIWAVR6tdck1ARJ27WUtXBsXG721TgOI55RyoH1x504CwHTA7PZq/swdQ7cQl5jLczD+LrITDNNKHCYCUODJpRpY/g3nveGvhC46Xgbi+b67bZKtn1O/db82h7KqIvQZpD2/1bnuibP+cV5/NogAOXLvonkRy4Dc5xGhdnMLu6zEyiymRXge2i8f2AJCKi1P537+UPndJoTUqQmAQsd50MH4V8k01/BVrUcmzfkRaOnGAcZ2xt7EJuwzg9UyZoHuPpMCL052XA9MTxVsHO7AegPFgR604dYvogyQeM264aR+pncXzBDf7Xd/+yta4XgoKKNzMV75zQMUICEmmCarJAXcsO2qQr3gMKFsrxcoc67KDwTqWSqGTv/rJcXVoov8QAnJh+zVdcTN3uY1NE2xwM3ULyoYaa2NYyly/hLn8yc6K5raQe/bw2b3e0lC14U3OVpW3OhBM9IgnjTJui9j0o0rmdcReqkVWj6iyv/eAn4yv+Jdu89fdj1gF2OdOgSaCKv8pRBDos3zXA4hlATLmgHC+7h8QkHYMmhWk1TQ3pGbamHIupSueSq76zfUC6c+fSzHpLaplgRfEDsniw2BYCvUqFbMC/9MG9k7ou5HfYJd5gk1dxhbWJNi5TdRnKyPlHzOfDWwnAjXjnZUVjafLfvp2DPDksQkxi0y/lsNrozr2/KujxwUNCv68
 eZEuRKtL
 1jc4s2wK/V3BUwWvBUSom7MAbJxI3ikid5w+PFb0tiJ4Zoojcl7+Atc6XQiio0TJzuKJbnIysHeKT4cwvOXN79G2OapooQyIKNMe/ZQ6vYKaGBnW4mTy5yueoBOOPGC+6VEqRkzhINtvBeEezOnR79o4LbrTgyhQMNZXN58w70P4I/ux6Qfem0AcgmfXl945jToI8aXIynKaZyKf1shmO9iaE78lDHE7Kf3PpIpJKtzEyd8X3SYtVSvJBc9O7krN5TkzuB7tTDuDPGaQp46+RZkz5efApLaLeXj2IjLcB9DYfyTPdeveu40j/WLfas4Mipq/0100u3FXoBHPBvosx4L0ghCegoQXDjVwKod9MkXlA0PSVVn8Ducl9WqsX7Kks7fudEw6915qPpeAk/P+zhMyKaGA3JBL9jYfWWfa70oybFe1y/PB871n7FuxxkTs0wd/0bygP4ee7edjdbzNuFBOuScw3wslCOWkorMx8KzTIQxNi3JbofgpigBdhOIK++iQU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 08:44:09PM +0800, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> __node_reclaim() is called from two paths: node_reclaim() and
> user_proactive_reclaim().
> 
> node_reclaim() already bails out early unless node_pagecache_reclaimable()
> is over pgdat->min_unmapped_pages or the reclaimable slab is over
> pgdat->min_slab_pages.  The identical check inside __node_reclaim() that
> guards the shrink_node() loop is therefore redundant for this path.
> 
> user_proactive_reclaim() is proactive reclaim driven by userspace and
> should not be gated by the per-node min_unmapped_pages / min_slab_pages
> limits at all [1].  With the gate in place, a proactive request is silently
> turned into a no-op whenever the node happens to sit below both
> thresholds.
> 
> Drop the gate in __node_reclaim() and always run the shrink_node() loop.
> The node_reclaim() path is unchanged, since its caller has already applied
> the same test; the proactive path is no longer wrongly gated.
> 
> [1] https://sashiko.dev/#/patchset/20260723045718.2052070-1-ridong.chen@linux.dev
> Fixes: b980077899ea ("mm: introduce per-node proactive reclaim interface")
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

