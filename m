Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCA8BC44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 13:49:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9242B6B0088; Wed, 22 Jul 2026 09:48:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D6186B009B; Wed, 22 Jul 2026 09:48:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EB006B009D; Wed, 22 Jul 2026 09:48:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 52C946B0088
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:48:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BE03FA019A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:48:58 +0000 (UTC)
X-FDA: 85016543556.14.6173361
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0A27640006
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:48:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jhr2ABz9;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784728137;
	b=5X2NTPqU1p5Sl8sE5R6goVj4VpUJdTBjEKWyT8LATY5UCL2rNE5WN4HisMjgNNkG9W7BHi
	bP7TZKf1VU/WTAb12FdDSVEqgO+f3AFLLbS5qfR5Xk7bFC6vMKJLOwWEan/dwX4puVy9dB
	VMhZHGw3F8Msqit9zwwjIGC2rGFYW+Q=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jhr2ABz9;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784728137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LI4otu0+1hHJyrtu/tBxz3iTtloCysub9k9iNgYv1gk=;
	b=8KLVCKG3m566o6UMwT32xi7u2Bbu0zDszjzFh32fSYtp5KXpYPSdOq5cqfokdN7Y2DVoaR
	S9ZB6OwIXDjhFAUh8U0jW4B9xMHpVr1YVjYbO/jTGgkd0hqWwTvY+XHLPVKBLSYitBoxOy
	voQJC5Fz3DvNSvbMj8TDwOAGG6Rv2+w=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-51c4436d02cso50814261cf.1
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 06:48:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784728136; x=1785332936; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=LI4otu0+1hHJyrtu/tBxz3iTtloCysub9k9iNgYv1gk=;
        b=jhr2ABz90MB+8SEPYYJdHn8DbakJNia6ZGsT6HhSHRY29IZukv5GnV+G7Cn8RQBc1u
         n8oua9aIeGvXNO8IiAoBE6ewkhjXn/As2D5n6Esn5n2pMd45W5k6ZO3TpQlRkWOngtAc
         kzJml4wrM/OEOJ/wt1V1+Gqfb3QgVK3goAggWT8Ui0J0+9gZPaqyCH/+W6+dNqK7zDnw
         dmajC1yu7P/HoBQsAS+MSKwA5/jfpgZI+NDqAT6DrXxagmXOWr4BgfkR2hmPjPNPPDQe
         NkE/ZH+Hg3HwNNMZElrQ/lLT6ewpiZCR54iuKyDToEeB00c0+djp4uMsZH0zli48m5KU
         4PUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784728136; x=1785332936;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LI4otu0+1hHJyrtu/tBxz3iTtloCysub9k9iNgYv1gk=;
        b=iHGXoOqUDrT0wmM90GbCVfQEITdTWRUoCu9HsgwKpRFehQGjRN/E3QCeQ4rxYm7tsK
         wT61UCfps2vdJs2Ziq84cLFxRoZ52dMkVE1wggFSNnQdcSFDJHI45bYfHDF4tXwdx+m/
         sADtkZVfZ8kQMQ7a5erkyvI7PpBSfqC1pMfbLNc27vzCApA/DCqt5qcoNnm/tuWOzqmW
         1Y6M+XnQpRNsZ38dFrq4ePS/KcWm9F1mT5j/B6iNF/QHQyJWDa9F5FatZA73Za9tMS/5
         eBftMAZjAPmo9PyYNKuOl3MfZz5WDSSkKha65OsEvw9AqpeeQ8xQNQqmD1Q2B8tv4DIN
         r7mg==
X-Gm-Message-State: AOJu0YyjzTf+mvDNyFtwL7sHmSoYcoVKJFuLvncWwiLsDCKsIrPuw8Lr
	S6nbFHOD3BFBdq5w69G9cTLxh32p9GMelmzq7EmF2xINxWebxsPBFQMj1RxRTXRIkPtyw9yhr9T
	2GAKC
X-Gm-Gg: AR+sD12XJxxeBC7s+5F58TK7sYjuyF5pIULFOvv7e7tZkEzlF4ZkLQW5bcalPXDdwXa
	YkVNJCFxyNsCHIIEj92n4sI6VRFags2/SKFm3RxYtVsrAeTz0sEjO0zR6W6x0S9iyqFY4VFot/T
	HkwToVd+oEnsWNiawFNGW0vXCz3H2kI5ynRPxJ+omXoG0J62Z38eVurf+e4HSgoOadyAtUxfjWJ
	NOnoeBiOLgc4HdwMyzcE+NJPE22gU93yhQhrinVhKNUestSixhRQZkCGj4O7823edpoSivmEuET
	W8tbFnbbeWXYgRpC0h56sA2riH4aOBjRrqv1MkAOum4oXwRn9vdaXFQZHXlUJEdAGjV9BihsZ8u
	QGCBJwdfASSsiSdu1tC+OKkZks0p4vjeFnn09P7yq9kYpduAwABGIP2DAgPPre9xZ4ycH9+PWZB
	PVbBwxGkosS1+2QbvHeKQBuqwwPvnph0GbMMaSzyMIO4Tepki1UN+ja5FADg==
X-Received: by 2002:a05:622a:350:b0:51c:555:7dea with SMTP id d75a77b69052e-5213cbd667cmr215415981cf.30.1784728136109;
        Wed, 22 Jul 2026 06:48:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba8e2581sm21393266d6.19.2026.07.22.06.48.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 06:48:55 -0700 (PDT)
Date: Wed, 22 Jul 2026 09:48:50 -0400
From: Gregory Price <gourry@gourry.net>
To: Richard Cheng <icheng@nvidia.com>
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
Subject: Re: [PATCH v5 26/36] mm: add NODE_PRIVATE_CAP_RECLAIM for opted-in
 private node reclaim
Message-ID: <amDJEbu3aQO8J8f4@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <20260720193431.3841992-27-gourry@gourry.net>
 <amDGXU94trqlXUgR@MWDK4CY14F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amDGXU94trqlXUgR@MWDK4CY14F>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0A27640006
X-Stat-Signature: y1borromezw4wjb16udrcocyfzuy6n8g
X-Rspam-User: 
X-HE-Tag: 1784728136-564419
X-HE-Meta: U2FsdGVkX1/3IWRnCUZCOkHzHYr+AfG1vrFIrk1znw4kfdN0j8dzv45Vwd4isFOPsSStb4lo4OxCB8r0Bg8bROfvD0gd7gQjLmOl8YHNE7qOuWiwmdg+7uDOft1pceFOpzytFVxDNPiousrIISP9FWfJwW3hSGowgSigioSPU20Dj83mtVh50jT5U8zRHZPcZt3bahMVc8kmlMJXwFcsHgVkqFGEjgsSVTE+OCV52kZrsSMxAq8rEySEx0nEQvwSF2CM7WavVm3O5NkX/N3/GRU/UN9YkJ/tVhLt8nEaHpxtXyIvggXkm3gkiG+oZJHzPzfHFXI5W+TSzVtu/ClTwARgc8hE5acwnT/vvrmzFAagBMSJAVBmmH1+jaoKA9zbo0QBRTfwK0P0gQyR78MucGpExLb96USWMWalJQAnoE8e7RU4pppYiCrIhmUsOi1bi8AFPwrUe5nf2QXKzn7PsB4Glam5dG6p083OUnEOSog1OGpO3XQ0RcX+EidEsE99hJaoM/EoEBwEGt1kTnhgtTFbVhjYgPzKzGWNVg0IFyHUp7qiDLgn73MYA0bKKsBcEMcxlWlAEwWGChP7zLmmDPQcsdsElGXE/wPsPdT45GIzDq0PwD9ZJZJe3LZ7yF7tVbLuVsHsBJ7MmYGSfilLYDD7OpzWUnyBDfYMxNk0+E+l48tg8pSFe3AtmJF3BOBwR1HjnwyqnFYwXKBLuv5VSuAOquvuBO+TsLHed4IWaUR8H/ygn0Tbufk+qUUDmviGpdEjDidLhWe3nbHn8xTBTK9g96p4vZJOJrK8Nafdka4K/sgYz6yjIABgeD4OeGa5s8Ak5aSwagM2qRPrq6+Rxu8F30NNXanNIo2KHQG3rS3R1MTcFCntEteG+Brq0c2gG77IaheQTNbrS2aTwUcBzJFjfe3YfArj3NUOyGWl6DHFJIsKdXk6fabRh91wo+5X5SdQwC7ZcQfBQutATr5
 7IgwOUOY
 fw82+3UfeJ6MfGH0QQnyKS5DdQJ56U4qPiQl/qk+4o8gFfnPQU5zuhN1qaKuvjyeHPnnHVX2mS0U9/jUWA3LT9RTiFTd2doR9TtXPFyWR4LCqxWuXV8+4aqtwxo+JoPpO7YUOB0TFCBaTPj9V7MUuFdUm8+j1kWEywnuf3wU60bArV6WjXZkMrydfUv61FLzehC24pcptYYFy/ACzoT6e9ponuOm/mGoQ8ksBTrwS18Jnk7ge1nvdN7RHIs3H2DZn+FqidLyZRuFgmfc/eOyn86ryrEqMYVgcDh++r79A6PMPVpyfROxnk2FwJq1sTkAuEBqspms0pA7I8GSbRN5btY5Fcxia7Oi6vmucnFOSyXjhG+wn1RlMXhT/LsoPx0XRQPAYYtHf2DJOwapX1J/XankqOWXHRsx+dbQm0tyKswXoH6OspocDHmjplbv6UGJ3ij+2kXl0m2HWt8sD4tSodP5Fq83kM1f9KDcfRpKZXokfpK/E759djYg4Jkgqbs+sIAcy4RPz3XNScV92PaKvXay9+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 09:36:14PM +0800, Richard Cheng wrote:
> On Mon, Jul 20, 2026 at 03:34:20PM +0800, Gregory Price wrote:
> > +static struct zonelist *memcg_reclaim_zonelist(int nid, gfp_t gfp_mask)
> > +{
> > +	unsigned int aflags = ALLOC_DEFAULT;
> > +
> > +	if (unlikely(!nodes_empty(node_states[N_MEMORY_PRIVATE])))
> > +		aflags = ALLOC_ZONELIST_PRIVATE;
> > +
> > +	return select_zonelist(nid, gfp_mask, aflags);
> > +}
> 
> 
> I applied this code change and notice in mem_cgroup_shrink_node(), it calls
> shrink_lruvec() directly and never passes through shrink_node().
> 
> This patch makes private nodes reachable through memcg reclaim zonelist, but
> what prevents the direct per-node memcg path from reclaiming a private node
> that has not set NODE_PRIVATE_CAP_RECLAIM ?
> 

I legitimately missed this.

Sashiko also picked it up on the filter patch:
https://sashiko.dev/#/message/20260721183528.B4B9C1F00A3A%40smtp.kernel.org

If nothing else - implementing this feature has taught me some
sub-components of mm/ have very well centralized logic, and others (like
vmscan.c) have 3 or 4 different paths in with a lot of strange quirks
carved out.

I think some of the vmscan paths can be improved to simplify this
interaction, but i will fix this particular miss in v6 and come back
around to see whether we can clean up these different paths as a general
improvement.

~Gregory

