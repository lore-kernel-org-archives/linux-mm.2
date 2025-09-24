Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF1E5CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 832F38E0015; Wed, 24 Sep 2025 11:00:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BBFD8E0012; Wed, 24 Sep 2025 11:00:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65C5E8E0015; Wed, 24 Sep 2025 11:00:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 531648E0012
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:00:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0F6B0C058B
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:19 +0000 (UTC)
X-FDA: 83924454558.30.8C7139A
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1FBB840011
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:00:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZAZtiqa6;
	spf=pass (imf11.hostedemail.com: domain of 3fwfUaAgKCCwRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3fwfUaAgKCCwRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758726017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bKJT4vpnX5xVBMK5mB1lNcuXbTDuRuXg8xoq8hiioZw=;
	b=G7VKjwIktQIg03f7/2qgFBRWUIdqLc4QqumkZHV87K+qPzfkY3b07Fntj9xDAbDp9C6L0o
	RDaCDbznMdopJuo8IeLW+QvMp2QUuRswKl8835cZzNPcWC0pgKnanngDZI8QNAG9ALwar2
	nA9M0evWE3m8O8PC6a4fdatdzgbNnLc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZAZtiqa6;
	spf=pass (imf11.hostedemail.com: domain of 3fwfUaAgKCCwRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3fwfUaAgKCCwRIKSUIVJOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758726017; a=rsa-sha256;
	cv=none;
	b=BxllQgRBe7DnyfIa08/yttACdo5/H4h7YtqlcYOM47+Xz27HLaiIBksfuqrSZEJdBIJix2
	Ip/dwkecxVRo2+92ExSoJM3qLvby9ron5AbWmEUY/IG6Pq9G/phuD2IRIMs5glzkMMy00A
	lYDIwA3VjiqwnlSTCelKlIu2LdKHWYs=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-46e1b906bf3so23560375e9.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 08:00:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758726016; x=1759330816; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bKJT4vpnX5xVBMK5mB1lNcuXbTDuRuXg8xoq8hiioZw=;
        b=ZAZtiqa6AzbT2Udt2xwi+yYyqOxEwY4Sp1QtLEc4uvv6MUfm97m4K0xW/Z22QqnPbf
         kxnyFglFPHm0jB2Hcqr+2V7si1/grvH3DBCc7Y7ux/OmbOUo1pYx+iJOK4088Ab+NdiV
         sHwnAfVgTSGTy4xVHfBCedvu2ZTAp/DglgAjczlW5X3wloKREVWNGicAmTsgSKxiJzDp
         0UziP5LFbybGuoLcbWFr7NloWJt1okE21EWXNNLI+OI5J8CH4U5zFXFe/DSAnN7YPH/Y
         2jNEgJBRvddKDWCFiYUdgOSEqzrE66bd7b/QCZle5uyQ456nEVfmT68NbnSI9oizZqAG
         b7BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758726016; x=1759330816;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bKJT4vpnX5xVBMK5mB1lNcuXbTDuRuXg8xoq8hiioZw=;
        b=LeIl4yURLg6PBpK+XFdQcALG8dXXkikNsQ/1uatvFrptp36HMVvMHGBJFoMPm2VLqa
         WJRpalv+dSvDtkH1Xt9qqSbOfCTf0X+apQjxwIY/c9QRZALKgqyNIR3idQWLcT25uKJR
         CL/2+xc1ODOSfoqAfja4eSitqn+v3CQn2U1yqWHcd9NndY2BNke20eolUrjBiiNulSZp
         O3aK95CvC77mGxwJlqRcZJZOdvHFnLxCNBm0vA6oOOPZ6Kn+T7/7IMK8IeeTTbgVDlfi
         vlUYhEdhjsZsbvz9ITI3BPkTQkFl6az9LDDcSFRQFn3mih6W6O5z77aHuCQYCMQfFpqJ
         eYsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVZu99+rXBBmT4WzSBxz9HQxqk29Yit90qt/dx74gKakzU7eQFZ/XcKTE2UCGc2WAjfH4yjQh3+Cw==@kvack.org
X-Gm-Message-State: AOJu0YyA65x0U9daZ1GGLwM4wBfs1f8rGgY8KE5Q1PLnW5WBaS/b6fBh
	NW8rRXu8mKwBrKHDr03evuaVmkyHLNv37U6dhAxoCf5JDp4RhNiqOPgTjY8CtgxsYoBvmfp7oAf
	280idJyxfZ/z2nQ==
X-Google-Smtp-Source: AGHT+IEwpH5Oza9iuA/SA1ZMp2dUWj5FnIP9hJFno7WJD+Pwhp72Tuy9jz82MKe39ZlHCf09lf2CtXpfs4Ad2A==
X-Received: from wmim22.prod.google.com ([2002:a7b:cb96:0:b0:46d:712:e422])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b9e:b0:45f:2f0f:6649 with SMTP id 5b1f17b1804b1-46e329d474fmr2189815e9.8.1758726015769;
 Wed, 24 Sep 2025 08:00:15 -0700 (PDT)
Date: Wed, 24 Sep 2025 14:59:43 +0000
In-Reply-To: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250924-b4-asi-page-alloc-v1-8-2d861768041f@google.com>
Subject: [PATCH 08/21] mm: rejig pageblock mask definitions
From: Brendan Jackman <jackmanb@google.com>
To: jackmanb@google.com, Andy Lutomirski <luto@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org, 
	david@redhat.com, derkling@google.com, junaids@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, reijiw@google.com, 
	rientjes@google.com, rppt@kernel.org, vbabka@suse.cz, x86@kernel.org, 
	yosry.ahmed@linux.dev
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1FBB840011
X-Stat-Signature: pcidm5jwaa49rxhxarbsrc7gyn8dcykr
X-HE-Tag: 1758726016-698202
X-HE-Meta: U2FsdGVkX18t9LMr2EG0g8RjlqEKMuSp2bkJQaPHQRw4kCf3OrMqQztLmIyMeIhgbY3hP1vrPcUKXwp+MmoEibNWSVIATE+oT4Yy5ir/5HgAQfQ9sJWicF8f8usKBX97TjnNk7u+3Ep9dYL1H4uNPTW7gQ0z85r90SmgFAJS+HCufY0IM2nvTsjh0rFDOgYTzOJV8k4wZ8fxnCFn41V1XCspyl13B9QdD0MW9s900rbz9Y/4A3aOzKR9xR9TYG4dU+tMkRzHtrTBc5CUwiQes8QOpZVzdfNWex0RwaiA+CqlMaCG5w9gqMIXzZAEQkccMMLDDwDQhZYZ6m68LzG1vkdjlxsQ2RzXrUpuo5q6yax5SX5Kmmvdy8b0hfLOGvXT7y2BUsrt9fre0k3Lt0kCwp7Li2ydCli6CRarge+UOYxOx3zpFGkDlxtWZ0Tze9sPcYaLB2azKHzM8OLDrFRJME1Vei+yJ4RwtQ5lf6QLq8pZ60I4bDyPEmE8k4BsXF+sFRoobAAK889VmsCENiYoWQ/lX1KfLsm7cSSkY8nOD2B1zfDes+wq72IhC5+BtZFUqoOugj3n7RtwkVA8CMgm2CNx6TOC4r+eTNXil7p4rxkth0lN75S60ilg+rYBh8ISzBsg0jqh3UmDXVK32+GNsqIvQHOHrucu0Nlz6MTcIUnInAaxcUUKjxUoWRZq2s22HFdHrJEt7ggX52HgBngoPwep0aswbWH8aZbtx6bVM2lEFk9oDa9s2Vxtw7cEiBg0Bn4EjOkanYCvvizaB8+x/PhoyPysmSYN76zemSsZ1a8bJqXPk2UZa9vab/SaGUyc9wNHshvvzCf+IHB6e7uGIyxc2aHbRu8BZEWysw+VYlLoInoR7HHwZIaA0sbsucH5cCnkG+GFnXMxDy6POsvSdgfJCiDNabzOf40RNrPPaimFZ8eu+v+Oe/ItmcCGN4x3y0DysO6UTG4K8O8qO3H
 Dz3c0L4/
 J19LgN0U3Ir39ChFGRZXAkD6ys3J6K4D9kdDRXI6zZn0tSMvgbamrHQrI+YADJe9EJw1u5MM6Aa1K2WFnJJtKwfwbtoINCpVvOsBt5k25fQxzmEMHAoKLmdO/FPHm6wY4XdDjNUi19scqhVxMWflEhMPdP4IbjpJl+LTD+BbogvLEqZsp5IRotE6rHgqlZSmhyPmXbU6afWMUAjgjz7ikRD/RHzZTc0IhhURFdRNa7gQtJ9trwofkUmN/6KsIDAIl5CJeBevJHEm9PD+kdOxjvuk17KqJAFZNMT7f41FolSFL5psCmHkK7RIyK59g0rhhKTt6iKZXqSv5nWZZ8gQRhoMbLpvLbyniHGamKNFpUsAbEumNMqm/bkJ+Vyr5CiBCOo76yenTynDCiDVpgtYb6xDdQAB70NFwx5qntkfo9Q2yjcrwhAIyRSCgoWEs1DUbF8LVTDTZL5rf90PTzPRsqAjF6wRgXsf4FP8/ndO3CPW1XTwZ9emOSxRR+ztR6dMrBxmjZQ1F4Van+FkIkOiVa3a3qg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

- Move the CONFIG_MEMORY_ISOLATION ifdeffery into a separate block, this
  allows the various conditionally-defined masks to be combined cleanly.

- This makes MIGRATETYPE_AND_ISO_MASK start to look pretty long. Well,
  that global mask only exists for quite a specific purpose so just drop
  it and take advantage of the newly-defined PAGEBLOCK_ISO_MASK.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 include/linux/pageblock-flags.h |  6 +++---
 mm/page_alloc.c                 | 18 +++++++++---------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/linux/pageblock-flags.h b/include/linux/pageblock-flags.h
index e046278a01fa8c37d898df94114d088933b6747f..13457e920e892c1c5083e0dc63e2ecfbed88f60e 100644
--- a/include/linux/pageblock-flags.h
+++ b/include/linux/pageblock-flags.h
@@ -36,12 +36,12 @@ enum pageblock_bits {
 
 #define NR_PAGEBLOCK_BITS (roundup_pow_of_two(__NR_PAGEBLOCK_BITS))
 
-#define MIGRATETYPE_MASK (BIT(PB_migrate_0)|BIT(PB_migrate_1)|BIT(PB_migrate_2))
+#define PAGEBLOCK_MIGRATETYPE_MASK (BIT(PB_migrate_0)|BIT(PB_migrate_1)|BIT(PB_migrate_2))
 
 #ifdef CONFIG_MEMORY_ISOLATION
-#define MIGRATETYPE_AND_ISO_MASK (MIGRATETYPE_MASK | BIT(PB_migrate_isolate))
+#define PAGEBLOCK_ISO_MASK		BIT(PB_migrate_isolate)
 #else
-#define MIGRATETYPE_AND_ISO_MASK MIGRATETYPE_MASK
+#define PAGEBLOCK_ISO_MASK		0
 #endif
 
 #if defined(CONFIG_HUGETLB_PAGE)
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 0d1c28decd57b4a5e250acc0efc41669b7f67f5b..a1db87488296a6d2d91a1be8d4d202f1841c4dfd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -370,7 +370,7 @@ get_pfnblock_bitmap_bitidx(const struct page *page, unsigned long pfn,
 #else
 	BUILD_BUG_ON(NR_PAGEBLOCK_BITS != 4);
 #endif
-	BUILD_BUG_ON(__MIGRATE_TYPE_END > MIGRATETYPE_MASK);
+	BUILD_BUG_ON(__MIGRATE_TYPE_END > PAGEBLOCK_MIGRATETYPE_MASK);
 	VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
 
 	bitmap = get_pageblock_bitmap(page, pfn);
@@ -443,7 +443,7 @@ bool get_pfnblock_bit(const struct page *page, unsigned long pfn,
 __always_inline enum migratetype
 get_pfnblock_migratetype(const struct page *page, unsigned long pfn)
 {
-	unsigned long mask = MIGRATETYPE_AND_ISO_MASK;
+	unsigned long mask = PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK;
 	unsigned long flags;
 
 	flags = __get_pfnblock_flags_mask(page, pfn, mask);
@@ -452,7 +452,7 @@ get_pfnblock_migratetype(const struct page *page, unsigned long pfn)
 	if (flags & BIT(PB_migrate_isolate))
 		return MIGRATE_ISOLATE;
 #endif
-	return flags & MIGRATETYPE_MASK;
+	return flags & PAGEBLOCK_MIGRATETYPE_MASK;
 }
 
 /**
@@ -540,11 +540,11 @@ static void set_pageblock_migratetype(struct page *page,
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
@@ -570,7 +570,7 @@ void __meminit init_pageblock_migratetype(struct page *page,
 		flags |= BIT(PB_migrate_isolate);
 #endif
 	__set_pfnblock_flags_mask(page, page_to_pfn(page), flags,
-				  MIGRATETYPE_AND_ISO_MASK);
+				  PAGEBLOCK_MIGRATETYPE_MASK | PAGEBLOCK_ISO_MASK);
 }
 
 #ifdef CONFIG_DEBUG_VM
@@ -2122,15 +2122,15 @@ static bool __move_freepages_block_isolate(struct zone *zone,
 	}
 
 move:
-	/* Use MIGRATETYPE_MASK to get non-isolate migratetype */
+	/* Use PAGEBLOCK_MIGRATETYPE_MASK to get non-isolate migratetype */
 	if (isolate) {
 		from_mt = __get_pfnblock_flags_mask(page, page_to_pfn(page),
-						    MIGRATETYPE_MASK);
+						    PAGEBLOCK_MIGRATETYPE_MASK);
 		to_mt = MIGRATE_ISOLATE;
 	} else {
 		from_mt = MIGRATE_ISOLATE;
 		to_mt = __get_pfnblock_flags_mask(page, page_to_pfn(page),
-						  MIGRATETYPE_MASK);
+						  PAGEBLOCK_MIGRATETYPE_MASK);
 	}
 
 	__move_freepages_block(zone, start_pfn, from_mt, to_mt);

-- 
2.50.1


