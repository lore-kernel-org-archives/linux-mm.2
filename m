Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D345ED68BC5
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 21:45:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F00E16B0005; Wed, 17 Dec 2025 16:45:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E847E6B0089; Wed, 17 Dec 2025 16:45:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D65F86B008A; Wed, 17 Dec 2025 16:45:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C1B326B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 16:45:14 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E156160C04
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 21:45:14 +0000 (UTC)
X-FDA: 84230294148.12.96BD901
Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	by imf13.hostedemail.com (Postfix) with ESMTP id 546A420004
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 21:45:12 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=owoqgNxe;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766007912;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cCQw+7EYcHrhI0VW083rNx16bRSH0hX/loU89idlDA8=;
	b=meSOwZqrQ6/800G4BnqOHJsA+jO/ZCsl1YqxUYzqom97t7YYh0S+gZIuVmmTUWEKnzA2yR
	4x6Ptb46fyIEU5Kqq7Sq4GNBaAJ2TyD1+RfWZ6e9aJttGMLAjn78ljVtDQmpGotUulEZ7x
	ftCWMZXP9gy/vnSuUAZLXU+LCFByDhA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766007912; a=rsa-sha256;
	cv=none;
	b=x8CJVeVzqsqavZVgoU5vc1vSojr2Ih8q/OJjpih/k2hzI6lFjuvrBCi9fubMuvN18yYf3m
	esS06GQUV67OxBdvYoyRYqV13YWGKqrJ4K9jA36lkdFEMdC7LEhQWYTdFO34HPm+NfnOH5
	ricUT4DCOJtx3ROEX3cVx1X0qvtCEMI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=owoqgNxe;
	spf=pass (imf13.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8b22b1d3e7fso643902085a.3
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 13:45:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1766007911; x=1766612711; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cCQw+7EYcHrhI0VW083rNx16bRSH0hX/loU89idlDA8=;
        b=owoqgNxeYoxJsPBSAjX6+53dSmwWJmWBDcYJR0qawdv4h0qumycTE/MF20hQ+ZXV3U
         Rv0pXgicYjUiXOHhbyBwSeoZ3VRJM0/duiorrcAXX5llRD5xwkJE+A3c1bBKuWf3UKPC
         doBNOHU1ec9xvKYogaR330iKI8tlRQ/rONeN/qRHViSkLvHl67BupKY10ojJHz7MXNFX
         4Rkloo4WOdkmFJznbewLPvixa0yChthBQRB/wSH7usryY9x/5tMZ/1W/O773+mxI/LTQ
         pRnAoI1mnWHA5JET6g22NQqL+MmqvbYjA14Zb++cFdEW+L3nSGOjIOxEYonrKhg08SSm
         HucA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766007911; x=1766612711;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cCQw+7EYcHrhI0VW083rNx16bRSH0hX/loU89idlDA8=;
        b=t7afW1pOB/ND1qOLEBQE4fwiCHALwmwXS7sZ1Jiaxz6q7zJTD7wH4u4rBGSVSF/QCV
         6mxPXw6ihQR+xJR+V7A3rMSZLzTZSAaR7kK5zCFwoGvEqatipNO6DLm6nahNe/vTnxdd
         HB2jECw1der+/IUZGWL1HQUwoKB5rehdXP7frXrLsM6xEh75ElxeAk82ZMxAXDRS1cpO
         e5aDBRrqDli2fS0Rg0Qve7q9eIlqQR7S8ah3hz6cBMsKxs9+TsQZJDOdh8pE0uFW9i/e
         69iSLG2SdVZa9kngQQ1e3UCXmFtHWR64ufDheg3N6SFo1wqq+gjdc8t0WgnPUhsMgVU0
         CKFg==
X-Forwarded-Encrypted: i=1; AJvYcCULL2bRobtptAXtQd8OcsqieHH7ICRnu7cTIquCvAV+rLVtEoaR0Z1MEJu5ABn7LW6hEsAY3g68hw==@kvack.org
X-Gm-Message-State: AOJu0YxlUw7jW2Cvzgv/TGs9XMMLG802WnkMUGkTjl+otiPi30ALxEnv
	4i1HBD4ujAYHIhRuhqroiEG0eUoXybYr/cyqA0aH8IUdw+t7fO4VTSe7q7btR/2xvus=
X-Gm-Gg: AY/fxX4/ITaNqA9kWMeXo7GkxSVVDNJgG9C7ii7LtEoWC30X7ln5qF/YdNpyiwNmc+c
	DM86udAduF2STF+/XtWMRK74FXvFf8dD8CEuX/i+gZe/P/fikuyeYX67L/EOEjO04a6QdYRwuWU
	ei+u4RgVopYg3tyYcRr1jHHf02IXIGMNENsIGpaVOcsrKyiF7pS5JO6wL81nrQNtVPjn2R6SBGE
	OJAeTbeFWQ2fMXr5PcT7D3SPoWtkY+BRGpCtSZuldRF8VnAQkyng9qLL74VpSdZivMyyp1hLLbm
	cLOysRA/VdXMG12C0GXi1be2rjR8nfXZ8YNEl8nRU1r8iK9RSJ3GC7Z8Lr0Soy8fFr3UYO0N9W+
	h3PbRWiZlq9C1AefiHNmPfvb6lCsLL1rRtzx2mExkZQPuJ5F2qAiCDaa8R254MbLOR/xF6+G9z6
	S7KozVNGfD+w==
X-Google-Smtp-Source: AGHT+IE7IeAzYEmDHvM2P4dl1qsqF97yDx6kfts+1/gZKkwJR3IpfyAacSXi+sv6340TQRr4kVA0Gw==
X-Received: by 2002:a05:620a:198a:b0:8b2:7679:4d2d with SMTP id af79cd13be357-8bb3a388998mr2861684185a.63.1766007911186;
        Wed, 17 Dec 2025 13:45:11 -0800 (PST)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8beeba2bca5sm31763985a.27.2025.12.17.13.45.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 13:45:10 -0800 (PST)
Date: Wed, 17 Dec 2025 16:45:06 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev, david@kernel.org,
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chenridong@huaweicloud.com, mkoutny@suse.com,
	akpm@linux-foundation.org, hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v2 08/28] mm: memcontrol: prevent memory cgroup release
 in get_mem_cgroup_from_folio()
Message-ID: <aUMkYlK1KhtD5ky6@cmpxchg.org>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
 <29e5c116de15e55be082a544e3f24d8ddb6b3476.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29e5c116de15e55be082a544e3f24d8ddb6b3476.1765956025.git.zhengqi.arch@bytedance.com>
X-Stat-Signature: egzbexmchgrrpw7rxc93ypre6mei5qrm
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 546A420004
X-Rspam-User: 
X-HE-Tag: 1766007912-16156
X-HE-Meta: U2FsdGVkX19BZ13lnOF5IPYLqz0vItF/lIODowz4YBet1qnlNPBGnHR7R1v7u7FvZmeyp9tcrWKIKd1wowI5JYuSHJvdwXZyAwl+zxnqHMnLKFnIMXLirR2UTTiOnV1NHcng1iA2VTqZLvUQqho4+PXoBWfAHCF/CxwMHzFPwzkiogfG7KH9epqBLOoa2PoarVdaOD+QCzZ1kAGGxfqYefo9FtFLCL7X9+giTtIcVn/s24SwC50Mnw/o7G4eqb5R+/31jAagU5R7EgdvD9+y3gmIeVasHf0Pvoms0J3g15hC/Fb6Xwzjn4RGPeTrl012a5g8Yw4bSx/98oFMeQ2+y2DZJzwUh9hlKCk5zOcKAIzH+AjBGkicHfJZOgvOf5Z31U2Tw+T3YrppwtJRP2JxZ+8/IMpgZbXeOLiciK9kSxwBFjkI8zxYzEY/cWKXIRZzF4K22EP4mUJg07hj/nvfN1bW9nqukr2oCeFLlcRAaurSsXukInAuXJ2cKkfEX53fGQF9Bc7fqfO6EekHdLIupGgU4GvW9nYrI8gRRKKz57kAvWg1UcdC9e8W47526+Aidoq2buME857Wsc4EMtmAbLMcqJ8DsCmwnGDB0dl9VCJZjn+XV7oM/Yi96gb9GewfqV8DyP/Uo3d4V65ikmrjrQBqsAXW4ddePZ9WtJv7OtsatAcFOHIliJMmL1UcDO+NTys3tt0HsGG0od5StML24oT9i4ZETQ/RRkKwdM338Kouwflt0Aajk4tjpi0ImztiSHw0MS0orLbXNiazEozr0qwMWW7vJWZ8cjPoIBli8rmcmhibUg7fX7Wh2ZA1piJEscUyKDz3gq4blQZB1CZzLLtSsvWqtJOBpjyY4/zm06GPutZFwCYh7dAffe9zY5jmFhASr5IYegyJ9wtAWIr0GIVWxQyZieApBh4TN4/sw28TJ0B3/S3wkhcPgYKr6jax7Ic0cvZ91QovOqGQdd6
 Qh66F/hE
 O5xdF8nIxEZhenR7EA+QomNpVLae3adbRfweX0u3YogSUCD45eO76GU16QMYeWOWHWzPNnxCF33Gr84Ex2DtAjgxOw7p+ckvKWHbpw49f0o5jFzrQxD0DrSfjDQysuQzVbXRy95cVTcbxIIa+E0AVQzX15SLMSD56gokt1LH3PODD2omVlKsKt7sq6bZ8kmQK5lZL/RLMBOAD6ii9J7KX9mToVvMgM90YQctAY3yv2A94AmLK3NaJNxlc1SDRhUHfN1+YJtIkUQjSD3URiEUXsM/UjSuHZoOS00e+GFvCjYC+lY7g5VMOwrywUsAYTJfL9LpOL1dNT/jRCVdxU5Ca0JhEgvRKQj4YZFB9OPAdUSf/XzAN57D8G5Vg3aJlnzXkZkfK34wb63ymEAB4JH9MBO9QjZC9LPnAZzZsZOUZ7SzPU/tPtDajFhvC/KhokBSDLufxQsqp0lZs6icAZFBOniTLpm+YFD2ISbkEFg7KZcTfVcc6PdTHdYsb9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:27:32PM +0800, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> In the near future, a folio will no longer pin its corresponding
> memory cgroup. To ensure safety, it will only be appropriate to
> hold the rcu read lock or acquire a reference to the memory cgroup
> returned by folio_memcg(), thereby preventing it from being released.
> 
> In the current patch, the rcu read lock is employed to safeguard
> against the release of the memory cgroup in get_mem_cgroup_from_folio().
> 
> This serves as a preparatory measure for the reparenting of the
> LRU pages.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>  mm/memcontrol.c | 11 ++++++++---
>  1 file changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 21b5aad34cae7..431b3154c70c5 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -973,14 +973,19 @@ struct mem_cgroup *get_mem_cgroup_from_current(void)
>   */
>  struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
>  {
> -	struct mem_cgroup *memcg = folio_memcg(folio);
> +	struct mem_cgroup *memcg;
>  
>  	if (mem_cgroup_disabled())
>  		return NULL;
>  
> +	if (!folio_memcg_charged(folio))
> +		return root_mem_cgroup;
> +
>  	rcu_read_lock();
> -	if (!memcg || WARN_ON_ONCE(!css_tryget(&memcg->css)))
> -		memcg = root_mem_cgroup;
> +retry:
> +	memcg = folio_memcg(folio);
> +	if (unlikely(!css_tryget(&memcg->css)))
> +		goto retry;

So starting in patch 27, the tryget can fail if the memcg is offlined,
and the folio's objcg is reparented concurrently. We'll retry until we
find a memcg that isn't dead yet. There's always root_mem_cgroup.

It makes sense, but a loop like this begs the question of how it is
bounded. I pieced it together looking ahead. Since this is a small
diff, it would be nicer to fold it into 27. I didn't see anything in
between depending on it, but correct me if I'm wrong.

Minor style preference:

	/* Comment explaining the above */
	do {
		memcg = folio_memcg(folio);
	} while (!css_tryget(&memcg->css));

