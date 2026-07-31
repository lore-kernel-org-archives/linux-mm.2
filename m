Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE6A5C5516F
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 18:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0C196B00A0; Fri, 31 Jul 2026 14:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BD826B00A5; Fri, 31 Jul 2026 14:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D39A6B00A6; Fri, 31 Jul 2026 14:03:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 585016B00A0
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:03:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B0FA31A050F
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:43:57 +0000 (UTC)
X-FDA: 85049643714.12.B76CDD3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6672C40002
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 16:43:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WiS9eWdS;
	spf=pass (imf12.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785516235;
	b=npXgklJOItrHYcYjZUxrHyhJtBU4PyrJ6UHPAZeNhtfYpHrA4V0z1/5JfKhe8c9zIhCEop
	cAUqP9yqzySMl18kzrhjw5zLfy39oNpJZklN/RXBDTyagQvHxmJD6iJ0Tk8dPs58lNV8F5
	++dnkqdEkvFGc/kLHKwTYCxVPVrQux4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=WiS9eWdS;
	spf=pass (imf12.hostedemail.com: domain of pbonzini@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=pbonzini@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785516235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ltyqZW5ZfqrwkkeZqLpjTnozgkU+0DHxMfwj6ZzMkA=;
	b=wsfcvfI+W87n/fMRJtWlbKMu5Ojo6eAQ1ab+CYH/BrC/NYeHRfFkLFS0q9FyEgC9kzv5P1
	RJ1g45GABivCB3ZnUjLKyh5H76PFPv8OUVw3o4Dr9aDjsq6rfMf+8dIIEZcMrfgtRl4m8h
	YMNHGjMvosmqGlve29NFRnp/FpkYzG8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785516234;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+ltyqZW5ZfqrwkkeZqLpjTnozgkU+0DHxMfwj6ZzMkA=;
	b=WiS9eWdSwc0QNa6ZLnVe3dQ9falefzhxXCtiqsEM6PB5aGTemNjQVkZ+48HOMxPS8oUKFZ
	pfPzB+sQH817lF4kQueN9tvojOYjmyhfd7ccPWgZ5tCKZj+LEuAJAw8Swsz5t8iRbpHhAc
	3If3bIpkXrMbfc1wdXxEr95Q79wmbBc=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-321-7ugGF7zHMtCkOwYL2z-pMA-1; Fri, 31 Jul 2026 12:43:52 -0400
X-MC-Unique: 7ugGF7zHMtCkOwYL2z-pMA-1
X-Mimecast-MFC-AGG-ID: 7ugGF7zHMtCkOwYL2z-pMA_1785516230
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-c15fc5a1b7eso90052866b.1
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 09:43:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785516230; x=1786121030;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=+ltyqZW5ZfqrwkkeZqLpjTnozgkU+0DHxMfwj6ZzMkA=;
        b=XwYfsH9qK4iftPpTQGYMTauwBKmof4uqy6JeoMw/C7tTtQ/TMREy7kBlslkvpDxJxQ
         +VxyfrDoXwkQcqDnde82S+vo4uKXNSzWRvqONepgqCSbkJzWhS0ESSNQa/4RUek2mOuv
         jcZOmvOTd84KC1Ev8/jcX693NpgJkWWGo6MmjsuQ1Ju+0a3npuy/qI014mOfbxy6vMbu
         Xits/3zDKaeCrhf/odd9brPtrny21bFvBTTVHdyxFaK96tGCYuOPxPo8y82T/bqaO37c
         fW3QQ4Ke9BHGyiRjg71XUlsL+CMlFKywLyMluJZc4YMWCbiz2u5Bl8TCithM+kVrC7es
         ZoMQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpro+BElWjWPL9FZjgyJcVUjLM+Y//G3YWDWOwUpUfsr6CfmXwjNfX5j+/N2oSSV6D8Uj4A/Dqhcg==@kvack.org
X-Gm-Message-State: AOJu0YzD51y3DERlCrcP+djWK5geBjk9BwYNNvoxzVHWWAMlrefLhgGk
	RXcVvbheXPJjkvw0Hjstwi10d1IzhHvfGhjKi8Gt5ubOMzBsh3xdgGeZqc7NlI/Ar03YO4WpgMY
	/vtOqht2UqxjPXvudiXopUEM4nAhfB8jcklNw+1Fgd3d8B4kql2mM
X-Gm-Gg: AR+sD12PQT34JERNKoBo3B+Cb4jzN7JM01BQo+hVPR0I9IaGy+6s5152FZynnYXZoLl
	EKGrDNUpXhpjiX5PhLJ3oicoYN/Da2vr100eeFhnM5i1d4bdTi1G428zZh3jdjCrIdTM/BIAmhZ
	TSK4eHsNbci2wFT7oMsl7IursjpMlFFZ6GippGXa29oM6iKzSdzQA2KV3GbWCX857kUoYznwsPV
	jNpWgjHO02wgI69a71FYsBAx5wsuCtxxGwZM1fWVO4F1d6uTHhpmPKNgfG387Zs48KyW//vanSF
	983Axmgj0XXKTUdP72aWgDM3ZeG5pishXVyXhljJC9lBiri8SqKaoErQ1jgLfRgNFeEnwcNPblk
	/BGW2S4U3KT3P9oQPndCJhDTUB9qrQYQAA+q7qq3LJTcGM/Sdxg2tnWuLllBvB/O2Mr84mSy7kJ
	ghldk=
X-Received: by 2002:a17:907:d1f:b0:c1f:17f6:2a74 with SMTP id a640c23a62f3a-c1fe7fc540fmr36348966b.9.1785516229931;
        Fri, 31 Jul 2026 09:43:49 -0700 (PDT)
X-Received: by 2002:a17:907:d1f:b0:c1f:17f6:2a74 with SMTP id a640c23a62f3a-c1fe7fc540fmr36346066b.9.1785516229473;
        Fri, 31 Jul 2026 09:43:49 -0700 (PDT)
Received: from [192.168.10.48] ([151.95.34.92])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fd4537761sm215223766b.52.2026.07.31.09.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 09:43:48 -0700 (PDT)
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Sergio Lopez <slp@redhat.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	bcm-kernel-feedback-list@broadcom.com,
	dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org
Subject: [PATCH RFT 2/3] drm/shmem_helper: use vmf_insert_pfn_mkwrite()
Date: Fri, 31 Jul 2026 18:43:40 +0200
Message-ID: <20260731164341.1109827-3-pbonzini@redhat.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731164341.1109827-1-pbonzini@redhat.com>
References: <20260731164341.1109827-1-pbonzini@redhat.com>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: _NxcMCICm1Y0Izz0h0gMo49GmmacfbPMVQ4f1PV9tPQ_1785516230
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6672C40002
X-Stat-Signature: u86dh81pkmjtyntt4iuctj5jmjj11pnu
X-Rspam-User: 
X-HE-Tag: 1785516235-754023
X-HE-Meta: U2FsdGVkX18Kljr7zDj76ytRnL0I4IBEuy30S5V+njW/06Orn4rkDVotw4Z+MztI0rpuVCZUk8Ubn79LcDrM0Gc4qPv9+L1CzgLyZEQ7A4JJO1wHyKcchZzBV5XcgiJYk6cMqGEQCruaVNsFvDjocsKV2i9x5zu9Q0SGMT5gHibOBaPt8bCZLEbfByNZKEY+Dh0K5TnUZcv1/EQfeUjX0nT1QKcW7ejxdt1gGN2ISfzgJt1dm4p9rzz+VrYrz37kEaHamOb8NIRoNViRwdQUCetTf+Rkes6Oe0yrb3Gdi8om3qEoAkmR0gIp1jyGFcOkkVe3JdgtNeHkaaZyFg78QZbalKUvBYq693CZrPTJunqo1VTOSoWEpMhgh/zVuBr26XYQk6OoFaFF1ZxWviAz0cDXqiubjTmrOJ0OjWkCTDX2+d08qPGIf2DHBllLFsUd1jzVVZIQPGzY2s1VApg/avUcPyr6KN93Y3OsQEmuYGYdeZfhvphpwwyCqw8fnHb9gncQBvAqCVJhyNrcPYXp6mYMWaKL8e3LkT0LP6484yzmrd6tFWkp3CZ/SFBDTPkDPkzOtEoBF+fHcz3MI3MRpm7wUotWhdbHX86bus0uNAf6KRV1NtJLOmBTd/81VXtHBK2Yc8kLSVeYTDAhCyqTVnUfBwmnciu1a4MsJWhZEPHt0LFeOxgnb0TyXxXDgGDrfh/UJHOZH7cG0fU7bDzwcwgWmFbfK9en+rZ4opoTyk24CRREnsE+p6HmCqAst0RwRML709Nhl6JOTIQFTyNFGan5qt9pP4nTa9uPxog3FTbzm3IO2nWU7c2txEf/xDYyJaZwXFVmk9w6o+jTm+UyqIuOMzAC1NEPrZpw2RzvkEk6fZVNSO55rJtgu6vzHs4Jq5ii9KeTkp69mxykASwAAgKn6w4dK0trdpoYgr6Ipnl235zH/cDM3hJ+DPKBjA4sBxYlXCFrsZ7QSzKs3SZ
 d1akCB/t
 JzyT4EGn4FL1ntLRRav00F7lSzU5lD9yA3A3e8WLN7DdVRbEetUHUYlR0DLEjNeIG4kZTF8gXaZxAKCviqLUFLsRFOGiQpBM8Gyqmtcj1CNrcTxuxTZ+jHVAvFBHEF6Cy061o0LgXOqYHwzlanv/IFIjNwZtcTJT+vl26yxLbBqo8sVoDzkfzuwyo8j85Spr181WKAT1s6OSRscFBWuESFwcqAiQBgUjrtr9tMeR9Cfj82jxtLiid2ogTyxEmFMNPW8DUGl6UDZ2kU8lw7l12RHaRPl0dy0Dk8T+e46mZ+4avL3wEu2ZgdXc+PJAvKjhanAcSfLkCwTNZxYlRBaRy/Fmnqw3nd5MEAZiGFhNZGQXXuD5SGh2Us8TB6Mfu2UvLxPaPmqtmx+RZf/M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This ensures that KVM or VFIO correctly see a writable PTE when
they request one.  Otherwise, a guest write to an unpopulated
PTE from a mapping backed by a DRM GEM BO triggers a VM exit
with EFAULT.

The code actually is simpler, because the same logic already
applied to the hugepage mapping case using vmf_insert_pfn_pmd().

Reported-by: Sergio Lopez <slp@redhat.com>
Link: https://lore.kernel.org/kvm/20260729072044.25796-1-slp@redhat.com/
Fixes: 28e3918179aa ("drm/gem-shmem: Track folio accessed/dirty status in mmap")
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/gpu/drm/drm_gem_shmem_helper.c | 38 ++++++++++++++------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm_gem_shmem_helper.c
index c989459eb215..33a14f558276 100644
--- a/drivers/gpu/drm/drm_gem_shmem_helper.c
+++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
@@ -589,11 +589,25 @@ static void drm_gem_shmem_record_mkwrite(struct vm_fault *vmf)
 	folio_mark_dirty(page_folio(shmem->pages[page_offset]));
 }
 
+/*
+ * Because the vm_ops have a .pfn_mkwrite() callback, vma_set_page_prot()
+ * has cleared the write bit from vma->vm_page_prot.  vmf_insert_pfn()
+ * would install a read-only entry even for a write fault, relying on a
+ * second fault to reach .pfn_mkwrite() and upgrade it, but that second
+ * fault never happens for fixup_user_fault() callers that directly
+ * walk the page tables with follow_pfnmap_start().  To ensure that
+ * they don't see the read-only entry, pass FAULT_FLAG_WRITE info down
+ * to install a writable entry right away.  Because .pfn_mkwrite() is
+ * not invoked, record the write afterwards.
+ */
 static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
 				 unsigned long pfn)
 {
+	bool write = vmf->flags & FAULT_FLAG_WRITE;
+	vm_fault_t ret = VM_FAULT_FALLBACK;
+
 	if (!order) {
-		return vmf_insert_pfn(vmf->vma, vmf->address, pfn);
+		ret = vmf_insert_pfn_mkwrite(vmf->vma, vmf->address, pfn, write);
 #ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
 	} else if (order == PMD_ORDER) {
 		unsigned long paddr = pfn << PAGE_SHIFT;
@@ -601,27 +615,15 @@ static vm_fault_t try_insert_pfn(struct vm_fault *vmf, unsigned int order,
 
 		if (aligned &&
 		    folio_test_pmd_mappable(page_folio(pfn_to_page(pfn)))) {
-			vm_fault_t ret;
-
 			pfn &= PMD_MASK >> PAGE_SHIFT;
-
-			/* Unlike PTEs which are automatically upgraded to
-			 * writeable entries, the PMD upgrades go through
-			 * .huge_fault(). Make sure we pass the "write" info
-			 * along in that case.
-			 * This also means we have to record the write fault
-			 * here, instead of in .pfn_mkwrite().
-			 */
-			ret = vmf_insert_pfn_pmd(vmf, pfn,
-						 vmf->flags & FAULT_FLAG_WRITE);
-			if (ret == VM_FAULT_NOPAGE && (vmf->flags & FAULT_FLAG_WRITE))
-				drm_gem_shmem_record_mkwrite(vmf);
-
-			return ret;
+			ret = vmf_insert_pfn_pmd(vmf, pfn, write);
 		}
 #endif
 	}
-	return VM_FAULT_FALLBACK;
+
+	if (ret == VM_FAULT_NOPAGE && write)
+		drm_gem_shmem_record_mkwrite(vmf);
+	return ret;
 }
 
 static vm_fault_t drm_gem_shmem_any_fault(struct vm_fault *vmf, unsigned int order)
-- 
2.55.0


