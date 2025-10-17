Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77D8ACCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 21:37:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D81CF8E000D; Fri, 17 Oct 2025 17:37:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D59768E0008; Fri, 17 Oct 2025 17:37:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6FBC8E000D; Fri, 17 Oct 2025 17:37:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B459D8E0008
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 17:37:28 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 666841DF953
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:37:28 +0000 (UTC)
X-FDA: 84008917776.13.FD44985
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 833F7180007
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 21:37:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FE1dBvUV;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760737046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S9EkNhymVLMKxTXl4lXZBEsZGNtUn/k0HTojV8R9ID0=;
	b=75Tii/WSfART7yXmxw2d45afCzhgNmEwrOppIEF6jzEp8ehlzWV0SIxS6L81i/iPvu6DMk
	6HfSSwgbNoMTIbaoU+xgLW/iZ+ZD8eUtbCc5SAWFRc0l8sBl4Yc2nYIif92THu2neAZWia
	lYfxvKgjph3hZmOqZK58DD1Yll4NH7s=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=FE1dBvUV;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760737046; a=rsa-sha256;
	cv=none;
	b=XXXZRuvG94M5rtzqiAGtBH7oQIlaw7EvtlAZz9PHgE+hgRcdYn4Y/dRNPiaW+iEk/tyeSk
	ca4N6a3is9zynESXGQc6dKllc1Rm+cN9KqgbUE1gVGM/jbcUi23Sg/ETZHqxL4Q76f9jXG
	B8sxJPNtAubZB0edyjayUlx8pf8/b+g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D2A714B5CB;
	Fri, 17 Oct 2025 21:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7221C4CEE7;
	Fri, 17 Oct 2025 21:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1760737044;
	bh=nYpBafhW7YwCHT2Y3O7Vz/Cfc9k402BvH2+Wh0f/DtA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FE1dBvUVul1ShFrtQ9a2yuuluVLEiX3PNARQaVwbXQaU+qoOwkoZFLo6b4wiRoAnn
	 EAWR1VKBFA4zRtgkP4k2hogdZvMF/OsA2XiB7rwYq/IaAOtbxaSzMwRQdJIRLlTGrz
	 ijhhPTnwyBb6OdZP8xn3qakbxsmeiLKTac97LR64=
Date: Fri, 17 Oct 2025 14:37:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>, Jonathan Corbet
 <corbet@lwn.net>, Matthew Wilcox <willy@infradead.org>, Guo Ren
 <guoren@kernel.org>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Heiko
 Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander
 Gordeev <agordeev@linux.ibm.com>, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Sven Schnelle <svens@linux.ibm.com>,
 "David S . Miller" <davem@davemloft.net>, Andreas Larsson
 <andreas@gaisler.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Nicolas Pitre <nico@fluxnic.net>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@redhat.com>,
 Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, Baoquan He
 <bhe@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, Dave Young
 <dyoung@redhat.com>, Tony Luck <tony.luck@intel.com>, Reinette Chatre
 <reinette.chatre@intel.com>, Dave Martin <Dave.Martin@arm.com>, James Morse
 <james.morse@arm.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Uladzislau Rezki <urezki@gmail.com>,
 Dmitry Vyukov <dvyukov@google.com>, Andrey Konovalov
 <andreyknvl@gmail.com>, Jann Horn <jannh@google.com>, Pedro Falcato
 <pfalcato@suse.de>, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-csky@vger.kernel.org, linux-mips@vger.kernel.org,
 linux-s390@vger.kernel.org, sparclinux@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-mm@kvack.org,
 ntfs3@lists.linux.dev, kexec@lists.infradead.org,
 kasan-dev@googlegroups.com, Jason Gunthorpe <jgg@nvidia.com>,
 iommu@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>, Will Deacon
 <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>
Subject: Re: [PATCH v4 11/14] mm/hugetlbfs: update hugetlbfs to use
 mmap_prepare
Message-Id: <20251017143722.d045a2cd9d1839803da3f28a@linux-foundation.org>
In-Reply-To: <c64e017a-5219-4382-bba9-d24310ad2c21@lucifer.local>
References: <cover.1758135681.git.lorenzo.stoakes@oracle.com>
	<e5532a0aff1991a1b5435dcb358b7d35abc80f3b.1758135681.git.lorenzo.stoakes@oracle.com>
	<aNKJ6b7kmT_u0A4c@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
	<20250923141704.90fba5bdf8c790e0496e6ac1@linux-foundation.org>
	<aPI2SZ5rFgZVT-I8@li-2b55cdcc-350b-11b2-a85c-a78bff51fc11.ibm.com>
	<c64e017a-5219-4382-bba9-d24310ad2c21@lucifer.local>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zbhttxtqmn5tdhx1yo3yny99nctbu8mb
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 833F7180007
X-HE-Tag: 1760737046-538803
X-HE-Meta: U2FsdGVkX1+JK2QdmezfequAm3xtq+Qd4hKClc5RE1Nn54P3D85bHRIbmGYJmdK4kKGxP6L/i51NT2ihNfqxrp9ovajMAk3hhj98TXUqibYpsjSot4gud8hTxFEQcU/DKZxneDX8TkCKY31KZkFkm4+7n9pPcxMNO1k9Isf+3AAN4paaZX6vkNhEiCRpoR/IQsV3IuRHtIwx1J6zeYHpfjpf+PDBAhkN24HeVNrDm+Go3ANk4IRC4mZRxPQKl/XhWc/qQDYnkkNQrl/QJUlDrVaakkfT8O/2pBynwiV6drkeV+BvYZAK2PIWy0b1Nr4ABnnwkQTgUfhleI0w32yvPMsJAlK+OgWG1zsfKS0k6yE4Jmd5oxr+1Z53IMkdxLpnaEzAFgPdU1kM4oTfO5cBBCFXwH8MZjFSRhz+164THpRWF8c0w6KjGpjT7iIdbUT7jA6yS4b8whi5XNnS81+nS9tsrSr4hnJ+vHT/Mr3VieyF8npfJ2HX1mb0CcAkI6qp1OfznAxIEUFdJY4I+0gKRgXKwzQ/Ea1GmSHC1Jtve7uUxP2GrV0VpRccK+Z3v4BraRzxRtUEsHmy/MxLwnBNj+3EEQyKPMvD8xiB/RjVoNO9w6woXjDtSKjnTaqR9dFRHTCBFCeQdnMQ7OhgeZhB/p7udAdoOFsVbnMOCP12wh0hrkceEv2c8uABc6RlV9S9LRi3RlVs2L390tEs2cVupMGm4nvbmYLlpnpm0mY7lhPvoYYteJGbfUfkCAAjmkoW8LzfdnSzTX3kjG8x5zykR8gDzOjO1n1ud97kGqiG1i4CdHHbHO93sbWXm97Zw63Y7mebksHkS/rjXWMIyMnkpltSiFhU2mUmHFvpe5nc0/iSOkAK7yg46tH2A5mxfNLRiajKfoDpVUp0tB/IVIZfkbZE3ztHCT18K0FdRvhFWHtltbSPI7Sco9cy5Z9NqIxlnPnjVerk39b0deDTy87
 ZVad0sGa
 ckeuEhDb6k26tdtwXn03Lmz4tgxPQnM/m1gFPJFBiicuAYcq/ETRXC/jVcGukfFbBWyOGsZ4AnnbtU31RMQCEIFn1vFNSVvtTLnwXmggONfXhiNI84BZqkk5KwzIv90ihaJStROzNqegSbAj6huehPewU60NR76UpOUh4EhYGnqDfHNqCzMcXie/INNjMVTUtYbnPoGHiaFwVFh2mEHSxc/jORNSbyPHh4iHvuyEZxDL86JCKXGBv83/t35MMchxZ0hTFXevC5MXsKU8nPTXbgicheZiccWRZqXLPAD0vfKKyuKxigB+OrmwmK2Our3GbcXhmbTscq9phf8P4M/tjGx+j4qcYSlo0t7IEX8Z34unXyHs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Oct 2025 13:46:20 +0100 Lorenzo Stoakes <lorenzo.stoakes@oracle.com> wrote:

> > The issue is reproducible again in linux-next with the following commit:
> > 5fdb155933fa ("mm/hugetlbfs: update hugetlbfs to use mmap_prepare")
> 
> Andrew - I see this series in mm-unstable, not sure what it's doing there
> as I need to rework this (when I get a chance, back from a 2 week vacation
> and this week has been - difficult :)
> 
> Can we please drop this until I have a chance to respin?

No probs, gone.

