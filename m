Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BACA4C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:28:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E65F6B009E; Tue, 28 Jul 2026 01:28:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76E726B00A1; Tue, 28 Jul 2026 01:28:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65DC66B00A0; Tue, 28 Jul 2026 01:28:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3430A6B009E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:28:22 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AAA9F1A02A6
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:21 +0000 (UTC)
X-FDA: 85037054802.03.34B5114
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1F97B40008
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PEBuIKDu;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785216500;
	b=MiXQ31ld49BRfp/D8JVB7JlOfJycbXZ4f/e1WSBz/iAHS+YDjKtSKZkDSE+gj/3URD1tKh
	R0mS1DZsUwLXLmJP3DgQGKnxM0pOjTyLtVcQKBCAKqbF3QaKqtZncdhVjIz0Dz6jh/WLRi
	/EXmrRFQ63sDcICWzI/Qwj0AsDc52EE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PEBuIKDu;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785216500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jEqn658128UTd1o8tS5ZjT5LQQ6f3vfRE5EdtC108ZE=;
	b=IsfWJxC5FgNreS/0ma+qh4mNGrE4X38jK6zBBAtzyZeL/1GaRyfMxXEfWr5+GV+IkzLwiR
	5dIzlOG5dUCYXrxS0vE1020C1ISIpUZ3OwrymHKDFtLhMaA6dhE2RWUegWTRm9e3L0LNXJ
	LFlBLyVnH4jXoFjK16MM1ERT5MqBf7M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1F960431CF
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:28:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94F01F00A3F;
	Tue, 28 Jul 2026 05:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785216499;
	bh=jEqn658128UTd1o8tS5ZjT5LQQ6f3vfRE5EdtC108ZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PEBuIKDuUaxyDyAOkobLWRBLv0M+5rVmn4p4GBzEbZ880A1uoT/nq+XdHLdzNb6XE
	 rGETPi6MNPer0T2vnxeOoDwHcj2ClPIxicFIuUEFFTIm4aUM8oJouaedags/Kx5qdB
	 mJGElUcNt1KAmIRo7oqCcY3vcnZAc96XWPACg8SImKRe8VYwEgrZeeEp4tFMAzDxGf
	 0/xlrAoATCmwE4r/fkGLLj0nNCg5xWlK3EkRWWcGjeqIYMyEZE0eU3xSla6Vo7Git7
	 BkTmIHaav3ya1TDYZhI6UAqwNxv5Nb99yddOPB0U1AmDerg/D/JpUZ58AQS6clFImL
	 hlRh1BQDQMdTg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 08/10] selftests/damon/sysfs.sh: test hugepage_mem_bp quota goal
Date: Mon, 27 Jul 2026 22:28:07 -0700
Message-ID: <20260728052811.192712-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260728052811.192712-1-sj@kernel.org>
References: <20260728052811.192712-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: mosdtiruc9czfdi4wofj7amiaxk59aoj
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1F97B40008
X-Rspam-User: 
X-HE-Tag: 1785216500-454030
X-HE-Meta: U2FsdGVkX18lau35J9juegvEntSMk4Rr8krCVQobSEK22yvB+ZaWRqZDbfehQImFNXtLaALYRyR0iNFJV/3vWr0lHU8vO/jNdTFc6KVMAR8xJVqPLrT65Sewt+HEQR5//PnBFex4UarPBJNrX+m3vef8W+puY3ms2rr1RVXBbxdsTg2g2c/1fjqpFuix9plEnt+9es3Hlr/ayerV/5KbLk29wJjuUpRzca6jN8f9bJJBauGbA9Gaa+8UhJNC8UUstXrjMqWxrMFkIh0jWcuG8Ct/tr0An9eIO8N6J66LxQihnSUnD2HtKF5Zo0MAxFe7xTOHDfDlh03I1T9vNG6rzfv4OiAO5SCqzD6Xz61JQT8pRANNUqIFMwwNNDrknnxDKYnm9FHmhT2TSoECMPTZTLxtbqPTJ082UP/kxnRfWhbvyQk094nmGqAj4kiSBjXV7LY6Vygmr3BgDkG117V4dAEi03puNzqe5mfhQYbFGf48mcBpuLp67nGtVQgrTxRxyOkjwGIHpHsAGIkmbf9wqBe/g+l0o2DEF3RWpXE2GbXBxG4sOb4oMT8npg4oJ02nZdXKanG/x0cKIZbD478uUBIo3MbOVvvVPsNQBRG8nAtHYW8KyvG/wSFprhNV7Uy9Cool4JN0NLp7fjBD2AVLUsZhgAUDOKhrVjk1t1YrpmPOtTSV/TpbM3ZLWfn/fC4DfnxdmLnRlulpx9gLjQ7feCIHg72/FL80DIKmKsI60owfcQy4iimXoPND1/Zkz8GFki7iLxXjXljjQAhtVMXYAtDVACKOZM1Qj4mUijevls66whUHxp8FzQhPU4A1xcKgoWpX+VbMqJZpyflJUiwOUPdccWOG63FWEwvJk3RzfGN3T5k/UoVkAoipkho/p53qdLOYg9gS75rFCjvGZJH4hEjXVCpTQHobfwPy8mVVCjqIG4VBENgFkieoB67NN67F59YruxC+9QjRg8ORWUu
 N3J3NqQb
 mwKzhtmzdNRLvbC9QVfaT+OIgQzCHuo2Wja/8NVOAIO3GfN/5g5K/pDo/ej401qtT4KwsdWmab6VeIM6Bd296fzKQuktd3pEHYXb57MyOYd4wqsYZ5XKf4o8Kldt6iz7L7gH0ivuvP1YL15eYG2ltTU7zPTvp7hlginVxAu/xAcKYoZTto411pga4xD3WPmwUJJ2Qlv2RbXuGrmLaI3+b3DMiZvdyKiVPtP00N7CJ9efRIPj/+nKdSPxbje3v40ZZW+4ivrPh5PgdXhlmg+0SJ3atj0v3JFQM/2XakzUao5Lr10hx/Rm56p/g5l7rr194Jw2QhNc7OmkfHbBA5lZWiiP/LJ1SI8HEUR68
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs quota goal target_metric file now accepts 'hugepage_mem_bp'
input.  Test it is accepted in fundamental DAMON sysfs file operation
selftest.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index ddebde6edabe4..b66593c9ac471 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -210,6 +210,7 @@ test_goal()
 	ensure_write_succ "$fpath" "active_mem_bp" "valid input"
 	ensure_write_succ "$fpath" "inactive_mem_bp" "valid input"
 	ensure_write_succ "$fpath" "node_eligible_mem_bp" "valid input"
+	ensure_write_succ "$fpath" "hugepage_mem_bp" "valid input"
 	ensure_write_fail "$fpath" "foo" "invalid input"
 	ensure_file "$goal_dir/nid" "exist" "600"
 	ensure_file "$goal_dir/path" "exist" "600"
-- 
2.47.3

