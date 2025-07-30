Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A85A9C87FCA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 01:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 496D56B0095; Tue, 29 Jul 2025 21:52:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46EBB6B0096; Tue, 29 Jul 2025 21:52:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AB626B0098; Tue, 29 Jul 2025 21:52:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28B606B0095
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 21:52:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0523411326E
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:52:57 +0000 (UTC)
X-FDA: 83719257636.16.715EB63
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3C3CD40002
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:52:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cRMvDWvd;
	spf=pass (imf11.hostedemail.com: domain of 393qJaA4KCF4EO668I6JF6NNAOCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--isaacmanjarres.bounces.google.com designates 209.85.128.202 as permitted sender) smtp.mailfrom=393qJaA4KCF4EO668I6JF6NNAOCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--isaacmanjarres.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753840376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=opijK7AhKe3RGzDyfUAJ5xJTjdm697jVXAtg305DKTU=;
	b=eikArnmWI3oExec8Ti0js2K7eSZz/8U8UAwyBonP2poX0AVq6xVTVEyxFyyIbB3CTPNzgE
	6H+JOSbWx0lcuq7pMieW7E/VTnbrFL6iclBb8n3xkTViYNOmipl7mSUq2b7i61lMX+X//1
	PsiDwBU45yvVbpO6/khH8s+wEP6Ivl8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753840376; a=rsa-sha256;
	cv=none;
	b=GlLbipVqwHEjTP01+hdw0iTgoqfycn2bVj6y/Qt+/VdNbbmN8CJE51Qv5mc2j95SiiE33T
	EzS4GVu63jAXm9CqQVDT3rMIyo9/Kg31U1C1dV9R6syqCWuMGdFqOeSIFLRU0wZ3rsU/F4
	FdbNNliRAQBR39KhjAXkiE92JPeaaP0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=cRMvDWvd;
	spf=pass (imf11.hostedemail.com: domain of 393qJaA4KCF4EO668I6JF6NNAOCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--isaacmanjarres.bounces.google.com designates 209.85.128.202 as permitted sender) smtp.mailfrom=393qJaA4KCF4EO668I6JF6NNAOCKKCHA.8KIHEJQT-IIGR68G.KNC@flex--isaacmanjarres.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-70e72e81fafso92123937b3.2
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753840375; x=1754445175; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=opijK7AhKe3RGzDyfUAJ5xJTjdm697jVXAtg305DKTU=;
        b=cRMvDWvdgqZIHOOAyGR2f3Xw4WXWVAdnRWDEF91M/V+nGVk5tn5hJfgyG0STH4yrLT
         oY+jsDr9Z5CqVQ+F5RnQmMsgPMFkxgr6vYt3c+I5fIL2HpKqjqO++Kx+mO2TvsyfX0cd
         FUdvPZD0GQkKaf6GnGjzQky1qIgw4ltWjOUDsU2+PROdEytv1VdaJjBghoQFGlmgir3S
         7VGdFWb99kSP00ULGlixuV0wYO+kU49WRL1IPtcHLUiVY2aPzm+/6GAEYPfHmHe7Gpoh
         XPDrHatblVyg1eCh5X7JLutg4LpAWlnu99nPGd/NSKB9ztZYWHuejk9sq+g6RIt4Svjc
         UFmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753840375; x=1754445175;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=opijK7AhKe3RGzDyfUAJ5xJTjdm697jVXAtg305DKTU=;
        b=cjid02UJ3eBMqTV0K/cDKeEEwxoscHeWWW8hnhZ31NQ8JwADzCIFAhIeKauTllNMs4
         gxAL8qv3FCc44hIIx9HBCj8MxA4z3gbrAxi3qTite85v/RFTUOJIAdNf1h8KLzlyBjsh
         Mo4E5+YL8mV3Osw++y4ipPAfaFP68o6c7lLeuPrtxOAXaCj4k3AmgoI8I577yelJ5S5s
         4nRoPcNQnB7Bjljv1dwE58pNf7TJHNisfSFooS950t2wVuPFJZFFonI3B/6/A6NGY9JX
         ei5ezfah9f2rH+QsTbfuOEiAxU5CDVqvVkzozkVt0mHD7zCjQ5XxnK4U1N/wrL0IegdX
         0Phw==
X-Forwarded-Encrypted: i=1; AJvYcCVzjNa9p93J9WugkdF4OdRO3b7yx6BTS5navv0PVRakfPZBtZfpYaRmRMxpcilzJXnBMYn/SM9LAA==@kvack.org
X-Gm-Message-State: AOJu0YxlliN/Vs3jGqWa1W/vYI8Z5+ltGlRLatNG2xYoIPwgVYUfHYIT
	e5DA9Z/jUJwQuyfm0b/EjLLJoHAFbtzKa/0QFOFjd+EOzG7bAWNjITxgb4wZMY5ZFb2AFYeNX8F
	KGFlYfMCDrLgwkefN1fQWwBgm6uJRKTGJ3Z29Lw==
X-Google-Smtp-Source: AGHT+IEVCc5l5RWyhngBBu5Jn/PGO8ldc4WNJBgCRgFdSuvfm1vB570lLkXgISLNjwCFAwCvjc3ka27wVRJji+sTcbvDKg==
X-Received: from ywbhf5.prod.google.com ([2002:a05:690c:6005:b0:71a:35fe:299d])
 (user=isaacmanjarres job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:690c:6911:b0:711:371e:ecbe with SMTP id 00721157ae682-71a4691abbdmr25247057b3.29.1753840375239;
 Tue, 29 Jul 2025 18:52:55 -0700 (PDT)
Date: Tue, 29 Jul 2025 18:52:40 -0700
In-Reply-To: <20250730015247.30827-1-isaacmanjarres@google.com>
Mime-Version: 1.0
References: <20250730015247.30827-1-isaacmanjarres@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250730015247.30827-2-isaacmanjarres@google.com>
Subject: [PATCH 6.1.y 1/4] mm: drop the assumption that VM_SHARED always
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3C3CD40002
X-Stat-Signature: mrftfo3596xxaimqndy3u5g844fncdbh
X-Rspam-User: 
X-HE-Tag: 1753840376-460116
X-HE-Meta: U2FsdGVkX1/jTlWazZRg/qzTUvabBBERhhm1rylFzck/Si/0VR+qgrr8yR40kw/mRLJhibBL4zwnHzzzlQ2Ns2/Q0FEwjl9cdzQxm2khW2c9WSSPgLilSOU37GxcUzguE0a+NoQC5jfK6d1CLj1ebjFwLhTkTBf8MOtJ7YrqVQ1wrZHJgblGg2eAa0/CnHwjOrMi16ZdlP12QVYzaFpMr4SEh8qsV3qbqQYa3N2z+0P8Ub6Tsg6ZOsPrJ8sBvwy9Z8cNAab7O9L+wBJ+BjZGWMxlg6tr+ip6Et+zvYfrfcgNAPE0/obhAaxBudaLdYIb25kLN1iwQRgan9Y86aaoaqZgOUWbdKJ0+Ek1CsAsyZK/C7gqr7JwgBadV68TrDQhpGv38JzM/shwfD+vqNcASC64f8m12Or5kExfMBR6GeBlayhIoxFp3+1+wt17887CkHynnl4EZB3MV22gHvYGNJ6Z1eWjbwnWp/gHCzOPf9pwaUDIMUZYWWLEoXNhuwERAEvLnQKjvLoxocLE0YhkdXjr9VRiji+wiMDfqp/NKpUXBDDwouha1hflF6f5p0Na3RvM1EO4ZLxs/pG08ZdhNNcsGLFc97JrAYxWvxxDhc/NH5NFiFmJvQlHuIuaYUSfS8qXAQqgKtyz4/bUIbkDTuZo5oaj0Pd2iS2uBrGWPpNsiqxH83FS+COFAg70hOpoMeqBwYUt8Zfn/BJH6cbXtBbfZbDOPIAvC0y1WmKFxRGD3D+JG5IxIZZuOo5yn9oKQUuEensR30qpNTkowyS/u2XI8YIIXeqEL6LYIKFBDvSg4/Rbd4QStuXKI0HCbEPRiWfa4XmFk1flrrLxdEJbZoXEtEkF1JNKgFi5eB7v0a6IIcS9XQB8pRHffbS0YlVxHT+oWZBrEMkPVcT9WQ+jYKmlay7kZt1TpxSJMgV7JwE7EguuoccpOmFIK0eMyAHcUxwWOJMKq2wXm3NxXhg
 HKeUku1G
 Tlxg2q8jt0aBjHcmbm2O4FXfsw3HQeR8a0mjzGz/NtntFomPEwum0eGx5Fl8RA4i5mrrXgVNP5Z7b7SJm0cn3mEo08OYjyIcE5qhwcWpd4OlIMJA+Bwc2RavYXLU7eyN6IFEGli4PyJS5Kmybrd5B7Ay4ywFhapNkJy+bbjONd+j6eyYbO0CdyAmNxs8g/3zXF4nXZH5lkQQU836ciaWaLnLta5pX8YO/U0710XpHlyOxEgcy9VZlVWpqFs8ppR0+TbUbam8TsJhYt/xBl3+Cq/w1L4VkmpJDYeDJ2nur6FEKqgAPwcufLYhUB/02d2WqC4kuuqzzs/e+WdxZGN27zFWBaoCYHHe4gUbq+HtLTCOPww3g4JZGxS+K/f8vgBxDxQ3Ln9HvgflQCSMBQ5edstJ/KvZVyMjFX0GTmlGVuu+ZSkqsOZk2KDQMhGncpq/kUJWiVHn3EnLXj95dofB/R6ResJDNaTnRM+m1WbCF6QDOIln8mI8jWLNv/sfvDEmNa4NXxUEOuQNtP08wPYscItGh1biVbMVF9ihmLSkPH4PwUT/HUjqFnfUT6x+ZtyOu+Q4PNfsf4o6Yr3SCxii+ue4XnybmabuxuV8L2ME+jm0hImVnYh9C9a+phCTqBE5T14rO4t/pHZUnysYgpglGOPi2D2sN1ViLW/mFndMDNuATAjy8e59fdF20eVOePwM7EX3Ehq60G+5VNpMSuyJ7xI4/iZdi4itDGIXikvQ9mK/I1LjufPHv9xi7GDxpS09hCRmESPi1IISUlRXbEa02rLH1a1JFtEePWgE+WQnwLRmD+67N9nGXk1vIB4ml2h3YcjeTePn8kaoz4ZWTtQt/CL7t12xbiqdonCnE7FNxSavw6rNvSITNETAmYI4jWzUAh5e8L3bjIwx6NffTHT8s8VBtb3ZI2/eq/BzrB9415m4+pZDFfgqunkfOAQ==
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
 mm/mmap.c          |  8 ++++----
 6 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1a619b681bcc..48758ab29100 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -410,7 +410,7 @@ extern const struct address_space_operations empty_aops;
  *   It is also used to block modification of page cache contents through
  *   memory mappings.
  * @gfp_mask: Memory allocation flags to use for allocating pages.
- * @i_mmap_writable: Number of VM_SHARED mappings.
+ * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
  * @nr_thps: Number of THPs in the pagecache (non-shmem only).
  * @i_mmap: Tree of private and shared mappings.
  * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
@@ -513,7 +513,7 @@ static inline int mapping_mapped(struct address_space *mapping)
 
 /*
  * Might pages of this file have been modified in userspace?
- * Note that i_mmap_writable counts all VM_SHARED vmas: do_mmap
+ * Note that i_mmap_writable counts all VM_SHARED, VM_MAYWRITE vmas: do_mmap
  * marks vma as VM_SHARED if it is shared, and the file was opened for
  * writing i.e. vma may be mprotected writable even if now readonly.
  *
diff --git a/include/linux/mm.h b/include/linux/mm.h
index b36dffbfbe69..b1509be77efb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -673,6 +673,17 @@ static inline bool vma_is_accessible(struct vm_area_struct *vma)
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
 static inline
 struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
 {
diff --git a/kernel/fork.c b/kernel/fork.c
index 8cc313d27188..da318028aa88 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -669,7 +669,7 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 
 			get_file(file);
 			i_mmap_lock_write(mapping);
-			if (tmp->vm_flags & VM_SHARED)
+			if (vma_is_shared_maywrite(tmp))
 				mapping_allow_writable(mapping);
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
diff --git a/mm/filemap.c b/mm/filemap.c
index 6649a853dc5f..2ae6c6146d84 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3554,7 +3554,7 @@ int generic_file_mmap(struct file *file, struct vm_area_struct *vma)
  */
 int generic_file_readonly_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE))
+	if (vma_is_shared_maywrite(vma))
 		return -EINVAL;
 	return generic_file_mmap(file, vma);
 }
diff --git a/mm/madvise.c b/mm/madvise.c
index e1993e18afee..06c5adcaec59 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -980,7 +980,7 @@ static long madvise_remove(struct vm_area_struct *vma,
 			return -EINVAL;
 	}
 
-	if ((vma->vm_flags & (VM_SHARED|VM_WRITE)) != (VM_SHARED|VM_WRITE))
+	if (!vma_is_shared_maywrite(vma))
 		return -EACCES;
 
 	offset = (loff_t)(start - vma->vm_start)
diff --git a/mm/mmap.c b/mm/mmap.c
index 0f303dc8425a..42e55e50b4a5 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -106,7 +106,7 @@ void vma_set_page_prot(struct vm_area_struct *vma)
 static void __remove_shared_vm_struct(struct vm_area_struct *vma,
 		struct file *file, struct address_space *mapping)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_is_shared_maywrite(vma))
 		mapping_unmap_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
@@ -408,7 +408,7 @@ static unsigned long count_vma_pages_range(struct mm_struct *mm,
 static void __vma_link_file(struct vm_area_struct *vma,
 			    struct address_space *mapping)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_is_shared_maywrite(vma))
 		mapping_allow_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
@@ -2827,7 +2827,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 	vma_mas_store(vma, &mas);
 	mm->map_count++;
 	if (vma->vm_file) {
-		if (vma->vm_flags & VM_SHARED)
+		if (vma_is_shared_maywrite(vma))
 			mapping_allow_writable(vma->vm_file->f_mapping);
 
 		flush_dcache_mmap_lock(vma->vm_file->f_mapping);
@@ -2901,7 +2901,7 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 		return -EINVAL;
 
 	/* Map writable and ensure this isn't a sealed memfd. */
-	if (file && (vm_flags & VM_SHARED)) {
+	if (file && is_shared_maywrite(vm_flags)) {
 		int error = mapping_map_writable(file->f_mapping);
 
 		if (error)
-- 
2.50.1.552.g942d659e1b-goog


