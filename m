Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86B0CCCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 08:59:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B6BBE8E0012; Mon, 13 Oct 2025 04:59:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1CA28E0002; Mon, 13 Oct 2025 04:59:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A32298E0012; Mon, 13 Oct 2025 04:59:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8BC158E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:59:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 360341DDABA
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:59:23 +0000 (UTC)
X-FDA: 83992492206.01.EAE7E86
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf10.hostedemail.com (Postfix) with ESMTP id F1104C0003
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:59:19 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=h3LaqdNR;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760345961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gGIOd7Ex2m90KckglAwHsiXkn+YFnTKWdf60l+zhCdc=;
	b=BMJ6J4PkjkGb2dbo1gPkCYDlJHmdZ9NwsjmzsDNdhPXRBfEfa0adB5T+wxV6A5OlW1EqPG
	G5Rz0X5MAkKmpJygfCoSw2GEw4Wp8x9VyUPk7wQY1doofB8ocbdHPzRvSnCS5I51y2gWBI
	JA53UZPfngP7cCGN/wB+OwIdnV8aJyc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=h3LaqdNR;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760345961; a=rsa-sha256;
	cv=none;
	b=c76B7rTnLjqgXC7ZefFg5l6zZgtsaaQ1h52WjfuPxSoFnEv9eNBu93rcz/qlDfMM39SGcq
	elloDT4ng+dCSWxQcXEu8pP1euWpzo1TyIOU/ssyXKCb59wwyPXLnLqzrFGpJHAvkKGPyw
	zvatvhhNtP82hz88WJqMOZbL9r9+DaQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760345956; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=gGIOd7Ex2m90KckglAwHsiXkn+YFnTKWdf60l+zhCdc=;
	b=h3LaqdNRHndzkRMufqmKcgJ7nMw9gmr2DxCZkxLSn3tWuuMOUs5UOAOrxr7OSasAqIqROY4s+gg5v27gKZvRZjfwJPoEox0HTVXN/EeCGzzliOwlBrqVy3lSbuTOloh2RYeLZSiQMEQHDszJQlShZYIONDMhzIq8OPMurstPjV4=
Received: from 30.221.129.221(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0Wq2ERPx_1760345954 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 13 Oct 2025 16:59:15 +0800
Message-ID: <9b8abc79-8605-4c13-9d9f-972f90418cd2@linux.alibaba.com>
Date: Mon, 13 Oct 2025 16:59:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/10] ocfs2: don't opencode filemap_fdatawrite_range in
 ocfs2_journal_submit_inode_data_buffers
To: Christoph Hellwig <hch@lst.de>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov
 <lucho@ionkov.net>, Dominique Martinet <asmadeus@codewreck.org>,
 Christian Schoenebeck <linux_oss@crudebyte.com>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Josef Bacik <josef@toxicpanda.com>,
 Jan Kara <jack@suse.cz>, linux-block@vger.kernel.org, v9fs@lists.linux.dev,
 linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
 ocfs2-devel@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org
References: <20251013025808.4111128-1-hch@lst.de>
 <20251013025808.4111128-4-hch@lst.de>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20251013025808.4111128-4-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F1104C0003
X-Rspamd-Server: rspam03
X-Stat-Signature: ub5q9kxb36yh1cgqrka4iq6zknpozc6x
X-HE-Tag: 1760345959-292748
X-HE-Meta: U2FsdGVkX19hM1T5hsUsiTrRa6rYd54jsJcpRmltvmYd1uCysDiM83MHvU1GGtCH0QVh68nSyfavE7WhgRrJTcw+J4LpQpzBlKLWIHgIZZ9avAY7MbmmWLoj7f9yjc6xtQtonVa2sf212HqVt4HynFkN90q0+o2RnLNf2QwFRdWlftvNLEgGFlJOmS7qU72fdmp/hKTHx3RB6Uopz4sRTVMaiaujYJ04eiPDS6iNEppTCjUdmn7QLyiZzsGN1I6nfw25lWilERIcy1AGI3TCUEtpu4wFYJs6cGdGqUaniDhUn0OO0U5cJKI0oFudXgqSzO6KQY/S2JhZgv1Piyu8SBO4ZwvLSw1Q4/DoS2VtEXcJ7ej4dLEhX8xRDUdmOWGRwv6gcYLSaFOp3yYwPyn+z+xD1ijYQzBoIBgyH8jeHjhmJ+wHzm7OF49ljV5pBDkveTqX+to1SNAc2UFZEAiMMtmcJ5TaO0Kdll/25oQvLH/DnHW9hfziyfwuiTwzNA4GHl/co5x7wivGNEGB298K1KSTbiQUfzXbhCRPzuVyyaeTmPPZxivvn3WesHxp86PA8cdVsUoU2sj6EWPLR+TQzmrd6CjZE3/pohnKHl5f+dsn76lXoW48LVkvPC6rNHjJk52a3qKW0LR8PAOAJPoPU9mOtcTGnFOlKFvX3GKL9B0hOUhzybYCTJXPjRiqagnUGMAhn6DD0/M4jq5QXU+rS+dCmjpQTHtw02BDMzikF7C4KCXZqOygKKvZT1g5u4A2KXtdBlb2cpxKqBccfnL4OEOK/P8lq8XZRDX++u83PafxNUIExzwG9UDIdwmBo0A6tPu2drNvtf8Z1ChR3p04s4XuwCaJruBdZ8FU7sKG/HRsJ+YP7JksoK8cLH5EMmliyEFTi54lyDY7qEAC+GIPr+Jc5Kk7aMTxYLHhqHvSXpuJ49JUy10ddWONUf5scTdNi9/ZIG3sOtNmJ+AHPXu
 9aV5QPPo
 596UF6LL8TvAs3W0bLsg5R2plEFNwIXI5jffPPmSEk3dVaaP4scUvuwS+LPOXaLOdzbtvjQga932WtfmMKrTj7pB/ZWy17VrGlzuJ0cwkXeqUL1wU2xhWw83Yp7edYSsDo1LmkdYhoobfVuUpgTDBkmpf5FWlJjBZdHg87hRQ/yQCbqrVPRvNsVB0Xu4khoT19iHY3WtJ+cb/S7zvWVzB0WbzqPUCxCtiA1g1dloQol6nSBQmbMMym7+r8hTunchFB5usKgqjtTLo6iXcng+zKzZlT6v7EGHURQluqOYAhu7o4fMdUP12vjVJ/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/13 10:57, Christoph Hellwig wrote:
> Use filemap_fdatawrite_range instead of opencoding the logic using
> filemap_fdatawrite_wbc.  There is a slight change in the conversion
> as nr_to_write is now set to LONG_MAX instead of double the number
> of the pages in the range.  LONG_MAX is the usual nr_to_write for
> WB_SYNC_ALL writeback, and the value expected by lower layers here.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks fine to me.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/journal.c | 11 ++---------
>  1 file changed, 2 insertions(+), 9 deletions(-)
> 
> diff --git a/fs/ocfs2/journal.c b/fs/ocfs2/journal.c
> index e5f58ff2175f..85239807dec7 100644
> --- a/fs/ocfs2/journal.c
> +++ b/fs/ocfs2/journal.c
> @@ -902,15 +902,8 @@ int ocfs2_journal_alloc(struct ocfs2_super *osb)
>  
>  static int ocfs2_journal_submit_inode_data_buffers(struct jbd2_inode *jinode)
>  {
> -	struct address_space *mapping = jinode->i_vfs_inode->i_mapping;
> -	struct writeback_control wbc = {
> -		.sync_mode =  WB_SYNC_ALL,
> -		.nr_to_write = mapping->nrpages * 2,
> -		.range_start = jinode->i_dirty_start,
> -		.range_end = jinode->i_dirty_end,
> -	};
> -
> -	return filemap_fdatawrite_wbc(mapping, &wbc);
> +	return filemap_fdatawrite_range(jinode->i_vfs_inode->i_mapping,
> +			jinode->i_dirty_start, jinode->i_dirty_end);
>  }
>  
>  int ocfs2_journal_init(struct ocfs2_super *osb, int *dirty)


