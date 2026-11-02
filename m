Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 371E4606A324
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 08:27:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E4F26B05B9; Mon,  2 Nov 2026 03:27:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BC3E6B05BB; Mon,  2 Nov 2026 03:27:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FFC66B05B9; Mon,  2 Nov 2026 03:27:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D5B386B05B9
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 03:27:44 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3EDF8140BCF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:27:44 +0000 (UTC)
X-FDA: 85389500448.17.86B3A81
Received: from mail.loongson.cn (mail.loongson.cn [114.242.206.163])
	by imf29.hostedemail.com (Postfix) with ESMTP id 86E50120004
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 08:27:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793608062;
	b=w4joDuKRpzJ9gOLhJxnkHWgbvVBnMphlXV92iKPcX50L3BTjmAtakGhI3XPeuW8bLV7xvb
	Y27kNhF2h5VK84lUyYHE8Hp2Mig4svR/+7U0w6Y9PpfZMLsybhyhIaAngcxm+TqyIJ+X8k
	9u8mklG4KVaaDIB+gv08U0o9YjZQC7E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of yangtiezhu@loongson.cn designates 114.242.206.163 as permitted sender) smtp.mailfrom=yangtiezhu@loongson.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793608062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=8rzT69sai/1JVMZrPPxqbIhnSUltQ4xUL98H0qfUrjY=;
	b=2wVrbz02J3pukaStNPHWcY8QvouW4PXdzX4aXaIuIaGqUldAFe6SjBVjU53i4mOqHtLd2K
	K+sN9uN88lvXeCn32fp3uBeVB0ktQnJCEBSojO0450RcBMsmanec/25pW8Y4TYaKGDziqo
	yGHO7xOWI+PV+GL5LK1rqpGObNanmEA=
Received: from loongson.cn (unknown [123.138.236.242])
	by gateway (Coremail) with SMTP id _____8Axj9F0Sehqj3kbAA--.14271S3;
	Mon, 02 Nov 2026 16:27:32 +0800 (CST)
Received: from linux.localdomain (unknown [123.138.236.242])
	by front1 (Coremail) with SMTP id qMiowJBx5cxzSehqyc0xAA--.10726S2;
	Mon, 02 Nov 2026 16:27:31 +0800 (CST)
From: Tiezhu Yang <yangtiezhu@loongson.cn>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org,
	loongarch@lists.linux.dev,
	bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1] mm/slub: Genericize x86-specific cmpxchg16b comment
Date: Mon,  2 Nov 2026 16:27:30 +0800
Message-ID: <20261102082730.12430-1-yangtiezhu@loongson.cn>
X-Mailer: git-send-email 2.42.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qMiowJBx5cxzSehqyc0xAA--.10726S2
X-CM-SenderInfo: p1dqw3xlh2x3gn0dqz5rrqw2lrqou0/
X-Coremail-Antispam: 1Uk129KBj93XoW7ZF45uw4UCF4xKw4DKF1Dtwc_yoW8Aw48pa
	17A3yjqan8ur1I9a47Cw47u343Jay8KFW2k3yfCw13Zwn8Kw1fKF1xt3yFqF4rXrWfua1j
	qF1ktFWjvF4UAFcCm3ZEXasCq-sJn29KB7ZKAUJUUUU5529EdanIXcx71UUUUU7KY7ZEXa
	sCq-sGcSsGvfJ3Ic02F40EFcxC0VAKzVAqx4xG6I80ebIjqfuFe4nvWSU5nxnvy29KBjDU
	0xBIdaVrnRJUUUk2b4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k26cxKx2
	IYs7xG6rWj6s0DM7CIcVAFz4kK6r1Y6r17M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48v
	e4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Gr0_Xr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI
	0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVCY1x0267AK
	xVW8Jr0_Cr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l57IF6xkI12xvs2x26I8E6xACxx
	1l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1Y6r17McIj6I8E87Iv
	67AKxVW8JVWxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41l42xK82IYc2
	Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s02
	6x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0x
	vE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE
	42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6x
	kF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUcVc_UUUUU
X-Rspam-User: 
X-Rspamd-Queue-Id: 86E50120004
X-Stat-Signature: jp6dne97thxjankg7j7ncacysidu3ape
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793608061-995286
X-HE-Meta: U2FsdGVkX180weKSsboHCsWkbUGVxqBJwE1b03VYyUmnCVw7qkUoZqAOhYkoO9GS1dgnQLBbGFYBZrmNCOBWYUdZcYQrnIA6W5l+MHXW9zTTXzBh9Jhpfu4sJAmR84l47LXk3PVrDND0rAAA6j7CnJDYYo+eQgOZVx1i6YxenFX/iJDkXmJwZOuONIuQ9G9DqrF6X91dHQHc5EThWq1mursRehXnyKnIQrkeASGeEWhe2UP2p2bXalGq3tjfrY58xrT4E9qMlJXKxrylN/JpFQwFE+7ILZ/vpQRaZ2qm3/F8Lks2Grz+LH9+g9VKD0cTEbBgJlmS2maByCjUA7O69TIL7fE6wSGuldNWM1PawO6B0dYzgvRc6vSdC4PMBGRbQDzSOhxR0hnYn3AHL4t+cx+dDKSImSBG/x2If3/9XjQDPtim91nbtN0xYcANEhcjSrVeJKH/T5vdjSRsq3vVZwzSaPKjbcJwv5qIIbWyoIS22GMo2LQZRkFiftxuO6Z1HLXbKrAT46FWp/oTlOFwr4T7LnLnscnc/Q18W9yI20hNW03azdQYlan3HPXQzL9571XjexvzOv6zvuafdGaxtrQ0c8KApMYHDwC1KUmU2sll0Pap+VoNabYtctsbbyeR+Qxi+TG+ITHh3KdF3keQBTPsdDcdECx2wgWJ9EaenWT5sbvR1L1qMQZkpeT4YvnX4jz6SsEQ1ctciBezF+YUlsuI9750wR7xC0eWpjpOJ5uaeNzq8jJOioif9fPJg3qzom0ULrDpCj4ylSlRTX7tG7lGX4+GZNJPMTuzxO8rzr9mL7vaJQS8sijXpxRc3jl9FItDDeNaMEuYQJyLQRICrCwGrfjCTzEsBayYSz6impJ2EPZKaIGEmYcABTimyoErRrYn0dvj8AlMc0DB5KFjRX5r86mfjPy675xHO4rHs/Z1yh21TE288/RREe5IoYHse+ImRt7YJ9JaoRIjNG0
 b2VrlO84
 f2eFs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The kmalloc_nolock() infrastructure relies on slab caches with double-word
atomic cmpxchg capabilities (__CMPXCHG_DOUBLE). The current inline comment
in __kmalloc_nolock_noprof() uses 'cmpxchg16b' as the prerequisite hardware
capability.

However, "cmpxchg16b" is an x86-specific instruction mnemonic (CX16). On
modern architectures supported by the Linux kernel, this 128-bit atomic
primitive is satisfied by different hardware implementations:
  - arm64: satisfies it via LSE atomics ('casp' instruction)
  - s390: satisfies it via native 'cdsg' instruction
  - riscv: satisfies it via ZACAS extension ('amocas.q' instruction)
  - loongarch: satisfies it via SCQ extension (using an 'll.d'/'sc.q' loop)

Update the comment to refer to "128-bit atomic cmpxchg" to accurately
describe the cross-platform hardware invariant needed by the lockless
allocator, and to avoid misleading developers of non-x86 archs.

Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
---
 mm/slub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 45e077c7526c..216bc6b5d776 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5589,8 +5589,8 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
 	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
 		/*
 		 * kmalloc_nolock() is not supported on architectures that
-		 * don't implement cmpxchg16b and thus need slab_lock()
-		 * which could be preempted by a nmi.
+		 * don't implement 128-bit atomic cmpxchg and thus need
+		 * slab_lock() which could be preempted by a nmi.
 		 * But debug caches don't use that and only rely on
 		 * kmem_cache_node->list_lock, so kmalloc_nolock() can attempt
 		 * to allocate from debug caches by
-- 
2.42.0


