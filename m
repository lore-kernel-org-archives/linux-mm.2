Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38A19F99342
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 07:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7688F6B0092; Thu, 23 Apr 2026 03:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F1E76B0093; Thu, 23 Apr 2026 03:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E1256B0095; Thu, 23 Apr 2026 03:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 48D2B6B0092
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 03:19:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F1728140511
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:19:34 +0000 (UTC)
X-FDA: 84688970268.03.ACCF8E0
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf10.hostedemail.com (Postfix) with ESMTP id 26ADCC000D
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:19:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UZTjWx13;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776928773; a=rsa-sha256;
	cv=none;
	b=EM/9RcoIcpQJIAnRGgHXdbznRW233FyRCfaIXJ8Fk2v7DVNZOxEg8o8C6+DwREET9zmhZW
	9QE03Mq1owqFAuO0Uud/tO4L6bTSTjKASsFssyXw5WvUphWa3RX1YrMX+wecaxTFuOf5uA
	Kbo9hECUMQN3ImsWiwbvldOrpJjx/4g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=UZTjWx13;
	spf=pass (imf10.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776928773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2yTHOksAu1ksVjTp1X1iUbz+KUOcAtP7+OrJQBUO/Q=;
	b=mvwhkh93wPFGNN3cz97ta+rvDHvRbzaPv5eVH2bzMxHXHt5Gw4eOfrX2HredcXqmkbQzje
	OKlaF6/XnYnsDxv51uTeDwO2AMQP27l04ASL0LIHxOTaBtBYGePpc1kD4Pveb8vVXn77V7
	EmCqtxNnRTJ3dzZO2iq0TcpME0KIPqI=
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35fc258aaa4so3982958a91.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 00:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1776928772; x=1777533572; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h2yTHOksAu1ksVjTp1X1iUbz+KUOcAtP7+OrJQBUO/Q=;
        b=UZTjWx13ElSYJsSSc+1i20CZdltGQZkJrKkkgMTQhlD0xVDBhi+okxmYIL/MrF+Gg9
         o+4Zx6TDGJdunc9IFFKGPsEz07QLJWT7lI8+fNb9CysNRyKTKRIZ2TJoZxtglGsz8G1I
         wTSs4/MbDhzmVVgl5bGcR3x+E04P2R5ABNOp31J5+rE8oUUYhAkbnyxP+dmUoadVRZ+j
         T+TUbnNVX46BQqJYXnrS01ppR5dP11cih3FPPwB/m11THUMhR1vT8yOxbZN9tPTWRaz7
         N/7MyWW7h28LCytsJUK4r0/R8rRhuKtNgKYTuFNqMX/SnABa/ItXwXWT5MM9v9tTcv8H
         CzvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776928772; x=1777533572;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h2yTHOksAu1ksVjTp1X1iUbz+KUOcAtP7+OrJQBUO/Q=;
        b=eYUwsxMlyu+TRkL3nXdEucV5iul9PF+w6wVmmQjUZsX6i/zrzrSZQtEmOy1JBL4dwz
         ohL8lbMMpRZZHh0xWlsOq9/dyK7ZN7KfdrOQdLnaAMFbvxL0OhBWvYaf0Cq6dQHaxxLY
         TngdzccwVkd8iVcrVKMUO4hwhlbkSFU6HdhJzUUA6DBeQksOEN5vRdgyL8n9RLx01uwL
         8i0VhoNA5pDv+KZ7Y4erz9aLOWPHkAeDEUxJJaFe2uVvMO2SdSMLKDOt+RLI7HpoD1Dz
         SMav6InAn40dGU8gQyny6kjnsj3TqowUpUXmaWa5eV6JmYLNNkrx0pESj/YJuKwP03+G
         qCng==
X-Forwarded-Encrypted: i=1; AFNElJ+x9rHid0Z8xqqm2rXbDziiQE11kzw8gNcrZZoqbaDmIudo1UVqRfItd7FNA7DyijLw1QG1f7AACA==@kvack.org
X-Gm-Message-State: AOJu0YyhzYivOa8rpV33VVzyq+CeI2hjzjSJ5fGgplYjebGZT+I0wW4W
	XJJVuc85qOp7bnjF7p7x5bl0sQwxTMuF+lAKHgK5rNa6TEJbWwKZD3hwpq/ljET4AUU=
X-Gm-Gg: AeBDiet2MUNP6OjIgFj3RUSRJLCUjC27iIvIgv1HKl1fesqZrFmRjkD3bPDAUcwDdpn
	hb4SBw1SEZzRmEzsUQqGC9sNRUg+FwpxNMaJU8z9misccawaF57XrdmdaRqQHYTYBMPXHsCeTDv
	i9RnxlUKj0O5rKhDspdi4bW+ddoL2J2ZKjkxUO1PzQvdqleFVQtYc4FYiMXmImEnViBxZ2crvYV
	IgN5LqvwfiSTPZb2SLo1ZKf8KTRZiSGU6BbZwVFbKv9vGAEf2CPZLB6ICrDcDzRxM9IieLfHXkP
	yYUmVeSDYygj+Cnp1XEGiDwMfLHUiOogqRkhaxtch+HyNDb5LC1tyVQbgQ7Mj54MlL+ZWaHAxP4
	R8nSVQEsz36+bdyxKIAkTT4k+hDSrdEfLeXnW4/tNkcEm1CHYI3hfGE1AIHN4kMGoEzRq5mREcR
	Vjm/QgcfO8x86/Dz8mqcFULWJ+dTlH9lCBlFZTKXqzZvynCT7Af2WzgQ==
X-Received: by 2002:a17:90b:3d01:b0:35a:cf:64a6 with SMTP id 98e67ed59e1d1-361404af0a4mr28368736a91.23.1776928771838;
        Thu, 23 Apr 2026 00:19:31 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3613fbd970fsm7092372a91.14.2026.04.23.00.19.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2026 00:19:31 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v5 v5 2/6] mm/memory_hotplug: Fix incorrect altmap passing in error path
Date: Thu, 23 Apr 2026 15:19:07 +0800
Message-Id: <20260423071911.1962859-3-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260423071911.1962859-1-songmuchun@bytedance.com>
References: <20260423071911.1962859-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 26ADCC000D
X-Stat-Signature: diiwwc71ju1hodiqdpjp1zizb5d866iy
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776928772-752770
X-HE-Meta: U2FsdGVkX19XpaCrdhoeTMe8SIE4p1hkmidFIp4M9yMIdF4+BjspI+l46I/tzQ/+rUib9vnsKOtV6C+VrSleWvdp+Mi7tt3qDblC1Hr92444bsqdskznnweo16MO1XxlSdSWaX79ZADZAw4GyemT5Al+k16bwub6Q873ScgTRsX+FHopS6+s3ew4V7C26hQvdDtrGeN43Wc8T0AFZlqro+9u5SWIkiRKAp1Rcole02YwFtip/dFkYbL0xgoqNnf+fzHONIygtuby2wmT5MZGdU+G0n2EV1MD+cqsxoERalpddu5y4bBJyfnX/p0EUVaGQRU/RoktpfnwKvBvgB+lg/WBiKM/0BdPlUjP7fLcNJfrY2f7JbPrTwuOQMVZGvtZ9b5dGFV3JFFubWzSUJvj5pfS813M+P5T4WZayR3iqvfWp5Ku0IC2UrLAQIBo2uleV19LRogRHrftNxFTL/EL0o295aYfwDcCqMdWgJUZqAI7AGgvGULyARs951OYgeyUtXRoCEEF7Q/fGiJfZ81Q2VSZb8E/XBXHpky7EnCBhbO+U1FZM6D6aoSIANq6i3G13Y9Nruxua486FreN/lmBOOPcNrLDjSivrHxMLJVpemAKHNVADNk9IJfZ/uupH852mpDH2EbvPkPIDhRll3u/v4SfxB8NxuU0YDpaWVbI7reDTVc+/DQCL6by3lQIQ9gKVjWrmDiQIPtuYOAxoin7RRSxYy6JUn32/C1r9oxOb4M5FtVRYNRRKt/UqUu4HwNwDT/3ejR1nOOrn88gZWkLUIxrhHBivqLkT9FL2AeMZmewZOStBKdDEXsEKj2BjsogLfcbo0aKHySjurRVOIWFOAkQPeFQB/Zak9S6JYRZx0h7tmGxzXrUWO0MZ7aCHRwi9YH/sA4VBkks0OAUBTtdFrnMl7dw3+MMmfpREwxUfb5ytMsxlOLvS/TKukI97sL/7X+DhvKDg2FJtnJxy4L
 KxStkFmw
 WTsHjHzspjXy2ZmMevUTlj5iiwjCn81HFDasp69vmGMTkI5tNv0CNeEZR2iuMllJ6iZKdutZ7Pk13kpxuY1Z5EKi/b63lcPRMdP7OYECQOTH8fWp54hwgpV7Y6Qdnvk502pK66SdewcQV5Dv/KHvOdgbOdbp0vfTxRfFruH0HaZtspf5e3dWRv8ynCexeQ/DieNRgPY6cSSjV34IO6VTJcNW1XXuPeuahD8Wlu/nd1F0cFOZ/P1DdoqIJJmhOCu5LNlCY5P6r2nEGS4ouNjmll7oxY2DR6IDBYq+jEU0L4jhfvTge8AzblkkKXYcx/jT/OvwVoWVv+/zsN72XbT1zxWZTCdEJ+RdzxF+53f2uTKBW4sA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In create_altmaps_and_memory_blocks(), when arch_add_memory() succeeds
with memmap_on_memory enabled, the vmemmap pages are allocated from
params.altmap. If create_memory_block_devices() subsequently fails, the
error path calls arch_remove_memory() with a NULL altmap instead of
params.altmap.

This is a bug that could lead to memory corruption. Since altmap is
NULL, vmemmap_free() falls back to freeing the vmemmap pages into the
system buddy allocator via free_pages() instead of the altmap.
arch_remove_memory() then immediately destroys the physical linear
mapping for this memory. This injects unowned pages into the buddy
allocator, causing machine checks or memory corruption if the system
later attempts to allocate and use those freed pages.

Fix this by passing params.altmap to arch_remove_memory() in the error
path.

Fixes: 6b8f0798b85a ("mm/memory_hotplug: split memmap_on_memory requests across memblocks")
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/memory_hotplug.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 2a943ec57c85..0bad2aed2bde 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1468,7 +1468,7 @@ static int create_altmaps_and_memory_blocks(int nid, struct memory_group *group,
 		ret = create_memory_block_devices(cur_start, memblock_size, nid,
 						  params.altmap, group);
 		if (ret) {
-			arch_remove_memory(cur_start, memblock_size, NULL);
+			arch_remove_memory(cur_start, memblock_size, params.altmap);
 			kfree(params.altmap);
 			goto out;
 		}
-- 
2.20.1


