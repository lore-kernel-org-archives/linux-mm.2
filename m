Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1B737606A6B6
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 01:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CJxXVWSn
Received: by kanga.kvack.org (Postfix)
	id 0E38F6B05B2; Mon, 23 Nov 2026 20:50:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 096696B05B3; Mon, 23 Nov 2026 20:50:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EECFA6B05B4; Mon, 23 Nov 2026 20:50:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B80A66B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:50:40 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1679440A99
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:50:40 +0000 (UTC)
X-FDA: 85468333440.26.38A22D1
Received: from mta0.migadu.com (out-123.mta0.migadu.com [91.218.175.123])
	by imf10.hostedemail.com (Postfix) with ESMTP id 04EDFC0007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 01:50:35 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CJxXVWSn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.123 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795485038;
	b=7h8mdfIeorRNPpjCmw6WML9mXCRJB5/Yu23RIGHL3XcFuxh6U2NnlCy5Fn1mwuzJLEUadA
	KaIShNx4oS4bI+ZtxR+6ldxFe+9WKlhC+mosVYBwZ5AJCusH0r3V51u2ntJJBcOUnOlVlH
	c9qJazgQ+wVBrilHkL+bRJxN4o5+WUo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795485038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UBJN7Ukcor2+qO6HKcZTR/7tIF/UCxC5T6SPsBDyMhY=;
	b=DqpHkpFXKvDTHX3LYnmaB6cUgDgfuEL9OeMGli1AbDrALcB+ufFewfDyhH2BpiPnQTOLGf
	sNMmXRe6dX2Ds8grIRZpJb3kSQaeFDiIjMvzxSOl9PYo7wjk59ZbN1V8plylrZHyNn9F/j
	IiQwaSddz0WHK6pe1AnpjMiJ757g1V8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CJxXVWSn;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf10.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.123 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/mE4Kphm9eN95jgCQQ92bpAduSWHEShLYf4UMWK+lxg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795485033; v=1; x=1796089833;
 b=CJxXVWSn2dNgs+4wFfW6qKONNL5/QkETl19ip5/XI8euIBzxlXzsJjwjNptPAaxmMRpLFWt0
 tbAFo2haoKQZ5WUo5fdSU3coqzrkO/KYJwPuu+Ta6i4zPsGQ4/oQcwhkfOlMDjmMc39VZqmtHsV
 j4bvwoLzKgDnPlYfqDk1DOm0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d90e46c0fb5e4815;
	Tue, 24 Nov 2026 01:50:27 +0000
X-Mizu-Trace-ID: d90e46c0fb5e4815
X-Migadu-Flow: FLOW_OUT
Message-ID: <f65aa688-d236-4b4f-87bf-c12e15991aef@linux.dev>
Date: Tue, 24 Nov 2026 09:50:21 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/mglru: deactivate anon folios into the oldest
 generation
To: Barry Song <baohua@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, David Hildenbrand <david@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Yu Zhao <yuzhao@google.com>,
 "open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261119134740.514632-1-ridong.chen@linux.dev>
 <20261119134740.514632-3-ridong.chen@linux.dev>
 <CAGsJ_4xsz0TdYUTtS2Pfr6PvfAs1PvDxzmPGU5wgBgjGVrB1EA@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4xsz0TdYUTtS2Pfr6PvfAs1PvDxzmPGU5wgBgjGVrB1EA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6hwsbobytzktpizxw6ueaidss3fykfaq
X-Rspamd-Queue-Id: 04EDFC0007
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795485035-382107
X-HE-Meta: U2FsdGVkX18mg1sqngx6xDBc9f/EP1xmwgLstnNoSSQ02eooQ0lT4zyB+KcoNVXJEYxPFmlowOIleJ1Ht1aao4ZLiYJtkNi64Fk+k1jeMc2pSuG1jYN1n1Fe5732xGOhFAJsrIgjeWLHMai94qIbSt9e+dKmo6DsThH/DQEiTRFwayO5WIWJ2KgGc58QHar9biMarT4CPc1pmyIC/bAKVlW9Le66hOSWAFdQVS+gXT/BOnu0cV8VF5floEo40vRi/9q/m+HJUiZie9dnZoEISF+wokuyRIdajxCqk8Rf2bPe5Q3PbF95Nwd9wjta4wtKSFLpcuv/jD+xRKw9GZ4MARqJBZtg6c/0ClkgcRhVMaCqgfeF033V5Cz8cY8U5vhZzOlipLSK98vPMRPxec+qDlVI1lmwbiXuTjZmCSPg8U2KZEopnm74T6p4XKfKh6LkCFXmUaISk2MdXxJAlJaQGxeS8Q/dEtkBMtw59QeC4lEpeSD09i040pmfLTGd/g+tBxMY89TUc/6c0tvgZfVTVAPo2dHUB4DX5l0ZPtcUgYh/w/PaArBE1vNHYeBZjAh06lhxxpiF5XJF6VTN177BH4MlIhSn4ihBWgKb451LqQ6i/RzFoKzA7Cefo0sJulDuTxB19hCsrkxe40ghFVtKM4ETI2X0LxevJBCF+HkH49PnbWm2Iz79Bn9GzrJ4LWVTbj5JBMROP5IkK2CRGHxoaUkt5/mw/nda/lI/riTdVsC1tofkmk17xolfbU91ze5p20TH1++bMx1WgtrDLLSviC6snUzczJ+tr99lmMZv5K0oa9JoV9jlMOsYf9/LXWkI4CrGDuTGCPbtAyyMsL0Obp0oSkygHXsa+tJ1FLUsoR4JxYiyDUKxeAjy1xMd/SqDLNhtV3NTeyjQhaNmeKPyRM0PlNOpArkqbnEkv3PC3tw/R34Wtx3aK6+POH+Mo2rdpq9pUqBW+T4wVO9n8oc
 b7F4lX/Q
 7LI0CdeckrSAgiZXNfPn5NJ+oOGdYHRc9Y2u949+q47Ezo3YvnSSOS7zafgCNMB1MuTaK++JXzUSQM9v6VNOyrCZnieGU/7tmCPZQys2HfCQBm6FZpsgvyRPre1k08aFyEXcoBJLmPPiXYXeUwqbNv0X5ZNjH1JeoEpN/uQtihg4aPWYsUzMBUSPt8HKpbLAaxYLaLSzr/JCsC7z/lZ4v6Iw8qr2ipJHv0hXDZQpzVKHdHejQVAi2Q3t6WtqfWppo9QW98XzXAYAIfmSzkDN0rJQqcVfIRdBDRxUHaA8vS0wpbKJXSmH8CUS0UgJRYUj92uZbTYA7FpglmjbvEP07kxqixhAF8RqKKZCObgTkwAylZivDE6yNGJGx62LKB25LFcah/iVOdRnq8PJwpVyZ66ave+1z6cw8FTTvHPespaSw3iOhAVarJTAU2KXPgHKBqVl+sjrBBI5Sq2TRyXzpTZHHVp5KTHBUqjR1W3qieO4yH5Bqk3rAJUNQUZganL1kOCWWkZ0tICYxqSI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/24/2026 9:18 AM, Barry Song wrote:
> On Thu, Nov 19, 2026 at 9:48 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
> [...]
>>
>> diff --git a/mm/folio.c b/mm/folio.c
>> index 7a3394e7c5dc..1bfd746d7f07 100644
>> --- a/mm/folio.c
>> +++ b/mm/folio.c
>> @@ -423,6 +423,14 @@ static bool lru_gen_clear_refs(struct folio *folio)
>>          return gen == lru_gen_from_seq(seq);
>>   }
>>
>> +/* add the folio to the head of the oldest generation */
>> +static bool lru_gen_add_deactivated_folio(struct lruvec *lruvec, struct folio *folio)
>> +{
>> +       int type = folio_is_file_lru(folio);
>> +
>> +       return lru_gen_add_folio(lruvec, folio, -1UL, lruvec->lrugen.min_seq[type], false);
>> +}
>> +
>>   #else /* !CONFIG_LRU_GEN */
>>
>>   static void lru_gen_inc_refs(struct folio *folio)
>> @@ -434,6 +442,11 @@ static bool lru_gen_clear_refs(struct folio *folio)
>>          return false;
>>   }
>>
>> +static bool lru_gen_add_deactivated_folio(struct lruvec *lruvec, struct folio *folio)
>> +{
>> +       return false;
>> +}
>> +
>>   #endif /* CONFIG_LRU_GEN */
>>
>>   /**
>> @@ -609,7 +622,8 @@ static void lru_deactivate(struct lruvec *lruvec, struct folio *folio)
>>          lruvec_del_folio(lruvec, folio);
>>          folio_clear_active(folio);
>>          folio_clear_referenced(folio);
>> -       lruvec_add_folio(lruvec, folio);
>> +       if (!lru_gen_add_deactivated_folio(lruvec, folio))
>> +               lruvec_add_folio(lruvec, folio);
> 
> Since we're already introducing a new wrapper,
> lru_gen_add_deactivated_folio(), could we make it more readable
> and self-contained by handling the fallback within it?
> 
> This way, lru_deactivate() only needs to care about deactivating the
> folio, not whether we are using MGLRU or the classic LRU, or whether
> MGLRU is enabled at compile time or runtime.
> 
> index 1bfd746d7f07..5a6092e64fe1 100644
> --- a/mm/folio.c
> +++ b/mm/folio.c
> @@ -424,11 +424,13 @@ static bool lru_gen_clear_refs(struct folio *folio)
> @@ -424,11 +424,13 @@ static bool lru_gen_clear_refs(struct folio *folio)
>   }
> 
>   /* add the folio to the head of the oldest generation */
> -static bool lru_gen_add_deactivated_folio(struct lruvec *lruvec,
> struct folio *folio)
> +static void lruvec_add_deactivated_folio(struct lruvec *lruvec,
> struct folio *folio)
>   {
>          int type = folio_is_file_lru(folio);
> +       unsigned long seq = lruvec->lrugen.min_seq[type];
> 
> -       return lru_gen_add_folio(lruvec, folio, -1UL,
> lruvec->lrugen.min_seq[type], false);
> +       if (!lru_gen_add_folio(lruvec, folio, MIN_SEQ_UNBOUNDED, seq, false))
> +               lruvec_add_folio(lruvec, folio);
>   }
> 
>   #else /* !CONFIG_LRU_GEN */
> @@ -442,9 +444,9 @@ static bool lru_gen_clear_refs(struct folio *folio)
>          return false;
>   }
> 
> -static bool lru_gen_add_deactivated_folio(struct lruvec *lruvec,
> struct folio *folio)
> +static void lruvec_add_deactivated_folio(struct lruvec *lruvec,
> struct folio *folio)
>   {
> -       return false;
> +       lruvec_add_folio(lruvec, folio);
>   }
> 
>   #endif /* CONFIG_LRU_GEN */
> @@ -622,8 +624,7 @@ static void lru_deactivate(struct lruvec *lruvec,
> struct folio *folio)
>          lruvec_del_folio(lruvec, folio);
>          folio_clear_active(folio);
>          folio_clear_referenced(folio);
> -       if (!lru_gen_add_deactivated_folio(lruvec, folio))
> -               lruvec_add_folio(lruvec, folio);
> +       lruvec_add_deactivated_folio(lruvec, folio);
> 
>          __count_vm_events(PGDEACTIVATE, nr_pages);
>          count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_pages);
> 
> 


Makes sense, thanks. I'll take your version in v3.

>>
>>          __count_vm_events(PGDEACTIVATE, nr_pages);
>>          count_memcg_events(lruvec_memcg(lruvec), PGDEACTIVATE, nr_pages);
>> --
>> 2.34.1
>>
> 
> Thanks,
> Barry

-- 
Best regards
Ridong


