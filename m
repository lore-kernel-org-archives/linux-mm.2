Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39076C87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 01:54:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD6818E0003; Tue, 29 Jul 2025 21:54:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAE908E0001; Tue, 29 Jul 2025 21:54:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEAEB8E0003; Tue, 29 Jul 2025 21:54:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B13528E0001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 21:54:17 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 878161A029C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:54:17 +0000 (UTC)
X-FDA: 83719260954.05.DAF2C0E
Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	by imf22.hostedemail.com (Postfix) with ESMTP id E34CAC0006
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:54:15 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NPTnZrPV;
	spf=pass (imf22.hostedemail.com: domain of 3RnuJaA4KCK0VfNNPZNaWNeeRfTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--isaacmanjarres.bounces.google.com designates 209.85.160.73 as permitted sender) smtp.mailfrom=3RnuJaA4KCK0VfNNPZNaWNeeRfTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--isaacmanjarres.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753840455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lG4k0E4CvJtfx+IsGfUl62y++jeAVTOmiRug9CfZGl0=;
	b=Yg82hdgUyixkv6tTG/VXcu3EWaRlzGl0YEFiQrmNBMUF4/JYmb7WtcmNXcAe9ndgoHGtqo
	KBl52pqOx0kmdSsLuC5lyMFmyKhYlJiC2PfEPfBuYQe6nydKJIcvnzB8KHArzxgFCZtNvm
	AVAJeQl5boRH/c71E5tlwDitgv5aO+4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=NPTnZrPV;
	spf=pass (imf22.hostedemail.com: domain of 3RnuJaA4KCK0VfNNPZNaWNeeRfTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--isaacmanjarres.bounces.google.com designates 209.85.160.73 as permitted sender) smtp.mailfrom=3RnuJaA4KCK0VfNNPZNaWNeeRfTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--isaacmanjarres.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753840456; a=rsa-sha256;
	cv=none;
	b=cxqNheS5uhBUC5/PeyYZknTXD1KZ4EOEDZJOwGO76B4+pqzS0fjmWSBdJocR3FvK0iOl8o
	rVXDyqNSplVIS+76sOymOqdx62kvv4knSk3Wut/GPB0pV8fsgADsFfwYW+GJAs8EKpgaYo
	0uYjtiY5I/P5OlwmY+9jQA60EMIOjuM=
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-30179e8d7b9so13660673fac.1
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753840455; x=1754445255; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=lG4k0E4CvJtfx+IsGfUl62y++jeAVTOmiRug9CfZGl0=;
        b=NPTnZrPVoRazSceHdcbyPXMSq2sBfCkLextq9tm6y0IeOPiBL3V5RhELNrzo9OkohX
         GDMQI2E5TzFyksuGink0iNwLr98Crmqtr32WvAaf5RGuN1wtucfGCxp7rCkKjDnT97HX
         Fg+NNRNHfRwnnIrggaYQRmKHWXVBUIB78dzVMSFdrcG+ihip9IuMLCF1mbubCvfa39kC
         WxYvLlIpaAU/uSmEPpaFaUMp0LKLsRcNCBvn9Yg2/CN7cNzTaaYg9R6l1BWxH1wjLrn4
         R8G63WwKRiketnnSJSHPsf7U4VkdsTM4iYHSplJrAl5ySD975zPp7uDouCOB9ydhf1sV
         IbUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753840455; x=1754445255;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lG4k0E4CvJtfx+IsGfUl62y++jeAVTOmiRug9CfZGl0=;
        b=Syd62MZSUYSmGow0dRU5Z6wE1OxbnSUuj+ZdTTXLopXcOq3iB11wIz+TlCQo8zh7Uq
         kXhdpgqz0jqPvXKIhSjSNAt+r+0k9NTleTEpbdzuPnDrmxuc/wFihBLiBxVxlHa+AkPi
         TeeMNdFvg3xa6p+0LZ1Zg849Of9h+jJWN/7oMGm3wKkbE7Q8nPFDlhCPmGQCHhCYum90
         M7LcAH/gFkPsKWswdV8RvdrLABaFqaJnvo9DjaN8Z+87E5oVU2NmzT6kG0O1fbUQ+Q2+
         iTMlqBcy9VO5AR3TgqQz0SmXACvuoSGqFM8kfmuTi8VLZO0lrBV6YR5AwZt05wPV9KRU
         43zw==
X-Forwarded-Encrypted: i=1; AJvYcCUzmbqeOGsKm+1sQ7UKn0qS4gaL346p5nzpDMK4nSKmh3PogvefBZ26dlNF3E7zf1++N6GrgouJUw==@kvack.org
X-Gm-Message-State: AOJu0YwANybp58sbVUp4//LS0OhtXrpndAIkbgPPYMJDo3SPj9aipWQt
	ocCGPYejbpArk2sgjeHwtXACfh+qX9PvBt8/va3/KmVXzDyluvjN/BcslaRqOrasub84llYJkwE
	ThAmPO7ZcdzRp+ss2qr09opNGqnsXzcYsSO7xKw==
X-Google-Smtp-Source: AGHT+IG0tvC5LDotzE4hH9WyIoOwyvYrs7/BCy1U6kv/3dvQVm9TUqS7tiYQoXt9Il79jT0w0iUThrNACbuA5DwzifKAIQ==
X-Received: from oabmj8.prod.google.com ([2002:a05:6870:d88:b0:2ff:c14c:6b8e])
 (user=isaacmanjarres job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6871:6c07:b0:296:b568:7901 with SMTP id 586e51a60fabf-30785a28004mr901771fac.16.1753840454698;
 Tue, 29 Jul 2025 18:54:14 -0700 (PDT)
Date: Tue, 29 Jul 2025 18:53:59 -0700
In-Reply-To: <20250730015406.32569-1-isaacmanjarres@google.com>
Mime-Version: 1.0
References: <20250730015406.32569-1-isaacmanjarres@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250730015406.32569-2-isaacmanjarres@google.com>
Subject: [PATCH 5.10.y 1/4] mm: drop the assumption that VM_SHARED always
 implies writable
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>
Cc: aliceryhl@google.com, stable@vger.kernel.org, 
	"Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com, 
	Lorenzo Stoakes <lstoakes@gmail.com>, Andy Lutomirski <luto@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Muchun Song <muchun.song@linux.dev>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: E34CAC0006
X-Rspamd-Server: rspam06
X-Stat-Signature: ewx5ahgt5sw9rauttm68d863kngpn69i
X-HE-Tag: 1753840455-994567
X-HE-Meta: U2FsdGVkX1/N+bOWSBnnvmXAvQOgrHs5EyFsVUjAR3oFEfHRGWB7TS6fQYSEuCMLRJbscvgI+EfSn84bt/dFXUiTgUIoiY1S4i5y0tiJduNANq344rvi5C27KvUwzSyccxlAFz7urh1nhzbDLsNIz2jwyArX0IpdYGr0MzdH1b1Sg5PONY/gxMgdREHssFwr3R1PKr8j9RKFc1crM5htyRBRbCMaZnJnhENbWM8c7e92kiCGTtEeI1WnHGwcJ0H60qtVaIB5VfDALZqwxNOdIZreRyA+HGFY2Fi9q3TY7jjEs0eO0y6qgRynHWwKwKtv0QNLK/M0QFCQghsaWv63jg0KhMZ1YT0cv2hTG6UrpcRXi+1H4vggtWr8IZRjPIN14cA/SbnmI5AkGwqfdHqpa9Vb/sYY1OlpMiHU784x1c1I5UR8Bafd0+EUeO85trcbo/pfkxs3psKCQreEtmuUCQ/xZIyiE5XoItsuRMwYRH28sWd6lVPAicIrnMVuAHyRSUuphCJBer1vp3klSHf8fwJmchT+L3/zs2oLhP6CbQBVgT03j8m2XzMQh9pDdhUEf5sHG2H946CKc3gyVvfwne693mI7kV9ccxvA0VBg7iXkFKBJxzwcHDHQZVeJSVQGhTImCaKQjbCql7iT15NGTnrzBPZCXE26UWQCfBAJj6YfF2ZnNoOy2QPkKqyLN3DrY1LBLVDWseyRmwsUYG408713FAg7U5jlFcHs2HP/0/vig/GSk8MteF8vdG7u0XSC6hxsdH+sXUI6xIPjGer9BjyyqtnHZfynJWhTv541D9PcEKJkPM3DvGt7938KNk64qgfjrgsf2ST7c1eZaK2URof65+6y502ESYwZ/WUqTi1QV7UTiNuAvnExUJjFu6CLQ2U2Sz4skwidyNauPOOxMk7LM9xX0S3pzu4M4otbFyCI4T8ysucoValjPMLI0++CDLAqNj2Ld3yXlsCQQtf
 3wwvS/Hw
 pWDh1WvZqddYVBvLhlJyqO6lVCOiTNCow11kSXv+jvvNdxeYf8u40ULNWesitGpLkVpuS/Kz6+mjPlAAvnH+qDG7pda2QICTAZ1TZdWi7zNuqDXu2IaIEAFZBlAlSTs0mO1/UmzKYdg6LZYFQA5JnP3ntcOis3gu1ur0IfW6uQ7mXFrlFLWFdXYEGVer0mtLmfULv9BFxaOu0MZgJDAOCQ5WmxPbdtu5AlqdsEDoh1lpWjIK+11xf5DtyZxAawATfuPD63LnZWID7ChORax5VugLhaE/EOOcuMbty4BzcPNSSgra/ipKoTdTHEg/Aavd1TpVk7+DskKl7xH+Jo0oMVGU0XkZfqYmbAhYLG1ERQozhZcBkMhiw3YnEp47VfklAUhXS0z0Iu+YtSHwhV/4uOZEX1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <lstoakes@gmail.com>

[ Upstream commit e8e17ee90eaf650c855adb0a3e5e965fd6692ff1 ]

Patch series "permit write-sealed memfd read-only shared mappings", v4.

The man page for fcntl() describing memfd file seals states the following
about F_SEAL_WRITE:-

    Furthermore, trying to create new shared, writable memory-mappings via
    mmap(2) will also fail with EPERM.

With emphasis on 'writable'.  In turns out in fact that currently the
kernel simply disallows all new shared memory mappings for a memfd with
F_SEAL_WRITE applied, rendering this documentation inaccurate.

This matters because users are therefore unable to obtain a shared mapping
to a memfd after write sealing altogether, which limits their usefulness.
This was reported in the discussion thread [1] originating from a bug
report [2].

This is a product of both using the struct address_space->i_mmap_writable
atomic counter to determine whether writing may be permitted, and the
kernel adjusting this counter when any VM_SHARED mapping is performed and
more generally implicitly assuming VM_SHARED implies writable.

It seems sensible that we should only update this mapping if VM_MAYWRITE
is specified, i.e.  whether it is possible that this mapping could at any
point be written to.

If we do so then all we need to do to permit write seals to function as
documented is to clear VM_MAYWRITE when mapping read-only.  It turns out
this functionality already exists for F_SEAL_FUTURE_WRITE - we can
therefore simply adapt this logic to do the same for F_SEAL_WRITE.

We then hit a chicken and egg situation in mmap_region() where the check
for VM_MAYWRITE occurs before we are able to clear this flag.  To work
around this, perform this check after we invoke call_mmap(), with careful
consideration of error paths.

Thanks to Andy Lutomirski for the suggestion!

[1]:https://lore.kernel.org/all/20230324133646.16101dfa666f253c4715d965@linux-foundation.org/
[2]:https://bugzilla.kernel.org/show_bug.cgi?id=217238

This patch (of 3):

There is a general assumption that VMAs with the VM_SHARED flag set are
writable.  If the VM_MAYWRITE flag is not set, then this is simply not the
case.

Update those checks which affect the struct address_space->i_mmap_writable
field to explicitly test for this by introducing
[vma_]is_shared_maywrite() helper functions.

This remains entirely conservative, as the lack of VM_MAYWRITE guarantees
that the VMA cannot be written to.

Link: https://lkml.kernel.org/r/cover.1697116581.git.lstoakes@gmail.com
Link: https://lkml.kernel.org/r/d978aefefa83ec42d18dfa964ad180dbcde34795.1697116581.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
[isaacmanjarres: resolved merge conflicts due to
due to refactoring that happened in upstream commit
5de195060b2e ("mm: resolve faulty mmap_region() error path behaviour")]
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
---
 include/linux/fs.h |  4 ++--
 include/linux/mm.h | 11 +++++++++++
 kernel/fork.c      |  2 +-
 mm/filemap.c       |  2 +-
 mm/madvise.c       |  2 +-
 mm/mmap.c          |  6 +++---
 6 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9463dddce6bf..11294a89a53b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -436,7 +436,7 @@ int pagecache_write_end(struct file *, struct address_space *mapping,
  * @host: Owner, either the inode or the block_device.
  * @i_pages: Cached pages.
  * @gfp_mask: Memory allocation flags to use for allocating pages.
- * @i_mmap_writable: Number of VM_SHARED mappings.
+ * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
  * @nr_thps: Number of THPs in the pagecache (non-shmem only).
  * @i_mmap: Tree of private and shared mappings.
  * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
@@ -535,7 +535,7 @@ static inline int mapping_mapped(struct address_space *mapping)
 
 /*
  * Might pages of this file have been modified in userspace?
- * Note that i_mmap_writable counts all VM_SHARED vmas: do_mmap
+ * Note that i_mmap_writable counts all VM_SHARED, VM_MAYWRITE vmas: do_mmap
  * marks vma as VM_SHARED if it is shared, and the file was opened for
  * writing i.e. vma may be mprotected writable even if now readonly.
  *
diff --git a/include/linux/mm.h b/include/linux/mm.h
index e159a11424f1..2bedc9940c47 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -666,6 +666,17 @@ static inline bool vma_is_accessible(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_ACCESS_FLAGS;
 }
 
+static inline bool is_shared_maywrite(vm_flags_t vm_flags)
+{
+	return (vm_flags & (VM_SHARED | VM_MAYWRITE)) ==
+		(VM_SHARED | VM_MAYWRITE);
+}
+
+static inline bool vma_is_shared_maywrite(struct vm_area_struct *vma)
+{
+	return is_shared_maywrite(vma->vm_flags);
+}
+
 #ifdef CONFIG_SHMEM
 /*
  * The vma_is_shmem is not inline because it is used only by slow
diff --git a/kernel/fork.c b/kernel/fork.c
index 6ece27056fe9..cdf28ac44879 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -561,7 +561,7 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 			if (tmp->vm_flags & VM_DENYWRITE)
 				put_write_access(inode);
 			i_mmap_lock_write(mapping);
-			if (tmp->vm_flags & VM_SHARED)
+			if (vma_is_shared_maywrite(tmp))
 				mapping_allow_writable(mapping);
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
diff --git a/mm/filemap.c b/mm/filemap.c
index 3b0d8c6dd587..b98af5680bb9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2959,7 +2959,7 @@ int generic_file_mmap(struct file * file, struct vm_area_struct * vma)
  */
 int generic_file_readonly_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE))
+	if (vma_is_shared_maywrite(vma))
 		return -EINVAL;
 	return generic_file_mmap(file, vma);
 }
diff --git a/mm/madvise.c b/mm/madvise.c
index a63aa04ec7fa..370d0ef719eb 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -848,7 +848,7 @@ static long madvise_remove(struct vm_area_struct *vma,
 			return -EINVAL;
 	}
 
-	if ((vma->vm_flags & (VM_SHARED|VM_WRITE)) != (VM_SHARED|VM_WRITE))
+	if (!vma_is_shared_maywrite(vma))
 		return -EACCES;
 
 	offset = (loff_t)(start - vma->vm_start)
diff --git a/mm/mmap.c b/mm/mmap.c
index 8c188ed3738a..3cc0d56e41ad 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -144,7 +144,7 @@ static void __remove_shared_vm_struct(struct vm_area_struct *vma,
 {
 	if (vma->vm_flags & VM_DENYWRITE)
 		allow_write_access(file);
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_is_shared_maywrite(vma))
 		mapping_unmap_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
@@ -663,7 +663,7 @@ static void __vma_link_file(struct vm_area_struct *vma)
 
 		if (vma->vm_flags & VM_DENYWRITE)
 			put_write_access(file_inode(file));
-		if (vma->vm_flags & VM_SHARED)
+		if (vma_is_shared_maywrite(vma))
 			mapping_allow_writable(mapping);
 
 		flush_dcache_mmap_lock(mapping);
@@ -2942,7 +2942,7 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 		return -EINVAL;
 
 	/* Map writable and ensure this isn't a sealed memfd. */
-	if (file && (vm_flags & VM_SHARED)) {
+	if (file && is_shared_maywrite(vm_flags)) {
 		int error = mapping_map_writable(file->f_mapping);
 
 		if (error)
-- 
2.50.1.552.g942d659e1b-goog


