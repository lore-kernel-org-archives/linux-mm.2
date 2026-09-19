Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A887C982D8
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 15:55:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 508D16B008A; Sat, 19 Sep 2026 11:55:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E0EF6B008C; Sat, 19 Sep 2026 11:55:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41E396B0092; Sat, 19 Sep 2026 11:55:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21B406B008A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 11:55:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5205440251
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 15:55:12 +0000 (UTC)
X-FDA: 85230960864.12.0D9D250
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B4A3B180006
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 15:55:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n2ZdRdGc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789833310;
	b=wiDdTTbKWE6hypIcuYNbBVnxvrZsNvOyX6JZMEnaPb4YJ5NFUHHY9TwDFy2aABKxlBPNij
	UwmLbOK4emhWPqfr1Y4CZWXumMG8VQ89mxcGn+xWLcptDkJpu/rUI4zQMFeMpQUfiu9Kbt
	X0lGKseptt6kkC5rmKYdhLyXha3VB58=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n2ZdRdGc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789833310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B6BjE5sn0U6E/JVzt5jw8kZLRH2flS2xlqYcSGbx038=;
	b=wvP59LcEkdsjJdbtHC/520LmgJ4J1fWHry84hIUgZaU+GDHtxTremka5pK9Io0zeYJJvX2
	aiSZQ7r03WjtzGv4/z7M/Or3vMCT+5h4uHGn7EuMVhU6EuQMx2cTtvNw1K6z2EQ5pZ54Cl
	wic7g/qghDuw7N5c79zgGu1cFoboMQc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 041AF41488;
	Sat, 19 Sep 2026 15:55:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9137D1F000FF;
	Sat, 19 Sep 2026 15:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789833309;
	bh=B6BjE5sn0U6E/JVzt5jw8kZLRH2flS2xlqYcSGbx038=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n2ZdRdGcRKiydZel/9OJ+ZO85Vlb9e/IhAgUzsFhvZCWzVleWaLCMfiSS6ow4HtKV
	 OXWBu38uvJ15HM84fyxkF8+VlnZeoyJZIT1qwHvSspUht3r3V7BEgLoBucl2M2h9Nm
	 4YSq469HAwpFX64g3ewxY+5yGwCQSME6T4pXSMvuABsRZLYbeY1/RErcTopIO/JImn
	 nBFs1v6QLUeTjheRZ1D7O+E+2nqcoHwx1MTYNgxNc8xf58zrwjgWEyGN8fWQA/wcAJ
	 Ur0VSPqGy3gvWK8L0JRoEOFKESzwBeoHKoWgd6NnmodJnXIShjD6Os4Vedojzt3h6b
	 HWoD0OO+5weUw==
From: SJ Park <sj@kernel.org>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/damon/tests/core-kunit: test PSI goal rounds under the temporal tuner
Date: Sat, 19 Sep 2026 08:55:02 -0700
Message-ID: <20260919155503.85841-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aq4hU5DNjnGELpUT@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B4A3B180006
X-Stat-Signature: q86jfq58bqpq6r55jrocqmiu6raf3zxx
X-HE-Tag: 1789833310-946750
X-HE-Meta: U2FsdGVkX1/wpVDLfrVqvu5ZQPKdTgp4Gce/MTZ8BLdaloWwU2hlHE0xUr/Tmmx/7ilbeduDTZq4KeGGezjB5UX7TqkhN/lOkuYEKv7LWdSkd8PWwqgP7luexNjukLGm51PupNrxJ20ji5uvl+yQ4FWab08yuD0cY5O8LH9hlP52h/4zYpiNzMnWusTmZeOEjHNCW7qj1S0dVatr8gUJIL4BxxqOYMoY9MC0V8JM/H9GgfPOAR2fAnUXyUqeAoAIzT3lMlzTTskAbZmaikih+4/DfhXbkn7xC6O+pLn80sBsPfP6WOXIVUM0+pXdjfWtUwXcpI5oAz2859pGTWrWxkN+uWFtCkQXtynpUPVAj6YoOlqD8p6VfNiunLI59W1ZMY2UDeb87HBKfK2qoO1vbUOkTXUWnqWcqb8GeXqObvbSf3usKScnAVrvLy3xkFFqwoBuwoWMzUojnWDlTn7IYEScTdb/s6dj1MwW1p6/1fN4mnZm4EwARL/6jiLPn0vZTn73LHcoGV4f30zB04whlRhItNcW4QXV1VdrcVlKwHIiu69b21qGWfZT4uEIUa99pQqIyyzHz1xMxC2gWpVQ/TW5N7ATrSuEpBeGKsXPtLpL0PUQAkHhJMefApHwg7dJ62ZE48TRRoNoIjuSpXcTqa8G6kur3GmvU1KzLseJNcRBy+Lhk/+BjZs8qc7s6mlSbveZDWmVAFP8m+BtAuueK0093/eZs9BX7ph2c9f3LossAu0W7d3EIXzFZoWLDr1Ccq8MoL31t5P8RZUpQ2dRDsNdwDDdupNyLpjc9Oli6wlWvLT5NznQkNP8sdSAMjCzjD/M/Jlzy3KLMguVjZsMeIMO+nP9e9okBRCx2W3xl4HZnDSrwSmjymUVmrgF2b0Cv3sjSrcYIbM/UoOz7ruov3Oel9c9ksPoBKrn1qA0mp2VFf/01iAiqVvltu4G0SfqF+6oho2WFiLe25DwLO+
 I8G5I6n8
 IoS6ifA1lC9n3Co+jl396aXLWBMKOrzFlHAGGZH11qtZMIAIel++sMYylAzO7KjC5umcp9VQN/cgehS0yNlKEWDHpIrNiJvKDh0EhvD9lY8Uvl3FR96aLOsgjXZExN0nFfGkqzvzaPrZnESUxqSwI6pfMJoA0YuR4A26k70eqaqpUuXo/HM5qZT8Sxt5f2mY95IrW5UvRpvM9vB/l8/talLHNj1x/QNyxwitZCKJViftGo10ZLpuO992qWx6MxDqRCwvP+7Zc1U9CzfEIyIfMHypEvR++jR8YUXzrdRoYAb/HyOH29SKpxKb0KA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 19 Sep 2026 07:47:11 +0200 Karl Mehltretter <kmehltretter@gmail.com> wrote:

> On Tue, Sep 15, 2026 at 05:21:36PM +0100, SJ Park wrote:
> > So, this test depends on the memory pressure level of the testing system?  I
> > concern if that could make the test result not very reliable.  Maybe we could
> > split out the corner case handling logic to explicitly receive the current
> > memory PSI total time.  For example, like what I suggested in the reply to the
> > first patch of this series.  With it, we could build a kunit test for only the
> > target logic, without depending on the test system's status.
> > 
> 
> Yes, the second round reads the real PSI total. I used ULONG_MAX as
> the target to make it unreachable, but I agree that a test which
> does not read system state is better.
> 
> For v2 I can test only the helper from your reply to patch 1,
> with explicit PSI totals. It would cover both tuners, zero and
> non-zero esz for the temporal one, and the last_psi_total value after
> each call as Kunwu asked.

Sounds good, looking forward to your v2!


Thanks,
SJ

[...]

