Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47C23C9833E
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 02:55:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202006B0095; Sat, 26 Sep 2026 22:55:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B2E16B0096; Sat, 26 Sep 2026 22:55:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0EFBB6B0098; Sat, 26 Sep 2026 22:55:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D9E7C6B0095
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 22:55:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 54E7980972
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:14 +0000 (UTC)
X-FDA: 85258025748.18.79106C5
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf02.hostedemail.com (Postfix) with ESMTP id 43D9F80009
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 02:55:12 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NJg03uTr;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790477712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oPILxKtLMatcdEGLhusrMdFPdqn1uhqgdU3ISddJAJk=;
	b=ENT4uvXZdf6jbTwFktP95A83e/QjkhfFOQti+UUnk9itELFbFyIMQFeb4bvSgnEY2iQPHX
	K9hhdM8m0GMQbFx0k2Yz+sQxjmlu6OUtMESBYVJ/9fR1xMBjY3vf1DWOzvxZNw9uBmkAE4
	0hwXzQDTpdyUkRt1e/5kNcDYQml4qXA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=NJg03uTr;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790477712;
	b=GwAReXQadvPUjakOrfhYdRrBHcFT78YvclPTNjy5Laz71db2KELeF9xr0wPXGGIem0haf3
	IiUb4p5SphGKvcw7mXRUqRaPICikGSqK2fYlBMJww9sEdd81jUk2h1P0C0Sr7477rb+N7h
	u8t7LU5Yk6EGcFjkI2HETe5ScU7u4d4=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-39d654f02baso850300a91.3
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 19:55:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1790477711; x=1791082511; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oPILxKtLMatcdEGLhusrMdFPdqn1uhqgdU3ISddJAJk=;
        b=NJg03uTrWYWwcTBpQKyHR7uM8quXkiyW6+/AYPG/a6VY3hLTeYhO9yR5c/nCNH22Ze
         23xp+uNfvmJkjk3jY8cg0ZuF/5crCVSeuTaSY0W1vSlRufxYC3vLisUL5sz9zLQ7WWKH
         KPiVe1bBkCJbkkyAQF6Z4ddV7ae2wCvVkZpIVwPdTXAKEt0/NmH9D1TPPLd0VQiPZJ4f
         wmUPOcXW41w7exn7UG0GJD+AJOMQdcf9gh5q7HPmI9+q8VF8jcPP/e7NPZUtAL6qmcRV
         PbbnhgnQ2wEasDD6jtiFI3n3vsYbuhmCEnjDGtp0A01otyJvlKjdxMKCWoaYY4uo8ftz
         pqMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790477711; x=1791082511;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=oPILxKtLMatcdEGLhusrMdFPdqn1uhqgdU3ISddJAJk=;
        b=z6LWLHyisIwm1j4on18kDithrTCHKmRFDEj/qz1ZLO2UdEuHfbivvogOWjXVRdx2iP
         GkkyWc/ZtaFcjcPFSZSidXTD4P3o/jRt9geebKF+vxF2vtgdVm4GCGNKVhEM4IFhK3o2
         zBxsDf8SrYOTa+/cemU/8BW9cjPwkJRtSZYel7HTflxqUGcWbTeVqNl8TIgWmyfETsu5
         An3gjls5ItdLbT3w4zqn4or4Iu0TZ3aU5oycBn7r+34nmWzTaji4xfeWQzGQEAWJqcl3
         bDgFalwDuJHVIVrAoQ6DLg/aQLDlbQX5twWPzS70VSKSmapUuas7zPPatt4PsPsT5gTH
         vrZw==
X-Gm-Message-State: AFq9FYJ7uIJRZeYyUy8S1xWR04fqKYCxROhlL14ybERsjAFCHpDEtFcM
	g/s9SpoJkpGjo1ZBxdp3GpGOt/IYCgycWiG000cU4nB4/EPG4vpX/83wKzxkJX3M2p0=
X-Gm-Gg: AYBFou2e3uxZkLLkCzfaG2EFJrOCyNAT40RGV2M6OIg2oZGgWxVmjZHkGGOYzF6wQXQ
	PofGEa7somJwMQs9ky4Td77qutrNH+NMNF2opiusY6/6dt4MQ/KhEoITOYSqxgo+F3IYssUCrc4
	87ROKQF4xZCkeRU0aB6k7KKrc1kn52Ibkt9/vpik3xLZvGBrCc5Lpgollh0Q1t/JN0pDYcVAE26
	ODy7nzSixATvTu0We3r25d1w5JbpalPI6sDfTYDDB2d7ryKehCypXXiR/+QeDTnfWq36EgXRJmY
	mYtY8EOPRk5alH+4zFYiLU92jLm0d02bU7NFzRjdWFX6YJkLyKpoBe7fnrjGWCH7P/O9Tn8qxpO
	XSP00uanjQqWSuISDfkBzhzxIfxq6taS2+PPeqRMmliNA/53Rz2JQtbH4gPQbThQsMJ3F2ROWv1
	MdKYSLSBi8DciodLkE1UAzp0Nn64MA4Fmb++0tIPVSdMiUk6vR8k/447T0hS9TeLnI8pDUmFl/P
	y5wR+YttEbRFCoCO4DQ
X-Received: by 2002:a17:90b:1807:b0:3a0:c8be:3227 with SMTP id 98e67ed59e1d1-3a0c8be4232mr4636947a91.13.1790477710866;
        Sat, 26 Sep 2026 19:55:10 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.102])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b8efb156sm13461377a91.1.2026.09.26.19.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 19:55:10 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>,
	Lance Yang <lance.yang@linux.dev>
Subject: [PATCH v5 04/12] mm/sparse-vmemmap: open-code init_compound_tail()
Date: Sun, 27 Sep 2026 10:54:33 +0800
Message-ID: <20260927025441.741633-5-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260927025441.741633-1-songmuchun@bytedance.com>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: q8qe3sxhfdt1mgg6ukifhbbja694ofiy
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 43D9F80009
X-HE-Tag: 1790477712-794064
X-HE-Meta: U2FsdGVkX188ZK1EuckJp9iYNl2orZdD+CQMXmapFG0iL2EG6bBnaheFIuaxUYqWXlK7HFdhUaRVc58W3sKiSjqfY4uiyAA0g0Ch6Bt2VyP8EXCu4edWYhCkylFo0ZbIHn+bHhPDbyhCzMPOGcu/AftOYU0Bs6DvWgWoSRtD8ajtxtGanek2YkafsWM8xLlNM3J80GkyJThm9Df0+Q5ziyN5gOCgvft5sBtb3Pxl0C3YM+I0ZmTJLFsG8zrjqlnmn6vP1jwhUt9DxAxje1Uj2eAf5SYxxto2ksdcMB10hvSKbUiAPN98xzgPoIklSSmfOVyOvx93NDvskQOYUjbEAfxXEIw55bG5hPwDKuDKG4wxJwmCbnI5wyzGLDVdaOy2n1wBWuqfO6Fhop5B8kuo5+8OHbIVgGSQDeI3NZ+K/9khswGcaCMJuYdReeB9GNzmXJmWBEs+oNd0XEFb6/CqBbLyubVvnAteXufLgA3OC4lMMDwq8VMGt5lmDuA4PNaKQMZ3wbzZpP1e9feHttq66jPgKgEb3R1Wo8384JX/jjwFzu2d3iZM46Vpc+uOn1yENTo1NpWw/49HO7gSysm4x/zOPk3h5Rx8PtzX91K0X5bsECjb5RZbfoAIVOjpwKePZadYFzL/nUmmiDqveBe5Cmx/hcCp01ZnZNQ63Qgm1HNVU9wxTyC5DhbtFK4bfOKSP6hsOD8lm1msXtjc6EP/X9wiwbDgpSSXsw6QosAxGti/BjjaRosb745lbrWF1NFI8pPubTEkSpWKO8+gFZuHlt23LFrX8B02ECg1/0w76dhom9nCOI8M9B0eodWQERa2ecVHJ6c5kCNwEZtPrX4Sk8evE1X3FwN2A2O7B+oSD6F7+hmFTKXZDq7tvdL6EOnHwJ+AVFsc6+NGhJDH0vvVM+UcIstRN0V4+3o20ETihb4y6bpUbPSg4f0JYL6qjQzxLoH75E7rIb2PKEAxuiR
 KlciZAAJ
 RcCkK8mAATlRw0vWzbsdaBNidN4vqxwcwX6FaD7ifzjPnxxHR8mtkuksYAkdLBcNxJM8aJ1CpkaU1m+xeF2tqhb5XRQnWqjC34cbp1DDf0DsJtwVjFFhOepbFBIKK5oQQMmBZV3BBEQfow9Cnp0cJu1JQaCgoeByNontppBNcEBHvr8S3pfQr0VEBzkWcQLyFrbfRfoZv8ZUWEWbYFKLKnENRj4OyflxBZ0ZwLV3R3u/dcObP8tzwAtQpBUJ7Thx+yqSQiC7zFaPLiZrDZT3XlG/DlV7I7TTHZ5wXE6v7gA+a7t6JCFFE32G5QfVU/C5KZ4jsDrnLZKLgJRuuQDwDLW6WBAokYqK1ngHxOhTLWaAtyyioLZbP0qwCszN0b1jtVIaE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

init_compound_tail() is only used by vmemmap_shared_tail_page(), where
the shared tail page setup intentionally passes NULL as the compound head.

Keeping this helper in mm/internal.h exposes that special case to the rest
of the MM code and can make the NULL head argument look generally valid.
Open-code the initialization at the only call site so the special-case use
stays local to sparse vmemmap optimization.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v4:
- Collect Acked-by from Mike Rapoport

v3:
- Collect Acked-by from David Hildenbrand

v2:
- Collect Acked-by from Qi Zheng
---
 mm/internal.h       | 9 ---------
 mm/sparse-vmemmap.c | 5 ++++-
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index da14c56fb24e..0dca33db068f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -786,15 +786,6 @@ static inline void prep_compound_tail(struct page *tail,
 	VM_WARN_ON_ONCE(tail->private);
 }
 
-static inline void init_compound_tail(struct page *tail,
-		const struct page *head, unsigned int order, struct zone *zone)
-{
-	atomic_set(&tail->_mapcount, -1);
-	set_page_node(tail, zone_to_nid(zone));
-	set_page_zone(tail, zone_idx(zone));
-	prep_compound_tail(tail, head, order);
-}
-
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 /*
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 38c36399f53e..e4dae98ba7f8 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -217,7 +217,10 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++) {
 		page = (struct page *)addr + i;
 		mm_zero_struct_page(page);
-		init_compound_tail(page, NULL, order, zone);
+		atomic_set(&page->_mapcount, -1);
+		set_page_node(page, zone_to_nid(zone));
+		set_page_zone(page, zone_idx(zone));
+		prep_compound_tail(page, NULL, order);
 	}
 
 	page = virt_to_page(addr);
-- 
2.54.0


