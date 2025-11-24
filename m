Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CA1ECFD31C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 09:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73FB36B0011; Mon, 24 Nov 2025 04:20:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718546B0022; Mon, 24 Nov 2025 04:20:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 654486B0023; Mon, 24 Nov 2025 04:20:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F1256B0011
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 04:20:02 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 23CE113A2BB
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:19:58 +0000 (UTC)
X-FDA: 84144953676.07.C595A74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 562BFC0011
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 09:19:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GFCQiqYK;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763975996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EQGAbrHjPGLlosuuOJrEJQkk2dE2pL5Np/K8fbrAbog=;
	b=Fz348refPzgM728g/nV2qVw4wOXEofPiSXOuy/Lg1VyJ6SzOMytDmsWpA4Ea47cch59jsE
	hPg18R3Z3VJaXLv9xviSeQifX2uJCzOY4QAXJXkb+pfuAU20jvB2FQ2Of+9bqUY3ZVBlr5
	2dGE5871M0b3t1B62SuBtGdmRkAjAPY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GFCQiqYK;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763975996; a=rsa-sha256;
	cv=none;
	b=bCOdZz3pMp5YWu9p8/+QgBYTGPLAMIlbTLeIFLWhbM8zzZ+SyAErrKckKYaGuOZ5jtRr6v
	96oVeP6qtcCs6lH1LBAgCzy7oznzvpVRbXuuOTY4rI5d4vikYx43t5JrvEguxbkgKtFQxo
	nI8Pg3e9uds3o8MxT5xb3hL/tqU4muQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 54AE644194;
	Mon, 24 Nov 2025 09:19:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96C39C19421;
	Mon, 24 Nov 2025 09:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763975995;
	bh=Uwsm69iJr36s6Dx79ksuQKNJ6J1krQHDg+amvtrWEWc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GFCQiqYKon870o58vf/NYMJtPCbHtRI8ZICYKlyCfE81df7+gpBmxPj3EbeLSHO1X
	 1UvuSAoCl4U9xj6Jbr0HAdBbzo9o9t5GQOecPxtK3wA4xyMC4Ic2KM0oHSVCP64Y1D
	 SnlgxQcsPs0hTQcZV+GXo3/yHD5qNM1blQylkWVXWWjJUb6SwjTit+ANBY3Xiano1w
	 q3NY53RNpfjN5zI+iWgsCLWFCKSxdmkDazDpCnd4Vs9x9uuXIPFaTtWnsNyfBXhlMV
	 /r/Hldd8z7RlyZYsGRfELm50EShpyk1YO43/5Ie0fuREjfPoTOGwbFJtvub2RdD06r
	 WHP6KFE7wH66w==
Message-ID: <de15aca2-a27c-4a9b-b2bf-3f132990cd98@kernel.org>
Date: Mon, 24 Nov 2025 10:19:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC LPC2026 PATCH v2 00/11] Specific Purpose Memory NUMA Nodes
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: kernel-team@meta.com, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, dave@stgolabs.net,
 jonathan.cameron@huawei.com, dave.jiang@intel.com,
 alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com,
 dan.j.williams@intel.com, longman@redhat.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, osalvador@suse.de,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, mingo@redhat.com, peterz@infradead.org,
 juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com,
 rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de,
 vschneid@redhat.com, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com,
 kees@kernel.org, muchun.song@linux.dev, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, rientjes@google.com, jackmanb@google.com,
 cl@gentwo.org, harry.yoo@oracle.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, zhengqi.arch@bytedance.com,
 yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
 fabio.m.de.francesco@linux.intel.com, rrichter@amd.com,
 ming.li@zohomail.com, usamaarif642@gmail.com, brauner@kernel.org,
 oleg@redhat.com, namcao@linutronix.de, escape@linux.alibaba.com,
 dongjoo.seo1@samsung.com
References: <20251112192936.2574429-1-gourry@gourry.net>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251112192936.2574429-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 562BFC0011
X-Stat-Signature: zyyxsc5mtmhxbakym9ufscusgngh471c
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763975996-850426
X-HE-Meta: U2FsdGVkX18xbemozFrVuEH4pp5F1WCUjDmpvOlS6VBIG1FGcLsHy5v0D5L02AqON93FqAkCum0j2SlsNy205HPTOqAykBU0zmGjaU4ALNQrQZSGovL1B6O0Wk/ZBB3nz5TBFYlg7wUPq67glUmS941e5ST6vrm6dumk4uql/OHkNlU1qygEKQVbznYV01yB6cBRy0Iy95yvN4g3j/tEiL6v96rMY4AuN1anoqcaPCFKE28ws8H64J6W3EGkcuMoO6lSha+2pFqHkJ5cnLJ4HkNAL1bTRuIUH+HCOtT/mxkSqlIfMxl4vyFZ9yvLgGgrVdUdE8xOOV0VfmUvZHzCh7uUowOnsiUkW+XLqaSDsA/um9QB96ERagQoYEBqqY2f+xoFZJRTEB+BQtDBnRBqVfy2YExXfeNZgGjqaXp5xfL1w18BEQg8HA6fC+4rn8qclRYsQobcM+ANo/53zTpLeAbOuizafOngOgmtwbcuByZYTNJ9SVXxELbskrg3jdwnJeU5HX8CPBKdbZ8WgfUs9UV+oLJTttx1ZYR/ET4cEh7hd3ZnCekkZViLyr3wfTlnZ/OlBnP14OCI5bzGbZfWCWTsB+fj6dj15m6kE4QFxj93sEc2V5dlc2ijceKlrEMRJpRpu/TtIRY6YqdfVp0Fe1UV5lbREzZZY6AvGz7Tt9uw8B5cBp5tXTVjWKoviB4+nBfOhXrTYw3Ytll0dIeMAMQEj2UFhMV3TVMpwmIIQsRG/3M5kvXK7wuAJIRId+tadhMJ88rYdTccjLMkFp44L6qkJgdtzd5jbUk0yk62Mlv1YoJoEXW7nd8BLp8UR6GdVRIvsXbpg83xc7D8KEYlwkSg4L7cIosxng+lLvmG5T4iOLWDbxDu+4IoCBmtjoWu3xNPr6EjJQuawN+iF5iczZMNi9UzJneJe1u0EgAnIoIPd++PECutWaVmBKCc+xK5HGURpfd3Ha70Mh1ScYk
 wA6J+96d
 L2OiXhf/XSIa9ROzFNC3J56lxZd17pxqb7kGu305+EEGWfbJILAZK1xYGpkCBRtHjj0qT8d83UbnxOtXcXU6VmuJczDa+KJn0aZ4ByEgCoOG15fuQzGdq0La7PIvvpWveAqLUuAxvgxrQvvzm1N0TsOVBJ+pcqqX0/9MpPrD87lCnL2iSekCeQ8YBb6VHkkm7Tuj9pn0fv53WP5cPOhRTqMWc2lpuwRqfGPXU9NUPuBtKYhXeYXYXWwg5KtojKO1iBSVB7qZngcaInuygsTnk0Ocl1BWKaUX7DFx4HTIlCfP1sLSEBYXhZhoSCl3ySOXYqK309uJNYbBIVa2me73ax62P6ZYqIfLTTXOM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[...]

> 2) The addition of `cpuset.mems.sysram` which restricts allocations to
>     `mt_sysram_nodes` unless GFP_SPM_NODE is used.
> 
>     SPM Nodes are still allowed in cpuset.mems.allowed and effective.
> 
>     This is done to allow separate control over sysram and SPM node sets
>     by cgroups while maintaining the existing hierarchical rules.
> 
>     current cpuset configuration
>     cpuset.mems_allowed
>      |.mems_effective         < (mems_allowed ∩ parent.mems_effective)
>      |->tasks.mems_allowed    < cpuset.mems_effective
> 
>     new cpuset configuration
>     cpuset.mems_allowed
>      |.mems_effective         < (mems_allowed ∩ parent.mems_effective)
>      |.sysram_nodes           < (mems_effective ∩ default_sys_nodemask)
>      |->task.sysram_nodes     < cpuset.sysram_nodes
> 
>     This means mems_allowed still restricts all node usage in any given
>     task context, which is the existing behavior.
> 
> 3) Addition of MHP_SPM_NODE flag to instruct memory_hotplug.c that the
>     capacity being added should mark the node as an SPM Node.

Sounds a bit like the wrong interface for configuring this. This smells 
like a per-node setting that should be configured before hotplugging any 
memory.

> 
>     A node is either SysRAM or SPM - never both.  Attempting to add
>     incompatible memory to a node results in hotplug failure.
> 
>     DAX and CXL are made aware of the bit and have `spm_node` bits added
>     to their relevant subsystems.
> 
> 4) Adding GFP_SPM_NODE - which allows page_alloc.c to request memory
>     from the provided node or nodemask.  It changes the behavior of
>     the cpuset mems_allowed and mt_node_allowed() checks.

I wonder why that is required. Couldn't we disallow allocation from one 
of these special nodes as default, and only allow it if someone 
explicitly passes in the node for allocation?

What's the problem with that?

-- 
Cheers

David

