Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15DA3CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 14:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 766A38E0076; Wed, 29 Oct 2025 10:38:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 73DE58E0045; Wed, 29 Oct 2025 10:38:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67B4A8E0076; Wed, 29 Oct 2025 10:38:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 575648E0045
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 10:38:22 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 100925B8F5
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:38:22 +0000 (UTC)
X-FDA: 84051407244.24.B0AC7F2
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf23.hostedemail.com (Postfix) with ESMTP id 42827140005
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 14:38:19 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="GEuqbie/";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf23.hostedemail.com: domain of BATV+a01530d85467cd1df9ce+8102+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a01530d85467cd1df9ce+8102+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761748700;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZSNefP3kGlhfDPKLLTZZZwOAu0fb7rvyzu/Kl7KhTYU=;
	b=8O+s+AfdcK57NECY1wgQSsVAYlZsYfOBhg5XGCSiNUEGD4+Km3yVsQrEZV3o6LGlrVFIFX
	JDJ8ZgyTRk61hxrR+Odg8o5fUB05Vp9BL3N6+o3PsB9r/UPN29g4sIqIUpZfyVCAdohHG4
	3MJCNlt1wNUEP9EwoQF4VfNnPzwNO+E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761748700; a=rsa-sha256;
	cv=none;
	b=WDeSwip8C23IO7mplpNpTDHBeYfEqE3LjzsjwplJa/ZvGF2q6HmXh+WV/qTHzN128Eibj8
	QAM5Hl4qIrY4+T+NUwbm9WrteqndCChxtwGlXscPYj1aeoSkBi/6r6qte5Q05HdAygvIMb
	n2/RgSPY1xLOWeCPpWwsHzL/eS7W1FM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="GEuqbie/";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf23.hostedemail.com: domain of BATV+a01530d85467cd1df9ce+8102+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a01530d85467cd1df9ce+8102+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZSNefP3kGlhfDPKLLTZZZwOAu0fb7rvyzu/Kl7KhTYU=; b=GEuqbie/FD8XRtOvpksnrYmVM/
	yxBYrL3OAGeTQjnvYE8lWldox55/VPUDo9bbo1GS/N63U9F8V1KN/y+de3zS+l34ZZ03nWBteFZf7
	DMo3ovFyKPDMV9Q+jJqEW5TtTYwBtOrXcu2CkMdedFvHOJYFYA0QU4HSxPXmAPQjp70karpYHfF4O
	nqq9/8I505ZPmHqy0s/iYCPoIpcCrpUjAP5mLXSWZ9Frnp5NhnbQ6ph6uxqUu3PaXLSQWfAtupK5+
	hqOpHXJS4gGOGpyAUHrK8m1Pr/s3mdU+EyQQCElhMSxXXZ+fs9CJo/mdnfHuAYJD1R7FpPyQ2fBBj
	2g12CylA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vE7JV-00000001cIo-3QHR;
	Wed, 29 Oct 2025 14:38:13 +0000
Date: Wed, 29 Oct 2025 07:38:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>,
	Askar Safin <safinaskar@gmail.com>, linux-mm@kvack.org,
	linux-pm@vger.kernel.org, linux-block@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-lvm@lists.linux.dev,
	lvm-devel@lists.linux.dev, linux-raid@vger.kernel.org,
	DellClientKernel <Dell.Client.Kernel@dell.com>,
	dm-devel@lists.linux.dev, linux-btrfs@vger.kernel.org,
	Nhat Pham <nphamcs@gmail.com>, Kairui Song <ryncsn@gmail.com>,
	Pavel Machek <pavel@ucw.cz>,
	Rodolfo =?iso-8859-1?Q?Garc=EDa_Pe=F1as?= <kix@kix.es>,
	Eric Biggers <ebiggers@kernel.org>,
	Lennart Poettering <mzxreary@0pointer.de>,
	Christian Brauner <brauner@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Milan Broz <milan@mazyland.cz>
Subject: Re: [PATCH] pm-hibernate: flush block device cache when hibernating
Message-ID: <aQIm1bfwKlwaak52@infradead.org>
References: <20251023112920.133897-1-safinaskar@gmail.com>
 <4cd2d217-f97d-4923-b852-4f8746456704@mazyland.cz>
 <03e58462-5045-e12f-9af6-be2aaf19f32c@redhat.com>
 <CAJZ5v0gcEjZPVtKrysS=ek7kHpH3afinwY-apKm3Yd4PmKDHdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0gcEjZPVtKrysS=ek7kHpH3afinwY-apKm3Yd4PmKDHdA@mail.gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam01
X-Stat-Signature: so53ctsi1p41x1961j8r989n6ubtjo3o
X-Rspam-User: 
X-Rspamd-Queue-Id: 42827140005
X-HE-Tag: 1761748699-59763
X-HE-Meta: U2FsdGVkX1+vGduoNob1WrdsMrBLhW4aMyqeLxyq/KWFG3Zl1dcHYPMvtmFrw54ME0r+lrj5nnwUB+4+ZjaJDxIqJwjbVhVw0PrLuEy3BzWsVVwot/icdWa43SHQnp9oZIBhXMnDzuimnNYzLCnK9KXr/PucpSezlPork734IglUai0+2MUAaEqHpY1RmOgbldkXpwlmKD70Vjd6ghYh4JnoYW6+BIqrkiK0CMu6j+ZozDvJQo1VDjD+LvMEZRZ4jMxOMCyeFFexGEqbpWR34sLGo1o8Hh6uVKsJ8dEBLveqLIBlT4H5tRF9NnkUDAt5kzRMDvYAzM5n8zc4gtnhaKUhwYhU6cslVnd0Q9BwsQgzcPLENFiVZKPQp2P5cBoNjN3Hsm3cV7ajvHuaNIGSco+oweApTZ49JOTbm6vVd4jD9Lhj1zPKEleJI6uUc7Ss59WCKuAOnEbGCm7LoAPIAEiJbReqRopraWmhqmDaBG/EH1qE2xl1iRilkRbhMMY9N8uHLIV/q9w+Jh8s91hwAuS4Fg3ljkyCH+njIJAzI0lJU7R60RYTqSodT05VVxHYWVnPZiucN48URAZUiOsVOV3x1rxynbgeoXci+3Nck5/KbzpRBOHWb17fdJMIV1KiSMFXe0lXACKR/nxOxzbfgmyQor4TZnxius7qb+k2lOUfvz9aUXkGfVJpWUC9vUg+Qfkhb91SOEYLBZ/i+hKo0K4XdfSfnBazh8bU0F/cwdZMzy7gvr9hoX/kiAu7AClPoGgVyeqtYRaXaGknTbrx0PtQP/2iP3PDG8NTCshnl6MNqufLB+k/9SmBc0Ic0DKGq0OibykPi40WpTcpWUbmgNBu9Rumim7/udgcGaCKosvwRwUuUcpjWSndTVYRmXl1gD4BgfEIuGeuYZUon/F6Es7sexLp27G6g1qGAQq2fLGe1YRD+BhpJ/PDrGc6O4VX8BE/SpIJlHD01v0+YhC
 ujkl0KeS
 mzD8isPzzX7sJNvrnw4C05zE0fHx4Q1O1fjCiHhoLjbSrvvlkRq7j8ZJvJkbt0Gz4FKrlYwEOTgW1hv5N2Fosok7xDvB05ejQ/tBjfFro5/4o8xIj8hr1s3HZ9xfmxIgEzTu9MQyIUiHOrB69iA+fsU5vn/FeOGrvQfY07Al9ZhfeIQR6PsP+/w+zLQvE6eiVQrqQ0pk9NAtQw0hVGm0f1oiurXUqQySughL8Zd8nwb69o3+EjQtsdbbOQOEDWy5jbklC7rUB+DzyrBcJYtTWr0IIvHU0gzU3qWcEKoSn0STVbf/oetKSxsLKe1Xti9E4lOJvK7tzbhKHpP09qO45OXQbKQJ2PPaz2ITUQW+tgz0M+pMf9F518L618Q68ly7O3h1x9ifGL2rWxnzoRElTJHe9bsYzM0JMb9OVC4nWpkWAEyIODpUujLMXNEcOjQhLWbtZQ2U4nv50bx7MnSNrzZlGJopVx+DqG1wsElNksyo3ggZYO/Cjp23BGrsdbhncUWXlQJVOVmT9q73+NGwEq5DIkQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 02:31:05PM +0100, Rafael J. Wysocki wrote:
> > This commit fixes the suspend code so that it issues flushes before
> > writing the header and after writing the header.
> 
> Hmm, shouldn't it flush every time it does a sync write, and not just
> in these two cases?

It certainly should not use the PREFLUSH flag that flushes before
writing, as the cache will be dirty again after that.

I'd expect a single blkdev_issue_flush after all writing is done,
under the assumption that the swsusp swap writing doesn't have
transaction integrity for individual writes anyway.

