Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC0FA105A58D
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:43:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06F076B009D; Thu, 12 Mar 2026 07:43:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F34626B00A6; Thu, 12 Mar 2026 07:43:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E36E86B00AE; Thu, 12 Mar 2026 07:43:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D21156B009D
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:43:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A4DA81C14A
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:43:54 +0000 (UTC)
X-FDA: 84537226788.05.9A60706
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id E8C15140010
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:43:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WNX9KYPI;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773315833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=H9BJa2FyYR/4Xd2mO+Zu5rjBKkRjbGyZ920JQKQ/ZcU=;
	b=byDVL9ctN2JwCOW7shUQj6+Zu4cngcl5iNP36WEcmRLKSX2fahVyi5CZY1/qIhgrvLDqZw
	SBSlNGiJPFMVkOpx4FFh3fitNIrpyPL1FPEhIv3Se7fDdZzVUL0TGD/62FvStiXjJ5x0Nn
	LgO0/XycIKjfDFR1bcBcOND83OGHM/A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773315833; a=rsa-sha256;
	cv=none;
	b=eoI/HBwmNDyc+5YsDsR7J/gj8+MLowQPcLc98Yzt7BlZOGwoFprrWIb3piPOWnmgiOCMZ9
	xKjUn+AdEXRuykTZAgWARfMuwZ1U6ea0zjcUcRMVqvgUAcIaO2IbJPJIz0Z9xZxvo4FHcC
	hi/waF1HVO/zPx9nqhtYyoPk6+MWbOw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WNX9KYPI;
	spf=pass (imf09.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773315830;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=H9BJa2FyYR/4Xd2mO+Zu5rjBKkRjbGyZ920JQKQ/ZcU=;
	b=WNX9KYPIJOBac5XcqnyjqN1C2HNJOyEakSmm+LNQ8BFNEwdYyo5O9rR4+ptnMYvLEmXK+W
	aLNXY8NTLOqEySImMa3EJFcDcDlopnZAvIJFJVmDOoI5btEENgDJvGOSApFeaiDpRcbjqq
	d06/2LhOKJsqCvfOWr7x7iYjck961uM=
From: Hao Li <hao.li@linux.dev>
To: vbabka@suse.cz,
	harry.yoo@oracle.com
Cc: cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [PATCH] slub: clarify kmem_cache_refill_sheaf() failure behavior
Date: Thu, 12 Mar 2026 19:42:25 +0800
Message-ID: <20260312114309.213731-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: 18steysbgbya7xpugxhzyx6xzxnygj1d
X-Rspamd-Queue-Id: E8C15140010
X-Rspamd-Server: rspam03
X-HE-Tag: 1773315832-700263
X-HE-Meta: U2FsdGVkX19vQGLVetF6QXD2cVOlL78MMdg+PC8UoSoIZclCpAyFWiIklk5swS4hCQT9SwVXc5CCsaSQ9XkajZnaQV8EJty3CYIWL9wQ7+m9idtl7WWljSQzjYs3kDFkJ/kTNj4NY3ergIq4Fb5EYuB6727KUb735bAmB8pxVWtJidziASXNrCJZJjT6AXc48mZ4AaM8PLUZ64Uv31m7V9Uuk54w/LlysUQScgl/JQ7M9cPYgL52gGiOyBO4WeWEICydVJjhau73S7fYqze5OTa8+rpuAChhefnmG4wLgheqwHsB+KgtyFnZIdilU8FWIGfkr34AFicpX2BCrjoqwj9i4pk8esNl4bcN/JoOCglOeQQzvyCop/L/k4LdVs8k8iY5MK6juf4Sf+SxMVVRsfa8JnswNyENCeJNRgvxsR6p79rRGDUNBVDmBLLfcZ4BEdGxzIWy35lIpLgVxbqrXBz93WouHQKYhyiYDz3Wbn/iAFvEFAh7V6xIFS/4zvX7/u60OQrmK7YG3TNbcGQ+JaN8lz/x5C9VsppSH/F6dgcSwH8QCo7r+KEWNYwTy6Wv78j66gchgyR+qYPuFyk3qbRX1ToZZsplXDFP55mSqbWVPKUlBRWfBaUy2TbsTQMuvswvFMDKBA+OzMsMoKUEABEQoPcCpkzNGQpTFnyGr9PnOMXZM3KPdRNJF7ljoykg/xrWGeryZu3tF3KZeIH25QyDqvNfWvwkD7mq5rNiMK6m6K8cyDQciToUvXC157T+EBoeLquCZhWmfHmWQaICVhWgNaS+s8a1ROujizcolwmAjE0tBLnkEqe1F68RbBfvHn/Bs8RiZK3CVDHusEKIR9CpUkzBHUYPXqxQ3dFTuGCf9ypwn2gHfPn55uSrSIQawLp+YvGpXrqv1PCxGsOfdA1TNhQ/gEzGDWPDwy80In5bhMeDvtjInUNKimqnAIvzUHmy9dUURvlRMWiPJOm
 Mlvu/B+N
 XxoH8npyLgIfBScBxethO5vqwc0rHcu81ZmJsqvAqomLKy+YVxTJI8J9faiHksV1iYIZqwXPfar4lU4xKyAZAGn5KB7FDewjso93Zm7xUV1JnajSnALK+dhJeL8piuOd+yMd12aNSrhprZk/ud+rFJFhkDA1qlWbSm13P6nIs8IlpJKctH1xo/LpUKhw1qHo+9MhFx+npjMqE+qgWSP2wUmYjKa2pJD/L/ZDQSztR9auVm1DPES5hLL6WEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmem_cache_refill_sheaf() can fail in two slightly different ways.
During an in-place refill, some objects may already have been added
before the function returns -ENOMEM. On the other hand, if allocation of
a larger replacement sheaf fails, the original sheaf remains unchanged.

Update the comment to spell out both cases explicitly for clarity.

Signed-off-by: Hao Li <hao.li@linux.dev>
---
 mm/slub.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 11a99bd06ac7..8ae248b5b384 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5005,14 +5005,23 @@ void kmem_cache_return_sheaf(struct kmem_cache *s, gfp_t gfp,
 }
 
 /*
- * refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
- * the given size
+ * Refill a sheaf previously returned by kmem_cache_prefill_sheaf to at least
+ * the given size.
  *
- * the sheaf might be replaced by a new one when requesting more than
- * s->sheaf_capacity objects if such replacement is necessary, but the refill
- * fails (returning -ENOMEM), the existing sheaf is left intact
+ * On success, the sheaf will contain at least @size objects.
  *
- * In practice we always refill to full sheaf's capacity.
+ * On failure, there are two cases:
+ *
+ *     1. If the requested size fits within the current sheaf's capacity, the
+ *     refill is done in place. In that case, a failed refill may still fill
+ *     some additional objects into the existing sheaf before returning -ENOMEM.
+ *
+ *     2. If the requested size exceeds the current sheaf's capacity, a new
+ *     larger sheaf may be allocated to replace the original one. In that case,
+ *     if allocation of the replacement sheaf fails, the original sheaf is left
+ *     unchanged.
+ *
+ * In practice we usually refill to the sheaf's full capacity.
  */
 int kmem_cache_refill_sheaf(struct kmem_cache *s, gfp_t gfp,
 			    struct slab_sheaf **sheafp, unsigned int size)
-- 
2.50.1


