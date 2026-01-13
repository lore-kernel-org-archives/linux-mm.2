Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F16AD2D108
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 14:22:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D757A6B008A; Tue, 13 Jan 2026 09:22:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D60E26B008C; Tue, 13 Jan 2026 09:22:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C764E6B0092; Tue, 13 Jan 2026 09:22:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B59DD6B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 09:22:18 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7FB36138AA2
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:22:18 +0000 (UTC)
X-FDA: 84327155556.27.A0758B6
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf08.hostedemail.com (Postfix) with ESMTP id A64F216000B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 14:22:16 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gxw7f7oQ;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768314136; a=rsa-sha256;
	cv=none;
	b=3sllVN64iPAJBQBtZ/LZgHNvmW5py73Fla3wthXO0zpvvDX8O8woGcjxK2kVUUPHfFnwrb
	ti8lE2NoJkrFVxicLbkxu9UF+KutqHtjVU/f63ZLPKP6ZlL23K9oxCzt88AfHbYpeVS8+8
	g/8qB7kk/v7f75j78tiA67XAGPxF2XQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=gxw7f7oQ;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768314136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m4O37FQr+LOdMRqQ+TweaC2/Sd4OM2JtWu1rpX/F7Rk=;
	b=FylhRlBAx5irATH/F3jB8Hu0uk92dDsnbZa/fOLm5SPW2a4JnshXXNlqT/WezVnWJoq+fi
	qfPlJs4c7v7Wv+KP4kH1zt+wbV04aN3IF2cNC9W0fCxqyeu3MpG2URBrhuhKR13CMX99Q9
	7Q9+Z/31z3EgcElfwxsB2XLtH5czozI=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-88a3b9ddd40so45223606d6.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:22:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768314136; x=1768918936; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=m4O37FQr+LOdMRqQ+TweaC2/Sd4OM2JtWu1rpX/F7Rk=;
        b=gxw7f7oQ65TEIMD97w+6DO5soCUXUKQkzDM0KLuof5D7di4axSbMRKTfi/Kh+L1ggM
         hpiH2KrN1+NMhtyheunXU+Rf3CnabYotSnIeOJ8uC4pbU/+QrAQeDhJSX7rFaf9QzXB9
         J9RBRCC2+7YYPQgAkMhyK/KkgoRpRawVt8wpYZCydgmBf+XvYUYGyulacj8o93ym2Chy
         uQUC95dpqKtU7Z8Ca3vm/yxiJnKk74vsCmaSM8/0rpr61OvnzIgCIjvwk6CnVNz2ufo6
         BWMNs5Z1dw0KakhHjGsWtISoyZG6BVMi8rJTMITmmKJp9i0sTzzzYEecdrLD4wlLoFVu
         FhfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768314136; x=1768918936;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m4O37FQr+LOdMRqQ+TweaC2/Sd4OM2JtWu1rpX/F7Rk=;
        b=KFtbQru3oYWovRtkNHFeMHQYMDu3eHRrfzhHLu6CD+iFRMZEMjaOIpxc2Ja1sUFn8u
         sEqqXulFskI6/p2OoED0Vne0lZrXZertDpCvEpf+h23VRzL+5PO0V/75qg1bIMl5bpOM
         N6HLVJpkosKFmQrecoWQ1WnPYjLuTQTwUgAHYg2h234ijs9Ev4kAP0TIHxLbQ7YMzEcE
         S7IwTUsXc+CYD+S8W6/MMakRUl5zR0GxoSi5HaKAGZqovwEsIoA9FjimwAgWzRng4doZ
         /J2L2PmpmQRiyVX9oWinFZynkO1/MWmN0h18H/cUELz5rQ6yvRHygXtN0hWK3YHRHg7u
         5STg==
X-Forwarded-Encrypted: i=1; AJvYcCUP2v6ZHtCO4ow8+rk4H+Lcv0QJ+zj1RFMpxT8ItcfTWsNChALNZNCjMYKq0K28vdq22JZ0AcaITA==@kvack.org
X-Gm-Message-State: AOJu0YyIPkrtP1mOb7vYpBSZZoqyN4PYssVIFg5R6joDBJqLsGympzJo
	A+Jmafu/9IeX8tKgAeyZvnx93eaoUOR+HZmWeVuqQtat9TtM6TMDhAGL06jzd+ZT6NQ=
X-Gm-Gg: AY/fxX4oh3TV7bkSz1wUvZuP/YywBPBIbZehEFNSlabeuFG6B9Yf/0iM02EfprujjuV
	2CdKvP6ap+a93Ven8NDIHNZDplFHLa+9OqoBvDd2QjIPyW5u4lIDzgxWFlySZ4I+lhOMwa+pFzc
	8wflBOcjFMaA4yLjIgDO+sjuqwURqOnhbXQd2d6BXoc2zhuapeABeBsdBNoR4sNeElMGSyksqAN
	EnKwYh9zwHU+Xrp3lxiCthJDXVMw4XSSWSu71zZHRpFqZMQ6vqkBXo/wqsBdeC9LYyjkISx34Nb
	jU/QvigsPicGld8yWf3UE4KYyYSUz2UYQqXy1jh0YICJjhiJQnwGXUlzSMz0HwP5ciUK3gMU/nL
	eHFfvciMwncLf1DtF3TWj9nWInEO8rnu/IICpNJU4yV3zpQwaS14G48e2O8nsPAq7kG5IRIuAIQ
	3+j78sm9XYSmXDr37kZdLw6G8YU1l10z41uwwWSjckbTSfaHKbNrcIiePIoASUxi9EG0JnXA==
X-Google-Smtp-Source: AGHT+IFjEUG/kkt8lULhTKW8EjcJ76aqeW9gt0lwSGT7fyOizprTUn0Us5awKcQHUHtWfOIUP8T8rQ==
X-Received: by 2002:a05:6214:5090:b0:888:8187:1547 with SMTP id 6a1803df08f44-890842a23b8mr315841516d6.48.1768314135363;
        Tue, 13 Jan 2026 06:22:15 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890772681desm157803516d6.51.2026.01.13.06.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 06:22:14 -0800 (PST)
Date: Tue, 13 Jan 2026 09:21:41 -0500
From: Gregory Price <gourry@gourry.net>
To: Balbir Singh <balbirs@nvidia.com>
Cc: dan.j.williams@intel.com, Yury Norov <ynorov@nvidia.com>,
	linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com, longman@redhat.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, corbet@lwn.net,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com,
	david@kernel.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, rientjes@google.com,
	shakeel.butt@linux.dev, chrisl@kernel.org, kasong@tencent.com,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com,
	baohua@kernel.org, yosry.ahmed@linux.dev, chengming.zhou@linux.dev,
	roman.gushchin@linux.dev, muchun.song@linux.dev, osalvador@suse.de,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	cl@gentwo.org, harry.yoo@oracle.com, zhengqi.arch@bytedance.com
Subject: Re: [RFC PATCH v3 0/8] mm,numa: N_PRIVATE node isolation for
 device-managed memory
Message-ID: <aWZU9YZLmpX7wxbb@gourry-fedora-PF4VCD3F>
References: <aWUHAboKw28XepWr@gourry-fedora-PF4VCD3F>
 <aWUs8Fx2CG07F81e@yury>
 <696566a1e228d_2071810076@dwillia2-mobl4.notmuch>
 <e635e534-5aa6-485a-bd5c-7a0bc69f14f2@nvidia.com>
 <696571507b075_20718100d4@dwillia2-mobl4.notmuch>
 <966ce77a-c055-4ab8-9c40-d02de7b67895@nvidia.com>
 <aWWGZVsY84D7YNu1@gourry-fedora-PF4VCD3F>
 <69659d418650a_207181009a@dwillia2-mobl4.notmuch>
 <aWWuU8xphCP_g6KI@gourry-fedora-PF4VCD3F>
 <91015dcc-6164-4728-a512-1486333d7275@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <91015dcc-6164-4728-a512-1486333d7275@nvidia.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A64F216000B
X-Stat-Signature: b1u7nprxxxarkw8hptyfqsi5ofkgk8ak
X-Rspam-User: 
X-HE-Tag: 1768314136-708125
X-HE-Meta: U2FsdGVkX18QjokCq8UIUE+h/xs8D3xSsxBWG0+hhHBo2CLKzCZ0w54vp0dYscheYvO/qEsgSoDiEidnn5XEOouCPSvouc3B+p0KPOcwWVxJb9JlmIJfCamJ5MsMfORPkXK/QLCOWP7dTQMwJXNbfCed5rEcoJ9OSY+y/6g4yG4a0OyrLdEcNuB95Dxaim8TP5GF8Jc8Wbxq7l7d7cbONbK7JO4dNZtgrLVWVmoOz6TUdtEMSf5FD7Z8NSiB59NYx1AJ2a22R6GoG3S82BOdekntZeNgIFiRRYx2gaV6+4Kx71Zgf0C9Lewk7JmFb/6kVYPy9U9KFkxIRBovGzsTabFykIDpFU+ufSfeq1hKSLZzERng+1s35aJaJwZ26spZrFm1NGOt3jp6pW0pe+RiwxZBY0TWuIJzXZga8NS0KLkrgIb532LruW6lvVXOT2zHJGosagqgXmf9JdMszjtfYJW0I309q2ehDpmtTVSnBmo4bGTR6FX/ba4iOlHromvJL4D/hMNZCEg5maKdmMaxNLsTeLbXdr5PUmWbjV8zFeNAZz7FhhYaGbtBRTDNKePAB4V/8xnOGNN9hfqJHTft3sJueFiHRrSdoFt8C/uRjPMXbAcHuERqW7drs7bHpb3HecyjfAMCSjmWgC2WrPca7GOSTZYW1jsQLCqpn7eQfVKj4i4wJc3f0PInCLlkPTxsIvBBPTx/nNpvL2mIWKnfXhL3dJsmTVFsW75sWEGVmw+3fN51cfmRB8IXs7o9OzHB+9L033kGxhot5/GhNc3FyJsGbLLPpsyiVE8ZSyYy16XccZB98lcEzpOvu98ZSLsHpYvyngQzTX+ek/xPyPN6h9OHc++QudecSIkhzkN4qjJTX9lMhkoCcK1/bQjo2UXAru3b/SmslHNEb56WXqcO82h9zZgL3lbSTuNE9UZZdVwQ3RU1nEm+7UPumZkTpWJ7uNTbkpvgkxQesdipwuN
 MRxEgcoi
 9ZmTFtW20TTwEulCsP0AYH7zTEUMGiN+uMQXn6OjjPfUHYOHyNGE1pcuRPzd924Aqs1A7usoQRbHkF2IqHxytLB6IaNU3IY81ZGb1oV7h7M7euhmu9N2M1g9F4fjZZHG+GepKRZRkMuTvw90sjwHtWjgZEO1fmiRV4y+NkNb5atxaPlD03xfHrxg8ROFILiPQLVOU+VlLFoo0cP0hRP7s6JgF3uVtHzQ6xDoGu0p/RX4zh0yz3xYZxAi/tFd1KJCzKNB+NCqnpieZ5y4RoN9+ZMB8d9XFT9ML9LrTfg/jnfb9q81I9c2hLANwUgEfvNAwHL1vdA4H8RJbH6JwHH5mk6G3/isZCf7GXLxBJoNZ+1OleAb/Nk0D8HQ30FMMWv6J6eR+oaXmfeGTM9mEQSk7mu0pTqZkJ/mgBHJkUFvBE6n5MWpJbAzchMblPjz8etlU4uT6pGHRXbsyUk/UVSTrnaLSbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 02:24:40PM +1100, Balbir Singh wrote:
> On 1/13/26 12:30, Gregory Price wrote:
> > On Mon, Jan 12, 2026 at 05:17:53PM -0800, dan.j.williams@intel.com wrote:
> >>
> >> I think what Balbir is saying is that the _PUBLIC is implied and can be
> >> omitted. It is true that N_MEMORY[_PUBLIC] already indicates multi-zone
> >> support. So N_MEMORY_PRIVATE makes sense to me as something that it is
> >> distinct from N_{HIGH,NORMAL}_MEMORY which are subsets of N_MEMORY.
> >> Distinct to prompt "go read the documentation to figure out why this
> >> thing looks not like the others".
> > 
> > Ah, ack.  Will update for v4 once i give some thought to the compression
> > stuff and the cgroups notes.
> > 
> > I would love if the ZONE_DEVICE folks could also chime in on whether the
> > callback structures for pgmap and hmm might be re-usable here, but might
> > take a few more versions to get the attention of everyone.
> > 
> 
> I see ZONE_DEVICE as a parallel construct to N_MEMORY_PRIVATE. ZONE_DEVICE
> is memory managed by devices and already isolated from the allocator. Do you
> see a need for both? I do see the need for migration between the two, but
> I suspect you want to have ZONE_DEVICE as a valid zone inside of N_MEMORY_PRIVATE?
> 

I see N_MEMORY_PRIVATE replacing some ZONE_DEVICE patterns.

N_MEMORY_PRIVATE essentially means some driver controls how allocation
occurs, and some components of mm/ can be enlightened to allow certain
types of N_MEMORY_PRIVATE nodes to be used directly (e.g. DEMOTE_ONLY
nodes could be used by vmscan.c but not by page_alloc.c as a fallback
node).

But you could totally have a driver hotplug an N_PRIVATE node and not
register the NID anywhere.  In that case the driver would allow
allocation either via something like

fd = open("/dev/my_driver_file", ...);
buf = mmap(fd, ...);
buf[0] = 0x0;
/* Fault into driver, driver allocates w/ __GFP flag for private node */

or just some ioctl()

ioctl(fd, ALLOC_SOME_MEMORY, ...);

The driver wouldn't have to reimplement allocator logic, and could
register its own set of callbacks to manage how the memory is allowed to
be mapped into page tables and such (my understanding is hmm.c already
has some of this control, that could be re-used - and pgmap exists for
ZONE_DEVICE, this could be re-used in some way).

~Gregory

