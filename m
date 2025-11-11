Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34BD1CCFA1A
	for <linux-mm@archiver.kernel.org>; Tue, 11 Nov 2025 18:44:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B97CD8E000F; Tue, 11 Nov 2025 13:44:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71018E0002; Tue, 11 Nov 2025 13:44:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A88318E0011; Tue, 11 Nov 2025 13:44:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9096B8E0002
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 13:44:30 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 587FD1A016D
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:30 +0000 (UTC)
X-FDA: 84099201900.24.0ADD4B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id B1ADE80008
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 18:44:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LhvmRijH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762886668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yPFTYO48l3MIvye8Ft5tuy4SodrlvTUGmwKdW9CQUUY=;
	b=igekcfS/AMunTtavowAIGuQ69Yzjrj4em+OY2m2X7bF0rCfCjhBm7VfUIt7EdgVVIrmi/U
	PkRBbaDZbM4bQw2V3HaDsy6dc58vg3P07zBfqx9hjx9oXr9JTt/iW8sTAgcWpPBcV/04rM
	Gja3MA7c9loA3dMov4tf/i6FYyyT6o0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762886668; a=rsa-sha256;
	cv=none;
	b=xkK5y2xVnl9DEqujQIx0ELaqbnPIVkrrtNUqH2NHue0T4d6kMZW+Fu1lvpuHJ6zmVpohcL
	M8tsOIeOOQQzeBrZwuYWqGAOi1pLoMYBgUFh354lIMhOCNS72mUpyd/py8lU8y0XD4OQBN
	nPyTh6aHp3Q+iQOPqwxbKTQIwaaWYNA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LhvmRijH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D0E1844443;
	Tue, 11 Nov 2025 18:44:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9117BC16AAE;
	Tue, 11 Nov 2025 18:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762886667;
	bh=RN1NkgEO23eqGRbIw3CgEAS8tb3Fp9u4BZ1voGEOa3Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhvmRijHVE7DhBMAgCDPQkJjPgAzyuoQn2gcyl020+DeeyaUT45dX9uTplTJh829R
	 Eh2tWyLnhoJaPHGZW4jpzrnYMiSrW8Wb/3UYOKQqFx6XEvXjdjS9ezViSBJzv7gZe6
	 5VJmHzP/sygGB7NSf7d87vgYAqJxWnDcev22qw7PuRrjQwRjlrItbtiPYDUJhPiIm6
	 RhTIDJ0GhH3kzG4xLHbPUA9mfQ2yeTKpJzRfbovH1QQvXO+o0lFICsPslWI6Lihtil
	 PO2QhrT9a44GqGjV2F6cf+s6oyzNuE/jKET5mHxOadx39+E1R1wsYV3yUWrlc1IlM1
	 /tovELo2fUjzg==
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
Subject: [PATCH 03/11] mm/damon/tests/core-kunit: extend damos_test_commit_filter_for() for union fields
Date: Tue, 11 Nov 2025 10:44:02 -0800
Message-ID: <20251111184415.141757-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251111184415.141757-1-sj@kernel.org>
References: <20251111184415.141757-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jebfjaaab64ycg68rbb1uarwu8aes6p3
X-Rspam-User: 
X-Rspamd-Queue-Id: B1ADE80008
X-Rspamd-Server: rspam10
X-HE-Tag: 1762886668-311328
X-HE-Meta: U2FsdGVkX1+Ff+nCP5ANuobkGCjqatx8vsoWlecBEZX6cWSoCA61mi8UOhmNYaCqdYYpOe/VR49Tu0y2Q6V03kDvSh3z9YkN0TGVkTpybXKiqPwSXYaxba/3lCDABZpOwe0ei2R5E8wrP/LplAAmu+N0mvKhhEWTbmBK8xhnzpXux/FSVRkGw6m3lclr6A6UQr95nLI5syJO/qxfyhv4uMm7+kFJpRJrMPusPUgiqSUWg9YJieOL/iuW9TBzHxgxF5jksvr1VtWmJIXYXyL/4VygVmTopkphg9jzEseKC+UcZxMxpXo4ry8GJEvMT5bWRubypwPa2RqIQHyPbglEpMLzbvGF3gvKnlxJaSjOYLjRKzUUxqrCNYSj0jip2SQSyBSXZZfOuTmJIEm0I8027mJI2yfftUyKDefoVOSgeF9j858eZ1zYx9OAx1TlmqBa4rJJPXjQ7uLLo7PUxmONpzneO1pgKZte6WsPqfpunCUf5gwuhxzEINYYjouDorOo9D6frVNRQvHMuwsj8LYSFzx1XEHj7Zecy05Ac2hOeRQ/0gXvRX7DXo/jQ5CXOoCZQ9r1cUYynyGC4/GTp3rr2hi93tQwIOaqzuXUhEIQGdkWELCWsi30Ye2FIUH8J1Gm4skAeJCFiPSzE5yBEOVOrcM0dqzPqPKkjjOvpq5Sd7A5IPT+OzwPEigWDF7POqBnIy0PfI2Y9Bx2NaCh0fXos0kd4N5Bwx0ICotJenywlmcTGaOFSozHeOxdD0S+2ciRaaIA3zZ33nI2vlZ3oJB561c/jgPZW4FMgM466J548OYABvCL1axuhiPoEMlcXvHOzc0aMIFtz9kzuCW202oLJ3QQhBQT4Fp9WzXHW6FtfDNYbCo21et6QLwTs6kIWiRG52Kkz45Xi78m7Lss2WmIKlph4pXGS+na6wLPf76ds4lFloNw35G9Ja5Y/CZK+MN/x6Aq4Vq9VdjEiSUu4Ck
 Vq+tKMJA
 YyraVoX3Gei/gG1I89ai0v3W4xHfQfn9nm7l3lNav1JopDtG/NnkS6iKJG1UuFBHKFnSYsPmuBWuU3zS0OoMB/h0ZpdfwkH2CY7h3VwmsCbJw9PCeUY0wKA7AsQIoMO9wvxUmjeuQWR0iyfshfx949H11uNV+mhhIkFgFSTrTF0jB5mDpOAbuylSWbvSIVNKzOF7CcXfxTw6QklWK7j/BNaKPSO1gc/UbZLULPv0CVx2axZRTOOrGA0G2vLBCEsW5XeE5G6/yJPk1U0EhYkRZf+ji5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_commit_filter() also updates union fields of 'struct
damos_filter'.  Extend damos_test_commit_filter_for() to cover the
expectations of the union fields.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 31f90cfcabf3..5052d8db9657 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -504,6 +504,26 @@ static void damos_test_commit_filter_for(struct kunit *test,
 	KUNIT_EXPECT_EQ(test, dst->type, src->type);
 	KUNIT_EXPECT_EQ(test, dst->matching, src->matching);
 	KUNIT_EXPECT_EQ(test, dst->allow, src->allow);
+	switch (src->type) {
+	case DAMOS_FILTER_TYPE_MEMCG:
+		KUNIT_EXPECT_EQ(test, dst->memcg_id, src->memcg_id);
+		break;
+	case DAMOS_FILTER_TYPE_ADDR:
+		KUNIT_EXPECT_EQ(test, dst->addr_range.start,
+				src->addr_range.start);
+		KUNIT_EXPECT_EQ(test, dst->addr_range.end,
+				src->addr_range.end);
+		break;
+	case DAMOS_FILTER_TYPE_TARGET:
+		KUNIT_EXPECT_EQ(test, dst->target_idx, src->target_idx);
+		break;
+	case DAMOS_FILTER_TYPE_HUGEPAGE_SIZE:
+		KUNIT_EXPECT_EQ(test, dst->sz_range.min, src->sz_range.min);
+		KUNIT_EXPECT_EQ(test, dst->sz_range.max, src->sz_range.max);
+		break;
+	default:
+		break;
+	}
 }
 
 static void damos_test_commit_filter(struct kunit *test)
-- 
2.47.3

