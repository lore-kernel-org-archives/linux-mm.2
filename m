Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF532C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 00:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B08B6B009E; Sun,  5 Jul 2026 20:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 961056B009F; Sun,  5 Jul 2026 20:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 876AF6B00A0; Sun,  5 Jul 2026 20:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CD946B009E
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:37:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B5F2914022C
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 00:37:34 +0000 (UTC)
X-FDA: 84956488428.14.0F1E6B1
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf27.hostedemail.com (Postfix) with ESMTP id 94F4640003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 00:37:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="UJKyN/wX";
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783298253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nic156rZ5KaHtFFmLVAbbRmzxwCr/ZSy+ecuMWzZnlE=;
	b=4Ps7dyDoBPK0HYOnHIkw31ArMr92nkD+S7pHmXeN99+THU6gpwukRkuBCVSwpu0hi3zd0/
	B5sdYWgWtDfUPEP78Vqmt/2WnlSTvKfIC5CQvHdqqvjOuCisYechQTP1QXdqHINrRVhtly
	7t2U6rUnXnUgKOXSHN+BME+PI6iClZI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="UJKyN/wX";
	spf=pass (imf27.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783298253;
	b=uMZjPj4WU0Ifa/F1IlFk8fxq/J5QEq0B7c3V2oWb+3cod4SJYYQB6tQ5b6/WzKYINlVbSD
	CVQNEF4SZZSmUBnKaU9l8vWebUWHEK39LYL9JxksNS4pFfr5zkDFESSoXU2AYBfwUJBDAw
	msOG3CwYq+GhrwYLF0EilXG6MMr33yM=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1783298248; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=Nic156rZ5KaHtFFmLVAbbRmzxwCr/ZSy+ecuMWzZnlE=;
	b=UJKyN/wX/Lj8WBqIVUU37dIfoDmIfgwAAIqe8Mqd1wgZDDw2qt7Bw7R+8CkXKbrMFzc9KK9PQ3VeaYTvQoRWj2veBmJb5fTy8H4GX+t7akwYoX3XpCMR4Q3f/YM0v6ZE35bubekARajg/yDoQT/+jOc0jG14EeuxI2r0uslKkDU=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R681e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=13;SR=0;TI=SMTPD_---0X6OpAFC_1783298246;
Received: from 30.246.104.96(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X6OpAFC_1783298246 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 06 Jul 2026 08:37:27 +0800
Message-ID: <9df7e5cb-4f8f-4495-9d95-372c4b6f6fd7@linux.alibaba.com>
Date: Mon, 6 Jul 2026 08:37:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] MAINTAINERS: add Usama as a THP reviewer
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@kernel.org, ljs@kernel.org
Cc: ziy@nvidia.com, liam@infradead.org, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260702140257.44780-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260702140257.44780-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 94F4640003
X-Stat-Signature: b53hshrxuptzzscbgg8n98j6dmzgexqh
X-HE-Tag: 1783298251-21663
X-HE-Meta: U2FsdGVkX1+GHsqGY/HETWn70XsliK4r9fzHOVk07ibNpjvOepO9ClvKIQjXvt1GeqBUqXODQP8vxpSy0MFsxTGu/iIibB7azLWZSY1gW1fnxVIGs+Iy/nn5dgpFRN+tzNcSDn+Um4ugwK+Qg3fYdJXAxk6BPwz1MlVmNJWsH8lbxBkMyCnALI0Af53GdSOK1epLkxkOehYiBNzOQHaZvlxhp+UY3/K/MHQj59o1tPqmgOBMilhpl5UBGeIdewonRKMVFeVBQtB/1NAtIdFQaRpmPX9qKOkvAoHjXWzH8Zap5+TbGWwShvQ4s738+2LpTDEUFNePXqY1nTcuByAYV3gtjEZelAUte+J/Kgh4oI+FodinkJ1e8YCxY4ycZg740TknGZl3zy5wCQK20wkYf84BaGNrFwMUMb3Yff6ijVfiHV8TzGswmAGT3PtCQG862c+eMbVAO/srvQu/nXv0X8ODKP3W+Tp3oHlGRkpQLpLrYfIk44epj+ifAs7+6cqxENsqCQN6b++8SRTukyhAfHGivLtQAcjI7JJiLJ9it2LQOR6JygpPPvMx+f22Qm7CvoByBpEES4w9mKS+oUx5Ak1GhlB7uluDrRdrIdRxpjgiEG8+xDVbPD9xozsBrU+jUAXUXqWxEVa1UDB5Rll46X0I44xaNiLnD9qoP4QHot/ehWj/SNpE3DlIcyJ0JlZPEGv1bq8lptGVLm6YZzHTlt1jQvYpHbUfbftKUgMI2oDr0/cTXeEjA+ewKZhSo4ZcIAvFy22GQ6xibItBtou0y+/1Q+Thv4/ue+ny6wdSsdHsvbVKenXWTb0KLNi7qhEigTiOiZHj7AJ8zsMvn0TuCEIPaZubLmtP3I/ghyfbH61sMMzgKuqhPFVz40y7MuGdTpyKug5PJbUHg6t01VVZ+AZMdsJ7WW82XerowmpdZZMkmEfOV3LEfyUNSESm6GfI4VJExbwelbEJpsUyM5d
 uz1ECzle
 dGjiLOHJWGVCowSThxGgh5f5Em4aKGc4w8juJ8QD/aq+gbLbBsap70D8+3hbLg7SSvBSlJ9XiQYX4s1uqeLv/hC8i0pGCo7dja4ZBT4gUb+Ub5/5Hun7WV/5fsWGW/r5uwMiGooQstgLPsH2D/GvAVy2aDhR8HUqEJYDQsDYbB7WzHkSDIQ8lNZDHusWnfGp/yiLhjNCT6Mz/wa2jRg+yG1wkBgy/V1ngMd0NQW1ME+KxbSJHdrUyLwNOF1ITWvWOif/lavzF8KBlxftHn3aMUEIdP1bPxCnL7SG2bZOuoSrZDbGRwXuPGZyB9JC+SI+bhzz6I7GI0e1PbQmzTzzGqazU7EAduy3e4t7dj73dFgC1MZoTFkNZJpJiV6Yreu1yy3ZjV7hP1QGNxkXWx7zRHqVYyVOEYF1d2yQLVESij+pSHvn8WLsFyhIFIzBJQzzMcU9Pqx2fWty0RlXOcT4wnIVoTWiHqQnvDgC+oJ/1M692GQtaaYCFCinVsbrYu+7hQwfv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/2/26 10:02 PM, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> Usama has been active around THP, really enjoys working on THPs, and tries
> to review all the patches that come in.
> 
> Let's invite him to the THP party as a reviewer to help with the ongoing
> THP review load.
> 
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   MAINTAINERS | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 2acb019516eb..29c302e9c17b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17255,6 +17255,7 @@ R:	Ryan Roberts <ryan.roberts@arm.com>
>   R:	Dev Jain <dev.jain@arm.com>
>   R:	Barry Song <baohua@kernel.org>
>   R:	Lance Yang <lance.yang@linux.dev>
> +R:	Usama Arif <usama.arif@linux.dev>
>   L:	linux-mm@kvack.org
>   S:	Maintained
>   W:	http://www.linux-mm.org

Acked-by: Baolin Wang <baolin.wang@linux.alibaba.com>

