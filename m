Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BE9FC61DD6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 00:22:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53D3C6B008C; Wed,  2 Sep 2026 20:22:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ED806B009B; Wed,  2 Sep 2026 20:22:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4039B6B009D; Wed,  2 Sep 2026 20:22:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 20EE96B008C
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 20:22:21 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9AB58403DC
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 00:22:20 +0000 (UTC)
X-FDA: 85170549240.14.8F7E136
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0BBBA180008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 00:22:18 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gECNSOex;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788394939;
	b=HSSxXmxDGuX6ibRjTx+dR7MVNU4HQO29tHPl/L9OnTRHpt2DaMaWJbka8HPzamPLTjwdpF
	cZagK+ehsqTq+UQ1XPWyn1qkeSjqT3qBAGRatMneBEpnynes4z6PTW3G94+ohOFMdRe3Q6
	EQQl17XM1wGcCCzCXbcPzdCvgStWzCA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gECNSOex;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788394939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OxWQhFCQXWh0+Se6BwEJfMpRHGQJ8OFKAgPc6CcdDiQ=;
	b=MaqVGdTBGxSquP/MtkckgV2pyPqoDpCuUZDHAvjdJQL6PgtnDy75vhjovIufBwnOf+H3L5
	oQvzzsz5DMtWhuA6hgnvuE/tKW7eHQbBLBskMyVCOamriqgygHQlVEgMyRa6KLIBoMOxBc
	hU+0cDGoPuVkfReHsagxGGSNveHNNkI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 87743600C8;
	Thu,  3 Sep 2026 00:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDFAC1F000E9;
	Thu,  3 Sep 2026 00:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788394938;
	bh=OxWQhFCQXWh0+Se6BwEJfMpRHGQJ8OFKAgPc6CcdDiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gECNSOex0hFA1rBKedGbmsFe8VUlJD1ARTyVupBjBwFJbckercbOnGGwi5aIOKJ6V
	 Uz8QrhzIvz6xyIDqKBW0v8oQJgzeCpQ5b8/NntQ6Ln6BFoiQXxZVQaY66JdrgmIUgH
	 r3h4an1LVt0/z1V78SKEumy3h/xubCLXsd41CxsvtR0jZ3fuYrtGhN9fy/GBHXO92o
	 kurITRekpi0dlFEwjXqOqRccoCz59rhiFMQIbUayizVUdM4fgIWXAP6Gf9cEFH7Ry5
	 4AvQF3wcI80RgAZSFpAI1HpWTM9Gg/RSeP1BSYXeEZmSgyOe6QSipbi2gS1Gy/90Kd
	 mB8S0W1I23X5g==
From: SJ Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 09/12] mm/damon/tests/core-kunit: test damon_nr_samples_per_aggr()
Date: Wed,  2 Sep 2026 17:22:09 -0700
Message-ID: <20260903002210.46269-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902154944.4035059-1-kunwu.chan@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0BBBA180008
X-Stat-Signature: o4z8aabag317g4gk7y6yszpmojcnxyms
X-HE-Tag: 1788394938-276381
X-HE-Meta: U2FsdGVkX18z2DJz+IwP8XORuImMRalDpd+mQGNBMY9lPXJbvGRuesyLzMa16O2vf85A4Nnxxp3hwx3VjlDXukJh0kcWSwP0z+TLnekiRuDPO1EtOmyfoNK7EV39+M6O+eY5oHv1hMrQBv8KMEbytXRXRZnnGx7FBrXIYSdKqwJOjbSRId4QMWk630sgWC2YVIZ/CFcxR8zW3fRUCGS32JG9XT64CueGa8pQUZ7qodJaEVaqen2IOYazhTfqJnCk4PL/8fBnManYxsJpTniusHINfJl8hqa2gHtEM9Kfl9zCic04ju00hXbBilc7eFy1UwRlDjBTVQOZ1DwRhSExnyikWL/Y5y+UBwKlIdVeToYl+szslU6AKBMturJ+n8GELHgsawZjIH98lU17Gb/9SMlC06ycF00OsPM3gf50Im0KzB7cpRKRzAUWcPqxDcAD9z/PT4P1XHQqNlY0mtUaMQ8XlhaD07Uk2nAa7iv1QcajxkvzCS7DLY/ubnJ0+Zuq7tYMZNuA9ee671Zwhq61Z/lk9j2K0KtQRCTVda3JAntdiWHUhydHuiQC/+qfL0o7E7jPG6s2rs9JE+qZI6K9OuehtM0EugtdJ7ny2Eyvmpuwo4ENekFdwfMFf68in0X2FyBZdO8oMbPHO54uiink/11Ij4KIg73YhTt6PEOR5LJ0xARY06C8K0ju/g0/R0RHeKusM1TRzGnhRBxTFl+YxtGTkOyP4JAU7gCXy8a7wNo3qkQHGwNbMWvG73ogb+zkNngnyS2BQTnCR5GD+W08lV67lTaZrDh6vEYbxW0N7BUTXLfDUt0B2wP20ZVdndIOHVWdzc3wBoiWLZvQUQqz7RyD3PBYQKUxB63YxsTWzy6lZ046O+DutZMP/5AFGw/Cam0j/CtlMEs+cWTlqIgeT095ejkjMRf5D3TyBysVXQWjBltx0xhUZGmyHD3zU3MWP/X0duwf/k5tRF90hQe
 lYZdvf+M
 oOlzSDyHle7gBEff9wdjg3h4cE7GY2hqTCt48XQb9r9vL5UrRBiGM8z46LT5e1lUajjUuumqeMH5jCuljktWqdMgbVCRY7mx4HklA+S0K5p9xtnnCQwsvNLF0hhWO8he7c9glPDPfRMBqrV+lF1d2/CVn71O3YgScuHPVzSADBAk7qsiE6obtrSdCYMKfwwi5745bpwRJ5piC9kp6dBaUk+kMl1Z9RJ6VOv98LdnnHY7+3bhitytn1x7f/pWAoywAe+jeyCk9P/hwDIoL0qXws7hwsnuw8NmqGMGkcJILVgRsbqy3zyAC8uHeicTMM4y4eBQxA9hkvBjfzqglF7sl/HfJmN9lMw3UlAtV7unnGWv+os92Y6MoRdd48w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  2 Sep 2026 23:49:42 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrote:

> On Wed,  2 Sep 2026 08:19:54 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > On Wed,  2 Sep 2026 23:08:41 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrote:
> > 
> > > On Tue,  1 Sep 2026 22:47:42 -0700 SJ Park <sj@kernel.org> wrote:
> > [...]
> > > Both `sample_interval` and `aggr_interval` are zero here.  Since
> > > `sample_interval` is the denominator in `damon_nr_samples_per_aggr()`,
> > > would it be better to keep `aggr_interval` non-zero when testing the
> > > zero `sample_interval` case?
> > > 
> > > This would make the test explicitly cover the divide-by-zero protection.
> > > If the `aggr_interval == 0` behavior is also worth covering, perhaps it
> > > could be tested separately.
> > 
> > Thank you for your review and question, Kunwu!
> > 
> > Yes, that kind of additional test case would be nice.  Please feel free to post
> > a patch if you'd like to! :)  And no pressure, no rush.  I will also consider
> > doing it myself if it seems you are not interested.
> 
> Thanks for the feedback, SJ!
> 
> I will prepare a small follow-up patch for this test
> clarity improvement.

Looking forward to!

> 
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thank you!  Also appreciate your R-b: for other patches!


Thanks,
SJ

[...]

