Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27FC4C5DF97
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 16:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82E376B0095; Sat, 22 Aug 2026 12:39:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DEE46B009B; Sat, 22 Aug 2026 12:39:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F4736B009D; Sat, 22 Aug 2026 12:39:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 498436B0095
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 12:39:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 407151601BA
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 16:38:59 +0000 (UTC)
X-FDA: 85129464798.22.BFD53E7
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9A20E40005
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 16:38:57 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JCloTXYN;
	spf=pass (imf01.hostedemail.com: domain of nicoyip.dev@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=nicoyip.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787416737;
	b=EYjV/KtjIH2f5Wj11OlI524z8JbYOFZ8noftPIcH4Xe47bK33pvxyujkJ15o88QdZlWynv
	F4tX4VegYDatPyiNVVUUL+lQKY/qBP6nVpPYXObySneQEgWwQzYqk3VEzMufHPv6wJyztr
	V81roWvmRmcXRKsTFcRF/syBDqzEtj8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JCloTXYN;
	spf=pass (imf01.hostedemail.com: domain of nicoyip.dev@gmail.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=nicoyip.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787416737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=g7kLVYi/u6oDHfqj97goW0adMfCQDYdgNJj4eCuKJKQ=;
	b=d5S/Yaf6r3AfffOuYInTHMHiySapcv7n0aCz5tyq2t8xL1lsmKH9BfuDMhaZ3il10Rf7Rq
	/E+HUCr03YfFCxAFFhY1EEr2fwAtz5u2Kf75xcQlSHDuLbHWpLZvPS6RkjXdfaf3YrGdCq
	FnX9TGf9F9whprKc20slDY+RR4p05dE=
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-836d228798aso1327737b3.2
        for <linux-mm@kvack.org>; Sat, 22 Aug 2026 09:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787416737; x=1788021537; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=g7kLVYi/u6oDHfqj97goW0adMfCQDYdgNJj4eCuKJKQ=;
        b=JCloTXYNkIBOUQNWgNmrRbLSTjl5o9ppNgq+R903Myo2qwSxQFzB6o+/7hUTJpJCY3
         mWis5WPavcEUNucXAqvN+Kt/oj38ycPvJuUmISYm0Cvoa27QsNrDdy7IxbKfi7MNEbCC
         urU9aitAk0vLdq0tEmP3yLm2iEN/Rhll0D5lDKwxPkzLKovdMejPd5gGWc+Wc/9d7moY
         hxbJQ9xOdUb0aQTyNCLupcr5q6COXTUBRn/eczoX8Z8dUvIiXAIFqQRQtKdxPRqbC8r+
         F9BGJH0r3yRxp9SG1CjlsDNO8zW6ekL037vAenyvnadn/k8K1ItgJSmUkcPs9Cn//PSO
         RGvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787416737; x=1788021537;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=g7kLVYi/u6oDHfqj97goW0adMfCQDYdgNJj4eCuKJKQ=;
        b=YQKXpDR0SMAGJVegHDaQzmEaAqZZC8aGRBXCnpFBMSPiED89dDnZqWqe2iPVaJZIwA
         upkEIta9CXRbCE5qwFg6sxZh7TsBe0H9edWGtvhPSskOjyerDB6mrVtV1VDVt/T9V1cK
         OJ3MrvOR8jou+dF1Z2zRdI1r1oo4oXrs3IrNSZww1rKSAtrmkj1AvcYfE8j8rEbFA3Qn
         dh4kya2JXk0LvDk5c2vjeqdUQt8hGvR+ND4NXTwXAcqRKHC+kznl4QOR/wXrxFnrYaKt
         krOq6ugPNKjjLuiX0cF7Cezi52nvuqFECKjn+5R61CQpe2pzXmkD2t55hOZSRKbDyOUW
         w+0A==
X-Gm-Message-State: AFuF++kuzUYWlq9YLH9OUmGPGcZXqrr4RK1bHsIfBkEQxEcG3duy2hMY
	xjlyRM7OVNV1izNAJRXIBc253G98qPBy3oylLrMWf559crwDiMQqSMKA
X-Gm-Gg: AR+sD13bM5ID5i7lLaMEg6Aj/YKmVguyU3/J4A2GzlqtsFn3fwdscZLHNqyHOVxVGYy
	FKacy7qjxNq1jr3SV6LcRLzM8Hyj6ZsxWiMbk4yi7Pa8wGuiGNnt+BQ2i/qYgEeBzSNHeEU3OLe
	jdfRr9j4X7O+VCgSMZrxPUVa2hzoosnRxljmPOCMJmDVnxS5QyJFG8XkroydjnMr3v/5q9vnR3f
	6FiaLJ/QENSLagMzFS5M4mfP4wH3jg4vdYcLrnN543AQVcK41Y0eYo6x37pWiwPV/arCgoSeJsB
	UJ+rxdUM1uiNtOX9r57Bn5zmFEfU90THjqKxbRzIp4M+60ItdWnSYvSaAXtvvKyzc7ipQeVi0Ot
	iVi72ngLZCR7PsDWapZtwxkJrTbxweAnkbnekHcjKPeMFV1Y7me0rEGReRp+YUx+8dkWsMuS00x
	vEEgqXWmVkGhdLzBzkJkvopii8MiSVb8txj4Ro7+rrnMxqCQ1k5C0s+x4bn6PMl4epuIcVYIeLH
	R0W++AlLLsgsYodsU81XoV5RZxfl18Ju68+Oj2PR8MPS5RQwXwfAfI=
X-Received: by 2002:a05:690c:6b86:b0:820:100e:1abb with SMTP id 00721157ae682-849f7d0c986mr57211377b3.4.1787416736602;
        Sat, 22 Aug 2026 09:38:56 -0700 (PDT)
Received: from localhost.localdomain (45.78.65.84.16clouds.com. [45.78.65.84])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-84ca518899csm12628707b3.2.2026.08.22.09.38.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2026 09:38:56 -0700 (PDT)
From: Chengfeng Ye <nicoyip.dev@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Hugh Dickins <hughd@google.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Chengfeng Ye <nicoyip.dev@gmail.com>
Subject: [PATCH] mm/ksm: mark migration stores with WRITE_ONCE()
Date: Sun, 23 Aug 2026 00:38:46 +0800
Message-ID: <20260822163846.3747787-1-nicoyip.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9A20E40005
X-Rspam-User: 
X-Stat-Signature: gtd4t9qjpx7be6duku313m1iqyhfhc1o
X-Rspamd-Server: rspam06
X-HE-Tag: 1787416737-806685
X-HE-Meta: U2FsdGVkX19Fi+b6k+Gf5E5uxKeA0Yc7MgwptWfZE8nM09Riv14aI2u6r4uL/dYLmRjuKebxO5jpZUPy8IuwnbIyZmlEoBkDChAQNVYeiLlZ5S0LaguEnkyKdiY7NorZVjgunioT1DZgxw8weq4Rzz/ZaOw+t5eJ5Yx8v1cPdcu4aELKXEeJZ/xouwuuSGbuCJR3+KlQyoA7TIitNbzNvC0x7/DzyFXB+IpVb4dOp18XIZ6kPTiP0CKT6ndn6zMZYKkNJFOzNL76u2D4GPe1qmqjyPQOw8pxwUktHeIUs9j9VEdDBZ6OuwvKQTR5XDVURCzyfAgbhyXvSv1B4vMUqQriflvMBfNlH2XlR3XZYW/S+yIE/c9xaBQQfDgMXAqNi8ZX5jdfj+EL2giVaF6w1P5IBrjZHZhY/m/y0Gt6vBDAkzjQ1Q+nP3Zgq4g/zQvVxPF4oMLd12g89x0AOHiWl1eXzu39CONjqTZ10F64taNpiZ+3utuXl0+S6WUoJtZ5+T87T3JN/YA6CL/XvG/5xv7385vHI53awlU4mPLejcKLsboCwp7BS5Sk8JfWhMzv4CM4SoVvfPcMABQiB6VJOORTi+yoNmTI8CFzW51qso3/uQxCIkgqqKz7BciJeC0DZjUi9EUfcY/vbizNv+5f8XuGCOAdv51dy7Wv+66VygaiwBjAalWBdZWvWRx6yTrTAJkxPuMkFXr5SfyxVvY9eI9s1VFHpB2QoJVKabocJZd+ms12ibq5o2y4k5e0g0i5vQWlngJO71Se/YNsSQuci3Ig3yr+mr7/6EjSaIbWYAcTzw+Xc6oTmbinbP1T4LiwKzoxIup1Vw9CaGlLDNMX0vXyUcwxzjdzdCA0+wc5aQXCFC5fPRax32wYtpFq9i19+LLRL0lLLDOS6IxVs4tASwS90e7TM7fIK6XfPucsbLtsHx/f61B8C8I+0LupduUxeLKCHe34ykMW2FwlnbT
 cQILH/M7
 r/df8YHyWYsrRkuM+6jQrd/U4R4ClEDgVYASNkGYaxaKpcD4MU/Y7mZEu3Z0TMMIhXlwXv/KauJKrIZoSGkvnCdaZhYT07kCYDhfFczKr5Oo6JjbvmiNAooxL+WcfRdr2po40qDk2o/nAGFVFKmKp+7XGxzw7xTYQLLFtq1YFKEfb+s+yI0RdA3rrqAAIANIXHAeEY4wU0rMbUizxeo7kSj2EshM0wMzgVzaC2C8rO0eKjzXalfOGxxYf1hWfcG/gINqUjClwQHGumB1QmmGLvC0+t7nue1sNJDLYf2ChvUSrdgH+hMQCUWci0CupJIED7kYSYqQ420cy4Rkezt/Ad/x6fZqTFpF3JLUN7c8wbxF5Sd78/OSd5tmnO2oP9gSMdLDDVfWs0EwPSUtu6xmynaVycR2dS7mudusE5v8h31pkpafTAbvqAR1tJjx+IF349zF/k9HaRRhfDjRiHgJ63ZcfmNmvsIi876VZwqssOUtygbMFbj3ebWW/z8AkKCmhJyItp8LJGKnGpBFryiZZqLa/4Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

ksm_get_folio() deliberately samples stable_node->kpfn and
folio->mapping without taking the folio lock because the KSM folio may be
migrated concurrently.  folio_migrate_ksm() updates the same state using
plain assignments.

The reader can load the old kpfn, then the migrator can store the new kpfn,
execute smp_wmb(), and clear the old folio's mapping before the reader
checks that mapping.  Thus the initial kpfn load can overlap its update and
the subsequent mapping load can overlap the clear, with no common lock.
This leaves marked READ_ONCE() accesses racing with plain stores.

The kernel reported:

  BUG: KCSAN: data-race in folio_migrate_ksm / ksm_get_folio

  read (marked) to 0xffff8ce401421330 of 8 bytes by task 48 on cpu 3:
   ksm_get_folio+0x7f/0x2a0
   ksm_scan_thread+0x1635/0x3330
   kthread+0x1af/0x1f0

  write to 0xffff8ce401421330 of 8 bytes by task 102 on cpu 1:
   folio_migrate_ksm+0x6a/0xd0
   folio_migrate_flags+0x193/0x420
   __migrate_folio.isra.0+0x162/0x1a0
   migrate_folio+0x4c/0x70
   move_to_new_folio+0xd6/0x170

Use WRITE_ONCE() for both stores to pair them with the existing lockless
reads.  This preserves the existing smp_wmb()/smp_rmb() migration protocol
and control flow while preventing compiler transformations of the shared
accesses.

Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
---
 mm/ksm.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index b4142746777e..bec6fea0fdb4 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -1116,7 +1116,8 @@ static inline void folio_set_stable_node(struct folio *folio,
 					 struct ksm_stable_node *stable_node)
 {
 	VM_WARN_ON_FOLIO(folio_test_anon(folio) && PageAnonExclusive(&folio->page), folio);
-	folio->mapping = (void *)((unsigned long)stable_node | FOLIO_MAPPING_KSM);
+	WRITE_ONCE(folio->mapping,
+		   (void *)((unsigned long)stable_node | FOLIO_MAPPING_KSM));
 }
 
 #ifdef CONFIG_SYSFS
@@ -3318,7 +3319,7 @@ void folio_migrate_ksm(struct folio *newfolio, struct folio *folio)
 	stable_node = folio_stable_node(folio);
 	if (stable_node) {
 		VM_BUG_ON_FOLIO(stable_node->kpfn != folio_pfn(folio), folio);
-		stable_node->kpfn = folio_pfn(newfolio);
+		WRITE_ONCE(stable_node->kpfn, folio_pfn(newfolio));
 		/*
 		 * newfolio->mapping was set in advance; now we need smp_wmb()
 		 * to make sure that the new stable_node->kpfn is visible
-- 
2.43.0


