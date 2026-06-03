Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BF4FCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 10:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667EE6B0096; Wed,  3 Jun 2026 06:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6400C6B0099; Wed,  3 Jun 2026 06:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 555A46B009B; Wed,  3 Jun 2026 06:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F4886B0096
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:49:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CB60D8D162
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:49:32 +0000 (UTC)
X-FDA: 84838280184.04.71B550C
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5D6B4C000E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:49:29 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ScXU1HIM;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780483771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TLYJyqwKkUcNMrBAucL8IXpz4weTpeaecT2LNBkzRw0=;
	b=BgH0PMswijV7bZBdEgxxU5E7G93Esu4ckzvw9P3oARgmA42NrTXoZYALNAwnmB7WyUvdeA
	do7L9cjiURZ94ORXMocNt2noVc9lmP6oFOwsQqKRYtBpMaH+ibkaPDkxHirurLN0VbquCq
	3Na1xggbsz3Xqx/TsRWf98JtAaNlgsI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ScXU1HIM;
	spf=pass (imf22.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780483771;
	b=mANN7EaC1hwsc0bmLpF+bbQK0/M0bzabtu1eeqKCeCZOmSWXjWgkVJ27olIpiyK5cRQtLr
	EUb8cD3Gp/uHT+944DkwU4t6jt5+nkldqnEPdxGA8/4CyxxXzuMztPryF9+VZ/O0iBqoCM
	wYr+RzLh8i/AeNBVO6D7O24ZA/2US28=
Date: Wed, 3 Jun 2026 18:49:16 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780483767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TLYJyqwKkUcNMrBAucL8IXpz4weTpeaecT2LNBkzRw0=;
	b=ScXU1HIMbFTBD9ftL/fmOlkwZHti+12s9b8SIKCfUCarsObADaSm9fsZXeXisHszykxXCq
	rDMOaKp9N3rkq6mTSgDVIisL4Ua3g2Y28244JjHItJ+ocwtRaSncbBMi+X4pwi+VqTu208
	Pe8E7+dl3acnJyXDYeWfq5zU4ka0Vy0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: Jianyue Wu <wujianyue000@gmail.com>, Tal Zussman <tz2294@columbia.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mm: move folio LRU code out of swap
Message-ID: <aiAGrJsNm_uAf1qu@MiWiFi-R3L-srv>
References: <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-0-5bbb567f8c99@gmail.com>
 <20260602-ch-swap-series-plus-folio-lru-cleanup-v3-2-5bbb567f8c99@gmail.com>
 <ah79c9IIuXt51ybs@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ah79c9IIuXt51ybs@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5D6B4C000E
X-Stat-Signature: xaopa8717wozbicpuixcq7uqxapepshn
X-Rspam-User: 
X-HE-Tag: 1780483769-526848
X-HE-Meta: U2FsdGVkX183f4n8U8ebPJXlnDEClPMvmOgRGaq1rUcMWsko93uzu6qQOtYbuGjCdcs1yOeLz8GvU2yr129s0sAXTO3LCym8v5HbT2PD4fWHntTX6Uy3ZRPV7DdEz4yx09muTZ8eRj+ky1H2hj5OhaKGSuCCtIwhy8IKljj1lBbm7R/Yf0g1dW8BJTK1BX+xiFtk6j6a6aruh/+/QtvZ+r28dogy4a1NFlB2ihZStRvyjYuQzSOxbjwmJTJwpU0OjzqrHnmNJPWjeFVsEsLPlxZQ1p5hm+4IIWVO8niVMkPy6oIB4lWmKawbQ6BQCoEWJQ58arHAdsc1PE7v7IcZbIkDqRMgnlspr0sCOm2ApeICYgRPsRB7r2ptYj96dwHg0wS9uw3h2AtDRw1DvwKlVAqOWvy59YZqsvWEeGX7ceVkb7TM4qrrFCbW/mtV0c2pZFRxD6YgyYcyEI3eI9LX5mzJvKOT2IiVhLcpVl08J8gjFVXykfbkdECeX4xHIArNxmxTven7tVxPWM4VXyUlCKHlh5IbE7CcsIHauBrA/C+z/L5haKBnsQPt6jkm1sDeU/2lxy8a0SnhSqTFBzhw34YeEkpoAw7Mi7rfBPUCRkVhj3iVp32G6h56Vdfmm1L63FL2x9WTG50EtTW2zWgpcKEf+D3W0Y1ruD1eK+/oMzap9F7zyJxrWmfy//8kxCHbgbUN+vGcqHzGWrnYi9x6I8zCbsxB9SwDBR/UvhwMso97wcrVKt+H942cQlcQnWrWdG5yps5sYXoi1PK0/EngGMqcpgM5CffsHwRz2btVxoGXVT+JNB+Ej2HU1JWv4R8Oidf7Bzls8VVgFfAmnSH7AyrV3GYn6KgujvTwY/ipjGE9McIEXAA2csJC/ZLWdtlqLvf+KnvUaURlU4lkwhKkaD/vSNL2UDu3aJWTj/coi6bY2PhE8rBpeaYrEibowI9RlVY8HW+63Dsyi3jyRL2
 mgBg7svV
 WOUs6ubasjtIhRi2fPAWAb6gyW6PFxTnU1BJ+wF6eAXJJOBN0DMqQlYDW2YL241brTRvO6+DcpCaYUIAeT8OpkSLcvhdPKhgQa4Wy6L40l7OTWx4ZEcUb2pdLfPl9Aic68D/xdpC/ILd+2NqyJEWhVlAjErtuoiheYHIIYc0HGs9fWmPdvrYtcwVX9AGjh31oO4Z5f+plCHDPbdGIGBlPdP2jSiR+d7ERA0+mF9Px5YhqPj+lx2qWVFE1PXakV6yTsCAY1S3hieMaIbZMHsKP21SSaA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06/02/26 at 04:57pm, Matthew Wilcox wrote:
> On Tue, Jun 02, 2026 at 09:01:16AM +0800, Jianyue Wu wrote:
> > Rename mm/swap.c to mm/folio_lru.c so the filename better matches
> > the code's main responsibility.
> > 
> > This keeps the implementation split from swap-specific code without
> > changing the published LRU helper interfaces.
> 
> At the same time, we have Tal trying to split folio_wait.c out
> of filemap.c.  https://lore.kernel.org/linux-mm/20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu/
> 
> I wonder if instead of folio_lru.c and folio_wait.c, we shouldn't simply
> have folio.c.  Tal has 700 lines in his diffstat, you'll have about 1100
> lines, so that's about 1800 llines which seems like a good size.
> There's some functions from mm/util.c that would fit nicely too --
> folio_mapping(), folio_anon_vma(), folio_copy(), flush_dcache_folio()

I think folio_lru.c and folio_wait.c are better than a single folio.c.

A single folio.c with all of them would have no clear boundary for what
belongs there and what doesn't. For comparison, page_alloc.c isn't called
page.c (we have files called mm/page*.c).

> 
> Other people have thoughts?
> 

