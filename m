Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5B36FF495E
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 14:20:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61C66B008C; Mon, 30 Mar 2026 10:20:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D130D6B0095; Mon, 30 Mar 2026 10:20:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C012A6B0096; Mon, 30 Mar 2026 10:20:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A91286B008C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 10:20:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2F7F05AF70
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:20:29 +0000 (UTC)
X-FDA: 84602939778.21.D32628B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 64239180009
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 14:20:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pXcZ+7fn;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774880427;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DQOnBMo6myTBWuwwVXUejcUTlDnJXzgOth+SIio0eSo=;
	b=WZBkbDpgJ7Tb2InoSl1aUJqUdPTNlrmXoW+xNOunOEAmye2mO4zXDRHoYAv6Ci0C0ovhs/
	UYbS3rHseHj5lpm3Qaz9Zrt3IDoh5Dnz03gfxOTY+0q6a+yQv361pnCHmrAxW0mHKI1Voc
	CSmvG+OGoMgNI9xcy2BfuXZ3r57SgPQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pXcZ+7fn;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774880427; a=rsa-sha256;
	cv=none;
	b=7/l+U0NBgMgl5Gc2ePUazYjcZakADgQne82uRw18UQm3il+VbnmHUBq94oDICDEGctEOx2
	VvOXNJCec7+V5pFX62k63+36muTCbN5Ra6VxWgiTI8wEfEfa9C+GH0MyXuuZ3xdSFn18kO
	CP5V1CAi6jgyPvPyeb7X3eYADP8dL2M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DD0FA60054;
	Mon, 30 Mar 2026 14:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D420FC4CEF7;
	Mon, 30 Mar 2026 14:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774880426;
	bh=06bf5S3/WSaRWoCBlnC2mh9au4sOQz5mO11EQY3Buns=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pXcZ+7fncPEcnrzkSfN6YMN6OGr061xooYBr65rWkkI8sB/QKQ/qimT6UI5BQGz0r
	 YXuf43myE3joGOPmz60hD2l8+GzzUiu85x93Cf9J2oZBZJG5h11ERYxW1+j6IeWFMv
	 D8KERD1V78j0ECVlK0ByYkH5UkyBI5W8S77NkMVD/OVgzs7O/0S9kAUKM6oG2ArqvE
	 eRSjC2TuVo2bykiLZmpPufFgHEvywx/YEYYj6TLH1bHsqEYAZ8CaJ9T5q7WdVlDHQR
	 qT5gl++rEnuydu/LUPFKdINEFnkRqUgv4i7TBNDPFv/nthgbVhBI4+KrViH4VtuwAF
	 GXMJozgEcc29g==
Message-ID: <5de08585-fd2b-4395-b421-99c7b887aa8f@kernel.org>
Date: Mon, 30 Mar 2026 16:20:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory_hotplug: maintain N_NORMAL_MEMORY during
 hotplug
To: Hao Li <hao.li@linux.dev>, osalvador@suse.de, akpm@linux-foundation.org
Cc: vbabka@suse.cz, harry.yoo@oracle.com, joshua.hahnjy@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
References: <20260330035941.518186-1-hao.li@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260330035941.518186-1-hao.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 64239180009
X-Stat-Signature: dyn3w98attciwqjb54cdj7cpqzi1fb7x
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774880427-916411
X-HE-Meta: U2FsdGVkX19/98Tc4iG4dD4M79hKwej8FlrvcMEpzamWUXM+Hqm8i76jp0c9uoZHCQnmJko6PJkh4HEhK7LgXsRf/aqYTBquTZdGrm2xJkVp3yi13ZOexP2VTJijk5fl24R8M2m0pO0D6XccxK3IHq5p6ExC0jKV0YckLkt6VzxLMBi7965K049iFB+gS+TATej2CkU8rwVNpSQYllpBag7nf4sPKtF5455b98oNmjsCExDNsbKVDisLDQu0tTvUisxw20iLRK6J/wUWN2l1DwdZheYGJFXE/VKWDXCMu4DXRCSeTnxGKQXaOLGOY3P/MqXk0R6TXB4dXB7OqRw6gd/tSftJME/MWb5ZdXmj55hWkRlTN/gu8j8TkN3AtY9fa5JrS2WQ/wdkLYILTQdNd7/7bsNP4mfQKbRGQ9cp0ImuQcbrzIfymMIW7Yyh+fCkHF04V6lRI6B/SJ++C5op5K32bFT7pLMOadnEi9/syJaRqWagpHkRrrebMLJLMLb/dTEgi7hwqe/9eTXwKFqa+znnlRLFQCFR57+JvZAe5X07QHI4Wr15jmy31WvZE0YZoAP3N1qD08ViLDXpu60PoZ4zBiuMuQweJH7R5gqrOfZLBQx7B2VtjpIJAYSChxD4Hj9ZsYSM3Oz6WW17sGCJpSlS5Ec8OPFN4ruNBl37asUMg03HJTWz6ofO3P2uVXHYIgFELXqvaM5eDEY2y/VuMcoJlSLW8DV25qVNBh6deu3b+iLGHsjHSC17f/emc4voMxnWSXg1uaIs6b9uCdsvpZR7SIq4ECrgnY6EIgQ5ZNmOKv1Q6VuuFaUV9h5Shw2bpoKidg8jordgq3Hx3h/B0GWemKgXUgaH/7bcTveEifUO3LxaPv1/F6n5ryU7aecTN7QoNC8rACFtZtJTzUmkTkyZsO9M+afW45DIXF0NRK4W3Ki6QMsg59NmPD5OnaM0nlzh5UhPasZ+UHzIvOk
 smrlQsyf
 m2rg83bUncckxmtoV1TGVUgZymY5SWeNb32nr6YHn2x17B5M5lZKzhrC/KbF23H2pR3x02swI0mn2w4DyG0lnLEVQRMWjKiPMZ5YbPxKXamjMEQ+A8f9bzr7TUjhHn428rBifHJtFj9XijxOniFySIA+p30EOysbjezTAulY3ULsgF36g8tToB3boRwgVQdOfBkA+TDCEVjwVBvOH8dWHTNt6qAjjRdisPyPCtMltZo5NCyBtg0584tfl5g7M0b0dcA4vX5aqvL3wQFWdQrkk2B/qBLTk12faxi+Kc7HhBr51+cUDcO+MtWAMWQtYwjir2hwcfawtMgTMFFQfxE6u2qk2aTqhazD/GohNnC7psbnCDH6IgsDCjXyH5o2CIRP+6RjbBDfsY6pc/JBVnmrixp9mXIcUSj+n3cxLAHkbFpYodt8kBNsiLFqoXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/30/26 05:57, Hao Li wrote:
> N_NORMAL_MEMORY is initialized from zone population at boot, but memory
> hotplug currently only updates N_MEMORY. As a result, a node that gains
> normal memory via hotplug can remain invisible to users iterating over
> N_NORMAL_MEMORY, while a node that loses its last normal memory can stay
> incorrectly marked as such.
> 
> Restore N_NORMAL_MEMORY maintenance directly in online_pages() and
> offline_pages(). Set the bit when a node that currently lacks normal
> memory onlines pages into a zone <= ZONE_NORMAL, and clear it when
> offlining removes the last present pages from zones <= ZONE_NORMAL.
> 
> This restores the intended semantics without bringing back the old
> status_change_nid_normal notifier plumbing which was removed in
> 8d2882a8edb8.
> 
> Current users that benefit include list_lru, zswap, nfsd filecache,
> hugetlb_cgroup, and has_normal_memory sysfs reporting.
> 
> Fixes: 8d2882a8edb8 ("mm,memory_hotplug: remove status_change_nid_normal and update documentation")

Agreed on CCing stable.

> Signed-off-by: Hao Li <hao.li@linux.dev>
> ---
> Changes: simplify the code. (Thanks Joshua and David)
> ---
>  mm/memory_hotplug.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index bc805029da51..05a47953ef21 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1209,6 +1209,13 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>  
>  	if (node_arg.nid >= 0)
>  		node_set_state(nid, N_MEMORY);
> +	/*
> +	 * Check whether we are adding normal memory to the node for the first
> +	 * time.
> +	 */
> +	if (!node_state(nid, N_NORMAL_MEMORY) && zone_idx(zone) <= ZONE_NORMAL)
> +		node_set_state(nid, N_NORMAL_MEMORY);
> +
>  	if (need_zonelists_rebuild)
>  		build_all_zonelists(NULL);
>  
> @@ -1908,6 +1915,8 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
>  	unsigned long flags;
>  	char *reason;
>  	int ret;
> +	unsigned long normal_pages = 0;
> +	enum zone_type zt;
>  
>  	/*
>  	 * {on,off}lining is constrained to full memory sections (or more
> @@ -2055,6 +2064,17 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
>  	/* reinitialise watermarks and update pcp limits */
>  	init_per_zone_wmark_min();
>  
> +	/*
> +	 * Check whether this operation removes the last normal memory from
> +	 * the node. We do this before clearing N_MEMORY to avoid the possible
> +	 * transient "!N_MEMORY && N_NORMAL_MEMORY" state.
> +	 */
> +	if (zone_idx(zone) <= ZONE_NORMAL) {
> +		for (zt = 0; zt <= ZONE_NORMAL; zt++)
> +			normal_pages += pgdat->node_zones[zt].present_pages;
> +		if (!normal_pages)
> +			node_clear_state(node, N_NORMAL_MEMORY);
> +	}

Was wondering whether we could just do an early exit, like:


for (zt = 0; zt <= ZONE_NORMAL; zt++) {
	if (pgdat->node_zones[zt].present_pages)
		break;
}
if (zt > ZONE_NORMAL)
	node_clear_state(node, N_NORMAL_MEMORY);

But ends up being harder to digest (incl. all variants I tried :) ), so

Acked-by: David Hildenbrand (Arm) <david@kernel.org>


-- 
Cheers,

David

