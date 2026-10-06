Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B70BDCA5FED
	for <linux-mm@archiver.kernel.org>; Tue,  6 Oct 2026 09:20:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5D836B0096; Tue,  6 Oct 2026 05:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C31E56B009E; Tue,  6 Oct 2026 05:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADC6E6B0092; Tue,  6 Oct 2026 05:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85BD56B0092
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 05:20:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 084E71C3858
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:20:39 +0000 (UTC)
X-FDA: 85291656198.10.50E8B61
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 502AD20003
	for <linux-mm@kvack.org>; Tue,  6 Oct 2026 09:20:37 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mRw+ahTZ;
	spf=pass (imf31.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791278437;
	b=1DyfMa4gQmP1NdmRWoFksF65umtVA8wkYyJndb9zpGD7K0B27U+d/2qEy7JTJl6lPoUNrE
	T8HNkTHBROb2JQjrgZ/RQdrybx1AtBsZhBTtcbRzjyiQxaSqnsOLpLRtUqccNwIzZICJ3d
	ktDrKnVn08IGC+rtf5/YfzyRr+/712I=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mRw+ahTZ;
	spf=pass (imf31.hostedemail.com: domain of kees@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kees@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791278437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g22MNOcpZQJw77B5VL8DpAGxBVPLTKqDTmR4tL3lAoM=;
	b=nO/ywm3LZQF9KCC1Y3ojK4rScSAEJMLvPxaRtmN96mFn2Bgs8kCoT0AO3D6QcIwx5XnPSP
	6H4jaKHiDPNNoto/h7DTwHfE1NlzXJ+RjxMpVJKPN9Uqdxu4HEL9einEY0+SKaLWuSNbDj
	g/qm+G7JnabxqIG4109XUO5KPfRbvHU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 515F7401AB;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0B31F000FF;
	Tue,  6 Oct 2026 09:20:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791278436;
	bh=g22MNOcpZQJw77B5VL8DpAGxBVPLTKqDTmR4tL3lAoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mRw+ahTZOj8L5wMO/OOKXOp+m9QqnvsM5QclJ2Og8BK0ZKjzb0r3QaToflZoWBxNj
	 0ixbDV7CTgQuAViLDZ4qn68GDlQR7JpowyAb6DtOK4EzhfVAluV9DP9BlRr/PQElkH
	 zxJ67wrI5jLV52zefbwDwhXtipAjVbGjHMoN1xgO9CrQdDoqAGnRhR+drQJKeZ+tVw
	 QGhwiATEhEcyDhZXGlkIMpe2LVhMXIk3vA6SCakgnwRaTzkOyj0gn59yJX2CAJfukr
	 O81wfm2M48KuWfEAtzri9Dtffd2vrW+77rTYkHwrXTTB7REMEoCCkTPzSoAuJ56DPE
	 JrH6B6Da/nM7A==
From: Kees Cook <kees@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>
Cc: Kees Cook <kees@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	Pedro Falcato <pfalcato@suse.de>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	linux-hardening@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH net-next v6 1/8] mm/slab: Mark the kmem_buckets_create() context as a Context: section
Date: Tue,  6 Oct 2026 02:20:27 -0700
Message-ID: <20261006092035.166776-1-kees@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261006092030.got.500-kees@kernel.org>
References: <20261006092030.got.500-kees@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1768; i=kees@kernel.org; h=from:subject; bh=qvVs6BUL6uU5DGS29fmp8uUzY+nuvwiJ5sJfljH/ZrI=; b=owGbwMvMwCVmps19z/KJym7G02pJDFlH9saLnhcKCTUMfdiWFjUn4/CmE+kh7qycc6MnSHyxt +4IqZndUcrCIMbFICumyBJk5x7n4vG2Pdx9riLMHFYmkCEMXJwCMBEeVUaGdQ5K/KGvzNR6r+7Y 8/n4Lqv8aD49Bp493sHLgjW3y2ydyfDP+tu/PTv4TTstL0+3SWt/GPaS68kPy/XVGl8PtFmFbOX kAwA=
X-Developer-Key: i=kees@kernel.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 502AD20003
X-Rspam-User: 
X-Stat-Signature: of5dcfo7799t1wp3r4nup1o6wk9z3ham
X-HE-Tag: 1791278437-93704
X-HE-Meta: U2FsdGVkX18p8ue8yTw5TNHGYHV8nI2VOaqazziYO3rfRxvBnN5jeS1grmyFqZzStpgvVavv79qDOhHu43cvzbZdtTSZky/e/Eq6TcAiYeUxzMzcAjMU+CaXsZO7dvUxkQxiN4xLOeqL7OTB7MAEyxdjJQ67Ec1w7ZsFmvvUBCnPfRJa+K3I37MHJ4faNzltUt9c+OIMAejRZpl4lgc+1+Xfv8I1eTro54ykTgxBVfhvTgGsC8BvFWcgFE8y19897penDYqiS5MwH1JD8oYbmp9nUvh+gBvubyHCRvxiygK2YM2Rzw/t1F+5Mb2hIcXoruj8wCK/ZbqtnrMgk8kSC6hDkbt/CIlSryycar/ocsg7rt0Ryh9V38UU4x+9XwApmRsg+fU8DrFtTLq1nPQY+EqhaVKukxhlj4eOxGsAldN9FMfcO/KWS10cGcJ0jPIODKmfO7q0Q75M2PsUzGCKQPdirWvLxU2YYzU/y3dpoy8lUWOWrtqRGTN6xB//R2rRBflpX48TrtlWTNB9OqN6TPhOLg8+1gfMSJWYKBs0tdE44Oedf6jzgHq5xcr4Z1uTBmuecaWPOfaxcedsQSBNzzcACcWurqQX/u21AUOg7qYcwDfgxRO70ldzGVdqqH9gSMZCL6PD6Ku370Ng6o44c/9YjGapcbYIbJ7n577uKUpO9mw4PMKYnj8MDpjI39LG1fhF7wBra9ZY+Ja2y1k15sqF7SV+8j6/f4nzHM6w6ZQenQIcQ74hFN7COgTs7hFRN3wyUgzRwXb4479plLk70enmtXBBGcYekkRCeyMQ3eZaTkf776v6BaN8Zt5gEx23nysTe6l2rd8iG83vCvKqK+uuOhB04D/LQKjQyKcjCxywO1IUGeeKLmL1H135c8kaTNjigJ1IgxwbozTmqqkSQd3uYxDLlTj2Xmm//Zq2/2pdOgwDI+cc051uB9polAU+k8W57d6Qg2a4h9oXHKe
 HYhwUJyO
 V1NTOkrrdJFRg5zVL5L6cWQvk1+uST4+8nHgDT2B54XvQoFm8uCzWLBGXHmMhb8Lyr92Y30rLbC0Vj6YTmc5vmbJwmU0e/5dfn1ZXjcMqWCQKxs1tvs1UHQPZROis+N/pj625T1lXS2txmMzE4otlK0WdnkmSM5EXgK+oQ+Rnpw2VxgXt4ssL1r7GemGjz0WnQakVe+AHhZLKvK2GZPGmHFwskUPBIO8RsHj4XNDNPRDZ+UT+sBLCQ4kl4BVQdknafUuxR37C440mFMSJHqLdNyV0zYoSbsHQ8+7f3vLQi7tXIDy8sU+xdCTqBktaPdtSnarxSn0/15crJwfFyukWpLebw7UP0EYECAIBmDlzRCWe4ijJp3GGJJAe07uC9ttkhtHZWuqYiOUqPGQ9+WR7HJXvYA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kmem_buckets_create() had the same sentence about calling context as
kmem_cache_create(), but lacked the "Context:" prefix, so kernel-doc
rendered in the body instead of as a "context" section.

Give it the missing prefix. Additionally fix the "a interrupt" typo
__kmem_cache_create_args() had.

Fixes: b32801d1255be ("mm/slab: Introduce kmem_buckets_create() and family")
Assisted-by: LLM
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Acked-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Kees Cook <kees@kernel.org>
---
 mm/slab_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index b19ba1b31484..270408ce5a9d 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -311,7 +311,7 @@ __kmem_cache_alias(const char *name, unsigned int size, slab_flags_t flags,
  * &SLAB_TYPESAFE_BY_RCU - Slab page (not individual objects) freeing delayed
  * by a grace period - see the full description before using.
  *
- * Context: Cannot be called within a interrupt, but can be interrupted.
+ * Context: Cannot be called within an interrupt, but can be interrupted.
  *
  * Return: a pointer to the cache on success, NULL on failure.
  */
@@ -422,7 +422,7 @@ static struct kmem_cache *kmem_buckets_cache __ro_after_init;
  *		to/from userspace.
  * @ctor: A constructor for the objects, run when new allocations are made.
  *
- * Cannot be called within an interrupt, but can be interrupted.
+ * Context: Cannot be called within an interrupt, but can be interrupted.
  *
  * Return: a pointer to the cache on success, NULL on failure. When
  * CONFIG_SLAB_BUCKETS is not enabled, ZERO_SIZE_PTR is returned, and
-- 
2.55.0


