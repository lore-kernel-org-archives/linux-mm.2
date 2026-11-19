Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A649606A330
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 07:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=TMyFDD8W
Received: by kanga.kvack.org (Postfix)
	id 8E17F6B05BE; Thu, 19 Nov 2026 02:01:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 891A56B05BF; Thu, 19 Nov 2026 02:01:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 759436B05C0; Thu, 19 Nov 2026 02:01:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3755B6B05BE
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 02:01:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 819A880997
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:01:30 +0000 (UTC)
X-FDA: 85450972740.03.F75CC18
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id A444C140005
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 07:01:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TMyFDD8W;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795071688;
	b=hSKmZZvmybUE86SUkEYlNAmU8WUD43a4WFG45pjoE6yV7oWA/GEBdos/OaLeeyZ6h8tixd
	arZ/QNN64GzW7VhSXGJa67YWHNAzWpdCzAmoOPvvmQMq91oozZeX1Sc2w2PHDXCdK3OfZh
	4fK9GmRNdGLo6gtTlMK9LVBwt0giG2c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795071688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PqykPPsR7vG8RbNReH5m+C9K46mE2LkFenHsUlsFdp0=;
	b=vKCK40z8yuiKjYX0HKkhktFtGvehph+v4FtABpuzAZnaG/pBwPJfI8hwyeVIuo2DN66Woe
	yeH4IA4Kkb3ug10+kxbrMy0ijBRw++7FHgAa2soaGP0HUVPu1r3oEAd1nuXAsJR13KK5I/
	Loh41AzGgPO//f8Fz+Aja9L8L7WrfVw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=TMyFDD8W;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf09.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3acb11973c3so1668325a91.3
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 23:01:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1795071687; x=1795676487; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PqykPPsR7vG8RbNReH5m+C9K46mE2LkFenHsUlsFdp0=;
        b=TMyFDD8WOxGv2IsURyBVanG0D1JHVQ950KJMUzaQkhWTzrtN4td085LCz5X4J0vKnY
         w6z48aVT8kZ+FFWq7GgsVQUu4ljH/J1HqD90hwlrlWACusF1iv77NHWCqNcm8AFQ8oBe
         M2yq0ZsbCas5RxdOFSgykLLiHz8UjiGN7s3ba09eAQoSr9VrDegcOgko4Ilu2rvnJqO7
         PTYP+5brBIn0TZYbl5A2Gt38M7COEKL/2vQz02el67zuqQYzufAQ/2KaOq3M1JHVltme
         WG4D+cCeSFWeyreHtg14PWBS5pkdW100Qd8OfFDXsrjhRMfsDfmMwIyO4Vz+xTK5Tbiy
         LYQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795071687; x=1795676487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PqykPPsR7vG8RbNReH5m+C9K46mE2LkFenHsUlsFdp0=;
        b=fyoMWhzxH0d4F2TQnzgO5+JybhImdgYElkBUPGfO5Ht0jif/PdAmrI/fFXBxsP48b5
         NAEEGDW5GyNKo+IsxZOpjK17RTU/ufptUmJvEZvH9b3xRVsKjOuI/ZISQoKqCsLIoIIB
         l0GIFLhZhQW+mwbh0keWkKTxylX/gyxETyTgdZJ3xduRpAmnhP0X5qapxmJl2ZO9YJvL
         xNVrgXONvpruopMw2HLbIYzddYNxzkFewl4VGyD5wz2wzmICmsY93uH9WJcj4Q8Ln7Yy
         442o0qUKmtbtmow6TxnU6JhGApgKJgXGntjEZ+7xQYKokRwuNTnWJCgUKYJMkSi7CJJe
         m+ow==
X-Forwarded-Encrypted: i=1; AL+hErFp+VWO6EE3PtMiUj5ZL9hinwYQCdftv4j+ntgrtNnFGslTJQS22pg2rjVyPTudFYaM3d1KgoMZug==@kvack.org
X-Gm-Message-State: APuU4Z/EbFjfrC3ApXZnh5DhC35/7CBwOwgatCIZQ1ucJ/VBzeXd5mW8
	tfo/eJK+0ATNKRJkzEfhIPTACvH1PRA1RUCITe/zzi7zzsQUknAioTw8pH6f95CQpbI=
X-Gm-Gg: AZFdTZdg7GovbCTT8g8KGhzuo91p785RBb+0WZs+XUOwTX1E0IbAq8nIXWHOxGd/Ts/
	rgDz/iEJrI7v0A9rBzAHy7S6668mVZsP0tiIZuXKjNURDHiRYH15NxFija7Fg0fNIkmBmQ3uNpg
	9FjV81j2LzhCgV2qNJxeR77buUlbT9Pih6UMa8iRsT9z1lJ6dUgfDeHnSCoAaYOTgEw9C9IwSNj
	RSvjakwSl12EJp8UM58H7lXa/BYXVnK//lSsTbpfsmYSa4H+mMTiHMHMx48wTgZARsDRoT48H2b
	yRgMp+gsgErxKiR3vWbZJfBT5VyKlnQtGv3bYTlgx23Oib+eWRObutg2eo5A+i/P8heeDmgnpMO
	cufoJF2FoqsZQKu3nMChtaK1J9Fp1kqOXUMzbE4SMAGkasscfIc1J0lLYDDzA1+z3xevlw+OuwW
	jh+hoM32Xza2iUXvt4BlChKMkQNVSb+rPEQKuiP1fr8zED0RWy/R3sWwxaWIgW9Ops4MBjjaSgo
	L38+O6EeDNbUveTOhot/0k9vDZAEgfW2pjlUyh15MDTqQy95Tv4egWucZITvnwujyWmULqSaT30
	PsSEnbVmK9C5s0kLohG1uXHiRB4U71jP4ZuWwq7kVA/pN05Xrw+PwMgFpgE=
X-Received: by 2002:a17:90b:2ec8:b0:3ab:c80:9370 with SMTP id 98e67ed59e1d1-3b3d0759d8fmr4252956a91.20.1795071686861;
        Wed, 18 Nov 2026 23:01:26 -0800 (PST)
Received: from G6L4RL2QG9 ([2408:8440:c38:5ca5:3175:932a:757b:716a])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b402e75223sm597488a91.4.2026.11.18.23.01.05
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 18 Nov 2026 23:01:26 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Chris Down <chris@chrisdown.name>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Muchun Song <muchun.song@linux.dev>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Pranjal Shrivastava <praan@google.com>,
	Ketan <ketan.kishore@oss.qualcomm.com>,
	Mostafa Saleh <smostafa@google.com>,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Sashiko <sashiko-bot@kernel.org>,
	kasan-dev@googlegroups.com,
	workflows@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 6/7] mm/page_ext: inline unchecked page extension lookup
Date: Thu, 19 Nov 2026 14:58:11 +0800
Message-ID: <20261119065812.89959-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261119065812.89959-1-songmuchun@bytedance.com>
References: <20261119065812.89959-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6bn1y43ms1sbpdmoakfgn6z4usibu1f5
X-Rspam-User:
X-Rspamd-Queue-Id: A444C140005
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795071688-165656
X-HE-Meta: U2FsdGVkX1/puIz+OFz3nzW3ZTRO9snLuo3l2HDzL3yDLQVkQWvUX5nZmuC0Tl5eMNoFL92PsdekaIBG4Vd+ZeKHEHoYwj4fobP1WABPqXK8mzcl/+yNvdW+a8Cvrer1fal8mg2z90te6v8fmni7uLFB6dxUQ+RkeKM9u+NzTghszt2aVf+ju011pEJGBzI6/tGKrwX9FVZ55NhP6JCQ7HDQzqal/yv0EXe8//Qhyv/Ehjqt2sSAZU82UX9oryOI/GYK+Bq7JET2saZTwRRRbLEeh9fkZ1hVQBcb0wMtiyGJW1R2KR6xyofGQYbmoCeVy7TFQOgrVbtVzXI6k2JYAcMt9FbbOOMB3WTYrHbOSvx7UtxvGsbjKWzKW0gAVoDG5po0bnwGjJ4CNI8B68Tcr3C+4HElfyrAcKQSoUoJNf9ywSqpvDPiF2eSZihqyA1lSTvX2Mp+vYWzIHjoQ6GQzv7SJow/+risEh7YOc8K/+2SBgG/V1ZshkT75UxlS4aJhtwNO2fL7uSWptQCYc9ftfJ3Hh4vP4aQL595tbuuTFRliAkInuoJB3BSNvUkWf1TmyqqPn94YFD/0eYic00ExbOdKI1ztDbSThelBEgKgBKLXGJDO6eUugaildjudpPi55hTsFbR1uFgs9EWJTo3iohUp8EWjFDLS4u8n/8czYDkPkdk6DhgYQECO8bOpbh9elXQd4nmEUd62kMlCD3fJhBmbMA742s4+IMGcG0d5YOhn8Ao/WTThtiTkRUUIWSdB9WwduOWfuLsYUxSSp+dIG25YRurgWITlGiNgi4HoYNmZeDmoF1Y/Zg3MOQCWQ/8MYo+OS95F+ztc2ohUu/xlXGQDAI2mcJypOMiPy/EF7fkosA0xQN5f6TWBlNYBgOBtu/5tppSJM1To/fTX3xx8u/ijfFPymCA4Cq26HOAfivOyns6tMZ1GiM9V03vqYeRNiUY8Th2/IZj74C0zY+
 9gh7Rr0Q
 rURzxD9azKT78sdQpbGt9erg8GxGjgXTiVO6DIZ9Miaj2P78919TeGKzAkO1VqwiMJAS0C/gu8tb8mYeyZdqCxFUu4porj+MvZJIdv7WYgnniv7lkG+kEvWqa7pVrqJ+poW8fNBa2tlr0jDY4FZMia4CozZNY8nqMHVc+lkDecTtjQ1iOy/v4TKkrcPWTm9ZQu/x10vNyh3zfw4kwr46BCSDvrW+lTbWATB9qcJ2FerWzOPW9a1/r96EA5Re/9/hWU+NhIMQT9rSCxiYlbv9iBBu9HMAGv4/eoN6h/Y18Fh6VILVxv/+SuTMmquzGA7CT+rsJCZ5RC+j+Pwgbg8XKC07XEYyF8Am79EIiogXekKZZh2A5sv7JK0R3o5xAEXE5hBCJVKZWsJFxu4JyBLv5J2A0pmnOUk+IcKQtVVZcAxjddeuM9S4/23KbREPJGYzbFCTZSaVX2RSSCLN9i553qlIq0jydO1s4ufQF82TR9c+g+nVWhTB+35fK2g+G28JmC0gZTtSid2zeq3Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The KMSAN runtime needs an unchecked page extension lookup that can be
inlined into its uninstrumented compilation unit while page_ext.c remains
instrumented.

Provide an inline lookup for this use case while keeping the existing RCU
checks for other callers.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>
---
v3:
- Collect Reviewed-by and Tested-by from Chris Down

v2:
- Add a preparatory patch that inlines the unchecked lookup (suggested
  by Chris Down)
- Use a PFN interface to avoid architecture header-order dependencies
---
 include/linux/page_ext.h | 46 ++++++++++++++++++++++++++++++
 mm/page_ext.c            | 60 +++-------------------------------------
 2 files changed, 50 insertions(+), 56 deletions(-)

diff --git a/include/linux/page_ext.h b/include/linux/page_ext.h
index d00320106a58..166f8be11564 100644
--- a/include/linux/page_ext.h
+++ b/include/linux/page_ext.h
@@ -64,7 +64,14 @@ static inline bool early_page_ext_enabled(void)
 void page_ext_alloc(void);
 void page_ext_init(void);
 
+static __always_inline struct page_ext *page_ext_entry(void *base, unsigned long index)
+{
+	return base + page_ext_size * index;
+}
+
 #ifdef CONFIG_SPARSEMEM
+#define PAGE_EXT_INVALID	0x1
+
 static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
 {
 	/*
@@ -73,11 +80,50 @@ static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
 	 */
 	return next_pfn % PAGES_PER_SECTION;
 }
+
+static __always_inline bool page_ext_invalid(struct page_ext *page_ext)
+{
+	return !page_ext || (((unsigned long)page_ext & PAGE_EXT_INVALID) == PAGE_EXT_INVALID);
+}
+
+static __always_inline struct page_ext *__page_ext_lookup(unsigned long pfn)
+{
+	struct mem_section *section = __pfn_to_section(pfn);
+	struct page_ext *page_ext = READ_ONCE(section->page_ext);
+
+	/*
+	 * The sanity checks the page allocator does upon freeing a page can
+	 * reach here before the page_ext arrays are allocated when feeding a
+	 * range of pages to the allocator for the first time during bootup or
+	 * memory hotplug.
+	 */
+	if (page_ext_invalid(page_ext))
+		return NULL;
+	return page_ext_entry(page_ext, pfn);
+}
 #else
 static inline bool page_ext_iter_next_fast_possible(unsigned long next_pfn)
 {
 	return true;
 }
+
+static __always_inline struct page_ext *__page_ext_lookup(unsigned long pfn)
+{
+	int nid = pfn_to_nid(pfn);
+	struct page_ext *base = NODE_DATA(nid)->node_page_ext;
+	unsigned long index;
+
+	/*
+	 * The sanity checks the page allocator does upon freeing a page can
+	 * reach here before the page_ext arrays are allocated when feeding a
+	 * range of pages to the allocator for the first time during bootup or
+	 * memory hotplug.
+	 */
+	if (unlikely(!base))
+		return NULL;
+	index = pfn - round_down(node_start_pfn(nid), MAX_ORDER_NR_PAGES);
+	return page_ext_entry(base, index);
+}
 #endif
 
 extern struct page_ext *page_ext_get(const struct page *page);
diff --git a/mm/page_ext.c b/mm/page_ext.c
index cfd20ed72884..63af3d62ed74 100644
--- a/mm/page_ext.c
+++ b/mm/page_ext.c
@@ -63,10 +63,6 @@
  * can utilize this callback to initialize the state of it correctly.
  */
 
-#ifdef CONFIG_SPARSEMEM
-#define PAGE_EXT_INVALID       (0x1)
-#endif
-
 #if defined(CONFIG_PAGE_IDLE_FLAG) && !defined(CONFIG_64BIT)
 static bool need_page_idle(void)
 {
@@ -180,33 +176,7 @@ static void __init invoke_init_callbacks(void)
 	}
 }
 
-static inline struct page_ext *get_entry(void *base, unsigned long index)
-{
-	return base + page_ext_size * index;
-}
-
 #ifndef CONFIG_SPARSEMEM
-static struct page_ext *lookup_page_ext(const struct page *page)
-{
-	unsigned long pfn = page_to_pfn(page);
-	unsigned long index;
-	struct page_ext *base;
-
-	WARN_ON_ONCE(!rcu_read_lock_held());
-	base = NODE_DATA(page_to_nid(page))->node_page_ext;
-	/*
-	 * The sanity checks the page allocator does upon freeing a
-	 * page can reach here before the page_ext arrays are
-	 * allocated when feeding a range of pages to the allocator
-	 * for the first time during bootup or memory hotplug.
-	 */
-	if (unlikely(!base))
-		return NULL;
-	index = pfn - round_down(node_start_pfn(page_to_nid(page)),
-					MAX_ORDER_NR_PAGES);
-	return get_entry(base, index);
-}
-
 static int __init alloc_node_page_ext(int nid)
 {
 	struct page_ext *base;
@@ -252,29 +222,6 @@ static int __init __page_ext_alloc(void)
 }
 
 #else /* CONFIG_SPARSEMEM */
-static bool page_ext_invalid(struct page_ext *page_ext)
-{
-	return !page_ext || (((unsigned long)page_ext & PAGE_EXT_INVALID) == PAGE_EXT_INVALID);
-}
-
-static struct page_ext *lookup_page_ext(const struct page *page)
-{
-	unsigned long pfn = page_to_pfn(page);
-	struct mem_section *section = __pfn_to_section(pfn);
-	struct page_ext *page_ext = READ_ONCE(section->page_ext);
-
-	WARN_ON_ONCE(!rcu_read_lock_held());
-	/*
-	 * The sanity checks the page allocator does upon freeing a
-	 * page can reach here before the page_ext arrays are
-	 * allocated when feeding a range of pages to the allocator
-	 * for the first time during bootup or memory hotplug.
-	 */
-	if (page_ext_invalid(page_ext))
-		return NULL;
-	return get_entry(page_ext, pfn);
-}
-
 static __ref void *alloc_page_ext(size_t size, int nid)
 {
 	void *addr;
@@ -365,7 +312,7 @@ static void __free_page_ext(unsigned long pfn)
 		base = (void *)base - PAGE_EXT_INVALID;
 	WRITE_ONCE(ms->page_ext, NULL);
 
-	base = get_entry(base, pfn);
+	base = page_ext_entry(base, pfn);
 	free_page_ext(base);
 }
 
@@ -508,7 +455,8 @@ void __init page_ext_init(void)
  */
 struct page_ext *page_ext_lookup(unsigned long pfn)
 {
-	return lookup_page_ext(pfn_to_page(pfn));
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	return __page_ext_lookup(pfn);
 }
 
 /**
@@ -527,7 +475,7 @@ struct page_ext *page_ext_get(const struct page *page)
 	struct page_ext *page_ext;
 
 	rcu_read_lock();
-	page_ext = lookup_page_ext(page);
+	page_ext = page_ext_lookup(page_to_pfn(page));
 	if (!page_ext) {
 		rcu_read_unlock();
 		return NULL;
-- 
2.54.0


