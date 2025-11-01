Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E85E4CCFA00
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 18:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A70D8E0018; Sat,  1 Nov 2025 14:27:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 456B78E0015; Sat,  1 Nov 2025 14:27:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3453B8E0018; Sat,  1 Nov 2025 14:27:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 200CE8E0015
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 14:27:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BEFA94A8EE
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:27:03 +0000 (UTC)
X-FDA: 84062869926.06.0870A15
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2BEE0140002
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 18:27:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FjPZlaB2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762021622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fPueBcNJa/qI0DXLfBmr5vxibSFjAo0eKSnnuNl27yw=;
	b=0hV5bsv1pLDdjCjEK8Uk24FnckN/yZySI5nrKluDqxleQrWQXtwx4VQOSQ6hcdx4Tul+LG
	sgmK8DlRr9aFO9eqUsyjWIIcmfqRT+xDncUOaOb+ULNK+GQPhF4dSltV5AhD/2v0Gwp20m
	/99ylii+UZGeIer49eeOth1gwC4SM88=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FjPZlaB2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762021622; a=rsa-sha256;
	cv=none;
	b=yULaX6dPhS46XUwxIoW0IrhPz117Klp/7ir7qMtVrTPmBkcovrG3yw6YJj9N+qPL7zvJUk
	vMvuN7ek7BMklfGJwyZZ95enhCRQWP4/U86dd1K4d7ZNrzlM7rBzBb9CN2TvhpHxjU+Cgm
	912bz8y7dnBHJCgTcb6jPkiq3sfe0NM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 18677440FF;
	Sat,  1 Nov 2025 18:20:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C52F1C116B1;
	Sat,  1 Nov 2025 18:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762021238;
	bh=mFKvW58Z/A1OQcFHyE0QlO67VUd7WnWfCLTNsVL0kBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FjPZlaB2TObb4T2dW5PMEVnsKEXDA50bpKODTpc5GgHl21/G21jLbAlvsxq1boR+W
	 CulmNGBY0zT4Qdo93ckIV9xSsmlHG83/iM830OiMVCpjKGhBzKnvOkDGgUe+WA2Saz
	 tVK18LGeQljsGtziSPkVv3pdUfs+XN9b4cCzYKEEsMLMUu6/rBnkY6Z8esXKw7TUEw
	 oSNQgKIZ118ViGn/X/6d9PNyfXjcc6WSfgC5K4ww2ldfPdu9lwzLTQxl2M+XeZQEYY
	 3m4lkLAbyu5oEe8PmIxKJOHVqVjHAzYc1Dab5HJDXXDZGybbkCIoLvSw4MuIGEctzC
	 6QVQNiET8g+Vw==
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
Subject: [PATCH 06/22] mm/damon/tests/core-kunit: handle alloc failures on damon_test_merge_two()
Date: Sat,  1 Nov 2025 11:20:00 -0700
Message-ID: <20251101182021.74868-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251101182021.74868-1-sj@kernel.org>
References: <20251101182021.74868-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2BEE0140002
X-Rspamd-Server: rspam03
X-Stat-Signature: jy3n7ns819garzboo7p7jnukmdccwt4x
X-HE-Tag: 1762021621-757737
X-HE-Meta: U2FsdGVkX1+9xWdgVpO/TEBBSRGQ/WQdfWZWTc5vjtPJ9aiDH+SbubRwqaUGvRT3mnCu/285z4T1vaS6gbELYFa6TKhQ3aA7jf7qQ0GomgPbcIndhqgH5oR4P5L5RYtAC65mOjJUgj5zvzNmi4pAQU8Ix2Sm6Gy7ZL32N0BlcbshGd1gjuppVULhTBJSo7cuAaWUNBb9ssJmiyeAaJc11esCvCyGGFHbtBQkRCfEy+nhw9CigSDkxIM4tc3GNAiBI3fbKnhilxyOtwH0BncJkWl9In4aF7+VERtDd6mAAMcTkw0cKNGa1luB5QAaHIoXrFV3NLma5Sa7sQZcR//3sYA8ciMBjZiwC9104Lt3TGTxChbI+888ti+M+ILVaoMomVK1wK0EnPKD/KujhgdNJ4tBrYLkixY2pg1nMHKZ53q50nmmwMD8y6121bwL3becnqeP0iYDoxIZqCKx+A2YT7/bmBSKYLSx59xHNJo7DQTVwibkoVtNolEtHL0LiRV8kDs6IaTZmlFFRHVpGKCqv3UMhFPfgbjbRt84xlQLH7cVsEGpskMs1wf+9ToJlwuNRgcmMUtdzsXzpJBF6u9BDWbGrMix+wsZVKu8bEXDXa2691yZ5GplsgPV1jZ5BkJHNg2BzYBCgvJmG6ANPWEfBkCiNcHJBfd9bNoN/QfYw8kVagZkkdKrKICzBLDOiurG24Kd4sEKucVS5rZ3zJ90P6u+TLuyDCC/NxroyKqsz883FnqIIrWlEo7qbJTBCl/A62rJw5l3vDvbKHF3sZaWT3TtV9yyzYfMJQfxvYy427OE8rcxPe9lQkAzicYY2Bf5mMG4LgsjMbEhqnkbJ+U/EHdguNMGhL+0zlfVa9fJjf7HuhdLj0zDw6OL+ZafmIo1HeMBZZz39Is7lfu+o/CG1sg+wEHnLVpD82bs+Tk0rV91nEaTCDrMAFYN46cpP5xu8YSfet9m+GNq2azfjRz
 GMUU5peW
 8IfMfkCIqkuQ/ojALq6rHQeVV6357B8yamMQmP0+MRSsna48/Q5MDipbtrYhuL5kD9faUBfLcr7SxXZjnkfHVhzbh87opaFs91ZU/niy3yHHULJJABddE5Oj96jqbUkheFipBj5FeSvcebHBP2IaVl5OGBaBQChB9+bLlMsSIvavr7FYXz9VVHLTGb7CD6nZ1S929tkDr4M/InG07sEFie+yl04pCjw08rhsjDWSHshQM5pVGQsIxV0EcBTmwfX+tlAak0gplHQUKGGredSj/q9Ji9g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_merge_two() is assuming all dynamic memory allocation in it
will succeed.  Those are indeed likely in the real use cases since those
allocations are too small to fail, but theoretically those could fail.
In the case, inappropriate memory access can happen.  Fix it by
appropriately cleanup pre-allocated memory and skip the execution of the
remaining tests in the failure cases.

Fixes: 17ccae8bb5c9 ("mm/damon: add kunit tests")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index f5f3152cb8df..e8219fd23318 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -188,11 +188,21 @@ static void damon_test_merge_two(struct kunit *test)
 	int i;
 
 	t = damon_new_target();
+	if (!t)
+		kunit_skip(test, "target alloc fail");
 	r = damon_new_region(0, 100);
+	if (!r) {
+		damon_free_target(t);
+		kunit_skip(test, "region alloc fail");
+	}
 	r->nr_accesses = 10;
 	r->nr_accesses_bp = 100000;
 	damon_add_region(r, t);
 	r2 = damon_new_region(100, 300);
+	if (!r2) {
+		damon_free_target(t);
+		kunit_skip(test, "second region alloc fail");
+	}
 	r2->nr_accesses = 20;
 	r2->nr_accesses_bp = 200000;
 	damon_add_region(r2, t);
-- 
2.47.3

