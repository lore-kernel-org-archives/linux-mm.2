Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30EE5CA0EE0
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 15:07:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C76759000A3; Wed, 13 Aug 2025 11:07:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E8B900088; Wed, 13 Aug 2025 11:07:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8C419000A3; Wed, 13 Aug 2025 11:07:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A7CE4900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:07:25 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 72210C03FF
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 15:07:25 +0000 (UTC)
X-FDA: 83772062850.06.D9C91C9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 00F5A2000A
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 15:07:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YENt6LTm;
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755097644; a=rsa-sha256;
	cv=none;
	b=RatoNV7jMkuKJ9YL7PCDFQlkeeugz9uc7/0djZSyRgwniBJ4ZA05xk3v35VHFDNs/KhcWB
	RpyjJfrbvJPPA/gvY2ulmaSfXQlN+0O2VOQFDMcqbcbdM3Iq6hSUN5p+5R79TGzb1o8uxs
	7Sz75h+/HdxaJ8LJaAF9kzD24SSx43c=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YENt6LTm;
	spf=pass (imf03.hostedemail.com: domain of leon@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755097644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ySXGLynnR++p6RuXca+nTN6nGsk03DV3QSK1ER01nvY=;
	b=dPM8ax2xpITeZsPXWvbIWETWMQBwLX1BAu7tveTybBkcsKL1BMFXSXuJSA0kmJIBCJN1Au
	49EO5X3UrNRdHooP3o4aPcjrH3TFJ2iYXDCECMuvmHuI103LAYmex5ZjPNNjvt94OV61zV
	njIOh26mQ6g0Svdm2mLefUdqleFqabc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F0C06112D;
	Wed, 13 Aug 2025 15:07:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B711C4CEF1;
	Wed, 13 Aug 2025 15:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755097642;
	bh=AgCFVr8B6NzxkSuzvPEJMB9AhjM0iYqJptnGya/8rdo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YENt6LTmzTF5MtD2CCE/V13VNj4PuphZirCcbsVboFbdWpo5pbDoM+O1RwGND9hHA
	 WetmjCRKzL7pVzJCuB6ANhgpmI5NnCbOUKiA98JWJtIXOH8N50EVLmuQyuay6zm6ky
	 Onvhe46hQosw9HCamdkdEFdjBFc8sAKkHOvcvhEwHpJ12ST8cc+74GQ77yCDPQN8yP
	 6Wv7nBFsNIocmJw6FI3A2Sw+oIhMT6YNdwdLIq5MhleD6VLBx07CKPNCPkvEmssek+
	 ZjeG2ZowZ0nIKyT2jMky93WoiZsWFLORbU579a0ityJsLq0oaeKqLOOi+Bq4oEc02a
	 vNc66YhlSs8qQ==
Date: Wed, 13 Aug 2025 18:07:18 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, Keith Busch <kbusch@kernel.org>,
	linux-block@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-trace-kernel@vger.kernel.org,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, rust-for-linux@vger.kernel.org,
	Sagi Grimberg <sagi@grimberg.me>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	xen-devel@lists.xenproject.org
Subject: Re: [PATCH v1 08/16] kmsan: convert kmsan_handle_dma to use physical
 addresses
Message-ID: <20250813150718.GB310013@unreal>
References: <cover.1754292567.git.leon@kernel.org>
 <5b40377b621e49ff4107fa10646c828ccc94e53e.1754292567.git.leon@kernel.org>
 <20250807122115.GH184255@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250807122115.GH184255@nvidia.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 00F5A2000A
X-Stat-Signature: amwz1q6gjhimc7bxjr695wh1p3dr48mx
X-Rspam-User: 
X-HE-Tag: 1755097643-819007
X-HE-Meta: U2FsdGVkX18lFVjvVkL6FxGSZnaMr9wxH7h5ecLCSJQbNhKRhr6iMv+dxF2YgLhtFKHKNzhsp+P1Vothzus73tgOW/t3qkpSca+aW1IR68Pd/n2t/9owRVf5a9gDEUMkUSR5q1EvmHqqxZXfNfVDLyxju8Lf2vjzPvRtfrNMih4zMfCvY+HPWwXcV+NJrnG+rbKLsE5HO1FvBcPrpWw/V2uV7QZE5lgML5n7q7ebFEQnj4XGDZL06xW1/HXxdxeRDQYCRuOLKy67uLrMuls1bxxuIzdUvS9EkSlitKxB6PQHTWaQkWMHeGcJcfga4Bdrnfv4QXnrTqMRIRsJR9+vHT706qk2ceOBfeNUixOf4r6jE0lFNrqGmvOaEHRwI/zSU6PhZA6F4QfXb3ade9P/Y69ocfolZzqAljkgcWhQCm+sQATp9clZg9M5B1rLLCX8WBpMoKTGBf0+jesLkFxPXTfXkzWPVkWX9tXx42vqTJelndywPUOCsxieR7ca5k1smKdMonCmRro8F8bvo/2219E/F3/noxL91Qr15ikhUalCgqV6DwT1e/L3OOHVtV5QAo/P9XvnsVi/7PAZ1crhEzTusluEIu9fMV3ceXmUjp6UyeY/pyhZiM3C9h3+NsAXEoYj8V60ItWNvjykFgqhl8wf/1P1Gr4Abjs8UVGIcJkAS3lGBe9sBS9R7U38l6pkJZzTO0G8oblMxDberRz/j7OwzW6oVxHpQeluBe6kOCMlmJC8tyxv/oVZV16pFngQTsdVEemJU82wKNPMMN/hgcoai9whzIskoV93gOG/+TZeRC+sXFMcyJ+aaHfTgWOGSCwFw8Or7nMDketyJ0sSCbzJDrqKDrMHdSEUzEl+J1lbbtCKn2lZOvK7kpVnnPxoS6uuIfBJn81nDLGtzF6w4XvsMMJLR3qe2LRS9Y6kcTpbNjPPHvgcfQPWuPNMXDWI41V2pSgmLPFur2yKfY+
 RqzakjL0
 UKNDomfpSIY9l2BPxYS05h94pJQNi1MHh+QwJsGvjnZ0AiXAfDz6NiYI4euZDMlmdGS7LS5ze1OhAaTY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 07, 2025 at 09:21:15AM -0300, Jason Gunthorpe wrote:
> On Mon, Aug 04, 2025 at 03:42:42PM +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > Convert the KMSAN DMA handling function from page-based to physical
> > address-based interface.
> > 
> > The refactoring renames kmsan_handle_dma() parameters from accepting
> > (struct page *page, size_t offset, size_t size) to (phys_addr_t phys,
> > size_t size). A PFN_VALID check is added to prevent KMSAN operations
> > on non-page memory, preventing from non struct page backed address,
> > 
> > As part of this change, support for highmem addresses is implemented
> > using kmap_local_page() to handle both lowmem and highmem regions
> > properly. All callers throughout the codebase are updated to use the
> > new phys_addr_t based interface.
> 
> Use the function Matthew pointed at kmap_local_pfn()
> 
> Maybe introduce the kmap_local_phys() he suggested too.

At this point it gives nothing.

> 
> >  /* Helper function to handle DMA data transfers. */
> > -void kmsan_handle_dma(struct page *page, size_t offset, size_t size,
> > +void kmsan_handle_dma(phys_addr_t phys, size_t size,
> >  		      enum dma_data_direction dir)
> >  {
> >  	u64 page_offset, to_go, addr;
> > +	struct page *page;
> > +	void *kaddr;
> >  
> > -	if (PageHighMem(page))
> > +	if (!pfn_valid(PHYS_PFN(phys)))
> >  		return;
> 
> Not needed, the caller must pass in a phys that is kmap
> compatible. Maybe just leave a comment. FWIW today this is also not
> checking for P2P or DEVICE non-kmap struct pages either, so it should
> be fine without checks.

It is not true as we will call to kmsan_handle_dma() unconditionally in
dma_map_phys(). The reason to it is that kmsan_handle_dma() is guarded
with debug kconfig options and cost of pfn_valid() can be accommodated
in that case. It gives more clean DMA code.

   155 dma_addr_t dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
   156                 enum dma_data_direction dir, unsigned long attrs)
   157 {
   <...>
   187
   188         kmsan_handle_dma(phys, size, dir);
   189         trace_dma_map_phys(dev, phys, addr, size, dir, attrs);
   190         debug_dma_map_phys(dev, phys, size, dir, addr, attrs);
   191
   192         return addr;
   193 }
   194 EXPORT_SYMBOL_GPL(dma_map_phys);

So let's keep this patch as is.

Thanks

