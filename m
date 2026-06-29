Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC76BC43638
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:48:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C95776B0088; Mon, 29 Jun 2026 10:48:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6D206B010E; Mon, 29 Jun 2026 10:48:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B82866B010F; Mon, 29 Jun 2026 10:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B0F36B0088
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:48:18 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 17E7A1C5339
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:48:18 +0000 (UTC)
X-FDA: 84933230676.28.119C464
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 99E951C0002
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:48:16 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hATrsdHO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782744496;
	b=Sv4A2duldVwgp+Ce37KukqeDVno61LpnLRJr+fZl+cYf2NbR5m0w4mLHtklGHobuvxXeg/
	YdRrAs74BW4DnyjZ4N6fQdrvQiuFdYup47pQdNyAk5pYE+vB/U6fWW8mhrqQe/cQptHFD1
	J4q8MFIRVqaf3nR9SUH2Q3wP+Zz2GyA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782744496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Br7Ex/IiLw8lCRB440Qh40MypLwSStBTcOqHVSbRwdk=;
	b=tvKxzzwtXX1ndaOYRbKIlzPZFJaTT23QcAtZPU75p+kOOud9fhkmzV51pX0FpxgK9B+s8N
	u9F/uPCbr+Duml/N3WM1m34TKY/9M00E3qG8FgXUgGhJXfVFjrilIV0bnPuFIVWqRVPOXM
	K5f3Iqnlgx9qXz6X9K9nVfSodVxf4Z8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hATrsdHO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1002A600AB;
	Mon, 29 Jun 2026 14:48:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852CA1F000E9;
	Mon, 29 Jun 2026 14:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782744495;
	bh=Br7Ex/IiLw8lCRB440Qh40MypLwSStBTcOqHVSbRwdk=;
	h=From:To:Cc:Subject:Date;
	b=hATrsdHOFRVmCCWsmVipAjo7dTzB7xOskMSbaNA1pV4gFlPkzzQ+RL0PBNpDyDAf6
	 qtnQpjab16uu6WJbM6c12dEYTJT9HuAVJBUZgRb3ic+zmcfje5umMDi8rWWo+ZFL3j
	 OdR145B3UwbmaFb7XDvGQPyX+edjygKOto/BGxHVv8hi+w+Isoxk0j0kynfvjBYk92
	 Tu79AL9MZnfgwP4aHgYnPguY92YRoUnIBxgpZtPMp6R52YFzMq0yfnHl82wdZsrjOo
	 UXTAq6LmsAQt5EL+AqXxK6j3nzJUdR+/MusdkFaG9isvpXl1LRN/lf3jd1sWUycOll
	 x5iTyC+gKNhhw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v5 0/2] selftests/damon: fix memcg_path staging handling
Date: Mon, 29 Jun 2026 07:48:09 -0700
Message-ID: <20260629144812.134159-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 99E951C0002
X-Rspam-User: 
X-Stat-Signature: 5cfy4aygghu9qqu9aywfe3ksfnj9x1gp
X-HE-Tag: 1782744496-477642
X-HE-Meta: U2FsdGVkX1+j5lc0/pc+Z6P1DgtSQyZ6nggkPCMm1vYuzlj65HNDl1bKuSqacvlGpOkLJZWK/g7ft/pkgG3agh8nzZkMOHocXLaOo7GYo0oDlbUaYJOiuz2qOOZAfR6xtjnGv5FcUIvPWbwqKGWtctvfUJRXKe/Zs1EwN2uybAO8MqcqulxBYaICNfGeO95kmHvudMkYi8kCV9TGxTErFd8i5ygPT1w2eSkqNuW3Z8WVsLHVzMQwrLjxmAqyVEiVqa7h0UbyONykh142glE5+VAYDp+alQxc0zfEu7JBo4Q2AStljX+AqbYcVa2tXEqhQb3aBm/rVlpzahmDaFZRT8mlOCJe6d9lfgJ7Q+2vL4KzECEXBAdG0SuYXeY4KVhDtNMR4WpdxGCAc6AOrFcnjvcM+10hs44mf7iaPBe7K9NxJRCg4f1IsLZL7UQ/2EoGULo6CW7hMu02JvTXKPicX1r5T8g+/GFwD1QlRYxQaZeLJrfgtvp5YPU+fPD0EJuAgtQH7VzVElaSP5ZkovkcSYcZgWizNX8b7fOW5z18E1v1BUDnVSQAnPOnVFlADsTyk++M89UUudaKxnD3OOzbYON0m+eL7BldW8I4bI6GTAtBv8TV+Cx6F/3zGQEdjkBcYw4SKsSJ+5oFXeuw5+kZJng5vxQAYpOqFSaL7VGS7AzX/ui7sdD1rAYY3KpVn3CsEZY6ZQahgp2FOs0VxMgSw3jksb/c/aFYclf3wOB3t8oBNQ9GA8z6R6D0OXJzHk5RGdOSEcNGjhVUDWG9I9rCv8A1FjANclDG2RvjAx8TxFhc5JIARLI/wSf9gPfZhp7tJziHikSNNYlAAWrYCThTQoT81379bGzZHl+GFXWULeDDW6ILDHTqWms4c2Ez6E5QPAnJFyEAH01Ql5XPL8pck56oEoH3B/yjKoXrziVN9Td1t90hvHMfA3vl13ELK+iZ34gvRqnmif/uculY1a8
 q+SKZBsX
 fIZAG74+D9QYWcmXncEQlm5VVoaH/qw/LpjZfPtiHA6fQqsWuDMLC4Ri7OlPTivArPb8hfP4Ch11dpvemQz+yB5qxrrwrzLV1ceP5YML/Idq2/Wk5Cd8hDMhEiYyjRfRhbk2arNLevf+1n+7fmGyFFgi7VzwAIFa3VRWD0BVXi+uKEwUGRc6fAfv5I0DrdVjdw6HTeJwqxjFCgtvcDp/2xXPwms/xJWCKekxVNLA7STb/51Dr1V2fzn543FLDVL3PgmG9iqnrpi4g7Uf47nxMP6HF2OH6eRlegAsL9+Pw4bMS+z1ccdlhmfwEoJ/e097OlGFt6AlK6+SfqA/Dq+Av1FUCdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Fix a bug in _damon_sysfs.py for damos_filter memcg_path setup, and add
a test case of it in sysfs.py.

Changes from v4:
- v4: https://lore.kernel.org/7E6EAB7C1BE04DEA+20260601090119.238457-1-niecheng1@uniontech.com
- Collect R-b: from SJ.
- Rebase to latest mm-new.
Changes from v3:
- v3: https://lore.kernel.org/E4B88E7D4879D1B1+20260601074250.203583-1-niecheng1@uniontech.com
- call stop() for cleanup without checking its return value
Changes from v2:
- v2: https://lore.kernel.org/4CDA28DC581FDCF8+20260529090845.1696845-1-niecheng1@uniontech.com
- configure memcg filter before start(), remove commit(), ignore
  start() failure, verify memcg_path staging readback only
- use print-style error messages as suggested
Changes from v1:
- v1: https://lore.kernel.org/406BD1BA0F6AE326+20260528081039.1192194-3-niecheng1@uniontech.com
- unknown.

Cheng Nie (2):
  selftests/damon/_damon_sysfs.py: fix memcg_path assignment
  selftests/damon/sysfs.py: validate memcg_path staging readback

 tools/testing/selftests/damon/_damon_sysfs.py |  2 +-
 tools/testing/selftests/damon/sysfs.py        | 31 +++++++++++++++++++
 2 files changed, 32 insertions(+), 1 deletion(-)


base-commit: 544856bcdccf456fc27f85e5d5b0a49f7b8e6019
-- 
2.47.3

