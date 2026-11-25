Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 18ABC606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 05:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=clvSJ2ws
Received: by kanga.kvack.org (Postfix)
	id 387C96B08EC; Wed, 25 Nov 2026 00:00:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35FB46B08ED; Wed, 25 Nov 2026 00:00:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 275526B08EE; Wed, 25 Nov 2026 00:00:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 07D776B08EC
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:00:39 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1603A1609E6
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:00:39 +0000 (UTC)
X-FDA: 85472440998.19.CD66C50
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5AED9C000D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:00:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=clvSJ2ws;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795582837;
	b=wwpjtItYIU2KTNASiSICXNh0az46spvtzLaCZeGDmc2QV381Uss74hrWXPJwUxUvbPJdmP
	WC6pwLfw3KBFxU7dl8g4BewQn7aCUdOMO29slqD0KuddAjCXhjVHuowvQZt78e612tbD1G
	EP70LeqQJ872WdeQ6HxjhQTpzy7Hpaw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795582837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6/DyrLQAwnaVdIlNNu/TcqCjNECAIqfAfCTOu9JpszU=;
	b=gbA2lcZ4Z8+gb3DnJpCRlRO8VvEWHxBK9+MvK0XqNknVZawmZKlJJcHGi5kWQ1lyRRB5uL
	9Hit62u03M6G5Q95xc0BNp6fmdKN6jKElvfOfuz+C293nZNy4NUYuOOAe3k5N4KSfIlcS1
	SO2RNV69DYjcN0hwkICKIHUt9PJSEAE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=clvSJ2ws;
	spf=pass (imf28.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CC2AF605D1;
	Wed, 25 Nov 2026 05:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484571F000C6;
	Wed, 25 Nov 2026 05:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795582836;
	bh=6/DyrLQAwnaVdIlNNu/TcqCjNECAIqfAfCTOu9JpszU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=clvSJ2wsEVPXgdnUPsGMilKqq2Vs7zlX+sEDEY2h0DNxB6u6sHU+6YIYZBPI9xAUx
	 OD6DS1EKqMljYfDZxJGvlXmGqkW5TnhVbIes5XEhGopFf1VwXbeKg39oH9AcUDwRqb
	 tfNO1mummX160mXsQh3fPgYO0DzKKtzNRoMIGhT5u3nvbBFxzRXKsp1t0ajNbZRlkW
	 Obc6p7APVSrrS65Y9yh6jpr+i8CC090I8N52djW7hkcHCMENZeKb1gxgVIpYz6x2V9
	 JCGeZDpFRyLN+ZBVVNtH69K7rufxntzJsyO5hPj/9tP0vPotsT7YrW+y8LPaQNFrms
	 yW8csjpMktxVA==
From: SJ Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "linruifeng (A)" <linruifeng4@huawei.com>,
	akpm@linux-foundation.org,
	chenjun102@huawei.com,
	tongtiangen@huawei.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon: support freeze kdamond
Date: Tue, 24 Nov 2026 21:00:28 -0800
Message-ID: <20261125050029.100568-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260409140609.59881-1-sj@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: e89rfg16errjunaasju8up8p3nm1qi45
X-Rspam-User:
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5AED9C000D
X-HE-Tag: 1795582837-29217
X-HE-Meta: U2FsdGVkX198gG9sAPRQXoLtUv6eAI1i263x0Zs0RPDIZRFQBpbnhgkqyMuk91mnwmm5KY9BZ1SahdHLcvKoYLpg9T+NRqGyeDDxgzoIQwKEkcAS3jCJ3/PmGOPgxiko9erwqULQpSPwyWIvEQS07xPwdFq0vjg3oCmpSbmtQgI3+YKz28SP5OwurTfqutCQBMg94148YWEYvDOEaBCI/wNgk+rCwqryfHcwBFMm1NAMjomtcUhcG2SNZUhpGuaVSNehGOX045dlkmqoFle9LNxl1iG3xTGyLs/vxxXvVvaBiVKh1S6R0nWWGJPKQZ9k/Kaly2jRI4oC6tPkEpa94juEIOR+A+7zZ2wnpnkDwmqvSmrvDQj8OHwoIsinYz3jMWz7DCTJVBvtVQFo4jtisu46m64rSFo7M0KZepCEatedEYqJD71c6fAnSFx5Zk5/oSfnBE6RzYB7wOVL0A90dJeCPkOreu3O/n0UmAJfJ7+OQ+eL43OvTaSeO/j+xIAwUOF4IDgkR2ootk/PO0IBGuYj8RTbrFIrBIVHAD9bTEgvvD+QSOJ2yUS5QUCc59zQNFEtj4y8U4ty1DUXO0l+0TsiWso5Ke3nMbjyDsXtSajbgzfPVV1hEftbgh4UL+0TMiiKwjAiSlkHlXLwWYhelB7bCmKqbh+2IyekZn+2IsaRJAUdmQpajQP5p+FbyaxJHML7XO9444BsRk6q4PC8seCLNiNDfEVLPSURlC0H9xE4xPid/0JFT9P3a4sg5HFZfziWxQGP52h9SVVLhhgC4SOYIZrjKFpZ76zVNJb/iQLCkkR7n4lwFWfNrfZpcqjtTRF5gMCeY1El1VH/OQsFPNx4BYxL+xxWJ778I+UIAxW/fYOge1IRfvIo1CLcCHVJ6fuiBdislcw6mUUj4Ba01DLDjeFik5z1a1pe4Nd4MA4B+6vQfL8mx8U5HktT3twjytuEySnhajH8EMonwe/
 6tT9EJgj
 VdoQrx1Y09tG3Q/CoIuStn+12iZ0Ar3pW5CNozJOlzNnpKyotWd19JDd21eYgbqbfmGK39dK2nsCOqmpVgy4TaEcLM7Sos1a3tOi7wCplz+Ex6UY1+uJ51OGBv5Gii3P20vfMkTPpfsOfbijZjr3E8iKhaQNZeH+JRAFiFDwfVz595hXuepfc8RLCuhZZT1FaCWJozKuNctqE38gqO0d9ndFnX0FxXcmSaT65opWooHaRhFn5syEFKbedJgbA68FRBNfGD4ivOH8XK3dograyYDxF48JQwBLwARQlMtTgj3JBQZzqR7hI5LcBYl69lu+hNHwHtnpH9sI15LDWbM4IIpRqz2EOD62KEg/qcl3sxpQLWHJ6c32TyIB1I6M1DpvOgTaQQnMgNi6Mq4K4CnW9JGXwUu763GOnf026VRCz0evTMK4InDprMyGBFDHH8TH6yrk2A8OhwlHdx5SEoqHbhGeiQ1CuLryuMOiT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello linruifeng,


I was thinking how DAMON would work under hibernation, and recalled this
thread.

On Thu,  9 Apr 2026 07:06:08 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Thu, 9 Apr 2026 15:20:10 +0800 "linruifeng (A)" <linruifeng4@huawei.com> wrote:
[...]
> I feel like it is reasonable but I'd love it more if there are more concrete
> examples and/or observations that support this.

I now understand following problem could happen in theory.  If DAMOS is
configured, it could migrate or reclaim pages while hibernation image is being
copied.  It could make the image be corrupted.  As a result, the system could
run with corrupted memory after resuming from the hibernation.

Users could work around by stopping or pausing the kdamond before hibernation
is started.  But it is easy to forget and cumbersome.

So I think your patch is better to be added.

Nonetheless, I think you should replace kthread_should_stop() with
kthread_freezable_should_stop(),  Otherwise, it could have kthread_stop() /
freezer deadlock.  By doing that, try_to_freeze() call wouldn't be necessary.

Would you mind posting this patch again, with the above elaborations and
changes?  If you don't reply in about a couple of days, I will do that on my
own.  In the case, I will add your credit with Suggested-by: tag.


Thanks,
SJ

[...]

