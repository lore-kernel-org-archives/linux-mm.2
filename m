Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5E84CCD195
	for <linux-mm@archiver.kernel.org>; Fri, 17 Oct 2025 06:30:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD5338E0039; Fri, 17 Oct 2025 02:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAC758E0002; Fri, 17 Oct 2025 02:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC2738E0039; Fri, 17 Oct 2025 02:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A803F8E0002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 02:30:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4F246140561
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 06:30:16 +0000 (UTC)
X-FDA: 84006631632.03.A442C9F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf11.hostedemail.com (Postfix) with ESMTP id 766A640002
	for <linux-mm@kvack.org>; Fri, 17 Oct 2025 06:30:14 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="FfObMG0/"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760682614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7pd8xu2BQLfOjempHtq7iHnkhNuH0dguXz1a13wDXOQ=;
	b=LUwBw2nUeO5SyuTcdcL8Sjj4IvVgpxAUd4/ENXtSj2JWUT268ue2uBwjigd8mqg2FY+raV
	GJpX/GN/1Rjgbz6mYP5l+NYahG/+60BmMW4PE9l5ES5xfgpIuXMVIWwaMCyhkzYX/gOnS0
	o3lziCBd3+/z2b4IxQ2BcJosBae7lC4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760682614; a=rsa-sha256;
	cv=none;
	b=UfCdg6mNCBpaKIW4PF5dmjFb6QfE8yiI2zbsz2/WcRxx3u3BxJ7zVlfsKlXRlLhERHHod2
	YN+sz9CCErcNnS2Lf3pogRJTGnsSzgS8HIQESKNKsKQPrcAS5mFJqnMa7hiFL++XTxCUJw
	CGspmMY7vhzXiJU8jQrY1WxDwPpZk6E=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="FfObMG0/";
	dmarc=none;
	spf=none (imf11.hostedemail.com: domain of BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4b0bb848bbbfa73029ae+8090+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7pd8xu2BQLfOjempHtq7iHnkhNuH0dguXz1a13wDXOQ=; b=FfObMG0/tRIyrpoLwagMgvca16
	ZBCXDWqMeZdoS/MkWG/P0NiNjEObHEld5ZrPkjGCYV9ht7av76XBdbzq+UHINeirBZSMjnv5iGAF6
	pJB+mcw13Grq4C5oq8umF4dIhZkQXk5UW7gi0gp74MglLK8g/bcf90kHvTe4EA9Y3231+veU5nPp6
	qVaJDBvzWZ58NbVAASJSU45+HmKPK9o1e/lIAXcS7KDAvBhiYpjnepl6/ptnGwBjRDbo0V5PHbk1x
	V71HMJ9pcrRpCGvX+EEo5h8TCxTuIy18KwdQsjnR7rxLfY0FFb8DO4O1/RLTpsn+yc+z6mXGaRhzz
	O7iEvjlA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9dyY-00000006mal-41MA;
	Fri, 17 Oct 2025 06:30:06 +0000
Date: Thu, 16 Oct 2025 23:30:06 -0700
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
Subject: Re: [PATCH v5 1/9] PCI/P2PDMA: Separate the mmap() support from the
 core logic
Message-ID: <aPHibioUFZV8Wnd1@infradead.org>
References: <cover.1760368250.git.leon@kernel.org>
 <1044f7aa09836d63de964d4eb6e646b3071c1fdb.1760368250.git.leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1044f7aa09836d63de964d4eb6e646b3071c1fdb.1760368250.git.leon@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam01
X-Stat-Signature: k57xtjoo9e5xpsjbbwyz7b1ifpzgym1s
X-Rspam-User: 
X-Rspamd-Queue-Id: 766A640002
X-HE-Tag: 1760682614-165943
X-HE-Meta: U2FsdGVkX18cHV4U4UOZoXSm/nxv8nIX8WPVTRe3jjcVHgFnqIBFKiRVDSQ3/RrIYdEPEE/3p5f20kuULfErfIaynJbSuN0Tf7dki4zWaJjBV64LyDzKHpoyqvP+8mRk2CXkXF+8U1GakrqTqnMAhNYg+937ptw+dMRrNm7HxJ9n8DP0UTHxCrRlnPavSd5bgSQTGUPOLORKmiqFz8J6jSaYKSpmjl1FJG3yha3+mmG6BixTmi/UFUfxCfH4zC8pKMfWUZyglRapqUti9irG+C54xkkUp4yEpHF/JcWw7uy38ofA3h6/iLkc5MKEy+9mVr9qYB1APIgDcg3rBfwgj/Gz+0QcNYeLoOoJVBsRfQXd332H5I+cWnSfU75EMjj16OMDA8i41T2z+Y1/7poU+3YOR6a/u+3Jasqwg9AJRAsPnG/rojcJvR+0/iwsNi/9o97T+MZ5jJSnkp4PK36cpTMU/fYOjsmUb+QnvIr2IgYHz8CTk1bYFRZT2pG+LFEcieBR+LBIOlNzCkY8YlbAcqsWYP9AC7Qq/UIPFfC9SokQN2g8E+whIvB1VjpYUxgwiW/R3SGKsqV6qvsB1TVZ7Wv+TZhl+qdy1T+QgswCxw1wWCW4b4x5BBqM9vkTmyH6At8phqQ3Rn/gFFG8xJrVw/+vLsuX4Xg/kswp1nD4QV6rhMeQI3xpyaDq+HbR1s0TdlKO8Np9B4OWA+9UnVPih4HA4otBlOdY/ReS/BNUip+xfLjAhnK/IKBiKe36rYYh4o5tIGkNEiQPOZXo8Uv0RVOpyOVlEdCnPXpsDidnxYAoDTW0EXJOLLEYc/5XxsiDQB2thKO336uHUshbQPOWfe1nNfWi1aPxzAW1+o9DDqCQflWqHOCRjTcs0YnlNvjwNaz7Ce24RiBXrzYkWPLEhCOu5r0aLbuNNDJMnaP8zzPwt0ZoOI6gmIhnQL6ovnB9m0t+9OA6JntNpvvqAqo
 L3zdJ432
 QmbZ4oI8Dr1UyGyQhQW/JF/GDdN89dMymfkfPcewCsJBiXBKIfwl0qzdK5StiX4gVAz/60iBO6MHUGLl+0SWM30Y7IFCXeRfXuu1iCr8PmaCQTIAX0+2EAbC7AHXguXcbIpdDtjqyhA6tQ2MHmVWKQSGhkXVDcWG7OSkg1ReTGHJDrhaeMiApwOFsUJSvfT+OqVixvIR/m2K71drKFVVDjOPnp/RdL12sEy5sK1AdMUM32asFcq6dpMFc3qJI7rxxV8wEB30lBG9IfX14mxN73WZ98j3SzBwwId7kjUCPJi9f9SGdeKlEyauJtsyu3enaBs/uY9GVXpt/vWKixk4VbouOAWMPXTTNrUdGsB4UZ+2lwkwI1l/cOBHA+Rx+e0KsXvFHhqUTPuOH5njBlfWszP8o3Hz4u8tpPsPi5xD4x/Au+9A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 13, 2025 at 06:26:03PM +0300, Leon Romanovsky wrote:
> The DMA API now has a new flow, and has gained phys_addr_t support, so
> it no longer needs struct pages to perform P2P mapping.

That's news to me.  All the pci_p2pdma_map_state machinery is still
based on pgmaps and thus pages.

> Lifecycle management can be delegated to the user, DMABUF for instance
> has a suitable invalidation protocol that does not require struct page.

How?


