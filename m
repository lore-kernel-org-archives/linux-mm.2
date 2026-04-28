Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14B21FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:55:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7631A6B0088; Tue, 28 Apr 2026 09:55:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ED856B0095; Tue, 28 Apr 2026 09:55:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B4746B0096; Tue, 28 Apr 2026 09:55:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 43C246B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:55:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id F2F0C1A0186
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:55:51 +0000 (UTC)
X-FDA: 84708112902.01.88C47AD
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1A402160009
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:55:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cKeQDrEp;
	spf=pass (imf08.hostedemail.com: domain of enderaoelyther@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=enderaoelyther@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777384550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4y6+tDkXnIMmu/nIfFw+lmemKG8+IlpqyDeYlXSN2FQ=;
	b=El+W19tCW4v/1CEqNXvq/fQhV3xfOMcEEq6+IsJU36ihTsj29p0tBlXR8idWkTw/wr9pDA
	YjmWCgSoy56xOTq6iMNxikrRii+5UvgkPlFekUkCudCK5ts7oyPDmZyd4grpmz2qP0XVFC
	fi5WcVFCIVlc9CediGGDc0bh4/15N4o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=cKeQDrEp;
	spf=pass (imf08.hostedemail.com: domain of enderaoelyther@gmail.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=enderaoelyther@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777384550; a=rsa-sha256;
	cv=none;
	b=t2UYiwV+m/FX8oTvcJgAEcXcMLEr0OLmT2EZQx0q+jTILjw+iQ4QNCZI86AAKfgv11BfUQ
	ElDKMBgy5C/j1nKe2k1Lt/amLwxJ28TSe/ohVH2pyjIAW6ZKNNJmOhGjKqUuMlFpPEJ/nG
	fHX+zzsKGBlGufztwl25dHvwWVi2YyY=
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-35da01fc0baso7213192a91.2
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 06:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777384548; x=1777989348; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4y6+tDkXnIMmu/nIfFw+lmemKG8+IlpqyDeYlXSN2FQ=;
        b=cKeQDrEpGwbz2RuhUQlwSoOhuR9mQUi+ZnCuTy6RH7fJfQs+0JUihtBjpPQugRzEBQ
         Jac/meHt/AnrrhuFIjW+pLwHS3XNdhA20hEMz43cTrHcaX1PKG9lS5AavQ4wzzwr6chT
         FGT68CEBBMdokkv3lsoW96FVSRO+pi+lZjjhiTX34bu8iqvVioMk9nIxY7U6OT/Yse/l
         xHD4868+ZKbslX5VZin9O7ic3XCzcX1nGGyct0A1CwwEBlb+3ENqGn/iNy16R9NBp52r
         mJkp9tlUCeNkaN+SjwCrHMsyAVNME/m9kSte6+E9UZomCrX2BtnbCzNPmuz7vnZ0nEHI
         NIVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777384548; x=1777989348;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4y6+tDkXnIMmu/nIfFw+lmemKG8+IlpqyDeYlXSN2FQ=;
        b=UcvdK/MU1HNyVQ98fsmFcUvEqWzF7Odx636d84v51NuLPgVdGfUV4CiUmeKWfS2IBV
         usAXYwd4wLGohcq1M5je3y6ZwcH01r8gtXBXbx62yAEznViGx4pgMbF4Rb64t0yT8xkw
         ZKcqSS1cB5N1kwdoYwxSWiWhUjAOOoxUpHgiCaMdk8BwyH3AYR4Nwo24XK37tq9pzfiH
         xyqSBxDPHjzZU9cS30MRUv7wqd3McNDdTHEm6Z3m9LqQZgG/iiYLFzm7cOxcJQsdKpnP
         Z0dPXZ1yf24DF72MfN3oCmWpUsdfWw5Fq/e9m7c5rq6dpsOES5WR2k9kpIhK+8nC60jU
         nwdg==
X-Gm-Message-State: AOJu0Yz/CISDL/b7k1QzRw8eKnM7P5hZrpNYcZh62UdPeDcRnzvnQsEp
	o48fVhpI3HbMJGKffrubAWGuzS49hTbG7rmpJ/Ff6J89gca/r3apmqvKaU3zIOniySd82gJ8
X-Gm-Gg: AeBDietgRrxKGhNOl+vh83Fqv52kT/JUckOLHOxVbm1/w0zoXNbUNGQMbts2EKzFZra
	ZA58KY94FJnb0w/aslvyIF09jm/Ux1hkcjl7BQdcodOWsYnbAfVmiOucKMz4XdvXofvybyc/A6b
	z9mU8lTqyRp82p5JrcC2/WVoxVP1MRBAw3IjNucflkx60gR9Nw7xSUz0ASGcRx1BexAHVnbNYt9
	ppoIDXvw/hXWRWc0rDp+6H6WJpg1Oe11npY9t28EliFylzrh1wPeZoFOheg1xEJ/FBSbyb38ieI
	ptt4QSVKdScOUfRWLZEI7A/Imo/siN1Qtq3Hl+nwxjQnRHZbtlRqehKQgI6zu4XvWBqiPA193uC
	zle3P6P3JvuLpoY+GJS8sSK8hYI//dT2+sYXHbpkgBqtnm3NcTe21ydf9q4hxc/EiaDFx0wFsfO
	KxfE5AOwViJyoMABYJyoYxo1+5/QpRSyrrFBs+pX5N54mDgoTUT1v4po4+d8tSaY0mfpOvfM0r
X-Received: by 2002:a17:90b:1a92:b0:35f:bae8:3531 with SMTP id 98e67ed59e1d1-3649207802emr3242142a91.25.1777384548307;
        Tue, 28 Apr 2026 06:55:48 -0700 (PDT)
Received: from KRHW1CJW23.bytedance.net ([203.208.189.12])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3649003578csm3106188a91.5.2026.04.28.06.55.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 28 Apr 2026 06:55:47 -0700 (PDT)
From: Zhao Li <enderaoelyther@gmail.com>
To: linux-mm@kvack.org
Cc: Zhao Li <enderaoelyther@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	linux-kernel@vger.kernel.org
Subject: [RFC] mm/hugetlb: min_hpages unwind corrupts reservation accounting
Date: Tue, 28 Apr 2026 21:55:41 +0800
Message-ID: <20260428135540.31428-2-enderaoelyther@gmail.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3ex3pep7sy9zq6sqh47fpy94wwyjkaps
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1A402160009
X-Rspam-User: 
X-HE-Tag: 1777384549-365772
X-HE-Meta: U2FsdGVkX1/hHEhu9VA5MAEtjIMzLPFPRqriQxvkYFraM56AIf44UFQLjkL7uvLOm1p7Unm+P3WQVf+ebwFRqBDi6ke+Lqozenrtre4B6ChUNUhfKsDa3jshbO7yN464/Pqx9jvcJaRMQYb6UBEBpZuU9mtdC10+/WFlfHlo/drPlRp6Ka9QUv/Rbvwx9m5UlDql/Of0lMSsG0EMk/cjGpmNq88cm+/XdsYka4/27KQkrEGoHN/upcO9kzT3MSRJocwqpyssIqtfP+FpZ+6vlLGwchgmNf1yiLFYAMQf8GXvoICBNehohv/wuHwMrHWq0CV6qH59dh7LgZzXDBeSWcJwhTFRZ0SrgEv7NaSqcxPO1cTMNcsj95/2xK4WHJV9LxBjUvhFAAf2BW4jlVmx3WkixRA2IEG3h8idEvOKPDukWijTCce7THayxm37YBtUAkyT/VyA4ISA4Rv7UTUkl+PpjjVx76pDpCJgqNRfnvd7bTlGsSBNlRXJ6aq3j3ISgoG81hREBwI4ThcN0m1FIlyXlbJwoGGEfG6ib9JCSl2ZI2PzbXS2LYJgP9SaCgPKWMyDht+T67gSfmsAX+SHhoQnyTxbcu+c3+x2+h4DEnrrxw3n+40MtJ++UhAawMCtGFv2d5aBkOi35IElbwOghwckyhfMvDgSN1/YH9GD/V6csEpmH25PA0p+Y56HJh1isUKPxKqHt5dVKZP6V/h/e55i9JfhL9BG1dt8yIPJ+Hi5ZLezrGUT8yPU01NkiNp1pG9cj23/IB29iFTA/ZtJr5CB6VLrMhcXPwCAUeMBhoeERWkoXw8Lx1MvmIffkt+JPO39hvf4YRf7xleVfshMsNkoGSUfecKMkmNivGwFxoieHQvsSzvwinleBdaAsipAOLhde7yfAnKQ7k1vr++Np0YJ4ywSQoiIKN67HhmLI+unOIRH06ytw0QLzwTohcog2tWSQL8F0bNf/8qekiW
 JVWtnVhd
 yJXyY3AnPVBxx00XGF/E2DPKWCz7VvTSemVg71ml6UNxjHEFez4cY7h2hS1s1hhtmULWRWT78V2zJepjoXIIX/AbMQeyCy68agNdHkmkyXksHdfU2E81BZCnEFX+EKgSJBZFC0c6GQ/A68DDBNq6XVb1vdRNnKR4TKfEe+HXcpka7Dt7bAvhO+zvukmA0NkgMtmBrBtPVLdvrLzKpQsTk9Mye5erARNDblaanWfqbst9scySPa+TjXyA948guXQCCR/hZWhrOzkMfRf3qxbH5T7e6NK/Wpcq1FVKar8ff2H9A7ywfNyd7QjvOX8NkuE1r1bq35Sru6mU1J89rVSSGdBGO8lGRSnY+j3AQDR9ok/2s9gMjOFzdkdtByMYNBbBGZBhj1CjXr6Md+B5MJ0pUi8Iv1+XNtCaYtdRESu9K127aSlxQAPzuHbLO0A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

While narrowing a separately-posted v3 patch ("mm/hugetlb: restore
subpool used_hpages on alloc_hugetlb_folio() cgroup-charge failure",
hereafter "the v3 patch"), I traced a broader accounting issue on
subpools that have both max_hpages and min_hpages set.  The v3 patch
intentionally avoids that quadrant.

Problem
-------

For min_hpages subpools, HugeTLB reservation state is split across:

- subpool->used_hpages / subpool->rsv_hpages, under spool->lock
- h->resv_huge_pages, under hugetlb_lock

Some callers first do a speculative hugepage_subpool_get_pages() and
only later know whether the operation will commit.  If the operation
fails, they undo only the speculative used_hpages bump.

That is fine in isolation, but it composes badly with a racing
hugepage_subpool_put_pages() on the same min_hpages subpool.

One concrete sequence is:

1. Subpool state starts at:
      max_hpages = 2, min_hpages = 1
      used_hpages = 1, rsv_hpages = 0
      h->resv_huge_pages still carries the subpool's min_hpages backing

2. A speculative caller does hugepage_subpool_get_pages(spool, 1) on the
   above-min path:
      used_hpages: 1 -> 2
      rsv_hpages: 0
      no change to h->resv_huge_pages

3. Before that speculative slot is unwound or committed, a racing
   hugepage_subpool_put_pages(spool, 1) from unreserve/free sees
   used_hpages == 2, drops it to 1, and does not restore rsv_hpages
   because used_hpages is not below min_hpages.

4. The caller of hugepage_subpool_put_pages() then drops one global
   reservation via hugetlb_acct_memory(h, -1).

At that point the subpool's permanent min_hpages backing has effectively
been consumed by a transient speculative used_hpages slot.

If the speculative path later undoes only used_hpages, the state can
become:

      used_hpages = 0
      rsv_hpages = 0

with the subpool minimum no longer backed globally.

Later, when the subpool is released and subpool_is_free() becomes true,
unlock_or_release_subpool() drops min_hpages from h->resv_huge_pages
again.  That second drop can wrap the unsigned reservation counter.

Why this is separate from the v3 patch
--------------------------------------

The v3 patch only decrements used_hpages directly for max-only
subpools, where min_hpages == -1 and hugepage_subpool_put_pages()
cannot restore rsv_hpages.  It intentionally leaves min_hpages subpools
unchanged.

The reason is that the broader min_hpages issue already exists in the
older hugetlb_reserve_pages() failure cleanup, so I did not want to
extend the same pattern into alloc_hugetlb_folio().

Reproducer
----------

I first isolated the race with a debug-only `msleep(1000)` widen after
`hugepage_subpool_get_pages()` on the above-min path.  More importantly,
I then reproduced it under QEMU on a **clean** Linux v7.1-rc1 tree
(`254f49634ee16a731174d2ae34bc50bd5f45e731`) with a userspace-only
stress harness and no kernel instrumentation.

Setup:

- `mount -t hugetlbfs -o pagesize=2M,size=4M,min_size=2M nodev /mnt/htlb`
  (`max_hpages = 2`, `min_hpages = 1`)
- Mapping A pre-creates one file-backed reservation on that subpool,
  bringing the live state to:
      spool->used_hpages = 1
      spool->rsv_hpages = 0
      h->resv_huge_pages = 1
- A separate anonymous `MAP_HUGETLB` fault consumes one real hugepage.
- `/proc/sys/vm/nr_hugepages` is then shrunk from 2 to 1 so mapping B's
  hugetlbfs `mmap()` will fail with `-ENOMEM` after taking the
  speculative subpool slot.
- The userspace harness polls hugetlbfs `statfs().f_bfree` and uses
  `f_bfree == 0` as the synchronization point between B's failed
  reserve path and A's release on the same subpool.  No kernel
  modification is needed for that alignment.

Race:

1. Thread B enters `hugetlb_reserve_pages(chg=1)` and takes the
   above-min speculative slot.
2. Userspace polls hugetlbfs `statfs().f_bfree` until that speculative
   slot is visible at the mount level (`f_bfree == 0`), then unmaps
   mapping A on the same subpool.
3. Mapping A's close/unreserve path drops one global reservation while
   B still owns only a speculative `used_hpages` slot.
4. Thread B then unwinds only its speculative slot via the existing
   `out_put_pages` cleanup.
5. `umount /mnt/htlb` releases the subpool, and
   `unlock_or_release_subpool()` subtracts `min_hpages` from
   `h->resv_huge_pages` again.

Observed clean-kernel hits:

- run 1: `HIT iter=1026 resv_after=0 resv_umount=18446744073709551615`
- run 2: `HIT iter=22   resv_after=0 resv_umount=18446744073709551615`

Here `resv_after=0` is already the wrong live state before `umount`:
the subpool baseline is still `min_hpages = 1`, so
`/sys/kernel/mm/hugepages/hugepages-2048kB/resv_hugepages` should still
reflect one reserved hugepage at that point.  The wrapped value was then
visible by reading the same sysfs file after the umount.

A follow-up probe variant adds a pre-umount snapshot of every
externally-visible counter on hit.  Three back-to-back debug-widened
runs all observed identical pre-umount state:

  resv_hugepages          (sysfs)        = 0   (baseline=1 expected)
  free_hugepages          (sysfs)        = 0
  HugePages_Rsvd          (/proc/meminfo) = 0
  statfs(mnt).f_bfree                    = 2

Note that `statfs` reports the subpool's view (max_hpages - used_hpages
= 2 - 0 = 2 free at subpool layer), while sysfs reports the global
hstate view (h->free_huge_pages = 0).  Readers of these layers see
counter values that disagree with each other and with the actual
reservation state.  Post-umount, the `resv_hugepages` value wraps to
ULONG_MAX (`18446744073709551615`).  That wrapped value reaches the
per-hstate sysfs `resv_hugepages` file for this hugepage size class.
On configurations where this hstate is the default hstate, the same
value also reaches `/proc/meminfo`'s `HugePages_Rsvd`.

I can post the userspace-only harness, the pre-umount probe variant,
and the earlier debug-trace patch as follow-up material if that would
help review.

So this is no longer just a theoretical concern in alloc_hugetlb_folio()
review.  The broader issue already exists today on the older
hugetlb_reserve_pages() path.

Downstream sinks (static-trace, kept to the minimum needed for review)
----------------------------------------------------------------------

`h->resv_huge_pages` is per-`struct hstate`, shared across mounts and
subpools using the same hugepage size.  Once it is corrupted, two
downstream consumers matter immediately:

- `available_huge_pages(h) = free - resv` (mm/hugetlb.c:1334) is a raw
  unsigned subtraction.  The `if (gbl_chg && !available_huge_pages(h))`
  gate at mm/hugetlb.c:1351 in dequeue_hugetlb_folio_vma() and the
  identical predicate at mm/hugetlb.c:1997 in dissolve_free_hugetlb_folio()
  both would pass when `resv > free`.  That would bypass reservation
  accounting on the `gbl_chg > 0` allocation path and on the dissolve
  path.
- /sys/kernel/mm/hugepages/hugepages-NkB/resv_hugepages
  (mm/hugetlb_sysfs.c:156) exports the raw per-hstate value directly.
  If this hstate is the default hstate, `/proc/meminfo`
  `HugePages_Rsvd` (mm/hugetlb.c:4566) exports the same raw value.

I have not yet empirically demonstrated cross-mount reservation theft,
gate bypass on a second mount, or a non-admin trigger path.  The sink
analysis above is static only and should be read that way.

What I am not claiming here
---------------------------

- I am not claiming the v3 patch introduces this broader issue.
- I am not claiming a final fix direction yet.

Ask
---

Does the above race description and reproduced state sequence look
correct?

If so, I will keep this separate from the v3 thread and package a
reproducer plus a broader min_hpages fix discussion around the existing
hugetlb_reserve_pages() path first.

Thanks,
Zhao

