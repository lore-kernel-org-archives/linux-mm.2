Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 071DFCD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 13:30:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 403A16B008C; Thu, 28 May 2026 09:30:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DA826B0092; Thu, 28 May 2026 09:30:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F1476B0096; Thu, 28 May 2026 09:30:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22A8A6B008C
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:30:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BB25540828
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:30:26 +0000 (UTC)
X-FDA: 84816912852.27.96E854A
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf04.hostedemail.com (Postfix) with ESMTP id 0EC0340015
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:30:24 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cyDYzH4/";
	spf=pass (imf04.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779975025; a=rsa-sha256;
	cv=none;
	b=HYqaH7Vvtxt163zjZFukPks7rDMo4HDHMEV2pLTfkB2YdRQc7o+tgInFcOLiOWOUL6033t
	LLO+dGvcrxlY9AzorrXPvmLXZTmk9KjrhiOi2KSuvqLsrwfLlIgy/kse9r1HXD69N4IT4k
	7D98XoO9tuCbLcXD+tQ+u9Y5Y9iXaOc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="cyDYzH4/";
	spf=pass (imf04.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779975025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ymCDErMyx33t1ESuPWjnecWS9by/6Siz6vuFexERi1I=;
	b=rud29sHLgp8ZVC1gGlWmRVQS8Jy0agckEZHSBZN2WKWMOtQQkF5eQ9dyELkm7xF2x0e9np
	WmxYoVvH3mkgEmbly6PRKrCp1LYQhJjsgilj9Nijc5g7p/D6YM5cZZcu9PMA8yNp3QO2U4
	ZkR7bjNdREnNhuHxlKxON4Q9NAU++yI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779975023;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ymCDErMyx33t1ESuPWjnecWS9by/6Siz6vuFexERi1I=;
	b=cyDYzH4/+ZT8vA7JAhmm8qbgu/lvOEBFg9dhu1qduEUxh1Hrjxpsxk8yoPy22H3wD+Y6Ib
	sqbb3EhkhGuIyldt0iTGWDTkvmKk8MMTvjyDKA3LtzB2hJbLASAdZO3KtAB3tpEqr25KfK
	jyQkDK4jNvpteFI7zeUAyu9Vktw0iyk=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	akpm@linux-foundation.org
Cc: mhocko@suse.com,
	vbabka@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	muchun.song@linux.dev,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH 1/2] mm/percpu: Preserve NOFS/NOIO scope during chunk create and populate
Date: Thu, 28 May 2026 21:29:16 +0800
Message-ID: <20260528132917.81123-2-kaitao.cheng@linux.dev>
In-Reply-To: <20260528132917.81123-1-kaitao.cheng@linux.dev>
References: <20260528132917.81123-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0EC0340015
X-Stat-Signature: us6phzi4zji7gxtzm5ppqibxcyrad6r7
X-HE-Tag: 1779975024-503
X-HE-Meta: U2FsdGVkX186wrJeCZI/kJ7hqyjFmd0OrSyXMOuIYx2QRX7vwR4xceLL02Ow3mL7jT9+YEERi+XvYqh2vp1hE/R0cQvqQSo4yUNMoLHAMcJbWuWQR0vuTJRb4aBU7dFMJkbev8rW5ce3mswp++elEwSGXhlA/ax/E/UfwKlFD44OEdyXMeF5TVXG/uY6SJlSu0VyLTOMINp/GSNvDG9+p2PuKUQwEjZDjtbcH1h31BgaLsNtL9JLiJJjOL3CJGO6t44gDRyE5xuJBer4OB29e5XfKSkD54hkpdZgUmeG8+JRjYFCoKu0NlI0IFmn0+hA1VHXy5AxOtov21tIIOSMiCEZ5bendvq9yajXq3YMF6z9lud9Z7wbYLDF1V9TTEmlx6LExLEUXwAKNDGLduk87LijTdwJwV5FQOjdphkFBPcI+W9g7xLeFcgyhnFVrr1z02NDzQHpfBVnjqFdn62xKJpNcg31Pkh+KoZd2JPp8J5V/YOGYZIwXf9xE1dJJ8ZZSaWuvDrF5elsg1v5QoqcxmotLJfN1MdUuxiGebY6sUi+04z5yN759xpafL5y3oKSD1cfKt8C8jaJQFu/aKpeqLgLrtp47vdW7MZdtjzsLQ4csc9B5XIfKtcvpjpB33TFUPlsZPMMzmFavWyGFgyhzW0qJP6p/734A9+HR2mblPK2dhsmQ1rGJudWpSvYZB0p4erseTHME1bOIJN2OBuWnDqF5YIb2zf67j0cemMnJPzpPycMQyTfJQfQ0vx5nHULH0wz2QQS+FkfXSPrzFkfojbJ7D4pxG8PtsRiXKBY8qTglx02rzqf7TlVx70u6wDptTqiUtGYxhYZrkQDHOpboIhYdAL69bTIz+P1E1hlnRaZ5jA5S6ma8jz2KQ9kBRXLAhlVgPV9WlMJpg9hdCLz+5crBE/WOh8E9uejoKoXPka7gOsc7tmaYWF3dkNPU2+sbQfofKRdMlnbTPBhk8M
 kEKLADbj
 G49OQVlsUSUlSAjzygJdheX8Nh+92JGq0/uoGsVfDGk9hzIuhbVHTkKL7UZHWI7g4eQzJ5MtzJ051qoEolI1uCgcSaRpWIrwl+7m0/goeew/HgJ1FsmsnLWRX83hx3U1pjLkYP9X1sjLFbjkh8dtHaw7sSYhfEYCon8/SF/CwIz0Z8xzHvXhIxtOtJ/coNfi7ZG5vncPYA3zjSRba/ytX5D5xGwguA2I9wrloZpllczsFP7A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

pcpu_alloc_noprof() derives pcpu_gfp from the caller supplied GFP mask and
passes it to the backing percpu allocators. This preserves GFP_NOFS and
GFP_NOIO for pcpu_alloc_pages() and for the initial pcpu_chunk allocation.

However, the chunk creation and population slow paths also call helpers
which do not take a GFP mask and perform internal allocations with
GFP_KERNEL. For example, pcpu_create_chunk() calls pcpu_get_vm_areas(),
and population can allocate temporary metadata or page tables while mapping
backing pages. As a result, a caller which explicitly uses GFP_NOFS or
GFP_NOIO can still enter FS or IO reclaim while creating or populating a
percpu chunk.

This is problematic for callers which use GFP_NOFS or GFP_NOIO because
they are already holding filesystem or IO-path locks. If free chunks are
exhausted, the percpu allocation can take pcpu_alloc_mutex and then enter
unconstrained reclaim from these internal allocations, defeating the
caller's allocation context and potentially recreating reclaim lock
dependencies.

Wrap chunk creation and population in a scoped NOIO or NOFS context when
pcpu_gfp has the corresponding constraints. Leave ordinary GFP_KERNEL
allocations unchanged so they retain full reclaim capability.

Fixes: 9a5b183941b5 ("mm, percpu: do not consider sleepable allocations atomic")
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/percpu.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/mm/percpu.c b/mm/percpu.c
index 71a85d7245c7..1bb38467390b 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1778,6 +1778,23 @@ static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t s
 }
 #endif
 
+static unsigned int pcpu_memalloc_scope_save(gfp_t gfp)
+{
+	if (!(gfp & __GFP_IO))
+		return memalloc_noio_save();
+	if (!(gfp & __GFP_FS))
+		return memalloc_nofs_save();
+	return 0;
+}
+
+static void pcpu_memalloc_scope_restore(gfp_t gfp, unsigned int flags)
+{
+	if (!(gfp & __GFP_IO))
+		memalloc_noio_restore(flags);
+	else if (!(gfp & __GFP_FS))
+		memalloc_nofs_restore(flags);
+}
+
 /**
  * pcpu_alloc - the percpu allocator
  * @size: size of area to allocate in bytes
@@ -1901,7 +1918,12 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 
 	/* No space left.  Create a new chunk. */
 	if (list_empty(&pcpu_chunk_lists[pcpu_free_slot])) {
+		unsigned int pcpu_scope;
+
+		pcpu_scope = pcpu_memalloc_scope_save(pcpu_gfp);
 		chunk = pcpu_create_chunk(pcpu_gfp);
+		pcpu_memalloc_scope_restore(pcpu_gfp, pcpu_scope);
+
 		if (!chunk) {
 			err = "failed to allocate new chunk";
 			goto fail;
@@ -1931,9 +1953,13 @@ void __percpu *pcpu_alloc_noprof(size_t size, size_t align, bool reserved,
 		page_end = PFN_UP(off + size);
 
 		for_each_clear_bitrange_from(rs, re, chunk->populated, page_end) {
+			unsigned int pcpu_scope;
+
 			WARN_ON(chunk->immutable);
 
+			pcpu_scope = pcpu_memalloc_scope_save(pcpu_gfp);
 			ret = pcpu_populate_chunk(chunk, rs, re, pcpu_gfp);
+			pcpu_memalloc_scope_restore(pcpu_gfp, pcpu_scope);
 
 			spin_lock_irqsave(&pcpu_lock, flags);
 			if (ret) {
-- 
2.50.1 (Apple Git-155)


