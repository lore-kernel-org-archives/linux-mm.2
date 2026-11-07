Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64D4B606D80A
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Co0WFuLq
Received: by kanga.kvack.org (Postfix)
	id 6C6D56B05CE; Sat,  7 Nov 2026 17:48:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 678E76B05D0; Sat,  7 Nov 2026 17:48:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5189F6B05D1; Sat,  7 Nov 2026 17:48:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2A2B46B05CE
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:48:18 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AB5951A0215
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:48:15 +0000 (UTC)
X-FDA: 85409812950.07.65C38FA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 35FA0A0003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:48:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Co0WFuLq;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794091694;
	b=KaEq0w0/lu/l4ypj0o/lnSIgcsdlKCoStU+1siVeUUnUNSRYleD9/uJO/ZjKmOPgF6s4Hk
	4idzfp8EpGYeAPKGvzBneaeKsgQnnfyyuGiMTwLfHV7ld9ViYwZXvVvHF6hd7AZdrdT++w
	YBmjrUN1rT92RRvvGTZ9Wwc420u4CUM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Co0WFuLq;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794091694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=r93xgnQnGDvW0eJYTsrLNsZ3v+4WKqnYiy2NtOwA/68=;
	b=f6HElOftnu6B+FokPrQymdF+vZ2l01mBNDqBY7zMqXAhqenWUZiioDiKrDm4cIduScLpgp
	z/Wm6X0Mf2fKDKYhNf//xi93z5fLy/Ja4gI7aHjQWlGomcBjjnjh/YgYjew/2jdwJqrHiA
	USUl4o7xSG7UY9ZCxNE+awZsvRjlS3U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B053A61261;
	Sat,  7 Nov 2026 22:48:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F141F0089F;
	Sat,  7 Nov 2026 22:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794091693;
	bh=r93xgnQnGDvW0eJYTsrLNsZ3v+4WKqnYiy2NtOwA/68=;
	h=From:To:Cc:Subject:Date;
	b=Co0WFuLqiounnTv/KIwnHob4J3Tytzzzbg9u7At/kRTYjW7LEeZF6U0e174jvnwTI
	 3MYg9JuI3oqYyznIxjDT8G1GlOkRoSlstSC5H04g7mgDzGhf8u5u37a0hKsakGu2qL
	 ej7bnAxCyg5Y6Mm90Y92UFwlEsoe+EzTk5sIBii+n2WSqbcL1lovuWu7r0PEyX8GfK
	 1J+g88apz1n7lv+83esBNJtYyoMhFt2E5YHX/MoL8qx3GkE9fFoT8gLKA0ms5WsIN1
	 VouAt/yrkqs1lNqjpkaoPn+oxo2ldPE9TuQnKRDZ7V+z+WKP61x+YLM/0lYjeXCj26
	 9xJruRIspNhBQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.1.y 0/2] mm/damon: porting fixes that cherry-pick failed on 2026-11-07
Date: Sat,  7 Nov 2026 14:47:57 -0800
Message-ID: <20261107224800.340250-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: akzns779m85tekyftagjbf51qonxer8n
X-Rspamd-Queue-Id: 35FA0A0003
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794091694-550769
X-HE-Meta: U2FsdGVkX1/akDtFNpE5tYQtXoVIAdlwnAw0Rs9JGDOl0irmIRHJPJ/SKpVhfFWnEuqsyenwyGZNDlA+SLASD8ZfqCpEzHJ39LXrmEb2WHgTB5My1ymuRY/Kyjpn+o5Gpuqtfoy8jowkkPfxMjRpuczUrg7fYDfMEq1qlxwlh3O7ZQY/1BxsTyGD4/iJGDSonn20UoMG28RkO8yH25UlqecatN4EQg85RtXgxDKH504vEBMb2rpEzbCpBculenBjG8NkOSElaTtzPmNmbIFNN/hnlNKz6+irrhEun7AFrxG5ZtpWIWjkNPADKvtHIjbN30n5F5ER31h8TT58OsVCoxPxTQh7HVX0xKadYH10zaApEL4OgPIxa+s5mTLAsQxq2lG3h1DxaFsKD5mgwZPWAuYNfLMbnP4JE9ztDZCe55yNJ+Hcwr3nJOHGfNNZ/WK/eXhUTyD0EJEnjJmnz9XMOaDdl7yqdRbWouzEVWPZuzGf22Z0p3+RSEcolHnCcRotMNmQY011y8cDdq3GJn8FUW1HQK6AC0Dn0Z7zamEZbHGd2a7CGYhNQxYhqNUw9bDGcKyx5vizWKezTsyMg19FgMOfV6ek4BYAuTBv1kPPHi2ggOJHMrhwClLxkVMo0sMPqN4D81rkSqE6yoAsqxsJHKf51lf9LNPQ1I33V++CkMHXV1kXY3gKDq57mS2Z8foeezfYck8lubphyL7cVLbt8v49Fh+6BEkvt80DYpLCcVIJHdSWySG1lu4W4O5AsgIQlndEyx5s6KGuhlubYnnCjDig7lEbag5an5+xTUi0P/gWGc78AlZGAqRwBesKb9evAhONvA0McZdG9CX/SvTIjE15ptcBzRz0CNNcWlTyk9ejusm+6uwe4yFwASOx0Eq3Rt8LKxaDl4l4545v8XiWKgfbciX5BcPTz12FQpSNuaAtp/pGBmvFBcu0mGsYGUTXXy7GCMuJHTYZ+KoyJQ+
 95XtYJoi
 72veD8KExlXENbvV0FvfFFS+vnyjsUG0MACVKjEwaHc8UCdnASrdWXLUkPMCzf7CXTWRvLPZHFYavchguHraIn7FZL+YEd+pMFjmeh/p0WOTtqj1CT665nJZpG7hy0DhnzVC0UA5jCVKHj9HhTDCL7B8fLlKbq/3sX8YsB00p7bF6o1kTQ3/9Seb7G7ODvHD5zM0975lBXDBsfL8NnE63N1WfoAGowGNBnqK03tVMEpIp6Gc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Manually port two DAMON fixes that cherry-pick failed [1,2] and turned
out to really need to be picked.  Note that seven patches [3-9] that
also failed in the same day were having wrong Cc:stable@ tags, so
ignored.

Patches that this series is porting.

[1] https://lore.kernel.org/20261107054458-failed-6.1-90c2fa6adfed@kernel.org
[2] https://lore.kernel.org/20261107055454-failed-6.1-5695abc4e742@kernel.org

Patches that also cherry-pick failed but deliverately ignored.

[3] https://lore.kernel.org/20261107054658-failed-6.1-cec08aad3def@kernel.org
[4] https://lore.kernel.org/20261107054701-failed-6.1-1bfb9384ae0e@kernel.org
[5] https://lore.kernel.org/20261107054705-failed-6.1-6f276422aded@kernel.org
[6] https://lore.kernel.org/20261107054708-failed-6.1-a1c7fdaf1657@kernel.org
[7] https://lore.kernel.org/20261107054711-failed-6.1-409d2ab6d982@kernel.org
[8] https://lore.kernel.org/20261107054714-failed-6.1-1d2397b2c414@kernel.org
[9] https://lore.kernel.org/20261107054721-failed-6.1-1c3352282063@kernel.org

SJ Park (2):
  mm/damon/core: skip applying scheme if region split for quota fails
  mm/damon/core: remove unreachable damos charge_{target,addr}_from

 mm/damon/core.c | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)


base-commit: 807b0a2cf04f7d9b6d42d23f5e63915fb80a54fd
-- 
2.47.3

