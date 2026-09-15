Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C5C5C88E73
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:31:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 875776B0088; Tue, 15 Sep 2026 04:31:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 82A036B008C; Tue, 15 Sep 2026 04:31:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 717666B0092; Tue, 15 Sep 2026 04:31:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48D2F6B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:31:48 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CBA3140374
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:31:47 +0000 (UTC)
X-FDA: 85215328254.22.0BD723D
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8C1F18000D
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:31:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BbTjniSG;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789461105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=srZnYOZh38wMRO1+hbACREA44r35OdzHMy0XMVlEyHw=;
	b=13zSSmtDyBDilYnmH2mTQhh/7ptanIYKqXtWigWf1BQ5ZYqrWkPuHWDFIh8OVhl4pF8JOi
	QjvcCMSgWCH/sHERkrYdZhdQGmuDpseVYej+494ZZmsor7WsGpfJdxF86teIA8Xbchpks6
	01ptN08GfJ7ocgB5vtMsiYIxynaIhO4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=BbTjniSG;
	spf=pass (imf30.hostedemail.com: domain of mhocko@suse.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789461106;
	b=HM569BhnAyLfjuC1fh6Q0UeL+k5t4yeDHes+SrJpSvRqV5+TQzOsPmaBFQGF5GGjjWxuUY
	LP+WBH4I8k0a4PDqE2mbJovQOtQ5zlqitXCHzS+0cqvhc/4YrqfgNxe4oB0w+nOvN7Py1D
	1dcUMboYVg86X4s0axlpncM5rs2aE0U=
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c25ef7a3ce9so371488366b.3
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 01:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789461104; x=1790065904; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=srZnYOZh38wMRO1+hbACREA44r35OdzHMy0XMVlEyHw=;
        b=BbTjniSGyNhiEJI+dEkWneWBvp0JR9KQ37cOQvd2wG6cAcjNYyI0gRayWHG2K4/30t
         gdeJQlMsPn9/za0m9miwT3b6w52RkqGAv2WLDN/girDCWP28DDnNzRzD8SBDT37YxItf
         O2OCVu93zLUydOgojkP1mktcsYQG2qDxcD/emIaT1uy6AWC32LDi+f4SPWq4zSwtUz7U
         QiA0CRf/Q42kJ7ORfQUGgII/ZaLW8aCUhuSLF8WcHfxlkwWJFfOnzdODDXvsmJa+NdmY
         PchKub3/m/j/tL1XGIwpOf9UIq4b40hdRzFddUVXJy++RvCce/lE16hdR1J+5+szql/g
         QeNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789461104; x=1790065904;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=srZnYOZh38wMRO1+hbACREA44r35OdzHMy0XMVlEyHw=;
        b=LCr7KtBK37qcJ5tudOMHeDk5WvlwbJhGw57z7pGrJ4bYXzSCr+p/cD3KM21wlrOMuU
         w8rIFMqY32GPmCBpe3m1HXxRox0VoMKx1WtYk7+c+jVCHs1HKL5UYBUvvrEi+SQMDW/f
         RdMtngv8Q3NmH39+0uFClp4yYC3orFkDXDJ1iwFkEvNi6IFI1rNEDQJmq4kYmL2wAj7+
         hlWAyK9WLtj/nubS3eqWwzqXzb6Hgm/Q+0EH/1ihPsTXpAm9WbuVBIBtUQJMvkY13ciM
         EoRvgJzXZuY9hHo5uKQ5lNvfE4m4geqhybqUTk7SqVksthlYEDmV3YXZ5BEWVV5kIGpr
         /Y6A==
X-Forwarded-Encrypted: i=1; AKwUvBxbUR74eLdC9Lrq5yuckccxBhBRf8D/52RhCXhxS1ry0lRpQtb3Gdc1YRwavWgXh+m1pgpBPObmxg==@kvack.org
X-Gm-Message-State: AFuF++kJjPzMm4H3w6BckDQeMHLjJGjytAmWJ8JQ+25DcapsUNQCRXWp
	b8Ms24mtNpaBxuInJhhUNknNtXdGsx0jErikADqEncy4e+WLW8BqVsQWHLbjwa7DujE=
X-Gm-Gg: AYBFou3rGJ4KhqI9Uy5GiiI/5RKKfU0RJYfs7lgwhmOcvgMJvakhjNFzQKaPd9H/AiH
	u2HjYX1cU3l6LMJNX6Omtf/V+oKeH6JVFRa/os8IwFhCiqXfgbokykXwEGLxgeSSDEQAApFViK5
	a8tN5o/r4maVl9z061RMLKjEMo0xrzASUcvUIVDXDudvQyFf9HgRMat64rnFQblLeqbWHGcxp9v
	H6+CmkxOd4OBE1t3TkyLg1HhniDGGEthScF4Zg01CDOikgyBWoW0SJuBnF0nODqPcwDTErDUZe2
	pC83j9PleE9wngb7/W/Cwy+eWV1AabGZVNlPGQHfy16/OyWDCAKTNRrGT6rqRyYRKNFQe+bPiAX
	4vOObB+/cDVmgyWzDZs0TSx8sEOn5g+XauY/0an3ng12Oof8aaOrUQcWLEzJpYogG5654HI6JSc
	nhceFBebYv7KwWlpEwoVZQEzPCcvaHtvOL5gS8cuwQaciEZKKLQgQH3No9lefJ
X-Received: by 2002:a17:907:3f1a:b0:c21:601:6501 with SMTP id a640c23a62f3a-c29b86059e6mr437931366b.20.1789461103956;
        Tue, 15 Sep 2026 01:31:43 -0700 (PDT)
Received: from localhost ([2a02:aa7:4656:2314:c23c:9eda:81d:3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c296613c3ebsm529983366b.57.2026.09.15.01.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 01:31:43 -0700 (PDT)
Date: Tue, 15 Sep 2026 10:31:42 +0200
From: Michal Hocko <mhocko@suse.com>
To: Kyle Meyer <kyle.meyer@hpe.com>
Cc: akpm@linux-foundation.org, corbet@lwn.net, david@redhat.com,
	linmiaohe@huawei.com, shuah@kernel.org, tony.luck@intel.com,
	jane.chu@oracle.com, jiaqiyan@google.com, Liam.Howlett@oracle.com,
	bp@alien8.de, hannes@cmpxchg.org, jack@suse.cz,
	joel.granados@kernel.org, laoar.shao@gmail.com,
	lorenzo.stoakes@oracle.com, mclapinski@google.com,
	nao.horiguchi@gmail.com, osalvador@suse.de,
	rafael.j.wysocki@intel.com, rppt@kernel.org, russ.anderson@hpe.com,
	shawn.fan@intel.com, surenb@google.com, vbabka@suse.cz,
	linux-acpi@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v3] mm/memory-failure: Support disabling soft offline for
 HugeTLB pages
Message-ID: <aqkCbgHmMGxI_GLG@tiehlicka>
References: <aqiIEkrc6aDBOqRg@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqiIEkrc6aDBOqRg@hpe.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8C1F18000D
X-Stat-Signature: 7oeszc5o1uh8oj8e3ie6y86ga8wnm6uq
X-Rspam-User: 
X-HE-Tag: 1789461105-269969
X-HE-Meta: U2FsdGVkX192N855Nl3lz6WHVuzv/x9WYNdXZiEeMpJwxRQM2s7ZavBl/iJrpNjlxNXUJ3jkh4fpPVC8JO8rIZ+JvphmPZOWP8pZVwQGi6PnYKPc7riGoZHozfWCAyIk/Lz3Sftq5dkhUXUIA52uuVaxbWrFJ9xBLOdphrfs2FCSpWOmn7qXaYYKfVJzINE7tmuGPntk8MsZYYvc6P2eMtEndLUR+xHG9akbDOcb9wTI613kWPf+r5vs/8Pytug/HkavVIvRJAIrQKrmIQXnm7+ptJTcu8daf0m4uGS4vDMBoCoCTVAVvo1BQYPjuWP/YSbP1+blo5zU/arBaB2g7wxv8B6bEZRJB3ZVA8EXDHSzFoWHuSs2VBpwngR5Uuo7JIecn2s81CVpiGJ+uaiVomJclAfjVS8w3GU19tBcsZGG8eQPhsfb7jmtpbAS65lXcuoztTyvFtRCjq4SD+BPGycszswDAggxgZQl+nbxqy5PE94NSmrwA08dlifB3Sh4yrDqL0ib729k+EQT7hS+g9Rq1DAdMd7vnRi8j57RvB7XH7cXxaEsuj3Bl1sIkQHl5EpIvOadn/yWlWth3Bb5ImqBivf29bX5CLE1bJrcAGOIAkcCwckVb4Nqhh0gNF5JuClwvsXgGkISbhQ2CixdX2EatK6iVx2ojc6myNemtS7UHm6WbKia853SfwxKGG1Yp8UV9ouVG/rc4B54gVvXvfBb1MvD+oc2dyxmq/TgyS5p4OC/ARITRXrEdFU2vd8E/ILlwzazMbuO60rUigz3OXnUy08nh+AA0VxPbKZWqyRZkIKCN5E4lAtBijIwxK+UJgZvuvkofiZELzGynXcv46u8K8XOumBCjaIAABTJNCXtykcTdRZHwA9cQ+4U9lrCtn7w2eUyywYDgi3LuWxeVU6W+/A6uti5BjnStEBN7fmSGdpIcJJF973RbbD9S1gJ0t35ZIcblsWdUEGS2SB
 WCcqmax0
 ZcDOSH6PqPlr6ii0q3aVlKjRo7Yz8iBrc2a7IHDpPPCE18whwy/UTjMcAANG2ESsYCgu/cKkyIWUE7wMfS1YkEnQUVH7fh4TsJMftq61dQtyD84Dm9uhSdQuwEyMrJEaJYpQkvOE7oSe2Gb0lwTPslx0Tnm72swwXwWxHWCDGPmBwMGLgtlyDSqAPh+ikWcivdpSIc02UhCurwKnkUoTSFbDSnBTosYZRkVOgbBuxOejYcx1uNT3RFL0QIvG109fdbl5aBPlG3q1S1yLuwoa+foCuIqY16ql1gtj61PP8n9j5cADYQmiOkb7BdvaAmtg35Q/iVjE/mg9/eJxzn6gPAXHXgM1AOqwHRKNoSKygBUnjW5XQ74tm06H9IIRYhrpxJ+OINeE9e7vBGHqe3BPPrilAhKLSK+PmOarUrdZ4htlHnAe4JDeXWJnEnpB5i8azqfMAdQEYD3PHsx/LacQHM9/HY36eJ9dzIFaq/j2eMG8nuP6TlTBNpoP7WpGPEecACtmIZl6x8P544/3q9IPhqrv9MHf7A93FiJO8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 14-09-26 18:49:38, Kyle Meyer wrote:
> Soft offlining a HugeTLB page dissolves it, permanently reducing the
> HugeTLB page pool. This can be problematic for workloads that depend on
> a fixed number of HugeTLB pages.
> 
> Currently, soft offline must be disabled to prevent HugeTLB pages from
> being soft offlined.
> 
> This patch allows soft offline to be disabled for HugeTLB pages while
> remaining enabled for non-HugeTLB pages.
> 
> Commit 56374430c5dfc ("mm/memory-failure: userspace controls
> soft-offlining pages") introduced the following sysctl interface to
> control soft offline:
> 
> /proc/sys/vm/enable_soft_offline
> 
> The interface does not distinguish between page types:
> 
>     0 - Soft offline is disabled
>     1 - Soft offline is enabled
> 
> Convert enable_soft_offline to a bitmask and support disabling soft
> offline for HugeTLB pages:
> 
> Bits:
> 
>     0 - Enable soft offline
>     1 - Disable soft offline for HugeTLB pages
> 
> Supported values:
> 
>     0 - Soft offline is disabled
>     1 - Soft offline is enabled
>     3 - Soft offline is enabled (disabled for HugeTLB pages)
> 
> Existing behavior is preserved.
> 
> Update documentation and HugeTLB soft offline selftests.

This is adding a lot of user interfaces to control something you can
disable by config option for an admin only functionality.
I fail to to see any actual justification for all of that. If an admin
can disolve a hugetlb page it has power to allocate a new one as well.
Not to menation that the whole soft offlining is mostly a testing
feature so adding a lot of fine grained configuration space seems
excessive to me.

> Suggested-by: Tony Luck <tony.luck@intel.com>
> Signed-off-by: Kyle Meyer <kyle.meyer@hpe.com>
> ---
> 
> Tony's patch:
> * https://lore.kernel.org/all/20250904155720.22149-1-tony.luck@intel.com
> 
> v1:
> * https://lore.kernel.org/all/aMGkAI3zKlVsO0S2@hpe.com
> 
> v1 -> v2:
> * Make the interface extensible, as suggested by David.
> * Preserve existing behavior, as suggested by Jiaqi and David.
> * https://lore.kernel.org/all/aMiu_Uku6Y5ZbuhM@hpe.com
> 
> v2 -> v3:
> * Minor documentation updates.
> * Use page_folio(page) instead of pfn_folio(pfn) for HugeTLB page check.
> 
> ---
>  .../ABI/testing/sysfs-memory-page-offline     |  3 +++
>  Documentation/admin-guide/sysctl/vm.rst       | 27 +++++++++++++++----
>  mm/memory-failure.c                           | 17 +++++++++---
>  .../selftests/mm/hugetlb-soft-offline.c       | 19 ++++++++++---
>  4 files changed, 54 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/ABI/testing/sysfs-memory-page-offline b/Documentation/ABI/testing/sysfs-memory-page-offline
> index 00f4e35f916f..19aa539fb910 100644
> --- a/Documentation/ABI/testing/sysfs-memory-page-offline
> +++ b/Documentation/ABI/testing/sysfs-memory-page-offline
> @@ -20,6 +20,9 @@ Description:
>  		number, or a error when the offlining failed.  Reading
>  		the file is not allowed.
>  
> +		Soft-offline can be controlled via sysctl:
> +		Documentation/admin-guide/sysctl/vm.rst
> +
>  What:		/sys/devices/system/memory/hard_offline_page
>  Date:		Sep 2009
>  KernelVersion:	2.6.33
> diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
> index 5b318d17aa4b..ee1941e44643 100644
> --- a/Documentation/admin-guide/sysctl/vm.rst
> +++ b/Documentation/admin-guide/sysctl/vm.rst
> @@ -309,16 +309,33 @@ physical memory) vs performance / capacity implications in transparent and
>  HugeTLB cases.
>  
>  For all architectures, enable_soft_offline controls whether to soft offline
> -memory pages.  When set to 1, kernel attempts to soft offline the pages
> -whenever it thinks needed.  When set to 0, kernel returns EOPNOTSUPP to
> -the request to soft offline the pages.  Its default value is 1.
> +memory pages.
>  
> -It is worth mentioning that after setting enable_soft_offline to 0, the
> +enable_soft_offline is a bitmask:
> +
> +Bits::
> +
> +	0 - Enable soft offline
> +	1 - Disable soft offline for HugeTLB pages
> +
> +Supported values::
> +
> +	0 - Soft offline is disabled
> +	1 - Soft offline is enabled
> +	3 - Soft offline is enabled (disabled for HugeTLB pages)
> +
> +The default value is 1.
> +
> +If soft offline is disabled for the requested page type, EOPNOTSUPP is returned.
> +
> +It is worth mentioning that after disabling soft offline, the
>  following requests to soft offline pages will not be performed:
>  
> +- Request to soft offline pages from sysfs.
> +
>  - Request to soft offline pages from RAS Correctable Errors Collector.
>  
> -- On ARM, the request to soft offline pages from GHES driver.
> +- Request to soft offline pages from GHES driver.
>  
>  - On PARISC, the request to soft offline pages from Page Deallocation Table.
>  
> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> index a8b03e2920ba..6c4ce39f46df 100644
> --- a/mm/memory-failure.c
> +++ b/mm/memory-failure.c
> @@ -69,11 +69,14 @@
>  #include "page_alloc.h"
>  #include "internal.h"
>  
> +#define SOFT_OFFLINE_ENABLED		BIT(0)
> +#define SOFT_OFFLINE_SKIP_HUGETLB	BIT(1)
> +
>  static int sysctl_memory_failure_early_kill __read_mostly;
>  
>  static int sysctl_memory_failure_recovery __read_mostly = 1;
>  
> -static int sysctl_enable_soft_offline __read_mostly = 1;
> +static int sysctl_enable_soft_offline __read_mostly = SOFT_OFFLINE_ENABLED;
>  
>  static int sysctl_panic_on_unrecoverable_mf __read_mostly;
>  
> @@ -157,7 +160,7 @@ static const struct ctl_table memory_failure_table[] = {
>  		.mode		= 0644,
>  		.proc_handler	= proc_dointvec_minmax,
>  		.extra1		= SYSCTL_ZERO,
> -		.extra2		= SYSCTL_ONE,
> +		.extra2		= SYSCTL_THREE,
>  	},
>  	{
>  		.procname	= "panic_on_unrecoverable_memory_failure",
> @@ -2982,12 +2985,20 @@ int soft_offline_page(unsigned long pfn, int flags)
>  		return -EIO;
>  	}
>  
> -	if (!sysctl_enable_soft_offline) {
> +	if (!(sysctl_enable_soft_offline & SOFT_OFFLINE_ENABLED)) {
>  		pr_info_once("disabled by /proc/sys/vm/enable_soft_offline\n");
>  		put_ref_page(pfn, flags);
>  		return -EOPNOTSUPP;
>  	}
>  
> +	if (sysctl_enable_soft_offline & SOFT_OFFLINE_SKIP_HUGETLB) {
> +		if (folio_test_hugetlb(page_folio(page))) {
> +			pr_info_once("disabled for HugeTLB pages by /proc/sys/vm/enable_soft_offline\n");
> +			put_ref_page(pfn, flags);
> +			return -EOPNOTSUPP;
> +		}
> +	}
> +
>  	mutex_lock(&mf_mutex);
>  
>  	if (PageHWPoison(page)) {
> diff --git a/tools/testing/selftests/mm/hugetlb-soft-offline.c b/tools/testing/selftests/mm/hugetlb-soft-offline.c
> index bc202e4ed2bd..9837c315a81e 100644
> --- a/tools/testing/selftests/mm/hugetlb-soft-offline.c
> +++ b/tools/testing/selftests/mm/hugetlb-soft-offline.c
> @@ -5,6 +5,8 @@
>   *   offlining failed with EOPNOTSUPP.
>   * - if enable_soft_offline = 1, a hugepage should be dissolved and
>   *   nr_hugepages/free_hugepages should be reduced by 1.
> + * - if enable_soft_offline = 3, HugeTLB pages should stay intact and soft
> + *   offlining failed with EOPNOTSUPP.
>   *
>   * The test allocates 8 default hugepages
>   */
> @@ -31,6 +33,9 @@
>  
>  #define EPREFIX " !!! "
>  
> +#define SOFT_OFFLINE_ENABLED		(1 << 0)
> +#define SOFT_OFFLINE_SKIP_HUGETLB	(1 << 1)
> +
>  static int do_soft_offline(int fd, size_t len, int expect_errno)
>  {
>  	char *filemap = NULL;
> @@ -55,6 +60,7 @@ static int do_soft_offline(int fd, size_t len, int expect_errno)
>  	ksft_print_msg("Allocated %#lx bytes of hugetlb pages\n", len);
>  
>  	hwp_addr = filemap + len / 2;
> +	errno = 0;
>  	ret = madvise(hwp_addr, pagesize, MADV_SOFT_OFFLINE);
>  	ksft_print_msg("MADV_SOFT_OFFLINE %p ret=%d, errno=%d\n",
>  		       hwp_addr, ret, errno);
> @@ -82,7 +88,7 @@ static int set_enable_soft_offline(int value)
>  	char cmd[256] = {0};
>  	FILE *cmdfile = NULL;
>  
> -	if (value != 0 && value != 1)
> +	if (value < 0 || value > 3)
>  		return -EINVAL;
>  
>  	sprintf(cmd, "echo %d > /proc/sys/vm/enable_soft_offline", value);
> @@ -128,13 +134,17 @@ static int create_hugetlbfs_file(struct statfs *file_stat)
>  static void test_soft_offline_common(int enable_soft_offline)
>  {
>  	int fd;
> -	int expect_errno = enable_soft_offline ? 0 : EOPNOTSUPP;
> +	int expect_errno = 0;
>  	struct statfs file_stat;
>  	unsigned long hugepagesize_kb = 0;
>  	unsigned long nr_hugepages_before = 0;
>  	unsigned long nr_hugepages_after = 0;
>  	int ret;
>  
> +	if (!(enable_soft_offline & SOFT_OFFLINE_ENABLED) ||
> +	    (enable_soft_offline & SOFT_OFFLINE_SKIP_HUGETLB))
> +		expect_errno = EOPNOTSUPP;
> +
>  	ksft_print_msg("Test soft-offline when enabled_soft_offline=%d\n",
>  		       enable_soft_offline);
>  
> @@ -165,7 +175,7 @@ static void test_soft_offline_common(int enable_soft_offline)
>  	// No need for the hugetlbfs file from now on.
>  	close(fd);
>  
> -	if (enable_soft_offline) {
> +	if (expect_errno == 0) {
>  		if (nr_hugepages_before != nr_hugepages_after + 1) {
>  			ksft_test_result_fail("MADV_SOFT_OFFLINE should reduced 1 hugepage\n");
>  			return;
> @@ -190,8 +200,9 @@ int main(int argc, char **argv)
>  	if (!hugetlb_setup_default(8))
>  		ksft_exit_skip("not enough hugetlb pages\n");
>  
> -	ksft_set_plan(2);
> +	ksft_set_plan(3);
>  
> +	test_soft_offline_common(3);
>  	test_soft_offline_common(1);
>  	test_soft_offline_common(0);
>  
> -- 
> 2.51.0

-- 
Michal Hocko
SUSE Labs

