Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F439C98306
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 06:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5908E6B009F; Fri, 25 Sep 2026 02:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 540F96B00A0; Fri, 25 Sep 2026 02:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457706B00A1; Fri, 25 Sep 2026 02:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 259676B009F
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 02:52:42 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F1D55120576
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:52:39 +0000 (UTC)
X-FDA: 85251366438.24.C4982B4
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7F6E3C0004
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 06:52:36 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ndpbDFL5;
	spf=none (imf22.hostedemail.com: domain of BATV+07853672776bc0ba7c7e+8433+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+07853672776bc0ba7c7e+8433+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790319156;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CoKrYiONuGciYdBdICmSxiNS+aSXQ/z1p0P2nVVf7sQ=;
	b=EJRDOHFqkD/t5/eF7KgGHDqMWH8fH4wgd7pgri6zkoNc4wobLr+5deI1IL+5loKYzxfHvK
	SzmYTPZaR0Ral663ynqTwyn1qGJyCxA49JM8gTTV+bVNjuCt1lp8HAEfkozj9OjagCS9+H
	hCMaZIQJ56QYpx7nfMHlVoLIoPvaoSQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790319156;
	b=VXJ1DBGi09X+sh3RMVhuJQFdQkDz15GArUYh7AZWqiWHSvL26llNK4vElhWHsZDK0J3XR3
	6+7TN5f8kR+8alChMcHNzCtd+snEjloH0SzHtviD1iXJval6kG0SXlqyasTaH14iLtjqZi
	TqfCQd+KFRFveBBnEzyYuX//znWcYfU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=ndpbDFL5;
	spf=none (imf22.hostedemail.com: domain of BATV+07853672776bc0ba7c7e+8433+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+07853672776bc0ba7c7e+8433+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CoKrYiONuGciYdBdICmSxiNS+aSXQ/z1p0P2nVVf7sQ=; b=ndpbDFL5NvXtwXggjq0mHatFKi
	DkzOT+jooG7yJfqmKsJ6QZZiHHoCwGZVhpkPPL0TprtXdaI9OVDvmq06HsuIbsJzUAJF5wrclWKAm
	yat14FBHxIFEWgN5x8FDhrbiAYmmT6nKsPKg5TdZr/UQRD0VZfQMHG2mwwJybSg2xhcD27PuG59i4
	idX7xGZf1enFM25zlUkBPr82iGVeEwA+2Qqq+SYz8OPAxKjLB60kHZJHo3UAKGmd4x9b2VrhgYd0R
	EGkiZkoHe9om8IoN20EOLeYUtBz7V+cPtgGFb6M6/ijR/zxMmoUXUexLNsVRJfg56rtiD4fkK5jY2
	pjI22nig==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x9znN-0000000Cm6I-0Pf1;
	Fri, 25 Sep 2026 06:52:33 +0000
Date: Thu, 24 Sep 2026 23:52:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, willy@infradead.org,
	jack@suse.cz, tj@kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH v9 1/3] block: introduce bdev_flush_by_dev()
Message-ID: <arYaMbJUh6unvz_t@infradead.org>
References: <20260925064444.3944820-1-sunjunchao@bytedance.com>
 <20260925064444.3944820-2-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260925064444.3944820-2-sunjunchao@bytedance.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: s1c6c65ghto14gupd4u33skgprbkgmyy
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7F6E3C0004
X-HE-Tag: 1790319156-561574
X-HE-Meta: U2FsdGVkX1/N6w0dMYswkXzm3dZwo6v+XD7hq3piG+kjcgZY2z9mwimUjN95rVtsJlxQN/imfT1yL0inKT2nb7z3P5g0BocHhjsLNWYAercWrZI7HWhY71NeNKMHYIvR1wpBMdvLQyWQbj9aCxRacXQRDQOU8NoJ1drFAts1mUdx/br0MRrCDaZkFxyhvxdBDlc3AueCiOc2VOC6dvi7nnhJmCFxSE5CFDtbe4gzFQNJCagGnTEi2MJWYOZMHs9RQysZuXCcE5KLANjU8KDpK9HDg/JdlpK2v53ke0HYGqr71Y1tNewJybi+I4XdPvjAXPXgaP7C2juJKu5DvVU65CdURKMLURo5XgrScIem2Xd9J/siwD/7Miu4CAgaWOzIgeFgOPCMDkRX5j+2MpUDqp29yuxs/epZuYZ/jDcJeupK2mY+epj4VZF3Rej3rWp8shcGJvPB/kDyHdRDgbwcM2X3UN/3rR8YoDbAdTQrJ/smRAGNdYCa1buVOVLzIOUg9UqENZ8nh+eSZQzhs3Z/gwLz7790R6rXxmTYRaZW6EJ6m15cKZofxYNKVjt2bcYltpdNNxj50+lysh3updWhTc40/oTUe5L1+wd2KvRrvGjwJIJLTTwwhMLAXsh/hWQ2RiFa1OuZGFR2aJTCmbx7Y9ggRVvQqEt3YJq46uuJ3DTeXMxZwI2ud2ngPKuv08ctfOb4Y1LklpVu44ghgG+gYrMGumob/EdC3z6Wfr8pd9UfWNVG3NsyVEvrwUTBXmoMN7tMgSOh0ojZVhJn78OKCIU1x0zpc9SLe1Erw/PsvrjgiwUDyAQwLqz7tOWS/2gbzEomYurEUWvpM0cmZMNQXLF7IRGcOlk0Qvc5aHsZnggvvsFUaBzPNNQ+PdnOirMjvqCzWgul3k31KgpDzqy8KwlwHGOtF4K8Rz9UmNuUTmBvWY4eb3MH3hawBMsuhwst/hmMGbyRmIzIVgQQEiU
 ut4K2zbF
 CD9RqC/YerS2zRjkIxMBWYYqpFNNcvGm+HTQJ1ACH7MqCcItyBsCTAWDzaDPabxoHRnd0g1KE1VUWPfQ/n5OJZCSRRjqrESeJ52atJxWpkrY+RpbaIF3tWVTVKzZnLFCd3vWTuSZ2eXI6NEgIwEYK0chAnUsLIG4x5sCyjNY10NEe2GJc9s5VLHde1T4NnhWuwS6/PkPR4ZTewJqbztPFDf9FQgtH7o1AsdJYgT6Bkd89UvQ9cOGtlx6vEM6EWEqUo7jfBZjbN44U0sM5ecoSVjj+GCq4iHBfj5+J7e/fccxGznKV3ue/SNGWUu9W5dIuzec0BdvMjqTx56lVHApD7e8CcZKqhoGSfSK3rYUrSZiLkO8/tmBaJEWSnT2cpfjpzXeccrprw+l4pEuy70THLzaTjxzZqnjtxbcyNqpPQmFk7G0uMqFtRkyzvBfAojP7fEoaXFebYfyr0zwdP2fzDFz5fAgaZNRvibokn0Qgs74zl2uEnlWjOIuuuSHpSV76L5tdl7G5lCgf0skZK1XN7rMK33v90lJg2Vv6goQ+xBWY2PPdbgLuyjUTdaMWMIT8lKmiKmW+6SuAg7ptfWfcjM/aw7fNPm9oujJV63a378Ozzcw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 02:44:42PM +0800, Julian Sun wrote:
> Add bdev_flush_by_dev() to submit page-cache writeback for a device
> identified by dev_t without requiring callers to hold a persistent
> device reference.

This isn't really a flush is it?  This is writeback.

> + *
> + * May sleep while submitting writeback; does not wait for I/O completion.
> + */
> +void bdev_flush_by_dev(dev_t dev)
> +{
> +	struct block_device *bdev;
> +
> +	bdev = blkdev_get_no_open(dev, false);
> +	if (!bdev)
> +		return;

Please don't add more blkdev_get_no_open.  You can get from an
bdevfs inode to the struct block_device trivially using
I_BDEV instead of doing another lookup.  Or just grab a reference
to the the inode, which would seem even easier.


