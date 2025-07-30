Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A915C87FCA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 00:58:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE3918E0002; Tue, 29 Jul 2025 20:58:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C93E18E0001; Tue, 29 Jul 2025 20:58:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B82FC8E0002; Tue, 29 Jul 2025 20:58:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9FDBD8E0001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 20:58:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0D88D802F0
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 00:58:39 +0000 (UTC)
X-FDA: 83719120758.07.833FD6F
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf21.hostedemail.com (Postfix) with ESMTP id 325CF1C0005
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 00:58:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rTlf6OpA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3O26JaA4KCIgu4mmoymzvm33q4s00sxq.o0yxuz69-yyw7mow.03s@flex--isaacmanjarres.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3O26JaA4KCIgu4mmoymzvm33q4s00sxq.o0yxuz69-yyw7mow.03s@flex--isaacmanjarres.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753837117; a=rsa-sha256;
	cv=none;
	b=7/8+khdmkmIVJ99k6MBfyMSDfvPNPDxKKAJeBZiLrLGscYfmyImPHo/7Lw0Bf1V+KF/B6q
	3mOOwxzyJ4pEoftEsR2s5K5HFPVBVC3cMLm6aGSg1ZNt3GauF875QGeYyhKaVZpuLCVSXc
	qgExF0f/+2mHgVT9lk4yivp2qlxaizs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rTlf6OpA;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of 3O26JaA4KCIgu4mmoymzvm33q4s00sxq.o0yxuz69-yyw7mow.03s@flex--isaacmanjarres.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3O26JaA4KCIgu4mmoymzvm33q4s00sxq.o0yxuz69-yyw7mow.03s@flex--isaacmanjarres.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753837117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=05zj0+Q+MKMGwc697BcOisoUJr9tGqN15IKwcysHRAw=;
	b=ulMuasMyma0OgrpIbS86r1vhIP+UfAXkjPdqbOtuMgE/ZaohIkLNyMpO0O1siHGRy1UY+d
	5PwW0raFPqZfVx6AGpNBQ06CX8uZEsXx19OYO8wre2bAf/UlEj2n/dYTUKOVsxZRgPkJQT
	edAElaq4KwAXQXg+heg6V8Xgrs/CV/o=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-b38d8ee46a5so413392a12.1
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 17:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753837116; x=1754441916; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=05zj0+Q+MKMGwc697BcOisoUJr9tGqN15IKwcysHRAw=;
        b=rTlf6OpAkvaqeKbjxSGdM+ejJg+TSXkvNt12Em1wf2jwwgPD1X3lAs+1pUYS9NFeKc
         O3n96Amq5R7mqXvuG0YmUPI4N8zCmTDA+yoJe9Br5sVgXK3q1OwU0oFbWLIe44LOsw0C
         nSYmVyV7841l/b+x8zHbCcGcOBQMT+ykvzXv9rHb7K0+APGUxc1bgf8OP4VSa7zIIYE3
         04j/QvK8rFRvm2JTxOav0mjNfpVWkB+jLy5t9gNYxc6bBIxvgP+6cb+x1mHb1JqE10Pr
         Q/8xnqKZtKHFHTykXMaX9SdmroZHi8RbMGhIAlUm5l+VquOiH+b5rLBvIqgRHkuIGmhw
         1Q6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753837116; x=1754441916;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=05zj0+Q+MKMGwc697BcOisoUJr9tGqN15IKwcysHRAw=;
        b=uPhjFPP+E5h6TzwHlQN/yAK3YESnhLzC8+zVGu7y/3qU+SfsrU16qMOSZKkymLWxlI
         MElnBP5sKi+yPEHdT8ZnbNfGbX1YYCiXUGfdhYKNw75OOMkeZDhY2R6iUVbh/T5oUIaO
         Tlg+Lb6FvghdixKjjbuOYEW8YWnje78WM/T/OxafSzPjnQHdcSO2BSWTXG8Zp6d5dbMs
         TDgtuQYGQD/xo22UbAtGD3clIFywuHajzx+yZuYybrRgd8rC6JBYAaG/yyV0xk251lKb
         wF2/R14J9fD2anrdsWwi1l5RbNd290kCLcEFu8ZooTOTfwYtLlc3JDb0uC1rrftbqs56
         RMlw==
X-Forwarded-Encrypted: i=1; AJvYcCV8g/UiINug0YKs4P1NlJxguwfQhdLdY9RgK5Hlyb9dYRz3oGMEsSgZJKczZo3LMtWL3fsmMezNVg==@kvack.org
X-Gm-Message-State: AOJu0Yz5keAPpNJlwyDX84StFcoZEe3xy7j784xVWbe4AvQGXoncd7Gw
	mgrMSBhCE7eh43g/iAAagWuMJ4EMO7hHN2iIb6Ze6xSOPuSMjLVp6DrNHbjarJTUtQKpr0Y+MbP
	bdTpu/8YF+2cY442ttrH8ojI129FHzaLERf6PuA==
X-Google-Smtp-Source: AGHT+IGWEjzOhQFYUAsEeOg6aONv1hOYMAFaYzjzUDUBEthSw7afXLd4o0cXyx997qVkvbfXma0R0HZEHo009a/07XIOQA==
X-Received: from pglf36.prod.google.com ([2002:a63:1024:0:b0:b42:c17:47ac])
 (user=isaacmanjarres job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6300:210d:b0:225:9ac1:7c6b with SMTP id adf61e73a8af0-23dadafe765mr10380648637.4.1753837115424;
 Tue, 29 Jul 2025 17:58:35 -0700 (PDT)
Date: Tue, 29 Jul 2025 17:58:06 -0700
In-Reply-To: <20250730005818.2793577-1-isaacmanjarres@google.com>
Mime-Version: 1.0
References: <20250730005818.2793577-1-isaacmanjarres@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250730005818.2793577-2-isaacmanjarres@google.com>
Subject: [PATCH 5.4.y 1/3] mm: drop the assumption that VM_SHARED always
 implies writable
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: aliceryhl@google.com, stable@vger.kernel.org, 
	"Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Lorenzo Stoakes <lstoakes@gmail.com>, Andy Lutomirski <luto@kernel.org>, 
	Mike Kravetz <mike.kravetz@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 325CF1C0005
X-Stat-Signature: y1gpws1iwpo6ea9ntnjjiytp3zqnfxjr
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753837117-995684
X-HE-Meta: U2FsdGVkX18wmbAbLydOnctWBgGtJ/w9p54hy1xZQqAmCHmvzlo7FWrwsAz1O2PetP223hlTFhlPzFYnr73VaZgCXp/D28fCYukIDljv41/wo/cksnqGYi6fsfg0QgaqGBgcohfUD48GTWTPt1xtt2YXeLEW1mJBniSqU+R2Su7Z7K6HqX5MhjGenzMhf/5DWnWV2rkYYOfHR+0lGuuJO+hwYJRLCiyWUNr2ges2qkLdL8T7jdHz7bZQ8GddjENVqBpYkqeJGV+gt2CIQQh9JYbuSRNRwny0WSh/obIF71bClf7qi4QKAzK2hc8ogHkiceuR/0r3zneiZeKcMNuJXu/d/lxyvgoagVKiO85TOP6Qy78O3vflybXPA9EErzadBmvo2glb8TrmwATduXxno940yMoexUlSEnWib7tmzpumXbsVF39htSTdTKogReC/e6Y2EDkiMyhE3vipDwKOD+Wvt5I0To31GI7ayxvsKh63ryk2fEITE8NnKYsppmB8FlwMow433ifLTnvrxCRa1oOBFm9iL+4JbAtboDokw7rc898U4cyrsXR36/YyAOe5H27dL4RCoKI2MfKSTe+lR5v8rgOHTQNnkm/kabmW7lz70mmfi2JXmaM8fxdjpc8EIYBH05LkO9Igi6MFTmnNnajflGeVdZym+J0CvQ80F+FFetldLTLBiX9ZiUs2Vs45TFOl2V2qnfheNyG8WIINEogoKZKxT/a0ZLGiXMHTX7922PHXSQfNPzUnAKRrrB93QO14ZRoYN3euZFhVNb6rZh7bwXjBlDDNSdcP+T8ns28xz7pfT95eu90Ziq/qLe2KP/UTmnDxQgWJYCwVd64Q55x4Hqu1p8HZxBRWXBUSdluKwN5kzWetZ9U7HwM5PJuypjluc8tGy8B41tzmWGteVfUA0zNBLaiTGpHvC3Kl86jQCqHqT1tto/xO/djfFPvGEUGhSkMZPRgNw+9rS/y
 md3Kpo3V
 Ll4GDxPVYoLa1isRJn/NhmODQoeMv3TaczSfKHgT3RLnJjl7TPz1wNyJGdbkoj0TYb9A6DViY9PQ+hFyOLaij/c30lw3TpTOk7wjEqCr3bYwIWiVJf9y5dnWAIdEM8r+Y+Pv5gLKz5EDe7ePhoWWAk9svt5fF7yb5WRBzA9TZFUdrLU8JqYRyNtAgEacQ2Fxls2YC1R7fhu3fvWx0RVtkgZDolVkU3wkw9B0UzQW1NMpS/tt1e4/cbh3G1Cu5jb4n36pW47SwxB2mJqBoTgSW+mStWY3ZqHIeXhJak9s3PvP+sh9QZ8WkV/ImLe761NZ2hrWqxnnK1YWBZtBBIB1HTsqay3LcHlwCo1RUnghl56zjj7qwPTbx3zkiSz+sq9q8TOqk7Wv5XOIxyFxXUrF9FhA5cJRfDDA5NA3Oz69pnia9fxfNRDeRZlxWRUbkY1UfV39ZMQHgpYC/g0+Tfa0u8wG/BdjRyHAbychIRyA0wIe5WZ7ij/TNmqc7DPQ4R72eSGvDknzOOBsfb85d6Sbj1rWSXMFJc0T/1G9fXEN5I6OkeLJrub53pSp6M2u4O4nRemvqB8nTpl6gjjRUTZOW5/JlR3+Ou/q0sO1Y3r14QRymYLYM9ToaPyVkpdpUvjaIISAORP6k0Z3WUEXEACBde6KbeIYf7DwbYiHbJbofreO2t2ZkKv5fikwF8qWkUX5wgkvrROnC2rZL/t0lK6JsqR1nmgiB1kZtQwiT93wZFzHaUiXw2q0Cw74GlhxBD+Veuoq5hL8z6OoR4bBxSJK04un1SkjSbHDvqDPrId4HW/HTZqOFLtxKrfw76qGhVlwO1oPdaXay0E3Oc9iL+ITKlfBbVRK44kgkU4xSWUGSive0Z4oWLkygUY6lx/zdqMduC83v+u1Mhg+SgjJSn2mUmn0h2CLqx50l48J3cg0V/jzTxoU=
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
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
---
 include/linux/fs.h |  4 ++--
 include/linux/mm.h | 11 +++++++++++
 kernel/fork.c      |  2 +-
 mm/filemap.c       |  2 +-
 mm/madvise.c       |  2 +-
 mm/mmap.c          | 10 +++++-----
 6 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index d3648a55590c..c5985d72d60e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -430,7 +430,7 @@ int pagecache_write_end(struct file *, struct address_space *mapping,
  * @host: Owner, either the inode or the block_device.
  * @i_pages: Cached pages.
  * @gfp_mask: Memory allocation flags to use for allocating pages.
- * @i_mmap_writable: Number of VM_SHARED mappings.
+ * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
  * @nr_thps: Number of THPs in the pagecache (non-shmem only).
  * @i_mmap: Tree of private and shared mappings.
  * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
@@ -553,7 +553,7 @@ static inline int mapping_mapped(struct address_space *mapping)
 
 /*
  * Might pages of this file have been modified in userspace?
- * Note that i_mmap_writable counts all VM_SHARED vmas: do_mmap_pgoff
+ * Note that i_mmap_writable counts all VM_SHARED, VM_MAYWRITE vmas: do_mmap_pgoff
  * marks vma as VM_SHARED if it is shared, and the file was opened for
  * writing i.e. vma may be mprotected writable even if now readonly.
  *
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 4d3657b630db..47d56c96447a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -549,6 +549,17 @@ static inline bool vma_is_anonymous(struct vm_area_struct *vma)
 	return !vma->vm_ops;
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
index e71f96bff1dc..ad3e6e91d828 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -566,7 +566,7 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 			if (tmp->vm_flags & VM_DENYWRITE)
 				atomic_dec(&inode->i_writecount);
 			i_mmap_lock_write(mapping);
-			if (tmp->vm_flags & VM_SHARED)
+			if (vma_is_shared_maywrite(tmp))
 				atomic_inc(&mapping->i_mmap_writable);
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
diff --git a/mm/filemap.c b/mm/filemap.c
index f1ed0400c37c..af3efb23262b 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2876,7 +2876,7 @@ int generic_file_mmap(struct file * file, struct vm_area_struct * vma)
  */
 int generic_file_readonly_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE))
+	if (vma_is_shared_maywrite(vma))
 		return -EINVAL;
 	return generic_file_mmap(file, vma);
 }
diff --git a/mm/madvise.c b/mm/madvise.c
index ac8d68c488b5..3f5331c96ad5 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -839,7 +839,7 @@ static long madvise_remove(struct vm_area_struct *vma,
 			return -EINVAL;
 	}
 
-	if ((vma->vm_flags & (VM_SHARED|VM_WRITE)) != (VM_SHARED|VM_WRITE))
+	if (!vma_is_shared_maywrite(vma))
 		return -EACCES;
 
 	offset = (loff_t)(start - vma->vm_start)
diff --git a/mm/mmap.c b/mm/mmap.c
index eeebbb20accf..cb712ae731cd 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -141,7 +141,7 @@ static void __remove_shared_vm_struct(struct vm_area_struct *vma,
 {
 	if (vma->vm_flags & VM_DENYWRITE)
 		atomic_inc(&file_inode(file)->i_writecount);
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_is_shared_maywrite(vma))
 		mapping_unmap_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
@@ -619,7 +619,7 @@ static void __vma_link_file(struct vm_area_struct *vma)
 
 		if (vma->vm_flags & VM_DENYWRITE)
 			atomic_dec(&file_inode(file)->i_writecount);
-		if (vma->vm_flags & VM_SHARED)
+		if (vma_is_shared_maywrite(vma))
 			atomic_inc(&mapping->i_mmap_writable);
 
 		flush_dcache_mmap_lock(mapping);
@@ -1785,7 +1785,7 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 			if (error)
 				goto free_vma;
 		}
-		if (vm_flags & VM_SHARED) {
+		if (is_shared_maywrite(vm_flags)) {
 			error = mapping_map_writable(file->f_mapping);
 			if (error)
 				goto allow_write_and_free_vma;
@@ -1823,7 +1823,7 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 	/* Once vma denies write, undo our temporary denial count */
 	if (file) {
-		if (vm_flags & VM_SHARED)
+		if (is_shared_maywrite(vm_flags))
 			mapping_unmap_writable(file->f_mapping);
 		if (vm_flags & VM_DENYWRITE)
 			allow_write_access(file);
@@ -1864,7 +1864,7 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 
 	/* Undo any partial mapping done by a device driver. */
 	unmap_region(mm, vma, prev, vma->vm_start, vma->vm_end);
-	if (vm_flags & VM_SHARED)
+	if (is_shared_maywrite(vm_flags))
 		mapping_unmap_writable(file->f_mapping);
 allow_write_and_free_vma:
 	if (vm_flags & VM_DENYWRITE)
-- 
2.50.1.552.g942d659e1b-goog


