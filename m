Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF44FC4450A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 14:54:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 012F86B0005; Thu, 16 Jul 2026 10:54:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C0A6B00E7; Thu, 16 Jul 2026 10:54:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1B3A6B00E9; Thu, 16 Jul 2026 10:54:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AA0466B0005
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 10:54:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DA004A0035
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:17:22 +0000 (UTC)
X-FDA: 84994388724.02.5BE3269
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id E55321A0005
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:17:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="iw2ftw/N";
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784200641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hTG6hGzVl0dWfit8w/MB62E4ZbeaEHmlylI6bepXRC8=;
	b=4Nx4tBJDej5q7MJ6H9I7HJLsYlM3IvpWmGHf1nTPLm5+9K/llMovkKuPg9fX52KFzXXCDo
	OTc/TdWIza+Woou2FvNv7kqUynJ6G/xDKLgVG9ILUWE8Z1gbJda7TKuz46tAoi9OmRvn3Z
	mmfIany1CliIfGZqDI+PzNs850DGGXg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="iw2ftw/N";
	spf=pass (imf19.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784200641;
	b=6wSuL/aFqJTg1FgVmv0Y6bxrTTScIq/ushAcXc3TyUy1ecrjz7zmjP8RTgm6k0PWAPTFfe
	H+LykOs7Mt4JSX2m8PR3lLu9rwc8B6L8yLf1hkwierOl4ETTc0LSbbddMpp90ddm8jTwmE
	jCxI2YEutPMbpTXstTNFCeyoMudpCLQ=
Message-ID: <65305712-8598-46aa-822b-914298277b64@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784200638;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hTG6hGzVl0dWfit8w/MB62E4ZbeaEHmlylI6bepXRC8=;
	b=iw2ftw/NK2C6aLDREmrqRB3OjKsp0m0NcDAUexkCvaS+1CoWYFdLyp3g94WH+U7yxEgSiM
	lGZoR+GtGUfnBlAM39TYcBixAEmtd9mi5XewkykQWHEgkw7LVMayH0akxk3gu2SaXH9Sp5
	w0xjNbEHkRdLLMISoubCAbwZcP3ZMYQ=
Date: Thu, 16 Jul 2026 19:17:03 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] mm: vmscan: fix node reclaim ignoring swappiness
 parameter
To: Qi Zheng <qi.zheng@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>,
 Kairui Song <kasong@tencent.com>
Cc: Muchun Song <muchun.song@linux.dev>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Davidlohr Bueso <dave@stgolabs.net>, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>, stable@vger.kernel.org
References: <20260716031729.1064007-1-ridong.chen@linux.dev>
 <20260716031729.1064007-3-ridong.chen@linux.dev>
 <7ddf3eee-5fe2-45f7-8614-c8936a039e04@linux.dev>
 <a5eb5433-cf6c-40ee-b14e-128a8bcc85bf@linux.dev>
 <94a489d5-8b02-46e6-92d2-ccb85f556769@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <94a489d5-8b02-46e6-92d2-ccb85f556769@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: bays7q1fk4gjw7ewd8xqnf5h1kqem5g7
X-Rspamd-Queue-Id: E55321A0005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784200640-864514
X-HE-Meta: U2FsdGVkX1+9lwffGcoRdpjpHRStS1EYUJTz5pv5BrfmW2Rv1bc4vqgX0UwMAGQBU6XLVL3ZWVDa+/3252KYCJVrOBHMtScRtDayeQFDHLodwwoYgCP8sr4IDeOlQN+REND8O57moASXLQEGzPkWxvpE4Ez/LFKH/+bHqugbyN+vStAtW/+KTtELs+IK8NfkJgV6bixc3BaPPaPnocLctgfyyhwgywn02Ru/5eji4jkKXajO0bEw7nWh4U2gBYD9/IpbM6TgesB4oSucqACx33wyoRpQdjmbizEXvGwTCP649HCdAyQvMJOKwucijf9WdeGACMjaI50xFpvXrQpMz5ATikybTg8uZ/l/XildN3f9ZMMc3l/FIS5HzGxoC6s78NXkigZtcBUOkV4XW6VOBmtR+08lnSKHQd31GYlnOpJDHIr3p0vV8MY9+zaikPPSaBJo7XKYJ8TpAYzvu8WubcPorUkcrb60UbnEc94AxI+zmiFnzG9QdtbNpLw7Z5/EzbDW2Yt+Tup/UVOfUOHHaBeV20piMsGz9eaeXF8X5amRiBviAvDsfKKixqXbabI9SraV3nkjfERM4T5obEygB+J9AeSL4dqPKuFHfXNanHLA6yA2BmHP0Dp5OZSujEX6IkT+50rZfIYE7KoOQmdVojKz21jpXEFxVD8VHBpdGrIbzmu1u3B5F2HFHkcIJ8OzGeVQ4zPANrOPzN7XQITLQyJxEOmmnwfWvY57Eufj0hX7q5g7Vvm1pJwkGcyR5oto3i2aEz/q1MJi753+ogIUlA8OIHos/CiuTaNGmommYZl7Sc/pNAGRGZDjTzFq9ulxUlw0VlQ+9YQP6VQ+1UiYZNwQ1R58e95UGgGbf1fssmDQ0B+TSw/MhsLsP4VyZUQGIhsQ91QsuxSsfI3nIMFhOTK11ys2ubQpUlnbJbWAYw9228N+rZFqjptA1CrHorz4h6UH4J/jXhhz2Oe4YkE
 JRJrRH7J
 6k5Zfj7FpDUrzd5EAvb+/sVEJEzt/DpszDFUS7I7pkDhD9AZR3+F2ioG0lrmk5yKovBk5LKmIehVeWQhsGo+sjr7k34O+T5uMHfzGwblWfDXntJqSloymEVtJp1Oy79kkv1imXd49XqNF1OVT099LpAOzKVlAewte6WhaDnMUrsEpu/9UWhL3Li7Tyb5D/LBSY5p3WdVeueuTsqZO33ONueIXms8+6HBSPrnFKj/AfmawTYkYqhSMF5yh2yxeuikpQItS7l5fiMFB+78=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/16/2026 4:42 PM, Qi Zheng wrote:
> 
> 
> On 7/16/26 4:21 PM, Ridong Chen wrote:
>>
>>
>> On 7/16/2026 11:58 AM, Qi Zheng wrote:
>>> Hi Ridong,
>>>
>>> On 7/16/26 11:17 AM, Ridong wrote:
>>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>>
>>>> sc_swappiness() had two separate definitions depending on
>>>> CONFIG_MEMCG. The !CONFIG_MEMCG variant simply returned
>>>> vm_swappiness, ignoring the proactive_swappiness value passed
>>>> through scan_control. This caused the swappiness parameter
>>>> written to /sys/devices/system/node/nodeX/reclaim to have no
>>>> effect when CONFIG_MEMCG is disabled.
>>>>
>>>> Fix this by consolidating sc_swappiness() into a single definition
>>>> that checks sc->proactive_swappiness first, then falls back to
>>>> mem_cgroup_swappiness() which already handles both CONFIG_MEMCG
>>>> and !CONFIG_MEMCG.
>>>>
>>>> Before fix (swappiness=max ignored, mostly file pages reclaimed):
>>>>
>>>>      # cat /proc/sys/vm/swappiness
>>>>      60
>>>>      # cat /proc/vmstat | grep pgsteal
>>>>      pgsteal_kswapd 0
>>>>      pgsteal_direct 0
>>>>      pgsteal_khugepaged 0
>>>>      pgsteal_proactive 1840
>>>>      pgsteal_anon 25
>>>>      pgsteal_file 1815
>>>>      # echo "64M swappiness=max" > /sys/devices/system/node/node0/ 
>>>> reclaim
>>>>      # cat /proc/vmstat | grep pgsteal
>>>>      pgsteal_kswapd 0
>>>>      pgsteal_direct 0
>>>>      pgsteal_khugepaged 0
>>>>      pgsteal_proactive 18013
>>>>      pgsteal_anon 337
>>>>      pgsteal_file 17676
>>>>
>>>> After fix (swappiness=max honored, anon pages reclaimed as expected):
>>>>
>>>
>>> By the way, in get_scan_count(), it seems we still reclaim file pages
>>> without swap space, even if swappiness=max (SWAPPINESS_ANON_ONLY) is
>>> set.
>>>
>>> This behavior appears to contradict the semantics of
>>> SWAPPINESS_ANON_ONLY, which probably needs a fix as well.
>>>
>> Thanks, Qi.
>>
>> You're right. Currently, when can_reclaim_anon_pages() returns false, 
>> the reclaim logic falls back to scanning file folios even if 
>> swappiness == SWAPPINESS_ANON_ONLY is set:
>>
>> ```
>> static void get_scan_count(struct lruvec *lruvec, struct scan_control 
>> *sc,
>>                 unsigned long *nr)
>> {
>>      ....
>>      /* If we have no swap space, do not bother scanning anon folios. */
>>      if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat- 
>> >node_id, sc)) {
>>          scan_balance = SCAN_FILE;
>>          goto out;
>>      }
>>
>>      ...
>>      /* Proactive reclaim initiated by userspace for anonymous memory 
>> only */
>>      if (swappiness == SWAPPINESS_ANON_ONLY) {
>>          WARN_ON_ONCE(!sc->proactive);
>>          scan_balance = SCAN_ANON;
>>          goto out;
>>      }
>>      ...
>> }
>> ```
>>
>> The !can_reclaim_anon_pages() check above takes precedence over the 
>> SWAPPINESS_ANON_ONLY branch, making the latter effectively unreachable 
>> when anonymous pages are deemed non-reclaimable.
>>
>> To fix this, could we move the SWAPPINESS_ANON_ONLY check up before 
>> the can_reclaim_anon_pages() check?
>>
>> ```
>> static void get_scan_count(struct lruvec *lruvec, struct scan_control 
>> *sc,
>>                 unsigned long *nr)
>> {
>>      ...
>>      /* Proactive reclaim initiated by userspace for anonymous memory 
>> only */
>>      if (swappiness == SWAPPINESS_ANON_ONLY) {
>>          WARN_ON_ONCE(!sc->proactive);
>>          scan_balance = SCAN_ANON;
>>          goto out;
> 
> For SWAPPINESS_ANON_ONLY + !can_reclaim_anon_pages, perhaps we should
> just return directly instead of goto out, since no pages can be
> reclaimed in this situation.
> 

Much better.
Would you mind if I send a separate patch to fix this issue?

> 
>>      }
>>      ....
>>      /* If we have no swap space, do not bother scanning anon folios. */
>>      if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat- 
>> >node_id, sc)) {
>>          scan_balance = SCAN_FILE;
>>          goto out;
>>      }
>>
>>      ...
>> }
>> ```
>>
> 

-- 
Best regards
Ridong


