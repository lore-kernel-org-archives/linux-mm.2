Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74B9FCAC5A5
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 00:47:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BDB68E0002; Sat, 20 Sep 2025 20:47:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947598E0001; Sat, 20 Sep 2025 20:47:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80F108E0002; Sat, 20 Sep 2025 20:47:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6BB438E0001
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 20:47:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9CF1B74CE
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 00:47:34 +0000 (UTC)
X-FDA: 83911419228.17.3ABC5EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 40D2B4000C
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 00:47:33 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fLUxwzDv;
	spf=pass (imf17.hostedemail.com: domain of kbusch@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758415653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xtIvv4lw44pUlJuaLKbzEHjJi6xJvnBBYTGn1zOuzT8=;
	b=dqsHtdTUVzOit411wAKRTRKmNqgHTytb7EGQTfYZ+B73/KzHrsduVEk6qETLgYEhtK27Eb
	N6TIp8YkqlKxFMFdZLqn2C82xNfRhOV0GVfQqHAZ/QAtHqgsfIJQm+r2GmEGtw2s/LWgQi
	AnHZmDYEgGX5BbxF7WBUvmybsEl9KuI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758415653; a=rsa-sha256;
	cv=none;
	b=b/J4avrSHxxqgAzEfiu9vQWOK/ZpCIeIOPCcdQA3XtFbkXjj73BxIcGaMJed6NHGu3w8Q5
	yHkjBHQrTnOZ8G0vHzRfaBEDJVV4+/YJni9SVuEQfqm4oMhjn+CMRSXs8aFZ/ViApjwUNs
	Rrwf/HD7Vo9gDUBq+JKqEtryHYS0Vs4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fLUxwzDv;
	spf=pass (imf17.hostedemail.com: domain of kbusch@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 70099600AC;
	Sun, 21 Sep 2025 00:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F266C4CEEB;
	Sun, 21 Sep 2025 00:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758415652;
	bh=aFgKZNQUQCaJ2vrroedLHD+DNPOlwj6GGUlnWjzhG5w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fLUxwzDvBQpVLTwxkVcEMGkM0isY6OG/nLB20SsNVXIRKxxZrAbNIPP/lH+JLvuUn
	 Kib9NA0Qx8ucaR4Lud4LpP66fHzAfy4YMg/WGXGCNSBD/snmzPLJ/GJr5uZM4GRPA4
	 FmPuCrywKU63yNMwT+i1LUerAAz4LYMUpnupPis0tcH13QBvBt9TCQlrhzdIw9AGje
	 8PZjHxaN7jKNeL5CBfGmMNjS4nLwafvguDKC8M88c1TuvUDa7uTmWsQUU6EjD9ZRCh
	 q7PhsUzYYnzKkPRC+D+A2gtlVl3c6gXMUqXDS+5w81SLBHHJjwyUZmv9q7TG8Bge2K
	 OMtCSqZskSdHw==
Date: Sat, 20 Sep 2025 18:47:27 -0600
From: Keith Busch <kbusch@kernel.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Abdiel Janulgue <abdiel.janulgue@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, Danilo Krummrich <dakr@kernel.org>,
	David Hildenbrand <david@redhat.com>, iommu@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>,
	Juergen Gross <jgross@suse.com>, kasan-dev@googlegroups.com,
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
Subject: Re: [PATCH v6 00/16] dma-mapping: migrate to physical address-based
 API
Message-ID: <aM9LH6WSeOPGeleY@kbusch-mbp>
References: <CGME20250909132821eucas1p1051ce9e0270ddbf520e105c913fa8db6@eucas1p1.samsung.com>
 <cover.1757423202.git.leonro@nvidia.com>
 <0db9bce5-40df-4cf5-85ab-f032c67d5c71@samsung.com>
 <20250912090327.GU341237@unreal>
 <aM1_9cS_LGl4GFC5@kbusch-mbp>
 <20250920155352.GH10800@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250920155352.GH10800@unreal>
X-Stat-Signature: mcq5oia1n9jh7q94scofnf3jmu7i8nt1
X-Rspamd-Queue-Id: 40D2B4000C
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758415653-724939
X-HE-Meta: U2FsdGVkX1+0dsstKkq+IA+P/i9728YIsrKIUA5OzLgixCGHV6ajy8qYmcNZVb115pNUJiZGWSmlYx+avd8jtrrK2ASb64+NUmIlhdKQsFM2jsffgM+agHKAABz+IOQdfpRpf/kYxW9vKeW3Us+7pw5OyEgLOviTEbhfXPm+V5SNaEpS/QkAhWdXFETTmj/Kg7AFAmVfPCQgfmJ01h0RbB+Sm+ZdR/wiYwlpYKmWXV/lBhjfG9P0a6MA+yzscIIunrR3p1BwIEaQXSCVHRREx+3aRsy+eM2ZZnFT+oDqoYKs4ZPe+FocYn6J8t4+4lS8wMx70fLpYS7oVF2RlsNf5rjGL6hDCo4alvsuzOAsMc/up+3OOIf5pvYcDQykreVxGzoymZ60BseBSR1VlLyXfqIQtLgy8ROmm174SDdkkyBO3MRO3+KDyDJlEwA9u5EbfBfoHo4xtBhTOzHVnbgnZFR0/Lc8f3WvPuXQPGZh+hsnKtOXXtH/xSdGzBwMFlwBWWUV6D2IRCQ11nnD0iQAQUi5u4ZrkDTFdqpRbam04RnGd7hAAGisnvVM8uH9SOmQCb57ePHXQxHdisEqEqVCGzBTAon/FJ3kVOLzp5qmARpgGle9fCLywmVAvdVzHBLLHzeHPap29jIRptj+2lYUedlw/chldTvXlEQijBi/LCcSUKMhDed64/3ii5ksrcSU4fPB8xqfKonX+pyIe1mFGHYjkr5Bh6Q4HBW7OGGmToxqPlhSc0DDa6EiKi+F41nlUfq8I3GZNnvk6bHkX3bFXZ66ueTiXcKpvOiqxej8vtkUV5rTe6WrYcI0bihvVsf92xk2jWfafpvg1eLl5caYJ1ff8yYIWvV194/sDynQAUr8713pzHYM0GqyEyKtkfJLZcj7g+x8qeBmmaKrCIWlOizFJTYgOAzXnra2tukv4y3XiLVtSFAao2ltklqiwzZqGZ3g0EBvt94MfURkG9+
 BN/Yb9bV
 TurEwOerk9SExlJrdGPDlTb+NhVd2Rf9J0Hgw0HNLJnRC3jXNCSkhO3hZzMFGMsxiB8qXa7r64zjneXp+mYxpp8osimO1ScMkdBA3Wx9d3/VhehPBPANuQlFCgaAIZPCvkuvRO/fpGFjJBOzsjsRVaVgq5eyjKs6xCspETr/RbOLnUUcQdwiY4zE0vid4+UUpYpRwaN06wjgkccEfan5+Bg0Ll18FqKuh0DevUuTXZyLdjV1vpAs9d7drbA/NmtmpjMUlNNdqeH0g0/AtYZ7GkvboeSS1VZf0OLzU8Ve0V3Ft+ohxz/dJTCM/Dohnd4aqmZew
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 20, 2025 at 06:53:52PM +0300, Leon Romanovsky wrote:
> On Fri, Sep 19, 2025 at 10:08:21AM -0600, Keith Busch wrote:
> > On Fri, Sep 12, 2025 at 12:03:27PM +0300, Leon Romanovsky wrote:
> > > On Fri, Sep 12, 2025 at 12:25:38AM +0200, Marek Szyprowski wrote:
> > > > >
> > > > > This series does the core code and modern flows. A followup series
> > > > > will give the same treatment to the legacy dma_ops implementation.
> > > > 
> > > > Applied patches 1-13 into dma-mapping-for-next branch. Let's check if it 
> > > > works fine in linux-next.
> > > 
> > > Thanks a lot.
> > 
> > Just fyi, when dma debug is enabled, we're seeing this new warning
> > below. I have not had a chance to look into it yet, so I'm just
> > reporting the observation.
> 
> Did you apply all patches or only Marek's branch?
> I don't get this warning when I run my NVMe tests on current dmabuf-vfio branch.

This was the snapshot of linux-next from the 20250918 tag. It doesn't
have the full patchset applied.

One other thing to note, this was runing on arm64 platform using smmu
configured with 64k pages. If your iommu granule is 4k instead, we
wouldn't use the blk_dma_map_direct path.

