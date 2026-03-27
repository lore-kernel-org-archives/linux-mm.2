Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C060210F286F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 20:55:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A86056B008C; Fri, 27 Mar 2026 16:55:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5E3F6B0095; Fri, 27 Mar 2026 16:55:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99B146B0096; Fri, 27 Mar 2026 16:55:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 87FCF6B008C
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:55:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C64E140F23
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:55:05 +0000 (UTC)
X-FDA: 84593047770.15.3A03FEE
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5F346100005
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 20:55:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VR7MAUwQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3pe7GaQYKCPImolYhVaiiafY.Wigfchor-ggepUWe.ila@flex--surenb.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3pe7GaQYKCPImolYhVaiiafY.Wigfchor-ggepUWe.ila@flex--surenb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774644903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xdmn94fDq5EabxgUHdZFE1PchWB5l0Hn00gGljt6mxc=;
	b=22HW4FK4ppUV1E6APzRsefA4okrH+BshY8H3QCjqC82sOn1KurexVWw8ikvH66fOIQ+Qar
	Py3ZQrFCOgzrjJq4rfTCZQWu5bCw7ROd+J85DB2r7u8kY/kC37jPgX4rEkPHHNmumlgQvN
	LAG+uj4P06qcrS8B+p5A6mkZptlDg7A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774644903; a=rsa-sha256;
	cv=none;
	b=CN3RH5842R/kn0y4EmyydAyllfKA1oIerwESa/8l9LY15hmT78yzUYAGJ3dP1lGfthdJit
	Th4LPrbfu+LCIxqo1aQAzQDQOQ7ie5T1q/OOCKifzvda4p4zl+cz9NEz0pQdo9hOtwiMcQ
	NB4s6LJMChgPsDlJcuuTwXw+90FP8rE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=VR7MAUwQ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3pe7GaQYKCPImolYhVaiiafY.Wigfchor-ggepUWe.ila@flex--surenb.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3pe7GaQYKCPImolYhVaiiafY.Wigfchor-ggepUWe.ila@flex--surenb.bounces.google.com
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2c1030ca85eso3557948eec.0
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 13:55:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774644902; x=1775249702; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=xdmn94fDq5EabxgUHdZFE1PchWB5l0Hn00gGljt6mxc=;
        b=VR7MAUwQulfNfyYy/vw5C5Hl5LPlzko2+o2I329lX5DLLnhBv2nfUeI57zEul7Zr3l
         DLHPjdVNrzX77O9mTp1nnxJ6tu7KA1VVYashLGVcc5F414RNYiojAB+tvAofvf8KXjJy
         xyuVYgCh230KpPBNmKY5tSKhADa8ev/esJlleNA+VoiF79Zu7AqiSjldeJXwrGNIuujT
         hbeLrnXGzBMODSThAu5lurL2RL1zF1bjectIzIYBdwBRxFScf5y6hM0hya0dxGv0K0Ce
         G36CJNXhPzCptDHUUCaZd6S2n8S85bJtQkNzaTtE2po5LiXYBKyjDMipzlsWu9PWXpAP
         Wlkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774644902; x=1775249702;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xdmn94fDq5EabxgUHdZFE1PchWB5l0Hn00gGljt6mxc=;
        b=VJRO0XIdfG3LKz7E4FjqDJ5pPC41BINoF5CofesM7C0oXn1YDzKNdDijj7M+TDQS9d
         lIF54a0mOGnijNLwjULjz+4ofh3CIJI3LXL8EVgS8BWcJk+xY53cysg22sV1ib2jojq1
         C6nY7IMzIqPJRKTCEpCnl7CWqojERzdrcgCBqZ8WNVX4MoE5+/X8KFmPXGVouW5ZtTSY
         kZ3iDUIHd36EEXHsfT1rX1SV30Mwm4lVBWIhaHHNHo48GKz2RUgreZ7S4fIlhtlMWL9t
         ZUon4HvDoRA5URyBieSNIzv9FOvBxXKNQREppB2qBmBXflJyCSpOgnK9+rTSXzFx7qGT
         Rneg==
X-Forwarded-Encrypted: i=1; AJvYcCWc3Uj1Vo0dj2b7HpC/eDnx+IyIULdQyMFUKDdbYsy6kgs5968DlD6XXU+WQnloaIUr22fDiaOg5g==@kvack.org
X-Gm-Message-State: AOJu0YxFjAXD2f8VrZThsRCSUTnzjKqcg7gwmF/4MywbH9cfaREwtJal
	p3s6xLE1UNy6phGS3oKqja2BxB20aH4rPjdPluxBBPX1C4NfV78O/Gx4TdrqAnsKJpeZ2TDsaid
	/dw7MaA==
X-Received: from dybse8.prod.google.com ([2002:a05:7301:4908:b0:2be:77bc:5c34])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:693c:3113:b0:2c0:cff4:b456
 with SMTP id 5a478bee46e88-2c185e5a4e2mr2359718eec.29.1774644901334; Fri, 27
 Mar 2026 13:55:01 -0700 (PDT)
Date: Fri, 27 Mar 2026 13:54:51 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.1018.g2bb0e51243-goog
Message-ID: <20260327205457.604224-1-surenb@google.com>
Subject: [PATCH v6 0/6] Use killable vma write locking in most places
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: willy@infradead.org, david@kernel.org, ziy@nvidia.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, ljs@kernel.org, baolin.wang@linux.alibaba.com, 
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
X-Rspamd-Queue-Id: 5F346100005
X-Stat-Signature: 33dbgrwmxdrsb1iu57tx7tuizeeggst6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774644903-229321
X-HE-Meta: U2FsdGVkX191PGojV9B52Hb2Vlq1tTHvhNERPcVe/wIohPiUr4D65bBnGH4SDVHei7m9psdbhTxX9jY+Ojcn3v/iCogxbCqIJGldEVw33aNz/z1xUdNqOeFnU/AsyeYQbI1795BiFm1FmtlTptO24amv5wo/5C8Faag2jLTT05l6eXutFpwWlPp+r+G6ZTdk0TNTRyt/TvXZOc/TgX36AQ0J9cxagqyevEHEfST2RCtR/ERV/7IQ0Sm+g1qz3Ak8CK1SmvFa6FZaX3b9A3kxQdOTjHJ07e4fKW2p57u9qBwzwCUlzsKN/XMPaaOhYHeILLHoFsjfJ9xe1WBmryj21Etn67sfu8+Htc68RKjEG8zT2hiGWPuvXfHwvVWgdVyP9L2UNM8yMJBTw7k4v3Awr0slV2lVdGjF/zgtkeJ29Tk9EBhyiErAiKQjcZ7i6SJ0RGju6Jwqk5ffUyudcPBRUXLL0CrlWb+zvnE852M1Zo/FphNX9toV0Km4IytNh/qiXAItnk6HbGPxNKtXSEysQlW9qFZKP7pqRxMrK7idY4WL2Q1VcDw8di76NmYuA/UxGqwxr5DS+xrq6reez2CSLTh14Lwf6lwitz4pffvan/DmAgFluh2xtuHJpSDBccu+YQviHZilpDaSWLEpQA3myIiBatip5DeuyDAwRz5fmxSsyrp9ZsuLZROkohqgfcVwA3wzWJgP8pFH3jjXLBG9HGS1oQuFfTqNn1/7YFhcHC7qQcZoFXm8k8t9M9J1Soj1baRgKjQ73gdgq16JEecpYrgnb+kG6c6G/I+ooTb+Si9roQte15pOhjvvn9PD2TsCYl0i+ZpwwgJjlPGmVIvydVbENCgyLV6ZFXan413U3EDOU04ERHPkrThzMTFNREwwEjX4Id193M7vfJjQF6p69/O7wfTQq7QiUBIULN4WGFzp4rRqKAzbu2Y2vme7dEBjMb5z5y04RJ9KcKrDlE+
 24yYVqZZ
 sUq2JapICcyz2/mtXdbyJM8j3hRqJLGtprpw/RWAABBgEPkStem/Nau31wHR3abDqEw1ja4dBB6WKcTF41M7SZQmSvZUDjc6UIHaxuaLRfq/UhllRab/rXI/u81ny0KQNyu8Hz+w6hLXw1Bvr6bTVEQoN0ExXZ68CaPS7YfmkKAZopzdItt7JmjW4Wq5/5+SQ0mXwOW2ZDp3iWdBNUND9UpgedAdd6eePkAiaProCG2YbRz/dqiKDhtpp4cOxKo3f+zlbjk6L30M+zpcpLCyQfSAguem3LCyrx5y93ZdCyK9FylCjE659YBMjpY/K4ZVogwYXvNZJ5080ignctcdl3I5gI6kfH6HMI7FK8EvFcDPImBG3b7yFnzybaZXmK0OvVXXwtliD2XsINu9yI1Cq3dGGznEhHopNQtquYgoq+0y9wsHdLNEt2CoXUXm228clD7BaNdhzQoTQf1wivPBBXsUNrk8LWoB6dN3LztKWzeULp+FkEidh6HyEPxLDVsamzCKB1YSWS10EkxUmJAvuolSjx4KGaia+o9PwWrc8dLz5Micx9KlHfDkhQCs6p3MGial7ZbFiBzd5A65C4CEtBS6MwlTStFcgKYQKfX43385hiEiuBZdEN/5hlbl5BzQIUd8I6TBwBRk0RzjdkUWN/OEEDrLDE4c1a5LINxw7vCq2k4ug8mw3Q3BNPHBdQXnyWi9areg0RLqlBlQexBpMVhEGiw==
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

Changes since v5 [1]:
- Added Reviewed-by for unchanged patches, per Lorenzo Stoakes

Patch#2:
- Fixed locked_vm counter if mlock_vma_pages_range() fails in
mlock_fixup(), per Sashiko
- Avoid VMA re-locking in madvise_update_vma(), mprotect_fixup() and
mseal_apply() when vma_modify_XXX creates a new VMA as it will already be
locked. This prevents the possibility of incomplete operation if signal
happens after a successful vma_modify_XXX modified the vma tree,
per Sashiko
- Removed obsolete comment in madvise_update_vma() and mprotect_fixup()

Patch#4:
- Added clarifying comment for vma_start_write_killable() when locking a
detached VMA
- Override VMA_MERGE_NOMERGE in vma_expand() to prevent callers from
falling back to a new VMA allocation, per Sashiko
- Added a note in the changelog about temporary workaround of using
ENOMEM to propagate the error in vma_merge_existing_range() and
vma_expand()

Patch#5:
- Added fatal_signal_pending() check in do_mbind() to detect
queue_pages_range() failures due to a pendig fatal signal, per Sashiko

[1] https://lore.kernel.org/all/20260326080836.695207-1-surenb@google.com/

Suren Baghdasaryan (6):
  mm/vma: cleanup error handling path in vma_expand()
  mm: use vma_start_write_killable() in mm syscalls
  mm/khugepaged: use vma_start_write_killable() in collapse_huge_page()
  mm/vma: use vma_start_write_killable() in vma operations
  mm: use vma_start_write_killable() in process_vma_walk_lock()
  KVM: PPC: use vma_start_write_killable() in
    kvmppc_memslot_page_merge()

 arch/powerpc/kvm/book3s_hv_uvmem.c |   5 +-
 fs/proc/task_mmu.c                 |  12 +--
 mm/khugepaged.c                    |   5 +-
 mm/madvise.c                       |  13 ++-
 mm/memory.c                        |   2 +
 mm/mempolicy.c                     |  21 +++-
 mm/mlock.c                         |  30 ++++--
 mm/mprotect.c                      |  25 +++--
 mm/mremap.c                        |   8 +-
 mm/mseal.c                         |  24 ++++-
 mm/pagewalk.c                      |  22 ++--
 mm/vma.c                           | 162 ++++++++++++++++++++++-------
 mm/vma_exec.c                      |   6 +-
 13 files changed, 251 insertions(+), 84 deletions(-)


base-commit: e53c9040ab1b738dd2c83b57558f141902caaf4f
-- 
2.53.0.1018.g2bb0e51243-goog


