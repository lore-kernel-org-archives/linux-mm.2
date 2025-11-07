Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EABACCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 12:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E03F8E0010; Fri,  7 Nov 2025 07:02:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B7CB8E0002; Fri,  7 Nov 2025 07:02:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81C408E0010; Fri,  7 Nov 2025 07:02:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7178C8E0002
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 07:02:59 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2751C88C7F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:02:59 +0000 (UTC)
X-FDA: 84083674878.20.05AA366
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf25.hostedemail.com (Postfix) with ESMTP id 55140A0014
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 12:02:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762516977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2lk+eauVGT8wyYcNhpNlsP+Z98gSJyLdsosgdBGpljY=;
	b=1XhjP/sPliSny+ZeGJniR/8SmvxMnuSHr4TPX9WERbaxNcGYuG0yftWRanmLjx0ALiP1PK
	jESrZE0Z9ZburBW5lperWkxK1Ejy0leS0mo4esrwk+jlazvXdLK9jxN8cY//QqSXvdzCVA
	1MkZz71jHiGLK4UeST2m0tj6bjX7ZCg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762516977; a=rsa-sha256;
	cv=none;
	b=8ab79KG/iDjplnG9iYeIaWlHUG7rrIgNNHDcKDWmo7EO+TdPvVKHYgEL2JPfZh+rXw6O2a
	TiY1zH3U3n4gUqkLl1x1zD4YatvD6qli6523yOfDe1Ut26TtvzHICe1vQR9gbo2GjihV5n
	bXvQaJ+7zKYvGgGxQuTsS19n63BICps=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A5877227AAF; Fri,  7 Nov 2025 13:02:49 +0100 (CET)
Date: Fri, 7 Nov 2025 13:02:48 +0100
From: Christoph Hellwig <hch@lst.de>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
	Vlastimil Babka <vbabka@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/9] mempool: update kerneldoc comments
Message-ID: <20251107120248.GA30551@lst.de>
References: <20251031093517.1603379-1-hch@lst.de> <20251031093517.1603379-2-hch@lst.de> <20251107032648.GA16450@sol>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107032648.GA16450@sol>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 55140A0014
X-Stat-Signature: h9tg93tddrcu7ffo4yf6fo3t9ntnfem1
X-Rspam-User: 
X-HE-Tag: 1762516977-661933
X-HE-Meta: U2FsdGVkX180a9JQuY1cLuhtBY4QfFLaCSi5yUXZktyPWOgOtAo6RlL23jFN8tPros5dyCYtBqMkS7Q3AFusuW0zmiIJXZOKJ6t9cK7QvTNnoRK2wTLcd+TGsU73Dj7hmXYsAzIapsEpQZZnuMPhMZmwYDTBHA5GH0eZpbZ6hgfxlF1UJR6PjM+bvzOwjbJLE8QG9Vj6FeiEwGG8tH+KvP+tiyt++6FOxCjEgdsxltp+bMuHeT1tJ+ObGNkRiZs23pRhamJWzFSifGpoxR3NJAZb5xBKpGzrtEbHURuMXFoPbGpTlv2GkHi8F8HvvBVguFP5dxp9dG3+7D9OaeLRjEMUzw8nkZUNi+z4YVC/Wavw/kZUarSFoofkircHKkAGVeP8m7HOP9dIlnTIJGbuCLT79WsP2TI9aJJxptcmS/BTriRTnFJx2E0ybIhGyFw5Th5LVyWEIlnJtjmoI3IAYZFQzqRLwJF3Hv2lIo2tvRNR7XTMmDhvD3o/odHmzYeAe4HlrVbVQeHAZWxS97dBjKMWwb+451MY0ycQ9tDqB4efw6y1UliPFMf/y7WQK/Iv+r2qg0Wh2/8h1b6BceRYXFijqQxifYOrnoOGvvSoDwXBVemQ+dbxT8aIOq3FTIbQl2tb+fFIwx0ADpFyaqw74iNO9Kww0Tu8AVgQKgDoel+G54g3Rv/EcvA7dR/A44gMx431tJhudDz7U1qqXF97MVpu/saWiX1A7TE5Adur3iPxpuvYixH4RTirE0M2JBlIKcSU/G6d0JppmCjxiQFNNedDR4WmYte8azsoeqmuILE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 06, 2025 at 07:26:48PM -0800, Eric Biggers wrote:
> > - * *never* fails when called from process contexts. (it might
> > - * fail if called from an IRQ context.)
> > - * Note: using __GFP_ZERO is not supported.
> > + * Note: This function only sleeps if the alloc_fn callback sleeps or returns
> > + * %NULL.  Using __GFP_ZERO is not supported.
> 
> Maybe put the note about __GFP_ZERO being unsupported directly in the
> description of @gfp_mask.

I'll give it a try.

> >   *
> > - * Return: pointer to the allocated element or %NULL on error.
> > + * Return: pointer to the allocated element or %NULL on error. This function
> > + * never returns %NULL when @gfp_mask allows sleeping.
> 
> Is "allows sleeping" exactly the same as "__GFP_DIRECT_RECLAIM is set"?

Yes.

> The latter is what the code actually checks for.

I'll see if I can make that more clear.


