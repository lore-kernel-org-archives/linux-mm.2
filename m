Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62F38CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 15:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAE738E0015; Tue,  2 Sep 2025 11:57:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B61BE8E0002; Tue,  2 Sep 2025 11:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A25D68E0015; Tue,  2 Sep 2025 11:57:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CAD28E0002
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 11:57:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4134D1A0220
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:57:56 +0000 (UTC)
X-FDA: 83844766152.04.808C66B
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6B61A40010
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 15:57:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MvltdwwC;
	spf=pass (imf17.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756828674; a=rsa-sha256;
	cv=none;
	b=5wNKSeYrSULg88EW2ImlpjF9Xf6k5ZQ5tvpNWpM+Hd5AMHtmo4KxQW7HO2D3xVHDUPKkr6
	jVMiYzwNykttGVPPgN6RbWYeKNGJvPq/YVCm2o+b+YecJovvk2nXIKPCbljbJ1HoabHxpc
	dHbtshIHC/B+ryqtUa9CdStIaNW2FLU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MvltdwwC;
	spf=pass (imf17.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756828674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qpTWgweWXwv5CYoYaJX9o8zOdS7aXfoq/fg/YbFm8l0=;
	b=c7nTZG2iA/Hl6mua42IkuN3aa6Y1t/uJC+rbYhB5lfJVoJznpejlYsYok2Qdr3T9Lu1BKU
	mWbaIf2bQxlySyt3sbMOrhXwSdJx6x1lqmg/EvEbXlXRRznNdrdaXyMWyI3JAofMiax4oH
	TLERF1EyD6U4/Hykvg3Ir46zjFe5szE=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-45b88bff3ebso17310855e9.3
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 08:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756828673; x=1757433473; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qpTWgweWXwv5CYoYaJX9o8zOdS7aXfoq/fg/YbFm8l0=;
        b=MvltdwwCvPWkHSMjdLT34lL4H4Gtb7KZs1b5Ck6I0aaTcBSV9UQiF+y40QpK60Y4Za
         mFL0an6dkRROVQdtdP81+oQGGG7AX7+cyt75qE9y1Lr1z0hVVbxIb6ykGu3gC3zn4UEg
         9cyvvDJ3jsioX72Ph7GnmmXSm3Sd0p5AdevUE129Uv6yZr8Y7U6yflHywfNbPCVUjel7
         LSeKnUZ221IlNc1S6F3JRAMVeVtRWypUFRzdQ9ZPUul4AewoS4qUx+vyUDV/D6xYCyOC
         Y1ZDDm2n5naN0RUF+RtlnhvVurgnxNT1DfcMe3bK32IVwfTBefOlI71rLcUbJuXWxTFp
         1bzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756828673; x=1757433473;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qpTWgweWXwv5CYoYaJX9o8zOdS7aXfoq/fg/YbFm8l0=;
        b=jTaEvaPSnfnkiQEBSr1K+LvQfCszVoNCfRNwLg2XrfQc6bbXQBG+LdbEtrVts8qGt+
         cjh2lCHkxuZEwoTXhP3XSEQQpG5Bpt9l8jPihVrJEnZiRxi3AT3a4UJxcl8Yn54iCz9p
         eWblIkEj70fTGJzGdDOdVCt/wjXgJFMErYG+tQtp4wCC1ZhjFtZprPVIYKQmDEKg3fRw
         jN9qxlhFDAXDu5/n0FylxIaR+GNWmw9o15q2WeeQoq8pqYlX9DMMDDPyOId62RVln7fk
         k4tNYcpp1NoZmVv2KdzcSKwXnr3ssGLxx1c7k4YsqirfCAVp61JOFX/FmDysxQCQRhOD
         jb7g==
X-Gm-Message-State: AOJu0YxKZnfzdE9Bae4VE+0lZSsKbsNAWp5ARnxA/swoTOCLtRTYvZ2I
	dZ/KK/Tw1GWQosANAEASR9YiNsL3aQBiW95LYIsfFEnVRrdYnlsaUjPHCUyveMp9
X-Gm-Gg: ASbGncvORgFLgfDZ1WZDBJ+xDkNaxJ7RD6KHqAdPMtboNX+zsvQSSI2m6atlT4Vgk/y
	+c7/opuOP8lWlVTV5ahHxt7H7l8M/G6mW3yw2Sbd0uJc8MCUcoG1vN5dayvGJgbW4xR1pm76+EU
	YLbQw9+FnnGGYaRD7B7GdpjR+zF3eebmLY1wSBk93scFs3iqm5lYfusCmov8JqorhcvWqSPAT2q
	5qrSMjQiUM7J6Gx0SFe4QYyuAtOOfhnQE/lrVkdaXKl3QsOdIW4zCSfEnjdkX6Dz9uK8/TdfJXe
	uRTmuz482iS2O/IKv1Lgbstn87WeUY1kVfm/4+Hve39dEBKA98A86g0X7n2V9ubHS2sugG2xicc
	1pntA41EEfrXxdQ==
X-Google-Smtp-Source: AGHT+IEfZqY6+K9hdaYp/KwtiA903hmxnO0Hf1TH8HCjk64cyXTMeAACSnf/1A0NKMe8smJT7hSwSw==
X-Received: by 2002:a05:600c:4694:b0:453:66f:b96e with SMTP id 5b1f17b1804b1-45c8e6d4cd9mr2987095e9.11.1756828672646;
        Tue, 02 Sep 2025 08:57:52 -0700 (PDT)
Received: from localhost ([2a03:2880:31ff:7::])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b74950639sm253623785e9.17.2025.09.02.08.57.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 08:57:52 -0700 (PDT)
From: Yueyang Pan <pyyjason@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>
Cc: linux-mm@kvack.org,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] mm/show_mem: Bug fix for print mem alloc info
Date: Tue,  2 Sep 2025 08:57:49 -0700
Message-ID: <cover.1756827906.git.pyyjason@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6B61A40010
X-Stat-Signature: nputcym9oap6as8p4xdqdswyabyx9bfo
X-Rspam-User: 
X-HE-Tag: 1756828674-800280
X-HE-Meta: U2FsdGVkX1+h3+DAydfa5IYCgZASH/gEX2Yxnwvt7IzRhnShFbM+3CkzVqYko8S+0J05uEqUDDcrYLQpR6dm5bKFTFLG054qHzcVjTt1aggVmU7r7/cN1XVcnWz88ZGjidRieC20cjCRNQZm4xWFqlpsHIHYB4zEuCB7TyErQ8r157mI+ekClePzW+0O/J0OBk+Ljr8VBiVdRc2WiskyI79MaFJ0jAyBIcLqZsPgtI67OgZ+qMUzCam5hqBaP3fPa2GkJEI1bq5gFxj7WdvvGmUJ55i9U9WFqRlcJflks6KEHdjI0mtLwLhqes6cK2AVl5uzi3Flre0le/GIAkH2KGacFiaC2YUIiP7Qj7ngSJQEdQhA/neNvyLO0EZOBCH4qYWb8VXrClsrjYJRUyShQkTc6t9dKsB2kAbNXTMilWlZPYM+z5qO38X3EzQvJxwIMZaXkLnlg9BVJcz5UTwt71qQC9c+qx2NcYIhfSxN/ff7Bbbbi8bUfkIT434z7eCV3cEs1SxMhYJFKOdEE4z5KwXnAhdAfUa3k8M5wLQCJghq+5fuSdGSN++NpYAZoaVfbh5hgFGmcDxHhmJ70eylBTIlOm6Z8QZCvHK4ae7YrhJ8TVvhXR6NEAxU4M2PAf3evh0RRrNWuW20sVh+iyX46O8nai96PHkfUZWmoUU/ZQxqd8ZbOZEKgTJZzqwkJcuBK383UCk/XfTz7PAfLOt8Yik4SyGZw+6nSASiJVOrpwBWl1MO5GW1eJ5Fo1m8clpg83LODBZbElrTxOk9WOTjBs4sDVKchKX53e1NCvQH+hfvYGDEJ4f7Wdar/b5OjW1HxLlc9uOwaq7RAEwV7q6FJgoSfFC2Zn0rBRXmAddTufOOuDC+4PRpB3fat/IV7lrMJ4cIFifrnNjn1/MAvESpnPAymin/yUvFtQJooiftm40OLD468qx9JwEEXMuwOyL1x5eMQEhw7D+G4tmd/ap
 MXnugVm0
 vZMjYtyRDjYqL+h3gWdQmrwlnELhsJXyhiptsr/Av1F0J4Aj/1nAjJ5UF1KW60NlZjBnEE4t/CGazMO15Bl6dx4SiAYWrGEGWmxgqNLnawEamf+hRs+gBdC2I0UxrI2q0ff6xc3UQPc9hFSMiEtIhO0zaOhLJz2FHPNKtQO7VYZ2+rCfGIlhZSOYdtc21gARtd5q7LdS/LftJghWMfmTnjOvrGYbJmE5fFNEqOdAu+oGi53oYYrnpDVt5UxAGRJvF6/s2FP2WcPQYa8i2xQcHaMQbYlNH8fb6UAMLCeNcY1mXcDdYBNt8XlfCTrM7LO8LvIrBcsHzzQshibi0uRKuj//HW944mphpehuY/9/xFfeo5ZxtumXwGCaC+V6YDJ+OfxDmPSI8omG5qA0aChpIHstA7F0BcAzYb2wqeSV56WiNpYk8XGVRiBLNUdaBjkAe/2diffycGK1ef3BOAKsJQMOjxAAUfIvp0EiyaRpsmPZBiJvCG7NBUFRb881TrWn/sSZ2g5ht8ncn3wW2dwsbBOIHcYHAMNhlps/IZdY8/T3mi/xkQD1IEmgmoNUrYYf0d9u275hAJdbKOZGsXq+137OH/sG5eW/iSqg/Vl0ShZxMRPYBd715YLgjDYFrDhcUE0vDfRDMEoZBWJ8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch set fixes two issues we saw in production rollout. 

The first issue is that we saw all zero output of memory allocation 
profiling information from show_mem() if CONFIG_MEM_ALLOC_PROFILING 
is set and sysctl.vm.mem_profiling=0. This cause ambiguity as we 
don't know what 0B actually means in the output. It can mean either 
memory allocation profiling is temporary disabled or the allocation 
at that position is actually 0. Such ambiguity will make further 
parsing harder as we cannot differentiate between two case.

The second issue is that multiple entities can call show_mem() 
which messed up the allocation info in dmesg. We saw outputs like this:  
```
    327 MiB    83635 mm/compaction.c:1880 func:compaction_alloc
   48.4 GiB 12684937 mm/memory.c:1061 func:folio_prealloc
   7.48 GiB    10899 mm/huge_memory.c:1159 func:vma_alloc_anon_folio_pmd
    298 MiB    95216 kernel/fork.c:318 func:alloc_thread_stack_node
    250 MiB    63901 mm/zsmalloc.c:987 func:alloc_zspage
    1.42 GiB   372527 mm/memory.c:1063 func:folio_prealloc
    1.17 GiB    95693 mm/slub.c:2424 func:alloc_slab_page
     651 MiB   166732 mm/readahead.c:270 func:page_cache_ra_unbounded
     419 MiB   107261 net/core/page_pool.c:572 func:__page_pool_alloc_pages_slow
     404 MiB   103425 arch/x86/mm/pgtable.c:25 func:pte_alloc_one
```
The above example is because one kthread invokes show_mem() 
from __alloc_pages_slowpath while kernel itself calls 
oom_kill_process()

Revision History
=================
Changes from v1 [1]
- Dump status of memory allocation profiling instead of disabling 
the output following Vishal's advise.
- Move lock from file scope to within __show_mem() and replace mutex 
with spinlock following Andrew, Vlastimil and Shakeel's advice.

[1] https://lore.kernel.org/linux-mm/cover.1756318426.git.pyyjason@gmail.com/

Yueyang Pan (2):
  mm/show_mem: Dump the status of the mem alloc profiling  before
    printing
  mm/show_mem: Add trylock while printing alloc info

 mm/show_mem.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

-- 
2.47.3


