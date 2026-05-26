Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FA99CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 20:10:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D7E06B0088; Tue, 26 May 2026 16:10:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AFBB6B008A; Tue, 26 May 2026 16:10:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C4BB6B008C; Tue, 26 May 2026 16:10:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B0626B0088
	for <linux-mm@kvack.org>; Tue, 26 May 2026 16:10:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E76A1A0498
	for <linux-mm@kvack.org>; Tue, 26 May 2026 20:10:45 +0000 (UTC)
X-FDA: 84810664050.07.0D9D789
Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	by imf19.hostedemail.com (Postfix) with ESMTP id E5ABD1A0003
	for <linux-mm@kvack.org>; Tue, 26 May 2026 20:10:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ixkFNoJl;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779826243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4tFZxDP5yKXP0UhVdj6/0NYHpVXbpIOmDxHnncGDOQE=;
	b=b1WWMx/5OVSSsspaoUYFw43at323mlG+sVdrpKDptGt9q8y3o9JRqF3UdwFkcMq4jEetiw
	wEhoOMglnOKmpGxNFDQaKEFQWta6X8A0aVnXVF9EMS/nh6N8dk4aWwsg5GXSBi/i2nngnC
	QyfpfvR18o4hzFXc82hg1mHQDwomCc4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ixkFNoJl;
	spf=pass (imf19.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.171 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779826243; a=rsa-sha256;
	cv=none;
	b=69UGFGaSO4kvD5vtnCvKaULjr9eHpm8gFWYolKZ2t1wJtNtLj1NcnjbEZsyeyIZsyE2VQT
	cRP1errKL/sIos5qonfhCdc6maWIVpmSx+tOjKM4JTGJ0Qm5tJc+oADURAXPxowQg6Wuth
	dlcHfsG5i6e+JBDSUBU4QYsMJkcN7lE=
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-914c5898245so289619385a.1
        for <linux-mm@kvack.org>; Tue, 26 May 2026 13:10:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1779826242; x=1780431042; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4tFZxDP5yKXP0UhVdj6/0NYHpVXbpIOmDxHnncGDOQE=;
        b=ixkFNoJlsoQKXdp3YzAvEaX1zoa6Egw0R5Yz4eLZ8dI4ilts7h784ZKluNFTjf33s/
         ORzqGrBtiwF7SOdNGFn2nQpwsr4JHUa+0tcqTTHqNI9/6MHS2ilx68UBS+LlIwbj6dW4
         F1vGr5i23vx7NQ23NjruUmtlrcdeNUOppazsRYY8DWK14hSuS0nbYOC+rY3dyWbphMz/
         zAPg//OBzx/tH9pgZW3YTZ/Dbh0YuBnoECvlhtFNYzaVzfkn5ECnEfcGNwwL5UnjMWSW
         QKggylBRKmF7K7CtmshTvyhNNTr6TrncJxUc28zLM5vADm3iS7obz99C9QGQVrMbYx3E
         rIEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779826242; x=1780431042;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4tFZxDP5yKXP0UhVdj6/0NYHpVXbpIOmDxHnncGDOQE=;
        b=TMLDK53QXJLeclIpEDSWf+O5Cnncz5eJ06GGr7qngyBtWymZ5yxYGMq69ShBvzIrd5
         PVwfs+miD+DPU04uZCFvYNJnVMlQTh8OnSeBjptkQvFaF33z8/nNomd8Qn4nhUwoFVuP
         gnnW64acuBtaGgieRUNQFbef1M3P5CByuoAEtjCYSLLhC6JqO0H/mQXtKSrbJbB4HWGO
         MmU4I7n6g5QQCwv4rtgZsUdMFcYy53izndN9Pl7Pq9IDx5ANTzcSFNpfL0VLjOmNIekV
         GPNjR3jvE4cl6OsUa8YvHBIGUMv65sXa8Bod/bIZgR9nMMj62mDRt3TWsnvj7IzHJJUD
         Eqdg==
X-Forwarded-Encrypted: i=1; AFNElJ80Wih4KnghoMLTPi5bNTyUyXHyPHSvpdxMe1FwMMCxbd8OlFTo0DUQfjX+PaOgHfcwe55qsQ+heQ==@kvack.org
X-Gm-Message-State: AOJu0Yzppc58YGzUJrWx2/ZaIUYvOpkwU1dEDoZBXLjbQZ5+bXy1O6Oh
	JRdVgRdOmAuf+l4RFXq9t6AHORs8misw20Vkt+Nu67hz3VPdiEaJtpicZNCTZGi8150=
X-Gm-Gg: Acq92OFhYutixEM40hCx97i9jslsKk989QC0YwAHsJkwkTselkMRMNl2OLjNNyAxXzF
	2DZDh7OOFYL9HKDVoE9j9OrTCbDSSzLkdIhwNI7mn9L7WCEpdcjxG8oSGWO3JjhtKTXB3F6xf1b
	s6sHE6yTZRin/zC4ZmrzO95EHpMe8bL+vX4BVt5TA4CmBFieYQfQdJ7tIIOGhzqs6wzsyPVYrSl
	73tsfz2B6zehyov+cUKwa02o9UkGy2K1DLwZvKiSQmWBNK8KnykvCrIr6mro6DfosoYyPqn17Z2
	GvCBKz/ogyF77duFy1xVJUbLvggqXx5kEEyDCTemQjUetpZgOwQLG595dzB4ciFwoBS+8UBjrVj
	cE7A9Rzdl2XTBFEWY5XfqnFTQcfUrj2RTiVTvh5O/LylMqu7HBT28Mngvr6Db55PgFjz15yfY1S
	07oCauBmfAnu8Ige7fkFVw2g==
X-Received: by 2002:a05:620a:4083:b0:914:afb8:795e with SMTP id af79cd13be357-914b48e7e4emr2837476385a.19.1779826241715;
        Tue, 26 May 2026 13:10:41 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914f8810a50sm310312585a.41.2026.05.26.13.10.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2026 13:10:40 -0700 (PDT)
Date: Tue, 26 May 2026 16:10:36 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>, Zi Yan <ziy@nvidia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Kiryl Shutsemau <kas@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Kairui Song <ryncsn@gmail.com>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>, Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>, Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 8/8] mm: switch deferred split shrinker to list_lru
Message-ID: <ahX-PHlOwAn5whdi@cmpxchg.org>
References: <20260521150330.1955924-9-hannes@cmpxchg.org>
 <20260526120923.2331056-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526120923.2331056-1-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E5ABD1A0003
X-Stat-Signature: ep9sqk6c6eiwjc9mt5g74yomx449miju
X-HE-Tag: 1779826242-50627
X-HE-Meta: U2FsdGVkX1863++W2woH2x85PLPlqUubvh6k3xUlWputpwOiXDIOa2gMWIa70AsrcB7HpDWsBC2HJbViiGFjlKDzOROZCjfQnztUAp7YhhLNpZHEEL7KJXDCncGk1zpIrA2qLJOhyHfsAlm9ACjYUzaQgLCfMskCDBbIWbbjFtxd+JFSA+OLJhIM6xf/Aq4+DyDQgUUAbzlM31XwcMOErn75rLAspHeCQ74HuwqqMRPhK1B2aX4SFuIMzxcBluNptukL4w11QVKkFcXNITgGn06gc6z1tzwGbfPI1XORMltnB1iUeKwZnvgFTwEJ2W20DQnETHMceQqd3L02sBdDUK6Zp/PyFrBFAt+y+7U7ytUh2nodrpCIzO8cJ5Ps6rRmTlib973R3Wi50rJWuLN8WEQLcNJLhsDShVce8pxVJW8gRNHja/ilMUWYuZN2OCy1U/lGlP8vm2+iZZF5pheTx/XWi7fR8OjlNxNTwPV5Ws+7w+Of1kz/ymH2uOQIkAFpgsWGKQUcd3fHNELEtCeVI0EP3FcEJiYzheoUH6B9cDHf4n1WsRCVYEncaEedMwjfXdewkgQmDwxI0Il593glD/E0iLJLZboaEiaxLqJQso21THbzE9xXX+bY8jwzgRWKSONndS/wyRaWgLD3hHoUjpI5YG0340xufNlmQKzBRxS22HhUSzSt1b/fSpZ1VQphFiDMQf/mC5+7n391wWj0IgNEAQCcqFqEePxDmg3YpC6Qmx7ZoaiX2jYzacrUsjIkYXKTB3qbVmiqwXXlQEDjFF3/OrXingRIUMxGYW+WnnMKA8oI3jk+R5LDyUAg2lw+4nhK+1b1dYA1wssXYph9Chj3sRKW3hq5pC1YEz68fdyYlb79vLkl3TvXTz/Q9M70SevcFknJqNaWxl3aUMc1dW2st4zdN+1ntOsrny0yFsUaMWNfqDKnkgz3qNMoIpS+lldPBcP/krmQkn3FQJN
 cEc01aQN
 vak0EuI8yCIdiHn8CNhA6blsdfOREE2c23dOhflqb0sBd7MxAyLcghP3bffqI5THxsLx7hTafPWZdT1dW6oEgKt5IU06GnGCZbt0Cqr5ClJdVkync4uMf0xh/QGn0heddIEKOqEJhS4KHRZ+vBM0UxAX37LhGvsYcoA9+Xi2/B61peGuZr4abIK4ZvzYDlJdQqyHDMdF1jMZiyuKvdcJvP0dRcnswMKpqaWvIet1kEGqrRzwzuz2PPf5uvqeliwP4szeAYVW1tsJI6bJtjUQtYN2akAhZEsgYuABaFu9ue+347N5rvKWwq2U0RZHC5AAplG1kul2QCB19tA+Zm8xqee35hkO6OZ+YNvxX+bS0Psf0nG2a2RNxaOSVAq8jfK+Neyt6nUhSiquH7FzKGnxjdnu3cXF6pbKOBKTYUK0W506/DOmHUmG2c/qby5hRPsZp3cW8Y4TkRBXv8JfhHFcgsqNUHZXjUR/NO6yA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 05:09:22AM -0700, Usama Arif wrote:
> On Thu, 21 May 2026 11:02:14 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> > @@ -4446,36 +4377,20 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
> >  				count_vm_event(THP_DEFERRED_SPLIT_PAGE);
> >  			count_mthp_stat(folio_order(folio), MTHP_STAT_SPLIT_DEFERRED);
> >  			mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, 1);
> > -
> >  		}
> >  	} else {
> >  		/* partially mapped folios cannot become non-partially mapped */
> >  		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
> >  	}
> > -	if (list_empty(&folio->_deferred_list)) {
> > -		struct mem_cgroup *memcg;
> > -
> > -		memcg = folio_split_queue_memcg(folio, ds_queue);
> > -		list_add_tail(&folio->_deferred_list, &ds_queue->split_queue);
> > -		ds_queue->split_queue_len++;
> > -		if (memcg)
> > -			set_shrinker_bit(memcg, folio_nid(folio),
> > -					 shrinker_id(deferred_split_shrinker));
> > -	}
> > -	split_queue_unlock_irqrestore(ds_queue, flags);
> > +	__list_lru_add(&deferred_split_lru, lru, &folio->_deferred_list, nid, memcg);
> > +	list_lru_unlock_irqrestore(lru, &flags);
> > +	rcu_read_unlock();
> 
> Can the shrinker bit end up on the wrong memcg here?
> 
> deferred_split_folio() takes the lock via list_lru_lock_irqsave() with
> the original folio_memcg() of the folio. If that memcg is dying and
> already reparented, lock_list_lru_of_memcg() walks up parent_mem_cgroup()
> until it finds a live sublist and locks it (lru), but the memcg local
> variable still points at the dying child.
> 
> __list_lru_add() then calls set_shrinker_bit(memcg, ...) with the
> original (dying / reparented) memcg, not the parent that actually owns
> the locked sublist where the folio was queued.

I think you're right. Good catch.

This looks like an existing list_lru issue, actually. Even before,
list_lru_add() would call lock_list_lru_of_memcg() which might do the
hierarchy walk. But then set_shrinker_bit() on the passed in memcg.

I'll fix this in list_lru first. It's a likely backport
candidate. Then rebase my patches on top.

> > @@ -1301,6 +1301,9 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long s
> >  	if (result != SCAN_SUCCEED)
> >  		goto out_nolock;
> >  
> > +	if (folio_memcg_alloc_deferred(folio))
> > +		goto out_nolock;
> > +
> 
> Over here, you will end up reporting success on allocation failure.
> 
> Maybe set result to SCAN_ALLOC_HUGE_PAGE_FAIL?

Good point. Sashiko pointed that out as well. I have a follow-up fix.

Thanks for taking a look.

