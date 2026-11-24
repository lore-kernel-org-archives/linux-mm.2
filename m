Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0AF07606A327
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 11:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=S0N9KYDO
Received: by kanga.kvack.org (Postfix)
	id 233CC6B0677; Tue, 24 Nov 2026 06:06:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BDF06B0679; Tue, 24 Nov 2026 06:06:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 085136B067A; Tue, 24 Nov 2026 06:06:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C76936B0677
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 06:06:38 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3CA52160AE9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:06:38 +0000 (UTC)
X-FDA: 85469734476.05.FDB6067
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 6B3A2140006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:06:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=S0N9KYDO;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795518396;
	b=7/5RInJui+iaYZzHLz8bgyxagp8OzDqc9MwypCTN7nrIT+AOAt1Li6hpSlwsiam5ule60y
	GI67Vhcu0GbDJ/tN4mSqKsWfw0hIp6GxYDbqVVjMb+QpE2WiKr00BO6x8eUKD/xWjl2ag9
	Gq65lEzrvb8IHS+Cy92DiXWALQRm57o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795518396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z/ncVgQk7z6SUo+uxtpEc02lHnedHRME0db1aGjigR0=;
	b=L7aMGSMq4mtjja4PvE8pNVEA+83zYE/Wgts5yK9GbQ/O3Pm1wpylOMtyyKxitDWuVHnP69
	uX6ml91HnT8vRk5l5uFfkluUsEja8qudC/35Dx9TO9ioveY6nf93tcZ6GMry7asgZhqxVn
	5FK5WuL1qIel3w7hIsA7zNnk0y4PXNA=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=S0N9KYDO;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-ccca948203aso3553268a12.3
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 03:06:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795518393; x=1796123193; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z/ncVgQk7z6SUo+uxtpEc02lHnedHRME0db1aGjigR0=;
        b=S0N9KYDOC8t3+181grzps+nIno4OVc7WdsjnfLLPejFbNLsy/i3OEiEBTVNOB2ae18
         lNaIB45zkrs5epm/5ibBs9/2WRTDJkCjSlcFCS6dq11qARRB+XjihpmntdqHE1SjgT23
         lsmlZAFU0ouIOAuNQed/9RLohmFUX03xXEALgGxpdH/x/xDKkx1tg9Lr80Tu3LYn6h7r
         lsV2IkgUrY4eO8f25iecesg9lQ64esxzBYQF/HcHziqALS5vgFrn5eHPGUoy5TBhh+LR
         pKlLFw0qXUFG7cCAtm+IJvBMPQojUzKKlsuwsCTr24Y9pQuwxwIc7dmbvDHzpGMSeP4V
         Mk3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795518393; x=1796123193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=z/ncVgQk7z6SUo+uxtpEc02lHnedHRME0db1aGjigR0=;
        b=K57GKE6Q8y81TbilZsDvEHgEdOaQBdbzTWXxQQQKRjV8Xvip1SveAgsx6pGkRdvYvP
         aa3JeY6jgcnhkgSfcPVu10I0z9aicji3JNcJD76q3v5/D4L2HZEs32PraKnNn5DMCD5j
         DTubnY8IclEroMViXBLz5z9kjgO8z7fMbW51+KCGcs7kjSwrYkfj0aUdDQWt0QCclkNL
         Ai2M6l+/Ky9o64f340gdRk9u5hPEbC2fUExtUzzPJtIM9blqSOI6xqtdHFBaR1mi41Qo
         mE+hb2ANJwQWqPziKmaZjhJlCBypunh0Htv+VSzEt+v+/7IeRumKYazr8hcRUi4JRik8
         y5nw==
X-Forwarded-Encrypted: i=1; AL+hErFXaoITL+4Et80/VtGJqPvuKJgKlrbdNUxhdvrrnxMOTT0dt8rIzxbGyaBLgCdWBJQHNAt8VHAEKQ==@kvack.org
X-Gm-Message-State: APuU4Z+T8U5yYs7J+z37SZ1EfW1W4QFUTPAqm3lkbnGAGJeEylT632do
	fni8IoZrz0sIw/u5MZY3F2wFmSS9N5f889GyT4K8gROpg/5XgrQ/9Q5rnZ1/RD9QV5I=
X-Gm-Gg: AZFdTZeouYVuBFONPOvU7Duru69TSyVNhkmCOBzLkdnp90/hL7sAaT2bQwQqEom+rIW
	oWVbFFzqNHZs7v/lCc0kKrih3mgK5YdIUg2ATEIF1XDMiFtNImTDGXWdNY2rQD/VGrLSgfnE7u1
	zU0pg1h7Nyf36g6NSiXxNXaABG0JejJfHC4Ky4JlY4kcz3WNkVY5j2pz2lSgJgAeqk/UV+AbFGN
	3Rb0vGBMFRYSIPusgJUvqCaQOZB81mJzrltuQcKN/7QceIOSNLPGDzxBJpD6D2S5Dcsp51vltdZ
	zV48+PtgLnNO//cD9oXyxAh+U601S89MMhfX5h6LlTBQdGCMJ0xH8+ePz6q9vYPvnz+kYkV6cWn
	xfYM00d13CDw1HkGfOCsfLFWzMp3VIYOJ3AKQ2XUB5HwP2ekN5DmjejnDtj3ZSNCtZjQDEbxUiA
	Or6SqUSPIfZrmtKtYtpwo9b4RZ8gwb8DaTxSaVxPyPI84wVlJuw8GnXFC6l2Mp7nKpYX69fi/p+
	72lJEEURV4uKVORIpO41lNnQLxraUZbikknk1KsRZzS1/dlNF9yuwIxp+vHY+0CCNt78zkh/Fke
	bBjsMREI3FkCJoPBJGfnYz10782mP2Jzq8TlVDCBUo0Ys1FONA==
X-Received: by 2002:a17:90b:2792:b0:3a4:ca46:840f with SMTP id 98e67ed59e1d1-3b41c8e172amr12357390a91.8.1795518393084;
        Tue, 24 Nov 2026 03:06:33 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b41ad0a33fsm22909735a91.6.2026.11.24.03.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 03:06:32 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 1/6] mm/hugetlb_vmemmap: remove the vmemmap savings boot message
Date: Tue, 24 Nov 2026 19:05:25 +0800
Message-ID: <20261124110530.3004071-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261124110530.3004071-1-songmuchun@bytedance.com>
References: <20261124110530.3004071-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6B3A2140006
X-Stat-Signature: 6psa9nc7sepygcqr37z9t6wc3dfi95kc
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795518394-102717
X-HE-Meta: U2FsdGVkX1/ilyhTQEo2b/nYXwDDU2tSo9549nm3A5Ppw5Atn+9zZz70tCKDHT92+/CiJrUF0Jrh27fcD/uGRB/GVFfu2MOATaetenwMM9r3moss+MmG2rOfZ0nuvJh47CqlUvHaYPurZ57IERL3U2GD7NN5L/W9U1AnfjSeBqc1yscItydF7/S+79uttWHzoeTnPkYBd4FHOZnOYjhreawCF9xmHhd89VEuMqhy+gyrbg9PiizxAawhoSmirmIiwkj52+X4rZAUFeFeEcVkxm9Z+VOsKUpisYqvq1nt7XnZS8SeqiRDoKk2bOyV2IIiGcVjK6x+PQp/4KvBhXPGHxwPqPGABuU0rQxLWZRDQSUQhnnKKyWDcxYzdxaFRbua1dH3m4uC1qBtMeD+JWLTlW9ao8GC5I7C8fNg2fylc6X1Q6KHstOGv82VVaeGZULaZqjEVLkXjU3Ym6XRCPYQ3Veb7ZXH2PMGB7JEk/251yPSe67EhjClpBaYOmtZtxi4+hxCs8rc2vT1d+cPSnP19CTp3mZMqENJyvHthb82cdPVkxXy0tZKvWg6cYP/I5Eq9dMQRKn+asNn3wnG1eLEUQgbfhHrLg0BoU7J4C5rQv1SU6TS87hOqG00Dz1DVHvq6b9gfq899CKsvCzeswkJ94x/puhyxSx5zVxMYo6tyGqErlnRdFU1xJt7/WDmivA62aClW0a/gB4uxqwU+Dp2chBIcKRElyFKyEjM+3+LftmR1if8OzNzM5hko6xT146E1ePoEWAgBeZErQV7znePpeZyU0GTB+SzhSHSF77oLpxu9904HVaDPTBTJznbDc0Vp8/3aA3gruZeH8LR92TlxyATmqeaFQ51tgv3PbF3hmYRXP/q0I/KAtkY/sI0JiBAtj78XAtZvGzpGAsuG+vR1Wbvp8o2NBpD9JMQ+/RLUFn4kbjle/mkm0h5nQ4kHklFfrXeujpJIbOi64iDug+
 VK74hCrR
 AwjM5356PrTXWj4gDLDEKEexOw5meaIjW880X1OCoL2fWBVVf5RhNXVsuL1PN1PIWt2/aYDalsiXKLVZ49B9UQWp71B/EuHRUQRjbSzIQJQgsGRwhCpBlkxs4DzBlZ1Kfw8Stzxtp3lbAd+s3lsQSh66RInNIQk9Axol9+YEVWm5C/iRUiXrLuDAZz+rmIBK23gNHxkvRL5EFX4hM0BdxjIeTPr+tgUsJlZYjEcL/Cmb8UFtBqC7Np0XYjKHkIna6cLnjN4O7nJX8vXmGxy3ojqC+ppk5PN5fSWo4zJ3rre4njw8DwVYe5zlHwlgu6qhWOIWqocRuOgXn+3qs99591AGGapXFBdGnD+NOQ3yPnre/xkxD+hYXH07zAP86yFJgF/BjDVwsOl09QEHovHQLFEziWgWej8dX/MJmVo+LJf/nA1tHPl0QXHhiXAVA35VNJWCbrFmEbI0XdcoyRu0oPaDotp9Kc7DU7RlsMJ++dwsiG1v/AB6hZ0dMB1bfgwrJb7kY22+6XGy5N8v8fxMK4KAvtQPTvPL0E8vwvh/NGPUz6snmmj+Q/gFmRZ8SL6tIlnzcJvG5gFEQelE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The boot message reports the potential vmemmap savings for each HugeTLB
page size. It is a static estimate and does not indicate whether HVO is
enabled or how much vmemmap memory is actually in use.

Users can query vm.hugetlb_optimize_vmemmap for the HVO enable policy
and inspect nr_memmap_pages and nr_memmap_boot_pages in /proc/vmstat
for the actual vmemmap usage.

Remove the boot message and hugetlb_vmemmap_optimizable_size(), which is
only used to calculate the reported estimate.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/hugetlb.h |  2 +-
 mm/hugetlb.c            |  2 --
 mm/hugetlb_vmemmap.h    | 27 ++++-----------------------
 3 files changed, 5 insertions(+), 26 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 0d5414392d87..b5b877ed5b92 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -812,7 +812,7 @@ static inline unsigned long huge_page_mask(struct hstate *h)
 	return h->mask;
 }
 
-static inline unsigned int huge_page_order(struct hstate *h)
+static inline unsigned int huge_page_order(const struct hstate *h)
 {
 	return h->order;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index d0e66fb30622..0eddb8cee1eb 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -3720,8 +3720,6 @@ static void __init report_hugepages(void)
 		string_get_size(huge_page_size(h), 1, STRING_UNITS_2, buf, sizeof(buf));
 		pr_info("registered %s page size, pre-allocated %ld pages\n",
 			buf, h->nr_huge_pages);
-		pr_info("%d KiB vmemmap can be freed for a %s page\n",
-			hugetlb_vmemmap_optimizable_size(h) / SZ_1K, buf);
 	}
 }
 
diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
index 8b28063d78cc..b7781baa2ce0 100644
--- a/mm/hugetlb_vmemmap.h
+++ b/mm/hugetlb_vmemmap.h
@@ -33,23 +33,6 @@ static inline void hugetlb_vmemmap_write_unlock(void)
 	up_write(&vmemmap_remap_rwsem);
 }
 
-static inline unsigned int hugetlb_vmemmap_size(const struct hstate *h)
-{
-	return pages_per_huge_page(h) * sizeof(struct page);
-}
-
-/*
- * Return how many vmemmap size associated with a HugeTLB page that can be
- * optimized and can be freed to the buddy allocator.
- */
-static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
-{
-	int size = hugetlb_vmemmap_size(h) - VMEMMAP_OPTIMIZATION_SIZE;
-
-	if (!is_power_of_2(sizeof(struct page)))
-		return 0;
-	return size > 0 ? size : 0;
-}
 #else
 static inline int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio)
 {
@@ -80,11 +63,6 @@ static inline void hugetlb_vmemmap_write_unlock(void)
 {
 }
 
-static inline unsigned int hugetlb_vmemmap_optimizable_size(const struct hstate *h)
-{
-	return 0;
-}
-
 static inline void hugetlb_vmemmap_optimize_bootmem_page(unsigned long pfn, unsigned int order)
 {
 }
@@ -95,6 +73,9 @@ DEFINE_LOCK_GUARD_0(vmemmap_remap,
 
 static inline bool hugetlb_vmemmap_optimizable(const struct hstate *h)
 {
-	return hugetlb_vmemmap_optimizable_size(h) != 0;
+	if (!IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP))
+		return false;
+
+	return vmemmap_optimizable_order(huge_page_order(h));
 }
 #endif /* _LINUX_HUGETLB_VMEMMAP_H */
-- 
2.54.0


