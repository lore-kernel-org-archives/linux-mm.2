Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EBCBC44501
	for <linux-mm@archiver.kernel.org>; Sun, 12 Jul 2026 10:44:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D989B6B008A; Sun, 12 Jul 2026 06:44:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D70166B008C; Sun, 12 Jul 2026 06:44:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11156B0092; Sun, 12 Jul 2026 06:44:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9DD0C6B008A
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 06:44:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B496169C35
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 10:44:32 +0000 (UTC)
X-FDA: 84979790784.01.886B157
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 885D8C0006
	for <linux-mm@kvack.org>; Sun, 12 Jul 2026 10:44:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OG39gJMG;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783853070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vGAlEpRQYRhrbsbyFqevUzGTrHwI86sKZ3VuDai3N60=;
	b=IHJsoeYmPG3gcT87gGSVepC/GItook53SpDEpfXSux76Q1E+3fCqcuGjDqGCojX+rIDdKJ
	LyOoCOLhj3+CIK7DDXMrHeG2PoIfz9574eQDK9wBE83UrORA00sL271ws+eO2za3ynP2aS
	cqXUlx4bfV0ZsVxGb4W3mJImAcu8XbI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OG39gJMG;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783853070;
	b=LDarNwgLe0K96Vnyp5BwFP2vJE7VF5TMVhZQDl7zG5XrnFIFY382Cuei6E/UcupO7ZaWQZ
	XhFEScNzaFsd/t0PZ6X8T/aVWRz/yyVyDQA9lTbSbyIQGy3E+LzOfMtl2KtSbWNM4lNnHx
	QmyyqignTPQRzT7vAel8OGHfE5lOE0Q=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F65F6004E;
	Sun, 12 Jul 2026 10:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7AF1F000E9;
	Sun, 12 Jul 2026 10:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783853069;
	bh=vGAlEpRQYRhrbsbyFqevUzGTrHwI86sKZ3VuDai3N60=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OG39gJMG3+GR+z2BP91RhW1g0+wE49EpUq3bCYDPV/qd1d16HjQxfaa5OvRrLt4t1
	 ScfsqVHBbYXGzWg1Ng0Uj61vjOdBG8skAeWgfl7mfu6l7WzjPmPBw5s3GsYjHbHBlI
	 P/6KwDeXesk2Y9ik3ih48WxLLm6+kKD93yq/NveeZMCdB6kOcqbl2f9rI+pyDoYAwd
	 CRwwmI70HYUvVJv4l3pVq9XKKrd27HOgHknKzrBrcIU2KRSA+jkHv+eoW++NJrOfuW
	 3YfKKI6vu+vOm3Kuy+pv3wszW47DA7g5awhjYFtsysatnbJHTTMialqgKQOD3Jfw5R
	 1t1JytAS9BmOg==
From: Lorenzo Stoakes <ljs@kernel.org>
Date: Sun, 12 Jul 2026 11:42:25 +0100
Subject: [PATCH mm-hotfixes v2 2/4] x86/mm/pat: acquire mmap lock on page
 table free to avoid ptdump UAF
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260712-series-vmap-race-fix-v2-2-ad134cc3a12a@kernel.org>
References: <20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org>
In-Reply-To: <20260712-series-vmap-race-fix-v2-0-ad134cc3a12a@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Uladzislau Rezki <urezki@gmail.com>, Toshi Kani <toshi.kani@hpe.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Ryan Roberts <ryan.roberts@arm.com>
Cc: David Carlier <devnexen@gmail.com>, ljs@kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2980; i=ljs@kernel.org;
 h=from:subject:message-id; bh=sQJwBcRAluqgPNbXUgxA0+sFptVnbX0UWpL7em1s+OU=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKC8z/859bu7Nn3SrLd4LHMIr6D0jnXY99ZKqtbpX9kV
 OT/stito5SFQYyLQVZMkeX5F/H9QSJh8zov+LvBzGFlAhnCwMUpABM5/Ijhr6Dyad2m2Y0q1/o6
 318LY3hTsNKyT3Nhxsk5k77/Ot/rfZnhv9vCUB9Bu4mFD7RKpLdoGlw2+/rkXRibwL4ZEbMTvv2
 yYAMA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 885D8C0006
X-Stat-Signature: n3aixzai6yyoy45xcyxi8m86jfidud4o
X-HE-Tag: 1783853070-466435
X-HE-Meta: U2FsdGVkX18ZtAbQUXuFFOo8SihhR4w+EhL0vHg9xSfpm049AOeRN+4eKrzzv9qL4kL08cH28vKEI3cW/rf85gp13vrdJOXLufIR8sH416zupRHQMAryqB9HSze7mQUkdqOtToi3Sl6MpEhoOYonWg/DEJVd6zuviZe9a7aE62NSHF8/2omVKGcwxG3pAghj7PynzjeZ98fJZXHav+iEOZnC5KSfOqG0q/L6lkopNhafo9Dy92pzI2Ra2RHzVCPx+W5swsJpZZYyEbS5NnBH2LlqRCF+R6RzMr/2prOvPmJukKWCMq4ViSJr+wN788jOeoLaO4cxk1ye4bHg4pkrOWGMPPs9rQKTcX8tAHDkqAeNWyFFzgnDUN0Uq332qMtF1syxFfiBG2jAQI2VHqlEAxIvKSDVllRC0l90PJFtjSSfraqPpBAvoLZiwe/CHoJjQpqVhNdXLEQCqi/Sqk7QKVL4clb5/8ZHO3dV1EuRLIg95pwV5mOLFM7zqPFFy02MDDMd7yamrDRQ+1x1DfWviPGTpWr+6N6fkPkmGafE4Q799Qz19QmMMiU5exQHfdYI5ozzWhcXp5E/G18HD8iSTRWMqTea/Sw9eNyB4PnuuMBgcaf//oOrsISHlgxgHFWq8NuanPLFQ9NF/Si9Zu4tSs5gKXuz3x3omOn+G4WE/331314kNYFJNSG2tOFwlcSxDNp3gI74C4Uqgd39eofm2DDWvTQny9ndBFW8AkvNKgsRdpGFZXuQLe3nnMeBqyXSAYuP+h+AfPSgBEeGMsRjXEOpaEilhqp87epRW5+2eIFKmy2kwbk9Cbjz3vY9f4akJ/2wn/RL6Mr0GAb+3nZMfxrFUu+1LgGbnfAL9twnRt2k9LWCWwWe6mvO6akY8G/VpmNCCdrUjajHtC5xluLO40ihWsfVKde1+29YVMr9MBpTASjHNpad0nkUEiGbA2ETQFvnGdoQgQWxDX98pnd
 RaJpd7bd
 /FBFJR/B9CDR8HR/ILpJM/SJLH5H8NmNK4lhsGXTvM2J+klP1u4zvM3fnCDzSXuQSIUY4MavbrhOtrjDSuXdopZIKXWpll32AOjrWGtt3UiGQvzEndjomf5ZJ0XCggf6xCR+S87NLVrSQyMkn07ZGLBQ6NT/g1T2A8Y4rWIhpglqWurFKmE5MpIbzbriSrisagUfnCN6ZsxNZbOas7AyiIRZbFnYHH3B9c8A/Cqg0esW0RKkOKSZEm3Fry5whKmyQB6HQuWdFIdEq0luBu/oHYg2llw==
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
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
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
 

-- 
2.55.0


