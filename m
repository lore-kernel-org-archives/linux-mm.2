Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5996EDEBF3
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 20:36:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A52816B0093; Tue,  3 Mar 2026 15:36:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A01906B0095; Tue,  3 Mar 2026 15:36:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D4776B0096; Tue,  3 Mar 2026 15:36:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7A0F56B0093
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 15:36:25 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2416B1B75B6
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:36:25 +0000 (UTC)
X-FDA: 84505909530.05.042D0DC
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3A91C40006
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 20:36:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dNggxgEF;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772570183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HSMo5+Ht+OJv6fxlprT7RhyGGgmGe3zydeGluTTF1Sk=;
	b=2b6MBwACOFhteCt0rpqBZ89aq07+8H5cKoPYiDI6tMp9puOWZ8yIKzA6bMGH93mZtF6Cbd
	ftoC81T6bwiwoxekXkONRrnrrwEoXLv9RSgBZcp/T1A+MZa3sBRXaLEJEJaU/hUNczJU2Q
	XO3YtsKVvQZVmzl8lZEi6ss67UMI0bw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=dNggxgEF;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.173 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772570183; a=rsa-sha256;
	cv=none;
	b=31SVdbXOmMgPvsNuhqfHjGkNo0tYG1cJYAm+QjjuloEhaBQwdITq6iPCYnEgSw5C8yymMG
	xj6dcfgiJHtBW9ws+428KiECv/tSV5/7Bu2LNmeDzvSSq1kL3m1RDeKg0KOV+qnKhZQQFL
	3CNefUPw8UuzXBsL8ioOvfTiLX4FRzM=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-8cb38e6d164so791825285a.3
        for <linux-mm@kvack.org>; Tue, 03 Mar 2026 12:36:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1772570182; x=1773174982; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HSMo5+Ht+OJv6fxlprT7RhyGGgmGe3zydeGluTTF1Sk=;
        b=dNggxgEFkNkLfio7ftnYdhj5GIXBnFNhhCYRm29+LS73eNkzv4VI1w4OvytZbGfb2Z
         4/2xTdNEzPmRM9ESvb3OfjEyGH4EAxvfXEvSjdfCFIKTEJH56hS0K8atBT4KVT1Qd4Pz
         Z1c0EebsfWjMeRmgifs2A4kg7QR09df+9sC8x94Uplv6KGXG+x37ahp79uiMTtOL08fx
         ji63vlTXf5oeAhV2hmbFmclxpVJacqHo4HhgwmM9wusqe4ci1RE3aDDCykkLYDHMDJxR
         TArWp8QC6OsjDjgu54dyTpt0Fh+1PShDtSjbfuScCLCkOwRAX3Zi/2G9c75MZ6PWkd9W
         9Lmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772570182; x=1773174982;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HSMo5+Ht+OJv6fxlprT7RhyGGgmGe3zydeGluTTF1Sk=;
        b=AizVDXdmHAISzRx4Tcy+MmORW11EY4hFgmFzQWRyPHgyCsfuZlRsZfVhoijk72f0k6
         YlK4owjEdIwo0i616gEblXiu4Tok8pm/bSuelgOEPO29FSfhkJVepH3/KqhayPsh35Jx
         vShBYn+Z8tNtDDoSXXjBgpRKjBmvq9z98K9Eg9v1WM0TzHwRvTOTMEaUWWLgLMALuJnZ
         TmviTJ82iHLnOOCN+PTDqPKsiDSuQFnBpUnCG1zAjKV5HH9W7/Yb7ercDril6OmbMsk6
         MmsLvlzGZA3ssCjxbre+7OPMe3p8lFi8GwXrfJGE3RwB8jt2W2NQ6YMLbq9CdCo17Nv4
         jqvA==
X-Forwarded-Encrypted: i=1; AJvYcCWRGtNq6U8teMOCFEe2y+Wsj6YvB9YDCzRf5zydZ5ZkfFgZvaJ1G9TaTc6FFrEaANAfkNTQ5f2ROw==@kvack.org
X-Gm-Message-State: AOJu0YxLbmfQmXIdnzdkqfLAq0i6AICdmBJUOccMM51dJhzWAPTwBKjf
	0QYjUxyMxYmPHzID/8CWe1XMEQD33OgmP9oMB4iZx1kcftqWtULfvelOWLeVAF1Jzqg=
X-Gm-Gg: ATEYQzwuUgJokNneZxy2yWHCUpzmd1VenkyKkjqMaEz+1n5OL8LrgjehLSWJ9Bqpjob
	QBw/VfvpSMHoAmCvuxId7SqKPg02nrTfi08wqex0Ucb2Mt9zF4swdONPFRYrol5oETkns4j5bL2
	JkLmnYe/LmMPRo3qIofUKqchVnQmiUfk362DMPtczhUt3jTDpWGT+xn4qEO4kAzwh0+4Y08mAoY
	IOf03T2T0hg8uAhbwzXeyng9/4kRYjEengLszdTbSihzOpthivT4/GRWv5ZMeNyy+AMfaSWH0X5
	bubTO0FTX0V0Kqf4E873S1SerdEfPSFDu54yXOKDMfb1SRD/YdStr21DmHBnHoSV5/1vbKpcFFM
	Z8k9h0a/8gDSX7HrBHsISrj8R0vyjR5Ro06cw/hBytGDM9SSDxI8rqgx+IXEJICx+XsHoGgaTc8
	V5vI40CI2tLRXVgb0ayC0nMeaK6uWkkTqDmxQgweVHqsfD/beiyJzmZ3gayuENKM539nGa4uAD5
	W3/m+4ANw==
X-Received: by 2002:a05:620a:4720:b0:8cb:5442:d539 with SMTP id af79cd13be357-8cbc8dc28b1mr2313709285a.2.1772570182058;
        Tue, 03 Mar 2026 12:36:22 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899e89bf39bsm79243066d6.18.2026.03.03.12.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Mar 2026 12:36:20 -0800 (PST)
Date: Tue, 3 Mar 2026 15:36:17 -0500
From: Gregory Price <gourry@gourry.net>
To: Alistair Popple <apopple@nvidia.com>
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
	ying.huang@linux.alibaba.com, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com,
	linux@rasmusvillemoes.dk, mhiramat@kernel.org,
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
Message-ID: <aadGQXXpayvFOZpy@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <fzy6f6dpv3oq3ksr2mkst7pz3daeb3buhuvdvcw4633pcl7h6u@mxjgiwpg5acv>
 <aZ3BEn_73Rk8Fn7L@gourry-fedora-PF4VCD3F>
 <a6izpi2wlqro72erhbvxhlx2lwdnae7my3ghfs6t33ivtixo4h@bi2u4x6qv7ul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6izpi2wlqro72erhbvxhlx2lwdnae7my3ghfs6t33ivtixo4h@bi2u4x6qv7ul>
X-Stat-Signature: 5tjhy64syjxz9uj6im6y57rfruwppbcb
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A91C40006
X-HE-Tag: 1772570183-613045
X-HE-Meta: U2FsdGVkX18lBp3YozOQycl2s/btHTja7G/FGVmsbFgzq4phG5GUleri7FagEsgAaMtisLuZeaSRfslVswS+oeDrcTu/sWQxjFglbfUS0pHVA/e19kCh5E1WJ1je+4zW3mB28YOdxJn7dYSON31ybkJmwQ2Fs9TdRMtQB/H+97SQEl/bvePlvQSQ2YM6Q7plzOXj09a1FGOQG/WkVjyY0U+R66ENOXQMGQH4o2FL1Q3VwfrntW8x9R07JvVjxW+fG62fOEcm8Ufi/c/5mfV5GjeZ/6oMI+JjofPB7NbwHPEO2eSuyZyHGV1hc4m+b+r5LsEczdo8FqBCd668nWFcox9+zqQ0oTJ92PqxyxiX7/ocSYCoK6lBIdUbMq8eSBcFQjd2FuPsxVaqJOhNaUWJEyHPvHgvOb0nfp0b3whpmXPRPBCkycl7w4wyQNAQPLw+9wajdclv06cIQ15QJEaCdPHfxJRkkac1xgLJt+Kic1Pu9NnnRW8tGMYdwpc8ULs5XDrLqdfFuXi8WYfgoT6Oc2/N5+w1erFG4S24rP2PBzWpgZAfJfkIVhUEodOuVyhn+etvNClrat14RVxtHwHCNb/1l20qHQ38Yzt3CmceA28B3CIZgetOj9s+mr6h2h9yAfVssXI9OJ9fDWkaQPJmdQtTK2FHLzkgy/VIAjRivh3QlXD3oZ4mDQztiMoXj88XGIjkYGOZedpLP8rH8fO/wUWC/4seMiozakf7VxY/eCAbmgbmtYc39rG5EcktYpRpGcwPkcDIStstw0+838Hv3DkRjyQPxDXcekkW4hLu8wt05o1YP+goPZ0WzRrNWhLMI3uSgtlRxC1Jg2nJ1LQARRQlGZhrkmp/+i6Sfs4JRyTiYR0GfdrKDV6ZmQ9BMr5TEesuAM4mL/cX+K2Hm3e/wvg+Szv4ua+hF/S/cA+3TtSfKa/5fytHc06hfxzo1L7ChnW76smhlZ52UlkP7tg
 4L7jIgLk
 e+gJqhH1nuvmG09+vTJK/r66GgEySNRC/OwFHPUejtFpvygW9YqlgkxlWAmioxTYw8UGx/y5rD4RzIG8p97xFUlTLDGsy/j/0p85+sbFvQ3TFj/AsS+hJNLmglIoO/2ajJCt9DH/g2xZ52mkzBPPFvv1N9jXYRkGEsPGJv2q6ij08lPCGwZHelAgVkhbNHJBcDezWo4RuGVdzVwFaJ59+YCDBc6GXmoqZwZI7PwLbQlnmbxlxA5ZduWtHwr6cVimMmeDg2cXszETEoWco4aGRrL18/ZfYoPg2DCiqQfo8jJYZpNlyv9JOOO3O5XndlmFIDEeLs4XU3xqceieZtPfKxNNDeSAREEBDuMHedUSwElOvahX827TzqQ+UUawmNo9M5RcR6yLQouwTfvemvw6/ue7V7GIeztGtfBSDxSSQbdpahCEmvljUW5JJHofi6Sp0IX+kee/izEqeO5s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 02:27:24PM +1100, Alistair Popple wrote:
> On 2026-02-25 at 02:17 +1100, Gregory Price <gourry@gourry.net> wrote...
> > 
> > If your service only allocates movable pages - your ZONE_NORMAL is
> > effectively ZONE_MOVABLE.  
> 
> This is interesting - it sounds like the conclusion of this is ZONE_* is just a
> bad abstraction and should be replaced with something else maybe some like this?
> 
> And FWIW I'm not tied to the ZONE_DEVICE as being a good abstraction, it's just
> what we seem to have today for determing page types. It almost sounds like what
> we want is just a bunch of hooks that can be associated with a range of pages,
> and then you just get rid of ZONE_DEVICE and instead install hooks appropriate
> for each page a driver manages. I have to think more about that though, this
> is just what popped into my head when you start saying ZONE_MOVABLE could also
> disappear :-)
> 
... snip ...
> > 
> > You don't have to squint because it was deliberate :]
> 
> Nice.
> 

I've had some time to chew on this a bit more.

Adding a node-scope `struct dev_pagemap` produces some interesting
(arguably useful / valuable) effects.

The invariant would be clamping the entire node to ZONE_DEVICE
(more on this below).

So if we think about it this way - we could just view this whole thing
as another variant of ZONE_DEVICE - but without needing the memremap
infrastructure (you can use normal hotplug to achieve it).



0. pgdat->private becomes pgdat->dev_pagemap
   N_MEMORY_PRIVATE -> N_MEMORY_DEVICE ?

   As a start, do a direct conversion, and use the existing
   infrastructure.   then expand hooks as needed (and as-is reasonable)

   Some of the `struct dev_pagemap {}` fields become dead at the node
   scope, but this is a plumbing issue.

   There's already an similar split between the dev_pagemap and the ops
   structure, so it might map very cleanly.


1. "Clamping the entire node to ZONE_DEVICE"

   When we do this, the *actual* ZONE becomes completely irrelevant.
   The allocation path is entirely controlled, so you might actually end
   up freeing up the folio flags that track the zone:

   static inline enum zone_type memdesc_zonenum(memdesc_flags_t flags)
   {
        ASSERT_EXCLUSIVE_BITS(flags.f, ZONES_MASK << ZONES_PGSHIFT);
        return (flags.f >> ZONES_PGSHIFT) & ZONES_MASK;
   }

   becomes:

   folio_is_zone_device(folio) {
       return node_is_device_node(folio_nid(folio)) || 
              memdesc_is_zone_device(folio->flags);
   }

   Kind of an interesting.  You still need these flags for traditional
   ZONE_DEVICE, so you can't evict it completely, but you can start to
   see a path here.


2. One dev_pagemap per node or multiple w/ pagemap range searching

   Checking membership is always cheap: 

        node_is_device_node()

   Getting ops can be cheap if 1:1 mappings exists:

       pgdat->device_ops->callback()

   Or may be expensive if range-based matching is required:

      node_device_op(folio, ...) {
         ops = node_ops_lookup(folio); /* pfn-range binary search */
	 ops->callback(folio, ...)
      }

      pgmap already has an embedded range:

      struct dev_pagemap {
        ...
        int nr_range;
        union {
            struct range range;
            DECLARE_FLEX_ARRAY(struct range, ranges);
        };
      };

   Example: Nouveau, registers hundreds of pgmap instances that it
            uses to recover driver contexts for that specific folio.
	    
	    This would not scale well.

	    But most other drivers register between 1-8.  That might.

   That means this might actually be an effective way to evict pgmap
   from struct folio / struct page.  (Not making this a requirement or
   saying it's reasonable, just an interesting observation).


3. Some existing drivers with 1 pgmap per driver instance instantly get
   the folio->lru field back - even if they continue to use ZONE_DEVICE.

   At least 3 drivers use page->zone_device_data as a page freelist
   rather than actual per-page data.  Those drivers could just start
   using folio/page->lru instead.

   Some store actual per-page zone_device_data that would prevent this,
   but from poking around it seems like it might be feasible.

   Some use the pgmap as a container_of() argument to get driver
   context, may or may not be supportable out of the box, but it seemed
   like mild refactoring might get them back the use of folio->lru.

   None of this is required, the goal is explicitly not disrupting any
   current users of ZONE_DEVICE.


Just some additional food for thought.

As-designed now, this would only apply to NUMA systems, meaning you
can't fully evict pgmap from struct page/folio --- but you could
imagine a world where in non-numa mode we even register a separate
pglist_data specifically for device memory even w/o NUMA.

~Gregory 

