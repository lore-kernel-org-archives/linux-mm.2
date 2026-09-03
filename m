Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E082AC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:49:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01C1E6B00AE; Thu,  3 Sep 2026 09:49:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F35C26B00B0; Thu,  3 Sep 2026 09:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4BD96B00B2; Thu,  3 Sep 2026 09:49:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA7126B00AE
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:49:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6A08F1402B1
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:49:43 +0000 (UTC)
X-FDA: 85172583846.01.C993CE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id BA1721A0008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:49:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FaeBrCsC;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788443381;
	b=UZoFQXNAhGsy6VKvnjInTPOmz+ncc5gfLz7Y8kgy/yzykPbzMQMxDkGMzRbFFRKQRHgJ6K
	ishcWhLHm/uD4BQz1o4g0LggPev0ZzqMNmCYNlPVqok4Ck8jIlveL3oBunedZfdt2nYSQD
	JUplws00G6/q62xDUcR4ZjvHzONg7TQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788443381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N1gBpF65Vg6Gyw/Zq6rh5fI5TdbcUPlG3RhMgbn70b8=;
	b=f4fUGrXHwIHAGeYX/awX5dx2D/uiVf3TcdlbZhxJdUznIRX3zSD/QX6d+PaiYOZL7tXSHk
	Az50NwOClnmfuI3CXXws+FyMnx0Ujf6FPY8R1A3ijbt1zv+tLBdc3YwDAjwsxZluLpguRS
	Ur2PUQ9ZMMw1uV57W+M5xMGXrNsn+hc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FaeBrCsC;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D9AE6053B;
	Thu,  3 Sep 2026 13:49:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 077FC1F00ACA;
	Thu,  3 Sep 2026 13:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788443380;
	bh=N1gBpF65Vg6Gyw/Zq6rh5fI5TdbcUPlG3RhMgbn70b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FaeBrCsCT6Bl7pLBp0xGDbAO+DYJ1i8KLk0r28Fs2BQlmHWX95+u0w7z1rZFWtt9a
	 bzf22vPAdGdjddw2VNxD6l6iA8fWPC7C8ChSYOWN6yWRu4+I3RrP1PsYUuuHqkWBbq
	 QxM94vcd7FK5QCmetDCCNmZAPbD1JfYCwo23k1OHDwhUZO3j2acgBvsPfLX/1tw+Pz
	 2WP8nPz5hfbD6RcBuWJYmuUyxsrfrquTRa7a5P8Krg7mQiQlc4Mju94kRehlcNY5VA
	 n7MX0B2q3uPo/lhZV3xp5pshTus3KAZCX/mrU4i87RNYTjQTVDMQXHKXkWhGIQ+UTR
	 LpX/YBzzGg3FQ==
From: SJ Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/4] mm/damon/core: copy nid for eligible_mem_bp damos quota goal commit
Date: Thu,  3 Sep 2026 06:49:32 -0700
Message-ID: <20260903134932.98268-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260903084547.960584-1-kunwu.chan@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BA1721A0008
X-Stat-Signature: cjkqj5ryxr81irsdpwbku6oahc6f6f1h
X-HE-Tag: 1788443381-947410
X-HE-Meta: U2FsdGVkX18/IWMxURPlm/T7eDHBVoCW4KN6dwlsVfBnjgyKsvWCEGIpqVCeijsH/yP4MK74tCnE/08vsRqopa6kqS/CGtjfBiZSWkQmoIrX4WdFLRIA0ShYTJ8bFKbCl3V+g+AYaKDeeOfXqLMwLVJBkJqlwRr5wciux+LQcF0KeXqPEf13l977677+n3hnnztkRPAGzyV5L+akMuHfrdDBB3c2mOiGig4xdpvmn06bJO0KXjtKmh9HquMZYNPi/x8TyMbFmZ+grurjFKmYIC489QIDbKvaJLkcamNrbuFi1zLN5OSqz+b3UA1OsATHXXpTKeeSpsffB8GjQ3KNC78C/mnlPGpeNJgdcHJmf0VAH5xHEhq4bsuUBrNGv8YhWoAhedtVqB5sZxaaltFvGpig94SdeKhiwnLONoaY3mxSOaFEHS3WDhyrg4ihsdZJAfHZzNAqkjRw6EJtBI84V+VtNXPeTOImnuWWa9YkNO407MMU2yVBD7MIt8xusKJxYqaeHrC2f4P4mIX28Ob3Q5AEs6wNcoi0isEnJQ3dUbm7qC4rob+wMnSAdTR3yEub/UaDnfY0UzsS+pvkvboWUIodUBUdDA90/qwbonrft7C+CFM/3lDtdH1MuJPi/37OH+2X7Qa7plefB83JcZ93IImjiXIml/m3NugpBGSnVJenoBjAzkf2v7S+lBhFepDnjQDBSoykloOiHyxy2YVE3mwmKSiCF0CXpJXLhQKhyHB8k7vV0wUUVbrroxZmNr2jpIgNS9TaGdBS5KFgbj2BoTUXLg70A3utOjNGUYIVFYS1IM9kT9dzzeItoNOpBVbvi+mQ+ItpzJJwI3ivPVu7rYnLI2qW/mSBrt8pVxv6noMlmpZEPs5d2QS+9ne2xit4EPcK4/pSFLEvu+U7xrLvnuo+K2/fCyAMXBTFoc6NnFK5cu65Va+5HP7YXBElPqIGcd0i/BSogijHJoswWwd
 g7veyPMK
 pNlks4Tba5bQ1Mb7/z6tJQmTLLN/FH5WJC0hnVGTDjjAvuHfjX2rmPd9DmyjnGES4ejbXKyAqKlxOmvP4BMO4iRVrhWRpd8MdkHgyNzQHkHHYzApupV7BmUPeokd/wnGcl1lwxCzDD0cLD8H4D2L0PRB8vj8N0Yx/8vQ1tmksGPn1vj0b8tt4e9hLHEKKKr5Y4QOraRQOBf63u1WI/wzg8J5mk9YeQwo7RtBVb6CojB1Cnbv65XDFsVFT6Yga8vbUh/KFCVOXOzD5Um+dZzwXHKCUVKesD9h6qcEAToIVXLudjfPbSpRFcK6P/rBxCzO5RxA6/F22a2SPVLrm4fAVCQilT8iXZEaYbuLelwyS4MQHPWIFt7E78jM38RAochdRYyRQVjtxCYdFjTvHKvq2WV0Wt7OCK+qsGNa7R0xNrNl5RjmbJ0xqiN5GuQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu,  3 Sep 2026 16:45:45 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrote:

> On Tue,  1 Sep 2026 17:27:22 -0700 SJ Park <sj@kernel.org> wrote:
[...]
> > This issue was discovered [1] by Sashiko.
> > 
> > [1] https://lore.kkernel.org/20260827045035.94611-1-sj@kernel.org
> 
> Hi SJ,
> 
> The fix is consistent with the other node-based quota metrics. I also 
> checked that damos_get_node_eligible_mem_bp() directly uses goal->nid 
> when calculating the current value.
> 
> One minor typo: the [1] has an extra k (kkernel should be kernel).

Nice catch, thank you Kunwu!  Andrew, could you please fix this when you pick
this series up?  Let me know if you prefer reposting the series with the fix.

> 
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Appreciate all the reviews, Kunwu!


Thanks,
SJ

[...]

