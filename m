Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA545F45A0D
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 00:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 02F0F6B0089; Fri, 10 Apr 2026 20:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 006A96B008A; Fri, 10 Apr 2026 20:22:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E867F6B0092; Fri, 10 Apr 2026 20:22:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D767D6B0089
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 20:22:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 67D8559FB9
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:22:06 +0000 (UTC)
X-FDA: 84644372652.22.28BFCF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8E1DB1A000C
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:22:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=avzeDsWb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775866924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8uj4Ku8iqZBXLBbomGBblIihtnK4GeGD/2NUPbWgs0Y=;
	b=42Zimteyv1oVHoFi4NLpmx6udLvUXp6jxRbVzgfRJSUYi9ujcCRXpiKbsYIlLOgdKzN/JO
	2dJBhFP/wOc7SUe3cBLe2QOghGeUh+aRW8Q+9iSUCWP7564fjiSp0NNZnXyOSTQa8jUlqf
	rgaVwXB3GjSIGN42kQvJ+aTzXLjTzpQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775866924; a=rsa-sha256;
	cv=none;
	b=k7406/XUnwDSuNSuUVClo3NgkAF1oTDYPEoIa7puOrLU7cpMXQMgiVZb7XBgA4M9Ln455k
	Egh2G/BHIV3e6Y6RYBuWeXaaZ5u/cMb6QgvfwULrzoZROI1qlobp1/kKl+Ew4jp8+6BMfo
	hSWeUIH30XjXf3nnsIyVcDktgM1fXSg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=avzeDsWb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 57DF841925;
	Sat, 11 Apr 2026 00:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDBCC19421;
	Sat, 11 Apr 2026 00:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775866923;
	bh=kBiuAJsRleCAE2nQwc802BH6Pka0Eyd4qplz/R/dloQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avzeDsWbKMIlIj8DvJuHnH9XjqAKJtIGdak9Bn+h27yxmse4cmnu1tTqEIXxq7wYb
	 dpKuiX/5HPam4Jb2FJu1TqPCpJito4as02is2S82+4AQjk78N/hwU/ApcG3t4cUifQ
	 loo9ZEqIT5MLmNGhGcbcygvWYZRiYESEKHgbYndk1TCB3JmuJoZQh7Xe2BJIYGr1CK
	 nO+zMw+5D+pcGWP2Ffm3yTjBq1Ek4GJgtFMqOkA1IKn8MjeFpwlqMUjTzo/R4heqEU
	 5Z7JUVE6PrNcEa9ts+1/lrwGlN/kk/QVshfvzlX2WVYxWferX33d8lvBIis1grNpO7
	 yRbAdr7SadxCg==
From: SeongJae Park <sj@kernel.org>
To: Cao Ruichuang <create0818@163.com>
Cc: SeongJae Park <sj@kernel.org>,
	rppt@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests: mm: skip charge_reserved_hugetlb without killall
Date: Fri, 10 Apr 2026 17:21:55 -0700
Message-ID: <20260411002155.91521-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410044139.67480-1-create0818@163.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8E1DB1A000C
X-Stat-Signature: eb1bfr9gn1arcqm1apag1jqzwwjq1aio
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775866924-94030
X-HE-Meta: U2FsdGVkX1/Gw1PCU3izvx8l9k0IMhjOlDj1laJdjI6VK9v4yVKenclZwiV9bBTTQkXmZqT8LP8rgMQZKKohnfZgtBI4Xnma1gswLkZqq8B0aVMdq4g5V9wQ64JjMTg3IWLt8xLF0y5v9ylsYBYCdjJz1FCviVVOptZEjYf7Lf2kpbHUzCXjHZSKamHjzo/mDa3FUEnmQFZ5EY9Vf+l5rTdukwolLmMyll3xk2jFHsH3xG9jNA1RTv8D9OUBSv4aCaFSimzYadTHnnAY8yroIm8GN/rNIRdCkvjHBmsQQDM/eHHUd+NLLIQgxWgBxC6UsPh02Et4Dn1kW1Bpa+kK/tXBSDgZDaUjAoI6IhQyrV1TOtgQbETwymNeJb0fjfF4d4ijCihtHfZSx/d/mIgU0nEezqWmvqUq7L7ecmPCo+NS0Q+q2wmTT2hR8h2q8BVasn13cs7DMwOwOWBPJreRCYxVfHWYj+kA8xWk02Wixiv3lmZDK88aTWkmQLqwGNnPD3iHaa87Dn9uQ/7O4VO9cI08eFOJdxnnzrmxH+Inqm+hP3Y9PtIrcF7Yx9rFaIkFhvWiKDoe9WhVlcWtIY0FXThRfEI4LHqpEcNxrsMxfuI91hvu9Fsrj/4KpNjhz7qARzQ6OhSrpkUXdAGTVHRlYMCrXpczqwtce5I7PED9X9/7bOz1e4GcRLjYQ7n5eTwkkBuz+poKT3QmF1OUJ8u8KmfXoNUmyuC9BmmGtJnWLoD0C4CgNIiqXn/0oUWMa7uNj8TMR7Zu3CP14ozNOTDLAdR8sW06n3wVnrlmvQq4el/hnB6viOl5929KoETTMnZr8kkZ7ebSaJl2OaLa+vBPmb/EShkZoGPs5WBNqW0GxT2rfnD5AdW6PvEkur+WIh9B+jGinCvIa3MDoANqwuK8A4EzRAdbH+OKRiQhZi2Rw9BnySuWdijrLXCCwhTMk6jc4mT23W6Y8VLjFMeZ0MI
 tKtgrVbu
 4MvGu9NDxE2VOOHXnyOkfG3VivhQsU8Ts2PjUN0yU/jQkqka6v2pzp3L+yb/rnKGN2hsEQiwg3VwebiT63GvDj88qyg/MEKBPH44cz68GBVM1uH0pP1MKvHZ9lCACpYGPfV5REosUNeHO8wgPLg2ndw0mRxaish/n7claBuLZ5e7AzhYJUCX3YPtR/wS2zTL9dXlr39AVoOoUKEOGlEEa+RQ86JSPcST2a3Ii2Bl3V74244+9LSPHzKhnRLxusYs9Q1dtvEFHBnsjJdeuv5xqMIJOCWA2DAjtdGTQGzRS7fdZB0mk42OzOicEYl5XuGFdWDtxP0xlm4tTSuk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Apr 2026 12:41:39 +0800 Cao Ruichuang <create0818@163.com> wrote:

> charge_reserved_hugetlb.sh tears down background writers with
> killall from psmisc. Minimal Ubuntu images do not always provide
> that tool, so the selftest fails in cleanup for an environment reason
> rather than for the hugetlb behavior it is trying to cover.
> 
> Skip the test when killall is unavailable, similar to the existing
> root check, so these environments report the dependency clearly
> instead of failing the test.
> 
> Signed-off-by: Cao Ruichuang <create0818@163.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
> v2:
> - replace the PID tracking approach with a simple skip when killall is
>   unavailable
> - follow Mike Rapoport's review suggestion

I was actually thinking if PID tracking approach is better reading this
chagelog.  But simple skipping also makes sense to me.

Btw, adding a link to the previous version [1] would be nice.

[1] https://docs.kernel.org/process/submitting-patches.html#commentary


Thanks,
SJ

[...]

