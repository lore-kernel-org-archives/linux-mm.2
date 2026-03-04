Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CD70EF8FE2
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B68C6B0088; Wed,  4 Mar 2026 08:29:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52BBC6B0092; Wed,  4 Mar 2026 08:29:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E37D6B0088; Wed,  4 Mar 2026 08:29:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2072B6B008A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:29:26 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C341D1B8365
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:29:25 +0000 (UTC)
X-FDA: 84508462290.07.6B3109D
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf07.hostedemail.com (Postfix) with ESMTP id 99C3740005;
	Wed,  4 Mar 2026 13:29:23 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=n5QQoG7N;
	spf=none (imf07.hostedemail.com: domain of BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772630964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FPYKHuv7AZ8xAducUFk6uwSA1xo0j120mBJpQUPt22c=;
	b=7Ie+G2tQ9hTjaBoPZajoxa6MvESMCZ+YReyq65QGF6xMCe27V3AlPaFGtCZF6cdSM8wV5+
	i0X5AOoWujQfwo9MrWnjWSoyzf21HfOeNFioVcyNx3B61YZWrzP6ogOCR+NImVGnAj2vZI
	50ihVLtJUqn3JwFUA0mlzC20CcGxwZk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772630964; a=rsa-sha256;
	cv=none;
	b=xhJ09z/YMqqrATHmAnyJ+yH+4dw79uQGkkn0VCXnE7TAvdUCwv0eJ4QrKMrJQJXc102lnf
	WPY60WeWusDquJr5WceLVTeL4m6NKACv8CZe3FaKHJnEnpAQsLKBAlsy7RITsJi/zffJTg
	Z0eMAB0cyHN+xFQzdWPpKik+zYvhn+4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=n5QQoG7N;
	spf=none (imf07.hostedemail.com: domain of BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=FPYKHuv7AZ8xAducUFk6uwSA1xo0j120mBJpQUPt22c=; b=n5QQoG7NOMOH6TEptJh/ogSnaC
	3AJmft4GcyF4eyoO13GGaPp+l/ZRDQ4b7Ptiscp2Vaj6Ck0j9oEIW3/JSHXOnhzbSuALODACCxojE
	SsKBb9DpB6I32LEDU1bvZLlShpPWhMuCy8SII00FJjfj+juKVt1A41YvVWRgEqNESR14Y4vhemMol
	GZgSYGXGksYtXcG+66fJpGUbZRCTz0Z4EyEc5gp0CqGvhccqlLF8QHBhyT3Wq/xrTW0nYaPbaHrKB
	sK4gs24MZ//2nDpGlVTl7dZpopefdPsa82gEJR4fpzqLjMrYV0MekOvPO8ZG/JF0/GxIY8ODTtw/h
	hdGC8DRA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxmHt-0000000HFO7-32GD;
	Wed, 04 Mar 2026 13:29:17 +0000
Date: Wed, 4 Mar 2026 05:29:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Subject: Re: [PATCH 21/32] bdev: Drop pointless invalidate_mapping_buffers()
 call
Message-ID: <aagzrZBKdftBb84n@infradead.org>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-53-jack@suse.cz>
 <aabrf4YhPJ2X7n9q@infradead.org>
 <n3anrkzfguzbn5sfwsom472cx4uzejyfemz3d5jm7c4rt3qr6z@ez2cgwzmbfyi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <n3anrkzfguzbn5sfwsom472cx4uzejyfemz3d5jm7c4rt3qr6z@ez2cgwzmbfyi>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: cw19arq3hqu3edqt8epmtj8ug3b17iae
X-Rspam-User: 
X-Rspamd-Queue-Id: 99C3740005
X-Rspamd-Server: rspam12
X-HE-Tag: 1772630963-887302
X-HE-Meta: U2FsdGVkX18vXdX89GhshqF6cyCrFELDXJeCvEg+12TjljuBxhrsQJhKNBhFyUbSz0ptWwtoxi24E6EnfkFr/b07cn0hRE1GYtaovpM2a2Y/noCFTSUXGGCEGkHe5Va1UXUSCFkv7+VrPFz2wTsC0W96+lOWC+7KMq7ieA52vnnWvual4hZJRUAiXFtEwMV6Cu0tl7AHfPeUE37YsYhylwMStGEpj4Egq6q9ZE/CcGZr1fqKZpr/ybQJ7EbUf7FGCgbA9IElVQk+k8NlB0rXK2WM31nCAXVwYY1Hj2OQnSK94PzONd2FMPtxmUQtv5YQifIeceqgC46KXVY0UH9pLM4RpOQ0ULIMXSJRyGx65V95e1AUyIqhzKIcT1NTgyghVdJsb8NkSjBRaAxgSXl/aFMfzEvkwC3HknVhmLqJ9rWnP1emirH/F61PXAU8wURNEOI2DrlTI20EwXfq85aM4RPo1X+20Dn1fzCQHrZcKIHWAxm+SNiqf4qknRg4+ayUzMKl5TiFZUrRkfWgi+QQP3pWLNfYHe/mUYq8hXDEc9uLE+lSFyLH8VTsgqrRco8lqFjYT/ANAsscH4ss6jQSuBQszIsDAaL0fPwCjDu8IRr533eV+Hw3GCiZYdKHecpj5AZZZevV+qEnqo4ugdO/RJYQW/YhjS/rrf5+2eKvdP3dSwG1kIS2+ihqYzSdUw1b2Q+LU4C8ZtIgJ/saZJbpq9Yn0UCY8z5vUUE7YUZEUCFrPyIMHb3xR4ZlHZddOi1sxcgBVFy9W4tvvyqy92uUBl7TcChoFxn0tAV3PAaUvJA4EpCKTF2+prD0iG662r6khPCtrH/Eww0SH0+HdChE3b7kf+FRT8/5FKvuUMffMU5M7TvCpiTtBsaLNVdFreAfyTjIbRiQSrYbG9pgrehI/432SEEELBTjSokNYOLGy3aG9c0dh63LZDFw1t6QlMBbET2DuMgC3OiA5jf5hdJ
 7wLLGtrs
 7piEyaal0ShJBXK4Umo7x988LIvhjL7RKafm3AdS3puhstEYoHJDgZdLRqV62QoKOrSd3olgG9RwNDCW8jA+2jMITBV272zO6jrp3uT+fsm0Xtl3b++eR7dlbitDt6SgDaQMBIYiqTJvmADuuPTwrPMFCnArwfcinFphqzcQb/+5JddffuigsxE7RgGtntlIcAse/rCtbC1jMutZZ8+kWbX1o8IjoGY/DAVxARqwlbBQBYau+Kxs+QMf+s6ON2wIeHEYlVUisafpiOIkUNxZthgEVePigfY9Rkz0aEJnJP2VP0JhkNiY3boyaV0kchUkgMrDx/hjqcz9wTTTZlD8VLqlG51B+PdXMgjom3wH8P64705EBtTqiHbNudapOjz/3bpBEQQraW3QThwtbkAl98JFkvC6MBRlmAInB3bv0REYxDPPRZFsfG4sE1VQHFMyCQC4n/54Z1m3V/In5EpItkgHni2DiwgQUMMshRG+e5OmvgAbtbbGLu8ciTDVrI7DeY4oiItmOIGs2L6oHdy6X0S9axAlZaeEmsMoXHLxdG9B/9cZnhE2B4BD5Afmq0lsUGeHTIR0O/dzHaqh1+cj2OPrmbnqfC72QAwwUzB4i2QjfQPlyHdlziqvNRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 11:36:29AM +0100, Jan Kara wrote:
> On Tue 03-03-26 06:09:03, Christoph Hellwig wrote:
> > FYI, linux-block only got this patch which is totally messed up.
> > Please always send all patches to every list and person, otherwise
> > you fill peoples inboxes with unreviewable junk.
> 
> Well, I've CCed on the whole series everybody who was non-trivially
> impacted. But there are couple of these trivial "remove effectively dead
> code" patches which stand on their own and a lot of people actually prefer
> to only get individual patches in such cases. So I don't plan on changing
> that but I guess I could have CCed linux-block on the whole series as
> buffer_heads are tangentially related to block layer anyway.

Ccing people or lists on just part of a series is always broken, don't
do that.  If you think something is just a FYI only CC the list to cut
down the spam.


