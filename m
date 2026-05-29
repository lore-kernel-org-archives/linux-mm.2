Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57EB9CD6E45
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 05:36:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 982176B0005; Fri, 29 May 2026 01:36:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90CF46B0088; Fri, 29 May 2026 01:36:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D37D6B0092; Fri, 29 May 2026 01:36:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 696C56B0005
	for <linux-mm@kvack.org>; Fri, 29 May 2026 01:36:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F363340DAA
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:36:44 +0000 (UTC)
X-FDA: 84819347970.06.A403BD7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6B8D81C0006
	for <linux-mm@kvack.org>; Fri, 29 May 2026 05:36:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="vZ6FwFY/";
	spf=none (imf21.hostedemail.com: domain of BATV+07363440a70d19ca35bc+8314+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+07363440a70d19ca35bc+8314+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780033003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aWo/gTZ+lk7qCswHD1K4xHit8Q7TVDZZNoyS6wwTu8Y=;
	b=I7GXGrMUiRCt9WydCia85Ts23M/wZ+ylPr9zS4bskabSCiSM4PjNhnvr/mHGTGBAOn+26p
	KghbLm9daGYw2LcO1R2+LqZQLgEEpaxIi93IbsbLbgO9OaXq293cr1YImJDWsiAuaU7YeO
	6X6WwyaACvMtdnOqvB046X+vduWPJF4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="vZ6FwFY/";
	spf=none (imf21.hostedemail.com: domain of BATV+07363440a70d19ca35bc+8314+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+07363440a70d19ca35bc+8314+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780033003; a=rsa-sha256;
	cv=none;
	b=n5o/egLGYwBYK5aDCkJ52mcW4Hc2ZpEf2WkaYKZQpVv+RZnFGGvSfz7uRuLvL9njMcDIUV
	qJyUSraAFL3O7UV8fcvCU/Z6U6zX9R5I3olv+c/Z4GGyIxgektfqXIPPxfqw3HmZHKP0Fs
	1VxowiBG1bAPIHqiCOR0dd6UtTv1nYQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=aWo/gTZ+lk7qCswHD1K4xHit8Q7TVDZZNoyS6wwTu8Y=; b=vZ6FwFY/6VqF6WzikjGIZxuBlC
	FLMmpJLHB1p5hx2CsiBI/QUAU2dEbJULNxIZqhYJcJWSj4LkthqJ3RzSqurUj8ga5p7zkk+DGxIbb
	l0CrRbsr9CTjvx51lSw1qc0faVXR5JH0vmj6Ikbyfh23v42jgWYoZ6v2AbGP/kjGmb2GZAjzcPI6z
	IluxeI7aHavbJ3PLPUbgjtngBQyObKDGlnQbakChVVkOGCAP4EJy/6Umqu93cGXoPGws54kMp3tED
	U+OMb9FtkrQnZhUtkvZlDtU4ulHdOD05FgUGQCY0ug52p0Bk0z6/rwsAHUr9uOCWNjjK+d9jeTFmX
	Q1Ew1VRw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wSptf-00000006laY-1dEg;
	Fri, 29 May 2026 05:36:39 +0000
Date: Thu, 28 May 2026 22:36:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Bart Van Assche <bvanassche@acm.org>, Theodore Tso <tytso@mit.edu>,
	linux-api@vger.kernel.org, linux-kernel@vger.kernel.org,
	Matthew Wilcox <willy@infradead.org>,
	linux-f2fs-devel@lists.sourceforge.net, linux-mm@kvack.org,
	Akilesh Kailash <akailash@google.com>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>
Subject: Re: [f2fs-dev] [PATCH v2] f2fs: another way to set large folio by
 remembering inode number
Message-ID: <ahkl52N3RDcusCNd@infradead.org>
References: <20260521155748.GA79343@macsyma-wired.lan>
 <ag_OVwPF49LSZ7rz@google.com>
 <20260522141115.GA8258@macsyma-wired.lan>
 <ahCNmWbcd_2lAJyk@google.com>
 <20260522224108.GA18663@macsyma-wired.lan>
 <ahTzHyHBL8t0iNBR@google.com>
 <ybmbjekuvzmaw4hmlxd7nxs546dqtwmxqxwyali74d6m3u7tat@b4q3japqnhrl>
 <f4e521ac-2381-49ca-8dcc-3cb3cf3ffaea@acm.org>
 <ahaPDHiXcJoVShPv@infradead.org>
 <ahcU5xbVy7xjps02@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahcU5xbVy7xjps02@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Stat-Signature: pw7boytshfp7mse1ybnhknt1qram6yjx
X-Rspam-User: 
X-Rspamd-Queue-Id: 6B8D81C0006
X-HE-Tag: 1780033003-626304
X-HE-Meta: U2FsdGVkX186tf0L+Iz/A8TvVjZon7kfBdEBm7gdu9Yrf9j2NjHVVw8MUnApK3XWwWwfDz4ByIAAe4A0PH17ipt+FjqQgUq1FNL2Vc+7SjTvr8CNIP4gArwghafKpvl2M/of9R2sn5p8wJuKDfdnKlCfVi+PQcJrj5ZgVTs8m/HUMIj//XJA9wxBrAmxmrPirZHd5dG0vgyaF6m94ZaI9ri7Rrs6K8l8bVw81qWaei/9cp9h67oCzUVA/9XTon0uOZoPgrWIM5cnSkvt29+vwulFay8UgIn6gp7pdJcr0g25kFlrvG8zJt8XwIChtdqDqgzKtVkV6TmnVS3NK5s+OjWvGfGZjzs24m6OT08UCZ65qVR/aYmPuCcwzTHXjblXMTG3tH5dLJpKpcylBrpy1fZv6BJ+5QsYeB2OAWD/Rv4fSz5HOkZVlYaCw4xVJxNtvx1r9RLkwpxwkYRj9tFWWX6ESOnstXWLjH9Tu+u9uVbTtFqbPyh1WpKRx17hpSorHlRNFZwb0J8fG0496mr3NvQkbuJO4XY+TTblovuRMAaWUSQs5cMh9g+1EAlBVBn8f6wHWdNwdK8bOnKTk9MhO1zyMfoB5lJ4pJnDgYM0L5QCspWA7kZeNwXBXLpZ1nBhJnUruEwbNKeKcBKKeEfxPWsXXL7ybBkkpiBfy8E/IaPjf1qdnuYXCc9s+r3qso2Kx6SDyu6wAmAaZqkhXOmmKqzMpIgvj+I3H4kSLAZousarTTeuM5p23c9EGmXKriRJD7mx1HbV22ncGbindo6IQD+Cpe/oElYEE04PVVLhFyEr8lHmffKRSlFkKCBcY3JJPHuYSm2xjrAE620jlP9aaF7qOCQG4ggf5BI9+SG7W3UMZksf9gArb5z1ECcZNiwxTiFoZci76ePiiDzhWXyjjUGHNei3V4GVF2qn0PrL0ady668/ArLUzDwB9RzQ8DmddMhwCmgp9MleMxXREok
 sTyD2xM6
 jGOYyb4nSREEUXsVlB+MiqEhHytiBeGKepGdS3mwgrh0Orbv3PQ6Esq9J38d4g7d6OPF3Xop3zg2nkzUsB8TkvyAhwntVaKbFnuOiS1S5+LRmLlRC06a27h3LLW3b/P3LzH3D2KZt1ZQ6QSqtt0o0uRk1i6TGcfxyMU2YCSGgDMzoPdQE9EW0HMrJ32lFQas0kiQ8jnJssoYfu5uBv1BtUjU2REoW5MvuVWeNxPv7y7tQ3gOehpE5xsedFocS/XXiRzNsZFayEvDmx+FCP3ZWYa95JQecAijNJ9eAgjt9rS2NcLvzyqURWgh+q5Ae/FDTXDfWcPvR2gWkdB2zZjFsEPkMyHpCEGt7vxGiS3EHQSKhXDikSnYnCfy0iKUx0JjOeEsbfB99eqWpXzfKSWuUgFhHTws/qauKR4IgYdW/dq9fkp3HSRp9Z9JZNSNCtVeYHwgQKk+gK1XV1NgzMbM/L2vI+2Jd5Db4cbhCbbN+iz2mpYoRyY3/8kTJTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 03:59:35PM +0000, Jaegeuk Kim wrote:
> F2FS merges bios before submit_bio, regardless of small or large folios,
> since the block addresses are consecutive. So, I think IO subsystem was
> working in full speed.

As does every other remotely modern file system.  But that merging is
surprisingly expensive, which is why using folios gets really major
performance improvements.

For one doing these checks to merge touch quite a few cache lines.
Second, devices are often a lot more efficient if they see fewer SGL
entries.  I.e. having a 1MB bio a single SGL tends to work better than
having 256 of them.
The same is true in the kernel code itself, both in the submission path
(dma mapping and co), and even more so in the page cache handling
both before submitting and in the completion path.

See Bart's patch about how long the walk of the bio_vecs in the f2fs
completion path can take.  We had similar issues in XFS even in the
workqueue completion path due to lack of rescheduling, and these simply
go away when you do the folio manipulation in larger chunks (LAZY_PREEMPT
would avoid the need to explicit rescheduling these days, but that just
papers over the symptoms in this case).


