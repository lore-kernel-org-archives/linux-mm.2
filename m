Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E8BF606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OEOPfR8c
Received: by kanga.kvack.org (Postfix)
	id 7EDCD6B00EF; Wed,  4 Nov 2026 08:47:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79EEF6B05B1; Wed,  4 Nov 2026 08:47:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DCC66B05B2; Wed,  4 Nov 2026 08:47:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5249D6B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:47:57 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E6CA2140705
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:47:56 +0000 (UTC)
X-FDA: 85397564952.26.80B0256
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4C348100003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:47:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OEOPfR8c;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793800075;
	b=TfQ5NUrf559eC2c8JOaThMLH11x34FXftcae3KOdhUsij9Sy/0kW73eShoDPRv/YgRUcg2
	tsrYHSZys9m1x7hJmSd9j4GLXGDZ8QLvX1Rt0jUz4inC1VB60Ib3QPpPgfq7a4gEEO4eiJ
	vmYcjkIPs4Q4TPtGRE4cuLwTJ1GUkhg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OEOPfR8c;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793800075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTVNdWh8B46/PatSuHx4QbO9mWYJLcSt+owknOqg8D0=;
	b=sRDGsldkZSfr14CB6kjmlN3I8kJ7gC/3bpsGWkQD/QoUp4JiYstpBAI5qkiEDvJt9qOkcF
	gcT4UDgIzEMP3j+STAObyQcEKE25W9sM0MFW3kWILTxYUfanS0qbDrh0Z7fiSb+YwZnXhP
	BCVhMB5CHx//QRmuKnWS4aSjHXYjnf4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 720C443D4C;
	Wed,  4 Nov 2026 13:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AB01F000C1;
	Wed,  4 Nov 2026 13:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793800074;
	bh=fTVNdWh8B46/PatSuHx4QbO9mWYJLcSt+owknOqg8D0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OEOPfR8cPw7G74kt65uMFjL6tNhebIPjtChoImRgJ+W0MEr7uoduMrU+eTgQKvm50
	 sZD+lg9/90SEW6KMj/m24Inj+j3r7wAA0CxTbDDQITamh6oYP1qEWKKO6SPGfbl2/C
	 sUoEaiWsieZSFfxQp2z9mocrqbmiVEbG+KJ7RNxNOVb9PCZLcC2LP11zs61pIFjjkB
	 CQlZFdZc3vlLr84dUYfAnB37FN4TeJcZ43ldsrJX7qRj0RCtzdSlhrx23AK+IqAfIU
	 R7RVrZ/3s9++HyPr547nfY/4aKdSLJjsDjlR18pThjADN5b+zKFoTwNptFGT1p3JKd
	 QTdCyMOf9iZJg==
Date: Wed, 4 Nov 2026 15:47:46 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Imre Kaloz <kaloz@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] sparc64: replace move_pte() with a D-cache flush in
 flush_cache_range()
Message-ID: <aus3giOxv0WWeysK@kernel.org>
References: <20261104105300.16260-1-kaloz@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104105300.16260-1-kaloz@kernel.org>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4C348100003
X-Stat-Signature: a5bgs6tj9q9r4ibzx9zmiknq98skkutu
X-Rspam-User: 
X-HE-Tag: 1793800075-826813
X-HE-Meta: U2FsdGVkX1+7LLKTE479hIt/Zd9LVkfjRMple4tr3zDGThVaT8PbhGQdTQQDgMQ/O0ubLX4Gutx3/tBpTKmTU61qun2YB7hMqOHcOkHqgNU9l6HVP2cS4BNwX21n3osaEMdnlN5i/YcZlxdJcVXdo1Ks9Abe9Ddhgi8ZJhTQSXE7Ek6YE3e4BwmX4shdsN4gFHgPUiFS02I3i2Ig/0DVmcXnmJgB/kKukhD4F7ZDAgjRp67r0n30+E4FgS5EGkYVOZOS+f+JpfpuHByCXKuizmBbkzWkovvWXrI3hfAFUao7bfI3MXgT6E6t0WfQlejl5N8zAlxjcylGCK4zHjKkrWrOJILWAN5rg/FuKaQEQKNpZreWRcv/3ET5NZAIMo5PGomxhWzoW9SHaFH5e/9QZkObCq4rtRERZqUnkBTTu9SHAWTfAH3ww9vLxq/eTf7c+E3QWfHomaRn4WCg9xqj4BMBqf8Hwf4I0jTlOHR6/ztlDXoSkMBCNgSjo28e578tjFcXRo06v5DH7q+PBAHzs+JeKbWcKUROmirGd5sc0PjonoAswpnnl93VSKSHsXZfoAMi75rBxitRYHiitGfQMqiNjyv3Z6hPrc1MBQEuviwDtbZF65rdJ9WDu9yfT6PHxvgVoIrGCBiTXcNfI/mcRtESaZgnXJJw9h5MHW22ul7CLLcXa5X2/uxBT9HaBMFpRcZsBoBOKopT4vQ6FZg3nuO+AEm13s77BjwGdgvxV9idJRut0wMnFgbQTsAAFP4I7qe60ykRzuFFTxH2trmU5X3uJUqMTUepL2B9KylS9GFLT3/xJd6azECaH6G3kgH4Jk/eq684GAJaHSC/v4pNEc3hNcXAoJ5j2JZ44n6E5Okg/dfs/LgaO9r/r8WtMcpC97Xp0lT+SQBeufsCVFw4RajsQY+LSoiokXhc6NHjD75jGUUk96XPEAZbXiGB7ZQX8HLaZ4nn1idqOCezyTs
 fpoyot6W
 58qxnZszbX98/NviNePPHoii9a4+0A8CQsaIfdcATmgVRgzolt+63AH+nJxArzYUfEUWtqsPeMXbBnj292ErfexJ8VqykJz2V6lHtD9RMwnPUJc8aZuIRrBkMjLw79YwyI2JNVWo01M8y4sEvFryjNG4DBs29bFhhg6EBhhvRAvc3qQoKuz7Jpp/+SJ8ocEbFQj9+wDx18I+B9jZL9EG78DoT/7RovKzGl08holpA9uGso3QcElC4N1dErIwSeTfdpWvzexJWoOFTVb4bxdM/laliLwaqzpfQk1B+RNMCObzge+8eW6rJkmWn4qjVzreY2lWU6Ax9TYPhtMGBV9BrB5eAWo1bxJ0QOCyz+lGuRO7FIYr9NmiB6GcK9Ye8iPutfszb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04, 2026 at 11:52:58AM +0100, Imre Kaloz wrote:
> mremap() can move a page to an address of the other D-cache color,
> leaving lines of the old color in the virtually indexed D-cache of
> Spitfire and Cheetah CPUs.  move_pte() flushed the page for each PTE
> moved, which is only correct while move_ptes() handles one PTE at a
> time.
> 
> Drop move_pte(), which no other architecture defines, and flush the
> whole D-cache in flush_cache_range(), which mremap() calls on the old
> range before moving the PTEs.  This keeps the fix in sparc64 without
> a page table walk.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Link: https://lore.kernel.org/all/409079fe-ab52-4389-9fe0-d7246eb27bad@kernel.org/
> Signed-off-by: Imre Kaloz <kaloz@kernel.org>
> ---
> Andreas asked for this as a separate patch once the merge window was
> over [1]. It applies on top of sparc for-next.
> 
> [1] https://lore.kernel.org/all/4fba060e-c4f4-4d73-8efe-dbed0b5a7bc3@gaisler.com/
> 
>  arch/sparc/include/asm/cacheflush_64.h |  4 ++--
>  arch/sparc/include/asm/pgtable_64.h    | 21 ---------------------
>  arch/sparc/mm/init_64.c                | 18 ++++++++++++++++++
>  include/linux/pgtable.h                |  4 ----
>  mm/mremap.c                            |  1 -
>  5 files changed, 20 insertions(+), 28 deletions(-)

Lovely indeed :)

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

