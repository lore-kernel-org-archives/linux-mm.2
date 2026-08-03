Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA161C55184
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 586D56B00A1; Mon,  3 Aug 2026 09:47:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 55EF96B00A2; Mon,  3 Aug 2026 09:47:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 474E06B00A3; Mon,  3 Aug 2026 09:47:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 053366B00A1
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:47:58 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EE09B1A0689
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:10:31 +0000 (UTC)
X-FDA: 85059538662.07.E34B399
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 633C4180008
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 10:10:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N4KAjlow;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785751830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fjlIv21Q+SMsBUXeo/sr5CkfyUQlee11htxhdsArwXo=;
	b=SfXK2UIyWkBkAqBSfuHNVw3k8InAKtvOFIU2acphRdUlyFzcIXpWX4zISq4DgKNaQ+l/Qc
	kqRNzA8tb4UyOTkqAbt9wXNmYgu4uBxBtcGBrXh+J6pm4HPckNryHpwO39Mr5fBn4rzHDB
	84/R0xhh2vlJFKrtBzV0k0D1LGtwzgw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785751830;
	b=tUAe/ty40kUKfwJSeqYQWBWd2vfTYOQ/FW3r8Y11w0nEDrjZK0+I1anGFLFkrp32FQcwGo
	HKKi/nnf/XEL5B5gzrGwBzK+SwceyVEx+ta8nf001Wq7cs5xVS5cq2C428ev6GFLMOEd6R
	1ew+zylhWErCR5VPXG1iLqMlFoaaPfU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=N4KAjlow;
	spf=pass (imf16.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF25C60A61;
	Mon,  3 Aug 2026 10:10:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3B021F000E9;
	Mon,  3 Aug 2026 10:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785751829;
	bh=fjlIv21Q+SMsBUXeo/sr5CkfyUQlee11htxhdsArwXo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=N4KAjlowkT0Supz/wF3ihdY5gmItZNr8z7m1lWpOOZKUPgLLDHGutU3CIAFhyLOF9
	 afYQvWCWNEpHQbDZP5FmwKG5Nysf2o9WeKBt5xwYZYx/wjdQuh1NrkxMD7juN5DbHy
	 yQeHe/yMXJ0fMfmwK3QQk1AAmOwe7zYndDN3Jp/pwgWLy5zOR+x6Otq4mVMIhCp7a+
	 TTkpWOdBvKYwvOw5uRMhehVKa2KL5Go6mwkeTN41/aHKayW63sEen2j1MYqVTMMwgQ
	 NCNdW2ohFW3QCl04dH/z2DCdHcukjvZSDi4NGW6fEq0MYv/std1fDvXwQYcmIC36S8
	 k4GAr+Fnlf9+w==
Date: Mon, 3 Aug 2026 11:10:07 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Miaohe Lin <linmiaohe@huawei.com>, 
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Usama Arif <usama.arif@linux.dev>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, Xu Xin <xu.xin16@zte.com.cn>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v3 02/15] mm: introduce linear_anon_page_index()
Message-ID: <anBjpdMicqaGADr-@lucifer>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
 <20260729-b4-scalable-cow-virt-pgoff-v3-2-e8ecfefea812@kernel.org>
 <e01ad01e-715c-486d-9a26-1126c666947f@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e01ad01e-715c-486d-9a26-1126c666947f@kernel.org>
X-Rspamd-Queue-Id: 633C4180008
X-Stat-Signature: wk1cbupb4qobikekrcforqm393jht63w
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785751830-264630
X-HE-Meta: U2FsdGVkX194dNNpK+67m6z9Vv9gmjcssHOT3DM44oSDPrFYsF0b8XXQrZ+WFbE0FEGvQTWxod3spIKx8TfMuOwtkcQEaKfnxlg/dThwln6ZdXiaVTFU7+YRLp89wSb6+mBvoqWIXUdwOeJyqvdkPkaPZO6NePpVIxKcXyHDduDuYsoCNOTr+5cBUSsPwN3I1toPkejfeD6W3hfrCuPmeh6HIAX006T4NO16xDhgnrlQ1CYispyCv0/xZolwkop3VJI73LSzRDJaschkPh7MtwkOe0Y9FciqNwdrP4kbMO0Kq0USlVaJAIo1eY0yGR8WFGW1h4THhTzPSTbzI5mwEdPISgUh67DnYnQPn+t4JuBMvSrK72dW+3luq15PaBW32s/pTlUHG0dO7Br9PPDBi/2ZJJC3wOVJc/R2cNMDienC+U+jqjWjt5q7wTjumLhcSZaSlaJLNP9GlGRs8Qh9eRtYaGrzDcIIJV/JrR6eUNmMHn1PZjIyAsCmOjBZ13iHY2HT7AcnZJD+Zi0MYJ9PCKjh429J/GffbEw+n5k5Fn50NSubqSLwdKEdwtt/zhK1k7jo2OV6Anzl3FPtmV/VnjBMb8NrpT5UxSpu4j9eHMiJAKvpqgLImGL0GuPAk/uQLW7abt+/K5UHR+bDkQiZNQfOxnR7YYGUSxL3Y0bzEbQUwFsYmT/e6qRPKQH31SsxwqOYVqqxkI5HisXZgbDlpa4HVTqN6QbAR3JpJPKUYIEJFHSb8rh1Cmx7MNTePlsdb24umjw5RmN27L5PEL/QTR/2Renb/Pu614gKQR3hYIBbU9yNB1ca1ZNGmYaxfmkTJ385AliIiHbAApVCdNnjsCLblLPSq3gw178NpQJP/5lBIW3MLHbbPelaoCl4y0ipiDFL192chczoe+9ktVNDqUnokKSCbqhen1Y4QocGu9gY9iTJs8AwJni2bP2apLXfpL5Mi8/sS6Y0zlPgQkI
 vYVkBpmQ
 sTho1WsJ38zxJEi9dOdRj6du9Km9+HZaCq6u7SfTassvNVUicC1Yw1xH/70Z65iQwg8tKxO/j8axOyJfehDyYGVlO5x5p7PU8SxLJ1ESlBxl+x75C0c1C8XfphbQUIwtFDCBJY4mgWwbi/6gqiWvVvLI6NCwT51vIooZ84fq6MZvqWIdIlxkkj8GHbt5dZhOwQ5o71JftTTIwfy/aMPzNS8x4XTIwYXpJ47idrZpIpNbZayOEo9K7B1mPMm7xF2Qljt8cNKMrOqwx1c0nN2RVQYTwA2Z31F3nOl4pozHmQ2750ZOy1TEHFs6qKqJ42QGBNzk8gSHm2fVCbArPS3iN8mkbdh5uErwzE6hAT1U6pWv3A0gatNFvC0vUU/dGB9uy8eAReYm5gX/78XHgkREbXNTrQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 03, 2026 at 11:34:32AM +0200, David Hildenbrand (Arm) wrote:
> On 7/29/26 18:48, Lorenzo Stoakes (ARM) wrote:
> > This function provides the anonymous equivalent of linear_page_index(),
> > instead offsetting based on the anonymous page offset of the VMA.
> >
> > It is valid only for anonymous or MAP_PRIVATE file-backed mappings. It must
> > not be called for shared file-backed mappings.
> >
> > For pure anon VMAs, this will be equal to linear_page_index().
> >
> > Assert that both of these invariants are true In linear_anon_page_index()
> > and implement the algorithm in __linear_anon_page_index().
> >
> > Note that MAP_PRIVATE-/dev/zero mappings will satisfy vma_is_anonymous()
> > but not fulfill this invariant, so when asserting this we check
> > vma->vm_file to account for this.
> >
> > We do not update callsites yet, so no functional change intended.
> >
> > Also const-ify vma_is_anonymous() to make it compatible with the
> > const-ified linear_anon_page_index().
> >
> > VMA userland tests are also updated accordingly.
>
> In general looks good, some comments below.
>
> >
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > ---
> >  include/linux/mm.h              |  2 +-
> >  include/linux/pagemap.h         | 42 +++++++++++++++++++++++++++++++++++++++++
> >  tools/testing/vma/include/dup.h | 25 +++++++++++++++++++++++-
> >  3 files changed, 67 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/linux/mm.h b/include/linux/mm.h
> > index df78847f5f07..64214191e7c6 100644
> > --- a/include/linux/mm.h
> > +++ b/include/linux/mm.h
> > @@ -1556,7 +1556,7 @@ static inline void vma_desc_set_anonymous(struct vm_area_desc *desc)
> >  	desc->vm_ops = NULL;
> >  }
> >
> > -static inline bool vma_is_anonymous(struct vm_area_struct *vma)
> > +static inline bool vma_is_anonymous(const struct vm_area_struct *vma)
> >  {
> >  	return !vma->vm_ops;
> >  }
> > diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> > index c6fc783aaee5..259177544b03 100644
> > --- a/include/linux/pagemap.h
> > +++ b/include/linux/pagemap.h
> > @@ -1101,6 +1101,48 @@ static inline pgoff_t linear_page_index(const struct vm_area_struct *vma,
> >  	return pgoff;
> >  }
> >
> > +static inline pgoff_t __linear_anon_page_index(const struct vm_area_struct *vma,
> > +					       const unsigned long address)
>
> Nit Usual "two tab" comment (same below) :)

Ack will change.

>
> > +{
> > +	pgoff_t pgoff;
> > +
> > +	pgoff = linear_page_delta(vma, address);
> > +	pgoff += vma_start_anon_pgoff(vma);
>
>
> I'd simply do
>
> 	return vma_start_anon_pgoff(vma) + linear_page_delta(vma, address);

This was just to mimic the existing thing linear_page_index() did (which in turn
was based on what the original implementation of linear_page_index()
did), will change.

>
> > +	return pgoff;
> > +}
> > +
> > +/**
> > + * linear_anon_page_index() - Determine the absolute anonymous page offset of
> > + * @address within @vma.
> > + * @vma: An anonymous or MAP_PRIVATE file-backed VMA in which @address resides.
> > + * @address: The address whose absolute page offset is required.
> > + *
> > + * This returns the anonymous page offset of @address, which is the page offset
> > + * the address possessed at the time the VMA was first faulted.
> > + *
> > + * For anonymous mappings, this returns the same value as linear_page_index().
> > + *
> > + * For MAP_PRIVATE file-backed mappings, this returns the anonymous page offset
> > + * of @address, which is the page offset the address possessed at the time the
> > + * VMA was first faulted.
> > + *
> > + * It is not valid to call this function for shared file-backed mappings.
> > + *
> > + * Returns: The absolute anonymous page offset of @address within @vma.
> > + */
> > +static inline pgoff_t linear_anon_page_index(const struct vm_area_struct *vma,
> > +					     const unsigned long address)
>
> Dito.

Ack.

>
> > +{
> > +	const pgoff_t pgoff = __linear_anon_page_index(vma, address);
> > +
> > +	VM_WARN_ON_ONCE(vma_test(vma, VMA_SHARED_BIT));
>
> Could we test or COW mappings instead?
>
> VM_WARN_ON_ONCE(!is_cow_mapping(vma));
>
> Because we must never have anon folios is non-cow mappings.

(guessing is -> in?)

is_cow_mapping() == !VMA_SHARED_BIT && VMA_MAYWRITE_BIT

!is_cow_mapping() == VMA_SHARED_BIT || !VMA_MAYWRITE_BIT (by De Morgan's law)

So the delta here would be this being called on !VMA_MAYWRITE_BIT anon mappings.

This is called from:

* linear_folio_page_index() - tests folio is anon first so must be CoW
* __folio_set_anon() - must be CoW
* __page_check_anon_rmap() - must be CoW
* try_to_merge_with_ksm_page(), ksm_might_need_to_copy() - must be CoW

So yeah this is fine, will change!

>
> [...]
>
> > +static inline pgoff_t __linear_anon_page_index(const struct vm_area_struct *vma,
> > +					       const unsigned long address)
> > +{
> > +	pgoff_t pgoff;
> > +
> > +	pgoff = linear_page_delta(vma, address);
> > +	pgoff += vma_start_anon_pgoff(vma);
> > +	return pgoff;
> > +}
>
> Same comment as above.

Ack, will change.

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

