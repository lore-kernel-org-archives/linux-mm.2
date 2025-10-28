Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3769CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 12:48:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F1F928E0191; Tue, 28 Oct 2025 08:48:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED06D8E0016; Tue, 28 Oct 2025 08:48:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71788E0191; Tue, 28 Oct 2025 08:48:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C26298E0016
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 08:48:31 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 71D27B97FC
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:48:31 +0000 (UTC)
X-FDA: 84047501622.01.95F0CA0
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 599C9180002
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:48:29 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=XjJiurAH;
	spf=pass (imf06.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.47 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761655709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Olopx85j++3FTIQ4p47k6xJ/f5lMguJl5tBEftSDYws=;
	b=Iub7r3Ua7CBCFTzrCmLr8EF7muM1+MnwvIFM46sK5pJ9TATV82nP/KuSXplMz/+YNTHxBC
	6qGfhXZ4rHTAb8z7nmoiY6NtyanCvA2T8KSTug6DoISsD64k8nJvVp3xl+FENdy8dljhTw
	SYLYa3l0tuw0r7kJY7BEg8LskLXi5zY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=XjJiurAH;
	spf=pass (imf06.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.47 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761655709; a=rsa-sha256;
	cv=none;
	b=FW6lxPtqRM8fmqdCGBBGPDHfEExdTVQhhwC+yJCvTnPENH5uJ8gnt6qwDV9HeqcFWcYGUY
	CyJCue+3kLxmlL9A9kCgtYdS0qcPzaaeOUdxHKJGWxwHAO0x3XUSRlGRxaO/uhgaFm7bLq
	NtWQd6RtKOUyo9n483XG+rN8xgUGUXs=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-87d8fa51993so69232986d6.1
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761655708; x=1762260508; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Olopx85j++3FTIQ4p47k6xJ/f5lMguJl5tBEftSDYws=;
        b=XjJiurAH8MGsEiOFvZCfV0bdkwCjun4TAQ9S/yUheZ9iaUKTI8y0GwxF7S19+vPDeA
         GhYwMsndcGod2l5IC8KhOP3bdJHRQwCJSv/+MPwNCneTLileaQmCrpkD0vVqFsd25azZ
         vgK6ZlgIYz4mnBmhhw2m7vJ/hSWfJ0rQsOyornJfb6/Xk4OGMxbAVmAqqkPq9hwyx8fB
         EcuW/5sG1VUXlDSYnH3bsUdPl39mM7z1N4cxWvxRjKuUjx3SK8kXFhU138Ywel4LFSFU
         xlfEBkJtVaG0AY3VvUkKSdCe9a54hsJGDxD5TMqmbYRj3UYraetztqI+Ao8s2n8AKbsR
         91XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761655708; x=1762260508;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Olopx85j++3FTIQ4p47k6xJ/f5lMguJl5tBEftSDYws=;
        b=EVJL/dFU9j9vQRLysXB0m5z1gZUzu1iw33KvHH2EW4ddGtbwRFlyYOHnh5jq2iz4BB
         OhgyXqOfWZ2tiibSzXHbY4ySImwJUfFSJRJnEVT1kql9k0exPwfVP5ytKY1zCBCeQEXr
         CA8bGxnfamVdHutdZUiJI3zCI+HhVmIB79kJGDpOitKqBK12THSmZFuozKA0T1L6TRiP
         I9J1y1esNmOh6KStAiFlp0d7VG/2Xxq4h5jt8IA4mW4fdlKV2YsPw+ZltRL72KcQNU/5
         yOsQzhV9G7YzO4LeQaH6jSevq8/Fln5XubTgvp96XtD2dIVhLt8zcSl3vhexKpJAsrDG
         Y/jQ==
X-Forwarded-Encrypted: i=1; AJvYcCWFju1R4rZf8af7JrbhTOG456DofCwLLkKQOWK/0j02h8f0jMUsxeWqyYWlIV9CnXqfkC530xhDyQ==@kvack.org
X-Gm-Message-State: AOJu0YzoJpn/pkh2Z8PyDnCcxMn5Xo27gLTiPfNvjHsvfjxULutmc1NG
	XYR7sS0pTs0KfIhFbM3mRNhLA+pyTim/mXV8bbRGHQ4L+DvD3fD2y3MTRDK2zYkGzrY=
X-Gm-Gg: ASbGncsOEDv+hqy44EbsDeCIw02OdbS+CXuuzBJ5ZY0dwpLCN6Hmbb2Ny8Avya6kail
	FwZeGp1FLFeUJV4qDUewl69sbGbPWK08WDkT9K8GwkXywZU/K0CX6gyj6QIrErxrkMBYSNadQ6v
	UCgrA/pAggjeAnz5QYIh+nXw2VE27q9hg/enqfkvngpmfueo2RT3GIUcQ327Do7YpFMuw6GE9yA
	YdHhA8MVrnLXIpMVE+8tm3ivFEwP21HkfMfZepHxoMCx2QwhayRb3SJdRJPDIW3BDh76nyKIN6p
	XLGTalHfZ15ucJUqaAUQjiwFrwL9VCAbHfj1heorQmh+ZP+1eZuNtJWCXNJW10HYXv7D1bn2MN7
	h+5DfMNejnTr7L/LGcI23XXhGD4HwNa40DLwK8honJ42Ev/i5eT1EZ8t1eApEX0cP1wKsVeBFZd
	VOJNs7aYYRdYEafPdEMa17PKtmX7/rcK/+PtlasOfblkTvAA==
X-Google-Smtp-Source: AGHT+IHiUNJHwvr/nLoj/e7qPf6JckrC19yXD6gHtAA14Gx8htpJ7qO77Enxzi9C2v+UJSUvbdZfVQ==
X-Received: by 2002:ad4:5c65:0:b0:87c:1889:6a7f with SMTP id 6a1803df08f44-87ffb000afdmr37515826d6.5.1761655708162;
        Tue, 28 Oct 2025 05:48:28 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87fc48e08d3sm76769836d6.19.2025.10.28.05.48.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 05:48:23 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vDj7a-00000004Oq0-01nS;
	Tue, 28 Oct 2025 09:48:18 -0300
Date: Tue, 28 Oct 2025 09:48:17 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
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
	Sven Schnelle <svens@linux.ibm.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>,
	Peter Xu <peterx@redhat.com>, Matthew Wilcox <willy@infradead.org>,
	Leon Romanovsky <leon@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 00/12] remove is_swap_[pte, pmd]() + non-swap
 confusion
Message-ID: <20251028124817.GH760669@ziepe.ca>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <20251027160923.GF760669@ziepe.ca>
 <8d4da271-472b-4a32-9e51-3ff4d8c2e232@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8d4da271-472b-4a32-9e51-3ff4d8c2e232@lucifer.local>
X-Stat-Signature: agar1p63k7jhrskixz9hzo6yzxkeeyqq
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 599C9180002
X-HE-Tag: 1761655709-396346
X-HE-Meta: U2FsdGVkX19hb2SbYINjgzQvYAzN/NTaUU9lYRdNz6rdlkksKv82/1v5Xjv/TW92dLpUBM90mB9q5sFBQ0JFIkbPrgLZpb9CPu/fwVTFXj0i5pitj8U5XI3kvYudD+B/3ChO1I7NLk2UyuwHWCUjqgQAyU1lH5kTtF931RGuyj4BJpRmA7NdERAo9eQMIgyMKPiD/Kve8NunNzsetqAMCY/zaiAlOn7nuraIFbdjLSSRm1H6yk5wAwBTCGSg1DoqzzXOXM8jUBwyT8dIsEwstoHLVWDGvpG+qxO8Cm9LNI5hh8p0ajHCCHj9v62imX6kmbApfJPppnSPx+mD1HU6SG1tNmTRCCZqQ6FsFxyYQmTsEv3ULUmdgEa1XPlS1w+ckTkdQBEVnf7FpXzg/LPys06NcHP3c94fLJtSAMMQ/gPGrHERjby2e/LKp14WyoP2iDcwnxGHLKdBzGFuqk6MNs9iMqCsVWtRGfr4XZjHvZRy41kDHRQxjjNzcN2KQ+T7BFpHCWWEa1ClE0dI2RQaEPtIvEky6I+MxPb1DPTa4L7Lyq6IibPsWx1AWXo61YoHvAuzgYhf6tjEOllZdy6Qtacr+KwSWixwGAcfcF91+r14WReQO15nVBTWMtHYl+0+nGrnZ0DvdhF41RVGeqcjVlgwRqQgKH++bNnD/h9jnr1lr3FdYk7siQ1LqzgYflg6RPKApwwQ0RP0HRrB7u9Q3N1D5aLiBstB7FW78oTq9a6fp/xGDMnv7qFBXv+W7erAMIvn98lUpQL2rq1jH2pt7lTuYophHembyyANSddJVeKgFarz/eZvnpUPAeeF0rfGOkNLkT2Z/ytQpq3YA/cYW83p7W27z9GAqq2lmM8hxfbYbmoL4fhbD6YQD2YE4rFVZtMjyER8dYGwtv5T7Hgr4WCELpKb5XjuEMUGBQr0Yv4Q2ZL6lHHijJOHQQUDtISDv2qzfBSb3iDf6kvXM95
 ImiZ7q5A
 87gOtid9dmdJnkP8LxPNFKAIlcLO9u3HT4g0MnQiKH48eDpp/8xXFmhIenFUn3UpHKz80V53ZsFM4arp2QAXpOyKivMpionC+UgHrys4gofIkIU3l/cNAO9OouKhsH1niGJD7MvleNQEBoKSC6zC/vsnUkCuULwDP9w216HFtUAkTEQUic73BTIlhqY5w5y7MAqNyN4g/UAJ48Q0XMBqRdNyN89t5IjbPdtY6wD3hlmZiyBNQJMySNDlWDXtLmc4y+JSUt0Yfh0fQvR4OpdBA1VdKwj8L9n6P27B7QNS1O/LgaLrdnvxpGn9IA4gmgF4+9Mn2K4omOxDIe0KEw33s0PsJQAaZ7SK6kZKAW22z46E1zvY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 05:33:57PM +0000, Lorenzo Stoakes wrote:
> (Note I never intended this to be an RFC, it was only because of
> series-likely-to-be-dropped causing nasty conflicts this isn't an 'out
> there' series rather a practical submission).
> 
> To preface, as I said elsewhere, I intend to do more on this, renaming
> swp_entry_t to probably leaf_entry_t (thanks Gregory!)
> 
> The issue is no matter how I do this people will theorise different
> approaches, I'm trying to practically find a way forward that works
> iteratively.

It is why I suggested that swp_entry_t is the name we have (for this
series at least) and lean into it as the proper name for the abstract
idea of a multi-type'd value. Having a following series to rename
"swp_entry_t" to some "leaf entry" will resolve the poor naming.

But for now, "swp_entry_t" does not mean *swap* entry, it means "leaf
entry with a really bad type name".

And swpent_* is the namespace prefix for things dealing with
swp_entry_t.

If done consistently then the switch to leaf entry naming is just a
simple mass rename of swpent/leafent.

> > That suggests functions like this:
> >
> > swpent_is_swap()
> > swpent_is_migration()
> > ..
> 
> The _whole point_ of this series is to separate out the idea that you're
> dealing with swap entries so I don't like swpent as a name obviously.

As you say we can't fix everything at once, but if you do the above
and then rename the end state would be

leafent_is_swap()
leafent_is_migration()
 ..

And that seems like a good end state.

So pick the small steps, either lean into swpent in this series as the
place holder for leafent in the next..

Or this seems like a good idea too:

> We could also just pre-empt and prefix functions with leafent_is_swap() if
> you prefer.
> 
> We could even do:
> 
> /* TODO: Rename swap_entry_t to leaf_entry_t */
> typedef swap_entry_t leaf_entry_t;
>
> And use the new type right away.

Then the followup series is cleaning away swap_entry_t as a name.

> > /* True if the pte is a swpent_is_swap() */
> > static inline bool swpent_get_swap_pte(pte_t pte, swp_entry_t *entryp)
> > {
> >    if (pte_present(pte))
> >         return false;
> >    *swpent = pte_to_swp_entry(pte);
> >    return swpent_is_swap(*swpent);
> > }
> 
> I already implement in the series a pte_to_swp_entry_or_zero() function

I saw, but I don't think it is a great name.. It doesn't really give
"zero" it gives a swp_entry_t that doesn't pass any of the
swpent_is_XX() functions. ie a none type.

> that goes one further - checks pte_present() for you, if pte_none() you
> just get an empty swap entry, so this can be:

And I was hoping to see a path to get rid of the pte_none() stuff, or
at least on most arches. It is pretty pointless to check for pte_none
if the arch has a none-pte that already is 0..

So pte_none can be more like:
   swpent_is_none(pte_to_swp_entry(pte))

Where pte_to_swp_entry is just some bit maths with no conditionals.

> > I also think it will be more readable to keep all these things under a
> > swpent namespace instead of using unstructured english names.
> 
> Nope. Again, the whole point of the series is to avoid referencing
> swap. swpent_xxx() is just eliminating the purpose of the series right?
> 
> Yes it sucks that the type name is what it is, but this is an iterative
> process.

Sure, but don't add a bunch of new names with *no namespace*. As above
either accept swpent is a placeholder for leafent in the next series,
or do this:

> But as above, we could pre-empt future changes and prefix with a
> leafent_*() prefix if that works for you?

Which seems like a good idea to me.

> > I'd expect a safe function should be more like
> >
> >    *swpent = pte_to_swp_entry_safe(pte);
> >    return swpent_is_swap(*swpent);
> >
> > Where "safe" means that if the PTE is None or Present then
> > swpent_is_XX() == false. Ie it returns a 0 swpent and 0 swpent is
> > always nothing.
> 
> Not sure it's really 'safe', the name is unfortunate, but you could read
> this as 'always get a valid swap entry to operate on'...

My suggestion was the leaf entry has a type {none, swap, migration, etc}

And this _safe version returns the none type'd leaf entry for a
present pte.

We move toward eliminating the idea of pte_none by saying a
non-present pte is always a leaf_entry and what we call a "none pte"
is a "none leaf entry"

> leaf_entry_t leafent_from_pte()...?

Probably this one?
> > static inline bool get_pte_swap_entry(pte_t pte, swp_entry_t *entryp)
> > {
> >    return swpent_is_swap(*swpent = pte_to_swp_entry_safe(pte));
> > }
> 
> I absolutely hate that embedded assignment, but this is equivalent to what
> I suggested above, so agreed this is a good suggestion broadly.
> 
> >
> > Maybe it doesn't even need an inline at that point?
> 
> Don't understand what you mean by that. It's in a header file?

I mean just write it like this in the callers:

  swp_entry_t leafent = pte_to_swp_entry_safe(pte);

  if (swpent_is_swap(leafent)) {
  }

It is basically the same # lines as the helper version.

> > > * is_huge_pmd() - Determines if a PMD contains either a present transparent
> > >   huge page entry or a huge non-present entry. This again simplifies a lot
> > >   of logic that simply open-coded this.
> >
> > is_huge_or_swpent_pmd() would be nicer, IMHO. I think it is surprising
> > when any of these APIs accept swap entries without being explicit
> 
> Again, I'm not going to reference swap in a series intended to eliminate
> this, it defeats the purpose.
> 
> And the non-present (or whatever you want to call it) entry _is_ huge. So
> it's just adding more confusion that way IMO.

Then this:

  pmd_is_present_or_leafent(pmd)

Jason

