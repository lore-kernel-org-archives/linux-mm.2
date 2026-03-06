Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B924DF01827
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:32:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 072606B008A; Fri,  6 Mar 2026 06:32:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 020396B008C; Fri,  6 Mar 2026 06:32:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6E586B0092; Fri,  6 Mar 2026 06:32:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D2AFF6B008A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:32:50 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5F3718BF22
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:32:50 +0000 (UTC)
X-FDA: 84515426100.13.7620AF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id BCB8740005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:32:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Y/Fxmg00";
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772796768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UixAVxEebHZJylV1vJ4ROTJ9dnaSHFTyIHLF4zgV9fY=;
	b=3Zm3ZxAdG6/JfNzgMJ5/YRIo2gCDyM0H30Xgne4pcAyPCaie3cV9Vf8DoskoogEWXw0OjI
	Nj0V4O2ur8jIv3c647DiwelFcd+PjeYTHJlmU1Incw2UQWIoBZXffrQxXveKKgmzrOfMFp
	DAuTQpb4n6Ndwk6zPFSPYh5i98QQbxc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Y/Fxmg00";
	spf=pass (imf12.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772796768; a=rsa-sha256;
	cv=none;
	b=BdYfJFZBKbsQh73UmtaHsOUEx5KmsvvCMWiyfhaxpuGujd1cSmr446vhh6nvao0Rnk9s2x
	xYfGQYwON7SMRigsBcyb0tj+s0X89tysOI6ETgIzHTAYZtMSjdpEUun/z0077yVMYrt7/3
	m2b9CBJwrVTgzj9VU/r8dpGgQux+jbo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AAFA60018;
	Fri,  6 Mar 2026 11:32:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42575C4CEF7;
	Fri,  6 Mar 2026 11:32:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772796767;
	bh=X9etgVwFexZz9bWGh+Ius3/W4TGrz1Spu+GpiM77+tY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y/Fxmg00RbJPFdAxWtM63iSb1tRdMnUWn8fvbp70ZKPO3xpErJUU87v8EFEn/UDDV
	 8B3+qkwlaL9UIcxrmdecPEF4qzNjB7Em26AOWlATcBiXbe9+9mHTm0mGmL7NAnYIWk
	 fdGu1VDn3pbO9KvjeKPZaB0Z/eyPYkxUhdIjTWiajnyyAv5BvamA8v9+G5hfDzE9sW
	 SJeMagwv2S7S5ILwE25Fw1YbzGwLffPmBRdHNTX7ynrTIrwsL+wHJ9pmJZignIyo/c
	 /zIH8HtYHhqIbG6GGdZgW86Jx4/CrfnEw2sQv+kCrR7AMNo8rgptG7CuOJK4SOMqxw
	 gJ+th39z6kBPQ==
Date: Fri, 6 Mar 2026 11:32:44 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 2/3] mm: huge_memory: refactor anon_enabled_store()
 with change_anon_orders()
Message-ID: <68156cf9-cf97-4435-b979-c2ab0d6a97b1@lucifer.local>
References: <20260305-thp_logs-v2-0-96b3ad795894@debian.org>
 <20260305-thp_logs-v2-2-96b3ad795894@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305-thp_logs-v2-2-96b3ad795894@debian.org>
X-Rspamd-Queue-Id: BCB8740005
X-Stat-Signature: jwbw1c8xhz3sctufmoeo8w5w4k5p8rcg
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772796768-98573
X-HE-Meta: U2FsdGVkX18/7GTveR9hPt+sWVqefOinAhd1roq7omUBqljTSOGGJIeoc7vyDP8zKSMA6YL6zBNQXPrmP2KyQkDihf9gYO0HglwqikMPyqwhpQrKjIBqjrivx54552cQUyKXwfpTKNiU8QPClgFscf5VIQJW6VHYhs3m2Wt3HUe5EEoRk6xZ1OmgQkjaiw1U1ykLv7i0oHWOdPOB6BOE/CbKlXSwtYsFHOFSVuEgmlxvBqjv/WIcl8RnN9TaoqpF2ouzT0BgnoUdtG7xmjWUfo9TsTl0GI2xFTxgXHS3dHZRaxfS+EHU7AN9ifjzuVFKu6UY4tGC5t9yTDXo9+pBt9dWuB5dCk4ugrAoMFuWQ+RZlzgQTbKB6c53A41LKEzxSGoACzpqRIcdzKmJ+YD3Ua3B1HjabsrZVj0vWA9hbMq9iKVMRpdDgrOxZf4Ax2sQlij3wyueVjLh6c3DVmZBQfanUXqhUGbGEBgIyAh62bwP91YTSTDDYW/g9pn/cA4+x+GpFzv2wFsQ+S+0vZUYV9UDjpD631L+fC4+Oiz1hF+OnYRjY1u9XHnxrXCCTwvOuzeizBBqNPOltqgIXJNBpQ2/hPhrRAhncmxzQPQ15CmWHwKW/0dpGhsHM0YZbVxbwNnVqNtUAg6EWeFCyHxyPMgM8STYPn1RMGhsplp9xkhxz96FUGFgHSQbEHgmWgE4p3DErEtvrOUAtsoTMWbZg6BMGepaOn6Xvngd1gBgRj4aOlLfV+Aqm+Sn/oSn1AG0SgKB8kx+3IvMJXr8dsw3arCLuoE2qS1BsydNAsCmzFGUMFWEq6/YQ142s3MkZsZdlKe42PmQv+2NWMibLhXOl9NuPEZXMvrdnE6V9Q6pBJsK+rFIfsDt365RLuiENQFpLc3ifFf4tlfWQU0gkRoPoLseePAZj+HU/ruz058wHx8laTC7spzRqP/4tz4DDsPPG7TkGF5NTP7NwJe+LE8
 COZ6qbxt
 ljdNW5AOpjztjsWVAmYi90tnyR0c2P0pFYP79kI0U+Vt3Zu4lx9O4LJX0rTz/gD6tmTuzyQR7YyNwF96bCXd44mH4/PyMUvBNBJJ3BFjTDt0dEAajTtGG8xvSE6MZRiMFten1N0ENU3+rTVi6cooFpLDlMXaTuXspRXA4AHBJCec9iiMhqK0DTk/sl7GMlCXiZZQPaHzY4hC4gM241u4yKKYVBtElCtlssNPP8V2EqVzwL7v2v4oUt2sEYDJScr1yYbiklDB9iHFUPHW2bGAp6GnnZyHlwXKfshR/kv2gxISd3/s5uWSFlsZTHQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 06:04:54AM -0800, Breno Leitao wrote:
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

This is nice, you've improved my idea :)

I know you change another instance of this in 3/3, but I wonder if there are
other cases like this in the THP code we can fixup too?

Anyway, passing tests locally and LGTM so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>


> ---
>  mm/huge_memory.c | 84 +++++++++++++++++++++++++++++++++++---------------------
>  1 file changed, 52 insertions(+), 32 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 8e2746ea74adf..19619213f54d1 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -316,6 +316,20 @@ static ssize_t enabled_show(struct kobject *kobj,
>  	return sysfs_emit(buf, "%s\n", output);
>  }
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
>  static ssize_t enabled_store(struct kobject *kobj,
>  			     struct kobj_attribute *attr,
>  			     const char *buf, size_t count)
> @@ -515,48 +529,54 @@ static ssize_t anon_enabled_show(struct kobject *kobj,
>  	return sysfs_emit(buf, "%s\n", output);
>  }
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
>  static ssize_t anon_enabled_store(struct kobject *kobj,
>  				  struct kobj_attribute *attr,
>  				  const char *buf, size_t count)
>  {
>  	int order = to_thpsize(kobj)->order;
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
>
> -		err = start_stop_khugepaged();
>  		if (err)
> -			ret = err;
> +			return err;
> +	} else {
> +		/*
> +		 * Recalculate watermarks even when the mode didn't
> +		 * change, as the previous code always called
> +		 * start_stop_khugepaged() which does this internally.
> +		 */
> +		set_recommended_min_free_kbytes();
>  	}
> -	return ret;
> +
> +	return count;
>  }
>
>  static struct kobj_attribute anon_enabled_attr =
>
> --
> 2.47.3
>

