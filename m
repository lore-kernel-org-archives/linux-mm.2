Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23394FC5905
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 07:06:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B2906B008A; Thu, 26 Feb 2026 02:06:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 160426B008C; Thu, 26 Feb 2026 02:06:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 041956B0095; Thu, 26 Feb 2026 02:06:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E4AD56B008A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 02:06:16 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9838FBC430
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:06:16 +0000 (UTC)
X-FDA: 84485723952.01.57345A5
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf22.hostedemail.com (Postfix) with ESMTP id E1FDDC000E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 07:06:14 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=E8385kAw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 35fCfaQYKCJoMOL8H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--surenb.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=35fCfaQYKCJoMOL8H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--surenb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772089575; a=rsa-sha256;
	cv=none;
	b=s9iguOvcnbvBiVLJaGqwa0d4u3z9AEtp3djq2TvcrhniO0meFiRhah8etC15UOqCLKmRPb
	nl98GvfpNHijuHvhnINdCS4agSJxd3OmXlxazvOBh3t+1H24ySXx/sRFdRrsWI7e7/yc90
	2S1xIWHe9zlsmk+G/IlKWJmPtobC6Jw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=E8385kAw;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf22.hostedemail.com: domain of 35fCfaQYKCJoMOL8H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--surenb.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=35fCfaQYKCJoMOL8H5AIIAF8.6IGFCHOR-GGEP46E.ILA@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772089575;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=vucVmOFSxssu4W4+hD04IB0isnzzlwVXoGbpC2l+3Iw=;
	b=H7qxH4HuC2sTNjHLIEk0xSa81lo+Fh0MptHVti45xM4pUq3ejgjkr4bJ7XdfpKvqkESYxi
	RJ/a7C5SwfeLjKRdDaNMcfVIDBTH3JjjWklD84bpeRZVpuDcwi/16YmlclrI9KieAWtW0L
	nCOgiivUn22igjAdLvmMrlqFh6QKKwI=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-1276e71652fso920490c88.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772089573; x=1772694373; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vucVmOFSxssu4W4+hD04IB0isnzzlwVXoGbpC2l+3Iw=;
        b=E8385kAwoB3++msPxMV8+3sFbW+GpqfohR3ThV8TR/WNkglifU0LTBBemcGwDKYF8v
         kdCzPsIz5fl5MHtcWZEmPY1kgbISDSnqlqJ89y4lOmj2PMRsVUDp+BaOPYE4rqJJMvOk
         HD3woIZeUdDj2gerZffdmJiTlrwikGjZdU1L1wG0UwqHrL1UxHz0agxiF5DeGf6X18o7
         E+N1AghNi1oL4WAtSzaIwiml5we+io/8WOMamARKlngkFR/5HRqy+FKBDlB3ygen+vFI
         +prMMksKZpfU3oqeUJNjgYmp/UySxDUZd6KKZuwlr3LPRfxLZX+VEx2KijOfhaPaPJEw
         q6LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772089573; x=1772694373;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vucVmOFSxssu4W4+hD04IB0isnzzlwVXoGbpC2l+3Iw=;
        b=st5ljviJSlf4WD8iAhr0Mpl0RxyGM/zoPFRlsq2VzqXxpDcny2OhovT5xUfvvuJuKL
         gapVjM1ViRIqAuggV/aeensUpfaWzm/DXo0mZz7LNQpH8J5lrUZGsbzLTI16J3n6vG15
         zPzTm7+ya/t/ABvm8GbRqAiEYNBYnhVNBC8Kn2PRJxXecuJIoiqLKTXzqGv3sKLqHK3k
         7S/4TCwtauamPwHSk3EJFj3KsYr5RK37uZUBnrIj4894yEWJWTDdMiN8ggnfX9oGsRSD
         03Ikrh6cVdpMk8ZG6hhUDqld4fmE/EaNN1/Hqx4Lnrty9jx9DXBFhuD5KWwowk43lKzF
         VOow==
X-Forwarded-Encrypted: i=1; AJvYcCVRkhHUHKeiFpx4SH+VQwdez65GIs0FgopWskGBLrmaceBAVm+hdwFV/7M5MFqXP3uWhyf6TzRATw==@kvack.org
X-Gm-Message-State: AOJu0YzXyqebU5oK4Kwqi8rpyrNOT0PrgrVL4ne/L6fRExl4VCMM6sG9
	SdQletIKgr2zK9Ahpp9OEoGIFwklHIMN34ltrUh6KyWz7DiHGzsoaFUgk3sxfTr5ypc9X2YJgko
	kG5mWig==
X-Received: from dlam21-n1.prod.google.com ([2002:a05:701b:2095:10b0:127:89b6:8d2a])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:60aa:b0:127:3b16:bf4f
 with SMTP id a92af1059eb24-127869c9ac6mr1332481c88.40.1772089573227; Wed, 25
 Feb 2026 23:06:13 -0800 (PST)
Date: Wed, 25 Feb 2026 23:06:06 -0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260226070609.3072570-1-surenb@google.com>
Subject: [PATCH v3 0/3] Use killable vma write locking in most places
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E1FDDC000E
X-Stat-Signature: i5wbtakdfigx55k54arq5sju7fdq68we
X-HE-Tag: 1772089574-351928
X-HE-Meta: U2FsdGVkX19lr9E95FB7PXrx0/3bFbwF8m5iBY/1Ok9aGZNfBYEB6AYHQk/kiObHD7hTKOn0F3eh8nWyta5jWaQyUkpEbcnUvdaZzf1ZoxCp8kdGcMMKgWm7lVbkcOqIUQp1lo//TLQSvuhdqRc97TzpBv4RfM3/0tP9dy3afJz+KL8SGYvlI+JkcBU/WCfU62GIYNRzVcQ2Bjv9JI4cTfLvIGYFhITo7uMW73q1H9pkh7kxNLSXb/G6hD0cFR4kUZvvukzFOx5vLlOshVFMMTme2e9ZnEXR0cgy9mMwQ+010FQRcF3x0xjnAGj9iRlV/sUnR/Xz0ATVDgbHDJYeAR/G3W+ll56scqRd8pKVQWRizAhlkcDd2kgoVZO3PqsLbh5OK6oDsz8EJxdjvClQB1GZIRQ6s5t42SlLSNblZgG3oB2JDEcuuD52ZjhebGi/nZwjDcXpAPhx2dpGDoZizas/szeShlsdq0476RTaNG7YaKDugGBh/nTt7KDfzvlFBvIUoAuU1Pga3oQDCwAF0kUgLztUfWv9o3LaYmw2hUVwXgDLpN9UUZqHMS1XRLpohrSgKeuzWY8TbvcLaSRNavAXKfqejShsAPwhKt1ZSbrJRZeKGZZqvdDIIfpymnvKk+pwDupLDjpMpg+Y/uPqvUCvG4KlwmoydkUE2X48COqL8y8hKYRgr+aAqB0BrnH7ewVOE8+fsYg7aKTM84BXhDlW2Q3zJQubCIm1yV+uEAa0qHrCgKbu6RYRClCqGK0PCZHmnRLbBoSB3meOrd3sY7KqghL5xcRhwh9LtikNbD5D7687VSQmj33uulRKr0NUMQiVCyYD0hwFlkhem3xi7BgabEkyvWqooEv3AyBzSKgP4auR5EG1/DkcrTfv+fHU2bIOvg0oYoWDTd8OIeT6+sdZB9RAeV3URdWnyZ6lhAc6FzyN7BorSa9gCgBFkeQrrLl3L9F7uhdO15FG9Nm
 +7SOfK8L
 C3CxJ1bpRoePKBoW+Uk3/rdkwssqt+qMPJpkqY5d4I+oJqbvQyJMizcz/Yg4pFB1y2RQ1GdGYde9bfHb9uAZTq84NqJ17yhHo0RLYQI0w1H/V1idz7d1UijoboBpRUsp31FlCnWwG6pW8uXewi2sQ1G/3Q+CLyHdi2kAWZ/ld/w9u6NpDTnJCJWQWPELqiGMtl0EVihJzukBr7zO7TWWkG2NFyCwaiu9vZLKiqDWAUnBOgt+t8sEBDcgKDhj/qx1HP5I7DPbo4L0SHjTy7sigEi+JoTk23PVhGFuXluhUNOMjbJLa6Sb3JdnJtZKdGONDstvE2i5t1/IeHOXKk1jelGxU4oG41Ou2Y4+k1VMd5si3rEyYSJghrDP8XrXrIdH1sK57JacdkuawcDRcS4IAOq0ED9YAIWBd7oojyx/thDbTOb/hBG6dBRRv0tNV5lwy60bE8m4Es+4VsrzLN4hR5BlOVuHvil6A/hOwwqWbZl42fPMcz03BFr8zsyD+4XA2uES/AayX1LEcIi3x246ViMA4PyOTJfQwPXpGhQX6kdhHapjm1p1YSSOGMr65XF+4RxbWnxsoOwEUl0jT1ok+pPpvtJxBxiu201Q2+2oLG+b2sr0PA6nx8ru9jDSbGvk/744dx5cc/jsN+3rnAKJQAhq3WOMgjCbjycGa9E6Ra1FXLsXvEhFZufmnX6nHRWnPlGD1mbSUGyFcK4I3QodbdwRiAg==
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
readable. The second patch contains most of the changes and the last
patch contains the changes associated with process_vma_walk_lock()
error handling.

Changes since v2 [1]:
- rebased over mm-unstable, per Matthew Wilcox;
- removed mpol_rebind_mm() changes since the function operates on a
remote mm and incomplete operation can leave unrelated process in an
inconsistent state;
- moved vma_start_write_killable() inside set_mempolicy_home_node() to
avoid locking extra vmas, per Liam R. Howlett
- moved vma_start_write_killable() inside __mmap_new_vma() to lock the
vma right after it's allocation, per Liam R. Howlett
- introduced VMA_MERGE_ERROR_INTR to add EINTR handling for vma_modify()
- changed do_mbind() error handling for avoid EINTR overrides;
- changed migrate_to_node() error handling for avoid EINTR overrides;
- added EINTR handling in queue_pages_range();
- fixed clear_refs_write() error handling which previous verstion broke
by skipping some of the cleanup logic;

[1] https://lore.kernel.org/all/20260217163250.2326001-1-surenb@google.com/

Suren Baghdasaryan (3):
  mm/vma: cleanup error handling path in vma_expand()
  mm: replace vma_start_write() with vma_start_write_killable()
  mm: use vma_start_write_killable() in process_vma_walk_lock()

 arch/powerpc/kvm/book3s_hv_uvmem.c |   5 +-
 arch/s390/kvm/kvm-s390.c           |   2 +-
 fs/proc/task_mmu.c                 |   5 +-
 mm/khugepaged.c                    |   5 +-
 mm/madvise.c                       |   4 +-
 mm/memory.c                        |   2 +
 mm/mempolicy.c                     |  22 +++--
 mm/mlock.c                         |  21 +++--
 mm/mprotect.c                      |   4 +-
 mm/mremap.c                        |   4 +-
 mm/pagewalk.c                      |  20 +++--
 mm/vma.c                           | 127 ++++++++++++++++++++---------
 mm/vma.h                           |   6 ++
 mm/vma_exec.c                      |   6 +-
 14 files changed, 167 insertions(+), 66 deletions(-)


base-commit: 6de23f81a5e08be8fbf5e8d7e9febc72a5b5f27f
-- 
2.53.0.414.gf7e9f6c205-goog


