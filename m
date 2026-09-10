Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0510FC79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:34:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21FBD6B00B3; Thu, 10 Sep 2026 02:34:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AFB36B00B5; Thu, 10 Sep 2026 02:34:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0715E6B00B6; Thu, 10 Sep 2026 02:34:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0D7A6B00B3
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:34:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 797E5A4593
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:34:33 +0000 (UTC)
X-FDA: 85196888826.04.5750505
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf13.hostedemail.com (Postfix) with ESMTP id AFC1320004
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:34:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IbjzhToR;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0BGuwwnpIgT7eCl3rvqq0NlL+Ip0lSFu+Xm8xqE1I4=;
	b=sJ2NeQhXg3+o9h14MjFy37nTwivWFZGMwylSHKViayb55Iwd0LILlvZyvSYN3hDoZrW9D+
	kxeiehH6y8Sr4ZYNk15B4MqDGhc9UqiBCwukyyqqwTsf8irxMVvBufuDc9LC39CcEQR7dR
	pjPTSvQS/VsuS1KMgRgA/DI8fl6bKwU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022071;
	b=kyI/gad3fKMvj71zDP/fjVRoKEJ2BnVPA1A1UcH7NS3MHKEm4E7qbQUzZCG9emuxQCfU2a
	CSZqC4pJ9dv1ZGI0sZU8g3h9C2p5BPafsWRsl2wLshAVVgdbZem1G3Bp3wYoVyYQjq/irB
	f9X+Dvj4cuQuhbphlDd3uEQt9aLni+Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=IbjzhToR;
	spf=pass (imf13.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3990fe066ebso5529733a91.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 23:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789022070; x=1789626870; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l0BGuwwnpIgT7eCl3rvqq0NlL+Ip0lSFu+Xm8xqE1I4=;
        b=IbjzhToRzN2Fb4wsMB2kZN/DR0nfivhZApPC4ckg8vfFkklTOhAzgHb9tZSSF9Pagp
         Igt+HruGKJ+T6geAkFwuc40u5f+DLprHfQpXFQ/DGpTpT8YMbzAA/7DDFgXUCT21Oi9b
         Tv5k7CcSKRB/E2/JZfLWiQzWx+2pk5gAFs9S79Z+tkxPWsBjVojNpLbBVi31AH1fiBhG
         n0WBUQ/F+AEnhCSJXCUQBNstaMeMyaYKqoS6zg6/I4ZB/V5VQK03vjMzf03AIrrCO7lu
         I3YkIOsb20GAgpC6ZwDv2fFcEJw/LIjxQ30LT04PS8218KoiEFlwd1NJOTg4D3qn07jT
         xogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789022070; x=1789626870;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l0BGuwwnpIgT7eCl3rvqq0NlL+Ip0lSFu+Xm8xqE1I4=;
        b=JTPkVJW33snDUKGcKy+d5QU9tIPP0b94OanaSB0HbIvxxchqOTQ+Wah1tTRqu+ircR
         iwt2IRhE4rkXmMi9IB0Ke32vlt4HIQXME8YKKrnZI4ECg2+kReP3Sow5ACLnmCsOcJzR
         kcFRxZ+CgreiHbJi29bpnl/muXRK8Bd/PJ0G2/t4ecbcEdMko6fBVTuRfDAgxaCSwBzu
         m0ql7T0c/6q68IOwHrbLrXay69A3UUC9w/LYlqXedSZH5xFhDfArheO6DcjYzMHEreM4
         0pvv4kP+K4goNKz3dR1rI6SUf/6R6ZpnYBTScTvhfAc32Izz6X0960Pgx4/IKacj+dXi
         zePg==
X-Forwarded-Encrypted: i=1; AKwUvBy+aPMNg19/CVTjZXlyVDNtzxWT2nzt+DR2myxafZHzTSEBXtjVOEOeIeq03ghqX0T4W31u5wJOdg==@kvack.org
X-Gm-Message-State: AFuF++kL+p5jg58fGtal4EP4ZwkNiwcDBdPHlNhb7clNz7SETPVOYJ7D
	YX38Ohzfzi7gQ4cZF+tinLMmOjmlX/A8rXprmdOUbvXfTK55bpb/DobwDOtB9xk6VXU=
X-Gm-Gg: AYBFou1MqsYkcpVvBuC0Ylhy1lNvSc7SN8RtbA2loDrGmBH9PXEQTNAl2N5MMFNEvVQ
	Ka4ENVvQn2RmsC32zJzep4MwTh4bpBwtIx3kQjLu/e/qbJxqNZJy8Qi57aDqtaiEZ8TVFLp+80i
	DTrhFju+BZeyB8MqJwBuAWOXIDHFfcrhtrA08ol34TidKFsgXNNW9hHiN2tnv7UZwH02mVmbiIO
	e1dotb/klCN9c/Bwrntq0XaABF9Y0cPOje1uiiOgYDE0KKBBt+qDoLzpEHeoSZqWAkv7LSDTF2D
	Q8xx8qToqsMpt3U8+T0AVq1vVEq3r/oTtT3E8C2LBcmG1H8h/POO2W0ufBiZEjnofDt7jU9Bza7
	UxfyuxoroiSQHkBcDY+Z1Tc/zlv73WK1/ySyhS1E7QAfNIbyPTH3DSk+3eOjUvboNEqW9zhuR6L
	x57BbRMcbSlmmyl1taLWbbAxXwc6SbSEYTM3+S4OEr+/MYXICY4Z4Tj9vDwqwKJJF5RDGiSX2vK
	EtZwO7O75h3X7yQeGVbChSEl/r1ATfYGVo=
X-Received: by 2002:a17:90b:54c3:b0:398:d6e8:f84e with SMTP id 98e67ed59e1d1-39b2612ecebmr61630953a91.9.1789022070455;
        Wed, 09 Sep 2026 23:34:30 -0700 (PDT)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d84fdbae4sm1213094a91.14.2026.09.09.23.34.26
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 09 Sep 2026 23:34:30 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	David Laight <david.laight.linux@gmail.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Muchun Song <muchun.song@linux.dev>
Subject: [PATCH v6 17/17] mm/hugetlb: localize HUGE_BOOTMEM_ZONES_VALID
Date: Thu, 10 Sep 2026 14:32:56 +0800
Message-ID: <20260910063256.64386-18-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260910063256.64386-1-songmuchun@bytedance.com>
References: <20260910063256.64386-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nyko9bqi4rha3crfztuiir5r5ucpty95
X-Rspam-User: 
X-Rspamd-Queue-Id: AFC1320004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789022071-561794
X-HE-Meta: U2FsdGVkX18ZAVtr6sv3xeamcRZzEp1C+XEsYAdl/y5/x2KTq0AtblELd7xMk3M4aHLAOjzA87HQUl+IULt8tT0xplf9dPa0s+XwDd5Xuuaq3dS/a5GTO5ulw/VAQB5jYetUgs2DS7j7uIyed5G6iOlzsY0Qy8en86O7ieRBSr/d09MgUVkX9LtxSxL/8eZIYAI7g8/fPt2fHKo6Dm3H/vy+4Rxyo5h9VaGyXwgQ50xGe/drPjAglRwc/F9lM5qKUGJWl8cI+6RAp78yGOHZ1JihY4ZK+2q9u2BVcE58O7FCjvuR5AdlASm1mnk4rUjNCVh+6tiPS5IDam3abwz2lWa+jdoZy44K04SnimBa4BYNWEh6w+xNB8b88JyurepexilvfdrDB3jHEprK7HzoHS+z1fudqNzexUK+InGf3DpEWtGBeEjHCSkQoSTg0CXIY6wBBpgCpctw6xN7LN4JRZOlC5gMMczAb4KlJA+G3QWLewlstJhfSyJMtAZ0FhpWRdOHeuARk/YaLc4IaIKOkus8c7seYHdnqUV3H0jiYiAR59X4iN7P+PUXIy+I4ZogpZc4cm99dhm8nh55N9j9DBFnn61YPR0pact1ALSNhNmN/vp0xc6gyubYciaSQYJidDx+j9vIakXAarBQyEToD7aWdcHhz+6dzJv1P36ti0kEAh16UBNfFSK0yDZlm5ES3gO+A9xesK8CcVmeqBCladenLQb5pKjKLRiFpX7lITjasLmBNvP08UL+T1z1Zgs/PRmRzWJS4WZl4kaEiaTe+DxLD/aMGPsqSCfcYiok355DSWMu85XNg8j0xkRF8svrXOE+wwOtfI4djk8BG/KSUHHO9BYklto+V60ZVIvOJesKkQ8hAQzx/9fuETMV1ss79bigXMYhNPcfBPU22VQTd2UbpzePnskEN2sNv/YdwEsTXW52Sy0c/6umx2vw+5hEPEezg7a6qdBCmAe83D9
 LI+nNOo/
 saEf/9huERt79nSXypFKaoE6NUOna7dzjLNQCcISm8bS8Uy/dQ9bb30wXS2kNMr7pgWow8GTQ5tz7xNaBTlU2FWi9klNfvFaKQNqwq42oYQgQAl3nO+LGZDMhC+Ze1IBcBhFCKlE92RnQO60itKwvOBgKLMz+cUgZkroTcZceAfsrHag5V6Jx3FDXGQ9pNw08tJZhCNcB1q/Wu3iKnNNF77hwUrYTBj+yj2OBMCxbBuvVVYqewFG0k4hjTrHoZj1+XfYw/xxJY3SJbopaVwqqKIfEbbgTnCbVD/3pnpSz7ikzpDZWwpMooglJ2TEOcr8rr9s+NCYoP/P9pVJ/W0OKh6QwLODHTcCqK53yD0ADWcYaUoeaJNbV8UknYxHKVlRcGyRExbe1Yz7F1cWNHIS1wjdNSV7X0DQlj0etHnUUjRcTKrq8uTjt2y4CzxxaNbjoqniH2i6ubfHq7U8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HUGE_BOOTMEM_ZONES_VALID is only used by the huge_bootmem_page flag
handling in mm/hugetlb.c. Keep the definition next to that private data
structure instead of exposing it through the public hugetlb header.

No functional change is intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
---
v6:
- Collect Acked-by from Qi Zheng

v2:
- Collect Acked-by from Mike Rapoport
---
 include/linux/hugetlb.h | 2 --
 mm/hugetlb.c            | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 255a258f11d1..900c95e346b2 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -675,8 +675,6 @@ struct hstate {
 	char name[HSTATE_NAME_LEN];
 };
 
-#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
-
 int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list);
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn);
 void wait_for_freed_hugetlb_folios(void);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index c8fd3a6ce812..894efb6b1ebc 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -55,6 +55,8 @@
 #include "sparse.h"
 #include <linux/page-isolation.h>
 
+#define HUGE_BOOTMEM_ZONES_VALID	BIT(0)
+
 struct huge_bootmem_page {
 	struct list_head list;
 	struct hstate *hstate;
-- 
2.54.0


