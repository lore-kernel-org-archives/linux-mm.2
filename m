Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20F4ACCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 07:09:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A51B8E0006; Wed, 15 Oct 2025 03:09:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67C918E0002; Wed, 15 Oct 2025 03:09:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B98A8E0006; Wed, 15 Oct 2025 03:09:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B4298E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 03:09:20 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC70413C195
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:09:19 +0000 (UTC)
X-FDA: 83999472438.01.6507200
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 133FD140007
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 07:09:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o0Woxrr6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760512158; a=rsa-sha256;
	cv=none;
	b=8Yi6eU3iW4XdnY4oWHBaFSzrEnwo8F5pEe+152QYZcp3SjRibGskOn0g6u4dKErpbQgAGd
	mqWL5S22OlTpj+f5o1kCOBGzaFdeqfh4Xf/atAJ4LU4TbF+WeV8mZzb6rAxixnfjmM1+nT
	/bH5Lo3hYRM3TVd0/kFlQyf4SObg5pI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=o0Woxrr6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of dlemoal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=dlemoal@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760512158;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wV5DEVVZ/+cnPQ9tFOgHbC886qo3ryBdtcYJNK4CeI4=;
	b=HiGerK9/6raN1nn2A/CisvTzm3RMQUauoZQeEFCUnqrfLo7oHsGWGksmg48gzZKocceBZU
	8LQRkJxU5YUQuG6Y8bRrnOhJnmXoqLcQEnAzlhA0bIvm31pzF9qb4/mTv3gW+QTUJ+FjV5
	WVuGK82ORkVpTazBABp55O046wxatmI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7292E624DA;
	Wed, 15 Oct 2025 07:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABADC4CEF9;
	Wed, 15 Oct 2025 07:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760512157;
	bh=UMOggXsmSPLysxqQ4itPauqV7qt745eUMB/nuFIg2w0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=o0Woxrr6d4Kjc2IeLhUM//liDCgTmMC8m7u94P0oWpYw5ZABbIAFXouGwSoLw2PWw
	 4KQjKaw5riSZy7EgXgKqDGkEvvolojqRU+OxJ/VAVp+05l+0lzxnQEL9BUJH+IKaM0
	 mnQK9uJXXhnDjcU+tAPck6AavFFL1rNQkArdnlK0VdrUU2q9AWB9XVtnD5UtB1A3yC
	 485ll3gliB5FsLmL/mS1AAUenJWU1qP3BrCK5JebxppZgfn9yiGBJgbTp8Q7pKXz5z
	 HCmsFNOhxhpw71ayascaMj6JwAV+RM4DnpFUls9VqcHz/CnxQwbUoAw5t/UhcXjLtQ
	 sX5HHK1m7lo1A==
Message-ID: <a1671515-4aec-46a0-aff0-75ea8540394c@kernel.org>
Date: Wed, 15 Oct 2025 16:09:13 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] writeback: allow the file system to override
 MIN_WRITEBACK_PAGES
To: Christoph Hellwig <hch@lst.de>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Carlos Maiolino <cem@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, willy@infradead.org,
 hans.holmberg@wdc.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
 linux-xfs@vger.kernel.org
References: <20251015062728.60104-1-hch@lst.de>
 <20251015062728.60104-3-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20251015062728.60104-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 133FD140007
X-Stat-Signature: 8jg46bao7qrtiffb3k3mwbezfa5cupzz
X-HE-Tag: 1760512157-720134
X-HE-Meta: U2FsdGVkX1/lKUFL3YgjTOfzWdMLY/aGyz7gRcbXiN360Q8G7C+O+QQpHMNLViahfRM3pl0T4Mp9hptaxX/FTea6glJW/Wy1TQuK4jz58TwOg68VOGA7L9yTBJXiMrGNICI64/cjL5iMU8C8kQ06mZ4KhGIx5KhgcgB4Pibtz0Xf99+wo83T9qTV49y8gqcXRZyFLbU2RQRp/fQiQ18MoiyhNw35Nv7U2sa2v7vO1DYbSkDCoDfeMhV2brsyeiSTNGcynvavn6NIT6/m0olmSzmKJ6W47BIlhUxq7FGO3lQzB4LHP1fcFaeDkW9GkvFCQgYSHqWpER5OLLd7RySnO7Gynj0KxemEL7EKgp36Ss5IMp+VYIsV3DPpW02C3OU+c8O53O1aHQX1yQMBqKnOMgoLufy/zzVBpIbHnVGhsYeALv17xGUFa7tb+aU2aQnS4D7SZrrzBnRsizZEZ15HM7baVWYRHuHD+5bNTktTkLwfzOakqhLiWD9/fHPIUDhdmegnCwlRsGWmQFmIBeoealCGMpbbwRK4JjmSt1Ix29Nn3604H2PsdVnzgCNhGQh3EiKUf2W9XU8RN8yVOukVkmqoSnBxZ+eK7t2VSROgMYQ8lBc8LY3gsoT6zu9xGvFZZRHsInYW13Sr6ZiEHMOE/1sHSS+akRwElhwEOcqkUNWHqjApG6ozfV7NoIaS3EVg6qD6NtlWFeCxTBo3M7JltDtqEpjLEGpn/lskNKUU4GGwuwG+WnmgyP2kz5RADZFzfR+z9STUdJe5DDyiU9eAyQAneA5ZN+GLvfJXZP71sM7G7gvOosBbxRAVE8m+PGf0hTj7Z3o6Yr7XGWU85Lk7UiEFnpMq3liE/+sy5FiwIogbkvo7Gi9565AXXYvy/69huiwqxQpTxcVubdiERdqDMXV3/3DXcofYf+ygJQ4zF4biIAFJOVtjqQ0DqsoDWDIUJgZuc7xuIMEfhqAHiAb
 R/y0UM9M
 vWuPAsD7ZmUDAEiS2K7EBrPV+lgXgN+WKTMwZfuhpbhnUb5VUnkzSFAF43a+EO+5lMAevahX7OV77K/G1GnXjz/4CPpwHCwi1Z5ZJJkEMo6uqVktHa0AacL6emHVtXyWeJwwo72uyXcjHnN2ZDcDgJAAvHmacliPlLzHSkxh0cJ4Ve7LcWn2hmMI9e2qWYjIAqRk5l3Ct05eHpDhbmYOZmZcZl8in3KZl5vHjgkTDy2sUbU0Lqal/arm5qq6pmKZaC9rW2tiXmaVXSot5R0QnsXnmD4nLkx51xSPzFBCQkgZA8PbIN0MlEyEXQyIkJy5dN2WE8DPZNz5WBcQ5ZH1tkb8zbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2025/10/15 15:27, Christoph Hellwig wrote:
> The relatively low minimal writeback size of 4MiB leads means that

Removes "leads" in the above.

> written back inodes on rotational media are switched a lot.  Besides
> introducing additional seeks, this also can lead to extreme file
> fragmentation on zoned devices when a lot of files are cached relative
> to the available writeback bandwidth.
> 
> Add a superblock field that allows the file system to override the
> default size.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index c895146c1444..23f1f10646b7 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1583,6 +1583,7 @@ struct super_block {
>  
>  	spinlock_t		s_inode_wblist_lock;
>  	struct list_head	s_inodes_wb;	/* writeback inodes */
> +	unsigned int		s_min_writeback_pages;

Given that writeback_chunk_size() returns a long type, maybe this should be a long ?

>  } __randomize_layout;
>  
>  static inline struct user_namespace *i_user_ns(const struct inode *inode)



-- 
Damien Le Moal
Western Digital Research

