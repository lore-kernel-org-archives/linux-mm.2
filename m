Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E61F060A3838
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 13:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AMqKHFdb
Received: by kanga.kvack.org (Postfix)
	id 011DA6B0757; Tue, 27 Oct 2026 09:54:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2AA76B0759; Tue, 27 Oct 2026 09:54:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E41976B075A; Tue, 27 Oct 2026 09:54:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C95F36B0757
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 09:54:05 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 65072A8760
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:54:05 +0000 (UTC)
X-FDA: 85368550050.23.D00C677
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id C6C2380006
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 13:54:03 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AMqKHFdb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793109243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O0HlFL9/QqurHonrWKlExnX7Q+xujC/2o87bXkVMAlo=;
	b=4+nphcSPCCWejh42J/Og5e73hx6T0ODaIwG8PcUnwGHcA9V8hDkPZ3oKL2afX1NEvInZFs
	qTrZm8+ZBiQuOOdYDsp5aqbwXV2pvkCXYEFNKdDVz0TUYRaVdiyRo+OoLtx0/JNW3U8ydJ
	Yt9BFisgoenjAcKZoVc9rpxm9STob1w=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AMqKHFdb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793109243;
	b=EYvPuvaL0y4+vB3RgYNeeH2URIGRiZYr8RNZERocmBTuo4VFjts4hP9/tX7e0112PgmoNE
	lqNC4duD1+C0aruleRJDrWT18hfr6vCCyYQnGMEss3PtEHzUbs5aDIWe/fF5yT38nMZYug
	kIjuz2ERqAO3hpUV9A/RdUD5ua+X1nQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 37F2642E09;
	Tue, 27 Oct 2026 13:54:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D962F1F031ED;
	Tue, 27 Oct 2026 13:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793109242;
	bh=O0HlFL9/QqurHonrWKlExnX7Q+xujC/2o87bXkVMAlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AMqKHFdbqByiISt7gdsCumYhawhuE9fwriGzjlE0yAjkYNrIZC6K2R0bMvHm3GizW
	 sAr5XUXUJNX8HBY/ybbp/jOIg5RlwlZKFKKpi5901ZDK5p+2Byo8TRKA4yC3LKS2AC
	 NMmzxJr3YefLqAEhLts6DW3A9bvzrJ0UHWcmRm61qYPXoYzyiql1+PgeDYnUE5I3Zi
	 04R5if/6KKbW7kzm4nr3AFj4kE5m+Zt+IJqrCIfYFnWdPEwTGOm4X+SxA9NtAXRumJ
	 6x6AyjgE9ddCd5dqS73hvfvQXHxdXlryLFx1ySNZZO8tgDnkT29Z9RyK9zzdD/muFf
	 3G2B2xqGCKexw==
From: SJ Park <sj@kernel.org>
To: Daemyung Kang <charsyam@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	akpm@linux-foundation.org,
	bijantabatab@micron.com,
	ravis.opensrc@micron.com
Subject: Re: [PATCH] mm/damon/vaddr: preserve migration weights above UINT_MAX
Date: Tue, 27 Oct 2026 06:53:54 -0700
Message-ID: <20261027135354.149948-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027035431.1007584-1-charsyam@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C6C2380006
X-Stat-Signature: m6b7b9ithdp416bpdideu34dhkx31fuh
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793109243-302360
X-HE-Meta: U2FsdGVkX19dsgcxIo9jXMarz1jA2mnTuVkySIrsVM2lQpEOPCt8hsnY9JOSH0gDiDdeR37TajIgN+1AMuavOHik/3drZCrFrMD8Lr9gfD2m904uP+w1zP660i8kP7x72XmBrrLCm8U2GrUlf9QdqMaAlim8UzoRHFm8WsKUYISFkGwo32HvdfMV3oBUkZuPynsAIRkFfc6cc1VjYu6FnnFyJpIoNeTYPRVqTc4gqptcITfgEBrb3wmsRu92fJrbvYuMrwR1U5GJdcEC2dEpniwKbLnauP6TBy0Ceav4b5IJrhKl3khRYdFUewABaJiZ7j3kZagVz966lJgiXPI2zFjxTpWSzrCbMSmbJnIAdcHSzqcp/5myuiz1ZzSljCkgupZCpUe/IePURskkBTu5ElLqlUsNjO+gDAnjV6NdmT/dWN43T5RErwgtmkE5VMT/DQfk3eF5itWHhgHuujFzm0cjv0IE4Og7d/HqWa6VeL4s18wwVxd/dkDUXoWxvBJ63bjAZIr4AuKQKbO+QHQff90BqwcE4XHkh26EDwAl9IL9Tb5/Dmi6j1Cz2Zu81wbwFSIQxzhL5GbcwNKOXsQOlMs6lYh7VX5GHOiz9EJb3XUv89h48GndEg0EvJT1Ge+Tupcfmo0L/cWgVbbwQvsiqoGML+gc8Cvmt8cXjpW/bHf+00R9f6QvwzhUEvOZ63J+m4TOv7DK1ncUqCCtTjh5EMt0aj1EzKAEGhooSfap20L2AbPRY7aFJenUJ5+Rfa4wmEAVhi9NFhsUP/WXek9O2ZBBLBfVQttlNNtPuSaW8fyQm41WL1sMR1Rn3nioAUDsJwHrsYPVPJ5t4ff3W1IFNVTBs1Z5rp7jmBmoPrQRRkrw9BZ5DViKS2n/2SJhlFlp2FrQbR9ufn7achfXEX6vcDY732t2eKX9mYCuOz/dWAsE4A+dabJXK7ztStYxOkpq9WCQEn2UqBD32Rhxytc
 aXPXwkuu
 3fqyzE1D7yxkx0XHqaok6/eJw8HzlixqG4AserP34kbq+zloCRsaTp1lFyPcEJpvSL98f/04xZCZqmOch1xvY7jVH58x52Atm7190tmoHFADM7rx5OZtQ4Po9ZK8dHnw0uHjAZspMER4e0zrIvzQd+fSXkzpdYo9xa7oybhS8ZtvfrO2Q//z8fvgvUPrEFYZYoMOpDy3dBl0UauPaeSXRRjCVXEZ2nhFBGRAF8gPEV9qJE7/JA4JuPqLN8QC+iKS0ubUSgHztMpy9FWiHZp9xX8yg5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Daemyung,

On Tue, 27 Oct 2026 12:54:31 +0900 Daemyung Kang <charsyam@gmail.com> wrote:

> DAMOS migration accepts an unsigned int weight for each destination,
> but sums the weights into an unsigned int.  If the total wraps to zero,
> no folio is migrated.  Other wrapped totals select the wrong node.

Thank you for finding the issue.

But, is it realistic to have the weight_total overflow?  Have you found the
issue on real usage?  Or, theoretical?

> 
> Sum weights into a u64 once per migration walk.  Keep the existing
> 32-bit divisor path for totals up to UINT_MAX and use a 64-bit remainder
> for larger totals.  Add KUnit coverage for the actual summing path and
> for destination selection at the overflow boundary.

Do we really need to support that user inputs?  Unless we have a very real use
case that require such huge weight values, I'd prefer not.

How about just clearly notify users those are invalid parameters?  We could do
so by adding weight_total overflow check to the central parameters validation
path: damos_commit_dests().

> 
> Fixes: 19c1dc15c859 ("mm/damon/vaddr: use damos->migrate_dests in migrate_{hot,cold}")

Should we Cc: stable?


Thanks,
SJ

[...]

