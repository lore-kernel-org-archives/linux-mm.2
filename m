Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6944CD4855
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 07:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 063C96B0092; Tue, 12 May 2026 03:21:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B0C6B0093; Tue, 12 May 2026 03:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBAF16B0095; Tue, 12 May 2026 03:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC1646B0092
	for <linux-mm@kvack.org>; Tue, 12 May 2026 03:21:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A05C18CB15
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:21:56 +0000 (UTC)
X-FDA: 84757923432.06.748771D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id E6136180007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 07:21:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HpnCduju;
	spf=pass (imf16.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778570514;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CbVlwsx6CEYMg77PXGLk2/geTVRI/zNjmS6aGPk9n0g=;
	b=dVU7osn9MUfzFmECsi8Ntr7nc1YJoF/6A679MMJ0XI4yKNih8rKrH7sadk49JJhlIOl1Dv
	whj/L/9MFU3Ef0TCYXCzqctJ8HohsuYzGXNlcl/2vi7PLXfOsvlBU3pW5LGVNU+DAd4P1+
	cfI1TWRtJjXYdz/lZIw0aKBIUwL6v+4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778570514; a=rsa-sha256;
	cv=none;
	b=FSkkmZlIf2rtNFqMW0fOLzeAleag8br97vmHYiwFWANwu1530K2XP69N3MjZQpjc/5aGab
	Ie2dDDWbfYpLl9LVzw7kikHVf0j+Q0a1kky6O4Q0a+aEWs0zWT5Wt2qhSabLpPRm4YJCPd
	IvsDF+PASbXebfL1HPbEgd5SB5EmY70=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HpnCduju;
	spf=pass (imf16.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 46A4C60055;
	Tue, 12 May 2026 07:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F004C2BCB8;
	Tue, 12 May 2026 07:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778570514;
	bh=Xq9+eEnZyp37k7qXEaOdw0f0Snu5QZQtlvjD1+MYRu4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HpnCdujuSs0wcUGzR0lQTqIJ531e+c+TnGuoVAcjOUCcPqOGeNyWvcWsmYWSE3jxq
	 mF9lVHlk8lkWBf0HidM6p3rU5VPTfQGMU6Po421XDufDTQigS16W5xwg2srgvuTKs/
	 KXvnNJ/6OzLv9KM2ZGR1T2oxhsd+sSbbrbqvxmSKTihw1tl6w2uJS9X1KEKKjpadNN
	 4nuq5EdnivRdW3Qm2oZhiQCb3YBa3DVhaw2PQmZBwhcU/a2lCEilJYilNG/IlNeDSI
	 ro2YyO3EhmNbLo3hYTXPpvz/utb7tHvG+kyLD+U0Yk9qQMEGGIMuLHEz7RaJRZq/gj
	 LeQ/tiiv2eo8A==
Message-ID: <217f91d9-4d5f-47a6-ad20-0404968b8e08@kernel.org>
Date: Tue, 12 May 2026 16:21:47 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 07/12] swap,block: limit swap file size to device size
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
 <20260512053625.2950900-8-hch@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260512053625.2950900-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E6136180007
X-Rspam-User: 
X-Stat-Signature: 4ebh9zkta9wedub6sk1wn4xbj5nkpuus
X-HE-Tag: 1778570514-657473
X-HE-Meta: U2FsdGVkX19p5UBEV0zM+0HcKsf4GYTelGKL7UVSNpXaC0yhuq5oGfnlIFwmkZA7z1gzix5xGV2Ea2EMCbAH0LXlQec4zUown+65Tn2E75nvF/nl46qruUBggyfaLbV87UrJpZFlsG1Rjo9p9n43JYrm1xYyy3QhTgd8DFtwelQYs466ePgDyroHevc7Wgq88iDQ8ccf6qQ/3oempXXUjNue9cSuzk8mfW8k9W5XAJTwMx/TZwvAgO7YStmUk4FNoSJ7sab6xvYDdrUNyGPeZ1l1RiWUzt0lh7bQOcmgqv0t+C1hMImXFUXJtdgL6+7mUmd/qKLxMDtdY0vqQ9/XX87cN1KnJbp9qHJXL9xVoylDh6dmoBJU7wPVpE1CNFku6QypN4OOrN1jv+26/IE5Sldu8CsjLnUmrnx/VHRGWbG/k8u+Was0JqZjboXqeu0l6pCrEqUooASoE19d9D24BnOiZmoJH+i2a/SurBegHFvbbqHTpLB3sQV8Yv8FRV19u6aDuDu67i/+QO0a8AeSg9HA212J2eL7H+oJQv66C2TWfxHpzKcOWjJaLuWZVV7/YT5jURS7Vnqqnp9r7TDzDNBXlt4tSxj+dAgSY8N1vn2XqxmaHDbqBEQQaUHiJ5xYoOic//cKPIfpoeMd14QkYJNbK17w1QXvfP3SF+pAX5kC2ZEvc4SKkQYzRUAgttE7f+gpG1/donIxx8VrUHxp3Afc55Cikddc5XovQmFIaptp0McPTarGelwZQyZl91+LTxqGZzuQNhuNDackFERBTPDq5XtvtmcEyYzt5X83B51aKs+U7rGN5/nGMMxrW+Y8j4ohybvGk3WbCC4UqWmjUIK3NV/0cqrub5XYMdyddRwq5KrDdk6W1X4sFklB9X2QXWqakIGRCG3ttE6YJRj6D/VuJIP06VezrsHGPM+rLSkNIvn75SwTwC78oN36tQYe3HUMCfb6bVyVCcEAO5T
 aM7ztghm
 J1CflAPr9omA79dHQbYWCBXxyKhuMSenyhdQw7P838H6QkaMtUd35NkOCDF7lIiZutr9SY8DOcVbtiGU4VADaUKFtpxNga4Bk498i5esPdCzqG/eW7EFxUzCTGoYpe4V5CNlrlZkqg3VhjxIgsM6UFWdEKRwwzqVFw3liba5ZAC6Kde2bzr0yvRFFiknh+TXyYKoizA+7HvC60kERMrg+MQLzwSCSCu3CxQsJJVtwoLTAxLoLm+lAPq8HBkTMiBE2+x9ajmsoNclIkzRWPPdp/4gfADi9Tkbe57mJjDtPeHddDf5lqOEGUW48fBGwohAz9/YLswoj+OUyQC/WY9tKgNfNXUUzGl9J3xz0+22ZpealCSCl57XNct/xfY1ZWNJlUzvnEV8BKQZtkJOEAhJOORPvhBSMZZurC9x4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/12/26 14:35, Christoph Hellwig wrote:
> Don't blindly pass the value from the swap header to swap_add_extent,
> but instead the device size rounded down to page granularity.  This
> activated the sanity checking in the core code that catches a too large
> value in the swap header.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks OK to me, though this maybe could be folded in the previous patch ?

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research

