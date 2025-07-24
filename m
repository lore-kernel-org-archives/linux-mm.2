Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6462C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 06:47:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B15D6B013A; Thu, 24 Jul 2025 02:47:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2891B6B013B; Thu, 24 Jul 2025 02:47:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5C26B013D; Thu, 24 Jul 2025 02:47:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 07AA66B013A
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 02:47:41 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4C351112039
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:47:40 +0000 (UTC)
X-FDA: 83698227480.20.8B166E6
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf23.hostedemail.com (Postfix) with ESMTP id A2740140002
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:47:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EiyeNwW9;
	spf=pass (imf23.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753339658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fn3knKVKVCpcK50XNHsC0pks1LFNjjEZLC3nrBSUFXI=;
	b=mT6zYwfVxPFhbG6j4TIWPoYXf4zw9OlmWxcCpGpaysoWfUZpXQOohuuTWhbbbzuz38lJF0
	MX/FdiwgtkM9HXglo/XR9kWef7n7OBwDd+dJDBIknMRbGa9cH8a/YTkSLdV+OiBBX+PYRV
	wCHl5WSmsP5L0bwt97kCnb/ky+FzRwI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753339658; a=rsa-sha256;
	cv=none;
	b=3fWbcjUkKofKmEgDHz3HAW0vJTMPqu75HBj+Vc4rjXHw98bjrxOZK0m/qWSbOHJc2wsTmX
	TGsBbUrKtNmKrfVsUJqhwyqEol/kPcco4RNBC2GejxzOv+yHI2MHliJysv4mKf9PBsLR/Z
	950IeJgmJbK0K1zKshfqWKPbrGaQaI8=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EiyeNwW9;
	spf=pass (imf23.hostedemail.com: domain of leon@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 895165C5945;
	Thu, 24 Jul 2025 06:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C39FC4CEF1;
	Thu, 24 Jul 2025 06:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753339657;
	bh=csTsbkp93NJRtM4YbopZiMpO/7B2FNB1bYVQvq4Gu8o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EiyeNwW9FSXVQdf4EQIVZt5/CPNXF5UMFZvCWr4eXLRAEYT/QVUbSIL6Yn8BxFDfB
	 APMYAPa9KV5RKE4rOUMR60FhZQuZWKMNRfHF2LsW4nfglewY4O4/bnyU4XcQR/DYMU
	 FP2UNyPz58ah+A2siP1KKh6qJPrUYZovswwCSXMTz9OeGGDIfF7tnkEzR6AqnL48l2
	 kJNL5ORY4Bg7SuXvcsYsC1+kER29kfT4O0lsyCRc73L58wNWEq0w9J0GdxIfZQLdnb
	 GidBmwLI0QEl4x+mR2E29CADPKupMoF/T2EOd5XcGXlCZcdv+ISbHe9lDlrLUkdbzA
	 S52eZLseracTQ==
Date: Thu, 24 Jul 2025 09:47:32 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Matthew Brost <matthew.brost@intel.com>,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>
Cc: Francois Dugast <francois.dugast@intel.com>, airlied@gmail.com,
	akpm@linux-foundation.org, apopple@nvidia.com, baohua@kernel.org,
	baolin.wang@linux.alibaba.com, dakr@kernel.org, david@redhat.com,
	donettom@linux.ibm.com, jane.chu@oracle.com, jglisse@redhat.com,
	kherbst@redhat.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lyude@redhat.com, peterx@redhat.com,
	ryan.roberts@arm.com, shuah@kernel.org, simona@ffwll.ch,
	wangkefeng.wang@huawei.com, willy@infradead.org, ziy@nvidia.com,
	Balbir Singh <balbirs@nvidia.com>, jgg@nvidia.com
Subject: Re: [PATCH] mm/hmm: Do not fault in device private pages owned by
 the caller
Message-ID: <20250724064732.GQ402218@unreal>
References: <9ae3e014-c7d0-4d58-af0e-925bcd9e4cfd@nvidia.com>
 <20250722193445.1588348-1-francois.dugast@intel.com>
 <023ab16d-f3af-487e-a7ce-929bf7b2fe3e@nvidia.com>
 <aIG+gqY2YRqBeKlh@lstrano-desk.jf.intel.com>
 <dad71615-0eba-4a8d-abfc-979fb815511c@redhat.com>
 <aIHLWnjzKWma1NLC@lstrano-desk.jf.intel.com>
 <368fa1c1-fccc-445d-bd22-0053fd2db29c@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <368fa1c1-fccc-445d-bd22-0053fd2db29c@redhat.com>
X-Rspamd-Queue-Id: A2740140002
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 5q4p13c39sjkspu3kdcw61bup7jmswhp
X-HE-Tag: 1753339658-683893
X-HE-Meta: U2FsdGVkX1/ebwbT0J0fpUrEXQzDPjLymJ4+9cFmGMaqmGtf9iKPRfXA1V+LnPHA0DeJ8tQEURRVW9L1cTQuYT05PuJGdPo+WPl0n7vA8STKDM3ec+/Uel1H9JhrOdEdP7sb/RvJDJ+fxK7loWRPMqog3MJPoicRLnl4658Z2iSi94V1O7zob3wSClt/3OfMAhuZn/3KjJODVD3e09eMYhopDYikxy3YbQYZicMn8xRXBBuSxoD+ACZkzceHSp+6z5clPCmmM8uSQYKk5n+vpsXX9fD6XeHtU7jpULOyGMmCzI6e7cH5i3Xm+Gs5tP3USCr8MbpJV64ocaV9TOkJOH4R6IzRSQdbzyReMgQfhrtpVMYKe175Bu1E5VWJWPFLQKyHt5bfhGF2w5k6/zfiZyPyPoPT/Ml36AahHxS2Es2KPD/XNzB6zNh2GynE0+LjYOL8NBcQ0z+Ja4FiUhXycoPTk3h5GzdPkeBFkvGdWf6BcGltYj4sCEk9g04KwimJ5QkWAvJtjwdLj/ZkLxjYqO1+Jj5n0+75atFYV9BVSl1/5moDV5hI55a0HMmj4AqjWwsbp2IValY7aI/GBQTDFvpSiZz9uBtJGVhkwnfMQu69pwd0+/mQWVj1Fjw4LASmU3NB8Ea5OdK+n2/hjsmZWpd5CEmmwdIaqX2vFkQmkzU5nZ2kFprfMeUciv9mpRcdsNNNF+KbkJw9a4x3bPDs4zLe5BdwVHJbsv0OdQ09WBIEubkDvm9crrPkG8lrRmEixNYuEvXNbkfsylifVVZn9LyK3AoaQ1wJKfvQzvUcXvOgDCv195Y1YtjEN8vobkeIdQUuW0XzWFMYmBq+WNpoBSgvfkOxTrMsYGWrkTBzgBQ2yGIToc8AOoPVtlTJo3scZeF6NoFnTa95u+wpqGjGhTK34DU20NU8wGxjNc4oNi7I9SN1if7kPpGty41j3I4HBgFfVMRh76h7gJbziRP
 eMrfZMSJ
 IiraojmtiwYpGmqBw+ibcxgft0hlWtdchclqow+p2Q7+VNhK4LumrfoVGJjPTeHqUaF9nS+HQQpBhYb6Ky6xvyVamHiyx7Bvx+dfJCtHkcQCCKyAosSzVKyzZGjaop6QhrNjnLoMqgZPrzrURlWoTTkM3XrMADGRtNFZ+a6vNhP4au8jfUGHJgSuW9NMHwoO0xYGOEF1MB89GcZKg5dTCxz4kqQFrwZUYUOKZJd+XgiLA+niYfKczlZtfC5bZ5CHMIi+k8m+UWACPYQGUnKA5PXAUYQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 24, 2025 at 09:04:36AM +0300, Mika Penttilä wrote:
> 
> On 7/24/25 08:57, Matthew Brost wrote:
> > On Thu, Jul 24, 2025 at 08:46:11AM +0300, Mika Penttilä wrote:
> >> On 7/24/25 08:02, Matthew Brost wrote:
> >>> On Thu, Jul 24, 2025 at 10:25:11AM +1000, Balbir Singh wrote:
> >>>> On 7/23/25 05:34, Francois Dugast wrote:
> >>>>> When the PMD swap entry is device private and owned by the caller,
> >>>>> skip the range faulting and instead just set the correct HMM PFNs.
> >>>>> This is similar to the logic for PTEs in hmm_vma_handle_pte().
> >>>>>
> >>>>> For now, each hmm_pfns[i] entry is populated as it is currently done
> >>>>> in hmm_vma_handle_pmd() but this might not be necessary. A follow-up
> >>>>> optimization could be to make use of the order and skip populating
> >>>>> subsequent PFNs.
> >>>> I think we should test and remove these now
> >>>>
> >>> +Jason, Leon – perhaps either of you can provide insight into why
> >>> hmm_vma_handle_pmd fully populates the HMM PFNs when a higher-order page
> >>> is found.
> >>>
> >>> If we can be assured that changing this won’t break other parts of the
> >>> kernel, I agree it should be removed. A snippet of documentation should
> >>> also be added indicating that when higher-order PFNs are found,
> >>> subsequent PFNs within the range will remain unpopulated. I can verify
> >>> that GPU SVM works just fine without these PFNs being populated.
> >> afaics the device can consume the range as smaller pages also, and some
> >> hmm users depend on that.
> >>
> > Sure, but I think that should be fixed in the device code. If a
> > large-order PFN is found, the subsequent PFNs can clearly be inferred.
> > It's a micro-optimization here, but devices or callers capable of
> > handling this properly shouldn't force a hacky, less optimal behavior on
> > core code. If anything relies on the current behavior, we should fix it
> > and ensure correctness.
> 
> Yes sure device code can be changed but meant to say we can't just
> delete those lines without breaking existing users.

Mika is right. RDMA subsystem and HMM users there need to be updated.

We have special flag (IB_ACCESS_HUGETLB) that prepare whole RDMA stack
to handle large order PFNs. If this flag is not provided, we need to
fallback to basic device page size (4k) and for that we expect fully
populated PFN list.

Thanks

