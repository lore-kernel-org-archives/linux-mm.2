Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B586E606A33D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 06:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=Q/UNpbZP
Received: by kanga.kvack.org (Postfix)
	id DCD736B00EF; Mon,  2 Nov 2026 01:20:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7E106B05B1; Mon,  2 Nov 2026 01:20:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C93CB6B05B2; Mon,  2 Nov 2026 01:20:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7DB76B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 01:20:21 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 46F59140B7A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:20:21 +0000 (UTC)
X-FDA: 85389179442.07.E26C9CA
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6F440C0003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 06:20:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="Q/UNpbZP";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793600419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k85vwGun/ME58WuhAJ471wGe1ShuWGkpnjyDxU6NW6s=;
	b=KHRDx/bHt5NT5qs+Sg0hMuhWob7Ch99/8JVnipCAh5O09mGajlew6Uf/7QDWnhJrHUVjKp
	W7TDHVNxlwnag/lxe0Ol1l12lvh4E1sP5kyugozdEIzPJmlJ6ixxsL9YG2cL+RWXpIuI0x
	YG5zcwBONyXm2quzvIZMGh6U0xFaXww=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="Q/UNpbZP";
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf28.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793600419;
	b=X1VO2KrcADaGtZoQQxKNT4HhN+G86CAJwXqP7xVgulLAQvZVa+wNBwc6kHRhs7ua9/9unJ
	5C7xD2UKVU+rFPn+niTk+4NcYTQq5HjPtjk9Eq1DsuuAwxwdDVQ5gtAF9E36vG7UCJgb1p
	N+DMQn+Z68Y36gbADWblIbrv3Dmpuq0=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793600412; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=k85vwGun/ME58WuhAJ471wGe1ShuWGkpnjyDxU6NW6s=;
	b=Q/UNpbZPGiZ2lfUvuztAbfyteC8dpC8ZBxgMRePo7PvlqEeXwxTF6VZuHwaIUFhWuE/0gbAz+odMc3QiKOhJfAcQ0yjUlywrT+Of7qvM0sqvp6D5PPo2ZBwRF2war6T/1Mqd6StO0Grb3e72aes6LGEHnibsF6yC4pmj7OKwGuQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=67;SR=0;TI=SMTPD_---0XDunP4-_1793600408;
Received: from 30.74.144.167(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XDunP4-_1793600408 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Nov 2026 14:20:09 +0800
Message-ID: <2fd4f929-d7e1-4deb-b3c7-4bdc611e789b@linux.alibaba.com>
Date: Mon, 2 Nov 2026 14:20:07 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/47] mm/huge_memory: fix list corruption when
 deferred_split_scan() races with deferred_split_folio()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Kees Cook <kees@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Hugh Dickins <hughd@google.com>, Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin
 <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>,
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>,
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>,
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org,
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 Mani Tofigh <mt4022@columbia.edu>, Muhammad Usama Anjum <usama.anjum@arm.com>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
 <20261031-fixes_core-v3-10-d6437171ecc3@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261031-fixes_core-v3-10-d6437171ecc3@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6F440C0003
X-Stat-Signature: k7hxdc6igaf47fh46izry74u3anr9j1s
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793600416-890034
X-HE-Meta: U2FsdGVkX1+gkDpmGsoFZoa5RvoWOx56hK/+Vm6qckqbADR0A8e8Ykqxc12bjCivjjWvdOwbARjNIpz4RlCOXTfL9iU1ebDmDT6i0kUjJVNQsCCnhx/CJ/+Klcye8WehCjefA9/zKiVUZZ9TaTsbvfk3ZRDLkIlymWLkH7bJeBteMqENz6IuIg9VoIzg8BnMlIp73r5tYp564Zlv7m/TVBnNT26GmqjpLyCkrYlXTMpqthCR3ZLPKc+bNbe8wlYPEL9ZnRjfkcPQtnpQ6lk0rn2j/p24C6199EZFIx097ym+a4lPtct+At7ybePQOn/v07x06zrT0WTYpgx5poTP8gh5wWlSuZVm2PavYC0ih9e0P+qIttsx+FrskcZOPbRbvLUnwUxUg11X3mv22n1kdJaMQkAaUh/XmKGa5uGsmyyubAuRXviNv1UCn2LSvt8AlRitMp9+2YmZ04Hm3OidMcoWoy2ypeBY1uwU3f4V6mKS45O5fEOx0Vvr8P9kjdIvwFx4itMWV9STNICEDO+mp3hxUWygG4rP9UYdMtJB7D8H541Wd/b79X1vvKm/c3bfMFHCBaHNMLlhbilxqUQyPoqbE9vD1EH7MN5V7GDDi32MfaMGfluQ0M5L1ABhbLc5AIQo1hOCWM2Yreb06yXnrC1hh1VimkC63PPP9Nk++vtogWDW9MjQBycGof7whXFw4TCadwFDVa7j+2pnFSg+ghQfGtNQThQkWVUmVa3FRgOPOcb2mpLO7SS9gRFCpwUR9m8X6CMwDYNu6nX2sBU2ZkZzng+1sajRedoCfdtKjAyuar92vuXBTWEma7qyK+oK1yWTepuYo5X0laEG/JJL0cjEaDqEafMyJZsuAi019uDarFyXM9pZF3QbIPBXpspZWukpxThpbwjv/YwX1BNuUCmTdeOlFATUeZSIY0sxDV9OZhVp9fGu8IzloTwQiHOAkbfSW7eBx4B7vshr6tP
 PE12L15b
 ae31oo+460eHO5eB0VhNLp9Xm3B+LMRpJ/oWF43ibPsVwyRppwNZAfkJGGqWTwnE/tdgcqyQ5uEBM43OtyjKzEq8bTn7OJnXKaGfEPfTC3Kz7K8EYlumlLMz3sB5A5TwX5OalypcIgc1+8o7cBp4OR9JwhKY/60vA76ODF/Y8De67dwBsaxqrRAiZxHDEtgTavqQv9yhiqXDdWxQEF/fcMFUdUN8mlWdfWzrvsy5Ew7cs2BThaIFtCvk3YbiVZjcS46BuBQ0Ru8xtmhkAPm2jOAJADj6+xKHluf299HQTDL1eGtzUZS7tahVC1JK+E24UoIz0/AF11YSduN74PA3JeHookA7jLVJXyPJs7QVnfAt2hJtN777pJm7SeTIdicpr20bxvwUEGP13Re5pS4TFiMQmjjSkPz6chowmxZHBDNqdKTb0HiyHgcdHZyONmC9uEa/JHXjOwdMhQ9twmDB06QZzNBgmGGvebYwUX58iMGW1pDK9/g/CVrZYuzqyIo3Ifepk4HTl6rWCL11WLx7OiW1ZQBI/8G3yptEeCbk4lTYLbrja2bzBYyk61c1bQU4E0ijGFJclD16aqsfGAkzssGECFLL56jo/0hmYo4v3kZCptatSjG5uG2uuUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/31/26 5:39 PM, David Hildenbrand (Arm) wrote:
> Since the deferred split queue became a list_lru, the isolate callback
> moves the folios it took a reference on to an on-stack list, linked
> through folio->_deferred_list, and deferred_split_scan() takes them off
> that list with list_del_init() without holding the list_lru lock.
> 
> deferred_split_folio() does not know about the on-stack list. It only
> holds the list_lru lock when it looks at the same list_head, and it can
> run for such a folio: a THP is queued when it is mapped, as a candidate
> for the underused check, and is queued "again" when a part of it gets
> unmapped:
> 
>    CPU0 deferred_split_scan()          CPU1 deferred_split_folio()
>    list_del_init(&folio->_deferred_list)
>      next->prev = prev
>      prev->next = next
>      entry->next = entry
>                                        list_lru_lock_irqsave()
>                                        folio_set_partially_mapped()
>                                        __list_lru_add()
>                                          list_empty(item)  -> true
>                                          list_add_tail(item, &l->list)
>                                            item->next = &l->list
>                                            item->prev = tail
>      entry->prev = entry
> 
> The folio now sits on the list_lru with ->prev pointing to itself. The
> next removal leaves the neighbours pointing to it, and they still do so
> after the folio has been freed. With CONFIG_DEBUG_LIST:
> 
>    list_del corruption. prev->next should be ffd4000000270090, but was
>    ffd4000000278090. (prev=ffd4000000270090)
> 
> Fix it by grabbing the lock around list_del_init() so
> deferred_split_folio() cannot race with it.
> 
> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>
> Reviewed-by: Mani Tofigh <mt4022@columbia.edu>
> Tested-by: Mani Tofigh <mt4022@columbia.edu>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

