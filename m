Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2384C98302
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 22:05:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC0026B0093; Tue, 22 Sep 2026 18:05:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E49A06B0095; Tue, 22 Sep 2026 18:05:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE9D56B0096; Tue, 22 Sep 2026 18:05:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A04446B0093
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:05:03 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 225621A0610
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:05:03 +0000 (UTC)
X-FDA: 85242779286.30.FCB9764
Received: from mail-qk2-f34.google.com (mail-qk2-f34.google.com [74.125.230.226])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3BF6E1C0002
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 22:05:01 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=j0EjUXL7;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.226 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790114701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=anrpgiCeXWmBr1az5PEHzf4nylW2QouLqia/wBZNbT4=;
	b=yvsc5tmFUijG/7CbBHIgRZbNbEmTh1hf0m+qAMm2qoJLTqfCJBJVuE3uEYP6ayRxnFX8b/
	co3cJhY6phAqPMPohXDwZy/PZ8rfDe0nM4vvHCg82B2Yh+GKAPerGcO/fKKD5VcllEMoK6
	AqKLhyNk8KnC55tToIhvL3xGCUj7Teo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=j0EjUXL7;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.226 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790114701;
	b=5sP3Tq8TbinjJqehBmK+UiunvU6aSUoYM9xe/OpW8M7FjQsgKvNyo0ik6ogySB38wOao4f
	ky9Xsf1lCBYk3oK6+Z6nLfRyBi1ICg94acg1AKL+eYbhQ959ARIV+RBbbMgFn5pICKXwuO
	c7tPM1bbjZpYw8LQbtGQ/UTPFmLxN1s=
Received: by mail-qk2-f34.google.com with SMTP id af79cd13be357-939109f067eso31986385a.0
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 15:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790114700; x=1790719500; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=anrpgiCeXWmBr1az5PEHzf4nylW2QouLqia/wBZNbT4=;
        b=j0EjUXL7k0jOMSuFE3TNsdOxHjEGlSnus+s2h/pmAfuj0hs3cg4RcGm6ZGzTGlCgfH
         LPX0V+nk0QRTR28eRUo6IKqZB3sOuc/gN+l2WOUkjGLdZlEvrhrRXJv/pVxPU24J15fb
         T2V3kmEZZPUKzHx7MvNYvGOE3mllrDh09w7kroC6kfwZniG5WrPnO+2OelJ1kAuiY7by
         g5bkOvEwQGkqYNrv/CjeaGCiUJIbaLSmCzD71h49AWEYo4pmpz7ptftFOtivTVgNXpys
         IMYY32hJgW30V8Q0Pv1zQGbVp6InZ/Al29UukP27mT5RIslqUXVdVbSLw238ePapfMQE
         xGng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790114700; x=1790719500;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=anrpgiCeXWmBr1az5PEHzf4nylW2QouLqia/wBZNbT4=;
        b=OO9BcjctHZKef4vIUwR16cpocS7uxDFLyA+CCJ9ZEjCDdH5fxqnERG32fgHC2nOkfR
         YLAMjtFLh8V7E5hvOYZU+e8yQa3d2ldanjMpGR3KXxvEU13pzoNTprCCsf45vZDM6FML
         2lZa9CGgGhesphvEqh5MSyTDPCo3S6o3iUBP+h/PgQOABYDIzcUnPC0ZyOiqpO6A5Pc1
         F/Qnne66TEaqWzAw26mrJSqjYChr1f7rKHIGrLq4QyB8uG+geaZsfrBd8gTsu2Etb7gl
         Hdo8mTmk+WxeUsWo1EUJTGbknN38dQTxAbQTFpsZDBPr3cTOUG3BryuVR7J35zROzpNZ
         rfcw==
X-Gm-Message-State: AFuF++kODz8Ih54pRTBArAQyKodGrzqQ0TPsrEK0pLDpRelskPUuOQEx
	8Zxyd99xNJCtLE34Zq4x1vudcDUds2NaJI5j4HQVb8s1Z9EdKkmQVoRCoXVhbdFN5gY=
X-Gm-Gg: AYBFou07mljuHcVKMjf1xOg9NlGAvOCmMOnR3vNclWVjf3BQz+9FCOo9tGY6GNWWe72
	OpAyG+dxeXNAeMcM9rMAfyCoW8RhT+LYf/ymEd2Onpwn05lSbHGGeoGDTiiZ/v/jOxWZzzOn3Ut
	9tPkcs3yOgTC560+uOTvE1yIUmPm6wcn7cBmImMJ/Sydi4ZmZ178BbOazHPELs9FihikeJd7tY3
	dn7Dq1W5j1W97SVj1Ge/6xbnMJZHvOQyVzhO3MRQTIeU2il95q5zkRJUCZU1lE70KnOc1dh+DBn
	m6nxJxcETvLUchJent8LFle85JGdCaFJEwc0FhuPZ37dLtbkUz4OXF8pOYfWQWjGGT2/V3iMb3f
	9lwaKws5TV/HHgKM9ko40tD1d989p5RGmbFzIkBh3tQlGIncnJ5EP7f6knPlF8OM76bcK5pB+JN
	p3Ukyd3NCC9g0n0/6yMfCsZv5XrMqDoTqS5wR8H1z9FH7DS2CDAB/pI0MjS5jfunpg6Knj9oPO/
	z/ygQ3fZopqvMG1q7pcaDjU+xLLLbtmPIFtLQIwjhY2exTxZDwuJOw=
X-Received: by 2002:a05:620a:4890:b0:939:a1cc:f234 with SMTP id af79cd13be357-93c2509dec2mr122764985a.5.1790114700080;
        Tue, 22 Sep 2026 15:05:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c284a1cd9sm4296985a.39.2026.09.22.15.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 15:04:59 -0700 (PDT)
Date: Tue, 22 Sep 2026 18:04:56 -0400
From: Gregory Price <gourry@gourry.net>
To: Arun George/Arun George <arun.george@samsung.com>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, balbirs@nvidia.com, 
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
	kernel-team@meta.com, hokyoon.lee@samsung.com, wj28.lee@samsung.com, 
	gost.dev@samsung.com, vikash.k5@samsung.com, d.bueso@samsung.com
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
Message-ID: <arL2eTRaDeR3DCQx@gourry-fedora-PF4VCD3F>
References: <CGME20260720193443epcas5p167fa7d8490edfb4d8c0aa6a259db058f@epcas5p1.samsung.com>
 <20260720193431.3841992-1-gourry@gourry.net>
 <963815509.21784796303385.JavaMail.epsvc@epcpadp1new>
 <amJGUuBZ2857QjDB@gourry-fedora-PF4VCD3F>
 <360067785.01790071202608.JavaMail.epsvc@epcpadp1new>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <360067785.01790071202608.JavaMail.epsvc@epcpadp1new>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3BF6E1C0002
X-Rspam-User: 
X-Stat-Signature: i58mf9szb4p3ycdgm4819dgwm4iie8rz
X-HE-Tag: 1790114701-535215
X-HE-Meta: U2FsdGVkX18OQoLnFnS/ybt4aEkbjd8oZbe/OBlmgn5iJGowr9w4uSZ7la6DchbxWznTf2+8QEwC55CBE+JchCRixPLebn1hdVa62qPohyW+CB6+4xyEyqFrR8d52KrmwkdotxqZO8npJpwkNU2zFHZPzISKLx6W9dTqieA+foc8q90nQ7LGMTf83aORjA7W6qEFMOOSK8z21ulfigKc9aO5FMRgKSY3XuSRhwvOjb+YrUnsHHekHIbihMl5B1K900rWRT8KNwFTG4Flki1uloQqvExNAxw8NB3VcYxkA4ZJH09DCu/yy5/yqTiLwF6rD1v1s5wckhu5EmytYBNLtpL/dClCloNtFnqsG7LUpWCf3q75T5rQMFh3EZia0LDuX2fryUwbEjjitH19fTQyx9jxC56GUW2EY5Jm5IdNNZRlZWdXE+joZ7t1t8QPZet/o94DSDzhtx608wLSyR10Xct7CusmMwy88z0PSmW+13wWnqdzBGepswUGYiQMXDDnWyqyBuZTLlvx/pCeC22tNGCAvmYIpRDucH+NBBLAvvU5pePcKN22aSf7gAh8dPnHthOneNKDYir9mAEvySDoUvManskyDZhjcBJH8AFh5UKrgCucSUnfpIeHSQEdCPI+kFT34hC6oBIFAw7nGZZZHJK86MObXwFsA4049kl50EdLMvf0oiUqvDpr3EfPPcQZHkDZHYrmdJJXJCnyxtVitWoFxoCJwUExsMYnkLBYpAU1WTGUYeYNVgBbezMwyDMpXQ5rpaTb3wnSYijP5eaAVIRnncdiXGnv8JbfJjLnInwyG830VNTCbPISg/E10NZduIYCGbVbtOqPBxsORqIusya1zwT1TvBzBrhn3Rkr+nASDPXLmNIWkT4jPT78s5Kdx++YgWJl9RBdbNhr5KM8YH4I93Z0qx1c6HK7VrweBHYLKAEB2NGizdxwrtt3cfr2Ufon5OKJdSqMc39pLe7
 t6tjwTom
 9mMzWl9oXrAxlQl5lJ/7Ic8iBCI5tKupQqRXWoHF8rWR7cxgylt58BD472yCjQHCsGVo4xbzCksCEw3K4z0bUSkxlHJlrSgYHJTHtsb9SVVmgUWL4RtaaW6ZGQQzrTXp21sVeI3yQYMfjMzzziKSNssLTOgzMvCCg2AqZ66P3EeicHzDPjwU/R5qP3gsTTsvMJG3FIxMEuUa0bqGrwfgjPMbIJDGVPW0/aJMw2C8rIC6oG/ZUAD0rWBc6VSOsV6HxdBgwjNQvkXa59N93UITS7Re45eXX4rFYdPIL4RmavEHCYqYX7nCR/4XSQLaGlqoeU57omuiww5bPFQZqa1rpz2ezhb+xndT4N26BzxFQ2TuKrkk/9EO84BauD5uZ3rzBgvJT1BnzWiyvaPbJ/CI5sUPD7OMwGnicRjpebBsP+bNOPmA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 03:27:44PM +0530, Arun George/Arun George wrote:
> Hi Gregory,
> 
> Thanks for sharing the working branch.
> 
> Some of us at Samsung are testing the series (both v4 & v5) on a 
> compression capable CXL expander and are observing encouraging results.
>

This is really cool, thank you so much for spending the cycles to test.

I'm working on getting a v6 out soon.  Glad to see the progress!

> Good things first! We feel that the isolation using private nodes and 
> the capability selection using NODE_PRIVATE_CAP_* work functionally well 
> for the compressed memory use cases.
> 
> On improvement points, we observed much higher 'page_faults', 
> 'allocation_stalls' etc. which contributed to the higher tail latencies 
> in some tests. I hope these are already part of the optimization plans. 
> The higher latencies might have resulted from the write_protection 
> applied to the private node, I believe.
> 

Yes, this is expected, and I think there are questions about how it
should be optimized both in a provisioning sense and a software sense.

For example, exposing a full memory expander as 100% compressible may
not make sense - given that this could many a lot of memory.  I have
some data that shows it may make more sense to split a memory expander
into two regions to better fit the compressible region to meet the
actual capacity the cold-tail is capable of consuming.

On the software side there may be some ability to adjust this at
runtime with hotplug instead of requiring a reboot, but I think that
needs to be experimented with.

> On the tools side, we used MLC and Taobench for the tests.
> 

Great! I also have some TaoBench and fio results i'm looking to share,
glad to have some additional peer review using Tao.

> Note that our intention for this phase of experiments was to test only 
> the 'private node' layer based isolation, and not the cram and below 
> layers for the compressed memory. Therefore we did not enable/utilize 
> the compression capability in the hardware for these set of experiments 
> (enabling compression would require the cram level ballooning/memory 
> shrinking and cxl level interfacing driver to the compression device). 
> That would be different set of experiments where we would be testing the 
> cram balloon shrinkers and our alternate algorithms (upstream targeted). 
> So cram and below layers were used only for enumeration of private node 
> regions for these tests and not for the run-time memory shrinkers.
> 

Agreed, i'm looking forward to getting past the isolation bits and get
more focused on the compression implementation details.

> ======= Test Methodology ==============
> 
> We explored these 3 cases:
> 
>     1) (Baseline – existing CXL infra):  DRAM 16GB + CXL 32GB. Here we 
> used the existing CXL driver infra to enable the device. No private node 
> is involved. And compression is disabled on device.
> 
>     2) (private node in default write protected path): DRAM 16GB + CXL 
> Private Node 32GB. Here private node infra is used to enable the device. 
> And compression is disabled on device.
> 
>     3) (private node with no write protection): DRAM 16GB + CXL Private 
> Node 32GB. Here private node infra is used to enable the device without 
> the write protection/fencing enabled. Compression is disabled on device. 
> We could not complete these runs as they resulted in kernel panics. 
> Guess the code path is not stable yet for this (We had hoped that case 1 
> and case 3 results would be similar). We also observed some unmovable 
> page warnings logs in 'dmesg' before crash (might be related to the 
> panic). Adding the log snippets at the end.
> 

Very similar to my test setup, seems like good signal we are of similar
mind on the use case.  (For readers: there was no coordination here).

I personally did not test private-node without write protection,
although it makes sense to test the throughput of a demotion-only
node as a baseline.  Smart.

My guess is there was probably a reclaim throughput issue, or there may
have been a bug in the v4/v5 code.  I will look at adding some pressure
tests to my suite that test demotion-only explicitly.

> ========= Results summary ===================
> 
> Private (CRAM) node performance is lower compared to a normal CXL memory 
> allocation path. VM stats shows more page_faults and allocation_stalls 
> on the private node case. Could it be the allocator waits for migration 
> path to demote pages to private node? Or the actual hot pages in dram 
> got demoted to private node to make space during overwrites? We will try 
> further analysis on this.
> 

- allocator waits for migration?
  
  Yes.  And worse, once the node is full, migration will fail and you'll
  swap directly from the top tier and reduce your reclaim behavior on
  the lower node.  It becomes very important to push proactive reclaim
  on a demotion-only tier to ensure there is sufficient headroom to
  receive demotions in the future, since direct-reclaim basically never
  targets a lower-tier on the first pass.

  There's a big discussion about whether tiered systems need to invert
  their reclaim behavior (reclaim from the lowest node first to find
  progress there, then do demotion - rather than the other way around).

- Hot pages in dram 

  Also yes.  The comparison to make isn't only against a raw CXL node,
  but also against Zswap or Zram or Swap.  How does the workload fair
  on a system with 16GB RAM and 32GB Zswap/Swap?

  This is important context.

> ========== MLC Experiments ====================
> 
> CMD:
>    $./mlc --loaded_latency -j0 -c0 -b1g -k1-15 -W5 -r
> 
> Experiment Results:
> 
> 1. (Baseline) DRAM 16GB + CXL 32GB
> 
> Inject  Latency Bandwidth
> Delay   (ns)    MB/sec
> ================
>   00000  686.18   40137.5
>   00002  686.69   40124.0
>   00008  709.74   40362.7
...
> 2. (private node in default write protected path)
>      DRAM 16GB + CXL Private Node(Uncompressed) 32GB
> 
> Inject  Latency Bandwidth
> Delay   (ns)    MB/sec
> ================
>   00000  320.09   12186.2
>   00002  543.42   22726.1
>   00008  482.11   28385.2
...
> Takeaway: Our MLC tests show a trade-off between the two configurations. 
> During low inject delay, the private Node is faster. But when inject 
> delay goes high, the baseline shows better latency. Could it be the TLB 
> cache effects?
> 

These latency results suggest to me that the memory being tested was
always DRAM, though the initial memory fault would have been CXL.

i.e. even if the memory was faulted directly onto the node via
mempolicy, the very first write to it would have caused promotion.

If you dropped the write protection you'd probably see it equals the
baseline.

The bandwidth numbers support this.  Higher stall, but faster latency
means the migration was more beneficial for latency than letting the
memory sit on CXL.

Neat.  I'm not sure these results are particularly useful in describing
how a workload would react.

> --------------------------------------------------------------------
> Case 3 dmesg log snippet:
> 
> [   82.525741] page: refcount:1 mapcount:0 mapping:0000000000000000 
> index:0x0 pfn:0x5f5800
> [   82.525753] flags: 
> 0x17ffffc0002000(reserved|node=0|zone=2|lastcpupid=0x1fffff)
> [   82.525762] raw: 0017ffffc0002000 ffefc85717d60008 ffefc85717d60008 
> 0000000000000000
> [   82.525764] raw: 0000000000000000 0000000000000000 00000001ffffffff 
> 0000000000000000
> [   82.525766] page dumped because: unmovable page
> ..............
> 

Was this memory hotplugged via cram.c or did you replicate the code and
hotplug it another way?  If so, did you hotplug it as ZONE_NORMAL or
ZONE_MOVABLE?

For a compressed tier, it must always be hotplugged as ZONE_MOVABLE,
without exception, because otherwise it can allow a GUP pin or kernel
allocation that would eventually become permanently stuck there - and by
definition of a compression tier must be 100% movable memory.

~Gregory

