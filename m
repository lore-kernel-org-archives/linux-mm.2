Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AC53606A33D
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=djzZG9ea
Received: by kanga.kvack.org (Postfix)
	id ACFEB6B05B2; Tue, 17 Nov 2026 07:07:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A59836B05B3; Tue, 17 Nov 2026 07:07:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 921076B05B4; Tue, 17 Nov 2026 07:07:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DAC96B05B2
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:07:14 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA96D80434
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:07:13 +0000 (UTC)
X-FDA: 85444485546.05.C526E0B
Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id CC0E340006
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:07:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=djzZG9ea;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794917232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6c6XNgFhfszqQ1hFLaWUE4ktsCkCd4UwZmAEeIjy0+E=;
	b=yoIMFUNtEYjPZu9R5uQ7NVVAkdufwPlbeBDtecWcTvj/OFkprAvSts8q4WTcXstcqEMHvl
	YPhtdwJDgSNRxNzaDwdURyrTy7cApD9LGdfTOLE1Llz01C1yhjlPFVfskFcRq7LQLUG8R+
	eFj0m91BadTK8j96KsNBWsCdP7RpojQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=djzZG9ea;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf07.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.45 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794917232;
	b=im0HJZx0Uh9pAZi7TpYq5LuOTOABKFkrxEndiGAA592V7+xz5q9SnNpWmGTOlhU0IZW/fG
	vSQP0tgCgBu7J8W/WUWYndFpt9EqLi6H4Hg930nsh4GW0T/YPI/BnQPdPvGS0OVRJDSgVy
	+9o13lNBp23rLneouydByGiKnwECh9o=
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1438d9363fbso591875c88.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794917230; x=1795522030; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6c6XNgFhfszqQ1hFLaWUE4ktsCkCd4UwZmAEeIjy0+E=;
        b=djzZG9eaER74owdixx/MZsJCSEfBEMa69lVupCviqtDNcywJK1nsZD6dyq1HYX0TzL
         fhO6DQSxgj3sOIj0RwgjCJswqazUB79TQL4O1fi7Z2C3uq9FMH560wK2QN5F/Lr589mn
         EZdoL7+7Gpzzs8YT2RQPlkzE/hpYgIPZEaYp7dtpULTH+DEVud98xLlygXbjTQOX0Oju
         6o1wvH0a4Mr4NwVx3efRksgMcGR8mpt2ZJutpyWouc6Vo1LLBAcEN8BPzE34GW6Sf772
         L6a42nSeBdASv5LUwZKEs5UXePK43M/nKLADTEofl8jM0jNZj1KYmC0cNy35J3gbw9dS
         gWig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794917230; x=1795522030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=6c6XNgFhfszqQ1hFLaWUE4ktsCkCd4UwZmAEeIjy0+E=;
        b=HK67A5ffZik4r3eiNjJC8LNE1z3F7vDBsVAjB5B/+I5hNWVURrDzy4B4VInMSHs82e
         mpPo/edh6A/qL604lLrUCz0sm6S+hlhKQSaF7bbJvRtuHXGK6iS3YixTvxE3pZ5TVmF4
         DBk3V0ZOmYyVYgEi66B8Jhaqx+MtppReJsqVHPz6S/FPzX7oiIiimaeuUyKFk0ebfwIH
         lAcvOzoOUunuPnFc7sHxvwrD6RKQ8zRKibQri0KnENKprfnFlCcyds17Dll3dgk5TP5b
         6j7rLc0aj4yyf/PAoEhma2NUSDjolBPhbnWs7kn6U6d6mdXtDNbBDu50GibuH3qntEL6
         2D4Q==
X-Forwarded-Encrypted: i=1; AL+hErEHBZixw5rwsXcES1Q3ww+AN5MS9sjO/Y3ZPMjFlKvL8hjq73yDjvPQu/gjOpmfPoirMW7chubNrA==@kvack.org
X-Gm-Message-State: APuU4Z9lDeUX0H7H9ZOviBzJ7nyWYH6ay93bedh8glRONNRHMwJxu4wO
	fxjgFIWDC/MbdwJjtQCfCI6KTdtRIZppepMojBAebpF6f1g2zN1SIq4NW7jyuAJL+Ys=
X-Gm-Gg: AYBFou16I624TTMTK5CmaSIMRDTNH5xwOenCvuKv7ZyErufsNnBvay7gPOHitGfMBm9
	rtE/ReHJfOt4utn0YvzIoQhOjB4Cjb+qf9OKlt5zz0VGEw4emZAzaaKfMGlWJ5DFZUXdBl9E6QR
	r+0wjtK6aLFZZ4sUxOjxV8Fz1fXkYL7RyqZiMG31PZPXCVU/Vd0BCWbEpwKxG8gJSvUIQGmtpPw
	a/VTiCoDqrsDZ5GSDIUu92w7h2szH9NoFWr9RhSLr+3jc3z7o6QCgLtUEB9tr/eawX0fZTw2nlA
	KIio0pkVIXiCO6xC/d7oBtVumO35IWVgLBAxSrWZKdrIRlSNIRjQ1j1dtC5YhRgob3slv5DdgB8
	5owFWZ98NNPdcogujfOPvdnoTHN1bnmt4e0kNXCYyY+MV84a+SLFRu7vFcwozmzKPQh+Y/+c9Me
	xUXu8xinHFKyo+NMlp4CTw5knf8ONW9iDrfsRLep09EpoAan+mwKHmo43tliqCXZqnzVGCD3DDp
	OGMraTecgqwViAIhA1GeELy36fqB70Fj6wROVKalrF7YNKEc+vQ6vBLKqgebu4sfgFCahDOzmcz
	MvTDEMK3hFpLaYSTwvCJMsUaNkPrHoIn8djt+lAYjw+f8p3icup02bVfbd8w6meing==
X-Received: by 2002:a05:701b:4208:10b0:1b3:b3d5:566f with SMTP id a92af1059eb24-1b53a3d6f36mr2100222c88.11.1794917230199;
        Tue, 17 Nov 2026 04:07:10 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.7])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031468b7sm47347116c88.5.2026.11.17.04.07.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 17 Nov 2026 04:07:09 -0800 (PST)
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
Subject: [PATCH v2 1/7] kmsan: encapsulate per-page metadata access
Date: Tue, 17 Nov 2026 20:06:21 +0800
Message-ID: <20261117120627.50601-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261117120627.50601-1-songmuchun@bytedance.com>
References: <20261117120627.50601-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CC0E340006
X-Rspam-User: 
X-Stat-Signature: o4qrexe3ge9ojq65f86pm3rg5aa8hcd4
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-HE-Tag: 1794917231-971041
X-HE-Meta: U2FsdGVkX1+y6Uqzy/F1tPzx63Tp/ykR1p/c2l9Y1zRulWVTPD9jDsGD44X9rQW25iI8stAOx56LC6kpCNdOO8lPrRJuNA+t95mURpnUZDVFybCTrf9azm9Q49Zan+lPwk6V5zWxNXAZI+kfO1OB7wwbJ+V67vi7Gx1AqW19lQhTheKES/Hukv7BC/8xZjMH3p7BM+KKrgsxgQZhen6q+Ubt9K0qPbbpiTTJJ+y04hgc9npR+h+OVxolhZjPmwGXC/VM7pl4OeatiEhk67KG58+BuEAyNluJEoL7Nf3HoQoAKfwiX2jqnGTLW6kJUu8zqpPMVaRm38Os9elEgK8UPCka8JUZRXsE4q6pL8TRw+9d72sWBdT81Yq7S6kkOeT9okijkoYxEe5kXBDXxE+YAihrfl+AzTp9oykBnVEAup9spyfAIvo7gDhaz59OLiw/7+K6+xyKoe56BPkHRTM+d0QH358+D03U+vv8hgg0IPx465jUqU1hzWvNf819+p4JadeoE3Hfn2A/Dc+YLNfG91Oaw0EX/z9oCdT2sSdRL0dVRZeI4oYrfmJjGcfMTXM4Yz5RTRzmjsQdAJksVPD9nyMr77Us1O2jNcA+5/nrtJTcBA8vF9/Tw9K+x44YV8CI1cYjAg82o1XChk7t7y5Yx8w8XerT6wQgvvgk7pX7b4/gBDcXLAMFF/ToJLYFk+1+sR6YLgX+DfBCMiFM9VlcanM4j2JsfQC/P+/QQM4rzcYrBy+X11OCWMQbvcM1oCabu4DCo4o/6Qt/zedwKz3UfZ6hcdDPuV46Ibbnh7zHwFu8Qnw6JfFb8LpJAotp2WtAjp2RxX1P0GYNQESCQko3WAIQMhEJbmYI5z2n0l98T0+6cx5036I1ssYyfzKwj54KD3Wy42cQrKydM8pxspQLFVBVsNgIu3s9OGLEIZU5IlEWwr3ojBU1asKHi6/FQBMcwsAkALaf49m1WHFRPTh
 bqYDxL1B
 rP1tQGIQdnd/+eTwbyJ+3HIb6mPPzAK3/CZbPndn4Ztv/IAq1JQUq5bE4AiOWfEGKz2A5c4Bs86m0TvL9RsodcdDTRnddVaNDFbtncs7OMdrd5FLFVPU10rIVrbdPkaK+3mx1BthsAN/L/NNLPUA2rN1TTW81F3MPksfSk3pV1hiNQxwiQMYamsIJLCQ7+1N/BegzGuLf7S6GYvobP73XZw5psfNGkljUvhGtjvBsAHERohEaCEpuhd+qck+65BCPGrMRGhvghH0b34iA9dhkOe2Ep8awEw1JBV/j7CA7Q12WjF+wwdRNOc+33w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

KMSAN directly accesses page->kmsan_shadow and page->kmsan_origin
throughout the shadow implementation. This couples these users to
storing the metadata pointers in struct page, requiring every access
site to change when the storage moves elsewhere.

Introduce helpers that get and set both metadata page pointers as a pair
and convert the existing users to them.

kmsan_get_shadow_origin_ptr() is the main metadata lookup path for
compiler-instrumented memory accesses and requires both pointers. For
page-backed addresses, resolve the backing page once and obtain the
metadata pair through one lookup instead of calling the single-metadata
path twice. This also avoids duplicate lookups after moving the metadata
storage out of struct page.

No functional change is intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
v2:
- Use one page metadata lookup for shadow and origin pointers (suggested
  by Chris Down)
---
 mm/kmsan/shadow.c | 166 +++++++++++++++++++++++++++++++---------------
 1 file changed, 111 insertions(+), 55 deletions(-)

diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
index 0c88d89bf0d6..300b48818af1 100644
--- a/mm/kmsan/shadow.c
+++ b/mm/kmsan/shadow.c
@@ -9,6 +9,7 @@
 
 #include <asm/kmsan.h>
 #include <asm/tlbflush.h>
+#include <linux/bits.h>
 #include <linux/cacheflush.h>
 #include <linux/memblock.h>
 #include <linux/mm_types.h>
@@ -20,29 +21,46 @@
 #include "../vmalloc.h"
 #include "kmsan.h"
 
-#define shadow_page_for(page) ((page)->kmsan_shadow)
+#define KMSAN_META_MASK_SHADOW		BIT(0)
+#define KMSAN_META_MASK_ORIGIN		BIT(1)
 
-#define origin_page_for(page) ((page)->kmsan_origin)
+struct page_metadata {
+	struct page *shadow;
+	struct page *origin;
+};
 
-static void *shadow_ptr_for(struct page *page)
+static inline struct page_metadata get_page_metadata(struct page *page)
 {
-	return page_address(shadow_page_for(page));
+	return (struct page_metadata) {
+		.shadow = page->kmsan_shadow,
+		.origin = page->kmsan_origin,
+	};
 }
 
-static void *origin_ptr_for(struct page *page)
+static inline void set_page_metadata(struct page *page, struct page_metadata meta)
 {
-	return page_address(origin_page_for(page));
+	page->kmsan_shadow = meta.shadow;
+	page->kmsan_origin = meta.origin;
 }
 
-static bool page_has_metadata(struct page *page)
+static inline void *shadow_ptr_for(struct page_metadata meta)
 {
-	return shadow_page_for(page) && origin_page_for(page);
+	return page_address(meta.shadow);
+}
+
+static inline void *origin_ptr_for(struct page_metadata meta)
+{
+	return page_address(meta.origin);
+}
+
+static inline bool page_has_metadata(struct page_metadata meta)
+{
+	return meta.shadow && meta.origin;
 }
 
 static void set_no_shadow_origin_page(struct page *page)
 {
-	shadow_page_for(page) = NULL;
-	origin_page_for(page) = NULL;
+	set_page_metadata(page, (struct page_metadata) {});
 }
 
 /*
@@ -79,11 +97,56 @@ static struct page *virt_to_page_or_null(void *vaddr)
 		return NULL;
 }
 
+static __always_inline
+struct shadow_origin_ptr __kmsan_get_metadata(void *address, unsigned int mask)
+{
+	struct shadow_origin_ptr ret = {};
+	struct page_metadata meta;
+	struct page *page;
+	u64 addr = (u64)address;
+	u64 origin_addr = ALIGN_DOWN(addr, KMSAN_ORIGIN_SIZE);
+
+	if (kmsan_internal_is_vmalloc_addr(address) ||
+	    kmsan_internal_is_module_addr(address)) {
+		if (mask & KMSAN_META_MASK_SHADOW)
+			ret.shadow = (void *)vmalloc_meta(address, KMSAN_META_SHADOW);
+		if (mask & KMSAN_META_MASK_ORIGIN)
+			ret.origin = (void *)vmalloc_meta((void *)origin_addr,
+							  KMSAN_META_ORIGIN);
+		return ret;
+	}
+
+	if (mask & KMSAN_META_MASK_SHADOW) {
+		ret.shadow = arch_kmsan_get_meta_or_null(address, KMSAN_META_SHADOW);
+		if (!ret.shadow)
+			goto lookup_page;
+	}
+	if (mask & KMSAN_META_MASK_ORIGIN)
+		ret.origin = arch_kmsan_get_meta_or_null((void *)origin_addr,
+							 KMSAN_META_ORIGIN);
+	if (ret.shadow || ret.origin)
+		return ret;
+
+lookup_page:
+	page = virt_to_page_or_null(address);
+	if (!page)
+		return ret;
+	meta = get_page_metadata(page);
+	if (!page_has_metadata(meta))
+		return ret;
+
+	if (mask & KMSAN_META_MASK_SHADOW)
+		ret.shadow = shadow_ptr_for(meta) + offset_in_page(addr);
+	if (mask & KMSAN_META_MASK_ORIGIN)
+		ret.origin = origin_ptr_for(meta) + offset_in_page(origin_addr);
+
+	return ret;
+}
+
 struct shadow_origin_ptr kmsan_get_shadow_origin_ptr(void *address, u64 size,
 						     bool store)
 {
 	struct shadow_origin_ptr ret;
-	void *shadow;
 
 	/*
 	 * Even if we redirect this memory access to the dummy page, it will
@@ -95,12 +158,10 @@ struct shadow_origin_ptr kmsan_get_shadow_origin_ptr(void *address, u64 size,
 		goto return_dummy;
 
 	KMSAN_WARN_ON(!kmsan_metadata_is_contiguous(address, size));
-	shadow = kmsan_get_metadata(address, KMSAN_META_SHADOW);
-	if (!shadow)
+	ret = __kmsan_get_metadata(address, KMSAN_META_MASK_SHADOW |
+					    KMSAN_META_MASK_ORIGIN);
+	if (!ret.shadow)
 		goto return_dummy;
-
-	ret.shadow = shadow;
-	ret.origin = kmsan_get_metadata(address, KMSAN_META_ORIGIN);
 	return ret;
 
 return_dummy:
@@ -124,46 +185,36 @@ struct shadow_origin_ptr kmsan_get_shadow_origin_ptr(void *address, u64 size,
  */
 void *kmsan_get_metadata(void *address, bool is_origin)
 {
-	u64 addr = (u64)address, off;
-	struct page *page;
-	void *ret;
-
-	if (is_origin)
-		addr = ALIGN_DOWN(addr, KMSAN_ORIGIN_SIZE);
-	address = (void *)addr;
-	if (kmsan_internal_is_vmalloc_addr(address) ||
-	    kmsan_internal_is_module_addr(address))
-		return (void *)vmalloc_meta(address, is_origin);
-
-	ret = arch_kmsan_get_meta_or_null(address, is_origin);
-	if (ret)
-		return ret;
-
-	page = virt_to_page_or_null(address);
-	if (!page)
-		return NULL;
-	if (!page_has_metadata(page))
-		return NULL;
-	off = offset_in_page(addr);
+	struct shadow_origin_ptr ret;
+	unsigned int mask;
 
-	return (is_origin ? origin_ptr_for(page) : shadow_ptr_for(page)) + off;
+	mask = is_origin ? KMSAN_META_MASK_ORIGIN : KMSAN_META_MASK_SHADOW;
+	ret = __kmsan_get_metadata(address, mask);
+	return is_origin ? ret.origin : ret.shadow;
 }
 
 void kmsan_copy_page_meta(struct page *dst, struct page *src)
 {
+	struct page_metadata dst_meta, src_meta;
+
 	if (!kmsan_enabled || kmsan_in_runtime())
 		return;
-	if (!dst || !page_has_metadata(dst))
+	if (!dst)
 		return;
-	if (!src || !page_has_metadata(src)) {
+	dst_meta = get_page_metadata(dst);
+	if (!page_has_metadata(dst_meta))
+		return;
+	if (src)
+		src_meta = get_page_metadata(src);
+	if (!src || !page_has_metadata(src_meta)) {
 		kmsan_internal_unpoison_memory(page_address(dst), PAGE_SIZE,
 					       /*checked*/ false);
 		return;
 	}
 
 	kmsan_enter_runtime();
-	__memcpy(shadow_ptr_for(dst), shadow_ptr_for(src), PAGE_SIZE);
-	__memcpy(origin_ptr_for(dst), origin_ptr_for(src), PAGE_SIZE);
+	__memcpy(shadow_ptr_for(dst_meta), shadow_ptr_for(src_meta), PAGE_SIZE);
+	__memcpy(origin_ptr_for(dst_meta), origin_ptr_for(src_meta), PAGE_SIZE);
 	kmsan_leave_runtime();
 }
 EXPORT_SYMBOL(kmsan_copy_page_meta);
@@ -171,19 +222,18 @@ EXPORT_SYMBOL(kmsan_copy_page_meta);
 void kmsan_alloc_page(struct page *page, unsigned int order, gfp_t flags)
 {
 	bool initialized = (flags & __GFP_ZERO) || !kmsan_enabled;
-	struct page *shadow, *origin;
+	struct page_metadata meta;
 	depot_stack_handle_t handle;
 	int pages = 1 << order;
 
 	if (!page)
 		return;
 
-	shadow = shadow_page_for(page);
-	origin = origin_page_for(page);
+	meta = get_page_metadata(page);
 
 	if (initialized) {
-		__memset(page_address(shadow), 0, PAGE_SIZE * pages);
-		__memset(page_address(origin), 0, PAGE_SIZE * pages);
+		__memset(shadow_ptr_for(meta), 0, PAGE_SIZE * pages);
+		__memset(origin_ptr_for(meta), 0, PAGE_SIZE * pages);
 		return;
 	}
 
@@ -191,7 +241,7 @@ void kmsan_alloc_page(struct page *page, unsigned int order, gfp_t flags)
 	if (kmsan_in_runtime())
 		return;
 
-	__memset(page_address(shadow), -1, PAGE_SIZE * pages);
+	__memset(shadow_ptr_for(meta), -1, PAGE_SIZE * pages);
 	kmsan_enter_runtime();
 	handle = kmsan_save_stack_with_flags(flags, /*extra_bits*/ 0);
 	kmsan_leave_runtime();
@@ -200,7 +250,7 @@ void kmsan_alloc_page(struct page *page, unsigned int order, gfp_t flags)
 	 * to just fill the origin pages with @handle.
 	 */
 	for (int i = 0; i < PAGE_SIZE * pages / sizeof(handle); i++)
-		((depot_stack_handle_t *)page_address(origin))[i] = handle;
+		((depot_stack_handle_t *)origin_ptr_for(meta))[i] = handle;
 }
 
 void kmsan_free_page(struct page *page, unsigned int order)
@@ -238,8 +288,10 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
 		goto ret;
 	}
 	for (int i = 0; i < nr; i++) {
-		s_pages[i] = shadow_page_for(pages[i]);
-		o_pages[i] = origin_page_for(pages[i]);
+		struct page_metadata meta = get_page_metadata(pages[i]);
+
+		s_pages[i] = meta.shadow;
+		o_pages[i] = meta.origin;
 	}
 	prot = PAGE_KERNEL;
 
@@ -289,10 +341,12 @@ void __init kmsan_init_alloc_meta_for_range(void *start, void *end)
 		page = virt_to_page_or_null((char *)start + addr);
 		shadow_p = virt_to_page((char *)shadow + addr);
 		set_no_shadow_origin_page(shadow_p);
-		shadow_page_for(page) = shadow_p;
 		origin_p = virt_to_page((char *)origin + addr);
 		set_no_shadow_origin_page(origin_p);
-		origin_page_for(page) = origin_p;
+		set_page_metadata(page, (struct page_metadata) {
+			.shadow = shadow_p,
+			.origin = origin_p,
+		});
 	}
 }
 
@@ -302,7 +356,9 @@ void kmsan_setup_meta(struct page *page, struct page *shadow,
 	for (int i = 0; i < (1 << order); i++) {
 		set_no_shadow_origin_page(&shadow[i]);
 		set_no_shadow_origin_page(&origin[i]);
-		shadow_page_for(&page[i]) = &shadow[i];
-		origin_page_for(&page[i]) = &origin[i];
+		set_page_metadata(&page[i], (struct page_metadata) {
+			.shadow = &shadow[i],
+			.origin = &origin[i],
+		});
 	}
 }
-- 
2.54.0


