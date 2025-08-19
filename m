Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A80CA0EE6
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 19:58:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA7406B0131; Tue, 19 Aug 2025 15:58:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7F106B0132; Tue, 19 Aug 2025 15:58:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D95186B0133; Tue, 19 Aug 2025 15:58:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C68246B0131
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 15:58:29 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 35060827AD
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 19:58:29 +0000 (UTC)
X-FDA: 83794569138.06.00A6796
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7BF1A140003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 19:58:27 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z3cV0Sxj;
	spf=pass (imf09.hostedemail.com: domain of kbusch@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755633507;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vouc/RnOn1OR1o/ff5mjM7Yg2TfneybwsfyI/BiiIXk=;
	b=z0fSjJeNXMdYxxHrWr5eu8bhWKJg87CIYq7onRgX0K6GVaD8PeovNa5/SYp7eyZtFvIp0l
	WIOy94hHMjwGVDz022wBC/J7uefXFz4z58ObMBW0V0PLoqgMmGzZSSkji+2Ipz2RFF6ulC
	JXGx2e5Esj+qVXxOLlmtXQLKuHs/0js=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z3cV0Sxj;
	spf=pass (imf09.hostedemail.com: domain of kbusch@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755633507; a=rsa-sha256;
	cv=none;
	b=3CgKncTBV/QZatRwPlnV5L0ZueGztZBGy2xwPVWQU8l5QJ0hpiwtjnJtalHi0VUaqRIgcl
	h2OZqhZSJJUJCHL9zwy3UXoq300OsvcfIEUnB6IvqHto3k57Mb1EEgk5D02muV5J5+Uv0+
	IHLtWqIuoSTDbQzEFTbT7L8AuCKzJQg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DCD345455;
	Tue, 19 Aug 2025 19:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D9EC4CEF1;
	Tue, 19 Aug 2025 19:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755633506;
	bh=nA9A0H3LrJ78fHP6AI7J40nKWuK6fskQEP9rQ9tJOXc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z3cV0SxjdjsbyAxLQAHXL9YQoVkd3oE/w0tg8f+/28wYPFIcCuOtf+n31sKJ+LyN1
	 6N7biz9o/yCuPtFBnn8ELyTNlP5RA151eN7wKi8pNSNB92o83ezmb7znz1ImNM7cWr
	 xClDJ2+EAIi/fyYTQNzUsM/2eAKArOgzFRoBwUKtf83SqZF5p6itYTMDZFBizPzyOj
	 cmndtkVjtFJFxZFPGtELV1/fpgrqmBEwX35+EsRatiowr0CXr7OcQuw39qyPoRCSeg
	 uQXDSW9Z/GPeI4IjUnpByoqXUrISGom24QKuNeZMIoK+/Modr6dLR2faOTSocU7qPz
	 FiaHtir3WFZ4Q==
Date: Tue, 19 Aug 2025 13:58:22 -0600
From: Keith Busch <kbusch@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	iommu@lists.linux.dev, Jason Wang <jasowang@redhat.com>,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	Jonathan Corbet <corbet@lwn.net>, Juergen Gross <jgross@suse.com>,
	kasan-dev@googlegroups.com, linux-block@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-nvme@lists.infradead.org,
	linuxppc-dev@lists.ozlabs.org, linux-trace-kernel@vger.kernel.org,
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
Subject: Re: [PATCH v4 16/16] nvme-pci: unmap MMIO pages with appropriate
 interface
Message-ID: <aKTXXv7kE0pGGn_8@kbusch-mbp>
References: <cover.1755624249.git.leon@kernel.org>
 <545fffb8c364f36102919a5a1d57137731409f3c.1755624249.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <545fffb8c364f36102919a5a1d57137731409f3c.1755624249.git.leon@kernel.org>
X-Rspamd-Queue-Id: 7BF1A140003
X-Rspam-User: 
X-Stat-Signature: 3gbjqy7hab1kfsh6d117q815u8oywfxx
X-Rspamd-Server: rspam09
X-HE-Tag: 1755633507-60691
X-HE-Meta: U2FsdGVkX191N8+xt1z2f3g21Rd2McGes7lacERAisrvl/mVi4LXlGYv6JDGN1XaNSzaUp5FRkDKPsDXPxxLtfi2anRdgDhtDVw0gHAgMH7+29NT6tGarWhz07X8wMYsoVTTm6hNUtmaQrU0LW2cUjIKDKlwIQOno9+7acyI9FtvntUlnKt/aDvEwjY1yI2KM/3kvNaZrCWcAr3jCG/XJDb2/dt0Sjvj8qfC9YQtKA2NtpOgVDVSzPyM+HfqJqRGwc/MXVIkOGYqoHoYwVWiZzFHNpAp/wDjuTWb6hZPTxGzPnPLBX29YYqU8FhHMflSy6sa8+8wkxPd6MdZRrUcLrZuaOJakPfIdNuHkwm0Sxmg94Z1Z4lvY+OukDjsc+vCG0RdIhmtLtORG6KdCxIA9CD+GKeaERTT0u038oGg88oGjuLAcVU2hmRycMBGp5sBYmZH1j8yUFNAiS84m12k8fSgLOHI2gHt7/qkiPa3iPrwfgXBIkds15JTvPmZakKia7QQSEe/AwxREjr7DOgzgAQ8Z2xz+6594zLW5RSJilwQd0pILmaajvCvhdhg/M2vZi4v7L4327/4I2O6qFVtKJGG+LW4AZvmfZTiZjh0QpHmILqvPcqn+nkfraI6IfaIgQFSzXmZJBf/H1sQWJCfGnWhDr+a6xeGlNhjZh4b+7scJieD3IIhqoBd3hMQVT0ltYE3mECTcJO1PRUqOsRC+wqeEc+jKBb81ubGn4L1RFdnUo3sHSqz0+v9mdK2kMz5D9qWC1hnImfTgVu6sKuDRKyo8HtWZTTVMN6iiKZqPbTZQCeZh32PP4m0DhbeAk6Aw9qLntBSgVjhYFKlgonWW4gAG51fUMI0W7JZxfUYqx2AqilTYFmspnGNzcnpABIcFRlBnQUPzcAsO1wgyxaOoR9MAFcnIN96Bt45ENW0I6EirqMIRQWCHHLJc1MsrUr0UhpGqqV1AKiMrQMro1p
 lvkxTTGt
 h67w1GGTdpWc3hUE5aR9QfZ0ESdptAbkVmpLb1AFZTE/x2IsX8CP7SRW5sClPyuy13BWjBsr0+X/yEUJTk+TTIUz/OpNRf98e3zDHvUyjASSyRlaBSUO+NgXPGpaOt9AmulsBP9Z3re+OsQToFntB/6c1l8kWK8sHC8teeel/Fl6MIhLqw5yqXARbgBoSBhPe5pgeKu03m5vYaLudRKodLf1Q16ljAUoiKtB091O40dnWPGUnWH1WGt7Ed6KkGT9ZaBqLvbxl/zIHQ53JXhWe+nzwpMX3FckS+HCJ/0YEayjbIHh/KNroC4n1zTPW95+g4CMRhLPQ4iuMexdorCjDER0pTjeoZQ+WQOMHExkRXHHGsiXmskDuiKnLXQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 08:37:00PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Block layer maps MMIO memory through dma_map_phys() interface
> with help of DMA_ATTR_MMIO attribute. There is a need to unmap
> that memory with the appropriate unmap function, something which
> wasn't possible before adding new REQ attribute to block layer in
> previous patch.

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>

