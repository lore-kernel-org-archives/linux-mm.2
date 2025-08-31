Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FDC3CA0FF2
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 09:40:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 041A48E000F; Sun, 31 Aug 2025 05:39:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3A2B8E0001; Sun, 31 Aug 2025 05:39:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1CB38E000F; Sun, 31 Aug 2025 05:39:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C564F8E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 05:39:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8779EC03EB
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:48 +0000 (UTC)
X-FDA: 83836555656.24.C17490E
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id A3FB11C0005
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 09:39:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="Jwy/SIel";
	spf=pass (imf20.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756633186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rG8qInwJ7HC+M9uFXGeO7jifDwFcNxLl5I1yIPskFEM=;
	b=KxSg61ncKKpvsmesuSAcmGojB3Anpgw/jjRFdVWLrpLM9tX23mqoLlMQGWoTFsjY+mkEIo
	SoF7H7Ng5+MlbWs3RH9U15an95W2cHyVvnJFwt3xDs7PoCZQwsfjIZHfaDvioF2Z99whA/
	qef0vLyf28/iCYmgShn0mdmuzC4z1qM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b="Jwy/SIel";
	spf=pass (imf20.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756633186; a=rsa-sha256;
	cv=none;
	b=623zemylUJMZo4ertrNJs5bwrJ8Ur+13UW0mEVX/CagD4Pw6fotJgIqGGkiqzdgs6PPlaL
	ufVwyXxOxeE6lqNednVcyYrBU2BCauLpw6j1F0EV4G45tJSZq0Z88Mb0nKmkQG2WwGk9Xd
	SjMqeOti/wRAF3fVxexTteukG1AiaAA=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-afcb78fb04cso574156666b.1
        for <linux-mm@kvack.org>; Sun, 31 Aug 2025 02:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1756633185; x=1757237985; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rG8qInwJ7HC+M9uFXGeO7jifDwFcNxLl5I1yIPskFEM=;
        b=Jwy/SIelQkmSNXuKJ0FGHEoKgNbPOQ0cWLYrtf+l1UKG8Ih3LANRp6te5Ysd3UodIn
         6U1t+JCBLEb4kk+NDuGccBkxxjvckjHblkNcOau1KH9HxDqFa2yIhmqX7efQ6Xb5sPIA
         4Z1CFB0r7MnE2xCA2mg41B0QcYL4gzvYPDmsIXQm6wUIJHRFAKQDKz7ycHO4H+Bb6l8A
         ShRPEQE6oUJlarV98acumhnn6EBd3hJZLnhgVMliGANr4WASgscCBVUM6fxTwnqTmhVK
         n/I/SS+OsW/IiQabi6h9TEqrKbyhwn80GWzwK9d9YQ/vkRvrGN+hCmydXd6r4xJR81wk
         PEXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756633185; x=1757237985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rG8qInwJ7HC+M9uFXGeO7jifDwFcNxLl5I1yIPskFEM=;
        b=DWzR86LUHkJ1457+8+gABFtcjRCguR1iMxmkMJrh5YtRLZ1EqN9dHz6y9kdVWOkCb9
         TmL8z5F8hRBArXy9vaU9Q0Kaledl1o9lLD/WlWTYd2F1GgiYCjb0gYfB6zTYnhpCyCgv
         DAtamJkiJJgo5oN9mX0p46Ld8LmTE2uOghJzGnLSEWGdEPYB0Fqgjt4iNBSlvpMZas0e
         /+qg+09PqHLgPTB1cjYzqhDr6YMRO4FfRSi/WE64SFyafnq1GOxuXnSrTML836KMKoYg
         o44MfN+uzYf3HcI43hQ2FOQKLYu/3Oftn4e0+JZhhv3xlbIrPTOQs2cfpABkcILBkywl
         3mgg==
X-Forwarded-Encrypted: i=1; AJvYcCUKUQtMYm9NYL9isoUinRdJVWdZd+8pyd/vIiLp81U4TiImXN/mTey7Xt20whsr31NDM0JZeZUr3g==@kvack.org
X-Gm-Message-State: AOJu0YyzkucbKiNfKBzv5+CrrVLMJ5G4iFvgMAWeAZDT53pJqB/C6iuN
	zRvqalex3yOhc9EHIs0MIao0MClEeJ7Kt6WfVg6PJQljFNY7YBPn3gCj2KZI/iWdOMg=
X-Gm-Gg: ASbGncsWBvNCxBTIxKY6UQ7ecUVzPhBeWg2DtifA+y78uGws+4/HepgxbI9QCdokX1w
	oZWQy0bau3ks+wB/d4w97rhmngFoMP6bbB742ltawDyXFDZQlEAPc1yZT/gQNu+FxhoWBYKY5ds
	uSGuR++TwUznKaAyl1+MFmb96GxxuGGO5A5g1fJP4OXuRD79svN8ybYu+/1teJGqE60Bo7AUSE+
	HOitDcofSxICZcHAMbEUG3NVoglV5C9hI7rD0T+8ZMAbBxSyIDR4d+GdGkRcFT88tKhwn7GZ1h9
	9DHrLt09RhRvCTzoW8j9YVhsbL3mTuzCieTTEMFWu/mAg84C6IuFov3UYCdIsI64fFypiMNngdX
	SvNNRO8s+LtNLr5yBgTpEIF49Ey+INnd0ZrstdEd52f1EHyHCg6ASF/vpf29lklTdsywNjKUrqI
	THx8fwdgDBCMarMAsGbHHFZg==
X-Google-Smtp-Source: AGHT+IEItZu5qd/uBWt3kniekyRuMwuRZURgEX22zC0t6tG3oVHjRNN/jljliIFQxqA84wsrfCrfkA==
X-Received: by 2002:a17:906:f586:b0:afe:e744:3058 with SMTP id a640c23a62f3a-b01d976d94dmr412983566b.50.1756633185141;
        Sun, 31 Aug 2025 02:39:45 -0700 (PDT)
Received: from raven.intern.cm-ag (p200300dc6f1d0f00023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f1d:f00:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-afefcbd8656sm597512566b.56.2025.08.31.02.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 Aug 2025 02:39:44 -0700 (PDT)
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
Subject: [PATCH v2 10/12] include/mm_inline.h: add `const` to lots of pointer parameters
Date: Sun, 31 Aug 2025 11:39:16 +0200
Message-ID: <20250831093918.2815332-11-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250831093918.2815332-1-max.kellermann@ionos.com>
References: <20250831093918.2815332-1-max.kellermann@ionos.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A3FB11C0005
X-Stat-Signature: jeqcarax9smmrjob7qdqfcx6nenoyx5g
X-Rspam-User: 
X-HE-Tag: 1756633186-484330
X-HE-Meta: U2FsdGVkX19O4YWSqmByZvJhhhKGuKGJdxxp3EiS1T3SaWe4KLIwuKOAkxpW6BiDEHZDX2OzZeQKuHwzAK6shMboDrbyQ2UQo2R4XEc5aHp995hfrbFdzTUhEmC8Vpp02XrX1nxM47EHCXkC1rLpG6lOmrWtPSA8ai9CGKZkZtr7fAxPAjOGofX2UFcJRvO4JncvO1N5vDpFY81KKgD2nMa3wiE0N8PYAHL3BrfT+ZzQLCP0l1+FbD6Y1JsjPZumy0CZNNzakx6LA2OKzqtDE7QqrId/XLQQ58xHQKVybUoaD8LIChyadLGj4kQYGJze8N9v8VsI572D/z8TpVJmJrU+Z25oK4N6bLGKqD+RVO85nBGURo7116GLbZ+Tmss3xmp25cnqlqCrllrcxZQNlrt0GoEjO+v2UU8zhMyEI+ScWQ2KBcPe21oSs8mPQJcVk8NwidRglsPRpzd9CoXMlu6ofhgCG4j7QEzZrPsziXHfoz7ItZALqPE0bp205u9L9tBz4qgDJ2J+e3diVjKU9ZHIyqUi2p9G42Zy4l9bilSgRKEI2+LDTMzzqXaz0ubct0fKcKclFWKBh29iIpVSNGwdduurOiZPhaZxijyCKE0AYl69rDaZ5Qgvd0PhFLM1bS7+RkDEVrO8uzslhCbitfmM8SGVbcMcFGYOYkLi9LOrgRtO35aqx9nwreN79FGQejkwDWadG81cYMl/DrLu5l1BONa1frGJmcHPKdK9e3Zh3e+nJVrFTTnu7DCRGRgyQNUydeD/gFMPlDU93We06y3hEGfoN53+Pdbiit5Y/CkbsbmYc0aeZO5/pEyHKj1IEPvFe/QMOtyP1UElZRMiUjI/pN5ness+uW/wKpagxXjwJcdGJKjRk4L4Qf3ZNJoODsZUhy1ojORIDP0rjMZmJba5wkatSXrM/jFDPYrPX4/cf3SPQRzWWui2HUIMkscOwziYanqAs/DZoQWbBOq
 AqzEdc2z
 qNDeXSFld6echsbjPvff74oZzmuDbENQ5T1gTkcbJwXfhPkccrY8KOIa4ujwJ+h0zPBc4kyYX1LNQq+5BypPPztqQCevRqUGxUWFw9Wx1JCz2rHd8UHqHoAV4uAPrBfRNGrCyzcs2D3eXCvoRsM2aLNpFzbv/3y17OemIr5nmoEIYsf69gTqftwWhlOCfay/REiGlOqOcil26aGB3/po9TLcoWxDj083EEGRdXkNnS6jQKrpkcMaEgGIjLZJqt3wQgQ5qa25Sh/hh4h3L8ltOQ4OVP9RPeFln/f1uPSDbgEbJ/Uyj8hG2DRH0RtIxe/tp7HJXCAwweU88c9jmtLyBztvkLxgWA25M5a4vYEsXq3/AFgnj/GqAXwhpJDcwxIonIVsqe2HSYn3ZdYXgmjspS4sCLet+GC4q29U+xdl9bdeyHBljunHkVO/s09Z/o11QmHpo4ol/fyLCDKLlkch5zLRtkVDhWi7LXnApeO+Fk7nRKhQ2M3XMIFzRllqUgjG0BgcE
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


