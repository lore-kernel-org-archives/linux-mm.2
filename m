Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0904D0E6DE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 13:18:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1904A6B0011; Tue, 25 Nov 2025 08:18:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1688C6B0022; Tue, 25 Nov 2025 08:18:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A4EF6B0062; Tue, 25 Nov 2025 08:18:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EC5FB6B0011
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:18:25 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 97AEE140127
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:18:25 +0000 (UTC)
X-FDA: 84149183370.20.39B116F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 07FB81C000D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 13:18:23 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gV87SkFb;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764076704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pgCxIYHEQfA22YGlPMxky8DJplHtENfEj44WE3j2M/0=;
	b=Ca6RFq5k9fYrv7hP6zC1o98HS0cinos6elNxok8NEzJbefwgN2bBCkqnkDYicjDTpzq+Yo
	4A0kjiyNMIjWpaVl5elY3WZMLeMlejzbuSw17adBURrzNH7L3k13UN4dtovWxyalYVJVJq
	Vy3M7U7V3OH96oZk/P1Qqn/lQSKqJh0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gV87SkFb;
	spf=pass (imf21.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764076704; a=rsa-sha256;
	cv=none;
	b=L1f0K1cO8H2gHk+QlXdgylJwsvqv5o4Zr6W8qMBN9kT5mahiYWBkSh6wuoX7+GFb2gJ8bO
	ufeKjv6+J9OtRoMKpOFm8l0BHeRMTietGMvuBYSwJZnAe/kelfZTZGpMY3izxdkPLvGJf6
	T7mLXH4/yXC+JWyu02Q5QQ1TuPn4zFQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 866176011E;
	Tue, 25 Nov 2025 13:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF35C4CEF1;
	Tue, 25 Nov 2025 13:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764076703;
	bh=ZKegHKbW1uMjjAwWvKSDoAguaNEuYrZ9rTK5/L6/Z6E=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=gV87SkFbYBCZWBffDjqyiYcNhE5TCFHDo9JNLCvrShY5ZfLRFzr08B+qTfWat9e6C
	 vn+O5sqHPJPNCaK2y2cHhC9cc++ZIuTkcosfQkEJ7fCG6xmis4yuEBROEr9QD45vpy
	 +4OshqdvdM0OJ3qb5TpzS58XgZSQnBmzVy9p4xOQ4PIwB72Kqn0DUG2buCAqjKSZzW
	 PVMDwGQZ7c19m5hdI2oWYy98Xw+M2/wDN+DzhiXbR1/kzSU7AS7RRQPgPP7XPlyOXE
	 MtMpeafjQ2oVCASU3pOGRyt6yFOMHkM7xy6ZXAQJZ8XC4lm7kTmCIAEYU5EX0fsYDU
	 ZSWg4jJLkzfrQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Alexander Graf
 <graf@amazon.com>,  Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush
 Yadav <pratyush@kernel.org>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kho: kho_restore_vmalloc: fix initialization of
 pages array
In-Reply-To: <20251125110917.843744-2-rppt@kernel.org> (Mike Rapoport's
	message of "Tue, 25 Nov 2025 13:09:16 +0200")
References: <20251125110917.843744-1-rppt@kernel.org>
	<20251125110917.843744-2-rppt@kernel.org>
Date: Tue, 25 Nov 2025 14:18:20 +0100
Message-ID: <mafs0tsyiw8rn.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 07FB81C000D
X-Stat-Signature: xww8k3j6bu3h1cc59htt11bscbdtghhq
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1764076703-124620
X-HE-Meta: U2FsdGVkX192M/B9wy/+g20Xjnlug2s3+tjwe3IkdLVL8H4ptB8bSNYp6w+KdnqRJwE/gODvLHSVEX8bvL0K1z6GfIFHLLmDDlXgR+ifZ644P9kfD3Yc/6fTAQSXy7ekgt1TSAr/CBRmS9XjoqHHJciWi6B+/tQunrFv9O2f1zuC2HKU3GDlvvNRPyRcawSxuyJm/pHfBlLr8ALfiX1xaZnDV71r7mjbHBV9K75OZtX7aGHyZJFzOo0+f79S7anRzNhyaJKLENooRapizs4ri+05pizVs9BqVxBj53YHYVt1RV7YGeR2lNQ0hn7YYMXuX1jVjyliYY4NfHAx1g+dZpB8Yr6qZ6pncOgsesE5aHTez6sJ0OzqNRN6MpJO68pv6ZrWqr626ZAhZ5Kjd6nLGQuMgM7tYxgT6mFD5aPFJ/ag44gBHw4HxO176eRkcQ1jcg4rCqSlB2xGtnzPpNimIcIP0t669vYlB3ZrrWxp+ATLoJ6dNcfLTspi6xGMFJV0KDxMXZizuNkzkONyjAdYlAMTINeqxgC3KOqKvbsQbM60JpS5A+OZ358T5dj/5Uj1qOXDpayP9lgRj/TSF/08bdcYZEvlHrHYE5tn/Rmltzggstz58JWQF571t69rMHEzonNKlAi2i1RNkVe95q6efIEvvGmyMfohnTW5QnMNRo5LbyoRtjpGWwcsV5w5naTifWUK0HENMi5LbQFplhVlDHP7HMZIRKHiG2ICVsrtr8KVDGNMnnsBdtfxMb6U038g9QLxdJ4gQWR7FUonMoMTNq5I68nvCEYL1VA7y5bClOVxsqhWpjLBm6tUv9BhaKKdNIXYdvv78KPqkGAiVCOQHREnLdZo7MIvy3wV9Dc+uJjG/ltpDXpTGrBOdiD8135kVedG2jqC8cnINPr6xmviO1sOhyrFEBrNHRlmDJhwOkxcU6zO8eyh5UUF0IKF+1+9u1XhKLh/upuB8w8S017
 B45+qU4x
 KVd2CZfvrghe1TZLRqauTPR2uWpeIzLhtPBQtcLGxDqLVvAuIq051pJWoPiOhx+4LPq4Uk+TLwxJGleFnFlHgxC7TN/rfkCmnUQjlxjEI13xzpr46aDhusSMWWyMEIpNuMAIbFhDTET2x22QjDJ57Yzh69+WP5Cb61fye0WHmvLoAN0tzkuX+2YxrsFP7/rEOg3NWsAoSlf7cpTcqbUFm8WpV5xiJc6rXaFGTzpOG2itWd5pdG3WXtFXmOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 25 2025, Mike Rapoport wrote:

> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> In case a preserved vmalloc allocation was using huge pages, all pages in
> the array of pages added to vm_struct during kho_restore_vmalloc() are
> wrongly set to the same page.
>
> Fix the indexing when assigning pages to that array.
>
> Fixes: a667300bd53f ("kho: add support for preserving vmalloc allocations")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

