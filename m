Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2932C55184
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90C386B00ED; Tue,  4 Aug 2026 10:32:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86E6E6B00EA; Tue,  4 Aug 2026 10:32:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75CEB6B00ED; Tue,  4 Aug 2026 10:32:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 31C846B00E7
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:32:54 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 715CA40142
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:05:48 +0000 (UTC)
X-FDA: 85063457976.28.9556514
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf25.hostedemail.com (Postfix) with ESMTP id 38D96A0014
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 12:05:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="W28lRHx/";
	spf=pass (imf25.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785845146;
	b=0/KbOKRSkvxCm3an1j+gPevjmtg2UhE10xXJfmngBPsVPBlJ3zuuQXQfqBIBK/ouzYT2jp
	qykHBzLJ7N1ueUVC0NTckej69uhyatuRTeDbfXC1lSJKBMI78/0XGbCwpdqqRvy9+hI1Jp
	z1s2Gs0cUy8A6/tNw7uiKJdjH5+8T80=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="W28lRHx/";
	spf=pass (imf25.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785845146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=AZAgqjN1G77tAGGqT1Vu5xvpE2S1pmBmpjJ+rMqalos=;
	b=LrFhFHM16EFcnlX+5qUXNyzNB+7JahLaebJ0RLUj42KDwsbOzS+7ADzWnmnCbQtuEXPgRT
	XYfWjUig83Q2P2syKMUoPTHsWxMSn1ujC1PpDlM0Tau5ophjO2MtkDgl9DCXVQ45JLQ8rp
	vzQXwoW15nZCbUgY/P17v9QVfXXQHLA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785845145;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=AZAgqjN1G77tAGGqT1Vu5xvpE2S1pmBmpjJ+rMqalos=;
	b=W28lRHx/kD+9Y16/BesCNcgDwJyDBpeKAEMDFNYjSuFSVSgUC62M/MLnTYB5jlIfZgzklL
	Q4AjRoYBI6VD6R7cuJYH4INs+md689FhIZobEROi//C5efyjsHyl9aKL9HJkvfMIEa4cvL
	BB5QUuWGaREabn6l8zl+C22UXa65e1A=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-215-NOsbteC9OXmEC0S2UI7sDg-1; Tue, 04 Aug 2026 08:05:34 -0400
X-MC-Unique: NOsbteC9OXmEC0S2UI7sDg-1
X-Mimecast-MFC-AGG-ID: NOsbteC9OXmEC0S2UI7sDg_1785845133
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-493bfc3b84aso17217555e9.0
        for <linux-mm@kvack.org>; Tue, 04 Aug 2026 05:05:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785845133; x=1786449933;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AZAgqjN1G77tAGGqT1Vu5xvpE2S1pmBmpjJ+rMqalos=;
        b=pgFN7PtNQIlBZ72Y1JM+uABduj9m+qZog6T4P0HFRX9pYZpkDW2uPxE4vNuAzZkkDq
         TeXOQqkcBwqduTwJnmOVudMqvsRr7rZfgtzki8cZDfXl783RZGO6OGfWEdayljr/X56l
         sX0LLgInYa1DJOq5PmlUshLzESZkysxuXwU+nv5i4gCcOxR6BFVWEyPHjgcpcQ2NZZrD
         QSmm+FqWmd7Aa6swZJ3L0Q8a1b06feMNKKmza2bc7NWkKNGKmXKsVHdCoFvHduAOWfTS
         zG2fKQFyVwII4RwTTmJWEN6PIEKIG0wZ11v7osigZxxUlr+xTF7L3wVrNcsgPjBdov+n
         jRrQ==
X-Forwarded-Encrypted: i=1; AHgh+RpIljFRsi7OzEB2w5EcIP27DSFE7z69xhKzAysOr5vGNFHfIdfIgCpil35rMjLEbxOlb5yQD+CqBw==@kvack.org
X-Gm-Message-State: AOJu0YzOu/mQT+NrHJeMZyL8CKeXfuofhvmg7H58NB+Ne91LxsvJZYzH
	+xoSwS6PUkFcb5XwX4KpDIgT+i1fWlkjjZ1YsEaZ1HhgKTuawsucWWzrqOPVuo3kFS1ShDedTGr
	y5Fa932Go6WMtNo5uIPWyJZ+vRxfe6hZ9brWH/yipY87V9+XoQ3zf
X-Gm-Gg: AR+sD12+4oceNY9eAeW/XeRPTNvqaHrZeb479Jvh1UElR4XM3eYHjwrfZ5L5uYJIa19
	uHjnei6UevJV0BVIoabIAyoT/7aLtAc3yedGE73/VD3w98t/DnZBMgPHkFcu4aa9oJ+lBj6rZKI
	QOTj6ZI15UfL5Du8fhxGN4s8ypeqtFwDFVoqyVLAewzYsXMWObYmT37It6pexsklXhPg4LWSzcr
	JObOMGby0q/57MiZCrv+op+r9oVG6kaOV5Z3z10p0zMaF2z9XrPWMzKWx0RMJpKO5bgqBI6ywUe
	wqquFmj5PuIVJGJ82jVftP0RCoyEJCEPFBGYrTJvakUrtIfrvbyGJVfcaK+Q7CLH5YVXgp1rdd7
	YDAh2/nBX5zQOQRh3SyDLJDsdu1rMCbDfZTw1yADBpwHMii9DNBu+nKUmmp6cVfCgFf5+olaqfV
	/V03E=
X-Received: by 2002:a7b:cc82:0:b0:495:6e68:5df2 with SMTP id 5b1f17b1804b1-4980c673d61mr252271295e9.12.1785845132658;
        Tue, 04 Aug 2026 05:05:32 -0700 (PDT)
X-Received: by 2002:a7b:cc82:0:b0:495:6e68:5df2 with SMTP id 5b1f17b1804b1-4980c673d61mr252270015e9.12.1785845132021;
        Tue, 04 Aug 2026 05:05:32 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.34.92])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49949fec606sm99039055e9.14.2026.08.04.05.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 05:05:31 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Alex Williamson <alex@shazbot.org>,
	bcm-kernel-feedback-list@broadcom.com,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Christian Koenig <christian.koenig@amd.com>,
	David Hildenbrand <david@kernel.org>,
	dri-devel@lists.freedesktop.org,
	Fei Li <fei1.li@intel.com>,
	Huang Rui <ray.huang@amd.com>,
	linux-mm@kvack.org,
	linux-s390@vger.kernel.org,
	Michal Hocko <mhocko@suse.com>,
	Peter Xu <peterx@redhat.com>,
	Sergio Lopez <slp@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH v2 0/6] mm, drm: fix interaction of .pfn_mkwrite() with fixup_user_fault()
Date: Tue,  4 Aug 2026 14:05:22 +0200
Message-ID: <20260804120529.1730187-1-pbonzini@redhat.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 5qpQmEUgh8Tp7Ut0a2rK3v5hOQj03b7UT4DUKMqeoVY_1785845133
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 38D96A0014
X-Stat-Signature: fmcjzn1bdn17gxttowcu6ay6xsbofnrr
X-Rspam-User: 
X-HE-Tag: 1785845146-26040
X-HE-Meta: U2FsdGVkX1+N6x7avHWom9wziW53iZytHFczIA+tXRYyRahh0eKoAiIfxwcrYINjFegY4OOCo/tvQJRpdAMHByh+VfEoXFJCatCH+QXce0FJneF2qXerD8AZs0dKzT8tmVefb/V0WfwspQWu9VikNlw59uvToFCSQiTeEszBYPlvc27UTeFRURnlJTbpxFnC8wPQN5QnA6UQbSSV2UHcyb/D6vSVDM1/Klj/RdyCOhBZDQVibobkhIQu33TQdRcx5ECxRHJi6+G4AAIhNzOzFzlyqbUtMZ1xqp4T78kF9/T3vw2qNLou21OACuBYwtOZU5P1YBSqmkNRw2wxfR61p96YLuLwrf2KwPQTXF/gslfpztdsyxGHY/88H2zOr3ZAYHRjHMBqsWg03I/sLSqX7PgyZzkOvtDyQzI2+Dve2gUAbMTDPpYjgBpHERX7n8a5vNELX0IM8We0d9mpVqqNwBu5vdnlDa6VWZU6jdK/2nAyA1t8Tas1Mdlz5AMgBpNDZh4mdFA+9khrcNGRMVHUePr+rA1ETHiyOtmYyjvurxDYTl6FcKp3F2IB/Y29/E3EGYUpcqWEBcUI+uf3TBwwxisI4gsNU/Afzi0g5r+JEqME8mo+1bIw6KvdkYyDlgCUcRtOy7S3uaJe4wcDxf+t5sGBgvNQqkrhC4jV0tW/F8lmQnN+6oDKnhhhZCi6tvdypIK/0GcM3rKHPvriy3BIzu6nuO0trNpZxLOa+iHztmwarV38PQ//5D/38uBSDfTakzkLL+Ax5okPVPtNDsV5zwrFHT+HE3wR40Bg/x/YJXQAIVwK7dkuy/RzhdR5CjKIGmIW9p5aFCRTmXq1ZNxGePGzJGU3UloI60w/yy/ZXmeR9IMU7Ii+nze0DTzsJZjIAzOj671cXkeKmomJykdq2FZoDKf75mWS6zVI/QiIMUIeSjZ7Jtgb4dEwWChcpETvNT8ZQNqUoSF3rheePjs
 wIs/s60D
 oslFQoTziojniuGAah4CcuyVVfrQeb3/DI5mfsxk7DsVinJSul1kKS+uIKd0FB9AR3i7wf/HyjrDxUOWTMXFFnD/jESaoLBQkVZoC8SxbNx45sXbpMR36kar0QdTG1sVM0skcfXhzHjGctBmdYXLJGkmzgpRj08dnbONUrW6mWoxuFfd81U6UicoS/q7A2aPSmaEpezForGAIQGtLKiHFk4Yn57KWvyDT2LjIN4Vh/D9MWr3v00iCLtPvrTG3pnAyue2Qyo0B1w6AkiRDg4fOP8bC6t3neGXoSjaOMxzY2btgtl6+Bko4EbEj4m/IPoYSwLW73bzhmOyWOPuBV3Mnjmq08iYG20q9xKlTGNBYEgR/h0AouItlvedHPOij2UeF3ijhl8vdOtc1bvw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This "v2" combines three series that I have previously posted separately to gather
reviews and tests:

- kvm: apply VM_READ/VM_WRITE checks to all VMA types
  https://lore.kernel.org/kvm/20260731175834.1121005-1-pbonzini@redhat.com/

- mm: pull writability check to follow_pfnmap_start()
  https://lore.kernel.org/kvm/20260731160514.1101989-1-pbonzini@redhat.com/T/#u

- mm, drm: ensure .fault() does not have to be followed by .pfn_mkwrite() for write faults
  https://lore.kernel.org/kvm/20260731164341.1109827-1-pbonzini@redhat.com/

All three, together, make it possible to write drivers that use .fault()
and .pfn_mkwrite() callbacks for VM_IO|VM_PFNMAP regions, and that also
interact correctly with users of fixup_user_fault().

The problem is that if you define .pfn_mkwrite(), vma_set_page_prot()
clears the writable PTE bit in vma->vm_page_prot, at which point
the .fault() callback has no way to create a writable PTE.  Users of
fixup_user_fault() will then see a read-only PTE and have no clue that
the page needs a *second* fault to reach its final status.

fixup_user_fault() itself does not have a good way to notice this, because
vma->vm_page_prot is an opaque pgprot_t, so the fix needs to be somewhere
else.  Other preexisting functions, namely vmf_insert_page_mkwrite()
as well as vmf_insert_pfn_pmd(), suggest that this has to be the driver.
In fact, of the five vm_ops that use .pfn_mkwrite() together with .fault(),
three are in file systems and are not buggy: all of them ultimately end
up in dax_fault_iter(), which uses vmf_insert_page_mkwrite() to correctly
insert the PTE.

The two problematic implementations instead are both in drm code.  One, in
drm_gem_shmem_helper, was reported as a KVM regression; the other, in
vmwgfx, was found by inspection of .pfn_mkwrite() implementors.
Both of these use pfn-mapped regions, but there is nothing like a
vmf_insert_pfn_mkwrite() function that they could use; the first part of
this series thus adjusts mm.h to provide two new functions for this
usecase---vmf_insert_pfn_prot_mkwrite() and vmf_insert_pfn_mkwrite()---and
then teaches drm's two users of .pfn_mkwrite() to call them.

This however leaves another case buggy where fixup_user_fault() is preceded
by follow_pfnmap_start().  Most callers of follow_pfnmap_start(), seeing
it return 0 for a PFN that is mapped read-only, would not attempt to
call fixup_user_fault() on it, and thus the PTE would not be upgraded
to writable.

This is arguably a bug in... almost all the callers of follow_pfnmap_start(),
but fixing it is much better achieved with a small improvement to the API;
if follow_pfnmap_start() is told by the caller that it needs the memory
for a write, most callers are simplified because they were doing such a check
anyway and now just see -EFAULT.  They then proceed to call fixup_user_fault()
and everyone is happy.  This is done in patch 5.

To sum up:

- patches 1-3 introduce the new MM API, and use it in the DRM .fault()
  callbacks to install writable PTEs in response to write faults

- patch 4 is a preparatory fix in KVM, eliminating inconsistencies in the
  handling of !VM_READ and !VM_WRITE VMAs; these would return different
  error codes for a !VM_WRITE VMA depending on whether the PTE happens
  to be mapped (but with wrong permissions).  This needs to be here
  because the next patch would introduce even more inconsistencies.
  
- patch 5 moves the check for writable PTEs from follow_pfnmap_start()'s
  callers to the function itself

- finally, patch 6 is a KVM addendum that will have to wait until
  the next merge window; it removes yet another inconsistency in
  KVM's handling of !VM_WRITE but is technically userspace-visible,
  and therefore it shouldn't be included in stable kernel releases
  unlike the rest.


Thanks,

Paolo


Paolo Bonzini (6):
  mm: export vmf_insert_pfn_prot_mkwrite(), change variants to inline
  drm/shmem_helper: use vmf_insert_pfn_mkwrite()
  drm/ttm, drm/vmwgfx: directly create writable PTEs when mkwrite is in
    use
  kvm: apply VM_READ/VM_WRITE checks to all VMA types
  mm: pull writability check to follow_pfnmap_start()
  kvm: return -EFAULT for writes to !VM_WRITE IO mappings

 arch/s390/pci/pci_mmio.c                   |   2 +
 drivers/gpu/drm/drm_gem_shmem_helper.c     |  38 +++---
 drivers/gpu/drm/ttm/ttm_bo_vm.c            |   7 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_page_dirty.c |  42 +++---
 drivers/vfio/vfio_iommu_type1.c            |  17 ++-
 drivers/virt/acrn/mm.c                     |  10 +-
 include/linux/mm.h                         |  84 +++++++++++-
 mm/huge_memory.c                           |   2 +-
 mm/memory.c                                | 146 +++++++++++----------
 virt/kvm/kvm_main.c                        |  44 +++----
 10 files changed, 232 insertions(+), 160 deletions(-)

-- 
2.55.0


