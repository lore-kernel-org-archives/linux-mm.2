Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C4B5CD6E5D
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 08:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC41E6B008A; Fri,  5 Jun 2026 04:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4E376B008C; Fri,  5 Jun 2026 04:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEE7B6B0092; Fri,  5 Jun 2026 04:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ABE8B6B008A
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 04:59:38 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F0541C2322
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:59:38 +0000 (UTC)
X-FDA: 84845260836.25.DA39F5A
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf12.hostedemail.com (Postfix) with ESMTP id 76C2E40004
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 08:59:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dhh7PXSj;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780649976;
	b=NsFQlYa6eG1uINGxS7e+9YSJwNTzbi0tuA7Ya6+572+ItL6poDiGYhiLaAOPHEsad694VG
	2rOtWSmEmctH4LbWubJY0TldmmZ3VGhsByFoIQfObpUr9Cu0U3UiCCoKq7dzRc2885hPkn
	mn4mYzEwCP/HAEu01BgfjkYHe0A6Yrc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dhh7PXSj;
	spf=pass (imf12.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780649976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aph3F0yH35JYxECybQiTrc4aeTySkKR0krHjxKePy6w=;
	b=rG4uAw2348EOz50hOsh5c23DpCqjKpaqy0NpNfn+hUXIxqOSgZUjMucPvb0NAQt7PA9oVV
	ZoeMtzt6O8YBpeyK/SxvJCO5uiPoyD6zAvA0cdATSFrIhB6pEoKQ6EbaPpU8+hEDenha+0
	FSoo43ikJBnOROdGat5XQwrmX/sUoZc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780649974;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aph3F0yH35JYxECybQiTrc4aeTySkKR0krHjxKePy6w=;
	b=dhh7PXSjnqOSGRZLH5vbiPzF+QSQXB5XerF/69shhrDMybXrN9ejD+mg7fsY598xDL7TOB
	PkwYWYJ4hhvFk7dgkSszqLeqJbpYkzbjuX6JInJZXdm5weNWfisyyy7lsvwt3SUOK5R4o8
	/vsuaca21affbDpb0uGv8xRTZRPq4Ck=
From: Lance Yang <lance.yang@linux.dev>
To: ljs@kernel.org,
	david@kernel.org,
	npache@redhat.com
Cc: lance.yang@linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	aarcange@redhat.com,
	akpm@linux-foundation.org,
	anshuman.khandual@arm.com,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	catalin.marinas@arm.com,
	cl@gentwo.org,
	corbet@lwn.net,
	dave.hansen@linux.intel.com,
	dev.jain@arm.com,
	gourry@gourry.net,
	hannes@cmpxchg.org,
	hughd@google.com,
	jack@suse.cz,
	jackmanb@google.com,
	jannh@google.com,
	jglisse@google.com,
	joshua.hahnjy@gmail.com,
	kas@kernel.org,
	liam@infradead.org,
	mathieu.desnoyers@efficios.com,
	matthew.brost@intel.com,
	mhiramat@kernel.org,
	mhocko@suse.com,
	peterx@redhat.com,
	pfalcato@suse.de,
	rakie.kim@sk.com,
	raquini@redhat.com,
	rdunlap@infradead.org,
	richard.weiyang@gmail.com,
	rientjes@google.com,
	rostedt@goodmis.org,
	rppt@kernel.org,
	ryan.roberts@arm.com,
	shivankg@amd.com,
	sunnanyong@huawei.com,
	surenb@google.com,
	thomas.hellstrom@linux.intel.com,
	tiwai@suse.de,
	usamaarif642@gmail.com,
	vbabka@suse.cz,
	vishal.moola@gmail.com,
	wangkefeng.wang@huawei.com,
	will@kernel.org,
	willy@infradead.org,
	yang@os.amperecomputing.com,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	zokeefe@google.com,
	usama.arif@linux.dev
Subject: Re: [PATCH mm-unstable v18 06/14] mm/khugepaged: generalize collapse_huge_page for mTHP collapse
Date: Fri,  5 Jun 2026 16:59:03 +0800
Message-Id: <20260605085903.77186-1-lance.yang@linux.dev>
In-Reply-To: <aiJ90SWqXvwN9dNT@lucifer>
References: <aiJ90SWqXvwN9dNT@lucifer>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 76C2E40004
X-Rspam-User: 
X-Stat-Signature: sw6ocywegcgkmj9dch9stp8c1nxfw8z7
X-HE-Tag: 1780649976-846769
X-HE-Meta: U2FsdGVkX18T5sjN0oQULsuM09us0xWxeUn6iTrl5W0qWQN7T1x87YFbKbET2PL8vrBANq6J7sjaHf96RTb0FdL09mhoaXTyQ0+oqEzLi9ZZXV9WKVuidrmTtwlg1dKRFLI8AwHJdBONos1RhjC3vSnkZwUP7vIwS18XyzN3J7xXp0bHZ3z2XO3YqT7M48tybQfQMTqGsRDEfLX12hEcBUOTdiR7Pvy13pHoF5WkPMOD86VbBgK9p+ZeOVqCUHrAMKlIOfoU9JAMz7/DnD+yTUvYaPDmBVvTCQepoOGkZ2S5tX49KO73hnddOn0CPauwFg5G6gauhpZ2WLLQ6tbSNdyHbyCLWExZm2fClhJDYjOI0yjNWnPq0Q7lAGmS645oLVnHy4bj0+Wjh5GmJaDbhM6H/rdWygQUzW/bApn+JbY85ruGi1IkrQxSPFqhlYrkHNbnNn+yh/uykM60dbcISSHBes9eOSBhY3ior6AdUwvyRot4AeuMEjIAsMNLT1stw/nStQpo/HcXm0eSMvhVhh6CKAEr9kqfSd2RBrWNxpkqM0lj2KCgIenvXGtKrTM2ERwzBivL1VwDJw1k8vKAulckKBch/75Ou4cc3MgsiE0svobcmOCncC+dfkxs2JCMQX2ARCUIb/BhTgY3jpKyCtAbSeQ3i24UMqRuRUeqKehxXgbouN3bATJZxm5Ea013uocqrTzE6lDDdPyV6gsNABCVuaJvEc+1+81rH/RfAkXtBJJ2XS5vnCRXiY1lWlc2mXa74n8coRneAhIueI11TOfV8jr8jZ7m1GQ6DSOGw8hV5lBI4ij4l0DDwEnIa/Bne3wx2oIWJQCJaR0DUUE0nTM8iOYbcJchbfJb999/PwW6iXqsd6xYZufH3Nr0BPDmOz5/50EFeqLjK63In3q8bxSicOFZXy84WQrCIs1Vu6vccHgfpgXRepK4c0ImYqIstQ+fdJ/+Bw8SflGzlrI
 1DQrbtwG
 qw2wyvElkGIzOX6mlzcjhCkRb6dAXSJpNEL1Y5ffu0BbMwdyMpmqfkNzhE/f/be7oY0W0Y+kIB6vZTROYsz5aDac1UOO6krW0pGsBkDBrnP/6YJL/g6w5fdegIxTNpsawyMIzoxzJoUjkz06DO7VW7/Y9HchZgF6kz06LJWD8N7gXKh3LQoS5tzb4RWMDObPVe2b429ntJLYhHDAVGERMVMewlm2VEIH1YSkAFfs5eCeEeIMtlcnRlyb1LSLQKu3ZbotrE4OVBx2ZrAYY/tKn5pFEphMyQudKypKwrnV2gIed06MUU2U1VJurD81M+f4YzFih78syyeMZcVEtHT1V6/bVzDyNSi5jXZJRvahQpzRAxNPpSPxGEUQi/z5YW2KwKjr+A03prOuOKISVHXvWJqoroA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Fri, Jun 05, 2026 at 09:07:23AM +0100, Lorenzo Stoakes wrote:
>On Fri, Jun 05, 2026 at 09:18:27AM +0200, David Hildenbrand (Arm) wrote:
>> On 6/4/26 19:04, Nico Pache wrote:
>> > On Mon, Jun 1, 2026 at 9:00 AM Nico Pache <npache@redhat.com> wrote:
>> >>
>> >> On Mon, Jun 1, 2026 at 5:14 AM David Hildenbrand (Arm) <david@kernel.org> wrote:
>> >>>
>> >>>
>> >>> Yeah. BTW, I think we'd need a spin_lock_nested(), so @Nico, treat my code as a
>> >>> draft.
>> >>
>> >> Okay, I read the above and did some investigating.
>> >>
>> >> I will try to implement and verify the changes you suggested :)
>> >
>> > I've implemented something slightly different actually and I *think* its better!
>> >
>> > } else {
>> >        /* this is map_anon_folio_pte_nopf with no mmu update */
>> >         __map_anon_folio_pte_nopf(folio, pte, vma, start_addr,
>> >                       /*uffd_wp=*/ false);
>> >        smp_wmb();
>> >         pmd_populate(mm, pmd, pmd_pgtable(_pmd));
>> >         /*
>> >          * Some architectures (e.g. MIPS) walk the live page table in
>> >          * their implementation. update_mmu_cache_range() must be called
>> >          * with a valid page table hierarchy and the PTE lock held.
>> >          * Acquire it nested inside pmd_ptl when they are distinct locks.
>> >          */
>> >         if (pte_ptl != pmd_ptl)
>> >             spin_lock_nested(pte_ptl, SINGLE_DEPTH_NESTING);
>> >         update_mmu_cache_range(NULL, vma, start_addr, pte, nr_pages);
>> >         if (pte_ptl != pmd_ptl)
>> >             spin_unlock(pte_ptl);
>> >     }
>> > spin_unlock(pmd_ptl);
>> >
>> > The logic here is that when the PMD becomes visible, PTEs are already
>> > populated (no possibility of spurious faults on local CPU)
>> >
>> > the SMP_WMB makes sure of the above
>
>THe locks prevent those 'spurious' (really: incorrect) faults anyway so I don't
>think this is necessary.
>
>> >
>> > And the pmd is installed with the pte and pmd lock both held through
>> > the mmu_cache update.
>> >
>> > This follows the conventions used in pmd_install() and clears the
>> > potential for local CPU faults hitting cleared PTE entries.
>>
>> After the pmdp_collapse_flush() we'd be getting CPU faults due to the cleared
>> PMD already? So the case here is rather different.

The issue I was worried about: update_mmu_cache_range() can re-walk
vma->vm_mm while the PTE page table is still not reachable through the
PMD. And, yeah, that assumption is ugly, but it is what it is, and there
maybe be similar code elsewhere ...

So the ordering we need is "the PMD points to the PTE page table from
_pmd before update_mmu_cache_range()", not "new PTEs before PMD".

Those PTEs are cleared, but we hold the PTL, so nobody else can install
anything there :)

So David's original suggestion looks enough to me:

if (pte_ptl != pmd_ptl)
        spin_lock_nested(pte_ptl, SINGLE_DEPTH_NESTING);

pmd_populate();
map_anon_folio_pte_nopf();

if (pte_ptl != pmd_ptl)
        spin_unlock(pte_ptl);

>Yeah conceptually the code above is problematic because you immediately make the
>PTE available right at the point you populate, so taking a PTE lock after that
>is rather shutting the stable door after the horse has bolted.
>
>Doing it this way is not a good idea in any case because we're adding
>complexity, an extra function and an open-coded cache maintenance call for
>really no benefit.
>
>I asked Nico to abstract the anon folio mapping stuff explicitly so we could
>avoid this sort of duplication so let's not roll that back :)
>
>So again, I think going with the original suggestion (with an updated comment)
>is the right thing to do.
>
>
>Anyway, an aside But in practice we can't have page faults here right? The VMA is:
>
>- Ensured to span at least the PMD range (this isn't immediately obvious in the
>  code)
>- VMA write locked (mmap write lock held)
>
>And we hold the anon_vma lock so no rmap walkers can walk the page tables here
>either.
>
>So I actually wonder, given that, whether we need the PTE PTL at all.

I'd keep it. Cheap, and lets us sleep better at night :P

>But.
>
>At this stage it'll almost certainly be an owned exclusive cache line so it's
>very low cost to do it, and it means we honour the update_mmu_cache_range()
>contract.
>
>And it also makes it clear that we're gating changes on the PTE being
>untouchable so any future stuff that maybe changes some of these rules doesn't
>get caught out.
>
>So probably worth keeping.

Yes!

Cheers, Lance

>>
>> --
>> Cheers,
>>
>> David
>
>Thanks, Lorenzo
>

