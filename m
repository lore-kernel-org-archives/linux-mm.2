Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDB0B606EE92
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 15:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PjVHjVCX
Received: by kanga.kvack.org (Postfix)
	id D4D726B05B5; Wed,  4 Nov 2026 10:37:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CFDFA6B05B6; Wed,  4 Nov 2026 10:37:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C13DE6B05B7; Wed,  4 Nov 2026 10:37:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A606F6B05B5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:37:01 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 457D61C4164
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:37:01 +0000 (UTC)
X-FDA: 85397839842.09.A1E4000
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id CA05B160007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 15:36:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PjVHjVCX;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793806619;
	b=V0XnezfdoklZYhJQceSEsKtP6RkF4k9RO8hRAjGGHJbTWeN4orR7LrVGuRMyLQxg6uXHWp
	/eBbbFU1F+Oe1LMAFvPb0NhrQPMHT1FbeYuSAYfKqxdNtVkGKP3Zs3bNxr9TDWLxt3e0Ja
	orU6FBc7Radk8oj/rBP7TR+WSLTFudI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PjVHjVCX;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793806619;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+ifUpgMT6EQwsUbOKCDjOEEW6HfkKKK5IRMwF1JmJ+M=;
	b=xR9O+dLreaAkuvBtPpBhe4vjghcqfmZnPQptd242hvkejLiuXo1jf89Uh/Z0/rOYURutRT
	2ZijXm68lrkP0drwikqQXBm67g4q7pXjKbnSSHDVueAzoYIvbvvHjvOd5xezXiNsnJ7rfi
	sKXfaOHt3o1QWwt4ZeJnEEn2tSFrLWg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DFC1F6021D;
	Wed,  4 Nov 2026 15:36:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530891F0093A;
	Wed,  4 Nov 2026 15:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793806618;
	bh=+ifUpgMT6EQwsUbOKCDjOEEW6HfkKKK5IRMwF1JmJ+M=;
	h=From:To:Cc:Subject:Date;
	b=PjVHjVCXwsQleO9uRLbpJSinsi5d3LRFo/G9J1Bzv1LPVBoTHgcokBBKC6jpRHBCV
	 +BsePRwfbD6YkfPBM9D2HPn9SeDvkXkMlrWPR1AsHT4eCEdom2o9rks0hN4KWwo18f
	 VeRI9RtocuzWtehKYcIbxJmabPCa8GwJ9fUS6PgUAia+83qqO20BgbeTIrm+QHtn+H
	 aWevTdrtu5rVzbJ/LCnSHdX2OMk8dMFPWzNJ2zfVmOEI50a11LuNEHunryfzSfEu5a
	 lmNZmWzLNDpMt7FyBWE4Vfmu9KCCwsdA2L90m5CKEitRnGw8sezdjpPOp55AcfbI9I
	 CNyUHbDJjZ2qQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/4] DAMOS access pattern supports selecting regions to apply a given
Date: Wed,  4 Nov 2026 07:36:39 -0800
Message-ID: <20261104153645.82945-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CA05B160007
X-Stat-Signature: 67nhqwfdnxj7mje1zr3juw7matzycu6c
X-Rspam-User: 
X-HE-Tag: 1793806619-499822
X-HE-Meta: U2FsdGVkX18A9/ncKL7JdPobGbheWGSb4+gSDbfSscAZSFnMjYFSAsdgb9/WD9xnqO3sBexzEZOmiVVDuyrLiudHqeglH7t9KjwSnBQsuLDOli0SLYfa0LVdMQV05meARk62ZLDmmY3Zmvc053U2/W7gyDsSS3moF6j/1eOclf3RIZRv8vKXdGahFJ1Ya1UDxzmrq8XcTe8bUjVl47V6APAKtTVlJzCDBRBdqeizaQ84OKuiL+VFSQ5oEIDXvYwvWvrJoe8k93U1KLLGW2Qu8ZumAS9LSt1LkooyJuTq1s/jZZypPaCk4KIIwFTmWYg8t7hpqUN/ci211v5TD2BxbDc/q91g8/UfOETD3mURoyzWjyfuEFIIYNIzYpLBzF0Y2ijkDRSuHcg0YBLHfPzP21VrkUIf37izIk3BrRd0RuiJgUS+1BIcO9H0Dj61p8grTHatmN1obm6YtILtWHGj5bzFzyZUpjM12EgWy9amD5rOueqSvbNKyosPz175OqmIWUra8P5c92uF8M0xcQshsORhLLugHxD9Dyxc+5vQm4S/8/5ETbltnKm59PduEqvFFHWyniPqYedo/RqzBXH70XFNYXJVurFCkWnB1uKn4ddpCVJlY3J3Ctj/V4fXr94cZ1k7LwX2zYSQaAxPi+shVKfEhliHgOp6RoVH6GjbFvLA+qZEAiivCRtyiIjANaq6wbLyKKeE93B/n3iB44pInqIArfESn11Xe1oz7yRSsJHpXjyPbFrUdJgTzlpTUejXfZb/1zw8Bp6QMFCBd6wtV6Pt8hk1JDQhcH9xbT2UqqJf1v/rBK8EkTB07mcrFvDKksXAQfZWvCL8FYLF8wXB81FIy+3+1iB3HPQDWvjjQcWdfqQN2YbOBXNMzBtp6iFeKD/TNKxdQ2M7ILexDcyBaKoLTvAQYTXCYvGdPzIrSHwlAqTP1ZbBmQpTWAkM6g+A4/jfqxK4EJnMp6N8NpG
 znHjM+Jl
 KTVBkeAi2IgTCSrgR/8BBrONtwm5s9AkY/ZDIlKYMldnzQSbtBy0TbJgtCdkGWqu3/xLe1lE3iRkBiVQwVACVaF2SUSEFOzptDU+mOZhXpMtTRhAB4fbrM2eOR+qLRnl8aIdvQjLA5bNX7R3WecxVOKcRscpp5GbVZrULMOm+2VADTj+WgYqnm6nd1sWPPLH9ZNDFUIX1kNmQVPUNGb+ZUI94TQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

One straightforward solution is extending the DAMOS access pattern for
specific deterministic time based age specification.  However, DAMOS
core filter is a better option.  It is playing a similar role in a more
flexible way.  It can be used for both accepting and rejecting regions
based on if they matched or unmatched to a given criteria.  Multiple
filters can also be combined for more flexible and detailed rules.

Extend DAMOS core filter to support milliseconds unit based age
criteria.

Implement a new DAMOS core filter type, DAMOS_FILTER_TYPE_AGE_MS, in
core layer and expose to DAMON API, via patch 1.  Add the support of the
feature on DAMON sysfs ABI with patch 2.  Update the design and usage
documents to explain the new features with patches 3 and 4,
respectively.

SJ Park (4):
  mm/damon/core: add DAMOS_FILTER_TYPE_AGE_MS
  mm/damon/sysfs-schemes: support DAMOS_FILTER_TYPE_AGE_MS
  Docs/mm/damon/design: update for age_ms damos core filter type
  Docs/admin-guide/mm/damon/usage: update for age_ms damos core filter

 Documentation/admin-guide/mm/damon/usage.rst |  3 +++
 Documentation/mm/damon/design.rst            |  3 +++
 include/linux/damon.h                        | 16 ++++++++++------
 mm/damon/core.c                              |  9 ++++++++-
 mm/damon/sysfs-schemes.c                     |  5 +++++
 5 files changed, 29 insertions(+), 7 deletions(-)


base-commit: 32e967f279b24f952a5482e2c427894787848ee0
-- 
2.47.3

