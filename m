Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FC81D4661C
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:45:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 927016B00FC; Thu, 15 Jan 2026 14:45:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D4156B00FD; Thu, 15 Jan 2026 14:45:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D3CF6B00FE; Thu, 15 Jan 2026 14:45:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6BD376B00FC
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:45:16 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1EA68C1D51
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:45:16 +0000 (UTC)
X-FDA: 84335227032.04.63747A5
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf05.hostedemail.com (Postfix) with ESMTP id 4B3A2100004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:45:14 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VwvJgZs3;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768506314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P7GsFDW3HeDyKihzotR4/NfBM14wwU30+97RfyEF1UY=;
	b=TiHvp4tXSDnHyDY0og2IanYdkYbd+MNGBWdaUGIGhT6zgC/5KT5yuXtBwwQ0EVRxC7VhL9
	tghp4NJwVArFJmFdzH72NsCuAoTl+30ZSMAl3He70PGxzhd/DtrG2SWqjPtq7F7ZNxRMcP
	OdA2HL56TQgL5DDW1mS8buk4HpiXTIM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VwvJgZs3;
	spf=pass (imf05.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768506314; a=rsa-sha256;
	cv=none;
	b=KMKb+qqh2MR1U1AQB0p6U89A+j3MsAftNMF/X7FVSwFrALkhwzypuurRTZztmgd9tbC8i8
	/SkeA8u1I+frJM96QndtNr4LOwBAuBXvESNglixijf73jeoBiU1wnNSrOqcCcYGgKnUcmE
	B1W4GSH5XsFdIoNDdlXWtgT4NDEPf/E=
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-64760131fc1so1023957d50.2
        for <linux-mm@kvack.org>; Thu, 15 Jan 2026 11:45:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768506313; x=1769111113; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P7GsFDW3HeDyKihzotR4/NfBM14wwU30+97RfyEF1UY=;
        b=VwvJgZs3KAfvqUDs/jv4Vm9yrN2AXZXhkBshwe28qnEmBhb8vAllrxjILd24Qfsk+p
         qbelEdUgpF0Pvpop3IszLpo9QdQu8+ruT5AWuM2gizF0nMttAdrsZxj6lsZ44A8EC6Eh
         Pc+jsdCk3chwrrhWtiQy6/yePwNqBwepdUnr9TsvRX6pxQuufcipF+9VeKrlSQmhiZrv
         33bpOwAALIDNCIFwqjLtQiETqZ8k11dr6cy2sVMYX55xJJ9TboOnrvgQPh+TF1PtWp1z
         ryfr8e6HcoYjsfZ9ss4Ufp5C3XxuyDQ/7nqQ3UFHRyHKizhLHI72rfuSnm2kEVtOlfe6
         p+4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768506313; x=1769111113;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P7GsFDW3HeDyKihzotR4/NfBM14wwU30+97RfyEF1UY=;
        b=Pis7xtCLCYSDgofw5Ef5RHQacf1l4iqNElUyX/NRCFz+o2dDOhIdLOHD5JN+GB1wRk
         iz0OSKRyi70+VqS/DxA/KXnb8lfv5r8fHcpLi3v0peM0f4GwmfybDEAAEG6/mSVhPjn7
         TibyBGYS64ohbtdjBe3GxZ7EcsGRjF43bHfyE4UxMgcWi+ERqrciGcfIpAsyDJQQTzqr
         OZRtAHfmjCv9VYfeIveIc28BXnkqGdEfPklxIcsl6nZTVy8AylF7+gjZ9WPWm8/HWFxt
         DcniFiWZm8WQ5vbac/6+pUyJprEwKlN66TVTFMx3z3YBqmnk1fpVcIRxEJX1N5Wx/e2+
         LZZw==
X-Forwarded-Encrypted: i=1; AJvYcCV+4VPtZFFkQxxsienOZvlV44OvOZoyURqJigSrKC+wYz4zH2CZ9JNJunYvuqFpGmIZpR0S/b7rWg==@kvack.org
X-Gm-Message-State: AOJu0YwNjHP2A+rC8eOXToJY//9m9JDs9sltt+YE3kbFOykH548QM/xQ
	u9tvEze2VFKEXL2yQKYbuGEphCJvIxo3A9uqqJ/3iFrfZn7zWKEzDwYE
X-Gm-Gg: AY/fxX6GTzRo9gTOtSWmG5KINRdkHSymaToj2IiGb7mXz1LAyfFcsxlGsegHLybSn8e
	nk7CiZqDGw3AsWirK/HsCNYx5kGG+qoOTrBDSHxYdv4q8Wh2igqd2/kqkkMHz0brUDQeaSnDwdH
	YqnU/HIq7UXLbiVzv/EVibt1/Rwg7MXPXiM6zcBAwiuD6GV6Gnd8rLH1LBwPlhrc1JLOhzYzXDU
	cf+UxA+etxBhoCUBe/fw5vmM0449w3CdKIKNGRWyKOzc+gLr/YQsN/cQBWJ3DnjKXdiQDTdRkL4
	XWkHtXnPbRoW/gj5GGpoYMWYe/GmwS9OtQybdF9PW2amJgZ3ifJBM117PWQCgFT0/Id2NnIKfc8
	VAcU24GWIBF/4tjoZ20PQnG6wLu+cxX9XttLypDQmgqPEEsVGfIyVZtXxbvhudpL9sxqVT8aIu4
	49u75L1uGbyg==
X-Received: by 2002:a05:690c:7288:b0:78f:b163:782 with SMTP id 00721157ae682-793c53eadd1mr14217807b3.58.1768506313106;
        Thu, 15 Jan 2026 11:45:13 -0800 (PST)
Received: from localhost ([2a03:2880:25ff:56::])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-64916ffb951sm205444d50.2.2026.01.15.11.45.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Jan 2026 11:45:12 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Wupeng Ma <mawupeng1@huawei.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com,
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] mm/hugetlb: Restore failed global reservations to subpool
Date: Thu, 15 Jan 2026 14:45:10 -0500
Message-ID: <20260115194511.836766-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260115111946.4b50c5dbe6c6bd01638e4b16@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4B3A2100004
X-Stat-Signature: tzarzq8spqun4jw7edzuwszfqp855xqm
X-HE-Tag: 1768506314-196170
X-HE-Meta: U2FsdGVkX185eJTgC08TAg+rZQxTeMaU5c7g1bllYNueDbK7ef6Fz+7v0ZUAovrUB1niBalnYy5kLhut4Kauy4JViw0mKV7ZGEycqIB1iYnTgi6qwdh5SAWmpnjmVNlexKHBUEVy72EoxiZ0RI6Jk+mpL5IIwf74GqAgwRYBEEMd8loFNsTzHOnzr5o2tLdQRkZS4G6dFIe+JfcHgtq55NhDAfASIfVrQjLLYXa5zBRjLTBBgnD1iMDi2YnrL5ynPSy01+APia8JKJ0GspxAk2Sfn4hat4lDdV6TPiTAcUtrTsm5Cbho/+hvucvFtxIwuQvpskUONC4hUOL4aAfc6SXdtOWbQZRLMHl9Dl22uJ/DK0whxavmZInj8hGonIO6pSH/dkzw/H83OhPEddzkmdmBIS0snPKxtk7xeOEjwERltpG77NlBgO818eCvD6jVg0XB1U2iaUqnee1NZcsUm39SeyQlD1iyW5c1jO93GGzJChZPnlj6yrCCKW9zKLp9OyvrZcTz+5NamdH5DH102fr/Op8aoMa+DNQhdzRVHDi9YRHYWv/OMToUli+SlbJJrt3UyvDktpaT21fv4xNYOXI28KSkE4yMrd51jRw7ykEtgHrk000e8Prc5dHVCmIWhg34IRnmPw2wGI+NfAX5+VcaViQul2g0B78krfSdTUWqF5KLbo2FswVvHlsz4k4MRXIcKpXcWLJQP8ZDLwLA3bntdG8p436KUIcq7Lu13ZGH7rJd+tM5rS2rFC46ai8EKdxmR5vwgT5+CGwXUyxzYxTxCRS/Gl+TNKCie5JhbpJ+Tt2AvaiBuu7jQwxb5+sytUJzeC6jw0/y20f/IO2qMTo5TezTXoY97aL9GSKLcxaE81btvM/3AXMRxl34DRhcbWCp5BSWo+GpCUlp8dUdCtpCX9/4KbDUpVEmksV7p8VocpUBC2+AVT5zDcCfzI7i+VO9612qqMdH0hoDH3t
 4FjTw5kf
 OKNhjgq1UE5K1LVG4CIq6dUBRHQEgtTOm/IAFQo+Jkj4ghvNytHDYOWr90AZudW15eLSxyT86dIqg2mOr08cJ+q/axQ1DMch430Y1qU7QZqF0x1GRGS1igjPj4LgH95TVMQXUZP9Cj/G3GbqSPQzJyYKHzN34voRSQ+G82y13YMKFt1olZMQwV1O7vzuBsh+sazofnVHqbyQcVMRbm7UHZGAIObEw6Za+o36KPh95BHuMTYmtGvdNfjzKXNhOgWa57pLrSAb1Y5FOsgRtvj5B+AZleEWda37J8S3wMrnU6GtW2tcRLE457p8IrdBICgkf1pwiPplOnU1Xs/YtekwFMlHFgbDMXYKzcTejDAgIWzNHe0VAg9tx/wZehCBVcjWUYcAOkuIGFy/F3/NobcgPFUiaJCg1GH5fXZBwvn3maWkyQu0HXNrrm4+cZlHgROrOSMUd1irTkRUSgYlANqBGI+QPX9qeWk2tRckasxkwgIVWUVNPvSweRC7rQI2AdxUxh33aEyi8vo/MOJvg3Bn9N2sUbw9ifd2RHZDtLZVzpoNIc/wlbZjQs8GRlDG+1oyEB0Ee0h53LVetIws=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 15 Jan 2026 11:19:46 -0800 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 15 Jan 2026 13:14:35 -0500 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

Hello Andrew, I hope you are doing well. Thank you for your help as always!

> > Commit a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
> > fixed an underflow error for hstate->resv_huge_pages caused by
> > incorrectly attributing globally requested pages to the subpool's
> > reservation.
> > 
> > Unfortunately, this fix also introduced the opposite problem, which would
> > leave spool->used_hpages elevated if the globally requested pages could
> > not be acquired. This is because while a subpool's reserve pages only
> > accounts for what is requested and allocated from the subpool, its
> > "used" counter keeps track of what is consumed in total, both from the
> > subpool and globally. Thus, we need to adjust spool->used_hpages in the
> > other direction, and make sure that globally requested pages are
> > uncharged from the subpool's used counter.
> > 
> > Each failed allocation attempt increments the used_hpages counter by
> > how many pages were requested from the global pool. Ultimately, this
> > renders the subpool unusable, as used_hpages approaches the max limit.
> > 
> > The issue can be reproduced as follows:
> > 1. Allocate 4 hugetlb pages
> > 2. Create a hugetlb mount with max=4, min=2
> > 3. Consume 2 pages globally
> > 4. Request 3 pages from the subpool (2 from subpool + 1 from global)
> > 	4.1 hugepage_subpool_get_pages(spool, 3) succeeds.
> > 		used_hpages += 3
> > 	4.2 hugetlb_acct_memory(h, 1) fails: no global pages left
> > 		used_hpages -= 2
> > 5. Subpool now has used_hpages = 1, despite not being able to
> >    successfully allocate any hugepages. It believes it can now only
> >    allocate 3 more hugepages, not 4.
> > 
> > Repeating this process will ultimately render the subpool unable to
> > allocate any hugepages, since it believes that it is using the maximum
> > number of hugepages that the subpool has been allotted.
> > 
> > The underflow issue that commit a833a693a490 fixes still remains fixed
> > as well.
> 
> Thanks, I submitted the above to the Changelog Of The Year judging
> committee.

: -) Thank you for the kind words!

> > Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
> > Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> > Cc: stable@vger.kernel.org
> 
> I'll add this to mm.git's mm-hotfixes queue, for testing and review
> input.

Sounds good to me! I'll wait a bit in case others have different concerns,
but I'll send out a new version which addresses your comments below (and
any future comments) in a day or two.

> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -6560,6 +6560,7 @@ long hugetlb_reserve_pages(struct inode *inode,
> >  	struct resv_map *resv_map;
> >  	struct hugetlb_cgroup *h_cg = NULL;
> >  	long gbl_reserve, regions_needed = 0;
> > +	unsigned long flags;
> 
> This could have been local to the {block} which uses it, which would be
> nicer, no?

Definiely, I'll address this in v2!

> >  	int err;
> >  
> >  	/* This should never happen */
> > @@ -6704,6 +6705,13 @@ long hugetlb_reserve_pages(struct inode *inode,
> >  		 */
> >  		hugetlb_acct_memory(h, -gbl_resv);
> >  	}
> > +	/* Restore used_hpages for pages that failed global reservation */
> > +	if (gbl_reserve && spool) {
> > +		spin_lock_irqsave(&spool->lock, flags);
> > +		if (spool->max_hpages != -1)
> > +			spool->used_hpages -= gbl_reserve;
> > +		unlock_or_release_subpool(spool, flags);
> > +	}
> 
> I'll add [2/3] and [3/3] to the mm-new queue while discarding your
> perfectly good [0/N] :(
> 
> Please, let's try not to mix backportable patches with the
> non-backportable ones?

Oh no! Sorry, this is my first time Cc-ing stable so I wasn't aware of the
implications. In v2, I'll send the two out as separate patches, so that it's
easier to backport. I was just eager to send out 2/3 and 3/3 because I've
been waiting for a functional hugetlb patch to smoosh these cleanups into.

I'll be more mindful in the future.

Thank you again, I hope you have a great day!!
Joshua

