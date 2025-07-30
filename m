Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CD76C87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 01:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162F56B0092; Tue, 29 Jul 2025 21:52:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 112726B0093; Tue, 29 Jul 2025 21:52:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 001C66B0095; Tue, 29 Jul 2025 21:52:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF46F6B0092
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 21:52:28 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 88EB51601BC
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:52:28 +0000 (UTC)
X-FDA: 83719256376.02.1605E43
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	by imf15.hostedemail.com (Postfix) with ESMTP id 920DFA0002
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:52:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WbH7Thx+;
	spf=pass (imf15.hostedemail.com: domain of 32XqJaA4KCEAkucceocplcttguiqqing.eqonkpwz-oomxcem.qti@flex--isaacmanjarres.bounces.google.com designates 209.85.128.202 as permitted sender) smtp.mailfrom=32XqJaA4KCEAkucceocplcttguiqqing.eqonkpwz-oomxcem.qti@flex--isaacmanjarres.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753840346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AA3tqwZAYn4iYWY4gZnS2TnDx/Uhfk7tBeQY06ar3TU=;
	b=ubnp76Lqoqv2//PVbtzkO4HDzCyyH4kHk9Lry5grY9i9FpCyK2/akUx3jGH8B+SyYVRomk
	EWLrRASDPL6AGdch9MxcBcF5VsiyrSl1FHVGhKfXT28KT1sbXP0AkPBSVnvjqf4d4ELzkc
	kkPDn4YGA6aso+5rFbuCObD8udvY6zk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753840346; a=rsa-sha256;
	cv=none;
	b=zgUfFA/RFc2Dzcj9G4wz+XQOXNxgz8sSiURkc3gEbIfwnuC9N94GlDNaLD3kaM3iswRBdm
	3EwVQMeZj8fiznOijfg3lkTfFIi9ajFaKRUxw4VyDRWslohcs8lM1aHYKdpyREjjsARrRJ
	Bij3AaOK5cfmg+6m8qcME6fxcfItlX4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WbH7Thx+;
	spf=pass (imf15.hostedemail.com: domain of 32XqJaA4KCEAkucceocplcttguiqqing.eqonkpwz-oomxcem.qti@flex--isaacmanjarres.bounces.google.com designates 209.85.128.202 as permitted sender) smtp.mailfrom=32XqJaA4KCEAkucceocplcttguiqqing.eqonkpwz-oomxcem.qti@flex--isaacmanjarres.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-713e879bd7cso80844247b3.0
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753840345; x=1754445145; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=AA3tqwZAYn4iYWY4gZnS2TnDx/Uhfk7tBeQY06ar3TU=;
        b=WbH7Thx+kqkVUHrzQ8PbAXAAdrgPNhme59F9PiFrORs50n//7yAUD80L9hsQCwYlNV
         JMhxDrny8bXhRMCAhl2ugPojr3tt9zZhZm0CeS8NJTYimwkBr38Lgd0UJWQxFumm/r2b
         e4KX1twaw3fYoTAzXQBhzcY/KVguymWzoHojGonE/+itGj8+NO+s+WWI7ivXumsySwR2
         bJJoz4Q1OZ5UETLMIq/8AusajHn41wNhmkd3+kmWfDnJilefvtXwuSPRGkRB/gcpe6nW
         gjIvuMTimQSN8xTAPj+8jCleSyzJGE8nO9b14Y+VLBXL+T6wYtDJ1UQNNtxNSDIhazJq
         gagA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753840345; x=1754445145;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AA3tqwZAYn4iYWY4gZnS2TnDx/Uhfk7tBeQY06ar3TU=;
        b=HWtzbuktxEPBXEoe3nurvUmRGI75jZnHd3EF5HOh28wV7w8IDZ39QWTZg1KA64RAEW
         a79zhacq1AjOh8dcESlSE0rSMXMpWfQ4E1+qmzkoYK8Y8AzFW+9ieWUcwLfyTYkS4XqY
         46uQl1fD1cX0FBw+jZe4WPikeY1Mju0LdiWx1l4z9yqp4y2SP+4dxwk2///sfCMSN9mR
         e8Cuv2faNPeAVEVn3xxe2N5Et1irwTQ+LL4lqbeN5JVjSwczC7wFqlBdQEEFwu7Tk8/J
         Chp2eVB4L72tImuGTwXNNhzjWJvAMtf8qLo4OophH9tvbNBBZtYORcNzYuQfyzKspyzi
         jebw==
X-Forwarded-Encrypted: i=1; AJvYcCXt89eaE4YD35kdSCBPGynVXLgZYzv5nQwA95O7WlvqeW/nuygvfma3g9EwEjd1chzakq1GhBPWog==@kvack.org
X-Gm-Message-State: AOJu0YypbUtlRhLL/l1VVhceP2cmKOzcNCyCS04T7LLoif4IqyFHxO0u
	f5/CfcLfQ0oklbu/hmKwJhnKDu+y/17fmCutok54CajqGbFoPKXnyotcVSkpUdP7DGOJMYR3APN
	zmvhtP1UNzWIB5LOnSNOdE+5/g7OYfJEM2f5icw==
X-Google-Smtp-Source: AGHT+IFN0NxB+ZPpjQbg9OjOCHaSNw5JP5NzhGugQD1VX9N+qSsWv5fy9DdXmUxNKYMeHXMinUiUJAtxrOorcoRQ/t7Mbw==
X-Received: from ybbd9.prod.google.com ([2002:a05:6902:4a89:b0:e8d:e2f3:3cfb])
 (user=isaacmanjarres job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:690c:6304:b0:719:5d76:742 with SMTP id 00721157ae682-71a46521ffcmr33189837b3.2.1753840345590;
 Tue, 29 Jul 2025 18:52:25 -0700 (PDT)
Date: Tue, 29 Jul 2025 18:51:47 -0700
In-Reply-To: <20250730015152.29758-1-isaacmanjarres@google.com>
Mime-Version: 1.0
References: <20250730015152.29758-1-isaacmanjarres@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250730015152.29758-4-isaacmanjarres@google.com>
Subject: [PATCH 6.6.y 3/4] mm: reinstate ability to map write-sealed memfd
 mappings read-only
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: aliceryhl@google.com, stable@vger.kernel.org, 
	"Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com, 
	Julian Orth <ju.orth@gmail.com>, "Liam R. Howlett" <Liam.Howlett@Oracle.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Shuah Khan <shuah@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 920DFA0002
X-Stat-Signature: utcrgzqory3x33c9tr7aa751c7ryhbrp
X-Rspam-User: 
X-HE-Tag: 1753840346-387271
X-HE-Meta: U2FsdGVkX1+RGtSsolD7OpKYD0K7KXFIy028Jgz1Tb5rFp8OzAIsklBSGsWsOQrH+4rV8Zw6xa4I/bt9Pv8dF0/r3MsBzecy0d/dhj/XX1zc05r+roAKKRGS56YGPcqRcWtp2htToAIxmKO7TI1eJGBmVaeEOemGamuZu3i++oo5Kv2X5Ytn+v9hAtlxa7w5jrB08apZmOClIj66Gm6G8CctFvmN+ZVssfIYHs8OCRLz/t7MinTOxSr5VpJYIPFb6x7bRX+4lRz8Eq3xquFF+Vd/Rse47YEeZcQ7jZAhIHhfoApdLJKM9le4BOoU1ott8K8JqdrjaVT1kml75TkKC3jOXaZrCnut9+ygRJLquAqK/OpjiEgHIiUyfH0ydGN/ujVV1fR8i9uH0BOwhURK3HHy1erek1svltb35tmqFKPXGoOxMVaz5lBGJ8X7ChDXhH1+qm+kvk2PyHilftEWdnviemjZH7/3lc7VI2DPUv+Qgdnhw+I/by1OW3uLBPNi/uUKsMSx8Xln6fuWzAulslN4RiQl5bFxohIN8Ve0/nnrt9rYjQdYkXQjWYmLIMaXcwkE+DkUlCy31s+s5llIf/sy+jWY++rpiX8oAdSJire9ESFzMwO7rNQ9dkkt5uksVcwXCP/d8134ooLTmTstVMtXk8kxJmsLgQHq7uL3ycQDWHM1OfLH+iVFYQZWJcG+4hoJTB1z/1wybGSgitA+LeS2QLAk+LLV3vUlABj9BpI9KOLDGCUS7w8axv60mW9PImyiAZYJ3UvKA7zZBjh2+oTDdEpLGsXYrT9e6kYRdd/i7o4u5VXAttf9+KfQ2Vx6eLZ1dg2zib7YY4RGJZR14YAXAH2nrNVlDt+V/5lw/wr2LHsPpyexsoZNhpSgfuLr7WK/HEJCNif2qdPZElrBpy1Hce5CtKnoCGNf/IAkAL7PpoOk8IVILqWpbGIDbFBQ6hiD+aVMdqd7lcPyIHr
 xRlo3DuJ
 +TcG0542fSgGJOJ36mYf9oYQyYPEDQTY7v94kyi62bjcdEWYJZ4eDrDxJfFu+LwoHNk5D9vq4Gs+YVUhtBz08gpqNzEgrzlL6FZqFanmpqKrvfGpkq9Jt8gYl7uvT3yieAqToZOTYQO7CdyZr3XSiDXf4QEmSvXCqGr32SN8WnFQ2X+TpSolDzdqoXfLHyfUqbamCoX+68hgpXXJzagwzErbfrXv+roW9YozNe2pMXEfTJ/xTBinKowNUF2lPWNX/NTu7He14saiRe/zS8IjLG4p6c/T9bEZ3+/MpCtJtzHcWre54a4/utdbEJawqoQhaYyRVnIpDEpK/ajzR9h3LYpvqLnK8SmLWirQ08euS/KMXeLUolEfo8is3su7bRxslIUoq4GkSdE+IO+czn2/J4sFJI1l3Q5Znh5ryC/JtxP9AwyO7G6DpV7GYk0MnPwaYWruMp9Wc5yAnB7LbLTzHWyVxBQMQitwa/HGoxGaLUt9RHlOOkhsr8vdp4esK03nLLSgAhWrPnlZiLLLws2FqcTKs75906zX61t8N037nTWEqhW9N5HPfcx0nOk6wJGHlbfGZTvBed346tSmrVt4Xfg6hmecjBCHNc+ZD+0DIv+MCB2kYal4s3rCTLMBdU1nC65itYz6Z8MDrHyP2yUYd+Tw4iB/mQ/iOecFo2nhDiAT/mTi3zAdjRDJ93k6jjrsKv9lVKKy1szIw+QgylC597s+NzCT1Un8222WjTSEhRvKHiGMZ8Ppmg8lU1zvqMDLvfWAkWMr87LyW30Qov7A2hZMjaiC+e8XKjhe51TkRgFbthph7AuBqvcTMCmgzQ/161Co3JC9Gxn4DznwToKvUMdZrAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

[ Upstream commit 8ec396d05d1b737c87311fb7311f753b02c2a6b1 ]

Patch series "mm: reinstate ability to map write-sealed memfd mappings
read-only".

In commit 158978945f31 ("mm: perform the mapping_map_writable() check
after call_mmap()") (and preceding changes in the same series) it became
possible to mmap() F_SEAL_WRITE sealed memfd mappings read-only.

Commit 5de195060b2e ("mm: resolve faulty mmap_region() error path
behaviour") unintentionally undid this logic by moving the
mapping_map_writable() check before the shmem_mmap() hook is invoked,
thereby regressing this change.

This series reworks how we both permit write-sealed mappings being mapped
read-only and disallow mprotect() from undoing the write-seal, fixing this
regression.

We also add a regression test to ensure that we do not accidentally
regress this in future.

Thanks to Julian Orth for reporting this regression.

This patch (of 2):

In commit 158978945f31 ("mm: perform the mapping_map_writable() check
after call_mmap()") (and preceding changes in the same series) it became
possible to mmap() F_SEAL_WRITE sealed memfd mappings read-only.

This was previously unnecessarily disallowed, despite the man page
documentation indicating that it would be, thereby limiting the usefulness
of F_SEAL_WRITE logic.

We fixed this by adapting logic that existed for the F_SEAL_FUTURE_WRITE
seal (one which disallows future writes to the memfd) to also be used for
F_SEAL_WRITE.

For background - the F_SEAL_FUTURE_WRITE seal clears VM_MAYWRITE for a
read-only mapping to disallow mprotect() from overriding the seal - an
operation performed by seal_check_write(), invoked from shmem_mmap(), the
f_op->mmap() hook used by shmem mappings.

By extending this to F_SEAL_WRITE and critically - checking
mapping_map_writable() to determine if we may map the memfd AFTER we
invoke shmem_mmap() - the desired logic becomes possible.  This is because
mapping_map_writable() explicitly checks for VM_MAYWRITE, which we will
have cleared.

Commit 5de195060b2e ("mm: resolve faulty mmap_region() error path
behaviour") unintentionally undid this logic by moving the
mapping_map_writable() check before the shmem_mmap() hook is invoked,
thereby regressing this change.

We reinstate this functionality by moving the check out of shmem_mmap()
and instead performing it in do_mmap() at the point at which VMA flags are
being determined, which seems in any case to be a more appropriate place
in which to make this determination.

In order to achieve this we rework memfd seal logic to allow us access to
this information using existing logic and eliminate the clearing of
VM_MAYWRITE from seal_check_write() which we are performing in do_mmap()
instead.

Link: https://lkml.kernel.org/r/99fc35d2c62bd2e05571cf60d9f8b843c56069e0.1732804776.git.lorenzo.stoakes@oracle.com
Fixes: 5de195060b2e ("mm: resolve faulty mmap_region() error path behaviour")
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Reported-by: Julian Orth <ju.orth@gmail.com>
Closes: https://lore.kernel.org/all/CAHijbEUMhvJTN9Xw1GmbM266FXXv=U7s4L_Jem5x3AaPZxrYpQ@mail.gmail.com/
Cc: Jann Horn <jannh@google.com>
Cc: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
---
 include/linux/memfd.h | 14 +++++++++++
 include/linux/mm.h    | 58 +++++++++++++++++++++++++++++--------------
 mm/memfd.c            |  2 +-
 mm/mmap.c             |  4 +++
 4 files changed, 59 insertions(+), 19 deletions(-)

diff --git a/include/linux/memfd.h b/include/linux/memfd.h
index e7abf6fa4c52..40cc726a8a0c 100644
--- a/include/linux/memfd.h
+++ b/include/linux/memfd.h
@@ -6,11 +6,25 @@
 
 #ifdef CONFIG_MEMFD_CREATE
 extern long memfd_fcntl(struct file *file, unsigned int cmd, unsigned int arg);
+unsigned int *memfd_file_seals_ptr(struct file *file);
 #else
 static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned int a)
 {
 	return -EINVAL;
 }
+
+static inline unsigned int *memfd_file_seals_ptr(struct file *file)
+{
+	return NULL;
+}
 #endif
 
+/* Retrieve memfd seals associated with the file, if any. */
+static inline unsigned int memfd_file_seals(struct file *file)
+{
+	unsigned int *sealsp = memfd_file_seals_ptr(file);
+
+	return sealsp ? *sealsp : 0;
+}
+
 #endif /* __LINUX_MEMFD_H */
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 05b970a6cd28..b97d8a691b28 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4022,6 +4022,37 @@ void mem_dump_obj(void *object);
 static inline void mem_dump_obj(void *object) {}
 #endif
 
+static inline bool is_write_sealed(int seals)
+{
+	return seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE);
+}
+
+/**
+ * is_readonly_sealed - Checks whether write-sealed but mapped read-only,
+ *                      in which case writes should be disallowing moving
+ *                      forwards.
+ * @seals: the seals to check
+ * @vm_flags: the VMA flags to check
+ *
+ * Returns whether readonly sealed, in which case writess should be disallowed
+ * going forward.
+ */
+static inline bool is_readonly_sealed(int seals, vm_flags_t vm_flags)
+{
+	/*
+	 * Since an F_SEAL_[FUTURE_]WRITE sealed memfd can be mapped as
+	 * MAP_SHARED and read-only, take care to not allow mprotect to
+	 * revert protections on such mappings. Do this only for shared
+	 * mappings. For private mappings, don't need to mask
+	 * VM_MAYWRITE as we still want them to be COW-writable.
+	 */
+	if (is_write_sealed(seals) &&
+	    ((vm_flags & (VM_SHARED | VM_WRITE)) == VM_SHARED))
+		return true;
+
+	return false;
+}
+
 /**
  * seal_check_write - Check for F_SEAL_WRITE or F_SEAL_FUTURE_WRITE flags and
  *                    handle them.
@@ -4033,24 +4064,15 @@ static inline void mem_dump_obj(void *object) {}
  */
 static inline int seal_check_write(int seals, struct vm_area_struct *vma)
 {
-	if (seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
-		/*
-		 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
-		 * write seals are active.
-		 */
-		if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE))
-			return -EPERM;
-
-		/*
-		 * Since an F_SEAL_[FUTURE_]WRITE sealed memfd can be mapped as
-		 * MAP_SHARED and read-only, take care to not allow mprotect to
-		 * revert protections on such mappings. Do this only for shared
-		 * mappings. For private mappings, don't need to mask
-		 * VM_MAYWRITE as we still want them to be COW-writable.
-		 */
-		if (vma->vm_flags & VM_SHARED)
-			vm_flags_clear(vma, VM_MAYWRITE);
-	}
+	if (!is_write_sealed(seals))
+		return 0;
+
+	/*
+	 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
+	 * write seals are active.
+	 */
+	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE))
+		return -EPERM;
 
 	return 0;
 }
diff --git a/mm/memfd.c b/mm/memfd.c
index 2dba2cb6f0d0..187265dc68f5 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -134,7 +134,7 @@ static int memfd_wait_for_pins(struct address_space *mapping)
 	return error;
 }
 
-static unsigned int *memfd_file_seals_ptr(struct file *file)
+unsigned int *memfd_file_seals_ptr(struct file *file)
 {
 	if (shmem_file(file))
 		return &SHMEM_I(file_inode(file))->seals;
diff --git a/mm/mmap.c b/mm/mmap.c
index 3ef45bac62e6..8cf23a07ae50 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -47,6 +47,7 @@
 #include <linux/oom.h>
 #include <linux/sched/mm.h>
 #include <linux/ksm.h>
+#include <linux/memfd.h>
 
 #include <linux/uaccess.h>
 #include <asm/cacheflush.h>
@@ -1285,6 +1286,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 
 	if (file) {
 		struct inode *inode = file_inode(file);
+		unsigned int seals = memfd_file_seals(file);
 		unsigned long flags_mask;
 
 		if (!file_mmap_ok(file, inode, pgoff, len))
@@ -1323,6 +1325,8 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 			vm_flags |= VM_SHARED | VM_MAYSHARE;
 			if (!(file->f_mode & FMODE_WRITE))
 				vm_flags &= ~(VM_MAYWRITE | VM_SHARED);
+			else if (is_readonly_sealed(seals, vm_flags))
+				vm_flags &= ~VM_MAYWRITE;
 			fallthrough;
 		case MAP_PRIVATE:
 			if (!(file->f_mode & FMODE_READ))
-- 
2.50.1.552.g942d659e1b-goog


