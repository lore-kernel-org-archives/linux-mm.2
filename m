Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D59B7606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=hC7suLs4
Received: by kanga.kvack.org (Postfix)
	id 079036B05B1; Mon, 23 Nov 2026 10:36:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0505F6B05B2; Mon, 23 Nov 2026 10:36:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECF276B05B3; Mon, 23 Nov 2026 10:36:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBF7F6B05B1
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:36:35 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 75C751A08FA
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:36:35 +0000 (UTC)
X-FDA: 85466785950.09.3875C44
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 723D4A0002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:36:33 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hC7suLs4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795448193;
	b=FykI89rtWT/IpEJ6haenWKxoDDOt8AaMbldYHnGO/ouzuajxStY10khcwuJMFd6eG7uwnS
	51+HDFAidvB1VZwdbwf14BCPqndY+75FCxm/plBy7QiM+9ygDdU5WEieCg/zWzlBEcr9r6
	F1h4zOfa8mHBNL1vsolteaqc5x+kYIk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795448193;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1XFcPod1FFohR6V4AAF/gEfpUeCtMF7v05o2OAE5Wyo=;
	b=ybOgB8BPzL6zX9IwwR/miAJ9LVkkR2W4nzey5znu+a9F2Ji40ha4EWMwu5LVyQMf8xaiHI
	Guc1cFOzertxNehRYL9b+gxjcC66ZDNW7Otzi4vceUZBp9lTMSaS9XSx4L2pNw5u9se7OT
	TrUGwJO0jwURZfMEZbn2+OBMrMjX3g4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hC7suLs4;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf15.hostedemail.com: domain of mpatocka@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpatocka@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1795448192;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1XFcPod1FFohR6V4AAF/gEfpUeCtMF7v05o2OAE5Wyo=;
	b=hC7suLs4ROdY+xXNIAly2zmmTULmfjDkxSSWU9bFgnvhfZTmfl+o20dOz4Q/jXMWAd7Wpr
	jNifNyYYYNfOqeUVlrTZ2xmdC9zgOa72Hz/TQI3hK8D2qJI5PDDZYfUFxJ77mClTP/R76Y
	P57WsxKHsHf/IoFRKOVVJx4RwBf61NQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-659-t5uJ-he9OR607hSFGokdKg-1; Mon,
 23 Nov 2026 15:36:29 +0000
X-MC-Unique: t5uJ-he9OR607hSFGokdKg-1
X-Mimecast-MFC-AGG-ID: t5uJ-he9OR607hSFGokdKg_1795448187
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C9E21801319;
	Mon, 23 Nov 2026 15:36:26 +0000 (UTC)
Received: from mpatocka-thinkpadx1carbongen12.rmtcz.csb (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ECEA53001DA7;
	Mon, 23 Nov 2026 15:36:22 +0000 (UTC)
Date: Mon, 23 Nov 2026 16:36:20 +0100 (CET)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Yongpeng Yang <yangyongpeng.storage@gmail.com>, 
    Andrew Morton <akpm@linux-foundation.org>, 
    Dave Chinner <david@fromorbit.com>
cc: agk@redhat.com, snitzer@kernel.org, bmarzins@redhat.com, 
    zkabelac@redhat.com, okozina@redhat.com, dm-devel@lists.linux.dev, 
    linux-mm@kvack.org
Subject: Re: [PATCH 2/4] dm-bufio: allow exposing a client in sysfs under a
 caller-chosen kobject
In-Reply-To: <20261119162819.1627180-1-yangyongpeng.storage@gmail.com>
Message-ID: <5e21caf9-5aaf-8007-0e71-598d7828697e@redhat.com>
References: <2033a6a7-b8c4-99cc-f351-e83579a238ec@redhat.com> <20261119162819.1627180-1-yangyongpeng.storage@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: R2O4uzBdwZp4BPcsR69jB0fxrhbcak9EV80lTB7KRns_1795448187
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 723D4A0002
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Stat-Signature: 37pheb6bg19f6tqm5mguaoj7aqsgp39k
X-HE-Tag: 1795448193-206766
X-HE-Meta: U2FsdGVkX1+mgmmEf/bZh7B63bpsfXxXyXMOCp3LRM63Zy46r853m2lag42BrZYadTSgPzPQNHqnf9gniKeedrTlk4t8d5TiOofq0p05chTASa81eIKyBKmr1gzuPI5siwvOryEkA5WnCvvjt+G/NhDLhspLwBjk8SXC7eJT1sRDbdxhrL5XDLjf1Q1OzLZzZhaIzQJ/KJGQSghqri5Z75WEAdiGoRL9X0igsoe4TwvvXooHk1B7WxipJLtjLNMKO5GE0dQQZc/7sfKTOlf4VHPp1XtkxE++uIqFuJZheoXz9q8VamaE/GvRPJl5YIyy6ZWEpYLejdEf37p6Va+5nZv1u0KpBeDwoeIp9tys61L8K/IfNT0EWEjZBt7D9KfgDju13hGQ4DdoBSM5ajhDl4zP8Mz/r2hj3a6w4DhAS1MSJ+r78oTtVEL9TaCgO/v0WpQJ8bESZ5AK8Q/BGcpFnPTpW5AJNBFi8paI/IBYkymJ4d+w6frpAaJjOEc4/k1rYEBJcFCeskHkg1qh7/gFHm79WQIRg4uGAoulxfXWNtfov8TCS0HxwF4I9qjl1/JFVRerHzuRBapj3cEEwHfDTW1SLrrDdydUssl5whzq8eUZSa9T6pGODPWEt0+TEfVfmh0sCqGwmLm6T1iyB4JMosvD0M8Y9jlPj1yuXHS7RGQQt89VAKv0jZXyuSsACeEJ1bA+zz/bdp0eEc75g4jolAhNsLovB7qEZaMC10RGiih7a253FiTPwgSgXomO4fuYAXhKw6MxbupNfDtRgSIUD+QtsQ/udBdv/Hzelo08rcWpyhi6wvofRunfOkyqNDd6w5q9Y0WK6PHVaFrm4rcAcZg2wHly0VTZtsC/PUexgDBNraw1JnZaWlDNnOPQ4crNfaNovGJAE7qDX3BMuxLSZDW17hA5tcTObKrM1CQWQwRSV/NkU0x3nBmKSfr7tzV3CMl1x3NUAQ7GCbAmNaR
 UhsznQ5r
 Ym9HzouBUEdS5OhI3OHV7p7WnDX1xZsBpVG4dU1M+1f5PxN1Hr8Xq/jIUuRV7WJ06r89rrTvrY53q46eyoYl06Qb44AnTZHFhD7RY9983vZpspv36EJi5usGxUDAfJN5E6hYWcb7Zt8K41jDgRIo8czbnTM21ftRnA+84LryXOEo0sc98PmTmn3X0d8ijFWF24LxsWg5Gxf53Vj6adv+GvKUW/lBFR/F7jdS7MqEKfjSEgeEDGdshwDP/yRhawmEq1NkE2lUw8CJYrjb7X24tjXpc2CpD7RK4DK+z3dS4oPsZge2lyJTIqXaw7A3MCPxoZOxautu7q8oscoYHhWtZIRgmU5pTtFZKAdiGlM5MADL0VPLLll5WD1vH7lm5iBfpk48C/Tkr5hiTl90w983H3Pec2L9TQzcGTxlBH1YfjoxgQp8j/MbaaO0gH8zkAHAKXWQKmVq3JvSl+C4m0elxoIDuRGc4W6ISy2dPa33sv1LLxt2q1RckwRhSzRHR8hQjJxnW6QinIeDhAD3mdL6Xq2CMI+cu/3zsJbbwohj2bfaf08zKk3uFpn5SYXOh/httHyhcWz/3UWeyhIsZ55vHXfJUsenTG/OWypRuZ3jqmciiruLM0frnwfH5Gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On Fri, 20 Nov 2026, Yongpeng Yang wrote:

> On Thu, Nov 19, 2026, Mikulas Patocka wrote:
> > Is the kernel dropping dm-bufio buffers too aggressively? Or is it not
> > dropping them so that they consume too much memory?
> 
> Both, and the tension is why one global value cannot work. Our hash
> areas run from 0.x MB to 40+ MB: the 256 KiB default makes large devices
> re-read evicted hash blocks, while a uniformly large value makes every
> cold, idle device hold memory forever -- and most verity devices are
> cold most of the time, which is what small-memory systems complain about.

What about improving the shrinker memory management?

The problem with shrinkers is that the generic memory management code 
doesn't know how old are objects in the registered shrinkers. So, it may 
ask the shrinkers that have only recently used objects to free memory.

Maybe we could add an upcall that returns the last used time of the oldest 
object in a given shrinker, select the shrinker with the oldest object and 
shrink from it? Would this be feasible?

> > Could it be fixed through other means that are more general? (for
> > example, having a global dm-bufio shrinker and dropping buffers from
> > the client that has the longest unused buffer)
> 
> A global LRU shrinker would tell hot from cold given time, but:
> 
> - Our userspace already knows which device will be used and when, so
>   it does not need the heuristic, it can drop exactly that device's
>   hash blocks, precisely and immediately.

Please, show some numbers - how much does this patchset improve Android 
boot time (if you are prefetching blocks that will be needed at boot) or 
application load time?

Would prefetching with the readahead() syscall be better? (it would 
prefetch data down to the page cache, so I presume it would be more 
efficient)

Back in the era of mechanical disks, there used to be a daemon that 
prefetched blocks to improve boot time. With SSDs, the idea was abandoned 
because it didn't provide any advantage. Are you implementing something 
like this?

> - On low-memory devices we need the memory back quickly, not when
>   pressure finally ages the buffers out.

I don't see how shrinking bufio should be different from shrinking page 
cache, inodes, dentries or other kernel objects.

Maybe you need to tune /proc/sys/vm/min_free_kbytes if the kernel is not 
shrinking memory fast enough.

> - Verity, thin and cache clients share one pool with very different
>   access patterns; a single LRU lets them fight for it, while
>   per-client floors keep the shares apart.
> 
> Thanks for the review,
> Yongpeng

Mikulas


