Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3F8DC531CC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 18:45:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62BB16B007B; Thu, 23 Jul 2026 14:45:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DC456B0088; Thu, 23 Jul 2026 14:45:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CAAF6B008A; Thu, 23 Jul 2026 14:45:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 125556B007B
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:45:49 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 82186A01AB
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 18:45:48 +0000 (UTC)
X-FDA: 85020920376.24.61B687F
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id B55F012000A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 18:45:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kGHjfRcG;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784832346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j6ufwgXideJpYnCHTcqdI7XFL4I7bDx4wDEI8wCsug4=;
	b=sDU5tu7Ma0UIpSlxo7t79E2jBLqV2CK/eGmOrVSxuO6OsI1InEYFzKrT20VcOxD67aji8a
	b6c9KVjvhhgaesVmfVBON4nNqYx9k1WrUkPtn9lMC1bh+1Ya1t16ZohsWS9YeWgxUjB9vr
	xRbqJpJG8qId2rPtycuKGR4DMF5fmLQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784832346;
	b=23W3VKoBsriErll/SiigvcxTKr3yC37Fi2S8E42UOC5hB+ySEciVIugdC4gC2ve5Tgi952
	rRFbS3ATHZ0vAuSxicfXww9hKs1PvOMuxre8AUwEFrfp8VxgGKpXeSLdZOlzpEFs9S6o03
	/l+kUwNpvizqnN/hWYIhxrSAYB601wE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=kGHjfRcG;
	spf=pass (imf29.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.180 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-92e5c92c389so80254685a.3
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 11:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784832346; x=1785437146; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=j6ufwgXideJpYnCHTcqdI7XFL4I7bDx4wDEI8wCsug4=;
        b=kGHjfRcG5BCZYRNSIBrbvgksWxkOxF7TTnH3z4G5XUvOHnOif5f+/r5+e/d9GzRO5Z
         MhUF725bAIsIpyg2LXDWtNnmauY25mG9WiKqJnduJEZ57jYV310FLVkTCfH2hbVIhgeM
         3BuY1zNwDovN9pYIbshEP+XWoelZ0LfwuHZI7f3azLKx7LhH96KyKyUN3K9V2oAnlgF4
         YIUmPWhUx5SxtRCnuFqLe2CAsHaNu5ZQlJnBBWqBz+8aDm1eLxBMKCv8gWr8Lyjb5a9S
         12hsGxGpWqW1OHmLqbTRdRlTCVynDslnYMi4E17gW/CaEmUeCnmDBKLVKkbJftK+7qg8
         O4Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784832346; x=1785437146;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=j6ufwgXideJpYnCHTcqdI7XFL4I7bDx4wDEI8wCsug4=;
        b=svfAGU+Q2r5HQ2KrCDna8ns+eFALs84AUQYMEBu3OkVDOif5XXccTYQQrg0RGOczSy
         W/ZqNz8TvoC5I1eWGg/tnfJt/i3eoOk8ndPUi7EJT7orU7QsNhiUl0gFjpgs7iWO5XPc
         nKpalvu8KBpaNgUw8DlU9DK/qRbKP9keYaJf0GMlYt2dBxwylNVTqJFV6M5tbTOV+KeU
         4fNBhh+XiMvFJKfPL7Se9rPlj2KysHPG+bVOi3TqgQae8fa62RyXRTqAkawuZ8B3AJ+V
         Q1TYFVKgbYGEXELiH10XVn9W6mo14BNijBod14EtYBOgkR174Cu4wgEZj/06gG/rrHhP
         H/lA==
X-Forwarded-Encrypted: i=1; AHgh+RrgNDtW80VKv+2plpELG2HT4FS/D5fMpDaYE7+Zh/0tNtEcLqFCFtfAj3YrNFen/ANlecsY2mrZ0w==@kvack.org
X-Gm-Message-State: AOJu0YxJDPHRV/KtmORVOYKYXfsW1rw78+IJE2cH/mLSYfXMBzpR7LBn
	ZcgangBSSwNbwTkBbKECg9CDkfOUmVjSxiSgERY0PAcG8FH6Yl32own8rjmA95qU05o=
X-Gm-Gg: AR+sD11mNQcjvrauHNrespa77vgXFcdYk3/S+xSPeP8HlWEl3Vig4u6W2dMf0pdDrUN
	2Fnw8IHr1FNZzjt7DIqXdfsKNopkU72LTowtq1N1j5D86WPIthnxXEUMapBKdaINhB4Rh5fo/kR
	2TWiHsAAHQcCIbuf16U90DrzpYMZAl9U7L5Sj5oIMKrbYvfi+0xq7T6mZyG6D1Xr6iSXgWnoJW7
	h33sxD3nKSrzK4qlaMjji/nt1bU9bu2y9sEBHJnyrQ5IrVlhpfBewDXkqlOMu9dBI4UHosViBSD
	Qx6cUyO3yvOjcGDg6p1MQmqFqfZAE2IPlrGhLKPUH1zW0RNzg5NPXWXsD8xLApvCZ7ou+rX6Igf
	WuaXUZEJhVgLnNBkhbPhZLzE1mbtAkvwbQ8ruS+zj+YKpzkY9YX92WR6Dqgrkk31Rtce2N5hGrv
	r2BIGbxA/I52Z/riuDsvPUWLcRLb5eDlo3JZWFLHdefAPSCMA1FDDoE1vzow==
X-Received: by 2002:a05:620a:371f:b0:92e:7d53:8e83 with SMTP id af79cd13be357-9310391f7d9mr467983085a.56.1784832345663;
        Thu, 23 Jul 2026 11:45:45 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930f6a6bd88sm470112785a.39.2026.07.23.11.45.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 11:45:45 -0700 (PDT)
Date: Thu, 23 Jul 2026 14:45:40 -0400
From: Gregory Price <gourry@gourry.net>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sean Christopherson <seanjc@google.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, pbonzini@redhat.com, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Neha Gholkar <nehagholkar@gmail.com>, kvm@vger.kernel.org, 
	rick.p.edgecombe@intel.com, vishal.l.verma@intel.com
Subject: Re: [PATCH] mm: mempolicy: fix automatic numa balancing for shmem
Message-ID: <amJgdSXxFk24e94p@gourry-fedora-PF4VCD3F>
References: <20260629163337.1264881-1-hannes@cmpxchg.org>
 <amGpEEqxoLq/Y7ZO@yzhao56-desk.sh.intel.com>
 <amIcXrS7nGX-adpG@google.com>
 <amIrDncrL4K-JRBO@cmpxchg.org>
 <amIxyy4Vg_TTE8Y4@gourry-fedora-PF4VCD3F>
 <amJKOPczNMb96NJv@cmpxchg.org>
 <amJQAs3Bm99ZR_sF@gourry-fedora-PF4VCD3F>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <amJQAs3Bm99ZR_sF@gourry-fedora-PF4VCD3F>
X-Rspamd-Queue-Id: B55F012000A
X-Stat-Signature: bmfy99qphagb7ubqfpnfktppyfcrcw3k
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784832346-745961
X-HE-Meta: U2FsdGVkX18578cIBwNFqin/JHFzuWaKqyM8cw5V3pgldNyCmoMS7N6yLkfD4AP/W+N3X10W6/kJ39nNwazTR8hX7/CGSFBwsoGwnBacISBrBy50wGliGxjEh1NJaC3e+s4uIMCcOEb3aM5ddm9OKe6Fz7JIkwruAQnjMdkkshCY7PYbOKu3B2rfLyttGeWq16MyCsXXfbWwyEleLnUpdNZ3ug16Flh+hErUbGri8ZcUQBcPH/7Y2Jt4MbMdHChFkk+Bab0SOmIOABB0/UTk47I28TUZBIsP6dfdWfFW4eD23tu6oP0y7oggrmEDCLEPXDWuhHPVAO1NKAMEZMR5K/AOyVK0To2y1ry7X1YfzDIYpyuzo0kEZOTY8H3tVX3ZK9oD0KSgoBOlHM/yDZC/BSFyJ3jQQRImYHMJ8v/jFYbds86SAoyMz4rwtKU5CdzFvj8ghrLckO+8KNcY2+HEueSIcB/yi8NtxjOV5/RvM0XxJ8lEgZSVofHD8KOZA3dAzz4oMHpPBsRuA09of69qNyOiCKCMum5gb9JI1beOvKNlLIjbil/fEKSKW3ZZrvLTdz6HFS/cAG9fiKL5g29Umd5AUN7vM+9zd7nuaHJG+TNzvHzysHWwpj9LaGCMZD46A0VknJFEvybJlfm8Pka9iUky58TiZOc6tIySV6cfDW6n7CoD3rv8bEtk1ELYPAkkDhIkt15pgqQVpZWk3Dp6B3K2rfL0Zr+8hvx/UGzP7tAUBIhF1aL857YxmG3UQWsOAYrRzSs78BPvm4WykJG0Z+dN/2ZxmDqs7C8W80cDJAlplUppYltrVJ6N3/Gq1MdnBySq3ktyBeXVQs2sMWDNYht6HNIyMp2fsk17O8yFSj9T22WWeOaUzUr4CR7ahKY/ICVtge8vfVWXGKOIHcTxswda7Z1cjTuADynAIb81dh2PLupcoofqq6vvJ37nqfwbGbdPdRPMe9rxdQ3gRPq
 e8TBmJyF
 ZMwH0nc7xva5jWmrmjTbYvj9+ZiMcAl/cIiIu9Gc954XDDol7rGy/FlVk8Tg0DlIxXVAb3Wcmfgl9m68OA1LRxDFK885rvc8DZzLbKuLLS1w85bspyJVt4Clr4krGFg3uw+QxXdzEAfHRPg1ShsWpm3m3Pe8+NvOjwaHCpI5+mvLLwGBn6EwxXs0o8B9jPoPmaEBGIynaDfnVH//DGLuqVL+NCT4UxYATFfhD2D99hFmqf0CjSPoXCHcQkcfqTkgs1ZOzV2H86xgERNQWhYexoS+k/XQGWIyRWnqI6hxix/p83xvYtlFR4Jhq0Z9X6VrXfFH3EN82razHSU8MzanNhqet09CkL8YObe9a6UdABvHKcDrZ53pKQRQzZ758A5b2+TTrKfebf/I1RsHKFyIBhnuIeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 01:48:27PM -0400, Gregory Price wrote:
> On Thu, Jul 23, 2026 at 01:07:04PM -0400, Johannes Weiner wrote:
> 
> So the default global mempolicy is effectively:
> 
>     (MPOL_PREFERRED | (MPOL_F_MOF | MPOL_F_MORON)
> 
> which is just MPOL_F_NUMA_BALANCING without MPOL_F_NUMA_BALANCING.
> 
> The user can't actually see that - because the MOF/MORON flags get
> stripped out when it's queried (because they're internal only).
> 
> Maybe we should just set MPOL_F_NUMA_BALANCING in the default/preferred
> policies and document that the global preferred policy default-enables
> MPOL_F_NUMA_BALANCING - and that if a user (KVM) doesn't want to be
> affected by numa balancing it needs to set a policy to disable it.
> 

Walking this all back:

  - MPOL_DEFAULT is the default policy
  - numa_balancing=on means enable NUMA_BALANCING on the defaul policy
  - shmem was broken and did not respect this

Johannes' fix is correct, and there are no additional changes required.

Users enabling numa balancing while running KVM with shared regions are
not getting what they're asking for presently - that is a bug.

They should get the performance hit they're asking for (and then either
turn off numa balancing or set an explicit mempolicy for those tasks /
memfd's).

~Gregory

