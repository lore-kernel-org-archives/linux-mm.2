Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20331C61DD6
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 06:15:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C02A6B0092; Wed,  2 Sep 2026 02:15:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24A366B0095; Wed,  2 Sep 2026 02:15:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 111B76B0096; Wed,  2 Sep 2026 02:15:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DF8626B0092
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 02:15:36 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6B67B1A06BE
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:15:36 +0000 (UTC)
X-FDA: 85167810672.30.12D61AD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id C97BDA0007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 06:15:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RyCC6K3+;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788329734;
	b=SCmv1yhSNSQxDd44Gd03fGjiWlIfe6BVgxCffqGP8/2OTjgRFPTF2HH6nc0tiln1Y/1267
	yeuKmZ3X76H1xHtHtZVICCDfb/N8nwgJELnDawh+qmnz51UpNDf2HK1bGXKcSt5lQxxlVD
	DEX5wIylvKSxkgqupT2kgN2N6OrjZHY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RyCC6K3+;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788329734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rZDmOJa3lKJg3q4J0vxXiCwo1usJZY0dSBwZL2xaIK4=;
	b=t3B+4HW105d1xShrfX3dnVJ9ykPkjFvht7hn/cNgx9ixe81UHdGPVtyVJiKBuTYwXSfPev
	bobZDybKU81mmOw61lc0R3JfujeJJDFSngX+Nxa9VMcghldoB/CnQZ7ffrOi+WE12aBkKE
	s2MBix4gwsW5fp02t5gdpy7BpDPvUmU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 234B160218;
	Wed,  2 Sep 2026 06:15:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38201F00A3A;
	Wed,  2 Sep 2026 06:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788329733;
	bh=rZDmOJa3lKJg3q4J0vxXiCwo1usJZY0dSBwZL2xaIK4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=RyCC6K3+yoBVj6HOL+jhCmJspI1rOOtMlmlJ09dU7HJTzqEQmvW2aI/S1sfTHPfj6
	 ZHYdLXxvZEV213yRt6hcyicUWOkk/fmtKZ2RbcigWIVDgqKvgU4dQNyaPa3tdhRynn
	 UmyYgIsw6J0sWUvzPkXwjZYh+twK/i+vDC+6T4STp0EIiC0Lknuutak3P8VrbsKjOT
	 9jh7aG7AnlP2sL5unVXGeaY3Dzug0feoyhj1sILuc+230lbhU7aXqxUVJGiXrHlVt2
	 nsi5FDvTfJt+DSOgof/YYHzGjA6EsF0FFHUoTrVFeq7ELA2DJhEqGbMzj/f0c2ZSy4
	 nk9//iAEyiEjQ==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 02 Sep 2026 09:15:13 +0300
Subject: [PATCH 1/4] KVM: s390: Replace get_zeroed_page() with kzalloc()
 for the STHYI buffer
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-s390-kvm-v1-1-3bc0986550b1@kernel.org>
References: <20260902-s390-kvm-v1-0-3bc0986550b1@kernel.org>
In-Reply-To: <20260902-s390-kvm-v1-0-3bc0986550b1@kernel.org>
To: Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>, 
 Janosch Frank <frankja@linux.ibm.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>, 
 David Hildenbrand <david@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, 
 Mike Rapoport <rppt@kernel.org>, Sven Schnelle <svens@linux.ibm.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-s390@vger.kernel.org
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: jyscqfrqib761fyi5n6pg18qtk5i48fs
X-Rspamd-Queue-Id: C97BDA0007
X-Rspamd-Server: rspam06
X-HE-Tag: 1788329734-369691
X-HE-Meta: U2FsdGVkX1+jbeSWhGxRc4mkdeBX2WeVCQiLK0e4j+4Da5H2yYUocs5vUNrr0aE3clTD7Fwq2QywqeIsW9eXa8v0k3k8IeYVB8MSyPclV3yFMbigSVeTxBVDtSjDlORqLB1ytvAF0qUh/vHZX4eF4143RG69LjckK2la6iLmXou5XdpUOFhjb7vw91I9kA82rUPd0uRkwazIQ276KPcUk565QoTE5Hy7UNSAIUhGRJ3831C54S8Y/e0GyVeZ5mnI1ZQd1KG499p38NbPvxcEdHtpA4ELqmHVgXVSVAdK/PJKFUUqBYLBldklwczlQPNbYL/1/PhOLklsKYhd/HsXtgbHE+fipalPuVOaWEKZn/EECRffhQmbrResbh4nMfBhWBijvQffQZTAp7chg6B4XNMqGbSNhIymitzeqbslga8RyNAqQIUh7kUoZbIYdTGs4dEKqTT8Kn0bDo+DqAS8YkkJIR+9PDcWMTegqxPZQ5Vwlj9LlZg02Jcdu1RuwiOD5ZYF3RyA+/AJNKODgWQI22HDV8ez9hdqEaYKVC2pbbcTCnA6A83e3VIyvw+bOOcdB/hsp5xrPIvuNJ9Y2lPVZA6D/+VWI+Oizb/b+fffUdw90bAgkANBnITgbHBzz9/fvmK2TCoq7YBMLKs60ccvIow9Yhcxvmfq4z+MH2hbu8R2mTCXhpw8iXlQ60hyIxsxV5/5AnqgX2KGGXN6Qv1B4uP/5ejbvBNs9QHbYTI+7x9NnCtEEE4K5a1TmmwqO/tDvR6JBG5WBqK3Oo16q16ByeCpPvra0crz8QY1alacTqp1pomcCE48r7UavIcShb5l0rCkLsPcnp+Xgd1RBLXalUqRgwAfU05GWunQybajYVG9B2Zwhbh1Tm/mvI7MT+WWgsAF2qNsNi0xRfyUV/mJqaFUm0s17K9jzp69KSyt5GYW1BmjG9opFamTItrdpFRIRDflta5b5xTgCJh/iEd
 uTADZiTb
 VT2FG154CPX0sKsLL35Zodui9Ih6U5duvJCGBD+NmYWT9waMNWDz8Cr98M5LOlRKXp+2e+avvvGobgSgaFEAUBShghCYKs0B8dvwwDU24/q12G2ZbBBXMh85nvW61p21fZhNjbAojIvUyaXiX+NIJP9RR6ZulPynxRaU3IA+UZa4dKTWjzUpIu4cSgs/ulLCYeYM1b9sQCJHvv6JZYT+aWIvAmGt+S8VddxxP+jK1aDco8/bif09cFTlC+JuHsBVs7uHpjFoH8wR09QUWxUyiJJ+5gorLv3hgd5aYb+bklX75sRhDvRZsNauUJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

handle_sthyi() allocates the buffer that receives the STHYI response
block before it is copied to the guest.

This buffer can be allocated with kmalloc() as there's nothing special
about it to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and
kfree() does not need to know the size of the freed object.

Performance difference between kmalloc() and __get_free_pages() is not
measurable as both allocators take an object/page from a per-CPU list for
fast path allocations.

For the slow path the performance is anyway determined by the amount of
reclaim involved rather than by what allocator is used.

Replace use of get_zeroed_page() with kzalloc() and free_page() with
kfree().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Assisted-by: copilot:claude-opus
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/s390/kvm/s390/intercept.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/s390/intercept.c b/arch/s390/kvm/s390/intercept.c
index ca1205dfac8b0..aaf9828d1f44d 100644
--- a/arch/s390/kvm/s390/intercept.c
+++ b/arch/s390/kvm/s390/intercept.c
@@ -11,6 +11,7 @@
 #include <linux/kvm_host.h>
 #include <linux/errno.h>
 #include <linux/pagemap.h>
+#include <linux/slab.h>
 
 #include <asm/asm-offsets.h>
 #include <asm/irq.h>
@@ -438,13 +439,13 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
 	if (!kvm_s390_pv_cpu_is_protected(vcpu) && (addr & ~PAGE_MASK))
 		return kvm_s390_inject_program_int(vcpu, PGM_SPECIFICATION);
 
-	sctns = (void *)get_zeroed_page(GFP_KERNEL_ACCOUNT);
+	sctns = kzalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT);
 	if (!sctns)
 		return -ENOMEM;
 
 	cc = sthyi_fill(sctns, &rc);
 	if (cc < 0) {
-		free_page((unsigned long)sctns);
+		kfree(sctns);
 		return cc;
 	}
 out:
@@ -454,13 +455,13 @@ int handle_sthyi(struct kvm_vcpu *vcpu)
 		} else {
 			r = write_guest(vcpu, addr, reg2, sctns, PAGE_SIZE);
 			if (r) {
-				free_page((unsigned long)sctns);
+				kfree(sctns);
 				return kvm_s390_inject_prog_cond(vcpu, r);
 			}
 		}
 	}
 
-	free_page((unsigned long)sctns);
+	kfree(sctns);
 	vcpu->run->s.regs.gprs[reg2 + 1] = rc;
 	kvm_s390_set_psw_cc(vcpu, cc);
 	return r;

-- 
2.53.0


