Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C23D4C982D2
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 06:42:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FB236B008A; Fri, 18 Sep 2026 02:42:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AAF06B0093; Fri, 18 Sep 2026 02:42:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69AC66B0095; Fri, 18 Sep 2026 02:42:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 339DB6B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:42:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A07914058E
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:42:47 +0000 (UTC)
X-FDA: 85225939974.15.762C923
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9F51E20003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:42:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QlVO2c6s;
	spf=pass (imf13.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789713765;
	b=c/BAESEYgqs1d1A6FcuR9uNNlQRBBxPGUjlWdyYiXLJvFOKrXGyAC2IywnESW+wpqxY2yd
	cahmrMjdcPSRwQ+OgDByoYiGwejIEglahiwXLgj0VL8YdCznrQoPuaAGDwIVRy0Cu6pvtn
	YBAao1wGlEpf4wFcSGcLh1WHh2GPrKA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=QlVO2c6s;
	spf=pass (imf13.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789713765;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CtIhiKCuOAEoVt/C4TCUMvQnAVKyRCMQwoS5cwkd+M8=;
	b=jfyQMY3cDkyO1cxPauWoChjMBtXZryVFLQ4LYn/n4iyUJ23os4m8vhvx6W/uVTqeaeg8Gz
	HoZEWA/JsfAQJAgaBHECdTx5pMf2ENFSVDe53KBW1+JGUSwCkZA8EZzk1UbFFfnWG+5Gj+
	d0G4X7HErPMYPIJR7ppvaCpa22ggwxQ=
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1ceb47d53so41291a12.0
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:42:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789713764; x=1790318564; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CtIhiKCuOAEoVt/C4TCUMvQnAVKyRCMQwoS5cwkd+M8=;
        b=QlVO2c6sGraa+UBME3MWZyiM4Swcjk1ZPnFTiJHHbZg1eqxSeINiO5a+lDzP0wkaoM
         2ls2WlEGS59D+yyf4lYSd0HDzELV3+K/p4SDI3EJJjS+bj9dNCLZ1+CLgM/GaSN6fid9
         O4+3umJeLX28ZRIxu+0RhsgLC2VhP4+ugdEmg7UwbrDJ0VohDb+CvbkdE8OiAjXUQpD5
         HzzK7d2YOlMy4S/NRBAOLixSbK+C3+d1sLpjks2ydYNyvVpMhJQB8ML7YD3cMNggbSPA
         LPSYGl1z+ksxeOvRZ4fV3Xvo03gELd0WoIoW/hSAo8WdKJ8zrGuRjnO/94OFmtKy5PY+
         z6Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789713764; x=1790318564;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CtIhiKCuOAEoVt/C4TCUMvQnAVKyRCMQwoS5cwkd+M8=;
        b=foYx1o7Fv4Bzguc74Me7rMNLcCfdYXOK5vPBNAaXPnQ9EJP6D9KkQZRl0rREdaB6ha
         U8UfK/7akPj94d6fYPUeSJQ9VgvyCcOAEyWnMmC7HTZI+OdvDNU/yuNspKXyhhEJ6aqz
         ZjUFtxlopcs1Fhi4qacag3SqG0CMrafVOqKkItVoUQrPivqrCT7EoCNHaukGxKlZZPpO
         5OQAznX0aDkzN562yVNjpX641S24yp9bRQvGZai/djuekqTKYvFrD8SUiUgvVA7YdFYs
         +8JwSANsyyTsVHDElHd/hd1RLaoxGuDsOViZje/p94yOHgJBvD/Ne4XR/l0uUkEhqGWG
         l+ig==
X-Forwarded-Encrypted: i=1; AKwUvBzLQwHzodaUlJZjFb6d8LhJTwlnXPYaGIt/wJAtSRYTTnDIn2IUpz6JOsxFvj0ZJHbzzVRJO2JAiA==@kvack.org
X-Gm-Message-State: AFuF++leJXa+7IZ7qVfvtDBflgbyrxVWughbwKK3IHcBqa2V38XGe4/h
	JW4F3/lz9oD9x4Vy5hHi4nNcHIEmO1+oyJwV2npP/pbPMROox/PSu/ez
X-Gm-Gg: AYBFou31gFeKflTiDjvfjmqs+si/+xOv6EYhe7DazCEsnzKjzkOPAA/0vtFvEPAX7RF
	LXkA9yTPSbfnZqKTgxZoPM9NVZUZK2XuZaLwu1Otyxfwg73kVwMrpC/rryBLK/PN5XcVYXX8NkE
	fFvk/PfViqRqg/K8VaqUjvb9hk9tgCSIVVBDETQX8pVTjEAmqB9IUurEdvYNF8ZsywZ02y0ntiX
	mkXyRQVgiC851L9XmjrgXEjlN8txt6z46pBDC5swYl3gfmW+knDJV2kb8Y2vot3Var6Lz7LRTKr
	iXVi1txcVtmoDM/G9AeTEEmOMANLhqIL3Kq62tSB64VjbnojymeFZoz9PDkflw96jf6OpfCxTyD
	Vq+O86I86Wg2+hnOBvXRejIJoHFcZtlRsfNccvXx0HmcWKWfXxAb2ggZtfTKaT1AIEY7EPsU9hz
	C0yfsVmaWNzE5Hl/DPBaxVDdxn+ZtSvyG+eX7IocZlFYZvhL3LsYZsrIJITIPmf9HdaaTQArnCE
	Tu3gjVsDa0T2Xqzah15Rx8G4DkPAg/S1XCSqc8EKLJOyyU808wAbzeL0/Gel9dBI4HzYU1Y7Wrr
	4t+Ju4y4/ZgiUz4fAKBLieIjQA==
X-Received: by 2002:a17:90b:2744:b0:39e:2192:f81e with SMTP id 98e67ed59e1d1-39e554cea27mr1826375a91.7.1789713764296;
        Thu, 17 Sep 2026 23:42:44 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (36-232-230-153.dynamic-ip.hinet.net. [36.232.230.153])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e5a0e860asm1829055a91.1.2026.09.17.23.42.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 23:42:43 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	liam@infradead.org,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Barry Song <baohua@kernel.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm/memory: reuse the whole exclusive large folio on a write fault
Date: Fri, 18 Sep 2026 14:42:38 +0800
Message-ID: <20260918064238.868-1-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9F51E20003
X-Stat-Signature: 3ko3au1tw4xqzcnm6oza4676k1fgo6nr
X-Rspam-User: 
X-HE-Tag: 1789713765-760906
X-HE-Meta: U2FsdGVkX18Iulp5HOZ0Rqz0tyaBOMshD/HPrlufa/VWqy4JkNy2Bt5yLiW+/NA91M8owJgHs83GCM+Xfa+9fCIMxX7WU2BCBmuft/m7hCRzTBQvTJc8yFg+bDKjvBWqKd9auaHFZALlBpMOvZMm8bkRwYciVN0uF/L9zDq7iDO5FlI82MsElw8zlXxe4KEZLMs2E04rvzW6Lz0FA6147oE2KCPMNmS8EQxoG7LMYRu/K/2uovLMFeB8iJAQ90S+Fc88o8+rUX+nMvsld6/VoSlEX3asrjen6pm6sCVf1fMqmd4yU/AeUWWfFR3V8x4DyfFIoxKxE1p2KHmzihH9qHwLAK4GkiLDuxYcH1PfARkJrxvPCHWVhvBknEGVMgMOIkl9PSDwhYrg+QdM6k9dWHXAbbYyFFnlfP3TPK5+kICTXM9uKcy4fna3TQG7OafMS29czAK1bAMzskpw3r389DGa3MvxWFH0myQIKj2eKjKTEImOZygt1/LF/LQPdhE2lrQYSIGhUsxVN61tS9OoadvNfqhEdsr8KBAp5pYYoUFEcb67kQqkEd5iFZx8hiDHCov8tDSVnVCAk4RzkiwV6bLf1MaQb+M+LRkzSiujTEDo5zXqUJQIxVKUfOVZ6h1bGQg+5x5DP5B6jJyicWedlWPv+g+hsh68sEEGBFIhk/eEqOGPhtOVID6cvEDGVMB05MLdwYSq+WszCZ9KPrzbfnojLjbVpn+WrMaNxA1EHWWWSOnWY4HUkQvCT0N+rbMp2yYND6qABNGtHQb/PrmcPKerduegDuJ+Bt2vYoGNsnApvrrrtXF2dpOnDrZOvJbnq264uXTlz5pbO3oW3ZHJpHyAO83Lh4bPuByRrR1WVgBas6cA3S2Hr3VWW1pynMerf1GdtwRzhQJ38VKEIZBkA/Ma3OJfgH06UZwH/N7gxxBHiNWLse7UMFZBof/QMiV0QI3PS79cGjcrrMkwoW2
 Xn5OK87W
 VYJFyCtBy6LBt+eSkrijHEAXAlNuvyvFijRZmVIyBgkoCgqVN7pBmS3VE2d/dEnAI+z2rOuZJsQCqX4uCWkbnVQZIVFEmZAlQTNozyQi0djozNyUDYbMKKD0d7xSJESioHWv3XzYA/eAQmHGWqB1sM9AmRzvPfl2lRwscosEREfXwbN6bBBwhYNzJmRCpvvuKxkxANFl5E5vu1W3pSYepR9QYOhx+FAKoTP+j/oghC5iU7/ykuyjoe7N7XC730WeuJNQfZhTbIjGA44IxfO9EZpPa4MjKdElHt4OlYkSQN122SLe/botJ9nP4vTRqxPSwo7Zb74dcaHeqIZ1fOCIS///koQOPf3j9lz88cY1ADrkMH7XtHgXhz+lXLy4PrmLKii9wdACSjKLALflQINVuHXWQSGInbaXsHFdf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

fork() maps the anonymous pages of the parent read-only and clears
PageAnonExclusive on them.  Once the child has exec'ed or exited, a
write fault of the parent ends up in the reuse path of do_wp_page():
wp_can_reuse_anon_folio() finds that all references to the folio come
from mappings in this MM, the page is marked exclusive again and its PTE
is made writable.

For a large folio that check is about the folio, and what it finds holds
for every page of it.  Still only the page that faulted is marked
exclusive and only its PTE becomes writable, so each of the other pages
takes a write fault of its own, and each of those takes the large
mapcount lock to find out the same thing again: 16 faults for a 64K
folio, 512 for a 2M THP that is mapped by PTEs.  The same THP mapped by
a PMD is reused by one fault in do_huge_pmd_wp_page(), do_swap_page()
maps all PTEs of an exclusive large folio writable at once, and
numa_rebuild_large_mapping() upgrades all PTEs of the folio from one
hinting fault.

Commit 1da190f4d0a6 ("mm: Copy-on-Write (COW) reuse support for
PTE-mapped THP") left this for later because faulting around might
increase the COW latency.  Numbers for that are below.

When a large folio has been found exclusive, walk the part of it that
this page table maps inside the VMA.  PTEs that still map it read-only
are batched with folio_pte_batch_flags(), their pages are marked
exclusive, and where can_change_pte_writable() agrees the batch is made
writable with modify_prot_start_ptes()/modify_prot_commit_ptes(), the
way mprotect() does it.  That leaves NUMA hinting and uffd-wp PTEs
alone, keeps soft-dirty tracking exact, and on arm64 writes a contpte
block back as a whole where ptep_set_access_flags() on a single PTE has
to unfold it.  Pages that cannot be made writable are marked exclusive
all the same, so their own fault skips the folio check.  The PTE that
faulted is in one of the batches and is then completed by
wp_page_reuse() as before.  Small folios, PMD-mapped THPs, unsharing
faults and the copy path are not changed.

x86-64, i7-12700KF, 256 MiB of anonymous memory, fork(), the child
exits, then the parent stores to the memory.  Medians of 15 runs, two
boots of each kernel, taken alternately:

                          v7.3-rc3+           patched
  one byte per page, a clock_gettime() between the stores
    write faults
      4K pages            65,601              65,601
      64K mTHP            65,601               4,161
      1M mTHP             65,601                 321
      2M THP, PTE-mapped  65,601                 193
      2M THP, PMD-mapped     193                 193
    time (ms)
      4K pages            29.7 / 30.1         30.0 / 31.1
      64K mTHP            29.4 / 29.7          5.5 /  5.6
      1M mTHP             29.3 / 29.8          3.9 /  3.9
      2M THP, PTE-mapped  29.9 / 29.2          3.8 /  3.9
      2M THP, PMD-mapped   2.5 /  2.5          2.5 /  2.6
  memset() of all of it (ms)
      4K pages            57.2 / 56.5         56.9 / 57.1
      64K mTHP            56.5 / 56.3         39.0 / 38.7
      2M THP, PTE-mapped  58.6 / 56.5         36.8 / 37.7
      2M THP, PMD-mapped  37.5 / 35.9         35.9 / 36.5
  8 threads, one byte per page, random order (ms)
      64K mTHP             6.1 /  6.2          0.9 /  1.0
      2M THP, PTE-mapped   6.0 /  6.7          0.7 /  0.7

The latency of the one fault that now does the work for the folio,
measured as the time of the store that takes it, against 420 ns for a
reuse fault today (medians, ns):

                          reuse fault   fault that     COW fault that
                          (patched)     allocated it   copies 4K
      64K mTHP                   730          4,600          1,500
      1M mTHP                  5,500         63,000          1,500
      2M THP, PTE-mapped      10,100        126,000          1,500

That is 14 to 20 ns per PTE.  Builds that differ only by NOPs in front
of the new function take either 10,100 or 7,500 ns for the 2M folio,
with a period of 32 bytes: it is the loop of modify_prot_commit_ptes()
that changes speed with its address.

Capping the walk to the 16 PTEs around the fault instead was measured as
well: it takes 5.4 ms where the above takes 3.9 ms on 1M and 2M folios,
it is slower than today when only one page per 64K is written (3.1 ms
against 1.9 ms, the whole folio takes 1.5 ms), and it is only ahead when
no more than one page per 2M is ever written (0.1 ms against 1.3 ms for
the 256 MiB).

Redis 7.0.15 with 1.3 M keys of 512 bytes on 64K mTHP, BGSAVE and then
1,000,000 SETs: the faults of redis-server during the SETs go from
262,100 to 18,500, its CPU time from 1.48-1.53 s to 1.25-1.33 s, and
redis-benchmark reports 742,000 to 794,000 requests per second instead
of 652,000 to 658,000.  With THP off all three stay where they were.

arm64 was only run under QEMU, for the counters and with DEBUG_VM and
PAGE_TABLE_CHECK: the faults are the same as above, and with 64K folios
the first pass after fork() unfolds every contpte block today (512
contpte_convert() calls for 512 blocks, and nothing folds them again)
while none is unfolded with this patch.

What does not get faster on x86 are stores to pages that this CPU still
has a read-only TLB entry for.  The fault makes the PTEs writable but,
like mprotect(), does not flush, so such a page still takes a fault, a
spurious one that costs about the same as the reuse fault it replaces.
That happens to pages that were read since fork(): reading the 16 pages
of every 64K folio before storing to them takes 65,500 faults and 28 ms
before and after.  And it happens in a loop that does nothing but store
one byte to every page in ascending order, which is what the reuse-byte
mode of David's pte-mapped-folio-benchmarks does (120 ms before and
after for 1 GiB of 64K folios; 2M folios: 119 ms to 18 ms; the reuse
mode, a memset(), goes from 232 ms to 157 ms with 64K folios): while the
first store of a folio is faulting, the CPU has already run the next
stores speculatively and has filled the TLB with the read-only
translations of their pages.  Counting with kprobes, such a run enters
handle_mm_fault() 135,687 times and do_wp_page() 8,457 times; with an
LFENCE after every store the faults are 4,100 instead of 65,400 and the
loop takes 4 ms instead of 29 ms.  The PMD-mapped case, which this patch
does not touch, shows the same: 8,800 faults for 128 THPs, 133 with the
LFENCE.

With a flush_tlb_local() in the new function, as an experiment, the
ascending loop takes 4.1 ms instead of 28 ms on 64K folios, the
read-then-store loop 5.3 ms instead of 28 ms and the memset() 21 ms
instead of 38 ms, for a fault of 870 instead of 730 ns and 11% more time
for the pass with the clock_gettime().  Generic code has no way to ask
x86 for a flush that stays on this CPU, so that is left for later.

Assisted-by: LLM sparse
Signed-off-by: Yuan-Hao Hsu <aa9736195201@gmail.com>
---
 mm/memory.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 66 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 8b0c2c735d3d..85c883d1e558 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4355,6 +4355,64 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
 	return true;
 }
 
+/*
+ * wp_can_reuse_anon_folio() found a large folio to be exclusive to this MM.
+ * That holds for all of its pages and not only for the one that faulted: mark
+ * the ones that this page table maps exclusive as well and map them writable,
+ * like mprotect() would. Each of them would otherwise take a write fault of
+ * its own that repeats the check on the very same folio.
+ *
+ * The PTE that faulted is among them; wp_page_reuse() completes it.
+ */
+static void wp_reuse_large_anon_folio(struct vm_fault *vmf,
+		struct folio *folio)
+{
+	const fpb_t flags = FPB_RESPECT_WRITE | FPB_RESPECT_SOFT_DIRTY;
+	const unsigned long idx = folio_page_idx(folio, vmf->page);
+	struct vm_area_struct *vma = vmf->vma;
+	unsigned long addr = vmf->address;
+	unsigned long pt_start = ALIGN_DOWN(addr, PMD_SIZE);
+	unsigned long nr_before, nr_after, end;
+	struct page *page;
+	unsigned int nr, i;
+	pte_t *ptep, pte;
+
+	/* Stay within the folio, the VMA and the page table. */
+	nr_before = min3(idx, (addr - pt_start) >> PAGE_SHIFT,
+			 (addr - vma->vm_start) >> PAGE_SHIFT);
+	nr_after = min3(folio_nr_pages(folio) - idx,
+			(pt_start + PMD_SIZE - addr) >> PAGE_SHIFT,
+			(vma->vm_end - addr) >> PAGE_SHIFT);
+	end = addr + (nr_after << PAGE_SHIFT);
+	addr -= nr_before << PAGE_SHIFT;
+	ptep = vmf->pte - nr_before;
+	page = vmf->page - nr_before;
+
+	for (; addr != end; addr += nr * PAGE_SIZE, ptep += nr, page += nr) {
+		pte = ptep_get(ptep);
+		nr = 1;
+
+		/* Unmapped or replaced since, or writable already. */
+		if (!pte_present(pte) || pte_pfn(pte) != page_to_pfn(page) ||
+		    pte_write(pte))
+			continue;
+
+		nr = folio_pte_batch_flags(folio, NULL, ptep, &pte,
+					   (end - addr) >> PAGE_SHIFT, flags);
+		for (i = 0; i < nr; i++)
+			if (!PageAnonExclusive(page + i))
+				SetPageAnonExclusive(page + i);
+
+		/* The PTEs of a batch agree on everything this looks at. */
+		if (!can_change_pte_writable(vma, addr, pte))
+			continue;
+
+		pte = modify_prot_start_ptes(vma, addr, ptep, nr);
+		modify_prot_commit_ptes(vma, addr, ptep, pte,
+					pte_mkwrite(pte, vma), nr);
+	}
+}
+
 /*
  * This routine handles present pages, when
  * * users try to write to a shared page (FAULT_FLAG_WRITE)
@@ -4449,8 +4507,14 @@ static vm_fault_t do_wp_page(struct vm_fault *vmf)
 	 */
 	if (folio && folio_test_anon(folio) &&
 	    (PageAnonExclusive(vmf->page) || wp_can_reuse_anon_folio(folio, vma))) {
-		if (!PageAnonExclusive(vmf->page))
-			SetPageAnonExclusive(vmf->page);
+		if (!PageAnonExclusive(vmf->page)) {
+			if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
+			    folio_test_large(folio) && likely(!unshare) &&
+			    likely(vma->vm_flags & VM_WRITE))
+				wp_reuse_large_anon_folio(vmf, folio);
+			else
+				SetPageAnonExclusive(vmf->page);
+		}
 		if (unlikely(unshare)) {
 			pte_unmap_unlock(vmf->pte, vmf->ptl);
 			return 0;

base-commit: 238650ef6c7c7cca08e032527329424c9fbd70e5
-- 
2.43.0


