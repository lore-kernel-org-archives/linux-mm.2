Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C885CC4450A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 02:28:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 938276B009D; Thu, 16 Jul 2026 22:28:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90F036B00A2; Thu, 16 Jul 2026 22:28:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 828B16B00A3; Thu, 16 Jul 2026 22:28:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0D36B009D
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 22:28:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C50681A02E1
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 02:28:14 +0000 (UTC)
X-FDA: 84996684108.20.8E4344C
Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id D8E2420007
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 02:28:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VcWEPhq4;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784255293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K7BquqktHv1/BZuLZY0RQng54+jc6Y0pgFNTnH/SVV0=;
	b=3826H64QrdWcgojAZzWlHZnPtQEdyUzuDk0M+3mOW21XbmcWuLhzDbJHqgKk8KuSiIyxwu
	85h+zYgUbIfjc+Trk9ecmEGnSCbyWwVpy8J5wLpyVgl7tuWXiKF+OHV+IVAiRuw8jOEcOR
	sUetOSNy9mMTsgkXThurpcpALsDhmIo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VcWEPhq4;
	spf=pass (imf03.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784255293;
	b=vzVROn7JwpaKpKKM/4TP8UImBLArD6kiGzqRlbgJ1s+Zi2iD1DBxvrvdYdS1RQLDG+zu7j
	TFqmcFL9hs1Br4FU3eIYTnMFtTdgFJ9Ia9m3imk25/eD3mL+WiIhHM2qg4i0pEemgt1zKb
	eOcYysbDzEGOtceFBccW3qAJMseQlwg=
Message-ID: <bd61c847-6432-491d-9314-304070b18196@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784255289;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=K7BquqktHv1/BZuLZY0RQng54+jc6Y0pgFNTnH/SVV0=;
	b=VcWEPhq4E+a+5McB+OTjqrvM3jg56G30RJxu5ay+P5eX+Y3Lf4/JaMWwS1D2For1jcDONU
	JqMi2TQAGD3a5C8HTdNvSIycx9sVWHReci4yRuvuItFztk+X5a2eu0QE/XVp2wApXo5L6z
	wArI5y4X5mCX4YMoBrH8kismyj4tVuY=
Date: Fri, 17 Jul 2026 10:27:45 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 2/2] mm: vmscan: fix node reclaim ignoring swappiness
 parameter
To: Ridong Chen <ridong.chen@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
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
 <65305712-8598-46aa-822b-914298277b64@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <65305712-8598-46aa-822b-914298277b64@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D8E2420007
X-Stat-Signature: 9nr3f7x7gxwih9fw59s7akre96cfrfxn
X-HE-Tag: 1784255291-357761
X-HE-Meta: U2FsdGVkX1/TGHU3vxEJjnYSig4wmBDy183LTPHYYO3C+1d4RGl5X7maCB9TxIibX+Q4i+v9gAtzVp0yfnm1jKwJkpe/IfmngQT63D8mcF4NDj/sq4P9UnZ7DrqMSzqgC3+wHb/vILN0VX/3CD04l7vCNvS+feH31YyUuSnhZVhz8vhXKPY/vlOaXmhjEZ5re8iXpI1c63L9m4XUYkRAVPCghSfjeQms+2+fnElaKKoz+UJzPlzmXE9vgEnsOjpvtszeTLccrpEoOtRHP0p0VOHOl9IQ7nO3YbU7vRLYllRYHg/PRlsXzkMlyRqE3D0ICHyR2GfHkkAME8dJB/59VjsiLGHM/24ru/FfVCtl5C5/kBGZMqZvvq4+FeLRYR2A9rQ5W17l/+XFCcp+mz+uCSQX0qhmIaaAvVGKc85/ggRbiGfnhb3dkLdGBwd1udKpvKUdcJY2u8doHWOWsMNzCyFDh3Uf0pSMTT5Bja1UWvPI9xFK9bgGM8PmiNPc8L97kJNu4g//K+CgeFs3JFu+/i9qg/YCiyJBQqrwPav3I1pMH3QiuITh+k/2S0KDOmbNXcQoNhC8hMEuXgYw+Cv9a4Dw/t3ALnw/1AYbrUZ6klX6iEnOjqyrxxdsxV6T4kgjfXl0+1zt7NDB2vQMJju2pKZrA6OWNqyRem7lgNyk8bLM0aXzc11R+GT7ld455HnbVoisY9mj72Bh51AkIUwGoNeX2rKUteEJPNaeY8GtXaHUFxcMFhMcSdu3VoU17nWkltcblnwjX8t3aH6+e0l7uSPAfkFzKIobMRcd6aUFfXOL8ZHW3mGGKRV7zpKcglABFD0sFadZUm1NMg+EVVf4Um4Oj1kQfRu4x6Mo4zmHmL+xpficeDE0jQV7kEhBRMRZGz1nHj0KJe8e35un8U0WpCgs3DOzustA/JG3H7mgfkKtyXpv70wv0amOGBihpNGoNDFRhAxIOrxr9N55GWS
 MJiF9yVu
 k0at9jYW5FcxuYoR9ciW0qm7DEsmhbneIVXNBhwtpnYz8L2lJ+hktNxtctQdT2gJk2RRkYxfyOFX9+bs62EwaNS07k4YTDWGptqWuQzhHkQTZiuQz9Jf1t1a3Pbf3g96jdwgdjhMrdDj14oIvSocxdyu4a3gzcDpJZc9ik8rFAZE6HqInERQYt4IPYlFO2zkXL8auumJ089m0QUUaO4KtCQgIKavsSMdIdR97rVHduMUaVFqjpFmLRM97rxzEHaeDNj49
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/16/26 7:17 PM, Ridong Chen wrote:
> 
> 
> On 7/16/2026 4:42 PM, Qi Zheng wrote:
>>
>>
>> On 7/16/26 4:21 PM, Ridong Chen wrote:
>>>
>>>
>>> On 7/16/2026 11:58 AM, Qi Zheng wrote:
>>>> Hi Ridong,
>>>>
>>>> On 7/16/26 11:17 AM, Ridong wrote:
>>>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>>>
>>>>> sc_swappiness() had two separate definitions depending on
>>>>> CONFIG_MEMCG. The !CONFIG_MEMCG variant simply returned
>>>>> vm_swappiness, ignoring the proactive_swappiness value passed
>>>>> through scan_control. This caused the swappiness parameter
>>>>> written to /sys/devices/system/node/nodeX/reclaim to have no
>>>>> effect when CONFIG_MEMCG is disabled.
>>>>>
>>>>> Fix this by consolidating sc_swappiness() into a single definition
>>>>> that checks sc->proactive_swappiness first, then falls back to
>>>>> mem_cgroup_swappiness() which already handles both CONFIG_MEMCG
>>>>> and !CONFIG_MEMCG.
>>>>>
>>>>> Before fix (swappiness=max ignored, mostly file pages reclaimed):
>>>>>
>>>>>      # cat /proc/sys/vm/swappiness
>>>>>      60
>>>>>      # cat /proc/vmstat | grep pgsteal
>>>>>      pgsteal_kswapd 0
>>>>>      pgsteal_direct 0
>>>>>      pgsteal_khugepaged 0
>>>>>      pgsteal_proactive 1840
>>>>>      pgsteal_anon 25
>>>>>      pgsteal_file 1815
>>>>>      # echo "64M swappiness=max" > /sys/devices/system/node/node0/ 
>>>>> reclaim
>>>>>      # cat /proc/vmstat | grep pgsteal
>>>>>      pgsteal_kswapd 0
>>>>>      pgsteal_direct 0
>>>>>      pgsteal_khugepaged 0
>>>>>      pgsteal_proactive 18013
>>>>>      pgsteal_anon 337
>>>>>      pgsteal_file 17676
>>>>>
>>>>> After fix (swappiness=max honored, anon pages reclaimed as expected):
>>>>>
>>>>
>>>> By the way, in get_scan_count(), it seems we still reclaim file pages
>>>> without swap space, even if swappiness=max (SWAPPINESS_ANON_ONLY) is
>>>> set.
>>>>
>>>> This behavior appears to contradict the semantics of
>>>> SWAPPINESS_ANON_ONLY, which probably needs a fix as well.
>>>>
>>> Thanks, Qi.
>>>
>>> You're right. Currently, when can_reclaim_anon_pages() returns false, 
>>> the reclaim logic falls back to scanning file folios even if 
>>> swappiness == SWAPPINESS_ANON_ONLY is set:
>>>
>>> ```
>>> static void get_scan_count(struct lruvec *lruvec, struct scan_control 
>>> *sc,
>>>                 unsigned long *nr)
>>> {
>>>      ....
>>>      /* If we have no swap space, do not bother scanning anon folios. */
>>>      if (!sc->may_swap || !can_reclaim_anon_pages(memcg, pgdat- 
>>> >node_id, sc)) {
>>>          scan_balance = SCAN_FILE;
>>>          goto out;
>>>      }
>>>
>>>      ...
>>>      /* Proactive reclaim initiated by userspace for anonymous memory 
>>> only */
>>>      if (swappiness == SWAPPINESS_ANON_ONLY) {
>>>          WARN_ON_ONCE(!sc->proactive);
>>>          scan_balance = SCAN_ANON;
>>>          goto out;
>>>      }
>>>      ...
>>> }
>>> ```
>>>
>>> The !can_reclaim_anon_pages() check above takes precedence over the 
>>> SWAPPINESS_ANON_ONLY branch, making the latter effectively 
>>> unreachable when anonymous pages are deemed non-reclaimable.
>>>
>>> To fix this, could we move the SWAPPINESS_ANON_ONLY check up before 
>>> the can_reclaim_anon_pages() check?
>>>
>>> ```
>>> static void get_scan_count(struct lruvec *lruvec, struct scan_control 
>>> *sc,
>>>                 unsigned long *nr)
>>> {
>>>      ...
>>>      /* Proactive reclaim initiated by userspace for anonymous memory 
>>> only */
>>>      if (swappiness == SWAPPINESS_ANON_ONLY) {
>>>          WARN_ON_ONCE(!sc->proactive);
>>>          scan_balance = SCAN_ANON;
>>>          goto out;
>>
>> For SWAPPINESS_ANON_ONLY + !can_reclaim_anon_pages, perhaps we should
>> just return directly instead of goto out, since no pages can be
>> reclaimed in this situation.
>>
> 
> Much better.
> Would you mind if I send a separate patch to fix this issue?
>

Sure, thanks for your time on this, and I look forward to your fix!





