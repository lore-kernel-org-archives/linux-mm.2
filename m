Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9978FD68BD5
	for <linux-mm@archiver.kernel.org>; Sun, 21 Dec 2025 07:06:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7245B6B0005; Sun, 21 Dec 2025 02:06:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A7C46B0089; Sun, 21 Dec 2025 02:06:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B3D26B008A; Sun, 21 Dec 2025 02:06:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 47AE56B0005
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 02:06:39 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AEABC137B46
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 07:06:38 +0000 (UTC)
X-FDA: 84242595276.09.CB7300E
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf10.hostedemail.com (Postfix) with ESMTP id 84F3FC000D
	for <linux-mm@kvack.org>; Sun, 21 Dec 2025 07:06:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=whwXMOqm;
	spf=pass (imf10.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766300797; a=rsa-sha256;
	cv=none;
	b=FZkZw8QmUKXkX4hYnYlOGlkFaYgiiE0QAT0rm22i3OBYQkl7qGTwYcW/t7+eHNIWCgJYAk
	gyEzfnBKgqOCG+YTlwsTwZa4Vjd7GM6ki77ZZ60JY5bKIEYj9/wGOl3ygTc4dDqrSA1LyU
	7MJ7cZiuEwK5dVNNzxkCmS1ogFqWt/A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=whwXMOqm;
	spf=pass (imf10.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766300796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RmEN7vH12uI1Rs0ygY9rWAV48Uxs0YhB3UwvPw+ZrNY=;
	b=W9wChKhWyKEAEgEcFE6M0eVfYNih5E4O+WzgPgLsbrEc6JDvc6QVTMLx1ysPhCKRz+vmHL
	f4SdFTu0djnrT6NdBo4mspzYGmqhSNx6yo9vuDjL290f2eC42UV3h24ATsjWO3aBOxnBOc
	NwR6BIkr3yC2MyJAlp92/kemkyWvLZo=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1766300792; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=RmEN7vH12uI1Rs0ygY9rWAV48Uxs0YhB3UwvPw+ZrNY=;
	b=whwXMOqmdAkkvynzDOqPcY0z3fcDMkq1oI6/X3UvROOzh9abCcq7/7pcXGGrGs4JWM4l0UMuXyNQHSMJzjFi/EyUYaJypvbQ5fL03Tw0BRt2p9Bvasx89Zp1VMEo1F2MOB83XJWLML/w5tT7hwFg6HA+xQg6lp7M0SM9NuMc81g=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WvICCii_1766300788 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sun, 21 Dec 2025 15:06:30 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Jinjiang Tu <tujinjiang@huawei.com>
Cc: <akpm@linux-foundation.org>,  <david@kernel.org>,  <ziy@nvidia.com>,
  <matthew.brost@intel.com>,  <joshua.hahnjy@gmail.com>,
  <rakie.kim@sk.com>,  <byungchul@sk.com>,  <gourry@gourry.net>,
  <apopple@nvidia.com>,  <mgorman@suse.de>,  <linux-mm@kvack.org>,
  <wangkefeng.wang@huawei.com>
Subject: Re: [PATCH] mm/mempolicy: fix mpol_rebind_nodemask() for
 MPOL_F_NUMA_BALANCING
In-Reply-To: <20251213082911.1509735-1-tujinjiang@huawei.com> (Jinjiang Tu's
	message of "Sat, 13 Dec 2025 16:29:11 +0800")
References: <20251213082911.1509735-1-tujinjiang@huawei.com>
Date: Sun, 21 Dec 2025 15:06:27 +0800
Message-ID: <87pl889uvg.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Rspamd-Queue-Id: 84F3FC000D
X-Rspamd-Server: rspam04
X-Stat-Signature: 3ri57w454mo3k1sganckphjyqgawtgc8
X-HE-Tag: 1766300795-975529
X-HE-Meta: U2FsdGVkX1/jua4z2sa7awnoXu95bZS7Hx/S8kGYyQ2OajylF/Epox8QkZguN8ygq7KUIQWtR9kok/FAEDrmTTeSsrLKPRU6bBcAoVtjWBQXKvFwRyOUH6kmyg9/qnPOm4h2lO8vo53lMglCoqnJirHOiGnjUfKgZZc+nCiPsbSmD/0X7mmb1aQAB53zfT7Bpo2EXz+HzM45qEhpVUQA5Xi6UIhdEoE9Z1kHN7IhjaAEbK0PzVbkaz2Q3vpw7Aw2hcK+bklVrDAk+SsK+AtvKYkGuJdrwaM2inR237r2coKn6xYytl2mC0uSck6RjYTvSJjupdXkSR7IxlCH3JSspRlBbV6nqWkkaWv0fx6fWE/KM89Oi7XAn8M5VxVJPduKevCQ6O/5sI1JDhKEWjCq6cQLVy52/ujlYb58oCijs3NwchqklAGEE1WTzT+o0aJ+sxh6IBiejms0SIinaiglVukCrdOTRJ6YG5JRcvhd34PDQYYBcZfpqGAYnPGhDfFdr0nntK0ZYe8iGGSDno+OazBJq3G46tOVzxfORXJKqVOH/IhxzRs8SxEZfPewmpYkzy1QwRDuZO4Qfd6VczYsu+PSn3COOOSJitZNku6ouwhoIX03uxyCW957Qe3VKqeZx+hh6At2hMO1CikvM5Dxvq1LlScjQcV4BXYKKQDvemu/uDCN22KC5OW5U/fpptCZmeAoUQ2HjuaiHkWPOB/1N/TNubqXAa+LvA+R+gmRN8OLHCyfUzbZZLbkmttSgyCBpZ3YetG8dr3l7aNIKkOqjvvVm+G7k4BHtz/LV3esVye2tUctrf+0wTGiFPDtXW4L93+ODhJqqzpOk8qJewDN20zoBXMl4UUKdfm8em9147x5QQG8q6NA6X1nL67DzDinkCoel/b5i+Wev4MYTNtlYdbdoQl3X5b7JpdGPX6QiWo9Lnafe208lY/vKa4+gXkya4+eWDDZZ2khNUIiUcX
 mYWY5tTO
 u7pkWWhoCkIQnfBWETR0rDqhSEYOiWipPn5sa8jINUol2VA+ikILSZguxfVvdzWN7P3tCXM0avdn48BMqpVQAElgsV84l06w0gEms7gs5teTW/MXB0VwY2xIRhGTEfkA4MPEhc7kpSgzyHU2bSSZolLkosbsJQhirI8Yzo9nwSU6hKryrkVHLMy9PBQawye9EYeYejCXtVtavlre+dvojG8IWfOFllKdEH4K95V6iSMoZMSXu+ptsMVJ7zWQnuIHKLQU6V7QJkBuy6UHpqiBj08DFrThMRk5ZNZTUurOfBLnXsHt01f6akVun1G1zlsrEx2ONRxaCyM+k1zXCE6mvHj8b+viDzJRUOIATVvA3Bau7k3nuGEPlezJvL0/IhR63wcrP232fVRRvadS3TCQZpHdkFfeXbQokxTkj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi, Jinjiang,

Jinjiang Tu <tujinjiang@huawei.com> writes:

> When mempolicy is rebound due to the process moves to a different cpuset
> context, or the set of nodes allowed by current cpuset context changes,
> mpol_rebind_nodemask() remaps the nodemask according to the old and new
> cpuset_mems_allowed by default. So, use mempolicy.w.cpuset_mems_allowed
> to store the old nodemask allowed by cpuset.
>
> MPOL_F_STATIC_NODES suppresses the node remap and intersects the user's
> passed nodemask and nodes allowed by new cpuset context.
> For MPOL_F_RELATIVE_NODES, the user's passed nodemask means node IDs that
> are relative to the set of node IDs allowed by the process's current
> cpuset. So, use mempolicy.w.user_nodemask to store the user's passed
> nodemask.
>
> commit bda420b98505 ("numa balancing: migrate on fault among multiple
> bound nodes") adds new flag MPOL_F_NUMA_BALANCING to enable NUMA balancing
> for MPOL_BIND, the behaviour of rebinding should be same with default
> befaviour. However, mpol_store_user_nodemask() returns true for
> MPOL_F_NUMA_BALANCING, leading to mempolicy.w.cpuset_mems_allowed stores
> the user's passed nodemask instead of cpuset_current_mems_allowed, and
> mpol_rebind_nodemask() remaps wrongly.

Good catch!  Thanks for fixing this.

> Fixes: bda420b98505 ("numa balancing: migrate on fault among multiple bound nodes")
> Signed-off-by: Jinjiang Tu <tujinjiang@huawei.com>
> ---
>  include/uapi/linux/mempolicy.h | 6 ++++++
>  mm/mempolicy.c                 | 2 +-
>  2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/include/uapi/linux/mempolicy.h b/include/uapi/linux/mempolicy.h
> index 8fbbe613611a..1802b6c89603 100644
> --- a/include/uapi/linux/mempolicy.h
> +++ b/include/uapi/linux/mempolicy.h
> @@ -39,6 +39,12 @@ enum {
>  #define MPOL_MODE_FLAGS							\
>  	(MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES | MPOL_F_NUMA_BALANCING)
>  
> +/*
> + * MPOL_USER_NODEMASK_FLAGS is used to determine if nodemask passed by
> + * users should be used in mpol_rebind_nodemask().
> + */

This sounds a little internal in a user API header file.  How about
something like below.

/* Whether is a nodemask specified by user */

> +#define MPOL_USER_NODEMASK_FLAGS (MPOL_F_STATIC_NODES | MPOL_F_RELATIVE_NODES)
> +
>  /* Flags for get_mempolicy */
>  #define MPOL_F_NODE	(1<<0)	/* return next IL mode instead of node mask */
>  #define MPOL_F_ADDR	(1<<1)	/* look up vma using address */
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 68a98ba57882..76da50425712 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -365,7 +365,7 @@ static const struct mempolicy_operations {
>  
>  static inline int mpol_store_user_nodemask(const struct mempolicy *pol)
>  {
> -	return pol->flags & MPOL_MODE_FLAGS;
> +	return pol->flags & MPOL_USER_NODEMASK_FLAGS;
>  }
>  
>  static void mpol_relative_nodemask(nodemask_t *ret, const nodemask_t *orig,

---
Best Regards,
Huang, Ying

