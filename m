Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0E8A606A336
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 22:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JA6O2W7j
Received: by kanga.kvack.org (Postfix)
	id D6D546B05B1; Mon, 26 Oct 2026 18:56:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E146B05B2; Mon, 26 Oct 2026 18:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C347D6B05B3; Mon, 26 Oct 2026 18:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9D71C6B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:56:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2C71DA8322
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:56:10 +0000 (UTC)
X-FDA: 85366287300.23.1E1CB31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 99A73C0004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:56:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JA6O2W7j;
	spf=pass (imf28.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793055368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kDRiWJeMZqvF6vqXY+N9yfNAfM6lhJN4gULkYvRyiak=;
	b=nD4U+pYN2DOiZ7dzOmS9dc+IeeS5WpAK/PgALWQfBrfVUggV5LNx8MPt00Kifa16TuAqYq
	Z9bUoW+EbR4OsI7M+QERKq5Qcv4uES7PBe+DvKxrNUDbfBA9VSKnir+nAxd5xw+HYH9TEh
	iwiTtybDUAUDsUH/6d6WVCK1J5bhvpc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793055368;
	b=TWGAzZS9vUl2kN2FXr2nyVR/QraoiUrk9Ar6QR0zQuvWmtGpOAlzq2sdAT9jtmwJPsVsV9
	pmKyQTJBz1emqzuU+aBK18mvCvVmSbR6/1DbOfP8jZ8MVvG+6pFNXOH2k+4jSSZzo8leAk
	EbM3nyAxaLc2+1/I8Vesq3Ll8CPZSng=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JA6O2W7j;
	spf=pass (imf28.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CCAC743689;
	Mon, 26 Oct 2026 22:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E29761F01828;
	Mon, 26 Oct 2026 22:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793055367;
	bh=kDRiWJeMZqvF6vqXY+N9yfNAfM6lhJN4gULkYvRyiak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JA6O2W7j6unWHhshHnkD/s//HD6Gtrrxz19ZJJp88yY8baS14aOi/vhUL9vmbQFoS
	 YlCnw7TvFUMhJk64ZYoPjt3OMOnK8zJ2oQjFkyu9W+VNz93QO51yxzDj1RmljmeT49
	 jCw0KgpYmfxg3j7ZZM4qmjjs6fx0/qNxyAs0s9SWeOnQzFA8SHMclQsgU83RHmaTsD
	 hkNT63KrvO/8yXP1sZU3TQ3kuzUPk4y+K6dMrAzpF7eWXz37BThopS4aUsG5FNh6sr
	 /VEgJeNMtrTnrhtLZ+0zdQAAvDBEURk95nPKgwo+ut9jeN7y8uxuG8lo4HwSab71fV
	 Q1MzPx4yhnwAg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 7.3.y] mm/damon/core: error damos_commit_quota_goal() for zero target_value
Date: Mon, 26 Oct 2026 18:55:55 -0400
Message-ID: <2026-10-26-1-daily-reply-0004-damon-zero-target-value-7-3@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261026133320.68445-1-sj@kernel.org>
References: <20261026133320.68445-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 99A73C0004
X-Stat-Signature: e15ww5h1hn6t3hds9c4qymy3e4udsyum
X-Rspam-User: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793055368-678731
X-HE-Meta: U2FsdGVkX19KCTKtllXUZe3kTaUG1F2ZzqtUi0o6vUswBB13rmfRiTRbZdzMraob8/5FC9OUJgGK2Xb4eVMkHgTN/ONlZ0Y0HJJt9zjqeYuNIqe7B2yEXA+bknwmH/7IXXKQrcFkdbG9TtSNbxkvRbjVcyB1qGKbTLbXsB1BqzydD4p0OXjM3jBrCAX5zV0UgrsChq/2lKgUBgqDgp7/C0eCzZitNFGVpAX9bPdbV/YEoIHgr32UnaEPrQj5C+qRO1gT/rCfaY6bTw5SqBze7aVBYw469Y4NSgGvTmXihLBYVUrwKKSdqRV3qLlmMVD5Q/IXoyS7LrRUZA7Jf8nZsR/WY/aktj6lYgkMfRdSyiiFVevdKNssmoXU0aC8cJxd6zgZXwsvyDgS75Oa9+k+ZAn0YMoZPmuwHszDE8Wy5hWwwhaB/W4RyxuvnHqhoHxjrvwn94B6E23aas0gpUhgbW5XUcEVtegcebP1KLpiIEGPdCYXBUo5gXO+VIWz+zo5KGMah1TA1+g27CjWEJpBlRgyZOUrqBMLW8u4R6ny5lxdfffKpjY2owsL4AZ0bdeSBA+fOUf+CqGBav7XqDNYlbAgDc3eadJnlo2Wa9OOKdvrAe6hFt27ILOXBaJs0xB+QI5S5oNLvyHaiGj4emtXkRcB5Ko2FX4qLZnxk1UUXJs6FG2afJ0mWailaVUJPT8Ir0Rl65TfG+aHtfaWbRKJEKInQSsPE0VomeyMPUzqHepWFUgPNM/786WB44t2LymaumzKlC/hik7CpmP2SuUJBHuOB4aGrjtdv2uKniR9vWcH172W7JBISDPB9ULYgkhpb2bFr1qAEZ5Ksj4daaYbhXLFOlj9/1JldaFpiK0gQFfc0MEs1QqWgYvWbiDrCUojgFWa/cSliU/D3tfl+S2mgXv+CpjBGM5FycpmgJ2YckIfp3cOAhkoXC3y8KMvqml70O1J6HqfcN+5dIta+kC
 tSJSNIhp
 oMsUZuYtMpLunBsEUZ/xUB6hsba/CprqAiqn4PuSapIHDMBVoi+XF6qA/HJwzWvCfDGpmBVl+/0kec2WCptmA1XnajMV7/jgNzXVb656E211ivrjOFu8uiJBT6tzfdPnN38b4fSwFpj03NOtf1xJaQQNf25RRGYY3OSOOnMmUoC0C+2VHo16JaIXcmckGa4TN8w0p4ZGUC0cxbB2FIT5KS5/tytzMwsgS+yUjJ2EGhKyI3/6OQqzhw1mnjd5evVKy03Dk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> Notes for stable kernel porting.  The upstream commit doesn't have
> Fixes: and therefore not ported to stable kernels.  It turned out it
> fixes commit 8b549a4fd3c5 ("mm/damon/sysfs-schemes: commit damos quota
> goals user input to DAMOS") which was merged into v6.8.  The user impact
> is a race condition that can result in divide-by-zero.  Hence backport.

Queued for 7.3, thanks.

-- 
Thanks,
Sasha

