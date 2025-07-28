Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91537C87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 01:44:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABCFA6B007B; Sun, 27 Jul 2025 21:44:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6E7E6B0088; Sun, 27 Jul 2025 21:44:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB276B0089; Sun, 27 Jul 2025 21:44:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E2AE6B007B
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 21:44:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AFD0B142042
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 01:44:16 +0000 (UTC)
X-FDA: 83711978112.13.165AE3B
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf25.hostedemail.com (Postfix) with ESMTP id 323EFA0003
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 01:44:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xPOCyhAn;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753667054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06xZ+bJju6hr8mDQ5HFTV8f7N7lQsAGxfNBuRYPHHVo=;
	b=ZjFA/azzb9CX4Uaj0/GXvHKNUK3DAWiKrF6MzS+WIhIOZTX0UQa8z9WMBpXXe3pdiHCZyy
	Kwiwcmxfi5cRHLauA7Kf8zzSlM37CBkP5SG9cTLuZCoE6SsPyhx0jvYojA6jzGvDXoAxSp
	O9dKsSHV1U7Dmvq2H7v0OlR+Eu+S6zw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753667054; a=rsa-sha256;
	cv=none;
	b=wM1rFS9IbVfbmo+NvseENmla48d78dSU2qXwiOIaGIO3ot3znylJARQ2iTPWV2IuQynOP6
	r1FixprJTSyKNpHKqq7Q2nxVsR81PmMN9hu1q1oxUtXKNDHzjkl5DbiC/+LU92G2btYQzg
	HWplKGhflelo2YuiTUDjoV9feE+WwoM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=xPOCyhAn;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf25.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753667050; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=06xZ+bJju6hr8mDQ5HFTV8f7N7lQsAGxfNBuRYPHHVo=;
	b=xPOCyhAnMTWwraPRn4aoaMdYGF1miD/gkCul6b9m9PT1sOOHisbrUZ5K0v7HagF9PrQIm6omTVi46H0azuPP96IUBdGZzqBWrhQ0bKGxJSgyF4E5v3GkAYYNnN50tiDwBSXYZgaiaKqG+UmejEH7oesy8KOhO3CDukuP/cF1KQc=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WkBGr5i_1753667048 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 28 Jul 2025 09:44:08 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@redhat.com>,  Johannes Weiner <hannes@cmpxchg.org>,  Zi Yan
 <ziy@nvidia.com>,  Matthew Brost <matthew.brost@intel.com>,  Rakie Kim
 <rakie.kim@sk.com>,  Byungchul Park <byungchul@sk.com>,  Gregory Price
 <gourry@gourry.net>,  Alistair Popple <apopple@nvidia.com>,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org,  kernel-team@meta.com
Subject: Re: [PATCH] mempolicy: Clarify what RECLAIM_ZONE means
In-Reply-To: <20250725173546.2295177-1-joshua.hahnjy@gmail.com> (Joshua Hahn's
	message of "Fri, 25 Jul 2025 10:35:45 -0700")
References: <20250725173546.2295177-1-joshua.hahnjy@gmail.com>
Date: Mon, 28 Jul 2025 09:44:06 +0800
Message-ID: <87ms8p2iop.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspamd-Queue-Id: 323EFA0003
X-Stat-Signature: 3nz8gxrc5rskjwpeb19i4iog1qfg6zt8
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753667052-606180
X-HE-Meta: U2FsdGVkX1+ZHPxd+EcuJiqMSDk5D90fRtFIRskjYzGW1aoHOgvejQrWkZQF8n9FYLHKgH6Ujs4T4ETntEKyx7hX+Sw/QBSYVrty/lU8jUCC5yDMOx0g9Qt22ZxV8J2RjFnUHqo8M520VtcRDQ5ugfz/SGI464VAnOB6+YLJQy0hmikwXmqloqERaB0kHZ9KBhLAJCFdtEzz+UAA8wJ3jVKhyn/DqvssFiEUFASwXoo2FMIwczyYgL10tCozLo0c+2MUGY/Q2EPAqjuoGwSxTHoKa6aDW/zk3d+yOXDkH7G89xzTtqyvzZdIBbWMbXiC/J7eVxc1qL1CH0eRRU5vhhcHlYW7cffpkqm1PCWc364WgNzfkRxzNtIBxmh/OWj7Rwmo43x6h1Q1ZaNlrAUnbHFg6hTr7CUv++YbBzsQFzjcqNcr817monrF+85A9szHAuk/OApQIYZ7yvLfOFsVvQlLbcyb46e08YgwpWC5iXtSbk9GMoO3cFsf8rb0S4/NjqpW7wSD8FO9GzSCXJN3SDfL85/R8y/rG51SL4uHiSnDwkECYFdimXGQ+kncGn7/SCGyIkqrwTJwNVr7T/i7cD+eQLz0gy3/YFulu6sRUY8m2UdXphhSPHwSYiCsLfJZZW+TtpjzYWu21tpkxUSDILtivDVfnS4/l4e9pO7HCUKQ1/sP+yoy6CXOU6rQpaf2+flRC1Izbfeto8SSHJid/apBvBunW+hAPfjZqmRbtJLJh096PdDQKqvYGys4iiCIJXau82jI9drWAnSJNosOtsDn/xdR7BtA9cd4Yui3emnj5bUIHg72yLxcZLrqg08DLxffaK1LO/XoK+nN4vtwRHdcExSIGYs7DX++UzE8PHnTbpym3VS4R4QQld+SEQOZSe4nwwVqA3FI1iQYoDQxBus0DTLDShYUKyNt3hrAfbwrYamaoFqXyR5RkqPpnOiJvkwjv6fXqZB7HX/6SaH
 29xBQ6J2
 7v4AoXSQvy2Rh+D0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Joshua,

Joshua Hahn <joshua.hahnjy@gmail.com> writes:

> The zone_reclaim_mode API controls reclaim behavior when a node runs out of
> memory. Contrary to its user-facing name, it is internally referred to as
> "node_reclaim_mode". This is slightly confusing but there is not much we can
> do given that it has already been exposed to userspace (since at least 2.6).
>
> However, what we can do is to make sure the internal description of what the
> bits inside zone_reclaim_mode aligns with what it does in practice.
> Setting RECLAIM_ZONE does indeed run shrink_inactive_list, but a more holistic
> description would be to explain that zone reclaim modulates whether page
> allocation (and khugepaged collapsing) prefers reclaiming & attempting to
> allocate locally or should fall back to the next node in the zonelist.
>
> Change the description to clarify what zone reclaim entails.
>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---
>  include/uapi/linux/mempolicy.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
> index 1f9bb10d1a47..24083809d920 100644
> --- a/include/uapi/linux/mempolicy.h
> +++ b/include/uapi/linux/mempolicy.h
> @@ -69,7 +69,7 @@ enum {
>   * These bit locations are exposed in the vm.zone_reclaim_mode sysctl
>   * ABI.  New bits are OK, but existing bits can never change.
>   */
> -#define RECLAIM_ZONE	(1<<0)	/* Run shrink_inactive_list on the zone */
> +#define RECLAIM_ZONE	(1<<0)	/* Prefer reclaiming & allocating locally */
>  #define RECLAIM_WRITE	(1<<1)	/* Writeout pages during reclaim */
>  #define RECLAIM_UNMAP	(1<<2)	/* Unmap pages during reclaim */
>  
>
> base-commit: 25fae0b93d1d7ddb25958bcb90c3c0e5e0e202bd

Please consider the document of zone_reclaim_mode in
Documentation/admin-guide/sysctl/vm.rst too.

And, IIUC, RECLAIM_ZONE doesn't mean "locally" exactly.  It's legal to
bind to some node other than "local node".

---
Best Regards,
Huang, Ying

