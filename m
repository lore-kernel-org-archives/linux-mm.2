Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1537ECD4F21
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 07:37:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C5626B0088; Sat, 16 May 2026 03:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2766A6B008A; Sat, 16 May 2026 03:37:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18C1A6B008C; Sat, 16 May 2026 03:37:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0AB626B0088
	for <linux-mm@kvack.org>; Sat, 16 May 2026 03:37:12 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 98DF616067C
	for <linux-mm@kvack.org>; Sat, 16 May 2026 07:37:11 +0000 (UTC)
X-FDA: 84772477062.26.DC45215
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9B8A3C000B
	for <linux-mm@kvack.org>; Sat, 16 May 2026 07:37:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nNpNtXRG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778917029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TdEt0/9T0OH/lLq8NO746g6M/VT2FP5Oq/347s859gY=;
	b=EsAiVYwAlFuumE5dzkl36SPOyTp2ZGKpRBxWfnnJTJ6ibe0bvAHa6CO5G8GR8AvfyjRSXR
	tZuAy+6na0nIVHWaNlVGMDXs11sOiZ16EyOmRwIUq3O7Ftk8cNYLWxThfDJSd4kctbDpA8
	2nmK3aK3U2+KTDkAYxx9fNZlZwKdA5o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778917029; a=rsa-sha256;
	cv=none;
	b=BKt5tA9MRI4tACh+FL/7rc28E5DC+PfogmR5NwXhhHiexpr75xMwkUolnjVNy/dbp+ZQDT
	yhIfLunigqMwZyAx5CxK4JrGno5bm+grfqamNZumDtCfiHmMmAZOsITdMouIrqmnxsboFh
	ZAi4sRXNJYcuukXlxs6dqyDp7dR0KPE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nNpNtXRG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 508BE445DE
	for <linux-mm@kvack.org>; Sat, 16 May 2026 07:37:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C04C2BD01
	for <linux-mm@kvack.org>; Sat, 16 May 2026 07:37:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778917028;
	bh=P3vqgwHwD6iLuiEKYHBc9rKUdaJI1VWv+dxZinDZG8M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nNpNtXRGUw0mf4NnH+yNpsGfoHEeYyd5NHflVOhmZkdo7mVPuYo0Sn7ejcQkpbAdL
	 Xq4AnHBYR4AGZl8TBwgKc4eBK1jQKV2THXCREwHOk3eNmL2yNugi07+KM4ItzVAMO6
	 lSPY0Q0dGzv7nMdKXX7wA4HJVc7hGOOjnXN54jcMnyKjaImX35rvGB1CMn7FnXzrEH
	 ttD1bT9CLBvfDdqqOFFKIZxJh2yhLap9F2AzPm/qZYxfkQWJm8kzSDn2H87s6wQ+fJ
	 uJXowVoELz8Hq3RAcg3eCdTqAUK/EgUtAJVUnrzr3fZqJNnt9hF+hAPgi/sObhd4Kf
	 /5dvJQcCOdrpg==
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8b5cda2dab9so18736126d6.0
        for <linux-mm@kvack.org>; Sat, 16 May 2026 00:37:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+MWWjDNWjDaSGVNLHsimFwncNS9bQSnKgDIkLSBdNOcDgieBs4I/pF62IcGPe1ZsJlDvcsp8+o3g==@kvack.org
X-Gm-Message-State: AOJu0YzOoWgsNFpWwUnolxxXkQhlTYi/MUkPhRUzfltvtpRYP0apVqqz
	vy2swu1BkIery51tJ1SgWoEoRAeQGKGiEmc5UgxGnfPmab9OsNjcrdwcHJXXhZj37fSnppeTTE/
	nGXSesZlMt3xwM4KXe8szG1CY8wIOLxg=
X-Received: by 2002:a05:6214:29ce:b0:8b3:ff3f:5d61 with SMTP id
 6a1803df08f44-8c8fda1ccbbmr178745586d6.22.1778917027156; Sat, 16 May 2026
 00:37:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260512-v2_20230123_tjmercier_google_com-v1-0-6326701c3691@redhat.com>
 <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
In-Reply-To: <20260512-v2_20230123_tjmercier_google_com-v1-2-6326701c3691@redhat.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 16 May 2026 15:36:56 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xfznffbjOaNKwnN6oZk_H6pqOzYqd1zx4Q9XrocdzV8A@mail.gmail.com>
X-Gm-Features: AVHnY4L9M-s1Neba6WebvB2EkXnslTMMIykTYPVPE3skCvVx5rzQK6ntLSW6W0w
Message-ID: <CAGsJ_4xfznffbjOaNKwnN6oZk_H6pqOzYqd1zx4Q9XrocdzV8A@mail.gmail.com>
Subject: Re: [PATCH RFC 2/5] dma-heap: charge dma-buf memory via explicit memcg
To: Albert Esteve <aesteve@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Sumit Semwal <sumit.semwal@linaro.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Christian Brauner <brauner@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>, 
	Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-mm@kvack.org, linux-security-module@vger.kernel.org, 
	selinux@vger.kernel.org, linux-kselftest@vger.kernel.org, mripard@kernel.org, 
	echanude@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B8A3C000B
X-Rspamd-Server: rspam04
X-Stat-Signature: ogoqudbq1ioxciptief5co9cumrd6snq
X-HE-Tag: 1778917029-891561
X-HE-Meta: U2FsdGVkX183tPnflHH8x6pWifOQqpt7Wev9JmIM/wHn9m+bbGoSGcXi1S59Y0/aWu5kbgF1pK3lb0PW0ooO/iKA4OWwiU8Ik4skahOJyWRnH4FccJY/aRKD95GVLix9qb8xlPhc1SAQ3P+vnM3OCgRnU26DetxPMoYVQq9hThhlBLYMys7/OWw1K1tc4kaX3W5VvteVTVt7WD0XQUALlkrCsZ7lIcR6FkIg+xENuh3Yi12OjBtsF1DZIOppsGh85Z/rSdN7woj11ThPWS912sIYqF8dvrr1M2hZdDZpFNyFD+ZDO5I/3Z6sBaeTI7+MBaNtCSgHkqpb+1THJhy/YmCqmIvso84q5oziaiRSNpoi28mXXM/vYVBYQlJD/u9UdxOtqZRadhqOqLEzKVWEq6jw1hOzCus7ndYlnQCIXXMA0IvxneLq6dDZ6JymHCZn0LLObbxD/oTIl3nCV6kNdz5GT8qiRaTccyv82Jn6Gp8JRtGa4HrSAHT9qCiGo5Q7I6N1KLBJnuAp/fx+h1l6fjz4AcgP58huTibJtreC0JhLUSGu/6AQhGIDT4BLyUBO5q3+FOCwoB47T/al7QzjVl1+ThNRnkPADJkn7VyzaV9k/VKvzQVRgOXp5UGS+7odC+T5brysn2DEpj6eHfPXZXIgq+0fKIlJHIVWghyOaqmxCBzt4sfDkfT5Gwy8PYTt/U9sjjMLUzN16GxmPUKVZZIOyeegXLac7rbGWrT+Zo3LgvFoe1nPEEl7lxSz+ggP9+b3nNNXzpnX/eeRjn1o8CRaeKn1NwkCbfyb9tIdls5sV3/HdL6tgqlLtf5hQKGS2e1MlQKnxa0O3M4QGSdGstt60xIc6FCrEUYjoHEOBigg/X5OTuCL/ccaA8d5m2yj/Qvl27fBK/hHF16KUGzLL9xjCviX39vZXyt+qNimwnEJXrOdWPkC/vasBZAny+A4i+0wuENQ/ih1QL7O0NQ
 VnvizZy+
 OWxmwapcRjyOMBO/Dax2e91UW4ycaHOoljcOPVa3dovLUY7qe3Cxc8nuP4oFIZff+KBm0uW+I+RqVzGCZ20CRf3nRuPfdqSNsNhSvhyLWe4eF/b7UeeByuKLIdV6Bc5V5ka8OyINBIu0ku4g7pPBUKQB3UFKUcAjkS2Xu56/SLhrdnwZrAA7UfiwsGTLtJVxhfAxFTiBxV0LzXODOgx1KyTiKGjnMcCQmYYEzJLY4snLMZwxRX25bIflCzU5ZIXwsN2NHssi8UUa3kueYUYzYLnoPPRdPDzc3Tth/mWo/VJ8FSMMM47STZREVlSMquh1NPkDUPzZ5Rdidw2rWN7EZUPuvsuYjJCNw3S8aColD3p0sQcx5AkY/wiqR2gvPhlbNiYra
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 12, 2026 at 5:18=E2=80=AFPM Albert Esteve <aesteve@redhat.com> =
wrote:
>
> On embedded platforms a central process often allocates dma-buf
> memory on behalf of client applications. Without a way to
> attribute the charge to the requesting client's cgroup, the
> cost lands on the allocator, making per-cgroup memory limits
> ineffective for the actual consumers.
>
> Add charge_pid_fd to struct dma_heap_allocation_data. When set to
> a valid pidfd, DMA_HEAP_IOCTL_ALLOC resolves the target task's
> memcg and charges the buffer there via mem_cgroup_charge_dmabuf()
> inside dma_heap_buffer_alloc(). Without charge_pid_fd, and with
> the mem_accounting module parameter enabled, the buffer is charged
> to the allocator's own cgroup.
>
> Additionally, commit 3c227be90659 ("dma-buf: system_heap: account for
> system heap allocation in memcg") adds __GFP_ACCOUNT to system-heap
> page allocations. Keeping __GFP_ACCOUNT would charge the same pages
> twice (once to kmem, once to MEMCG_DMABUF), thus remove it and route
> all accounting through a single MEMCG_DMABUF path.
>
[...]

> -               if (mem_accounting)
> -                       flags |=3D __GFP_ACCOUNT;

Hi Albert,

would it be better to move this and its description to patch 1? It
looks like patch 1 already introduces the double accounting changes,
and patch 2 is mainly just supporting remote charging.

Also, mem_accounting is only used by system_heap.c; has this patchset
also eliminated its need?

Thanks
Barry

