Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FC34D711CC
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 02:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBE746B0088; Thu, 18 Dec 2025 21:14:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9F986B0089; Thu, 18 Dec 2025 21:14:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD6716B008A; Thu, 18 Dec 2025 21:14:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CEA766B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:14:40 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 80AA713AC98
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:14:40 +0000 (UTC)
X-FDA: 84234601920.27.EB8E359
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id C64BB80008
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 02:14:38 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xpVzXD1G;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766110479; a=rsa-sha256;
	cv=none;
	b=1XNo7fj5GzJiFu381K34ogL3S2CxCL9HBiKm7btORy4xSugijDNoBnnSymBIw6UitGSXdh
	DIgiM94n/OUN+gEevPxVJtUCO404oshXY79K7rIN3hnwTGZ6gjgP7ZSUocNLbSD63i/Aa8
	durQAzS5nTs9YbvEMvWfLpBZqnur66I=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xpVzXD1G;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766110479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MaSewMPFpzgfIXddZ9UUgGWOgyUZdsrAm8yw6vZO0OI=;
	b=t0xfoiCNLtOywvzGNKuTmzpryQ4mo3ttU1UeJTBiMNy56I8QPtyZEr37M8n1vvjSW7/Idf
	BZ5H6mJwpWDl20GXq/kaaJA7URrwgRxGrLNC2CA2pouseC2U3eUNugy+ot669IKkrf0KuN
	bOFr5/pp/eVqExFiX3fiLW+6uDZ23JU=
Date: Thu, 18 Dec 2025 18:14:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766110471;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MaSewMPFpzgfIXddZ9UUgGWOgyUZdsrAm8yw6vZO0OI=;
	b=xpVzXD1Ggi7BKe0yZG+mdTj4GPIZQ2eHcL7soEZ+iQNUDl98A6C+S/UO2f1bu+vuOaar4U
	cEF9ZqPXFHMK2W82Pi+fh3vSIuvYY7k98cXwXJ/EPszhGhxYWKVAxL8dhHpzejl/rWb/qM
	NiQez3/6p932qHFBJnWFWFfE7Q7rD2I=
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
Subject: Re: [PATCH v2 09/28] buffer: prevent memory cgroup release in
 folio_alloc_buffers()
Message-ID: <63h3n6m5ek623nzq4pwkwkhu72jqjjastxgnsjuvrvwpevv57v@2ki32ihzx7lj>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <bd87d13b99c159de77f23f61c932724a8b2d000b.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd87d13b99c159de77f23f61c932724a8b2d000b.1765956025.git.zhengqi.arch@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: C64BB80008
X-Rspamd-Server: rspam10
X-Stat-Signature: 4tzyzkdi47jphqt4m9hyynb768d8md9h
X-HE-Tag: 1766110478-492967
X-HE-Meta: U2FsdGVkX19QX0FfHfC0bCiZNR0TfwwzmB685L8UTy9V7zYd8Wx68ZSDK4l4VgP6iDmMxlINL5N+3PFDj3WMbqLmTDxV+ZdmePfrMEhyKYcH0jlRm+Lw0je9C+gClbacp5uBhFYj+oiaZK7HLmjBsBbNP8Pn9ck4SWsa+SOxvUasQo+Oa0OQK/gp0J7QDVKysdb6OJH+GxWTpWRUKpWFK+Wvgfg6RzzP9gxh+j5xhFBCFGw6PYfaPU/dQznOsx9OcMhaY99oj8QOdYv3YWEuqEshSc2LTMdgROgWxFf4p59iiLiOmwS02XsS0hrGdcsK6yvcFmxHVw0bTmKowcCxhj+8ktUF46DfY/4cwtY/LLclMPi/8rfVMoNHKBE5ttThV5BTrXuxllMyeAGAF2e00vGVcy+KgVWoiQz1h7GOZW1PFrtx1YuIO0GRnurZU0Bkh3hub/rrXMZ5TLWwYMTk+5GYuryheMq38nrzj+4ObWZtexmzuHwq0OmMrgPhvtGPGEq13Z0zp52f+W93VsO2NdxKeP635fY+QYvmNeksqACmcpKvZ6r37ow7DHuKxOvHVPtG7dcJkQz3fPFibH3WzB7FVtupZhrqEEahOPBYRYlgZzVt+PnuAwq2+Kjwan8emXcK45297VC5OBVJTMBfRBhI1VKRsPgashkJi7KciOp8JwjyliUH/N21TlPpQeyWlB3/NOI1jyZYrCENOnmh4KqQ0PUUttT+Hfcee5topUITh6AY/1KXtH/GQFDaMfCZbWHO2MXFtES3AWNtFg23wsUBWsgewi7FFaTnLlz4S8OdNFuPKCdJeUZygaT8XzdwmTzURw31G+paMwgD4JeyZORSDf5ksendVPOMja4hJbj6kv1ijdCLhidCe/HGpOTu7rXnQ02I4SDhssRuMlL16TsI9ES7vQuiFw6VHvziwXo/gE6YgKeRPL8eO4E6Keb3FEx7Nzk4sS3X1BMu2rf
 AL2FDOu4
 Ao6cZLqoMBf54PBzkIaNeNmaoiixfVhiUypqAmYAxXrcsqYOR+gqdHpWQ/AWIj1ktacGUt+zloDxlu1Cawq24moxaQGhR5I4NRYKoxGYv+6vrwIls8VROujsIPe1eDphz1dBG+OP2sc2Ffs+oxHMmWDtP7tvwFZFS1nXwIUH5tjNimP/SqtbwlIFTp+x3eebQY0EKK3unOqIZc49Y0h1/Jz/DiVWazw0YW7zxDCNERADzTqGiq1J+TY/BiLF29uqud+5kpCnuP5F22+1AkwBfq7SUfIYXPl+nXUcIf7Q17HG8QS7Ehm5yqVsRVt9MYXEnSFnrlcFhk27vy9k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:33PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the function get_mem_cgroup_from_folio() is
> employed to safeguard against the release of the memory cgroup.
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

