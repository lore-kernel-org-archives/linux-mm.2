Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0261AF513F4
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 06:08:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9BEE6B0005; Fri,  6 Mar 2026 01:08:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D49926B0089; Fri,  6 Mar 2026 01:08:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55F76B008A; Fri,  6 Mar 2026 01:08:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AF6F46B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 01:08:03 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D628958C02
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:08:02 +0000 (UTC)
X-FDA: 84514607604.05.D6702FD
Received: from out30-101.freemail.mail.aliyun.com (out30-101.freemail.mail.aliyun.com [115.124.30.101])
	by imf19.hostedemail.com (Postfix) with ESMTP id 03BDF1A0002
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:07:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uA0yZc1M;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772777280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QyUsGtGIS/Bny0j3Jrlu7OIiSZdRmYRZ1aQvboXUosI=;
	b=fXKcm5xqJqZh0kWk29UTNnJ3K+bLnHMQqMcSJ5Wqb8BV+JoONmGHiShjokq9eQ3DQycoRm
	IAIJYa6WkFBFuQcTkJxHhHFytOIYWevsGHX4lvzkyMEfYYp1AEhKsbqeLNmbzs9bXcQy9N
	8N0Dx9M7rtZeKgOTt6iKr3lyIlF6RQ8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uA0yZc1M;
	spf=pass (imf19.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.101 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772777280; a=rsa-sha256;
	cv=none;
	b=pkT0XWITD9cQWiiKGiihLHsA2HRvgaYxOa6Anqz89SH59igcI5iLKn1LuSgvwIH0/SRPsS
	mlVF6wx1w8J4bHiIW4anryOH+MH5rIsNG99qBpHya5bDwkb1Yt0GD5W0wXbtEpUtsDpjvr
	gLo22Ke48bthJCv3ZgsrTp/oAE+CrX0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1772777275; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=QyUsGtGIS/Bny0j3Jrlu7OIiSZdRmYRZ1aQvboXUosI=;
	b=uA0yZc1Mw1yMg1SV2lXq1Rklp1adyJBiB9aa2OplyXDOaZZf1at2H0o39LdGt9ahHHl/MTxkRWn9i+uIAKNZViJ0ezUJg6rVeVOLJr68fLza9/do/ZTz8jOt5X/wwwSMFuFKbVkt5ksdJ13Xu9bxZwAiRY090/TbOGfcayEli1g=
Received: from 30.74.144.109(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X-MLDCR_1772777271 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Mar 2026 14:07:52 +0800
Message-ID: <8b238664-4375-413c-a8cc-105d98430362@linux.alibaba.com>
Date: Fri, 6 Mar 2026 14:07:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm: huge_memory: refactor anon_enabled_store()
 with change_anon_orders()
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, usamaarif642@gmail.com,
 kas@kernel.org, kernel-team@meta.com
References: <20260305-thp_logs-v2-0-96b3ad795894@debian.org>
 <20260305-thp_logs-v2-2-96b3ad795894@debian.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260305-thp_logs-v2-2-96b3ad795894@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 03BDF1A0002
X-Stat-Signature: 9gh3z68nee48n3ftkyp8bfiqp5d8h3zg
X-Rspam-User: 
X-HE-Tag: 1772777279-521617
X-HE-Meta: U2FsdGVkX1+PjqIiKUgJB3yXdDWoLJEGPg+98T6wqjcem/pS7qBN8SjF/qZi1h9ILQUGiLKKD8gmKrrrLP6ZvG0ggkG5/RgLuvycL3SDZRSQhiwbTS7KOtaRz+QqUEzexANoNjy41ZAj/p3mQvzR3tlxRBsip2peIgsYb52GvZsaq3GNir9J+X9B2xLncsuTz3Co1kan2FKvHmUk4QZF3phItDOdrqw4LDrVkBANFsJYrNgai3pB3XJu+lbb9uZv0I3J3kVY2GzN5Lm2xF2TmK4s4VkGtlUsA8evXsA+esRvoflRf+eUBrC0nD52B9G8+B899NGWutYUg+lTm2qCWHVcBaV6xuREvy+viyM8cGNjguLh+PxOSDNL0WuyBroWmm4oCokC+09FIVnMsyZhwu+9XZgAccEz800Xqsc7joL9qZxqWEa8yEzf3CsPmlcA3yoijpM0MzI3ycnQ7gP8flvzAl8kEISgucHfOjUUA0C7dJt9ZIlyCyS64xGk0IitbQsZSGOwZJiAQmjt3qn3gz0H9XnOkAryZtWPmSwvl1/5woV4u1wS7MfeJKU5NiMBQcNwEwps7T0wb1zNU4+9k460F1t76sarI1/+uapj/bXmd75i4CPhW54Zdpw2A6PzzflvmdBInZOTWDIIR/2kDQtNyjg9J3eFmNbFhhnWE9qPFIOCwLgtvpimEMJTAe+2LMIVdT4z9YRId4e81kpF0AIHzVpX0mjdeu1Hkz17TBKZ36SMRlJY00TLrlhvoYyrpU8izAukd30YW/VPztfbTxojXOZZDLGbyAtbndWrxQGb4iVdm2JDGkP83EQgdL0x1kOSTvs7+5QphLLnw14+unCpsG2zUVG6diTAKhr1+iV3FwcytrLuMMw/q0HNQonPE64CVtfV7XeZzLN1y1bXrbwfP1xWLK+C1uoiFKBbW7WZluA/DcZY/Q6WzzomcMuZ6C1u6J5G/KvbRErfh3p
 0jBs0/LG
 97hBRz2G6hXA7QCmpNt7RgEjTkfQX0fBT6J6D4cRGTaua/BzQW6FquBU4pF6EEHzvreajrOfGfA5FeT6wu7upRsniwFb0omTRKVIHaqHtvauFysHcNFCwRnIhNsZBgdJjXkLPATP9Kcq7cn6gOYjyBzjH3SHrt1OjOmA4TagVy7dnsTGI5KlOFUQ0U1dhoclTF2vAmm96H7+/2EfxwNPWtiQP7Or/dJ60MIBazCZIYJtw9aOguOkLgnq/J1HaTPDIOzTea1TbXldnXIlYhas2ILOwWPiHVJ2w89aOtDwCopAKiMhqiWymK1ML8SibuCzrcbgBACsJYyBcj79K1kGhsDolti0qlbJLSbpM+uwrbNezWg98SvXBu8QcYN5xeXzl8yrZUkp2vFLZH9lfaoGZXSY15qKnbxbQVGU3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/5/26 10:04 PM, Breno Leitao wrote:
> Consolidate the repeated spin_lock/set_bit/clear_bit pattern in
> anon_enabled_store() into a new change_anon_orders() helper that
> loops over an orders[] array, setting the bit for the selected mode
> and clearing the others.
> 
> Introduce enum enabled_mode and enabled_mode_strings[] to be shared
> with enabled_store() in a subsequent patch.
> 
> Use sysfs_match_string() with the enabled_mode_strings[] table to
> replace the if/else chain of sysfs_streq() calls.
> 
> The helper uses test_and_set_bit()/test_and_clear_bit() to track
> whether the state actually changed, so start_stop_khugepaged() is
> only called when needed. When the mode is unchanged,
> set_recommended_min_free_kbytes() is called directly to preserve
> the watermark recalculation behavior of the original code.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>   mm/huge_memory.c | 84 +++++++++++++++++++++++++++++++++++---------------------
>   1 file changed, 52 insertions(+), 32 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 8e2746ea74adf..19619213f54d1 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -316,6 +316,20 @@ static ssize_t enabled_show(struct kobject *kobj,
>   	return sysfs_emit(buf, "%s\n", output);
>   }
>   
> +enum enabled_mode {
> +	ENABLED_ALWAYS,
> +	ENABLED_MADVISE,
> +	ENABLED_INHERIT,
> +	ENABLED_NEVER,
> +};
> +
> +static const char * const enabled_mode_strings[] = {
> +	[ENABLED_ALWAYS]	= "always",
> +	[ENABLED_MADVISE]	= "madvise",
> +	[ENABLED_INHERIT]	= "inherit",
> +	[ENABLED_NEVER]		= "never",
> +};
> +
>   static ssize_t enabled_store(struct kobject *kobj,
>   			     struct kobj_attribute *attr,
>   			     const char *buf, size_t count)
> @@ -515,48 +529,54 @@ static ssize_t anon_enabled_show(struct kobject *kobj,
>   	return sysfs_emit(buf, "%s\n", output);
>   }
>   
> +static bool change_anon_orders(int order, enum enabled_mode mode)
> +{
> +	static unsigned long *orders[] = {
> +		&huge_anon_orders_always,
> +		&huge_anon_orders_madvise,
> +		&huge_anon_orders_inherit,
> +	};
> +	bool changed = false;
> +	int i;
> +
> +	spin_lock(&huge_anon_orders_lock);
> +	for (i = 0; i < ARRAY_SIZE(orders); i++) {
> +		if (i == mode)
> +			changed |= !test_and_set_bit(order, orders[i]);
> +		else
> +			changed |= test_and_clear_bit(order, orders[i]);
> +	}
> +	spin_unlock(&huge_anon_orders_lock);
> +
> +	return changed;
> +}
> +
>   static ssize_t anon_enabled_store(struct kobject *kobj,
>   				  struct kobj_attribute *attr,
>   				  const char *buf, size_t count)
>   {
>   	int order = to_thpsize(kobj)->order;
> -	ssize_t ret = count;
> +	int mode;
>   
> -	if (sysfs_streq(buf, "always")) {
> -		spin_lock(&huge_anon_orders_lock);
> -		clear_bit(order, &huge_anon_orders_inherit);
> -		clear_bit(order, &huge_anon_orders_madvise);
> -		set_bit(order, &huge_anon_orders_always);
> -		spin_unlock(&huge_anon_orders_lock);
> -	} else if (sysfs_streq(buf, "inherit")) {
> -		spin_lock(&huge_anon_orders_lock);
> -		clear_bit(order, &huge_anon_orders_always);
> -		clear_bit(order, &huge_anon_orders_madvise);
> -		set_bit(order, &huge_anon_orders_inherit);
> -		spin_unlock(&huge_anon_orders_lock);
> -	} else if (sysfs_streq(buf, "madvise")) {
> -		spin_lock(&huge_anon_orders_lock);
> -		clear_bit(order, &huge_anon_orders_always);
> -		clear_bit(order, &huge_anon_orders_inherit);
> -		set_bit(order, &huge_anon_orders_madvise);
> -		spin_unlock(&huge_anon_orders_lock);
> -	} else if (sysfs_streq(buf, "never")) {
> -		spin_lock(&huge_anon_orders_lock);
> -		clear_bit(order, &huge_anon_orders_always);
> -		clear_bit(order, &huge_anon_orders_inherit);
> -		clear_bit(order, &huge_anon_orders_madvise);
> -		spin_unlock(&huge_anon_orders_lock);
> -	} else
> -		ret = -EINVAL;
> +	mode = sysfs_match_string(enabled_mode_strings, buf);
> +	if (mode < 0)
> +		return -EINVAL;
>   
> -	if (ret > 0) {
> -		int err;
> +	if (change_anon_orders(order, mode)) {
> +		int err = start_stop_khugepaged();

Thanks for the cleanup, and the code looks better.

>   
> -		err = start_stop_khugepaged();
>   		if (err)
> -			ret = err;
> +			return err;
> +	} else {
> +		/*
> +		 * Recalculate watermarks even when the mode didn't
> +		 * change, as the previous code always called
> +		 * start_stop_khugepaged() which does this internally.
> +		 */
> +		set_recommended_min_free_kbytes();

However, this won’t fix your issue. You will still get lots of warning 
messages even if no hugepage options are changed.

