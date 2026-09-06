Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9FF4C79F99
	for <linux-mm@archiver.kernel.org>; Sun,  6 Sep 2026 08:27:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF4856B0092; Sun,  6 Sep 2026 04:27:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBF2A6B0095; Sun,  6 Sep 2026 04:27:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D86B76B0096; Sun,  6 Sep 2026 04:27:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B39D76B0092
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 04:27:36 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 39DD0A4847
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 08:27:36 +0000 (UTC)
X-FDA: 85182658512.16.D1387BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 8CE29C0004
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 08:27:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PYMp5XZs;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788683254;
	b=euBjoLqZIajdGb6AlVrmB+E7nQhT85GzG8CXfOLJzAsRWKSwRxwDE9GTxHlI70IviRRAg3
	ggCiO1qxGk1UezKVo4tBiRl+zixrT/IZJSVPO94I6T9veVPol5RqJX+bnj/xlfw/It9dOp
	t6K0xdKxEHTRVT2Qr2JEJjkrD6/Ep+Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788683254;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JMHG+THezrVqv+LxM1LlqqUzwwh90wkGAEXs+OQ+QKU=;
	b=P8YVrZJ7pC6cPkRJJJY58OVuW8mh0O2yNvFUswS+HAYIfAWGC+UdFLUtKqsEar4sdUgeV8
	K8YVBgwZtV2XC0fsqn3tsH5u9MWQRKrKLKbyqsllD24FSEgP1cbgpoNKmw87b27ojCV6Ja
	W/BgwuEFXZR/WnGnqiKIRULxVjwH9cg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PYMp5XZs;
	spf=pass (imf10.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 218B260236;
	Sun,  6 Sep 2026 08:27:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE4A11F00A3D;
	Sun,  6 Sep 2026 08:27:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788683253;
	bh=JMHG+THezrVqv+LxM1LlqqUzwwh90wkGAEXs+OQ+QKU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PYMp5XZs0RSikeOmuwhKduqniWT3hGFAXvR0qtGbALX9yosr5KePfNaVKRg2SYiMw
	 McPUiTok5nieRhEXBdSvYsbnohtBT6eIH7uo8rKYD0KjrtCe939rzxcAOi7eKhdzlK
	 /J5jg6Cs50eL9nyAeDEwkb+kVAhGHqCa9HptydJc36ezW2aYQTWAVT2zJ3s2BvoZJ9
	 ZU0XIXucyOWL9vLlOdtrggfum95IivONi/zf+Z5UuI5qMUYm2kprd8LNgSvJL3nSRh
	 l7+Y6tYXYBM614JIt91OPc+lOS0AklR7KTb2Ql8XHR7x5kg4z9UfusC95OUyZpMewN
	 kXn39hX7a6AbA==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Sun, 06 Sep 2026 11:27:11 +0300
Subject: [PATCH v2 3/4] KVM: s390: Replace get_zeroed_page() with kzalloc()
 for the GIB
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260906-s390-kvm-v2-3-2cf6434e6646@kernel.org>
References: <20260906-s390-kvm-v2-0-2cf6434e6646@kernel.org>
In-Reply-To: <20260906-s390-kvm-v2-0-2cf6434e6646@kernel.org>
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8CE29C0004
X-Stat-Signature: 7r8yhepbi8td6iequnic5xbghwykdtfd
X-HE-Tag: 1788683254-461255
X-HE-Meta: U2FsdGVkX188OFYE6rrKxUiVfZXM2jAVoGfGR8D8ZVK5DhZ1m7V84GzGG1sTc1lYQCg7tznNPoQSW0ISTODF8vITmoRwoZD2jXGsLaQUn1sbszLJ1L5HCY26vD+AzVYBVI7wsYkKOMbtY+0EetCutz+QPu9A28Lwh9l//H99s6v0zYixb3goaItB/06dn3ABxfuNeEABslStY11onxyNJSZRyUOcXwyPfG3Yzl/ct80FcBcWfiwS4FX5Z/VcfJDl7qn/nLFpQPSc6iXCuTl8DLetpiuX2mOAL6rSBO5kHDiLFpRVunfRuKS0O9Nyz1C6Ij50biBa3Lo21mLSYzTnJFCW4BxQg0XbMYUhzB420MIOQqDuvKqL7I5UhlYlqIx7PmBxAMA8f+C8Nznr4I8i3b4ijQC0i9DihuVl7qNKUNiA+AJRKdHlFe8YlbdflT+RIidA36JB91qkEhWxGUTZ0y1mxW5y094JZNvQTtXpkNKy/96siWam1Uyfwszef4yFoQB3WeBacv1wc3lY7DmuizRtIVmIB9I/LXiWm7xKOjtMKNpuWz+DI68O9SpEESvYOWlUcq6S1hsn8YeVJTw9UfA2sLnyFxQRRSePItIHH6MES2d+MI66E6+1Z0h/dBSpJYU1xa2kgWhUoNygmVzt+pFaMTRPrB1jS2CYZWj2/Et3bR1bUNsmsXHbhxEW+duWFO0ztvzarZoHli/ekcHpif/HIKQOvtQBKv10bMVXyzhYC0kP1oEYIk78Et+M3pQ3/NA3LZp6J8lhxQiV9nQpQ7NEkCj/hss8t2VB1SVuFbOrD4Qpt2qB3y06Hmy3lyV8NcPSESOjGGJYJPFlWXRf62CFQPM8e60TV7I+EDIA1Degz0AM/E5YyhxMabdhvpPGvqFIsAHx6HVpWn3VnpC1MR7Bu1H1Ge5jJljIdpK8o3p7bPAbIr7aQiqB1KHlcypVVOVIgdAboCiHtmd5nuI
 fByYN2RN
 ehTtNSvnNLe1AbHvChAF03Tu7oTTnkfngPeg7AMKC0e+6tXLRjYcRITHw2k5LER4clGXdUgYigqe9iXIEXG72JQuEcu/TxJwS8zrREGD+NsanBAQKYAIwR8x+GfPor+EFTz/Bzud36z5YDtIjkdROA7tcVjoFb+vpPm8ge1pWSQ5C9EwzV/7FzNzAtk9L+RrpCi4un4wnCHnszJ0wqkCD2B0kOdHse+V8W/XWQmi1mqgbKkS8Udt4YU/SfUcbI/QR0zYEYDdAI2DIinWTXz+SFPcCtHFCcesIWZ98s/76p05kKDcxV80blfi87Kl5Rxs7bZ5F
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kvm_s390_gib_init() allocates the guest information block (GIB). The GIB
is passed to the hardware as a physical address and must be page aligned.

kmalloc() guarantees that a power of two sized allocation is aligned to
its size, so a PAGE_SIZE allocation is page aligned as well.

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
 arch/s390/kvm/s390/interrupt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/s390/kvm/s390/interrupt.c b/arch/s390/kvm/s390/interrupt.c
index 0381ae9817035..02065fb8d053e 100644
--- a/arch/s390/kvm/s390/interrupt.c
+++ b/arch/s390/kvm/s390/interrupt.c
@@ -3689,7 +3689,7 @@ void kvm_s390_gib_destroy(void)
 	}
 	chsc_sgib(0);
 	unregister_adapter_interrupt(&gib_alert_irq);
-	free_page((unsigned long)gib);
+	kfree(gib);
 	gib = NULL;
 }
 
@@ -3703,7 +3703,7 @@ int __init kvm_s390_gib_init(u8 nisc)
 		goto out;
 	}
 
-	gib = (struct kvm_s390_gib *)get_zeroed_page(GFP_KERNEL_ACCOUNT | GFP_DMA);
+	gib = kzalloc(PAGE_SIZE, GFP_KERNEL_ACCOUNT | GFP_DMA);
 	if (!gib) {
 		rc = -ENOMEM;
 		goto out;
@@ -3722,7 +3722,7 @@ int __init kvm_s390_gib_init(u8 nisc)
 	gib_origin = virt_to_phys(gib);
 	if (chsc_sgib(gib_origin)) {
 		pr_err("Associating the GIB with the AIV facility failed\n");
-		free_page((unsigned long)gib);
+		kfree(gib);
 		gib = NULL;
 		rc = -EIO;
 		goto out_unreg_gal;
@@ -3742,7 +3742,7 @@ int __init kvm_s390_gib_init(u8 nisc)
 out_unreg_gal:
 	unregister_adapter_interrupt(&gib_alert_irq);
 out_free_gib:
-	free_page((unsigned long)gib);
+	kfree(gib);
 	gib = NULL;
 out:
 	return rc;

-- 
2.53.0


