Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01E57C79FB7
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 05:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B11B6B008A; Thu, 10 Sep 2026 01:47:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 659AA6B008C; Thu, 10 Sep 2026 01:47:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548206B0092; Thu, 10 Sep 2026 01:47:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3977F6B008A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 01:47:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3A27E4040D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:47:15 +0000 (UTC)
X-FDA: 85196769630.25.D8325CE
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 587EEA0006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:47:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=rbu5P+b0;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of BATV+ff59df477875fb2864a7+8418+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+ff59df477875fb2864a7+8418+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789019233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GfLKYZUgvxL1ahMi0OUAEXLtCuptGFsPyzgJaDdoa1A=;
	b=Lho+fg/sNX63GJOPQha9j/QIT1W5p9rEfaFSPjS7AwgZ0Yv81Jqu/vm5wpNPFk1QS8w3Ln
	9BD8MP4F+9vM83hNwulsak5BYJq7E918ev/ZxpVh+qrf/PRtx4wl8UsY6xFTqDMwuIqACc
	5gmTOUVQna3X1PqpKlRICkkME7ue7XI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789019233;
	b=3RiWGLWnNkd1LQqaAwyGBCs+YQyilOe783TxLE2PDmbMbLML0FvmbxM8niPczLxJEQ50yd
	hPWYTZ02FVCHO2zYTzfpKfe+7RZskiJpodgh4cCq+tif8DUjVzIEo8n493U2j+9+HBvPmD
	qlJnaj5kG8mKBC0qlhXjMp7e+Ze2iIQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=rbu5P+b0;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of BATV+ff59df477875fb2864a7+8418+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+ff59df477875fb2864a7+8418+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GfLKYZUgvxL1ahMi0OUAEXLtCuptGFsPyzgJaDdoa1A=; b=rbu5P+b0gKhmfHoniTHQeIpdmW
	XZAOFK/cR0q1II3k5bdMPFeVTHmMiFQiwkCSIDIzrRbBb320pnjc4UEUNhDn6iG0YNZmH3mFFkJZb
	QMBgfU/sLem7PTpXB4+D9cRNZkMnNsU8P8ig0U871JDqZ5U1VSvg/KA+e+WSzsow3XKuGW12kn8m5
	M6CL8HGF6hVHZwpnyguCfd34JfXZU3312iIFDH+0/VuntKcZIVIql4h57GTFtkz9+hO6glinlxA6V
	JtdJc6X2bndHJp0eAbbrwHgHWXAxm9c14WmPLfOTNIz5qGXnVM7ALDShomySW35sO5af+V7Qa1+yw
	2piWhWJA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x4Xco-0000000DTZq-0r7E;
	Thu, 10 Sep 2026 05:47:06 +0000
Date: Wed, 9 Sep 2026 22:47:06 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org,
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
	ziy@nvidia.com, david@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	Yun Zhou <yun.zhou@windriver.com>
Subject: Re: [PATCH] xfs: fix NOFS state corruption in btree split worker
Message-ID: <aqJEWmUN3Jsajoyl@infradead.org>
References: <20260902134417.c44503a1d65533f81fb1c391@linux-foundation.org>
 <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903133756.2006032-1-wangkefeng.wang@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 587EEA0006
X-Stat-Signature: w64mrri9bcyezrozf63y6ggp1emq3wdk
X-HE-Tag: 1789019232-195808
X-HE-Meta: U2FsdGVkX193wKscICCvVYEgQ437QuzqRIqioJwujdX68UHVT7Z4pivpw8qzcha2lS65y3BHCmsVvI5tzA0yDDuqdoxZMCs/m4DS3bWPXYFbzCACdYcCAAXNZNegmf+v7MOXi6JoW82I4NczqAi5/Nb5/v/1VXZ2rwMvhte7wJchDuBCo4I/VZSI9UMpXUeKlB3wWn/pd6CIWvkFNI8ZtQTQ0vWj8ZF3/wvadf/h7tR+20EFn/seET8Yap6tQ7WebsCXWwXidxgwDIgXiMHv/ArGSGTMMB+nAVJRFIRSTQKJLHBOQ8WvH7lVHR2VAPlQ+pqaAwD8YT/Q+OXLglXGRfV9U7BACCHedX55cvVvKrwiyAgL5WMlLjD41JV211xTY9DLUDfi3c2Ji84gMYJ6P5c02pMJwbuX0uhOGuOUfBY5OfoYDhn00cuGR9fNYUOXab4v4psc2GxTjJU7x8l9Ti0Q3cycup9uqSOciglhQ9XvwqUZpJINyJNkyzU4z7Teg+gKMd/oVjbCIU3PQf4xQyNKoP8Qr2D2vUwCmBMuDIkkhoRdKvzELO9g9pL7O+VMTi4cBbyFxK44Pa0UhxGJWNrM6BKkOhILwL5gdn5nCOySNMuTCVmiNdG4Ols2VniE4i72pjlXsQA/upvY+LJRIuJRyCuzptbp7nbJ60rQDOj0JDtaV/sH9+YB8ctuMI/h1I7xr5X+EvwsiUcdpNc9jy85buqBSFRSd0heEiAGsZYicCd/HO091rglb1aDk9FRMYZXVhis25PT+/pTdpNRoUBR80gnTvegIX9zAAdjS2dMquUDLOS1vYGX/B/Tz/xrDu1pu7L7wGYotgTXcsNAaaIxjM6sAbD7twaYhQnC7IKWdWQOmDBc8aDlthDeNvhcRe3zIq0bt74BhcAmn+XNi+sekXoP04jxmluKHmo8HVBtKxI672sOMDdPic40PguySqS649nNKolM953pIT6
 A8Y6r0yh
 zrfEepQ/QA59Phr9WqTPX25pMsKUWDbbkYjaKnqGV4tUTeImR0ihLx7OnVabmLPBbERzJUKDCC91fpDq67HUVMpwbzHAqtNkmmoEHJknpOcmnOV2ZiGApPhLp5Uh7cvmB8yhJvXU7WLH3VnDpKBacmvytAt3y24Trd7+PggYQYU52jhjJt5I2zunR3vNgnw0QOM4Tzd6VjcP9wXUnc53mIZlz5KxyrrNnT05TsO1dfCNGg4rj0kGNbcsF7PZDLa5bZ1JY5H0YNFtl2lufipeOpx4wwJLpOqmwyrRv/x8OssmYOckRAfAZDnEr0BR8XI0MYWcuOA5gXzd+qd44U/13GNdFxZ5gE2neUzwocDU0hcyroDjG2EnGdZZSeBEJcWY1b6pPfguaFUmWD8FEavgZ85ZfuWFem6rkdDjPgFJMfhofxHVL3wVwT9CiwbxS6QX7oRBiTKF1/8zcRh2ipcCWXNdC0MuprHfNdGhuv7V9gXGZ0Kl/yP5ffkeJWbwturQiDoXQJQDzzMjcLNs1wGoj8sDATK6n03ryPubapHbbb/9uQn5gcSqQr4BGMg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding Yun Zhou, whoch touched this area recently.

On Thu, Sep 03, 2026 at 09:37:56PM +0800, Kefeng Wang wrote:
> xfs_btree_split_worker() calls xfs_trans_set_context() and
> xfs_trans_clear_context() on the caller's transaction, overwriting
> tp->t_pflags with the worker's NOFS state. When the caller already has
> PF_MEMALLOC_NOFS set (e.g. xfs_end_ioend_write, xfs_dio_write_end_io),
> the corrupted tp->t_pflags causes xfs_trans_free() to erroneously clear
> the caller's NOFS protection.
> 
> Use memalloc_nofs_save/restore with a local variable instead so
> tp->t_pflags is never touched.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Btw, if you have some spare time, it would be nice to kill
xfs_trans_set_context/xfs_trans_clear_context as follow up given that
they keep causing confusion.


