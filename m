Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 865C7CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 17:09:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF3CD6B0093; Tue, 12 May 2026 13:09:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECAD56B0095; Tue, 12 May 2026 13:09:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE19B6B0096; Tue, 12 May 2026 13:09:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA6566B0093
	for <linux-mm@kvack.org>; Tue, 12 May 2026 13:09:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7157F160532
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:09:58 +0000 (UTC)
X-FDA: 84759405276.14.0B84C01
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B7C6D120003
	for <linux-mm@kvack.org>; Tue, 12 May 2026 17:09:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RxFaNE5w;
	spf=pass (imf29.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778605796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQElBpLn1nS3xLhKLyy0LAuDhAI6VScuxHNo4Sy5ycU=;
	b=ZEh68YvFf54WMB3z99cDv4FVwrzkwx/V6qKtkcvsvEA8QUw/kXL6cIiQCMI4KhCMLkQAvF
	kfXDfTcqAcMo+vua5DAO5PU5v0K/kk7ZGzc7Os4pTtmf9OGHTGRL5IoY2muL3lh2+tKe6h
	bHXNGr8BEZeB9Jt0lxCYxyOv7XJds3g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778605796; a=rsa-sha256;
	cv=none;
	b=IYZdUqvrZtf5hQe7LNnf405r79e2UP25ST2rkg6iEEYG1eBAR8MLT3r0PyAN+qIp6UWBFK
	wx6SSQj1zl6a3/VDfrjQxAxjM/ZMjENyrN4y7hgZfZxCjsvLz2oZmt93++gXDu1DqUIXWY
	Dtbn3MUL8QjFK7slYNoKxxNNun8KZ/Q=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RxFaNE5w;
	spf=pass (imf29.hostedemail.com: domain of djwong@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DCF464191B;
	Tue, 12 May 2026 17:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD890C2BCC7;
	Tue, 12 May 2026 17:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778605795;
	bh=3aHXpzD86WhvrwXcIwdK9qFl/6Uw/9X6ePBZAS123EQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RxFaNE5wPAV876f9BvjR4wqLnwTIKIo7fOPGapy+ipTeWdy0jpxo8hQ2Ri0GGHmrp
	 CqEc/osq1V/20la7b58M49nDmb9ZDPQ1HRb652DRaiRlrgV68syhNYSwQ7oTHrZcE6
	 e3va7ElR0K9PdL8DhzMxSzWHChNELJn1/XKK6AOCxoD6uzKfeHErjVWG/d7wnQJObm
	 qV6eLTMTIGPO9wJvaDH523pfBAeOI6zjjN0aAdpxBGGOZXqoEOYhYlGqvV2ZUbFiua
	 kABUvY5GndwreOZSc90aCC87nHpz2HeFvQqE+CWvH5k/2Gj9vksO/G6bmHaKnlQRkP
	 sADrDRhCj51HQ==
Date: Tue, 12 May 2026 10:09:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Christian Brauner <brauner@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, David Sterba <dsterba@suse.com>,
	Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>, Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Hyunchul Lee <hyc.lee@gmail.com>, Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Naohiro Aota <naohiro.aota@wdc.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-nfs@vger.kernel.org,
	linux-cifs@vger.kernel.org
Subject: Re: [PATCH 11/12] swap: move struct swap_extent to swapfile.c
Message-ID: <20260512170955.GL9555@frogsfrogsfrogs>
References: <20260512053625.2950900-1-hch@lst.de>
 <20260512053625.2950900-12-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512053625.2950900-12-hch@lst.de>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B7C6D120003
X-Rspam-User: 
X-Stat-Signature: 9eg7cihbk963s5poynjdo9ogtoaftyj4
X-HE-Tag: 1778605796-372991
X-HE-Meta: U2FsdGVkX1/5bUn4IREF6ROVGIIJnXFD3VgHS3+w0jaw7nkS03r3OcGC3XyjhQVpqE0ke6fzUGPEEdN6tpbLPlzPkQ2eminGDuEw3uKcCqPMSYW03bOTixbSiVe3Y35jVxRNhnKGEI5oB4VHboFJMzBdFbaHYnXpgFtHU2i6wUFs92vOumKgisVxagyZJbt5/BTuqP6wKMLEx59HuC0a4fRZ06ZY4torc2NrrxsDcmaN7+cPF0/SjF0CyY8n8SD1RMuDj3WEmJu3u4D4DUJllf5aqiHtyAcSqV5vqgDYcBzP5AoDFSHLyyco4Xtj2isiXZMoYBZQ8o4zasbTfDFj+qnuZWA+2vhc0xt38JCVTcr4rEjcrjSKnruAfNTQyw0FaxXBZ+JYngWFnVsE33RF0gwIHcTaZPh4LJWLMlObOT+awmoiSCKv6LKnOiyY+yEaW76Fc1rMzRTKxixkNHJ7Az/86V2HC+kJasBy0PBC1fX8PAu/+mvfMZJWlkolUdKl+ht3Wh8WQJa2CV6/U9uW2OY7goi4m21dIDbz0GMKDvUxwfXLKkfyk0GhStfEkMqpir4GkzMx5nTBw8V6eJrVfa2FoARXdcFdY9N329tAnl3onYC0wPm563d/ScW+DDXffKNVqZsYgSXV9+vHwyE69tRUSwcf9VgQHzHfYaxoERJsQpOoOS+Kwl+1jNyWko/Vf/JmmEryeH9fVtO80XZu6YMRrHzyHH6wn21t4E/DYyQGcpDCaV7cou/l6CgBZO6aKzg475mqbFISmmEkJ6XmHkfGdPkxqUlV+jgQ2sUbG59fw365oND4WhnlXVWuBmL31aQXfhkuI49crAtiXUPvHDxVWX97EJeyVIoBAqEiiyGzwheM3QFvhZnFozUeuIg/DIAP9yPNbVX6TK/5trr51NLrL9ptr3azAGSDT6A8t9RLLskUNGQ4s3stdg+1z2QHCUt0C3sw1H1f/pkX52Y
 IKupi7kZ
 RrjTukU8I+OqlteWh7YVVg11nDBrE/12lC6+1Gu2wh5Iqyf3+FTKU6O2Lu5kXQPxm5pArY1TSUhPIAeQmZ3SJOlKcbAuNM0nddhVAkoL+tr04qBA1VSUz7vy9vLI3KiYt0vJunm9jRFT7/T1Sgd4Cq5EFJ6XGvC36VauC3Q4TZD9Buu/grsrCiRmf114rXeEwjzXAZkj3SLRI441bc/xR4r9ebajLPLrrst9V9kZFr68kuzctHsUdJRveqSRVEhxxBtXyQBMVK8Hbrg6l3Ts3fIjuv7+cBOU4MF/gErkTtfhiX86F1SB+ubRm6AII7o1QyogDOE+7pEdCROUaa45tijhWgqICCJEnXO4r2zQ+PN2b2V3mPIH4xKmlJMQL9uMj5OAVpoc7xy4EMJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 07:35:27AM +0200, Christoph Hellwig wrote:
> struct swap_extent is only used inside of mm/swapfile.c, so move it
> there.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Woo, information hiding!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

> ---
>  include/linux/swap.h | 15 ---------------
>  mm/swapfile.c        | 15 +++++++++++++++
>  2 files changed, 15 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 916889738f08..95237ee065c2 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -178,21 +178,6 @@ struct sysinfo;
>  struct writeback_control;
>  struct zone;
>  
> -/*
> - * A swap extent maps a range of a swapfile's PAGE_SIZE pages onto a range of
> - * disk blocks.  A rbtree of swap extents maps the entire swapfile (Where the
> - * term `swapfile' refers to either a blockdevice or an IS_REG file). Apart
> - * from setup, they're handled identically.
> - *
> - * We always assume that blocks are of size PAGE_SIZE.
> - */
> -struct swap_extent {
> -	struct rb_node rb_node;
> -	pgoff_t start_page;
> -	pgoff_t nr_pages;
> -	sector_t start_block;
> -};
> -
>  /*
>   * Max bad pages in the new format..
>   */
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 26852c2ad36e..c0479533f9ef 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -260,6 +260,21 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
>  	return ret;
>  }
>  
> +/*
> + * A swap extent maps a range of a swapfile's PAGE_SIZE pages onto a range of
> + * disk blocks.  A rbtree of swap extents maps the entire swapfile (Where the
> + * term `swapfile' refers to either a blockdevice or an IS_REG file). Apart
> + * from setup, they're handled identically.
> + *
> + * We always assume that blocks are of size PAGE_SIZE.
> + */
> +struct swap_extent {
> +	struct rb_node rb_node;
> +	pgoff_t start_page;
> +	pgoff_t nr_pages;
> +	sector_t start_block;
> +};
> +
>  static inline struct swap_extent *first_se(struct swap_info_struct *sis)
>  {
>  	struct rb_node *rb = rb_first(&sis->swap_extent_root);
> -- 
> 2.53.0
> 
> 

