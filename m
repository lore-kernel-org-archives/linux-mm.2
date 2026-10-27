Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2A1A606A339
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 14:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cmpxchg.org header.i=@cmpxchg.org header.a=rsa-sha256 header.s=google header.b=OAHZJDP3
Received: by kanga.kvack.org (Postfix)
	id DEBE46B073B; Tue, 27 Oct 2026 10:10:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC3C26B074E; Tue, 27 Oct 2026 10:10:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD94C6B0753; Tue, 27 Oct 2026 10:10:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3FEC6B073B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:10:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C704809E6
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:10:40 +0000 (UTC)
X-FDA: 85368591840.25.3F23AF3
Received: from mail-yw1-f169.google.com (mail-yw1-f169.google.com [209.85.128.169])
	by imf04.hostedemail.com (Postfix) with ESMTP id 16C7A40003
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 14:10:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=OAHZJDP3;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793110238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5jxF6/4/W+A1WjrCqJd2E9d0nCbxdlQgcbJ/7pkC9T0=;
	b=6j4ecWZ01gmx1p6L85s9AlRiFBAmPgsMbksfccm4mbtlsw5iIIAqQPzV7ptEsHGvNc/tlx
	QYU3ptULxGbnuGTrpKwRsuwUPLLpb/B9qmCUL7ryo2qvd8qnHAkT7+d+Ug841nZCRLBnk0
	2vyPGugp+8VJcfEiXAh7jr7n/9Me3JA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=OAHZJDP3;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf04.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.169 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793110238;
	b=2DUkocrKEfIU1KMc86m8P+KZdn7QFiT72BKBO4H9IRa+fBQqZ7iUNAVIJFvI/8vfyGRrJq
	U9h0JyZ7gq8yRB2rPKBdtV7Rw+NFM5vOhbzbpIlh3uleBtdvyj9KYjtCKNA0XcYEQi/LOC
	23u/pQDQBwgE62VTHKpkgoBGErrwyCw=
Received: by mail-yw1-f169.google.com with SMTP id 00721157ae682-8ae8607e8afso30290107b3.3
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1793110237; x=1793715037; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5jxF6/4/W+A1WjrCqJd2E9d0nCbxdlQgcbJ/7pkC9T0=;
        b=OAHZJDP3RY0Idr/1QPEmHX1n/1y7C2QA7iU9QnKZtITMYsPFQE3wr3XZJ/anHNXD55
         VJD0n4h9vVEniT9d449wpa8PPusj87C86YGx0XmugpTJLVm7AhBMNuNksjyfxHdjBrCY
         jnGYdLVVuGPvhFAg57wVLL/GzVbegkqweav9knH3o8QFP477B6Wv90cz+5++31FslBCG
         k1MMv9ezvsdO1ZpJKn8wvq2VmSNpt95ORaMzDK0xikc6+QXgL6rowgdtuAad3PM2UhuF
         eHC1AxGhprhtCdiaSSla209sm5BZTCWjWwt6m9GCB0XeBj6VU8bpMHO4TIXgWm9XTB1r
         0Xtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793110237; x=1793715037;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5jxF6/4/W+A1WjrCqJd2E9d0nCbxdlQgcbJ/7pkC9T0=;
        b=hNbk9L3sif9HGsLUJAR8h2fUWFhhI/CtWnLM4j7NsEsP933LkQtMqAgYUSBakZ++c2
         Rn+h7D+R82dV0eB4P4D/cx9GgHvNWocUZ/ynO7mSvE0G4tIHf1E8Lq7TIz4ZGuq5OSsY
         vjJBwx9jKwNHIsPsV5ZG2HX23ozUFWQ8WDeNv50+oxzwFo1yLGjx6FI7is0iu065wb7N
         5Lu9/kzsfd9iiWzH0DMO/oWTgkEnmSSLnPYwIyyHSLtSB+VdX606s/IavpJNgKNBT6gB
         99uNuB/dilfRkkk8ZTC19dZpVkXsDUoxzPM9DaN8ljjP/nr3EUkeDuO6k8RYbpTPunv2
         GifA==
X-Forwarded-Encrypted: i=1; AKwUvBzcu1FHRmtM1BY8nsKM7qNZS3XC+f9mOpg4UgxB9Gqn++QT2b6LcNVIP61ZoaT39v0tFlDUCBr/OA==@kvack.org
X-Gm-Message-State: AFq9FYL3YSrBFKwWYYc7brfxeCpUpgyoUsbYmbebvJN0Z4TGEzGr+hMf
	1oqHJ5Ft4wgnWBnyDtSdF6OxN6Ncgzb43Auq5jggZxhdpUTsmAXeo/E9EAKSPM0yhMo=
X-Gm-Gg: AYBFou2WY5VZVkEAzf5xNyPLIdMFldHVxEDdw+SJ1O/iKQ+XO+F7Ajpb5RrOaqT/02c
	ZJFIH00TVaVocSLyM6X9V+n+UBC0kKYYDe4U9yNNdRdiQTlet3lG/9TYcR41pGEYnXMijepvkAU
	7jcLIX3o1coh5YwrdPAIeB5vTsX1CZ744pumdtSnHG2QkRFGdfZv3Xy6YKpWdgqYqQ13r04vX07
	ZOnYoQI3gBOehbr2fYnUKHZvb4PDi22/2oxPX2aEquP3b7eP65l4xusty6pfLLTX69Drrxx3qZf
	finM152WVYho6ICu+sIi+SoPJ/VlItuvfbNRGPpOAiPMesNDc4jRZy+wBGf7+zjw+Up1raqQ32V
	piEeOMLKUZ/Hb6dyEgvvp/1rrPTm4YJZJpMDfIIAHXiX43evbErhd/Zbto5ikjXhxsNZwVB3FGw
	hAS9CFOQIBDGiQilGvIL/TxaKyR3PiCw6tiNguNuIF6cMWb0TIz1pwZ9bFYTkIzOs/XiXmF7pkf
	ZB2nKbx6h037Auy/A1rlq9UnsgG1urX/gXbiA3LuHpC5F3V9UHZbP8=
X-Received: by 2002:a05:690e:bcf:b0:678:907b:3014 with SMTP id 956f58d0204a3-67a6b942174mr1866452d50.63.1793110236828;
        Tue, 27 Oct 2026 07:10:36 -0700 (PDT)
Received: from localhost ([2605:8600:200:14e3:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-67a7a07daf6sm127367d50.7.2026.10.27.07.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 07:10:36 -0700 (PDT)
Date: Tue, 27 Oct 2026 10:10:35 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>,
	Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>, Alistair Popple <apopple@nvidia.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	Matthew Brost <matthew.brost@intel.com>,
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>,
	Minchan Kim <minchan@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Youngjun Park <youngjun.park@lge.com>,
	Gregory Price <gourry@gourry.net>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-fsdevel@vger.kernel.org, linux-arch@vger.kernel.org,
	linux-cxl@vger.kernel.org, stable@vger.kernel.org,
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 10/46] mm/huge_memory: fix list corruption when
 deferred_split_scan() races with deferred_split_folio()
Message-ID: <auCw2-_yjh1_RjiO@cmpxchg.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-10-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-10-6f74bec9a5bb@kernel.org>
X-Rspamd-Queue-Id: 16C7A40003
X-Rspam-User: 
X-Stat-Signature: 7i7qdna1ss6rbxmy7owfjtqzb1py8sg4
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793110237-218182
X-HE-Meta: U2FsdGVkX19wMgHl9JLev5KlxZ2PLQs5fM24Qrqcyxtu+u2U6Us9v4UWd+Xn7rN8c8HYa+aDU69CC6mGarcsVr9/mmsThiK7MpYmfuK/ql2mNHMp2rfABx6ME4fPS4h2YW2C+72Yenz3cRoldNZgaIxuKgfPJAab8zx1tWPg9RxYyKMziI9YbB1GlGUQNvXEnUb3s/vhhV4nKpDCmW++3IhooPYTJ+ZOnHqtcXM8+wPHC6qb9fUb9pHvQjyNeyfPvqZD1M7OT0Iyw41sn+g8/0TVz1lAb7cjG4NGynhmbQK1/tvhSUvX1Lj11fxSasLiwUTh30tmJRo6yTKjLXuxCrksZc1OaDFjWNxSn2XZuGjCcntfbNJS94cLrcMAoPb3cSGZuJjbt8ccvjRWF/G/TNrHkKWwANCk8VghXfccMVYWO1VlHmmzbEatS9BlKqtZ77fx6geuHc9c95P81SMNXDNXaZqg4ZXcpJuMa6WM8MC4C0zNq3C6LCMDqrzjCWse2iXMPeeS+BCkpG99h84UXTBjzaSEDH3+UH6Mzc8DWcnntL1WOTcqcCWgblJ8l7kT+SzE6FOByxerG8w+kJZOGT/vea0lxKKgHwSwKEgjsg5AlPiEZ9tYqOfbYTQ6CfR4C9Kzm4cBdWNJVYC8E5QXu9NYBHC8PbRpNgJea4MAIrbx63ex2x2rs9TsPc1pOVjDlLQWrFLLxFb1rQWHpbKQLmzsetj2Dol5smdJMHy6RcbX9PpXIvD/6gbRtAExccbP7s9d0WssDuXTEeXWCB/STN7wDOaeC+Po6O1kFKLXWu7rH2ngjdyhjEhlyDLtPQqVpblep49Q9MyQb0hDYidTSDYVDQbNydpUGyVlMETH+3mzuFvzArV1e0INZ+X+/jFSEotdXWu/GERnUoFXGuJLtLZv7jzUSXl1+u4uowLjzPCXJiy5LCQJYxeUDFIktVk6JswJCiCQuNGkzcrNtBc
 sMTJsFiB
 cj8T9nMPOvPnDV724icCw6pjjcB4OQuQMXr8A+5VlJ4UdkuM35kSJAXuwicT4hqMyHn66CFsGx2YmGPNH/CNLNoCfgqenGfix7Tua2kickyIhyq/qLQhxLkhqa9414knYtHU5o3mPOk6Q2/qoBiXb3Iix/5MDcXE0xBULZnRwPp+HGNbc++AD0UETnfBF50UjuzO+RCwp+ZP4SDGYYjFW0d3SzR86bmz8HVC/Tst12wMW9V+2Z3RzQR8NCI1CfGr29rrhfOTaRy1dZ23n3HlXugFttZ3Xmkv8IBvK7jzdyarNDZd7RWvMaW5kDvw9OfA8+U2BI3sPzC3gfneCnRSWMCpt4EpcxMWdzErbZroV+szcNYbmQDz9KiBJUUhjCIOvNW2uW2WZiLXXmTVixvokud/RI2TraItZaEP7LHwmN9J29OHOzGoU/ZdEskgsraFJCUDncMqOqH5p2eze6u/6LBrSlgxFNhzI0QR1WVmo2FkKgz6IsMBoyRTMqBpSF2xCGDyfVfa09Uu0JcDvHvR4yqII4k+rgBNDDxOyErxeGXv8pqBoNJqt6nQ8zyt0xUQte7EifUEVdV377LMXsGI+wPEeo3eD4cZvDAjJ5ZNyfgMDN4Y/H4bWounVrjtP7Llv07ei
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:30AM +0100, David Hildenbrand (Arm) wrote:
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
>   CPU0 deferred_split_scan()          CPU1 deferred_split_folio()
>   list_del_init(&folio->_deferred_list)
>     next->prev = prev
>     prev->next = next
>     entry->next = entry
>                                       list_lru_lock_irqsave()
>                                       folio_set_partially_mapped()
>                                       __list_lru_add()
>                                         list_empty(item)  -> true
>                                         list_add_tail(item, &l->list)
>                                           item->next = &l->list
>                                           item->prev = tail
>     entry->prev = entry
> 
> The folio now sits on the list_lru with ->prev pointing to itself. The
> next removal leaves the neighbours pointing to it, and they still do so
> after the folio has been freed. With CONFIG_DEBUG_LIST:
> 
>   list_del corruption. prev->next should be ffd4000000270090, but was
>   ffd4000000278090. (prev=ffd4000000270090)
> 
> Fix it by grabbing the lock around list_del_init() so
> deferred_split_folio() cannot race with it.
> 
> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

