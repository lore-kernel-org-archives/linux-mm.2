Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EA85FD9E1A
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 22:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1B626B0141; Thu, 26 Feb 2026 17:04:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CAEA96B0145; Thu, 26 Feb 2026 17:04:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9EE96B015D; Thu, 26 Feb 2026 17:04:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 839596B0141
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:04:22 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 350768B529
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:04:22 +0000 (UTC)
X-FDA: 84487987164.11.6C96532
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 25503C0008
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:04:19 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=bmFMChbe;
	spf=none (imf22.hostedemail.com: domain of BATV+c5cab09b19de097b6dd3+8222+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+c5cab09b19de097b6dd3+8222+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772143460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5bu012TDyQPUO/wvA+hw2yCZC4iVJmbX0faG8R4aVOY=;
	b=BVdIFPhXJz/xotr5thLpCoUogclqMzHZjpxGJ+Kudo3XbdUbvzb76sRU6lF0/ujBFyGKsP
	oO7Afa2fCs9Nq3DAjuqj6nBhdKz1UaYFmCgEtjhgQBq1oEbcTtmglnA6CoNPErfR+qJiLH
	Y0BhsxRt5uQUDWk0JP7TkhRPXCtZef0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=bmFMChbe;
	spf=none (imf22.hostedemail.com: domain of BATV+c5cab09b19de097b6dd3+8222+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+c5cab09b19de097b6dd3+8222+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772143460; a=rsa-sha256;
	cv=none;
	b=Yk+n4Qv5ty4m3u4QoTs+qKIer6OeXRQOclOue+mEs6kXwA5+J7wW9Gm3LoeGkqHVH9GBoV
	S6iVWvyBd3Wl5HoLPseZx9RVIab9kg/IMqRnIYmZTH3R+6DIy2x4b9P/NIcoptBw20qv3Q
	h/UbrhT/XfJaTMANTI4L4gXBrE8V2KM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5bu012TDyQPUO/wvA+hw2yCZC4iVJmbX0faG8R4aVOY=; b=bmFMChbeXAKmL9O3h8bmg/4rBu
	So6ch1NZnvPbScRns188h7F/rGcpYLcQKPAND1O3tIhaTGfhesfRyaEMSiOck1t/7GJsgSW8By+oe
	I+6h8JlmxarQ7tRM8QL1c2VrCrvGumCicDKwneDLTqcbq1r6v3CDKHoyLopBGteCJSC60/gK3Y1Yk
	MRRGFix+j8wkBUHPxiSbKO/MbA5YC5+uJtdTB0P2eoY48gBiPsdaoS5Qu4rfUdcP7hGztuzf9N5u4
	12HyGuT1qf4DoCAjblkVAff52JDrreI7lolCOWuTuFqA/U3Nt/x3bhEUV4uHKYQsn6JOd0Y6uf9QB
	Nm0hpEWQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvjSr-00000007HXz-3kME;
	Thu, 26 Feb 2026 22:04:09 +0000
Date: Thu, 26 Feb 2026 14:04:09 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Tal Zussman <tz2294@columbia.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Yuezhang Mo <yuezhang.mo@sony.com>,
	Dave Kleikamp <shaggy@kernel.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Bob Copeland <me@bobcopeland.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
	jfs-discussion@lists.sourceforge.net, linux-nilfs@vger.kernel.org,
	ntfs3@lists.linux.dev, linux-karma-devel@lists.sourceforge.net,
	linux-mm@kvack.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH RFC v2 1/2] filemap: defer dropbehind invalidation from
 IRQ context
Message-ID: <aaDDWQ3gc4BWH2d_@infradead.org>
References: <20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu>
 <20260225-blk-dontcache-v2-1-70e7ac4f7108@columbia.edu>
 <c8078a80-f801-4f8a-b3cd-e2ccbfca1def@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c8078a80-f801-4f8a-b3cd-e2ccbfca1def@kernel.dk>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: jo9raj45thtd6cm7wpejan6pc9c65zeq
X-Rspamd-Queue-Id: 25503C0008
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1772143459-576740
X-HE-Meta: U2FsdGVkX19orhKAlNnWMxwz0RRwXVcaQrDlYCAvlIbXDEokVEEY9bVqTJCRYGA8O4aEwbw/44GoVTGMx5t3AhYXFHFFMI25K0vAxtOswUt3WTRneJLd3Cutvl5Fnd93LhKzhPXh/tMX6lQQl8WgSdbrN2GoY3OkQV4g1Hfd30eoaYCWK1Q2tpfk7aFSF83sQj8Aq9cKcWCQvi2lHZP1iDTgHr3ZMXO1ZsgUzFWHYI4B9HKzRohYl/UIFG6cDSl5FpSLeHnKui5y0/35v4gLQX/eA7lV2HY8lx+qN14VCLpsb7W6yMJZ3TRyTiEAHzlMwvYbhwibOSSZ3pm5gvtoQmbfXE7YN4g9QH5nKD+p8kQhnmuyzkDDCCyCnNfED3UHKhbBkCLb1imZpZjWS/QMtUmO2kJQ2vS8dFPpTfI5anpJH05v9rVN60kjg9zrm8MmNTldIR8fyjp+2UT0n10NQv8FaBbDv3ji8ke9u/Pcf0QXVbEU3Mvduwmv9CzLK6vJd60PgAdZN2K33RhBYqEzmJl2xR45KP6mnitoYNYJDz78iKod6y1vxpu6ABEpdl/j9MFzgTJ7zGMveZrUHAcoDigzJqpRb8JUyaMSjBHq3Y/TMT2Au4BoiLto2711vgeZ8lyQv92hJ5ncvlU9oOk5Z9mV4lZGW/2V+p7i/UyfvhxBxvzwJjtVzUET6S4SOszB+W6IeY1LTBlZJXCkitLfj7EYByufBiBQ2eYC6Mu5NXNfMETPIB1PQ6w5ODNXTuxK6krtf3vwCTzP9PLsl29R8kj9/e8EEQQhK9yWBBz8VomY+Fgpx5AMK2mvTambZaPRXeXHey1ymMNqJaSKut2R3ZQgRoripuFsUVPKb1wnltX745JkaZM/TMwAXHOezsXoIzXoCsjGO0uV9RCUJ0IibNKkEmwiVuBQTPgET/7bj/0PY9KOZtnUXtLMRCh8/pOPB2bLAo2kDhbXP0o8oPA
 iSh/Wwk8
 bK+sTpfymTQnIammCgOemYxBNhVCo7Qpi5ltCifrGQJVVCZawELO0iWnNETRW0MQgtfQL9KcxNC+4VNNw7LXK4oVI0qUSpHKZ0bOA37mVff/1eLXg6p4sTSRTW4OVLnFYJsFIHXz9k/XRj2ujwuSJZSOMeFREqGJ/5y4E5oS2GmW0eElI/U62P8Nk9T2fmM+tfGiS4FvIZFfNJbhuBg4uvnqAHFZcYFMFKQ/OqmoPWEGfrkWslnaHrsRQsim4Cghxgp7PmU/bgWIdTUNEeM4lKbIhcX2J5NFkK2iT+bytyFfaLllQFXecGRcx70YbG3NpAZYHlLzdggw8AaloBvzl5xqgVsUgATH58709fi4oTjVRwRhvzJy4TgFe3ci5b7vjUVN24UQRdTrTQLGRrLuaqIjF1oQyVcWnl1NjfeRbwCyDtT5XmIwp42L4Mi5XCao4Z/temQwDXvGuLzgpkRGSuhgeg6NRylJYjskIEqKrpIvORrJYt0SYJB9XufHjvVNmW+N+FQboOB11Eh6YIpkk6fTZNQJM5MzGixsac0TXOlmeqFgXudTSc8/roZkUvUZoUSXv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 03:52:41PM -0700, Jens Axboe wrote:
> One solution could potentially be to use per-cpu lists for this. If you
> have N threads working on separate block devices, they will tend to be
> sticky to their CPU anyway.

Having per-cpu lists would be nice, but I'd really love to have them
in iomap, as we have quite a few iomap features that would benefit
from generic offload to user context on completion.  Right now we
only have code for that in XFS, and that's because the list is anchored
in the inode.  Based on the commit message in cb357bf3d105f that's
intentional for the write completions there, but for all other
completions a generic per-cpu list would probably work fine.


