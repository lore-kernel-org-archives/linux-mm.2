Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F158606A337
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 23:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SZTTFDX3
Received: by kanga.kvack.org (Postfix)
	id AE48F6B05B2; Fri, 13 Nov 2026 18:52:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABC8B6B05B4; Fri, 13 Nov 2026 18:52:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95AE86B05B2; Fri, 13 Nov 2026 18:52:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 685DF6B05B2
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:52:43 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E89A91A02C1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:52:42 +0000 (UTC)
X-FDA: 85431748164.26.29ADEA7
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id 26095C0006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:52:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SZTTFDX3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794613961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V6Dc06AwxOqv+YtietBML1RlnbCWLY7fPYdPiA+3csI=;
	b=FuqSlKkjG82I4PIhPv2wzdPQ/+KSW7pO8q3tCJNPh2VoT5KMwRdW3iwmkV9J+bzAeHjmgl
	xpQNJ17xmlYFVAmMy9pdBNf8IHo6qLHiDWubt5OUMUOBJxW8Yiv9U/v6DThqov8ri0xB2I
	iTozscx+FLxWdKjckN0JWEEIieK7jj8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=SZTTFDX3;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794613961;
	b=y4MnDe6xZn8cze83R0Bz2HJvNTZf3z/JX4uP1EfJCHTQ7Zz72rfgAf8NbDnlsJQY2DA3TZ
	XD1yjDzA8hrMmrxd1DETTmhmLjWsSFVatSEdT1zR3EwZTlNWH7wsGXz9xW07iWlIuuczNM
	dg2bfJjpfNQwpmrk2EXB3dvkQ7IRAZw=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-8b32bbd39d5so12142787b3.3
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 15:52:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794613960; x=1795218760; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=V6Dc06AwxOqv+YtietBML1RlnbCWLY7fPYdPiA+3csI=;
        b=SZTTFDX3cidmr9RK6szshRLfalUjMJc9pu7CgAnLI7ez3nB33MxcWKXtamplwIu/IR
         zebyeFWdJfhc8GPRUdhNWyYhkkBhvSMxNEfs9JM0OpmTKzSP1t/3j1JFWFa6OvtYczD0
         4dJ2oNuVw0TRhYLkyMUe4oo2L31fCs6WzxVLKPU7TpHWVjO+xwbABDCUwIJFL/tJDrlU
         9Qevm6og5uRSxz2AY4ZLg9mVu/edLiBtSKZuQyakxOtUvYF/dV+jCefDv5l+2BrGDYUs
         VVCy2ZalEcto1pe+FmlZelOTAQDtX4+4AxS4F2LcTHDQDXNHWHswi06KMpTNiwo9ZUGW
         em/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794613960; x=1795218760;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=V6Dc06AwxOqv+YtietBML1RlnbCWLY7fPYdPiA+3csI=;
        b=dvLRqJHEO2Q+6VTrO5grM5e+ImxYafeJuF7UMqR8mSWOmAl/oK255nZ2sjLM/bhLsN
         NWTVFTD+WsQ4XvuX1b0Kt0zrJgsOhBMHhzyOZPYuMG24vyaH6ebajXsPg6xxPBdqxBgT
         MIFiZz9D2fh+uJrYCZ7tiRaIdTFWiK1rGYM0erpSlPRXukAUpmHaMX4vzOE7vAQYOKqR
         WxFAMSmfFHv1bLwo8zI/eAzwY61LaA5X1C1pfxQUP+kmAdb15T0+miULOmv2JjA5PwxC
         fPAInti8ybceTZMu+ZHCoi5e/ykfPwoU0yk2dsb5L9bfTFIt5VHA6xfu2J73dMbk1Ua9
         m04Q==
X-Forwarded-Encrypted: i=1; AL+hErHGk6J+BQd7C6cG+Sl6oUQdTT2D9jf2M1AyU4vlmlDDfEyNDBTqMg0HJv0zsMJTXS8Lz6SzBPNjXw==@kvack.org
X-Gm-Message-State: APuU4Z/ky0OFDk1ATu7PzErXVW1migxl9kJPmVyiuUbb+Q5S1JgbHJIV
	nb0wtH6xdpKykLfMMwI3pf4uE2Vwa5RO2uRdQnJmvcQmi9e7rCgTZBm1
X-Gm-Gg: AYBFou3to4abzZnvqx+Gl+Ym6uAT2VUXzDk3PMX6PfWFHjCyJ6jkQxH2wZ2DlqV3kpr
	Vth9VEUV25mUihInQKzR63+tioRPZpRbCXF0GxiKWN2gPGXNBQtNbTACNoJwV+1azn5elRr0oep
	VuWrqHo7p4HpNiHyjCPZrMnMRcBF2lqcU8NPLhkaHCTM2gG+PgYazy57ol2p2ghbm+vCZznzD9T
	5dU+VjPVXz+jopz9GVljTakohmh0wlPlMafn+ZYfwutRSoPybVbzkasmZG1CI1VSfAMp1WMmnFy
	OqPITw+xL6lg9QpVWUYgoayZQ3gsN7x+rz2KAW7vNegaOFWcatNLMev7zMp6pk2QHA/P/eTireR
	LlFCZl0SpfvNQJSSTv+BulRi30Y+gM0hksH84xhQN4M5CElAljh4msYkJGNQTKf8Xey278xrV6O
	xneat5iryQQbjESoWNVv0Mf6SRinevhNn3+LOGqC67mGjePpUwyFTlJstvG9kAFKstdki+bFx8U
	NI/bsBXSTkg1cwOQdci2jMqy5G9gluDjxcr2JOq5Ef+Z6gyCmdlSGVkMu+ci+AcP6SlikRXOjJv
	qAt2MF+6Cxrm42usDYuZbmB9adF8RaTC3v4KbuiNDHOE1k8AJ8roQuOHQHCb
X-Received: by 2002:a05:690c:8d07:b0:8b3:5eaf:29fa with SMTP id 00721157ae682-8b4aa3d36dbmr26756697b3.55.1794613960093;
        Fri, 13 Nov 2026 15:52:40 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:5c::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-8b4aa9870f7sm32719387b3.24.2026.11.13.15.52.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 15:52:39 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 1/3] mm/page_alloc: drop unused gfp_mask from zone_watermark_fast()
Date: Fri, 13 Nov 2026 15:52:34 -0800
Message-ID: <20261113235238.3595412-2-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
In-Reply-To: <20261113235238.3595412-1-joshua.hahnjy@gmail.com>
References: <20261113235238.3595412-1-joshua.hahnjy@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 26095C0006
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: eb7e7to57d4gzxtr87cr6548nzks337e
X-HE-Tag: 1794613960-667572
X-HE-Meta: U2FsdGVkX199jdT85/F+rkqBswOT2MFZej3oFAQnx0UKzUoKkMhxjhn88HBkbmCFjCGFHPcmpKtJeARrkG8GGlObv0MTU63hkB1CiDpoPfNs0AdoWHWsfP9bzVne/Q9tEga2CVW7sjQfOCnwOqeE7fPpgicH20h4VOWV/ZIbpQ3+kwhnwA91iznZ0z7LtRkGVun7ZOa8jHBsli03MlvNiLL9RVg1RwkhomeUbFGM+n6riHMvgka+x2a1RFW4wYajuQiO0lL4YOOyt+zpdAPL3lqoF6/tJZY5qAU05veeWyoCRhlCn2njRZlY36Y1Z5+20q0jNYUyAoRXDg9QwytG0y6FA3ZBqwj7OARl0sQWvmYrvl704NGH5zM6XbL5TVvcQ7txj1Y5XAVgQt404wbrNAICZslCZw8OUIu+sCLZdGfQoefEDlUFWnvbP9FxwRsRgXbHIrN2SyB8Fl9LCNd1yXT9D4vRW0TrtyBHtIiEyflgW05DWMCbd03s35Nvv6uuPCblBg4VKbYoL9EOxLhST/+fLCVNvaLx8mpLpKg7uJxVzDdWPLyJ9zR9I24WyrDr6lCzodFG5nIaW7MiLg/wHyTQwBqpgK59WEncknct/EX4RnJEJSdSCjMXj2BoDpQuN1Q9hXqiS6Ioofv8MdVrFv9XGGCzo65lNOCkDHjbGN5KehaVI4S8+kJdHKhKJhiQoawPkwksnsA/s8c+yEI/lRRMBAn5H/kysgYMpyxfLE3uI7gIl8XGkaknAK1QPW+GVvgt7OAE478kEJ0y2lb0lQltD95Imjcq6cm8mmzx0sk/EFFdLz0oHyIkdfMG8WUsaao4d3UDQM3DhjVO2IUrqwk7GBN6xrIjwHgAXOHpepNc6+xRFBme3pieUMvRtcAjn/PsD6ldSvpU3virGnKSNnAwIvrSP/HjdBorKgQruRLF/4dVaDJBRWDYni3ySibv4AD0dX9HJk97aV1mguY
 TiuN07TQ
 DrJhCSkh+pzCnpheJYXk6pY2Rs+MkzCwObb13XTdOXXCA6eCdAnDr1wEqSH9AIM40Zw7uZeWflJZpGNCzuTUrFxjxM9krvqopQfZrDcGC2Z+0R1g96JlXq88XEqueGZ8kTFS8Ez84myPyh+0W3dg3FqCahsZvZHV69Zzs6+M9tOAUWrZU1DxdbmiANsfi/XtrqL4jX4MxfRPRISep6ij/qmbtgme+OioODZy+XQJELqnQP3Tgeq4PsFei2bUNgCD6cnUqccEoAjA8NifExmGXr1MAL09iXH9gzqnYgP/xreH0cY7wzILUi962q9lGJf/yzCmDtTabBysFtTsbbN8H3SLIo+cOlb4B1bWc9Ewr6p5l5XuIPDrXLEM6IX1oQA9O7ElxVjimGmo1Wht0vrw9InYAEmsBfYle2fYyl1yQ0FJOEt8KYyr4PxEz2agpL/pScT2YvWrGUNOlKrMlkpUQyaOpsu3rkM66yJxjEyKIo2KVgdmQyO92/Q2PskCq2rGFagWnIhAa2wXDLH7r8b8wTUb8zR3Sjvt8nKkEfwxR9C6uuwI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

zone_watermark_fast() has not used its gfp_mask argument since commit
2973d8229b78 ("mm: discard __GFP_ATOMIC") switched the watermark boost
check from __GFP_ATOMIC to ALLOC_MIN_RESERVE.

Remove the argument, no functional changes intended.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9e1261521b6a3..4d829e5eac49d 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3675,7 +3675,7 @@ bool zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
 
 static inline bool zone_watermark_fast(struct zone *z, unsigned int order,
 				unsigned long mark, int highest_zoneidx,
-				unsigned int alloc_flags, gfp_t gfp_mask)
+				unsigned int alloc_flags)
 {
 	long free_pages;
 
@@ -3877,7 +3877,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		    !waitqueue_active(&zone->zone_pgdat->kswapd_wait)) {
 			mark = wmark_pages(zone, kswapd_watermark);
 			if (!zone_watermark_fast(zone, order, mark,
-					ac->highest_zoneidx, 0, gfp_mask)) {
+					ac->highest_zoneidx, 0)) {
 				skipped_kswapd_nodes = true;
 				continue;
 			}
@@ -3897,8 +3897,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 
 		mark = high_wmark_pages(zone);
 		if (zone_watermark_fast(zone, order, mark,
-					ac->highest_zoneidx, alloc_flags,
-					gfp_mask))
+					ac->highest_zoneidx, alloc_flags))
 			goto try_this_zone;
 		else
 			set_bit(ZONE_BELOW_HIGH, &zone->flags);
@@ -3906,8 +3905,7 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 check_alloc_wmark:
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK);
 		if (!zone_watermark_fast(zone, order, mark,
-				       ac->highest_zoneidx, alloc_flags,
-				       gfp_mask)) {
+				       ac->highest_zoneidx, alloc_flags)) {
 			if (cond_accept_memory(zone, order, alloc_flags))
 				goto try_this_zone;
 
@@ -5245,7 +5243,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 		mark = wmark_pages(zone, alloc_flags & ALLOC_WMARK_MASK) + nr_pages - nr_populated;
 		if (zone_watermark_fast(zone, 0,  mark,
 				zonelist_zone_idx(ac.preferred_zoneref),
-				alloc_flags, gfp)) {
+				alloc_flags)) {
 			break;
 		}
 
-- 
2.53.1-Meta


