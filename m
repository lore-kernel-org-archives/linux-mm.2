Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34D7ECCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 03:42:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA0288E0008; Wed,  5 Nov 2025 22:42:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2A308E0002; Wed,  5 Nov 2025 22:42:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF1078E0008; Wed,  5 Nov 2025 22:42:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B05DF8E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 22:42:02 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 640C912B9FF
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:42:02 +0000 (UTC)
X-FDA: 84078783684.10.348908F
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf22.hostedemail.com (Postfix) with ESMTP id 99056C000C
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 03:42:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cMpTVqX0;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762400520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=2xo0Q0yezjPat4Uoc+uZK449naBLb4C/0XjyKxCdNbs=;
	b=lHJ0zQKRki5/NJDVKmc4bhzjvZwMWBlzFz+NkFn5VP1aOXVrTvGNfRfQinCvA6LVzerd+J
	ZB21KqP28/IwJgKL37v4hVo65tKldbd4BgS3LzioNkH1jX+Lt/r4gOuNyIWH0vEFwtvwAB
	K5r6uc1mhy8GIyCtiM2hMA97B0Ayawc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762400520; a=rsa-sha256;
	cv=none;
	b=d0xpuQYNwwZG535lsQyfZwUmX9NJceh5wCywZDRqKjt1G2nmoQDhVH7jhePxp0waN5k5Ba
	KH6cHdc6zTyJxJO7vX4Qok5i3PArelaYKYMyrhoZrqZSjuWgZl9rhaxkjAbZGRQcqGT5jh
	uDtXI8H1+mMz0dJCGT3R72+Myp59cWc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=cMpTVqX0;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b5a8184144dso69034866b.1
        for <linux-mm@kvack.org>; Wed, 05 Nov 2025 19:42:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762400519; x=1763005319; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=2xo0Q0yezjPat4Uoc+uZK449naBLb4C/0XjyKxCdNbs=;
        b=cMpTVqX0sZOi8UTKBBaqH/sbyIaOecOwijVEj5qg3V7MFUBlUTpOjvuMQW6WOrpZWS
         CwAbeWXnauNdjhI1nMzcu1lfQIaHBbXwFgSg7yxBSM+zMJywD0e7mD2kvEdv3CePmncR
         CFbVPd1yF7sX0VvMurzeNgu+qP99jK/vHBXsPNaYu0heL5Jwe3lv1ySG+A+sWERSxqK8
         n3EYcRvKixw9cptQoSMYxBV7Jl3GbD3ZHB5g2lp5gTSWdBfd9DS6+phFcw+JEts25SIf
         vc5kqvOYXP2LuyTisdKTjdQEWlUtF04hYbppyIXjjoSfEdnWJHprS8608RKnMWgcEPyz
         Zg6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762400519; x=1763005319;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2xo0Q0yezjPat4Uoc+uZK449naBLb4C/0XjyKxCdNbs=;
        b=Zz1xiHqV4njxIatLqhQOxGUbrty822/N/i0O42F19XHPqONZDkSrr74CIbHM0Ar8vk
         J1JVWlc+Njd1eIyAmAZwz4Wqt+9mAFs3rzPy5dYhlK/+me6uA4oiI3Bghvx835oCLh11
         3J2bTDxdyk4uTVgeApfhub3JONq3uKza2yVpcwoTwCU3IX4rGDLLM7czGrKXbraSdk4k
         2G+S83GKUazjr6UMj0NwiY9bFlT1wOkd3XRbGhhVrvgkyppUF/odbH4MFCsJoKTNt7OU
         ppRXCz3LeSr7aVloM6eyYkWuEOcHHD8eVT+XnSo/amB/W9jABtLA3AcktA3MAB5DLV6I
         p8oQ==
X-Gm-Message-State: AOJu0Yw1QdG8Jsl5TURU9ejdbpaWYYx4RJfY/Yknn342+jxX2V85rUWE
	e+zWvwVJsWEP38X6jyVOdJ7KmdP79vma8nCkE4gR0i1ppbtcgsaTZC4V
X-Gm-Gg: ASbGncvFOMu1IVY9yeRsef/Sb0XCsaqxtJyQ4koflfnwadopnX2GlRktg0y/XcH5qCl
	2Rff3f7+b5Nb6Yt9RFa2XKagXbXvDKg80zKL8sOEw+KEUcR+fMvwdNIRQnU6Vq5SHkUI/gqyact
	Hl7DySDy41hxREXh2agoYxOu+rxM3MwANMaWNyKrS1e1KaiYKr3FkdW6IylQHMQKt9qn84lJCYB
	NXLwHpSAizV9u5VK2j0IhYRfu4FkQMkwSA7G5vDUE0aPLQmpLYWiPJfZA4dGbObW7TMx3xuuQIw
	a/5Qm4tXKeNknIkPpKxa62EI5ty8T3ZarJLo0l7FKhBKnIldwTa/lAEzKv7ZwWqgs+bsEMI3pFp
	Bjw6RKKadGyRe6ZJ6nNvfNZF8q43+Rb+DBI6Goh0jIaxauSQPmq9P9O3Kve0ytq+fE9g3PY4mel
	E=
X-Google-Smtp-Source: AGHT+IH2u2sTKyOQKIUfpU3dW4aZmA1fwsw7OzdpWyWFykYoOnMNxQAzZOD1IzdiA3/1IW1k8o9KMQ==
X-Received: by 2002:a17:907:2da1:b0:b6d:5e64:c36b with SMTP id a640c23a62f3a-b72652c0099mr540073766b.29.1762400518951;
        Wed, 05 Nov 2025 19:41:58 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b72896c8e29sm108630466b.74.2025.11.05.19.41.58
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 05 Nov 2025 19:41:58 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v3 1/2] mm/huge_memory: introduce enum split_type for clarity
Date: Thu,  6 Nov 2025 03:41:54 +0000
Message-Id: <20251106034155.21398-2-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251106034155.21398-1-richard.weiyang@gmail.com>
References: <20251106034155.21398-1-richard.weiyang@gmail.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 99056C000C
X-Stat-Signature: pi437z5unnuzbw68a9eg6xrtnnoswkiw
X-HE-Tag: 1762400520-92888
X-HE-Meta: U2FsdGVkX19kR+b20VxMGXR7/k7/HSx1trGm0Isg16SOPvhOug82AOsa0mdDi2IU0Oam0nJVu/QxO6O9jK5NKMxemxq9TArskbazaNFcIQLp44II0193qLyoZhiiU4ZpIbNrYcs2IHZazVa7gQhocmlYrM2w2jGDiZYIzG1bRlNE0gm89si/fLeuamk0k2jIniVBGGpWWJoii3XkCd/rUkZWGsbWSiwY6X3J9Fkx3mgrHhbpQj4uHqlRi79WC4mXc8tc3pI148uFTSv8iH9/2kst3xucDGuga+38A4sWAiaMPi318XGKpWb0A+VMEO6D/HmoB8rmxsFjW3PsqzLQtJcQQecKtiehiLEnGb8YLMJ+Xwq/2824jRMQ19mY+JL9ZAvalKB6MdhNgliAQ5TrsF4SbwHM3rnJfGOKGBopoTzpWxLiScdZGQrwlZVFm9rxgFAnkWnjAw+1qtL7B6wd7LHlGVBkSa5bT5yshvP22Arpciy5Qh62sO33zxoNiFvuZfHpxwKz+RCSDvb+vJSTJKBylKahPaA9jZKksXIPttOX+rLYllCFmWzlxK2HhMWQluHjSlseOf3O7PzN2fZgjGs40b66DLQqSEAmuUNR9cbX8h8VVmSc+3iAolCcVXTmIIYaZkw7csXx8fPUGHHMtaH7giU0v8IMs3w1gaowIWQQFxgIUfkiueAhWteJ8tMz6Y+opeWDz66LKy3qaSoA/S8VIvlGFiFdYNAN1ZY1/GzTQqbsT9gq9yGoFvbjvC0BvdzZTm4O2uRaqc9laoXAoZPsjvY4fdHkrzAAwRER+ZWvsPJmRpdtUjPBogsfIGLZmRfJ7PRZN2AwADZ3zttRGtAI9cfLokAL5CHgoa5NMdba50LbfrN92hqhNlcwNpiKPm15o6tWyihg574BiVdp5+CwGLJGa7qpTpGn72AAmvkKDCb25sTi7BRT7CNXKOruwo71VHMDhUYgX1vC1Xx
 fumJ3oxG
 BGJmi0ySQMRCEZ/oFBACWezG7IdKaojqIGiaUZYM38f+eIo/3+grFn9/sH82CV+w9M6Ba3vxMe6gmrK/BIhXzT4e+kkGkyJSmPkVEqVhZJYVuQ0Fv6Lppk7rM9ZUghuAx7QZzMEj699fHZ1HKZwxa+XR8kwwbTGgr0xsytD9sYIDnQU/X7Y6Pp1DaudCNLmqY3oOk1eWGJVSnDc5A9Eicp3mLoE3UW8bIlCtiI5ol2jdwIiG6/5Ob1PpdRkFJ/tcpXigliBGAHVU7FYd9uSDBKC/QU+M/pQM7L1KDHBbztoC07wZn/4N/h/RXoIbaLcBGGfu0xSIs1CjdyUQnQV+8TOPTtOiCJEGkbjis4R/wJjudmsyp4Te71m+nAPoegSin1hiO0r/1PiNUsjCV7f+ZrTSvmTXAm7kSGsvh7xWDqhXJkIyywalapX3NTyUO3T33qoJbvGj9j52tkmOMBbK3aO3WOEbG4rafz62hASTHPscOCpzf8LZp1RtNQc431KfHocVGaLXRUHYlWwF0E66HCN/N243xCnEI3bKCcIzKt2VIUpL8/CT6K1mN7bxG7TX8nHsFdb9yal+O+GWZZCWrxykhRGfj7Bhnq4I8J8vJkm0aw+nIoBxRhd1X3g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We currently handle two distinct types of large folio splitting:
  * uniform split
  * non-uniform split

Differentiating between these types using a simple boolean variable is
not obvious and can harm code readability.

This commit introduces enum split_type to explicitly define these two
types. Replacing the existing boolean variable with this enumeration
significantly improves code clarity and expressiveness when dealing with
folio splitting logic.

No functional change is expected.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
---
 include/linux/huge_mm.h |  5 +++++
 mm/huge_memory.c        | 30 +++++++++++++++---------------
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index f381339842fa..9e96dbe2f246 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -364,6 +364,11 @@ unsigned long thp_get_unmapped_area_vmflags(struct file *filp, unsigned long add
 		unsigned long len, unsigned long pgoff, unsigned long flags,
 		vm_flags_t vm_flags);
 
+enum split_type {
+	SPLIT_TYPE_UNIFORM,
+	SPLIT_TYPE_NON_UNIFORM,
+};
+
 bool can_split_folio(struct folio *folio, int caller_pins, int *pextra_pins);
 int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 		unsigned int new_order, bool unmapped);
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5795c0b4c39c..659532199233 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3598,16 +3598,16 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
  *            will be split until its order becomes @new_order.
  * @xas: xa_state pointing to folio->mapping->i_pages and locked by caller
  * @mapping: @folio->mapping
- * @uniform_split: if the split is uniform or not (buddy allocator like split)
+ * @split_type: if the split is uniform or not (buddy allocator like split)
  *
  *
  * 1. uniform split: the given @folio into multiple @new_order small folios,
  *    where all small folios have the same order. This is done when
- *    uniform_split is true.
+ *    split_type is SPLIT_TYPE_UNIFORM.
  * 2. buddy allocator like (non-uniform) split: the given @folio is split into
  *    half and one of the half (containing the given page) is split into half
  *    until the given @folio's order becomes @new_order. This is done when
- *    uniform_split is false.
+ *    split_type is SPLIT_TYPE_NON_UNIFORM.
  *
  * The high level flow for these two methods are:
  * 1. uniform split: @xas is split with no expectation of failure and a single
@@ -3629,11 +3629,11 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
  */
 static int __split_unmapped_folio(struct folio *folio, int new_order,
 		struct page *split_at, struct xa_state *xas,
-		struct address_space *mapping, bool uniform_split)
+		struct address_space *mapping, enum split_type split_type)
 {
 	const bool is_anon = folio_test_anon(folio);
 	int old_order = folio_order(folio);
-	int start_order = uniform_split ? new_order : old_order - 1;
+	int start_order = split_type == SPLIT_TYPE_UNIFORM ? new_order : old_order - 1;
 	int split_order;
 
 	/*
@@ -3655,7 +3655,7 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 			 * irq is disabled to allocate enough memory, whereas
 			 * non-uniform split can handle ENOMEM.
 			 */
-			if (uniform_split)
+			if (split_type == SPLIT_TYPE_UNIFORM)
 				xas_split(xas, folio, old_order);
 			else {
 				xas_set_order(xas, folio->index, split_order);
@@ -3752,7 +3752,7 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
  * @split_at: a page within the new folio
  * @lock_at: a page within @folio to be left locked to caller
  * @list: after-split folios will be put on it if non NULL
- * @uniform_split: perform uniform split or not (non-uniform split)
+ * @split_type: perform uniform split or not (non-uniform split)
  * @unmapped: The pages are already unmapped, they are migration entries.
  *
  * It calls __split_unmapped_folio() to perform uniform and non-uniform split.
@@ -3769,7 +3769,7 @@ bool uniform_split_supported(struct folio *folio, unsigned int new_order,
  */
 static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct page *lock_at,
-		struct list_head *list, bool uniform_split, bool unmapped)
+		struct list_head *list, enum split_type split_type, bool unmapped)
 {
 	struct deferred_split *ds_queue;
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
@@ -3794,10 +3794,10 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (new_order >= old_order)
 		return -EINVAL;
 
-	if (uniform_split && !uniform_split_supported(folio, new_order, true))
+	if (split_type == SPLIT_TYPE_UNIFORM && !uniform_split_supported(folio, new_order, true))
 		return -EINVAL;
 
-	if (!uniform_split &&
+	if (split_type == SPLIT_TYPE_NON_UNIFORM &&
 	    !non_uniform_split_supported(folio, new_order, true))
 		return -EINVAL;
 
@@ -3859,7 +3859,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			goto out;
 		}
 
-		if (uniform_split) {
+		if (split_type == SPLIT_TYPE_UNIFORM) {
 			xas_set_order(&xas, folio->index, new_order);
 			xas_split_alloc(&xas, folio, old_order, gfp);
 			if (xas_error(&xas)) {
@@ -3973,7 +3973,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		lruvec = folio_lruvec_lock(folio);
 
 		ret = __split_unmapped_folio(folio, new_order, split_at, &xas,
-					     mapping, uniform_split);
+					     mapping, split_type);
 
 		/*
 		 * Unfreeze after-split folios and put them back to the right
@@ -4149,8 +4149,8 @@ int __split_huge_page_to_list_to_order(struct page *page, struct list_head *list
 {
 	struct folio *folio = page_folio(page);
 
-	return __folio_split(folio, new_order, &folio->page, page, list, true,
-				unmapped);
+	return __folio_split(folio, new_order, &folio->page, page, list,
+				SPLIT_TYPE_UNIFORM, unmapped);
 }
 
 /**
@@ -4181,7 +4181,7 @@ int folio_split(struct folio *folio, unsigned int new_order,
 		struct page *split_at, struct list_head *list)
 {
 	return __folio_split(folio, new_order, split_at, &folio->page, list,
-			false, false);
+				SPLIT_TYPE_NON_UNIFORM, false);
 }
 
 int min_order_for_split(struct folio *folio)
-- 
2.34.1


