Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE3F9C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 18:29:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CA1F6B00A1; Tue, 22 Jul 2025 14:29:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57A986B00A2; Tue, 22 Jul 2025 14:29:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DF016B00A3; Tue, 22 Jul 2025 14:29:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 415496B00A1
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:29:18 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BBBFC1112B0
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:29:17 +0000 (UTC)
X-FDA: 83692737954.20.700052F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6947D20002
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:29:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sB9XUAqi
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753208956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GDFu/mz0pwf3ys1s8E2ujXi3DodWocfqXe4YmJVkjXY=;
	b=IgPGwKjTvXuGLamVg2G+4pm/phevesMl8t9IwZAu63mpJD4lZo7hG/u+pigeKQuuNePpAN
	6Ec6ibRi999SR7DO39ucVGRrM4Uj3ZfSV4aKqon1eEbBMgjaqn3t90FAh4DTeJ8oSAvYVx
	yLtuH7dWwVVpv+GhHAjYrerS7IRs8bE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753208956; a=rsa-sha256;
	cv=none;
	b=H4mEJwQCOeW9BUB4Lm9PA2VEkDEdkGhjJbfht413ROqLWY4/rIEDKOMMM56MhfQayYhUqY
	y40OEs+ZAonNJrVL+b1CbYFe6OGiAgqhz00dRlw+IHR/q5HWED5WiWqh7K287kz8QzJTcZ
	WeMRWgxzMT4B8Yor3/KpnvTirCzTPLo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sB9XUAqi;
	dmarc=none;
	spf=none (imf13.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GDFu/mz0pwf3ys1s8E2ujXi3DodWocfqXe4YmJVkjXY=; b=sB9XUAqiFBjXc2RLmQPXmrflys
	e6v11okJLstjVSkjYIUwCnj3HLq618qVXNKN1GhG6iPnursItxxQbyYUkzqjtQVAqg2SNuVFAvxhu
	PEopmJAtf8inrGqSGNBjkRmKYOvFDa+MyD8bIwxgN9peLnDdiesA/tR0gz0snfepJOJ5KE0vFMDcO
	QhSeVqtNMCxdqhdJsk4tIycH4WiiTxqZm93nCKmiFD0TJ7lEeW872udL3zVNH94AMXXEARYeUAWui
	hJz9rtwky9CgYI2GDC/rVeyciv/Mje39lt0YF2K4YVEHQ5chN2wuSkrWFeWhuvQZuLd3iOs4WqQsh
	xZZNX7HQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ueHjl-0000000E7Yc-1no2;
	Tue, 22 Jul 2025 18:29:13 +0000
Date: Tue, 22 Jul 2025 19:29:13 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org
Subject: Re: [PATCH]  mm/page-flags: remove folio_start_writeback_keepwrite()
Message-ID: <aH_YeVoEbMzcVzt7@casper.infradead.org>
References: <20250722182230.2114587-1-joannelkoong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250722182230.2114587-1-joannelkoong@gmail.com>
X-Rspamd-Queue-Id: 6947D20002
X-Stat-Signature: 96aayiy86ngq8xu5wjeo1g4miy8f3ygm
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753208955-201900
X-HE-Meta: U2FsdGVkX1/O6Tz7RarbMQyPzcqXx2m0KXhwOuGgY7Ui05XA7MPhpG+wTr/3yXhk1Z2fhEjarwNfDVYg8VXqL5q0bTj17enB8HNMrG8YxKEk3nPZyhgqHb23/1M3AqMYMti9M7jW5uB1+tpMngxIAUUYeG/X216Tiuh1rw6iQ5FsAChsud67Q1gNW2kbSu6hf5AwjuSvzKmdL6ZXt/mHeLCRArIrMH6/FXsl44SQA5/Qnv8cbfHbjR+HOQPP5bS2NnHMDJvu1SPIbeUnuGG9gBk/QrHbUoUnhzpjUruPZLtIO2rV6P3kGrmbzQaJED7ZnseqvGr8GXA3rcUlnvRXxk8zh/lrtpbDBBQYFvl+SBozAiDwHZaoCGaTlkv05CKcXduSip/YngPAthOGKp1YCSOfEkxRgUhS/Wabzqq1+AOHkY/Uzo0fGjuV4jvRF/GeGIF/9WJPORxlbntaPZwQtogKfHuj2m5lPV5yfdXaIQAKhytheiDbeG4AMwuT2ah4hpfEf/iqNETnx5ASOl+2kqqsXSrCnYE0Iz/Fvi982x+hbX4F3R5nb3Y+gEHoqVQyh5+7yFttu7nslHOEIdYLwvrxnI0m9OCNzNVifFyqSnaooQXWcQZM4tk7JyQB27JuBrirZbR8Q+O9r2c4guDihSc32AomEb6cRziov4Pckkki+BWQFt4/T9mzX6lmvN3Htv/N2xHoTkluNnwU2cCXkpgbhQMQ791lQtRo8CnqjAURpYVUAePe1MJZFVGriGf4Febfr8IaLSiAjjTNYS4rB7QRmEfMubaZ+XFdhdEmgGb2VZ2ePfyFagMu4icHPUn0OPQuL0kFIxqDl1cAmGXZyeESFbyxDJub80Pk5YFDY/gMvYfsEHkSOS5MtajWFYeU79SIeK5o5x48AgUjIyTh4isYi8hKKrX1lxugAGtjXqaU1ItP8DWKI5a4lyJBiqgOTQLTgVvq1CrFBTNszEL
 hvfq/Smo
 +oJJq85DDIFyJ6seevQvrad4ZuNR7Bc9LmRxkwc86vfTKCxoeTx/CprvhD2W1PdWRfnjctivcPh0+hcjX0N1wBC8F2wycfepqhs805KQ2/0rJ6eG4lUvqw6HAI3dAeerp43RcIHPh25l24VPQRYbtBTN8vmkrsZPyDvgs7EU8rIjqLq4frrSwH53QBI9LKfO3VkraL+hRYSL2wKyGiIFNMY83zLhAGPeYgfERM72fEXFRazse4uVxOEyUvq+QbsDG0pu4TzYHwhoNu3WOjoqZ6lC0dr6d28H5uGbhdJP1wHn52o/9MbehxE2ZZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 11:22:30AM -0700, Joanne Koong wrote:
> Commit cd57b77197a4 ("ext4: Convert ext4_bio_write_page() to use a
> folio) removed set_page_writeback_keepwrite() which was the last/only
> caller of folio_start_writeback_keepwrite().
> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Yes, it did.  Unfortunately, it doesn't remove the 'keep_towrite'
boolean argument, but I guess we can remove this now-unused wrapper.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

