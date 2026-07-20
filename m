Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9185C4451B
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 06:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF30B6B0088; Mon, 20 Jul 2026 02:03:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACA846B008A; Mon, 20 Jul 2026 02:03:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E0F36B008C; Mon, 20 Jul 2026 02:03:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 718C76B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 02:03:46 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0DA5516074B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 06:03:46 +0000 (UTC)
X-FDA: 85008113652.03.6CDAB8F
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf28.hostedemail.com (Postfix) with ESMTP id C7F11C0004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 06:03:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P2d2KH1z;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784527424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EOa2sTI0h7gbpAoJrm7HoBQ8Xn3bVAsybwlbAeYP1CM=;
	b=THLM4PSw7fuUXVGv7/49FylqzQAg9n2iaePSdsl5XpGIGN/3njWCYc1ElrhBWvW+H2azd6
	HrgYkv9GkVLabxwUcJTWW2rgyWmnQE20bvTHhblvAnD/OPQlp9dpy7VM3D5YHYTvFQI97D
	oMltEktrQ/G4BqOa1xylr1LYqPdgLsk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784527424;
	b=I8OY+dvtLI7C6eWJ9vkk10yRn8yznfOm3xJV3wvw0GibNaM4LgMXwYRinZIq3FbTNhA4L8
	6BBj19/WnTnggALACQSBacPlMNQZoGIAgsAYNZmsznI6mJai7+PuqlxiT1w4mnf+zGaMa1
	x6BcjHqVNT0VTB9r1RZBCvaGwhEh7f8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P2d2KH1z;
	spf=pass (imf28.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <dbaa0a54-cf81-4644-b47b-b60a2083cb30@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784527421;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EOa2sTI0h7gbpAoJrm7HoBQ8Xn3bVAsybwlbAeYP1CM=;
	b=P2d2KH1zoFc6CCaHQHoU8kOPKNHeAvz9g/bVcgWvG/bw3S1HxPQ2RSo2VN937qAZdANCte
	2KUtW9JMpWaQVpUU8jryQ2SwqH/midwu37hzmQBll6FFLCGOytcNjEKb67I3ljNAHhNCYz
	2g/mIfmjrb9xtmY7nJp0gAlyuoWOYuc=
Date: Mon, 20 Jul 2026 14:03:32 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2 4/4] mm/mglru: fix anon-only reclaim evicting file
 pages when swappiness=max
To: Qi Zheng <qi.zheng@linux.dev>, Barry Song <baohua@kernel.org>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org,
 mhocko@kernel.org, shakeel.butt@linux.dev, ljs@kernel.org,
 kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, hezhongkun.hzk@bytedance.com, muchun.song@linux.dev,
 dave@stgolabs.net, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20260718095251.82937-1-ridong.chen@linux.dev>
 <20260718095251.82937-5-ridong.chen@linux.dev>
 <CAGsJ_4zGRtDEGnQwmFqXrEcm93UrHaX8A_awJgu=b8ikceT8fA@mail.gmail.com>
 <c9ad9052-4f9e-42a5-a6f6-17877aad18e4@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <c9ad9052-4f9e-42a5-a6f6-17877aad18e4@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C7F11C0004
X-Stat-Signature: xymba9xt6bu1jik1zgb5ds9yrd4x9k9w
X-HE-Tag: 1784527423-713069
X-HE-Meta: U2FsdGVkX18ZlF1CqUZrsQFUBxXwukcm4VulkMZeaFO78VjKBf55sygrhiHY+3GUBBh4dy3LiBu4rY9LVguhdBuVJFuxkSLqJJSGYZsxDea6tGRMvx7cqqg59EJORMF21bpXlebmNb0mfyqMiF4YhrxvYg/DIDULI/ULvaWcDFoRfWbiuHExL7m2kOoKc452I05x5tJOMWedCOzxHXQC0wvJ+KhD9kQeY4bDTplqEz93ZmES56U/X4bMN8Smrd0L9Vx/UV93HrhCUdHxUJ3dIHayhF9r6zVaQFcdY6KDXYk8SzHFiXrYyT1WKPRKADnCpX7aQc/a0Kw7jlyLnc8WyKvIPHlvuhJhSLQ/+CyIEd1Z38EKFsW7DIh2Nbb0mFD4PTjxjm1JXYMHoPySCIPd2bDwrAggARm8HQVG0xM79MRqUU3I/TfDO3iqmm1mNaT6rqOJYPkxU+k/lB4qpYC+Wz2CQryRLgcJM1Vl/hXH9M7DD9eJ9G6GdF6CZ58CI0AKJBZgM9/nLh3eKUe5dGkfcl8PVrxVqSaOyzejmWMmySq6qG2a3rBElQFXmYs+w+hZJK8CjDDDN49g9eswDW7Jq0wozvZQiEGIXro2qb7XwffmD1PFW+czvdTefMqSRYIqyZMF3lMOuw6D9ttTAFXj/26H/A/u9jzQwAtEAMu5uMgdpNoI/q9vt00VI5MPxbRjXq68AjR1xAg9pqwyte50RUCfttGRRfOrHVbmHSaz0WscJYpc7Ap8RnXLTh/pFp3+JcDljQvwz7Ihf25Jlewk8zMwgQs0R18pXhL4DsNbUVr4SoJV8KDNG0MEgd9BTYc44Yb92JktjygxqwqathOQpPrn4w7PeMmQ0TgWRJGvoGCk6UDMbfjzbhHkCfCBhdorqF+64q3iqT8rnJDq5/E60bRR4jT/IksMcxDxTtVQExeOOQTcruZYa8MDNsQExLM1CA1YRj8mA8GdKCgZDSh
 J2qU67+f
 dXJMYAU7Mc7sT5ObuZcgK7nn35doLyabgLWg1462ruwvPSfMzCxnU8EQIgZdWMn/r9udFikrUlrgqrrGBLdrMndX0FYR52BlZNmxEvmJy3WOAFT9eO6N7ewq5FEgUrZzNXMf5hdgPK8jtf0h38CaEuZFM5kmAb74QEyqTYrLds2ZoFnrXC7hYJ52rjd+wfAsn804U3SdW/5JgUpWWCntLRYPita6KHsUn1ibRU9nsOK8vAVylZbBviKLIwyRGpjlVJ1CvU4MaJo8e4NSBHMF7oO1vhnWqRORT6eyeRUkJUkfJkkfoB7I0x5tVpdo6IJgS77Fm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/20/2026 10:48 AM, Qi Zheng wrote:
> 
> 
> On 7/18/26 9:43 PM, Barry Song wrote:
>> On Sat, Jul 18, 2026 at 5:54 PM Ridong Chen <ridong.chen@linux.dev> 
>> wrote:
>>>
>>> From: Ridong Chen <chenridong@xiaomi.com>
>>>
>>> The previous patch fixes this issue for the traditional LRU, which also
>>> exists in MGLRU [1]. Fix this by checking whether swappiness is
>>> SWAPPINESS_ANON_ONLY in get_swappiness() first, and returning 0 from
>>> get_nr_to_scan() when swappiness is SWAPPINESS_ANON_ONLY and anon pages
>>> cannot be reclaimed, to avoid useless work.
>>
>> Is this intended to avoid unnecessary work, or to prevent file folios
>> from being reclaimed incorrectly?
> 
> Based on the test results below, it seems primarily intended to prevent
> file pages from being mistakenly reclaimed. Also, bailing out early in
> the SWAPPINESS_ANON_ONLY + !can_reclaim_anon_pages case is to avoid
> unnecessary work.
> 
> Hi Ridong, perhaps the commit message could be clearer. ;)
> 

Thanks for the feedback. Let me clarify:

When SWAPPINESS_ANON_ONLY is set, get_swappiness() returns the 
swappiness value, and get_type_to_scan() can always return LRU_GEN_ANON. 
So if anonymous pages cannot be reclaimed, we bail out early to avoid 
unnecessary work. In that case, get_nr_to_scan() just returns 0.

If we do not return early in get_nr_to_scan() under the 
SWAPPINESS_ANON_ONLY + !can_reclaim_anon_pages condition, then in 
isolate_folios(), it may fall back to scanning file pages, but this only 
happens when scanned = 0, which is not the usual case.


```
shrink_one
try_to_shrink_lruvec
   get_swappiness // return SWAPPINESS_ANON_ONLY if swappiness=max
   get_nr_to_scan // return 0 if anon can't be reclaimed, skip
   evict_folios
     isolate_folios // !scanned falling back to anyther type if !scanned
```

I'll update the commit message to make this clearer in the next version.

>>
>>>
>>> The test result:
>>> Before fix:
>>>
>>>    # cat /sys/kernel/mm/lru_gen/enabled
>>>    0x0007
>>>    # cat memory.stat
>>>    anon 204800
>>>    file 67108864
>>>    ...
>>>    pgsteal_proactive 0
>>>    pgscan_proactive 0
>>>
>>>    # echo "64M swappiness=max" > memory.reclaim
>>>    # cat memory.stat
>>>    anon 208896
>>>    file 0
>>>    ...
>>>    pgsteal_proactive 16384
>>>    pgscan_proactive 16384
>>>
>>> After fix:
>>>
>>>    # cat memory.stat
>>>    anon 188416
>>>    file 67215360
>>>    kernel 1970176
>>>    ...
>>>    pgsteal_proactive 0
>>>    pgscan_proactive 0
>>>
>>>    # echo "64M swappiness=max" > memory.reclaim
>>>    -bash: echo: write error: Resource temporarily unavailable
>>>    # cat memory.stat
>>>    anon 204800
>>>    file 67215360
>>>    ...
>>>    pgsteal_proactive 0
>>>    pgscan_proactive 0
>>>
>>> [1] https://sashiko.dev/#/patchset/20260717113300.214717-1- 
>>> ridong.chen@linux.dev
>>>
>>> Fixes: 68a1436bde00 ("mm: add swappiness=max arg to memory.reclaim 
>>> for only anon reclaim")
>>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>>> ---
>>>   mm/vmscan.c | 14 +++++++++++++-
>>>   1 file changed, 13 insertions(+), 1 deletion(-)
>>>
> 
> Overall, this looks good to me.
> 
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> 
> Thanks,
> Qi
> 
> 

-- 
Best regards
Ridong


