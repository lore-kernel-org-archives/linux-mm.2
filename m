Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CBC7606A323
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 03:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=fi+Mycwm
Received: by kanga.kvack.org (Postfix)
	id A20486B05B4; Sat, 14 Nov 2026 22:17:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D17A6B05B5; Sat, 14 Nov 2026 22:17:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7EC6B05B6; Sat, 14 Nov 2026 22:17:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 64D2F6B05B4
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 22:17:01 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B3C0B1404A4
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 03:17:00 +0000 (UTC)
X-FDA: 85435891800.26.940C781
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3B14340005
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 03:16:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fi+Mycwm;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794712619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=mN2gq5B+d2OvtU8QqWvnRSQvuxpXkyu+nWgHWvtvpF4=;
	b=GQtTNaF2SQPI89eLBrLcRYBdBstq+VfZCu/FSpgKG5IAIJwXoCzjoRSQ87T/fF6cR9+K+J
	WmLMsH7N6jIcUeROvFy6XZP46jbJICT6Y11coZzZG7ymPuQNpnxAIu5vnP5cP+rPFq3w7N
	Yr/MaX3QHCYLsUcF0Fc9fPsmgNGQo6s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794712619;
	b=YJzzpWZMgTtUOBvz92tOJ1NfR5cbwSTgiTmzPBf9gD5KErNzx0DJCZc/R4xvk9tpp5vKo4
	bwDOQJTuO1k5S4sovR55iJNfl5A5PnNfcq53sAokPPmkF7YkdrGJfc+knSPQ6Z9P4wz3gN
	YWBsjckitmCwKeQzENS6j/ZXTIjkq7A=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=fi+Mycwm;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BE82261418;
	Sun, 15 Nov 2026 03:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 634D21F000C5;
	Sun, 15 Nov 2026 03:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794712618;
	bh=mN2gq5B+d2OvtU8QqWvnRSQvuxpXkyu+nWgHWvtvpF4=;
	h=Date:To:Cc:From:In-Reply-To:References:Subject;
	b=fi+MycwmVKAMu9UZnLmwfamKPztqU1hS9jXCnuSmefU4RzNvBGbpNahkM0BjEsF7v
	 JxFUjP0A5Q9Gft7w9glddCCuN6a4UIlMHF4oRBdlFrh6kf/dsrLYzxJ7G+Pz5V2BoM
	 rCrGh2FMrFJBwf0c2YTbA7DTuYdevQg6T5bZbXmc=
Date: Sat, 14 Nov 2026 19:16:57 -0800
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Shardul Bankar <shardul.b@mpiricsoftware.com>,
 "David Hildenbrand (ARM)" <david@kernel.org>, Dev Jain <dev.jain@arm.com>,
 janak@mpiricsoftware.com, Jinjiang Tu <tujinjiang@huawei.com>
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <2dfabfd9476542e39c7d5473a6597208.2@linux-foundation.org>
In-Reply-To: <2dfabfd9476542e39c7d5473a6597208.0@linux-foundation.org>
References: <2dfabfd9476542e39c7d5473a6597208.0@linux-foundation.org>
Subject: [PATCH 2/2] lib/test_xarray: check unused spare node after range creation
X-Stat-Signature: xftwrq1zb6imikiihcfucfpdec8ersek
X-Rspamd-Queue-Id: 3B14340005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794712619-868258
X-HE-Meta: U2FsdGVkX1/8YlCFkLJ6nt9u26jJbIx0utc3YfyxvBsXplb1FcnmQlQg9pUSN47TNqCylE5qN9qZqSOs7tUwewxVh5J40Dt7tSaCyWwoKs0uaZT5+Zcwee/VTt4zSJVVErmOgGvpfl+oxZ5N6tMszLHwlQgPZ2y1nbmqdGq3W5hfrGLFv71g7lwXwSVOKA0FeZupg0lhkma8yExj8VFZwmY1pleiHfLoyWsq7gH4R9zUroTl7ivE+zeH4eOnQmPAcVEAZ492NQZqhArXc+3AlnI3b5Mix13ff4riOWZTUQk7GHHf9RVH/eL0bNyy7GT0xEC6RVmlA0HNUrjpmJEko/xYAUrZrkNg7Y6KW94+RHQlV5wGlXp9KoswbRBljmTHYl40tp+EUtqRa2TxIa7wsYcf1WcXW49FQplp9X0K/Crv0gggscGp1Hl+gR2TMp8hjyBTaUMBWBwDguM3SQmzZJlYYWAg13hCkz8ykb5mZyJyy/SDo76PajrtEnqosBrhFm3KoxSzDgpKfQ8QX6bGPF8IDOwBeN+aXqjR7+yk9wkl9TasjQLMup47qNigDq8Oyjn0lanSMLeM7Muj5fJmJiyEdStm0LqggA28LQZI6RjnWoj+K0wKJYBcjk9VlUxNU3p+1sydgnXwgb5qk+vW+w8iOMe/fggzjeXl3II14uX6USVWQ9BU7F56MZmc4tXdHVQ/2VkEnuerR9CPY+A9a55OrS3rxYRnrfCp+s+WVevcR4Ay3+EzucCxy0rvnl9j2WYavrjMuHm6zR/HDOHHVqIhWmRKyMwBxIDG6idBjFK8YmwQJo5l58cIljp7PCXzm3BCphUq6fsSDzJ0fEwjVHgSKolwfbvmJLIhqPLQ6ytJLuUsLQahzDRe1B8qtG1x3bgyumxV8Qkk211jSPOoeBCR2beoYlyKYwwbZzEKptQil/nPy75F14SmEK/VY4SCUV0c/9Lm7TCxbf51ofA
 kWQjxCxY
 b+T27CYYV1CHDMgvF2KRQw5TutOUBLy2jkvpD4J+itlH6SmmpdDOuRJRJhOwQApej+L8mpEEPfg766DEpypDGxLrr6rOlQJGnf5SyWcuebGUoUhd4Og0U+vVmIVYQaXWG80CbIY7PviY+d2T8wEx007yOImNwF+vyqYi0jhkc5CJ8a8vjCiJvYzSHOMxsoC84BFcRBgFyOsKhIKybNUik05eVgvu6SzAk8f7zl86j0vZgdBN/qn3Q1Gdy0hJ5o8rcFdaVYzT7WLCXSp/i1/IrsiFoKQbXuN5+Hc819L3LW4PmpRZnRd77Fw3Q7tol8qUXk7GNZDT8YDdsJRjlGbl09XnvTPK8MzslkJcnDzLTpZVwMgazbwrw4TrvLGbmG/VnuyfnFDozXqx+mF7DIE/V8Lv2beeYGyEBRBnC+vf5W2LYTOiAzj+wPmk1nZQBoNrLMAZ98VffqEzoOhYD7TNv4P1U9pddSLuId6EgrVpF2l0nwoc1mCMXue4t/0o/OoQoZYPnzHi+SJOSzzFYbcqhRhCVuEy7kn2F1J8AhIxofN4lEPS+axFuJ/5dOm06sRzyi6TZltWKYCTR2p0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Shardul Bankar's "[PATCH v4] lib: xarray: free unused spare node in
xas_create_range()" [1] releases a spare node left over after range
creation.  Exercise the case without depending on allocator failures or
timing: let xas_nomem() reserve a node, then populate the relevant XArray
node through a separate operation before xas_create_range() retries.

Check that the retry succeeds and releases the unused spare node.

Link: https://lore.kernel.org/r/20251204142625.1763372-1-shardul.b@mpiricsoftware.com [1]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Shardul Bankar <shardul.b@mpiricsoftware.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: David Hildenbrand (ARM) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: <janak@mpiricsoftware.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>

 lib/test_xarray.c |   31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

--- a/lib/test_xarray.c~lib-test_xarray-check-unused-spare-node-after-range-creation
+++ a/lib/test_xarray.c
@@ -1834,6 +1834,34 @@ static noinline void check_create_range_
 	xa_destroy(xa);
 }
 
+#ifdef CONFIG_XARRAY_MULTI
+static noinline void check_create_range_spare(struct xarray *xa)
+{
+	XA_STATE_ORDER(xas, xa, 0, XA_CHUNK_SHIFT);
+	bool spare_left;
+
+	XA_BUG_ON(xa, !xa_empty(xa));
+
+	/* Model a failed allocation followed by a successful xas_nomem(). */
+	xas_set_err(&xas, -ENOMEM);
+	XA_BUG_ON(xa, !xas_nomem(&xas, GFP_KERNEL));
+
+	/* Model another user populating the tree before the retry. */
+	xa_insert_index(xa, 0);
+	xa_insert_index(xa, 1);
+
+	xas_lock(&xas);
+	xas_create_range(&xas);
+	xas_unlock(&xas);
+
+	XA_BUG_ON(xa, xas_error(&xas));
+	spare_left = xas.xa_alloc != NULL;
+	xas_destroy(&xas);
+	XA_BUG_ON(xa, spare_left);
+	xa_destroy(xa);
+}
+#endif
+
 static noinline void check_create_range(struct xarray *xa)
 {
 	unsigned int order;
@@ -1867,6 +1895,9 @@ static noinline void check_create_range(
 	}
 
 	check_create_range_3();
+#ifdef CONFIG_XARRAY_MULTI
+	check_create_range_spare(xa);
+#endif
 }
 
 static noinline void __check_store_range(struct xarray *xa, unsigned long first,
_

