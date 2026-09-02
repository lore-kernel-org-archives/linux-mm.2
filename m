Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F435C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74AAD6B009F; Wed,  2 Sep 2026 11:33:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FBDF6B00A2; Wed,  2 Sep 2026 11:33:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 639096B00A3; Wed,  2 Sep 2026 11:33:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3992C6B009F
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:33:49 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C15E21A026E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:33:48 +0000 (UTC)
X-FDA: 85169217336.16.55E056E
Received: from mta1.migadu.com (out-61.mta1.migadu.com [95.215.58.61])
	by imf08.hostedemail.com (Postfix) with ESMTP id 9A8C4160006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:33:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eG9ZZd+o;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.61 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788363227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pCyolZ/whF9oLvOPT9S5DtqhKfGmHas5NfUPYiKjRVM=;
	b=mMJ6hXKk44IqcJzOutH70kqIln4KMa8/EFktRG+pjYmAsPuimXzF0z2VSqFHdZE6t34wwU
	KV8K8waXpIxrZK/etoaMXCaAXv/Ccw88O6F0swnUtbo+CmaOzYo8sf7SoQ5uRMKO43i8K2
	QoZkPyxz0wVHBcKVQfhjlW/IIQoJ9+o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eG9ZZd+o;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.61 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788363227;
	b=t1vM3d++z6/ISdDu80sB2T5kZXkkTWO8/PjhIKa0f+ipDM9GI+PFXtxrr7qcHOjpk1DvCR
	UfKGCI5/IimvaQURGrhKiB7gxdxaCBU6JsW1Ly/WWPry09vjfz0v31j0Q0E3TH9FxydQQv
	KToaRpEDXvmkXex3w3TaEPL/i+6grgc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vbue5OyW55xGQwmYa8CPdbdplvj7VE/wOjx7vybY0CY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788363225; v=1; x=1788968025;
 b=eG9ZZd+ocdwWvXP0bufWDzDPW6gl+Y/nkYvanXXmhQ7YciNhsBmIG076vqFPpryeKsMyOSVw
 gMxtmpihWEjLrIYNWrtL7w/lHcIGLs24bpPHmI2ryqIX0/u0V39j0z5MUhuLjRkp3TB15B+Hj2M
 wnHmeiC4916zqo40OLGQHR78=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9ae62829dd25829f;
	Wed, 02 Sep 2026 15:33:45 +0000
X-Mizu-Trace-ID: 9ae62829dd25829f
X-Migadu-Flow: FLOW_OUT
Date: Wed, 2 Sep 2026 08:33:43 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org, 
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, 
	brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, david@kernel.org, 
	qi.zheng@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/4] xfs: remove dead kswapd flag inheritance from btree
 split worker
Message-ID: <aphBvsGX1op31Nwp@linux.dev>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902131653.1338227-2-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902131653.1338227-2-wangkefeng.wang@huawei.com>
X-Stat-Signature: 4udiozo516xhw33fj8hotkwebr3bnx4e
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9A8C4160006
X-Rspam-User: 
X-HE-Tag: 1788363226-302378
X-HE-Meta: U2FsdGVkX1/8pTCXIqml0Zi5LguF5saqbcFhf5zG1QY9zF28/TuEERJDDszq02bUMgJp2qajqBwmp1GX1IvQ/ADnRmcL5dhpo/vfdHK1quQlHonQ5/3BcmrLA7Y3Nt3QkZSX4AZSrTzsBBIbYoZqWJeRh86nAN1FkZNS2C2RicNLRsivJgewK5SjYu/lsvss6Q9YfKbWIOs5UO4sFWNRxE20++YDbCvh8cct5yEncSdQteX/UihUlBCqvMOkTuZ/seKIiKnom/Cx2xLv0/orzJrtAKPTzRAHxO8L8ZddExsmvlkuhKyM6pKxpP2gGIYEUgYFkt60Jd9DmcBs6UrR1pwBE9eBh4FZ+vppfj0IJbKaIbcqBEMYNBkmawTGpmEikdn+DyHkyIYxuy+LJdhxZdDX41ccGblBY/iJOLRvlpwZmhxM20gqeKoWhaTNagch2EPzZ8I+b1PTu7bcblNq2oHNaUsRUE6ywyPB4wiv05LrVCcwdx2QOcW1vPQcX9ou+sR9tO801e9hOHsKKdzjQvWBWHPuzxnkSiVEprf7PMl0Mjyic8WWEY/I1alRlLUCluknASeqIl6jkETlDE8/mkhXmXLI3o7DM2mvqcSojfR2QVeOgNKNqNlESpRGDpN8TFKhSYQImBQugIuoCkIBO4eS6dJHdZ4GS7k+6itmHLkKThKskhCnunQrTvRnD4NH5YYUQmV3yeZHgFkVbELJTJkQiT/UmQXC+xCyL/N4aIgA/pHTX9b+wzTN+HgawTOH9tUpFmY/r2sdjt8k7jAnyw1Y4X67DQCzAC084TlRiC88hNmvAw6yVmV5O0YG1/PDPhJgSpyi0W5eCeYyQUenD11g3Hhk7e9JkCCyMDXMYknYEywJf0jpgPYS0Fy5na5lj42aurUb/fQzILfqwqw9sE8KNGEeNkaOcJYmgwPWYfsHfKNOxHLu3ta/JLvgSoENvm3Ma8pb1MWYe9egSn2
 ucZt+UXS
 e8huHDv2jiwHDGi1nTmpCiLYLKem6sX1l7RwL7zEpO23qk4G0vEkuxTZiAk6noGhXs5GYACoJ7mf+4Gc7dgrRTh/FiitXPGoZEVwDgq6O0oBXF5fX5CUlzHKUqqN0PZSJMDBMQFueRUxBEUe89VEpABHKpT0oH2MnBlvw5IXfKcBooU2nJJOapqh2vbLUrnmcvV2yrFxQp0vjI1QuxOAPOrBHLRpw3oodnWUgUeHJIodf8Er4r89SkCd5ABafHPlRbP1rE4Ecphh3aUQwbkGVsnHTkM61VFNLajDyh/SErxch+qhuW8ngqAdHH7L+OP+RrZcr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 09:16:50PM +0800, Kefeng Wang wrote:
> Commit 1f6d64829db7 ("xfs: block allocation work needs to be kswapd
> aware") added PF_MEMALLOC | PF_KSWAPD inheritance to
> xfs_btree_split_worker() so that block allocation offloaded from
> kswapd to a workqueue thread could access emergency memory reserves
> and avoid reclaim throttling.
> 
> pageout() no longer calls ->writepage() for filesystem folios -- it
> returns PAGE_ACTIVATE for non-shmem, non-anon pages.  kswapd therefore
> never enters XFS writeback and cannot reach btree split.  The only
> path that offloads btree splits is unwritten extent conversion at IO
> completion (xfs_end_io -> xfs_iomap_write_unwritten), which runs in
> a workqueue context where current_is_kswapd() is always false.
> 
> Let's remove the dead kswapd flag and related codes.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Shakeel Butt <shakeel.butt@linux.dev>

