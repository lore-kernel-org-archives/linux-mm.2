Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0460ECA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 13:20:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B10E6B0095; Thu, 21 Aug 2025 09:20:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83B796B0096; Thu, 21 Aug 2025 09:20:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 777406B0098; Thu, 21 Aug 2025 09:20:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 63D376B0095
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 09:20:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0463F1403C2
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:20:14 +0000 (UTC)
X-FDA: 83800823190.29.916B53A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 456A11C0002
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 13:20:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=obSXaNXo
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755782413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z/oWZca6DvhMtcxXT0BZTEYb3yDuQB6sErtZtceew9I=;
	b=CYKaINXflLQJAfUN0oqgBuonKlTERyMYyOLg7P/LLt60vWR3IkaHTzApyyS1+Xy/ig6tTS
	OCziKfuncPHpPjoElKerbX9i7I8l2dyEPjvGJ0grNd4b/Xt/o9ZKz1AYXZCgcbJL+q1rS0
	MP1c4QvI88p7IU6leWtE9eITy9VevKc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755782413; a=rsa-sha256;
	cv=none;
	b=PPNzmf1rd4JkzbQTY08sAAN3GTBXacOfZM2dwPS59gRa5XNPDBZDmK24w/x1Hq/mc1C9At
	/p5OEXpzc/6K/rK4EAcR5F+adncd9vaJddkz4o7Ja7TinoiEsEW2Tv04juBCa/XNovIbLv
	NlJtm9E/D93Td5KWynxZ+xGtNhgo5A0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=obSXaNXo;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
	Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=Z/oWZca6DvhMtcxXT0BZTEYb3yDuQB6sErtZtceew9I=; b=obSXaNXocIlf2lRwryTlVAqb+E
	6aUrEnyInq7GSVDOTpN5jqByuTaBVLXlqH+qaYXWFsfyOcDH3MXULAO7UETi5uaiD5nglf2jTA+wf
	GdrEX2z+6F0Sa5HgABPZWm0KKQxziHE6PzxZPislz87NSu4VImni8/WfcO/SEEbJL6lnfsfZyDqNr
	q8eBvQQ8koYaC1WHgte/gRmx3eubHAofpA1Fj7+h2ybSft4RQ1CCF4Khp8EM/MnLtl99A170Ilaw+
	jL2NBF+WDFzWkJKVEdF2mzLWk8Qp4dtZwpyLrCpoM87/CZ0JoH/R2hchK1vmYT+LttYoZXOQliz5L
	HVnEAoPw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1up5D4-00000007hcA-3brr;
	Thu, 21 Aug 2025 13:20:06 +0000
Date: Thu, 21 Aug 2025 14:20:06 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Hildenbrand <david@redhat.com>
Cc: Jinjiang Tu <tujinjiang@huawei.com>, fengwei.yin@intel.com,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	wangkefeng.wang@huawei.com
Subject: Re: [PATCH] filemap: optimize order0 folio in filemap_map_pages
Message-ID: <aKcdBrq_xwOeUQTp@casper.infradead.org>
References: <20250819140653.3229136-1-tujinjiang@huawei.com>
 <aKSdsH_yk69EvkMX@casper.infradead.org>
 <b7a1100c-2302-4781-97c3-1146ed2b44a7@huawei.com>
 <aKXCz0QOlE8QkPIn@casper.infradead.org>
 <98f0333d-1ae6-4a5b-b5cd-c8abddbfae5e@huawei.com>
 <aKcU-fzxeW3xT5Wv@casper.infradead.org>
 <bb6e89e1-ff86-43cf-980d-b03b644d85be@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <bb6e89e1-ff86-43cf-980d-b03b644d85be@redhat.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 456A11C0002
X-Stat-Signature: 18rn9sj9fd4jfy31cie3tiw1r3jy6jsu
X-Rspam-User: 
X-HE-Tag: 1755782413-618593
X-HE-Meta: U2FsdGVkX19SHAyc08vhYCBvJnrznlTZhyZgEqK1e+I2WY9SEHDiuPpeeHj3xwvRuyi8Hi6cA/zo0LwzZUgXRb2sdYccjObBsOcBFw6C6tH2gBAp/uGJSdqGVFTwVZVNb76FcvMxbTZFOHlksWSBzalrLloAoty++9P5sCeZqv8zb+/K6LTKkC7ZFieHk4tDmOyvMPQcxaqDX4zAzRwlD6GKZADHg6u+DYX/Vd+ahAHu6lSdFLFN4Mm4/SQSmGg7SN/YV+Qw79ebGoMOKcVAFO9bCPKfs9nJTdkV6/7X2cQW9k0XDNNYR3szU+WpeSucnQWkM8LDMsh61t9R7XHMu1n8p7sASWto1HB7+I2KQPdoOcSdlk2x6uafBD+iD01vD4Ypd2vcz7DKnKhUzm5l+u5xiQWaWdDJz/bffXDZ4iEB9KdMEc56s7/xQtwW+d4v2A5p4JXLFzRgM2By5JDIPMdyGHKHVekyCd6MXQB8ju6Ee9E8ZKNSGPuVxEcO37mlWzFF7dDPbirW6sQUSnIUTYjt+as2eotwCbAgy0neOq2D4+QXmWN7ISKnYh2/0HiAG7j1pQq9bsvKd39yz1mStjf97k9AvEMDYNIZ/PsRWF/d523mx1+ftB09BPtahgGeqY6NyhpGBQL8Sp4FM5OxUgh2dd3QKNql12zQcCgfhRicBQeiQFpJ0iIudAIF59LU2ckNC7hhGJW83zqB7AP0rdpnYhR7HAzPq3Wxg+t2WK/eONnUk+6Ajj9IaGtNs1HitZTEhtTD4rdONMwzHDsoXPIUXhiOm3XrTRkrE8YFZPX6gKx1crXVmG0LX6b3Qf0uBrh6OhGHxs4oSXh8ZKiDGXDhxRqT9egJGgQfkrCh7uDhPTQ6k+LKc8Sx/2v/4FU4e/+FqTFm8eJf28hvwNn/Aa83wci9UQV5zvK2zY5zIbd/lGwQQ5w77F27M1ITI0g9k96jGOaTcck5MIhvgze
 mbxEEkIH
 g72hKSi2fbx6sggRk/IXYyfc1v/Mnq23240RqV8VBU5jpiZFubAWy3Jr1C2IPOQmPZUP/FaMC7ZtcHUsEqZ1OpqaCyq/iNjzrVpFwrekxP3ufmZndDb3r0laikker94AbVwEsruW5x3yzl/R8qpzJYUKDXxQLSXMVPdyDscf8k6CbsuoUjE3nD1eHvVCqCsUBABAd0EHvnrBTN28I31xChfG5hXco7M8b3MqUOClLZ4XGxR10K61P5mnvZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 02:57:54PM +0200, David Hildenbrand wrote:
> On 21.08.25 14:45, Matthew Wilcox wrote:
> > On Thu, Aug 21, 2025 at 09:22:48AM +0800, Jinjiang Tu wrote:
> > > 在 2025/8/20 20:42, Matthew Wilcox 写道:
> > > > On Wed, Aug 20, 2025 at 09:10:56AM +0800, Jinjiang Tu wrote:
> > > > > We should call folio_unlock() before folio_put(). In filemap_map_order0_folio(),
> > > > > if we doesn't set folio into pte, we should unlock and put folio.
> > > > I agree that folio_unlock() needs to be called before folio_put().
> > > > What I don't understand is why we need to delay folio_unlock() until
> > > > right before folio_put().  Can't we leave folio_unlock() where it
> > > > currently is and only move the folio_put()?
> > > 
> > > In filemap_map_order0_folio(), assuming the page is hwpoisoned, we skip set_pte_range(),
> > > the folio should be unlocked and put. If we only move folio_put() to filemap_map_order0_folio(),
> > > the folio is unlocked when filemap_map_pages() doesn't hold any folio refcount.
> > Oh, I see.  I misread your patch; sorry about that.
> > 
> > However, it is still safe to move only the folio_put() and not move
> > the folio_unlock()!  It's a little subtle, so I'll explain.
> > 
> > We must not free a locked folio.  The page allocator has checks for this
> > and will complain (assuming appropriate debug options are enabled).  So
> > this sequence:
> > 
> > 	folio_put(folio);
> > 	folio_unlock(folio);
> > 
> > is _generally_ unsafe because the folio_put() might be the last put of
> > the refcount which will cause the folio to be freed.  However, if we know
> > that the folio has a refcount > 1, it's safe because the folio_put()
> > won't free the folio.  We do know that the folio has a refcount >1
> > because it's in the page cache, which keeps a refcount on the folio.
> > Since we have it locked, we know that truncation will wait for the unlock
> > to happen, and truncation will be the last one to put the refcount.
> 
> I agree that it is save, but is it worth it having that subtle detail here
> instead of just doing unlock+put?
> 
> IOW, what do we gain by doing it differently? :)

That was in the initial mail:

> With this patch, we can get 8% performance gain for lmbench testcase
> 'lat_pagefault -P 1 file', the size of file is 512M.

Obviously the exact gains are going to depend on how good your CPU is
at doing atomic inc/decs, but reducing the number of atomics is always
a good thing.

