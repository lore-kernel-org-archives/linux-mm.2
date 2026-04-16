Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45852F8D76E
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 20:23:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48D596B0005; Thu, 16 Apr 2026 16:23:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416ED6B0089; Thu, 16 Apr 2026 16:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DEA66B008A; Thu, 16 Apr 2026 16:23:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 197456B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 16:23:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3242213AFA0
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 20:23:17 +0000 (UTC)
X-FDA: 84665543634.11.B8477C3
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf11.hostedemail.com (Postfix) with ESMTP id 37A4840012
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 20:23:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="MULrlnn/";
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776370993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lQIC/zWz5OJ08TBOSJwx1m1q+xpY5Pl9ONSV8Ev4djw=;
	b=5V7D3NFOckxTdy2Etv4obmOIS1tkObCoX+lxQZK/8Qgx4zWnwDRevR0FbZeKdWIvv5mg3A
	kDNSxSQL6p3qgdNULPWYw2ktVY6Ck0ZL0YhnFzKNs4LrrOEVee/Zg80ATjyVH2KttFghBm
	mQ/VruLER+eLTpYzJsH0UtqTfaCRSJY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776370993; a=rsa-sha256;
	cv=none;
	b=wDxlp3XktFj0Ft8pPE2STEAEX5mWS8cWsZvCbenS/ftPidpYRpXIpjT6TUjEABXFptpW3s
	UAgUMq0qS+rPvlW+zXltzpuOwgRshcz0GPt1HGP3PJCMgetEr7oIcL9jlTAaJMkHvwjG+Y
	2nkDxO71SdHs6hGw9p3GMiLDcO6ZhhA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="MULrlnn/";
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50d87610513so82040701cf.3
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 13:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1776370992; x=1776975792; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lQIC/zWz5OJ08TBOSJwx1m1q+xpY5Pl9ONSV8Ev4djw=;
        b=MULrlnn/71M/p1RgoRxMI9MfVXVjGiHirHj4/3gAiBv+jP/ZlDYVNGVsHJM3cbaGSE
         Rv3qaGjV1DTLheUS5hO6UHf9y3AIM3ZNYx9ITH7kBiw10fFMHvyl3Pl78mLjKvgpWkNS
         4goBwhnKo2kjn8h2oNCZEiA776lD9+4AfhyoMknIeESYFkKRjwYM+LuRuZxLThwMjfNR
         7qR2b8i7A7YnHptJw07t/e/5of7jtcpTPa444W+6UhuGr2bttVQkB0ol9FLps4F3a8CI
         MJhUWN0WemUExKJ0F7o0s9YkBBfrshtYZwcDb0r4fYjmXQaH2590xv9731ifAihzkEa6
         Vajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776370992; x=1776975792;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lQIC/zWz5OJ08TBOSJwx1m1q+xpY5Pl9ONSV8Ev4djw=;
        b=ZkXpotMBDVnb/0pB84qQ68FRcpr7CekCcRx5RK05fvRWAVfl2s3olzO3J2OSESJBwx
         B9ICvu9KW5ykCe6DQDxJV+QO4kCS3bzOUx/gUsuY7BQZ8PqGd4XwdrmEDst8cu2TkveU
         +coss/QnxtKbcg7VnwikfIPSPqzYpQFXCr7/8zgXuMcee6vU1mN9MYZzuGtoWkBwO1MW
         rfHLQx+kzRnaosgebundyalLVXk8J1UPr7nVtMrh1DWBQ5a5QsZ+BpTZjFZ0rMTPnI4L
         p1QBK7WTsZDRgV6FVLE3ujKFzmvlJLq9Q7aI5/+lVTftHT9DxRoH+dxQ7S4kQMRmlr6J
         2LHQ==
X-Forwarded-Encrypted: i=1; AFNElJ8/jPJJVlZ9p05k+grxtUa4fCG6e7xRbrUBzbYea4u7LwESIbygWnzJcUUKZtExEwGnHEzVdelibA==@kvack.org
X-Gm-Message-State: AOJu0YzEcC+muG+GxxhoQWEbF6jav+d5HLFkCH/d6HRwjxLcP361NEXK
	HviWDvrP8GB+iyr5UB9OTg4txHqOogjO4+5OufRxzDbvQvw0qQH2y9+zvU0DPF1FcNw=
X-Gm-Gg: AeBDiesFWwEU/Cl7ZxngA48neFaFXCcbhIMVW3pxwCLe+PB23U2gErLjEfpwCJR3twJ
	x/N+rRD3Ft4Ef55WiFoyfhNCWfX1gwBRS8C4UfPK0Webkwmeghjof+6KdETTOEcT0Nxspn80i9H
	CriotI4ZEo1Niu+xBRD45QRyk5cpHmwSKFhKF3XRsJ0C4IJxqDRHrcUF+Yo4NhqwJdsqZVEvHiZ
	ylipsT9/wi1/aXBAGe6yJW7NiELVnpWo+2OfMABVEGXSsBXJdTSoOczrOLGeX8Ew24bRpi36K+L
	icLPk422INfdKcu2BwQdKMnKsSSFMw/JOQzUjsATozKvwzVXKoayrtUETCFaEtW8QnHnBjTK9AF
	UPtwvZtbyoc/LemTEVtwvQgC0y8jILbVl8ITIUdWzOwDgNXZsZ17elQfLpeEfAWBm8plGFlreKG
	iaXFQiCyp/F2N/Y56D/YfIvq2OfYZiBw9SWHBS0W5XbIvyQvzf
X-Received: by 2002:a05:622a:7917:b0:50d:a7d9:d9af with SMTP id d75a77b69052e-50e34a76ca8mr7683091cf.53.1776370992242;
        Thu, 16 Apr 2026 13:23:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([2607:fb90:ea1b:4643:9f36:3ffb:fc60:9518])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50e1b0063easm49480691cf.29.2026.04.16.13.23.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 13:23:11 -0700 (PDT)
Date: Thu, 16 Apr 2026 16:23:06 -0400
From: Gregory Price <gourry@gourry.net>
To: Frank van der Linden <fvdl@google.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, osalvador@suse.de,
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com,
	sj@kernel.org, baolin.wang@linux.alibaba.com, npache@redhat.com,
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
Message-ID: <aeFFKlSgOctW2W84@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <3342acb5-8d34-4270-98a2-866b1ff80faf@kernel.org>
 <abwRu1FNqI3dVyqL@gourry-fedora-PF4VCD3F>
 <2608a03b-72bb-4033-8e6f-a439502b5573@kernel.org>
 <ad0iT4UWka3gMUpu@gourry-fedora-PF4VCD3F>
 <38cf52d1-32a8-462f-ac6a-8fad9d14c4f0@kernel.org>
 <ad-r7hwIdnvKsrh9@gourry-fedora-PF4VCD3F>
 <CAPTztWajm_JLpp9BjRcX=h72r25ELrXeGkOXVachybBxLJGS=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPTztWajm_JLpp9BjRcX=h72r25ELrXeGkOXVachybBxLJGS=g@mail.gmail.com>
X-Stat-Signature: decgpdecpkikhqbjsug8ipugr4qooya7
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 37A4840012
X-Rspam-User: 
X-HE-Tag: 1776370993-262322
X-HE-Meta: U2FsdGVkX19UJYwJSp0rt732eHJ8Q1dCJn64WTafjHvcoiYZTpqVbUbMNF5R9GC49wvkvK8teSfyVQCC/Lg0EPUq9REAGFLdrlRpp1t+njm+N7d/V3yrZ0JHP/XpxR3UdOczUEBAwknLGqCROLRR7tsi7qr95l+mW3ri4AlLdjyeHMqSmwGr2AzOwpKe3d68faS/vF04ypx92XeP9y5x5Um0fRPJlwYTqNl+GlfT6b9rjD6dU1EEdR5BsGu+n9oor+NVaJnBydfbCmLo+MD8ocUqJNf02KWooVmogqdGnIiEhpMHjDRQQQQmJ6cKhvKr2M6NHhu9F6YGZ9mCnpG18eZ+cXnNnH8PK+0fyBF/X14MzPiPqJLKxzJMmhFqBxMQvJUjYu47LT5QT9VcC5i3yKC5cVGJgPUAZXv19vryNjKQ4vvMPYRltFVt1J1K8ui6vD7yvLiKy9dpzC3JTwYYevyrlod+MzPlD2F3F+fh3c/zqpILIVjDNSc+jH/eRkS8APKp4W3E2Sw9LCmaNhUVYv2TvcigLq4x2psf5tix4c76Z3c5DLJ4SJAy1vvcETY2QKm1nK3ugqBPxjcZhtASOhv/+yaPv1lgb1cQbp5zzPPG+te+6VXteYPMPuySz8l4p5mKdML0ycsOTj5ViR8fOcPnpzBETfBtAqnqREhw/sDp3Nz0fVAMLwmsZR5OC9VBf9aXF1RTmtHCOg9uWHiwGA0tB0P9i0myatZlJst8/VsY4wffWioriUJZp9pxDa3K3xxUKDeEj7r7wo6U8+B1K12dLuF3cX/Pknt1xiKaWUlaFkAltQ2HPMCSt8lw4XQ5CG7soJtPkBX8jBd4IC2hXHS1iZ8QXdrp5ahmNIKmTOzdpRVHGE1QSS68MQQ+9qwYdR7iFatxMhJEojdzVEEmxj6CjGwgyopw/3QwVD4AzY4dLH2Jx0uswt8tibmS611cYCEUXg5NNRR6srGFtUe
 lE3NxvYA
 AWKB6igjiW+zzNmxfhAd6JpsvHbh1Pm8Qwsh8c9Sy6qf42SiI2ujj7wzhgoXz1Qp7NxjwlntP0okQH9eKQk7TfK6cGCvuQUfiW8yHGixx+soIP63CAMqV4gomxf3GYJCB3H21N104fUDugPuVZ7NKd9GZwCR1ddc4t14zzv5ytOCL9jwwNFn5nB7sxpPbMDXDz7ZLa19da3HG05BxjPiNYA01eQ1nKzq9+G1z/7speEnt46WH4FwUUHMbfCn1ig1MW5NyZtwpxFJkRnxGmaBTjyybj9+c3iXrdF987N6rFDrqEYRpgswsDBki9QF5HgxCKl3lkqgB6+Doy/js3XoYsyDdOW88Z6g9bv8X0AIhpbOdvSLjMF4JeFzV3fbV42pvHTc6nedGwm2dM4/Hs1DndCzWyxUnroewWcRxjoe2MpZrOKNkMe4P2E7UuKKdfoZWDpeV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 15, 2026 at 12:47:50PM -0700, Frank van der Linden wrote:
> >
> > > I also have some questions about longterm pinnings, but that's better
> > > discussed in person :)
> > >
> >
> > The longterm pin extention came from auditing existing zone_device
> > filters.
> >
> > tl;dr: informative mechanism - but it probably should be dropped,
> > it makes no sense (it's device memory, pinnings mean nothing?).
> >
> >
... snip ... stitching together some context here
> 
> So, looking at having some properties set at the node level makes
> sense to me even in the non-device case. But perhaps that is out of
> scope for the initial discussion.

I think there's an argument burried in this observation (useful for
non-device case) that suggests there could be a world where longterm
pinning on this memory makes sense.

But it doesn't need to be introduced from the start, and it's a 5-10
line change to add it in later, so I think it will get trimmed unless
there's a user out there actively experimenting with it.

~Gregory

