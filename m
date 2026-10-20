Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47BB160A382C
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 11:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=dfmPitHJ
Received: by kanga.kvack.org (Postfix)
	id B05F46B04AC; Tue, 20 Oct 2026 07:59:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A41546B04AE; Tue, 20 Oct 2026 07:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 908676B04AF; Tue, 20 Oct 2026 07:59:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63CED6B04AC
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 07:59:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F3BB2160138
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:59:10 +0000 (UTC)
X-FDA: 85342858860.27.B8F54AA
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2AA6610000A
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 11:59:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dfmPitHJ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792497549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MSxyw/b1Z0I2OC6ruxOoDkUE/7o8+/pL3xgR5OEullg=;
	b=V3stQyCpZn6gug2uZ2qOSEzovT0T0mkV5qZMNO8VGa6GDGKdZxT1T006mNsF/iVa7/ITe+
	2tQRjj2aMQ+QVxO+BtmRn4NFL+eFP0Csk3JeNwLLgqI83ea6AU6SQjog5XnzfRVtmr08/C
	LnjoclUnueqhSb49WZ2IZ9wgJu5P/wM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=dfmPitHJ;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792497549;
	b=JxKOou1qi4jnKYbkScjNxp4GRPIMZVrGiuQ+F1Lw+LrMZADFIinFLM+OpeLOWaXGNIRLx/
	wFXhtk+YDQOOLN+M7r6C/YnGeR6n2r0v51ItyQikB0vDjr8Cl13UZ+Ue99eI9+kJ7SxKpq
	pSamcFfqYD5AiDatgrhvQ45AdguCEdw=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3ab9268d90eso1822282a91.3
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 04:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1792497548; x=1793102348; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MSxyw/b1Z0I2OC6ruxOoDkUE/7o8+/pL3xgR5OEullg=;
        b=dfmPitHJ6eQW5lO+V7Ki2a79Y9DE1cZ9e3rUYt9QmvRPoagg/6WDE8qABpdlkZb2zp
         UWNyfyxMlwGWmsvGXssE1EeVAr/YLQ0Hv0GBRPLMj8wwyDPidGMy/SXdzxIQfc+6wReG
         LJzduw3lFoUwOy04tL+RtYhEJELX4mEcf1h/6jZSsF7wYFoOjUDzK4mp1R7UkeeHs64R
         Y4En0HFtIsHB9psQt6Iwh7WQa4H4G5mjhVfI6MRlCLJp9riJ0QSDt2MHqtLvFyv0ysmV
         HIgs0XjmpKANc5Oqm1n+ovXHz4gjvtu8CNlvtOAUSfks343s1fBmxB9pVBaxkKg38OjJ
         ri8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792497548; x=1793102348;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MSxyw/b1Z0I2OC6ruxOoDkUE/7o8+/pL3xgR5OEullg=;
        b=IQWUrneTdqOuSP3C31KH3QmAAccQTuKshe79PT8mQwMuOOFkaGSKvuTAtw2hjZJ3PG
         h9OWO5kz7D72iEKL9rEgxqSg6J1BvCUX002GM+sRnNboHDq7Vtwiiba0cpUm8tHErOZr
         GNl5Qx66AJ4vpQ8Qr4beNtf7fcoMLNQgon6oEhMUVIC1EJB/I5VEFpqc9IXoy8mgczt2
         LusCGaoiO9ceRsdnZ3+l5dhbhIsX4swobf3HlWjqjiKmAN2Xm6sDgt7rxwVZ+GCcgr4U
         Kl8CYNPx5X9mBZTCcusF4FgjyOce+XX9n/K7HPnFOMr33H8SNtkTdgqgfYf6hH8DLKCK
         wpng==
X-Forwarded-Encrypted: i=1; AKwUvBxx6JeUFA4CJZ5IOHWUXZQXrAS5xYPNTglJgbfEmLMezff6zEO26RvLidhNhO+L0TgzrZEG+cSSAA==@kvack.org
X-Gm-Message-State: AFq9FYJLCCoc/sg/iL0G3PcF+uVwp7upnw/eXNeSI0guZqzbanziEmAV
	rpoWLt9xqB8rm7E8oGMvnAcmqZMj0uUP4xvjLVGiZG/kajwnio/xSaTqrTdGc4iRiig=
X-Gm-Gg: AYBFou0DCdRAD0jWDofTkh4WFXdo0CgKkEsokEVRLDRjLrilMzp2rojWSNWNtDnPzt4
	xGHZUT4A409MVThlOWEQ2coqmRJMgAjIOQthoJ4Kz4P83FlP6PLsnhsqEpLTOMg2cwYzmfhyi4O
	FZnCMdBFldDHRV8VRsynZWZNh3nFyvJSCmHWu+jAof5l0gTxImek97tSLWUX6wKruJhoxbRPMK+
	AyJi/EQQ8aq3x6pR+6+uuXxlF2eXGsLfBL+eXhEeKyYteCzKaJDjB+zPVBMYGCdf3rHJHnIuTkw
	6IKMcl5hr+RQlAyj3IFYTXracKimXNYcODcQNbmr48DJVHCxgEkdsoxGft7FWPw0Cz4ZxNgmR5i
	N4U+eI8LvPH8I5VDGq1xLL9gdh6gVBsXxxZgePGy3vZ7TJM5nKIHc7ltN0gXpbankUYQL+vNcx6
	FKfFzGPApcd9HHBynIzW9dO75FlFyM2yNGe3HNL7ZVvz8eXL+JI9DDQjzudpHWsWC5Cxzk3+//o
	EgqA9jtEPiYIMenM3SS9eNRfuiwh+dTDn7foy0f0j7s7PfrJ/HmpGhx74Ua1do55CLWQlcORCEu
	eLcddPNtHlUfYO3T7J8PftU=
X-Received: by 2002:a17:90b:3b46:b0:3a8:c0cd:57f3 with SMTP id 98e67ed59e1d1-3aceebc55e4mr8770103a91.18.1792497547969;
        Tue, 20 Oct 2026 04:59:07 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3ad60274fc1sm3448095a91.0.2026.10.20.04.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 04:59:07 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 11/12] mm: hugetlb_vmemmap: unify vmemmap range restoration
Date: Tue, 20 Oct 2026 19:58:23 +0800
Message-ID: <20261020115824.823278-10-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261020115824.823278-1-songmuchun@bytedance.com>
References: <20261020115306.813483-1-songmuchun@bytedance.com>
 <20261020115824.823278-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2AA6610000A
X-Rspam-User: 
X-Stat-Signature: au7b1qhspmxqeu5cxqt5nij7djfg9hec
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792497549-29408
X-HE-Meta: U2FsdGVkX18+f599SC47uvJ4+XEZJ2rtcDpPTEnhR8OMAMagRFpb5bLzmsrq6vrp56POzNyKY+XyotWIscvREz+H+uvPvpRAdEPtf/6hCXwLR/+8hrRH9O7YOIB2KTkjnmIl1ogE5U7ZRF0Ii/Qg3iC8coyKcJcRvIX22geoOuMsVYZOwlYZ6WetUlMdTfQ297c7tvAgo42GkoPi/p79/AlNuF0cOhgf07r9zqVxD5HIb/ctZEbouLOxn+uFyFp0BY5sf/ZBTAHinM+dooNiVUPZvshyk7cEetCrk5iHrnRkt7g6BsW2/i0KBl7WD9rKgU/nMwcbWHwVP9qJd2Cb82wur9lcRQdsRHCa6bgoqQHncaqnNsl8iswVwwBYEs46u5V9Z9hpnRpdJjUp4zOGCKDVzbCaakgPsEC6hX6UbDcQDzhGiQZLrPyK1dH28GbaOZtM9hypItxaQXSkAIc1rH4w4a+enw5C5aJTCoYI5rDGtjzkZYztwCsPITJ/qg3bDJf1wf6SNPXBfJbURvXuXlgt9XN5fQEagxbCmIoSwwAUdM9GEU/5l8MOb6JOSmIbsq1VI4zOz0n645ZNa8MFr77ZYCAmfCzWBjnxbEd1n/puX3siFQnc53NbHWbf60QEVtnPmMtcIwWGpQfypG0PLB5TAO0AXHrYxrirYyf/LKcdbOy6p3tqoz7vx/1jKbgPBoT8+RHfuUqoNEM92970n263ookeQrI9/E1pc39yuP/qManFRUWWtOE91IO9Tb4QdxuCzvIvKQq51zpQDY1uSxKz8eWxZ4bQTL4fdVVgS0eBLyIODtnTaM+KF2I1OR2o3G8wYSSVjq1INh7y7bI3n1HDvSUfJ6uD9dfIYknKsNsMtd5dmWTCWPivuSU01v1vSNoF+j1JS0r9zX1+mLChuWG9thWUkk56VRQijTKnFZHPICHJynSF88jMuhySzWT6b70GrAVZf85NR8bm1Kz
 PnJdhfCQ
 O/LliIG5gvkhBbxIvd/npchaFnebDl420lxvgbwA0TKzQ61vx3aA1mv2g4cKVMOyll3Kw/wGIU+Wk34jtiiqchi+iVsTwGl9zy4uFooZ/aLkUAgR4aX5UR4wo5oOdg1pkqWsUZ0CYbEXARzX+OedUCNtZ/MjkjcGK585F7aK4abCE0hrE9yI3phbZzByPEX0DObzfAol4YHPCY76prPgzL0qn3xPxvRK7wUKdTozRZrHxvh2ho4Ja3Tblv2+SqGYTqTdZjp4nEeq+JuqpjhW7QfiEBLJZKvlR0p+woz7tHFSM8PgtWhwe9VpWLX99MitTSHoe5lyvihOJ3yuMSCKe4hXOCKB3/AjnyIRxDy7tx3MxLBk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Restoring an optimized folio and rolling back a partial optimization
both restore a vmemmap range, but the operation is currently implemented
separately in each path.

Use a single range-restoration path for both cases, making rollback an
explicit bounded form of normal restoration.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/hugetlb_vmemmap.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 97748a9cefe2..2cfb88dc4fba 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -284,6 +284,18 @@ static int vmemmap_restore_pte(pte_t *pte, unsigned long addr,
 	return 0;
 }
 
+static inline int vmemmap_restore_range(unsigned long start, unsigned long end,
+		struct list_head *vmemmap_pages, unsigned long flags)
+{
+	struct vmemmap_remap_walk walk = {
+		.remap_pte	= vmemmap_restore_pte,
+		.vmemmap_pages	= vmemmap_pages,
+		.flags		= flags,
+	};
+
+	return vmemmap_remap_range(start, end, &walk);
+}
+
 /**
  * vmemmap_remap_split - split the vmemmap virtual address range [@start, @end)
  *                      backing PMDs of the directmap into PTEs
@@ -342,19 +354,7 @@ static int vmemmap_optimize_folio(const struct folio *folio,
 		return ret;
 
 	end = start + walk.nr_walked * PAGE_SIZE;
-
-	/*
-	 * vmemmap_pages contains pages from the previous vmemmap_remap_range()
-	 * call which failed.  These are pages which were removed from
-	 * the vmemmap. They will be restored in the following call.
-	 */
-	walk = (struct vmemmap_remap_walk) {
-		.remap_pte	= vmemmap_restore_pte,
-		.vmemmap_pages	= vmemmap_pages,
-		.flags		= 0,
-	};
-
-	vmemmap_remap_range(start, end, &walk);
+	vmemmap_restore_range(start, end, vmemmap_pages, 0);
 
 	return ret;
 }
@@ -376,17 +376,12 @@ static int vmemmap_restore_folio(const struct folio *folio, unsigned long flags)
 	int nid = folio_nid(folio);
 	unsigned long start = (unsigned long)folio_page(folio, 0);
 	unsigned long end = start + folio_vmemmap_size(folio);
-	struct vmemmap_remap_walk walk = {
-		.remap_pte	= vmemmap_restore_pte,
-		.vmemmap_pages	= &vmemmap_pages,
-		.flags		= flags,
-	};
 
 	start += VMEMMAP_OPTIMIZATION_SIZE;
 	if (alloc_vmemmap_page_list(&vmemmap_pages, (end - start) / PAGE_SIZE, nid))
 		return -ENOMEM;
 
-	return vmemmap_remap_range(start, end, &walk);
+	return vmemmap_restore_range(start, end, &vmemmap_pages, flags);
 }
 
 static bool vmemmap_optimize_enabled = IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP_DEFAULT_ON);
-- 
2.54.0


