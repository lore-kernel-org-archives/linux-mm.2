Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 279A1109448A
	for <linux-mm@archiver.kernel.org>; Sat, 21 Mar 2026 17:40:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6378B6B00E5; Sat, 21 Mar 2026 13:40:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E8696B00E7; Sat, 21 Mar 2026 13:40:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FDF46B00E8; Sat, 21 Mar 2026 13:40:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 411166B00E5
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 13:40:08 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA665C2139
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:40:07 +0000 (UTC)
X-FDA: 84570783654.24.987F39B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 32AAB4000A
	for <linux-mm@kvack.org>; Sat, 21 Mar 2026 17:40:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bk8epan4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774114806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/8DxthbFiW4fMHp0rB6T69R3gkQb4csFQqxMgwWFOYw=;
	b=aDrqPjxJVHvtK1MEgMdqr2rUSONhOEqILyjgur6DQjxFX/YnGVryCi/injAnptfAxWXm5B
	bL7gSoU0zVgPHegjKtBNqNwMFq/j9ioNgusuz/pqkH2ZG0vfmB/WYQfzMbG5/4XzA23keM
	JdcrefomyMSGwGO523TiX5kUVxvQ7aQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bk8epan4;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774114806; a=rsa-sha256;
	cv=none;
	b=U/NmEpFxqNR32d3gf1FbulaV34GT253v6HKLnCuARpgsN5jMXdFjhPp7oiDlDR9IY8hbYz
	heYKdisqx+y0x/pZbTkJ4haebRKW7rwXBAqpVBWE2LZGo5MUJald6iEp5+9csvKudRwwDQ
	Fumqo4JMBfMzyKjR3W0NwcQFaWQD/mg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E4F260097;
	Sat, 21 Mar 2026 17:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1589C19421;
	Sat, 21 Mar 2026 17:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774114804;
	bh=cXJQmRXxj3TsOqK5c1x7V7leAyVCPgHLDttc+gNLdbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bk8epan4r7fhqafp8ZTHOyQmUlsUDC6UtZReYeK4FU8Wl9zwHX+QUmBTgijyNnyJF
	 kllBoUdZmENElQ2EVSADEmZQsC67s4t43quYuSvMfiqMr+JK/DMM3ZVqtxFhfQ4+Sj
	 8PCqKsGSWsJMDN3MBTyBpI0QDsNA6azPTW2lmI5XclbXw7Q62ntP3j+PSoNtSn1WoE
	 k586pwj5NvXo8U/eQZvn5phnxK4L5WkhO8SDJ284x+4NRkZ3C7gGYWx/9qSfYLCrSq
	 1tp4SWp7zV8/w7KFLZA06Dx56FCXz0/I1Y/zVyhyvUvYcBmkllJLih0CswHNjE5YdF
	 Dh2pzzU+VGH4A==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: (Sashiko) Re: [RFC v2] mm/damon: add synchronous validation for commit_inputs
Date: Sat, 21 Mar 2026 10:40:01 -0700
Message-ID: <20260321174002.85141-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260321170623.84638-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 32AAB4000A
X-Stat-Signature: 8g6h6x51gqbouiiiyozdkyh8qsjzhmjr
X-Rspam-User: 
X-HE-Tag: 1774114806-468571
X-HE-Meta: U2FsdGVkX1+QAwxa4YP1JHRoUBk/wjFNgSj8TRernRBYTK45hqzrCjC9wB2YjwWn+kPWRiFdYROOyMPpto6wYdsjmXKCfJgtHbyrggy+8Bi/yWavWCuc6TaF4WwfG4cI544KCLz9EZj+AmOVm7ZVTRa+JmyBdCr4QIwuXnMxPn/hO83pXIqzIaNqMSAmJWEOVqzmpO52z7B3i3iZyB0kIeBxK17xmH/65cgqivt3afC1ivZ+QwKWgI5FiqZMxahGsfTgA/32yDR8LKIr7Ctj4cXhRr0sD4pGOEpxwqfFwn/xMIB2piYuEGM1M6gvT2qoIe4Ta7cUyM4ECbBqbojeofCoalP/84w8Y74cEkNnjgHaQoCzlO3QC/tGKC/fynrXPqdSO5IDIw4A9Xz4r/2Ck+xX7JZeAH/o2YnlrnsdD0BKT9DHM/qSkbZMtFv89aC9bVhFjnCd4GqK/hV1FOpwKu59pOk9y1dLcnWzK5YvdYNc/wsM67yXyN3v/jyLwMHK1mZ/+7yAgIIt1AkXAvexpPhxD9VtQQMb2eV46WKWaN3l2rdC/4rx+ABuJQg5egtbTwTPW6sLiSxn00K26/jQ9vUbnw2MfQb/D6QpuyDfewqfo3kQMynBbsG8OBV9seTwsvvf7+S8J16+SpOStqbEiBrCNQntcGV88lWu+bt8rsmu93X0m/0XGsU98PwgGugPXmuTo0Ync8ofVG7CWtO6emOaTGqS8RatIcQGErDmjUhOHghoA1rRCaB68YxgRUnPco4TRkCqBcTU+7+H+SD1jJ5gqOvv/U5FkNMjsfbS+QfYaQn6YoACzl53/Yis5ZgcfIj4Ba4Ft4T09cWqizitsKHKRpvxv7ndloIgnungbgIFKOn1AeFfMrYEvv+mC6FKQQCBublRlH+wiCNKHh6dfyR9cEQzjIuQi1Ht4Ncm58pJThIbkYrBc8I2puYy98sq6ZwO0qmEOF1cDXAezHV
 vEmOym9n
 xvIX2VpbjdaC+nOHRBLrk+iV4CIzBByVuRwBRVlWI3V1kdpETcH9+id2RRkB+Jp8dmVukJ2X34qieKKue0y1gI573zKAy7ZRxMM7Do2uJ4c9GQSYoSaG37rtfqXy/Cdh6XTJVYuXI6TY/sOlEJfIa5uzV/GqDU6H6MyvOHy0B7ETU2bAAXUZyN2Ezb9BZNOT+jCmphDqdHdS0WQd47L/Vh1WSBO1/LRN1X1U5fNq5z9FGhTpjyz8u72HNIqHF/GTaaqtFBjkp/F8Xz2jx5nyz+1SwVaQNUDT837JL8fyCHdCr0MIBpo746Jz/2rPVg7FftTK8naY5RkixysS9ya/NqaExxRW0nCraSaBQ2foPDQOlUpzbZ4PsK4Db5sxUuYgciXo/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 21 Mar 2026 10:06:22 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing the discussion on the mailing list.
> 
> # review url: https://sashiko.dev/#/patchset/20260321140926.22163-1-aethernet65535@gmail.com
> # start of sashiko.dev inline review
> commit 05e8b12e4fe302bfaf2b30ee9c0d38b036fc1c5e
> Author: Liew Rui Yan <aethernet65535@gmail.com>
> Subject: mm/damon: add synchronous validation for commit_inputs
> 
> This commit adds synchronous validation to the sysfs commit_inputs parameter
> for the DAMON lru_sort and reclaim modules. It aims to return immediate
> feedback to userspace if the provided monitoring attributes are invalid,
> rather than failing silently in the background.
> 
> Link: https://lore.kernel.org/20260318153731.97470-1-aethernet65535@gmail.com
> 
> > diff --git a/mm/damon/core.c b/mm/damon/core.c
> > index db6c67e52d2b..22136486e745 100644
> > --- a/mm/damon/core.c
> > +++ b/mm/damon/core.c
> > @@ -751,6 +751,27 @@ static bool damon_valid_intervals_goal(struct damon_attrs *attrs)
> >  	return true;
> >  }
> >  
> > +/**
> > + * damon_validate_attrs() - Check if the given DAMON attributes are valid.
> > + * @attrs:		attributes to be checked
> > + *
> > + * Return: 0 if valid, negative error code otherwise.
> > + */
> > +int damon_validate_attrs(struct damon_attrs *attrs)
> > +{
> > +	if (!damon_valid_intervals_goal(attrs))
> > +		return -EINVAL;
> > +	if (attrs->min_nr_regions < 3)
> > +		return -EINVAL;
> > +	if (attrs->min_nr_regions > attrs->max_nr_regions)
> > +		return -EINVAL;
> > +	if (attrs->sample_interval > attrs->aggr_interval)
> > +		return -EINVAL;
> 
> Does this validation fully prevent silent asynchronous failures?
> 
> If a user writes 0 to sample_interval or aggr_interval, the check 
> attrs->sample_interval > attrs->aggr_interval will pass (since 0 > 0 is
> false), returning success to the shell.
> 
> Since the daemon's actual application logic requires non-zero intervals,
> will this still fail silently in the background for zero values?

Zero sample_interval and aggr_interval are valid DAMON parameters.  DAMON logic
is written to allow that.  If not, that's a bug or wrong design.  Please let me
know if you find that.  So this should be fine.

> 
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(damon_validate_attrs);
> 
> Is this EXPORT_SYMBOL() necessary? 
> 
> Since both DAMON_RECLAIM and DAMON_LRU_SORT are built into the kernel and
> cannot be compiled as loadable modules, does this need to be exported to the
> global symbol table? None of the other DAMON core functions in this file
> appear to be exported for this reason.

I don't think it is necessary.  I also suggested to just not expose this
function to in-kernel DAMON core API callers in the high level review.

> 
> [ ... ]
> > diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
> > index 554559d72976..883860721d3b 100644
> > --- a/mm/damon/lru_sort.c
> > +++ b/mm/damon/lru_sort.c
> [ ... ]
> > @@ -361,6 +360,39 @@ static int damon_lru_sort_handle_commit_inputs(void)
> >  	return err;
> >  }
> >  
> > +static int damon_lru_sort_commit_inputs_store(const char *val,
> > +		const struct kernel_param *kp)
> > +{
> > +	struct damon_attrs attrs;
> > +	bool yes;
> > +	int err;
> > +
> > +	err = kstrtobool(val, &yes);
> > +	if (err)
> > +		return err;
> > +
> > +	if (commit_inputs == yes)
> > +		return 0;
> > +
> > +	if (!yes)
> > +		return 0;
> 
> If a user writes 'N' to the sysfs parameter, yes evaluates to false and this
> returns success without updating commit_inputs.
> 
> If commit_inputs was previously 'Y' (waiting for kdamond to process it),
> does this prevent administrators from aborting a pending parameter commit?
> 
> > +
> > +	attrs = damon_lru_sort_mon_attrs;
> > +	err = damon_validate_attrs(&attrs);
> 
> Will this synchronous validation reject valid configurations if
> autotune_monitoring_intervals is enabled?
> 
> The actual parameter application logic in damon_lru_sort_apply_parameters()
> overwrites sample_interval and aggr_interval with hardcoded defaults when
> autotuning is on. 
> 
> Because this validation happens before those overrides are applied, will a
> user who leaves sample_interval > aggr_interval receive a false -EINVAL error
> even though the configuration would be safely overridden?

I haven't think thoroughly about this.  But I think synchronously doing not
only validation but also commit, as I suggested on the high level review will
solve these complex problems.

> 
> > +	if (err)
> > +		return err;
> > +
> > +	commit_inputs = yes;
> > +	return err;
> > +}
> [ ... ]
> > diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
> > index 86da14778658..6ea44b02cc76 100644
> > --- a/mm/damon/reclaim.c
> > +++ b/mm/damon/reclaim.c
> [ ... ]
> > @@ -267,6 +266,39 @@ static int damon_reclaim_handle_commit_inputs(void)
> >  	return err;
> >  }
> >  
> > +static int damon_reclaim_commit_inputs_store(const char *val,
> > +		const struct kernel_param *kp)
> > +{
> > +	struct damon_attrs attrs;
> > +	bool yes;
> > +	int err;
> > +
> > +	err = kstrtobool(val, &yes);
> > +	if (err)
> > +		return err;
> > +
> > +	if (commit_inputs == yes)
> > +		return 0;
> > +
> > +	if (!yes)
> > +		return 0;
> 
> Similar to the lru_sort module, does returning 0 here without clearing
> commit_inputs prevent users from aborting a pending commit by writing 'N'?

Again, I believe doing both validation and commit synchronously will eliminate
these complexity.

> 
> > +
> > +	attrs = damon_reclaim_mon_attrs;
> > +	err = damon_validate_attrs(&attrs);
> > +	if (err)
> > +		return err;
> > +
> > +	commit_inputs = yes;
> > +	return err;
> > +}
> [ ... ]
> 
> 
> # end of sashiko.dev inline review
> # review url: https://sashiko.dev/#/patchset/20260321140926.22163-1-aethernet65535@gmail.com

FYI,

hkml [1] generated a draft of this mail using below command:

    hkml patch sashiko_dev --for_forwarding 20260321140926.22163-1-aethernet65535@gmail.com

[1] https://github.com/sjp38/hackermail


Thanks,
SJ

