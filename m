Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48180109C027
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 14:43:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E3276B0005; Wed, 25 Mar 2026 10:43:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 893D26B008A; Wed, 25 Mar 2026 10:43:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AA696B0092; Wed, 25 Mar 2026 10:43:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 699D86B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 10:43:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 15B111A085F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:43:51 +0000 (UTC)
X-FDA: 84584854662.09.135C18F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7133310001D
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:43:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YIw5e6wM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774449829; a=rsa-sha256;
	cv=none;
	b=3Hb2qKWtExBQp90nzBXYFzSpiwaNcSTDic6qxBko6BUjaoMUmGV11SU2bajjJgdtX8lTMf
	rXyXP5GTVOrE91tpELcKPygFrLq+rLG2AwGxApMGkSMN2APEtC08lAnKqzlddz3VZibJAw
	vv0Zb509DXVR90o4fRUn2TTa0V0Fm+E=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YIw5e6wM;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774449829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cm1P2rDiDEmkS976TYd/u3vjuo6EaRbE2CVLyW3fCCU=;
	b=5GPHni3s4vMzEp/S/7J8ok0bSX0K8cBTFCENI5RQ9ZiUbJDxn7CYOPryvPyCW8DNl+PNmh
	T98dmf4eDf4N8NDQ964ftlgVhvSSeTA7DfB4h/eADV3ZYA0d19iI7p+AMUZOMgdXsVWjkt
	RBm8Wepb+VmCPbCMepK8NOtNfFirE0s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D7B68600C4;
	Wed, 25 Mar 2026 14:43:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 728D0C116C6;
	Wed, 25 Mar 2026 14:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774449828;
	bh=fz0PH7iPdSPVhHcrWudA4xa1kfyWU1uxxd4GADXVVEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YIw5e6wMpwqsBArxqgPqW29Eovlha+8sP/PTHAchI25czpN3OXsjCVgW7EgERL1c8
	 My3d17ab8a5zHMYQi8ouEaakQaf6sDq3Ru+E1qoq4aC81KWIntcvpBpN3ENlheg260
	 AzshRMXkeoyW75MWosBPPsriMsm2jUiS5Sk17GoyP6i9hd/HkSgtpMKUEqjtr6eRNi
	 PGYIwJHRPwdcbNYQykyQVOdpfPVQmHvgC5yYmUdK7xem6OIjfT5InA6UuSc92vudMU
	 +4fi066thhTqs6JDxPzKJ/zyFkzAAyaGzoz8mZW0V5PNOhQhXG0nBmo8C/awYzhZ8u
	 Zgb6fYSxrKMPg==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: (sashiko review) [PATCH] mm/damon/core: eliminate hot-path integer division in damon_max_nr_accesses()
Date: Wed, 25 Mar 2026 07:43:46 -0700
Message-ID: <20260325144347.87818-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <E4E214DB-E7C0-4B69-8DC2-2A9640BF5CC6@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: hswiharp4zjptkkuospq6yo6poyakobs
X-Rspamd-Queue-Id: 7133310001D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774449829-643520
X-HE-Meta: U2FsdGVkX19SfqWKi7AAFp7lrqblJGdFoegUjeT1parB0+dqplBtFfVorUEk+wWW/IJ3+xu0Y2uHTx6duCnA693c8iWouDotI0wJN0GXIq8HI0rSUnDoOZQN/3EPf6fP0dgBoAbFnGXrrTIzJyrJEdY2IsrqBeZiF1xuK2N1h6AmbAMLz8M58xGNDJCtfljvqiKJzGTdzHrJMJCK0lXckb39SF0sZKKjX4g323GzElM1vL5DvgaAPnBJmJ53c1YnQKJ8p4L9BdOGdrsLedZPglmISKtyVuOSoVe9BUfGz/tdJF3nqtCLxs//fdWbv0uDcxkA6uNEibHEl+5S+jmR9GewLmzfXDxF8b2Iu2Gk1xqtYR6qwdXd97uf5+gJ/TrSX8oQQp4J2IJhEgYqxqjW7ODfiGGGSiuhZcKiz2cjMiT0FvcBMD5OmuZn0uvpm9YRHlCHBfBitgEbFO8LLjQd8KZ3q0qe4y1rqrfEHa6IJZCxxoIZZwlIp0xcco9v7fCHhqJL57PgPSexdVoOzjLzqT91YpLDhqaBCxbuAotPjbJCItIDMVFOGU55mpCv4zXx/cFUCIlQmKsClvqtTS6VQYEug9d5RKRo8hdEOsKWm4jikF7ynhmzyJsktxOletEkD5twycycUA83uoeYvBiXd1ZRn8EK4YeikWB15zA5lZKN2AlkiKuxNQn9gxb6Xw3k0bbmXhPY++33O5nfqsKM2uAmtbk3Jvl54PtugA9y0aCjuYEZNovljiLnAMiD8ARTxo4iiozRdo/5tDOb+GQ1rXKutxtJB+C6EAf2ZZ59EQSZ8JTYwBj1PAO+2MMQosr4qp4CR1SZ3vBI/6BTbTvKFvmv+M1kfzCZ/gkBRgbkL1UjwB3NSS5YDIdvufmKA2wcHXCW+h3euRI9Mxch4KLEq581sjj19tV+Wnfn8/W7wkwgs8ZG5k2e4wE0fd7FIJMC1sIF+Bch/rUjVsb+uko
 SrVegVy7
 C4ctEQ6K0Jby1q1VvllVAjc4bdE/ZVDmHUHJcvMleHCaSjP2YxDSZZdOB8gMiz/WeuCzVZfii2yuBlceEHCzGIW0PdTEssbz+pHnUEwOeYmqYZYCR49gL0L0zoF+I1Iv90mY6pcL9C+5LJQW0DFpEDu4dF0pH7No0dXg1BO6j+6qububb/+iidhfiE+Wwq1QwBnXEU/c90WGgq0gAGvdyywd3pmKA8kfgdE7O0wEYiGEf+Kb1HBKaQanSwqTXXh7dQPFW+Mr1pZbtrIlBp8Jax4kk7ZZjnu3fMb6gu+DnruYJUSacP12w67d5qhR2+oftpO+cCS72BGBbP7iaLviuNTuT0mc8WNk9dVCcQJnrIhp67TCR1KUdiFRsr/geAWgoDwMNZbqYsMWNYWERRKSRYpEg1fTjGtGxelJ9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 25 Mar 2026 07:36:20 +0000 Josh Law <objecting@objecting.org> wrote:

> 
> 
> On 25 March 2026 01:16:52 GMT, SeongJae Park <sj@kernel.org> wrote:
> >Forwarding Sashiko review for doing discussions via mails.
> >
> ># review url: https://sashiko.dev/#/patchset/20260324154005.83651-1-objecting@objecting.org
> ># start of sashiko.dev inline review
> >commit ff5e227a18cd69435749b0aae0dc2c762c4f0a47
> >Author: Josh Law <objecting@objecting.org>
> >
> >mm/damon/core: eliminate hot-path integer division in damon_max_nr_accesses()
> >    
> >Hardware integer division is slow. The function damon_max_nr_accesses(),
> >which is called very frequently, performs an integer division.
> >However, the struct damon_attrs already caches this exact ratio in the
> >internal field aggr_samples. We can eliminate the hardware division in
> >the hot path by simply returning aggr_samples.
> >
> >> diff --git a/include/linux/damon.h b/include/linux/damon.h
> >> index d9a3babbafc1..04c8a052fcfb 100644
> >> --- a/include/linux/damon.h
> >> +++ b/include/linux/damon.h
> >> @@ -978,8 +978,7 @@ static inline bool damon_target_has_pid(const struct damon_ctx *ctx)
> >>  static inline unsigned int damon_max_nr_accesses(const struct damon_attrs *attrs)
> >>  {
> >>  	/* {aggr,sample}_interval are unsigned long, hence could overflow */
> >> -	return min(attrs->aggr_interval / attrs->sample_interval,
> >> -			(unsigned long)UINT_MAX);
> >> +	return min_t(unsigned long, attrs->aggr_samples, UINT_MAX);
> >>  }
> >
> >If an administrator dynamically updates aggr_interval via sysfs and commits
> >the inputs, will attrs->aggr_samples be correctly recalculated?
> >
> >If aggr_samples becomes stale, kdamond_fn() will compute the real aggregation
> >loop count and allow r->nr_accesses to increment up to the new bounds (for
> >example, 80 loops). Meanwhile, damon_max_nr_accesses() will return the
> >stale aggr_samples cache (for example, 20).
> >
> >When evaluating schemes, damon_hot_score() normalizes r->nr_accesses against
> >this stale maximum, producing a freq_subscore that severely exceeds
> >DAMON_MAX_SUBSCORE. This causes the calculated hotness to exceed
> >DAMOS_MAX_SCORE.
> >
> >For DAMOS_PAGEOUT actions used by damon_reclaim, damon_cold_score() returns
> >DAMOS_MAX_SCORE - hotness, yielding a highly negative score.
> >
> >Could this negative score cause an out-of-bounds write on the
> >kernel heap when used as an array index?
> >
> >mm/damon/core.c:damos_walk() {
> >    ...
> >    c->regions_score_histogram[score] += damon_sz_region(r);
> >    ...
> >}
> >
> >> diff --git a/mm/damon/core.c b/mm/damon/core.c
> >> index db6c67e52d2b..afb058f7da5c 100644
> >> --- a/mm/damon/core.c
> >> +++ b/mm/damon/core.c
> >> @@ -587,6 +587,7 @@ struct damon_ctx *damon_new_ctx(void)
> >>  	ctx->attrs.sample_interval = 5 * 1000;
> >>  	ctx->attrs.aggr_interval = 100 * 1000;
> >>  	ctx->attrs.ops_update_interval = 60 * 1000 * 1000;
> >> +	ctx->attrs.aggr_samples = 20;
> >
> >Since this value is cached here, but not updated when intervals change, does
> >it remain permanently stale during dynamic updates?
> >
> >
> ># end of sashiko.dev inline review
> ># review url: https://sashiko.dev/#/patchset/20260324154005.83651-1-objecting@objecting.org
> >#
> ># hkml [1] generated a draft of this mail.  It can be regenerated
> ># using below command:
> >#
> >#     hkml patch sashiko_dev --for_forwarding \
> >#             20260324154005.83651-1-objecting@objecting.org
> >#
> ># [1] https://github.com/sjp38/hackermail
> >
> >Sent using hkml (https://github.com/sjp38/hackermail)
> 
> 
> 
> So it's nacked? Or is it just a review

Just a review from an AI :)

I treat sashiko review as just another review comments.  I'm forwarding these
in this way for a case that someone is interested in the comments and want to
share some findings from those in a way easy for mailing list based
communication.


Thanks,
SJ

[...]

