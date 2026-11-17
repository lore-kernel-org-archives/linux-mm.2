Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CF0F606A33E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=I9XHLjzW
Received: by kanga.kvack.org (Postfix)
	id 68C4D6B05C3; Tue, 17 Nov 2026 07:07:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63CAA6B05C4; Tue, 17 Nov 2026 07:07:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 506346B05C5; Tue, 17 Nov 2026 07:07:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26E776B05C3
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:07:52 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9FFC71C3BEB
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:07:51 +0000 (UTC)
X-FDA: 85444487142.19.87258A7
Received: from mail-dl1-f42.google.com (mail-dl1-f42.google.com [74.125.82.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id BFBB180007
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:07:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=I9XHLjzW;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794917269;
	b=hYlNOCNuuVMzJnZCWM/Mb2Heoc10fSiHhIqOdAvgk//I/icGDcVRZ3aQfQOTRDMH1kNsMS
	8YcQGBuDG1EQPWEo5C20TKPtFGi9ldKNbGBiSJdo5PA1nSIK7r+ci7CaZ3zuuzpZuFLuBC
	rXf7XF5XINjxrxbQZXjvBZhOXDRJTOI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=I9XHLjzW;
	spf=pass (imf02.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.42 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794917269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WC9KwNg7vzWFhqtQelwms4WX3k2rA90664GjYEiCkuE=;
	b=T26aPGmxv5tnck1TLr+Hd5SbA7NPqpmUFXa1cxe6AZdNtisiGL7NpCJxJhob0waY6XDJKq
	tZOQ7TXwCtLXabRPps9QN0CVkHt+vCsVQbZzPNL0JBsRQDlAaXVOoXfcPMUYskN/BxEggS
	6xtYnLv4rzVgF8X6NL723T/0Pf6k26M=
Received: by mail-dl1-f42.google.com with SMTP id a92af1059eb24-14394530ec6so5819825c88.1
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:07:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794917268; x=1795522068; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WC9KwNg7vzWFhqtQelwms4WX3k2rA90664GjYEiCkuE=;
        b=I9XHLjzWXFo33rPckl1Xfe0fSvgEL6eQcO2WIlPYmDOYz8Jp5negcslV2p/ortXfBi
         Qqe6z/ESaRSsXp23aSWdasm3n9ADl4JmbIXMl9LFcAP5Z/TojeSRdEdYsRq5vyUdaZjQ
         /3NlNkXFirVU+/KnGon4sVklZCYpsgtovo5nKPbw8OSTXKlmcOp9MDvVGNrs15ghZF5o
         fGvo3PbVF61U5W90dIz7imbdp9PoVxJGIjfG7g451BF7AE1oVpd3uWwPqv1A4FZDiA0G
         +Bu01Zyfff9pdHVSkdcEgT/bSrQv7uu7v+ymuoPOJDVcI2WM6RmirY5MixXfVPKQHli8
         aemA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794917268; x=1795522068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WC9KwNg7vzWFhqtQelwms4WX3k2rA90664GjYEiCkuE=;
        b=Z+/7BCYNOpU2iNzcwVyNqMqBWBvvMeodDhr9l8rY6C5MLfY2lVKBWRjEbduMZYcY8D
         NTiQR3OLNO1KVsB++YuhHS4F/P6qu6ecoDKFRhDdGa3n/wHr7ee525sZptt8pzw2H7QT
         vabtlxsD/PvRuHmMyAbImgHpVtCifOPaVOGU9Jymvae4nS9oyxjqVxvo4oeevU7WaqRq
         55JzgcXBhC+xtHEQTFl3OKbc9GZ4NFBaqdCcrKDZKBm2PpQ4JemE0iaCejsnLENN9AcU
         IXfaDXI/qLHVy8S93c193u4dM81o3iPKdQTSs3I8eGY2UzhGWQHTlM/6KmKMxE7iQofE
         meOQ==
X-Forwarded-Encrypted: i=1; AL+hErF6VcWzy5yexo+AnpYqHZEtiGU3kSq5llpbAeSb7Bz0DhHsKRH1NNWFQ3ub+XEr0uvZdPQhHL8YzA==@kvack.org
X-Gm-Message-State: APuU4Z+ymVE5EG0zCdKs3fhehyFF2GlIFV7G0OcpQPU8Z8eVL93jqxb1
	BQGiEVEBPZTlYxhJOehEHjWJrE26vhrdj16YUbvHyu0oi8suUYr9Imxspmc1bzfGqas=
X-Gm-Gg: AYBFou0bqZIwLOqkyzKt0Nx2jv5TRlAWoWgcCTGGJK8eEYm+Y5lNzzsS6d2IXNZ+3qY
	0pgMIogvBXa+5PzW0179rVWVGm4jlmIR5+PfqQjl2eO4nLwrVWCf9Kb1d2CnHqscbnQ3mtPzdFg
	eyimxj6EW5xroD8Ew103zVgYPRlH+XF5wXAN1rPpQxuhcmBozdz3/+kIXuHGrdaQOZcVIWHXPJT
	hNCjO02SIfGXuqbi0kMqGxZ7UxcmYu96lv/VLcfVpp6Qu2D1V8A0V18wOByEN9KA1HY6GActPfO
	ko5raypjM5grF646qEhYJLg6lFHNFOOlfbc6Zb2ky3pkhE7CGPQV7yJik0Hfqg9F9jmLegRHKHG
	xUIVXMjKchS7HuTDvn1QbcbiB8vuwfwwYHmzSF4trK9gudkmXecO5EI/W6yTIJeSSg+dgPThq4z
	g7l6PrefPqtm1639QRcchNtgAh5Y1omU78bvYxerwEjrdiHMbPZEsglMqASpoV//R+6+r1u6E9G
	oTgODq1YMlmoGILnY66NoEvGC5sgWbylcoHsEnkfrVb+0h3OWp1nSXVOywyYR5hDNlJktl/iYXj
	yFp6614bRGovGSAxfQ19dcZu9sjgIAtJMQkkJlEegUVMBTP7LLTNAZMorFomeGUH5OY=
X-Received: by 2002:a05:7022:f116:b0:1b3:af3a:e793 with SMTP id a92af1059eb24-1b502fe37c6mr12306756c88.0.1794917263484;
        Tue, 17 Nov 2026 04:07:43 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031468b7sm47347116c88.5.2026.11.17.04.07.37
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Nov 2026 04:07:43 -0800 (PST)
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
Subject: [PATCH v2 6/7] mm/page_ext: inline unchecked page extension lookup
Date: Tue, 17 Nov 2026 20:06:26 +0800
Message-ID: <20261117120627.50601-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261117120627.50601-1-songmuchun@bytedance.com>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BFBB180007
X-Stat-Signature: g8chfky3ctxj34fcwcj7ciu8pw8fkgax
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794917269-742881
X-HE-Meta: U2FsdGVkX1/TMOz/UtU4byErBabpMstpNI8B6DiEzrH3J+Bk5ijgjh3dQ8TolQ5PYfkbJPGqS7YPCi1CI3O2ne21gK20Y60RuCbF0Wgd/E0LsT2I+VTjkMCISpMEO88kO556ek/LxoSXVDjIVE47ddFa3wTRaGVQq0SHZef89le2moHVPML4k8tIW44vW+mZNH2joMwXo0s7y3BTaYKIkBHDaEjencTpzfQu6DrPywOHbkGTaifJqQ4Lu9Dn6VIgGXjLuxFAEN3R4njdQmYIvc8HpXf1ZlAlHEs0h6102EAv9xvV7lUwjq87b0yOk6FpOaocBQuddUIieiJrmorQpYDlc6/ow4YJP6XjVW+7asepg8LBg7+xBBYSnQvjqdnfYi13y3LObT4Z70nAC/0mGakbcoN6xX7l+DKzks6/+okDLClfnOuFWXNb0qoHmugUn+9bdLCjFMKHH8mQRkCnp4/8NKfPrOLgi8Q7C6oowCXblKE+vXvYlbCPnMR286tYdFZAq8ukVO5O+Esg4r3hysmKzNoP+SvZpYr6zHo6+pokgIzq6rk1nkqb8g6kUsuLF5BOQMU0KPVV8aCcUsd6YaRw1w1+FyBugEPOH0nWqJpBKmmDZdWRg1bXGZV903iiCyROxr0JK06S4kb/JcdeIepFnpUpmrACzLZ7pCfZc0aObh1ANHFNEQoLtJTBMQW1oeqf+J9VKYIU2lBTN5VxRSPmkcla1QhN2pvTxsZ2WmsiYYedYxsOr47h6bxJpYMaB/YadW6EnVFYtccKPQLIQIcV/BFElR65JUYWyUyimTcAPYO476QnqkYHXOzaGPIKn5TkiQ7ICLOiYyzpoJAAq0eUGKIxqAwhp2DKvA/jmpRJ9NM/zkZzra9J/iVV5qLWK4TFybuS6Y9Z7ro4DJqMp3of/6BemFKopDiEW3Q83honHFRlbZ3rB38NsWG3bhjTNuUlFoUcY6mN/4Z0J0x
 L5wOdjU+
 DY4Y6UmVFgG1DBxXnu1QMmuUrUn+qoFrfQKGP1EGrtS8y8ZY4G6h5pogQO8Iu2kncxFmeJRcg4w4uDwb8WCTuzvt/0YAOB+L36TjjE8988HDsEmyLAsA1B2kSvi7IJVfc2GHfVWiSiJKB/RXj5/zuSlgwyrGnQbGO9slXSg/6akVxaQb6N1FtJnNoupcIGJ5DZFajYi2sxwEFcIoIaDh3c0pLIoFqF0N1jbqqqHy2OxpjfEPGfPaU5lKcDddJe+m7UofIXb4/KAn2kR62sFhvsjbikdhR73KAICk8DEec8cxqVcDdOE2KO9t6eTtnD47zeVlUCqU+/IWYVtaxdI7zy5if+1DPUTk2RAS/wPp6VXdZtVI=
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
---
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
index 2910727e99e2..0f31e2da2611 100644
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
@@ -175,33 +171,7 @@ static void __init invoke_init_callbacks(void)
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
@@ -247,29 +217,6 @@ static int __init __page_ext_alloc(void)
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
@@ -360,7 +307,7 @@ static void __free_page_ext(unsigned long pfn)
 		base = (void *)base - PAGE_EXT_INVALID;
 	WRITE_ONCE(ms->page_ext, NULL);
 
-	base = get_entry(base, pfn);
+	base = page_ext_entry(base, pfn);
 	free_page_ext(base);
 }
 
@@ -503,7 +450,8 @@ void __init page_ext_init(void)
  */
 struct page_ext *page_ext_lookup(unsigned long pfn)
 {
-	return lookup_page_ext(pfn_to_page(pfn));
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	return __page_ext_lookup(pfn);
 }
 
 /**
@@ -522,7 +470,7 @@ struct page_ext *page_ext_get(const struct page *page)
 	struct page_ext *page_ext;
 
 	rcu_read_lock();
-	page_ext = lookup_page_ext(page);
+	page_ext = page_ext_lookup(page_to_pfn(page));
 	if (!page_ext) {
 		rcu_read_unlock();
 		return NULL;
-- 
2.54.0


