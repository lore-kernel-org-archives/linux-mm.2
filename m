Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 30890606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 15:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j7nkVgaa
Received: by kanga.kvack.org (Postfix)
	id 020656B05B4; Mon, 23 Nov 2026 10:09:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F13EA6B05B7; Mon, 23 Nov 2026 10:09:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E29E06B05BB; Mon, 23 Nov 2026 10:09:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B619C6B05B4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 10:09:40 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 379571C4340
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:09:40 +0000 (UTC)
X-FDA: 85466718120.11.72DDA88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id ADE00120010
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:09:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j7nkVgaa;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795446578;
	b=Zr8uJhOT0sI9QvO3F4KYHJ/UNqDUm6IWOu9TpAca6NjGQ6FRiyJRtWv9FbyQc6jiw0neMM
	K8yEQGHFbPyarUDr5BWPIm/c2RKCXJrvBDgM3DM2dSXgzIZRAXreduPSOOXigDXNRg72Q/
	AmwvNLvk4zH5BVK2gTRNzIAu3wR59to=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795446578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=JJ8c/8W1EmEuE66i5nJ5h2SZQ9wJSL5O/EOD51UVqLE=;
	b=RxbVIlKSkPguahFJkU7bQLzb2qTpN7qJbhZhh/ZTkxYqjgCaGMwC3B8d/7UMTRL9N16ai+
	myZqpVdeaGpX8awhTSMagwoEKiPgMbt4PNGt+SHJ6JkDXr+u2Z6c8SIhBKxCeN2s6oeiSl
	OjPdShzpkDXnNWr5mN9Z8IjUmz0469M=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=j7nkVgaa;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2A6E96224D;
	Mon, 23 Nov 2026 15:09:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED331F000C4;
	Mon, 23 Nov 2026 15:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795446577;
	bh=JJ8c/8W1EmEuE66i5nJ5h2SZQ9wJSL5O/EOD51UVqLE=;
	h=From:To:Cc:Subject:Date;
	b=j7nkVgaactOMke8k3yZMiQUfqdT7YZtD1yDQNOU7+OoldrqyMeYZrmc+ezJbemsA/
	 R67BJu8UQ1hQ3CjM8qeLRfIBsP1Q7yCh2jTE8xsB+4hgaEljBgj5HCkX02nzlLaJ/R
	 SOcM46OCVzo9gw1YUUXLo9RfEBbA66+YgCqcHwn5GhFOQpi+o/W5jtKwn1Pil1vZjB
	 jMW6feld473fB+ZG8dSzpJ1UWyiSTy5mbFj3xEzTjjm2wyNIF7LZFBOTzs0ofiCu5D
	 1xd5vFwrgoE3ltrJtZY03t/LWv/zwyHJ0gwLoQwvglWBaWR1a9Lciz6xKAx+5te0qv
	 xFxwy7Sak/xgw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v3 0/3] mm/damon/tests: add KUnit coverage for age_ms filters
Date: Mon, 23 Nov 2026 07:09:24 -0800
Message-ID: <20261123150929.81797-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9cyafi3n9uetyyrjtbfrgtga5bt98831
X-Rspam-User:
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: ADE00120010
X-HE-Tag: 1795446578-537606
X-HE-Meta: U2FsdGVkX19JviKMkRMcMb4rz4EssZosNKMUX0N/HoKrUt4Os5lafuWXNBV4e3zJ+Q/PzlbveDYyeQ/9EpXx88vYfZFHpKX7XieqbgW/OUCqxOFCE8yNZx81JfUG1EfsIyxMPbJfgG9kZj+Y2q1WhVYqMGaRl/mCyBS6icr3X557xCAwZYqcY40Y1qFg5WQPkGIolGim82/VXxkL+5RdyoKIcrMXc9JMfBfvnrTeZi4tLMUx/dTMiGfnvfQbwR+OoQ9Eq3OJVLI/tSkSXw0wQ2EJQp/2euhWwN89lz6o3OKqO26ZOdfU74FZdpoHILpIZSXpg0/QQLY2horggf4fU19CB3wHK82BhoFqJibtZ+vjFP0eBhzBJ03wIuZ65mSaeMYHRERLsd8s/+S67HIBq0SmDtfbBgHA/kkOcNtNITPHfZe6I0gG7YnGFQ6alBcRmVUMJH3Zx++E0cosqR5XfvcaOP5w8x+mw6+4TSg5QqTjaDDY2nR+u4//nFemtV2GIIpnBXgBsBtbbx4hcjiTzUuBrgErTzOyNMC2dsVauy1hwiq+UMc5dd/cXow+/WkPujIblCPiObDmlveaZcnb+OhzMxLoMX0u26Ih9seV02t7ssD7XPbwj4h3Kxa48LmCB8A8b1ZnIFYSEJRu5i52cwNwmlSvM52u0f8UixWScNCGuzaxnMN25qlSuvH0T17U5zsE76Hlt53kzvnYZC6nZ+kDiD5dwVZyYqTzI9vpcNuDFrHGfKGREFEgRrbeTKmFLmcILVIcvQmat129++ZOU3dI8dynanSPyQ7kQfEkY/zMyfBipOQIcjQYDhbUoRj9cRUW8sILeNdmFqfsTUk/cx7pWcxv7HoPQuT8qNXOwh4q5pE2+kbrGBfpExeCxy3MJGw8GXDS7PUKpHvgqBgDOA+ofpkmiwI3JxwJWbwGjkdN1dNqQmALfVzQfIP1SrSdSOEPX5EtroedKuMD5x9
 TzH6xO+E
 mPAK/3ZduLX4owPc1ESNmo+VHU2dqeZ+TUbAdduMS+jEdtsRk+chShS8rJNWdcJwqXnEeJQQkP5VTEsj4sYpn8BDHNt2z+/n/hb7jFwM6EOy7U5dDX/xq7ReiVpqlDMWA0dU6om6BwgyPTD1plP7+aecech0/6WKid1SfqfnuzOrnzFMMsRD5C8cxdBKXXKEjv3L3xDD67kQ2Pwy4nh3SLBv7lYYGz3m7dSZMMDskGlbEXCvQsUyNu2FVPtO/Vioc9rb64Ba2F2HyhBxN91AUBJPSGFHDmT51bbzVk5bfYqgy8ANfrUVgdV9bY2YAdaMkvQEdqq8tWXX+9718Nj000ZK3QG1maXhGVE0E86WQyswzaMpeqRX5oKV+LLaghs7BqPHl3/GIjxubTqJi3y1Wjv6N00XxFvtMQVDAOQP2Wr5lyUnVWl/msMgjVg50nLFYXg/J+p6JdrX+RISRM4jPoIIlmkiw9TxbdYYLv2F5RfgO8oot9ICw9XtY39gMXu2Q+tBH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Jason Angelov <jasonangelov@ucla.edu>

The DAMON core tests do not cover DAMOS_FILTER_TYPE_AGE_MS. Add tests for
committing valid and invalid age ranges, identifying the filter as
core-handled, and matching ages at and outside the range boundaries.

Region age is counted in aggregation intervals, but age_ms filter bounds
are in milliseconds. The interval-change test checks filter matching
after both increasing and decreasing the aggregation interval.

Changes from v2
- v2: https://lore.kernel.org/20261116-test-age-ms-filter-v2-0-3b265d59ec98@ucla.edu
- Collect R-b: from Aveline and SJ.
Changes in v2:
- Fix commit-message formatting, line wrapping, and comments.
- Set age and interval inputs directly in patch 3.
- Add SJ's Reviewed-by tags to patches 1 and 2.
- Link to v1: https://lore.kernel.org/r/20261113-test-age-ms-filter-v1-0-b99eab2f71bb@ucla.edu

Jason Angelov (3):
  mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS in
    damos_test_commit_filter()
  mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS in
    damos_filter_for_ops()
  mm/damon/tests/core-kunit: test DAMOS_FILTER_TYPE_AGE_MS interval
    changes

 mm/damon/tests/core-kunit.h | 93 +++++++++++++++++++++++++++++++++++++
 1 file changed, 93 insertions(+)


base-commit: 5247761933577a245d262c55994032b86cbec2d1
-- 
2.47.3

