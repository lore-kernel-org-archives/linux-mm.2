Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F011606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 03:35:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=hmAudLFW
Received: by kanga.kvack.org (Postfix)
	id 636676B0647; Thu, 12 Nov 2026 22:35:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60D736B064A; Thu, 12 Nov 2026 22:35:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 523A86B0659; Thu, 12 Nov 2026 22:35:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9EF6B0647
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 22:35:26 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A746012025A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:35:25 +0000 (UTC)
X-FDA: 85428680610.19.118F6A0
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf15.hostedemail.com (Postfix) with ESMTP id E2051A0003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 03:35:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hmAudLFW;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794540923;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F8Mc5bfPfaML+usFR7btwu5wOcUdY4Py09ljLQ8hfIQ=;
	b=t2FCqaGoTBjwIvZwG7FSvxVW6Y6QHgmE7hY0TBMatX1O3bja08nkAn9XypZeMKh+y1Nj+u
	4jVw/Oh6jFanCSLhUG8mpZ1kbaufD4H+hVMsMwjtRiRB0C9mhND/3q3H7ZkrxAwJ+0tMMN
	9/9HUlzueQGkklFCKgJT07sYYA6CY5I=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794540923;
	b=Ldefl8NL0s06MD564S5FTryxj/FmirGjqvhIi+AlZsX9JN6o2oN7gFi+Kxi52curBkUNIR
	uy32lEEzHj5zX6G7DBDSc3msXpIO93fndHr5W7Boivh1ffJoMMgQjxu+zl51B2MVWw/XKT
	nIq63dDOlo4ia4ikDSTi12hnPZx/OD4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=hmAudLFW;
	spf=pass (imf15.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-36dbde64409so854696eec.0
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 19:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794540922; x=1795145722; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=F8Mc5bfPfaML+usFR7btwu5wOcUdY4Py09ljLQ8hfIQ=;
        b=hmAudLFWI8i3riMjY3J6saE5Jj4RtARcp0nsvKT6+TXrxQ4QoiEaUFnnNHtSJ6FC0i
         QAjx9TJQcN1qs596Q8KLT5XX4zTOCBNke6IVkEaY6TldLA9BhFSiYgk58uqlFam9d0qH
         F4s6QeGwWJ1xZj9ua89SCUJGRno0LiESl39092EDpX+82JqRYnvKUu5zVWt9JJ0R4rRy
         AgppnD2cStJ2EnFogIR9kXKnB17rNliV0VkGzmiXvb2jZOyabYlp4+XUYXgdKX0CZDGn
         oVhvzN2TTG1sdAV+GmRbFYqZG2/vyxm76dJlRqCrQ5LQk54ZoyR3wcWzKzzlpQqI15ox
         glrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794540922; x=1795145722;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=F8Mc5bfPfaML+usFR7btwu5wOcUdY4Py09ljLQ8hfIQ=;
        b=uRP+26yhg4NFVEowOSTinanw5DYIfEqOrkxROcas7Lo2NngO7ra5RuzrdazPi7A17o
         Y/3KM1NGYQbeWc8G9cPVF6/Nx+w6oUzQ1bW4cAZCPdEMQw+xtmDKSU4BUZd3BsTiG5+/
         Kz03ZRWMHB0czBGdqzyEd99AZRCvGtNyZvBW9GQZxSzszrMS1lBFRN9jYVNRvOxsiDTY
         dstavgfd06e6NUOI5etEHW767bjaFke36i81IUt+MPliemvZQL7o/mRKIJFLMeCWqkpN
         waTBz7exIEd3LME22LmYWnhM3Aqa1uyrcm8+JplbwrCv2cETX+c6yE9nvJ4yGz1kTECo
         WBrw==
X-Forwarded-Encrypted: i=1; AL+hErFGo+X3UL6pkRFdZSE6NZRkBJOQafCwRIk4bGdTEsF6FT1VZEkNtHAoE2QSHou6dwRD0Mu4oEro1w==@kvack.org
X-Gm-Message-State: APuU4Z/hIyvRkpk+J+NtE8ayBdjfTLoM9b7HUm7jbHorY+J8XVyqr4DP
	dz9eqWXEBMvwRx21RrcnqWKgN68vMKz5Jw+bX5Ok9WLtKiPS6Y94nXBeOJBBfjXiB9o=
X-Gm-Gg: AYBFou093l9qwt/2/TTxp/8SJFnSdUZ8s80BroJYFGH7OVewf/LUs+QZU0/IWWT4tHu
	rpf0tQhjaqYwDW7MJFrijvQ82rTvSmKSMlOn8mvChW9BF9k+oL5uqOG2gxltJPD7rh70KzFHgdW
	bA5DrlmJdXvtgHI735EXgD+eQ4VDHAK2NYJryPshdYBjuLzBe729CZzd3L7RjFdpVnFxOcGANYP
	+GRH8xnBvUnUIAAvGp4SgJISa7mj0WUUm8uNIsU1Fg1djoE3eOs7bn2hDS066YnscjgHGI6O1S+
	L4kWnvaEQwbv0C7J+M9VTQESjVq4VJgP6q30y5dNS+eTW9HTkErAEFBBFhDGRMqhuVbrRAbNFpu
	SgyA+fbfKU8u/fVoEmOoJKVI2JH8iDFb0BHeILWrfTnj+52jIpMMr97ARile2A0FkudYUbmQj6D
	C92KTiKUhnyRe0su8G0qrS9Dic4WJXAcvfxC0lGLnbiMAMVidHc5iArOIFZi1Sg1cK+Udo98SuR
	/yAyeFie7VdhSywNfIWBivZYYXFD5QnSZZgnPjLI4J1GGC65z+8CYutIGTSDY7fPQgJOqhbDJfT
	SyHR7fhs/NdWnUg8R/evt7senUS6yVfmUjF9DCw6C9e/OumQ/uKARUMuCApbZw==
X-Received: by 2002:a05:7300:8a19:b0:377:1bfe:14d6 with SMTP id 5a478bee46e88-37965f9d236mr962228eec.6.1794540921443;
        Thu, 12 Nov 2026 19:35:21 -0800 (PST)
Received: from G6L4RL2QG9.bytedance.net ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37955e0d966sm2959426eec.15.2026.11.12.19.35.16
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 12 Nov 2026 19:35:20 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Mike Rapoport <rppt@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>,
	Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v2 01/14] mm/mm_init: factor out memmap_init_page_from_template()
Date: Fri, 13 Nov 2026 11:34:29 +0800
Message-ID: <20261113033442.62970-2-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261113033442.62970-1-songmuchun@bytedance.com>
References: <20261113033442.62970-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 917zr15ztgy3o37g6razikec9grhwj4n
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: E2051A0003
X-Rspam-User: 
X-HE-Tag: 1794540922-551769
X-HE-Meta: U2FsdGVkX19R73ToQXKKGS/BTcuBfamr0dTymQF5Foh1fnmSYMmXChlsvo2Aw1x83BhhKuysCX6aw2tZxNzkSWJnYq2bd2SnSNjMwJiHiIZzvbaLZDB5tD8G4ekgvMWlVHRozHbmLWCgbnaw1SyaHIgesgU6+fLlxCTCbHrELRqWHIg4gYQGTEphyr5kONBh42ptSzIHRVQ7oLoAp5U3M8GysJyPZWExdRJHoa2j2IwadG8IwP0MsV7bIki2owVdkf/3hVDAL6/cAWBEAJJ4WF5rdS6QcYAqHBBHOBYOeQs9SCtfuWxMCUYxN7nIKDwZQ/yS8cwyiVdc/PX6qjggymEqLq2fRIbAmLMouxbwkQkA0h1pxz4f0n3kPJzWuJhPW+eiNwqlXVzVu0bHXknGrc6xc+4LsmIAXcBtGMEi6Hcd3cdnGYaMfRntLctP8eZiO+7dPiKTsYKF1xrNiU5+nnDOjlKp2PDQFeAlDGeOCihyunavDDVs4apqbjGvtNAlTUzlGc08969LEX5UewiOUq/DuwHeGep/geA2osBun/Pfr/+nfvnVVE+s/VoZ8kozfbJmbZO/UPPCr/sl6SHcsIhH3VXzxee2zGRQLZO05y8peet9Z1iP0RKZeUdHE7rZNEepgenmuTvmiN/jetVyrgudV0KjdlA7uN/BbiPx9qu4aqTzhVg8d1CvqR3dBCI8iwDGMdAlBiFsqJu2kxfkA2Y7xQqFbW8nm8KCdmZpnun5F7cldg32/LvHr3PJ/qRq0JOx9nIhRKFJKE3rB5nvRGifZZBhwtjNY7Ttjr+SIzUrpAPGOZrnV8l0GjDPyF2zBdnwkcijZG41roAe1C15P2fky/aKyHysBgUinoMqpZnY3ujiZBSLflkAzsXKjYDEh58Brt6xyvuBRwgOO9HqDZ1fDGfIjai95mmovZf6siMRgmK6vA2DB0/YKmZu7ifv6r4RwIkKkdMqg+/AQfj
 5fnKhRjR
 2abbj2mmBhm+vdYAzDDDjZfr8o8NvXanDsQbXLIvVYnlH6R9yQ9Zw3QlWOlgbxb2YL8FkCNyywrxgGYK9FO2Znkv34blnQgVMcD2OqbHwX5A4QDrlpoNnX6XFQppPGxQMUrLPOPOGn2zdTsTyzxEV28oFI+RX6JcsSD6LFiNlovSlHs6wZGcMZnCvZfdrCpKCrXKgZIhJC9wILDgiYkaZsPeeJerycafr3TU1bIfrJmOhZC3TjP+V25hH+P+Djx2LkqIGsAPBbk9RDyWf0qhhD7EFwf4k8Ls7kOujo4Jy13jNozRmCXg3j8lO6qCaa9snvhh4Uev2rhlLI/ZHlvcDzv6rSS58fRvOnZm9WZG6rRw7QaQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Li Zhe <lizhe.67@bytedance.com>

ZONE_DEVICE memmap initialization already uses a reusable struct page
template when initializing compound tail pages.  The template mostly
contains invariant state, but a few fields still depend on the target PFN
and must be refreshed before copying the template into each destination
struct page.

Factor that operation into memmap_init_page_from_template() so other
boot-time memmap initialization paths can reuse the same helper.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: Muchun Song (ByteDance) <muchun.song@linux.dev>
Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 mm/mm_init.c | 33 +++++++++++++++++++--------------
 mm/mm_init.h |  2 ++
 2 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 2367af05570b..3988c19699bc 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -707,6 +707,22 @@ static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
 	}
 }
 
+void __meminit memmap_init_page_from_template(struct page *page,
+		unsigned long pfn, const struct zone *zone, struct page *template)
+{
+	/*
+	 * Refresh PFN-dependent fields in the template before the
+	 * non-temporal copy, so the destination page does not need cached
+	 * stores after memcpy_nontemporal().
+	 */
+	set_page_section_from_pfn(template, pfn);
+#ifdef WANT_PAGE_VIRTUAL
+	if (!is_highmem_idx(zone_idx(zone)))
+		set_page_address(template, __va(pfn << PAGE_SHIFT));
+#endif
+	memcpy_nontemporal(page, template, sizeof(*page));
+}
+
 struct zone __meminit *pfn_to_zone(unsigned long pfn, int nid)
 {
 	pg_data_t *pgdat = NODE_DATA(nid);
@@ -1074,17 +1090,6 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	}
 }
 
-static void zone_device_page_init_from_template(struct page *page,
-		unsigned long pfn, struct page *template)
-{
-	set_page_section_from_pfn(template, pfn);
-#ifdef WANT_PAGE_VIRTUAL
-	if (!is_highmem_idx(ZONE_DEVICE))
-		set_page_address(template, __va(pfn << PAGE_SHIFT));
-#endif
-	memcpy_nontemporal(page, template, sizeof(*page));
-}
-
 /*
  * With compound page geometry and when struct pages are stored in ram most
  * tail pages are reused. Consequently, the amount of unique struct pages to
@@ -1137,8 +1142,8 @@ static void __ref memmap_init_compound(struct page *head,
 
 	/* Initialize the remaining tail pages from template. */
 	for (pfn = head_pfn + 2; pfn < end_pfn; pfn++)
-		zone_device_page_init_from_template(pfn_to_page(pfn), pfn,
-						    &template);
+		memmap_init_page_from_template(pfn_to_page(pfn), pfn,
+					       device_zone(nid), &template);
 	prep_compound_head(head, order);
 }
 
@@ -1193,7 +1198,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
 	for (; pfn < end_pfn; pfn += pfns_per_compound) {
 		page = pfn_to_page(pfn);
 
-		zone_device_page_init_from_template(page, pfn, &template);
+		memmap_init_page_from_template(page, pfn, zone, &template);
 
 		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
 			cond_resched();
diff --git a/mm/mm_init.h b/mm/mm_init.h
index 0034e37dbabd..4478419f0bb9 100644
--- a/mm/mm_init.h
+++ b/mm/mm_init.h
@@ -111,5 +111,7 @@ void memblock_free_all(void);
 
 void __meminit __init_single_page(struct page *page, unsigned long pfn,
 				unsigned long zone, int nid);
+void __meminit memmap_init_page_from_template(struct page *page,
+		unsigned long pfn, const struct zone *zone, struct page *template);
 
 #endif /* __MM_MM_INIT_H */
-- 
2.54.0


