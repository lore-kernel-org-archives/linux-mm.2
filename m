Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8461ACD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 07:24:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1C016B008C; Wed, 27 May 2026 03:24:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA5966B0092; Wed, 27 May 2026 03:24:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBC0A6B0093; Wed, 27 May 2026 03:24:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB7BE6B008C
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:24:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 49339140471
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:24:37 +0000 (UTC)
X-FDA: 84812362194.21.3AD08BC
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf03.hostedemail.com (Postfix) with ESMTP id 921372000D
	for <linux-mm@kvack.org>; Wed, 27 May 2026 07:24:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779866675; a=rsa-sha256;
	cv=none;
	b=lmhC1+/b1nDTC39oJiPMD1QJP790zlYgRaapGcwnY985+FZiFk4Xlxp7PWir0ofMnWdWLy
	KPN0G970zKmrpcvcivN5wgofHXryug4wbNyEgEG28XAknFZ3dmRbQKWd6f/MzUTMQ18aTt
	ql15dU/bzYwvAp+qfUAooxWJATM6sN8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de;
	dmarc=pass (policy=none) header.from=lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779866675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	b=bt4gGylBxP3HXTbgvm8Y9kGjO66u12G0JOuteNWCbzL80ufEgjsQCgc2MqvfV4cKj86bhP
	WiJKTsXUp7fJaZVIbtNFSd5DLKL+CMzawquAvWy63uZ5nTrQN7K2IxqNN2ogn9ybo/KKxB
	8y/loSV9QizeLu0uRgB/mAv7qbZDH7k=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 475AF68BEB; Wed, 27 May 2026 09:24:33 +0200 (CEST)
Date: Wed, 27 May 2026 09:24:33 +0200
From: Christoph Hellwig <hch@lst.de>
To: Cunlong Li <shenxiaogll@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] zram: drop unused bio parameter from write
 helpers
Message-ID: <20260527072433.GB17856@lst.de>
References: <20260527-zram-v2-0-2fb84b054b5c@gmail.com> <20260527-zram-v2-2-2fb84b054b5c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527-zram-v2-2-2fb84b054b5c@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Queue-Id: 921372000D
X-Rspamd-Server: rspam03
X-Stat-Signature: 6shmb9c16e4h3g6p43tdy4ojba36mwh9
X-HE-Tag: 1779866675-940255
X-HE-Meta: U2FsdGVkX1+5daMNtfopoBt1VuN9tG2lxfcU4ozLVUQH5aygDcgQ1tlxASMYp5cSj2pc4JreTheWPeaLSek5raAq+OMeUo5zD8WLgy5iK+SZIS3JatoPM3u5tZyfjssOzHyEQGX7rZMU2dbweYZdeZqFqUtEph8JP6LQEouEqB0eTi/Qaj3GAYoLJm6In9AsAyHHWN2itzH80/gQMOJYgS3UdNLxZ+yHxdJIboy0YAd6isNGjeF96rFwi1HCTuc07XXW8aHGlrZcd2d+5I2T2+B3qRapmGBjV7n6Yq/ycwkawwOvkJs3cje3LcKRk3ZTP7rK3IBq5M9ixbYsRSZf4O2hqc2+8gjmQFT6T+z91BPlQ2QInBbaYtQwyb7pvn9m+Mt0CcrB3YHgNC1Nx/7NfCDLC9iHw76A9gPhnGRTVU7mvHqlb4rLzNUPqQm987NBYR1VWvc3r1U60/UaCPRSvYjssV2/4dW3zjajSqO8vYTJwiQCQTvny920uXmoGW6OR0HlN9pxNUfrS+V5TSL6AlWQ1eI5xZWSf7tZa0m9ia2i/3IS1YxUTrXz4gPyVmaGinYjP5LKwx89Uy6L5bgf1obvFd8IhaRHfPIINTf08l4YmLQPrYg3cx8P6nS9f+meJvlj4CmGuoDDzzcY7MPTGLIKoXvUddYgfK6dDo2wADqaCivpc6qcu2LcQCGxB0rIPKONM55Yh5BtsP8/qlWiePeqyQ4uyTgiQyt5rQHpJ8h1mA/sC0DspFAjST0fKr8X5RbkHNc4loCZjIUSVOrc7py3ebGeot2aa5X6b9K4LSCyjo6atE/1nmRnY1HnzSus5OKFN64wY4v1o7Bg1bjaRXbfWDw1wQfrpRmAtXeTnLylui5BaY/vBrkl77lkqz4wCD4KU1LisP68OYPA/0Jg4o5NZfArFCotPx7ZGqHdQn2+rqL8vQoBm1qKn9KaPsEypadSDH23mXtsVL9cnFJ
 6rW4d7IF
 tpcq4PsFtrL2w8O+3/h4CIIBcTfUewXh7iKPXietb/f8cK72jyZuB0js4zpN0iYu14HbnU+st1loRyoHs454Bhv94914pE5js03msqMzGHEZbav7GY9sPLBoS8fKBJSE24OWp13QaWy2PiwDPXIr+0gHE0t87E5NeyUMKICwfTFnLdXNIlZWx9nQfnD6ZJgMB2Y0z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>


