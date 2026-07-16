Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E4FFC4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 203816B00BA; Thu, 16 Jul 2026 10:49:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DC496B00BF; Thu, 16 Jul 2026 10:49:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F0456B00C0; Thu, 16 Jul 2026 10:49:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0B7A6B00BA
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:49:22 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49ACA14011D
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:19:59 +0000 (UTC)
X-FDA: 84994546518.23.6CFFB53
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6B5AEA000D
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:19:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784204397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dU/FhiUmN39PXsVW/yA/rSkGqi0i/ZN0XATf2yIDTuA=;
	b=3CGfHY6mvEJbdkZGsXK0jh+se5UMFTbxFLbjT7E+/ukCD2IyaM2Bkdqhkp4QmdRDp44ZFG
	4RoD0/YG7Ue26Fe66LKVUMjFf+ygx6sU7EObi0bK4scfOwdGFEaJczh5Ud5+NVmigMdBuw
	ZaJ+uSPsMtPBpn1fX6bRGpWxTBIrPi8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784204397;
	b=ibQsOgd2ZHLqo2lDd0uAvDiWuolHdVhL1JSet5vGnrlIc0yqTgjtH5VqtDYF7ikXQ1rr44
	ndMGvf/hJtrjbM58EdySgEsOum9SsZ2dB4zG4gk4ADuPKKon4UnGVy+QWETJ8anKon39Ac
	z8km87mNFiMWxzfn9pBMaPFo2Y00n8w=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	spf=pass (imf15.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 57C9568AFE; Thu, 16 Jul 2026 14:19:53 +0200 (CEST)
Date: Thu, 16 Jul 2026 14:19:53 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kairui Song <ryncsn@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, baoquan.he@linux.dev,
	akpm@linux-foundation.org, chrisl@kernel.org, usama.arif@linux.dev,
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com,
	youngjun.park@lge.com, linux-mm@kvack.org
Subject: Re: [PATCH 3/7] mm/swap: also use struct swap_iocb for block I/O
Message-ID: <20260716121953.GA28985@lst.de>
References: <20260713093350.2154226-1-hch@lst.de> <20260713093350.2154226-4-hch@lst.de> <alZ0fgRSy0RpHxcT@KASONG-MC4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alZ0fgRSy0RpHxcT@KASONG-MC4>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6B5AEA000D
X-Stat-Signature: 4czbfeud15d1bc373rq999r85mnfwejz
X-HE-Tag: 1784204397-996172
X-HE-Meta: U2FsdGVkX1+yssA+jG8lp0Lg68kGgAFWNteD1Mhz5A4J6kSTVhlWWmoc4+MS76cMH//KNqdpo3VmxgpxrRbOjx4ICOlM4eLooWR+egENgZ2KLLuq1MLo4NYvM6hGLzZfCyN2ARPGLGybbBbQwe1XjBc8A2+YyRzKN3ZIqYxctg9PXjHAZjO0as/4qjZtlGJ5Pl0iotn9qenCHBmkDK3WSPQPhO9u114nkp4PqhVE/iqx/3SEQqwl6SOtLXgysd8UH5G5z9ICa+DMl0ngcRo7MRr4NztypM/MjZlX/O1TEYCzXeUPx0JTLA1hewdRACOWrwcrsxaP2fKLpGAui9bz255xrUPMoTHLongFwMDCrvIlwmm6ozN8lc3c5Xx9i+vNp4K/9vbqXVJu8kIfPs2RkMeTP1lCefDteN00b7a1SyCjvujzgd9NEvDNw6DWADK4YRSdJpwYdSAAsGDxFO1BrADbT9TM2+dnHKNlEEPHBfHS8yEExkQQ6SexuJi4eFheZbTRumqo8ejWYU09eplBY2OEAXW8jb+Q3zXD7wf2V3I8JzGLjmWX/COvNNcG/LowDqLD/3rLwXKccIsYfxdf0CayREPMbpNXul8d91iH6VDD0sHSUXp/KE/XcOiHkw9HkpWObcsy5gBRj+rrUS/PVUPADlT+pvmK42s8HOltEkea8sYH1B1230xGVHv4XEYU0/oTOchHNQpthN0ciXbjAB2cP46zAeqEnMs1MBqZZZqMbdvIRrN8Bx0RE4F/2nuxlk4uCMf5vGBXMoeHk/DYGPzZmNsaOxXOo+VO7r9Mg2Ar19SPU0goNdXjtFzqBKuykmQ/19Kjg6kE7vZxCiQdBI2RAVYfwWbrM/HW8vDmJO8qA/VUBlZ6FaEyQhBk0yRRubWeQT3DsAKYI6GxUuyfk7dF7qoLQVlugzJHTOjwEqukVJo0Ec5x3ZCEZa/JmvhLUCGCw7SWPtauz0au14F
 FSItT43k
 +Whpj5qCGXhlyt0gHtLBuVtdUbZR9urWxQz8MzBkPIhaTJnx6C4fctcphIs8hVq6jMIZmeVEbiA/C3BkFp0iO/F6ttv1KgoDgoNMpReaTGmC74Aj6jeK8j8XOhWonCARKnY4yvX8Tlr9SdbY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 12:03:22AM +0800, Kairui Song wrote:
> > -static void sio_write_complete(struct kiocb *iocb, long ret)
> > +static bool swap_can_merge(struct swap_io_ctx *ctx, struct folio *folio,
> > +		int rw)
> 
> Will a bool rw suits better?

Not really.  Bools as arguents always have the downside that it is
really hard to guess what they mean based on the callsite.

While READ/WRITE really should be enum, it's probably the best we have
right now.

> > -	bio_add_folio_nofail(&bio, folio, folio_size(folio), 0);
> 
> bio_add_folio_nofail also increased bi_vcnt, now it's open coded and
> bi_vcnt stays zero, it's not used right now, could there be any user
> of it in the future?

bi_vcnt only exists to assist bio_add_page*/bio_add_folio*. So if we
assign the bio_vecs manually we don't need it.  If we ever switch
to using bio_add_folio_nofail we'd need it, but then we'd already
maintain it in there :)

> So this removes swap_writepage_bdev_sync (which was calling submit_bio_wait),
> we are replying on a later swap_write_submit, and just add the folio to ctx.

For SWP_SYNCHRONOUS_IO, yes.

> Before the series, pageout will detect for writeback finished and clean
> pages under PAGE_SUCCESS, if the IO of a page is done and writeback flag
> cleaned, the page get released immediately. But now, almost all pages
> will be put back to the LRU waiting for rotation. This also make the
> reclaim have a stronger bias towards reclaim files, and anon reclaim
> become less effective.
> 
> I do observe a real performance regression with classical LRU and ZRAM,
> ordinary swap seems also very slightly effected but could be noise,
> test is done on my laptop by building the kernel using make -j12 and
> tinyconfig in a 2G VM with mild pressure:

> Before this series (with 8G ZRAM only):
> 175.39user 125.89system 0:40.54elapsed
> 26581840inputs+0outputs (1186391major+22698964minor)pagefaults
> 
> After this sereis:
> 165.59user 216.02system 1:04.06elapsed <- the problemic one.
> 53531464inputs+0outputs (2550441major+31974007minor)pagefaults
> 
> Because all anon folios will be derfer freed on next iteration of the LRU,
> which caused a much higher memory pressure.

So this is zswap which does set SWP_SYNCHRONOUS_IO.  I guess forcing
a submit after each bio_vec for SWP_SYNCHRONOUS_IO might make some
sense as a workaround, although it is a bit ugly.


