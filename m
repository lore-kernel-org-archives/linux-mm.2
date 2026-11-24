Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7214606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 13:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=d6hKvlJg;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=o2pbox66;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=d6hKvlJg;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=o2pbox66
Received: by kanga.kvack.org (Postfix)
	id D53EA6B06BC; Tue, 24 Nov 2026 08:04:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2B6B6B06BD; Tue, 24 Nov 2026 08:04:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C40566B06BE; Tue, 24 Nov 2026 08:04:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8CCE06B06BC
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:04:48 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A9514C0B7A
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:04:46 +0000 (UTC)
X-FDA: 85470032172.11.9B8B3F5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id 761DD4000C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 13:04:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=d6hKvlJg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o2pbox66;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=d6hKvlJg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o2pbox66;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795525484;
	b=H12ajtuSnlLiN4bJIAeE/JLMfC9XA6jzsHvw6pciGRRZb+oeB/52+pRaGUvn1k+hAMyMjd
	yGM9nXj17bfQ8NP9FlSHZtPTAp936by6cu4bjYbNr1lU8KBHcmEWIs/dxUxOKkuA+jPRL7
	+a/x9rGBv62AeU+Q/xZNGIupsghSURc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795525484;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MGLlsaUUSwBgOFasvcC4m8G1HbbNWKywwDMCQ+xfhD8=;
	b=LXRdMHrW4Ja8gC1ztjeJ+k+tGwdQV8xy8aBcVFxda0DG4deMVhuoIhi6dBubLhzlkLy7Y6
	G8IZYES5G8fEQZe+1aibxQyUDk78Fvgezs6Fe9PqNoWcV0TOj0mnymrR2ilnobanAmqPlm
	yzl7zW0PI6yIe6YedXKZzHjFF0sMIf0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=d6hKvlJg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o2pbox66;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=d6hKvlJg;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=o2pbox66;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D5391221D0;
	Tue, 24 Nov 2026 13:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795525482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MGLlsaUUSwBgOFasvcC4m8G1HbbNWKywwDMCQ+xfhD8=;
	b=d6hKvlJgG4X7khE+jq9at3VtIrBK87hyEDrBYy47SpMqyBgQyCGtWYEJB2QxO4UP0dEynx
	HjMVntQ+5DCCgsmIa+ciX7ASPhoddYx8/NpY+DyRzyEOwxLhm6r1dhG2ZUHEju5VFoFd3z
	EogkhkBofC6765TNqpTrNAp6xukXKfw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795525482;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MGLlsaUUSwBgOFasvcC4m8G1HbbNWKywwDMCQ+xfhD8=;
	b=o2pbox66290zEHTPTnLGRnEyF5M3kv9q1MZs1eYZssGtRnTpu9DoDG0/d4VS1CplMZajUS
	JEagk2uRr0Os3XDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795525482; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MGLlsaUUSwBgOFasvcC4m8G1HbbNWKywwDMCQ+xfhD8=;
	b=d6hKvlJgG4X7khE+jq9at3VtIrBK87hyEDrBYy47SpMqyBgQyCGtWYEJB2QxO4UP0dEynx
	HjMVntQ+5DCCgsmIa+ciX7ASPhoddYx8/NpY+DyRzyEOwxLhm6r1dhG2ZUHEju5VFoFd3z
	EogkhkBofC6765TNqpTrNAp6xukXKfw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795525482;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MGLlsaUUSwBgOFasvcC4m8G1HbbNWKywwDMCQ+xfhD8=;
	b=o2pbox66290zEHTPTnLGRnEyF5M3kv9q1MZs1eYZssGtRnTpu9DoDG0/d4VS1CplMZajUS
	JEagk2uRr0Os3XDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0DDE913505;
	Tue, 24 Nov 2026 13:04:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0+wrM2iLBWuQKQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 24 Nov 2026 13:04:41 +0000
Date: Tue, 24 Nov 2026 13:04:39 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, Chris Mason <mason@kernel.org>, 
	stable@vger.kernel.org
Subject: Re: [PATCH] mm/vma: drop mm asynchronously in vma_start_read()
Message-ID: <awWLCZ-jBjSD7V3M@pedro-suse.tail5790ac.ts.net>
References: <20261124-vma-read-lock-mmdrop-async-v1-1-257f99f551de@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124-vma-read-lock-mmdrop-async-v1-1-257f99f551de@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 761DD4000C
X-Stat-Signature: gupjm1t78h8xhnfa7dbe98tfjag65iqa
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795525484-37892
X-HE-Meta: U2FsdGVkX1+z1g0UdBMJWTQb+ftuicKaTpGruVhWplCwMx3HSWltLtyJG5ZDXdT2T2heR4rIYbUWMGqgJEIydTAuISnCuF1esHIC/K1MyWR6ZMT20g66hZQIKUGUuoWo1JXUehV8x5TWnRnNi07PCCa11Kn+XgWXDClHn6C6SOHOjg9cH+NERSZ9Mjq/cSvcmpy2a4r5iwb0NJr9zatZDDl23eoevVz3kRWBkPUWp4OPSiNGe6oEeiKUSUyukMJ9FD5TNOmbnASy2teA+EaCA55+HYhKKZrcPomikKA3OLXiVZ0LPwhBV3f4rN56H+ZB5AkRPj0EYQw0pSIppTlze9vx6IoQWw68RAGc5TmIQtDIRTr9IWJGWNcNTTXwLGndMVdAs/1wFVdAWlcgvDfHE02sWv304qJeXsxa00VJZbS0Nvg0ZEbblx8IVKCp7Y8jgxyjSM4rxN+h6QsOphgiMOR6jFWAipXuuMv7bHkVPRH193IIrKEZ5zGEYRVbtpf9SIpm658ApIua/wmUPmcw7UKr/IADfMzqZpGTr3+SWp3HKP3HrhD4qZ5UoDsBjYdxjp8H8r2OyJun6bdlZzBGyridJEu1v+WCNOXR4CZAiSdsk1aks2MBdnJLi0BiItG/Cv0ysS88XU8q7sfaNG4o+L2ZroZHNBbra6TNGN7jFERLpW3PVWpx5YfyCQQFjWAgrISFHZa6VBOxg2Rh7vpgf2e8svGN5QbPMCKoWqK7+fYJY3zMFh/qo9YxiJWTy8thMhPL0nnUpOypJm99OiDUE7+xFxIhNd0m/8YC+2JxvqHl4OEWEkmSBMd3C4kT6sMTLfv11vwJga7OuHtMK/LWEBPV/AuL9uQO9Jh5XGgS15ysIJZkzkDeBiM/gZiO9jUeOXMWt56IJaJMR84j3FUpgEE9Le8KkJoa/Iq7hMEqLQrQCUqSliQ3s3744jtCNnvPve3mzqcGMuMU7dVK3C2
 rMqYX62Q
 pP7qvSOmdNwZD/c3bbAmShTDTwgXeMh86OCyJRtrXCg9iw/Na6Bg1mrB78r5de3IrwXlVJCTzb9wi/OYKLAWMI54a/9GrAHXAWB/3JDcj4BJHLZluLIG9RSwm6pUJLSebf0vLv0Kg4ebH0J7rCTjdmN2k6E6Pkg4osayuzTluQWxQ8rlKpYnRKvKxZPRfcAda/BCGF1giyxVhriNNbrwozobmmVcrlnmGRFTHkqOQ6/FEcv4bYdy4kWJE6Hi9nYGWXWwakhI2wlQxVqIV+29KwUf/L3yey8cPUtciRnqa54mDCgagWTEvAFJexdQ12hF/kHAShXGRfyT7pJyge5zpxDSGl7q9rKxPTo+ZpeXXTCDkt4VMmwoSmeMtRDaLmIiIEKlNztH9Rp4M4KalqTue38Bi3ibNapJJJl0aAl9A3lNVFtIsoth1+arvOvERzzxMXO5PQsVrtTHt/0QASuV+WyyD70SCABruvEwwes2qMV/iLFvsQDC89ql9TYl94nfbHr+ZO+sCfaGLGcApdL7e1AB1PHIpmITiRp+J9COk6ZHr8RbbMp1auXwJ37YpMlLBB2gAvGA/jMwFIgbnVcCLJoIS1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 12:26:19PM +0000, Lorenzo Stoakes (ARM) wrote:
> Commit bee9ef4a40a2 ("bpf: switch task_vma iterator from mmap_lock to
> per-VMA locks") open-codes a lock_next_vma() implementation that does
> roughly the same thing in bpf_iter_task_vma_find_next(), only without
> fallback to an mmap_lock.
> 
> This is because bpf_iter_task_vma_find_next() can be called from
> non-sleepable contexts.
> 
> However, lock_vma_under_rcu() gave no guarantee as to which contexts it is
> safe to be called from, and indeed it turns out this assumption is unsafe.
> 
> Since commit 9bbffee67ffd ("mm: fix a UAF when vma->mm is freed after
> vma->vm_refcnt got dropped"), this call chain is possible on x86:
> 
> lock_vma_under_rcu()
>   -> vma_start_read()
>     -> mmdrop()
>       -> __mmdrop()
>         -> mm_free_pgd()
>           -> pgd_free()
>             -> pgd_dtor()
>               -> spin_lock(&pgd_lock)
> 
> Thus, a plain spin_lock() can occur when lock_vma_under_rcu() is
> called. Since bpf_iter_task_vma_find_next() can be called in softirq
> context, this can deadlock, for example:
> 
> pgd_alloc()
>   -> spin_lock(&pgd_lock)
>     <softirq>
>     bpf_iter_task_vma_next()
>       -> lock_vma_under_rcu()
>         ...
> 	  -> spin_lock(&pgd_lock) [ DEADLOCK ]
> 
> Alexei Starovoitov also pointed out that a BPF program attached to
> trace_contention_end() can similarly cause a deadlock:
> 
>   pgd_alloc()
>     spin_lock(&pgd_lock)
>       queued_spin_lock_slowpath()
>         trace_contention_end()          <- pgd_lock is held
>           tp_btf/contention_end prog
>             bpf_iter_task_vma_next()
>               lock_vma_under_rcu()
>                 vma_start_read()
>                   mmdrop(other_mm)      <- last put takes pgd_lock again
> 
> Resolve the issue by having vma_start_read() use mmdrop_async() instead of
> mmdrop() so the work is deferred to a work queue.
> 
> Make mmdrop_async() an internal mm function, defined in mm/internal.h, to
> avoid abuse elsewhere (kernel/fork.c includes this header, so still retains
> access).
> 
> Commit 0b16f8bed19c ("mm: change vma_start_read() to drop RCU lock on
> failure") accounted for the fact that the RCU lock had to be dropped for
> this operation, which is no longer applicable.
> 
> For the sake of a backported fix, retain this behaviour, however drop the
> RCU lock last and remove the now irrelevant comment.

Is there any particular reason for unlocking the RCU comment last? after the mmdrop_async().

> 
> Reported-by: Chris Mason <mason@kernel.org>
> Fixes: bee9ef4a40a2 ("bpf: switch task_vma iterator from mmap_lock to per-VMA locks")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/all/DN267JUKDRNS.2VMV07CQ58R4X@gmail.com/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

