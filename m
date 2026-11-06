Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83A9A606A32D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 17:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=f9FWjavz
Received: by kanga.kvack.org (Postfix)
	id A01566B05B3; Fri,  6 Nov 2026 12:42:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1706B05B4; Fri,  6 Nov 2026 12:42:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87ADA6B05B6; Fri,  6 Nov 2026 12:42:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 526436B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 12:42:30 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF20240172
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:42:29 +0000 (UTC)
X-FDA: 85405413618.10.E9DBD8F
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	by imf23.hostedemail.com (Postfix) with ESMTP id 25F23140003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:42:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=f9FWjavz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3ghHuagkKCLsuknfsdjfshpphmf.dpnmjovy-nnlwbdl.psh@flex--tjmercier.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3ghHuagkKCLsuknfsdjfshpphmf.dpnmjovy-nnlwbdl.psh@flex--tjmercier.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793986948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dUFLil/A/qxmQAsi18K2mSML2dlbE2/nzQZ4zVZkdWo=;
	b=LhGbsTIoyh0oDSxCNg9se7szi8O5g9Z7FMoSCO4zJk1SB98qWScUy/vjcjoV0eOGl+RxFY
	DQ4E5sma7d/t78QbG8nE4M4dpNFX0nzyt6iJsNZxHtAsfo4nrlisRV2N1zOFvSz7lfP3Vx
	PkE1xRzEZ1VAPna5VorrCigZZrRRh9M=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=f9FWjavz;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3ghHuagkKCLsuknfsdjfshpphmf.dpnmjovy-nnlwbdl.psh@flex--tjmercier.bounces.google.com designates 209.85.167.200 as permitted sender) smtp.mailfrom=3ghHuagkKCLsuknfsdjfshpphmf.dpnmjovy-nnlwbdl.psh@flex--tjmercier.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793986948;
	b=YsAPj5m8oFVffyjWgt9RuYBtgCItH8mrlKZB1KT9pf1kuTWx/2l07IchbTMvOB/OVdwtHV
	kiroTAHhPyr2ImPa6lOusxtQ5y4JYjXNUaemF5+ANXjk+hWzrtMSrenm1/opTPXDW296L7
	9r7av3FzhEi43Ty4zcS8WddowMJH2IY=
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-54dbbf252cdso1192846b6e.2
        for <linux-mm@kvack.org>; Fri, 06 Nov 2026 09:42:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793986947; x=1794591747; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dUFLil/A/qxmQAsi18K2mSML2dlbE2/nzQZ4zVZkdWo=;
        b=f9FWjavzU1hNaFljtKPPOJcRS9uooGUpHCRdFSYj5gwrBnJDa8RNM1xbj6K8+MSaOq
         xxnrmuH51GaOZipt0+2r894tFY0Wgfj0/gRqQf8/lmDXQGt8U5d/wrnz+wmYKrLD09bL
         Ndr30I/+p0iDpkyjaMv88L1JA4eAXy6waFCmSnzguzARMUsJSWai0E0RmRxQ6RR0VVzH
         um2EwbpDZwTkQQWgb29X8iVn/pLZ4H8/RGI62PwB0WAGDnjt+5xEnc8qWZy5Td5i04eh
         kQh06KBxcHFZRT5ZLfua/q8ksMofaer+QWhi7fLSyodktRarWDWuha/Z6q8SY9x8O3tV
         hobw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793986947; x=1794591747;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dUFLil/A/qxmQAsi18K2mSML2dlbE2/nzQZ4zVZkdWo=;
        b=Bj+n6gel+/NYISJ5mPsz7oSMnWGwlNAxFt4n0IebBJ1Azgr8Cpx2xrl3tHuuG7VHoc
         qcUsueYU5GHjnkT+Ig4XZjQo/ww2McXHJ3U3ummSi17zq1pgcdqyDqm+B0+fnWIqIIH3
         0oT/6W837/oAhVPQ+tO1aGozi/3syQNgmZQmTjRDAFrJSuj3hlTo7i5cD6v8U7DGHTCx
         5RWG5fEFsSEmYHwrAVckYHIHyqAzvQ+BeWX3+PCfzg2wLAGSLH2Es8oxBcnQMnhL6NMM
         v5+H6wNArdSKbQSUH2taJ/sBlTXGX81/PUD7FPtMoD0xCcedlFWfHDcfXOfeAXkOQA3n
         BQqg==
X-Gm-Message-State: APuU4Z8ecE24YmG38PB1xgwqbAfKnDoy9rC+BAsezVKaARRE+wC/6bOk
	abNyGZILgJs4aiVPSEnghgYLaj73hohJ+sDblmB//Rew78KZs9ftTHpSP4UCU7mVsOROeX+fQVN
	RS4+IgO+o8J1soJDiiQ==
X-Received: from iohc24.prod.google.com ([2002:a05:6602:a998:b0:9c7:7f8f:934f])
 (user=tjmercier job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:4f47:b0:4b9:a8ac:480 with SMTP id 5614622812f47-567e14d9facmr2577739b6e.30.1793986946809;
 Fri, 06 Nov 2026 09:42:26 -0800 (PST)
Date: Fri,  6 Nov 2026 09:42:23 -0800
In-Reply-To: <20261106163056.541441-1-ehagberg@janestreet.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261106163056.541441-1-ehagberg@janestreet.com>
X-Mailer: git-send-email 2.56.0.455.g6c5a503b38-goog
Message-ID: <20261106174223.743929-1-tjmercier@google.com>
Subject: [PATCH 6.18.y] mm: remove '!root_reclaim' checking in should_abort_scan()
From: "T.J. Mercier" <tjmercier@google.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, zhaoyang.huang@unisoc.com, shakeel.butt@linux.dev, 
	qi.zheng@linux.dev, kasong@tencent.com, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	ehagberg@janestreet.com, "T.J.Mercier" <tjmercier@google.com>, 
	Rik van Riel <riel@surriel.com>, Roman Gushchin <roman.gushchin@linux.dev>, Yu Zhao <yuzhao@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 25F23140003
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: kz98sqo6qii6hxrbinjoebkzjskqbo3t
X-HE-Tag: 1793986947-570356
X-HE-Meta: U2FsdGVkX19C14jnnEhAB5Ui1Nh5IVSVTwvKcDTxzYes8QRaCNavcMkOFwF1tZzV6HWAPQcEWTQfzMx4b0/+DH9oBHuFNd4zfEwQ8X3VczQ4M8MMlo6W9M9wDDAlkSpIrxwW6WslPUhcLRsRlx0gRckQaSFYILG2gpdiC/UZR1N3nrbMqjGYwRBRY8JpcGsxFk+RzSWJIzQyrIRT8f1haq35WtKG9PzvfFMpWIjAEx0VyGsfFnTMrd8LvLUG2MnHbvNIYXbvY2ETHiPQVr71/nrFZxre8CDV2gBs015mGyVM5YbHdEJqDkA2mYE4vRBNWLxmlyKN+tTux+lVYT5+6GvaUWoYFi8JNh0opiKwTfZarZ1xCgl+lmKFAE4/EM27Vf3gMYY4a5IjgICn+KfGeDO2w2qUBTZRed5scXGDGR4dv+zNK/+dp2Bcf0ZSLGVtPGaE4VINuJ3Fnmveg6bEp0THmIv9PPLhdDYTP1aPOE/S5kc/+Zu1dyWLuG99qCJDL6SwFxPZXEt33KjCw7xcgb8clsOXtfZtdVAL7t3ZJMj3grTK4KecKdR94XuWAR8INyQ7LapYmmjhqyBTnYQ+kUrRB7RwVacpgGhRfix28mJ3GpsJ9Ot4HIXF9ywTU30wJwiLkTlRZcd1fE2uNhWRMjUEvO4RqqKHdP6RYRLteT60kh7f3kWBAZKCZnESavVNUA0yG4a+inrYfwO2H+RRmVAzx0WlNDZA0IzH9BNm67R/54zZLg2Z7MIsWoTDwAMSupDsLjTCKBtWwS6kxkMyNXCKQsNoJ1nn44YQ+WN9Q3EYJtEmEcQCAWGJYQq28/xiwUlQBruFQOg1hjLbfI18s4g/IxHOtupSgE4iu8E7Ynmg1qpcl7gU4nClQ/u/18zkH6q10jEnncp5V+7ykh2xMgv0jdoqnxCZCC5/fz2nesccUUjePtdCllQwUt14okxpBNnbu3e4fMfag3/neJ6
 pg++kxXO
 Tn+6WoyC8m9CU32VmuMWj+PbV+tPgjbj39J8qrvalGvtGvSDMhDBbNgok5J7cmRhm6ow/uiMrODkamO61VoxFUUyOsZcad4ChhdlyiC39g9LCC7+o/aOnVkxJIrSgJzjQ7e15u1FEterqMi26hOZBUyypTSo0wcXIg4apDkSjHPA1IT8mto+t4KvS4MSZom9bCHu2825ZSj8qzXPNcpo9RbgS1KoBR8aVmTFBJ65GRRmxslWqmGDIDEKq04gPKT8vcX7+oUbdG9edoaeRJG9RWI/j1KGMqv8y5pbQklORCnhl7y/J23tDXhpE/hcZmiDz5yQ4PFmOu8n9hRywVdC81qvUsi7TM9wsJ+btyrM90MzoOFzu64SCDNd1d8UDZSHmunzADA9f6m0HmCP28MHvsTKf1ntkAqEooMtuFj+kGZ6OMxNIEacPOw7fsV7Xf6b1U8OpiwqlgnJMi00vr8ayeuyO0xRgWzPRQBI+6kLfskxj/BKc+MPVkX1/ELDjAuFx7ET378jYv7PmdwEwhdGz09jmStR4BNtoRVSjgTDYrC9qAsuOT0g/vRqUnEmojrU0MEfyCM1i3xu5KIXThGRUXxp8YenCyw8BO22V9NoE3vrqj+0Aj9N/xfX3vFmTsDoHyEk1+C/N0/93798ErDNpTB/0l7PcmS98UDz8t96FrBu/rIO9omZ0FkfwTa2MmUo/ZhJH3e3Dthh9JViKmi5VdxFeLWK7bZf5icaYLjN0FUL4oIvGdoECJ3mgrvOl2IVnPnp5zZerfakubV7s57W3X8jerrj7ex+cnF4IA/CWMOpBSurzwfPm4ECfPmEdjocF3LP4qI6faQQqbOX/ulfKj9VrXdYehZiB/HRrbnc3A4OGvDS0PacGb/iesCQTzgCv/P2VGQA+clACGfPYMZopUn0LHWIjvfIHgt0FYb6CoIvDGX2njTe4dJdH+4BtBlu5Jsl1HhcdGY4EGOPSRuRnLAqE77j4
 gUIIeI2T
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>

[ Upstream commit 19999e479c2a38672789e66b4830f43c645ca1f2 ]

Android systems usually use memory.reclaim interface to implement user
space memory management which expects that the requested reclaim target
and actually reclaimed amount memory are not diverging by too much. With
the current MGRLU implementation there is, however, no bail out when the
reclaim target is reached and this could lead to an excessive reclaim
that scales with the reclaim hierarchy size.For example, we can get a
nr_reclaimed=394/nr_to_reclaim=32 proactive reclaim under a common 1-N
cgroup hierarchy.

This defect arose from the goal of keeping fairness among memcgs that is,
for try_to_free_mem_cgroup_pages -> shrink_node_memcgs -> shrink_lruvec ->
lru_gen_shrink_lruvec -> try_to_shrink_lruvec, the !root_reclaim(sc) check
was there for reclaim fairness, which was necessary before commit
b82b530740b9 ("mm: vmscan: restore incremental cgroup iteration") because
the fairness depended on attempted proportional reclaim from every memcg
under the target memcg.  However after commit b82b530740b9 there is no
longer a need to visit every memcg to ensure fairness.  Let's have
try_to_shrink_lruvec bail out when the nr_reclaimed achieved.

Link: https://lore.kernel.org/20260318011558.1696310-1-zhaoyang.huang@unisoc.com
Link: https://lore.kernel.org/20260212032111.408865-1-zhaoyang.huang@unisoc.com
Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Suggested-by: T.J.Mercier <tjmercier@google.com>
Reviewed-by: T.J. Mercier <tjmercier@google.com>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Kairui Song <kasong@tencent.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Rik van Riel <riel@surriel.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Yuanchu Xie <yuanchu@google.com>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: T.J. Mercier <tjmercier@google.com>
---
 mm/vmscan.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 2c66fbcd6e84..160481706b42 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4844,10 +4844,6 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
 	int i;
 	enum zone_watermarks mark;
 
-	/* don't abort memcg reclaim to ensure fairness */
-	if (!root_reclaim(sc))
-		return false;
-
 	if (sc->nr_reclaimed >= max(sc->nr_to_reclaim, compact_gap(sc->order)))
 		return true;
 
-- 
2.56.0.455.g6c5a503b38-goog


