Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B28BC531C9
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 17:38:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB6606B00B6; Sat, 25 Jul 2026 13:38:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C40396B00B7; Sat, 25 Jul 2026 13:38:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B08C36B00B8; Sat, 25 Jul 2026 13:38:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63EE46B00B6
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 13:38:35 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C7BBC1C05DF
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:38:34 +0000 (UTC)
X-FDA: 85028008548.09.A0F9AA3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2A479120009
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 17:38:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hbLGkWpN;
	spf=pass (imf29.hostedemail.com: domain of deller@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=deller@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785001113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QylY0Jj+M9aiGs5V5SL5IjP/iHtiFsye8Zowe/lAKfs=;
	b=nbnkhaJQ+5DcF1Fm+5s+sXyLIN352rW+mKgupuicPu5Dc3tn7jh2qcnziji7VTUd/H2d6T
	UJEKEl6sBU08DFKXG7rbyg2qkefAKkZaBBpfZrafIoz0x0f0d3uX4Qrk8CJAN/aUIlxxmY
	c3dymKY/zwEizq6XRAES2DklCrr4ens=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hbLGkWpN;
	spf=pass (imf29.hostedemail.com: domain of deller@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=deller@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785001113;
	b=5th8EDyaUKeIb4GVqKheLJKCkWtd7wZ1Z54HD2mF+EtIoOXZU3XpthH4aaoEgEZY1yeP9W
	rv8NLS/JFNoKQLrzrZfoNBjce2kOLsp5745nAGq67oUc6pFX42k5qn1YpeoyVCtADabZIC
	fjUrR+4iNsSvcuarhRMe369EFuoYqgw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D17243C37;
	Sat, 25 Jul 2026 17:38:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C003D1F000E9;
	Sat, 25 Jul 2026 17:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785001112;
	bh=QylY0Jj+M9aiGs5V5SL5IjP/iHtiFsye8Zowe/lAKfs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hbLGkWpNrMM4k73a7LkMKOLXC3oYWnMbIQUTX9a1AMPyP+ZB2YtDGSKAOO7LnRTqG
	 vBTBVOyCfgkBM0MWbOb/NoVC5YN9xSGoda6NWf0PzmMOT1fw/XOO6vHcoZm2T9Hnp5
	 55ibAzms1bMqsEcamK0sa477Sp/cRJs/DtF2sButDQG4u1jm7nFthZJfCS76oVES0q
	 WsTkfomIff31rzlYsktIJhBXeK7omGcTHPA60jUlZ+1E5GFmI8FYxCp3658BnzoxL3
	 TPxHPEdFzInIhLMkWjbdj7ZY/o7vUtkGVxUVFRul5xDUBZdBWJw09bqSEyMu0nLWef
	 YF/1c7ceJP17Q==
Date: Sat, 25 Jul 2026 19:38:23 +0200
From: Helge Deller <deller@kernel.org>
To: John David Anglin <dave.anglin@bell.net>,
	Usama Arif <usama.arif@linux.dev>
Cc: Helge Deller <deller@gmx.de>, Pedro Falcato <pfalcato@suse.de>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jan Kara <jack@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-parisc@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/5] mm/parisc: constify ptep_get() argument
Message-ID: <amT0j_bBT3CCxPcg@p100>
References: <20260724102017.141532-1-pfalcato@suse.de>
 <20260724102017.141532-4-pfalcato@suse.de>
 <0fd713a8-e4ab-4c07-b36e-79dd138b4a86@linux.dev>
 <amNzLXuwflIZFKtI@casper.infradead.org>
 <253f7ac0-205b-42f1-9fb5-d19eceb581b6@linux.dev>
 <amOEUZlp1BxYh6_t@pedro-suse>
 <fd239383-dcbe-4daf-b337-32facef07076@linux.dev>
 <3e9dece8-4e86-4ce5-bd74-b3ec305f3003@gmx.de>
 <4606e13f-6827-45d0-b3b8-6bc26358f7ae@bell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4606e13f-6827-45d0-b3b8-6bc26358f7ae@bell.net>
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2A479120009
X-Stat-Signature: 35jmrwdtd341gkfg87fhzicoiyxyscyk
X-HE-Tag: 1785001113-976311
X-HE-Meta: U2FsdGVkX19GUWF1bo8U1tQADKjqTZSfFKB8MluChJsRa7TV9iCvPyZJlwRtIm7BNYyh9KbgOsyEwilFuPfgRdIgJ4QqbiJ00r111We6jpChJMizD7CAgxk81OtX6u5pzzwsxvuvjelUjz2QhT6AZAoXHJQNM5vAiSViOoQiyE0o2hwJbm4ATfklNWGW3IPFmfTOwppAMkMf8nNZWkCKwlKzk5+nqEtMOq9pl6xwPtdsAypvh6l9sdzc1u+ZwSd5JI3uJujBz2yifzxyHey24OE9HKroNK+qYYmlVUl8YrmqzmTKir878a3mMDqnp3wXHg2MzVUP1Sy0InBrgD+5w9wGCZD5JY/XAVYYV+VLj80A6Sx42MIUyNDqC1nFmRhdiCpjHqNtM/jLSoeTCq7GA22prpzubkp7EVR03xdtTLxawWiZXkFkEZYwcRP1CSsqg3u5ccW9wxZlNHbokqM56GJtJ9XJ9E4Rya//mhqlvPce+vrnDTcI750pYu+jZnWbxCFG7QjPf8+qQ7HezX0iwFKZ4CDE79crjWyk0wPlrugpF9pf9jJCxHvlFjXOJ6Vhb9Gs0zxr6gQuj495sEqd6gEODKtlg2Q8GPCDdava2jw+zQkyomhqL7iUVSOyq7ueCxYlvzGNDWY3A4+CLzCZZyg/IGYc16zfAVSJl5YBJJVRkXsKHdZecf1JF7YShbAL9SS354pFRlz5UFoHBTjULnCGvTENR7dOLZ+1jx5wElIREVtsMGGxnjsytKzyic2InJNFqZ0l5hsjc55hAup6lT3i2Ad7uwl3pFP/fBh5AzBn8if4ce7syK1CO2uruhsa5ZnqYYfeMoBV6b9Evp21v0E2UZ6AdpCXBDrr28U9HCS/SqcZYn+bdX1zpfriujr3RVWrcUTTVQ6ueXe/RZXyJdh73vYpUhHFDPtYs0zQ/pz53O7om3qP7suoT0rD+qnVDMCmp2+kIA+RJ1zbe84
 oqgeoz3y
 Aidn02LUrx1zHA684QM9MYgJmG07Ngr8bs6v0W1wU4yZkBMm9KonkzEKrR+KrdFHI0tFdxjO4VoIQxUHHlJdAt9lzCS8r/n0+j0BGpGvM6A19NfocgRXtLJ6NiZcgNjbMF6IwcAr5x8sOwvb7rwuPjZuXzb5dfjBIZSn+wWZ6O1Yn4HZAvBCGrIbCuJND5vNeJddsdlYQTSj3d9BmQd2tUxDkWLQ+hGXidznbMnHzwWJODwLhyYLFIv9rGUYI3CXi/uH4yU19Gb6YXiLEOc1614ikkzUBofO5BXOjDrzEvXpz7F88g+Ozc9vTQxiKCurFXasrzIPg94HQkzKSMOpoTNQmYXZukuqUJOtHD/6VAMcoY7URwZgfRzDaE/3vFB4oF1abxisNHQn6KnhikkRQfArG+C490RADlJghUTfQm4PvqC8zPpHUxG3fxRBLfVqENFZqiOBDtIX1RpJaAnygzYrdEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

* John David Anglin <dave.anglin@bell.net>:
> On 2026-07-25 12:27 p.m., Helge Deller wrote:
> > On 7/24/26 17:48, Usama Arif wrote:
> >>
> >>
> >> On 24/07/2026 16:32, Pedro Falcato wrote:
> >>> On Fri, Jul 24, 2026 at 04:03:44PM +0100, Usama Arif wrote:
> >>>>
> >>>>
> >>>> On 24/07/2026 15:14, Matthew Wilcox wrote:
> >>>>> On Fri, Jul 24, 2026 at 02:36:59PM +0100, Usama Arif wrote:
> >>>>>>
> >>>>>>
> >>>>>> On 24/07/2026 11:20, Pedro Falcato wrote:
> >>>>>>> ptep_get() does not need write access to the PTE.
> >>>>>>>
> >>>>>>> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> >>>>>>> ---
> >>>>>>>   arch/parisc/include/asm/pgtable.h | 2 +-
> >>>>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>>>>>>
> >>>>>> hmm I think you might break build bisectibility if
> >>>>>> you separate out the patches, you should squash patch 3 and 4,
> >>>>>> with patch 1.
> >>>>>
> >>>>> I don't see how this breaks bisectability.  Can you elaborate on what
> >>>>> you think would break?
> >>>>
> >>>> Patch 1 does:
> >>>>
> >>>> -static inline pte_t ptep_get_lockless(pte_t *ptep)
> >>>> +static inline pte_t ptep_get_lockless(const pte_t *ptep)
> >>>>   {
> >>>>       return ptep_get(ptep);
> >>>>   }
> >>>>
> >>>>
> >>>> ptep_get() takes a non-const arg till patch 3 for example for parsic.
> >>>> I don't think you can pass a const variable to non const function arg?
> >>>>
> >>>> So parsic won't compile in patch 1 and 2, powerprc wont compile
> >>>> for patches 1, 2 and 3..
> >>>
> >>> Aha, yes, nice catch! I'll have to rethink that. Maybe squashing the patches
> >>> would be the cleanest way forward.
> >>>
> >>
> >> Yes, squashing is the simplest way forward.
> >>
> >>> FWIW, the vast majority of architectures aren't doing funny things on
> >>> ptep_get(). E.g PA-RISC, loongarch only define these so they can use it in
> >>> their own asm/pgtable.h. I'd really like to delete these but I can't tell
> >>> if they are *actually* required.
> >>>
> >>
> >> Ah maybe there is something in git history on why it was needed?
> >>
> >> If not, hopefully someone from the arch lists could clarify..
> > I tried to remove ptep_get() and ptep_test_and_clear_young() from
> > arch/parisc/include/asm/pgtable.h, but this then triggers compile errors:
> > 
> >  CC      arch/parisc/kernel/asm-offsets.s
> > In file included from /home/cvs/parisc/git-kernel/linus-linux-2.6/include/linux/mm.h:31,
> >                  from /home/cvs/parisc/git-kernel/linus-linux-2.6/include/linux/pid_namespace.h:7,
> >                  from /home/cvs/parisc/git-kernel/linus-linux-2.6/include/linux/ptrace.h:10,
> >                  from /home/cvs/parisc/git-kernel/linus-linux-2.6/arch/parisc/kernel/asm-offsets.c:21:
> > /home/cvs/parisc/git-kernel/linus-linux-2.6/include/linux/pgtable.h: In function ‘clear_young_dirty_ptes’:
> > /home/cvs/parisc/git-kernel/linus-linux-2.6/include/linux/pgtable.h:683:25: error: implicit declaration of function ‘ptep_test_and_clear_young’;
> > did you mean ‘pmdp_test_and_clear_young’? [-Wimplicit-function-declaration]
> >   683 |                         ptep_test_and_clear_young(vma, addr, ptep);
> >       |                         ^~~~~~~~~~~~~~~~~~~~~~~~~
> >       |                         pmdp_test_and_clear_young
> > 
> > So, I think the answer is, that the local copy of ptep_get() is used in the parisc implementation of
> > ptep_test_and_clear_young() function.
> > 
> > Switching to the default include/linux/pgtable.h seems not easy doable....
> 
> Did you remove define for __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG in parisc version of pgtable.h?

Indeed, I missed to remove that.

Usama, if you want you can add the patch below to your patch set, thus
simplifying your series?

Helge

------

From: Helge Deller <deller@gmx.de>
Date: Sat, 25 Jul 2026 19:19:55 +0200
Subject: [PATCH] parisc: Drop own implementations for ptep_get() and
 ptep_test_and_clear_young()

Switch to the generic implementations, which are identical.

Suggested-by: Usama Arif <usama.arif@linux.dev>
Suggested-by: John David Anglin <dave.anglin@bell.net>
Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/arch/parisc/include/asm/pgtable.h b/arch/parisc/include/asm/pgtable.h
index 467b8547ac8b..d92dee9fef3f 100644
--- a/arch/parisc/include/asm/pgtable.h
+++ b/arch/parisc/include/asm/pgtable.h
@@ -432,25 +432,6 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return pte;
 }
 
-static inline pte_t ptep_get(pte_t *ptep)
-{
-	return READ_ONCE(*ptep);
-}
-#define ptep_get ptep_get
-
-static inline bool ptep_test_and_clear_young(struct vm_area_struct *vma,
-		unsigned long addr, pte_t *ptep)
-{
-	pte_t pte;
-
-	pte = ptep_get(ptep);
-	if (!pte_young(pte)) {
-		return false;
-	}
-	set_pte_at(vma->vm_mm, addr, ptep, pte_mkold(pte));
-	return true;
-}
-
 bool ptep_clear_flush_young(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep);
 pte_t ptep_clear_flush(struct vm_area_struct *vma, unsigned long addr, pte_t *ptep);
 
@@ -491,7 +472,6 @@ static inline void ptep_set_wrprotect(struct mm_struct *mm, unsigned long addr,
 #define HAVE_ARCH_UNMAPPED_AREA
 #define HAVE_ARCH_UNMAPPED_AREA_TOPDOWN
 
-#define __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH
 #define __HAVE_ARCH_PTEP_CLEAR_FLUSH
 #define __HAVE_ARCH_PTEP_SET_WRPROTECT

