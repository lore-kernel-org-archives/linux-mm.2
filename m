Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87409CD4F3C
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 06:48:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ECC236B0088; Mon, 18 May 2026 02:48:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA3476B008C; Mon, 18 May 2026 02:48:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE10B6B0092; Mon, 18 May 2026 02:48:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CEDCD6B0088
	for <linux-mm@kvack.org>; Mon, 18 May 2026 02:48:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 83BCE1207C8
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:48:38 +0000 (UTC)
X-FDA: 84779612316.14.CBB1677
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id E5223180009
	for <linux-mm@kvack.org>; Mon, 18 May 2026 06:48:36 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Cpo1+QCS;
	spf=none (imf24.hostedemail.com: domain of BATV+a5a5d3dd39d7e5270008+8303+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a5a5d3dd39d7e5270008+8303+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779086917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=djVav9qp8qWv2nDb1e5cTDy7CeWTYgYPpPFyKLjEQcMWSZ9015nEvgyFi6ZEFOQupO4FSB
	MKFRaYv7W28mV2Yz0O3iYHMNjlQjFfD5VR5ENdPn6+kciGtbTwtxqdZR1KJkew0ZrSmAPG
	IyZOOQjsO4yjT+tF+UsuwLZK2txPEk8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=Cpo1+QCS;
	spf=none (imf24.hostedemail.com: domain of BATV+a5a5d3dd39d7e5270008+8303+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+a5a5d3dd39d7e5270008+8303+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779086917; a=rsa-sha256;
	cv=none;
	b=n7uhCZFoJCEDZtzIU25LkKt9WOBYLSs0mgkvjs49XZcXLjKwjNDS0YadL5AHlLb9qrReVe
	g4ZAMFme6FyytRHP5pEqRJynflmQs6jPdRrgOUVbZkuRFelD1drmvHixGsBWop0xyP9A3o
	gEpLQweuKeTm2BdM5CIvYy3JAsVBE4I=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Cpo1+QCSLlBOD2DUlxCYFMB4oH
	puN1Nl3rQ+d9UzEW7pqcnPF2vNcXAsAH9V5QdgrQQqjvJKfXS8xTMXjptXvMzjN+8zHEl2WiFlwLC
	LNt9Un1Wk7ewKcxIKAhSw4t+yTQ8wL4IcQW/wQAfEyPW3SIZYoJQToBqVqo09eI76Xs6vbRgpvgnD
	Rrzk/g2QRVQSkTELX6T9CVv126Ibkpv1Iz8Uur9MvefZNbLVRtCGdSyYs4DAsWWC8owKaSg4p7Woy
	7y1FBQ1SAfbV5RwuuyC5Z/Ieaw48tXMPzfPtrS5pfdx4LVUSerOStZM/ECnh4WCVbKiR3DGkrwxza
	NzAHOSPA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wOrmE-0000000ETWz-1PDs;
	Mon, 18 May 2026 06:48:34 +0000
Date: Sun, 17 May 2026 23:48:34 -0700
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
Subject: Re: [PATCH v6 2/4] iomap: use BIO_COMPLETE_IN_TASK for dropbehind
 writeback
Message-ID: <agq2QoZWSY4LTtY7@infradead.org>
References: <20260514-blk-dontcache-v6-0-782e2fa7477b@columbia.edu>
 <20260514-blk-dontcache-v6-2-782e2fa7477b@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260514-blk-dontcache-v6-2-782e2fa7477b@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: E5223180009
X-Rspamd-Server: rspam06
X-Stat-Signature: tcf8fjmgyxiym3ucifh4ityahe384jsb
X-HE-Tag: 1779086916-2631
X-HE-Meta: U2FsdGVkX1+COoAhPzb46XaP7absjyYVURo/0T7l+HIF4X5QJ9wOH1URH3JxbI78ilD2kJiZxD+Bx9WE3qETfz9Mxm6zDX0qCrEO+cBr2aBQPA6ZiGuLV2NjbRWdmdFJo+gfOuBB9I+i/dYCoVHeqpRENKfVAkfnCgTaicBC64tzphFqYOZbsfNxAk82fho1QynHpYxa/QSoeYoyBFsVLdKJw+5kAljoRQzCU6wmFaSWjX+LIbnlpp6yb/VcbsCTFdWuLRPgA7Loai5QNeHULahRNrUPMhgrzKQVFnik/P9Xd7kpEyrxQlDVmlVPp5LalgY22ZzyNF6N01buBw/9jFH/xRsxinHyBNyddr95TRz3Tt6w8ssX/rePi/buBaur1DCRHLTEkxsbNyghfz73hGFDnphK6s1IpzeA3zDgJ48/zSrcZmgb/pwbDHWRtXKEuCyCnVDRK+du935TW1VHwo1jZz1KQyeyRHqAf3zBE4XEPEdxgOTXEwBKLf+zGaVN/qiVUJT384J8/l7D87BOQ5cZHK2Tp0Ta3XUy75KdIEneDsxribImEawP6f978QyQ1zNYOTRsF9/39tCbtDr3IxY+7/HyHZ91/C6Drab02OgGqQpVcpA+ZOFQTM6vCaU1I2HnprDbc8xvYb69M/VhoPt/IA3hZ4ESjvIGy6ZKMzGtTwjoXyQ5fR2c1oGR077NmxXwwfPGFRSMr6i2rIOm+m9hjVkY7N/6VOO8ZZJWEnnGatmZSaBMugQcK68H85eEzBqdnyEzug9XdmC7ugHuwggIvfiO30sckneyVSDvyCPMJKj4Lm/wWKlHnlk/0PLg4wQa68trjA7rF273M+cxWljEHsiPAwKpBSCioheT1c8OPCQTLO8zOlYjEGuRVdA2F5BuPZM5X1P2En4boaBihg9jhQrYwWLKe93aIVq8vZtcDN8IUwX6MfwoAxAXiV7PJoyx4NzOt40i9FIqbLR
 a6/gcqvw
 rZ6WEFW9cqkBQTOkn1yOpdG+brxdd8vDShsr16WzqDGOn66i8yBg3P4tFnI4wsOZ3jWIZc/fbe9vOYzppKwanxsgOreoilv5q7f0rJKAJClu+OT2azGU81e1A2Jp77cU8tHFKSEzYAzAUhsPn1aG1q6B6lxMFCwF6qnQRKGR5zsc8/9gSjTdtxTLCTRlg2TnsYIRSCSFfZnlgvUxzLKNMSmeIZyXtAEHihX3qhFTFrut/yJWVdgGB5+XGam1U3+h0nSNA1NSlyJuhHmT3JaQM7Ey3MFvmmDEGAH3EFZV+PHZUPTdqswNMzc9VPzxid50VHqgPqHoXauconpL73cw4Ksy9Uw89zDhBaKrGPsg/bsGT0T4Uls2EfOQGGrmInz0xpBTSkeeYRld0gBvERDna9rbp9k+ki0k2Bb5riMTSU7EKFivQ9V6z8HN46gN6SqM7hRLXkhB9gePzDnOJJLpzQGEGIOTlqxrI1xmZHXhGWazWyKIvvpfD7721isxfCbmAloNSIt/I/qdIxDEon5pWDI/boMkI+xK5CEEtV1HVgT/LIfShLnHXmOSXOecZ8qh9tsiN/rT6CzWo/pE7ke/xlhrbpflYXVkCPcYtk7jlAatK80Ae1la0YE2Hgn4R+kEfGH5ldFIPKduzceaIGVGeQhxdcQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

