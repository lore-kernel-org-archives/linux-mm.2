Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A651C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:43:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 26F0F6B00A3; Wed,  2 Sep 2026 13:43:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D2446B00A1; Wed,  2 Sep 2026 13:43:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 099E56B00A3; Wed,  2 Sep 2026 13:43:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C50EA6B009E
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:43:31 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38CC4A3E01
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:43:31 +0000 (UTC)
X-FDA: 85169544222.11.564C24E
Received: from mta0.migadu.com (out-85.mta0.migadu.com [91.218.175.85])
	by imf02.hostedemail.com (Postfix) with ESMTP id 5D83980006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:43:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wa5rNLtt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.85 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788371009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bwdv0E924WKS2Y2GH91PHhyAbyCCSaAV+7KD+SKH9Vo=;
	b=dbrwmFCKMZ244bL2f3AsvsmaSptpOtVekK3mq7d6pTisgLeRzky6HAiE3vEuNwE5U2DAr4
	GwDTFLXs8Ij9Oz/5sot57gQ+4mWkNdkPW3Fa4JzcfdM88bSa3Ra1hTpEns1XBEs8V8C+IO
	om0O3xJmX1ABxuCtR1MDCwhmlZ5R2Tc=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=wa5rNLtt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf02.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.85 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788371009;
	b=W/Crl9VOTyXq0aClc93bCFDVy/hDwHIjCGKo4kxbihcwKVfvvyBS4jfxvKI6p2SW0lu0FJ
	kAFZxhrAxNNBRoOK01ixVnLkNti5UGhNCqKCjamuM7ggl+weiYoZXJ+rWrk8kx41BGNL52
	OyfNRkCRGwmnxDpuqoMwc+JIJFbI/VU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=xd6EFsUbftLos1RRhOIpcmZSlk3cgIUqMzzRlctLURA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788371008; v=1; x=1788975808;
 b=wa5rNLtt14Z4n31TNb4obZVnk6EeYnPqLi7n3kWX3f4STpj9nDO7zUsQbRUyWJbq+zzH+mNt
 pHHwkMWeSrJHxaL2PjY8g/AJ/BprbdPuLLCc0jkgj+Bne6jMuLmJx0AQ5oJRLPR0+MnKq7BalUK
 3msExwP7YdMeEn6m2T+PSvNY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1032bfc38b8f472a;
	Wed, 02 Sep 2026 17:43:28 +0000
X-Mizu-Trace-ID: 1032bfc38b8f472a
X-Migadu-Flow: FLOW_OUT
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	tjmercier@google.com,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/8] memcg: remove the soft limit reclaim tracepoints
Date: Wed,  2 Sep 2026 10:43:06 -0700
Message-ID: <20260902174311.1772372-4-shakeel.butt@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260902174311.1772372-1-shakeel.butt@linux.dev>
References: <20260902174311.1772372-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fsu9a3nd5qfstiymtk7nmededx74r1gx
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5D83980006
X-Rspam-User: 
X-HE-Tag: 1788371009-249200
X-HE-Meta: U2FsdGVkX19Yqq6J0uRwLvzh22F1pDJc/HkGOhjJwypihzrsMbGdEAlW0EdI2YzH2KZ7WOveU3ZpIdwzL+KS1EIS1J8LJKRa8dARCTSfiu/QedWRI7dV5oYyX6629EoHgqB6277e2m9pVXgvsDqy8LsEmxweKAdlq7/MASGz/TuZ4GJD0acdMeqcASKGQQ/rg+UoEgHR7SU0aiz/0RzHuCBr52xeyj3VbuQGl0tj1w0nUe1HgGWwWy0hhv3sjOvRy4AT+n2VoF6BSVDsAkjROKFQtuPBi++KoezOyvHIvjUbgoRQaTDT06lRu2Ad87tgS/l5fHy+O4uPcpKtXz6ZPdCQHhHK726EjNscIuE+aPNaGtGb/4xp3jR0XX4xZNfnrSdf6++JxtUxP+3YnDOOqgGqXnE625GpH3zPsRwrN1kn663tANseQchbU5XfzRX4547T8bfvTtiZ2mV6+mpyxrwVsPU0etBNuXZdJSakTEnzIOUMlD+AlCkS1hGXaCUwxxY4qEt//2c05fCsmfqjZXB1OzQYKhT7j/oPAPBYYH4Jlt7eOirily6j/r69zKmEj/Ncw0VmL8TYz3idUcxrav5CR/sZvDlI9E0U6pckzQ+KY67Ro2E7Al+QK4MCg36NDHyg6jZPgQj+IjWXYOBTp1XZq2svP5R78inWrscz26vEDUdWNLE+uYg95/4U1zOSXWFgSyizc61Xya8Oe9PfSbeCB85AK99W/1a69byY/KBcpgT4NQLy1DLEKhR/YnQEriNOeIY+7zISkkWVM32GZWdLVRnCWpteLTlT87Bdpsr2PY9NDUpBJwsrqunLRGwPqAH2MR4h8v5siRITACMh3R8KldQZuohXFQNqyDmfJ723ozj7ZPzMdsx21Zf95bKoEB7cwqYN6h9dJdriIbv3SEw/rmF9L1Y/S3S2MLYH0JGhlV7GkIdQePhEzJVMXWwtzA2wH1E4PK2kV5d5s8t
 foU7PWj6
 yQavqDg+2WU2HLG5xckntRDNu9UmKvEaafd1VDEfnbkXWCPZvO9Z+XZq+Uv4DYSaNawPSPGwIvAV0usyhkuB0kV5rzJZurVwyt0NzteG5Fudh2H1s4RAUtxzLztxth/E28OWT/E3Ela6XIpWn4+rTAZsjh1V5eH8YpvkpL2IWXQfBhh++ECwLxn57rcoDhZyChTgAHQKQMRIO2aWhd2Q77p4wy2uVzay0XzsgzIlU54Xhm6pH1wWF/XTvKSqRGNEtSU2xg2BGuAniNzyXx9jMVTTDo44+fUZocoqe/At2I4vk/XXXY3M7zCzAew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

mm_vmscan_memcg_softlimit_reclaim_begin and
mm_vmscan_memcg_softlimit_reclaim_end were only emitted by
mem_cgroup_shrink_node(), which is gone, so they can never fire again.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 include/trace/events/vmscan.h | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/include/trace/events/vmscan.h b/include/trace/events/vmscan.h
index b4bf7b8def1f..8a872990b4be 100644
--- a/include/trace/events/vmscan.h
+++ b/include/trace/events/vmscan.h
@@ -214,13 +214,6 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_reclaim_be
 
 	TP_ARGS(gfp_flags, order, memcg)
 );
-
-DEFINE_EVENT(mm_vmscan_direct_reclaim_begin_template, mm_vmscan_memcg_softlimit_reclaim_begin,
-
-	TP_PROTO(gfp_t gfp_flags, int order, struct mem_cgroup *memcg),
-
-	TP_ARGS(gfp_flags, order, memcg)
-);
 #endif /* CONFIG_MEMCG */
 
 DECLARE_EVENT_CLASS(mm_vmscan_direct_reclaim_end_template,
@@ -260,13 +253,6 @@ DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_reclaim_end,
 
 	TP_ARGS(nr_reclaimed, memcg)
 );
-
-DEFINE_EVENT(mm_vmscan_direct_reclaim_end_template, mm_vmscan_memcg_softlimit_reclaim_end,
-
-	TP_PROTO(unsigned long nr_reclaimed, struct mem_cgroup *memcg),
-
-	TP_ARGS(nr_reclaimed, memcg)
-);
 #endif /* CONFIG_MEMCG */
 
 TRACE_EVENT(mm_shrink_slab_start,
-- 
2.53.0-Meta


