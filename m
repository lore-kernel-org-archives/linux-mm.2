Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2170EC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 12:03:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13D586B00B4; Wed, 16 Sep 2026 08:03:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A14F6B00B5; Wed, 16 Sep 2026 08:03:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED17E6B00B6; Wed, 16 Sep 2026 08:03:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C9C566B00B4
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 08:03:42 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43682C071C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:42 +0000 (UTC)
X-FDA: 85219491084.06.8493850
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8F22C160017
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 12:03:40 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VTt/GeWX";
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789560220;
	b=2/hND66GUscVMMcpHiyy5qECIPoFu+5xh9az/WYV6T9e0vD52Wcb6nv2tSgSQWUYgA+4fG
	npp091ARWKEAmr5NngW5eaL/8IqeB/vNS1tXXTrFV550yxrC9Zj/81Q2J7Ls2ra0vZ61qp
	FLIwAP5p+kX36AjOwXuqILqTZwDqXUA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="VTt/GeWX";
	spf=pass (imf08.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789560220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bAVP4y79lmB0kd35IBqs2N16e6jwAfNVV+NWInsx3B8=;
	b=iWVhSsL1oSdbiGfQvnWa6G9lUuWcmtTMc8ow0BO7OukBX+RJcHBCrquAud8h4POfmdXKrQ
	6x1DPzQDN56bQQv005BM+eq5j2lQykcBIM+g0dz4AeJNr+6aj+ItKLMCfBLlWa3AIR+4fQ
	OOCrbhoHlAfeLMe4647EB89UmYcCEgg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C7E9743DD8;
	Wed, 16 Sep 2026 12:03:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E9A1F00898;
	Wed, 16 Sep 2026 12:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789560219;
	bh=bAVP4y79lmB0kd35IBqs2N16e6jwAfNVV+NWInsx3B8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=VTt/GeWXn4wGm+DCH9mXXJSp7QVqNTomDqScLoOI0DSnG/syZbREC6+JqLFScDMts
	 w0tqRt3zKmQUkvgAzmklD+LuFal6jyosmohlkHuCLIIwGPHMto+6yiGEiM+wZ0d5Bs
	 kS78RGjv9qNlb9LPWA9+YwO+sr76FakD9GmyE/nwWwMjbQYgWFCiZBIvKfdu31jWE0
	 cXw3euA/GWEZYYbqPM+T9khBqET69p5CTMzKFY+CaA77mzvqGH5CeAxAIP3CoeB6pi
	 vgxPCE3YyPBxo0pZG+eg3tv8wr9u6wFz1JPGrlXWOEeWA5+Onijl07DWaSQwiWHwpE
	 bpX9bmZ/1YlHA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 16 Sep 2026 15:03:14 +0300
Subject: [PATCH v3 07/13] s390/idals: Use kmalloc() for IDAL data buffers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260916-s390-cio-ready-v3-7-39e4894637d6@kernel.org>
References: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
In-Reply-To: <20260916-s390-cio-ready-v3-0-39e4894637d6@kernel.org>
To: Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Mike Rapoport <rppt@kernel.org>, 
 Peter Oberparleiter <oberpar@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Vineeth Vijayan <vneethv@linux.ibm.com>, 
 Vlastimil Babka <vbabka@kernel.org>, linux-s390@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8F22C160017
X-Stat-Signature: ouk4rsxzbcf1purqkoanbnysp5s6cz6z
X-Rspam-User: 
X-HE-Tag: 1789560220-639262
X-HE-Meta: U2FsdGVkX1/6IfEPn9oACDDHEL/u6+N+4yier9GTE4UCWWTlLeqV/ZQSPn0UJAf8RVzHNrylSopxwjimHRCr3ZyIvo/TILD+WBdT2LKV+dspnLqIT+450egJMCHbAeKUyi+tGVk6sj06OuTSJgdaTfKQhvPIfeJFPeKsyS1gP64+H2oXBKXgw129BQNPCmqQidgKVl93jbwwhzJ7TnDvsz1an/PSLxlAGRVHbZH/Iqr/jwcddxLjUsxfS45LrsipncU80FlPfLUxerv+KOPBtOQHOdSGL1mXaKG8lj3/GFlx6y4v44a8kPzehgaMtMPikEsqH+KFapcBNPgJSU5DSuYVfLuYWFv3WoeMo+cupCsjrU4OvN/XWHiCJlhNS9ABG7rGkFftk8BVeFG74nEXpQRf8//xcnWt0lbwbP3UZdQHL+WWB4vorTbzLf+sLtQ873R16yUxL1c+ZR78oFM14+B5Hwo6Ayom/c2r3MVutQVCDCKQz+890ekolOMbX5OHz2p6pGbczGauy/Lf0glnzS2uao9zhaB7YuQC2UA+BRjuy5SylCpkkzsWuYIckbP3YXLcd3l7rVRqu34mfEfgOs8ciCfap+tFS3ySB/tMHYJXCWvyIvJlSXIVjmTS9MavvNmZ5qKxId5HUrj5MuxXOTvp6220uTh4NgSFQ8C/kfc+We4xeTK+3lVffBeRexa4m6DGncXC6jscmwHCaqdu63/f5cYxbz1wlCKRDgCUX5XQTHEFuvGOMEDMhAZXfwETf/bZFjHl18mJJluL3Z+QNB2oPwaP+7nSUVuuwZdinnhXdAsY2bfSlLkcpqpio4X/h1aepsKsGr1ukHqOFWW6SBx8A/wKszim+Sb/r7uJ3KxhRu+fRT6mtJIEvJuyicJxaVswM0Kiy34b/JTEe2N0/OaGgHUBrNMApeSz/AeAHxHTLNRFaVNBIEkxlw1zk8iuQxo/m6Q2rrQ0zVlrIDP
 A7dIzfCc
 L98AmuNL7yIt5vHBwfrZT6/XUEr7tQFbw3cHFhyfDYYI8K5/NE4P2DCOeVU+Ns8mzGdFll6jnr8lbr5ZbgzHWzgtV0Ri9BjMEjE/atWivcCnV3p1WZB1pNaGnxLtsKy6DYeuAg0sx8TR+YtESkUA2Y3Vinb0aK1tBX+OJqo1k3+cGwjzbr0jxbXR7vihTe62ENOmThdWDH7VvML3aTw/Za6QZ8+SCx0opuwU0aBYyZ73TG/A51szdGlHKAwe+zrPYx6vakHTHWQTHgMk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

idal_buffer_alloc() allocates the data chunks of an IDAL buffer that is
used for channel I/O.

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of __get_free_pages() with kmalloc() and free_pages() with
kfree().

While on it, tell kmemleak to ignore the data chunks as only their DMA
addresses are retained in the IDAL buffer.

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/s390/include/asm/idals.h | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/idals.h b/arch/s390/include/asm/idals.h
index 06e1ec2afd5af..213f430a8d33a 100644
--- a/arch/s390/include/asm/idals.h
+++ b/arch/s390/include/asm/idals.h
@@ -18,6 +18,7 @@
 #include <linux/types.h>
 #include <linux/slab.h>
 #include <linux/uaccess.h>
+#include <linux/kmemleak.h>
 #include <asm/dma-types.h>
 #include <asm/cio.h>
 
@@ -147,9 +148,11 @@ static inline struct idal_buffer *idal_buffer_alloc(size_t size, int page_order)
 			ib->data[i] = dma64_add(ib->data[i - 1], IDA_BLOCK_SIZE);
 			continue;
 		}
-		vaddr = (void *)__get_free_pages(GFP_KERNEL, page_order);
+		vaddr = kmalloc(PAGE_SIZE << page_order, GFP_KERNEL);
 		if (!vaddr)
 			goto error;
+		/* Only DMA addresses are retained in ib->data. */
+		kmemleak_ignore(vaddr);
 		ib->data[i] = virt_to_dma64(vaddr);
 	}
 	return ib;
@@ -157,7 +160,7 @@ static inline struct idal_buffer *idal_buffer_alloc(size_t size, int page_order)
 	while (i >= nr_chunks) {
 		i -= nr_chunks;
 		vaddr = dma64_to_virt(ib->data[i]);
-		free_pages((unsigned long)vaddr, ib->page_order);
+		kfree(vaddr);
 	}
 	kfree(ib);
 	return ERR_PTR(-ENOMEM);
@@ -175,7 +178,7 @@ static inline void idal_buffer_free(struct idal_buffer *ib)
 	nr_chunks = (PAGE_SIZE << ib->page_order) >> IDA_SIZE_SHIFT;
 	for (i = 0; i < nr_ptrs; i += nr_chunks) {
 		vaddr = dma64_to_virt(ib->data[i]);
-		free_pages((unsigned long)vaddr, ib->page_order);
+		kfree(vaddr);
 	}
 	kfree(ib);
 }

-- 
2.53.0


