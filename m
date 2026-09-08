Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8291EC79F9E
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 01:23:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A9936B0093; Mon,  7 Sep 2026 21:23:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35A8F6B0095; Mon,  7 Sep 2026 21:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2974F6B0096; Mon,  7 Sep 2026 21:23:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0CE926B0093
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 21:23:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 99A8DA45DC
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:23:18 +0000 (UTC)
X-FDA: 85188846876.06.BFA31AD
Received: from out30-100.freemail.mail.aliyun.com (out30-100.freemail.mail.aliyun.com [115.124.30.100])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7A78D20009
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 01:23:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=q+pKMqIg;
	spf=pass (imf03.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788830597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nD7gGh4AZ10FefEACzj9jolAeDfiEc31jFoW7AJG6Vs=;
	b=CsHsi6HHopf8W6fh86UYFFEDmAXTBN7z/TOS6+2VzBAuRQfqdiSvI85NTtrEEBSA8fvjPV
	S96OD6FTNlL8d+Vi/L/6pFdQZDclz8FfOVqpRWngKSygAyCXGMBqNJ+F4veiErcCtBPIcj
	tXDHuD49HuBwSofj58E4XI9beLRhPPw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788830597;
	b=JpbCQEwqKmIKzIciYoqX04/n+zJPIGDFPFvgNJ1lZdtvtPAzPpsh0tX0w/IqFo50dc/NA+
	gyrrUsKBu17WRCoL9jkR/aKk2t+t/6OrwiHbSNTl9d594VEm5tj9K2RfDwwD5ATqc2u01H
	ZNAVWPOE/eZrRpHF5M0vDSyuiZ5kiRU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=q+pKMqIg;
	spf=pass (imf03.hostedemail.com: domain of joseph.qi@linux.alibaba.com designates 115.124.30.100 as permitted sender) smtp.mailfrom=joseph.qi@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788830592; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nD7gGh4AZ10FefEACzj9jolAeDfiEc31jFoW7AJG6Vs=;
	b=q+pKMqIg70Qlhy7VkAImsm5pLlyGNFB66RAXDL4NQ9foTi04PkAg/qFG/ZK/OppqmA9queWG1WeFiybA9Ki1oDZzRjJX0PZx7OwEoC2ZCeizP85LF0+RxPeQ1mLJU0bdyFoSI8UfFhK/1m5heDfedA2OhLuqR3UeCn28yXyu7cE=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=joseph.qi@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XAZebXf_1788830590;
Received: from 30.221.129.137(mailfrom:joseph.qi@linux.alibaba.com fp:SMTPD_---0XAZebXf_1788830590 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 08 Sep 2026 09:23:10 +0800
Message-ID: <b63bd2bd-229f-4636-9c89-8f1686ab087d@linux.alibaba.com>
Date: Tue, 8 Sep 2026 09:23:09 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: remove unnecessary ret variable in
 ocfs2_calc_xattr_init()
To: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
 Andrew Morton <akpm@linux-foundation.org>, kernel test robot
 <lkp@intel.com>, oe-kbuild-all@lists.linux.dev, ocfs2-devel@lists.linux.dev,
 linux-kernel@vger.kernel.org,
 Linux Memory Management List <linux-mm@kvack.org>
References: <202609040247.8B3lmoqX-lkp@intel.com>
 <20260907132202.48834-1-krystianmkaniewski@gmail.com>
From: Joseph Qi <joseph.qi@linux.alibaba.com>
In-Reply-To: <20260907132202.48834-1-krystianmkaniewski@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7A78D20009
X-Stat-Signature: ymkg5o1h78f7ktd158p47dqqsit9ehsa
X-HE-Tag: 1788830595-618708
X-HE-Meta: U2FsdGVkX1+kb/vTVmRIZeP12ia5T49RmiGSh8d06ahNQAwXa82CTDCrBIq9VJigw4227dke9mlTD6+PbmfLRIpXquPTA8hZfjqBn53i20tAwZLj8tQe2nKxdOHMuSCtM43rzgNf0Dx2MdaBvkj5gG2x1/8/j3X5ilDRAdUyj8qZnpZ/g8Aj0kssQdVBMamDN9TvNl6ncvhxwdzqqcGDPqjfes7wXoLDGC8dBMyPyBDXhYM118z8vGp3rBncg3cyXffwqx9k7ewMP3vZZLT5j+yraj+L0NURaPNGQ20Nrs8cQJZP+snlUQte3KsNCbjPlKU6Pyrg6dbfm7adLFUORYHofL3M+/qRRX/1yapE9Xg6O+ShBlLC/Dcy7vk+Jz7alLbYgPO+NnNnMr1gU7PAZnStYmfeXq8ViTNPU7FuTK6OLpOif12R6TREMdDsQVd/wvGll2L+QoOarTAKNnk1wiJcFVnre65zYmcPFmvd0Ix9ubmuyyJViyEI+e9BaHlQbfCgDzk0YiGpXlsFMvM6ZgtnIA0EMPiqH3tT4mWaTlEnTxUBtQVlVpuwHAo8Qiiztav4WIYXGziHOgoetVAySqR0ZhLzABaCRwANKEqtobqau2+NxAjTKcJhsCSk9z1Cqb522Txa7zC1jx+Sb1sBa/tX5ZOkrJ6xjobJkwSErjT6hIRg+l0WeiKvP00Y2heOjcw1gkxSQltwcbIQQk37JIO0+QOIX/npasEt9nrfBPRd76/SlrU+Knaa1drnUOrkuMWS9XfSX3u1NhFRpzTDOT6meVIUg7kWGiHwzIzbjZM4INvx+bFcbYeGxeReKCbrt2K7mxtMQdp6brPV0DVQ02rfMbFj8bQJCx4Wbqsxickd/2cnHpl1UzvDZxsqStdeoFmwAybyyHfmwUG6ARXLeMr9aZkQ1zOGKFQ42MklbEdXfqMTUmOb9vINzARUpY71+27R659eS798u0pPy8n
 hTNIkkXL
 H3t7K4ml5Nf5BwJz8KbRuQu8zC4Rj1yb89jxl4r8QpVGAVpeFPAcSppJZ0QWnsMRtZeRIDhL/JbqVsRFqi7ByLLpGbLr8vdGZk4O+hHIw8ZRdrDeu0PUE/iXP5Ltov8wGq+dWwMKnbYNRHCuLpxhORg3VfW0DoeBXt3IRpfV8gAN0S2Re53NnuhqlhbFC8ss52kvI4KZVmSSbKM+8rW18+rllLS1yK+otEtKkvWdKmyO6cP60cctc66k1OYhfm/hG8tWdlF1E4IHB5x8RRbFC7UYPgwNkrQ2GZymKWh/FFvSmsGz2xsiHbweg8xL9fme+9rVB9ivPr26/nSvPUNcUeIZzxlBiv+IJ1KOPVTPez8AJ0mRbyZDb8OZ2/zJIt4KyQz2Lnd2ZRcdzDEP24OGzXBlO6GEUYrxtLzb3Wkhr+73nwec=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,
This has already been addressed by:
ed57836ff300 ocfs2: make ocfs2_calc_xattr_init() return void

Thanks,
Joseph

On 9/7/26 9:22 PM, Krystian Kaniewski wrote:
> Commit bd7c05fb4a47 ("ocfs2: fix circular locking dependency in
> ocfs2_init_acl()") removed the only code that could change ret in
> ocfs2_calc_xattr_init(). The variable is now always zero, so remove it
> and return zero directly.
> 
> This fixes the reported Coccinelle warning without changing behavior.
> 
> Fixes: bd7c05fb4a47 ("ocfs2: fix circular locking dependency in ocfs2_init_acl()")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202609040247.8B3lmoqX-lkp@intel.com/
> Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
> ---
>  fs/ocfs2/xattr.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
> index 35bcbb0ff607..ab3b645983c9 100644
> --- a/fs/ocfs2/xattr.c
> +++ b/fs/ocfs2/xattr.c
> @@ -640,7 +640,6 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
>  			  int *want_clusters, int *xattr_credits,
>  			  int *want_meta, struct ocfs2_acl_state *acl_state)
>  {
> -	int ret = 0;
>  	struct ocfs2_super *osb = OCFS2_SB(dir->i_sb);
>  	int s_size = 0, a_size = 0, acl_len = 0, new_clusters;
>  
> @@ -662,7 +661,7 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
>  	}
>  
>  	if (!(s_size + a_size))
> -		return ret;
> +		return 0;
>  
>  	/*
>  	 * The max space of security xattr taken inline is
> @@ -729,7 +728,7 @@ int ocfs2_calc_xattr_init(struct inode *dir, umode_t mode,
>  		}
>  	}
>  
> -	return ret;
> +	return 0;
>  }
>  
>  static int ocfs2_xattr_extend_allocation(struct inode *inode,
> 
> base-commit: bc35965f6940a9bf834d54187b6088b8eb09206d


