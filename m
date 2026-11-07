Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A085D606D80D
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lPcfoW1k
Received: by kanga.kvack.org (Postfix)
	id 9F0696B05B3; Sat,  7 Nov 2026 17:22:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2DE6B05B4; Sat,  7 Nov 2026 17:22:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B9866B05B5; Sat,  7 Nov 2026 17:22:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6ECE96B05B3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:22:13 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 04F0E1C39CB
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:22:12 +0000 (UTC)
X-FDA: 85409747346.24.380E309
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 824101A0008
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:22:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lPcfoW1k;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794090131;
	b=v7lHbvMlqHmYTGBzknCfXtJBAg9oeo1oFAdTgn5Du2ZEP1K+58tZ/ve/OKu5QBr1K9Z5sc
	miLrwNH8miYFzJ57WuWEp9cbl0bfBqwip+GtS5fKWTamJ0ZofkmmoyhBn6VeEg2ZuAzJjT
	92wuiUEeLn3qbT6nfKRITxVDckshNaU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lPcfoW1k;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794090131;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oFyH1lXK+D22hmGRk2EUFASP4KJBcyjWs6rRrcnHQkU=;
	b=g6E0XNmBMqxkhjfgevQJb/t+ixwcq9xQL9ijCjfpr6lpZqH6hQaakg7j5yVX6dXOsUDlaU
	yfyXTFtuvOlvG0Ez3VSCugmIGev1jSInc506d2YvN12KLqa+h/aRqQxm0oT1l93bvI2PTq
	8omRev3MNvS2FV7yNSgbe2p4una/oLs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0B53F6120B;
	Sat,  7 Nov 2026 22:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7944B1F0089F;
	Sat,  7 Nov 2026 22:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794090130;
	bh=oFyH1lXK+D22hmGRk2EUFASP4KJBcyjWs6rRrcnHQkU=;
	h=From:To:Cc:Subject:Date;
	b=lPcfoW1kLglj1i6JIN3nPgQGGSRI0kGogIB92HmszE1lxF9XvVJLA08EG7T+wUvXY
	 hmCvBQLap57JcbniUzaGg6q7caY0NXigaLeV2PYLCH6ppcAPphz9EHwEmWh0MS6OO4
	 t9OtWKorGE83GpQeer47a8uum2Y9o94AY6hw02VKRgVR6XVfWysmNhz7NLggvMLD4V
	 9Y9VYOSuzCVu8dXMYrgmfyg4yWixOz+Xw+cekNA5eDyirDRjyVfIuPVqTOKYoh/cl0
	 8yRrR4pQvQvWnsdmCFGdB0v69UpOvGRFPRvCstQNhYloherKXePTOSSTa/uCJfQKqt
	 R+ARw87afnLlQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.6.y 0/3] mm/damon: porting fixes that cherry-pick failed on 2026-11-07
Date: Sat,  7 Nov 2026 14:21:58 -0800
Message-ID: <20261107222202.331476-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 824101A0008
X-Stat-Signature: tceeh471zjnf99etxxnnr7mcm9dhucja
X-Rspam-User: 
X-HE-Tag: 1794090131-584698
X-HE-Meta: U2FsdGVkX1/2c5ZgwXhJy3at++Ba6/Y3ANvjNK+FG2L3W+2vnYE12iYvaVvvopAHzMp8Vi8yxJspkGPTaqvpYhuiFD6lspsq+h+N3+c6DBQW5VQhB8NdF8tS/EPH7AUF1PTNwNKFW0Yyd+Pw6tusVeVJmdm4ffMvd34tm5YlJEuoohhcvfaiCYV0oLM5JucBHhddsrMjl1hh64jcoFvUr5eE3uqK3d5PqN0rjpmEbNXYfVLSEwpHZFyc1EM5K4GRKiR5hElJaclKV8fVgeNod8eDoOAr6QfbqD31Efz9uwgJNh2AK4uUJEnvPdYuzi/H3LNAzaERHrZfx9tt1gxzYYwOBt1aZmHOwP9YX69ogz6JqN7ndLvXAq/KR8QOdEN5O8hNGGgE/cL9asOfN29okzzX3fyCMUMwP5mDcnNh7b7NDhBpVFgTbIPotj6WakrssNaYdEGLSTpglWCCkxentu8nXWoVQ75PhBaHvItwAN1811oWM5/V5AC4sPLJrIu4VHWWXptxzVoJEl5wNLnHqZTlg4Y7c1Jdo81DVFOdfzESUxjVsI+h3s6xxC1VEKTbnQwmxKqBUlnqRnBbh4ECOLPsE/VsGfeaQtVobWbX6EQ2sBMTlyNofF5fxF7UjQOYfz57Za24zt3NK+BjUtFgvWCm8Ir2raOdVzw7qEWDpAxDIhhQQ6iU3/A35TEHPvYHANULvxzySSU9PL0Z/R2TrTU63Lqdvmogs2OJELmCHRFkFqgyGmhrmir86a4js4Z6LlOfDYYy9KFmyF+i7p9XaXHg4qfo4ZoEQDRMsU9t6L44BwXgwrIf0bw0t4lblQu0+9dogCZ4pe7qpyIYXchZ8q2ejyXlRvH2U089CCfQfYS3iNe42aJtQebdzc7QGte6YX8dfLQ/MTlUQbWvZxMNnVgAlOymKvZZAdQGEovoa2/hprC7Xz9eQX3RuNBfPRUzaGfvsyknT3acktuavv9
 fb0+RHS0
 aKQVJ57X+s1OVttmloYtZe0QUfSuY7Fv8M3gC017G6k5k7Hq+nAu4WHtdaesj358/ndqTCAxWDdRHq72YsU1Wx4wrroHhiO+3OslH8cXWpf8nW0HnUvt3DfJTTT2IqI8BXW0DfNxepUV2K//XY9jgqNfldg2PmBip3k4OtUS1lqEThGWjR+oxGuOcChnM8yJs2INXR3smYSncpYpgLiARbbBT3hD5qUwXfz9c3zqOExGFguc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Manually port three DAMON fixes that cherry-pick failed [1-3] and turned
out to really need to be picked.  Note that seven patches [4-10] that
also failed in the same day were having wrong Cc:stable@ tags, so
ignored.

Patches that this series is porting.

[1] https://lore.kernel.org/20261107053211-failed-6.6-90c2fa6adfed@kernel.org
[2] https://lore.kernel.org/20261107053907-failed-6.6-bbeec2d8324d@kernel.org
[3] https://lore.kernel.org/20261107053915-failed-6.6-5695abc4e742@kernel.org

Patches that also cherry-pick failed but deliverately ignored.

[4] https://lore.kernel.org/20261107053348-failed-6.6-6f276422aded@kernel.org
[5] https://lore.kernel.org/20261107053350-failed-6.6-cec08aad3def@kernel.org
[6] https://lore.kernel.org/20261107053353-failed-6.6-409d2ab6d982@kernel.org
[7] https://lore.kernel.org/20261107053355-failed-6.6-1bfb9384ae0e@kernel.org
[8] https://lore.kernel.org/20261107053357-failed-6.6-a1c7fdaf1657@kernel.org
[9] https://lore.kernel.org/20261107053400-failed-6.6-1d2397b2c414@kernel.org
[10] https://lore.kernel.org/20261107053402-failed-6.6-1c3352282063@kernel.org

SJ Park (3):
  mm/damon/core: skip applying scheme if region split for quota fails
  mm/damon/core: filter out damos address filter-split failed region
  mm/damon/core: remove unreachable damos charge_{target,addr}_from

 mm/damon/core-test.h | 11 +++++-----
 mm/damon/core.c      | 48 ++++++++++++++++++++++++++++++++++++--------
 2 files changed, 46 insertions(+), 13 deletions(-)


base-commit: ba98b310288deb9f3814fc8f80d8a33ae0f59850
-- 
2.47.3

