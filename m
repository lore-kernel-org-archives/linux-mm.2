Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0840CA1000
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 18:37:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 239A28E0003; Mon,  1 Sep 2025 14:37:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 211018E0001; Mon,  1 Sep 2025 14:37:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 153418E0003; Mon,  1 Sep 2025 14:37:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 03EFA8E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:37:57 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B1E2313B495
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 18:37:56 +0000 (UTC)
X-FDA: 83841540552.27.9591A91
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf18.hostedemail.com (Postfix) with ESMTP id C81CB1C0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 18:37:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=IFgZvYXk;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf18.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756751875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oBLVwqjZ9ozuQvAMG2IXEqSvWHfxO3m3fGuPczFQRQg=;
	b=H5hmgXbfJHVrMkRgm734mdAO+HbHGhe63a3udfbRg7ybkYTN0+N3umSXSAKQlHgvca4asI
	JOAZQ535bxQyvwA4bUD0mdCnWsAKLbNFTM71TP6MQDaOYi4O0tKwCHcr9++Ifzcr1EkGVC
	m2JWVuN7fMO2oQq4iiFNKNW6QunQXcU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=IFgZvYXk;
	dmarc=pass (policy=none) header.from=igalia.com;
	spf=pass (imf18.hostedemail.com: domain of cascardo@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=cascardo@igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756751875; a=rsa-sha256;
	cv=none;
	b=XjuxL66Ddkig2kuemOL1/Pkgn8H8rsm59CwdKMz1XbeMLdxk9zuU/xX2RMTYlUcLwgzmKe
	GW8kSmkzLXe3fWjK5N7G6XZXfzjtHInBDn0/Rp/aK3VJq77YQDHZunc04A1sA2AC02HWbP
	Qq7zQ8rrbeuBnW3TJ32rD6yPtCaW3EM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=oBLVwqjZ9ozuQvAMG2IXEqSvWHfxO3m3fGuPczFQRQg=; b=IFgZvYXkggEb1ow5yxf/KGJbZ/
	x5Wg7L4Ye33R00WYkqPItOz3yetWNs0A2liQxWzjh8MfBm13wWL1ZMgJ1JrfbZgGaeLqychhWXpGV
	upmItKwf5+/oUVYn8OQKMrZ+EV3uArtsxP7bErpBz4CxX9xAk4qWJefJ6oChQvPw2t9KZ/vEjPfi9
	A6lDy3U177zvNRBTOugg7VLaobc3Ct3uZ55HNU3zeIJt/Qr258QMikECG0HGCXFBHRHPBXAd3Xw+f
	uy95H/xMV077c6ZSDMNM+FsVv7hChs8bXD1Dm4KMM8h0EFuSbjz7yVFVOi2x7eRlUDwjRtjl6UoIA
	UA/wa3UQ==;
Received: from 179-125-64-234-dinamico.pombonet.net.br ([179.125.64.234] helo=quatroqueijos.lan)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1ut9PX-005Oj2-F0; Mon, 01 Sep 2025 20:37:47 +0200
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	kernel-dev@igalia.com,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH] mm: show_mem: show number of zspages in show_free_areas
Date: Mon,  1 Sep 2025 15:37:28 -0300
Message-ID: <20250901183729.3900578-1-cascardo@igalia.com>
X-Mailer: git-send-email 2.47.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C81CB1C0006
X-Stat-Signature: 9pfzfgxhedoztf8j7q9ky64tiig3n6zg
X-Rspam-User: 
X-HE-Tag: 1756751874-962374
X-HE-Meta: U2FsdGVkX1+A2Ll+m292ZRyIgKlpslOjsPDIcrZ5+TOtiqQFoVdbC2I42O/SP1LnkK8ShjxL32rEPdgGYvnfykeVGsIvxIMcNAtPKlqivtOkvSblWhBAdq7w6i/+6YbmAj4VAFOduiLs/V4cYzrfPwLCyChYUgu9gve2Y3F/DYngcZwqAoJulJho92P0PWp+uIuN59K/YBvwhBEenq54sG8FKc0QuUZgCJyxcMZL+r1UEsq5iY/KFvJq2NxqZ6pGhhMjVtMrVXFWtXTFFVlGq3ack6rLqjDIOiW9+3aA8+m6aJzuPP1zhVqxKUn/RgM1nj1JOzC3hH/XhuTRNGolNGV+8IaUooIr99ZsT9jdcfZxhlQ0XHoxJpx9cAVnLG1GCoek/TrnoqyIFmGeHrZr8/d2mcwUDaw4+ym0cJd79WJeis1VEOjjwBjDO/ebiyUBSKAbkI2RROg9LfWQBH3BBCmBuNGcTd+EvAEHNldpPesue5ZjhOUZh0EV3MLPN0lgfsCAy05SuUQo2xCTWTArFEPQ48ENGt68nvAB44ZuF4josuBccbonGYpYZUO83VXBuXo9b9fNcFcaBwabC2PeZkz/CpYNK2w2hBgX/8AyUAAJt1tplVCAYO4vPLdIVxveaF8TEiGw/NM1M30lhQZr1Q9i4qdUy2H/bN8R+uIbtKVJ+JYrqV3JS3vzzWNkGHBRJqo5IROEzBukilrkEXnecSNSvh5usjkbJ+klcsLgPrAicj9VTnh8i8vJZTxdm4M3YJbY+VaV3L88B2GGqijYBFGMFGNw+Da8LSygFNECFxyxZEXepghpCRd7woNIXhwBEoIjbBZcIv2r97BGvdA2VbTuFnYHNhv5baRwAYuow4cTw3uVxmzqTA4c2nd2iui/hxQUYHw7HI/zPR+dt/EFAuRCreDNC8/uAnEz2CUY7f9Da5bvkZITSch7J5BrIkdyM8LN2j/sJY66x2RpwgX
 tSMHlhs5
 EQjJBIEnbgUni/XZcrpj8et/J+NaP9wQmJVANTHN6zShdza75PuVcYjahJKEMF2ebge7jdfXoTEwXh7t/6nW4m/n/Q9oMsV06J36Q7oMQszxKSrFRedlvfGAzTX/6vh8cQCV5N0y8x+feyFmG/qUivsuJCS3M9Yb5y83rWRgylG5dXWQ+mi3ADuLPuYuyiUUkmnXF0WN83iiyRc4BQUiNMKjZKVnC36F9mcDXSQ0qaFzsDRuD6mH2jsHDA7rpe1jHAN/bzz1szNkXaRk8rlZ0E/Op626KUbTIJaYXlfsqYgi0PZkjCBD4y1qXPItaJckKWo+U8Pe5OyK2MOLhNX5cNmbgj1R8a5zmcFz/nuCDqxBYbjX3bI0soXvglRey7uja4lcbawsLonth+8YGZfeum3EY2m/aKKSXpNcbm3g5WXRGVx8C0kmVuvRw3bGrKSv9RCnh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When OOM is triggered, it will show where the pages might be for each zone.
When using zram, it might look like lots of pages are missing. After this
patch, zspages are shown as below.

[   48.792859] Node 0 DMA free:2812kB boost:0kB min:60kB low:72kB high:84kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:11160kB present:15992kB managed:15360kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[   48.792962] lowmem_reserve[]: 0 956 956 956 956
[   48.792988] Node 0 DMA32 free:3512kB boost:0kB min:3912kB low:4888kB high:5864kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:28kB active_file:8kB inactive_file:16kB unevictable:0kB writepending:0kB zspages:916780kB present:1032064kB managed:978944kB mlocked:0kB bounce:0kB free_pcp:500kB local_pcp:248kB free_cma:0kB
[   48.793118] lowmem_reserve[]: 0 0 0 0 0

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
---
 mm/show_mem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/show_mem.c b/mm/show_mem.c
index 41999e94a56d..ecf20a93ea54 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -310,6 +310,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 			" inactive_file:%lukB"
 			" unevictable:%lukB"
 			" writepending:%lukB"
+			" zspages:%lukB"
 			" present:%lukB"
 			" managed:%lukB"
 			" mlocked:%lukB"
@@ -332,6 +333,7 @@ static void show_free_areas(unsigned int filter, nodemask_t *nodemask, int max_z
 			K(zone_page_state(zone, NR_ZONE_INACTIVE_FILE)),
 			K(zone_page_state(zone, NR_ZONE_UNEVICTABLE)),
 			K(zone_page_state(zone, NR_ZONE_WRITE_PENDING)),
+			K(zone_page_state(zone, NR_ZSPAGES)),
 			K(zone->present_pages),
 			K(zone_managed_pages(zone)),
 			K(zone_page_state(zone, NR_MLOCK)),
-- 
2.47.2


