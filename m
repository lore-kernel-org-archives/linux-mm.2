Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08FF0F34C5E
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 14:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46FE66B008A; Mon, 13 Apr 2026 10:49:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 446D46B0092; Mon, 13 Apr 2026 10:49:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 383A96B0093; Mon, 13 Apr 2026 10:49:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2B8B76B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 10:49:52 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C015A1601B4
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:49:51 +0000 (UTC)
X-FDA: 84653816982.03.2B548A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id B6BEB8000C
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:49:49 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HXyiDmP6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776091790; a=rsa-sha256;
	cv=none;
	b=I5oatay/NwfSlPwFgMuppJHZkE1zbKyFTTb5qMV31MfhJn87rjXtmeBsK2ywbDgZ0bhgVC
	S0kaB5y7X0E4Wq+SR0t3O/pRbLgDjk+RV6qW3CzpqjfQyTuj0j0JE4lgelWDTrwR52VDAf
	kyvuV5d1fMd/v9fQdx2j40lfoKNSZXU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HXyiDmP6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776091790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YZe8IWvzcPZOKNkz+czas8chwh4OfUObRgtwmJIvH70=;
	b=nhoIt3Zl92ruyJ1N8+dCNqDLHtOB+LiI4jU6RMtOpJWxCRyYS8Og4nnBIMras6XttZM3QC
	Yd+kdMDJSZTaRTSFkWrd2FSZJ5xSTd/fw57g7QmAcUOy2zu0mRmPL2tHgGfuEHCJIvA5YT
	Fgh1R3aeXoHt0GuQJrtATgPeWT7qLw8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FC2E40802;
	Mon, 13 Apr 2026 14:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D9A3C2BCAF;
	Mon, 13 Apr 2026 14:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776091788;
	bh=mjWzHkibbJ+YGpg8iepNJ9fmO8lj/6ddY53/GhjosH0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HXyiDmP61caBFR6ZEDJhLV2kLFTrpfWmsebGSZkB4Sz+GvDVozGmf+j4Ma4qLWtHx
	 vblYih3TDYo1K5L/hjqRnJSE/NNvB7I+g8EGy0zEZwP9FErtsWbxwx3MUUBbhwxjXR
	 RiMs+KxEGJ72hftseV0cvzfNjc6QuH1kP9ywyULy3USoTE0IBt5Lkh/vHTRshbQBYO
	 x0qd8ryPHY/QPw1CSAY7abXHysgOhE+zArf5GJu5t6o+6CYS8QeZudssfGWk8HRjTd
	 NIgY1AhwDj7UyixFtsOC3h42MI8HKENmsWkIAwjZwEtCLjiNUUm87amLTdD59FHP6S
	 8PQtsyQyU1o7Q==
Message-ID: <4c08c0a8-9415-4f30-bfa9-db39318fa7d3@kernel.org>
Date: Mon, 13 Apr 2026 16:49:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] dax/kmem: atomic whole-device hotplug via sysfs
To: Gregory Price <gourry@gourry.net>, linux-mm@kvack.org,
 vishal.l.verma@intel.com, dave.jiang@intel.com, akpm@linux-foundation.org,
 osalvador@suse.de
Cc: dan.j.williams@intel.com, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org, kernel-team@meta.com
References: <20260321150404.3288786-1-gourry@gourry.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260321150404.3288786-1-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B6BEB8000C
X-Stat-Signature: jw7gjji97opfseeps7axtyhkph6gkcd9
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776091789-508000
X-HE-Meta: U2FsdGVkX19an6XIzea3sgc+ICoDwUH5YLr1GHsnRW2+Olrwv70yTwJ2B73zh/SuuaQZ4TBvZgTAXZild0pttU21dB2ODDTzlJtrVv55zBxLr7h/MByjfYTfXQ9F7G1y1Q7jYnURPzU2ef9OBMNvl7ssgHFMSi0KuAnEgW1a1Mvk8ksUXQ5oXzXFP1zpkExmr+3mAS2tAtHaRtKJgyThk/V/svMDExMD+I3dg53IP0gGKzQt7peDZhv99WjQonqucLFdcblEbBPKqwU9YmvAcV0pntN080oJpcCVAN7G6st00Ofp9WgPeasb48aUtVX30IfmmfjaLRm6aGWOX3IrfXOFTw9HfFcSaeB2NXpcZ1ggPsGTjf/MUkFka4GhPsxCExQ4yPjjh5XpgJkPor4Ae8hNi+hbjBlS2r/4sy09WN+RJcJ5DD6hw0hYFboSOizkSUAWugkSiiHjDMcIL74R2lGvY6sbYSyz0E5rhXYZ4nhIx3xZORn24QuNytytfjDC4ZmgZ66eAvP/rZG/TNhe0c3V/nANW3azG9gafDFdkFRmvzTk3XEqmbEWMCeZDvKz+hFz93IaMdhnSRQ7eFzE8RfkqatSr+0WEaVfF/xrSkzquAr9hHdzLkijgDuTgbxPzhSupjc8U1fjv7AZCCdzFWcsnT2cWGzNm97FXWSdIq16lg1NtTtl6Nqsx1R7isG0kSYh6lK4KwH0SP3L4xw1A8zvYQNsNnBwi4VKX84wcNPBc7y/A/131//8FF2i0zvctXlWGp0eP9n3Pso3JfBq6RCHHmdmTwry42NE626KGl2p4uBZWTJr9SfTQTao0Dp0+OtNaiLvj74NMA96wVt4zEHA6ztMvHyGQp3Hct0IcdUFYDPIOMxdFY+GDKD4Io4SQ5qexqh/tS2sjVJ5niEJihacFkRHin07tsx41+eJuh74vy6XvaEHqNoYpbwk51v5oqENSBHrAUwYiC0Ae3d
 HEdrYVK9
 wkcbAl3Msr/A1/C82XzCeTP4OKXR+knvX4UxUScfRjt7aPSNo/PUwPT3KK7c1V0muRpcweU/jgw2vFWejfTHG7CTgB1mE5nSb1uauOtlsePQMuSBA446ix/UFmaMbyYoqWoc4eGWYhzMxnifLyYHwHFqpPi9v9wq9lZ3SsjGqA1SKLZxGUWwKvFZo/S1X13g0KoJe7CCQOV/teBDfxb5V7E3NBAT7I+N4JK3FrZ8VANoluRH2JdMGGuWNZpeUmOnvcJWw7HalJySUbEdhJ+f7krKKrFEBQqTAgi0Iyoc2c+iv/wMvWQsHDNrsuuyMYsGNH8xcHB/bfHDnWCC7PfPUaRvYLeO5zlI7Q7GZwAShyw67VB3l9MY1ZLobCjuk5DNC6QNP8uhXqirRrZl3ixh5SPG4Sx/bhc2WlQgsd2TcPBBs5FA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/21/26 16:03, Gregory Price wrote:
> The dax kmem driver currently onlines memory during probe using the
> system default policy, with no way to control or query the region state
> at runtime - other than by inspecting the state of individual blocks.
> 
> Offlining and removing an entire region requires operating on individual
> memory blocks, creating race conditions where external entities can
> interfere between the offline and remove steps.
> 
> The problem was discussed specifically in the LPC2025 device memory
> sessions - https://lpc.events/event/19/contributions/2016/ - where
> it was discussed how the non-atomic interface for dax hotplug is causing
> issues in some distributions which have competing userland controllers
> that interfere with each other.
> 
> This series adds a sysfs "hotplug" attribute for atomic whole-device
> hotplug control, along with the mm and dax plumbing to support it.
> 
> The first five patches prepare the mm and dax layers:
> 
>   1. Consolidate memory-tier type deduplication into mt_get_memory_type(),
>      removing redundant per-driver infrastructure.
>   2. Add a memory_block_align_range() helper for hotplug range alignment.
>   3-5. Thread an explicit online_type through the memory hotplug and dax
>      paths, allowing drivers to specify a preferred auto-online policy
>      (ZONE_NORMAL vs ZONE_MOVABLE) instead of being forced to the
>      system default.
> 
> The last three patches build the dax/kmem feature:
> 
>   6. Plumb online_type through the dax device creation path.
>   7. Extract hotplug/hotremove into helper functions to separate resource
>      lifecycle from memory onlining.
>   8. Add the "hotplug" sysfs attribute supporting three states:
>      - "unplug": memory blocks removed
>      - "online": online as normal system RAM
>      - "online_movable": online in ZONE_MOVABLE
> 
> Transitions are atomic across all ranges in the device.  Backward
> compatibility is preserved: probe still auto-onlines when the configured
> policy matches the system default.
> 
> Specific notes for maintainers:
> 
> I downgraded a BUG() to a WARN() when unbind is called while the dax
> device is not un an UNPLUGGED state.  This is because the old pattern of
> toggling individual memory blocks is still used by userland tools, and
> will disconnect the `hotplug` value from the actual state of the overall
> memory region.
> 
> Unless we move to deprecate per-block controls, we should just WARN()
> instead of BUG() as an indicator that userland tools need to be updated
> to use the new pattern (the old pattern is subject to race conditions).
> 
> The first two commits are semi-unrelated cleanups that conflict with the
> changes made in the refactoring commits. (memory-tier dedup and align_range
> helper). These are intended to be used for future cxl region extensions,
> but if you prefer them to be dropped or submitted separately let me
> know.
> 
> This is technically v3, but the patch line has diverged considerably and
> I've reworked the cover letter, apologies for prior obtuseness
> Link: https://lore.kernel.org/all/20260114235022.3437787-1-gourry@gourry.net/


Hi Gregory,

against which branch / base commit is this series?

-- 
Cheers,

David

