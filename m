Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEBE4C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 13:22:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D37D06B008A; Wed, 26 Aug 2026 09:22:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE5D46B009B; Wed, 26 Aug 2026 09:22:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFBFD6B009D; Wed, 26 Aug 2026 09:22:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9447B6B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 09:22:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 15188140379
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:22:10 +0000 (UTC)
X-FDA: 85143484020.29.51745FF
Received: from mta1.migadu.com (out-152.mta1.migadu.com [95.215.58.152])
	by imf06.hostedemail.com (Postfix) with ESMTP id BDDD7180006
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 13:22:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CVvqQQM1;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.152 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787750528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZfJ1DEJgA9xHP174GM+zD+DDhRxQ3ktuVvCLdq3Www=;
	b=oMhkf2dfukg1JTs42ezPu8UurHhF1U1tc51zHiEmkxNnveQbMrmI4i5cxPFaUwKmSDLAqf
	GUIEch5B+HXso3HveneeZdNqCsPta3h2rx3EFKsgUvQsw4bx+hY+PqH6Z71x8sLsO+yZPJ
	/7LMo4PsRnRnr61zCfFR83iKSxXB3jg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787750528;
	b=GKc23nykcxyrQ4VbXg+mKsXSzOjfIKpMBCoUhkp/lF3Hp51uK6sYgEpegRPJjSuwlYcjJr
	aLjdx1062TKU5aOd+iicDS795AGRoUGxyqog6ROOqKbZPcYi+nR4oqByfKfImkjV1NP+UA
	B/reAr1UzBm9aGh6ML969J16dzb02eE=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CVvqQQM1;
	spf=pass (imf06.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.152 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MbqC4/3XY2Q8MsrJW7NGpu6sTdEBe8KkMt4dCMJF8g4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787750526; v=1; x=1788355326;
 b=CVvqQQM184Jm75RDtC4a1OO4/F7nTy91v4NJKILsAAfjDf7M+JdN0EoD4RkwoK4jJsR6HVbO
 gy/aYQ9o+uksKAvOLOQ8kBPluU7m7BtlvRg/I2cuMJFO6W5nvjlC5c6fE8wMd05ep0I+a8cZzW0
 mbjh4aiJtP0Ixz0Bcde12QLU=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:19::)
	by mta10.migadu.com with ESMTPS id ee22d32ad11dbb84;
	Wed, 26 Aug 2026 13:22:06 +0000
X-Mizu-Trace-ID: ee22d32ad11dbb84
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Usama Arif <usama.arif@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Joonsoo Kim <iamjoonsoo.kim@lge.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/3] mm/swap: move LRU insertion out of the swap cache allocator
Date: Wed, 26 Aug 2026 06:21:58 -0700
Message-ID: <20260826132159.433469-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260825172604.3243589-2-alex@ghiti.fr>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BDDD7180006
X-Stat-Signature: 3rxtudxtf3xxz61h3hr3te8b7aa9ract
X-HE-Tag: 1787750527-139599
X-HE-Meta: U2FsdGVkX19r/JfnY7AwQ+JEWI6LZfKKSEnplUh+QY+BTWCsIwkbT25B0YGPmOz3dXIErEHgusebvDaoJk3XKyyxfOnToG/3zrgHJkMAGTGrJCY88EfZKg9B/KWghlfOs5iSdefZmmlIxSf4bsgB3hdiF637Y+wRL8rPM7hPDDsDK0Q05+B98QR789yKBGgt1Eh1dmge3R95Sq9vr14TUwKtUUraRq87Tpv3UL8KSrJetpf1l/9eyy277aMV5jM09DdMfyY/pGCGVfobx588xvpGM0cwVjf7reE7/qTna+wP4aiP2XdLb1Qp0gtDoLc426Tu7CEjPsIrDcPcOrxCVLhTmGy4TO47/HRSp7i2oYwPEbY6+K57MrVKGiuH7UbkI8ifOjC6BCQLBR8PoRizun6VTFooRuziXbQcFI7WBlRoq2zVhSrY1GvROVGtTri/Rf5zIFsQS0Kq+7DmQ0Cx3pKsobmWHFQlKhhjzR5nypBkKLR6hTx5+1U/hPgKp1tD6PgAXLjxKFutsCCR8uLIAYjjyCZEhqsqVs/CTzsxMyc5F9H56jwE8Vvgf4oX1O6G1eAFO051GTGjU47DRycIIpdosm4qtoYiFJ4ajGV/7sYmu2uZXpoXYmtUDPNxEq5oIwTBrpH0rfyecMo1B0zdfklkhNT3wO0CEnn4XjZWZaAmeemi9Z3MNWnoQt8WAs9wf3CffOsPsj2iRudqp1TVB4ISCAzpL0FZ1qpdkqeb4ZYlufTli8He60xi65wMNzXypBUcKcUJEnqwO6lY3i7zSEtfobBnsEPWEA6Q7XSCWSxB0KbRJi9SA74rStxmvIihQg1TV0UinXB+9Mc/SNThKbp0dJ0SPbPi8kfWej/prmai2BK+0HtmYvqHqz3GG83lenulLwMGgdpMb/vHnHkdxget2fPNhxzXMaLcwtEV+PM2dHxovPMQsJBKKvIBW9+DgdmBz6QydM0nH+4EzlX
 tqL9J7ir
 noYC305wedN7FtDxXnDIwqFQWkXQxE/0mxpNl/T90Qpkr7fJm70FyP+1ZnONmRHwUVDTvC4S6TQoSVpPmpqkyJyG5JsLkdjeHk7Cw6ESHz6LleLEk7bbxVTe0ZbD2QtPgz+XNeEV+3kPh+nL79k7PQ7ANt8BFj9KmzEcLjuCkcDUeJqhFUJ5X31EVH20cJHCYT84/eNxfcPMDfOhooWfg9GTbuwzkvv9rI2Raxr6z2BXrveR5csQ7ICsO3+s3ZHhwe3mm8YIfocWUuZus9pJ1msFjDhVsGMDd6tik5oQxClARr8U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026 19:24:51 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:

> This is a preparatory patch.
> 
> __swap_cache_alloc_folio() adds the new folio to the LRU itself, which
> leaves its callers no way to act on the folio before it becomes visible
> to reclaim.  Two users need exactly that:
> 
>  - the next patch moves the refault evaluation out of the swap cache
>    folio allocation, and it has to happen before folio_add_lru(): that
>    consumes PG_active to file the folio on the inactive or the active
>    list, and under MGLRU it also reads PG_workingset to pick the
>    generation.  Setting either flag afterwards does not move the folio;
> 
>  - the upcoming zswap writeback dropbehind implementation needs the
>    buffer folio to stay off the LRU entirely, as the per-CPU LRU batch
>    would hold a reference on it and keep remove_mapping() from freeing
>    it once writeback completes.
> 

I think the kernel convention is to not say "next patch" and "upcoming.."

Especially as this patch is in 2 series, so you don't know where it will land.

> Defer the LRU insertion to the callers of __swap_cache_alloc_folio():
> each of them adds the folio right after the allocation, so there is no
> functional change intended.
> 
> Suggested-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>


The code change itself looks good to me, so once the commit message is fixed:
Acked-by: Usama Arif <usama.arif@linux.dev>

