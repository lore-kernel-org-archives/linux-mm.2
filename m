Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0C5ACD5BAB
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 00:35:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA7886B0096; Thu, 21 May 2026 20:35:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7ED16B0098; Thu, 21 May 2026 20:35:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 994BE6B0099; Thu, 21 May 2026 20:35:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 878666B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 20:35:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 21101120910
	for <linux-mm@kvack.org>; Fri, 22 May 2026 00:35:53 +0000 (UTC)
X-FDA: 84793188186.22.6097879
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6CE8E16000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 00:35:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NdIPAQ7w;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779410151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yljY8YQyXmVtcHk2rKuFniU/EGNik4faj4r2Y5gPpNE=;
	b=1rVXv4km8gJwIzf1xy4egcruUOKko5xHbMDYVVFGp887CfKNqd3SvCBmuQTIAFF8h2OQky
	M+ovV2ymYx8DXmAjDJXgo/LdHrvc6q1Kc9QR8jA9tqMJoroasP0hs4o86Bg9/JbiUosfhR
	r4exQ96Zn6n5h2wdK/5XF6WQQmbMMwk=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NdIPAQ7w;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779410151; a=rsa-sha256;
	cv=none;
	b=3Q0reKorCV4qS7crVVbgZqVo+UpZba2osxVV+YeRhJoygfROMy9mO7l/WbR4kLcMgncoEr
	C7B3SyVYzR4C+l1u7lkw2kzs5GJ4dX0nppSmj6HiyYsiEFPcr1PMchqKy1U6lAuQYn3fDD
	J4Ow6JxFPFiqt3XXicCH6feutCxPJNc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BE05360138;
	Fri, 22 May 2026 00:35:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0714C1F000E9;
	Fri, 22 May 2026 00:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779410150;
	bh=yljY8YQyXmVtcHk2rKuFniU/EGNik4faj4r2Y5gPpNE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=NdIPAQ7wkTRT8DsRoisNUDzR0BsNKEEoUpDrQYPem0wQskvvSQQN6y+EEHdjh+w5p
	 RTyTwMbZWwUA/FIlWMPQvS4gcbIV8a3CpDPkRWPTV342je1rucse2JApFOeRssfP3/
	 IOWujqDHkDEXnezGBWbRuDWc/a61l6X6xW4hxIG0=
Date: Thu, 21 May 2026 17:35:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Dave Hansen
 <dave.hansen@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Thomas
 Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
 <bp@alien8.de>, x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>, Jason Gunthorpe
 <jgg@ziepe.ca>, Lu Baolu <baolu.lu@linux.intel.com>, Lance Yang
 <lance.yang@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/mm: fix freeing of PMD-sized vmemmap pages
Message-Id: <20260521173549.d5aa510a710b4d77c3f7afeb@linux-foundation.org>
In-Reply-To: <32fc4c35-acdb-4202-8369-ac0fe00c5b86@kernel.org>
References: <20260429-vmemmap-v2-1-8dfcacffd877@kernel.org>
	<0c20d1e6-1a39-42c5-8c94-9bd2222fb6b3@kernel.org>
	<20260508092341.GP3126523@noisy.programming.kicks-ass.net>
	<32fc4c35-acdb-4202-8369-ac0fe00c5b86@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oocor6ond4c19q71so3iqrugc6kkoeg7
X-Rspamd-Queue-Id: 6CE8E16000B
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779410151-606797
X-HE-Meta: U2FsdGVkX19qUTyecsdHSuPLRaCNEELNsVjFi+iH1D0YdVwIod3cl09dgQqUV0YR8Qhys6vi0KXAHvvQDBKDjq5foap1jJyW00+O/daKOSrDIqEbaTH6u4D8Dnog6/kVxZsPF2Q0XzLT55yaaiWRdPNHEDriulI7y0PJN+c9RrORVx2idnNm2Yx5ZA7cT57xa+W88iN8GP5jN/es7ulctAe31AAKE3JgWN+NzoMdDePH3vdn2iJ9l/Gm0bLyRfhZ1z1SXBmX3J2iXdpt81xOvUmzCy7QsJcKOOf2neGHDXfw6XmucpPDguNy9qi/GDczG1sZ5bLf2s/d3XvuMps71hCUXgJ6UbL73ppMXriiO3WmjaUxvpWyGIftnyp9mPrdSwuRVnxVRprQKGQuPRMb9awxcFglaffBTAyAg8CX8XbOkfM9RHpIUhcqVhIA3YKzaf2UFWq3fLsXRlWWv7oPYPug1BbRTA7PUUO2b4US+MQjsiiZRg3eetrWY8oGHc4jVfta2jO0WuUyuVg+aoiRzhE4N0isDSUiDBGA0JfIUo2HDGV4DVd4fafGWCJYPRUM6uHK24xN+FXLj1PISDQIsmWIw+2Q0OOdmPENx2bDLowRQXwi8/SLF5EM7+bvoUw1tPe27B4Z6t4pNmY7ehjZV7mWXm+y0AveK4yahddZ0ZZTE/AxCKL5r9Zz5S4RH7l4PbzNC16xOu6lPWQyFi4H2qiN4u02cR/uf+eSK5uBlbw4GrNEjiPGVz0sQj5x9jll/lp87/zwEP2Luz1TH4d6KUQQ9R1HDeTuIJlyW/uI7QG0EmVKzsUFeoj01hykf/QXsZTWvePrXTdIluBAUNYz1r1aKBu1wUdYXdE0z51SlTe2cULhzwZSc+QTdwf7e2uMaE9+axqaRe+ai7GnqWUdoMVectLjCXhURys9+7jczd4gH8llBD8qaHe1VJhOy15lPP9O7xZYFZws4qi+mYG
 /0J/NsnT
 L47Y0+mPKYa1NA40tZPj+gaeeHE8GRTO/fCZ8rf8ZG/RRrJCZJrUzb/XCU0WaROSZv/c+CxtEQAcHZ9vyzkJQpo9c11KKXtHbH/XjccH6O4pM9rK5Q3sgCcV8lNcZrbGGsFqDRBkhwiVuoWqsDqcqOVezS0ST3gjwk+n/5O2gNwGb6vumPp2/U7jTPwildIH+c49580oFdtXGLyGfArkDK7ZhUbKx09PeVlo4Lp5fMsFhN0GFqWJx178ZFi40RZBLkwpbfgeeBluiuE+Ma/9khz4HgBtDqmgVX9nvrzUc897snSSJRIsketsW00qjwR1H8VdXO29sZlqxPMnrb9k0SxzlIveB77mvwqcZYF7v0DPSgUdJj8Yy5s8dBJMPSlMWtrOla8ZwKKEFunm9A8KHIxahH+t9ZJdFE98+xRVvj/1BZnuUcg4pSvkuPMVq2HlqJf77bBxyc2yh8OhomH80/K0NSTs5uKGo1sQhGgjhnB+bBbPftFHUO3bsJgXxBdqBd5KBKZ9vDCIsJiHJEibT/Z179ltkSTG3qAot8MGYsujSLWn2r67a7WZz4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 8 May 2026 12:51:31 +0200 "David Hildenbrand (Arm)" <david@kernel.org> wrote:

> >>> Tested-by: Lance Yang <lance.yang@linux.dev>
> >>> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> >>> Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
> >>> Cc: stable@vger.kernel.org
> >>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> >>> ---
> >>> Reproduced and tested with a simple VM with a virtio-mem device,
> >>> repeatedly adding and removing memory.
> >>>
> >>> Found by code inspection while working on bootmem_info removal.
> >>> ---
> >>
> >> @x86 maintainers, do you want to take this through your tree or should we merge
> >> this through the MM tree?
> >>
> >> I have another MM series coming up that will touch this code (no fixes, though).
> > 
> > I'm thinking this should go in rather more urgent, yes?
> 
> Yes, please :)

I'm not seeing this in linux-next so I (re) queued it in mm.git's
mm-hotfixes-unstble queue, for a 7.1-rcX merge.


From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: x86/mm: fix freeing of PMD-sized vmemmap pages
Date: Wed, 29 Apr 2026 12:49:14 +0200

In commit bf9e4e30f353 ("x86/mm: use pagetable_free()"), we switched from
freeing non-boot page tables through __free_pages() to pagetable_free().

However, the function is also called to free vmemmap pages.

Given that vmemmap pages are not page tables, already the
page_ptdesc(page) is wrong.  But worse, pagetable_free() calls

	__free_pages(page, compound_order(page));

As vmemmap pages are not compound pages (see vmemmap_alloc_block()) --
except for HVO, which doesn't apply here -- we will only free the first
page when freeing a PMD-sized vmemmap page, leaking the other ones.

Fix it by properly decoupling pagetable and vmemmap freeing. 
free_pagetable() no longer has to mess with SECTION_INFO, as only the
vmemmap is marked like that in register_page_bootmem_memmap().

The indentation in remove_pmd_table() is messed up, let's fix that while
touching it.

Note that we'll try to get rid of that bootmem info handling soon.  For
now, we'll handle it similar to free_pagetable(), just avoiding the ifdef.

Link: https://lore.kernel.org/20260429-vmemmap-v2-1-8dfcacffd877@kernel.org
Fixes: bf9e4e30f353 ("x86/mm: use pagetable_free()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Tested-by: Lance Yang <lance.yang@linux.dev>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Baolu Lu <baolu.lu@linux.intel.com>
Cc: "Borislav Petkov (AMD)" <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/mm/init_64.c |   40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

--- a/arch/x86/mm/init_64.c~x86-mm-fix-freeing-of-pmd-sized-vmemmap-pages
+++ a/arch/x86/mm/init_64.c
@@ -1014,7 +1014,7 @@ static void __meminit free_pagetable(str
 #ifdef CONFIG_HAVE_BOOTMEM_INFO_NODE
 		enum bootmem_type type = bootmem_type(page);
 
-		if (type == SECTION_INFO || type == MIX_SECTION_INFO) {
+		if (type == MIX_SECTION_INFO) {
 			while (nr_pages--)
 				put_page_bootmem(page++);
 		} else {
@@ -1028,13 +1028,24 @@ static void __meminit free_pagetable(str
 	}
 }
 
-static void __meminit free_hugepage_table(struct page *page,
+static void __meminit free_vmemmap_pages(struct page *page, unsigned int order,
 		struct vmem_altmap *altmap)
 {
-	if (altmap)
-		vmem_altmap_free(altmap, PMD_SIZE / PAGE_SIZE);
-	else
-		free_pagetable(page, get_order(PMD_SIZE));
+	unsigned long nr_pages = 1u << order;
+
+	if (altmap) {
+		vmem_altmap_free(altmap, nr_pages);
+	} else if (PageReserved(page)) {
+		if (IS_ENABLED(CONFIG_HAVE_BOOTMEM_INFO_NODE) &&
+		    bootmem_type(page) == SECTION_INFO) {
+			while (nr_pages--)
+				put_page_bootmem(page++);
+		} else {
+			free_reserved_pages(page, nr_pages);
+		}
+	} else {
+		__free_pages(page, order);
+	}
 }
 
 static void __meminit free_pte_table(pte_t *pte_start, pmd_t *pmd)
@@ -1118,7 +1129,8 @@ remove_pte_table(pte_t *pte_start, unsig
 			return;
 
 		if (!direct)
-			free_pagetable(pte_page(*pte), 0);
+			/* We never populate base pages from the altmap. */
+			free_vmemmap_pages(pte_page(*pte), 0, NULL);
 
 		spin_lock(&init_mm.page_table_lock);
 		pte_clear(&init_mm, addr, pte);
@@ -1153,19 +1165,19 @@ remove_pmd_table(pmd_t *pmd_start, unsig
 			if (IS_ALIGNED(addr, PMD_SIZE) &&
 			    IS_ALIGNED(next, PMD_SIZE)) {
 				if (!direct)
-					free_hugepage_table(pmd_page(*pmd),
-							    altmap);
+					free_vmemmap_pages(pmd_page(*pmd),
+							   PMD_ORDER, altmap);
 
 				spin_lock(&init_mm.page_table_lock);
 				pmd_clear(pmd);
 				spin_unlock(&init_mm.page_table_lock);
 				pages++;
 			} else if (vmemmap_pmd_is_unused(addr, next)) {
-					free_hugepage_table(pmd_page(*pmd),
-							    altmap);
-					spin_lock(&init_mm.page_table_lock);
-					pmd_clear(pmd);
-					spin_unlock(&init_mm.page_table_lock);
+				free_vmemmap_pages(pmd_page(*pmd), PMD_ORDER,
+						   altmap);
+				spin_lock(&init_mm.page_table_lock);
+				pmd_clear(pmd);
+				spin_unlock(&init_mm.page_table_lock);
 			}
 			continue;
 		}
_


