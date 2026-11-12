Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AE904606A885
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 10:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mVR6HgOg
Received: by kanga.kvack.org (Postfix)
	id D41726B05B5; Thu, 12 Nov 2026 05:55:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF1D76B05B6; Thu, 12 Nov 2026 05:55:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1296B05B7; Thu, 12 Nov 2026 05:55:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 951716B05B5
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 05:55:13 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D766C140531
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:55:12 +0000 (UTC)
X-FDA: 85426160064.15.05B350C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 0A96DA000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 10:55:10 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mVR6HgOg;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794480911;
	b=V2J7cfH/AiiTHK5Z74OOdYVRTfFBuei1k7oTmsKY7df8ePFqt47TaNzIeSWbPj86Ducm53
	Skx1SUD3yrDGooZlCHWTsExBuaVM4RMxy3HzvH0Obll0avLmJRplP0F9saJ51AZ1d7JdMT
	ECL2AfPkX/taBwNawATVHPng+VbnPCM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mVR6HgOg;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794480911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hBBRka0fgdENvERIYsPzoLXmI7OdvHBhAV6rADe9TMQ=;
	b=k/3aQGMepdgPbU04ynhYhQlIsr8rduVxcl2voleezJjTlMPEi+ywr69gBcbx6kXeOyzTxQ
	7kk0OJYz5t28HKU4iX0m4ewow9z2TduRVv/D8An+2/dXUFuBZCok7ill5nWjBVZHXDNZgZ
	m8nno0sJZ+mko4UnPC2e53EyTIFQWa4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 328BE403BF;
	Thu, 12 Nov 2026 10:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 735FB1F00A05;
	Thu, 12 Nov 2026 10:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794480910;
	bh=hBBRka0fgdENvERIYsPzoLXmI7OdvHBhAV6rADe9TMQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=mVR6HgOg/ceImyZhmMvUyCD1gCi9KdMcx9kDP6BtyYopaWHif25AK0lFQXIz3PlLm
	 zvj/wn+r8mOdfmobgmEkg1F5syvIhoNuPdQ0wq/7Bt4XHmUBfShWInqaA3hMM0qgAk
	 bCf+ouF4iY6V9bVOC1ovlXEnT7k/BLwoWZoFLHA9hnQ8Yln0CfvmEvcWw3Uhd4/CQL
	 R3wgbLkxrrOeBi8R+QVPPIlQ6OpYmhYd7Z2hIKu7PV5KakhWIHd6htoTsjaYROEZP6
	 1fsO3oSdzbA9kWGhJD8pLIphaoAQSehJAY1gwsvr18zimH2uEhz1LPhYVDHRsm92/Y
	 ddIb4UYpAYEUg==
Message-ID: <9d1fa2c1-7090-417f-adfc-0b128c37622e@kernel.org>
Date: Thu, 12 Nov 2026 11:55:05 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] memcg: flush nr_charged_bytes when the obj stock trylock
 fails
Content-Language: en-US
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand
 <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Meta kernel team
 <kernel-team@meta.com>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org
References: <20261112013220.4064478-1-shakeel.butt@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261112013220.4064478-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0A96DA000A
X-Stat-Signature: yfkma687n3dqwtagoizkq3wubpap8fzo
X-Rspam-User: 
X-HE-Tag: 1794480910-84200
X-HE-Meta: U2FsdGVkX1/V0dleq4vHpnLR8uH8t9vl2QDBGFx49Rxk//0A/EtNaRAO7URZuUTU1bymuwDrpp+7nx4kKlLg3gqWENHsogr+ihVzYww42Xg/lBvgDwIr8HMUzCNLak8o/Ih+KP8zDogP9lEzApa1VCjz7LBUKPYiFElhBAAsO2KrOwySNUm3oEKgAfprRNnNBJhbRDnAcvCBsx9S2x3nWRCn49mQxwOUN5+nlrs2cTqbOSrrsF2UlNfGA3PF3kDY4IciF9mlpNxLa6xJncMQRGk3DfeGVTtLreR6/HoWhMMOyDYd1KchsUuaOTFa47i9SYTUVHjQQth5IqPr/UVWwf+enHP8J3rJkkgx63rVQZI/0VCApfe52zTzE6kH5M7GP0YDNrG0TicPpo9U/uFGWbvnNszU/bVsux1SpcmQfbTEQlwqDiqu5oMpDtWfVOrs7BEZpieQlNx0PaFBS3ap5T5yBxV4aLDWy7t0LruqmfwsHVxgTkHU+loclpM3LeliyHM6cGlhSJIuuTibE6eETmSI6TNotQl6KlekadgNmrhhktImU07zk/xaBSuXTqp4HF6iXDH3MuNT0S6LEkOlZSCCY90KT6t0Yie+7JDZ2T5eMG4Smhbz1908jJkwfvGCD0W21+ds0ggWI9xZKh7fLV6yANth7pJBW6go1xmpkVurfyvtPYTfMhNL1qN95/jAIhe2czcpZYCt7aM/y5Sjzf+42xoexrck95jiZnMvqtnVoKhK90NDD5X0nORiB10hXzhaSc176P6XWkwsfBx1Pcu03xnao4fhLpRAe2tQgb7dYvSbffDBmaG6kFG86baGtwyLA1aISbOt73xiP9DIPrNFG2y4rbWocne6Ji2023i7KpbMm1OJCVL+NWYFwZdnQgXymxhUQxkMHgdsU9TGfhJYGv2c/nELx2MwaskCWqSH4c/zsI16SzY8ImSyTlPWw+ikU6lvXlo9QsHcYZK
 Vo+Eo+L+
 Dcr4wADOEVjns9dcaUx7d6csiIZ9YbiprntLdr21Q5V8CvLiH8Pj7OOHH/Dsj4Wo0o5VP/BLZEOqAa/RRSp4Vw9d1sDgVWc1wWOQbRA2etIMlNAsmkorbO+WCESSxOWrNehm6HS9vSWzoApeVpDlSLeQN6vNoDyMEzGUqbVAr7tnEWWW24Bb1Z3AiAbeXUFg3Bg8Hz0Q1b5dTH8VHnu/NEdg70hStXpQlLsK2IBRX7yZwQhQHbtHnWmkret+5QNEFzDU4XbC9n/RccQv0El2g6KlXsvUrN/OyVBcruGXDWCzBJfTl36VojSMnp4P1XgdNtOVYv78C1z8OcVo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/12/26 02:32, Shakeel Butt wrote:
> When interrupt code, such as an RCU callback in softirq, runs on top of
> a task that holds the obj stock lock, its trylock fails and the bytes go
> to objcg->nr_charged_bytes. Nothing empties that counter while every CPU
> using the objcg keeps it in its stock, so it can grow without limit.
> 
> Users see memory.current and the "kernel" field of memory.stat keep
> growing while the cgroup's real usage does not. With memory.high or
> memory.max set, the cgroup is reclaimed, throttled or even OOM-killed
> for memory it does not use. The counter is 32-bit, so after 4 GiB it
> wraps, and those 4 GiB stay charged to the cgroup and its ancestors
> until reboot, even after the cgroup is removed.
> 
> Fix it by uncharging the whole pages in nr_charged_bytes whenever the
> trylock fails.
> 
> Fixes: 200577f69f29 ("memcg: objcg stock trylock without irq disabling")
> Reported-by: Chris Mason <mason@kernel.org>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Cc: stable@vger.kernel.org

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/memcontrol.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index f5f567f7d4a9..091401cecf39 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3553,6 +3553,8 @@ static void __refill_obj_stock(struct obj_cgroup *objcg,
>  	int i, slot = -1, empty_slot = -1;
>  
>  	if (!stock) {
> +		nr_bytes += atomic_read(&objcg->nr_charged_bytes)
> +			? atomic_xchg(&objcg->nr_charged_bytes, 0) : 0;
>  		nr_pages = nr_bytes >> PAGE_SHIFT;
>  		nr_bytes = nr_bytes & (PAGE_SIZE - 1);
>  		atomic_add(nr_bytes, &objcg->nr_charged_bytes);


