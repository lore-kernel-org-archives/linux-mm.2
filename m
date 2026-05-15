Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 786BDCD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 06:30:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AB286B0096; Fri, 15 May 2026 02:30:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9351D6B0099; Fri, 15 May 2026 02:30:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8046B6B009D; Fri, 15 May 2026 02:30:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 69B726B0096
	for <linux-mm@kvack.org>; Fri, 15 May 2026 02:30:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1F402140642
	for <linux-mm@kvack.org>; Fri, 15 May 2026 06:30:46 +0000 (UTC)
X-FDA: 84768680892.08.E943380
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4ACA2C0010
	for <linux-mm@kvack.org>; Fri, 15 May 2026 06:30:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=GmuzAaRj;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778826644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=shaRST3HQM429A/PY0LfH58c4YMTbb8Gt1FJcn3lHuE=;
	b=Gls7yGUS61zHS3EIwVwnoGwpn1U/3Fdz/tNrkMEdECoB44yO9gWm2pcuy4FVUsqMz7cqWm
	VCm36VlTFNRtoC3/h4C9wSIgk1SZ/N5lDg6lxSCybUDvTMBjm2wAIl/hj8X1QdZFE8XQq3
	oNaSw1JXhI1fEyRLz/CNUGfSShIqcuI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778826644; a=rsa-sha256;
	cv=none;
	b=wg/rtQAtYKEeuuSF42IrSO/cgj1XmaHrYP8Se7B8sDQsrP1Pd5UotgB/xBme2BpQ13MKMa
	pxLFBzjNAU9qGZasMYB2jwV5jjh4kX/t59ug42KdJNhZglxLCFPhsDL3dx3J+T0HSa4W10
	pVZ8ejU50M0y6qngtJMhqEaipVAtx+Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=GmuzAaRj;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf28.hostedemail.com: domain of BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+10df459a9b3838b27a9f+8300+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=shaRST3HQM429A/PY0LfH58c4YMTbb8Gt1FJcn3lHuE=; b=GmuzAaRjEWkM+Q607nMdCFx08D
	USeBuJttxyYgvpBv0QSWd3wYiHdErvdbrrNoKCi0fClRcGo0ALBYOcKNI8RDCWcgvEU0Ps/eU+wnU
	Bk3MVGZA9k1wZTN1nP3Qq8wQqwtl879ynTJXjfJ570B6gNU+4+Z5jj/c3R8LP+vT/CFx54XCP3364
	xf8Htn2rIvEN6udtI+fkuoDKeFDoPgsPl4f++L25Cd0LXxwTmgt5jhSFiQ3IprKIx/hxK221PlawS
	w5NtuE/nx3wXWPB/KdkwdLB9w917jXFyAZPdxQ26+KFSRUsZppl6HmyQKbRl5Ondehth80Q5u5fcc
	EKkrRXzQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wNm4C-00000007Vx9-2c2a;
	Fri, 15 May 2026 06:30:36 +0000
Date: Thu, 14 May 2026 23:30:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Baoquan He <baoquan.he@linux.dev>
Cc: Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
	akpm@linux-foundation.org, chrisl@kernel.org, usama.arif@linux.dev,
	baohua@kernel.org, kasong@tencent.com, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <aga9jI0gc_-yxeR8@infradead.org>
References: <20260512104201.716213-1-baoquan.he@linux.dev>
 <20260512104201.716213-3-baoquan.he@linux.dev>
 <agQM8YJgiMxGlI34@infradead.org>
 <agSZ3hZJTBAjgVOn@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agSZ3hZJTBAjgVOn@MiWiFi-R3L-srv>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4ACA2C0010
X-Stat-Signature: ridjygnzi79so6gj8osou13njjkdtcdo
X-Rspam-User: 
X-HE-Tag: 1778826643-549254
X-HE-Meta: U2FsdGVkX180NHRjiGDHYfH3G5eE5KDtyQQkt1zfcx+zn9wC1nktH2gDsztWOszZ4FDxxajUf3CL5AAfY169Ax72pbjv1mYNLUcpJOZIU4kBo8TecdvKeiLkcZLVwsa3Nb0jRS+eSAQ21GlZle13whlZwuR88B1RvwThhAgMQPs/B3Z3FyAbYV9zummu2nMt7EktcZfpkW8YsMyKLT/hpQwS+Zx+1hYToihWT06FsQGtoXmINQwrimOAQkB1/jawMYe/tro76Z0/N8U1/JiHM26ie2INz05IRJH3pRh4Uy6EOkJwXabPLx7IzjPHTE6ud7dMj0Kb2lBN1Aa0x5+fMXgdelHwnQbqUO2DhRTwm7iVQ61QDcGfh4weDvFmACWoRSlxWkHDIEDXPCjLTl3tvIFhY0SnuNfxoUjnCfPA5mA1iMS6DEDTHWS+gEa7q16V0IlKp3ft8Lpf6FsEWp/dAn07KrcIJlvM0f4KEEFzfqx/7PanZvJSQiz+CM+GQ79tfjbknaLURACxgiQrXfHGiRUUAf0uYeMV5PmVao3WZGQfDeYCOublUoDk6rvFZM4c6Bn+NDpznPOBdbqJ5m3SAigD5wBBq01x6JJQgSRo7ZKy1wlbX3C/+CN5wgDanjyajpIz2yewPptYtWcGXQ99TvvTYbQiGWp2GprqO8Wv3Q5MciGJoKqeVdlds4IKr87VkytQue2xQxsFUO2472xssx5YrGqRfnywtRqrRV9Yh/I85xPDfMToTaVIDB3/8xclmIlhgnbd6HGytnAh+Gh6AoGhocB+c1hj0pQyVc4o9ZWUEe9xEtFkRnoaOmzFE98sS7wc1nP9gMLrR00kyhVMaeQhSlxD/pZNz5/fSczkQMo+zzaR2SkXNGnFb66/4AIYQG4RhKQ7teV9tszuq2lcioNpT8UuOTwgGKzsVQwmNQ9gRLoCV0d7IH//fUF8du1HXWEUR2vPTJCvQoBsUZj
 0W4Byc8z
 zIYdsfaVC5Qyvo+et4cMupO9mTGsweJ6Quf8SeUu1xrUQiAVtEH2JVgF/+4bitTofcvnShXWV1jVX6sO4UjoSI7z9jiBYtHfuZ3l5tzygBhAvWmIsztcIfv4j7hv3px1jh614SM6AKhP9571Ngt5F52MOozlSnnMQvN8ju2SVZCJ7L49XYlmJEossK9oUUtEFHl5lvVkCequKCu3ytADrQFn3Gr25/3f78mMLdL2ZjWEgPJkUEbJlv4Ed6ma4Bqmsjbur3B7+s5m23VDzwAD8neTe2ea9pNC8ldZkxWjY+MymTwzhZJ/aVLyCXW5gOzDtHLidhT0FdWPYeJ0SxLC11y5z+MsQEslKdOqb4KdlMrQvNDOhkT3yhVSZPe7xPUCt3+JzV8ctGL620HFm/bivZnlozD3OW/kH80/3OLTcovJydh3bsLWpDJFsOVyx/9en2MaBMMQ9t8mu9sfpA0OKmdfqDRZK3ruoi+0IeUX3VDTDweKsAz+IFjr8RRupW9kc+IPNuYgUvxzKwXWkQQY8QBG9aFuRvnntYydL5irH7Fl1Ocw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 11:33:50PM +0800, Baoquan He wrote:
> This patchset is part I. I posted v1 to collect suggestions, later I
> took a leave, then people think the v1 can be merged firstly and helped
> to post v2. I later came back and continue to push this part. If you
> just found this patch series and come up with those cleanups, could you
> wait a moment until we merge this part and part II is posted? I think
> the split handling of block and fs in swap you mentioned is super cool,
> and is beyond our plan.

I've been looking at this a bit more, and I think it is going very
much in the wrong direction.  I've started drafting a version that
moves block to the same model as fs to build up multi-folio bios,
which actually allows for a clean abstraction.


