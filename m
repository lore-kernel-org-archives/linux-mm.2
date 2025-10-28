Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5B73CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 12:53:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CD768013D; Tue, 28 Oct 2025 08:53:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A4B18E0016; Tue, 28 Oct 2025 08:53:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1BA898013D; Tue, 28 Oct 2025 08:53:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 081FA8E0016
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 08:53:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A4AEB1A037C
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:53:02 +0000 (UTC)
X-FDA: 84047513004.11.974E5BD
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf09.hostedemail.com (Postfix) with ESMTP id B9B64140007
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 12:53:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="PVIl2/Yq";
	spf=pass (imf09.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.48 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761655980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7CqgmoumiIO/LqZvmbvABjwYG8sY5r9jILlhcKrm4Ms=;
	b=phr+ZfFMCsYlHwz0IQBt+5Enj1SNTESgw16DPXitQYrlqXJV+YG2CmDDyA03B/PiRnBr57
	FizySTLtfcvAD+6ymj0fiIR4fBZzkAX9bDlDZEvaTT0xjuahSn9ME8UpVuaTRFcAk/nWQr
	IvKqdqGNlLBky8OPuFhvMyJM4VuWvaM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761655980; a=rsa-sha256;
	cv=none;
	b=QaMTD1ymfRpfTzuYPmHu9hs3tba6mefuvhCROSXsyJmkaNimWw1O3kfsHUNwXyhptJlCSN
	Rb/CdY22TazqBZ4K2SDA9rNM0ZCZ9MHSFKNFPxsmXRipr2OB9ixPRmRco6RQyM/K9/MoDw
	gjMpP2B4tPFxUeMnzX9wwVixQfXXOeM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b="PVIl2/Yq";
	spf=pass (imf09.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.48 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-795be3a3644so32444336d6.0
        for <linux-mm@kvack.org>; Tue, 28 Oct 2025 05:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761655980; x=1762260780; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7CqgmoumiIO/LqZvmbvABjwYG8sY5r9jILlhcKrm4Ms=;
        b=PVIl2/YqDtAoqtwSQvGsY9yoe0r0S6e2jgGSzoDrrXHjH7I16IZhlL/r+6TFMIQ8ep
         yBXycyQTK8SKfYok0CptyXL5688NNfFj/sbiHbU0SqvGJNPK76QT7h7NNTpW1lae0wKh
         D6F1kyroprEpJ7GuATUwvyWDVXVuUJqJzXCzJB59aFq3RMnTjVuKq/ZTcekqdlDS0U8q
         h6NmztrFWa2Z3ucP+lgYWBeIi0osxaJXtbwbVLHm3aP3CQU5eTITE9Drs9p4gHsbE4JC
         /jLh/bxr65mAfe9e+ocGWvBhDWRh0HkzYzBu3+Jhm3AiwyvbjJEjZXR9Ou9LgPSJ0K7N
         nArw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761655980; x=1762260780;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7CqgmoumiIO/LqZvmbvABjwYG8sY5r9jILlhcKrm4Ms=;
        b=eXwZz3uOFrTdWkonOdRSenhS4Jzs3ysQh0ffhIoG02FlJg41Jzy9CKzEHZqSlz4AZ8
         wZ6uFfYeFm0mEWg0yIpumj37Pe1YTcJ/pZG0xlTp359LyN183jKIBlv6SluSl+4/5jBh
         J5ZdZ8NJV1rA03hmFJcDN5xQ72QDLDnlASeGEAqxlHXyEIS1CJ9W5o2kSpMV6uaYttv8
         6WWlAPqMIN9NsBHv7kOk6n6Yp6Xr8onRqqsPqCqUi+BT8Ys1EvNjh+ACVqsFUvyzr8nS
         4XCHGmVKAo+CJjDtmk2yOzxFK4ZK2ERM65rdrylgLhMjGjyz+12BFj9kkRFOTujB8m9t
         VLTw==
X-Forwarded-Encrypted: i=1; AJvYcCXmCakPyhNizxIePuzXwzh2/XVmghc7gVhADXPic8Uf1YTczmyaABEA8fPJZ90lZm9jLEQBVx1edQ==@kvack.org
X-Gm-Message-State: AOJu0YwVej0HKP7KRvy9Ov6uXniZN8Y0Pm3fpzmv4XID7QVPTlM3A4cY
	OaPi4/plFBVxhB6pDHRU9KGPOoQ1w/OR9FQqQfDpTtxnsBqc6aLUq2rcRFFt56vSqko=
X-Gm-Gg: ASbGncvjB3XLpC4fUQwvpO/sXYJGbPcbgKDDH3vr5ws2Zla9/jcTZmqrGIbQSRBW4Qp
	h/+54+NhlUy0Df08etN2luZfjsid8OyT/M5SEeAfMuNKKGFi9NPGNh+P6WpL0cywANZFxo2Ez9a
	gBPiBHASlGXAMR9QW40PpsV8V05R9zhAsxeYooRO4A6eYJT3hM4rAbqbEGg6Wa62lUe0qGNenZw
	EA2bnlx8d3lQlOuZDw32R6d21T+ji7KBd2WouBg2tVU7U2i4dWEKLTCqFViR/Z21TXmoDVnqbL5
	RHdnuvdqTVb5Gp66ciI3RVsFTbn5qgxnTTjjYKcWGHhNdztb+lG/yAH9HzWlQSLgfYIyzzIfSrE
	Io7SrspMwkfYMY8fALWKqxNEB6EGmGwKy2NjxRz/m5ulDs1yGmGQ2vERsgCEThvJ+m07J28cDag
	qdDk8ELnGsWysJSt+Wp6lHJKGQy4ObZdbfj2U4NC109xMLTQ==
X-Google-Smtp-Source: AGHT+IH+xZpvPIbhKx7mJgf5LQY0C/zJpDpvmdyPQ1VJnfhZtNoMsQ1XOGKSORZ38fLIo5wpD093Tw==
X-Received: by 2002:a05:6214:262d:b0:809:5095:4153 with SMTP id 6a1803df08f44-87ffb10cd22mr39426046d6.31.1761655979645;
        Tue, 28 Oct 2025 05:52:59 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87fc48abea7sm79249956d6.0.2025.10.28.05.52.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Oct 2025 05:52:55 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vDjBs-00000004Orq-30qI;
	Tue, 28 Oct 2025 09:52:44 -0300
Date: Tue, 28 Oct 2025 09:52:44 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>, Gregory Price <gourry@gourry.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Janosch Frank <frankja@linux.ibm.com>,
	Claudio Imbrenda <imbrenda@linux.ibm.com>,
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
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Rik van Riel <riel@surriel.com>, Harry Yoo <harry.yoo@oracle.com>,
	kvm@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 05/12] fs/proc/task_mmu: refactor pagemap_pmd_range()
Message-ID: <20251028125244.GI760669@ziepe.ca>
References: <2ce1da8c64bf2f831938d711b047b2eba0fa9f32.1761288179.git.lorenzo.stoakes@oracle.com>
 <aPu4LWGdGSQR_xY0@gourry-fedora-PF4VCD3F>
 <76348b1f-2626-4010-8269-edd74a936982@lucifer.local>
 <aPvPiI4BxTIzasq1@gourry-fedora-PF4VCD3F>
 <3f3e5582-d707-41d0-99a7-4e9c25f1224d@lucifer.local>
 <aPvjfo1hVlb_WBcz@gourry-fedora-PF4VCD3F>
 <20251027161146.GG760669@ziepe.ca>
 <27a5ea4e-155c-40d1-87d7-e27e98b4871d@lucifer.local>
 <dac763e0-3912-439d-a9c3-6e54bf3329c6@redhat.com>
 <a813aa51-cc5c-4375-9146-31699b4be4ca@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a813aa51-cc5c-4375-9146-31699b4be4ca@lucifer.local>
X-Rspamd-Server: rspam05
X-Stat-Signature: 1xdkexciqtmatiq5rm3t578a8b1xmfuk
X-Rspam-User: 
X-Rspamd-Queue-Id: B9B64140007
X-HE-Tag: 1761655980-918043
X-HE-Meta: U2FsdGVkX19IvIwYW9vdhMoBhG5wKuI4ze0HY3X5QDTSLKjhFcT5gp0SuBVrAaub+alDmf2F3yEPIxUMu6SVYiirfd22VZ8xMngc1PGTFESUoFk/rJv1NwQ0SCv2JCo4mykT6g9a1GstIxS4w4VLUSUqiQ/XdDsV7aCzuoncv+lPI0Fym9AH71cI4cnOq11DgLrup1iepxxYQoh5/cxDxJ4P/QmwNZOCs+ApFjmElLic0sydV6+Z/txcjTPKnAvtGzfsBgI3/XAEJlmbFSmXr54R2hbNvw2ciyYUT5hQW7gHHN3kPDeGvdPogHdyrcb1kn588J7tOi7haKS2Y7mPBtS/ei7ty7ZHzz5+V3Y+BOS5da9wp8+mtccIecvdWbkCE21cbSxweiQZk/e7N8vFLHlpMOI4FoQHa+WE3wZQvWK/5+bGjlnz9m2/oB8kdhMvMUVt4llTHnWfCze4/7kLA1Wt0GhEJhVUN8CP5/QbFH9a5g/vi00SUNhAem1lmAX/KSn2Nm0HG2pdafXZBBO+L19nsmghMZLiAnikYQLcwkawsycZ4IPA4JlpT14Hg9nNImeiATkC71nAP1KzhwuduTLAasZY9hPpBelooWLjoSUcDyTyXrVhasSg5y95Uj32Tx1zGN9qqxUYSyObnDQHOeJNiPiPZD9cbJx7fyVHqI8LBx2XyDRi3FGDI7o8QOm/4Wd9weLxgB8n8t5AGBYBvoz09ojc10Oh3cQtY73MKx9g3QY8PzXjfpzI8FzeugKlbT1iRKYScAkiqRruF8MuGgo1yJARcY6TPRp+nLUdQI69irZ3HAovXci77NDYGqhwUATy7PvbWCOWn5JPz3LmARrLWRrdwX2/x/aJn0T+nPXBBqY2yKpAmjbHcwOnWKaXA486lli11EnSIZgYtBY6eaTeaSJFO1ooWmHoYlCYy6ItwEN4kKCR4MNMa0jUHTpqvU1bLDx46N1TmIPevDa
 Bby8AHuc
 4cCFIMZx5VVi4BuQg5FC5uH9igwZqN9qr0CgGoZjqGvoBvfGwnOSqmWZtMd5b+bk5TUDSGvF/ByXzTEcx6HJg6d2InKhCB3/rml0wnqEjKuqvRXUNCxzh8FfqRJ9pm31ZS2ZnvhqnfsC6/FN10iPLOC2vrb+qLsxRtiMN5h1JWx+8f4++dmRqbXNUQVEteYzhjrlzAuKlrYOr9WCGbiWqJ+xsoMOaAMVmKhVLmCZFS6JiGbl0l1Pc03jnHZ5B1bVB/pJeUELe8ubfL87ENIS9x70Kuu7lXsHQshgprRdBJGL6eGOwbkPWxfvPTLfM45U4scHsQoJuW/h5EF8R3V672VTapSyXCTqx0+Qay9/tEtNm9Mev1EcitNyK1Igg8YvcICz54ECJaDFGX5UBuXNtxDg8zQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 04:38:05PM +0000, Lorenzo Stoakes wrote:
> On Mon, Oct 27, 2025 at 05:31:54PM +0100, David Hildenbrand wrote:
> > >
> > > I don't love the union.
> > >
> > > How would we determine what type it is, we'd have to have some
> > > generic_leaf_entry_t type or something to contain the swap type field and then
> > > cast and... is it worth it?
> > >
> > > Intent of non-present was to refer to not-swap swapentry. It's already a
> > > convention that exists, e.g. is_pmd_non_present_folio_entry().
> >
> > Just noting that this was a recent addition (still not upstream) that
> > essentially says "there is a folio here, but it's not in an ordinary present
> > page table entry.
> >
> > So we could change that to something better.
> 
> Yeah but leaf_entry_t encapsulates BOTH swap and non-swap entries.
> 
> So that's nice.
> 
> What do you propose calling non-swap leaf entries? It starts spiralling down a
> bit there.

You don't even ask that question.

You have a leaf entry. It has a type.

What you are calling a "swap entry" is a "leaf entry of swap type".

The union helps encode in the type system what code is operating on
what type of the leaf entry.

It seems pretty simple.
 
> And it's really common to have logic asserting it's actually a swap entry
> vs. not etc.

leafent_is_swap(ent) - meaning is a "leaf entry of swap type".

> 1. we keep the non-present terminology as a better way of referring
>    to non-swap entries.

I vastly prefer you leap ahead and start using leaf_entry
terminology. We don't need a temporary name we are going to throw
away.

Jason

