Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA7F4CCD1BE
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 07:10:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 535C38E0008; Wed, 22 Oct 2025 03:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50D998E0002; Wed, 22 Oct 2025 03:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44A1F8E0008; Wed, 22 Oct 2025 03:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 339138E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:10:43 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD9965B473
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:10:42 +0000 (UTC)
X-FDA: 84024877524.04.4AC4C61
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id 20024180006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 07:10:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=LA0EsnIv
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761117041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XKoyGCto+Kn0HeCK5i87kYlf6+Be8yWE+pzHWLeDEO0=;
	b=1Sdaq5IMmuVjo3HU/0lD8DpWl+YO/5FGM4ZCLNy81UoC9ZLY4C5192eFsXr1/0ojvwC9hB
	CBkc2eGrMjtvTqKKlU26YEX5AGd2zMqYsvO6590Pt6oL3XjvjYuNOxSEnJEWeb0LRQRdIN
	nTaT3asYJpwwifQg/hck9o237uhFmEQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761117041; a=rsa-sha256;
	cv=none;
	b=4q/t/eJiXDcrOWJMiHcbPqYAp8xqHlJL/1EeQZRGBf/U9B52NFHN5ZEItfBMiZCYMNr9Ly
	xpIOhPf+iqOorU0FUzPdjWhKsaJNoPk/LSy8ujcJOKwhk4LtNV45PvLdBwLzi1Ekgzxxet
	z14FWFRWI+rNIEUz9ClZeXSaxrmcP5s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=LA0EsnIv;
	spf=none (imf16.hostedemail.com: domain of BATV+21c3bf232c3b55be12f8+8095+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+21c3bf232c3b55be12f8+8095+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=XKoyGCto+Kn0HeCK5i87kYlf6+Be8yWE+pzHWLeDEO0=; b=LA0EsnIvPmdhyAlKnWiGNmOL5l
	dPh0nZUevEw5pwm6HBBuRxpL+2yfoJmbOBQlWDuYglG8QtuSjZzDWUqtSadQ1OFRPkGGDZwk02eQl
	Bu+qOaq4hhb9Bd5VhP+RGw6wG8tKjt+oR0eO64ab5IIneyp3/JhLSsBpmjpjM5a/ycj97uOgmYi+/
	Y1cRAulWoHfCg1kdfl5Alide/1gYw2Rn+VvkITIlqp8loD9nJTP6eJ8kMFPCR/UpvZDtjb6axkHGz
	ZZPEPI9OgbKn0k/f8YRe21WllooKBtsnBOVhBULD9Jfr3RGKlOgLor3ceNm20eilmCX59TC4cQ8TU
	Mj/Wx7eQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBSzT-00000001oYi-2Iys;
	Wed, 22 Oct 2025 07:10:35 +0000
Date: Wed, 22 Oct 2025 00:10:35 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	Leon Romanovsky <leon@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Leon Romanovsky <leonro@nvidia.com>,
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
Message-ID: <aPiDa-QruoHC3alk@infradead.org>
References: <cover.1760368250.git.leon@kernel.org>
 <1044f7aa09836d63de964d4eb6e646b3071c1fdb.1760368250.git.leon@kernel.org>
 <aPHibioUFZV8Wnd1@infradead.org>
 <20251017115320.GF3901471@nvidia.com>
 <aPYqliGwJTcZznSX@infradead.org>
 <20251020125854.GL316284@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20251020125854.GL316284@nvidia.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Stat-Signature: heajppn95otx8ow78y9k4cbjxsw74cj4
X-Rspam-User: 
X-Rspamd-Queue-Id: 20024180006
X-HE-Tag: 1761117040-450763
X-HE-Meta: U2FsdGVkX1/i2O246dZ27Gm1xYolBd/GQIWjUiRvYnFueoh6ZaoVu1P75s/DYOf1yLxnssCQPxwVUJXfyVOZ0/IqUigQGyuKXEIeCBKVEIfT65Ie4o/Hj+JlGdAu1iZxpD+hgVpqQEGqlis7kijbGXbVVKY+sW2zRMN/g1p6D/kAGbsx6pBw2kPCC2bVgjFtWz6TkVnGy3c7r+Ngl9waNytc7Ij4d1UufRJNGACUBkMY2KCzy/bx0eZ87jhZ3sLQ4AMcVaJHpqYqJHNrgTttlrWLIz9fX6KEo+yKm0utsnRN2oTiFSAMvOfNDi+EK0wNleR1K22qOMgMGkzGpjQt2N8HOq8kxhCzB9nOZJCPTutZGfGgLNHrSpR1jpKmwiQRHSMn6ayXl87tRPGUjL1hq6U9oc+B9FfHuf/pCqd4/dY2l1ZTYKG5rAcnuwv2ENID/uJHj6vcIGas0TGCPM0nim8bb7Sqta3v5X3ahWFyPZhu9HXk+q9G+Z1I9XF5MHD+k3MaB2U858LwlDcsKCL9xlZrftky7uttA9AaapV487LzF5vT17i61J1YT+TxVkt5Q+fGa1nTopRs130z9TP3fX10cbC+3kGo4tsmqLO8KnQ5gMjquKX0GUxBNZLYj6MZhjQ8yfOSeogi1f04iTxy2C0h1SyP3t+BdcPgRjhtzqLexS40qvNZu96kW6pOCh9WwtwSECqE0vRr2B+SOKoNpMH+4WBr3UkJKVi6YLr/cV84zJ7fQK15j/lu1retJ+gVLo5jVtdryILU4MxNjx732bGQCUvk4ntDK8/ZVRS79riHB+2kZm+T2YEKM6wvgMv9QnI0yFUilsFl3PLo+62Cbd8je1kxni6tc+157Do9ktUQONXF88KEhM2w6IHT6agfXSr7O7FLB3exD6xveRpD+VjlQ0LsrwpiIOKdmIDnlCKxpxrCQh4x139gWckn5+CwAjhMYCi2JD0Cr42Ve49
 ziIGN4cz
 TixgLdzSaCipHWQOvd9Bmh706Fbpuz7RgqTGNBxFGKFfGPEFry3TPGrIGg189SptlsRGCYolHErehpI+ER6UCkRly2wrRTWMJeMggienGoU1N57za1gZ/LFm15kqRxem/PhSejYvXRxXpUdBcLHNcv+sVC7xXYJnJzFyvTvYw6mOu9YpUzy2AerSSpRhbjLDHC6DkqpU6s2fmY9h0lDcL6Xpw3RMBSzRdtZTf7Bejij60StkAdxohTtlmsgEjZ8LPhq15yPo2ZNCF+/HcXRoKkgtINZzBs0tjLGxyNRHMt84eaoAYSzYwsTna4hAGAokhCSM640HbMtv1tDDGDYF6WeFdKO0wNMwx/t4XbedLUPY2hGyY+fJ4rBFVzZ9MyRC8Zq79X0WWma6x30nwJQ81T2/TRXE5kstdqMDjzClBzuv+B0w97kiz1h63jccxBNGoKGC5qo1wmpzKTinFaiehJuR+19Bs8nq95Zfq
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 09:58:54AM -0300, Jason Gunthorpe wrote:
> I explained it in detail in the message you are repling to. If
> something is not clear can you please be more specific??
> 
> Is it the mmap in VFIO perhaps that is causing these questions?
> 
> VFIO uses a PFNMAP VMA, so you can't pin_user_page() it. It uses
> unmap_mapping_range() during its remove() path to get rid of the VMA
> PTEs.

This all needs to g• into the explanation.

> Instead the DMABUF FD is used to pass the MMIO pages between VFIO and
> another driver. DMABUF has a built in invalidation mechanism that VFIO
> triggers before remove(). The invalidation removes access from the
> other driver.
> 
> This is different than NVMe which has no invalidation. NVMe does
> unmap_mapping_range() on the VMA and waits for all the short lived
> pgmap references to clear. We don't need anything like that because
> DMABUF invalidation is synchronous.

Please add documentation for this model to the source tree.


