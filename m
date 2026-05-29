Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5610BCD4F54
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ACFF6B00BD; Fri, 29 May 2026 13:23:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 484A36B00BE; Fri, 29 May 2026 13:23:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39A236B00BF; Fri, 29 May 2026 13:23:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 27E256B00BD
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:23:46 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C41881C0369
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:23:45 +0000 (UTC)
X-FDA: 84821129610.16.25A8893
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id E878D20007
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:23:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eSpSQgsD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780075423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RPrn2/bxAVyENuntwWUEW6oDZF8UkuB5Ook8E7BZnh0=;
	b=70AFvTbxDbsOoKoB+Fp5Rp26wShJH2F6ejSUJEsePlC3A4F/9po/PSK/Mmfkxy5v+sbmg6
	jEDG3euLMoGbsOCn2g8tcMiskVQgjwsGzy39Xz8H8NpqmTevFt1Wbs+MW02Ib7ESef4u9p
	VYgBRHDX9FbJDGBHIlJ8X68eV31MVKA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eSpSQgsD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780075424; a=rsa-sha256;
	cv=none;
	b=OdBEWDUJajjiFjzRbSku4R5fDW3xnar7RSOi0EzfNF9y/GpNIZUqjP/84hrzcoLqCILqx6
	9d5tBfJ4dXG9C2y4kMmod4+TNLWrgghrA2U6Dc/6Ik93iyfx52hCJE5MRWNhr1My9e++vc
	fGmKbCZtrmyYC1XSSVmnXYayN9JYrjE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 521EB605D8
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:23:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30F71F00893;
	Fri, 29 May 2026 17:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780075423;
	bh=RPrn2/bxAVyENuntwWUEW6oDZF8UkuB5Ook8E7BZnh0=;
	h=From:To:Cc:Subject:Date;
	b=eSpSQgsDWD/S4laLkkqVNvGY8mXwFU6KJ8xIYMxc86ZeJF5RRX/Ys1yMG0pj4Gfa8
	 uX5w/TvUpeIYg4IH9dIdvMVhoVYgdFfOnVO2gdEtmnI7XOyPrExE0riXNNr3dEpMNj
	 n5jpGKkhzZJILdQ4VWrMWlnx+2p60dyDZjqY46l5R7xDfxpy85SyOfFa/SqaHCzRdy
	 RMn5Yj981kOTYlbGrLSaeYFp8NHhLGCVsquJ7ZMbebMMoBCwCtGs/32OqKa5I/bkve
	 nzSkwrTrDNJi60r81rKm3dEoYok+WeD5Qo8Y8hmDxCeB9Z51u8alLU2fsnoF81hNtG
	 5STWmS8NHXnqQ==
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfauth.phl.internal (Postfix) with ESMTP id 16383F4006D;
	Fri, 29 May 2026 13:23:42 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Fri, 29 May 2026 13:23:42 -0400
X-ME-Sender: <xms:nssZahM9Gg5khnXfxnwbzs8zhQnkU9rCGjrVH0bkm-Jlk0r_PX3P2w>
    <xme:nssZamMXXVoyaj2vSm6CrYH-WOqTJ-k0yfQOxvf584bG9iim9-b-YDpXiSUitS1K7
    9u4xdwrL1MFVAXehGH0F_0zkITMPaSyXlCeXirhgeKRIok04he50XE>
X-ME-Received: <xmr:nssZaijDLXHDaWxU6dQBdyWK6GGr6GJCd9VDqXHgPYeIrHo0IuJ-o3rP9sVU9Q>
X-ME-Proxy-Cause: dmFkZTGJO121lzqEjzVUUb/I3hYGcVW+idk06I4e5a8zkge8Oc9/f6cR3X2tUT4kmpvjEB
    vl1JWnyaesWx58xQ0U30pPFukXTVTzQwvp1dlT7tqH1Fx9m3bOUQ8gMGXOiPMkSTWgyItz
    0Cvz/Ngwan2IDdcuhND+uh5UOTVg9QE3hbZMB+1+InbXEST2DmWQDCr5YeVUAKztEqr/wF
    BP0BW7ojMsW/NH5Q1K3Onhv/GSQ5TG8AWBbGQ8u/5evo1gMBkLI+NJZ8SZbPAXzfN/57yo
    pmcV9Ai5RG3hj5OUDLot5dir6V8vdH3VgVc05DIW/9p7mY7yiG+xQF6KZmCz6JknepqcSU
    Gye/qUYv2XQmjyTeIBp/Kix3+21JhlJMUVgOGsvs7Mc6MfaV2L0vB+YnkhFw0ehcWq7fB8
    aCBQXxA5iIPs8bryVyqtcVyXn0mXewd9Hyqx0jHkAFQSgmJcBmjTQvvtDgQTmrho6nGlqY
    ZDJQ3fpWO+PoS4tjHY97YKUOBBK7VhjCMMSWJxhkXCpPJDEjl1pRdcc7Yqp52bXgrXIRCI
    MZ4Y9JHnzpJ9o9zFzmhCiLT3+i7KUo0ZUAGtJ5g6L7ce6P8CfVydGit0e3rhJsZ4GwPyO2
    TbUiwBL/WrX6lnmRsWytDYUeTypzmK/wlwcveIu4cuqWk7jz1MxLd0dS3hKg
X-ME-Proxy: <xmx:nssZajt2YXXSeIEVHNL8zzfGGGmZoNfs1XmaxDK_Vfri5-oKbddiEQ>
    <xmx:nssZaoQt0frVZ7wnxb_OVVYZIk2x4ktPv2-GQiQlSj-_GtV8LR1O4A>
    <xmx:nssZav1Y8nl07NTvQrN3dlVNI3ChOfD3ZDjpErjR6M8FCT2iC25JZQ>
    <xmx:nssZaluNOYtaB8jkd5x_i0YArmTj708i487LdK_7uVJiVEwWW6NTRw>
    <xmx:nssZatjszcQgkpEIbOevVV7ekK4PvkiU1ZfiHpXEaecvVaQ5fuc-qHvm>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 13:23:40 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 0/6] userfaultfd/pagemap: pre-existing fixes
Date: Fri, 29 May 2026 18:23:24 +0100
Message-ID: <20260529172331.356655-1-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E878D20007
X-Stat-Signature: mtb585d3xx9caambeu8h7gyfrgs7mnm9
X-Rspam-User: 
X-HE-Tag: 1780075423-976398
X-HE-Meta: U2FsdGVkX19rGzrZJXrDLaeywi9MpCKX/Pf0+dF9Cn0wVa9bCF0MiEXn3aoSHSsSb3exHYZ5/C/yvER0k6NVx5Ikk7Cqjm00/xwwtwtaMYON3mcb/t/zqh7hChXWUDZkbvfbZXH7uTW1bj/4VynWNnIfPtxZDuA/FLXBTP2KbTYjey+Id9JkDjzcVSZU2puNGwHw1iiNYL/Mb6WG7nayJ/35Pc7tHsCp52CEScHlrf4+2NDlAUVQqeXVBYYoAdHnpL8YzYfhtO0lvgZIG8IM6zIse0nnoV05z8TdFJ9LOj1GdXEgPZ+VdEbhfrK7X1NlgCG1zvNPs2LsFPQG8zzbmRidrFjbGo5E8zPrdj5pCFZWT61lvFrP8O37nf/VJUNJ8982MQpdSxAQvN8z/Bouky9Uo1UzlvzeQn/yTxMCGmNswOGK6aNQ7fEf9yIyyblmzJIAWW9fVoO51zbQB+P0QpJLjJdPWi9zvL1iKi5uJTvVuMYmVMqa+7HVPBUKD1G3LPQBhnYYl0EnIkWUiW3TfZ+7ZuxduqpDwl/vgEYY3J+lgQk01MDwyXOMhTyKdwUV03sCcN+kn0SVm5HGlORa/CQETfhVD6HdCKcx5HnyYPnZpsmFH1eAodonBmVa2VgluuIKRXG4OYELmhNmJDMJHWeBS9nrvnrqL3aMSQ6gSA9szJaQmqMWSoEx8HY9XeHK5ysdkjEQffaTSA/qwetBMjzh7VTbbI1TBl47/MylVq52xug091SRpHzrkun4ieRglEOvYo9y4ZPkBAZsmOlj+mbdFaQL8CKPeE0bCmWBq9M3MocaukxurKEvnQCJcK6Nwouz1cWXw6V7UzpxtwUjjMhyMmskZmSmXfqOommlHs1BMQGEz1F6gg/vGt/6F+AVplKs7kO8jQ9MfFbseO9ucpzOJNZ6T8RK74VmUBXuKPzMLyKiLQaMJDcSO+uomPYiKY4UmJgcnpJ684fV7QO
 e86Oo5VF
 QGJ+IKtjF+6HNlvE0uZWrgjROjsNoBSdv0j3Nw6dwfWi71rAy9s8Fz7pC0KNN1st6Brcixfsz9klL6clVg5LowCe4ZU7S0d//kNAI0DLh+p/Ei0rSfwLn7Mta3P67JKkHQ1BhTRgeYd80rvYpOGDxzvEbdVGRFom47FXGdYheaYqN3wQVdIOb9PRGvPbzsabBCbLJltidLWTZc6OO5Msyvc5wi7LcTq21Mgy3E4UhY42FjYV/bej/BarOouvNHQxXatNCXkaWAx/6cETHMs0SwcNGWywW1UU+MpA8AobiX/plB8JxUv6gPnnpz/iYI9WiOvf3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

These are pre-existing bug fixes that were carried at the front of the
userfaultfd RWP working-set-tracking series up to v5 [1]. Per review
feedback that fixes should not sit in the middle of a feature series,
they are split out and sent on their own; the RWP series is reposted
rebased on top of this.

All six were flagged by the Sashiko AI review of the RWP series and
carry Reported-by: Sashiko AI review <sashiko-bot@kernel.org>. They are
independent of RWP, apply to mm-new directly, and carry Cc: stable@.

  1: fs/proc/task_mmu: a missing huge_ptep_modify_prot_start() in
     make_uffd_wp_huge_pte() can lose hardware Dirty/Accessed updates
     when PAGEMAP_SCAN write-protects a hugetlb PTE.

  2: fs/proc/task_mmu: pagemap_scan_hugetlb_entry() compares the range
     against HPAGE_SIZE rather than the hstate page size, so it never
     write-protects gigantic hugetlb pages.

  3: fs/proc/task_mmu: PAGEMAP_SCAN with PM_SCAN_WP_MATCHING over an
     unpopulated hugetlb range self-deadlocks -- pagemap_scan_pte_hole()
     calls uffd_wp_range() while walk_hugetlb_range() holds the hugetlb
     vma lock for read, and hugetlb_change_protection() then takes it
     for write. Install the marker inline instead.

  4: mm/huge_memory: change_non_present_huge_pmd() drops pmd_swp_uffd_wp
     on a device-private PMD permission downgrade, silently losing the
     uffd-wp marker.

  5: userfaultfd: must_wait() applies pte_write() to a locklessly read
     PTE without checking pte_present(), so swap/migration entries
     decode random offset bits and a thread can stay parked on a stale
     fault.

  6: userfaultfd: __VMA_UFFD_FLAGS feeds VMA_UFFD_MINOR_BIT (41) to
     mk_vma_flags() unconditionally, an out-of-bounds write into the
     single-word vma_flags_t on 32-bit. Build the mask from config-gated
     per-mode masks so an unavailable bit is never materialised.

[1] https://lore.kernel.org/all/20260526130509.2748441-1-kirill@shutemov.name/

Kiryl Shutsemau (Meta) (6):
  fs/proc/task_mmu: fix make_uffd_wp_huge_pte() prot-update race
  fs/proc/task_mmu: use huge_page_size() in pagemap_scan_hugetlb_entry()
  fs/proc/task_mmu: fix hugetlb self-deadlock in pagemap_scan_pte_hole()
  mm/huge_memory: preserve pmd_swp_uffd_wp on device-private PMD
    downgrade
  userfaultfd: gate must_wait writability check on pte_present()
  userfaultfd: build __VMA_UFFD_FLAGS from config-gated masks

 fs/proc/task_mmu.c            | 73 ++++++++++++++++++++++++++++++++---
 include/linux/mm.h            | 39 +++++++++++++++++++
 include/linux/userfaultfd_k.h |  4 +-
 mm/huge_memory.c              |  2 +
 mm/userfaultfd.c              | 20 ++++++++++
 5 files changed, 130 insertions(+), 8 deletions(-)


base-commit: 449a5df98f8dffa9b037e3b6838fc5af327df072
-- 
2.54.0


