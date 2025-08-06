Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AAB7C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 08:16:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CDE828E000C; Wed,  6 Aug 2025 04:16:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8F058E0001; Wed,  6 Aug 2025 04:16:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BCBB58E000C; Wed,  6 Aug 2025 04:16:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ACBB68E0001
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 04:16:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 69ABB8153F
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:16:03 +0000 (UTC)
X-FDA: 83745624606.12.98B5564
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id BEDCE140007
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:16:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tzUYNT8X;
	spf=pass (imf09.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754468161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D0JXxe51jAlql+TRKu9VBSbtOQNrlasC1vvH39bvxbs=;
	b=1KAhnD7/2xl56tPR5mYbu/CUX0mzrG6yKL/qBi0/R2EdHkv5AmJwDEEAEjQ4UhufGUhIfe
	Ypr+XpwPdzqc0QTMlwlbVJm4w8L5c8twrsmTgEShnYLUChYXJq8yBaWQbv8BbjZ3QvmvXc
	0IRDNsxCQA+CRSNTuanN2ztf8NIixS4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tzUYNT8X;
	spf=pass (imf09.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754468161; a=rsa-sha256;
	cv=none;
	b=VCn/ml3HNvSHYsYo6da5FSYjwD02MeE6bLRWnRgFpjjmlYLsQOwMXgVe+4r5J4K8CWEtSm
	KQM2zAaEqeCIpVmIMzn7+U/zly32SDr0IENIBk+uc9Dk7RBl52Sk9wf/lniDRCfBm5RZWc
	DuM9nAnWCEM1X8l23yKOSYAG9g5Ci+g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 064AC600BB;
	Wed,  6 Aug 2025 08:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E2A4C4CEE7;
	Wed,  6 Aug 2025 08:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754468160;
	bh=Fbs+mcsucsTbbAfdd4KqOVe7ihhq3xMWZSnPSsrgkFQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tzUYNT8Xalxuyjn5JF7yGta6JqVi66uQJ+BbyjUmL04iS+TZaM/+LppSVJAnVg4pQ
	 kYzdfZco3vWBTi95h50psAZoaikqE/wlh0X9bNUSdH3lLHLgF5qBIdMhdEndhaQHah
	 u4RVYMufQmBtCcm58SIX17ENIcivOMPkNLbYClBIRRsB2vmrb1Vhbkabj9M+BgOVGg
	 KT5U0lCMuUdvKQ4DYyNgKEK2sQMYGctCc2oMdYXLYR3gib/bXVucP9/FZ7KEAthQo0
	 4bEU+t8p+/SqmpMlR7X8gMfI7HmKNT9UqMfV5MXQDCeiUymAXDLn56Osq3IAoMpddH
	 bsogXwSP11smA==
Date: Wed, 6 Aug 2025 09:15:53 +0100
From: Will Deacon <will@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
	ryan.roberts@arm.com, willy@infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
	Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, vbabka@suse.cz,
	jannh@google.com, anshuman.khandual@arm.com, peterx@redhat.com,
	joey.gouly@arm.com, ioworker0@gmail.com, baohua@kernel.org,
	kevin.brodsky@arm.com, quic_zhenhuah@quicinc.com,
	christophe.leroy@csgroup.eu, yangyicong@hisilicon.com,
	linux-arm-kernel@lists.infradead.org, hughd@google.com,
	yang@os.amperecomputing.com, ziy@nvidia.com
Subject: Re: [PATCH v5 6/7] mm: Optimize mprotect() by PTE batching
Message-ID: <aJMPOTripINrafxh@willie-the-truck>
References: <20250718090244.21092-1-dev.jain@arm.com>
 <20250718090244.21092-7-dev.jain@arm.com>
 <7567c594-7588-49e0-8b09-2a591181b24d@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7567c594-7588-49e0-8b09-2a591181b24d@redhat.com>
X-Stat-Signature: 3h5duqkiwdarr789mjug3anfcrdqx9sh
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: BEDCE140007
X-Rspam-User: 
X-HE-Tag: 1754468161-958346
X-HE-Meta: U2FsdGVkX194UaVijGv+VpYqq2Mf9MPtMew/UJ/F4Wuhgi7ZLuETkJYO4FEST4mmEYDXi0QRscC/t32WiRGetiABjCGagwQ9PzNhThPNcPZnTf7ewI6BFimUya2CXTriFZxTmJZvpq1sRPx7hOd9pYlXb+73DMfeciwQmLHMtkPghqx4KgU+4ewT7kxP5VCQDn0dg97cTNtV47DiYtsO1dtkxp3Da4X+NYTEgcc8lCzqd70N6UNil6FAN276XrSEVBHvXamfWkYC+xaUW2/Q3y3k58T9mpmyFpQKx5qVZvTMesGY5eV/Wc9CEbz/zXlaUS0w4vP5bI7yi3aIBCeY4ALEXx7g6ou6w1zUKi/41sS+V3xKoP2TUNVSCh+YdTxVKi6KSWY557S56tgwz2NXxci+SHO+r8PX0IkbviKekRctMC2KBJZQL+9byDE3EpDD5Ldt4j2FiMz9oR1tl0YBiujt2xWNSjUzZAIJdfoPM9vYGmbfFu5YPcbf2wtMFWLJvSbN/xyszc04KljYg9TxTOseQQIvFyXuA7JkYjxsxFSdNHJ4QplRPPMHd1r0Q6VCdlSwKrXHng9H1Kei+QHrDnelWIP1EEWyAbbfjmvFmMepwq4mQGHMWAe1MeTiL/AP0QCH1DEqE6YL4sI2gA4pZhk5aVSlfc50fm6Cza/JUo8mk8bT+hTyUoZI9CsaPcAdjAk6pSU9RMe4g2mQWKKj6v2oPRUOcVedf7J1vetudnQmWNvsWrm9/GP6hNFZmUT2cbbubMW3c1mH2mVULxJfxUcN5BYyK/wTaC7W8UHGBkF/ia9kQppa2/cP62lxzLNs+I9PfwiKw6FJvl19yF9AUM0mg3MyFBFAvMIDfoSSYs712Mhp4iRdgQvHah80s2WzYUnEBltpk9QRdIKa8jMpsJOmLHU0w3JWkDyf+rdL7+38ya6rTEGJxtyvWDOXJESjK4m91QRTgYRqcusEQWZ
 mY9/qEPD
 f4VAt0q8TILLi6FDnF6Ve0xJLiBz8b+X+j/mCq6X3R17W6PLFlAmIAIH2ywbk8IehdLfX4SMppSNfHzhrvWb2/Z2grbqt1KNIJvpiZR5m4gaJSz9z7zqCSxNZUP6/pJ1aG9nkDE2AHBnzZZLUjnG4rrrjS7lWszq2J/1NRh87LyYy6ONmZwxWAi8FYA7iJY7+eRVTLxKZ7G8nsuh23nRzD4/EDFqQipGDoraClOr5u+pOgBYClfm9TiFZGNbkxzjNgMdaxg16rf2CeR1LC/GkdTcAKsedQGsdeTNHvQZtaZLVrzUNkVSYN6HGFmCoVAAvmxul3hKydA83w3xDbmpptCbp+DFVQ8+gatjIJQSRxsCjBso=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 06, 2025 at 10:08:33AM +0200, David Hildenbrand wrote:
> On 18.07.25 11:02, Dev Jain wrote:
> > Use folio_pte_batch to batch process a large folio. Note that, PTE
> > batching here will save a few function calls, and this strategy in certain
> > cases (not this one) batches atomic operations in general, so we have
> > a performance win for all arches. This patch paves the way for patch 7
> > which will help us elide the TLBI per contig block on arm64.
> > 
> > The correctness of this patch lies on the correctness of setting the
> > new ptes based upon information only from the first pte of the batch
> > (which may also have accumulated a/d bits via modify_prot_start_ptes()).
> > 
> > Observe that the flag combination we pass to mprotect_folio_pte_batch()
> > guarantees that the batch is uniform w.r.t the soft-dirty bit and the
> > writable bit. Therefore, the only bits which may differ are the a/d bits.
> > So we only need to worry about code which is concerned about the a/d bits
> > of the PTEs.
> > 
> > Setting extra a/d bits on the new ptes where previously they were not set,
> > is fine - setting access bit when it was not set is not an incorrectness
> > problem but will only possibly delay the reclaim of the page mapped by
> > the pte (which is in fact intended because the kernel just operated on this
> > region via mprotect()!). Setting dirty bit when it was not set is again
> > not an incorrectness problem but will only possibly force an unnecessary
> > writeback.
> > 
> > So now we need to reason whether something can go wrong via
> > can_change_pte_writable(). The pte_protnone, pte_needs_soft_dirty_wp,
> > and userfaultfd_pte_wp cases are solved due to uniformity in the
> > corresponding bits guaranteed by the flag combination. The ptes all
> > belong to the same VMA (since callers guarantee that [start, end) will
> > lie within the VMA) therefore the conditional based on the VMA is also
> > safe to batch around.
> > 
> > Since the dirty bit on the PTE really is just an indication that the folio
> > got written to - even if the PTE is not actually dirty but one of the PTEs
> > in the batch is, the wp-fault optimization can be made. Therefore, it is
> > safe to batch around pte_dirty() in can_change_shared_pte_writable()
> > (in fact this is better since without batching, it may happen that
> > some ptes aren't changed to writable just because they are not dirty,
> > even though the other ptes mapping the same large folio are dirty).
> > 
> > To batch around the PageAnonExclusive case, we must check the corresponding
> > condition for every single page. Therefore, from the large folio batch,
> > we process sub batches of ptes mapping pages with the same
> > PageAnonExclusive condition, and process that sub batch, then determine
> > and process the next sub batch, and so on. Note that this does not cause
> > any extra overhead; if suppose the size of the folio batch is 512, then
> > the sub batch processing in total will take 512 iterations, which is the
> > same as what we would have done before.
> > 
> > For pte_needs_flush():
> > 
> > ppc does not care about the a/d bits.
> > 
> > For x86, PAGE_SAVED_DIRTY is ignored. We will flush only when a/d bits
> > get cleared; since we can only have extra a/d bits due to batching,
> > we will only have an extra flush, not a case where we elide a flush due
> > to batching when we shouldn't have.
> > 
> > Signed-off-by: Dev Jain <dev.jain@arm.com>
> 
> 
> I wanted to review this, but looks like it's already upstream and I suspect
> it's buggy (see the upstream report I cc'ed you on)

Please excuse my laziness, but do you have a link to the report? I've
been looking at some oddities on arm64 coming back from some of the CI
systems and was heading in the direction of a recent mm regression
judging by the first-known-bad-build in linux-next.

https://lore.kernel.org/r/CA+G9fYumD2MGjECCv0wx2V_96_FKNtFQpT63qVNrrCmomoPYVQ@mail.gmail.com

Will

