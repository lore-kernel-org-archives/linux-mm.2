Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76B9FC624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 15:20:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8695F6B00EA; Wed,  2 Sep 2026 11:20:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81AC36B00EB; Wed,  2 Sep 2026 11:20:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7312D6B00EC; Wed,  2 Sep 2026 11:20:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 52A9C6B00EA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:20:05 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D9E65140268
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:20:04 +0000 (UTC)
X-FDA: 85169182728.18.4CECECC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 48AB040004
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 15:20:03 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LCjsPGcI;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788362403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EmdLDOUaG296P9CvbM12jSxYGxNeVIbHfGvENxwCkbw=;
	b=Tj6zjnTVOmk+OQi2AoQVxdSqIhzKywaVuSKyJbi4f1t21Ba/JeObhQLvL2pPfWbM2W0FWd
	9EaKWuWZssIc6vVCJvN3BV1LgaSBIcJvlxIqLWo2C6MPGibzV/kiiit6L//mS/TxizW29r
	Amz9/Ia1uGMEiYO9dZv6eM2rn1bJJTw=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LCjsPGcI;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788362403;
	b=txBTyn9MNMwG25LdQ+bxIGxR7BoeQQekVod/PUmNKxqFGc6dOl8ewqG55W3bOyZXUu7v4A
	OOEMNoXEeT1RU/4RMX/NbuTEUZ3DOEVlzLIpSYaTxCinfNOetEZS3LrJvSJggUVgbyYA33
	1LGPwPkRw48eSu1EwujWHky0JDL6BwQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6E08140404;
	Wed,  2 Sep 2026 15:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F08BA1F00A3A;
	Wed,  2 Sep 2026 15:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788362402;
	bh=EmdLDOUaG296P9CvbM12jSxYGxNeVIbHfGvENxwCkbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LCjsPGcIlubZv/I7kxnTj2vuAMW6xD6HCrWwLZXW54VpxsS9HmVQYzAWbRqwbRM7R
	 CrpUvX94Ul+n7/HGsKNLoQhlYASfOBEU2ugN6FckjCXhPzFEo1/5jW+cw901xqEDJS
	 VewGQoJQls9BbW7hfWc8pU/7YmP1txFV8PEhBuXiEgrghJI9s5V5j5LjaMQE4RMdPx
	 Fn1HdwMSsxyZ8fK7vCtiDCdXDtc5wt9GUHGfFs0FyOgsJYxP8ar1qJjIUh/n+hBmce
	 H2vMq1krBKRNqmKrybjJuHkCNZeajfyNjh24aBDEpCNJC+BD/MMyb5eYaO50iG5/5T
	 ZgWvEhZMnuaew==
From: SJ Park <sj@kernel.org>
To: Kunwu Chan <kunwu.chan@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Kunwu Chan <kunwu.chan@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 09/12] mm/damon/tests/core-kunit: test damon_nr_samples_per_aggr()
Date: Wed,  2 Sep 2026 08:19:54 -0700
Message-ID: <20260902151955.88892-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260902150842.4033320-1-kunwu.chan@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y8nbn953ai98q3oqq68t8xymrofn8654
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 48AB040004
X-Rspam-User: 
X-HE-Tag: 1788362403-47636
X-HE-Meta: U2FsdGVkX184ZRYT1rTKKd8xZd2M+nhsTi3HJeETukLvjBRMVQGyX9RCZaU5OxjTh1+6cHubrctQN1w6QmiNexwDTngK1dpZazY+J8F40B/5S8RB1ZLf/gb3cf1fbHI3tPlCWSRb+iIbHBoai2FOL3iS9FLJi2vQQFSIiLAkrXLxkwpW8ddUPpi2KsuGfLvdRePM/E3i5oI/VG+dYwYxhzdxeUZCT61iWNtR6dD04m7jEbP2/uUn3IK9hI/yrH66smbj/nh+SKJKiWzO1nLzOfOSWfascOezJLwyU04L8NYX2wlruW1hnRPiOu3FUQq5966cPUTHO/Winev0DWDtTY/QUh3Hg1Ter2GQ1pvqroHc9UhcpwXOYXDgF2Fa7PzkqjS/3IXkMoReR69cxRCXKyRMcZwSESxy01V3ARSt8xTEoqBwvanOl46Kv89ZiWYV46FImLRd6W0L17rwsJKRuuN6pWObNaQQ80pHsIQUvBPwpDBcOX4os7Crz6GyT/BIrggm1G2hSoRgJiHa2AMI5lx6x604Q7xEw83pGuFoQ2jDpERIkpfzN3fuMBbmwgicVzWZXmz89Ri/YfxyqO2R3eZsBfXw1fJgYtR1VYV8Xk3avrbIafnyWEfQ0mtkPRz54z7GWyki3jKpAT/qu7yrby4k37WVwTLpb0/UbhloJ2J8XmxG4VDXEAAJEz/daJzMB/Spbh2gxutE3hsGmufCYmDV2NUg9ZDudB6AB15cau0J/9tOuUwM1J/FH7PETsnajpAy5hx3sTawtWYAsycRWP1F4nMTkYmMweh7dkbwpWZaKBqc6kG5JI4THRHWH2smuiNNkv/Yn4oTogbKWeeUZOsD4QCUpF8lJOZLgMKvX5N+09q8kwO+xLv1vd3zTgzMj4qc2FxBdSJM2iG7etLlhUjphRFk3rhkPqSa9M1cZRfIPhKUstVIGPr9Ax2G6x1NuYt05H3ryrRbgHWBITp
 iLrGlbLW
 xYcG8xxc4XiaZ8R+GWA3fSCzqJWdW4a1X9IQ02XgK4sQ8Nyd+Vd7U7ZN0Qd5LvZoVUUZ90KaG3YhVH7aJK7+MwVfKwrpYxbskZnz/v1jCP3RltLk4WgEnz9ichfzlxLIVmDUr6bx24bPZ6fPfSWXSMtKv8LEkw4F+UEiXOtSUVDHZUMWecNL3ep/rKVj2N9XSab/eVD0GpAEaxw/9oWDZdRrzqxSd/jzQDziNvCfkmuNsdUh7jBmNQvMlw5YKkDmTiOpRSkoQCToK5ec+eOqv66M7z2UmS3llalIlICw2sBUl69HIeyrESoQMzye/HzYdKjDwVymsZQp8YltED9tGORkses54RdLbOnz75D5SykT55qdDNQSscugkm9wDeUwaqm6e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  2 Sep 2026 23:08:41 +0800 Kunwu Chan <kunwu.chan@gmail.com> wrote:

> On Tue,  1 Sep 2026 22:47:42 -0700 SJ Park <sj@kernel.org> wrote:
[...]
> Both `sample_interval` and `aggr_interval` are zero here.  Since
> `sample_interval` is the denominator in `damon_nr_samples_per_aggr()`,
> would it be better to keep `aggr_interval` non-zero when testing the
> zero `sample_interval` case?
> 
> This would make the test explicitly cover the divide-by-zero protection.
> If the `aggr_interval == 0` behavior is also worth covering, perhaps it
> could be tested separately.

Thank you for your review and question, Kunwu!

Yes, that kind of additional test case would be nice.  Please feel free to post
a patch if you'd like to! :)  And no pressure, no rush.  I will also consider
doing it myself if it seems you are not interested.


Thanks,
SJ

[...]

