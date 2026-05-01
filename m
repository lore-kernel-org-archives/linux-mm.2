Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19D8ECD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 21:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76C7D6B00A8; Fri,  1 May 2026 17:04:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CE4C6B00AC; Fri,  1 May 2026 17:04:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56D986B00A9; Fri,  1 May 2026 17:04:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 3D8286B00A6
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:04:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1B8FC157B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:20 +0000 (UTC)
X-FDA: 84720079080.30.0DB0C2B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id DEB12160013
	for <linux-mm@kvack.org>; Fri,  1 May 2026 21:04:18 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O3cr2C5x;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777669459;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xpM+PZkwCk6Zg+EfofEVvQphsEgxeWwzwrq3SfsvUPc=;
	b=OrGv0fkeHfYrumhpRNSGc/Tp0y4aeMl0wgYrDhMAPBErdIj3HpLgp+4j6OgmHGtelnfqMN
	VG8WZPDtUMEcU8iTSqUFSf2Nn1blOmtzqGC3VgSlufximK2hRfN61c+y/Lk0MTtbhQK+N1
	NO/LPUos3CG7MiFkmzZvgJLuauF22t8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777669459; a=rsa-sha256;
	cv=none;
	b=Cwr+M6c3x7bPKN20h6CLxVLsm8CsguoiDylr0p1pV/v5rPzI+O/vMgXjV/fE2Eai+XJcTk
	dkw0l+dIUtgI6AFzj+rCMTvHsvkj8SeumUjTgfUkl2nuG54upOr0wZENhEff8bvU1HGDS1
	/X/9sc2YBexw6khzi6Z0x9vFwaXqK1I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O3cr2C5x;
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D71A4473F;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7D890C2BCB4;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777669453;
	bh=J9XkOZA3RXA56Ea9/X8t4L7qZbu/jTW68DVd2kgzDhY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=O3cr2C5x32oLyL4h7xuz2UvIo9eA6PphtmST6sK7EeejTnm4kfJAKsNxMjQZzt+sU
	 D2PGf/lXwKbmY3Eo2apjgoYlxxUP3tWg1Hhw9JXOt4EXVTSw1VcZ3vbOzXUz/Xb5px
	 UCqjmdT+XolQ+/+lrW6HTjbcIMXp800eCF5YTseQWv98nor8nFCVar247XRJE7vmem
	 s/pl/tCGoiZilGmzSbO8j7ObmgQL0S2Fq9fjq2CwK5jPSUde1agsqQAfF7LokQjKOa
	 6wcRVbWQlVMvUWPhYB2+rm22sNdVQR2CEUykBY3rR39ajXi9IP5oeYicP6DVEY5OXo
	 Mw7WG/EZDtIdw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73752CD3425;
	Fri,  1 May 2026 21:04:13 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 02 May 2026 05:04:06 +0800
Subject: [PATCH RFC 20/32] mm/damon: don't clear the lruref for MGLRU
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260502-mglru-fg-v1-20-913619b014d9@tencent.com>
References: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
In-Reply-To: <20260502-mglru-fg-v1-0-913619b014d9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@huaweicloud.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, linux-kernel@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777669448; l=635;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=aHsc1nk/FwDwd1lG6O1KFNt7Wktso+y56WV9FF+FyW4=;
 b=mQ1ilv6x/6GtozJZhXvoobsbJ9AwqNI8htvVQf2Xp8Esl58NF8vs+4uOuU/WIwknj7Ts5Z1Ok
 wXwKliweL9CDMi4L7r0NeohOyUPT3TIx6Z/hv/jKA2Tw2fVQF04dSsD
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DEB12160013
X-Stat-Signature: by77mw4asriojg9n47nr8p3aaene4n7g
X-Rspam-User: 
X-HE-Tag: 1777669458-473276
X-HE-Meta: U2FsdGVkX18OGU/8MFDaMU97yJ+gd6fWziCWsmWWkIjCfPxxfx5gKq8DmwTO7B2DF5jz8xGYgxOB3qnWPHZmGj/1VyUJps2Pw2mGKoXpQmi044Py3Ecm7H/RZoMWmbNzuiAo1ua3RcM3hOJ5cXWwA8b+9z8eAfhs42e1O65fgxu9Lr6aU9ZgcJabxV13ierDYGOSLp3f1hkNqy8MStynJ3dG8rvz82w0FHQcdHWMtCrey17WkOERGi3O8/lNqqm3MjSQX8Al+lHT38qKWRVHeX9nQqImhlTqIQU41a4ToQ+SA8ETrqbiNtSpgMGUJWgbx1teY45ryuUjm/K3TLF67Xh8qGRSjZMGDsE7p2az/z+le1I59tmCmgTqMEYg5E0jOivvF+UsOGP0WAkHyBlN2vSk7Ty7Wtp8/qXr5IQ6z4OXdnkWRXKqbsx38xBMg6jyxvupNI5ePoROh3QQ0Ojj+lVMupw1dHTGj692zaaFMtfCsTxTOvL677uykDmDD776CTH57FIHnntHIVVRYCVG709uQ+WX0+0EvAWBTIfIPGaMLi6sc8WFU64Ib1EVs+wELo4a2+zpN/dHJoRaN+JLTnZcwtNEzAv9EXoVvaBvJexJbkuOjwkY4cMioFD7j8WW3RvjpktguFZX3MQvp9Hzew0jfZhdE6ZLr3XZQI73Mfcfot8pvZwHxbwhAHC4pG0f/xFiXnTnHv6ybEK4a0imQ9KQWh4s5HMY5azUaVy+ebHAWwUiMPa3rPtWySbL36kAissnLjP9aFN4Kyq/Pz5NiINNezEtwmICSBR7PyobWnTFupdv9fv4YP1+NHqxajpG1gMZ9F2mWAo+3fXx4Q2GBWVJqR6pNXLYnSEK1C7r4P/D2Ru5J09YxNkxJaJ2UMT2vYgx54NS3uvwc3VpBqpT/smc/oGQd/ffk0G7t2i8BKo6KMFfMcJU+Js7CyzCTBcBGKfLyGJ33sBOSnpMQlg
 I/f9OYIj
 LB0oEpKBCMJeAvcPv5BETKR+MxernawWZQ2XCfIWnAbJhAFJjpkbthyY5EkzOO7NSQq7TfjrSeeU60OuwXDKZl6Q03Qvp2c4r9EV2EqebqKvfQG01GXnKPtxoSLNMNOHIXRBOMtDjtwGvOFlnrEImgP3P4FxIJzYQJVgmIYTo5CS02xB7P6KSdlmfLvXPahc72Lw5iYu0178iuI4YlpX/G3nljmeoTfVRYUxTPw3P142bu40cxyjf79OCLlfBsB/ygETaLPnddADG6ZLxJH74s1dwRSDcmrvluVyNdP0vPWGd1s9iCcU6rhNk6x3TPLfp1IOCM1STub3OhodhOPt/TfOHa4nDH+hzdmlSdmU9a4R5fpT4fxRFqw5oAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/damon/paddr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5cdcc5037cbc..7718cd9ac959 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -186,7 +186,8 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 		else
 			*sz_filter_passed += folio_size(folio) / addr_unit;
 
-		folio_clear_referenced(folio);
+		if (!lru_gen_enabled())
+			folio_clear_referenced_by_bit(folio);
 		folio_test_clear_young(folio);
 		if (!folio_isolate_lru(folio))
 			goto put_folio;

-- 
2.54.0



