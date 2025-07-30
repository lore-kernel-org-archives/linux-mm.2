Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED37C87FCA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 01:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77F0B8E0006; Tue, 29 Jul 2025 21:54:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7310B8E0001; Tue, 29 Jul 2025 21:54:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 620198E0006; Tue, 29 Jul 2025 21:54:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4F6398E0001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 21:54:24 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 24CD61402AF
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:54:24 +0000 (UTC)
X-FDA: 83719261248.06.15D4C04
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 48E861A0006
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:54:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UWvczfoZ;
	spf=pass (imf19.hostedemail.com: domain of 3TXuJaA4KCLQcmUUWgUhdUllYmaiiafY.Wigfchor-ggepUWe.ila@flex--isaacmanjarres.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3TXuJaA4KCLQcmUUWgUhdUllYmaiiafY.Wigfchor-ggepUWe.ila@flex--isaacmanjarres.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753840462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rD1XrM7C8qCS74tkGulJTEtPhEfxr9z3RXYKptzHc+4=;
	b=OcN9hd6mPPePKlpwjTJyOquNZ0EhhkG5K0DecUdJ61eaWt8VgGeMewLEE2fbcloiyQ53yS
	Jpf9h15GS4FNioSbs7iUIDxY27xrKAnfO1x2rw7wf6bDW3lphqCjeK17aWozUb3YvOhHpq
	Hh0iuFlZdXBt7VYJLkKYM7b0buTPWjI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753840462; a=rsa-sha256;
	cv=none;
	b=wxIqqDA1us0EBRoGXLN7KaSzc9MYUdSw0USIFN5QKyi09V7a5fE/lHCElU36XrEc7n3psN
	hYSzTcafEMw0wW6kuCKW+t3qNpLuPnrGiGNWwakY6KQ7JRvtXNyD2VvrHvMkWjd0i+ehTc
	YXdkgfJSfhhOlgIfsILr0NUDRXrWP2I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UWvczfoZ;
	spf=pass (imf19.hostedemail.com: domain of 3TXuJaA4KCLQcmUUWgUhdUllYmaiiafY.Wigfchor-ggepUWe.ila@flex--isaacmanjarres.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3TXuJaA4KCLQcmUUWgUhdUllYmaiiafY.Wigfchor-ggepUWe.ila@flex--isaacmanjarres.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3132c1942a1so9449036a91.2
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753840461; x=1754445261; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=rD1XrM7C8qCS74tkGulJTEtPhEfxr9z3RXYKptzHc+4=;
        b=UWvczfoZm6RlqvhqPTmfsyF/au2JTv+0QXd6OV1KB93RKXfZZqw4YZB9NHLDYeqcrK
         RyKvGNdmtHX07pcICgaoXpyH3K46kyRN0VI/fqMwlXlkXwyaAyrf4xbjW3ekFhwCyIKI
         e7e8Ph0K1yb/CbvvBSiKdIHKY4xAuf5/Y73RoHVyQnDGzgU4OUTr/bE4VRv+6cBicgxs
         s0c8otZn7oSnGOKenjDNpf++M9068qbFKgp5+7bw+ocDHHcLH6K/x8D44j2+TFJoScNT
         /ZjrnERWHsyi2nDAa/d9J3EYc8zYY0HSjtueROF6h4HcgrOQVR0ANTr10/edHPqiKOlv
         xlsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753840461; x=1754445261;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rD1XrM7C8qCS74tkGulJTEtPhEfxr9z3RXYKptzHc+4=;
        b=mLqG9LkBXCeboQCTyh7L8HRe5apzXMsTkhsgYsZmurdyt3oN18hiAk0+fwnenkWVM4
         IY+EFIYX/Bm+2ViMbTHGDhrX3d0E2gRdwQ0wofKphnc5q80/m0RhjBRwJn2yzwhyFzH/
         VKY+5qf43rNwn7M+dwPRYbt2oJBkrWkeVogTq6PVhnR4QtsIHqP7ISh+92dfzrMkehvX
         u0IZID/23DVNTCUOFCzHAyqsOQ2Qy2JpNW9pieIJiNow8bcREKWzu+EnoHWC9fQpQfQ5
         hmnrXH3OA8Eh1pO2PMftaBRcpvGAGELY5De65XpKfPzSNpJgz5JCq7zX/5SPWhXLK4LI
         ntqg==
X-Forwarded-Encrypted: i=1; AJvYcCVQdvDiefhNR8LEsD07Ng1Z9b0zWyuJtKTTFRGbMxV30eG8EUdH7njScGNoa+fhGOjE7epTlyrjYw==@kvack.org
X-Gm-Message-State: AOJu0YzPGymvAAgceVb42TJrgcSuIR+pn2XL1V5bMGuKnAzyMMsF1iQx
	+ZTzgDVpOnF/I9e7gyqDvQ+k1zjyHnOBbn9cBx8jo2fgGlmOrX2XW5axxR3IEnrFcbO1289Bd3s
	RnduE57u7gaKHgiWTZ8Nb0sPkadu8x6vIOroi6g==
X-Google-Smtp-Source: AGHT+IEWGQl51/ieBxnYg6o9o2Ih0h4KYSrk7jmBX3jej4cRHusFyoqw9oF0p+iuLpU/I5VIw0YnPDBVoPqErEKBXYNTMw==
X-Received: from pjqo23.prod.google.com ([2002:a17:90a:ac17:b0:31f:f3:f8c3])
 (user=isaacmanjarres job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:390f:b0:31e:cc6b:320f with SMTP id 98e67ed59e1d1-31f5de1f21dmr2045542a91.5.1753840461026;
 Tue, 29 Jul 2025 18:54:21 -0700 (PDT)
Date: Tue, 29 Jul 2025 18:54:01 -0700
In-Reply-To: <20250730015406.32569-1-isaacmanjarres@google.com>
Mime-Version: 1.0
References: <20250730015406.32569-1-isaacmanjarres@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250730015406.32569-4-isaacmanjarres@google.com>
Subject: [PATCH 5.10.y 3/4] mm: reinstate ability to map write-sealed memfd
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
X-Rspamd-Queue-Id: 48E861A0006
X-Stat-Signature: dyukxijasgb9kzmq4k4p9boo9fk1wwsa
X-Rspam-User: 
X-HE-Tag: 1753840462-243539
X-HE-Meta: U2FsdGVkX19ma38ZCbxbbVUbAjbSlE4aueErpZn85zP+InEih1ltPlg0EFLjtRsx0AScYxV8NySkG2ZKV0X2P7vNAeHnytNDEqOCi1mqdNguiW371GZzzADOmg1fO93AI/9hQm8CEGE5LkGr64Ga8cds2fnnE17thk/szTxrZoCX+wQpt49/XbI2pjSUhBb2kAH2iY6gjWK4Oh89YmVHARAFpVDCj7ZtEJUJeB0JNzSG5KEFyoPy439dZAuqWqcYZpfVo17cDmFQaOgjNGWKag1eVmqkGP4iq8V6vqvfrgWW8VyXoZuOVhYvUWhxd3RCEKju/X5J/Pp8HExigUpBW7ySF8ehZulsLxMsuMMMzAavEebq7l9bnFPTAdTdDoaLpMpaFrcC06Ieakcf2JLCD/JnLiCAiZInSf4ol69IRaChnPs8TM1fjqLMfF8VViiVViMV8vNvXoC4LjRD04zUtb2IJPsHuD8GQLsvW2z171fkrgHNzfe6OG1wJZCK2zCsgUcZqR0KS/Dwk8SToNIuDMKzTpPEmKFiTlf5egS+gV9K8OYlowWSLDVrn+4b2exQUr3rpvoa4rIu9VI7ZMVdxiYot+nt0ZB61F+gUdX007I5Tzs99YyHa4/U1EZijcDk9mEIcmzgk6ZYPuFCC/KdsrS1BZZn1z80FqxiEzKTXudKpf+4mMFphIz3VGRzhoPUyI+fneO9HK0KQHSVD25iO6r89jpcSVMiXIeSJ2Bz2NypByw89LtaBQwU++sfJ+giBjyk5CkuEIaCIHK/dgR/nz7QabDf/BQPT2N0Bq+tVBU1ZSp4bgbKfLvmHB0rI7DsYjBaTZ/WJvLMYqx7kW/JCHuxrhKSiGto39Qx3kDGK4XUIHhQCNsFBXoZIHPkQYXzTsjm602C1uAJ8JSEyNmCbKJG2khqbKxvtnPRtH3jXO1JDS35Tqwj/ksAAiVu7ZPRUdnCNE9zoqBB0s0+jUx
 dfE91S7p
 vvKi9AMct4zhOaXITTeY0kZjUvoLcO0HeonNfXkLMTND44ZNIFY7MmJFbsC7ZiDR6bZt3NwRat0xS+X6TAGxxGNaIrBDpeSctt27TVBFS8Gytbb41Rc1P0Lr+w2elfcUPCbnyMEfYEQj4ooS2+LGpnvTTChbw+ZuAWDYMvjKsdkQE3/PJeWH6dXWW1QtDgfqriN48UZO0Ifjy7m4Mvu0oxSVZlLcFgNCUc8gG9A3Q/4umFucYDKN3OXb8HLXXYC+oPYEijfhtbKs7mbBYHPJDcPnPEkMESDgjEF7QXJz8shAthcyrQv/mwflzYV0gbcDt9k2RSLppMZOkzhRlsybb41yykC2O1eC6ai/MaMzYtH94k3vDfkRmMu8VaCZ//60wD7HGcotiMRbySpqCB8tHzf7wwjMH6g+V5uQyHlaghK8itVYXK4eXi1f3crJ/7U72+rSF1AJXh5bE0DLPZjZOSnEYY0rRieev1Mc7ZJuIfOJxinlNUlKeL9KKWXIeuZrNI/1rPFX80q8OW7LOZqNvtBJxEXqN9n0nHDocbmgLO1wZ5mFwzm9Nhf4VYNusJ2jim8HonzxoOqDyVf1jCujN4lfEO7sMyDGrB7GKy5iJ2U9Fbi3khlP3+KJcUBlv1+J8Zj10TXw+Vm3Nig/Cs6uUCj1k+tH7R7HGbEKiWCqVJu9xnSGyVhVlTnFhxGQpBE9W2AKXNyiuSyuV62u81MlisePz/WQCz9QZYDkWIQJTDm1zXXU48tQ5NH2OAFRAYlkBibipcFgBuXY97wuCEuCtmNONWDgIP0d4AsKK5VXYGVmnHonHMmAPdzUwDxWAd3QtOSGkn4FGrLHasXpvBoGfg6gvZg==
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
index 130d53f0bd66..e168d87d6f2e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3200,6 +3200,37 @@ unsigned long wp_shared_mapping_range(struct address_space *mapping,
 
 extern int sysctl_nr_trim_pages;
 
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
@@ -3211,24 +3242,15 @@ extern int sysctl_nr_trim_pages;
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
index 278e5636623e..8ce796ca5bfa 100644
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
index 3cc0d56e41ad..4d5e9d085f0a 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -47,6 +47,7 @@
 #include <linux/pkeys.h>
 #include <linux/oom.h>
 #include <linux/sched/mm.h>
+#include <linux/memfd.h>
 
 #include <linux/uaccess.h>
 #include <asm/cacheflush.h>
@@ -1488,6 +1489,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 
 	if (file) {
 		struct inode *inode = file_inode(file);
+		unsigned int seals = memfd_file_seals(file);
 		unsigned long flags_mask;
 
 		if (!file_mmap_ok(file, inode, pgoff, len))
@@ -1532,6 +1534,8 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
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


