Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D48A6CD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 07:24:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E544A6B0005; Wed, 27 May 2026 03:24:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDE006B008C; Wed, 27 May 2026 03:24:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCCE46B0092; Wed, 27 May 2026 03:24:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B8B276B0005
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:24:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 47F4A1204BA
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:24:21 +0000 (UTC)
X-FDA: 84812361522.04.07A37FF
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf16.hostedemail.com (Postfix) with ESMTP id 95B25180003
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:24:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf16.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779866659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j4CFrtHFXnqeFk0+sb9YS9buAbyJi3Egrc9qV6f3e70=;
	b=5yu0zz/jhRFI37+bgntdX/9HUNk47bEU+WGcG0pOB/6D7hSRuIS/9+BP1S77wRx6LPMIk5
	K61tYjqulstqwVV+3nED0cPV9kSFAot3CjOhj+0pnrvYBVWj7oG9O5tTkP4yQstAVhpKjM
	0MBTNTYPXysP6SGi1UXFepMQxcVGR18=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf16.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779866659; a=rsa-sha256;
	cv=none;
	b=r3iFm/qGhbgoIYZmEYHNcftGq7pREBr4VDMDyyhiSC4T24G+8vMMLSzyn2zR+MpQZO1AfD
	C5PeJNEQCzDSB6JyOtoNdjk4E9M5YODwXxbpl8tLAbFPIl32+uzeraPdI3KFAKQxWxfpwL
	FvTCCFWLqe+VxYjlhFMv+F7gkLCcj1E=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2359E68C4E; Wed, 27 May 2026 09:24:15 +0200 (CEST)
Date: Wed, 27 May 2026 09:24:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: Cunlong Li <shenxiaogll@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] zram: fix use-after-free in
 zram_bvec_write_partial()
Message-ID: <20260527072414.GA17856@lst.de>
References: <20260527-zram-v2-0-2fb84b054b5c@gmail.com> <20260527-zram-v2-1-2fb84b054b5c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527-zram-v2-1-2fb84b054b5c@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: fkn9ghi3ejodxbfz4ijfcowmjyk5hwzm
X-Rspamd-Queue-Id: 95B25180003
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779866659-34589
X-HE-Meta: U2FsdGVkX1+kxIy9D0rw6W2shJjmD1C+d0L2Q6J24RgGWGg/i2OFIuswA/uzlpHVLEr7z6R201d2C2i0zmsy+ip3ub3AdhYCpKF9C3DNUB/xNqsDXh+IHKFit4hD/JC1FqVp0OBxU2GtlD+IjC3RwY1nKs4nWRnbjALF3WfoJFgiSuaUy78uJt/LYpZM2R2OE+Gg8BQ2X7ZcWu9UZubtJ50c4APbVoVnftz1sZIo9I7x338hJh/z3SkoAWI6DTYk4duiPKWrPRWPaY0wEp3YeRa/ARhabB0MlopuUrmdVtUQMOpfo9fb46iTPjn7GTUCvzyB8xQ0d+3uC8dJJqW0AQX9RvhdejzUJfHXkmUduVyURfxmXqGUr+0v6ZZ6C88sd2nT36OleBbLx2Z0GSEJt4x5/rFOaXOaNifZjzdghuhnVr2Z1Hb3co5rbuyCgtgSZY1EdMOD4NtBeIaHNetpAG7q9E8YUAwHP7BS12fbOEc79WXFMKC2cKBv1dar0pumjlGfrLEhgxHbZF9CN+l5GoRchfS9xGWSC/Wvr2lwEH8gXrYz9EhAqAwDpwP1F79NyH1wFAMvzOQzNOqYeC7Pk+hWMHLHEsKnhBY9DMaLOCNa4YuA1dcvKYIeGITVB9leIW0XFhSIuuisey1UgKa5NwGPuNWF5g7R7w2eJyW3/0R17Id2rYfRNuNIQlOCcMMkobC5b47Bwm82qKrTH5GLViJYVtFs5/X+aE7DxlEhMED72EM/eQ8h5c/x6dpRlUvh4OYezTOPuY04EqH3l3Kk2wUQDjveK82h9KRu7FIGDCb+uop6GnR1fy1hmfOZfwIR/XoGz1rT+QqC6qu1EslKJMV0UqCYBXK66WE1MGflN99HB01tfe4mKZqBA476MVnyA7Hz0xjEA4xYw5FGnxSAAukrBeVLRovlYr34Jz5AGTZzZVIHsipBH7ADpIzYC8YBVdTU7qgy/0PNaw6gfHv
 aE0xNdb4
 IdK0u6U+P3JLHudblW/xDRmSnLcgipSdQBT/7TX2pqQmjnsI76OnKVVIarwJRNsefK31UgZ0XHJcO5CgA5lAqS7gr0Q3q/kF9ejHHjgrP4WgXg9leSb+zmY7uzYD1LPCqJVOoPNETHFr8K0s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 12:49:24PM +0800, Cunlong Li wrote:
> zram_read_page() picks the sync or async backing device read path
> based on whether the parent bio is NULL.  zram_bvec_write_partial()
> passes its parent bio down, so for ZRAM_WB slots the read is
> dispatched asynchronously and zram_read_page() returns 0 while the
> bio is still in flight.  The caller then runs memcpy_from_bvec(),
> zram_write_page() and __free_page() on the buffer, leaving the
> async read to write into a freed page.
> 
> zram_bvec_read_partial() was switched to NULL in commit 4e3c87b9421d
> ("zram: fix synchronous reads") for the same reason; the
> write_partial counterpart was missed.
> 
> Fixes: 4e3c87b9421d ("zram: fix synchronous reads")

That's just the last patch touching the line.  This bio chaining goes
further back.  AFAICS all the way to introducing backing device support
in: 8e654f8fbff5 ("zram: read page from backing device")

The patch itself looks good, though:

Reviewed-by: Christoph Hellwig <hch@lst.de>

