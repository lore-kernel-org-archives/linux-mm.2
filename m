Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFB38CFA460
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 00:40:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 359246B0005; Thu, 20 Nov 2025 19:40:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3097F6B0012; Thu, 20 Nov 2025 19:40:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D1046B0022; Thu, 20 Nov 2025 19:40:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 080046B0005
	for <linux-mm@kvack.org>; Thu, 20 Nov 2025 19:40:42 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B0871B95F3
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 00:40:41 +0000 (UTC)
X-FDA: 84132758682.18.71BC349
Received: from fhigh-b5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf10.hostedemail.com (Postfix) with ESMTP id B8286C0005
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 00:40:39 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b="bQ/usSFT";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="W 6/D/Im";
	spf=pass (imf10.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.156 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763685639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BWrF0R3qQL8kwm9npP1EvAhcAZRE+BA2fEO0OQij6hY=;
	b=xlGAXC/wUSA+rwUAuieVVvSQ8yO7oUPC0ngqF54tiDmoiIph4Xi8XEya5NKHaeOymERUqj
	uJ8dgpyRqz6+WRWJNIoxZg7X8pGMFkmEbe5jlJkQjGMMnWVuN5n5yDuGQvOYRdrvuFJrsQ
	ugMacaxK/pY9Tn98nC91j9uC3QaqP74=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shazbot.org header.s=fm2 header.b="bQ/usSFT";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="W 6/D/Im";
	spf=pass (imf10.hostedemail.com: domain of alex@shazbot.org designates 202.12.124.156 as permitted sender) smtp.mailfrom=alex@shazbot.org;
	dmarc=pass (policy=none) header.from=shazbot.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763685639; a=rsa-sha256;
	cv=none;
	b=UGTFGWvJQJ2sjMMWNzwI2vyTKPiFMlGsQWGIJjp4jBDu2QXApmuu37DpY0+kvFzDyzLAge
	i3DsFsVn3j5dJAh5AF6Ftnjr6vVi3EHaZu/g3Fv1sD7r7Dk50XcMShfXrubNCHfK4W6RHM
	fwvF96gKgl6JotHYLgY5UEy+Dn+8voQ=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 4F1D37A014B;
	Thu, 20 Nov 2025 19:40:38 -0500 (EST)
Received: from phl-imap-18 ([10.202.2.89])
  by phl-compute-02.internal (MEProxy); Thu, 20 Nov 2025 19:40:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shazbot.org; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1763685638;
	 x=1763772038; bh=BWrF0R3qQL8kwm9npP1EvAhcAZRE+BA2fEO0OQij6hY=; b=
	bQ/usSFT6o+GWegKvvd8h3PcSB2A1hCVejwJtF7wsEdC7CwzuBGsDiHZbmkxFhTZ
	d3UIol3MggwYKtr3/7m8xHyYxFZEfi8xy9RcSPvxuCsyc0MdounLwdBO/jy+bF8Q
	QMRupKehNfw8HmjuvCCa78xT+NL7tm00BrGzRYcDVClQyvRaUh5RVCfj/DJfA9BN
	x5s86jNR+3qTFD9TYEPKOzH5TaocL4t+30TypdxjRYVGuCBSF89ZL3JYk8ybXWdP
	2HBXxNDUNKIY52H6XFTtq5eDJxYKvYA3BepZULCxBk8xlDM0LYJhphJ4jbnaB2do
	BBa9XXH1Lha6uliQ1SziTA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1763685638; x=
	1763772038; bh=BWrF0R3qQL8kwm9npP1EvAhcAZRE+BA2fEO0OQij6hY=; b=W
	6/D/ImpsP6E8UHOnHw0GHkvwQhWlYdOrwXFehCZFo9BlwYpK5+GOeFWB33eaI72c
	o2iReqsiKaZ6t9qjAjpN0Xy115KlGnR65KX+g5UzbVBd/rcQlaiz8hiLAqer98qQ
	XFoirt/2+8WdsP7ETLVokZeBr04/nTxLN1HgtZrk2DDl7wrTRs8onknGjWKUWLnj
	5TIODtgQLz3kfaCb4wP0kgI7O8Hg2ukyYnBZhW4Sf5Xwx3Si8Z8pE8LMGUWysWV9
	EbfxOHrI0s9K+yzOiA+ZKd4nSgH24XQr7oMuDcKfWL0sRgLVy6W4btuveDFkKOyb
	MNY477StKsGD7B911h8LA==
X-ME-Sender: <xms:BLUfaTcu-W1ZbFNKOZl9hEoK5kM2iKVgFY7hi_qwxdijBO8eYSBaQA>
    <xme:BLUfaUDr4NrEmO5B9_8l2v3n4jQbNvi6XEqlmD-9LLSydDnUnrnRawFKgPpvTMRYP
    Y7434dwhOkYoKdQMRD7qq4WJ2pf5tck8RcL6wMx-_En2tJAQ-vQQQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdeggddvvdekheehucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehlvgig
    ucghihhllhhirghmshhonhdfuceorghlvgigsehshhgriigsohhtrdhorhhgqeenucggtf
    frrghtthgvrhhnpefgfeeflefggfffveffteetiedvtedtgfdvieevfeejfeefffevteej
    tedufffgveenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpegrlhgvgiesshhhrgiisghothdrohhrghdpnhgspghrtghpthhtohepfeefpdhmohgu
    vgepshhmthhpohhuthdprhgtphhtthhopehjohhroheskegshihtvghsrdhorhhgpdhrtg
    hpthhtoheptghhrhhishhtihgrnhdrkhhovghnihhgsegrmhgurdgtohhmpdhrtghpthht
    oheprhhosghinhdrmhhurhhphhihsegrrhhmrdgtohhmpdhrtghpthhtoheplhhoghgrnh
    hgseguvghlthgrthgvvgdrtghomhdprhgtphhtthhopegshhgvlhhgrggrshesghhoohhg
    lhgvrdgtohhmpdhrtghpthhtohepkhgvvhhinhdrthhirghnsehinhhtvghlrdgtohhmpd
    hrtghpthhtohepvhhivhgvkhdrkhgrshhirhgvugguhiesihhnthgvlhdrtghomhdprhgt
    phhtthhopegrgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtohepghhushhtrghvoh
    grrhhssehkvghrnhgvlhdrohhrgh
X-ME-Proxy: <xmx:BLUfaf3IMN_DjSt37FnR5cC7cKZKzm-Evis2a5redpwD9gpwNa4Mgw>
    <xmx:BLUfabfYFOLIxRZxj2GcfZQhMAJrV3AvzpNs5lf-FrATezIBt46vVw>
    <xmx:BLUfab6kKk0AxJC9j7DElLBpacsb7lCfW4srcPj5EWec1IZ1DQymrg>
    <xmx:BLUfaYhbHXAT2tIz3nE8TBsZFON8yBhxofv_cAOU6AX3rp4HzrS3QQ>
    <xmx:BrUfaRbHrZD02fwIphP49SQDR9cZINb17knsJOrpHoo-8nVEkFZAnwDT>
Feedback-ID: i03f14258:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id BD7C115C0053; Thu, 20 Nov 2025 19:40:36 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
MIME-Version: 1.0
X-ThreadId: AE6BP-1UiBv7
Date: Thu, 20 Nov 2025 17:40:15 -0700
From: "Alex Williamson" <alex@shazbot.org>
To: "Jason Gunthorpe" <jgg@ziepe.ca>
Cc: "Leon Romanovsky" <leon@kernel.org>,
 "Bjorn Helgaas" <bhelgaas@google.com>,
 "Logan Gunthorpe" <logang@deltatee.com>, "Jens Axboe" <axboe@kernel.dk>,
 "Robin Murphy" <robin.murphy@arm.com>, "Joerg Roedel" <joro@8bytes.org>,
 "Will Deacon" <will@kernel.org>,
 "Marek Szyprowski" <m.szyprowski@samsung.com>,
 "Andrew Morton" <akpm@linux-foundation.org>,
 "Jonathan Corbet" <corbet@lwn.net>,
 "Sumit Semwal" <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 "Kees Cook" <kees@kernel.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 "Ankit Agrawal" <ankita@nvidia.com>, "Yishai Hadas" <yishaih@nvidia.com>,
 "Shameer Kolothum" <skolothumtho@nvidia.com>,
 "Kevin Tian" <kevin.tian@intel.com>,
 "Krishnakant Jaju" <kjaju@nvidia.com>, "Matt Ochs" <mochs@nvidia.com>,
 linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 kvm@vger.kernel.org, linux-hardening@vger.kernel.org,
 "Vivek Kasireddy" <vivek.kasireddy@intel.com>
Message-Id: <cd6f8c6b-6950-4b06-8f2d-bb4ead660ead@app.fastmail.com>
In-Reply-To: <20251121002344.GC233636@ziepe.ca>
References: <20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.com>
 <20251120-dmabuf-vfio-v9-10-d7f71607f371@nvidia.com>
 <20251120170413.050ccbb5.alex@shazbot.org> <20251121002344.GC233636@ziepe.ca>
Subject: Re: [PATCH v9 10/11] vfio/pci: Add dma-buf export support for MMIO regions
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B8286C0005
X-Stat-Signature: 7qwfg175dgtm57ai63wu3q95mm5hnhr3
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763685639-426152
X-HE-Meta: U2FsdGVkX1+uZjUlSJRnpBttq1dM3nqsMxqC/N4OZvm8vlBrKxywtC5cDusgBG7EIkLBofZBOrzzZn/32/T8GQ18Cs9YKb5PX3osFfbD6+PcBOeQuqlHqKo/IF/YpthKmb6uhKsrSkKNp/z5yX1wtR5JXisAfKhVEbxissbkexqfiJ8G6dNHyJnPTeaARMTGu9i5t4ndDpRlDLkMy37FPBOB0qCDEsKpB5Y439QKLDnjmIkbApI1erb3NMIQiNJCVlhwqPaMm+A8qDWCGoeAK3ob5ApjPOtsQzdeFoKS9tIiGDUYa6vtszLZKOdESlMvJoVnh+WrnFKTUDrUEjpMlkSAJ2SzPW0lUEPMHXHiBk9JcMipY2//v40FHNnd2wle1aZUoEUJUN4aWztFGc/SaQUitCR1wXSo3GVNsnixxq+AMLbvnAqOijWVgKck/o3iJrgjadkRdbWqhVWo7Uv8PCTLLUE0KzxVHVCkY2XqfhTiBYlLOo+LtlS7TPuIkXpk0B4/bU0f7bNetSCNbdmXtGJOZmA1yHHoQEN2JCdc+nb4Ur8/uMvY0GZ9hKwTZ3jjZVqm4m0pHLMgB5yxbN53h4RPejZ14MQf60sviKcUK/HZ/yp1vrhgi1XGSnTP8OwUlsrcWINBP0KG9YsB+bP1WX1TtC6TVNG8RVsHboPSmWAk/Rxv3I2L3cCkW/NjEF61/uFNv9dyNytYXKMVjtmCzlr8wRAb1fLha1a1YP3x+JkENWp9BaF3YrxbNabVcSCZsx3FzkUpjvRNmxN9/vb8RcLQD6ZxTYJ2jHiM1EvYxfd/WWdFB4xnVQZQoKIuA9R1RkM6x5wuVlpJkWZFe6AcJBWuXsjRvJm8jW7XNSpcBRCO8RFdMKGDEUTf0+V956KumCVVgvqR22vBARZxVyRVbDYxcHjahbP97DgPvb6HcDFMPDkEthzAUmXDdMsqCnFJ8soR73vZWIs7S9XipEX
 Duds5sDh
 EMWzh6ONamLGmPf14K66bBK7wycBz8PKPqyxYOloCYBnYmhlxycoKjtQ4AcTawylvykzuW9kSEdLz6CrcwDitMYv1Gm9ea4KcbWYZbSOZ6FVpvtXU98mKYDjwBzwmqmMCM5Cz09k6cN18Bq2XtjVrGjaaLnri/XuOlcupY+nOXzYFIMmzy8T/LPqFPXp68wGU3mDxCooLe9f6wEdHCJqJoBNN/PH2HNgN9wIvp2F7VpImrTE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 20, 2025, at 5:23 PM, Jason Gunthorpe wrote:
> On Thu, Nov 20, 2025 at 05:04:13PM -0700, Alex Williamson wrote:
>
>> @@ -2501,7 +2501,7 @@ static int vfio_pci_dev_set_hot_reset(struct vfio_device_set *dev_set,
>>  err_undo:
>>         list_for_each_entry_from_reverse(vdev, &dev_set->device_list,
>>                                          vdev.dev_set_list) {
>> -               if (__vfio_pci_memory_enabled(vdev))
>> +               if (vdev->vdev.open_count && __vfio_pci_memory_enabled(vdev))
>>                         vfio_pci_dma_buf_move(vdev, false);
>>                 up_write(&vdev->memory_lock);
>>         }
>> 
>> Any other suggestions?  This should be the only reset path with this
>> nuance of affecting non-opened devices.  Thanks,
>
> Seems reasonable, but should it be in __vfio_pci_memory_enabled() just
> to be robust?

__vfio_pci_memory_enabled() currently only requires holding memory_lock, I don't think we want to create a dependency on dev_set->lock for this unique call path.  Thanks,

Alex

