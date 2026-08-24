Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7D2CC5DF8C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 03:24:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9AD6B0095; Sun, 23 Aug 2026 23:24:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C06F6B009B; Sun, 23 Aug 2026 23:24:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D6CE6B009D; Sun, 23 Aug 2026 23:24:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 28D446B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 23:24:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C1324041E
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:24:55 +0000 (UTC)
X-FDA: 85134721350.20.606E641
Received: from mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 67E9420005
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 03:24:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qKA7mjhX;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787541893;
	b=aPuPlFxgN9cYN3KXXH06/CzZBtr3sgMgeLmBDsS5IWUwjHwcyXbzWXAjwRlsVZoCe8DziO
	07TLTno2U3F7tsbctFfoUgKqC+AGfayRuwVYj3dYh08aBrpvrLqED2yTLt/CdWCiTwkDkm
	GPXt2I/Aw8r1hNAEpI5Y3tefBGnmpKM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=qKA7mjhX;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787541893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2NiJ7gKGNplXhdWnRiORd0oQmfXzE5e5jmRmb3tG+Oo=;
	b=JY4M52Iys55ogB0DZOdIrEyxmCckeGMihHC6HlohWP9RQdaEPAKa8NvWOLwHPvhT63vLc0
	H0dHFRaGnT+siOWqOkhJKiltoq1mgHK9yqW3WSds+LwDl4VBd9GviDeZDyE9vsd/L0TWWM
	Fd0IjZBgTZSdcOKL5rUeT0GFhkyF8/A=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=GJQQjYv5cAikeWZ4aygGwi6YdDnAejQoQYl0vwFIJJY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787541891; v=1; x=1788146691;
 b=qKA7mjhX8EqNoG6I6h7I+tcfMxDLqWdEdnODkaQ/xeobZYgC3tpKQ4nL0ZTpJILXqqcvyCOT
 g6rhSUYBRI8eNOu28tZ+qRNefDIdRrWintA5F2bzVu8MrIMIyeLnOj4ZnILXPEy1S7ubNMUEGBO
 tNqeR5TZfWdtJc9bLRCCdw4Y=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.63.107.123] (14.29.108.92)
	by smtp.migadu.com with ESMTPS id aeb7d2d31c83cd6f;
	Mon, 24 Aug 2026 03:24:51 +0000
X-Mizu-Trace-ID: aeb7d2d31c83cd6f
X-Migadu-Flow: FLOW_OUT
Message-ID: <de7d583e-bd9b-464f-9e28-73075c0211a4@linux.dev>
Date: Mon, 24 Aug 2026 11:24:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/4] mm/vmscan: honour node reclaim limits per type
To: Michal Hocko <mhocko@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
 <aogMyu5R_DZRqp2J@tiehlicka> <f45848da-9569-453f-b0c0-8aa984e1976d@linux.dev>
 <aogZZsXwCyOXISaw@tiehlicka> <bc9c3de9-17b9-4ba1-8065-3270bb455630@linux.dev>
 <aogwUac-sjfcs7Vi@tiehlicka> <dba83897-9bbb-4a44-9021-8f938bb6a12f@linux.dev>
 <aog0ch0u8BtkR-a1@tiehlicka>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <aog0ch0u8BtkR-a1@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 67E9420005
X-Stat-Signature: 655h4wysdisqkddxyfa4moibadn1myit
X-HE-Tag: 1787541893-595691
X-HE-Meta: U2FsdGVkX1/rTNB4bqzFuGElTy5ELbv73TolnBDMzp7hWjwvkrJXSZU03rRsz5L3D3+Ntjqol6msw6HDJnyzU08lSu5AGyKElyRjjL/pzDhAcLxfXjXugGW5gPrrHgiLr20aeW3Ua9mJ+dxcGLNQ4wN2sZVB3Z28atVHa3AahW5/pxM+JoGSskUNuk4EHWCzd/8/CNTAkilqg22tXslNj2KsW7zOohEJDeGdu0nZF1yjNSyLDNOuyQrdtC06iCIOvIg9SFoPnht+AxcWJnVC3kacU3EMh3HiFTY7L2D9ys1eWe0WBVwB3HX6kJh4RlXWg3Dw7tPj4SHQp/j1qXAmtQGZIhn7aQUxKdpP/T6MUrQCOx7EDdKMaUpsNfgeV2UvvaQ0fJPteGq9rgzbHf51SjNvhtWdfo1myUB1bHPLFujEu912hFh62raI3vamefNMd0RPocMyL6SjMcAg367l3F5F4qyxmU2J4cLC3y6PZZbxoC35cr2WZ8OZXu0wd+oKEMA+DB1Z+g4mMlm8cElPnQgbbodesOQ6oQ89HY/waA3F2ifoEz3AWrxEQicqnUYXn2uS1OrNOfOtuDRGjCSauxWxap9Z7pCD4y9nS9otGwmwUsQCtmTtPkb83gdoz8RWsm1/eumRs3qID8rHnASNEQENpL3non90+0l44NVeUb3b8PluDqJavRL3VVeMH1VsG/QClwbyLXvFLtMu/x36xHDUJBvCiCMelpcuBwg0leXIYR/IHw3TL7+jXdXjv2DsQj6lIAMwymcqeJzWbzAAcefCDA/ppmdB1t+Fy+cU1HoP4lC33VP2NerzE9EYWV5Nip8oeliPUQv2XNj9U60TZAeqDA2Y4TdHgWKqg+gPuJLiYlvFS/+B43hJfG5YjJkzVrPb9ilq+CeQAGpQmSxicKmX1xWB7jBNxM6OG4Hc9+jQIVR/fwn3XxBaSzW1LRVAo+02ZSF513I/ElIl4oK
 39VDtz1m
 rX2BqswbEQyj1StRQjSCYsjZu4LYp52CJqVdMM/KmVB+/HZIGimAClC3b+j4sxaYMeJu3LfndOonkCeGBShOO1yLyaEa4vez50SHuvFVgQQuejpX1D0z2mZefzIFVNQdiddK70eE8Du/u6AVyQgb5a12DoJgEVZHyjy3K3TCohUPWCYbCTvyh60JkWA4lCFXP9l/OUe0Z2jirB+yuIX3k5VYbjOcak3MUohtPnW/DfUsqIutdcIgUKgo3jjlsOOaqnVGS8OJiKJKgtkfOQQRwFmgPFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 8/21/2026 7:20 PM, Michal Hocko wrote:
> On Fri 21-08-26 19:10:45, Ridong Chen wrote:
>>>> Did you mean that min_slab_pages and min_unmapped_pages should influence
>>>> proactive per-node reclaim?
>>>

I apologize for being incoherent in my last email, it was after a full day of 
work. What I wanted to say is that min_slab_pages and min_unmapped_pages should 
*not* influence proactive per-node reclaim.

>>> Nope, exactly opposite
>>>
>>
>> I would really appreciate it if you could clarify this further. Sorry, I'm
>> not sure I fully understand what you meant.
> 
> pro-active (userspace triggered) node reclaim should completely ignore
> all those historical node_reclaim tunables.

Yeah, this matches my understanding. Apologies again for the confusing reply.

Since Johannes has acked patch 3, perhaps we can simply remove the conditional 
check in __node_reclaim and keep the shrink loop as follows:

```
@@ -7906,16 +7906,16 @@ static unsigned long __node_reclaim(struct pglist_data 
*pgdat,
  	noreclaim_flag = memalloc_noreclaim_save();
  	set_task_reclaim_state(p, &sc->reclaim_state);

-	if (node_pagecache_reclaimable(pgdat) > pgdat->min_unmapped_pages ||
-	    node_page_state_pages(pgdat, NR_SLAB_RECLAIMABLE_B) > pgdat->min_slab_pages) {
-		/*
-		 * Free memory by calling shrink node with increasing
-		 * priorities until we have enough memory freed.
-		 */
-		do {
-			shrink_node(pgdat, sc);
-		} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);
-	}
+	/*
+	 * Free memory by calling shrink node with increasing
+	 * priorities until we have enough memory freed.
+	 *
+	 * What to reclaim is gated per type by sc->skip_slab_reclaim and
+	 * sc->skip_file_reclaim.
+	 */
+	do {
+		shrink_node(pgdat, sc);
+	} while (sc->nr_reclaimed < nr_pages && --sc->priority >= 0);

  	set_task_reclaim_state(p, NULL);
  	memalloc_noreclaim_restore(noreclaim_flag);

```

-- 
Best regards
Ridong


