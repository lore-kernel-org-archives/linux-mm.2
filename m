Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C85A2D3B7E2
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 10:40:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DC016B0005; Mon,  8 Dec 2025 05:40:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 265446B0007; Mon,  8 Dec 2025 05:40:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12D486B0008; Mon,  8 Dec 2025 05:40:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F1C8D6B0005
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 05:40:46 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 82E665C139
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:40:46 +0000 (UTC)
X-FDA: 84195960492.18.D29220C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9966D120015
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 10:40:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CSRWeO8E;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765190444; a=rsa-sha256;
	cv=none;
	b=K2B6vuFbj2S25E7yjkZ8W18+IbjdBH/Npt4vSsaVGp3F7gFuDvZ+TSgIWnWmubN8zJq2cM
	Ujy6VF81tQAFp8GyiJshPePUS3BkHzvLFkXvj+zy4ZclXOBFURMma95MjQLAUkLc34yP0j
	uSKOan5T91hUSzGmgpQ344gxO1UeR8w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765190444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qVY+xwwKiAjZsV3eYxHrP4g3DW7olMT+0jxNvEhpF0k=;
	b=o5Ry8UaQgZLpt9Js78t1PKTQywUlbAiAZYX3TBFaD6Ntkw1dAxWdzgWf+E1AVeHksQC7eh
	nMY2NqUuA3MN7jZ1EYjLs995nN2gGeYJNSp2/811gIk+AJqc9WxB7At0KU+oWPn+tkJR3K
	6+QAyLdyo1vRmprL1Z1HWGYAzrp7YvU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CSRWeO8E;
	spf=pass (imf29.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DDBFD60153;
	Mon,  8 Dec 2025 10:40:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BB5C4CEF1;
	Mon,  8 Dec 2025 10:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765190443;
	bh=P0dL+8t4dY1bkxzyrYA3i4X0+ns0NC17VdJogz7i/q8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CSRWeO8EHpyINoSzLDwsSHppv5GLyqElaJywgFb6NtCT+JUyBXFVScKqfxXgU4R+V
	 Wxl0smsRfezo30/PjT7+B2YYXmlqE14GAu62fPlNagRFfGim+S+fif3nIkltsRBRRb
	 TWW9oix8Lm9rqhC2TiFAaSZ/uIAjqNQ2w5Zy1e30vJU5D6icp5/B3CMGS05/fah6k6
	 P7G3pzOGdbWKmCsf9cgGI095WTcb0aKqGAoEUXuZvDJk0HAhd8Mw/QWJ521s5JHw4j
	 fikw18UO6E1Pnd6M18h5cfb3+MAeqQASAEm7w2HQzCKQxgV3o4AkvBA/YrjIWofpjE
	 oDsob2ZknOmAg==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.phl.internal (Postfix) with ESMTP id 26C4CF40070;
	Mon,  8 Dec 2025 05:40:42 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Mon, 08 Dec 2025 05:40:42 -0500
X-ME-Sender: <xms:Kqs2aXNuxA6CEgFzb0M9fwHP-BwLqfFrKmfd2uSeKWuhxHsH8MSYPg>
    <xme:Kqs2aYy-AvUP-yJDCeN-CALpHOG2C4LRDOkXCcA-7sTwGYmSYqRGTgrNeUiy9fHCx
    JhojKCbKQDMLpS6xK2YNP4KGANXUcHWRDKc727iFliw5MIHy6XfBCc>
X-ME-Received: <xmr:Kqs2afN_-rd0ywZWpifrpXKfVcFZl2nK8fS5Ndzlv-_pz2HZnDaArb1vFAi6WQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieegiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpeffhffvvefukfhfgggtuggjsehttdfstddttddvnecuhfhrohhmpefmihhrhihlucfu
    hhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrh
    hnpeehieekueevudehvedtvdffkefhueefhfevtdduheehkedthfdtheejveelueffgeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrih
    hllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedq
    vdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnh
    grmhgvpdhnsggprhgtphhtthhopeefiedpmhhouggvpehsmhhtphhouhhtpdhrtghpthht
    ohepuhhsrghmrggrrhhifheigedvsehgmhgrihhlrdgtohhmpdhrtghpthhtoheprghkph
    hmsehlihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehmuhgthhhu
    nhdrshhonhhgsehlihhnuhigrdguvghvpdhrtghpthhtohepuggrvhhiugeskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepohhsrghlvhgrughorhesshhushgvrdguvgdprhgtphht
    thhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepvhgsrggskhgrsehsuh
    hsvgdrtgiipdhrtghpthhtoheplhhorhgvnhiiohdrshhtohgrkhgvshesohhrrggtlhgv
    rdgtohhmpdhrtghpthhtohepfihilhhlhiesihhnfhhrrgguvggrugdrohhrgh
X-ME-Proxy: <xmx:Kqs2aeiXoiq-3V4nXgRYHdYPqDEf3lPKZB1NnrZ6ytIJCmud0nYYUw>
    <xmx:Kqs2aTuhRZUWHJZdM2o39ZCWbcHnxjGSUARZG-TukV_PoUeGbdltAQ>
    <xmx:Kqs2aWUQ00wgeLIjwfPOkzRLPEy0GWy34_GohHaFbpe9zOjmSOqD3A>
    <xmx:Kqs2abb1dBSV4pIbfLFMbd8Ea-QqHWc8EwC_jsfU0ZXKF9tZzN438g>
    <xmx:Kqs2aQtrv7WWG7wLoCnmHtdDFmkHdr6sbpx0a0PlHheVrxWyEmdsj2o2>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 8 Dec 2025 05:40:41 -0500 (EST)
Date: Mon, 8 Dec 2025 10:40:40 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 06/11] mm/hugetlb: Remove fake head pages
Message-ID: <s7uxtfbfta45d26g5e5iznkkbj7ccpsar7dppacqmbwms5bcdb@7cr4bo4jqnd2>
References: <20251205194351.1646318-1-kas@kernel.org>
 <20251205194351.1646318-7-kas@kernel.org>
 <db4538c3-84f8-4fb4-8307-b4fcf46ebe38@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <db4538c3-84f8-4fb4-8307-b4fcf46ebe38@gmail.com>
X-Rspamd-Queue-Id: 9966D120015
X-Stat-Signature: yxh8qhisurdgt9nc9sp43q48bwo8a9tn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765190444-855928
X-HE-Meta: U2FsdGVkX1+ud7QEU4U0tZtUaI8RbJ7qxLYQlQZcBu0lipHuMT9kVNDLtKg/YTeFT9w/jatas+VlKd5cGleGbX47KYbMN0DbK5q1ESW837pDW3NC+4wqAchWy4bPCJPy8OQeOt2FxPOgjgT6JjZ1o8LLebuSLeqJH1sPXm7M5k0/khrAPcX4l+4E5CmDUMaCe3rm87dvLHGb3V3hVzDfPd5tCiitWdAF7iBqRO5+0kGD+kUGRR8BUU80lQUkgZpQnIn4iB7QeD6qBBCwPV3rZicZ3RZFtfBguriZOt7P8N2Cvncl4kpYZOHJfd4cYfqQ8C9UF6LVfk13qOIeNii8AY8AewfcB/QVXWwVINptOFBnSC9plY55yEteinEAL1RbydWmG8jYa6Fgz1+mhs8IkWOmcGBOpSCJT6AZrMTjS4ikk3ZeuVM/NITStU86Y70pPt0Xn5omI60/qSPe26PdkfLXUsNJL8qAp62Rt29FT9Cz63BVEGjyba8UgdFs+7pI60TToPSetMP6rrtZDhHWxFHL7Uf15mxvPIWWbl4q+03/7rpoTT9G+eBqUc/LhHTTrSerthJbN1VhseupwOhFTyCp1wJjDdGx9HrT91IaQaaA5E3wj71K86N9fFBS6m/vqWsCQZCW4bj8ZabHP9XBnHNzWk/420QiQ3hltQB4+SVkRM8gPIrjTYYGBsHSSGxsAOyhvuKKwVjvw4Kxg/SR8r79R+ClwyKcpWr/ijj7JgJUJvS/DFFlF6rzIenm3wFv34pF1gj11R+8mEI3ialreRQQxdzqDzSNwdl3/NV3kpNSU43Lce7theoEAxFWVSqK5cuvwt1Z/bOB95jKV/yX7ScuQ1E/a1KHBc8/KEoezjMWyNt8D8KxoEngOMjEBy/BYY6eRQcC0DgxZ9Th+nes7m1LirmpXuTpI0BPndQmtMPc1f1icKbFxVfqIouilVV7aq2tB8bM3895dnjfRrH
 AW0BnUQ/
 p2XgvELBCb+/4UBrAzyaCM2nxsy6iNsw24YNehkgTncBD5QhJaSXieXoGiCsymgMChjbmBMlsHFe+nVIKBCf45FDptKKtLOlg5ZKt9l7WL9zrpFMBiZOzM8lfGM2UEvYUgP3Vj1XQCi8qMUdJSp2nxEXNQp79/U0880mNAy3Oza7DdgP25dsg1/a7KBeDiJu+ygzMv8eFChrHvlrPwCc9jSzYYCFKJHulywLykZY+l7fcmBj6knxxSQWYI9d1w6KctjF0xINQ7mHvHRFtPF2M10Rxlw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Dec 06, 2025 at 05:03:25PM +0000, Usama Arif wrote:
> > @@ -518,7 +519,24 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
> >  	return true;
> >  }
> >  
> > -static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
> > +static void hugetlb_vmemmap_tail_alloc(struct hstate *h)
> > +{
> > +	struct page *p;
> > +
> > +	if (h->vmemmap_tail)
> > +		return;
> > +
> 
> The above check is unnecessary as we already check for
> !h->vmemmap_tail in __hugetlb_vmemmap_optimize_folio?

Right. I will streamline this codepath.

> Is it possible that we could have a race here? Where 2 threads both
> trying to allocate a hugetlb page when none exist in the system, both
> see h->vmemmap_tail == NULL, both call alloc_page and set
> h->vmemmap_tail?

Good catch. Will fix. I guess, serializing h-vmemmap_tail with
hugetlb_lock should be good enough.

> Also, is there a good point where we can see that the number of
> hstate->nr_huge_pages has gone down to 0 and free
> h->vmemmap_tail? Its a single page per hstate so not a big deal, but
> would be nice to have cleanup for it?

I didn't want to go to this complexity, but if you folks think that it
is needed, sure, can do.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

