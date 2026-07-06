Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20C17C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 04:37:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD09D6B009E; Mon,  6 Jul 2026 00:37:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8796B009F; Mon,  6 Jul 2026 00:37:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC0576B00A0; Mon,  6 Jul 2026 00:37:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 82E7D6B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 00:37:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 124411C70AE
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:37:07 +0000 (UTC)
X-FDA: 84957092094.07.359957E
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf23.hostedemail.com (Postfix) with ESMTP id 288CC140002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:37:04 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783312625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WzsGa9AwEW8CUx2gO9iGJey0IZTt+J7oJSIKJ2gI0bw=;
	b=idjwV6SwZ+ctHsfued7DwTGFEN59Wl3K7bVNobNtyU0U2ECEcO45UpnSVh2vslHyOm/MeG
	qdEnqlkiZ5ezAlW3Vbymac/2icMfXbmq9wserSOjqt9WNJTyVDu2A59fhr91wmvb3kBKWv
	AZIeoKpaYjNajlzawl8hF8Ch1mdCiMQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	spf=pass (imf23.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783312625;
	b=XEC9Sv2g7EoOLF/cO/HUJcYfFu6/2Oh1oZlhaoDPBv7D4MJuYkRZnvz+/VaAQA7w5aEcJ4
	kU1ahdgjti9+KNxe6/Z9gdyWjuBlUodAlik64MOBJ3Ft/roydoGVR7ruaD016/wugApzAt
	pTXNnDSTpZvc450xX0gmYKh450L7pB4=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gts5S56Q1z8XrrM;
	Mon, 06 Jul 2026 12:37:00 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl1.zte.com.cn with SMTP id 6664athr086600;
	Mon, 6 Jul 2026 12:36:55 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp04[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 6 Jul 2026 12:36:56 +0800 (CST)
X-Zmail-TransId: 2afb6a4b30e8e48-3ab3e
X-Mailer: Zmail v1.0
Message-ID: <202607061236567802Fu8Rt3DTBwp-KSVC8Hx3@zte.com.cn>
In-Reply-To: <026e7be6-fa97-46b0-8daf-57fb890db0b4@kernel.org>
References: 20260705213758375Xf8iZzfLz92U9SASpvqTJ@zte.com.cn,026e7be6-fa97-46b0-8daf-57fb890db0b4@kernel.org
Date: Mon, 6 Jul 2026 12:36:56 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <harry@kernel.org>
Cc: <vbabka@kernel.org>, <akpm@linux-foundation.org>, <hao.li@linux.dev>,
        <cl@gentwo.org>, <rientjes@google.com>, <roman.gushchin@linux.dev>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <zhang.run@zte.com.cn>, <cai.qu@zte.com.cn>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbW0vc2x1YjogZml4IGxvc3QgbG9jYWwgb2JqZWN0cyB3aGVuIGJ1bGsgcmVtb3RlIGZyZWUgYmF0Y2ggZmlsbHM=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6664athr086600
X-TLS: YES
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Mon, 06 Jul 2026 12:37:00 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A4B30EC.000/4gts5S56Q1z8XrrM
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 288CC140002
X-Stat-Signature: mub6kak3asuxyaafhbhhjzgfbac8uq53
X-HE-Tag: 1783312624-400137
X-HE-Meta: U2FsdGVkX19/snPjfO2SxcuarYHbD9qvjwJ2FDFVu4oSFr/LNnK2kMW0ev8keHgIS70rBa3yH53ZSpxqK5dnRv3/7uJ29FflQO2orZ7Iy2axLk65GorLYCw8Rsd4t5pvv/PDoixNWlZFShtTFFvyvUdpIs3E1cuZwHQx0UF+spV1ys/jezT7SFgISa4MmJpC5NvLkrA5UVLlv23UKcu5TiLN8Je80pVLJRlI+SLsCZIA4AYpGMzhahwa6DKW6LQE903hki4rJHPNZuFBdiHeq5hqp26E4i9O6QYoY3CWowzSpATpJd5hTBFK9lP8OKxUB7RRWPHlHu0zhc3pbnTJuq2amiIFhhcidOkdhjROUsyHl/PxTHn8tTMqnJtULgfXJey9kxfDSppcxyK/QQOH5qPZH1xzhjOgJeChA5H7SB3gwuSGu9O4dkUlC4EC8BY7D7S/0XS1xhbvoPQSVWNwsOv1OiFXskXYJGlHEbyJ+sec1s8exrGOk52ythhmdTZdz5tJkZV7Ruz3W+g4HuBPU2bsJQNx0FzW+1cF/HSl9KDwa/upYSB7yoJ/ZadX/ygPKJJDNEsB1tCThKGasGp+a9JfkJ51IpywxdVLbfYKBDGnfzsu4iLJ0GasIHI0bEYiKmh9sanxAkCUuJXYZhk74ZWQ4fEiZ9JNsws2k/Z3zAyYHbLR6vf+QHUbHdvcCn0PTb30Wt0fxJM61708QOM10M5Z5yhXk+PltLEO9wUtH1PeFI0d9Qnx1gHgS0+/O33XVC6sZq7j1oyLc93hUBBZ1z0ymb/sZBk0wOyLS1wnYcztOtVyAm+f6gQ2MWNM7aHY2lMuaIyppQ8+EMtd8Iuuy6lzCo+svqW7Px7guZmrGDpgA/YsFqBIIXvhjAfk80b7qgQlz1dGgzPbaosST7YBtKb8nLepg9Sb1PAxF/ZuPhTI5oDszs7Fn38kuHWJ6/dvX1oo0g+y7E65tZY6CyJ
 utxNqjoD
 fMCksZC7p/nX98IJI6HOO5V7XA8n/ALblQ5t4YXzipBdsWU+tb0zVgJiI8HwZYzW/kjoF/Fg8FIPBWCZnIdaUaCR1/lYix7MD+CPCLVJySP6k7/QtazLIJxryfMxbkRJ1UQ30oGSyHeg5GLB2hcf8y2BcNHyieNwvtceRGClIJ6Z//sKLrFcHIhPB6HagPjay/eRZdmoPkS9r1JUMcpsk7t45nQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry wrote:
> On 7/5/26 10:37 PM, hu.shengming@zte.com.cn wrote:
> > Harry wrote:
> >> Hi Shengming,
> > 
> > Hi Harry,
> > 
> >> On 7/4/26 5:04 PM, hu.shengming@zte.com.cn wrote:
> >>> From: Shengming Hu <hu.shengming@zte.com.cn>
> >>>
> >>> In free_to_pcs_bulk(), when remote_objects[] fills to PCS_BATCH_MAX,
> >>> the code jumps to flush_remote to free the batch. If all remote entries
> >>> have already been compacted out of p[] via tail swaps while local objects
> >>> remain, the flush_remote path returns early since `i < size` no longer
> >>> holds. The leftover local objects are then neither cached in the sheaf 
> >>> nor returned to the slab freelist, causing a memory leak.
> >>
> >> Ouch.
> >>
> >> Interestingly, we fixed a similar memory leak in free_to_pcs_bulk()
> >> during the v6.18 cycle; commit cbcff934fa7d ("mm/slub: fix memory leak
> >> in free_to_pcs_bulk()").
> >>
> >> Hmm, I feel is a signal that the control flow is quite complicated and
> >> worth revisiting if we could simplify the logic there. I'm not saying we
> >> should do that to fix the bug, just mentioning.
> > 
> > Yes, this is also a memory leak. I agree that the control flow in
> > free_to_pcs_bulk() is fairly subtle, especially considering the previous
> > leak fix.
> > 
> > My intention with this patch is only to remove this problematic path with
> > a localized change.
> 
> That's fair!
> 
> >>> For illustration:
> >>>  size = 64, local objects at p[0..31], remote objects at p[32..63]
> >>>  After scanning all remotes: i = 32, size = 32
> >>>  p[0..31] local objects are dropped.
> >>
> >> I can see that could indeed happen.
> >> Interesting. How has it been undiscovered until today?
> >>
> >> Well, for this to trigger, at least PCS_BATCH_MAX (hardcoded to 32)
> >> objects in the sheaf should be from remote nodes.
> >>
> >> Looking at kmem_cache_free_bulk() users:
> >> - maple_node has sheaf_capacity = 32
> >> - skbuff_head_cache has sheaf_capacity = 28
> >> - panthor and msm drivers have sheaf_capacity = 4
> >>
> >> The capacity is (at least for now) purely based on the object size
> >> (with user-requested capacity as a minimum)
> >>
> >> Only maple_node cache (out of four users) has
> >> sheaf_capacity >= PCS_BATCH_MAX.
> >>
> >> However, for this to trigger in maple_node cache, ALL objects in the
> >> sheaf should have been from remote nodes. And that means there is no
> >> local object to leak :)
> >>
> >> So, although the logic has a leak, you cannot trigger this in reality yet.
> >>
> > 
> > Thanks for the detailed analysis!
> > 
> > Yes, this was found by code review rather than from a runtime report, and
> > I can not verified it with an actual triggering workload.
> >
> > I agree that it does not seem triggerable with the current users. This fix
> > is mainly intended to make the code robust against possible future users or
> > changes to PCS_BATCH_MAX  :)
> 
> Could we have these explanations/analysis above
> in the commit message please? :)
> 

Sure, I'll fold this full analysis into the commit message in v2.  :)

> But yeah, we should fix this.
> 
> When fixing a bug usually I prefer to go through the process...
> 
>  1) Confirm the bug exists by reproducing it, and
>  2) Confirm that the patch indeed fixes the bug
> 
> But this one is impossible to reproduce, uh.
> 
> In this case I think it's better not to Cc stable (which is already the
> case). In case there is an error in the analysis, it's still
> straightforward to backport later.

Agreed. No stable Cc for now given no known real-world trigger path; it can
be backported easily later if needed.

> I will double check if the patch is indeed correct.
> 
> Thanks!

Thanks a lot for reviewing and double-checking!

> >>> Replace the goto-based flush with an in-place free of full remote batches
> >>> during the scan, then resume processing the compacted array. All local
> >>> objects now go through the normal fast path, and the tail path only
> >>> handles any leftover partial remote batch. The redundant next_remote_batch
> >>> jump label is removed as well.
> >>>
> >>> Fixes: <989b09b73978>("slab: skip percpu sheaves for remote object freeing")
> >>> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn

--
With Best Regards,
Shengming

