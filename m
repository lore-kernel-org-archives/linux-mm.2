Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8436CC87FD2
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 09:43:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 185AE6B00FB; Mon, 11 Aug 2025 05:43:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 137296B00FD; Mon, 11 Aug 2025 05:43:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 025AC6B00FF; Mon, 11 Aug 2025 05:43:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E68186B00FB
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 05:43:16 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AE69C140773
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:43:16 +0000 (UTC)
X-FDA: 83763988392.05.A291B18
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf12.hostedemail.com (Postfix) with ESMTP id CB55840007
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 09:43:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="G /WZXrU";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=BQK+ypFX;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754905395; a=rsa-sha256;
	cv=none;
	b=SiqvNcY02HCwHfQpOesMzFHey4juwMD5OZ9FIcBjsNv6Y86qQEF84UqxLFoDVcKZQzDekh
	1ls89uPnhY1g46GIRA7cDO6bDkMikfqud7TYMKLsV77RcNjTpM0dNrM1e9i2yCXmytMR/2
	OZT1N5sIJ0gGIvNd4gm+J+3NYBrCJsM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm1 header.b="G /WZXrU";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=BQK+ypFX;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.139 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754905395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VdjvmWy6iQXvtQ1GiKbzqztULu85VbiyFIL8fPU8btU=;
	b=AHuPoigjDIsd4TT7aLAdH5DbFGX3pZoYnp0CyBbDxLOn9M7n5EjyEZ4OSHGAF3ZOqpAx4b
	MX0dkUHOVQ9d/0g+JqkDpxbq63tA+uMmdV5NqhRpszo0LyJiG57DIHXkwMzQFtTglo8jAq
	zmMW4bopRAiTcXYOrF9aCyr0fw8oR1M=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailflow.stl.internal (Postfix) with ESMTP id 7566D1300129;
	Mon, 11 Aug 2025 05:43:12 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 11 Aug 2025 05:43:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1754905392; x=
	1754912592; bh=VdjvmWy6iQXvtQ1GiKbzqztULu85VbiyFIL8fPU8btU=; b=G
	/WZXrUqh9nsKBdFTWEfHdbeqxbH3ManDGS0mzft3EVCv+32+GusH8VCChlayvYlu
	i8XqMjj5F3ltL81Qex9gLEOj3d56rW8y++gOjxE0unJgEeAmhkYeDELDDnBcwWBm
	5CxsLfUbCxivxpD3zFKKoCHK9Ln7uwFCMsJ2Lz/h8Be3voXaKW9TcBFm93pQKbI1
	+kg1aIJ0Sq2hdLswGuyNDbx0RLIIP0CMVUHdTjrVAa+7++QwgseI7tO30h6hS4DY
	1OWQQWVR5l77vkIvCEu+JKx2Uv+03PngMi69tFvI7iradTMGXcwO5qYKKAmm0ipc
	l014vUhZ64Ll/lRUqGmqg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1754905392; x=1754912592; bh=VdjvmWy6iQXvtQ1GiKbzqztULu85VbiyFIL
	8fPU8btU=; b=BQK+ypFXPOrbDUTH5B4wnAvNnNtfw78A8OtplJWKdEDwTYtfcm1
	mdZa/C4afcYNT5RKDSblmk6uwk5WGjqDsNYwMHcnPbVLMHJX+o/wtl39U29RyvcM
	XdRE08fuGYdiBTlJuN3Zt7M7eYwLn00p8CzsN9ib6pJrehO4FWB9+DulPEz+a3ls
	1yo8IweN6EgazJraQu10YCBpHHjnBDKk7SZd7XaqHG+w+Iu16/2PwVc5DdmW9876
	LdAOEr6htEk9SKaRSQ43vGuE2pCcYxpO+n6uJJL39AFuR2Na6lk2j0vydv4uMMae
	AOn5qR0/fc6UoTExIk4A4unytXMogWFx7sQ==
X-ME-Sender: <xms:LbuZaBRkxOnx6SpBT0QfT3s9t5SzxR-oPLhvu0ZHJpau-aa066FUUg>
    <xme:LbuZaNsc4bC5lAEpmlPiVx4gnva2b44-Zmx2uMqNgiSWDLJfMT05Rb_TAOllkLlHU
    U6y2o3l9yA1bPBTij8>
X-ME-Received: <xmr:LbuZaNk8yYai-XvLMSRc4gREbiO_Tpta32YgUk1-0sO9HaPDmGS8njyXHK2q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeffedrtdefgddufedvuddvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesthdtsfdttddtvdenucfhrhhomhepmfhirhihlhcu
    ufhhuhhtshgvmhgruhcuoehkihhrihhllhesshhhuhhtvghmohhvrdhnrghmvgeqnecugg
    ftrfgrthhtvghrnhepjeehueefuddvgfejkeeivdejvdegjefgfeeiteevfffhtddvtdel
    udfhfeefffdunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrh
    homhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeeh
    iedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepkhgvrhhnvghlsehprghnkhgrjh
    hrrghghhgrvhdrtghomhdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhm
    pdhrtghpthhtoheprhihrghnrdhrohgsvghrthhssegrrhhmrdgtohhmpdhrtghpthhtoh
    epsggrohhlihhnrdifrghngheslhhinhhugidrrghlihgsrggsrgdrtghomhdprhgtphht
    thhopehvsggrsghkrgesshhushgvrdgtiidprhgtphhtthhopeiiihihsehnvhhiughirg
    drtghomhdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohep
    uggrvhgvrdhhrghnshgvnheslhhinhhugidrihhnthgvlhdrtghomhdprhgtphhtthhope
    hmhhhotghkohesshhushgvrdgtohhm
X-ME-Proxy: <xmx:LbuZaDJbQGaLdnwev2IPfL5uOUvnRSEIFmb59B-gJ2praKYD8hqgPQ>
    <xmx:LbuZaN6qzYaDRnyyLkHcnk-r5M3-cwVYLwQvcCCprm4d1frtQsIDug>
    <xmx:LbuZaD0pbxsjkR-8UrFYtK7ZlsBdpuvJg109DZN61JSFJ6-38xspxg>
    <xmx:LbuZaNOCGd4ZT8bdu-31kNEme9g00sMKqrISutGRJrxZSGYnZiGMkA>
    <xmx:MLuZaKRuqoK3mFiJGexCZYWZqsudz8TcN55vbnt4rHxNO9kAFX3Y9LoR>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 11 Aug 2025 05:43:08 -0400 (EDT)
Date: Mon, 11 Aug 2025 10:43:06 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>, 
	Dave Hansen <dave.hansen@linux.intel.com>, Michal Hocko <mhocko@suse.com>, 
	David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, 
	Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, willy@infradead.org, Ritesh Harjani <ritesh.list@gmail.com>, 
	linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	"Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, gost.dev@samsung.com, hch@lst.de, 
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [PATCH v3 0/5] add persistent huge zero folio support
Message-ID: <hzk7e52sfhfqvo5bh7btthtyyo2tf4rwe24jxtp3fqd62vxo7k@cylwrbxqj47b>
References: <20250811084113.647267-1-kernel@pankajraghav.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250811084113.647267-1-kernel@pankajraghav.com>
X-Rspamd-Queue-Id: CB55840007
X-Stat-Signature: cjowuoznp1rehy3ndqo9mqtxu9owf6he
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754905394-897096
X-HE-Meta: U2FsdGVkX1/uNk8hZdiGg8foZ9mAGnrzhAKfQPCv5+8ZB1lqaUqZ0pIdbonmtjoKoBkdLcpILC86lgunywUpkiA1JDTxDkNhHEx8l5ZlV83Ou8UEtFWvWGrUGRM7yV/D+Xxv0zOQbxA8yWyzuIqXBd0OrSFOCeud6ct699w/Rx2w7L2Ao4QQyH9qcfisz8hPZNkXXVUmczaFDr1lNoL3ua+GSFYpNUkSXKIFQI72BgCFot6Y9FcIkgRK4EQ3WjVVjRZCgIAWOgh674I1pgZTKRx+fDYMGq8SxvZp8/TZSUK7DOelaQJk+pIp8i72XzT6qd0FBJsvdMXvcfcVWC8SSC8uShMtYCyxBJb4fpuRz43gUb2IxjyZFLwl2DfrLmA5LLsR+R0/VTTdohYhLn+kxqG2uNvGgU9d3jLhNg7AYBIRShD+IhLjU7fh5nafQ+jlsVPX2EJUMDxxaa3814yJqxQtCUXqf/z7LmrRh6Kx6bn9wmLC0BHiedN6TPwXUYszS+abWfzoseaRwBzMWr1pSdKAzXKz1aWczD4k17oITTXuCYJVu+FO/eIhUyJ/9RQJm+70mRYy9Bw3Q4KAs7GiqlD/YNdIrGM5l/HfUlShPtHaqJgtU9WUurEBDX0g3Fx3xhfGSErBYGAnGIpVOW0qqFf0D7JK6DwNfcKGBtk30OZ0GGd23BxfV3FwwD+hB0kIVc/icFIzu1TQ7lEifxPE1gTrj1y3cov3zVc98W9IghwNXsm4+H30Pq2SaRrzUucpKoeMYsnXXYfsAtkx3xs1VyPkOeAqerBGrSS2oM18BHnHqgGClx54z4eiujzBF57VP1OsANT1XBRkSr5raQ7NDuTsfasIkvbCvvJZ/A5NsW7/mdgOG0BP6lBt1bU8LZgEApPY8JVulKBwErLV3hxJqAf1KTLHJwbFgMM7tx4KkJIovdF+d4NFe7XaqnLgga01gVA9zUSec03ZhLf5yo4
 yDYrPASN
 rD20/DagQTWA+YBk4R/sXHyLKUU6+XOb2Dht+oi+nXf1UxTp+L/7FMVmQtO4kvfmZBToA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 11, 2025 at 10:41:08AM +0200, Pankaj Raghav (Samsung) wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> Many places in the kernel need to zero out larger chunks, but the
> maximum segment we can zero out at a time by ZERO_PAGE is limited by
> PAGE_SIZE.
> 
> This concern was raised during the review of adding Large Block Size support
> to XFS[2][3].
> 
> This is especially annoying in block devices and filesystems where
> multiple ZERO_PAGEs are attached to the bio in different bvecs. With multipage
> bvec support in block layer, it is much more efficient to send out
> larger zero pages as a part of single bvec.
> 
> Some examples of places in the kernel where this could be useful:
> - blkdev_issue_zero_pages()
> - iomap_dio_zero()
> - vmalloc.c:zero_iter()
> - rxperf_process_call()
> - fscrypt_zeroout_range_inline_crypt()
> - bch2_checksum_update()
> ...
> 
> Usually huge_zero_folio is allocated on demand, and it will be
> deallocated by the shrinker if there are no users of it left. At the moment,
> huge_zero_folio infrastructure refcount is tied to the process lifetime
> that created it. This might not work for bio layer as the completions
> can be async and the process that created the huge_zero_folio might no
> longer be alive. And, one of the main point that came during discussion
> is to have something bigger than zero page as a drop-in replacement.
> 
> Add a config option PERSISTENT_HUGE_ZERO_FOLIO that will always allocate
> the huge_zero_folio, and disable the shrinker so that huge_zero_folio is
> never freed.
> This makes using the huge_zero_folio without having to pass any mm struct and does
> not tie the lifetime of the zero folio to anything, making it a drop-in
> replacement for ZERO_PAGE.
> 
> I have converted blkdev_issue_zero_pages() as an example as a part of
> this series. I also noticed close to 4% performance improvement just by
> replacing ZERO_PAGE with persistent huge_zero_folio.
> 
> I will send patches to individual subsystems using the huge_zero_folio
> once this gets upstreamed.
> 
> Looking forward to some feedback.

Why does it need to be compile-time? Maybe whoever needs huge zero page
would just call get_huge_zero_page()/folio() on initialization to get it
pinned?

-- 
Kiryl Shutsemau / Kirill A. Shutemov

