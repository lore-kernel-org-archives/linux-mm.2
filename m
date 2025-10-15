Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B53FCCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 07:31:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A82CC8E0009; Wed, 15 Oct 2025 03:31:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A593F8E0002; Wed, 15 Oct 2025 03:31:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 997338E0009; Wed, 15 Oct 2025 03:31:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 88C8B8E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:31:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 603B711B30A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:31:57 +0000 (UTC)
X-FDA: 83999529474.15.72BA0B2
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf12.hostedemail.com (Postfix) with ESMTP id 97E6340010
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:31:55 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760513515; a=rsa-sha256;
	cv=none;
	b=URTtWgNam7HWlb8RTMp/Pq5+oukNg3S+O2p3LxuUZcAj8D4BJozWbM3A43uVxsplzoqXN/
	APOaitjVQNpBfhSReQaivE7SF5HrweiOyZLshx8WmuX+cgTsfV4J0Ocn1AU3HG/rm8i76K
	jrSUeGn8pIu5NyE3PIqdRr3zucRpPcc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760513515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9Ye/2Sg9yKFeISLBWd8NKQZoDy/029G1tfPVlfBjgMo=;
	b=LVs0HmxwKEGA79OKdTfZHs/MvjoWVW8XYYuM0WonfllZrczTxLUqVdJQqWpiwvYyxa8Glj
	ETGQ32QVytFTqybKFyPg3OIMjg2OoYL5Su1NUX+bdFwCcl1/Wh92hXxWdQqOQtmdekP3dk
	J5i2ofAAUPxHiL0Me3HsXBid1JpzT3E=
Received: by verein.lst.de (Postfix, from userid 2407)
	id E48B7227AA8; Wed, 15 Oct 2025 09:31:51 +0200 (CEST)
Date: Wed, 15 Oct 2025 09:31:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kundan Kumar <kundan.kumar@samsung.com>
Cc: jaegeuk@kernel.org, chao@kernel.org, viro@zeniv.linux.org.uk,
	brauner@kernel.org, jack@suse.cz, miklos@szeredi.hu,
	agruenba@redhat.com, trondmy@kernel.org, anna@kernel.org,
	akpm@linux-foundation.org, willy@infradead.org, mcgrof@kernel.org,
	clm@meta.com, david@fromorbit.com, amir73il@gmail.com,
	axboe@kernel.dk, hch@lst.de, ritesh.list@gmail.com,
	djwong@kernel.org, dave@stgolabs.net, wangyufei@vivo.com,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, gfs2@lists.linux.dev,
	linux-nfs@vger.kernel.org, linux-mm@kvack.org, gost.dev@samsung.com,
	anuj20.g@samsung.com, vishak.g@samsung.com, joshi.k@samsung.com
Subject: Re: [PATCH v2 00/16] Parallelizing filesystem writeback
Message-ID: <20251015073151.GC11294@lst.de>
References: <CGME20251014120958epcas5p267c3c9f9dbe6ffc53c25755327de89f9@epcas5p2.samsung.com> <20251014120845.2361-1-kundan.kumar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251014120845.2361-1-kundan.kumar@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: ddkbmsdc5x3gggharpgsmy7dyfmrczx5
X-Rspamd-Queue-Id: 97E6340010
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760513515-138303
X-HE-Meta: U2FsdGVkX19O+HWX7odqv41WcXG5Q27CrOC3ji81kbX/SSYNdVr1108iTUErMY5anTCunaOu6mxab8JfslN1f+bKpxiUbQzd+fEoeJ5Jme8HVAVkbCm4jzq+0/VyH/R5fFo2hmyc3n5bRsWVp8cALKt6BPC7gTw3ZsJU4iprwb7S/zaki5cK7i/M80Jz+vjh2Qcp/fYGgnAd9/1P1Mm2r+RV7FhpALwt5K2RUJPYwPNfFXoIUo3p4vvN79KIyi4owDOtNXTRIPFwQgv69ZkjHS13UBQ3qCr2Ns6p+BY7EKMPZNC+W/WZYR0U0sURK7YmFBE9kg8wrMl9ZIh/6l9aZ0wwtTsfCLSe7ZRNXvTPZm4Z/9z3UV3nza1YrPJDB6GzfJCJE8x/Nkkvbujtok1vlWaraPOjuvmkK3uJErH2Wz92pnWdxTAu4+2qLEwVnLMnLRGBYzM8HF5XiehpVeYbBcx0gzGCKMWpAvIKED5bOLCssZsh8mLFfQW9afSrB5AHBJJOqO624EgO4dcn1GU3tF74zrR8FUFy+u3od9Z7x0otoq/IEMkCZVQvXkQ/wVeMKYM1VvdddzeZUg6vwBIWLCfpM9lCeSq+GzakiNCQh8oTwQwQTzc92tXcypvzPWQ6MYPPSvwA7o0Y6w/WOZ7tTZ52jNPaKyfGS/uTPls1SiAniPgVqmnZ04Xu63X8e/tYyLubCKWYpnfSf2RaGELHWJUH6eozUREIXsCUmiMVLyVnYmXsUK6sJnqRv619vljNyLiZZcYlezaxQ40W6BJkqspmPCMIgra15q1uUhqkrbhfi845wC58kSSK6mwm/nkCbAJBt6lXMwy97jhU1ZY9SxBsC/weiAw7QoaoroeaZ8h559vR13wVK4EJ3M5K1TXI3TM+G5AV1CBRaRJOI8wzjo7ObXxcKjGtjJzkGAUxDJUkiIBO8T//moX7pxzuVe1n0vgVx3zOOggHC9qTnyN
 y4PfLhjM
 fril1AjKfqtgXq1VNUXdcRa1VNCOnX/qxhefO+34ijgTFSUHRFtl/mBgejhpKirxXgEBT15mmLyhyKmwUFsVp1gojgSkboWbbXHvwhpPZI+hUUAlfOrGbJVwDxOcaXjka71an9ecAQS7zNkkFg2X0spsy5UcLHScq4lTLi1xXrPXZ90w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This still allows the file system to override a bdi paramter while
the bdi is shared by all file systems on a single block device.  As
said before that really needs untangling first.


