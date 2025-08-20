Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA258CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 12:43:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 492B58E000E; Wed, 20 Aug 2025 08:43:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 442F08E0003; Wed, 20 Aug 2025 08:43:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359DC8E000E; Wed, 20 Aug 2025 08:43:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 201D78E0003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:43:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A202381281
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 12:43:02 +0000 (UTC)
X-FDA: 83797100604.20.ED65596
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf01.hostedemail.com (Postfix) with ESMTP id CE0A740005
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 12:42:59 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sJGlE82q
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755693780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ChCZAA+PNmcIvnMUun4olvJR6cGa/j+xQmctvbDLqgA=;
	b=TaQfMIcQdp9Sb7oHpuauB9uMdh5g8GZI9XYuYp1hLKmQZDrgeXcpkidtmGjvOx9Q4yeyKF
	/0T4UYlQsfcyn70xT62pANzVb7dSvxBQHkE/0gCYNp/jWlWv932sLhPslU9IeNS5tLw7Ep
	nYeBIj0PIRinTTyhk2IUZ1rvuw2LpoQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=sJGlE82q;
	spf=none (imf01.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755693780; a=rsa-sha256;
	cv=none;
	b=C0GKnnPw/X7AH01w87uFf5R3xKmXawG4uCn8FwlW3GQ2K4UkZg2TgB/sozte2PVkSfrqt5
	K5zXhsJ9h/VPeUZEWRzwAd6uJt2fzRiYWaAodXSOK1PJh/8MnMJM2mNewHoK2GpIDkA7+s
	4v+eCuD30Ku6LqXsNV0bDSiM6eqEgWQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=ChCZAA+PNmcIvnMUun4olvJR6cGa/j+xQmctvbDLqgA=; b=sJGlE82q5OpZSI9Q8q569R3tIW
	evncx0/aNRm3ca4zTFX1dLhS51FWVEAOYlUp5XQqwIyijiS+j1lU1zeiTm1BeI5mLMyRkWaF+ZZpz
	LMKjK5cM/wR3h0C3Bp22kSXl+1TKpcdR4SSh+UowyxMFqFawt+EjcE+IB16iq2GPpAq+9U1PxQOPH
	ZjxCDHCUu0J/VbykhJz/GAEhCzv6DJBrKygmhY0XBzTBGr5CP2FIKFomFUncxWcRoAL0E/tDLO3S8
	PiCA27EJS20xJgqotv1rzDQi2Q5bPrbpWzeWmiTlMvP3xfVYH2U/Qnoi15NHokgHvx25CfFCUm99Z
	z4/EwgdA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uoi9X-00000006SEi-0vtN;
	Wed, 20 Aug 2025 12:42:55 +0000
Date: Wed, 20 Aug 2025 13:42:55 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: fengwei.yin@intel.com, akpm@linux-foundation.org, david@redhat.com,
	linux-mm@kvack.org, wangkefeng.wang@huawei.com
Subject: Re: [PATCH] filemap: optimize order0 folio in filemap_map_pages
Message-ID: <aKXCz0QOlE8QkPIn@casper.infradead.org>
References: <20250819140653.3229136-1-tujinjiang@huawei.com>
 <aKSdsH_yk69EvkMX@casper.infradead.org>
 <b7a1100c-2302-4781-97c3-1146ed2b44a7@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b7a1100c-2302-4781-97c3-1146ed2b44a7@huawei.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CE0A740005
X-Stat-Signature: z1kyujomozpeboaw6jk99hwpon5j5h1x
X-Rspam-User: 
X-HE-Tag: 1755693779-739524
X-HE-Meta: U2FsdGVkX1/OHyaBoLnjvvbHDUSnK1wvD2CMS360+tKpj4b2lFf6tnziQCu16HMV7XNYdwpTXz7KNRR2Yf3vher0xy51hxFBvE08ZdrDeq0L0DKgS8ij0cuKLAS48J+wuQuSLRHNy5B2+dg9BEa3UXs/kXUxcLhxqvFLTs6X7VQ5uxaD25j58O7SoYlp0DXq/QtB4f3cMVYdqzVUsj+FYiC1GnYJUO5oj+i2tepkfOJI4zO5nMCADz6IKFtpkJgjFfzYdS6CRhd3A74AgvPuzIhYPlabhvvy0FCAAjdyQ96a1mUm0WDEKoPlqZuKproeODg418rt5LjuEgDNSNDJYQnfeOJh664+LFGJ+rPnPeNun3e+5DwT3K8B6+Vz1GBdLRlBAXgrV8ledu63kXsNTSKaax2LTDxGLdHM6EvIxf6chDKxWq5HXBl8f/xSVFK5hY6fCrbM367deJpEJnpmLPF8OrYNxl8ZH8xvNorLtFTpxGT2YdpQyILkxLmn9YuN4CAc5d3JZ8gtIObghAaOuNlekeTMT2IQSFObjMGO7QBlVrn+0auD2dm5ZHGYHjSJjtFPAgwMmh38taYWTxxk2FZP0HCR0ckDnXt5gxKMUNGpmBubQTmulHNHHQllFPGySD3OburrrAuCPrscFIymyta3KsKfeGbCGDaNaySftAVpAsL57PdrPBAN1zv4i7VMLuu7+NGrCVX3WhCPtPZCQp4c6W8w/S+O3TrNb5/9GsJL+sZf5gBkgTHNc9Rf9SYtaDdzmTF6pJCHhXEFq8GBCrVzMPVSxER36SxUbgK0r6rQh/79Up6Ne+1taTMYw8lFxC7OFzhzEVwwMJ+F+IRbV1KAgsxsrBVCirwAasyijyMiHi+KarRF3Zi3PqQFdBfyYjcAu+7n0+50xNE7o4P47uFMqUVt7Le9ZL8pRoAD4kL7VwOiCGEOkmgAo2g+EjWRQudFMJOBwW5DRVC7gB9
 vQev2rp5
 ayd/o3DCd6tYeE+8bGc6QNAPxbHNF94NOygZcgUw7NP2S/G6zmZ3UiN/x/che0R7ZbA97MAq+Xg/BUr/buRLzp8DimM2FfN+RQJzTWXyrb2sNaopx/tBf5KOCNQ06Wy4FXmAkCRq7PYJfMIhB10OCyI48A4x8plTBnrYLKuGZa4UPD3wVf7aO5yu/BJzIelYWTOqfBFCcVzIC+vAAiEjiFCD3WeLqjI3wyG9JTQmCwo1JT77D8oQtiwYU1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 09:10:56AM +0800, Jinjiang Tu wrote:
> 
> 在 2025/8/19 23:52, Matthew Wilcox 写道:
> > On Tue, Aug 19, 2025 at 10:06:53PM +0800, Jinjiang Tu wrote:
> > > There are two meaningless folio refcount update for order0 folio in
> > > filemap_map_pages(). First, filemap_map_order0_folio() adds folio refcount
> > > after the folio is mapped to pte. And then, filemap_map_pages() drops a
> > > refcount grabbed by next_uptodate_folio(). We could remain the refcount
> > > unchanged in this case.
> > > 
> > > With this patch, we can get 8% performance gain for lmbench testcase
> > > 'lat_pagefault -P 1 file', the size of file is 512M.
> > You don't explain why you move the folio_unlock() call
> 
> We should call folio_unlock() before folio_put(). In filemap_map_order0_folio(),
> if we doesn't set folio into pte, we should unlock and put folio.

I agree that folio_unlock() needs to be called before folio_put().
What I don't understand is why we need to delay folio_unlock() until
right before folio_put().  Can't we leave folio_unlock() where it
currently is and only move the folio_put()?

