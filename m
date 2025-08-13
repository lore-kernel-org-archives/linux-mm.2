Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15CFCC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 04:49:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C43F8E01B8; Wed, 13 Aug 2025 00:49:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99BDC8E01B6; Wed, 13 Aug 2025 00:49:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D9308E01B8; Wed, 13 Aug 2025 00:49:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7ED438E01B6
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 00:49:33 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 290B81A0248
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 04:49:33 +0000 (UTC)
X-FDA: 83770505826.18.32D9B0B
Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by imf03.hostedemail.com (Postfix) with ESMTP id 953F420007
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 04:49:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=codewreck.org header.s=2 header.b=XVbe1UW7;
	spf=pass (imf03.hostedemail.com: domain of asmadeus@codewreck.org designates 62.210.214.84 as permitted sender) smtp.mailfrom=asmadeus@codewreck.org;
	dmarc=pass (policy=none) header.from=codewreck.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755060571;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2gYQPNPMmKQR/y69joJ6grvfQ7sb2M14s/jfpiUm4+w=;
	b=hY4xEP8yzuFBxjerZCGZYaks1BFBMyISTLyRaJe+slpM9lIqcHfD5k8rC3DLFSc+QoLK8i
	mDwRdmLCAkLYVKLgVDFiO3WnOFABHQaVvmstNlAl1o4zlEvLxLpZ7RPuEB+MXS0gvjOJmG
	N7Y1skmOIlF85ig/2C1fo3sGbaSUA5E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=codewreck.org header.s=2 header.b=XVbe1UW7;
	spf=pass (imf03.hostedemail.com: domain of asmadeus@codewreck.org designates 62.210.214.84 as permitted sender) smtp.mailfrom=asmadeus@codewreck.org;
	dmarc=pass (policy=none) header.from=codewreck.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755060571; a=rsa-sha256;
	cv=none;
	b=CHuHEAuwuvbH856iJIVCzxl9NNH41B3TSaaAxu+qwxZRMOcNeOuplUjg326dqE4uElpaN5
	uXq2Nfr+03BdibuqEZ8I/N1YsMp6SYudgiTKUqy+JLk4LcaPf83qm8xyHB55GjloZZ3IYP
	ZmCV2Bs6M9neDWkf+GuAM+aFm+BPQck=
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 9D91914C2D3;
	Wed, 13 Aug 2025 06:49:19 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1755060564;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2gYQPNPMmKQR/y69joJ6grvfQ7sb2M14s/jfpiUm4+w=;
	b=XVbe1UW76zHNmZAYQ87tMsEgOECdFfIgVSw+Fy2jy1ArOng+EKOYVY7d04N44rEwrSxoIO
	dePoHBHkmwcbHlcRskh5EJ8CFL4DeIU9I8dR1ghoO1A65TnrsHwz8csFGMFPmmRMh4K5fB
	Fm2nnTeYxWjgm3XxvQFsGAxCMrBFqrqCPGJtcaCAz8Hw1jmQVrBUFDFWJ0GfuBC0qYjEXj
	Njrq+10uY8Vd2P8LhoiV0aBW2t8yt74TFCEAiTGz8AU4m+Y1QZTDR6A3ywlo4iiDSWlu/g
	ml2GFm7Z2xbb2wkVSJ9sNeWFZpgXWU1d+u7Q+aVoAvmgqfGLJn4EnbwMexDuQA==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 3e5818ac;
	Wed, 13 Aug 2025 04:49:17 +0000 (UTC)
Date: Wed, 13 Aug 2025 13:49:02 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: syzbot <syzbot+3f9768ec54c86997ddfb@syzkaller.appspotmail.com>,
	akpm@linux-foundation.org, apopple@nvidia.com, byungchul@sk.com,
	david@redhat.com, gourry@gourry.net, joshua.hahnjy@gmail.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	matthew.brost@intel.com, rakie.kim@sk.com,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	syzkaller-bugs@googlegroups.com, ying.huang@linux.alibaba.com,
	ziy@nvidia.com
Subject: Re: [syzbot] [mm?] WARNING in alloc_frozen_pages_noprof
Message-ID: <aJwZPq0b2rckG-ap@codewreck.org>
References: <689bb893.050a0220.7f033.013b.GAE@google.com>
 <aJvc5m8Ocm3S_Xkc@hyeyoo>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aJvc5m8Ocm3S_Xkc@hyeyoo>
X-Stat-Signature: h9u4t1ui7zkp71js7wmd6emfjbxh9og7
X-Rspam-User: 
X-Rspamd-Queue-Id: 953F420007
X-Rspamd-Server: rspam05
X-HE-Tag: 1755060569-817487
X-HE-Meta: U2FsdGVkX19ToO1VYeLVbepHk+9Q3zq8V6/kHcCCANCmc9ObzHdUgrBfuDE4bRVheOBWC47+hApuTDBkDaNJg7zUM8e+Yzz+SGGnscrg1qQOjkyJrmd2XPU8BOi+DKFHz4usj++Fd2KI/Xc/+kJF07cOtgIaK25CyqR1u1Kv4ptC3B8TJcuH3dCRlMqTjCQHcjobJK6XL9ZDZiz9MYmL44DMgS4PU320bLAlbuHcoLCJgviAxCuvi8Or6F+UZzbqrRYRwS2w+MdPb6Ee49+O1hEYFQ+Kd1AypYDrxHRU1AJhSVzihNjqsKVZWtICNh3sQVs5McAFpZWPIlH9AV5gV9cLAVYHrEpb8iOwCI+pv0BBziWN+cTgpXQ2UAnwjCZm8VcreEFbBgnToIKjJVV31Uy1hk679s5cOFS7/y3xrIzL5a/N2BjdRBrlGXKsNLd39zRlYHGXw7mQXNj4IgHmqplFYq7Grk9v0J3wH79zAM2DVIF1pFV+iWJzgpvGpaJX61PlPWx04pRG3KpX7TVHUs+aQALO2jsFKvR268AF1SAuZY+7v3q3suXQE6C2RMDTjnNeJWx5ZnY2uZpfsAEMOPeC4KAnethWdRYCaCY/bcYpeAzA1CsQe+RiCT6LTvEq4ZtUS84vekFnZUJODlSvv1x/6sG9m/Y7piO4tlE0FbS+Bd9YiFsrCkcWBXgZu37tpe+xySW39zEFYkJIwgLfw8GT3BlNfLSwj8fSUfnlH8ULtVDLxZyHN95jKQGryGHuFDZDf81Mn9GMaVEpUKFvW3DYe3TAmCgV0vmPRMYP/mPeb/v0HO7GdEfEB7Yfw6uSgfPb7mHiHE5SS7zj64hIP6CKCJ9JO3c80QNZdg44xttyyTGSq1qnwc3gnoYO/Sj8rc6YGPClEfVeMODyM/M261ekMwG5zn883etlUIQpoY6+vSLqjz/KHcZRzFYShIUC/d4wdaiIANIypVo5c9G
 rj9b/Xpm
 50zrtyk1jLa7jFePs+jfmR1bD+1pBv1JsAyrEpSOZCe89j4jklKScpsYwn1xTKBAHr9LQZ0Dm6RH9X2Mb2QiQG9OlbBDJ3QHkctaG73+vKf1BhsbwYIGA7deLGPuWXDhA/m9O4s3bE9vEkhoGciSJ8smSQ2LTFf5SdyPbeRKcxk9ovWwVW650BzryYD/yyZfx9cU0bg5wWdqfc1omWDypYSPuJdkDM7nGJZnltxuiIBvWHjzN+01nUVNrcoQiVBkAM7hElKyQBka1Vl8Jhu03FHoGH1xgAn3sqI0KqNlNPyiqyTAwBWGfBY/mgs0w5hNFUu77xp2B89miXHJqpnRRPcW7ItrGFQ6b9uj0C98G5QcqIOqOSaM4jPbwVGPeIJ4f1l8nebrZw+2z+v0AFk+dPiI8AvnNlVONeQ9VjQUXecrRP7BjNY/yvXtuuVZ66PoEZWrVjnIPuKIlbvu8dQpf9EgQVpTBZBRwaxB3Bg0drsjAwH81nftXHyrwHDJOy2fTerVW9W8+lbafvRb/SZBpfu9gvwLq/umLCSsdbG5NI4d0T8kRPDh06s6oZHm/BfrtQ+onOKxqLGg4xcMVvmkMDI++KqkWXp4EvwRWpy3ibD3CXOtRoxd0656+pvTgcsQ+0AX3TQcaQxLDUaEELh3gCEpbUpZbz0TrnTToOxqklhvpMTosqHj6LW42NNqWhdMFBlsiGK4kPE3a0YfGiFEITTb77g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Harry Yoo wrote on Wed, Aug 13, 2025 at 09:31:34AM +0900:
> The warning is:
> 
> 	/*
> 	 * There are several places where we assume that the order value is sane
> 	 * so bail out early if the request is out of bound.
> 	 */
> 	if (WARN_ON_ONCE_GFP(order > MAX_PAGE_ORDER, gfp))
> 		return NULL;
> 
> There's not much the buddy allocator can do when a user requests
> order > MAX_PAGE_ORDER allocations.
> 
> >  alloc_pages_mpol+0x1e4/0x460 mm/mempolicy.c:2416
> >  alloc_frozen_pages_noprof+0xe0/0x210 mm/mempolicy.c:2487
> >  ___kmalloc_large_node+0xac/0x154 mm/slub.c:4306
> >  __kmalloc_large_node_noprof+0x2c/0x8c mm/slub.c:4337
> >  __do_kmalloc_node mm/slub.c:4353 [inline]
> >  __kmalloc_noprof+0x3bc/0x4c8 mm/slub.c:4377
> >  kmalloc_noprof include/linux/slab.h:909 [inline]
> >  kzalloc_noprof include/linux/slab.h:1039 [inline]
> >  v9fs_fid_get_acl+0x64/0x114 fs/9p/acl.c:32
> 
> So... 9p FS shouldn't really request that?
> 
> Cc'ing 9p FS folks.

Thanks for the Cc.

So, this comes up once in a while, everytime we discuss limiting the
xattr size, then someone says we should do something else or I'm using
the wrong define or I don't remember and then when I ask what we should
do never reply again.

See [1] or [2] for the last two time this happened.
[1] https://lore.kernel.org/all/20240304-xattr_maxsize-v1-1-322357ec6bdf@codewreck.org/T/#u
[2] https://lore.kernel.org/lkml/20240202121319.21743-1-pchelkin@ispras.ru/

I'll be happy to take any patch you send (or one of the older patches if
you tell me which is "correct"), I don't care anymore.
-- 
Dominique

