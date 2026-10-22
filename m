Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3BF3606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 05:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K6KQnHc+
Received: by kanga.kvack.org (Postfix)
	id 28F9B6B028F; Thu, 22 Oct 2026 01:29:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 240CB6B0880; Thu, 22 Oct 2026 01:29:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 158756B0882; Thu, 22 Oct 2026 01:29:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DFFBA6B028F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 01:29:23 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7615FA073A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 05:29:23 +0000 (UTC)
X-FDA: 85349134206.11.7317F5D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id DEE5DC0003
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 05:29:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K6KQnHc+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792646961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/hFUlGsMyUlBLXXlLd7/S9ppRDXnIafqCfycbOzgc+Y=;
	b=6TfPg2VW02e51VI/aq5oZgicj7uTGCruiHe1itUKtHvZqbt3BhkfTI7fXXV150hNgCn/QB
	GA8iR4sN9R+SPFudyIsD1wmRuJ9C1E2OTQvE1OBGMBomRCmq0Pw1i9wC+hN710mQJhQSLw
	p9VKccN7J/OK2P++lOamllWCiDaeKRE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K6KQnHc+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792646961;
	b=NTxOwCJ9x1Y3gouu7IEuzUCAlAUa/yvx06N8JCFaBststUbd4Gn0ERN6io8o1JyWb85r+5
	vNj97qz6TE727CXyafmZEFLnfrtZLeMdP2I9WefrCXn9dowbieH9ShkaBe0lwUEK1n8wPp
	WACx0UcMp8+qc9EFDyD7uc7mZP8ZG3E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 22C1360A5A;
	Thu, 22 Oct 2026 05:29:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 825B01F000C1;
	Thu, 22 Oct 2026 05:29:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792646960;
	bh=/hFUlGsMyUlBLXXlLd7/S9ppRDXnIafqCfycbOzgc+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6KQnHc+j+2ytbnpP3BCpXMW0mem31ef/x/HuaNJ3QhPluqjx4uFGEfpAZ4kCzqjH
	 QMi3jnTvuQxXD2PuJrDsbK8o/5DJpWXMoVsIjH+Ymg3kHHh8TTm+NQCvoc2y1NYKFT
	 F++/Z6+nUOEMyhJrN/ldX1hC4SNBNZ1sCHnhRzc+eIlv9UkLfMUrktGDVcxo/nW+6z
	 U/+y32p/QeFBiMWg2YDmq2Uj2O9/zvf/U6/QCJN+//05dsW5pocz2paWMZO3DqItqg
	 +Ex9D25m3TnYPdwzbA0G2aZ8joae2wQoX5MvaH1DN1l0FpYJ+1QJHOuhQF+cVB8pB1
	 R+JpwFNV0gUbw==
From: SJ Park <sj@kernel.org>
To: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	corbet@lwn.net,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rdunlap@infradead.org,
	skhan@linuxfoundation.org
Subject: Re: [RFC PATCH v0] Docs/mm/damon/design: document data attributes report infra design (beyond page table accessed-bit milestone 2)
Date: Wed, 21 Oct 2026 22:29:12 -0700
Message-ID: <20261022052913.90437-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261022041724.2712-1-ravis.opensrc@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DEE5DC0003
X-Rspam-User: 
X-Stat-Signature: f46z9uy6qzqims3da8dfo6mcoc1dbww7
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792646961-292587
X-HE-Meta: U2FsdGVkX19ysg/IGYViSE43y+HfAR8OTK9g5toG19UFiOVgcd7cghgupcDbx41EgR0ZE2ACm+jGUT+55Bm9Qeo9xCVJppSGDyzGIPy7UD4yaLAxPnz3cJHonwS47KhKoeyFG9z7b6JJE/VFtarVL1GT5zSXsjX5yJjV14PFwsqv3/Fl2uu8wtYPmDiYyGlMQR82SODnBwv85N5Vu/5xve+ynKYgV5jWj75R6Bn45feAHwD7l+R6ODXkwB7R28GmD0srl8IW4vtt4RBwdAz/spn22x5s1vODDCxGjcthSv47unaQRI1WfyfaZ7Ymk8osyXLW5+bENI8ug1ehisXhe23Q0bHT1AQjpxSf1UG94p6xs9PxaFuimP1NwHZ0ndSUoLRIV+Joht7oYMcBLWinbUfdli0DRhPUAQUaIroo+vj2PujkkxXvrXjwxjrHWmmzYBu5AkBEunLv1rN5HMRN8aHK+X+eGkjFbrQ0mqo7FI1V2TDB9ucCYYt17jGfgmckx6a2Afsu5UrjP9VefyfyYHvHO3N4/KQ4jRZ5peB+k+7pmJKTEzzCywwsWW49SMEvOD/mjcb+v+f5nMqqe1SOA3nBrNgrTY7X3uE78sQ2o9Dg1nGZWlheK5Qxukrz/JlNB0Kd7unbk20qREv9V6ldfElQzmp0F+W/7Agu8UPOVINvzGOjT7poopofZ2Bf1rxUgW3mV+AHzljiJGOn1QD58yETEPBFvydFO0CAcybO6hcUvsrYEuIS3QhGXohBG1vs1LM2csL3BJYGINohafg72IGBdQfXzagkfbsdKlad3yVah8GOoQSkzqnn1y9Hr6rORRzb0mi49uruY8kiLb5SwgWBM8N65E91z8LIVGxEA7zLn15Db87qgPscTFa/hQ/BoKnXc0lSTO1VP2v9ODjbbRw1f3Z98oqMV+2FLzLvsbMELtaGxD4clq+tGwh9OfhS3I2xmdQNiIezUOrGZ2r
 N2of8TLQ
 0P/84MTKfROr4lVYydWsv/1oZra4OWf+loAtqum5On5YpA9zrkHEwCcNMMDTi4x33ojC5J98VafapXK/Mlgkp/mezIAqOsVT1vqiQ9w2IrLs+d8aSyPrWBewozrZl6Bztu3M7lz8o5WBzdREJiDO+xTOzN+do80yBKVocudPsBGYX4oyMef3eLCkZXDABR21MigAsHA/iJk4y3wWE/hOEdUV2wO5oH98mTTmLx34/64SZwqisMWUKu3yoNtOT1YGqNgGIcsD0XbPqvEKXrZWDJbgKQ67s46ovty1QJcE0WWcIyTPbuy2HBQ0m/emdSoML4M9QkGPopfJfOkk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Ravi,

On Wed, 21 Oct 2026 21:17:24 -0700 Ravi Jonnalagadda <ravis.opensrc@gmail.com> wrote:

> Hi SJ,
> 
> Thank you for sharing the design early.  Short version: the design makes
> sense to me, with one main suggestion.  The first report type should use
> the data address the PMU captures at sample time, rather than decode the
> instruction later in kdamond.  The measurements behind it are in my
> reply to your answer to sashiko.

Thank you for your detailed review and testing of the first design!  I'd still
like to try decoding idea first, mainly for quick prototyping.

> 
> On Sat, 17 Oct 2026 12:57:45 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > Does the idea for perf CPU cycle sampling based access monitoring makes
> > sense?
> 
> On AMD, yes, with precise_ip (cpu-cycles:p routes to IBS Op): its
> memory-op samples carry a data address and load/store type.  On Intel,
> even precise cycles samples (cycles:pp) carry no data address; PEBS
> memory events do.  Decode from saved registers worked for one of two
> test loops on Intel and for neither on AMD (details in the other reply),
> hence the suggestion above.

My current understanding of perf event is not good enough to deeply understand
those.  I will start with full registers capture-decode option and revisit
this.

> 
> > Does the design provides clear idea about how it can be extended for the
> > future extensions that already scoped for milestone 3 (AMD IBS, Intel
> > PEBS, Arm SPE)?
> 
> Yes, if the report has an address field with a validity bit and carries
> the producing report-type (attr) id.  Then IBS, PEBS, Arm SPE (through
> an adapter, since SPE uses the perf AUX buffer) and device-side
> monitors all produce the same report, into the same queues and probes.

Thank you for confirming.  And yes, I think we can add more (union) fields to
the report structure.

However, could you further clarify what are the validity bit and attr id, and
why those are needed?  I'm still newbie to perf event, please bear in mind with
me.

> 
> > For the foreseeable extensions (AMD IBS, Intel PEBS, Arm SPE), would the
> > required change minimum and maintainable?
> 
> Yes, if staged.  The sample-filter matcher and its sysfs already exist
> per context; attaching them per probe is the main change.  For example:
> 
>   M2.1  in-kernel only: damon_report_attrs(), the queue, region
>         lookup, the perf producer; kunit, no new sysfs
>   M2.2  your per-CPU write-only example, set up from user space:
>         attr_reports files, per-filter report_queue,
>         write/cpumask/threads probe filters
>   M2.3  counters, a silence check (tracepoint/debugfs first), tuning
>   M3    more producers: Arm SPE, device monitors
> 
> Implementation notes:
> 
> 1. One sampler per CPU per attr, owned by attr_reports (as in your
>    damon/next usage doc)

The things in damon/next are just my sketches that are not yet ready for
review.  It will nearly all be re-written.  I'd recommend to ignore those for
now.

>    and shared by all contexts.  IBS has one unit
>    per CPU, so perf time-slices multiple events: on EPYC 9555P one
>    ibs_op event got 67,140 samples; two on the same CPU got
>    33,547 + 33,535.  On Intel the event also needs wakeup_events = 1,
>    or an in-kernel handler sees only the last record of each
>    large-PEBS batch.
> 
> 2. A lockless queue, as your NOTE in damon_report_access() anticipates.
>    Today's buffer is documented "May sleep" and uses mutex_trylock(),
>    which interrupt context cannot use; its inclusive jiffy staleness
>    check can also count one report in up to three intervals (HZ=250,
>    5 ms interval).  A simple design: a per-CPU circular array with a
>    write counter and a per-slot seqcount_t (using
>    raw_write_seqcount_begin/end() for NMI safety), overwriting the
>    oldest slot.  Readers never consume; each context keeps its
>    last-seen write counter per CPU.  A nested writer (e.g. an NMI over
>    a task-context write) drops its report and counts it.

I agree the queue shouldn't sleep.  You can ignore those in damon/next.
Nonetheless, I'd like to start from global queue rather than per-CPU queue.  If
the performance is concern, we can later consider optimization.  Let me know if
I'm missing something.

> 
> 3. Report fields: paddr, vaddr, size, time, cpu, tid, tgid, the
>    producer's attr id, and flags (is_write, plus a validity bit per
>    address, since 0 is a valid paddr).  Store global ids; translate
>    namespaces at the filter.

Yes, this kind of information will be added.  Some of those could be union.
And we could extend the fields as needed.

> 
> 4. Binary search over a sorted region snapshot (your todo in
>    kdamond_apply_access_report()) beats a linear walk from about 2
>    reports per interval for 1,000 regions (a model, to be measured).

Yes, this efficient region-report matching would be important.  We could also
consider starting with linear walk and later optimize, though.

> 
> 5. Samplers can stop silently: in a report on the v4 thread [1], IBS
>    Op samples stopped after about 10 minutes on a Ryzen 5 5600H, but
>    not with the NMI watchdog enabled.  So count dropped reports and
>    check for silence against an independent reference.  For tuning,
>    step sample_period rather than use frequency mode, and do not raise
>    perf_event_max_sample_rate: on an early DAMON PEBS prototype (Xeon
>    6960P), perf cut it from 100000 to 10000 in about 20 seconds.

Unfortunately my understanding of perf event is not yet good enough to
understand this in depth.  I will revisit this after starting implementation.

> 
> Three decisions would unblock M2.1:
> 
>   - The first report type: the PMU-captured address (suggested), or
>     decode from saved registers in kdamond (your current plan).

I'd like to start from decoding option.  It will be easier to test on my setup
and therefore I will be able to share first prototype earlier.  Also, there are
users who cannot use address-capturing PMUs.  For example, some users need to
run DAMON inside virtual machines that might not support virtual PMUs.

>   - Whether the report carries the producer's attr id (suggested: yes).

We can add any field if needed.  I'm not very sure what attr id is and why
needed, though, as I asked above.

>   - The queue: the per-CPU seqcount design in note 2 (suggested), or
>     ftrace's ring buffer with one iterator per reader.

My current plan is to use DAMON's original simple lockless and global queue per
report queue.  Let me know if the report queue design is not clearly explaining
what it would look like, or there is a clear problem.

> 
> One question on the ABI: the usage document in your damon/next tree adds
> a report_queue file under each probe filter.  Is it meant as "this
> filter tests reports in queue N"?

Please simply ignore those in damon/next for now.  Those are not meant to be
reviewed.  I am still redesigning the interface.  The high level design in the
initial mail of this thread is still unchanged, though.  Feel free to ask
questions if any of the design is unclear or concerning.

> 
> Happy to write, review or test any piece: the queue with kunit, the
> AMD/Intel perf producer, a decode-accuracy study on real workloads, or
> runs on Xeon 6960P and EPYC 9555P.  Several exist in RFC v4 [2].

As soon as this design discussion is completed, I will start prototype
implementation and share it as the next RFC version, as soon as possible.  Your
review and test of the version will be super helpful.  I may also ask you some
questions for perf event and your prototypes.  Thanks in advance for your help.

There are competing works, though.  It would take time.  I expect about one
month at minimum.  It might take longer; Thanksgiving holidays could be helpful
to give me a time to concentrate.  Please bear in mind.  But once the initial
prototype is implemented, I believe we could quickly iterate and meet the ETA
(LSFMMBPF'27).

> 
> Thanks,
> Ravi
> 
> [1] https://lore.kernel.org/r/20261017211613.16456-2-aethernet65535@gmail.com
> [2] https://lore.kernel.org/r/20261005-damon-perf-rfc-v3-send-2026-10-03-v4-0-b03452e137f3@gmail.com


Thanks,
SJ

