Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B059A606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 13:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=eassQ+eh
Received: by kanga.kvack.org (Postfix)
	id DC4516B0A24; Wed, 25 Nov 2026 08:52:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D74DA6B0A26; Wed, 25 Nov 2026 08:52:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8AA86B0A27; Wed, 25 Nov 2026 08:52:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A3D7A6B0A24
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:52:22 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 19827120E59
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:52:22 +0000 (UTC)
X-FDA: 85473780924.09.CC56B9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7C08E80010
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:52:20 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eassQ+eh;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795614740;
	b=M362qcS7SJp5UnpOLCH7AfbNE5owJgdy/jozQwD9GC6PxfSBKPV8UBXXH/xvj+7aXOWjLb
	NHEYMDuRkjNTzFgsZ7VRpvu0FsNMk76GFMLgmCX/0TKT6JWiyw4dvi5XRME0/WcaQ+Oexm
	930BtEZFAwlYdTMmbq8ISFm7rCBsU6Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795614740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ih1VDTrU3FeJ2fsbtiUZSy/fzpLqeBrB/3Ho1Q8Vksg=;
	b=UYSTbgf5OsajJZu6iojpnspO1iW0JX2E7eTc0q3ZqRkMnC7xWMmC4yE68VI6ZmLySh0e9X
	ZqU8N2pMFbMCgxd9ANgR9B/aorHgzyq22n5AbMgj+Cg6OcFQ+ytHbtkjE9welJMZcSqvUv
	6GSEmVinJBkvIZYkPyd3o8bdGPJd0jw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=eassQ+eh;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CAFB2623E0;
	Wed, 25 Nov 2026 13:52:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21D61F000EE;
	Wed, 25 Nov 2026 13:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795614739;
	bh=ih1VDTrU3FeJ2fsbtiUZSy/fzpLqeBrB/3Ho1Q8Vksg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=eassQ+ehtNlIg7BCYm6d9K32YvY8qw6Lw2o1T2KIXMP1nElqmQXlEYtZ3auoJRGPs
	 RuPLl0AlZn5mOfaiPEATfDF5yS2c9jSNMDDvEc2aB3teBrAHDvhqvQ0MilTw5woUrX
	 r+0qd3DgUr8J04D3fhgoVd1Mx84QADjJiEWYndLt5edAv7x6+DpeHV7Vl+aDd+IcQh
	 1ojyxYxC1kYLPCYAitx6iV/dJHFlHDlAbFcQmP57isDtbEc1BaI4smiZPDCiSmq5VS
	 ltAC3lonKaXHrHdjEBqyBOf1CebpOHDeQUX4mcBbO+VEv83fNq1eCllKZOuRXUuBGD
	 YyMs/2wdpZIAg==
Date: Wed, 25 Nov 2026 13:52:17 +0000
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
	Kirk Swidowski <swidowski@google.com>, Huang Ying <ying.huang@linux.alibaba.com>
Subject: Re: [PATCH v2] mm/rmap: avoid reusing batched TLB flush generations
Message-ID: <awboAcnWHZfsy8bg@thinkstation>
References: <20261125-rmap-v2-1-0ba817662eac@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125-rmap-v2-1-0ba817662eac@kernel.org>
X-Stat-Signature: g6kqyuck3fn4b3j5dxxbrgwdbydybgas
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7C08E80010
X-HE-Tag: 1795614740-811338
X-HE-Meta: U2FsdGVkX1/VnRSZd9/dGVxrRaa+6DPRmEbREm25fcKcVD/IhYVl41ln1kHUxcZj9vA0rkOYlDbQCzlUIk/h92y3iowRxM/RPqW/qwhFiDaJSIQMElIsCDhn+k9Ko5e60go/Dz6gkaRiYifg0bJop+Z4bbliJkpu8T3d6GIZb0wvmU2yMoV6vDKyfniOn8loZacnvxXd9MI3dZgd/3n+b3W/x1UvVrnnp/6eL1nB0/UX5wGbHs9tQrKq+SyQVfK3HS/P5HuqzO1m6Os3LvngtvURj4wq32dAsijjU8jyPZwmrAx/n57hoeW34A9nXYD8jlXyZ4jasS7VlbN3xnMcBC7pF4GptfekPORvgt1l622F69nsQQ0Y2nsnUqfOObmw0wdAdt/6skkIXDTvXfVZNSlKdvNLQ4qV0gSNTbW1bDxpCWk1KXbeRSJetcCPqjuqV5iNkkCAhCx00SZS42UOZ8PfO5pANzjafYpVI5t72kPF+z/JRh+SBJpiy0qDkJsR+8GL2rfXExT3id4p+lCSgJ37lamhqFH+Yzs+A6534Ey6oveP19Fl3za89qYBWLNXeyMjZkMRrbHYuE3lSXmFGKR6FlmT8t3QnYUBLZtJs9NHq+ZaJdKIbEmZmEkqPCg+UoWx9x0MWMx9gZd/K78+jWcdk9Mg+h4Z7+Q89OMsf2oFMA9xvvDVesVfo4JwHEw4D5R4FctH5TuddTYWp8s/LcgE4lgBEXOIGmBs14ywF6Bn6qrsnowpl0N9W1ZMtajD0FvWe9AxwL7E8Pb9xYnCVCbXbtpwg/MGcT0qkr7HC6KgPwmoFM9m9PcqNoB1nc8kyHEiFsipDqs4npjOFCsP9cLdflsBQq8Aq1hXZWGbVQ50mnkuL8S4xzQbh3vxt/X6R4Yenbk/CCnjzAZb6m6YoJL1XjArr8jnH4DkwPhjG4PE60pcRQ4jckIvf1kmY4rFqt9bQSg1RWMnSGaKX/z
 HdBb40kI
 iII81pkseUUz/ibEWWjA4bOc0MuNoj6mMLhvEcTeh/vz7/huLdkvOKzqJRUbN6z+1xxyGCtbqqlqCp9LdwpiCigGN+SLc81S6X6SzMsiU/KUSe2200iHlBJRd9/8sxCvXttAkhT89iH3ZWKKurBOX55jYj9ghDBLlMohQS9+JR9nyWBfZaRp/pnJFCT+CwsNA0HDNSpBK5rypO/htT4dwURkETrEz/6uEht+vcbMBly0w4JUe76+0SGNfrdzdTAxoueLaj0qKbg9RfeYP2vEIcqELQfItSVdlylCujlSu9FsmfPaOX8tgn25SQKxb6OHpDknLDSkCuDfLuolyGmMY3YqFLMXgM3wiGHGOwncSBRMld7w09C8Z+pmVPvRyBc7xFu0vKiPetQWBTVrghj4HRY4NoepUkKd/xwVyTV4lObb49vcRJH5+mm0pjXP6KALlLv35KJuoeBOkc8sEvT/ixCapdt0qwr5GL+xxHlRS34rVjjxP0xdjwfkQLgc9cpjUWPBhYw9OoFLxMzgnGqEoC/mQtNToXzpNKwaUbp8C23TT/1JUla7BobxV2ynxiQqtiFQyUxBFPfoabixxtXfDXS9neHELlQh9ResNGhhzHfsOT+30mqa219tXUo2Ze2ffc8V/REwROPvUBlo4nsPRj50e3W9jmkhaCcQap3NVjLTFM6A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 10:34:46AM +0100, David Hildenbrand (Arm) wrote:
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
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

