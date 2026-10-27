Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E192A606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 11:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=casper.20170209 header.b=tec1jmsz
Received: by kanga.kvack.org (Postfix)
	id EB4116B06B1; Tue, 27 Oct 2026 07:09:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E657C6B06B3; Tue, 27 Oct 2026 07:09:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2D076B06B4; Tue, 27 Oct 2026 07:09:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AE0D26B06B1
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:09:58 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4F6DDA09A8
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:09:58 +0000 (UTC)
X-FDA: 85368136476.04.B70EDC5
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 15DAA140004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:09:55 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tec1jmsz;
	spf=pass (imf23.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793099396;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8BryABgcZ7DA+XBYIpyIPDmj1TmISKJ+oIODypTsFPw=;
	b=2z+AlTqQ6dujAI02C2iaJZKnPhGuqFd/SMJvP9Z9tlzuzuULDDvdQnGKnGIuLxnn2pedLy
	X3DakxE72FXjBfCiHUA3BjcIA5xMtG0Ea00kLQzBa2pDgGj5n26+jncpwUrjo+nJIL5y6V
	hp3kTOLZthLub6TCplpFsm5oLl5z4Bg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793099396;
	b=oxbqo2Yyckq9A8jDuf7+442eVA2hqh7l8n4dF1iI9tzsyEcpAFKrqwa3eR9HeVvw2997yb
	5iXaUV67fOx+97HQ0BUjsU2EXeDHgdMbob8tQg/O1IbEqiwxHRqNNaL0ePgV0ZNKPP3W8e
	TtHmKGQGe7+WlsBisPKkn/Y/4yovrAo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tec1jmsz;
	spf=pass (imf23.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8BryABgcZ7DA+XBYIpyIPDmj1TmISKJ+oIODypTsFPw=; b=tec1jmszyHzg20Gsi9B9OGtdi0
	bsCvcBUhd46e/5/GXq6SGAww+LVpHIHQwe0YKWk72ihksfy4XUJrxTbGdLAnv+D/3l8x0l5pOrtHd
	7acMwSIp8xdaNQ1AIn1SBzFfdKqfG47ktiRrG9Gdqsr6nFLRAKQwd+iSUVX0qRopMxZbjuME3IWYU
	rWWjhVhXS7N+lyNQrK9sV4YC1izjgWJLVZnwjd0PysDBxqh4LXHJQqVbGOqt8gUresF7JGcKsKk/M
	4u4+TrZIvctu40uV383GKM/IXYMeeS9/2czQz3WkAwKHaXgRu8pQpjnw4c+liTKeH/5Cd28W8xTcV
	Jq4Gy6Aw==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xLf3s-0000000D9LE-3APy;
	Tue, 27 Oct 2026 11:09:48 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 385DE300312; Tue, 27 Oct 2026 12:09:48 +0100 (CET)
Date: Tue, 27 Oct 2026 12:09:48 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: James Houghton <jthoughton@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Thomas Gleixner <tglx@kernel.org>, Kees Cook <kees@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>, Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>,
	David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org,
	io-uring@vger.kernel.org, linux-scsi@vger.kernel.org,
	linux-btrfs@vger.kernel.org, bpf@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 05/10] perf/core: Don't unwind the user stack without
 an mm
Message-ID: <20261027110948.GI2668564@noisy.programming.kicks-ass.net>
References: <20261026215226.3713941-1-jthoughton@google.com>
 <20261026215226.3713941-6-jthoughton@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261026215226.3713941-6-jthoughton@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 15DAA140004
X-Stat-Signature: a7st317qfkp4cutsgouwk59t56m655kx
X-Rspam-User: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793099395-815375
X-HE-Meta: U2FsdGVkX1+2tBWDlKtC49RtouBnhgBKHZYLuvzYqGLwHRHkkC7l2mfcCmkmpayO59YhrdJI/oTvYWFAj2o/9+2odzY4t/5ryJVi6gvc/lo6cXo9Um7LGeLFxf/p5GlUepo4WZC4W38EnCT04yf9fIRaLrqZSQkLYBeT1dwfyAwUdAcN/8gXS8+ubRC7R0x91yUZRmtMk5kKF+awimCFlGRtq+gCrFyxrYERoQZN1NopBTJc2GoLd2NFa8biqzW3tMDX2UsTe/sjaCBywML7HJ/IvDGoc9Jx6XPysRtlUCgbpmD1v4DrSoxi5XUcX7Or/o4oSdmAtVK4r6cz6NKyr31K1XCRkOf9oBVvkPZQG+7Sehus4qX/O0ehvHeGqmMGoeeGreP+VpNq4M5hiN+usLzhk3QjEd19H8LXCQWhQu3+Ak0cv5EU83TBn/1l5M2Vz7+FNViQEU8laQJxJeE9VeBJTnme69X5ovu5t9EgS3iXhTh3UNaMprfqrdGRF53t54l8QPD7fMyBQQByAhlupp5G8LV8vLpjDx+7wsFAGyt5sC0DTUBlBS9RRxGRR3gpROZgPkhDojtbqquslGbyPNgA1ZAyKsukVjgtHXMoaBnImc7Gs0BXYQFFiLUaNPC1MHV7vUrgxo9StDe0La8mlJad+j/bpjb1SmlWsb1MPIsdRdrpYr0qVF1WndMNOdVBHLg9ZXmetBr8YYs5QQ/7lF5xBZsDizKQEaME3HM4l7P3xbUpSgtmYDs58kPonY3NVeN+Tg60iJWKZw6H8PGkJA2EnfA/s9ua5yTqbpRucaMWEuudHJ0RqMIQl02+XXVFKzuqHd4VPpgk65BNd1QNUjCYoCbLJQJqDvgs+HWrZUQUJrzoymwtYqLFzi0hV/KmzCcH0MJ3KWVr844NAZ8yT5C3QzDOkRVr5/wl/Lb6+NVxwwtH6z4M/KLP+Nsqz0LHH1EaJg6MjVB9H8Bb2Rl
 jw+JFVDv
 OkbcxjNakAl0JeeCrwYVE1ZOqxLIqVNHddBkm5fNa1y7vi0UQWbovrgu3u9VAyjXKPChhhsN4TlKrTn8obIzgCSHicA19PkUXIGLHhm2woNcJ03g9OddvD76OEjKhSWyVoPkj1RqGrpH+SUwtip38WvKu9cijgoe7YiiRFn6Z9uhg8wuQFPXJqbwFKesdjHxXPohuzSAj3MlbZdW/cAoFx9bTNF+ZS1hq0ffh89mQ797J8gKL2nZkGpw4RjAFzKrUyQRub8gZXHflUu6itONzJ5gtaOBkAuEFT/ar3z6Y29CxY4ETGAkROeOtosNwxOaSakeTYMyXBQRL/XU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Oct 26, 2026 at 09:52:21PM +0000, James Houghton wrote:
> get_perf_callchain() only checks is_user_task(current) when the regs it
> is given aren't user mode regs. However, BPF's bpf_get_task_stack() (and
> bpf_get_task_stack_sleepable()) pass task_pt_regs(current) when called on
> the current task, which are user mode regs for a user task, even if that
> task has already gone through exit_mm(), e.g. when called from a program
> attached to exit_files() or to the dying task's final sched_switch.
> 
> perf_callchain_user() then unwinds the user stack without an mm. That
> access does not reliably fail: the user half of the address space
> belongs to whatever mm happens to be lazily loaded, if any, so the
> unwinder may read another task's memory. This affects e.g. arm64,
> riscv, loongarch and csky, whose perf_callchain_user() doesn't check
> current->mm itself. perf events themselves are not affected, as
> perf_callchain() already clears the user callchain request when
> current is not a user task with an mm.
> 
> Check is_user_task(current) regardless of the regs' mode.
> 
> Fixes: fa28dcb82a38 ("bpf: Introduce helper bpf_get_task_stack()")
> Signed-off-by: James Houghton <jthoughton@google.com>
> ---
>  kernel/events/callchain.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
> index 9d24b6e0c91f..a451ca2a5573 100644
> --- a/kernel/events/callchain.c
> +++ b/kernel/events/callchain.c
> @@ -245,11 +245,15 @@ get_perf_callchain(struct pt_regs *regs, bool kernel, bool user,
>  	}
>  
>  	if (user && !crosstask) {
> -		if (!user_mode(regs)) {
> -			if (!is_user_task(current))
> -				goto exit_put;
> +		/*
> +		 * Even if @regs are user mode regs, e.g. task_pt_regs(current)
> +		 * passed in by bpf_get_task_stack(), current may already have
> +		 * gone through exit_mm().
> +		 */
> +		if (!is_user_task(current))
> +			goto exit_put;
> +		if (!user_mode(regs))
>  			regs = task_pt_regs(current);
> -		}
>  
>  		if (defer_cookie) {
>  			/*

We have perf_event_exit_task() before exit_mm().

Still, it doesn't hurt to be cautious. So no real objection, but perhaps
adjust the Changelog?

