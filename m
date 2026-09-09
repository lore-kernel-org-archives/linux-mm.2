Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90DC4C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:26:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73D376B008C; Wed,  9 Sep 2026 10:26:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C73F6B0095; Wed,  9 Sep 2026 10:26:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B5596B0096; Wed,  9 Sep 2026 10:26:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 35DC86B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:26:04 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8694C801D8
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:26:03 +0000 (UTC)
X-FDA: 85194448206.24.F76C4A5
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0F8C240002
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:25:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=NS5VlChU;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf11.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788963960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KW2RH9Ty/MdWv03UCeHROV7nkGt/GjJzoRCaA3lG9QM=;
	b=Cvt1T+3MXWprtlNUGGVC19MkdODQkUfvI4G1mINz5zQoI5R4F51jXt1HOtzfkt7qaEHgsx
	FYhXKx6n+dgdlLFXK3VPzBvSAXU2+Z+GVmFbVrsKiNThY8Gvb8Hk/L6UMNFm5SvWzZTanO
	crZiBsxUR13pQVfCxhGf2YUGo8m+7JM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788963960;
	b=UjdCZQJb5weBdcalUmhE4RE72ri3wAY5OFtknWtBYqtmLzFdN24NWOH4LP6TFlE9KJYJs7
	Nsh647pAiCM/yC65KEttdXDcPYzYa3QMrptbF/yotpNMhv6KNc81u3ul6gXhAmX8AXsP43
	VeXGr0vAiYMmIuo/xmZWJVz+rjExuRE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei-partners.com header.s=dkim header.b=NS5VlChU;
	dmarc=pass (policy=quarantine) header.from=huawei-partners.com;
	spf=pass (imf11.hostedemail.com: domain of gutierrez.asier@huawei-partners.com designates 185.176.79.56 as permitted sender) smtp.mailfrom=gutierrez.asier@huawei-partners.com
dkim-signature: v=1; a=rsa-sha256; d=huawei-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=KW2RH9Ty/MdWv03UCeHROV7nkGt/GjJzoRCaA3lG9QM=;
	b=NS5VlChUHQnDGlfjHbgtKyLbpa1LeNZBAxGSb9dg5o/ZpnoIdR/A5pxXvv0edfCXBEIGgNxlz
	SqDIWm1BKuT+5oLz27TfH/NNR4yp03O+btU/bbs7LTZD6FxIVjHXa74C0fQiL27Wp6FhAkezOBE
	FWwAjEwrq9bruxkSiahHCdI=
Received: from mail.maildlp.com (unknown [172.18.224.107])
	by frasgout.his.huawei.com (SkyGuard) with ESMTPS id 4hg33k3JQYzHnGj0;
	Wed,  9 Sep 2026 22:24:50 +0800 (CST)
Received: from mscpeml500003.china.huawei.com (unknown [7.188.49.51])
	by mail.maildlp.com (Postfix) with ESMTPS id 416564058D;
	Wed,  9 Sep 2026 22:25:52 +0800 (CST)
Received: from [10.123.123.154] (10.123.123.154) by
 mscpeml500003.china.huawei.com (7.188.49.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Wed, 9 Sep 2026 17:25:51 +0300
Message-ID: <6f1e4bde-da16-4510-b1c6-16ba2a24d3f3@huawei-partners.com>
Date: Wed, 9 Sep 2026 17:25:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH REPOST 0/5] mm/damon/vaddr: support {prep,apply}_probes
To: SJ Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
CC: <damon@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-mm@kvack.org>
References: <20260909140408.104699-1-sj@kernel.org>
Content-Language: en-US
From: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
In-Reply-To: <20260909140408.104699-1-sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.123.123.154]
X-ClientProxiedBy: mscpeml100003.china.huawei.com (10.199.174.67) To
 mscpeml500003.china.huawei.com (7.188.49.51)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 0F8C240002
X-Stat-Signature: bu45ze15s5g9ip94op4d8g5g7nmszbpy
X-HE-Tag: 1788963959-522061
X-HE-Meta: U2FsdGVkX19Fxa7PpZ3CeSQmPs7dGBlMsQya+ktCE8NkJkCRSmMoMxzS//3LJzS3RComtl6MxNOTyd//bUzgx4ju6fQWyzu1qSKWEhs682DyY5VRa/JCeL8CWzEwYNzpMH2o6fZZLTrjN2B6YsAhhlieuGjlkyefQniUEeKsLw7yYrEFCK1SV3ymjRw0DyfshdjL02A/gSqXX3lN/uD6OwrsZitcMr0y3jow8q8/v9p4JeXOKExWdOEgFA4nqhbFgHPwh6ypFIe+zpEsziZXydWORA9FjXNtNxQpPvORjaGW8qK5qEvNVISLUJUnPj/r8/Rjj3Zfs9igQqEG1bT+9WwPCfqwAAXK147ckOXCOBg1uCbUPXHtKRMhVIACp2zq00XCD8+TcCn5ZEM7P5WMvLiSpDUsj2w6/YGB8h3hImfI2iAGnJUg0loGZI0yYt7BaFwe3/mlVpGQlR2KqTCul1T2TrXHEhU0UqOOmBR3m2urt/Pynut55XRiSEtkeQLTW9LZfcUsc8SCCd3zVkOS3MPuYNUQld16gF+LOBSXCG428YUfFIcFd3H+429snVw8efHMHkxFrWx78gS8oXcjQSSuf3g4zz6lUHYYEvp/zODf+ESDqrVrEe+hXna1mZrd4daTrInog4o1f+jMdmWhpSD7L1YsRlmsL613wEOAPnZt5/LJCiG0KgMScXG9DKXqHHbtty9ILrdQQCKmkcSTFHPlswdlfdn88aMjnOaYzNcNN1gF8sZnbrOVlxvbohuCuivHMhEdPo6z2viXvg2UNEhbzVY9B42VgIvwdltB9zYleRaAqbSsezmIOXmHYEOzEJfesUgiGf3MExb0uvdWf2WljRafeILzmUrmLLywdVQwsA0DEq4GfCULcB6cfYsqe+MrNT7c7wD7H2hBMOE5v8826v0FGXc47qX1AEvaZy2mDe5rxCYkd0XuWtLAYo17Fm84df1K+YyTFBp7YBr
 lRlN5QpP
 WMIiLOIImyxIgQp8KhNCrkX+QFQOFco/Xkhul70908cOjVLK2hRPTcETjhpN9/A204CYeGDbiSscNWkDeP0lMLOmHIKaEEHsGMyhKZ7cwvABNrULww0j62WgKN/Lejune9QYGc/37OODHfmboVAxg+shW2UikmIiFPPthL+m2MMXID2DbJ4oMQss1aFQetGml/MZjb6mNrL78WtdzwJsDM5pSnbb25vI2O3+0mCyaim3WwB5s4B/bg3DvOKruF0lrO7IMLN++TMpPPhQSmZTkatVOjIY8/4AUtiUb+StNwYTAgP1UQr0ZFDK2RaaRHgfb/CrqxhzjGVHEe7e8CrnWFzv7sejNXnQ/ia7UPD7g4wDmG4XYehrPDSbdRDQVVXv1BjAIV7OAWUrip2brcRidTeRN8FeORS7zoQX32an02W9Pac5EV9ECQr5E7U63VagQ/TzA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

On 9/9/2026 5:04 PM, SJ Park wrote:
> DAMON supports data attributes monitoring.  However, only the physical
> address space operation set (paddr) is supporting it.  Add the support
> to the virtual address space operation set (vaddr).
> 
> Patch 1 adds prep_probes support to vaddr.  Patch 2 moves probe filter
> handling code in paddr.c that can be reused by vaddr to ops-common.c.
> Patch 3 adds minimum apply_probes support to vaddr.  Patch 4 extends the
> support for hugetlb.  Patch 5 extends the support for pgidle_unset
> filter.
> 
> Test
> ====
> 
> I confirmed it can capture ~48 mb working set of masim in vaddr mode,
> like below.
> 
> First, start masim [1] to access ~48 mb memory at a time, in the
> background.
> 
>     $ ./masim/masim.py run \
>             --config_file ./masim/configs/stairs-50mb.cfg \
>             --repeat 10 --quiet &
> 
> Note that the config says the working set is 50mb.  It is 50 million
> bytes, so ~48 MiB.
> 
> Start traditional access monitoring of masim's virtual address space
> using damo [2].
> 
>     $ sudo ./damo/damo start $(pidof masim)
> 
> Confirm it can capture the ~48 MiB working set as the 4-th region on the
> snapshot.
> 
>     $ sudo ./damo/damo report access
>     heatmap:
>     11111111334[...]3000000000000000000000000000000000000000489999997777777743333333555556[...]8
>     # min/max temperatures: -1,150,000,000, 80,009,499, column size: 6.963
>     MiB
>     intervals: sample 5 ms aggr 100 ms (max access hz 200)
>     0   addr 85.355 TiB   size 55.703 MiB  access 0 hz   age 9.500 s
>     1   addr 85.355 TiB   size 18.984 MiB  access 0 hz   age 6.700 s
>     2   addr 127.183 TiB  size 278.516 MiB access 0 hz   age 11.500 s
>     3   addr 127.183 TiB  size 7.570 MiB   access 0 hz   age 900 ms
>     4   addr 127.183 TiB  size 48.133 MiB  access 190 hz age 800 ms
>     5   addr 127.183 TiB  size 54.977 MiB  access 0 hz   age 1.700 s
>     6   addr 127.183 TiB  size 55.113 MiB  access 0 hz   age 6.700 s
>     7   addr 127.183 TiB  size 37.902 MiB  access 0 hz   age 3.900 s
>     8   addr 127.990 TiB  size 120.000 KiB access 0 hz   age 11.400 s
>     9   addr 127.990 TiB  size 8.000 KiB   access 70 hz  age 0 ns
>     10  addr 127.990 TiB  size 4.000 KiB   access 0 hz   age 11.200 s
>     memory bw estimate: 8.931 GiB per second
>     total size: 557.027 MiB
>     record DAMON intervals: sample 5 ms, aggr 100 ms
> 
> Stop access monitoring and start probe-only mode access monitoring.
> 
>     $ sudo ./damo/damo stop
>     $ sudo ./damo/damo start $(pidof masim) --probe_prep set_pgidle \
>             --probe_filter allow pgidle_unset --probe_weight 1
> 
> Confirm it can also capture the ~48 MiB working set as the 11-th region
> on the snapshot.
> 
>     $ sudo ./damo/damo report attrs
>     heatmap:
>     00000000113[...]40000000000000000000000000000000000000000000000001111114999999533333336[...]6
>     # min/max temperatures: -840,000,000, 330,002,000, column size: 6.961
>     MiB
>     probe prep: set_pgidle, filter: allow pgidle_unset (weight: 1)
>     intervals: sample 5 ms aggr 100 ms (max probe hits 20)
>     #   size         address       age           probe_hits
>     0   8.000 KiB    127.990 TiB   8.700 s       0
>     1   120.000 KiB  127.990 TiB   8.600 s       0
>     2   55.543 MiB   127.183 TiB   8.400 s       0
>     3   110.008 MiB  127.183 TiB   8.300 s       0
>     4   55.352 MiB   127.183 TiB   8.100 s       0
>     5   55.605 MiB   127.183 TiB   8 s           0
>     6   55.691 MiB   85.355 TiB    7.900 s       0
>     7   54.430 MiB   127.183 TiB   7.900 s       0
>     8   50.391 MiB   127.183 TiB   6.900 s       0
>     9   18.879 MiB   85.355 TiB    6 s           0
>     10  52.844 MiB   127.183 TiB   3.500 s       0
>     11  48.039 MiB   127.183 TiB   3.300 s       20
>     12  4.000 KiB    127.990 TiB   8.500 s       20
>     memory bw estimate: 0 B per second
>     total size: 556.910 MiB
>     record DAMON intervals: sample 5 ms, aggr 100 ms
> 
> [1] https://github.com/sjp38/masim
> [2] https://github.com/damonitor/damo
> 
> Changes from v1 original post
> - v1: https://lore.kernel.org/20260906184417.96621-1-sj@kernel.org
> - Rebase to latest mm-new.
> Changes from RFC
> - RFC: https://lore.kernel.org/20260905202634.88102-1-sj@kernel.org
> - Drop RFC tag.
> - Rebase to latest mm-new.
> 
> SJ Park (5):
>   mm/damon/vaddr: support prep_probes
>   mm/damon/paddr: move probe filter handling to ops-common
>   mm/damon/vaddr: support apply_probe
>   mm/damon/vaddr: extend apply_probes() for hugetlb
>   mm/damon/vaddr: support pgidle_unset probe filter type
> 
>  mm/damon/ops-common.c |  32 ++++++
>  mm/damon/ops-common.h |   2 +
>  mm/damon/paddr.c      |  23 +----
>  mm/damon/vaddr.c      | 232 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 267 insertions(+), 22 deletions(-)
> 
> 
> base-commit: da659d141e9797b3a2e5d0e2b457bfa4e8a8cb2d

Nice to see the progress with probes.

Since you are adding prep_probes for vaddr, do we need to check for
the existence of prep_probes in kdamond_fn?

How about this?

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 645cb367019a..7b308cbf21ab 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3935,7 +3935,7 @@ static int kdamond_fn(void *data)
                if (kdamond_wait_activation(ctx))
                        break;
 
-               do_prep = ctx->ops.prep_probes && damon_has_prep(ctx);
+               do_prep = damon_has_prep(ctx);
 
                if (!access_check_disabled && ctx->ops.prepare_access_checks)
                        ctx->ops.prepare_access_checks(ctx);

And maybe change the name of the variable to has_prep.

-- 
Asier Gutierrez
Huawei


