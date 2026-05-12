Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F02ACD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 451D86B0088; Tue, 12 May 2026 03:41:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402A56B008C; Tue, 12 May 2026 03:41:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318636B0093; Tue, 12 May 2026 03:41:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 240B76B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:41:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B65758C919
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:41:16 +0000 (UTC)
X-FDA: 84757972152.06.33B3845
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 096832000E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:41:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="O9sk2Vp/";
	spf=pass (imf03.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778571675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UywdvZwZh2rj7+kkQt0ERW4ZHo2QGonfqFX8tXYpecg=;
	b=KCo2YCKacJn8wjPsDq+n271T7A7fLTOEkKwLhhjHj0KCC1vbtZTxxI837YMdM6McEkHBt9
	LCcdWFP9Vy0jD2yORoODDWxNQBO3xlIx0aaJYQm8YlR+rLR5tW5LbBQXywryFos+H0qMgv
	uJk6fCur3jEGHPkzspyZ8g3cDpP3mvI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="O9sk2Vp/";
	spf=pass (imf03.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778571675; a=rsa-sha256;
	cv=none;
	b=7UJCNM0eBTf3W+3Fw1lhHTld5v8Pf9GXJ0ze6OtMK9QFJPtM4upi6QUdN7qCrpYq2MJFTs
	RdODH2M0rJrhSXXd6GHIJJXanwClNlzuBumJoTzMnKEYv3iJy4ZCfpzQMdjC9jyvzRcTmi
	GfxLEAlG0SFyD03losuQBagpemhioDg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 64043600CB;
	Tue, 12 May 2026 07:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9C56C2BCB0;
	Tue, 12 May 2026 07:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778571674;
	bh=uHgramlR2UsacSFL8Nsu5N5X+GjYLWlhcrhT4BezNyc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O9sk2Vp/6GejyLBdgb0tqXl6XI8Ee217W/WOaFreEgpDwIvDrdcYs5L+UvVMSDEtr
	 VQS8spmPo1GjuFg8lOqv6BgC/h2D4BVJV7320DvGlZ0uQw9DMip1t5wzR+QZ+PZqvX
	 4euKkWF/7dSzn05IMr0YYsxImiQ5qB0q+sVlxBJaaa2seN5mPMPKL9DHtjsuYB7qn5
	 VPCiIaEbt797FILjsA9YdVx/DZCl4+YtNpBHarBuSuyC5IfT8VPCxxOsG44wp00wG0
	 nipgyIPW9XvlM+VpiwqXL2eRV69/I7/NkoZhH5IsZAm++5jfr2M3jbXO5AbKZHbT+w
	 9wE+XnHRqTRmA==
Message-ID: <ec8ae080-56de-490d-a1a3-e646e4a2d629@kernel.org>
Date: Tue, 12 May 2026 16:41:08 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 12/12] swap: move swap_info_struct to mm/swap.h
To: Christoph Hellwig <hch@lst.de>, Andrew Morton
 <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
Cc: Christian Brauner <brauner@kernel.org>,
 "Darrick J . Wong" <djwong@kernel.org>, Jens Axboe <axboe@kernel.dk>,
 David Sterba <dsterba@suse.com>, Theodore Ts'o <tytso@mit.edu>,
 Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
 Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>,
 Namjae Jeon <linkinjeon@kernel.org>, Hyunchul Lee <hyc.lee@gmail.com>,
 Steve French <sfrench@samba.org>, Paulo Alcantara <pc@manguebit.org>,
 Carlos Maiolino <cem@kernel.org>, Naohiro Aota <naohiro.aota@wdc.com>,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-doc@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
 linux-cifs@vger.kernel.org
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-13-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512053625.2950900-13-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: oejdkts7is7zt3qpecwkohgjuwt3fj1r
X-Rspamd-Queue-Id: 096832000E
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778571674-928015
X-HE-Meta: U2FsdGVkX18yuFwwDpp6e0AUcU+V3VLtnj7B7aHCojaAQIk08Prerfm77UvV8wxUThdlLnNFsTHhnDvEG++TRGcQ2MoucyiGVi9E3RQB655Dzqp1gYjlhdioaueNoMVfsCuS4QOxn5GfDzLKzIEbjuwhv654GGw/iCGqXnwNdUQcr9yakc5wRaqVskR146n0BuqOucllV4JcfK2Lok6H75ohWnrgHpUgLLVKzLTDMYR7Yq7p8ypEHoRA+3lopgjWBHrkKdi+h/cvomuhtKRy2kQhH7G2UPjoL48De8byFFlPa0urvyzMfDkM982ZiI8Gd5JElk+QOb4fbx2Qn1Bxg3MxBR4J+dMIchtC8sCIuNydz7EZWuj3Y/FYPNEr9UKwAnd0nzeHIjBshw3LfZZFZiod0F9oBhPCWu2lEJ2woUoucR8AtlWmKaK1f1oMPNBer8waqVwHZ1HVACs1142CisBPS9YP7AP8OI/LB21yLhDuNLZ2egnjwt7hTYe3EP+PXqrhCMrHPw7d6MDnQBFaYO0N14pk32oCEC/TE6sa8IWTnOZf8qv4PhM4w7j/uICCza96YJTBDqJZONA7FeiY1CUJLVhYN+AhxlqkjZ42BRAptQg7YYju4GMN1r0/+n/m2VqlDlXazDyM5uZ/WvgU2wEGYy6BbiN5wwK9Yj5jYafRrHG+G2HgIsSvHQbnCMb9JhQZhs85DZ5D1Pmj9r/wqV5OFODBXijwsxfOeBVkxVOiEtL7qbW0TU4KdE38DUQudG9QWWh8E8DEd+FmQfeiGBnpzJNZ/ecXTQITvtAeoeWz20gtrqYzezJJHguNhctNLsIWerX5uNwpAKDVTSywBzxJc9IHTKODHt5akhP2buC9L7SnRSd4sOIvUppWRu65hmxEoRExkTxCkm+eDBqQ+VdyYJsozWxUjnkQElQlSHxB9exvsqzaaD0NKEB8NJuMZPw1pmDM8+IjQh8z4Ds
 mWBXq6Ir
 O6UAohymZHtt8+JMf88rjcvfrkE4XCUnE3cIOa3m7qnWpNBsAPkTBO3XzYCxefZxkrv7Hhxxp+0wrZ5ATlsPk3L/Y4yre1dHKgTiG3KvsMcShzBwhCKCf2ulNwYWZNvuy6LOOuQyAjt8r61ohxFUHpuNPC8+RRMjqLPm8VJVT8VjuJhOQT+YdFgVX1Duyyl9tODfChN4jmxD1B0467QBo6HibxiATlTBQnG1UyhZuc/3x5p5qLJam/e4W0O6eoDxh9nWHjgLiaA/mQ9UtMxoWDy/QQ7twPAZ3r6kHMqvtWLXMGikLNnvi6vsOx22HIvH6PMoVuSMCptsMf4mHw/st08Y6njkhEf2FKpnHw+gGWPZNDgUN01IO/+kZmU+ViZ/2p5roLex++J8WY+wFlfhtZ0jnJLVsaiPnkgkGKUhYnsIQqE+/3sWpXEqEBsPW5Y8MqpDH9DZekwpPXLBbM0AvlXSHww==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 14:35, Christoph Hellwig wrote:
> swap_info_struct is now internal to the MM subsystem, so remove it from
> the public header.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research

