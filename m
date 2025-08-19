Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0879ACA0EE4
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 00:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 132B46B00F2; Mon, 18 Aug 2025 20:13:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E4416B00F3; Mon, 18 Aug 2025 20:13:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 020B66B00F4; Mon, 18 Aug 2025 20:13:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E4FC86B00F2
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 20:13:45 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 33CC656EF9
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:13:45 +0000 (UTC)
X-FDA: 83791583610.03.43413A7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 817FC40008
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 00:13:43 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EZIufOcn;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755562423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KxwkrwlxIJhjwW4dmw15/23VfantoW/YxRDROi5gC0M=;
	b=MQFr6D6JAAiEkplIuDG4FF2tDcvrAvPdqehpcruHx5ibfdHlKfK/DvnFC7RvqRItnJyeQh
	89qw9PI33IbmAHc2m3l3sH24VAa6yoJQR6CMPWUGBcj9y2po7exJ5MyLSMknd/X9pj+/a7
	3N17SgfTjyS9uOz2lMNHk91I0qD7GGM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=EZIufOcn;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755562423; a=rsa-sha256;
	cv=none;
	b=20YNMuFn7IAK4xjvDR2wyQX27IlkxmItg48tghszkt16BDp9XQ8PrQsIqq34TRpdOxB+gT
	d7TjY2/okJ5B7Gp5dWmUWicsXd8Fal121CkccPJ3ko7uugckDOM66LimhkaS84flXKlI2/
	7eEwNRKAyuQXEhJ3Q9HA7OQEFuTecQ8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05AE7443D1;
	Tue, 19 Aug 2025 00:13:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7BDC4CEEB;
	Tue, 19 Aug 2025 00:13:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1755562421;
	bh=GBanHK/LR/pCa+c9vWGF20U2DJFnrBk8djjY08eqQnI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=EZIufOcnq3zWlRpA9rbGk9p/f1cZCEKsXyvKj1S+SVM+4GuekTaYnAQeUabIkSBFl
	 p2ErIcETq0LI3Sm8ulCEAYOuI0sg+jYbSF83JwcVjHQjlfy36QDSW6S1Ls4+Soq0lK
	 Qjm0I4kbptksi3V8jY59h3Ip/yTyvcszwGZTBA+w=
Date: Mon, 18 Aug 2025 17:13:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Chris Mason <clm@fb.com>,
 Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@gogle.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, Zi
 Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH] mm/page_alloc: Occasionally relinquish zone lock in
 batch freeing
Message-Id: <20250818171340.2f4ce3356f1cda59acecab57@linux-foundation.org>
In-Reply-To: <20250818185804.21044-1-joshua.hahnjy@gmail.com>
References: <20250818185804.21044-1-joshua.hahnjy@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 817FC40008
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: a3umr19o3tqsshskbmekm1crn1hspcn3
X-HE-Tag: 1755562423-220347
X-HE-Meta: U2FsdGVkX195zQeXNSwBk7buu4fZjycgLgvYmLRH60Iej7v5aT5cI+r8In6leomC7lIn6zhE2jmoocb5NwCgbrZB8Ab9F+ZC3iB7ShQ1khT+orEESNZ/acRfJqzyy/YR/wLqNqmcbZfW+Lr58ydibqN+zMXQz+V+DlaOl4wBMrNG2+1ZD69UKAtW7ClSH8jNnyYQ8F2KbdQyu5ABhjWxh2mAqoV/50rSIn69JCjK7Tnbc6//E+g1taMbcPQtEywSzmsw8Si4DQxY9MhFHM4DaIgSnB+qkJbC3trGawYhH/OEk8XvtpFLNNztC3u6Y5YtYSkOe2K4M6+dRNZJN4tqZlnCxP6wg2hpCxXn48ybFTFwpwoxrd2sqfJEJBLlUhO1EoFr9qc3OYdRTF0rwrqon4eMT1jHZZZs9SFnke/jc/tOlexjbDNhc3kh/AypQzDlwHvU70mf2jX1etrun7k6vO6cKXqikBOpafwvEeoihDtJdRB3l9ihFTamKv/FeKtAIuP0MNYItvmj8dyML5vDI8VSoV8t4G6j9jGQKmuhY8uMxO85Q+No3sgqpjWwFNb0p5y1EtBOc8RyHeyGryqvdRPlJJHELTznBXYcPpHtwzPlyeoaCTppVv6OCIx/Oqga4mVJDyl1/EwS+gqXX9eMpw4ZsUpezsUBA58M/5WKyhAu0xgYiuiVv56PDsToftr3v+sJ8T17qAnODO6bj/GVMbtFjyHeGRoRgJSNMsKWiJLbManuGi21BkK9wCMnq1VzGdkdkTgzINKNoXOxBhITo+svxIG5nv6Rzj4tiltM8SP4s5Zx2QYs2mNG7mnubztvUTp49NNqao0Hg1IhlOJcxFBEt/K/Y5jwN7oeezrQhwSuZAv5p7qrLjy0lTZodlXYoAYu+GW4lB1by1mvIvigUfPWpdeK23ox8MT5fr31Gdq8LTrPKBOpDX/bCOu5SuQi0HCvKNqMLO5YNkDwufI
 MvT+nfs2
 WZ4PAg2AoWT5VCQ0x7aSFl+PCB78fLm5BFSEV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 Aug 2025 11:58:03 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> While testing workloads with high sustained memory pressure on large machines
> (1TB memory, 316 CPUs), we saw an unexpectedly high number of softlockups.
> Further investigation showed that the lock in free_pcppages_bulk was being held
> for a long time, even being held while 2k+ pages were being freed.
> 
> Instead of holding the lock for the entirety of the freeing, check to see if
> the zone lock is contended every pcp->batch pages. If there is contention,
> relinquish the lock so that other processors have a change to grab the lock
> and perform critical work.
> 
> In our fleet,

who is "our"?

> we have seen that performing batched lock freeing has led to
> significantly lower rates of softlockups, while incurring relatively small
> regressions (relative to the workload and relative to the variation).
> 
> The following are a few synthetic benchmarks:
> 
> Test 1: Small machine (30G RAM, 36 CPUs)
> 
> ...
>
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
>
> ...
>
> @@ -1267,12 +1270,22 @@ static void free_pcppages_bulk(struct zone *zone, int count,
>  
>  			/* must delete to avoid corrupting pcp list */
>  			list_del(&page->pcp_list);
> +			batch -= nr_pages;
>  			count -= nr_pages;
>  			pcp->count -= nr_pages;
>  
>  			__free_one_page(page, pfn, zone, order, mt, FPI_NONE);
>  			trace_mm_page_pcpu_drain(page, order, mt);
> -		} while (count > 0 && !list_empty(list));
> +		} while (batch > 0 && !list_empty(list));
> +
> +		/*
> +		 * Prevent starving the lock for other users; every pcp->batch
> +		 * pages freed, relinquish the zone lock if it is contended.
> +		 */
> +		if (count && spin_is_contended(&zone->lock)) {
> +			spin_unlock_irqrestore(&zone->lock, flags);
> +			spin_lock_irqsave(&zone->lock, flags);
> +		}
>  	}

Pretty this isn't.

Sigh, we do so much stuff here and in __free_one_page().

What sort of guarantee do we have that the contending task will be able
to get in and grab the spinlock in that tiny time window?

