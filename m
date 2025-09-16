Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ABE0CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 14:34:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 501E68E0003; Tue, 16 Sep 2025 10:34:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B2798E0002; Tue, 16 Sep 2025 10:34:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3EF298E0003; Tue, 16 Sep 2025 10:34:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 24C928E0002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:34:22 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 971F614013B
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:34:21 +0000 (UTC)
X-FDA: 83895358722.08.372D3D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E1A7FA0011
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:34:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QYE8Efn+;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758033260;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lP+hEXGVxPwkOMM7p2V+b+lQoPvNSqOTwc7tNn5pKYI=;
	b=C2B9n3LQWSxHTJU6m+J/s6CNAnCnVUCZDhVa5s9E7jx1+K7d8BmM7zM0NYYjWjswtcG9p+
	51F9QqDf8eOB9hnRUoW1Mp+dzs6V4SXyqNJro6fTnR5LYtiuoKZBtsOxZ82qyWDxGx1KAC
	Fy5gGjsGYs0Rn+mAitvrYBa8LE0Kzs0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QYE8Efn+;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758033260; a=rsa-sha256;
	cv=none;
	b=ZO82tPA9geDswZyCe7Pf8i7+wTTZU4kBI+dP1X96kroMf1TdDXTeSbHFU2l/Tc+YYRe3P4
	W7qVAidxAtghUTEB5P4YE+q2+MRf6qs84n48SbyiJZl5ZKNKvNQcBepesOX2tY+FNMTJ66
	B8bQtK0irTrlXn5SVXbpiuNgCIrhnT8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8EE2F44964;
	Tue, 16 Sep 2025 14:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF58C4AF09;
	Tue, 16 Sep 2025 14:34:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758033258;
	bh=3MH7gD+Tsr6/+WWbc5XNbhhMDRlAVwAmSiICzgleW9A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QYE8Efn+Rtz49VyeXFT+OA9QWcbqM6ZXeDrJnDya8oYEdZbQzubfb9N/1S8hoNNCX
	 gp9rau+XytOIg1+un9Mguc/q1TX8w4O/yPllotB9qGt5PXIOpqIXJjaVFVSKy5T/Js
	 hRokgc0yIP2bQL9tlVDvbUDm6WUC6w22W6TJv3jNOc6eznzrEo36jFDnLYTKiXnvCx
	 gsRzOcL5ehCcUdEQDnpGsSGqwV9EdD+BaSUTy2xuxwEU8JRJutD7k2bDjreQ6HIXdT
	 utIlA1mGCdnleTYeWeuuFajS3OxCIufVPpSy4JBfMgNdWXy+4bXnz5Gk7otR7W0T7n
	 ym5FukQVNHB5w==
Date: Tue, 16 Sep 2025 17:34:10 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Pratyush Yadav <me@yadavpratyush.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>, Chris Li <chrisl@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] kho: add support for preserving vmalloc
 allocations
Message-ID: <aMl1Yj7_iw1kCU2D@kernel.org>
References: <20250908103528.2179934-1-rppt@kernel.org>
 <20250908103528.2179934-2-rppt@kernel.org>
 <mafs0ldmon784.fsf@kernel.org>
 <mafs0ldmnlmq0.fsf@yadavpratyush.com>
 <aMgey9qEC_XUejXm@kernel.org>
 <20250915144335.GL1024672@nvidia.com>
 <aMhAiR6qnXMA-c8r@kernel.org>
 <20250916130516.GB1086830@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916130516.GB1086830@nvidia.com>
X-Rspamd-Queue-Id: E1A7FA0011
X-Rspamd-Server: rspam05
X-Stat-Signature: kobr64s7g1jy8wdicx69tin5faypuxgh
X-Rspam-User: 
X-HE-Tag: 1758033259-595720
X-HE-Meta: U2FsdGVkX1/iuCqVp5sy/5FJ32H5iZ4LX702JRWqAbqf5UP4IHeD3iTx8H97R0Z0b9YgOVrn8aZ0kuV9JvrcyXNxe2c9KB04mbiAvK4RrnTk6j8wUFiPsEDc7rqWlhT5YQBG4+RS+qlEdTGDvTrQJ4/7PQ8awmGliVVguGETXmWwIZSUDBIzcgH4YJZ9osYpXu3aiDmftuQevlyl9ZuzfF2C+fgQQR3oC1kfAV9zLdp5F7Zl48QkVWDsO9lJn/Qa99vHBrwWlmMTA3PAs7cBl+G5ZQYrzInWyxVf+V0kMF8p9p4hW/flyxFOME+vJpNDkyiOEhh2htjiRmRMgDTCttYjeQW2cjVrDG3Zc140cuJ8mkrJeoBxoD5oNpauAk2+cK8ek5axovnuGLOuujGwSCj849ozF7MSTg3SHat4P6yYqzDt0A+UqqQmJJGLBu/z7omcpu95/bDDNrQxY8Q30IFmqhPSGrDSe4YjnTbLEeJFHqH+nKrcIByUgAVZxtxLVDhwlA2J1SH0skoQV9WEeO3Cs2DvgwZaSqkE8YDCVFQehfXIVYOteA0K/2nxW9CFhPC/AQCC+3fGD/bwdjuUc2DvMCrnCEJgJg8hWAx4rN5L4ZfusLfkp2V9dbeHVe/hjqRn37F01k4Ipw+lyAKMidNZcm1gHGwijcukXb7bckl6qMxwUg8n2vgKyO8cKjpIiPggisndSmyJrQR36hLCW18XwHYDJ2PPMFfUVwZJc7lrIfKAum/HjO3Q0QSm7Dce/agmK/Zx2SaG4IAtdof35gbX3cuLVSf5mhKqaaV0jS26vdotzLMfDJlsdHMUi5Hf2bpkQiYaZEsNijYP9SOM8ExiIltR6VvZmiMX7fbPrh0tDvvafbOtiAR3ZyOVGwXJk2RkhKysRFZtyxdy/wat5Oc/IARBaGjSvv8uxKCmg5EMCStjNtBeWqX+YTWLAjbiqQvvju5qnZtFpGsO01b
 F9dc25mL
 OSaDWbkPn5STZ28Rj2dofNx8/OyeMjksxjJzbtSXUZWu8MbgQ836qtd34aw6U06DIWx/0ZcW/zqyFL7kGca++vretRFcbpXzixf+xluxv/CoWQUHjwETiTcKfDoLqSRGczOcXwp/dq3dVcJQ+FQxkGmzycgAfWaduJHH5Oy7wKyGa6pt8DyoNwtCxuIwYApyRPj3o3GkYrYVGQinDIMggAGBIu5GL+vtj4jhc/IO/tzTtWrD8gxjE9P0gvAeFYxLsljqOsYpiVP7bi7Sdxy/956Uing==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 10:05:16AM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 15, 2025 at 07:36:25PM +0300, Mike Rapoport wrote:
> > > Under the covers it all uses the generic folio based code we already
> > > have, but we should have appropriate wrappers around that code that
> > > make clear these patterns.
> > 
> > Right, but that does not mean that vmalloc preserve/restore should use the
> > public KHO APIs and avoid using internal methods.
> 
> I think it does, the same way vmalloc is layered on top of the buddy
> allocator. Why wouldn't you build things in clean understandable
> layers like this?

Here it's more like __vmalloc_node_range_noprof() and get_vm_area() calling
__get_vm_area()
 
> Jason

-- 
Sincerely yours,
Mike.

