Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE7DDC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 14:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7B6A6B0093; Wed, 22 Jul 2026 10:05:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2B846B0095; Wed, 22 Jul 2026 10:05:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F6846B0098; Wed, 22 Jul 2026 10:05:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5EB746B0093
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:05:00 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D6ADFC01EA
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:04:59 +0000 (UTC)
X-FDA: 85016583918.08.2018C01
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf09.hostedemail.com (Postfix) with ESMTP id 15DAE140013
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 14:04:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kKNkOEFR;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784729098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wzTopji7Zl+MAyFivVnXiZLO5KABEpd5UV02S/KHUTw=;
	b=iVOXCNHJah6vSisrlBNCFN65EAXSyXDueUq81Rs1yrTlh3Bunec1/8bG5TAYJ7Z3wIr+N6
	2Vv4AhgkWqz+yk/nJdFpPgBtk4ZwmroqxM9HQU71r5l7LObwmcBxdzFqwYgU6PhNkrzRIt
	kH1r3YZnoBC4hwYBFIlO1Rsr46gxFY0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kKNkOEFR;
	dmarc=none;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.43 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784729098;
	b=zSvymlAbAOk+4Fi/+QVsIJ5khtgxIo3M/fwNwGtEVFAn/0w1xjSPgVO0X7H6h5ddSi25GK
	Sso9VAlURXAw9jCMPW0hGk3X5bX8Z6o5LlOF6y2i+m2EDpinCvf4cIB/JJk1mrfdWsd8+4
	iL7GQIbLwBi7t8PfXTVNywpaABRmXjk=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8f256eaedf8so149143276d6.2
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784729097; x=1785333897; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wzTopji7Zl+MAyFivVnXiZLO5KABEpd5UV02S/KHUTw=;
        b=kKNkOEFRNjARUCeHy5/dAdE5CIR7bpv48H7BlZLt10CRJ4AGLfWWj6I9960huJ/WcR
         fqTKwduV5rCIGokp3Re0qoEsVt2HnHan+3/m5xTCD+RHxcWx1waRUEgME164FCvR3L1f
         NCv24YvagiO3WMcjbjzw0V28+QfGq+KXqp+7UUMQt2saBriNPObgYwNwUtq7Qirh2iJC
         qEiJDaI7iA4B5UEHi8o68dDBOPr/QGBubjeW/p2hcJ7WN0hQ9f80vvGAoycDif8YB2rh
         zsph+yUl+J1uv0AzI72g3Kljiv8sXxcHWKo65JlBfPTA1dgt0QFeumHFFXj1jxPeCwz2
         tiIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784729097; x=1785333897;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wzTopji7Zl+MAyFivVnXiZLO5KABEpd5UV02S/KHUTw=;
        b=S8T/YtATLLTNSt5s3fQj63qzWV3kJ7oJ+bI2A5v5hBFDYShGacyUJFLhKFGqXkGofK
         sQC2CtNsVTAuFg1Dr+oc1N7j2+/u8O7mI85gW+34K3qF941T2pymZWC8TSxrEqjGpVHj
         QxfwWPvKfWLSoCd2vPuLvrHAsN+E2BcpLC9du7EZ+kgai+1Fwvq/Crx2BMB+7pddvXaS
         H/2OLgfJ4rYFP0DWWUqpxjub4QP14a0yGwNb9dj7VlL7UlU7koVf+aDFJwY+gV4mjdyx
         n5ClNqOSX77+yUejxNayM70UAPH1ktptbwgY+4bT2QIfPjrES+B0ZSCwZlbx8oXjSQ1B
         7xjQ==
X-Gm-Message-State: AOJu0Yw7aJ6mMfeokdJj0lTNe6YVyMRiw8CiiPeEiBMqNtYbOnzoTIu2
	Xz5YB6AnGHUzbYkWMjoqQWVSVy90ahYMF2xfRlAudlgqM0sWPOrXJYUVoxu17zZcSaKryneyEsJ
	5grfo
X-Gm-Gg: AR+sD11KY6B5GMC50nh/z/tNqDsJcixD4xNmlFoMxm7gZKxx5MAIU8l/qnusP5QpiIf
	CndMOnvKBMb4yNNwfzPFdpTmaliM2fSQHId2IYlfYJu/QFhNPiOiHvILCWZxZLbxCV3EDz3eLxr
	ZxA8GP+dhhqqDn/ikx8ZpTRwRK69cnI0IoHolH5/3oXEhsGgL0OuKJovZsyNY6i+qIr3SYckes+
	Si+wom41zvHVosXXHbAOfujTGBA/EUlw2rXfDl+aF8gslp9QayGxmOu5eDT8tiS8RHfrc5Yrb9k
	0FdEJV6gEDyi25SVfVWNaLTveDNlrQ/dK8OuUjvU6VohOWAi4BAImSh5/o9/4szajqFRHW0kwQN
	2+GRRlpP0xM+COLxIyV6n5zY/Q5xytOyr3K3aSOartZTtrPkHIKTqWFNlbD9NEwZw+OfFxXiZbH
	K6s3ErtVz2Bi58Ty9lxvIQvS4r0FYN8QNLsmGEcLyct3R9OJKNLXplYaRpag==
X-Received: by 2002:a05:620a:1992:b0:930:f7ee:2cf5 with SMTP id af79cd13be357-930f7ee3792mr215753585a.66.1784729095553;
        Wed, 22 Jul 2026 07:04:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f68d5d6dsm171863585a.20.2026.07.22.07.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 07:04:55 -0700 (PDT)
Date: Wed, 22 Jul 2026 10:04:49 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com, arun.george@samsung.com, balbirs@nvidia.com, 
	brendan.jackman@linux.dev, yuzenghui@huawei.com, apopple@nvidia.com, alucerop@amd.com, 
	matthew.brost@intel.com, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, 
	vishal.l.verma@intel.com, dave.jiang@intel.com, alison.schofield@intel.com, 
	osandov@osandov.com, jannh@google.com, pfalcato@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 28/36] mm: add NODE_PRIVATE_CAP_HOTUNPLUG for opted-in
 private nodes
Message-ID: <amDNMmbdE_ZhUgl1@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-29-gourry@gourry.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260720193431.3841992-29-gourry@gourry.net>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 15DAE140013
X-Rspam-User: 
X-Stat-Signature: n9xqcfkdys4cy7zym73mtyb7zzjodd8i
X-HE-Tag: 1784729097-71623
X-HE-Meta: U2FsdGVkX1/DF8dQq6gdABQCZqArOrFzqDkXmfSmd2TbqpoQL6tJQoYMkFPYs/dV1SOcKBxEWBMRzP/7yPwbJu8THKH7r/w4EqDjABPhRRJfKzzWl33HKu/k0eW//dh1Q0WwF8AIJjLOsT9JNNXk+MY886NbIDgkauK5i2wk4l8V3N4uwpYweyy8d0nKi9sNt0aiRWb+ZeeRsRRhXwWXdXeg6Msk5LoteBo7/c0kZtoojoMkSDhEikoFD4FZO1EZtsnU+gxRSVbq2YXwM3avCQFZIKLpA7a3v8Kf0yuSzkTWowRQPsphKPiElk0cYBCydft6nY1amzWMGwFscD4Rg7XfXHo9wiHcLHsfvDs75QO6KUfn6r6ti+F/pRTnXRFtVUkoYKrtzymDN+OWiTX4rOBPVZikfyTbh4hzu/GjxPrI6o1N8y3ETJtd0a26a6inQQzG1vOwkmyqixTikCDMQPcdsykHTbI0i72MNipfhwyEhHAdREpykGmFV6TifgBrO9bhmTtrFDwjUwfoyRUHR7wf3uzcrIuVSo1g7vxmF1opSId4r8ICnxBLgpHOUJeN1gEzSYSiJOqwyuqnMY0flqn5SCYoWPKYm91P4GgFrHHJp/4hrfQC0UIb4GoqNCAlqJ9ds70bXeljfDkGBoghMJ/MgK8E53p+p7A6f0D9T/xiOXFEZ6rEpncyHdfuNob/GR+0zCCaXtVQR/knNmVML+4Se7DZ40ucco/YaWLIHMLTviJXS/UN8BQILKkhu985YFpUXZfG/803CFOdXGh0IM2E6/l/hjhqVwCkeNUMznCehvuIss/2NuVac5GRZSPCJPxJ9T0nYBZhvbFoDuLfpzpRe2xWpkzGTaSPkT4NDojNcprwQODo+i7Bz30mfB8wT3buV3OEocx7UBQKCOniwodUk6Wcwmwee6tDix+cKz1pQeZzO/RU6NuHTr5A+8y8gAgqxcq8NVBMod0WNXj
 /inn+7PF
 ZuuAqfvEMCLCG+3/lv9kssCwDGxcihzafE60p+EKvVCHFBd+dAXYKvxI9oLGXyUhM0vrqCeVizpptbmg66hLCalQ0885LQtqfJQt8uzZucXhxhyqInn3yTnfuoZJS1Estnj3oRAgKtGAqlc+o4iPbOZqnSc6tUJntMTrwgtskb1+UXKBIveaCzx+ejYh0Vre3HpmepN1Oe+B3i9I4igyv74DkHuGgzfVCxfSAgZaM/zMkkJtHO/9hRGUcIB8OP21qfzV78MWE/hnuYsq1lIt3+krS/XJEf3sRc+y63vtP8TWVNBUwWaXw9sRqNUu8rNrF0F3Z0BmmaKgJDYU+2pxAfdzias2WRt5IYFDeu+cXOqI4w7wP+MsK2aQ3+aRcwvqG+Rm+bZz5mAF+R33cskzHqicRrKDoXiU2pdPW/in0dMjQjCFZHJGWxokIPGJFn4UykmhEgtyTJWaFow+AyeoCcY9gleAwDeWD8fm1+nCHOjbzib7Qf976NBNMgUp1n4rzMybtztGhdPkQguZHjyLTLvujnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 03:34:22PM -0400, Gregory Price wrote:
> Add CAP_HOTUNPLUG, which allows memory_hotplug to migrate a private
> node's folios for the purpose of hotunplugging memory.
> 
> Without this, hotunplug fails if any folio on the node is allocated.
> 
> Add node_allows_hotunplug() - which returns true for any normal node
> and private nodes with CAP_HOTUNPLUG.
> 
> Signed-off-by: Gregory Price <gourry@gourry.net>

after this question:
https://lore.kernel.org/linux-mm/al-pkvmgIxGu3LzM@gourry-fedora-PF4VCD3F/T/#m5b8166212a276fece2380f2dd03d6864375a576b

and some off-list feedback about limiting initial cap bits to active
use cases, I realized that this CAP bit can be entirely eliminated.

hotplug notifier callbacks already allow a driver to prevent memory
block state transitions - so that control already exists.

v6 will remove both the filtering here and the cap bit.

~Gregory

