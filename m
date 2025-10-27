Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E699CCF9EA
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 21:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D6DA8009C; Mon, 27 Oct 2025 17:02:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8870B8009B; Mon, 27 Oct 2025 17:02:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79CDF8009C; Mon, 27 Oct 2025 17:02:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68D698009B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 17:02:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF6211601AD
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 21:02:15 +0000 (UTC)
X-FDA: 84045117030.02.A385F31
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf18.hostedemail.com (Postfix) with ESMTP id 215531C000C
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 21:02:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Wg7OHaza;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761598934;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6xkTsJd6g2aZFL4Hj7gV7QoNZnVPDQfNBEK5GWCOHSY=;
	b=e0+vbTrrLsOpUTNQJ4c1phgh4TfrMvF22gmE9uTGjp0EpTK+GAnPfHZrpGSKPP1ziOd+pv
	UQkbcLIi5wkODg6AtQBbv/8nRVnzzjEMRJU/jo2QDNmfETuTh1626NdsAZgEekeYkKvz3/
	4ADYpwneVZp1tpDlhr+UgryOQFsTA00=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Wg7OHaza;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf18.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761598934; a=rsa-sha256;
	cv=none;
	b=cXSsy4nes4QH/GMkkODdSQvWcryVpxtl5LlIbFrEysQxTp5zr1sVMx5/b47gyX4dYmRe2e
	uYYflXE4FbR4rIoePggW7sUkDAjz5FbEMt0l4x93lsmVlwuC5REzOF6cz5lAEHmsnz57uc
	I8jNP/WRF90F05D7+gRfZj3kICIeZQY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6xkTsJd6g2aZFL4Hj7gV7QoNZnVPDQfNBEK5GWCOHSY=; b=Wg7OHazaDgrEuAUSDxxxX6C9em
	HoM0kHJbwQ4SvKHMKqULhXprjGS9RCP37GhxC9DwpOdn2wpuob2/etGxITPtNY4bEp37RPF8olZmS
	yOB5d4AFg1IV3mjDxIhxlhI6iyFwNPcnggY4lsGWA9t6PVvcb7IEBt9bndWInSEwn2vw2s30LiNna
	uylYxaV7ekuJjkf9/7qCGW1NnFfAfasMGKW2Z6XNbP45YLjjAT2ctxGGac3DPP6eN7WlcM6q1XsfR
	s0S8ILhsVtmbkW3ghLuWoAsVNJFpv+XavUEJxGD2GY7DiUfztXZfbc3aTOkDkI+kf/gsKMHfpsozI
	7kutRRUA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDULu-0000000CRqG-1cxG;
	Mon, 27 Oct 2025 21:02:06 +0000
Date: Mon, 27 Oct 2025 21:02:06 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org
Subject: Re: [PATCH v3 08/17] slab: Remove folio references from kvfree()
Message-ID: <aP_dzoKpBqYCWW9a@casper.infradead.org>
References: <20251024204434.2461319-1-willy@infradead.org>
 <20251024204434.2461319-9-willy@infradead.org>
 <988a1020-d4e2-4515-ae92-03298553d09c@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <988a1020-d4e2-4515-ae92-03298553d09c@suse.cz>
X-Rspam-User: 
X-Rspamd-Queue-Id: 215531C000C
X-Rspamd-Server: rspam03
X-Stat-Signature: tbzekejghp934hnzr8qmsy19gqbmwt1e
X-HE-Tag: 1761598932-413472
X-HE-Meta: U2FsdGVkX1+G5t+eekmVbIEZGLuZpnbvJ9QBJLTt19r7pWoaMry8XwiPsvBC7hbkJmWYPPVFPQCtOChPe+HbGA2bTv4ag6Dls6lgMzC84KvBCY1opDa3+g3EZEn91pvUXOJjWdIa5Ii1dssjA+uR6xU8rEjKwkP0JUiAkBxwgrUngoWAz0i9/zpObY2lV5oPcyaqAYca0M7G/eQZv+iC9T3AGdFIPEG0AbXunzMRM1hoTRdXt1Et5lt/c3/JVAiQ5bFKwpfIImE3bnz+I48MrWD53on0TDzryhtkVG9TxarAe98QemDELwrUbB1Q4TSCIU9XVZB/XXSyVPtswN3+Xsek1fgs0je8RYTBC69v05EBPWm0ru0tFfwSTSw3uJkl081uRADomseRLDkQqAmW+7GW8jKJyugafmzar2gA9y+zgd9/3CrjI4E2rGwej7137hNlQ12JNXNEpcze/zqiVxbRswxgqrd0Hj7XvNuFYUoN48gJYLOvhtjiy2kfYMLdqq5M4FoiXOmdyMcpj/OLB/dvWIfyZWugXEhQTLf3SVyYpKTbXf5qKUlF2mWMwHq4oiWfvsu9RVH/3l9CDGEHYUsKrOE1ZojoXf2X5kVFd3cQWG+6mVdC4FGp7ePQ7xvZ748vbmz6a+E3/cXAxHpD5VvAPxziGOOCE72d11Rp4Av9GHd8uSYrY5V4Ly2ei08ccSPqikH9jfGRyicHN+nNcVnJ9G8hfHD1GvJkBH2jMACJ6k158Fdp2WLf3BObZqMESdkSkab+JSXX7KxLvArCLGjZLYKjeBMqZiWomH6I9y0QfnqH/oF57oOxdyFBuxsodoDpygYoJTx4thsYuYUoB64JhUligUkISXd5lcez7Xm+kUitaab1ds7eKWmOy5tWzpXPeE/eUyVEG9lGKTCi3KJWhx1v1LcvGILuQ35hyHyXqI5AvOS4NcB8CDzKdXn3Yvi8WwbTA50U6/7v7Lq
 Xi1kKII3
 CiOLQpnMvynZbhSMZA/GiOKkIk6P7zp9CVZf8YywqBJuYIjO5N0hZt8PEb80Z0p89+mbICEmuNUR8Y5J90ee4oMTa/FHhL2rjJ8mOyYkGozelKsa9I9dF8fz1rB1kuf/p4bxeEa1/sIYD3HCgy5DC7KW9PJdJhFV7q+jHRW8XJRA7+F5DOhlgxpNSh9ywRcUAHo1phZkFf1Bjp9xKLwB9IP9CCbGVmgIJdcL5+zbTDFc2WrKi1rMVF8UKdTaxEz7T547fF+yhQ1KgLot7bFx2Ctf8WA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 27, 2025 at 05:58:39PM +0100, Vlastimil Babka wrote:
> Subject says kvfree() but it's kfree()

Thanks, will fix

> I'd rather restructure it to try page_slab() first, and free_large_kmalloc()
> if it's unlikely(NULL), without checking the PageLargeKmalloc flag (let
> free_large_kmalloc() do it for the WARN).

        page = virt_to_page(object);
-       if (unlikely(PageLargeKmalloc(page))) {
+       slab = page_slab(page);
+       if (!slab) {
                free_large_kmalloc(page, (void *)object);
                return;
        }

-       slab = page_slab(page);
        s = slab->slab_cache;

I'm fine with that ... will be part of v4.

