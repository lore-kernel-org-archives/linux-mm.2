Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD616CCD195
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 20:44:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE96E8E0003; Sat, 18 Oct 2025 16:44:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A99388E0002; Sat, 18 Oct 2025 16:44:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AECD8E0003; Sat, 18 Oct 2025 16:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 87ED68E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 16:44:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 26B5787F4D
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 20:44:55 +0000 (UTC)
X-FDA: 84012414150.20.848C49E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A33DF140004
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 20:44:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f7I73goU;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760820293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=xoe6IjBlkphyBMWlMK98UKkXJd44k3JQ5QlUK3b9+E8=;
	b=4TS/JzSUsc/4dvp7L4fny74my3UnW9/2MOQkidMjMO9MWC1gSGbnKkTRAMDoJsFpGOdBjP
	8XW4aRtJd8SLDENuKZ4FDKM9sgpztTUIFrxwy1XzIqHQid9nowz/FHFist80KA/QUCaURP
	3fMkawww3zIsSceJrSUx+Y5m0Q8j7YY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760820293; a=rsa-sha256;
	cv=none;
	b=tZN6xr0RfeNjGzmYTi4/G+fHC3aBcO6LQGsyE06hpDvc6kCD1pbzecBg5uOoriSTByg6ZJ
	L4YnYJ4rSXTZObmmqmvIO2lxV+KXnQjLXZPtqQxHGSkkG4R86IdEhyJ5tkCdDkaBb7E764
	b912oTRlDI/4/q+uBngWGhXxkm+lmu4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=f7I73goU;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D267260225;
	Sat, 18 Oct 2025 20:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29529C4CEF8;
	Sat, 18 Oct 2025 20:44:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760820292;
	bh=CeZZk9p5z6KkgS+x4IVFKcC4JWjTbvSMfd0yyRSruDY=;
	h=From:To:Cc:Subject:Date:From;
	b=f7I73goUIQgzvVeUabqDD8fY5jbdxieK4x5mjlKJPTGypIiqKbjsZntJR3jrTbKui
	 3bk/9TD3om0MatV/qQw6rMSvtZZVEwvB5er/jlIDkqNHqZprevvQ3CabjF2uMCayQK
	 al6YEuwFeKp0jxe44zwxDLo2JtWm5mt9EWx1hYK+7bp7jCRtF0v7YnQxehhqWkntUR
	 1g/E8zeIntDKzD4+ybhrg2nQ0sLWk/2A6UUDDJMn61eR6dQQV1hFhU1E9A/2IDucz7
	 VA5Oraxe5hzKAaKGos/Y9iZwbyEj9w6avLQtJLRJ9sDYNIh+k4NLc041IndztpdDHq
	 To3/4ZT7ON2DQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bijan Tabatabai <bijan311@gmail.com>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 0/4] selftests/damon: add a test for obsolete_target sysfs file
Date: Sat, 18 Oct 2025 13:44:41 -0700
Message-ID: <20251018204448.8906-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Stat-Signature: 76a6d8awfewhpb4jtbxaz7nji5ff5id4
X-Rspam-User: 
X-Rspamd-Queue-Id: A33DF140004
X-HE-Tag: 1760820293-935085
X-HE-Meta: U2FsdGVkX1/BI+jzSsFx9t0nEzsQ9HWNmbbiAzMDFHYWsegIfOuh6FsyXj3sn7I/teqKQQSEcQFwIj39SMYdLFOQwSUgSjwmpZ0mEmeOf6tOnhlau2Wi4h8G/hgidKNiPEhhVlcn7P8ER0A9Qchgtj++fJp7cfwTiPOA/5M/IsV9Uwl4KYpJseF3CjpdlBsJkD3GNLrv8hwTbVEcp2tH/oTZ2GUPgA3oELeGIS5WQPDx9cUG4lPJL+BuaSI5TfqA56LFDA55dfHHA12KGUxtJ5MmAy1bJlQyhlKF6S1rfnWmHGGN3szzetkAgYAKqFbFkqIjNj6Hqb0rI7kVKyw87felz3xkJqd34XG2NagKl86ZJYxBAzsjWhM4fewCzKuyeIpQc+psDSFR/XA/+yWJh5217nHfB92cdmlSrhq2uqJBM8aEmcfCKf+zds9uy/AMLM5TWH95+n7vOD4zzX4KvXMCEQm78RCTUDQFn05dLL4yp56JKvmOPNsGGabUs3hxxtyDSVpInbyPAxKAQFJic40i95srW4XtjCOH6Uef6msNMFDio2/x39OH7VYn8PTOdMJWP7cZbx96g3vsmrSwM0aqbtgzRUZluBNSNRd3eJrHWm2dfikE6iEJyJz/e7NoPK0LowZgAlYbBRH4kL3s6k+FZ23uPMusCJdZbD+vjtE5E/j+3tRG0JIGjAU9VPrPCO0Nm1QgXThJR2BbmvuKOXKUftDtqCg56rTYcA6N9auOIKm6YjAN+VKOyQZR7PsZhtTq6fQMNXQKmNgQgaPMZFa4R2DidFJgUcp/BJ2ftrMOdEj8HDSaniGt/x4Qgwm5UojMxnDtVwLjntPyYvmMZxPxVQ64/M3vtjAgkvp2YlF5cXzpO1PUf7pboLnTW3nVu1dzqeaUGpII0aD9c2GCZuTE+KpsbXbVb7k2thvhmVk6egxg1U3JNA+IpWJt0tMoLgYqm+EDBRhM9VRMFOW
 ByB9cSUz
 QMyyF3imQPibuWhPfLikf20rf4CoV4+qCHJEO1uProHLHMpSYUxK1qARezHpAvuR9Uk07YA++s4ootuw6RZpb/c7Y4XJpSrKdl6NU8UDOXL67RYz7G5UWpirwdyXCe3DMubP5SyHXKJNcKReWbY66bunM5LOR1QRZsW+C0YaCjVjGEvJMtAmx/hdbgYBvM58t8OC1Q/31N3LsvK7sCK1VzvTYiYjudqaqu/2XUaQXrnnil0gFhaFpiYBzv9DNpOU7hUj9Y4XK81LTSDTRQtVsi+SnLg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

An RFC patch series [1] that add a new DAMON sysfs file for arbitrary
targets removal is under review.  Add a selftest for the feature.  The
new test uses the feature using the python wrapper of DAMON sysfs
interface, and confirm the expected internal data structure change is
made using drgn.

So this patch series may better to be a part of the other one [1] that
introduces the obsolete_target file.  But, because no significant change
is requested on the series so far, I'm posting this as an individual
RFC.

In the next version, I may merge the two series into one, to add all
related changes at one step.

[1] https://lore.kernel.org/20251016214736.84286-1-sj@kernel.org

SeongJae Park (4):
  selftests/damon/_damon_sysfs: support obsolete_target file
  drgn_dump_damon_status: dump damon_target->obsolete
  sysfs.py: extend assert_ctx_committed() for monitoring targets
  selftests/damon/sysfs: add obsolete_target test

 tools/testing/selftests/damon/_damon_sysfs.py | 11 ++++-
 .../selftests/damon/drgn_dump_damon_status.py |  1 +
 tools/testing/selftests/damon/sysfs.py        | 48 +++++++++++++++++++
 3 files changed, 58 insertions(+), 2 deletions(-)


base-commit: 1aba8bd57e6aaa1c9e699c8de66bcc931d4b1116
-- 
2.47.3

