Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE156F3D608
	for <linux-mm@archiver.kernel.org>; Sun, 29 Mar 2026 13:55:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C96956B0092; Sun, 29 Mar 2026 09:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6E5A6B0096; Sun, 29 Mar 2026 09:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAA636B0099; Sun, 29 Mar 2026 09:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A23D66B0095
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 09:55:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 46A14160165
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 13:55:18 +0000 (UTC)
X-FDA: 84599247516.17.227A2CF
Received: from mail.parknet.co.jp (mail.parknet.co.jp [210.171.160.6])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8E54B80004;
	Sun, 29 Mar 2026 13:55:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=parknet.co.jp header.s=20250114 header.b=xj+M8VDD;
	dkim=pass header.d=parknet.co.jp header.s=20250114-ed25519 header.b=4mTxwXMe;
	spf=pass (imf02.hostedemail.com: domain of hirofumi@parknet.co.jp designates 210.171.160.6 as permitted sender) smtp.mailfrom=hirofumi@parknet.co.jp;
	dmarc=pass (policy=none) header.from=mail.parknet.co.jp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774792516;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KIltfUA5+2NK3wdSivLBU62ecJ7gsJtG2EiE1X57dBI=;
	b=OSy3ILeYZI1ldwgrdNtShC5C/TNDzLhkbqANeGtY4QvMqVAUb6GZK/xj5ul488Pf7qvrxE
	nK9NzbINi0ZYzgMRGgB7BmSKz3Prw4BhT2Nx5Acysv17J83bgnE4xlERWrnLViJj97JyN2
	WgANlJjVOYsv58/lXWUu5BmfaG7rY0E=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=parknet.co.jp header.s=20250114 header.b=xj+M8VDD;
	dkim=pass header.d=parknet.co.jp header.s=20250114-ed25519 header.b=4mTxwXMe;
	spf=pass (imf02.hostedemail.com: domain of hirofumi@parknet.co.jp designates 210.171.160.6 as permitted sender) smtp.mailfrom=hirofumi@parknet.co.jp;
	dmarc=pass (policy=none) header.from=mail.parknet.co.jp
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774792516; a=rsa-sha256;
	cv=none;
	b=swFtpZHED7z+58OGOkOsBo8ZrKnIESc4lI9MaZ3sThPNJoIrAPM/3MGwucim16dB9l0MMD
	P4RcpEnPf5mcQGS+GVfteUq0UsixF3VN6Coz5R3jorkZWlxDDgj30Fo1x9MCLde8YGzdhx
	mFHBaXgqTDASYbPKETS+LpcPOYWnkyU=
Received: from ibmpc.myhome.or.jp (server.parknet.ne.jp [210.171.168.39])
	by mail.parknet.co.jp (Postfix) with ESMTPSA id 7E32126F768D;
	Sun, 29 Mar 2026 22:55:10 +0900 (JST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114; t=1774792510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KIltfUA5+2NK3wdSivLBU62ecJ7gsJtG2EiE1X57dBI=;
	b=xj+M8VDDMDYKnn0BJ+hNu63xwfdh96i8SzbyNPO5WVD8WO4XjKjtELvGfOzW7jb+BH9uof
	KCKAEUdpjs7NKMXdiZ7771WfWUp6fYxK/zTu6kmli8JxLRGrQ6VechGHojzdVyK4komlfR
	EMOqLFsFYoZl/dOphKK4iUSPzQArLpWSJ5jHPquS/W0LADwfyuX5/zQJrKXZJPcXNLSeO5
	ZWnZAG6w/9mKgThTrvGOtDu3nGuTLIISot9XQN4y2QhNjO5WG6GYoI0f75rK/WiACFoiLw
	mV323nsWGwcSr8xmLW5PZvuCGdwNGj0xQuk4gGxAiytp37umZPMuc1DooTrNZg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=parknet.co.jp;
	s=20250114-ed25519; t=1774792510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KIltfUA5+2NK3wdSivLBU62ecJ7gsJtG2EiE1X57dBI=;
	b=4mTxwXMeeuLuGk+hT0eoHS+aiarZC147RAzUWMn12DyWrPq3K33cLpx1j3joSVY+LQsOGz
	OgcvTa9LfZSIbDAQ==
Received: from devron.myhome.or.jp (devron.myhome.or.jp [192.168.0.3])
	by ibmpc.myhome.or.jp (Postfix) with ESMTPS id 03DD5E0029C;
	Sun, 29 Mar 2026 22:55:10 +0900 (JST)
Received: by devron.myhome.or.jp (Postfix, from userid 1000)
	id E9EE322001A4; Sun, 29 Mar 2026 22:55:09 +0900 (JST)
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Jan Kara <jack@suse.cz>
Cc: <linux-fsdevel@vger.kernel.org>,  <linux-block@vger.kernel.org>,
  Christian Brauner <brauner@kernel.org>,  Al Viro
 <viro@ZenIV.linux.org.uk>,  <linux-ext4@vger.kernel.org>,  Ted Tso
 <tytso@mit.edu>,  "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,  David
 Sterba <dsterba@suse.com>,  Muchun Song <muchun.song@linux.dev>,  Oscar
 Salvador <osalvador@suse.de>,  David Hildenbrand <david@kernel.org>,
  linux-mm@kvack.org,  linux-aio@kvack.org,  Benjamin LaHaise
 <bcrl@kvack.org>
Subject: Re: [PATCH 15/42] fat: Sync and invalidate metadata buffers from
 fat_evict_inode()
In-Reply-To: <20260326095354.16340-57-jack@suse.cz>
References: <20260326082428.31660-1-jack@suse.cz>
	<20260326095354.16340-57-jack@suse.cz>
Date: Sun, 29 Mar 2026 22:55:09 +0900
Message-ID: <87ldfazqo2.fsf@mail.parknet.co.jp>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 8E54B80004
X-Stat-Signature: 4ma4t97jhdnn9cj174h49z3pnz6rapri
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774792514-735263
X-HE-Meta: U2FsdGVkX19R9IpWcPE84GEc/S+EqJRYfdZW9u7vGMaxf+B2P5az9ab2+yZ4N3Z43km9ti8ZN6Tu78xZDU87Q8XdvdcL2vIlmRs9M+aqtCtDSeCkTE8LRKRBhPh8Ew1BGk1CGnJQPAm56q2BFzRnigWySk6EcK11KaR1X/TmhzMSWhrjsNIvHJmkPYRbEIzUCcAwfsmCd+ccQpxFp4dlAiVaBu+EI6LQld+BzduROJvjRLfwjBTdobjq7RSzYd2ctdw3YkAU/fN82hvSeECVVBZ1KmhYwlPMFjCZ/M7ADgExHIoBYzZU2L1RHIzeX268aabRzZ7yy6XpKVx6RgHV84nnxV/bH1VqWidO4oNQilqZ+zg4bqWNJptbcOt8MybCT09qJIESYFca3gCJeaI+xGTrWC/IagPTkK4vFeECVuF0drm9v12BCKBpa3d8DnIRN3HfMJ8bzdAGgHrCSvJWVxIf2Ucr+s39yzQjTkNsI8XcFvdOXcpPL3Aaa4mgTPRaaciwV4KXb5rS9XNdBL8HpW9FvrBbg8qYc3pTNHcGr1LdElo1LQUhi3MOo/wfhVPnUXiaAHqw/E05IeBrZbMZ4OI2Am65SyAzjdGpxV4xsy6Zul+2gonVKbfsJ9wTgU5dI7hrPJan5UINfgl97MXqa6qHgPdYLRRYJNB8CZgFo814YsXHARa9/F7kNjLn8VjzwAPrPxtmVjgJIzEUgB5hj96PbPq3QbbKphcEUigsA6cSzep1Lvydvppji6TgpxdhZJqJyB6gm56PMUEseyD75KsXOLceFklv8zyqkxa8VTWRbM2tb2aZqC+PHHs1yOuqZ50S+G/0gHU9MEo2VJhTdEUQipWiriT6ZgZiYFH88ocYK703NDGYZYZ/WZb5/VZ70uqNFbQz4tUiH79KOyUwv3mkKgfsDwKrIA08BYznScdhA/sB+VJQrK0uVsk6ANoIrUWtH9cbv9Rge45B+zM
 N4yB8II2
 ZtIHE0vptDk0uT+i2RAgOoKnskwVy8uEO0hkxtXrVYYH/25WZGzIInEyU+iiNhBruipLFOZ6prpWlZBjfwYZTSs29JeaiV6WVgI+oEN13PUjnNcKWsKAdTkq/ymwOsmLuKHM7wBVDAD9TW8spHhtn1/safCv4KeZlEL89XDTSpYICnGRsgKHfivraijUGAUBXNZFBFRFjKif5MdAlsTDcIQTVXmBa9AfUVn5q2VlwcDlglNi4lX2Qmh1PrAKyHuL/Hwo82pNIbN27wibwgoQzLa45XuxteHnMB04NOpOKA4taKyamKvRtBobU2oA4iFrheNjB93nSNqnq5VLrz6m4N63baBT1jHdjcRY1KKtOnARsNsijyZ28Pw9dzlZXKISnQNYh+thMNHQqRxbrX+mla0+Cdklhd/bxrs3MWQTp+icJqqNMZQjG1IGkYd41BOsWSp/kWPryPvOh0syrMT+XhQIo0N6og08B4OAYtKFDF8iPrCw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Jan Kara <jack@suse.cz> writes:

> There are only very few filesystems using generic metadata buffer head
> tracking and everybody is paying the overhead. When we remove this
> tracking for inode reclaim code .evict will start to see inodes with
> metadata buffers attached so write them out and prune them.
>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/fat/inode.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index 3cc5fb01afa1..ce88602b0d57 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -657,8 +657,10 @@ static void fat_evict_inode(struct inode *inode)
>  	if (!inode->i_nlink) {
>  		inode->i_size = 0;
>  		fat_truncate_blocks(inode, 0);
> -	} else
> +	} else {
> +		sync_mapping_buffers(inode->i_mapping);

Hm, why do we have to add this here? For FAT, if buffers are still
dirty, buffers will be flushed via bdev flush?

Thanks.

>  		fat_free_eofblocks(inode);
> +	}
>  
>  	invalidate_inode_buffers(inode);
>  	clear_inode(inode);

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

