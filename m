Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F195D38FFF
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 17:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7562E6B0088; Wed, 14 Jan 2026 12:57:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7405F6B0089; Wed, 14 Jan 2026 12:57:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63FAB6B008A; Wed, 14 Jan 2026 12:57:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 53B6A6B0088
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:57:31 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 142491405C8
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:57:31 +0000 (UTC)
X-FDA: 84331326702.25.70742D1
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf16.hostedemail.com (Postfix) with ESMTP id 618A2180003
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 17:57:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dJzagWnQ;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768413449; a=rsa-sha256;
	cv=none;
	b=iw6IaF7g2SJoEpO+TBfz+G7KOO77LhCaw4EY6zKOY8ybqMXNJXyeflZOqJnESeguwNlZAZ
	9hmrAS0F4f7dnWeUz7j40auti1UdZPTdWDTEbNiJYNSiB+tEJLlcpPxlE9uTQVpr0q/ksm
	x+g600htbI16OyeFXX91pQazOJnK8Fc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dJzagWnQ;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.170 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768413449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m08Yl7EtzwefnAMN6c+XsJuXztPdRxM3+g7qCQe9UyA=;
	b=p1NPH1IYn5qjzmNLDeEVoLYHTguBcwfNq+N5w7qiqmr5X0qc7oYLBJqoq7ruf/gij1peuf
	gb+ZZdsRh7tAyY5EDRnmhvWP2LMW6hSp6+v8eYOtWvkunzQQo+Q31bN4hftCui9YdnqAWq
	6laWDVZwjy2lT9+9WcuCuPMVV0SXbbs=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8c52c67f64cso9616085a.0
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:57:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768413448; x=1769018248; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m08Yl7EtzwefnAMN6c+XsJuXztPdRxM3+g7qCQe9UyA=;
        b=dJzagWnQbY5tanTmNDp5RsJTvwx3DJ4qFTIcayI4zY8Q+CR+RYojDRa1DkDOqGC/KG
         dN4cz9kCOJC3lO0e1O37ITKrqLa0f0/45OBfQ5MAXvhejQewVHY0/FDiVKJoIY58oP95
         va41nc4zB+4siDcmIjmky9jQX1HSwYvCHl13l5BW7R1jD/hxv9D1p77Sz+wpUdezF8hT
         hS+Im4ZDweTkzFTmj1czrar6QQuIO0O6/EI3MjHHJVlFCn26/HKGZnRY9N0tvHwE6/RF
         8+W3f7jUsI0+xRULA/fdbCv9KKkTXaT0q6nx1qduFJ2WJK8lG2iYyo5GRe8A6SiXW291
         1sAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768413448; x=1769018248;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m08Yl7EtzwefnAMN6c+XsJuXztPdRxM3+g7qCQe9UyA=;
        b=Tsbk6US7kS2lXIxY1F1uHuxvgzcnu5h4Foiz32TXSXYLDuvx/z9i0BjhHR3NgbO6qN
         Z7OHbrwiM/wI4YGF7c+CdojfmZOxJHWGa1wvjNzRnUSsYj8moXBZBOlzrQlwVZD5aw31
         ZP1nBXQGTcsOXgD1dJ2CwQQFqyixiABAK/lGhRpXQVQvnIftxeLunEMa3DGPHbE3fztO
         R2wBahrvSyTRhSvSCx1tczVGyn8xzLPj2Z0jTiMRzLDXWXsmnwdDnIsELX5KER1Rmpz4
         K2Kn3UZApUlVJ42KWXMzjC/iqFLfQaimRrPo8RbVQeowfpvUM3WL2YMqr0uTB/j/MTwn
         cryQ==
X-Forwarded-Encrypted: i=1; AJvYcCU61FjuoWnTPgYJQyuRykyzzk5ZpYWHdihXcaekVmCyLcjNUmBr4CIZEb74F81gZF6P5cx2VktYdQ==@kvack.org
X-Gm-Message-State: AOJu0YxxwTJLYt+2b50+xODslLTeJILsUHvoQuvzjy1fn0BW6ewsZCut
	DbgyUWkJ1986kp8CBj7YkFLZBJgBjktF0BAHDaGYdcsPSFAZEwQHhXxPvPZj6w/T8N0=
X-Gm-Gg: AY/fxX5/HPu/T+NDYerfMAguaTR0LgkR1uwV4w1kTMQo51vRvelupq1Js18k74EsnYj
	HdvRib9wNQiUaZpZqtAyLNe6Ox4/v+3XwR3WdRuanT2a1HEBnOZ7j4QBRzYCNhXBtYZrLXgUiUz
	/GEmkg8lDf1Ldzo2Ra/KzW8s6tb/6qt5mCo18kb0GI8TuTzspO3BO7p91+TMFNx/qbR7yV0q+Ei
	9w+wRbAkeqU//vVYYxi9ClZqCj+VLIQkL8Gg4v5S9pAd0BghHlQ6mcpna3Xi8L82hGjQesTy5bO
	e3HiBwpvLZW/5lQCdLi2fLZPHJQ9bGnFMljfqmodGa4RiOuy6buXHGgOYULhZBVtXveH8tPJdW1
	JYdWXS2krg1/4fBBCiPC6C50ZSIHGcKSTKTqfimKY4j8dki9R8n+wZ7yC/15QrLOe1N99pOlxP0
	4CKtUKSmaboZmcWfskFykPWlrYQu5Bpuc+N1YW6Fku9Z4NvBeZUOUlJAHjEC03B6uaiCzKuik8D
	Bku7QWJ
X-Received: by 2002:a05:620a:3942:b0:8b2:eb79:d380 with SMTP id af79cd13be357-8c52fb2f623mr544823485a.5.1768413448323;
        Wed, 14 Jan 2026 09:57:28 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c530a6bdbdsm204232785a.10.2026.01.14.09.57.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 09:57:27 -0800 (PST)
Date: Wed, 14 Jan 2026 12:56:54 -0500
From: Gregory Price <gourry@gourry.net>
To: Yury Norov <ynorov@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alistair Popple <apopple@nvidia.com>,
	Byungchul Park <byungchul@sk.com>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Michal Hocko <mhocko@suse.com>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Mike Rapoport <rppt@kernel.org>, Rakie Kim <rakie.kim@sk.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
	Ying Huang <ying.huang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
	cgroups@vger.kernel.org, Yury Norov <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: use nodes_and() return value to simplify client
 code
Message-ID: <aWfY5pUPCD3mOou7@gourry-fedora-PF4VCD3F>
References: <20260114172217.861204-1-ynorov@nvidia.com>
 <20260114172217.861204-3-ynorov@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260114172217.861204-3-ynorov@nvidia.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 618A2180003
X-Stat-Signature: jgoum6wcc4n5zpntjqcwkufci1xpee15
X-Rspam-User: 
X-HE-Tag: 1768413449-869714
X-HE-Meta: U2FsdGVkX18tP87noWrLpELHdqNuwjFC5WOUY2/rupCcnLze7LEz9iUPdzdTx/f0SKtVjRzWZy2n2X/mXuyscMAwN/j1an46IiiYsV94TMo3MJixszhG+2Z7KWrVqp4ye8nsHdp8Zea8TjkKoxilWIYjsNX0BTUlp5m6WBWIV+d6+xFsZdwwY6Cg+CGUCXpYG9NSoU5lYq7/MhUST4ff4rSPiCWTucMnvrhYZJaP5JTManilmC9LeKeHGzgXCZd6DSOx5xJV3SLdAIO1TfilolTVpiu/edJlaN+TBIPk4eCMQMYWjZsrPrEl/C2lVKNVajPCDYnHe0v6qJVRim4xtkY7kLsZy5lrfeiYHupNMsPy/VmEsjggclEH3o0pqIEZbZ6u7UFUI7kCQ67qvlEtdz7dYW3w+V9fKrnAtpghghXfpruoPI91fpBjdnN7fXuUAnNd4qGWbLyfvNMPcsNVMsBDb31VFljwE/Xfvkisn5o45riuEIopY1YYajmx7XuKhZGRl+OR+HU11HVAI5msptAB8qinLhBY4W7vMTINWyb8MPj3HYd2lDreiHMxQ0p/qfjXs4YuTkyRxJUnkk5T8+oQQmzEyX/4578YuKysUeb8COEFzviDEiNMCKvizc8fqGKNdH5EwV5dQ8aKQKppiuFnXGnSuhdMhInRaznH3GWQtrrexCdvylOG/ZxXsEqUaxdQrXEmbia2lkbCfD9eUdJY9VbxQhH/0ZwAG6f1Wuixp9U/Or/VqkgKVFnXpQzgQtSWqsnqdNZsHgiCsU41QfbyloTp3cDkoN8a9xV+cE2HCwc4ZX3ufXaIKAS1oVlkOfVZApibKRiW2xmh3UtRRSKsBe20wWIdp6ualh1TbzfQRnupJVolulRQMCAKmxv+7iNCBNNEfuAuLrrs3QNEI4a+PLsFk2aewiTdSvGB4oxA9V9LgXydNJdQJIIqwE+HM80NQyJo1qpaz4G/9mt
 rLpipim6
 WfEM3i4notZ0hu4LyETHaZN7uKcl685V2sxrOY8uc9LD0PHFER/P7u/UxEScund8WMWjI+a4xJKfHTcp612cwEwJSiRCatq316zSSWylG0zp2vw3XLH4qJUYNNP2e5AY1OWGGlVvDEaL2Wwo83d1w40d2bw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 12:22:14PM -0500, Yury Norov wrote:
> establish_demotion_targets() and kernel_migrate_pages() call
> node_empty() immediately after calling nodes_and(). Now that
> nodes_and() return false if nodemask is empty, drop the latter.
> 
> Signed-off-by: Yury Norov <ynorov@nvidia.com>

Reviewed-by: Gregory Price <gourry@gourry.net>


