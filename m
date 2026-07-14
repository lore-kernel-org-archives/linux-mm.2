Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AE9AC43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 440E46B0005; Mon, 13 Jul 2026 21:20:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F1536B0088; Mon, 13 Jul 2026 21:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 306FA6B008A; Mon, 13 Jul 2026 21:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B15E6B0005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:20:17 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6050D1401FB
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:20:16 +0000 (UTC)
X-FDA: 84985626432.18.6251227
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8648F1A0002
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:20:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aLPVtxei;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783992014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZctEu+mX1koEkj7iSspmtkQvsQ427myBTirKB+Ofv9Q=;
	b=biiEOoH+ixlAHFOG7rykq5de3hTt8pSAjpTcIduKhlP0oEHH3kWGUHgKI9TzScIkdR3XAU
	GnkLRvQqxyIvnMx9lMb4NhcgJd6sZ+Xuo0E9nwpjSYbqiDqi/jMGyTEtGs9ieGesjZLuxj
	mhla3prwgZaFDHHF9MhEV2SGw3h9mKc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aLPVtxei;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783992014;
	b=bnaTW/CfiRn3juJeWQp8+0FEIAkC9IM2aDJkQeMnQiFU+Bxj9vbMsEB5m6r+SvtwBqIiyc
	Kyog6yr5pz2KPJE0WKO3jwE7j1A0JUMyvnkbGLgqqSwSNkeWr2sjbvB+7RcCOvtBSlyqfw
	nYdeEAGDAO3vWwkUzTaTQTlMcB7Oxv0=
Message-ID: <87dc4105-b98b-4541-bafe-c0adfbf58836@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783992013;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZctEu+mX1koEkj7iSspmtkQvsQ427myBTirKB+Ofv9Q=;
	b=aLPVtxeiDDTh4DfW/RDii/1ZK3BCZDRA8W8VefSwdDDRhy2veEza0ita+eFrzjWOY5Bk0U
	vLbN3hjYA6Wa1jSjTAKTmZn8V8wZFSNkQ3PzQuisAK1lml21UZjnDRdvQqr8v7DUdU0XZf
	mMwk10gxE/Gqd1uGn2LmMbIK2S+jeTg=
Date: Tue, 14 Jul 2026 09:19:53 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/2] memcg: move mem_cgroup_swappiness to memcontrol.h
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 David Hildenbrand <david@kernel.org>, Yuanchu Xie <yuanchu@google.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260711091157.306070-1-ridong.chen@linux.dev>
 <20260711091157.306070-2-ridong.chen@linux.dev>
 <CAGsJ_4y39eSYqYwSPzqcZPk1wcJEYN3HZr83MPv8pMgN8Nct5A@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4y39eSYqYwSPzqcZPk1wcJEYN3HZr83MPv8pMgN8Nct5A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8648F1A0002
X-Stat-Signature: 8ptnabhust47ybet65f1h1bfikjzjpwg
X-HE-Tag: 1783992014-462876
X-HE-Meta: U2FsdGVkX18//3DnhxVmojHAjhbRba1Gbx1NFk2JQh6zqE3rMFqPq3vmuhmOA+0p+urlhgKXCJv2E2/tRfbkd6GtO8SHVv5f3fBzeTCanl83RF1ldhc3RE6uJa3zL6Yuqap6Sb7eDUwqLfaMZ7M42CIKAYhxNMk+WBUyZlKHmJIdPBjPmanvaD2/t2AlSmcLPcy8WWxCLuE/IKG7qF4s1thakw/Z73ZvE5uTM0nRUtpKW4PaWfZQIeOtigWLIr35FyuLZYdfcUpyM6mSgEjT/8mqd21W8VJLaGR1IviE5qKBKoBp3vFwCL3LWs/j3VZ5HlinMandkL1GjsxKN49YRxrMzF/5cStl8dBnJ8nVqC+zH5zc0ewAHZVsCZwseG51lG/x2BUEiellciN7evmJDna9H7nPrN/Qhd5EcohfzuUquI3boy5AVMs0FF0VwxF0FIMuBlYkgGlhJGTREtlZidSDIbxPb28Dkyz0ybL85hzNfhQnq0OvP7GPhpowlXKfOgnjtE61vDcuLzz6lMr7hHV2sYLAALEznNYReTjXdagIuhvUcWTYejNRC3jnY+NRVsALIK8v9IfVzMMHKputKMyAHJBW94XIiWVMBCxPg6n7euM2kTx/gtXQEHHJ3PrMBd5SkBz94FW/0X+Bo4mNxcC/YUJIlgekCtlmTjiYvkm4nplu0tJ1RdqhYRW/KaBX/vv9WMFaJmCWR72KcuRzC+8Cubt8mwzCdsamOM/6luYOo8KN0NWHJoAU/pvuJJ3d/5IwqW4Y4OoqGkG2AMV1xqaJnWiXTGIkAamQqAGlZDEtCrAm2vvotdRCiU2g5KrBs92NL0mSHAeOOVP/biSlYX9S8tRiAhQwUke9Earv9U3mMSU3gAdkmQx83rm53oZHrd8U/MfJI5NeUiabAR6miUgLZ2opXPjr/m2XWRBkqDs0X/IAolE31qSRk8tt3gjMaRv9wzxuDPcxrkwirJs
 4XRw6CjV
 awxBgcUdmzDGdpiDd9yROnDWhAwbxPqFm5Ac63No6PL/z1lKP13iy7aOrFGAkRjsMlejidYvOmVbzichSkJxsmOaLTET5W/AmcEoMjJp+8Iisn7xcqR4BxLW83mCE7ga58PHD1fqCOOeKkFJrPkbXRAOjZ22IKg4vQQ6EVfTngVgR6ChtJ2stW8xGzGc2oX74xXiwyH2C0FqVdonFs7gQ7yIrETakrclu3yEd0UBJFfE6cwQY7Pz8YfuR/ihzPRuYRxFWbLPSlax89JDt5zanfSgkcacwTsklA82bOgEnJ7gaoIxBSyNtETrsNCZ2I3grtQ7Vg93jiJbTyAG42EXtoW5C1XJHwsQBSUR8mQF+Yqpbk6x+JR+ZUdMUZDiZWA5J0NQJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/13/2026 11:08 PM, Barry Song wrote:
> On Sat, Jul 11, 2026 at 5:12 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> The per-memcg swappiness knob is v1-only; v2 always uses global
>> vm_swappiness and ignores the per-cgroup field.
>>
>> Guard memcg->swappiness with CONFIG_MEMCG_V1, and move the helper
>> to memcontrol.h where it belongs.
>>
>> No functional change for v1; v2-only kernels drop the unused field.
>>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Reviewed-by: Barry Song <baohua@kernel.org>
> 
> With some nits.
> 
>> ---
> [...]
>>          struct mem_cgroup_per_node *nodeinfo[];
>> @@ -365,6 +366,9 @@ enum objext_flags {
>>
>>   #define OBJEXTS_FLAGS_MASK (__NR_OBJEXTS_FLAGS - 1)
>>
>> +/* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */
>> +extern int vm_swappiness;
> 
> This is a bit unusual. I'm not sure whether mm/swap.h would be
> a more appropriate place for this.
> 
Thank you for your reply.

The vm_swappiness variable is not utilized within mm/swap.c. 
Furthermore, since memcontrol.h does not include swap.h, retaining the 
extern int vm_swappiness declaration in mm/swap.h will result in a 
compilation failure.

-- 
Best regards
Ridong


