Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13861C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:29:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D35C26B009E; Mon,  6 Jul 2026 02:29:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE6106B009F; Mon,  6 Jul 2026 02:29:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD4BB6B00A0; Mon,  6 Jul 2026 02:29:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 94AF36B009E
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:29:53 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1E2CBC19D1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:29:53 +0000 (UTC)
X-FDA: 84957376266.12.E9186B4
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4E6AEC0002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:29:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qO+jFkbx;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783319391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3XQkYBnHZWsJpiyDF1oAd+8WYbBHmcQTchDtP++ibmA=;
	b=U4Ae+uBrDoZDw4kD99tmQvYbRHpxoxsqF97KlNy3mAyehzzMu0KRmtzHKP9wR6+zAhmw2j
	u43x4UZM/H+iTAp4R4AfGDMaPnzrtUh+fOQHhFOh1Ji6jcl6fDD37/wFmmMuO4ER9HLjIc
	6OIUYJ51oP4/qrGOQ+gzd8Gw3YBeRYw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qO+jFkbx;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783319391;
	b=hdJWy7QJxz7v3VnkeQZ69UJlcZzNyuMyYfqnMXo59IlBFvBQC64oLzJzfh6ickDLt+uC9h
	6jz6k6n35/qcZQ4Lkn65wPYFsPsts2Xq/lt8HAvaz+LIRqc1W+xHXm8vIMuIVDryXcZ+Xb
	bgm/iw383Ul7nr5pYY428GWk6a1PCkc=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783319389;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3XQkYBnHZWsJpiyDF1oAd+8WYbBHmcQTchDtP++ibmA=;
	b=qO+jFkbxMfLVNFyOyT2C9xJgciesprCRI0aNzSsDeA8+DQP2vHUY0p5odBTMJos6gjXI9V
	HrDYMBdGGGXpwhGk1avVIz1/LnmEqiz9JlOg58JJpRgMtu7X/y9H8b/4BcPnJuh2HU4AAi
	RaL1ZpF2wvW5pAmsGODfbpAWQzFSVG0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2] mm: memcg: reset zswap settings in css_reset
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260702024827.353185-1-jiayuan.chen@linux.dev>
Date: Mon, 6 Jul 2026 14:28:54 +0800
Cc: linux-mm@kvack.org,
 Jiayuan Chen <jiayuan.chen@shopee.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <152D4FB6-5540-476E-84AE-AF463929F2B2@linux.dev>
References: <20260702024827.353185-1-jiayuan.chen@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4E6AEC0002
X-Stat-Signature: iqjsmmz1t89wj9mcys85crh1c1pz7mge
X-HE-Tag: 1783319391-603330
X-HE-Meta: U2FsdGVkX1+jUjQ6nys/tVa4iMDFJYwl6q2XW1NzgETJxObcv/c3QOVhatkkZn9jsAsHXaUb9h9/CYNXWShGfQ9/FSLgsqRXSSMTM4KsBWINZ1vdDvfbM+PqlLRi2NbkzVh2hcMBWKHsHrVx82uOMaEu7h0fWx6qPLXRi43ZPEp0ndfmm5FKtrH1opK+uFHjg0KvOP6Ft+knRv1lbYpWsNPhr1Cj2JSoC2G/KwvUhkn9wSTEZv2nCF5xPAy4wzMJP8H/yGop3HCecGXifSr2ZdJ0Ybr1X0AfCmwdbSVoQrlBmOcrrox/hcNlRmbelfyMRA8f+McLsZnlONAY8TXeCtMbLGksGPjSYTMUm83c2msjBtJe3KxzHAEfMe9YfJYOV0uAaRwWiFlgDjXk1qwCeP8+c5G5/DvdppA68SzO4i4r5WGEcbd1C2RTCOBOWaFvyf0BKJn+DS93yu462fy1i5eP1AdHdgd5at4v3R0YEQsC4HkBKjjqc2WUp7+TrN+pcEdty6A4zWfvPxl+uNpSOwUPGvN4BcpneFQzK1OPqmnKbDm08z0DTEimTCstFWEfM6Ow6B0KLjYe+mu03A9nvcpl/UaqnrPl2R/KT2kVNvPrOXLAcg/yTcrz7TOpY+24OxHWKXPUBKFXlv/60zOnp4T6iVHwB5l4/BDKxC5pemk2xCGw9I/17xLVGNrW+16r2i/1w6Ils5mDpKPF/AZpJoDLsASSO3KUN0dLeyt+9nag9/S27WsQ1xOV29aqh2b7RHgvNUgWaFt9pkl2TdJGie5Tp4BE1v6YYeWDOKSa0npU3HkSL+AUI1ykFNKGIq+qeNpDIPZJtV30lIGdSudBZYkZaFBpJLNspMcMcrIn4XziWIBTh2FRpOkyNe6XggQ7vHgadTYY9cPBDmJRu5rBpgJvmFHra2BU1a4q4iY8YMaDPjgC8KCejvoaNJPvcnbxXNmSfR8kebfKwpA3CnB
 pph+0m3i
 UlFTCj13L0muZ2yfybWFuPF7iTFq+i4WtBDb6NMJLJqhuL0bI6mcQ8gUmVXJ0KP7Ni1Es6HizOHnVvGkooGGYk3z8Rmy2kFcurqLOWW4RPBPJ59qJx12Tk2WxSxvFfhqsBGidG5p+lnDMNpiqam850i1UAslSNMl/qa1b/ZXeEGqdB+UCWMjHGUyDquNSkbAMqXjQWVsyHYTjvKtDWyJE2HpoQYz1xs8FnOnQpic4eHiuZ67ihFcZG7eDIUfTczBdwyIPrrEzlRS3VWsVpx1XcYZzkyUpnW6abzLbOjjSuLdCOx3xMUELBBeiUnpHBimTceEoq1Z3MgIE9R64l9XdWwHDjg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 2, 2026, at 10:48, Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> 
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> mem_cgroup_css_reset() is called when the memory controller is disabled
> on a cgroup but the memcg cannot be destroyed because it is pinned by a
> subsystem dependency -- for example, the io controller declares
> .depends_on = 1 << memory_cgrp_id, so memory remains in the cgroup_ss_mask
> and the css is hidden rather than killed.
> 
> The purpose of css_reset is to revert the memcg to its vanilla state so
> that no policies are applied and the css can be safely made visible again
> later.  Currently, all page counters (memory.max, swap.max, kmem.max,
> tcpmem.max) and other limits (soft_limit, memory.high, swap.high) are
> reset to their defaults, but zswap_max and zswap_writeback are not.
> 
> These fields are initialized in css_alloc (zswap_max = PAGE_COUNTER_MAX,
> zswap_writeback inherited from parent) but were missing from css_reset.
> As a result, stale zswap policies remain in effect after css_reset: the
> zswap charge path (obj_cgroup_may_zswap) continues to enforce the old
> zswap_max limit, and the writeback path continues to honor the old
> zswap_writeback setting, even though the memory controller has been
> "disabled" on this cgroup.
> 
> Reset zswap_max to PAGE_COUNTER_MAX and zswap_writeback to true, matching
> their defaults in css_alloc.
> 
> Test:
> echo "+memory +io" > /sys/fs/cgroup/cgroup.subtree_control
> 
> mkdir /sys/fs/cgroup/test
> mkdir /sys/fs/cgroup/test/child
> 
> echo "+memory +io" > /sys/fs/cgroup/test/cgroup.subtree_control
> echo 10000 > /sys/fs/cgroup/test/child/memory.zswap.max
> 
> # child/memory.swap.max and child/memory.zswam.max disappear
> echo "-memory" > /sys/fs/cgroup/test/cgroup.subtree_control
> 
> # re-enable memory control
> echo "+memory" > /sys/fs/cgroup/test/cgroup.subtree_control
> 
> # before this patch
> cat /sys/fs/cgroup/test/child/memory.zswap.max
>    8192
> 
> # after this patch, same as memory.swap.max
> cat /sys/fs/cgroup/test/child/memory.zswap.max
>    max
> 
> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


