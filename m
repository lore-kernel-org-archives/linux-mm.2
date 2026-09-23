Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24A04C98302
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 17:45:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 329A46B0088; Wed, 23 Sep 2026 13:45:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D9B36B008A; Wed, 23 Sep 2026 13:45:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C99B6B008C; Wed, 23 Sep 2026 13:45:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EA0B36B0088
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 13:45:49 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 86611160842
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:45:49 +0000 (UTC)
X-FDA: 85245754818.23.D48A1DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id AEEC91C0004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:45:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SZvW1r2i;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790185547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gBATB8uu2oRqNmBGt1NsSq+MtGX6Gp4XwS/NcICfVSc=;
	b=pSUtnC7nBrAAIC1LGtbBqjHf3Z8DM8Dw2ARzBcvtkLJBx2HAX02sU/Jpgs+iwPuMYPzJiZ
	t51fQTaF9eEvKkyrE5dUOBrihNBeXug45Y4Dw71KXv9zlpGIZDhXhU0mCLC3/AlkNu/tfg
	xNLpMmN80CZfnKNB1YgxwmQC1qr+j90=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SZvW1r2i;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790185547;
	b=3d2NRooLryj/BpGYGkXmGj9qz8894KKZ/Rtt6jIVfG9CZAl7pgwHnKLov3336WGJSyswIY
	WVk0HaA+uro/kcGW6j2PwU6j6ql4qwWhKRRNIaxyUySSH5rc5JXTRU3OrxQpqbgm8Pxn3m
	743eSpOvMsf1mRC1XlvNFanpWefZUV4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B767404AC;
	Wed, 23 Sep 2026 17:45:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 326261F000FF;
	Wed, 23 Sep 2026 17:45:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790185546;
	bh=gBATB8uu2oRqNmBGt1NsSq+MtGX6Gp4XwS/NcICfVSc=;
	h=From:Date:Subject:To:Cc;
	b=SZvW1r2ik+DDhg7vkKvvs618HlAFXyxsfvGQfSM6EI8MT2IkGKP0UiZKgozWz5V+u
	 83lw3cVk/Wjvxf/Pf6FmG/RwmUfKCGxjbWlbAxGOcTwidoJNgpJiqqqhJIxD34frPk
	 WReIvz64KF8bnDkJ5odUtPC8qZ8DGOkHLoVfMIhwHAwAJ1OsBRh5Gt81JCW5L8OSTP
	 q0QNwCNtey+lO7Ci8+X3P4ncdaONp4EHQM2JSNJiRQrddzywYtZymwFhn/kY2/Wq76
	 +rkzv6JnXGn0rN3RTDwPRd91Azi6Yr1YFSW+K+iexFgPbUjPOG/wTP6h4PmeH3dDcH
	 IUFXBCmHIlZ+A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 23 Sep 2026 18:45:41 +0100
Subject: [PATCH] mm/vma: predicate setting mmap_prepare VMA fields on new
 vma alloc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-fix-mmap-prepare-overwrite-v1-1-3b3f1bfcdf5e@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/x3MMQqAMAxA0atIZgNtlYpeRRyKRs2gllRUKN7d4
 Pjh8TMkEqYEXZFB6OLEx65hywLGNewLIU/a4IzzpnUVzvzgtoWIUSgGITwuklv4JPSVqSdrXaj
 HBnSgQvU/74f3/QD6PtX7bAAAAA==
X-Change-ID: 20260923-fix-mmap-prepare-overwrite-6304d112a4c7
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, stable@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=2429; i=ljs@kernel.org;
 h=from:subject:message-id; bh=B/5OxH4zopJDHw6XR/oNfqdty/0ftHeGKu0ofzE6qRQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2CLjXS2s2qf181v8xJGaF9Zx97Ct5WeMDZp9LDNnha
 Cf9kTOzo5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABPRlWX473ije1/kep09ew53
 7DjrYLvx7xxG020Pbl/o+q8vmeqdNIPhf/xxAZefS87LfVGUVGmVf6Trybg6Zb6axoY5b86dyJf
 0YwcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: ny7e1c9ecrbiixaqgx7ri6nq5bifyn8j
X-Rspamd-Queue-Id: AEEC91C0004
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790185547-431555
X-HE-Meta: U2FsdGVkX18dT30S1X6uG5uuJ9vh3LckNN4KcuJU/5dV9ooFsz+baPrA3rrxpAiscJqM52GW+maSSo55xZZD1I8KFUFeKCqIYABRR0Um/l3YN/DfTe/Ebmtcx9Kr5xpd1xBZ6KXDEaOE11eF9Xxu0CXWU3BNoAfQXHES26/21KzQcEbuplJdV9EECl9mfLjt0x35na18W8yp1N7ItTzYftEGTBwXEucIDofjydFOju020ycXycHjahSyxycVcnZ+3Y+f3q5G+MP233+I2xwKpvq9CgqKp/RodIXp2EdeYaH2CDj1P+QnNtyMMkVPtaPg0ZHIY5IcERub3Xiy3HkzZx1ZKwY1e9rPssW3sYG0lQ9Olz5nt6jSDuIJ3gsRZBLaJe0cBDvyi5xidqJ2dpmzpCsNNhNKQnZ7GlvhBmqiex12rATuBHuhh/YknP252xOoZnDiWKoOTrh/Kxh5i+9U3HmzeVcsnM/gHV+Uj47ZcaoLvUBUnTbTcn6ZwA3lJ+zQ2CAjX+EeKjvLKa0oYI/SexXtr4XqsK2MLaZs1d3YkldxJiY7K7W7q/M29yVliHG8x8KxTANsY3+sflh++ZD9cZ6QqFN8/B/B1J9L2talVoAoZIvNHu+5h56Fm8sz1eK2cGUvp2ufSA7txiuuPu+xdXjTc9Qdh73PhJODdI79rhRs9qCJtHws7uko/fjqAsrgssK9lSlZrn6tsA8rV3nXMpoWruMfptxZYyxq6YUwBb/eDt5p8HCWzO4x6M/xoN7fTihMlUe6PqWXOrllhgPjCWV24rxZjT/etewYyndqOep7K/lHgMNx8sUOwQKFijfr1P1JkAAfW2muHzLOi0ify34Pmir5Qv5k83uROi0WMeElZB5A8CyadCTS+nz2i02Fb6lY6A/8HgondfHLvQsy8GEmfTWWKPYZ9oeGRCj/GGrsY7e8zTfIQyjQ9L8GSchV1KJFKwnK629KsOtZjoA
 D/bQWnV1
 4wotn7nWbuxrOZbK+kN2LAs9aPHhW8jhjOYHF6PbtkBL33hG2pfU5F3QjcmwwS5G9p3eWvNENqbct0klP9+PI5nBLXGO+9XoAF5cBrBKt2wHjN4p42UPthnD0Vwk5emiMhsGhvuzUZKZ5PpxrSrNUdAHbiZ/dIsXitcSzQ0ssvvE8No2NRuhlC5FumYGLwrcCAy53obWIBXDEEg2C1uVxOq7iZAKpj4ZoRHL3ZWE64mAlpTMLdYNwB52s4R4yKVaXjvfyyWMhPrKNjSmxxtThRNyBC1eHrh1jU22m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It only makes sense to manipulate VMA fields if a new VMA was allocated,
rather than merged.

VMA merging does not compare vm_ops or vm_private_data, so a merged VMA
keeps its own, which is also what the legacy f_op->mmap path does since it
never touches an existing VMA.

Currently, these fields will get overwritten by whatever state is
established in the mmap_prepare hook, and if the VMA was merged,
vm_ops->mapped will not have been called, so this could destructively clear
existing state without replacing it with anything valid.

There is an implicit requirement that vm_private_data and vm_ops are
fungible across VMAs which means that losing the 'new' state is
fine.

However in this case the 'old' state is being overwritten by potentially
invalid 'new' state, so this must be rectified.

Additionally constify have_mmap_prepare while here.

All existing in-tree users either derive state for the tree or are
unmergeable due to VMA flags, so this has no direct impact.

Fixes: c84bf6dd2b83 ("mm: introduce new .mmap_prepare() file callback")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Note that this is cc: stable to account for any possible back-ports that could
break it (unlikely) or out-of-tree modules which might be affected.
---
 mm/vma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 9f0a0acf694a..6cde67883fb0 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -2849,7 +2849,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma = NULL;
-	bool have_mmap_prepare = file && file->f_op->mmap_prepare;
+	const bool have_mmap_prepare = file && file->f_op->mmap_prepare;
 	VMA_ITERATOR(vmi, mm, addr);
 	const pgoff_t anon_pgoff = addr >> PAGE_SHIFT;
 	MMAP_STATE(map, mm, &vmi, addr, len, pgoff, anon_pgoff, vma_flags, file);
@@ -2892,7 +2892,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 		allocated_new = true;
 	}
 
-	if (have_mmap_prepare)
+	if (have_mmap_prepare && allocated_new)
 		set_vma_user_defined_fields(vma, &map);
 
 	__mmap_complete(&map, vma);

---
base-commit: fe2ec83746e501645709761605c2464a44fd2929
change-id: 20260923-fix-mmap-prepare-overwrite-6304d112a4c7

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


