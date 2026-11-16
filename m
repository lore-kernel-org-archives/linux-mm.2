Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D71DD606A322
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 16:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j6GIz5y6
Received: by kanga.kvack.org (Postfix)
	id D7D5F6B00EF; Mon, 16 Nov 2026 11:55:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D556A6B05B0; Mon, 16 Nov 2026 11:55:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C92016B05B1; Mon, 16 Nov 2026 11:55:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A00D26B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:55:23 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 290091201C3
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:55:23 +0000 (UTC)
X-FDA: 85441582926.24.638AAE9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8120A80002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 16:55:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j6GIz5y6;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794848121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MOX2IuvHhL6KYQ9Yw7AqZupB+f7laGqvjxs74L8EXG8=;
	b=umO5rFeFDzNrYfQYdXBHqGd8Kd0+Aj1EmNTnRJYI8RajteHnCq69G5uT8S/4IzB6NLl3Bt
	i9kITyAvkPZ0eIJ6ysJgN7YGiiAGBvlvnWZ0JebUq3wfSKBjba+UQ3Ad0JfSvMnyZboj7a
	pT74UsS9rEzbk7dl5V0ZX/XhFWcYAxM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j6GIz5y6;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794848121;
	b=FpDSAAro8TtZCVQ6qB2wD+kUSgENbiiUuZ34C08z63bOZJiWAALOheIdEsdkenOTG7UVTH
	rVbEVhI9lKAil/6ihhSLUOS3gXq9RrjXmJdEeC17DCtSHj9tCJw6JLILJAR76BVLx1Bpc1
	ZInyib8+DzJfwj95NrOlRykITnmdej4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB2EE61808;
	Mon, 16 Nov 2026 16:55:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0771F000C4;
	Mon, 16 Nov 2026 16:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794848120;
	bh=MOX2IuvHhL6KYQ9Yw7AqZupB+f7laGqvjxs74L8EXG8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=j6GIz5y63dt2rZbL7xip5OTicaJXloFWpGTULYFqkW9HNEePnEJsw/7ovDbpWiQDO
	 BechQm/psjOWB/RzQycF0bnACUr4SnQgyaJZGQnMMOsrmeys0qzHu7IzBstSYksORU
	 ZH0CAlw6byFvqDhSazJnACEhhLQyvMB0Dyqx9Us6iBvreHHS0U5Gto+9/Bwv2YjTmd
	 w9OJWt3ApH+4oPK8ln5XSFK1K9BUegykOibmGaHp5oIMR29n6LOwoRbwSkSoAdW2ot
	 7WZXWkPsMcpymkpe+jgN53EDt4FjWuL54O7Xer9UNnRsIhZJ92t2/wrqIB6sPr1zVC
	 Md5feKFAEJoYg==
Date: Mon, 16 Nov 2026 16:55:12 +0000
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
Subject: Re: [PATCH 3/3] mm/huge_memory: only compare PFNs of huge entries on
 huge fault insert
Message-ID: <avsz6Op6mfkF4y1x@gremlin>
References: <20261115-huge-pfnmap-fault-races-v1-0-537605643f6f@kernel.org>
 <20261115-huge-pfnmap-fault-races-v1-3-537605643f6f@kernel.org>
 <e13044a0-871b-4033-8a79-22cb9653b6b1@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e13044a0-871b-4033-8a79-22cb9653b6b1@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8120A80002
X-Stat-Signature: y31qrfzud58uteptanrebyz9n41cwyid
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794848121-612116
X-HE-Meta: U2FsdGVkX1+4lyqrCWKRaaxa9owAJZ3KaspBtENDz3eMLMfegbxeG1n25SAkYdmMe7b3W4ElHAj9wF2rU86xEDCJkIgwcLHWXGkZiizRVqgK357odQCxEwVZ9qNNaLI3plqs/T5sduSbGZqypTk0t8gyNZw1ukDfm3e3/QJnyc70f4+egAk6bteIaKwMoDa9CpfGRQSS54HEgU7ZxxbPdDGj59KWbV1KhHFsTxXiRtA8awvQFjViFC/y4FBLTwQR0a37eTCVJ6RwU6a+Gh1pZEslEp9gP0FTk+yxONnRDq2bxDOua92xUT2MLcH4yLgFbO03BUDDj4+UcOkSVqxNiBpTTnMCrnhYO/LTsiH+OLaeCuxcF4SYLDkK+1X/ib/V2ho4JNTn4nR2M71I1yeywDxwiuU6zfP2ZJ7o/5cFqLCSUlRi270FwABoEM0+o4DR8rBfxfl2PgXMnUOZVFUmLWmOANtaNf4uHuSfZCyMvBifDG7XlZplyr+YnkznW95rMb/sAJnrEAG2X6eQDZf2FwExb98fqKqQZqj4NxipA2FLFRaP/gHgaIRSjiIblfyAtjd5OmGG2fbH3obhTQlXgUs3L/D59t+6Yhsq5jSA2h3S31axfjC4YEmDc3HAuSazCMlV9IEEwO2t0mBvk4opxfv8kikHSkBk5OLO+s+k/LulKH1pQRPjwVomLsXFhOKe+hYB6xCzFs1Ni4/m5kPKAtdVoDqhOq92RDfdNRGS0ERUeihGOAkKhXzefbJmRna3ipfiSMOzyoM2ykTZv06eHTetdxTUflJhY6SDyrnptYLGJx7bZjDqvv6wv7UyOZMqZMCTawIBAEE3j2x4aH2ep4+Z+TfWcUUH2nAFCxHiGWo7GeCYVTQvmyVhVNGoNLIoDLTmn5cUteESzkdKkneBoSQrQWvgYdlQx0KQLcTiKpAVsD/GaNNI1YepQjr/JOCZiyl8m3DfqsIxd+RODhl
 KTk9veCA
 UpphZmbzam3gFYerdMRmKZBoBihRgOoACX7He8aroxT0qxc5nKhFuz5S8yDkmzKd/u27fsni8Tu91nx1FQiZZlqvoWSWkj9obrNMu9auuQMk239Fz65RXDmM2fRq5X2pALdn9eNno/3SRJVhPE7EhFyYqD52bR6CCpGJvWwPcvWGWFooIPnbB8KkVJi6Q5re6c9UmkvyqZFYcL75Q2PqYPbLVIPMxL5P/7W6MqJx/vvhu9vAbpwulOT9ONl8CTtWisbPE6ZEUSlaNkMOOdgRB7FVQY6eyWLvSHOwwUBuQDPnrLg6UbMa4RRV3rUtjQmZLxuxqxzwnBejf2RW56FN09QV9ZKABAzTYYc9b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 16, 2026 at 05:01:52PM +0100, David Hildenbrand (Arm) wrote:
> On 11/15/26 21:58, Lorenzo Stoakes (ARM) wrote:
> > A driver that implements both ->fault and ->huge_fault must anticipate
> > concurrent use of both.
> >
> > This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
> > concurrent with faulting, as that only holds the mmap write lock and thus
> > does not exclude faulting threads stabilised by VMA lock.
> >
> > insert_pmd() and insert_pud() have issues with this as they both assume
> > that, if the page table entry being populated is not empty, it must a
> > present huge entry.
> >
> > This is problematic as if it is a write fault, it compares its PFN against
> > the one being inserted, warning if they differ, on the assumption that the
> > entry is a huge leaf.
> >
> > Since the entry may be a page table, this is invalid and can result in
> > spurious warnings.
> >
> > Equally, the entry might be non-present. Nothing can install such an entry
> > in the VMAs that reach this code today, but there is no reason to rely upon
> > that.
> >
> > Therefore only examine the PFN if the entry is both present and huge, and
> > otherwise simply return VM_FAULT_NOPAGE so the fault is retried and handled
> > at the appropriate level.
> >
> > This is what already happens for a read fault, for which the existing entry
> > is not examined at all.
> >
> > Target the commit which introduced the first driver which both mixes fault
> > orders and passes the write flag for the fix (since this commit, both
> > drm_gem_shmem and panthor are prey to this issue).
> >
> > Reported-by: Eliav Farber <farbere@amazon.com>
> > Closes: https://lore.kernel.org/all/20261112051440.16140-4-farbere@amazon.com/
> > Fixes: 7bfe3b8ea6e3 ("Drivers: hv: Introduce mshv_vtl driver")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  mm/huge_memory.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 0d589be136d2..da632c3e834b 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -1643,6 +1643,10 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
> >  		const unsigned long pfn = fop.is_folio ? folio_pfn(fop.folio) :
> >  					  fop.pfn;
> >
> > +		/* We may have raced a fault which installed a page table. */
> > +		if (!pmd_present(*pmd) || !pmd_trans_huge(*pmd))
>
> Ok, we hold the PMD lock, so that cannot change concurrently.
>
> Given that we are in THP code, I wonder if we could just test for pmd_leaf()
> instead.
>
> Same below for PUDs.

That's what the original did, but as the commit message says I don't want
to rely on the entry not being a softleaf here, in case we do something
later that changes that.

It's future-proofing.

>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

