Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C327C44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 16:14:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A2106B0093; Wed, 15 Jul 2026 12:14:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 051EB6B0095; Wed, 15 Jul 2026 12:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E85956B0096; Wed, 15 Jul 2026 12:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BFCE66B0093
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 12:14:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 447D640232
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:14:56 +0000 (UTC)
X-FDA: 84991509792.04.CBC2EAD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 617441C0010
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:14:54 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gpxzo/IO";
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784132094;
	b=wh8eAC9dGh36isVRVV6SubySWReKabjZT4HY8FUiumXiohzWlwFR+hA8T8ICr/FozNbmAo
	rAEahVKccXX7eJqqYFMNMm9dy/0N0ctberBDP+F1VLttjIn/eefinwnDauT84uuvba1vJz
	Eg1Mt2w6+34Mod0IfnCbWq39bteJ2Yw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gpxzo/IO";
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784132094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pVMjnd6ptKwYPB8UkY6qqtALdKO+zAj3uPclax6r34I=;
	b=dBdK0X2WtUPfPLQYiGWXeg94kpIOCPNF+7uCbN5vyu6h97FdEnHE0ktQYXGp1iJNEW2TOG
	uiTfcy8OIrXaD0dx8SqByAb5+msBinV/1TIn3VP6bUI3PIyOJ3geX+ndApIzhs8bbC9F00
	5cWU4jGxeiGVQmgG/O3ExQX5N73+fwU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3CDD541B3A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:14:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216B41F00A3E
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 16:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784132093;
	bh=pVMjnd6ptKwYPB8UkY6qqtALdKO+zAj3uPclax6r34I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gpxzo/IOyN6nBAAjNwp0eeIhsQVbbB+pyG3jrWjPDxNprat4lNwb6YhaOYUN7H4le
	 DH+PlzUORIIWRz7zFOGZVIjyaml/nnyzd+I5OiKahwAo4zeGDrE5GPLv3a9LO2v17e
	 Ros/tdazLIaOFRLC/ItN9lQVRHMuCpkaYJEd4cWo01OTFipblcl87meAd1Nxgm/aIP
	 JglqeMG+IBQnMjmW1kmf3l1K2klehtxH1wXEbHmJFIs9cRTud8wnFstp5r6ifDq9CX
	 FGHoTY9iSbVFBM/C5sYxNx7Zk6eiW36eKH2H0fB+DtCBBuqntMjb/btugH0W5dj9Ww
	 owc/BsjqPglqw==
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c15e2dab83eso368067466b.1
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:14:53 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RprJjOcYBcRPIkdHC+7JHXq2OtIj8s8p9YvApC+IO3Dq6tSsYr3bM6RYXJAnpmcCteG3TDeQdFuVA==@kvack.org
X-Gm-Message-State: AOJu0Ywj8RDUSta2yGPYSF8bykUMkQZ2bcXL2T9mA/45pGHfJbptxp4m
	1mMRhAwXeKM3Flg5A5+9R9gg9UIdQFbJ8OiEuVNnMoCSbxzwGr4PH/wQ8S072/RDMditaeaksHQ
	oX8MNm/vdHSK8B/6+brsnR3CAkMpdV7w=
X-Received: by 2002:a17:907:3e8a:b0:c12:a469:c with SMTP id
 a640c23a62f3a-c161e90a00dmr872937266b.9.1784132092086; Wed, 15 Jul 2026
 09:14:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260714081510.16895-1-jiahao.kernel@gmail.com>
 <20260714081510.16895-3-jiahao.kernel@gmail.com> <CAO9r8zNiT63LUHx8X5i_aboX1UWuGkcFf+p9ch-pekURUuDdXg@mail.gmail.com>
 <2bc8e4f6-46a0-5b74-6eaa-59e7aef9227e@gmail.com>
In-Reply-To: <2bc8e4f6-46a0-5b74-6eaa-59e7aef9227e@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 15 Jul 2026 09:14:39 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOFg_mnNGbFFd_h8FAwRCbQ9vXk47EF5f1CLg1cDVGB5Q@mail.gmail.com>
X-Gm-Features: AUfX_mxckocOMDNAXcaDIksTHkGKMb-YRMUFBn4leFJP1SyAw0X7_5cXmfzU820
Message-ID: <CAO9r8zOFg_mnNGbFFd_h8FAwRCbQ9vXk47EF5f1CLg1cDVGB5Q@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/zswap: Support batch writeback in shrink_memcg()
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 617441C0010
X-Stat-Signature: o5xdgx33hy93c7zg5okupj6foobor1cb
X-HE-Tag: 1784132094-746064
X-HE-Meta: U2FsdGVkX1+w0la/ChevL5A2+Vm3FPREmO4YMD0niAoV7EWIrEK02sEHnv/WQLQro1AAIuOMze309p3wHX+ctRUSkEax7zXMfsxG9n1fw0CCStfWHdg5Y2LmVsRTRFHYLd9WpEVra5HCjZTO2Oc3jeEOuCMmfXbR5kW1ho1/8bKQWKBgwGRqrq2igrVxxU9NQ2MAF5b5gu69F0EQ1XtY5l7nV1NNA6cZpAhJ21DppFFTBc9fbmi9sBvfqlP0hLWTJP4GaTvPkO97Bt+BAP+MVQbixivQM44HVw6nfzN0jN/5SbM5KPRCV3V6Dnwf8QLtRNMA2rurfT6n75RrLf90KyTqWfgyrmdgXIr48GAQNtuEPToKvLNCqLOpiScMQpx57j+o5oYfgFIdOQZDV/xS3sH4y2EbUHh6fj02qTd0T+8TPTjVUkVG62noah6kqLGHhPdcFW8W59ZDHqL3tpu47g117HLH4UFcFvMsMKh4u2GUFreAYbZpcjqrXny9TVItnFKJx2HIT5sWKhNZPLAiL7ftbt0k68P6Z2wl7Jdxd82V3NC7WJAZKkEGQhhC2O2ay8NdT5mgiBctjV6QQ2424psp3b1WMX6Cz2ADOTAs3qDmBYRtGXxqZmQ390Tvv1xAsndj4ZQQIkFhqFJ5TZdHoCXFu+JGu9dMr4cQ48ZGHDr3Syk42ogH/ODx4uENX/FwdxgkKiLS5eAd5OTrv5F5KL7PAwj9F5bxhZOv2L9/IKOO1pPDLGHBT5tvY3vegvbFF3J8N70IZsaNja3HNet3DF4JDfJDWaZeKtyy1sqrNYVbbPR5b7IWzidvllVoPWz/JEIcO5BSe3M18tuAnHpoPU5dg9Tz8f+UzRjuSxdYBdcitb7eZ8DCoNeoWs/S6cMDX2/jsTbwEao1Kntm5U2NCxA8SvUao9AX3xJVnYdcgUMiX3P0l4HS6enXiF7Kb57wZTVZ2PmR4KuPes8JuxC
 N9Gkz0Mi
 cp6aKNSG4SEiGTCXDQdw5qUgYVZEW2JwZ9Ji4kG76qiWEKbqXDiAOFr88Ar/d2XZtJzXeK3Gl/MU9FsyLCDD9r2oP8VTTB8clLZHzTIX6urE7FwzCJgh6uHh43Dc7UyA9ND57CXSj+EuhZkpYHeKyLb11ECL7ODndZbVUbcqvl9qn+EApixN7K8yCwnpApN6YvDh8eityFrZV9gBuT3dMRxYnKpWHlnL9VgNCyCUmpzTJ05g4ur6JzTRKZKAY9h4ZQj14zFHOjr/3rgyoU8wYHMG2g8Ah/w2RcmllbjZPLXWGYWGhc6WkYq3IHiNMmnf0LGwDv+48/4j/8OVqXwSuEkEXH/54gMtkp4iV78iKOLRi3RnWy2aWn1FnmASR54qFIuXCFA+7L24lRqggKrQ0tVkLfw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >> Test Setup:
> >> Total memory: 32 GB.
> >> zswap settings: max_pool_percent=1, accept_threshold_percent=50,
> >> shrinker_enabled=N.
> >> Allocate 512MB of anonymous pages and fill them with random data (to avoid
> >> compression), then use cgroup memory.reclaim to force a large amount of
> >> anonymous pages into zswap. At an interval of 2ms, allocate a 4K anonymous
> >> page where the first 4 bytes are random numbers and the rest are zeros, and
> >> then trigger a reclamation of this 4K anonymous page through cgroup
> >> memory.reclaim. When the pool threshold is reached, shrink_memcg() will
> >> be triggered.
> >>
> >> The test data after running for 120s is as follows:
> >>                             Baseline         Patched
> >> shrink_worker wakeups          5363             85
> >> shrink_memcg calls       11,345,012        188,264
> >> written_back                  40214          40275
> >>
> >> Conclusion:
> >> Under the same workload and run duration, the patched kernel shows a
> >> significant reduction in both shrink_worker wakeups and shrink_memcg calls.
> >
> > Please also include data from the case where zswap store failures are
> > observed and pages go to disk, and compare before and after this
> > patch. I think that part is also really important.
>
> I retested and added some collected information. Perhaps
> `pool_limit_hit` and `pswpout` can explain that batch shrinking of zswap
> can reduce the number of pages that fail to be stored due to the pool
> limit, allowing zswap to skip zswap and go directly to disk.

Oh I meant the other test case with high memory pressure where we saw
a lot more writeback with this patch. Do you have similar data from
that test case?

>
>                                Baseline      Patched
> shrink_worker wakeups         5,363            85
> shrink_memcg calls       11,373,201      180,928
> written_back pages            40,212       40,236
> zswap_store calls            161,190      168,741
>    store succeeded (ret=1)    102,743      127,644
>    store rejected (ret=0)      58,447       41,097
>    store reject rate            ~36%         ~24%
> pool_limit_hit delta          55,826       14,062
> pswpout                       98,659       81,333
> pswpin                            2            1
>
>
> Thanks,
> Hao

