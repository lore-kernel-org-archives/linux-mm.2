Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B16ACD5BBF
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 05:31:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46B716B0095; Mon, 25 May 2026 01:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41C6B6B0096; Mon, 25 May 2026 01:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 332C86B0098; Mon, 25 May 2026 01:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22ABC6B0095
	for <linux-mm@kvack.org>; Mon, 25 May 2026 01:31:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AA51540169
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:31:00 +0000 (UTC)
X-FDA: 84804818280.05.FE212EF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id 264A714000E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 05:30:59 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="g4ON/0Fn";
	spf=none (imf09.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779687059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2U0I91EEn9zktr/NrB5JNMRj3jME1frv7H4DRKlkkao=;
	b=EzQBbYguxkTDJBxGkNMvCLiDhCYLTiiw/zZZoU5ipKIziOXBffchNf8B5aWn2ScoVRDj/k
	lYWc0euEG5mCiD8xFaAVPhIbM2oQRdvcdvVtFUPXO/SdN9MPXUSCLRKOn7k2xPusFMZUj6
	ETobqzqMuTc+gAYmdTUtbE7x+cgE6A0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="g4ON/0Fn";
	spf=none (imf09.hostedemail.com: domain of BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+728b97dfb722ff21c2bb+8310+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779687059; a=rsa-sha256;
	cv=none;
	b=fgOkG4V1+iEE5O02gkwnkjsJLvEUtEGKS+Sl+QaCiyIWSgvGdJml/dsyXWXYbB+gKD9t9U
	DRBG62jWp+l6LKfDnoFoLLttl0iu3n1YO+tql58GAp5H0npsvCReEnLhfGXML1f7YMRFTq
	XaPJipcpmVpQryt2kTw/vvltd75GxEE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2U0I91EEn9zktr/NrB5JNMRj3jME1frv7H4DRKlkkao=; b=g4ON/0Fn2ZnumYYz2ZJB1T88cU
	rNHpVEomEVsJ1cxLFOKfkJusvgNbjI14ra30px6ASSOkgnAncCdx1EA8wpz5/7p/1AsnKtwKqlV6I
	9e9gIYLIifhVrQPuTGuIw0WSjFlSiqE27GCrGUkXo0zNRG6mnAv2cvSVoOM2ADeuTQ/A0CpP0E+GK
	cWVO9QKrA3z/8kpOdxQB+eBHDBYZlzyiRaukyYZP7CfTKl0/yONePwuuCWVo0ttW42wxXQGikkP2T
	dIKdMDBG+1ZRyYKO7UEM2j/7KJsUjYLGzL2eXOduhNg10pRUUA+L75zygat6xSUFHxJlExZTn/1b/
	V/+d1fLA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRNtu-0000000GKEh-46lr;
	Mon, 25 May 2026 05:30:54 +0000
Date: Sun, 24 May 2026 22:30:54 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 4/4] block: enable RWF_DONTCACHE for block devices
Message-ID: <ahPejprWrEjsh7aC@infradead.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-4-782e2fa7477b@columbia.edu>
 <f8d509c7-c0c0-4196-9a82-a6f8ae24ffc2@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8d509c7-c0c0-4196-9a82-a6f8ae24ffc2@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: w36rwuztpmbskt3n99wq6cjqpqbsm1j3
X-Rspamd-Queue-Id: 264A714000E
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779687059-112921
X-HE-Meta: U2FsdGVkX19DHsKj4742RUOzapN5fUFPC4FuJjrCms5vjiwJTYA/fo1NOadLdHGPvcRVK3/kMobu62+cATMclturWm/Jg9JVcz6rpDZi/l53CudPNGiPr+c4DO2CRq107sHBIOqS2CC56Lg+M1utNsuMo4r/GUBsn7sQIMcm3vx9bY9gzZqqpogEQIExYGIZg9ry3QAUsoAx1n2eL/ECvi+wspfP863uIJs17yMx2kYw60bih6w4smKAhBdoJ0eql9jvylMif8/ePyyQO9vsPatjnB6YXTfhRwouRBKmxPqvKHxoEW68W0I2mP6p9t0ugEjs1R2lddfKrD9di7WEBxjS1gRuXAzm+2WfxPlLD0Df2fYr1mMDVno4iGreg5Rc+dGzdsv1NCu0GV+3Z0JtkHZKuUJsCNkwC9MwqZVMpUdukWwBmIWL/v8TkVKAq1LOlyllxMNVu+hKPbZN5SjINosiP2Sk3odY20PDAPmNkqU328OKAOiAq6MVBF0pCH1ajHQl0+ptgf/xL0LeESFy132qYGD0ez9cORGGKHI9PCivdCoCuZy4UgFW52T44qXECEG2TuRaB1m5i6B+OW2sp52CUxrCtyepi1bAB+hah0OhM6InNSYBIvdRDy2iSggEjNF9CDdT/bzh9ZP3lg9Pcbl+OuVchEiJ7GZf2G6AG2AAN/EEwDqzvqpsIXxaCcIpelIsaCybMo87C+vS2meV9j2r/EHHHJGLUPuFVb9oafw8fGTt/wgmzMXuN0aolX+1VC2VWhp/rvjqRRXYM+FzA7RVZncFEyXmgseauPL1exFCtOLTpRvc0Ixj9rkCUDap1rtkQJ9IYJOCHEkPMBZNrgrS3xvEt2zRBmfPwDYMDCGL78fU9JtJ5vps6nTf/JbqtK984qd/duRcy+N50VVL7chpmFJ07yrlyIbSMWZGgqZOghGla+PpkvNtRabgY6T/PUStl+ryJdcYFLWcdFd
 qGlwj6QL
 Lhmh5HBBdQCgKTjrzU1xbbaG3F00Xmbp7mwvCWI1WvwkNTp46QVz6YfK3nHlbn6H2kPJTGJjEXR370I2PITkcD99AwSt8Q8hZlYp+rGI201neCKDyQXAb6Bk3ksjnu1u0Offd5585QIdaLohQukp828X3rVGHvna9lSTCOEdrcGNXXQosgAMfi+VWJ29X5RmA1kQycuelRsiKI24eP95hzPPEUL/f5NeqW+8In9Rvb5HC7aCvl95TDzJSVJP42svu5zgRqES76hrOocoWFUyLdUijBBkGv0bpNL32jfRDNZ2eIMeoYoRMLlr8FSSyZ9ALlYY1i1lEQjsofjsjYqlQ+i9opCqPjNi2TDfltGphDr5ARvx5J9Nq5+ABzcrpK5VcwajwuSXuLNhyLCZ7cH4Q+X0LzcxT0g4w9oXsAjVMR2i+D1im1W3iu8akgkLFJn6OdVhnPPAUwD6aNJ8gl2X5R30Nqqxulq/hDoQ9C4iY2i4rveAI1yO++to7Ohex5FIGgacRzHKBnFjZz0JRS58Rql8psX9tIx6An/xZcSGoGk1/kxE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 07:17:15PM -0400, Tal Zussman wrote:
> A: So this actually seems legit... doesn't look like anything actually calls 
> blkdev_write_begin() or blkdev_write_end(), unless I'm missing something.
> block_write_begin_iocb() usage seems necessary for bh-based filesystems, but
> block devices seem to use iomap for writes unconditionally.

Yes.  Maybe send a separate patch to remove these now unused methods?
Or I could do that since I forgot to remove them when I should have.


