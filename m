Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A65BAD711C8
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 00:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 159456B0088; Thu, 18 Dec 2025 19:16:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FDB46B0089; Thu, 18 Dec 2025 19:16:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 009EF6B008A; Thu, 18 Dec 2025 19:16:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E2D476B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 19:16:49 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 84BBB586B7
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:16:49 +0000 (UTC)
X-FDA: 84234304938.11.D7422D5
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id AE4F8100002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:16:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MUBmcdQs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766103408; a=rsa-sha256;
	cv=none;
	b=bUwUZbbbtnb3z+7cXL6XCDX6Iuc2BVy82GMAQXB7OXSegtjoXkqfuEQtRP61Xrid8Nhx1Z
	N+I0iVIWi61/s5fxUxuWZzHK5tCFlSk5O7/4pvGKkFyBIPBIMwgmPiTCGjSbNqnNaPYspv
	Aoo6HlbS53h3Jd3aKCzm7RDHc+1P1jg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=MUBmcdQs;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766103408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iaNwM6o2Q3buZTg4AtEVmQYeydc3nbq7x/hRmv9CsW8=;
	b=ydRx6EpPIfrqpQNKX8w7PsvqbwFW1s/qNwQPumUoXwkX9LonzRiyqMz76qbzv+tUDLDxtw
	g1iHhIU7h0q+IgHqAwGl5r0IjqX8ptC+OgRL9thikqdBwrSI8KMSVK5dGpYddXvZxWy7L5
	7Erc6xARGHwrBdkzbGs4tCpwH2uks0A=
Date: Thu, 18 Dec 2025 16:16:40 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766103405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=iaNwM6o2Q3buZTg4AtEVmQYeydc3nbq7x/hRmv9CsW8=;
	b=MUBmcdQsLHkz91tl1c96JusBFth6vDgdq2NU48+HTzjQEodmrBXYqr7M4W88k4qgSL6u8l
	MkyPlC0HK6iVCumF+HMob8y2+CRjeVH0+uCXabMNbMM8w515bNixYVpr85tjP3Zen4caVv
	Z1odTtd+sShuwGvwlRkpdTLQjJ9I+As=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Andrii Nakryiko <andrii@kernel.org>, Shaurya Rane <ssrane_b23@ee.vjti.ac.in>, 
	"Darrick J . Wong" <djwong@kernel.org>, Christoph Hellwig <hch@infradead.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH bpf v2] lib/buildid: use __kernel_read() for sleepable
 context
Message-ID: <3lf3ed3xn2oaenvlqjmypuewtm6gakzbecc7kgqsadggyvdtkr@uyw4boj6igqu>
References: <20251218205505.2415840-1-shakeel.butt@linux.dev>
 <aUSUe9jHnYJ577Gh@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aUSUe9jHnYJ577Gh@casper.infradead.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: AE4F8100002
X-Rspamd-Server: rspam10
X-Stat-Signature: ko1r4737uui84ihwnfpf84uagqsj6f9p
X-HE-Tag: 1766103407-873500
X-HE-Meta: U2FsdGVkX18jvsF489QmgD3zrOgrhT8L2+iI8l7sC/4j8pyk4e+0yeOfoq909FkRJzzMtkQzF6nNyyVdFwjGusKgelBNqST6xHC1E3zvZWGggwpL3wRnIzeYiqPdciIH0dxHgF/XRwTW6kB7+vswW5Tpeg1cc6D9uTiyH9mh4tD7VnjAZwpFEkV3h50RLeDQVLLGUEHs1sX5lM5zInLr4F5qIrvT+jzzVein2gqTBuMr9XSXhVPLzs9uuEb/LtdRA2XeFD8SV4HKQE0pLnKelJj1IlFw67vorVWd6jMcZfL4ZIsJEJZsAbW8qc/TI736I+/qIZKjQMDW3gl628s5H0viwVRRm/3ev+PzzH2a/GC6oMXgyObffsjx6TOFCxQdoqQM2hLYydSmR05zwKAJbi/aYxR4lTUHTwD/gisKYlDLk7/X2CABABCc1wYnaXw6fSoyvTkh3ujKLsO9JSpUSxr8LTha2jqXpDBoKpSvLDbWBBekmehHFiMo+3R9/Jz3B8CJjP9ZqD83Tm+CORz1Nr6N9vq1SakhB8R3G/1LOqg1hsTrTVDbuq3iDwwr/93O754sXYbeXei+UYA6dnEcsNLNiVsO8dOQ9RA1Wc5KxzqqTrdOznshbH4bwGnQuH4G2gHJ4V/ahE3oS47m93yXLWmRseWXzPQgC7J8/Gq/U52j+Oa9VJfV+uCqgp623eCSVdOmr5bvFAxTfo7N4HYZFWo/igwr/RJPyVbStRL01W11f5z7RyVJ7DoWcCUjTwGPU164/FwUmbwqT7mGX4QhOpBy+4xzXLl5a+uR9EE2RLYFcb2/G+mv5xu4y0YG1XfmqILtDi0Af4WxhAhtNh6CNPv1XCWjHBS5VmBllA2+ihPuXmM73+NsPh/yJlqQii9Yz5Ch++ljWS03a0Ml++cYN0Zuvhr0zfxKh0piKBMIW43iqPYLLIpiCw0A01kP+yiyFeVXlB3o+Nt1kbccDWq
 x5KF4GL8
 f9AT8ICuzaT3I5vm1d0pxqjvDXEEMLhieKmMnKpG6pZ3rUAp/5XGhiKMrZsxx3JTC0qgOevct6X4OB0FAt1RVlAhR8kA24tVGJNKQHfxttZWX3rfP40O8n2TL+q12c7LAn0zix9w5D6aYYL6mi2lQbF0tlidDGhnK13stHnY9MnigosNj/cl/679jqEY/ovXIE8iUMIyHj65krqMyYg7lROEfGGfpUr9abG3/t9lPLUJ8n9AJ6XEp8ETcbNGNXO7tfjYS2MFx4vB3wAHSTi+ZE6soOZUzot9bsezLofIuc5BkdMHHyY/2IKNzCrT+YUu2II2iUiacNpPDFEM62mYXl3vXCCoDSeunwV8/ogPnhhNDlVNd/gPSJ6d/vg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 11:55:39PM +0000, Matthew Wilcox wrote:
> On Thu, Dec 18, 2025 at 12:55:05PM -0800, Shakeel Butt wrote:
> > +	do {
> > +		ret = __kernel_read(r->file, buf, sz, &pos);
> > +		if (ret <= 0) {
> > +			r->err = ret ?: -EIO;
> > +			return NULL;
> > +		}
> > +		buf += ret;
> > +		sz -= ret;
> > +	} while (sz > 0);
> 
> Why are you doing a loop around __kernel_read()?  eg kernel_read() does
> not do a read around __kernel_read().  The callers of kernel_read()
> don't do a loop either.  So what makes you think it needs to have a loop
> around it?

I am assuming that __kernel_read() can return less data than the
requested. Is that assumption incorrect?

