Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A30ABCD5BB1
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 13:00:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEB946B008A; Thu, 21 May 2026 09:00:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC3176B008C; Thu, 21 May 2026 09:00:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFFFA6B0092; Thu, 21 May 2026 09:00:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A1A236B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:00:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 60F7E40625
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:00:42 +0000 (UTC)
X-FDA: 84791436324.03.851A15B
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	by imf28.hostedemail.com (Postfix) with ESMTP id 92431C0014
	for <linux-mm@kvack.org>; Thu, 21 May 2026 13:00:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	spf=pass (imf28.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779368440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GKCzCEk4JumjkXlMulaOd+bgGG/FVZsOWWgW76bSzWc=;
	b=23X3V85iSzrJHVnovP88ron0eOsn/BX4nRC8Sv6I8WeKglUf5S5c9UOwgcBoG+nvbWIXOi
	cYIKWBTVpU5xrCuVuCQ7WUh1PQQ9lkWoAihBP3/qMdg0OiSCA+qMSIpO1B6v+5KIq5Q3qb
	yL3KYbyeDEzRFw+8xaicD1D1M0Q9fP0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779368440; a=rsa-sha256;
	cv=none;
	b=7y3I2Tr0t03qnUqSxiyKBPyBLEA74DlQWJUX65nVn9kK8UwcOMr+nXKi7renYHH+u5a4rj
	CE9U8r5HwyPXTO+8BqJq0W/awjDAwX6tsOFE+lkzFHhPeMSPEySv4HeO9gv5vgCDqkDMbn
	nC0bXOfJDRQZrwCVgsc14ug6MV0gRgo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.197 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 2207A3EC4E;
	Thu, 21 May 2026 13:00:32 +0000 (UTC)
Message-ID: <f942b897-4fc4-4f3f-a1e2-c0d90c99c5e6@ghiti.fr>
Date: Thu, 21 May 2026 15:00:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] per-memcg-per-node kmem accounting
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>,
 Christoph Lameter <cl@gentwo.org>, Vlastimil Babka <vbabka@kernel.org>,
 Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Minchan Kim <minchan@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Barry Song <baohua@kernel.org>,
 Kairui Song <kasong@tencent.com>, Wei Xu <weixugc@google.com>,
 Yuanchu Xie <yuanchu@google.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
References: <20260521034604.4126295-1-joshua.hahnjy@gmail.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <20260521034604.4126295-1-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-State: clean
X-GND-Score: -100
X-GND-Cause: dmFkZTFmsEyfNc68qrqRIOts4zs413bzwTXVyXR1l7lXbRsVt6n4nUhPDqj1pajky4uCr+YZ1zTEH+7veoCTLY+HNEX3lmo1mb8YffUJVTrBlLzbGqFHBXRpEs+bq3p61Zv4nTUxoWCa35x9Ta0eUlH5bBKjc3luGFOKaL0BgT3W3PyuRCBQjurKDhrMgPh6m1cdbh1YbVRvwO5OdT+mFeqF+Tg/TTmQaqKvkeitSksmpWzB01IIIlg8v+EvGL+8+9sCBhARvpS9yBVGKIEnh7bB19GKR2gAGYC2fVjjISGpZHO/6bP89RRpdlOUaMuTs7AMLo4e6Q02XSPUPidz41t0YXaYIY/4FBCiVhAH15wU3hcGrmRYYTbhTCy5sPGHVRYhp5F1pLJI9pBzoHMFpU2lE9459XKbb0znW1LJ5Mbu6wQANRBPrbbBJ7L2mMddJAj0EDZqzHj2E0he2bd5oNmDcIU3zx4ZYU6F8/fTYVu83ID2a/Tq15TicNGnDUR1UbVnn5GH6B1MWvgni6LEKHnOxDuC/CnE+rX9Xv2+rrF8cUhET4h8hK/stGBaJKtuW8TaHNhQ1lOr+/gPVKGDBiyCJrfEcqZlPiwu5UPPWnIONpfnkbefjYuoEsiWSlWD3J8sHW5mGQBIl4u97E10Z/AhykQqwBe1d/pe0GE3F6ZbZZrJZA
X-Rspam-User: 
X-Rspamd-Queue-Id: 92431C0014
X-Rspamd-Server: rspam04
X-Stat-Signature: uuhsibn8fbecxpx3bzsbne6zrwrnoc65
X-HE-Tag: 1779368439-282918
X-HE-Meta: U2FsdGVkX1/Bn8cjXwr9SxyvuTmtIswS74wv/sd7YOChA67wiLnyqXS+1tv8dRVRghXmzOdQzvD9VZHDLQRqRdd/2wHpulLmtenh14BwJwKeL+SN+J12pQsPxhOOhCg591/bbwNc2ADNc0N8WJm38rOlWHAl/6iNAVg4Rwre1175e1NK0tVTuHSpuVQhLJK+FafBkcT2lw42JHr9wxwt6b021F2hU2gutylW0OscuOMrCEukmOryOSM6e0YWbIhs0yNDpWlZruyekTOU8/IPDAIly7hGF4EiufEX2DfkNcc7yNDbBFI2OPsKoz5aTKUI8RQIesnr5f73S44YqxLmnpu5ohmYlNfa13hW15J2VbLHFbP5iy8/3fXYvQAknVKnemEZhmb+eI+I8pqSJ4qZR9fXhZAOQaImm2gmEHAMm1D84y57UGnG/QnIL3lUv05YMrA5B7rUyidPwN4PzVmHdsLxdYsiOmzRtHBfocCI2WL0fWf857TC6dkL2Efg7yb7TKIjVHT/RNtZYok0jO7XflN6/b3kPsctmVwbe5oDUNYSaXFwOV2bXycVVyLkh5wcG4qTXGxLq1coyskdg7XsaEii56VK/XArcnufK6TQipU7Lq0ZZZRaFVsze4QB+/mhgKhSt7DJkALTPekf5j8Wkd2fT2zH0W4j+FklorZ4YqM9fSxrjLywSpBLXbdb7X67sx2/txOlYlAwsRgdAiAbtLVlUW+9b0woozhZKiHAai0LX2DplGLyiHTPllyupo5zOBBRa4Q7UQrUH4MYfqV27VgKNiAw7R+S+v83tpPP1kdQYEYnmVOr2hnsc8j2y0AYLN7evQuc3K7rFJvQZQHL/rTv86TLF8WP2tE1Wt6PTW3bhBpwBNg9bK6kkDG5f4PpZxIGbDHOx/6Hl5FOl4tZ4umr5gIzEjyccWLwDMEy+UWSlKExP+EQMXOjdwQ1bhsnVg2NbgcqIXD9O3Dk4eK
 W6S74nSf
 taOLVTsYJSmeqUArefIRSCRt5qbN/BQI4nyi8EO4EroKbrA8YIwzmZX8XVJNRMfYqy3MBdS4jzZ1Mk+p21MUMLsGic/2k6oTZzbmJ+xWZ3pUpr9HCjDYGqx9KTcVcccxTtPAvQkUhpJgUQ4JOh0uOhvjdNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/21/26 05:46, Joshua Hahn wrote:
> On Wed, 20 May 2026 10:39:59 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:
>
>> Hi Joshua,
>>
>> On 5/18/26 16:57, Joshua Hahn wrote:
>>> On Mon, 11 May 2026 22:20:35 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:
>>>
>>>> This series pursues the work initiated by Joshua [1]. We need kernel
>>>> memory to be accounted on a per-node basis in order to be able to
>>>> know the memcg and physical memory association.
>>>>     
>>>> This series takes advantage of the recent introduction of per-node
>>>> obj_cgroup [2] and makes those obj_cgroup tied to their numa node.
>>>>     
>>>> The bulk of the series is percpu per-node accounting: percpu
>>>> "precharges" the memcg before we know the actual location of the pages
>>>> it uses, so charging and accounting had to be split. All other kmem
>>>> users (slab, zswap, __memcg_kmem_charge_page) are straightforward
>>>> conversions (zswap support is limited in this series because Joshua
>>>> is working on it in parallel [3]).
>>>>    
>>>> Thanks Joshua for your early feedbacks!
>>> Hello Alex,
>>>
>>> Thank you for your work!
>>>
>>> Overall I think the direction makes sense to me. Pre-overcharging makes sense to
>>> me as an approach, we would much rather overaccount than underaccount and
>>> later have to breach limits.
>>>
>>> I do have some concerns on performance, though. Namely, I think there are
>>> some expensive operations that I think would benefit from some performane
>>> benchmarking with this patch added (maybe some simple microbenchmarks that
>>> demonstrates kernel allocation overhead could be useful).
>>>
>>>   From what I can tell, there is some additional performance overhead that has
>>> to do with iterating over num_possible_cpus() x pages_per_alloc, which
>>> doesn't seem trivial to me.
>> Indeed, let me microbenchmark the overhead on a large system.
> Hi Alex,
>
> That sounds great with me : -) Looking forward to the numbers!
>
>>> Another concern that I see is the stock credit system. Maybe we could be
>>> bypassing the stock check leading to more time spent doing the atomic
>>> operations.
>> I'm not following on this one, which atomic operations do you see that
>> could be bypassed?
> So in my initial scan of the patch 7 I had a concern that if we have a nested
> stock system (obj_cgroup stock and local credit "stock"), then we could
> incur more work if these are out of sync; do extra work in the stock refill
> path in obj_cgroup_precharge, and then do extra work on top in the loop
> within the pcpu_memcg_post_alloc_hook (obj_cgroup_account_kmem does the
> charging atomically I think).
>
> So what I mean is, I'm not sure what the "size" is typically for
> pcpu_memcg_post_alloc_hook. But it might be a worthwhile optimization to
> do precharge all the pages, then for each cpu iterate over the pages to
> figure out how many pages are used per nid (doing just math, not actually
> doing the atomic adds), and then outside both of these loops just iterate
> over every nid_objcg once to perform the atomic operation.
>
> Maybe this is needed or not (depending on how big "size" typically is
> and whether we go from doing O(1000) atomic adds --> O(10) or some
> big reduction, but I just wanted to toss it out there as something that
> could potentially be expensive.


I get it, I'll trace the microbenchmarks to see what happens there, 
thanks for the suggestion.

Thanks again,

Alex


>>> obj_stock caches a single obj_cgroup, which means that if we split the objcg
>>> to be per-node (in patch 6), then the obj_stock basically gets invalidated
>>> every operation since we iterate over more objcgs (even though we are in
>>> the same logical objcg). Maybe I'm missing something?
>>
>> The objcg split comes from commit 01b9da291c49 ("mm: memcontrol: convert
>> objcg to be per-memcg per-node type") and the problem you describe is
>> exactly what Shakeel is trying to fix [1].
> Whoops O_o I completely missed that one. Sorry for flagging it again!
>
>> But I remember trying a microbenchmark and noticed a +5% regression (on
>> top of the 67% then...), I'll rebase this series on top of Shakeel's and
>> re-run.
> Sounds like a great idea! Thanks again Alex, have a great day! : -)
> Joshua

