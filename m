Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 71B13606A323
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 20:50:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YCg5P/RB
Received: by kanga.kvack.org (Postfix)
	id 670E26B085A; Tue, 24 Nov 2026 15:50:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 621546B085B; Tue, 24 Nov 2026 15:50:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EA806B085C; Tue, 24 Nov 2026 15:50:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23E906B085A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:50:37 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7921F80C69
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 20:50:36 +0000 (UTC)
X-FDA: 85471206072.05.2E0FC42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D0A82100006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 20:50:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YCg5P/RB";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795553435;
	b=q43p38R9OtV2yyqApSh4NBsBt/qICsc/r7uq51mk1qCOL6MbkTOrkkoIJ5VV9wxSL1aVmd
	t3xdY6LVdn10TZCydX5qwJCp+wXCrq6nXI8OYfQX7GqO8jiXudA+3KzzLie+2jSSdnFazI
	iYHPO5mcqDAO+j6JzvfNtOUIQBv8zdk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795553435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T2Cmoxzb1brkU2WAWgFepmyhPPY4h/7fNR3QOaBug3M=;
	b=L1jJOt72tTCC4Ik1tS0n+hr1sYxFY9gOWXNu1lGPFNwEeHFadQVCCo3heSi5jCFxIfk1GG
	N5OPuRBz/9NEMq6yJ8ivYU59myiW/uuteuIYPoJhI1CeNyZfHiOf6osW4EaUpUqE9Vc9rj
	3kJEhaTV9EhTz6PVO7gXQnwtt8V+zFg=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YCg5P/RB";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F2BBD4351E;
	Tue, 24 Nov 2026 20:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2871F000CF;
	Tue, 24 Nov 2026 20:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795553433;
	bh=T2Cmoxzb1brkU2WAWgFepmyhPPY4h/7fNR3QOaBug3M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YCg5P/RBuE55E35xzbd0kZaokZyw6ayV60kuDkUiFuO6G7cWbSpYDRGaSM4dPOPHW
	 P+y1v5KL4nMjTiZdAbQyRoi+DwAJV5cg8lpblEcJLp/8MFBZXAZ+QNmoowupyj6O2h
	 sKc56OsXhASUxLZ4Rv0gucd6qhFdCy38w+SuBEGsOq9rQAwDOCQgO4dYjhKQlk6EG7
	 XpLFP9fKcvwDnz5rUrwxqNIDNoZG2svmMk5m4Z7mC9UDaLuFStKgkqrQRMSNhyFJs0
	 cc7AFk1RH226ltMpj9f2dPkz8V6tigdgxZm6jKdCj9amCMlJuQZenetpgwYWqOVc6L
	 FMeK7NARKo4BA==
Date: Tue, 24 Nov 2026 20:50:31 +0000
From: Harry Yoo <harry@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Rik van Riel <riel@surriel.com>, Jann Horn <jannh@google.com>, 
	Lance Yang <lance.yang@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Paul Walmsley <pjw@kernel.org>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Alexandre Ghiti <alex@ghiti.fr>, Ying Huang <huang.ying.caritas@gmail.com>, linux-mm@kvack.org, 
	linux-rt-devel@lists.linux.dev, linux-riscv@lists.infradead.org, stable@vger.kernel.org, 
	Kirk Swidowski <swidowski@google.com>
Subject: Re: [PATCH] mm/rmap: avoid reusing batched TLB flush generations
Message-ID: <awXQg94rksZvexZe@thinkstation>
References: <20261124-rmap-v1-1-e3dc48a4b527@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124-rmap-v1-1-e3dc48a4b527@kernel.org>
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: xfs3gw44tmwq66w5dq8ocrhgz93sqerq
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D0A82100006
X-Rspam-User:
X-HE-Tag: 1795553434-31627
X-HE-Meta: U2FsdGVkX18dHULXjextAQRr5/hnMJ2b3BEmVqPObsxNOrPCtMd1npoaw+q0LZ+v+/bSGD9//EBJ30KWr7LupdvOXmWTCn94UtCMdtJzGug1I/IUacYGTwxHMopG3yRHr+D846A3EnleRMc4Pq43Sc36ojowwBlmAfMj1PBTh84rn//N7WkpPUDUh3ptRK2wWe3KZhclB/o3UH1CUHDE23wZTOy5G/muF6UfPD+DJ92FPFExdtYoteArsAsrsS+k4me5rb1iWBj0/MQ89s5K82x5t36TV+TIcX0GDQMk/dSPqsOHcjkuzwSXFt0dxeY+DqgFB/wbRIAWV0tZyZphdgc7uWHFdkggbMbCHcfxJAxmusfLfjX8xbOoJd/Y9l+txb18b55Ch6P64tNMJmCnM6rKnU9HbHoBOUGmHVnnevORNS+348EdvZd4yORJ9RVHAlPKMVL/hiaWGcs/ZUjygCKKfFhfp9neFO8fdiucSokQoYmUOdnibCTEvDgOyc7vWuHvP3VtMxwTtuatf5kRXy6/KkOPvnlcq7nAKhXVa0txWIcbWTPaj10mzLcs7SRMciHmGQ5QJ8Dph8RE0xE+xRSCWGGmXoAYI0/VLi25BA2j3DH2wtBbnR6xeetjxTuh+3JNaHawkTBMXnZLFlrY9ZizfTGax/DOMbfCOdlXrAWXLnYfMeOXoBy7wNB7+rwP9gpwBezZG0J+9b12MCRf6aZhVtVosxmPVukNbOLReLQdubD8LLLQozveMqlJ9PkFL4Flzhrfc7jYufGn7l1s/DCf+AfJQTMTrAVbv2OFi5p2tkenf2Pm+xJvQbGkTw9Ycee8YqObZLoctWtb0+eDDvphNd/7zyWQTzBXfKR37IV/yBEtin3VBTFAF6/UjxxE6zBKXSuxU7hQbSupBwW2WQ/ivLwMCOi6DGEtf9oaqgNWM2hZM9b/6l/obHrkYRof2sRwE3vRLEV391xPsff
 Dtrpa2JH
 /3xJ5PcSqHTmwcFmxcfxuV94dsyOKskDhLfBfixHX12nNM3xeiqwpRm4cVnfxFD/JpJaZvXlC5AOCDOR3CtxdmHux9LZKR+TahIR/cveqegE+OlWGYmPr0+5ImLPbgwQGAvS/JQz5bmvy58VxeEmSC9w7fc+cFBCMO1YpkOh7DLyQf3J7EEAZjzPyxDID9dau0/EqyM9dY0ii4KWaeiBAMePNv74Z6prmoahy5gHGrxTwgN35dEywznnfQ1Fqv6VxX8Cy8TaMpiegY9r/jkQ+iAir5AiT+VDT99EBztHubOC8syYaH0kRHxMm9UqVANl1cFFSMQenV5JwW2Eb7XTrGfhGCoBwRztAUWAkNLDuY6JP45d+WatoLnFWfNpvD9R/Rz1gs7KuVFxwiXGulqarmQHs94JUHINEsSB10U9RRJLGHvCQ9Psq1tguiPBgdGG2H0UlLiucvlq2CvgCYOOut/0SFp4Px4atPVmdWmeQoOlbx/4gNDh2sMlj8tOrIN+h6Aop9lWRdHGQR5VQduIXDXHjnz/1eSsYa+IzmSD2amWwBXMjeuPLZXvRtZZpzI+edPDkTBDugg7X9ffR/olpkX5WBXJjsVUKf1xC3fPCq4McZM89WJljzuQ/z27WZZVrc6WXDVo9g0bchz9QQgCoIHdSGPZeLpoEMzI1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 10:39:11AM +0100, David Hildenbrand (Arm) wrote:
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
> ---

Uh, I spent a couple of hours to review and make sure this is correct.
I thought this is correct but then my claude flagged a race during fork.

dup_mm() copies the counters with memcpy() and it doesn't know the
ordering. When flushed and pending fields sit in separate words,
dup_mm() could read them in two separate loads, but in the wrong order.

It's especially problematic in a very rare (IMO) case where
flushed == pending + 1 becomes true in the child (which means the first
pending flush in the child might not be flushed properly).

fork				reclaim			another process
memcpy reads pending = X
				pending++ (X + 1)
							truncate()
							-> flush_tlb_batched_pending()
							-> flushed = X + 1
memcpy reads flushed = X + 1

Maybe reset the counters after copying mm_struct?

-- 
Cheers,
Harry / Hyeonggon

