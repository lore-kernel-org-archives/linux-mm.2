Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2FBFC982DA
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 15:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D792E6B0088; Fri, 18 Sep 2026 11:48:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D50026B0095; Fri, 18 Sep 2026 11:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C67756B0096; Fri, 18 Sep 2026 11:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A1E7C6B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 11:48:09 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B36531A06CB
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:48:08 +0000 (UTC)
X-FDA: 85227314256.29.A814DFD
Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	by imf20.hostedemail.com (Postfix) with ESMTP id BC1C11C0009
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 15:48:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ldIn75Ve;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789746486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IPLmlyFNg1TvrjgHDtlZeDYufzZUYgmgWzNOrLusAF0=;
	b=RBTgLc5d7qFZeeC8zkVwwfZbChnUOyZ2NCk1IR0XeOqhSsQeFhGqi6MT+2e9hzaBtBF8z7
	wHKAIOT75GHYJEsh4KY5NdwTJuxITjfm926MjOzQppMllxS559xmwW5WTev3TUjossKorP
	V7bEaBBUSkt8Q6jzD8h7+/touwitNGY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789746486;
	b=evish5G4pLUYqlQq65AhpsBjKxvOOchuKBENppph/GWtcXtguN4eA8yIkF7S+ahmJt/RxQ
	TSZ5d6AGveadVIfBf66ns91vw+5VpUQ7QdPlMK796fd3CxENcxCQCpgsGT8N21sVVo/daC
	oro9iuOufHkGF1RAYi744uBLUAXmZ54=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ldIn75Ve;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.205 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-93910ad2273so113924185a.0
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 08:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789746486; x=1790351286; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IPLmlyFNg1TvrjgHDtlZeDYufzZUYgmgWzNOrLusAF0=;
        b=ldIn75VeiK0Rh0DrtVug4N0EPHcKDqRA/V8zjesByJAiwoH4H35e69kEnZcF+DFXOY
         cQ1LN1P1pYxUB1gNUJGh2wCYGiRT+9LKYrPnPbIYe8Jr+W0s1mWcBT5ti5XsA2JwZKWO
         Ooi/Y3RkzZr+qv383PkCQpne8gQiwSZnU+F5roiSF92FKG0XuyA96axCuaNnHkZ8B62P
         KdRGks7vDcqTp+xSS9LyCHkWSej8Syl76yzRBg8BlJz2PTq/Nshk1C3WfK4XQ6QbdO9p
         f6GXi2v+DeK39gzpEBLCPh52eugiCccP1bGyOSw8Gklj7OFbRgOHItUZwb9my7kPQcpy
         Dpog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789746486; x=1790351286;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IPLmlyFNg1TvrjgHDtlZeDYufzZUYgmgWzNOrLusAF0=;
        b=ilTfZTYjv0elkxjbCLVe4vYi7yoDYQzfnO3WNO1JWQblIgYp6rviieY6b3okVzs9pK
         OiHStjlhiGzixjD8G73UqijX90QO6pi4NeewYB8XkyNUcLGWV3LXWP5MC9Q14P9WaOtm
         a3VL8BAwWSE8fRhFKnKizWZmG6NW3ZZqIMTZDSzwduKB78ZUoO6V/ZjqoMoYtY3jdbAO
         V5HN3Rr55IMYCXxwL00B27+hgXgPDG+o6cIw56RJ++64dbCxzXL0T7QncdNgxTWXWbaX
         DiLYQAD8lgTProNe1OCvSdW2k4jTYA7f5l3njKWBemrnjaOBaKS7CDMIoqW+txwOaLtf
         1xzA==
X-Forwarded-Encrypted: i=1; AKwUvBzcgj9NW24ULBVCZplm064AKuvKdhnFOnCruXXHWlAzMFxD/JLi4BO8Vmg9B9p4BxZlacpOWO/xLA==@kvack.org
X-Gm-Message-State: AFuF++m09nB7FLnZL8UsXx8uOpTsNgDYCe81qrWZFm3Aysm7CKXjjD24
	/2zPtpM348jLmTAKIV5/XmL5vik/N47Ui1gJdf3pdySRv/1AWzhnC1ny209vuR4pY/M=
X-Gm-Gg: AYBFou0vXbZ4nS3DBS9cP3ppdaKdHickt/semW8YzHa00/x/XK+tVDzdL8b4Anb3HZm
	vrFw0I477BhjPnDiUl8N74AFqVhv3Nxkqze0MLXtEzsVJQ1qdAIcL2WkTxoOZGlQS7XBVXW0jiV
	VbCH9M/5WVJnA6/5jpLbC+pzNlKVGV4RbbFK45KhK5BgfXpLpchW23pxvNuUpMkHUvKGU26GFz5
	t50wYFyvdHlg5QFnCc/zpPOxFrormszz8sOt7+IqYo+XOaVBhupv3L8gcd3JN3eVxUpWPd5/q3I
	mwLzXUqnz5E4Pf9UBUN1mHMg8v5wJ6mEjJCz3+Q60inj9BdYT/zAtcJ/uGfBprVnOlqGn7fQy4f
	gtvdqX0ExgHGnTIERuquvrh/LI5SyGjDDCX5E/MMOP1Uk3PLio6gMNsQMmnDGg9HLnnAM7mGs9C
	SfCAV1b+X00xAFElEsLvM2hiMOHSaCbcAaSxheCubAaEgwVZ5wDv5n/crpqOkbbKFP6stofGmMW
	LCUJjLClSsEld4R+LHuPiMNMU930+63d2ycVnMcD87HnwPU+PTvD4A=
X-Received: by 2002:a05:620a:4710:b0:937:50b6:4a5b with SMTP id af79cd13be357-93bdc70b5b9mr439833785a.23.1789746485649;
        Fri, 18 Sep 2026 08:48:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93be0ead31asm170247285a.25.2026.09.18.08.48.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 08:48:05 -0700 (PDT)
Date: Fri, 18 Sep 2026 11:48:03 -0400
From: Gregory Price <gourry@gourry.net>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, akpm@linux-foundation.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, nico.pache@linux.dev, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, 
	usama.arif@linux.dev, kas@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, osalvador@suse.de, 
	hannes@cmpxchg.org, raghavendra.kt@amd.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 3/4] sched/numa: scan read-only file mappings in
 tiering mode
Message-ID: <aq1ZUTgLQfLBxn80@gourry-fedora-PF4VCD3F>
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-4-gourry@gourry.net>
 <0ed3ab3a-80b4-492f-867a-0584441722a9@kernel.org>
 <aq1Cwh9hNw4wWEUP@gourry-fedora-PF4VCD3F>
 <c445a20c-ae83-4571-ae97-031ce7facc45@kernel.org>
 <aq1FDhy00epXXtgd@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aq1FDhy00epXXtgd@gremlin>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: BC1C11C0009
X-Stat-Signature: rd8gx5x9hs3own3nybxh19mkxw3tt8tn
X-Rspam-User: 
X-HE-Tag: 1789746486-177547
X-HE-Meta: U2FsdGVkX19TaIESIbI9tTfncXaweawKwpB7dBpE+KvSVFU9SD70SoXNIuyyfkSjMX4BWJhPbjjJ7HQTvzeokHQYaBzBa65KAtz9NVwgEhx5d6hRXTNx8uoIWFLtmMdahhwgH42f49dE+pFn9y8V6H1Cgv5vJOQAFwAqlrQU+Ph2uRQsNa/7SdjDjBLf/QyvVlpSHPeohwnvLECCreDn5ueoCXRIR+XtdchsJfQlHGrzqahI4hVHohqeW+gm36k6Amq1zBFZ01V++ZQzrEFbuB7/AlBybmencNWY9Sj9dA1SCMWbaMA8dFSXS2Pj1eg96nQAOonTpz4NKiEAewhy8WZhyZEYMT6FDRp3AXtz4AbLPvahSxb6tk2s2j7vnKZM1bxa9UZx0eEMsP9/Xa5eGAXi4VKEew7bPXyH37qjpD636P4ZLJHpAeNz9nayf4bu+XMOP3/Un3iMdmYW9AU1b/4ys5ot66bPh4wS9McAzIf9y5xUHI1G4NnNxUjzw+jNZZG+TiNXnW50Sn3fPAga7JsfAOw+tiLxsiW6TANOywZSsnofs89hDzyTRnHu6IhHE2J0sbSdyMV96eLE/+WIZW9ZAZ5fLIcBNY3GLUTYrQOHJxrDeYcV779+27pUb1O+v1KAfJVpX/Info9DyEzfen0y2HxYpc2XZTlY4Vq9yZ7AhTC3Bj/O6LdCLqMDopoAqRQFBYVR0Qh2vvpDNMosglzCbKEL+UUvt8xSIEO3yqIL4ECaBgsCs3+eU2kN+eR6sMO7ZGTKa0+x0hVoeyVjrdGnkUfzWmY83GdT7IlYW1B6QyGSL+NjrSyFY2UVntmmfHlewuv/P6m1cUGRV84jz8tcNALjq4peAJIvqcC50n4CJv1P3djyW+T/6cSYHJZ56y9IgaUVFiwlLUfnSksFQTNQ9OgpFJ19hQiEBBRxvtJEgJXXOwPcYfhvFpE1c1RNTIocPukioSLVqGrILk7
 gaqUVcpx
 ZWjbottFQNXfqDw5Nk+Xm2QYUjZYL/3/d8rPHOA1J/SoHRYfa6LYETyY/ZO+0v7V+BLC/nBgYmudaOiIuWH143dAmDjdQjMtOjVy8iNsJbM0KO+sabBJGZa/PJQrJYXM3B40FQcre1Yifs/5fPozNGy0FBKvtVLrBFQHyX6vcxU8iydZuwiDuhBMccK6/HrPot4JqzTv9+R5iJOW1wogR1rbL2KVEpuq4mPYGhcntxZxurxJ9gzvlsyzKbNSJd16HLrKzlbMMawVVZXKurr0k4xWeKNcwDME+1e9d2bueybbW5j4mxi32dtC2AHT1xp9MsgIDJ/rKkY55z6acXcV5hzYRDEVKXxPD/j2cxs7Tj3/bLJ/3zMJ0DFfUthkKMfS4HnIaXm4qkaPJWr1fJCz58AtLZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 03:53:26PM +0100, Lorenzo Stoakes (ARM) wrote:
> On Fri, Sep 18, 2026 at 03:59:40PM +0200, David Hildenbrand (Arm) wrote:
> > On 9/18/26 15:57, Gregory Price wrote:
> > > On Fri, Sep 18, 2026 at 02:58:36PM +0200, David Hildenbrand (Arm) wrote:
> > >>> +/*
> > >>> + * Read-only file-backed mappings are expected to be cache replicated between
> > >>> + * accessor nodes, so they are not worth sampling for placement.  They can
> > >>> + * still strand on the slow tier like anything else.
> > >>> + */
> 
> This is the most specific description ever for such a general condition :)
> 
> > >>> +static bool vma_is_ro_file(struct vm_area_struct *vma)
> > >>> +{
> > >>> +	return vma->vm_file && (vma->vm_flags & (VM_READ | VM_WRITE)) == VM_READ;
> 
> Firstly you should use the new VMA flags API :)
> 

Please, I beg of you, let us propose clean backportable fixes to handle
the dumpster fire before we propose setting the entire dump on fire.

I'm not against doing all of this, but this feature is horrendously
broken and every piece of tiering research that used it since ~6.14
has just had its data invalidated.

> But also it seems odd to check VMA_READ_BIT. You can have it cleared but
> mmap()'ing without PROT_READ but has no material impact on mapping since
> write implies read for everything afaik (that can have an impact on GUP
> though).
> 
> Also note that (well my series changes it hopefully landing for next cycle :)
> MAP_PRIVATE-/dev/zero which is anon would satisfy this. But anyway :)
> 
> Anyway in general then I wonder if this shouldn't be vma->vm_file &&
> !vma_test(vma, VMA_WRITE_BIT), but then it makes me wonder about whether
> you care if somebody can mprotect() this writable?
> 
> In which case it'd be vma->vm_file && !vma_test(vma, VMA_MAYWRITE_BIT).
> 

Right, I made no attempt at assessing the correctness the existing vma
checks - I just moved the existing code to a helper.

I greatly dislike this pattern
  1) Fix a bug
  2) While we're here, fix some other subtle hard to explain thing that
     may or may not change something but certainly is unrelated to the
     fix and might actually regress something else unexpectedly.

In a single patch.

> > >>
> > >>
> > >> MAP_PRIVATE can easily map a read-only file with write permissions. So the
> > >> function name is a bit misleading.
> > >>
> > >> This smells like a helper that should go next to other vma helpers and have
> > >> clear semantics.
> > >>
> > >
> > > No argument here.  Would like to balance improvement vs backportable
> > > bugfix though.  I broke out the name to try to make it at least a bit
> > > more readable.
> >
> > I understand, but I am not asking about much.
> 
> It turns out I made it probably too much, or at least too many words :P
> Sorry.
> 

Can you at least propose a patch on top that adds the cleanup you
suggest? Much of the VMA stuff is lost on me because I haven't had
the time to sit down and consume the novel.

~Gregory

