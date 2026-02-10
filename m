Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E77EEB26FC
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 18:53:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93D7D6B0088; Tue, 10 Feb 2026 13:53:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EAD26B008C; Tue, 10 Feb 2026 13:53:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CBCD6B0092; Tue, 10 Feb 2026 13:53:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6DF706B0088
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:53:01 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 11F9E59DEF
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:53:01 +0000 (UTC)
X-FDA: 84429444162.17.C85373E
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1BDBF10000A
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:52:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="P5rAbC3/";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770749579;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dYxAK4MfxkNTvDSky4rly7XqGqYb657cJCOkNsVbPkc=;
	b=zaHB5Ikk/705jsAXVkU5pqsK5fXgFGdj/oqC8qia4BL+bwHcaEY+r1uKT957KZVtZeT5NH
	B0G+DSU8X1hWiWqEPu0wrqe4/ZDzAR9r2vm09IJA9Q7rT6w+dJJY3baXJRs5ZZHzx23jLq
	hA+hoAsvpgcH1msaUEE3Ql7AKUMOaCs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770749579; a=rsa-sha256;
	cv=none;
	b=qy9mqI00eKzw2Ofm/3y67WTvWt/ijeuXBBstAMA6GM3Y2cAKtptGEsrSWO7UwDVLugGn1L
	7zbh+GnDqd9y/tCWXPemAtkT/Xnz6JggzzFEn6H55Oo8C1M5+xyB4Bk3XPaNIZ/5K0Q+st
	R109yeLViPNdyv6D/hJUTl8IGoRQqng=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b="P5rAbC3/";
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf05.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.178 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8c5386f1c9fso610015185a.1
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 10:52:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1770749578; x=1771354378; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dYxAK4MfxkNTvDSky4rly7XqGqYb657cJCOkNsVbPkc=;
        b=P5rAbC3/owiXFIDcIDP2HQl3rxnrMtIALAZ2G2/7hsnQ7iYJ9KtNpFgFdnsazRqraZ
         HRikfkyp3hr74u75ndyNGHLCs2Po5L3E4rdHmWlTnd/tDf3+NIrACWxu7PPiJMCRCIr6
         6M3Ptxdga29K/ORDjjlDaFgFyePycp9BOvSp6fQkm2cm/RdnI0s4rO7Xmo/x4of3FBza
         3+SITPnwfWgbYcRlHgmcnuv1TKxmqrOTkrRzWoyNAWvFHiVRpOAQBMFdXMP6mE20iOCM
         L7H7Yk7aSWlxTuBaIjcL0jTtUe0Un1kEqjv+MbSVYD6lZ+jhsCKqKAhRHN7TR0Jjx2/p
         i32Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770749578; x=1771354378;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dYxAK4MfxkNTvDSky4rly7XqGqYb657cJCOkNsVbPkc=;
        b=jef+1bdAjHITwDIVoU72BBFflCcKBMgY4hmheIfM33qs34V6jrfmwN7PUVm7z4a1cp
         z4anPQdDvAaKBrTK85g1gc0bw6J6lUFMotR8EZOzvcrf0LZK6ohMer5+cUObvSUNsSjV
         hNytAITh3JUP0HT2bev5xN3B2qkKlsfKtm1CEu/0YcvlBUAOPWvXi3Fsng83/IoZDGVU
         3Hm4dcMNI+n2N9CbTzgGZjAA3HTiozIqhBKPw4vdI6K9L4t6wCqPqi37VY53vjd3uUiz
         QaAAQR0W4KKCzKaQQY1mkoGxPInoBAdRXu8cQHOy5rdxd2y+INDapPaSPe6DNFg8tHIV
         S/kw==
X-Forwarded-Encrypted: i=1; AJvYcCWF4LY4JnUOYf8gtB/Y79ZutpOZLlU8iIlrdmp8AFQxasP7CRoicbthOzVeaGnEd80sD4N5wRJNng==@kvack.org
X-Gm-Message-State: AOJu0YxvEXSdJX180rCYNRG2g/R8WFqv71AYZjFMI7jUCwXFGrg4aygS
	TqhRwPdd8ATNtaHx/UcoyOdznqm7aXLVtAk/kNDDDqI7R10t3uJAy1Zhkjon9biEqc0=
X-Gm-Gg: AZuq6aKL0pL/mYoscE8pTKt4cax+UuxMLMSyQR2oN0A7NG7IpKi51hweabpvCIQH04U
	2iXUQ/Pu2Puf55UxsrG+XFMEG/ng21R9ma3l6WHZfJKrtv4Vif6mFw5ty287LrK2SRtMS0eeqY0
	F0S1el+vAqELLMtxVuPcy+s7I2sYjU6PKnHmzrmnskPirZWy8q2gOaXwixxa1L/J14cad7G0t5a
	NDVFXoYbH/CpiZHgS2hiGSXQRxpH7QkyrVLC46VYXk0EA8mrweqoel/0MgFv/O547mqzG2TbC+b
	Waflw7SyXJNNdAs85x1wpkiEAbEq3wZfmsxzgdk+MfdtRBYsCHKwGTAoy2RcnXvItrARJMKrMhG
	m8iMDxYyTadfBrq2fqWTZadg5nBe9tgiugzxZ7EHZCGKiBmI4rg+QlQX4Oi4bt/WqX9xcBxeIrM
	aEvw07UiYfl5Z/ovLRAgR/c/1H0x24xbQ=
X-Received: by 2002:a05:620a:690e:b0:8b6:1877:3689 with SMTP id af79cd13be357-8cb27fc2b12mr39809385a.35.1770749577839;
        Tue, 10 Feb 2026 10:52:57 -0800 (PST)
Received: from localhost ([2603:7000:c00:100:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8caf9a16240sm1107793485a.35.2026.02.10.10.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Feb 2026 10:52:57 -0800 (PST)
Date: Tue, 10 Feb 2026 13:52:53 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Kairui Song <ryncsn@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, linux-mm@kvack.org,
	akpm@linux-foundation.org, hughd@google.com, yosry.ahmed@linux.dev,
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, len.brown@intel.com,
	chengming.zhou@linux.dev, chrisl@kernel.org,
	huang.ying.caritas@gmail.com, ryan.roberts@arm.com,
	shikemeng@huaweicloud.com, viro@zeniv.linux.org.uk,
	baohua@kernel.org, bhe@redhat.com, osalvador@suse.de,
	christophe.leroy@csgroup.eu, pavel@kernel.org, kernel-team@meta.com,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	linux-pm@vger.kernel.org, peterx@redhat.com, riel@surriel.com,
	joshua.hahnjy@gmail.com, npache@redhat.com, gourry@gourry.net,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	rafael@kernel.org, jannh@google.com, pfalcato@suse.de,
	zhengqi.arch@bytedance.com
Subject: Re: [PATCH v3 00/20] Virtual Swap Space
Message-ID: <aYt-havagZ8kUmov@cmpxchg.org>
References: <20260208215839.87595-2-nphamcs@gmail.com>
 <20260208222652.328284-1-nphamcs@gmail.com>
 <CAMgjq7AQNGK-a=AOgvn4-V+zGO21QMbMTVbrYSW_R2oDSLoC+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMgjq7AQNGK-a=AOgvn4-V+zGO21QMbMTVbrYSW_R2oDSLoC+A@mail.gmail.com>
X-Rspamd-Queue-Id: 1BDBF10000A
X-Stat-Signature: fpd4tjge64pquc8kfuq1jni8fm6jrcy5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770749578-621534
X-HE-Meta: U2FsdGVkX1+YwmyGbjF00vg6tBlKu3ub7N5xD8DyWer9FBt59vo5zvBwWQQpDCbU16RDw5HXVrXsbChNvmAG+1dvD1u+TvoDjRiNO58z9Ef5pq3QKI0v2VhgJf0EL77ZiktlEx8oHbs9UJ5ThHNg+jX30yhNjVNLgmgfyzAeZyZySrPuwEYtiY+3lE+Gwrpyu9MtfQfD1sk8Jp57axVGMDfQ3b3+D05Gow71XFzSQdPpLYSq3dfkkJXB6rwKhlbA4eFh2zp1I/NwJ/TrcHJH2iqvz48yIKH0F6XJ+15dS52jyLEwq9l/hQEru1dWgoX64PggmQrMw5y0aoWqL+TKr343ft5VZOC12YO+qM36RfU4mY90unsUijgLRjCAEnMSjUeJPrRIGjjREDYdECrwSZVvnA2bmoI/vQSVa5zQWoEIQogkrPNFGJsCdY6ay8G5FDRH/FyS2upVB3d+zV7DClfpIkJP33PCdXNoxwwzYjyg3yPsCMRl7+E3rsT0J5Shek0/vaPpPo55cEUrOZ+h6BhyN/ob2BZ3zPYPSqcXDUkKSRB+2bLCu2DyJCFuhMLIxYYXAMJJ2mSv3I3LWWBxUWokBUxHTBLkcpHpQ2oIzh4tqIx4SwyoyBRT6fHzygIclGgAjrOS9zhRh9HOMPYA42cRlK5wQgeihs0R7Vho8HEco8rcN/IBUBn+NMfxwtxFChuxjedfqFtp+9PI5y4xaJ89yDAUKvJ54B3KyYX6F+Z3eKJ0BTU41y6zbLP4GFW5gH6v1nlGGWJdhj8WYYEXeLLkvRxOrgLK8pwXDwf8hh+gD73Lbspm6yIurtqbX6jQDg1qdaducRu7CUyJ4m44HB8cMz8M5J492qp/mB973FxmWTXXcjAJj+ZYqRVPSmDmTM6QDc/wcUa+zhL8OBboCMvruYz+2ncfiDyD43KA2hvznHTH1y1min+4im0MxlwNVSTIcY4J/iICdp82za9
 Z83HiW8f
 /Hk3T4cf/m4U0zY57ehzC6dNCC3fI5Efl0pl4Zu9JOFcKc+7tVi+4mjihae8dSJPm2+e3YecNgFRZ7aDUgJqmU+ztQCCOZHfMv6rFE3m03B2yiPC/EoW9cGzh1qnEFduCgDfRGKNqlCMlWyo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Kairui,

On Wed, Feb 11, 2026 at 01:59:34AM +0800, Kairui Song wrote:
> On Mon, Feb 9, 2026 at 7:57 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >     * Reducing the size of the swap descriptor from 48 bytes to 24
> >       bytes, i.e another 50% reduction in memory overhead from v2.
> 
> Honestly if you keep reducing that you might just end up
> reimplementing the swap table format :)

Yeah, it turns out we need the same data points to describe and track
a swapped out page ;)

> > * Operationally, static provisioning the swapfile for zswap pose
> >   significant challenges, because the sysadmin has to prescribe how
> >   much swap is needed a priori, for each combination of
> >   (memory size x disk space x workload usage). It is even more
> >   complicated when we take into account the variance of memory
> >   compression, which changes the reclaim dynamics (and as a result,
> >   swap space size requirement). The problem is further exarcebated for
> >   users who rely on swap utilization (and exhaustion) as an OOM signal.
> 
> So I thought about it again, this one seems not to be an issue. In
> most cases, having a 1:1 virtual swap setup is enough, and very soon
> the static overhead will be really trivial. There won't even be any
> fragmentation issue either, since if the physical memory size is
> identical to swap space, then you can always find a matching part. And
> besides, dynamic growth of swap files is actually very doable and
> useful, that will make physical swap files adjustable at runtime, so
> users won't need to waste a swap type id to extend physical swap
> space.

The issue is address space separation. We don't want things inside the
compressed pool to consume disk space; nor do we want entries that
live on disk to take usable space away from the compressed pool.

The regression reports are fair, thanks for highlighting those. And
whether to make this optional is also a fair discussion.

But some of the numbers comparisons really strike me as apples to
oranges comparisons. It seems to miss the core issue this series is
trying to address.

> > * Another motivation is to simplify swapoff, which is both complicated
> >   and expensive in the current design, precisely because we are storing
> >   an encoding of the backend positional information in the page table,
> >   and thus requires a full page table walk to remove these references.
> 
> The swapoff here is not really a clean swapoff, minor faults will
> still be triggered afterwards, and metadata is not released. So this
> new swapoff cannot really guarantee the same performance as the old
> swapoff.

That seems very academic to me. The goal is to relinquish disk space,
and these patches make that a lot faster.

Let's put it the other way round: if today we had a fast swapoff read
sequence with lazy minor faults to resolve page tables, would we
accept patches that implement the expensive try_to_unuse() scans and
make it mandatory? Considering the worst-case runtime it can cause?

I don't think so. We have this scan because the page table references
are pointing to disk slots, and this is the only way to free them.

> And on the other hand we can already just read everything
> into the swap cache then ignore the page table walk with the older
> design too, that's just not a clean swapoff.

How can you relinquish the disk slot as long as the swp_entry_t is in
circulation?

