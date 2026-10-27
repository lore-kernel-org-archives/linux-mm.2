Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DA40606A321
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 17:46:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iQgMSjck
Received: by kanga.kvack.org (Postfix)
	id 2B4496B0877; Tue, 27 Oct 2026 13:46:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28B906B0879; Tue, 27 Oct 2026 13:46:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A20B6B087A; Tue, 27 Oct 2026 13:46:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFCED6B0877
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:46:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E9AC7A8540
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:46:23 +0000 (UTC)
X-FDA: 85369135446.28.EEB4AAE
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf10.hostedemail.com (Postfix) with ESMTP id 0C4A0C0002
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 17:46:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=iQgMSjck;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793123182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zJVDlsrsrfYz550OKB/3hdZdazvfDU9t83gGSE4oBec=;
	b=DWKUhF8JREq3PQGFmbSTyj0BNq9VG2kOdFS4rD/b7Kaqz7LyxLGcaqLaffkQIfe4oOEFz6
	hsEoEc2eg8r+ZzwMV3FOdKRuX5IN1K1fp+obBThCcQEPtglxwTYslGiRN1lIEGLtye/4Bv
	9X6H3U59tPtujsZSnRJ+oZ42A9pKcyc=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=iQgMSjck;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793123182;
	b=4COTr15dS7rJD5kKQn7DGmPehHZTcFpRVPXW6Zy0LF9vH/zJsghJ7U5gQr+Ni82UJcY/n+
	yjgEaisZR9EK6M9bdw2F56Tf+deN+nUYS9v0ghPiLDtLH7hVJEFZqeoLYX6NhojB/y3Hhj
	ipatc8R2ZmPW8irw70lhEeXsOisHn0w=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c445c95d553so13192366b.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:46:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793123180; cv=none;
        d=google.com; s=arc-20260327;
        b=mOK7fmqYc42rOUtlSgqYJApGwhoAMJ9FISnr3pRiSXgdXpKMQjammwvTI72EC047Aj
         RKLXUe5m6XUNI2WOipBn9DgWTtMynrvTHMPv9eD67G8QqiGjOERqJQgOdcfrG2DlSOfX
         0aI829jGNFYl5vn87Qq84IPy0wU3R4JdzniyduTTs+RzJEoncRRq/khRuQPhUN9cHE6T
         icp3hksbAtGlM1KToSQstiwNlQcpw5Nu7SwryLXZXCKElwkFZVdqtkvDEppp9OtP0HPg
         9V+KJiCiQxMKf+VxQ64gjsNTQa5pOwcsJCtctlblW1ky3/suLCGu7n4rMz82H/3CMUhz
         v7VA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zJVDlsrsrfYz550OKB/3hdZdazvfDU9t83gGSE4oBec=;
        fh=QkyIlIEhXU/1AQJxy+PKu1paadYUv3PvJ34Ezk9ZAEU=;
        b=kEqGe+dj/VPoCIe4taua1GF2gfTZTbmGRzsYKaFgkr8oIN7zFgA18bPEcYarh+HA74
         dL1p9aIug+BPtGP/cydpSZtLQ+M2fdXkWVJeUlxA012s+P4jRgSD74pffnvvSkz77/Hz
         twsA9M9YI215Mtref4jlmsuCXvDMV1uEyihV2Wu3QO1eq6sJlh8qD57Dmb8KKg+TydCW
         RKc8QbUwQBlW/cpk/JAY999okVkBv7XbLqSE7E3fKVrGTbHnDRM1Krnn1bGKVBwr2K5d
         4j6A6TeVurFm7AvOjiC7mFQ0trp1RXRznC0g9bqEmRhmqblAQtjR3qIZsW5SKZDmiqM/
         NY6w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793123180; x=1793727980; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zJVDlsrsrfYz550OKB/3hdZdazvfDU9t83gGSE4oBec=;
        b=iQgMSjck8tTf5jySWrpmtvd6mKpvnBbkOz0t/dewIPoTaNEt/jMm1YAQwwT43QgXbh
         pZuM+I/VJnP+Gua+FP9NEwJJEhgP2JjeoweCd4/Hg5NpIbZVaThAKOjhIM0Gw46E6Aby
         Q+E4KAJjhUYgOXn0OIRnl2ZCrofw8NoLlKyQeCHb+quoPqi1dBzqhirai8AeHkfVFfd/
         7YtFYzHW/4HdorAEgbOVknrkaPJfL5vw8tl53Liugppa1i+HG6mgcWRMK1PRi7ELPY5r
         jw7n/8oHwWyS5PHBvGkTb/NxpQx0OEsTUKqjNjJGY0HRKGEm5tIUB4a+iFXZy0MYIobo
         gUfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793123180; x=1793727980;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zJVDlsrsrfYz550OKB/3hdZdazvfDU9t83gGSE4oBec=;
        b=iIn96bJoKav4xF1qb+GOpoI4ZBvh/bfhZJg/AnKjzfEiSX95jsSYMzPM4MRcxjeXO9
         20pWDWoy/3gorqKCYk25J191JTo+Bf1YxXLygr5Y2GcPolIHlNxd6G1n4agiAQS8pc0/
         gjcztFPYzYGdM3MQTTx5Dx8Qaoqy1dXPE9hq9hCMWbZDRB/dFwvqu2uA5m6EjR85iYes
         8ygYjdHbm40mwcJEHlRA+JE1NqRXtzt/xxc2OTSGletLAzo/4PmmhL/czbAunGZHmcKN
         SQwgTfAyz2GVL8M1Z63stSnyrwocd74uHznzIisDmW9L029DJiA+sQV/S3M8BhvKptlj
         HrZQ==
X-Forwarded-Encrypted: i=1; AKwUvBwbymaD1xUEqfQT0mIGIZQA0Q+yrhKKjxBaa3VEfQ0k6xei5KykFYSzVLOPrjuO5wXeGVtfdc3eWg==@kvack.org
X-Gm-Message-State: AFq9FYLASjem+TA9z2BmxrzWIjC/fO/cg9FSy246Y5SCaymf3YoPt85w
	61nZTOOIkLyjn5qL87oLLsrBlKTLjDRRu7aDETq9EHhdA98yQhBPY36pceWdftkVFnKbRUqOtQP
	jpvgeeYXeIJQdsDjm+8NkfBhWQUX5MF1G9LBHA1m9
X-Gm-Gg: AYBFou3lrdhNPZ+sVZ6ZJSMqIyUhVQhGmzQEzW32sMA+rIVM644NiKnqALp1QBCO8Es
	HNXL5lF2QDjf57DmkDOG3F4lcuDZWRxLx6WkCe1xTQdcxQ7EsWPlfg0lqhDFhPSNxNKHIaB57u5
	H+O6b1Ihm7gdIhjmKJ+sErRHCDzKuLnpqY0RzgUsbNKnTQvZhY0lGeKqSwbjDYI5SVxUktg2PZs
	m+oaSvedeqF/hc4CE+Fwb1Jhc3gDY1zgWzzo5k/fEE91McnEXn1UstF3t5ooQ3wGpjq8tdeyy5v
	ZPbC1xpvlVjtz7oZkzTChySvmrtVZis/ApHfkrayPgZf1IvR1IZ0ZuTjdGN7MgpjBqCaJGW4ihD
	x3uHaG/5vwHK7CZtJIpBTS1vzuph8l/uY2bf47eev7kJVSR5zaavJVlliiVSmxluLXMpdx+Khuk
	/A2fpCsZ69jGby5pPs9dyttA4dyBH2q29gDFG5xiE7uhkaft0TytgfzzvI8bgQY2Sb2XUQMiYwl
	ga+3j0gFLOOImrZdFlZK2HkCcwPEQxuPg==
X-Received: by 2002:a17:907:7b9e:b0:c41:b94c:4538 with SMTP id
 a640c23a62f3a-c46bdec03f8mr1197886866b.47.1793123179946; Tue, 27 Oct 2026
 10:46:19 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261026215226.3713941-1-jthoughton@google.com>
 <20261026215226.3713941-6-jthoughton@google.com> <20261027110948.GI2668564@noisy.programming.kicks-ass.net>
In-Reply-To: <20261027110948.GI2668564@noisy.programming.kicks-ass.net>
From: James Houghton <jthoughton@google.com>
Date: Tue, 27 Oct 2026 10:45:43 -0700
X-Gm-Features: AclHuK-GDZyG6m8BFpUMWxfSIBXFJlvlZbCjTm5c1oLpEFzow0OEe9cdwDWWw7s
Message-ID: <CADrL8HXtBxf=qixBZV5-iz1sqfZAqSrMR4ZsJTFXS0N84G+nkw@mail.gmail.com>
Subject: Re: [RFC PATCH 05/10] perf/core: Don't unwind the user stack without
 an mm
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Thomas Gleixner <tglx@kernel.org>, Kees Cook <kees@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jim Mattson <jmattson@google.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <mkp@kernel.org>, David Sterba <dsterba@suse.com>, Chris Mason <mason@kernel.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	John Fastabend <john.fastabend@gmail.com>, Josh Poimboeuf <jpoimboe@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-scsi@vger.kernel.org, linux-btrfs@vger.kernel.org, bpf@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0C4A0C0002
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 9bm1bqghxmcuxcgr7k9i1bgfema4jnq5
X-HE-Tag: 1793123181-916263
X-HE-Meta: U2FsdGVkX18p7UclSaYtSlrqZ83UIS/fjb9wg8Zp+z3rG9/P/OzTRprITpM9wqc3O6ZQrATlMei2a624uQBT4fQR4EH+YwOpu392hX2ZEmUomzN2EVmPH0OkeRX1vGK+CtfYJeIRG4s7LG/6+2goPUnpOPaLBxvlWoNtxHD4HSlXx+XRW7zc+AhU/xN5rVhPYMo/cB3R9onYD3vSDJUbTzFXmJQgh1yvBKo1S6AzVKZu5Ka47eyxNYHMW6JEBYryqDNQtSucSCAQtik+EKYlAukCCrOt/OrL55OFFcSgh5SOmnDY+g18bCx+eDZYgYJ+gVoVu6UaQYc5pBlb6dwh4BzuKyVQFylGFjYwBG8jweC/he7JVgGBAugqOXdEgpz6INRrPiR3dbNpiOszLB3gs2CNmzDt2ksSWg5nF6e09uLvoJwOYulPFG21x04RlMkLK8Ki09cMl9dukrk0Fcqj/3juGjEB9PJQIntbydUUFrjMuUMXFy4TEkVxFUVNF/WUOVsqB2wMo1DjX2sPP6jhqbERFMJ1rUyrYLpG9kUSpbirOEpVtiMU2HfwUNALbbOvM+gsIbR8BBVoaAxQS62sQsjbLA66YAdUb50eXVT6BKIA3jS/W+9c/qX+Hn8RHK65WlXZZjn+au1StGhR7POza7ayVCu/Odk5Ybc3IOGyR2sAVy/yPKW5Z/R32blxPxDVCLPAk2VsAVKhxtLKL7en2TvicCZmphug1awkhk4mWD63sL1c0oolu8lT7FtjfGYJ24+GhpdHGC/sLQkoel00yPHF4o8YwSUixeyZf0KEp439Lizn49IxjHjNLaV+E7P2po2nSz5V/eptBfz+h8c7nSPGmkjGW0LWJk/JaCxOiIMSURwoi1QSeDN38ywjZFmDxG+UmThCpUQrB4+XQ1az3OPNGuGE1ehRuFplNf5VH/eIvyqym9uXoOhzFmOnNOCO4aWE5c0/tzUOwlH/Jnn
 OcrAA1En
 BnRvO544+DOGO0H2v2yttKMzfrwotCQjS7oNgAQFKw/J2asI4fhUgADAaWWGitYwudVIqnGd+ty/5yLhFp76v3WeAZhyOamrj9Z9Rn1HkXKzzOLbnlCLAqnq7UpVKq7mmxHFE9YIVY1oG3gd0aFPOfR4T2Cn4RUypQ/ljQzCnSOqTwL9eFtcVm/ygh//v5QV/z0lbdyNUPUmUGo/UuFlgrSN+GrYt3MvNnlwsgLteWqnmUrWdOeC1YggUcwIRTYcV4v0NT8BhoDQrYWSQhv0EnIyhdjgsf9O15BjGalffvXJBvFYqzuTzJ1tNq0HiKJx6XOew7exSvoj9OtzcDQCpehSxGm/xxCc7KTdqRBAZqOuSXzI5B4ykKEZLOEBRC8RXOCpq2vpE/h2hYgo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 4:09=E2=80=AFAM Peter Zijlstra <peterz@infradead.or=
g> wrote:
>
> On Mon, Oct 26, 2026 at 09:52:21PM +0000, James Houghton wrote:
> > get_perf_callchain() only checks is_user_task(current) when the regs it
> > is given aren't user mode regs. However, BPF's bpf_get_task_stack() (an=
d
> > bpf_get_task_stack_sleepable()) pass task_pt_regs(current) when called =
on
> > the current task, which are user mode regs for a user task, even if tha=
t
> > task has already gone through exit_mm(), e.g. when called from a progra=
m
> > attached to exit_files() or to the dying task's final sched_switch.
> >
> > perf_callchain_user() then unwinds the user stack without an mm. That
> > access does not reliably fail: the user half of the address space
> > belongs to whatever mm happens to be lazily loaded, if any, so the
> > unwinder may read another task's memory. This affects e.g. arm64,
> > riscv, loongarch and csky, whose perf_callchain_user() doesn't check
> > current->mm itself. perf events themselves are not affected, as
> > perf_callchain() already clears the user callchain request when
> > current is not a user task with an mm.
> >
> > Check is_user_task(current) regardless of the regs' mode.
> >
> > Fixes: fa28dcb82a38 ("bpf: Introduce helper bpf_get_task_stack()")
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> >  kernel/events/callchain.c | 12 ++++++++----
> >  1 file changed, 8 insertions(+), 4 deletions(-)
> >
> > diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
> > index 9d24b6e0c91f..a451ca2a5573 100644
> > --- a/kernel/events/callchain.c
> > +++ b/kernel/events/callchain.c
> > @@ -245,11 +245,15 @@ get_perf_callchain(struct pt_regs *regs, bool ker=
nel, bool user,
> >       }
> >
> >       if (user && !crosstask) {
> > -             if (!user_mode(regs)) {
> > -                     if (!is_user_task(current))
> > -                             goto exit_put;
> > +             /*
> > +              * Even if @regs are user mode regs, e.g. task_pt_regs(cu=
rrent)
> > +              * passed in by bpf_get_task_stack(), current may already=
 have
> > +              * gone through exit_mm().
> > +              */
> > +             if (!is_user_task(current))
> > +                     goto exit_put;
> > +             if (!user_mode(regs))
> >                       regs =3D task_pt_regs(current);
> > -             }
> >
> >               if (defer_cookie) {
> >                       /*
>
> We have perf_event_exit_task() before exit_mm().
>
> Still, it doesn't hurt to be cautious. So no real objection, but perhaps
> adjust the Changelog?

Right, perf events can't get here, since perf_event_exit_task() runs
before exit_mm() (and CPU-wide events go through perf_callchain()'s
is_user_task() check).

The case this fixes is BPF: bpf_get_task_stack() calls
get_perf_callchain() directly with task_pt_regs(current), so a program
attached to e.g. exit_files() or the task's final sched_switch would
unwind the user stack without an mm.

I've added this paragraph to the start of the changelog to make it a
little clearer that the perf event case isn't the interesting one:

  get_perf_callchain() only checks is_user_task(current) when the regs it
  is given aren't user mode regs. That's fine for perf events: a task's
  own events are torn down by perf_event_exit_task() before exit_mm(), and
  samples from CPU-wide events go through perf_callchain(), which already
  skips the user callchain if current isn't a user task with an mm.

Are you happy with that?

Thanks for the feedback. :)

