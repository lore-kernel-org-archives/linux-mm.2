Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1D42606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 19:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hEe2oV5n
Received: by kanga.kvack.org (Postfix)
	id DBC066B05B4; Thu, 29 Oct 2026 15:58:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D93966B05B5; Thu, 29 Oct 2026 15:58:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD0816B05B6; Thu, 29 Oct 2026 15:58:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A6D6E6B05B4
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 15:58:43 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4137D1A0545
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:58:43 +0000 (UTC)
X-FDA: 85376726526.22.1C5F296
Received: from mta1.migadu.com (out-190.mta1.migadu.com [95.215.58.190])
	by imf30.hostedemail.com (Postfix) with ESMTP id 324B980007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:58:40 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hEe2oV5n;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.190 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793303921;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pVeEdJtlXA25iorxAj4BG6N6zIAVHrWYsjlt6JZGNBA=;
	b=05L0Bptk8R3FxDeWq+7UbGCxTk4M224rkiRsjlLPXgnk27OI0rJQow23Fvs83N4crNrqKJ
	Z77iJauMGSxOB6/JBTP1+/sbtcAh6zzFwnCsYTZhIqO6ab6n1sbxLCVK8H25DrzCj54Sy0
	PjcGoqxQA3ULlHOxK8scOd1LjRKD+uU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hEe2oV5n;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.190 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793303921;
	b=lssAjKMX5Y2LifHu22CIasnScvY37+fyvRSFe98QLZ81Ybt8ei1bMaGUra3xhS7ycFztBo
	HC99Md8BQn6q43Ity0hyjGY0A1daGfqRgIGh5L8tubmv7OgqXEvBbOW3bn1eFSUbyTtDDU
	uNlqKid/AQificS0pXykcU6ha1YYWpo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Rv8ify/EDz+JQqoM8pTjIvCmOvRL5bSqPDPKODDV4kg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793303919; v=1; x=1793908719;
 b=hEe2oV5nqrcMnFsNW5746z+Cp1JNiXRXKgKx3cYeiTMjXe5ZYZz33Zj8ppVLV2wud5vTYhAV
 Z0BS+/26uakHvBxM64v4rrsYb55aRJAF/YsiaSbK9kYstKHyX+2LaaauYoVT45C0Jtg800/LAZ4
 Ao5XbzB3bw2hb8IgIjoCKnNI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 400292d4dbe12dae;
	Thu, 29 Oct 2026 19:58:39 +0000
X-Mizu-Trace-ID: 400292d4dbe12dae
X-Migadu-Flow: FLOW_OUT
Date: Thu, 29 Oct 2026 12:58:34 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Kuniyuki Iwashima <kuniyu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v3 1/4] memcg: Remove unnecessary READ_ONCE() under
 memcg_stock.lock.
Message-ID: <auOlVi4b4kOGy7qh@linux.dev>
References: <20261029194452.3189365-1-kuniyu@google.com>
 <20261029194452.3189365-2-kuniyu@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261029194452.3189365-2-kuniyu@google.com>
X-Rspamd-Queue-Id: 324B980007
X-Rspam-User: 
X-Stat-Signature: 5r8fosn3joa9jbm6dyxfcxywfwrygs5p
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793303920-634540
X-HE-Meta: U2FsdGVkX18g4uaNsY8n1bZA/jpOb8ud3HFMT0wg20XYxLR/7rBKBIADiGBNnyzi4aZV7Dt8UjcQzhQ5DF2KP3lzIpiQ/iZV+5jZU2rI6hZsOMiVbeoVtEaZ0FU2RJxZ4dNXQy848Xji3Rw+Aae4K5APTvnh0Z8elkRA6cjF588aX9PM29kIa5628cSiNHwG13ua2KX5b24b7G+2OqEaEAllugYHgSUr/bz8+sxp/KCnm56T37nQL4haDcjO202V0iAaoEf9BCYAKOmHC6kwq/pdTdhmU2gdDrlJO4ImoxPO4kgYay6t2xoCfKocUNVslWJp04cmpJ2YHHyLrU7E8zY/HDwpe3QgIrwVPdIfV8aRWc1ZIsBN7qmaWQTW9Yfd69IXTTiyCBce8kzv1TupRU9BM2llkwqcC6CASASSIaxn/bUw/fPMJs+OucZUXikRqhO43bCrOwGb3PiJ4+cOiz+K9obqm6vxZVyGKxxsKwdFnk4Jn9CDo/z9awOUY0cCqDF+Ab+Hk185JWWE/n095yZ7xFn9xMJzNUknuchyqqPX6VJp0owcjbTaUmFEbOa9NfKw6jH7dKxdWqnpFJhosIB/zFuT0dLhs5d26afgFo3mWEk5t3aTXHqYf1RaZrSqm2KItn+7Sy43EQF55fjxx8Yh73Lz0KyosICZ9x1iLhi4pwY0rz5jBkzvREZFkxOrqP3nmioxkOZijUYgPO2VblrbzU3Mofe4ywGRh5dyh4UEfqi1dTlb6SSWnirwh1cPvXzdnix5MvQiTZUOcxwLKRbEUwreVpcNnk28zoRqe3i88GxHKOlR2t3tD0moGp9a0I9iDyw2/QKdAzmoX2I4KBLDtVhJLP5l+kxX1WAT3uzxoFSmyCFJTTxIfKoxWWWIQeijNHMpdPtCeNEL1Xbr8SBtGFV5Q+EtNieIBLAeBJ6e+H6tYaI7Kts/wrnZ4cAD5dB4Rw8t2xlDOLsdFKl
 Rde5bMFP
 3SyMXfgkZpr3No+Ei1Vzk/ybncaOixs8XAlSrjVUhmy9HDMpN8nXQsjtdrdCtF8dUlk9PT12+pgbFABdcXnDlfPPpsDeTcu6+Gnt5HBxWm7RP9chDdYC7Eq12mVJfM3SW66uYiqIiB0/nU4qWmPKOuxaV9lPMroj7CgMAr70ztCsDKrXiAt6Mjr/kidSKvlvY68ibw0mXpoKF7napkVXCwwPVio9rv9JLuel0vcOrOlsDV65SK/k4cVZNf5gJxlhFswkYJWBJdANZm7FzPJNNekv67nOC8MGoK6sFBCGDh3IobZzpktaItXXnWsCc90oNxS+iNMAK3vTMa4XjjAECaDyoL6yk4ImGl71Hokdh4ERpVQfjGErybCmYCg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 07:44:12PM +0000, Kuniyuki Iwashima wrote:
> this_cpu_ptr(&memcg_stock)->{cached[],nr_pages[]} are always
> modified under local_lock(&memcg_stock.lock).
> 
> Unlike is_memcg_drain_needed() under RCU, consume_stock(),
> drain_stock(), and refill_stock() do not need READ_ONCE().
> 
> Especially, in refill_stock(), READ_ONCE() is used twice for
> stock->cached[i], which forces the compiler to emit two volatile
> loads from stock->cached[i].
> 
> Let's remove the unnecessary READ_ONCE() and eliminate the
> redundant loads in refill_stock():
> 
> Before:
> 
>   cached = READ_ONCE(stock->cached[i]);
>    4c 8b 80 88 d7 bd 84 	movq	-0x7b422878(%rax), %r8
>   if (memcg == READ_ONCE(stock->cached[i])) {
>    48 3b 98 88 d7 bd 84 	cmpq	-0x7b422878(%rax), %rbx
>    0f 84 86 01 00 00    	je	0xffffffff817d01e0 <refill_stock+0x210>
> 
> After:
> 
>   cached = stock->cached[i];
>    4c 8b 88 88 d7 bd 84 	movq	-0x7b422878(%rax), %r9
>   if (memcg == stock->cached[i]) {
>    4c 39 cb             	cmpq	%r9, %rbx
>    0f 84 7a 01 00 00    	je	0xffffffff817d01d0 <refill_stock+0x200>
> 
> Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

