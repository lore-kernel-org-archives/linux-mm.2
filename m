Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B88A0606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=cDi7XcNt
Received: by kanga.kvack.org (Postfix)
	id E5A566B05B7; Wed, 18 Nov 2026 12:00:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E32306B05B8; Wed, 18 Nov 2026 12:00:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFB4F6B05B9; Wed, 18 Nov 2026 12:00:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8A3916B05B7
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:00:52 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 061691C41FE
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:00:52 +0000 (UTC)
X-FDA: 85448854344.23.1678EE6
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id E113840005
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:00:49 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=cDi7XcNt;
	spf=pass (imf07.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795021250;
	b=2CZaO8T+U23t5vUlSOV+c5N5hqaOV2t2IvU1t2boP8P07lmC1PrTCxV99VLly3JMkgOdEr
	z3PNGV2WHfWnmzOgwgpmR007SiIOqg3Ga8gpgoSx0oU4NfBUzjlUnNDJzM6+RjuHsVpy8r
	XASW/sXa6WU7bdxnWlChoeE/K0pxefU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=cDi7XcNt;
	spf=pass (imf07.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=josef@toxicpanda.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795021250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pp1c2KI2hH/A28QUr8j4Aqw/A/tCvx2iHS29JIkHGCk=;
	b=UhOpR7Kio3/iuxFf86q5hYAWLkXHCGANVnZlE9ywTgvwHYtXR+G0BcS17rROtsHlWwtV0C
	HEnsxLdWPQiDaABSeruY1P7XhIfFKdZSoZmJjqhLa6Cs/yVWh7N663FobMnJ7LQ6+L1q7O
	ZDuX6j8ftLWPZXJRuVOQ5hMqPi1tAM4=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-92123f02faeso686776d6.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:00:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795021249; x=1795626049; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Pp1c2KI2hH/A28QUr8j4Aqw/A/tCvx2iHS29JIkHGCk=;
        b=cDi7XcNthOdQcupyflCDFxJOmM2oWZ5Y2k1gUpLHPjWxGG/ctLWu6Lc4M9qg2SjAgO
         is+H/LgZBU8kIZsk1C0UFsLUBtS35Kbsx2p3FxIRkukhFaILotDtq88buEMAPaRkmhaL
         33W4qAE+0rU7/hkRtAoMdERCCojGbRnFI+NC630pcdLpu8+Feqcs4SKuoerVERV0eqq8
         wVE79N7O7ReQyvluNLnapICV7JArrK4nPfWJUq7ONUjJiZ4E2pBwBI5oq3EfYVE8YDOy
         uocBvfwwmL36omi6Q4k0RgkEa6r/keV2plLNPp3E00KTZFURmRFSLGAMVDsdVQxpAw3d
         f1eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795021249; x=1795626049;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pp1c2KI2hH/A28QUr8j4Aqw/A/tCvx2iHS29JIkHGCk=;
        b=rs/paGTP++l2wMRGRVrAtdc+5awIWya2EsQ2u+T8KxFGZU647YKP/rBwiuYIfv4meL
         WNPvTGgc4Qb+0x2EnXVKlUEEUz0R8ORLXzCijrfRjIu3Eq+OT4TRTOrYZZJ7uBL3E5gG
         VgjCLXkGJFCxc4CbWXCft1B5wlkpR3uhe+vDCBl34C4EI0uWMkY7Q38vR34Q0kg0381m
         Nqv9cgYceRSHsDtbJahh0ZuAE+2PCOPYZ8tD9k9zjR1dbgNuA6mLaWehcUWIo8rht36w
         L7l2UheP9h5kYK3BAyqiICZTo+zLYDdriL2VuJscBQq6dggzwy5CLc1mQPO0qi+/E3+A
         9AUw==
X-Forwarded-Encrypted: i=1; AL+hErHoc8xMWfSf9434TUWwaRGuyCVdNvZ3SliKlHc1oB83JpVUfC/ipy0IYslQI5bTb/yce02O89LhDg==@kvack.org
X-Gm-Message-State: APuU4Z/uppRhvG7Z3zpMQ0hGUtO2Z/pAJ0A6thAx9zyMtwjnvzFrXOWh
	alcsfi8JAmYjKR86Q8j4GediVxCU9xqQ8GNiEgzn995yULd7JctZU+R7pUX63QlH2zQ=
X-Gm-Gg: AZFdTZdOSRspWuDBMS8yet6aIsZdBvhoF78gm0Bqu67GKdZ8Uazo/FftnCJT624S3PF
	fp3dcs7jbeB+1Hyf3HI3fsUSyxYWVNvaGXsoaqvZm6ikRmCNdY0pBNdFxz9nekkAuOPEO8FxpHh
	/+U7/qO9pe5CJtDnCfZfwd49c4AzE4og4jgNMCBCnIS2K701DEBSKkdxtKWyHixo9XrO4Yk0v6b
	OVlVYbdiYxOA3oQxiXhazPc6jJw2AUYKP/WLpVneDMj8uwqKSZtlfOSD/FV59djQ483JMbgYZak
	0XoKxS78rcgcr6XD8/pvpMIyP84XqPBGsYd/mGA58HgEdiyTPvYHK7K4RjwfYDJqawus20Ey7tn
	EKE7xZTCk0PeT1qDl8mOIqHaJ7zbYmBvwq4fMP+a1jovPprfoUVR23zoIt1He0nkJ1Km4oD98t8
	wnLW+aIH1LySsxm7gsR42Z11LBmBMadoflOXMpI5I42l/ar0e1Dxpjsp6jlnqur5y8IUS1Xb/JH
	xgnX/44rJ2IPCz9DLYziBGa/8dh6yDrudiMg9UGlFKQNwUTCssvV9ccMfW30xlOhIJfLtB7L38i
	QZKzOsgdkyJJ4JnrAQxPO7BZRLc6C6FAkUKyw1/+63UYFGU=
X-Received: by 2002:a05:6214:2682:b0:920:e412:e3df with SMTP id 6a1803df08f44-92114dca707mr51430806d6.18.1795021248307;
        Wed, 18 Nov 2026 09:00:48 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.240])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92114d67132sm26072986d6.28.2026.11.18.09.00.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:00:47 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Date: Wed, 18 Nov 2026 17:00:33 +0000
Subject: [PATCH RFC 1/7] treewide: make vm_ops->open() return an int
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-b4-vma-open-fail-v1-1-c8b0209f2700@toxicpanda.com>
References: <20261118-b4-vma-open-fail-v1-0-c8b0209f2700@toxicpanda.com>
In-Reply-To: <20261118-b4-vma-open-fail-v1-0-c8b0209f2700@toxicpanda.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1795021242; l=38013;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=8ygLbMNJ/Luabug83CJqqPhx2JwmWNT9Miu7x+GyQlo=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QMh3k6mTwVm+9STBNfkgIpIhaSysQyTz+YOmZki5iHDG91px2BNnqyWIFNLt4wuRZGwWRDdYZXz
 xDaV4uwO+jAU=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E113840005
X-Stat-Signature: tjyob1ekwwkur9wyh3nqexduib5iacke
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795021249-764784
X-HE-Meta: U2FsdGVkX18faAzCpP/3CeYfQJMjCet5zhzUHel/VB+9LoBxdYSYm3YPfGWRTdIGvZKnG+Co704LsLUIKge9XCHtqa36wxx+T/KJOoZnaVtKoeSq9eiXhEOACPwiSADqHH2DjARCjTaYF6UWZFzprsZ6GYr/FTeNxUMh2SWAR2Es60cQQPB8Uumuuf0hb1xiOqOY5lDDkfeGOu1xwXFDpdu25l00gyws6r7oYODQDMqYeReMq5Z7fB4QB9qdFOHj9gdrN5lDXexlKRCot14+vEwc0eJreLJtvZYpH0eAePg/gVyEYeeY8KtWS6IIKpz1GKwSGBTDvXEqUvTFEKZpcEitcHH1bmNFKxrm7XDCG8U0CCccQh6YbU2C43vfwaZbKU30HqU6oQp+e3fcgXEHIxle7udHNbrSIwSp4lkNy//KGC2iJuE1H3sAkNtjf/ZxxKFp6N5UQs4DClh4Q+EQAyBYbfVoN6HayqxnB7cVYTp6ygVX6fw0srDrxkVe4GCryPNI1EMn84PyH9oz774/by312OGKWyofIX64NFR4oCh8knYSKdkIyv2wIVgu+RCpsHSa2oM/12WHZ84eEK9qmolGjqA09adD+x3aJObCpEKM9mPYJTcpVmWwPlThpbPtP270vEdV9wuj27yY2Tzhlr59g2xPmvZjTCvhYrQISGjc2+cWKXMR0rKZ7I8YRUgXbomaZKnYIouUNS+70BzQ5Xy324vRMkmqcPG6iYFZ7AIliqFlcQlBNr+e9C/fpz0tsCWIUqQw42OUdrGTrpEIwLdhio84LxcgD0fuk8wJT6XX8dWpB216mFu6zxupjJX036bIRfTQTeBHwXsneNt+mSQqyrzFjj6mVHqXf/K0bygtg5IBUh0+TAlP3KeJd+ydAuhCAexPXqECN92UUbNfGSlq2G5djRFSCWf20KI2OlXveDpQjwO0GKD3WegH3JX9NFgxcfPytjHAu24ZBZJ
 7ZoSdnN9
 ABGxzoqrZzpZCIbNTKWPMTgMb9Nsdn8FE3r+e780svCK2QmV+sRHJp1UJgYeV6QVneOn9mhkb4t8AxLsZ6BEAChRQD85InDw89OUEJcbjgsXVObdPV0p+ccdb8AlGnKZGty5+reXCkSpgTyCjC8MTKgWdLlRAexZWm9ylf98fvEevGMLvgUEQ5DtVA/W8yVmJtvED8Tlnzg25DM1ZWsc9ayeBcjiozNtcdii0bl0Kr+XtPnoL0bhG8oyWApUi9gmyJ3DAxdPl+hA1RGFBfRHZ5XyqRRtBgYcDU7R2f9qvfVfu/ZT1lfckb7I8G1pOvyMtYBsx+2N9LU6KtVPP4Prfdpr/47P9w1O7JKspd629D4T8Ih2LgiCPBpp3eaMsZ51AZZM3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

vm_ops->open() has no way to report a failure, so a callback that
allocates memory has to hide it.  hugetlb carries on without the VMA lock
for a shared mapping if it can't allocate it, for example.

Make the callback return an int, so that this can be fixed.  Every callback
returns 0 for now and the callers ignore the result.  shm_open(),
kernfs_vma_open() and coda_vm_open() wrap another vm_ops->open() and pass
its result on.

No functional change intended.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 Documentation/filesystems/locking.rst             |  2 +-
 Documentation/gpu/drm-mm.rst                      |  2 +-
 arch/x86/kernel/cpu/sgx/encl.c                    |  6 ++++--
 drivers/accel/amdxdna/amdxdna_gem.c               |  4 +++-
 drivers/comedi/comedi_fops.c                      |  4 +++-
 drivers/gpu/drm/drm_gem.c                         |  6 +++++-
 drivers/gpu/drm/drm_gem_shmem_helper.c            |  4 +++-
 drivers/gpu/drm/i915/gem/i915_gem_mman.c          |  4 +++-
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c           |  4 +++-
 drivers/gpu/drm/panthor/panthor_gem.c             |  4 +++-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                   |  4 +++-
 drivers/hwtracing/intel_th/msu.c                  |  4 +++-
 drivers/hwtracing/stm/core.c                      |  4 +++-
 drivers/infiniband/core/uverbs_main.c             |  8 +++++---
 drivers/infiniband/sw/rdmavt/mmap.c               |  4 +++-
 drivers/iommu/iommufd/main.c                      |  4 +++-
 drivers/media/common/videobuf2/videobuf2-memops.c |  6 +++++-
 drivers/misc/genwqe/card_dev.c                    |  4 +++-
 drivers/rapidio/devices/rio_mport_cdev.c          |  4 +++-
 drivers/scsi/leapraid/leapraid_app.c              |  6 ++++--
 drivers/staging/media/atomisp/pci/hmm/hmm_bo.c    |  6 ++++--
 drivers/staging/vme_user/vme_user.c               |  4 +++-
 drivers/target/target_core_user.c                 |  4 +++-
 drivers/usb/core/devio.c                          |  4 +++-
 drivers/usb/mon/mon_bin.c                         |  4 +++-
 drivers/video/fbdev/core/fb_defio.c               |  4 +++-
 drivers/video/fbdev/omap2/omapfb/omapfb-main.c    |  4 +++-
 drivers/video/fbdev/udlfb.c                       |  4 +++-
 drivers/xen/gntalloc.c                            |  6 ++++--
 drivers/xen/gntdev.c                              |  4 +++-
 drivers/xen/privcmd-buf.c                         |  6 ++++--
 fs/afs/file.c                                     |  6 ++++--
 fs/coda/file.c                                    |  9 +++++++--
 fs/kernfs/file.c                                  | 11 +++++++----
 include/drm/drm_gem.h                             |  2 +-
 include/drm/ttm/ttm_bo.h                          |  2 +-
 include/linux/mm.h                                |  9 ++++++++-
 ipc/shm.c                                         | 13 +++++++++----
 kernel/bpf/arena.c                                |  4 +++-
 kernel/bpf/syscall.c                              |  4 +++-
 kernel/events/core.c                              |  4 +++-
 kernel/trace/trace.c                              |  4 +++-
 mm/hugetlb.c                                      |  4 +++-
 net/packet/af_packet.c                            |  4 +++-
 sound/core/pcm_native.c                           |  4 +++-
 sound/usb/usx2y/usx2yhwdeppcm.c                   |  3 ++-
 tools/testing/vma/include/dup.h                   |  9 ++++++++-
 47 files changed, 168 insertions(+), 62 deletions(-)

diff --git a/Documentation/filesystems/locking.rst b/Documentation/filesystems/locking.rst
index f7363ad770c7..f2bf0bd6d8a6 100644
--- a/Documentation/filesystems/locking.rst
+++ b/Documentation/filesystems/locking.rst
@@ -573,7 +573,7 @@ vm_operations_struct
 
 prototypes::
 
-	void (*open)(struct vm_area_struct *);
+	int (*open)(struct vm_area_struct *);
 	void (*close)(struct vm_area_struct *);
 	vm_fault_t (*fault)(struct vm_fault *);
 	vm_fault_t (*huge_fault)(struct vm_fault *, unsigned int order);
diff --git a/Documentation/gpu/drm-mm.rst b/Documentation/gpu/drm-mm.rst
index 2dea94f77d52..7f9c1ea18b44 100644
--- a/Documentation/gpu/drm-mm.rst
+++ b/Documentation/gpu/drm-mm.rst
@@ -287,7 +287,7 @@ made up of several fields, the more interesting ones being:
 .. code-block:: c
 
 	struct vm_operations_struct {
-		void (*open)(struct vm_area_struct * area);
+		int (*open)(struct vm_area_struct * area);
 		void (*close)(struct vm_area_struct * area);
 		vm_fault_t (*fault)(struct vm_fault *vmf);
 	};
diff --git a/arch/x86/kernel/cpu/sgx/encl.c b/arch/x86/kernel/cpu/sgx/encl.c
index 3f0222d10f6e..3a982bba15cf 100644
--- a/arch/x86/kernel/cpu/sgx/encl.c
+++ b/arch/x86/kernel/cpu/sgx/encl.c
@@ -484,7 +484,7 @@ static vm_fault_t sgx_vma_fault(struct vm_fault *vmf)
 	return VM_FAULT_NOPAGE;
 }
 
-static void sgx_vma_open(struct vm_area_struct *vma)
+static int sgx_vma_open(struct vm_area_struct *vma)
 {
 	struct sgx_encl *encl = vma->vm_private_data;
 
@@ -494,10 +494,12 @@ static void sgx_vma_open(struct vm_area_struct *vma)
 	 * failed to allocate memory in this callback.
 	 */
 	if (unlikely(!encl))
-		return;
+		return 0;
 
 	if (sgx_encl_mm_add(encl, vma->vm_mm))
 		vma->vm_private_data = NULL;
+
+	return 0;
 }
 
 
diff --git a/drivers/accel/amdxdna/amdxdna_gem.c b/drivers/accel/amdxdna/amdxdna_gem.c
index f14484bc31ec..5f3a119cb9dc 100644
--- a/drivers/accel/amdxdna/amdxdna_gem.c
+++ b/drivers/accel/amdxdna/amdxdna_gem.c
@@ -608,7 +608,7 @@ static vm_fault_t amdxdna_gem_mixedmap_fault(struct vm_fault *vmf)
 	return ret;
 }
 
-static void amdxdna_gem_mixedmap_vm_open(struct vm_area_struct *vma)
+static int amdxdna_gem_mixedmap_vm_open(struct vm_area_struct *vma)
 {
 	struct drm_gem_object *gobj = vma->vm_private_data;
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(gobj);
@@ -622,6 +622,8 @@ static void amdxdna_gem_mixedmap_vm_open(struct vm_area_struct *vma)
 	dma_resv_unlock(gobj->resv);
 
 	drm_gem_vm_open(vma);
+
+	return 0;
 }
 
 static void amdxdna_gem_mixedmap_vm_close(struct vm_area_struct *vma)
diff --git a/drivers/comedi/comedi_fops.c b/drivers/comedi/comedi_fops.c
index 05d14839c5a6..8e35184b09bb 100644
--- a/drivers/comedi/comedi_fops.c
+++ b/drivers/comedi/comedi_fops.c
@@ -2442,12 +2442,14 @@ static long comedi_unlocked_ioctl(struct file *file, unsigned int cmd,
 	return rc;
 }
 
-static void comedi_vm_open(struct vm_area_struct *area)
+static int comedi_vm_open(struct vm_area_struct *area)
 {
 	struct comedi_buf_map *bm;
 
 	bm = area->vm_private_data;
 	comedi_buf_map_get(bm);
+
+	return 0;
 }
 
 static void comedi_vm_close(struct vm_area_struct *area)
diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index 3ce38df7b8b8..fae60f8cbea3 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -1174,12 +1174,16 @@ EXPORT_SYMBOL(drm_gem_object_free);
  *
  * This function implements the #vm_operations_struct open() callback for GEM
  * drivers. This must be used together with drm_gem_vm_close().
+ *
+ * Returns: Always 0.
  */
-void drm_gem_vm_open(struct vm_area_struct *vma)
+int drm_gem_vm_open(struct vm_area_struct *vma)
 {
 	struct drm_gem_object *obj = vma->vm_private_data;
 
 	drm_gem_object_get(obj);
+
+	return 0;
 }
 EXPORT_SYMBOL(drm_gem_vm_open);
 
diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index d654a22a30de..95fe322a0cbf 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -687,7 +687,7 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault *vmf)
 	return drm_gem_shmem_any_fault(vmf, 0);
 }
 
-static void drm_gem_shmem_vm_open(struct vm_area_struct *vma)
+static int drm_gem_shmem_vm_open(struct vm_area_struct *vma)
 {
 	struct drm_gem_object *obj = vma->vm_private_data;
 	struct drm_gem_shmem_object *shmem = to_drm_gem_shmem_obj(obj);
@@ -707,6 +707,8 @@ static void drm_gem_shmem_vm_open(struct vm_area_struct *vma)
 	dma_resv_unlock(shmem->base.resv);
 
 	drm_gem_vm_open(vma);
+
+	return 0;
 }
 
 static void drm_gem_shmem_vm_close(struct vm_area_struct *vma)
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
index 6b337684dbfe..34f34c98bbcf 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -918,13 +918,15 @@ i915_gem_mmap_offset_ioctl(struct drm_device *dev, void *data,
 	return __assign_mmap_offset_handle(file, args->handle, type, &args->offset);
 }
 
-static void vm_open(struct vm_area_struct *vma)
+static int vm_open(struct vm_area_struct *vma)
 {
 	struct i915_mmap_offset *mmo = vma->vm_private_data;
 	struct drm_i915_gem_object *obj = mmo->obj;
 
 	GEM_BUG_ON(!obj);
 	i915_gem_object_get(obj);
+
+	return 0;
 }
 
 static void vm_close(struct vm_area_struct *vma)
diff --git a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
index df3fcc2b1248..3b6a03b2d40b 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_ttm.c
@@ -1166,13 +1166,15 @@ vm_access_ttm(struct vm_area_struct *area, unsigned long addr,
 	return ttm_bo_vm_access(area, addr, buf, len, write);
 }
 
-static void ttm_vm_open(struct vm_area_struct *vma)
+static int ttm_vm_open(struct vm_area_struct *vma)
 {
 	struct drm_i915_gem_object *obj =
 		i915_ttm_to_gem(vma->vm_private_data);
 
 	GEM_BUG_ON(i915_ttm_is_ghost_object(vma->vm_private_data));
 	i915_gem_object_get(obj);
+
+	return 0;
 }
 
 static void ttm_vm_close(struct vm_area_struct *vma)
diff --git a/drivers/gpu/drm/panthor/panthor_gem.c b/drivers/gpu/drm/panthor/panthor_gem.c
index 22b57ab6f929..60f251f967a5 100644
--- a/drivers/gpu/drm/panthor/panthor_gem.c
+++ b/drivers/gpu/drm/panthor/panthor_gem.c
@@ -927,7 +927,7 @@ static vm_fault_t panthor_gem_fault(struct vm_fault *vmf)
 	return panthor_gem_any_fault(vmf, 0);
 }
 
-static void panthor_gem_vm_open(struct vm_area_struct *vma)
+static int panthor_gem_vm_open(struct vm_area_struct *vma)
 {
 	struct panthor_gem_object *bo = to_panthor_bo(vma->vm_private_data);
 
@@ -935,6 +935,8 @@ static void panthor_gem_vm_open(struct vm_area_struct *vma)
 	drm_WARN_ON(bo->base.dev, !refcount_inc_not_zero(&bo->cmap.mmap_count));
 
 	drm_gem_vm_open(vma);
+
+	return 0;
 }
 
 static void panthor_gem_vm_close(struct vm_area_struct *vma)
diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo_vm.c
index 872bf444b1f0..5822bb1aa82f 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -347,13 +347,15 @@ vm_fault_t ttm_bo_vm_fault(struct vm_fault *vmf)
 }
 EXPORT_SYMBOL(ttm_bo_vm_fault);
 
-void ttm_bo_vm_open(struct vm_area_struct *vma)
+int ttm_bo_vm_open(struct vm_area_struct *vma)
 {
 	struct ttm_buffer_object *bo = vma->vm_private_data;
 
 	WARN_ON(bo->bdev->dev_mapping != vma->vm_file->f_mapping);
 
 	drm_gem_object_get(&bo->base);
+
+	return 0;
 }
 EXPORT_SYMBOL(ttm_bo_vm_open);
 
diff --git a/drivers/hwtracing/intel_th/msu.c b/drivers/hwtracing/intel_th/msu.c
index 84d99d7b1d20..b089cbfed09b 100644
--- a/drivers/hwtracing/intel_th/msu.c
+++ b/drivers/hwtracing/intel_th/msu.c
@@ -1587,12 +1587,14 @@ static ssize_t intel_th_msc_read(struct file *file, char __user *buf,
  * vm operations callbacks (vm_ops)
  */
 
-static void msc_mmap_open(struct vm_area_struct *vma)
+static int msc_mmap_open(struct vm_area_struct *vma)
 {
 	struct msc_iter *iter = vma->vm_file->private_data;
 	struct msc *msc = iter->msc;
 
 	atomic_inc(&msc->mmap_count);
+
+	return 0;
 }
 
 static void msc_mmap_close(struct vm_area_struct *vma)
diff --git a/drivers/hwtracing/stm/core.c b/drivers/hwtracing/stm/core.c
index f48c6a8a0654..7ddb64b8f9a6 100644
--- a/drivers/hwtracing/stm/core.c
+++ b/drivers/hwtracing/stm/core.c
@@ -676,12 +676,14 @@ static int stm_mmap_mapped(unsigned long start, unsigned long end, pgoff_t pgoff
 	return 0;
 }
 
-static void stm_mmap_open(struct vm_area_struct *vma)
+static int stm_mmap_open(struct vm_area_struct *vma)
 {
 	struct stm_file *stmf = vma->vm_file->private_data;
 	struct stm_device *stm = stmf->stm;
 
 	pm_runtime_get(&stm->dev);
+
+	return 0;
 }
 
 static void stm_mmap_close(struct vm_area_struct *vma)
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 2a046c888dfa..5f892ce35e93 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -662,14 +662,14 @@ static int ib_uverbs_mmap(struct file *filp, struct vm_area_struct *vma)
  * The VMA has been dup'd, initialize the vm_private_data with a new tracking
  * struct
  */
-static void rdma_umap_open(struct vm_area_struct *vma)
+static int rdma_umap_open(struct vm_area_struct *vma)
 {
 	struct ib_uverbs_file *ufile = vma->vm_file->private_data;
 	struct rdma_umap_priv *opriv = vma->vm_private_data;
 	struct rdma_umap_priv *priv;
 
 	if (!opriv)
-		return;
+		return 0;
 
 	/* We are racing with disassociation */
 	if (!down_read_trylock(&ufile->hw_destroy_rwsem))
@@ -687,7 +687,7 @@ static void rdma_umap_open(struct vm_area_struct *vma)
 	rdma_umap_priv_init(priv, vma, opriv->entry);
 
 	up_read(&ufile->hw_destroy_rwsem);
-	return;
+	return 0;
 
 out_unlock:
 	up_read(&ufile->hw_destroy_rwsem);
@@ -699,6 +699,8 @@ static void rdma_umap_open(struct vm_area_struct *vma)
 	 */
 	vma->vm_private_data = NULL;
 	zap_special_vma_range(vma, vma->vm_start, vma->vm_end - vma->vm_start);
+
+	return 0;
 }
 
 static void rdma_umap_close(struct vm_area_struct *vma)
diff --git a/drivers/infiniband/sw/rdmavt/mmap.c b/drivers/infiniband/sw/rdmavt/mmap.c
index 473f464f33fa..ee8513a54318 100644
--- a/drivers/infiniband/sw/rdmavt/mmap.c
+++ b/drivers/infiniband/sw/rdmavt/mmap.c
@@ -44,11 +44,13 @@ void rvt_release_mmap_info(struct kref *ref)
 	kfree(ip);
 }
 
-static void rvt_vma_open(struct vm_area_struct *vma)
+static int rvt_vma_open(struct vm_area_struct *vma)
 {
 	struct rvt_mmap_info *ip = vma->vm_private_data;
 
 	kref_get(&ip->ref);
+
+	return 0;
 }
 
 static void rvt_vma_close(struct vm_area_struct *vma)
diff --git a/drivers/iommu/iommufd/main.c b/drivers/iommu/iommufd/main.c
index 9a921b153162..5e176d5b47a4 100644
--- a/drivers/iommu/iommufd/main.c
+++ b/drivers/iommu/iommufd/main.c
@@ -564,11 +564,13 @@ static long iommufd_fops_ioctl(struct file *filp, unsigned int cmd,
 	return ret;
 }
 
-static void iommufd_fops_vma_open(struct vm_area_struct *vma)
+static int iommufd_fops_vma_open(struct vm_area_struct *vma)
 {
 	struct iommufd_mmap *immap = vma->vm_private_data;
 
 	refcount_inc(&immap->owner->users);
+
+	return 0;
 }
 
 static void iommufd_fops_vma_close(struct vm_area_struct *vma)
diff --git a/drivers/media/common/videobuf2/videobuf2-memops.c b/drivers/media/common/videobuf2/videobuf2-memops.c
index f9a4ec44422e..be2aca7afb20 100644
--- a/drivers/media/common/videobuf2/videobuf2-memops.c
+++ b/drivers/media/common/videobuf2/videobuf2-memops.c
@@ -86,8 +86,10 @@ EXPORT_SYMBOL(vb2_destroy_framevec);
  *
  * This function adds another user to the provided vma. It expects
  * struct vb2_vmarea_handler pointer in vma->vm_private_data.
+ *
+ * Returns: Always 0.
  */
-static void vb2_common_vm_open(struct vm_area_struct *vma)
+static int vb2_common_vm_open(struct vm_area_struct *vma)
 {
 	struct vb2_vmarea_handler *h = vma->vm_private_data;
 
@@ -96,6 +98,8 @@ static void vb2_common_vm_open(struct vm_area_struct *vma)
 	       vma->vm_end);
 
 	refcount_inc(h->refcount);
+
+	return 0;
 }
 
 /**
diff --git a/drivers/misc/genwqe/card_dev.c b/drivers/misc/genwqe/card_dev.c
index 5a07e8403e97..719186815650 100644
--- a/drivers/misc/genwqe/card_dev.c
+++ b/drivers/misc/genwqe/card_dev.c
@@ -376,9 +376,11 @@ static int genwqe_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static void genwqe_vma_open(struct vm_area_struct *vma)
+static int genwqe_vma_open(struct vm_area_struct *vma)
 {
 	/* nothing ... */
+
+	return 0;
 }
 
 /**
diff --git a/drivers/rapidio/devices/rio_mport_cdev.c b/drivers/rapidio/devices/rio_mport_cdev.c
index 40d2953a9a7f..1617454fe0ea 100644
--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -2156,12 +2156,14 @@ static void mport_release_mapping(struct kref *ref)
 	kfree(map);
 }
 
-static void mport_mm_open(struct vm_area_struct *vma)
+static int mport_mm_open(struct vm_area_struct *vma)
 {
 	struct rio_mport_mapping *map = vma->vm_private_data;
 
 	rmcd_debug(MMAP, "%pad", &map->phys_addr);
 	kref_get(&map->ref);
+
+	return 0;
 }
 
 static void mport_mm_close(struct vm_area_struct *vma)
diff --git a/drivers/scsi/leapraid/leapraid_app.c b/drivers/scsi/leapraid/leapraid_app.c
index 84eef50947ae..6bd9dc7f92b7 100644
--- a/drivers/scsi/leapraid/leapraid_app.c
+++ b/drivers/scsi/leapraid/leapraid_app.c
@@ -693,15 +693,17 @@ static long leapraid_ctl_ioctl(struct file *file, unsigned int cmd,
 	return leapraid_ctl_ioctl_main(file, cmd, (void __user *)arg);
 }
 
-static void leapraid_fw_mmap_open(struct vm_area_struct *vma)
+static int leapraid_fw_mmap_open(struct vm_area_struct *vma)
 {
 	struct leapraid_adapter *adapter = vma->vm_private_data;
 
 	if (!adapter)
-		return;
+		return 0;
 
 	get_device(&adapter->shost->shost_gendev);
 	atomic_inc(&adapter->fw_log_desc.mmap_refcnt);
+
+	return 0;
 }
 
 static void leapraid_fw_mmap_close(struct vm_area_struct *vma)
diff --git a/drivers/staging/media/atomisp/pci/hmm/hmm_bo.c b/drivers/staging/media/atomisp/pci/hmm/hmm_bo.c
index 0a8f401a1ca1..154a1836268e 100644
--- a/drivers/staging/media/atomisp/pci/hmm/hmm_bo.c
+++ b/drivers/staging/media/atomisp/pci/hmm/hmm_bo.c
@@ -982,11 +982,11 @@ void hmm_bo_unref(struct hmm_buffer_object *bo)
 	kref_put(&bo->kref, kref_hmm_bo_release);
 }
 
-static void hmm_bo_vm_open(struct vm_area_struct *vma)
+static int hmm_bo_vm_open(struct vm_area_struct *vma)
 {
 	struct hmm_buffer_object *bo = vma->vm_private_data;
 
-	check_bo_null_return_void(bo);
+	check_bo_null_return(bo, 0);
 
 	hmm_bo_ref(bo);
 
@@ -997,6 +997,8 @@ static void hmm_bo_vm_open(struct vm_area_struct *vma)
 	bo->mmap_count++;
 
 	mutex_unlock(&bo->mutex);
+
+	return 0;
 }
 
 static void hmm_bo_vm_close(struct vm_area_struct *vma)
diff --git a/drivers/staging/vme_user/vme_user.c b/drivers/staging/vme_user/vme_user.c
index a472a38ef613..c8b9ec8d72e5 100644
--- a/drivers/staging/vme_user/vme_user.c
+++ b/drivers/staging/vme_user/vme_user.c
@@ -446,11 +446,13 @@ vme_user_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return ret;
 }
 
-static void vme_user_vm_open(struct vm_area_struct *vma)
+static int vme_user_vm_open(struct vm_area_struct *vma)
 {
 	struct vme_user_vma_priv *vma_priv = vma->vm_private_data;
 
 	refcount_inc(&vma_priv->refcnt);
+
+	return 0;
 }
 
 static void vme_user_vm_close(struct vm_area_struct *vma)
diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 07b514678176..12dff4b4d9a5 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1871,13 +1871,15 @@ static int tcmu_vma_mapped(unsigned long start, unsigned long end, pgoff_t pgoff
 	return 0;
 }
 
-static void tcmu_vma_open(struct vm_area_struct *vma)
+static int tcmu_vma_open(struct vm_area_struct *vma)
 {
 	struct tcmu_dev *udev = vma->vm_private_data;
 
 	pr_debug("vma_open\n");
 
 	kref_get(&udev->kref);
+
+	return 0;
 }
 
 static void tcmu_vma_close(struct vm_area_struct *vma)
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 101cb9425480..cfd67c576d9d 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -205,7 +205,7 @@ static void dec_usb_memory_use_count(struct usb_memory *usbm, int *count)
 	}
 }
 
-static void usbdev_vm_open(struct vm_area_struct *vma)
+static int usbdev_vm_open(struct vm_area_struct *vma)
 {
 	struct usb_memory *usbm = vma->vm_private_data;
 	unsigned long flags;
@@ -213,6 +213,8 @@ static void usbdev_vm_open(struct vm_area_struct *vma)
 	spin_lock_irqsave(&usbm->ps->lock, flags);
 	++usbm->vma_use_count;
 	spin_unlock_irqrestore(&usbm->ps->lock, flags);
+
+	return 0;
 }
 
 static void usbdev_vm_close(struct vm_area_struct *vma)
diff --git a/drivers/usb/mon/mon_bin.c b/drivers/usb/mon/mon_bin.c
index 9d00b21a8153..0f808e9e7a29 100644
--- a/drivers/usb/mon/mon_bin.c
+++ b/drivers/usb/mon/mon_bin.c
@@ -1232,11 +1232,13 @@ static void __mon_bin_vma_open(struct mon_reader_bin *rp)
  * open and close: just keep track of how many times the device is
  * mapped, to use the proper memory allocation function.
  */
-static void mon_bin_vma_open(struct vm_area_struct *vma)
+static int mon_bin_vma_open(struct vm_area_struct *vma)
 {
 	struct mon_reader_bin *rp = vma->vm_private_data;
 
 	__mon_bin_vma_open(rp);
+
+	return 0;
 }
 
 static void __mon_bin_vma_close(struct mon_reader_bin *rp)
diff --git a/drivers/video/fbdev/core/fb_defio.c b/drivers/video/fbdev/core/fb_defio.c
index fb359ecc3966..9c9e41ced9b0 100644
--- a/drivers/video/fbdev/core/fb_defio.c
+++ b/drivers/video/fbdev/core/fb_defio.c
@@ -106,12 +106,14 @@ static void fb_deferred_io_state_put(struct fb_deferred_io_state *fbdefio_state)
  * struct vm_operations_struct
  */
 
-static void fb_deferred_io_vm_open(struct vm_area_struct *vma)
+static int fb_deferred_io_vm_open(struct vm_area_struct *vma)
 {
 	struct fb_deferred_io_state *fbdefio_state = vma->vm_private_data;
 
 	WARN_ON_ONCE(!try_module_get(THIS_MODULE));
 	fb_deferred_io_state_get(fbdefio_state);
+
+	return 0;
 }
 
 static void fb_deferred_io_vm_close(struct vm_area_struct *vma)
diff --git a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c b/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
index 046892682fc6..d02f20feeb24 100644
--- a/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
+++ b/drivers/video/fbdev/omap2/omapfb/omapfb-main.c
@@ -1063,13 +1063,15 @@ static int omapfb_pan_display(struct fb_var_screeninfo *var,
 	return r;
 }
 
-static void mmap_user_open(struct vm_area_struct *vma)
+static int mmap_user_open(struct vm_area_struct *vma)
 {
 	struct omapfb2_mem_region *rg = vma->vm_private_data;
 
 	omapfb_get_mem_region(rg);
 	atomic_inc(&rg->map_count);
 	omapfb_put_mem_region(rg);
+
+	return 0;
 }
 
 static void mmap_user_close(struct vm_area_struct *vma)
diff --git a/drivers/video/fbdev/udlfb.c b/drivers/video/fbdev/udlfb.c
index 8b7b4bdac4fb..a613d83655b4 100644
--- a/drivers/video/fbdev/udlfb.c
+++ b/drivers/video/fbdev/udlfb.c
@@ -321,11 +321,13 @@ static int dlfb_set_video_mode(struct dlfb_data *dlfb,
 	return retval;
 }
 
-static void dlfb_vm_open(struct vm_area_struct *vma)
+static int dlfb_vm_open(struct vm_area_struct *vma)
 {
 	struct dlfb_data *dlfb = vma->vm_private_data;
 
 	atomic_inc(&dlfb->mmap_count);
+
+	return 0;
 }
 
 static void dlfb_vm_close(struct vm_area_struct *vma)
diff --git a/drivers/xen/gntalloc.c b/drivers/xen/gntalloc.c
index 3218686be45b..537e3988617c 100644
--- a/drivers/xen/gntalloc.c
+++ b/drivers/xen/gntalloc.c
@@ -454,16 +454,18 @@ static long gntalloc_ioctl(struct file *filp, unsigned int cmd,
 	return 0;
 }
 
-static void gntalloc_vma_open(struct vm_area_struct *vma)
+static int gntalloc_vma_open(struct vm_area_struct *vma)
 {
 	struct gntalloc_vma_private_data *priv = vma->vm_private_data;
 
 	if (!priv)
-		return;
+		return 0;
 
 	mutex_lock(&gref_mutex);
 	priv->users++;
 	mutex_unlock(&gref_mutex);
+
+	return 0;
 }
 
 static void gntalloc_vma_close(struct vm_area_struct *vma)
diff --git a/drivers/xen/gntdev.c b/drivers/xen/gntdev.c
index 49957e3ab49d..3715a27a19f4 100644
--- a/drivers/xen/gntdev.c
+++ b/drivers/xen/gntdev.c
@@ -500,12 +500,14 @@ static void unmap_grant_pages(struct gntdev_grant_map *map, int offset,
 
 /* ------------------------------------------------------------------ */
 
-static void gntdev_vma_open(struct vm_area_struct *vma)
+static int gntdev_vma_open(struct vm_area_struct *vma)
 {
 	struct gntdev_grant_map *map = vma->vm_private_data;
 
 	pr_debug("gntdev_vma_open %p\n", vma);
 	refcount_inc(&map->users);
+
+	return 0;
 }
 
 static void gntdev_vma_close(struct vm_area_struct *vma)
diff --git a/drivers/xen/privcmd-buf.c b/drivers/xen/privcmd-buf.c
index 4cb66eb54602..81f7c2ce689d 100644
--- a/drivers/xen/privcmd-buf.c
+++ b/drivers/xen/privcmd-buf.c
@@ -84,16 +84,18 @@ static int privcmd_buf_release(struct inode *ino, struct file *file)
 	return 0;
 }
 
-static void privcmd_buf_vma_open(struct vm_area_struct *vma)
+static int privcmd_buf_vma_open(struct vm_area_struct *vma)
 {
 	struct privcmd_buf_vma_private *vma_priv = vma->vm_private_data;
 
 	if (!vma_priv)
-		return;
+		return 0;
 
 	mutex_lock(&vma_priv->file_priv->lock);
 	vma_priv->users++;
 	mutex_unlock(&vma_priv->file_priv->lock);
+
+	return 0;
 }
 
 static void privcmd_buf_vma_close(struct vm_area_struct *vma)
diff --git a/fs/afs/file.c b/fs/afs/file.c
index 4c78d3441785..6a123935c849 100644
--- a/fs/afs/file.c
+++ b/fs/afs/file.c
@@ -25,7 +25,7 @@ static ssize_t afs_file_read_iter(struct kiocb *iocb, struct iov_iter *iter);
 static ssize_t afs_file_splice_read(struct file *in, loff_t *ppos,
 				    struct pipe_inode_info *pipe,
 				    size_t len, unsigned int flags);
-static void afs_vm_open(struct vm_area_struct *area);
+static int afs_vm_open(struct vm_area_struct *area);
 static void afs_vm_close(struct vm_area_struct *area);
 static vm_fault_t afs_vm_map_pages(struct vm_fault *vmf, pgoff_t start_pgoff, pgoff_t end_pgoff);
 static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
@@ -528,12 +528,14 @@ static int afs_mapped(unsigned long start, unsigned long end, pgoff_t pgoff,
 	return 0;
 }
 
-static void afs_vm_open(struct vm_area_struct *vma)
+static int afs_vm_open(struct vm_area_struct *vma)
 {
 	struct file *file = vma->vm_file;
 	struct afs_vnode *vnode = AFS_FS_I(file_inode(file));
 
 	afs_add_open_mmap(vnode);
+
+	return 0;
 }
 
 static void afs_vm_close(struct vm_area_struct *vma)
diff --git a/fs/coda/file.c b/fs/coda/file.c
index 6ca8bfcb58f2..2979c697aa65 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -119,16 +119,21 @@ coda_file_splice_read(struct file *coda_file, loff_t *ppos,
 	return ret;
 }
 
-static void
+static int
 coda_vm_open(struct vm_area_struct *vma)
 {
 	struct coda_vm_ops *cvm_ops =
 		container_of(vma->vm_ops, struct coda_vm_ops, vm_ops);
+	int ret = 0;
 
 	refcount_inc(&cvm_ops->refcnt);
 
 	if (cvm_ops->host_vm_ops && cvm_ops->host_vm_ops->open)
-		cvm_ops->host_vm_ops->open(vma);
+		ret = cvm_ops->host_vm_ops->open(vma);
+	if (ret)
+		refcount_dec(&cvm_ops->refcnt);
+
+	return ret;
 }
 
 static void
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index cca9f83fc9b5..33187396b681 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -360,21 +360,24 @@ static ssize_t kernfs_fop_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	return len;
 }
 
-static void kernfs_vma_open(struct vm_area_struct *vma)
+static int kernfs_vma_open(struct vm_area_struct *vma)
 {
 	struct file *file = vma->vm_file;
 	struct kernfs_open_file *of = kernfs_of(file);
+	int ret = 0;
 
 	if (!of->vm_ops)
-		return;
+		return 0;
 
 	if (!kernfs_get_active_of(of))
-		return;
+		return 0;
 
 	if (of->vm_ops->open)
-		of->vm_ops->open(vma);
+		ret = of->vm_ops->open(vma);
 
 	kernfs_put_active_of(of);
+
+	return ret;
 }
 
 static vm_fault_t kernfs_vma_fault(struct vm_fault *vmf)
diff --git a/include/drm/drm_gem.h b/include/drm/drm_gem.h
index ed329408acbe..7259f62d0aaa 100644
--- a/include/drm/drm_gem.h
+++ b/include/drm/drm_gem.h
@@ -540,7 +540,7 @@ int drm_gem_object_init(struct drm_device *dev,
 void drm_gem_private_object_init(struct drm_device *dev,
 				 struct drm_gem_object *obj, size_t size);
 void drm_gem_private_object_fini(struct drm_gem_object *obj);
-void drm_gem_vm_open(struct vm_area_struct *vma);
+int drm_gem_vm_open(struct vm_area_struct *vma);
 void drm_gem_vm_close(struct vm_area_struct *vma);
 int drm_gem_mmap_obj(struct drm_gem_object *obj, unsigned long obj_size,
 		     struct vm_area_struct *vma);
diff --git a/include/drm/ttm/ttm_bo.h b/include/drm/ttm/ttm_bo.h
index 32791c4db2a9..b3ddf710a543 100644
--- a/include/drm/ttm/ttm_bo.h
+++ b/include/drm/ttm/ttm_bo.h
@@ -449,7 +449,7 @@ vm_fault_t ttm_bo_vm_fault_reserved(struct vm_fault *vmf,
 				    pgprot_t prot,
 				    pgoff_t num_prefault);
 vm_fault_t ttm_bo_vm_fault(struct vm_fault *vmf);
-void ttm_bo_vm_open(struct vm_area_struct *vma);
+int ttm_bo_vm_open(struct vm_area_struct *vma);
 void ttm_bo_vm_close(struct vm_area_struct *vma);
 int ttm_bo_vm_access(struct vm_area_struct *vma, unsigned long addr,
 		     void *buf, int len, int write);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 77b5d450fe45..dedc5a850c49 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -786,9 +786,16 @@ struct vm_operations_struct {
 	/**
 	 * @open: Called when a VMA is remapped, split or forked. Not called
 	 * upon first mapping a VMA.
+	 *
+	 * Returns %0 on success, or an error otherwise. On error the operation
+	 * fails, the new VMA is discarded and @close is not called for it, so
+	 * undo anything done here first. The split or remap may be the last step
+	 * of a larger operation that can't be fully undone, so only fail if the
+	 * VMA can't work otherwise, such as when an allocation fails.
+	 *
 	 * Context: User context.  May sleep.  Caller holds mmap_lock.
 	 */
-	void (*open)(struct vm_area_struct *vma);
+	int (*open)(struct vm_area_struct *vma);
 	/**
 	 * @close: Called when the VMA is being removed from the MM.
 	 * Context: User context.  May sleep.  Caller holds mmap_lock.
diff --git a/ipc/shm.c b/ipc/shm.c
index 83ac223352ba..f9b81d1a0a3a 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -99,7 +99,7 @@ static const struct vm_operations_struct shm_vm_ops;
 	ipc_unlock(&(shp)->shm_perm)
 
 static int newseg(struct ipc_namespace *, struct ipc_params *);
-static void shm_open(struct vm_area_struct *vma);
+static int shm_open(struct vm_area_struct *vma);
 static void shm_close(struct vm_area_struct *vma);
 static void shm_destroy(struct ipc_namespace *ns, struct shmid_kernel *shp);
 #ifdef CONFIG_PROC_FS
@@ -299,15 +299,18 @@ static int __shm_open(struct shm_file_data *sfd)
 }
 
 /* This is called by fork, once for every shm attach. */
-static void shm_open(struct vm_area_struct *vma)
+static int shm_open(struct vm_area_struct *vma)
 {
 	struct file *file = vma->vm_file;
 	struct shm_file_data *sfd = shm_file_data(file);
 	int err;
 
 	/* Always call underlying open if present */
-	if (sfd->vm_ops->open)
-		sfd->vm_ops->open(vma);
+	if (sfd->vm_ops->open) {
+		err = sfd->vm_ops->open(vma);
+		if (err)
+			return err;
+	}
 
 	err = __shm_open(sfd);
 	/*
@@ -315,6 +318,8 @@ static void shm_open(struct vm_area_struct *vma)
 	 * Either way, the ID is busted.
 	 */
 	WARN_ON_ONCE(err);
+
+	return 0;
 }
 
 /*
diff --git a/kernel/bpf/arena.c b/kernel/bpf/arena.c
index ec2bda1a6ebf..6ba2320f975b 100644
--- a/kernel/bpf/arena.c
+++ b/kernel/bpf/arena.c
@@ -450,11 +450,13 @@ static int remember_vma(struct bpf_arena *arena, struct vm_area_struct *vma)
 	return 0;
 }
 
-static void arena_vm_open(struct vm_area_struct *vma)
+static int arena_vm_open(struct vm_area_struct *vma)
 {
 	struct vma_list *vml = vma->vm_private_data;
 
 	refcount_inc(&vml->mmap_count);
+
+	return 0;
 }
 
 static int arena_vm_may_split(struct vm_area_struct *vma, unsigned long addr)
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 60c4d84b9aba..efad9040aa99 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1072,12 +1072,14 @@ static ssize_t bpf_dummy_write(struct file *filp, const char __user *buf,
 }
 
 /* called for any extra memory-mapped regions (except initial) */
-static void bpf_map_mmap_open(struct vm_area_struct *vma)
+static int bpf_map_mmap_open(struct vm_area_struct *vma)
 {
 	struct bpf_map *map = vma->vm_file->private_data;
 
 	if (vma->vm_flags & VM_MAYWRITE)
 		bpf_map_write_active_inc(map);
+
+	return 0;
 }
 
 /* called for all unmapped memory region (including initial) */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 457d75ea7142..55747fa82ef3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7020,7 +7020,7 @@ typedef void (*mapped_f)(struct perf_event *event, struct mm_struct *mm);
 	f;					\
 })
 
-static void perf_mmap_open(struct vm_area_struct *vma)
+static int perf_mmap_open(struct vm_area_struct *vma)
 {
 	struct perf_event *event = vma->vm_file->private_data;
 	mapped_f mapped = get_mapped(event, event_mapped);
@@ -7033,6 +7033,8 @@ static void perf_mmap_open(struct vm_area_struct *vma)
 
 	if (mapped)
 		mapped(event, vma->vm_mm);
+
+	return 0;
 }
 
 static void perf_pmu_output_stop(struct perf_event *event);
diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e8c4efa8107b..9ff7736e4d91 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -7428,12 +7428,14 @@ static long tracing_buffers_ioctl(struct file *file, unsigned int cmd, unsigned
  * This is called when a VMA is duplicated (e.g., on fork()) to increment
  * the user_mapped counter without remapping pages.
  */
-static void tracing_buffers_mmap_open(struct vm_area_struct *vma)
+static int tracing_buffers_mmap_open(struct vm_area_struct *vma)
 {
 	struct ftrace_buffer_info *info = vma->vm_file->private_data;
 	struct trace_iterator *iter = &info->iter;
 
 	ring_buffer_map_dup(iter->array_buffer->buffer, iter->cpu_file);
+
+	return 0;
 }
 
 static void tracing_buffers_mmap_close(struct vm_area_struct *vma)
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index cb2de24affdc..c94d491b338b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4754,7 +4754,7 @@ static int hugetlb_acct_memory(struct hstate *h, long delta)
 	return ret;
 }
 
-static void hugetlb_vm_op_open(struct vm_area_struct *vma)
+static int hugetlb_vm_op_open(struct vm_area_struct *vma)
 {
 	struct resv_map *resv = vma_resv_map(vma);
 
@@ -4792,6 +4792,8 @@ static void hugetlb_vm_op_open(struct vm_area_struct *vma)
 			hugetlb_vma_lock_alloc(vma);
 		}
 	}
+
+	return 0;
 }
 
 static void hugetlb_vm_op_close(struct vm_area_struct *vma)
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index cf6429f09477..4a387985a157 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -4394,7 +4394,7 @@ static __poll_t packet_poll(struct file *file, struct socket *sock,
  * for user mmaps.
  */
 
-static void packet_mm_open(struct vm_area_struct *vma)
+static int packet_mm_open(struct vm_area_struct *vma)
 {
 	struct file *file = vma->vm_file;
 	struct socket *sock = file->private_data;
@@ -4402,6 +4402,8 @@ static void packet_mm_open(struct vm_area_struct *vma)
 
 	if (sk)
 		atomic_long_inc(&pkt_sk(sk)->mapped);
+
+	return 0;
 }
 
 static void packet_mm_close(struct vm_area_struct *vma)
diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 1f5ebfd2886a..2b3fe01e13f2 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -3942,11 +3942,13 @@ static int snd_pcm_mmap_control(struct snd_pcm_substream *substream, struct file
 /*
  * snd_pcm_mmap_data_open - increase the mmap counter
  */
-static void snd_pcm_mmap_data_open(struct vm_area_struct *area)
+static int snd_pcm_mmap_data_open(struct vm_area_struct *area)
 {
 	struct snd_pcm_substream *substream = area->vm_private_data;
 
 	atomic_inc(&substream->mmap_count);
+
+	return 0;
 }
 
 /*
diff --git a/sound/usb/usx2y/usx2yhwdeppcm.c b/sound/usb/usx2y/usx2yhwdeppcm.c
index f1d5b4b797ad..248355d5984d 100644
--- a/sound/usb/usx2y/usx2yhwdeppcm.c
+++ b/sound/usb/usx2y/usx2yhwdeppcm.c
@@ -658,8 +658,9 @@ static int snd_usx2y_hwdep_pcm_release(struct snd_hwdep *hw, struct file *file)
 	return err;
 }
 
-static void snd_usx2y_hwdep_pcm_vm_open(struct vm_area_struct *area)
+static int snd_usx2y_hwdep_pcm_vm_open(struct vm_area_struct *area)
 {
+	return 0;
 }
 
 static void snd_usx2y_hwdep_pcm_vm_close(struct vm_area_struct *area)
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index dc4927d26296..d418d9000b63 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -640,9 +640,16 @@ struct vm_operations_struct {
 	/**
 	 * @open: Called when a VMA is remapped, split or forked. Not called
 	 * upon first mapping a VMA.
+	 *
+	 * Returns %0 on success, or an error otherwise. On error the operation
+	 * fails, the new VMA is discarded and @close is not called for it, so
+	 * undo anything done here first. The split or remap may be the last step
+	 * of a larger operation that can't be fully undone, so only fail if the
+	 * VMA can't work otherwise, such as when an allocation fails.
+	 *
 	 * Context: User context.  May sleep.  Caller holds mmap_lock.
 	 */
-	void (*open)(struct vm_area_struct *vma);
+	int (*open)(struct vm_area_struct *vma);
 	/**
 	 * @close: Called when the VMA is being removed from the MM.
 	 * Context: User context.  May sleep.  Caller holds mmap_lock.

-- 
2.55.0


