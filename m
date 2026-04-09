Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BC59EA3C4E
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 12:50:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38DAC6B008C; Thu,  9 Apr 2026 08:50:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33E566B0092; Thu,  9 Apr 2026 08:50:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2532B6B0093; Thu,  9 Apr 2026 08:50:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 186D46B008C
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 08:50:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE9071B8568
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:50:47 +0000 (UTC)
X-FDA: 84639001734.14.28DDF32
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf30.hostedemail.com (Postfix) with ESMTP id 719D380007
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 12:50:43 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=jr1w2Lb+;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775739045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KE4eT7YcrT++12c/obGpJYqag96lO0J1UNDibfVOhpA=;
	b=xm7/Az0QnVGWaTkN1YKMHviQXs1LxJwn2RNkbD7UFlBuPzceNMJ0/2fDTt6abdalo+1Oqj
	ziZRW4gN8yB14ArBfPa7ENH8Kv/7dm9ZX9Z5iTFu8Z2aKmmRtUbvDZlZYn8glbcIpNwF8L
	rP3gF3QB8IXjuPXOgZVEHYuCRgF/vSU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775739045; a=rsa-sha256;
	cv=none;
	b=sjseXNiAlg5fdHkg86eo1kjnKdhacHKWzoTXKqMIMrLZnJwPx5DnRsRnuT/m3wY9fnulFp
	tqIq+jaXURS3Lkkz0JG7jzpqB6ppYShYHQqmCh299DqOxkddq1dXbwgwBci/8DYdfqG4l3
	YRRXZNMNTJpgMd/5dd5d7ZGL/J7ySgs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=jr1w2Lb+;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf30.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=KE4eT7YcrT++12c/obGpJYqag96lO0J1UNDibfVOhpA=;
	b=jr1w2Lb+N3vZPTEFDElACQMA6h5rDgN8VQXEOB8wa1u3Sr6XbfzJvM8fu4Ea9zuaiDMLOILNf
	bOKS8e6m6ezGljzENQ0R0UCWPCMNTbCk5HhaXK+9xOhDdgZtjUf6DP+g36FHlneYudVV9iHTLYZ
	Z5RSJ/sZ3AhkAqLCedtGYiE=
Received: from mail.maildlp.com (unknown [172.19.162.223])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4fs04s751Mz1T4Gp;
	Thu,  9 Apr 2026 20:44:45 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 6037C40561;
	Thu,  9 Apr 2026 20:50:38 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 9 Apr 2026 20:50:37 +0800
Message-ID: <95bc0034-a72b-449c-9be4-b691fd03dc1e@huawei.com>
Date: Thu, 9 Apr 2026 20:50:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] fs: drop_caches: introduce per-node drop_caches
 interface
To: Michal Hocko <mhocko@suse.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Christian Brauner <brauner@kernel.org>, Alexander Viro
	<viro@zeniv.linux.org.uk>, "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo
 Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan
	<surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>
References: <20260409063503.3475420-1-wangkefeng.wang@huawei.com>
 <addP4MKmA8zfSN1o@tiehlicka>
 <dbb92553-58ba-42e1-b7df-b8450bd69d33@huawei.com>
 <addhuRqrB-u7oDp8@tiehlicka>
 <bdd49511-9b84-42cc-a286-9fdf2ef531a7@huawei.com>
 <adeFBKzNq9rNzbHk@tiehlicka>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <adeFBKzNq9rNzbHk@tiehlicka>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 719D380007
X-Stat-Signature: dsth8ix1q56s987hrsf5d6fk4nne9um8
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775739043-467982
X-HE-Meta: U2FsdGVkX1825P1HYy6KAdwZxhByBCVu8kvuce6CLCTFMB10hd3Jwej0Yu4U550SD4oGuMwtIajSOhQrxzWMeSbh4inA5Ww4En1DgvGTMRgGaB5BEbr8odnTpbjXqNoF+c1gCKeML9MBsE5q/hLnSBXfN94RDtLkgfJcib+L5paoh3F6KaB8ss/yPT97JqG2F6BKvvaJ4IqjVPc92kPThvzCuGSaCCGZ7GNXcF+nJ5wkiYR2Gykpd3NkwgRQ51uEE3eQDWcRUhrv3D/S7d6nkKkJunRwvVPDLIrL22qFfUNNiE6bJep+xsszhrnbDAg/7eK31zxRfpxF7guOUJGccQ4LypmgDHnhofe3uc1Hhc3JkTRGoqBbYOniZj4taI7/fOaeJ+qWWi3rfK0w93QoSmTzG8Rb1WEMauWFaOfI38tLYx2SGPTQ6hGosuN5MVw0dwVteE7FYNhkjv0fhLtcG19Sb0L3RAzIar8oYNg3VD2G+Ggy0UpBYBoTu6BRdMjseninRXl3yBucyUNUjvbbEJYVA1s1wq5OyMkGuRSfUpwY3nUN8c2DKfdo6oi2+xWZk2RxZtaLFNmbyeskbC0Mb34C/n3Lt4xQuSjTrLMwF5reEMIQoHYROX4aqLUYJrEmuZnXq1ueTLLRKFhft2g+J13qPRHfjssW9iodsavstFlCQ7x/9Hpa51BZJ9tb+ckQwjnji0u+uWGLaYiyIhlmuoFiCbA/zkTg2SVCRaaOzZtBvpDzO8xqWANRFGoNymhWjt+zwfK4/6OaCo6NnM7wOKSbInk++a8BrekblV8ZLZ0fRNs8ys7Eoln3V+7T7NLYGJ2RAvMchi3nRF4vv1NnpL7qJ6kQ/N8F+S7vf006OYx4O9tvkI2bA3gJ8D+X5c19fcssSZcu/KCK6iXWHLXg4FA4WmtZbuW2IxZ10JmTvTjDSPPFcPN89K4+gTka5NA0G8D5WaDdGBl6gqd8qow
 JclVLve/
 uAqwhj8OSxL+F5+tKrdVHmwjQzIaMmzrpB+CSbJ8mjwUHkMnP/E7lapX1LGCADJ5X1ah6+On3llmQNFDAXgWepUuE7q5JvzwXNBTySUCrJpsnDuRsccVnAjGRO1dC6gSmzlipKL3xmTpYnPuFegk0ysOdKYv5s4mUacjUu696ux3UHSqbTHD7BPDjEtRJnlQthPbrAY6NpvtiFM3/s/eUqGDyRQr9t5y8pE065hJVIhYm0yZzXWL9zCLFsnFnlESs9/gcf3FgcGnfEZqd/4gZmMQUWyRxgsVPtEV28xP6Ib4va8gGaYbskYpGVQiShdpUfdEgzllXqqvywNJpauSEOMm5anXIkPNv25jA6HniikvO5w0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 4/9/2026 6:52 PM, Michal Hocko wrote:
> On Thu 09-04-26 16:54:48, Kefeng Wang wrote:
>>
>>
>> On 4/9/2026 4:22 PM, Michal Hocko wrote:
>>> On Thu 09-04-26 16:08:37, Kefeng Wang wrote:
>>> [...]
>>>> To use the reclaim interface, there are two differences,
>>>>
>>>> 1) we need to input the reclaim numbers and swappiness, this is not a big
>>>> problem
>>>> 2) for reclaim, it supports swappiness=max to only reclaim anonymous pages,
>>>> but cannot only reclaim file pages,
>>>
>>> Why is 2) a real constrain?
>>
>> This should not be a restriction, but a strategy. Our product wants to
>> migrate anonymous pages to the local instead of swapping them out. However,
>> the current per-node-reclaim interface does not support reclaiming only file
>> pages.
> 
> Yes, I do understand that you want to keep your hot anonymous pages
> resident on some node. Those shouldn't be reclaimed by the user space
> triggered reclaim anyway, right? Migration will then happen during the
> memory offlining.

Yes, that we need.
> 
> This will certainly require some fine tuning but I do not see any reason
> this should be completely impossible. Certainly a more robust way (from
> API POV) than the suggested drop_caches. I am also not convinced we need
> page-cache-only reclaim for the existing reclaim interface. I believe it
> makes more sense to look at the reclaim from hotness POV rather than
> anon vs. file.

It is already support only reclaim file pages when swappiness = 0 for
memcg.reclaim, but not for per-node-reclaim, so we can just make a few
small changes to enable it(no tested)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 84eba9ab5d25..46254ae9b8df 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2515,7 +2515,7 @@ static void get_scan_count(struct lruvec *lruvec, 
struct scan_control *sc,
          * using the memory controller's swap limit feature would be
          * too expensive.
          */
-       if (cgroup_reclaim(sc) && !swappiness) {
+       if ((cgroup_reclaim(sc) || sc->proactive) && !swappiness) {
                 scan_balance = SCAN_FILE;
                 goto out;
         }

or

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 84eba9ab5d25..e2998b61f78b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2515,7 +2515,7 @@ static void get_scan_count(struct lruvec *lruvec, 
struct scan_control *sc,
          * using the memory controller's swap limit feature would be
          * too expensive.
          */
-       if (cgroup_reclaim(sc) && !swappiness) {
+       if (sc->proactive && !swappiness) {
                 scan_balance = SCAN_FILE;
                 goto out;
         }




