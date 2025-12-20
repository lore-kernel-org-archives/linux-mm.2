Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBF1BE668A7
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 02:04:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C02446B0088; Fri, 19 Dec 2025 21:04:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B85926B0089; Fri, 19 Dec 2025 21:04:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A87866B008A; Fri, 19 Dec 2025 21:04:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 96ECC6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:04:35 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2BC0B140404
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 02:04:35 +0000 (UTC)
X-FDA: 84238205310.03.AC77CAC
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7F59940003
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 02:04:33 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FzkZzase;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766196273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N4z3e0bMA9k9deirHaNPAvvnsA5OuUkwcK91JbFfwpc=;
	b=P9rWVntTcN0B6PYl0rwPyFMC2pNHFpUA+slt6dNf83c6uHmpYOW855Q9C1q9UMNVLOxR3S
	BKjQIwozBIEFeePfZ1kngr1iG9UJnNycokbMsFmnZcVsVxZKl0UohEXLX6TRQ5S7NhSe77
	+LQ1SQHFLUqMGS9c7Z/tfSvBUyjmU4c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FzkZzase;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766196273; a=rsa-sha256;
	cv=none;
	b=03sbvaL3RlX4eOM13ybiVLVyRViwxkoATjCdY/lwwphNqEGw6bKHlvhzc5JgirHTd/co3e
	AIyQHPNauhWqTt3o6Fdw6EzZcTtrGwFxIKJmsBK/EhjfQ/LsI2oXYrs2UAMCqnbR36WU1r
	ATzQKtqOGA+IPXygR7hnt2unPTk0OzU=
Date: Fri, 19 Dec 2025 18:03:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766196268;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=N4z3e0bMA9k9deirHaNPAvvnsA5OuUkwcK91JbFfwpc=;
	b=FzkZzaseKGxfs1admxWGs8Tw5MD2Zik2GFK+WRLk0SaeNE+Do4YVYZiSbSbS8d9l2TtmzY
	6t7FL/bp9ejebxXX/25JP/sPbM1T3OZOJHr2RJp25aSJ5H4ptlAA2IsynX88SUpke7JNDJ
	O2DIS42mMfMacM6Q25supFEbQMqlx10=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, imran.f.khan@oracle.com, 
	kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 23/28] mm: memcontrol: prepare for reparenting LRU
 pages for lruvec lock
Message-ID: <jdhf6h7weedyentvyaqsr3n3v7dlj4n6k3mrryn2hkyhc255cl@kmexszfblh6s>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <6d643ea41dd89134eb3c7af96f5bfb3531da7aa7.1765956026.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d643ea41dd89134eb3c7af96f5bfb3531da7aa7.1765956026.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7F59940003
X-Stat-Signature: 9mxcr93gp3h7bon1rf8m3yoids3ojefm
X-HE-Tag: 1766196273-167257
X-HE-Meta: U2FsdGVkX18AtI2ovh4JjuOa6M2BRgmHA62og4SqFySgWozYie2xGcIpluaqjCAy40AixN3Eh0k8XDuuJwXfVOqE9LBltukT7F422sEcgzEW64bobqB4ykulebWurZPWT8rXJGR3ggKP1SRz3P1WNGQ8MuQWH+bo176xYm5geXgz1oPHxLvpfPnv050z5CqHlbZCVFpSVUSLQ+YOHpn51QvEHGiDSTA4tObdqmWRab/ILCAiKcv2UmCnDpU/94dUd08IjPqXI3b26QtapVmZfC7O+nG5aaMEOW7FU9tcBmqyHcW1kmtYqCKF6wQKXN2TtiziN8c13neK/U/vFaDAPME7xpxCce3i81j36Scz595bYLRPSBRNrBIuWI855V+m9z9F8Uki1Xk5m7qYXLxtXPQJxUuoqBqz0Lw+dWtcgu7/bZaKJ1QRD1nnhS64qAD9LEi6D8rYx+yt8vogmAfcgtdnyGQ88Gx9Kfk7zojQI/iDJlkfYftRxpHw0DGouWwXL7sKAXSsvs1YvBvfsqcZBldWj6UZtM/F0Jqhf9snXvR7Ol2UjtM6hxgxjkYpsLCowIMSlIG3Cc+MW8GnMY0Vm76eq1bg1etx+StPffkNY93G/uesQXHSr+kJSKd1lbA8MTlRYjkmACgFUQ7Nq1JiwWEm5dfDzPljTnaDjEIzmmcWBFCddqd+fHm55B9TvpBWsqmLT8ZEGrtvwjnezTyhb8RFc8HY368JMTQT4A7/jTdNo82YJR1MqzAkqy9LxKOe7qgsW4z1PRk7eqETjWCw/b25qgwfeMKtqIDbwNcB3GYx/W+y31iNSz22+a4yOlvxtQeifNFmyOIneAfpp9xMiEcLxY9hL0/vvJeqNp46B8++TIfzNB4vqQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:47PM +0800, Qi Zheng wrote:
> @@ -1232,14 +1221,20 @@ struct lruvec *folio_lruvec_lock(struct folio *folio)
>   * - folio frozen (refcount of 0)
>   *
>   * Return: The lruvec this folio is on with its lock held and interrupts
> - * disabled.
> + * disabled and rcu read lock held.
>   */
>  struct lruvec *folio_lruvec_lock_irq(struct folio *folio)
>  {
> -	struct lruvec *lruvec = folio_lruvec(folio);
> +	struct lruvec *lruvec;
>  
> +	rcu_read_lock();
> +retry:
> +	lruvec = folio_lruvec(folio);
>  	spin_lock_irq(&lruvec->lru_lock);
> -	lruvec_memcg_debug(lruvec, folio);
> +	if (unlikely(lruvec_memcg(lruvec) != folio_memcg(folio))) {
> +		spin_unlock_irq(&lruvec->lru_lock);
> +		goto retry;
> +	}

So after this patch, all folio_lruvec_lock_irq() calls should be paired
with lruvec_unlock_irq() but lru_note_cost_refault() is calling
folio_lruvec_lock_irq() without the paired lruvec_unlock_irq(). It is
using lru_note_cost_unlock_irq() for unlocking lru lock and thus rcu
read unlock is missed.

Beside fixing this, I would suggest to add __acquire()/__release() tags
for both lru lock and rcu for all these functions.


