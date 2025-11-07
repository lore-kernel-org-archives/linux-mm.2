Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D281CCFA05
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 17:48:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7345E8E000D; Fri,  7 Nov 2025 12:48:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E5268E0002; Fri,  7 Nov 2025 12:48:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D5478E000D; Fri,  7 Nov 2025 12:48:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 481B88E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:48:17 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0487C4BB95
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:48:16 +0000 (UTC)
X-FDA: 84084545034.09.76091B6
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id F3E964000A
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:48:14 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="JChn/KmQ";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762537695; a=rsa-sha256;
	cv=none;
	b=OBmXlCl+BF/qg7BtqPTliVnmWb4VS0cAxo0KgVW+uz5C+1NeaxXQYmPmfzRUDhiHKtg9kB
	UwDmXyRXCdu7Aa4Y+N1nDgost5Yecq7ycglE4dRwD662+9aJe4mwllz1p3+BTRa+i5Aw9E
	oKk+XZRwIyfezVuxfubJlwnOkCXYHAo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="JChn/KmQ";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762537695;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OtB+sZpQawht6Y2wkMhn/jRh99U8DiHTZvyeB15mQow=;
	b=1I9IDl6XpbXZ7YhRiJ5aCnzcyF8wkBjtwbKdLNGBB9Zch5EQiwr/bYln2Q34kGwsscVpkg
	diy2DOx5tUbPXEZQgAfUVpz7ZVrtLAmIjx7QJ1ASk7NHh0nyLtt3uWAjAmieJUfufIngZH
	QhQ9y6Oyu9u2JnXeHk3dz4f1G9cnm5I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762537694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=OtB+sZpQawht6Y2wkMhn/jRh99U8DiHTZvyeB15mQow=;
	b=JChn/KmQoPXvc9upZrr035/hg2QLczAm+I5z5tBkAnnPzHpgAY93KFBuFbw+1I2P5tXK55
	wKywTQDtqBhXpYwjJfss6glMKQtbW6VRWGE5hhyAjb8PqhkdlMq3wG0ECYhozpcQ5aIhDz
	e7IQ+BJXUuhrBYMPhGNuPc47naKdpn4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-527-pyVrMrA2OsmnKgqooUZhkg-1; Fri,
 07 Nov 2025 12:48:10 -0500
X-MC-Unique: pyVrMrA2OsmnKgqooUZhkg-1
X-Mimecast-MFC-AGG-ID: pyVrMrA2OsmnKgqooUZhkg_1762537689
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6AB36195605B;
	Fri,  7 Nov 2025 17:48:09 +0000 (UTC)
Received: from [10.45.225.163] (unknown [10.45.225.163])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C0671196B8FC;
	Fri,  7 Nov 2025 17:48:06 +0000 (UTC)
Date: Fri, 7 Nov 2025 18:48:01 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Alex Deucher <alexander.deucher@amd.com>, 
    =?ISO-8859-15?Q?Christian_K=F6nig?= <christian.koenig@amd.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    David Hildenbrand <david@redhat.com>
cc: amd-gfx@lists.freedesktop.org, linux-mm@kvack.org
Subject: [PATCH v2] fix AMDGPU failure with periodic signal
Message-ID: <6f16b618-26fc-3031-abe8-65c2090262e7@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZLk1rCM2jCUIltL4JnFasHNFvDVBbFIML3Cz9KhtOwc_1762537689
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F3E964000A
X-Stat-Signature: 1qkofiob1hrjnaudke9wizy4im5zou3w
X-HE-Tag: 1762537694-675368
X-HE-Meta: U2FsdGVkX1/Y8N3PA+Vm48YQEXmLECG6tHQMr1kI2sxNPIcD/MrrEDpae1p0AsNRVeD6Mu+KAIc051jzniq/AU/V9nURxyw6gSIGGM0bZfqiekW0UfLyMPxx1XwDK3+nse5ottUhT6Rar+HIixjhPavP7RcV9hiWG8JTqUuWbeHybTxsRpJroHcKm3yKeTmAoPnVRi/KuaMETYHjkzsReCF2kf9LI0LzZkQnq/iYVEvtDALqn4vnC7qh8qa1VGCsix2K3PAS3MU7/WhYUZ5ZgJFhFhB3x2vUBMG86BAOUjZiSXfAKDmaeE+b7vz7PzniD8UnqOb7kQQi6ubeiurHqigiHZp+S7eDQ0lNM6QacfeiONJXxoZnpIvQOo8GaTbxGW0vM4w+zJE36YzWcBehhIbxFFp674FmxOehlyqYKigf+coL72Avqer567KoP59ts/tZeOPLSSoRtiym3xJJeLW87ucEF+rREzsUe8Fr+mXu2/bHtCSG010g45zu146TtfvP8u/bx7Rlzcmj+HrjH6Xmwd8JwrB/iZoeYcqbk1g+IXkf5ay2Io0eUXS07PPjQfuPAf1JiJo0gs7VmiAEGgmEOy+vohM4sr3/UAC7i9KyfioLQ5wyajZQjoTr3gonrjnEAxJljTEycitlw3UIe+URvvy4RdL1aC9/bdfD7xSdKRUlNNQMWhYguc32SWbY7sEqR6peVqh0Tee1DgOePOrCvyDmgq0VGaoEkzKN3b8zTR/cBshYxPyvgdRlPkW/gXDrtjBu/xrFh+c5zbpwCK2L1mWGzsdLLR+VoEbgD1r14jE643rocqaIoGci4cq5nQTjCNXUSjyjjoDUm8YBe6iNToldZwaZPQFvwU/+YfyC+XQj+iF/cQIn99s1MkENdlHG4SYNBcbKc2j99/NfR43yMreiwj9yEErnqpCWxNBf5vIoY1RAnzWeX6MYyRGKrf9OuDBQnpBBxEH9SBB
 224bp6aB
 HqpBrmXNCK/F+qQfovQl5IjhFICK6gAfup3olSEE8vIgce8ynfI5z9J9s3th8lj83qAi2/OD5A4BYlWDJRJNlaULe0BQmgo2KGDTfUoflLIwsKyKyjfaVt6uP3L84KPcioKqA00x2HwSBY5Sq2hvFkLjvmS0DoZ13/t/qcBsr7+ijXD1f2y9r430BbECTJHd9nlNiph9UNcIIm7vrClNJf2VKDgnrzdxqkjQvQoAKNnQ3fJ71EeZWrsAbuCyRpGgKiqkUq4c3HJx4rrXIqn1spdKHlyeJG2k1ACpBfGa8TatjunqNDGrR0wtSqilK21QfkgJ9U7RLeJGUhev/iLjIgWUVbstHcF1/U+Pk44bYXZ3Cj1mnaQuLDeXgNKi68bd2i6syOaG6eNhQ8VrzkpE2qv92kVE/1LxOP4threnzmiH+XaO456kFwglLokpSRnh0V9jgdBpo5tgECpu/Cbm/vWLkHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If a process sets up a timer that periodically sends a signal in short
intervals and if it uses OpenCL on AMDGPU at the same time, we get random
errors. Sometimes, probing the OpenCL device fails (strace shows that
open("/dev/kfd") failed with -EINTR). Sometimes we get the message
"amdgpu: init_user_pages: Failed to register MMU notifier: -4" in the
syslog.

The bug can be reproduced with this program:
http://www.jikos.cz/~mikulas/testcases/opencl/opencl-bug-small.c

The root cause for these failures is in the function mm_take_all_locks.
This function fails with -EINTR if there is pending signal. The -EINTR is
propagated up the call stack to userspace and userspace fails if it gets
this error.

There is the following call chain: kfd_open -> kfd_create_process ->
create_process -> mmu_notifier_get -> mmu_notifier_get_locked ->
__mmu_notifier_register -> mm_take_all_locks -> "return -EINTR"

If the failure happens in init_user_pages, there is the following call
chain: init_user_pages -> amdgpu_hmm_register ->
mmu_interval_notifier_insert -> mmu_notifier_register ->
__mmu_notifier_register -> mm_take_all_locks -> "return -EINTR"

In order to fix these failures, this commit changes
signal_pending(current) to fatal_signal_pending(current) in
mm_take_all_locks, so that it is interrupted only if the signal is
actually killing the process.

Also, this commit skips pr_err in init_user_pages if the process is being
killed - in this situation, there was no error and so we don't want to
report it in the syslog.

I'm submitting this patch for the stable kernels, because this bug may
cause random failures in any OpenCL code.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org

---
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c |    9 +++++++--
 mm/vma.c                                         |    8 ++++----
 2 files changed, 11 insertions(+), 6 deletions(-)

Index: linux-6.17.7/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
===================================================================
--- linux-6.17.7.orig/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
+++ linux-6.17.7/drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c
@@ -1069,8 +1069,13 @@ static int init_user_pages(struct kgd_me
 
 	ret = amdgpu_hmm_register(bo, user_addr);
 	if (ret) {
-		pr_err("%s: Failed to register MMU notifier: %d\n",
-		       __func__, ret);
+		/*
+		 * If we got EINTR because the process was killed, don't report
+		 * it, because no error happened.
+		 */
+		if (!(fatal_signal_pending(current) && ret == -EINTR))
+			pr_err("%s: Failed to register MMU notifier: %d\n",
+			       __func__, ret);
 		goto out;
 	}
 
Index: linux-6.17.7/mm/vma.c
===================================================================
--- linux-6.17.7.orig/mm/vma.c
+++ linux-6.17.7/mm/vma.c
@@ -2175,14 +2175,14 @@ int mm_take_all_locks(struct mm_struct *
 	 * is reached.
 	 */
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (fatal_signal_pending(current))
 			goto out_unlock;
 		vma_start_write(vma);
 	}
 
 	vma_iter_init(&vmi, mm, 0);
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (fatal_signal_pending(current))
 			goto out_unlock;
 		if (vma->vm_file && vma->vm_file->f_mapping &&
 				is_vm_hugetlb_page(vma))
@@ -2191,7 +2191,7 @@ int mm_take_all_locks(struct mm_struct *
 
 	vma_iter_init(&vmi, mm, 0);
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (fatal_signal_pending(current))
 			goto out_unlock;
 		if (vma->vm_file && vma->vm_file->f_mapping &&
 				!is_vm_hugetlb_page(vma))
@@ -2200,7 +2200,7 @@ int mm_take_all_locks(struct mm_struct *
 
 	vma_iter_init(&vmi, mm, 0);
 	for_each_vma(vmi, vma) {
-		if (signal_pending(current))
+		if (fatal_signal_pending(current))
 			goto out_unlock;
 		if (vma->anon_vma)
 			list_for_each_entry(avc, &vma->anon_vma_chain, same_vma)


