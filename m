Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C57ACCD184
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 06:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9FA18E003A; Fri, 17 Oct 2025 02:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B779B8E0002; Fri, 17 Oct 2025 02:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB4B08E003A; Fri, 17 Oct 2025 02:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 985188E0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 02:31:59 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F8F759739
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 06:31:59 +0000 (UTC)
X-FDA: 84006635958.08.347802B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id C1D7B1C0004
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 06:31:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=493urc9v
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760682717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pmHn5+tRqJO2fDf6pS/Dahy8vpk/9cVU0mdR9JQWhq0=;
	b=EZWKN+KzCFtwHlHtG3YWcTqiD9EwgIzcG7FTRjKfP+O2y5YETLe9EqWhH6/x7JUCfRp1bx
	HhgJauxeK4QGMBOT7U0bigxhA/HHBcI2rfzl3RNGgXAWhtOA9rx0dXsgST7UfW7GslOj+q
	wdNrn6Mv9sLiQtM3QsrUju48a0lp7Yg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=493urc9v;
	spf=none (imf21.hostedemail.com: domain of BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760682717; a=rsa-sha256;
	cv=none;
	b=6S/Old7CGvuPtwjP/fRfTXR6UIgPv1KLDBap9HEZ7gxzuLZQQmWAJXsi2OaOKH3vnXPEjq
	6zifr2fws5zirlnLygv8iT8DonHfI8CdT/TJZ5kiIw5srsgKTnzFwZIJs2fSDCTaYht2Ml
	ZfwALeR4jZqi+COkW1d8wztbntcn8YU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pmHn5+tRqJO2fDf6pS/Dahy8vpk/9cVU0mdR9JQWhq0=; b=493urc9vdCLUHtN/APrPDMt+Nw
	AAbBU0C8dfMa1U8/04w8afM0UbQ7W4gfcGrT1PBGuKApCfeI/yVbNcy67l/1CHbSzWig+DgEMzhl1
	ZzpKrqbkQ86pXT09AHT/LEn9pdUs7xyx39HR4pPuC0C9RK1ZEmdj52vKjGs8HzpfXkoQOv3DRNBAo
	iiC9vjRotySW9JM5FhYFwF21OgRE0gkvj0t2hF3xqmFaqwWaYjuZbpS5u4slbgR3A/lwVwbjv0Qs8
	3wRUKZuJqg22v24KQ247pwYg+VEk3THzgctOopEJX1pwFYWtXV1JYoFEi9fP+5GDHzAhdIYSMFrOU
	EcuOZFYw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9e0H-00000006nP1-0jS7;
	Fri, 17 Oct 2025 06:31:53 +0000
Date: Thu, 16 Oct 2025 23:31:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Leon Romanovsky <leon@kernel.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>, Joerg Roedel <joro@8bytes.org>,
	kvm@vger.kernel.org, linaro-mm-sig@lists.linaro.org,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org, Logan Gunthorpe <logang@deltatee.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH v5 4/9] PCI/P2PDMA: Export pci_p2pdma_map_type() function
Message-ID: <aPHi2c2BQNB4eqm_@infradead.org>
References: <cover.1760368250.git.leon@kernel.org>
 <0fa715706e1adf5e26199dc3eaa3b1ff3b14db67.1760368250.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fa715706e1adf5e26199dc3eaa3b1ff3b14db67.1760368250.git.leon@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C1D7B1C0004
X-Stat-Signature: x9rp9ke8wuwceaj73eho3yj1ao8tphpc
X-Rspam-User: 
X-HE-Tag: 1760682717-387374
X-HE-Meta: U2FsdGVkX1/BU07V/sRFsCVZqLkVekz8/AqU2Ahf7K5HNtG3eDbFQ0ztQbL+dZyXCYC1IvFNxIxXEVNR2ZqJbIE0eNVVphizJG3WfO3GKcN1JnVnUKCNBz1VoGfRBHQwYeUDkLEeEUFFrP8UAuuCckHOz0nmA9JdTm93XwnKjNJwDSpDf+tyNc2jXuHkBclNBkKh91iabXyWL+JWoBprlRUBgkTzIhKc5Q2sd2OaB8AMZC+JOUWY7/uc2gM6c6YDFWBZzEi0wuP+nmuGeM7ARPVwvl08O1fyUH5Rg9R+l+ViIo/ljpnpE0LoE3H+ygigEGXmMLc5Oq4aNQ0hgzqlNXWGBA+wphCPas9BHnXMtuJgdCUhu6aLMg0xBj4KlJTBuYvlbEjk0a/fg+QDv0iGSqYTh8mNt+YdgIM7dop3VYTjd6vdeC1EKi+o4aJS1nsi8oX1FkjYljxJ8i/l/51nCCRvVyXKms9Iqx+IZQjDWce7HM2boV5CRotehVkLknUZzaWu0J5nJ9c1NMaDxHh8TxG655RbT9Iai6aNkfsMA9o1A5I+X6RX9E8KjzJuiNsaQrmT9VCYOfFicefccpw/+L9htK+RYlLJ07/1jVD3xfb7LZs+zP1/NpZzcFgsSQQNNWXfGnqsHuT7xeRdu75dxgeQ0lXeQsK4muLC/RncmewPAYnMxJvoTV6B+kkAD/qpFRzWsIEnjnnkvRQ5hrnm6tsonk9L1NT5/A+y6TfPrJ1+NB2gXWhZnu0AnTSoE2MCRIETJ78I9eBz4dY72Auh4vjpsAtpKY32iTdxT3i4HJ/sXa/sTbxqhaEu9Yc3U6P5s7LiU2zyvx7qsd8jhnmS4CM894oHppIiQFNwukfMCNCLLx6rP5GT2fe6/dYxAxcaw4s0WjVilUEFPDDfg5ZHioJVdN5RcTrMItLnp3CJYc4QzPcaO/mLoY3B/UqXWz4U3n4MKbSghjeA8VzqrfL
 /3zG/RGw
 LdYCdhE8waVwGd0oDf+1w1LT3wYflei55Bs+i9VZ1R+7mRE3XpaNQSh1leHXcHlm872QXHfqGNSQu5dsMlnMCQEjEVGpoSuTpLFiz0D6Cdld6LsNBhFo9e8VsvUN+MhINvXVe4Yb3vBjOU3/g9ctlI79ve8Q15MCsY6PcPcjnVlhTdp7PotXiEMINHLF+C89waSECQx3s50TMwwu4azWqQh0O4g7T7tJyvPraU2iyTpQPs5bPuPcGDOaLPY2QE9AeeEJ5AgXlrpgAF73ekLZh9PHfi0tYznDG+FuDiuIG6RG8LcjeMZ63dmfkXhXAwX6CHyEqaxFOCvehyECENN6jApqM/C6qZheMMikFAI6AloSthCiWnzEmNKSuvA5HwbknKu4UCjM4gTQraspDxBtnnkTPbe6EOgYvFHF4OL6SOvvFXiocUXvjk1KYjjTo77d2WXqmxbT/LuYSlPexn54hu8OJ5HSlcrh6qztjNXHKK/Tn3MenCKpbHIaYVfPSUsGG/LTM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Nacked-by: Christoph Hellwig <hch@lst.de>

As explained to you multiple times, pci_p2pdma_map_type is a low-level
helper that absolutely MUST be wrapper in proper accessors.  It is
dangerous when used incorrectly and requires too much boiler plate.
There is no way this can be directly exported, and you really need to
stop resending this.


