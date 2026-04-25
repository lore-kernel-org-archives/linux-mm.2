Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06430FF885C
	for <linux-mm@archiver.kernel.org>; Sat, 25 Apr 2026 09:14:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F6176B008A; Sat, 25 Apr 2026 05:14:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A5B76B008C; Sat, 25 Apr 2026 05:14:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E2B76B0092; Sat, 25 Apr 2026 05:14:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E0F26B008A
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 05:14:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E7C6B1202D5
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 09:14:43 +0000 (UTC)
X-FDA: 84696518046.18.85D74B5
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0D1DC140004
	for <linux-mm@kvack.org>; Sat, 25 Apr 2026 09:14:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="hs/REWCj";
	spf=pass (imf23.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777108482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CVnXxlcJbnKFtW+7QTgIbQ4r0L3YJZHhXyURqARd+OU=;
	b=Iro/qhjBMIPogzUqwrbBo+E3RQdluedJlflGs/uCFV8k0liGdZCbNycHTOk7eRn7+SbMs+
	pIgW/AnQeHLCAORZ3AwA6InhYzgJ6ZnLzGPvFbTv/X5eqpaaZJpTYQ4WIN+vhTp4YusSBk
	GiyAryOAgMgHHmUp3hlJTrVpzbXrHzo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="hs/REWCj";
	spf=pass (imf23.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777108482; a=rsa-sha256;
	cv=none;
	b=wHeWqibJMzWYQpCa8DbhCfNrm7FtSOT2JkaBBVCFDsE2ea1LD6rhuM7kGJ9yDHogoCqyVA
	MCFu9g0+qmlk2EyP2bvqMLHJ7GZl5fEXn5RDCWJpXZ553Q/yIc1nwBHP4j0e/AE5kHc5B8
	TcLSgBE9YQpmeNUcUzvSSErGixvTs5Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2ECCE1762;
	Sat, 25 Apr 2026 02:14:35 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 441373F62B;
	Sat, 25 Apr 2026 02:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1777108480; bh=ndwM1adU0Ywc49Htd35zTWEkTDTVzUK6JgCrM5wCvp4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=hs/REWCj1nJJbdFLaDzl5x3SlkAUdGEOeK2cS1VirrpLk0LadSf0nMMFYkELitCEb
	 2cF/0fQYvMLiHmbRZwhac5JlGZi8yxE7lcFtAnbolD9wmjiSTUVPWoN8g0hFcOMXjP
	 o5xr1kzh6WR2heWeC6UU0QJrGjqiD3QydgEZKLcM=
Date: Sat, 25 Apr 2026 10:14:34 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Dev Jain <dev.jain@arm.com>
Cc: arnd@arndb.de, kees@kernel.org, mingo@redhat.com, peterz@infradead.org,
	juri.lelli@redhat.com, vincent.guittot@linaro.org,
	akpm@linux-foundation.org, david@kernel.org, urezki@gmail.com,
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com,
	mgorman@suse.de, vschneid@redhat.com, ljs@kernel.org,
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, tglx@kernel.org,
	usama.anjum@arm.com, mathieu.desnoyers@efficios.com,
	linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Ryan Roberts <ryan.roberts@arm.com>
Subject: Re: [PATCH v3 1/3] vmalloc: add __GFP_SKIP_KASAN support
Message-ID: <aeyF-pEruWRMk5bS@arm.com>
References: <20260424130157.3163009-1-dev.jain@arm.com>
 <20260424130157.3163009-2-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424130157.3163009-2-dev.jain@arm.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 0D1DC140004
X-Rspamd-Server: rspam06
X-Stat-Signature: ife1y74oywh5sw14n1c4feq9wnoyxrrn
X-HE-Tag: 1777108481-283319
X-HE-Meta: U2FsdGVkX1+2DIiA7O0YgQY+FgB6U1uReQtmjugwH5ALrz+KkClOVBhMIftLFjZwsNFr5lFUKXlfSpTb4gqxf7PtXRCQrzUdOLlCT0xCWwur9Ow9shg43BdlN9whCuOwZvp2XOz31MvJCtzzJhCoQ7Usi3Hu2IyIV55OS2Ks5enBVy8Mi6bawNha21SSz92fDN+OHxBgYBH2dcZwyVhz4aXeOEBXIL9f6SQxNilJEWGxGrO/FPvQDvrGHQ2q47nSpSTrQlMDMTJoIA4zLWCqrWLZsjJP7JCSXxd+WmfnkaD53vQQgc/iB2aPjthw1x21fVkARouG4ea1IiMbgI3IA3BzdaidM9Kij1xJ7YHoo5r6XUu01i2rqNKH/EyM0evk0Ngt3yGDH/y3HsZTqKHwHS00xFVBxnHdZ/x6bAS/b3jddVMjOGPMNFwAIWR8Z8erC+gYJaxZt3xFjUemHS/Z8KetWcKweL0iUvzPzEih64j8P5cIC0XY9WQ6T5ith881H+HYdIUd/HiKK6kzX5AaHkoEllgDvh0St6tRnywPfgpNOhZXXsinfA9XjSLaNPItt8yCEcCGUGmM2e94l6oy0icPXLiMTTvmEu2OAUoPIq520yzNsLHblzWhBS5GV1fvQ0NEDLN6+VFLR6zR3gJ+AAez00C52MitiI6/UFT4XjwxoRzq4ksBJZallJ+VzTsTmfB6Uaqj+zoGmF6MxjFVUYUfa04LvZSI7Yz4btC961h9INggQ+z4Bk1S/qqFmutN/GTT68/8Nbmk3PJsAYYf2Ar/+UUtwcAjqgnD7j9g/kD3s6pO3tP0EWIAw1CBfE2cKbYBLSibVcAWPwlJlwjVFPyuoaOjbkSYBPyJr0Hc1v1As4IKTEgtPkaX8YeX2bCrut7s5lGi+hBMGMkv0IHgs82Hoy1ua+cIWlSdbasJdV7HGBbjo9pHK1UfflEXOPm4KqUoHVSSVjHkVojSwWw
 ggkJcwJo
 wmUtfiLFBM2tF9Z5hsrAgEPujw9nJv8KiUd9z355FF07HYOkHgZI9nN+kvY05DlrnIyhN6XfvVU8IsedVomTT2pHRvHH611NMqNI+ZEBeOqnR8WkLeoKp3EBjDIqD5Pf5vL+QqZwh26f6oRAq8GN1JE/3dzZKgOJLQpCviNV4eLLWFoYk51+pKvUTNONjoGZgvbtuGnEoDx3X9rDbSmITYowz20dDi/hPGncxV1ybIgl9Ios=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 06:31:55PM +0530, Dev Jain wrote:
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index b31b208f6ecb3..c94fcb2725b6b 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3939,7 +3939,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>  				__GFP_NOFAIL | __GFP_ZERO |\
>  				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
>  				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
> -				GFP_USER | __GFP_NOLOCKDEP)
> +				GFP_USER | __GFP_NOLOCKDEP | __GFP_SKIP_KASAN)
>  
>  static gfp_t vmalloc_fix_flags(gfp_t flags)
>  {
> @@ -3980,6 +3980,9 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
>   *
>   * %__GFP_NOWARN can be used to suppress failure messages.
>   *
> + * %__GFP_SKIP_KASAN can be used to skip unpoisoning of mapped pages
> + * (when prot=%PAGE_KERNEL).

I just realised, if we go with this flag for vmalloc(), there's also a
comment in gfp_types.h implying that pages are unpoisoned by
kasan_unpoison_vmalloc() instead. This is no longer the case with this
patch.

A VM_SKIP_KASAN flag may have been nicer but we already have
THREADINFO_GFP and GFP_VMAP_STACK, so all those call sites would have to
be moved to call the lower-level __vmalloc_node_range().

-- 
Catalin

