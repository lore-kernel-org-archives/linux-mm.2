Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28AB3C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 19:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8A86B0088; Wed, 29 Jul 2026 15:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E89C86B008A; Wed, 29 Jul 2026 15:36:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9F2C6B008C; Wed, 29 Jul 2026 15:36:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5E7B6B0088
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 15:36:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9DD341405DF
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 19:36:33 +0000 (UTC)
X-FDA: 85042821066.15.71D8383
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 850921A000B
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 19:36:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=GfoDLQG7;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785353791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YFlfsyL868lT/j3agJwNORpNx5tokno15i4G5m1Hupc=;
	b=QLB4RVEkhM+ufjNON8NdVNMcjVCqt/lmZlz4z7ghynk1lIVMk2OJS5+oSuUIiFHLXQYBd3
	TwC/219Uw3R5KFPDzaLrR3o98lZDSkHJzRAq63vE1qP//FmnuYwTLl4vnA4EvJlx4RsJp5
	2qP0HNUquV7lDmFVDFsjJYgr9md74/k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785353791;
	b=Sh3XvojGtkt6wzyRSISXt7TBkImkn+w2URvcqPbo6pWc9rBWkU9PprdvZ999bUFHim8TV4
	vXvRqgf34NaS4kN+5QRZhFewoBrcnbC7PjTKxYFhO0BZ1zbXAhlzVn1CuT7Hl8qY93wOfA
	coW+poXmfHfZGxsLziwI4sLmxQsMe4Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=GfoDLQG7;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.172 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c928bf172so9512741cf.3
        for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785353790; x=1785958590; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YFlfsyL868lT/j3agJwNORpNx5tokno15i4G5m1Hupc=;
        b=GfoDLQG7HoCWR11Az7jDfqHTw/71IiEy932nWLz3CNHrYJAUWWHnM+cJrt5zxxzFmn
         1UL9SnDsVp0D5LM2UvIsfNOpj/zofICgO5E9Bi/LGZNgrtW5Vyl5dQT/Hlobj8eRQ2Mo
         6SD9UehJE7sOhPRLbLN5unRfUmpPQeT+MpRE+yTn5/2i3BV0DrShhC96Dy4m6Glw3cva
         XtwsowhyG3nEGflbNW1sb/CmpbiRW9RN3JS0MiRpijUwv7+e7XYIi9qNIrTESNQaOL01
         s9tQynQ2zRfwwn4PKj36YyQK+7imYyVZffQhdOh1+LlzOVtgVBDn3MHDodG1f9Q073Qa
         Qw5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785353790; x=1785958590;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YFlfsyL868lT/j3agJwNORpNx5tokno15i4G5m1Hupc=;
        b=YWpOAm5d3jdft2PNoixhpdW6FI5vPvs/ioSbNVfbDUZedpmxd0EVSWAPTtRrs1fDgW
         iAi2aG6yw82j0ZGKOcSTURkjNm+Gp5dxtzaIJz7aT5CrUV7kvMpbFmOHv2GXXuhAf6C3
         8nxOrhsanNMZCKCMawRcBeguzuGyyPB0jnMJf6rki9NfBzY1ccICLkLdynjiJIMQuLA6
         a27iet0B4HrTFrG3HBw5DhGPu5EcO5qYNs5TRSsMDX29VegNMPDTgsdCZC+N413rEkgv
         HJRn0XRYlNnsqyqnq5xjk+e9QVbEGoHWRTylgw53upKhCtUg7HV21OI9I+3dWSsOhdnQ
         00MA==
X-Forwarded-Encrypted: i=1; AHgh+RrGqXnML4Y8m+sa8MyVx6Spx4irgjJit+qiXxfVozAn7Hlygs5rQ85Bzi9YTMgHMQ0mZbsI1PMdYA==@kvack.org
X-Gm-Message-State: AOJu0YyljsQx0XKyHk1I9tr1n9Z/jvJW8PTW44OYcmCo9Oh7B8bLB3qt
	YNPD8MZYoX8e7l2iRWky3+fOuA1tZ2BAFuCQAyM4PsVuYhCVei9BLsIXZMwiXQP8r0I=
X-Gm-Gg: AR+sD113w4UhhifhFWXvcWoZJYkgzIBk87AkjDRPZoWkvH6Kgi5ry5aGUgzHmtslne4
	48ssrgmoyz4KoTa2xKrRVit7aZIdZ5s7GAyr5LSS1ToguupOOsRqr8gKYed5r7se3hsRGdzEeiP
	RSrp+9qIhOAEjIqrh0z/ltwzyMphD9K5oW+sMvu47IR2vhYSVg6hk9a6MSFI+2NMY3XPzb4Y/EI
	zVVb5Vs1+VttPXV64IRNPQ5eGtN7rvwGgoEbhrqeh3FAfmwPmnskCQ7Y4aiKV4NcKMsJ0OV4GsN
	jYd7ojrCCvKPZhZvMKIMNoJYxF1kNVZ+hSWf7W4XtVOMxzxjFHuPDqadogK0niV6szXzx+/IF6O
	4+Lxcj5/UY75IIgUYcipaZ9rqq7SLAI6i16iewMyKt8LkvSutKzx99vOfpcxFC83ak1K5izeLwF
	aYOEQwNbm/3DTI7ZpChTUKveQEgMXK6uhlDahWDGTqc08St/0qPgPLGx9h1Hs=
X-Received: by 2002:a05:622a:1ba2:b0:528:15e:d1d4 with SMTP id d75a77b69052e-529d709c7bdmr77022001cf.4.1785353790549;
        Wed, 29 Jul 2026 12:36:30 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-529e2b1a1ddsm25903541cf.5.2026.07.29.12.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 12:36:29 -0700 (PDT)
Date: Wed, 29 Jul 2026 15:36:28 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Guopeng Zhang <guopeng.zhang@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg: stop reclaim when a limit update is superseded
Message-ID: <ampWPFfbz5zvmFys@cmpxchg.org>
References: <20260724021805.1234583-1-guopeng.zhang@linux.dev>
 <amcT75pLmA0hRUm1@tiehlicka>
 <615d091c-bd3b-4686-817e-5b29756542ff@linux.dev>
 <amdkHvSMj95DUri5@tiehlicka>
 <f706d139-53a7-436d-adc5-c691577ce53b@linux.dev>
 <ammzjkUIADCxO2mP@tiehlicka>
 <20260729121137.7b451d2d00ca5a389ebeb848@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729121137.7b451d2d00ca5a389ebeb848@linux-foundation.org>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 850921A000B
X-Stat-Signature: ibm9wdb5cdq9medeiui7y33jrzz8q5no
X-HE-Tag: 1785353791-628421
X-HE-Meta: U2FsdGVkX19YjBtweZoHMNj4sz5z991yAooLjmNqgrFycvgm+trtBD/04IChKK4Bj8LtwQ0ryTR1BtzYe036RoprtXpdYDEdO4iv3hiafFVFxJ6JKEb0cJZdXrPLuWLYHoXJjgFgVaVR4G9BN2rLWZ9sAPY69rWZpp0H3akgioJKc4YRpiY78PP8VxOGGs9Au6cgumFQ+uknSTlmF2u1wNwc50OCE+QLwUS86HiAyHF80+FkCDrNMAziP81e7s184lfP07yXaMU+cyz1ER6HsmFyY8dR6RMUR6moAgnFoTbOp6xB7CGG4u7vBbQME4SB3HiMnjp2qLGC1PTUUbabzi69DWRyKCkOLueEfSkN0Py98TW4smhMhqFqACtCzRIO/fZyUYOuTHNihpHr6EeT2tRbxGe4mftFlQ+3Ml2kOY1y/W17uRiN+Tu/eB6RapYbClsO8WZnUCZwi6WPhejFmo75HKgEfReawy45j4M0K4l6fPpH9Fh13e4nZ+c7gqmIGnRjU/mHwEaZJZU4rQUzoYcSnEMKQ2z5ptwIUAOo2qY0fRw5L7XqU0iiBrJaT7dJmp2pptV7LXqgUM7O1l3qjVjumbOpX7jSFoQWuFlx5M8ghwJ954UZuRPZhsipKK2xT5orc+/HheOQS96Mb9ZwBYpTWjdq3ezg2ZmJ9QVfhIqOG7rD3ErUOaMSZAjb82B50rtds/h4nEBkuPLP+jJFB+924Uqsg6tGM/76CNhaFVkfOMLN2CsJVLvrxEROOAhVE8F9Xm6cjYWQdaY7N/A3FDq39sne5V5stDFmf/3dV8DP1HPSTnwQP8GxhqZSvNfdAvTqiaZcKZV8Qn7LEightCHIlZt+3lWfgTd/oVpdQrVrqgglPVQqjwAWSekPE84lm3Vtmn76aNrZrct5kW8kmuK6BCZnU1jWnuDkBW5oHqZirFXsMcs8wcMy/bagNjdR76urMU7/eyAYilkC3FH
 0IZRFG5Y
 S22eryE2OxfR8gCIhBdQGwIl//OcZzFtuMahGYZGdvQOCbg7KIwH91oHDM4nIEq4Nv43CI/iRmW8MhI4s1Y+TMuINvCuxNZNrQ/niexZC8Xf0n6qHB1042dRhVA1mAF7rpCi7eWl3AakO3nqWTvO4ZVdtIbqjShFdWy2dYPXSG9nOENsqM7OyahR66C5iqgiDt0m07MkSZNRM8IZLM6r+EO5Tmb7CCRgAr82MTwOfEYaTnot/B1C8S+bTXu36M5pm9/W5xYkGsQXiBQdR7j6i0qR3JwwrvgKQ5FsJtr9G0aTHjnossNQz0mO/Er1/2aH4TZaS4YZjzkP03P9n6J3cPqX/3LV+NFaUbL6WJEWypVHuOdm4AajxoVejc4GoLxWZW1M2XtMpiCHxnZYBFVaiwrJv+XHAlyZs8iUV5QESC5eJU1vKXGFk7f8YkIuyRs6rs9L9D150hVKRMz8b5vLfPnCEyxf1Cf7Rulq+xj7nF4Q0O5n9JrP/E1mEGsZvWKq0LlxiOMG0k0WeAzQi4v+zQN/IiUZgsvCSInxmu+QmfRBxwiLGvkl7p1ketKOs1uk7KY2G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 29, 2026 at 12:11:37PM -0700, Andrew Morton wrote:
> On Wed, 29 Jul 2026 10:02:22 +0200 Michal Hocko <mhocko@suse.com> wrote:
> 
> > > > Is this trying to replicate any real workload? One would expect that
> > > > writers to limit do some sort of coordination otherwise the exact
> > > > behavior is not really well defined.
> > > > 
> > > 
> > > No, this was not motivated by a reported production workload. We found
> > > it through automated randomized testing for our cgroup observability
> > > work and reduced it to the reproducer above.
> > 
> > This is an important detail to be mentioned in the changelog. Describing
> > motivation for a change is really important, especially if it has direct
> > impact in user interface behavior.
> 
> I've been adding details to the changelog as they are revealed to us. 
> Below is the state of play.
> 
> I await maintainer guidance on how to proceed with this!
> 
> The worst-case effects look pretty bad actually.  Should I add cc:stable?
> 
> 
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> Subject: mm: memcg: stop reclaim when a limit update is superseded
> Date: Fri, 24 Jul 2026 10:18:05 +0800
> 
> kernfs serializes file operations only per open file, so separate open
> files can update the same memory.high or memory.max file concurrently. 
> Both handlers store the new limit before synchronous reclaim, but continue
> to use the writer's local target in the reclaim loop.  If another writer
> raises or removes the limit, the first writer can continue reclaiming
> toward a stale target.
> 
> For memory.max, this can leave the writer looping indefinitely once
> reclaim retries are exhausted.  The OOM path sees sufficient margin under
> the current limit and returns true without killing, while the writer still
> compares usage against its stale target and records another OOM event.
> 
> Check the current limit at the start of each reclaim iteration and stop if
> it no longer matches the writer's target.
> 
> Reproducer:
> 
> Populate a cgroup with anonymous memory and disable swapping.  Lower
> memory.max from one open file, then restore it to "max" through another
> open file after the new limit becomes visible.
> 
> Without the patch, the first writer remains blocked and repeatedly
> increments the OOM event counter.  With the patch, it returns normally.
> 
> This was not motivated by a reported production workload.  We found it
> through automated randomized testing for our cgroup observability work
> and reduced it to the reproducer above.
> 
> Link: https://lore.kernel.org/20260724021805.1234583-1-guopeng.zhang@linux.dev
> Fixes: 8c8c383c04f6 ("mm: memcontrol: try harder to set a new memory.high")
> Fixes: b6e6edcfa405 ("mm: memcontrol: reclaim and OOM kill when shrinking memory.max below usage")
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
> Acked-by: Tao Cui <cuitao@kylinos.cn>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Muchun Song <muchun.song@linux.dev>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
> Cc: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

This looks good to me. If the culprits had been more recent, it might
have made sense to split this in two, one for each Fixes. But it's 4.6
and 5.5, so I'd assume any still alive backport target would want them
both at this point anyway.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

