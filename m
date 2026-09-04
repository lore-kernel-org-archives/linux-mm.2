Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC647C624D6
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 03:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9616B0088; Thu,  3 Sep 2026 23:18:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9429F6B008A; Thu,  3 Sep 2026 23:18:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80B576B008C; Thu,  3 Sep 2026 23:18:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 51D916B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:18:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C75B5160698
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:18:09 +0000 (UTC)
X-FDA: 85174621098.04.4B84649
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf27.hostedemail.com (Postfix) with ESMTP id 06E3540002
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:18:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HE3HVErr;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788491888;
	b=fvUzyvjLMnHH4jsmIJ9yt4VUA4ZE7Av/2UeqSy09ZaZbBVteweNn8bpW3j77bl+thqRQKv
	uRLnZAlrN4k7YWdmE79cHgXgJG/INg1/Z08n7+esdobfoYqMgkE/1akjvnKfOMMhsuycos
	w970U6UABlwXf0ZzF301k1ohupdI8bk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788491888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I82bST350eZ9tF0sXAbqbqSO4hf+URoRFBA/uGedV7I=;
	b=mCiqsHxgOry2VDNIxtxhhhKk+LQNw16rccz30mT8pOavM6qRh7rXD3p9tG7lB/lo6GP2ny
	QFlX5+GWJpHHWmjLTNqIZsB/Ki9u+j8d03BO3SP3WV+Z8x3Ku8+zqsW2sjz4y0aI4TcEoB
	8IDNYjUJGOn0wJMTCp4Os2j70cgVffg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=HE3HVErr;
	spf=pass (imf27.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-53024149d40so3753991cf.1
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 20:18:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1788491887; x=1789096687; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I82bST350eZ9tF0sXAbqbqSO4hf+URoRFBA/uGedV7I=;
        b=HE3HVErrwoLcbEPB7TFcgo9cT80B3ScDIclhwSHu2HGLGkk2aKbbK5oNYxnh4Vt7Ej
         yfiDRs1Hmk08M6YLvNQEZuT/5pah8pthuJJ7RBKv92M0yy5r21AqFQ1FWxPlhsBPBd+7
         q2XA8/sOqi5qa9mQ/KJcTtCGFBx/3RUy8mGEelX7v10oZcCkEH0UG1AfLZPJxt6kQRtL
         Hn6GAmO233S0t/sP3SwU8wHDi5DpWyjEo76o9V+VYRLBLFVnomC9VqwhxVZVjLsPdbnW
         cTPj6PaUSjylE9WVGLUxbNeOoJiLT6hGtRJPaUQI7EHuf9dm/AW41r3v3NQaGYz2Yf6P
         DjRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788491887; x=1789096687;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I82bST350eZ9tF0sXAbqbqSO4hf+URoRFBA/uGedV7I=;
        b=Gerd0YCLyT82SYGCsX9CrrxMeK91zyZBz4zYJGXv2eBtodlN3/zBZi9Q5z4T7XNUS3
         aoHK7Qg0Pq4SLOVvr9KK+KgLyMiKF/UbggFhKm2EPb6P30c374RyHYAQ9+qj2bfDCJkg
         6i9UICo3MQwej8ZBsIzCterIOwPsxU+h2meVFmvhgmJTV8O75JAktn3xUiyxKSOjbScv
         fWH/TIj4CwFpsb5I7To/N15WSxoBCZDUUUnE6Q78SgfEpuB4wC15oyPVoDrHCnOPwMQ1
         ijh8U7qYG3cZ4abPer6JYisqh9WPCx0/1VwRch3d9V5xB0/wi22BgWo8pqejRmNfKgGn
         U2ZA==
X-Gm-Message-State: AFuF++ngkrRsPGRVMtTvEgaYShejYZjROkr7AhgCTzwOIg13y2v/XqUB
	IKv94+70Z1JucQVjf7AI0j5rx8XZCni7SuupmREOiyjnqhsbQe/eNPga1Xt770IA8nw=
X-Gm-Gg: AYBFou3K5OUgHrHhnP4szj0dyC1Q2eE4voOQyI3YA4tB7VgSea/4TMfRGVSrqn1LmLx
	MivDjppklGhOn59Xjrio7/K+XjeI6huUAvCtq5jOWBOlopKns0QpRXjBA78p8x31AnXUejfACci
	q5BkwR5O2avgjDmGwiz3gCjlSgLYDD44DqdzAD2k/UTtubWkq8R5rSLX1LzBmwE7MSHlrPLljD8
	FCvfRlxVxic/igC+cY25WPAwr68pkOPtR1yMfGukCFFaQotGBxci4nasRkzC/gaBSf4JfnRNvwf
	Bwy/Vqqc7eENLJlvG8e/1VXTtqcqXT99/nFfjl5cCIY3yeJNSRiVe/HhZWo2ku1WqCMCU06jQfX
	/R2SrNBcvKcPJPaIfmfXywvKvFmYD5aP1oz6pxYF8KGK/HQ9FQwiWNR5jai91tJnTTL76+uCd/a
	J4p+yRMNPVp3BFQsje8WvAmw/YLq1jcMvXPeMB58NeOS5sVpJtfKNB9crOX7LO2JNni69aLxQJa
	qjT+U37jF8Plqcmmv4A1cfeV5epDcBdOqwUkY6DkFdSKrk2bRfZ3dw=
X-Received: by 2002:a05:622a:1c18:b0:52d:4f43:d5b0 with SMTP id d75a77b69052e-530548bc5e0mr43078621cf.22.1788491887027;
        Thu, 03 Sep 2026 20:18:07 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5305402a7b7sm11260161cf.3.2026.09.03.20.18.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 20:18:06 -0700 (PDT)
Date: Thu, 3 Sep 2026 23:18:03 -0400
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
Message-ID: <apo3bZab6qtCosQM@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-26-gourry@gourry.net>
 <6840c720-8cb7-46bb-a652-040c130a4427@huawei.com>
 <aoJaaYp30LnKLj1w@gourry-fedora-PF4VCD3F>
 <0334fe7d-d949-45f7-8914-3012cb11b740@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0334fe7d-d949-45f7-8914-3012cb11b740@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 06E3540002
X-Stat-Signature: h61ydeerym8xgpcpdq1unz8fh7ucw1r1
X-HE-Tag: 1788491887-720385
X-HE-Meta: U2FsdGVkX18PJh1imiFKqIBsGijcO82LBA/mK7w/zzcedzPLCaMjnllZgye13jNQq5qgDcopaNdZ/T4yPlDS1xZdMf905kgSwA5n3amrSDPX3Uh0JmsChLxJgr2emEDBes49S7rrEFhrQGAWZvTdF9slCAvLq02dxeclb+cbptugMJ6YgGzKfy/oIOK/CmmydVHskr6G5rp6CPVx+wpCSsNgI0wIS8wCcXRr7dwb5gxI/MWLe1A5FQxzdiF1oPx0VuvvifUiw9q1bsjPY7S0gfX2E2HNfBJ2KrKjoir1Vazf48AndJboUwcpuawlfb/a/1bzfIR8j7iluch+JABmN4onycemG1syd8M7BfMN9b3mnrQvgWYEbZO9jmSo51Du4vojBvQ0tUXhyEJhQsT1no1ZE8kSL7RKv9HiVO6FXgfJpkk2AxsHYvnI2j1G2fKnJw2C5wBmBq+2R04ZuDZU3qXPVCWlCB90azzdZSJBqMSahCVB0PuYUO/68SP7Zfs1lvOisFJEg6hNJlE02tBCWWdc3K9lqEDlnwQTPGABrBnCwCm2j1xFd6LQLHFiIZg/XOBoJbbUd626TxiN1aO9c5RuJEvou8zML2ID7bPBtrh7bCik6awpbHXPfScraljqw7zzhjoF/ucT0VwGQIM0EXbKsixWnpHgJGX2rLVUJdSRlpwuCbD6p7MK1wE5qHtYLxCpdDCoP/NmmW6nT9FFClQR19KKv8j/Kkx8EgxYq84iGtLQUg3GzrbFOQvCAZQvdvJMJ21vYIc8D1EhTRxRNV60rZx3jdMn9KQnhw8mwxjVGap/4bDc9h1exG2qDvGDOmA7U4Wcrj0kJ/V24HpjLW13erGJBkqDfmEIul5MyQ9kqzXYyoPzEkSsv9toCPIaejMhnw2ZMz42O6kEc849yDASTQt7Xcd/lEBAeemBKRO6WavIwwI+mJPOIpzett64arQS+qHcRzaKyj1ksei
 jmgguWXr
 JSif9ciDI/WsKclu8GmfOq0W36KzoKOaTDCpPizfZoORGbCTVKc/Cetx20Bg/O3KBDQDQuShsCWxFK+tHlLZNZwe015/nsibXuxaPKaIO8Qih5pkSs5jUCL9CaiGjSGMYgzRzaPUHTaQlM+K+uc8u91PTPJVrNT64eNmyWpGeO41+2/L3Rcep1aAhI+1FDma+WdkHV9aAuVOgM5XmI4enDWq3QXDzntLbDD7N0O44AE2yjTi9Dhbv1jFdoAAAjrQUlfZ0tzthS9f7KG/yFyKyP677bY11+tye8hoOFYzU/JOcUFCI1O28nzPKDiTIRsOxG1EvpY1c/BOWRMne9Jkn/Y2fp8lCKJOkLdVRPWn+vvQ8IMU6exp7zsUwEp+6D8IcX+2O45eJktMHh4sKaTErEiU8pZoFy46mkOdomwTxdsuGyjIRlDGRSYVipjgazCtNc4nszzqP+eDEhM5/eregLbwfQXJ0atS7DpyvJi+NyG/NPh5kNMfo3bLQ7OA6G9c4pW3wc5PIKYvtbizmc39EAjPEkEVtqoUNrnAReCaeZBYk4fUp9rkx1OO9iA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 04, 2026 at 09:05:39AM +0800, Qiqi Li wrote:
> On 8/17/2026 8:49 AM, Gregory Price wrote:
> > It would need to be reserved, and you could use numa emulation but
> > that's clunky.  I have an RFC for exactly this issue - though i haven't
> > pushed it further yet.
> > 
> > https://lore.kernel.org/all/20260610014517.253609-1-gourry@gourry.net/
> 
> Hi Gregory,
> 
> Sorry for the late reply.
> 
> I took a look at the exclusive-node RFC. The approach looks useful for
> device-backed private memory without a firmware-described NUMA node.
> Thanks for the pointer.
> 
> We are currently looking into the private-node and CRAM design as a
> whole. I noticed that CRAM was not included with the v5 series, and saw
> that others were also interested in a v5 version.
> 
> If you already have a CRAM branch or patches based on v5, even if they
> are still work in progress, would you mind sharing them? It would be
> very helpful for us to continue testing the overall design.
>

I dropped it off because it was starting to become unwieldly, but i am
continuing to maintain a branch on my github:

https://github.com/gourryinverse/linux/commits/scratch/gourry/cramtest/cram_72/

I have not posted a new version in some time and it has been reworked
significantly in the past few months - but I plan to talk about this
particular branch and the tests I've run with it at the device memory
LPC micro-conference.

I validated this branch against most in-tree (relevant) filesystems for
the page-cache extension, but I imagine the anon-only version subset is
the more immediately interesting for upstream development.

I may include the anon-only version in v6, but I've been a bit busy
shoring up the base private memory node core and implementing kernel
selftests and LTP tests to ensure there's no userland api regressions.

I hope to get something out later this month.

~Gregory

