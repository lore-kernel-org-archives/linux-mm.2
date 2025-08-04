Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F620C87FDA
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 03:38:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD4266B007B; Sun,  3 Aug 2025 23:38:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BABE76B0088; Sun,  3 Aug 2025 23:38:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE87D6B0089; Sun,  3 Aug 2025 23:38:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A24666B007B
	for <linux-mm@kvack.org>; Sun,  3 Aug 2025 23:38:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 553CA135F6D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 03:38:34 +0000 (UTC)
X-FDA: 83737667748.27.B4D2FA1
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf09.hostedemail.com (Postfix) with ESMTP id B4D47140003
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 03:38:31 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vIsLKdYF
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754278712; a=rsa-sha256;
	cv=none;
	b=uIW+mDW7wlCoQZkHsi9NbJ9Z3rvuhFD2OTQfUv19fQMGLoCPWSiQl8LjK3MGUvM0BlYgoc
	omwPxYQS8dwefpCNbUyGjcKbP2+/NP6Yo8bQyeNhvbsi8yvWaKs23Hp5D62C/SD5s1JkrS
	z4JoTVhQzRDoJcKOK5tQdwAx01/Is/8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=vIsLKdYF;
	dmarc=none;
	spf=none (imf09.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754278712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SmxoINSQKVJVK+Bn4i2QXaigutnESsGDJWcnHJouMq8=;
	b=tUBOTA/PSyIW9CHQOt7oDUoHEMfwTPQeVf01puyxQmr4xtrKnY/7/y7acVqUqUTe3kj89S
	fvw88OvlEKLmhjegZtpCYS4qZycB37Co3UjQOUSIvQ+3fPH/BMnfdvILXL9RlbZMldz6pR
	+Ny4hM5fKQh4mjmZwgybdtEnrrf1K9c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SmxoINSQKVJVK+Bn4i2QXaigutnESsGDJWcnHJouMq8=; b=vIsLKdYFH8YXGskFCYuFxM0Kri
	4LEo9ReJIfgKFC95xymdzIuZHgWmCy4G3xVF1JqLP/afdrq9I84T2Y/HuFvZL4VO6QmU21lsUX/J7
	vabemJeVXNbK57caQoIcupupdF5BH7q6dfJPU0J/aad1iPWgFP1Pta6YnAxGVC/HxIlB76K9yRSGM
	9j3b/WmA+tZKaDnoC39qDIVxVYX23JxNjVp20InQWi7XyuBDNDCOuusdG9eda9qGfK1Uki2htTbQ5
	+Xwy3IqaT9W3uDTeg3KYHyV0grcCXOdru7B95ajExnsHQEygus1gpnlTvvukrNJXtwkIJZ4HcTmaN
	wXIAK1ig==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uim1N-000000099Z0-0JOE;
	Mon, 04 Aug 2025 03:37:57 +0000
Date: Mon, 4 Aug 2025 04:37:56 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Robin Murphy <robin.murphy@arm.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Christoph Hellwig <hch@lst.de>, Leon Romanovsky <leon@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, iommu@lists.linux.dev,
	virtualization@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/8] dma-mapping: migrate to physical address-based API
Message-ID: <aJArFNkuP8DJIdMY@casper.infradead.org>
References: <CGME20250625131920eucas1p271b196cde042bd39ac08fb12beff5baf@eucas1p2.samsung.com>
 <cover.1750854543.git.leon@kernel.org>
 <35df6f2a-0010-41fe-b490-f52693fe4778@samsung.com>
 <20250627170213.GL17401@unreal>
 <20250630133839.GA26981@lst.de>
 <69b177dc-c149-40d3-bbde-3f6bad0efd0e@samsung.com>
 <f912c446-1ae9-4390-9c11-00dce7bf0fd3@arm.com>
 <aIupx_8vOg8wQh6w@casper.infradead.org>
 <20250803155906.GM26511@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250803155906.GM26511@ziepe.ca>
X-Stat-Signature: nynjx4gn9pcuu7r6ycrc3yj9yggnuwd1
X-Rspam-User: 
X-Rspamd-Queue-Id: B4D47140003
X-Rspamd-Server: rspam02
X-HE-Tag: 1754278711-434094
X-HE-Meta: U2FsdGVkX18JGwLiJY/0YObZ6Cgs2ZBJI/L5VLF7AhXaGL8TbqLxFtD/m+SkqQP7AAmCPwSg8gNQ6s//CUtS6ndWpkMHPQEnK/Qof4hg43ghXc+J1nw5SycGz8+EYH+U4UZeQYgpaKGue38SHMd5Jg++QGj1rwKND8ZLFwPGP2UtA7o1mK098EdCMVrq+/BMKTlUpihicBnwDHQoY9Cw0/wxK3Z+wmiHUpnrGfJkOg2pPf9FbAyXI5TFiOf2psC5OiKpF3QnFNKIUcq6h5euXi4frc5ZYl5BUQTdkbAPFdiunucPpUO9BsI61v0eidahd4+gbZG5P6Betkn5bIDwRDYIKKSDbVMHg4e57sdfXzz6keCr/sdD8ioz7bN3q6w6lzmSE0Y0DkVeM9M9FUemN6zkMyjVUekoMnewfOwrayA4FRd0+zCGGkh114/V5cPULdTtOyy8sJmapURL2mRBBUYhJc9wIRQi0anCmwU/et8RTXO7QoD7hJUMYIH0FobWQhUFxyElCooap4keGLu44xK4oxy/aFGs1VvNxVSVAR9R673gBQacLEbH6UgveR4mOWmy69G711lOZrQs1tPH1aR3p2iCsg3sMuDE5rWm2m0lsGrv0NrGels4RJQFXgVPVZ37E9c50PDHoXRWfRbsKMNIQESBJlE2SzuEtshPzIQaJEEhe9UVIrqrWvnV11CzKet2YBCftWUuaDXVvy5T8YncffANxXGe60P59FGsFSKC4CnZS05txiQ40XLPNaYbNM1N3zbQihoDcZ+OstKD5OgSi4Jj09BHQ0bCxQU1eAbhTcw1Y+1MmsvbQrd4Fd0nDQ2i/8WIEFZnCTp9MX5a8/dnH9SLMYDhB7PWm27kJdOaFjmhW8g6adrSkbc2Y4MsuEaYenx7MdvC6EN4FOIj9LNTztlPrQouEkNZGjrs0CFhVRAXB6wINRGvG9hGj7vu0ZLStd2Yygcz6dhwuQr
 V3E9eXv1
 bpqOv31h5F+1VFbbzUX8itW9ZlKVywI5vO0IZqhvl2qo8I/jxXvZ29hmVXdPbvtwCItrGhabYoAlGxZhk3cH1SE/Mpmx5hseqcilKk2N3hcxcXTVKJMhc45DgCS9g1tP0eJC0cLuTl7Dygqx/0qKSHYtvrN1hq0e5l2iRJIoQlvLx6TnLsI19THXUnQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 03, 2025 at 12:59:06PM -0300, Jason Gunthorpe wrote:
> Matthew, do you think it makes sense to introduce types to make this
> clearer? We have two kinds of values that a phys_addr_t can store -
> something compatible with kmap_XX_phys(), and something that isn't.

I was with you up until this point.  And then you said "What if we have
a raccoon that isn't a raccoon" and my brain derailed.

> This was recently a long discussion in ARM KVM as well which had a
> similar confusion that a phys_addr_t was actually two very different
> things inside its logic.

No.  A phys_addr_t is a phys_addr_t.  If something's abusing a
phys_addr_t to store something entirely different then THAT is what
should be using a different type.  We've defined what a phys_addr_t
is.  That was in Documentation/core-api/bus-virt-phys-mapping.rst
before Arnd removed it; to excerpt the relevant bit:

---

- CPU untranslated.  This is the "physical" address.  Physical address
  0 is what the CPU sees when it drives zeroes on the memory bus.

[...]
So why do we care about the physical address at all? We do need the physical
address in some cases, it's just not very often in normal code.  The physical
address is needed if you use memory mappings, for example, because the
"remap_pfn_range()" mm function wants the physical address of the memory to
be remapped as measured in units of pages, a.k.a. the pfn.

---

So if somebody is stuffing something else into phys_addr_t, *THAT* is
what needs to be fixed, not adding a new sub-type of phys_addr_t for
things which are actually phys_addr_t.

> We clearly have these two different ideas floating around in code,
> page tables, etc.

No.  No, we don't.  I've never heard of this asininity before.


