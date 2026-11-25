Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F565606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jVA570wa
Received: by kanga.kvack.org (Postfix)
	id 56F006B0B23; Wed, 25 Nov 2026 17:42:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51F916B0B25; Wed, 25 Nov 2026 17:42:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 435996B0B26; Wed, 25 Nov 2026 17:42:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C60E6B0B23
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:42:49 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A215CA0173
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:42:48 +0000 (UTC)
X-FDA: 85475117616.29.DA80E73
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id C440740008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:42:46 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jVA570wa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795646566;
	b=OKYwLczFg09DXtekkvkhDe3oYUVMXqEjMMPfZEvh8IJwvurU8qFnxjd5aZNY32I6OcG4Yr
	C6BJFI0AvkIGS1EKdStQ6awbX/eyHpMXBsq7TmxF3ImaTErpaRbwiZielXGdzE5+PztwNN
	PankZKxt+tkVdv2Myanxe60jX36hHm8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795646566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wIfAdkxQcsRohaTqE06fnblD43O9O+Djz5eJ6myvDxo=;
	b=X6gzL1LPtdKL/ppDUXlhmh9OI4Z9pCeBYEikqN6w2aUh7kc0SadOeGH1KookHFmAnYZogb
	NKZFjPYf0BGNLQAGfU4LotSzIDbXiTf51DhoPjVcYG0h0z3zaxQIiBQC7nAh1e7WyG7exQ
	O0ze7xmlAuruUvYq/GK2eawAiltIKDY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jVA570wa;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of azpijr@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=azpijr@gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-48e46e449e8so4112076f8f.3
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795646565; x=1796251365; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wIfAdkxQcsRohaTqE06fnblD43O9O+Djz5eJ6myvDxo=;
        b=jVA570wa6PhFDHAGlWe5W5bgqGRKNJJU9RMY9lRB4kMeXqjAqGhVPOhph4/vX1fTvZ
         LIrI8O4Fa7iBU//2SCJwPycGCcl2Bq4TEZgrZ4ZwvW1Aoud7Az5LxP5M8LFMc7e+xP0k
         bJ4fCKI1QEPjZ9+dEyWYXNMvZIZKPFXhoBUGJtnTGlmOrbgIUkHoZyvykFGQmr/LotwM
         DeS4MzYIOyTycbbm7Bu0A2OHWQcF5Gp69qOHoIilaKvPHGuvd75LVVhG5fOXXXWdS1Fn
         AlIy9pwCIsylV2eGaxxtdG2PVsf25OrQjtohZuI5OPvJ2eqoOZEOSeL/r2+YgsijHhJl
         87JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795646565; x=1796251365;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wIfAdkxQcsRohaTqE06fnblD43O9O+Djz5eJ6myvDxo=;
        b=bAY3mKuvhrdOzIBytlfeFcF5BSeuvN2sDUNMCkYbVQMIC/yHfMcn+ijPmItu2M+2Fi
         KqysyXLPQ5NkZTdA9YKNnJSYrQjqcEWDnbcQNlLoke2B36uHkYCWcY6qfPlIodUjU7wu
         x0fTXMqIixoGzFe3WNpMsrFDlDtCRtPSBajxdCU/jQboJ+cjZ86RaAhilDEscSjZ7g0Z
         +3hcCxtwyxb2oIziFCmUzvEX+xdF5OiPhv28Nx52JlHl2tqBaYll4QFqn9eiNmzAHVkb
         8Gv/1TSubCp9K7RN9OtdbHN8ArNGfYuHDpGBZ5EdOvbLFnNF3cSEdMHOw4WyJqFyvDiA
         JKrQ==
X-Gm-Message-State: APuU4Z8qqVs8X8mV/clggtYbjWXDonUKma4q9rqb1H5olN9L/EKolYLh
	4vRngHJtEa+HjeNwLoXdM3Cj3SKTA0JavUoA8G+utx+ESghbtNKDptSy
X-Gm-Gg: AZFdTZfMmJQaUEkAql9kohpdafen74RhYJ/vUhx+BBbeO3J8IgnCQ/vOLo8E9g3YuSR
	Ubzv7KUVxoqhUsSksLotz5oYmc03txf6U5j5dbjkImBenbQcWzQiOoeuaWqV5qllTv8Qj7nxYdh
	V58XozS7EUNucCLlqH5XF/yIkmISkOapRPyfLucK9JteHYGJVXQa7kSNXMkdali6wK8jj7yvi84
	/P9EZHzlSb+FfSso8j2wxtDeD8GmxZSHBaKI0m9hGyuwTOdSoGf49cKfZxs5XsuIbx0ISrzMHZ7
	zrqWtvfvWrP3TPz/dMBdMvHloKqlAAdYORqdZJyndorqtln2uFxPu0/kfUhzTinwrAsXYTCumtv
	CM5RYKzclvaWJQ3BUuK68Uof3aF34DBxxEEUN8ybMvh9WzOR8fkQCL9pQvKaVBHxK6koAS0uc0q
	e+PdBGCBVztj/QbN9hIVKSHVhJiFpar65RSic/raMEuO5XwN3hcDOese7NmGCIOAswsF90R6T+0
	k64QMK0vuiNfWQO2Y9QweyeLQzYvhi9VegQZtzzHetjfKBTaxUhSlVin+6WT8opyoArk+d69Ygy
	FyE7OWiSSZnuhxnAsKqF9Ss+IA==
X-Received: by 2002:a05:600c:5493:b0:4a2:8c5:5e5 with SMTP id 5b1f17b1804b1-4bb8881c734mr412295055e9.7.1795646565114;
        Wed, 25 Nov 2026 14:42:45 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8538b2c5sm544402355e9.5.2026.11.25.14.42.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 14:42:44 -0800 (PST)
Message-ID: <b7c6eafc-43ef-4434-8423-fc8733911571@gmail.com>
Date: Wed, 25 Nov 2026 23:42:43 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/rmap: avoid reusing batched TLB flush generations
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Ying Huang <huang.ying.caritas@gmail.com>
Cc: linux-mm@kvack.org, linux-rt-devel@lists.linux.dev,
 linux-riscv@lists.infradead.org, stable@vger.kernel.org,
 Kirk Swidowski <swidowski@google.com>,
 Huang Ying <ying.huang@linux.alibaba.com>
References: <20261125-rmap-v2-1-0ba817662eac@kernel.org>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <20261125-rmap-v2-1-0ba817662eac@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C440740008
X-Stat-Signature: uxrsg57h4r7k4q6wtbiaxcuae56nkx14
X-Spam-Status: No, score=-9.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795646566-171105
X-HE-Meta: U2FsdGVkX19v9Rjh1Kx50T/UPae8irCrEp7g9pH88drNXmeuyrJHgX/0H5TdCnjWm85y7pZH/JSxA1ROUMePSIiqxMeg2kmVDACiq7dteOgOG+N5+eIEivj2+7KgOONrPMQ5nnMXfTCDkANf95vA9yEkgxRn9lw7udgMPWgIShMQPOa9zVa8effi2n5ut41/Z3x584lOAv1+KgrcFLJ44B4nEJZX1wI4ZwBYSXS1RwTA02ORiU2rk9LEvdUsNLrGgidgZqUBwGaGB/3v6Q2lN9QVmeaxxYztOh7rZedNwTzsP+OPR+hnDbjMqgSiqpzqDteO8Oz5sWK+EIhrp9mQaLv2uDd4q/MLc1uJfpeYZPt2AJgQ1MMsJYtzjJFPrVF444auRRH+BB6bDKUTDfqqbzfDdbiCV0MxvXt1NtCd3QYct7iZlhoovNk66p0gPrxXfHWnMWJfS9UgVr2pxntxyg6dzOGj3I6HrZJ3VnXRsz9qDQ9xjC2tGa32nOyW07CSK/peQMMUJm8L3yzgh0AFyCKos/N57Z7yQpUkIQJTFuOiFOb2ATVuoSwsMz/itcm4Q+HOtQwz0Jl/mpuBf4AuoEQeQTJCnrEXU4iQ0Iz6GTHm9DRXg55wTfzOHW5/MLvOAVXjRZYRjoQponYoSMCKGCZk1XY7Jmg8nj36AmBYh3xBBurcClCJo/+fKpb3P7/dHHGOjlALPUqEYkNikbqVUzy+VVmE1rlYkk/dg1dVSG82l3aFEm6pgobBhStakK8+qgAxD4HZEfOEMPa8omNjfPKNRWkCzgtEkhsZB3V9wdNXwwdGS70gIKH1DPIduj3us1CEqZJXwrm1UYJjf2TFTGmAl43gR3Iuk+hG+zxFv1eTJ4JI6+E9EByBxWX0z/Jg0aQibeu0CJMltoDFJxkoJkrksAuI/X3WoehAWhNVLy5r8rauKVuphAdO6n+DaNTfGB40QXx36nSTL+29pCT
 8lCLgyC3
 KkFENo4hEmWswCGihgAhsfR26efPJjP40Gj/E+wxwUZ9AC1SuRUgvpiIAgpRTdR2MXQ/eAnWOpHAhU6OY8y1xjFDN6+5/4T57nzL8Ds8ug/IzfFzVtplPgBFxs9uRwyNKZ9hW7Uhv3AjGGE2C0BjQRaqEQDz9wwltF8+knpLlCFSpXGq8gGyUaOpzbvR3GmsJzKUu4NktWCRKM6dNUxy4yG88PPeJmpmYpLNlhL+eKKtO7Tb0670Cbp8/DnpRDkv5B7WLlSxbpTrZ4WYeQ4CwBTIeoSEBORzlDvVh5KQCdNascNIfqRK8vfni7XqpOTjnuQyQIg69FOeoOkFZkK0K+NDh8Cpz1Pn1sRcwSV9s2+bqI41JjMmyJEhOdpJzOA08Q9zfMMbVVzQSfSbjL+lGq1ZgfAnr46tO0L7PJQacdxUaUP6G8pOkrrzYWZLaNe8ppkIgTRhbwxC1EBPjNusxr7+4fnia/oLRd4vdts0so6+a/B/6OSfFLBL/iWVH5S7VPeZSsPZcqdcuFrSOE8reKVrcqLYQ2TT0l3t/U9zCnTKX7tztsGSYzVrplemDtDnmyVoPX0NJru0+AGo8xUdLtN19Y3jCWdKXo5J5BRfDOZsgjkLj+k+1IR5hUHrsoxcOC1cPOQPVK8ObQzxKGhXpmv9Cd0kAJOqgI1WWIpwsRgLrgGJJS+bmyrWHOrEUbWw6b7Xl/63xQwI5qlIps15DPgsT+jwkQzzfIDzQbpsYLqAyuvkNnaT5KEs5luq5/YLMl9ZbDT+GI3wdxsD1craxhEcAagoPObE81UqzSsaSkHE4YKsHlPa+xAp91ntMMOBJ/qHNooKU0N9ddEOi7C+M0RyKddRD8Ad6EcCcPz7uR2kps8nEeSi4lXnftMxa4q/ngEpq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/25/26 10:34 AM, David Hildenbrand (Arm) wrote:
> mm->tlb_flush_batched packs a 15-bit pending and a 15-bit flushed
> counter into one atomic_t, and resets both once pending gets large.
> flush_tlb_batched_pending() updates flushed with a cmpxchg() against the
> value it read before flushing.
> 
> If the counters get reset and reach that same value again while
> flush_tlb_mm() is running, the cmpxchg() succeeds and unmaps that
> happened in the meantime are considered flushed. A later zap can then
> skip the flush and leave stale writable TLB entries behind.
> 
> Use two separate counters, never reset pending, and let the flusher
> simply store the pending value it read before flushing. To keep pending
> from wrapping around to flushed, pull flushed to pending - 1 once
> pending is more than INT_MAX ahead.
> 
> Preventing the wrapping is primarily required because
> try_to_unmap_flush() as called from migration and reclaim code does
> *not* go through flush_tlb_batched_pending(), as it does not iterate
> MMs. So if nothing in the MM triggers flush_tlb_batched_pending(), there
> would be a problem.
> 
> As the separate counters are no longer read atomically together, we must
> read "flushed" before "pending" (acquire/release), so a reader can never
> pair a just moved-forward "flushed" value with an older "pending" value.
> 
> We'll leave the barrier() between clearing the PTE and incrementing
> "pending" alone for now: it should be a smp_mb__before_atomic(), but
> existing arch code (x86: inc_mm_tlb_gen(), arm64: dsb(ishst) before the
> TLBI, riscv: fully-ordered xchg() in ptep_get_and_clear()) implies a
> barrier. This should be cleaned up or documented separately.
> 
> As dup_mm() copies the counters using memcpy() while they can get
> updated concurrently, a newly forked child could end up with "flushed"
> being "pending + 1" and we could skip a later flush in the child. In
> theory, this might have been possible before (load tearing), but two
> separate counters make that easier to trigger. So let's just reset them to
> 0 during fork(). Put it into the existing init_tlb_flush_pending() and
> rename the function to make the name better match the wider scope.
> 
> Note: if a flusher stalls between reading "pending" and storing it,
> while "pending" advances by an exact multiple of 2^32, the counters
> could compare equal and we could miss a flush. The same applies to a
> writer that stalls while moving "flushed" forward.
> 
> That is irrelevant in practice: both hold the PTL, so without PREEMPT_RT
> they cannot get preempted, and wrapping within the ~20s soft lockup and
> RCU stall timeouts would require more than 200 million batched unmaps
> per second on a single mm, which is impossible in practice. Even with
> PREEMPT_RT or long vCPU preemption, we would need minutes of unmap and
> refault churn while the stalled task stays off the CPU, which is highly
> unlikely and not a realistic attack vector.
> 
> This effectively adds 4 bytes to mm_struct. However, on common 64-bit
> configs it fits into the existing padding, leaving the size unchanged.
> 
> [ david: use atomic_t instead of atomic64_t, reset counters during fork(),
>          adjust description ]
> 
> Fixes: 5ee2fa2f0636 ("mm/rmap: fix potential batched TLB flush race")
> Cc: stable@vger.kernel.org
> Reported-by: Kirk Swidowski <swidowski@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

LGTM:

Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>

-- 
cheers,
jose a. p-a

