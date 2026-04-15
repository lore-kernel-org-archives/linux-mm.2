Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62326F43828
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 14:57:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A37B86B0005; Wed, 15 Apr 2026 10:57:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E8926B0088; Wed, 15 Apr 2026 10:57:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D6DF6B0089; Wed, 15 Apr 2026 10:57:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7DB976B0005
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 10:57:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 162E113AFB3
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:57:34 +0000 (UTC)
X-FDA: 84661094028.02.A0BF817
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id D190316000C
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 14:57:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZOqieyER;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QhK952uR;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZOqieyER;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QhK952uR;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776265052; a=rsa-sha256;
	cv=none;
	b=6Pm/XkBgrnQylGZ2ol45HZ2PtNGelusGbv07I10HZUkQY4zYN3JNn/aycuMo7kKH+HYkRP
	3YuY896FXiBiVjK+A2frPHFJyFUcfcS9LaNpGmd8ZM+XNhCGQUYuSh3XEKjp37lOn8wOfE
	gpy2plJLpJRuInu2PekYGmXl0W5MXCU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZOqieyER;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QhK952uR;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ZOqieyER;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QhK952uR;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf08.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776265052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dejBW0wqfl5La/A5fNZs8+yJ4zYDF/zcppXmo6s+WTg=;
	b=O6bdTKtoscVbCo5jCL6Zc2yjaddCNNcBD06JS/C7oTdbR+kdLhJOLUE1F37OCdY1PS716I
	iuzq40OXTH8vkWKnkm6PvFfbzK2cWLG6ftkljzpqT6wzeUYn8oaQQmSd/JaFd7i/up1ZC0
	UQJopqAc17oRsLQnQPfSPkoS9eNSwQI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 03F8E6A7EE;
	Wed, 15 Apr 2026 14:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776265050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dejBW0wqfl5La/A5fNZs8+yJ4zYDF/zcppXmo6s+WTg=;
	b=ZOqieyERkstU4sq/1i1UVTKuxcJTiKftBbrzu+87cPT9jJCKFCJ8sSTA6HUssbcN4pUqv6
	PT7beI1ZTsgo/Kik48NrZNvogx+ex2X5la3wqDIAqs4xTCZ7HNZ2/QJBd+qZSKHCl+NB1y
	XvGfLgvHS0ILpEDkjJ46JbLmfX9RmCs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776265050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dejBW0wqfl5La/A5fNZs8+yJ4zYDF/zcppXmo6s+WTg=;
	b=QhK952uRnEeFAz0CfB0Hz+28Od4WreKz3F1G8dvjGLDWQLjrSUx/pz5YehqFOdxk40UuxL
	bvjH1iuArfq6g+Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776265050; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dejBW0wqfl5La/A5fNZs8+yJ4zYDF/zcppXmo6s+WTg=;
	b=ZOqieyERkstU4sq/1i1UVTKuxcJTiKftBbrzu+87cPT9jJCKFCJ8sSTA6HUssbcN4pUqv6
	PT7beI1ZTsgo/Kik48NrZNvogx+ex2X5la3wqDIAqs4xTCZ7HNZ2/QJBd+qZSKHCl+NB1y
	XvGfLgvHS0ILpEDkjJ46JbLmfX9RmCs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776265050;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dejBW0wqfl5La/A5fNZs8+yJ4zYDF/zcppXmo6s+WTg=;
	b=QhK952uRnEeFAz0CfB0Hz+28Od4WreKz3F1G8dvjGLDWQLjrSUx/pz5YehqFOdxk40UuxL
	bvjH1iuArfq6g+Dw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 274AB4BA7A;
	Wed, 15 Apr 2026 14:57:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aKYJBlin32k2PQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 15 Apr 2026 14:57:28 +0000
Date: Wed, 15 Apr 2026 15:57:25 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Matt Fleming <matt@readmodwrite.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Minchan Kim <minchan@kernel.org>, kernel-team@cloudflare.com, 
	Matt Fleming <mfleming@cloudflare.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Require LRU reclaim progress before retrying direct
 reclaim
Message-ID: <v3j7f476gbj7b5rxigpcorxhaimg5dyhgtovsl5quo7gc33swc@7i4ypekahw5h>
References: <20260410101550.2930139-1-matt@readmodwrite.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260410101550.2930139-1-matt@readmodwrite.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: D190316000C
X-Rspamd-Server: rspam02
X-Stat-Signature: sqwq4kym94ocn9aqkgmjmpw7zkciyk5q
X-HE-Tag: 1776265051-413811
X-HE-Meta: U2FsdGVkX1+MP29NW6nrKlwnyiWy3yFMIegtmJiI61G/guoVGiErVGrxLL48T18PaamU+fxk9VFwLULmDSaonNC/RrSWRfzZw0PWlAYD2ZbZXb+MAC2TRJ127HAvLUUCSuiMBo98OSI41K2S8/b2PHKx0BMCA7YzlrRuR9Py0gu7/L52ElI0U3hwY/35OcDvddKCo4m/+CzkDgxK0DwbY2cUbuA4nm1JsTQ9qSNdc8VohBD6vDreOl8AmSsB4ShS+SmFUDTC3c5MUESKtmXdf1YHmWkxuzr1nRlOfDqHlfjZGPz27MgAYrjTh97L//oFO6RjiB4YMs1BkRz20bmwZ1yGzpuGwie/PzvUlGhaAmHOrkKggOLHvEQ1qRU/cMGoFVz26dK49knWF+VdlVTIle77eKZKSgF0Ovi1vOXWyTZLB10gEr02U1FizMH9kR81B/xvbzcc0+RzjHaAiHPbOVjIkYwSGezWaV0xuj5p3BZ+B6bpSoM3r3ctE9zcnfBJJkYFlDwB/0DKmvFj4nUfTMIc5wjMpcPYOhgyFJvkaPyuD0C8J24pp8LzqStQMJz/xvpAyS4CO4+NEs/BZtiRxxA0FX9Cr92ve4zd/M7B0RwQYaC0wDCB1QLyDJnpdY3zH/L29DH6XKvW5pV8hB24ZsjEJraSmswQfb/21Buk/G1HYNSN3SqK8c8df+FhW5+TuX8HT0JB9r9AV7R7d0HMOrMDrhMHot86IWE9VAZKzVVeH5NF8jgodd0oTe3J+H1O1iAQZHPD/vAkVWbxrdBAn/nCYMZClj+ySqSsZhYM+xT34h2OASnaB0FgO7q7JVSpY3v6vJfV9M+k9GxM/DKFTo0EwHPmzbJ12gTfoNgEwhWQTDQwTAMcaPSS5zU9hgNbCMOM7t4HiZRs/h0gPa7ab2I1Jwf2Df9a0Rb7k+HIZfkNbUTdOi+q1Q6OWW6XAhqxBNLKNdh03GDlcr/nuUv
 mBZ/B3co
 guwaNg8YB4iWD1i4FSOc978BIx7lDnU8Ib2HhdpMf9K1eIIu9sQVmdz5y+ibUSZivSTsFBVBcGrJZlcP3MMJN4/XIzgNPgFoDFsdzudu5+R4XMHNE/3JSchCGBDHDnctXF/dFXKc5TmhGbGEoRYHs5Gl1UmEFhsk/oT0fJO399GS2MSCZ0uWeA1G9v2iRPdanNkHpAu5DKwtciA5c5SnZCcawTBxr3GXvh6qFJ7kfRxExCIjM9W16m3mgZc3axGvWZMSA1AfoULCKhRNRu64XpSFiZY25pGBy3apOPnuTVP46DvX/AAyRsKu8ynV5Ue1AFNDGhr8qhSGsfcI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 11:15:49AM +0100, Matt Fleming wrote:
> From: Matt Fleming <mfleming@cloudflare.com>
> 
> should_reclaim_retry() uses zone_reclaimable_pages() to estimate whether
> retrying reclaim could eventually satisfy an allocation. It's possible
> for reclaim to make minimal or no progress on an LRU type despite having
> ample reclaimable pages, e.g. anonymous pages when the only swap is
> RAM-backed (zram). This can cause the reclaim path to loop indefinitely.
> 
> Track LRU reclaim progress (anon vs file) through a new struct
> reclaim_progress passed out of try_to_free_pages(), and only count a
> type's reclaimable pages if at least reclaim_progress_pct% was actually
> reclaimed in the last cycle.

I think there is at least one problem with this heuristic: you are counting
everything that hasn't made progress as "we cannot reclaim it". When in reality
you can simply fail to make progress on any given folio as e.g it's referenced
and we want to give it another spin in the LRU.

My theory (from merely reading the patch, maybe I missed something) is that
a pathological case for this is a lot of folios added to the LRU in a row,
that are set referenced (or dirty). Say SWAP_CLUSTER_MAX * MAX_RECLAIM_RETRIES
- it will simply OOM too early.

The other question is whether this effectively solves reclaim problems - some
hard numbers would be great.

-- 
Pedro

