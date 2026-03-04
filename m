Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 028C9EF8FE6
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67F286B0098; Wed,  4 Mar 2026 08:40:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B426B0099; Wed,  4 Mar 2026 08:40:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C2F96B009B; Wed,  4 Mar 2026 08:40:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3371C6B0098
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:40:04 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B04ABC1D61
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:40:03 +0000 (UTC)
X-FDA: 84508489086.11.6E6DB5A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0EB0A4000B;
	Wed,  4 Mar 2026 13:40:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TxHpF5jF;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772631601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CaaJ0OKxMpZMGSsQkZwLI8CeqpHkNPbAlXb5D90noUg=;
	b=S2boxZ9uBxvkRK6m8gQNYZfSOgFKhcSynH60QUkbr5yrwgO41/qIFTJvPo3MSp/JVtE4gZ
	z0MNDi74RA+Vwvrw0uyjoeSEuyE8+D5OdVd4aAVw9EJ5McBB88aOHFVY+VvU7vUZB1MwAC
	UBUl3T3NfS3MvMxeJ25XANup6rIoBPc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TxHpF5jF;
	spf=pass (imf07.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772631601; a=rsa-sha256;
	cv=none;
	b=t0VLBcW9+8Qpbhn+n4tkVxWGW+laLWdwL/t/RNQHL5lg70tFTtjFbvuq/o6mOpxn3h9czj
	haQYs3mu0eWfGgRZPZtinYNrTIaucxlHWR30SfXLX2jPXotKZPaPrLURUtARUENcCuSMwI
	8tEqU/IVNFdBC1xOqs412w14L4dW/9I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DF6143BE4;
	Wed,  4 Mar 2026 13:40:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79464C19423;
	Wed,  4 Mar 2026 13:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772631600;
	bh=IgVErusGbBVUvuBX5aaGbT+VBaSMQ9ieeAk3Mhvg7ag=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TxHpF5jF632zcGOUPVYUAwPxtaLg9GeT4g9b8AGgvI/Zf/6MLbRx0eOYaqs/Tz2rX
	 WoDEX6icwQJ1AHKZfguDJaIB5cRqgN1uNpOv4nw+AYXXvVUCpbmoMjrLnMIhhOnQAJ
	 ixhvNXxrQ81HxbnMc+0ijk9fkkvUodWYyN2hDg4t0D2BLcdjZjB1xUPcC220usP4K5
	 kDlhOs/7zTcneZ5s7xZHMkkhmUYqSA5oFrsG/nXHoGJs4jaz9M9poyaP5RQ/6MPFlF
	 MFFV70+MuyvqSNLnJjWu3+ok2FdzzAItsx9wpeoCzA8GpbDpOahu3g0wyN6Baqx8Kv
	 2jiP7V/X8SUig==
Date: Wed, 4 Mar 2026 14:39:54 +0100
From: Christian Brauner <brauner@kernel.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, 
	linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>, Jens Axboe <axboe@kernel.dk>, 
	linux-block@vger.kernel.org
Subject: Re: [PATCH 21/32] bdev: Drop pointless invalidate_mapping_buffers()
 call
Message-ID: <20260304-dachboden-minibar-620c6f7d69fc@brauner>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-53-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-53-jack@suse.cz>
X-Rspamd-Queue-Id: 0EB0A4000B
X-Stat-Signature: eyqkqknghohf7kwo9nwmuhfjh4r4cspq
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772631600-38303
X-HE-Meta: U2FsdGVkX1+S93U7NZQcs96SgcJe0pJymBjmQXuGay8YIS1Bb1NwBBVqe7imFbJe5rMffoIV+Pc9SsgUcy+f7jbaXBUfS/EwZ3Na+qZkxv4Wo4ML4/FzjsIEaeQ1rR/tewKkTsJl+n23JR6I+Dnu8xQFtZZ4cYeQZlpUTQKNVp1Prl/Z//3NILOSuS26TvgcrNY/N1P8on8jCLDoEHJbtKJAf/Z/n8jIJ1ueEFb25VJaVHnOJC9GXQZF/xUKmtsbMdMyIvXvDy/kSaRTAn7Rn8JynXTr3ISt9u3iZDHeNyIKzuQjpS+knMtCioXHIpyZ/90ne2ymTMniIxWaUoOiJbKqgAFcD098r66s0kRqCkKSGaJXHP3Nq3wZddUdSeDOmqPWJQzO9wIs+iWOgTpO5KizsaVrdK64NnOdTOtI4M5y0yRNV7Fi9+hZYkbne37hDAmcS0S+A6aFjs0mXxZCq5mxh9HlUDABCA4202t9nDfB81R3dLZ3/puzvrsUlHNSgu47JQjNj+iyPhOwInk/5j6EyTkmqsS0QQ+yKaHLYCSlfQhZi9D7q/ZVARMld2TlO3pjQyHwQwN4sLAGWtHqW/2gJzOTVGvMp9bFiB4OqxhN080AWdDDvDisH0B+Sw5VZbMZllmEWtNXK4TfGLOPRhozjDa3GgtjvPJdlM6F76ttJPJhxmDZAEeGnHsNLExNX1kVMo75XuRliq+vkBVvfLJCplPsn8+mSFl/xWeE1j9gYmdXT8U7QzZ49Bu4zizazK30u9NVk2Ofd/eVw/zMgXx5f+uv5+MKQZbt9Eoljl1Vo3ZO4ioVCn+BPiWITK1ar8Y4sF83t/KdAFzvkRoFwafkw72fFrxk2TLpoz8a2PC1kcvZyaYh3QeNC/4mIOhPwq5vpaK2XN3y9I4kPzZ/1LvQVDcpUGJ1TjrjtC+MPGIHTwSIwTh3mU9yQtdJTs+n46mcWofpypwZRYwa3yF
 KIJpEOR7
 dceW+Zmxz3ZJ0cdMqRfp0bOvbnnoF3FW8LSROSjaslL0e3Q0PCRft1S9YiIsbB9mfKppm3oBzHDpb7bUrXzLIfUzXdAfiv/Yscmf6QQKTCOJACZDjj4HW95bQ5BBWTTy4BxJ1ePLjXWlc1FBwSZDj0S1C/zuvnyUDZUcmMf7XlisVizn7OLK5sxnLGEqd3Y0zuJgYdviI6Ebo0klmR1WMbx19TayM34IqCkP2Bcdn2jxwFJK4zW/j//H4Nk/wbhbF9SYNxXDrC49XaUge6enmuWwXANTTPfrX3QlzG+o+yAgLRbf6u5JKB7+gFj4TM4SSdD0ou793EJJKDahkKxFVy25jnV0B+mx4hRqOC9KTHhCAdj1VbOIFgpC4TqTQNWBuPZc5+CxnqRQd64I/LBM32fhBr1v0t3QFq/+4Yl68/gnKQY74G9fDBrnOfSoG43KKRIuB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 11:34:10AM +0100, Jan Kara wrote:
> Nobody is calling mark_buffer_dirty_inode() with internal bdev inode and
> it doesn't make sense for internal bdev inode to have any metadata
> buffer heads. Just drop the pointless invalidate_mapping_buffers() call.

s/invalidate_mapping_buffers/invalidate_inode_buffers/g?

> 
> CC: Jens Axboe <axboe@kernel.dk>
> CC: linux-block@vger.kernel.org
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  block/bdev.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/block/bdev.c b/block/bdev.c
> index ed022f8c48c7..ad1660b6b324 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -420,7 +420,6 @@ static void init_once(void *data)
>  static void bdev_evict_inode(struct inode *inode)
>  {
>  	truncate_inode_pages_final(&inode->i_data);
> -	invalidate_inode_buffers(inode); /* is it needed here? */
>  	clear_inode(inode);
>  }
>  
> -- 
> 2.51.0
> 

