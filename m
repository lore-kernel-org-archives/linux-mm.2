Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 613D3F0182A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:39:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C5BE6B0092; Fri,  6 Mar 2026 06:39:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8733C6B0093; Fri,  6 Mar 2026 06:39:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78D2A6B0095; Fri,  6 Mar 2026 06:39:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 641796B0092
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:39:34 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0E2121C691
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:39:34 +0000 (UTC)
X-FDA: 84515443068.01.102B1BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 74AA0A000A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:39:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q6+5bJU5;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772797172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhyVQ9JurrmIL2o2jUPmxaLoahROVNlgiaUJiIP+540=;
	b=SMptLr1Q3Km8qsM9CYPcH4GbLv8vnQQZXkcUXbrnC843mrI4QyI/MuXupslNEcjLtFCh84
	DUtV3xwBySChZB5EsBL0PSRveSARWpyslZGuYCn6xzMQlHOAPRCkbSgzqW3TMh9ki12nSv
	6uXleSg8wMFVs9fNDMMGZbXgiyRs7ck=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=q6+5bJU5;
	spf=pass (imf15.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772797172; a=rsa-sha256;
	cv=none;
	b=CQFXlmWS0Yn79+2dvExnytS9eVh94g/RfJ6Miie2oPuIRFBSoiDEznyGRdllC7T2YTCHmw
	Fy/ZM+j0A6GBwTgR1h5D9MPeAziJUq1r6vpLnb375QuMBxvE+czqlxWwQWnNibnw+ZXY29
	NbOaDSDUaINM7uzeF1czPHoHLFoAd5Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C6A9C6012A;
	Fri,  6 Mar 2026 11:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEE6CC4CEF7;
	Fri,  6 Mar 2026 11:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772797171;
	bh=0cs8qXX0w8L9WzG6FxiKkEtbMe4IWFPc1fUI16tb98U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=q6+5bJU5Q4vnGYIOMHxtP/fwEKuDSK2hA5IhDe8+PkQeYooM2TIRjBnvmFVvCA3id
	 zx+kdnfnhGj/Hc2J46iXwA7kz4D7aKyf8Ka9/QeE1ovFxzsN3ZjpEk/g/ZL9CHq9WO
	 DL7EyjTCNT0rTq3V++Z1Z84TjsutySazmrFPxuph6Vni0biEndWsyaZL539j5TjDKp
	 Gqs9RY0RSWWVsCxDv3rAkXkjlCRjN830b6gyc3TvnCgioA1C0CvyoEpheBCHuDkVyF
	 RN08EbOx/XEUw9Xpfs5pPNDPGwK44ER8hK5YYUNd/Wdd6dIeNoGI0Oo1D9ycyuIAfB
	 43L0aHB1cxH9Q==
Date: Fri, 6 Mar 2026 11:39:28 +0000
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
Subject: Re: [PATCH v2 3/3] mm: huge_memory: refactor enabled_store() with
 change_enabled()
Message-ID: <ce99b331-809e-48dd-ae8e-19eb6a44b5b4@lucifer.local>
References: <20260305-thp_logs-v2-0-96b3ad795894@debian.org>
 <20260305-thp_logs-v2-3-96b3ad795894@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305-thp_logs-v2-3-96b3ad795894@debian.org>
X-Rspamd-Queue-Id: 74AA0A000A
X-Rspamd-Server: rspam07
X-Stat-Signature: u6xajfqzyupm9j3dz9a7sqjxxpeb77b5
X-Rspam-User: 
X-HE-Tag: 1772797172-1939
X-HE-Meta: U2FsdGVkX1+vE4+kJLSzQRvWMUhvPL/R9rb7MSqKGtl8zuEz4Rcf09kXUn8FsXEy6OadZ9DnXhuM/Gzy1ZUC7pn3Lurcot2XJg7JnJDuFWgUU+ZW44XY5Y/QvYvUy2e4Xn5OTQ3FT/2JmcYb1+8FdHsVszbqhOOm3NehcKmqSyPlMA5VBwe4p/ljwVTT1N92aT4xTgFv6G9IoBD+vYzmo3Sf1dQhcpdPa73kw6OKXm+k9yvbQcjDNpABeHK9RSKFZ4AhzK6/UticVZpqRV29pPU44XEslHQCuCIkFDSvRMsPUqCKFKOpqIcRvStRu/9Ob9LzEECHEQ0SWoEf2a1YfQ96rPhUWPTvEr9zJ3tY8e6zZkFzgoZbSCjkXmHiFi7D344KhJTAF5xrtg0fp3A3OdyGC53VFiijyvUAZjD/+wRLd86mJbzCgM9WJo4cRCPI+ZLuac2SEZGKYih4TuHDnti9BsVAp3yv8CavhRwfhVKkzMv/24lfduhFdEL9/lWLZ3dgaSM0k2oNKi+Sk18RoqxaZiUJXlTUibnoHIr74ftfGqVssS4jDnThMolJnvRy0D2mrVGdfvQzKGbZfERs9f3gB7F5gT4BMjjbo2B2XS1JYtZPJQq7IwqUcvp4+vQquyqhmPbT5nWkJ3vUEkyBHkPLIxfLqdeBLy9EjnhrIOFyX0NrAuH+G91Z7QFMjLJLem7zDGi1/j6Wi0CjNJoQ/3X8CtocjF8XEDm6ofJOyRYEPp5uvU9dGfHZ7EPGmyz34ZM0XNAQ+BdynGLhmkbQxUXdgZ4zJ0pPQxumXmHMtp71Ni+CnQjB0z7E5bXGM0bYq6XvtIP2S5B0JlPXlp/QDOdg6eBlmXWkJ+GYljEV+o4zmB7k3Ly4fYGqp8KhEbXsnp8Nl09ZWJbNZLgdck6ot7NGZXj6YXyVLmYF/5SOEvqf6VyZksbhdKMTmXcBFGT3e8HBsF4mxjY9/TeVz67
 trMulgew
 IOccxhD3G2r3promSyW/fCT3J8w0X1/d6K7QGZhZY1hlLkPL06wWkdkOLdH33AKXYlSMIqBsZjhbp7PnjQUgswUQltFWzZnYFOr3eg2DGaNKGZGVwB73a/tEObFPt8oe35CL7dLdTJTh3uJOVdk9EB4VzKxyNP1lB3KmFxgYrwC1gIQR5Ix7VxgqSprEn4WiXqDQOiJfKAmXeJYAF0+/8sIw2vVf2UQTBBifZgX7amBj/tiwJhWpCJax8+y1qtO33q5oA8aNPd1LJBk24yqJwnaOZ1X9XxKsZgg3H6BCJhznjQq2MjCrRnjWwMA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 05, 2026 at 06:04:55AM -0800, Breno Leitao wrote:
> Refactor enabled_store() to use a new change_enabled() helper that
> reuses the shared enum enabled_mode and enabled_mode_strings[]
> introduced in the previous commit.
>
> The helper uses the same loop pattern as change_anon_orders(),
> iterating over an array of flag bit positions and using
> test_and_set_bit()/test_and_clear_bit() to track whether the state
> actually changed. ENABLED_INHERIT is rejected since it is not a
> valid mode for the global THP setting.
>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>  mm/huge_memory.c | 51 ++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 36 insertions(+), 15 deletions(-)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 19619213f54d1..dd5011cf36839 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -330,30 +330,51 @@ static const char * const enabled_mode_strings[] = {
>  	[ENABLED_NEVER]		= "never",
>  };
>
> +static bool change_enabled(enum enabled_mode mode)
> +{
> +	static const unsigned long thp_flags[] = {
> +		TRANSPARENT_HUGEPAGE_FLAG,
> +		TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
> +	};
> +	bool changed = false;
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(thp_flags); i++) {
> +		if (i == mode)
> +			changed |= !test_and_set_bit(thp_flags[i],
> +						     &transparent_hugepage_flags);
> +		else
> +			changed |= test_and_clear_bit(thp_flags[i],
> +						      &transparent_hugepage_flags);
> +	}
> +
> +	return changed;
> +}
> +
>  static ssize_t enabled_store(struct kobject *kobj,
>  			     struct kobj_attribute *attr,
>  			     const char *buf, size_t count)
>  {
> -	ssize_t ret = count;
> +	int mode;
>
> -	if (sysfs_streq(buf, "always")) {
> -		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
> -		set_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
> -	} else if (sysfs_streq(buf, "madvise")) {
> -		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
> -		set_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
> -	} else if (sysfs_streq(buf, "never")) {
> -		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
> -		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
> -	} else
> -		ret = -EINVAL;
> +	mode = sysfs_match_string(enabled_mode_strings, buf);
> +	if (mode < 0 || mode == ENABLED_INHERIT)
> +		return -EINVAL;

The mode == ENABLED_INHERIT check is weird, it reads like 'oh a user CAN specify
this, but if they do we error out', but in reality
/sys/kernel/mm/transparent_hugepage/enabled explicitly outputs only always,
inherit, maddvise.

So, even though it's duplicative, I think it's probably saner to have:

static const char * const anon_enabled_mode_strings[] = {
	[ENABLED_ALWAYS]	= "always",
	[ENABLED_MADVISE]	= "madvise",
	[ENABLED_INHERIT]	= "inherit",
	[ENABLED_NEVER]		= "never",
};

static const char * const global_enabled_mode_strings[] = {
	[ENABLED_ALWAYS]	= "always",
	[ENABLED_MADVISE]	= "madvise",
	[ENABLED_NEVER]		= "never",
};

Just to make it clear what you're doing.

And if you add something for shmem add one for that too.

With that fixed, feel free to add:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

>
> -	if (ret > 0) {
> +	if (change_enabled(mode)) {
>  		int err = start_stop_khugepaged();
> +
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
> +	return count;
>  }
>
>  static struct kobj_attribute enabled_attr = __ATTR_RW(enabled);
>
> --
> 2.47.3
>

Cheers, Lorenzo

