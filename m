Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B426CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 05:31:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A16776B008A; Fri, 29 May 2026 01:31:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EDE46B008C; Fri, 29 May 2026 01:31:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92B406B0092; Fri, 29 May 2026 01:31:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 85DD86B008A
	for <linux-mm@kvack.org>; Fri, 29 May 2026 01:31:16 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55714A0FDD
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:31:16 +0000 (UTC)
X-FDA: 84819334152.17.2107585
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf12.hostedemail.com (Postfix) with ESMTP id C75E140006
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:31:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ozbubiXB;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf12.hostedemail.com: domain of BATV+07363440a70d19ca35bc+8314+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+07363440a70d19ca35bc+8314+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780032674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=dHKtAEF9jfpQspO9nlrJOtTa69TZ/bb1FcPAlgmeA/KBnDsook4r/hSexfpv76YoG7shY9
	k5PjgRQhksFHW5fApV92doQRMOg4xjpBCCbGZXi9gB+N3gncF1hh5w7qBpwIXCwBW8FAm1
	DqgvcCKVsI6uNJknY9kRRHoqRmM/lJc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ozbubiXB;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf12.hostedemail.com: domain of BATV+07363440a70d19ca35bc+8314+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+07363440a70d19ca35bc+8314+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780032674; a=rsa-sha256;
	cv=none;
	b=6u9npnjfGUUuKxolQzCrFf0ekcNw6ZkcnzqAngc6v+Ss1W6jOgnX4sHN7IROYeueoRRJsU
	uSzulPmi4MsEW0Y5VtbdRnI+G4jcKYE7F9Il3ryD7r+cbKcHitAzMCzwoJpvGuOVGbXLtW
	5lfj08g8uZI3vzymXwvy3AUYv+97Y24=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=ozbubiXBJPbur4vr+f3GbV/Dd4
	5ktHSdzBO+bwAWD893P6W88nAULCSeZmKMm0bNkmXjMiJPNX9Pa3/UWgcIodfHGX9EUJW0hQKit3F
	UXbNDYpntkfUqdDWve/JctGgxD1Si0QZ93vCHAu8TAAJG/HnDnixlSmX5HOi3x+eXUXI5lT6ck2c2
	WxfnorP/bJjFLQJvxcTRN87mWwwF3m3+KiJTMwTmZBiGDfcqybHRFPcRTgTl5YQCkfIVojdzGdaP2
	cvXEgn0XyMWqOf7nk6UB+am3nRuBY5gTien0i4HomEo8wYzuk7S7AwtnZ9P3T/x/QjcvPXrYYzJlD
	OpDSITBg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSpoQ-00000006lVM-0IRZ;
	Fri, 29 May 2026 05:31:14 +0000
Date: Thu, 28 May 2026 22:31:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-mm@kvack.org, Leon Romanovsky <leon@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 2/2] block: Include bvec.h kernel-doc in the htmldocs
Message-ID: <ahkkomkZJDvwbShO@infradead.org>
References: <20260528175905.1102280-1-willy@infradead.org>
 <20260528175905.1102280-3-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528175905.1102280-3-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: 3n47nmskh3c64umx1soabqruyhfwoqur
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C75E140006
X-Rspam-User: 
X-HE-Tag: 1780032674-659244
X-HE-Meta: U2FsdGVkX18XwrQCQFOq55W3+HoaltOw61y+Lm5i08OTWHRZO3nQIqhE8PcxAGIMHI1MvN66mSe7RnepzqGbZIdpyIR0MFuIxHLJ+Viu0GesbMXYtdnl41QNhm01ZC79a9GrL1otucRiCg/9XLQ66vRIPsxZIkNrPjXVXiBozXMiANvFFsX+yHGDrBp0QPQJb8pzuKM1N0X4M67s3FF/Uwy97/vX88lfc32eLK05PD2iSulchxGJMwgebFPVnx+lzqyEljQGaxNmrznwzNxfHvS1FaOjVPwUcso2o+GxFzVvIFQqfIRxQsSIh6VmolTNlR6DNnyFcZgLuBRtKALvwxI6O9bBqO7ojvZb5J7geAxVDRwin29ad9HWqFBwYej5YgwsmtlDaQQK7YFkQE09NacFQqQ8Y/INqTeHfSiV/hzp9OkL7pL+ywMprnqB0IcquyKrL9vURt9HYaTm/Y5bQ4OeAlyeU3XSUWLmyiYNxXi2vE2Cp5a3AdIhBJNp44H7swwISUPw/jZXmUsl2KI2Xmcu8itJ2ACrsK93RugvB49ypoDZt8gvzp23Y8cJ4z88TBwdXctJbr/xuL73rDmf7MiNOFXUl0CX5OEs+AMjadZknpJQDnBaaIYgyR+Se1bgwpKxulNxC+2me6B/74G6CIOTESZASYvSw4GlDx71tW20+1hwXknDQ730gW3GRnphKPK/v47AHUsVDPzFu2bl8RkuGdQqi0Zmy4ZNjJ0yS87Cb0FU6HPZl7CqPmxx0PryhsurAj0pBE2eq2PYH2kV9EA/VOTZ2oSni7/GGvzD/DlrVhXa0569GLpCjR243ogBqmanm39jMfEdKBgOZoXQiv2DTb9Y77l5nDCER/9MqH6fFYV6Kexyka26HFYVxBITzv/ZcCRI//VcLNNK+XoeWrVha+nNqQtManA2k7dxjGttJLzOtFR8LOUuMlhi5y0mgVcLJnkRe/QdiVHrft0
 i4hw9fFQ
 DfsRA1psw39bLx7qgyw0HDyAVI/khkLP0tSHoogQFrLdxh5q8tBlHzOgWB14cnzIlaQKdiGK0mwNB/6RydC5EP8s6+66CYmd+lbA2YM+zjsISMTLS051t8uYxwNTa9OjB9uSTKT93tsycOO4rDXP/YmyHJACaK5Ttp89DA0lV0xLfioX6zvsOhdvKom2SUVo3aeno6stNXAdepq3qw5fo1Hti3qV0dQrubFxuBVFB7P3kwpeMDeEOUMuVf7dWp9Kjka7WNOtI/keL6wg1Ko/jAdxbdfv8LvbSYfuWUWkwezY+/0Wxigu5BrXszdxmet8HP/2dNPfYbohTeVNI4+eU0kL4aYQF9fbwWrW8wrhimSiqcCCQRDACQ3h31PpqoV1ua8qmefUK+ER7pNQ3kS2fBDO0PT5DCoK/w1jbMnuUCAUnZlsZmTRMKDfIVi9XxPjMCTtkmgAQn8dgPIlshiezmjqxtV6lnJLTpGiB8pBKK9cAfGQYQWPr30Cfe5a2QaxMH5ks/Z/6PgOJFINL0OfamT2obbr11DdAHAbYcVtbWg50hz3Bt6KSaPoOH3n3zXW5VcIsCd6LVeUqr5Ox0DmFwF1rwnnlyeM3T3WV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


