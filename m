Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E3C5C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 01:21:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 391666B018D; Wed, 12 Aug 2026 21:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 369776B018E; Wed, 12 Aug 2026 21:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27F2D6B018F; Wed, 12 Aug 2026 21:21:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E17E06B018D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 21:21:14 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 54968A04BF
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:21:14 +0000 (UTC)
X-FDA: 85094492868.05.1E12C1F
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	by imf22.hostedemail.com (Postfix) with ESMTP id 87FCCC0002
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 01:21:12 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GMK7Dhj5;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786584072;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZGIPGO62vUWJJtnlWOV7HnIzQD6+wbjwlpycp53S1ew=;
	b=5sRcKfoIW8u0R7rEWrp0inPc3sPcpYegA+/Ge9DavSTsyI6Lz+kVeeLhunt65jg+mOTKeH
	K3dfQvDEkecNO6GlcI3Ge9rYqvMGvss0ajrH7Wi1+S9IWOf7eweRu96cx8zrqxTZhC1h+P
	MQ3/D4DhoTkrbGz38nLEZy0Y5l6mzqI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GMK7Dhj5;
	dmarc=none;
	spf=pass (imf22.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.53 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786584072;
	b=Vk3gmR3t557hVyWYPUoOkzM5zY1AhFkOn6fhykYt/pymWsgD9rAmT3/8dljPIUeBOJf0Aq
	w4pIabtWeNFYOwucFBloVu6bzWCiD9S6IhgUf4VZ/E+pFBxgOy+MVrkRJq2bEF27WHKwYK
	l1/9X7BR+ZkQW8CREYcScPYcmCx7xgI=
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8fcc43c48f7so2142826d6.2
        for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786584071; x=1787188871; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZGIPGO62vUWJJtnlWOV7HnIzQD6+wbjwlpycp53S1ew=;
        b=GMK7Dhj5vqItHIw3gebZBOT6rszIqEhU1oS+WA6mwMJ5qrM7tfxU7i/jwcPijSb5t3
         vuaJaYRVAD9UoKbxtEhuX5vyPR/NsMtxzYkvII/7KJSy8T7kB4KWf0GZbg2Cb4oSifBY
         TwYC733RA3tQc9PMinNQrKwx9TGWuFkz+dCehFt/o2lhOxq1Eb3R3oIWCajNcWWTWrje
         qcaCIwQMPKVHVPlxUA3E+dvoXWaGZxGDMjNhm63G0JVIyRtYn+P/dpnW1AC3RoOOPpWr
         3vsOWhQqEJRh54ek764h8BTh0BuHNjuVT/e/2hCUzyxN1p5zakiRhHIprjp7VBcPmvaw
         6HTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786584071; x=1787188871;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZGIPGO62vUWJJtnlWOV7HnIzQD6+wbjwlpycp53S1ew=;
        b=XFfvN6dVlgaDhuaWtphbuE+moyrefZXiXTXtN8n9lAtjyHVDQCFQlQMF+eSbVeJGjS
         Iba6/FDkW+ZnuKRgmN4jwPOCaa9c+7caOGy44DNWbGRRZNZA+NHc+o/hsZ77QhU8pO9V
         IVghgLzgQz9RWZDReJxCm60BsniAXFKUwxmmCbcpLOsiZ06TQYX9um2FhK8+KS+ZPphm
         5x8G2GBf8rHvMfTZCGr9bVSeL3qexUd5JO9fx/Vc+3iudnrxA7k+p74nzGs3Q+GE0UVu
         gIOj6PEkRjOS7eD3nx8ztdB1PCJWfcL0ioTNgbVWRc3lUSw4ZGbnZ9vsAsAKiy9alapg
         wE0g==
X-Gm-Message-State: AOJu0Yzddb53mj/0x8GqVu76/WodCtkvYkTcmOISNeLNU5Ds6TRC895L
	LEwdwaZ9uGT5ZqKKsbYFTR0hiG/9HTyioIoMptOLlnwdfUyN5eh9lEiUbZJ5LnsyS0Y=
X-Gm-Gg: AR+sD11WIKn+fxDwUIrdYSQSs5pw/jR/wnYPfK1Kjr4lTWYRl323DMoPcybiNGYyAG4
	O/rbglCuEkHkN2bazXoYcA+RAgPudc99RZnATa33KqYmT/g0tKLlUVtdkLyAMQAni8EWy6nOnVX
	Z5ybvJt61dmHeFytRK6oFfEhJ6pTr5V0Zsouy50g6cP28bd+w5P8k1mbX0AYA0ids1iNIvv3XUN
	DlivjyVJG2nx/v9Q0/MgZtN6N547ZZ0R278T3261YtoeOIRRUbBD419QVOGgTS0UCU60ut7niAX
	WZSR9+7c94MLQ+EN3zjnPhMTyumoxqqPqLa4qGhLT0PYbWnrdvF0nTEV4ENk5yReyLwLUVbbvi9
	907gL1hJF6WH1ubBabWdsjTVVR50BLFVL3Gy3D0hfOaPl2IlyZ6LOT6Ou1Ip7VWldgevp3EUrj1
	XPt01Y+rVBb071kL8vEBnOCtLDWuoMYoRWNGj8pYQIsVsmzbg=
X-Received: by 2002:a05:6214:500b:b0:8f0:d710:26ba with SMTP id 6a1803df08f44-90a80bb0b74mr17793966d6.31.1786584071577;
        Wed, 12 Aug 2026 18:21:11 -0700 (PDT)
Received: from fedora ([2601:19e:8500:d3c0::28fe])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90a8179e350sm4119856d6.6.2026.08.12.18.21.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 18:21:10 -0700 (PDT)
Date: Wed, 12 Aug 2026 21:21:04 -0400
From: Gregory Price <gourry@gourry.net>
To: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com,
	balbirs@nvidia.com, brendan.jackman@linux.dev, yuzenghui@huawei.com,
	apopple@nvidia.com, alucerop@amd.com, matthew.brost@intel.com,
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, corbet@lwn.net,
	skhan@linuxfoundation.org, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, osandov@osandov.com, jannh@google.com,
	pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org,
	ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, kasong@tencent.com,
	qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	yury.norov@gmail.com, linux@rasmusvillemoes.dk, longman@redhat.com,
	ridong.chen@linux.dev, tj@kernel.org, mkoutny@suse.com,
	sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, peterx@redhat.com,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev,
	usama.arif@linux.dev, xu.xin16@zte.com.cn, chengming.zhou@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org, linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
	cgroups@vger.kernel.org, damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com,
	"Gupta, Pankaj" <pankaj.gupta@amd.com>
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
Message-ID: <an0cAMh_m8ZhGIm2@fedora>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <CAM9Jb+jpJ-Ui4qDHxsp2WiERiv8gmrQfKQ8Z0BmabefeQ6pg4A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM9Jb+jpJ-Ui4qDHxsp2WiERiv8gmrQfKQ8Z0BmabefeQ6pg4A@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 87FCCC0002
X-Rspamd-Server: rspam07
X-Stat-Signature: i51t3o3ohr3x1ig39bbju3fsooycd5zq
X-HE-Tag: 1786584072-151178
X-HE-Meta: U2FsdGVkX1+fEDOoiyvwnMw1pgjzerjdm2Gfi39vtGvSbfapNEAxYl4FXCl30C9gzVUEaqPo4ptvNt6HQZfDt+p8PJpLCbZaguGGxKNi4L3HBtN+jLOHfE7ZjZjx8Q9mzkmd2qi6xmjjXpavC069BKtmyIQqMQjFzkinm7G6Cz2sjhQbAjLe2r4jciYU6dp+olwa9zsOkSsTT/7+3E14I+Ky/hwzabwGLCOymqJ/411saD70rzViMBpOJe+rmNJikOeeEuq5YFOfsebJdstKqG6xvYjjcCYmwtpb5g4ng0U1t0M4QgP6ycErITUZ6EPabY6DFPRYIEs+Zil6Q8L5WGMlszNYmnTLTaRJ9jq4vNDB3j3H42hkN9tM7kTJmeWMGPnHzbKcAdbhl0zVrncf0WxvfdsB6/ikDF8sOxX5tFDHBfSS5Qk3RSi+q7N516lHEWI2UwfVaqoB4DoPAUu38zcoDMaWAsHAHzIONg+z23L2rifzDNcASplAJ6EiMxpTM/oWQ6ZtzW5k8FLRvPdhz6k5gSkSGbq0iqmpW3oeFtAfb5FREplxjOhwE3IMAVaX5Vcddmv61uCaVu6gEdhxFgsEXtA6nubvPdX8FcsaKv9hNojkEWkHjBgq79BZEjggeQ3+7KipUeSTOtVU9Xo0mrxgyRMMDiCUN/bZYbETR1SrQddaGbtqd7FJ2Q9fYx4RaFonFwiZ1KclF64eE1otQpcmqbB9e2ljH/E1zWirbC3boC+0UleZXv1jNmDDTdojNlso2Q85pTyQVhZ1gLqjbBe9ka64Z89MRAaB3ljHFrX3BSSQp+IifazMeyc+55FiOdyhB1AOH853q6znDT3JtkOm/jyhd4Gr0ScSxOULhP0+pdXtX1+7ES6PEfIJeyopz6B1Tiz1Okq+0GNF+PIavOaZfOmmXTtlFLEvnppMXZXUORKTGhhb9qgSalAjT/iUl15OQJwA/jdyxfuPPdN
 Rv8vcRn7
 YAUHUyBCfdj2rzkhFINRiZOSiIoIBoUjnSHsfQ9QHTdTBmIaJhWvGpePVHeex4ykmJEQWzRnDNejfqN2C3BeOe4DEizkT+MB+V6MpsQfvukods3vKShvApVLC230afpyO7wIVp9KRf2B9CQJlqP1qkergb9XBcVPmRwDz3ve6gpn8msDSGqmmZsZTbKg0Nc5i9IBYloLXeDtFSyY2TCAISFdM+A2nAwdoAQuCwMkY/xSs4VzbU+EXQlhzbY8qqU3oXcuho+/IUL+KUrxV5OQOs89Tbm2cusG6eQhEhY0im4unNWobuoL4YmJ/At9yvblsYc1WONag3GxNMKDbJK80CjGv7Ntr1wg0W18yb4+w5l7YAXn6gZdnPCKaI2hCvGzvLzBgGeykLs3z8jQV7boWab4fAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 12, 2026 at 02:01:12PM +0200, Pankaj Gupta wrote:
> >
> > Bonus Configuration: HBM device memory tiering
> > ==============================================
> > echo 1 > dax0.0/private       # make the node private
> > echo 0 > dax0.0/adistance     # highest tier
> > echo 1 > dax0.0/reclaim       # reclaim active
> > echo 1 > dax0.0/demotion      # may demote from the node
> > echo 1 > dax0.0/user_numa     # mbind()
> > echo online_movable > dax0.0/state
> > echo 1 > numa/demotion_enabled
> 
> I am bit confused by the HBM device example being discovered as a DAX
> device. Is it to
> only to showcase the use-case? Or we see HBM device is actually
> expected to be discovered as
> DAX device with N_MEMORY_PRIVATE?
> 

"actually expected to be" -> no.  there's no requirement HBM be
discovered and boudn to DAX, DAX is simply a convenient intermediary
to memory-hotplug.  This is at best a demonstration.

A device driver could very well just call memory-hotplug directly,
or its memory could be brought up as a private node via a boot
paremeter (which I have sculpted for v7).  The former is preferred,
but there's a bit of a chicken/egg scenario for bootstrapping.

Most of these UAPI extensions are going to be consolidated into a
debugfs interface for testing purposes only in v7.  I've been working
on aggressive Linux Test Project test expansion to ensure there is no
UAPI regressions.

~Gregory

