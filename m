Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03A3DCD5BAB
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 01:50:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7D726B0092; Sun, 24 May 2026 21:50:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D54BC6B0095; Sun, 24 May 2026 21:50:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6A506B0096; Sun, 24 May 2026 21:50:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B56BB6B0092
	for <linux-mm@kvack.org>; Sun, 24 May 2026 21:50:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BC40140DAE
	for <linux-mm@kvack.org>; Mon, 25 May 2026 01:50:13 +0000 (UTC)
X-FDA: 84804261906.15.D977AA6
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7331D100010
	for <linux-mm@kvack.org>; Mon, 25 May 2026 01:50:11 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="lAOrZW/V";
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779673811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HaMGwylp+AdTKGZZEDuVzWMLLa2CVFaFeY7VVe9bsb0=;
	b=uaH4WyYLCzuJjj1lCYggICDZ6yCRG1hvYY0KEtOp1KhLSRivFm6UEoEb8ZL4yGLEPUpgnc
	zxgFJuq8jVZKavGi1TqfCAija8CXHhn4ocZpkf6YcIl7DbsIWFG42comnKhRjrYgAcnXSW
	iNsyHDHOMom2OdAIBJ3e75FWjxhL5SA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779673811; a=rsa-sha256;
	cv=none;
	b=IgdMHy/prXbq5YTAIBLF4yW0NgEIUI+veNcwWpe2AKD7vz/h22JUXsf1zdluQCOwiJ/q0w
	Zkofze5qPeW4Y982DA3CzQ24Bwiy64AS15PwTWfNn405BNp0JXTMW0vRcsX5DgXejzlrhp
	d89t5dHSZi1EzlwluPoATpCKY8kXiGc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="lAOrZW/V";
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50faeb8317bso84368621cf.2
        for <linux-mm@kvack.org>; Sun, 24 May 2026 18:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1779673810; x=1780278610; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HaMGwylp+AdTKGZZEDuVzWMLLa2CVFaFeY7VVe9bsb0=;
        b=lAOrZW/VLF/BwDhtK17Wg3XJ7l0EYpdpH03qYAnfi9fpcd2EMNIvD1byCO/EgINzmb
         XYSJtkZKT3psxX/NvLh9xK8pDrnpjViS9rt7Y0VxR+yaVREKC9PtH3VV2PEWP88944iX
         VH1NTtguvx3D3S8EXl1DVIRx5GILH9IbwMBgyuvobZYhDdq6fEJBy6eVTwVF8kyWlefh
         6Tiq8kDh5xDpqim6Vc9jeVJLqwN1rRuLm05wHXVjKQHvbLsEIXVyu7qWH3Ir74rZT3RR
         jzwXpYcZTQmxEX2K6KtJQsGQjWuVpcZPpF/ua5FLlJYcZDsoVt9Ir2XEO+utlmDafNfL
         gkhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779673810; x=1780278610;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HaMGwylp+AdTKGZZEDuVzWMLLa2CVFaFeY7VVe9bsb0=;
        b=gtUuUj+wzJXX2itjAaUnxVnQwhJ/wJxfbasFNuCfzge+XF5lp5S5VIiGxqy06TBO4E
         VHjVmUo2YKYJ5geaB7tG6C5JAW1eNcKbr1ZJIgDMIy3Y7msWRp/pVG3Maao2A/O1S+rn
         BGkjFUTm9ej5z/P33Ol+ZKzUuVgsS/CjzBBU/RynBDQ4nzZDOEocHBM9NU7Vqm7x0zGr
         4VEUAIVZZEtoir8BHhRS+/qa9ugjAzL4zLoIh8bJ1fxrC38uHt2w83i98n694RqyPWH9
         f778CJRz5dL+2hGit8T1nmL/HGSZtM0aOUg6V5qCPPqEDTk7JFzto8e4aQOmvZFLR8tI
         ZsBA==
X-Forwarded-Encrypted: i=1; AFNElJ8HnDzI8M9MaNqH4P6lSntT5UzCbSEiuO3rSNf1+Z7vXvFMZHZ+c8zxPZ4Xl9xS1YX498fLpe3VKQ==@kvack.org
X-Gm-Message-State: AOJu0YxNyjJaHFXp2ldZBFRkVX4tZ2QAE9k3KLch5P4jxPprjsh5BHY8
	fAK+Om5QTQp/9qDgHfx0V5Bo0145Vf9yry+0u+HmdOjX3bZuLKFVRyLSh7qTGn48CyI=
X-Gm-Gg: Acq92OFPd67rJzI+/z1KqUCacTPv7MmBYZ2OzTlGil3Fu7z668wSuIeudjrcgOhVV9a
	r78AOX2Fa35/g5q6Pi/2KivIgFf8u5e8RYNvXadwEOfs7Bd65Wt46jE8mE0L0ncBWActUn4q4L0
	3OrLf/xby/AW2XeYFjkpA/Y7Y2Ma+jj5QXauHYPfMbdreoHc5T2L59vc/w/+1XQhJ8aD/svtPFo
	pGe4CZJ4SWNgxU4B95IyAvpSWl1r9cqF3IKqXGUDjkK7pcCUtE52uYBvytYqZYZn06gia4wtCMs
	YMnlzoH1UyZoBwu8Cp+UfyqxALCh+xG64vq4WOtup7VbfUcIwYEgkjCJQkwCbm/EdfAv/kjPYLi
	HMQX9HKf3qAURu6qPwoyvH3u2zraVl3wgg/JrxVfBD4mVKzSKqGqB3AGjcInbe1eNxIZGURWFWc
	+jiAUrNF/Y6udBhxo2ym7CKZesTpfjXzymPBdhzI50GdNWrisDUN0nvXNHsKcz5dI94Dx7Kp564
	BTKvEqWycXC
X-Received: by 2002:a05:622a:480a:b0:516:e7d0:73ab with SMTP id d75a77b69052e-516e7d079c5mr94541371cf.40.1779673810351;
        Sun, 24 May 2026 18:50:10 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516d8cb9f11sm88159681cf.23.2026.05.24.18.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 18:50:09 -0700 (PDT)
Date: Sun, 24 May 2026 21:50:06 -0400
From: Gregory Price <gourry@gourry.net>
To: Balbir Singh <balbirs@nvidia.com>
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
Message-ID: <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <ag6XyvxR-NU5rGn-@parvat>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ag6XyvxR-NU5rGn-@parvat>
X-Rspam-User: 
X-Rspamd-Queue-Id: 7331D100010
X-Stat-Signature: kg1mtdwcwcxuukjkrdhdys5aokau7ey5
X-Rspamd-Server: rspam06
X-HE-Tag: 1779673811-416297
X-HE-Meta: U2FsdGVkX1+hJkcQD5SYV2WHXNUcBBi/9VSH5AdEgmoLlR2MZaFVIxv3cuNSsyDQnef8wnL6iFEhvnoJqcibKSXNHV+CJPlsaCny7ZjwdKHJYlgv+D7i7u1LClAAZ/qSaJYH5+4Yj5aGUmUeOWKDLfBsZdLLd8K24+pgfSDhpBCk28Uy4yaz6M9ad/Y3/2xWtRj4lIvyFvBE6T6QnmxrSKaWSR7q4oVJHtxhAR99/Z8K5VxjQpwOH08/ar6uB3r5FQqJZkUXCABfki8QPNZXtEvDKnr93VvxreHIbFzW0dUbbO6Y9mRgkGe4BtPZEs1xKje+dNnMdj1lDKzYR1xm/Hxj9WdXZAEPa+z8YXBZZgMQB3T0AwfEEjcY/jhm+H7/DgCCVWDKT7xmxcthMNYonHZPaukLtMtTOl9oYjksYa5MncU06xPV4545EBmfdO7cl91ANSwodu83qgBPpCt91QoExRrtzwYscy3eeyojBAECkQcp2bIip/EcgVOttAR9XKygDYd4x8B7qMSeLQVuerRKaZ3TrWigwj0DPH2iVvCvW3HNlMzUW8tNTG26MgtVqnHXsrlfnyajrmurcsaAGgSJcdBXAcOou3dTzjPP4lHkN+ej+8LDIPoiC/nDgYWmNrVmUzAWrosld5JR+5FSjALRu96QtvwHvvvKKt8qFPoKlPb+zfsUmdjtXp6xzeusZAqvWI1ZzyT4W+s0+k5g4X41EOpofwjtvbumxWAXFu4cqwC3rAX0C2STs4Nw1eCwZ9E0lMj4YmXAF4Pzc5GqBK4QjlgNDD292VaOaIp0lZAHkvnL/cU98HQUO5sPM3JroU85uGy5d0Rh5TkwfIGbDsFRsmw7BWanS0ng8AOZ7QT5mtmoaptxGTFnou9pFgjELSv9smFD9kVhSq2k+POql8kNRISZiaJQMGzqE31vd5Bo3/A0pLRwj2gZXrznNNgtlRLMakt3y8msqmghtMc
 LiBG3U9O
 BIcpo0rCnuhDIW4VpYUwwnZROW9vLHugoQcBx7VrumBFcYbJRm4idQaUpl03r2EnSSDnOU3asp3FCxhE2qgPaoaCs+Kdyn75KmDD6MbMtbewMkG3jH+vzTMM9KpXF5oyzNFZBdaafUr32hj0TmpnTWBFuc3WJvckRhoziHmTSNzuenSiO4xo3YR6PmMV/3jT/hPRKiYvPWr9Fwv1JSCwcKEDrihrSx8rklii4+IJI5+PDwFGQdsk1mjOoqh09XDY0a0XquqB8JEfowmHcBPdOIXBDDMOldvEDLXuLRookgi5gpNCxjoVqNbmMHAgxi9hZ20baVS2WyM60PRhTfuneX+eCZrapgoP7FROX4p8Drqg/Jbp0ulU8DTKvmCa8Gg5tTPk/dqVa2bjtnt6almZVi9AvqwBxjQozAtijpImFBYk6Ufa8sIq5ezT1s3FC7ESf2NHdnQPiOQQU/I6PHdGPKNsGU3s5HM7KkCd0SZzbfl/q1V2DrD7pihWHaQ97CMzQ6j3F4Ho67yC0/QOh7KNxb+QR/NVmXRQv9ZBZQR3689SrizuXS65IP3O5tm/aI+fBYJba
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 04:23:28PM +1000, Balbir Singh wrote:
> On Sun, Feb 22, 2026 at 03:48:15AM -0500, Gregory Price wrote:
> > Topic type: MM
> > 
> > Presenter: Gregory Price <gourry@gourry.net>
> > 
> > This series introduces N_MEMORY_PRIVATE, a NUMA node state for memory
> > managed by the buddy allocator but excluded from normal allocations.
> > 
> > I present it with an end-to-end Compressed RAM service (mm/cram.c)
> > that would otherwise not be possible (or would be considerably more
> > difficult, be device-specific, and add to the ZONE_DEVICE boondoggle).
> > 
> 
> Do we have updates/notes from the meeting?
> 

I have been on leave since LSF, but I do have some notes posted:

https://lore.kernel.org/linux-mm/af9i7dkNvGGxPHzu@gourry-fedora-PF4VCD3F/
https://lore.kernel.org/linux-mm/agYJcRgOHho8upVv@gourry-fedora-PF4VCD3F/

I will be trying to post an updated set stripped down without the GFP
flag as a first pass w/o RFC tags and no UAPI implications so that
device folks can play with this upstream.

I'm debating on whether to include OPS_MEMPOLICY in the initial version
if only because it's not intuitive how it interacts with pagecache. That
needs more time to bake.

> > 
> > page = alloc_pages_node(nid, __GFP_PRIVATE, 0);
> 
> Do we want to provide kernel level control over allocation of private
> pages, I assumed that only user space applications? I would assume
> node affinity would be the way to do so, unless we have multiple
> 

alloc_pages_node() is the kernel interface

> > 
> > /* Ok but I want to do something useful with it */
> > static const struct node_private_ops ops = {
> >         .migrate_to     = my_migrate_to,
> >         .folio_migrate  = my_folio_migrate,
> >         .flags = NP_OPS_MIGRATION | NP_OPS_MEMPOLICY,
> > };
> > node_private_set_ops(nid, &ops);
> >
> 
> Could you explain this further? Why does OPS_MIGRATION
> and OPS_MEMPOLICY needs to be set explictly?
>

Both of these have been removed from the upcoming version, but in this
RFC version i was testing OPS_MIGRATION as an explicit flag that meant
"migrate.c can touch the folios" while OPS_MEMPOLICY meant "mempolicy.c
can touch the folios".

As it turns out, OPS_MIGRATION is not a useful filter, as it doesn't
actually filter anything (anything using OPS_MIGRATION would also need
its own filter flag, so better to just drop it and do per-server
opt-ins).

~Gregory

