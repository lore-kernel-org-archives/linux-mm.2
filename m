Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A7EFCDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A44A16B00AC; Thu, 25 Jun 2026 07:31:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CDF76B0113; Thu, 25 Jun 2026 07:31:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C38F6B00AC; Thu, 25 Jun 2026 07:31:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59A3F6B00AC
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:31:24 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D3ED0140696
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:31:23 +0000 (UTC)
X-FDA: 84918219246.08.8ABF0C0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1D88A120003
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:31:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=LfjFVxci;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782387082;
	b=BLb6mVqJkHmbbV9MQDX7aqFb3I44fLGbTCF3ixkWlTz5jEyIaag5Jqiif1W44E/i2Eozu4
	6rX8vwTdH8ttSXX+W7uWdc/SDHBX9KkrkE8iJQ4ZpLPP7yA4ZhzvWCvENJcprvmq5HgDWc
	DIrWBWuuKd0rTA7e+3pYBZ0lVlqpKHk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782387082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=M0n0xslBZOnXvCBoRLf7KpafHYtczL8HIrC0UAfZNEQ=;
	b=w4fJHTAv3FmqKh/OFRzJXF9BPhg+I80ZoDtrPwR4KrEUiAFWiPl//CtdjaDBq2UwMlFmKr
	AECP/iTJkdvWexLRBVpMwggOFkLblDlBo3odHMAAEIlSL8zSTlajV5NZeqHciAyxmBzyIB
	HjNA2ioKhstz44aI9Y6hwVAQOHOwHSw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=LfjFVxci;
	dmarc=pass (policy=none) header.from=linuxfoundation.org;
	spf=pass (imf29.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DEB641AD9;
	Thu, 25 Jun 2026 11:31:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4A61F000E9;
	Thu, 25 Jun 2026 11:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782387081;
	bh=M0n0xslBZOnXvCBoRLf7KpafHYtczL8HIrC0UAfZNEQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To;
	b=LfjFVxcixG5JIMofiCum1jmEgFFeGhEGI3P9UWUEV6RewCmqkZKP2V1Ua38Q2lsuA
	 m6sNaMXseHGACPz2b4CTVYJmm1Iidsb4FFOsB1zkwoBwG5CWiNEcj0LGlp9WywAZxE
	 avaj4VxXvP5GCRhgX2ijxFaAoi8Ofa1otSCSrByI=
Subject: Patch "mm: update vma_modify_flags() to handle residual flags, document" has been added to the 6.18-stable tree
To: akpm@linux-foundation.org,avagin@gmail.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,corbet@lwn.net,david@kernel.org,dev.jain@arm.com,elaidya225@gmail.com,gregkh@linuxfoundation.org,jannh@google.com,lance.yang@linux.dev,liam.howlett@oracle.com,linux-mm@kvack.org,ljs@kernel.org,lorenzo.stoakes@oracle.com,mathieu.desnoyers@efficios.com,mhiramat@kernel.org,mhocko@suse.com,npache@redhat.com,pfalcato@suse.de,rostedt@goodmis.org,rppt@kernel.org,ryan.roberts@arm.com,surenb@google.com,vbabka@suse.cz,ziy@nvidia.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 25 Jun 2026 12:29:48 +0100
In-Reply-To: <20260515124218.151966-5-elaidya225@gmail.com>
Message-ID: <2026062548-obvious-party-ab39@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1D88A120003
X-Rspam-User: 
X-Stat-Signature: w6qdhtrpzo4jbnstt81jpzpchse5h181
X-HE-Tag: 1782387081-782056
X-HE-Meta: U2FsdGVkX19EOB80gXQeQczfuW7YzQJ4ZZYsos/zKSwS+p1rde8wUOf+eS81uxH/4ByoBs+d/8L0VrvxveIlp8yYuzkJOEIhNwo6NXd/q+j7Ftk3YSuUMjGthQ7x6X4l+a2VpFz6zeMWdtWLwjLx3xBalYDnkBYdj4wCeACGrdQDOHv/+v5MgtafWy25ZJ8QWGmb6o1DoaKLS3iGOVIqYq9AXUyYI8j8CXQ9osOD1uvgauGK85No8N3rJJXJ/Qbkj4UDcI1UuWAHAuTQc5MuIkyrsm48ZafpaL3gbDgAzJ+1jMwF4s9Q6/xXiWRdawzofnbysF3N/Bq7jDNiXedD+RtuWAVFVE//znVmw+amDMZIdQNNaNhZN/xhCl/f2LYULrPw1hKCK6takMdILt5olUT3blOBQ0Bf3sQFfTCCMXTaWDb+XGB1JhMJLze43N445ml4aoCdsK1h66BY17SN7pAtOsTHBfiWR4fPZ0DEAkuns6NOqtmyhqT1edAooboLcNSoRoemh/fEnEP92CSPXD7NFt3O1qvSlAtMgGoJvMS30OXzY9Y7Bzy7wCdMCpxDMYjAqIKIYHH0d4Xe+bkU1gI5S11S8IpcA3gxCR0z2vNgmtKaQ9Yc3h0hvJmkapVBBa7goW0PvGqYUXRlWkZlOlKI6A3hLEsl7gQm8RaRv+L5le/GKb/TwqjjkSOHnP1lsIM5WFOVCbZkcDJ9orx0WJq8oPVGvqtWXaf14oUwCED6pJC6z+x0H0m4vXUcAwtdlcMJcZyGgI00zvYscB/GWTSn0Jr+kTPwGcAj3hJARY1Ed3XslpxZOLaqBGvI5hTcjg+++oOd6USeYv8s1cqtAlC82UQapQBs9tJ+LQr9JogNDzh2CEf7xMSk2zYWtsOPgs6cXBt/ozl2I+rMIk5inRyXrQV5Uu2US1jFSQgcs0c+IdoM8vJbccS5XNm3T/TWQbU+MkNx8kVvTe/hIaO
 CVCepKHA
 w4XsWZq/mpvAF5GSMDryQT3tIBVpHHFCBrxmOiyFCkkKsFQPtSWwAICb/hTgAmZgO3H0C99iv6uAWPfut0sVHsizIOpqmyXIWhdzFxngqOGxgaXKsvb/W21ZnHyu57UPasthhyxZhdHpVDseogM3GHOU2CvYLeG6X6MT+duLAHc6jy/l7iE6zzmD1YauxudMs2ILPcegSK775jI+RYDck+LxyC3wGP0dB1wphukA/gYJRps3aZpIsjphUKjWps5zJ9kCyjxZA85QxxD8VtrGL2N0aI+TVeNL4yHGxapW+3RzyAamnxJGcl+qB1HcR07htbwe/7TWXL88J1KFRjJ8ZDL79TuyZC8nexOnnSFCxQXBLtI1bDgGbj0JRzzVoYSJIkXOAV6acBB7FSGQmRIpuDataGj2mAiTiWoNOB19i81Zb+TLtOR+2kzUJpvUwdd26HR3fHsHQxcqeHqeqMo6OFxdHlPeiRaI/z6Zv/dF62QySJ7+X+XpTRpGuKD88NBKS9Zu4NC6+/CsXfT1NLKTUayLcWkUZrT+AKcEybCPUNp01+sfr3eAbK71rq8eoEYjgvSmOZjJA/apww2APQ3W4rBABi1hkAZyOz4w6fRalVQG+xJtgZEo1q7b7csawSANm1CLBTBgLyhxgczEWjUWgQbkqO3iHcERmNzb7OwSEn2YzETBNY6F81lKwCU8iT/V+bTsdb6kD02d2A3c5bCRHTe7YEA7G5UHTY59MFksSon4a8xV54Rdx3B0W7kDpvQYZZrV8DPShedfhHmkFzX+q5P8ZowR/p+zFE9aYHH5+mqLgnk4lPmLEJs66v5M4pYzoDXYaHt9ypQpDc0vg9BymaD9uo/bZG2gqZtJcil0PRnjyzMKMIPjNsPXvLSLu/r9fbFbDjI+1QW9VKRlHfV2+mM9UpuPeJvJHsFiF56UxWC4nuj0YcgJjo2lL4OA8sMrQzICETByX1559akFQ6h8SBa/iCOmP
 r3e2zWF4
 7myKzjg/9zTvo44r21QEzhgFudkxr374c4RF+S91ny7mVhsT4yFS3Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: update vma_modify_flags() to handle residual flags, document

to the 6.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-update-vma_modify_flags-to-handle-residual-flags-document.patch
and it can be found in the queue-6.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-247750-greg=kroah.com@vger.kernel.org Fri May 15 14:05:39 2026
From: Ahmed Elaidy <elaidya225@gmail.com>
Date: Fri, 15 May 2026 15:42:13 +0300
Subject: mm: update vma_modify_flags() to handle residual flags, document
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, ljs@kernel.org, avagin@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Pedro Falcato <pfalcato@suse.de>, Vlastimil Babka <vbabka@suse.cz>, Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, "David Hildenbrand (Red Hat)" <david@kernel.org>, Dev Jain <dev.jain@arm.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Lance Yang <lance.yang@linux.dev>, Liam Howlett <liam.howlett@oracle.com>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>, Zi Yan <ziy@nvidia.com>, Ahmed Elaidy <elaidya225@gmail.com>
Message-ID: <20260515124218.151966-5-elaidya225@gmail.com>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

commit 9119d6c2095bb20292cb9812dd70d37f17e3bd37 upstream.

The vma_modify_*() family of functions each either perform splits, a merge
or no changes at all in preparation for the requested modification to
occur.

When doing so for a VMA flags change, we currently don't account for any
flags which may remain (for instance, VM_SOFTDIRTY) despite the requested
change in the case that a merge succeeded.

This is made more important by subsequent patches which will introduce the
concept of sticky VMA flags which rely on this behaviour.

This patch fixes this by passing the VMA flags parameter as a pointer and
updating it accordingly on merge and updating callers to accommodate for
this.

Additionally, while we are here, we add kdocs for each of the
vma_modify_*() functions, as the fact that the requested modification is
not performed is confusing so it is useful to make this abundantly clear.

We also update the VMA userland tests to account for this change.

Link: https://lkml.kernel.org/r/23b5b549b0eaefb2922625626e58c2a352f3e93c.1763460113.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand (Red Hat) <david@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Ahmed Elaidy <elaidya225@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/madvise.c            |    2 
 mm/mlock.c              |    2 
 mm/mprotect.c           |    2 
 mm/mseal.c              |    7 +-
 mm/vma.c                |   56 ++++++++++---------
 mm/vma.h                |  138 +++++++++++++++++++++++++++++++++++-------------
 tools/testing/vma/vma.c |    3 -
 7 files changed, 142 insertions(+), 68 deletions(-)

--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -167,7 +167,7 @@ static int madvise_update_vma(vm_flags_t
 			range->start, range->end, anon_name);
 	else
 		vma = vma_modify_flags(&vmi, madv_behavior->prev, vma,
-			range->start, range->end, new_flags);
+			range->start, range->end, &new_flags);
 
 	if (IS_ERR(vma))
 		return PTR_ERR(vma);
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -480,7 +480,7 @@ static int mlock_fixup(struct vma_iterat
 		 */
 		goto out;
 
-	vma = vma_modify_flags(vmi, *prev, vma, start, end, newflags);
+	vma = vma_modify_flags(vmi, *prev, vma, start, end, &newflags);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
 		goto out;
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -813,7 +813,7 @@ mprotect_fixup(struct vma_iterator *vmi,
 		newflags &= ~VM_ACCOUNT;
 	}
 
-	vma = vma_modify_flags(vmi, *pprev, vma, start, end, newflags);
+	vma = vma_modify_flags(vmi, *pprev, vma, start, end, &newflags);
 	if (IS_ERR(vma)) {
 		error = PTR_ERR(vma);
 		goto fail;
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -69,9 +69,10 @@ static int mseal_apply(struct mm_struct
 		const unsigned long curr_end = MIN(vma->vm_end, end);
 
 		if (!(vma->vm_flags & VM_SEALED)) {
-			vma = vma_modify_flags(&vmi, prev, vma,
-					curr_start, curr_end,
-					vma->vm_flags | VM_SEALED);
+			vm_flags_t vm_flags = vma->vm_flags | VM_SEALED;
+
+			vma = vma_modify_flags(&vmi, prev, vma, curr_start,
+					       curr_end, &vm_flags);
 			if (IS_ERR(vma))
 				return PTR_ERR(vma);
 			vm_flags_set(vma, VM_SEALED);
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -1676,25 +1676,35 @@ static struct vm_area_struct *vma_modify
 	return vma;
 }
 
-struct vm_area_struct *vma_modify_flags(
-	struct vma_iterator *vmi, struct vm_area_struct *prev,
-	struct vm_area_struct *vma, unsigned long start, unsigned long end,
-	vm_flags_t vm_flags)
+struct vm_area_struct *vma_modify_flags(struct vma_iterator *vmi,
+		struct vm_area_struct *prev, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end,
+		vm_flags_t *vm_flags_ptr)
 {
 	VMG_VMA_STATE(vmg, vmi, prev, vma, start, end);
+	const vm_flags_t vm_flags = *vm_flags_ptr;
+	struct vm_area_struct *ret;
 
 	vmg.vm_flags = vm_flags;
 
-	return vma_modify(&vmg);
+	ret = vma_modify(&vmg);
+	if (IS_ERR(ret))
+		return ret;
+
+	/*
+	 * For a merge to succeed, the flags must match those requested. For
+	 * flags which do not obey typical merge rules (i.e. do not need to
+	 * match), we must let the caller know about them.
+	 */
+	if (vmg.state == VMA_MERGE_SUCCESS)
+		*vm_flags_ptr = ret->vm_flags;
+	return ret;
 }
 
-struct vm_area_struct
-*vma_modify_name(struct vma_iterator *vmi,
-		       struct vm_area_struct *prev,
-		       struct vm_area_struct *vma,
-		       unsigned long start,
-		       unsigned long end,
-		       struct anon_vma_name *new_name)
+struct vm_area_struct *vma_modify_name(struct vma_iterator *vmi,
+		struct vm_area_struct *prev, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end,
+		struct anon_vma_name *new_name)
 {
 	VMG_VMA_STATE(vmg, vmi, prev, vma, start, end);
 
@@ -1703,12 +1713,10 @@ struct vm_area_struct
 	return vma_modify(&vmg);
 }
 
-struct vm_area_struct
-*vma_modify_policy(struct vma_iterator *vmi,
-		   struct vm_area_struct *prev,
-		   struct vm_area_struct *vma,
-		   unsigned long start, unsigned long end,
-		   struct mempolicy *new_pol)
+struct vm_area_struct *vma_modify_policy(struct vma_iterator *vmi,
+		struct vm_area_struct *prev, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end,
+		struct mempolicy *new_pol)
 {
 	VMG_VMA_STATE(vmg, vmi, prev, vma, start, end);
 
@@ -1717,14 +1725,10 @@ struct vm_area_struct
 	return vma_modify(&vmg);
 }
 
-struct vm_area_struct
-*vma_modify_flags_uffd(struct vma_iterator *vmi,
-		       struct vm_area_struct *prev,
-		       struct vm_area_struct *vma,
-		       unsigned long start, unsigned long end,
-		       vm_flags_t vm_flags,
-		       struct vm_userfaultfd_ctx new_ctx,
-		       bool give_up_on_oom)
+struct vm_area_struct *vma_modify_flags_uffd(struct vma_iterator *vmi,
+		struct vm_area_struct *prev, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end, vm_flags_t vm_flags,
+		struct vm_userfaultfd_ctx new_ctx, bool give_up_on_oom)
 {
 	VMG_VMA_STATE(vmg, vmi, prev, vma, start, end);
 
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -266,47 +266,115 @@ void remove_vma(struct vm_area_struct *v
 void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 		struct vm_area_struct *prev, struct vm_area_struct *next);
 
-/* We are about to modify the VMA's flags. */
-__must_check struct vm_area_struct
-*vma_modify_flags(struct vma_iterator *vmi,
+/**
+ * vma_modify_flags() - Peform any necessary split/merge in preparation for
+ * setting VMA flags to *@vm_flags in the range @start to @end contained within
+ * @vma.
+ * @vmi: Valid VMA iterator positioned at @vma.
+ * @prev: The VMA immediately prior to @vma or NULL if @vma is the first.
+ * @vma: The VMA containing the range @start to @end to be updated.
+ * @start: The start of the range to update. May be offset within @vma.
+ * @end: The exclusive end of the range to update, may be offset within @vma.
+ * @vm_flags_ptr: A pointer to the VMA flags that the @start to @end range is
+ * about to be set to. On merge, this will be updated to include any additional
+ * flags which remain in place.
+ *
+ * IMPORTANT: The actual modification being requested here is NOT applied,
+ * rather the VMA is perhaps split, perhaps merged to accommodate the change,
+ * and the caller is expected to perform the actual modification.
+ *
+ * In order to account for VMA flags which may persist (e.g. soft-dirty), the
+ * @vm_flags_ptr parameter points to the requested flags which are then updated
+ * so the caller, should they overwrite any existing flags, correctly retains
+ * these.
+ *
+ * Returns: A VMA which contains the range @start to @end ready to have its
+ * flags altered to *@vm_flags.
+ */
+__must_check struct vm_area_struct *vma_modify_flags(struct vma_iterator *vmi,
 		struct vm_area_struct *prev, struct vm_area_struct *vma,
 		unsigned long start, unsigned long end,
-		vm_flags_t vm_flags);
+		vm_flags_t *vm_flags_ptr);
 
-/* We are about to modify the VMA's anon_name. */
-__must_check struct vm_area_struct
-*vma_modify_name(struct vma_iterator *vmi,
-		 struct vm_area_struct *prev,
-		 struct vm_area_struct *vma,
-		 unsigned long start,
-		 unsigned long end,
-		 struct anon_vma_name *new_name);
-
-/* We are about to modify the VMA's memory policy. */
-__must_check struct vm_area_struct
-*vma_modify_policy(struct vma_iterator *vmi,
-		   struct vm_area_struct *prev,
-		   struct vm_area_struct *vma,
+/**
+ * vma_modify_name() - Peform any necessary split/merge in preparation for
+ * setting anonymous VMA name to @new_name in the range @start to @end contained
+ * within @vma.
+ * @vmi: Valid VMA iterator positioned at @vma.
+ * @prev: The VMA immediately prior to @vma or NULL if @vma is the first.
+ * @vma: The VMA containing the range @start to @end to be updated.
+ * @start: The start of the range to update. May be offset within @vma.
+ * @end: The exclusive end of the range to update, may be offset within @vma.
+ * @new_name: The anonymous VMA name that the @start to @end range is about to
+ * be set to.
+ *
+ * IMPORTANT: The actual modification being requested here is NOT applied,
+ * rather the VMA is perhaps split, perhaps merged to accommodate the change,
+ * and the caller is expected to perform the actual modification.
+ *
+ * Returns: A VMA which contains the range @start to @end ready to have its
+ * anonymous VMA name changed to @new_name.
+ */
+__must_check struct vm_area_struct *vma_modify_name(struct vma_iterator *vmi,
+		struct vm_area_struct *prev, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end,
+		struct anon_vma_name *new_name);
+
+/**
+ * vma_modify_policy() - Peform any necessary split/merge in preparation for
+ * setting NUMA policy to @new_pol in the range @start to @end contained
+ * within @vma.
+ * @vmi: Valid VMA iterator positioned at @vma.
+ * @prev: The VMA immediately prior to @vma or NULL if @vma is the first.
+ * @vma: The VMA containing the range @start to @end to be updated.
+ * @start: The start of the range to update. May be offset within @vma.
+ * @end: The exclusive end of the range to update, may be offset within @vma.
+ * @new_pol: The NUMA policy that the @start to @end range is about to be set
+ * to.
+ *
+ * IMPORTANT: The actual modification being requested here is NOT applied,
+ * rather the VMA is perhaps split, perhaps merged to accommodate the change,
+ * and the caller is expected to perform the actual modification.
+ *
+ * Returns: A VMA which contains the range @start to @end ready to have its
+ * NUMA policy changed to @new_pol.
+ */
+__must_check struct vm_area_struct *vma_modify_policy(struct vma_iterator *vmi,
+		   struct vm_area_struct *prev, struct vm_area_struct *vma,
 		   unsigned long start, unsigned long end,
 		   struct mempolicy *new_pol);
 
-/* We are about to modify the VMA's flags and/or uffd context. */
-__must_check struct vm_area_struct
-*vma_modify_flags_uffd(struct vma_iterator *vmi,
-		       struct vm_area_struct *prev,
-		       struct vm_area_struct *vma,
-		       unsigned long start, unsigned long end,
-		       vm_flags_t vm_flags,
-		       struct vm_userfaultfd_ctx new_ctx,
-		       bool give_up_on_oom);
-
-__must_check struct vm_area_struct
-*vma_merge_new_range(struct vma_merge_struct *vmg);
-
-__must_check struct vm_area_struct
-*vma_merge_extend(struct vma_iterator *vmi,
-		  struct vm_area_struct *vma,
-		  unsigned long delta);
+/**
+ * vma_modify_flags_uffd() - Peform any necessary split/merge in preparation for
+ * setting VMA flags to @vm_flags and UFFD context to @new_ctx in the range
+ * @start to @end contained within @vma.
+ * @vmi: Valid VMA iterator positioned at @vma.
+ * @prev: The VMA immediately prior to @vma or NULL if @vma is the first.
+ * @vma: The VMA containing the range @start to @end to be updated.
+ * @start: The start of the range to update. May be offset within @vma.
+ * @end: The exclusive end of the range to update, may be offset within @vma.
+ * @vm_flags: The VMA flags that the @start to @end range is about to be set to.
+ * @new_ctx: The userfaultfd context that the @start to @end range is about to
+ * be set to.
+ * @give_up_on_oom: If an out of memory condition occurs on merge, simply give
+ * up on it and treat the merge as best-effort.
+ *
+ * IMPORTANT: The actual modification being requested here is NOT applied,
+ * rather the VMA is perhaps split, perhaps merged to accommodate the change,
+ * and the caller is expected to perform the actual modification.
+ *
+ * Returns: A VMA which contains the range @start to @end ready to have its VMA
+ * flags changed to @vm_flags and its userfaultfd context changed to @new_ctx.
+ */
+__must_check struct vm_area_struct *vma_modify_flags_uffd(struct vma_iterator *vmi,
+		struct vm_area_struct *prev, struct vm_area_struct *vma,
+		unsigned long start, unsigned long end, vm_flags_t vm_flags,
+		struct vm_userfaultfd_ctx new_ctx, bool give_up_on_oom);
+
+__must_check struct vm_area_struct *vma_merge_new_range(struct vma_merge_struct *vmg);
+
+__must_check struct vm_area_struct *vma_merge_extend(struct vma_iterator *vmi,
+		  struct vm_area_struct *vma, unsigned long delta);
 
 void unlink_file_vma_batch_init(struct unlink_vma_file_batch *vb);
 
--- a/tools/testing/vma/vma.c
+++ b/tools/testing/vma/vma.c
@@ -339,6 +339,7 @@ static bool test_simple_modify(void)
 	struct mm_struct mm = {};
 	struct vm_area_struct *init_vma = alloc_vma(&mm, 0, 0x3000, 0, vm_flags);
 	VMA_ITERATOR(vmi, &mm, 0x1000);
+	vm_flags_t flags = VM_READ | VM_MAYREAD;
 
 	ASSERT_FALSE(attach_vma(&mm, init_vma));
 
@@ -347,7 +348,7 @@ static bool test_simple_modify(void)
 	 * performs the merge/split only.
 	 */
 	vma = vma_modify_flags(&vmi, init_vma, init_vma,
-			       0x1000, 0x2000, VM_READ | VM_MAYREAD);
+			       0x1000, 0x2000, &flags);
 	ASSERT_NE(vma, NULL);
 	/* We modify the provided VMA, and on split allocate new VMAs. */
 	ASSERT_EQ(vma, init_vma);


Patches currently in stable-queue which might be from elaidya225@gmail.com are

queue-6.18/testing-selftests-mm-add-soft-dirty-merge-self-test.patch
queue-6.18/mm-implement-sticky-vma-flags.patch
queue-6.18/mm-update-vma_modify_flags-to-handle-residual-flags-document.patch
queue-6.18/mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch
queue-6.18/mm-propagate-vm_softdirty-on-merge.patch
queue-6.18/mm-set-the-vm_maybe_guard-flag-on-guard-region-install.patch
queue-6.18/mm-introduce-copy-on-fork-vmas-and-make-vm_maybe_guard-one.patch
queue-6.18/mm-introduce-vm_maybe_guard-and-make-visible-in-proc-pid-smaps.patch

