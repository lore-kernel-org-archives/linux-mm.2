Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA384FD9E19
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 22:07:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 230086B010A; Thu, 26 Feb 2026 17:07:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DE896B011D; Thu, 26 Feb 2026 17:07:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DE7F6B0158; Thu, 26 Feb 2026 17:07:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E74FA6B010A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 17:07:22 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE741C19F8
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:07:22 +0000 (UTC)
X-FDA: 84487994724.01.A860991
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0958F140007
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 22:07:20 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=K7DL8n1Q;
	spf=none (imf26.hostedemail.com: domain of BATV+c5cab09b19de097b6dd3+8222+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+c5cab09b19de097b6dd3+8222+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772143641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kg9gzOuUKPXfQ8TifAkHBiU5GSG5v54A0/HGpdATajE=;
	b=jp6wx8RQdR1akpYG8L7i7we8QLtZd9QK4vAjyDliXJSmZbocQRLtA8N6Y8g7LgYV/a7aGl
	8r7iWEcBem8MQFMMHCCpitf4hlyFX+/aam8lJqU2caRvR+PjJcGI8T9WueAmorHMCxQnPz
	w/67yPCs/NFYhcjSQ8clmHqXJWwAP8g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=K7DL8n1Q;
	spf=none (imf26.hostedemail.com: domain of BATV+c5cab09b19de097b6dd3+8222+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+c5cab09b19de097b6dd3+8222+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772143641; a=rsa-sha256;
	cv=none;
	b=nkahyPTkGL3EHYmSMGA00uTdnDnjOBDZsHo2aH3sMRSIEKOj4A2l+nFFdlxFbdlb+O9TLq
	rEJq99SCWhmrIhRG8cri2qBylZEfh8R64QD/6A6hNT4cGj8jgSb7uYbBaT/jhWBG8Bw0so
	kLrO8gYbSNszaHWQKyICXbKvo8KW1Yc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Kg9gzOuUKPXfQ8TifAkHBiU5GSG5v54A0/HGpdATajE=; b=K7DL8n1QS3fDGk8/1/ItX9kSyq
	wGDsP3RH3tejeQ90Haptd0/T0PuP9s1ekbp6LW1y31cbyrt9nWxqXpDH5yWK910W0H7qDmAOp4mir
	vPyykjX5r2Y9hYE4nuPKuxchdUtNCMGnFo7DpEMxzLsXdtuACqOyH7o+aoj6LwBSld9JPHEVZZaeS
	qBKvr5fqBFTTGOOveTkKaGnpZpaKhIND3S5tdw74N7oTSKyYDDBmUZ77/NuHPY3rtWDa/wNtmot3+
	r6z1pWxyxWHCTDAUm65LDMvRpEaU6e357eJg8d2uGILLtuClnyLAlOgGs7cbZuIkAkYRoS4MeaaqN
	lclBFExg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vvjVq-00000007HdC-1p3G;
	Thu, 26 Feb 2026 22:07:14 +0000
Date: Thu, 26 Feb 2026 14:07:14 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Jens Axboe <axboe@kernel.dk>,
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
	linux-mm@kvack.org
Subject: Re: [PATCH RFC v2 2/2] block: enable RWF_DONTCACHE for block devices
Message-ID: <aaDEEjVKBKrLxsht@infradead.org>
References: <20260225-blk-dontcache-v2-0-70e7ac4f7108@columbia.edu>
 <20260225-blk-dontcache-v2-2-70e7ac4f7108@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225-blk-dontcache-v2-2-70e7ac4f7108@columbia.edu>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 0958F140007
X-Stat-Signature: pzurm7k5r5xdwwaobkyyp3y8zfncpp48
X-Rspam-User: 
X-HE-Tag: 1772143640-321921
X-HE-Meta: U2FsdGVkX1/WIXwkm5Ods9ffMa+baR2tjCU9L0j++5Glii56q7Qlo7gLWxrhW7/pbUsKJRqEkZjjmD8bHDXn+Qrt8FV6YRINa1/uy5sbD4mkYiDOziWNgGKtIuHCdtddAY3bWsvpxgG2D68rFe5op3xfPtmrqlEXWub5952Din73/c8/OKFAp+o+FShggds4YIb6QbeMMjHBLzvgzHU4+YK8wQJZaZGDVw3zjkt3rGhrSC5SrjSAC6e9U+SxcQ2goobXPzB7+SoE7J205aYiLuk8QrmaPT5ZOaXit4GeNWXvQMHZJOb5KHHObRTdEPfOk5zgWBwzHUiwXKNVBhFGPuxprc8DVi+K6+jNUkhxmoayq+7uneEcA1k8c4NatPbMCts4PbeaxtSHdkllQnrEDj8ols6NA/Oh7Xt69YNNYGMt/TiBZvOnkdEf5lQaeONNTvE91JHTJooJnb5MOV+wZyLOFIadCF19yN60TegfPH4Lcu9zh1mKTAUdcaJVCgkdyi7XAXBT43Q/P9xfeEx0UTLSDM2PT8hGAGczhkV52WDqACpQH+ykmX++vBq2DQTX5gXrEJiBNrW0N8IFvAYMHfsSkLCwsj9a9PSrJRgzsJq7YJnuyDAp3+Mn2k9w9xT/exiIiJpftH1VC0Sc+VkYQxfoBPQQ5UXF4sscvP5+g0c87XWMg0Eun05D3us/V7WosIusp36nz1s4Dw7DQnMiQ9szOE9jipAum94h45Xy7WoYWuDwn7wzeSGyAhH99slUd0SuB7TygzP1MYi5tbJhJOwN9DyhAq10XW8m5hBwtF8mzyZLNvfAIo1a6fjUafYJzLSaDfHtUayOzsdzZYyQKPzlSeSpCjfW5pQxU/bc9T0s+VfNbAiQvP25KLTU4oTY2chlIuC4rIYoqCUGyz3TElcNh52cYCLLXdoqOtjPnRZgf4c7KUQTMsNg1nn+6qhd5CWhNGvTzPdSZuHS4lZ
 hQY/yR2Y
 2ICeFisuZpqUm7nISW5h667uMqPeGfbJ7Bal2ljQg9IaZGrYRIwSVobft6RhBsGCz0cXG4OGYxeImfqOEXSdg+ljo2ylwlXWR0ScqCzlIXl6jonk9ZzmU3YvmoQLsOEl0zckf4YDjmEuQkLmnt+HFpnO9Vl4bvS6dGC5v5hXpITRAAKPcrhbew3eDZV95QnK4bOSxYu5aUZfwdDY5+1m+pfrQ111+eO8inynuG+/myV0JLXAbazi7hW9OweCFEFJ0pvtbkXCe5c1ZCHYFTb2a1BRljyDs1L32gOe0DZ40g73AFw4FcRVWnRTX/fw+L3pU8jawKmGy1sQpecHw1+GAe8aG/5S5CIfCCeL0BNhs7rRQ5LX1Knv6JHdIUkXIoLJjzksSkUXkY1RpszPtWD6pwyAIoqN0dIsDaqmCgEZGwZM/t0yGQWciCUL8c4Tutv/QyhYUjY3qstYn32U5yyMkid/Lk1W40xYKxQ44fkA9ZAdQTUL0oGwVvQSnd/p5+azIiGxKocRGBpHpYOpO9BZUoSaoIeVqEPaENpaoWUwKN1IdspERWtuo6YxFFvIAycr964nD3JJn1l5hNUAL5TvSXbmaHLnUaktR0xvPwJ6zPqiS5sOCyTiF8MFfCHnhnbvs4CDwz1mV2bASuhg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> --- a/fs/bfs/file.c
> +++ b/fs/bfs/file.c
> @@ -177,7 +177,7 @@ static int bfs_write_begin(const struct kiocb *iocb,
>  {
>  	int ret;
>  
> -	ret = block_write_begin(mapping, pos, len, foliop, bfs_get_block);
> +	ret = block_write_begin(iocb, mapping, pos, len, foliop, bfs_get_block);

Please don't change the prototoype for block_write_begin and thus
cause churn for all these legacy file systems.  Add a new
block_write_begin_iocb, and use that in the block code and to implement
block_write_begin.

And avoid the overly long line there to keep the code readable.

Note that you also need to cover the !CONFIG_BUFFER_HEAD case.


