Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F7A4606A33F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=Vg+9YLcY
Received: by kanga.kvack.org (Postfix)
	id 53EC76B05B8; Mon, 23 Nov 2026 10:21:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 516A26B05BA; Mon, 23 Nov 2026 10:21:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 453196B05BB; Mon, 23 Nov 2026 10:21:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2952C6B05B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:21:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1555807D5
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:21:08 +0000 (UTC)
X-FDA: 85466747016.02.C745FB0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf31.hostedemail.com (Postfix) with ESMTP id 660132000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:21:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Vg+9YLcY;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795447267;
	b=7O0QMBCaSvCUF6fGH4w7f0BPdk2YBdCAhtrcnomtlWmNyPk/AQeJOfOJVBZDVVKjIporYE
	mm5rSOvp8VAl87iF4q5V4OBT4P/1rn6LubcEeKAjISuIVnIWeOdKT/6Bx0lXBXoTvBixA7
	lCeydQQCFA3dyqIMzY8uKHCOpySPbow=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795447267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CFKgcFBO4UgwIK/cKgNY6HtHF7vgOpwxHaH3N8T18zc=;
	b=ExSiQhH14yqM7NMVDwwsYquSHwxU3NspUdxm1Ubw5N/pqll6SMXR95NjOs1nbfQYrWd5wI
	4Q1O0RHrhFuaDtOWIBq453b3HRJ7pu6bSG4nLVhVbqLdlI3KzfyccBaqIxtS78BLOmfIkl
	X6oIEmVMgKaDjmgmTb+mYNgc2oxTsf0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Vg+9YLcY;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf31.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CFKgcFBO4UgwIK/cKgNY6HtHF7vgOpwxHaH3N8T18zc=; b=Vg+9YLcYwMFh2urJlLcSSQzVXy
	sO3umaNGynhYi+OEEeR4kzTjCjkS97OiiWU8B+wm9E2W/kyQdVkmX2pesxPI6211YJe1djTQ4ah/X
	VgrBjN4G0QZFV0Wy+dV99xfaCuY9fIpL4PD6UrR8Tz7Y6m+WVQDmlj/8WI78QZTxXdbbFIivBh3No
	GA/EUBdlLE7Q0Gy6AWrD3MkgZfUzStxbqICcTp93+czUgSHDNH7FOv95BH2Pxtfe9Y+eTZIU/hfks
	8xDRfE7xIr+sPwywf5aaPydWRxlKKF/TtHU5wGYeZBhKi6WYuXgQ6EkxPy8566f+elqXvUrA4QHsZ
	rq7+i22g==;
Received: from willy by casper.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xVVqp-00000002H4l-14E3;
	Mon, 23 Nov 2026 15:21:03 +0000
Date: Mon, 23 Nov 2026 15:21:03 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Qiliang Yuan <qiliang.yuan@linux.dev>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/rmap: flush the TLB once per mapping in
 page_vma_mkclean_one()
Message-ID: <awRZ36tj697iX0gC@casper.infradead.org>
References: <20261123-feat-mm-mkclean-batch-flush-v1-1-7e998ad13251@linux.dev>
 <awQo2tg9rzMJYCQe@gremlin>
 <20261123120514.4141292-1-qiliang.yuan@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261123120514.4141292-1-qiliang.yuan@linux.dev>
X-Stat-Signature: mz1hnaommz8kpi9namw4dbsfc4brxixf
X-Rspamd-Queue-Id: 660132000D
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795447266-480391
X-HE-Meta: U2FsdGVkX188F/niuQfcr7JmazmMIlNAgirL+OY0RN8ZKYoTEjCOyNOC+dMdJzAxasBU/2/AGQ+QjNooN2W46WmucEsW10JDSBuq2j2ESbvH/myVyL4MFWPRiJuUWuZTy7/6DTVHUR0/kg0zH84w51FlaQx/KbQJ0YyPo2Q6twx4mqdWjoxoykpMgHFqn9pxFILgS3f71Dq97jl5EqbLotnULUw4ijbWiczeBzPRVSH33o6IsDaGD0WQ3sB00IuV2mKtr07/ScrNDIMNug0yX0WJHHzAc52RRVnEz6Y5PfqBo797PrUw5Dg7PflJdEuvTJvhIi0e3DBV/ImtFjO9SzXLP8iR+7cnVqfD9SUZgpXzu6ScJGhUs8ZdnZFH3qrBsFyL/olG3WTHfFLfhBE0STCQGt5KVNM2cqCmau0cq6o7ww0gsfVWktmL5IYNsv5OIRCTeFKjtzUXDR8vXWhr4PmOfISM1LN7zBCLEcyBzGPUmHz5FjgnNlgYWvA2B58M6nCNm3wmTPDfg3EAj7T1wRw1uUBDoJp9o9cNrlcYPs9bziwK70FVmJRBXSCh9LYVnnlI5w9G/TJ7lWhfm4bX9Qy68ranysCC8lGrrFywmW0A+1OeTlhvv0APLdxmK6yh+7kC1VU/79FxC/N3ESp7M01onvntC79AThwgmPdb+QH7N8sF9ZOpyjmUZk/eRNKLpkFTmq4GoVEAkzI5bRk3ee6RXaKgaResHDp+vZO/m8bdyDE1gR7epXU7cD49lz0bWvDDnX5N8Pbo+8kC+RyjHEUr2neKC4ahvKU6HoADmO3ox22cYk3QjTVceKiVrQsLI0pQgdKfygGMI4kSaTIczvTq2kdFNAK7t4VjYTjA15ehxXI6DKTCX2CdxwY18nCVTzrhzzbTAjOSfitht9J9DE1mdx+nn4MB8w6is8cr31I+v9UT+DkfNVuY+eaUucLwHvjv2p31f0BrGC5i+Bv
 nOat9Z5t
 zAI9Mw6KMbVL/Cn8mzFrJ13ua9vrv+Q5az5gaKxS4reU4LowWwF8ECHAPi1RGm3f/R/jVB8LcHPlYVuw8XVPxpvIPoXgCRNvfeRXC40hzJH1PjODwAN677u4juv2K2itaRjn5MHQqGv4vU7/aDVF+SdTRDu/nye873mIuGB7MDgwiFcHIWC7E9E+lskJu99PPivNKfMkVd7RbfCcIaaBHahxUMGdNHc701GKXTjSMvGQ2/+kYUmhWbqCtfWuYkoentXv8qNMYK2iztvU8r0fvrRA7J3JQ0u299VTY4NEn/ybBtCEEuVYNYCqDN56sgFVc9TtsKdt7x1hPmeKVFDHQCTyP8gEaQMo1b+QwOJDPxUaemJ1p9txt0MyNOy/hLDRVsv4jCA9L428NmtsfnJyqk9czgjErSilR1ewUEPuFBu4cYPWvGU4LS2e065dlAciA49fydxCQNJubi6l1vqpPtmztTkJF/nInxpD4yG0RTwjJwndtgG58oCwS6wCiAYh5NKIxHjJBtVdYbPHCd51UBcrFFQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 23, 2026 at 07:05:14AM -0500, Qiliang Yuan wrote:
> For this one, I was looking at how AI training jobs save checkpoints.
> Writing a checkpoint through a shared mapping was 3-4x slower than
> write()

Shared writable mmaps are a terrible idea.  It doesn't surpise me that
lazy AI people do this, but your efforts would be better spent fixing
userspace to Not Do That.

https://numi.st/post/2024/mmap/
https://db.cs.cmu.edu/papers/2022/cidr2022-p13-crotty.pdf

(and many, many more articles along these lines)

