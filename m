Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E35BECD5BD5
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 08:55:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A3A16B0092; Thu, 28 May 2026 04:55:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17B2F6B0093; Thu, 28 May 2026 04:55:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B8216B0096; Thu, 28 May 2026 04:55:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF8136B0092
	for <linux-mm@kvack.org>; Thu, 28 May 2026 04:55:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B73B1140759
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:55:11 +0000 (UTC)
X-FDA: 84816219222.20.5F68B36
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 38A4F20002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 08:55:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CUkNRqba;
	spf=none (imf13.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779958510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=Hg07KsuXiGIzEfcRK99ePGS9X9+azF/YC2mlRh64+xkVwZozWqCzuU5doMvXmOdFUtdejT
	WPPMoZk6xTHL5vKtMu6xsiKjjL+hE6WSTVah7aBhqD6wVFiSIBMMYpZygkj7iKrO/SSI3V
	AsAo7EnYWFaeRz/9teRzYxSSCgEHBnQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CUkNRqba;
	spf=none (imf13.hostedemail.com: domain of BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+39a899e115b5adf89e7c+8313+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779958510; a=rsa-sha256;
	cv=none;
	b=rPFxqjJISSD9opX07jFCA+VxoU4FsUYAnJ3F4bKIedns0itAqMFTKzTD4MxmmGLMa27dGF
	FBqBolj/NvfUbUyXAmW92jXQaoqA2ATArQHdEdI9cFBGFR4SGkfh8540X6RZEj33bgnDVA
	88Cy9/inOVvcXLRdcR3vWFFTNsAXZIg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CUkNRqbaq26L+L91UTI3tIw3Xo
	U4ub1Z5qIyn8iP9fXOF1eEev/A+5iX5mG+qbzT3sB+rlefG6x4M1t2WFA81fOxddGq81a0llbWPGF
	zejxCgXEZBj696DSyIhCALDtPm7XQNMiOfTglc1OB2j+Y2Gq/7H680myWVi6mxiNL/c0RwCNb6fNt
	ifMSZtaYfblNtXUxQs+QRlDkkQRCslbMoCKCi+K14sD9S6Cl9XhSWtUh1r+mnAm9M5G8YrZz2kFzn
	dD6ZLtaF3dsbbGfAiVOUDo6ZyurPPkISSpklWQfxGu7Xx3UGxU8PwQaCTfmAtluC2Ss1lo87g9wji
	9f1DZKzA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSWWC-00000005RWW-2G1U;
	Thu, 28 May 2026 08:55:08 +0000
Date: Thu, 28 May 2026 01:55:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	David Laight <david.laight.linux@gmail.com>,
	Li Nan <linan122@huawei.com>, Song Liu <song@kernel.org>,
	Xiao Ni <xiao@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-raid@vger.kernel.org
Subject: Re: [PATCH v3 2/2] raid6: use kmalloc() in raid6_select_algo()
Message-ID: <ahgC7GmRVRPuUf46@infradead.org>
References: <20260528-lib-v3-0-feccddf1cb6d@kernel.org>
 <20260528-lib-v3-2-feccddf1cb6d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528-lib-v3-2-feccddf1cb6d@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: ouo56cjyh4sz4sa1ube1f9mutauk7zfx
X-Rspamd-Queue-Id: 38A4F20002
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779958510-708815
X-HE-Meta: U2FsdGVkX1+Igqww5rErgq4GSt5I63MoSmDI5WM+gZ0pSWaFTrwDdRcGaFGzYHhcCereseCCHtbiJqecTY7NratEtbcHfcC5vQCAYLYhB/QlbJqBcRR9DcgTlLoO3B5LWHe7XuzeAgYhSb1BCUtKJyrqLlBefbSFRC6tnoqRt7hw3JcwFwygmWLIVDZv3cAREa5OuRGb9XqR2xvlSDB9dzvlplbUWy1XBSAvsESPxKoUOgvusnnDcsEbm5pZYwx7FtPqNtd7lFo/ELeI7iED4tdK9XSR74IJzGTqYpBdxqzhTBMA4L/PqZm0DibFCoa2/KEgCN0lLPRBnsFU/N8C/iRwqwBnwW0KUCqUGlFd149QNH7+ssHpNywXhESd+g42KBCWE4DZYY0z6I+WpsStBdwj6AcnDetGfnPlrunhseLUZ1qz3b6f3G2Q/VaB6ejFOhx7xiHvzRpHY4nhw2ZExG3VDvtySxquGSAOip83QuPAZPmpLIszFtzHwAX2cBNg6PAUJ89noSRAmcw/tN2fKDnwKebDN6GXTAAOfKzI8aTnowBrynfsXQ1yNJzuqDC6tCcnupKFjdfbhsJQTYrX0Rzk3tDf9ntEp2stWA/m+xtzIriV0HqHsJT781br3ihnA38SMnZV52GZT0eScG2ANqRClGpRQhEDFfatnCLsMiPz5lR8f+4QZqaL+gkQ8kPE80/VVlrspL4gTv9hoXkai1sPlHKtmEsUFO+Xq86TxNZNX/jtVOxG9GIitIbZxCnMcPXww44PxUN7jNWtALyrzDdONjAphKnJKHqqBlaV9AlQ2lqrQQ6pVC5yE5vEzQs2LqPw+DDOuZZIxr0wGNHK92I+UQnrjj8zQ1FPonEqGy8Kiuez5L6/Ayqrw+Zb5cFb1X5awscx/o1TPfcdt43kT5+0gL+qgSUadLV/4dQtzQICZtn9rM/P/E3RuMR+ANMPtwiIR1648DgthaI4BPS
 dSvxFdxS
 lIEC4EqKyUWtDoZsSXKlWIFQTmbHhntALuCdjdfHAt0ArCN/8s7NgG7dap8ovWeAA/T7rA6OezZtE+PYDM2yLTo7NaTZ/rdl39UW8vMhmmBjLEtbKRYZCObkYjU3BpVMBoxsd2HJI0AWtYjAdegGtzPaxaOrH24No8cQL9vckmf81RUN0RKZBkIyZ5b7vTmQPKMo5ijw2tshCCtSY5JmbsErTalSArHEfcToBvOgQuTJYIxakUEV0cMz7gma6YITa5huFwa2MNi1HsdgB1k0+55G62csCFjjwYNpnDc4Vv31k2zbHoHxkY5HWYAfWYr9edKqDLlAj7JMegU/CzQ5WjI7qWGSlvjeauInre52GtZjdu1X94axBijyvTQpYllqojYatwNJy8Us0hxaXo9UsYbGqYAdBXNe6ksWvICMq1YEZiL9hhZXUD9T5TNmpcMsJUt0cmHrHCXoTAMXyJvyLIhDaQUN9KnWWrczmJZ143heBCxp1Dce2X1OffKLX7k+nFN1gdxwKQMKlOZtZDlh6W20pBiEaieLlsA3RL4jIT4Ajn1Y2P4FKRZ908qRTSm7vP7hlnMUJ/fghNvPDuOM0yXtUhojpF6H6UijW32nkaOoPK6BaWhQJ+cKgDkdLRyGqPk1nSOCO3YRuY0an+8VZcAcOX6wyUSY172kzfzXL7hpEUxa1eWjVbiP0ZKGR4AatAiH14nmb8avpt4GXliAUHABv7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


