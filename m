Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66E40C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 08:38:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 462936B00A4; Wed,  8 Jul 2026 04:38:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 413736B00A7; Wed,  8 Jul 2026 04:38:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 329D16B00A9; Wed,  8 Jul 2026 04:38:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F35A76B00A4
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 04:38:35 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A154C419F
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:38:35 +0000 (UTC)
X-FDA: 84964958190.19.F06F431
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id 98220A0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 08:38:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i+IMVPEu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783499913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=YpkkoaSl0O2AaMEcTuxDfNe4rT/5zh+FKCaNy9UkAKw=;
	b=bd/cpr0UVoNwW2k61GSwOQvggPJI5dkPBw/2FhtDy0JbRj+O73//46hRU6Kt0UXaXrHtK5
	ct30tjImiZQEUcwBgLKAE5JDrTwNTqRDBcJqdnunp0hQZcKIk1+kMjXPSX1M3qtwNJab3Q
	JfmC4W1JWAe7xKSO5roj8ry3aBhzNuo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i+IMVPEu;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of thehajime@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=thehajime@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783499913;
	b=LMTbx0MAPCpPG+xpWEicExrjQZZa0MmQKhATIPnnzDNknv2/aaM/vJoDt9yq8xhqf2Oi5h
	oraUSK7lX/8w8VMy8u+zVTEj2kdiZnkK2hr8yEgcX9hbxs5bjYtNm3dNAhZetBBRH/34ms
	jihaQnmuLKHbj7+Ko0o+d54eupPh5Eg=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-845ea8924a2so435122b3a.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 01:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783499912; x=1784104712; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=YpkkoaSl0O2AaMEcTuxDfNe4rT/5zh+FKCaNy9UkAKw=;
        b=i+IMVPEu+SZB5VGz6xXdS+rpV6ICgFRUdFjKt/tmPSY67sXRPNXKv47IeiqLSnxeom
         RnqS/e+EQfIzHOtMxAwJ/D8LVAcqyatGYH7rwhABm07Se7kSSWscm/Bi7mviVND6k2O1
         8dZe2LOp2oGyk8AWfA5FhJPIBJh2QRL/TDIZbddKgUPEJjak2fG88nwpugQZ8Fe/anWn
         hE0XGarkgZcN/wljS9cz4A2TqH3zubOQS/+6y+lRNzcsOr+ufhyCxWxKDhx51Z6SiqeD
         UBWAaoW3JX4BJvXd7TxDGTNNd4zaAxPWsmpM15lcQEur+UE3FDJIWlZtthqtGsMpTlGE
         NXHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783499912; x=1784104712;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=YpkkoaSl0O2AaMEcTuxDfNe4rT/5zh+FKCaNy9UkAKw=;
        b=SToWaEvzWpzHMqVaQSxGiRbIlQaqfG36AD7jYUiH7nmv/7QM6AUDeqP/7/3qEpRSam
         +V/N5t/ZjGC/iBf9fdMXtt0SKmOLMFvNunuG1HHq67ZEnU+VS6ZxkVfdaRmpXo/sRayl
         aBF7wPcLGFrnvyIOhy2H0iSe6ZzcWwichwUuvBHHKrP6yraqz/ynPWn/tUJ+xsxH32JU
         1hOrlK/0sHhAhPwK6N+YJJ71A4oZJe82dPquwKvUL1kwivqdBNPMONryZqBjV+qIflA6
         C8vAc2PDJMMHzTPOey+t62v3F4W6vhtjAKYUb1Od3I7ZHDRLHkl8Oimw7qcgVpwwf1xI
         nqgg==
X-Forwarded-Encrypted: i=1; AHgh+Rp0Dz1O42OnbipEQV39JT7xnzcRrl9Ia8OcX3AQ/elvHgMrDps9tUlBv/E/c2vPzqxi/FbOhzrxcQ==@kvack.org
X-Gm-Message-State: AOJu0YyjcEakPyyFOtze4VmRjnBU2esVGwxMONTgF6ucLVTRA52Pkurf
	NIi+7yztqju4OvJ70YluQuydIULdt0JowraePMFSRnbB4x9ia+77DP2k
X-Gm-Gg: AfdE7cllKyWNTeJWoKUzfV3jZgmD6KoaVJ42EKnCtqi6SBmgTKySprJ4sfmGKY62RvG
	57CY97AExNU7QbBOQwzL98HtJWIZGTHrQNfHXnXt/BXt3ojQe2oSbicoWKcFftaNE08ORhrfx3Q
	hOvpmqM1vx/mQ52/vkJpn8+Ozp4Lw/fL2ECh2ywx64koHSg0Uk5O+7dsNyQJaqrgvBWNeVY0nyz
	XtjqjER/+mrELmaeuzeDID4Dhqt8pXnN7MUuCxjQWwTqUOg4o04kbzoxOySHqwNmsH+ONvi9skY
	rDsPvExbRbURfxGYSSJmocWkLzfLDIyK3ycaSP0mhHVwYi4oJgSfZw5Gdg1FDGHQx2teExf+I7h
	ctaInr6ARgLiuKJRrXEKCN86hwcHLP01Kr18Y5zvPAdDoZC7ewhlY9G5Xjrvqi0XxgGBBUZfTiH
	doJaa8apBE+G0gY6CcH2D5DtH5uqFzM/N23BiDkWcNtRe0++U/GThZ3xK4iuRfC7mXm0V3Mo9+s
	ynxbWcKWjBvVbY+rwChS9epjPs3
X-Received: by 2002:a05:6a00:1396:b0:845:39dd:f773 with SMTP id d2e1a72fcca58-84842fdf963mr1745490b3a.7.1783499912247;
        Wed, 08 Jul 2026 01:38:32 -0700 (PDT)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-847f6d4dbdesm6672431b3a.31.2026.07.08.01.38.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 01:38:31 -0700 (PDT)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id E30A714914F8; Wed,  8 Jul 2026 17:38:30 +0900 (JST)
From: Hajime Tazaki <thehajime@gmail.com>
To: akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	pfalcato@suse.de,
	linux-mm@kvack.org,
	geert@linux-m68k.org
Cc: linux-kernel@vger.kernel.org,
	Hajime Tazaki <thehajime@gmail.com>
Subject: [PATCH v3] mm: nommu: fix the error path when vma_iter_prealloc() fails
Date: Wed,  8 Jul 2026 17:38:29 +0900
Message-ID: <20260708083829.576036-1-thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 98220A0005
X-Stat-Signature: wu83mzkpqb85edrsn4jkwx816nztq834
X-Rspam-User: 
X-HE-Tag: 1783499913-221928
X-HE-Meta: U2FsdGVkX1+NOR3p0BheKzjgBLzuWjw+yIon5lty0G5/aSO1bovOI2MoqKMZv2Yolb7OHwM35kQES4OSTz/FSAefT/Fi27+fLScKdPiEKd9REwU4iCLKhELuJZmAvd7S0LXAQC3PJ24bGJCDO3HWvPeFMJgu0sPiMzH0hToUmifpsYUYr3aeD92z8d6nhuZXTqWJcNbyBcsr2aWsc1jV4JdNKsucYDjcL7RiJT75Oe0f1/LYh0WUPywFdg8EbJWeGe+C+sQsb0Ft3a4R84xlPzkwT14TfWCHkN9rrI7pmcW6E4Y+L92HfKZgzfq9fsQBj46+FxveFKlG+W3n4stKNlrbWxiKUCqQzck20CzAAwM1MhsnjshhBGaacrpsSTMDF0Npha1r/FF3NfVJMkM5u6JPsORw3KUX84+4E0YVWya4ruhk0DBj8VIl67QjBiA2kXqGu0w9wfeYVmZC3F6jhI/1YZ70DZcsEadkdJfnTesrm5ul8pRW362+gSIPaCdywfdYF3AzaPrxcIXRAeK8sSsIOyiwEEr9nKGImtPWKOMPrLIpYu3yHt/5dwvXWE92dGCLcC7ryvATm4fAsclntc6oSPRmAiWSvexKyJ0mpajptyNLWo/4AqvUx6qNQt1XmLxNCGHTzB6fNHeTJw2octfkSOI/1PZirX8m+jyD8mVIVDOPtRvEYSxmKGWIUdR0kfWMhKjksE83KdcSkA2zcmu/1hArBgqwKfJN1peDhpAwMbiWYHveaWemcJ/5koSzizGUaesFuVhB2sz0thq7oUg2nl6A76FICHb27PGOTKKApRtxQlyspzMH3b9X9TmIr0+zIjDvPNW4d+T8vfI9DeJ/kvMALL9Da3U9NVdgkw0roJqQeT4AoMLZzr8JiqaZdkA+hGy2IOes0SiC7nT1WUJMl7ZZsUeGH8UIeTyjWdqNTLnKFo4y5bkE/Gj47quW6hMOv7C1/+m1iui+Z8n
 iHK8EqVP
 RsZPhghI45WLAsGt+l/ixRul2G16S9BmjsvyVb1eNO+eJRBMSvKVC2/fB2toBR1kzz1d2cgODNSHSH3se/apim7sptzOSDzyLiVSg8bV9qWb1TMqm03aLmQ8meRQ32KCAIkC2KfUB0rMwENB4RONsPY2KzMcOyJpmQ1ZBZ8ohsz3vqzvDbTIgSYQHnnNlzGHSpNIE14BRqHyK9+0KcvJ7DGPdgvAOwVKDdCmzW2oIuvwRn8l513Rgy1ta8F+/KMlumbkxw8BVx7ySVZH80LQbiIWE9BAvBryQdDIk+OJGYMDUwmk5rH4yDXY9Umt2KrSD1T5HLAlZCYSLkWJSxpVdXyrxmveFc0DXtLoj9oEWFMgXOg9VSHSt+i2YbeVmjHTno0mOQ0san0ghZ4/sVuS0UkH22uwl6DFtcAWSavUMpIlgdPRl2oECtBKfyJSR4mYKMu0mHIjBU6VdIBP/DLRmI3zBaghKwDQP8FFiVwT5OEWsTNtyD4Jnxs/+NaI7CcUeLizl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When vma_iter_prealloc() fails in do_mmap(), it jumps to error_just_free
as a error path of this function, but there are several possible issues.

1) It jumps to error_just_free without updating ret to -ENOMEM, meaning
do_mmap() will return 0 on failure.

2) The error path unconditionally frees the region struct.
Since the region was already added to the global nommu_region_tree via
add_nommu_region(), leaving it makes a potential dangling pointer in
the tree and may cause a use-after-free on the next tree walk.

3) If do_mmap() finds an existing overlapping shared region, it
increments its usage, sets region to this existing pregion, and jumps to
share:

	region = pregion;
	result = start;
	goto share;

When vma_iter_prealloc() fails and jumps to error_just_free, the error
path unconditionally frees the region:

error:
	...
	if (region->vm_file)
		fput(region->vm_file);
	kmem_cache_free(vm_region_jar, region);

This potentially leaves a dangling pointer in nommu_region_tree and
causes RB-tree corruption.

4) When establishing a new private mapping, do_mmap_private() allocates
physical pages and assigns them to region->vm_start:

	base = alloc_pages_exact(total << PAGE_SHIFT, GFP_KERNEL);
	...
	region->vm_start = (unsigned long) base;

If we later fail at vma_iter_prealloc() and jump to error_just_free, the
region struct is freed, but the backing physical memory isn't freed via
free_page_series().

5) In the error label of do_mmap(), the vm_area_struct allocated is
freed by vm_area_free(vma) but not called after vma_close(), leaving
potential memory leak which should be handled by a custom .close handler
of vm_ops.

This commit fixes those issues by introducing new jump label,
error_vma_iter_prealloc, to correctly handle the error case of
vma_iter_prealloc(), updating ret value (1), and move the region updates
after the place that the allocation is finished (2).

Additionally, the commit removes the existing goto label, error, and
consolidates to error_just_free as existing `goto error;` code blocks
always release nommu_region_sem.

Moreover, it only frees region allocated in this request to avoid
freeing the shared, existing region shared by other processes (3), and
free physical memory when do_mmap_private() allocates (4). It also add
vma_close() before vm_area_free() to fix the potential leak (5).

Those issues are discovered by Sashiko, linked below.

Link: https://sashiko.dev/#/patchset/20260702012830.667205-1-thehajime%40gmail.com
Link: https://sashiko.dev/#/patchset/c8513ee5aa8444ec9bf6c276043c9f833016a2fa.1783304131.git.thehajime%40gmail.com
Link: https://sashiko.dev/#/patchset/20260707235137.498738-1-thehajime%40gmail.com
Fixes: b5df09226450 ("mm: set up vma iterator for vma_iter_prealloc() calls")
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>

--

v3: address another sashiko review.
https://sashiko.dev/#/patchset/20260708052820.556085-1-thehajime%40gmail.com
v2: consolidate commits into a single patch, address additional Sashiko
review (sorry for the noise: i have no working local environment of
sashiko/gemini)
    https://lore.kernel.org/linux-mm/20260708052820.556085-1-thehajime@gmail.com/
v1: https://lore.kernel.org/linux-mm/20260707235137.498738-1-thehajime@gmail.com/
---
 mm/nommu.c | 36 ++++++++++++++++++++++++++++--------
 1 file changed, 28 insertions(+), 8 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 815ebefddfae..852ec9bd0505 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1181,7 +1181,6 @@ unsigned long do_mmap(struct file *file,
 		ret = do_mmap_private(vma, region, len, capabilities);
 	if (ret < 0)
 		goto error_just_free;
-	add_nommu_region(region);
 
 	/* clear anonymous mappings that don't ask for uninitialized data */
 	if (!vma->vm_file &&
@@ -1199,7 +1198,9 @@ unsigned long do_mmap(struct file *file,
 	BUG_ON(!vma->vm_region);
 	vma_iter_config(&vmi, vma->vm_start, vma->vm_end);
 	if (vma_iter_prealloc(&vmi, vma))
-		goto error_just_free;
+		goto error_vma_iter_prealloc;
+
+	add_nommu_region(region);
 
 	setup_vma_to_mm(vma, current->mm);
 	current->mm->map_count++;
@@ -1218,22 +1219,41 @@ unsigned long do_mmap(struct file *file,
 	return result;
 
 error_just_free:
+	vma_close(vma);
+	/* if the error was from shared mapping/existing region, don't free the region.
+	 * this has to be before releasing semaphore.
+	 */
+	if (region->vm_usage == 1) {
+		if (region->vm_file)
+			fput(region->vm_file);
+		kmem_cache_free(vm_region_jar, region);
+
+	} else
+		region->vm_usage--;
+
 	up_write(&nommu_region_sem);
-error:
 	vma_iter_free(&vmi);
-	if (region->vm_file)
-		fput(region->vm_file);
-	kmem_cache_free(vm_region_jar, region);
+
 	if (vma->vm_file)
 		fput(vma->vm_file);
 	vm_area_free(vma);
 	return ret;
 
 sharing_violation:
-	up_write(&nommu_region_sem);
 	pr_warn("Attempt to share mismatched mappings\n");
 	ret = -EINVAL;
-	goto error;
+	goto error_just_free;
+
+error_vma_iter_prealloc:
+	pr_warn("Allocation of vma iterator for process %d failed\n", current->pid);
+	show_mem();
+	ret = -ENOMEM;
+
+	/* in case that the region is allocated via do_mmap_private() */
+	if ((region->vm_usage == 1) && (region->vm_flags & VM_MAPPED_COPY))
+		free_page_series(region->vm_start, region->vm_top);
+
+	goto error_just_free;
 
 error_getting_vma:
 	kmem_cache_free(vm_region_jar, region);
-- 
2.43.0


