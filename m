Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78D86CA0EDC
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 22:22:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C88F8E002E; Wed, 20 Aug 2025 18:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A06D8E0011; Wed, 20 Aug 2025 18:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1F558E002E; Wed, 20 Aug 2025 18:22:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DD6138E0011
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 18:22:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C96B1D9DD7
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:22:31 +0000 (UTC)
X-FDA: 83798560902.20.5D9042A
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf24.hostedemail.com (Postfix) with ESMTP id A834418000D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 22:22:29 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="eeXW/WML";
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755728550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LKna9+pTrNiSBtEO552scEDaUumI8ZqvDqHtxxkqIFM=;
	b=Nez8FQKFE46/LaiXxrfvfE7yxDPwsOtNsleHv3w5qfhZR3kb+LgK6SMc5HS+aDulXxxSRe
	UTdRc443AZDixOkTCH/9LHv1dV2BunU09OLYwgvCdJ/V7u62iSQF+i9c7F4NhdRic+qO1y
	XDo0iPiSFchK4IlDKsdW5mwA4a8RYI0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="eeXW/WML";
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755728550; a=rsa-sha256;
	cv=none;
	b=OMzb5Rts4jWvxvthqYkWvhvbwcjygkGP8yk/vCAl8faDEuBnytAY3LsflFjCNhTrqk0B0W
	TW+9RBFvo2XvKHR1/DpHXLkDr2F9LgHlRdhLdAN+/ZPrytKJiLMDDoeUzsJH+vVZztvJCy
	3l1Wx09B3giTOF3tU5y571t7Qft67pI=
Date: Wed, 20 Aug 2025 15:22:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755728547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LKna9+pTrNiSBtEO552scEDaUumI8ZqvDqHtxxkqIFM=;
	b=eeXW/WMLq4obqxrBljin+eptqDeBv8yMznDNcxfiysjlI9wnD6ctl0ywYp5rkjziOAfyQ0
	/1c4DMMJf4OXjjdefa0/hTbmG4ZUACQKWj2bxTSqKUCg5ew9NYGuUxGeUcHhwlmXYEDFNd
	KNvQa5xnWbTUZx58x+ts+rGLw7/mLes=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Klara Modin <klarasmodin@gmail.com>
Cc: Boris Burkov <boris@bur.io>, akpm@linux-foundation.org, 
	linux-btrfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, 
	kernel-team@fb.com, wqu@suse.com, willy@infradead.org, mhocko@kernel.org, 
	muchun.song@linux.dev, roman.gushchin@linux.dev, hannes@cmpxchg.org
Subject: Re: [PATCH v3 1/4] mm/filemap: add AS_UNCHARGED
Message-ID: <hdxyep67zjudwbawdyasxhe4xeu7ckua35wo7whwy3zkjaa5ie@tibviq22ndhf>
References: <cover.1755562487.git.boris@bur.io>
 <43fed53d45910cd4fa7a71d2e92913e53eb28774.1755562487.git.boris@bur.io>
 <hbdekl37pkdsvdvzgsz5prg5nlmyr67zrkqgucq3gdtepqjilh@ovc6untybhbg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hbdekl37pkdsvdvzgsz5prg5nlmyr67zrkqgucq3gdtepqjilh@ovc6untybhbg>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: A834418000D
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: o74nwrapd6pnb1963epqdkxinsu7acc1
X-HE-Tag: 1755728549-259615
X-HE-Meta: U2FsdGVkX1+Jd5oWhMVGoTQ3Iv2HYMwJXYU5LOAPbYDv4a+V2q/FXjX821OPZ5hbQNC7eOCGKdANUfAwnDkaJEGRm+xEbZKhoTECJsJ/ZbCN7w6/fw/CFRD49KFc7cZGwjb34h7xHpRYrC3SU4MqrKSTALiPvBDo5JdEllpLzsOSbrrWAb+2+hzhHYhUar/ggBBLl0UH1J0zOiiiMhFJx3BlX7Vyn6yC5RANIMs0zk36AWXWzZzG8UQ8pDtGqulu5gYkas8JQaRLFgs9pfB8B1U/yhYgOvnfIRRC0nHkNtNgxQhRP1OD7ibYhADoGtK5G45Hd70ebWAcXPNNzKHNn2p+FDerTG8KMx/K6m1fO2j/y+V8130Be7YwtepXxmlDCuSMDSB2pK1TgVzmBrqo5aJT/FEojQB0i7NDItmgL1QGiOrQ8Sbx5X/ESoZZ40Jmw6N4+J+nhlTqCQSAs2fD9uOGWhxn7NIa4/kdiYUbPZlmGellfXMRdrBzeJ7cdqKgN38jIZgs6ZiFeITNFUw8qtHY9iigoJYckbzw0qwTL7czq7bkXuqq9O4eB10L48yA48DNMzUO1vz9fFtEbZMrs6ab8VKfnQT+ww8gN8fCPqyTtEbLW/7Z77HKlpncSIThcg4mHwLR1PxTS8iEFlmLMaG7uYlsMe92kr648XOscBZXIvXnAEkRZbBxO/NUXo1F15VfkS3PQ+9EXjo987R4B8e39IF2gqlPsU9QRCZ/KcvxoGVlHwgRlO5dzzf/gSmtOaRc54FqpopuaoUNdb3BkWftd9SvHXv/pXwIoZqyvdxRQsBhjXqnmUXhFeGiSSH41dwcRTPlNYxR126+RFWuXthY2WMykqT10Jl8DFDvRie93suBTA5Oemm5UiOK8Xom+WqvcC8EWKS5PZDuTRpJZvpSpQQPBQyurM1rn2ykG9NA9Fxde3G7pdOuqzqRI4h/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 21, 2025 at 12:06:42AM +0200, Klara Modin wrote:
[...]
> 
> The following diff resolves the issue for me:
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index fae105a9cb46..c70e789201fc 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -809,7 +809,7 @@ void mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
>  
>  static inline unsigned short mem_cgroup_id(struct mem_cgroup *memcg)
>  {
> -	if (mem_cgroup_disabled())
> +	if (mem_cgroup_disabled() || !memcg)
>  		return 0;
>  
>  	return memcg->id.id;
> 
> However, it's mentioned in folio_memcg() that it can return NULL so this
> might be an existing bug which this patch just makes more obvious.
> 
> There's also workingset_eviction() which instead gets the memcg from
> lruvec. Doing that in lru_gen_eviction() also resolves the issue for me:
> 
> diff --git a/mm/workingset.c b/mm/workingset.c
> index 68a76a91111f..e805eadf0ec7 100644
> --- a/mm/workingset.c
> +++ b/mm/workingset.c
> @@ -243,6 +243,7 @@ static void *lru_gen_eviction(struct folio *folio)
>  	int tier = lru_tier_from_refs(refs, workingset);
>  	struct mem_cgroup *memcg = folio_memcg(folio);
>  	struct pglist_data *pgdat = folio_pgdat(folio);
> +	int memcgid;
>  
>  	BUILD_BUG_ON(LRU_GEN_WIDTH + LRU_REFS_WIDTH > BITS_PER_LONG - EVICTION_SHIFT);
>  
> @@ -254,7 +255,9 @@ static void *lru_gen_eviction(struct folio *folio)
>  	hist = lru_hist_from_seq(min_seq);
>  	atomic_long_add(delta, &lrugen->evicted[hist][type][tier]);
>  
> -	return pack_shadow(mem_cgroup_id(memcg), pgdat, token, workingset);
> +	memcgid = mem_cgroup_id(lruvec_memcg(lruvec));
> +
> +	return pack_shadow(memcgid, pgdat, token, workingset);
>  }
>  
>  /*
> 
> I don't really know what I'm doing here, though.

Thanks a lot for the report and I think we will prefer your second
approach which makes lru_gen_eviction() similar to
workingset_eviction(). Can you please send a formal patch and Boris can
add that patch in his series?

