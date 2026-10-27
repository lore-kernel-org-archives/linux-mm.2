Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7D84606A323
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 18:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=B5QpgQGV
Received: by kanga.kvack.org (Postfix)
	id AF9C06B088B; Tue, 27 Oct 2026 14:32:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD16F6B088D; Tue, 27 Oct 2026 14:32:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0E6E6B088E; Tue, 27 Oct 2026 14:32:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B20E6B088B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:32:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 02B8640AD8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:32:01 +0000 (UTC)
X-FDA: 85369250484.22.287DA24
Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1CC751C0010
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:31:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=B5QpgQGV;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793125920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LVq6pbjr7FsFX3prA+jfg0dfmRTCJpqiA9RsFP438sw=;
	b=z23OyEhd9cjkUIsVzsF5l9S59+RnWXtzRQgfwxCfVq5juPXoroxJRbM8/gbXuZfSbxflzX
	xJ8qW/tFbklcqluiLH5yeLGd//e2fJFwo3rYT9mD4IIXon3jg1TX4lBpISeUmLNNM3iNoy
	6vTHhkgHKkWy0JXvLMnaaQxSbMn4gp0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=B5QpgQGV;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.217.41 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793125920;
	b=hE3sKxBikaXkF/EKIt62XcmCG3ph5CfcCXzqq9wZFZ4MHvHAeGt+phYEFwA2C5uP7CF1HX
	Lw3KdukHABaQIlhhD4juCqjMTUzl4toiiLOZgxHedQk67nC5Cf86+S3RTmNNlC1Ib0u578
	QATt13XzrMMFp1ysp+jRIT8MSDUuwek=
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-7cc603a168fso36557137.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793125919; x=1793730719; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=LVq6pbjr7FsFX3prA+jfg0dfmRTCJpqiA9RsFP438sw=;
        b=B5QpgQGVJDax9gmzVlso3EfG5aIuzfNjaEDsXWR8Wi4PzTJDFAxmknNFO82xL92ZB2
         hlGpCcp/JjvcIRnEppuXSpvKLsf0wMucG3nn3Jn1m8Zvq+JAcDdv2NB/PwBAp4FdIW/n
         GBAoe3xnqjIMCXdWHuRWsg1aiK/Nun18KyUDwNdqnrjxvCQTJ4LWm1scfqNxHkhJ1rxu
         odIKhVt/2kJl6jEYWvhcJ8tt+9pUvHAgIge3MMagoBiRdJf0nKf3W+rdQWIAiEQ50Omn
         ZWn0eF91dV3IbBqSB4ITcD3Xyz40tK2WN5kdJqJHn7Gm1zIFf/JDAxLMIEV/yg4+PjYn
         ynBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793125919; x=1793730719;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LVq6pbjr7FsFX3prA+jfg0dfmRTCJpqiA9RsFP438sw=;
        b=yhGMcyivGHY5TAMQfd6YuPcrK+ODnAN6nSA8059kOF6Gci2+fc/5F5UG49EtBM2VE2
         Bh7v6/JGihVJsheGYVSciyzZhjHtflBfuKlqh0OghZqEgzce/p52w/LhkCxhvDcSN/n+
         /9O4FTj44OVchqi1pHNSYtIi9/Ffio0P2ZV7pa4m2+yzAuVMV7hg1NoeCqeADjOA/jnB
         oSwOwH0fBXzaQ8DNUKNsgos8nCHgw+8VoCOlHxpYvgXsNHWLip/yVp8qByXyTUHLg7t5
         s6KH8hF+rw2/Io6uLTZzdGVDY1KqRFLmHPm7eY2+5a4mmMCiQQJxZDCu6NvYy2Pspgj+
         Ms7g==
X-Forwarded-Encrypted: i=1; AKwUvBxJ7IvhL/9nMptRinUmXntOPeLOYgVnQY0Oi75qM25J3xQiKgsIH+LxNe68KFfW4YQXOAEdsJ8qiA==@kvack.org
X-Gm-Message-State: AFq9FYI8sqUzErHnH48QkFxnVZMTlxm+Svk4gJf6ySgKtrnH6qjNTmWt
	ESBR5ejKrT1vA39iIhKs6U0GohPt2s9qI5vciB/el6EA9Ko3ffuSUzEMY8Hx6aC+zuw=
X-Gm-Gg: AYBFou07eocuLJeJZpDWICLDXJrEpA9xEr7WqKglRhQru4HfYcOw6vYivTFvsNhhBET
	JcbMfFTauEDoLBj1YfAImvZYPwQWU+0uLh4EXi90v4oA0khPltNmikTTQgfR450WK48KWNadgxj
	0o6kVBOpwdhuIBJNeBdlf3iSl4SNpi02F50EKunPpVLKGEAEtb/ORMxFiHzNN0LrEQGn0YXRHC7
	icRPYzUrceMaxU6wVO7bxgEI8gM8aJkyllwgzjRrm2hsD1KKZ3doGwKgSIrfUfm8NLak/F7fJxX
	iZvSG+kdV4bF/ezg0j/FTmT5qwgrIKzQmZc6HjgyMowgkGxxFkOyWIChCJgETngTp4Nw3ctg/OP
	YnzqZO/+9TjiJeT/kGYlC/s6bMHnkXBAFMDtJqoVjQl40llb4g+IwnxH81LyOf7XRMkGQVJguR3
	5WCk/aFvT10/MZOt9a+RFD9T/udLfTEyC671FvSSMzMVuSbLpuFqR56clFDRcLVgwzjFSOc3uWh
	nNdaOjR1gEMXAzhumdeSL7UqgNVDQktqGQJQB1GfvGe6KCDn7ga5qPVmw329VZ3Jnf28IEa/BeB
	bhg5JYxukERnDrW2YYkpiUSPBdI=
X-Received: by 2002:a05:6102:1481:b0:7a2:7ccd:280d with SMTP id ada2fe7eead31-7d03a509f02mr71066137.8.1793125919047;
        Tue, 27 Oct 2026 11:31:59 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c47a6bff7sm109225116d6.5.2026.10.27.11.31.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 11:31:58 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/9] mm/page_alloc: don't undo a racing
 start_isolate_page_range()
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
 David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 stable@vger.kernel.org
In-Reply-To: <20261027-pgalloc-ai-hotfixes-v1-1-9c7d1aca801e@kernel.org>
References: <20261027-pgalloc-ai-hotfixes-v1-0-9c7d1aca801e@kernel.org>
 <20261027-pgalloc-ai-hotfixes-v1-1-9c7d1aca801e@kernel.org>
Date: Tue, 27 Oct 2026 14:31:57 -0400
Message-Id: <179312591750.3837667.585125681248029246.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Queue-Id: 1CC751C0010
X-Stat-Signature: r5q4rj4x5wx9yq7exw5k7sa7fxrmafcn
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793125919-560202
X-HE-Meta: U2FsdGVkX1+aDZ3LFuWkV08iLNIZcRsJLQ5jZ7u8/jvqzTTOTddgT35lYrJWfo6b9qgAk4IzKueR2LNOqq5jbRCCx0BeuSe0ITMu5gDxp1IuUCfKu2Mw8Sa2B58m+05O8qcdp1x4xAjd4ERGNSoAO8Hk6oQupExLhbD+ononfpnMiULwmrXx+rzoE1xoaDJQb4v4mZDaHrcBTZtgW1owAtVztPb/LHu4DHj5ThLO4KCTkx1XniLPg+T9oxK9HwXJ2hl3Yh4wZ9rt29E2rZkptTGIgIeX3Wx13URW+jA86DU3H+pEvG2vFEYlQLqeKBrb91GN8GWkGdAmRJ49Ns80I/AA19ReVL4NCRXM4hD554oMLIxek6QnJp8bBVO/YMTM5ZFPg9W7EeXjTURafawvJ5oGYWePZ1GJIU3xuKbqzEnpM70NN/OeDECj51YEYPlQV2QTbsUcXcVKgQtWB8V/elc+RIOCEzQRZTQcTmiFFfLFE8YYyhciSZFAkQvUYWUMm9NeqdPHG1aJnM8Kt9Gz44n8beYEam/s+tTJOqR1GqNXnYSfS7ZU4fCULphlkdYhwZq8LinRhntDubQC2l6mMMysBvyf4cncE6tgBX8jZxnc3lSsaBcxRLDBZZsWAvfVoEgYif0cqGjIH/dkq5A4axxx6qCC7IY6IIMD+WtSdxKba0CFO5JhB6oJqk2KeeJPamd8IdgFxELAj0u9R3s+kw1GAmwSdAfQ9/SN02qSqfvbonCsfvgJvv4YMTDy9vwaqrxSAnpohTtWD/GwcfXaafr3X9EJHQD52CmNXWiBW4yxe2HhSgUO3HznRGE/7PnDe9YIuBZ1yStuHkXTmixsd9syHifLSmU8J5PBevuuiZFWS+J+/co/XxRMO8NtE/CAli8GA2LHiJ/T8Hx1SAxYTNVvejT0aoT3UI7ihdp3rkJH6UeXe/PUcsAun9/G/IGvRV6Zlt6y47M3Kvg1f3y
 OpOHuKZz
 vtbH/xF/WpMlQH+pXeHFGn2aGGBnrtFTN+HnyNyh+F6G7LcoBKErvHh5KzOEzjEEmZoqHcO4drUdoMUx5MpftqWbm49q/sCUB5/tfAP2mEI/lHe+lMaOoA6XTu1yFhBjsfXc1CWjhPePBfZpdnT238hDtt5LsBLhTkNRqKwvAQPYe2Aa5WlIrn7pVjMprbg5didW9jc8ZkAPQ0O/NW6kJ3y2DhP34UPfu07eoZ6pVsvrLeQ6RongFp7hrjoqO1wyju/aWAg2z8ZlKzNJ4Jhlpaz3FHxe9EfQcZvT8JpVHURcGi4ppUdrEv7M9P0plDDEceVk7jBxpf/3wsJmXcgDN5OhHX/ibFJA2dq4KGyJo15lH3M8QHd14UMLqhKAJ8x6qsqXhvYCcHYbICSeFIbvl2oOH2y4aAc6QPXGoXvb3HCWGJsV7JmvS9CRE5I1ujL1DcHA+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 16:46 +0100, Vlastimil Babka (SUSE) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> start_isolate_page_range() fails with -EBUSY if one of the pageblocks is
> already isolated, i.e. if somebody else is working on it. It restores
> the pageblocks which it has isolated itself before it returns, as its
> kernel-doc says:
> 
>   We then clean up by restoring the migration type on pageblocks we may
>   have modified and return -EBUSY to caller. This prevents two threads
>   from simultaneously working on overlapping ranges.
> 
> alloc_contig_frozen_range() nevertheless calls undo_isolate_page_range()
> for the whole range in this case, which clears every isolated pageblock
> it finds. The only ones left at this point belong to the other user of
> the range:
> 
>   CPU0 offline_pages()                CPU1 alloc_contig_frozen_range()
>   start_isolate_page_range(A)
>     pageblock X: isolated
>   migrate ...
>                                       start_isolate_page_range(B)
>                                         X is isolated: -EBUSY
>                                         (own pageblocks restored)
>                                       undo_isolate_page_range(B)
>                                         X: not isolated any more
>   test_pages_isolated(A): -EBUSY
>   (again and again)
> 
> offline_pages() repeats the migration and test_pages_isolated() until the
> latter succeeds, which is now impossible and the task spins until it gets
> a signal, while the free pages of X are handed out by the allocator again.
> 
> If X is released after the last test_pages_isolated(),
> __offline_isolated_pages() takes pages which are accounted as free off
> the free lists as MIGRATE_ISOLATE. Thus NR_FREE_PAGES stays too high, or
> hits BUG_ON(!PageBuddy(page)) if one of them has been allocated.
> 
> For another alloc_contig_frozen_range() or cma_alloc() the result is a
> spurious -EBUSY.
> 
> Return the error, like the function did until it was reworked.
> 
> Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
> Cc: <stable@vger.kernel.org>
> Assisted-by: LLM
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Given i separately found this exact patch and tested it

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>

-- 
~Gregory


