Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15EFBC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 13:38:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE6BF6B00E9; Mon, 29 Jun 2026 09:38:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C97D96B00EB; Mon, 29 Jun 2026 09:38:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B61BA6B00ED; Mon, 29 Jun 2026 09:38:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 893086B00E9
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:38:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0314F1623CA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:38:47 +0000 (UTC)
X-FDA: 84933055536.06.AEEFC59
Received: from relay7-d.mail.gandi.net (relay7-d.mail.gandi.net [217.70.183.200])
	by imf26.hostedemail.com (Postfix) with ESMTP id B5EF9140003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 13:38:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	spf=pass (imf26.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782740326;
	b=XsnDFFHcbtf7nBlnWc1mdzKtg713KFkRUfKDqbVcWCuoEcS+5uco4wLkyif2aBg9ePaiV2
	YW9J0cV5fwEyP7NBszsLrBVXWpZsrwnPDp2PhPYk3MClXHoTbS7Kf8oaMUnOK6wHQIW4JV
	1V5KZb+KIhdcSjOnHNuNggudtwNI4fk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782740326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ytCsJNSXqbC3QGuKmLSahYlVBsIINE53aZGb/xUXibE=;
	b=hcx+p04HcwoPigRINrN81z3ZUcKJbxOVAYzORa97tkh8ZCJU9JU8GOYbE0dxRwA7m1/Yyp
	0DdYQK1gDk6UPSEOQ/cFTYx7Wd7QjALSXXzQFuIH2OsdzW+phmafUZh83hrl5FoENs9t2b
	9xzz6Se2gmS8pAPa4HpaNThhTXDZ0sQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of alex@ghiti.fr designates 217.70.183.200 as permitted sender) smtp.mailfrom=alex@ghiti.fr
Received: by mail.gandi.net (Postfix) with ESMTPSA id 3BA233ECCB;
	Mon, 29 Jun 2026 13:38:34 +0000 (UTC)
Message-ID: <044c3a58-7ed0-46f2-88ca-462691fd0b68@ghiti.fr>
Date: Mon, 29 Jun 2026 15:38:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 9/9] mm: zswap: per-node kmem accounting for
 zswap/zsmalloc
To: Nhat Pham <nphamcs@gmail.com>, Usama Arif <usama.arif@linux.dev>
Cc: alexandre@ghiti.fr, Andrew Morton <akpm@linux-foundation.org>,
 Barry Song <baohua@kernel.org>, Ben Segall <bsegall@google.com>,
 cgroups@vger.kernel.org, Chengming Zhou <chengming.zhou@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Hildenbrand <david@kernel.org>,
 Dennis Zhou <dennis@kernel.org>, Dietmar Eggemann
 <dietmar.eggemann@arm.com>, Ingo Molnar <mingo@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Juri Lelli <juri.lelli@redhat.com>,
 Kairui Song <kasong@tencent.com>, Kent Overstreet
 <kent.overstreet@linux.dev>, K Prateek Nayak <kprateek.nayak@amd.com>,
 "Liam R. Howlett" <liam@infradead.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, Lorenzo Stoakes <ljs@kernel.org>,
 Mel Gorman <mgorman@suse.de>, Michal Hocko <mhocko@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Minchan Kim <minchan@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Peter Zijlstra <peterz@infradead.org>,
 Qi Zheng <qi.zheng@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>,
 Sergey Senozhatsky <senozhatsky@chromium.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Steven Rostedt <rostedt@goodmis.org>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 Valentin Schneider <vschneid@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>,
 Yosry Ahmed <yosry@kernel.org>, Yuanchu Xie <yuanchu@google.com>
References: <20260626102358.1603618-10-alex@ghiti.fr>
 <20260626143244.3382853-1-usama.arif@linux.dev>
 <CAKEwX=OKsjtStcuvhQ3WCGYoTJHT6eagBq1mZqX+DdbLm_BFLQ@mail.gmail.com>
Content-Language: en-US
From: Alexandre Ghiti <alex@ghiti.fr>
In-Reply-To: <CAKEwX=OKsjtStcuvhQ3WCGYoTJHT6eagBq1mZqX+DdbLm_BFLQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-GND-Sasl: alex@ghiti.fr
X-GND-Cause: dmFkZTGMiVzjl8fx6fcDqBZVHRMjBBRqSm59eFdRBEQwbWWmTTZIXhW7nwTt2Grss4O1/Qzt4P/mKF6Gmw6s2N/Oar1KMbL2zQ/CA5Ng7g5/MJ+YoUJ9kLBXFq3omlAoEvf0fLGmz9tA2OED/bPsg1UDXGt9hMqz5EQarroAvd4wxiBQgAAraj+7XjgGWBq9kulJb4GE/r3esPtWnpz4nKIUVPtTMnHjfQM2cFy7RsZ3cU+lLuDrsRpMSkC/2J2VEz0KKxeKxQfaacyWFxf8xFIG13dHpLvT5Qy+0Tn661uwcMfZro0h4Crr29Kw6eoshS718JKnanm88t2zuMK3rAW2qixNKjiI/FS7zmzBPO/u/jQ3iK8hCDgnqc4V9ZuWd4uVZGN176v3P0MekE6f2aqcNIQJCWiBkeQxtTDaJO1SAL/EYMWWFxWS5F0peBBQXSrAq4Hb1ApNcvqz5RCsigu7WmKQwqBJEr7tS+sUlij7QdXU6IXSFaTyfKKYLxH0n+vSHrkmuRI/kC0N7a9UvlFdW4E2Ua1+n1mp4ekbDbJZPlN8OgyWMyjQvtKmyw8DdlfxvJ7bFujw8r5IIdrEz8opOKtVTBYDaFfbdMFMclTuwur+TiWMIPAg6/RDuMBTF0dDIeqNdu10UbKMeFvXh6D26HtA/XD6Z8Y1EwUi3F2eR8MVyw
X-GND-State: clean
X-GND-Score: -100
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: B5EF9140003
X-Rspam-User: 
X-Stat-Signature: i8cqfs5d3m14oyi3pxczspqij44iiga1
X-HE-Tag: 1782740325-646743
X-HE-Meta: U2FsdGVkX19zrP6kXOHv/S3TyQocHgjo/Ob615V3bbZkD1TyuDNkd1ExWJ/DeksyuGLirYCh2Z2HxBNubSXq8dIVwAklg/IlgaTZzjiVlyjr9GcGS+KGhGGcODr7gPZFuy6haRs7OqGsxwg4bE46SW+OxKXsALNNPc/fIyh6NK1SrWs8yPMhuVIfdhrJfvEf3QGN1iR40kEdY9CcCeVKGINrbWRy/XHtiMP7DucusZ2rKKWlOlGFoqXN3EvVDcn1FiKYH8lf9696gcxEbsqQDN8yMBFLhRvCWQ14c4VwV58miR+UVkX4XWgZiqhuunj+oOwo2/uwj38jp/9barVIN575M9uXveIx0XwWMvhq+yrTI291bO3va+NSjxmfTpMUZr3QnTEVG6J0Vh4jq6dcAznphvPtVeKGsmiXb1m0BoGEQVVdCWXnuY8RcyMieSlOES7gdVP1EjZEPVbUBWDyR3ugYLKYwuWevwK4aAqpNcd2d7ExGa/i18PsnaflFRdiZr5Ujw3Uf4e8KXFIVgfjku01pzuK5MMNdaPATM3YU76v3iIKTTm5pXLRyjuq+qaxmI4DfR3CvYDChD2gSnF83xaJe/rhiYBwMZibzkdowc9dExeWTfj929c/Fo3EGDOAUDUZpkV5okVRcwEKQk2Uhoo5HGNLZSXEncEDCxxmmjn4qXaCVDdYbVXlZaUMEfSJ8KkeTBi+ad8uzSTrhMnlyvdkIFq0uKD5SQg55f+j/mmC8kHv9D5QyIEpAmYAUtuSnTsNLOlKx+J0Wt327hGmmTwBcPJXe2OlsFh9+D/+jCRLrEy3e//iUoS40MdouoCjP0/9bmJ8w4lFtu10sqDF334aZZqLs7Y4gIs9/XZCllUHUEXEuqcSLe+xUl+dnfcNhrgjaqLsPGsD8Fir+tQ+6XjRWTUNYD8YXVEbNjgdNoc1m8LbpH+0ZLa7gqaos5DPxVrUa3R8Z93A3mKCfGp
 qXBTocQE
 G2PEoCWNjliDnYkTILIoNcIYroiQMfpL/gm6cYZPM5QK/zk2tV7nbce5evt+JYoFMks5Xy63qiD6wzpMxYkpcsfQZr1Eiu0aBskdswkITNEN2l4bA0gv1q51K8LlbhKveJ3ib
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Nhat,

On 6/26/26 20:36, Nhat Pham wrote:
> On Fri, Jun 26, 2026 at 7:32 AM Usama Arif <usama.arif@linux.dev> wrote:
>> On Fri, 26 Jun 2026 12:20:58 +0200 Alexandre Ghiti <alex@ghiti.fr> wrote:
>>
>>> Update zswap and zsmalloc to use per-node obj_cgroup for kmem
>>> accounting, attributing compressed page charges to the correct
>>> NUMA node.
>>>
>>> But actually, this is incomplete because it does not correctly account
>>> for entries that straddle pages, those pages being possibly on 2 different
>>> nodes.
>>>
>>> This will be correctly handled by Joshua in a different series [1].
>>>
>>> Link: https://lore.kernel.org/linux-mm/20260311195153.4013476-1-joshua.hahnjy@gmail.com/ [1]
>>> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
>>> ---
>>>   include/linux/zsmalloc.h |  2 ++
>>>   mm/zsmalloc.c            | 11 +++++++++++
>>>   mm/zswap.c               | 19 ++++++++++++++++++-
>>>   3 files changed, 31 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
>>> index 478410c880b1..30427f3fe232 100644
>>> --- a/include/linux/zsmalloc.h
>>> +++ b/include/linux/zsmalloc.h
>>> @@ -50,6 +50,8 @@ void zs_obj_read_sg_end(struct zs_pool *pool, unsigned long handle);
>>>   void zs_obj_write(struct zs_pool *pool, unsigned long handle,
>>>                  void *handle_mem, size_t mem_len);
>>>
>>> +int zs_handle_to_nid(struct zs_pool *pool, unsigned long handle);
>>> +
>>>   extern const struct movable_operations zsmalloc_mops;
>>>
>>>   #endif
>>> diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
>>> index 83f5820c45f9..17f7403ebe77 100644
>>> --- a/mm/zsmalloc.c
>>> +++ b/mm/zsmalloc.c
>>> @@ -1380,6 +1380,17 @@ static void obj_free(int class_size, unsigned long obj)
>>>        mod_zspage_inuse(zspage, -1);
>>>   }
>>>
>>> +int zs_handle_to_nid(struct zs_pool *pool, unsigned long handle)
>>> +{
>>> +     unsigned long obj;
>>> +     struct zpdesc *zpdesc;
>>> +
>>> +     obj = handle_to_obj(handle);
>>> +     obj_to_zpdesc(obj, &zpdesc);
>>> +     return page_to_nid(zpdesc_page(zpdesc));
>>> +}
>>> +EXPORT_SYMBOL(zs_handle_to_nid);
>> Does this need the same locking as the other handle-to-zspage paths?
>> zs_free() takes pool->lock before handle_to_obj() because zspage migration can
>> update or move the object behind the handle. This helper does the same decode
>> without the lock, so zswap's uncharge path can race migration and charge or
>> uncharge the wrong node, or observe transient zspage state.
>>
> Can we just charge it to the page's node for now? Once Joshua's patch
> series is in, we can correctly charge the node owning the data :)


Even if this patch accounting is incorrect, it is close to reality, 
using the original page's node would give results that are really off no?


>
> FWIW, this is how these zswap entries are organized in the LRU too -
> following to the OG page's node.


Oh, we should do something about that right? Because the compressed data 
is not necessarily on the original page's node.

Thanks,

Alex


