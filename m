Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B878EC43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 00:03:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18B506B0088; Fri, 26 Jun 2026 20:03:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 163216B008A; Fri, 26 Jun 2026 20:03:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A14E6B0092; Fri, 26 Jun 2026 20:03:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D4A1F6B0088
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 20:03:40 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43B78C28F1
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 00:03:40 +0000 (UTC)
X-FDA: 84923743800.21.6A0B7C0
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5444D40004
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 00:03:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tqlKQhv5;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782518618;
	b=WRmnUYoxBfOwfueBi9ptHvMmvHpeUFtvsU+Eor5HMDjSZz9t6mpsPkKpLkoE1r0SauW3uC
	GGpybfeyrFxQqax9dGENeoLC5OTd01V6Hk6hY3OlRqTl5RS08peRI+rQTVidjXAORXIVzX
	k1NGCvmjXBtYiVE575Rf7cwlPH+eRW4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782518618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYf898hunEgSW0ZHYKR8e7s9pAnnfGRsXXJ/Ps5DykU=;
	b=Fidq8Dot7vZPly1DzLMiGEtEw6nUSuMNWACILBvqUuLEixtaHoSi2+XK0SijagLAXVS4sK
	q+hVPkwCDH5BLkP/UJA2ncU2sfp2GRZFFeMpS1LPFvL9NMA46O7TJ3THE80QhJG2CKxgWV
	IhWXHLOUpaoU4jrmNd/mIdz+EDTkWNg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=tqlKQhv5;
	spf=pass (imf04.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782518614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lYf898hunEgSW0ZHYKR8e7s9pAnnfGRsXXJ/Ps5DykU=;
	b=tqlKQhv5JQkI6bokcL3pmaPWOOWl2ckxjfKRqvwOECpLWTkl4P3IgJ0Ch953pXdFMYE4rs
	HPAtt49lrbt1Cg0Y+fpGHB8jZPJOoWVnkMwsN26RpI78rCxPP+Tnf1XEYs4/59S3deHqF0
	K7+/RjlRVoONF7/uOrgivtTgPHZbnQE=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: linux-mm@kvack.org,  Johannes Weiner <hannes@cmpxchg.org>,  Michal Hocko
 <mhocko@kernel.org>,  Shakeel Butt <shakeel.butt@linux.dev>,  Muchun Song
 <muchun.song@linux.dev>,  Andrew Morton <akpm@linux-foundation.org>,
  cgroups@vger.kernel.org,  linux-kernel@kvger.kernel.org,
  kernel-team@meta.com
Subject: Re: [PATCH] mm/memcontrol: remove unused for_each_mem_cgroup macro
 and cleanup
In-Reply-To: <20260624183700.1152742-1-joshua.hahnjy@gmail.com> (Joshua Hahn's
	message of "Wed, 24 Jun 2026 11:36:59 -0700")
References: <20260624183700.1152742-1-joshua.hahnjy@gmail.com>
Date: Fri, 26 Jun 2026 17:03:29 -0700
Message-ID: <87jyrkdf3i.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: c5qiysag1wehcdzdztg8efcakh3ofyht
X-Rspam-User: 
X-Rspamd-Queue-Id: 5444D40004
X-Rspamd-Server: rspam02
X-HE-Tag: 1782518618-732937
X-HE-Meta: U2FsdGVkX18fmEUkaeHu6DMRlRE/WFnDLXgGFiiB2e7WsDV4MMiJGCYzZr/UL5ppKUEsvQjVJ8xHmG1cSL3VwI1glti6GvhcjXZENrSTzlbyP6437AcvDmi//lKQXDjPk9coA5ZH5krLPdnEaqwKuL5X1QvH1Yxxj9TTTmgS2f475DIFvWoLg+tOViGOd0vd4Yv5e7nJ1IyF3RvCMQ4qFXsosBFYUdfvFFcUvXGGL7N4Imnl5muZjkCDCjCfrJnvjor/n7nuRFguc5ub9IulOXzI8N3VYR6WfxfDkc17Ku8mH56wbuH691mPzWySHKYUqMDTnHg+/lh9YWGeB3TZ9zWUMsc1ifkpWdFG4sUbGzwbo10XZIVJ3we8p+eQJcGwcHMCZlGI/16CLKxc7bN0iGDfbnUlH6nY+7Ac7516wt0le/lp3EfV2xOGG9fb1S3eqUomzN1so2rJt13LDqrG8beIBPPBIoJTNNPRL83z0gXMo635l6FV+iDXlzBHsimnizmA3p9Cw5iNcwSi7e3Koh1KsxVRczySHA+nxiuwUPsr1WrEUn5ldUJrWo1XuO9387yvycAd9pDk5kvdni5uUF7rSzo/5q/SfkBw0VnDtCzQb0PcLJMKNG5HIV+hA8CmowrP3O6qqauXbGga5f3a1ZaUGDvoCfy4owJg6rXys2hlDJVu+K1mFU42rtZIKPIZlVub5GEOkydtXYwwIKyRyQDVXmh0T1v87IXWYmnoANIrGjJ35lydLHGnmb7xc3c2yj4q9js6Mbb9klDC8Yhh41Wz156+hvsWovlx2xVs40d+K3FxlIq2N4INVemPzxq1WThWsO2OSz2rZ6MOYCvhWZVnqsP0yUhEsHvEPnWB1WmsRXUsYZJIE+WiFBeAzwysyms7QDcI05V05GdVLeI1WN48QlSHuAOcBbRWp+Y/8/Tzt5GrwD3OXKo7dx5jE7IAAJBoAPA7bwYEbwrrrPP
 aebH4h8b
 Bx7Y8R+M5fwFcB7riz0ozWE8UBRBRFFbGepko8WRYJSWUiUhykbo+rLAxf4+xw0vor9dRjaYZ2QE9OfbRTef7RD2WbJ1sylt6B6awAGVuS+YYs4v5dsY5oREQT4U6SgYA0obzwLRnkWoD6bdVWEpketvYLRnVQMIhgCr5G0/fJCST4iacw0fsw2wTX7TkXoGekkR+8T3YamFO8LQTtSKNeCVROwqj1KOSL44QBb1Ii+3JOx7GGmp39J5n3ajC6W+i+0b35FWkduNt+2OOT0o/r3SzEYRTnKyQIIZXLJxYFEuP0fwzSZqml37+rVuHhVWLzQasY0D+gINlF8k7DCiQRDx9SYc6H4lxeaI3WFHNcbk1A2Ti3WvNdydhyjFtVvIbxnZkNO2bzLbZPS3451iQLeuJ5w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

> Commit 7e1c0d6f58207 ("memcg: switch lruvec stats to rstat") removed the
> last caller of for_each_mem_cgroup back in 2021, and there have not been
> any new callers since. Remove the macro.
>
> A comment in mem_cgroup_css_online has also been out of date since 2021,
> when 2bfd36374edd9 ("mm: vmscan: consolidate shrinker_maps handling
> code") open-coded the for_each_mem_cgroup iterator. Update the comment.
>
> Finally, 99430ab8b804c ("mm: introduce BPF kfuncs to access memcg
> statistics and events") added a second declaration for memcg_events to
> include/linux/memcontrol.h, duplicating the one in mm/memcontrol-v1.h.
> Let's clean that up too.
>
> No functional changes intended.
>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

