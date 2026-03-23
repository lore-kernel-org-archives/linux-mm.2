Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B3AAEC01C9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 800216B0093; Mon, 23 Mar 2026 06:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7656B0095; Mon, 23 Mar 2026 06:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69F686B0096; Mon, 23 Mar 2026 06:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5781F6B0093
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:46:24 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF2681EC1A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:46:23 +0000 (UTC)
X-FDA: 84576998646.27.9EC54C7
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf24.hostedemail.com (Postfix) with ESMTP id C6199180006;
	Mon, 23 Mar 2026 10:46:19 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Tv6B3eRk;
	spf=pass (imf24.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774262782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iQ6mAQdlt6rOthd/wT56xFxrcrGf+UGd+c4429Y/xYM=;
	b=hjZEjGqaz3AHCi/5eTyqSEztN2fcRwoOmD526Hknnxednbk0/E2twiagyBzfgzM4jXZdZy
	AO9qiKf0A7Wp8fMVIG/JaAlq4OMsOPuLJuBnQHXHBwIMGnhE3wlwzXIk3hQyhHIogedz0p
	Z/MTIoLzNi0rIlDvh2Hj+9xZu0EzMKQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774262782; a=rsa-sha256;
	cv=none;
	b=XUFR8oGOp8J5iye1Bzz8rMICu+uap3Pu2T/A4/rwGt9/6aBp8KI9s31I9kC3xdghRQKqtB
	1B6vRH7K48ri9bfGDEvwX9a/o6n+SPrRTi2Z/jPfraPo7AdSeww/yPzucdSchK+gi2alvv
	DMZwc8JfyDABmLEagSvt/RBsQnl/hXQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=Tv6B3eRk;
	spf=pass (imf24.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1774262775; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=iQ6mAQdlt6rOthd/wT56xFxrcrGf+UGd+c4429Y/xYM=;
	b=Tv6B3eRkCpXLOJCtaN79deX5c91AnqJ4uF/YIu2hwwcyAF3SFEmOjdoUF3bm1JwJBgRVkp6EBeqixfO/vJXEBkJt3JvEVWkCMOGZI4Ze5CBjQVgsvGvRWkGiKSeqJvk2GwRQO+pVsmJGAIAV81ZucuUImVQX9T2E0L9diap8ajg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=18;SR=0;TI=SMTPD_---0X.WQK-Y_1774262772;
Received: from 30.221.129.170(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0X.WQK-Y_1774262772 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 23 Mar 2026 18:46:13 +0800
Message-ID: <abaf00ff-3374-44de-81b9-6f806c370227@linux.alibaba.com>
Date: Mon, 23 Mar 2026 18:46:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 04/41] ocfs2: Drop pointless sync_mapping_buffers() calls
To: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org
Cc: linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
 Al Viro <viro@ZenIV.linux.org.uk>, linux-ext4@vger.kernel.org,
 Ted Tso <tytso@mit.edu>, "Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
 David Sterba <dsterba@suse.com>, OGAWA Hirofumi
 <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 linux-mm@kvack.org, linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>,
 Joel Becker <jlbec@evilplan.org>, ocfs2-devel@lists.linux.dev
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-45-jack@suse.cz>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260320134100.20731-45-jack@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C6199180006
X-Stat-Signature: jqi4z6e3d1du9btueoq8zfdt4czn5dqa
X-Rspam-User: 
X-HE-Tag: 1774262779-8513
X-HE-Meta: U2FsdGVkX1/qflEgiw8lEX5kYTqNLiL3vGjpZ6zen1rRakKARW2mxpXaNVt9lJnV+NGL73HaiOW/uVbdVGG6Li6JP+5uVo+/yVlMKNYsmyJJhM9a9sUr5ejqRUGeI4svoSbZAR9jXtphT7kDvgE5m+9372lWewr09ch5Ualyhl56zewIezTokVafkbBGJKXKBuBmYJmtwY5yjjXfSEutjDY2C8kWF2RDWiaoC1NnWP+oec0NKT/YtAwYIWZqu2N4F2AK1AjRBl7EijNLq9AQFTM3xEaEGDFA6t9ZogvRNPfDme1mwPgraDSNnJVQaVyUADiJCt87N9UDVgEh4e7yGxta9CmPG2CzrIj7I4sPgJJKscYmr968U4TqoQur2VBBhoDnzHntZyKoZP+Qqu2YvVRnGZi94jGsa/gdsOWwlB4XfB+9ELiBUmn8//Po9m3ziSZC+znEqo1m//XWcmglKIi3eayZzvqPb/4gVb5SxWK1LYrb6/FL/4IOvNbTSd3mCoiw/BwoookZ9HTBU68eLNTLgsyRpgt7NZD5TVFqjQukiR6YoL4HLCDosa2UtQ1qvVu5emXPkFLjXOlJC4sERPwsed5B8LzunGxKyiMiG7/kOO87qfPMTHZbylJhZCdTpEpOTuqjCghIP9cdqd8BNK/Uh2YiGONphXK+8y4RPdgFeKHv3IKa/E83EGssXHLTxNIAR+JEtRNza1OLdrmICU27xa/P5Urmxt5Ac+HsWqGQbYEEXn93rGgVkLohT9vn8pjdMO7m3y8AgFtiqhZ0q0zuurqGedW1e4JrgTP2KljM8kWNOQMrP3hiDR7mHPd/I+ITfed2Pu6FQqig/n55DvAVHshEeWTKo3nHw3PldRF9Lv2cSIHbFAuv0ku/kyPoTR4g5he0k8H1V8TRgf4XYb06sXpV5eVzm4mxM2B6otIlt8VTIfIoFbRA2mfyfoXcrlVfABm8zljgsIAGcof
 V42t2Rly
 xvw9wKeCTbKyjhAWd+A4UzWtpPQb/m6ktF2U52pdy4+iyvgouc9UN2Kl7g9KpHGFr0V2Ct2lp81A3nyh4xCzWsC4X0/4x/EQ5nhIUTj/jpw6MGwoDwF/8E+axdyT9qstleo10eWQr+tHEP4jPt/buqhW4/QQb2AO5EY918piUMvq+/5OHyJJxyJ/eb04jMjYxkDfpwAeJQRwNT43lq1JsumOG8EmheAOnoM6lKKOw1u83jVJdqlbpqjNCnRPZfvIBmLMHVP97mdjuUfkIITavBeDnx0+p6p9p/3INphwEbpOeZ9lmBEcY7I13zj1tXzrQx88GreKR75C/vefk5MVHHQ04aFM/YqWu7CEHxf2xgtsjmcx2tCvpne7LnqM+pCtu6H84aK4spfGJnJvvN3EzTfL6ulwB0qt+e2Ck9mnAGQTE2xB36CkkiwqvzvhiQElcN5lzmjy/EQFKPfp1rtkfWhOYikL0yzVkyfgZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/20/26 9:40 PM, Jan Kara wrote:
> ocfs2 never calls mark_buffer_dirty_inode() and thus its metadata
> buffers list is always empty. Drop the pointless sync_mapping_buffers()
> calls.
> 
> CC: Joel Becker <jlbec@evilplan.org>
> CC: Joseph Qi <joseph.qi@linux.alibaba.com>
> CC: ocfs2-devel@lists.linux.dev
> Signed-off-by: Jan Kara <jack@suse.cz>

Looks fine.
Reviewed-by: Joseph Qi <joseph.qi@linux.alibaba.com>

> ---
>  fs/ocfs2/dlmglue.c | 1 -
>  fs/ocfs2/namei.c   | 3 ---
>  2 files changed, 4 deletions(-)
> 
> diff --git a/fs/ocfs2/dlmglue.c b/fs/ocfs2/dlmglue.c
> index bd2ddb7d841d..7283bb2c5a31 100644
> --- a/fs/ocfs2/dlmglue.c
> +++ b/fs/ocfs2/dlmglue.c
> @@ -3971,7 +3971,6 @@ static int ocfs2_data_convert_worker(struct ocfs2_lock_res *lockres,
>  		mlog(ML_ERROR, "Could not sync inode %llu for downconvert!",
>  		     (unsigned long long)OCFS2_I(inode)->ip_blkno);
>  	}
> -	sync_mapping_buffers(mapping);
>  	if (blocking == DLM_LOCK_EX) {
>  		truncate_inode_pages(mapping, 0);
>  	} else {
> diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
> index 268b79339a51..1277666c77cd 100644
> --- a/fs/ocfs2/namei.c
> +++ b/fs/ocfs2/namei.c
> @@ -1683,9 +1683,6 @@ static int ocfs2_rename(struct mnt_idmap *idmap,
>  	if (rename_lock)
>  		ocfs2_rename_unlock(osb);
>  
> -	if (new_inode)
> -		sync_mapping_buffers(old_inode->i_mapping);
> -
>  	iput(new_inode);
>  
>  	ocfs2_free_dir_lookup_result(&target_lookup_res);


