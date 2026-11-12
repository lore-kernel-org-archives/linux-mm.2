Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C3BE60A2609
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 09:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Cv3iFa2W
Received: by kanga.kvack.org (Postfix)
	id B06C86B05BE; Thu, 12 Nov 2026 04:01:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A913E6B05BF; Thu, 12 Nov 2026 04:01:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97F8F6B05C0; Thu, 12 Nov 2026 04:01:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 768926B05BE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 04:01:24 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0DDE0A7C2C
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:01:24 +0000 (UTC)
X-FDA: 85425873288.01.F66E010
Received: from mta1.migadu.com (out-200.mta1.migadu.com [95.215.58.200])
	by imf01.hostedemail.com (Postfix) with ESMTP id E97A440007
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:01:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cv3iFa2W;
	spf=pass (imf01.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.200 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794474082;
	b=37pIB6/J4bR9IoNweM9INZmDQ87MitCn10GXoontfJtBFWvxUq9bsGQctRrlvApxAP6NOq
	KCj49F//US7XX2lZsZ4tQPqEk0+YugOKIa6ns5QrsOj2ufX0KaxcopFxST/b1KqJjlCUEw
	0ANwXTxC6evotfvZt16cdz0iGCU/uJE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Cv3iFa2W;
	spf=pass (imf01.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.200 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794474082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XueNigRXrNVQbOmN4VACMi1GudjntNvPC9ZLfnYMjrU=;
	b=p0jD30f74r/1LKhXSFYeidfxfNuBI9MrAz0hNWsbh9Nfab8AbFW1c7qio36EHID22zZu3S
	A3InmzCtXRMAWrXKxdp2LMU9PgzPTbBm7ql9dGxZyBCUhaRAoybi7iveH6e9HiASotkdjz
	lN65sfWVXJKKgrF3oZrGs5FbSYVn0H8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ou+k9MfEfVyFsna30Jg2u9TW8pwId0PWBe5K6vBd12Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794474079; v=1; x=1795078879;
 b=Cv3iFa2WgJToElLQhNcVRYpZIh4t/yePr6xD0CcQrvFX/0ZuaCfEvj5LeiV1b3cudpOWWUAT
 yU2Adui+XIQNZxEQJnZr7nJ3TzN9KzDsI8GsG5m2Wj/7jFZVjiHmIr/bDhXLUqiben/hamG4J6E
 c5PU/T3RJ8lLCwK/RXzoqHco=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f320f4b38b6a1e59;
	Thu, 12 Nov 2026 09:01:19 +0000
X-Mizu-Trace-ID: f320f4b38b6a1e59
X-Migadu-Flow: FLOW_OUT
Message-ID: <7718d4d0-58bf-4281-8256-fa726f753159@linux.dev>
Date: Thu, 12 Nov 2026 17:01:04 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Betterbird (macOS/Intel)
Subject: Re: [PATCH] mm/mglru: check need_resched() in fill/drain_evictable()
To: Michal Hocko <mhocko@suse.com>, Kairui Song <ryncsn@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
References: <20261112075827.255602-1-hui.zhu@linux.dev>
 <avVx_1BEP7fIzGDK@KASONG-MC4> <avV0IbvSx4iuv0tF@tiehlicka>
Content-Language: en-US
From: Hui Zhu <hui.zhu@linux.dev>
In-Reply-To: <avV0IbvSx4iuv0tF@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nuci7qmsru5hndbz4ioct8jw7p9f8sit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E97A440007
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794474081-648277
X-HE-Meta: U2FsdGVkX1/7Pf/FywqmXbrYBShCxyACGj5ZDRJlfHKJRg5gKOiY76RvaYw04djMBzsN73VzAQgh8XhKxVKb/Ewz0nKNGVliLPBXRzKlD5wxeluOCHabszolr2Kewr/biBVke0zik5ZqastJc59D8CZnOtG5hoac5Pd8iAgWBBeJQ+TUYTq6I1Xbf8k0vadUy0B1k26TR0++UBpwx9jtGqiC7Kwwt60KJY6Kbe7dTU3jNJCrYKh68xuoamC/6y9mRQE7erwrETyFuxcgxj2kmsLCY8KBh8/ix6epWDn/nbSLRCqys+4YveAt7rcBaQ6jeGZ693Q1iar7vkGjjZ0Ue91bIK4FLmOyLRoPe+6jnj/pgxGVa6nGdrwy9w+m1ME1i1fBCcTDNv0fc1T1T76yfLiauTzRcqnG0c7OIEzbYc+XSyTeT233/CDw5PLCQPRx3EWrHGwHVKyTZj0AMKTZaGl/bFExHOc7QNljXeu6OTAqB3FO+kNMFeIeSrTnuptIyYTi3OO7T34ct65ddKMdyxOkE4uXLFXbqch8qiXssO4Cb/nASVpjJn9sl8gFjCWw3XAkjRTXQknWVKQ47RyTsNb9hhROpVnroxfn705/ZcCKOJBv4kY0XQwmdqBJoob41PmLceCZyJXwWvvqwKf6xZEGi1sBQ/U+0GWM+aeexLsOZTCvwA6RRG4JzQo3d2AluHD9GUgiIOAu9FyHvXhjyJ21tMMlwHTdAyhrY1YFSjaRDKXS4kwDCN3jnP9MAEo0yZ+ID/j5Bh/Sk3+9oyNss9RstZaQUMoMrLrgzU7c0Or7Ik2wRgG1w33GRACV+CdnfRz6KKv+MwLvgOtazm/wUzQujjis0sm8jlZDGH826MgVNg8Wohm79Zoo6lzhwgNr/Q5Hs1s6cCKneUACYHlI1/TWyxo8KJyUmMowe2dxwg49eVDOY6teAAg6dUP/cRNP498KeYekQk4Y/bhqGM3
 GW7Es8pL
 bTZutfzCBN06zLYPxpuoyGqDqs2BDOMLns24nddP1Rqwc7NTG2JiWrPaTGIoZxoik0tYmP/Z2t+bXqRA7LGzKFoBdjOOc3JNSYV0gh4zHv/mlkRz6MuIB0DB5nqbdClL4xuEn7rKbJz1A9KnV3Porjp3nFJF1BEil+1vazg7fn/ErP4l89C8H4w2oc2mtV7N3lLhMJoCfY/pbWbjCntJmsI///pMf3I4grPn9M7qZfBxZbTGny3WqmAlE1Qimm8lpJo2BgKGNnF06TeHG08QyeV2dao67U5Nj9vQ840W9CSQYHed8tF3vOwfbMClOit9+OgQMrnTqoCwaTz8vrU5ltrY42/okb017/Y6p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Michal and Kairui,

2026/11/12 16:09, Michal Hocko:
> On Thu 12-11-26 16:03:54, Kairui Song wrote:
>> On Thu, Nov 12, 2026 at 03:58:27PM +0800, Hui Zhu wrote:
>>> From: Hui Zhu <zhuhui@kylinos.cn>
>>>
>>> lru_gen_change_state() migrates folios in batches of up to
>>> MAX_LRU_BATCH (4096) folios under lruvec_lock_irq().  A full batch
>>> keeps local interrupts off for up to about a millisecond, and CPUs
>>> contending for the same lru_lock spin with interrupts disabled for
>>> that long.
>>>
>>> The caller already reschedules between batches, but a batch itself
>>> only ends after 4096 folios.  Stop it early when a resched is
>>> pending; the caller restarts the migration where it left off.  A
>>> remote resched_curr() sets TIF_NEED_RESCHED directly in the target's
>>> thread_info, so the flag can still be set with interrupts off.
>>>
>>> This follows walk_pud_range(), which already pairs need_resched()
>>> with a MAX_LRU_BATCH cap, and commit 6e9be217a3ce ("mm/mglru: use a
>>> smaller batch for reclaim").
>>>
>>> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
>>> ---
>>>   mm/vmscan.c | 6 ++++--
>>>   1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 6a1af9b92349..47f2cb25eb46 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -5533,7 +5533,8 @@ static bool fill_evictable(struct lruvec *lruvec)
>>>   			success = lru_gen_add_folio(lruvec, folio, !active);
>>>   			VM_WARN_ON_ONCE(!success);
>>>   
>>> -			if (!--remaining)
>>> +			/* stop early to shorten the irq-off section */
>>> +			if (!--remaining || need_resched())
>> Hi Hui,
>>
>> I've been thinking about a different design, what if we just
>> delete the `--remaining` check completely, and check
>> spin_is_contended on the lruvec and need_resched()?
>>
>> In the optimal case we don't need to keep lock/unlock the lruvec
>> at all so this is faster. And it still avoids lock contention or
>> blocked schedule, and it might be even more responsive as we are
>> release the lock earlier on contention.
I like the spin_is_contended() idea and will add it.  This file
already uses it (lru_gen_look_around() bails out if the PTL is
contended), and security/keys/gc.c uses exactly this combination in a
long list walk under a spinlock.
> Wouldn't this result in too much lock bouncing in the end? Would it make
> sense to reduce the batch instead?
>
This worry is fair.  Under sustained contention each yield costs an
unlock, a requeue and a restart (microseconds), while one folio move
costs a few hundred nanoseconds, so the migration could slow down by
tens of times, with cgroup_lock and cpus_read_lock held for all of it.
Requiring a minimum of work per hold bounds this: only honor
spin_is_contended() after MIN_LRU_BATCH folios in the current hold.
Each hold then moves at least ~64 folios (~15us), and a waiter still
waits only ~15us instead of the ~1ms of a full MAX_LRU_BATCH batch.

I'd still keep the batch cap itself as a backstop, though.  Both
triggers are event driven: with interrupts off the local tick cannot
set TIF_NEED_RESCHED, so it takes a remote wakeup targeting this CPU,
and spin_is_contended() takes somebody grabbing this lru_lock.  On a
quiet system neither may ever fire, and one batch becomes the whole
lruvec: 100GB of 4K folios is ~25M of them, i.e. seconds of irq-off
inside a single rcu_read_lock() section, enough for an RCU stall. And
toggling MGLRU on a quiet machine is a common case.

Reducing the batch alone would also work and is simpler, but it pays
the unlock/relock round trip even when nobody is waiting, and on a
loaded machine the unconditional cond_resched() every small batch
stretches the whole switch more than yielding only when somebody
actually wants the lock or the CPU.

So how about all three combined, like jbd2_log_do_checkpoint() does
(batch cap || need_resched() || spin_needbreak()):

     if (!--remaining || need_resched() ||
         (moved >= MIN_LRU_BATCH && spin_is_contended(&lruvec->lru_lock)))
         return false;

Should I send a v2 with this?

Best,
Hui


