Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56704FC0342
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 15:03:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA9676B0005; Thu, 23 Apr 2026 11:03:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B59B86B008A; Thu, 23 Apr 2026 11:03:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6F646B0093; Thu, 23 Apr 2026 11:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 95E6B6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:03:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3323140273
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:03:05 +0000 (UTC)
X-FDA: 84690138330.05.6915D31
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5C722180004
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 15:03:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s9++1bKZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776956583; a=rsa-sha256;
	cv=none;
	b=psEm/icbvQmVHCL/Xp2Qknt688/cKHUeIEsn3/1CQAYJGt7YlCo7wAhazIzlTREmeSgrBC
	owk1+UC0cYB8gY6lyuJdksDwENAuQUS8l99NCAz/BJYTtIWs2u8FgEg7slJNo7dq7xB1/v
	gQv3Da2kJaqqTyv6k+BvCEM/bkpNVKg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s9++1bKZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776956583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RKHCHCe0pmoPcECwaTmWcIE27CrGNeqC4X3BUhLLxG0=;
	b=CVhWt/uURPgvi6Dt3T50RkuC5ZbbOGEYe+faXskrW9kt8wVe3TPx9TGFVp5Hqeolv88iKO
	tQDLcLIXYaPloQwWHeHLoF8ismcMN8DI8iu6HS66agbNOS2cgCGmYcIxIpFwRrsZpoMXxd
	O4Rd6I+P8z/jAldzD59X57294Zk95Z4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A7B343597;
	Thu, 23 Apr 2026 15:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D6FC2BCAF;
	Thu, 23 Apr 2026 15:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776956582;
	bh=rQtJyg98FPKQTGRAUXuSfYXDH7AOf6p1ENCuefnOVK8=;
	h=From:To:Cc:Subject:Date:From;
	b=s9++1bKZIRQFMWLOYuaJsuL4IQQDmbqEmbx20BBr+2XLP36ZgEIDUA+1dQrUUALOm
	 Xup12QRFQ/4GBYsi2Pye3ObpCvg8lsOi66YlxwFJHaalagYQ7AC0t5lkhLBmHtauhP
	 PzPZREJdJbzgYgHp9/M88z55JDauXRC1h10GYZpjFGVuBwcs3iz1fGBMtH6VpT/Ji6
	 JffDgyRxI/KvdvvVyLnKn0vJ2ABb79MS3NmWevwQNgZUzVzFx7XOkWnbuRngbZ7x6L
	 EOBiY/+kSlzqC4WsErkL/NdNZWFB7fDbNyNSZXd3zXXm4tAzx630bUan5ruymYMVJ5
	 g9/ZVHGxQ3C7Q==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 16 . x" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/damon/sysfs-schemes: fix use-after-free for [memcg_]path
Date: Thu, 23 Apr 2026 08:02:50 -0700
Message-ID: <20260423150253.111520-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5C722180004
X-Rspamd-Server: rspam12
X-Stat-Signature: nf34itk9tfz4e6dcgzj33dt7wr54j7i6
X-Rspam-User: 
X-HE-Tag: 1776956583-857381
X-HE-Meta: U2FsdGVkX1/S8u6ZZeWs4ya4RTYVdeMBpchaz3TstjbNRErgbELFEnMnRu/Nsp8ImhzboC5RmREoNn2hvs/jGbJl+wcuECIop8MkUVpd0kjVDtY1njiETgCtBFcaJNQq8kaDPOI0Pytz7V+wP8nzo9KgGJ7WrcxeYYMvbV+aAuu3vWhHjwr4zCnGAcEJ0064QAq3CSVwOSz2w8OxkDfe/x6dPn08kF/HcknfLZKQjv6amAizWpQspNNUKTJQPRk8JOtiaZ8O3KDic/84rIuN5yPYcTkvc5eK2Jiamzf4FjNBeUZwaexr0CGJgFDBamjipi87WmX7Z7KLlmvD4qhuSYojiYhagDlWfXOZyoax8JqdkXex4OLlKh5qE9Yi8UfEz/Najp6Ofl7tNi/hkgCA0Q1vBA/wB6WqcYg44MxR+C6cCLGYdyQ95CskcGqFuLsKWf9RbWIMmrvO0nVJRhXxCoQKsCLUlBxHTTDYjeiVDXXn32x7jBhMSWcQdZ8EthZQ4PjYTiCKLNHzWE7ATt5IqGGQNFs/eDB+475/XVPahkOtUkQIVs2iaIBrnDX3WnYDa/dGCcaghPCLt4DapZIrQR4Xa5Y0XNLWaejfJ+UnIsm4xSFrrXr8tVyJJV+cZQsPd4pvW5tef+e1GYgOWXlyYaMhO6/Z4hGI7hiahNjDTUmwLLklTKrYoH83vUv3IjpfRpF1dn83uNhJKwqUC+duigwqbsoyDmAohmg8WnX871MFygLz0TveEsy2vkNyBwRlAx/KsgP7JY+hpJNjGT/2woROP2bOTREpq6Kq0hBT+L23ZOeoqJr0O7fcGrluQrZWA/DvfSThkFdD4l2XPWT/DzekmmD+DSCGAWQldMeabCIGUkZiCFWhH6i8PuNVISoMFnWhdmjHILZLR2dvLACAqbk+Cgpy2JJdlPodoqwQfgG9XZcE6m97KClMlGfNEAql6WWVm95Dn0Ev0nwRJJn
 HR8+qv14
 4+Q2jbT+k5Mo7sD06eiew7Ea9myRcspC7dOGO9L+nJ+2QuiIa+wPSK9/07X9ls7pmpMf0KZkW6se+yFWftRtR9mHIZh7ju7rRWD/BjNMQws9nGMiYO1bBNul4L3eGQ0giY96e5iKqGZJFjifRpY/rmjIIceIRt8N0dkhBh8Cf5Na8163GWH6dNGNLcb6CaUnMyr2mzh1lqn+F8xNcqbR75fjCeA71NzJkpG4FLbkkks1cIs/dSdL9J+pVALbuh+Euvu2HQ3iOc6HWlfNpYZzqvuk+WVyb8hfPjBKKZLtpI38qZTg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reads of 'memcg_path' and 'path' files in DAMON sysfs interface could
race with their writes, results in use-after-free.  Fix those.

Changes from RFC
- rfc: https://lore.kernel.org/20260422144059.72000-1-sj@kernel.org
- Fix a typo in commit description.
- Drop RFC tag.
- Rebase to latest mm-hotfixes-unstable.
Changes from v2
- v2: https://lore.kernel.org/20260420125405.362137-1-qjx1298677004@gmail.com
- Split patch for individual fixes commits.
- Hand-off authorship to SJ, give Co-developed-by: to Junxi.
- Use mutex_trylock() instead of mutex_lock().
- Add RFC tag for Sashiko review round.
- Wordsmith commit messages.
Changes from v1
- v1: https://lore.kernel.org/20260420085332.178473-1-qjx1298677004@gmail.com
- Protect not only user-writes but also user-reads.

SeongJae Park (2):
  mm/damon/sysfs-schemes: protect memcg_path kfree() with
    damon_sysfs_lock
  mm/damon/sysfs-schemes: protect path kfree() with damon_sysfs_lock

 mm/damon/sysfs-schemes.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)


base-commit: 26232ccdfcc7029d92b633b01f5f22913ab72168
-- 
2.47.3

