Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2506BCD98F2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 16:31:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 066376B008C; Wed, 17 Jun 2026 12:31:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03E476B0092; Wed, 17 Jun 2026 12:31:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBD1D6B0093; Wed, 17 Jun 2026 12:31:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7D2C6B008C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:31:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E9108DD1F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:31:31 +0000 (UTC)
X-FDA: 84889945182.04.9647B69
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2A01D12000F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 16:31:28 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Io1nRl4G;
	spf=pass (imf29.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781713889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SC2CjG0tyBQTzB68y+c7c4kv0xX9wi+E9xbDTYwfOrw=;
	b=U2sKZt1NBZcTG1jaVQfCYvkCZJiGE2XJeWLlhTaFT7HfCv6m8uKtBtjYWwjPWf5ofsGLrD
	5/71Y1Or09wQ1swZF470TBYu6v5l1D24GHSk1Xd1az2NN5PDSq/QxgPjxKXHpzPupAum2o
	dUM+CDkbeUPn1CgjANAEYRgfBawYrLc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Io1nRl4G;
	spf=pass (imf29.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781713889;
	b=RjhbyBYophdwCMNf2yui6JW8xJ8f9QKXVZ3sdPKP5oe84nTg1AZXiDVrcymlranDCDU1fh
	4xtzHdaQQDYM1OUNEWUegpkMZzhnjj6pPzF3UvX+60J7NlmXuKfnThdR1lNBcmsI4Vef7k
	mE2+Z6XYeJ6lnhlEprc2GWTUjBhd7A8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=SC2CjG0tyBQTzB68y+c7c4kv0xX9wi+E9xbDTYwfOrw=; b=Io1nRl4GKWGEkviVg4PYxP+8Xh
	LXNMBLy7nu8iHIuLPQ0LAMgxHpfrt+wVsd98vTbzX/pmDOUV2N+52sUGkwfqvB+CVj53WdFjlItO1
	9n8TtThKb3wMCKbsozkalBko4c6zD03emBdp4ifanmq+z72W6NEpH84fwpAbFG9M5+7WYSpo182OH
	maXlypIWcCReEnHkWcNTtIeVVyX70J7zJOJofYI0Fvaf7KUiFV5X10RFgiVkjBhzqVY+hjWAkFlQc
	+uDSrf0cyLAN7+JkVS4bbYu1S0Eg9wyi3v6+xnYKGKF937lvyMYL9sFlPAOX9JQnOd0hpshq0hmFi
	ZWqp7ynQ==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wZtAl-000000003P8-3sVs;
	Wed, 17 Jun 2026 16:31:27 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	"Harry Yoo (Oracle)" <harry@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH v2] slab: recognize @GFP parameter as optional in kernel-doc
Date: Wed, 17 Jun 2026 09:31:25 -0700
Message-ID: <20260617163125.2716279-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2A01D12000F
X-Stat-Signature: 66otgioy5frmu98x6umcgq8h65zcfqd5
X-Rspam-User: 
X-HE-Tag: 1781713888-474169
X-HE-Meta: U2FsdGVkX1/Phs0PoDauLzaYbZ5TN0Fh4fLpc/u8Dekxovb81AbEHHmwxJqrEc0O8QQV+lifI83XfJ0B8N2FFP2N86U+we5sJNeM60zfKheCZWxfL446Yu9bx/RvSp6c8ULHp7/BVMhQqgg6QZ8HoJx0+pDFjJcArlpKOdrqKh4O6/Cyt/svMt+I0KJ+wYQOcWxYqkC10GcSni/eQULhqK3k6hYqIrw1sYfgbcdrK8tMpqhBFhPAJcohHeNDapWcMqTyu91b7zff7i/aF390Ev5vt2nDqPIEKNVln/yuJGzPFFnsQAQmgCMh0XCRgXjbPTc9FkSTfS6YX9RHLBjoWWjAACD8Gq+zpg9ibMzyHfA6Xij98+8vh2JKaZ+yXcHeHx3o8mizsrK+hJDjV3KhBfhAqJh7Zy/5DtqnxE2vKoZHhh6Mbprl9GYIySg8BU/s6Tu1mSYQ/ktKvaN7Ty5T2U+Ak9NoW54eStc2kJfz0aqC3h8Rtf05egqhDP0Y2VtbCoI1d7KYcZotWV+9n7QZ4ruQmav0ysS5KGdUlYE1spMa51p5eD+jG4qIy1F2HGVvlLgs5iNx2QT2r2lCy8JvfZUnShkslah5+ev4Nzr32TA6erSwS+/Pguy9Fn3ZlX+9MF1jWUhIWq8HzK104KKpqu1rMz+LLl/cVR/y/nSe6JoC+Z2Uk61yb/OSv5WBs98xBb/4WlusCqGmdaRu2ZN8p2Ip0IgHzUtzDHOrrHFOdy5xYJjtMal0vlUKvrF80FUHA992l6k24iEv/hB9q/LdIk7ImUZG5ExPoOZMMNEtlAWpScR+WvmRi640ngba/GrBuZTABLuGmjt5i5mVhrHAA0fOjWY9cGBamqra9kbZPiV1d+agkThYtZ0A4OYBXbx9ycmcBZsPtwiuOBwRwrNJTWoQ5uvMCfmb3Q+ENruIP4L/dgJ2R7aYEAf1Juhac1EE8LU32xVhVX1yXUo4inf
 yl1EeV8s
 mLQw/x96xmm9/Tv9BznAPiPNAwuLUM2FlqbmnaMkAXP5oeDSwC++5SmhMmjCQQ43xbswtu1P2ZD/Umr8YmlN4AURBuFrZYtJ7H9xfLia7Mx9CubMbcFDXmXPUPak8/wm89R4/y81fh967gnYW8gcONieuGYqq5NMu1OUIcmVBb33IhwyfN2+O/d2hfISFG4O36sel+fuPug8okSO2V3bzflfYHIro9S11ktSqVlfF6VJgktT8SFrOS/0fe6lQ6aMqHxSLAijpHGL3hSa4Sir2e68xo/9km8ObHNd2YvF1UitLZOe+ogAhG1Qu7QxdmYB4Xz6vcLMA2nZmxbaZkEMMS/j6DkgbRuOPA5MUjapSRj2qd1/P9Niwd3rIdVQaIkYhdveOaYpe2OQRqBrGkbCRtFVcO2gOqXQFfWk47iSc15v7S/4VMpViH/bEQkLJE+JF4SMm0Ge2bE0bCbZtB/UEMaLmZRGeme0WkdT6tlSajyIGMM/KUSjyelh5+w==
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
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
---
v2: add default value for GFP flags to the description (Harry)

Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: stable@vger.kernel.org
Cc: Kees Cook <kees@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>

 include/linux/slab.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20260615.orig/include/linux/slab.h
+++ linux-next-20260615/include/linux/slab.h
@@ -1094,7 +1094,7 @@ void *kmalloc_nolock(size_t size, gfp_t
 /**
  * kmalloc_obj - Allocate a single instance of the given type
  * @VAR_OR_TYPE: Variable or type to allocate.
- * @GFP: GFP flags for the allocation.
+ * @...: optional GFP flags for the allocation (GFP_KERNEL when not specified).
  *
  * Returns: newly allocated pointer to a @VAR_OR_TYPE on success, or NULL
  * on failure.
@@ -1106,7 +1106,7 @@ void *kmalloc_nolock(size_t size, gfp_t
  * kmalloc_objs - Allocate an array of the given type
  * @VAR_OR_TYPE: Variable or type to allocate an array of.
  * @COUNT: How many elements in the array.
- * @GFP: GFP flags for the allocation.
+ * @...: optional GFP flags for the allocation (GFP_KERNEL when not specified).
  *
  * Returns: newly allocated pointer to array of @VAR_OR_TYPE on success,
  * or NULL on failure.
@@ -1119,7 +1119,7 @@ void *kmalloc_nolock(size_t size, gfp_t
  * @VAR_OR_TYPE: Variable or type to allocate (with its flex array).
  * @FAM: The name of the flexible array member of the structure.
  * @COUNT: How many flexible array member elements are desired.
- * @GFP: GFP flags for the allocation.
+ * @...: optional GFP flags for the allocation (GFP_KERNEL when not specified).
  *
  * Returns: newly allocated pointer to @VAR_OR_TYPE on success, NULL on
  * failure. If @FAM has been annotated with __counted_by(), the allocation

