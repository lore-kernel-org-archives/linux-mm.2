Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F19C71077612
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:04:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B05126B0306; Wed, 18 Mar 2026 16:04:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64DB6B0308; Wed, 18 Mar 2026 16:04:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E06A6B0309; Wed, 18 Mar 2026 16:04:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7B50B6B0306
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:04:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 27F83C0797
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:04:10 +0000 (UTC)
X-FDA: 84560260260.16.BA61151
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 58A021C0010
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:04:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="WE/8XnGh";
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773864248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+lIBKuihBwhIz7SacTrjJRS4SfXMfl3HnekVF8WIFpY=;
	b=fnLdogtt78meGWQe4oUY8DCT9VXGhDVllrdvLkSnXns+gTkNnaQCuoOkEPnoZJp0K1TL+W
	3xdZKlbuTMdp/S6UD9CO4iEViZjNgsIkIzYoTafLH8JSbOM/QDM+dy4uckVfpT27I8nfgP
	8bn4nr8Y9z04E97Q+c9aQ02R+xDYdy8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="WE/8XnGh";
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773864248; a=rsa-sha256;
	cv=none;
	b=yc/Jjwhuh5+dbTb7vqGNMoPWJEpDasZKmD6Qzw46ygmt6W8cCTAE2chTU0ZbdXEyrr1Wn+
	9i9aNctT4eDAhRNhWfFvsyZCRmBNjBgCKC5Y4lYBKxwU3FPvBPMKY8XNGa88cAp2RuJllL
	X41SO4rXFwKCjnn3fdGz2m4DGsFV3pY=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8cfbbf35354so8211985a.0
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:04:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773864247; x=1774469047; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+lIBKuihBwhIz7SacTrjJRS4SfXMfl3HnekVF8WIFpY=;
        b=WE/8XnGh3gg9yAwX3SkwTB+o1vOcH5B7PX2E8Jsln4gMiXuaqS1xVt7HDdhicjoWCi
         L0A02ZSkYE+1W39f3c43vOItlAqni7n2px3TgoPKxBtVJgxXNW46sF64QxaoNAlQR8pw
         uDbJlMtDr9jCYyPgV49n87hamX193f7G/z3NH6GnvaqsbDci0/uWgdH6PpqgUrsIVbQ6
         oBcLEMz5/smaFEuzdNZCrAPNs4T/WuI9/kYRWnhpRGMc9Ba6FeLfigQ36DAhlFT3nPB1
         ImWyl/GiQjltDl1ui/TKwuxC0Qc6nrfFasB3uQNFGAVelkQw0T9KN9kuSsYZ8hVYQJEU
         OVxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773864247; x=1774469047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+lIBKuihBwhIz7SacTrjJRS4SfXMfl3HnekVF8WIFpY=;
        b=sUB3eBezp4cQ4wTF5gbuGx/lYBiSHUinW0LoaHfUbuInCVrNyN0VXAPv7flD3NxKpR
         F7WjymU9HDHcJtumo8QYGnqsrmYhpTrVPwHCxXyUoD980dCZZGo6KvzgwW52PUu3tqHk
         NfuUwuv6eoNKfBqwIk7nQxqBn4LdfZd7N5kokUNda1RvbGL1eLKQIVZJAsj7H40KxdnD
         oRXR80UE6r31jN8Z/wExwpTco1Y+g4llvbxr3gNVmWdkKhjK3TbthWqJLv7EcHmojRD+
         KIzCyrszpBWB+2/sPpdTC0GKT3icZP8iYu9XQUL/OOgQPOaXaJ8yJaqvi9qYLiPQg/28
         XA0Q==
X-Forwarded-Encrypted: i=1; AJvYcCUxMMViYKlWOJmlYDZutR/fnSpIpnaycElirPoZQKzcS85T9BxuccZWlTVg+vsd92f85r55GPNFlg==@kvack.org
X-Gm-Message-State: AOJu0YxU5GtT2rFCDBIudKkhP621dReXy5l2Qz/hkA/DAMHPWgTABeeq
	jTUlexL+e8N9wOfMDN2YSA8ACS6Y4wq1aqpy2kkyhYdUXrdojBx7z1M0yQubWDoHciM=
X-Gm-Gg: ATEYQzx8xXPZbRkLo2L0dQF1ISVdItK/KJVwrKiaaKdenIWEJ5GsZENOnOwlcogvcML
	NNUEbluCROap11uKcmSf/gH96f/+MtsYm3m1EbCDIKYc+47uY6DNmehayz47AL/+N3IR2pKaJgt
	2V3dLqLTXK4dm7tCfvHMJoeqJPoIumTsQ6FfNRAQdl/siBE82SfoGEs09xVKk4+15H10KT4k3mC
	4UXyQqdMzLPcJ8JeOUx+We8GBBzFT+sw6q4aW3gp/UPkjJVoD/JrhP1+rJEpcvT9jIzvLr4N89x
	7N0ucfl1KWUCzMNcAl91sQNGOcPOdFmGcMQtNHHdR11CcbxWE29lnCFLxurlYqEQVvcaw3uQd4d
	GR3B4QM0BlWKJKou2XkvAI+36K+qeRZAHPs9uscoWcG30CIZjyEmK3ZxuecjGNV7IvuP2gGy1Xc
	Dfmmyf+MV/kLkOnmAjV3jr9CQem4ExC3EK
X-Received: by 2002:a05:620a:171e:b0:8cd:b641:b730 with SMTP id af79cd13be357-8cfad3a0f32mr663539485a.66.1773864247421;
        Wed, 18 Mar 2026 13:04:07 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89c6b9ec0fdsm27008986d6.40.2026.03.18.13.04.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 13:04:06 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/7] mm: list_lru: deduplicate lock_list_lru()
Date: Wed, 18 Mar 2026 15:53:22 -0400
Message-ID: <20260318200352.1039011-5-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260318200352.1039011-1-hannes@cmpxchg.org>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 58A021C0010
X-Rspamd-Server: rspam07
X-Stat-Signature: 5at6r7typoq9r3h9y7zq648jz75uahue
X-Rspam-User: 
X-HE-Tag: 1773864248-572264
X-HE-Meta: U2FsdGVkX19oraxzQiPbl2WdLLBFdLZvRHG8jO8CRi7CUI2ydq4wZxH8pJ1GxmkfpIpm5o0lD9nBu7st2YQOSg6Ds4rXFzb/i2CGAJbrjNIZdvdU5vp1BgimDaJq04Q8b9G1TTGH1BCI8Wi1Hk6U5M33LBCPbSixAh4T+OPEbyznjqqi3Am/7UyzCwIkpDfqte4hIibTxuiWn8PgDyvLDsZgPx/lcYn7f9RUXFXSRdE4dc1YCQ7mf0/OCg5vR+bgZrh8x13kBRKC4RMyHN3yQa9SaQELv80R+bAxmr+YhpcG79+1kK1QC2ost7lIu42EgTHuqqidbOv2zhWRv55g+RDGw1LX6Re03g7AA51e0ao87Y+Q1edWA15q4Zyn40XLiIgvTo0hpYxcEPYc8z2d87iGhUyU0MHi0x+Wp88pXw5fPK6RuJLMw7aPFz3St+hNV8nf0N1yZNk9tLJbFKNgN1ydD+2hZdLAohh7yC1XhbVIRodnccTclVeeJDH48XlYTKAVjeBXORkl8AZ6/fg16xX3KyqiuG9Bqjwqg96zf8ieGChtpKDvWQJGVBaeMoy9ro89H9wynamiKUvwIt51PFxLB4O3gt2+0riZ1hsLXoz93PhUptaxwiUN1C1927kiW3cjxgSiDoKzoHOCY01cKpy4Ooduq+7nn4rddeWfGm3YBMWJACBJYAivCjA7FzgwzoNYLb44q0RG9k+j4QgSVU++FcdWJP4XexzmjGqATIuPR6To0BNNdkMMeD4peJ0gu9RtzxPaYu1CVgh3V84ffY3QpOMO6y8MeI09M0mNIPI8dhPwzXUhDxL8ewM7qInDLZpRfkdpf1JB6t4b8k7imRDepITsntp/vuakkg68DBulyW8cXud4ivPoNmjYFsJbgWWgnyTnGOJAUlHf5hfGMHLyYqMJFkJIQIKV0CIFJCuTEBm9owPFzIMOdZ/3r5HPOduWE5MEvWrIqANk0j9
 ITDxfrCY
 g16uodrg+hHwMHEnCyBumMB/2Fitpd+mgy+Bpq19zFrRiDu1T5gYo0n0O3toBujaIFA71Ez1Q7GLhZfS9Grk6gT5Qpxd/q6WMJhk/o96EzJPRp3FEynsiS7cv5XW9l4UgymWiLWq3YCgzRGtA+CJ8eNk4raZWGuAq7G04N7w96AQlZObwnVir5/+DshCCGU5199h3zONBXzzcl+RZFVocgkJ4C7f4Oo1BNPIlvP9DWsCQySqj5D1irQqTg/YRmMUzSY/UWSIIEB2TBOmscedf1LFFoPkKpqDpYToagrTg/L4yFX7RZCTiYMWvOKZjnTwV0YBksIay2LAj/zQrzbClGx23PXA8RPLfltCayyrlMiA7hcUuKL7ZJgU2muoLxQhas0+y+vgXRrwK/kOMS9Dyq3q/lfIsJBItBOR5BuJny8zUigjifdteO4MMBkjnYynrqaHBcjeMWIOjhivD4laBZawz9lDpE9vT4pIsnVtjk90zic4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The MEMCG and !MEMCG paths have the same pattern. Share the code.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/list_lru.c | 21 +++++++++------------
 1 file changed, 9 insertions(+), 12 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 1a39ff490643..4d74c2e9c2a5 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -15,6 +15,14 @@
 #include "slab.h"
 #include "internal.h"
 
+static inline void lock_list_lru(struct list_lru_one *l, bool irq)
+{
+	if (irq)
+		spin_lock_irq(&l->lock);
+	else
+		spin_lock(&l->lock);
+}
+
 static inline void unlock_list_lru(struct list_lru_one *l, bool irq_off)
 {
 	if (irq_off)
@@ -68,14 +76,6 @@ list_lru_from_memcg_idx(struct list_lru *lru, int nid, int idx)
 	return &lru->node[nid].lru;
 }
 
-static inline void lock_list_lru(struct list_lru_one *l, bool irq)
-{
-	if (irq)
-		spin_lock_irq(&l->lock);
-	else
-		spin_lock(&l->lock);
-}
-
 static inline struct list_lru_one *
 lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 		       bool irq, bool skip_empty)
@@ -136,10 +136,7 @@ lock_list_lru_of_memcg(struct list_lru *lru, int nid, struct mem_cgroup *memcg,
 {
 	struct list_lru_one *l = &lru->node[nid].lru;
 
-	if (irq)
-		spin_lock_irq(&l->lock);
-	else
-		spin_lock(&l->lock);
+	lock_list_lru(l, irq);
 
 	return l;
 }
-- 
2.53.0


