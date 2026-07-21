Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5DAFC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 09:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AC3A6B00B5; Tue, 21 Jul 2026 05:26:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 983B66B00B7; Tue, 21 Jul 2026 05:26:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C3426B00B8; Tue, 21 Jul 2026 05:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D7D76B00B5
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 05:26:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C7824A0467
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:26:06 +0000 (UTC)
X-FDA: 85012252332.28.08164CE
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf19.hostedemail.com (Postfix) with ESMTP id D98191A0003
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 09:26:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JGeNhTOH;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784625965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vB+JRQVHlMG5MWvo+GPIUeB91lIMDz4d0A4B5NQYUB4=;
	b=LbCkGjto/uX9rFbW60wxO5EHedI6v/XsFVz9eXcERsbNe6H+6GNsGMbvsLKxd3jkZOZVH+
	BhdGi8BLByYfxbSdvSbMnKheneWR6Ue2kFQIuRbOPcVhHRWGrtLlm+FXRBOoayb9Up59iR
	9TVWBqjnOLdQdlNUvry2OFm6fxOp5Co=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JGeNhTOH;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784625965;
	b=1cmoGaVjtdUqNb3JayvCAsvmytqGa1kC/7PGYeNNM+BqIrTD0ZG7H0iOSMuH0hzTnrBrB9
	EHQmIXRxjWND5zBV9MEEtzeYSnvwkbW2odhxc8iQ2dDAvMvz+P1uoCfMH30WcjyctogR7o
	F55FrsuRWy6Mfr38yvGxAEBz0kJhuzk=
Message-ID: <c64a1eac-4127-4774-bcb7-b386860b2924@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784625962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vB+JRQVHlMG5MWvo+GPIUeB91lIMDz4d0A4B5NQYUB4=;
	b=JGeNhTOH+a/B8Oj13NkMY6wxt3WLgc8dgCHmbJys6SpwisQ/le7wFr9agOxoaW6+Aduta+
	tuFCGwosAbVWHQk/vdTBCkc7GdTxl+PBRWiLRQtxtUijnQZ1Vbgjy66bC0j5xgr+HF2A4S
	2R6uYsF7mCYhDyDLEpPzu01CNTwjQDM=
Date: Tue, 21 Jul 2026 17:25:37 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] mm: shmem: make unused huge shrinker memcg aware
To: hughd@google.com, baolin.wang@linux.alibaba.com,
 akpm@linux-foundation.org, usama.arif@linux.dev,
 Qi Zheng <zhengqi.arch@bytedance.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <cover.1784621804.git.zhengqi.arch@bytedance.com>
 <889581093179462979dbfb5458620fcca531787b.1784621804.git.zhengqi.arch@bytedance.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <889581093179462979dbfb5458620fcca531787b.1784621804.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: D98191A0003
X-Rspam-User: 
X-Stat-Signature: 67jye8qyixqy3cuziq6iwnud8h7yb9bn
X-Rspamd-Server: rspam04
X-HE-Tag: 1784625964-89751
X-HE-Meta: U2FsdGVkX19xueWDlGuWoB+guPiVxR2JpnsILQMzc9eLn6/oppagt8Kib3esi61tnkEiptEfsmJNS8w57nrFlM/FiMOO2A6Ee/rsIqWjEe1P+x4tjvsfLa92zIdJdlloLPQyMuhI7B5MbQ8vq9d80m2tcbAmFLBCbrFpBevTG9YHeW0bgK/Ie8ia9rRq+6cxgZYXCgMY2gtU46etdiYbAb5BNI88/yiWhyU8W0Cf755dFmcTNC1BKPzQXJS19nhjzTQmVhhNkxVh0EeTOdRl3TkThGcS+aLlDZU/6pJoF/pXtX0QNNYlv5yD0b8NjJtBpZZJ1Otfd9dUnOSpGIBILYrEZUziGjLsCE6YN9IAyuKWvMzviIRfHT4xD6C3sCfv+mcCmpQ3iNf8g9X5FmpuQFr0ptlQ22qkgsrCHHWmTmwhDq6rQ2nw9JK8zv2ZHGN1sQK4VlaOEAVdNxeJnVM10JuNpClGtvysmpo3fYWmZdT3EUZ9B5QFr7RPZrRUxKVJd5UviBZT0R7fSGGWTr4WqwPp/kVqUGm1/73Z3skHwGPMD9RRtdOI4zcO1NlfIQ80YmA3IKFwFZzjKMU2CWba+qeKgjgnyNv4tVe83xbY48xsDRfAvVnvWOUWP+/tG+zQB+jldu7fKrpLznkhc8L92XqTBQUbHvbeyxZSAB34i0w4dosW/7rM+usfAiceUoS+v0BgZUsFmJ+N4AnqZLSrAYahJULNSLFGawvUWWRV8eVBdE0apS8CfIQRpICtImCXk0FtLqrNntKttlCtti5qvHKMcMltOgashYr2/fRbRzEGTulafSrW1baD6VwDma4vhbyMiiwytxBxhuyZqA9gjINppRf2TNPRAGSJI0HzszQvz8iG+P1TN2zbwk+dF1X3mPeeJHYfHHtS3VzA/m9nLXP9vs+bVIMi2Yh2ZqndZ2mHV64HHCbm9nROpIuOqgsWIguALehPNUaw03/afsn
 DnftNh5+
 DKdkyAcL++xrP1S6hM0B9mwjFEe4+ZuRS0gB+K67h0j9MmOUeLdRajkUirIHfYvimIjxfQZBuW6Vyk4ya0NN/M6iyn4z9ZN65zV+Zb4xyqw2bIMs46BovKMr28sCws6wUomR2A7mEd2Er3q2JuihvtUZ6IWqU4eRglzTFn6TwqLru02dYUS4tQRqB7FC4GMeTBDNx9MMEusm3rmtsWjbPERR/Rp/LhFUXbbCNVHghHmhIcBdQ5qcC4f9g091roUox2JVMvgf7aifRUVFvZ15HB1XHGOgHrl/nDJTC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

sashiko left two review comments about this [1], but they look like 
false positives.

[1]. 
https://sashiko.dev/#/patchset/cover.1784621804.git.zhengqi.arch%40bytedance.com

 > > +static bool is_shmem_unused_huge_match(struct folio *folio,
 > > +				       struct shrink_control *sc)
 > > +{
 > > +	struct mem_cgroup *memcg = NULL;
 > > +	bool match;
 > > +
 > > +	/*
 > > +	 * Only non-root memcg reclaim needs to match the folio charge 
against
 > > +	 * sc->memcg. Skip the folio memcg check for the following cases:
 > > +	 * 1. shmem quota reclaim (sc == NULL)
 > > +	 * 2. global shrinker reclaim
 > > +	 * 3. root memcg reclaim
 > > +	 */
 > > +	if (!sc || !sc->memcg || mem_cgroup_is_root(sc->memcg))
 > > +		return true;
 > > +
 > > +	if (folio_nid(folio) != sc->nid)
 > > +		return false;
 > > +
 > > +	memcg = get_mem_cgroup_from_folio(folio);
 > > +	match = memcg == sc->memcg;
 > Does this strict equality check fail when a memcg is offlined 
(reparented)?
 > When a memcg is offlined (e.g., a container exits), its list_lru 
items are
 > reparented to its online parent. During memory pressure, the parent 
memcg runs
 > its shrinker, making sc->memcg the parent. However, the folio remains 
charged
 > to the offline child memcg.
 > Consequently, get_mem_cgroup_from_folio() returns the offline child 
memcg, and
 > this strict equality check fails.

No, get_mem_cgroup_from_folio() should returns parent memcg, not the
child memcg.

 > > +static void shmem_unused_huge_requeue(struct inode *inode, struct 
folio *folio)
 > > +{
 > > +	struct shmem_inode_info *info = SHMEM_I(inode);
 > > +	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
 > > +	struct mem_cgroup *memcg;
 > > +	int nid = folio_nid(folio);
 > > +
 > > +	memcg = shmem_unused_huge_alloc_lru(sbinfo, folio, GFP_NOWAIT);
 > > +	if (IS_ERR(memcg))
 > > +		goto drop;
 > > +
 > > +	spin_lock(&info->lock);
 > > +	/* Requeue the inode to shrinklist */
 > > +	list_del_init(&info->shrinklist);
 > > +	list_lru_add(&sbinfo->shrinklist, &info->shrinklist, nid, memcg);
 > > +	info->shrinklist_memcg = memcg;
 > Can this cause a livelock under memory pressure?
 > Because the memcg match failed in is_shmem_unused_huge_match(),
 > shmem_unused_huge_shrink() calls this function to place the inode 
back on the
 > list. This attempts to requeue it using the offline child memcg.
 > list_lru_add() transparently routes it back to the parent's list, but
 > info->shrinklist_memcg records the child memcg. In the next shrinker 
pass, the
 > match fails again, creating an infinite requeue loop during reclaim.

No, shmem_unused_huge_alloc_lru also returns the parent memcg:

shmem_unused_huge_alloc_lru
--> get_mem_cgroup_from_folio
     --> folio_memcg(folio)
         --> obj_cgroup_memcg(folio_objcg(folio))
             --> objcg->memcg  /* reparented to the parent memcg */


