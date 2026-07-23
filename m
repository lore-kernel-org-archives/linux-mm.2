Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96E17C4453C
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 05:25:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A2B56B00C2; Thu, 23 Jul 2026 01:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 753066B00C3; Thu, 23 Jul 2026 01:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6438D6B00C5; Thu, 23 Jul 2026 01:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 40C3C6B00C2
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 01:25:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A6DC5A1006
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:25:43 +0000 (UTC)
X-FDA: 85018904166.26.F12160B
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf20.hostedemail.com (Postfix) with ESMTP id DCBE11C000A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 05:25:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf20.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784784342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=LXlH5t42bIDRUaGVCRUioDOAPOPmAyDJilVuYKaUrbo=;
	b=SKO27MdgUSxW3Hw7sx7faf7GNMYiNRwGHpAH7T90+KIjycX2QPRO/F0E2zmb2YkbVS7eI2
	783KVRGk/tfvG8DY0rOwYVUKMRndU0HbbxtPkz61BbQeUdE365xtdiFnp87x3/AL3FfX2v
	PcOvweVFfK5vis5gFdYVhgmA6fZfJPo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf20.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784784342;
	b=Cq6oZ8mtsph38QT1RGHzEF5RdjT5PFjxADee81A5By+BVUGr5Zd2EsSKyXQKgYxOTwvEqV
	4+PLatJfylRYzFFIZ2WYJLyjtjvnk0V9rFZBvIpyeVZhmCCAxhUZPGeZ3TZHQJc+Nzn9CU
	pxiWRn1VKxmf28TDr52iv0PJWRLmDRs=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 14D7C68AFE; Thu, 23 Jul 2026 07:25:37 +0200 (CEST)
Date: Thu, 23 Jul 2026 07:25:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: Usama Arif <usama.arif@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>, baoquan.he@linux.dev,
	akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
	ryncsn@gmail.com, trondmy@kernel.org, anna@kernel.org,
	sfrench@samba.org, linux-mm@kvack.org, linux-cifs@vger.kernel.org,
	linux-nfs@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/swap: revert to single-folio writes for
 synchronous swap devices
Message-ID: <20260723052536.GA7565@lst.de>
References: <20260722130615.3163560-2-hch@lst.de> <20260722163601.1421253-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260722163601.1421253-1-usama.arif@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DCBE11C000A
X-Rspam-User: 
X-Stat-Signature: dwqoguf795zycxu66o17wrwoykdm3j1d
X-HE-Tag: 1784784341-44313
X-HE-Meta: U2FsdGVkX1+XKtcNWd1CzXDTOfNOQB2SkhsTGPO++izwpTxmoFWaA0E8h4Utj+O/7lB5zT6Hr9rAUDPqbEyh2SniKQpL/cy3pURBtxn6TUiBbgddySoWi9n0CSSGwtrYdhDk0aeZqBWGAvoQBRMzkmlP+0ZVl5ujQtNXauK0NpD6HpUzJue6Wq1wlUQ+rf7G8HF/g7VaykT2rU6RpGZY4v+sQK2ksaSspW6TbLNQsNXSJJv0udL+q8xATE4ntMAws0zY63x6Fc4fgUvztmB9lrYvMONsN+rVcKjwRVdMHJVRs/sYcnrUYRMFiP0uoUYlL24mk7pRyeV5hFmI+iHxQXMhwLQdcvKlxrSt9IrEttw0v9te8SkdHi37dZP5sSplcdGUryNIaj+bPoWZ2+NvWJl7CRRm3m3AMonsS9EGCsaHWTqtJrdNw/b6cgcpbxHwtx1VaSCnsD3cuYbEVTYqxtW9DuNP/3f5P0aqc5i+TYQ6DrJRZyDLnTb/YapPIYRJtXvaNNU9S0TjMLioSGYhP0vU+KN916dVtrpAw5pKJ/MkbTT3wJNdeBjhzHXJ1hVAenF7+BUVb0dO+Dsq4BjJKL0K56eR+E1JDBZpP++hk1s285DJmDMZvL3CnsRNMNhFPlcJVSPs4gfZBAqVyQL8cKOP5F0m/SLRegUYVzNBf+HdQ1/arhFEEnQR+VIUypIonDhOmNseLcei2AKQIUaj/d2FbiFR6jeKf3o42gMub1speClqyQm+DtT5wrXZP9MU12c7jHmGlmcTOt+/BaIGXsQaxnSOQ0Ya6F7anbJEkMlKivU76EwEJBcYCeY6boVilu1KtQiaFfM9hVFqM5YsbFj46wiLawCGdD+fbayrnAXSjiEJquAC2nXF2jrhNL+rgDbKtzpf1sF+0HDz66+p7tX87L5BvPnAkT0zmrXXbVAq9/9su/Z4zInPVWe2KLGWOa+bbwYaDbCTRL8O8lR
 pET+WhiA
 jaggpZo9SMh4Cy7FQ8Cn1Lto6JP1N51qEZdvNnlQ1dRjqCwHmDs6YWOoLBEHVt/D4cseYMNe59PWYfe+xlSnenanQk/pj8/O55V0L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 09:36:00AM -0700, Usama Arif wrote:
> On Wed, 22 Jul 2026 15:06:07 +0200 Christoph Hellwig <hch@lst.de> wrote:
> 
> > Kairui Song reported that zram benefits from submitting each folio
> > directly instead of batching up I/O because the classic LRU scanning
> > benefits from clearing the folio writeback bit in the scan loop.
> > 
> > Accommodate that by kicking off reads for synchronous devices for
> 
> s/reads/writes/ ?

Yes, fixed.


