Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22411E9A03B
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 01:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 361296B0088; Tue, 17 Feb 2026 20:00:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30F196B0089; Tue, 17 Feb 2026 20:00:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20DF06B008A; Tue, 17 Feb 2026 20:00:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0A39E6B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 20:00:14 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 86FD356D10
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 01:00:13 +0000 (UTC)
X-FDA: 84455771106.21.ECF1BD8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id EB1B5A000B
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 01:00:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XljOV0aE;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771376412; a=rsa-sha256;
	cv=none;
	b=FZcOI/U2NmVlQ57MnbpEgjYQe4GPHRatRwmLF3B29RvlOfZJHegUVZbQAKDgjQ9oBDQOfX
	ODE23YNJwmKFN5djtrRVd8T3SoTqnW8D+w79KR82swh0J2rUZdH+My0IvAu5fy3woDXrWS
	Ih/3GdMqu1NFLPR6pEDAI81m7v4LMFw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XljOV0aE;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771376412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vwGD4+uHKmhmP60jIBykMErKbt4OCcQQaCtSSC1/n3s=;
	b=liGggC+WR3fjgaUzwV/IPl8KQoguiEpY0f/vtoJwUQoy24YoMiragKUFjFg2lFXbq59ANt
	ENFDLzlxMAMTU8UgT09HCdKMzvsE2VioLv5Oyy5GEjmLZXeady4BAEYYc5y1ZMN+bkhbA8
	ojwiNaqZRyRWbWf8siRIr867Kl0738Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 51F46600AE;
	Wed, 18 Feb 2026 01:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE11BC4CEF7;
	Wed, 18 Feb 2026 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771376411;
	bh=Zi/hbrzAQ6HD/Ca/Z25uQVxrxlf0y9pGLZODPBxVeV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XljOV0aE04c1d17L8gouamIzQUOv4O9rADZJwPc2FGF3d/Gj7epRYdtPSB/0GlwAE
	 UTXLQpAUFSOEeaos7fYLhARK42ZQq4tZ9rkG1VZyQusapyhjGcEVngQFgiUbqTBJDq
	 FdQ3Ka3hRl3Yg1q/BeNR4PSndOXFRUsNLtc/Oondetrvkk7vBsXhEkPvW7cHEFrJC4
	 adoMUL/m19u4Ldg3++TgIKNWYauUo5bGh3DJmjuBoIlUrZASYqQxrSIw+8dnacEy/+
	 E1leP4jjCRMqak+DN/XbfxY3J6A3Do5miMrpKxBeyKo/zofI44tNW7os7b16Ugi2Bw
	 d4UxZoPvveZKA==
From: SeongJae Park <sj@kernel.org>
To: Qiliang Yuan <realwujing@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v10] mm/page_alloc: boost watermarks on atomic allocation failure
Date: Tue, 17 Feb 2026 16:59:46 -0800
Message-ID: <20260218005947.2979-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260214-wujing-mm-page_alloc-v8-v10-1-bdfea431fd97@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EB1B5A000B
X-Stat-Signature: u57eoi6ftax8irkt61fusu3f7bm4o3yb
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771376411-311335
X-HE-Meta: U2FsdGVkX1+0jfCjW8Wxn8qYqvinDD3Gvlw563wh1lB59SnWAezjpfWXCTQxEYaBmTrxA+uaRZwP+ggKr91IJ8IF4DXcIOIXL247N8NH8gUVuD79qawh9TRZwU7L/GAdVf8U34XGEa5L3csxSCHS2zxaiX7ykScQwvrGrJq+BT1NOkbdCzvGPddn6I452sByieN9gFm7iwrLcbgUjYr0TlA58bNl8LUSgUSU4RutcizPt4LmY37zzrj7Q5CCfcFv1y6sHh7kJC29FGnrkWBR7z+j5d+qRkMJ98aHhDJl2AVF6TPf4CZor9KsfajmV6H2lMG5iUfNN6UiGSMa31nhiVFjcgZApvqOlHwNmlNeqmlKLSEWzbFdBQXdkuFQItdsQUcwUcgq6Ksx+Ay0T6ATNkHplFS1GpyEIjWgByqZt5TTaq3DLce7h5HiZf61wYtcb/vhnbi34UoCeaz2aD8t6KfWXTCcMEMAnoEkehEvwQEuGZiR0x73Y3oD+Ikf6obvoyLT8QddktxfFgwAjUD+ifLMen497cYFTgNvACiZxVlCSxsAGNhbH1eT07181reqfExFy0xtEdPZispBparGGKAJ4TgX0jrHPJ0Wp9ORm3MWR2ITt7na8OlPfutzloIjy0FCtGRZfPq+mbeCK3GJP7ByoK+IrkXuFOu/rI/EfE6N6LJBPRLQbfIyvedThd+TJG79jVN8hZa1It4WLh+c62hyBxHfo9jDUN5b8VElWjaV3KxCpEZCbT9gIqZtEUuTE/s+Stefz9KLEqbOY8F1y3kBPUmdQtCeX7i4NmLQmywfvA9fuhHL8s11b91INeMuU0LDdLezYhnH7NFuF+zCjmVM1PwHFNBK+UbbmAU1Mod41vLWPX9ZA7/4zuY8bE2oOlmsUvatVw0WM4LVlhCKwCp7vsPYeeVcZZtT8HMFssTOIkY3vSrKjRHPjLzCd1myBf7W0JG4BHORH4ID2Wh
 t/ddMhDm
 aNbqw5v2oqBSFi93jqLAFFdkOdgqZxxKze//OxteO6UET8+K1BOLA2YBNSNJAo3iSrh6f3/QKoPepoOpvRhbNR26OvdF1c0Ombj3JbYT9Wq9coERXUaeIu1398YyhUP4fPQur+cUO3Uaw1VsEHEdOUTnpFqx7JDvfvCJmdFl1/HBypD0EBqyNusxZz9g5wmptz+s382xNSmMTWILLdxf7IlvdxjyoXHPlD89k1VTtfWFHdfK22lgPueCKk5HQnvFgjpI3KxMWqP4qLjuTsD7vlg1rVD9dcx876BY0VK2R+92Dxp8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 14 Feb 2026 23:13:50 +0800 Qiliang Yuan <realwujing@gmail.com> wrote:

> Atomic allocations (GFP_ATOMIC) are prone to failure under heavy memory
> pressure as they cannot enter direct reclaim.
> 
> Handle these failures by introducing a watermark boost mechanism for
> atomic requests. Refactor boost_watermark() using an internal helper to
> support both fragmentation and atomic paths. Apply zone-proportional
> boosts (~0.1% of managed pages) for atomic allocations, while
> decoupling it from watermark_boost_factor.
> 
> Implement boost_zones_for_atomic() to iterate through and boost all
> eligible zones in the zonelist, respecting nodemasks. Use a per-zone
> 1-second debounce timer via last_boost_jiffies to prevent excessive
> boosting. Protect modifications with zone->lock and verify with
> lockdep. Integrate the mechanism into the page allocation slowpath
> specifically for order-0 GFP_ATOMIC requests.
> 
> This approach reuses existing infrastructure and ensures emergency
> reserves even if fragmentation boosting is disabled.
> 
> Allocation failure logs:
> [38535644.718700] node 0: slabs: 1031, objs: 43328, free: 0
> [38535644.725059] node 1: slabs: 339, objs: 17616, free: 317
> [38535645.428345] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
> [38535645.436888] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
> [38535645.447664] node 0: slabs: 940, objs: 40864, free: 144
> [38535645.454026] node 1: slabs: 322, objs: 19168, free: 383
> [38535645.556122] SLUB: Unable to allocate memory on node -1, gfp=0x480020(GFP_ATOMIC)
> [38535645.564576] cache: skbuff_head_cache, object size: 232, buffer size: 256, default order: 2, min order: 0
> [38535649.655523] warn_alloc: 59 callbacks suppressed
> [38535649.655527] swapper/100: page allocation failure: order:0, mode:0x480020(GFP_ATOMIC), nodemask=(null)
> [38535649.671692] swapper/100 cpuset=/ mems_allowed=0-1
> 
> Acked-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Qiliang Yuan <realwujing@gmail.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

