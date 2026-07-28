Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8784FC54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 13:08:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71DD96B0099; Tue, 28 Jul 2026 09:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D01B6B009B; Tue, 28 Jul 2026 09:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BD176B009D; Tue, 28 Jul 2026 09:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 203366B0099
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 09:08:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A2B2B14037D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:08:25 +0000 (UTC)
X-FDA: 85038214170.24.E7E894C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id C8AD51A000F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 13:08:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lkVctXdO;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785244103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z6kR497LjC7Isvr03okKrlj74MLRITXjjuRFnxSRHOw=;
	b=cy1aKaSLWrh84GT+q2fRkyWJFzBsJ4ysWLGj1oPVA6Co5ZISlu40FTOdpHUvQrzETiBNJ/
	oF3kuf5fjv5uRmQzG2wV28aEQJniFFlfbP4+d8yTwwj71Wp6zQtqHa7iosU9EAs5UsOc/y
	b+dRY6f+8EnTXyj/WzNVHk1Yxf7b7v8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785244103;
	b=At5HupPxfR85pdnDz7c3bv7nqETJfjODY4E9JCGMO+5mHNPkPNNxH3KxVIPclYP2pSntkZ
	r2EWXC975K8bDWyBGjpiMXvDOrs34Oz8E+GVT743wXSuZjqNrGZU4sNO9LnBVtonrSHYPJ
	0LfFrf07UHMUVgHPc7dfjl2qEaie3qA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lkVctXdO;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 523A360A96;
	Tue, 28 Jul 2026 13:08:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0692C1F00A3A;
	Tue, 28 Jul 2026 13:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785244103;
	bh=Z6kR497LjC7Isvr03okKrlj74MLRITXjjuRFnxSRHOw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=lkVctXdO80DTaLpIRkVUNPaBSSApcMdOEjwGOtWKWkmUaJkBC2uenMket0s0+WK+J
	 qTU2b4h1fS76z1+BcoV+nXD1jokWc4Q75GzqaJk/fzbQbRLt/zhxBM+bEY7fykoTor
	 4WRIpmFOp61kxIYTDeLHD8DyJnWLF3jKgtl9yoh+6oG9D2fAMp4y5aWgahNyjkUet0
	 7gH3rlRAr5V7wVuKeildwuQTH2IpBnJ1T67rSxZHP6K4raL9pwTFSFTkZn6/G1i4bv
	 y1BSGF0PnqNg4eE/SU78DganA84psQAVYfEmnZlG5sbg36lAUorwUcutXzBn/yOMwT
	 IpmJaUtdaoQ2g==
From: Mike Rapoport <rppt@kernel.org>
Date: Tue, 28 Jul 2026 16:07:45 +0300
Subject: [PATCH 2/5] x86/mm/pat: acquire init_mm write lock on collapse to
 avoid UAF
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260728-cpa-fixes-v1-2-2ed2352300b3@kernel.org>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
In-Reply-To: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, 
 David CARLIER <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>, 
 Kiryl Shutsemau <kas@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
 Mike Rapoport <rppt@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Toshi Kani <toshi.kani@hpe.com>, Vishal Moola <vishal.moola@gmail.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 iommu@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 stable@vger.kernel.org, x86@kernel.org
X-Mailer: b4 0.16-dev
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C8AD51A000F
X-Stat-Signature: bmow8j8b6fw4zg58r8i1mxpmirxjydas
X-Rspam-User: 
X-HE-Tag: 1785244103-874434
X-HE-Meta: U2FsdGVkX1/P/aladz00aausRPiETFCebKuzSZ3BJu4gIDB9Tky+nU+bFA9bNhCQPCb9Omui7TtMqJEWorPaKUlkXFj39hQqgpKOiebmheRtKxI9IISH7L2MoVMKHhMXcgtVWdB0GXcw7gV/gH1NknqAyB29w7zkgqDkz78Jv6Ih4HBVBfiQ/JmJXCsWFMd09wnsrOhLQ6Y3Ubu/ZS1KKO4mY5bhA97y13HJlrZTM1GmvhMOBm/Lw4u1QzCqpcN+L2kUKUP9O5TSajcHVfJn5P/08A124FYOaMhFKCZB+ANSBnD7UVz5HKZ8r6NKHDDJ9wu6eG2VMrOxEwpQAuvNm3+0b8BAMNiKa7W/k8xiNHKIaVcjELqzmfDI4ZjdCfGDp5yyLvWXUsTMDt0ZKyM1Mkas73mSsrWkhAHviHNeR9+NiH2cFgINDH/MANOt+SxSL13f7EkIcWAaDKiAE8Yxy5jTA/JDV5t2VQHKTsZB/QsPuw1tkIhjetMuMgKdAGsENJ8hPucDIqDRE+YeIJjwY10fz6rxCbFw688OMfBQHiv2mZYAniVeHwWTOJALR8zBy7CWWm7cLnRYOSiBNAGpuPJlvx/zdz1t7cYtZA+zhQTbzJMWIq4CO6NHI5tEzgpfm1TnDqHSM+ofK7eCnSdvVfDccGZF111+F9tSQalgRaEwTRc7sJeaITvElqxK0ABPJnb48Xeu72JvvzARO8et/4RNh9cjRN9BmKVf0WVuOT2vbOoxw1yRpdNsL5jfTfkWcZ1MwFYiSNEHlv1n1vttewjMJbCxd+Bc5PR+fz+u1nSVrfRkeW2q8cP8uHdIGfoZV57xyKwV1h7X23x8LJt2YYm5lf1vaQdlWBOCXgxDNwGb1HCQEJr0V3mPjAiQ4tH7fWWDb9k2hYLU2oWo+ev1yq0Sx21onURkpFWPNz3B6Amhlticmbv10l95NMW85DdXH4fzFbn+ojOlVDiNAGb
 B554i1bk
 oYRQl93MRf/G9Yk/wvhnrkSGoRddsGu1Jfz27qtoImBmdQYGjCrwxsngoFq8J941VxHuAYceSXG8qR9+mQwG8trlwCyOtkohVCaIEWGOH3YbxRoEfpy8bo8UYypwLYoKU64SjkUNKI5bCZgvdQREaBmRWocvXLqCdmn0ykFTVN0yvsS6iK3CPOmuOrz/zLMDRSd10q9FnfkW2TI0Gmnkrru3xylF503Aj3PG/K4CS4/pElZ5OlMZUIObd1u7HI2YKYYWCErpN9thBkx0YlRszTpUzsnYa5z7N+UV5XmIfuMu7MBUmDJ4bo1B+HhsXXLA80fRPoJd2qdu80UvDJbDXd6s1YUZl4DdLdIDGeIjftn47u08zPZ/Zmogk0mnDAI46bzekcD0PZriKsNr0djpVzNUUzexvLpA8esDp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>

x86 implements page attribute modification using its Change Page
Attributes (CPA) mechanism.

This tracks properties of ranges such as cache mode through x86 page
attributes, and as part of that logic manipulates kernel page tables.

Since commit 41d88484c71c ("x86/mm/pat: restore large ROX pages after
fragmentation") ranges of kernel page table entries can be collapsed into
huge page table entries as part of this logic.

As part of this collapse, it frees the page tables which the collapsed
entries previously pointed to, and it does so without any relevant locks
being held to preclude concurrent kernel page table walkers.

The only way this code can be reached is if CPA_COLLAPSE is specified, and
this is only set in set_memory_rox() via:

set_memory_rox()
-> change_page_attr_set_clr()
-> cpa_flush()
-> cpa_collapse_large_pages()

Notable users of this are execmem and bpf when manipulating executable
mappings.

However, this is problematic for ptdump as it walks ranges it does not own
and thus runs the risk of a use-after-free on page tables freed underneath
it.

In addition, concurrent CPA collapse operations are possible which can also
cause races.

Resolve the issue by acquiring the mmap write lock on init_mm across the
whole operation.

It is safe to acquire a sleeping lock as all the callers invoke
set_memory_rox() from process context and in any case,
change_page_attr_set_clr() calls vm_unmap_alias() which ultimately takes a
mutex, disallowing atomic context here.

Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
Cc: stable@vger.kernel.org
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Will Deacon <will@kernel.org>
Reviewed-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 15 ++++++++++++++-
 include/linux/mmap_lock.h    |  2 ++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index 4c8922695fd3..4ba16d72a535 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -22,6 +22,7 @@
 #include <linux/cc_platform.h>
 #include <linux/set_memory.h>
 #include <linux/memregion.h>
+#include <linux/cleanup.h>
 
 #include <asm/e820/api.h>
 #include <asm/processor.h>
@@ -426,7 +427,7 @@ static void __cpa_flush_tlb(void *data)
 
 static int collapse_large_pages(unsigned long addr, struct list_head *pgtables);
 
-static void cpa_collapse_large_pages(struct cpa_data *cpa)
+static void __cpa_collapse_large_pages(struct cpa_data *cpa)
 {
 	unsigned long start, addr, end;
 	struct ptdesc *ptdesc, *tmp;
@@ -464,6 +465,18 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
 	cpa_unlock();
 }
 
+static void cpa_collapse_large_pages(struct cpa_data *cpa)
+{
+	/*
+	 * Take the mmap write lock on init_mm to:
+	 * - Avoid a use-after-free if raced by ptdump (which takes its own
+	 *   write lock on init_mm).
+	 * - Serialise concurrent CPA walkers.
+	 */
+	scoped_guard(mmap_write_lock, &init_mm)
+		__cpa_collapse_large_pages(cpa);
+}
+
 static void cpa_flush(struct cpa_data *cpa, int cache)
 {
 	unsigned int i;
diff --git a/include/linux/mmap_lock.h b/include/linux/mmap_lock.h
index 04b8f61ece5d..f4ceb968aeb3 100644
--- a/include/linux/mmap_lock.h
+++ b/include/linux/mmap_lock.h
@@ -621,6 +621,8 @@ static inline void mmap_read_unlock(struct mm_struct *mm)
 
 DEFINE_GUARD(mmap_read_lock, struct mm_struct *,
 	     mmap_read_lock(_T), mmap_read_unlock(_T))
+DEFINE_GUARD(mmap_write_lock, struct mm_struct *,
+	     mmap_write_lock(_T), mmap_write_unlock(_T))
 
 static inline void mmap_read_unlock_non_owner(struct mm_struct *mm)
 {

-- 
2.53.0


