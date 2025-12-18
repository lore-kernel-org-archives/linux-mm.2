Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D96BD68BDC
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 06:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B12AB6B0088; Thu, 18 Dec 2025 01:00:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A960D6B0089; Thu, 18 Dec 2025 01:00:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A20C6B008A; Thu, 18 Dec 2025 01:00:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 86CC76B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 01:00:28 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 397181A0D07
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:00:28 +0000 (UTC)
X-FDA: 84231542136.27.D0A6A7C
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1E8BE18000A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:00:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="hbYodE/Z";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of BATV+3d4854a57dc9b1fc88a2+8152+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+3d4854a57dc9b1fc88a2+8152+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766037626; a=rsa-sha256;
	cv=none;
	b=s4DBxasa47PyvqBVawL2sz9O3IY+2voqj1or/RzWIX239ZQsnPUbKoEB3G1JrF7t06YCv2
	CFcLF1JxyVO7CHGgk6kjVmaqgD0LXTJmWsyumhz8nrGqIMyebXPJdr8SphMS/3CCtaMy0D
	UhwlH52/ICQtUq7H5sWfi5du+Fs5siI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="hbYodE/Z";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf16.hostedemail.com: domain of BATV+3d4854a57dc9b1fc88a2+8152+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+3d4854a57dc9b1fc88a2+8152+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766037626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7AZnlHdb5mVs/DWMBb/Fn6vsoTS72x+uWHSaGcyXP+E=;
	b=hakD1IfhGMNOO/Xkr+O5O6YyuiXzNn8qm8sOgXQ9zX41g0dNpKrQUmYCzQZA6+x9VhD7pL
	HUZxaGZ5+0QAJ0Z9s3hVUCUxU4TTelbjnOrQRqrkZnJNkykw66K75MtLAltzNlXu2fiIor
	5ntCvqTvo7aAQgqTUqZs3XriXLuyHIc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=7AZnlHdb5mVs/DWMBb/Fn6vsoTS72x+uWHSaGcyXP+E=; b=hbYodE/Zyf6pmKD15iiGgEvYny
	URWV0ikQGTiAUqJfk/PSiCb7vNaOYGN2qRdU4jxS2T8CHlQwVPp71BI12BCyF3hG0mVcN1bl899pa
	hMJgFHu3mXje2KoqVxoYnLDWr8TY7eDe8T4fEe9VkZ+hv4SuNErqi9oS7cGPlFSTgDKZXB/1XBunQ
	QqL02V3qkCh1mvXYOhIxEqENJSWMKemr48sTstuKC+qPTbAkYNGTRoJHya3q16mnaK2vEdr8Nlpz6
	YQQNA08ZkKSJRNlDK8ZUBmdHJRZybItT+Smzvq2zhwqzVxCxN4BjMVCYudQkk8lgfoJv67m5l8CVz
	CBcBV9pQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vW73n-00000007rvr-3hnF;
	Thu, 18 Dec 2025 06:00:23 +0000
Date: Wed, 17 Dec 2025 22:00:23 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	akpm@linux-foundation.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: retiring laptop_mode? was Re: [PATCH] mm: vmscan: always allow
 writeback during memcg reclaim
Message-ID: <aUOYd6FiIBf06Skt@infradead.org>
References: <20251213083639.364539-1-kartikey406@gmail.com>
 <20251215041200.GB905277@cmpxchg.org>
 <aT-xv1BNYabnZB_n@infradead.org>
 <20251215200838.GC905277@cmpxchg.org>
 <aUENEydFvVvxZK8r@infradead.org>
 <20251216185201.GH905277@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216185201.GH905277@cmpxchg.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1E8BE18000A
X-Stat-Signature: tz4sgg3qbqa7szndmzsgurxiwoc3ke39
X-Rspam-User: 
X-HE-Tag: 1766037625-501221
X-HE-Meta: U2FsdGVkX18YGCwCYxANcC8hN5wxcvwZ9iDS1ozjfGs1/FwzFcgzJu4nzm/aaKGLAo7FzOdU0V3R8AXIsxDTXPWmOxb2UA9zDrM8F3XYbYJITHEsRV82ciESWVFJS7XsYTbne2bdW/T5gDBaaWd5RZr8EADD0RBQbGUBKRAMlGwNlDKzpzZqT86fgcQ+IGaBjZ/J7mrndb7UNNl8GWuFrgx+weCBIxjoj/YU8h2VYlYPsYkDdmSuwNYMlgjp2uT20fxVVq0HWwqmYfAeRGxP5vMnOuOImJPaABXmkt4Iv0PQNFmnkH7ZXNjjEob3u7eaaxX2uP2qjml/BjeXI+nB1MyLjr0WXbU1KiBFFLAv0R57yVC5nvC86LqEmGipkHWIwXbiHvnGrlx+3Qq004pKKmZJ/odQsKyroqFarbkOaynWgKPxLinPUmkXobf/5xZ/D7LwIviXoC8zamLFHjU7f4EIQ0p4xYmURsP+xbbcf5fzltibqIOqAqCBE/eu8Ak2xJkf0sT3gXEEecO9MEjC/1qHzg3eVTEqiJrgsHz3s/Gk5+ih5Jp3bLCXeszeQHcdZVajNsjYRHh8v0HUEgJuDEFyLAGaxEX/fYfko3qUU4LjttdUyueATb5r8OCLRa5wJwJBRKR9qZNk7swVhi8m6dAgaZbpyv5XkOYHBd5VRnA8vei7W5XkKUtXbv70kGcDF4Q5vj6M9Me9HHsyvaCP1bqSQQADPK0aPNEGH9+8GChVMV5j/jWQEnmSF99s2l7zgyBflUIiRWa/Osy0gdGvkBe2Zm7RNQrUslrChHEVk0Rv9xuPGYOKifeZFevbJ9d6VhJmfl/ps/ev3+6u6wVthfucrWteKLuvt+TcfUSJMqLEkMQYA6Ru1WLlxJ6d7hlOVXDSCM4wBXrJLQxqUntdMT4yM/jpzZvVjPXu/kFVtAiS60vgvw0Pmo70BHqQrKm98GUcrJCcWmRDuzVmX1v
 b8keD0yA
 YU7l+PoVGSAbBIkieOZAcc4gIz5HYlhq4zCM/R2zo21t6ubUtuy+iwjJNynFc+Jb2LsU0P+dqXJw77N9ISjQvR5eMYUlMK12FyBCh+JVgdLYYqnxuybf4SpUZTag3pwKvpKMNPbzrEiFJR5iZl3c6/qWq2W+6hKqAnV6ec5046g46ZUf31qV+YNL2VRmQLCtcZlYTDG6H2HU727SQG+NmFcq2yuTyoaq9kZNvYbMG9sS/eY1ClsjwzagakImZB1DwOPm4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 01:52:01PM -0500, Johannes Weiner wrote:
> On Mon, Dec 15, 2025 at 11:41:07PM -0800, Christoph Hellwig wrote:
> > On Mon, Dec 15, 2025 at 03:08:38PM -0500, Johannes Weiner wrote:
> > > Debated whether to add some sort of deprecation sysctl handler, but at
> > > least systemd-sysctl just prints a warning and still applies other
> > > settings from the same config file.
> > 
> > In general dropping sysctl will break things.  So I think we'll need
> > a stub, at which point it might as well warn for a while.
> 
> Fair enough, I added that.
> 
> Jens, that change seemed small enough that I carried your Ack, but
> please let me know if you feel otherwise ;)
> 
> > > Laptop mode was introduced to save battery, by delaying and
> > > consolidating writes and maximize the time rotating hard drives
> > > wouldn't have to spin. Needless to say, this is a scenario of the
> > > (in)glorious past.
> > 
> > Maybe expand on this a bit by mentioning that reclaim now never does
> > file system writeback, and fs writeback is already very lumpy by
> > design.  And of cours that hard disk with their high spinup latency
> > and extra power draw are a thing of the past in laptops or other mobile
> > devices.
> 
> Sounds good. Can you take a look at the new version below?

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


