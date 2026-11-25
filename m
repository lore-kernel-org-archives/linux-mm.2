Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16975606A68D
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 09:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ieRYNdSd
Received: by kanga.kvack.org (Postfix)
	id 39A606B0954; Wed, 25 Nov 2026 04:19:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 348F36B0956; Wed, 25 Nov 2026 04:19:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232486B0957; Wed, 25 Nov 2026 04:19:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E546E6B0954
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:19:15 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7937340E55
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:19:15 +0000 (UTC)
X-FDA: 85473092670.17.BC3AFF4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9DADDA000A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:19:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ieRYNdSd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795598353;
	b=uruy9vrWfGa5QgCIgjJfY8xo4luGWavVcd0TdygoLmiIHBOFcWFrCP553IOE0cM9sUShgm
	Szq1KvVbb52/Uc4b1QPlb3DU/GCmymuD2U4qsVlGnRjButoy5x61qJGNW2P65wVrlXsSO0
	vDuqo6bKp9nOkAggMdHVz+c3Sjv8Nmk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795598353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fAo+SUdWw8IPNJsn0IwIsl5VrDmLwF+WpUivd2tJar4=;
	b=0DP+WySVlAw4/A1FEK1wOb2YlXiRWdw2R+wsPDEE2zKPBGn0sx1yqPB0/1SuqLr+1sjzks
	kN13swfrfM/CLbBaKXUx2SDhgC9XQnOwX/m9lIo3TtB4bx1PiG1j6jLkBgPE1zAAqQSJd/
	Pqm2DL8JrAALW9IumNUP3sov/T1zfnA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ieRYNdSd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 795CD43B74;
	Wed, 25 Nov 2026 09:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57031F000D8;
	Wed, 25 Nov 2026 09:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795598352;
	bh=fAo+SUdWw8IPNJsn0IwIsl5VrDmLwF+WpUivd2tJar4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ieRYNdSd01MN6n81no8M7mgH5h/kK3WEx1KRbfDdae6DKqHvU9SprXC7utnqZJU/1
	 CsRVgCmoPEAGue+cPNYXtJZwG3RFa872GCFNk5z/2QbAQtxcvJ4VYbEIySxPSp+ys8
	 ul16TYZGMBJB68fRtdfjCl3YDnqutlL5JMjBAwSdDeMTRRSwmuviq99GuevyYmH9fi
	 gR8AJxmXh9mA2YvZJJoTd7t8wWbVDmY5au5yaYQCmXuLzlZTYyRv4mo8iuvFW4dWYy
	 mAZxxKYjNmaqJDCuUp4sqZJg98vWiTb7vm7hH+F8QwYMVM5qI/VJdXEmN1hZklv00W
	 4yUngMTr0gtyA==
Message-ID: <7b89db31-3c69-4845-a46f-6bf42b3ab0a1@kernel.org>
Date: Wed, 25 Nov 2026 10:19:02 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/rmap: avoid reusing batched TLB flush generations
To: "Huang, Ying" <ying.huang@linux.alibaba.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Ying Huang <huang.ying.caritas@gmail.com>, linux-mm@kvack.org,
 linux-rt-devel@lists.linux.dev, linux-riscv@lists.infradead.org,
 stable@vger.kernel.org, Kirk Swidowski <swidowski@google.com>
References: <20261124-rmap-v1-1-e3dc48a4b527@kernel.org>
 <87a4mxthsn.fsf@DESKTOP-5N7EMDA>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <87a4mxthsn.fsf@DESKTOP-5N7EMDA>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: wjhy8np1z7945w34ms4tdh9huthbjiru
X-Rspamd-Queue-Id: 9DADDA000A
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795598353-294448
X-HE-Meta: U2FsdGVkX1+u7DNdoOQMxZaYyZqE0SN4n3HqESxre7cFeIs7yc3jaBfRbR1twHJqdM8thlzEi49mWrJ4pewrA61nDwFcNKAEg/TTyJPCOs+kiWSBlBc5MdiHtzjAYUDAvf3R5cSND86dRCdTFy+Q12tpEA8NiCBueA/IMK9qyAbSkbKTqq+nJ7I/gUMT61nJQNAOaSpBNRO2rPebZh6xt7uyXhjDOX9EbJYxc0mwQQJxpU5kPe589Zh+v15l4m/qtvoqadd4mXa7bHdTdpsjxj/ZuQ0BNr0Y/AzxnWwNabV5DaXcE+MCxWbF3i4Umd04s+kV4zBTHg01OMbdp3dS2K8NpEUsHxzBlzj2J2X7TAkoG1aoGbkuiUjgcJKENrlgrQzWiuwsEbQr9Yup9vNoPV97LBhC34ubl7phSLC3Yp/hURcfDjgER6eXgSVVbXSFdlP2wrP8v9mwxQGg/RQkUPTTEIim8wahtzjuhMNkY+4int5e+opkIA4tDmtyqFKN+WHYARKJwmMVtlUJcd4rJ/ExQ/a58BkKDgIBsIzenRn8j9o8kexj7z9iIo0G7mNRbCsz898gtu4GUOgMSxqUEFUCfd3I9nKhiFOghhMlwjx1xKvPawKFJs0qk9hJ802vdZRYhwGyjVR9DR/q2MkAyXytvWFlgbMbw/aH3TnNLgNKyMsR0JV9AgkmDH4Y8Y9Ar7hUj5+BW1f+i4Lkz2pLIK5a4+mfmdLUUts2plYnselO+S0ljc5zWFuiKWW34QZj3C1IVBcViLGMkxBOtbqUoQLcEOEEsIYr8xs5bp72w+edUPVEInluyQhqZIp7eJK47NjGKQlOQUg+vX0fgcp0egyhXJlu3JZVUbRmgjig6Ncmzn1qfuslzGycdC7qJddTDFAdWzG2DKawpeL0iitjlSNRH6fdMGXfM9dCNtpNBAd0SdYuTklpYQ4QaSpcdvsVw9+AYY6mfMIpAdFe3HI
 y8wsa9de
 VMdfOe6ZrBLItGHmeq4btBYsJMcGjqB4CTF4obtEIPrZGqIYwFT4gnFr/yVVuLuAOeGpKKzvMQ8DhGL5IDMH3FYvwB2zDksS65RF2v069+3S0/CzBcbV3z68BifoMWYGmScKWCl52P9J4liJmZlCkL1JKiIRVOjzTlZr9rEHCKq3IXMxR6doHP2sV2LRv5HZeueaceZoZK0EMGEvk6ObIvnBc/v0SLSamLDjO7ERap5szxwbw2h066B3HUEEfhN7jiLf2DhUgf9eLTgFyWbXTye69fy96RS0z2tzu9z06iIl4fP93FTCKwfhg2XCURzol6I7uX3bGpy74s9ORTI2UiuFlGfyAPW6N2I6Cgg+cxmTwuBdLBv4Ra8B2mpfMwrIjlsU5WpWZg3c2cqg2+Eqb0eZM89MvL/yuryv0xnJ+kKwClKK6eVv14O/mGez9mFePqdqojU1Yi/eZOM+aS4eUL2ZpZuRQ5s05itB3NG9J5HbWkBZ68dnEe2FNWu7VIDyek1j7vl28aFXOiZQS5B+ihdWf4GzjRAHUdU8bzSbx8syQ9xUKf5xOUAdQzcW/d5srizkK2vRCg1SUEQDjIWjSFgIkarPj5ucYPs1Ydh6WOAeM5gJiVvAjAzEjwnEpN0KYlyC9wTK7t5NraOJaLBklBa+q/B8WSjDuw/Z3+X7vKFA8PYwdH22FVO4AMQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 09:51, Huang, Ying wrote:
> Hi, David,
> 
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> 
>> mm->tlb_flush_batched packs a 15-bit pending and a 15-bit flushed
>> counter into one atomic_t, and resets both once pending gets large.
>> flush_tlb_batched_pending() updates flushed with a cmpxchg() against the
>> value it read before flushing.
>>
>> If the counters get reset and reach that same value again while
>> flush_tlb_mm() is running, the cmpxchg() succeeds and unmaps that
>> happened in the meantime are considered flushed. A later zap can then
>> skip the flush and leave stale writable TLB entries behind.
>>
>> Use two separate counters, never reset pending, and let the flusher
>> simply store the pending value it read before flushing. To keep pending
>> from wrapping around to flushed, pull flushed to pending - 1 once
>> pending is more than INT_MAX ahead.
>>
>> Preventing the wrapping is primarily required because
>> try_to_unmap_flush() as called from migration and reclaim code does
>> *not* go through flush_tlb_batched_pending(), as it does not iterate
>> MMs. So if nothing in the MM triggers flush_tlb_batched_pending(), there
>> would be a problem.
>>
>> As the separate counters are no longer read atomically together, we must
>> read "flushed" before "pending" (acquire/release), so a reader can never
>> pair a just moved-forward "flushed" value with an older "pending" value.
>>
>> We'll leave the barrier() between clearing the PTE and incrementing
>> "pending" alone for now: it should be a smp_mb__before_atomic(), but
>> existing arch code (x86: inc_mm_tlb_gen(), arm64: dsb(ishst) before the
>> TLBI, riscv: fully-ordered xchg() in ptep_get_and_clear()) imply a
>> barrier. This should be cleaned up or documented separately.
>>
>> Note: if a flusher stalls between reading "pending" and storing it,
>> while "pending" advances by an exact multiple of 2^32, the counters
>> could compare equal and we could miss a flush. The same applies to a
>> writer that stalls while moving "flushed" forward.
>>
>> That is irrelevant in practice: both hold the PTL, so without PREEMPT_RT
>> they cannot get preempted, and wrapping within the ~20s soft lockup and
>> RCU stall timeouts would require more than 200 million batched unmaps
>> per second on a single mm, which is impossible in practice. Even with
>> PREEMPT_RT or long vCPU preemption, we would need minutes of unmap and
>> refault churn while the stalled task stays off the CPU, which is highly
>> unlikely and not a realistic attack vector.
>>
>> This effectively adds 4 bytes to mm_struct. However, on common 64-bit
>> configs it fits into the existing padding, leaving the size unchanged.
>>
>> Fixes: 5ee2fa2f0636 ("mm/rmap: fix potential batched TLB flush race")
>> Cc: stable@vger.kernel.org
>> Reported-by: Kirk Swidowski <swidowski@google.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> [ david: use atomic_t instead of atomic64_t, adjust description ]
>> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> 
> Except the fork issue pointed out by Harry, the patch looks good to me.
> Thanks for fixing this problem.  Feel free to add my
> 
> Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>

Thanks!

-- 
Cheers,

David

