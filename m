Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7B5AFD3764
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 14:43:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4166B0005; Wed, 25 Feb 2026 09:43:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92636B0088; Wed, 25 Feb 2026 09:43:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48816B0089; Wed, 25 Feb 2026 09:43:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 927516B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:43:35 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 36129BA2DC
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:43:35 +0000 (UTC)
X-FDA: 84483247590.18.544E7EE
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf10.hostedemail.com (Postfix) with ESMTP id 46C0DC000C
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:43:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rcbkIZdZ;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772030613; a=rsa-sha256;
	cv=none;
	b=n5hd6irUC7UhOeJbkSaaFcLVZNJFSXqRFGGDitaHeNFXT6DGK2T+3mBAepD4pBYJfbBQsk
	xZBUhy7jg42Tp+AfEOG8PBdejP66S0CEABFN1twasytFhtXBq0iEon0hAuqR0sTQh9cTg7
	IYRDBOCgt4NQDDr+VfksFt0F5ms7fZg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=rcbkIZdZ;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.173 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772030613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=foY2Y5omQw20sTq6/J6XKrTrTufvDv+fOLstkti1G50=;
	b=bkiudk1qARdRZnFx1p+dhvIgLpMrqlayNOojtMOg+wXOh75CaBsTwaTF9uvhUKzMBnO9ki
	XqwrDTiRs2iofsuJ8qMPIkeoOb/RVOlsIIuLfn4Kln2neAIfQh+5g6GE9bQr7BIpZiflP3
	q0zbL2JFrp1RT5Y+PYcqGxKnm3dl564=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-506a3400f30so8545131cf.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:43:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1772030612; x=1772635412; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=foY2Y5omQw20sTq6/J6XKrTrTufvDv+fOLstkti1G50=;
        b=rcbkIZdZe+AjrGXS1+blMxAthjrcK5seQlOGQEaD3N2YmMTWQgwzpxO1K1kSm2s+58
         Jb4rj/J3Mxfa4YVZDpaTu9BnpWq0CjqvZv77WSKIqlETWje1AlWvDpsITqA2scx2W66g
         2bKsQTJMjWPE2o3pZ9XsFghY2fvfnCnffinEI6//ucrQ/vQ/2sCUASWJsRe328EPkyeC
         khCNY7+U+mvkEHgyUcEYdrRbfvmyBD5zXZhCCQrdElEHTEwog7jLOw0g0YmG108CkPO5
         nn4BgNfxiegiGclPUoqwQjWgUU8b2ryF08BxOLQPdl61KE9VvwSh/FuJVn8PTgWn2YzQ
         9oWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772030612; x=1772635412;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=foY2Y5omQw20sTq6/J6XKrTrTufvDv+fOLstkti1G50=;
        b=K9BtdcnNuwajPfD+DR8RCIn8c8faqQbVT6NzXQhpH0/Ff48MDxkaOxTrgarFqYUYld
         B1Og5xjtxt1+ZcZcF28AI5DWQow4M8JDFDNf1+2E6TP5gOS3cT00fITwb0dI69mSkpSq
         OuASnvW2FFydRKCVFsN/6MzEgbLoCGmftG9HckInWk2sNWqf2m0abbFwvpPNAMZHYYoO
         agqFbMfRVDpnM0WKL5ZwHgkHK3g3pJYw9vQjRwPhpyWmlFtfcELw/Ob0mnYM3QY4D2d6
         PctWO9prO0Swqc+xFZhSqtBTq5iovQFdFn+TM9bPTJ0FP4kL+HAZFQFCHzMcW6EXPEcz
         2DpA==
X-Forwarded-Encrypted: i=1; AJvYcCXfLcPEabUq9opQqsxbW0n4VFGX3ZgQM+a0R+aN4QpBLiGV5G0PIJVGCeXd9Bz76ktqY6oZaAfErA==@kvack.org
X-Gm-Message-State: AOJu0YyngdiWFz7bbOTyGPq4MbT8pVkcgBGVvjFFctDDhczutCdgSzio
	35ZC2K/0F/WfShgVb66hYRKLlizxbuzuQ1QfLzWiEgNFyKZeB35zmKPW9wkRgqMqBuw=
X-Gm-Gg: ATEYQzz5Jj/p1UbEFEegVPzbysLezW07EZmXkVWVTOIYQlOHWpecCZFiTCn64D5qFKH
	GhJleKrAvN/3eeE971Oj2J8734QdkysJQbWx3IDVoLKoZtFwEtsnH0f5Hvpj0HrOj3gGnFp/cr/
	KRo6tF0uFN/5MCXOwGAREl0q5VBPaKV7Wh85rplT1Qmm06VTgmQYSSgGQ+uVBSMSQVwz8QFeKLS
	fo38LJWTorOXBAWny6GBNmdLj2l9/5mfsdmeP1evXbKVRL4xWVzJSJlNvqJ1sxTs3Tboxiz+G8u
	2Romrs1xU/q5anHLfKRVJkq6kBHoDe3S99e6h4ptSstT12MeEesTdIzgh/UcEwK2qGGGPtC/9Rv
	+zyw+qbYvmiCEvsDjCO5YpVehrpR9U4vN/dC+rQXLxYF7GYPyXQGef+33BJqqDwQgsBiQTYLIBJ
	9YfLN+EKgraMZuttLbQNCrwgHYjqiinJnwMX1ZUM6Aq9pNw3Qvv4ArS9S67KWkwFy+JeuQFH0PW
	8cAIm2JB78NmQjztzDE
X-Received: by 2002:a05:622a:1453:b0:4f1:e79a:1e0 with SMTP id d75a77b69052e-5073659bc05mr41895291cf.20.1772030611934;
        Wed, 25 Feb 2026 06:43:31 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d510a7asm123124661cf.1.2026.02.25.06.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 06:43:31 -0800 (PST)
Date: Wed, 25 Feb 2026 09:43:27 -0500
From: Gregory Price <gourry@gourry.net>
To: Alejandro Lucero Palau <alucerop@amd.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	yury.norov@gmail.com, linux@rasmusvillemoes.dk, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <aZ8KjxdPS077aFcq@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <b704b05e-3e65-4a73-84c0-21557b0cc38f@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b704b05e-3e65-4a73-84c0-21557b0cc38f@amd.com>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 46C0DC000C
X-Stat-Signature: gaz8pmxg319jair7gufkzihrgf4ohoe5
X-HE-Tag: 1772030613-65859
X-HE-Meta: U2FsdGVkX19qJwSwWCEgj/u819mnVWA9d05tqx2CVS0myCC7lKO3hVOYkIxIttFJrBcKXCxv9BLinC0wfm9WOTTxHXY6DVsZjAPtQY0zAC2n7fDCD4Yze92qMtYo2BWQ1rCCDnoMdRNycq6vLvOOfawoU1EZ2ll2B0kCPznLLU5NcylmGa8+vCLDzGu8jAgfBbyEDV9oJJAQHP2zu6DBEf9mMf3N28Mq6Qf6fz3wXjQZEcKjRDfM7hU7rL7/N2g2vlgboLNzbxSN8GjraVKBeMGYPc+OjLbt1t9uuZGTyhEC47kpJsEZaS/Svb+KWzauG8IdYuCuY1BpCqgqhpuesTulvVM996eazdZVG6s2UncknA0Ib8qUow4UcCjK+sKuqIk/IVz/tZuT+Rz9crI1xTYDJ7RrSis1Zb1t8KU694C6DKSUZHG3WE7cpVXq62jEX6BEMk+2QYpg3tRYGW/cCo7yQ/vUXpu3nHE7Rx6ldlL/cNkMDkDYz/MXX+rDfjGi3QKzHzNv5vQWUJBCa5Q2OvEQ5EbT2x9xDPobo2zsgexnAw8OZaZi+suoAh9zpPNMkzCV5iBdPfoGyJwBVUoFvrmZ7nbXJPKrmSTVkYDEXOXzPEASWVCvL5C3iiy+ENnT/DTXE3iVeGfj6+11n1YGrZvqCsGjEVCrnu9RAW6/6V981/yu7CjBgHTNEPh6a2lPanTrD42YDtMSV4Tl3FjlLWJCn6jRSGULIHjlebxRl4QWLSNO3xGtGSYxcD/5WW0A28ehn/gXU2Xv551z6OD9vimc8DhetvkjIOsAnO8YfZdGk+AW/e3mfr+ECkpHoso/avEi7gpx3qbpPiDUOwzbdZyBqYIbaSb5GcCsZGq1j01/b2MvRh8Y6l4u9GcBqXlRN+b37/47Tupxq6/Am6guzk1DoXCnn4zT8Zq7FEIswnKWcqLgTRVPdeazC2IRWRxI+2zLzEDMciu9jvDxhLt
 Ig1b64BN
 ooJmAPzL7FNXb/oYIGI/TjX7Dj6IR3fLTX2f+pgyKD7RDr1JoQ0W6B6a3fdHTU0pjkUDJa8Y7OVRvWL2r3oQEY/S1ka2nozzikWEtQbQ+vgvNgyDIWRZ+viz1Ykx5y8O/vArcvsIAAeJzQ68rqH5No08pGAgxFwsBxQaFBf0K67IDvb+S1hWPeHeXLMRxfd/IOzb5t2Ebx6oOY4CQi1huB2w57KX98BIZ2tmVSdisjYnQr4urGMoI3+mcFHVUoGmMKaOVQVUp4O8M2v0UAUOMBcoZ0nzcMgSd74RmAhtDNGHCTrHSGwixQ9W15N7KcUbUC+nwa30LjGQnoHOZBfD8bcBHZfkiVf9g2wGz1zab6LpyxH/7zitVfIF+/1Wy/oHrRl8YjwHSnrxWRBoCT/ITW44iOw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 12:40:09PM +0000, Alejandro Lucero Palau wrote:
> 
> > /* This is my memory. There are many like it, but this one is mine. */
> > rc = add_private_memory_driver_managed(nid, start, size, name, flags,
> >                                         online_type, private_context);
> > 
> > page = alloc_pages_node(nid, __GFP_PRIVATE, 0);
> 
> 
> Hi Gregory,
> 
> 
> I can see the nid param is just a "preferred nid" with alloc pages. Using
> __GFP_PRIVATE will restrict the allocation to private nodes but I think the
> idea here is:
> 
> 
> 1) I own this node
> 
> 2) Do not give me memory from another private node but from mine.
> 
> 
> Should not this be ensure somehow?
> 

A right I set up GFP_PRIVATE for this

#define GFP_PRIVATE     (__GFP_PRIVATE | __GFP_THISNODE)

If your service hides the interface to get to this node behind something
it controls, and it doesn't enable things like reclaim/compaction etc,
then it's responsible for dealing with an out-of-memory situation.

__THISNODE was insufficient alone to allow isolation since it is used in
a variety of scenarios around the kernel.  v2 or v3 explored that.

~Gregory

