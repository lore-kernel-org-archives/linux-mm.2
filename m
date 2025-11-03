Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14808CCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 07:53:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AF888E0032; Mon,  3 Nov 2025 02:53:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65FCA8E002A; Mon,  3 Nov 2025 02:53:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 527EB8E0032; Mon,  3 Nov 2025 02:53:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3C64F8E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:53:38 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D7F325C3FB
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:53:37 +0000 (UTC)
X-FDA: 84068531274.02.0993455
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf27.hostedemail.com (Postfix) with ESMTP id F010A40005
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:53:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=LI2sXFpl;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf27.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762156416; a=rsa-sha256;
	cv=none;
	b=3r9fOOZJx8On5jhSLthRvRI1KziZ1+UbYBUBQz6SL/E0IPhbh+HFxfj3hCi/hesWOsWYGk
	/zid6EPYrGKyX+sM8cumNNwYUMfQ1izVxkjnR9ePPc4ww17EGI5MukA30kOFOD0ctrtgNN
	yIAV2y1qVDZPav4ndx+rATzQhlSy7wk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=LI2sXFpl;
	dmarc=pass (policy=reject) header.from=shopee.com;
	spf=pass (imf27.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762156416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M049GtTJOIx1jAzuZfnGS5SMrlVlEyxlsar/o1b4yF0=;
	b=C/hMhmy9647XAJlPrLThC2Abt9wqKIPspBUOnfqw5G9zu4OZecOXSpljr66uHZCR7bm5aX
	Qf4FeeB6FD7zKcbeRYI2qfQRFHohnGjbCPIHB7yzFRmjb7xwNcFfxF/M3fvXTGPC6cXcik
	cvbqrfZIxGKiNG/y5miyHccTWy8JH78=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3401314d845so5453260a91.1
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 23:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762156415; x=1762761215; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M049GtTJOIx1jAzuZfnGS5SMrlVlEyxlsar/o1b4yF0=;
        b=LI2sXFplgfdoJXuheg4HPTqHfWvXkEvCRjdUpJ0CFoKBNFHHGVBEigfY5o+N+zGziB
         AqKx4uQtopGeu3szKVOHlzsgwqN+RWBulD/hKHHxncUr5m6RrzR9T9L2xVydBBFia7u6
         v71UcugCnvpogD+jr5SpXbJTQBBmEYfkxsK09eAurUP5hzdrT9mmH9TCBD4Hk1bM02XN
         FGsSQZC3blVtedN1IFmHjMRDOL+1KW/n9UvaV+5h7ntYAB3dGKMslKHmZj5in7U7Refr
         jc18drY6W7tNsldgEcewNGiAKb/LBWQvW14M3Osau5TLjtqq19pgRBIPL4NWQ/P1SoXk
         BYAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762156415; x=1762761215;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M049GtTJOIx1jAzuZfnGS5SMrlVlEyxlsar/o1b4yF0=;
        b=Cp6sCUlHBFpcKosZtb2pFCqnCOEQzFdHPklPHd6N8+lvbM9vfx/iIzIRcL5Hwx0isJ
         TQtftVX3qDTi2T6INyuwc/7FTySGjJAWAK3Ji+k65XKDrJ6+34s83+Ca9UidfcTei4lO
         cRhI3FWbKFVd4m38EMC2Udr4XkPjt6UqmMLk8pzqBKPfpPiqR5CG6P1XUL0fLtbfGQny
         FN32KntlA4Xx8npcvZoajdjhHnDsgDNxSz+ZHU4OECXh8ecZQTk8px1+6KhgRgyvJFxX
         hGTOJGK1Vweb/bHdZyYJmR/K8O8MO+2hVRxYqAJXP4dhemI9+W9zss2Q3vCtltuEEv/5
         dl1A==
X-Forwarded-Encrypted: i=1; AJvYcCXu3J5AmfDWM2mYRTTR5p4b0BVKCdu5Bov6r+upq2WJwaChrcW+aapd5cQQ4eiBRfW5cAPAx9MsvQ==@kvack.org
X-Gm-Message-State: AOJu0YxOqHtpD+DnnQ307KLkozRMsZ8fQuZriT764CYfPG4d/ZHGJs8C
	uXSJUm208pwiL77fb52NxkzImzwvIlNvP1ztyGGzjTjt9NJ8gQuB1Zk20MWVBAYFKqY=
X-Gm-Gg: ASbGncs2SAjsR682PFZNu9JlvhhFE15XRpzOmKIltbPhkWz6A7fBdAen6h85AymoI0u
	U8Bc8M/880i2/NdG7yLMsqKqq6tiE7psgtD7XwEu4Nh0ebKplOPVEXaxyKJL6rHv1ebgfPoJk18
	1teTkRx4V6cpwZPOxb4ufmL9bACj1gWiwQwQ/8YvB3swVBTJr1LMchbem+WJi00+2Un1X48N5KX
	Jqvhs+3xPoQ7EzDzAZYZ21gID2VAvPTZZvUvMGayyVbJ2u95hy5XRlJ8WxgBngg04UTBwOc/Wqb
	g7qzybPqaKGo2ALt5cZ03e1Nkzr4xEEOoxZsoO2ZTcihl7Pc3DPJxpHBbJ/vFVGoZKSTHjC02Bl
	pNPl2WtXWwv441w2bt2bL8GhlysDwhywt0vrlZe0i17/CGkchcOC9lT328pmnB+0/4YA7OOdHdx
	5qQL/t/dLkIemVaM4CNUw39ysP
X-Google-Smtp-Source: AGHT+IFNIljmMinHPhv4QokcHvxrVgwW0bD5RaqFND+JFxMKndgBolIUy2lVbgcYBW1Dd94/zRpM1A==
X-Received: by 2002:a17:90b:3fc3:b0:340:d1a1:af6d with SMTP id 98e67ed59e1d1-340d1a1b159mr8269845a91.36.1762156414854;
        Sun, 02 Nov 2025 23:53:34 -0800 (PST)
Received: from .shopee.com ([122.11.166.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34159a16652sm34552a91.20.2025.11.02.23.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:53:34 -0800 (PST)
From: Leon Huang Fu <leon.huangfu@shopee.com>
To: stable@vger.kernel.org,
	greg@kroah.com
Cc: tj@kernel.org,
	lizefan.x@bytedance.com,
	hannes@cmpxchg.org,
	corbet@lwn.net,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeelb@google.com,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	sjenning@redhat.com,
	ddstreet@ieee.org,
	vitaly.wool@konsulko.com,
	lance.yang@linux.dev,
	leon.huangfu@shopee.com,
	shy828301@gmail.com,
	yosryahmed@google.com,
	sashal@kernel.org,
	vishal.moola@gmail.com,
	cerasuolodomenico@gmail.com,
	nphamcs@gmail.com,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Chris Li <chrisl@kernel.org>,
	Greg Thelen <gthelen@google.com>,
	Ivan Babrou <ivan@cloudflare.com>,
	Michal Koutny <mkoutny@suse.com>,
	Waiman Long <longman@redhat.com>,
	Wei Xu <weixugc@google.com>
Subject: [PATCH 6.6.y 6/7] mm: workingset: move the stats flush into workingset_test_recent()
Date: Mon,  3 Nov 2025 15:51:34 +0800
Message-ID: <20251103075135.20254-7-leon.huangfu@shopee.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251103075135.20254-1-leon.huangfu@shopee.com>
References: <20251103075135.20254-1-leon.huangfu@shopee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: F010A40005
X-Stat-Signature: rauyyqb1yg1apicb36d9zgxsjs56hg5n
X-HE-Tag: 1762156415-68552
X-HE-Meta: U2FsdGVkX1/CHO1Aav7JO9XK8MyuO2vWjxUoC1oSE/oMW6ymGzAVPjG2Ch2Dv1z+mOYObWgHauHlO2E8JH7xlUAeTu7Dzoa1cDoOu1MNlfBHAo+yp+93DNdWDhvdCdMSTmZAYgfDm6anb4mJmHhgJPxeowkfoz3R9jzodRA3BDUuVWfOjJlkYr3GdETchzzqY+r/5D4cPn3Ri7v4a45oKUwSSjruMbxdzlEULVceWEJvrUf12OMQQJZtibTmbFzTNQdHW4xKmWFT98OOy2I3cjUzSXVPUxJoZOE5M2Nj8l+ABiN6+DVJVeLFl65iHcxNy44FUTxV6+COiZ4rWzHYjWIXEBnM1S8gTKvAxMAbg9LIF6c3jXFqak0xMf6/LOtUUOewVdLj2lTvDYV5RvRRPpqVBC6DwnRmmJjhokY84A76uBEiDJ6IzmQqbC5lmThTPXH9gpjFzl3sDVOUjpFSlZ818qDnQ2751jgdO7POnfJ4beTGwlmniWkLmLcoDEju7XrZLLQqLUhQBlVHME1RSB///8Sa+CFGDoxBw5BJrwKbiP4qV95mthH2n19amwqbXhReq8Pc3GuUIC26OSkL7gKzNFrH1sTm0cztusdkhu5Ae+33IOPUG2KVCAysb5WNqR6UjAE9R3B5hMlsx4ZIO2Lvrv0bn4yaShXHUX/R2nCKQPPDIBpOxYSnTp8htqGJy8E5nVhbW0N2RO70wqb5q0oZPK54lBq9YhBikR+h6FSKh6fw9bAlKAcm+t4HbWqAw433u33HEDoYo1d2Sr/xUoEsQP9gQxB2QcLaUP+0mjwdAwvPwCLiyCt5BnJaB7/xWlcYIRwV74HyAVmpCITCajqLeyvERh0C41xfgvAR9yNU+xpD0dgep6fnlJTlnI/PiqmD2ShcklaHT7/rkxP1/sNkYI6wO8hsVJNtTgBhhpIdQMaZceftoMDL10xtEm+qAmd+Gbp5typGmwSWc2b
 gcl4ZWZI
 N5lMY2iwGXZjFEA/2ywJEmc8SghMZ41QmBulstCN4kyqTqdkqtOWIqvUfSifvep55f6X4OZU7CJp2rJm3pXAmmddRW40WbQN3dx7IiJIBjQn6jQrZIbIEGxZUSyLzmF11ziy4MUGRYo7WyQ7l0eoFnNW5nfFO0zsnenj3lkPNiZG2vaxwfVTXAFBngOjzfRZ0SwUgPuGIIMd33HEMn/lBDNFS/m34VTncfI5eLW4WL5jEIDs+uMRVmBGhaAaRiAMKPzI29XazOkP+0hVoMUvgbfiALH313Auvv1L5l5CetBnGecoVjVDSG5QxEymfUbkfiHyYvp1M1vLT2X4PGzAU5HRhnQIiB8MUiZSkOxUuRvTtI3F8EMyjEynSNm9RH0TK3xl0DFbE/A5IOJTK6/bY6iabl0ygripBLFB1SUujK+aTbCwuB0gfvsOX/0fIG62bj2uZArDfyFjbSb/V3DskZTWVYlue3umzwoqS7wVrRD4ZLjAyIWI7P7o2yz1FvA3wymaDyuoVtydLTgkj5ncyJfFPZ7quhpB4PXi+dygF7vRSWkJC8Lt7ZdQNkQW5WkNOoWyDadmzV9zrO0d9BnU/mIsBrYa4DP7e8n3GUipNEuiTIBLRp/RfcezPTi2OvZGegd1ed4A2tTlxxNTD9oBF+QNoRgHYXNqKHisti4smil4CtM0oo3e0AMAB3s1iC4BMSZW5l4DLlxYTA8h/hMxqs4ZLBa3NQP6Rp7GB8Gy+koely9g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yosry Ahmed <yosryahmed@google.com>

[ Upstream commit b006847222623ac3cda8589d15379eac86a2bcb7 ]

The workingset code flushes the stats in workingset_refault() to get
accurate stats of the eviction memcg.  In preparation for more scoped
flushed and passing the eviction memcg to the flush call, move the call to
workingset_test_recent() where we have a pointer to the eviction memcg.

The flush call is sleepable, and cannot be made in an rcu read section.
Hence, minimize the rcu read section by also moving it into
workingset_test_recent().  Furthermore, instead of holding the rcu read
lock throughout workingset_test_recent(), only hold it briefly to get a
ref on the eviction memcg.  This allows us to make the flush call after we
get the eviction memcg.

As for workingset_refault(), nothing else there appears to be protected by
rcu.  The memcg of the faulted folio (which is not necessarily the same as
the eviction memcg) is protected by the folio lock, which is held from all
callsites.  Add a VM_BUG_ON() to make sure this doesn't change from under
us.

No functional change intended.

Link: https://lkml.kernel.org/r/20231129032154.3710765-5-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Tested-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Leon Huang Fu <leon.huangfu@shopee.com>
---
 mm/workingset.c | 36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 9110957bec5b..6e61ad08df75 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -425,8 +425,16 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset)
 	struct pglist_data *pgdat;
 	unsigned long eviction;

-	if (lru_gen_enabled())
-		return lru_gen_test_recent(shadow, file, &eviction_lruvec, &eviction, workingset);
+	rcu_read_lock();
+
+	if (lru_gen_enabled()) {
+		bool recent = lru_gen_test_recent(shadow, file,
+				&eviction_lruvec, &eviction, workingset);
+
+		rcu_read_unlock();
+		return recent;
+	}
+

 	unpack_shadow(shadow, &memcgid, &pgdat, &eviction, workingset);
 	eviction <<= bucket_order;
@@ -448,8 +456,16 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset)
 	 * configurations instead.
 	 */
 	eviction_memcg = mem_cgroup_from_id(memcgid);
-	if (!mem_cgroup_disabled() && !eviction_memcg)
+	if (!mem_cgroup_disabled() &&
+	    (!eviction_memcg || !mem_cgroup_tryget(eviction_memcg))) {
+		rcu_read_unlock();
 		return false;
+	}
+
+	rcu_read_unlock();
+
+	/* Flush stats (and potentially sleep) outside the RCU read section */
+	mem_cgroup_flush_stats_ratelimited();

 	eviction_lruvec = mem_cgroup_lruvec(eviction_memcg, pgdat);
 	refault = atomic_long_read(&eviction_lruvec->nonresident_age);
@@ -493,6 +509,7 @@ bool workingset_test_recent(void *shadow, bool file, bool *workingset)
 		}
 	}

+	mem_cgroup_put(eviction_memcg);
 	return refault_distance <= workingset_size;
 }

@@ -519,19 +536,16 @@ void workingset_refault(struct folio *folio, void *shadow)
 		return;
 	}

-	/* Flush stats (and potentially sleep) before holding RCU read lock */
-	mem_cgroup_flush_stats_ratelimited();
-
-	rcu_read_lock();
-
 	/*
 	 * The activation decision for this folio is made at the level
 	 * where the eviction occurred, as that is where the LRU order
 	 * during folio reclaim is being determined.
 	 *
 	 * However, the cgroup that will own the folio is the one that
-	 * is actually experiencing the refault event.
+	 * is actually experiencing the refault event. Make sure the folio is
+	 * locked to guarantee folio_memcg() stability throughout.
 	 */
+	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
 	nr = folio_nr_pages(folio);
 	memcg = folio_memcg(folio);
 	pgdat = folio_pgdat(folio);
@@ -540,7 +554,7 @@ void workingset_refault(struct folio *folio, void *shadow)
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);

 	if (!workingset_test_recent(shadow, file, &workingset))
-		goto out;
+		return;

 	folio_set_active(folio);
 	workingset_age_nonresident(lruvec, nr);
@@ -556,8 +570,6 @@ void workingset_refault(struct folio *folio, void *shadow)
 		lru_note_cost_refault(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + file, nr);
 	}
-out:
-	rcu_read_unlock();
 }

 /**
--
2.50.1

