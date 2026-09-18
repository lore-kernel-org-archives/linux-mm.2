Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC442C982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 02:36:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 769F66B008A; Thu, 17 Sep 2026 22:36:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71C676B0092; Thu, 17 Sep 2026 22:36:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 630F36B0095; Thu, 17 Sep 2026 22:36:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 38B6D6B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:36:27 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42ED54055C
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:36:26 +0000 (UTC)
X-FDA: 85225319172.02.501E0E0
Received: from mta0.migadu.com (out-65.mta0.migadu.com [91.218.175.65])
	by imf08.hostedemail.com (Postfix) with ESMTP id CBCEF160004
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:36:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QUZwkVhE;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.65 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789698984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yp6fvch+AE++R7vgrTejWyuNgSzoEGtpe6oA3VzPSOs=;
	b=mMTYlGdvcyDvudgIOyM8cVxyHn3gHVpxtX2xvYqCm+vAJUQW9RajIcrJ3ij0j2Db/m/u0I
	Bc9/jTCar1KKFQs+koJ9jBgFoinF/1FJdSuAOYNEGgVzKDQt5SCfc7cLGvH8eND5H2C5uQ
	5385W3+I7wQMdHHEiqFK8x6r8JxZAks=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QUZwkVhE;
	spf=pass (imf08.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.65 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789698984;
	b=pGyRkeFbY2tC1VSyJfS3ilLG2hwf+IjJt/BDtAy6KaoDOmGzZQvsTcjbj0dyVSc7c4zQMs
	BKMNtzpAX1Hp805lifTCTZnk8jqcMsNXmeATM4PpIcBZGJZhVZTqjYa2tvJ51U/X9vr35K
	25UN90Vs5lel6mCJHokRJyc4O03JWDY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=uokSLb5tIWKs9wmoZjlPpYDU82fxVQpNKwqAQMjHX7s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789698982; v=1; x=1790303782;
 b=QUZwkVhEiApuqFBO2Qf3Sr/p7fX6co8bMIR4oUgIrzHtMdkY9hrcU4Xwy6OgO5607RIDk/bB
 6qjBSzNIWGstCwnQKGTcu28ei6A/eIE/F631ACwqzzAqf9w6A04RsJQP1gpP6sBqu0PGdX8OIKs
 YhqyYcHEEz6kqXiD9SONN6ZM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3b51e68b3c915898;
	Fri, 18 Sep 2026 02:36:22 +0000
X-Mizu-Trace-ID: 3b51e68b3c915898
X-Migadu-Flow: FLOW_OUT
Message-ID: <f16c55ba-3403-4721-9ff1-061d73e17fa5@linux.dev>
Date: Fri, 18 Sep 2026 10:37:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 5/6] alloc_tag: skip percpu counter allocation when
 profiling is disabled
To: Suren Baghdasaryan <surenb@google.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Aaron Tomlin <atomlin@atomlin.com>,
 Kent Overstreet <kent.overstreet@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-modules@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20260915070001.113559-1-hao.ge@linux.dev>
 <20260915070001.113559-6-hao.ge@linux.dev>
 <CAJuCfpFKGxOy9W+ZY9KasU5YaDVG4kbGsV6AYb2NNRyW4gT0mw@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpFKGxOy9W+ZY9KasU5YaDVG4kbGsV6AYb2NNRyW4gT0mw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 34pndcntp95btid77maekau77g5uhn6f
X-Rspamd-Queue-Id: CBCEF160004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789698983-785667
X-HE-Meta: U2FsdGVkX1+PB/lpwQWZ7uhH7BGFd5ee0o1/id2hVTNqK8yHSEZoo5vIcD2+w9kmY+LPoogIbtw2i1jq7hlZKLIvgk1F2N8bQm/Oi2wuSF5a6KGAluIvZ+0SAbfZC8pG9Lkn5p6TW804hKME47ZM+5ycjLyShnCGtEX8mUIxQWA3i5cdwnOgXFakigXKe6apR1N52ywdu2RmoIYAqDj8izQqy2pqjAYpX25Dp70Erovc7RLAPXdSDIpxzli2Wq8dH9i1LEuDPdKU2SkzXjRC+1uREtz/Felgt2BHCJEWeQUjTElWcNwE50Ib/A5CpRuy+ADrICq2wv3TQh+JQYKtyteAyU8RbGvOn1JyrlM5tjWqFIvhmfFJJ4D0/5DcOS1Yn420Hp9y+ZAIaV2F05PQTCgrtnr4aT6qycbikjlt4n3wvLj/FQLxkkNsQRrOdglTkAqTbKkp/nGoiIhDiX+hnowViEDu+FFZpnevGXPrbcoAE1B75+ePcSMBhKrIbbEH1Ljx1f48H/3uPcUpzVMlol2Cii9wHjDMRFvefciNgzw9ycYthIHG0lSCD2AX/DPgr2xXvFdPpkInNFLxQhcR00rRd5koi900Vv36KxTw93k1CR7gcloZoReTGI5Bo4urwvbHA4R9O1kIcOSofT2UEWj8tbyyvPTJoEGkv3VAf6iABKjyXIdddXO+qhqLNcAoQgT/GPPkaniaLLB5SLsoyWOjIAjYCFl7TTwK09+G33bQgdnDgQzLuawD+F45FI/a0COjvacr5XzyW0b8n11DVyODkiKsP4GegiUhJgCnGRFt02jx2YZEDUXSMEnuXW9SB9BjBKMevttTszJ7dl221druuC++P9ZULv0R7qUnAcCfMu44lByDz14wtBf9BHozsRy3GEnIi3O+UrLyoecSNqTmFpRbcRy+QpdoVKm7xpmGCfMgRyf0PVckxtKQ/r1+zrv8N6YG4ye+wX6ZW08
 mK8rqnzp
 6M9LjCynHEEB/lLDHMXmLkiTlkUORN9J+ZLOT4jbh5ec3RHvkx6qR9BuoJT+2/BeXyEMl0+bvWwVAp4Hkw+JIFrMGRMq3vp9Di60Z2+oFysOGIRIEjKN+4dR7mC3w4uH2A1E+1qCQakAArSand8nZbbBTCEf4C/wQJpO+dbd4oNDLK7e6tRB6Ix/u7fpkL8zy8z4B7S0NnxWeTHCWAhY8vhMXqumJZ0hzGTJlX0jetc8QCAXF/JjO7Dvj2nDwbFcmhVLkDN5dshSIZsiw/RZDgZLpIX9oob++Jmcet0lYNuKgU2E41pp8m1wJTAwI7q0mZLq04wiq+lUplBi9JRBUBJVON8K4QtgUquvGIlKSgzL4rLFXCYNkgkTgZH44o+Te7uU4EFZrGjP/uBYDmuGbDZ7I+6opgPMNM7ROnbFzvISZx6cxeAKnHmpI4uLyR93VIOim4NxFashd8d4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren

On 2026/9/18 08:53, Suren Baghdasaryan wrote:
> On Mon, Sep 14, 2026 at 11:59 PM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> After shutdown_mem_profiling() clears mem_profiling_support,
>> needs_section_mem() returns false, so later modules have their codetag
>> section placed as regular data and never enter the alloc_tag maple tree.
>> codetag_load_module() still called load_module(), which allocated a percpu
>> counter for every tag; release_module_tags() could not find these modules
>> on unload, so the counters leaked.
>>
>> Return -EOPNOTSUPP from load_module() when profiling is off:
>> codetag_module_init() drops the module's cmod, no counters are allocated
>> and the module loads without its tags. codetag_unload_module() now always
>> calls free_section_mem(), since a module whose module_load() returned
>> -EOPNOTSUPP is not in the idr but may still hold a reserved section.
>>
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
>> Cc: stable@vger.kernel.org
>> Suggested-by: Suren Baghdasaryan <surenb@google.com>
>> Acked-by: Suren Baghdasaryan <surenb@google.com>
> 
> Yeah, I guess I didn't think about alternatives...
> 
> When mem_profiling_support=false, why can't load_module() skip
> allocating percpu counters, zero out the whole area between start_tag
> and stop_tag and return 0 as success (mem_profiling_support is not
> enabled, so we acted accordingly)?
> Module will be added into maple tree and later codetag_unload_module()
> will find the module, call release_module_tags() (which is a NOOP
> because tag->counter==NULL) and finally call free_section_mem(). This
> seems more natural than special-casing with EOPNOTSUPP. WDYT?
> 

I see, but the module would then sit in the idr with NULL-counter
tags that become visible to readers which today never expect that state.

alloc_tag_top_users calls codetag_next_ct() to find the next codetag
and alloc_tag_read() would do per_cpu_ptr(NULL) for each cpu - plain
pointer arithmetic onto a wild address, an oops straight out of the
OOM report. 

https://elixir.bootlin.com/linux/v7.3-rc3/source/mm/alloc_tag.c#L503

So if the codetag section within this codetag_type ends up meaningless,
is there a reason we still return success? We will still maintain cttype->count
and allocate a slot for this module inside mod_idr.

I'd rather keep the -EOPNOTSUPP version (your original suggestion),
also because the comments in load_module() and codetag_module_init()
already document this scenario.

WDYT?

Thanks
Best Regards
Hao

>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>  lib/codetag.c  | 10 ++++++++--
>>  mm/alloc_tag.c |  4 ++++
>>  2 files changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/codetag.c b/lib/codetag.c
>> index a9cda4c962a3..a0b600720afc 100644
>> --- a/lib/codetag.c
>> +++ b/lib/codetag.c
>> @@ -240,7 +240,9 @@ static int codetag_module_init(struct codetag_type *cttype, struct module *mod)
>>
>>         if (err < 0) {
>>                 kfree(cmod);
>> -               return err;
>> +               /* -EOPNOTSUPP means we can load the module without its tag. */
>> +               if (err != -EOPNOTSUPP)
>> +                       return err;
>>         }
>>
>>         return 0;
>> @@ -388,7 +390,11 @@ void codetag_unload_module(struct module *mod)
>>                         ++cttype->content_id;
>>                 }
>>                 up_write(&cttype->mod_lock);
>> -               if (found && cttype->desc.free_section_mem)
>> +               /*
>> +                * A module whose module_load() returned -EOPNOTSUPP is not
>> +                * in the idr but may still hold reserved section memory.
>> +                */
>> +               if (cttype->desc.free_section_mem)
>>                         cttype->desc.free_section_mem(mod, true);
>>         }
>>         mutex_unlock(&codetag_lock);
>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
>> index 5836803898ad..1ca0409b492b 100644
>> --- a/mm/alloc_tag.c
>> +++ b/mm/alloc_tag.c
>> @@ -988,6 +988,10 @@ static int load_module(struct module *mod, struct codetag *start, struct codetag
>>         struct alloc_tag *stop_tag;
>>         struct alloc_tag *tag;
>>
>> +       /* Profiling disabled: load the module without its tags. */
>> +       if (!mem_profiling_support)
>> +               return -EOPNOTSUPP;
>> +
>>         /* percpu counters for core allocations are already statically allocated */
>>         if (!mod)
>>                 return 0;
>> --
>> 2.25.1
>>

