Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 699EECD8C9F
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 12:19:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF5DA6B008A; Mon,  8 Jun 2026 08:19:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA6A66B008C; Mon,  8 Jun 2026 08:19:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BC606B0092; Mon,  8 Jun 2026 08:19:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8E90D6B008A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:19:35 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 33EAF140ACD
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:19:35 +0000 (UTC)
X-FDA: 84856651110.08.A06348C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 74849C0008
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:19:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pK+Z52VA;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780921173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qERTLKCFsdtVE8IpdID0EeMDJispzoTVRSNdOHDPl+k=;
	b=AHlcsV7Sp/zyEuvPPP3a0H1wd4tDJ9KpfupCxLt4uIay26E42SoSByxQypR//jOqyVhQJM
	wjXsP1KrNPq1vZ2DA3gyuKHPiyz7diO5siAM4M5sE2PqsOHwTJ8vYmesWC3a+PC69nLuF9
	c87ttAta8aRHrnO/ZnKaBapzHfH6M/s=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=pK+Z52VA;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780921173;
	b=M3VCWz8oMV2QeA+EfYqhd38nWkooUYIA2zNr6gB6nHmb1DPPQ8ggI56pDLpG0uQYL1sXy2
	W89z6gvbCDTFa6F4kUJvV8NF+3/EpyBNTNs4cLI79425tFd5sz4H7DoFJGDQ78JGYB1lzG
	9lWn7eTN5iM/jZubY9iPlwFwL2yyUZc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qERTLKCFsdtVE8IpdID0EeMDJispzoTVRSNdOHDPl+k=; b=pK+Z52VAGK7KZAkOuITnxC5Vb3
	PHYL5/DgnXPAXjaENesapBN3zjmkmz57XsRw8+bJY+htyOPt5FpciVJww09WW4VYADB/o3pCPBa+o
	ITQzIAQxDQ6ajm9AiQLxeRKpk0ymSQm4RiFaCgEFylJdFsDx8wn0vu3aBBMFnoVGUiAeyyFdMVAWx
	c8DQPYwUDeUtlb8qJqAsFHk64VN+7v1Ku70v/bxaYv3Gm8zHr0rAhg5D9VIF/bbpoDy1u+F8LVNCf
	6dJeaZUFkrrUe7jJTISR/DA18ypFmeTq1siCNdf7QqN1ucOHV34oQQ79CnsjJwfMC2XVZnkKbKRxh
	vh8bnBjQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWYx0-0000000DffW-0nlk;
	Mon, 08 Jun 2026 12:19:30 +0000
Date: Mon, 8 Jun 2026 13:19:30 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Dev Jain <dev.jain@arm.com>
Cc: Jan Kara <jack@suse.cz>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	David Hildenbrand <david@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG?] invalidate_lock not held in read_cache_folio()
Message-ID: <aiazUtNaS5mVlaCy@casper.infradead.org>
References: <5ca6512c-bdc1-4620-9c99-c7525e059099@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ca6512c-bdc1-4620-9c99-c7525e059099@arm.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 6qim9e3hq76jgza93cpx3iax1oyscd6k
X-Rspamd-Queue-Id: 74849C0008
X-HE-Tag: 1780921172-565123
X-HE-Meta: U2FsdGVkX18Se4AC9IL77hOlH6RUF6dkSjrdr5hTfOhpmSWIU2lhLPRK2pecoTTyWXO4QmMSpXVXlKt//7j2lwfV+NT/iwYhT6bsOfY7j8wNWRqrJYZJJ1UhjRsmkntn392eRmBcu6jQPHjonO1Q2/bJBTdvNgYZ3qDw9kFKJlF9Qr7g9tRUmF1gdr8cfzHdClkgDZV/c7bH/YM3Drer9zDxBCFm72wvuTKHlRHI1tjr57HzQYjCkL1G+T3xgSQ2KpRFIIq78dN0tIN23eXNOnxgfD30/ncheFNppPxuZ+53TDZf7ndnxI4Xq8roPrm4U62EFqpRZqc36HO631m6reXZtcQmTosdlKZxcBqEvqkzgrGfqGgqmI5bPDmPi+qCKpblFdjtPbeTP7iKX0PBZjKgp9e2+L0ScwJURz01gYfHkjpPGYYUxCpCln+n5S8GhSg0m8vcEcBgNn7KHCSJ7QMFTsaPGoWH59IdTvLV4eiET4z5jEFD4sZOCC4DLCSV1An/AiD5DT4HkHXtxmPZg0HVp1bM9zRrl4VbXOgtpZ6CZFSj2zKXf3gZ14+achrsoeZLUEyU6IdlK1ZAewHkqnyA8vZTK+xKLeL+Rc/2XdV32bFAR2lSF33bQ2xzcdCbLCFWaD3HEFx6lQ/8tqDQQGlb4ZSmEDGULCxn5OAagkB2gd2vXHOdoOR3jSM4GCy/MYo2+NNK2oLY30bsadqRNj3V3az3bOLfihWNfGsumuZx7ykz8wYA4nyGYPpqdmXhupdLQSUsUqQex4S6olC/vjNp9IAksm0YsBLpw3bwqB7wRQsDy9zHGSmxiC2hNFu6yZEwSHwtB0NmPiQvVwlfBfagjZpRuZRi8r6WSZGRkjNmUc/LhnPWNHgyKRE9Be+ih0aB7stJkja4K3xeJ47VuyeEl/zg/N9e7cpZetrfThudRVeJZS+TYkIEMmAq8TL1I2al+ldazZpxx6QySTp
 dSMY/Orj
 V76eQMOYiHMBRNWKjpqya6G16TspikDFLRuUru3jat9zrVo17zYb+0rWPhZY+uGoNNcoTKGnheoxoSNXfjq1RCkY/U+EPVj5rqZRxPR6/iVsyW7DAMrY1z7fIrDTwH5ng3sHyKtz64zUSPvo0MGSvG/vCDr7AWHpXJMqTkQSe0YEE8XQirbB5hvhJjA7us2/KLdYXSIF4Lb3oikVtvWw8+uu7zb2ztTjEfWgUw7BJQWs22lmW5hyoDtdE09MQH5Rhriz+mJPksib3x9fp3BUcqpfCYEvbSuEiDstKRi3X9oIL3VFa9edtIx4lwq+nd4/KxnkQCQZnWAJSurwG0RcgngpetIn0yE0ufqu/nN5tsxnLx/1FG7b26uT7ZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:54:51PM +0530, Dev Jain wrote:
> Hi,
> 
> My understanding is that there are two ways we are serializing against concurrent
> addition of a folio into the pagecache (see 730633f0b7f9).
> 
> The kerneldoc of read_cache_folio() says:
> 
> "Context: May sleep.  Expects mapping->invalidate_lock to be held."
> 
> I put the following in __filemap_add_folio():
> 
> +       BUG_ON(!inode_is_locked(mapping->host) &&
> +              !rwsem_is_locked(&mapping->invalidate_lock));
> 
> 
> And got the following trace:
> 
> 
> [    0.115587] Call trace:
> [    0.115686]  __filemap_add_folio+0x5dc/0x680 (P)
> [    0.115871]  filemap_add_folio+0xec/0x2d0
> [    0.116031]  do_read_cache_folio+0x144/0x2d8
> [    0.116194]  read_cache_folio+0x1c/0x30
> [    0.116344]  read_part_sector+0x4c/0xf0
> [    0.116499]  read_lba+0xb0/0x1a0
> [    0.116627]  efi_partition+0xa8/0x740
> [    0.116769]  bdev_disk_changed+0x238/0x620
> [    0.116939]  blkdev_get_whole+0xac/0x100
> [    0.117090]  bdev_open+0x280/0x3c0

You can't truncate or holepunch a bdev

