Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE69C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 10:22:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CAFE8E0005; Thu,  7 Aug 2025 06:22:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A2528E0001; Thu,  7 Aug 2025 06:22:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DF6D8E0005; Thu,  7 Aug 2025 06:22:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0BD1F8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 06:22:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D1D271A022C
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:22:11 +0000 (UTC)
X-FDA: 83749571262.01.E2EA1FE
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	by imf13.hostedemail.com (Postfix) with ESMTP id 96B0F20006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 10:22:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=7OrwcfrK;
	spf=pass (imf13.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754562130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UA01ZK7YVnyKFfoAYOxQGgqOGupBnkexzr8LbdxiehY=;
	b=tzDS/T8EO5Rh93vQkIBEaTMCDRpyE1+TsPNZJ1lGy8QBpQu0ZBK5vF7cU7TjoAX2MCZJDx
	4A7VuPXFfk9CQs2co5y8RH26fRawM74TTOwf3zjSeLXeQnmGEGQ4ha3djt1OcO2Tc+4Hht
	mzToQsdkjQcNjvMjJ5K085JaocinvN0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754562130; a=rsa-sha256;
	cv=none;
	b=HPFy8imZjCww6vUXWDpS1VhLmg5d22Y/xolTRNnp5IJjpl6RhVIhRHp9XM9VqdYYcfke+k
	7CbtG4oNNa7RsDB5K0G99auOI7o5XdkvF6/17ysIrRj4WX3T061QhapXz9D96sqwhoTufX
	9tpvdF8QZEsFU0KsTiOO+6f2WQJHAxM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=7OrwcfrK;
	spf=pass (imf13.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
DKIM-Signature: a=rsa-sha256; t=1754562125; x=1755166925; s=dkim2019; d=cdn77.com; c=relaxed/relaxed; v=1; bh=UA01ZK7YVnyKFfoAYOxQGgqOGupBnkexzr8LbdxiehY=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References;
   b=7OrwcfrKJV0FeENW6OBLqjmfQFZVrhBSb/hdRQXsWdHAjQ3H9fAQIWbf6piwCvXzs+lmG7wRAqW8Wx76B/mahwB9XlVVP0zFRuMWkxyQmYss2BxRsbS0avNG/TF5m4SFxZkHEIPnxUPgbkpLvpWsaffyaOlUzO1zO5k2XJZVFCY=
Received: from [10.0.5.28] ([95.168.203.222])
        by mail.sh.cz (14.1.0 build 16 ) with ASMTP (SSL) id 202508071222029266;
        Thu, 07 Aug 2025 12:22:02 +0200
Message-ID: <0f6a8c37-95e0-4009-a13b-99ce0e25ea47@cdn77.com>
Date: Thu, 7 Aug 2025 12:22:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
To: Shakeel Butt <shakeel.butt@linux.dev>,
 Kuniyuki Iwashima <kuniyu@google.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>,
 David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org,
 netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Matyas Hurtik <matyas.hurtik@cdn77.com>
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
 <fcnlbvljynxu5qlzmnjeagll7nf5mje7rwkimbqok6doso37gl@lwepk3ztjga7>
 <CAAVpQUBrNTFw34Kkh=b2bpa8aKd4XSnZUa6a18zkMjVrBqNHWw@mail.gmail.com>
 <nju55eqv56g6gkmxuavc2z2pcr26qhpmgrt76jt5dte5g4trxs@tjxld2iwdc5c>
 <CAAVpQUCCg-7kvzMeSSsKp3+Fu8pvvE5U-H5wkt=xMryNmnF5CA@mail.gmail.com>
 <chb7znbpkbsf7pftnzdzkum63gt7cajft2lqiqqfx7zol3ftre@7cdg4czr5k4j>
Content-Language: en-US
From: Daniel Sedlak <daniel.sedlak@cdn77.com>
In-Reply-To: <chb7znbpkbsf7pftnzdzkum63gt7cajft2lqiqqfx7zol3ftre@7cdg4czr5k4j>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CTCH: RefID="str=0001.0A00210F.68947DBB.0039,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0"; Spam="Unknown"; VOD="Unknown"
X-Rspamd-Queue-Id: 96B0F20006
X-Stat-Signature: ztgdqjqokcr3dszpumuun6yz43bciz6w
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754562129-319609
X-HE-Meta: U2FsdGVkX1+IcfZ4F4RLAbVdadQYTNaojX6m5pExYOiQthEIJbGf4qAi78qQGiuGlp7/6ZXnMiROD9JmXdpqeXDbLDas13cNb02SRqKLmYICRHXi71GsJCVwAGRvQ+p4uHX4v26f2KSgww2d3guMl6Tn9F73z5TE0+ZmTpnMVWxAsmBYcIP3CZunk7jK8KWGUWaWRO+YzTxounOl6lpeXDrrOWK8gXIivCoBr6ThhJVHKsugX9b3jkzPHBBYCpV/1f9F7iHgF82ULjk7IDMgyoK3JCs17+yDzSkdKeyCWQXggnbdvdsy7gwHO01HU8Jsy4hyw845+EjxlSXNjS/2ZBUIuQMAppCcqeSC3l/FqZnQIJHqX79RNpLOR/k2iinaUZlySMDxkJeUEMGN4HgGQ4n86EM3Ntf1l84Jq2H8vJWVhgKu2SP2UzarK1yR1TiTQ6yUM2YGJh9Ww2R7UgRSXLgGYhbQDiUM/m+XSB9fl37e8uC3sDEbufuXmhV9RJQJy10wH+ijjKiR91Cf3TuipVpEiCQ7CnIUG4EMzPKPNxch1UCOmdxBcdbLi+b382OwD2joxIINBBaAJlW+EgT8Ez9/GuhMWTs4RpKhDG0gfoPPpCYahdhCKGsvsXnAzOk+TvdNaQduwhCif8BC5w6UeurSjaCcKEpWjM81bJmCBXQdpNjEmbxSfIzzKMtDIz9xtKz32v7AX7Bc2UfIkXfcxT1eb0Su1mLVWSZsa3KcQcd25F6QeOLPZDPqZb6SYEAEK1aq8eMQxdgq9BsFEidyEwzEdHrw2O8BWIrTrSrbTkKZIygW3vOLTP3Kc9HUkNQuk+mk0Ugq/vF2fnZUaXceZBIt9DXEhGicQSEfSFKVb8OCQyfXh4gVElOoBbIaZlQkLqgbKZ7oP+ndY/XbQxW5NwkpF17ogtpyWlzJWl5Oslo7ybN54aFa3hkDsAJVkElFK0mKneyf/TYtcEqNEwk
 W1dmWsH1
 6CjRzJnRY0tTvEI72fGRq+2H6ASSqWcZmZR9P4PARtQV+nki6ORgN93TmbCqle2YgWJn8qtgimobjU3DcaZoBtYchMvKSNJUCHFRkSCULbkAVVb10b8+V4X33KluaOnXOgiB7drYI5d7byjkHKytASs3/z5l3m0sgA7llpEGGVHTbif674IuXcgkZZoMhbDY2U+ih46Rnt4LzkLouuQfb2gRcVjtbO8TwJXat0FcvTLeMEUQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/7/25 1:34 AM, Shakeel Butt wrote:
> On Wed, Aug 06, 2025 at 03:01:44PM -0700, Kuniyuki Iwashima wrote:
>> On Wed, Aug 6, 2025 at 2:54 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
>>>
>>> On Wed, Aug 06, 2025 at 12:20:25PM -0700, Kuniyuki Iwashima wrote:
>>>>>> -                     WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
>>>>>> +                     socket_pressure = jiffies + HZ;
>>>>>> +
>>>>>> +                     jiffies_diff = min(socket_pressure - READ_ONCE(memcg->socket_pressure), HZ);
>>>>>> +                     memcg->socket_pressure_duration += jiffies_to_usecs(jiffies_diff);
>>>>>
>>>>> KCSAN will complain about this. I think we can use atomic_long_add() and
>>>>> don't need the one with strict ordering.

Thanks for the KCSAN recommendation, I didn't know about this sanitizer.

>>>>
>>>> Assuming from atomic_ that vmpressure() could be called concurrently
>>>> for the same memcg, should we protect socket_pressure and duration
>>>> within the same lock instead of mixing WRITE/READ_ONCE() and
>>>> atomic?  Otherwise jiffies_diff could be incorrect (the error is smaller
>>>> than HZ though).
>>>>
>>>
>>> Yeah good point. Also this field needs to be hierarchical. So, with lock
>>> something like following is needed:

Thanks for the snippet, will incorporate it.

>>>
>>>          if (!spin_trylock(memcg->net_pressure_lock))
>>>                  return;
>>>
>>>          socket_pressure = jiffies + HZ;
>>>          diff = min(socket_pressure - READ_ONCE(memcg->socket_pressure), HZ);
>>
>> READ_ONCE() should be unnecessary here.
>>
>>>
>>>          if (diff) {
>>>                  WRITE_ONCE(memcg->socket_pressure, socket_pressure);
>>>                  // mod_memcg_state(memcg, MEMCG_NET_PRESSURE, diff);
>>>                  // OR
>>>                  // while (memcg) {
>>>                  //      memcg->sk_pressure_duration += diff;
>>>                  //      memcg = parent_mem_cgroup(memcg);
>>
>> The parents' sk_pressure_duration is not protected by the lock
>> taken by trylock.  Maybe we need another global mutex if we want
>> the hierarchy ?
> 
> We don't really need lock protection for sk_pressure_duration. The lock

By this you mean that we don't need the possible new global lock or the 
local memcg->net_pressure_lock?

> is only giving us consistent value of diff. Once we have computed the
> diff, we can add it to sk_pressure_duration of a memcg and all of its
> ancestor without lock.

Thanks!
Daniel


