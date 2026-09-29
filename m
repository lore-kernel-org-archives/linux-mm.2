Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 951B5CA5FAC
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 21:53:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23366B0093; Tue, 29 Sep 2026 17:53:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2EDD6B0095; Tue, 29 Sep 2026 17:53:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1E406B0096; Tue, 29 Sep 2026 17:53:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9E30B6B0093
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:53:21 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 16F4FC05DD
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:21 +0000 (UTC)
X-FDA: 85268151402.29.A9D8248
Received: from mail-dl1-f72.google.com (mail-dl1-f72.google.com [74.125.82.72])
	by imf15.hostedemail.com (Postfix) with ESMTP id 50E2DA0002
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=H+QhDJ98;
	spf=pass (imf15.hostedemail.com: domain of 3TTO8agoKCAIpknc0xckujiqqing.eqonkpwz-oomxcem.qti@flex--nilayvaish.bounces.google.com designates 74.125.82.72 as permitted sender) smtp.mailfrom=3TTO8agoKCAIpknc0xckujiqqing.eqonkpwz-oomxcem.qti@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790718799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QVhxO6kSow0k5UDp11Gxjfu9ww4Gzm9LclAqKVKPFJA=;
	b=1xTlwSf+5qG/oM7axDrAALvqXEE+kadP7Lw1K2v4T1GJI5wAzOylpOnCbSIv4gX9sBDN8i
	R6QtBm+ACOM//dy5iMwSix7vyRvRG+SEn/Q25RDTiw7YNcJf6hcf4miWKamr5m3mHuXlWK
	5PrWWcH9sF+jPbYQptf9DfrK2UhUWS8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=H+QhDJ98;
	spf=pass (imf15.hostedemail.com: domain of 3TTO8agoKCAIpknc0xckujiqqing.eqonkpwz-oomxcem.qti@flex--nilayvaish.bounces.google.com designates 74.125.82.72 as permitted sender) smtp.mailfrom=3TTO8agoKCAIpknc0xckujiqqing.eqonkpwz-oomxcem.qti@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790718799;
	b=MQefQLNoU8wOaiPKnYEB23/LXq5F9BNiVNe+Wq/zmIo0/gobkpjsej8oEiVRoE45nMy80i
	wN9WiLfy2HSQq/mExSk9ZW52obSGsO46CKhDJ2AAb8Qm4hZzNWX9mUPYwhVm6ri2bMnBNG
	eD8t/9NVK2sbJ0aGHtRi19XyZ1uIB7A=
Received: by mail-dl1-f72.google.com with SMTP id a92af1059eb24-143826c4a13so3826676c88.1
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790718798; x=1791323598; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QVhxO6kSow0k5UDp11Gxjfu9ww4Gzm9LclAqKVKPFJA=;
        b=H+QhDJ98o2AQSj2wQQhphbIwsKZhVDsaisscnrwn7xRe8/NwNCjtmItAj+i8rnWZOx
         sQeI4ggl+6B/cZMU4NgmxS9+Fy+sz8vVCqJHf3I30gx+qVU1wWtXVpxP1IBqZk/Wvnoa
         IS00RO49uW6aF179ylb2yn5SN6k3aBX7JyBEn34kYrwUaPvBMQTI13qctoSQb71+7xf4
         caIbuCtCQEGsPeJVumMdqlOMJnkSPWwe2IRcKqsbHK35//G2AlDJletlj1KUEyIbyQLK
         EJLMM48qc5rOioJZJ78p8U5REMhgWVYZ/BasFQ6fC2n3PD+HYPKrR4KJwhm4iUeUQLl3
         R26A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790718798; x=1791323598;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QVhxO6kSow0k5UDp11Gxjfu9ww4Gzm9LclAqKVKPFJA=;
        b=IUu3Umcnd833fBQG423AlaxywHmOThi9VxJNkrDqV3b4IlH1bzPB645QYkjrb70NOE
         bQBOCZ55v260u/oOPvOqj48XpZkN7G5WLtqbNdiuz93EWGXuGA1Mr5h9oXa1l4gR5R3c
         BAjnXucamEDcT8XygTU8bWC8Uc/kFn/0Ml1GZ6UVm4JGayVNypnuKyjYX8XK4dHT/tW2
         sHci/KRC9u8D1Uh38cigPmpqjTJHmU+PqekS60P2w2pdJoZrox3ZdkwkcFekEV6bfoJb
         d+BxnyER9nJh9z68gmojCk5tNXutDrextqq8jrm/9ie7G0acGrh4iYh2o/5YkkqQbZGv
         vNug==
X-Forwarded-Encrypted: i=1; AKwUvBz69biobM0YuWCigB+mBIaPLib/MF14LugZ1y84zlrmHCpmMoQMbhzhLyMfj3Rm8XxkG39BVhTnig==@kvack.org
X-Gm-Message-State: AFuF++m7K+qUYQGf5H2FYEk27BUXrjg43Mk4wQuc13vJD8XU//J4fHJF
	B7VrK0VGVYhYuF3v8rzus0g6bLY3P3iYjnmVlJRpXDV9bzfJ3cOyRXruZ4tOnhqzUXlQp3D7VNB
	i7Qn67bIuCP+m04skf0ln3w==
X-Received: from dlbsw2.prod.google.com ([2002:a05:7022:3a82:b0:143:8d74:244a])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:4183:10b0:144:c128:4c4b with SMTP id a92af1059eb24-14c9ffac4bcmr568196c88.36.1790718797482;
 Tue, 29 Sep 2026 14:53:17 -0700 (PDT)
Date: Tue, 29 Sep 2026 14:51:54 -0700
In-Reply-To: <20260929215206.516490-1-nilayvaish@google.com>
Mime-Version: 1.0
References: <20260929215206.516490-1-nilayvaish@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929215206.516490-4-nilayvaish@google.com>
Subject: [PATCH 03/15] mm/huge_memory: use folio_page() in THP split paths
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Greg Thelen <gthelen@google.com>, Roman Gushchin <kfree@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 1rgzhsb5x38y3tykentiag358zg58afy
X-Rspamd-Queue-Id: 50E2DA0002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790718799-494987
X-HE-Meta: U2FsdGVkX1/4FHtK34AiH5NWACMYXimT54GTHOGYIlc+EtxIVvkxiNmBrHcH1kj+SAKXwN9IBxcmjkir5YF7CB9c1412452gJGRyFa6Zv991jYxO3mdN9KSOMiPmcuj5cC9db+XsS+wLogg5fstvYcrY5r3jyB4hlmjnr8m7EBjPkPCuYIukEWxZ9qaDJyBSQpD/CECrFB+k9ICq65imtgRjRD9sQ10Y0ovDlHftAYQn7MX3WRfgS3jylbpGrr+j2vJ4GrYf3BdqcOAMMuJuxRejWyVLsetIuEsa4C2VEx2ZBhkswyBHRwK5K4C0e0D2evqTWuwhfzj376mG4okjFlppODekeuF3WiTRwnm8QxI7yiwuMGAcbE5fUqSX3izbWltKR/O0s/C173gG5ajhtrYf83Qd2b+DgE2M4yEUJfdBRpTDZDs7VA1GQSEXR4AYf1ornNZePlVt7UMw1wCtaUsW9ku1b+nU6sejy1pxgk76uVjugUl+yeT8sZz/lzxRkaC0ugQFX0mgKgEjnfdKKHxTfvnUV8Ct26UYHj06NmNA3pMdUOsztC7XFkcQIIEEkkVDsYDbhUjO2YEwnSJfHUEX3F2JUJn2PdyUoV/sJZ6CZdXfkPqBBVE48NoOh6VXe9Ikb73WqQby/EcCdA8qBxtf4+E+qtDj5rLUIc38LudL5miXDhiNYyEXYCm/FFQNRN35kGaMstUKn7QlXa8KWPRPkVNPmjPFk+Rav7m08aDnWDIkiz3efSkXFnJ9/r7EyApszy9ojpbu9I2vO4OwANEnLd/xlQ22zu3Faf6rJHCcVOyrW8xexiddqrXa6oyOb15KhrpFfHKUwp9vSizoJ5XJeGxqw4x1Cm0ErnFBZaLKVRFzm5GJq8tkUMXxcGM6nbnGaMfGQh2IXg0sQ2pctK+po8gZnnasMIXiJ+rVPXXVitEGZGv2exhKQuue5RtaqO26LrrBt9RogWIVzdW
 f9KXwkDw
 1Q8CsSz1PRvX3P5p0hnNx121YMLFeUrGndpa/iqku0rRLzAZZ1zGTqFsiqb7nd3KGsH3AMkFH74nqC+yuJBYr6j4svLSk35WU00sWZ9RM0ajMzapVWK1eURIeKj9ASsOLYkuCUmku0N/7LjB3WhEJF41YKhk8uQTG0ebOQdEblsOw6mT1HqO+pSXYZ6VRx8O4XnTFfMqEEoQp/p8+sp1hx4UWIgn7naL+C9jyC2V/9fkUVfxHamTc2JMOhunKlBsG6JjF1aP+m6DauKwAdKdFkRXhh8r6E8rRaR0ZEGfsM0Awq+yH21r30jpkHYe7dS9qrgp0OJ5AWVvNcWTOsLFUuEJSIRMtXkkt+s9vlXzV/q8YXvJP9atW3FTqS0qtmJkRHvPzuA1vEnGgkv+OY8QQ541EJhYw9F0j1y+Gl+leHKePCeoAni15gxc09lrGm78OeaaP7AzBKV/bRB3jzZB7OYrU9qBWkMZMO4xHp2hZ7JFhKG6Dn7OB3ecKE5BI6b0DM7yJh4LJN8hx3++pR+pitFGU2BNOOzi5scXeAtSN4xigk1clJg8XnnY3TQhpOU18hkAJgu7J2RYYXdqzBUjUkdpWUjX6vHjOhb//VfPzcsc40dZvkoL4+Ioucbsl2G94d6CbJLkubDuY4+mnXVLN0Jy70A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of the memdescs effort, struct folio will be allocated
separately from struct page and will no longer overlay the head page.

Replace direct &folio->page uses and pointer arithmetic with
folio_page() in __split_folio_to_order(), __split_frozen_folio(),
folio_split_unmapped(), __split_huge_page_to_list_to_order(),
folio_split(), and split_folio_to_list().

No functional change intended.

Assisted-by: LLM
Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---
 mm/huge_memory.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 31af817eeded..58fbc4d4ddb8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3711,7 +3711,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 	 * the flags from the original folio.
 	 */
 	for (i = new_nr_pages; i < nr_pages; i += new_nr_pages) {
-		struct page *new_head = &folio->page + i;
+		struct page *new_head = folio_page(folio, i);
 		/*
 		 * Careful: new_folio is not a "real" folio before we cleared PageTail.
 		 * Don't pass it around before clear_compound_head().
@@ -3808,7 +3808,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 	if (new_order)
 		folio_set_order(folio, new_order);
 	else
-		ClearPageCompound(&folio->page);
+		ClearPageCompound(folio_page(folio, 0));
 }
 
 /**
@@ -3898,7 +3898,7 @@ static int __split_frozen_folio(struct folio *folio, int new_order,
 		}
 
 		folio_split_memcg_refs(folio, old_order, split_order);
-		split_page_owner(&folio->page, old_order, split_order);
+		split_page_owner(folio_page(folio, 0), old_order, split_order);
 		pgalloc_tag_split(folio, old_order, split_order);
 		__split_folio_to_order(folio, old_order, split_order);
 
@@ -4394,7 +4394,7 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
 	VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
 
-	return __folio_freeze_split_anon(folio, new_order, &folio->page,
+	return __folio_freeze_split_anon(folio, new_order, folio_page(folio, 0),
 					 false, NULL, SPLIT_TYPE_UNIFORM);
 }
 
@@ -4450,7 +4450,7 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
 {
 	struct folio *folio = page_folio(page);
 
-	return __folio_split(folio, new_order, &folio->page, page, list,
+	return __folio_split(folio, new_order, folio_page(folio, 0), page, list,
 			     SPLIT_TYPE_UNIFORM);
 }
 
@@ -4481,8 +4481,8 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
 int folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct list_head *list)
 {
-	return __folio_split(folio, new_order, split_at, &folio->page, list,
-			     SPLIT_TYPE_NON_UNIFORM);
+	return __folio_split(folio, new_order, split_at, folio_page(folio, 0),
+			     list, SPLIT_TYPE_NON_UNIFORM);
 }
 
 /**
@@ -4514,7 +4514,7 @@ unsigned int min_order_for_split(struct folio *folio)
 
 int split_folio_to_list(struct folio *folio, struct list_head *list)
 {
-	return split_huge_page_to_list_to_order(&folio->page, list, 0);
+	return split_huge_page_to_list_to_order(folio_page(folio, 0), list, 0);
 }
 
 /*
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


