Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F6A0E668B1
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 04:02:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890566B0088; Fri, 19 Dec 2025 23:02:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85D8C6B0089; Fri, 19 Dec 2025 23:02:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 761816B008A; Fri, 19 Dec 2025 23:02:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 65E056B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 23:02:31 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 07B0214043B
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:02:31 +0000 (UTC)
X-FDA: 84238502502.06.3D5B61F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id B5A7F1A001A
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 04:02:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HRzXcBno;
	spf=pass (imf19.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766203349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kvqmX5hgABRKtsoboa9njISBubOT841+nRpbPYRdnww=;
	b=6f8ss/gXpIdLeochu9buU9Z2a9noJJQAuij64b6H5n8hkynI8N4u6Apt8bilqlFBB623ZJ
	SKjnwizdoG5zQXB4Z8lS96aZi/E+N3gJ6oiCXZ05mMT1s0EkScMgloHrxiyU8fzL9wdiWq
	lmqerxj+Ityx389pXlIZMQivm/gj2nk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HRzXcBno;
	spf=pass (imf19.hostedemail.com: domain of bhe@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=bhe@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766203349; a=rsa-sha256;
	cv=none;
	b=ZkWHiRlibi3xp8Ny6/CD/9EPe4baVNR8TmQnb5fmng2M+LSLqUVAaxF4TXRbb8sIipl11A
	h6j1sehL4xUEyGY1e8NzyihbcDmbWW5D8NufjQn6Hb9y7VDvW3xPKDO3IkVzWwCYCBvNGH
	dI/oYya7LnSsKpQy/suEnY8GQngUxPg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766203347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kvqmX5hgABRKtsoboa9njISBubOT841+nRpbPYRdnww=;
	b=HRzXcBnoODZyuTRmFsotw+XuOg5D931pGd6nm9U8CUgcMAr0ND/hjRyGx7FbmSmv40FVXw
	Q/CEqhDXeGA20sDregebe4pBpd9FLYmVWWCpfp9CdB2IjIDMGEo0bit8FOZv14mA9VlNYz
	OwWBQoDXY7Ji5c5rWZHMPm8es5T8RWQ=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-177-NwGKxkwYPue8DRXokHcolQ-1; Fri,
 19 Dec 2025 23:02:23 -0500
X-MC-Unique: NwGKxkwYPue8DRXokHcolQ-1
X-Mimecast-MFC-AGG-ID: NwGKxkwYPue8DRXokHcolQ_1766203341
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7601E180060D;
	Sat, 20 Dec 2025 04:02:19 +0000 (UTC)
Received: from localhost (unknown [10.72.112.41])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 90CF2180045B;
	Sat, 20 Dec 2025 04:02:17 +0000 (UTC)
Date: Sat, 20 Dec 2025 12:02:13 +0800
From: Baoquan He <bhe@redhat.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Youngjun Park <youngjun.park@lge.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>,
	linux-pm@vger.kernel.org,
	"Rafael J. Wysocki (Intel)" <rafael@kernel.org>
Subject: Re: [PATCH v5 14/19] mm, swap: cleanup swap entry management workflow
Message-ID: <aUYfxQtmWO3STLa8@MiWiFi-R3L-srv>
References: <20251220-swap-table-p2-v5-0-8862a265a033@tencent.com>
 <20251220-swap-table-p2-v5-14-8862a265a033@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251220-swap-table-p2-v5-14-8862a265a033@tencent.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Stat-Signature: hhggp514z4n8wbgm3d59fcqdoqwgsbsn
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B5A7F1A001A
X-HE-Tag: 1766203347-846563
X-HE-Meta: U2FsdGVkX1/g8gP9aIPI3xVODjVSoXfAnH/lvf2D0zbhb/xPYvuxEPFlsJQWy0GvLCzugV0SGRo7D2XYsYqFIL/mEoBfa9UzhOuYnVjJeJMLEZGVAgBvoKxlSzFkInJW0jq3Ae3vxojFEi0J/7zrrhNkrLy0K6hCsxtDdXine3lR+rhwXCw4s8Q4LXW8Zs+FhYgg5CtvDPpT459ozsGJSJeLNKuGXgKd9ie+8ErdiegulVLgG4pPKWtOCgij/m+VwlBps5dPqtbIfr6n4uviHI1PLVHkxyPSdQ6mGm3udqpmkGPZee3J2AFS09mgJqP93vUXu6OyZkDm6e6zjXgpS6o1rGUX56h556Qflxwe1aXgm8nJsErJhCK+6/TzbDsLzLLruVnXfIO73yReEoBqPfyOixJ/zJ7Oo1ZcFSwzxWxWVl2JRVNFTLaJU/pcCxqoNToQuoGAWTvx3cN803S4AoMUyPHPewWrn77Y7ZXPH2UATvYfvJET63JZXFSTAgEN+3/mCzFEdrw2ZkHLG+tK7COsQ542tqftuzzKT9KN7mgF0c9YVz9t8fxKissBM7zI61oXDdUTbER6aoVxWlRht7CSgmpYAADMw4XkmTxoSQ/2sjzxS4d2Bug6H4tmPMd24QY3ls+QiX5Dl30AvgIbLx7MtYBTQKOXtP40wx++GdGULQjcOC3E0UHGJh/R/AAt8MjT2XZg5uioj58mA9VfOUGhdBT+g8zcnEghVoLyIkIOibhJpRi+QFkyyVtQneK+kIYmJuFJ+lniV9lYVChBn7e7cAamRXA2EXbQoY6tGWfO9eRr23FccrlvMpdJlO1ZueSkAJKmAEDKSZnOVOifNfZ82bBbGNj+jZSc0UBaHzJjFFELSsaS1QBMs2AVP7F0Zhh6oS1wYD9Gud+aTSqzeG6AIddcMrLSf0dl1MhhzN2TuaKkBzZUutftI473LnE2Uqzqkp2HTH/obvBpIWr
 fBAR394i
 km40xf9Wf839yldqZl9vx8ZHgFiBx5O9FYRHd+iuEEQkQPM1QnYp6LdZvNuQ6H9GLEBt00esrJS31QbaLU0EboHh6uk/HLCynW8ygwzOyUe7jt/2n13ilZwR2JT2ckU8QqCl5uoskSskYD/YKFxiRIOpSnIUY1hhDcaQsi/rteCqdZvvx3wOUUGN2wzsmktkd17A7G9t+a9P/rR6vJX8MuKvC97HjXtpm+GxeY0lAe36hKsCjB0/Ec0D+NnHr0eJZ+ia1rrTxOeosJDvhsNLqO/4bS+AhMzPd3WuPMYWRNu0GEQzyg/MUGW9goCta6EUBLZxSmH19HlurFn1fIomYU0x4xIYQSVvYxhYoH1whzIzs8TVN8MW9+Y90ZZ+tnF6IPPxo0wXnZR8CEW6P1HDkmNDhCqxGEaTZ+M9uebckZqEFs5E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/20/25 at 03:43am, Kairui Song wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> The current swap entry allocation/freeing workflow has never had a clear
> definition. This makes it hard to debug or add new optimizations.
> 
> This commit introduces a proper definition of how swap entries would be
> allocated and freed. Now, most operations are folio based, so they will
> never exceed one swap cluster, and we now have a cleaner border between
> swap and the rest of mm, making it much easier to follow and debug,
> especially with new added sanity checks. Also making more optimization
> possible.
> 
> Swap entry will be mostly allocated and free with a folio bound.
                                          ~~~~
                                          freed, typo
> The folio lock will be useful for resolving many swap ralated races.
> 
> Now swap allocation (except hibernation) always starts with a folio in
> the swap cache, and gets duped/freed protected by the folio lock:
> 
> - folio_alloc_swap() - The only allocation entry point now.
>   Context: The folio must be locked.
>   This allocates one or a set of continuous swap slots for a folio and
>   binds them to the folio by adding the folio to the swap cache. The
>   swap slots' swap count start with zero value.
> 
> - folio_dup_swap() - Increase the swap count of one or more entries.
>   Context: The folio must be locked and in the swap cache. For now, the
>   caller still has to lock the new swap entry owner (e.g., PTL).
>   This increases the ref count of swap entries allocated to a folio.
>   Newly allocated swap slots' count has to be increased by this helper
>   as the folio got unmapped (and swap entries got installed).
> 
> - folio_put_swap() - Decrease the swap count of one or more entries.
>   Context: The folio must be locked and in the swap cache. For now, the
>   caller still has to lock the new swap entry owner (e.g., PTL).
>   This decreases the ref count of swap entries allocated to a folio.
>   Typically, swapin will decrease the swap count as the folio got
>   installed back and the swap entry got uninstalled
> 
>   This won't remove the folio from the swap cache and free the
>   slot. Lazy freeing of swap cache is helpful for reducing IO.
>   There is already a folio_free_swap() for immediate cache reclaim.
>   This part could be further optimized later.
> 
> The above locking constraints could be further relaxed when the swap
> table if fully implemented. Currently dup still needs the caller
        ~~ s/if/is/ typo

> to lock the swap entry container (e.g. PTL), or a concurrent zap
> may underflow the swap count.
......


