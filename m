Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FC53C43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 18:53:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75B896B0088; Thu,  9 Jul 2026 14:53:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 732A76B008A; Thu,  9 Jul 2026 14:53:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64B946B008C; Thu,  9 Jul 2026 14:53:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B7A56B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:53:40 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C60021C0537
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:53:39 +0000 (UTC)
X-FDA: 84970136958.11.2996482
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf25.hostedemail.com (Postfix) with ESMTP id 05F6DA0002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 18:53:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="e5fYQ/uU";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=dave.jiang@intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783623217;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RI7iJgvTf8txY6Dhz+ITywiAeeyqaT0TQssDuyyFM/Y=;
	b=U38mZ54nP/XFi8LqL35Grfnih6auLZBhnWCOisttDSdZuLcgGivZI53wu8H1k4M/jFVrxC
	+av0LGa96gmfef8vizyEpy5RZmcicJO55g6aJIG00B6Jf3q9tokbP6BmQxMx0LF+mZt+5l
	xT+G4ZClgCjgKOEvTEia1rv0dkZFJvw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b="e5fYQ/uU";
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf25.hostedemail.com: domain of dave.jiang@intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=dave.jiang@intel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783623217;
	b=kTQ2ttvlcVdURzwQtSbITtALFaIW1KCCIwJF0GCAGNUYOlrTBlnpvoWGJhtzpgHSdIoPQB
	eiUDzENvs+0EV0SSKe8wDgsQqVfSPV8MoO1/oJqmK7wGk2n8ZDFlMstLwMzSJpmTGS8SQj
	b4oz71EiVOAlpwm8+S6+3pkfYPNyi90=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1783623217; x=1815159217;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=LWIYIVvgdWKhwMP33tl30RMSOxpaqVLRpXYaD3FEX/o=;
  b=e5fYQ/uUTq0SFh0MfWoBtA4kos8eD/HcqlbRzJlmEB1UDzFhTqsL7ShA
   xIp9WViLGZBh1XcIQczUobwTSgjR+cTb0TXlusR04BKcG138NQAiI6iCJ
   zdDLsxqJPWIH8TFMlplP4c7bBsLJdNBHKL6Zl1GD26uWvsqAxjFNaArpc
   VzSGbGROQyjUnJ7dUApeLqU+XLp0rrlobKeO8XoSS5+DMkK/W1c1SfCfK
   j66NjZt9fDIT/WF/BBVcltZpNX4TisEf8EhGdglTE4sNTUO4oJEJqAX7D
   UEtl7lT5f3mUpgys26MZ1WrjGR+6gMUFA90A74p3u1S8zKNo8VbSW/YDx
   A==;
X-CSE-ConnectionGUID: /QaIR/dXTF2aKqmo+1DeZw==
X-CSE-MsgGUID: 4o12CmoURV2jUQrt1o7aUQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11841"; a="86863319"
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="86863319"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 11:53:36 -0700
X-CSE-ConnectionGUID: 8y4wDk/dRRm6acAzB59uyw==
X-CSE-MsgGUID: O3/+HRVRQj2m6mIsYe7DqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,154,1779174000"; 
   d="scan'208";a="252933813"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.111.142]) ([10.125.111.142])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jul 2026 11:53:34 -0700
Message-ID: <48645b42-64e7-4f96-9113-b136386038f0@intel.com>
Date: Thu, 9 Jul 2026 11:53:33 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 06/10] mm/memory_hotplug: add
 offline_and_remove_memory_ranges()
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev,
 linux-kselftest@vger.kernel.org, kernel-team@meta.com, david@kernel.org,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, djbw@kernel.org, vishal.l.verma@intel.com,
 alison.schofield@intel.com, akpm@linux-foundation.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org, iweiny@kernel.org,
 Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-7-gourry@gourry.net>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260630211842.2252800-7-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 05F6DA0002
X-Stat-Signature: mqhkg8ag66uirtqy7xp93945jcbabxpf
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783623216-357369
X-HE-Meta: U2FsdGVkX18gh+88T9Zdh6GF8f/cknvsZ5HdlOY7rh5HYdq6165A40oylxudQ2SVgBgQg0pXXN7BzaEyD1JuI5VrEpibXoHg71vf2rOgIJyBZogXzpACiUvpJ7Np06t87u8jAILBTwO9J/iY0CEMmYWbq3UNCqIQVCha4WesvpP9Mh86CJ7cd3yJaZ7w6KSwS/w9WbKiMzHSaNlO6CKi9I5WPUXc0H4WlcsJC7dGvdwNRBDQuK2feo2XbTNAERyDkaDMEbGiS7H9AXj8axYU4D3jAOEJa58HkN56UtNyoQkgSA1ieJij/an5SL3Ik2nfozBX2iz30I0MGdeTMb/mqGepXaDxpAR4rgr+oG0POECPQZ2ddmrf80bv38Aa48j7tnPPBxLpJ39OZzCkftmz0K9DRemOeUc7Apz0ALsEZ1pCcOHCAvKNwb57siEIiUlsv4O6+k5kHy4fwvG7S+c6m2s32qung83P0g2esvRVMwYRGCb6h0NysnvG3LXgDLaKduaNoM9uuMOVIA6Z0xfTKXI4r3MkjHRaLlIlqqe8aJqYBa0bc9rw631WZeAKiEAUmhQimrEQ+VmYs+wpj5Q5YN3ZYWCyLsQPHuLmNKFf79kgVXfG93Ic//4UkYIkKTwXfrZi5EkjSG/6YGeu3QDT0SdtaUCbzLeadC095Qeaii7zIZcMYnL8A1QzmVjqggeuECU7JvH6tXyaqUwA6ez/lss1QbFspx1aZtLoS6aJ64/lmYIh1Yo6hRFIuh543pEyEtwH+a0NnwPE362MqSkl4XANKoQcXIbNvLqWegK9FOj9YPnMzhFkSfgp71cdgK9/cwvm8ukmg7srMA0abg8/wp6wYLtK8UrQne86oMUg3wm9ZfGLUldZvWvBBi6KcvprUgPmPX/5ychDW0tujrYF7Wb1UT8lYf87IoaN+CbtrDsr8rsHpbzKgGsbnsqqD8Bex2lijnHEjafz59sCu4N
 19jvULGr
 x7JAzgSA9ji4sB1k6Tu3W+61oZCl/A1hJLaMbCby15sAPb9reTmC0ZHvyhSrYyxGkNYq2w39GP5AiO+pCS7xEBemOAezt1wqpvug+0TF/eXjt9IU02j35NRn3wuUEfjjGP41UaBF6YzSEmC0t4GiWwTOGrxDOXFhTURxOZmmJP6SBAeUUt4IgoxC8vaU2VTLUcVclaJMHfsGER0w3twPpEt7cpQ8wx27Zlr3MmZ0ka7fwoagFAuURTUvrOOFsDLrdALKGIsZKA0KQkXKwgTdXCWEinNrKJuNqMquChSJhZXswvCCM+qbNYjaa/76DZWINEYcjcmBQ8MgpfQR3jwASHwMpwXCR7Kp9LHAmCoBcFstX3oAn3gphnBrdaq42EEvs4GJ+xCWv2YYdPLBxNIr5w3iOEEhHWohHois4ldaNnf3U63ZicuRkrUeI2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/30/26 2:18 PM, Gregory Price wrote:
> offline_and_remove_memory() handles a single contiguous range.
> 
> Callers that manage a device composed of several ranges (dax/kmem)
> currently have to call it in a loop, which gives up atomicity.
> 
> In addition to pushing rollback logic into the driver, the lack
> of atomicity creates a race condition between system daemons trying
> to manage the same resource:
> 
>    - Manager 1:  Offlines memory blocks.    Removes device.
>                                         ^^^^
>    - Manager 2:  Detects offline memory blocks, re-onlines them.
> 
> Add offline_and_remove_memory_ranges(), which takes an array of ranges
> and processes them as one operation under a single lock_device_hotplug():
> 
>   - Phase 1 offlines every block of every range.
>   - Phase 2 removes the ranges only if all ranges are offline.
>   - If any offline fails, the whole operation is reverted.
> 
> This gives callers all-or-nothing semantics for the offline step, so a
> failed or interrupted unplug leaves the device in a consistent state.
> 
> This also resolves the battling managers race - the second manager's
> operation simply fails when the block is destroyed / cannot be onlined.
> 
> offline_and_remove_memory() becomes a thin wrapper that passes its single
> range to the new helper, so the offline/rollback logic lives in one place.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Gregory Price <gourry@gourry.net>

With Richard's comment addressed,
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  include/linux/memory_hotplug.h |  8 +++
>  mm/memory_hotplug.c            | 93 ++++++++++++++++++++++++----------
>  2 files changed, 73 insertions(+), 28 deletions(-)
> 
> diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
> index ff3b865ea7e7..db10d50f30ae 100644
> --- a/include/linux/memory_hotplug.h
> +++ b/include/linux/memory_hotplug.h
> @@ -268,6 +268,8 @@ extern int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
>  extern int remove_memory(u64 start, u64 size);
>  extern void __remove_memory(u64 start, u64 size);
>  extern int offline_and_remove_memory(u64 start, u64 size);
> +int offline_and_remove_memory_ranges(const struct range *ranges,
> +		unsigned int nr_ranges);
>  
>  #else
>  static inline void try_offline_node(int nid) {}
> @@ -284,6 +286,12 @@ static inline int remove_memory(u64 start, u64 size)
>  }
>  
>  static inline void __remove_memory(u64 start, u64 size) {}
> +
> +static inline int offline_and_remove_memory_ranges(const struct range *ranges,
> +		unsigned int nr_ranges)
> +{
> +	return -EBUSY;
> +}
>  #endif /* CONFIG_MEMORY_HOTREMOVE */
>  
>  #ifdef CONFIG_MEMORY_HOTPLUG
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index a66346def504..3225364bec2f 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -2429,58 +2429,95 @@ static int try_reonline_memory_block(struct memory_block *mem, void *arg)
>   */
>  int offline_and_remove_memory(u64 start, u64 size)
>  {
> -	const unsigned long mb_count = size / memory_block_size_bytes();
> +	struct range range = {
> +		.start = start,
> +		.end = start + size - 1,
> +	};
> +
> +	return offline_and_remove_memory_ranges(&range, 1);
> +}
> +EXPORT_SYMBOL_GPL(offline_and_remove_memory);
> +
> +/**
> + * offline_and_remove_memory_ranges - offline and remove multiple memory ranges
> + * @ranges: array of physical address ranges to offline and remove
> + * @nr_ranges: number of entries in @ranges
> + *
> + * Offline and remove several memory ranges as one operation, serialized
> + * against other hotplug operations by a single lock_device_hotplug().
> + *
> + * This offlines all ranges before removing any of them.  If offlining any
> + * range fails, the entire process is reverted and nothing is removed.
> + * This provides a fully atomic semantic for unplugging an entire device.
> + *
> + * Each range must be memory-block aligned in start and size.
> + *
> + * Return: 0 on success, negative errno otherwise.  On failure no range has
> + * been removed.
> + */
> +int offline_and_remove_memory_ranges(const struct range *ranges,
> +		unsigned int nr_ranges)
> +{
> +	unsigned long mb_count = 0;
>  	uint8_t *online_types, *tmp;
> -	int rc;
> +	unsigned int i;
> +	int rc = 0;
>  
> -	if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
> -	    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
> +	if (!ranges || !nr_ranges)
>  		return -EINVAL;
>  
> +	for (i = 0; i < nr_ranges; i++) {
> +		const u64 start = ranges[i].start;
> +		const u64 size = range_len(&ranges[i]);
> +
> +		if (!IS_ALIGNED(start, memory_block_size_bytes()) ||
> +		    !IS_ALIGNED(size, memory_block_size_bytes()) || !size)
> +			return -EINVAL;
> +		mb_count += size / memory_block_size_bytes();
> +	}
> +
>  	/*
> -	 * We'll remember the old online type of each memory block, so we can
> -	 * try to revert whatever we did when offlining one memory block fails
> -	 * after offlining some others succeeded.
> +	 * Remember the old online type of every memory block across all ranges,
> +	 * so we can revert if offlining a later block fails.  All entries start
> +	 * as MMOP_OFFLINE so blocks we never touched are skipped on rollback.
>  	 */
>  	online_types = kmalloc_array(mb_count, sizeof(*online_types),
>  				     GFP_KERNEL);
>  	if (!online_types)
>  		return -ENOMEM;
> -	/*
> -	 * Initialize all states to MMOP_OFFLINE, so when we abort processing in
> -	 * try_offline_memory_block(), we'll skip all unprocessed blocks in
> -	 * try_reonline_memory_block().
> -	 */
>  	memset(online_types, MMOP_OFFLINE, mb_count);
>  
>  	lock_device_hotplug();
>  
> +	/* Phase 1: offline every block in every range. */
>  	tmp = online_types;
> -	rc = walk_memory_blocks(start, size, &tmp, try_offline_memory_block);
> -
> -	/*
> -	 * In case we succeeded to offline all memory, remove it.
> -	 * This cannot fail as it cannot get onlined in the meantime.
> -	 */
> -	if (!rc) {
> -		rc = try_remove_memory(start, size);
> +	for (i = 0; i < nr_ranges; i++) {
> +		rc = walk_memory_blocks(ranges[i].start, range_len(&ranges[i]),
> +					&tmp, try_offline_memory_block);
>  		if (rc)
> -			pr_err("%s: Failed to remove memory: %d", __func__, rc);
> +			break;
>  	}
>  
> -	/*
> -	 * Rollback what we did. While memory onlining might theoretically fail
> -	 * (nacked by a notifier), it barely ever happens.
> -	 */
> +	/* If any failure occurred at all, rollback any changes and bail */
>  	if (rc) {
>  		tmp = online_types;
> -		walk_memory_blocks(start, size, &tmp,
> -				   try_reonline_memory_block);
> +		for (i = 0; i < nr_ranges; i++)
> +			walk_memory_blocks(ranges[i].start,
> +					   range_len(&ranges[i]), &tmp,
> +					   try_reonline_memory_block);
> +		goto out_unlock;
>  	}
> +
> +	/* Phase 2: Remove. This should never fail holding the hotplug lock */
> +	for (i = 0; i < nr_ranges; i++)
> +		WARN_ON_ONCE(try_remove_memory(ranges[i].start,
> +					       range_len(&ranges[i])));
> +
> +out_unlock:
>  	unlock_device_hotplug();
>  
>  	kfree(online_types);
>  	return rc;
>  }
> -EXPORT_SYMBOL_GPL(offline_and_remove_memory);
> +EXPORT_SYMBOL_GPL(offline_and_remove_memory_ranges);
>  #endif /* CONFIG_MEMORY_HOTREMOVE */


