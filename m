Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03627CAC5B1
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 14:41:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B60E8E000B; Thu, 25 Sep 2025 10:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1669B8E0006; Thu, 25 Sep 2025 10:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 056488E000B; Thu, 25 Sep 2025 10:41:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DC2A98E0006
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 10:41:25 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A47514013D
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:41:25 +0000 (UTC)
X-FDA: 83928035730.23.1B7EE80
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id 54FD01A0007
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:41:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QBV3c3+c;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.166.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758811283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MonnHrFBlLbKfxAqCg2RgfcciUCPzHDcG9rP4ZA+VFA=;
	b=8OLry5dk7/GpPflhP+I7BuekhoZAh+QgC/6M+4XwaM3EqbeVPBvNHEUsgCslqSgeq/7W2O
	ZcjOw/EO6tmUmSHdzKn2G8hKmavzEYj5tkIQxO15dAl+WKDtdd7efRtZSpZ1o3+4V17Y+Q
	hFFA/v7B7YG1Ld44oiDlElEUiZ+qBNM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758811283; a=rsa-sha256;
	cv=none;
	b=DiQe4EMS0RVCzpJ7DP4x6SXONVjQTOp1xTYkUouOUUIppNdBZbIWFKiyaDkZW/PvuoLqum
	q+6tLqoZ6JKXlR5XyKeX42Ez/rJJrFwKxtirYnfXVHUxQ1rXZ3eCRjME33Dgg+s9rZZ0ub
	h0UjcvUJi1FC56mc/zdBcgEMFFhCKsQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QBV3c3+c;
	spf=pass (imf19.hostedemail.com: domain of gourry@gourry.net designates 209.85.166.53 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-8876de33c86so95666539f.3
        for <linux-mm@kvack.org>; Thu, 25 Sep 2025 07:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1758811282; x=1759416082; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MonnHrFBlLbKfxAqCg2RgfcciUCPzHDcG9rP4ZA+VFA=;
        b=QBV3c3+c1WjdJmS1lTLLobcQKWdVNQHusIlB0AAvkgniLxoMHjcmyjCGcFt5Ku5THH
         0lN27jOEx5ZI+m5fA+NiyBusYmn1yeJmZi2/+OcLFty2rEENkcwyHpX0k+VBRwHgg7DD
         ye0Qr5+7NzneSWU4nAwEUF7fIhY8cbrOaZW4h8uPd3u6NWJRjk81yr26CpycQFFmMQll
         pii1TN1R+UGkEGPlEqNIc2P4EZPx5b5aLJE1VbM23QUaH9sMzfhj2C1dIyHG4hcy0/5e
         8HGdN/kX/FtEIereQDTZ4NUmmIAm2O7SdMMAm4PfquLOiFtuNTqvz4s29AjL82w5cZog
         MCpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758811282; x=1759416082;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MonnHrFBlLbKfxAqCg2RgfcciUCPzHDcG9rP4ZA+VFA=;
        b=P1/bsNlTKX+OrkfSDzuKajzV2HYOwcrSwOBz3mYbVyIUqgUYLbzvES4SZiNxSzoC3g
         pOD1+ldAK8sMehEketu+dcBCEZwJm5JimlqFszHH8L2Ko7s5KtiftoxfgsJgbDyG4a9b
         7jF4/lXH42i8aNszCgK1gLw7svJIAiKErGE346ANAsfVLpsONgX5f1xV2slu1n62ZdFX
         mesR9FUHM4/R+46R7DPTe/rvQzju6nfP0+A0Q+z3uMtvQs2u+HDo1ey3nx12ea5+NQ5q
         YS/zt9PQ9HW9fZeaxC+UaaHcxQeYdGrVw/LOEZYKOs7GqGPiGNOKl5PNd/CR5Ltcx80+
         CmdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWiRyNdDzqwv1IORKdOwEOCTGhebBcg3UTuYO1z0WOqmx8jNYVA2yJY+cT8ymaap1awgdTQcPQiPQ==@kvack.org
X-Gm-Message-State: AOJu0YzrcZk2dPqxip6I5NpsynB//U8KpJUbqbXWL+tsqioBGdQ0pNH3
	qUh0HlZoQgOjuef73+qUpYbjXoXSd1SHLJLhxMn6XASFv1mZnyCvv2mj1OTvdib8VcM=
X-Gm-Gg: ASbGncvjtGnFR+/vvqEFz9JT3DVpkG6TGekHQV1rFbYwM49FXJnqa+jETen6n9K43Dn
	8C3osmFTBEwW4PBDky1qlOLA7TQ551vR1trUOzb6Q9QQgXhcN69KXIutxCEI6vJyaEc9x/pTeES
	rurkyVScYKfAk/DlqTE1SwOqi/DVN5t8Yeog5pYwG6tglbuzoO0ZL5fvU+TCpDgrDxFZ4bCUR89
	rlT8TQH225v2JDTO3dfCGIFmqLzttZ7UYx/K6H1iZyg+ie4flZQ9piBWaFp5DEnC6in694Hsr0J
	/rbWdSpu9BGsbgtQ8oMydbTXOWFWL49Osn5aco4is2dRXjFxjDlKDQxCSNPOMMbkeVfQhMK48r3
	jydomFI82/nmPczFNdpymQ5qWzbscWtbTQgU0MngmoRs4bnHlRMOHayeErA7r807pRv1LiAWu58
	0=
X-Google-Smtp-Source: AGHT+IFTMmFL5XyKbSmyHPZUijAtEKCfXMRWWA8DP+zvHaZMXznIcTuoDIxLpn6A+DpNfM4CvL5RkA==
X-Received: by 2002:a05:6602:3427:b0:890:1f62:492c with SMTP id ca18e2360f4ac-90153366535mr509131239f.8.1758811282156;
        Thu, 25 Sep 2025 07:41:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (50-32-2-77.vng01.dlls.pa.frontiernet.net. [50.32.2.77])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-56a6a5ae382sm875785173.64.2025.09.25.07.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Sep 2025 07:41:21 -0700 (PDT)
Date: Thu, 25 Sep 2025 10:41:19 -0400
From: Gregory Price <gourry@gourry.net>
To: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Cc: Jonathan Cameron <jonathan.cameron@huawei.com>,
	Wei Xu <weixugc@google.com>, David Rientjes <rientjes@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, dave.hansen@intel.com, hannes@cmpxchg.org,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, sj@kernel.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, yiannis@zptcorp.com,
	Adam Manzanares <a.manzanares@samsung.com>
Subject: Re: [RFC PATCH v2 0/8] mm: Hot page tracking and promotion
 infrastructure
Message-ID: <aNVUj0s30rrXEh4C@gourry-fedora-PF4VCD3F>
References: <20250910144653.212066-1-bharata@amd.com>
 <aMGbpDJhOx7wHqpo@casper.infradead.org>
 <aMGg9AOaCWfxDfqX@gourry-fedora-PF4VCD3F>
 <7e3e7327-9402-bb04-982e-0fb9419d1146@google.com>
 <CAAPL-u-d6taxKZuhTe=T-0i2gdoDYSSqOeSVi3JmFt_dDbU4cQ@mail.gmail.com>
 <20250917174941.000061d3@huawei.com>
 <5A7E0646-0324-4463-8D93-A1105C715EB3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5A7E0646-0324-4463-8D93-A1105C715EB3@gmail.com>
X-Stat-Signature: 8bc7u61j96efjo51how6u6r4gjirzws1
X-Rspam-User: 
X-Rspamd-Queue-Id: 54FD01A0007
X-Rspamd-Server: rspam10
X-HE-Tag: 1758811283-684071
X-HE-Meta: U2FsdGVkX1/zmGxBqt/V8wf9JZPaLWUSyfGiqzLHXlumtqdCX8Cb2/l1+/N/nKbfp/Qe374pIGjvt0nQmNkwPi2LM7WufQGsTtCsn5KGaqn7Ki4+WIDr4PEYoRxCXwzHl1ERepkhLnsfW3wdMR/sPoSS+o2KNo6DN5aLl0DKVe9OAO2rFJ1p6iWa1veLFWGnjs82gAjVZFJDMzIu7JtIw8cNpLaBenIRsTP6vaVuuX5N6ml+FS6t63oQLGAZKmXEtE2M05uN05UpNeNGa6HDxsss8N7OF4TExR8kG8Q0guiaeMMQH1qE+EynWbhnnigEPL1oMJL8Tyrwjhql5UzgUdFrcrincH8mdeGAuRt5umgqRIX+tG7btvD++5ZtZE3NcLpOHdNrpJ54sM8q/GCxgSOezV0gyd7IEU4O7o+JCuVWa7/mrwa1OB/XgZUD2xuzmqkhflBgrtVGaAGvG4ifGiFBrxAYypDEZ3pR282TgdcF1/GaGAxqdTNEvbt7dTHU2jAYJGnVpud7GdSxqGE6kqEQ6DJPDH9a+gBVDJj6fqOx9/xXoHNrKvDQD6vdwuKQxRtftr/MPyxlUPupQhzujFs99B8c9gmzLKds+hUiKjfYLzTyCkGc13RuZCxFDLFwG3JEX6RhNxp+f0yC3r0RCNkymVblSZ6XESBcqlGWBYrYCB8Fdpfp3jLqm99s4Vqq/uqR5gzfFLS3j7wda5kl/zQDkTn6ANtM+pDG+Kuifn/4y0fYxoxRyk6axcihDBPO4UzqKvYx32s21D2swqkx+6RQfQBOAbu+wb6VPnknhx44g1fOKVTTxquIEuW1fuRBqW/8tN9BSQqVEtfYhqag+G3YA3RcdSib106qucflR6VP4Q7Q/wHifYFxFaniYo/yPb446p9Q6cNxbQ50zHAyCgb9Fwt74vDjgmK3r3vwdRwoVgKW1ECCvVVI67zmMHm0M7AYmFHnk/SsRxIZp5g
 ydISQvd+
 5v/EAWdSl8p7yFpEG6gJxd6NOKaUYgQaRNdlByita0Blt6WEAe8n1t4dXACkYNpRMHBU+b26FPBjSF8ueZ9MiiwzJkIGuiotZn3tw1DR/mWJzupEzQtEC+oHg22LV0bdw6paP9G7NMFzYroAc1Ef/6cy04XWgbe6tAGKtXlbBJB8+IR22+IEzVno3qc6a0wNJPIJ/2LZ1gBeSErrClvToKUUFILDQ0wd3bLxqY4y7KQrR/JpMPNZwmA98XW3BJGEOPpG0Z4rp+zj0eGdOhP7RDp1QZbK73wHPrWXm+BOBwdeZKdxLQHRxXX9UtKTcewWuoTn3aHKbT/WL74jdA3+4zy+eje5CCMZ7It9zEen/N5NC1gtwylkdYbRWZ954JLzK8ZIy5PqeSb6srrnPrAxB6FE1bw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 25, 2025 at 04:03:46PM +0200, Yiannis Nikolakopoulos wrote:
> > 
> > For the hardware compression devices how are you dealing with capacity variation
> > / overcommit?  
...
> What is different from standard tiering is that the control plane is
> checked on demotion to make sure there is still capacity left. If not, the
> demotion fails. While this seems stable so far, a missing piece is to
> ensure that this tier is mainly written by demotions and not arbitrary kernel
> allocations (at least as a starting point). I want to explore how mempolicies
> can help there, or something of the sort that Gregory described.
> 

Writing back the description as i understand it:

1) The intent is to only have this memory allocable via demotion
   (i.e. no fault or direct allocation from userland possible)

2) The intent is to still have this memory accessible directly (DMA),
   while compressed, not trigger a fault/promotion on access
   (i.e. no zswap faults)

3) The intent is to have an external monitoring software handle
   outrunning run-away decompression/hotness by promoting that data.

So basically we want a zswap-like interface for allocation, but to
retain the `struct page` in page tables such that no faults are incurred
on access.  Then if the page becomes hot, depend on some kind of HMU
tiering system to get it off the device.

I think we all understand there's some bear we have to outrun to deal
with problem #3 - and many of us are skeptical that the bear won't catch
up with our pants down.  Let's ignore this for the moment.

If such a device's memory is added to the default page allocator, then
the question becomes one of *isolation* - such that the kernel will
provide some "Capital-G Guarantee" that certain NUMA nodes will NEVER
be used except under very explicit scenarios.

There are only 3 mechanisms with which to restrict this (presently):

1) ZONE membership (to disallow GFP_KERNEL)
2) cgroups->cpusets->mems_allowed
3) task/vma mempolicy
(obvious #4: Don't put it in the default page allocator)

cpusets and mempolicy are not sufficient to provide full isolation
- cgroups have the opposite hierarchical relationship than desired.
  The parent cgroup will lock out all children cgroups from using nodes
  not present in the parent mems_allowed. e.g. if you lock out access
  from the root cgroup, no cgroup on the entire system is eligible to
  allocate the memory.  If you don't lock out the root cgroup - any root
  cgroup task is eligible.  This isn't tractible.

- task/vma mempolicy gets ignored in many cases and is closer to a
  suggestion than enforcible.  It's also subject to rebinding as a
  task's cgroups.cpuset.mems_allowed changes.

I haven't read up enough on ZONE_DEVICE to understand the implications
of membership there, but have you explored this as an option?  I don't
see the work i'm doing intersecting well with your efforts - except
maybe on the vmscan.c work around allocation on demotion.

The work i'm doing is more aligned with - hey, filesystems are a global
resource, why are we using cgroup/task/vma policies to dictate whether a
filesystem's cache is eligible to land in remote nodes? i.e. drawing
better boundaries and controls around what can land in some set of
remote nodes "by default".  You're looking for *strong isolation*
controls, which implies a different kind of allocator interface.

~Gregory

