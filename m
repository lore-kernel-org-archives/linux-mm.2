Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 984AFCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 15:28:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5176B0099; Wed, 14 Oct 2026 11:28:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95E3D6B009D; Wed, 14 Oct 2026 11:28:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 829E76B009E; Wed, 14 Oct 2026 11:28:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5EF386B0099
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 11:28:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C3AF01A05FC
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:28:51 +0000 (UTC)
X-FDA: 85321614462.19.959649C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 25A8C18000A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 15:28:49 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HkaTxe82;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791991730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t7CoEsDiQ1jsv+tlhphmD5A0y/E12bIMAu8++omEJbs=;
	b=DqFkrqkp6cvuPL7EUqHkc3iDIcGqywIzt5rBSU2+34Zp1M2cygBH4Fxuqyf/vvpSgI0K0G
	5IoVlhGDO845FVzYGHWl8AO2GA8qmyCJO0bCi4XXQPpz1hEoka7kU0YkzMYaoyuURX0HwT
	dtWsbTFJOEVwbK8TpfpQ7UVllqYm5xg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HkaTxe82;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791991730;
	b=xrX/XsEwLsum+4iqW0B0OQQhRBHNS2i8WIlPdcoosYUU0g9S3HhRmI2ScS7uEjvvQoZ33t
	/box8sy3sbYINpqowGM0Ls8FxKgjGjV1NF6K9lKthsVrwL7cYW8qqMyI6+RjUA5Y2C2loh
	P1x0YaDYwDmhab3xdzAgReIHyReyGRE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=t7CoEsDiQ1jsv+tlhphmD5A0y/E12bIMAu8++omEJbs=; b=HkaTxe82hu/bFQSTbhRkxjiCdg
	wjyuZNDWtmdTLnSjkttC3dT0SQtUvsPIWo/kKFs7Cc/Tl4o0PWlXvyPU6hwB+niy++R12oPEDZ49H
	fUlpIflEtj6ZgWkt45p/BlmRmY1Qawvk1qdmv0KFtJsCxMBkUhyzQoTOhTbcxBj+tZLkFYI8dOPBV
	YXArFtljlcMFUYLEOi3HpHl4jYsFHtIkYElhiHDU+Li6NCaVU6YimndrXML15zdWILcEY9xNCO7T8
	KVJutzjpSEPyftDW660jptFrUWhUd5a3fSqj0vwQpr18Gf/ceFxgG+W1hYHT2M6HWP8Md0YvZCp1/
	GDeIQ0Kw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xH0uJ-00000004ndB-0BKr;
	Wed, 14 Oct 2026 15:28:43 +0000
Date: Wed, 14 Oct 2026 16:28:42 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux-MM <linux-mm@kvack.org>,
	"Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: Improve page refcount scalability
Message-ID: <as-fqjiGj5T5NLOe@casper.infradead.org>
References: <CAHk-=wjLjgfwgSZ1RDk4YdNFcV0ntosMO5AmBoHD76Zb3HFY7Q@mail.gmail.com>
 <as6vBoWQGglxXxb0@thinkstation>
 <CAHk-=wiCe2H33izZHDyDHEhcFwUr9fXZk27-WZ2vn_pn5FcZTg@mail.gmail.com>
 <as9rk-T5cedl8Myq@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as9rk-T5cedl8Myq@thinkstation>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 25A8C18000A
X-Rspam-User: 
X-Stat-Signature: 44ue6hpicej4gb5efpmxnendc9q4poyp
X-HE-Tag: 1791991729-716285
X-HE-Meta: U2FsdGVkX1/ibMQkL34jtETTJGyIdDULP8V3R19Zyxab0H+W1Sr2pE+ECBVTxEcBU95xVNJdiChI/2ujU+tIurjD87XZ2GXc/bHp8ncS3sF8VPYcc2eoOW1vhwuY2KPJrFIzdMnRVYVXzbgiDqIP84DVhuaPduaxs9jcFleGWEHAf5lArLA6kK9OmtXJZUKXadT81KMC1NYMh6Zi9pLiwAXoLzL4Iee951qDhBhWCDYzx4gcB8a1keaJNINnWSfNNGACT5JFEa+5szeB8PZ05I3N7LApUWPvaQtLnrQCrnN4fYf1GzHq6m/VF3Pa3jXLqsvnOJxFcxxf7hgDPpdYg6aQLNOx46MajyBzFsKksK9ymoxANEh1GgPiih3BWBYN1XrNiBovMqJ9Z6Pyjz941TgxpJ6uOXKRppaluTuuL5P5iJidTE9QZDSPgi9b9MdRAens281lgnaCV5rvKqzam6ehO1glhEfPipZmT1q+WBhZnFrq60zayTsGbAuuYVCU4aYHscbMNxKaPJaQlEKyZq80Uas8K5ZvLzWEt3LJptbp0EWP+LOecKBFnDV6xEFpHrO6AjIpw+VFWfr08HkIFyUc/OyzRnBFLBMdic2eGfaeHgd0YgyxIV9CWf4MbUoNxlqJWP5NYkvryF0S33MNWj5mWPEKcbnMhEo9tVuPKJGe6FN0gLvWErJ2Ny0CByaYQeYnhW2X+0G43HXJHuIvu6kjQ68PXC70Oo1U88MgSn3c9fKnIAY6hvUdKrsh7dpgjxi7iMBQzAZc0xF+hS97K85u0e9GcQywO09V3NhFQMcilY4B1tXijqLkEBoOjkb5Ek2BZhh2hrogXbexjmAp18LWd8uyeTkZ4Huvble9PDnhYnRnAq7Glc7JupMUmNNZqAHCoN4H73OqqQGxBtsf35viF+xlrwO23ieRlnhC+yiV2V215dGLLx5e7/SO4MD09Lu97VeBc8NmL1nD+7s
 auspbfeO
 jW4dD5RQMGzBITmVts5d4WfutIPaubvs/uvHVLhGVAI441JSyKzcK6u7RnhyafalhHncAnOl/fFR6WS89LxBvjNUGtOOrkwvuk1a7EqAAR+XkZGajxYKonGbTdlvdS/UuJLVKajB7kE9paKH6gExDPRye3sdeDX3gGT8fXMjnX/1TfhuSgDPB20c4S1HA9vq6+DfmkhmX1ffRRmmz2ukd1GDABJX1gchm24bI9O4oodWJ73lexf/Kxh4G+KmVJqbMxNLvl7xpaSCKYig=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 12:53:11PM +0100, Kiryl Shutsemau wrote:
> The uptodate check in filemap_read_rcu_can_copy() has to stay, though.
> The flag only says the folio was uptodate when it was marked. Some
> filesystems clear PG_uptodate on a folio that stays in the page cache,
> and that can happen after the folio got the flag.

Those filesystems are buggy.  We have assertions that the uptodate flag
is set on folios mapped into userspace, and filesystems going arund
clearing the uptodate bit will cause problems.  It's something I'm
working on removing, but since it's all connected to writeback errors,
it takes a lot of arguing with each filesystem maintainer.

