Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A19E6075245
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ntZvMKrT
Received: by kanga.kvack.org (Postfix)
	id 197776B05D1; Fri, 20 Nov 2026 13:10:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 121CF6B05D3; Fri, 20 Nov 2026 13:10:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F039A6B05D4; Fri, 20 Nov 2026 13:10:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CE5B66B05D1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:29 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6348316013C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:29 +0000 (UTC)
X-FDA: 85456287378.25.63F0FBA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 359B6160002
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:27 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ntZvMKrT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf08.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198227;
	b=8A+h9ajE4p6m0t87vobHd1yzOjw+8HPidnmdNcjkCc9i0A9ZqXsA0bklxAB1n1sLk+rJE4
	sbb9z6M5j627apCbC191vP0F7Dn2iRNahrAqCqLEztxCdEoF7wrlfkd59Aj+uUyrAsYYat
	uiI04bsWMs37k4eNWxhKSX0p2zgDreA=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198227;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S63qEZh37FcqDEnZtOKDS8dEDMlYAdmMAyDqP/DP/54=;
	b=SpGNs2MQBJlEgxyHqXeq88X+5UL5Q+zGPTNkIOVIo7fFSPqToXTR2yYRDKmagKK4uufUAk
	Mw3pExB3b2nl+6ghvNZ94tFEZOs1JYCFarwQyDQBrs9puhIvT8taP1q/gbCQMHca5xq5eT
	DVM4vLg3Dmad777Al5naZ6ovn5f114k=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ntZvMKrT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf08.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7CB5146BCE;
	Fri, 20 Nov 2026 18:10:26 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198226;
	b=F0RSukeG23xlkWqgblvlYPORnzkdhm9q6tlodchkKDzPUKHOQRHp+bTdv3NX99yZq3PN
	 kLMUsJboWMrWt1wakG6hLV7k3CeAW/KQEi28T4Muka04l/0DG2V/jUebRnSCJiBBZSA3e
	 qTxLjs6/AAqX68NhFaAhGHgLoMYmwvUap9MQmnZoVv4P6FnvNF8/5ASHgU1PZd6fDAYQp
	 DMNKgt1898fodC8stPkNYdWLnUBZ2qXP4TjjErnaHRgRRmSrRGgoo0A352BCs1wMp4NTO
	 iunelUgeCHx3poOPx//wPKv3qH9bvyMue9dcjTAMoHkXVGOyMdNocM7DxF/ttp/Umeg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198226;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=S63qEZh37FcqDEnZtOKDS8dEDMlYAdmMAyDqP/DP/54=;
	b=ZZaBIAn0dsBdqTb9B9A1Aj07Qcm+dTefzNGie5nK3Dj2HfIhLePVTs+ku3KmqpkUYJtW
	 lQoSJthK9JKoCSWujKe+kriULtaJtmQeoQOPxHn+aDyuWjTEMnttacwzv2mehFkSGmyB+
	 OMjxQD6H8ewK4B/GIVHVj9dKlspW14ia2VXAY8X+v9ueazAR0Yrf+79LHEaHx7RoNGscR
	 YA5oZ+MDlllY899uyEsFpDWQUPxaO/8+ipDn1+pFlhPeFFh58uIAWZk+VNfUIhgB1O9jr
	 p8FLFuIaA3+PNTIe6VdyXSfGeqhzgOL9JKmLpPOBBni8+LhzF3i2J8FaL28oPftuTww==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 17FF01F0156A;
	Fri, 20 Nov 2026 18:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198226;
	bh=S63qEZh37FcqDEnZtOKDS8dEDMlYAdmMAyDqP/DP/54=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ntZvMKrTq1oMrnZQN932/NmXsQ4FrS2OAHZB8uqJiHBIZLQSbD1JvC/LkeoKvKCeX
	 GiMWNgfXWb7lXOkAC+swDXaymUecKg2FtB++NJsDqYxTYew0Baal5iFPMzGSr0mbt1
	 rTcjQAgMbPebs17y8DLLAfz4pWL5a11cdG6PMlIFlEojHxVmexrsBEeKfBT3rtd8Tl
	 pH1a2bt5ZuPQFKEE0UHe0g8kA3UrPar0lw7fScfhOxIQnyn3blGuKB2aP19xVRkqgX
	 ZKMbmEvC6hHdTksGx+Rm+KvaGZPAnsvUMvgJdnjo8cFkz8JcvS5g8AW9sTI+JcTxvL
	 1+Td1JLZdhb1A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 28C3B4B929;
	Fri, 20 Nov 2026 18:09:20 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:17 -0500
Subject: [PATCH 26/60] mm/migrate: leave pages outside common memory in
 move_pages()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-26-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=857;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=AKM465apFVaa3BIvx9XBEK691w0dLD6ac7SFTDNSyZQ=;
 b=zKNmtwP0ZJy98reK9MCbqubRCfEXRiY4oIhpY5EIBd6qtzzkCGaM6TwqOsdAK0YxCEyfiIv7s
 pNtU/wZ9nLKDgoZ6+gYrdIUpvysLRVgvfMsEzFM7klZsQ3JuUN5Arbk
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 359B6160002
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: foykr5wjwxmazrw6i1qinrnm3xpjt4mj
X-HE-Tag: 1795198227-14935
X-HE-Meta: U2FsdGVkX1/sMxeaMX34HyHzV8OZb89O5wur7kazkzIQuuNv8qpxUBh6WsXEFh/ah3IQzxM5h1kdGcVxIYiEWNj8pdIJ4gFbjAo6HKP01AwqeVh2enMUafM3lG8rbhz1IG/RfROWO8O2u63goEunIB+DDtShPt/Fv5DPqZcgP7UoA+e0eFPkh6U5tLqedJeL2rj/PmAmiiKBpTfwKFZ0PUR3SKXfTQfxlBV1bUYwn3CP4lZzTbzbCQmy2I71BPdxx37CELNS0uvkMnQ15JX8eo40iii/SUUmYTN6I3Mg5VhmZjdh9PNBA6LL1KFVrixed7pt2H3JOUjBdSHexQiQHI69NEr6C7U1XwxyEaRMmOSy7k2LeRIPgU6/NdjNdBkINOebLcstGynBO1ANwY1wFiMuzcypsyswHkyLijXrT4WxsXNJuVhk+S64IxTHBAbNxG8sJlY1HIcyHqjjEw6LRsl4Y+9SE35ycXUigTTJ6acjHgJLz7tidfO0+w9f3233OIBOWEBPwMciiLo+ZXhYC/60MUh6YvMS6kgfHnKtDjNt1KjZCrV6ROUW0+2LNN9sJUc6+Kl0tTWUakCHdsQ5PNnBUQkeXizhMC0RfAqRWvZcC3hgbKq3meAVEfmUJ8QTFm2hC1Jm1W7FarpW57imL/O4M+iQtx0Sklu78KT0eshLHdEf3gM4GrLAZz8d+THi+Chiem7j94DZ9VsYhZ78CFbhxOnZYu3eGooNF1BzyQyJEj6vCiwI84Z7oofto7giUIiaH/t2S/kyypFe5WxmpGIzvqf+kPbxB9ScWjxL8twIsXF6uPMH1C++7SCG7A+FplXj6l1wwuPFeR+eFt0SnzZiQKRjfmLTeQrWsxCds6peojZq8Qk3QKVHE0mTZMPe1Nxh2qFYRqUwJxu8aPA7Eeb1MdaGgdf1E0by+1I5oooi8i28Laktr1RLHe1dR6hpNGWP94yzNU/BbTeZARf
 5Me79yKN
 S9TJP1hXpg9LPLbT1dgkw2cE/bjcCzmscPYM+io6kcH2Cc7ya7HXbBYognhxNV/o6CPO3juhMBETcy6mUtbMKgnXEH/d4Ez1I503Ug1KBHNkqvtBVOw1IjKOFaBUCZ6K/LwYglBtOvsgeeWNe4fKpDNUb1/l4WQcJhWDiu75UqvT/V4TdXs/TwHWAhtLik4xwST7kZWkhnwp5LVk2/cLwtI0G+XRN5sdoBrewD0E5exgQFLjzO3FNucVSK0Zq7jPyK1SLfnPNdOyc57TEf/VGWi7DYAKmVUpBfYo77GmfBioze+Uee9RCyNkilX8v52elmw1v5yeHWamUvuqvohk2pCyof+EdJATYJOIdjvxXmF2mk3kyeKtW0p2eIir1XELriBjr9BIURKzydhN1WIQ3ylQeITh5v4Q2Pb8slMORAp/7ZjLq5JWBLlV/bbPNfTXYjaLY8V+v4C687kLpdLBm8IR7Ukf1sdq39FwSBsMAM9nazYH1rCrsxoMrMb2PP6/zbfXxZiUUCKeZIhPpZKjwkHEfKaecTMErigCbomKB2pTd3ObP4jv6Oj9CQt6tatMIur1L4dh0Skkmw3wA+A2Y2PL7WxZwIwCoUUQsyyfwHgcNg/3LjSwr6zTYioNK99XMsBk06HOw23XeKhEfHPfAIcBRkT87Uhvb+9DZzZzrVPQTqecJ+Tu19QdHqLiNW6JFFjvRNnFf5uEqzBvSWMqj2IUpSkdNH1zwFwOuwfeZNlcADOgEWoX+ZvD21q2YU8Cc05PhBnqUYPoazyXXL2uqKNh/BYLHq4dfTswAlCA9OBsr8wT+m5sMYKhfSynLjX0/fJXK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

move_pages(2) moves the pages a caller names, and reports the node of
each page in status queries.

Leave pages outside common memory where they are: refuse to move them,
similar to ZONE_DEVICE pages. Status queries move nothing, so they
still report the node of each page.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/migrate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 208788b130fa..ac583afa1bc5 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2287,7 +2287,7 @@ static int __add_folio_for_migration(struct folio *folio, int node,
 	if (is_zero_folio(folio) || is_huge_zero_folio(folio))
 		return -EFAULT;
 
-	if (folio_is_zone_device(folio))
+	if (!folio_is_common_memory(folio))
 		return -ENOENT;
 
 	if (folio_nid(folio) == node)

-- 
2.56.1



