Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5AFD606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 20:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZPb2m8Gh
Received: by kanga.kvack.org (Postfix)
	id 1A88D6B05B6; Sat, 31 Oct 2026 16:26:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 159896B05B8; Sat, 31 Oct 2026 16:26:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 094196B05B6; Sat, 31 Oct 2026 16:26:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C46F76B05B6
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:26:26 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4DE61A08C0
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:26:26 +0000 (UTC)
X-FDA: 85384053972.16.C00A2C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id AE28C20006
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:26:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZPb2m8Gh;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793478384;
	b=rbmSk+POb1P3wCGoC1nlEWZi46SmHiBkpO1iwaMu/h7mCurOlhwh+ko2dYph4PLR0PG5OS
	2y2h9i2SfNkLnBzgFrpH4vKArZcWEP8E4CsELr7ttETkJq9XmF2mHMFu8UpUCsv/tUdZ35
	/o0xmr7TAT3QoGqWESufHRiCEGE0a18=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZPb2m8Gh;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793478384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nl/jwuQeYoLkJzo/bhBa5SyX/AJXXbPvtIr1rgEJpfc=;
	b=5l1/WT3j+K6CX8aFJrcNqPEgtZYbYWX4IyHivKaMUh24zk+ehvrmCdNjn3k9fqZKuVhGcl
	t7wU9G9NwgA1Os0LLgAN62niQxttikABjfglwYZ0v3+6DWW6Gbz7+L93uNlRzthMtPMf+C
	6S0khVUw2FYpgr90M4jpVWWwog9ZRlI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0947841932
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:26:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B23F61F00A02;
	Sat, 31 Oct 2026 20:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793478383;
	bh=Nl/jwuQeYoLkJzo/bhBa5SyX/AJXXbPvtIr1rgEJpfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPb2m8Gh6rnTXbroSHauDyU9CHuyH220YgRt0Dn1rHI18EQmlKWyqR0eP++CYByBY
	 NUrVbs56SKOyVIzXG83r6fBDDB8fGds1TfvEP2XUBz5wCIXZwvFcZ/e7KQPDndwHIy
	 zDl9aSiQk+1UxMSsfqqbTs0BT2iwS1XrwlwLbgN6z40ko8pupuuSXar08cWzyZk0bB
	 YTHDuN+EOWzLXEKXn+XsLEAoTNAltNLzVpv+Xqn6Z5/4mlpIX5erm3xA9LQbAx7zqO
	 U89XSlkZKRS9IVYE9l0mcAHlhnyoHMIZ5MwJUlumHh4dJny1q0ZfDD94li2W0lp7a2
	 p+eIP/3YiWgDQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 5/6] selftests/damon/damos_apply_interval: remove unused variables
Date: Sat, 31 Oct 2026 13:26:12 -0700
Message-ID: <20261031202614.96036-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261031202614.96036-1-sj@kernel.org>
References: <20261031202614.96036-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gsfmpzqzj9sr1xxq68udjy98nwe4tkes
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AE28C20006
X-Rspam-User: 
X-HE-Tag: 1793478384-934180
X-HE-Meta: U2FsdGVkX18DBBBBDoNY58foqW1nVnghuac5Y1o3xtDvn1SOE/iEuPuVX7dDwC5L0umeHM+lgrHFxpVLZUgAaG5ptxcv6+2LOrmdcdtlGDm6ZeX6dLc8h1K5erF1oh4Ht0k5oJgFdXUoxRlN43eT/fItkZxiiQPP1ljXFlebRTlOep/8Ch6CV0t7SZtDTrecaYTOIhJ6tGVc4lTlUWQ1EDGx6sJFyganWCNyScckZmXH6Qtm19SJL7hq36UA9DiVoqKwBTVrO4kdkr6HM8m5pTnalkF45vINiHq5HFbbvPo+eImV8+O1/HN/zhrFox42opbkFkXdd0RatDxk4SIs7vgRqrGLtitwYkcmBj2W6Zcywomb+f4pYUxUbGJQaER4yjYvnnUdi+4wHT3iOneXe/AYSN5NwY8sjns4CNCfkzk3C/BNRyKnUewfvFLaQaTrg2azMQ11pAGHyxh3DK631YtVHgCf7PrX5MJ6p1cegnBNjeoZ5FbpARtj9871hgi+oinb9iq7j8jNXzkerYuCh/C4cMMgfJaWULJBA91cCRiNTDNyvdR3Mwu4PD7Gh13W3indpC3Mwtr5iF9yGvP4jRioHoAmgimQJ4G5mPtLnetIyzpBERprVAbSSYf7/NqzLWCArtsYYMl19FUL7Z/bnyBKAljIFrrl1uYlfosWYznwhu1EoYHv2gdBLcicdOW8PLGEJZujm+C8cLyhhRkfl2WXsMY3ViyY1SGTjqE1NPJvtrXRdjmdsebuUTUBah7bZQioen0GQD4zKSV6udebE098B44QkXYA8CqqLie2h/PkjL0BgAZoSixCQD+tKbUKVLI1XKb54mUSiy07Pd4l2I706uiAxKtTaexDKzlcHP81AI/HgqIkkkGJAVsy7kStBlR1pharD0481SbavCRCncPl1uyt1Yd1C0sEXPv+tscHZgYoQ0vqZ+jbWNcX+V3TD5lqjbpuMychhm9pfTx
 89y7nNHk
 keflhXDFM34WKeQn/knqeCmg6k6rGbhilxiAvOQwDpNAGSTphf+rmvXwYl5GMd+CCkdphKwyPJNtNcxqxqtf8UTQvSKf77261HJfjgtNKILccOM1JDBpm183HsQr9cz5AA2r+9QvTuaHW3UpMeoOH74F0tCCHCpX37p1wNirwoSiKvBogqLFO7bDNfVzLw2C8n0XIFFUA1A3p6lvu0K3H1DigK3ldaOPTikLf5EQBnvE8wKu6IAQ+NE+drynZmc87YRMJOty7wpmrvl9aATjO6pGPdY9l4rrImw5ORx1vhu4YFoz0xeBe5WazJXgEVXFOejNLzu/mkBXfXCpLbZh4knGteyWMwkmraBSZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

wss_collected and nr_quota_exceeds in damos_apply_interval.py are
assigned to but never used.  Remove.

The issue is found using flake8.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/damos_apply_interval.py | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/testing/selftests/damon/damos_apply_interval.py b/tools/testing/selftests/damon/damos_apply_interval.py
index 0bf7768b2006a..0ad110be0fb94 100755
--- a/tools/testing/selftests/damon/damos_apply_interval.py
+++ b/tools/testing/selftests/damon/damos_apply_interval.py
@@ -42,8 +42,6 @@ def main():
         print('kdamond start failed: %s' % err)
         exit(1)
 
-    wss_collected = []
-    nr_quota_exceeds = 0
     while proc.poll() == None:
         time.sleep(0.1)
         err = kdamonds.kdamonds[0].update_schemes_stats()
-- 
2.47.3

