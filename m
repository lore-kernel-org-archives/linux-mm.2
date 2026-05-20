Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00358CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 05:31:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5466E6B0096; Wed, 20 May 2026 01:31:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6FF6B0098; Wed, 20 May 2026 01:31:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E64F6B0099; Wed, 20 May 2026 01:31:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29A916B0096
	for <linux-mm@kvack.org>; Wed, 20 May 2026 01:31:36 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C613940171
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:31:35 +0000 (UTC)
X-FDA: 84786675750.14.ECE0CC0
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id 165ADC0003
	for <linux-mm@kvack.org>; Wed, 20 May 2026 05:31:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GzrO3ZU/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779255094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=w9644gpBoOdPB14uQ67yzVOzo6y2pa74KkqSttfHrQ0=;
	b=2SMQXkKY6m6/5OJZIB5ZXkEveTbFASZ4ldKWm4CtOIs+omZe1WEgGXZmLLdpHoHk/M5V4X
	ujKkhA1d8S2boacDFax+ElWOhvHDq/oYNe7Ls9qptGVvz6sUC6feaaUm723jfEMCNfKJW+
	UA0fJNPDHpAsi0FRFNTiHuMWyByKkI4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779255094; a=rsa-sha256;
	cv=none;
	b=mI0RhMFqEOgsZuxJhUpzF3/gxIkYElr/yywCpSbLmwu1oWV0Kunmtr1VRXsJKrvt3yXb4/
	YzR2osRd5INA2GjeqYzxpHzhC29JX2pcJGrIy8u4JndAdqqL2RU9IHfkcm3Z6UYcmOSev6
	yf7D7jXeWtCNFr6zXzHNOGDFPVrZwLc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="GzrO3ZU/";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779255091;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=w9644gpBoOdPB14uQ67yzVOzo6y2pa74KkqSttfHrQ0=;
	b=GzrO3ZU/2Y+tqIZ1TZ3hLZ53OwRP/Dgfxc7Xoi4ikVGmYzjrsiw/iIuHN9So5e9BWqQGjt
	E1J9Ug+2qb2K6GEbX/i9Z3UoeSzrR/WHVY57qvRldi2PqIDnL0aC/BnmernotrhtG06lcH
	Ye4abrA8khI2O+PSYOL9TKda/C8DWqw=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Harry Yoo <harry@kernel.org>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel test robot <oliver.sang@intel.com>
Subject: [PATCH 0/4] memcg: shrink obj_stock_pcp and cache multiple objcgs
Date: Tue, 19 May 2026 22:31:18 -0700
Message-ID: <20260520053123.2709959-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 165ADC0003
X-Rspamd-Server: rspam04
X-Stat-Signature: nn99nc3wtu8isqsgsde5icrbka5bkebd
X-HE-Tag: 1779255093-777211
X-HE-Meta: U2FsdGVkX1/InPMp7biEtpv2LqEelsm77tr+1GDc1DC12cFy5VGSVYVFd/x09Tx+wjphO8ZrMDXHG8v/7Zfg2jzFcunu93ttBZPQjFkkAnqbr+0eYHHItczlt7rGjs7RcNAAtCfEYXJUon8IGG2RVR4tfdZ/d1SyZTPGlnpzAMIW69BY1WNOzG/htYWHzgVViJCX7gxj8Y21BMzqymFEm4hc3NRgr0/76tULdbJkVzvEr9gVi/2Dl4a+/tm7yeK3x8WOgq0dJWzmXhXUhzYFkvW9N2YFeOBDkYviLP6NHSvc2l1fMtdvlajQBy/AGp8hWFTiPA/gN8p8Z3Y4tP5tfFN2y5vB+Ux/o0lbgbiOoBptLKfblzXgDh+JPZMJa50MCJNxsVjxbbDrKXSZo2QAxBEsxt28I16u3IQdWj3qyOocjnAnOnNIl8/dvP8Vdr+L3gzp1CveEM6fRhLJmAyVwnwRuEy9CrysrGo7ZTOUoE/r2RG/J8CaIYULf8g9t51lQPpXcq6YRc+Hb63rRh00ydf9XJ2vEsiOeNxzQKuYLSLAHfldVEAOL0LTR+gpCwa7XYIp5TqOOwccm1VTcAUE+anqxpN1+pOlMJoDX81XRbKj48PpFl+QmaM32bE2ZF67Efj2KSjtyqGx4PW+o4LRXf6SYM7BNhA+3D+S5L/pLiUVgip9+sSyol+pEfKONidhsYJ4B/ZviK+Oe8e56eHEE1BlulfJI0YEQv5jp9/AnBJdz9mtt/zezJglhbX6E6KyjA8Q2v7M91cBMW85WVGovIPgib7kt2g5ltyKod4ygBG/X6vxEOi+GxISdE9pvecL8/WdSqJUq6TsSkEMWcp6VtDLFZ70q+BbzMF/J6Tu/pc7Aav/c8APUx8YmUqZLyZk9c9BdNUruzGMDjNn5RYq4XgpfKEo4yD8yOB5lVlWm7tJb37o5gKGSDAZG0k+cmNHb0W6dL2LVg33/7NVtFB
 6FZS6Aaj
 T2tNhD8OL1LaTVa50hFlsZaJcGuSf9ihMXyMFt2jtGnPJDL+gUrqrfGt82ZB6hOTdaaDFO28jKS4X9g1FIGL0rL9xuo0dwmuZXca59uRmYMXzvZskUr4Yvi3V9thAUrodKALXSdOHVMCTzL8O0AkN0ng1ktSOzipN1hzrR33DfCdtDZn0DlN3A4n/o9qiz0MNbi4iBLPHG1hbj8Xrj1ls2NGt16cDd9zlK/xf284UDXL/vCjkOQZW2Fy6z6cCDFd5stZZ5/dWEJrV0tFHtJQlCZ4mHNDgDeW6K73zdqCUoLAXMwTj5WZd9M+n6DsbcZQv33I+8Zi7LjvinnY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg
per-node type") split a memcg's single obj_cgroup into one per NUMA
node so that reparenting LRU folios can take per-node lru locks. As a
side effect, the per-CPU obj_stock_pcp -- which caches a single
cached_objcg pointer -- thrashes on workloads where threads of the
same memcg run on different NUMA nodes. The kernel test robot reported
a 67.7% regression on stress-ng.switch.ops_per_sec from this pattern.

Commit d0211878ce06 ("memcg: cache obj_stock by memcg, not by objcg
pointer") landed as a temporary fix by treating sibling per-node
objcgs as equivalent for the cache lookup, intended to be reverted
once per-node kmem accounting is introduced. This series takes a more
general approach: cache multiple objcgs per CPU using the multi-slot
pattern memcg_stock_pcp already uses, so the per-node objcg variants
of one memcg can all coexist in the stock without ever forcing a
drain. The temporary fix can then be reverted.

To avoid increasing the per-CPU cache footprint, the first three
patches shrink the existing single-slot obj_stock_pcp fields.
The final patch converts cached_objcg and nr_bytes into
NR_OBJ_STOCK=5 slot arrays and reorders the struct so the entire
consume/refill/account hot path fits within a single 64-byte cache
line on non-debug 64-bit builds (verified with pahole).

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202605121641.b6a60cb0-lkp@intel.com
Fixes: 01b9da291c49 ("mm: memcontrol: convert objcg to be per-memcg per-node type")
Tested-by: kernel test robot <oliver.sang@intel.com>

Shakeel Butt (4):
  memcg: store node_id instead of pglist_data pointer
  memcg: uint16_t for nr_bytes in obj_stock_pcp
  memcg: int16_t for cached slab stats
  memcg: multi objcg charge support

 mm/memcontrol.c | 214 +++++++++++++++++++++++++++++++++++-------------
 1 file changed, 157 insertions(+), 57 deletions(-)

--
2.53.0-Meta


