Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8DACC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:28:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E87D8E001C; Thu, 28 Aug 2025 08:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C0EC8E001A; Thu, 28 Aug 2025 08:28:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 262D18E001C; Thu, 28 Aug 2025 08:28:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12DF18E001A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:28:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC3B5B659E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:28:12 +0000 (UTC)
X-FDA: 83826093624.21.A0006E6
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf11.hostedemail.com (Postfix) with ESMTP id ECD3E40015
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:28:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZStxEUCu;
	spf=pass (imf11.hostedemail.com: domain of 3WUuwaAgKCPwnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3WUuwaAgKCPwnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756384091; a=rsa-sha256;
	cv=none;
	b=tNnYEVqwk7RIzgR3su3z0ePVgQwH8fNXP46VZ/ojysIugBnDcRp3+VytXYVIVz8zTFrZaP
	pj1Exrt36qvZt4prjpH7+rlO36wjP52JTS3RnRGsAc9/bKKcASfsq7cQOuEz8lJ3TbYsws
	6UawD8IwnBgA6VKGyX3oBa8FnqWY05c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ZStxEUCu;
	spf=pass (imf11.hostedemail.com: domain of 3WUuwaAgKCPwnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3WUuwaAgKCPwnegoqerfksskpi.gsqpmry1-qqozego.svk@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756384091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l7cTx8YnEK6PXjAxYIM2TxKBSe00LYvnBB3H2O1o/mY=;
	b=duuMpajhIwNPRlEU0yky2xxsHisPlrXqSp8xKvkwOkeJ9EJW9aVh4vlRB74/fyLFa5HZ60
	I6G0giQnNfge9z17IRJcCARVCv2ZfRgoKYfUp1miQ4IhMkcYgmSrG5MCUhw5s4d28HNx/s
	5Wrf6YbcK8FhQq49Dpj2aosoA0RAK3U=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-afcb72a8816so74948166b.0
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:28:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756384089; x=1756988889; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=l7cTx8YnEK6PXjAxYIM2TxKBSe00LYvnBB3H2O1o/mY=;
        b=ZStxEUCuQL44cncfJbwa7yPOEMHerUcQ8GjCSugTZVKKyJ0Sg1awoQ3z9rj42ODf3c
         S3D/2rBvyuvfhNpUZhbhP2IQ67vm940NC92/q/XYzdiWFzaOase/JQz+jLgQ4Pd/4a0i
         i9X4ZzBGlab9K5MzeybCWYnciZw8fWURmcJAe4yCCPt0rdiDOyoKk9UmUH0LKL0FeNBu
         PsAnmxdbBjYss+EFwjCzD/0l8OOowFXvE6zu/RYVMyhCIR5bB3p/PTQfTGY/kzDNWl5a
         hqkfa2EEerGSaDibz49Ym2kLsbjPcbt3JyO8+NbyXDfz6qV+UQ/a1yS1ZXIe3GQQXPlo
         CQsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756384089; x=1756988889;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l7cTx8YnEK6PXjAxYIM2TxKBSe00LYvnBB3H2O1o/mY=;
        b=CM3ASWkmX0kZE7ZYZLiBEWtw3CWulyVzgM1kdztc4xjMwzuRqtrhZr9squaqD6V8y2
         n7boBX/HEdHjaV0mA6HkFGLFNDtEryQXyst778Y2VQ+qvqkN/pQgNhj6yfs7GHNUy1a4
         gIxgw1GmMI3zd6q8ts0cRadWp4ybugZYsF8qQWdS2nwBN5o1eHvjnUikKrQfKVohZWc2
         jEs7EAlqTGPS38XMAbQtoh5UVoIsDF+5gJWBX5BQgy0RhPC1frrCjbXxSauFeigJNIYa
         b7siiMNyZ/I3AYWUapAiqvaMk5XCtBKsw1q1+bgLtY8koY59O6ahPXh1BsnGy1nyrdox
         o66A==
X-Forwarded-Encrypted: i=1; AJvYcCWZ2cZELh8px/w1MEwIuzpoRIWtdsvs2WjqydADDlX5I7bnfur+VFnajOAEH1lLdHzBq7WZT7Q4oQ==@kvack.org
X-Gm-Message-State: AOJu0YxlQ2yJb+okGrMeTyvpIeAgpHPNoUvzUf7/RD4ly2uZ2D9+bp5P
	egFIr9VCZwLccC/t8ceYmxpmOKXNuPO4CwEpbswtiKHrPzsyrezELelY6Gu5NpVNr+xr8e0hwhl
	HRTcffuAVrdbJHA==
X-Google-Smtp-Source: AGHT+IEjpL3mL9YVYzvlFjpNuB2q7yGo5muV6qRmjgMsPd3KcbfmlJV+kvknHo72hH9YYv52hL3iJ2LhDTES2w==
X-Received: from ejcvj16.prod.google.com ([2002:a17:907:d490:b0:afe:af3c:d8b])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:7e9c:b0:af9:8c1f:b290 with SMTP id a640c23a62f3a-afe28f6a866mr1820910266b.29.1756384089249;
 Thu, 28 Aug 2025 05:28:09 -0700 (PDT)
Date: Thu, 28 Aug 2025 12:28:01 +0000
In-Reply-To: <20250828-b4-vma-no-atomic-h-v2-0-02d146a58ed2@google.com>
Mime-Version: 1.0
References: <20250828-b4-vma-no-atomic-h-v2-0-02d146a58ed2@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250828-b4-vma-no-atomic-h-v2-4-02d146a58ed2@google.com>
Subject: [PATCH v2 4/4] tools: testing: Use existing atomic.h for vma/maple tests
From: Brendan Jackman <jackmanb@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: ECD3E40015
X-Stat-Signature: 6stcbhrx3nmyo4extmweyxqkhtb5ur6g
X-Rspam-User: 
X-HE-Tag: 1756384090-659631
X-HE-Meta: U2FsdGVkX18yUtA4BSOa/AYzkao6/rvQGAtLJyCxM7Vjd3hVNVpbQvt+39WX+lq4E1oWdcoaIda51OcY8KWMc3xCFMFt6KQQdSiYJmCp3HgLFtlsWzQtp4mmMvDrdktWwj/6yB3l+YBaAT5jtOWgffaVEy8rQilMtMIIMVFuxusWrOYCiNpXq4yaBmTIBSpEXr60l2jv5swG2nFjgdlCmUrMdFJowH8MwFe7fLhr/fM2lrEO8M/jC1hOS6UW+TiT/NeZfi9oz/ejWwoT4CKd/FPgngGzKU8yPF38Fz6SVautOaKcysCGEwtvRIk/Tub+iZg5xBsufI8k3XvRu1qDqatlOq7WrxR45RF6+hXICPREBiMsEVTpH+tlXTyAG3ds70meW/5Qhshiai0iwLzpZEbD02i3i1APYqnHBLAETzoVbIVAI2twKoc6bAVMMk/39eSVKalbaIQBcuXfdc8gQXZZNMUo0AvWJ2lHIHMIRteqKwmktcqgxRhXyyUbxiVJINRFtLk7yh86e+7oN56y2lybsWy+b3yYzrIKf0HFhSA1X1RVD3nwBpV27vdnwYkYZUyVL38HZ6X0qG3n0mbvxT3Nd4j8VWIAMRlh9bV42cA+x73qWR6MH68F6swhEwvXbJRRYyXxGlW88NTkJMMsivvCcfjLtKgijNhCLkeRoGQVlZQBioayYHrUI34KJvDyleCGqx33naesXc942NCbnmHgQwCebGTs0yMHOaAlB8PuPlUr2EmaBKy/K+P9ZMBMVlPtZq65LTGykCHH0eCq3FSt3eoFtvyKtyFXD/HQDKAJDVsPz85GG3zbcsA1c9jXywVfspmXNkkKc40fsKSFIryWpV7l4UHGT43dV/Hb4l2zRkmmxQUpZXzJm8G+VXjNi/9fCiwxeOn6PJPAWjO8jyDFk0FfUhtQW3i+0XsWaJxIaBzFjAxrRe9QHqvxBU2PmSQI2h4CygwnTxutWVN
 XXCM2JKA
 gjvS6+Gsw7Wgxo+UrzhYIm8BnQJZ9hpD6XA/Gnm+UtAWBaaDEdoLylAGCu3VvGY/jJj/PDDGr/xYnvuHiYFxYG1T0T/K5inDYcesdbEICa8e1MaZ7T2nTazHYtc+uUs8DMp3jGd/OvtDbzMz3WIHCPQS4tg5Ke5FgpQfShjEwJ04pSO+YPI96W5P+ZOWASUoaefde8nXpZ5OfBfzFZeRgQ9Zseut4PJvIsVDVX3wQrWDqc9vMUzJxPmb4fBCflJifCvnkivM8jlEorjVuK1uB0g4QIzrdxfm5Q+iYy1WRSVnF6/ctjRS6i67JNx7mOSfcrYHmQtBmBGQiAwsyPWwMGceJrtECWicHW2Ak2JqkCLQ3Kf6055H1Zbg9nBhV0SWIgQ8JKPMooXDRre0aIEIKz/h5N40w8/hhEtoHCIL7dcv1nkb0/yqqMHgHDqOQcWMs8lgnEipfXxF9ENYxCbmcECRo5AkvR1QBJyIQjCaao37DZGcXfryePApJHK+VsQYWkO4sLXpf18iuX4PJe6eIiWQp4nyqn11Nx9n1BQE9OgZm59atMym7vkKLF3ZGPnL1vUn+UIZdb0DUKiw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The shared userspace logic used for unit-testing maple tree and VMA code
currently has its own replacements for atomics helpers. This is not
needed as the necessary APIs already have userspace implementations in
the tools tree. Switching over to that allows deleting a bit of code.

Note that the implementation is different; while the version being
deleted here is implemented using liburcu, the existing version in tools
uses either x86 asm or compiler builtins. It's assumed that both are
equally likely to be correct.

The tools tree's version of atomic_t is a struct type while the version
being deleted was just a typedef of an integer. This means it's no
longer valid to call __sync_bool_compare_and_swap() directly on it. One
option would be to just peek into the struct and call it on the field,
but it seems a little cleaner to just use the corresponding atomic.h
API whic has been added recently. Now the fake mapping_map_writable() is
copied from the real one.

Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 tools/testing/shared/linux/maple_tree.h |  6 ++----
 tools/testing/vma/linux/atomic.h        | 17 -----------------
 tools/testing/vma/vma_internal.h        | 12 +++---------
 3 files changed, 5 insertions(+), 30 deletions(-)

diff --git a/tools/testing/shared/linux/maple_tree.h b/tools/testing/shared/linux/maple_tree.h
index f67d47d32857cee296c2784da57825c9a31cd340..7d0fadef0f11624dbb110ad351aabdc79a19dcd2 100644
--- a/tools/testing/shared/linux/maple_tree.h
+++ b/tools/testing/shared/linux/maple_tree.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0+ */
-#define atomic_t int32_t
-#define atomic_inc(x) uatomic_inc(x)
-#define atomic_read(x) uatomic_read(x)
-#define atomic_set(x, y) uatomic_set(x, y)
+#include <linux/atomic.h>
+
 #define U8_MAX UCHAR_MAX
 #include "../../../../include/linux/maple_tree.h"
diff --git a/tools/testing/vma/linux/atomic.h b/tools/testing/vma/linux/atomic.h
deleted file mode 100644
index 788c597c4fdea7392307de93ff4459453b96179b..0000000000000000000000000000000000000000
--- a/tools/testing/vma/linux/atomic.h
+++ /dev/null
@@ -1,17 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0-or-later */
-
-#ifndef _LINUX_ATOMIC_H
-#define _LINUX_ATOMIC_H
-
-#define atomic_t int32_t
-#define atomic_inc(x) uatomic_inc(x)
-#define atomic_read(x) uatomic_read(x)
-#define atomic_set(x, y) uatomic_set(x, y)
-#define U8_MAX UCHAR_MAX
-
-#ifndef atomic_cmpxchg_relaxed
-#define  atomic_cmpxchg_relaxed		uatomic_cmpxchg
-#define  atomic_cmpxchg_release         uatomic_cmpxchg
-#endif /* atomic_cmpxchg_relaxed */
-
-#endif	/* _LINUX_ATOMIC_H */
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index f13354bf0a1e3839327da7927c4a7da1530a1693..437d2a1013be418c6d3e77534fa19b0ee1518c9b 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -21,6 +21,7 @@
 
 #include <stdlib.h>
 
+#include <linux/atomic.h>
 #include <linux/list.h>
 #include <linux/maple_tree.h>
 #include <linux/mm.h>
@@ -1398,15 +1399,8 @@ static inline bool map_deny_write_exec(unsigned long old, unsigned long new)
 
 static inline int mapping_map_writable(struct address_space *mapping)
 {
-	int c = atomic_read(&mapping->i_mmap_writable);
-
-	/* Derived from the raw_atomic_inc_unless_negative() implementation. */
-	do {
-		if (c < 0)
-			return -EPERM;
-	} while (!__sync_bool_compare_and_swap(&mapping->i_mmap_writable, c, c+1));
-
-	return 0;
+	return atomic_inc_unless_negative(&mapping->i_mmap_writable) ?
+		0 : -EPERM;
 }
 
 static inline unsigned long move_page_tables(struct pagetable_move_control *pmc)

-- 
2.50.1


