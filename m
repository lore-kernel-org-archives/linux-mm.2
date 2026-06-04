Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A7D6CD6E4A
	for <linux-mm@archiver.kernel.org>; Thu,  4 Jun 2026 09:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B4EB6B008A; Thu,  4 Jun 2026 05:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7663C6B008C; Thu,  4 Jun 2026 05:41:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67BED6B0092; Thu,  4 Jun 2026 05:41:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56B986B008A
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 05:41:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E51A1C13F6
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 09:41:10 +0000 (UTC)
X-FDA: 84841736700.07.B9849B0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 947F61C000C
	for <linux-mm@kvack.org>; Thu,  4 Jun 2026 09:41:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f1XM8VeW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780566068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mnjVaJX+R7uCbO3jClwNLliInzV5QanTPnKFMHuMuas=;
	b=p63dqelwAm3u3TyxFn7Ayy8dM3Jxmb+Rs0mG0GEoWZoIh5W4hIE0G8XBgmp44MQUN9+zbx
	r8L78hebAr/dXh/3MZuyTGNpS8HRcxQV/eR9gx7mrfiLpPyUEL8Z+TTDE/CdlRG1TxnNie
	NC13eRhZVZshi5uCDKJXccMct38LI5s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f1XM8VeW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780566068;
	b=TleCRJ2Qzp5Yz5XglHciHSjP+NW8Pl7kworhuy+ZBtQoTKf3Bx78meHGfLTWmf11TuGr4K
	FUqFoltdfjzQu/Dlfst2nF3M9/Qh8QB5+pcCIQHzZh/tPbN+JEm8v7e10v8DIYS6UwSIq8
	V+AHGhniUaG1BtuN8l/6fsRaEaBfDeU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DCAE360221;
	Thu,  4 Jun 2026 09:41:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B081F00893;
	Thu,  4 Jun 2026 09:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780566067;
	bh=mnjVaJX+R7uCbO3jClwNLliInzV5QanTPnKFMHuMuas=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f1XM8VeW9YiBPOV7xsp6RjWrfLgcqlz5ytLuWbxe9s6CrVt44fS1UvYE7GV5NQIt7
	 sopJ13tqkwmI/XyC8MpBwZouwgOSbMk8iVik2o+ZU7c281S9CTFBvgIkDrM+4ZdqWV
	 2WGnIWao69+I0v6Z76n/kKt4YUfz3qmFsQ1PRzpCGaRmr2erSDCJPApnP6CidYDXMV
	 wVx8GxOh0qoC3i30sBheccc56PRGVa9YP6PEko8JAoo8n1cgMhz10crJR6NENzssqD
	 PaHgWdUSzzxcQBj5BKgrhnIAnOARH7gvvtYwlzW1B4w/L7VUJnDDWEUOOyXyzuOREw
	 sgzKoew4rxb7w==
Date: Thu, 4 Jun 2026 10:40:52 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: tao <tao.wangtao@honor.com>, catalin.marinas@arm.com, will@kernel.org, 
	tglx@kernel.org, mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com, 
	x86@kernel.org, akpm@linux-foundation.org, willy@infradead.org, sj@kernel.org, 
	kees@kernel.org, luizcap@redhat.com, zhangjiao2@cmss.chinamobile.com, 
	kas@kernel.org, hpa@zytor.com, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, jack@suse.cz, 
	riel@surriel.com, harry@kernel.org, jannh@google.com, jgg@ziepe.ca, 
	jhubbard@nvidia.com, peterx@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, 
	lance.yang@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev, 
	nao.horiguchi@gmail.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net, 
	ying.huang@linux.alibaba.com, apopple@nvidia.com, pfalcato@suse.de, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, damon@lists.linux.dev, shakeel.butt@linux.dev, ryncsn@gmail.com, 
	21cnbao@gmail.com, jparsana@google.com, dvander@google.com, zhangji1@honor.com, 
	wangzicheng@honor.com
Subject: Re: [PATCH 0/15] mm: introduce ANON_VMA_LAZY for deferred anon_vma
 creation
Message-ID: <aiFH5_rjl-mJyXBs@lucifer>
References: <20260527110147.17815-1-tao.wangtao@honor.com>
 <70377626-500d-46f2-a3f5-a0d2914ce365@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <70377626-500d-46f2-a3f5-a0d2914ce365@kernel.org>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: s6smgzcbgiwawk4aowsb8gwxyykdy14g
X-Rspamd-Queue-Id: 947F61C000C
X-HE-Tag: 1780566068-276523
X-HE-Meta: U2FsdGVkX19jj4cb/hRfXcsQ4EeMHijGLho1SCTh2EgRmle8KmGObevovhju63Rl/F/pei7t4jE8c2FtSI1fum12KJqFqiYu48DUY1iBX81QbzEvTNi+lxFkX2Y3Vdw1G4PY3EfKUng5d5+bua9ITNj2HOAF6+p/gIY/oG/0LyEUWmliSp9p+yxyGd0JVlCQkSCxO2hCi0dAeJ3zmiwVx6rT+8rKi0/AztjS/zBITcOlQ59S5UyihxJ8szwxx1lWB/JBVWhN+YHpAY2ghcUb6p3FiDGOMJk7VDGfmYu1C5kEsX0Ywm7LzAbEIFWu/tuQu4yaHVCJ5wo0wwW1nBkPD47+a3tJbvl3a2tSGuGFQ/ZweItJcSvAlMvVyAkfn9En3R/Sf0VIFA9m8eXwTed2lfUrxMXTmuc/dVcULBNd1feC39+a3YrBSD4ynK7gbB1FLfQJ7IkfiPs9x2c78bYAf9yhXA4urnZ/8RbZ30NHWqA0XRu2f1kir9yjaAEu+ZlB8jrxiBW8q7yvUN2ybt4qdTyJ//5k8QKwMMrsjmqBdKj8GKeuPUiHRec/VCpmJ5z4b4FsViNulVekQyKL+NTIfg63MT2eoAoljx4gamjZWSgl42T3woqtcC+IgMidlxrCiVTATfHuJuhNyrK7zEs5xYX4Y1Be6AJkr8bogRwBccsE8DSe+OdxV/2GYntzzDZPZ4XD5VkfpTl7JziALuiUeaGTvC+Dmvvhl8SGiZNCL0HqzHv1ULFcMvCZ9ZqGt0yw0+Yevs2Z5sn8BFDy6tlbtkrU/G90nGahrK5AkK2q4MGpP2/dQ3LhFa080NrES42yUopaeVrMntr6oZ2WuCL+gcBsgwoyTzEMdG0Md5QD/OwumQpOyEKgiRulZlqkobjw+YHptDYIByMa4xh9sb8QA6XF+TbCWHpau+Mb26TqLumwHN9znW5yOSFwwwBhiOYEN06hc6Y6Xqu51fS0Eua
 ZMM3Div1
 tZ97nmPVVdyGxoFr+IjlRiCPZ8+rYOHdQnFk/0RH1hVeiXclVvdwuswmwR/EggmYp1c1iP0bk/bcz9HdjbdKbYMPj7m9/ovnt9eNsO062Z5rEhqeDUszbtuVNjB/gt36iqn3jq4wwB+9NgA0NJ2sz7wysw03/rjNUqw+2UOnCwdPcrYVkfzmuhvGnMeyO25kN9CiWPY5uoQ+cO9G00WSsCjazvmqM86aOCmw7A5HFxDwHzspPMLjC3soORKjAhbe+oOQZpEFkbY0bMAjm1OOIfKfv31CcFQI+xkYK0eaodnH9D4bv4QnFPzDtTwGQzCCbS7baTwyHOacxs/3v2JnHjuEQ1Sbz3ZrC7CVo+4rbQdcmb8uxIsqxQPEISA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 03, 2026 at 10:25:05PM +0200, David Hildenbrand (Arm) wrote:
> I was excited when Lorenzo started working on a completely new approach that
> would focus on improving the common cases while trying to reduce the overall
> complexity. Because I think most of us really dislike anon_vma. It's still work
> in progress, and I am sure there are some rough edges.
>
> But fundamentally, I think we want to find a new design that is just naturally
> simpler.
>
> Lorenzo has been hard at work exploring various design options (and I'm afraid
> he might be one of the 3 people on this planet that understand anon_vma in full
> detail), so I suggest we wait for a redesign proposal from him and see if that
> is doable?

I'll spend the next month focusing on shipping something as a priority, even if
partial.

Thanks, Lorenzo

