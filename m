Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F1EE606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 04:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lC/NIBrW
Received: by kanga.kvack.org (Postfix)
	id 7F83B6B05B4; Thu, 29 Oct 2026 00:23:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A9536B05B5; Thu, 29 Oct 2026 00:23:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1276B05B6; Thu, 29 Oct 2026 00:23:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 446B56B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 00:23:54 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 24AB4A01C1
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:23:53 +0000 (UTC)
X-FDA: 85374370746.09.C48D76D
Received: from mta0.migadu.com (out-120.mta0.migadu.com [91.218.175.120])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6D30E40002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 04:23:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="lC/NIBrW";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.120 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793247831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7dXsrgUlut7z8koNhHFnaevyZ/dqIruzgu7a/b5mCrU=;
	b=NIX8QMvCPGED8XeBj9QG3WBlePW68jJmFzqJqIe6e1UNrn/zSxGb46EuOtTwHlhBC3vOOS
	qL7iN95ZJFB5UarADajJqaQ95R3YSr7v+v5wOpAYm8wldagHhMi3Gw3pjjdNMtv+DmKsc4
	uPQcSOjH+lcX5dYRl0StKkMstY1mElI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="lC/NIBrW";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.120 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793247831;
	b=WHcKsIJ67fl2rO9/npAPrvcEwkxyO2+YhXXWvDHM7RSQuDabE5ygDW80hmdpVKf9MKFynO
	Hftkzj1c8pMmvHQcO7pZZH/RJIHgLZcv7ANuGOYYHSWuWr22/UHa7yNHLQysbW52dC9T0I
	Te1Uu68wZcHO/Ic7kZ4KrC+njWetMYE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KCVQ9p13e3GAc36gdApz1ELKMKOGi7CgHndl6zoXWi0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793247826; v=1; x=1793852626;
 b=lC/NIBrWIIa43Ewd1VbYlglYXZm0gnb6AM+04blOJkR2zPVx3qPb7Zty/QBotnG4NNv0IlCg
 K9EJROTLdodyX38OSXMr0Ro1zqJ7O70OIa52RpbWSqOb4S04H3kMyoR/CokAAmhp/FCkJPYnP5m
 /3YvbtmQdz+6tPMplXMCenuM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id cab5a1f6a6641afa;
	Thu, 29 Oct 2026 04:23:46 +0000
X-Mizu-Trace-ID: cab5a1f6a6641afa
X-Migadu-Flow: FLOW_OUT
Message-ID: <2bd4f0df-80c7-4d32-ab50-1225681ff6be@linux.dev>
Date: Thu, 29 Oct 2026 12:23:30 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/zswap: fix double decrement of the LRU node count on
 writeback
To: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>
Cc: Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>, Nhat Pham <nphamcs@gmail.com>,
 Chengming Zhou <chengming.zhou@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20261028113619.38752-1-kaitao.cheng@linux.dev>
 <CAO9r8zP15iW3ECW2Bs0rfyZrifeisDunLa6qJC43M1RcE16wWQ@mail.gmail.com>
 <auJkvb-Lq0M5Enkz@cmpxchg.org>
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <auJkvb-Lq0M5Enkz@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6D30E40002
X-Stat-Signature: rbnpm43kzzf8r8eeosg9xhi9dkwahyye
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793247829-304716
X-HE-Meta: U2FsdGVkX1+NOJ9VbEszV1R2WrTPXwKek5F+f0h2WaJdvsRXXAPCuxAUCd9JoPzVQC51ap5CnBSnzGbBz8IHRKb1a/YJhyUX9Fu3s+JNHY7XdZA8dwxoOAKpkMI3rEg8XhdVArBM/FyDqBcqV0juSx/6XzyVwX+t3jh9LS1ZWcUdeo0//kvVeLdrWt/Fl7LDtwxgbr/spVrT/sitburWplcl39dhgwCHOORpPcPMwuV+rfWSB1cLbUEUXsBDEO99CIoa6nkrKdy2yYl6roxhCy5gNQTpLXiuMclUDdnunfRLgtR84ZWK/Co77GLy9S8ufV6oj7xyrbCpTBqg35I8S7CJXnLLvNCx+oyhwTKPK/+SUM3r0oj6my+FZDgN9H4pWU4hXQ/5gH8ApTujGq5tO25VXTpHGLWPGyrPzoVonMfpBgvxkvvtGiX1EvFWWa4P0pyiGbvp/kwPrgm/LTem/jTdGKlKbziL9m41T2KC2aI+1PVIRKD513UaQp2kQ4aNSLQW8SCh9j8Ww4JkA8j532Ho+U0UxQdLfSTkxu5a6IEyf6EqZtUGLpKWTEk7hYaHat0QDU4lpvH3FV+pxquVGwNNLSpwbGnA3UP+4lLTEJJErmzam+L5i5WMnlergCOaqmm2yRFArv7n/2wuXsQ/Ye4lUDzDjDzJ4uBcdCDYMPb97s9spz2sehHdMUb4GB6KSi2SKDQqZwwTa7wFDR8oGNX/WKOq2RFmDkOHjWAkDh0bGFnR78FCJBDPfv/WYMihPiM2AkX+ZbAwnWCC8v61kwrkJIogYbT2Z2I9jJR3lcfNYomiVeMifwSVzVuCo8Oo597EPRuihuFKEakng2/MAbkYPOdHJg35v744RwnuMu9gavWjCYFdL0CZg4YZTXloYomAsoe3pj3GS/zGZkeLXKjdbAquhws3YORM6YCbXcIZJBMlgqJnSsrUe+cI/wkPMnB9ZEvLLbHxTpfBaKW
 Raf+XeAP
 miHxdQmY3LCfXLGcB+A+jqIDZ26NzoJLds96PTQWesDKrQzBS/5XDogVd0p3n66vDOEyHqdIYlteGNvR3mjTZHVM5t12ohvZfX4KNQ8KT4gyQo6dt3arYn/DX6+c+8KTkf8Gsk0pUfzOCGxKRZtE9KN///KwKVYglfmaiBvL3uJUQz6c2z2bq8C1qVLSqIsTxrMIUlEdEwQtpZ+UN7k0/QCUm+6Bwb7RAdeZQEEGMefvrpi4xf7AndqLGH6CPAKaa63OiU4uW2a39nw+oPIueW99URDt4n2xm9Akt4UO+VmnYtllCBobP5aU5hg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



在 2026/10/29 05:10, Johannes Weiner 写道:
> On Wed, Oct 28, 2026 at 12:22:43PM -0700, Yosry Ahmed wrote:
>> On Wed, Oct 28, 2026 at 4:36 AM Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
>>>
>>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>>
>>> Successful writeback calls zswap_entry_free(), which removes the entry
>>> from the LRU and decrements both the sublist and node item counts.
>>> shrink_memcg_cb() then returns LRU_REMOVED_RETRY, causing the LRU walker
>>> to decrement the node count again.
>>
>> I wonder if we have a valid use case for adding LRU_REMOVED_COUNTED or
>> LRU_DELETED instead to simply avoid the decrement.
> 
> It bugs me that it's the walker, not the callback, that adjusts the
> count. That composes poorly with the normal list manipulation API.
> 
> How about pushing the accounting into the isolation callback, which
> can then simply use __list_lru_del()?
> 
> The tradeoff is that more things need to be passed into the isolation
> callback, but that seems reasonable. It does make the change noisy,
> however, and we might want something like Kaitao's change as a
> backportable fix first regardless.

I tried three approaches.

The first was "pushing the accounting into the isolation callback", as
Johannes Weiner suggested. However, as Johannes's example below also shows,
this would require extensive changes across multiple subsystems. I doubted
that such a broad change would be accepted, so I dropped this approach.

The second was to add a new flag to enum lru_status, as Yosry Ahmed suggested,
to handle cases like zswap where the callback has already decremented the
count. However, the incorrect lru->node[nid].nr_items value in zswap is only
an accounting issue: I could not find any code that reads this counter for
zswap. Changing a generic interface to fix an accounting error with no
apparent functional impact did not seem worthwhile.

The third approach is the one implemented in this patch. It keeps the changes
within zswap and fixes the accounting issue, so I think it is appropriate.

> Thoughts?
> 
> ---
> 
> diff --git a/drivers/android/binder/page_range.rs b/drivers/android/binder/page_range.rs
> index b0c797523bc2..157256e52dd0 100644
> --- a/drivers/android/binder/page_range.rs
> +++ b/drivers/android/binder/page_range.rs
> @@ -24,7 +24,7 @@
>  use kernel::{
>      bindings,
>      error::Result,
> -    ffi::{c_ulong, c_void},
> +    ffi::{c_int, c_ulong, c_void},
>      mm::{virt, Mm, MmWithUser},
>      new_mutex, new_spinlock,
>      page::{Page, PAGE_SHIFT, PAGE_SIZE},
> @@ -684,8 +684,10 @@ fn drop(self: Pin<&mut Self>) {
>  /// Called by the shrinker.
>  #[no_mangle]
>  unsafe extern "C" fn rust_shrink_free_page(
> +    lru: *mut bindings::list_lru,
> +    l: *mut bindings::list_lru_one,
>      item: *mut bindings::list_head,
> -    lru: *mut bindings::list_lru_one,
> +    nid: c_int,
>      _cb_arg: *mut c_void,
>  ) -> bindings::lru_status {
>      // Fields that should survive after unlocking the lru lock.
> @@ -728,7 +730,7 @@ fn drop(self: Pin<&mut Self>) {
>          };
>  
>          // SAFETY: The item is in this lru list, so it's okay to remove it.
> -        unsafe { bindings::list_lru_isolate(lru, item) };
> +        unsafe { bindings::__list_lru_del(lru, l, item, nid) };
>  
>          // SAFETY: Both pointers are in bounds of the same allocation.
>          page_index = unsafe { info.offset_from(inner.pages) } as usize;
> @@ -746,7 +748,7 @@ fn drop(self: Pin<&mut Self>) {
>      }
>  
>      // SAFETY: The lru lock is locked when this method is called.
>  >  ........
>  ........

-- 
Thanks
Kaitao Cheng


