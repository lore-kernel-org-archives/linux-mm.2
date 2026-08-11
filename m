Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27066C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 15:30:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DFA76B00B2; Tue, 11 Aug 2026 11:29:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B7CB6B00B4; Tue, 11 Aug 2026 11:29:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080256B00B5; Tue, 11 Aug 2026 11:29:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7FB06B00B2
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 11:29:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A54EA287E
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:29:58 +0000 (UTC)
X-FDA: 85089374076.16.B16E9F8
Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 96871140004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 15:29:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pOXwmdpF;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786462196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMGzaTR2fG9A9c/MgSioyYDGHbbLKIjYxPc4ZGRn4m8=;
	b=eFZNmnY43URj+kiEyfO1Q7e7z2WNFk+Bhv+ke6QszulXXnBJqBbrgw9MvKdN0h/KcV/bMu
	yi+8zrrnCW8tAADnXP1UUjsgrUNhF+YwZaq62OAZCOJJjxKL4z0csAPEKaOKSRSL6wq7rZ
	j/Vn/jm6iWGI4CQ3mDUkUoFl+6jRPOk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786462196;
	b=UOBobgP9NkbMdP1mi6443TC44ETnWueofqS1cU1oJ2pa6R4oIaTNgnpmue+6rUHv0CtqSz
	jEQu90OhD9x983O6sQ5DlpGL2s7mhXmQFv8Zmfx0kRM5+XUU/oIE9vLkfVx7r2XigOcZUk
	JCqpY3jEKin6is5hYBVHNF55bOS5I2I=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=pOXwmdpF;
	spf=pass (imf26.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.44 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7e6b5737bb2so50730a34.1
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 08:29:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786462195; x=1787066995; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dMGzaTR2fG9A9c/MgSioyYDGHbbLKIjYxPc4ZGRn4m8=;
        b=pOXwmdpFufAyW7sv3DTUK+npwMig4edx3pVVZQJ2hAdImNKiOAvEI1QwRNTCa6AZ6l
         GU1ALem5gKxBAV73jlWSCdqvjTqf2TnNgaYO+U51I3sJUAs310Rxl/LMG2ZNtYmQCyJM
         GweAQ+Q9qoVRXBoS0Evgg5LSsaQI54Oimi7HvIlG4yS5S23z6DHPFnIejEAXqTcN8FBw
         cwyJZBKTh/VNgOH9NWhPmqQs3YEfCG9EHm/8C6ZXWC2D/w34/1hJoccUvdZGtplZFrNs
         7pDsxHxRFd/prKFLPPCZHt/aHukkCic8IUg0GhTsxhRsRVTPjeg2mciLZ/Uz7jq1dawz
         QoRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786462195; x=1787066995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dMGzaTR2fG9A9c/MgSioyYDGHbbLKIjYxPc4ZGRn4m8=;
        b=s2rl7k5ma+gFtW+CCi0O+IYs4R6sX4tTxyqW6kzUnRiSR3mp81jdk8lYkmi8ZSyTRg
         VSOz78ZUQ+V5TwlhQAl+Jhr5c30ymGm49hG9AaURr4bdmCEEVl1MpkXpY8HQX7F3lHO5
         cEbEmmb3vNoGaMBb0vWRcSlP+2XXQ9UiVlheleKTsoTUrhLjxakB1WQCRsU18P2Iot5X
         +mFVIB6HZYf4dgajxTzLZxP6dnd29NE8s7VAdG0uS8IFn7JNxuiugCQ7s/sE/avEJ/av
         BwC3yohk3fFoWG3vbMWGPT0Dg9ttJTeK8QeXaY4G7s6Wz+3Epvv8Pnsurfqn59tP/2EM
         EuLw==
X-Forwarded-Encrypted: i=1; AHgh+RquxznMeFL7BPilHHpxrajUkB0DXXIxbkuGHiDHSLvz83jWg6do+Fd0nYfDSdDdTpMGwSsa/W3ylQ==@kvack.org
X-Gm-Message-State: AOJu0Yy8+4gA8FMGFsBaamY7vmbwH02/ZGFPoga07jnyivXw8dTjmzHO
	F3ny8kD5JsS/5qKuNtjY7+lRrWJcvXBPNz3ktNPUmZDiHA+btr9YvWiA
X-Gm-Gg: AR+sD12eTLyJ/2wqdDxrCanbPsPYDvys8VRc7AUf6qU03jP9/0pSdIyL9J9ql7XSt2j
	VhJoIdkVP3Yvn8kaQXeoKUSlxr2GnFhLqFihJQXmG87mdiHlkmXH7TLa6OPuH2P3cIes05EThYY
	dBeKFxjYHHUTmy5MocokTfnizyv9Pl/1lP/gvWgQr/Ql5IsL8bZImu5Xe8ip16brwutI6GgXvtb
	YC0KmUB5yeHt0kY5smswLGMiSMIIcJDne/v44zTEafI/NV4Cuf21hbVOl6jxlOX3M5Tmes1bBld
	Ng3UijDRXDuA/S1j+4sZ2+TNrGpn4R7Xb5SDaC/2275IZVx0eZZ/xvNt3LH0isqvp6aJPlNym0Z
	Hvnvher93nRNP6riYjgUNxKt0LTHjQIGunlw/NNubyO69WQPWlHFOjBrCBJWSzau/qowGUcZPd9
	7iYh3czwbhPcrdktIofDk4B+/Du8H/JTQJ4jwAQtjW5kIo8e7Rv4JdPGKLcAirL0J+4X5yFJVme
	k+zSe+IaMsm92LkNBRd1ksrGaJNlw==
X-Received: by 2002:a05:6830:6617:b0:7e7:16b9:e274 with SMTP id 46e09a7af769-7f3a8203291mr3055974a34.8.1786462195335;
        Tue, 11 Aug 2026 08:29:55 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:48::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f3b34266f3sm81980a34.24.2026.08.11.08.29.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 08:29:54 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Rakie Kim <rakie.kim@sk.com>
Cc: akpm@linux-foundation.org,
	gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	byungchul@sk.com,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	dave@stgolabs.net,
	jic23@kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	harry@kernel.org,
	kernel_team@skhynix.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted interleave
Date: Tue, 11 Aug 2026 08:29:51 -0700
Message-ID: <20260811152951.195315-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260806080936.421-1-rakie.kim@sk.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 96871140004
X-Stat-Signature: h4a4spazddnjs5p66cq6i3zpggarhast
X-Rspam-User: 
X-HE-Tag: 1786462196-796609
X-HE-Meta: U2FsdGVkX1/9pcuHO94D6bx27RW+hC93QUyq4eQE5QLOFH2QuNqCzVYW5oAs8QS3TJviPOIU1syUF8CDk03d+0isJnkraYBnTAmpOGxn79sYlmsEbyHtmvht3GmQyGHk9ppMQN+q4LubVl3QycYOkJpsa260k4IwfQ//6FWZi945KYzasbsJLwz7IFY+x+unNi77N9B74xHMs1HWSrcgai+FHg7oDSZX/O08J72imZQSqSdcWR0OzdQi+i/P+igTqBEDz1dtwZ22Y8PPaEP2+2QkQsKaGvzrxTNAvMhyLlWfv450yGK2UsUEXytqdI3e2jx7AatY18WEhszK3VQ2UHE/O+rfoE62Y6wbAncwyWeWjWITS5BUqJq33yDppSnyjDZBxGnX/cux0GmIeHCNad7D2qsbkSlU2iw0cELwUznXDe1OxCiChQ2QAkxPk1jVWqztkb79MsUcHUVrNdAm+AGk74nI9xLlvJi5kOApD/EhEJImFm30QqJueUw7fdtfaQs2YPAs2F+h2/BVwJIg7EHv/Ve7eG5hhuUQ6d66dEHNj9yjiGqFrZOdcfdKNsC9BQ+7/apmEMZEBRUUGgA1TBve6T94D9aYnrQPJide84baNloUDbqXepJ9iIqOV07LM5JTySmG5j5cwobIBp/3VznzDlUbwF/hTKG8Ty33mEVjuxiVPhUFuSia2opGFHOdzLB9/jNGLemY8OA7+fFTvwPSs4cDM64t4ZnHv03kgoc5ANeSL2bNi5VdC8e6f5VVXyc+ylxG86PjhtmS3VPhh1lVNFAmMsMXB1N2Cte/xuMcyeUUtCOzJa2BWN0zUvaJSTk4bvSSkhvfJ9I+3eNfzOPOyVpMHO/rrQLTaYpGSr01VjTFJ6758r2VeBYb+4AOOyRc/+f6+Wpj0AoQ232gYynxQQYEZyl6OsNL5Wq4ct9blVdtU4YqDkSauVeA8dPgkTcdIpZoxbd93apFkaZ
 bhVP0/ov
 bmP99vI2YHYnt8j47NRryO7I+RVmioyeV7YLWzK7TATqffG1gGwt5NDLETtdERk+b2fsvftZxyhXiQxIkANNwzmzKuOt5x2RExWJngHpVXiUeOjI9nDCYLvgi9NT0WGU7JAJYKsmDoi2XTVVPYEZh9HTsvLxP5tI4gQ98/rscqgC9kt+JfZwT/MYI9DzP31yFtapHUmpxxeMDNI5hahXCblY75cjIyMCoUVDtfWEg6nxOjZD2Xoacwr2j6jFOi5MwK8RVUo11EvpuiGX8qiCVcuPoBe+SC9CYMtmEfuv/Hl86SKlKFaCoMY6cvqsBOETIyE1v8o1sin93VDhSWQUz0ko2I+tB61j6U7SY6mdunIL4I8IM2dwYCNHi0/G9BPavC2Scbf1BGtiPbDsC4XySD4ctOUjYomuGHc8V5l90HCLMFRNRtroNChKY9C4Z76zEdySJKC+mH95/jF8syjPKWaEqdSod2iof4VYJmLqifcN0wygzxjxVzCqSbuSB8i6zH4RBFU88CDYLd52fDXsq+jWRnkpOUSgg7/HYNLDpn+uVBZtrVSae9AFxu/hNiVerd/izx2BkpiHcqSJHvpnJq+LcQ0d1rJ6IdvbHZPzseEhft2zGZZiaW7Wj+e7neBbOy+fqj1EsbRJ4CGQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  6 Aug 2026 17:09:31 +0900 Rakie Kim <rakie.kim@sk.com> wrote:

> Package-aware weighted interleave places a task's weighted-interleave
> pages on the NUMA nodes of its local package, so that interleave traffic
> does not have to cross the interconnect to another package. This keeps
> each node's weight aligned with the bandwidth the task actually gets
> from it, so effective bandwidth holds up on a system that has more than
> one package. (A package is a CPU socket together with the memory
> attached to it.)
> 
> Changes from RFC:
> https://lore.kernel.org/all/20260316051258.246-1-rakie.kim@sk.com/
> - Added an opt-in sysfs toggle (off by default) and a read-only sysfs
>   view of the package topology
> - Added topology validation with a clean fallback to plain weighted
>   interleave on unsupported topologies
> - Hardened the allocation, device-teardown, and node-hotplug paths

Hello Rakie,

I hope you are doing well! Sorry for the late repsonse.

I have a few thoughts, some of which are carry-overs from the RFC
discussion we had before! I think there are still some open questions,
and I wanted to get your opinion on some of them.

My first question is whether we want cross-socket allocations at all.
The examples you gave seem to line up with node-restricted interleave,
as opposed to cross-socket interleave. I think the wording that you
use to describe the feature in 4/4 (which I will copy below)

> The resolved mask is by construction a subset of the policy nodemask, which
> mempolicy already restricts to the task's cpuset; package mode can only
> narrow that set, never widen it, so cpusets and the task nodemask remain
> authoritative.

is 100% the right way to treat these package-aware (socket-aware)
interleaving allocations, but the example below

[...snip...]

> Applied the same way to every source, these weights give the map:
> 
>               node0  node1  node2  node3
> global:         2      2      1      1

[...snip...]

>               node0  node1  node2  node3
> from CPU 0:     2      0      1      0
> from CPU 1:     0      2      0      1

Is essentially the existing weighted interleave mechanism with a 
nodemask/cpuset applied. With that said, I think a more interesting and
illustrative example would be if the user truly would want to allow some
allocations to go through cross-socket, but be able to control the
ratio at which these slip through.

              node0  node1  node2  node3
from CPU 0:     3      1      2      0
from CPU 1:     0      3      1      2

Maybe even more illustrative of the true capabilities of this series
would be if you have an asymmetric system where you bind some
host-level monitoring / logging workloads to one node (say, node0) and
want that to be able to cross through to the other socket, but not the
other way around:

              node0  node1  node2  node3
from CPU 0:     3      1      2      0
from CPU 1:     0      2      0      1

Anyways, these are just super hypothetical scenarios and I don't even
know if the configuration that I'm listing would really be beneficial
for the system. I think that coming up with some illustrative usecases
which are now made possible by this series could help motivate why we
would want to interleave across sockets. 

> A task on CPU 0 now places pages on node0 (weight 2) and node2
> (weight 1) at 2:1, which matches their effective bandwidth of 300:150;
> a task on CPU 1 places on node1 and node3 the same way. Placement
> follows the bandwidth each task actually sees, NUMA locality is
> preserved, and interleave traffic stays off the interconnect.
> 
> To make this possible the kernel needs a notion of which nodes share a
> package. The NUMA distance model offers only relative latencies and no
> structural grouping, which is especially limiting for CXL memory nodes
> that come online without an explicit package association.
> 
> The series adds a package-aware topology layer that groups CPU and
> memory-only nodes into a "memory package", built from the physical
> package ids firmware reports and, for a memory-only node, an initiator
> CPU node or SLIT distances. A package can contain more than one CPU node
> or more than one memory-only node, so the layer maps a package to a set
> of nodes rather than to a single node or a single CXL device.
> 
> The feature is off by default and opt-in through a sysfs toggle. The
> package topology itself is exposed read-only under
> /sys/devices/system/package/; there is deliberately no writable
> override, since a machine whose firmware describes its topology
> incorrectly should be fixed in firmware. On a topology that does not
> have the symmetric shape the placement relies on, enabling is refused
> and any active mode degrades cleanly to the original flat behavior.

I was also hoping to see what this interface looks like and maybe
discuss how we should relay the information to the users, since this
seems to be a new addition from the RFC.

> Measured results:
> 
> System Configuration:
> - Processor: Dual-Socket Intel Xeon 6980P (Granite Rapids)

I think a description of this system's topology would help me understand
the results below a bit better : -)

> 1) Throughput (System Bandwidth)
>    - DRAM Only: 966 GB/s
>    - Weighted Interleave: 903 GB/s (7% decrease compared to DRAM Only)
>    - Package-Aware Weighted Interleave: 1329 GB/s (1.33 TB/s)
>      (38% increase compared to DRAM Only,
>       47% increase compared to Weighted Interleave)
> 
> 2) Loaded Latency (Under High Bandwidth)
>    - DRAM Only: 544 ns
>    - Weighted Interleave: 545 ns
>    - Package-Aware Weighted Interleave: 436 ns
>      (20% reduction compared to both)

Really awesome results!

> A small CXL driver change registers a CXL memory node into its package
> as the node comes online, using the initiator the driver resolves for
> the region; this is where the package layer gets the CPU-side
> association that plain NUMA distance does not carry.
> 
> The memory_package layer offers a broader interface for grouping and
> querying package topology - usable by memory tiering as well - and
> package-aware weighted interleave uses the subset it needs.

I was hoping you could expand on this a bit more. Aside from the
alloction-time placement strategy, did you have other ideas in mind for
who could ingest the package information to make tiering decisions?

I definitely think this series makes a lot of sense and I am
hoping to hear more about it. Thank you, I hope you have a great day!

Joshua

