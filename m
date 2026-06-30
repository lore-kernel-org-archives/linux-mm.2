Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0243C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:44:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAD406B00CC; Tue, 30 Jun 2026 06:44:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5E396B00CD; Tue, 30 Jun 2026 06:44:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FDF46B00CE; Tue, 30 Jun 2026 06:44:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 585856B00CC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:44:57 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE0A91A042D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:44:56 +0000 (UTC)
X-FDA: 84936246192.24.31182B6
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf30.hostedemail.com (Postfix) with ESMTP id 00FC880009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:44:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XHYswoBS;
	spf=pass (imf30.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782816295;
	b=qqFrIEJBq1nNpTCUzX0oOEEj1MmLlOCzpm0xPcocc/4SgenlNhou9bJSfLLCEPfzG2n+To
	N4/MtQM1H9bAir/4Xz2EunH6ILVVrTPd0aFjzX6g9wIeMHZEYa6+UQY93Rfjj5KVKuMWqc
	Q908lRgaIntu903AhhFTJdYVJgXkeMU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782816295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pLRS7nAqGz48MGg7TIU1nka9vUVrVauvgr4FneekIG0=;
	b=F3n3IPZMKYGgGE2g/4fUvtXPB6yYw1qFOQoFstCs56C76cbRwc1HinRCJ8ZhFlnnRh/E9C
	0hjGxPZijBWF/Gnw14neUa8WhHg9Yd834UQshz6wzYEzxiVy8D/EIunAHHEhY0BQOHGUM9
	s5YkgAz4vW1L3Zb2rDE7SsI7lwvo+zE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XHYswoBS;
	spf=pass (imf30.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <eb3a62d5-5fff-4da5-a211-860ef0d4aec2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782816292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pLRS7nAqGz48MGg7TIU1nka9vUVrVauvgr4FneekIG0=;
	b=XHYswoBSXYGhbmC1LEOvVbk31oj5YII1IAkDH1/MNafvK9SSO+2C3YK+RXrk58DYfS0Qqk
	/hV+o5FnPxzg+bukyKwurLyVJoggsDPxUfLg5OtO2GvxzyvipgtJydSRyPut3qdySn74/z
	f+OCW7UiVu659VzjphMQfSqJgWb0NcA=
Date: Tue, 30 Jun 2026 18:44:28 +0800
MIME-Version: 1.0
Subject: Re: [PATCH] mm: memcg: reset zswap settings in css_reset
To: linux-mm@kvack.org
Cc: Jiayuan Chen <jiayuan.chen@shopee.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260630100832.107062-1-jiayuan.chen@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20260630100832.107062-1-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 00FC880009
X-Stat-Signature: qfm15pqr8nnzz9jjprnqtn537kfffpuk
X-HE-Tag: 1782816294-328992
X-HE-Meta: U2FsdGVkX1/kCer6yqe/Ew3v/PJKxU6uOB6QixoBcrfv5GVFRxgmcebKvyErNPRGkcXKLRtwqwRKyCjd2LDeATxBiUc7knOmRV7eHxYTvY1I5YgiHOrDXD8QJsvSJ7kMBO7KObzlHqZkXalF0ULmBMNYOnurH/lfh2Y1M0bSielBfNRuzT24MzKANlBqgiRLA8YDLMK0pviBi5NjHBI8OcbHo/myO+Qrepy4/0O+WKuVFvyCU4e+P4CyKpm/beVTbn0xxZjbHMnIrv0H/GBOnFCIb6MT5csxR572EbBymAC1ZMMvO+uPcAWe6gZTBtLlWBbE5nJHO6nuKYb4dTyv7vlqL0zso0dD+Gju8fyN4AFUR3biHH1vlAGOihVkIXLE2sOefufaFkb+eOzev74Rlo4NWtpOw3ykAjIISEc/up5lphK5v6g/rgT9lK5amHfB8Ug0NbZU9a4+WkhIlPsKu50djADlAlhgcmsVmsECwdCiYbO3VyGziSSe+zf2bnCG56sQB0kvktQDrQWTk2jFHTwPssSHEITdf12s8n6JJctnD5ilgtRhwyykutArJY+UYscpDdKtcFxXfsYqX75HddKYoM0hnqRNh3Zk8WwL+pO9hhBOU4bMOhIKI4rjPrD8n2YgOxbWt8g9CMNicUnDoji5KuNWpvoCDLkTVRZ9i8amuwU5D0RyRRXs1IpPSsxaCsWpS35b/3qhLX70+tbUTkAOcyDl3PeXHorlkNXvcQHcaF1y7upgm1xATnmv8IH8jXEyw6WDTFB9O4ut8mf9iqHxb2LXRbqNDa5GjlzF1SCUaW5JcBVhwW2vJMefZQTYHpG473wwqQ3JV+9JxixHZrDaFuwIpofOcn5do1sW0eRsEhUQ3AJh237dKkJaBP0g4L7as3LUMKmkmXmBGdfntfgqOaUrwUlQpuxlXS1pUTZN18CWi60hddnQLONKcw4M72pwzy9e6DvRIIgqqlg
 vAlFpRme
 kIsBt0MkHja18GQNKYgMgBZ4CXNuyU1rIrPQorxv5WXyi9QV3LcOam/HDt3euttT4HRL4iK+QaeyN4CuKKDW8ilB2dEyLmq46gBeWPG88UWGzCr7+H6lhd1BGgB6QSD/SRzjxN08Tfv86fnyduSXrb9G+yPZ4aVKkOL1OCFYg+0TR/h+johL6EDCwqLqwcF3BkHznfYlYSjtZAyWhx0vF4K/DiCpODoVfi//CP9PxvD9R+NVsjlsfXhMvLrlJg01zHWe3QYkHFmdUWNoFVuEPdjC+UW8QjETGZcYU652w4Ib+XIChb3Z1lWif4BMdMa0O0lUWCmqK9k33vZQryTskYMseliAvStljhnJdetznaL96jCqOKtZ+c/sHUOcpW6xP0S3jxx2QOOQtmgqQaUZeOX9Epw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 6/30/26 6:08 PM, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
>
> mem_cgroup_css_reset() is called when the memory controller is disabled
> on a cgroup but the memcg cannot be destroyed because it is pinned by a
> subsystem dependency -- for example, the io controller declares
> .depends_on = 1 << memory_cgrp_id, so memory remains in the cgroup_ss_mask
> and the css is hidden rather than killed.
>
> The purpose of css_reset is to revert the memcg to its vanilla state so
> that no policies are applied and the css can be safely made visible again
> later.  Currently, all page counters (memory.max, swap.max, kmem.max,
> tcpmem.max) and other limits (soft_limit, memory.high, swap.high) are
> reset to their defaults, but zswap_max and zswap_writeback are not.
>
> These fields are initialized in css_alloc (zswap_max = PAGE_COUNTER_MAX,
> zswap_writeback inherited from parent) but were missing from css_reset.
> As a result, stale zswap policies remain in effect after css_reset: the
> zswap charge path (obj_cgroup_may_zswap) continues to enforce the old
> zswap_max limit, and the writeback path continues to honor the old
> zswap_writeback setting, even though the memory controller has been
> "disabled" on this cgroup.
>
> Reset zswap_max to PAGE_COUNTER_MAX and zswap_writeback to true, matching
> their defaults in css_alloc.
>
> Test:
> 	echo "+memory +io" > /sys/fs/cgroup/cgroup.subtree_control
>
> 	mkdir /sys/fs/cgroup/test
> 	mkdir /sys/fs/cgroup/test/child
>
> 	echo "+memory +io" > /sys/fs/cgroup/test/cgroup.subtree_control
> 	echo 10000 > /sys/fs/cgroup/test/child/memory.zswap.max
>
> 	# child/memory.swap.max and child/memory.zswam.max disappear
> 	echo "-memory" > /sys/fs/cgroup/test/cgroup.subtree_control
>
> 	# re-enable memory control
> 	echo "+memory" > /sys/fs/cgroup/test/cgroup.subtree_control
>
> 	# before this patch
> 	cat /sys/fs/cgroup/test/child/memory.zswap.max
> 	    8192
>
> 	# after this patch, same as memory.swap.max
> 	cat /sys/fs/cgroup/test/child/memory.zswap.max
> 	    max
>
> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> ---
>   mm/memcontrol.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index d20ffc827306..eeeb22a5e8cc 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4362,6 +4362,10 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
>   
>   	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
>   	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
> +#ifdef CONFIG_ZSWAP
> +	memcg->zswap_max = PAGE_COUNTER_MAX;
> +	WRITE_ONCE(memcg->zswap_writeback, true);
> +#endif
>   #ifdef CONFIG_MEMCG_V1
>   	page_counter_set_max(&memcg->kmem, PAGE_COUNTER_MAX);
>   	page_counter_set_max(&memcg->tcpmem, PAGE_COUNTER_MAX);


https://sashiko.dev/#/patchset/20260630100832.107062-1-jiayuan.chen%40linux.dev

Ai is right...


Also I'm thinking that should we add a helper instead of using open code 
in css_alloc and  css_reset ?


static void memcg_zswap_reset(struct mem_cgroup *memcg)
{
#ifdef CONFIG_ZSWAP
     WRITE_ONCE(memcg->zswap_max, PAGE_COUNTER_MAX);
     WRITE_ONCE(memcg->zswap_writeback, true);
#endif
}

mem_cgroup_css_reset()
{
...
memcg_zswap_reset()
...
}

mem_cgroup_css_alloc()
{
...
memcg_zswap_reset()
...

}




