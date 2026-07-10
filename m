Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DE87C44501
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 02:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22E196B0088; Thu,  9 Jul 2026 22:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DEBA6B008A; Thu,  9 Jul 2026 22:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CE256B008C; Thu,  9 Jul 2026 22:47:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D0B8B6B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 22:47:04 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 567E516938F
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:47:04 +0000 (UTC)
X-FDA: 84971329968.16.7DBA243
Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	by imf06.hostedemail.com (Postfix) with ESMTP id A0E73180004
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:47:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ouga4UAz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ahacigu.linux@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=ahacigu.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783651622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=p6nnrWnfSd1WjruGGyvcLkntIHQ6kTbFpN5Ah/hDWRg=;
	b=yNOsG787X84HXFyraxEtX7hPgN+frx3mCsE+ZsQ/2i/4vsgTj5y9JEnXfGWwb6l8rTx3S7
	ducnadgZRuYhjjM3yp0U0I0ev1NsuLMG8TGkeqaJh/efPjk2rmZQewwjv30XOiezn023Jf
	Qv/N9Bq1YaXKo4P8Q5Y5QAngodeZgzQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Ouga4UAz;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of ahacigu.linux@gmail.com designates 74.125.224.48 as permitted sender) smtp.mailfrom=ahacigu.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783651622;
	b=vKYpJ/iFISWdufLZwShi3GXkcJkb6eItl8aQfHQ4seLkvUwzutWnIOi8dm3LxzX4GlUE9X
	ZKGzqCt+2UAMzlsJSssZAAUyRZ+XhB8ulcXXMfMUpvEETSsPo1SDGwli/RVEEleGgIsT6Q
	9cWcfyAr5um2oJ1ixYSG4G895y8ps7I=
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-664c535f1a0so784346d50.1
        for <linux-mm@kvack.org>; Thu, 09 Jul 2026 19:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783651622; x=1784256422; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=p6nnrWnfSd1WjruGGyvcLkntIHQ6kTbFpN5Ah/hDWRg=;
        b=Ouga4UAzHgUyIfoS3lSxMy7Fw7zNU2WWKwu1CxZdJMjVF8LqoNe3wUjzWmhuQ3kyl7
         kd3cIy4SCA2YrYWh3gwOIgswwMs/fsA3izRJf27doRv3SZ1M1oRTN3swnYcx4tF64ckK
         ZW6ae5b4koANZBZRo0/5JZIbxaByndx4qrUDlk750QwlRsqhL+zzmapPD6RvKI1fV1pn
         XZxuzitDSUMEGtLkxluwYyeRzWaic6G4PqK3xBpV3fJw5Vj6TN+rwm02/9qNwyft6iMS
         COKGBGoSLegYp5WuGazX4Xn4Q7GbPu7IPbt92Caw4B17fPdt4DRRMMLr2X/pc4gSPlJ6
         wnrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783651622; x=1784256422;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p6nnrWnfSd1WjruGGyvcLkntIHQ6kTbFpN5Ah/hDWRg=;
        b=Lzx4ZZCOxEBP29t4h0r+Yk+7+i6gx7pRKhyGkJEQedh3zXmgl2DEi8HfYlkAo3qt4R
         o30R/R+WlRTZTeVZv36PYOob+pjACIFwmqPFaRjZ2M3RYM6k0/V+/1DoxZIE4PXwE0CZ
         qdZOwWIq4PX//+lBaP9T8zNcumHdvpGKllspNhqYDeKuSlFc1b8RUll4QIEd8NkPR2Zp
         JJs5Nwyr//O3FVtr29j0I8m5iPszGPD6OSBz9IHejk8oaLs7vTDoHQfEZls+Xg8QlkOk
         e0tnX4QZji0/5dfCVnEtgCFu4G0c0hzj/+fFYjbkjXLKPghkQP1XNu86ixTt0Pw65SxF
         gBNw==
X-Forwarded-Encrypted: i=1; AHgh+Rrdor20bCnUb6EqsgnSNt16HlvjVBK3nW3WZiOuxEiRobqDczIxw5izhD7YNFbCQDSdVCRhPvFP8g==@kvack.org
X-Gm-Message-State: AOJu0YzuSHQSxf1SkpxNbGjdRTr/MOb0wYUwCFiNPQ27c7GoE7LhD9Ik
	gC5aCjLvQ8Qnue/aWD9FP/or0ILQbdnkvFkTgiddsHEGjfCCq3wT90am
X-Gm-Gg: AfdE7cmBTGVDd+2sXLYTDsWw/4OiWW5o7WUcBhiCN4kWGFFSCMPR6AAh0rE5UGsbwIS
	6UjYXlL0bNZqKeVc4i0/iwB2/ZcCfAPWAucD2cj2aA4nAhIl6vfYWEM8H8W1elrVof/4XxMlcvN
	8DVURSI7CyzfzvMMQX17oV5wdzUnR/J94iSQarP0wNIprFxxBhbqSOe708ZrFs3BpRpTqM715gG
	g5oMJt0b3Cj8xhRTxQVV0PH7s3pMFKF+B07C4ih4ZtGFGxIYb4iNYtuaxl+KXk1WSOzA2Gexl1y
	dTC0woBVwvOSL1xOysQ0gfhryOfQMf5gUWeGWiGUIMsSEbv4QDqhwgmuPyidU9kTLl+BypiGMKz
	Lv3ePui9FGJeMdLTS2NDoT3f3nV97lEID+QZcAeym4uL+TUCisLkRh3A08UBJ03XLCUgyua8znr
	An95XdNssfJhQ4fhb5
X-Received: by 2002:a05:690c:9989:b0:81d:75b4:925f with SMTP id 00721157ae682-81dbe9587ffmr78809617b3.19.1783651621543;
        Thu, 09 Jul 2026 19:47:01 -0700 (PDT)
Received: from host.arpa ([2600:1700:7c:96e0:2b12:f605:51ed:d586])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-81e6be8f5f0sm35546697b3.8.2026.07.09.19.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 19:47:01 -0700 (PDT)
From: Altan Hacigumus <ahacigu.linux@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/vmscan: clear hopeless kswapd when global direct reclaim makes progress
Date: Thu,  9 Jul 2026 19:44:29 -0700
Message-ID: <20260710024429.70923-1-ahacigu.linux@gmail.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A0E73180004
X-Stat-Signature: rk41ndk7da3pzwwo3n8hco7zta9ureqt
X-HE-Tag: 1783651622-297639
X-HE-Meta: U2FsdGVkX1/K6DJZJ3R8J30oheuzTCpcp7neaeSZl1IjDPM0E7Vyv8HajyUOrA73PURtoMgGDI2cfQFawPgFKh2Xb6MzXieG0JGM+aMJg3m4bb1QpBmEb2AJRgtUg/lh2YDteh/uvJNYiHTxEGsCO0G9YcVqbf+Nli+vSR/ipZLJziQo/gohQPIrOKXy9qXceGsVxMBWFhQzFoEowHi/pHg/tIN+tVfKymzD3vfeyyuBT2cgrI90FE68oY6jmle0DJfbMhm2lxRoCrCkvnba/kgzLIdG83jQUXUT73Mtiu8jr0u/lRHRh067jQrprbxDUqOb2T67lT2UTv7vi/KjAoThBiyL9RkUoOqUbturRWWsH1VtN/qEHNaGWbbQ4hcUSxwNs2UlejBHVW3LPUpCA/tlROdVV2fs9QUmgmw/MeHhrTfhc7h4nYumEz2ypAGK5iCdy3jjx/VzOzZ9qydQIyrWoSQF01wezoVquQkCH1UXHGcoCbRRaiYyNJUECzHvDe7J4uYi9pPoNWIeAejC0B8R8oNKczoae68zpNVu0Rg7C8iAWDzJggPA1VL6Opl+S54gRKFbvCSxoHbpGprG3e6kJugwLsr5r6T+ZC8456ZJ/cCXyAD7KBSp/pWoLHZyPk+sD9khaz6QkruaqfI5JI3xc1qZZkfWXbg6kNRhQPAiN0dUizd2naaOweezEr7aquUDKSOQ4941ZwBigFl2cfNt7Xg0reJJurw6VWboY5vfzkvmnUPbqGSZc2ZUv4zvmKHYGRHhArOZnUghJFmKCYUfFQaLYBxmh9bkU36a2uS/cBD+AeAs/IoEfoqRZYmFU48d07pg86KIgcXZF76/V4m0fgU2PxMx2n6vkToppVPypqM2YWVNSW+LWkStM44yDGsZxGD66NC1/Hzm/F1ayUfvK9MIphQaXW8/Xf3vurlYfa/w5MnAdapkzLtuxAIA0+pFnegotyGE1y/OHzE
 zDoj5W81
 U/gVxcFePuoEoBFNctFLiwN2ah5Qi46Rlxtn0gmt7ORQ4PCwS90vVbpakikqZqwCu1Cuq8vYlVWTuFkszPdfEmZ8aeannVh7JXggFQDmcEB7Fy2WHIjYjA0YcyxRX6HHtPE07EAhnn45fHUnEaBKNGMWwky+2HOYARxhs5/VSglfl0tk5T8H/Kp/G8nVVlZhbQiSOhtfIARHYmD8Ml+Ymnf33eOluAcjP4Hv0fBpKrlOQIlRzmX+GZewzzktaERYFSfi7wbJYbqONJH/7PY4IZCbvp4hX+etEUy+81td+29FYYqB8RTLB1w9mkoxwhrPXt7xpEFkmxMYxf0dBSmyAKZCko1at5NQ8RWs3MwjiOtbgu22P4ql9cEMeXjIHFVdR3Pf3OMbXwpMIfSMVYuhq7KNeAN/LFKoMtqDY4/TW0D9tTCsjVfAJvYbENkRLYgQbU+ldnh46/3/VCHU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Direct reclaim clears the hopeless kswapd state only once the node
becomes balanced. This avoids cgroup memory.high reclaim repeatedly
reviving a kswapd that cannot balance the node.

However, it also prevents global direct reclaim from reviving kswapd.
Under sustained memory pressure, global direct reclaim may continue
making progress without the node ever reaching the high watermark,
leaving reclaim to allocating tasks.

Unlike memcg reclaim, global direct reclaim follows the same node-wide
reclaim path as kswapd. Clear the hopeless state when global direct
reclaim makes progress, while continuing to require a balanced node for
memcg reclaim. kswapd_try_clear_hopeless() becomes static since struct
scan_control is private to vmscan.c.

On a workload with most memory mlocked and the remainder under sustained
churn, with swap enabled, comparing the same 60s window:
                              base       patched
  allocstall (all zones)    413441          6532
  pgsteal_direct          15889552        255619
  pgsteal_kswapd                 0      26079382
  PSI memory full avg60     13.10%         9.37%

Direct reclaim was already reclaiming many pages in the baseline;
this change lets kswapd resume doing that work asynchronously.

Signed-off-by: Altan Hacigumus <ahacigu.linux@gmail.com>
---
 include/linux/mmzone.h |  2 --
 mm/vmscan.c            | 23 ++++++++++++++---------
 2 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index ca2712187147..1db6f8dac927 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1630,8 +1630,6 @@ enum kswapd_clear_hopeless_reason {
 
 void wakeup_kswapd(struct zone *zone, gfp_t gfp_mask, int order,
 		   enum zone_type highest_zoneidx);
-void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
-			       unsigned int order, int highest_zoneidx);
 void kswapd_clear_hopeless(pg_data_t *pgdat, enum kswapd_clear_hopeless_reason reason);
 bool kswapd_test_hopeless(pg_data_t *pgdat);
 
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 35c3bb15ae96..78fd35a11eee 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -198,6 +198,9 @@ struct scan_control {
  */
 int vm_swappiness = 60;
 
+static void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
+				      struct scan_control *sc);
+
 #ifdef CONFIG_MEMCG
 
 /* Returns true for reclaim through cgroup limits or cgroup interfaces. */
@@ -5172,7 +5175,7 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
 	blk_finish_plug(&plug);
 done:
 	if (sc->nr_reclaimed > reclaimed)
-		kswapd_try_clear_hopeless(pgdat, sc->order, sc->reclaim_idx);
+		kswapd_try_clear_hopeless(pgdat, sc);
 }
 
 /******************************************************************************
@@ -6251,7 +6254,7 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 	 * successful direct reclaim run will revive a dormant kswapd.
 	 */
 	if (reclaimable)
-		kswapd_try_clear_hopeless(pgdat, sc->order, sc->reclaim_idx);
+		kswapd_try_clear_hopeless(pgdat, sc);
 	else if (sc->cache_trim_mode)
 		sc->cache_trim_mode_failed = 1;
 }
@@ -7530,15 +7533,17 @@ void kswapd_clear_hopeless(pg_data_t *pgdat, enum kswapd_clear_hopeless_reason r
 }
 
 /*
- * Reset kswapd_failures only when the node is balanced. Without this
- * check, successful direct reclaim (e.g., from cgroup memory.high
- * throttling) can keep resetting kswapd_failures even when the node
- * cannot be balanced, causing kswapd to run endlessly.
+ * Reset kswapd_failures when the node is balanced, or when global
+ * direct reclaim makes progress - then kswapd can make progress too.
+ * Memcg reclaim can succeed where kswapd cannot (memcg protection is
+ * not enforced against the reclaim target), so its progress resets
+ * kswapd_failures only when the node is balanced.
  */
-void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
-			       unsigned int order, int highest_zoneidx)
+static void kswapd_try_clear_hopeless(struct pglist_data *pgdat,
+				      struct scan_control *sc)
 {
-	if (pgdat_balanced(pgdat, order, highest_zoneidx))
+	if ((!current_is_kswapd() && !cgroup_reclaim(sc)) ||
+	    pgdat_balanced(pgdat, sc->order, sc->reclaim_idx))
 		kswapd_clear_hopeless(pgdat, current_is_kswapd() ?
 			KSWAPD_CLEAR_HOPELESS_KSWAPD : KSWAPD_CLEAR_HOPELESS_DIRECT);
 }
-- 
2.55.0


