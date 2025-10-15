Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5D9CCCD192
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 13:57:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 048828E0036; Wed, 15 Oct 2025 09:57:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021188E0015; Wed, 15 Oct 2025 09:57:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9FAC8E0036; Wed, 15 Oct 2025 09:57:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D34CD8E0015
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:57:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84188140188
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:57:38 +0000 (UTC)
X-FDA: 84000501396.13.741280F
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3BD7340009
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 13:57:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=GTRNRPra;
	spf=pass (imf27.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760536656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UoCSU4XyYx59fD12dxoPWCIwk1oQ2hfxBjxFdeb3MWY=;
	b=Edjfkg4mbtVrLiuA5owNIxSjaOU/l4of3f2T8CM2Viw1J98bfNAG9v4Y4rJmb0LSKRVYE4
	7SqRyb4K/loM8UAgoxAhglSySUJglTOQ4jctAvjB3R0wVYLc7OL3bRqJqbfcHwRjTRaEE6
	whiwCBz4liYNOJ4aoESXl2IViaiX8Yc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=GTRNRPra;
	spf=pass (imf27.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760536656; a=rsa-sha256;
	cv=none;
	b=wwAG4kdSiO/psgLylsmq5BuRo8YGvJPPWk4/muJrz08YJIgJIg8WDnjVpHQO2d9ewglFy8
	Snk0Ej1apFcHClxMQ5lEZpoKfenDuRh/YW57Q/TjhfSmoHTKk2566aaCm/lkc9LAstjrZA
	HPOVuWKDqySa1XnMLm3L8/eXoCYBflA=
DKIM-Signature: a=rsa-sha256; t=1760536651; x=1761141451; s=dkim2019; d=cdn77.com; c=relaxed/relaxed; v=1; bh=UoCSU4XyYx59fD12dxoPWCIwk1oQ2hfxBjxFdeb3MWY=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References;
   b=GTRNRPra9zCnXGizQYbz/tnpG+eEpB/eReNgN4avTVOY25rovQ4/A57OZYw69x3YXXqieJC6zgIOzGJ+sjAxmIGpDsp8/5iLWU64ArpDNbyBC7z1gQ0X3IspmfhNYeN72xRF65U1keYTDEYYgXqqjvNkB8WBk3bHHXkw4oUeZ6Q=
Received: from [10.0.5.28] ([95.168.203.222])
        by mail.sh.cz (14.1.0 build 17 ) with ASMTP (SSL) id 202510151557309450;
        Wed, 15 Oct 2025 15:57:30 +0200
Message-ID: <5e603850-2cfc-4eb6-a5cc-da5282525b0d@cdn77.com>
Date: Wed, 15 Oct 2025 15:57:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] memcg: expose socket memory pressure in a cgroup
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org,
 netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Matyas Hurtik <matyas.hurtik@cdn77.com>
References: <20251007125056.115379-1-daniel.sedlak@cdn77.com>
 <87qzvdqkyh.fsf@linux.dev> <13b5aeb6-ee0a-4b5b-a33a-e1d1d6f7f60e@cdn77.com>
 <87o6qgnl9w.fsf@linux.dev>
 <tr7hsmxqqwpwconofyr2a6czorimltte5zp34sp6tasept3t4j@ij7acnr6dpjp>
 <87a5205544.fsf@linux.dev>
 <qdblzbalf3xqohvw2az3iogevzvgn3c3k64nsmyv2hsxyhw7r4@oo7yrgsume2h>
 <875xcn526v.fsf@linux.dev> <89618dcb-7fe3-4f15-931b-17929287c323@cdn77.com>
 <6ras4hgv32qkkbh6e6btnnwfh2xnpmoftanw4xlbfrekhskpkk@frz4uyuh64eq>
Content-Language: en-US
From: Daniel Sedlak <daniel.sedlak@cdn77.com>
In-Reply-To: <6ras4hgv32qkkbh6e6btnnwfh2xnpmoftanw4xlbfrekhskpkk@frz4uyuh64eq>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CTCH: RefID="str=0001.0A2D031F.68EFA84A.007C,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0"; Spam="Unknown"; VOD="Unknown"
X-Stat-Signature: mpxq8ehuy1mzgsukotqgggtmy6kyj1pd
X-Rspamd-Queue-Id: 3BD7340009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760536656-793765
X-HE-Meta: U2FsdGVkX1+mJ4HXkYbKcNouMrFGeiI4BGZEjtfh6iCh5FOlfjg55tyBjuRpzNFsBckpEWoH6c9xfTZI3raovM5SYG+IYg3nKncftT+tQPKu0cc1mWVm3VsW27dvBoOneHV4UsXRq/nr7fXjJPJEG36renT0IRVYqTGEdDkAIJChUIPaSYWdzPponotTAsNowgADUcxmaaz8PjikXjrTefmWEPCFvSK0UNhqD7rmneIp9vSvmlaz0uuSRNQo0OdefLX+s4mGNuqwzuLyzgvi1Bd5G9L0zW35AoMpPZfG6ljDeRTq3rkOWKCq4AIT17V88SWzWuwjJPWTvF9k/dZe9CJTZF7uZARxLZO8c2HD8rxt+gUHKMTa56dFpyIW7a43Pl3QKPVhWnYuwSocjdMwu+n3+BXQBf4Qqf5fcrD59FUVmv5HeDezt0Cx14fmBG9wFUP1rAssI2vM3MKz5ZW5y23dXPjZTWRmTTAb4WXv51dIIl+KEkyiaQa6AvH7orHUz2iaduuSZVAYOx+9+mWUMV/Uv2JXEwdRWKhzBylkhGGY2NopoifxJjaGZNz+f6u27BlJgrB+uid3dECmuyirHbTXDmKYAy/oyYXHxvnvc32M9gDy+LOPc1uDLSPbbQUMQLSXsm5oAi+tdgLpRwHrGQ1S5gOLdOgaGBC2E3iTfIj3K7PoGQZkssz9cKOc9gzIlc9bOz2bTicmoBfxhpR4U3Lgd3kkVoMeJeDP+lrQEjt2pochOjYeQvAox+lzEoW8/+8M9WXlO8Ih6ZLTAwUVWp1mhXW/hJvZ/o+NlG5PRF5gvFcAONR2RW59VvxINuzg4P6hikB+eDihXq66yEXER/4eCrvGvYR98q1PpxogQByB4F2gui36hXfA510lF5g3s3J3ZhnCN2qYJYeP0ZqZb70AL1mnhX/MTKIoziARtj7k8CVFTpf27sEs+ffc6e/12eOMvRHO7fuK+H2tGeN
 DNanDhMu
 AHkfdI7gtbOHQYtNPlqedv4EoLUPcQXGgk319re5kjVnLsxOZJTrwtELNXG2Brh71BsdWw+6TwUHpCqyJJTfNCyzsAOgtduguVlKWEWKbKej0BYuyipHsH2gr0/xF4NVBlvPkoJCrFTJ+w/p9alMi6AxOmULDASzTNiQajXtdAPqPF8k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/25 10:32 PM, Shakeel Butt wrote:
> On Mon, Oct 13, 2025 at 04:30:53PM +0200, Daniel Sedlak wrote:
> [...]
>>>>>> How about we track the actions taken by the callers of
>>>>>> mem_cgroup_sk_under_memory_pressure()? Basically if network stack
>>>>>> reduces the buffer size or whatever the other actions it may take when
>>>>>> mem_cgroup_sk_under_memory_pressure() returns, tracking those actions
>>>>>> is what I think is needed here, at least for the debugging use-case.
>>
>> I am not against it, but I feel that conveying those tracked actions (or how
>> to represent them) to the user will be much harder. Are there already
>> existing APIs to push this information to the user?
>>
> 
> I discussed with Wei Wang and she suggested we should start tracking the
> calls to tcp_adjust_rcv_ssthresh() first. So, something like the
> following. I would like feedback frm networking folks as well:

Looks like a good start. Are you planning on sending this patch 
separately, or can we include it in our v6 (with maybe slight 
modifications)?
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 873e510d6f8d..5fe254813123 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -52,6 +52,7 @@ enum memcg_memory_event {
>   	MEMCG_SWAP_HIGH,
>   	MEMCG_SWAP_MAX,
>   	MEMCG_SWAP_FAIL,
> +	MEMCG_SOCK_THROTTLED,

This probably should be MEMCG_TCP_SOCK_THROTTLED, because it checks only 
tcp_under_memory_pressure, however there is also the 
sk_under_memory_pressure used in net/sctp/sm_statefuns.c:6597 to also 
reduce the sending rate. Or also add the counter there and keep the name?

Thanks!
Daniel

