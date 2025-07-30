Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C17DC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 01:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 078846B009A; Tue, 29 Jul 2025 21:53:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 050996B009B; Tue, 29 Jul 2025 21:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECEF76B009C; Tue, 29 Jul 2025 21:53:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE2186B009A
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 21:53:04 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ACA7F1D9F22
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:53:04 +0000 (UTC)
X-FDA: 83719257888.19.FFE9B38
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf08.hostedemail.com (Postfix) with ESMTP id D8E0016000D
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:53:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="w/Pjczkm";
	spf=pass (imf08.hostedemail.com: domain of 3_XqJaA4KCGQKUCCEOCPLCTTGUIQQING.EQONKPWZ-OOMXCEM.QTI@flex--isaacmanjarres.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3_XqJaA4KCGQKUCCEOCPLCTTGUIQQING.EQONKPWZ-OOMXCEM.QTI@flex--isaacmanjarres.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753840382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BffikEvgrnS9N7JhHL4HzdMZNiav8gXMo6oxeg0nd7w=;
	b=ADCsBfIAExW+JavToQMNPjn57tzs0b9J39hQGhIPkXzvyiJflAFU4yapU2roUUQp1WskAb
	qef7bz3Ed/JcvJ8rRk6UnKOgHBeC1Ydhb+njpsJztzLdreMEO2SGXhuUjYGc+rnKn58e7F
	B4bpDDMzJS+g5io6xQa4SR89yyrBLcw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="w/Pjczkm";
	spf=pass (imf08.hostedemail.com: domain of 3_XqJaA4KCGQKUCCEOCPLCTTGUIQQING.EQONKPWZ-OOMXCEM.QTI@flex--isaacmanjarres.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3_XqJaA4KCGQKUCCEOCPLCTTGUIQQING.EQONKPWZ-OOMXCEM.QTI@flex--isaacmanjarres.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753840382; a=rsa-sha256;
	cv=none;
	b=ckxrjm8XLXFWsiLIuNnUcySUbyt42crfCrem2oShzlFJiesMMjxoOeml7Fsl8bgObi7Kd7
	JfOUxqZFs7g3mWKPTKGEyJLdL1rQJetrJFimLXGRC9WLNvcW6I/h5IZ6Vfa5rgJVnuGYNp
	Jw5w0vt1t3PmkK2UtpuKG0WpAW8D9zE=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-24086faa5bcso4035205ad.0
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753840382; x=1754445182; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BffikEvgrnS9N7JhHL4HzdMZNiav8gXMo6oxeg0nd7w=;
        b=w/PjczkmF+rCSmfbbMwiKRtLc+ZkXwZh+S1xRkUQkRj5uywaHOnUj8hwwYo6v3dN2a
         CZh2lC54WgrdMzviAfBTYHxc6JH+IfxAVtgTH0UCuKcPqdpWOx082DKjH4w1pOx6zkva
         7jiIJ5jWaAVJoNZCo57IJgzfw+7awkl/WbmuDN1kj2vaEqM0JF+Bn/xwlTb9VwgBzOQE
         Gc31QNMdwEtwGLDR71mLJII3gV7LsI5NxAfHo74HgOO0xuNenCF2NTh7jKdlM1XzHHxr
         wLaQcW1G+4gzGcJaKH0QqIW4NyqrYsUWyHJlLsGRdiA7FbLF85u+YMtOO2yEmeP3qSBR
         F+MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753840382; x=1754445182;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BffikEvgrnS9N7JhHL4HzdMZNiav8gXMo6oxeg0nd7w=;
        b=k3FU30QN0X1kbQ34FguAIiVwVONvC38V0rcVRUenCqcdK0mcsD4V+tdiPFfYNcHpeA
         QXtHwvK+AE03udzVoz4pfI/PUYn3XHHQ20lJypuGHCHZlWuoVk884YxLkc7Uo6NZuVAn
         Izg1hdoqOGH3EcrCMqyTJNCIanMhxbBx5TTJE6Py8OcX3B84jOrRVhvmCSbpkMQsbUw+
         W8pCXfUzWtC22/N3ogMF6vB9hB9bjLcMIyevTbDDyiFgreIIya1wqwbEUALknWtM/lAu
         8eozOsst3nTtwaYiuwVA7OwZax/9AMAKuqRqSUSj7lPHHF70V/kscBYoY4yjP/D3Nvvb
         XGag==
X-Forwarded-Encrypted: i=1; AJvYcCWHCYOuE+7rtvmEK8vk4pN/2kRMaFHrgoK5eFvE/0JuMzNG41Q1LUdsxzsoSFX1Nyx8h67vmSOsNA==@kvack.org
X-Gm-Message-State: AOJu0YzsCzbADChID97bm0EKbmtQqhzdphxaVOyPy/fDsmOgOzdI+yY5
	894vBR8aq0mqO6+7P/9virDN8m/yOmD5lPbscV6Vc0owsDDMbs7pHL/dOuscGEC9BP/Q5ShLtf2
	Z8K7LO0XG6mbJTV59skRaNjzz9kbTnRqJbYhLwA==
X-Google-Smtp-Source: AGHT+IFFOLO7onC4fbbldKn8fz2WtXlZdQIS6lpA7B1lFt/YEZY3ErKaME52nb0cd7N+E0pPmYUWrDtw3k8Z8P0cty+h+w==
X-Received: from plbm11.prod.google.com ([2002:a17:902:d18b:b0:240:770f:72cb])
 (user=isaacmanjarres job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:11d0:b0:234:8ef1:aa7b with SMTP id d9443c01a7336-24096a6fefdmr17416885ad.20.1753840381679;
 Tue, 29 Jul 2025 18:53:01 -0700 (PDT)
Date: Tue, 29 Jul 2025 18:52:42 -0700
In-Reply-To: <20250730015247.30827-1-isaacmanjarres@google.com>
Mime-Version: 1.0
References: <20250730015247.30827-1-isaacmanjarres@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250730015247.30827-4-isaacmanjarres@google.com>
Subject: [PATCH 6.1.y 3/4] mm: reinstate ability to map write-sealed memfd
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
X-Rspam-User: 
X-Rspamd-Queue-Id: D8E0016000D
X-Rspamd-Server: rspam06
X-Stat-Signature: zrmn7enhesfdxyc9fta8ntt15a9cex8n
X-HE-Tag: 1753840382-297522
X-HE-Meta: U2FsdGVkX18DxatSbMGjtB23yqssbmcO0mBEh2TALm3eHr0vJa96yUUvB5PPON7uZK2K15OGu8SUTqzzPKaFr5tTk2mu0u7kasxp0tnkNUknMRnhjflWH6rFVj06HA4ADW3MSnkE5v34acezKhlVIsMqC+CBw9M/JzwsVdclRPiOZRnLL+xS7TR23tgz3ntHiclcFio7S0PPXNw1xOGO9Fx+V9BsRuG37uBwcQLwtu0SrkYQv5cmtYXggYCYY9aQpMgVFDuY+VfP99bg7QCV7GysOHoVgJVV/O77fo9hfp+me5f3Gh3r78bsAGa3D+9VCXRzA9UiktmaCrC6KfYQ3zb5SkipGJ+u94K/XDQTxFt+Hp3oXbIsXST2qvojDX4cY0n4h7IaEbCx95Y/mMILErcTucFD6wFHgwYrJmzww49blwhHA89LJUJ1aY4HzW4TUML32woAg1tCzC4cvm4XzMtSbmbrh49lS5sBU202589Cz2uTB+q4se0E9iPmmk+imTgvvjwjB62sISU+gK1wHBpm+baljwi/RSZlUsRFe+IgHt/oCjYRxUc8vQmALRejAGagwckR3AzzjhRY5XN5FP5/Ih4+NyAjdVRYA7KTwVOaCPrk5Mvl+SYWmyeBULQq3bSSVg1QzwUcL65iRcChbWn1VqPMl0c6gR63l+TU4IuQjK5k5lASI6fI+zOcQGD6R0LMo2aW0zCarX2vqToXX4s6ufcApQpH8jcT/xfkVExLSadlk6F4hOlSeb5VY3IIiYSTNItUMGAeeSDMTszR0Cd1B5+aYmQoBN7XUTDnJcdq0WtatWr+gqL4uyeP4EplbNwWe3mx5Wl+leMwqMpknDqIB5ZYzbn6uo/o82vrTLmuVOM5N9BlICNmrvELWWlwS+zSImWOcHel8GWVkSIk9wba3JBz1a/B6eRjjPpIQskuw9kpcirFoGMFIBGYZym+TfEtYesffbrcLH2Gpk0
 EBl6EsBU
 eVxGKqK9JruAD3pRzzD2DBTwyMxFOMt+kgH9VOaYfoFnjSPWhzL0QLroPi2ciQeZxaOA/T1Fg1hPJZvjrav8PJ8XKHYUojNX9getj+qW4FXeFHA+FH7f1Go7id7IccsxMMS71I+ALg5XOxgsO0r+lx/+LhBBAlx/u4OGjsakD5j6HiBbUCb8yJWN9xgYUqk+ICjuV1gvLkJRZD+MiPxv11HIKzoMtlfoN3gJZ3UYJXVbtnOcigCk+idN0GM+y8xU3eimyos0lJdWevKSG+Dbq3tMl+RvWW7ALlGyJo4sMESv1VirZ8ZljtGA8ppIy8PjnSbOlbTQ6oWO61ChgCw+sTH22ZI4IomgLBnz1CkVOS9jHtL/r6eMwOSqR1HfOIjAOkxLikWRGeohHpSrnRNRlLscz9kmIX0OqfuDV6njdEF0LtYEiMR9ZpdnMHfhTqk7Z/B/xtNRaBiyq0+GcDT0Y1wd1dwCK40AGTUomKMFGun+faZQLLllv85ggGsHM6dfLYxC3zaoMO7HiOhfqhjkt667+P8dEeHfm1/2DuWb2jPwQbTaGTKNrNDHR9A1xeItYlytMYLnBzMFQY7fXJ62kiEB+D9vz1WGleU5JQZdmRpPmz+YAguif/NaJMfL3OvaVJfr9wKTob+sN7+RSKqHNmK0evn78XMO1GLginhqyN0LmpRBaLXmo8EZGrt4ZSkwB/yuqCF0qTr24RusZQgyPqWqZh4iCCp5r6f90a0R3/5MxwL7CJ+xbpiWObE6E/ZWcqWbOFey4WUZ8fTkH/JuXqagqnt6pGtLxDeQi40wBGQgVUiJ1ymYSTJlH9Qkbhdbj1ryY0yAlloZaU1GVjYJzs3jhTg==
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
index 4f1600413f91..5d06bba9d7e5 100644
--- a/include/linux/memfd.h
+++ b/include/linux/memfd.h
@@ -6,11 +6,25 @@
 
 #ifdef CONFIG_MEMFD_CREATE
 extern long memfd_fcntl(struct file *file, unsigned int cmd, unsigned long arg);
+unsigned int *memfd_file_seals_ptr(struct file *file);
 #else
 static inline long memfd_fcntl(struct file *f, unsigned int c, unsigned long a)
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
index fcd61558ebcb..9e17670de848 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3525,6 +3525,37 @@ void mem_dump_obj(void *object);
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
@@ -3536,24 +3567,15 @@ static inline void mem_dump_obj(void *object) {}
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
-			vma->vm_flags &= ~(VM_MAYWRITE);
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
index b0104b49bf82..4b6c8e5ccd97 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -133,7 +133,7 @@ static int memfd_wait_for_pins(struct address_space *mapping)
 	return error;
 }
 
-static unsigned int *memfd_file_seals_ptr(struct file *file)
+unsigned int *memfd_file_seals_ptr(struct file *file)
 {
 	if (shmem_file(file))
 		return &SHMEM_I(file_inode(file))->seals;
diff --git a/mm/mmap.c b/mm/mmap.c
index 42e55e50b4a5..f93526b3df0c 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -46,6 +46,7 @@
 #include <linux/pkeys.h>
 #include <linux/oom.h>
 #include <linux/sched/mm.h>
+#include <linux/memfd.h>
 
 #include <linux/uaccess.h>
 #include <asm/cacheflush.h>
@@ -1336,6 +1337,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 
 	if (file) {
 		struct inode *inode = file_inode(file);
+		unsigned int seals = memfd_file_seals(file);
 		unsigned long flags_mask;
 
 		if (!file_mmap_ok(file, inode, pgoff, len))
@@ -1374,6 +1376,8 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
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


