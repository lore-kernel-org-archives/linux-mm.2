Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20260F532C1
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 00:15:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 876AA6B00AB; Mon, 23 Mar 2026 20:15:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84E456B00AE; Mon, 23 Mar 2026 20:15:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78B726B00B0; Mon, 23 Mar 2026 20:15:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6807A6B00AB
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:15:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 12F6F160E64
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:15:08 +0000 (UTC)
X-FDA: 84579036696.12.89426C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 41C38A000B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:15:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sFN5xPhV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774311306; a=rsa-sha256;
	cv=none;
	b=iy5txfLo2lTEKHzeGmCuu9CPB1lIN9IkmxCIFCN2byyetT8gJQltt5fDKDZJaStISh5PwF
	DrKg8qip8oWFBdJUgY04wc9sQGyw+BjMLxuovXQRWhmIaxIgOUu2/HDCBZ4Yo8PRLHRGSz
	QXhm7wot3BRq0Zi5f8R/NfFkkWaVlIg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sFN5xPhV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774311306;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bfszvMF3hdftnyukf42jIlC33hVDq/u5fFC0mHPEiac=;
	b=yT3fAbGK0LxRVzKs9w/RXTHtL5Isw+NHkGbnov0UdXsb1G4gXfvZXKNYxwjNCIRcQsTelA
	gRb5wBrqwWyx8pnODa1tvmVBy/bocajbvSlUVon1Lb0h++pviPM0Ys9J8S37WoN3enBnf3
	om+ahq4aRJc0ewt+Js23+MhxDaHIrR0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 36D85440B9;
	Tue, 24 Mar 2026 00:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E209FC4CEF7;
	Tue, 24 Mar 2026 00:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774311305;
	bh=bL5TsY3mZar75uq4cPHULH9KGrxQsAUm5BHcGvhJ0RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFN5xPhVG4dpXaXm5iu5UF1N4xq5C6EUOpBzXqlbHMjbHJ7lNxLvm9Mf4aInb2HYd
	 68LkohmqQ3deRRVz1JGYGW691klI6MwF4FD+8QBUB1yDoMxiOSt2nw1K+HhzTIMe4M
	 2YeywJbauLPzC0pEDfScmvpDf7r3LAovvuP3CqMivbvxcCVyuwB4Viz/2JPoQiMVNq
	 j86hxvcDO8Mhd9DsJ8Vq75y8hnpYQofWtDcZywr/YlNCUMJ1zGg5ZPVpRKylqBWko4
	 V1BYUIc/u+8nP3FxhJVwIa3y/ZuXLG/aS23uwkJsZVNh5K85kknu3XECPuveZWK8OS
	 Bdu30t26WKk8A==
From: SeongJae Park <sj@kernel.org>
To: Josh Law <objecting@objecting.org>
Cc: SeongJae Park <sj@kernel.org>,
	Markus Elfring <Markus.Elfring@web.de>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [v3 1/3] mm/damon/sysfs: fix param_ctx leak on damon_sysfs_new_test_ctx() failure
Date: Mon, 23 Mar 2026 17:14:59 -0700
Message-ID: <20260324001500.86247-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <0E185D9C-311B-47C5-AF28-06F8D1235926@objecting.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 87atqrfwdp3q14dot4156hwdf8szm4c4
X-Rspamd-Queue-Id: 41C38A000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1774311306-445551
X-HE-Meta: U2FsdGVkX19WU3aXIRpAqfNU4/NJ47kOGTl7fdab0AwkQxX0Tn28uk2+6l7hPBlFIZ/habR9qcPed6O0IkWZAcyb+zVP6HJco5KsQq9Mocv1EZwPqeiCLdoyizTK/tiaQxemKCWw7c1mlO4NPttppYUZ2rkt2ByG0RIjpLuDn7bjLuZIP1tDZf/CgANzNw3bBxUbgYHnXRtFrp9lxKIPHQz4wsZloioWkGjaK9H9klPjHkosvfmqPi4vPUvX/DMiXdw15xKhXxvHtUxCY9DFw2uON1Mm7b4V3hpv9/AXbRbLIcX1ONEYFzyTZmngl5tGQeLVpFn4Xsu8sVYnbz+ilYUFyIdr/FsqXL8rWXXlUw20bR88pBH85JMBKW6Cr7HXupQ30VxVZDcF2c6RXyimUXuBhBn7oIa576jWHQFTgBu4dk34onSueM+wBKfO5lJgbLJjYEcJmpGhErmiv2m/GvhEIT4efLLribCtagfNX1k9/gZHKRDpDamiaND8XpbMsXSpHB7VfsKNNeHx2KXNF0vpajaL/sCCpgApz3Ipr0kJ1QqRScMtsZQd57I3jSN8R2LYtomk8ZAZz8urkcx1XYBsYcKJkSeYHUUhnlhGkcD5h5UHNCA5dBqSz4w18FmLqWFKb5OAPJvOvtGGKGCC4qQVAY7DyEUGBotCPed5LW5ao8rTDQPTq6yOebxa4SnZfQV5xp3PKfzsZcSHQ/sj8npQOzkaZxjcfN2hv5JKiuD6zLUbb/+U8xOySYHcuILKgMXQ5G+ESiZjicT6+G3Idkk8VBGI+kq1e7IIJ63qDQmUDlaRO48SOvtj+2lY7iqg9ikDzb3miTKSXgtYO3Gg1KkOz+JD5572Mg+jvXv/GG71/CsvkiMAVCy8z/AaV8Ix9BUZHBRY42utB7Zds7SyPcehORmLtfS22W0KMSok4MyDBnQm44ivvxUJ1mAQAKzTJ+nxhGHKbSCBpcxWDyW
 euL6+8GM
 Y2vHdiqQ1cCMVjI7fkXzmVWJ83HJkRI5/y+p+CHLnfskTG+Am9AXL+44Z2qpfdL8VA8RW6+oVgl9ph0O38DXmE5qXQURLmJ0zutuM3GVFrQpTDW/C9IIExq22MnfmZ/fOfINLYNznlY8byhYPq6XNjJz2cP+9tRLZ0WJ/Aq366VTajojrAU/3rwBTo9pwnn8i8LcYyWjBzgV9Gt492qOSVMQWFyotSPzr6fBiGpZ4J0vZc/EXrIuePWuupBgQ43WF2GIBf/7PbaQ7vQiz1G4aS9hpMmy3O5TJIG+O/ziWiGRrqQq1tQ2F2Zdezerq5EpGNSFntAtl4Wz1oWZS2GzEtJ0UNcrbb9rwKATEhwa5zCBJ/TKCjymX2T70NqGloOheNp/+pWc0ecH7JqsX71hqajh3CUMFqcjgA5W1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 23 Mar 2026 16:48:19 +0000 Josh Law <objecting@objecting.org> wrote:
[...]
> Also, unconnected to our topic!
> 
> 
> I've tried to backport Damon to 4.19 (for a personal android thing, and failed! Of course)
> 
> Can I have a bit of help if that's fine with you? The tree is based on GitHub a bit

Sure, I will be happy to help as much as I can without burning myself ;)

Seems [1] Alma Linux has backported DAMON on their 4.18 kernel.  Maybe you can
try their port first?

Also, what is the oldest kernel that you have to use?  As newer it is, the
backporting will be easier.  When I was in AWS, I backported DAMON of v6.7 on
the v5.10 based Amazon Linux kernel, and the source is available on GitHub.  So
if you can use 5.10 based kernel, using that could also be a good option.

[1] https://oracle.github.io/kconfigs/?config=UTS_RELEASE&config=DAMON


Thanks,
SJ

[...]

