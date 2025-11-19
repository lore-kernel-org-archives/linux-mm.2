Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66189CF2570
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 05:51:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE7496B002E; Wed, 19 Nov 2025 00:51:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B977F6B0092; Wed, 19 Nov 2025 00:51:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A86B46B0098; Wed, 19 Nov 2025 00:51:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 94A5F6B002E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 00:51:06 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0272058751
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:51:03 +0000 (UTC)
X-FDA: 84126283248.28.C9165AF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id D729740009
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:51:01 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Gl1NeohW;
	spf=none (imf27.hostedemail.com: domain of BATV+806892ee5b7c973308e2+8123+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+806892ee5b7c973308e2+8123+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763531462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oSUCW2aTXazbvbtd8t7tT7TQJ2omNwxbKL/AucooRco=;
	b=LA/UDTR5BQBNnUbxRtVZKeexGtn9K51vP+bfQqUwlZUa+Pwmws+vrYJqI2FJc8QVOytXmw
	jS+S6LXjPwxdHvqp/me55LmtCAryrJgiU0frvnaZLuxqgzcd9aNdfWgY3aAZFoPV7jsMX/
	EwcvCsqBc3k/TXlTYY3Wen3WnGbL1fc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Gl1NeohW;
	spf=none (imf27.hostedemail.com: domain of BATV+806892ee5b7c973308e2+8123+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+806892ee5b7c973308e2+8123+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763531462; a=rsa-sha256;
	cv=none;
	b=saB+ryPKXsSI9/QETcixFTrms2bPpGm+W9Z7SlH3dQ0qq6WI7mTl18sBSgut2sm4v14d16
	dGgkVX04cPuiLcAO3m+fK+YPoYx2egzQ57utDKkWh7vUMwzok3DTJSZxInYwBaRYefQMCz
	s/d3EVsqRDppylx6x6fviA5wuoJZYR8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=oSUCW2aTXazbvbtd8t7tT7TQJ2omNwxbKL/AucooRco=; b=Gl1NeohWW4D63QJy037NIx5AwG
	0hK0i3ORimeuhGTfy4ed0DNW3HMXWUDMF9+ZtXM6c3JgtTbWP4TzcT7yfS3Jdru/LulygCgwo9jOb
	MK8+YlbPb6aCLDH269juL/NLJJUPQ+LvPLV1fPDZvftwQ+YSQJ2WqnG0sQqQUqsYb7XQoLgO2UmHG
	nOl9BEtF/T8Xx+M+E+vnEbw+aD5QzBGs2v0+HNJT4P7BLAbSEqXFxvyM0ckeVaZedGV5irsLEkycD
	tJBKEhTWOUPiM6pE1MuNBha9J5v7mjdcyemLxC9o1TWST/i1IGn10uxmGvZ8MYINZVW9h4zPO/81a
	0n9JbTtQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLb5k-00000002RCL-2l21;
	Wed, 19 Nov 2025 05:50:56 +0000
Date: Tue, 18 Nov 2025 21:50:56 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	SHAURYA RANE <ssrane_b23@ee.vjti.ac.in>, akpm@linux-foundation.org,
	shakeel.butt@linux.dev, eddyz87@gmail.com, andrii@kernel.org,
	ast@kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-kernel-mentees@lists.linux.dev,
	skhan@linuxfoundation.org, david.hunter.linux@gmail.com,
	khalid@kernel.org,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com,
	bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH] mm/filemap: fix NULL pointer dereference in
 do_read_cache_folio()
Message-ID: <aR1awLOhdOXNMl9c@infradead.org>
References: <20251114193729.251892-1-ssranevjti@gmail.com>
 <aReUv1kVACh3UKv-@casper.infradead.org>
 <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
 <aRpQ7LTZDP-Xz-Sr@casper.infradead.org>
 <20251117164155.GB196362@frogsfrogsfrogs>
 <aRtjfN7sC6_Bv4bx@casper.infradead.org>
 <CAEf4BzZu+u-F9SjhcY5GN5vumOi6X=3AwUom+KJXeCpvC+-ppQ@mail.gmail.com>
 <aRxunCkc4VomEUdo@infradead.org>
 <aRySpQbNuw3Y5DN-@casper.infradead.org>
 <CAEf4BzY1fu+7pqotaW6DxH_vvwCY8rTuX=+0RO96-baKJDeB_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY1fu+7pqotaW6DxH_vvwCY8rTuX=+0RO96-baKJDeB_Q@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D729740009
X-Stat-Signature: cnywaoz99a5jme61xy9hdyt8qezatdxi
X-Rspam-User: 
X-HE-Tag: 1763531461-621163
X-HE-Meta: U2FsdGVkX18+KZylsw4pdTiAU0IzWhBY+Rwf7BUCpP+ZUL6Fveu/JsX7LJub3aWR4FnR1KNJwthCXEE/ifXC+BhT2411mH+FEW3hA/Uzm3j4+hfjRVAhBCqzwgVV7DA+TzaA4pxmIBSTpsGjhEj/Rrmfs0qMfUS4vpDNm6tlpPs3C/fqmYEmWMTzeI337XZucQOYlQLFnFTnuS8UVpuf9nCfq5ngnOPMkGD6GT8uQ/PcUHyJmc9oUwF7lTpy1w1bds4I8MAO5nDQiBpPMgbWh4kxBkD9Uf9A/0QGr67W7gzVJ9XN330zlrzDHI6JpJbZ29G70pEnvKjCKNnwpB6fAmaMgGAzWdoJYf76l4qkZinj+UaWfgEfYD45SPHLUibk2HkLN5WkZ3eDSyUnterGn1veXcfyphRtifoLbf0erIiWIv4kZERV6yNeiMlIX6GEXXJcb6ei5cZLTsxEdB4vAiHlHHywI4j0/HXkROt6FwWYxY8tLSzy81WzbK+5iuYkKmPfLAZA51A9B+b6KNpR9/YxJEABI/DtE+S6bwZE06Mw1fpaPcYjJjuwffJggNcgvk8pZV+VBo/Y9RfhPhizs4jynXXDSFtsNGN2VL1cPi3ZZrm/8wvvqaGyG4lrEtw0Pdr/VJu/QMbUJhqa3bVdu6+2JeysjeFRAZ7JPNw2/xEbq1127sCfo8Pr84SOzW5o8Kdb5nv2fSogh/xaAcSm9bwDMcTOuzM2qB3pY4qZblBJ9EYnaEoFtVLM+VQO7blzvxXsh608vuimDRzVWCaHke7rQghsYQDvsmu/gVEwyf4mhK+2ZRaCcZXoVM0CrFxfE5wr9+nL8akyBGC+6mhmuffmqeTn+/2MHHvSPwL3zHrF5kCSleGlsPT+BsZtT7bvJBxFRNiZVzwVGVJZsfhjm5Rhi9w9l8JxtrX4j+zH0bm52ibDab8mamnQ4IVSiN6lOVy2Gm9VDjEHsZyDpR5
 d59ZRi+p
 ysga25lXCAWGr25s/BqVMnhU2RmH5bMWLQcP/J6PiwoXiNpHV1o0CQoQQEJ9+5KNcfR66P6iTj79W5ihoc+VeCJMHmrVv3jG/F+2xJo45/SFecTAgKiR9HdYwz6chyxVD282hMSbaqC9H5onm9ys0cN4TgNnJJEB7+pB5oDk5zVrlaWUBAiVtEkk1Tf7WwibbMeNbBV9AW08qAZb1/kF7Zd0LCEKyLCwJS5kUwOw0G96poShMYjX53p27hjVb7fER4Xgha6uui0JZLuC0UYfEUvL2JtDUTd2xdB7al+OKaEvBa4Xh7z5V3t1EoCfAK5YTJP/GhnMf4eX7hF3s66VwVmJ95agDnHzoEkhecspiXTJ+mWaNLiIa0oBsGHBojY+ZZbVBF6muNzz/r0fPPiih7wduaMSx+LdiST4qqok2a6JzNxFZewcwdA7NM9UF+zpfvzIIQK5ht8Ws2Lt9hxwQbkBDbqwmz7MD6EWyNcPHb2aKvO5j1i6MSzJ20V12Y++DtZSteCqBFxLcpnLYKm8ds8AgvMLPFP1FiM7f72/FIuuYEav3IdZkyxT23iOZK+tEFVJ/9Pg4B3HJWvISbvTAmoPLwvVrYjFhzFcntDMOBngZSU/RXx2mmnImTyRLcbmwU1yrNQRovpye+/c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 11:27:47AM -0800, Andrii Nakryiko wrote:
> Then please help make it better, give us interfaces you think are
> appropriate. People do use this functionality in production, it's
> important and we are not going to drop it. In non-sleepable mode it's
> best-effort, if the requested part of the file is paged in, we'll
> successfully read data (such as ELF's build ID), and if not, we'll
> report that to the BPF program as -EFAULT. In sleepable mode, we'll
> wait for that part of the file to be paged in before proceeding.
> PROCMAP_QUERY ioctl() is always in sleepable mode, so it will wait for
> file data to be read.

That's pretty demanding:  "If you don't give me the interface that I want
I'll just poke into internals and do broken shit" isn't really the
best way to make friends and win influence.,

> If you don't like the implementation, please help improve it, don't
> just request dropping it "because BPF folks" or anything like that.

Again, you're trying to put a lot of work you should have done on
others.  Everyone here is pretty helpful guiding when asking for help,
but being asked at gunpoint to cleanup the mess your created is not
going to get everyone drop their work and jump onto your project.

