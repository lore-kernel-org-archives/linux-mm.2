Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 14D73CD4F3D
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 08:11:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53F7F6B0095; Fri, 22 May 2026 04:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F1706B0096; Fri, 22 May 2026 04:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 405176B0098; Fri, 22 May 2026 04:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3DF6B0095
	for <linux-mm@kvack.org>; Fri, 22 May 2026 04:11:27 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C4C791C079E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:11:26 +0000 (UTC)
X-FDA: 84794336172.16.D76FF38
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6C746A0005
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:11:24 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	spf=pass (imf15.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779437484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hnOXLaGlvDzPD4Q62369U/U32X8xHiwuTgrMRz8iH90=;
	b=yxECXG/6n+E3PtjWX98OZ+ujEqb1B+hGK/JPpL6J9fimRS0phEuv+Ze4Lbsz3LCK1gN3sm
	y88d7oLJRDFNeWIqhHqgO6ZNC9bg2jeWWCYWkPZ4lrKFbHFFICUtEfjkPwwc0Vzb+S8/Qo
	JG86tpO7ZKhNz8PviuQ1wFrGY3bubpM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779437484; a=rsa-sha256;
	cv=none;
	b=KS97yrvUdaAtSLhV16lKcDzsWJx7KfPAjJxmlx3j0IanBfXmjqehZPM6q0PaoRxTdiaY9G
	OMRN/Aw3TCamMZ1HOBVxRW6iOtYgMlQ2TfUPhqDpNypMxlM9TFnKtesPCekTo8kkOwuPNb
	lMto7EHdQpir7LPth7rnGrIyyeQaFQE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.201 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id C1BE13E83F;
	Fri, 22 May 2026 08:11:16 +0000 (UTC)
Message-ID: <b434907e-2036-4260-bced-1adb8e26c917@ghiti.fr>
Date: Fri, 22 May 2026 10:11:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] mm: percpu: charge obj_exts allocation with
 __GFP_ACCOUNT
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Vlastimil Babka <vbabka@kernel.org>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Sergey Senozhatsky
 <senozhatsky@chromium.org>, Chengming Zhou <chengming.zhou@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Minchan Kim <minchan@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Barry Song <baohua@kernel.org>,
 Kairui Song <kasong@tencent.com>, Wei Xu <weixugc@google.com>,
 Yuanchu Xie <yuanchu@google.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260511202136.330358-1-alex@ghiti.fr>
 <20260511202136.330358-3-alex@ghiti.fr> <ag8-Dfoco9qQho0A@linux.dev>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <ag8-Dfoco9qQho0A@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTE6GZhhZQpoR3ySVQqehkrEDRY8i0Z5642swRsrw/EAKy1P+BYfoIDwg5PvM/uODv1MTjcv/PUmQHg//4/wtR0I0DHMAIxCD9C4pjjX+/cUoycfvUfeO3g1TtQhd4mQrDF7/wh3g6QEHgKwcALdpor4k4RkwCurcTlCbTJdbY6CxOXEZpr2/DgGz1A/zLxKOPuZODZ5W/XW6dboQ72sgLC79gW+LS4oGVymE+F+scl/k/8FHgo+5CzjWCZOivLavhG98YXax6kP7uS5f+rdzWKMk/9blt3gtnls922sF2tsJ3YQ097vPlYq+AkqIkp94audac/hlPzJA+zuKiSuQyTXBi94AwmnVZIP/vfrpMql/1SiOGlQszYxPMheB849X0A5K3fWfyHUJhpMpT3ZuKL/BBYFXdvaG9U7Ab86m67ylvhVBpHmw/rUrEObKaXWopNJztoAoKaQ67WSpVsEBcUNpnG0Kg0bjATIWE3M3AY7SUb4UOdjz67GZ5Lgnv2IxkYiL5lovfFeym/N0uwjmPjFA1tGdBc3KJrOwe25iRBMjmurE6s3rPVNpcz7uTb9fzDBGwlJZVu5BdJza47WAnzQs4iG5zqNSY1/OAK225Etmz3L7mgRDXBeHyKntvffSfeRgiM9l39iWoEW+67a5NhLdPGQnReB3trBtAdiY5EsFg
X-GND-State: clean
X-GND-Score: -100
X-Rspam-User: 
X-Rspamd-Queue-Id: 6C746A0005
X-Stat-Signature: qgzgoqkc8s3g1w88n1yy3fgq4gqonn6j
X-Rspamd-Server: rspam06
X-HE-Tag: 1779437484-707863
X-HE-Meta: U2FsdGVkX1+sfF7L4eRyuGlqej8Bl/SvttEbx74GED8utNaxABakPNYT6vU6O5zpEHKYdlWH+ky5Y6vZca41U+e8Fv+w62Bsq80rZVCMZNsyBfiuyp86hH2kv6NEIxEv4hRWjDz4HqkN0SuRvb1otfHV0OKk7tKB8xu2fTc/LkF9M1Qyiud6tnjvqgg/yo1m4e5mr2Zo2dhMMG8i8GbfwsT3+Ed/hFcI9M9Qxx9m1LkKdNijAJVrQ1lnGuMYqjcjimeyt8ADPdJ5tosJ4BvgVGnEM5fwJE672fdO+MCdw1lOAVe5akHkael5JCAKkbc2sL+Z80VB70XvvBE8f7GQvPMAPqfhp6N1aXcWGXeLAU3ssKV7TMHVOtvil+i5MFcY0kQcMe9KvfMUQwpafTN/onEm8gfLUShFf6vLMxi72+Qo3C02p+rmylof82mS7Wl3SRHtcOcTkNtXhka9qnZTijg7pvr4rJk91wvdjnXxmoWl/SPaxoJD9ZrnGM7k3eneD8OgC1t9DRKDh7sx250D0WKk7qjgRheD4M3HrE+HH3kMOGtBHKv0tFP1TVJ3MvLvqNrfIv9Of/+4AzUSd/j5NLvgFkT0qTzHHvKKJgIPu9TaAseCQUm8hdcDZEa8K9iVJwWUmsUKeNjC/7w15yDcVSzasjlSfnw4mUHAhmuSDAESTGgqcnylXnUGMHVfHgFv7Xuhx/e8LXop5kDjoQtUCaklL4UDYNOVyEhvA3xg2Q1Wyiqiqr9BsuzDrlb1LZFsYpIZrvrd9azKZVx5K6VoKM7C4VpBXjCaHU7AhpJFwz2M6lWbQKIy7moN9PsfyaxO8WLc8/ERbQPF1zxbzljtRPUTowysN6PxBnQJerNLuqZlcv8PR8BMnkdAsCVVUA14dCB6JLZZGFzYaoCn5STUcdUx+PYibUmZGPi0wnAB83MbP6ICUMs9lJr1ouSHfiZScXO1SIUs7I/MkRWKgP7
 lLd8Xjl7
 3yTzEne/CttAGcYna1r1OIiqMjR1FzqJBkcLM3REOosZGhLGEb1oSaTW9mizjEva/Dx71JGwJt/mmUPlRNJBQ5IGBQTEll0dpfqcU4RZIaKHdECQGk8vTD7IPjqsb6iIko4bkBC4gojprGkJ85NHYDbs1Ws9uNF3gW+G1bJcOzYxGciS8lECF/ELnWuAOj5ulB1lyXNCihVo2q8Aq+AvgwSRzuqgcKKLJ4kXRQ9900UYpxxg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shakeel,

On 5/21/26 19:25, Shakeel Butt wrote:
> On Mon, May 11, 2026 at 10:20:37PM +0200, Alexandre Ghiti wrote:
>> This is a preparatory patch for upcoming per-memcg-per-node kmem
>> accounting.
>>
>> pcpu allocations are always fully charged at once using
>> pcpu_obj_full_size(), which returns the size of the pcpu "metadata" +
>> pcpu "payload". But metadata and payload may not be allocated on the
>> same numa node, so charge the metadata independently from the payload.
>>
>> Do this by explicitly passing __GFP_ACCOUNT to the obj_exts allocation
>> and remove its accounting in pcpu_memcg_pre_alloc_hook().
> Will all the entries in obj_exts array be for the same memcg? If not then why we
> are charging the whole array to the one which happen to allocate the array?


Hmm, I overlooked the amount allocated, so that's my mistake: the 
chunk-allocating-memcg will be charged for all the metadata, although 
before the charge was distributed. And according to Claude, the metadata 
would represent 64kB, so not negligible.


>
> Sorry I don't know the details of percpu allocator, so asking some dumb
> questions:
>
> 1. Does the alloc_percpu() (& similar functions) allocate the underlying on a
>     single node or does it allocate memory for each cpu on their local node?
>     For slub, it is on the same node, so the situation is easier to handle.


To me, chunk metadata and actual pages are allocated differently:

- pcpu_alloc_pages() tries to allocate the pages on the cpu local node 
https://elixir.bootlin.com/linux/v7.0.9/source/mm/percpu-vm.c#L95. But 
to me no guarantee it won't fallback to any other node. And I don't 
think that __GFP_THISNODE would be a good idea here.

- pcpu_alloc_chunk() uses kmalloc or vmalloc depending on the size, so 
not attached to specific node, that's why I wanted GFP_ACCOUNT to do the 
job for us in the first place.


>
> 2. On a typical system how much memory is consumed by obj_exts for the percpu
>     allocator chunks? I am wondering if we don't charge it, how much will we
>     loose?


So according to my previous answer, 64kB. I have just noticed that a 
bunch of dynamically allocated chunk fields are not accounted either, 
which again according to Claude represent 2.3kB. I don't have much 
experience in accounting but that's far from negligible right? Which 
amount are we keen to lose to make the code simpler (or for other reasons)?


>
> 3. What would be side effect on assuming that obj_exts is on the same node as
>     the given chunk?


Given the size of obj_exts, overcharging one node while undercharging 
others?

To conclude, you're right, I did not dive deep enough into the metadata 
sizes, I'll fix that.

Thanks,

Alex


