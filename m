Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7D56C5CFCF
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 17:53:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7019D6B02B3; Thu, 13 Aug 2026 13:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 68A996B02B6; Thu, 13 Aug 2026 13:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 502E36B02B7; Thu, 13 Aug 2026 13:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 100086B02B4
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 13:52:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9B64D4026A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:47:49 +0000 (UTC)
X-FDA: 85096979058.23.77451DA
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf23.hostedemail.com (Postfix) with ESMTP id 94F19140004
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 17:47:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nn5Lnw81;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786643268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3y7pys/aur7fDlG+aT24eU7dWd1dPHX0Ry6w4e1aYUg=;
	b=bT6SIEpXUGJFpfXzmtYDkV+nRrgpU3a0vFfi57yI6YvZMW24ud/REj0D/f8wAtqEHqRKM5
	c6/lSvv9w/wV3hOmpX9zbw1aOzV0x0GDU8Ge/bofTq/j+EzqdP1JOX8bwuEAHAtSOgMTkr
	eXn+m/qyqNVCQEP8O5U0lc6BUzeraUY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nn5Lnw81;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf23.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786643268;
	b=FWCc7kQLt2yMpIlQXgAchGrN5Wd9abymd9NZGL4ITtO3CAzKa77QoQtHYlWqpcQFqH9ZtA
	tkkB7Glh5DS7dcyzR1/AI4DG0SktCRV6MOh3mcffV8mIqhLAI3Ns0qIgXlvUgOAI/aFqfk
	UYRaos9N0KljXpHvTdMiCIgP9+yPda0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2DFBF1596;
	Thu, 13 Aug 2026 10:47:42 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 69FF23F632;
	Thu, 13 Aug 2026 10:47:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1786643266; bh=1CYW0i+lW++6QIhwUBddZ8XJqGMhScftIHevpWyhMgA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nn5Lnw81w1QjuPz1RXLa4mOPfZawnfwvqyFOA1yyoewdcvO+/rD6/grSpFM/TtGPo
	 VQlEITvj3yBJQqcPyEl9NflGhE3/AHrsgy4lXQlM/ucNvSA3KdFUIYm1nGTNt/NQLa
	 I1K51kkmUU+OwKnvX9tXG1V6SdGYjM97G3+pzSC8=
Date: Thu, 13 Aug 2026 18:47:38 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>, bpf@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Dmitry Vyukov <dvyukov@google.com>, linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
	kasan-dev@googlegroups.com,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH RFC 3/5] mm/slab, kmemleak: handle kmemleak freeing in
 kfree_nolock()
Message-ID: <an4DOrvgdJcfOVvb@arm.com>
References: <20260807-kfree_nolock_kmalloc-v1-0-ba993cbf7a60@kernel.org>
 <20260807-kfree_nolock_kmalloc-v1-3-ba993cbf7a60@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260807-kfree_nolock_kmalloc-v1-3-ba993cbf7a60@kernel.org>
X-Rspamd-Queue-Id: 94F19140004
X-Stat-Signature: ft4k19ianinjn8wrgttghendzatksyfm
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1786643267-203281
X-HE-Meta: U2FsdGVkX18837lBx2TMOJk80jFymgv5No5VJugyOWcejPYvDPJ78zv4SavQZL67pGdCuVpsOWV9KjTUrzVO+0jEvR5/ZKz69HWZrXU+4fWNW8cp+DkGaCgYkwfvXLEqfvvfZ/6DpZ9afLV9q+/NtKZHxQTr752YBc0FvKixJL/JITQ0Z1OV53ea/k1+vej/gxyZ1ygZKzvTYu/YxuZMvjwhHxPxF8RtpmBzDN1Bd2PUFW8Jlzfnq+9/p5nsg1ym0Sgpq5zBQ5HfHdNXIkc5snW24YDoUQJkmfTNSm0VnFTJhgaYBSIpLkSzRoYl7OqkTx7xT2AECZTNZSJ0ryj7xffiRzIqWu1FJCDmrVgryWKNm+hkkzx+aNwZPxgFvaWNkfn+s5+nhhKe8Ck5Vw2Lc6vFtYfEpFW4pfs8n3hLpZK13Qui92aXI1V36WTvVT++vLovCbOed/IbwTeuQWvVfTXRm3QOsLmjlDdNiYbm4x4/AUcHsRaWy/eKqcwiySVDhUjQxwkCBQoj3CSQf2CsSK2wq1g6TPSW/aRXTAcxpvfbZ+m8Yp1dU9FWx2eK8cgZ7VY5oRfLMgdwE9L9B94I7cBJjwKKlCpXBut1UFqrd4uRcOPBjtrwpvLNcZkf8D+M/2Q2tJ858GuERVtBE5K+398iBSnCAyXWiPClDsLv/3h4aKuus2xVi6ez+DRtA+1YqEqFquuuL939iyA3FYM5K/o9lS+UA5JyAkCDsWm/8CB8FSCIOkWE7eR/pz3Vzlf4VoZpV+e2TiSWcGdoANVYP6uCSJwqe6krdzX+inDRoI4JxLljtyJB0bQjWdyBGOe5UE0W9OyCPwtqlOR6p7bu/uf1TbseBcmNLXbjvw6+ayZJSZmMhBCBMkz1VfvOl2XD3IE3VYmsU9DOLrdRLOeQzGXXWWM3n0ZnaRsW568KGLdYPCo6PxV0UKTdcyUKKZePMJT0SFWTJuzyiSh4dpu
 xcnjR7B+
 zoaS+LZJI7ScjIAZx3h+oX27tebQE3UjKBMjxM4ruXZJO6rUfjHf8+74LUaE+62XjTlZjG0zLVd7xCsxCp+evM9L3RtoTl5t9glsB3muQTdmHq/dIfTdeOf+Q6q3kaF442pEB7ZkA+n7iKbJJZhKLoXaikp3P5IajDjtOJADQuX5CwOab6INn9mt6HlOWc88RcnqnR5k7ZO0VI4rUifpX5xo/XP2shJSCpy8Rp9qljTc7hqvDEhRw0L+Y50Ru4eqK2SemA6xkbMnkYLYZHLTfeg0AOfA+EuiGjxM3I7Iu02EYYKRII1y+Idf9UI5e67DRR6hmNtPMsaI8plmHw+2miuv6DQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 07, 2026 at 03:50:29PM +0200, Vlastimil Babka (SUSE) wrote:
> Kmemleak handling is one of the reasons why kfree_nolock() cannot
> currently handle kmalloc() objects, because calling kmemleak_free()
> would involve spinning on its internal raw spinlocks.
> 
> Kmemleak is a debugging mechanism so we could simply defer all
> kfree_nolock() to irq_work if it's enabled, and eat the extra cost. But
> that would be unnecessary pessimistic. We expect kfree_nolock() will be
> still mostly called on objects from kmalloc_nolock() that are not
> registered in kmemleak so they still don't need any deferred freeing.
> 
> Thus introduce kmemleak_may_need_free() that can check if the object is
> registered. This is done using __lookup_object() performed under a
> raw_spin_trylock_irqsave(), which is safe to attempt from kfree_nolock()
> (except from a NMI on a !CONFIG_SMP system). When that trylock fails or
> can't be attempted, we however must assume the object might be
> registered, and defer the freeing.

The only risk is during kmemleak scanning when kmemleak_lock is
repeatedly held by scan_block() even for minutes. There may be some
timing where most kfree_nolock() deferred during such scanning. Not sure
it matters much though, unless the kfree_nolock() use becomes widely
spread. If it becomes problematic, we could add a new RCU-protected hash
that's searchable for this specific case (we can't remove the rbtree as
we need interval searching in general).

Otherwise the kmemleak changes look ok to me.

Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

>  void kfree_nolock(const void *object)
>  {
> @@ -6844,9 +6848,23 @@ void kfree_nolock(const void *object)
>  	 */
>  	kasan_slab_free(s, x, false, false, /* skip quarantine */true);

Not related to kmemleak but I noticed this call here: if we relax
kfree_nolock() for any slab objects, would the above poison
SLAB_TYPESAFE_BY_RCU objects while they are still in use? I guess we
should not allow such slabs on this path.

Sashiko had some comments as well, I haven't gone through them but it
also mentioned SLAB_TYPESAFE_BY_RCU on another patch.

-- 
Catalin

