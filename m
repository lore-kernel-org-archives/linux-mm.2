Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20F93606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 14:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h/bZGNdg
Received: by kanga.kvack.org (Postfix)
	id 4019C6B05B5; Thu, 29 Oct 2026 10:07:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B20D6B05B6; Thu, 29 Oct 2026 10:07:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C8686B05B9; Thu, 29 Oct 2026 10:07:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 11C566B05B5
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 10:07:28 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EA3111C3B7E
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:07:26 +0000 (UTC)
X-FDA: 85375841292.30.94D38F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5615E20002
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 14:07:25 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h/bZGNdg";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793282845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yWokR00oy52lcRfgOHsrSCc7CbeEVF8tg0js36RpqSM=;
	b=s6ejrpgZo6PTWWrhG8sReh8/hNBXkCjIF8gkerfzQcRErcHcXB+M0jxnGceawA6pzji6im
	T8jFz2xPSNk0RYLgMpcMT8brOrSP/rXBUnQuSs8skOm68QcMT6cAgV0PnUgVOFLsw71Peb
	zIPFRfUg/6YrTrpFwX2+IwbIu/AlERw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="h/bZGNdg";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793282845;
	b=ZVYkQcDdLOjtGWqQgOHEOgjTMENBcbx9b6MBchLBWbb7HucmVS4/3SQMkqa6q4ZyzZ45Gf
	hf1hrUyCvBRBbX0VdUBo4oZsuBbv9bk4gejunUquy9TGuENfA+vgc0RgZer1N9DLpuPcbB
	ByGIIt2VxejQnBncXHdEz5UNcYpFK4A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C29596021E;
	Thu, 29 Oct 2026 14:07:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38941F01825;
	Thu, 29 Oct 2026 14:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793282844;
	bh=yWokR00oy52lcRfgOHsrSCc7CbeEVF8tg0js36RpqSM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h/bZGNdg6ZSylv020gtdL1fR7zN4HT1MWDQJhT6W3de8MCURCqWbt77taZYMYBrNV
	 PiNXcx7r7n0CZUBwZTC9oofVZz9/FXdc1prLqOOXsOpwfLBBbZSm60UWgZjEbaJAv2
	 MAQSJxTYZdul12qbMyW3ut6T4fioUDh07Lo3F0ymL7x/T+wkgUDyMux6ecx74jngFC
	 1oRxb+R8j3Ydb8flB6dx19XJSnG7cVOuL5DUQXCQEIBUWbzdu2fKEsBfH4lz5ZsPkE
	 AeoUembg4FhSsnjVSUELyGk3g4FD/l3VYynMr06uaeZsen9V2t+GC1I29wDxGIittU
	 zImBRvZ5Xm6aA==
Date: Thu, 29 Oct 2026 14:07:21 +0000
From: Harry Yoo <harry@kernel.org>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org
Subject: Re: [PATCH v3 1/2] mm/kasan: Detect double-free involving
 kfree_rcu_sheaf().
Message-ID: <auNQ9fjjyF5Xa0qb@thinkstation>
References: <20261028194014.3671161-1-kuniyu@google.com>
 <20261028194014.3671161-2-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261028194014.3671161-2-kuniyu@google.com>
X-Rspamd-Queue-Id: 5615E20002
X-Stat-Signature: g35m99ae4kq65394xg31mp9egb49ecnq
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793282845-310815
X-HE-Meta: U2FsdGVkX1+wC1Apef5NQAV2kSBD0Cs+YSowCHjmjXWE+3unTuMX1FhYIO/UoY8uXlEHP1UjcQohiVxF591cvhiE5KSXqjpqp1g8/3mi6qybckgJ4cNoSF7vXm30Qa/ZmaZHXKzY6+lpEXgx2ylL/3RPvWAeL+s9mBRLQyI746OiR3zTQWE6mUHBiGe3r9TgPy0WCgivvvED6AjxlaqmmszB+wZ2YexBD+LUva5Tr39lXkf5fj/WadWqFjsHK8P9L6g7nRBHd5R57ByjXJ6styV7WnSYFaWPklmMI11fjvaIazlbiP/MSIgLcoZk5hC1zGx7MU8yCPWBShU21AThsDpu5GCht6gThdM70Erj++Odm1cciInEN7wZ0sl8sSuarTnp1CfQiPG6Mu4hilBBKcq/jOxeKGT6J07vfvqGw/u0Xm5TmmRJyNGYOJB9x9a5KfIQyqBku+ATtCeEbpzh1P4zgN8ORKAhms3k1Vm6uq0YFUvPw/mQHfK+Hxv2v4zORkJ0cTzIlZSuu2Kbn2P9FXG0Yo9LYTvpz1VixLNLH3mbOjDlD0XtExs8PA526RxT8A/OUllK1dexKV5GV7ME35qQL5orMJk2X67a5fBCRCactt7oMTsnAERGEOnGzl2OZonBazr2vQ+PWYp7n4s6EwUdIzKppePsvWuepPpv6DYtDZX1GjKATgKDJGRqHE3WavZ2IYR/V39W/oyY5EXJ+ml8l6bDa3VWIxkoTB3KzrqAHLIkG9xgUcX/ydnI7LqLtZDAWlk3f3cF8V7VYcKROtO+Xc1LybpRl2FuvCqqmp3C/2KD8WPAz7sSFa4PQaJcP3ox59A1IxsND/0TMPGS5i3JvjsOIyjt5v3TU1nr7mguAIHTszwSN5kz2L1ccWXt3rHny+X3rZWdFZSDCQI7eyBV0m1pSmZ02BuPuBfMLcSI3VhNyZMkGIsW0szOVU/EP43895JnfhmGoKH/ShT
 QcmVGsUy
 0sTso11kTZr9znD/DkTEZNgS45AAPiHAGG51eG4ker4V1TvBAsJILEwYaUbbG80JCNGZdL/U+iZP8CAYsC0tBA9DGMGa38xcIsq94qRQ6eGtmEx2qfzHXkA4tv2bTjUOoztqETsbUfIZeDPic7su6VVg+2GkaK7fEwZDqlTFMFJPJPL+Pw+vqOc3RihmiAvmgc0y4SZIJ4UudraVEtXBAjNMXLj7ZBbbobSwx68dqvisQ+k0Rrti6OYYTndbkyx9lm0bGFxBgTzjeB8DD/m7P51Mmjq7155gFVQykCcpJ095REJfAx/YgssxZThFRMiNg+hxfWkbmIIk/Qro0GMpGjkqLVjI3CuYWj03Nmozhn+K/M131EcOSBNoQghuHlKXrCRExogDCJCv/RFpQOhilVttEaIqLiU1zq+zXSZYoucTYoVqpoYc5XH1exgGOxnYLWWMx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 07:39:19PM +0000, Kuniyuki Iwashima wrote:
> syzbot reported a weird use-after-free splat. [0]
> 
> In the report, an object in the kmalloc-64 cache was freed via
> rcu_free_sheaf() while it was still in use, even though the
> object should always be freed with kfree() (in xfrm_hash_free()),
> implying that the object was a victim of a double-free involving
> kfree_rcu() somewhere else.
> 
> When kvfree_call_rcu() frees an object via kfree_rcu_sheaf() and
> queues it into pcs->rcu_free, debug facilities are skipped, e.g.,
> kasan_slab_pre_free(), kasan_record_aux_stack(),
> debug_rcu_head_queue(), etc.
> 
> As a result, KASAN cannot detect the double-free at the call site.
> 
> If the object is still in the KASAN quarantine when the sheaf is
> flushed, KASAN can detect the double-free in rcu_free_sheaf(), but
> with no trace of the suspect.
> 
> Worse yet, once the object is evicted from the quarantine and
> reallocated before the sheaf is flushed, rcu_free_sheaf() silently
> poisons the live object, resulting in a false-positive use-after-free
> report on the new user.
> 
> If __kfree_rcu_sheaf() simply calls kasan_slab_pre_free(), we
> can detect the second kfree_rcu(), but only while the object is
> poisoned in the KASAN quarantine after the first free:
> 
>   kfree()     --(poisoned)--------------------> kfree_rcu()
>   kfree_rcu() -> rcu_free_sheaf() -(poisoned)-> kfree_rcu()
> 
> An object queued in pcs->rcu_free remains unpoisoned until the
> sheaf becomes full and rcu_free_sheaf() runs after the RCU
> grace period, so a subsequent kfree_rcu() or kfree() before
> rcu_free_sheaf() cannot be detected by shadow bytes alone:
> 
>   kfree_rcu() -(unpoisoned)-> kfree_rcu() -> rcu_free_sheaf() (too late!)
>   kfree_rcu() -(unpoisoned)-> kfree()     -> rcu_free_sheaf() (too late!)
> 
> These cases can be detected if we call debug_rcu_head_queue()
> before kfree_rcu_sheaf(), but ODEBUG splat only shows the second
> free.
> 
> To detect these cases with KASAN, we just need a 1-bit flag
> to indicate the state, which can reuse an unused bit in struct
> kasan_track.pid. (PID_MAX_LIMIT is 1<<22)
> 
> The bit is marked along with recording the stack trace when
> deferring slab frees in kfree_rcu_sheaf() and checked in
> check_slab_allocation() so that any double-free pattern above
> can be detected immediately.

Why do we not need the same thing when it bypasses kfree_rcu_sheaf()?

> Link: https://lore.kernel.org/all/6ac959ee.70ed5d86.2ac85.007d.GAE@google.com/ #[0]
> Fixes: ec66e0d59952 ("slab: add sheaf support for batching kfree_rcu() operations")
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> Tested-by: Alexander Potapenko <glider@google.com>
> Reviewed-by: Alexander Potapenko <glider@google.com>
> Reviewed-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
> ---
> v2:
>   * Add Fixes tag
>   * Add kdoc for @after_rcu_delay of kasan_slab_pre_free()
>   * Rename s/kasan_record_aux_stack_rcu/kasan_mark_rcu_free_pending/g
>   * Add comment for __kasan_record_aux_stack()
> ---
>  include/linux/kasan.h | 15 +++++++++++----
>  mm/kasan/common.c     | 13 ++++++++-----
>  mm/kasan/generic.c    | 17 ++++++++++++++++-
>  mm/kasan/kasan.h      | 34 +++++++++++++++++++++++++++++++++-
>  mm/slub.c             | 13 ++++++++++---
>  5 files changed, 78 insertions(+), 14 deletions(-)

-- 
Cheers,
Harry / Hyeonggon

