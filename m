Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82C3BCD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 11:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68106B008C; Wed, 10 Jun 2026 07:34:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B18AF6B0093; Wed, 10 Jun 2026 07:34:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A563B6B0095; Wed, 10 Jun 2026 07:34:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 93FCC6B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 07:34:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5147E408AC
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:34:27 +0000 (UTC)
X-FDA: 84863794974.14.EEE3927
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5D922140004
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:34:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=X8o7G3dr;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf26.hostedemail.com: domain of BATV+081cf7365c78a3b9f81e+8326+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+081cf7365c78a3b9f81e+8326+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781091265;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J6hoPXLvOx2TCA04yMR1djb76KWHLJVHc2qvhWJmOVg=;
	b=LMBt7m2kAMHf4Ngsk5WVRUX0VXff0HL9byf4EZoaSNK8QIDQZnSIXQvCAtLhuRO70gmhaL
	cwmZyKagfQQzrMVL4IOqdS4hucfi8A2+ZswNtOMJV/r60dhUdrUr3vEzNPAueClrOBy7q4
	cimBsWCd71Csxo3YmdN0J3Mz/FYTFaQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=X8o7G3dr;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf26.hostedemail.com: domain of BATV+081cf7365c78a3b9f81e+8326+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+081cf7365c78a3b9f81e+8326+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781091265;
	b=ShthPLWqayEK5r3O8Dfz2CdzgrKo6CIfKxkN0UpeXYXLsw1ejJAa948HIJ/c5aB6jjka7Z
	LZd0pJLA/uDVB83OM8mr1bOJInAOCQu70wXp/6+Jrzy+zegRSg8WJn16UWULI+zGyzW5YO
	AryQY/0XfLJX4EijisGuYysFOBpXrhY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=J6hoPXLvOx2TCA04yMR1djb76KWHLJVHc2qvhWJmOVg=; b=X8o7G3drVcOXM+/TpI2tFzOhkP
	P+GddtDvp2pcyv740wKRQAwQ86oEtCJXElaDEVU3xXw6NMUe09t3i+I/y4Gy2LaNxWs4SavNjxxbA
	2bI8d6iDEqIo6r3aRUBUy7lP6q0/j4fdw5S3JIe5VcLvkNTG+oqL2jFV5uMajzkRvBMc6Gc0SrH8C
	Ob7UActExDvwWTL2K40r6rxwQjd8KTodQrivPka0hP1PcWGPHWu1LQ54JVLeDi1k+dwx0LbLl5Qag
	m0Dna0idaCifxxntWzhZNWcDEJlnNxFv9AywFjTHAjESdqqJWDlBqVf3QmhF6kInPlW4BdTCFDcah
	n6VMPwnw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXHCN-00000007Y6Q-3gpC;
	Wed, 10 Jun 2026 11:34:19 +0000
Date: Wed, 10 Jun 2026 04:34:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, sw.prabhu6@gmail.com,
	axboe@kernel.dk, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, dave@stgolabs.net,
	dongjoo.seo1@samsung.com, Swarna Prabhu <s.prabhu@samsung.com>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [RFC v1] io_uring/rsrc: add fast path huge page handling in
 buffer registration
Message-ID: <ailLu70plC9WK2dB@infradead.org>
References: <20260608062937.804758-1-sw.prabhu6@gmail.com>
 <c924fb59-be47-4fa5-adbf-a50a831ccd7b@kernel.org>
 <aikBIESiJftxBdfL@infradead.org>
 <f2b5189f-10de-4685-97f3-6ee08d159743@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f2b5189f-10de-4685-97f3-6ee08d159743@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Queue-Id: 5D922140004
X-Rspam-User: 
X-Stat-Signature: z6hz3chyne7fi5y67cd6ffdo9ujat8y4
X-Rspamd-Server: rspam09
X-HE-Tag: 1781091264-209222
X-HE-Meta: U2FsdGVkX1/IJSnK8bjAsHy95jrvt8JsuNaqJ/xzW0+cmo2lVUrku2MAr4ABf0fL1e0LvEWINPl1jfHUDRAHQi97aDah9wUEH0bDdObFVpeZoPbYPl04PV3edUvaFmSqJf7v3AUgv8hoLmVD9zr9LfkqBq9vsjzWx98PdPojFVQSiNu8+IYqFh+Q79C0A4f2WLOj8GpqCFP93F/PtCkhkoCmq4xb23ByBnis/VkIAhG3jPPdAVvmNJpVnI3v7iPoUkujoe/7EAxgx4zdLGADSoEL4fJKYkpr2F0riZbJ2BBF21AwoJB1YaiU1xDPx76b8RjZ+4Jxn+whQ2S5WzJZjuo0Qsn1wO40HRi+HyCc7CC28gwRoV1156AvH8TImoUMzSm3OkAMnMboxwfZF+UI51PY6atSPLJ3ZiSHJ54yj7X3w4ah1ifnacGKsaiItAwZigq9sJLLDX+NvDo56dD1UyxE4PaaIoMJqcUy7cgqbBbEWMxvgsxo6tApPuw+gpDVxeXMZmtiXOhBD0ICpScgUhf2+EBstb9dNeLrVMf+vJjbKNjCVpBwHDwm+FZhd5UieZRaty+WM8ZmCjBnwToW2IMkSg5UOrOR0bxB+7IUwRpNMt3KrynoNxn9NyQju6NcRiqxyKa47D46R0Wu9JZkMu7oR2ur7XklGQ+aVfsiK1ocEkSjHXNe6cUV9WmL11A5EtGb8cHO1Sj89raCOFNeM1Dt5AeZO2uY8IAbJ/XVPr7FqK1UiQimWaqcnfAddl8gl46ZINKp2d9IUMiGmNljplf45WyRv/YcbKR80e81INh6Rp5m6+D+WFuBy1fUjoIf9M8yB01QCgQ+nQGgRC36fr85xWr7x5LUhxnclBOtKlNIndbn2QWasBvnKpSUGmZX99DTv3jOl921Es1CdKbUHnmT7HwGN8l1cRWaFfJGKrHpVvmUuS5EDVAh4cReIvGocc6480L/Aj9CaowpcaF
 Q/5NTqTj
 fJMO0FFS1aYBlWqqIWUlL7o8QPEhkml7/UoVlzIZZVO2nLkL5uadI21YjiiZy/OMczcYB4HqfZFVQ+Bico7y/J7q2ReyzvFKY4nCcXIfaOQd+lzSviJ0DugafIXQ953D6qIBU9KZarlsRG0jM+7mrK2nrnwOxxw/FLbjEWMtZ7JcPp1+cAVdcL5YnTCjE1skYKq42hIyCv0Z52TcF8HA/+klpOnFUrD7fXJ/Ho/BZsW3L2m3STkB1tHcEhOPk0qjOrjTTQWZPlI29XfyKX7fsGx90DnMAgOhr2fyjlSs5wPEWbXjLxMQR/EGNEA/38CnJ1fKgY7Z1/jWz5zIWJcjnQWjLbWr2N+bYUM6/CS/qAivqYO5ijcnAm6z9VpZ4B9TWThK00OMfiGtHtTlYDweUQjenZPbkbevj0LCbCqu+gAV9eJImkZ707AU2iOlrM+Jcj0psIMVA+PP4l8vax7OckekLM+g5xhHP5iJVKJM4GLyeIMwNaLg8NI1+OejgnXS/p/9+aUKzJNKX04ty7oR7+91n6izwHmXitBddKeqIjCLerhE7JNSMX0Q9eLWLpDAX1zytW5JEgGvL3eA5+wgtGQa6OSz2UZyvIV7zx/+gpkUNgfZJINrDSsq67sBWnh7vkh9dhYlz+9sgt/qjAD89fiyOneWork2KwBjY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 10, 2026 at 11:54:01AM +0200, David Hildenbrand (Arm) wrote:
> > Yes.  iov_iter_extract_bvecs and thus the block direct I/O fast path
> > would instantly benefit from that.
> The tricky bit for such an interface is that, soon, some pages won't be folios,
> but we could still end up with non-folio pages in the address space (e.g.,
> vm_insert_page()) and have to pin+return them. So using folios is not future-proof.

I'm still doubtful on the "soon" beause of all the issues like this
in the I/O path.

> There are some long-term plans on providing an interface that would abstract how
> you refcount something you GUP'ed. (because, some pages we GUP in the future
> might not even have a dedicated refcount, all still fairly unclear). But it's
> all not really finalized I think.
> 
> For now, we could expose a folio+page/offset+nr_pages interface, where we,
> long-term, would not be able to return non-folio pages (e.g., vm_insert_page())
> and would instead, in the future, fail the request if we stumble over a
> non-folio thing in the page tables. That sounds reasonable for now.

I think whatever we're going to use for direct I/O has to also support
non-folio pages, especially PCI P2P memory.  So coming up with an
interface that support this ASAP would be helpful.

> Another solution would be, exposing page-ranges (e.g., page + nr_pages), whereby
> we'd say, that all pages in a range belong to the same compound page, and that
> we took a single reference for all pages in the range. IOW, page_folio() would
> for now be the same for all pages in a range.

This does sound like a reasonable short-term improvement.  One annoying
issue with returning only order 0 page in the current interfaces is
that it fills up the pages array in the caller for no good reason.


