Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C9A4C87FCA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 01:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB1F56B0098; Tue, 29 Jul 2025 21:53:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A636E6B0099; Tue, 29 Jul 2025 21:53:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978126B009A; Tue, 29 Jul 2025 21:53:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88E2E6B0098
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 21:53:01 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 021FB57ABB
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:53:00 +0000 (UTC)
X-FDA: 83719257762.18.05A63C0
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com [209.85.219.201])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3E04E140007
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:52:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ghgBv1qx;
	spf=pass (imf23.hostedemail.com: domain of 3-nqJaA4KCGEHR99BL9MI9QQDRFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--isaacmanjarres.bounces.google.com designates 209.85.219.201 as permitted sender) smtp.mailfrom=3-nqJaA4KCGEHR99BL9MI9QQDRFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--isaacmanjarres.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753840379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EFr/UvDdK6SWWx6RBLxb5NvZO6MxbSmkX1gTh8Tsnig=;
	b=ZrXUd9RsfidF7XCVSPDhvC0iy2rZD76ffWzk5yOIjdAlcKyVo4gAoL639/7m/klOdcoKhS
	WWR8CwEvmFzB3h3ZGcRCqZbKiqgdEi5AFx8qA7YF1rakco1/rxrenExxU2PDiq9Jo8D2x9
	RJ1JaITS1oerv4GvcYs0pPxuadv41Vg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753840379; a=rsa-sha256;
	cv=none;
	b=lqpAcXCtM8dEGmyeFhnb+YfgCMGeI6LwT5SW601AMDXIcDm8sLw5b9YcRl8xx0Maqa2heG
	gRNeOfkSNvRy+qBIRxwalqjgrwOIEsq2W2Qn4v4XcN8iPuIcE/LKvHIna+/C68/W7EVTlS
	PGPPXFha+uvaPtgdfXLErC8ypLr/xlE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ghgBv1qx;
	spf=pass (imf23.hostedemail.com: domain of 3-nqJaA4KCGEHR99BL9MI9QQDRFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--isaacmanjarres.bounces.google.com designates 209.85.219.201 as permitted sender) smtp.mailfrom=3-nqJaA4KCGEHR99BL9MI9QQDRFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--isaacmanjarres.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yb1-f201.google.com with SMTP id 3f1490d57ef6-e8e13403e45so2926627276.3
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:52:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753840378; x=1754445178; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=EFr/UvDdK6SWWx6RBLxb5NvZO6MxbSmkX1gTh8Tsnig=;
        b=ghgBv1qxdxV7R3QqOeynf7xHj1Mu4VFtuEPQ/v9yhLz8OWNk3EMNCkdJNUPmzB2IUu
         AcIREDOvVIZcvenSoxXaeIXultmmh99V8YYh4ndFF9fkIMr265I08QiXMbF9FMD1E8U2
         avzyYrdsnLvYn68Aql4/iHxwVKpTv45uf3jApUwRM7AKENncTJmNluW/rtL2nNPpIXXi
         YusWF/Dat9e/wxYNNEZcQlOkKU0IqRXiyAu5epsg/k+BzVuzX3rnG0kOzVGCphRE6BU3
         oYmaDnxd+a6KC+ZT3MRC97Cuyk2BgJ7ho957br6RR/t92LJnqi+PV3/nt2tAAEPz4GZ4
         tu2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753840378; x=1754445178;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EFr/UvDdK6SWWx6RBLxb5NvZO6MxbSmkX1gTh8Tsnig=;
        b=UbfuRGIBG5MlfSaIM9dLuqRM/8WnUclKbHqbhXZ1xIKehfJUNfbAqn/3w9jP5tKG8Q
         NKaMgN1wI4bVD4T+Mg3CicCuyMPvXufDc0nBJ6ixtq2Z/4XiIU3fY/0dDjE+R9tSYyiV
         eMi4fagHNuVoR47O8K8Fu/dvY19CrVCqNy9cHFfC1A/fdwQh6X1DhgJCSSLxTrCKZg1b
         8x0Y1j3ZYkyAhrHY+Re8/yeR56uD2ssQbnB40oxLa6gJejvUIQEIM4Vpi7ka0yFbQ85m
         wSnWMgve45bUXjhMREffgcXThGPUxgOa5I5KEXx86dtIBL9naFNNalqSZ8Bx5WLER3MA
         q9XQ==
X-Forwarded-Encrypted: i=1; AJvYcCW59BxbxYzzuPOlXcITof7fG2x9rn5pMe9xvta2K3eihjD2hm/V9c5Kxr27b8Kg+Y4qz1IFljKS1A==@kvack.org
X-Gm-Message-State: AOJu0Yzh96xH+FDMg80brChLcfR7nJV3ax2BPk29rilSYusomJsCmdZw
	eZ6q0veekldnTsuGchhe9H4KarAIFIW9EDOtvaRL3cXLerHWMYJZI6D1PVMNSAj2qyKi6IggJtK
	QnLfBtPAD14rm0ZYJSIjf84AZVH3w2h+rpT1jwg==
X-Google-Smtp-Source: AGHT+IG1cJhmCCZIkkMafM0jzony5iZe8ksvoa9M4ezF0eX0aWEDihWVZCPpSJiee5XVHyXovfPD3ubRCc8t5wyjc8VHNw==
X-Received: from ybbdt4.prod.google.com ([2002:a05:6902:2504:b0:e8e:be3:249e])
 (user=isaacmanjarres job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6902:160b:b0:e8e:290b:7f91 with SMTP id 3f1490d57ef6-e8e314d390amr2232654276.6.1753840378293;
 Tue, 29 Jul 2025 18:52:58 -0700 (PDT)
Date: Tue, 29 Jul 2025 18:52:41 -0700
In-Reply-To: <20250730015247.30827-1-isaacmanjarres@google.com>
Mime-Version: 1.0
References: <20250730015247.30827-1-isaacmanjarres@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250730015247.30827-3-isaacmanjarres@google.com>
Subject: [PATCH 6.1.y 2/4] mm: update memfd seal write check to include F_SEAL_WRITE
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: aliceryhl@google.com, stable@vger.kernel.org, 
	"Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com, 
	Lorenzo Stoakes <lstoakes@gmail.com>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3E04E140007
X-Stat-Signature: ojcqctoxzyog1yh8p445t86ifg1kcsxd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753840379-803744
X-HE-Meta: U2FsdGVkX1+FQ/DfSF6nNqkUvk8v1PYwhiULyG0O85+w/AyP91Bjq8Cb1yNaHH2FvdB1Uoth9ULTPbRMG01m/1Rn8RkmPOxKqOtWaYdNImzricRtGZrAd5tGOPvQx/qMPGOPLv5bJ5aeOhH9Sjj8u0oan7E5C64qE8RcG/A6MhV4bh982egI0XiinuWlyOw3XKcOtnABad+sdYASzQswJOzIkZe2ZZE5Cgnoytej+RyO/9Ljr0DT1iulPj7QY6n56razUAAUliJKXwU2tydQggaXhBHYcbNxMN9n2BQPT96tG/kiJcQvAZfuNGx5A+shcknTUMclhOX/Mvv82lWFwD5Du/bKfJLF5EINppObEpER1RGo4OOQyCwVxBKVKdNI1pW0/mE76ghwxvOkyl/Y71l9WSzY+FCxAswZKh9s5jzu1WKVtNW+V9p/5KyztFXiNyMKQXUeYDZFdsXyZMmUkqazfKBKnWgP1vKLu6hBMrRjap1UDAP2DU9XVJxsrj9f9m7cMtjX7mYnrMHPFr+uSJL/586WpzIu0EJJZUL2cqr1wY2Zeo6QZkUtGGRcCg3v1z7drXAFsB5J6UZe/xrNOCDOYVek0CaYtsy90l7IVnukWMNyyZp7wZeZcvPQQW0SCcQuvnQYtwk8LQj6veoP5wcABvezcUV6CaUHXCFKv62pPgrPo5kXzvI6988i0cm+ccCq6bQXjYVII87Sd5bERknfkHpsanGLhBx5HE6Ck7zy2rF2EK0rPzJln4cN1h33+JNCP2sotqTTSHREP9SCOxvjajWvluym8/3tXilwXVucUhXCWXOq14Xyp/Lyeym6B7aNwEPOTqNts7Kxnpgu/iqW8ZSIN1o+tPsodcNfHF9kl6pJadySdY51V+SwzGKQCyhnJMfbLjrHIGaEv2g+CEifpcFmuBuE48k4VZwvif/JDAqk4IMoyBP6QOdIfapUB8EzSgJbMDmcovUT3fq
 K9mKUPu9
 pLPG1TP5kxOynQ8NWBrfoxxdk6AXsJMs0gHqvZF+5I0MBoa9FPhgbempjRG2QQbo0inKe/eG1dJEVl3jX0xR+W4B95PJe33JzHor7F6Vt4O6XzNp9OrXs54AQ0B7B7eYO1HHvsM+UOqH+vvqI2G60w5AQsLZ3NJTMDbqvvRDDFqBMfwiglZ1Nob95w4+gQWsyLnmFp5/SdbHeP9FiowEdLmHN/6l7MyOcVGzF31F/YvinhqHnk2+yMt7BHTqlfJFzu9ejcUlUQxpkYNKFCnQewzkQJXKBqaH6/WXUxS1Ssld1dxk+rXBy6wtaX5+j480J4pLfBC4Bo0NZElUHmf6DK+TzgUMRTaot6k9pZsUMEjCAukmkZzRiecI+Kr1ZycKB/PF0OQhhmHYVb/aTA7JKbMdyq0kYOphZZnky16OXdYwljWrugxgARXPenk0q34t+wK/qDxWYL+KW6U0gfOKf19Yk/CVh4rjygYt/v2kHYJp9wQoeV6+JiZl1iY8Gbi8ZsbX4a90Fzr/m5PvpN3PQaJZzvkM7b+ZsC1L1XkU4AZVvHcPVzUzj5O4ALaT/9S4HWteD7ZD2K6JQSYO9Bp6qs1HpOvDvuvgMKjbOtmkvxOpYyrQZC/PNghcNxUaIyDehv1wpSnUI1X8ilZU+jK5DURtuyl/df+JU7j6QE/FPPvTeLxl3pvhk2GK2fRiM94pxJ1viFyw0YAStW+hrcL9rORIb7HoBuMFuLsosEsmFXKdT4ggCZOjyleY1veRSh8efJrqY+MeZPvhMw4C2cQmRRGrrI3Gs4LGnltmcuobZtSLz4FgHISJQxDDO/9gHMsBMDXhYS8MTZuRVY9CLhDtXmGAzGiOVYJON4V0QlIFAYGH62ciR+ZgZceWrraK2KjBe8+Nb+3zs0jTBiMVOLaUt+EerkguNAz5t5DWW0IPFTN4ob8I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <lstoakes@gmail.com>

[ Upstream commit 28464bbb2ddc199433383994bcb9600c8034afa1 ]

The seal_check_future_write() function is called by shmem_mmap() or
hugetlbfs_file_mmap() to disallow any future writable mappings of an memfd
sealed this way.

The F_SEAL_WRITE flag is not checked here, as that is handled via the
mapping->i_mmap_writable mechanism and so any attempt at a mapping would
fail before this could be run.

However we intend to change this, meaning this check can be performed for
F_SEAL_WRITE mappings also.

The logic here is equally applicable to both flags, so update this
function to accommodate both and rename it accordingly.

Link: https://lkml.kernel.org/r/913628168ce6cce77df7d13a63970bae06a526e0.1697116581.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
---
 fs/hugetlbfs/inode.c |  2 +-
 include/linux/mm.h   | 15 ++++++++-------
 mm/shmem.c           |  2 +-
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 330729445d8a..d4b2a199cb9d 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -136,7 +136,7 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND;
 	vma->vm_ops = &hugetlb_vm_ops;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b1509be77efb..fcd61558ebcb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3526,25 +3526,26 @@ static inline void mem_dump_obj(void *object) {}
 #endif
 
 /**
- * seal_check_future_write - Check for F_SEAL_FUTURE_WRITE flag and handle it
+ * seal_check_write - Check for F_SEAL_WRITE or F_SEAL_FUTURE_WRITE flags and
+ *                    handle them.
  * @seals: the seals to check
  * @vma: the vma to operate on
  *
- * Check whether F_SEAL_FUTURE_WRITE is set; if so, do proper check/handling on
- * the vma flags.  Return 0 if check pass, or <0 for errors.
+ * Check whether F_SEAL_WRITE or F_SEAL_FUTURE_WRITE are set; if so, do proper
+ * check/handling on the vma flags.  Return 0 if check pass, or <0 for errors.
  */
-static inline int seal_check_future_write(int seals, struct vm_area_struct *vma)
+static inline int seal_check_write(int seals, struct vm_area_struct *vma)
 {
-	if (seals & F_SEAL_FUTURE_WRITE) {
+	if (seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
 		/*
 		 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
-		 * "future write" seal active.
+		 * write seals are active.
 		 */
 		if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE))
 			return -EPERM;
 
 		/*
-		 * Since an F_SEAL_FUTURE_WRITE sealed memfd can be mapped as
+		 * Since an F_SEAL_[FUTURE_]WRITE sealed memfd can be mapped as
 		 * MAP_SHARED and read-only, take care to not allow mprotect to
 		 * revert protections on such mappings. Do this only for shared
 		 * mappings. For private mappings, don't need to mask
diff --git a/mm/shmem.c b/mm/shmem.c
index 2e6b7db7f14b..2034b9b3fb71 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2302,7 +2302,7 @@ static int shmem_mmap(struct file *file, struct vm_area_struct *vma)
 	struct shmem_inode_info *info = SHMEM_I(file_inode(file));
 	int ret;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 
-- 
2.50.1.552.g942d659e1b-goog


