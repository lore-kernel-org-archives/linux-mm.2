Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05C55C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 11:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7460A6B00A7; Thu, 10 Sep 2026 07:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71E726B00A9; Thu, 10 Sep 2026 07:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60DA36B00AA; Thu, 10 Sep 2026 07:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3F4D26B00A7
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:00:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 544FA160477
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:35 +0000 (UTC)
X-FDA: 85197559230.15.4E6C03E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id B5D64C000D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:00:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QwJMnW0u;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789038033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bAVP4y79lmB0kd35IBqs2N16e6jwAfNVV+NWInsx3B8=;
	b=f89IWJCnSLiNSkD+p2RzvmvXN+eZ4YuVyuUFiVNOpFmVIIFSs3949PFL9rMBxNbIwBNzqA
	tlaAydVd7OPkBNp5+VNybSEjO/Y2z0KXKPRovygY1M1Z7n8YFgBT39gk0GRKtmcWHUfRNk
	Mv83mygUSIjxEEd9zSluKO58TRnq8PI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789038033;
	b=6kxbN7mzhRPQWLwYG3CYyWH+l/BHGcOppFGutxzrbYtHEbFYqGBtxMe5sOO9lQhU2jIPgI
	zCTNmMsYuv+vb4i1VTnpo33dsthp5SaKaBJMG6q+UKVN6bnjt9VbkrDEbA6ZBOZwHHladi
	jTypyUusnIXM+UjuSV3ZR5FNWldK9GE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QwJMnW0u;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 460C460211;
	Thu, 10 Sep 2026 11:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369BA1F00893;
	Thu, 10 Sep 2026 11:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789038033;
	bh=bAVP4y79lmB0kd35IBqs2N16e6jwAfNVV+NWInsx3B8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=QwJMnW0uXEnOlhVjMZA3ChXQrzqwPzdD00tByvpMjpZhbWPYw2EJdfVvtch3h/gZS
	 G8mh1fgKfpv7AA3MQn35gggwdWJqOOt2ofz18QG2rJT8R953CBCiPLjyEKF49uqLnV
	 q+EQ8WmHBUuk8iQhRrfrGrGExi9FTJn+tmDTlhkm57GGQd9AruTdroDxlPuerbDl3C
	 zdEQE9V5Q5uiApj3qDzkEd2l9IzAmVxfy8hwd1UtOad7tfAX7gF4+7ggrj70cCZZqF
	 8aGTdeEAocc03X2vN+/KbDM2SEyEEyymgz2CH1VaZpf7oHPgD6/ZQxzdUlPElKMchr
	 VjgvEuvNpQnLg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Thu, 10 Sep 2026 14:00:09 +0300
Subject: [PATCH v2 07/13] s390/idals: Use kmalloc() for IDAL data buffers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260910-s390-cio-ready-v2-7-e931086fdde1@kernel.org>
References: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
In-Reply-To: <20260910-s390-cio-ready-v2-0-e931086fdde1@kernel.org>
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
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: gbdii4jqqst7hiapna47zkwtaq96jfie
X-Rspamd-Queue-Id: B5D64C000D
X-HE-Tag: 1789038033-418679
X-HE-Meta: U2FsdGVkX18XSbXs5Ka8NORqfvXYG5rE2p5t+p85igMFAeTL1FMkzTxOPoI9VbcnGO4gBtSheJ7u9S/EJhkYAjMBKsG8dbasnW6KJ3Jp8m+4RwcRb5W9CSkcvECiQL3mOE0CBP8BB1u9LJgU9dGsdVWW1OFlfkZOuIamaqWeevz1atVkGPN34e35UB1nSd1GDtT6oAOebNNLqDQL962oTs8HYW2RYbsg6XhXZIu6MPqex+sxijZMtUa7DsH1G07Z++Oxf2WU0r5O8/x1JpIpwHklTY6L5LG9blg2/rEXP/Ygjtmb1srkK2pBN+ixE3UqNw03VVrnLMgoJOZcjyPeOcFFAHd1BLt5aSydZvHjCt/WtcI+PPUqUKsJptz44MR5vAb3ltt2r25p8v72mZJQMx2JATTpH2sWhIVopkucoqv5518oGQU9xsW34P0vGXWMFtThrqcGmlF8//3xu2kZz9+iNIjWb3hYN128v5sucA+eaMT3eacXLUybElTqk8q66SAtd+/hNFk7sCVhspA9E8euObjRxSe8tssFZS0l/+boVHkxw5Z9v3NxQehRekp/tJVVMqHiqvdndOwAMLFxUOsikwvm+1TU2q63/1mYg+ljOI7IMIO69WesImOCf4WDkGB0/J4YIw7glWHc5r1kDO+hgc2a87r//2gmuE+w4wV8H1Jkb7EADsm90PhS8E+mygvrPkXuaYsxDo8+7rXgRDbZWMq6tKOLsBfR1f+IuIAxseCfMLwrtHNWlhVRqqxn/Q6IKU3yjZaoo1wjgc3gWxRawe3bGEtpvqwZy8yDmnYDPJVH9Mk1oMZpQJqEEl7tZjUmX/hSKk+jREAbRf8Nb0Wt0sYz1SIOL+TatCEispHJYr22CGOkWgAMGCelCJihWsbo3va8K0P9ZwtbPIkpPxox8BCiUDHe5ZuIuQJpaDfcqQdafs3amdOEwYRC4PkkuUEcVWxVlJg9JEHkG/g
 WdrZK+Nc
 kRJZYrVvIEeuUfPOQ+wTI2zVjZzWj488Cn759Fsln+VFv6Ywdu3KzFx1k/a/KtgZ1EDiyax5HbH1XVSGJ2dyVw7QOmQVyD4t95rMDt7a9VqDsVyXI4U5Jn0McZHSK08N5YkWE+FCbBXj87k2EGeeqcC0jahqnjNepSkZ1qP4iSjx91qxJgDARZhmbqeeb7vrZIH1LE6W7lM8mpeOpU77jWoW0daQhxdN4rgtXPRyZ+fPwSyJHl6yTaKqdIOwGNaZYQ2La3GJYgV8visg=
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


