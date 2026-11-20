Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A9A606A32C
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 00:31:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TVe8L4A6
Received: by kanga.kvack.org (Postfix)
	id A4E2C6B070A; Thu, 19 Nov 2026 19:31:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FEBE6B070C; Thu, 19 Nov 2026 19:31:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9156C6B071F; Thu, 19 Nov 2026 19:31:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 757F66B070A
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:31:40 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0E5AD80D24
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:31:40 +0000 (UTC)
X-FDA: 85453619160.09.198F9D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 7231F100007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:31:38 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TVe8L4A6;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795134698;
	b=TGlXC6AvbB11jG/0aT2APlG1hHsYDGu2tJkozzplIpCX1F3BGUeLmIYxahz7LYDXbWhCJC
	X/R5NN07xQEAQ0dYLufQDhy3EJwDCRyJebLkUHFfBBfw2jKKe5AxE8V9xTvY9kb/Sfhg/G
	ymIWZsd+kDoulkffqBVybXgeejePd0s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795134698;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FSLKH/ZOja5ZsyP9KHbldn9we9OtgyfCNQ24loR9CoQ=;
	b=n8Ehg2HDr73n/aIUkyStSrysip04DyKzOqBUhdzVfrOejw38tQrcGce9u3Lg3wKU8IDv9q
	HsJ7DOuldOTKsPWdMLAqw6h98Zf6sJCurptSCeWjZAUUrfN6G0EOrf1GdaX0A1sLs64h4f
	XFYfr0Mqshfu2S4scuABzAFpoQhR1YY=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TVe8L4A6;
	spf=pass (imf05.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CF28E6193A;
	Fri, 20 Nov 2026 00:31:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DDAC1F000C4;
	Fri, 20 Nov 2026 00:31:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795134697;
	bh=FSLKH/ZOja5ZsyP9KHbldn9we9OtgyfCNQ24loR9CoQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=TVe8L4A6oRe2k4jkjEWYow3Jfj4qr6RGzbiDtpkgbmV9hrm9gkcbKcVmiO/oLgkqg
	 EGYbtUfeMii9ggOYIFakAwnomI21GJDZyRkkStZAfOxC249yZuMCmaq8pofFYaw7A6
	 kwKycNmrcuI0pnINtk3RLS2TfJO3MmRKjGJ/6rM/dPFEaGS/6UMsWphiELZ0sOz5/f
	 IgV19Yf+TBl0X5B/hJTNisnVPkffkXv6Qa9SDWpTaMTSKRlk1INxulDsHlAswulp1c
	 RIBNG8BaFpBzFwdgQPvKFK1jpow4hq4BqRdi5y51gSzJGxQ4Kppp/XPKpKC/I5Go8K
	 eHgyFOxmHnf0A==
Message-ID: <sashiko-outbox-224267@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/damon/core: fix damos_walk() hang with zero
 watermarks interval
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yifan Feng" <evanfengff@gmail.com>, "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261120001300.11809-1-evanfengff@gmail.com>
References: <20261119014247.119946-1-sj@kernel.org>
 <20261120001300.11809-1-evanfengff@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Nov 2026 00:31:36 +0000
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7231F100007
X-Rspam-User:
X-Stat-Signature: xd8rgqnjoj4s4wa4c8w8jrhpons38zxy
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795134698-592884
X-HE-Meta: U2FsdGVkX1+e5KmqRRwDu7kaPyr/yEzJvNol+r+0XPhxhDkkPsyZWiXyrThx/LIV0QLypFa3yoga5YQ+1OD+g4UeLkPSSi6gqY/v9sftDGKTWRzotXYxPwupoTh8o1B5z2DWda2blV4+Jh5kLyYuVuR4cQr5xANm1MU40pCETOai+ie8komTN2kDFf/3E2nNpngMqEGYcFYbfFBXDhdbsqwv5c67KVwNvSbu7Lv5KSLjX2xe7twU5JhyiccSEM3xYWWqcWJq5vW0JGriMcqArIfHIbd4A0sZodX00BcH3zi10KlFN2Qd2TUR54dYhJMzAfAD7cJAJEbpBX8la9hyfh+AxMiGtzRc2vxx3InPY3fqdLmmAxoVYJzDV/EUG9I0j6roYuIIUiYDqpUWpkUifxBHMq/OUOnhjuZCU9S9ozre1VsoYG3rLY6R48nOHnglJ1Y4ec+pmBitqKLzJjjjycUlCA8HrGFZrJ5a/S2kTwoNY95GjtFmWJHNw5V+btAmOcbAEysgYczos8NSXWr5K/GsDQBHyJJMC2j1RrGUV72X+VxSrNuYU8qFu9L7iWz7iw/qGlctbeM22ea9pmze5byg5xKG0Y6JoPjLSGTcS8G4T7IEQkG0nYgBWlTiE2BGi+luRhhQ6WyZ0wc6G3HQBB/LGVJKyWI7XfFU8ul3h0ARANydhEQvC70QjmEst5k3MKTAjUwlGaqfyB7ow9JkzImfy5aDYPZKp93dnkK0cjilA5hSxZsvOkdzHn2rFLuOQau5rB1WeQOjiLAOiTP1KK4ApLJUUzyXcMmEtqOnGn5E8j7ciRtGKQvnNtCFLaDbhDpKJnc6TXx+x9vLLtMN/RUZkKe0SLW8B0wA1nN7tj/ziqir6OudGyNxK7ujkjR5ZTVyJySczvmc6IeK2L/+teznIaKoASmad0SEbZdI/ANXOYN60JWW8/hCUy90vnUanQXT1F8pG3J3ZAJ6Wqp
 HC7a/WaY
 gl3c0WcC+jX7FF4WNxMJDxTBX7XhqEq3rIvHez4F0iWZ20NMTkHc7CUBnlIb99Ce0rq/P0F0pZ/sMU12O/VIGQE8RaJC67Ml2lMLaL1MmaEHjxBZ9YB5m0hEJ6dVUYGXgD337+r94rVm7/MJ61nHQDJ5wiK41uJlg2x67dHAgU2PAB/Lui7ut64UkSyTST024o6PlJvGvxMb5T2wEakSw0jJRXa90Aw7wYaZDokh4exxCFNtMczqQsL7tVAeCoPxEy9+Ao60ONHqSZt2oZ9v/t0VQCgGh1A2NyBOE/NyBF1LEv7obOluToMih7LwLD6GFxGLGsehqXlRSMF21djhrQMZHSmz1CjkXLGJeulCqgkvS8Qw36CNRdTeesM0beSZ/jCBT1DGYKcfMntXs+BGAqAfvQrWevD2mjJuYSqdLmLUFUaoRCajsNQQ3ujDBRUcGYsGGAT3l8pLJ0PQaYirDPNvw7bIfKjjUcdbG1jvESAr01jAtVoJrhVTyj87Bl4gI898VJIW3tgQS56OXB6mJNzBwkawJCIu7fZF6W3ZZzaLvErLeT3ZmdV4N+Bj1MFKR782UB6KsjRBS2TpQJgHrWdw7T/eE2DTl4F42Z96t9DxsVDaiHtGhw718txKlVj4K1TBhkbG/yU+mF5yGMtH4XZcKKCOESqTv/pP/zxQ2+3cFk+WDjqGfIk7PQBB8m986YvJd0qn8spWRauU0nmf3iUASDEh/EScgl7LlEdu8FKE4I6qSzZtXUKFvZ8Hjh0yRh6XVCMsCwAmEaSNbgtOMWuXWI+Ip+6649xss58shFS4D6hdwgQIOLtcVq14vTprKBj+f7xngFTwl9O1MtCoMfweJQuBupRqciYUpWo/GloetJt4qjeMmZDf3aia6uPXcV/i8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential
issues to consider:
- [High] mm/damon: missing Signed-off-by trailer in commit message
- [Low] mm/damon: commit message body is an unedited mailing-list reply
- [Low] mm/damon: missing Fixes trailer for damos_walk() commit
  bf0eaba0ff9c
--

commit 47dbaffa25c5043afa14731164c912784e9890e4
Author: Yifan Feng <evanfengff@gmail.com>

> mm/damon/core: fix damos_walk() hang with zero watermarks interval
>
> On Wed, 18 Nov 2026 17:42:46 -0800 SJ Park <sj@kernel.org> wrote:
>
> [...]
> > But, this could make has_schemes_to_apply has false positive.  How about
> > calling damos_Walk_cancel() when has_schemes_to_apply is false, like be=
low?
>
> Thanks for the review.  You are right about the false positive.
>
> I tried your change.  It fixes the hang, but has_schemes_to_apply is also
> false whenever no scheme has reached its next_apply_sis yet, so it cancels
> the walks of activated schemes too.  In my test (one stat scheme, default
> intervals) 18 of 20 update_schemes_tried_regions writes got -ECANCELED,
> and two selftests fail: sysfs_update_schemes_tried_regions_wss_estimation=
.py
> and sysfs_update_schemes_tried_regions_hang.py.
>
> What do you think about cancelling only when no scheme is activated?
>
> '''

[Severity: High]
The commit message is missing a Signed-off-by: trailer, which is required by
Documentation/process/submitting-patches.rst to certify the Developer's
Certificate of Origin.

[Severity: Low]
This isn't a code bug, but the commit description is an unedited mailing-li=
st
reply ending with trailing single quotes rather than a standalone changelog
explaining why damos_walk() hangs with a zero watermarks interval and how
tracking activated schemes in kdamond_apply_schemes() resolves it.

[Severity: Low]
This fixes the damos_walk() hang when all schemes are deactivated with a ze=
ro
watermarks interval.  Should the commit message include:

  Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120001300.1180=
9-1-evanfengff@gmail.com?part=3D1

