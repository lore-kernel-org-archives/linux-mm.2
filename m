Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CC09CD5BAB
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 01:56:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63D266B008C; Thu, 21 May 2026 21:56:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61AA46B0096; Thu, 21 May 2026 21:56:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 552386B0098; Thu, 21 May 2026 21:56:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 488D46B008C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:56:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E8EBD1C1EED
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:56:32 +0000 (UTC)
X-FDA: 84793391424.07.8A83B37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6536B1C0008
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:56:31 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YBtC87G2;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779414991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6HtJuUDJtmhs8hd5ldkYZOOhfjw4YQoyAH7cd+rYzic=;
	b=EuFuHzQHprJsEm35X4bIytfnZV+b9XzbOSyIM2ucUmVIxQ/Xzs6dy8Zj9tlO6ujtad24xP
	aR8QLN0+HMfJbdnhYB07oi26FrEfNcx8REfzKa6ZgOyFGpXKMhM0cUW5ZSxtssvO8z13sG
	a7JesjTd7BOpag7Z9ivCgA2rIJG9SLI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YBtC87G2;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779414991; a=rsa-sha256;
	cv=none;
	b=5Glr1Wpu2T9pROL60wIRgXvSQGOWlvIv3mCYD6AbEvWzRtO/SRK3uo5jiGs5WcOKTcrkKw
	xS74eSiNH7j9shMiFgsgFuiK011BjKp8vY5V55OQtJ092O1m4rUmMVXYIyCxGf7TN7+LLF
	BuiUZ9r3yO53GVdImhJ/6pfJaFH7gJI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 98A8743993;
	Fri, 22 May 2026 01:56:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE4A1F000E9;
	Fri, 22 May 2026 01:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779414990;
	bh=6HtJuUDJtmhs8hd5ldkYZOOhfjw4YQoyAH7cd+rYzic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YBtC87G2WaMgXzEHN5jJmForY/ZXvOfLrPHsC0xnWHIS+vkcsCK2kGBc0be7o/BT6
	 KPgrOyAPnZGEMVcdKIJbqgFvLWiO+hsXpqC+4QsZu8+KeAwjrnL5z8gxN+tTuyEYmR
	 9SN0WMR1/UhOrZgnadJooogMQQtuGAqsniTGVM+pq+fOXUv20pWy6KNQmc/RRzO5VE
	 MGJ2dfQuW5Kd96JA7JYW9FVU5c52e7OpHNglDk78q4fU1YnV/1CiwuueFZ7kr/z+dE
	 z/49fVJ3hY+xXcNLt9PaB+NkvQU2Q08wdhwiuy4D5Nq0a+Zonm8XFMQHZhqAxyMAes
	 kQv7QHQHFmVaA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: trace esz at first setup
Date: Thu, 21 May 2026 18:56:20 -0700
Message-ID: <20260522015621.86403-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521162834.d119e280e3f9c20cd596d197@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6536B1C0008
X-Stat-Signature: h7syhquzrmo38tzctyg8unza9mfar38d
X-HE-Tag: 1779414991-282025
X-HE-Meta: U2FsdGVkX1+h8YxZn6iw5yGNcxY35Zou1V0XSfdaeEv0GeajKrHuR25qfQ3MKaO9oC0PSgqWCo5CMMZKh0Ph9Kg+9y4XJ//6Cza7ckSItkKT5Oy6JdeLY+IzbbFAT+5nVPUVJ1q9SfU1j51nI48N1fx0Q99OR2CnJj86ppYjfK75CtSqzNiK0daQFAXo+HE3AspdJp+fbOZ21QsJbZVd8c0rCAe8QaGvrRRYS7CJPfrlyU4EWuRq3C0T62mljsdPQKtlgeLPRSMZ0rvKqpMUZ6QkSS0SrOKDRrRBArGpzF3NfOkFZi2rZ5Whl/TGI+qMinfTV3Y5ai2KxyI73U9sSaZoV9djrBeUieBdC3/FMB45kOfpNwLXjJK/YUp5ziN9vvrme1/KCrpssCtuTvIwQcuhogFXXppJHqTU4y/oTGv/eVTtkEwUUB0diXetS0EMkXacqSMbBMLFpiO4HOYdXCOwi5GNCp5FO11Unp89rKLBjRXk/dHO+x6hs6YNypfLFEa6jgdzIkHicWXsjiZJcrDM5ZnwScPKQ3eMOSKVCjW3Gy7Ez+XHCWLQdjnNl/lNknWaReCt4ya0j4JFhzpmUx5rK78esC50YHWCOumi+okbHu5Bjce6c5SbctyBv7Kk/p30FZgjtnQFznWKvq8SboTgStGcN8+gBt4J0ynwhkhqyXyOZuvx1XmdNQ5liu77KSnJOvr2ff2GlJAm849i/KPGK6rodQ8oD95lJF1kBGkcjEIlvUQE3FmRVjPA92FWXcUbgJO7Ih3hPUbDRmXnNLFKnzbrjh8XnpWfhpioNyirJgVMHTYicIyNhS6K+GJDMz/HMr4GLCASjZaoCPzcH2D1DXqzAdy2QGqBLLCXq/lhUEcCKvUvePNwbeVL2Tpa8CnwyN8L0MbXwcwKNZ7AHeJBQ2BqCxlH6u/Jv+OwxW4VNQurrD9rE9aL/eU0375nkkAfg9O7ejo19LqI4qy
 L0IwFcUr
 kccTlS8/zZHw1WfqT1puIYcmAZTr5UcQiS0K5EyW6Izb1/kKSciaYKCrpjuJ2a7x68WK2efS6idSMwiCl+ry/Oa5xiLpS6Vm773zWgrK2JL+rKiITURUmqUOmN2xyxjvzyrCsjupKSqzwiz2CDrqV5jnFLLqz99FpJMrD28fs0xdhvlPrsSo87MquH4MZ5lWqhPPlOSh9BXS0QR78BcLDUYD5jZ5NLKz9n8x3rSklh62Og8JINgNWCGQo28JCjeJUfHEJFNKEL40YWI+RMlf8k7KZNrZYARwjWPiO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 16:28:34 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 20 May 2026 08:03:10 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > DAMON traces effective size quota from the second update, only if a
> > change has been made by the update.  Tracing only changed updates was an
> > intentional decision to avoid unnecessary same value tracing.  Always
> > skipping the first value is just an unintended mistake.
> > 
> > The mistake makes the tracepoint based investigation incomplete, because
> > the first effective size quota is never traced.  It is not a big issue
> > when the 'consist' quota tuner is used, because it keeps changing the
> > quota in the usual setup.
> > 
> > However, when the 'temporal' tuner is used, the quota value is not
> > changed before the goal achievement status is completely changed.  For
> > example, if the DAMOS scheme is started with an under-achieved goal, the
> > quota is set to the maximum value, and kept the same value until the
> > goal is achieved.  Because DAMON skips the first value, the user cannot
> > know what effective quota the current scheme is using.  Only after the
> > goal is achieved, the effective quota is changed to zero, and traced.
> > 
> > Unconditionally trace the initial quota value to fix this problem.
> > 
> > Note that the 'temporal' quota tuner was introduced by commit
> > af738a6a00c1 ("mm/damon/core: introduce
> > DAMOS_QUOTA_GOAL_TUNER_TEMPORAL"), which was added to 7.1-rc1.  But even
> > with the 'consist' quota tuner, the tracing is unintentionally
> > incomplete. Hence this commit marks the introduction of the trace event
> > as the broken commit.
> 
> OK, but...
> 
> > Fixes: a86d695193bf ("mm/damon: add trace event for effective size quota")
> > Cc: <stable@vger.kernel.org> # 6.17.x
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> 
> The patch is marked for backporting but it assumes the presence of
> "mm/damon/core: make charge_addr_from aware of end-address
> exclusivity", which is queued for 7.2-rc1.
> 
> We can either redo this against current -linus and fix up mm.git's
> "mm/damon/core: make charge_addr_from aware of end-address exclusivity"
> or we can queue this for 7.2-rc1 and you get to deal with fallout when
> -stable maintainers hit issues backporting this.
> 
> Preferences?

Either is ok.  Because this fix is not urgent to my perspective, I'd pick the
second option.  Let me know if you need anything from my side.


Thanks,
SJ

[...]

