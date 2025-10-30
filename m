Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD84ECCF9FC
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 14:05:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14FBF8E01CE; Thu, 30 Oct 2025 10:05:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 127968E007D; Thu, 30 Oct 2025 10:05:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 064978E01CE; Thu, 30 Oct 2025 10:05:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EA0608E007D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:05:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B4F748621D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:05:16 +0000 (UTC)
X-FDA: 84054952632.14.91B4A4F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id F085D1C001D
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:05:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=OU42mios;
	spf=none (imf21.hostedemail.com: domain of BATV+944ef91ef5ddfdea56ef+8103+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+944ef91ef5ddfdea56ef+8103+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761833115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xFP5v3fUOlDAEzHhimBhc19pvPkZDICA/lfyXRtuCO8=;
	b=eOl+l6c9L+PC1jEO7JgxtvlzAtf74g/wK0DXzO098y15TmHPbHwnVD/DdYdkA6Cx1+pH6A
	J7jKIgmo15AhQjC+6Yfa/S6brXxfJRWxJ4wL/M9Rxm2EsmiW3SbUsoFgZwlbZ/2zAjy8tV
	5Iy2UquQLnIyr+BbE49UQlL/mZYgv3c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=OU42mios;
	spf=none (imf21.hostedemail.com: domain of BATV+944ef91ef5ddfdea56ef+8103+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+944ef91ef5ddfdea56ef+8103+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761833115; a=rsa-sha256;
	cv=none;
	b=S8D30PqTZM1l25kNcnHZ1LBkjtM2GQIfRpvqPzpDNrXUpuIpwf8oRBhGgOYbQUETZdv0R1
	IpCd/jk5KaVTvhT4FlurlEWZQs4rrJSSkKR6rpQamURzXuWd8hV88kSgOPWGRHJp0DArY3
	OECYw9Fqmdp4bEv4lLz8XeRIykzdzZQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=xFP5v3fUOlDAEzHhimBhc19pvPkZDICA/lfyXRtuCO8=; b=OU42miosZZnsNGA8GWX4rxDD5v
	NbliiDx+SjRjbIF9jFGckM3MdP80CQtGSDK/nbkvMlbdk1UygMYUDjPgN0c3vvX0NOyP5CKxGp8AZ
	A0DJkJWWLkbUlw/iPQNrDXvp28dgzimT0B/sxr0cBPO6KMupjjlnCC3hxe9S9lUyGvfnixBrqjeAC
	wT0vgTXn2TPw1TpM6hxsYrRnggBilsHevdZqkWTFmJhpkv49kyH6eyrb1h6QAe2DZ4/V8W1eTyrm9
	TrXUxnBsjtbfa8pB8oZssfa0DYQyEYtx2WM8A6WPnUYKejXmj9paTw59DZGiAsEmGg/W8PAHKEk9q
	Asgroq/g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vETGn-00000004H02-1Xin;
	Thu, 30 Oct 2025 14:04:54 +0000
Date: Thu, 30 Oct 2025 07:04:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Christoph Hellwig <hch@infradead.org>, akpm@linux-foundation.org,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, alexandru.elisei@arm.com,
	peterx@redhat.com, sj@kernel.org, rppt@kernel.org, mhocko@suse.com,
	corbet@lwn.net, axboe@kernel.dk, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, willy@infradead.org,
	m.szyprowski@samsung.com, robin.murphy@arm.com, hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	minchan@kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, iommu@lists.linux.dev
Subject: Re: [PATCH v2 0/8] Guaranteed CMA
Message-ID: <aQNwhQcN8Su_Il6c@infradead.org>
References: <20251026203611.1608903-1-surenb@google.com>
 <aP8XMZ_DfJEvrNxL@infradead.org>
 <CAJuCfpH1Nmnvmg--T2nYQ4r25pgJhDEo=2-GAXMjWaFU5vH7LQ@mail.gmail.com>
 <aQHdG_4yk0-o0iEY@infradead.org>
 <CAJuCfpFPDPaQdHW3fy46fsNczyqje0W8BemHSfroeawB1-SRpQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpFPDPaQdHW3fy46fsNczyqje0W8BemHSfroeawB1-SRpQ@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F085D1C001D
X-Stat-Signature: f3bqwf9ts6se7tib3j9swt9a5w68mb41
X-Rspam-User: 
X-HE-Tag: 1761833113-812742
X-HE-Meta: U2FsdGVkX18HoQ/yXeFeY8Y1dWFoGQ0Ok9BShWZk0oD9R4RozC3eQiERkP5mJPIJhFN2854GPMD+P1ForPhvFMsiJs8Fn8mq+jkKd5RHT0inma1TRVOLL1B90JeSQDckJ0wnbwV2JQyjxbG9dKg5gdx54m4oIMSVW6wN0U0inBCX/t3l979SxlNuqfhlBsV24XdT1hLYdhFQBo7EzzN64CMmmceZYh9FKsCYeKI2bL5VH6USee8ZgzOuZ5c0L+RPNp3iBUdkWxDhbddIEBVnTQ0tuZbklwxfPY8innrb6O2iMx13R9CkWidKZn8xw9BvAiKrP799HKawuwuNFGwN7L8nyq9wsqbj/2xrYlvPjyTPr6bxxiuUHmVqY5TlBSQ1tBiPGg7vUC+KTWfYfjw7q0BvROuOUB/fM2mJsmk0wSTXvpXtWQBj8zJDbDW+D6K/v5csMo+onpKa4Jfko1NIErSYzgKGu+XNITlWX+mfpgwUNKDFU5QbX8b6SnnbUgVpEpjA+IPIIHuY5VZBj0glKfFhoDcCiL+RhjtwuBlqjfKXX64yPaYCTjmEK4GtVmzZDf6GKiDWHwXpmx2dJjEXM0PVgVepB6Al0lVpTpM+6YpOZDAuCuv3n6lOVZq5VJXo4Exc/MFupprAy2ciDN5JoYFmLc8JTm05Kdtlw5+P+Fc83s4P1unKTya2LQmcCnXtvLcVEZPAZaMLAWsvuZnmW4oLT7sw60arnXyolpNH8m0tn/k/r1CyIhpkn24UwI343H2njXL7SYAojpi1CvoGWdWATTYXL0++OamPMU81wEauk0Qr0cAGgjnErFm9JSwA+4mI0hrZB/dr4II4fyITyOInE839UT0hhhJDF8A0PXZcdaznZkfPY9xoqCpY90RLsfgq1XdqJNzYCRjOcf9n4hl5GVMuQtRD40cF8t/1N7xeHIKKOnlNCU/hVmcLbYkEL21vdAsAFJtuqABbXPv
 2omscHH2
 vpsB2BjldSns+D9+mIRMY+uvir/Gznx+GgwouvOjajVI5EDyEbmJJCuC8gM32CSBEhyrR3+aKbcOhSEsocdx61H56Nc7UadSRdpz3le765vGuQSHFZNPLE+krSe0omxzIN39ycZiFIkfLM6AWqud4x5Lh05pzP6+vwdiYKDdglUx4zSeV9fgrwPE+s4L5XWziDaEII5E72Qksx+cHtlJyKpXqhCh1MvzXUd5mJyeqaMFWm5bRrIFHawE1iMH9RMTsZ82osQNk4dKUh569d7QOikUe5NEeBYPRJwDfEcZta3bFjpCl3yu9MCTVanqNz2zkEQlMtrmUy/hl+QbGxb9nypa7mrTcCaTY+EuHQBZksKME2chI+nmxORW2P8Oe7lyLeTTyVchHLUaYpB4nZMLnJ8Pj4nSlnJHvpgZiKhDLoze6sByKMZ08Ceig507v9DgqeogXarW5DGKQ3t4j4CAakRqjdHDM493+MVlYXkLltY4rusUhNa3em76tLyjUwUhdlsN+lmDR2mid6ub7gNIx+UTucnvS7qp1CYTi50WbK6M5TuYycunXyuRzPu71DUWHONjCZm4jVLS3EyNVG4D7TsfpOg/1rE6DbIlLRSfFs5AIHWNMgx/P0pQmO/MS0VrqMP9E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 07:57:34AM -0700, Suren Baghdasaryan wrote:
> On Wed, Oct 29, 2025 at 2:23 AM Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On Mon, Oct 27, 2025 at 12:51:17PM -0700, Suren Baghdasaryan wrote:
> > > I'm guessing you missed my reply to your comment in the previous
> > > submission: https://lore.kernel.org/all/CAJuCfpFs5aKv8E96YC_pasNjH6=eukTuS2X8f=nBGiiuE0Nwhg@mail.gmail.com/
> > > Please check it out and follow up here or on the original thread.
> >
> > I didn't feel to comment on it.  Please don't just build abstractions
> > on top of abstractions for no reason.  If you later have to introduce
> > them add them when they are actually needed.
> 
> Ok, if it makes it easier to review the code, I'll do it. So, I can:
> 1. merge cleancache code (patch 1) with the GCMA code (patch 7). This
> way all the logic will be together.
> 2. . LRU additiona (patch 2) and readahead support (patch 3) can stay
> as incremental additions to GCMA, sysfs interface (patch 4) and
> cleancache documentation (

Sounds good.


