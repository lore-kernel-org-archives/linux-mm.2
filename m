Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA250CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 18:17:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C66B96B008C; Fri,  1 May 2026 14:17:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C17B76B0092; Fri,  1 May 2026 14:17:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B06306B0093; Fri,  1 May 2026 14:17:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9BC106B008C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:17:18 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 48B19401DB
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:17:18 +0000 (UTC)
X-FDA: 84719658156.04.4683E8F
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7165540006
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:17:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LRenUcPt;
	spf=pass (imf11.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777659436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hH8WjvIFvfB7lCVYfIBULvtLO+n9YZWTzS7cJlqaCmA=;
	b=u3TJ//ZZBwMz6IRnHI6dX4etHofwq8xwHcIGMLtAfMyesR8DQbjJfenQJWEd+9QIqh9F6x
	9mtDO9gTsO34fhf0WfIkuUxbQ18NDxYgWvudpLZzVZpHYTP9eCH9KRo3ghGnyCl2DjR66+
	4X0+gc+N1lz3TT8ulVrPm6VWDf2zWs0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=LRenUcPt;
	spf=pass (imf11.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777659436; a=rsa-sha256;
	cv=none;
	b=VWJOGkRC6sk1bo8yGKx/MQQ1WXjwJ7/XLD4nfDRGXbo6HQJwFyH6dvactoKbZ5cvrPaBfY
	92kAAv5G66++5bNXDORz2lvitC7mygoOkdqd03m7XJ2l7Pcr0DLA78LMC57uEX8YMQ53l8
	m44b0Bq20Q+do2l/KchG3PNp1D8BejQ=
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2b243198058so8875ad.1
        for <linux-mm@kvack.org>; Fri, 01 May 2026 11:17:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777659435; x=1778264235; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hH8WjvIFvfB7lCVYfIBULvtLO+n9YZWTzS7cJlqaCmA=;
        b=LRenUcPtQBwZ+UM8x/6QheKy1ClfNRUnPxtdql8ddcFclxeTciToRKef8vXKC6AUkE
         HLFFsWMGPH0nvX8QFmamlSCgh5M3v9Uf4/prwSRXwpvohw0cC3x+w5KQxZYR7gtRqlWq
         H79NdFZ82eRXleOZs5XcYIszqnpVbPOAbqSlY6pKX1qflMNWPqUWRLJULtvhsDcupi1b
         IzE/VO52oAmZAmCnE96gnxvvFHFZtKDn99+o2ygx6CNEBC4udVvlPmSdyzuXTZGA/OyX
         nQ6LC4tnMmhCOOsgX7g6+3lMQ0YjgIkTliWhRZQjG6V48R9/uQWcve6LbVk4KcFSkEJa
         FXMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777659435; x=1778264235;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hH8WjvIFvfB7lCVYfIBULvtLO+n9YZWTzS7cJlqaCmA=;
        b=XgAxGGUgHgoUmrLoqYVMEyNnCqiqEM35rGl/2pSMg36oWxoYN/cJPNWbO2DpYwN5wI
         lSxJLIIjzgOp/0+cEHu3xEJdD4UgyC325FG6lU63/3mH2Plh6RUnVRimZHKRPglnYAoP
         fJf9GRQjuxn51izsIZW1UaP/K2UAxIgeiiTbmGwwLCU0SZ2cTVcCRNCmAizmB/hYj9SM
         bmB6ptmKT6WwI/m6fia9INGwwZfhdJs0e5cvy2zYSQaTNQhBv+wEyye42FE5LJPTK8nw
         l3MVNbJFuMwtPXq9VSWbuen+d2VXdB23dFqZvXrP1fkfKXz1eYT+ho4EuypU55aypJ/y
         XjtA==
X-Forwarded-Encrypted: i=1; AFNElJ+Uk5eDJopzryv/4B1XKvlGt7aKKAS4+8K914cqa9PkP+IFjIghSIbTZmjjFwADBW0p+PoWKm6uFg==@kvack.org
X-Gm-Message-State: AOJu0YwCKHECJzxIg0P/FZQYBoRkWojZHupfK2IS+PfD1wlRSnvevXj9
	updExS9xKCaQfcvBZ2QXH312KGEJQ8WfnfLOLOXIaz0xzt6DO1Gu2+eQUbrFYzEmvw==
X-Gm-Gg: AeBDiesNa7K3yiRV/AXvMCzB2VbCZAoyL3pm7rsNOf8y3TXbYl96Eg+vmsqAKTsOZCI
	T5ouyo+ARcodbPz/F9+1RCXjkrhk/d1bi7nT7jAorTU+TTHhPsFTadN2Mqf5QfuKuJDowkR7vcR
	Gm9iFSW1sJd3gQG5T4UHWQ2aleNIpXtKDrvUWKm3nSfp2m+epT0tRZIMFjm/oN2QuLsbF9HcMbg
	R4eTnmpgJr2TiCEBlAtJc5zrLwLLigVVsERGxzXtj8M8C+PAAbdj2w7UFZHlafd4jGYGTX1qCS8
	nWB2GSectffYQpItyLBllxXR4+nXAFteJsxO97IsrH8MZzXniMcCUdaV057N01f+z3YbRem1Cl+
	G0lvc9+Xtu0X1YGdFz5Qk9IdqYz504H5XL6tD2uI9k6shbUmFWA+3Cm186uc8KzHZkNig6iPm7x
	20Ix2m4oW7W9aQyuqC78EIpU2eUzpR2HpSoJ97PcLuLfSSLkgastLj+hgPAsu/wXWrbzBPJ9n82
	w981wI3QA/DJJTiBkcDew==
X-Received: by 2002:a17:902:cf4c:b0:2b4:60e6:44bc with SMTP id d9443c01a7336-2b9f38a41abmr300485ad.13.1777659434630;
        Fri, 01 May 2026 11:17:14 -0700 (PDT)
Received: from google.com (195.236.83.34.bc.googleusercontent.com. [34.83.236.195])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c7ffbc85c61sm2776855a12.22.2026.05.01.11.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 11:17:13 -0700 (PDT)
Date: Fri, 1 May 2026 18:17:10 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Robin Murphy <robin.murphy@arm.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 02/11] PCI: liveupdate: Track outgoing preserved PCI
 devices
Message-ID: <afTgOXpUNWMapPAS@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-3-dmatlack@google.com>
 <afDqs6oqWlhoVqMN@google.com>
 <afPGYp145FbrvURR@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <afPGYp145FbrvURR@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7165540006
X-Rspam-User: 
X-Stat-Signature: 6h8nbnqa3hc4txf17rpmsrkjqats1syy
X-HE-Tag: 1777659436-431355
X-HE-Meta: U2FsdGVkX195YDcp7yuOI9CgXBV38oKgRdq1OUHopYlSne+sphfUPsG2gAC27gLpMZuuptF64jUQZGMsd32idbMAJIIY9PMWOf2bj0jesx/Yw8M69wCQSt8J1dYWLME39VFJBDGkikess57AF1QpjdRr3xN5wVfQ1fsf+CnNUCBsFcVmGEjRyQPzJGSozO9KDLKxy4FwifwCLkOyjUWjYvizoNbCmYegThzs7yHMNNuwUXJhotP/zPEErfKM3CUvw3dAJNqz9tPGvnjFtyoBUs2Wdy7A6d5hqvIP/76rT4eEnejHSlavrmqVPrdX7RhyIvEdjwhuDfdbiBrFJS4B9XNNNHNU5lHQraEdRu4NRxEPllyP5YFJ8dZVB0W9r07WQpyhsO765ocBxyy2VSdjR2c4BOde28fccU7NtQJDFNRvPF75WjK6WYukhXIFIE0TvVIHX/mYKvUqtn3Xe/N2ZbNeqqu/gGJ2rldeOLKED5v+2WvayYVc66ZgZBspxzZW3MuSW8L5NrpfU0BElkCbDcXDmuxPjhnPe1FxddDFyeUWGOdEW370jejJ92yQ9WpTHmqJ5oO/zNfbgosUKdYzs4tZebU0JkxydKlP3CuGdWUm1xTGz6bI0OIVciyVBhDxS98Fn6QtdTo9HMuojlTAk9FJ2WjTlTPkjnSkYx6T8en+WVg4UelIukk/qzqQxmLiC+9PhfNxXqqDsOLYd6nILFMQ9tyaXoQPvvQPSTK1wToXVQ0lAd0ce4SNw/OG3qVwPNXSYj91UxeoK9sV7CBPfTz4fVHjtDyHCjsp2Rmv3oG89waHShFO/JYQwX4iiz2Ss1N20GP28Lmt9jLSyGRjl1lWFmm/YqCkkcHXjZu/zGwQLjW5GEz2xL9P/aqpiRK1ShXROvUlzqw56KDsBWQk/X9iAFHfSzbjbfKS1m+YDbjWeCU9Rpgp2lXxwHialOwd/26Qv2buxvV2fsU+YyY
 wdzBhfrI
 UaEkHxW+WnCHHbDQkFJFvFLaNhRDQrMPUQvbkDRSzHU9I+zlDedKlk9noBtLYcfGQQj1KGOBfsKSBHoSE+nrV0WsQSvQUVxKNMEu9ykJxqowo2Jp3ImuIu63mKhYW19stcxJxRHvXnjqvgu7zvkw4U6TREV9pxy8CmYvJHD4WkaUsT+Rz7/6uEe0476xfiijxxguj9u+mNXymsVUOAX/GR2RgQxBYhF3W7RpvO3xyk/9TgMv9qgPajZDgmkJlgQoM5xeK9je2my5UD38QfFwUPhgabO5kkOFghBVpURyhxrCq2fZc/nR0Ij8ybyLTDTeIFl0hkXAgq5s0i0cWYn1VoTnRaEnlrLstM/FiB+xpbsioOBg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 09:15:14PM +0000, David Matlack wrote:
>On 2026-04-28 05:24 PM, Samiullah Khawaja wrote:
>> On Thu, Apr 23, 2026 at 09:23:06PM +0000, David Matlack wrote:
>
>> > +	for (i = 0; i < ser->max_nr_devices; i++) {
>> > +		/*
>> > +		 * Start searching at index ser->nr_devices. This should result
>> > +		 * in a constant time search under expected conditions (devices
>> > +		 * are not getting unpreserved).
>> > +		 */
>> > +		int index = (ser->nr_devices + i) % ser->max_nr_devices;
>> > +		struct pci_dev_ser *dev_ser = &ser->devices[index];
>>
>> nit: Maybe we can move this logic in a separate function as down the road
>> when we expand this to add VFs and Hotpluggable devices, this might
>> change significantly? It's good if it is self-contained.
>
>Did you mean to leave this comment on pci_flb_preserve() where it
>decides how many devices to allocate room for?

I was talking about this one, as I think depending on the scheme we take
this might change significantly. Just a nit, you can ignore it.
>
>> > +static inline struct pci_dev_ser *pci_liveupdate_outgoing(struct pci_dev *dev)
>> > +{
>> > +	return dev->liveupdate_outgoing;
>> > +}
>>
>> Is this expected to be called under the outgoing lock?
>
>For now this API is only used during shutdown, at which point userspace
>should have already been stopped so drivers should not be changing the
>preservation status of an outgoing device. So I don't think this needs
>to be under the outgoing lock, but it would be nice to have some more
>explicit synchronization.

Ok that makes sense. I have similar cases in my series, but maybe we can
add kdoc regarding these stating in which context this is expected to be
used?

