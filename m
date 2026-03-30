Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08AA8FF4927
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 01:25:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AB6F6B0092; Sun, 29 Mar 2026 21:25:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35B9A6B0095; Sun, 29 Mar 2026 21:25:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22AF46B0096; Sun, 29 Mar 2026 21:25:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E3EB6B0092
	for <linux-mm@kvack.org>; Sun, 29 Mar 2026 21:25:40 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8EB3C1B8053
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 01:25:39 +0000 (UTC)
X-FDA: 84600987198.29.B9B544A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D0BA3100005
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 01:25:37 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZH7CN959;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774833938;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y6Oxj4jXwFMe7UiFMVb5EpDKjnwAJqhPqOQIPnVUfBQ=;
	b=TSZbN1c5TGu3OuJlcrxgQVu0K0VXVzDNjTo+TTitn3iLsRA/vLwU88yXMUDIbCi+6SlCtF
	c25gyhf8qDe7uVkfMOasEWxUTvcTBREVTUT7dlpDUAplKNcbVY6VhSalARwQyot8RShTVO
	ek/MKuDdFh2+Hs/wlqGuAsdWSJ9AONs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774833938; a=rsa-sha256;
	cv=none;
	b=4XSInTQEw2xH28hpfmRVk9RE5CKRYXavYmjrAEdkL6Z5oV+y/orw+FAnpQztaPsfAitLDx
	tu0Fef7NVPBoKC/PGI3Y/4j0YdHwz4d5ujEHHavsOkhMTkzBNDbvNAGJzGmvLsiMoYB8kI
	v3Zr1xNp2dzWY3JdlvhTMjkNcw2sWSo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZH7CN959;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9939F40AE3;
	Mon, 30 Mar 2026 01:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C1EAC116C6;
	Mon, 30 Mar 2026 01:25:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774833936;
	bh=QtbwGcQO/wcZZuRBp5gT6Lg9A1uakp8JwUHtWhFR+vk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZH7CN959O/UCUttT+rAmnTcDabGv8rmF4GAfRkbtFbrvozjuijYT2iEk0/traecfs
	 fcvmoZWTH3i76Zk0BhsMvPhE15pPuoYxYD2c1Dv+KJWovnXaGvtY1S7i1xczSf9Wj4
	 74OYcx7avu+hxYPudjdl8CpmH87zfbmqvH/yiJPVrYjKr6Gw3D6Nz4VDlIannkMQ6k
	 47LgN9vgRIFD69KmDo41UbqcLYCX3xObcTTY5s6ZxLiEkRc5qbcE8sSiv9nLpJP9tl
	 ieDepI/b2F/YJFbDHX3d63+yyECxW1w40L/xhfl23CJKjoehhn4NvpUYNCX/om1dNX
	 hI5rzfElOS3pQ==
Date: Mon, 30 Mar 2026 10:25:34 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, david@kernel.org, ljs@kernel.org,
	ziy@nvidia.com, yosry.ahmed@linux.dev, imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, chenridong@huaweicloud.com,
	mkoutny@suse.com, akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com,
	lance.yang@linux.dev, bhe@redhat.com, usamaarif642@gmail.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v3 2/3] mm: memcontrol: change val type to long in
 __mod_memcg_{lruvec_}state()
Message-ID: <acnRDhkGy4JXb_74@hyeyoo>
References: <cover.1774604356.git.zhengqi.arch@bytedance.com>
 <70a9440e49c464b4dca88bcabc6b491bd335c9f0.1774604356.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70a9440e49c464b4dca88bcabc6b491bd335c9f0.1774604356.git.zhengqi.arch@bytedance.com>
X-Rspamd-Queue-Id: D0BA3100005
X-Stat-Signature: tmrdnrfedst18tggecyamq9z5d3tjz4c
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774833937-633475
X-HE-Meta: U2FsdGVkX1+BitCmMDK4mI4yCjeWpzxrJgAOZsuKe1Q+xv0fMS/7qpyBaOL6RXU/vHqyQmPZKqS5odjeNUGUGZ2M7/i6p0us8W8cSvJntXuYcOwEGAAnruBeadF4ceXooWR4WypQfheX7QraFdUmpdnU1ctOOOCnX/DPl0en732/miPdWlLsfEVxksWmd1fBIaYHV3dzKvghJ3vi/GxlBcMg4UgI99KUM/cupRcDC+FI1NANgKS/0HUgTcBL3u59a2Zpl30I/VNFi6C/E6IarX4NWLesJnd9k9QnGOIkUFr/sObvfdbzsh3vEb6TL7MoT0TwBJoapHomyDB9ealvn6ctdzc4U1SBaGfhZaBYRljBAZYbVv9/D9nBCPJetnwe579vQkoddozduA+DdrgaMXz1r4qD/amFMdcw4/Fr4dzH723V4iTqfqnSt7OJ1NU0pp+4WGG3if/kbjD2bAzEKmSJRVRx4Ed8byU348D0KCeJAqXd/0kKelW1qhwZmpPF5ei6QXpvYjQXNvvREduJ4aiUeyXAEpONiaA5Qr1lILIa2+0eJAWhEJu218Ja11xg15hKFsP5quXSELpq2geQIp0dKjFTchCGuSHj76H+nb794WhmM/3keAGMoiBJfUAtqp44eI9x0ngYgj8zrqNU5AyAQ+qQuO3U+/b6gySXFE3o5eCU4Wk/LHTYYbpi+CmNYnRt9r2CmyMkOH9KXScjRVjVRLzHXsBFzkukZxuOrr1G/V+U8Oa6lyUnw+bVAldpKgnbmv/fmG1FIEsBmldZol3t/mjhyJ2k3FMjrIkwnVPGoLnrOEEOuAQJyPegAm2psP24OBtpHqoJSCY4uj/qZ/3N3jiuyd8428PbLCufgYxCnZgt4GK2iCj7Sp5ejJK4No+iTaNsTEXpCC3xxN3cu+vrPCQQKqYf3l76ng8/xQ44eMoHILcfte2d97eMPOZsuER7S0NlkpcLhwUlxR1
 H6+YXSgX
 v4cSud8hN+e6BUu8a5sSEgve22LjirriB0InKBkiKc+apj3stQaKU/e1QFO55gXb8YCKp8MYZwDrnMFz6jz8C35oXafQjxPKWGnrhws6VxvwiIUirlCYm15eG9gyqk6YsYQF306HNRc9AuL1Yzs1+XNSDzgb5IORL4INVRuHnNqhb34hE52cHjFZswxzc3UVVFPqsyVBF9PVsL8RTy2CLlHh+VHtLOKJauvOg5LudTYJWEaOtcbmFuF6eZrgFojJOzm3m7LZ5g2UdX2xZyOjiWiUGs6U4oxEoS/9g+P6q7pmaY6W780nIR5uQcrFCoaKxZd5Xr7vX19Xj2vND72j8H7ItqaDzVbA5KNO3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 27, 2026 at 06:16:29PM +0800, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> The __mod_memcg_state() and __mod_memcg_lruvec_state() functions are also
> used to reparent non-hierarchical stats. In this scenario, the values
> passed to them are accumulated statistics that might be extremely large
> and exceed the upper limit of a 32-bit integer.
> 
> Change the val parameter type from int to long in these functions and
> their corresponding tracepoints (memcg_rstat_stats) to prevent potential
> overflow issues.
> 
> After that, in memcg_state_val_in_pages(), if the passed val is negative,
> the expression val * unit / PAGE_SIZE could be implicitly converted to a
> massive positive number when compared with 1UL in the max() macro.
> This leads to returning an incorrect massive positive value.
> 
> Fix this by using abs(val) to calculate the magnitude first, and then
> restoring the sign of the value before returning the result. Additionally,
> use mult_frac() to prevent potential overflow during the multiplication of
> val and unit.
> 
> Reported-by: Harry Yoo (Oracle) <harry@kernel.org>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>

> @@ -831,7 +837,7 @@ static inline void get_non_dying_memcg_end(void)
>  #endif
>  
>  static void __mod_memcg_state(struct mem_cgroup *memcg,
> -			      enum memcg_stat_item idx, int val)
> +			      enum memcg_stat_item idx, long val)
>  {
>  	int i = memcg_stats_index(idx);
>  	int cpu;
> @@ -896,7 +902,7 @@ void reparent_memcg_state_local(struct mem_cgroup *memcg,
>  #endif
>  
>  static void __mod_memcg_lruvec_state(struct mem_cgroup_per_node *pn,
> -				     enum node_stat_item idx, int val)
> +				     enum node_stat_item idx, long val)
>  {
>  	struct mem_cgroup *memcg = pn->memcg;
>  	int i = memcg_stats_index(idx);

Some of code paths that calls mod_memcg{,_lruvec}_state still passes
int values (which is quite subtle to notice), but it should be fine
as reparenting is not involved in the path and could be cleaned up later.

-- 
Cheers,
Harry / Hyeonggon

