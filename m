Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF2D8CF2570
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 05:52:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162816B0099; Wed, 19 Nov 2025 00:52:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 113306B009D; Wed, 19 Nov 2025 00:52:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04F8F6B009E; Wed, 19 Nov 2025 00:52:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E83FD6B0099
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 00:52:12 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2591113A87A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:52:08 +0000 (UTC)
X-FDA: 84126285936.29.BC7805B
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf29.hostedemail.com (Postfix) with ESMTP id 88BF0120005
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 05:52:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DCDGMOIt;
	spf=none (imf29.hostedemail.com: domain of BATV+806892ee5b7c973308e2+8123+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+806892ee5b7c973308e2+8123+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763531526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I8I1AprjDBUOj7jue2dl3t9Iqf4Cwq10RSkL95tBmzw=;
	b=pNqyz1pvJeb67tGMkDAqMC5XnTP0hsu8ZR2WJo4SWKKIwoE2IFJhe1yd+GDOGmtVJf5GRD
	X7aYyoB3VKUDnoQOo4Y+0SYhs1LH2ba5IfCKvrcbhu5f7daEAmEsZkB9wQxJ5z2wXCZrM2
	s3t1B4yYmhNzoSE4B+IOR2OWvuU3o00=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763531526; a=rsa-sha256;
	cv=none;
	b=eR7TBVrl330Np7rNvG7tVY813bSbMTtYT6zkBatNsy6fjJN2v44EZBMKI7+1XDP4XCFo7E
	fEvmtDr5P5s0FhNZadUZgfuxtzfmqKCfIwuX9VDH7Ei2+9AyGVIrzA4FYgxfNuDkYUjgDG
	MIBeHQBP0ji+PVYTCnp2D9xtgzbX7YI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=DCDGMOIt;
	spf=none (imf29.hostedemail.com: domain of BATV+806892ee5b7c973308e2+8123+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+806892ee5b7c973308e2+8123+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=I8I1AprjDBUOj7jue2dl3t9Iqf4Cwq10RSkL95tBmzw=; b=DCDGMOItsmmDvLY2JYHYouj2Xc
	OMO73rZ6noq0tsz/j4b9DcP9NFeBYTfCbxfUML6nP9c2GxYLjlRYa787wx5GKEyAsMLJgZNRbOfd9
	NAAe/QcIO5vwHMXsvm0u7IRRN+j5fetrVEXgu/rAqG9m4KGIs7BTr0t3S8mqm43c2TH+k6j+erJwd
	OuF+otZTirQnwvM+rCvPmSCSsRzaKg6eCV7DFxxX99OsbSnkmCR6v8VEOjtDAH8m3zFTkL9VENnRX
	ISVNVDCFed/qMXULXTivoZJDh+55W0Pa5NmvrW8V9YxisnUpjpQsyv1w2o63rKf3sSBpF4l8wUhKe
	SxK9wpqg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vLb6p-00000002Rs3-1eOi;
	Wed, 19 Nov 2025 05:52:03 +0000
Date: Tue, 18 Nov 2025 21:52:03 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Christoph Hellwig <hch@infradead.org>,
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
Message-ID: <aR1bAzXYJF5TicnS@infradead.org>
References: <aReUv1kVACh3UKv-@casper.infradead.org>
 <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
 <aRpQ7LTZDP-Xz-Sr@casper.infradead.org>
 <20251117164155.GB196362@frogsfrogsfrogs>
 <aRtjfN7sC6_Bv4bx@casper.infradead.org>
 <CAEf4BzZu+u-F9SjhcY5GN5vumOi6X=3AwUom+KJXeCpvC+-ppQ@mail.gmail.com>
 <aRxunCkc4VomEUdo@infradead.org>
 <aRySpQbNuw3Y5DN-@casper.infradead.org>
 <20251118161220.GE196362@frogsfrogsfrogs>
 <CAEf4BzYkPxUcQK2VWEE+8N=U5CXjtUNs6GfbfW2+GoTDebk19A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYkPxUcQK2VWEE+8N=U5CXjtUNs6GfbfW2+GoTDebk19A@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 88BF0120005
X-Stat-Signature: t6ta7ya5eunky1rgiaorxcbqbkoeci4x
X-HE-Tag: 1763531526-808239
X-HE-Meta: U2FsdGVkX1+NflmVVILmLXzv368i1kKX9gtXMkOEBVv/CEv4Tg5TTapzEr9eXI8u/ZB4rMs5cPlIfkrbXAZ80jrPAUwc9NK6NXAMRp4aBoqTvjOcMCAR0lKB5uMnYDngjnXqP+/0jDKS9x9+1cvzPo2mNeynGvXPn0wFyee4QTxrMjkOQBmgYellcc32keSj8M5qtix9dNslpU+E0w6TzidIRQ2AMfkUkoEFB0WEog9wFWM679wf3mu7LpyOw+VrbQ2Sgw10Ux8Aqh3si8ty78tiv92cpQYO9E4wSUlqwkdzSXV02kYOoepDv86lGjzM+BhNqvixwdqb1xPIKsLc4632z+Ff/VEfJXx4DfVy7o4/bf9FvYnDVzyj2xe7a5w3xMzIqHQe4WSJxkU2RXCPw/KUFQAXEV4JCuPWgv0L63HkNZ6lNi8dp+PuywOXdgm2w4EhAwwUnDNJ7UPcvZdVO+Hv5ULSLQcgNQ6gkwFYYl5aUBfgZEbQ/Too2k6qPH3hZ7Nayg8XVVQ8xocboIqteho6YzbVA2SvYKx8o74zjKfM1iCBebXeRyLhAgx4TOQIHF/+pVHv+aVKgTj8PbTwQ68RtCb70cM72g6RXSBLtFCCwk140y5B1E/Q+RVeTyq01VQ51VWztalYcCLs3odR3Zb5vq6ghZG0fMqmoFRkQGc75sg2IFFpAli9cPe+orNT93dc+uh+CP7BfJAIPT0WIT4hgeykg1BOB0myHo+RaUPUPOgMMmQ35AEoq1QFx20eE9+Jtc/5716yn/EMszrMsVg4yp9VS8i88xT1kMIHylPbyaIC+eRtrwsbCOVSOWwvSXtJtRzIhWoeJYAk51xmv788JDjga4kGxeNt7NRHkNUE8TqN+USR8FP/P5mwTe2Ddewpf+hU58Mm5PJV5+48YR1CZoZPlX/MG9vvK9EaUQmpUnEbSdrFr8bagQAnwPA4JvyB6fNFahWapWLjp3T
 vfg4WTHn
 fEIJtPUi8lTyimTa3J/LnHDyuxgnABqQ48beM2lI3Eey5ZdMMjWLUpS2/y3mAlNN2RntsHopWwqQIV56uLK214dlYPS4p64gcPlKCFL8HMQ+c9gyt4gfRyHhd+wzezI2TA8MqE3jnP3lKR+C8SYRZOnXjjUMyG0F/Y97Q+uT5l2lqng3BVyg93mX3UM0oJZy096Irj5mZyJHZ+2Xi3zOwwJKVXxRTi1ZdhhAaBbKSazOGeaUi588P263WY3RPndDkgZ9G7JHxU/zd2u+297cwubo0yszQO1ZSnN4meITplA81OgeIW8mQpFtGMhi6/+29F1CgYK5PQKujJPukRR8KN91vWlgfkc+37xfVXQFlzS5HkY22LPZZqKQenC0zjTWpy+ZOAieonm2wvyQ5u6/XQQ8ZPSKok/KBxWTGydvr3esgm+OYC5AbMlsKL5n3XmqZJ8AVBsoS+9WXbVtQwAhipH7ZmSItXP8y5rnpgB4x8s9NQ1sdD132hBvAuryr51GuTGzvWJqeSXmA6S7+SjV/TGzDARYBfN6FETJRwPxOFTIQJI+XFxnajmhgaHpe+37k/t6JUP3GN7O0n9rrhzf7Qs9NgZU5dJi+9Avw4dHd5siLtUWggIQvq+uVbZ3vH3i1We4ntClAQWbhKmpHdWavDdDteVcQrhY2cq3o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 18, 2025 at 11:38:36AM -0800, Andrii Nakryiko wrote:
> We have plenty of build ID tests in BPF selftest that validate this
> functionality:

And none of them is run on a wide variety of file systems, presumably
because they are only run by BFP developers.

IFF we allow for magic file access methods it needs to be part of
regular file system testing.


