Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68102FD0046
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 22:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D36C56B0005; Sat, 28 Feb 2026 17:45:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE4A86B0089; Sat, 28 Feb 2026 17:45:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF0016B008A; Sat, 28 Feb 2026 17:45:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACCFB6B0005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 17:45:36 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 620978B33F
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 22:45:36 +0000 (UTC)
X-FDA: 84495348672.12.64009CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C39671A0002
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 22:45:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CAD9+Ez6;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772318734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i4I6gDFP+mvvxIPq/ocStZnHQyRu6GUt+IK+kzUY6rw=;
	b=CUmLKcL58PblqnWVvzBXVsWBlRDnnuBfwmDCBgNk9UkSt/gMly6q0ht6Lr8F98scZ4mNGL
	ZIo5ZFgZrv7X3J7Hixt+xtS+ragNR629XR2LxPAcCx/5ibGMafzr+ZzLJQb578CHZI/kq/
	m5PB5MJkr87YU/TKKGJuFxtfhb0EHSg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CAD9+Ez6;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772318734; a=rsa-sha256;
	cv=none;
	b=reWUoO+uV7Yfo4yC/+xdKlp4DW15fUQ3pzo3WJWUXSkKxy9ISYlJ0fifWejl2XQi6pCudw
	fVoB7JPhzD7SihCK3tLzFd+5i5oZ5f1zFo3MG9eie5Md0Z5oIhNuxnz83UlsoNv2FwNPKi
	gYYGncq6ZyUSOgNnHarhYe3KzQ/70bA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D3ED9423D7
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 22:45:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96AACC116D0;
	Sat, 28 Feb 2026 22:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772318733;
	bh=tSTLV3hh0zdv4JdwDyNz6FB+mBuMYydTeNeT2mIVrBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CAD9+Ez6erx7g95bkAj/O5d0ktZTq9tPGlqYkn2ljspqeuoRSB/xkVHZaFueltGZ4
	 QmfMDJ7tX83uzZdTYdoStfoazP9ixr9pj8FboVLQBQRNw4YfvrPVqut/WRXrOZ71wH
	 L8KyQKtrk553lW2VwkZ3zMGaFy955dNUl8K6GoqkN+Sjm3SgpNM7m74vwcAFp3HI1D
	 Jt+PtCr4MklVsSvfzjmzpORMQZy9Cnf1ziroX1Q2Rb2GEcg2Xpc2YggRNfi90i3NiC
	 QEspVcMLsr4vqi62QlsdKQiwhMPDzlUKhtcb6FzDljaVTty3vchqLQNpfUIQxGmBzh
	 Sr0/UofGmgqWg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 10/10] tools/testing/selftests/damon/config: enable DAMON_DEBUG_SANITY
Date: Sat, 28 Feb 2026 14:45:24 -0800
Message-ID: <20260228224525.8345-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260221193629.19332-11-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C39671A0002
X-Stat-Signature: ha8jkcpq94y5ija5nm1hwou85w1rjdzt
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772318734-272166
X-HE-Meta: U2FsdGVkX18TcGClOjoW9nW3PmeICf6dNXQAwxEqJCvHvkzWQHr64uHtw6PBYCooBc/UhlFZcJSzdeDHohdk8hvqpwJfEHoPrMTuLwncW30x0WuHE2B7FtS3HNhqkiBR4V+0dWlTZ7PS4vZVnF+srrho2B1xzWzV3ko0d/aV2IyUk6FlspbLnaUX1redM97v7XdqlDAKORtIPGHc3MS2yVhyUsowZm4DDVxmFV1J/7Ft54MnDxms0NauQhboBMsnqiU8PYmBUqSYl++IPD1s4aoDXD4RW5lk7/S1weHK5cDPqT+c2gLRwXmiZtshMFHyNcso5ods7tTLtdywYEZ0sm6biGzhfkTQKwK5Us6lt+7nLYEHJqys+0g6bYc7dWkck6cUglIulZ/qANEK3cfO6kxsAykuWGWh2bvUqAbZJa8h3MxooC5Znkdbaq02bEaTybP2FrgKgszTg0U4S9Ek3cDfQfMiFAbzis+s+nLNFgFcJOI5MzQ83M2NqkLdIOdXnijL94mvw8FRe18gUXThg5Isc9hwBHAvusg9eT+Tw6XKJiESyd+VNP3UXLzybQs31hbw1gt5XkucgLL+fdoTou/fZfK7ePvUPA5ohwJe2aN5ToW9ddAeAXmrtrb5MCqs9O94fjaH7R5jhHcDhHJ492ROF6DpBoFh7yWWLsQEIF3e37urxuEepZVRK07iyINX/wiG+tjqACwGeKJom9pJev7Vh+V0GgHIiaPjAFgtVxIgGNWsk+wf+41C2YcXnI/cJ3absVTbP4rn0ef83+BOAf76ApVM8l8ModA4QreyhGbGhesXef4du3WcrxEtOUmTar4Fmt1MXIQEpSbRM/qFFL62JT9izo9o2fELhWptJAUTVce9fmFn0XvtkxcWY/eTjh8cvbWh1UcpqR8Urx0T+Ihj+Wm/zrpatImI/rI5dPwMV9pIGUufT2elPZS0kJF8z5yc2sQWhZPWaUxffkk
 oTcy1Uhp
 CEn4Ii1zUUl9JvekfUGL7SMYr8P1qkGrZPIc1iWoZZVEiXPy20pXS/eE/Zt16wkQ34Ko/Xaz+AW2Uofw+CfClQZOJQ0IScTgU1SaLBQWgx4QLhjRmhDLFuQWMiNq5GZI9ZDkkiHniYeXwEFIlRkkOk7ZeqX/jDxIKn/vuGwKf7bSqgvy/i8FT/TL1ElXmnN/VX6qNgqN18KLvG4dPchLwi2sFxJQ6TSZxQr4TKjlcKagI7JlcjmVKFePgaaI0jR6diaUKNFvwFgwktwKPUbj28jFVxQq9WAi7hX3TI7hh6xA6RTIwzNuiHOEJDonwADR9uZoq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is more common to use 'selftests/damon' as the prefix of DAMON selftests
patches.  I will do so in the next revision.


Thanks,
SJ

[...]

