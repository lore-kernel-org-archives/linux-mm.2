Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A672DC53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 22:17:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FE706B007B; Mon, 27 Jul 2026 18:17:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AEF06B0088; Mon, 27 Jul 2026 18:17:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C54B6B008A; Mon, 27 Jul 2026 18:17:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1266B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:17:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7550CC01FA
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:17:10 +0000 (UTC)
X-FDA: 85035968220.06.ED81016
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf17.hostedemail.com (Postfix) with ESMTP id D92CC4000A
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:17:08 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=GsmIl0hX;
	spf=pass (imf17.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785190629;
	b=wYffzZmYqIfuhK5kHAMcGeFH9NlGZW7xrhQa3mweOIjFpJggO7I6bBwloNK0kRd82cC6zJ
	mB1+vdMEHKPU7IjV6EwVnoTHY97ujep6gM286uTUhGiCWoqOv3DR6gvaMV4XDpZCJULvRb
	q5kGX22XilrL0iHIq8CPRQO+C/YRflk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=GsmIl0hX;
	spf=pass (imf17.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785190628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0JjD6lkFG+20UmtbdWZxcSfJM0w+DF0///X2tria5TU=;
	b=6VI9K0gOPTunPxUNw3z2k7/oSvJj4KM8evrLnfLEkJtLV7g9r5e3DSL0FsOhYu7CCTX6MJ
	sd8Nnj7Uqan/rdM3HF/ab/yf/TvBiS8HhOSGuc6VQl7vsLvcwEfDNqLe6u880c55WeRpCG
	3UylWfCBaMHsSNFwMn0LAfr80hTCiSw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1785189987;
	bh=0JjD6lkFG+20UmtbdWZxcSfJM0w+DF0///X2tria5TU=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=GsmIl0hXdDi2A+F3WW3vwTaE1qAEDh8CDi57M+9dpVeT7GPRHBTxFgdMnhzxeVyXC
	 1GmsQ5DzDRWgK4lpCB8RH3ku6XZwWRqSn7DdV96ERj/Se2GsDU7W0Q1nrhIzd4W+BB
	 SUUi6XIXSIQpNVqEBcWKk/1mSXCEO25lBAPx+vuI=
Received: by gentwo.org (Postfix, from userid 1003)
	id 5D65B406C9; Mon, 27 Jul 2026 15:06:27 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 5A28340112;
	Mon, 27 Jul 2026 15:06:27 -0700 (PDT)
Date: Mon, 27 Jul 2026 15:06:27 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Mark Rutland <mark.rutland@arm.com>
cc: Yang Shi <yang@os.amperecomputing.com>, 
    Ryan Roberts <ryan.roberts@arm.com>, dennis@kernel.org, tj@kernel.org, 
    urezki@gmail.com, catalin.marinas@arm.com, will@kernel.org, 
    david@kernel.org, akpm@linux-foundation.org, hca@linux.ibm.com, 
    gor@linux.ibm.com, agordeev@linux.ibm.com, linux-mm@kvack.org, 
    linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 PATCH 0/16] Optimize this_cpu_*() ops for non-x86 (ARM64
 for this series)
In-Reply-To: <amCPBrdltFSE_fEf@J2N7QTR9R3>
Message-ID: <25d1e09b-53e4-7cd5-87db-b58437e4e690@gentwo.org>
References: <20260715180455.515692-1-yang@os.amperecomputing.com> <0344c559-1959-4531-9265-d5a5180eb7cd@arm.com> <fc21c840-1584-4844-963f-80cea7f2e674@os.amperecomputing.com> <amCPBrdltFSE_fEf@J2N7QTR9R3>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Stat-Signature: jeyje9t6wr48kt7tmpn455imura4kgia
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D92CC4000A
X-Rspam-User: 
X-HE-Tag: 1785190628-150450
X-HE-Meta: U2FsdGVkX1+DW0sXpuIXV5M7rwjI5XTJa9CY7pzI8K64dmWWWm0Qz6xyH+Fkum6FqrBSs2d9msxk1ODIOjqbQJDa73n37LtfhTH5NKqyfw9Kz/Z5GDJRXPF8VKFcxurgxBZHV28KI44V3sIKcHItmA7pzqoDM4a1mR7dTO6sqpsm8vo/WpUgRsgohodbkEpteGzqjH3wwFlbNVWiR5AxWrMMOtRHBAsnf2E9hCfa+xGCV8V5eQQMss+uGUBGyFocu1Cnb3kUKjRpnDyUpYE7pz1mxSGAEWZjFFBvgP+WVE6+n92MoxEfYAjhxgMi6L+0q6Xx3x8zIla0khQwkh/7q8XfvBeKcJJcfpa6CYV8P7FufpEFqrQiqxaIjTpzLNkpfdb1b3TsJ4VhD1UEGncK/mGqR+0abEE+x+V512Zc8VH2Y4jT3BHnX3yaKv4bIt5LGukIG5NPOxUVqClqJO50KRPlJm0M40Wb6MXfx/Y0lVy38Q9Y9avv3m16wWRI5i8nu9gmKnGYP5d28VswMsOui8hNvenZDAvQ7aGOSLkci1K2twA4FLSD8lSG76hmkv6k2Fe3seji/jywVh044Od4Ll8u4QDvrxGLI/cduMiuthSo9vMbxt/RI+/pb0L0j8J4c1USNm8mh4OoXXiA8xtM+zcdWMtY/WD0wPFtKfgdbllW47SU2kW2LcR/3XrMX0MJ+4NamFeNYwRHiSAIm62og0RIjOMm7ikvkDr1Td3eykP5Rz3RShw+iAp+2potOFQpkTN/AOyFp/J3y7XFXtO/9gyVSxdc0qI/GMHL8DP3Zc/hsYwYL7grYX4DCQn7L2BCyZg9tw/9UnAwO2ITBFsuPujV5MJUZesjlgCcnwf6HdbOD5Fwe+2FrGS/IJlqreEsJgfN+DfHlFsWDNNMwbl89v9rbrPem9gNJV9O14CSWh8CQLJzCOXaJC6iyXR+9li5ZI7ahdJcIehUGpq5ZEN
 djXLh5/e
 VbilCEw2IX/Q08h0VD/Oq5lboR77TYvCgkthST5QKXJRWSG2C3TAFD78xI3xNOfiS8OMTEzAiiOj/A3OXOnsVDf+8F+arUEj2jlG72oaszxbElote5ny8DMv1bY7NSgEzPx25hvx0W4ft3gZ9mmB3AUwATX/n3+rO/ktLaXonAnHVQrisp/N0R9Sis5JCBT/3j8k+YIqdV9hWd49UH7GnTcdM+Fk4yFWEytctB3HyDtgInZj3k0d4C4UWUPcNo6mjnEkArjjN5NBjuQGuHPGO0bHGxW3Qaj/9em5lF7oPBtf8zBM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 22 Jul 2026, Mark Rutland wrote:

> I expect that should come with a reasonable benefit, but I don't have
> benchmark figures yet as I haven't finished converting the xchg and
> cmpxchg implementations.
>
> > It sounds like it just moved the cost from one place to the other
> > place and it also seems hacky TBH.


Yang Shi's patch has *no* critical section. There is no additional code
for the RMV instruction. The RMV instruction is executed on the correct
per cpu area. One of the reasons for the performance win is the
eliminattion of these critical sections. Your approach still has some form
of prologue and posthandling like the current preempt approach and
therefore will not be able to have the same performance gains.

The code is more efficient, there is no restart necessary and the
technique is already widely used on x86 for a long time.

Having the ability in general to map mmemory differently depending on the
cpu opens up a number of other optimization like

1. Per Node areas. Calculations of addresses for per node data and RMV
operations on per node data becomes as trivial as the per cpu data
handling. This will further reduce and eliminate critical sections
currently necessary to handle per node data modifications for NUMA
configurations which are increasingly becoming important for large core
configurations on ARM64.

2. Kernel text replication. Kernel text can be replicated per node or
per whatever memory is closer to the executing code. This avoids transfers
via the on chip memory busses and increases performance. We have seen
20-50% on that one.

3. Readonly data replication. A similar approach is possible for kernel
read only data.

3. Read-mostly replication. This is a bit more complex and the writes
become more expensive since updates have to be made to all copies but
a read-mostly variable is rarely written and the replication will reduce
the latencies to reach these variables.


4. Custom sets of cores that operate on shared data that is replicated
per node or some custom set of cores. This is for example
useful for network devices that have the ability to do I/O via a split
PCI bus or other construct where I/O lanes are duplicated to sets of
cores.


What we are proposing here is a basic new feature that simplifies code and
allows addititonal performance and functional features that are so far not
possible on ARM64.

