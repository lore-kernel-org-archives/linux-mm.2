Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F685EEB577
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:55:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5E566B00BA; Sun,  5 Apr 2026 08:55:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E35B16B00BC; Sun,  5 Apr 2026 08:55:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4B406B00BD; Sun,  5 Apr 2026 08:55:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C664D6B00BA
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:55:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9235F13BE40
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:55:42 +0000 (UTC)
X-FDA: 84624498924.07.13C2823
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id B75F2C000A
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:55:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="kgL/Fiz1";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RosLEkDdV2Cdz9XETYo2dsVY+zgApycOz9SAkpm7hvM=;
	b=EKbbxO1qBS0OtbDPNE+hYZWARQ++/3oaQfvvYtXusWz2laW6mKxdOzraqsfc8iVsyPoF+M
	Wyak2Qfu8kwl0hgS5XfQgUXTdyWH+K25XgkoNFANJzr+GqKeBr6TMn6gijNRUtCCNdnA2S
	wiWMw6K0tx2gQo0VReI/8XGUj8ijugg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393740; a=rsa-sha256;
	cv=none;
	b=a62nnZeVj9tGNaQmcuahgftny7bcrAN8MM24nurmusQqBCHxs2T2nXRFo/IpPIbd12ru7D
	4ffoA+XHuJMiYP4RJjWiH5iB59PLCNRnPNZscDg2HKOyccZbjtXunU0+H60SFQ/AQQ1B2L
	/C6npPKvO7/sMwhpXhDPDULxeLyg5/g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="kgL/Fiz1";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf28.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-35da9692ec3so2875525a91.1
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393740; x=1775998540; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RosLEkDdV2Cdz9XETYo2dsVY+zgApycOz9SAkpm7hvM=;
        b=kgL/Fiz1Rn4ZgMG5KrMpAIxFclexd8+SgNFHtdtDa9VnTbG7be2En1DzTEEFG8yAFR
         l8ZAB4Kvn5LUwJ+m3Bi+rsGyPFAM2c/jxfHHMxLNeB6Rb3eR+x2F/WWoLECzjHvCJc7p
         LYoxNKeN/5qFaBgRQALj+Zg0fWZ9B32Xyt65R7Pi1rJF1d9M5JHH9XdiUX1anvA1hY4A
         Yf2mdp+NgBMkU3zqrQoz203oEhWNqFWmC0oNbXOk1CVRPGx49CubyDVpp9mV7UTs67Hp
         YYnL480rsqo0qfM0+CKT8GeE7qVkRaZ1D0L2QTqvdBa+rMaZJPkc79c5pJqQvZyIktdQ
         Uw3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393740; x=1775998540;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RosLEkDdV2Cdz9XETYo2dsVY+zgApycOz9SAkpm7hvM=;
        b=MrK27yaSj+cAa/6JAKDrvRDxpnlCTwq0Wxj45ZeZ9qPWlVrSoGS6q4RFYeSYrdv1ss
         ICqjx3N85mjJZ4rKXavc7KKStp0TFllpHG8FVLnhhFhW8LK8thHj0OiTW4uuM+5CK22L
         IqWqdGECJ2uKUi+ufDbIUHuIf4ndhKJtrp/Pnywy5YuRSiKlcqLQEo48peeArn7Adn0X
         AAttlxNJv1n3LBGE7CkQZ9SF288nTtEIQc9XAzQkXofO95aM/W0pq0OkdDa3qM/lHVW3
         43wsNOFxeA0ccR1XVK1/0Z1VyNGw4AMoXisCRLo7DvYQh7B+Yp04K2srS3LcZgEX04CP
         a0+w==
X-Forwarded-Encrypted: i=1; AJvYcCXyBUklut7TGIrtz3cN/XXUvVEvctiQzyGWA5s+cTHWYsmuu0e34/FrkOIz//H9tfTra/6mAUPBQQ==@kvack.org
X-Gm-Message-State: AOJu0Yz3h6aCk4mmWE1cL2kaFqyax5TLNVOqNn1s+4EYrz/PcOFoxTPv
	WLoiGDR2YhZlIciuc4HokNPUElPdUqs5wjC5vp1Nbw818LiEMRJ+AKCoQa4Gs6tOfKY=
X-Gm-Gg: AeBDiesfB5BHfxESZX4IjutDfTploC+uElH+mgTEmHkYSBA3KXv4S2vwVpX06x6KQyG
	F4AgWuFxbtI1ovQJA/lSEduyPszfnOF9SGi582yTcgvzuIYI4cXtr0AZuY4xI8plXNZopAhGB9D
	oq7gEJ+NJ4LEnjVBzjmiQGA7bGW8cBCsKCjHhl+utMYOcfDo+aY9ugCkfm43pxVeqUiborPs0PK
	PvyC8d/INxYk7Z2Scmo1Izh284U9QgZn+lR7tOLmhBIktCPPiOsuDny+5gnt+kQYtQz3Gey/vf4
	1kP6prFDg7iTvfk1V3Ovaby8XXyL14A+5pI/peBn45U+jSCVx3yXILdnqgfEG50HMDFsbLbwMC3
	lsQKpzOIJ2yudj8of08yqipFeZVU2pNKk9y+OxM84ZRoJtAmj8U6RamIlCX2p0se933e7XCA/e5
	3NiMhBAdZKDxFKwQ2oCANvGOXhdTyhTKeTUHcq2W7caqs=
X-Received: by 2002:a17:90b:554e:b0:35d:aeb2:25b2 with SMTP id 98e67ed59e1d1-35de69780b4mr8868406a91.27.1775393739584;
        Sun, 05 Apr 2026 05:55:39 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.55.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:55:39 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 21/49] mm/sparse: drop power-of-2 size requirement for struct mem_section
Date: Sun,  5 Apr 2026 20:52:12 +0800
Message-Id: <20260405125240.2558577-22-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B75F2C000A
X-Stat-Signature: c9khbnisikw3kqxca5ehts4qfk5fe9xj
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775393740-672812
X-HE-Meta: U2FsdGVkX1+FnPYC3mMLUvzb1X3+qvxstCC3eFaaydlrDGPiVPfEFMjAyX2Tg3ox/W4ZiHfpvpio/UFNQo0mPl9PTEiyppu+q1bPoNFsb8N76OGdrKAKP5H9xbr+UbjvnYl7GCgTEhxulKY5Wq4tTGC/ph3nx1yXJcglLG9cmE+ogO9mRbblBh9uNYMKJt8bk17CSAfSJZf2nwcaEYu40JHNuUmFEt+vzjcOc4SjlBzKOVNbzEYAtkDt+nLgU06KGzym6b6DJxjGzGySdDvoEx33RhDrhalqrAdF6HgZFwzQgbALWmbY1c29AFT2XXAkW9/rE4sl5Nxl4Yb72J/MNq7x2Yxy0any8yYz4E+NYY6gmoko0VxTcLjr4K1CqStPqf0gcLnl/pxPfMFFdBEiiOpyzJ34+Vo27h0HmFc8cE1H+3Jwe5iHAFqDV0holq5GEgz2UqzEWAWCZ6PWPcO01pbcmICQWDe7r3N4TrA9oK2U6gYOanVJOQ+oyRX5Fo3DVsdujGBG2hUnGSwDQwOWNvkbAAfobFEeAr+Xnw/bVK+Ae+wJ/MRLGrXvWL9hMX7b8pP0czgzBDMBDNnD3dgq9o/r16donKnOBkDkzU4YJOGON+uHlPns8qjc0krBc6LZ3EOPadTvC2R6+rImorrVA2bplh4tg2rJz2wrSEopNS+H0Q/7oS0cHnA8YsgOmsiaoKuH1b87Auqr9xPRxM90SoFA/455WCxC4/7reGcLEGZ7KpRN7zolJTuUwHFvat4eMpIcRrwh/1zmhSe5T/+QMpq3iKR8QQT50E6oFf/JM52uarYdEy5VpYO1j5TT2EXxKi8MS4RDQdsiLNm1T60avoYe5bR0tF6ZhE0HtSlV+agISZ3uYZkDYUdZ8EZlYAN5jpCnc3Gsn2ZWWd19RKeSOIRPq5dPyK92Cju53A6H0qd3amr+k5Rc/+FhNHeBQwH8KozNDuXtFPwXpII/X3B
 nvE9MOjY
 8zlVvUteRuTY6NvnUNgNMA9Vzklz77t29T+FFiyUsbji/nJoWUjdB6pM4xVZvVLZOUm9oY6IhWTIGlIjwA7zSXiwKsDfbFeuBYgI89F/nQGHy5rK8l8Pf5WqDETMfPo7SQvhoptXHx5+2z9/WNoZrQe94IhDxtmmShAF6UPxCOwFTkMZEu9VolxRD5vs6vC0PWwaLUNlkhDsbOBI8myYxX4mCffr/PaUVzjZYOs/+2NzL2+3aD+UZ42wr3YVazkNI42fM7zdPt4ZybCd3/8ke6hRoOc4vl8twCpsC4U60uKGzLkPqZL+ff7iXpPJZ2m6smSUi+8R80fDgF/qPtAhdz2trSQPT/Faed8pExFutCyDVIZ4iAJTnUJaGGPLWVrqbiRRv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since sparsemem-extreme was introduced, struct mem_section has been
forced to a power-of-2 size so that the section-to-root lookup could
use a cheap bit-mask instead of an expensive divide:

    section = &mem_section[root][nr & SECTION_ROOT_MASK];

This is enforced at compile time with

    BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));

and forces us to add padding that grows and shrinks with every config
combination, wasting memory just to keep the structure aligned to the
next power of two.  With CONFIG_PAGE_EXTENSION enabled the padding
alone can reach 42 struct mem_section instances per section-root page.

Drop the requirement and switch to a plain modulo:

    section = &mem_section[root][nr % SECTIONS_PER_ROOT];

Modern compilers turn the divide into a multiply-by-reciprocal approach,
so the runtime impact is negligible.  In return we get:

1. Immediate memory savings when CONFIG_PAGE_EXTENSION is enabled.
2. Freedom to extend struct mem_section in the future without having
   to fiddle with artificial padding or the power-of-2 rule.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/mmzone.h  | 8 +-------
 mm/sparse.c             | 2 --
 scripts/gdb/linux/mm.py | 6 ++----
 3 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 378feaf4e4ed..3e3755666846 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2013,12 +2013,7 @@ struct mem_section {
 	 * section. (see page_ext.h about this.)
 	 */
 	struct page_ext *page_ext;
-	unsigned long pad;
 #endif
-	/*
-	 * WARNING: mem_section must be a power-of-2 in size for the
-	 * calculation and use of SECTION_ROOT_MASK to make sense.
-	 */
 };
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
@@ -2029,7 +2024,6 @@ struct mem_section {
 
 #define SECTION_NR_TO_ROOT(sec)	((sec) / SECTIONS_PER_ROOT)
 #define NR_SECTION_ROOTS	DIV_ROUND_UP(NR_MEM_SECTIONS, SECTIONS_PER_ROOT)
-#define SECTION_ROOT_MASK	(SECTIONS_PER_ROOT - 1)
 
 #ifdef CONFIG_SPARSEMEM_EXTREME
 extern struct mem_section **mem_section;
@@ -2053,7 +2047,7 @@ static inline struct mem_section *__nr_to_section(unsigned long nr)
 	if (!mem_section || !mem_section[root])
 		return NULL;
 #endif
-	return &mem_section[root][nr & SECTION_ROOT_MASK];
+	return &mem_section[root][nr % SECTIONS_PER_ROOT];
 }
 extern size_t mem_section_usage_size(void);
 
diff --git a/mm/sparse.c b/mm/sparse.c
index 5fe0a7e66775..cfe4ffd89baf 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -394,8 +394,6 @@ void __init sparse_init(void)
 	unsigned long pnum_end, pnum_begin, map_count = 1;
 	int nid_begin;
 
-	/* see include/linux/mmzone.h 'struct mem_section' definition */
-	BUILD_BUG_ON(!is_power_of_2(sizeof(struct mem_section)));
 	memblocks_present();
 
 	if (compound_info_has_mask()) {
diff --git a/scripts/gdb/linux/mm.py b/scripts/gdb/linux/mm.py
index d78908f6664d..0c9eeed92064 100644
--- a/scripts/gdb/linux/mm.py
+++ b/scripts/gdb/linux/mm.py
@@ -70,7 +70,6 @@ class x86_page_ops():
             self.SECTIONS_PER_ROOT = 1
 
         self.NR_SECTION_ROOTS = DIV_ROUND_UP(self.NR_MEM_SECTIONS, self.SECTIONS_PER_ROOT)
-        self.SECTION_ROOT_MASK = self.SECTIONS_PER_ROOT - 1
 
         try:
             self.SECTION_HAS_MEM_MAP = 1 << int(gdb.parse_and_eval('SECTION_HAS_MEM_MAP_BIT'))
@@ -100,7 +99,7 @@ class x86_page_ops():
     def __nr_to_section(self, nr):
         root = self.SECTION_NR_TO_ROOT(nr)
         mem_section = gdb.parse_and_eval("mem_section")
-        return mem_section[root][nr & self.SECTION_ROOT_MASK]
+        return mem_section[root][nr % self.SECTIONS_PER_ROOT]
 
     def pfn_to_section_nr(self, pfn):
         return pfn >> self.PFN_SECTION_SHIFT
@@ -249,7 +248,6 @@ class aarch64_page_ops():
             self.SECTIONS_PER_ROOT = 1
 
         self.NR_SECTION_ROOTS = DIV_ROUND_UP(self.NR_MEM_SECTIONS, self.SECTIONS_PER_ROOT)
-        self.SECTION_ROOT_MASK = self.SECTIONS_PER_ROOT - 1
         self.SUBSECTION_SHIFT = 21
         self.SEBSECTION_SIZE = 1 << self.SUBSECTION_SHIFT
         self.PFN_SUBSECTION_SHIFT = self.SUBSECTION_SHIFT - self.PAGE_SHIFT
@@ -304,7 +302,7 @@ class aarch64_page_ops():
     def __nr_to_section(self, nr):
         root = self.SECTION_NR_TO_ROOT(nr)
         mem_section = gdb.parse_and_eval("mem_section")
-        return mem_section[root][nr & self.SECTION_ROOT_MASK]
+        return mem_section[root][nr % self.SECTIONS_PER_ROOT]
 
     def pfn_to_section_nr(self, pfn):
         return pfn >> self.PFN_SECTION_SHIFT
-- 
2.20.1


