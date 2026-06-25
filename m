Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0B77CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 11:31:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A92E96B010C; Thu, 25 Jun 2026 07:31:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6A406B010D; Thu, 25 Jun 2026 07:31:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A8126B010E; Thu, 25 Jun 2026 07:31:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 726146B010C
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 07:31:08 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F04C0167689
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:31:07 +0000 (UTC)
X-FDA: 84918218574.09.B644C9C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 3533A140007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 11:31:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=dVeTUjoU;
	spf=pass (imf09.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782387066;
	b=vF70D5dC2Tk6Dq4EWAeT+k+lmi+bmvno3RbmzF1GnABRGEMNkocprpm8nHjmbk+i1oDl1h
	KcBuTsFuxwgt1yha/e6UYES1wWaHd2sPxN7ZDJYWrQphQ378cdAdT/DRXkc5Kbqomz4TvS
	63USVLm5Y2xj3dXcd5R3bm9tuXBAGyU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782387066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=SSWPqL14BLonbO7R0VQVr7FBG/mp5EpHUIIbFs7w2GY=;
	b=zOOqa8iShMZYn62DZy0MwxsvfoUiWWaqhcdSJPK5lOC9Er5MdCM0IACEkAzGDvmOcBBjjQ
	+UKA21yVnwRcGjfBfhMm/osTyKkRCSQK4im9RgfgHwEmM0Xn4dDte0rReKwtSRuTWiODi4
	Wli+OMgvNV7wBgwc4kDMerBMqtm6iCQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linuxfoundation.org header.s=korg header.b=dVeTUjoU;
	spf=pass (imf09.hostedemail.com: domain of gregkh@linuxfoundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=gregkh@linuxfoundation.org;
	dmarc=pass (policy=none) header.from=linuxfoundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A139600FC;
	Thu, 25 Jun 2026 11:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EB8D1F000E9;
	Thu, 25 Jun 2026 11:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782387065;
	bh=SSWPqL14BLonbO7R0VQVr7FBG/mp5EpHUIIbFs7w2GY=;
	h=Subject:To:Cc:From:Date:In-Reply-To;
	b=dVeTUjoUtZCTcyovj301zVADU3PsNZUParU1TttfxbsI2VquFxi0Q0+nrLR6o1XvF
	 6DGTJQ+Zpdw5DGyiXaAtaCxJHV/LYp7aPHjEzdIjCk0mImqNLpzDhRtGhkzg7ujPZO
	 ZOiWwLpltB4+JL4BJWkgDE8DIsf9vp4zXRit/ti8=
Subject: Patch "mm: add atomic VMA flags and set VM_MAYBE_GUARD as such" has been added to the 6.18-stable tree
To: akpm@linux-foundation.org,avagin@gmail.com,baohua@kernel.org,baolin.wang@linux.alibaba.com,corbet@lwn.net,david@kernel.org,dev.jain@arm.com,elaidya225@gmail.com,gregkh@linuxfoundation.org,jannh@google.com,lance.yang@linux.dev,liam.howlett@oracle.com,linux-mm@kvack.org,ljs@kernel.org,lorenzo.stoakes@oracle.com,mathieu.desnoyers@efficios.com,mhiramat@kernel.org,mhocko@suse.com,npache@redhat.com,pfalcato@suse.de,rostedt@goodmis.org,rppt@kernel.org,ryan.roberts@arm.com,surenb@google.com,vbabka@suse.cz,ziy@nvidia.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 25 Jun 2026 12:29:47 +0100
In-Reply-To: <20260515124218.151966-4-elaidya225@gmail.com>
Message-ID: <2026062547-laundry-raking-aa16@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore
X-Rspam-User: 
X-Stat-Signature: 36suopc9httyn5oono7iwyru8s46skpk
X-Rspamd-Queue-Id: 3533A140007
X-Rspamd-Server: rspam06
X-HE-Tag: 1782387066-725060
X-HE-Meta: U2FsdGVkX18RIJeUrjjvPoLDnAisLg92h2PIkbpPz8UDqvguaKiwwrMoQdvHHFdYHm/hNUK9LnsMwoZEVaORVlB9AEScqnrFsX0YyqPAHBc/4PIduy6doc1kwuH5mou0A3GOTAMYeuf+QvTdCIXFYlKHRr+0zR6+SBkHUdWR9UofLUKsDZA5hxKDLDpF4+ZtEN0BPUmEhG+bA8LLdNbmyzZQSWfL2a0QeQfOyZoTh+dlUHvDXBwVVVgioYMc5F3ebK9oArliqRgL1Kxzmi6SFuE0P45nDjU+EFbGMq6b5bzDFgF4oEGlnxqWALjIJ2T8sKXQuNhHRKPB+dNwuapLNjbtq68g6o3CIE+MAE9QLQGFf0RFyUDxDqpB98kgcreryDImWHRVcHX7EYQzFv46jwyz3fDSaNG5k1RvAIHp7LTFoB4VRJPMpnc8k3YkXROr+znzhJaFlxle5jpAzQQ8dCgvEC5NeP5snwtnv0Xw7lG3KcDkGmhYRGhvwW9I1D7tNRkNYXGBZuC4zRJcQJz2PnfiVvY01ZO1hN1nHBW93aSXIv8Ab71xsacYgo7d9IFSFwSyK09TzjYSE2TE/50wfE3PET8rRoob+QJkvikcPElUMTC9ymDAwbGIe18XqSgQS42he1t0yAtS27cAOh7Tn8DJY+Td8szQQBzWXVbjXWYqjsexdKxvI5eFsprV1Z4owsd006D11ShJdar78tfLZxjmcsbe7c4ivy/nQ0tF0urHOCkThM/HoFUJFhBBS537/Xn/sYCGojAPtgfwIDrAzWadnchEznGrpD1SSL3oXzAKQwdaAA2RXf6/SgWR0luHz65ACrYdws7FFqyIU9FLvlJ1M3Ble3Rms9xQdvF6jxtODcKZCPxYN1Jy+0ls33iB86oyIw72HThjd4gIIH7qXOr3ht7wJ7WCsS7m9Y7KpllTBkp37kH8hn7I+Nvn1LAmOZ2DX+7s/znmoTDqz8a
 EmLjKlq9
 W0y+ioXsLCMo7nFHgB4UedXzR+NJrzr4wX/+VEkHCdY7NnJ3MUJhm9IlDdtM+yTFIVzHRlhXVuUZGodAD4i32VIeVlXX4+ccLVKEVmXeZPICSNisztou5uSinTh8HQTgwATZ+tJZo73tUCsTjUZz4OV/dGghjhbQ8wsGDCtFG0NgtxupxQOnKP7tu3s/5jaD52a7suc41+s0EFgODbaXlotRQ4yj2bh2H0zzDsJ+d6avtmorxau6tAFryHpUuzTxvklM+3IuP8jhSzyAssF8CufXDSO2hMvBLH8Vgs9As78Rx2UjUNfPzRcyfnPJjqymiZubcL6zye8TVQvSn7hZiARaKaaNW/J/6vK4xDkdZSpEC6Rr5Ismk/1/hXbRl0fQkjyzf1l91NzSwzEh/oaSvmBIRpPH/YoYCMc6i0f7jp4Xvl0IAVdwM8ymG67sgnWCWZJJdUrzb2SGnDA+xr4ioWtCIg97jcbtWt1z0Ve03dOUCmHoAQHTkK/BR1UKNMhvUTStz6CNrFOS+ua95pvIn8LtuMWHrz/yZilnxsu58dBc17fwbgMCjn0yeBX5UmN1bVQWcBf7sfz7EOsc3KQH3wCxVz5gcG4JM7yqYBlwhkJFTGHJzWshM1u3ttxGnEPWDZvaO/4CltACDsrC+qtU/AWAQ7IgdKOQF4wPCwocYTCBnp51JLp78kNZxA6ym/azFArLc5cP+gexHJofObh9RVBL6HnRmNdjV6UcYWAtqAtzaM/0WhfUMsrvhIu5q8s+6ChwmqkT5jzQ4GSxTghmUQLPMgsry1/JuLKqV9e/ad8GSagX/gwfGcuu6hi4DutFUDNV/b0rkYC6KjUYozCYGo49uIBxRG9bMSbf3GJ0WkQY+JcWaJq/VZHa4SNjpJBjuqSoJI8STWDSFstItn+3Z8V+nFVWOuESJ9lixlGrnZey5Vl5SkzUMGR9oGW4zZnLp38x9npIukrrIhD+ftgy09aG2yraj
 Zb5NM5gi
 JCaV8xLAENmlPQS7DIMh663pYYeMUeWHpCe2tCg4OX3/tsRXggjdlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


This is a note to let you know that I've just added the patch titled

    mm: add atomic VMA flags and set VM_MAYBE_GUARD as such

to the 6.18-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch
and it can be found in the queue-6.18 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-247749-greg=kroah.com@vger.kernel.org Fri May 15 14:05:33 2026
From: Ahmed Elaidy <elaidya225@gmail.com>
Date: Fri, 15 May 2026 15:42:12 +0300
Subject: mm: add atomic VMA flags and set VM_MAYBE_GUARD as such
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, ljs@kernel.org, avagin@gmail.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Pedro Falcato <pfalcato@suse.de>, Vlastimil Babka <vbabka@suse.cz>, "David Hildenbrand (Red Hat)" <david@kernel.org>, Lance Yang <lance.yang@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>, Jann Horn <jannh@google.com>, Jonathan Corbet <corbet@lwn.net>, Liam Howlett <liam.howlett@oracle.com>, "Masami Hiramatsu (Google)" <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Suren Baghdasaryan <surenb@google.com>, Zi Yan <ziy@nvidia.com>, Ahmed Elaidy <elaidya225@gmail.com>
Message-ID: <20260515124218.151966-4-elaidya225@gmail.com>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

commit 568822502383acd57d7cc1c72ee43932c45a9524 upstream.

This patch adds the ability to atomically set VMA flags with only the mmap
read/VMA read lock held.

As this could be hugely problematic for VMA flags in general given that
all other accesses are non-atomic and serialised by the mmap/VMA locks, we
implement this with a strict allow-list - that is, only designated flags
are allowed to do this.

We make VM_MAYBE_GUARD one of these flags.

Link: https://lkml.kernel.org/r/97e57abed09f2663077ed7a36fb8206e243171a9.1763460113.git.ljs@kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Andrei Vagin <avagin@gmail.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jonathan Corbet <corbet@lwn.net>
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
 include/linux/mm.h |   44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -501,6 +501,9 @@ extern unsigned int kobjsize(const void
 /* This mask represents all the VMA flag bits used by mlock */
 #define VM_LOCKED_MASK	(VM_LOCKED | VM_LOCKONFAULT)
 
+/* These flags can be updated atomically via VMA/mmap read lock. */
+#define VM_ATOMIC_SET_ALLOWED VM_MAYBE_GUARD
+
 /* Arch-specific flags to clear when updating VM flags on protection change */
 #ifndef VM_ARCH_CLEAR
 # define VM_ARCH_CLEAR	VM_NONE
@@ -843,6 +846,47 @@ static inline void vm_flags_mod(struct v
 	__vm_flags_mod(vma, set, clear);
 }
 
+static inline bool __vma_flag_atomic_valid(struct vm_area_struct *vma,
+				       int bit)
+{
+	const vm_flags_t mask = BIT(bit);
+
+	/* Only specific flags are permitted */
+	if (WARN_ON_ONCE(!(mask & VM_ATOMIC_SET_ALLOWED)))
+		return false;
+
+	return true;
+}
+
+/*
+ * Set VMA flag atomically. Requires only VMA/mmap read lock. Only specific
+ * valid flags are allowed to do this.
+ */
+static inline void vma_flag_set_atomic(struct vm_area_struct *vma, int bit)
+{
+	/* mmap read lock/VMA read lock must be held. */
+	if (!rwsem_is_locked(&vma->vm_mm->mmap_lock))
+		vma_assert_locked(vma);
+
+	if (__vma_flag_atomic_valid(vma, bit))
+		set_bit(bit, &ACCESS_PRIVATE(vma, __vm_flags));
+}
+
+/*
+ * Test for VMA flag atomically. Requires no locks. Only specific valid flags
+ * are allowed to do this.
+ *
+ * This is necessarily racey, so callers must ensure that serialisation is
+ * achieved through some other means, or that races are permissible.
+ */
+static inline bool vma_flag_test_atomic(struct vm_area_struct *vma, int bit)
+{
+	if (__vma_flag_atomic_valid(vma, bit))
+		return test_bit(bit, &vma->vm_flags);
+
+	return false;
+}
+
 static inline void vma_set_anonymous(struct vm_area_struct *vma)
 {
 	vma->vm_ops = NULL;


Patches currently in stable-queue which might be from elaidya225@gmail.com are

queue-6.18/testing-selftests-mm-add-soft-dirty-merge-self-test.patch
queue-6.18/mm-implement-sticky-vma-flags.patch
queue-6.18/mm-update-vma_modify_flags-to-handle-residual-flags-document.patch
queue-6.18/mm-add-atomic-vma-flags-and-set-vm_maybe_guard-as-such.patch
queue-6.18/mm-propagate-vm_softdirty-on-merge.patch
queue-6.18/mm-set-the-vm_maybe_guard-flag-on-guard-region-install.patch
queue-6.18/mm-introduce-copy-on-fork-vmas-and-make-vm_maybe_guard-one.patch
queue-6.18/mm-introduce-vm_maybe_guard-and-make-visible-in-proc-pid-smaps.patch

