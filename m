Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5660DCD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:12:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C2016B00E7; Tue, 16 Jun 2026 17:12:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44B396B00E8; Tue, 16 Jun 2026 17:12:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3627F6B00E9; Tue, 16 Jun 2026 17:12:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01A6C6B00E7
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:12:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70CEE14021E
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:12:23 +0000 (UTC)
X-FDA: 84887024166.10.BBAAD31
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf20.hostedemail.com (Postfix) with ESMTP id DA37C1C000E
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 21:12:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Nz5ysZFx;
	spf=pass (imf20.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781644342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=25EV8+cd30BCeMpggJSyntHwUrkjR4MOGFomUCaILko=;
	b=34v/MT5HYE3rwmdjc8ITIVoQ0UCVCG5/xe9PQP43NN9crF/94qHdqCyfe3LqWsrcKCtJl7
	AjctuqSCevvPj+YGixw0ceZ2yFbwrk3BnX4BqVTpuwS7Vch61mo1AdHvpTahTDj3+8LJJW
	u6jneWO6yuCzwN4RrcILbzSejOlZguQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Nz5ysZFx;
	spf=pass (imf20.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781644342;
	b=B0jGSCo1QLY21YleuPZh+fRxLCfL3GAhZ1yyVQUbON7eDh7QnOdrBKdd46LNI05BgNvRb6
	SzqPhCryCwN0EgVZCeBP6woLqVGIGvM46TxD2tIXw+WNvXdHEI2Ruz7O51aje1zvyMRhfu
	lKQyRuiIY8gQFEV1kVMdfprW6gTIVVU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=25EV8+cd30BCeMpggJSyntHwUrkjR4MOGFomUCaILko=; b=Nz5ysZFx7oRrJ8mgZA+/6ui/Xw
	P0hAPmCKcZBs3kcp7O8LwIRtRku80y56umzhAP3vJKjDZyF0/cm6mxFu31WWvIIWM9R5Bmuf3xHW3
	YjkIUsXMGTVpPOVbfRMyTjjj46B8V3kjCg547TNn5LhLweXVYWUnjRyf1YJCaRDb+g3P1K78MdYXL
	tS1u3xY4t7SKKFcooshoO5NElFv0TzwBm9MrXLVqu0buXPkZpILXsGf7nDaDUt5xdvbyi30+oU8Bi
	0YpMh/GvW/gBWdXWV4utHK6gxa1mvQv4TWwo6Y2UUzF3p0cTdMoxYffKxTnd17LbhZ95Ah0Zw1wjc
	AhCftxQA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZZdC-0000000GFwq-0yxY;
	Tue, 16 Jun 2026 19:39:30 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: [PATCH] slab: recognize @GFP parameter as optional in kernel-doc
Date: Tue, 16 Jun 2026 12:39:29 -0700
Message-ID: <20260616193929.2394119-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DA37C1C000E
X-Stat-Signature: iys9jr9s4pcpzrt831iswa514xux1fcy
X-Rspam-User: 
X-HE-Tag: 1781644340-149719
X-HE-Meta: U2FsdGVkX18vSgGG/+ySUlG74ROYwM9n8G451A+fBHGE+ziWh08XytzWTKAo72o22TQ8xIcyUYTboHIKnb38RN7eS96CHmfWUmlpAgwaPEcPGBslxrjWvfJ068TJlEBpCV19UHZ/IzMC3o3ReMVfyscfy+t9zLsOY9rUISpSDxJ4EzFbMC3/lghM+s3+wyR3KFcrQ2JQ+nNnAELocSo4yXy5ggLxUTW3ws8wWGmXEa6hEvyoE90Af41BlHHbJnKl8a5CchXvifhl4J8OUhUvwqo6goRIIeE2QJQ9FgtS10/6LQ5tqDJ1C3c6b5L903aUS+CCx6vvV0eKXZIeRWkz8P0UUy95Gopur07+D8M3tUKFbNISNoZqT/57M01/sKPT8SE4r5BL7fQTDwUf37QMG84u/b2+r/CgikGCVi+rYXsGWSOnoy3AgY5o/7hfTrDBf6tPW48HA0MPN1NNzz4gH3FKRM+9lsdQLtn1tBdXHPpKvOC6RDODfg8eRD4KOQQc2g5C19ZMWzNH9Nhg2aPAYzWEEh/5jAlWzJIMTWGSDAh3RxvqPWbkHAVXHeNF1wbTJTrGoAkI3K1b4SWgM6+ZnqYcZ5JPBCTZ5hcgJd/6mrCQTR9lHMOsy8q16x2xzJ2ldWR9TzCEUnCOXBDO7KiBfamtsBVVwwk4Z+2uODBeCGbEsnhKUWqD7ajIxaUSuIVBuqOdsv6hkuK26T2QEy/mdQF2MNp8P/LmA9Bz2M0UHIWcmgbqPct7n0Q9ubH0UobyuN+csiIXbdZ+6cYVTnHJFZ0OCnbYh+9r6NVY19rJCgYz6+mxsc0vvnAfn60G58VHRtaBoW5zdbej4kgghcTLwmRxDupiOqLCbAnBkPQRY87W2lF9zSSXqrp8CiSB4ydK1YFstrvY/lrBqBIbkHSBURAGMCSqLc1BgjXU4AeCePg3IohoKbg2boa+LSwM8GgcemazHSwSR7Uk6pcW2Tr
 s7WxhKbW
 RKYb8d1AFQc2eZNL9At5cRLhTN2ACAN6wcKFmPsAXXRH1tNBUMZ+yQOWUBqSXMhIAEVxOODTXqtZGxerIJGCt0ReGuSVpTfgYhIneM8+uEHUk07C/M0gN3VSrdTqvhLdlinOvq995/LOEMsHcVOpN5aVA+0Js5qFXnHHaltmbKtbJOMWLLNGfaxBCDwUzfYXFFw9qvta3rOkd8Gz3suSBsLtrqUe8ew49FGl8aL+AqiINZm92dOvQyMyKWzpmhkjajEa7HPnCE+FINo967tBsowxg9ZcyMRWts7iUTwxWR2MaGn6R1sfSkphcgMnwGQq5VviUUJLGhRuiD5WgTDaQJL7Jnt+9yCljM6KzK939ky4EB7dqG5qj78h87Jq4DdjpUAAySfmkLnrKMfT2NF/Hd2xc2cp2LmuZk1nwDmTBr0BR48qds+Tthbm9GA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since the @GFP parameter in kmalloc_obj() etc. is now optional, change
the kernel-doc to indicate that it is optional. This avoids kernel-doc
warnings:

WARNING: include/linux/slab.h:1101 Excess function parameter 'GFP' description in 'kmalloc_obj'
WARNING: include/linux/slab.h:1113 Excess function parameter 'GFP' description in 'kmalloc_objs'
WARNING: include/linux/slab.h:1128 Excess function parameter 'GFP' description in 'kmalloc_flex'

Fixes: e19e1b480ac7 ("add default_gfp() helper macro and use it in the new *alloc_obj() helpers")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: stable@vger.kernel.org

 include/linux/slab.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20260615.orig/include/linux/slab.h
+++ linux-next-20260615/include/linux/slab.h
@@ -1094,7 +1094,7 @@ void *kmalloc_nolock(size_t size, gfp_t
 /**
  * kmalloc_obj - Allocate a single instance of the given type
  * @VAR_OR_TYPE: Variable or type to allocate.
- * @GFP: GFP flags for the allocation.
+ * @...: GFP flags for the allocation.
  *
  * Returns: newly allocated pointer to a @VAR_OR_TYPE on success, or NULL
  * on failure.
@@ -1106,7 +1106,7 @@ void *kmalloc_nolock(size_t size, gfp_t
  * kmalloc_objs - Allocate an array of the given type
  * @VAR_OR_TYPE: Variable or type to allocate an array of.
  * @COUNT: How many elements in the array.
- * @GFP: GFP flags for the allocation.
+ * @...: GFP flags for the allocation.
  *
  * Returns: newly allocated pointer to array of @VAR_OR_TYPE on success,
  * or NULL on failure.
@@ -1119,7 +1119,7 @@ void *kmalloc_nolock(size_t size, gfp_t
  * @VAR_OR_TYPE: Variable or type to allocate (with its flex array).
  * @FAM: The name of the flexible array member of the structure.
  * @COUNT: How many flexible array member elements are desired.
- * @GFP: GFP flags for the allocation.
+ * @...: GFP flags for the allocation.
  *
  * Returns: newly allocated pointer to @VAR_OR_TYPE on success, NULL on
  * failure. If @FAM has been annotated with __counted_by(), the allocation

