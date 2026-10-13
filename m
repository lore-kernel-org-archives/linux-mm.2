Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AF20CA9ED2
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 11:41:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 315456B008A; Tue, 13 Oct 2026 07:41:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C6446B008C; Tue, 13 Oct 2026 07:41:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DBE96B0092; Tue, 13 Oct 2026 07:41:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E67166B008A
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:41:36 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72FB5160A93
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:41:36 +0000 (UTC)
X-FDA: 85317412992.15.E455CE2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id B10E31C0004
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:41:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OOLZmlgc;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791891694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=F93gnhxwnZO5S1/DscLlicVfv27bgs8rbwtUzEPimv0=;
	b=iMBagHMk9cOZ864TYODX4vBQ6Zrt65mrILu9qtxSALUt6dHkgXZeE03ILnoKZCJ22Q5MKA
	XXLExFKZ4xzC6QgZT0+p0PM7MY/WEoH+QCvKpKLXdpI+8WIFRi9caD1xj5fytqZKomZ7tU
	GfanP7GC2Tkw1UGTW8uzYHieVAavUw8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791891694;
	b=2TjgVBt9oKlQ3BoSQq4qeU/M/P3Iz+qlOdO9M+As8EVk+h5OmnRS7douOV+JmCBlHyWQhD
	5SuzqPiic1OE9Ex/AusXXU99dYuId2MUcONOSg+YaL5fUHTz3l08WHQDwHw1HHIfeBGv3w
	QR/fEkumesqXsD+6Wt0O5PZNIcgob3U=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OOLZmlgc;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4BA93600D1;
	Tue, 13 Oct 2026 11:41:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B81F1F000FF;
	Tue, 13 Oct 2026 11:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791891693;
	bh=F93gnhxwnZO5S1/DscLlicVfv27bgs8rbwtUzEPimv0=;
	h=From:Date:Subject:To:Cc;
	b=OOLZmlgce05m/yaxI8/uEpHWHpgwwZWngSGvYKvMt2dwL8iUBw3yTtiW2JE1wSqo0
	 /V88R5r9cuNnozbtMFjr5aHJW0+fUKM65LvgQKklm9RpD/MN9e3EMj4Xz3DReAydiB
	 gm10EpbDJBWYtymh9vwAaDLXkRP0OENRNrsD9OUNJ2E5q6S5ZR6EGc1kW9lISklk70
	 f5IsMMJhlEEPafgI+jSCPFzSsz4xKFuZ0RU9iYsJG6N/uigsVV1pGkqgAQhS+NEpKl
	 IZO5Kqo7VwWVut+6nd/joTJONbId64t663bDwBl6nbNOFxyJ23XgOqSGIyA8PLNpEl
	 R1ILmp+IVBkmg==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 13 Oct 2026 13:41:24 +0200
Subject: [PATCH] mm: disallow ioremap'ing ordinary RAM in
 generic_access_phys()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-generic_access_phys-v1-1-b3963ef76e37@kernel.org>
X-B4-Tracking: v=1; b=H4sIAOMYzmoC/yXMQQqDQAxG4atI1h2ISqX1KlLExl+Ni1EmKop49
 07b5bd47yRDUBiVyUkBm5pOPiK9JSRD43s4baMp46xImZ+uh4+F1I0IzOp5OMxxl4MfXOR8bym
 Wc0Cn++9avf629T1Clu+KrusD+UT1mncAAAA=
X-Change-ID: 20261009-generic_access_phys-0f3e0806305d
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Benjamin Herrensmidt <benh@kernel.crashing.org>, 
 Peter Zijlstra <a.p.zijlstra@chello.nl>, Rik van Riel <riel@redhat.com>, 
 Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com, 
 stable@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3277; i=david@kernel.org;
 h=from:subject:message-id; bh=9fyepUSFbap3das+eKlha3QFUTceWJGofHIg/6dNGCg=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLOSTx7YW87s+XvMXWn2Z+4+nZU/npuMLN5rZ3H0VTdX
 suDoS8rO0pZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZiInzTDP6utt7Qf5NvM7+9+
 nnrm5fEjTTvyK9mqLR/sjOiyubf28m6G/7UHtOZsP9r8sGFl2te4mWqPdbkC5mne/rbjwxe96mu
 Jp9gA
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B10E31C0004
X-Stat-Signature: qizg6cpfqc49feyc5cf89mkphr6apjxi
X-HE-Tag: 1791891694-611030
X-HE-Meta: U2FsdGVkX1+mbMWC+39pgK8azy2slKk+ZjBoAXykkowp1/QoRA5woZJIdU6fGtf9EMuYbg9JPpiBsDWlvd6GvK0GNcfly6ZvTQf09HlookeTRhtzFO7jNSHC/cvrZOSM/V5gIpA3Hm1moK7nYgi81at4/69GWTov5mIKyXOcCELchK4YqiLpLVU81+mZtOqt6SJTkeQZiE1j8QYGKTM6rm9KHWQqNab+32D8NBss/qydAGrP34RMaq28C9EZ9k0LGm78xFcG2LPoQcIzCJeSGzNW8eYWu9piMxGZRaq546Jpvhg2/wBeHl9cnZpgscVeezhWPWaY8lsWU+Mnn9nFc6N8wD9LPzKLp4Xwtuz9uO4cLKGrBsuMpI1StvyxeoZNcVXj8dzDaCuOR1Guq//cKw8XDKV2dNzgTemfbHtr/TuYx/YzhSYLJPATcSO0AJz6e1Ar1q31ao0bichXVGNtcmUWSLVpgUad0ykqEYwsjous/JZp8Gm+ZjJ2NTq/XXTQAT12dOMffcc55X7HdXF0IyB/u4L9QZ4TTvGtUzMZc69r6puz876hVZUvx1abqpppeLNB7my2q96mFZsyxOy0XDlhRnK37LSirNbqn/9gdjdNc0+NyI0bE0fPBlxPi++Q22thIqIsCdrcF1UM/yytNtaIEiUTmZKYgSiDpqQPTlE2XlevUyFvgxvEE9lg7pWYcDGu9vlVO645tct6vm1Vq5D57+/pqPx8idKhAT7bOEIIXg6EDrE+X4yzw0wJoPlwSjZa0BCFVeFhjxkpFXmCGzY0X+KKlhUW6x8h3tgmbQV6WkG7kC+ljV4hmzbB7EWdpyyTyYTXIUSof9Z4RwF6BViRu7QsY1CiUGNdgMCUZRJ0CqiSV2FIUqooL4N5YUcU25wxrhQeQUYftQKHRk3kAdZRq6P43Cmf1EkZLEPkJ5C68W4bwH65NIT0GYLf+zbn5jLAlYF0ZQcUEyntTAl
 +4ukwy35
 0of/rLARF98qEFvPfotDaQ2j2uLW5L0rvnX0qzn5uggDsF/+D3g5M7KERDSSpHbfzNMCXyHPGIdag7bwEgfm/Qny0A9OaIM6NOCn/F2fUOnDu1N61jyq9AxKsbl/sxDmt3lYqXQKCdeXs0Djrov9TFGI9eRT8Xo7JzlzLImsP/zcGVr6F4u55jTU7rXA/VLFvZxn6Dju01QC6kyzkebyKNp4jNa4J5zyLqFVLsimpCfXxC+oHFTVngIdNmwrE6TX7jXtjXs3UYlQJh9DYuiVclhv0VbGsBsNAiFGnVUCvr5TBv2FTI6f7A/EUlbBsRye6mhdnxDSt+6GKVTwt301GdZvMRTEbzy6T6kfpC4rZqVXaIJoJanSBMzWA5du8hmrXGLaop5RsvyOHz7D3mRzY0C5WMgvwkJWKoi6ml2sjR7q7pftu5wPMjRFKMx24JPUwFb6sw33Jlkn7jdg0aF1DfFHwgWiib4S58yutAt6GWLHmWO06hT6ijgMFjoxomMwOuLchAOJXDGmkjjfh1It/99BmZcAv83wtEedqgcEJnKWk4n84boK75zoTMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

generic_access_phys() can end up getting called on CoW PFNMAP mappings,
resulting in it trying to ioremap anonymous folios, which especially
the x86 code doesn't enjoy, and which is in general just odd/wrong.

E.g., with a CoW mapping of a PCI BAR:

ioremap on RAM at 0x0000000045623000 - 0x0000000045623fff
  WARNING: arch/x86/mm/ioremap.c:216 at __ioremap_caller.isra.0+0x4c2/0x5f0
  Call Trace:
   generic_access_phys+0x130/0x4d0 mm/memory.c:7178
   kernfs_vma_access+0x1ce/0x280 fs/kernfs/file.c:437
   __access_remote_vm+0x58f/0x890 mm/memory.c:7256
   mem_rw+0x2a1/0x670 fs/proc/base.c:912

But more generically, we should disallow access to anything that looks
like ordinary RAM in the system: including allocating memory (e.g.,
alloc_pages) and mapping them in a VM_PFNMAP.

For pages with an online memmap, allow only pages marked as reserved
(PageReserved). This also includes memblock allocations, however,
distinguishing them from other MMIO is tricky, and nobody should really
be mapping them in a PFNMAP (except someone abusing /dev/mem, which we
do not care about).

So only allow access if there is no online memmap, or if the pages are
marked reserved. Reject other pages with -EINVAL.

Note that, just like other pfn_to_online_page() users, we won't care about
concurrent memory offlining; mapping memory that can concurrently get
offlined is highly dubious.

Reported-by: syzbot+49b1021becba70c1f3f6@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=49b1021becba70c1f3f6
Reported-by: Nguyen Ngoc Thang <ngocthang2710.1999@gmail.com>
Closes: https://lore.kernel.org/r/20261001152524.171115-1-ngocthang2710.1999@gmail.com/
Fixes: 28b2ee20c7cb ("access_process_vm device memory infrastructure")
Cc: stable@vger.kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
I went back and forth 10 times and concluded that using PageReserved
should be the right thing to check for now.
---
 mm/memory.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/mm/memory.c b/mm/memory.c
index 1f5d5f7d39cd2..5d9f757a00073 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -7226,6 +7226,7 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 	resource_size_t phys_addr;
 	pgprot_t prot = __pgprot(0);
 	void __iomem *maddr;
+	struct page *page;
 	int offset = offset_in_page(addr);
 	int ret = -EINVAL;
 	bool writable;
@@ -7240,6 +7241,19 @@ int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 retry:
 	if (follow_pfnmap_start(&args))
 		return -EINVAL;
+
+	/*
+	 * Reject anything that looks like ordinary RAM, including anonymous
+	 * folios in CoW mappings or allocated kernel memory. Note that we
+	 * cannot distinguish memblock allocations from non-RAM reliably, so
+	 * we cannot easily reject them here.
+	 */
+	page = pfn_to_online_page(args.pfn);
+	if (page && !PageReserved(page)) {
+		follow_pfnmap_end(&args);
+		return -EINVAL;
+	}
+
 	prot = args.pgprot;
 	phys_addr = (resource_size_t)args.pfn << PAGE_SHIFT;
 	writable = args.writable;

---

base-commit: 634cbf5b794b734c78631b92e381cfc85f357bbe

change-id: 20261009-generic_access_phys-0f3e0806305d

--

Cheers,

David


