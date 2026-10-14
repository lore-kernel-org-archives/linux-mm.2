Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD81BCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 14:43:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4006F6B0088; Wed, 14 Oct 2026 10:43:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B12F6B008A; Wed, 14 Oct 2026 10:43:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CAC96B008C; Wed, 14 Oct 2026 10:43:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E08B86B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 10:43:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 41F1F1605CB
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:43:05 +0000 (UTC)
X-FDA: 85321499130.01.DE7F085
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8572EA000A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:43:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b="RBgg/XHZ";
	spf=pass (imf25.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791988983;
	b=iEozADJUVSdvBG9Cmvw4dLcz1RHjVygdxuE40OBVDt97iDwj64MbAV/Jp3979S2CLYUGje
	LBlZQW0GZy7ceS0GunJqPfm5ul/AC1o6NpVgJ338kH6Ka85ci0ssZv+zKqHrpSAjazjhSD
	3FE0H374FUeY4SfdRuaTBZMHOd4Dx3s=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b="RBgg/XHZ";
	spf=pass (imf25.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791988983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t/UZtKfAP/AOsCTLOqASa/QaRlwucOv4zkWaYhC/wA0=;
	b=tza0x/HFB6Zws8hMy2Yfxu8h2N5iYrFfb3ZOBjZoStRjpq6ecd3YilL2NOELFePNu86O7I
	oxO6axSGda7JHjNeMANvQUNmPbjp7sLT9V9cu3aLmxGBFlKlhz0BFUQZi9Qnzwes3C0yFT
	AeWCbvrvVdJs+vu1TshsZQIno3m4a3o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=t/UZtKfAP/AOsCTLOqASa/QaRlwucOv4zkWaYhC/wA0=; b=RBgg/XHZEF5N4a/JZiG
	jP43gQhG6kJRhxVD+UVnG/cpXJfYdqXv+tkYtUFWvu6oYafc9fBg4QjYzBGXa9AquIuLEEhhsZ2EU
	3e6+ppoTzCf9+Ht+c/c1MEsntPoSdw+I4P7Ux97Xk6Ji/bBfgCGaJOM1/4+djhW00mZWnJkcGYLhw
	sti2RK8i+TowPnAQf3dzTp2myVyqjW4kk2UZP9uNz7xKq/AksmQsbro1IeD1OOop2Tug24foQYmWl
	ESOXF5pPFQ73IvLjxdZP/2NfWwwZ0ED2I1i3Sw1mId+dow5gCH2Agj8y4pY5Wkf4byiMFNIrK5Ick
	t3fAIp+ysN+vxGg==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xH08A-005A8J-2F;
	Wed, 14 Oct 2026 16:42:30 +0200
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Wed, 14 Oct 2026 16:42:21 +0200
Subject: [PATCH v2 1/2] mm/huge_memory: recheck a special PMD under the
 lock in copy_huge_pmd()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v2-1-e1548488fa68@virtuozzo.com>
References: <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v2-0-e1548488fa68@virtuozzo.com>
In-Reply-To: <20261014-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v2-0-e1548488fa68@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org, 
 =?utf-8?q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>, 
 dri-devel@lists.freedesktop.org, Madhavan Srinivasan <maddy@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3447;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=24xsS9uHXjbHNUmfuAgnap1aLrWSBY6Mx7i1m77Ij0I=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBqz5TUTk1Iq6n/aWWXcVJlaLQNo84wp5TFDgCA1
 cPpv8dcbTSJAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCas+U1AAKCRBRlgpH+WFc
 KnVYD/wNHthVuGM6T21qF1NC3MBC5WWWYhNN2wSERL0OJgSUtoxYYWvBeZGsCrUsmlg6MjLeCjV
 5Zqdhw5Khly/2gpOYdz1bYUYQS+6+4avGm/L9e/3h+mUkBjEr1Z+p5g7rOoEe9QeAGh7MjoCw0n
 PEYr3RSsywRBLqHoN7iCxNJojbjEmlMgW28z46Cn2PoGPirti16ZxoWpmTvC6EZs8hWrYS/YYeN
 xFTS4RAxPtk+xWGUeDP/jHeEniMBbEKf7/pNy54bbhxrD2Ln9p3EwanHm9V3noI2IFefm/QAvYg
 QBG33/zassG97uUFEjsi6XY+qree+V11hln5c0t7mOpjAv7uc/bdY7hzM7GC4T09QSZvUCTiwYQ
 Fj/VbO1VD8fqG3g45EiAoSOfUkUBdmPhhas2lw4qn5RnDAZHED1uAaFdJAAFBE33nF5aYB2Ehiq
 VZNgSaqnUj5Quue405tJEhJVt0lD5DvR4qBskWeVIX5O8+V9v/S1OSPkV/vBj4sYNFhujEIKoCT
 VYV71TiHUPiyFVQIhOk+RspeWyHi0nRK0KUUW0aXiuvhxDXFmc/qqQXgJE1pzRmGop/0uVgdX67
 XkmRK24Xi41gpTDYGTXE0aZGvvT53/enIROVbAjb+j6k2l6Xx8tA3XOwxm7GyirCDUGC+LieM6f
 CQsQZrrKGsQXv3Q==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8572EA000A
X-Rspam-User: 
X-Stat-Signature: 6q5jg1twsyh8jnmzamhjzqosbzr38a6d
X-HE-Tag: 1791988983-232786
X-HE-Meta: U2FsdGVkX1/QDD0+B8YL0nvkzjnX0d0+ytU1CGHxlaetdVN1KeGr/b+uDb9Qu2a0PXoO8MxNDfWo5suY/hNvssmOirAmJp7L6f1d9HEJWIl4mjDkSnacjzQF+MOqnuC8V5iaCCQmJjvpbp6VZo/puemmp+DZaV+bNZnO2E4Sn9aA8LCi1fJKIIsDuvpJtiwM3W8R3sQct4YdSv1QdwvoEgDnhwguSnlJ3MSvnkvzjWGRgcEMNQmVwvtQx4FEZJVDZPi3ZMPUfyegnn8XnRDzNWnc4o9BT//xTXWCbZment4jNgUF1eqMVo8WpX4gmLUjlEcotDI7QlyIx7nAY1rFI9uXbY8/Hg0kDU8E5rv7XKJjEdU4iLCcawB2N1MYsbJcaEjzzoPF3HkS3xUs6nvt2H2dcz1+PQrPtet/85RLt7nk1ssDDWoLb55O2hMQuJSvbTvgokGri6OzyqKBH+OUztUa64bzH+FHx3w/vTehsUfBRJ7mpYr5xx94+W+JHB2s9ADGiEFEJ+4hbaScSOZONmB3G3qMS32HPXERcr3diHf2OyflxQy4Jy4hWdDiZ9FUxHGEuOFpSQZ3HuHhLn3o9U53x3O8pVWcMdMdcg86TFRHtyTFpkzu+LBCoqZjJ2ZD28W53XKRz/XLu/cr5QWfm3dJ4ozwmXTMrLpVN0t9JDtzhW6BcgnCDG+Vs1VzIkOb4aDYv91y7n1ah6I/Yr0pp8BLbEHH6x8Yh9bw3p0IfiFnw1TtykI2nn9pJJzJNic/Aloc7oTpLxkMWci3ixnWi5VW+4/3n0mZix9TYRrsHJ5scSi6q5pSk70CICGaF8tImytBk33aXeBPuJek11v7gFiJXq586RgLYeS/of3pX1HaEoECkRTqMT9CIJAQAQUSMJuvRK82o1tiOCPpDFrtsa+tkCGWkhJD1E5KCsHs08hxSXgveWhBLi+DMVClpw+sqWaKF5fAJ4+2+lJf0Ov
 0ief4gqs
 fu32Fp2jaW3u6GTffKmsMW50Tt7bcJWfrs7JblRUz2XYTsAhPupu3W5kGGal5TgrHfRCciYO66yu+qL3DKerjrJHLqjblm1FfPHOLrTZJ7kdE6NxPHKBgLRS7idhM633XnE8/LNaDHnSgDgKAi8sqZWVcJkPpa22gZ1Kr+dRr8xvl2RIa5MPpeQ67Fh2miW64ODtGwlgr2fVice7+JXaPqIbvjq5B/20GPQAnYsEX00jETimxdfKDwiUaB3v49lriiAcCnkJW1HTXtpVg3n8Xa+PEOj4Frj1hwLWq5PdUwMkYPrsn1GKhYUMPOxb4tx31yaXqQyIfDvhAa5T7sa3hi84QNucGUDue/v6m2SQ93f8jxVkd5Hhipv1iZ1moZZTWTHIaQbyodCgcRBOCWcxjrqkLpDMGoSf+SIYa5IuzoNYGc/fzLcJwEjpEW75OgR0NxHQYMcSrNl+f/Hg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

copy_huge_pmd() reads the source PMD without the page table lock and,
for a special PMD, installs that value in the child without reading it
again under the lock. The comment says the PMD cannot change while the
mmap lock is held for write, but unmap_mapping_range() does not take
the mmap lock: it zaps under i_mmap_rwsem and the PMD lock.

dup_mmap() links the child VMA into the file's i_mmap tree right after
the parent's VMA before copying the page tables, so a zap visits the
parent first and the child second. When the zap clears the parent PMD
after fork has read it, and passes the child before fork installs the
copy, the child keeps a mapping the zap was meant to remove.

Drivers that map special PMDs with vmf_insert_pfn_pmd() rely on that
zap. vfio-pci zaps its BARs when the device memory is disabled or the
device is reset, so that userspace gets SIGBUS instead of reaching
disabled MMIO; a stale child mapping still reaches it. panthor zaps
the CPU mappings of a buffer object it evicts and then releases its
pages; a stale child mapping points to the freed pages.

Read the PMD again under the lock. The zap clears the parent PMD under
the same lock, so either the recheck finds it empty, or the copy is in
place before the zap reaches the child, which then removes it. If the
PMD is no longer a present special entry, return -EAGAIN: the source
mmap and VMA write locks keep faults out, so only a zap can have
cleared it, and copy_pmd_range() then skips the empty PMD. Otherwise
copy the value read under the lock. pmd_same() would be the wrong
test: threads of the parent can still set the accessed and dirty bits,
and -EAGAIN on a present huge PMD makes copy_pmd_range() clear it as a
bad PMD.

Fixes: bc02afbd4d73 ("mm/fork: accept huge pfnmap entries")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 mm/huge_memory.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1e5d68acf62a5..fcea98f0d8865 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1965,13 +1965,22 @@ int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		src_ptl = pmd_lockptr(src_mm, src_pmd);
 		spin_lock_nested(src_ptl, SINGLE_DEPTH_NESTING);
 		/*
-		 * No need to recheck the pmd, it can't change with write
-		 * mmap lock held here.
-		 *
-		 * Meanwhile, making sure it's not a CoW VMA with writable
-		 * mapping, otherwise it means either the anon page wrongly
-		 * applied special bit, or we made the PRIVATE mapping be
-		 * able to wrongly write to the backend MMIO.
+		 * The mmap and VMA write locks of the source keep faults
+		 * out, but unmap_mapping_range() does not take the mmap
+		 * lock and may have cleared the pmd since the lockless
+		 * read. Let copy_pmd_range() skip it then.
+		 */
+		pmd = pmdp_get(src_pmd);
+		if (unlikely(!pmd_present(pmd) || !pmd_special(pmd))) {
+			spin_unlock(src_ptl);
+			spin_unlock(dst_ptl);
+			return -EAGAIN;
+		}
+		/*
+		 * Make sure it's not a CoW VMA with writable mapping,
+		 * otherwise it means either the anon page wrongly applied
+		 * special bit, or we made the PRIVATE mapping be able to
+		 * wrongly write to the backend MMIO.
 		 */
 		VM_WARN_ON_ONCE(vma_is_cow_mapping(src_vma) && pmd_write(pmd));
 		goto set_pmd;

-- 
2.43.0


