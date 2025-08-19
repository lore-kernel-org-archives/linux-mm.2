Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA6ACA0EF5
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 18:20:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 231E98E000F; Tue, 19 Aug 2025 14:20:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 209D48E0003; Tue, 19 Aug 2025 14:20:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147018E000F; Tue, 19 Aug 2025 14:20:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 02BFF8E0003
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 14:20:23 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AACFCC0185
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:20:22 +0000 (UTC)
X-FDA: 83794321884.09.FC18A72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id E56051C0005
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 18:20:20 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jXjytkUF;
	spf=pass (imf18.hostedemail.com: domain of kbusch@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755627621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jxMRJz5w5n4PxTFk/2BTZWr0cMwftnWj3iBsc1w/fNg=;
	b=HwqXJVF9FoNoJjPQjZFPQh4bglOqSTlcXberqA4f80C5mAyo7Wygof27KMvRZwHhh54ZcI
	wEx7hTT5MQ26eQZdJopZ2YGRYmdNIiLOEFuFz5825TEfClwaW2tusaanS4NTQElZbPreAg
	SVCjxTaPg1Ehkzvc/yYxl/IFXzX22Vw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jXjytkUF;
	spf=pass (imf18.hostedemail.com: domain of kbusch@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kbusch@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755627621; a=rsa-sha256;
	cv=none;
	b=3hfZAWLti+6TCqVPvVfvpbQD1r6zxvfCurbaQc8AvJ2RTbDZ1G9K4HvkBdEwm2fgKnL1CO
	t2zsy9k5VnTYTlBzkzhSNkc8jbNQMipHIZfK7fit/yjeQC8JjowWLzVrNYGjC/ZQ6o0kjJ
	j+UMDBR2Sc4HE8dShiPDzH8LsnEy/cc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C14C74588D;
	Tue, 19 Aug 2025 18:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0BDC4CEF1;
	Tue, 19 Aug 2025 18:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755627608;
	bh=vJQ95/awDQN15gMxlaXB+Tcfic806+eL4EX36Buoiiw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jXjytkUFHZiUoUGI84YdHLEqkOvvneMczP1tcgM6yHssC3PZa14NlekO8OwnhQkoH
	 1tKFJyNzeoXibR5866EB9AlD853dT6hX/BHgsXNW4sH7pbBGpZs3bWwj08oPN1sJoj
	 hWrw/W8bx/Ed7fmJOvpwVh//YcUPC4H4piBW1ARVWVGtVpPRrRKbwDEj6sLZPN6zpp
	 WYxb2QFL4WZg9ljpPs9MR4UmpIcWbSmNlEaUUOSNEz9VaSvb+A8MMAVV0hqzSSr9AT
	 hd29ClRf6ZWgUwXusfUehQO9rXf61PDcTKf5hXEkAaN2POaxHzJVqre4wL9NW9YYur
	 pp6mAS1uKCUqA==
Date: Tue, 19 Aug 2025 12:20:04 -0600
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
Subject: Re: [PATCH v4 14/16] block-dma: migrate to dma_map_phys instead of
 map_page
Message-ID: <aKTAVOBp0u6ZSC4w@kbusch-mbp>
References: <cover.1755624249.git.leon@kernel.org>
 <22b824931bc8ba090979ab902e4c1c2ec8327b65.1755624249.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22b824931bc8ba090979ab902e4c1c2ec8327b65.1755624249.git.leon@kernel.org>
X-Stat-Signature: gis48bx6g4th9w74nhkbdiy4gmxrc8mk
X-Rspam-User: 
X-Rspamd-Queue-Id: E56051C0005
X-Rspamd-Server: rspam01
X-HE-Tag: 1755627620-508687
X-HE-Meta: U2FsdGVkX1/wkbOFSRZUgxLiLpMZ1NKCVKC3TVnq/vdZZ/cflfwpidd7WNUbpeeoBjnLWI5bjrofqSHq/3Y0chCXxh05BkL/MvLQ6zPjKaygbFE9nPnGCaj6kvBvmbUBrtSfgIxgtOsook+bXXYJW0Hsv2J2hMC6UObhpiDys+4ry1rDr6fclQ8ixtrZV5yFWeXLU0MpYHhcz2oCers1s6ITTNhj4e4noyYx5OUXH8A8wag6LhGFOXGplRIb3LRGm6pMS3Vzq9uTtx0kCxrgJe52S5czh2nlcoIbWwXWDE27lv9nNMJR00c4doO1EL+capx+FElAJdH1/3l4n09xgenwVVxCX2ZGoDuJYGSX3uO+oFPT4ixv/h+m95g6vsU9BFy3cFAVKopSAdxw0S8VzFi3bbTGXw3Cu2agm5Rk9MGy2GZqwVWijxJJS4IAvAtdUSTyB6pIseIfLZevHslP7OKPdgthSqpJ1nuDhnyE/B2uYoM6KZtgWf5IHY3oe2B6RbKOp+W5rB4y7vfAG4rkOveYa3ja6BykkeFW0Za3k8+gdP5GBqItE/P60/iCRsS/v/eDNf9broQrxG/SXQwBRfY/flnnkdSl7DK3Vh4JzkYsxxNVh0w9EWi5X83ryb2CEgds3Cm1+HJuXM2JxoOeLJOC6RxMNUxn7JwFYPhqulMj/UMmgl372jovPP3Qg62sxFJ1ifVqIIN50cPbTsGRnl0t7KQDmQSg6gXdqHkDA7vkqZx3nlMqEoi35ajC5LrO1wqmIHyUayRuWM/9Hn20V6JGeimR7D39SB+h3OkE9PfNfNt4ssZ7zT1mNx08R0bDurap72HIi6XK8dUTgZQo9c0t5XIHgGlQSO57d9h6w4TClfEAQwHhlDF+ZnpV4NYTpgLLYcZSMisQokHpgkxLOyyLYpqbmhDg0LMXZA1szTDKFPsarOTuItmSP9UcLRqa+jIt3K1IJNLARS/jp3Y
 7/8bCSi2
 3iPuFCZJR5t71pExfdkKj0wzEhZpU0zNLSzxRIrlUkzKHvEPfIqqrpLI5xfX0WF49uTdk/Xq1q/zQPW3lsg9SACm6PHZV0dKm6B2K7OcLrxi7xuBNef/n405HA6BBOvNqYIcYqMcJOMPS247wElLiVfvW4o79fcj1xQ0UsxI3N1mVJdICa7dmHbZn+nddT4Z1+nYKVUbrNPxfVWCVgpWGriEyjEhoYD0AwZfEecJrbyD1bvHiYlJmxpcNUmfS4hIpOMFmXlHi75my0LqCXy6YLWmoC0h/s5i1zOf8pBYfbHytU4cSgJ45xzEEDXAorr5NLS22XLaQHZnXgu9PHvOmSvePloaVlcNtMqKO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 08:36:58PM +0300, Leon Romanovsky wrote:
>  static bool blk_dma_map_direct(struct request *req, struct device *dma_dev,
>  		struct blk_dma_iter *iter, struct phys_vec *vec)
>  {
> -	iter->addr = dma_map_page(dma_dev, phys_to_page(vec->paddr),
> -			offset_in_page(vec->paddr), vec->len, rq_dma_dir(req));
> +	iter->addr = dma_map_phys(dma_dev, vec->paddr, vec->len,
> +			rq_dma_dir(req), 0);

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>

Just a random thought when I had to double back to check what the "0"
means: many dma_ api's have a default macro without an "attrs" argument,
then an _attrs() version for when you need it. Not sure if you want to
strictly follow that pattern, but merely a suggestion.

