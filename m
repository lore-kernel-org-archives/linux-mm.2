Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D5EEC5516D
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 18:04:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 331A26B0098; Fri, 31 Jul 2026 14:04:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 309096B0099; Fri, 31 Jul 2026 14:04:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21EE16B00A1; Fri, 31 Jul 2026 14:04:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF5466B0098
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:04:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 800F380473
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:49:16 +0000 (UTC)
X-FDA: 85049657112.17.161877F
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf22.hostedemail.com (Postfix) with ESMTP id C536CC0003
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:49:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JbBgQ+fD;
	spf=pass (imf22.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785516554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6HyY8EWD+CeIwkFV5a9eHwrMcUPfNl9gW7SyAQIfixk=;
	b=ei9neRemlxgoy2Zrrib4eTwuTSKI0q0/+vmQXlmtXwvB/Wj9nFEvAKBNMXmkRV/RzcOMew
	DlUIBSnFj/y+rcyiDVWyNHECQBAn8Emf7o9sY5QuvQFJRvF4Q2z6nbq6LeS2nBSsLWQBhB
	bz9u+wjkvDxvfLudIOIbzU6I7c3yi0w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785516554;
	b=EvbQC13LXaVbhlIE5aMFTOopTqOJvqnVNB49k3x56zNdZ5HqA0c6UgfGdCZePIjGzq4cZN
	2gK7vbbgRk0O5Hgx2NPoXnRieEtVGyVGyIufyqDgWrbyO2t12gu1BikKBnnbUDTBrHVz36
	SchkuSqBAneC3ikBnsNTI8Ih/NAfDnA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JbBgQ+fD;
	spf=pass (imf22.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cc7ef7ec27so14521325ad.1
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:49:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785516554; x=1786121354; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6HyY8EWD+CeIwkFV5a9eHwrMcUPfNl9gW7SyAQIfixk=;
        b=JbBgQ+fDL+9u/JxxhS+e0iRxssF3s6tHI0We2REHodRg63sRLOo9FRoopVPsyVp0+3
         Znl79+04h2leNQZO+oQeNe6GXA5HKnAykMF0+bJKWN9UvWuToVk56pORCXA5qRHiyH7N
         pOyIv75fou4L+ChdVEIVtM8b3hXJzW3WjgeLbqJvGnpJUSJXlrJB/TZqzVBdZwyrG9WM
         7x0sW/o5hbjhb3meUML5rPx0HpEyn3VGmc4N6VoyEJp9SQKKl2aiKD5Pl5KLcHaFiy4i
         z/aHpXghWvW0rryc4BWwwYw8FRvt7zKqwPQYPEAjWuIr60bezmWzlIMK+1LsMdeEHpLE
         6Yaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785516554; x=1786121354;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6HyY8EWD+CeIwkFV5a9eHwrMcUPfNl9gW7SyAQIfixk=;
        b=PZ/hfsYtv7SYF21HsZ355wQQVvmZdnu5A1S0INiQXhMM5q/+FAiSou2nW6E1IWpEyc
         tlfDXgRLhr2jcy0PXhtE4jvlbaUBr7LzadAoAalxHuX6hXodA9Q/ySfHoaKdnDgR6GKC
         +Vd1oBk1x0nOLk5bsA9iJIVDmAEYJYrlskUi/isKvOxn1dds3Extx/SlpDl42z522sQJ
         DRbK4gYw6228MGy2px2SHOyn8BJNkwiGC5yb68sU3whL9WE3T6H9oCZr2pCKJmXwgxFj
         wytUKC3l5rtUBK2TeywXZP16wdz25ojdjnXRmbt9dtgEUD1SDCgFhKmqUoYBhprja9TJ
         BUQQ==
X-Forwarded-Encrypted: i=1; AHgh+RpjnWRLdjtO5LxgOH3ZrOPByGkriVrob9TOc3HvpG8CUZYlj0qPLTEsFD7ZoVb2q0u8NjyKWMo5bg==@kvack.org
X-Gm-Message-State: AOJu0YzoeVdQEHcmhazZNnlvcx+ByjK1dcSt41nYOqsZoe3+r3eaA/70
	gJhbc4pp2nqAZ4tfqDxB4ZwaticQCYbMBnHqZq24hmsCGnohAmwo7hB2
X-Gm-Gg: AR+sD130a/dKO7YBYBc1vFKUR7W8k8eVj+Zmm9NpqETgFDtXBviHZNI+RachaGO430I
	gZt78fk6jcIBD/cbeMpTHJbn6Wj9oAVjXCS3pdZNjDEBPsSSCEu7TlEoTowGdnLa97+rTLZ0Roc
	G7n1K4LquU1YvGZxsxO9l9I8/cdE6XHOj1ETHXFk4JQyvZeN5Lh/+uj0NxKmNji20qlhhDU2y8z
	Z+9sr5mPDyBgyijBZSpwipypoxo0V3ui+whttk7JUlBo5PJIdlHcbOwNyFrM6bVcXTWP1vDqzyY
	r0qD5lIsqyX39BfLFgwNwdouMs232tMCVgJ7UXFqsKjPOR8UWKNLgNSSt7LWfiWSOZYD8DgAVsW
	O6r6/yG9Rhg0I1TUqAaeF0yVAOGcb2dR0LuQJuMc/MzSK1se0nz2dlFUqQnITbt09C6dg8PbJGf
	fW33ofF0KFQJRRGWYyy74KMihRqCdaLi66zr+MVTM6GtzMZl+bOJrnJk0=
X-Received: by 2002:a17:902:e843:b0:2c9:cf5d:d9b8 with SMTP id d9443c01a7336-2d0523bea8emr6660295ad.33.1785516553467;
        Fri, 31 Jul 2026 09:49:13 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04b11f99csm7813635ad.58.2026.07.31.09.49.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 09:49:12 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>,
	linux-mm@kvack.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>
Subject: [PATCH] mm/sparse: correct init section annotations
Date: Sat,  1 Aug 2026 01:47:55 +0900
Message-ID: <20260731164758.1210668-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C536CC0003
X-Stat-Signature: riar3itjtnd357iiswtgjqat8feyr8c9
X-Rspam-User: 
X-HE-Tag: 1785516554-602155
X-HE-Meta: U2FsdGVkX19eVRAbK7yiFBD2fqnPBsY86mWQcafQXmk0ubxOsNsoUVzY03aBTMhSMk6PH1el0Qd5C/n9y9VZetaNLXBMSu6/YxgdsPTk0bq2YGrOXt2r7fHEe5/uCiqi5aeHK9c6Wsqd54w8Mx/hHbUf82QEVlKr/1dumKMYm/Ibup0CN2tapWi404lKOUMDB289w3P2MgnMRD98llvwIalk0Jh/Lc1iWOlVxlu6kAHpmi/BR39BkEokJONRy3+MxSyXE5i1eZCrXfbT3xSbx3htkbYmuo25Cufd54fouO0udXH+vxHo0hoOer4kWZ4wP9FqRuUSRU4qzbwAWTSzg6W8ZFJBt/ys9MiF9A7YaqVfjwi8QvtT20S0USR3poyNIKKCkVVpOz/dp66sh5ew4ts7xej921bnY+lou7tg57lkvVfUmZb1d/obMzoKR2+90spgnfKyw6eevGcq7Ns2+nC2G/RQuptV7VBf+/UpyKr2QFZHh7CKqbUXWoPmpbLfmEDvXNcIjJwM0oP+CYHxFsZxNQc7u4RaRg5LOgmvvI1wdoTz7DlnLOi2pd2I7j97RTrgi3wqJ38+oR/OXabDO0LMWZXso+2AATlFCC7WRKLr7D1ckcFKThCR00F1HbLRuMnbl56qRg05csgJdVxpwhBWCNGq/19CkhUI8CsLHvioVnZL+PPX5ZIM8Xqnn8wf43RRtsqavoWRULEzETjmL6d49GSkWQyNhOKds6lEEPxQxyCwZcPxwUSInlYTjzzX5PyhlWQ0qFYRLOXtNGqqqqlGKeJdtckPfhuMrM2cR/PYT7wiOz4LzBFIiFS2rclu0EkHTCyWnphfrFN5RbJKbVTqkDUVyNaDPkBd7h+TxrwbzOSFRrgxZapAd87LFHgW19pmw2UnsUfk76tvMrFcTrvvATMdHfA2Hr7PS0ffPK8RcE4W01vhfB7jXwVfBS89lRH0sz8gaKZ4ZneY33G
 wz4fmvsw
 lOyvDkwGuxU9Zi5ADPQ7JAG7Q5umhqm7ExaRtQBjxJ9kZDg4qQtYfczBbjCTWeX3ol7yMbk68fxUGUoAGc2d8mnlWt8TOWc92RZeuLaGlYeMKYBfRKfWznMNZZc6G0gnmgh/LTbMElNouZDdy4f6SqNalpaTd6ru45/lrI9DQ6onG7L5sQR/4xafR6aFsKZqtIsoljvxpA8+XPFmUR3oHZbL/+UroIzfJiPO+r2qQtIkBm5+OFspPaPNpaiGhy4ROBlY94H8IvOzH9acPjn+W0HYKunYjha3vzrVQugM7aHl3CNpySpdDfc+ELqAVHhbKJObYwHijm3+UfRWT1LMUc6S0gzckO3B+HUiUz8bgsbUkJmUCl1GiIkoR5Oz8krqIshItzE3/bq4n+hU4nV2uKweZnBJNnqAbmhb0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The !SPARSEMEM_EXTREME stub of sparse_index_init() has no annotation
but the SPARSEMEM_EXTREME variant is __meminit. So mark the stub
__meminit too.

mminit_validate_memmodel_limits() is only called by memory_present(),
which is __init. So mark it __init.

sparse_usagebuf and sparse_usagebuf_end are only used by
sparse_init_early_section(), sparse_usage_init() and sparse_usage_fini(),
which are all __init. So mark them __initdata.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/sparse.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index 704a9dec2b9a..67fa192d4289 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -104,7 +104,7 @@ int __meminit sparse_index_init(unsigned long section_nr, int nid)
 	return 0;
 }
 #else /* !SPARSEMEM_EXTREME */
-int sparse_index_init(unsigned long section_nr, int nid)
+int __meminit sparse_index_init(unsigned long section_nr, int nid)
 {
 	return 0;
 }
@@ -127,7 +127,7 @@ static inline int sparse_early_nid(struct mem_section *section)
 }
 
 /* Validate the physical addressing limitations of the model */
-static void __meminit mminit_validate_memmodel_limits(unsigned long *start_pfn,
+static void __init mminit_validate_memmodel_limits(unsigned long *start_pfn,
 						unsigned long *end_pfn)
 {
 	unsigned long max_sparsemem_pfn = (DIRECT_MAP_PHYSMEM_END + 1) >> PAGE_SHIFT;
@@ -249,8 +249,8 @@ void __weak __meminit vmemmap_populate_print_last(void)
 {
 }
 
-static void *sparse_usagebuf __meminitdata;
-static void *sparse_usagebuf_end __meminitdata;
+static void *sparse_usagebuf __initdata;
+static void *sparse_usagebuf_end __initdata;
 
 /*
  * Helper function that is used for generic section initialization, and
-- 
2.43.0


