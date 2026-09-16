Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFB47C88E75
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 00:21:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E49776B0088; Tue, 15 Sep 2026 20:21:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFA386B008C; Tue, 15 Sep 2026 20:21:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D11376B0092; Tue, 15 Sep 2026 20:21:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF7A26B0088
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 20:21:47 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20389A05A5
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:21:47 +0000 (UTC)
X-FDA: 85217722254.02.5842FBF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 78D1C160006
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 00:21:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I8uyB34Y;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789518105;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G4LowGoWNcdFj3OSfkotqiKzOTNUTztLfprpysOi+bA=;
	b=MSfoBIXc0KH/v9VPPobxjwQA1YecIgp+T97Qdy9SvsOp4r6g538hsy7/f4usfrIr8uoe3L
	mGvogHxCZ1s+7HnFjoTNuitKgjPrEWUd9ETcOBUYVs85McucvL7+4eg7FRyfyfN8O7CN9c
	1dq7LE2W0dBIha0cHM+nij1UNMn5Dyw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789518105;
	b=G9JErOCGK21xFoEvAjcM140fqXLRl/LXDYCgE4ZoX2OJZtRagFMcrHDYImjaPSFhLx78ur
	7FBohSM7qrvxP6gnR6Yd0LwOHgNCSeBY0kz7wlOHYOBI+fzw2JFFSkz7MUQ5c8gRZWccbl
	FWJKVf9WIKqzePNYlMPXoiMctDkHMrU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I8uyB34Y;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A2C6040640;
	Wed, 16 Sep 2026 00:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4563C1F000FF;
	Wed, 16 Sep 2026 00:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789518104;
	bh=G4LowGoWNcdFj3OSfkotqiKzOTNUTztLfprpysOi+bA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I8uyB34Yay2zuDDBEnWmf6i9iYa0SBIDA+SwSJ8zI2PeKeWIewnl2eoVqeJgo6I6k
	 X2WYvc+6po4JPforGzAWrO6IljvYaL6duWElvitQSNLuY9TOzKFvYa0Wk3kJ47Z+Fc
	 kNlZNUYmma+CW3DQ2FRWTUd24BCMJDPn1LS9/aphG24Uew66N8dBiv9CJxw3nCwW/Y
	 O3VKZT2glvNxOZS8WOpJGk/PcBuzn6hkR0qUKb7bNQFMnc8ledAwA5UVYzxAbm8Ivr
	 +RtmiiW6mcSKrDEOGx7wx/fdhxhWts5OrUrEzbHWrRTskBtus+jJUKJnx9SfM49Yvl
	 e5I7ljHeqATWg==
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
Date: Tue, 15 Sep 2026 17:21:36 -0700
Message-ID: <20260916002137.101195-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260915060937.3423-3-kmehltretter@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: icpxe5xt3qh9mobi81rrc8wifag9pqqs
X-Rspamd-Queue-Id: 78D1C160006
X-HE-Tag: 1789518105-812497
X-HE-Meta: U2FsdGVkX18i8cdNH+2xG/F8GkiPH4IpEVsrRUIPiLQbKhnYqeR2WyP3aYiY7rwdSZJgFs1xGqnccXLvDcAYR5aLW1q+NU1vyTEBgG0lpi6x/IbSZJoTtma60CSZfqdxS55wwLHaDuAgtfjUvZDSL7AUS/74e/IpT7E45RMXF3PMEry9lg705mkO1txYs0i1CUF0mB2ad3FWStTwLQgkW5l/b24+5NrGKDzWxaIC6/hFoQGOzRbSLpKm+TgfmVa/gbEad86FMXQ+TpqkXgDjx8jxbBda/80uN0x8Uj0oBaOslmezL2sw2RgJucuZzFtfZelfKA/B8Qev2lAo9jM9W++VY+P7asKS5SDGrGUdql7Uz1R0dCApX2SeS2r/BES22FF0biqL+ic62x2sDmB/UJl4Ox+f1TRuQ33I8ia+FNLTou9rjHjPSJosZkYr8+SrZ+IfNOyiECblM7hpNBphS2CcLcjweC+p4BgpwNHcOjxbpA8dpuPzdukl+YG3TUNYsxyQYFagBdGt+Qhw/SipTIa7t4HddcGP6ovyew5pLV74mLtbLVypl6zwmG7p/oIosPmDn9gRSBmBqLRTSneDVUKA6R8q1FMa5YGxcboNaaF5DrnuDNyUDr3tZeyouaZ5bk3yFbATpxuuHeLNvZY5KR6HTpfPgYtQ0XTOaWmgLf7tKaQZ2NloPWJbnEANXevXbN+olg0V66P4jF612xRKcN1vTp3T7u/v3YzoHD+TqrcN6H68K544+tAEIWrux/Z+yu+Gfq5U+wx0MJ8u1XXjuwNhn2PW0fqp+/kf4E4pulAxMOEeILkqm+kwzCPQwWmSPg0unhj493DKV/ibVZkUU0J4pJEjwfpYhS30Qkst5re2M6tMMzM0XMKi6J55ysUCvsJKGKLc+WWYdt6RjjIzUceC0TXWzHF2H2GQ1NlYyHcS+zFC8y7gp8CfXBdUlrqjmBZ4MN/aUKiF4clS+jM
 Ll+Y5sXQ
 T9Hm0YSWGtKuYpZaRWmH39eAbA/ugDwgHv148KxbNS8XryDAP1X86zbkejM+wFSefalTVgFeo4OBEzC9tpfgknyce/RiyJ8MpL0rz2W29a4rimVmy1VFj7hckgbvMPpq1XzY5GfTffrF5qam1wF/LXiCqJKVetV9k5oh+7nc6dTAw0172Vd5kZEgRNcAVZOM8gZOnf1IX2PW8CpP1tzpkA1ToorA8MPV0jM67GfvLwB3uWXYH5/fZal558T82BiGxVW0dFss7NjnImFvyG+7yarLLTTT9gCyqk7spCUYkvS+RFE3c1GeWXnMJCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 15 Sep 2026 08:09:37 +0200 Karl Mehltretter <kmehltretter@gmail.com> wrote:

> Exercise a PSI quota goal under the temporal tuner on its first
> round, its next measured round, and after a goal commit. Use
> ULONG_MAX as the target so the goal is not reached during the test.
> Then check that a measured round which does reach the target sets
> the quota to zero, and that the consist tuner keeps its quota over
> an unmeasured round.
> 
> Without the previous patch, the first and the post-commit checks see
> a zero quota.

Thank you for adding this test.

> 
> Assisted-by: LLM
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  mm/damon/tests/core-kunit.h | 69 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 69 insertions(+)
> 
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index c01e6a75cadc..2b9b24ce7dad 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -889,6 +889,74 @@ static void damos_test_commit_quota_goal(struct kunit *test)
>  			});
>  }
>  
> +/*
> + * Unmeasured PSI goals must not disable the temporal quota.
> + * Keep sz * 10000 within a 32-bit unsigned long.
> + */
> +static void damos_test_set_effective_quota_temporal_psi(struct kunit *test)
> +{
	[...]
> +	/* fresh goal, first tuning round */
> +	damos_set_effective_quota(c, s);
> +	KUNIT_EXPECT_EQ(test, s->quota.esz, (unsigned long)SZ_64K);
> +
> +	/* second round: last_psi_total is initialised now */
> +	damos_set_effective_quota(c, s);
> +	KUNIT_EXPECT_EQ(test, s->quota.esz, (unsigned long)SZ_64K);

So, this test depends on the memory pressure level of the testing system?  I
concern if that could make the test result not very reliable.  Maybe we could
split out the corner case handling logic to explicitly receive the current
memory PSI total time.  For example, like what I suggested in the reply to the
first patch of this series.  With it, we could build a kunit test for only the
target logic, without depending on the test system's status.


Thanks,
SJ

[...]

