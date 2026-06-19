Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EFFB5CD98F8
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 08:03:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0D3B6B008C; Fri, 19 Jun 2026 04:03:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE3C26B0092; Fri, 19 Jun 2026 04:03:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FB036B0093; Fri, 19 Jun 2026 04:03:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D2F56B008C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 04:03:38 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 074128D922
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:03:38 +0000 (UTC)
X-FDA: 84895922916.15.2BED6BC
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf25.hostedemail.com (Postfix) with ESMTP id 346FFA0005
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 08:03:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JO24wKCZ;
	spf=pass (imf25.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781856216;
	b=EBIvOp32Nc8VW1987x9eStR1Y+MWsHRYpkCcKPVt8zxF233Dx/rfozV+JGIEuId1T3h1e3
	qlFIF79HGiu3M5YDkZcbOnCrCq/W9ferI82rVi7yAcP3HamgjRxaFXtArNQ9tob/m+aVkw
	A+A6ZFsgviGZtM7f20tojC02/NwoFPk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JO24wKCZ;
	spf=pass (imf25.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781856216;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=97ALfhxEHKnHr+DmTHdJ5AlydQr7RUIpXUMAyaq3tCI=;
	b=1CwQFaFizzj5OPf0YO8thr/2zXzB5uWdwiiQnbUQdqWh6YUrgSl27vYMHdgl5CYeNfmdf4
	CojUu2CPE5F4z65JjPsqEsOo4PAb4ET9Ms51brujyZ/O5lcqqKZ8lRy50aW/Hg7/m/r1g6
	Bt2kJNbs3fqLsbOQz72+8z1bruVLwEw=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781856211;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=97ALfhxEHKnHr+DmTHdJ5AlydQr7RUIpXUMAyaq3tCI=;
	b=JO24wKCZF5d/OU6egxMZuPUk6dgIJvBGm4v0uD7IArIJp9pyn/5XcsAHDty9wVgahfTxAv
	wA4cxqUQmxO2lMudPiLf1Y+W6W9OXOpiiN+fOvhlTVMSvM6HZAgFEnVbVgZX5rBmdGBZgV
	ych8oKJROkfLPyWkoMLLClVHFy8WIKA=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 19 Jun 2026 08:03:13 +0000
Message-Id: <DJCVAYJNZB2V.1DJFHIK9QB9EV@linux.dev>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-rt-devel@lists.linux.dev>
Subject: Re: [PATCH] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Hao Ge" <hao.ge@linux.dev>, "Brendan Jackman" <jackmanb@google.com>,
 "Andrew Morton" <akpm@linux-foundation.org>, "Vlastimil Babka"
 <vbabka@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan"
 <ziy@nvidia.com>, "Muchun Song" <muchun.song@linux.dev>, "Oscar Salvador"
 <osalvador@suse.de>, "David Hildenbrand" <david@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Matthew Brost" <matthew.brost@intel.com>,
 "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>,
 "Byungchul Park" <byungchul@sk.com>, "Ying Huang"
 <ying.huang@linux.alibaba.com>, "Alistair Popple" <apopple@nvidia.com>,
 "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin"
 <roman.gushchin@linux.dev>, "Sebastian Andrzej Siewior"
 <bigeasy@linutronix.de>, "Clark Williams" <clrkwllms@kernel.org>, "Steven
 Rostedt" <rostedt@goodmis.org>
References: <20260617-alloc-trylock-v1-1-83fd7858832e@google.com>
 <692d9bfb-66ee-448c-942f-a26c07a19f61@linux.dev>
In-Reply-To: <692d9bfb-66ee-448c-942f-a26c07a19f61@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 346FFA0005
X-Stat-Signature: pgu5tgtfsb7paeb36bmosre8fdt46gd8
X-HE-Tag: 1781856214-83104
X-HE-Meta: U2FsdGVkX1+1HPLt/AAjR0WwuQnzo7np2stybslVWr1B6moafqqVlktxtctvsa1FRWUEz0JvvYpESi+UT9kpbhj8Ydp/59xzcHu1d6X4oxx/s9zt5JAHrzRKbrrtACi9a84lE6ZLyJ3/bQNxI3iNvIUYsZ/rulAjM2cMcUD8pHXu2vnKStDTXu0yGtdIwM3bibVUblU6e+IasRafBVVDo4CN2Bao63vS7VJGBONV9oVpv/oLoVm5migyR0wCfL/bD/agfSj/EA04NRiyP3VqLDWJ0I1o3H+cEJDnlC5UrxgWm+5beBGe8/PEZJoma//7tZt7/Xl/7shf8UiaNs3T47DoF/X7zZkkqvDAjFc9Hlu7clhvYzhheKXrT8Mp8p3XU4kvgBJJ5fclqKyk2mPOUlSKy6zaEUsYrAb1nss+ULOFw5LH5zt8ovinlq8NEHiPLvN4C5ry2ryv5gdUWnXh6ieomA2b4iQCdzs6Y/oiwEBYpBLtUKkPi/6RNzBxMzkg50lgNkyafqAkXKgqelUWbbk/GDAHi8em4mut6dD2qt1RmXPGE7L9WyHBNcE69i6g+bU4H1vt26o1RbQGdwtFm6riaRrrBlENQFaLGDmJ0EAx8PnhQMdD6W5IxKkrH6t7oQj7817wxIADa+mpWAdaq5HZuzf96EGxi6d9Dc3qohvd0Z1VDBUEZSuTDh+Wefd083YgmlNKQ3vluMn19YoYkDcwxYHkDLrNTxJIT/Tc7y7ly3ub2qfZx/SR+ItU4yDRjamaIpa4eXBC0QUnXaL6RA6Dfw9FBWXoPGMSsfnzZQDx5mWylF6GBQKFXUlsvj85zWMd3K4Mf/LX3gqPSi/BjAOLQb/dRul2v/j7VQ4siUa6ruReX3ns4HX9RBf5mBbqu3vkJp0ucq+wD80k0QIGEAlMdJL9T1QQnxjdqsnFrqN34AIdGgh9m9tKrq7GtNiAxOzaKyds3mbd7IbD5UP
 kgTxi9lt
 za1tOlt57rZeRideApkRNchZzTJdUW3UnIISxCn+cNNuPMeQQvOUEetJSOEXMPPlF1iIbLhpsfVNTZzjE8PyqXO0KtGfA23e914+wlq3v1MRoqpDvCVt50v4vyzfNaO8PQzH9sTRXjkDboAIo3HZcx8tdoO8NWmkFOZDYwpyv1ePRe0iwSJ0rVDLJPggsthDZYe5+BzD0JLnlpK5Lwu21Zn8m94X8fnIKLSZ2+RRSES9ZQDWLV69QV2Ei1v1gUUyeQFyZuwCKVeoTZ4qKN+xoTzbtmMpBW3TL5yteZ0pO44pRfZHZmq543oOJUZN+nDteHSsjGJoDYaxYzGGedk6q2en3GxwtXGoMESi7l5qXeTFrYQA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu Jun 18, 2026 at 6:56 AM UTC, Hao Ge wrote:
> Hi Brendan
>
>
> On 2026/6/17 23:29, Brendan Jackman wrote:
>> Currently the core allocator code is controlled by ALLOC_NOLOCK, but the
>> main entry point function is significantly different from the normal
>> __alloc_frozen_pages_nolock(), this is tiring when reading the code.
>>
>> Plumb the ALLOC_NOLOCK control one layer up in the call stack: create
>> an alloc_flags argument to __alloc_frozen_pages_nolock() (which is only
>> exposed to mm/) and then turn the nolock variant into a thin wrapper
>> that just sets that flag (as well as handling NUMA_NO_NODE, similar to
>> how some of the wrappers in gfp.h do).
>>
>> Rationale that this doesn't change anything:
>>
>> 1. Simple bits: A bunch of the nolock-specific handling is just moved to
>>     the new alloc_order_allowed(), alloc_trylock_allowed() and
>>     gfp_trylock.
>>
>> 2. __alloc_frozen_pages_noprof() has some extra logic that wasn't
>>     previously in the nolock variant:
>>
>>     a. Application of gfp_allowed_mask; this only affects early boot, an=
d
>>        only flags that affect the slowpath get changed here.
>>
>>     b. Application of current_gfp_context() - also only affects the
>>        slowpath
>>
>> 3. The slowpath itself: this is now just explicitly skipped under
>>     !ALLOC_TRYLOCK.
>>
>> Ulterior motive: adding an alloc_flags arg to the allocator's
>> mm-internal entrypoint can later be used to do more allocation
>> customisation without needing to create new GFP flags.
>
>
> If so, I believe we could generalize this further.
>
> Under the current logic, |__alloc_pages_slowpath| cannot access the=20
> alloc_flags
> passed down from upper-level callers.
> As I discussed in another thread, we can introduce a new alloc_flags to
> replace the |__GFP_NO_CODETAG| (|__GFP_NO_OBJ_EXT|) GFP flag.
> This newly added flag needs to be propagated along the entire call
> chain down to |prep_new_page|, which means |__alloc_pages_slowpath| also=
=20
> has to
> handle this flag accordingly.
>
> I'm wondering if we could introduce a caller_alloc_flags field within=20
> struct alloc_context
> to handle alloc_flags that need to persist throughout the entire page=20
> allocation cycle, when such flags exist.
> I'm sure others will have more appropriate solutions.

Yeah totally, this is exactly how I imagined this evolving.

