Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87260C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 10:24:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFEE86B00A6; Mon,  7 Sep 2026 06:24:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B62BC6B00A7; Mon,  7 Sep 2026 06:24:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A511C6B00A9; Mon,  7 Sep 2026 06:24:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 79B3A6B00A6
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 06:24:18 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 143E41A06E0
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:18 +0000 (UTC)
X-FDA: 85186581396.15.3EE0234
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6A541180006
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 10:24:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQD1u0iZ;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788776656;
	b=KwAPfTCg4wG114Dnu4miU+HWvsIn/udaS9Re5ioC1LNNsViUkMmfaT3y50rRsNrjZSsK+F
	mCJhnCTJnLfb8eelCoE0nN+cck4UbEbbHkCrqwIXnC/kyuUsMhF4Eel6BBDjnXFsNePPmF
	VIu7fViipd/GioGxh8rm2CY8eDD5PFo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iQD1u0iZ;
	spf=pass (imf16.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788776656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3tq+MmVWpxNrmq2a43GAPaqrd07nxrFSLnxvA2070ww=;
	b=XSxel8N+ZzXQdlQIrFM9G1tWM2RGU4eR3LQrpXxhGB60AjSJhnUYCNBlntvM41rUmes5Cm
	17HLSeKsey9c+5EC+unx63/aPCzUkQO3y85k3hWNc/3WYqxyE+NTCr4JfXW/g7aqfu8gt5
	YYQ2/lE5jexwBAkyHAjA36Vj6EaXsrE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 072A360AB5;
	Mon,  7 Sep 2026 10:24:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E90AD1F00A3D;
	Mon,  7 Sep 2026 10:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788776655;
	bh=3tq+MmVWpxNrmq2a43GAPaqrd07nxrFSLnxvA2070ww=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=iQD1u0iZXJqJOENikM9GGerBxb8HEccexTEau4VGA63cDIw4BSsatuxl3gWwXTGHD
	 SYXN6vXKEMpzfU0RJMP6W4FH2rhsJoTPQeTj7QHO8C0BWaxsMML3kCjlpb7QCoZKfQ
	 HpVTv++GYxSCjuiwXe/BBHNmUp4QPXsHrsthDtPMM1Rxb0Y4cwd1aw2Kui8gZBVUYT
	 Noc0z5jJcIPQCzNMgltOivv+y3/paJNswKpY+/UTwGIRQfEGN+JynsFmHrZUc0T5Qq
	 XuRfX9zWEKCRG0RM6+4yvfkw1+XYcI3d+exQortSfRKNF49MWRXYLDSJQx9XLHPb1g
	 +9syUsDnG4AWw==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Mon, 07 Sep 2026 13:23:48 +0300
Subject: [PATCH 07/13] s390/idals: Use kmalloc() for IDAL data buffers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260907-s390-cio-ready-v1-7-ca7f39806234@kernel.org>
References: <20260907-s390-cio-ready-v1-0-ca7f39806234@kernel.org>
In-Reply-To: <20260907-s390-cio-ready-v1-0-ca7f39806234@kernel.org>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6A541180006
X-Stat-Signature: xc53gzinwzqogtxba8u9dw39udenkyxf
X-Rspam-User: 
X-HE-Tag: 1788776656-717079
X-HE-Meta: U2FsdGVkX1+MuvixuaEhirdWqMaXx/nR/fj7xvx09KSnq0e3VJc93Ki1YLbA7hvBiKsfTkaiJ10O5izZVz4QUrEgsqQdPiynnq8dlHmCHSDzT49zRGNtDQOQT/5qKjTxtKUbCTD8gGJItbjYbcDMzdiidiw7IbyDvda+oAY1P7ZL1kJOkNce65+LEBFx1vtnqCNjQigHK+1rB668bbHzHlfKejDmNXOWQ1qZ2FK71ZDUYp8kfMGKD0WRS6i8Fp5rOpC6tHTmU6TYf4Fs5kJLh+VnVHBbdBbBakqDu9tBXdmwwSVbZnrHokFFYHHGDOg+zTdbfuBIs2LxQT1dcQgvLWp0e1avYTgFF60AsXrMUk5LRKTemql4YUsft5ElxsMHYYgEnmCB9gUct0q8kfUEVKtyhhdhKGXaAfiAiIdyLOHncPJVGMLU8R2VrAaBgD1hyVI8ty6ChwPNJSBOxQ+BbMgXAUgm3R85WFaDPkuIOQLPJmxCuNjD2IrfrXOP7F2a/9cIHh4kE1eeaCVV0NNiUdXBmqaYU3g/8Clh2BhOJTces4N6mNBI3BJ/cI/wgVJ3ZIVx8+enl0IjZ5hThwZ4imoPmTm6SwkhnSxdBCJ1r0WVuyjl6FOA+yEh9CwVWFizrH4vfl7gk02bT0YNEcYRbtQBBGVJ5+kaKOWiiaDnUiDp2FQgkT5kHRGV6DBjG6OKtoDX10fXmoy2V9C1mISFd3F/5BpKUIaFpjSQxsFENYI9wmrW6rliy8U4+G4bt816guWPzT4vSbluhWGyoNbU8oSj/S6hVw4G6h/kcPMJZdZfB3fKbzzJEa3XqY5Q59ae7+72QVh/Nx+l1EB0iWtFt+7msLf7llT/YDk8bkPjH2jHg+yCf/4NrusgJIu5+osiDS0NJos2oElHhLeKn6rZMmjg7hVa8bF+xzXs8pgmns4GQYoqt5tjpJ6r6Hbn5cXXbWlfe4fU3dyX8+J5Htu
 tkL9UQET
 1hQdLi+pM6bZg/mGLhpwdgEAsPEnxSfF5Qw9OSCGCA30vjhN4qnt+dbtOMF0yKupNWaO9w43bFIvhbStN43sqeZch9mIOWuT0V7OBwd8ddSIvvIONXhd9PmkJ+5jl75giPMQsAd8/S3WvKTwVuooF/T8xWnxO7gfpTwntdT7WI+JeP7QmYJK1yGN6i3XYg4PBEFkhC9swgxtoUyLWquMc56zTRGnyoV0Z3jV/rKPIH9hCeN2AKURTvYWAKesnCr+nxBXxWafS3Fj3yqw=
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

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/s390/include/asm/idals.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/asm/idals.h b/arch/s390/include/asm/idals.h
index 06e1ec2afd5af..248829d461bce 100644
--- a/arch/s390/include/asm/idals.h
+++ b/arch/s390/include/asm/idals.h
@@ -147,7 +147,7 @@ static inline struct idal_buffer *idal_buffer_alloc(size_t size, int page_order)
 			ib->data[i] = dma64_add(ib->data[i - 1], IDA_BLOCK_SIZE);
 			continue;
 		}
-		vaddr = (void *)__get_free_pages(GFP_KERNEL, page_order);
+		vaddr = kmalloc(PAGE_SIZE << page_order, GFP_KERNEL);
 		if (!vaddr)
 			goto error;
 		ib->data[i] = virt_to_dma64(vaddr);
@@ -157,7 +157,7 @@ static inline struct idal_buffer *idal_buffer_alloc(size_t size, int page_order)
 	while (i >= nr_chunks) {
 		i -= nr_chunks;
 		vaddr = dma64_to_virt(ib->data[i]);
-		free_pages((unsigned long)vaddr, ib->page_order);
+		kfree(vaddr);
 	}
 	kfree(ib);
 	return ERR_PTR(-ENOMEM);
@@ -175,7 +175,7 @@ static inline void idal_buffer_free(struct idal_buffer *ib)
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


