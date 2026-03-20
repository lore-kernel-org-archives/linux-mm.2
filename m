Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36A0C1099B28
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29CEA6B00D3; Fri, 20 Mar 2026 14:24:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2265A6B00D4; Fri, 20 Mar 2026 14:24:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 116A06B00D7; Fri, 20 Mar 2026 14:24:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F0D456B00D3
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:24:00 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B3BAD140202
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:24:00 +0000 (UTC)
X-FDA: 84567265440.10.48FA572
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf03.hostedemail.com (Postfix) with ESMTP id DC75C20014
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iB53oOi1;
	spf=pass (imf03.hostedemail.com: domain of 3vZC9aQgKCCoPGIQSGTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3vZC9aQgKCCoPGIQSGTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lGMhbZxFIgAxdlzkjZ1cKVDZiAbKLAwKMpahCpzEzEo=;
	b=VWbFqeNarhgVaXNojdtPiGwZbQ7l3h/hQjGiy3Pe145fKBQ+1CvmIuXpOUTrawb3VxbTip
	wR4DM4mMeqwhYgk+Ayoafb6KvT3HSiP8vdYQ2Cewc6/veLIwCbxUVTyuQzG8eg8Afg3vK4
	n0dV/NVBFN3efHwBlm2wD0J3TYaV/6I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031039; a=rsa-sha256;
	cv=none;
	b=IyJvOj+CBN1p3l9Kv1A5rG+T/razomlTPd1/8ApLdOIuDCEDlFK9oV4246iK8uuzRr5+P8
	yVQ3OOou2Bi6V0wKHSKEfkQ+Ajp6C6BXlx8QTVEHnbmqdtGXY4bULuUD9O0mTpnus8V8fh
	I+DgAtYqqWdqljpqzmyEQ0FYfTw5DwY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iB53oOi1;
	spf=pass (imf03.hostedemail.com: domain of 3vZC9aQgKCCoPGIQSGTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3vZC9aQgKCCoPGIQSGTHMUUMRK.IUSROTad-SSQbGIQ.UXM@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-43b42fe9031so2389716f8f.0
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:23:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031037; x=1774635837; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lGMhbZxFIgAxdlzkjZ1cKVDZiAbKLAwKMpahCpzEzEo=;
        b=iB53oOi10fiHWt/gmbmICAYet7UwNpaZc7mFKL4acdssaOEL0fNuZerGvLbmal7Hed
         wuNoRC5y80JjaKRhHwWeSca0HXBgAwW2M3i4ldwA3FHKBMYxNbM5NSbV1LPbvU4fYntA
         J8VMMJ9ehAegXwU5CVwQTJBBuE+xN6g4MLU+syVK9eDLco78IsxfJhlyIPJIrwZ4rTRU
         CAa6uGrP5gO9n91ciJFqiL8tVOKmV2M8NjzVs2IcwVz1haeeRNkpKOU4ZwdjjW32OCHo
         vDuBTv3gldmjxSQ7xCBRJZcwxya4lh9ctK6XEMAy9vvLuomuNBTLVhxbsnbaXUZ9HrQ3
         xM6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031037; x=1774635837;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lGMhbZxFIgAxdlzkjZ1cKVDZiAbKLAwKMpahCpzEzEo=;
        b=IugwL/KXwzVNCNPE9qdGqqXUUDCAp1lpKvsadI8wjXebn9pMwr5235l7osl4ZV8r82
         TN+2QGf0u4vRO7smNVryROQNulw5Z27j0loikMeST2zXANevbILIJLsW3iYd9tYYjv51
         Opk6XUAbhP1P26IcBdIW7wQB+GvCkbFIeJDJ/PsnwBtE3Yl1b/eVJOIdgd7NsAGRv6Tq
         IEYTtOkUkFCHfMMsr4uFP38+1/jJhMCsySohfM6kNcU62ms86iGT3YwguzeHOYzNbCIY
         x5Yb6rH94UUHXCSJCq4lTQIC55Cp8foTG5TSQDWDkMUKUmZ0X1btfa5p3nSG61s854Ve
         5V7Q==
X-Gm-Message-State: AOJu0Yw1IxsVjYNRwhoEJrNnqcwBpcSviSJ0TZ333Ww8VLhAQLzPU1yw
	QhGViCgU7kFxstJD7QGptI6ry6O+15q8YWoqDuSI7yIqppScTAYcN1+TwrSIDvEfe7sTwKby1qG
	KdnH2dpqnwfHE9Q==
X-Received: from wmro8.prod.google.com ([2002:a05:600c:3788:b0:485:39cc:2a07])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:19d4:b0:485:54cd:6e4e with SMTP id 5b1f17b1804b1-486fee0b723mr55394755e9.18.1774031037278;
 Fri, 20 Mar 2026 11:23:57 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:37 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-13-28bf1bd54f41@google.com>
Subject: [PATCH v2 13/22] mm: rejig pageblock mask definitions
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DC75C20014
X-Stat-Signature: i4p3euebq63sftoxt48tmih5kymckqph
X-HE-Tag: 1774031038-732405
X-HE-Meta: U2FsdGVkX19jr2hxcF9gtK4061akF5zw16PNRSFLUerOm7SawVbH8HexzfmbyLFzBeyixJxk6EiaO8TTz44Za47mGj95f+lZahPlyfoycfDxpMwW9i2kDg5ISnjdwXwA8SpUSQKn2l4UvxlXhiT/u5+DSqF/CyvispP2B3Jsaz7FmE4D9k5ucqo659slhyThNB/m1yhd3gGS0Zm7XLutP+SXuGfYqsp16fEhre5buRlQnG6f7mm3aCwxbtrmKvV82dNB90bbytHViGXDxAAT5eR1scBpOUaQYOyk+RSuxQv7SxFd+wfnfoKIcadhhmzuh5zSraNTSzCrGuzs28Wye76xZFIQLcvys9+Tuc48hTENAOU0znMjh+xJBuNANKwKluL0JWg35NUZMlWWlXg4tdmrTc/wDg6zNggyRSu5TTjyf1da907qrE22x+V6CNdyQzh/TEWW/q8kcLsY425DyA4nah6E/N8dxbSf+BCi8rEBf1taAFKJM9FuycgS9tdFK2nBKoH54/5ynLKyzVdjgDF1pnd+AKuWSbZJlOvc86tRlCqX8aYKCc5Y6w8E3FpykOKwciPdnvH5/IE8eK8zCHsSnDnHYX55JH5e1YEgGMkPjeNnuBdvIHju0hm+OF4Pdnf79A999kLLHfB+0vV7EqNHc1UtqWOfceTnqnErxhVhjrU6f5yJATPlyTmZP3jbGHbi/8XwqsD0+vCKDpk194kO7lgYuO4zGRHSxg8zVL68V19woE2tTCmYv+ycOU5zmYxW+SAfQQS9LrROTO2uBT5wc2xx9Sgcq3PRU2H/usbrVtKIDPuX7bvY5m5rDfWQklnzsLXMDeHw9OH6+cX2gChD0Fj1EuKOakronC3XaINYHX/r9T+KOepIblx8KG4Qyi92eOEMlimRezZFCEa6eaBf2Xp854SLTyVPttzP/Rg0VSzD31mhhOdurLfI+ZdJU2gKj4RVmBKxguAZbvN
 JOOnsaRH
 aEQDiXF3WcN6a6aaCVpMrhXlVURqb4Mp1qilXS1Uu6oc6zn0gOdlserLzMjS2M91qajbySjsA2S8D41PhK5gweq4dwZWiOx4W0G8rJ9/1vmZ3u3ZKBkqFWJUvQQMtDYW9nfTRb1kL+XV3ZRyWXG7jor/jlbnj7+6Nc8lSZJ8dTWJ6OKLpVLeDGUKcGQf+HtwMEEG80S/y/w0lBKtcHhV5/D4KX558UI3WqoB9hgocdMyewkwWrbAmDCga8WMRdYT/dM31zJuYpdTZQsf9WaYEZkDqPnwWF8EU2BEUpEz1oFZ4guQbdZSfqa46iPHKHKnO7eWuKVJzsLCfZB+15iiybNlf7r7VAwTNa9NGUWxzmbDg4PKf9c8tvnpkhG7Yg8eZTx3zj8lU2qrjbgurAjoPaU77/7ZwoewGONwjzO9exHd/TyeVHzPIAojuavNpKq6b6juZ3NSL2E2zOqBJdbhaK/S7dQpuiYRcAVG0nRTOU59SSjOJ5rTib6/OfymM3EmDJOLKNHiq8PCm4satFgo3E9wEOyyLrou9CFG0g4Dfl/Ex/8kgBVxMkYz2zA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A later patch will complicate the definition of these masks, this is a
preparatory patch to make that patch easier to review.

- More masks will be needed, so add a PAGEBLOCK_ prefix to the names
  to avoid polluting the "global namespace" too much.

- This makes MIGRATETYPE_AND_ISO_MASK start to look pretty long. Well,
  that global mask only exists for quite a specific purpose so just drop
  it and take advantage of the newly-defined PAGEBLOCK_ISO_MASK.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/pageblock-flags.h |  6 +++---
 mm/page_alloc.c                 | 12 ++++++------
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
index e046278a01fa8..9a6c3ea17684d 100644
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -36,12 +36,12 @@ enum pageblock_bits {
 
 #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
 
-#define MIGRATETYPE_MASK (BIT(PB_migrate_0)|BIT(PB_migrate_1)|BIT(PB_migrate_2))
+#define PAGEBLOCK_MIGRATETYPE_MASK (BIT(PB_migrate_0)|BIT(PB_migrate_1)|BIT(PB_migrate_2))
 
 #ifdef CONFIG_MEMORY_ISOLATION
-#define MIGRATETYPE_AND_ISO_MASK (MIGRATETYPE_MASK | BIT(PB_migrate_isolate))
+#define PAGEBLOCK_ISO_MASK	BIT(PB_migrate_isolate)
 #else
-#define MIGRATETYPE_AND_ISO_MASK MIGRATETYPE_MASK
+#define PAGEBLOCK_ISO_MASK	0
 #endif
 
 #if defined(CONFIG_HUGETLB_PAGE)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 018622aa19006..d16f7b7bdf282 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -362,7 +362,7 @@ get_pfnblock_bitmap_bitidx(const struct page *page, unsigned long pfn,
 #else
 	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
 #endif
-	BUILD_BUG_ON(__MIGRATE_TYPE_END > MIGRATETYPE_MASK);
+	BUILD_BUG_ON(__MIGRATE_TYPE_END > PAGEBLOCK_MIGRATETYPE_MASK);
 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
 
 	bitmap = get_pageblock_bitmap(page, pfn);
@@ -466,7 +466,7 @@ get_pfnblock_freetype(const struct page *page, unsigned long pfn)
 __always_inline enum migratetype
 get_pfnblock_migratetype(const struct page *page, unsigned long pfn)
 {
-	unsigned long mask = MIGRATETYPE_AND_ISO_MASK;
+	unsigned long mask = PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK;
 	unsigned long flags;
 
 	flags = __get_pfnblock_flags_mask(page, pfn, mask);
@@ -475,7 +475,7 @@ get_pfnblock_migratetype(const struct page *page, unsigned long pfn)
 	if (flags & BIT(PB_migrate_isolate))
 		return MIGRATE_ISOLATE;
 #endif
-	return flags & MIGRATETYPE_MASK;
+	return flags & PAGEBLOCK_MIGRATETYPE_MASK;
 }
 
 /**
@@ -563,11 +563,11 @@ static void set_pageblock_migratetype(struct page *page,
 	}
 	VM_WARN_ONCE(get_pageblock_isolate(page),
 		     "Use clear_pageblock_isolate() to unisolate pageblock");
-	/* MIGRATETYPE_AND_ISO_MASK clears PB_migrate_isolate if it is set */
+	/* PAGEBLOCK_ISO_MASK clears PB_migrate_isolate if it is set */
 #endif
 	__set_pfnblock_flags_mask(page, page_to_pfn(page),
 				  (unsigned long)migratetype,
-				  MIGRATETYPE_AND_ISO_MASK);
+				  PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK);
 }
 
 void __meminit init_pageblock_migratetype(struct page *page,
@@ -593,7 +593,7 @@ void __meminit init_pageblock_migratetype(struct page *page,
 		flags |= BIT(PB_migrate_isolate);
 #endif
 	__set_pfnblock_flags_mask(page, page_to_pfn(page), flags,
-				  MIGRATETYPE_AND_ISO_MASK);
+				  PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK);
 }
 
 #ifdef CONFIG_DEBUG_VM

-- 
2.51.2


