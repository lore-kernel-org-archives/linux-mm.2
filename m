Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24440C5DF97
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 04:39:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8838A6B0088; Wed, 26 Aug 2026 00:39:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833BB6B008A; Wed, 26 Aug 2026 00:39:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722B16B008C; Wed, 26 Aug 2026 00:39:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A2786B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 00:39:26 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 29B8D120272
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:39:25 +0000 (UTC)
X-FDA: 85142166690.25.6E0665F
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6CED1180007
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 04:39:22 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=uAZQOpGq;
	spf=none (imf06.hostedemail.com: domain of BATV+069b6cbc82efeb758f32+8403+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+069b6cbc82efeb758f32+8403+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787719163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41Rt0vAQEaJmrkrfwUslbqo+28BOf48xV3lYK1P5vZg=;
	b=GSep+Gc8DeCHInv5fuOP66jugXycXTqUZQh6UBZ+YXs0QlFoK/gbu8ztqQHer6mkuwxqCA
	OpfEQYlVjeon34JwFvznAoLVmLS4baKsFqZrJ3DeMNpUjAEmakv+LT2ORBwc5zRXNQGBSf
	J6zFX8uGwDpxlfYnbKDSfn6uhrkQHVk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787719163;
	b=Qalj2W2XApd5pGqR7CLb7FCB4/EwhEHwQ7b5WZ4An5mAttNqJs0Tz4Dai0nJW2GPAPEjIR
	PmlGbx1kF7S3J8jVqSDLH5ovnocdUnvfaMTptco1n1XAn9jac4+2GptenSR9giloZW9xPD
	cTaWeD1FtEqeQF0rKAe2wg576qJlC7w=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=uAZQOpGq;
	spf=none (imf06.hostedemail.com: domain of BATV+069b6cbc82efeb758f32+8403+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+069b6cbc82efeb758f32+8403+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Transfer-Encoding
	:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=41Rt0vAQEaJmrkrfwUslbqo+28BOf48xV3lYK1P5vZg=; b=uAZQOpGqaJIyDd3J+r9WlB7Obz
	wJdFDpGyGtfYjCcU1Xr5M86W5pupAvOwisRVvGpjDsHhp02aw7zw4hMb2P2rjKoAYDR3krFz/rlDv
	13i2f8YKpurLuzktnuurtgX+bnfuy5sQa54CmDIPT2g/2sTWLUWI17Lt8CDuHUSDf5lUBMiHIPius
	bYPxgFWjijeSCQ2XeLxHF30YHQqbI1YLPHufVDNY5fNOGRUmANo6yHJcowjqFbt3AUWuUYjue6fBI
	iyto6yWbbL/psPXFmN5vSH1IRp6Uk7inpBarOilnFJloUWRlMIuLgP/URXOX2rfl8Iet/LBafvWpW
	IQY1YMyQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wz5Pu-00000001tLh-2NRV;
	Wed, 26 Aug 2026 04:39:14 +0000
Date: Tue, 25 Aug 2026 21:39:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Rik van Riel <riel@surriel.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	kernel-team@meta.com, Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>, linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 0/8] batch lookups in follow_page_mask()
Message-ID: <ao5t8lxaCWQvph-l@infradead.org>
References: <20260811025157.1632867-1-riel@surriel.com>
 <ao1JwEAeNcP9OyKR@infradead.org>
 <a10c74df79e1db6a9a2448220fe4c4fd6a0e5bdb.camel@surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a10c74df79e1db6a9a2448220fe4c4fd6a0e5bdb.camel@surriel.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6CED1180007
X-Stat-Signature: o3698m4ddh4r3muqmhddam9ijichh9wu
X-HE-Tag: 1787719162-117221
X-HE-Meta: U2FsdGVkX18GBKd4oH5EI5g6UxwKj0+avtaQ/aKz71lREKHGD7NMD2YkSEKgVrWoF/FvUkOJyEQAP9+6mNu3AGw68S7tK3tRA7C6ZjJa6yPVCfN3lBigNu80DrS2I6EsU8zUEJl4bYm7rZcrr03/W3HGmPPMj6GgeS1BPYomE6SD/Dktj/F5/AD7k5NCKiObd7NHeeZ14ArXbyPVvYgXRz4XlLbOteoy4Z/cIjasLUEZp4X/eq337FDvh5qDsj7pKbK7q8GsrJGdq64JZSe5QGLVLcvzAL93+nCSZgHzS4nOQaLk6SqbfZFGWRnkRC+0cqDfgIc23RcQW8/c8W4fdsSdDMoriGPDF3kyJuL9kHoed/AGZRRWc+QESdWueY8k8HIOZpW+ZS5OKez6lkmHmYebRU4tVxlqQegZpCXYB3hgf6Nk2XZ4jvHck4FMI2F9LWcKeuadvyzcS9VS8b5LFRgsFiplXXeUOQBIdqQaK5sVpkXwFuUE4OMVhUf3MpoTIOBb4C0bocXpD+1G6zjzHJaNrsIyvFmVcgBhVEK/safeM8MX5S7Ht3HWAtBjyDBr0xuBGS42sIOeOgFHBX8J2uFJ+emghJ7lwNAIrxMqG4QJev4TdH7O34Seo9jZxQFPg/mqvcdypsvtuyZFxOZ7GgcUCn/dWu3w6OYZkbHFrzdB5lzL8LTtisqXv70aA8MnXoKMrUyI+uTa3vgssR8mPnjDM704WHxcxX8BL5GVO9ZicgdFPXSVjnowBav/JziSbX+gX0SCkZJL/o4pUxtsuqydO+Xj1AMtWSqNnEYRbX1bs3IkRvj6Nez79IqA09QErI/gjwv9NW64r2SBmmnKGRF9ekruDtuVDO4Wpp72hQh8zaeb+icRb5BdT10rm7voRcH1j/6rK6quBHK1xO0ubDiC76Gno9ntkHY7NjDtjUeBrTBRgYkLk2RI33hAD+WZe6CFJpKwwog4nCqpv6V
 SIAERbL3
 MlzDlV3JSnAc2VDeB0jo0VGLlfPMH9gmE3ml4JRPNZIKJOaVk87zUb3RVRlMoAB0+Cs9ES8P1zgnkqXUAl2i6tsn/kQ7TmiDT9eiQvkCC5/1p0COn/iXGKXhiUekoTSGBw98qXmsYUaczSMXXpiG4PyHpOuE3FzlGpxUdk1TmapxN/RkvvgVkpURBFSNYwE1w0ozNR3Ue+Ek7NltSb3dN0tz7G3PldM0OmRAR7eCaFpo4EwBbx5oaIH+evTkmfWMY52G+je7/TW9f14Rjf1fVtPz2YigzhazMwXNt6LPYk4V8ah8BilgqtiWrfqAv5tK3amClGV+AvPYmN7m5iZsO8Rqf6SLtU/v9tbVkadqSBNr3m6KHxoEjiQy64DOlpeAyWJnwxOLIbiCughf/kuQPwDjcUtv2Rnuv4sZbjAKzkPsmmKw3qO+klb7axRQ4K59w7X34HUGaJdxn3aIP0glwMB3A3/j7+DBvTbkEL1bjma4fEDMbLC9cEUwZvO7p5tPAt5vTn8KM0R3AQ/tOrIa86ZjOyIMrMpJIMN9Aqg6nWnSKS7DrEJHqWWi+6Jr53D1a1GbJO1g6Q0A+flqtnZkzfT/TpfRCf3UGxoSu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 25, 2026 at 09:37:09AM -0400, Rik van Riel wrote:
> > And what many including the most performance critical callers want
> > instead is really a single bio_vec.  Maybe we can go the extra step
> > for
> > that, as it would reduce the number of calls into gup significantly.
> > 
> Which code are you referring to here?
> 
> blk_rq_map_user() seems to end up calling pin_user_pages_fast(),
> via iov_iter_extract_user_pages, and it directly fills in the
> bio_vec's pages array.
> 
> Is there another performance critical path that goes
> through the slower get_user_pages() path?

The other callers of iov_iter_extract_bvecs matter more, but this is
the main user.

And iov_iter_extract_bvecs right now is very inefficient when used
on larger folios, as each call to iov_iter_extract_bvecs and thus
iov_iter_extract_pages and iov_iter_extract_user_pages can only
fill in up to 256 pages.  On x86 that is a single PMD mapped
folio.  Passing down the bio_vec array means that for PMD-mapped
ranges we reduce the calls into pin_user_pages_fast by a factor
of 256.

