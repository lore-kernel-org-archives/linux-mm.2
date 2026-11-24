Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E6D1606A329
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 15:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=D90caJjF
Received: by kanga.kvack.org (Postfix)
	id 54B516B078B; Tue, 24 Nov 2026 10:46:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 522F36B078D; Tue, 24 Nov 2026 10:46:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 439FD6B078E; Tue, 24 Nov 2026 10:46:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 20DB66B078B
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 10:46:20 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1544CA8765
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:46:19 +0000 (UTC)
X-FDA: 85470439278.01.5C723EE
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf26.hostedemail.com (Postfix) with ESMTP id 1DD67140007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:46:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=D90caJjF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795535177;
	b=wxACoBeunwKO+vs3TGl2RbZtMoxqh1lJTFBPJKMcqIGkW3MFHFsiO4BtZvCk8umcGkwOgK
	0SKCB2IZqP85J+KPfEMZCDuPkHzsYUnmDlZOCe3ypcqgLTTDgs34IN7BQYCy5HEEjajav3
	ug7+2Rnsz/UAWrXxrnNN27RagMKqLF4=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795535177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SOapY5CEQdlHxqSl9JrLPR3I2czhVi36uOATqS9W/YU=;
	b=uOsWxb71dGIsgQmSuSptsnf+nBGjvxsyHp7bOMXdok7XYnVtZ4jwf3AhMCjVTQ12jkzCSZ
	kYHo5b3coqi8ulCVtTJVrAy7iGqjkUg9eBNTLKd9IrId11qXRGYARTtzMM8plr9eVizmJP
	1Z902kZuKUEfKTs/TZrn4H8KxLoZo28=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=D90caJjF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-54492d8a988so914921cf.0
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:46:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795535176; cv=none;
        d=google.com; s=arc-20260327;
        b=h9jpNWkTso+zT0OMMQMYfxHzH5ljnYMA9g0V9W1KlSimG3VbXbgrbWUdTZCLyUJiCG
         Vxv0o8LkWBxVGV3rbehe1pYHCHu82oi6YV2j0SAJN/1oEgrR0dKwAwWjmq7DxA4qy+bP
         0WN/D9NikIOil5AMldFns/D52XnrG2CkOhm9H6g+8L5+qrdFRrkxMJCExXrzDGaEmJsC
         I3jMcnxH+8FetUhIsZ0PNndG4x4AtXJqZEa+9000DyxLMbBmERiK6YAgEiBHVdl9KXzf
         0RSm7CJtx1r0NWq4V9DsGd9KB02qb4C+66RAN9UUJDVtHBD7YDeM3h1XivM8IbvKUyNQ
         hVqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SOapY5CEQdlHxqSl9JrLPR3I2czhVi36uOATqS9W/YU=;
        fh=WEs+PQ8hvAO3zaCFCXPVKGM6gMrar1mlKtyLck6Wcuo=;
        b=egJMuYcf2xcM5UHaxNiHNX6KvcXDv5Bsz+0SYkIA7HlIJQWNB5LO2qJp/rDqB4ak9b
         0a23xrj+pO15O7rXL+mwBTiK4bLTeWqrV74wCbUpR0lyklGUEhnPgdcV6d5CrWqzYcNF
         bd4B7+PmpK4wfHnb4BZMk3ApMWbIhKtORf+IqTWLqvXGru+xlFXCnhjIwIXb783CAL/h
         roLk1zcKtSkfeCHbAhoZi5i6ApTOrplKe/V1GMf7T3BlorahwpCgSIo4dYiUpNRy1vfj
         MUfBNJNhp9bcgrycbz03TsFZ76ToOJE6kp+5Y3uM5C+4AYW8lEdxmtjUbhnFIQFVbySu
         /vGQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795535176; x=1796139976; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SOapY5CEQdlHxqSl9JrLPR3I2czhVi36uOATqS9W/YU=;
        b=D90caJjFhU35uBAyew6NwBHqBEwC8JDeoGkyml6yBOH4szogmob7cuSc8nQtDeemMM
         1xhx3bmW1r4p023i2rN5dxsVJ5dnIXTUm8VqzGkIwnqf84UCFj+HccwLANIJtWv/hCJS
         +IhzlkL8ZBd6XFNLFsZ8VAogh4muPIIpmAy7Cn9ELVNEpjpblaxxUokiVAJv40tYzzpi
         trWziUGqLAiiv9UghkhG6wEyQSnc5c8dJxlA/JyNr/h2kpEzWwi+bCose2TMxlPBYxXt
         iE5uwY0ul+nnoOqKGHbPtm9VEmpb8HF5JpLJP+zLD3488FIJMDQ0DE1ooKOKPpr6DBm8
         zAxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795535176; x=1796139976;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SOapY5CEQdlHxqSl9JrLPR3I2czhVi36uOATqS9W/YU=;
        b=F9lMmf09CeVaNI1lVHGpkpV6LCrhKVsWy8kClhEbett/Z9jH3ObVGVnKcNrjNl2QGN
         GhgO/TPPQywgyXEI7yoKLU1FPBfgV4No/+oUS63tICA/3P/Cs5qYbOu1kXlvOkQYBqcW
         KWwd98vJKEeBsP0QArhffF8BbGA0Rvt1cMnv7r/pPBjLFwfLIPyS7mVIUC5R9Ru8kxoS
         EY32iRFFjsxRR7cd92OfSq5lNMQLbjtlqzClfJIpTkjiPzjNSoEgw1gBMM46NpiwJ/5g
         /piSG+1Mz4ff26mKfbp2AUcC8ZfyhzoI+D/9wuJA9v0Wf0uLZRnBFnoVKLndimebHdBJ
         tHNA==
X-Forwarded-Encrypted: i=1; AL+hErGmtNPCgJ7mJx/hihnVhV0hpR0dBxjmtOvbjdNcnIGx4Ueu5owM4rJWj4Q6vBRVWiadQlDXZzgXvA==@kvack.org
X-Gm-Message-State: APuU4Z/iyCt31oClmr8bL2YUlilzJ0feVo04LqPmveHOKfnPvKwlNg5Q
	caKDh+ZL8gpEdP175Ai+Q2tcHEjSRDypK0ctPHWqDcoU3bX9aDByjz7wJ+GM4wBV29Rlht2qYyN
	h/PahsCXK1S4RpK5lvF7soUPAt1VS+NI8Rdvd75EK
X-Gm-Gg: AZFdTZeMHrPn46y+zOtZIgKugymPsN64Es5W9Wtyrdyaol/eKd+J6Nn3wl4r0XMjgUL
	KRPciYcyPGrCJDN+uN9zcdLl5DGrbFGXuJx+yjK+qnC20UJgxbghPRdZ6yB7pQcuILpQD0h+/Dt
	ZOsNyj8NoF0OTFLZ5sKCBFzugHoUM8fj+QRnEZMvrGva4w1GOYNTaQ//GyEfmCcQCIpiS/9bx/q
	jqPmcphc9DCBpZBlS3004mQYHtkaZTWcE92EJbnla7ImO6paBE4pfy9YgI6TLPSdLX2ghrCbZch
	wu2dQUkVxw1fU5DkUNo74S2roPVIOWbq1ZMSJknVl4SaR5CPCo6hUxHrarr0JfwFHvzi6e2ggbb
	kpd5hVtsKxi4vw2uCDIMWjesqRlqyuT001rpFFOzWIcbl+FeqZsV3d4rmZPkqJtif/DkuaopwHR
	mfo4MVj2fWlFd2ZD9Mp+00iHrTtq4=
X-Received: by 2002:a05:622a:1dc9:b0:536:353e:8d2a with SMTP id
 d75a77b69052e-55d87fe2e61mr49432961cf.1.1795535175538; Tue, 24 Nov 2026
 07:46:15 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261124-vma-read-lock-mmdrop-async-v1-1-257f99f551de@kernel.org> <awWLCZ-jBjSD7V3M@pedro-suse.tail5790ac.ts.net>
In-Reply-To: <awWLCZ-jBjSD7V3M@pedro-suse.tail5790ac.ts.net>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 24 Nov 2026 07:46:04 -0800
X-Gm-Features: Aa3M54rJps960eQ4ANiw2FEhSY-XIlXfbwKX87yDblku-U5-CQ5DzHJjVlODTLI
Message-ID: <CAJuCfpGk6eYK43Unxo+O4ML5=GM_siZ9owp6oa9fO0ipZXVg-g@mail.gmail.com>
Subject: Re: [PATCH] mm/vma: drop mm asynchronously in vma_start_read()
To: Pedro Falcato <pfalcato@suse.de>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, K Prateek Nayak <kprateek.nayak@amd.com>, 
	Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Jann Horn <jannh@google.com>, 
	Puranjay Mohan <puranjay@kernel.org>, Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
	Chris Mason <mason@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User:
X-Stat-Signature: a9xk7dbdehud7nbztag9hs186df7kihi
X-Rspamd-Queue-Id: 1DD67140007
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795535176-586371
X-HE-Meta: U2FsdGVkX1/4yr6WT4focDYSasdI5kU30bYa9PhC+aGZNmBk1QXx+8NKm2cfK8UY+qQlgJ8dTDK3vOrXUX8r3ip9tfSj/IwuOG2XBHGDBteo1MFzueega83LqUPAy2SiTxozgTIMIbe7n8Ee4YlywXapkDXttPiVdlBQWfT4jMYh6u3ROx3bUmtJ9A2dHlZuVSjGZD2DMyUNdVrjR56B+MRkiN1vADbQFOC9cJLE+rpxpS6m3lpXvHgxMldTFOLzDSOIsGJWYZFkRSnbzS8CDelXVHWx6mxYV43J7SJOz+v2nPmt5+KoRncypCzMbUd/FygsT8JJxNS3LFZ9WObn0CscKZQ7Sulx95YHugXKodVvRoiyDja6c0KgR/m7yMVlAwKdK35P6hw+8NgakX8Q8WSapMZlDgTHLmDIbp97Ei5zhtRDZ8AZ+QSKgGGEvZx5/4a2nXXHrZcSct/iGXqja3J2fpr/Fnu1xOvRs7j2kaWnXbWljMhLdVHiQYZxdcDmeVzpncZNr2LI/SkO3qkGbCSBlT8Ed2uvrEgOdDE+RD0ayikBYjxAiee3rhbehagbHRfhzsyn+fKqC+QG1Pr/ID6juydOPicUB3FNHdFPsX9a23dVA9KWMkquF1OL9tgDh5mAmDndrBS8jRkrWqZaQZ6ZpOf1QbqxAq1tCnYEH5PPUA0zILDcQTnkPI78i/u/ltuN1lGf2UsxKjlhxqKG7Tk+Xl9Kp3nMn7pmt88pgigWJdN/fRAXbyYzdN8/JwBmuj5TFqCgUXW8F8RpNJxNVMx2FNatGFrnjW1c4FiGuwtuVteB07RZk+psogqJ9DEiT+esSjCW99QdMbk1PzzfH/qUCfiAoVzvWqdWA3T+NatxoqH4Q4n6L/r5E2lXDKHk39fdvpwoitN2lFMbGE+hY/pEP0DrB9A52ptw23bi7i4RXmn6FXQTYzQUvRrCN5On/IouLPkOvyvRb5y1NuI
 QhTL6ayU
 7T5KK3jmP2x5SW2jrtGZazQLeRIv0SPu+/o254Q4dnbW2QnS2Ncgm2auJIkBZq4yeguQQ9MzVRFd3RQD+ZJUjK6+s5eAoI6/PzLgKTAdiWhfZ00OAZQGnbS20neR1AQUkDDVpUmFfFMGdAiHz/8fHOimDRJ7Bk/LtBAjjKmGNJI1cZwGJsoFRjOOcnz6yPaK1oJVQkhrEhuZHtO0++TQ+MC3vip8v7viwA5ZwLj2h5OA0yHvNWBDHPiewiBwGnIpVC9DxHhkNBOewVcuFYJOOF78SbqQk4szSC9GU/F8VhlVXt5TjYCDTUD3YmYSZZihJ3GbXPLJq8JJhzin0tACXFIDVDVIGQrNHxM9LGoq9h86LP3QNBtEkgFMh64eJ+Igh5vfgLwNAywvmqSu6njSB6xhFfWIWD/1YA/efzYkizXDpDXOLaiMc9N1x/5AXEA0UKGrnFDrlqudNi0JPHRDYXAkoXt/npGKBDwivb5Hkwbk8hH4pdbP6qNGqj5THkrUnkUcYdLB2FgBBKEO7U0maTR05G5wLPAmpA3smKrcguiPbP2D9yCJyS1P6H5K9vmz4acwOtaD/WDHdrp8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 5:04=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> On Tue, Nov 24, 2026 at 12:26:19PM +0000, Lorenzo Stoakes (ARM) wrote:
> > Commit bee9ef4a40a2 ("bpf: switch task_vma iterator from mmap_lock to
> > per-VMA locks") open-codes a lock_next_vma() implementation that does
> > roughly the same thing in bpf_iter_task_vma_find_next(), only without
> > fallback to an mmap_lock.
> >
> > This is because bpf_iter_task_vma_find_next() can be called from
> > non-sleepable contexts.
> >
> > However, lock_vma_under_rcu() gave no guarantee as to which contexts it=
 is
> > safe to be called from, and indeed it turns out this assumption is unsa=
fe.
> >
> > Since commit 9bbffee67ffd ("mm: fix a UAF when vma->mm is freed after
> > vma->vm_refcnt got dropped"), this call chain is possible on x86:
> >
> > lock_vma_under_rcu()
> >   -> vma_start_read()
> >     -> mmdrop()
> >       -> __mmdrop()
> >         -> mm_free_pgd()
> >           -> pgd_free()
> >             -> pgd_dtor()
> >               -> spin_lock(&pgd_lock)
> >
> > Thus, a plain spin_lock() can occur when lock_vma_under_rcu() is
> > called. Since bpf_iter_task_vma_find_next() can be called in softirq
> > context, this can deadlock, for example:
> >
> > pgd_alloc()
> >   -> spin_lock(&pgd_lock)
> >     <softirq>
> >     bpf_iter_task_vma_next()
> >       -> lock_vma_under_rcu()
> >         ...
> >         -> spin_lock(&pgd_lock) [ DEADLOCK ]
> >
> > Alexei Starovoitov also pointed out that a BPF program attached to
> > trace_contention_end() can similarly cause a deadlock:
> >
> >   pgd_alloc()
> >     spin_lock(&pgd_lock)
> >       queued_spin_lock_slowpath()
> >         trace_contention_end()          <- pgd_lock is held
> >           tp_btf/contention_end prog
> >             bpf_iter_task_vma_next()
> >               lock_vma_under_rcu()
> >                 vma_start_read()
> >                   mmdrop(other_mm)      <- last put takes pgd_lock agai=
n
> >
> > Resolve the issue by having vma_start_read() use mmdrop_async() instead=
 of
> > mmdrop() so the work is deferred to a work queue.
> >
> > Make mmdrop_async() an internal mm function, defined in mm/internal.h, =
to
> > avoid abuse elsewhere (kernel/fork.c includes this header, so still ret=
ains
> > access).
> >
> > Commit 0b16f8bed19c ("mm: change vma_start_read() to drop RCU lock on
> > failure") accounted for the fact that the RCU lock had to be dropped fo=
r
> > this operation, which is no longer applicable.
> >
> > For the sake of a backported fix, retain this behaviour, however drop t=
he
> > RCU lock last and remove the now irrelevant comment.
>
> Is there any particular reason for unlocking the RCU comment last? after =
the mmdrop_async().

Yeah, I think moving the RCU unlocking was unnecessary (unlock as soon
as possible is in general advisable) and we could just remove the
comment. Both versions however seem correct to me.

>
> >
> > Reported-by: Chris Mason <mason@kernel.org>
> > Fixes: bee9ef4a40a2 ("bpf: switch task_vma iterator from mmap_lock to p=
er-VMA locks")
> > Cc: stable@vger.kernel.org
> > Link: https://lore.kernel.org/all/DN267JUKDRNS.2VMV07CQ58R4X@gmail.com/
> > Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> Acked-by: Pedro Falcato <pfalcato@suse.de>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

>
> --
> Pedro

