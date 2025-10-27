Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0313ACCF9EB
	for <linux-mm@archiver.kernel.org>; Mon, 27 Oct 2025 06:54:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46A7A80019; Mon, 27 Oct 2025 02:54:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4421D8000A; Mon, 27 Oct 2025 02:54:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37EC080019; Mon, 27 Oct 2025 02:54:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 251EE8000A
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 02:54:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C16D9B9C34
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 06:54:54 +0000 (UTC)
X-FDA: 84042981708.24.1E8D765
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id F0A5D4000B
	for <linux-mm@kvack.org>; Mon, 27 Oct 2025 06:54:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=H0uxDnnF;
	spf=none (imf04.hostedemail.com: domain of BATV+f89618a03c6ce0da8aec+8100+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f89618a03c6ce0da8aec+8100+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761548093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HZ1cENyC3OKTlLcokwNqr7wXJ9H0uHel37Dp79dnSVo=;
	b=TstlTDy2HLRUZmdsKU8SBXYs+jOTLv5gxF41/8IwokFGIfhUpnwKMb64SUaHYBf9Ech+8G
	04WMdwMs94rG0/+VwvU3chBY8zQAXLNoKoYgyB3bf5X+/ZXjxCBHM6YxDHHhpyUYxctndh
	phgVVfYT79WWJa8VW9gfSx6du5Kr5xM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761548093; a=rsa-sha256;
	cv=none;
	b=3pZ4L857z/LZrF6jngvyqxBGvuI5lRFQM5eouAEgtaa9FFPnYwTfzX+AEQjAAm8dRQX9nT
	sqiy2BWHoTjmK/fS+x0g0A38suzdiAKp4pTuVoUMbeH6W5/l99wG03tsckUw5lyo+t6CDD
	hPHQwwzXctTDRMhUuOYRF6JWCdlg8m8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=H0uxDnnF;
	spf=none (imf04.hostedemail.com: domain of BATV+f89618a03c6ce0da8aec+8100+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f89618a03c6ce0da8aec+8100+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HZ1cENyC3OKTlLcokwNqr7wXJ9H0uHel37Dp79dnSVo=; b=H0uxDnnFfGSmqhHOC8bIChmg2U
	zqeyhzXYYeltjfd6s4eSCvSF70/LWP568ahKfzgVEL36melttZ6xkUEonRCPOOtUxFfYSBRpetta+
	C7jrPsmafvNgsoxIx7/8DlYPxU5PJY9qXHXCDW0eoWTxVVCPHBWhfdRrqyjlYhSM5niMX66o9vCB8
	J7qRUYdVoIioFx7orkFpT2m/6CPixRMfzocTeUS/eIX9j6/yvQzDPN05SSmiVgbZX6oI1Wv6FVQ0+
	IUxehKy2s3qD05HoxXBvxki94YTFIG+ro6y75bhoL0D6Pr5Wv9t7QOYZcqZ9EfHhKRnHFPTgiQ6gp
	KHi+loWA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vDH7p-0000000DEPR-06m6;
	Mon, 27 Oct 2025 06:54:41 +0000
Date: Sun, 26 Oct 2025 23:54:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, alexandru.elisei@arm.com,
	peterx@redhat.com, sj@kernel.org, rppt@kernel.org, mhocko@suse.com,
	corbet@lwn.net, axboe@kernel.dk, viro@zeniv.linux.org.uk,
	brauner@kernel.org, hch@infradead.org, jack@suse.cz,
	willy@infradead.org, m.szyprowski@samsung.com, robin.murphy@arm.com,
	hannes@cmpxchg.org, zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, minchan@kernel.org,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, iommu@lists.linux.dev
Subject: Re: [PATCH v2 0/8] Guaranteed CMA
Message-ID: <aP8XMZ_DfJEvrNxL@infradead.org>
References: <20251026203611.1608903-1-surenb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251026203611.1608903-1-surenb@google.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam05
X-Stat-Signature: 4h8xtbuxetaw9uc116h3qzipoutpjaag
X-Rspam-User: 
X-Rspamd-Queue-Id: F0A5D4000B
X-HE-Tag: 1761548091-77983
X-HE-Meta: U2FsdGVkX18I+TvuwnpumcNNiID+jwkLpcbIXzZO3u9sjR9hEwEHO5Q7EydcLS2hzBjH+6kvvjy8b1TRcQY+3xInRXtwff7FqZLHQQI4eEpTHyFevRyxB+vQcPjczaObwe4n0yInYnKdNdxw7kKR/y6YGFWqra0yDYfFCuk1pyn3ItrMIrAHuK2u6NZpLcuqmPNAaaJl5y9jOKebyWw9M7cEsF8SUExUopC2iwrdYOGTvtwzaHd700vBMU9ghyEzRupiWlsXgz40xciDMdqoHcSeIG+HUoscdzbtVwqzE4gHxDIWtoiYg0OKT+hEAQo1XfyHwvzKSg6zQTbEcUbZMdjxad29Gx+vRjFbAXo/wDOFdZK4gJO/DxckFd+EbbG/50KkfzRtN1m8rvpRgFwhFc7ZdKcViBUAXAqgVRyYvwWR5VtDi4NNBb2kv+Hq8fvcheUZF/FB33gFkDiqrg88FPNgNCd645Hvh82rtwozNOc63xXjBo42JwB+expLfqxdgkotANQXeJ3FWvVejX6OSq53Vqgfp1FzAVuiiF1ZlEJo666Xx7jxuB32kOE3WcfMWliK/UI2R6fP33Oy5fk0dYx2us4q32Pmf4ZOmdbcDY+OUdNC3U/E7qBGW0FNt1OCMZ+HrcWzDmyjFbkZN+33qdNvysDJwRrlxeh1NtQpAXG3viz3k+2hMduyWyfYAxFrCo1/hRXsSOCUrf8DxnrBg5tcE3UPAnqiovYpZa6uYy2hqftzRxGoebiFJGJ8GfMzgmrPCbDff9P343NAy5En4kmNNVegNQlROXsUVDMI3+96bgAw2ovWvWf5sU7QPlL+uhWa+L3MwuDUynjvOPDLaJlpQSV5EYa8HezGqyrSC/vo7xNZxq+/7Fi00IOdTtZZr1UzW4bkItvujHKXzo7YIqtmpG2GkZm73lLfCdpT8TY/193a78blxRq8gJsej2hNKol9ikbwNO70nyjt65S
 7Jfpxc04
 UJY8ZlwXr+a8OEY4QYjhGhcrAwIWNsdHHoyalpIMQrlu9K1gtkpeHR/oGlIaBcI9edTfXFrd6gQVyBEhCzXh4R0RRWaqXLTMz7QO+OtL3HnXXFd2t80FXwvhkG0WEzd/zR1OzITB13iM/OvX36Dx5hchdWBufzQBSZDKZjI6SoqMJvl3lELk6gsUVAQIW8kJwY2IhI035tUQxampGIlLzrZPZGQ2ydmwQXP4v8cPbZEukfy3Ic3VW5e8CONOfaCjdB4i6IeRZs47NmHwQniP+vJ62IAVRANWivMnT8lymw/pYUwgJ25/g2OWi1oUnMKWOeDU7J41FVKa/NjnHjr0xlMwDIPDTzBpfeRv/YwL7Hj1VlULYCgTUKoDTNnS2s4EbzGJT0eSVB1448A0InLXVD/ekX1r34Nhykg5TuDfGfEFoRAapOn05fNAsO2oB8P43xNivMgUNz58ImSnJhsSm7dwGmjMvQlIUrefPUnAFmbeLcbnG49pFsQ9pSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sure,

jsut as last time please don't build empires with abstractions that
don't have a single user, and instead directly wire up your CMA variant.
Which actually allows to much more easily review both this submission
and any future MM changes touching it.


