Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7331606A337
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 08:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hCY7sdiA
Received: by kanga.kvack.org (Postfix)
	id DDC676B0B1C; Fri, 23 Oct 2026 04:18:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8D856B0B1E; Fri, 23 Oct 2026 04:18:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7C296B0B1F; Fri, 23 Oct 2026 04:18:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A9B166B0B1C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 04:18:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 22031C0382
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:18:32 +0000 (UTC)
X-FDA: 85353189264.17.343EA34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 7C677140006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:18:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hCY7sdiA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792743510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=prHVcZI7ZOeGWeFdFfhU7LU8KIRKEIpIOhbDbC0BxoY=;
	b=33AKgWCkGf0W1MY/5p8+qpAa6DPBzEyhcoGZV+/K3iq222cGYb4EK7ekvc6Q7DZHxhOc7B
	N+xAQNR/R7ZY6zcQ+9XRq8sOoCpZWoQmvBYrxfsQb56EnoDlbVPAul5p5R2EhGzzj452II
	ZyT5WUneUqt17hGxxbhVE5JPudTJFC4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hCY7sdiA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792743510;
	b=OdInfy/qvmC9gMfJOYyRt3MasV7dHXQQwFHVC/7hjsh36jvq+7XDkrXGxm0/+biUWHMHgJ
	nEZBZn9NY7E6eOONOXzuijOkGM30eHatvM7SgF+eeJbgS+9F/m0RNTyuPf+3ApQCBIf2CI
	037TCYvh9NQgpNfexPtpHrw0TdT/L7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B7E042A5C;
	Fri, 23 Oct 2026 08:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D55B31F01825;
	Fri, 23 Oct 2026 08:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792743509;
	bh=prHVcZI7ZOeGWeFdFfhU7LU8KIRKEIpIOhbDbC0BxoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hCY7sdiAqdyG+S5ZJnzwRNcuf3xJP5Ev73Lay/aIUuHLTU+IVehh4YYIlZl7rOZNM
	 Ec4Mx8SM+w8ZR/+jplutOn3FRG+fsv0RxutkYJ4TOFTnGlJj+Bt+wOCfuOclSCOT2l
	 8gfF83+R7ag4xA2J1hXGPG3ahvNkwt07Yh6wV1dCikJOQVgS1MZoh97iT7eayWW6B3
	 0wnYU0dkfwyclWs4SA7TCTj6g1pBXWshZK05dwL0w92hw2CwlQg7N4Z6hESp5KaJ4g
	 IIBDtdtKQnq1JE2QEWqSJCbe0pkAGZIfJ9SVeKeWTOHbfFaqXhfeE2bZvKrFOakCDv
	 H0j7KuZpodGWQ==
Date: Fri, 23 Oct 2026 09:18:24 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Luiz Capitulino <luizcap@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Jakub Matena <matenajakub@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] mremap() fails VMA expansion when VM_MIXEDMAP is set
Message-ID: <atsWop95CHj6oTSU@gremlin>
References: <20261023023106.515365-1-luizcap@redhat.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261023023106.515365-1-luizcap@redhat.com>
X-Rspamd-Queue-Id: 7C677140006
X-Stat-Signature: ujaadrf3on7ewr6s7ya7rh3dppj451fb
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792743510-350984
X-HE-Meta: U2FsdGVkX19ZRbligp43Ldj+AW5THgGpytlMRGAnOFREypQlKCYKWPh4XWMmsukfQWtWMMZ4Ygd/I4f2kzoYKhuqGC4TKkwOy6YL1rqreSsQfZmKfffu7SMJh7CvsRATwxmfgDojt5ap/tkU8QTW0KvSKc7NqH0mpq0FKDhyCNnhWPcX9Ccr5UM4VlNQb9kB67+bxwQxu67ywqEdEsN6W1ipxUr+3j3hLptz10TirPS8FdAixjYXP1m5/8+lkc+Jw7FtWZyVgfxAaoDR/p7opUQy/hjbog7+1kMkMs59sVtTpez8/qHJaOAWC5roRD8GOeL9P4jVAq2wvjaoCGHoPGkYFpQ2xccoAQBVJcnt5/CKJO10ta1l531QrbcBgr/E+vjYHHGvhRsUi3SuAA9HlKxx11XX/OGz7tF4/cEhKLtCnWA/222Sz4nPuGjqjnHKumfsT5rYhDj48NtxPWI0YEbUgZG0NkDLC+sAWp0WsFbce0+YNqbq9Ka21UWxuZMFV478pz4Tb2QwzWA7he9/BqD9wcHY1EXC75VMhyqf9mmi5xlr8gACs24O8AsxUtR2uDYPilaUztXh+l8s1yyztmpvJJGhk6Eh0NOIByxb7EXbkj2nnH3m0FDt2xtSjf+z1SPeQ9Rpzjc/LHIHMqZWpDJt2iiY0OD8SS4Xi3qSPLANo2hEtfIjePE4FJlWpn/pVe5MY7NMsw+hzWVCrLg3NUhCyQh+uWUc7zyyD4hoxOMJ37+DCZIdaD17iYJSnDRTWTH5q9cLrz/om2yV77bVDBzadbIB3P+E4lKsHsBCKaQiFbeA8K+bbiaIp/z26gPNFe8zrIRTTFG3Z0NstVr8t0DJKy+kYjE5QwmZZcDPK/2ECjbfZb6PQI/SF8FBptiD7M2bpYNUKgGr/YRXk81x5MfNecJt+0uREMwnY5I3LQuUSR2zWeI3JXjMgFykuT/ojoBdkUFsmaKjEFw2uE1
 pneFFEs0
 gjWUhnrIgNvZwLqaQ0DJ11LbZhwwv5sKnZ3ZxlcGCKbPeULVwiAWaCANyjPaRAsVGOGBGMDAmveYE8SO3Wg1Uq1wxEFPKD+x85zf4Wyq68VWWyzpa6xNXwWh8ypYMSgra2q3DJyoQsesjSEKo/lD1NW7P7ihxX8ths2CYrMzdVN2xrf8jrf5JDnJV+T/JEd4xkSC1ieeIBfPqENCYqJqHfWyM90dmHuouUVtHxYfxA3oc9eKRwhw4tXNJvmTCb4kcqirIvf/VfG6hWmbNIzy4zA4CfOyA9DOytF/WcW1TYoNYKLw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

I'll look into this but obviously we won't make mixed map regions mergeable (nor
were they ever), that's completely broken.

The most recent version of the mm code (which is going to be send to Linus soon
in this merge window) documents why:

/**
 * vma_flags_can_merge() - Do the specified VMA flags permit the VMA to be
 * merged with another?
 * @flags: The VMA flags to test.
 * Returns: true if the flags permit merging, false otherwise.
 */
static inline bool vma_flags_can_merge(const vma_flags_t *flags)
{
	/*
	 * VMA merging assumes that a VMA's flags and fields completely describe
	 * its state, which is only the case for mm-backed mappings.
	 *
	 * Mappings which are not mm-managed may have established state upon
	 * mapping not embodied in any attribute of the VMA.
	 *
	 * Additionally, private (CoW) PFN maps encode the source PFN of the
	 * range in vma->vm_pgoff, which may otherwise cause spurious merges.
	 */
	if (!vma_flags_is_mm_backed(flags))
		return false;
	/*
	 * hugetlb mappings contain per-VMA state, so their flags and fields do
	 * not completely describe them.
	 */
	return !vma_flags_is_hugetlb(flags);
}

I'll dig in + get back to you.

--
Cheers, Lorenzo

