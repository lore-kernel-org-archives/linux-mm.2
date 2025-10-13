Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDCA3CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 07:29:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12DF08E000D; Mon, 13 Oct 2025 03:29:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DED88E0002; Mon, 13 Oct 2025 03:29:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01B9A8E000D; Mon, 13 Oct 2025 03:29:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E44CC8E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 03:29:37 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AFCF013A75B
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:29:37 +0000 (UTC)
X-FDA: 83992265994.30.861E79A
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id DEC8B80011
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 07:29:35 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BNutXIZ+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760340576; a=rsa-sha256;
	cv=none;
	b=ON261eQnxYV6b7q/DHFg9fst+QOhfBa+IwxsKK4ypgqMJFK6ca9upOiDojS6dysxgsGGuE
	ankhbO4EJeys+C1xxW5//wTnIMGzbRw75a71QufeMH9NviT25uw11RFYZ5k9aPELdnJuuz
	0Yr2YRDLrlp51CBb+1dfsRtfSllfpA4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=BNutXIZ+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760340576;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/vZP9HpsjeKEWQ9ykCUaY7omAgoRs+k/b14bmmT76T0=;
	b=qV7JXLdnIuqUVZR78KBUKvRly3G6W5zpSzeZEuh4oSuX35L8zAsdHQTpGkngM3UdJ4Na+w
	cJw3LNj3A3POzfxrZD5UxPDI+xk6zuUVIHR/mZvg3ynIoQ88sLxhHNPTJf6/S/JgX79aRO
	G/IKXnQVWt2nj9TELv/vmbiTopdO25o=
Message-ID: <ab6edd99-30a3-486c-bc47-ffcac3d93b51@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760340574;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/vZP9HpsjeKEWQ9ykCUaY7omAgoRs+k/b14bmmT76T0=;
	b=BNutXIZ+c4siKB0mcFGD5RRZLQ3PNEf4I+6qjrSKnIkaPg0w193ytJEFODM97FcOGAKkFr
	h3TfaalDIraRKKKPNhyRj0RIk99hSEnanM8rJMAFGpPqpQOTvpybOD19xKYlGgOqyxwCfP
	/U+6UvEP1XKa3jDhi3iMXOtrkadH7tE=
Date: Mon, 13 Oct 2025 15:29:11 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v4 4/4] mm: thp: reparent the split queue during memcg
 offline
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@redhat.com,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, harry.yoo@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Qi Zheng <zhengqi.arch@bytedance.com>
References: <cover.1759510072.git.zhengqi.arch@bytedance.com>
 <a01588414c9911f2bc912fa87f181aa5620d89d4.1759510072.git.zhengqi.arch@bytedance.com>
 <sdpkprxqf43emy5sttfzxnv4aemlarimdybdva4xyywyndajtx@zyvckuxgujzm>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <sdpkprxqf43emy5sttfzxnv4aemlarimdybdva4xyywyndajtx@zyvckuxgujzm>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: p5k43xuuceowixs5jnhh7an5gytn6opn
X-Rspamd-Queue-Id: DEC8B80011
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760340575-375806
X-HE-Meta: U2FsdGVkX1/eYoou1dzw/Mo18ra3WQQpw3m8+W7xFSQyc97Xxn957Qj9IoId/6w+z/AoE6s2WgPs1ziSn0IJIbTiVdZuvqkg9JO1lrSbRLBmr4o/Upbd/JCqR99QkaPBGWqOXaiKmJQLQf0MsNTpDAqCk+9v6LJVZ+QDFOsBnqmoIL+Wvu/aGCO8C6e4IkFhZvi8dgnl9B5gOHoMc8xBmUyWo9aIgMNbkyprNxdXHV7m7teAk7SMbf7xYaxINdphZGSCRUp08otclJNL95QbI16UZYMOwFvVA7LMUlOmCsdpylfbcyUI2ZQbTIb9BQut2T7h003KwL8cOE7BFyK7QJbsUUvecUDA0tAOvUyvk3HHpGDD8vrbH9Q/NXrqnB+oLV0tUE4VJyBH3TfaWwT54pnqHUcVaD62OWbBthv8D8VA1u4lrnI0SXGFRyx+rqNGV3ehxR/1BVaPwVxkiDAYBSQ8l+uRqEutmHvuA96dm7LjMIrmNM40xb86w7II82J9+fVdCnY46NvuRGpwvy5mXbyZFxosmDmA6Dd4yOAUNHZkJnIlSq9B1Z0jd2XOHadJhoi26Wj7Q5Z9raZSv333dBpR1fquOd3U+ssYVm3e9X6dSUHudyc94rhVpU9N7II8h94oRZbvunkgjrriNXYJuUGWsyGpIwgiWL2EX+Uba3MYZj6ol3amJpbtLqXUVp/+P6f5Fbs/D7IayyqZWbyiaFRU8BC6m9CIq1OHqlkxBF/ptPqICBm6+BJWXBjW4nH/qOlTuUKyUGx6Rc/Pq0hb35eHhWm4dBdEG3a8iNnj64rH/mtARIYI2zfCydv4iPUU+mDwsd7aSi3YdDzN1HcgDLCAWLfWPLM2ApPazVelgTuiNOmRt44P/nrdkGi/HCZ5RCsCzf/ZLamJb+DbaDrj+iYNN9azleOgzfiaGW8e3EzdDEVxNidHcZL7DvG6e1Lx0BtcrDTSbjBLCkvnuJe
 J+6X3mdM
 8GT3noMU/yNwpdGTdGgA+CiCrtpPQoFx3v2Hg9L1S+5k9qhy2JJ1yD6pagATSCJ+LDswtT3g8+GOULQUn0f5DRELAOTxgwFEqBi7GZHjdC5irW9WuchfYUEogUkt3J+xoGdWABNi1ik6dSxEjzGcFsZ0zeVKImBcUj7+GOQIbKBeKx/ZE4crWbWTlZGPIGnszFPP/6jjjcXpfNFRQlr6NiYScnEynvmcx8YMNYm8jEu6bu3fNlCTWPBqw8QsHGdz/N2uaVuPDDXMUEAX/cgkoqMqiF31FbAhsHblgDJSAbMqiB5HIqVnxzC+kTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Shakeel,

On 10/8/25 1:56 AM, Shakeel Butt wrote:
> On Sat, Oct 04, 2025 at 12:53:18AM +0800, Qi Zheng wrote:
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> Similar to list_lru, the split queue is relatively independent and does
>> not need to be reparented along with objcg and LRU folios (holding
>> objcg lock and lru lock). So let's apply the similar mechanism as list_lru
>> to reparent the split queue separately when memcg is offine.
>>
>> This is also a preparation for reparenting LRU folios.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> ---
>>   include/linux/huge_mm.h |  4 +++
>>   mm/huge_memory.c        | 54 +++++++++++++++++++++++++++++++++++++++++
>>   mm/memcontrol.c         |  1 +
>>   3 files changed, 59 insertions(+)
>>
>> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
>> index f327d62fc9852..0c211dcbb0ec1 100644
>> --- a/include/linux/huge_mm.h
>> +++ b/include/linux/huge_mm.h
>> @@ -417,6 +417,9 @@ static inline int split_huge_page(struct page *page)
>>   	return split_huge_page_to_list_to_order(page, NULL, ret);
>>   }
>>   void deferred_split_folio(struct folio *folio, bool partially_mapped);
>> +#ifdef CONFIG_MEMCG
>> +void reparent_deferred_split_queue(struct mem_cgroup *memcg);
>> +#endif
>>   
>>   void __split_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
>>   		unsigned long address, bool freeze);
>> @@ -611,6 +614,7 @@ static inline int try_folio_split(struct folio *folio, struct page *page,
>>   }
>>   
>>   static inline void deferred_split_folio(struct folio *folio, bool partially_mapped) {}
>> +static inline void reparent_deferred_split_queue(struct mem_cgroup *memcg) {}
>>   #define split_huge_pmd(__vma, __pmd, __address)	\
>>   	do { } while (0)
>>   
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 59ddebc9f3232..b5eea2091cdf6 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -1099,6 +1099,11 @@ static struct deferred_split *memcg_split_queue(int nid, struct mem_cgroup *memc
>>   {
>>   	return memcg ? &memcg->deferred_split_queue : split_queue_node(nid);
>>   }
>> +
>> +static bool memcg_is_dying(struct mem_cgroup *memcg)
>> +{
>> +	return memcg ? css_is_dying(&memcg->css) : false;
>> +}
> 
> Please move the above function to include/linux/memcontrol.h

OK, will do.

> 
> With that, please add:
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

Thanks!

> 


