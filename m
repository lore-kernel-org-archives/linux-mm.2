Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D94CCFA02
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:20:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED54B8E0008; Sat,  1 Nov 2025 14:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E37B38E0006; Sat,  1 Nov 2025 14:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADBEC8E0008; Sat,  1 Nov 2025 14:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8B5628E0009
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:20:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3D3A016045A
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:40 +0000 (UTC)
X-FDA: 84062853840.30.CDC5381
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9EC0710000C
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:20:38 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KSxZleUw;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7TzUAwDEYtZ5+rwi+gbFvOaA1RsxlwROhD58p5bYGhY=;
	b=svniRjYhDeKFWVUoUydyzDc0QzVZ7kSuIJAhpst6hafqSV/b+wJ3fHFlMKtFUNbt8AAbnf
	SbW0Sj0N1lR8IFAPiaVQMuDU1/4EmnnSd1Q9RqdUDfpkwN3eRJwEWpM9YLtDZcqZCdtOfO
	O4EAOhRJjWaMPqJol/8ZRJavQIqWRQ4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KSxZleUw;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021238; a=rsa-sha256;
	cv=none;
	b=JdMpTq/+KfAxWXs19ih9WbT+ZECN5FCjMYPWl94XhtpyBLn2/E1cFSTRghSStwjkSl4W8v
	pLbo6hHQRUE2rDx/Gu8/i/BbXR86cBtEY1FD88Fg20pqD6Etazl6XL+IHi+7vyHPB+qm39
	B/eefY6xxjz3u3QIP0HK5wYyVq3E84g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BEEB643F05;
	Sat,  1 Nov 2025 18:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79FF5C116C6;
	Sat,  1 Nov 2025 18:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021237;
	bh=PgfRRLXORijPzf0z5HMHsfa0ZrC+1SalbiD9xfUzyPs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KSxZleUwuqRprD4u24yaPwktHSggSvqqzUDoN8rJzDncwxTjEUJJuHvfliQ0s5DUn
	 wBL2ZsLPWwes1sdWPSULDRT5AydRjEX3Ra23Ba2PpfmDFCVpMsDumVlLUdwKbErfTd
	 lOLmWlM8/r9G36rhQeZqVp/wxkidFOr1LwTGxpkva3din3cYQCdbLuzNk33xsSns0l
	 eEtpBxagoyNL8HrkMF/qEW4nq6IAOQN2NUWNG+FeFU1vmq7m/Aya1yYhOfzAgshoIQ
	 xS0Ti5eDXbNn4h3MNHH37FtGXMUe16EH/wrUikcDqLQMSWGZiX7s/Ei1ES2zAKvNB1
	 jqveyzZCTd1gg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 5 . 15 . x" <stable@vger.kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 05/22] mm/damon/tests/core-kunit: handle alloc failures on damon_test_split_at()
Date: Sat,  1 Nov 2025 11:19:59 -0700
Message-ID: <20251101182021.74868-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9EC0710000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: f5ken67k8jnse9cpj4emusr316p4we3z
X-HE-Tag: 1762021238-42872
X-HE-Meta: U2FsdGVkX18ccZ85iTbyZhwIAGSNiRUot5jfOkRjkxCy+iOb6xziaIKKZuieysfaPKtf44YuJb5deA0ebHeuzQcc/VxVYvf6SxUnmKN/VEHwLS7/kyCy5Fwyh/tlmRiWUl0+TS5HRTqrah6w44K6UXxmmBVzUDd/OuOL8ghQWgts6OuQrNYLNz+4BGwiVt7kIywohAifMLaC7lsWLsIe/4hfEPhiCd5B1muLx40H7lnkeEn0zich/95WGJqQIFoCyFcACw6oC37zyXwOVnCTD8dhVHSkWJwms4xpKWN+DN7PALaDZqj7QL62sjOS4vboRwwe2z5Q/KsRYMkWzAYOIwMl1NAlkH+w7VYX0q1n4a3MtKxYyA7A+80+UUSAtCAtfWOjHK7vOeazpVXe807yXzOTa+7aCPlqR1hOWVYftKep0kxO2Vj7akLPEHzv52vMGcO1Iq+DwJZjoVoyhI72V3M0/kgr8oPQ9CKVohC/ztTqTr7NQloo3l2fklVZmDXpxkrHjE0NHBpOxDAPMUKLwmot65PK/mS0RryTMmicaI1UdGTmvbwV2NRN9gRE2MsIDTemZqrBIuJXaJV+eGy3tCFvytkzJQcjJA7zYv/W2rw5W7K9SOKYb5DM7pHXZXAJ3/B/QQ2vrdnqnJR4wOhwHYlm2SI4GJRJCRzYeHlThtM8nV6fSnsXE60D0eySTDpN09ow4iV21Tp6kliuNUbevrH9yALvj6LP8+KOl54SPejLYP2LadtzALMzIUG/yKuDMiRbf5kfyWVzmJKjfByShx4vNIhflBZI+VVWgs8qsJf2kjMsIytGWHniLdBPs5w2XNO775LKRVE847xo5AfXga9OY4J9GB7BPldulduwhUVL+yQ9HdUeX7zEt64+Epf2jp3aWbJL98mhF9/1cGMyAsQ2V0xsP5KzRU3W6yt384TQkdtYdUqpSsZ1Gi/2mxh0VexMdlRx/bEdEcYzzew
 jVjZrVtJ
 RIGD1otHovqJnOKtWOsSd88HdeijVAtbSaoRScr1GYc1mniIBJRki0nkqVtbptb7oyMKPFHPTF26nTBvF+GWB3f5L3SmyOl0seJvrwemyiIHX6CnLuZS2BacI2BOQjBnEBeI1/0DiOB/hh+WxK9fwQNLS0VV1qJ4UvsaEJLnpnFZDU750JXnxCFwfXsWN7YSwaOZXqWsmq6SjUOmiCsx1DCuhGOvWnmeV+eAd5WZhaj++pFb3uWl+lOMy0ZYgEysu+mhIaA3Z7QGu4XMhA76QuWAgjg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_split_at() is assuming all dynamic memory allocation in it
will succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.
In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index fd1e1ecaa2c9..f5f3152cb8df 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -148,8 +148,19 @@ static void damon_test_split_at(struct kunit *test)
 	struct damon_target *t;
 	struct damon_region *r, *r_new;
 
+	if (!c)
+		kunit_skip(test, "ctx alloc fail");
 	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(c);
+		kunit_skip(test, "target alloc fail");
+	}
 	r = damon_new_region(0, 100);
+	if (!r) {
+		damon_destroy_ctx(c);
+		damon_free_target(t);
+		kunit_skip(test, "region alloc fail");
+	}
 	r->nr_accesses_bp = 420000;
 	r->nr_accesses = 42;
 	r->last_nr_accesses = 15;
-- 
2.47.3

