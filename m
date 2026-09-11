Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB10FC88E41
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 00:18:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 421ED6B0099; Thu, 10 Sep 2026 20:18:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F24C6B009D; Thu, 10 Sep 2026 20:18:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E76F6B0099; Thu, 10 Sep 2026 20:18:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F12876B0099
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 20:18:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F0AB7A0627
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:18:43 +0000 (UTC)
X-FDA: 85199570526.19.A05ED3B
Received: from mail-qk2-f12.google.com (mail-qk2-f12.google.com [74.125.230.204])
	by imf13.hostedemail.com (Postfix) with ESMTP id 27E5420007
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 00:18:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=r0OnbVgB;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789085922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LhZIogGFAKBWcn9TqaxnEfdXlwBjbgcMrXypWpyrcPc=;
	b=Ny37tpxXDt0Bp0Fcq60894HBRJHrTkMp/ng38TvAv5zAxLc8MZkeNZznb5cY22lCM2MZg8
	UIX3SeK/ubfenD+EVtLQ3IVKsUZyBQz5cARH/ZYsHRz+4LVIE5fOBE2m6VUOUEsTLdy8eU
	iCUVF2huZp9EFDyxJizHZjApcO4YPlU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=r0OnbVgB;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.204 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789085922;
	b=NC9qNH2CWS9rkgYbs6Qmw0N349hP3J/DqQElApIU21ri9pS484vQrC1JupzZZYHEVvRfaM
	xijQtdUP6h5M68YPm3yFZK74r0QG+4Ox2Fs6K8ZkD15aiWQbKx6QgkCIoXBID7TOzUutMJ
	IKD9t+1pAOI9yZrpMh73ieiLW/SEQuE=
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910cadeb0so25207485a.3
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 17:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789085921; x=1789690721; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LhZIogGFAKBWcn9TqaxnEfdXlwBjbgcMrXypWpyrcPc=;
        b=r0OnbVgBH6WxI+iCUoRXqjwYAxtZ8PWU+DdY3po98VPpigPjTg0eYECWwN7YaMyMt1
         qVPK1RtwJvd0ABUeF25s4XiLdhe8IN9LO3g6Zts5ztdsz5VQlt7eMY+B44OueDKG09+X
         yXcaobpWbIX+fx/d+ijdhxefs1WL361CBSPzgVn2xX9FQVheZNzh62ylkVkNoiY2w5Jn
         y6+bqtvmkP1VsbahdH+MQvNe2hqdX9GWPrXtsncR/pctSPDs4YTGJJmMNX5tILbOfwEu
         O82L+X2cF/RSJ7C3+VOSgh7F4FLLqcFexa8p2ufZ+MO0esCKYWawhafRn8ONXoQZ0Abi
         YQUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789085921; x=1789690721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LhZIogGFAKBWcn9TqaxnEfdXlwBjbgcMrXypWpyrcPc=;
        b=BA0iiuOK4ILS9YR5FGOc/DgR3dnxvXHD/EwjGfLOUxTlFhL/w1v+t6HQ7wlrqcqk/T
         ZB9tLYHmKOfUOvKfm9acGppw5CQzp/JY5cbxQRvs3sdTIC8FlB4376OI+2WowDc5doYE
         JuJyAXQdWwYpsWNaaIcK4T+IjcFMyZa+rMQDXGcZ3ii+BYrgQA8zU3h6R53+lWtav7hW
         jnT+WD/p8clsiyY5S3cIpd32/B8JVyJophpNa2So04h5mgpMpOQhMoT3PeE7gqAjcxtL
         XXQYH0M8TdtRb2ufdT0yH98cW1PemvPkqYsf/pXyBsoRmINcSifIXzhY2CHXbai+U06G
         RL5g==
X-Gm-Message-State: AFuF++nREg6UopApC3j7LL2RdxUKLtZ1sajSvHoVYcZRe71WvcjzFfpD
	9vY9IwICWh30/xYDIjttmh/LLK4LoKCymI9RAa64Hv4n6lRGyeZcdvYfbXUkDJMsPXVjpo9oHEv
	Ygi3D
X-Gm-Gg: AYBFou3W7wB8ilHrhE+Ua8RMi9Kw0yPVngbcUNL/4D1I5PLTrAFwsg+E6250n54sV4v
	3QSqiDuKwGOuacw0Ul4cmZHZGCGrWLS+P8zS+FWD2wZCOG3APCFloSUryEot62qP/oWj/hmpOHU
	WFEjPohMK/q2WkJO4Vhtd/YGunNZUqqUbl7MwNKzQuNzNfAQWUKrpmGn3Taphe20WF5o+lBTNpu
	Pxg8A1UyldWSgRvdfBGv+0cTKrGD8mFKqYW67r2GCfa+uAv/9Y8xvYa5lqp80i8IHwd9OQpZy1L
	0Jtq/iMdsVdqqP68S3bpiMgwEEwkJP8BQ4WA6gH1nv3yD5rOINg9JPwboQ5oqYYPHmPQG5FCqwY
	lqWyrq3Haz7wNAH86qLEeoFMh+qzkINgK8CghX24KYERoUJOU0xSwibwbQwidycCSoBIfQoPgF/
	NQ2VO8mGAJrrhJyx3d68+gI0JLM82XCXM09XRv6/yje34XElFuQqr4Mvc1nNMCMe70/oSv/+afL
	dAC2GEZWzuf3OMyF8HXOFTgydAl2sZj87gYddYuHKb4wOs4NCxLGLJkCNuaAGuV4vX5990=
X-Received: by 2002:a05:620a:4109:b0:938:fd60:4f9 with SMTP id af79cd13be357-939ea16a07dmr234110685a.27.1789085916408;
        Thu, 10 Sep 2026 17:18:36 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-939e80e4c36sm108896485a.40.2026.09.10.17.18.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 17:18:36 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	jannh@google.com,
	pfalcato@suse.de,
	osalvador@suse.de,
	hannes@cmpxchg.org,
	raghavendra.kt@amd.com,
	stable@vger.kernel.org
Subject: [PATCH v2 2/4] mm: allow shared folios to be promoted to a fast tier
Date: Thu, 10 Sep 2026 20:18:24 -0400
Message-ID: <20260911001826.2109390-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911001826.2109390-1-gourry@gourry.net>
References: <20260911001826.2109390-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 27E5420007
X-Stat-Signature: e4786tq38o6kebjchu4sz66w4cn8rnhh
X-Rspam-User: 
X-HE-Tag: 1789085922-443842
X-HE-Meta: U2FsdGVkX1+W3kXOJvhLcoP5nx+4UsIGZC7TLZqUz1O00BbUQC1e9RpObNSnrOWSfNfvzZ2b7AT2c9zEtxUwaItLuLyXlNXnLO0lBgF+9Erp9tllVMakOmtx95foFQt6DnBalLZVtsLdZvOwSbS/suR64TqEjgbdSU0PKG5nEnxGv6bPAzdNdS3y/hNKgW5AqdDc8D/HmAn0Z/5QOCo000Zw0ogH9gHsjKe74LGobUCkHFUDM1VISwwNZO/1NX0eetAaMBW6Q7eD+Y7PQPEUSL5kvzvvNFCuy1u3nNzZDo9DZAw+qM5f3v7KWNRgsCPo7hpTWiF1DLGhc8Qr2jyeT1LTO3jfWJryINqhEu4nj4MFEMkHNnkOoW1lh0TtNBJQF2d0zlK6GB/dvHt6/QGi97Hj/xb8OKKKLj6zd1J7qy9AH1R6JTFAbhws12aGvVQNXB8OhODsodPr77g7Lac8I6RUoinagP2i8HIyUkfuJ7eK2jTl8HyijjKekA4YumhZAIw85gKlKIPjodLJmHCMfajh9FOr7zAEWoHnQqJA0LWzjdPrFnvzBXqiWJn50BwCfENIg8sWMw8jI/H/xTtIdYOAyslDa3vWzSwRIhg3fBrA2bSHfZhohg4vGoD1q1eNchNGIy5gmU0wcCBLFeUWoJCWV0bX897ky3lCD/HWU6k0q8q8J7OWBE7xvS8LrE41Uv2JeKKeScinLCMSIua8dFLV+CaETrxYras31UCdDFL4v5ZNA//IzqM1Ww7ImEdXB+oI1felLF43wGlWA9Y1rxKXFLala/IUYpJ7bazNx98FgByMGG2ygV5jLdGQ3PMMfmIpjQi5joi+vbf6KouRq6vW1ri4Hzhi/1hoYS9YE6qrrd+MgcxZnreUUsCpxs+9/MFUP7eNJZw9v58Zec0Z7X2ykgaHX6qXQj1FvwpNJaNy6TrZJDuFzw0tnHsrk6sJm/dKJaolDaplFIWRI0G
 Yx6Zcwfa
 OI7GYwp2uL5JW7jraYDpzX5NrtGVXbrRelSk5ISw455KdTM+9YJC56bvSSheLwtxyXb2jXHeBm2TFxNAhdzvK0o4RTeYV9D/n20HLz/BlvODsQ8ngOZf08CJm/aSjSmXEDZlfpy4fCn4T/L+Vqn7SHcbt4AzQSSvXTP5Fy3KNiZgR9t7JnvIouQB6un+mLvreYil2wArQe1pPd2D/sPkaMtaGcdnB3N+DR2qqZij0ZyojMkZ7sIS9WB/RlLs29cL5F4HUsxp+HzDhuTnlqOqs/1jZfWLy7rKOWkgJLaR33rKB7LI8EF98vu1qsSjCpdjWV56AXpBCtjCtkUhinBwpls3TVFznX8rWuoq6UgHZPCEhiMbrYWNInoGivtjMIfRZ4R4tdYyprSdzHTCJsh6k5/LOTg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Gregory Price (Meta)" <gourry@gourry.net>

NUMA balancing rejects shared copy-on-write folios and executable
file folios mapped by multiple processes to avoid placement bouncing.
These checks also block promotion from slow memory.

Allow such folios to participate when moving from a slow tier to a fast
tier. Keep the existing restrictions for ordinary placement.

Fixes: c574bbe91703 ("NUMA balancing: optimize page placement for memory tiering system")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 8 ++++++--
 mm/migrate.c   | 6 ++++--
 2 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index a082ccfa09ec..19b599bc2dd1 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -863,8 +863,12 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
 		return false;
 
-	/* Also skip shared copy-on-write folios */
-	if (vma_is_cow_mapping(vma) && folio_maybe_mapped_shared(folio))
+	/*
+	 * Shared copy-on-write folios are poor NUMA placement candidates, but
+	 * a hot folio on a slow tier still needs a hint fault for promotion.
+	 */
+	if (vma_is_cow_mapping(vma) && folio_maybe_mapped_shared(folio) &&
+	    !folio_use_access_time(folio))
 		return false;
 
 	/* Folios are pinned and can't be migrated */
diff --git a/mm/migrate.c b/mm/migrate.c
index a369d0c95c38..afd9c97d2389 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2697,12 +2697,14 @@ int migrate_misplaced_folio_prepare(struct folio *folio,
 		/*
 		 * Do not migrate file folios that are mapped in multiple
 		 * processes with execute permissions as they are probably
-		 * shared libraries.
+		 * shared libraries, unless this is a promotion from a slow tier.
 		 *
 		 * See folio_maybe_mapped_shared() on possible imprecision
 		 * when we cannot easily detect if a folio is shared.
 		 */
-		if ((vma->vm_flags & VM_EXEC) && folio_maybe_mapped_shared(folio))
+		if ((vma->vm_flags & VM_EXEC) &&
+		    folio_maybe_mapped_shared(folio) &&
+		    (!folio_use_access_time(folio) || !node_is_toptier(node)))
 			return -EACCES;
 
 		/*
-- 
2.55.0


