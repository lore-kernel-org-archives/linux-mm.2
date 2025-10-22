Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00769CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 05:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 496188E0005; Wed, 22 Oct 2025 01:04:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4461C8E0002; Wed, 22 Oct 2025 01:04:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35BAC8E0005; Wed, 22 Oct 2025 01:04:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 20FC68E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:04:54 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 92F84BAEF8
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:04:53 +0000 (UTC)
X-FDA: 84024560466.13.8FDD79F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 063CF20009
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 05:04:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Hi06oMy7
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761109492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5Smdjdq98m6eRqqjdmVHSHPPEy9QVATBpcC35WOmW1E=;
	b=MeVif195Wtjy7us7u+PLVh2dkJWE7rhCcUmhL0/lh/+S9/IsGNqa+8Toc+23bhRuo2PNEv
	VQw1ouCLHOmU4eosLNgy6ME55lKBdOn103xyh2kXsl/Jq1a4ZbUJuorJz0uRfwbGQMtslf
	y6lt4gcHnnckNyT8YsQU1AdSZkBHd9U=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Hi06oMy7;
	dmarc=none;
	spf=none (imf13.hostedemail.com: domain of BATV+21c3bf232c3b55be12f8+8095+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+21c3bf232c3b55be12f8+8095+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761109492; a=rsa-sha256;
	cv=none;
	b=r5L137dv0z7nWpVqL/GmTtNkSvjkPhanY3/fWNoko3Gi8y+KMfSPp2sAK7MUCAv8oeeB2v
	hk/PhRawsEuRVuqV2qequX8Mnlu02rshIjVPBS3r1r4ca1QFamj9lB56miGJJleB88mwNp
	RyseMCvdYHbX+YqBLI5oJztP0cePP80=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5Smdjdq98m6eRqqjdmVHSHPPEy9QVATBpcC35WOmW1E=; b=Hi06oMy7rNYVyki85MGbBgUyFf
	GVNYzky2kcF5e4idbC8qUqD8qT85YSNOL2o4ywQM2lXTXlUSQssCcgO1bH2GyYFBcjT/AkVZq0E0l
	o2A84UhxOMbekDuN0BLkPnwb8xNZ2k+O7Id+Hsc7DXbznc6UraT7kmyQYBJELJhK4Fh8ASlaSHUKy
	oy6dSItstNbocE6ziqx1wWHL8AV0tU8LHyuyNzmI9yJamEugX04+Zrx4dKHLi7a6DKtW+G8Kr29nR
	T2Pc6nEE9MYoAyvY2Rf0xs9N5WabpMRZX8b4bGCHmmB/1s0YxyQ2xxA0WzSE5gEXBSnZQvqZn/Ud4
	33BxRXRA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vBR1j-00000001UyY-0yaJ;
	Wed, 22 Oct 2025 05:04:47 +0000
Date: Tue, 21 Oct 2025 22:04:47 -0700
From: "hch@infradead.org" <hch@infradead.org>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
	WenRuo Qu <wqu@suse.com>, "hch@infradead.org" <hch@infradead.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
	"djwong@kernel.org" <djwong@kernel.org>,
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"jack@suse.com" <jack@suse.com>
Subject: Re: O_DIRECT vs BLK_FEAT_STABLE_WRITES, was Re: [PATCH] btrfs: never
 trust the bio from direct IO
Message-ID: <aPhl7wvyZ8b7cnLw@infradead.org>
References: <aPYIS5rDfXhNNDHP@infradead.org>
 <b91eb17a-71ce-422c-99a1-c2970a015666@gmx.com>
 <aPc6uLKJkavZ_SkM@infradead.org>
 <4f4c468a-ac87-4f54-bc5a-d35058e42dd2@suse.com>
 <25742d91-f82e-482e-8978-6ab2288569da@wdc.com>
 <f13c9393-1733-4f52-a879-94cdc7a724f2@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f13c9393-1733-4f52-a879-94cdc7a724f2@gmx.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 063CF20009
X-Rspamd-Server: rspam03
X-Stat-Signature: sj89gbewmjcagn6rs5fxgsnzbmjr8cbj
X-HE-Tag: 1761109490-196028
X-HE-Meta: U2FsdGVkX1+NYNS+H5D2TXuOx4/46r1D2GkcXWMRsf8cYbqDfV1bZTvOVXg0M1Ty7QQtXewspcYidFpSqnvNU8pCtl26ns+FFsnRyO/Wd++pFqjzQdYc/2fSDhQywyJx6acnXsmwGttXCUcKWmfm1nJxJ5yI338bytp4N0791GbwkieXiHoOreCvP0aE6nzxaPvO6jVupuVnYzMVD8Mstf4whXWRchI5C2PoZd34iCHMtmyHsAEO/8upeXO7KYS8ZKgEeT2QzDm4TH6vfQog5v3Ol0AHU5pMphcnGKOjkHW0G+lVuZrdb9YpHWjCEzacW3Fr9WtP5iDF/GybEOWezMJ3BIpcpXSpAqa4EiT7CmKWlkHSF3UgaVtoWqYA8IVWmrWYGyzPERbKS4nqWKXoeq7gDWa+NygWT+mUTYrUjd5Z6caQon2MGb1AHyWRXv3XYgRx2DFq9KWFC4a9BRqpccSDltetdeNC3AmF/n2rh1VlPtba68qrIttLsBr/rQpU9pqKJksSyJUmeKxdO7zswpPvtG4uX8fNpLBs5apzVSvMCfcEthq28WOwn3OeUfK4ehnKWzhb7L0e1Ayk7UQPSH4ZahJZvTl6PJ1PLE8cODDrC2NIOpc1EOqsJyI+UuwhZHvNybp1klhWON505snHEHoEmFO3OisOGtkCoWo/XLo/fFLTB1s0v2ZHiXaeEVOMRskaVwN9TuNPllQ+p4EMZiuRFSIJ+DIS0Lm76KeKI7NKY6+80ZkVJN8qzFXMNSAb/6benazDfHisQqlE5Q28GyEELzHf/yCA+v1ejgZPZAL5t1IoH9hMcl677sSGDIedmm7h4EJ8LpEpkbn4jTJDTFBQbQWBLbLQZ7SE+4OKwh7Ku1nZT7u9PNEO5esNT86ZcpD6c9u2APVrOwBXdI524HDUqdw91J+4A2zKA8MYOhOgfglM4o9jMMR+q9rl2QFrpUx+IFjgrqaLKEQP+ST
 dhp2COOv
 suRzTBdTBXb8+/8ivJIwa4rPo4EuDgkLw7CXBHRSJFNbA38Lya8Wp2zBpj0ciTmvtNgAg668EXIunnO4mThs8NtaxojftiedunlHpHNliqMeco+TuJ9rZ55DohLiSbgvXyBotI+JwccytPUXXmvx0DGukQMqp1OMQYVAQarpi/jQCBxvwkMVwa5HtOt+eVzm+rUbT/ZUVxoHULjFM/NTTA0uygEnzIpxoC+AZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 12:57:51PM +1030, Qu Wenruo wrote:
> My VM is using kvm64 CPU type, which blocks quite a lot of CPU features,
> thus the CRC32 performance is pretty poor.

Yes, unaccelerated CRC32 is a bad idea.

> 
> I just tried a short hack to always make direct IO to fallback to buffered
> IO, the nodatasum performance is the same as the bouncing page solution, so
> the slow down is not page cache itself but really the checksum.
> 
> With CPU features all passed to the VM, the falling-back-to-buffered direct
> IO performance is only slightly worse (10~20%) than nodatasum cases.

I'm a bit lost, what are the exact cases you are comparing here?


