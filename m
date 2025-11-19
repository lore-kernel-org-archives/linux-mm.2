Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45879CF2585
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 05:47:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74CDD6B007B; Wed, 19 Nov 2025 00:46:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 724086B0088; Wed, 19 Nov 2025 00:46:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6611E6B0092; Wed, 19 Nov 2025 00:46:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 569826B007B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 00:46:59 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 13EA24DD78
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:46:59 +0000 (UTC)
X-FDA: 84126272958.02.A857089
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5EA621C0009
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:46:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=U1QS+YAA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 30FkdaQgKCEkutl1t9lyrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jiaqiyan.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=30FkdaQgKCEkutl1t9lyrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jiaqiyan.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763531217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Vb/HB7JvOs6MeOsQOCBNlFwF73L2gTjMjilw7YnURsQ=;
	b=drj4eUmuFERTuf6/t4/+Fg5O7vkNZWcGyUJVhmLXCwHP24a0UpIL0/ZrNw9fmJn39f2qYP
	g+i9yuiDF97MoigTqC9QTcdq3CbBBW+kqrUMlcpUvuwiAEX+y3aYe8K9wHm4M7VFCOwMZd
	gFbAwIg8tG/XPZtndJ6ZoyJsjLr+x4c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763531217; a=rsa-sha256;
	cv=none;
	b=KyC/fFLosdSPAs2+lpkzqOn/0PTcTLfU6SM+a3BRBzoywvb1ybZ0ceZm9PJlpkAXKc+ZNy
	x4MLq8Irnjzeum6NewZdtXr54+a5yUAOmVmG/nPDfJyRjY99/f4+CMLA/wtf6objXFBnfQ
	2bzUJvsAmh5XYF6EdccHCRmE576S2NE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=U1QS+YAA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 30FkdaQgKCEkutl1t9lyrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jiaqiyan.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=30FkdaQgKCEkutl1t9lyrzzrwp.nzxwty58-xxv6lnv.z2r@flex--jiaqiyan.bounces.google.com
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-297ddb3c707so56858575ad.2
        for <linux-mm@kvack.org>; Tue, 18 Nov 2025 21:46:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763531216; x=1764136016; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Vb/HB7JvOs6MeOsQOCBNlFwF73L2gTjMjilw7YnURsQ=;
        b=U1QS+YAAdBGJ0WhCoxNtrXzciMHhEEOGhAE/9u5DPcnu1+MvWUvTlhhQGwwZqcUP0o
         SSj1QCWB69zNCkPdQrYPaeofvKdaRryxwHh3X53mVLPm9Wv1yU+YySPkuQ3OgFtNItRo
         fze/qfF6zva16JcJvXPBEeEIxFxbSY+IM5gPKEcjbXJzFaHjdgEeTmeTSYBbFksBRHDX
         5+Vr3rh3ZdRNl6eTXvP3r6k4F5Pwiqc1zL+ocVgHjDJRaoDfWc5EKAH+lYbMP3zdbgb9
         Ec4NRHqVulLSfE7ERb21v90ES1b3U01TdMYF+nCKIvCXj89Z9FU0FjnB4X5WRyB7xVZM
         uqww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763531216; x=1764136016;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Vb/HB7JvOs6MeOsQOCBNlFwF73L2gTjMjilw7YnURsQ=;
        b=XuWPs0h65FXUK0gToPU5VwhPoriAOI6RA3vLpti+eY+90kX6UjCSlwPreka5N5MbB9
         chW2LMoVQamf499QJ81xmL4AHBhl66KcpnlCQ4xpmkkdMLjc/zhvTcIC9P4d8p7AMVTo
         MCBdr9kYkkLTVbQNg2mxCCyZA+0/bC68JK5Lr1G/LYVeMaerzpPwr4piWPDj6FDFUp8i
         PDKEZaF31GSqc93l+2Jw/hZJawHCSqcO3vBrJzRI0fDG18gby3rtbmHGgjlKgsl8Jaf8
         zLO5WbBLoSA4j3A5dLvGRxF48S1WUlImZ6RD3ODXPISva2nICOq08Ve9GEpH1SAjccxz
         D3mQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUiYsX0NE/ifXPgeyY5HX8f1BTVaZV/lVstNc0rhbJllefZx8z2/prH7+DD62E8vH5hm07G426rQ==@kvack.org
X-Gm-Message-State: AOJu0YzxoZEJJokOlfgdJ2clkm8LC1z2W9ZQo3u57EQj+s/NlVddCVur
	06gRaddEKQ+IZdMNC5D7RMT/39onViNDqS/AhPv7uHWrIVHXnZFmhWTFxXO1qFlFD4nSMkrkhDu
	lE5amVF+bO+uBnQ==
X-Google-Smtp-Source: AGHT+IGADl9ZQ07/9MkeCDeRkG4/7zfkllCvkoKF6loKrPg/WHyFF90dkcPphnyfyKbl1jk4LilKUYjGFxQVnA==
X-Received: from pjbfv24.prod.google.com ([2002:a17:90b:e98:b0:340:b55d:7a07])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1b2c:b0:298:45b1:89a1 with SMTP id d9443c01a7336-2986a6b56edmr216337365ad.12.1763531216125;
 Tue, 18 Nov 2025 21:46:56 -0800 (PST)
Date: Wed, 19 Nov 2025 05:46:39 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251119054639.244202-1-jiaqiyan@google.com>
Subject: [PATCH v1] mm/huge_memory: rename __split_unmapped_folio to __split_frozen_folio
From: Jiaqi Yan <jiaqiyan@google.com>
To: ziy@nvidia.com
Cc: akpm@linux-foundation.org, david@kernel.org, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	inux-kernel@vger.kernel.org, Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: ntta44ydwmu48p6x8fseerrqz4zyip39
X-Rspam-User: 
X-Rspamd-Queue-Id: 5EA621C0009
X-Rspamd-Server: rspam10
X-HE-Tag: 1763531217-400403
X-HE-Meta: U2FsdGVkX18s/mYkdxioi3XehgEf7iHINccmP8c1CzhNkPx3K51EROCvHEGzA8+EYYX8KspbFonn9QY07k/aqFC6jcxEYYeE63mRuKYFk6E94zfTCROJ8Gn8oKqq/O2r+oSpWK8t6QQG+vgOFYbpFjmgR2EjzZEoJ05K+fl52T47/IiLZvcJzv69YvUVShIEUqyCmzmqFkE09YOD0JUOo6fkJjX1I+KyljS3nl956zE5fQ9MEpqPDn+ojLIz8w8TyJeMqceFKug+WjG7oOslAsEeGV7YdnmToL7yeFw17feeHrjZn1f/OnkWi/Ht0e5kEWy3Knj5xkTxp2JqAeZX/9u/fAVRGxLIf+6rh2xY8oksiLz4VJ+vjU7ElSrIzUyfILUFRKGOThsKQT2DxFxTXhbEY77BphfUTBO5CLVFyrQqAEmNPpJXOoNMJbgKT9p5e61KdXsx+pvm0GEua1GQSQxgGAOT+ub5J95G3oYcHXE2ZKpD+PgrgWYT9nj+ElLphBgAIoMJTV6zc3o51dHt8bpxGz+oRhLebHHR/gQogIVThHlYGjlpIHcwAQo02UoaqFqE+pc5Vgdbdqd1GAvNqzU+mOXPWtpygxz0mJiotc3fcLbYUAuc/JT3+a0kfUderLRL2ARmSRkB2+h30jJ7Q13AHZnfRw/ekZvWD/UuSEP2Z66f/evnN9InnWRixwmC9cYR9c0QgqMTdpZvDbI94MBgXE+//OjPDCaCFihOBK5aXMcjrTo+DHrx4Ez2CWPx/SVeRMk8LXXEes372z7gMkka6Q2fIEoxmoCxKXPYQFVTFqf6Ac0PKQUTgmvkDe8VodED/AyoYoPm2QN87vmx42MtWmDYHLqnN1GIty/1tI3H3rxdCITWjigXxH4Go83Ayp1jPjeU2kuG0lwwIAeXOENnaOhwY+5LIHRWVACkkM0mVw55pE8ua3GJWwd3iR7evtW6elO1hBTmMDWyAZV
 2Lv+LDEP
 uWEv7VxlOuouyrUAR+63NeLeCVCD6NRly4kZJzVgTB6mYfIje2NjXAbhdqdGHA769t/cH4gzRM8si7PPa7zapcPgXmV7ghOenE+5Iw+r0nyo01+g516TYrLI7/MMaAHWCAtPoSWpiIonPsmif9SCCUKar8/kM+10RTGhUweNYXnZGdvz0zW2wXCSp4hVrl3NoMzmZfpwYf48qvWoUfkxjVMgn88hslYngCd0ZKashKOtu7t+NVVRO7793mfQIsuCoQjl07DKfSH3/GYiYjB0wZb2YESF2OYGs89vPjE9cvY1A+BysyjA51yiuYpIDg8CiL6htaTX7wP7fFU3keD3rClMIrLjB2/qVqLsfONcfNPPM4UE85m8Vjdh8izsYYFa/Ujxok5Y65s1Hjg5cC8XPaX4Am49Su113vuheLYBM7X1SojluphgnCfEQk6YazkpvkhrVzRj/d+73JvW2NOiwuJOfyozYsC6/WGMXLj+7zha1HsAUoG9jT5SmUmRQ2/6BTIjeVHT7NeXkfCZxFMfR48WS9CcH9qcPyKEryYYaQ3hTmACF2tMbTzxxttbL3B9GI0QBa4GzC9vTC0Gqqhn360u+5Zwtoi52q6tktub8TjTwyGjWnRwTTOQvE6I8fePT9qmLAxHoD4lUlLxmI9EoOi230rr95rnMtCjPOV5MWGJ8qXcRWX2gZeT8bd8x0qDG0rHuYLbzDZ0neEhR5HrvsomzTAkL7YWJf4oBZhnYzAqp2lG7babQ1k1UiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The correct prerequisite for this split utility isn't really about
if the folio is unmapped; it is more about after unmapped, folio's
refcount is zero and has also been frozen. So rename it to
__split_frozen_folio.

Add a warning in case the folio has non-zero refcount.

No new function is added.

Tested by running split_huge_page_test: testcases all pass and no
warning is shown in dmesg.

Suggested-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 mm/huge_memory.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2f2a521e5d683..5b9c3725e9265 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3390,7 +3390,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 }
 
 /*
- * It splits an unmapped @folio to lower order smaller folios in two ways.
+ * It splits an frozen @folio to lower order smaller folios in two ways.
  * @folio: the to-be-split folio
  * @new_order: the smallest order of the after split folios (since buddy
  *             allocator like split generates folios with orders from @folio's
@@ -3428,9 +3428,9 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
  * For !uniform_split, when -ENOMEM is returned, the original folio might be
  * split. The caller needs to check the input folio.
  */
-static int __split_unmapped_folio(struct folio *folio, int new_order,
-		struct page *split_at, struct xa_state *xas,
-		struct address_space *mapping, bool uniform_split)
+static int __split_frozen_folio(struct folio *folio, int new_order,
+				struct page *split_at, struct xa_state *xas,
+				struct address_space *mapping, bool uniform_split)
 {
 	int order = folio_order(folio);
 	int start_order = uniform_split ? new_order : order - 1;
@@ -3439,6 +3439,8 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	int split_order;
 	int ret = 0;
 
+	VM_WARN_ON_ONCE_FOLIO(folio_ref_count(folio) != 0, folio);
+
 	if (folio_test_anon(folio))
 		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
 
@@ -3583,9 +3585,9 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
  * @list: after-split folios will be put on it if non NULL
  * @uniform_split: perform uniform split or not (non-uniform split)
  *
- * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
+ * It calls __split_frozen_folio() to perform uniform and non-uniform split.
  * It is in charge of checking whether the split is supported or not and
- * preparing @folio for __split_unmapped_folio().
+ * preparing @folio for __split_frozen_folio().
  *
  * After splitting, the after-split folio containing @lock_at remains locked
  * and others are unlocked:
@@ -3698,7 +3700,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		i_mmap_lock_read(mapping);
 
 		/*
-		 *__split_unmapped_folio() may need to trim off pages beyond
+		 *__split_frozen_folio() may need to trim off pages beyond
 		 * EOF: but on 32-bit, i_size_read() takes an irq-unsafe
 		 * seqlock, which cannot be nested inside the page tree lock.
 		 * So note end now: i_size itself may be changed at any moment,
@@ -3788,8 +3790,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 		lruvec = folio_lruvec_lock(folio);
 
-		ret = __split_unmapped_folio(folio, new_order, split_at, &xas,
-					     mapping, uniform_split);
+		ret = __split_frozen_folio(folio, new_order, split_at, &xas,
+					   mapping, uniform_split);
 
 		/*
 		 * Unfreeze after-split folios and put them back to the right
-- 
2.52.0.rc1.455.g30608eb744-goog


