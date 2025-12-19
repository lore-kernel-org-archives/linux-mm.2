Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96FE4D74956
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 04:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F102F6B0088; Thu, 18 Dec 2025 23:08:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBDF86B0089; Thu, 18 Dec 2025 23:08:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9F976B008A; Thu, 18 Dec 2025 23:08:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C8C566B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 23:08:03 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 61AA1B9605
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:08:03 +0000 (UTC)
X-FDA: 84234887646.18.CF80E9A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0AEFE160015
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:08:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=o3ZHtDLv;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766117281;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eCD1IBdj7ODKaeO2jXui4z4Z/L646xCoFb81QN9gPBM=;
	b=RpIaUUrdT/4TxJHYZsXS+OW8Ht83064O8ylP/b/Yfw4YQsGBCi4A5twV+Qwu3B2yCXBozr
	oEc/W6+IuM6ED6lQ+PpPZ2tKvRpE5aN5UeX3S37Aefgjw9obApHDKVzaPlWVKL0c5S5kZJ
	uH9gp4RXG1Bo7Q14rMHKVwNfXmJZQTo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=o3ZHtDLv;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766117281; a=rsa-sha256;
	cv=none;
	b=LPy3QmV6FtksDdF44twDdBvcdL7sy/z4WvWdWsnvWfh5mA4njWvryZvH8kI2UV2fochx42
	YQV5uzZuKhAUKDkxNRwNOEfndgQmnp8hHEPa0lFJfD3uB3xlZDHEE76b57ZEsVhGkydSUJ
	r7JvxDjvOIiW8q2RP27TMAGBQiTQuT0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=eCD1IBdj7ODKaeO2jXui4z4Z/L646xCoFb81QN9gPBM=; b=o3ZHtDLvF+Gw0VgM1ijzs6p5Yf
	s7behnjZvQy0gGmbBdkrJBjVQWiIjtRxDQVx2MdQHYwuHrQiD3SP1ieVTwPVqJymDs5fgnNuugwfm
	elP6tKuw7GZyHU4v9AGo5aa441ONdXY+iesx9/A464rih/SqZSte295FrlGrKOdKgZckPG+vJUGdM
	TtzWJpXUA49f1V/TGuvEyQJCsQSmpmz8f5YLvm1Z+ddZIg3Lrp+JbTJuRQVTQqg2Z7orVQmbh0yxn
	cask8wscp2V+WoVlLZ8/JB4WYuFC6s9bp1ZceNAntpezzZ8AfP3KxrtACOL+bpvrWh2M1Z5EWYpgk
	82wnOljA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vWRmR-000000072ZY-1zCI;
	Fri, 19 Dec 2025 04:07:51 +0000
Date: Fri, 19 Dec 2025 04:07:51 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Message-ID: <aUTPl35UPcjc66l3@casper.infradead.org>
References: <20251218205505.2415840-1-shakeel.butt@linux.dev>
 <aUSUe9jHnYJ577Gh@casper.infradead.org>
 <3lf3ed3xn2oaenvlqjmypuewtm6gakzbecc7kgqsadggyvdtkr@uyw4boj6igqu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3lf3ed3xn2oaenvlqjmypuewtm6gakzbecc7kgqsadggyvdtkr@uyw4boj6igqu>
X-Rspamd-Server: rspam02
X-Stat-Signature: tkxuub3a67nzo7bywa4drgjot7h7mwg3
X-Rspam-User: 
X-Rspamd-Queue-Id: 0AEFE160015
X-HE-Tag: 1766117280-410988
X-HE-Meta: U2FsdGVkX197DgYVfEFeGzYVcpcfyf6taTe9oEZMWrXI+nQfkz2/xzfIVh+s+N5BnmbuhWP+2X6XkMEcLaZp+VClQ0OJlUMjnqeKeQrnARuYpbEZIot2rwfEE99lHsKqgB71pOYd9tbLiFRv/kokTIcBeDWfUnm5WTDt0sNMXHpcJcd9WXrVibjKY/8c4aJnbUxJYpuIe3GuWD6CPlE7Go23MXVw4WGNOUASdZYzNVMRWsvDhpvhZgaK+teLm7epXxhDfOpa0zWHXYiPjfmAVKzigr/I+wXcRwYCA5yGyOofsIVVivdE2lz8XqAli4dsTQy4V/Xah7CPxaHZrU9yKkig4XhD2n8FMeXmFyBdue2AmfCqdv+Y0UWRITFJD1Afz1qFOgntTwBw6/5APh0Gj4f4qJGJhNCuLmLLWZKdiBIe6gAS0Id5/71dcmr3hKECD8P/32TZ+71q7L9+niRD3UZI1ho++F9aTljnGxx90VOqBkoWpjttEUFmRTwFG4Gr12mKQBji9aGwqqXKTVh2i1QacU6dgho5UUKtMQwZk+rmQOP4BnvsLJuEOGDDWGDPSsy0Fgd3VWEz6nNG6vt+vVRDK8QHQbJZa0xiuK+bc5rb8TWdadDpFTHSKyh9slvgctl0IvZxKx8i1uFcFsTRP1bAtjc8rXS5P4SBVFNjPu8GXPFKXtBS38UMZEgm6fTGGvzXyT52jnrGjjriqqnJrYYQqrLEyLbdbKSoFiGzNgIPZEV9iApzQKIEhG6T8mD8FNHBO4lck9YaCbi7Z3SH6eRDLO7gtL92P7kWbdnkGlz4tV044SVredi65XcjqeDhPpl0FM+n+JMKpOBWT/1eV26hk9lzHPMPI1dzzSieKqnTAp2lMFVK3f6KtQgLGMRJerRcQKAvnngjkWuW17JWsOvi2gIde54Jxtglr7j2A7hEzEW1AbPKHwRr59hLIKR4spbYJn9eJ5bxVbCDfPw
 aQPcBM4Y
 hNMvmx5t4K6PMV5moN5HVJ1lRImzagJZcbkad6ViVozOcsHhnjE1nHgJfTX+CW2SFKvVi2uGwutKL8dXywAqivcWSQswXl8LaFwr6Y7onR15NiKVSEunR8MfGS8Et1yVi93vg+9IIh6P8AnavNlKVTmguSEIaFAJ6RlyAaBzCqN7wK/nVPRsPMI2C0y8drlBIx2hYvtkMh0kYPsfdDQ3McyuVCjfBdKw6JyCCrcsdPFGNPa9wSYCnd5yhXZcbWEY1B4ugSooV7yt3WW65xskKF/KhTJM/9KPDeokw9EpGErwfoF5h5Qp/1uW2kbc/zgDCndG1sjNn3mA9tGS72l13uyTxIKDxJofj+ekSUefCRsoQXGALvaegJek7H4HJ53iJtSoOqjI+YIAaulhbRmzaiN+NVwb3ftJc/mdMS6fbWaPzg3g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 04:16:40PM -0800, Shakeel Butt wrote:
> On Thu, Dec 18, 2025 at 11:55:39PM +0000, Matthew Wilcox wrote:
> > On Thu, Dec 18, 2025 at 12:55:05PM -0800, Shakeel Butt wrote:
> > > +	do {
> > > +		ret = __kernel_read(r->file, buf, sz, &pos);
> > > +		if (ret <= 0) {
> > > +			r->err = ret ?: -EIO;
> > > +			return NULL;
> > > +		}
> > > +		buf += ret;
> > > +		sz -= ret;
> > > +	} while (sz > 0);
> > 
> > Why are you doing a loop around __kernel_read()?  eg kernel_read() does
> > not do a read around __kernel_read().  The callers of kernel_read()
> > don't do a loop either.  So what makes you think it needs to have a loop
> > around it?
> 
> I am assuming that __kernel_read() can return less data than the
> requested. Is that assumption incorrect?

I think it can, but I don't think a second call will get any more data.
For example, it could hit EOF.  What led you to think that calling it in
a loop was the right approach?

