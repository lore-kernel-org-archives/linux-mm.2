Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64A1CCD5BD2
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 05:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A16EE6B0088; Fri, 29 May 2026 01:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ED0C6B008A; Fri, 29 May 2026 01:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92A336B008C; Fri, 29 May 2026 01:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 868316B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 01:30:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 399FBA0FDD
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:30:49 +0000 (UTC)
X-FDA: 84819333018.01.C6B83CC
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf18.hostedemail.com (Postfix) with ESMTP id 093D21C0002
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:30:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CwJluKGb;
	spf=none (imf18.hostedemail.com: domain of BATV+07363440a70d19ca35bc+8314+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+07363440a70d19ca35bc+8314+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780032647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=4nSTGN++5wBdyIklTLMIrJIZVW3aSqjsNbOfIfSSCzs+KAaVePgBvdGrdukU+LDBAJf655
	QqpbAN3IyBSCICA6RMaX6Vt8pOu8xYYFLUXh5sDhB8t3UoZ/4TFsx6414QUC8niZ+mD7dY
	eOxxpkL5TSInB/eCc0hb94521b2rYn0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=CwJluKGb;
	spf=none (imf18.hostedemail.com: domain of BATV+07363440a70d19ca35bc+8314+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+07363440a70d19ca35bc+8314+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780032647; a=rsa-sha256;
	cv=none;
	b=u+nvPdtUpCejv0PZ+bVfs0FCJx3kojZzb6J8nCJq5nVls2tsY9umxWO+srGMrcEfAx2irZ
	lAEduKqka9AZH2Zi9i9MHs82/wy72CPLExP8/k63twtSJHk+dcVUZoVFghntYGmAggCsB9
	Q43fqYKTMSuKKQcyGxs/0SjY7QbZ/Vo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=CwJluKGbk0pgZBB9cVqRkZyffJ
	u5FzXI2H5qsdGc+NevbzqTnCBvNFKHYw5gu/QciXhPv2YY+RIez4KuZFNktodgQKKUwibIqeYDLUM
	eCbeLkeWsrvR/KiR58CLFISZKpN27opNrGMO+N2oPC68QHwLH9Ze87aOh2TCUbXS+Sc4i9Q0vwIgD
	UAsEu9p9FT/6gDTMAwl2SW0waTgKi6SeYqhrYjgXaCrqE33tAH5KrSEdViGvCOioFElBdX1k2tmvI
	gnZQhGcC8GY8Co+4ob9SBBbyS2ajE/y9OsQ8zW/GL6EI9UgWxR+dxDuCTxRdHWKzrH6D0gx7zeTYk
	fpqjHPFw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSpnx-00000006lTX-1pdG;
	Fri, 29 May 2026 05:30:45 +0000
Date: Thu, 28 May 2026 22:30:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	linux-mm@kvack.org, Leon Romanovsky <leon@kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 1/2] block: Add bvec_folio()
Message-ID: <ahkkhRsqSZPQXOAu@infradead.org>
References: <20260528175905.1102280-1-willy@infradead.org>
 <20260528175905.1102280-2-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528175905.1102280-2-willy@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 093D21C0002
X-Stat-Signature: jwupjcy6yr788a8afu8uxgq3d6zaop5o
X-HE-Tag: 1780032646-777121
X-HE-Meta: U2FsdGVkX1+eq8BBG/1Ny1Cl6iJlrKa1+Rit4r/3BpTeWUMG14BBXLLdhAFH0KPn6xjmBoAzATcu/gEOsSR8FiangPHufT4DxLS0mXJsEtN7TGZuFViTwwXKcVKKVzYXiSoVFgvYrLqvLC6ZnK2mTs9SvONDrZEFikdIZwW3qssgoPBvEYKYYYlaWvrOCEQsIK3OZ3n0tlcy3fo7V6pMzjZPlFwPZmZ3MDocLvdQNq5CEYv7JvwmAGiHi8wopTjqcGNUcjuED57Zn7ty+7UBxYrwHR/HoqsA9fe+h7P7Pph2X2qa28NslXz2mnRlI2/54/AZET8Z8tOF/1KwMsrcGcGU8ChaqQEoc4RKELVbe9Ida7wpGKPob84KTFu9kN8iw3dqwZs/NMb13cHilUjr++SNS68df5eomTSxjNKLibXp9ZSOI00Bwu+KCFy71fxE2/CrERsZ3nkou1Q0yiZ1fGkAHRl01lu/HNyGtmmkoB5NB3b7V0MqExC2Ux0S2OU8karCYAU17ciNd6gqtbXTDbaTtxYsuK9lER09BFvcj1B9yUYvDQ9HmFfAdJF3oTRmsEgN06LonYKAwffl461kR1G1kqkQmqNpQ6EGmvY0YxCZzG65ZZHzgMd01bVR0TsVJt6rtuSIWetzhQoM1F7OyYO2l+tyKlj6Z7HhRGEOEgAnqkDr6/pzcTvtgknXdin6eXd5+v6I1wCQqEX7ljvJyfJOVYj0AcVnPHfDjDM78fu1Hba77wbthq8Al4KP+pI8xmR7F6XHjYGUxThtsZPJWDmcDX+TmoeON7gFrgkBsxc7oa4Y1fF1gowbTDmpMNqoyQweYrBeWVCHqydGBHOZRce5GIqe/PeZ7uckvdI6kMrnEGul6JY+bjscyfsudqGtnHl/QiTldR4OTOGzFVm9d5WzsweGic+yZGPfOZKXOZpo1m+CftJQO0bHTaOIM7cBizjBxNSSsDUIM7WZA7o
 npdwndqS
 DU+dG605Tf/YgcBgHXNLxVXElb24iEhq4SggttmvkOT85/0s+l6PLTEfzTxw/7Q/qrwZyoqQJ6jNOSjR/BATrBRqQbYFaPJO2QEJ8jheym1uY+2xeZTJyFllCUOX5eYLy1tdFsaALhZFvsS4EqMXIisNcpzn4H8khGZHAoIJ+WpYwVrVjKYXeA9piwheIznUOPAFLLuDzeOnefQYsVcfcVEJEQFhjImhk36nurbi38iLGZ6w1P5tl/CTDVJTC5CBMr8D06e2ammr3yVANzgY5jQCieFnLTvFgGyss1DysxXUFcQNjvuwIXdJNV+WTFNOVUbXdaSfRW4o4n6dN3RkvcT7cg/QDJjOARpiUDHwokocm45QfNaxDYDedwSbVqWIFkyIfawDcLchOAkqlH8HSUnnrJYSp/BNk/h0cRVshAQOC3GXigR5sDvo2iHyNjqPrgkbcAxDydGRBww6dBsw2eKI028IOCCmYKfWZNbwLhXzGK9Bp6ShEeICcF/K7A3AKtFYT+ueh5fc9hn8nuYbPBn1nN4kGIu6TRyEo1bZ3ViPTKzUi3l1sRnTBFkmbsbczHqywYm4ELpUYLKHJYGTgEzs6Fzw8fpjmRSDmlwJfbnXEIA1VpGVux2KRsiKw0+UVGzxqY2nv0HK6Zng=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


