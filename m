Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2BC2CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 03:07:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A7FE8E000E; Mon, 10 Nov 2025 22:07:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37EC98E0002; Mon, 10 Nov 2025 22:07:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BC2A8E000E; Mon, 10 Nov 2025 22:07:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 18DBE8E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 22:07:21 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA349160386
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:07:20 +0000 (UTC)
X-FDA: 84096840240.08.CF3CDE1
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf18.hostedemail.com (Postfix) with ESMTP id 09FAD1C0009
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 03:07:18 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i2VXkTwr;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762830439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=coZlxvjouzIp2H+RXwQcczehI/L+km+mWX+nuQHuLuc=;
	b=AVdQz9AkSDPCQLbRybXDW0ArS3OxclZ13TMn6gU5kxEe4ICAHbjGvUUmF/pfbEA69ahh2a
	qstRVEc4gc3FtzysKsrvMvYipzX4XQJqF1VHGxBTrCMM5s86vF3xsp5nhbf4Aekg4RlLSU
	oD6Q3VOAcUf629bK5y63CdJwlv+AjjI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=i2VXkTwr;
	spf=pass (imf18.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762830439; a=rsa-sha256;
	cv=none;
	b=CnQm1HdVYw0VB8b3PgHa6TVugKr/JYy9TaYkqqe3c5dSqFlbyoozg+Cne+o5tKVOun8UQ/
	gQO9RABVnb8BXPLk48yE25P/AodO3i3wrxvtctsc4+5oFdx8FqgJpcC7awX4DFKQMohLZS
	imtrk2gqEYATvUTaGxeoslCy1ae++V8=
Message-ID: <982d6b8c-53e7-46f3-9357-afb85319d0a3@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762830437;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=coZlxvjouzIp2H+RXwQcczehI/L+km+mWX+nuQHuLuc=;
	b=i2VXkTwrEj122SnmJM/kZ5RGpk+CzulkvQbubkractg6E7mfog6AeRcXLOdWG1K07xKKJo
	3PSATPpRhFOSR6pWC2IQHDdfj13x4O+rsoI9YBNN/lzT8Lwd9xqxAJvLM96rPpnDJcphP/
	tfysCV3NdMZAEmDE402Rr8RVOpryFAA=
Date: Tue, 11 Nov 2025 11:07:09 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/4] memcg: cleanup the memcg stats interfaces
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Meta kernel team <kernel-team@meta.com>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <aRKKfdN3B68wxFvN@hyeyoo> <24969292-7543-456f-8b80-09c4521507e2@linux.dev>
 <gsew67sciieqxbcczp5mzx4lj6pvvclfrxn6or3pzjqmj7eeic@7bxuwqgnqaum>
 <99429fb8-dcec-43e7-a23b-bee54b8ed6e6@linux.dev>
 <hgf4uciz7rp2mpxalcuingafs5ktmsgvom2pefjv3yogel5dh3@7kkwtrnqotnc>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <hgf4uciz7rp2mpxalcuingafs5ktmsgvom2pefjv3yogel5dh3@7kkwtrnqotnc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 09FAD1C0009
X-Stat-Signature: 5zqjh4he1oykhq5z1bjqt8ea9nzojsmg
X-Rspam-User: 
X-HE-Tag: 1762830438-8727
X-HE-Meta: U2FsdGVkX18gvCxkm+ZEzsJRW7XZ7CpUK/VxTxHjZWyV76nOlmr8w6u75VcetPh3negflcUtRpQyufbw7lcrBskibIJktkvA/dd8PLluNw9BHd54TFgv8BeiDkeX08HY1nJoZqqOR+ooE5WTtUkt/o0U6se1a1P/4kx6+LTJeq2kQlsuE1ezJ/QepU6e0orUTbqzDn8ckZVLJX7VpyXDIDVX83NUcsyCuHgr5Y7tdaN4RwTv43DwwXv/ROGU9pI5hvzrG/svsRJgBMBlUka5yJDmpF4ZUpMsalmWNRHiMKKp3qivqa+AH2+lUAkLt2QyZlK6qmsSFcO4ajCyMmOsVjKLcI7d9NRqk6qfm2k0HsFply4Z5oP+WaJpUPCP5IszNSZbZW1H3dPw6eNNItNtOboBMo3b2tLvptef4j2NGMmyrp3Sz5SFvwXqXVcNLLdMxNPexW5BCenn6tpWg4j4Pik4GSJ/OOoshb+lTi8CFbyP4qUYZS/K46aaTip6n1mZQyUPQEGrYV9wBcUDWHqeZ2InfAGPB+NVXEaCOLz2r39TvGcbGU0QzOeRu/Mjlbz5rmIP9kR0XKN7k+EkI+4TNfKn5kEoCxBQIMCH2+TbJC2p/D1KhaFwLu0PUqly/jkrBFaN0+Gmw4TNyn1nk5Oz4/qd6JQsyPiqymNfDM4wHeK6GFzZszYKgoAwgBMKohZ3g4zJ4IA5zc7ZEhXNsG0rhSp4kPXyIgekYU55vaPkkSEFZa2jPTb0u+IOSdm/s1wAGJfj1TyoM7ZeJrnife8rRVZq0Zw1CkaK90eJlztN201/styW9hX4/mL7ddYSKv5pSBELWFbbQLBK2QezJ9EL2FsWN5KwJtY8WONH2eNfMZf3on8zYXsxOmJ+aWKyATAYIt15CRPgYQvsRKI811bInQwE4Yrdel5BEGN6KMPhZjD+NPZ0+XEmimSvRRodTSrhCtx1xDTb/Hw4yA2Wb0A
 id12jl8F
 wzgCtqMI7lyN8KwB7MX6cswcOHg+kaFUgJACsOFrhWR5G+7wrLaeB7+JpFiuRsGcwaHLEVKFvvOi/U/1Lm7OgRfT7E41nyMOLuOf6+F4Bi8hgpUyGl4yMkCPgfN4m/8iv3ktX6B1mH965/zzeIRR2ZeBCzHB8jmxtFMJFWKoFtmR8SSaF1cGFxXabHouN/mHx+mIJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/11/25 11:00 AM, Shakeel Butt wrote:
> On Tue, Nov 11, 2025 at 10:48:18AM +0800, Qi Zheng wrote:
>> Hi Shakeel,
>>
>> On 11/11/25 10:39 AM, Shakeel Butt wrote:
>>> On Tue, Nov 11, 2025 at 10:23:15AM +0800, Qi Zheng wrote:
>>>> Hi,
>>>>
>>> [...]
>>>>>
>>>>> Are you or Qi planning a follow-up that converts spin_lock_irq() to
>>>>> spin_lock() in places where they disabled IRQs was just to update vmstat?
>>>>
>>>> Perhaps this change could be implemented together in [PATCH 1/4]?
>>>>
>>>> Of course, it's also reasonable to make it a separate patch. If we
>>>> choose this method, I’m fine with either me or Shakeel doing it.
>>>>
>>>
>>> Let's do it separately as I wanted to keep the memcg related changes
>>> self-contained.
>>
>> OK.
>>
>>>
>>> Qi, can you please take a stab at that?
>>
>> Sure, I will do it.
>>
>>>
>>>>>
>>>>> Qi's zombie memcg series will depends on that work I guess..
>>>>
>>>> Yes, and there are other places that also need to be converted, such as
>>>> __folio_migrate_mapping().
>>>
>>> I see __mod_zone_page_state() usage in __folio_migrate_mapping() and
>>> using the same reasoning we can convert it to use mod_zone_page_state().
>>> Where else do you need to do these conversions (other than
>>> __folio_migrate_mapping)?
>>
>> I mean converting these places to use spin_lock() instead of
>> spin_lock_irq().
> 
> For only stats, right?

Right, for thoes places where they disabled IRQs was just to update
vmstat.



