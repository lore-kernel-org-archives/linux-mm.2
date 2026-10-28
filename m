Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06B42606A329
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 14:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E/8uDbQC
Received: by kanga.kvack.org (Postfix)
	id 416F46B05BD; Wed, 28 Oct 2026 10:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C6746B05BF; Wed, 28 Oct 2026 10:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DCF56B05C0; Wed, 28 Oct 2026 10:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 088666B05BD
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:14:41 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D1331A03D0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:14:40 +0000 (UTC)
X-FDA: 85372230720.12.4A28D73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id F2C4880004
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 14:14:38 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E/8uDbQC";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793196879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dcLt9dyzwjAnym8V24jziGssbE22lwtpvcDh5iVGI4s=;
	b=hUlcKiVNm3HSiSTOkKZOapYkCiRZ/5XVQVeivnSyR0Q+jovrcfbnaLIUYiL6Zc2XoRdeAn
	2LLAxKZZaeNctjNQfiySxKUbz+bmyzT1C9q5ZMqgWb4BniqPnpSaXJ4rTf78HeFI3f2h68
	0jfMjuDzw/nRw95Xq5LeLheNAKvs1eQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="E/8uDbQC";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793196879;
	b=rawQwkUkt8MN4K+b+77NSXci8wb4SRz3CxxiYnZQJoQaBkqkvhCwldFg2/CtmHIwEs0JtH
	6XMkL97tmRZbGInOkAbzGcDei11QW38WmeyhD3TUtlnIQriEyfOyrHJop1uDtRLQSp6k+h
	C6ShaZGg/qvV8Y0DupIPnvUBNpfVII8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 366CC42B15;
	Wed, 28 Oct 2026 14:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E26B01F01825;
	Wed, 28 Oct 2026 14:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793196878;
	bh=dcLt9dyzwjAnym8V24jziGssbE22lwtpvcDh5iVGI4s=;
	h=From:To:Cc:Subject:Date;
	b=E/8uDbQCjA7y8LJJBJHSLyBMSNFEaxjqo2hQNv37R3TQwDGE38lfwf9/ACcypC0jj
	 s9wPJJisFGfZf4otFZUnHJw3qsPEXALmFsv6HWy74yD2dlBIupoFi5jhynMaphokcu
	 8XB81Yf6OIAh8mVWC1zZ1eJPfFb60eqKlfRCK2P4yohnA/9t64dCOxD8sAxoEmRJMc
	 W3wnE52M2JR/jCHBittrGc45mG1GSuwURqLILSGqGfM7W7Jazh5xKCJX5S+xXpDhOb
	 Qcmb5DlMqEuturIl5kG7giJSjg0stSdpdJyWV80ARB9yRaK8v7ZVZDAV+i9WjbiEbf
	 8qxvi/osMdzwA==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.6.y 0/2] mm/damon/sysfs: fix pid leaks from wrong error handlings
Date: Wed, 28 Oct 2026 07:14:27 -0700
Message-ID: <20261028141430.161175-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F2C4880004
X-Stat-Signature: t5df9rkdr5r95it18pf9pnux66ebn4tj
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793196878-499978
X-HE-Meta: U2FsdGVkX1+wHoqASj/t4qbiFV8jNzvaCdBADRnA9E9G2GHYiFV88bWcr58yQ2dApaqs0t6K/m8H10YGq/RNuPJC7dsz1G68uGmI2r6XEbfP+aKW8jJkV7AMMqmewwOPwdgSrzeM3kRuIxzWw0UdoCQyc4xz6ufpKKIgkmgqE5iac7AjbzUpcmt50oINsn5SwxAQHnbYlhsuqNcxxsnoadb7v1ykDRmZThVGDnVcibyalTnQfd5gJBYalAa5qSej92taT4RqZASsMnd0H0NNogKqnZVAnChjJsqhnHNnbSrFmTg+dC/I75WKJaa75GnhsEdk3f7Ev3TkMpc7Xu8PuDcZ3jF84xE+mAX7ZVJBETSt4WjqpVdxEVM2wq96aQ3bI3Fp9t/tsrmv9I2sv+OH7uPN+hnir5dRIXEvL6o3VEwUk/l2EhROn9w2jarkXXtLk9Ss4TTIXW5qTB0U2YiqiIAStapyyioMFVMkq3Wxu/vLrM2DIaj73y4K1Uj5Qi/sVFJ9ca3uvdAezUKFHpJ9BKXFO4YgVLkoEnecx8/9AMkTH6z6HCDu5mvYp0Rc4vtCzeMhWHe+Ll+E5y1SfGouneJ9IknHdpTDS/qFk1elmOrBxTiv7L2kxfITlDlqG0RK/XXD73Yn4/RzyuUpxDwtMDFyFJq1cqu+5v/5pbah9ilwLEci0xVcHiNqGXzFc8wQhHJZUK8TdSqSgTFj/xioDwJqLWxdAsKlAWUQj3/F/qc0duatmRte1WeDY0GjYS5LNIr9rxi5V1mi9F0qCuyW7q1+uFPVmgyIDhv5VGlkf1WqKRXoIJh3nEWOm2zvbQpkvlC+hwWeItFuCdTalXB+DHN4jpEE2h2csyfkyjvD81uWKf+9JM5dV7RHEuh89wZYaT8bBiOjNDKyhFSjslzNtY5gWpkHrxnXoN4TCwYP1p6xRa64oZdEfQIVY8RXobNh84S60dMYSjMkiAJCsgq
 IBigwyoM
 0ysNQ9DSIlWRjRxocURQ4zRDkjP/mm5t68Oqf3svoWIFs+dCjzoNLlz+qr9+nHiV9uIBiV2kDWZ+ga33b7ubhBc3fSkrZtWxi1VkF++G9y9Szfrp3haQgdhuUjuJGyZiaQB9MdWoyXa33AntIZbXcHHOw9Ss440tthBNy3rTcTHLjYKAlvN6annASMBEJ2taDYKAun4W20YhERyra89wuOJtyxddYeUXf+U6UwB27JU5qQrw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

DAMON sysfs interface can leak pids due to wrong error handlings.  The
issue in the mainline has been fixed with code refactoring.  The
refactoring is done with commits including 7114bc5e01cf ("mm/damon/core:
add cleanup_target() ops callback").   Porting all the refactoring
changes to old stable kernels will be challenging.  Hence submitting
this non-mainline hotfix series.

Changes from RFC
- RFC: https://lore.kernel.org/20261028045902.148624-1-sj@kernel.org
- Drop RFC tag.

SJ Park (2):
  mm/damon/sysfs: put target pids for damon_start() failure
  mm/damon/sysfs: put target pids for apply_inputs() failure

 mm/damon/sysfs.c | 2 ++
 1 file changed, 2 insertions(+)


base-commit: e242a25af30b4e817ad5b8ecb336201e386a87ea
-- 
2.47.3

