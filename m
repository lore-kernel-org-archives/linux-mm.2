Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAECECCF2DD
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 15:54:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FE296B0447; Tue, 20 Jan 2026 10:54:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D5EE6B0448; Tue, 20 Jan 2026 10:54:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30C776B0449; Tue, 20 Jan 2026 10:54:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1D2386B0447
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 10:54:54 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BC14C140674
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 15:54:53 +0000 (UTC)
X-FDA: 84352790466.11.EE200E2
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf03.hostedemail.com (Postfix) with ESMTP id EDBEC2000E
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 15:54:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ScaXqcI3;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768924492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IhsVj2SW0FOxYtaPNx5A7XnA7ZGrfb7ONRjNT2dq1cs=;
	b=gxpaZyVMlByt/7Qo/2JqGtXnfTp/hZDI8e4DiKJs0NmIu5eNuw6FiOVsvrPN26eoYIW+cu
	kbX5IFzjeyjcGTt133SHMOyp7V+yVv6g4Q3NC7mfMHo0bb3IDI8LokbcPb+0UTxJMiEQwv
	PloNGXihhk1D9hILeI6ua/5RCtFRyZo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768924492; a=rsa-sha256;
	cv=none;
	b=li2zEcI8j7qYG6cnwSWKRcG0LxyGJ9t7DL52PahNhldIcpZ2PIwGRxQ4f5EI87bnVFUjdN
	VNIRLS1HufJe7shUCROkXKyKLLQoXeHyObG98IsEo/zYeaWWSm0ffMww2I0jO5EWLfCWuI
	EzRJtrYdesqaUUSs0Wktj9ptvmI9pXw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ScaXqcI3;
	spf=pass (imf03.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 20 Jan 2026 07:54:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768924489;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=IhsVj2SW0FOxYtaPNx5A7XnA7ZGrfb7ONRjNT2dq1cs=;
	b=ScaXqcI355Enod1tJ2i/3AlhFJPA6uABNdikdvdAsNXrGz6B/WaEJtYD7pN0V7ZfndiNgp
	tMeCJgJiIA2TJXFybimJiSW9WBvpNKUpINDiBCOKgh4yvGG957S0wQIrfLH8cLd8F6sNq+
	D3ATwcewePPGGTLuuJWokdKA0bEIXWI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>, 
	hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev, 
	david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com, 
	yosry.ahmed@linux.dev, imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chenridong@huaweicloud.com, mkoutny@suse.com, akpm@linux-foundation.org, 
	hamzamahfooz@linux.microsoft.com, apais@linux.microsoft.com, lance.yang@linux.dev
Subject: Re: [PATCH v3 24/30] mm: memcontrol: prepare for reparenting LRU
 pages for lruvec lock
Message-ID: <7ruaiutqvgcja5l3zmxluwjp4c7utn62f3lx6ybwcwz5liki37@77fhdxyhmyk5>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
 <0252f9acc29d4b1e9b8252dc003aff065c8ac1f6.1768389889.git.zhengqi.arch@bytedance.com>
 <4a1b69d2-df29-4204-91fd-bb00b52350db@linux.dev>
 <e7aa1221-040e-4806-a259-56718844897f@linux.dev>
 <ncg4ibcrecdutsizzwdu4buw2fvqc57yji4rx3hsdwv4mgobkz@krdjtokzz4xg>
 <dd288f1a-e7b0-48ae-9b11-d882f42bab36@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd288f1a-e7b0-48ae-9b11-d882f42bab36@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: EDBEC2000E
X-Rspam-User: 
X-Stat-Signature: q8p33cjcm1ozmdt5pux4k1o8ujb3kcot
X-HE-Tag: 1768924491-466227
X-HE-Meta: U2FsdGVkX19WHMGJRrjP+Gq8wYTLKlqhX7WXVlFnlq5AnBtrweEiQ6WwyEw8qpdXmvVBQdWVqNQJFYIG3SUqU1N2tGv8uCuMnNC6T8cE1bfJc/ubry8Pz9yeYONAJrozAFBsElMP7R1S6BIdMoIILSYbODepHi1rlem2Xe0ro8kLwH6JsM+azid5i/mVfguYntyKMzNA2whNFK/IlZ2gLfhPg0NB3BbccrNJIoVtTcnKyW3cpE//hxbsCncTOKcbLhoK19Oe8mu3h5BJScjnyXSbRiy1/uwzq+dUTV4f4fqEQNknJrgT5+IrINb4ppianAD35miiKCPSSWBahQLhSWhJO9zcUMwHNp7f3eXNL16fVOHUDwW+0i90xLTCc3GoXhwj44vzDj1l1dqvtMTIrskISYxFFrjIKXC18lfuB4uionZNxCWi4HBDLQdB0sGF08Z2nW18rtk2xj01+g3IR0icp5uXty+erPANSyQGK3radj2hmPGqY2kuBHHfn7yZ3dOI6ZqK4+HwxYAMBsohe986DtVlRt5hZJtQa5nDte/lr8Tp7TWvNNZzbzKG2hPpcf7vvbEZN25phCVw8MJwFCyBhT0z2vFBmmlxAwXRqFUzPjSdCjGPWdMmdElsuvM8M0F+ZN3zLxFpYi0yAtGQnPPpfF9FjOIARrMEdsw8nzoyEmliEpNHxry76vI8+6WAyrs5zbBF3q9QEBmuRcP3R0LhJ6fSl1Ue7puW5BGKBR9kHQOzR1g0VIo4iOZoIkOgdz4Z0T7BAwMx8k1kty/2jilfiz8HzatC2zKB9qJ20VTVUjEA1bJ8q4gY7gSHDf+S0KTJzP9R8f5MGhcejngV2rsDABXUy5452l3U9YCSQVo6BTjfWzJX1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 11:44:09AM +0800, Qi Zheng wrote:
> 
> 
[...]
> > > 
> > > If no one else objects, I will drop __acquires/__releases in the next
> > > version.
> > > 
> > 
> > If you drop these annotations from header file and keep in the C file,
> > do you still get the compilation error?
> 
> I did test it this way, and it does fix the compilation error, but
> Muchun thinks these functions are very simple and there's no need to put
> them in a C file.
> 

I think we should prefer correctness at this stage. We can always change
these functions later if we see performance impact of these. So, I would
recommend to keep them in C file along with these annotations.

