Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6256BCF45D9
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 23:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C053B6B00B9; Mon, 12 Jan 2026 18:46:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB3D66B00BB; Mon, 12 Jan 2026 18:46:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C906B00BC; Mon, 12 Jan 2026 18:46:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 97DB76B00B9
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:46:45 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4D037C87B1
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 23:46:45 +0000 (UTC)
X-FDA: 84324949170.09.039728C
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 850AF8000D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 23:46:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VaOtEh+X;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768261603; a=rsa-sha256;
	cv=none;
	b=VR9a35ipp4JwE8FZ4UYdtrqKcJAux70CRqVTFyX5H4Sf61w8wpM4M28dH4clFVrQHl9SC3
	YY2pTb6rLVObDiAR+eua2DuQmN1ZVFxnkLTi9QXG+Tr9Pf3MpMPp17bBLGc51Mq2TPqxOV
	+SAJVDkuPdmoTH2S3PhK/cRsLikTPKo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=VaOtEh+X;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768261603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gt/AVyATGJCjg02bpOukDf7tzsy1q7kJHO83Jx5UbtM=;
	b=r/k+bVxBE5Nops0yIBcYVnBdv7VX8mjbG5rVm2bvTNMjaHtJuknmL2hGI+868vUyuRu/iS
	npvME9zOpxaD0XQCRr61WMtcl9gJuAz0ITtEopIc1gFLxmZ2kUwN5L4NNOG+2tUvHBzlCJ
	/N9bg3rUpk/Le24cBAyUaVOzjRsrfvk=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4fb68720518so72350491cf.2
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768261602; x=1768866402; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gt/AVyATGJCjg02bpOukDf7tzsy1q7kJHO83Jx5UbtM=;
        b=VaOtEh+XhXKGyU1Ukm4dxnfsDXwFClnRN7088ydBASzq0tZBl7My7vclWZjlQtBI5G
         hFYCPxXxVXBuOFrZmTZXd6QH/B0SInq5P34+lJkRVId5FuAl7p59w5FZBqjqb3nQEwTT
         uOZULEJGAJFZg2FL1/znOFbhfM6b85T15XAy0yqejhAT0Htkb/fudVwmU7a1e3pguvbO
         2LGFfqg9SFuCHluFgfcn6CK7m/2pX6kOCQ3QzVTbEEn6AQgDDItdSpou4XUcGloSAVMg
         4JIQSoNcpX0RUc5SxY9C8AZZ4KG3zUrN9U+UD6UPGNO+5gVS7WT8cU/68PLnE4xH+VZH
         mSnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768261602; x=1768866402;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gt/AVyATGJCjg02bpOukDf7tzsy1q7kJHO83Jx5UbtM=;
        b=W+9V1P2QHmfSHANSj/0JqmoyF4fKXpPLQsLzqA5JcXZ0FqqD6MXLnXc9OFHqrh2rVN
         ch5VJt7ewKjES25eXvkwZTknovHkwTqTMlyc44h8y2I6upCS15/ce7n2XP67BGJWNhts
         8NhRmm8S2ZcwRIkfeLh6QQB8nm5tt4ZqCw4JJk9OSIOY/Qef8yMxcqsvG6IbdR+Z/Cqy
         EAaI0ZlCtZmL3BaDzr7vpWi81tQRqjOxy3VcRE7hU5UzVYyv9xFCfnVlbEYB2+toyEyw
         QWWKu643kN8+mvFOxdSkrTQ4g5o8NhaSG/RxdcHQ7pMKCro9dvAmDbF6JaIP6BE0SXtw
         hhbg==
X-Gm-Message-State: AOJu0YzzvgniMTHlcF86swTOxVCgeh1MOzecOKT0oB8FkFBwpL8KNWSV
	rUdNvY8JN60bow+ueK5fa3geM6w6gRdYaXlLPenSLSIY5M2YoCsrkibufiBnTeGlds4=
X-Gm-Gg: AY/fxX74tNPTktpi2ZTKJqjBrWspG0IgyST6QIw0s+FlGfYDlj5+ubbSO47754pyVHp
	2BSjv7e8y+0wj17M1VJTArlfVkYpcSf8UJ39fr5d9Zw+LpGw8K+APLe6PTzMKRg8UZskbR5ukYc
	wSOcJCeo+coHg+g5ALpPArLe/MCkz3H500KK+6AgOcT6zN22hxTx/4SD7DzYChV5yJklQbAhA2t
	kLorzmZhn8pjzBZE3bXp3QwUlMmSJ4IBeCeKnbcvUE7WuN2v4Q08FShNrpsj/dgXmv1lJnh78z9
	opPqb3GJthm6oeHSLYbVDy+wEh1RFrqKZOAJEd9AV6cAXeHAKbAmgeSqPwZGLqSthiKdCZVLKXH
	QzSg33TJEeobKqEnO3NnynMkWcoPzvgC+o40jW6is85UP+wIGsaBd7tjnmdo/Kihajw1hE81E/4
	YF1ZTTjMWmfn4u5AIIz7+KzhpQ47ONEq7N7H78TGwppZ2VikDevrX7xFVNRJaBIC0q5PF+9w==
X-Google-Smtp-Source: AGHT+IGFud8YvEm7ATsxYNdlgRbfkjm9D9grRrxO3octkolx4kKDFiysT5UJJvHSioxVBl6DqcPzKQ==
X-Received: by 2002:a05:622a:34b:b0:4f0:5dd:c963 with SMTP id d75a77b69052e-4ffb484a53amr283188541cf.7.1768261602494;
        Mon, 12 Jan 2026 15:46:42 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4ffa8d3d92esm136264811cf.5.2026.01.12.15.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 15:46:41 -0800 (PST)
Date: Mon, 12 Jan 2026 18:46:07 -0500
From: Gregory Price <gourry@gourry.net>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, kernel-team@meta.com,
	longman@redhat.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, corbet@lwn.net, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com,
	ira.weiny@intel.com, dan.j.williams@intel.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, rientjes@google.com,
	shakeel.butt@linux.dev, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, chengming.zhou@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev, osalvador@suse.de,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	cl@gentwo.org, harry.yoo@oracle.com, zhengqi.arch@bytedance.com
Subject: Re: [RFC PATCH v3 7/8] mm/zswap: compressed ram direct integration
Message-ID: <aWWHv-G6cZAiQZJY@gourry-fedora-PF4VCD3F>
References: <20260108203755.1163107-1-gourry@gourry.net>
 <20260108203755.1163107-8-gourry@gourry.net>
 <i6o5k4xumd5i3ehl6ifk3554sowd2qe7yul7vhaqlh2zo6y7is@z2ky4m432wd6>
 <aWF1uDdP75gOCGLm@gourry-fedora-PF4VCD3F>
 <4ftthovin57fi4blr2mardw4elwfsiv6vrkhrjqjsfvvuuugjj@uivjc5uzj5ys>
 <aWWEvAaUmpA_0ERP@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWWEvAaUmpA_0ERP@gourry-fedora-PF4VCD3F>
X-Rspam-User: 
X-Stat-Signature: bsgfii83bwuho7wda8mfk6x1rw1ncoei
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 850AF8000D
X-HE-Tag: 1768261603-982446
X-HE-Meta: U2FsdGVkX1+VeiKfhdg2KXvSL2MLOJGgc+5MMB2mAMe0jOyKI3C9OS2NGV2+3irM/uR4GeBJU3O//ZDY7bvPuFrg17ts8LZQyeXe8vtAbDG40Gf8mzJ5Zdr3oPxXTMRMA/Br3xaZsmoUAioADjKwX/vlFyPjgIdJhocTfnWKjW1EmQTG0KjBbVyFmUiH+aJEUQUTqsNs5KIZNXDchTF0Ivs08koE8kTsIQkUXlenygogwtyzA4wGpQcDQpAGKR8S0WVHGuoMU/vUKdNqgBC9n5Tmr68wEF5PGZ6+qAQR19EQHw56ssKM8Rc2ojoZKpnW+FQvqkfg4ceOd7nZlHno2ZqMX6uI39gBBbI1AWQc1O4XxUDL1ZL9wx7pPpASeVSVXspVRnkwyihx5eun7zNCsfS4RBGKIJBt085wnEL8dW5jfLxwe2tS8RDpmIxnPh3mr8qiUAYTOoJFoxDvUSpjXz7quAvgCm7Y5IIrU8ughjNr3s2GFHlx/8SZqsutSU09CKy3sXjmE9r44Y9uq8t03avB+19D8yY1pYwoevi3OyMrxOAQeP1B1erwnmtAkMnhmFgDsXN4odgk00XQhWnjKB+mGmzKZ2W0lqXw6HewGjc93z0EcVV8BKuasWly9xZXmbTbYGU5vL95uKioefftrgFI3rcLKQ+9CJSvqEhTv4VrPbN9ErPns68sDZ9EVBkl28Tpdpx0O8ErqkxwEntyU5o6McbmXWi9u1pUln/FgHocypfSKN+wmhpKRAVtesQAD72evwV8PmIQIbEHJCuIDCYSse8uQiPlM/cMdswhNLUbnnlx2kJYheBgsuuxXUYkCl5Y81xDC0qkzYwBuoRgtJT/q7BceABgGtKhml4AUhw0lWb5lEl8XyRroe6qYkXNrOuwGqwUgb9lQrj0fGgQOKjjUP/c/cDgC9hQOVaoRQCf0oj0rgbWc6N1l9DV6tBuqTVt8MeasmhT+mXPuGV
 iJ3c7sUS
 5e7QUkjYQCB6HuzDeE1aEnB1MgFInM64xzR8Lfl4uMVbSPx3vrC6wY/CE0qrmioI9sPcKevIy+MRtjgU8OFsD4BzzINuKYbjsxObBoHYkZbLC8c1c2aIlKQCPYGyJ2SN57GUQAmMYNrNurFEyyObhsz+V4zBE8YELGHXfQRg6707q6Oz2TY+v0fuj6mcpAnS5anoch7kJ0j1yb43r4Fm7D/sYY4Z2fYtCS9NhmuUVTmyEi/neE5FvB8v4Io4MdXy2fN3KI28KZZqsPneOy2Jg37xcq8wmO+v69FPxDBqJy4MnySeskJdaIqzgTMS/kZBkWigHX9urkDKG4CTUlTPM2P0chk4SjhpifMuBfo3OAElMa/OsGTxnwLGyteJuG+FZJa88sgx6xQn+VayAeaMJTeeZUA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 06:33:16PM -0500, Gregory Price wrote:
> One of the assumptions you have in zswap is that there's some known
> REAL chunk of memory X-GB, and the compression ratio dictates that you
> get to cram more than X-GB of data in there.
> 
> This device flips that on its head.  It lies to the system and says
> there's X-GB, and you can only actually use a fraction of it in the
> worst case - and in the best case you use all of it.
> 
> So in that sense, zswap has "infinite upside" (if you're infinitely
> compressible), whereas this device has "limited upside" (node capacity).
> 
> That changes how you account for things entirely, and that's why
> entry->length always has to be PAGE_SIZE.  Even if the device can tell
> us the real size, i'm not sure how useful that is - you still have to
> charge for an entire `struct page`.
> 
> Time for a good long :think:
> 


hmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm

now that i have written this out, I wonder if the answer here is for the
zswap_node controller (cxl driver or whatever) to detect high memory
usage and online a new memory block if there is additional capacity
available.

This would look like the swap file increasing in size dynamically,
which is *also* problematic, but it's at least in the same ballpark.

From a CXL perspective, this would look like a dynamic capacity device.

And the catch would be that we would need the opposite interface:

  zswap.c or cram.c would need an explicit evict interface to allow
  capacity to be offlined if the device needs to shrink the "fake"
  capacity in response to shrinking compression ratios.

Time for a much, much longer :think:

~Gregory

