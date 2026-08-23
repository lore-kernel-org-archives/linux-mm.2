Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 991BBC5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 07:02:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 619886B0095; Sun, 23 Aug 2026 03:02:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CA2F6B009B; Sun, 23 Aug 2026 03:02:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E1E36B009D; Sun, 23 Aug 2026 03:02:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 284EE6B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 03:02:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8F5EB80295
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 07:02:49 +0000 (UTC)
X-FDA: 85131641658.17.002DA76
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id DF19A18000D
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 07:02:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oFJQKJeu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787468568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rrlgIqfpPIHSqK0RV/eGVXjNicOZIO8LbhcffvSifZU=;
	b=GrATCmr6z4tJAjoNlIyOUXQIU71pIrFuEddTcjDfpuXv99Wplmh1ONAmiiH2GbSDPHjpSY
	JzVmSczDwg+D8g0TeIRbv/Gg+DCIFkk3ZZnTG+dbsWhXAx3jVuC71VCCFO8a5eiNvVG+kC
	c+/DveXGWCdraProyBmIz3CFi1vJGNk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oFJQKJeu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787468568;
	b=CnxB9S7ZnB37OYgIsQmpALdI8ohyZcUiOXc2gGEJnucD2jZc08nkOVv85C4ofXcJ8R2E8n
	i1q/4sFqBH7S4L5RCgGnS0nk8fZE8STC/C/dlFyY7uR6668hOqYxFJY8iuTckA5tvBo7wC
	En61SJzx8+O6oTsf1cK9U8hm+CI0CyE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E824E40E4F;
	Sun, 23 Aug 2026 07:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494EA1F000E9;
	Sun, 23 Aug 2026 07:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787468566;
	bh=rrlgIqfpPIHSqK0RV/eGVXjNicOZIO8LbhcffvSifZU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oFJQKJeuMZncT+e8e6YlISEmXQB11x8W66x7n4X6TulTEx/Z/wSdBmu2qLZBRJdRj
	 hyv9pUZkXZGvwchBnoquA4Y7L35ecs8ywXwbsHaxds0oalhGkNLv/249xUUE9zMQuo
	 IjIbTp2qTGvB5RyopS41bYK1ZuYRwwGC1eHMND1csjVOtylehQWDtdSgz4TAzwa7+h
	 s8alwQI4JXTl62GPqwXqaZjP1MQzSWgK32bkAq55xEd4hXId/GgDn4a5fV15qdAmHX
	 BRD1RGczq74PXBAn+PSR8v6Pc3PTnQ5jSEL4AjkciyRkWpdTBuGZzJcb/G3q2XUIjI
	 LsA+P1uDfWK+Q==
Date: Sun, 23 Aug 2026 10:02:35 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Eric Chanudet <echanude@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>,
	Albert Esteve <aesteve@redhat.com>
Subject: Re: [PATCH 00/11] mm/cma: charge cma allocation to memcg using per
 area counters
Message-ID: <aoqbCyX-32doBJwd@kernel.org>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
X-Rspamd-Queue-Id: DF19A18000D
X-Stat-Signature: pj1uaggw1c69ybge6s9eyecytz3p8bnc
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787468567-365321
X-HE-Meta: U2FsdGVkX19AKEwi8Aj8jcZIY/WNss7y150TRYRicZI+lfkxUBiIWMv8BfJ0LvMlsZKbBy+08NCMmErlCbRpGAPMJy7jQxRQ0WDEgdvHlLBh3FY3CIESUMnt1QWv1RgaVrRv0LRn03LRb7Qsg0nXc+dTmf/bAJ/X0NAMjauK/6rS2y0bhfxVmNMxo2LhKiNAtvJLDXomk7NVLMH9GANV8K+EeO3IhJ7sqEeeOmBidX4RRsHp2kQ/++nFbQimN2SfHoS7wuYxiSaRvKQavRj1JV3NpaMhKvEva5EjoxS1E5yWBFsVzi4V4Q7QP1N31G8vj3NeLgz2wFdS+vAlo6L0owNXXtv0rQb0x9TqXgGl2dEc2vgh7PZ1id52Mc39Sg5SOOevWEfCHSkbSZ+6luy17L9KuHmzTqqdA2MSpepGDpERPFsO9ZbGZlos7vN7TlKAiDdXCcic+O+ciP62VlzZt17qjKmDi8kBX5ekdfkt3dnw406de6rdyQYN1g+5wo5h+XeC/NvavUpBPtucoT7nW2S5jX7FxCogU1wBtTsRhRfANu9uUTxZMAlHU1KaJkzSV0GMsEjZPfN2cw/tQAO1MyiiHBzY5P7z/o+FDLC7sBOBGAOTLgwJMXs2Kc2ViEf74rK60Sn31s48cotbK6Mx5lSrLe0zujEKIfNkqtOtHi9JWq272AwfgYTAmxj7as7Ek92bVbmbdqrdRTHYttxyu08p/2CrkVsQBDHpj6nNMFOw2JcHGwNtuQymAn/kaCTkntDdWbE/L9FIIPL7eGjha7qg018Wy5cxkvL2jkCbaIj/31bQMhgw42OGRQwGqVIh1mIl042L/4jkpMUGC9QzZYihHvvH+XykHDBqI9pMPa0/DZShWvwo3j1ZLqh1NBSt5F++5FYkm3WdaT1wkdRQXXBKKKD2HR0HCZWliknagswFhA+IQESBYUNMblkgiKhYBvIalf1DB0CA7mt/IX2
 Cx3E5oxw
 fnjCX5iC7+U8QRjYBwG5ZsthTNdnGLIij610ozc1i2lJSuMjSkLVJpSG+o8LVNQnGahkJqCBoBRQ+T1F7ApTDSD7jO+bsM2jFxIgkRYvmmxUHf+Oywwj+JfPIIFIyekPSrRIOMsAPNhnXwy+l8QvHe/FgdbeQUf8p85ZmNPR+yMp5xLfe4KquVLFWvka3BhWqXSZwlAzA6UOVPXwfJy/NCbhwYYrVfGeqhD6BjUatEQREhq0ohAmxoF7QFloPThg1zFxeV+/rBsPXxZZuOVJ0PEzPDCjfvmi3dJA2Ppn2Hxvxu60=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Eric,

On Fri, Aug 21, 2026 at 02:56:52PM -0400, Eric Chanudet wrote:
> CMA allocations are currently unaccounted for by cgroup memory
> controllers. As system resources, they should fall under memcg, but CMA
> areas partition the available space for different purposes and memcg
> doesn't have a good representation for that.
> 
> Add a memory_cma_accounting cgroupfs option in preparation for the
> following new behavior. Make it disabled by default since it will
> account for CMA allocations in memcg which may affect existing systems.
> 
> Provide CMA charge/uncharge functions to memcg that introduce a CMA area
> specific counter per CMA area. Charges are issued to memcg and to a page
> counter for the CMA area used. The allocation's folios are marked with
> the cgroup via commit_charge() (once for large folios, per-page for
> 0-order ones) so they can be later uncharged correctly.
> 
> Add the new memcg calls into the cma allocator under __cma_alloc_frozen,
> for both cma and hugetlb_cma allocations accounting.
> 
> Finally register the per-area usage counters in the cgroupfs. Each CMA
> area creates a memory.cma.<area>.{current,max} pair for reporting and
> limitation for each area.
> 
> Selftests and a vmtest script are added to this series for convenience.
> The tests are simple accounting and limit enforcement verification using
> the default reserved CMA area (cma=) and hugetlb_cma.
> 
> Signed-off-by: Eric Chanudet <echanude@redhat.com>
> ---
> Eric Chanudet (11):
>       mm/cma: drop const for struct page on release API
>       mm/cma: include linux/cma.h in cma.h
>       cgroup: add memory_cma_accounting mount option
>       memcg: add cma charge/uncharge functions for area counters
>       mm/cma: charge cma allocation to memcg per area counters
>       memcg: register per-area usage counters in cgroupfs
>       selftests: cgroup: add cma configs for cgroup selftest suite
>       selftests: cgroup: add memcg cma tests
>       selftests: cgroup: add a vmtest script for memcg
>       selftests: cgroup: add memcg hugetlb_cma tests
>       selftests: cgroup: amend vmtest-memcg to run the hugetlb cma tests

CI found issues:
 
https://github.com/linux-mm/linux-mm/actions/runs/32519133924

>  Documentation/admin-guide/cgroup-v2.rst         |  35 +++
>  include/linux/cgroup-defs.h                     |   5 +
>  include/linux/cma.h                             |   4 +-
>  include/linux/memcontrol.h                      |  19 ++
>  kernel/cgroup/cgroup.c                          |  15 +-
>  mm/cma.c                                        |  14 +-
>  mm/cma.h                                        |   6 +
>  mm/cma_debug.c                                  |   1 -
>  mm/cma_sysfs.c                                  |   1 -
>  mm/memcontrol.c                                 | 205 ++++++++++++
>  tools/testing/selftests/cgroup/.gitignore       |   1 +
>  tools/testing/selftests/cgroup/Makefile         |   2 +
>  tools/testing/selftests/cgroup/config           |   5 +
>  tools/testing/selftests/cgroup/test_cma_memcg.c | 402 ++++++++++++++++++++++++
>  tools/testing/selftests/cgroup/vmtest-memcg.sh  | 197 ++++++++++++
>  15 files changed, 903 insertions(+), 9 deletions(-)
> ---
> base-commit: 98f21c54f99519329c18e2625b0ea6db14524d09
> change-id: 20260706-cma-memcg-regions-696cb5ef7998
> 
> Best regards,
> -- 
> Eric Chanudet <echanude@redhat.com>
> 

-- 
Sincerely yours,
Mike.

