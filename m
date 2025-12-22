Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 660A1D711D5
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 05:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C1856B0088; Mon, 22 Dec 2025 00:33:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96F0F6B0089; Mon, 22 Dec 2025 00:33:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 871546B008A; Mon, 22 Dec 2025 00:33:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 74C546B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 00:33:49 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1B99E138144
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 05:33:49 +0000 (UTC)
X-FDA: 84245990178.10.F1DA06E
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4287640009
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 05:33:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="pQF//HiM";
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766381627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIs6CFP5A9jSluqCx+18mI7gmdKlhYCYgDLoMvNckcU=;
	b=vf5D7lM8i0KhZs6BIT+DfOeUi1eRu5U7ozmMQZ7rwrEYZLf/KsyLG1DmBXllknNGGWME3Y
	3w9eN+kFhb10M1ICpWXTscFs4q4UlusUIv1Jxw3xAAfWKs6hn9A5gzaqXVW8B4MLbmrfbs
	s9fAbrk2YEaVEWBiVYq+VcVOzh7Yw3c=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="pQF//HiM";
	spf=none (imf07.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766381627; a=rsa-sha256;
	cv=none;
	b=SKvBaHOdnFyvTib0b2SdpgmSiY5kAdJX4Ci54oPHKTjFbMx5a35D8wDMyqktcP6RCCjxUd
	P/F3OXuywjBsb4g1YqMBPruSuc8StIMTkQe6uuv4Xex99NrAjJXvPvJMzX6N+uirqhOlWI
	dxpOVXfXf5j1KnBKjJWiA2VO2D+ZsMk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OIs6CFP5A9jSluqCx+18mI7gmdKlhYCYgDLoMvNckcU=; b=pQF//HiMUm3sOW88A16V4T6naV
	EjFN+hH0XDDpxid8DYmvlJmgneugAt4nTItrAxHWZfblbwt9mrFqhhCglEYhlLongrNvER+vsY6xz
	XSAnM6xlJzy8ynCZOezXIp56ubY6IFwFGLHk1SqnhSd/7zciM8J4ThSflEUJnP4xNXt143NxpQOds
	Zw8bdSB2li230hMTcC8SlIrQ5DoDfOGjHL39XPp/N8/B7qGzQmzIHsuQIQoA1TQEdQ+VvesdDn7U5
	6svUwlIhCZaHcLeq2HqLYWM77rrqBja/Dj3v/lOoS3pkSBA9CUgUbx5JR/YAnQRIdAt63cUsbu/YI
	RA2HwDZg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vXYYA-0000000BFzx-0oyw;
	Mon, 22 Dec 2025 05:33:42 +0000
Date: Mon, 22 Dec 2025 05:33:41 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH bpf v2] lib/buildid: use __kernel_read() for sleepable
 context
Message-ID: <aUjYNUNygZh87Yih@casper.infradead.org>
References: <20251218205505.2415840-1-shakeel.butt@linux.dev>
 <aUSUe9jHnYJ577Gh@casper.infradead.org>
 <3lf3ed3xn2oaenvlqjmypuewtm6gakzbecc7kgqsadggyvdtkr@uyw4boj6igqu>
 <aUTPl35UPcjc66l3@casper.infradead.org>
 <64muytpsnwmjcnc5szbz4gfnh2owgorsfdl5zmomtykptfry4s@tuajoyqmulqc>
 <CAEf4BzY2YYJJsMx8BgkKk7BG67pj52stv_GRGwZkj3jnuipw+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzY2YYJJsMx8BgkKk7BG67pj52stv_GRGwZkj3jnuipw+Q@mail.gmail.com>
X-Stat-Signature: r9zakzaq71mgwsmiritreq58cqkwpy99
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4287640009
X-HE-Tag: 1766381627-352334
X-HE-Meta: U2FsdGVkX1+aXFNmV0u2ouVQ6U1qKpJvdR4dYw6IXq4NUq7ABTUaw4bHauW16swNYJ61mt9uPo6ICebKa0UzqK5rN80cBbJj1ECjTspn6Tw7PoPX5oWyfqIwg2tEqIhdJl7B/c5XdktNWkkn+gMGQH8wUcGsAlJAmQxBxOeEZ7zjwV20IWzzvJla2vxON/4LqhSratGE8OVoUdYc7f6yXA8R1ZoVMU/0J3u4zyjD5AYVevSRBGnWRXxDJvBZ03DOuuNcpzoGJUa6fg7BbPfX+mmpoVa+Zj0rnMwFSogB7vo95HjM/1gIlxAHrlpKPJ6JAyjSdFaS/x3HmP0IWh3feM/OAkSSLl2hntFNbAPAsa6r+si9y6sgUtiGlIphNJm030dpBVx9+eoNX/ebk2AZY/XXlkY5RvE1K24DUb+Pa7o/4SWQQa3QzXmVJebw1EVdOMbJ/SRh3SYxWmqefIrXHRyV8l+ODHPEDNnxsjGsMEtpNULQmpAlzjG1Ri2LRmNg173sJ2e77Md3cnuLu/g5PeQ5TAvunFhd2bBk95zdcf509Ch3pgxuklGdJTbcYLmWHEtnQYTQ7D6G1GAScAQdP/kExqeo34pwt2qK16Kodq3NRvqQfpuvSb+1mFMBfLvM2mqzyGUg3NufqAV5FvBvmWtbZCGAVcW7tMsJFzK7vvnslokXWUUWBfVYoqJHam+7++v7tlM38WbArBfwHFgpw3t0geeve2U22Avnj34ACJ/WhNIaC1Lwp6RFBB8ckl4kKZYWqRCsS4Rao28R4dzUUjt4WTzWvdrBX4MaHhSva8F0fR7t+KDRIFctR/zQf+0j+jqePE4wdAmzmSNM9D7m5SzA5Xca4gwr6ETZ+CEXJRBs9MRWDPmRiiHhP4lJrK9W+/c0MmyEF2bg1nMLseX9hvDpph6TON6XMRr3vmQNcldYVZvydvVRCV8nCoEh8ZLldAKNYhktdCTQ65PgRgY
 3o89YmRo
 nhG+YO74nVAjo2V9H5Up2HTcqJMVzmEAG8AJL6ZB42DP8/SbtMoGS7nucoVHyFRbDrsXF8suG38jO4dwojfb9bDF/VPtU1hpSgA6DSNyFOzNVlUSqSVEnLGdxZm1DfqoenZB13LDKKI9YiCDeUc/NHXndz6VJ6/ZpzK+igOYTw1cVSwbmFQaFQfbZobzIU/n58q0+/pewQBop7J6PPR7xNqsbgK6fxkkHjSZiqedMsE2cW4p2OOEO93exSGT+cun1/30hAJ4BkDnm/zn6/Wd/ivjedCm5n66t6Kj8brlLeLALfBNUOBDYFXHakeMkgjSF46COcHaiw/7YCNnO75gPKQhF0NtRNk5wtTuHYAU4UsflgECkYNfTVYv/veJLfyNwhCCjb4NEgOySjLa+rEx0te6X9V1kIX2xTecew/viDBLgoN4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 09:42:13AM -0800, Andrii Nakryiko wrote:
> From a user perspective, I'd very much appreciate it if I get exactly
> the requested amount of bytes from freader_fetch_sync(), so yeah,
> let's please keep the loop. It does seem that ret <= 0 handling is
> correct and should not result in an endless loop.

No, you don't understand.  If __kernel_read() doesn't get all the data in
one call, it's not there to get.  If a partial amount of data is useful
(I suspect not), we can return it, otherwise an error is the way to go.
The loop just betrays a lack of understanding of the VFS.

