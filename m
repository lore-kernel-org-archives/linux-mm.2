Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 157C0CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 06:12:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43DB88E000C; Mon,  1 Sep 2025 02:12:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C7428E0006; Mon,  1 Sep 2025 02:12:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267EF8E000C; Mon,  1 Sep 2025 02:12:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0903C8E0006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 02:12:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C5E9C160679
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:45 +0000 (UTC)
X-FDA: 83839662690.07.80088F5
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf16.hostedemail.com (Postfix) with ESMTP id E34DD180006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 06:12:43 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="O/GYIJcj";
	spf=pass (imf16.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756707164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rG8qInwJ7HC+M9uFXGeO7jifDwFcNxLl5I1yIPskFEM=;
	b=UWIOKtDu+03TB2gStz7Pd1pypHbMZlr03oe/V2cIBikZ5xZy/JCGyVHFRT2YFNNgUIGaeT
	CBhwgIoRj3h/b1OLwf3etczMqWCcgmHcU7WuI/+15sbOn7VgUDmO0MwYa4ChCWH6oG6qcU
	u2hdlFxOqS/Xdiw3baPWpho4QP2T0yM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756707164; a=rsa-sha256;
	cv=none;
	b=rm2PiAsiknY/MR7uDHHx/FCE0yRcVa656z7zK4UB0x/Hqnt7xkAsWVBFeHmxSraiz8OBhi
	JgONiw63+iZwG/ndSDU8R2TsNZtGg9xzB/yWSkazTTCsak6xUzRwRPxjMwi2p3l412V+mS
	BnGX2eD9A1DayUNqqL/EyNc0v6xP/dk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="O/GYIJcj";
	spf=pass (imf16.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-61cd6089262so6000692a12.3
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 23:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756707162; x=1757311962; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rG8qInwJ7HC+M9uFXGeO7jifDwFcNxLl5I1yIPskFEM=;
        b=O/GYIJcjAY0mmkq+a5H34sf8bGilpmX76wbT4qk3Qh0EnHTHSw9Oe+n3cS4csiTP8T
         CcRTUySWhhyGOgZUSXfXn9xa1D4DIRp8q+AxlgUSMEHouHszjaZrfcaRTaIVPN1YPggo
         f1ROTB2pPnicMtd5vXtJakv8/IozGwlfUMgmDOkN7dPpOCwlP+SL0G2/ToZOkQbw3MzY
         uPqnGg82JEXusbBPhn698q4rLsTfUEkQTePxZBP9YZh6TWVuN6XGsFiGMyIxOhqbSCXQ
         oh6xaToJAVAAUW8yWhRssSb+ED0WmhgxpagAPvqxLDkYXaFLwMS+KgWSPmcjuT3f1oX2
         y3pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756707162; x=1757311962;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rG8qInwJ7HC+M9uFXGeO7jifDwFcNxLl5I1yIPskFEM=;
        b=prsKGDoyXvNSHj6JPO0baws7lXT9BskAl26KXOpO8GQEBsC55uR2kQsJa0XBFDhjFb
         gYDn9T3Bmyh4iLBJF6HrtY74F6L8dn1EY3+QL7sh4f44ST+9u/pbB4oXyRwrHbPbquJR
         f6xagEM0QdpA3/QdssF8JwZSQiZVWgcqoC/MxtE8jp6KlCX+6IuoHHlhaSkkd3Fohvle
         9FIjqWZZxygR5I8UjJPQ+tj44biRHhrMVRZiZGoOjAfqfPEeSs6NwESvVeSErvdfM7hr
         8k4vRch+i/TVvdKMgR14ou4tb2zZGfdbkpqfHflUsa9t/fkbJBDjluqqn6MBYGG6G6Mp
         BCiw==
X-Forwarded-Encrypted: i=1; AJvYcCUU/2VXkZdDjo23eyE90jL3Jw3zoS8+hZVDh3iHffQVOuOZ8g6MKL/gDI7/RjS0W0HeSwUWJyFa0g==@kvack.org
X-Gm-Message-State: AOJu0YzWjb2TCBT7OTdRT/wAlQW6cZchLNGVDIL4QAPVOEgtGN1bb3IC
	moHzVC2LaRYYyVpWWA9EO7lmCKChKnqk9yfFXiRfDGfQ+rEGVliOIGV6cBp8zdVVEHk=
X-Gm-Gg: ASbGncsaKvtI+j+HKFpV/cwsKUxP2A+8jBtj0kyU0zv92TLL7KxMdfEdwzy99ceONqP
	UCGuB2e87S4UVPZNO/fwV/HseGrKc9SCGgksttjqVmgABm4k4iEJuQ/QFOkhZ9qr9NDOEx+/4e1
	SRnIBBvjma1TGd+nrQZTUVqDdQpHs1AQPkekY0ZPt6aJHDIzGBpNwwyWkQY9Mr8wo77kueKoHBX
	DNDPssByEkWOKeJEW25zsi1RuClzWqtEhAQ9aHKk/4VDrAITsTuE+eebb+FDJb3FJt0akDYowfU
	6ZOpscNxYz04JpiKptayAbOMBygLLRZxOD+tJR+qZk8Lb3+kK785kzPMuwOfp6cqIHA/2XVosxz
	A4eR03oUt659ra5fij/PigHIAqbDlGz9sikdN53ZWT+cWrC3yW3hKyadZMJaxqAN/KFgsodi4Ld
	6Rmy6/jz0FfMRQ0Wh2zFDhDnCKbHXR7/G1
X-Google-Smtp-Source: AGHT+IFAtjmwZ4hK4x1JPevho811XP+EdM9fOjsV5Bznkx8JWR1z6DDHqQxBXROOVg06TaWqpog9Hw==
X-Received: by 2002:a05:6402:274d:b0:61e:95b0:c95d with SMTP id 4fb4d7f45d1cf-61e95b11582mr2278334a12.19.1756707162259;
        Sun, 31 Aug 2025 23:12:42 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-61cfc231561sm6374533a12.23.2025.08.31.23.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 23:12:41 -0700 (PDT)
From: Max Kellermann <max.kellermann@ionos.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	willy@infradead.org,
	hughd@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	vishal.moola@gmail.com
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH v3 10/12] mm/mm_inline: add `const` to lots of pointer parameters
Date: Mon,  1 Sep 2025 08:12:21 +0200
Message-ID: <20250901061223.2939097-11-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250901061223.2939097-1-max.kellermann@ionos.com>
References: <20250901061223.2939097-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E34DD180006
X-Stat-Signature: jkg3386ejfb565mi5u1issgtdyanwiw1
X-Rspam-User: 
X-HE-Tag: 1756707163-559880
X-HE-Meta: U2FsdGVkX18vPTZ4trtudChJHl0HFw4oGe1O4uCV6PTcSW7XgMJGxHZAo40iQvw+2lPEfWAul0l0M6KwLyw9/A0MLk9lldiB0QJl5ctsItxDrSzeAo0jfe9afiYxZd/I/o4vB/MSZs0sj7kmYjxeWToeQqdtFRFV5UCtZij6X7cAa8WOa+eU2ZOsjll0HC/R0bhZBMKuzkaRDwN48Tuk10l9pf3Oa/7scOrMT1I2+kWOcBPhOZMh3dYp5touIlkA1GwOu3+/DqDN/hSNHVoKM3qfyPCqeOA6yu+hZG8I2xYfK5LlpbyUCZuI1ljcFnI52kHNjq7KDCeWnqZjOyns/NYrgc28tKbJme07wbI21oyl9AHFArMyZW3so0NXU0HFDa1kWbjUNeNO9jcoZV31UGVk0xhdD9eej2B6tqW4O0Fw0W+sJjykmFszF3sEjUklX31HnQmDcL7VELmVko/MgXijrefKrCrohel3M2L3wUW8P/2S0udZqLRtz8jfvNdL4Jt1ZOJxb7M8vqqz9y3AYEfiqZz1glHyQirWeE0a7QM8QS4iffam5xNrMpmCk6x/5lP8jjUvVK2LnAXMonGvWIOOzUBTfimejO5opLcew1qf+3LLv+I/l70U04JLeXlfW5r/4r1Zzd7Gsn0hZpDgYV2Rvnh9qaAduL0MuyP8nkX4GgSA2yJw7vyWIHNuZd2Q50wTAIZhuiKhYjOc1/qlmlhGwDoYJHtdC31ahkB+nTysRAimRQQ8sS5weTdhMwsaXYXkOVpkSq7Pqu4YUfdBkwSTPlx1bYKQvuM+t3zOKXu5o244wLoNPvga0+aKaUoTnu208wpk4gOfZ9PBV6BFtVCUIkbQh0VXUyXXlYN8oYKpT6MNWIOhC4VK3aVyOoWq3LowQMIU8qGgm/r9MRZZkGob3eZyMd0IKa+SRzceRVIPrvfwGFfebUpr59yYZcUeJW2rujRA/waXXK/xIgh
 6l7udog1
 VFwrryUuknWkph7G9Os1BYnLygZfa6rSsGiw47Tz16UOVGdBJVa7uDAmvb0ZPWunF75rd3YpMSBgGfmDKuOlgPYQ5IfUqeDI1ZDwh7t8hWhWgmzSaZ26X/Vf9fHcYZNQ4NeXRDRxWCaoFZ+YMguY5joiM7H3Jma1HJKQ6ePPMVLWgzwb7NbqkHpmLiPi7Qk+2bTUFrlkZxp1895chGQRWERw2ZYwcNS18l8mgKI7OgzEh4ISlIbvvwOslhV8KOEi7i7FueF+AZNhtlwmMVosrFMfrpsXKHCi1p4DXCrWHCkZix1fS8GEhsuu/rHlwOFQ1Wz0Xb3yE5CMyl9kmTsItGNPiwvZv2J8cDJGC1Plz61pf876xcg459bIrF5nSOAmobz5/B7Msp0YmKInn2FxKOyGgoAQ3JkdJamKw0ExbGsibnzoeXPjf4bbIsVhmdSEgUUCXnxGWggT+zpWSMIt5igA/Wd+X/8FBtJj3i0mbtalfO4e1XLsPImjJP9VDz6MBhpjv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For improved const-correctness.

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Reviewed-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 include/linux/mm_inline.h | 26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index 150302b4a905..8c4f6f95ba9f 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -25,7 +25,7 @@
  * 0 if @folio is a normal anonymous folio, a tmpfs folio or otherwise
  * ram or swap backed folio.
  */
-static inline int folio_is_file_lru(struct folio *folio)
+static inline int folio_is_file_lru(const struct folio *const folio)
 {
 	return !folio_test_swapbacked(folio);
 }
@@ -84,7 +84,7 @@ static __always_inline void __folio_clear_lru_flags(struct folio *folio)
  * Return: The LRU list a folio should be on, as an index
  * into the array of LRU lists.
  */
-static __always_inline enum lru_list folio_lru_list(struct folio *folio)
+static __always_inline enum lru_list folio_lru_list(const struct folio *const folio)
 {
 	enum lru_list lru;
 
@@ -141,7 +141,7 @@ static inline int lru_tier_from_refs(int refs, bool workingset)
 	return workingset ? MAX_NR_TIERS - 1 : order_base_2(refs);
 }
 
-static inline int folio_lru_refs(struct folio *folio)
+static inline int folio_lru_refs(const struct folio *const folio)
 {
 	unsigned long flags = READ_ONCE(folio->flags.f);
 
@@ -154,14 +154,14 @@ static inline int folio_lru_refs(struct folio *folio)
 	return ((flags & LRU_REFS_MASK) >> LRU_REFS_PGOFF) + 1;
 }
 
-static inline int folio_lru_gen(struct folio *folio)
+static inline int folio_lru_gen(const struct folio *folio)
 {
 	unsigned long flags = READ_ONCE(folio->flags.f);
 
 	return ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
 }
 
-static inline bool lru_gen_is_active(struct lruvec *lruvec, int gen)
+static inline bool lru_gen_is_active(const struct lruvec *const lruvec, const int gen)
 {
 	unsigned long max_seq = lruvec->lrugen.max_seq;
 
@@ -217,12 +217,13 @@ static inline void lru_gen_update_size(struct lruvec *lruvec, struct folio *foli
 	VM_WARN_ON_ONCE(lru_gen_is_active(lruvec, old_gen) && !lru_gen_is_active(lruvec, new_gen));
 }
 
-static inline unsigned long lru_gen_folio_seq(struct lruvec *lruvec, struct folio *folio,
+static inline unsigned long lru_gen_folio_seq(const struct lruvec *const lruvec,
+					      const struct folio *const folio,
 					      bool reclaiming)
 {
 	int gen;
 	int type = folio_is_file_lru(folio);
-	struct lru_gen_folio *lrugen = &lruvec->lrugen;
+	const struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
 	/*
 	 * +-----------------------------------+-----------------------------------+
@@ -302,7 +303,8 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return true;
 }
 
-static inline void folio_migrate_refs(struct folio *new, struct folio *old)
+static inline void folio_migrate_refs(struct folio *const new,
+				      const struct folio *const old)
 {
 	unsigned long refs = READ_ONCE(old->flags.f) & LRU_REFS_MASK;
 
@@ -330,7 +332,7 @@ static inline bool lru_gen_del_folio(struct lruvec *lruvec, struct folio *folio,
 	return false;
 }
 
-static inline void folio_migrate_refs(struct folio *new, struct folio *old)
+static inline void folio_migrate_refs(struct folio *new, const struct folio *old)
 {
 
 }
@@ -508,7 +510,7 @@ static inline void dec_tlb_flush_pending(struct mm_struct *mm)
 	atomic_dec(&mm->tlb_flush_pending);
 }
 
-static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
+static inline bool mm_tlb_flush_pending(const struct mm_struct *const mm)
 {
 	/*
 	 * Must be called after having acquired the PTL; orders against that
@@ -521,7 +523,7 @@ static inline bool mm_tlb_flush_pending(struct mm_struct *mm)
 	return atomic_read(&mm->tlb_flush_pending);
 }
 
-static inline bool mm_tlb_flush_nested(struct mm_struct *mm)
+static inline bool mm_tlb_flush_nested(const struct mm_struct *const mm)
 {
 	/*
 	 * Similar to mm_tlb_flush_pending(), we must have acquired the PTL
@@ -605,7 +607,7 @@ pte_install_uffd_wp_if_needed(struct vm_area_struct *vma, unsigned long addr,
 	return false;
 }
 
-static inline bool vma_has_recency(struct vm_area_struct *vma)
+static inline bool vma_has_recency(const struct vm_area_struct *const vma)
 {
 	if (vma->vm_flags & (VM_SEQ_READ | VM_RAND_READ))
 		return false;
-- 
2.47.2


