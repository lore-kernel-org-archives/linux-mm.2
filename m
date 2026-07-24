Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD40DC531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 10:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E7B06B0095; Fri, 24 Jul 2026 06:01:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 873CF6B0096; Fri, 24 Jul 2026 06:01:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763426B0098; Fri, 24 Jul 2026 06:01:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FAF96B0095
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 06:01:41 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B7C5D1402CB
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:01:40 +0000 (UTC)
X-FDA: 85023228360.28.AA4074E
Received: from mta21.hihonor.com (mta21.honor.com [81.70.160.142])
	by imf04.hostedemail.com (Postfix) with ESMTP id A241040006
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 10:01:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784887299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9t4gmZjMRiKt3UzoYPIkJ8afQKdByBFpV8GwtCS6p3k=;
	b=LHDX+mnnmFhbIgorTsrzUtSjonSKrRxNtwk4NR6ezildE8jwjA3lZxgoM8wI0W7cu9fqIO
	94sd8RRkLgKkh0JCVUFOxS7WpdkM1CBe7qttKpx8q0Jv4cNEd8XEihIrQe3vEscGtY/isd
	g3cTyKLYpFIg26HM2EVApzx8KRDqLgw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784887299;
	b=Rhf+10Ptz37UAd0GZUDUEnKpObSobW+9w7suz7BjIKN9i77IBGPcvHYO77c/xGKvP6SLTm
	gQgnaq80vIyi9vC+dcsODDYpRUJ1LSZ4sQLO0QUeZKhI859IxSOy+SOgcuggEbNxEEPxYH
	oPB1tvwtSG/z86uza1DMkwJXramBSDE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of wangzicheng@honor.com designates 81.70.160.142 as permitted sender) smtp.mailfrom=wangzicheng@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
Received: from TW005.hihonor.com (unknown [10.72.0.123])
	by mta21.hihonor.com (SkyGuard) with ESMTPS id 4h63Rg1Sv5zYl38y;
	Fri, 24 Jul 2026 18:01:35 +0800 (CST)
Received: from TA012-1.hihonor.com (10.77.199.132) by TW005.hihonor.com
 (10.72.0.123) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Fri, 24 Jul
 2026 18:01:35 +0800
Received: from [10.144.5.36] (10.144.5.36) by TA012-1.hihonor.com
 (10.77.199.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Fri, 24 Jul
 2026 18:01:32 +0800
From: Zicheng Wang <wangzicheng@honor.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
CC: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>,
	<hannes@cmpxchg.org>, <riel@surriel.com>, <liam@infradead.org>,
	<vbabka@kernel.org>, <harry@kernel.org>, <jannh@google.com>,
	<lance.yang@linux.dev>, <kasong@tencent.com>, <qi.zheng@linux.dev>,
	<shakeel.butt@linux.dev>, <baohua@kernel.org>, <axelrasmussen@google.com>,
	<yuanchu@google.com>, <weixugc@google.com>, <mhocko@kernel.org>,
	<linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
	<tao.wangtao@honor.com>, <zhangji1@honor.com>
Subject: Re: [PATCH v4 0/3] promote mapped executable folios after first usage
 for MGLRU
Message-ID: <20260724160000.b4-mglru-feedback@hihonor.com>
In-Reply-To: <cover.1784509721.git.baolin.wang@linux.alibaba.com>
References: <cover.1784509721.git.baolin.wang@linux.alibaba.com>
Date: Fri, 24 Jul 2026 16:00:00 +0800
User-Agent: b4 send-reply (non-TUI)
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.5.36]
X-ClientProxiedBy: TW005.hihonor.com (10.72.0.123) To TA012-1.hihonor.com
 (10.77.199.132)
X-Stat-Signature: yrzzfjii51tbuupfi4sc8zyeb7xwy8dx
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A241040006
X-HE-Tag: 1784887298-286375
X-HE-Meta: U2FsdGVkX1/CGIkkYsicJjJnUwJ49Y0uKy5SlkRWf5bRjlOEhzONs2z70qF2BlC9tEAofftSPn0pd5T3cr0aUWelLqrjhmTs0PF63+u1SRTOoLue9f1b+sAT7GDKcSKwvTTHhhD35jpnRZ85/niVQyfJXN2+X8puSbAXoIvFzhZs5g6Lxh9ggBxOmIMuDXbAWYbzsVW9qY5Y8nLudThhkIJW8yTu2HR0tjTEmXLAkN1Wr8qHm0IB4TK+NbABpjMx/2FrJzukhAGHXOwdbatbdRBXIPrJzxLQCCJM+4/ywPoPNpu2hbNNFU8LAAdrBAfNEY+ogxPds8qxoCt7VgXeHJrSNfVpLD6Q0S9KySC6jotleEIKmOdRr2IICeRV3OHWalg5B5hlhYoaEN0XZq+OCfIIUhoi3OG7V3ias1acjsRIbwVGCgnvV7TV4qzVG75dkrUKVAIx+YPRN4ZoaHNICBd/ehHti7GnwJh6+Pxp0eSq3d5ychsJor66E3/B8e9CHXUDNSTxJh+rIrFbzvURQ7StqB8CpCgMvfa3W2j102xC7u65c/YhZva7rF0pmENmHRy8Prf4J2Fw4AeuTiEfyihjxKdnSjHxaj3nS0oHd7M6M0QduWGY/ypRX4wHnN1HEQVUM3LK+fgSWevFwp3Qi3bvWlFHL6Lu4lO0tVqbfmNHPws96vtlrNC/1cYvLJNiwmMaQRfSDFdKGXl6L+7n4cpAlKxZG/xd88kEL/vIvy35t5InBjc/tDBDJcDiqAaFtfJHmqZPnFdaRl1LdyHfKHvcWVuEVUxv6xJzEAkNesI0d/iK4X1tfPOlbFVC82MpfN80eKSo6e9gwwGqXH3sy0a/eDjiqHsdBL+Vmm5lAUWmwqegI90+A2wiPg0H2LbgaDO2yPZ8zj2ejQ9XmVDdPpX6Vm1MHU5PlM2j8axri3f1d8hPR2JE2nuUdJy9k6fiSuOfQ7t5B+g+BG/JIu6
 oJyNlVRo
 y3ltT4IBABxu55uiiEpGJOju9V0cb3r0C04Kkzf9/biT/nTY25JVkuKUNDxOG2VlB4frEDHaBdlMZskamenI8JS4NI5Wd7FEYjHnNxuJDylo4pJF3dnp28voMm3AnSwFpp+pUWQe2F1+TiMRt/zaHvXLUN/TKFy4PBrZH6sDtXYi/B8Zz1Loc18i4Vg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Baolin,

We backport and test an Android handset(qcom8850, 6.12, 12 GB).
Patch 1's vma_flags_t isn't on 6.12, so we kept only the core
check in its legacy form:
    (vma->vm_flags & VM_EXEC)

Since this is a backport, the numbers below just show the direction
of change. Overall the patch does well, and ran for several
hours with no crashes or hangs:

Camera (launch + capture, 22 background apps resident):
  cold-start p50        -6.3%
  capture               on par
  memavail at startup   +4 .. +7%

Reclaim over the same window, as the patch intends:
  pgsteal_kswapd -46.5%   pgscan_kswapd -52.9%
  pgsteal_direct  +0.8%   pgscan_direct  -6.7%
  pgsteal_anon  -13.8%    pgscan_anon  -13.8%
  pgsteal_file  -14.5%    pgscan_file  -30.1%

Dynamic jank (cold start + scroll, x10): missed-frame <1% on both
base and patched; not memory-bound enough to discriminate.

One trade-off, same run. PSI (memory) creeps up on the sustained
window:

                  avg10  avg60  avg300
    some base     0.00   0.03   0.33
    some patched  0.00   0.02   0.37   (+12%)
    full base     0.00   0.00   0.10
    full patched  0.00   0.00   0.13   (+30%)

and kernel stack footprint -5.3%. Reads as LMKD keeping fewer
background apps alive. This seems an Android policy interaction,
not a kernel regression. Downstreams with aggressive LMKD may
want to retune.

Just curious — did PSI move at all in your make -j32 run?

Best,
Zicheng

