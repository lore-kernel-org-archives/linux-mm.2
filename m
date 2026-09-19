Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D15CC982CC
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 07:31:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EED206B008A; Sat, 19 Sep 2026 03:31:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4FE26B008C; Sat, 19 Sep 2026 03:31:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2D6B6B0092; Sat, 19 Sep 2026 03:31:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 948E76B008A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 03:31:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0008CA01E0
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:31:45 +0000 (UTC)
X-FDA: 85229692170.22.BADDD2C
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf07.hostedemail.com (Postfix) with ESMTP id 330A640002
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 07:31:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=spA34BdU;
	spf=pass (imf07.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789803104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9zipXiy3Z2c8VL53l/rPwbA9WGYn3oGwXIJotl5EYBA=;
	b=zjVSJAMV34/Pv/lqpXhZ5bWbWntIjAAio+qso66q6baI3ADdC93bGuT1s9HCWKgJuKnD6k
	KTcITXIOdVGtjEdPhr58u0iabKbnJizAiOJVS/UBxjNX1wZbI2mWQlMHgkkxDpXG3GVQQZ
	MdTGBT/9SPJf5CKXtw2mjQL96CC5vts=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789803104;
	b=4NkeVfjIJEWNULFKHdaJl4Elqnqe6weCJX39vs4Z4oB9O7aeWjRnfv8PGMfNLuhl8Mns1f
	2l5RYww5JM6XLCFSXe4uFJxwSzc8oCjmbvewcVOIizdFX4wUq1JBf80wzxLJ3DX0xKEmNO
	JYbqMr8/1LKZNjbcY+k5XIXGTNbDgkQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=spA34BdU;
	spf=pass (imf07.hostedemail.com: domain of aa9736195201@gmail.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc4c08393b0so1243457a12.0
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 00:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789803103; x=1790407903; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9zipXiy3Z2c8VL53l/rPwbA9WGYn3oGwXIJotl5EYBA=;
        b=spA34BdU5w1iD5JljbVbqx813x/GoCb3mZx//IKkxmhzFpmhNBAkzoSjooxCsy3kfw
         a+3scMnAxEgmKJOai6aeaqcuU5kRD4pvVd+MY/wjH/wWeZCpDvfwvQ/EvclhYToMD+jo
         LIxaLdzrTx7q/C8KbShihtq9H8Fswr+UXCAa+fbsTUuLBUpXrhaB9vjGtob7TGMiEiJ8
         JYQUc34f70GEnkY9528RVDJk6+Y151hUNVqED7zdRMVR2uuZjCTcnvDR0wxrMqeOKjfe
         Dv06S7wHrGgyWdN66TfvnJplDoWy0Kbuuht3ODpgAvwxVBEngaKpytmtOHT6quh+NENX
         fjYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789803103; x=1790407903;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9zipXiy3Z2c8VL53l/rPwbA9WGYn3oGwXIJotl5EYBA=;
        b=DSqto5Ja59NRRVY5knxSu9HYFvf80ykQuA3TPkWh/0a/rZ9/pzTqmqIRYb03UkVYV4
         xb4vzwU7zypq+FZZBZYgZAC4+1vMWUzNhxd0QGj95FxW8Z/P/aUTJGfqn3hSXco0ICAr
         BCa8M6tWKxHpCylWSi5ePJ/IdHr1ZS6LuvqjF1g7U4UEH5bRuAZzbFhiCPw3TMmeBsHw
         803/ksyghn7Hc8mankyoHYVBwhHO0nMecyAXDzAyZdBhH7tHxTeojzzcmXgOl4QuA71d
         hXMGk5iasA+WuSF5AmxKClYVbEPWf90Chl9GZLBhFUK0Xwg1oFfKgkzkYs1t8tDyyFXL
         fVnQ==
X-Forwarded-Encrypted: i=1; AKwUvBxbjJKsZuLU8gxhKYVablGn10FizOG0QLlwIkUOcXX29PNVq3gv5K9IhJO6WluXg4XEcimqeuYjng==@kvack.org
X-Gm-Message-State: AFuF++ladEQZvZwSnhBtMq0OTNZebsIforS8FBHqV70i8Wm8XvhUk9PK
	RFWlzXcOU6MYzObsdnX+9Vm1xO/CBo4KzkDxxe+iRH2f/cdhWk3tkomx
X-Gm-Gg: AYBFou0knZyQILD9r/2VoUhVg2EXbW2LIAdAxDz/UlSiuB/hziRsFX9hVXzEeh3A+pL
	EVaa4Lf7vW8CEDGJE5GtiJUxEwFbBSFoPZpKw1eA3HO+FNSk9OD89ViEIvkqA691MhXEqXh0Bfq
	J/aAZfVnIUnPH+vjsKsHaP7DPY0zC+3IKa0qkTnr3FvI9Q8hXueK6foOS8Do+Xn9mkii6BVCMTW
	K2c6Qk7Apye/03uH8KT00f9s0D5eHW0D2Azu3gUzsq35Jb7yMjO6NnypoG2aJRjwQLZYbdE7Yj9
	40E+boh8A+t+NSi+nCMcRjhTo4asSVoX8JmKZ8yciRdiZ/sMxd8f4Hm/W3MyZUNvgIbWcnSbDJG
	3Gr86SljqHC3uRv9n0uvcwyP5pfD88cWMGvLB05R1cYGOv0nyIICCFvbLpoh5z2hEHO7neybRtZ
	DN5Xl41MypJQtXYSLuze944MB35gsNyh4Ev2l3LFPqQVWFtjuUQ9nsDUMrbNxEMhCRerEtP8WWh
	JjsEvHXpgzSLMqW0kD2Mx/YKxrjLieRjOf5+E3Klhm8R8hZx5APApTF8X7lL5i8aCH/w2ZkUEqN
	a+Xbjz/bfItzOyIlfjFNF/RvAwshRPIIVc8K
X-Received: by 2002:a05:6a21:7308:b0:3dd:a196:9073 with SMTP id adf61e73a8af0-3dda196a642mr2895494637.61.1789803102983;
        Sat, 19 Sep 2026 00:31:42 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (36-232-198-121.dynamic-ip.hinet.net. [36.232.198.121])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc72ae9e9c8sm654498a12.17.2026.09.19.00.31.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Sep 2026 00:31:42 -0700 (PDT)
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
Subject: [PATCH v2 1/2] mm/memory: reuse 16 PTEs of an exclusive large folio on a write fault
Date: Sat, 19 Sep 2026 15:31:32 +0800
Message-ID: <20260919073134.639-2-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260919073134.639-1-aa9736195201@gmail.com>
References: <20260918064238.868-1-aa9736195201@gmail.com>
 <20260919073134.639-1-aa9736195201@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fyqdukstaqf7r55rtmkr8ch34gyponf5
X-Rspam-User: 
X-Rspamd-Queue-Id: 330A640002
X-Rspamd-Server: rspam03
X-HE-Tag: 1789803104-624945
X-HE-Meta: U2FsdGVkX1/i/eMqdZkB0NczzDtMFEikla76xYhpHWuroQDYpQwUyesbkR+FCxNa/BT2/bVpkvCEH45uPxPl9i5umFaGcp1TO9EuS2y8N/5QMbQ/Y+9FtUIEknBAU0N4eTYuqz1T9oOZ5Tl+HnfR6dfF0rSeRl8Cj/o5E8E+JyrDNjFofvlCDCtkXIgloJw9vlyAfSorU14Le+nj4C8qQjwBQDPvIlN8bR7oY1j1KUapNdxYk+LiOhepbLdjYtKGXBvFIhFyIirb9dtzfzryJd6v+E0vhDqe9WP3gNVaHTi0b7CMVTjJmqHm5NS+coMCssb2RzbLQsUrNZYo8kJWfszuMVM/1CTZ+sS5z5FRvTLGhDk1JinM0cEIa4Llm5Tr0JDq5gpW2r9vW5aSK2tMEJVfPyzNsE8oR4WbDKZ3hIgZdnK34/pxM8p24Vl/SiQ2QJ61JS0cOV+PU8XYUeO9tg3US61ogIZxmaGSKyzSBbwTHDdZBCCwzoHHNBfrcg7SGIzkNj82FQXx9LvTcIJwXqxXWSvuI3LabMtYN8LDBaG2J5AaIATRvDCP+Z2WPfAmWiFGcnBN76cz6Jn0Xq3CjS9GTAKtGdQtKff1Gs4si5fsQAMWwC9zMZ1Ep+DYTiwG4Rqd26IzGrH83+ZpsER27wfaaZP9t8IZTnFvCu6XVcQk/nVWitSgMs2C+VVBuyt6U+0FA4HIHwnU1nkea8ajO1HMSjZe0+ZZwo44R88HuvLI8OmDIfve1Su0n6Q7hPnBCazaN1NK8QqYcF5zeo2I97aOpfIX4FRqT7vxhAOCp21liH7AmDONulXx6YHbLhFfhyJ0+xOvfNJM+6AfMq229gUpt+sMS4BMN/De9SsC/QinNqk5xtvqF9H9wc6mAmtzgsjn4Q2jwhSzfr1zjE5CTUb/7+xzO9bv9eOa7bKoZFUgrU+on+N67gu/GiLNMnL2/XVmlL0X9ueS4OQBmL6
 NlayqpDD
 9m89blS2DedXGHq+f9LEJt/MRs53ZktCec+YTWh81ELGM1yEwgVT/IliRkpOxqfvZgBstCF69t/09P8jutkI+/A8qEjPhCKDsHZaT1RZ2yetGRb2bBrLo61sLsfnxBFHoQGZekKL9CKTtsLEVinC+0m1ZjyR5/5luE0IDj8UjG/b5LvJPnrrvfUW92K3smSvm8MMyxcmub/SfRqeUgwmzTGqaL9/1eKxMn964knyofXbLKRTIuKJttN2hR8fXxTN6M6YOBEfQ/TzttHYTrouEyiXv4nQxkeYUzL8UuyMJhxljso9MbqRqPHO/o+BCYyLAp4YvN8wFvcYO+xBLXRa0FI15TjbEZZpYlM5F5ltrInN+f3pMy3QTRt3jIQwDZglJuMNhgnizi0IAEt4wcRDKN9u/3UKPkDcs7obePBRIn4lY0vPVRZzxflhfy/ZPi8xZgjUFLvp9QJSnRxE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

fork() maps the anonymous pages of the parent read-only and clears
PageAnonExclusive on them.  Once the child has exec'ed or exited, the
parent's write fault takes the reuse path of do_wp_page():
wp_can_reuse_anon_folio() finds that all references to the folio come
from this MM, the page is marked exclusive again and its PTE is made
writable.

For a large folio that check is about the folio and holds for every
page of it, but only the page that faulted is marked exclusive and
made writable.  Each other page takes a write fault of its own and
takes the large mapcount lock to find out the same thing again: 16
faults for a 64K folio.  The same THP mapped by a PMD is reused by one
fault in do_huge_pmd_wp_page(), and do_swap_page() maps all PTEs of an
exclusive large folio writable at once.

Barry proposed reusing the whole mTHP from one fault in 2024 [1].  The
reservations then were the latency of the individual write fault and
how far to go around the faulting PTE: a contpte-sized block was fine,
anything bigger not yet convincing (David's replies, linked below).
Commit 1da190f4d0a6 ("mm: Copy-on-Write (COW) reuse support for
PTE-mapped THP") then added the per-folio check and left faulting
around for later.

This is the contpte-sized part.  Once the folio is known to be
exclusive, walk the aligned block of 16 PTEs around the fault, within
the folio and the VMA.  PTEs that still map the folio read-only are
batched with folio_pte_batch_flags(), their pages are marked
exclusive, and where can_change_pte_writable() agrees the batch is
made writable with modify_prot_start_ptes()/modify_prot_commit_ptes(),
as mprotect() does it.  That leaves NUMA hinting and uffd-wp PTEs
alone, keeps soft-dirty tracking exact, and on arm64 writes a contpte
block back as a whole where ptep_set_access_flags() on one PTE has to
unfold it.  Pages that cannot be made writable are still marked
exclusive, so their own fault skips the folio check.  The PTE that
faulted is in one of the batches and is completed by wp_page_reuse()
as before.  Small folios, PMD-mapped THPs, unsharing faults and the
copy path are unchanged.

The cost is bounded by the block: at most 16 PTEs read once by
folio_pte_batch_flags(), the scan fork() and mprotect() already run
over them, 16 pages marked exclusive and 16 PTEs written.  On x86-64
(i7-12700KF; medians of 15 runs, two boots of each kernel taken
alternately) the fault that does that for a 64K folio takes 750 ns,
against 420-440 ns for a reuse fault today and 4,600-5,000 ns for the
fault that allocated the folio.

256 MiB of 64K folios after fork() and the child's exit, faults and
time of the pass:

                            v7.3-rc3+             patched
  one byte per page, seq    65,601  30.8/30.5 ms   4,164   5.7/ 5.7 ms
  one byte per page, random 65,601  39.5/41.6 ms   4,161   7.4/ 7.6 ms
  memset()                  65,541  57.4/59.5 ms   4,102  39.5/39.8 ms
  8 threads, random order   65,541   6.1/ 6.2 ms   4,155   0.9/ 0.9 ms
  one store per 64K folio    4,101   1.9/ 2.0 ms   4,101   3.5/ 3.3 ms

Redis 7.0.15, 1.3 M keys of 512 bytes on 64K mTHP, BGSAVE and then
1,000,000 SETs: the faults of redis-server during the SETs go from
262,100 to 18,550 and its CPU time from 1.48-1.53 s to 1.31-1.41 s;
the requests per second stay within the boot-to-boot spread.  With
THP off nothing changes.

arm64, under QEMU for the counters: the first pass after fork()
unfolds every contpte block of the 64K folios today (512
contpte_convert() calls for 512 blocks, and nothing folds them again);
with this patch none is unfolded.

[1] https://lore.kernel.org/r/20240831092339.66085-1-21cnbao@gmail.com

Link: https://lore.kernel.org/all/20240831092339.66085-1-21cnbao@gmail.com/
Link: https://lore.kernel.org/all/b7853f0f-7044-4c49-931c-c61900229b19@redhat.com/
Link: https://lore.kernel.org/all/36933711-ae0f-468c-93bd-d6a67d974c9d@redhat.com/
Assisted-by: LLM sparse
Signed-off-by: Yuan-Hao Hsu <aa9736195201@gmail.com>
---
 mm/memory.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 73 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 8b0c2c735d3d..73e5691b3ed8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4355,6 +4355,71 @@ static bool wp_can_reuse_anon_folio(struct folio *folio,
 	return true;
 }
 
+/*
+ * The pages of the folio around the one that faulted are handled in aligned
+ * blocks of this many PTEs: a 64K folio with 4K pages, and the size of a
+ * contpte block on arm64.
+ */
+#define WP_REUSE_NR_PTES	16
+
+/*
+ * wp_can_reuse_anon_folio() found a large folio to be exclusive to this MM.
+ * That holds for all of its pages and not only for the one that faulted: mark
+ * the ones in the same block exclusive as well and map them writable, like
+ * mprotect() would. Each of them would otherwise take a write fault of its own
+ * that repeats the check on the very same folio.
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
+	unsigned long block = ALIGN_DOWN(addr, WP_REUSE_NR_PTES * PAGE_SIZE);
+	unsigned long nr_before, nr_after, end;
+	struct page *page;
+	unsigned int nr, i;
+	pte_t *ptep, pte;
+
+	/* Stay within the folio, the VMA and the block. */
+	nr_before = min3(idx, (addr - block) >> PAGE_SHIFT,
+			 (addr - vma->vm_start) >> PAGE_SHIFT);
+	nr_after = min3(folio_nr_pages(folio) - idx,
+			(block + WP_REUSE_NR_PTES * PAGE_SIZE - addr) >> PAGE_SHIFT,
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
@@ -4449,8 +4514,14 @@ static vm_fault_t do_wp_page(struct vm_fault *vmf)
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
-- 
2.43.0


