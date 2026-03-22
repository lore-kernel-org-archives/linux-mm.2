Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9300FFC72AB
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 05:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B857D6B0088; Sun, 22 Mar 2026 01:43:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B355C6B0089; Sun, 22 Mar 2026 01:43:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A24576B008A; Sun, 22 Mar 2026 01:43:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8D13F6B0088
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 01:43:16 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 146688C3B4
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 05:43:16 +0000 (UTC)
X-FDA: 84572605992.18.4D778C9
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6947D180002
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 05:43:14 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SPPD9sba;
	spf=pass (imf24.hostedemail.com: domain of 3cIG_aQYKCMU352pymrzzrwp.nzxwty58-xxv6lnv.z2r@flex--surenb.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3cIG_aQYKCMU352pymrzzrwp.nzxwty58-xxv6lnv.z2r@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774158194;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vcHDXdXeHcBh7JcXxd/NIeUk+f66988A9WXmJh1lMtA=;
	b=Gur9jmQYI+Xi49VtgaHqVmlxOm6eRCl0766P+ehNlWU/igJ4enWiL/n3dJx3l2q3k8rsvl
	vJfDufcwqlvQhMdDWvVOA9o40jU/shec2EVhOhQ/jcxIyP3MxDCAaFb/V/kCPSjrw8ubF6
	sBnSyDvoSZ0TKSV2Czg3NJmYJ6XNnGI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SPPD9sba;
	spf=pass (imf24.hostedemail.com: domain of 3cIG_aQYKCMU352pymrzzrwp.nzxwty58-xxv6lnv.z2r@flex--surenb.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3cIG_aQYKCMU352pymrzzrwp.nzxwty58-xxv6lnv.z2r@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774158194; a=rsa-sha256;
	cv=none;
	b=j9yVyu682oWkH9rTX9w1BUq/iPofoB5VDxHFzXucVhu9aABUkAYrG32A3bHwJbpEUiU/bT
	gIlSJy8g2zpBrXe6HkZgaTvofMmfJ/tK1K3CPWmgqGFLEnypxnGcDsWz/QcCaVCxxHo+h2
	wbE+JYk4+hMLrU9KnWF8U/6Q8hSzoKo=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-1275c6fc58aso1267110c88.0
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 22:43:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774158193; x=1774762993; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vcHDXdXeHcBh7JcXxd/NIeUk+f66988A9WXmJh1lMtA=;
        b=SPPD9sbaINmvaIYwAd73jxaAzU+9njtJ3aIW40kd3TfjQrlPNYxrHFuqfu4kGJPUsY
         abVqDEd+MKmEv8C16D+TdT9bkIJAqKWIBcKK9+lPB3T7TX3pOdFv4N7I+EfNBnlT3kmG
         2NLWylA03+XRkxAYBfhstekKJz3hUu5yNOdaCh/SbHsr9ggpHTt1+oIeWWfiDDR/n+nA
         UucElYcFL1eb3Gu5wZtii3zd1OpupaU613EaDkI/gMgpZFNbPEt4ZIx/kxOZj3NTx4sY
         HodkCdDW7TmMvDc1XjEZ7+HEI0+5LG+3hIhv220sMEDAORzTBs0oHUxjINA7cQRVtofS
         NkBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774158193; x=1774762993;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vcHDXdXeHcBh7JcXxd/NIeUk+f66988A9WXmJh1lMtA=;
        b=lipNY6rY/l+XgqymQt16CS/PXkdEjOWKZKY0HT1fi9Xeesi5VIaQ5vC0l/7q8qnM2j
         eQVCNYhAWlFYIbshXfyVC2MO7uE/H6MQ/57Ugy3yuBg75kf8JHggYeAT+Z+I8m4abGXi
         YAPHMqgK0VOW8QTgd573J1HV5qqfe8rLkYDbzUtrLxOwBCKoAO6Up7HlcFEhqtI6rR7S
         ebcRjSSISoDCjQQ5ywTR2Dz9oRv84tqZGnz/QAzcN+s3IMzKpO/w1sGatxxabhntTjC1
         WJck4DJJaSoSUI0KextucU4pVux7laZHqnnkS9x0TclAXVlgyxjq5uf4yUvlohLK980E
         zDcg==
X-Forwarded-Encrypted: i=1; AJvYcCVZrnLDwqdWVzSAGHLGS42rKVal8edjjkIYToQlftFnx3O3QjDUHe26v7SRFin5TYcyYoVKDkqgAg==@kvack.org
X-Gm-Message-State: AOJu0Ywpnxdsv+nb0Zyi3EX0Uyt4SvAowIWONWtG/VVraF6UxuyW2LEL
	E1dZYjU0VP2Rliy4QEz6xVtbtNta31pznPCP8fblWPf+7xVK5OTPcbDrUrlZuo2ZPF7jxYZgDr/
	/xmqTGA==
X-Received: from dly25-n1.prod.google.com ([2002:a05:701b:2059:10b0:12a:7703:c328])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:490:b0:12a:6a64:81ef
 with SMTP id a92af1059eb24-12a7267d891mr3739492c88.9.1774158192658; Sat, 21
 Mar 2026 22:43:12 -0700 (PDT)
Date: Sat, 21 Mar 2026 22:43:04 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260322054309.898214-1-surenb@google.com>
Subject: [PATCH v4 0/4] Use killable vma write locking in most places
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	jannh@google.com, rppt@kernel.org, mhocko@suse.com, pfalcato@suse.de, 
	kees@kernel.org, maddy@linux.ibm.com, npiggin@gmail.com, mpe@ellerman.id.au, 
	chleroy@kernel.org, borntraeger@linux.ibm.com, frankja@linux.ibm.com, 
	imbrenda@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com, 
	agordeev@linux.ibm.com, svens@linux.ibm.com, gerald.schaefer@linux.ibm.com, 
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6947D180002
X-Stat-Signature: 3wnmurpfz3wk9gfd64oygh1qzii4wfek
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1774158194-14146
X-HE-Meta: U2FsdGVkX1+yDagsqVcC//K1toVqiB5yCUOm9ACt4MVGDhNx1ycAqL3OiG5EwqaxWL08UlWk4ERAXfdR2g4liNJUymNBk54QdsV78XuKAGSQd5EhNOs1rtlnBXTzZq5qza7pNop1q9SI7Vg1azXOmC8npXSP/bVieLpY3DFAGtzGECDYG840Cq8XOtFQ+V/arIonJ54hFizikGeVvZsOfo/wzWGtVLJ92xZCXlhmC/N8mBmLsZxkGJOlsR7W6YPUX937ETpQIkaO1d+GLDTHDOwwa6c6ew3jbhN0FUIukpNBBhvjAJf5dwCf/8cL0JK9NJySQkdBJ7vt8ajUggRs3zIL3pN6yh+Fjz4mtNSoi1lOVR0g5tilCSGYbbHP3OZZaz/xWInfShINmU3Ravt4ORGakuAfoxFIScG28BxHYH2oE6+JJc+rd90LTqnuccScaoC8RjfJsJtcF7od5+tMCpa6P0TN2URnFSviO0UeOMGi/3MXZB31JJqxM2pxJ0blUGXYAsMVCyU6bApEROPSK/iDti8YvILMFEE+jlIbXBdDm0ayinEdjgDk4Ou/fEp8U7cegFbYkmUpRMkec0eVWFdc50GjLNwjplA5aKWhJzRHpCwYWrqAS+r9fLuawSDNMgy5W3tysUawV1igIn3CYKq5q+6UQJ1DOnK2kLWhMy/uVymj3lbXlKdqMJIMSyWA7eZi1aCHZBzyWV+6kYyl7oaRJBQYIxI3ncXPB1MFuCQYvbdmf9Zz81IUFA2CO/ILmcyi3iGcIvTwvBuyJh87btTr6J1sALqCRh5UW0VMHC1bTh4Vqh3dSBa165k5qE1WMcMSy2EBb3bSNNTVG9KPH7yApiOD72AZqS6TFaDpLRux4wem7KPz+5CVOI52nSx0gfgYSbSNTGv06rrNx1oNkdc0x9SpKBFLFrItzGidHYibWbNZKYemEsH0PIeONiTarPGszt/yhmPBdh2blGf
 FkkqplBa
 +sEURf+cfdhQCMVpXnyAy2lrWAQqwGPKxqmdI5gKURIPCpFAPuVi1wCsA2usm8UG1DVLZymJqNZwln6ZVgary6/+UdlcqJYWArjnldZzQYzU+akTsH5Vbn/dflu/047Pg3+9WDi/ZpAowliNA/7wiuOEFbwCY+VZlZzxK6H369jSeqWIEVNHW1mBr9W8dX1NniIeMG9Gd/Ak+b6Y+oOoeeVW5Phw7+vHAwOhri6+xU1STKKGB11zS+JXnNee5GGMWAd1P9lNQuT/Zqh+RpiQ75I6HeMIl9XeOCHkrfLJiBpy/F5+mLTswp9SYa7/4kCNJ9sa6BwhoGoXvs6btCeCORukCa0Srnjn6xbZ7XVpmnZ+Br1S7OCLcdit+G4yL8w/GNlqIFgSBml6IwRKBitriYvbuGa+Lq50g4azqi566F8f9jAskIAzO2Uz9EZTExSO4oT4RJgEJw3DVqJUzac+P9exbiuHo57bM6uSb63vz/CoKyU82aeieKn2wRUjTGmWQZdfz7v1JyFBijlSNR7cQNnUW4j2pROrhSDv55FTAXp6aFCtOQJVL54KB4mpOHrA/MNLuC6iHZwKyQfWyPXJeAO0jN4VIeBoALFN+1tx+UZyA2fQliop0Vsev7IVPUgZtxUxfk7d49shpcJiDt494ZbFXsvZ7i9N0+bwUNTABP1ClS2vZqpJch2cvgVqLa4s/eW54YHjYuq1J1i+wTL7t4KAjmQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now that we have vma_start_write_killable() we can replace most of the
vma_start_write() calls with it, improving reaction time to the kill
signal.

There are several places which are left untouched by this patchset:

1. free_pgtables() because function should free page tables even if a
fatal signal is pending.

2. userfaultd code, where some paths calling vma_start_write() can
handle EINTR and some can't without a deeper code refactoring.

3. mpol_rebind_mm() which is used by cpusset controller for migrations
and operates on a remote mm. Incomplete operations here would result
in an inconsistent cgroup state.

4. vm_flags_{set|mod|clear} require refactoring that involves moving
vma_start_write() out of these functions and replacing it with
vma_assert_write_locked(), then callers of these functions should
lock the vma themselves using vma_start_write_killable() whenever
possible.

A cleanup patch is added in the beginning to make later changes more
readable. The second patch contains most of the changes. The third patch
is a small error handling fixup. The last patch contains the changes
associated with process_vma_walk_lock() error handling.

Changes since v3 [1]:
- rebased over mm-unstable
- added Reviewed-by, per Liam R. Howlett and Lorenzo Stoakes
- moved locking before vma_iter_prealloc in vma_shrink and in vma_link,
per Liam R. Howlett
- added a separate jump label for vma lock failure case in do_brk_flags(),
per Liam R. Howlett
- fixed cpusset -> cpuset, per Lorenzo Stoakes
- added comments explaining vma_start_write moves, per Lorenzo Stoakes
- amended patch description with explanation why vma_start_write moves
are safe, per Lorenzo Stoakes
- added comments listing EINTR as a new possible error code,
per Lorenzo Stoakes
- moved comments in mlock_fixup() and apply_mlockall_flags() to more
appropriate places, per Lorenzo Stoakes
- replaced check for EINTR with fatal_signal_pending() with a comment why
it is safe, per Lorenzo Stoakes
- fixed error check in mprotect_fixup(), per Lorenzo Stoakes
- moved vma_start_write_killable() before allocations inside __split_vma()
with a clarifying comment
- changed mmap_region() to set err for each failing case,
per Lorenzo Stoakes
- changed label names in expand_upwards() and expand_downwards(),
per Lorenzo Stoakes
- changed "if (err < 0)" to "if (err)" for consistency,
per Lorenzo Stoakes
- separated error checking fix for s390 into its own patch,
per Lorenzo Stoakes
- removed special handling for EINTR, per Lorenzo Stoakes
- dropped changes trying to propagate EINTR during vma merge,
per Lorenzo Stoakes

[1] https://lore.kernel.org/all/20260226070609.3072570-1-surenb@google.com/

Suren Baghdasaryan (4):
  mm/vma: cleanup error handling path in vma_expand()
  mm: replace vma_start_write() with vma_start_write_killable()
  KVM: s390: avoid kvm_s390_handle_pv() error overwrite
  mm: use vma_start_write_killable() in process_vma_walk_lock()

 arch/powerpc/kvm/book3s_hv_uvmem.c |   5 +-
 arch/s390/kvm/kvm-s390.c           |   2 +
 fs/proc/task_mmu.c                 |   5 +-
 mm/khugepaged.c                    |   5 +-
 mm/madvise.c                       |   4 +-
 mm/memory.c                        |   2 +
 mm/mempolicy.c                     |  13 ++-
 mm/mlock.c                         |  28 ++++--
 mm/mprotect.c                      |   5 +-
 mm/mremap.c                        |   4 +-
 mm/pagewalk.c                      |  20 +++--
 mm/vma.c                           | 133 +++++++++++++++++++++--------
 mm/vma_exec.c                      |   6 +-
 13 files changed, 173 insertions(+), 59 deletions(-)


base-commit: 8c65073d94c8b7cc3170de31af38edc9f5d96f0e
-- 
2.53.0.1018.g2bb0e51243-goog


