Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 689A8CCD193
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 17:52:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66A98E0116; Tue, 14 Oct 2025 13:52:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B17EF8E0090; Tue, 14 Oct 2025 13:52:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A54D88E0116; Tue, 14 Oct 2025 13:52:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 93CD48E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:52:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 39E4FC0A2D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:52:18 +0000 (UTC)
X-FDA: 83997463956.16.A948997
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id BEEFC80002
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 17:52:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EX66bqz3;
	spf=pass (imf30.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760464336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hvMiWLq2oPuMCkA+sTQumqKiNf08Ubkr3DoFqm35Ze8=;
	b=nlGdiYsvKW6bwpHOkkqrcwcBa8dmhBKiLDUvioxsJ3K8hP4i4tmjmfQcNh/tNGoJWyVsSG
	ga44s6dTJt2lidJq3EGCLZrKXxiDomDPzJEJo6hK3AQpEpVyXdCkbY7HKBf3OdKvF3w60p
	st7WCC5vtxSueWXQwsSE0j9WXblJkE0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EX66bqz3;
	spf=pass (imf30.hostedemail.com: domain of djwong@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=djwong@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760464336; a=rsa-sha256;
	cv=none;
	b=qlMykSdXgM11XN5pGUC7cHMCloTf8CKuY+k29I0QaxXnmhA88pvNM2jt9NxugQgsHUzPtq
	35xlZZuVUj8NbxaFk+KQA+Jwv9BPPCpTvTEQtTAY/7AxAxUpIJ/n+joJ4Sfw4o3WmfVyhq
	64jGEj0zV1kBd8JJJ0RP0OR4y6ptGZE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BA3926051E;
	Tue, 14 Oct 2025 17:52:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66430C4CEE7;
	Tue, 14 Oct 2025 17:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760464335;
	bh=GVdXnKSzFxC1fusf6WmdE8ZRuGvCFvTlScHIB6DDkSQ=;
	h=Date:From:To:Cc:Subject:From;
	b=EX66bqz3LCrk7qT3cBb1T22aApDn8VSKyFoPU70HqIhOfow7M3AMIskIcYbOfonHc
	 AhTTn1w1QgbVAukW+n5HUfqFdtZXgHebnQBdfprpAUl/fc9VyGuQa9MHogjRV0pLJI
	 dg+pUPCReF6yINar28kgy0SuoW8rzxdAaQa4cheIyNtHi03/GTl4XvP/BjwRG5zqQa
	 ZXo0VenEAT86IqxhhiqOcGRefG+9NgsvhUGtdPaymhxdvQcg+3Bow+wBcung0drNnL
	 cwaKWwB/BHafig81SxnqIAMgZmFSML42uN3R+EUdGRshV4dM27mdALAORtVhijkeRH
	 pCFiC4XoVaGAw==
Date: Tue, 14 Oct 2025 10:52:14 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: kirill@shutemov.name, akpm@linux-foundation.org
Cc: linux-mm <linux-mm@kvack.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>,
	Matthew Wilcox <willy@infradead.org>
Subject: Regression in generic/749 with 8k fsblock size on 6.18-rc1
Message-ID: <20251014175214.GW6188@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: sxmqyy55msroipoc4j1f96idokyeubto
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BEEFC80002
X-HE-Tag: 1760464336-68407
X-HE-Meta: U2FsdGVkX18Bc09WA9Q26OZcfCUuloYG9EfLKUE2wGC0qTGPxpulmriJjuK5zHkIGYhagoCTzOYhry9jm0OboHdoCPoVUzYKE59yD8AEZ6k3cWz3zSJhzuaXKBiQ/48xdtUR4ODVvNqTB1BQn25a4sCkUN5LVKvn6vTkf9kVL4LQOjS9tRbWd1L5ysW/sekpioVphrnB3kzZ6PBHI27PK20QdZxOFROtDRTCCXUpnYz9CGF5NKsPjrUntvT+adwhiDUUX71V/2cVca+fJZr7LPUwuadzXDr/7x3NJ+ISgKfCifq6BB7cAy6XRqjLn0B2nqbbFl9Xgxcb0gymfTsmsRCKIbbbcf3K5iF5LykiAtpS58L83sewgybTA9KRnFxg6avdqJGYypiNCKRyy/M+pFNRodigDXpJ3Kp7VFlgoSqZTJ4ozX48sM+dVp0LvBHlmpISWMFbdBPvBhusjzRJzU3TDi85o3c/RznWV6KYUp5kkQbfJZZhnAmH7BFy/3k62UhyvFMJBSpFl/A1CT8v40rqJ/uNuUPAXl5PX67f2k0nulhc4jilNIvxg22LrZAGVQYmepD6nLkVL0iM72CKakCuFAkHYvWMmKiOat2SsvB8j5yml68RAFw38kYlFz1L/hxMo2glGprgOjpd+2QOYDhUbBhc5/lV5HOoh495zUBpJAKh8F8ZCg9KlGKYnqVe4WFmsKOzL+481mz/u/rtGJQfJvTx5q1c0cN4POF6jSH8D/8VGD+IsAJrVAcmtCbSpeVb7aoer8mGGxTJdPMDD7vAGanoVjpker4XGHnk+siSQ5qWiYj0LSVmYIsP+6VIGb3z+QhNoKPqzDTNZRGvC1HbZ8UffUNrfJiUYm278JVe5ywukhqhNqUCSlKaUpBuyLNhtyjBzyDRod6ya88F9i7MfAtcfzxBlqHulEiD/CMfamnIRGdq4ZLmNvrpnp4UlshYgf5FH4ntavsWagj
 wSUYJnkU
 GLTQGoS1RtfrNBRALJulE2TY0Gc0dbunQ9Mmkg7Gtpsxt22dLekoq5X+V76mRVxbaTmiLiRSwaIYdNUIQOKJbU3jaHIMK46WUlhR3ktA1ib5/Qzp71zSeUQwwJqQtI2TDi5MrNfIUlyGvqbWcE7BB03Rz6Fl7FZ7W43NF0csTY0gLlOEre4LGtV3EiKZb7rn4UfVpZklBBu/yKduamLvAGnuXUC/0+wRDKYIU8wuMeRCM72o+30oR/xYliUR6Sl5DjC6p8Pk6x7vAU+0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi there,

On 6.18-rc1, generic/749[1] running on XFS with an 8k fsblock size fails
with the following:

--- /run/fstests/bin/tests/generic/749.out	2025-07-15 14:45:15.170416031 -0700
+++ /var/tmp/fstests/generic/749.out.bad	2025-10-13 17:48:53.079872054 -0700
@@ -1,2 +1,10 @@
 QA output created by 749
+Expected SIGBUS when mmap() reading beyond page boundary
+Expected SIGBUS when mmap() writing beyond page boundary
+Expected SIGBUS when mmap() reading beyond page boundary
+Expected SIGBUS when mmap() writing beyond page boundary
+Expected SIGBUS when mmap() reading beyond page boundary
+Expected SIGBUS when mmap() writing beyond page boundary
+Expected SIGBUS when mmap() reading beyond page boundary
+Expected SIGBUS when mmap() writing beyond page boundary
 Silence is golden

This test creates small files of various sizes, maps the EOF block, and
checks that you can read and write to the mmap'd page up to (but not
beyond) the next page boundary.

For 8k fsblock filesystems on x86, the pagecache creates a single 8k
folio to cache the entire fsblock containing EOF.  If EOF is in the
first 4096 bytes of that 8k fsblock, then it should be possible to do a
mmap read/write of the first 4k, but not the second 4k.  Memory accesses
to the second 4096 bytes should produce a SIGBUS.

I think the changes introduced in the two patches:

 * mm/fault: Try to map the entire file folio in finish_fault()
 * mm/filemap: Map entire large folio faultaround

break that SIGBUS behavior by mapping the entire 8k folio into the
process.

Reverting thes two patches on an 6.18-rc1 kernel makes the regression go
away, but only by clumsily reverting to the 6.17 behavior where the
pagecache touched each base page of a large folio instead of doing
something to the whole folio at once.  I don't know what would be a good
solution, since you only need to do page-at-a-time for the EOF page, but
there's not really a good way to coordinate with i_size updates.

Did your testing also demonstrate this regression?

--D

[1] https://git.kernel.org/pub/scm/fs/xfs/xfstests-dev.git/tree/tests/generic/749?h=for-next

