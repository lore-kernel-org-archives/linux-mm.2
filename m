Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C947CC43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 00:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B399F6B00B5; Fri,  3 Jul 2026 20:50:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEA2E6B00B6; Fri,  3 Jul 2026 20:50:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FF506B00B7; Fri,  3 Jul 2026 20:50:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C3906B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 20:50:13 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E921F120213
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:50:12 +0000 (UTC)
X-FDA: 84949262664.10.9141302
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7CBAF20005
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:50:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RyrEOlgs;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783126211;
	b=WTyfuXuULO94HN5ofhaIrIZnTIvfWso4v0tYQgiFKMBJfcboOBFJ28XTTeaJ/2xWPKzQ1d
	7hPcXb6T021WOt6jEBExPO/YGnu4SOHWT9Z+W0NKAEK3WPzot86TBo3dd+XgaIa+ZmtUO0
	Bbu4+jXKkjbXQaU82jWiUipMNIAJt8s=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=RyrEOlgs;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783126211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XnVJsju8SOFKOP9LIze7WlE4ehpoJpNKlAeeOaTjpUA=;
	b=aO88j4PRtXa8s7J19Fb67FbmylEBYMuhoXbd5zzv2s5C7VQuTEp9zQu4zOTCaLUipqipro
	vsj4k0JsjOWlI0HPO9PFBBQlcRAaeT3EjpG38izBn9gi2C5vQ4KSyHX6h18CSPbKQ+m0AF
	lIhm59eMzNH8AsLoKNH6ZHTwD1GYI7g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XnVJsju8SOFKOP9LIze7WlE4ehpoJpNKlAeeOaTjpUA=; b=RyrEOlgsLoALPcxG8DSTjDNX2j
	ob7fZ0Md7ST0kEweAT5XcAuruL8WQqVzhnxXj4y3I2PQtxOWpfIVXZTcvFkFDtQBWt3qXfz56Kqw0
	dtoVoy5+4SPsCWawmiIhDtJtqjhv0CA9lSGw/MTURELC+Mt897OVUIUNusa/sB6lJXs07cb3Wcj4p
	dozyOH38ldyDA1AHv6rzVBpHfIRf8tNMK3PzGnyNjXZUDUhoHejMudChiVigVM0196O6EL2YoWiAR
	RtFFag7Rk3gWYVa7Uzrfxlka/Nte7kagPh9qGcvSVAjvFB+8Sad70vTrxiSPq9kIS/eeFkq3ruh1h
	gKvV6eMA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wfoa3-0000000B5w9-3YmK;
	Sat, 04 Jul 2026 00:50:03 +0000
Date: Sat, 4 Jul 2026 01:50:03 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Song Liu <song@kernel.org>, Eric Hagberg <ehagberg@janestreet.com>,
	Zi Yan <ziy@nvidia.com>,
	Gregg Leventhal <gleventhal@janestreet.com>
Subject: Re: [PATCH stable] mm/khugepaged: write all dirty file folios when
 collapsing
Message-ID: <akhYu66GmjyM8l6a@casper.infradead.org>
References: <20260702165409.164568-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702165409.164568-1-pfalcato@suse.de>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7CBAF20005
X-Stat-Signature: h3sd7fjjsxp6b4wi3og18cuxodo3y7zk
X-HE-Tag: 1783126210-232125
X-HE-Meta: U2FsdGVkX1/sOoN5YrwXHl5KZq/+n4UjHiT3ykrglt6M2OrP3fIRZT+bePEWRUKEIBzUS5mAv0Zb+0cfEnu7SCV1Qfw8oEZf3XyPhNoljrvVqJJv24iH3xQPeMo7M0q8X3rruJWRPtpOeNfeqBy7C0NTrgwvW2GeJlUBMEZl8nYpl9LlhRQzuNgsK4MueU6+xcBLEzAXgvVtvU13btg1ZI9tVqbkxTZisi4NyHzeoWHyLv0h7Bsh8s3eR9aq1kHifjx4bLiG7NlIeEvikiGFbHo6+looBZ0Aj7ilee/MXDa3IvY8OCmxI1/2Q/3acjkZ866TM4ZF7wVX9bq18kzpU/Lby7JRC4u17gt118XlNEzrPKEkadjIkQcumCk2xNX7jicrYFwQHkWp2ekVtheiImSbb1iLzj2K43jqhrUnHXmeU3dvFdkxzqGdBBGWLpfoQFVacUVFsbRIwFjbQGiuMBv4Hx6a5jli4jzKq3mrFV86YHqMDzzS0aOn6XWilVbkqAu4agqK1qoBDjEgteTVBHHPWadFmn2ojbTcFJCMxBiIbwF+2tcStKwATWq1pvU32rz/Vtwa9RrQATo/pN5xU/HK0VzgNShmCmr+ovBi/sseBgNpt1qaWKbfXo5J5gltztj9k4UjadF4Gx40XqX8MDh4mLYevskZmETB/KOt1mXmqFOKG3l2ZGDJmVBGCQ+wggo2jA5k5Nr0aCpQdqXl3o1C7NgZBgYbp5FyYyuuORspd/9TFZMFAHvjB1r9PUf8f74gQKj0CVXzIubY4tDaZnhkk9O3jFlmQEWBwl27ix4v0lnzUbsB2/m3qE0h6/iUO73QX9FppGa3pifCT6EDnkDR6tkbhWMeC80oNJyF+DP/lfZSiJfaxxSyWt/u9Kfz3X7BYUERkyWXVuUfhNcBQRxTOHBEdrgv+CmEj23z/NGBjayzzMugWeqYN93HgDjA8QZ1SQOJNFptPxAMkm4
 b53q8bJA
 glb+7Wcq38hTzrd0FtUrM2xKPev043SS+wKT1IyLZt5xw0QedgNrBGpO8+JvwhRFa9P5RxXx1e2zwF3jlEfl7jxOvXPW+TmgMpLWkac/fK7GfBX6vHGzvej5fcRStdGv58BzTqiJGiZNihWkLxGmgZrKPLCfJ96qSK7V/TtQtW3/8f9bJNfNv4LRjpfAshIEmkd4sSir6E2G6ICPRjAOzn/rQ+PkfurI4kHeNgt7bUal9KlFK3I2MhedYm4+uQQLfCm/aALh0QpjtDEX4Vj47VXTdQQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 02, 2026 at 05:54:09PM +0100, Pedro Falcato wrote:
> +++ b/mm/khugepaged.c
> @@ -2094,32 +2094,43 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  		goto xa_unlocked;
>  	}
>  
> -	if (!is_shmem) {
> +xa_locked:
> +	xas_unlock_irq(&xas);
> +xa_unlocked:

Hmm.  Before this patch, we increment nr_thps while holding the i_pages
lock.  Now we aren't holding it, but we are holding the invalidate lock.
Can you put something in the commit message that notes this change and
argues that it's totally fine actually?

You were good enough to not point out that my suggestion of calling
write_and_wait in the existing !is_shmem condition would result in
sleeping with a spinlock held.  Silly me ;-)


