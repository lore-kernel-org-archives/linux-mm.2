Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DFB5C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 11:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44E9C6B008A; Fri, 10 Jul 2026 07:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4261B6B008C; Fri, 10 Jul 2026 07:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3151C6B0092; Fri, 10 Jul 2026 07:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DBF26B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 07:57:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A2DBC1A0413
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:57:27 +0000 (UTC)
X-FDA: 84972716934.14.11B989C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id E9FAC180002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:57:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fUW7DbAD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783684645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dieG9UC8DK2iL6zyM2fmkYyIvNrYkz6CFno/58d7W3A=;
	b=TLlR+9qCAyZVa0APUfOSOTevJKDvVosHpSxhFIV+81RYxZDi+FvydMNcfvUoZuB6UHunYt
	EMocaBCVAXFxJcJfxdxWMcHzhN5hyC/QImo6D9U7lp92IRm9/l21k83ABQhfAl8yfgJEFL
	jvg+q2AKJx/+TBBJYuN9y7I6TKa6eVM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fUW7DbAD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783684645;
	b=Y5i/+a+CVCv24gZ7PSnNXs1GsFJD+uR5PzbmdMEdYLdI0gOXSp2HTrjbFfO5cwNNHwtEkH
	0U7D9WT7sUmNLLFosK6V9uSXQ7JbA7a1u1VKbaIjr6Xgh+6IsZhb+R9J0Z5i06XqPXIaGY
	oKMZKSUTkHGz0GqfKTwTHNUH1s6CJVQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 39385600C3;
	Fri, 10 Jul 2026 11:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7C941F000E9;
	Fri, 10 Jul 2026 11:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783684644;
	bh=dieG9UC8DK2iL6zyM2fmkYyIvNrYkz6CFno/58d7W3A=;
	h=From:Date:Subject:To:Cc;
	b=fUW7DbAD/dY8hB9yFnkwjt6yegf5eXnziSTbsCo38yx3/RGgx1ak9f53gyoCTBGvR
	 Y2wxHx17jBby3rdzhh6EKjQ7RscPtUoOlVijTZox7msbOvRRw8EUlB5wOfOID7L+gh
	 NKM4TAbfk0J69ZsxdT0fNBg5+nOOZGUnTPTen4FMeCgT+i4CEPWDu9LxbSj23jQs8D
	 1op0Cltv1ZGANowhSOVcXV6i63vZUVgTt/ITmJ3R3vTW6bgv+h+jVlUOJuO0R+aKlW
	 EFcjW7QxIr/ac/1ZVS71VpsRdUy+ldc66MwWG3bfXJHfO6gf5aYbukAnVaEDOwBrhb
	 djsvRIt4EJUnQ==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Fri, 10 Jul 2026 12:56:40 +0100
Subject: [PATCH] x86/mm/pat: acquire mmap lock on page table free to avoid
 ptdump UAF
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-fix-cpa-ptdump-race-v1-1-d898699a7417@kernel.org>
X-B4-Tracking: v=1; b=H4sIAPfdUGoC/yXM3QpAQBCG4VvRHJta5Ce3IgdjdzAK2y5Scu8Wh
 09933uBZyfsoY4ucHyIl3UJSOII9EjLwCgmGFKVFqpMFPZyoraEdjP7bNGRZlREWVfkpiorA+F
 pHYfZV23a337vJtbbm4L7fgC3dRCWdwAAAA==
X-Change-ID: 20260710-fix-cpa-ptdump-race-0aa3b65d878d
To: Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, 
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, 
 Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Carlier <devnexen@gmail.com>, Vlastimil Babka <vbabka@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, ljs@kernel.org, 
 stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3019; i=ljs@kernel.org;
 h=from:subject:message-id; bh=gx21zkGMFU8tNTBc3mSAQnclVYeMYuGYggt/VeL9ls8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIC7omVvl7usurgiVWfZc1kfKO31EoF39WPyOiY7r/np
 MdlbtM7HaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIoxzDX8G8nrkMc3UN4+t4
 Ksyso1Q4+8U1Auf/XLiR3Tbo09wrLxgZJpfp3T2z7OV1XzbV/k93mD3mZWw6kOOnrH0iqkZCsaq
 KFQA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E9FAC180002
X-Stat-Signature: y69j4bhso8bo5s74jnogtyek91pzeww8
X-HE-Tag: 1783684645-320057
X-HE-Meta: U2FsdGVkX19AxS9GkPDBWJUENLiK63WUqogvosaJ3/0loxP+WudfhpdCydZ1BTYetO3yNmw2bvbkrJxRL2v5OaK2yj3mpuGHZjdhhyKhGsSj24pk33Bj7YKMnEHRwBmwozP/sPJfC5gDUADiDxkLIULfdmnQjkvmrywwSXx+S3CsHbV0cWuBzyOJYTzzhqs+mbYFraKsDI63qmFdaY7Pt1EsPuHWk8rOlDbpkhMpN4dx2CE6aS8DGK8oMXHdnAR1+eZ/FFbbxUuLvAxpykGKHhripXm16M9N2mOfW9VuRZRznheYKFAdX57LqI2wqLk/jUZ9vm2NEwiQFea1Vw+KuZKz+RZBmdzvwYgz5GowbR7yj5dLH7AndGdH5JNCGUCcm91GDgLx7oN5/XLt0HBNAiWsQbkZfjV2iNs2wb7oOB4kqerZalDaHYSBzauAMFK8ZQRMlaXNy0PoAmIgGdv37v00dkZcHrFJgu2O/tmuEKYY0lLQXB49A8J4iTyWBE+nnUb9WisEBcB7mpmxHMXNxuEx+hct6C8XVvRVb0s7tj2ncaUXWPPYAyQaNV0y1G+h1odkvv9VkMLSOqCvTHzhRb43NQFfmxeZfT9XIOiAsrROBx7g7pA6hE2jBs7YvLBYgKtneWfISQqC/LzUEfY7E0K/koUTuUZVe+/jM/X2F9tsBqLCpk01hLnR003p3cUO8PZF7ryp9hwfa+BsXtRSAvmmBRKWNH/F23mPI3OonY867ojPbwLJMROgc7OQDXS9h7GbasF/7kBlo1emoUZx0s/hGxo+4Q6EyxsdUYgf+/0HFdBb9hmEBuLlSqolt0qY9YAKrIUfUAqzR96L8eEpd0egzGoy3oq5Z5NjI+Vbz5SXoO6X9Ej/zvAIa5/VW9V18/XDtu/ZIXGZOHLfhaL4ci22xCW5+WfljVUu1CiJxkmM1hWYSvBUTAl8zoBmhOu2UjR50HSGsvI8rNWCuOz
 bfTdP6PI
 VSuhZcjyvebrZFC+e6uI704ksEjIw874OXCzcrgkwAfvbBU0I3KOKle0o1XvKf/2FV9IuigHYRloTmhPO2LwWdVZduPKR3eK0rTvwf/5vPpqOyciG94DRr3C1HwLSId55v18qc7gnpmVszy0cBJXb1IKSyqlDofkYAtOsTfCqwFpKJVuGfBZuu5Vpb5/BxjGQrMgpcCC6NjYrkFmo9FFqHOfIBT8lrkRurditXPVkxF4rWGPLs/eBUhBbIPHRkOsjntMQjBWsQg/DOLVn1tuzp/wwiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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

However, this is problematic for ptdump, as it walks ranges it does not own
and thus runs the risk of a use-after-free on page tables freed underneath
it.

This patch resolves the issue by acquiring the mmap read lock on init_mm to
provide mutual exclusion against ptdump, which acquires the init_mm write
lock.

It is safe to acquire a sleeping lock as all the callers invoke
set_memory_rox() from process context and in any case,
change_page_attr_set_clr() calls vm_unmap_alias() which ultimately takes a
mutex, disallowing atomic context here.

We also include cleanup.h in order to use a scoped_guard() to implement
this cleanly.

Fixes: 41d88484c71c ("x86/mm/pat: restore large ROX pages after fragmentation")
Cc: stable@vger.kernel.org
Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 arch/x86/mm/pat/set_memory.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
index d023a40a1e03..4c4b8244502f 100644
--- a/arch/x86/mm/pat/set_memory.c
+++ b/arch/x86/mm/pat/set_memory.c
@@ -22,6 +22,7 @@
 #include <linux/cc_platform.h>
 #include <linux/set_memory.h>
 #include <linux/memregion.h>
+#include <linux/cleanup.h>
 
 #include <asm/e820/api.h>
 #include <asm/processor.h>
@@ -436,9 +437,16 @@ static void cpa_collapse_large_pages(struct cpa_data *cpa)
 
 	flush_tlb_all();
 
-	list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
-		list_del(&ptdesc->pt_list);
-		pagetable_free(ptdesc);
+	/*
+	 * ptdump might read these page tables, so avoid a use-after-free by
+	 * acquiring the mmap read lock on init_mm (ptdump acquires the mmap
+	 * write lock).
+	 */
+	scoped_guard(mmap_read_lock, &init_mm) {
+		list_for_each_entry_safe(ptdesc, tmp, &pgtables, pt_list) {
+			list_del(&ptdesc->pt_list);
+			pagetable_free(ptdesc);
+		}
 	}
 }
 

---
base-commit: a635d6748234582ea287c5ffeae28b9b23f91c7e
change-id: 20260710-fix-cpa-ptdump-race-0aa3b65d878d

Cheers,
-- 
Lorenzo Stoakes <ljs@kernel.org>


