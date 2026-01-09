Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEB52D1A63C
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 15:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 302D16B0088; Fri,  9 Jan 2026 10:03:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AF136B0089; Fri,  9 Jan 2026 10:03:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC466B008A; Fri,  9 Jan 2026 10:03:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E15E6B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 10:03:47 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C1767160134
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:03:46 +0000 (UTC)
X-FDA: 84312744852.15.560E1A3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 30DDBA0008
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 15:03:45 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SE4DXA4M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767971025; a=rsa-sha256;
	cv=none;
	b=IBLJ+NEF1YnMZSnHzNQoSX4co8J3RaE4NXA5BW6n5GsPlCxH7GU+GU1Q0EA+ZEAKpUpxhr
	VxfCIHgjcW4iwi05UzEQe/dM9VNYI11TIFcd0XLdZFrPENNKL4PGE1qxuDpYf5BPyf9ZwR
	8C4jldDMNpaE4qmpxdGrS2Fj4xJbM9o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SE4DXA4M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of helgaas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=helgaas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767971025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=N995FToeNi5XPxdDB7HyMTCG9fgYlsEvICbTLmRQ/LE=;
	b=ra/ocXlqVCwNqdTT8JmapoaInHgheleOaSsMfCsNSLn0ilow1sIYNqxN2ZOeuw7msgaISx
	jTE2ROhIJ7ZYfyi2UajQikYbE/9LUXwG+QBieYGe9bQU4sYCm0OI3gqQe3wFFfADIw2vYm
	mpZbhDELFrY0V0OXLyZ+gK0OXYHzzxk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2988D43DDD;
	Fri,  9 Jan 2026 15:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD764C4CEF1;
	Fri,  9 Jan 2026 15:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767971024;
	bh=WAuchXVNbi1E8wL1YCiS1onMwk8fVlA590vyUaYKxYo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:From;
	b=SE4DXA4MOciW8xfdJXBrN01CZqLwFW5mbrXNqOB717rS3DPhir3IKMAYUPUlfNCNG
	 oSrp086ZYAXSL92LzUrIGHD4hAMVrqHne4K/V4honA0Sdc4MqOJ8m/SnSRKVmJ0nGi
	 yGsgXO5bbNoYRyAMxPGH75OGylwqPrB+zIruHZWk3i7kqFtCvAPPS+qiHfd/83dKyO
	 2bHw1C4FufwAKVvlPtucN+I0YXw1NbI79//5/k6RUspiS6PykxjoXoOCJpJXiC1s8e
	 7hOlLlnIwjuXvIvuSS1dFMQOPoSDlmkrIkQ3PQlSDmp5lxci8og+C55Pk+FojGBUfa
	 zkKk4VDitU6fw==
Date: Fri, 9 Jan 2026 09:03:42 -0600
From: Bjorn Helgaas <helgaas@kernel.org>
To: Alistair Popple <apopple@nvidia.com>
Cc: Hou Tao <houtao@huaweicloud.com>, linux-kernel@vger.kernel.org,
	linux-pci@vger.kernel.org, linux-mm@kvack.org,
	linux-nvme@lists.infradead.org, Bjorn Helgaas <bhelgaas@google.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>, "Rafael J . Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
	houtao1@huawei.com
Subject: Re: [PATCH 01/13] PCI/P2PDMA: Release the per-cpu ref of pgmap when
 vm_insert_page() fails
Message-ID: <20260109150342.GA544448@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vrti6maahtwfrd6xrdmyupunprioodhl7x5alpi2r6kyi4qcyr@ga6a5yrdvmb2>
X-Rspamd-Queue-Id: 30DDBA0008
X-Rspamd-Server: rspam06
X-Stat-Signature: 5nr4aqzwzefkp31tp8k458y8egpajrng
X-Rspam-User: 
X-HE-Tag: 1767971025-840818
X-HE-Meta: U2FsdGVkX1/SuzUS00B/P7WxYM7O8lAAVCF/r+E044MHPrbF1X3pg7WpvNxJCYEkj24hdKAlrs+Ax8b6xSsufPHfvbv7qNGjgRc5ad3jCminhdbIQ3fkBqS3qzv/x5fevp9P1y9aILKvdgBi/X2cndYjxWBE36whwlnnlsYBAPUHGN1RyKQhBXkUTwNZsfCRn6koUx5ChK3UAyTaDeLnZ3OctOX2tgNwIl3EGzD0pCHdtsXP0OG3ZN0QE9mpoUeyYqfA38GhL7l06EnM3hOgK0g3gGOFPniHIGls3wvVtuzrX6ehCUg2lXA1eri1GjOvATTUswmGTPfXOzD1v5SBwb2P1zR1vc/guMvjYjIxQBYHQJWa9bLDBR+FTt9UqR+w1l5LSgAD4jYE91nuUBPwpkxVcD/Z1c6CVyWzGVOhRNEB05ROon+qsBzFgL3YRO7aeWMe1prgb2RH6TKHoe7kRchmmZ932+HN8/SXtitS4n78xI6ZkEu/53mF+n4xJNOgv+1JNG7qeiy1dgPRWfTU3wY4DVFgkKox7OsqkIzEfh6K2XtoPEQgS7u0DhWGHlS3+UyXNzKzKcstDnjOjx2jVCeyVFr112RYD0EjCOpPL24GHu6eNP8CrboGGyVj+MrnGR2fqS6g0c89BmjPOdS42on0gw2WfZNgUyA0tbicYHGjqPTrQx+/rxpK/RHZD6GCTEK3Hu5lpNSgS/4lbdRQ6MdnQfvx8Z9YC72Z7UXtydFdOIB3u9G87Hi6EP17rR/IuZgPbGCbGUdd2ZtOdZwqnF4a3F/opk44PjGVcyFmIV8c51THiL2jtJwKHIodtjvHbLK7KImZrUbbtpWp8l0oucu12dgDqL2QQw65jS7+GdPMdh2NzzhrJaHWE7S9RPmFz3TciNdC8VpPfOSNkxOj0+qjdDpBZEiTI3Oh9Ys+iIdLzFv132eXsNLDWtbkpccu7ife4RHbr+DL1x6Kp4v
 bEdf5jNp
 yDX2WohnWGLKjFCh1hlI4jsrXSxHQPvsdj2mqk16uz9LdliCuC90c+BYh3i8oYKkb0jzQGba080WNNpSMHo68mGmooHNmdACEmHLSFtFeCRgXn8sTcBrg+dZWxT1F1Opom58MCLZrYNw5ro9ouv3rnDNnkDZRbEBNS9VtyJKtbUFqGC88eoZ/1pHiAE8e6htg3/JtJAUOn9+gJtoxEl/sWluYvJfxPWSGWc3Fe4tYqp/o0pF8MtYQWCIC12ayRKsOPSgGUeRyBNXeDx5bbSL/2AUKgezbtg9P2pquDAw+LV3HqyOSvrHqehsHVTqC2MDSgSoUY2qkkn1oKe9H5CXZnMcXX4yYw5UdD9qJXohjfFDbW4GxVnrt7a+NxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 11:41:51AM +1100, Alistair Popple wrote:
> On 2026-01-09 at 02:55 +1100, Bjorn Helgaas <helgaas@kernel.org> wrote...
> > On Thu, Jan 08, 2026 at 02:23:16PM +1100, Alistair Popple wrote:
> > > On 2025-12-20 at 15:04 +1100, Hou Tao <houtao@huaweicloud.com> wrote...
> > > > From: Hou Tao <houtao1@huawei.com>
> > > > 
> > > > When vm_insert_page() fails in p2pmem_alloc_mmap(), p2pmem_alloc_mmap()
> > > > doesn't invoke percpu_ref_put() to free the per-cpu ref of pgmap
> > > > acquired after gen_pool_alloc_owner(), and memunmap_pages() will hang
> > > > forever when trying to remove the PCIe device.
> > > > 
> > > > Fix it by adding the missed percpu_ref_put().
> ...

> > Looking at this again, I'm confused about why in the normal, non-error
> > case, we do the percpu_ref_tryget_live_rcu(ref), followed by another
> > percpu_ref_get(ref) for each page, followed by just a single
> > percpu_ref_put() at the exit.
> > 
> > So we do ref_get() "1 + number of pages" times but we only do a single
> > ref_put().  Is there a loop of ref_put() for each page elsewhere?
> 
> Right, the per-page ref_put() happens when the page is freed (ie. the struct
> page refcount drops to zero) - in this case free_zone_device_folio() will call
> p2pdma_folio_free() which has the corresponding percpu_ref_put().

I don't see anything that looks like a loop to call ref_put() for each
page in free_zone_device_folio() or in p2pdma_folio_free(), but this
is all completely out of my range, so I'll take your word for it :)  

Bjorn

