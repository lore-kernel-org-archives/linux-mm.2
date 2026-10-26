Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 468AC606A330
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 13:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=UX1M8Er+;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=AstCp0Vn;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=UX1M8Er+;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=AstCp0Vn
Received: by kanga.kvack.org (Postfix)
	id 624F26B05B0; Mon, 26 Oct 2026 09:31:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D5856B05BD; Mon, 26 Oct 2026 09:31:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EB8A6B05BE; Mon, 26 Oct 2026 09:31:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1837F6B05B0
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 09:31:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7E2F6A8337
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:31:43 +0000 (UTC)
X-FDA: 85364864886.01.99B7D74
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf19.hostedemail.com (Postfix) with ESMTP id 45D261A000D
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 13:31:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UX1M8Er+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AstCp0Vn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UX1M8Er+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AstCp0Vn;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793021501;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LKf/jI/bjj0oPXrviRNSHjeXeMp3TxZx0LrRFINXjVw=;
	b=6LE6mfXM7PTvOCXfO4xGLnYeVW1cDhqDkhH4dNCXRmLTeo7kieyFy+W7evZxJLxnhM1AWQ
	h/yy/tzPjt+OywfB6CaMNgS+MqudUI5EOYMUy2CqerJNIBSaffwA3RRaEtQ2X/yyn42uv4
	Ccu4ciNPoEH8rlDAKn1BN5payjdFtQo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UX1M8Er+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AstCp0Vn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=UX1M8Er+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=AstCp0Vn;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793021501;
	b=3IKvP8sdba1LlBoVtK/c+g1IM+3xTEV8cqKOMkr9UCVutFY3EIPiqccX0VP41B3dcYSgNW
	/u8/QNg6iIIDSsNnirG4Bzr2B9kESm9ZfQ5a6D7NslImKC+jvDfNfxDtkQ1mBV8Z+OIcqU
	k/jO5KDmgw/DGJhAcnTKhDdAGTHg8Og=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 27FB721EBD;
	Mon, 26 Oct 2026 13:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793021500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LKf/jI/bjj0oPXrviRNSHjeXeMp3TxZx0LrRFINXjVw=;
	b=UX1M8Er+JZvgKRP+DnkHGie/LMyRJLqLTRWNMKOj+vLBPyOqyiDN7H22WQIJiAm1tmExF2
	CYQ/CL6epAdiKivnKyhe70jXQhl8NoosTUaZFT0RvqQzP0fX2uNnOSRmuun6FjyfoohMgI
	J5/ZxwjV5WS8j4OIIQL2O9Bc7I7UW7U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793021500;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LKf/jI/bjj0oPXrviRNSHjeXeMp3TxZx0LrRFINXjVw=;
	b=AstCp0Vn8QLm3QFjXiGbZoQjWqLwTJCuYYh/PwSlR9ZX5+HNTFcIgFeuvV0dzZzoKJOcsd
	5BHy+myC12caKbDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793021500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LKf/jI/bjj0oPXrviRNSHjeXeMp3TxZx0LrRFINXjVw=;
	b=UX1M8Er+JZvgKRP+DnkHGie/LMyRJLqLTRWNMKOj+vLBPyOqyiDN7H22WQIJiAm1tmExF2
	CYQ/CL6epAdiKivnKyhe70jXQhl8NoosTUaZFT0RvqQzP0fX2uNnOSRmuun6FjyfoohMgI
	J5/ZxwjV5WS8j4OIIQL2O9Bc7I7UW7U=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793021500;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LKf/jI/bjj0oPXrviRNSHjeXeMp3TxZx0LrRFINXjVw=;
	b=AstCp0Vn8QLm3QFjXiGbZoQjWqLwTJCuYYh/PwSlR9ZX5+HNTFcIgFeuvV0dzZzoKJOcsd
	5BHy+myC12caKbDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F334913408;
	Mon, 26 Oct 2026 13:31:39 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ulRbMztW32qOeQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 26 Oct 2026 13:31:39 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 80BEEA1419; Mon, 26 Oct 2026 14:31:31 +0100 (CET)
Date: Mon, 26 Oct 2026 14:31:31 +0100
From: Jan Kara <jack@suse.cz>
To: Jiale Yao <yaojiale02@163.com>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/5] filemap: drain in-flight DIO before buffered writes
Message-ID: <ddkjou5djippzkzf4euqg4wvsnjsc23fw4qldwi3hru5cxg4ul@eyts4mtzasxt>
References: <20261025124115.3178287-1-yaojiale02@163.com>
 <20261025124115.3178287-2-yaojiale02@163.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261025124115.3178287-2-yaojiale02@163.com>
X-Spam-Level: 
X-Spam-Score: -12.80
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 45D261A000D
X-Stat-Signature: 5qi1kro85osmaxpinbsdkrdyxcyfiwwh
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793021501-592393
X-HE-Meta: U2FsdGVkX18npcwpGJclOuB3JBlobSYqHOZZo+YNduQgKk5uAhrgxeyFYllnRmQjtZlhPesczK94P6P4n7mGq68XbOUNvCLAXT6Vjt+Ne1fK2BqoJzhwZaq17QdSFH2YExw2Ps0OsZ5FOQrfPrz8YmOCZPKGlrA+zVmz3WkoLHwk+/eDTi+xNHBSSCK1XaWnRlaWyVbyCrsOQfW0SDN3vGp1gnmwoFVd9obaaA2ZLn0zDIkDb7Ir4tgKEKcYoP45cG9xT2SR1DPJ2OnTuXh/1luo91Dd2GR+8Vk2/rVcrEbg+n0FZ0woSGldZLM+kq7OkfHMkA2kPduRJl6yQbPM9MPIbl8mL1+dnBqG/AhF5x4gPIbYrHqmPENyLQHVb65IngOUEa8GfpU6vUd7Tc1G6ET0/YDgDPyD2wdq1F/Rna0008ys30wUBRmGHce2GBDkeAPvQDJjtT44UVGXDVbCExeCWtqa1FYAEHPyhGGCI6rvr7cTQrd/7IvZYA6F92Vin1i+cJwl4exkachJnzbr7O+hMKYU29kzNT5irJ8ZtdlBKUW2wNkyWo4nt4c+oTcngwqeU2FpUrxkOLHL/Lbv1NQyDXJQLCoR8LpReWqmtvh3yiOX1xS9TMfYhWrKBnzUPSyH2PL9CUrmfe0tCM//RvXyBnsbvM2tU0D0Hrl+NIlIfxKDctOjngUtHzxrpocGR1XBvqQTI2kD18iGDfMRD5Y3r8/j8EKTlY9GxWY+isn0vAcCMLOz2bTahV8mIRlMJOeou/B81Ubg6ZW04CR0sbq5t/5VjBkwPVo93MIc1KE+ARNk93ypbZJhYYn4HmKi9yTMfRyRHJexhC6BXVkGpVlFakJQ3z7mkMzXYndRRQyOc2BK43j+oEMA2p7Y5bPDA6m0MSIk2hO1aGTgXCS20woqQBEUVnHemKBZ33DhjhTy9NxqMwftAAtWEru0PqdPdZNo8rFrGPaStvK6HWO
 r5JCtHHl
 QS+0G8LeBXi8sGMhcOwcblB0HFz7VsVzusZ0uNZ5fmSQ0jF22fvI63mRVBnZl865R7yu67A2rEHM2tfZhZUP3qy773C8zU89ZubuI1Re36ZrQdFrNdkJdsY9WZO51G4dbWtk6sCrj/uYnqB/xVx+10mLHVIv2X4XBSFiKQ51RODOu78mHDGdQZL2+nhdiWlqzSNeEVEDWC+Zp8+WMwygEYhOpmfuRuXUcJvHIRC4Uf3Yj/rnQUgCjrZjCuwx0EkKFkgE/p6vn2zf9zbzCJpzzaoJGxzsDGRq+u3XV65mUMJp1FWUcVyE/ZfJM2Q/xRbv6UFuMtxCXTSmTFlqY6YtdiqvE2XfiviQhLzcMdBcOKpxa+Fq5DB4eFy+mjfLJyypcb/Io
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun 25-10-26 20:41:10, Jiale Yao wrote:
> An asynchronous direct write can remain in flight after its submitting
> thread releases the inode lock. A buffered write can then dirty page
> cache before the direct write completes its post-I/O invalidation. The
> invalidation finds dirty pages, reports a possible data corruption, and
> records -EIO in the mapping error sequence.

Well, when you do stupid things, you get stupid results. We were always
saying mixing buffered and direct IO in the same file isn't a good idea and
we try to not screw users too badly but give no promises. This falls into
that cathegory... So I don't think there's much to fix here. The only
sensible exception here are simple filesystems which have only simple
support for direct IO and fallback to buffered IO for the rest. But I think
we should handle these on a case-by-case basis and either drop the support
for direct IO altogether or convert them to iomap and properly handle the
waiting in their .write_iter methods (like e.g. ext2 does it).

								Honza

> Drain in-flight DIO before both regular buffered writes and direct I/O
> fallbacks in __generic_file_write_iter(). Preserve IOCB_NOWAIT semantics
> by returning -EAGAIN when waiting would be required, while retaining a
> positive partial direct write result.
> 
> Fixes: 8174202b34c3 ("write_iter variants of {__,}generic_file_aio_write()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jiale Yao <yaojiale02@163.com>
> ---
>  mm/filemap.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index b74bc1e5015c..289b8ca44ada 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -4502,10 +4502,19 @@ ssize_t __generic_file_write_iter(struct kiocb *iocb, struct iov_iter *from)
>  		 */
>  		if (ret < 0 || !iov_iter_count(from) || IS_DAX(inode))
>  			return ret;
> +		if ((iocb->ki_flags & IOCB_NOWAIT) &&
> +		    atomic_read(&inode->i_dio_count))
> +			return ret ?: -EAGAIN;
> +		inode_dio_wait(inode);
>  		return direct_write_fallback(iocb, from, ret,
>  				generic_perform_write(iocb, from));
>  	}
>  
> +	if ((iocb->ki_flags & IOCB_NOWAIT) &&
> +	    atomic_read(&inode->i_dio_count))
> +		return -EAGAIN;
> +	inode_dio_wait(inode);
> +
>  	return generic_perform_write(iocb, from);
>  }
>  EXPORT_SYMBOL(__generic_file_write_iter);
> -- 
> 2.34.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

