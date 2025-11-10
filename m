Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75757CCF9E3
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 13:45:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD1F88E0006; Mon, 10 Nov 2025 08:45:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA9878E0002; Mon, 10 Nov 2025 08:45:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BF798E0006; Mon, 10 Nov 2025 08:45:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8AD2A8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:45:08 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3157B140D17
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:45:08 +0000 (UTC)
X-FDA: 84094818696.23.3B74620
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8CA9E4000E
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:45:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nJRJnoHT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762782306; a=rsa-sha256;
	cv=none;
	b=3msBB7nmR8vw9JOD/6n7Rc7CqwecT5oFmj+l9HqK0jgnGcwphlm3DTen3nSsoH7SxdGANa
	pfFrCuMKLhgzxf6qJPVr2KtXzmJOgltuSiQz4neik27wQWA0SW7dbIu3kBkRN28H1Z+vRe
	KaSj/uSAaKRsiYAIe6OORH+oSvErW7w=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nJRJnoHT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762782306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EEsOrLFryvrbHeWzdBcm5BPkW195VediZuMpCkSB4Cs=;
	b=oyr+DGPH9A2mddlonbLjI1Q5V3t9tbElTBNft5ZVwtoZ6weVtBTCPMO4E07DsH9D231bbt
	H9UwhT0hgtx7aRF+LKnqimbOc9+iln8X2TbXSC6ELkjUKZXJ0VzzuGwradED4Fr/j8S00w
	McYEN/gZC0PTrAZCiagPDt0wnpvdxxQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C648F601AA;
	Mon, 10 Nov 2025 13:45:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5E7C4CEFB;
	Mon, 10 Nov 2025 13:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762782305;
	bh=K1xogRmcdnJHCvjWGY+Er/5mR9phjWmkoC/mTpkqq+Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nJRJnoHTl+9Cbeu8AtpQVl6MNu8LP7vYCarp/uXV0NbcLGe5/UyGPbNA4xSCI2RwC
	 UPZmRzo9UEkoy089Iscpp5zjMrREPUnqLbKm++nbSkNKPu6x56aI+Xh3ev/QLMxEec
	 5c0fkBUdfIeOd6MKzMEIqZzG7e6gVDaVhCSdHwTLfdkd4kAYztyAKHnKyl3X+S3fzV
	 9ovZf4kVEn7eNQe3LemtVmi9zH1TsJkySJDyQTzaD4W3PCvng8gUNAjb73ZhIYrUPz
	 9YxUpUh25WrfYWIBf27UgkW6dDxg8oF9+SWT6FXPYKflLL4vUgUmyLlAW0YPlrGzUi
	 pT0FLuBk5ZvOQ==
Date: Mon, 10 Nov 2025 15:44:43 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Peter Xu <peterx@redhat.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Arnd Bergmann <arnd@arndb.de>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	SeongJae Park <sj@kernel.org>, Matthew Wilcox <willy@infradead.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Jann Horn <jannh@google.com>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-arch@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v2 01/16] mm: correctly handle UFFD PTE markers
Message-ID: <aRHsSxhIikzC9AAN@kernel.org>
References: <cover.1762621567.git.lorenzo.stoakes@oracle.com>
 <0b50fd4b1d3241d0965e6b969fb49bcc14704d9b.1762621568.git.lorenzo.stoakes@oracle.com>
 <aRHJ0RDu9fJGEBF8@kernel.org>
 <1a77db9b-ddb2-42bc-8e8f-f4794a5bfc6d@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a77db9b-ddb2-42bc-8e8f-f4794a5bfc6d@lucifer.local>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 8CA9E4000E
X-Stat-Signature: 6576cg4hfq11tcaf18kux9zc1o8dwb6g
X-Rspam-User: 
X-HE-Tag: 1762782306-240688
X-HE-Meta: U2FsdGVkX19ufUxbw2IN5/2QoQTMesOJ9QISa+98GpGFwP+vrSEve+7urimKsx710CcQfOM5PfqB8mlr5+uoY25FxVS6+skDO981MWFMjLsmAj89sKS2B26/y8NNaoF5GUku5/cv7U92TrJbuZOujHZ6qgJox5NgLSH5WerAfvbE0AznJYeYlJSGScsYn56CSgomM3w43/4t4pG2YvSYqmfZifKw17NETPLshBRk0hvbvY3cwJjjVCKnC3r0ZDQVYVB0U+7ys8i5YLmwojrQwQwpIIGvCj6gvPRKwDQwVF/pTVAb4kXOzvA1fuPhq+U27X442e859NUVtmhXIU/gP7rRpxBatk5CJXVNBGnArj0Wf9aMbdGhEILwlUD8GpWU3ureDtk7YbCRGhg3Z/SHfqmNp+uhpou2St+5N0wmcAs7eniUSQKhV0AlT8dpNg6TPTWBIypYvn4LGFDo8wF1Gi8Ojl122kAYrlRVXO4P3tHTbvtZRHp+Xj2yqoudWUSzCH1yzyqQ7oC6OCijpbAZ6ZCBEugZd+GL7ta/qeiHf3eef7GOa9WcI3b/8CRL5XIHpqVwCact6XDUVoEsLUAZUTG1mpnRkmySjAhNkxoI3o+zPyC5eQ9gdMEk/zj4UxkBNbdtxKvGwFDG7lYpy3E4wWjEoa6xHxFWqU/enFOGox33TjGcw2Tnkbm3KUBP4p7/aBolW+iZ8pYWVs0J+STFgUV1mYDm5pesapedLuMPSprEcnNXegMIDu55htkGIRKd+izvrLDELM0xZ5YTrEio8QsL6r+OUAe2EsLgVjqMWzb+FH2gAzQwIh7VnEK314arFzHXhPHHf82TLik1sRop0vzrAES01VbxoOyeLVqzw0k1g9y0GSCRCVLDxw5hC6ysxezgwk6r6Wbay7U2VOm2XGhJkLKt4XR9GCoNSHi0HHkNcTSDM7c3RRBfsvo5TydZa3P+J6R3D6RhGtgDZDo
 XTJzzVLp
 vlYiLrWvzRg6vQu5ayzoJGbLVrZt+Px3O+HAHQZsZuB9YXuLkbrktSnNCRlvYHmnSvvcFrFYRiJuONKBx0ONQ70+uZPp2DrE6c5XCrFgZNXM+liT1U3p18G1qUo22c6v+co9AnhRF+ya+5DaQiDmyHYLfKlUmB1L+SMFEhoHNkpWPW1ra/9yoeWan+lk7HSGMppG3pQDFhZBHDmc8Flay5X12ISwvfIY3XODeqAIllmzZ+j3mE0HC9fIEDN1H08jn5reqKWu1AUL5S8qq3LMu3T7DZzPxcmgsCCO/gjRZ+Bn/RtrtFErVDjCzXLS1ava/myaoTa7/4WeeP6sIUSJMpnO+M0Vw3Ao1g7ADzhIORbE1M3tSo0Xagd3eXrslI/FLmW3w
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 10, 2025 at 01:01:36PM +0000, Lorenzo Stoakes wrote:
> On Mon, Nov 10, 2025 at 01:17:37PM +0200, Mike Rapoport wrote:
> > On Sat, Nov 08, 2025 at 05:08:15PM +0000, Lorenzo Stoakes wrote:
> > > PTE markers were previously only concerned with UFFD-specific logic - that
> > > is, PTE entries with the UFFD WP marker set or those marked via
> > > UFFDIO_POISON.
> > >
> > > However since the introduction of guard markers in commit
> > >  7c53dfbdb024 ("mm: add PTE_MARKER_GUARD PTE marker"), this has no longer
> > >  been the case.
> > >
> > > Issues have been avoided as guard regions are not permitted in conjunction
> > > with UFFD, but it still leaves very confusing logic in place, most notably
> > > the misleading and poorly named pte_none_mostly() and
> > > huge_pte_none_mostly().
> > >
> > > This predicate returns true for PTE entries that ought to be treated as
> > > none, but only in certain circumstances, and on the assumption we are
> > > dealing with H/W poison markers or UFFD WP markers.
> > >
> > > This patch removes these functions and makes each invocation of these
> > > functions instead explicitly check what it needs to check.
> > >
> > > As part of this effort it introduces is_uffd_pte_marker() to explicitly
> > > determine if a marker in fact is used as part of UFFD or not.
> > >
> > > In the HMM logic we note that the only time we would need to check for a
> > > fault is in the case of a UFFD WP marker, otherwise we simply encounter a
> > > fault error (VM_FAULT_HWPOISON for H/W poisoned marker, VM_FAULT_SIGSEGV
> > > for a guard marker), so only check for the UFFD WP case.
> > >
> > > While we're here we also refactor code to make it easier to understand.
> > >
> > > Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
> > > Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > ---
> > >  fs/userfaultfd.c              | 83 +++++++++++++++++++----------------
> > >  include/asm-generic/hugetlb.h |  8 ----
> > >  include/linux/swapops.h       | 18 --------
> > >  include/linux/userfaultfd_k.h | 21 +++++++++
> > >  mm/hmm.c                      |  2 +-
> > >  mm/hugetlb.c                  | 47 ++++++++++----------
> > >  mm/mincore.c                  | 17 +++++--
> > >  mm/userfaultfd.c              | 27 +++++++-----
> > >  8 files changed, 123 insertions(+), 100 deletions(-)
> > >
> > > diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
> > > index 54c6cc7fe9c6..04c66b5001d5 100644
> > > --- a/fs/userfaultfd.c
> > > +++ b/fs/userfaultfd.c
> > > @@ -233,40 +233,46 @@ static inline bool userfaultfd_huge_must_wait(struct userfaultfd_ctx *ctx,
> > >  {
> > >  	struct vm_area_struct *vma = vmf->vma;
> > >  	pte_t *ptep, pte;
> > > -	bool ret = true;
> > >
> > >  	assert_fault_locked(vmf);
> > >
> > >  	ptep = hugetlb_walk(vma, vmf->address, vma_mmu_pagesize(vma));
> > >  	if (!ptep)
> > > -		goto out;
> > > +		return true;
> > >
> > > -	ret = false;
> > >  	pte = huge_ptep_get(vma->vm_mm, vmf->address, ptep);
> > >
> > >  	/*
> > >  	 * Lockless access: we're in a wait_event so it's ok if it
> > > -	 * changes under us.  PTE markers should be handled the same as none
> > > -	 * ptes here.
> > > +	 * changes under us.
> > >  	 */
> > > -	if (huge_pte_none_mostly(pte))
> > > -		ret = true;
> > > +
> > > +	/* If missing entry, wait for handler. */
> >
> > It's actually #PF handler that waits ;-)
> 
> Think I meant uffd userland 'handler' as in handle_userfault(). But this is not
> clear obviously.
> 
> >
> > When userfaultfd_(huge_)must_wait() return true, it means that process that
> > caused a fault should wait until userspace resolves the fault and return
> > false means that it's ok to retry the #PF.
> 
> Yup.
> 
> >
> > So the comment here should probably read as
> >
> > 	/* entry is still missing, wait for userspace to resolve the fault */
> >
> 
> Will update to make clearer thanks.
> 
> >
> > > +	if (huge_pte_none(pte))
> > > +		return true;
> > > +	/* UFFD PTE markers require handling. */
> > > +	if (is_uffd_pte_marker(pte))
> > > +		return true;
> > > +	/* If VMA has UFFD WP faults enabled and WP fault, wait for handler. */
> > >  	if (!huge_pte_write(pte) && (reason & VM_UFFD_WP))
> > > -		ret = true;
> > > -out:
> > > -	return ret;
> > > +		return true;
> > > +
> > > +	/* Otherwise, if entry isn't present, let fault handler deal with it. */
> >
> > Entry is actually present here, e.g because there is a thread that called
> > UFFDIO_COPY in parallel with the fault, so no need to stuck the faulting
> > process.
> 
> Well it might not be? Could be a swap entry, migration entry, etc. unless I'm
> missing cases? Point of comment was 'ok if non-present in a way that doesn't
> require a userfaultfd userland handler the fault handler will deal'
> 
> But anyway agree this isn't clear, probably better to just say 'otherwise no
> need for userland uffd handler to do anything here' or similar.

It's not that userspace does not need to do anything, it's just that pte is
good enough for the faulting thread to retry the page fault without waiting
for userspace to resolve the fault.
 
> Cheers, Lorenzo

-- 
Sincerely yours,
Mike.

