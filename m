Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACAF5EFCE53
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 00:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E59DC6B0005; Wed,  4 Mar 2026 19:55:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDD786B0088; Wed,  4 Mar 2026 19:55:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDFAF6B0089; Wed,  4 Mar 2026 19:55:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC2656B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 19:55:06 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0FA085A782
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 00:55:06 +0000 (UTC)
X-FDA: 84510190212.24.FFC42E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 57AB31A0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 00:55:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="oIN/AhtU";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772672104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C9dld4P33j11Q39+FhGvjRASTVT/S76iHfy+Plj0Woo=;
	b=7cBhhvwoN0FUHO2Uty7a+JaZOGHNRpf1dX8mzCSBy5BRNC/5q7AcKBgWmsxXU7rCpx0+P0
	62997QUmJioVtTvsoik4gcUed5EgFzsFqWSgcJfmhmWtx/t9Ne8KpFX88EODj1FybU3KKT
	mJlFROjoswYgPTDCvzRmYdpyJU4aExc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="oIN/AhtU";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772672104; a=rsa-sha256;
	cv=none;
	b=8XpgqX6F+CTvUm7YVX7osN3/5xwIubeoHYECV6BO8YCNhesdJo+mVNvyxJ8oXGK0gir68L
	M9I24PUAV9txJ2nchto7vIx6LZz9B8sho4Xy6xHL3/Mlaf+AWKFxFiUvjNSwjf8JjDfQ4J
	vMPrwd2AVkg5b6u2xDHiQcyPgP7bbF0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A47D437AE;
	Thu,  5 Mar 2026 00:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4379C4CEF7;
	Thu,  5 Mar 2026 00:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772672103;
	bh=uhkqqYzBgXQddoLBpJs6tjXLYsyzjESovm0d5V33olA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oIN/AhtUYBiRZc8RztJGdli1WMuzIAe7Ns92DiKDrN7LBOqV90Pq6iL5qTvpyGjCA
	 1ZiBhxjFKaarSNLWc5Se3ol6yUaeAkrjG+eusCOdPwyLBvOyMYfEgpaTvlXZUcBJCx
	 cfsRpwEWbpKxYjEesifJGqJf63vhOZ744iR7AWlTHHT1Uov1u4aYQXHezPxi/S6R5J
	 /GAQ7OT2OqqYLgxgtYCvULQBdwM0B7+/R8xUtnERyBXIDjXNZ3G0YKakH+ZR2pGKWY
	 Ujsi1hpXPrLJiods5PWfqeOU3bmIElWEGoKQGkHhCu0Qjp9WAykHcXfUhyCR6wJ3ED
	 q352Y6LvRvPkw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Gutierrez Asier <gutierrez.asier@huawei-partners.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v2 02/10] mm/damon/core: allow quota goals set zero effective size quota
Date: Wed,  4 Mar 2026 16:54:57 -0800
Message-ID: <20260305005458.26137-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260304145140.172293-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 57AB31A0005
X-Stat-Signature: m194d3oom3f5sar8pipnihajo7pfnynd
X-Rspam-User: 
X-HE-Tag: 1772672104-464844
X-HE-Meta: U2FsdGVkX1/CS94J3ILm6EDYJDUaQqhCFAoUiUVZ3xgSCWyWAZzyKxp7ESaK9MqZdXaSZqiafpWJ2XShdrc7D9oRP41QHeq5p2JeuMw31AgSJU42g5DXcC6b6SHgpFhNu7WL66+SzjzE4GcX+e06qAbX7tNQVhwfVEyeTA/UtSgEP/xMHEQXMQ3k194XzmFoFojKD3uMii1xaAcfqv3dY4MvAPCwkM+Tv22l0tjD+VyfUaq/iAZBCzJK6Jq1TZE2wGXt7y1Fo8ez0gg1j0k1bh5KWRmhEhr/gesYUN9I3rig4qtzi+viKuJHHXNWYJXVmEBLjAVaFTo3gP73Qdsnyifw5+jz5H8d6SZ20RfzcFZwOi9uSn8uFsZP42/HOHl6AlprEHr4b/DJvOI63o2z6mOxgZU+Wue1cpj5ru550KcWDBaLQReOaNY8KyqIyGA3FlsQlFKKyb8qwVJMReEpicJ7fO/d4uCCJ8t39AV2IrZ5XovadsFCDduw7wp3w6Sz+CxX56oZPvPgYP1G1B5nBw/7QYpJsVh0+e6cDuDWARgH1GsGQMLErfBVlm0AzjRl9ChspZA4XV4KxGqQCj+n1tQXks1qTsGyCWh0RRHPCGQNe3r20/3wMu58Q/raWY0mIfwrs5Embl4iOF3c8mQW9Dqglg4wdP1240QjFQwkHNkANbPKyJtCmBes7vEWQA0AvLBxkfuCMj4MVfkF7sPfD0ggnm74lXkycOOlgI62LS5IxVH8xXFWI6NceI+e36MvnZEhR3VVosn13uivKAVb4l7SglNJZF8TgZynr5aYb88n3BrGDcTW2q71L5h5zN5acKeLcyQBnsX2j+70uJPdZKJIxRA/9ia2qYNc3gUrKBDyw34dtbrhjwNYvSliCN9Hot6Df6eSH9Xj0wtb7mmyBsIWkkD8ynAsPemTfvdNPK+F4rXZKTWZURwL+kB8ZScobJiVzvNOj+Pd92ENhaI
 EpbYDM4V
 XnBzROnNPyppy0jC/ygsjpKT3Htz3GPew2ADHhDtcJ5TBHaXGkliWKbt3MVu15tMOyIfAua6B4v0le8f//N7KoBoU38BzRkJXYbab54iR0bl6EsotB74cFUa3bRRnXHJhTSzxEbO5dX+rS5NT6pKwYfjR+lZP/ioC4tBK6uySEqP0V5orYkmmuDr/eWjnoNqOzvv/0DpFydWTf5F0RS/obDdJfiOOnEv5HM29G/DzxewyhecmlHKjHkRvdEIXgIya3A6xLVazQg3Lx/mH5y+sOXO5qad6gtwVJZmw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  4 Mar 2026 06:51:39 -0800 SeongJae Park <sj@kernel.org> wrote:

> On Wed, 4 Mar 2026 13:18:16 +0300 Gutierrez Asier <gutierrez.asier@huawei-partners.com> wrote:
> 
> > 
> > 
> > On 3/4/2026 7:41 AM, SeongJae Park wrote:
> > 
> > I find the name of this function confusing. The function doesn't
> > actually set anything. Maybe better damos_quota_is_set()
> > > +/*
> > > + * damos_quota_set() - Return if the given quota is actually set.
> > > + * @quota:	The quota to check.
> > > + *
> > > + * Returns true if the quota is set, false otherwise.
> > > + */
> > > +static bool damos_quota_set(struct damos_quota *quota)
> > > +{
> > > +	return quota->esz || quota->sz || quota->ms ||
> > > +		!damos_quota_goals_empty(quota);
> > > +}
> > > +
> 
> Thank you for the nice suggestion, I agree your points and like the suggested
> name!
> 
> Andrew, if you pick this patch to mm-new for more reviews, could you please add
> below attaching fixup together?

Never mind.  This is an RFC, which is not aiming to be merged into mm-new.
I'll squash the fixup to next spin of this patch.


Thanks,
SJ

[...]

