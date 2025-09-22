Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86364CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 08:43:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E0AA8E0011; Mon, 22 Sep 2025 04:43:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 891C78E0001; Mon, 22 Sep 2025 04:43:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758CB8E0011; Mon, 22 Sep 2025 04:43:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5E67A8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 04:43:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C7C268742F
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:43:42 +0000 (UTC)
X-FDA: 83916247884.06.C6DF16C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6DA1F1C0004
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 08:43:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BWKLfjG7;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758530620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6dZLLbjdMnUvIg9VzmdVPy48qNzYPknOh8uhqC3nYWs=;
	b=VDXWoqVaLDjJr+eDDRh+m4Hse8VKuBSCZNLSH99fCmncppyWIKrjRCyUMiQwZgRn0tMlYF
	MwxWGZJ9+sRSFpchwA0e3ux2/AHqAs5DmKLNctfVlMIw3wQsM5gOJ+6bVGxg5UQjSVl322
	ISYEZ/QwVp+VOP2UYbL1Du/OTgxl/7c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BWKLfjG7;
	spf=pass (imf21.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758530620; a=rsa-sha256;
	cv=none;
	b=099kPuA/Xg7CO1OaRlUp5JR/XeMBkJbAdm/9KFGbcDJjTZvi3oruCDql7Otod/by+aUAmW
	Kl7kq1Zh4Yk5NPOSGqZynsNXmLcbGcK+4sZmyeP0m+zpH8csEw/3ftrp0PIQAJh6O30ax5
	xcrGAobKb5ybV+OUubfU84WeGhRWoSw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758530619;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6dZLLbjdMnUvIg9VzmdVPy48qNzYPknOh8uhqC3nYWs=;
	b=BWKLfjG7klupCCOfPXZp97sYrN7k+O7q2ZzzKcbeX68PSyIGc+qneiIkMdAhIrvAZSKpqP
	rTEQAHXVcMZ6s7KSCzJ4NZM6465Pn+p/fDo76Muyh1gnkdaRJkvn3l2dpeFuuzonspgPdS
	Euus0QG940+u2NEwk7yC1+GsjN29VTE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-612-N77Y2BVoNlWV95KWpfGtqA-1; Mon, 22 Sep 2025 04:43:38 -0400
X-MC-Unique: N77Y2BVoNlWV95KWpfGtqA-1
X-Mimecast-MFC-AGG-ID: N77Y2BVoNlWV95KWpfGtqA_1758530617
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46d46692831so3448425e9.3
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 01:43:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758530617; x=1759135417;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6dZLLbjdMnUvIg9VzmdVPy48qNzYPknOh8uhqC3nYWs=;
        b=bhfbzqHYtRUXJ/tWXsZ5VRvKqO48XAnaWBvZbp3Sne786wD+l51x99qB28tZojbodL
         Fh/t0+/a3vz86m96bHohUmeuIt7olhB1rh/cmcNvjs0yT7u7hWLvDsbP67gENCbAg65N
         h45bO2uGxcUAo6Ib7cV3h+jx43te/I9IuLWLomMZVNwA6cfGw6oRXQ+zW09TDXjMtopy
         nOXhd9Uel433Xn5ZTWpxHAeXqcZogCgX9WzcdBXdvGQYPbFNigLEORdMLc6nHwKHLprQ
         waBCXzQlVzGuOYdXz2NCLeA3nMyEqFif3n9xaEsy8163AYNOhw/V+g8lQSfGQB4x3FVh
         ix9g==
X-Gm-Message-State: AOJu0YyGNTkt8thsewmQzigCbLdf27jF4/1/20ABDYJVh69MkHnuzwe5
	1I+B3EyS+/hevpW9asHY3nT8BChVRA+3Ktpd3P+nlJPyqH3gOYlfvD6Vc1jtWQnoClynUeitawI
	Ce/vUgpjrSbU/l/xy1t+pkRJWBXG1xjgGkpRmmC96naqfOOSe1vKP
X-Gm-Gg: ASbGncuW2d9VWvO9Y+JC5Jkgd0PyQiHDdmy9Ag8WsYSSpGTE0Z7DfAYf3jHpQ5Z0/zr
	7gnEv+VuUvA6CNJjoJ5VWC+HGDi0gvoM5fY64Ldq/IXmqkBfTymN0yQDHuZSBJrplG6SdunAoaI
	xELMMi0W+x9F0XgDnwF1dQLw7AhITeKow6QRgOTz3kmqUMfMbci6Dl66hzLxGEMyUTneHye0MwB
	mnhp+TAp91wM8LxkFcpaqXN26nLSr3Iv2/qSFfq+heBvKKrTD/c34jMgHIyL8XUUahH4OpSL05c
	LztdqnAOivg/Gpthb5Pb9u71XiJ3uXNi4aYLcALkAUohPCSwEb/CuFO0h9RUyuDthGShgxFTce5
	/qd/iMiq1uR2FFsVY3QkdRhnA6GhnKXHkTFKphYmJFp/c3u/nhx9X3pnGUWnmUO0=
X-Received: by 2002:a05:600c:4f42:b0:468:7a5a:725 with SMTP id 5b1f17b1804b1-4687a5a0801mr110690845e9.1.1758530616713;
        Mon, 22 Sep 2025 01:43:36 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEd8F58bMwqbxykxW2EHlng+H3tgYCitYi/ROlfT1EKPjCK0qI5N5OizLnvQxyLC3ZQisYmoA==
X-Received: by 2002:a05:600c:4f42:b0:468:7a5a:725 with SMTP id 5b1f17b1804b1-4687a5a0801mr110690495e9.1.1758530616252;
        Mon, 22 Sep 2025 01:43:36 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2a:e200:f98f:8d71:83f:f88? (p200300d82f2ae200f98f8d71083f0f88.dip0.t-ipconnect.de. [2003:d8:2f2a:e200:f98f:8d71:83f:f88])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee106fd0edsm18355715f8f.53.2025.09.22.01.43.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 01:43:35 -0700 (PDT)
Message-ID: <40772b34-30c8-4f16-833c-34fdd7c69176@redhat.com>
Date: Mon, 22 Sep 2025 10:43:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: thp: use folio_batch to handle THP splitting in
 deferred_split_scan()
To: Qi Zheng <zhengqi.arch@bytedance.com>, hannes@cmpxchg.org,
 hughd@google.com, mhocko@suse.com, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
References: <cover.1758253018.git.zhengqi.arch@bytedance.com>
 <3db5da29d767162a006a562963eb52df9ce45a51.1758253018.git.zhengqi.arch@bytedance.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <3db5da29d767162a006a562963eb52df9ce45a51.1758253018.git.zhengqi.arch@bytedance.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ItjrrxWoziV2yrU3LaA7Omelh8BjKqdeXe0llMWt3Lw_1758530617
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fnxuop9za11n17imc439t3i6qafp5csm
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DA1F1C0004
X-Rspamd-Server: rspam04
X-HE-Tag: 1758530620-631008
X-HE-Meta: U2FsdGVkX1+Rye8l229t2smRqM/kSvl8Td4i/dwnRJGKYjxdtx7i4WN5o6oBsVOK84TU4xcQ6M3/kuRBQMsbsUIXF5EszqxrOTMZSioXcSJ2G+s84dxO2vB6yeXDrpwlJaVvD89kG8cXC6opSvejYT/YEZ2qqAWgfDU46evVqwIv3XOIdFRa42U58FyrEEAff/DkLShVIkh3hFlB5G7nT7VXJx8UaHVRkAmxwt29DIiG1SDLmPFm2w4nks1vG24AAFmA2fSiK3QyJS6VJpnxf86/Nu//upHEORMAcdITP14LHpBS4cJ8NHmghtdfGk0o0BPkEbFIF4n44qrxWfVKsftKTumVGeuQ0yDMXySYyACFzflkIGrb+2VnPG+ePBncINWXxutQY12KTtkoh/BSbW5JGdchgWOtYqV6jWKmeW9OMamRcIcVKkq6ESpSze7GGDkBThyDg4yYOuX5795AYrWiNEHgPDKnH5bPo9vNoR6Or2xmXEjhmNuKZK0f9eD9MxKiazx2s/7zF47dpnAQ0sc3DQ7Dj6gbLY0MPFIFG510uldRMhdfbS+xQSnUsIneJKfq9Tll3EeSQZhUQzCLJj3rY2VtRPU7aGykxUMzIL/ZyEBau2rS6GT5tkxOBwjSgq9eB/Hl6iQiFqiRuRH/qpY+6jr/KaXcMYLCV7boXCe+CEcj4AHDFmJgPYhZ8/n0QxReo0VwRWnSu434rmSaV4sAjB0rZjp7FZ64St7hTuL45h56ObbiudQdm+hRb9Yal5TG01OVkH9z0S/aednE1rljNG1bH5JLC+uBOojc1KC4zBqaTqA093iBT+SStO2uq9SejA+t+qiKPeHOq3Mr0TxAKJmjs2PFPD9mZaKphRybQqGZ/dYz5P0c1UI5LzvIAcHh2+tgy77v9WSzXgekm3qNbMIr8hX5F+m7Zk9c2Js1+jB4ALgDGnlsoYyiuoVB9J4ZuW60vk4UJInfo/d
 mDDxGFmo
 z4EljBe8BuV4vlRxlMoAf4YAoCxYc+/Khstclr3EjAKl1POw0AyL54CwZKoODfY5HeQxofM/cRtFMoIc8UsJzmfGSDSS8WPMgn6VAwO9QsG4ffH0qTSeG6YtBJ+uMAOaPo3ZRdhknLcghorn2iyJhkmT7Mw0CG2ffCuUeE25YoGUEpmWt9w8nC5OVIDcBDFazSmrKWmDFXpsShEnf/ZI+ndvMXIc5KxrhA01knC3KAKtZiPu3/Y5nWOpVbCvBNJMY2ZG9HuwKglMyQf3KxaOmex5J6Pzp3lXRlW1vWQ2xiGT+LMuFjctHaQMEs0sZc0uY0TCMkBKfQDySYGfd56c9+Si92QSz3aYgqDMkwJGeOJlXaZr5dkQ1ql7ugGBsB9SZxjClkuJ4ruaL5IIKYzgZZP0m4Rg5bbUGSYpteYFPCDrAysvdvxwL0VgkxeVE7zvVlPFQITuC+j3LG3ut/EHsXLbWWx3eGw65AfU3wD706C0XWVV459dfgRx1Rg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 19.09.25 05:46, Qi Zheng wrote:
> From: Muchun Song <songmuchun@bytedance.com>
> 
> The maintenance of the folio->_deferred_list is intricate because it's
> reused in a local list.
> 
> Here are some peculiarities:
> 
>     1) When a folio is removed from its split queue and added to a local
>        on-stack list in deferred_split_scan(), the ->split_queue_len isn't
>        updated, leading to an inconsistency between it and the actual
>        number of folios in the split queue.

deferred_split_count() will now return "0" even though there might be 
concurrent scanning going on. I assume that's okay because we are not 
returning SHRINK_EMPTY (which is a difference).

> 
>     2) When the folio is split via split_folio() later, it's removed from
>        the local list while holding the split queue lock. At this time,
>        this lock protects the local list, not the split queue.
> 
>     3) To handle the race condition with a third-party freeing or migrating
>        the preceding folio, we must ensure there's always one safe (with
>        raised refcount) folio before by delaying its folio_put(). More
>        details can be found in commit e66f3185fa04 ("mm/thp: fix deferred
>        split queue not partially_mapped"). It's rather tricky.
> 
> We can use the folio_batch infrastructure to handle this clearly. In this
> case, ->split_queue_len will be consistent with the real number of folios
> in the split queue. If list_empty(&folio->_deferred_list) returns false,
> it's clear the folio must be in its split queue (not in a local list
> anymore).
> 
> In the future, we will reparent LRU folios during memcg offline to
> eliminate dying memory cgroups, which requires reparenting the split queue
> to its parent first. So this patch prepares for using
> folio_split_queue_lock_irqsave() as the memcg may change then.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> ---
>   mm/huge_memory.c | 88 +++++++++++++++++++++++-------------------------
>   1 file changed, 42 insertions(+), 46 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index d34516a22f5bb..ab16da21c94e0 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3760,21 +3760,22 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
>   		struct lruvec *lruvec;
>   		int expected_refs;
>   
> -		if (folio_order(folio) > 1 &&
> -		    !list_empty(&folio->_deferred_list)) {
> -			ds_queue->split_queue_len--;
> +		if (folio_order(folio) > 1) {
> +			if (!list_empty(&folio->_deferred_list)) {
> +				ds_queue->split_queue_len--;
> +				/*
> +				 * Reinitialize page_deferred_list after removing the
> +				 * page from the split_queue, otherwise a subsequent
> +				 * split will see list corruption when checking the
> +				 * page_deferred_list.
> +				 */
> +				list_del_init(&folio->_deferred_list);
> +			}
>   			if (folio_test_partially_mapped(folio)) {
>   				folio_clear_partially_mapped(folio);
>   				mod_mthp_stat(folio_order(folio),
>   					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>   			}
> -			/*
> -			 * Reinitialize page_deferred_list after removing the
> -			 * page from the split_queue, otherwise a subsequent
> -			 * split will see list corruption when checking the
> -			 * page_deferred_list.
> -			 */
> -			list_del_init(&folio->_deferred_list);
>   		}

BTW I am not sure about holding the split_queue_lock before freezing the 
refcount (comment above the freeze):

freezing should properly sync against the folio_try_get(): one of them 
would fail.

So not sure if that is still required. But I recall something nasty 
regarding that :)


>   		split_queue_unlock(ds_queue);
>   		if (mapping) {
> @@ -4173,40 +4174,48 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
>   	struct pglist_data *pgdata = NODE_DATA(sc->nid);
>   	struct deferred_split *ds_queue = &pgdata->deferred_split_queue;
>   	unsigned long flags;
> -	LIST_HEAD(list);
> -	struct folio *folio, *next, *prev = NULL;
> -	int split = 0, removed = 0;
> +	struct folio *folio, *next;
> +	int split = 0, i;
> +	struct folio_batch fbatch;
> +	bool done;

Is "done" really required? Can't we just use sc->nr_to_scan tos ee if 
there is work remaining to be done so we retry?

>   
>   #ifdef CONFIG_MEMCG
>   	if (sc->memcg)
>   		ds_queue = &sc->memcg->deferred_split_queue;
>   #endif
>   
> +	folio_batch_init(&fbatch);
> +retry:
> +	done = true;
>   	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
>   	/* Take pin on all head pages to avoid freeing them under us */
>   	list_for_each_entry_safe(folio, next, &ds_queue->split_queue,
>   							_deferred_list) {
>   		if (folio_try_get(folio)) {
> -			list_move(&folio->_deferred_list, &list);
> -		} else {
> +			folio_batch_add(&fbatch, folio);
> +		} else if (folio_test_partially_mapped(folio)) {
>   			/* We lost race with folio_put() */
> -			if (folio_test_partially_mapped(folio)) {
> -				folio_clear_partially_mapped(folio);
> -				mod_mthp_stat(folio_order(folio),
> -					      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
> -			}
> -			list_del_init(&folio->_deferred_list);
> -			ds_queue->split_queue_len--;
> +			folio_clear_partially_mapped(folio);
> +			mod_mthp_stat(folio_order(folio),
> +				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
>   		}
> +		list_del_init(&folio->_deferred_list);
> +		ds_queue->split_queue_len--;
>   		if (!--sc->nr_to_scan)
>   			break;
> +		if (folio_batch_space(&fbatch) == 0) {

Nit: if (!folio_batch_space(&fbatch)) {


-- 
Cheers

David / dhildenb


