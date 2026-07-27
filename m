Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C539DC531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 16:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEEBA6B0099; Mon, 27 Jul 2026 12:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC5EC6B009B; Mon, 27 Jul 2026 12:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB7BD6B009D; Mon, 27 Jul 2026 12:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 831BE6B0099
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:48:14 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 08C9E12011C
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:48:14 +0000 (UTC)
X-FDA: 85035139308.02.E26967E
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf09.hostedemail.com (Postfix) with ESMTP id 440A0140003
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 16:48:12 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cbCMnp0P;
	spf=pass (imf09.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785170892;
	b=KPKDp1mAQnZMwo430qb0dI5qxe6iS+iUzYNKZawKg9iz+p/TpJ7bvMK0CQhrnlRbQuz9TJ
	AU8V97SE2onGGg2qo46K71/QeuTAOxRJsmqMlNF6a941RTbCvsIr0tkvSmr+m7nB23zawl
	RTq/jv240gtAeHHS2Y3ilrqyv+/ukRY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cbCMnp0P;
	spf=pass (imf09.hostedemail.com: domain of hongfu.li@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785170892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hy0lAR5BwcNL+bC5/jeWDhQWSzBgJ0FsC8sPOBnJLVA=;
	b=j/QLjHr2gbfXQlnXkM85I7SMPNWK0a4P3vSKb/sRWEPJu1THX1BRcBkI13q8bML+Yys/oR
	QIO7EPr9WL8Fz7bl5Akzomg65GeWra4RGfuRguZs0H3jmEXDHeKM1hL751wM9ei1IMpDyB
	slEYsiAZMwVR3wOqoL7fKA4SXIycsGo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785170887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hy0lAR5BwcNL+bC5/jeWDhQWSzBgJ0FsC8sPOBnJLVA=;
	b=cbCMnp0PjxyPK7LQgx8tJq1MNkGv0WZEwtFc2Id5MlguWwgxVHuqLnBw5KIb33r/abqU1q
	ezOsDLX7yy2o6u0Oa0v5Gg/EGPaHQXifVL55eC/BPdPsIIE9Y4wLz6Lb+DsqvHkb3J+nRb
	73QVhAKxEwJ1w9J5qRm7XWJkb49j5FI=
From: Hongfu Li <hongfu.li@linux.dev>
To: hongfu.li@linux.dev
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	lihongfu@kylinos.cn,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	mhocko@suse.com,
	rppt@kernel.org,
	surenb@google.com,
	vbabka@kernel.org
Subject: Re: [PATCH v3 0/2] mm: folio conversion and refactoring in do_swap_page()
Date: Tue, 28 Jul 2026 00:45:06 +0800
Message-ID: <20260727164506.14432-1-hongfu.li@linux.dev>
In-Reply-To: <20260727161431.13455-1-hongfu.li@linux.dev>
References: <20260727161431.13455-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: axwo1cb6z331g3ixiwnrermygkhksabe
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 440A0140003
X-Rspam-User: 
X-HE-Tag: 1785170892-229700
X-HE-Meta: U2FsdGVkX1/SW7gAU4R+sQ7KRkgi4wyUFNW4fdK9j07Ta3YXkv81BKWt+R2a+ZRDjdUEqWQT6xt6Ngi2GFySd62Mmj8MME/57a2p2RiBlWuJVOK2SzhiPFyU7mV+PPD3JfaFM7xIzpxJ82toCfuXzi1RGbTz1kHB4oDa3OzFiQLuZSAd5dKZIqiZogZykS04WtbaEHDs33YAMJCL24XmL/2Aqo+vw0CRY/KFRC/ak+1rr3Yvo0MbYl7Tmo0d9bii4jdDhnFiiQ4UXfph0fHmTbBJiJiBNLxAkUZJ5Mep+4eK7s2EABnlfljb4+f/lprvn3ipEPWfVt2kIspdPieLe9P6u4vgVco36kOveul6mp2ftr57LmC+7q45Mss71dKTBsNBQfQOor0m/G3M8gbRK/AmnzsDoOgXKuOaBmTTDIRfbhdNVP5DOLTZp4738OO8uQ9l3lfPARgjeuWHzhE5sltIRejcsNSjDUlPCMPqQbn2ECkuulsgwVTEcfHIBLMd7ovCeGcs0/WXh03ShLJ/7vHgb7zHk/sj9iK80JOV3ZuziDLGKEcinuCz7yNLwcvDjSvJlSbt/RingugCjCpiyhGOB6JS/TdMX7FD/nEhyDCtFrwax7+wgHNuYC79znIiigedjkJlxJhSu8NSOciGf5ExmO3tltYe1yQIUzan8QarO9GcgwuMxeSfz3eSseiBjj6TCrxhgpqVYPLNkYk6IJeMu1EaRhypobeeRSdNgpcCYtPWzYdELPoxDrk9RMEXGUcM80jDKjXJn2e4+8X6KS7auLrxA2rtfz7oazy3zuVmYv52cG/ZUvT3Csko51w37trsESy+hCizbfFTXU+bXMWBtsf7WksEArmNIO16wDqkc1YBo8FJqYypvrg/CZtsLpB+dxLmDSG4PdUHRqkL5xCy/xNQvkEJW2o2aZ24ceicCfwPhD0TrPDWpdKK9MUH1YLX9L1zCF5lJFXLlNX
 6FmzWIjU
 uXRk0r+siDtI2e7itN9W+RJBZoUjNg1QAvc/s1gpdwztJlCIMW/kdozhlaSz7ZZ7cIOuFXkp9aHcFxSmECWOVecgEUgRuhwfBZHRL12o3fdNZDG8yLDPG7okPnIYKgQ9iBG9tlaPUGVsOU54BvYUWkbBZxSLf5T7NtVOqRzrsc1pJP7GsvndvFd57dZFu1Z6/PGb6Wf1SW/vHrO9LPt6ZJF1lhMAtFK/OlZhxGPuYiT4gcEKvuJNqegzQzu0C/C2lDaAt6T7SGKVg/XoZ4V3gkw5Exw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Convert the device-private migration path in do_swap_page() to use
> folio APIs, then extract all non-swap entry handling into a new
> do_non_swap_page() helper to improve readability and reduce the
> size of the main swap fault function.

Please disregard this email. There is something I got wrong. Sorry for the noise.

