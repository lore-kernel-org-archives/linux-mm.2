Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8395606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 08:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=VyXu7E7Y
Received: by kanga.kvack.org (Postfix)
	id BBB566B0943; Wed, 25 Nov 2026 03:52:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B92CF6B0945; Wed, 25 Nov 2026 03:52:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD08D6B0946; Wed, 25 Nov 2026 03:52:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 840456B0943
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:52:08 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 14273A8CC2
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:52:08 +0000 (UTC)
X-FDA: 85473024336.25.DFB59D1
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2E637C0007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:52:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VyXu7E7Y;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795596726;
	b=j149b2v7GXk6Qc8l2n0rnrDRovYWpQtkfLCppIW5GeJXFxT+y/gJRE7ye78ZmyoIaoxfKN
	9E+C7WOnR0QbGxISPhvvras6bN8NF3O+T3vRoeJ6hwBVPpYrYnSeaZW3qDfAA/cv65aip+
	ZfLpTaQUvPudaNLbXJZC3wr7IShELl0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795596726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CpS23/nwi76U/xfd1RwGp9LbeXJvRV6wntw7x0C4i80=;
	b=3qfV+7POWfaYGGFcRijLpBdVr3ju4fOS+iktKl95iW9weGHUbczxbxwsuLGn/zDXMCpJ9h
	4zILMMnFgnEj0sb2qbGLlC4l5jZ0NgnSKZc7FJEswhQ+KnyYr/H7+7rKlUDQ0X3xKag8lu
	YL6vy9SVSDJyVdVY5DKoEuTHFhInJa8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VyXu7E7Y;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf10.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1795596717; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=CpS23/nwi76U/xfd1RwGp9LbeXJvRV6wntw7x0C4i80=;
	b=VyXu7E7YuJlZETQw94qjHcothUquMgs5+gNKvHjPaNQQvKQVkdlNNDBb2ppmfVN8w6Xdue3A2SkZds2JVIdJDeHlV81tjFzOIkHrwGK9EQzTxAk2qgFIP2vGBGoqRKe9knAYR4h2SWhXOlYE9Yu7NfXTxxXeE1oNQIf2vntzx2A=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R911e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=ying.huang@linux.alibaba.com;NM=1;PH=DS;RN=25;SR=0;TI=SMTPD_---0XFR2tqg_1795596713;
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0XFR2tqg_1795596713 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 25 Nov 2026 16:51:54 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,  "Liam R. Howlett"
 <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>,  Mike Rapoport
 <rppt@kernel.org>,  Suren Baghdasaryan <surenb@google.com>,  Michal Hocko
 <mhocko@suse.com>,  Rik van Riel <riel@surriel.com>,  Harry Yoo
 <harry@kernel.org>,  Jann Horn <jannh@google.com>,  Lance Yang
 <lance.yang@linux.dev>,  Andrew Morton <akpm@linux-foundation.org>,
  Sebastian Andrzej Siewior <bigeasy@linutronix.de>,  Clark Williams
 <clrkwllms@kernel.org>,  Steven Rostedt <rostedt@goodmis.org>,  Paul
 Walmsley <pjw@kernel.org>,  Palmer Dabbelt <palmer@dabbelt.com>,  Albert
 Ou <aou@eecs.berkeley.edu>,  Alexandre Ghiti <alex@ghiti.fr>,  Ying Huang
 <huang.ying.caritas@gmail.com>,  linux-mm@kvack.org,
  linux-rt-devel@lists.linux.dev,  linux-riscv@lists.infradead.org,
  stable@vger.kernel.org,  Kirk Swidowski <swidowski@google.com>
Subject: Re: [PATCH] mm/rmap: avoid reusing batched TLB flush generations
In-Reply-To: <20261124-rmap-v1-1-e3dc48a4b527@kernel.org> (David Hildenbrand's
	message of "Tue, 24 Nov 2026 10:39:11 +0100")
References: <20261124-rmap-v1-1-e3dc48a4b527@kernel.org>
Date: Wed, 25 Nov 2026 16:51:52 +0800
Message-ID: <87a4mxthsn.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ectps178m9ykts164hapo8hai8t3rktf
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2E637C0007
X-Rspam-User:
X-HE-Tag: 1795596720-821428
X-HE-Meta: U2FsdGVkX18K8R0G23CaPJb/4fVtdsmZajaSScbypaxEYzOEwZUFYv4HHXiy9fqQEmAzQWL+4dg1hgMNHlwSJ1P1AnO5+Y72yrjEMQJQhrPXTklRehhPgihUJlbhDWTWrZHjPX0z+1d/QsRQTOfCiwtIr4XEFJZG2Erpsa5xdDt6IrWZ10qk7Q4ozFPm7jOTRPLRTtxJE+6ZfVD9lLk/CPgUevMuGu5zMaajf1aLqqj5ozdJeqYU99so4iRnNgn47XUSwaWrGERlv54RNNTpfPfcnVp7LELrcTaHx4Qw79rULbd8UdhFlor9Ew7Qo2IPISsVI3CegXkF8sdXybMpFlE+rVb8TNTHd9r7CLVA59JzSK/7IHqYF5UxM8Wxa9WjFSDKZth8RtZjkL74AIG847icHSSobwg34xOhWUl2bBpjCtPmd0vFgRnHLgwSlaKY+4CGV4gf4n1tkPZgvV8HHcFCjJrxHFCXul9UJdccwI4netxErhUyoM4ia4f38BX5R7FItobR7oLaaz0YfFoMpn/IqXZMkNVv4gifl5RAGVmFqwEnrJ7ENlV3mfbi3HDkLeVa0+btKbtU4g0pnJbZRlQa3Id7BC5fELJYP/rrY7EdtGEC8XUBmy6wlJPb25r4OZ65kjPsgDcQ1nDALMx4GYAZon/O/0FOc5v6E/lqfwT8BzQMxw0vJ/jY8BB/hMYvPF/kycoU1SsqduKF6MVsVyBsLjbne5THqrxNoO/nLUUMc7FC6hgVr7VLWl+7kj9uV8Auh0VvQupKup1MozF3kNC58inUSsY1LJTp2Zc01mkLpUCDIdp7VtUqFT7d+JTNavhmYmIMBX/Ij+CLldq2qdc6yK2JhOx5m20P7Pib4NvnM/dnKiROW8oxQOPwkRybgDx0WTIZEVls6yCiDUjBB1d9vWbolzVd+Apbw+ssQzsuHnYH61IUf50PZgDSJDpn4zkHmpu3seVGRxMV5dZ
 ipoKokkN
 XRHmg86tFhvj8vjQ1REWxTKzVwQj/38AUkYVRPGxCWw3jWSqXzlNXoT4LcB1cMFKfkiZhiD5DsQ87uuM4s+5A91n/wfViJyv5+SVstvV8wxbbRgCxduj5s46CQatiPIAhlU+w6DQanJr+fIo4z7XLJJGWQte/cUORSVWd9e0AjNT86VNH/1uBNyyogOXKe9ttM7sFq8ES8QXyBU9O1G1NiDO3xPLEP2Z7sj/sCQr01GDNa08s3lNZPbER2EwhczNiNibQZRpymYpIROQq9RH8keQZNozps4dI0/tX3ZeLXdtNfxCEQ2LdZ9FGSf+uvcTW/Z7l2OiW9HwwQgRHtyHAcqsKXu/TaGQ7pHZzzGrlllq9KCc6XaSiOyRpbKqOHaVFDhCdQ4lDJti2gdqaIbTWbPx+rl3b21eYkCPXmZZlUA/jDqgJ0EOobWgAFrl6cpiToVu3/qc4bTIxd/zuhFtoUUSrC9h64ndHialAQgoV+dO0EE+e//ucuguHOFqeEsMLXGV1vPex92oEdy6ecUwMA3xfoXjBelGK7UXt7LDmzbV+ZC2Ls6WMM5ttWoFIVoakE5AWrHtSAbP5kD9XV/hc1QEwbg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi, David,

"David Hildenbrand (Arm)" <david@kernel.org> writes:

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
> TLBI, riscv: fully-ordered xchg() in ptep_get_and_clear()) imply a
> barrier. This should be cleaned up or documented separately.
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
> Fixes: 5ee2fa2f0636 ("mm/rmap: fix potential batched TLB flush race")
> Cc: stable@vger.kernel.org
> Reported-by: Kirk Swidowski <swidowski@google.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> [ david: use atomic_t instead of atomic64_t, adjust description ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Except the fork issue pointed out by Harry, the patch looks good to me.
Thanks for fixing this problem.  Feel free to add my

Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>

in the future versions after fixing the fork issue.

---
Best Regards,
Huang, Ying

[snip]

