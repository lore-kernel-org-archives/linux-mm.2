Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13B32606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 09:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DeiMapPB
Received: by kanga.kvack.org (Postfix)
	id 3BBAD6B00EF; Tue, 17 Nov 2026 04:35:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393606B05B1; Tue, 17 Nov 2026 04:35:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A9856B05C0; Tue, 17 Nov 2026 04:35:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F40276B00EF
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 04:35:42 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8C45EA7989
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:35:42 +0000 (UTC)
X-FDA: 85444103724.30.6822E45
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id ECAF040009
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 09:35:40 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DeiMapPB;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794908141;
	b=fZhl3Ny7ZaL2L1nI9Ep1XXXo6ZZrkckvnVAiYnH4ZJI9NRfk8q2GjHKcbvba/VMu9JZVYV
	sFaoxxP5oN/dO5MuxYPFThe8il1KmYZy/15UpOiQuq5WhRtEmSOciOqCvmMg6QwUaFpuir
	8D8K3t0qjWW8oCeBx5YV6IiWSPz0Hv8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DeiMapPB;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794908141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OhiR+JSPx8omGjT6b8YvAiFiu4YN/j7mPCjJR2bPM4M=;
	b=FuBglDFREyT/DzdW0kN7vhD1qP2HNt4FoXYGHU+LarSRFeh4yxFc5hxkC+hvB01XEsOfet
	dW1lORf10DRxlt7LprCUb3vZrmkkLCGyJhhXuQfm6oDGoaRTE7kPBd1a1otmKlMP/53Hkv
	qEaLwBq9/U7AgqTi5QHE6zKwJPLrK5Y=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CAACE624C8;
	Tue, 17 Nov 2026 09:35:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4831F000C7;
	Tue, 17 Nov 2026 09:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794908139;
	bh=OhiR+JSPx8omGjT6b8YvAiFiu4YN/j7mPCjJR2bPM4M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DeiMapPBv1qnuZUks3+vkS9vQKhSFANKRAJ00GG+00KAmW2BdHrdtW8WHT3e7iLFT
	 nFsxfKcIH+zwLmNxDc5T82lDHypUqr4zvbMzkDiBdX2xlVsMRMDXlYIUMN86mqKymX
	 LPDm1tMHkzqr+5j3EGKoPojPubh99V3FTvO4EHnXyOT6BZr6aCr784DVkDXJ09lGLZ
	 1VMTbY4l0g4skbmWuvlOozXZGbmB3QTOv8+K+o3njnYzVx5p4wxsAAor6jUfgfr3aR
	 Yqx/cKJrh+//dpjUnqtVm56/u+soAo0+ZDo/oDtwLoIAOUEg9Q6UoAbP+CbK3yiizj
	 QvU61S7rOaqjw==
Date: Tue, 17 Nov 2026 09:35:30 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, Peter Xu <peterx@redhat.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
	Roman Kisel <romank@linux.microsoft.com>, Saurabh Sengar <ssengar@linux.microsoft.com>, 
	Naman Jain <namjain@linux.microsoft.com>, Michael Kelley <mhklinux@outlook.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Eliav Farber <farbere@amazon.com>, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/memory: remove racy huge PMD assertion from
 walk_to_pmd()
Message-ID: <avwbrON3_cCtaR20@gremlin>
References: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
 <20261115-huge-pfnmap-fault-races-v1-1-537605643f6f@kernel.org>
 <dccf94b3-b901-4311-a233-488c87195dc5@kernel.org>
 <avs1rOJQ1gV33z8w@gremlin>
 <61d4f3ee-7a0b-4a8b-b5a2-35380dd46b4c@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61d4f3ee-7a0b-4a8b-b5a2-35380dd46b4c@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ECAF040009
X-Stat-Signature: y76zkdduob384agxxtuqf9ugraetasra
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794908140-128945
X-HE-Meta: U2FsdGVkX1+XPh+TR0dPkdvGVWEEm0YsH6DezGqAM4LzUHztQtM0aHr5ma6YHHpGCf9iy5tlB/U00hFa/SA6V4f0kYPIcqcK0BM9tcPgeL5diKFYuMUfcS00rwgNWm5PXWwd8guF/Fc7/RSCAUF6wYoEWZlmeye4o4JmVZpnJWbHS02S7yDsJ7b4Hes0rfiVvOX0gE0m+0Lb9sRlrhTUYHsH48V9oeYfSYzBhOrxJ9hY4Ped5VTYuKH6Y2euWGrUBwygSDOHETWDT+yRjA+pK39NSoSR3Q84hMOnErE4o6oYmd00JQyYCilnx4xux9+8Qf31K0KCGrIeAvZufBVjhrxs5Tb/X8KaPNlRklP2DpOd+A7dOEyhIdgVuDpLOGW6NMj6+um4fz4lUZaZ/56ob+Iy0E/XkfsTJnRWtG98tf4nf7AGvtwyFXbLfkazpi+/AGgaRmp50I1HTk98fyP7xTGN8exOuZLOeRvFUdDz8Db6CHaS4mhczDe7AR78dFe8NJ4h5vkt4NeG0+Q7bQXRC3+3iwvi40AEzo4rIJrLVArq+d6seBDv4aEQiirLKaer2Jz+PI0SRCwGekFO5+JhEM70DkBMiHYnva67Ahwky7NuEr+MM8o25hSgsirmN8XWtaog2UmDUovuI1NP6FqU5ZMx7ZIouTBh0Y0xN1nICOR4EbuAx8r1SYftSdAGKkNch2naUSkKfNs5VttvhYibDh3SB2JBYWvRd+/PX+7lUCpeN+p05TxdLJ6az71ORRXYVTSnmsS524mEcTcyfcrSaHIyNtTgdk+Pz1nffZkkcbdvklYuWZ1nY0J9sARco+dJIka6i/Z95r1Tfol7A0eDIy5gcWdaJKSSWVlM0+E6Qo9j5urwHDP8Lo/2WIVDThpIWKaK+qq6mrE5QuZt92HaRgKf8GIl39pK/cTwJwmrB36RyuygBKxMRoJTBTENF0ZYt5Jph7fdLMh/JLbuf5U
 i30cInT9
 pA2GKt/GR3BUGNL/q04qCqfyVyMSPBv/bIUzBZE4lJXD1P1lm7PtBaykhWj/EdpdrQSepJUpMfuuCQpMq6KZ9DCe5MThmB14Hs8eiHacT8UiO+mj0TBsRuzaf8z7Dp1JUNgYPHwoEZ6cPhF0W5Iak6e+8daEVvQ1Fy8MTNF/9G6C8zhGJSC3k6VupsVZ/qdmEyJH58SHp4cpcQGkoyiqHoHuKaKe1bXre6670AMfquomFOwbcWLLf7zkwdIF5HqU2WuXVZYg+jaieh6wvJU3jkM8fJ14crUfJYx/Zyf3ocmNxRX2sJFLX3RK9qrToEtAP8vYZFAbCZuk9C/RgH0isHQLF331z/C7ig0gA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 09:06:21PM +0100, David Hildenbrand (Arm) wrote:
> On 11/16/26 18:10, Lorenzo Stoakes (ARM) wrote:
> > On Mon, Nov 16, 2026 at 04:56:25PM +0100, David Hildenbrand (Arm) wrote:
> >> On 11/15/26 21:58, Lorenzo Stoakes (ARM) wrote:
> >>> From: Eliav Farber <farbere@amazon.com>
> >>>
> >>> walk_to_pmd() asserts that the PMD entry it returns is not huge, but does
> >>> so without holding the PMD lock, so the assertion is only valid if nothing
> >>> can concurrently install a huge PMD entry in the range.
> >>>
> >>> This is not the case for a VMA whose driver implements both ->fault and
> >>> ->huge_fault and which invokes vmf_insert_pfn() from the former.
> >>>
> >>> The existence of prctl(PR_SET_THP_DISABLE) is problematic here, as it only
> >>> takes the mmap write lock and faults taken under the VMA lock are
> >>> unaffected by this.
> >>>
> >>> This can result in two concurrent threads faulting the same thing
> >>> disagreeing as to whether to attempt a huge fault and thus ->fault and
> >>> ->huge_fault running at the same time and triggering this assertion.
> >>>
> >>> So just remove the assert.
> >>>
> >>> Target the commit which introduced the first driver able to do this for the
> >>> fix - vfio-pci. DAX also mixes fault orders within a VMA, but serialises
> >>> them using its own mapping entry lock.
> >>>
> >>> Link: https://lore.kernel.org/all/20261112051440.16140-2-farbere@amazon.com/
> >>> Fixes: f9e54c3a2f5b ("vfio/pci: implement huge_fault support")
> >>> Cc: stable@vger.kernel.org
> >>> Signed-off-by: Eliav Farber <farbere@amazon.com>
> >>> [ ljs: rewrote commit message ]
> >>> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> >>> ---
> >>>  mm/memory.c | 1 -
> >>>  1 file changed, 1 deletion(-)
> >>>
> >>> diff --git a/mm/memory.c b/mm/memory.c
> >>> index 3a20d64fd276..e03110906aa8 100644
> >>> --- a/mm/memory.c
> >>> +++ b/mm/memory.c
> >>> @@ -2384,7 +2384,6 @@ static pmd_t *walk_to_pmd(struct mm_struct *mm, unsigned long addr)
> >>>  	if (!pmd)
> >>>  		return NULL;
> >>>
> >>> -	VM_BUG_ON(pmd_trans_huge(*pmd));
> >>>  	return pmd;
> >>>  }
> >>>
> >>>
> >>
> >> Could this also stumble over a huge PUD somehow? Should we just prepare it for
> >> any leaves and bail out if we find some?
> >
> > No, walk_to_pmd() can only come from the order-0 path right now and
> > __handle_mm_fault() makes sure that can't happen in the fault path:
>
> That implies that get_locked_pte() and all insert_pages interfaces can only be
> called from that path in __handle_mm_fault().
>
> x86 an s390x use get_locked_pte() for some other paths, so I wouldn't want to
> trust on that :)

Well, I had claude go look through everything and there are no paths which are
problematic _now_ :) but future-proofing is a good idea because assumptions like
this bite you in the... assembly *ahem*

>
> (did I say that I hate walk_to_pmd and get_locked_pte? But you likely guessed it
> at this point lol)

Yeah they're bloody awful aren't they? :)

>
> >
> > 	vmf.pmd = pmd_alloc(mm, vmf.pud, address);
> > 	if (!vmf.pmd)
> > 		return VM_FAULT_OOM;
> >
> > 	/* Huge pud page fault raced with pmd_alloc? */
> > 	if (pud_trans_unstable(vmf.pud))
> > 		goto retry_pud;
> >
> > So by the time any ->fault path runs, the PUD is stable.
> >
> > We don't have to worry about the mmap paths as at that point nothing has
> > faulted in and it's all fresh.
> >
> > So it's all safe as things stand.
> >
> > But could update for future-proofing like:
> >
> > 	/* PUD leaf might have been installed. */
> > 	if (pud_trans_unstable(pud))
> > 		return NULL;
>
> Yeah, that makes sense. I was just wondering whether we'd actually want to
> return a proper error then instead, because this would not be an -ENOMEM case.

Let me have a fiddle and see what I can come up with, maybe we can use this as
an excuse to improve things a bit... :)

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

