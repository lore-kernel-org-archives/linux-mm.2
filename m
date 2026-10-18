Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F107FCCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 12:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C29616B008C; Sun, 18 Oct 2026 08:27:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD9E56B0095; Sun, 18 Oct 2026 08:27:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC81C6B0096; Sun, 18 Oct 2026 08:27:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 83C676B008C
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 08:27:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E18BA12051A
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 12:27:47 +0000 (UTC)
X-FDA: 85335673374.15.1F33A9B
Received: from mx.itxnorge.no (itx-kvm-14.itxnorge.no [91.189.121.228])
	by imf21.hostedemail.com (Postfix) with ESMTP id 601DB1C0004
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 12:27:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=kKTmP4PH;
	spf=pass (imf21.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792326466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pwubdLAMCHJgPaLvh4kT6SepriqCMUENEcVtSCeajdM=;
	b=TEGXmWsE4AKPePdsXx79f48H9DvEztacet/hE6NLBslc66tjH3HhYQzw7YWTVYdhmaJsuz
	m+FgwZJ4qAP/agXpsnVnqQIJnMyAbRK4Ldwfr3Mil5b8yCz7wT0+tFi9xN5jWe2F3iuHGr
	Gh83itLzYS/XFYUbyKP/82wPpTUMjqE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792326466;
	b=FUVNzCJ53hoglJ2WfQre6IGXR8Vj9SW6NC6g1XHv8+tEHM3fgUKB8b4XyLjeMO4UE5BZs+
	K+pxsJcAYCMbNpCYCcSBEEz85rGAsx8kbBstSkiF5pbpZuEhtHTf/tp7+AwF+1r2/qpxEg
	EDAOlCz0fTGe8BI35/ekdW26V8MtdCQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=itx.no header.s=mx.itx.no header.b=kKTmP4PH;
	spf=pass (imf21.hostedemail.com: domain of stian@itx.no designates 91.189.121.228 as permitted sender) smtp.mailfrom=stian@itx.no;
	dmarc=pass (policy=reject) header.from=itx.no
From: Stian Halseth <stian@itx.no>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=itx.no; s=mx.itx.no;
	t=1792326465;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pwubdLAMCHJgPaLvh4kT6SepriqCMUENEcVtSCeajdM=;
	b=kKTmP4PHBl6CsmbdA2yRaFZ4+/bgvzMOj+4PdXDahnortKYSQAzKSJmZVGm5Q3DJcOjdJC
	yZ1D2fvx4+pDowUiGnqPod7Yr+dKrlqnDmHizuwaiRY9ZTRzLXf4IvBx61JbTB8juUOMuu
	acMvRY6mz/qfaVphD/2VcKDnILenN84=
To: Andreas Larsson <andreas@gaisler.com>,
	"David S . Miller" <davem@davemloft.net>
Cc: Kees Cook <kees@kernel.org>,
	Michel Lespinasse <michel@lespinasse.org>,
	Jan Engelhardt <jengelh@inai.de>,
	sparclinux@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Stian Halseth <stian@itx.no>,
	stable@vger.kernel.org
Subject: [PATCH v2 1/3] sparc64: Start bottom-up mmap searches at mm->mmap_base
Date: Sun, 18 Oct 2026 14:27:32 +0200
Message-ID: <20261018122734.2594904-2-stian@itx.no>
In-Reply-To: <20261018122734.2594904-1-stian@itx.no>
References: <20261018122734.2594904-1-stian@itx.no>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: x56euqa8wb5dhobg1stczrxi6sopnzq8
X-Rspam-User: 
X-Rspamd-Queue-Id: 601DB1C0004
X-Rspamd-Server: rspam10
X-HE-Tag: 1792326466-433161
X-HE-Meta: U2FsdGVkX184ONvthykca6nzWkloFjHerz0Qn4L6nzcf9s3HyQMtINh0dmSt+p2babukeQ7+pBvH/sETQjONthTA8JPLjCNN2YXQFhR5xdkm8yHy5Lp/njmPN3WjpoMYAy3EOcMgHyHWvV7m86H9EXlUFXGlz1ySh4/22xt+bFVwSQbSnCasZTadYgPgS7u/T56IWrtLzLtzXWtZZh9bsB91vKRquggspJ2S6HGqJJPH2w6NENcb0E0r9RWly9QANJaGvosN+KAZIWiRneG9apX1mjvS72+8Z90LqETypRwTDJxsggxhOt4pmdHfLZc4xEEAo9kDiYZUOb/NjeCXMFxc2AFwP4n+99iAt9BgT4TivtfjAdsZ6R9YUtQil0tOkKj72pHIYobxKJXq1/6NQnP3oMLcHGqKdB4ogUbuPOp8qIWBxcqdw5vIBLKt2iz28XSj+XSoft6oO2JNLTK9xb/HpegpUuuANONuHWLamXI8VPbTsjl5/5xW1iuj5EhR8ndD4Q1n2jZkiq6MdKVhS5dXGThe80QHQKNTPA81tem5FVzSYD5hg5GNbTIEtyVjlTZ49H2tB+/56fzHEASGaPGa2rJe6UGnH2IU8vhjrPakUFVzk0185ZzEZcvhTXlMhdhmfKRkYMjXMlqN6NI36BLY6Mlnurd3eqJJwFm42+YsQJAO4s+Y9TQdm+OJT0wH6p4uaBLjq7ES1pahreLegoReqV4ck8E54GlefBjGcHLCdju2nbve0MQDblLhm138Y4P6MbUpBWIbduNIR7gOMMvTLAOZA9mpdaPxGnp3Mg+IqalBkJr+5HvL0+G5wafUVKkg+4V5YRZMvHJgW/tboXqEKtffFP6VK2UfVf+B+z2a9vuqGZM021LUhp7kF3+oBZJU3xCdu59Su8Q7ar1o86Ag+aZ387N79vQiiQk75G7QTWAlx3mFxtxYLGcZzs2CkaBOMc4VqcCzNXfLfAJ
 nmPTFzvu
 xSyCbcC7joPXlsDvpDINyr6krBKIyuahW9+gDR0fO61KYmBp0S0p6lZMQ5mRsWD+hsyQgflMMcYLib9MzWxZn+xiqA86hcVYCpUkL5CRzQtMXnHzWTpZv5eTyF2jyNGwa7tjoP74X8OiWoBj8CjIExAy0AQEETB+1/j9+NFTyLcbzcxEipIXYFiqsh2y6aHxoxUJhydJT4t+HXe+fT5S7/oCb8+D2j46ZF3VA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

arch_pick_mmap_layout() randomizes mm->mmap_base for the bottom-up
layout, which every 64-bit task uses, but arch_get_unmapped_area()
starts its search at TASK_UNMAPPED_BASE and never looks at it. Shared
libraries and anonymous mappings of 64-bit tasks therefore land at the
same address on every run; only the stack is randomized.

Before the conversion to vm_unmapped_area() the search started at
mm->free_area_cache, which binfmt_elf set to mm->mmap_base. Use
mm->mmap_base as the low limit again, as generic_get_unmapped_area()
does.

Fixes: bb64f55019c7 ("mm: use vm_unmapped_area() on sparc64 architecture")
Link: https://github.com/sparclinux/issues/issues/119
Cc: stable@vger.kernel.org
Tested-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: Stian Halseth <stian@itx.no>
---
 arch/sparc/kernel/sys_sparc_64.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/sys_sparc_64.c b/arch/sparc/kernel/sys_sparc_64.c
index ecefcffcf7b10..087595fa43081 100644
--- a/arch/sparc/kernel/sys_sparc_64.c
+++ b/arch/sparc/kernel/sys_sparc_64.c
@@ -142,7 +142,7 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsi
 	}
 
 	info.length = len;
-	info.low_limit = TASK_UNMAPPED_BASE;
+	info.low_limit = mm->mmap_base;
 	info.high_limit = min(task_size, VA_EXCLUDE_START);
 	info.align_mask = get_align_mask(filp, flags);
 	if (!file_hugepage)
@@ -151,7 +151,7 @@ unsigned long arch_get_unmapped_area(struct file *filp, unsigned long addr, unsi
 
 	if ((addr & ~PAGE_MASK) && task_size > VA_EXCLUDE_END) {
 		VM_BUG_ON(addr != -ENOMEM);
-		info.low_limit = VA_EXCLUDE_END;
+		info.low_limit = max(mm->mmap_base, VA_EXCLUDE_END);
 		info.high_limit = task_size;
 		addr = vm_unmapped_area(&info);
 	}
-- 
2.43.0


