Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54322C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 00:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 592BD6B08D0; Sun, 16 Aug 2026 20:49:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543D86B08D1; Sun, 16 Aug 2026 20:49:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4324D6B08D2; Sun, 16 Aug 2026 20:49:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12E4B6B08D0
	for <linux-mm@kvack.org>; Sun, 16 Aug 2026 20:49:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7DCC81A03C6
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:49:30 +0000 (UTC)
X-FDA: 85108928100.09.C128AC5
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id B2219140009
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:49:28 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=MRyNp3B8;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786927768;
	b=Tbi0Gmzg6TiJmNstBweF0KjTdOJc/jiARMyCJFYGQD46r80p10Rjvb/yUKWtjJUUgEqv/0
	VwJxeFlU3TwNDwX5/KAxzTTKmDqXUA8VtEAAcWxnGgSgcNpAz+r+TlPQ9+ZuuUGnNXPza5
	W/D/ja+Nd35skNHdil63vIOF+ht17JE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=MRyNp3B8;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786927768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FcQdr0dRPL3xWk5ZJ+WEqnlvhAK6C+Y9UAGkoGf2Ky8=;
	b=8mW5nNR+Xnhe6EnQl9TlNC47ARPEvpzIhUIXXellpXgyJJkzruQkJBkTtBcxu9FCgQ8Uok
	8dgF4ZqiL1Wt8ujNJkgT/ZKZhpErvbuIqej8b1VrGDuOy5eYm3swN3k5AAYXrn3EeYgQV+
	c+wrLEXUZN2x/d53fzwkSwXwDTOLfQQ=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c2a76536bso28094641cf.1
        for <linux-mm@kvack.org>; Sun, 16 Aug 2026 17:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786927768; x=1787532568; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FcQdr0dRPL3xWk5ZJ+WEqnlvhAK6C+Y9UAGkoGf2Ky8=;
        b=MRyNp3B8FAr1OAoS+i4jBF6+HuQwPHDakMWnX2L0xpYuBJH+mYy7PkMYEB960QrmnZ
         RrSEkftikcXAJDDh4brZRp0q2YdVki65i8e7ziGrxF5as+4Z39ybDzDatVc1iWJrzeB6
         PyG5lWs76AAcMABVqMoatAKLJr2sG9wDosKUzSpbAHhb915N5G+6Bd2oD8d364k15xbc
         koaV0qwDjpLYZ/9uWsm95eX7hHuJFZJ6h8XEfio7seDfALAydYB5AbLrObX0I+gizmqm
         AmBUya34gaUPSupzHcSfW5bFrXArryHfxjL/dMNEYDm+vDAnzMSD4fm+XxA6jghAcRZd
         /VKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786927768; x=1787532568;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FcQdr0dRPL3xWk5ZJ+WEqnlvhAK6C+Y9UAGkoGf2Ky8=;
        b=q1DTvXdAfxOkysfIS8UnBK0c1s/7RqrgIZotJSsiQYf6R32nXIdHy+QNzeIMlTkUaQ
         JUI81TU+L1hqCiRAO16Cd2S89l2tMyjtuPYBDAjKJ2GGnI7N7Z6/Ihcrz+RWg65yZh3Y
         B+uujgsuu3rar8StifmHnFZW9pmgf90AuUticat4Zi6Ans9tPgxrk+U8AYYiQV9DCjtH
         JKLUtYVMcEtTfT5dfyCfOrPg60GQIzQrI2pZM+cEclmABb3IvOMFEbWHLN+CLOhdO50c
         RDHlFQmPIzdnWlEif9VaQzaubTjekfOB7jbKJRX2aCI5ZBgS/0H6Yi8wyXoSHaX078e3
         ifwQ==
X-Gm-Message-State: AOJu0YwbM08zKUHug46Y6ec423QVCq02YTAn5a/+haOg1UkVTsSARwaj
	bDhmQFcQ+8ZF1+1gZY/eAPjnpCVLZEji/6DnGmh1X1yZvpHAhPwJLiW629r0DMz0L1s=
X-Gm-Gg: AR+sD13JlT6q30SAlSBKYlvt+B1UHHQbhMzxb8yOhejXGlwBm0E23+27gPPWLw/xLXZ
	HKVoz1jPDx6eHRRQpRpvTnUQRNJiCaTLDODrbZXCsqAcr/y96oi62JBZ3covis6R0yYwTjn0/CF
	Jq40GC3ViAuLtBIYvVD4+7kRYLOxM4/qNv1r1V/voFIll72dNwv6jKUYyXyJEPBynC+CAngImnI
	O0U8iLV9yb+TqbrurwejFYUsfy87vAvPo0lDm7gb3+lGQdqnoggwjJS2EfuUJlzEycZV8dI9InN
	Ucp+hVzM6xb77+qUCedZNXnxNa/eNlAiMwd3sGuPjbbHmYSIhXNmGmfvyggh3YDXdgjy90xdgMG
	zKR9oCFgcWE7no2cnes3iHo3G24XHbnz+qHybMd8nRYRm8GYGCCQLKb4P2rL6ITYT6Jf6f4ATn/
	aoDVK/22iE8FXqokfncaYykEpxCmbciwUuvJw24rl5DzbTK0M2F2cJqHxkLhOZBGzh0yGWNunoP
	2VJRRow1e6h9zcIdwXGqqcn/+ChgXQ9NptljSFh8VEB
X-Received: by 2002:a05:622a:2b4b:b0:52d:a151:10f5 with SMTP id d75a77b69052e-52da15111admr97787241cf.22.1786927767788;
        Sun, 16 Aug 2026 17:49:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52db62764f2sm1152051cf.30.2026.08.16.17.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Aug 2026 17:49:27 -0700 (PDT)
Date: Sun, 16 Aug 2026 20:49:24 -0400
From: Gregory Price <gourry@gourry.net>
To: Qiqi Li <liqiqi23@huawei.com>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com, 
	balbirs@nvidia.com, brendan.jackman@linux.dev, yuzenghui@huawei.com, 
	apopple@nvidia.com, alucerop@amd.com, matthew.brost@intel.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, liam@infradead.org, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	corbet@lwn.net, skhan@linuxfoundation.org, gregkh@linuxfoundation.org, 
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com, 
	dave.jiang@intel.com, alison.schofield@intel.com, osandov@osandov.com, 
	jannh@google.com, pfalcato@suse.de, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
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
Subject: Re: [PATCH v5 25/36] mm/memory_hotplug: support N_MEMORY_PRIVATE
 node hotplug
Message-ID: <aoJaaYp30LnKLj1w@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-26-gourry@gourry.net>
 <6840c720-8cb7-46bb-a652-040c130a4427@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6840c720-8cb7-46bb-a652-040c130a4427@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B2219140009
X-Stat-Signature: rnhzstcb7rpyxiwkt3apineifs9pc5bz
X-HE-Tag: 1786927768-453722
X-HE-Meta: U2FsdGVkX1/gaLNEc5A97eTMN47g2QIzvzg1BThWxWRAgrdaO1q39+CPY9YapKsHi0cBoNGBdT3xYBxnjOGIdAy8PowS2+1yjrsZoXKyHlOXQfyT9pkUsDCEBOK8dNiy/ZzENJR4PMrBxxOTPSB8HMPLd2+hTJLA2LUytwpjoES1C8Btg6kdRHJkLhlafRXMBLC7YwGYeolpgaKHfNGTUKuf7+lAV9IP6cB+QR+zj0K66A3GWiKj/TCqGnoQMkFScPlTj1kcWLa37nXQg5dpLpFmYPllaoJcF8qBo+K+UmIGmsWN23tgyHnGrGjqApTv3u9SmptHeve6XqFSHrW7LJV7zPqifiuZOiC4o94zApujn2TtiLzXHlEqMRy+qpjhWyKQBS/wY1PB9Nc4YfYZqxCVlUsS5rgsMQQ1X0dmMQ3YhY0PT+JT9cLnXoMJ2h5ZaZsYkbU7rA1BpgJa6gcLLdIm7yG57BQAI1yM8bSK1tVksb+q0wabZJTq6UpCptEHFxwlABSi82whJi48hru5uq9vAzfB1gxkvVYphdOHUtaHl4dla/HgxHhL+xU7nAuqXRqhWw2eV99hcwpP7Ld7dNK/NcraHP3wBKtLmylqr71iHNLIiJqFHGE8FvoVlImrXo7W4pTTZxAir5kB9ZylIENI7FIb3o7NU9NxQFRVC8AyjMYJk5jObHzEm8ddBupcCcGKGgBL7euXWdATO/uddM+NW4uAI68+oDvgBzYf0vE3l7aZAAXO8pWDBHalJT2qb7DmFPshidARCyc6YBHr9kF9AsI+CMn/tQ+IrvnSNAVHbdZzzlHPUQZiyRkUMB7lhk8jTppPkp/0aAN5krziesh/PxEiCtXyVxb57dpzoyiH9XLPUdtfrSisDQMOHzNkDErChjmXXjzACiZ1P2ZGp0zMUW4su3oEzJ0jJHoMADMQ1gzh8FuLxCNlX7Cf/Kxg6K6kzQj33/JTyPxVG5U
 Hai9DNH+
 YR2HDp1FQ/OpVGfbMXj2P0pott16cbROuIM8vMkpABqGMBMY68nLx1I8SgRTpDZE4VeUunbt3sI+/zjh9sJbn3Thzm9CfB3EJuu8kB8nY5pNJqqPlTj8Zq6C7P5uhwfl3ifVMWE6cwruGmLkzbW6t9STlPfRHenFGsiilDLu9jPUy5iy4o3WRqfbWWdHYhoY6EWRVmIiSHsRp+XKAZuI2KSehykkX+tSxAnuWjlObuzeQEjsvEnoLzESqQXQgDjXi8HQE1eTRDngdgevyDTo4NrEOrVtw/yoNEDb6UMD0gzxHt2quBzH4pQoL8VtQToibUx97aPmaEn+u441sO9Y5tClA+EQ0Pr7RshtZnKPvso0THhMhY3tawjhE7xRiE5rw+kDLpc8fDasKxmW4EP1F3eLqfw2dW4dZFRc0Xe8+yaNVQTam/l3c6/TuCEcIDgKJeoo/TkPD89dQHi8e2PZRVf3kdItjl8ztHu9gSPaaG5AiKIyFlfNb6lawP1XyhYI3KTJ7CfeqIQ8TVs7Frpq/HoarAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 11:30:08AM +0800, Qiqi Li wrote:
> Hi Gregory,
> 
> On 7/21/2026 3:34 AM, Gregory Price wrote:
> 
> > Add add_private_memory_driver_managed() to let modules hotplug
> > memory onto an N_MEMORY_PRIVATE node they control.
> 
> I am trying to understand how the nid passed to
> add_private_memory_driver_managed() is expected to be provisioned.
> 
> From what I can see, both node_private_register() and
> __add_memory_resource() require the nid to already be present in
> node_possible_map. My understanding is therefore that this patch
> supports hotplugging private memory onto an existing possible node,
> rather than creating a new possible node ID at runtime.
> 
> For example, in the use case I am looking at, the device's private
> node is not described by firmware. Would its nid need to be reserved
> during early NUMA initialization, or is there another mechanism that
> I may have missed?
> 

It would need to be reserved, and you could use numa emulation but
that's clunky.  I have an RFC for exactly this issue - though i haven't
pushed it further yet.

https://lore.kernel.org/all/20260610014517.253609-1-gourry@gourry.net/

> Also, could you please Cc me on future revisions of this series?
> I would appreciate it and would be happy to follow the work:)
> 
> Thanks,
> Qiqi

