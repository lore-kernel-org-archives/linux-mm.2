Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2CA5FED3C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 13:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 314006B00A0; Fri, 24 Apr 2026 09:56:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5746B00A2; Fri, 24 Apr 2026 09:56:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC116B00A4; Fri, 24 Apr 2026 09:56:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0B74D6B00A0
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 09:56:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 94B9E1C0054
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:56:21 +0000 (UTC)
X-FDA: 84693598962.18.CEA3C8C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id DE6C01A000C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 13:56:19 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tWKIRAk3;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777038980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3vroCxHDFErsYYm4AmTQKjBCHv6XEi/bI3pYwGTqPUc=;
	b=NM9jkiucf2Bxtyg4dNSBvDCr4mFoPNax39z7FavwUQgcQ6t+i8XxXwG3/o02qLmD4borAU
	6RS6Od7yRaG8UheL1+SNO6rQujDcCFu1DXL+/1g9DDahsVxcvkMcwEUzR4gsgEt6VqDhKm
	Ywz6h8c7++FPQSMsM61sktZAGEu+uJI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=tWKIRAk3;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777038980; a=rsa-sha256;
	cv=none;
	b=3p+fY/s2SB3ckU+NSCCGt0YAnHi/ttZBnNDKmGXIeq72IiX8e5ijm7nJDiqwIO3PY9IIpN
	U5xCJKIV7sRUqnj9YDQoCwFKoJBgXV1p6FZJQ6V+msPk7juBFob3jC/x0kaCFdwPgF4ZlA
	N2Yc1/7GwJ3eSJD60twPm4r2FETmJyM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C635840664;
	Fri, 24 Apr 2026 13:56:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BB7C19425;
	Fri, 24 Apr 2026 13:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777038978;
	bh=ChyUBkH34s7FeI8qgas9yFITZwgMiabL3SZHFnWYILE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=tWKIRAk3owCEWZorPHdqK5zTy/FQwaqxjq365RJkDdcfwpcqabpAt1Yr4kLsXU8FT
	 uYkiYJmlFLcMNFfsFmd4atsqFvS9zXPNphZ7uPYp8G6wcqaXe1DuKnkv9QI87dU0BC
	 kzoFM3cOse3Rrw5vfor2ChWhUhzkUWqyVa3CGVuU=
Date: Fri, 24 Apr 2026 06:56:17 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marco Elver <elver@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>, Uladzislau Rezki
 <urezki@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, Vitaly Wool <vitaly.wool@konsulko.se>,
 stable@vger.kernel.org, "Harry Yoo (Oracle)" <harry@kernel.org>
Subject: Re: [PATCH] vmalloc: fix buffer overflow in vrealloc_node_align()
Message-Id: <20260424065617.5de5751ec5a5c91910d45a28@linux-foundation.org>
In-Reply-To: <20260420114805.3572606-2-elver@google.com>
References: <20260420114805.3572606-2-elver@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DE6C01A000C
X-Stat-Signature: kjnw5h5pkqhbc4zk99jn5j7xerz3y6cs
X-Rspam-User: 
X-HE-Tag: 1777038979-288180
X-HE-Meta: U2FsdGVkX188+w5alGQFZJJYjBmcokzxAnahYsCn2ZKiSoxNhd5uO8URLr4OMQHU3s+DMyPbSt3vpBysvf7cCTYYRofq5O21a/qgnndAbEycArjEGi6w1zz19sybjlnZrc00DcII+pDsWv/gnDiGuEQ4H85zbIhSXx1memh9oQy8bEG+d787e2jf614kjh3VMSYwrK8XU912QKxMppZqKGaMa9e+D2ZKXVa3C11/20qqUgAnQoAZu/iLSdQi5AK2kgbDSVeXbza4nQOTb2+o5BdhghvJ+Gc4RC26ms5FT2a852mr0duZT59XdXb0hanfxQMgVfKIaffVP3yic5q+4cGaUx4REiYkelf9s2wxAKTiFVTUVawXGlbfdVaAY8DRdjQTYL8f6ZkfxO7e489YwdiDM8/D4bRJ8s8TbFbXyeVc6J52KK4R0Z3jyuM8ogszXnrpsHmaCmaSsaBEs1aqENxV48ne/Lpgy2rmyanb25OUB+BRjPeQ4ybCIGu0GvAz4KcAenD+Q7HOefHQwErMWsDO2KXxE2mTmR4Kj4/hEGYmxYeSs47ThwqSfWBI+OXCr21GBTwYZUA9HomnLyX+EsleHzQRi7ykncrDKpNznXEpI9/RpyOGMkL0iE4oi2/r9S9BvTT11hurcFUAqXV+tRIjhbqH4X38ml9eVBnlVDqMVScwsqeO8G4VE4Yhsv9S1xlUsZmtBqXuoBncT9ilpEDXt4djGWpxgA87o2B01jIx74WGHmRI5PR6lvrw1iNnRAMRdhSXsZdLjbcc7rEZ15ZVHku6nJY2Q2fReBaG+3FYCKffUDFfJBRsswCWppZKR6cC0VAcWMasouA8EzwB5cEnUo1g2OJy2urW4FLg69iJMWtQyUKz1T2eA8UyBqP2kKG3HSB9lSmIaWI9ys0mF5uyWmBP3pmQUYbF3XvxXhdWj/dsqmA3Tj/nzK02zLraQL3m2pXO/Uxl9dc9eg5
 5O3OT1Bf
 iF/oxRin+LmQzDB3tB1N19SZxoJ9DtUlcopElteWSOxrniT4RG2DgG8jLcQOFL6OYaAwUnElFlIkoTgrcXpG+kifhSOCp0TQCuqlaNQS3B6AyrKyRQ37LfXpe0KTbStzhskWblpyVPXpU3+LdiESMFv+bAqQZzEMgI4e5mVlC1gXbj20XrM0dQHuVdX91BkRcLTatQBJ4RjP5PePEZ3wNyDY2I/ZRuNVUQ9hRcHK3jMh+1f4FVROEi5U/JEeqCwYijgFRACH2fPWiUh9EDBvKKNzkfyQR4//eTWiWUbswtmvnlXZewdsvYpEo3OC2FvYoTSenjjaZ+u9RUSjOlte0PiPhb/p5nQHYISUfDe0P+892goWFurno21XaOUmA7eVoBobl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Apr 2026 13:47:26 +0200 Marco Elver <elver@google.com> wrote:

> Commit 4c5d3365882d ("mm/vmalloc: allow to set node and align in
> vrealloc") added the ability to force a new allocation if the current
> pointer is on the wrong NUMA node, or if an alignment constraint is not
> met, even if the user is shrinking the allocation.
> 
> On this path (need_realloc), the code allocates a new object of 'size'
> bytes and then memcpy()s 'old_size' bytes into it. If the request is to
> shrink the object (size < old_size), this results in an out-of-bounds
> write on the new buffer.
> 
> Fix this by bounding the copy length by the new allocation size.

AI review is asking questions about the nearby code:
	https://sashiko.dev/#/patchset/20260420114805.3572606-2-elver@google.com

