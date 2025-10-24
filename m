Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC9E4CCD1BF
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 23:32:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 328178E011D; Fri, 24 Oct 2025 19:32:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D80A8E0112; Fri, 24 Oct 2025 19:32:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2153B8E011D; Fri, 24 Oct 2025 19:32:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 117408E0112
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 19:32:35 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8E0CC13C577
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:32:34 +0000 (UTC)
X-FDA: 84034609428.14.DF5B4DB
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	by imf30.hostedemail.com (Postfix) with ESMTP id BCED180009
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:32:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=G4ueG0v1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3jgz8aAgKCOUQHJRTHUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3jgz8aAgKCOUQHJRTHUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761348752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o4r08lbVsQE0OD3LGzE40m+9+CVVkVezP7P3sn2U2T8=;
	b=KzTFnqO83hMMpT6rp/mg8Y3+UKD+xtTjVM87la0ews+seT0xOW8gIVHqivI6jz8KbC1Qg4
	fJwSRlQ74h8wBKxdvLcVyd+RVWe9uTWEejhG7Nu5MSUZcRpgz+B/6d3QWot3QQeNGTq5EQ
	sgvBWaFg1dDyPntbgVbewW9cZY4xEXI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761348752; a=rsa-sha256;
	cv=none;
	b=qQtM9Vy3Wek4nvy4IHqIY5dqQfuhTssOUDMHkRpTI/5Grj3eL7PT3In2Ly7phzowIDd0Jf
	bX7VWkrSawb27Eum0ovAPQXA6LvL2vgdZ11a7ZUy9gwHCCnlutpfEjE8PGNmqjIVzrjqkS
	xhazp85WAcEjiLTzVbmr/dvla8HtqJI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=G4ueG0v1;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3jgz8aAgKCOUQHJRTHUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jackmanb.bounces.google.com designates 209.85.221.73 as permitted sender) smtp.mailfrom=3jgz8aAgKCOUQHJRTHUINVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--jackmanb.bounces.google.com
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-4278c82dce6so1462365f8f.3
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 16:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761348751; x=1761953551; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=o4r08lbVsQE0OD3LGzE40m+9+CVVkVezP7P3sn2U2T8=;
        b=G4ueG0v1JZT15Y2t/lCcIHl7c9+FDWg95xgmzebHibqMUh8f6EkDr0xZzCkvc5+BYs
         7xJlAj4aJme/XIbZYCFvYO6O2Xa3BOZswwkKUDvbZEFsUZ77V/LHJukR+7/OLcYkD6rB
         wkCuZRKq648952xbAORXWHSnhVdAdYMGygbK5I3i7lPN1nhbf3QNjT0iydC08jgNuv6f
         3NQ1kJOH0ovlxnmKsbaUYTRRvIQ0fxyApJW9RzUSI27YaWF0/4Z1UNI/UBFXHvCAIiIm
         NGRH8Faxa93ksW3XKuwMlN4QnTAjoPwzhvyg0wCN9tIbgjC5e+NOyBlqa9syvRLYPhIP
         X5rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761348751; x=1761953551;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o4r08lbVsQE0OD3LGzE40m+9+CVVkVezP7P3sn2U2T8=;
        b=BoPLeKoeY5F0y72g9ERm8hT0nVCeNDQZnHNmAdUGKSBu8Umzw16ZWdtAY3CSQXj05b
         3zLPuoovcSUnmsGCxF/14xAbQDwSUaHuH4s7EmT1zcEigUGNJ5s1rTLE5a+fTQXSayED
         41tBUy1mXkI9jpiqZuOnTo6Zj1PR/OZVuGFBYUGKZzYMmVDRrw1GbXv1qPcQeC/J1Wry
         jyjMuHQAonbu15OUcBA4/sOzr8GNj2bsji604uJu7UAeJVuBM88eptblGI+nLOtHvRxN
         yECGDBQOVoNvVKOsv/qe7zxRvjJk6X+BQXlaxhpFH/ZXW6DxqBYGRxYIWo2tKOOHyCNT
         iOOg==
X-Forwarded-Encrypted: i=1; AJvYcCW1uzJCRtSl+fnz7S1oNwG71u4zHXlJPVi0pWKsz1QkhOilQGFJt4tukXh5Zk1E07zS3cRmj0ZIfg==@kvack.org
X-Gm-Message-State: AOJu0YyIT9S4pl//8hWxAT8MuBIQwVLL+ilbDEtTUIu6or88zi3/VUWI
	22R9iWdCn1rEo/ifm6n10QHfcvLVQ7R6s/A0gLrh7x9uruthQI9WPZmkbhaU3bXWlb2rh8y+kaQ
	ixZHZqtTwg6CO2w==
X-Google-Smtp-Source: AGHT+IGuDi8Lro6+irFVET2GS2b/HrG9TBMx5UeNAi9r+zStVMAINrU4nwULyXj+erM6/d4+A0kxh3I7rKXgfg==
X-Received: from wmwr28.prod.google.com ([2002:a05:600d:839c:b0:475:db8d:717c])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a088:b0:471:d2d:ac42 with SMTP id 5b1f17b1804b1-471178a6733mr190680415e9.14.1761348750964;
 Fri, 24 Oct 2025 16:32:30 -0700 (PDT)
Date: Fri, 24 Oct 2025 23:32:30 +0000
In-Reply-To: <20251024223746.GTaPv_uiyc0wd1fPjV@fat_crate.local>
Mime-Version: 1.0
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <20250924-b4-asi-page-alloc-v1-1-2d861768041f@google.com> <20251024223746.GTaPv_uiyc0wd1fPjV@fat_crate.local>
X-Mailer: aerc 0.21.0
Message-ID: <DDQY0TEKY4MU.2MMSAEB8QQZ4S@google.com>
Subject: Re: [PATCH 01/21] x86/mm/asi: Add CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Brendan Jackman <jackmanb@google.com>
Cc: Andy Lutomirski <luto@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, <peterz@infradead.org>, 
	<dave.hansen@linux.intel.com>, <mingo@redhat.com>, <tglx@linutronix.de>, 
	<akpm@linux-foundation.org>, <david@redhat.com>, <derkling@google.com>, 
	<junaids@google.com>, <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<reijiw@google.com>, <rientjes@google.com>, <rppt@kernel.org>, 
	<vbabka@suse.cz>, <x86@kernel.org>, <yosry.ahmed@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: BCED180009
X-Rspamd-Server: rspam02
X-Stat-Signature: syp9y4edrwmk8aqtr5jsaheesainfcsq
X-HE-Tag: 1761348752-291686
X-HE-Meta: U2FsdGVkX1/WhqU19UQkltlc6M2NMimor2e2hkw9469VjXb/tBPT95WM7uuaIzEsDZIJ1kBBUDAGDW1Eyj5u10gCOSkUtjhUDLe23AjP7axK4EbmDfqsM3OpUvKYiWldX6/wfKPx66O7zTBVuDqqVUpUScuySoAII5BdRWi1xJq52riqUopseL2MOYBVHCCoowclu9pyrCF7yn24NPnHIEXSEEtVNbUnMhw/dQDayxeYOEIwoMIE4WXbd9CAkahogEKflvDI4RhcyB9R3NScOVkhboKvXRsZDavacZIrG6FaO/NJdb53uD9GHEorbXXzc89wcGuGhiA+678EyrDkRKiDgXEpCTumPHb4lct8Ika7nrLnkVjwwjoppJnsq8YvPrklzQWJg0ZPVNiU1gTtOmm5MaF7nWvboMF3AXrM2zIxJcIFQ9bvEc8Q06Qb/GIryCbNcBrZCvrZe40KXJFZODmdI1sUhvbr4WJKKlWbLsa6/eXRCwiEVD0qEGy+Yq/Da1dGO6/bteInZ8qgU5dCNWOQ54NinT1LQkP4rlbKY7GZbeK7Q+NfoQ8GqqPf18tZ1aCzF9F/a3uHz/EvWucoLrWUjsD8R3klLc2gFOYRFpTKmpd7kdRjeaBrMXnScZs8Np8ETQGU/K700V5cEOeXzB7r7Tswq309QGMzzYXw/uCtfhQP5nykNGMfAuZFD/iSvAHely4exkVcmyqabylwvjxWXwZ2XMUvw0kQAhXTjEW3KbZX95a3n0DQe2aKwNnHKpvnhAjgMRdr7PHypJzGKyQvokG106ioIznVbcH6JUa3SGmxbp4WEQdirneavl+YG6mZenS4UVbb6COwL24jL5Yru5fKoihHQa6ogtbvg6hWCKL402QlV5e2X3hPY9PA2FlpI4SUwRmt8V+zDjLo+mCUcsFb3Q86He7kjVjhj8CqkK9pCXEFzNNXUmc/D/dvBk3kOwRpV+0HTMvorbA
 Fv5wT6GU
 cT6xb9O3aQZz3/8Q9CoFqgCh19Dw4+1tfiCtrFv+XR9Nql9s2K/4M4/4k2SbpaGzScr3w+w46HnrjScJ/Ayvi6f5BMHTHPBa4Tq5e1YdZUxzcxaCXvn0z4A3HjN3a602kgV1f/4ABqRWFfycAwVNS9owzVKUMQ5dp0QVbd0J1e0eNT3UDhcnOUiKJ4DU2xb9w9NgR0c86iVd0QG/zPLWJPCVuC/4xixx2TYAWhLlMwWsoTKGmficPIiF/+TavRZJGdAKFUHtPPH8ucvbcjOxPvLTRJySf/hhPZ1GcaJke+tvHuinCFN791XaitjlDMYyGmlSkdy/RBQuqaGI4d9m+ikhIUgUtWQJhdnTIcRwwVnzwWZLfVeyg+2iYtTzxPzZrdDzIa/NASw+EUKvrEvEg9RQdauBlyHaHuTytNFl59qFMtJIGCQTEvdUq8u7tONpxQM976a+d04ArhE4GDBOg2QlcKYPe3/MMKl9kWU9F1qsFp8ymPdFXaDG3PR41eBS+8C5DGF4N1PRva3AYbfB0XJb0Jv6VHmCXCsbNPPUf2c183DNWcsl3PirJ4/ScTMa6MmrMaJZxoiYPhMogcN/HW8kMp7LT8/9B6iL2YlUl0UB1OI/MmoMsH85FZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Oct 24, 2025 at 10:37 PM UTC, Borislav Petkov wrote:
> On Wed, Sep 24, 2025 at 02:59:36PM +0000, Brendan Jackman wrote:
>> This long awkward name is for consistency with
>> CONFIG_MITIGATION_PAGE_TABLE_ISOLATION.
>
> But why?
>
> I bet you someone will get confused and mean
> CONFIG_MITIGATION_PAGE_TABLE_ISOLATION when she means
> CONFIG_MITIGATION_ADDRESS_SPACE_ISOLATION or vice versa due to the
> conglomerate of similar words.
>
> Now compare that to CONFIG_ASI! Wonderfully short and clear.
>
> Especially when the namespace already is "asi_" ...
>
> The only problem with ASI is it doesn't tell you what it is but you can look
> it up with simple grepping...
>
> I'd say.

Sure, CONFIG_ASI sounds great to me, if it sounds good to you :)

And yeah if someone doesn't know what ASI is, they probably don't know
what ADDRESS_SPACE_ISOLATION is either to be honest. The Kconfig file
has a nice place to document it.

