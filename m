Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0A42FF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:09:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56EDF6B008A; Tue, 28 Apr 2026 09:09:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51DC36B008C; Tue, 28 Apr 2026 09:09:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45BC26B0092; Tue, 28 Apr 2026 09:09:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3486A6B008A
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:09:08 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EBC321B7090
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:09:07 +0000 (UTC)
X-FDA: 84707995134.02.6EDC2AC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 31AC0A0019
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:09:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e4JN5naQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777381746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4nqivCc2PRJMXKSuCzKBaD7+S/jHJk0M6k+CUV6NswQ=;
	b=4DXSyFqUvQdkdeQqdR189IyBBXXwGf9nRoyUAdP1NoFUp2MMZMZFv+mlmAq3HrC6ZeW9O1
	tPhp2NI/wzjFMBFrH8a3N1lbttsIZ2+6A0Pn9jx3mpjru0IbeVDPG5yrP9mVLZ8l8C2LZp
	MU0dmja0wjm4+Z6YDB9VdXetDkbSIfM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777381746; a=rsa-sha256;
	cv=none;
	b=H61WEStymC4mMrYKQSmmhF5JCDpxCGUutY+uTnA77AFzZgodFZ7xgMYVLUi1zx+KTiwMVb
	n5kXA6NDfNB4AkYrK5Mfg1yfJ2rmAoZRglx1LYcDKG5K0IHaPQQtaIfvB3afUtW+cOlnj3
	BVpF7E6DKWY/owDFRZcoFNnjBF3M/D4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=e4JN5naQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6AEB861119;
	Tue, 28 Apr 2026 13:09:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74F66C2BCAF;
	Tue, 28 Apr 2026 13:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777381745;
	bh=y5Wj2Mshp/u7h62ACdtB57U1YInb0w7gkuhwEVUSYGA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e4JN5naQJ+TlVk6mBeIiP5kBgPhrbIsfSTf/vPhjQnRELi7dpfbVtB7ACoelq3Jap
	 1zY46otM4NN1WLpNBlVPTdA1TzJh35tO9otOfRJTFL5s+h3VbR7VadwmoPQCR6XGDP
	 NgYZ1g8KA7kTtq1YHu3G1h0OjgQTnJnYjtx3FVNrvmuSvvNrcGXPeZQoBB292gh4Ie
	 hxyYVQSqY8X2a4YFRViC2EZb1IZyWUPFLf44FM8zPleXw3gUUQQ0msO05RFejgRbgY
	 9F6sK+FnOIcDgn5tr9dN6HAJhet4K1gOT/1BuGP0IGaTdVie8lwjqKQv4pqVuwZ/gB
	 l29nT7E3K7OXQ==
Date: Tue, 28 Apr 2026 15:08:55 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/49] mm: panic on memory allocation failure in
 sparse_init_nid()
Message-ID: <afCxZ5vYDeAlzTK2@kernel.org>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
 <20260405125240.2558577-10-songmuchun@bytedance.com>
 <afBaMEBoR_35Fblc@kernel.org>
 <9FD13495-58E8-4183-AAC0-48E50A694ADE@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9FD13495-58E8-4183-AAC0-48E50A694ADE@linux.dev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 31AC0A0019
X-Stat-Signature: 513b987ijym88q553xjckxqb1ywmya9g
X-Rspam-User: 
X-HE-Tag: 1777381745-883946
X-HE-Meta: U2FsdGVkX18QQNTTDGdKVb+a69T/n8qPlCih5pDZfbp/XQDm0o+js+rQZeaWBsYMCmqGqydHXYeqcombk/i08iP3DeYwAmryuQirICQ5/+gv+E+6OPEv7PaE/u6psz3UiVMgfmdA3csSYH8j7F44TKqFV329+Muezd2+a7VWr30w6Uq9nakVOIY2PDxqbx0fU8ZV2/67HF10U9j0rvax/a6Wb5PmqIFLSasPDIFWDAXnR5otQJfWiZDOWUjuUHuUUNCkJgT5jN4qg+mesRWjIM6tBbsg3LHHFtLvaUaLmcC3lXA4CLxxVqlQDF+B8ZE2jskVXtTQU/KwXzEbG9CxgffsGMHTqtiTAu/UlIILgmM/hT8Q7oLlo8uZLhc7yWbmvDvOx6+31FQ5UOI435OC0OwuXwK0+yZAeaFoAyQa9BAZrZrLHZ/LZZrN6mFe7KE4YYDhBh29W8mBEI/DpPWzzvKOzXmvoblDbn/tyQroR5MVyDiOhTvDe54/FHEKpcCqhJH99yWq7bCPZmKQ2k1F5L+aMkAyJGCAkEk9coIHcjbFKSJISPpyp2zSBbKwM6fjiXICF6XdIfb1FlquNiRByhbEsVox4g8Osr9oIvidEaZiFG1w+fMTjPPP/5RTRshUuwTCInGE7hOGmPjWUcs55SAYleEnJkfsd9k1A+n+zn+KXoEMcaBzy37MNeDOTXvYaLzQ3VZdNYPApLUJuEGilWNyo515uvW5dOOSaXVYsJoleJKFUuNqjbTwaWzTVbEOPqnl1Bni2J5tb1MXcyvJeOzbqoONv+e1DoPRDQDl03kZaM4wKfoNXukU0lChli/JuecwBOnOPVSv4mM069tAyMJgY5mmMUvBxEPy+mcy7w7rDlE1w+qvun0PQpw4s1bFXZCIzweQXeb3/RZ/SjS6jyVf9kZUDqVkrQMkY53NI+vTuJKjEGuRr3RfxLHhsAVGNJTfZBHrllUfzKglzJh
 MnH1kE+L
 YE2eYFEdtzpBN1iPTdbaIfipuWw5s7zondzQBp5acfhuMchKDhaGIiz2jvlhevJWUwdmxheW7Pn6DrpuqlpIgc71e02JCN7sGJWrmoQK8m+FzTH3SbcXdjGu1xm/MbglXXWjuTk73a1ab7lA15Tn6RXsEDpSiHdAjQJBnQBuWAghCK+XjXwbjrGHVTeTwuYR9migtSKj6L5AQC4+4LZu1EcnTgPfhkqviEw/fxDMFVBF8lpf0lnOKpqc2F4WVH4oTj2jAZe76sSLfsaYjrNdR6Di38+oOCSuoMp3xz3Aj9+nn2Nnjv4RdWbohaAtVzZt0yI+yOedLO4w4oUKAr7LIksdoWYJ4lCiNfkAa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Muchun,

On Tue, Apr 28, 2026 at 08:13:05PM +0800, Muchun Song wrote:
> 
> > On Apr 28, 2026, at 14:56, Mike Rapoport <rppt@kernel.org> wrote:
> > 
> > On Sun, Apr 05, 2026 at 08:52:00PM +0800, Muchun Song wrote:
> >> When vmemmap pages allocation or usemap allocation fails, sparse_init_nid()
> >> currently only marks the corresponding section as non-present. However,
> >> subsequent code like memmap_init() iterating over PFNs does not check for
> >> non-present sections, leading to invalid memory access (additional,
> >> subsection_map_init() accessing the unallocated usemap as well).
> >> 
> >> It is complex to audit and fix all boot-time PFN iterators to handle these
> >> partially initialized sections correctly. Since vmemmap and usemap allocation
> >> failures are extremely rare during early boot, the more appropriate approach
> >> is to expose the problem as early as possible.
> >> 
> >> Therefore, use BUG_ON() to panic immediately if allocation fails, instead of
> >> attempting a partial recovery that leads to obscure crashes later.
> >> 
> >> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> > 
> > Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> > 
> >> ---
> >> mm/sparse.c | 37 ++++++++-----------------------------
> >> 1 file changed, 8 insertions(+), 29 deletions(-)
> >> 
> >> diff --git a/mm/sparse.c b/mm/sparse.c
> >> index effdac6b0ab1..5c12b979a618 100644
> >> --- a/mm/sparse.c
> >> +++ b/mm/sparse.c
> >> @@ -354,19 +354,15 @@ static void __init sparse_init_nid(int nid, unsigned long pnum_begin,
> >>    unsigned long map_count)
> >> {
> >> 	unsigned long pnum;
> >> - 	struct page *map;
> >> - 	struct mem_section *ms;
> >> -
> >> - 	if (sparse_usage_init(nid, map_count)) {
> >> - 		pr_err("%s: node[%d] usemap allocation failed", __func__, nid);
> >> - 		goto failed;
> >> - 	}
> >> 
> >> + 	if (sparse_usage_init(nid, map_count))
> >> + 		panic("The node[%d] usemap allocation failed\n", nid);
> > 
> > Please consider using memblock_alloc_or_panic() in sparse_usage_init(), it
> > would simplify the code even more.
> 
> Hi Mike,
> 
> Should we add a new function like memblock_alloc_node_or_panic? Because
> we want to allocate vmemmap pages on the same node.

Heh, I missed the nid part :) 
There are a few _node_ or _nid_ allocation helpers in memblock, starting to
add _nopanic for them would be overkill. Let's keep panic()s at call sites.

> Thanks.
> 
> 

-- 
Sincerely yours,
Mike.

