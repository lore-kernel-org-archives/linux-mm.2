Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BE45C88E65
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 10:59:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A66B76B0092; Mon, 14 Sep 2026 06:59:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17746B0093; Mon, 14 Sep 2026 06:59:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905E66B0095; Mon, 14 Sep 2026 06:59:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A9316B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 06:59:40 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC2E11402B5
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:59:39 +0000 (UTC)
X-FDA: 85212072078.24.7677ACC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id C52CD180002
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:59:37 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zuk9D7+m;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789383577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k/820N3jYr2GH3WCO3bqlo3T1Ji36Ja7L774u/GuoxQ=;
	b=0zK111+7cZMPo/kHmQn6Z5ji98siWRKn9E6zQW3fZzG0Tog0KqvUncGM2RDk7p3YQ22w9v
	ZgHZQMs5gCTg3wiFY4lf4xza962Wlg5hLpFDLnlM/QmOuP+qhtxjVlgPmuKGjlXNeR6I8I
	RRe9qe/mK7fBtc+lTuyLYwIhRTNjIeU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zuk9D7+m;
	spf=pass (imf06.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789383577;
	b=HE7hOvnQnzR6muaSOrpaPr8qk8bBWvzggAD+TkWnB18HNZRwH0AN2ly6SguIbH83ifuRmb
	1VBbxLJrtKCAp8mUmwRQDTjsC+2GSEt/0Mgbq7rqrJN0sbYCiRYpoECMbBPfhy/drRNNz/
	ngjZfLZhSojiVr7ZnZq9sXzPZ34Ipgc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E6411601DE;
	Mon, 14 Sep 2026 10:59:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9644E1F00893;
	Mon, 14 Sep 2026 10:59:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789383576;
	bh=k/820N3jYr2GH3WCO3bqlo3T1Ji36Ja7L774u/GuoxQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Zuk9D7+mhbmETqyGx+b6NA4d8RWyYcLoNEy1TLPy0e/Dn014vxpUU1WikKC0T0r/7
	 Ov0mc/YucGBUfMHEKxaz4Szf0RCtFDXTL2j+5EaEU684rqf7h1KAeJsVLwHuCgvnNX
	 rrJ4Xmspi5n/zFEUrfvdeasWfnfQdQ//QstsUMkPh0bcblv1/EHVAl33TI/hLAazdJ
	 cNEMhFVSfrV3SbjJoJY0rIhS5ju09P/WvIdRLw6sRKPkBBYVNX+nnLSUjbs4KwUuXb
	 r7jP6cKkSNV3pXSLrkE2Il3/ucxD2s/GuuCvD6IxvGqiJOIuaAAs2eYk6liRWao171
	 MU1WgEBpP/keA==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 90776198004A;
	Mon, 14 Sep 2026 06:59:31 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Mon, 14 Sep 2026 06:59:34 -0400
X-ME-Sender: <xms:k9OnaqHYjWotVJxbnp41r1vGY8JgRiwaCeF8ZUhFdpvWFG7d-4QyPg>
    <xme:k9OnatqGa77SeWvVYXGCWqC6KA_p51VWUT3QfNN8pXhsTf97SBefGebz3M2f4GUQM
    efQkSQbQBgk5TetMsyHfOTnRZs1MvplpYV0c_QnK22bo74jwpjhdFbC7Q>
X-ME-Received: <xmr:k9Onai2kuygq_g1aR0atLTaZwY5SGosh2LTQ7AUPw54UU8OogHShrHUYt1s>
X-ME-Proxy-Cause: dmFkZTEa4sevxAV6Q4GAtMmH3bNgFi9bBl2P5MgBoETq78GI1x+H4CqfJcXgtyg8PZSHj5
    LvBOUCzISOeMcJoRas58P2quezxpo3JC6BH90ravhEQYsyOcJAJXikWX7542hpMGHON4L7
    i7k6Zwylw09Q7uXYpekWt9ouQUuEpeXnzySfB+XsC6DRIfmU+wT5NEO4827CpZTmvhRRw5
    c6Kmio2ItUEUefEPyDnOD+8oAQJ/XhY/CYU1LoF4MPhTOKywPDF6hfnX5h1iFSclCvFQYr
    kcrXR0C/DEDl7eglkfSInGXgUWVUj950lWrgzDvr/sTLu+HwJpLB5xSuAE4a5sKhKXt3Ip
    PAy8KT9QsKuOTuZHH23753Aasww8q9BumVuQkb4ZSLnqUwyQwh0wDgZdyuVJSqKWgmm7ym
    N2ZaTFzPy4JKby6jkjg9S1XjwbxdToO/GANDuV2z6KCDq2De5oJAgSC83nQ3xY+T78TA7Q
    hJdkQHaht+xAzKVkzoiC6y2OZ0JKyqEHq6uBWIKe7wAViEPip3UJ6AELJ5Wc8yO3cB/hml
    5Yn0mDJEYYjhvcZM6qxXkCfnYOK3NyW3sHKdEzTU+jVaDB6T4AuSwnL9tpWBkqTl87Gi4l
    8ZlwpGwz0CZcFI/a9uqBNKj0fHONB5xJe9RxjfmyiTvEPvjRZDq3KhXsVX9A
X-ME-Proxy: <xmx:k9OnahBrDsaxL963XQga0pd_HufUJ3UEG3E1KeV3GYJFzKnWO0K0AQ>
    <xmx:k9Onat8SpXgt7AK8tbhOtlPySC-SAZ8H7kq1LJu9o8BK7nhUb35hFg>
    <xmx:k9OnavMSoaSp_NcmONiBIEEodxgVb_NxKWozUyJntVafvVjYQx41BQ>
    <xmx:k9OnanF5FAyueRGy-U3vIDp4RVRlfFaFAvXnoU64J2N6MnXFO9R5Uw>
    <xmx:k9OnausicBquc8Ki5-pPkwUILlALjYlm6cuBbPexMfzrXZah4wJ2-hhJ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Sep 2026 06:59:30 -0400 (EDT)
Date: Mon, 14 Sep 2026 11:59:29 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, nico.pache@linux.dev, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, usama.arif@linux.dev, ljs@kernel.org, 
	surenb@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 1/1] mm/huge_memory: fix pgtable withdrawal for huge zero
 PMDs
Message-ID: <aqfRCPheDYTgTdAk@thinkstation>
References: <20260912234635.db50397364858aa15f58f4d7@linux-foundation.org>
 <20260913072312.52111-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260913072312.52111-1-lance.yang@linux.dev>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C52CD180002
X-Stat-Signature: adrsgoiany411kj8nxntgzpxzo5im5bo
X-Rspam-User: 
X-HE-Tag: 1789383577-405933
X-HE-Meta: U2FsdGVkX19BjCeb7kdxDr4VewcG6sQgLDDDwgSxmtAc+pOSUUr+Wo3ns7cz0bep4/G5CpOp3froyWB1LZkcF7znBwEYZUl3U125iIOa2zmw3h1sWHZ7AgcK7xIKVrGce67992p0V59xyCDA8rAcfzasadL1PSo9qPCv5shFvjNU3CSUzWi7M3/VzQqu7s5bdSq0q8HOb3hORoZN27PfaP0o0THI/I+jsZbnq+vQ/lE0tApwgXYP4YwGEea6YlZ5bHK9KyuMXd6rtSX8vUiYY3bm2PNLTe/WT6YhTFRJ87puyph1J5KletM9ompaVZ5LjFjQovvf7JDLj5YQfoY0caj9twzGGs35HXuZp/jBFPXf29VQPc84xKJDHfFw0Jho0lMxSmNnEShsi2Vde7mX1CbsTF/zwq24LoCYSLW9MSHyt8KnAr+tG0cm/xYpnG9pEQ8gQbu02F9NtAZTqQPKIQAwwmVcL5VxtDIsjB074crAL37fAVHTCE/cDIOTaZCkD+9o9JpP22taOOnnSPytt5FE0bZYq+NdfQEQV+x2WKGr7S1DFexVumcPl9SC2BA73ejgnBovR87uAE+0F218vNpSZcEg2bRcDJaZKV+s6BD32y1LzaDAdIDQ+B9qEw/PWThj+dq36aGSNJk7xjcic/TP1hjOymaryvCJSZqwEdn9CELsKf3EGLgqQEVkitxvoV899Qdf2zo4BiFtlHtuo0TssjmVbWVaq5J8PWVKBaUrRQz5Xlxjf9LH56IwYVt13+VnIBsv70Wn36IhemaO6rto/8haZUpeICCqOMo3pMcW+0Z2dH/Wvds/ao9ZhRrkwgvVk6HPSumzOU4LJ8thh/iupjYeW6K1wCCKz9L2kpD5RIul2PxLTLdKLxLiWCcfHyNL7wvSxfV4TvtipiI8fw4dw4STOUTdZN9rslIj9NUvSLJX18a9UxVqG800iIPnxmBIQCZDKN6iqiCS93Z
 tTSLE4SN
 wLoELi/fC5IWuEr5hoUZlym68XVgIrdKi9Hs/7QeENs3oNSIo2AVTFB9g61Ilq75QF5PRJhyhT4TSj6yKUcyeWXlzjDB4B+F/KiE6Z6XZOxDvBt97gFL5bUsdAPaZBeQf8IafMje1h4fvpsoz+p8NTiIyiBW14J5BBkbLwdMJMp4uJYUmBa3fA5BhaI9dIdOiU2CWNxAkOoIhUrl96GNGf6DeJxsFlDff45DOwwpdkzWZbUzeFADPCEpGYZpE6V8Bmhp80KvPz3x3cUxMkrkwmFowW6fbfpOHIe7p1AMA3NqXmF5mBD0X5xjMxduF0le4GqXHYnBz9ulv5Lu4aG84rJZWIRS55GcCREauVbER8UrVjDPkz5ZFR+cyTjXc9UMIf2K0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 13, 2026 at 03:23:12PM +0800, Lance Yang wrote:
> 
> On Sat, Sep 12, 2026 at 11:46:35PM -0700, Andrew Morton wrote:
> >On Sun, 13 Sep 2026 13:19:42 +0800 Lance Yang <lance.yang@linux.dev> wrote:
> >
> >> From: Lance Yang <lance.yang@linux.dev>
> >> 
> >> has_deposited_pgtable() uses !vma_is_dax() to decide whether a huge zero
> >> PMD has a deposited PTE page table. That also accepts raw PFN mappings
> >> of huge_zero_pfn, although vmf_insert_pfn_pmd() does not deposit a page
> >> table on x86.
> >> 
> >> Zapping such a mapping would call pgtable_trans_huge_withdraw() without
> >> a corresponding deposit. With pmd_huge_pte(mm, pmd) == NULL, that causes
> >> a NULL pointer dereference.
> >
> >That's the sort of thing we'd prefer to avoid.
> >
> >> Use vma_is_anonymous() for the huge zero PMD check. This matches how PTE
> >> page tables are allocated, deposited and moved.
> >> 
> >> - For anonymous page faults that install a huge zero PMD,
> >>   do_huge_pmd_anonymous_page() allocates a PTE page table and
> >>   set_huge_zero_folio() deposits it before installing the PMD.
> >> 
> >> - On fork, copy_huge_pmd() allocates and deposits a PTE page table when
> >>   copying a huge zero PMD into an anonymous VMA.
> >> 
> >> - Raw PFN mappings use vmf_insert_pfn_pmd(), and DAX file holes use
> >>   vmf_insert_folio_pmd() to map the huge zero folio. Both use insert_pmd(),
> >>   which deposits a PTE page table only when arch_needs_pgtable_deposit()
> >>   requires it.
> >> 
> >> - Moving an anonymous huge PMD preserves its deposited PTE page table.
> >>   move_huge_pmd() transfers the deposit when necessary. For UFFD MOVE,
> >>   both VMAs must be anonymous, and move_pages_huge_pmd() transfers the
> >>   deposit as well.
> >> 
> >> Keep arch_needs_pgtable_deposit() first so architectures that require a
> >> deposited PTE page table still return true regardless of the VMA type.
> >> 
> >> Commit d80a9cb1a64a ("mm/huge_memory: add and use
> >> normal_or_softleaf_folio_pmd()") removed the vma_is_special_huge() check
> >> in zap_huge_pmd(). That check skipped the huge zero PMD deposit test for
> >> non-DAX VM_PFNMAP and VM_MIXEDMAP mappings. Removing it exposed these
> >> mappings to the incorrect !vma_is_dax() test.
> >> 
> >> Fixes: d80a9cb1a64a ("mm/huge_memory: add and use normal_or_softleaf_folio_pmd()")
> >> Cc: stable@vger.kernel.org
> >
> >How real is this?  Is there a reported-by:?  Do you have a reproducer? 
> 
> Yes, I reproduced it on x86 with a small test module. It sets
> VM_MIXEDMAP | VM_HUGEPAGE and calls vmf_insert_pfn_pmd() with
> huge_zero_pfn, without touching the page tables directly. A full-PMD
> munmap() crashes before the split series[1] as well.

Ah. So there's no real bug upstream, right?

And I am not sure it is how we want to address this. I don't think we
should allow randomly map huge zero page (and non-huge too). It can be a
security risk if it ever gets exposed writable.

See CVE-2015-3288 and 6b7339f4c31a ("mm: avoid setting up anonymous
pages into file mapping").

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

