Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B07DC87FCA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 15:29:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFE2C6B007B; Thu, 31 Jul 2025 11:29:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD5816B0088; Thu, 31 Jul 2025 11:29:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEB5A6B0089; Thu, 31 Jul 2025 11:29:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A14EE6B007B
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 11:29:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 71210134AC4
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:29:55 +0000 (UTC)
X-FDA: 83724945150.29.F2E31B0
Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	by imf27.hostedemail.com (Postfix) with ESMTP id 826894000F
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 15:29:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=2fEYzxjp;
	spf=pass (imf27.hostedemail.com: domain of bvanassche@acm.org designates 199.89.3.7 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753975793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xQRIHmeEidmmr3xvfnQM6kAnc4SlI1EPCVjCZw3NRPg=;
	b=OY5DmgH5LYriQJEyYMdeZ4HJA1OTUipHMtC4bt6EVv9yZzlpGrf7MYIGYLgCC3G7RkWnfg
	UEP7sdjj8AWmQg0ia61dVm9L++IDUGrQ7xhF88I16RDQhmeiqQQsuTYapZ00k8g94LbJw9
	t5lF1ispNK5HAcZcAiWl6qhnKvSEBy0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753975793; a=rsa-sha256;
	cv=none;
	b=fepCVU93va+isFm7lVcC4blBMrcpZwSvVg9BMtioMwcgiee+PBp/OuOfA6WaErpABSUdCv
	6bLOnyiS63pxLcRCu4arSUHbkIzFropGf3jzLus0PPTWuHha0o7LQo99oHktcFu+Avbd41
	pwf7Co4L0B4qDQ3fpk18k7tI4IDneSk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=acm.org header.s=mr01 header.b=2fEYzxjp;
	spf=pass (imf27.hostedemail.com: domain of bvanassche@acm.org designates 199.89.3.7 as permitted sender) smtp.mailfrom=bvanassche@acm.org;
	dmarc=pass (policy=reject) header.from=acm.org
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4btCgh5xSyzm1Hcb;
	Thu, 31 Jul 2025 15:29:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1753975790; x=1756567791; bh=xQRIHmeEidmmr3xvfnQM6kAn
	c4SlI1EPCVjCZw3NRPg=; b=2fEYzxjplvAfmVkNIGvySQhxqD9Q4wqkibkVgKpd
	3/mrX86Mpu5Ll/B3Qxj5DogrJvQNCbkL2BzPhiQk3zjbVMHQzeQ0dJg9Yl0im9Tm
	C/JYlgLsrzXGqwIS3qX3IyT2dthejrn9+NY1D3BNLab180I2Lzf5VPnmBEG3Mu52
	DAFYRDyhgxFHXJrf1iD9Oo++cB58XF9UEzeWlfVBs9qrYFQegP+u9xHST+IVcW7y
	eYpVsj4tkw7cwtE0GPsUhYzSYjewZcFk7zDlHRPg4hW6xfraaUdRXeZVpmake1Mu
	0iJwE8za1XWoqB/A8tigvRoVY1eaCNKMysnUQb4DOif9xg==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 1mtbCr0qwDCR; Thu, 31 Jul 2025 15:29:50 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4btCgX3p62zm1Hcj;
	Thu, 31 Jul 2025 15:29:43 +0000 (UTC)
Message-ID: <4b24afa0-7e3c-411e-ae29-9ba58ed86386@acm.org>
Date: Thu, 31 Jul 2025 08:29:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/3] zram: enable asynchronous writeback
To: Richard Chang <richardycc@google.com>, Minchan Kim <minchan@kernel.org>,
 Sergey Senozhatsky <senozhatsky@chromium.org>, Jens Axboe <axboe@kernel.dk>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: bgeffon@google.com, liumartin@google.com, linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org, linux-mm@kvack.org
References: <20250731064949.1690732-1-richardycc@google.com>
 <20250731064949.1690732-4-richardycc@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250731064949.1690732-4-richardycc@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 826894000F
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 4ihdj6uemxpd1d1b4ijbbryfpsbfxdhc
X-HE-Tag: 1753975793-472694
X-HE-Meta: U2FsdGVkX19xvf5DeCb45Mit5y8A5QJwN33zx/hv0d0tf4TepdXr/enxFStNA4BxYH0w3GQM4syldiFC9fK9pxsBW7fvyxV+7Ia7VnRziGB0OhItfANadqFoRb/pHfMUGKTFPyt1e34X6shTxVY5BQhZD+JMiYpEQjS4s2H/HxX8t5YQcyRh5XUQywXY/qJna96cbsU9QF8ZVRdvJn8CEDOaYQaoCJeMVfc1G5+gpz8xH0DRWfWMXmUPek5yvP2G5oTf5xz7FHqDrneKFeEXOzqltPIFDWkA0y489xmgpxodr9CX2Ac8ZCe4YHq96ocODKUcTyIMXB7oCJBlVFq+4CAZNs2k7jeUGU9RE4oxTAOcLxhTcSBsHj6bmxK6apzsEuyJRn2qvcXp/w+eTmERrMeUYl7YAFMdCrQfzOlLnq8kzC1k/IsiCUIgT0B6L+ZBDOCQC8oVxKRva+1CgjgGL1O97tRnwnAMCB+m9oxwabK9ul5DGAVWSvGtXrJIFr2Omvn4CaTeQtgLcC95nYkAgWM3CyEXycXKG8mC2I4WWNQajaCCRZjNhf8g2NCGhh22mNC/CLCNQaKGwxQ9RhX1QmX14qUBvdBCI479WSsrKselJJCLgtJkr3/ZKY7FQ57d4yAP05kkMLJq9NKoX7Zj8jpQRh+fUmXhjyu7jE47Fj5FUVzW6ejwef1b6fz3DYkSi2lBo45VW21pLG3dJSQirnkBOFICN13LS/kInezkuGsgiUWcNgJ1obRnPpf/Cp0/OSz8OqEeM6TBSppqQ+1BrFNcGNtyyb8mAZV5EUSWDCLCxyMQIkiLpb/InDQDwPg2N9gyB+wQyrzePZT4Bpr7Fzs4xSHKM6vQJPuI3XYTP8SU98UndLMO8vfms784M6LxKU6nVK7WuJ0NcbrjWc6gCKDppTnxsdMxJggtor+SxV+qJm0o0KVR2LL16rxKupsPE253lpf+C3IVZlplFfX
 cNZE6CC5
 M++5k70qmWXzSuMnO5Z3wg5WStT0ShaUwbylfxAyrmq5AurHdqq50fnjZ1z2yNpLA+Un3Xr5rVxRkMsGoXD5/x3t2mKr/g5B/ZDd85lWXkYWQLI+DdonXruWxt5IQg5rxCn1L5RvP7kjhoBq7HpEGAU2ta0ZbUfJei1wvORIFQlB1q575kks6j0urw0qzT0k3h8RVX/nL0cg2DwAzhLo85D7rctWW6pN7AY7Eqi/y8bJCl+d4Y+YtUfFhYQfr/IO+51V6Cqcz3CiaqJdZMqABAjd7js7MosFj91mx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/25 11:49 PM, Richard Chang wrote:
> +	bio = bio_alloc(zram->bdev, 1, REQ_OP_WRITE, GFP_NOIO | __GFP_NOWARN);
> +	if (!bio) {
> +		err = -ENOMEM;
> +		goto out_free_page;
> +	}
> +
> +	req = kmalloc(sizeof(struct zram_wb_request), GFP_NOIO | __GFP_NOWARN);
> +	if (!req) {
> +		err = -ENOMEM;
> +		goto out_free_bio;
> +	}

Why are 'req' and 'bio' allocated separately instead of creating a
bio_set with front padding? See also bioset_init().

Thanks,

Bart.

