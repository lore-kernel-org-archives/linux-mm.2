Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B8ECCCF9E9
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 14:10:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCD148E006E; Wed, 29 Oct 2025 10:10:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA5538E0045; Wed, 29 Oct 2025 10:10:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBAE78E006E; Wed, 29 Oct 2025 10:10:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AAE0D8E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:10:53 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5BC9C1A06E7
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:10:53 +0000 (UTC)
X-FDA: 84051337986.02.7434E52
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf20.hostedemail.com (Postfix) with ESMTP id 893E71C000C
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:10:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=UlNelilx;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.46 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761747051; a=rsa-sha256;
	cv=none;
	b=m95oFzDdoA8obx9TyHitu3NohHRuwBGYPMkNRZSl+fOuuT8TXD/kOGIWXUpukeS3twSO5/
	8t20lUdC7BBnTxwLbSyRV3ZR+9j6sE3va8u2uzkfr5tXhLIkevE1Y8qwBmIjSUfQZ1kOiy
	/VJ2pBfoMkLU4DMXyVZXB6Mm/KyMO6Q=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=UlNelilx;
	dmarc=none;
	spf=pass (imf20.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.46 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761747051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3gCBuq56/59adr8Ol0O4W3+IsGMOD3y6s+9TcTsiPOY=;
	b=BvnEqYZ8vjD/GqKeYd5bjE++4JhNw1a58VV6LjgxuN5XOrGk06VBdU4Ne5apDHIaiGzgh+
	uHH1l1Ad6Ro0aM4yrcpporvDnpp7ir48PfNjDNRBAVy2wl6uX7t0LrRAPWWOoncuCam8zn
	rPAbGP1JqfRyWW26gJm6kBYW0yLNKSM=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-87c1f61ba98so105479046d6.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 07:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761747050; x=1762351850; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3gCBuq56/59adr8Ol0O4W3+IsGMOD3y6s+9TcTsiPOY=;
        b=UlNelilxiIvAYq61gr5zwrBnLt6U7Q6p+K414xEm4kZKOPgIuauFT2mgTUzol++JAU
         zumCdata8umm1rX7neFZJ6kRAx8KgryaOBszPSXl4W+jrS8JvxB3JquRTeEnw5sApyZ0
         uGg1EA9T6yTCUiy7fXT/EYKxOGSjUv6kUzTxPPovSSIW14i3H6zu6lxXMRg99tjpiXLW
         tbDpDgI6YtbkBq7n8u/M2BUcFuXlG3RlrA+QJhnWE+rh0bkfAGQKPTXzJifX6oxzkwWk
         esmtIBHgoSnKLkyZ4NfCn89/JDoFngI9OK1Gz6oGGaOBWyG5Dh+AlR0pkMk/P0HI8nbc
         YUBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761747050; x=1762351850;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3gCBuq56/59adr8Ol0O4W3+IsGMOD3y6s+9TcTsiPOY=;
        b=VwGCz/WKnYooZub2NUSZGXwabKHSQIHL5l6EFnK9rwsVXGnaSzv/nIdRNkH12UhaMM
         JirNKap9itf+yC70pnTswTzemqWKc67Iv2Sc3E5eYJ87NeBMAntvXpnN4r6NiHkEmyGq
         FFnlKlQprl4GVCR/EWXd5Nt0/TyD3rlkbfUK+Mwb4reW6XBpJBYmU5kMKANfQs0zPP48
         Nc+iTHQg/ykGgJItV2nF5/ALjhOAU5GTm5xdgYUcvvm/ERXaGM1PICLxZv7BiOfM6kLC
         VSn3B2X1ksZyshfa5WyrSq4aTksHgqL2Vj6LC9F08PVXIAf2xl6oHKekTPcSbprW7VoJ
         ZxTg==
X-Forwarded-Encrypted: i=1; AJvYcCVbGXma3poKyuXO2nQKGOaFlqDiKuUiLkGA7WeHuNS0aHwr5A/AwOr9a2ZwOACYOZzC5R/rkzYkAQ==@kvack.org
X-Gm-Message-State: AOJu0Yw3wyrCLtGMC1tosEgMmFSyz5TEU8OL2U9rJIpGofV3wtYATjdh
	qCfm4wrF+hF9LVzw4hEOs+zaC/JbMIk4vn7hCnzg2pRhvGpG3g25cAkSEmbuLdmNn0s=
X-Gm-Gg: ASbGncviy7M0Qleqkt14npI/TpWHs8kyo3CvZSlEzHMRziUw02LJTlNBTo/V+NfUqV2
	z5J7PuoVTwkWT+6W4ngT0ndyQiEgLEr4+XBiHKk7neKVQKUcO7q1Avov8oHIp/CSmIMmisCgA3X
	zowpJJzWYoUZ47b6aoZnXrEhoRXOleFZl/DY9aIKtjbQFePoNRYP+ktNDne4NTPRRKznDetmJpE
	1ia2lsJTg+p76u9Wn5jucdf+rnWvTBhPWAcLyx/Qf3erc//5kMnE6d4/RChXqUVFttWhY89EBO7
	75Mq9uznEiRBpHnbdMtMwFvWN8TMOX6jfqsRWmP5ZHudyf5L4j22NB82Oyabk2xFJAA9R2sxgqo
	0OKQuhOIyJrfBS6olhC6nwsijC2tyACdDbNhubp+iH0Fw/qrlndLsdbSNE+E8qqELxhBR2265EM
	R/WMKeZwhKxDdg5bGbg79sLdSmiP8waFqWrWJ6fPomYAzFBxZUZaRAb1+2
X-Google-Smtp-Source: AGHT+IFN9EEFBAzfjpvQnmAHpqKEJbqdqdrZ9KL1PtSYGMem5wdE9qnodevFJl+GDHD76k8KE97qmg==
X-Received: by 2002:a05:6214:23cb:b0:70d:fa79:baf0 with SMTP id 6a1803df08f44-88009be5c01mr41077486d6.38.1761747050399;
        Wed, 29 Oct 2025 07:10:50 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87fc494ab16sm98679066d6.39.2025.10.29.07.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Oct 2025 07:10:49 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vE6sy-00000004etU-2Jns;
	Wed, 29 Oct 2025 11:10:48 -0300
Date: Wed, 29 Oct 2025 11:10:48 -0300
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
Message-ID: <20251029141048.GN760669@ziepe.ca>
References: <cover.1761288179.git.lorenzo.stoakes@oracle.com>
 <20251027160923.GF760669@ziepe.ca>
 <8d4da271-472b-4a32-9e51-3ff4d8c2e232@lucifer.local>
 <20251028124817.GH760669@ziepe.ca>
 <ce71f42f-e80d-4bae-9b8d-d09fe8bd1527@lucifer.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce71f42f-e80d-4bae-9b8d-d09fe8bd1527@lucifer.local>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 893E71C000C
X-Stat-Signature: trjj53koo9zw16wp8yb5oeza8gg3nhzc
X-HE-Tag: 1761747051-404865
X-HE-Meta: U2FsdGVkX19gAunOrTL6lgRefr1b2J8TIOHUr1UXSk9LXjg1SO55qJ9KMs1iuk1oyDVSzraLI8kS+WCYCPf1d/GXdFuC1/IbKC+Ux0ZORtCsF+j/kGRzf9WeO+EPRNIc6t2TUia6TC3Y+CTVI0mtwaN5lM8Lpo1xpozlfW61XjGx/ExZjAAPIPbCd2cHGXT4Zu0bUPacKticWAMcATxDNoVZD1keT2wJy1qMtMziyWz89QJOVmjy4eJlmo8QiNtjB63hmAnW7ITjwZwrFEhT4nd4bGrOi5LZH6N6/z14rzy/HuGtjBfo2KCt9Hg6XFYZWq0l9mPaYFyQU3XthN624nQ+x8kfg3bS3Y4mhLs5v2bGTY28OKosHLnkMJ7vo7lDQWFS61UEQKd8xInlF9aeVx+0cq4Xjf8cuZFN1yVEEnyVeg+yQwwh+Z9lI884tUx3Ilr5bfkFR2Ly5FjAoJJXk05db8gEkVzXzDAKHtEYFLc5CxvrTB3nQspDCbgTgSrHwvZDSH/V5gWmnTMALl3QtbMucZwHcI1VzJ4b2cG3nWsOhosTHodrNE5I3I5XKVEEkKjbenke2NdFgXBx+jy1EXkoJyEZW2lVsyelCHY/wWMgDokjYItv47rzdDXHsHJw0kVbbrpiVO3678Oqads6K6AXXmZYF5YekHrtXsSjk3YRLQJAf35o+ZQSt5g8len85OmuuHe2WBy5IRArFIZO3VGHfPhdm2BApEJydGDCEaNcJ8QCLdre4REWl6lNPaz4Lx2PDuSSUJ4YvZP9cnTSbcP4Gotw7+liA1fWH6Ay7QXhD5QaR2+GnbZN1UWqmxsbeb2bzPv4WlZWLDnzyJyqCv18uEbRAr76ft5FH9C/SgmK3/ST/jPlYY+JHIAPm5K+577WSxnq5S6xkmjW0PdOI7/fYVizNWEllWyQrJB1ZTcSs5RPcuAcTNyCyLm1TNP0M/0Gx6c6rcyQIEFfwUm
 7d/8eWw+
 z2L9IGz2Hq2uv435j6y1gcGXyItnwqfstz2PCJccN90ybXfP2baCpSLKhYAUt+ZTRfrLmUlcKwQlebU+FkWXYfTW6HgHv6resmOEFU8X6XAprPVw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 28, 2025 at 06:20:54PM +0000, Lorenzo Stoakes wrote:
> > > And use the new type right away.
> >
> > Then the followup series is cleaning away swap_entry_t as a name.
> 
> OK so you're good with the typedef? This would be quite nice actually as we
> could then use leaf_entry_t in all the core leafent_xxx() logic ahead of
> time and reduce confusion _there_ and effectively document that swp_entry_t
> is just badly named.

Yeah, I think so, a commit message explaining it is temporary and a
future series will mechanically rename it away and this is
preparation.

> I mean I'm not so sure that's all that useful, you often want to skip over
> things that are 'none' entries without doing this conversion.

Maybe go directly from a pte to the leaf entry type for this check?

#define __swp_type(x) ((x).val >> (64 - SWP_TYPE_BITS))

That's basically free on most arches..

> We could use the concept of 'none is an empty leaf_entry_t' more thoroughly
> internally in functions though.
> 
> I will see what I can do.

Sure, maybe something works out

Though if we want to keep them seperate then maybe pte_is_leafent() is
the right name for pte_none(). Reads so much better like this:

if (pte_is_leafent(pte)) {
    leafent_t leaf = leafent_from_pte(pte)

     if (leafent_is_swap(leaf)) {..}
}

> > Then this:
> >
> >   pmd_is_present_or_leafent(pmd)
> 
> A PMD can be present and contain an entry pointing at a PTE table so I'm
> not sure that helps... naming is hard :)

pmd_is_leaf_or_leafent()

In the PTE API we are calling present entries that are address, not
tables, leafs.

Jason

