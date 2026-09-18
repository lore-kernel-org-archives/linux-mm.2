Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35301C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 16:38:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08D1F6B0088; Fri, 18 Sep 2026 12:38:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03E576B00A1; Fri, 18 Sep 2026 12:38:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E96906B00A2; Fri, 18 Sep 2026 12:38:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C8CA46B0088
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 12:38:01 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1003612073F
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:38:01 +0000 (UTC)
X-FDA: 85227439962.16.2683D9C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 508221C0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:37:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hGwnyY61;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789749479;
	b=4JSFL2jiIbM6KTxgEkSatxtXv3XwlS4ndXncmZDPXbcruucDXTJfVqAXbisLJGYtQ/YoZX
	zWQiC8CgB6xUIcIly91GMOzDvMi9n3fV7GpCYx++TEaQlbv+MxeDCRhB8BEb3K6mAs1sv1
	+o9e9NVN5jWTfKA8a9WbZU5b4oM/QlQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hGwnyY61;
	spf=pass (imf21.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789749479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iD5n9wZgFu9t1L3ANTHITm97oEB8VYi5DwC7XLPAORY=;
	b=F952WBGpDg4ZAE1LthYrEP2+O1qtXNSpF/mOEfzS65xwOsv8+EbzVYy2cD8bS2mc/MJLXJ
	icsLoeVmKY3so/ZZySCxNAdO+xUaDrKMHa5zD3L6aFxfSTZEZgKFsnVrkb5A9dsg7oh9hi
	0cakCuQW3MDEuKDURJ1ocxKkho9V59w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 826F44057E;
	Fri, 18 Sep 2026 16:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426101F000FF;
	Fri, 18 Sep 2026 16:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789749478;
	bh=iD5n9wZgFu9t1L3ANTHITm97oEB8VYi5DwC7XLPAORY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hGwnyY611cszDR+4TPDrMQUZbBiqdoW5ZLKxi3j0ka0qbi07BvkgFcht3lFcgtMAN
	 cUTZC/mnV94XiRp6wkg4b8j1YEZC6dGfY3hVTucL0vSwhj+pPResc5dB8SikiHA29v
	 AJPQHog9QUpPVT6CEw1iRJxQgXH+gozatAQBF5TP2iBuHzqsmrJfnUNLtRoYjmYDGP
	 V2TWmYDpdSP0Gr3RUv+ByFZDUpfKZJdMeK6nz+qPUndyTtBSRZHgMiS5JNPlYOfK1j
	 LfM2HXrGLqH0npfDRJjKtvVhAP1TScMAQc962ur9z9Axg6xKl0qxHljlkCkwXmwWMV
	 yGBw9UBuvUJFQ==
Date: Fri, 18 Sep 2026 17:37:51 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Rakie Kim <rakie.kim@sk.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 1/3] MAINTAINERS: split up MEMORY MANAGEMENT - MEMORY
 POLICY AND MIGRATION
Message-ID: <aq1o04SylcmHpPVH@gremlin>
References: <20260918-maintainers-mempolicy-v1-0-9a94cac6d135@kernel.org>
 <20260918-maintainers-mempolicy-v1-1-9a94cac6d135@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918-maintainers-mempolicy-v1-1-9a94cac6d135@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 508221C0002
X-Stat-Signature: 7bewiy79gnpyrmkix61f7f41gc9jkcxg
X-Rspam-User: 
X-HE-Tag: 1789749479-223164
X-HE-Meta: U2FsdGVkX186vsfjj+5BmZOo2ZnQpLN0i/ti3xTpW4SXFCZFddOVza8Le1bH/z9aahKoTDycX4wmx4l3lbN1nZDryIgmXEvn2xcVmUy5sJ8VVZlhHHZnSBDnYw3zjPiWbaUQA6/S7Qwn/Lh6PdWvTP5aQdUyvG8Vhgc2zqYiZixreO2/P8wI9PSXgKhwP0Zw7mL9UZSWai57f/+whbH1hKmh7JNVMrYPZIPTrOS5GvDErgK2HAA4oVM1Wy3be+kjJVXd5TYNv/c1QxG/M/pJM4mLGkwPPMzxvqrsw67v5rjdPMxdNoMfHwOX/LbA/7VDbqROPUgQpNA/7mlDQ1RqSbjZd+Ha4ZDfXmkOtFk+MnAh3yK87WCSbc+b9C5qpPVUqaSAjzMlmxI0eiOOlMXISpnqWoM2uA1ny+RAIGuYRygjJaU70Tx9bckyBXbSsnGfhwZ8y1Px7XdSlTPybYppE0iApIKqqUp5JZx1gHC8iAoXx592WGeeN617o96HPmH3SB81LCaO+1NgDBE5gZZhGvmcOlNgPu2+3Fq4AIJbLYujX65PGUzgxS5TYCgfdBgXsLrWIAifG338SgeUH93JrOmV62A4tIzjRZXtdP+hc0sTBcRZSvQgPrzG3OyjpCNcBLoqCA/xMunBmLVk1dxvRqVY5OzEXLDJ8IihrNV5MYVi9latehwH2iYfa4um2YrOt6a58KOekzAadhHNC1GC9pB2IRXww44oI7RjzIqkHVagGa/vZWBurLjzkP5nVNDpNWHu3IZmWdWuLGPsw1EWrYA9KnoJOrWB0dFA4Sp6gqiCpV4JkXY76Hg4luTQATY/edRJt7Gl4HPd4QhrYiF4mweuZm30AAk7DsqU7xlYlO/k4sS49rQwJA+bKbLrQ5pSrciUs8xdYjIeBFLjQqJJymVavHBtfMghu2IG3HcXGC3WGCJwZbxNH4vAVj1czKQi1hnsRGwGQVcCJjimGlg
 dQ57WN/q
 k0nodMR91heJjQ0br9kAyVKO3HzHB7RDtfDf+z3QIt6DHvocEBzO5kkBhNDGuIz+4I1sRkeZav2+FLZMsF92vsOh20h00NNFtNjiTw9Acbc0pdFNCR+u8I3b9aWGG9pUciZzYCw7LutSxprBZqZafq0+BJzQXpjrlC19SiA6jdWpHTsTpne6oj80Gy8yqI3Q82stLfxqH4hpXzaHz7MP8WvM2vSsuoZ9vYmrPNyAxM2Q3x1orMDWPnPl28sV28ZJAtVvHX9NYLyFAMUzG++HaXQm+ELAQTGmt1rDNRwl71+JguNzhxOUN7GO03RxiJ+6IYeoHUzc4F+ALw7x0OojwUNYlVgIYDYuerIgz2njc8XQ3gn2Z6NQohE1Ib4KWYxfMPMiFiIeHzr+3EFjrWeirz7o5fkvbRK/fVJ9kcTP8ipGMt75mpfK0Jy7u3a0QyKlseiFk9zM+7ouUTwuSCbwfEplEkhwSpVZGJdwZWL5rT0obGtyzKZv6o21Kc97SeHOZDs0sv8vuyB9IDuV2TFlH8tlu8JRD5tYtZVVQXUZINRwVF/8zr3PgoiwPGGiiNbZ00EFvSwTWy8rSWcahLsA+lHfPgJuRmKZd2C2VYisNeEbjUgYq0BorjBzgY29mw3muwlTG564hhjq2rV8SSRCJafdAyvUsl4ktZqXScBvKT1gEsEeoTCom5Tha/C5k1GtbLKCYLHxBGIFApmnKRhPP8Ss6/ZtVsOtiL8Wq/AVWrT3Na+OLtF4ONcTVv4zQKj/HFpZWsR6Lgph0gKdReViU3f2cEzVWZJbiDiBoTjy0h1TgiNfBC9ddb/rsetMKQCZJE9pggfUf0UvzrxODn9/KshyUKA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18, 2026 at 06:34:24PM +0200, David Hildenbrand (Arm) wrote:
> Let's split it up into MIGRATION and NUMA PLACEMENT. The latter is a
> better fitting description for mempolicy.c.
>
> Make a best guess about which pieces existing reviewers are interested
> in. Move the split sections to keep alphabetical order.
>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Makes sense, so:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
>  MAINTAINERS | 62 ++++++++++++++++++++++++++++++++++++-------------------------
>  1 file changed, 37 insertions(+), 25 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3b2eb2a7a89a8..77232db57b53d 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17207,31 +17207,6 @@ F:	include/trace/events/ksm.h
>  F:	mm/ksm.c
>  F:	mm/mm_slot.h
>
> -MEMORY MANAGEMENT - MEMORY POLICY AND MIGRATION
> -M:	Andrew Morton <akpm@linux-foundation.org>
> -M:	David Hildenbrand <david@kernel.org>
> -R:	Zi Yan <ziy@nvidia.com>
> -R:	Matthew Brost <matthew.brost@intel.com>
> -R:	Joshua Hahn <joshua.hahnjy@gmail.com>
> -R:	Rakie Kim <rakie.kim@sk.com>
> -R:	Byungchul Park <byungchul@sk.com>
> -R:	Gregory Price <gourry@gourry.net>
> -R:	Ying Huang <ying.huang@linux.alibaba.com>
> -R:	Alistair Popple <apopple@nvidia.com>
> -L:	linux-mm@kvack.org
> -S:	Maintained
> -W:	http://www.linux-mm.org
> -T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> -F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
> -F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
> -F:	include/linux/mempolicy.h
> -F:	include/uapi/linux/mempolicy.h
> -F:	include/linux/migrate.h
> -F:	include/linux/migrate_mode.h
> -F:	mm/mempolicy.c
> -F:	mm/migrate.c
> -F:	mm/migrate_device.c
> -
>  MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  R:	Kairui Song <kasong@tencent.com>
> @@ -17252,6 +17227,25 @@ F:	include/linux/mmzone.h
>  F:	mm/vmscan.c
>  F:	mm/workingset.c
>
> +MEMORY MANAGEMENT - MIGRATION
> +M:	Andrew Morton <akpm@linux-foundation.org>
> +M:	David Hildenbrand <david@kernel.org>
> +R:	Zi Yan <ziy@nvidia.com>
> +R:	Matthew Brost <matthew.brost@intel.com>
> +R:	Joshua Hahn <joshua.hahnjy@gmail.com>
> +R:	Byungchul Park <byungchul@sk.com>
> +R:	Gregory Price <gourry@gourry.net>
> +R:	Ying Huang <ying.huang@linux.alibaba.com>
> +R:	Alistair Popple <apopple@nvidia.com>
> +L:	linux-mm@kvack.org
> +S:	Maintained
> +W:	http://www.linux-mm.org
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +F:	include/linux/migrate.h
> +F:	include/linux/migrate_mode.h
> +F:	mm/migrate.c
> +F:	mm/migrate_device.c
> +
>  MEMORY MANAGEMENT - MISC
>  M:	Andrew Morton <akpm@linux-foundation.org>
>  M:	David Hildenbrand <david@kernel.org>
> @@ -17304,6 +17298,24 @@ F:	mm/numa.c
>  F:	mm/numa_emulation.c
>  F:	mm/numa_memblks.c
>
> +MEMORY MANAGEMENT - NUMA PLACEMENT
> +M:	Andrew Morton <akpm@linux-foundation.org>
> +M:	David Hildenbrand <david@kernel.org>
> +R:	Zi Yan <ziy@nvidia.com>
> +R:	Joshua Hahn <joshua.hahnjy@gmail.com>
> +R:	Rakie Kim <rakie.kim@sk.com>
> +R:	Gregory Price <gourry@gourry.net>
> +R:	Ying Huang <ying.huang@linux.alibaba.com>
> +L:	linux-mm@kvack.org
> +S:	Maintained
> +W:	http://www.linux-mm.org
> +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm
> +F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy
> +F:	Documentation/ABI/testing/sysfs-kernel-mm-mempolicy-weighted-interleave
> +F:	include/linux/mempolicy.h
> +F:	include/uapi/linux/mempolicy.h
> +F:	mm/mempolicy.c
> +
>  MEMORY MANAGEMENT - OOM KILLER
>  M:	Michal Hocko <mhocko@suse.com>
>  R:	David Rientjes <rientjes@google.com>
>
> --
> 2.43.0
>

--
Cheers, Lorenzo

