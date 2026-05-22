Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8504CCD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 08:19:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CC5786B0093; Fri, 22 May 2026 04:19:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9B7D6B0096; Fri, 22 May 2026 04:19:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB2ED6B0098; Fri, 22 May 2026 04:19:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AC4A96B0093
	for <linux-mm@kvack.org>; Fri, 22 May 2026 04:19:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 625A81C0758
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:19:08 +0000 (UTC)
X-FDA: 84794355576.10.860AD15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id D28211A0002
	for <linux-mm@kvack.org>; Fri, 22 May 2026 08:19:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WWpL2KLZ;
	spf=pass (imf19.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779437946; a=rsa-sha256;
	cv=none;
	b=wjxGX+G6QifhjZIMCKQgdFAVkNHBtfywdymTWbv7snT8RdttqP4LVK14NzVJ+ZhZ0vwKQo
	F/yutqymsBMh+sEl4GzieWHV6LlZVoioFskpg++jMN3pj0sYMYX7ec1hadWGiR6TMPTkLN
	ZSzkhClVy0rBD7+13LDRwSeXduR9VWM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WWpL2KLZ;
	spf=pass (imf19.hostedemail.com: domain of osalvador@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779437946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CNPgc/AtB0Jee2xxiWKuQgkW16i9+QRUo+cQrRJrVkI=;
	b=V2akSMvh/p8beCB6pkngM8xK9YFf12qrwMyac9xMRPu/kS8G69TEolSeNXG+UFpk4NUwpi
	7GHuVZWClb5apYOJdq1Qb1ofQMx090d8ydARtFN9px2JIMpPce5NqPPWEEWPifMG1IrAW8
	tkDt5CY4+NugJnXalSnANXsSqGKGAM8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 51E346014B;
	Fri, 22 May 2026 08:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601CF1F000E9;
	Fri, 22 May 2026 08:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779437946;
	bh=CNPgc/AtB0Jee2xxiWKuQgkW16i9+QRUo+cQrRJrVkI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=WWpL2KLZnHVA8zr0yUIoVdMVNKhwiJ+wfE8fRSCG6iBcgtP4Vt4D2NVKhc8gyhCZt
	 7Br7sd7FZTzXFy1jB/ecY8BN1Dnfy8yI9HxSvLv+uAxjI1K4HZi/FuL0jPWjRSHWG+
	 vFLXE/0TdqZvPTB61z5ew1k2gy/FnhtmYvU/yX0OOVWoy2UPcoPs0+IaNzbVCwXE1G
	 Iyr/uW5pIk+xQ2qFbeJlLT6CdCebz3IpTz7sVzq8tYoepPzaPVw0ABZqGaP4OSaeLn
	 mKqECRs0aQGLKbI8fvlRiyJ0YVDqSiZEkbV0xIWmuYb3VT1LsuA7s6zXiEebqX7OS8
	 CjAPQtkhp5fUw==
Date: Fri, 22 May 2026 10:18:59 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Wupeng Ma <mawupeng1@huawei.com>
Cc: muchun.song@linux.dev, osalvador@suse.de, david@kernel.org,
	akpm@linux-foundation.org, ljs@kernel.org, Liam.Howlett@oracle.com,
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
	mhocko@suse.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend] mm/memory-failure: fix hugetlb_lock AA deadlock
 in get_huge_page_for_hwpoison
Message-ID: <ahARcwGqlMiIU-cx@localhost.localdomain>
References: <20260522010305.4099834-1-mawupeng1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260522010305.4099834-1-mawupeng1@huawei.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: D28211A0002
X-Rspamd-Server: rspam03
X-Stat-Signature: pjjso9goaj8rohn5d9xoqx813waektpd
X-HE-Tag: 1779437946-297869
X-HE-Meta: U2FsdGVkX1+jnEQR+WswRhr1U5L1gzUNdGQaewBMUGmWufIdv9ZWCgF/BOA9/vJNxtRrZjjXlUbBwB8OJcChnc2qdlmMn8k5+lc28CMPiqHyRXNzlEe6tAqILU7RcOeBIXdDMQ5Ik+gqzNAdxZZbdISv7FubKcl2oqRLWxhW9T+evHVRZ1hX5YeR7iTVmjxFzyrZ9pHIt5yC1AmQA0RvyB8iW4Sliv9Pnq4lCurOnCknVciqBFf9xwP8II96PHmX7155YvJLxCbqmf/l8GRo1PXV+9CATvtr+XwxpRwgHZFzA+TfuzAr5uxAqAvaFOgY4bBnVFgCztBjQWj/3kGVJDEc8XJ6+zUwjmJUKbr9Oh/8wtlcLYY4pBPZhjVUwz3wpxcPJ9TaZ6hsNkU270YeKGmdcKiXmPP6eyW921W6ez3K+O6VOSOnK1SDND8Gxiya8Hc3E2YOgcIuiN4+5VRUA1zvJxY5N+YESoS+M4EI6jSlNdSyuSmBRbLhiiFZgkbf/L4D6sNCKJ047fXLaNOwaGV6J0astlOEnPaHh+ZGtzk71G//AlMpHpTCB+V3YV8nct6EANcRjxL2ATjNv+khBl9nx65jCaYN2pME/8MFq5m4K5wcbc2FNTfsTW3T8ECJ7kaSQ+51xL1ukH94iiSh79c88n6uqZbqto1eZy6VfJv7T9lDrg0JiIV9tlS1NABF7Sv/l06m7Jr51bMJtNsF7yPPgWtiirk2K1ypZRnEiSB1jfSrn5xeaFkNKhzu1CEhD6fZvEsR3WYlnDoUh2FFL4lEY70jOPa4OhY6h17u/WfpQ6mmEawKsB/L2iEORxdHUSQfK2FziDL5MdXkGbqja4KKoRY60uXytcou1JIo0FAkn43lgSZgUqcBfnDSNB3LQWwJo+Kfo1DCnvLNCBVJkFRbhMaCty2ElYJSbGsMEESKdxVOgBxZpwDfItaDGGWzuADdu0kXzD1h/0chbi5
 jSNDO4cE
 nEVjmtiU/c9BvOOXA62ZIH2ns/iluwXxG1tSUB6TjggaL/eU5sffoOOrNY+NOuuRy8g1VLo6EMrZ0jQNOJrWHauUcpza+wljDJvkAgfzrR5OcbZOKFhPA4dbBBuSuoM6dPGS0b8C9qWxj9KyA0PZtV+3dh2oc4BVAlPElzqlBgzWWM5bh1f7vF7LEfAb+ZuakNKwOYglkzHf6Y+IZdPmBc/zFdaZBYp7lXDXk6VFjanhiy3XnisRE0eF9bpgPm6iqaTZc3L90OE5P1ZlAziU/dfLsFohS7qczt+UnWDHnOcZMOUlX/vMpwTBh9mMD3BMljJ2kvJrRZExpZqEioSZ1akplbIHDB2eRtsXADN6Lu+ixYIePu2FBN3wAo4c7RXknKyCt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 09:03:05AM +0800, Wupeng Ma wrote:
> Two concurrent madvise(MADV_HWPOISON) calls on the same hugetlb page
> can trigger a recursive spinlock self-deadlock (AA deadlock) on
> hugetlb_lock when racing with a concurrent unmap:
> 
>   thread#0                              thread#1
>   --------                              --------
>   madvise(folio, MADV_HWPOISON)
>     -> poisons the folio successfully
>   madvise(folio, MADV_HWPOISON)         unmap(folio)
>     try_memory_failure_hugetlb
>       get_huge_page_for_hwpoison
>         spin_lock_irq(&hugetlb_lock)    <- held
>         __get_huge_page_for_hwpoison
>           hugetlb_update_hwpoison()
>             -> MF_HUGETLB_FOLIO_PRE_POISONED
>           goto out:
>             folio_put()
>               refcount: 1 -> 0
>               free_huge_folio()
>                 spin_lock_irqsave(&hugetlb_lock)
>                   -> AA DEADLOCK!
> 
> The out: path in __get_huge_page_for_hwpoison() calls folio_put() to
> drop the GUP reference while the hugetlb_lock is still held by the
> hugetlb.c wrapper get_huge_page_for_hwpoison().  If concurrent unmap
> has released the page table mapping reference, folio_put() drops the
> folio refcount to zero, triggering free_huge_folio() which attempts
> to re-acquire the non-recursive hugetlb_lock.
> 
> Fix this by moving hugetlb_lock acquisition from the hugetlb.c wrapper
> into get_huge_page_for_hwpoison().  Place spin_unlock_irq() before the
> folio_put() at the out: label so the folio is always released outside
> the lock.
> 
> Fixes: 405ce051236c ("mm/hwpoison: fix race between hugetlb free/demotion and memory_failure_hugetlb()")
> Signed-off-by: Wupeng Ma <mawupeng1@huawei.com>

I was also able to hit this with two threads and adding some delays.

Acked-by: Oscar Salvador (SUSE) <osalvador@kernel.org>



-- 
Oscar Salvador
SUSE Labs

