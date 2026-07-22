Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCEA3C44512
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 04:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6072C6B00CE; Wed, 22 Jul 2026 00:33:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B8246B00CF; Wed, 22 Jul 2026 00:33:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A6A46B00D0; Wed, 22 Jul 2026 00:33:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EEE56B00CE
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:33:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9608340376
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:33:19 +0000 (UTC)
X-FDA: 85015143318.23.EB99463
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 499DA4000B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 04:33:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J8StVHGQ;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784694797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SQIaw6RUIl9sIBDtTmFb37A91uvQrFJH4fhuTcF8/Xg=;
	b=fFEqalJVSNV26hqhBGnL/hqWYxvp7yFGL5E89wGGI4Y1ixLT/Oh8kR3lvsj7DohFRtpjdy
	8QHyHWdOImBw1RMU5p22jfX4XN++PAfxm6Pn/64AuA4zfZAZBpZnsmWl2dMZ9U+2V25Pkk
	mkjkKz7sHBPWoiyBWnuNLIPb4QUmwXk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784694797;
	b=KB4nypDLBz5ddRShg6YwwK2kH8VUivsmRPuSAUUjbONmIr4V1hmm92sFVU75aVAopSLSBV
	mHGQqNrShLkixA8VBEy4AsGRJJ32aNnb0h9OgHRV6xdCjzUZvoEiHPVi+2aTWdD/PDpDi7
	x2Q3MAN5l2xCiTrKESj9uAuZ+kTjYJk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=J8StVHGQ;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E9867152B;
	Tue, 21 Jul 2026 21:33:11 -0700 (PDT)
Received: from [10.164.19.44] (unknown [10.164.19.44])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 00E363F86F;
	Tue, 21 Jul 2026 21:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784694796; bh=qUwOyYyxJlbMFmKAIAJ1m806FYR7SWozC8Yg9pfLJo0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=J8StVHGQbtg0VuqzhPoahZpWhk3VEW2Mz09ov6/YpK0U9xNEaJP1SMI4FmTGve2Bn
	 QM1KpqpA8kfKdVYel3jLY3MRJe/jEQ/78fiS12mJC5DaucwegF2PT1QHl7fPSxpQAf
	 vDWwsyVfBfFS2O1trdUQ6CxFX2XwDPaJhRfGK+z0=
Message-ID: <4bb234f7-5f3a-452d-92dd-a1e62b6f39aa@arm.com>
Date: Wed, 22 Jul 2026 10:03:04 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 0/6] Fix incorrect access of hugetlb pte entries
To: Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, ljs@kernel.org,
 david@kernel.org, liam@infradead.org, catalin.marinas@arm.com,
 kernel-team@android.com, riel@surriel.com, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev, kas@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, apopple@nvidia.com,
 rcampbell@nvidia.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, ak@linux.intel.com,
 nao.horiguchi@gmail.com, mel@csn.ul.ie, j-nomura@ce.jp.nec.com,
 pfalcato@suse.de, tglx@kernel.org, dave.hansen@intel.com,
 jpoimboe@kernel.org, linux-arm-kernel@lists.infradead.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260703114202.365553-1-dev.jain@arm.com>
 <178464737122.1305746.12295190523058911270.b4-ty@kernel.org>
 <20260721133636.df1a012df895054d3fd34a2e@linux-foundation.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260721133636.df1a012df895054d3fd34a2e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: f93nb1mofqtbiybri6ba59mitzhncnke
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 499DA4000B
X-HE-Tag: 1784694797-149093
X-HE-Meta: U2FsdGVkX19zEDCuSm7ol8u6feCI9NdAZ57r0jW9oALVBSMvzw1Pey2Bm0mDGxkWO5gn04FiLYwmJ8pnGKV09/0dXM6dqxhDVLVT/Db7m6ET0FwEOMp+4yjkDddNiozqKQXnHfH0bjZmjVnr8aBdMgdbA9AFFqEHMI6+SldY0VxpL3/K0qae1rsQ2fV/NChTsto9rrgdXUxTeN/IuRlgCWkESlwcJ20vWqtHKIJ6DUMyGNhumGj4Je82DLhE62ZKvVSNuGSAI5PO5Jx5cNQrZ6WTbF08NfDoxjIkY+PsRaQBS08QM4Z8fgnUBSQF27FO9lZjw3OfngHpn5YfXIWEZf6klMX8LDGxu4+F56zI493v8/pW4rMtaJJbwbLPKDy5KXckARKxr2UynWXAqyTd/OSvuBL7SkIxpMfYgc9infoXNYLb/YowucI5+P0ZUqCu1hWHkC+1ps12seg+HE56MjBz9IU6/qugBeXQBRzweAdTTJLXKDmhFiBIlHCN/cLfgLZg+SEzDBiF6Sv9v+1RUN7I3egbwsr3CXIHo+pxa4RwWyWDG2BE0q2wzeQt5fdU+alnk6wPaXDpe48ERTjy0G04uQ8fIHuYAWZPoJfg4T1PXkLPUUYDPLvKqFlaovB8rcWjLrXUyToUgj16PEh2hne02CD4gQsQ0sgpI9CcQBuhoD0aognD0vW6VMneHE0dO3X17h6yCNjxw76ItgHcLVnaRK7dZff2ccvKn6Ppe9PbLwjQIJ4VuxSwstJkYgFGtU1Pm+VEZc9UQdcuqVRYAcFxiwWrklXQio/a9dyLvXEwWrttAj7+pdJ14UrKm/ICkke5Aw4GgNG4FXqPEdrOHgF6m2H0j2Flv+JcN96GvmcKJ8qwuSzTdoHhcq/jAB5vLh6IDO7dduCbetMbLZ44CeUOdsZ6M5YZMbztEPI/lFhzHP66TylMjw9Ef1PpXsQ1pUe7LehXC0k9pUaMPMm
 4HyPT1Vy
 qpW6Qi9zYw11EEWN1McDo8mPtR0gKyaG9RYtRjJ2hmzAACFoysLSQPO6RYZT3WM+v//eF01JZjw5x+zHxCt5YfI2Ii7lLoyUH/rGgduSqkqdfvbP8Nj4M7aV5POIgnvkkz8zM7r1NP6m7AGpeB/RFhwmnwy190xS08MjwIujgLg4eLnojZK+U03Ut0vCJSevzrl9F6LU8poocSzikigHfYVoQetWhgXZbGKIXgtxaWOsmN25tnNubFJiDyNaXowmLwNShYBtqkgLtt2V+r3ZDHgiu7/Iv8mp5dpzuOrlhGtGqRZNDUL43jUeCI+ieEergT0fJQcDA3t2r2sw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/07/26 2:06 am, Andrew Morton wrote:
> On Tue, 21 Jul 2026 18:18:38 +0100 Will Deacon <will@kernel.org> wrote:
> 
>> On Fri, 03 Jul 2026 11:41:53 +0000, Dev Jain wrote:
>>> There are various places which use ptep_get() to get the pte entry
>>> corresponding to a hugetlb folio. Some arches (like s390) have special
>>> handling to compute the pteval, so they provide huge_ptep_get(). Use this
>>> helper consistently.
>>>
>>> Additionally, some code paths may provide huge_ptep_get with an unaligned
>>> address. This is a problem on arm64 (I checked other arches and it looks
>>> fine for them), which is fixed in patch 1. The fix is made to be
>>> to huge_ptep_get() - that is wider churn and we can do that later.
>>>
>>> [...]
>>
>> Applied first patch to arm64 (for-next/fixes), thanks!
>>
>> [1/6] arm64: make huge_ptep_get handled unaligned addresses
>>       https://git.kernel.org/arm64/c/9175a8c7cfe88
>>
>> I'm hoping Andrew can drop this from the mm tree to avoid a duplicate,
>> but I didn't hear back yet and I'd like to land the fix.
> 
> I can redo Dev's series to omit [1/6].  The patches apply that way, but
> there might be build-time or runtime issues running the other patches
> without [1/6] present, haven't looked.
> 
> Also, review indicates that the changelog requires updating
> (https://lore.kernel.org/all/2b9d60a2-8698-46b0-80ae-b8747a66a85b@kernel.org/)
> and I believe that Dev plans to do that.

Oh I was banking on you to do that : )

@Will if you could edit the commit message with the following userspace visible
effect:

"On systems where CONT_PTES != CONT_PMDS (meaning page size is 16K), we could collect
excess a/d bit state, meaning extra work for the kernel. Even worse, we may iterate
beyond the PTE table and dereference a garbage ptep pointer to access physical
memory we don't own. Since the ptep pointer is a linear map address, we may run off
the end of the linear map, dereference a VA not mapped into the kernel pgtables and
cause kernel panic."

> 
> IOW, it would be better to carry this in mm.git with your ack.
> 
> Do you plan to upstream this in 7.2-rcX?  If so then I can hang onto
> this patch until it appears in mainline.  Or something.


