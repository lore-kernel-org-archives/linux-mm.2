Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4A851091913
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 18:24:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B8096B0571; Thu, 19 Mar 2026 14:24:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F30D6B0573; Thu, 19 Mar 2026 14:24:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 293316B0574; Thu, 19 Mar 2026 14:24:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12DB26B0571
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 14:24:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A80958C20C
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:22 +0000 (UTC)
X-FDA: 84563637564.25.DBEDBCA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 20D5C80011
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 18:24:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mZgkP81+;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773944661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mb1H094Eggo+sZAEeZbt0Via3qvG4mfa9Fpg2YeRetw=;
	b=nw70gpCxlmuHe/0Ja4KKmTDJL/fZIAVckD9Lj/rIXdbH9QxJRMpO2wbyv5QTeVIX9tZZmb
	DgMbMB4nyfKmtpkRa00/yhqzERip8fWr3b9KjDGm2RdMeL8IbWt7ZyXDpuAMM4rJcm7Cql
	lQCAowhBGSYeHl/szciyRCH2oFbidgM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773944661; a=rsa-sha256;
	cv=none;
	b=V0JoBRjHlXqDtVkehhvAAjtkmL0AHHNHIGH3Ty5fSFdJ3V3ysRjXlio+pV+560Kyh4+snE
	W6sq0NL/VXeCdFU4XUxJ/NJlstIRJS1mmYnDlZ1pNm6hEajBR5iOobouwbdU5PzozugFcV
	+8s4C+wMixIsIM9UQWSeIXhe9z64gvA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mZgkP81+;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7916660097;
	Thu, 19 Mar 2026 18:24:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8234FC2BCB1;
	Thu, 19 Mar 2026 18:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773944660;
	bh=xhLlmwR4AUj9PhlewTo4sEx2FcR6iF+ofwi5SoZX8Hk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mZgkP81+To5o4+opP9DVY1B5L2QIqkffzZEmmi0qbgQF8ZVYK6KsNBItOdUPSj8Nw
	 bMAJAsZplTZg309A7z2OhoR8cJq1hs3Voltr+9XPsXqcr6B8T7QpMIUib8B1mw5zpn
	 zoJGI26UscPsQWtn1lV1WfrFgdQq/o2bKzW0dF1zLlzxZsvheOTfctL2OpkWYsLPm6
	 nf4EakEPzGXz2D3JzZ3dRo797Ig/ffZ8ia8X/aRBpZVx1/2wLN18YVJKawCcJFWUqK
	 28ck4MYHjmCzOUK3wFG9x513U6FnnHUq3xwOTyMHg9ARTMeUrZvVAYbymNlAVqMYPt
	 dO8wscgfJc1bg==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Clemens Ladisch <clemens@ladisch.de>,
	Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Maxime Coquelin <mcoquelin.stm32@gmail.com>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Richard Weinberger <richard@nod.at>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Bodo Stroesser <bostroesser@gmail.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-stm32@st-md-mailman.stormreply.com,
	linux-arm-kernel@lists.infradead.org,
	linux-mtd@lists.infradead.org,
	linux-staging@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-afs@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ryan Roberts <ryan.roberts@arm.com>
Subject: [PATCH v3 12/16] mm: allow handling of stacked mmap_prepare hooks in more drivers
Date: Thu, 19 Mar 2026 18:23:36 +0000
Message-ID: <05b4d97d6248777a827f17445760b460cd293cb4.1773944114.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1773944114.git.ljs@kernel.org>
References: <cover.1773944114.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ecwzyo3dtx61ep4ejnihecozkgj4pj7p
X-Rspamd-Queue-Id: 20D5C80011
X-Rspamd-Server: rspam03
X-HE-Tag: 1773944660-272422
X-HE-Meta: U2FsdGVkX18hDaFvyXRfVxGUj2KV4fn9iD+t+fOqxAQOE9KMvFgfAITuEZKvQh/Zk9fPepcnUJ/CT2lgbrjYV26tWfxVQjJuRdPld+imMaakyoE2Qwlp/dJo8LmK0xG5mLIdbsW1BLbZjNH76F5lz61UdUUK50tASqSsBTiCIJ0ZtYK9scz7zhLOts/Mmy3pQMFcY2eXpH6kH98vJ0s3OiIj27feOEgOOpOFje4uZ35Q99AeTtmK27J5KNvDXCfxAzTigXl7C8KqdBQmK5iq65NlAFGwMVRwzC7q4Krrl/ecxzaII6NcKkZsh96sRWgeN/km97AB4f0xIqpLuUFk2rY541CA6V4U7o8oPkbD8NK73K4WSZ/PAohNfysRNSpbGGllznpPKXaiG4+p26EKpl9XwdkLwHjU7Pf2NOIV3pxacwVV1YmuIaqUaHLClKywEaQMUgJTzFePshzztWhYo5CwYM+yWN22wWazIBU/MvmfR04UE6QOKeTpJRgg5eIcL8xuAPxaw9agxEJ0cBaprInA5BJn8mPMLgZWntt3cO6SEagy7rnoi4cm6NHIAd5mnVGMZpfHvDGkpV19HRu902h9uvqUSgebw2Uin8a2NNfTti9u+iszOUCEAj07NO7DAOT8EbhMwvn4wmoLW/alGthrUNgHUMwrhr0KNHZsFXWnNPYVKUFSps95sIdwRdFuILQwk0Lsww4eaj5/HUd40OoiimE7bSOiNbRFpsC5aoQE1kGq38csxxIpqsRqWiSYmzTMLzrdboWI8bRKiObDbNLZ2wLmHA4wLDPvic/JnEyzM9erUwpIejuzSpAHWo5gqRLez0WxyJbufzfOX0DcpdeZmvO3mCoeHA0MGhpNTP14ZD5j0sQ0DceYT088DsOmQGPlZm5NGfasgxK33m2LN2fcgu4ZGxMquH4IP5fXXcadXRFiJHyLmURduC7Onz1jWsh/CXMsF/SW0Lk0tVM
 2Bfrqjqz
 TGlxuUkveZHrfgSzJeA2pg4fQUnzpRVryoM/97JKHANX/r5yx/xXi/STbwHIirkgGxxJyASjk6J44Xiy6sMyqr6Qt35lDq0bjCLyE+tuHE/Pgh+cH2YT++VYRcm9PbTO+N3zJWh8QISYd0hDYnEtawnF6gegG4d80gGgxX/SvAaKsAMEk62ckXHKjJUWP5ZVckQ7A4IJvcYBB6TarPOiB6yLPWMoICGwBmbxmUmjAukDdSbeuyarkIx2ETvz5Fjq8Cih69bhDTP8W0y/pb0VB6seoUW/3A5kx8PNDtOcx7GyweQILUSZpXfBbHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While the conversion of mmap hooks to mmap_prepare is underway, we will
encounter situations where mmap hooks need to invoke nested mmap_prepare
hooks.

The nesting of mmap hooks is termed 'stacking'.  In order to flexibly
facilitate the conversion of custom mmap hooks in drivers which stack, we
must split up the existing __compat_vma_mmap() function into two separate
functions:

* compat_set_desc_from_vma() - This allows the setting of a vm_area_desc
  object's fields to the relevant fields of a VMA.

* __compat_vma_mmap() - Once an mmap_prepare hook has been executed upon a
  vm_area_desc object, this function performs any mmap actions specified by
  the mmap_prepare hook and then invokes its vm_ops->mapped() hook if any
  were specified.

In ordinary cases, where a file's f_op->mmap_prepare() hook simply needs
to be invoked in a stacked mmap() hook, compat_vma_mmap() can be used.

However some drivers define their own nested hooks, which are invoked in
turn by another hook.

A concrete example is vmbus_channel->mmap_ring_buffer(), which is invoked
in turn by bin_attribute->mmap():

vmbus_channel->mmap_ring_buffer() has a signature of:

int (*mmap_ring_buffer)(struct vmbus_channel *channel,
			struct vm_area_struct *vma);

And bin_attribute->mmap() has a signature of:

	int (*mmap)(struct file *, struct kobject *,
		    const struct bin_attribute *attr,
		    struct vm_area_struct *vma);

And so compat_vma_mmap() cannot be used here for incremental conversion of
hooks from mmap() to mmap_prepare().

There are many such instances like this, where conversion to mmap_prepare
would otherwise cascade to a huge change set due to nesting of this kind.

The changes in this patch mean we could now instead convert
vmbus_channel->mmap_ring_buffer() to
vmbus_channel->mmap_prepare_ring_buffer(), and implement something like:

	struct vm_area_desc desc;
	int err;

	compat_set_desc_from_vma(&desc, file, vma);
	err = channel->mmap_prepare_ring_buffer(channel, &desc);
	if (err)
		return err;

	return __compat_vma_mmap(&desc, vma);

Allowing us to incrementally update this logic, and other logic like it.

Unfortunately, as part of this change, we need to be able to flexibly
assign to the VMA descriptor, so have to remove some of the const
declarations within the structure.

Also update the VMA tests to reflect the changes.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/fs.h              |   3 +
 include/linux/mm_types.h        |   4 +-
 mm/util.c                       | 112 ++++++++++++++++++++++---------
 mm/vma.h                        |   2 +-
 tools/testing/vma/include/dup.h | 114 +++++++++++++++++++++-----------
 5 files changed, 162 insertions(+), 73 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index c390f5c667e3..0bdccfa70b44 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2058,6 +2058,9 @@ static inline bool can_mmap_file(struct file *file)
 	return true;
 }
 
+void compat_set_desc_from_vma(struct vm_area_desc *desc, const struct file *file,
+			      const struct vm_area_struct *vma);
+int __compat_vma_mmap(struct vm_area_desc *desc, struct vm_area_struct *vma);
 int compat_vma_mmap(struct file *file, struct vm_area_struct *vma);
 int __vma_check_mmap_hook(struct vm_area_struct *vma);
 
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 50685cf29792..7538d64f8848 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -891,8 +891,8 @@ static __always_inline bool vma_flags_empty(vma_flags_t *flags)
  */
 struct vm_area_desc {
 	/* Immutable state. */
-	const struct mm_struct *const mm;
-	struct file *const file; /* May vary from vm_file in stacked callers. */
+	struct mm_struct *mm;
+	struct file *file; /* May vary from vm_file in stacked callers. */
 	unsigned long start;
 	unsigned long end;
 
diff --git a/mm/util.c b/mm/util.c
index 879ba62b5f0c..8cf59267a9ac 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -1163,34 +1163,40 @@ void flush_dcache_folio(struct folio *folio)
 EXPORT_SYMBOL(flush_dcache_folio);
 #endif
 
-static int __compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
+/**
+ * compat_set_desc_from_vma() - assigns VMA descriptor @desc fields from a VMA.
+ * @desc: A VMA descriptor whose fields need to be set.
+ * @file: The file object describing the file being mmap()'d.
+ * @vma: The VMA whose fields we wish to assign to @desc.
+ *
+ * This is a compatibility function to allow an mmap() hook to call
+ * mmap_prepare() hooks when drivers nest these. This function specifically
+ * allows the construction of a vm_area_desc value, @desc, from a VMA @vma for
+ * the purposes of doing this.
+ *
+ * Once the conversion of drivers is complete this function will no longer be
+ * required and will be removed.
+ */
+void compat_set_desc_from_vma(struct vm_area_desc *desc,
+			      const struct file *file,
+			      const struct vm_area_struct *vma)
 {
-	struct vm_area_desc desc = {
-		.mm = vma->vm_mm,
-		.file = file,
-		.start = vma->vm_start,
-		.end = vma->vm_end,
+	memset(desc, 0, sizeof(*desc));
 
-		.pgoff = vma->vm_pgoff,
-		.vm_file = vma->vm_file,
-		.vma_flags = vma->flags,
-		.page_prot = vma->vm_page_prot,
-
-		.action.type = MMAP_NOTHING, /* Default */
-	};
-	int err;
+	desc->mm = vma->vm_mm;
+	desc->file = (struct file *)file;
+	desc->start = vma->vm_start;
+	desc->end = vma->vm_end;
 
-	err = vfs_mmap_prepare(file, &desc);
-	if (err)
-		return err;
+	desc->pgoff = vma->vm_pgoff;
+	desc->vm_file = vma->vm_file;
+	desc->vma_flags = vma->flags;
+	desc->page_prot = vma->vm_page_prot;
 
-	err = mmap_action_prepare(&desc);
-	if (err)
-		return err;
-
-	set_vma_from_desc(vma, &desc);
-	return mmap_action_complete(vma, &desc.action, /*rmap_lock_held=*/false);
+	/* Default. */
+	desc->action.type = MMAP_NOTHING;
 }
+EXPORT_SYMBOL(compat_set_desc_from_vma);
 
 static int __compat_vma_mapped(struct file *file, struct vm_area_struct *vma)
 {
@@ -1211,6 +1217,50 @@ static int __compat_vma_mapped(struct file *file, struct vm_area_struct *vma)
 	return err;
 }
 
+/**
+ * __compat_vma_mmap() - Similar to compat_vma_mmap(), only it allows
+ * flexibility as to how the mmap_prepare callback is invoked, which is useful
+ * for drivers which invoke nested mmap_prepare callbacks in an mmap() hook.
+ * @desc: A VMA descriptor upon which an mmap_prepare() hook has already been
+ * executed.
+ * @vma: The VMA to which @desc should be applied.
+ *
+ * The function assumes that you have obtained a VMA descriptor @desc from
+ * compat_set_desc_from_vma(), and already executed the mmap_prepare() hook upon
+ * it.
+ *
+ * It then performs any specified mmap actions, and invokes the vm_ops->mapped()
+ * hook if one is present.
+ *
+ * See the description of compat_vma_mmap() for more details.
+ *
+ * Once the conversion of drivers is complete this function will no longer be
+ * required and will be removed.
+ *
+ * Returns: 0 on success or error.
+ */
+int __compat_vma_mmap(struct vm_area_desc *desc,
+		      struct vm_area_struct *vma)
+{
+	int err;
+
+	/* Perform any preparatory tasks for mmap action. */
+	err = mmap_action_prepare(desc);
+	if (err)
+		return err;
+	/* Update the VMA from the descriptor. */
+	compat_set_vma_from_desc(vma, desc);
+	/* Complete any specified mmap actions. */
+	err = mmap_action_complete(vma, &desc->action,
+				   /*rmap_lock_held=*/false);
+	if (err)
+		return err;
+
+	/* Invoke vm_ops->mapped callback. */
+	return __compat_vma_mapped(desc->file, vma);
+}
+EXPORT_SYMBOL(__compat_vma_mmap);
+
 /**
  * compat_vma_mmap() - Apply the file's .mmap_prepare() hook to an
  * existing VMA and execute any requested actions.
@@ -1218,10 +1268,10 @@ static int __compat_vma_mapped(struct file *file, struct vm_area_struct *vma)
  * @vma: The VMA to apply the .mmap_prepare() hook to.
  *
  * Ordinarily, .mmap_prepare() is invoked directly upon mmap(). However, certain
- * stacked filesystems invoke a nested mmap hook of an underlying file.
+ * stacked drivers invoke a nested mmap hook of an underlying file.
  *
- * Until all filesystems are converted to use .mmap_prepare(), we must be
- * conservative and continue to invoke these stacked filesystems using the
+ * Until all drivers are converted to use .mmap_prepare(), we must be
+ * conservative and continue to invoke these stacked drivers using the
  * deprecated .mmap() hook.
  *
  * However we have a problem if the underlying file system possesses an
@@ -1232,20 +1282,22 @@ static int __compat_vma_mapped(struct file *file, struct vm_area_struct *vma)
  * establishes a struct vm_area_desc descriptor, passes to the underlying
  * .mmap_prepare() hook and applies any changes performed by it.
  *
- * Once the conversion of filesystems is complete this function will no longer
- * be required and will be removed.
+ * Once the conversion of drivers is complete this function will no longer be
+ * required and will be removed.
  *
  * Returns: 0 on success or error.
  */
 int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	struct vm_area_desc desc;
 	int err;
 
-	err = __compat_vma_mmap(file, vma);
+	compat_set_desc_from_vma(&desc, file, vma);
+	err = vfs_mmap_prepare(file, &desc);
 	if (err)
 		return err;
 
-	return __compat_vma_mapped(file, vma);
+	return __compat_vma_mmap(&desc, vma);
 }
 EXPORT_SYMBOL(compat_vma_mmap);
 
diff --git a/mm/vma.h b/mm/vma.h
index adc18f7dd9f1..a76046c39b14 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -300,7 +300,7 @@ static inline int vma_iter_store_gfp(struct vma_iterator *vmi,
  * f_op->mmap() but which might have an underlying file system which implements
  * f_op->mmap_prepare().
  */
-static inline void set_vma_from_desc(struct vm_area_struct *vma,
+static inline void compat_set_vma_from_desc(struct vm_area_struct *vma,
 		struct vm_area_desc *desc)
 {
 	/*
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 1b86c34e1158..1f123704078e 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -519,8 +519,8 @@ enum vma_operation {
  */
 struct vm_area_desc {
 	/* Immutable state. */
-	const struct mm_struct *const mm;
-	struct file *const file; /* May vary from vm_file in stacked callers. */
+	struct mm_struct *mm;
+	struct file *file; /* May vary from vm_file in stacked callers. */
 	unsigned long start;
 	unsigned long end;
 
@@ -1272,43 +1272,95 @@ static inline void vma_set_anonymous(struct vm_area_struct *vma)
 }
 
 /* Declared in vma.h. */
-static inline void set_vma_from_desc(struct vm_area_struct *vma,
+static inline void compat_set_vma_from_desc(struct vm_area_struct *vma,
 		struct vm_area_desc *desc);
 
-static inline int __compat_vma_mmap(const struct file_operations *f_op,
-		struct file *file, struct vm_area_struct *vma)
+static inline void compat_set_desc_from_vma(struct vm_area_desc *desc,
+			      const struct file *file,
+			      const struct vm_area_struct *vma)
 {
-	struct vm_area_desc desc = {
-		.mm = vma->vm_mm,
-		.file = file,
-		.start = vma->vm_start,
-		.end = vma->vm_end,
+	memset(desc, 0, sizeof(*desc));
 
-		.pgoff = vma->vm_pgoff,
-		.vm_file = vma->vm_file,
-		.vma_flags = vma->flags,
-		.page_prot = vma->vm_page_prot,
+	desc->mm = vma->vm_mm;
+	desc->file = (struct file *)file;
+	desc->start = vma->vm_start;
+	desc->end = vma->vm_end;
 
-		.action.type = MMAP_NOTHING, /* Default */
-	};
+	desc->pgoff = vma->vm_pgoff;
+	desc->vm_file = vma->vm_file;
+	desc->vma_flags = vma->flags;
+	desc->page_prot = vma->vm_page_prot;
+
+	/* Default. */
+	desc->action.type = MMAP_NOTHING;
+}
+
+static inline unsigned long vma_pages(const struct vm_area_struct *vma)
+{
+	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
+}
+
+static inline void unmap_vma_locked(struct vm_area_struct *vma)
+{
+	const size_t len = vma_pages(vma) << PAGE_SHIFT;
+
+	mmap_assert_write_locked(vma->vm_mm);
+	do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
+}
+
+static inline int __compat_vma_mapped(struct file *file, struct vm_area_struct *vma)
+{
+	const struct vm_operations_struct *vm_ops = vma->vm_ops;
 	int err;
 
-	err = f_op->mmap_prepare(&desc);
+	if (!vm_ops->mapped)
+		return 0;
+
+	err = vm_ops->mapped(vma->vm_start, vma->vm_end, vma->vm_pgoff, file,
+			     &vma->vm_private_data);
 	if (err)
-		return err;
+		unmap_vma_locked(vma);
+	return err;
+}
 
-	err = mmap_action_prepare(&desc);
+static inline int __compat_vma_mmap(struct vm_area_desc *desc,
+		struct vm_area_struct *vma)
+{
+	int err;
+
+	/* Perform any preparatory tasks for mmap action. */
+	err = mmap_action_prepare(desc);
+	if (err)
+		return err;
+	/* Update the VMA from the descriptor. */
+	compat_set_vma_from_desc(vma, desc);
+	/* Complete any specified mmap actions. */
+	err = mmap_action_complete(vma, &desc->action,
+				   /*rmap_lock_held=*/false);
 	if (err)
 		return err;
 
-	set_vma_from_desc(vma, &desc);
-	return mmap_action_complete(vma, &desc.action, /*rmap_lock_held=*/false);
+	/* Invoke vm_ops->mapped callback. */
+	return __compat_vma_mapped(desc->file, vma);
+}
+
+static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
+{
+	return file->f_op->mmap_prepare(desc);
 }
 
 static inline int compat_vma_mmap(struct file *file,
 		struct vm_area_struct *vma)
 {
-	return __compat_vma_mmap(file->f_op, file, vma);
+	struct vm_area_desc desc;
+	int err;
+
+	compat_set_desc_from_vma(&desc, file, vma);
+	err = vfs_mmap_prepare(file, &desc);
+	if (err)
+		return err;
+
+	return __compat_vma_mmap(&desc, vma);
 }
 
 
@@ -1318,11 +1370,6 @@ static inline void vma_iter_init(struct vma_iterator *vmi,
 	mas_init(&vmi->mas, &mm->mm_mt, addr);
 }
 
-static inline unsigned long vma_pages(struct vm_area_struct *vma)
-{
-	return (vma->vm_end - vma->vm_start) >> PAGE_SHIFT;
-}
-
 static inline void mmap_assert_locked(struct mm_struct *);
 static inline struct vm_area_struct *find_vma_intersection(struct mm_struct *mm,
 						unsigned long start_addr,
@@ -1492,11 +1539,6 @@ static inline int vfs_mmap(struct file *file, struct vm_area_struct *vma)
 	return file->f_op->mmap(file, vma);
 }
 
-static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
-{
-	return file->f_op->mmap_prepare(desc);
-}
-
 static inline void vma_set_file(struct vm_area_struct *vma, struct file *file)
 {
 	/* Changing an anonymous vma with this is illegal */
@@ -1521,11 +1563,3 @@ static inline pgprot_t vma_get_page_prot(vma_flags_t vma_flags)
 
 	return vm_get_page_prot(vm_flags);
 }
-
-static inline void unmap_vma_locked(struct vm_area_struct *vma)
-{
-	const size_t len = vma_pages(vma) << PAGE_SHIFT;
-
-	mmap_assert_write_locked(vma->vm_mm);
-	do_munmap(vma->vm_mm, vma->vm_start, len, NULL);
-}
-- 
2.53.0


