Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35A6CCD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 975B96B0005; Mon, 18 May 2026 02:49:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 926346B0093; Mon, 18 May 2026 02:49:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8637E6B0095; Mon, 18 May 2026 02:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 73B0B6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:49:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3E8381C06E6
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:49:14 +0000 (UTC)
X-FDA: 84779613828.05.E7F8EDE
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8BB76A0002
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:49:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="DdvWKG/C";
	spf=none (imf25.hostedemail.com: domain of BATV+a5a5d3dd39d7e5270008+8303+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a5a5d3dd39d7e5270008+8303+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779086952;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=dFDGZzmfCO7gmrq3FLU0UOFJv+YkDiHnM7U5RhXcLvG5el+t2QAq+Ti4DhpzUYYeYHkkiZ
	gapMPUZxyJRO0dQkgUuRyAUCobVDTRAfL162v7KrIkExclhZUI4SPN6vOuXeeOOCz5tuk2
	aEOrQuBbi+asayu1fKbQt1C+67WyNfw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="DdvWKG/C";
	spf=none (imf25.hostedemail.com: domain of BATV+a5a5d3dd39d7e5270008+8303+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a5a5d3dd39d7e5270008+8303+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779086952; a=rsa-sha256;
	cv=none;
	b=pKq4amgS0HF3bF3M/U/LOJRPuhgxnLa0EBj8v0okdxA7ecvqY9UUKHS9HXUpDgxbXeZ+9o
	s6VzvC0BwGSsuJKi4n53hKiw0bXeBjMLVDVaHuPuGdxox/6yDaIwMAZzJznQ0nDp+Yw3s3
	q4yk10kgEJ0ntTTCAX5BopE32g2H88o=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=DdvWKG/CatSmbba1jyTEAK5yzY
	FymDJQmmWv7yROwQ7FrGSdJisZ+UryNak3HrG7tUtSQWR+5ckH893uLELNtDfZh52dlArszSGwjdC
	bN7QuJd/kS/mNGRdP4vi75nEUucPZ3Tq791ex3rnSAah+XAM4xJFvc7nlE5AuRtzcSeEwMYxh0NSh
	yaMkl1LyEzj/GFn3ateGMtLcFDhBaUaM47sNaARN/sJCQcWUkk8Hl/TzGWXf/h0zp3yfvQsBRPLp6
	LlPbtR8Q+yFzoe4cZ5/BUVcG+gvL15RMPc4zugHo/j12VnbpX/jXCeNKQmKvidgdad30cDlz2pFr5
	TBlUugPg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOrmn-0000000ETfw-00v3;
	Mon, 18 May 2026 06:49:09 +0000
Date: Sun, 17 May 2026 23:49:08 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Carlos Maiolino <cem@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
	Christoph Hellwig <hch@infradead.org>,
	Dave Chinner <dgc@kernel.org>, Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, Gao Xiang <xiang@kernel.org>
Subject: Re: [PATCH v6 3/4] buffer: add dropbehind writeback support
Message-ID: <agq2ZAf7MUL3ap7N@infradead.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-3-782e2fa7477b@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514-blk-dontcache-v6-3-782e2fa7477b@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 8BB76A0002
X-Rspamd-Server: rspam06
X-Stat-Signature: jc1zezoidzsi57jbjrijijs11wb3jgnj
X-HE-Tag: 1779086952-623494
X-HE-Meta: U2FsdGVkX18MKAu0zHKC1WOnEQtO9UUwdP6eGObTdOH66sAXBMoLfj0CS0Rg0CEQm/aX7JfmukQ/thWhZdSxBSlQlI3q5l2wgr80/P2gez8bK2ycx+s9LrNl5l1h+Ey9E/qQNNv8YuI/wv1BhMfFfKs7e+BnkymMKADUreP3cN4bzWPmVYOqamQEWb4SsRaMuRNdkTVk/H7CErvtf9mQ9LqHCcgpb8PyCJNYVK+YOeoK5Gipsu/hCWh3Xn9uGU0W2Cw1IUYOgbSrQV4OY6OLZ0TlI6EBIhtkUXtsJAYPyybVbBuXejBn6zWoePoCkMD7eK9snqPmxC61Yt3uN9hLSRyRwE6Uk1BtxI91g5oCP4Sx/t6BAwJ/4ypeqHdnQGq76OIEC5rcg683m6ePGsd2G0zdaAVy2PoRGHA4f8uRkraAN+l1d2g7xOJd7M8o6mfqB4jnhhd/PWtzaqz6/EC8OPgYcRItli5BXS/BS350vcBuNnHXEnzpVMf9tfCmVTTEo8jACbzv1p1t/5qAg6CsCoICUqAWGDTTRzm4xidt5GAPXtMGLV6vqWLqotImvhFOi1wBpOh2rVePZKF1re0Th0CC6d9nrBuhqr9/9UZMLp9jakxSM/fnmk7cN9kw9hqILaxm7BRXNH/yRfbY9jIDd+jdU0feWfHqdyShDKNitFbKg3dAS5iOhSNNkEPd8zPTDlM8IwS70zJcZPRzv6nmQOYVmx5bTHICHuvt2mBJdrvlvo1wU40+7JQhQdbd+xIPDUmS77naMuNgXIqQAvWbHNNJtrTQbEY7goDcqFwkzNHz4PMyJq/+JC49Kq8PZNI3Q+cFs+UieiCWvTtqleSnAB5D/7Aaf4qG2Dky4tZjifh9iII01aUeeuU71GlMbWLJw96Hy79BddD2f4Czb0qrbDGxWKTVj1tIB8GEBrVpIRad3fpqwJ3Pnur7NJbJ0lg8ICAfmXNA3JCjEqZ/H80
 iwJTHQky
 2HbKQMOYFB+3LMIhZJu3kkS1sKv8QoQJFnxBMh+vFVsrR80cPwsI2EGHa+y3H75TPrVGMotv5b3O+AKH+AANBUn7cmRtB4us+a3lq7VLQZZFCQXUKDpZZiDlLA1CdjNbsjxC539hqCPqKP5JAxXRXECfOmfXceatyKVyQJw3REgz9ztBvIZ8s7HVPPE+77j2mlOhuNFjfthi647eFlU/VTD/rdHJpPQoTYO6URC8FyRDaRO7PddsawKW0mB9Sl+O5hFI+iYflskqcstT7VvOJG1wdPABshHP9JrbP2rgz8xuAQy5ApYKLJHYtr8KOORpnyBLZwqC0gTJa2jMlR+WiK85sJApUh3ovTI9febb8L44uBmSz/F4JuO/QGQE17hBFreF386YkeDKT3USogTq2VUdT3sZ7e3RAPsukGJCbPh4KLbRVgsHSJSfBt6hISrTzbrPXMI6JtER+CZOFCYBqFRtNwfWCCWZuznMhT/+LQrCxEuz9eU7hjBuKdmw26ic0JCVCeSMHdchZIJM0xGUuaTX4A94Gwh97LrLPRmY4h8LR/6IFsGAsfuSUIdqlG1fvBqYVWAP3s9sC9X1eKhyS5A/x5PI0U7I6TFTj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


