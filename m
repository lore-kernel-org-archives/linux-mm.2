Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F664CDB47C
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 02:27:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06E506B0088; Wed, 24 Jun 2026 22:27:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3A946B008A; Wed, 24 Jun 2026 22:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E036A6B0092; Wed, 24 Jun 2026 22:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B903D6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 22:27:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3C9388EED1
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:27:45 +0000 (UTC)
X-FDA: 84916849290.20.2C8D43B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7FFC1140005
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 02:27:43 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DbzrAQBi;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782354463;
	b=YNQR+B/pwu2insUQiHB6FM9tqERXYcitI6tSzbFlK5SadIMveTwFGfGXuh1K1Pd1rlG5ZV
	Gg5uIL7fBLB64ObBBrp6YIPMxkvUcIqY1xXlZJI/ZuURMCt7fsdRxM/uhx9hyuaisEMmHJ
	UqmNCv3I5NPKmtRNRVf3J9Sd80LFJeM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782354463;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=opuTRvHJwaMNifPV0It90Ejzc8af5zHdKuBMA/ZMsoE=;
	b=Ta2/ZNPVD5Yn7LYGNvviIgEO53fYAZFn2vMP/NHSATOtLT54ry9GRPUuxYmp2FTDKCDo8u
	4L5/8O5f+k+MK/JgLNfe5uHp7GlJoRQ9a+e3AoY0AQw/xdxPsWHkOSZmVCO5A6FdYSmRqG
	ln12i4SJn+Rc+eKnc5oegp2mlBAj/Ho=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DbzrAQBi;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0CBD8600C3;
	Thu, 25 Jun 2026 02:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762411F000E9;
	Thu, 25 Jun 2026 02:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1782354462;
	bh=opuTRvHJwaMNifPV0It90Ejzc8af5zHdKuBMA/ZMsoE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DbzrAQBixeyDdXZYzGJi2O4PFVgloKcZNe3AxZgtI1AlqusQDsZjXlyllY+m17gEa
	 +diFjtgj1hRifJ200up8bY4aCfJGEFXqLWQutj6eetE6r4NV55VWHWxLyoM1KkUuLn
	 7xehB0AMefpHwMCl2mT0hDtoXveESjv/rxkyr4ms=
Date: Wed, 24 Jun 2026 19:27:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: don't build vm_numa_stat_key if
 CONFIG_NUMA=n
Message-Id: <20260624192742.afbd255b97d82ecfe7e11e17@linux-foundation.org>
In-Reply-To: <20260618100614.1321950-1-ben.dooks@codethink.co.uk>
References: <20260618100614.1321950-1-ben.dooks@codethink.co.uk>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7FFC1140005
X-Rspam-User: 
X-Stat-Signature: kixca8dzmmp1mm4rrhtprfumxewbsw1c
X-HE-Tag: 1782354463-254622
X-HE-Meta: U2FsdGVkX1/w0tlmyNthl8+xgF+mSN+JjdG2djYqHzfItfuAz8yqwurFsc1rvjD/G5WVDF4CzpWyvT84WtP4Ox9gtogghXn8vhdqcuSUhEZA9oKsxm24uMyDyndztQ/M2Qpy0gjyIPbn1mv7J/mCXSvyZth9RrxlFod0DljdaMi2E6IcR0aQ/VuM8T8SuZ4sEFQRaL+SM4NoQjJEdicERUeYenvib2z4vGyLzC5Fu346NokHflL1lnx7qqJPJo9/rlxWAfMa5BN4nrfM7r4ZvVRU4gBnGVtUx+/ZFrqkg067N9tItM1md99bI0DSBq61pthVU7t6yY8bn4ZOG4bFFjpm4Omhtf66QpOHxpOWZg81X+K9+oa54WdMEKYyR0fLWACtOvoCzmF+QZ1JbpxrJKrRVIICK2KwPNnbAoYQXqalLqBjWn2Luwtqwe7Jw68/wk5r4/sywxW1cb9YyDYl7N6K6T2yrKt1V6OmjwfwrK+UgoWnei3Cmctr8zZ++Y5fLfKfjpJi1r6Sfp1Fvdrd/1eyAO2xHSefki/dfKWlfkjlqgjvEuB5T6KxTyN/kaNRdAB34sTW0DfpsM4dm64zbpgH5U56VjkDYvuC/PKPKEcE3+xmTjdBLbFVIFsftUD1UM0mcM3M7Xg5m95ADcktBA//c/kIFDC7Ck6FjIa5fHuQWQ5czhswhTp5+0r+n51NC/GT+Vx1s8OKETxlcKdHXTKmXVAIsql+IjCGmcsrCK96PGElINpxPS+9Zgc9VQsRD8A4lUhiXMln71K/cqNVtwNGQQyYsLCeA/5y9Jg5BsbFAiZeU0IlnQvkqhsmMOWUxwgmkv8e6FGKaMe/JZfdSu3gEeMY1UR4niClSxHyQWEn48yqq/r5etWkNl1MpJ77MdypcB7vy33JHDx+ObOVVHdf9Se6KXN7y2vTnhCKEIDXOWHzamukx3IynHu9kU+VAYLcIdmSNoQVMeWoRsp
 10EKykla
 5e6eNf5hqH0It1adfmMADrenInB9ZPGIfW0yU5mUN/poHgGFkTpzoJxxB6FwV7892RqiHL4/ANzB+9v4L75bCF6oQOJooEUgK4tGRBYw6ocLgsc3LwwMzP0F1SZ4Y0gEIgN2mUj5L+f7G9aYVXlt9R5h/0EmLUTepJR5wUxe6emTHn3LKy2sMNyALmfwLDXxHrvH+sFyWmEGfzDpnjJmw0WF8u8T67Gq6ef+mgNaZQdKAR8fm+pTJahzoTg/ED+WZnsKjQ4TjaJVmXdmAPXz4CuwbGiIBa2wVNU3EAbBJL/ZnZ3zV/KBQ+P9OhyZBqSUj7OjyWGFHEPCoEG8zDUC6MUzC/yl/F/NCZy4yJxXKXy83eObWBtmxzD0PcDy5/3ZCONgP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Jun 2026 11:06:14 +0100 Ben Dooks <ben.dooks@codethink.co.uk> wrote:

> The vm_numa_stat_key is only exported if CONFIG_NUMA is set,
> so avoid the following warning by guarding it in an #ifdef
> on CONFIG_NUMA:
> 
> mm/page_alloc.c:165:1: warning: symbol 'vm_numa_stat_key' was not declared. Should it be static?
> 
> ...
>
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -162,7 +162,9 @@ DEFINE_PER_CPU(int, numa_node);
>  EXPORT_PER_CPU_SYMBOL(numa_node);
>  #endif
>  
> +#ifdef CONFIG_NUMA
>  DEFINE_STATIC_KEY_TRUE(vm_numa_stat_key);
> +#endif
>  
>  #ifdef CONFIG_HAVE_MEMORYLESS_NODES
>  /*

It might be tidier to move this into mm/vmstat.c, around line 38?


