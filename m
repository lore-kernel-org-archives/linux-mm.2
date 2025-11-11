Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7FB7CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:44:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10768E0012; Tue, 11 Nov 2025 13:44:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C1628E0011; Tue, 11 Nov 2025 13:44:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 861FF8E0012; Tue, 11 Nov 2025 13:44:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 728F68E0011
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:44:31 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B3C51A0174
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:31 +0000 (UTC)
X-FDA: 84099201942.18.B146C73
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id AE2D080003
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Nz/BecqM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762886669; a=rsa-sha256;
	cv=none;
	b=7KopB+cnXaYhFJN3ucuVsjW6tpgUHLWFH9ZTuUVRA6TNLh6pk15iw2gmvMXHxvV/RE+5Kr
	gClwlVUqkgoFi60UZ+/Q+cG2QFPV9MrZv3WgeWaDFyqjfhziHDteOK4C72ZooZ9q3b7h0g
	GStmhn73yGW2ZVyZ7c45b2fBAjF0+Y4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Nz/BecqM";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762886669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=y4mHkNTdE/EGu9quYeF9TBXV28VECsvTeCKjU/8ifMA=;
	b=e5BHQH3ywOeRhG0ulArmXz2rgI7Okg2eCxmhdqTpPUYTJ6kIYaeTpdJQBlEMrAE/lH6SFE
	HJKfZYM5EkHraSwMS9v4V7auZ8X8P7hQEFNB5MnIleCIgpLBO1KMWX/u37yXgVvxcogGfv
	EbxwMtcAf8gq4kF/w/GHh9/c284PJwI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 08DD8441B5;
	Tue, 11 Nov 2025 18:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFCDAC16AAE;
	Tue, 11 Nov 2025 18:44:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762886666;
	bh=m2hHKtIlg5ETlXGHsaViOdGrXByOpAXl7sGM5smf3nI=;
	h=From:To:Cc:Subject:Date:From;
	b=Nz/BecqMuxBuI+lNBLETRFlGtiVXVLN4K+dCBpk3eY9BC1/3fVqpb/hTqL4w+KvOp
	 Kgefl7VDI4E4xTEyMn75nXstAkJI4qhaAZE4IYO5AQd9U1xYHh6KuJGkRD44Kb9dWC
	 kOjwltrWdmLoAX8VDNL3F76Y0otKH/XvDNjv0IclF0m9PCW6o0qm6vBII4PEF7Uzja
	 DMXMT5cb9iJoLUGnZZ0gnOWY08hSJd22zNikESwzBOzpqhg5drTTx0xFLwKOehZGZJ
	 54aapKTRXzMrQwvFuPI+a8q1YPbpgIc8GNkw3vfo51eqQT9i1nCyJ6QWwB+oNNrVgf
	 E8Wb4WqQVA2Mw==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 00/11] mm/damon/tests: add more tests for online parameters commit
Date: Tue, 11 Nov 2025 10:43:59 -0800
Message-ID: <20251111184415.141757-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AE2D080003
X-Stat-Signature: eh66zkscpxtf9jice3oyx96r1jc9695c
X-HE-Tag: 1762886669-894100
X-HE-Meta: U2FsdGVkX1/xyXH89ZXy/9faVW2nD9lv7YaUezXV0xnXN+ABawL/twf2S+VzHPY4IqliGc1HrXZaQdoxeWHpslDfg3xMFNgQBn4j5MYuaI1g9jaK0ort4JuQAdCR1CbOAsa6qAhNDFI0txdJ75D7mwYzLpCfo22/E2SSrqI2dtkrF5KS/K+TLDZ+mkifl8yJzWkYKAZ0SfKt1iyY3zcEObFnro1aNmXFjqhNzIYdkvZgk/oCSc00vltc3oPVGrnO+nTBroVvW7IPYg+eO/nHu5/x0edbRuxma74/dA4FTa5DTM0r6IhwDHsE8HKkmibzuHgy4vJpdErhCCDuYOOb3A4ybZ+CdOIQFL7stUqcknZu3LCE04FJ1oMQJGs6CkW9xwneBIJVlcZOX0QvQBxeTMrQR1e/rWRdm2DnxuIi2MPFNGgVS+KrLlK7gXGzLLIsmlxSNUlbQB71aFj3Tkr6beXWuYpYK+Vg1Of1J9a8rl89+HIingZbBAXKbYj3768ZFT5USKBZXzvwj6vI0SxyC5d+viLTwkbIYXpMt2T6jZeYPEpRufjojah6CaDvnesPEF+PxFmaNp9dV1La+S0CM0rhhp2aAq8JrXfgt3b7I4ur7D9sFtFDaPOKeU85WOnGI3ZCaiJrMWS7pMqRzJELJnnodVVQwPa6bx1qYxB2kYDiVJ4o2oXjvJ6gbJ1ZyjgoCTk/Fwfjwc1heToczEmipFlY4TSxb/1z8ApXCVQpC5mpJt+ZdLLhbWi8Mn86DRg7vmfmz/tv8HI3sT8u/iWfEli/PDwrGonxHb5ST5EoUotKQcv8Z/cZD/+iUnTDAUr6tc5OzJ+aWIU9ztHImhKWW/obQ2ux8uIyC1GzIVz7y+MBk2XLWksdg0eWS8WUrAOXTzVZ04gay30NW+paH4JKWDzLQlbZWkg8ZIJpGgoa1ACIlpbo6/ezdpRgUzIhBzx7yyS3c5UCk0l0yd8mhkT
 da9UM+4D
 qTuDqQkDSBNJNAwhihFPhNt+nOoHywZxWVBfRK1qAasFPLvdHKZLt8DKgm4ptRtd44Td0zuF1MyUCCVVN8LtsMKk5kVohhRCkuvZ9Afe88SQO53+uBY2R4P+LdldbpqVljCIH5jxTW1f2PBomH/+/+Q+ijCiVCIeG2k2Al7iYIBBqFBzXChZkAW3Jmh+3N0RnbaRWHBdelRHwGkk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A DAMON feature called parameters "commit" allows DAMON API callers and
ABI users to update nearly every DAMON parameter while DAMON is running.
This is being used for flexible DAMON use cases such as taking a
snapshot of the monitoring results with minimum overhead, or adjusting
access-aware system operations (DAMOS) for user-space driven auto-tuning
or investigations.

Compared to the usefulness of the feature and size of the
implementation, the test coverage is pretty small.  Only the filter
commit part has a single test case, namely damos_test_commit_filter().
Actually, we found and fixed a few bugs of the feature in the past.  The
single existing test was also added to avoid reintroduction of a found
bug.

Add more unit tests for the feature.

First four patches (1-4) refactor and extend the existing test for DAMOS
filter commit for multiple test cases.

Next three patches (5-7) add tests for DAMOS quota commit.

Next two patches (8 and 9) refactor damos_commit_dests() for ease of
code reading and test writing, and implement a new unit test of the
function that is being refactored in a test-friendly way.

Final two patches (10 and 11) further add new unit tests for
damos_commit() and damon_commit_target_regions().

SeongJae Park (11):
  mm/damon/tests/core-kunit: remove dynamic allocs on
    damos_test_commit_filter()
  mm/damon/tests/core-kunit: split out damos_test_commit_filter() core
    logic
  mm/damon/tests/core-kunit: extend damos_test_commit_filter_for() for
    union fields
  mm/damon/tests/core-kunit: add test cases to
    damos_test_commit_filter()
  mm/damon/tests/core-kunit: add damos_commit_quota_goal() test
  mm/damon/tests/core-kunit: add damos_commit_quota_goals() test
  mm/damon/tests/core-kunit: add damos_commit_quota() test
  mm/damon/core: pass migrate_dests to damos_commit_dests()
  mm/damon/tests/core-kunit: add damos_commit_dests() test
  mm/damon/tests/core-kunit: add damos_commit() test
  mm/damon/tests/core-kunit: add damon_commit_target_regions() test

 mm/damon/core.c             |  38 ++-
 mm/damon/tests/core-kunit.h | 544 +++++++++++++++++++++++++++++++++++-
 2 files changed, 547 insertions(+), 35 deletions(-)


base-commit: 620a4c1c5116eb811807ea7e63d61846015f69c8
-- 
2.47.3

