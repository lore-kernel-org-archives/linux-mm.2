Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FE10FF8850
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 21:13:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02A0B6B0098; Fri, 24 Apr 2026 17:13:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1CE46B0099; Fri, 24 Apr 2026 17:13:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBD686B009B; Fri, 24 Apr 2026 17:13:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C886C6B0098
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 17:13:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9E07E140107
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:13:52 +0000 (UTC)
X-FDA: 84694701504.24.53E4B84
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf07.hostedemail.com (Postfix) with ESMTP id C5BBD40008
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 21:13:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kpWRpMsC;
	spf=pass (imf07.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777065230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eQ1ogQtji8N9fk/gCNEBKuaQlCDkrnlVpOUwUld6cXk=;
	b=4IU9XjmJUzpC6w9d2uaPAnLsyCIBCa0cZbVw0b66jOTTVhIj2esUf4xCNbK/rAsjuoCci+
	oNgvaYynXzJbauBJF+tkfzqc0sVWqeG2aTepnWRl6Y02ldFgj0cb+IolOj4iWyrNoLoHFc
	iOH6nfscwoyIBGzJDwMOSmj7pUfOp5Y=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kpWRpMsC;
	spf=pass (imf07.hostedemail.com: domain of elaidya225@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=elaidya225@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777065230; a=rsa-sha256;
	cv=none;
	b=G9rfnHYuH9MwswSGxeCeVZXYrGvtfR2Ch28/N0Ke19JsGqbImhVKx+tu8D5AkRLtqwE82f
	zc8ksv39QmQ9w3g9v88NAG14FEXZ2c4ju6fTmHKIAA+t6hIHtwrZuDNc4XtOlLUZD3mgoM
	EQOw15WAQAoF8HWMuKi6x9AAp69ucBE=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488a8ca4aadso113739515e9.3
        for <linux-mm@kvack.org>; Fri, 24 Apr 2026 14:13:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777065229; x=1777670029; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eQ1ogQtji8N9fk/gCNEBKuaQlCDkrnlVpOUwUld6cXk=;
        b=kpWRpMsCfvjkHDUoYbXwIQv6PhKUJ+WTeFxiz5h5bUejO9NwrQbphxK7gJo5JQyt9q
         Gtzi5IJtbMMTnvtXAteGCR41i+u6f4tH8O/k1rgfebIpNKlarFDVyp2g8plsXrG5s/6y
         24HrixsT65nkHVACEOjIPomSTaEdvIUzi7cO9mBIqIfotHeAnCENJ4JNje+fylbLX96I
         bYACX/2Qek4h229bYACcFuf41/bELkA5qCLSrzhJs1Dnalv4vnnPunhxtaEyc5lrggVV
         +hgZ7JkHdZvG6V/kM7k9efKPsjtYa13DsdPfp2eP+5qh+OfhHOf5aS7tEs7kuVwLp1DG
         B8QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777065229; x=1777670029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eQ1ogQtji8N9fk/gCNEBKuaQlCDkrnlVpOUwUld6cXk=;
        b=qSnYB91vn06W4muvQ6IoXEWM5dnj4ui9tMXk5HihnuNq/geap2Fr0xXILvBKzhdBFJ
         aGvVgDfv3lNVPFT9UC45s3DkfhELICMVje4VoRIGxodrrnb61W3QgdlyTqdOoM2tyIAY
         nI42b37lfz8L5zKpY8L0Xdnn6A/kH4Ifx1bzD1g8QNob3wJvdE7z3jRnR1b/YlhXB7AI
         Q9kI+3oR+CRZMAEWqeVrMK0WZiUWllmNCW1eiHvfzaQKVhzLs7T8AMSV9JYVTRVznA15
         ebwYI8nFAoRNmlX4w5s7YHczDnizj+Lv67Q2Sn2gp1xqTHSOVYUFXRvI/+W6MWVKtqXD
         kqHg==
X-Gm-Message-State: AOJu0YzqUyvOFPR4d/Kkwq6EA9X5adwa2L6BQRDK7lbNT2YRcPkesQiD
	kUgFP0Lq6zq/WEeZB/pSX45XjiVU2s1i3kVOZ4BVCOWxrq6cV3f8MfCx
X-Gm-Gg: AeBDievvQqtEoKoqLBV6OKNZZYhgsX3dpwFElP+OxLqQt8TtJCOc6klthX4BpAFQrDn
	30xRErYfijC+OxQa65WJBDyr/J6kOVyM+SqNX9ulY+VktWddBOKaqbZJSFRuaRiwz03O1SZoTCM
	kSwS8QQScrjm48Ze05GvPfnNS32ccwNOg1xS2irgvEpC1+0g+MQBbLR9CJ0/+qrWWXza+U5PrfG
	JX6Snkmkr8ZkbWd0mlgaR9s9Nsbv0/05t+FguVTB9EPOEvDbv2j5FaT9KwKhJrJ2GMYQTHfI3xT
	QiLZirVceq8gJe25b2W9eINSlPW8QzxJwNEn7hiswmowlOCR8PMvTO+ZrxE+a8jXNrHYyIkg17X
	8EZ6838oDjScFQGLPAAqAXvFZVREEYk5/52uXzkuf4yI7gKtj0TYT+5r+VRyV3KJUchU2G7ywyi
	GvXkMeQOVKp9IZ1bcPIGxpCkoxXWx9bA==
X-Received: by 2002:a05:600c:a107:b0:489:d1c:d468 with SMTP id 5b1f17b1804b1-4890d1cdaedmr283357005e9.31.1777065229276;
        Fri, 24 Apr 2026 14:13:49 -0700 (PDT)
Received: from fedora ([156.207.128.125])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4cb1176sm63845677f8f.3.2026.04.24.14.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2026 14:13:48 -0700 (PDT)
From: Ahmed Elaidy <elaidya225@gmail.com>
To: stable@vger.kernel.org
Cc: linux-mm@kvack.org,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com,
	avagin@gmail.com,
	Vlastimil Babka <vbabka@suse.cz>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Dev Jain <dev.jain@arm.com>,
	Jann Horn <jannh@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Lance Yang <lance.yang@linux.dev>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nico Pache <npache@redhat.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Ahmed Elaidy <elaidya225@gmail.com>
Subject: [PATCH v1 6/9] mm: set the VM_MAYBE_GUARD flag on guard region install
Date: Sat, 25 Apr 2026 00:12:40 +0300
Message-ID: <20260424211315.1072123-7-elaidya225@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424211315.1072123-1-elaidya225@gmail.com>
References: <20260424211315.1072123-1-elaidya225@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C5BBD40008
X-Stat-Signature: a6e5xurgkp38gyecy4nx7brud8x4qcex
X-HE-Tag: 1777065230-617695
X-HE-Meta: U2FsdGVkX1/XIVIJJJJRsj4xg/MTpbrBvJeqCOnK8nwl3s0h6eMR4k3ZTQfWWeblf42+SCbbe/a/6jsAPfinnpgRcYvGFoeSzEcAEl8O5UT2EK7vyHLXetHilaS5WJnCF4EN0MP2k9f5FygE5UWQ4wRqXYP9BGVoSYCroAMFozt8akpcgxj4VOxZHv74kzqyKIo9gMrzCQ+2yFcYhgervqqkhlmuM8kFtHnhg+3tOynVODcELtQ3kL8b93obIzgn59gIJf1L2DDi1S7n+P7I43QT+BnEsNe9PoP4u9w+myROcXyVX8HDr7IZhk4nNSFaKRtT5AQiIzqHb01SWq9V9RNf4g4hutzlN6EPQhEVm62xllI7wuLhHV+zrljYsn/sZf7rIFygGaEQrMDV1gBUc7XfdRJVO7QmgxXpd3bUna28fMNDkx2i9aKSlsjq8BFA23oYIqENdtGHe+RzgFS3JnI8KkRt+Amvs8POxfyQIwhcsvbIwUC6BWq5XzIlNCql37hIPQ8b8CQpAeCJXWX6Ho71m/doM5HXa1jlI9LLbnnemEoJ4j1CIU2f+PcoYsH9CbnmbjBPJvD5b8LoFQc4PXmMMKXiYyuIEbSq5z9XKFVYpgdgqYllvKWixzhkeJSYVWT9BmqsIx7XizYmludm0oem/zSXr8CXGjdGEmaihIzx/vtYaRVyfAJn/HmsptHw2yesS4O82BEBxKTzKZV6GMUjPnlXmMw88cxR3nwB5WwSEBKI9ulbT0Kte4vOU01NITOm2DgVeA0BlvAfiQ+ZxZFBKKboCh+X/0OlJl0//1NSgCdeXRNJ4SfBnJUniClbaTSSnjvpelW5S92GF51xGETtfXx8UqcIhzy7686uj7eq5dIfoIIo7EZE8KGC1XaHV6mMvSWVW8CY3ymqc4rr/WkcU+UGy30rnTafKOQmzY3JCLTtaCKWOyY4bOtcJXuIIm+JrQYEHJ95bxP+tCy
 bBJdoL97
 Mxi8lQ7gQUjqQ6o4EAZgvB5Y2d98zoRefB5E9aMmEDdjeHlnHXX9esPGE09vG3rMetLB70p2egJirpipdBLDRnim+C++yFnS88UzW81ICpDG0TZc/tRwUGsPClsu0YH9Zbc5LMf+UALmETleQ/OiERTem/ADqNAUrsERKbd+Mr5KU7vARYtPE1cOs5avGI27PujKCrbPlp55hjKZ8nmWG8K2A9/0hx2iTd1+21Uj11/AUMD9v6xlz3C8KoGWwHeiX1w1xNs8p2W2beHRJsjuQVME6aivZ2IjiqGbxyxiB5tnJnUN/8xW3BAwAVRj1Jg6szKydjqA3bk4hG5YU4h28zSpld7fzPaXZumm2E1SQyLL8jb7/tr0DejINOGY/+Fiu95WQWo7WEMZpV04uDndCO7SBgD2ZxVDXZSDhE5d/l/iyi8HbIxyNL1/6LeZapAStltqi7noOGq9QW7wZnnppIurIP8DaVcOmThiZgRvoJdKTCaFq+5hD1P0n3/bphP4snIpsm7+xpwuhyhbjRknpFQ/D2eyO16fdlo3nMYehQaFQMU/NNo7NsXuv3THkA5WanPeZzrF8zbORGF3YUQLsggnovXnU8Y20D5PZviqZT07xivERwY9mIRP2dUegAVcIzW24BCxMjNbyRtFXjhvs/Lj2wdJB+HK+OUJYOWoGpix16XqDysCUQVwY6DOt3bPYUsqPK/LDoPDS44XdijL1LBLb16Hl4IHhMn9iueQMJZ8gZaVn3QJU+jMxqhWRuSZdBweHPdTjsApQ3czlWmmffKRG1WZBoGJ6+pfoe9y8VTaqwdNLzPzXfaMh3KeTJIcPdypz8jYLLe0BtCqg0SjJo3S6K8qmG0H+ujBsvAK0RYUDMjdJkFgUVXuMYO/MmgZphFtb9oV59T808Nixk7gK0zsWXJ4JmI/XFoBNQxD4rZ6J5LkCXNozvjmj5FzNIvVLicsOm6XPofjMXOpQDWI2V9RegWkg
 FBHIG2/V
 D/JXgaqksMfC0sYP2y9C/4z7VGC+MVgta3fobVHRZqBKnBgCP3+0+JVeLlB6Ate9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Now we have established the VM_MAYBE_GUARD flag and added the capacity to
set it atomically, do so upon MADV_GUARD_INSTALL.

The places where this flag is used currently and matter are:

* VMA merge - performed under mmap/VMA write lock, therefore excluding
  racing writes.

* /proc/$pid/smaps - can race the write, however this isn't meaningful
  as the flag write is performed at the point of the guard region being
  established, and thus an smaps reader can't reasonably expect to avoid
  races.  Due to atomicity, a reader will observe either the flag being
  set or not.  Therefore consistency will be maintained.

In all other cases the flag being set is irrelevant and atomicity
guarantees other flags will be read correctly.

Note that non-atomic updates of unrelated flags do not cause an issue with
this flag being set atomically, as writes of other flags are performed
under mmap/VMA write lock, and these atomic writes are performed under
mmap/VMA read lock, which excludes the write, avoiding RMW races.

Note that we do not encounter issues with KCSAN by adjusting this flag
atomically, as we are only updating a single bit in the flag bitmap and
therefore we do not need to annotate these changes.

We intentionally set this flag in advance of actually updating the page
tables, to ensure that any racing atomic read of this flag will only
return false prior to page tables being updated, to allow for
serialisation via page table locks.

Note that we set vma->anon_vma for anonymous mappings.  This is because
the expectation for anonymous mappings is that an anon_vma is established
should they possess any page table mappings.  This is also consistent with
what we were doing prior to this patch (unconditionally setting anon_vma
on guard region installation).

We also need to update retract_page_tables() to ensure that madvise(...,
MADV_COLLAPSE) doesn't incorrectly collapse file-backed ranges contain
guard regions.

This was previously guarded by anon_vma being set to catch MAP_PRIVATE
cases, but the introduction of VM_MAYBE_GUARD necessitates that we check
this flag instead.

We utilise vma_flag_test_atomic() to do so - we first perform an
optimistic check, then after the PTE page table lock is held, we can check
again safely, as upon guard marker install the flag is set atomically
prior to the page table lock being taken to actually apply it.

So if the initial check fails either:

* Page table retraction acquires page table lock prior to VM_MAYBE_GUARD
  being set - guard marker installation will be blocked until page table
  retraction is complete.

OR:

* Guard marker installation acquires page table lock after setting
  VM_MAYBE_GUARD, which raced and didn't pick this up in the initial
  optimistic check, blocking page table retraction until the guard regions
  are installed - the second VM_MAYBE_GUARD check will prevent page table
  retraction.

Either way we're safe.

We refactor the retraction checks into a single
file_backed_vma_is_retractable(), there doesn't seem to be any reason that
the checks were separated as before.

Note that VM_MAYBE_GUARD being set atomically remains correct as
vma_needs_copy() is invoked with the mmap and VMA write locks held,
excluding any race with madvise_guard_install().

Link: https://lkml.kernel.org/r/e9e9ce95b6ac17497de7f60fc110c7dd9e489e8d.1763460113.git.lorenzo.stoakes@oracle.com
Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
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
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Zi Yan <ziy@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
(cherry picked from commit 49e14dabed7a294427588d4b315f57fbfcab9990)
Signed-off-by: Ahmed Elaidy <elaidya225@gmail.com>
---
 mm/khugepaged.c | 71 ++++++++++++++++++++++++++++++++-----------------
 mm/madvise.c    | 22 +++++++++------
 2 files changed, 61 insertions(+), 32 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index abe54f0043c7..3dcd884c844e 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1715,6 +1715,43 @@ int collapse_pte_mapped_thp(struct mm_struct *mm, unsigned long addr,
 	return result;
 }
 
+/* Can we retract page tables for this file-backed VMA? */
+static bool file_backed_vma_is_retractable(struct vm_area_struct *vma)
+{
+	/*
+	 * Check vma->anon_vma to exclude MAP_PRIVATE mappings that
+	 * got written to. These VMAs are likely not worth removing
+	 * page tables from, as PMD-mapping is likely to be split later.
+	 */
+	if (READ_ONCE(vma->anon_vma))
+		return false;
+
+	/*
+	 * When a vma is registered with uffd-wp, we cannot recycle
+	 * the page table because there may be pte markers installed.
+	 * Other vmas can still have the same file mapped hugely, but
+	 * skip this one: it will always be mapped in small page size
+	 * for uffd-wp registered ranges.
+	 */
+	if (userfaultfd_wp(vma))
+		return false;
+
+	/*
+	 * If the VMA contains guard regions then we can't collapse it.
+	 *
+	 * This is set atomically on guard marker installation under mmap/VMA
+	 * read lock, and here we may not hold any VMA or mmap lock at all.
+	 *
+	 * This is therefore serialised on the PTE page table lock, which is
+	 * obtained on guard region installation after the flag is set, so this
+	 * check being performed under this lock excludes races.
+	 */
+	if (vma_flag_test_atomic(vma, VM_MAYBE_GUARD_BIT))
+		return false;
+
+	return true;
+}
+
 static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 {
 	struct vm_area_struct *vma;
@@ -1729,14 +1766,6 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 		spinlock_t *ptl;
 		bool success = false;
 
-		/*
-		 * Check vma->anon_vma to exclude MAP_PRIVATE mappings that
-		 * got written to. These VMAs are likely not worth removing
-		 * page tables from, as PMD-mapping is likely to be split later.
-		 */
-		if (READ_ONCE(vma->anon_vma))
-			continue;
-
 		addr = vma->vm_start + ((pgoff - vma->vm_pgoff) << PAGE_SHIFT);
 		if (addr & ~HPAGE_PMD_MASK ||
 		    vma->vm_end < addr + HPAGE_PMD_SIZE)
@@ -1748,14 +1777,8 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 
 		if (hpage_collapse_test_exit(mm))
 			continue;
-		/*
-		 * When a vma is registered with uffd-wp, we cannot recycle
-		 * the page table because there may be pte markers installed.
-		 * Other vmas can still have the same file mapped hugely, but
-		 * skip this one: it will always be mapped in small page size
-		 * for uffd-wp registered ranges.
-		 */
-		if (userfaultfd_wp(vma))
+
+		if (!file_backed_vma_is_retractable(vma))
 			continue;
 
 		/* PTEs were notified when unmapped; but now for the PMD? */
@@ -1782,15 +1805,15 @@ static void retract_page_tables(struct address_space *mapping, pgoff_t pgoff)
 			spin_lock_nested(ptl, SINGLE_DEPTH_NESTING);
 
 		/*
-		 * Huge page lock is still held, so normally the page table
-		 * must remain empty; and we have already skipped anon_vma
-		 * and userfaultfd_wp() vmas.  But since the mmap_lock is not
-		 * held, it is still possible for a racing userfaultfd_ioctl()
-		 * to have inserted ptes or markers.  Now that we hold ptlock,
-		 * repeating the anon_vma check protects from one category,
-		 * and repeating the userfaultfd_wp() check from another.
+		 * Huge page lock is still held, so normally the page table must
+		 * remain empty; and we have already skipped anon_vma and
+		 * userfaultfd_wp() vmas.  But since the mmap_lock is not held,
+		 * it is still possible for a racing userfaultfd_ioctl() or
+		 * madvise() to have inserted ptes or markers.  Now that we hold
+		 * ptlock, repeating the retractable checks protects us from
+		 * races against the prior checks.
 		 */
-		if (likely(!vma->anon_vma && !userfaultfd_wp(vma))) {
+		if (likely(file_backed_vma_is_retractable(vma))) {
 			pgt_pmd = pmdp_collapse_flush(vma, addr, pmd);
 			pmdp_get_lockless_sync();
 			success = true;
diff --git a/mm/madvise.c b/mm/madvise.c
index 0b3280752bfb..5dbe40be7c65 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -1141,15 +1141,21 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
 		return -EINVAL;
 
 	/*
-	 * If we install guard markers, then the range is no longer
-	 * empty from a page table perspective and therefore it's
-	 * appropriate to have an anon_vma.
-	 *
-	 * This ensures that on fork, we copy page tables correctly.
+	 * Set atomically under read lock. All pertinent readers will need to
+	 * acquire an mmap/VMA write lock to read it. All remaining readers may
+	 * or may not see the flag set, but we don't care.
+	 */
+	vma_flag_set_atomic(vma, VM_MAYBE_GUARD_BIT);
+
+	/*
+	 * If anonymous and we are establishing page tables the VMA ought to
+	 * have an anon_vma associated with it.
 	 */
-	err = anon_vma_prepare(vma);
-	if (err)
-		return err;
+	if (vma_is_anonymous(vma)) {
+		err = anon_vma_prepare(vma);
+		if (err)
+			return err;
+	}
 
 	/*
 	 * Optimistically try to install the guard marker pages first. If any
-- 
2.53.0


