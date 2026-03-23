Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45B14F46122
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 14:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF1376B008C; Mon, 23 Mar 2026 10:22:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9956B0092; Mon, 23 Mar 2026 10:22:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E01F6B0093; Mon, 23 Mar 2026 10:22:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8DC9A6B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:22:16 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6BC0ABCD4F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:22:16 +0000 (UTC)
X-FDA: 84577542672.03.AB066A3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id C85CC1C000B
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:22:14 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Je6IqAG6;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774275734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vAIpo1+pXFghf8xHFXZd4hZcT4usnAjWRVQg2Bl12e0=;
	b=WdPtJCNsAtKLOb4DQmDzjsffzNJwci8Hei2V6DEOs8uXT85NkIbEekwZFBdpgltEIlY4y6
	qnZt6YLZvutv4g1g/k3L2P3Uc5VzmJFzf4XfDjMHnlZFnKDqmbV0ddcWTYLseudkalsDeG
	LytKFZMK1NKvB9//TiLhASqfiLfbUpg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774275734; a=rsa-sha256;
	cv=none;
	b=5nHKxoh2s2/4o0Pag2LMAf0DYA0iZQXIxqNP8EPRSaEVOm20nQOH4pn+wwpUqws+U2zy88
	fsJi1ZzegzZnsLOV6GDbLCdpOQAU6gYGQt096fNpRBNd0CssDTQs+GTZ2PYjp7NpYjhTSF
	kcp0ds6ib3e2XBkdOHOVPr08JzDnuWE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Je6IqAG6;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 48D2860103;
	Mon, 23 Mar 2026 14:22:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3FC5C2BC9E;
	Mon, 23 Mar 2026 14:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774275734;
	bh=RjpDxLk9rU7OOSjXqNDUmgbPPvZ7Jn5hdcpGMM/hqqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Je6IqAG6WUMLRcNbhLvOyLKM4chp726sWaD4U0fTkFDYZ/X+ynopBGwRCK3i/hBMs
	 3Y1R5W2fJgAGoqOKwG/1WR3imUmUWZbaTV6UzTGF8JqJpmiAKISmtfJfEJ9wHXfUVS
	 D6Nj4nU7IuRpJkN16U34fOieKan2nvK0bWfcIyHEBj4rlm431zmbmvtLBHo60wzJNU
	 xHSSIGqgvWvLoVvRlnbAZryefGWhZy66UMRXNyABAe99meCauh2/DqEvlHvRGKXG+2
	 MzWoUJMo2qQVIoce2NaBuF9ekk2+NYz4/6J4zLPtqRftUG0H8Y7aDNJnqkGNErok4M
	 DnErARPseJXoQ==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC v3] mm/damon: add synchronous commit for commit_inputs
Date: Mon, 23 Mar 2026 07:22:06 -0700
Message-ID: <20260323142207.80553-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322231522.32700-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C85CC1C000B
X-Stat-Signature: 4kys1n6w7fjko8g9rj6mr7fte487fxpe
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774275734-476351
X-HE-Meta: U2FsdGVkX19II4qVQV5y5ciYheCf7Nli6UZWlrCpXvvZnLd+VIZNGC3LSY+x3m47J5v3eT3EVeSrRvlJPVYEdNp/PuwPv8dC4zpJg/4YYQy5v65Td0bqwfe522O+pO85Wh5LimuInRXzBlQ6KrvYJ1IVcXO2D1gxzCmTYZPdLtcWOOwE0VszFFVXN2Aglt5gHTvRIfS0OVY4srsfVaOyd44U0LNSvELKmBkx3G2iwqaUMBheBf4qKACGAZ6x7RGfUL3NMUJ2Tna2sAtAIs3Bb7t+n1MUugJWAcg8HWHbXMfoKM1H+tqAsprHDSKuCFBu12lYY3+R1L2amxezynmY6MypK53HWcPwt8IrNCSLHu+DJG1aYU5wsNDWZZMChBvVL2ng+YV/LKnx/0Mvnogtarw7HGB6eMRe4DeqXfY9E6ORvn58b/sK6HF8mcECKL78Zss9zQree85kUcDFt+wNLhYYrV8zHnI0yUc5qmlmusJf4iIcsW9XjP/U7G4brd1QTuAKUJxV8P+M5vK/QJrsNOeOF3hKEILo5WbQ4PXvl+fhr4Dfb/3a185InJq7zS+MFq03+Wm3lArBlzrdcvqiybkcNHYbsBEB5gVfmwGYzJfmYvBx5z/yixxJiwjT3mTQLPpFYsLrkbqORMCNmSfgwil5RG7fpGcSKk0HtPaFBjEslU2lseuAWPdSnFH2XzP+1XocvvLMH+1XUl1Z58lZaHYPnk89/P/JY5X1Zy7Q0fueELfpixwwp2+aI8eDOS9COTK75K7SEjvAoJxs4ciwUcKKqF7zNc+OM98vHLRARkHxwHzMgXMf3iNou0INt1oxjVCrzV/fO0M9aXRJSAKg5QugIpj8CTwE4Nr3RlVrI5e5r4bO+RG0AnPfPAKQ1O0CBNFnLqNPgHcrQ9WrO0bcCsgugJSJO38iduU13s8PovlJv+oTF3bNJQcloyWjEEF6CGGx6H3xiv7NKiASqQV
 4eQIvzgG
 0EdmR6UdCFCy9Wn0m1cljaToKjV1DSz27mOdUGVi+kvg/aTC2HgcxQPCHHORO809oySnLOIR8sHOtp90h/SQcypCzWVxBlsx1jZ/PDlrmf0hhb7ZgWqPzcn0wJaq4IceIvfGwzFr05l/Z5HBh3QROXJ09kAjt04o2VWiMMJ780pMVIcraqQTr30FARUrcAc2ld+bCXusfkH/OXsGfrvaJYDChFjw5Yit91F7LXnUMQSDbTuknKZiF8fXDZfWijlRBty87GnsQZ8VQLuBn1h3ZH4UrVBAf8aYFTKxSvLsuXw0cdfYzRQIP4oBSGJOmZb0hLiIy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Liew,


I show you posted rfc v4 of this patch [1].  So I'm skipping this.

[1] https://lore.kernel.org/20260323021648.6590-1-aethernet65535@gmail.com


Thanks,
SJ

[...]

