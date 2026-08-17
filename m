Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8C8DC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 05:05:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A6C36B090E; Mon, 17 Aug 2026 01:05:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85C5F6B090F; Mon, 17 Aug 2026 01:05:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76E616B0910; Mon, 17 Aug 2026 01:05:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DBDF6B090E
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 01:05:02 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D2540140684
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:05:01 +0000 (UTC)
X-FDA: 85109572002.01.813B3C8
Received: from mta1.migadu.com (out-248.mta1.migadu.com [95.215.58.248])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5B59540003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:04:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HXw63Snk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.248 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786943100;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DObUnXHx/J22V0f8BJLxa41riys2kfX9t4dyZp9SMIQ=;
	b=fUT5mv5pdppbyT2bdxXeMj7hV4R12E1uQXSyxPLtUePdqhP+csWIg1FOkf83cGPcX7rx+2
	+19MrrKsIV+oxTtC1NhWD1oGaeHAl2BYXNtWo9Wl3eWyXjNijfZ/ReTFnkMkWrSs/6HMNP
	EQtbnYfIy4wJ4HOHIw2m0HH9almTUnc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HXw63Snk;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.248 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786943100;
	b=3VhGPYwYf1D1PxcivmTA/HRpNxmSWfd0fILA62FIY7uHY5qyBuJE6TFLD9xj8LCuLDwoL6
	9VKXLCe5M81TbmE08LRRhHHKSA/Z0moCsB9ppyStvT4xmUilZ5K7QFOWueNaAKdxg6DB4+
	WGEXj12aTdvH6F4pVgNsLXIM15ghWSU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=zZ6GXwC5OG4b5xcls/Kj0bSMKnufqj9IxmzWaj0rIqQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786943095; v=1; x=1787547895;
 b=HXw63SnkTarUFftqNxeC993R4l0BP1quQYnLVYcO85cZKsIwwBan/e8cRqzLDu24hTPeYh4H
 UN71qFRE3eP48C//7BnFi/dYAS44cZLsZtYCuJM/weegDyLjiZ7pZqxUuv8EcaNd4iVfcPe47I4
 vHOvnl4kYklwWdsHnmv98Cis=
X-Envelope-To: linux-mm@kvack.org
Received: from [10.42.12.33] (116.128.244.169)
	by smtp.migadu.com with ESMTPS id abd4cd8211b2a0ad;
	Mon, 17 Aug 2026 05:04:55 +0000
X-Migadu-Flow: FLOW_OUT
Message-ID: <e19d1b50-4d10-4833-8770-5003a0593518@linux.dev>
Date: Mon, 17 Aug 2026 13:05:36 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/3] alloc_tag: skip percpu counter allocation when
 profiling is disabled
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Aaron Tomlin <atomlin@atomlin.com>, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260813093421.135230-1-hao.ge@linux.dev>
 <20260813093421.135230-2-hao.ge@linux.dev>
 <CAJuCfpHAzhCC1Sx3uJr7kbhBzc7RFqwLhMyjo04hqZz=HBJH8Q@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpHAzhCC1Sx3uJr7kbhBzc7RFqwLhMyjo04hqZz=HBJH8Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 5B59540003
X-Rspamd-Server: rspam07
X-Stat-Signature: axdpznratu5ki69dag6kt3m9j5htnab7
X-HE-Tag: 1786943098-459362
X-HE-Meta: U2FsdGVkX18ujDSs8zBYBWxibfU4fSSUl6pphjfPTeshrnVI91XFbuWczdIL4354lkHM34iF/5/wSq7ljfIyU0Q0jYLyAO9EApx4NOU+IZ6sZFS3LUrPwKaL8k01Dm0ZdEQ6NMdEFBYW5W8nujAawcG7i/DJqP2H9/dhPvUBVBcHURmOQRextMUpl09LhJyAar91/ovrP0BhmSfdn8sAMSi//DzMtbzMBphRZA2Ag3AxWoVKB28t4kT80MlI006+6BOMA7yuaubpLZG+syq9VHhfBbOWMsSc8t/pz9y7llRp6ftikcNH/HjZZlWcEMyoCfUEy45fWewLp1TQC6DBKUG1ufKeQdTwIK2QXqtBVnmO9GsruDh8RgBHsT3E3dlG5Au5099RvRKt/cJOSmhHMY7MDDgRkx71/Nr19Gy4Bwr8FUPI2XUgMhDbHg6YgSnAxH7DwIsdptommCYN1nrS0lhhjqWqNeDE+QodJOE5hn+i9xctHEYAKgh2JJdzDO8kuAcTF5ZECrpj6rGuL8afo+jGaG5DCBKk84kg5JxiAU2eXI/ouWco763M8NTQgo2kTn/G2nhUZ34sYYmq43KDj4EADTMl8QYjxVgsLXXQ39yfBkrIDMX/sO4iqBmjR0F9Nh3jpXPxQ8vGv5lqrTN5vrRx6V7w4c7m5Lz+nYnaBWRCGbX1VWVxf1lpc7bDrxUroFFIc0DBIHthAHdXGamBi1K6qQRRi5/9EiTSW19FPzYcl/3Z9uHibEgl23qUu+JQ/Ui9NYJDfGG4GzbvO3zlJz1SAclu7XzSFYQIHsDWGDzmo8deRBwkdUs12gCOQOuWBc0K5XZvWVHMo29gew5+NNKal0ELK91MoGG0Kw5sh8NVG/g9Bqqu17gzxAPTkS0oG13JfZk9nf6FD00Z1KEbGdTCqrY2QdhAlBtqCkxOwoy3fqFr+Pk0bVnmoZ/+b1mqkydSWXab8epSAGnziS0
 LhPyD5L/
 cOKS4n4/gycIUB/ZTDEu/014GV7Iv1GoFUhy6dzWrujCg4fM8hqwQbMdNzU/HbSr9s5/G8VtmvugOMUKa8zQMpRPoaAK1Dkn41mLkZQJi5XxbR3Q3O65UUhUEY8ScR1gLc1UBllgWEUl65VvfrZEGruqqEsCuaHkCbX3DI8+dDcM4WQBpB7XobKqWPxadWbFpJ8mEqZBsPzH1N2DDOy/o8Yqp2XVhkRSOtanT0t38mEtPQ1h8wiinATq3VfSeP4ZqWh8NQr1BvwhVDnI+fLnxJwuY4uJWXzSkDvJPAXujLm0taLArbSDKyv4aA1qZ1W6h0Wp4x6y7PvIKgh7VIvlE+7nd/x6+3vt516SS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren


On 2026/8/15 14:15, Suren Baghdasaryan wrote:
> On Thu, Aug 13, 2026 at 2:34 AM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> After shutdown_mem_profiling() clears mem_profiling_support,
>> needs_section_mem() returns false, so later modules have their codetag
>> section placed as regular data and never enter the alloc_tag maple tree.
>> codetag_load_module() still called load_module(), which allocated a percpu
>> counter for every tag; release_module_tags() could not find these modules
>> on unload, so the counters leaked.
>>
>> Return CODETAG_MODULE_EXCLUDED from load_module() when profiling is off:
>> codetag_module_init() drops the module's cmod and no counters are
>> allocated. codetag_unload_module() now always calls free_section_mem(),
>> since an excluded module may still hold a reserved section.
>>
>> Fixes: 4835f747d3ed ("alloc_tag: support for page allocation tag compression")
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> 
> Thanks for the fix. I think it could be done simpler, see below.

Agree, will do in the next version.

> 
>> ---
>>  include/linux/codetag.h | 4 ++++
>>  lib/codetag.c           | 8 +++++---
>>  mm/alloc_tag.c          | 8 ++++++--
>>  3 files changed, 15 insertions(+), 5 deletions(-)
>>
>> diff --git a/include/linux/codetag.h b/include/linux/codetag.h
>> index a25a085c2df1..88081c618673 100644
>> --- a/include/linux/codetag.h
>> +++ b/include/linux/codetag.h
>> @@ -52,6 +52,10 @@ struct codetag_type_desc {
>>  #endif
>>  };
>>
>> +/* module_load() return values */
>> +#define CODETAG_MODULE_LOAD    0       /* module loads with its tags */
>> +#define CODETAG_MODULE_EXCLUDED        1       /* module loads without its tags */
> 
> I see no reason for adding these special values. You could simply
> return -ENOTSUP when profiling is disabled.
> 
>> +
>>  struct codetag_iterator {
>>         struct codetag_type *cttype;
>>         struct codetag_module *cmod;
>> diff --git a/lib/codetag.c b/lib/codetag.c
>> index a9cda4c962a3..8506ecab9ea7 100644
>> --- a/lib/codetag.c
>> +++ b/lib/codetag.c
>> @@ -238,9 +238,10 @@ static int codetag_module_init(struct codetag_type *cttype, struct module *mod)
>>         }
>>         up_write(&cttype->mod_lock);
>>
>> -       if (err < 0) {
>> +       if (err) {
>> +               /* Error or excluded: cmod is dropped, free it. */
> 
> IIUC here you want to call kfree() if profiling got disabled. If you
> return -ENOTSUP instead of CODETAG_MODULE_EXCLUDED then this condition
> does not need to change.
> 
>>                 kfree(cmod);
>> -               return err;
>> +               return err < 0 ? err : 0;
> 
> Here you can do:
>                     if (err && err != -ENOTSUP)
>                             return err;
>                    return 0;
> 
>>         }
>>
>>         return 0;
>> @@ -388,7 +389,8 @@ void codetag_unload_module(struct module *mod)
>>                         ++cttype->content_id;
>>                 }
>>                 up_write(&cttype->mod_lock);
>> -               if (found && cttype->desc.free_section_mem)
>> +               /* an excluded module may still hold section memory */
>> +               if (cttype->desc.free_section_mem)
>>                         cttype->desc.free_section_mem(mod, true);
>>         }
>>         mutex_unlock(&codetag_lock);
>> diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
>> index 0a7b657fe2de..461fa87fbb0b 100644
>> --- a/mm/alloc_tag.c
>> +++ b/mm/alloc_tag.c
>> @@ -977,9 +977,13 @@ static int load_module(struct module *mod, struct codetag *start, struct codetag
>>         struct alloc_tag *stop_tag;
>>         struct alloc_tag *tag;
>>
>> +       /* Profiling disabled: load the module but exclude its tags. */
>> +       if (!mem_profiling_support)
>> +               return CODETAG_MODULE_EXCLUDED;
> 
> Return -ENOTSUP here.
> 
> 
> 
>> +
>>         /* percpu counters for core allocations are already statically allocated */
>>         if (!mod)
>> -               return 0;
>> +               return CODETAG_MODULE_LOAD;
>>
>>         start_tag = ct_to_alloc_tag(start);
>>         stop_tag = ct_to_alloc_tag(stop);
>> @@ -1002,7 +1006,7 @@ static int load_module(struct module *mod, struct codetag *start, struct codetag
>>                  */
>>                 kmemleak_ignore_percpu(tag->counters);
>>         }
>> -       return 0;
>> +       return CODETAG_MODULE_LOAD;
>>  }
>>
>>  static void replace_module(struct module *mod, struct module *new_mod)
>> --
>> 2.25.1
>>

