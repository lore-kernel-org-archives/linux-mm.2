Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DD76CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 05:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 041836B009D; Thu, 25 Jun 2026 01:08:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 018566B009B; Thu, 25 Jun 2026 01:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6FF86B009D; Thu, 25 Jun 2026 01:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B2DD36B0099
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:08:17 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2FA98C2473
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:17 +0000 (UTC)
X-FDA: 84917253834.13.7AA6CCA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9B82B20007
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nVhawKbp;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782364095;
	b=piXk4ZY9cQQCi0CiMVS7MKpWUmJlrEZaW6giYZHrmClwsVtD/fZw3S2NejUeB38inLyNJ7
	zv+dKaACtXe0tqBTG9KaaOs614XQwclxSmY5ECglnImhE2lRSqhZBssZPXw/HFL24J432v
	dbI8/47aNYz15XRhTXCg9PWfsY7oO3I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782364095;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=61iW0clYSHE8gzHIMRcuF9jxdl/Em5VRtXAIIrwedXw=;
	b=u1TrgQrQON4VkRsE1WSsQHkceUS/DSLn/UY5YF/BBU1oiXaooaloAeh4mJ4UMTlRdCtNkx
	3y6gY4j7c4O9mPKCxEjb8doessrVFSjJGA/sbNm6fAwOplzQfcX5uccYNP8tMhJp3Pl5t3
	v7tVooHcwPGWHUTPSC6IIdtAGOtQpe0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nVhawKbp;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E0E0441A54
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 05:08:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF30E1F00A3D;
	Thu, 25 Jun 2026 05:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782364094;
	bh=61iW0clYSHE8gzHIMRcuF9jxdl/Em5VRtXAIIrwedXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nVhawKbpCGZoP530+IaNcaMO6FdWyaE17WQTJdXc41vAEw94WUo4G0hZxy9h2p+fI
	 k4YZjLzvWzNEPpmK0rN1MaY5m5y1d+PG8ZnEZp419ZUfuHuTqI67vwsMV4Nta18dKY
	 pzeNEqp/ZOCf/1gNeKZfyq68Feg2rn2p84Qtk6JYgsNubfWJ8ucrkLyCY52vxAdkLs
	 kjA65+/QL12t8twWO8cvZLg4nOS6rOEBDv3nB6+SIKOObLYAppwk3k76yIfkcnNaM5
	 5ExUVyOu2qAX+NR62dh5QOJkKpO5oPlelGBy/tnYvbQMKwvuZT5I+YJHOw2PGLdv3r
	 lnQP3m104NcTg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 04/11] selftests/damon/sysfs.sh: test multiple probe dirs creation
Date: Wed, 24 Jun 2026 22:07:47 -0700
Message-ID: <20260625050756.91115-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625050756.91115-1-sj@kernel.org>
References: <20260625050756.91115-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: f1tz3bw6ofxt1jone8cswe3nhu5o8w6x
X-Rspamd-Queue-Id: 9B82B20007
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782364095-117850
X-HE-Meta: U2FsdGVkX1+UU7weadmH4sf0XptlU77OXRFXDsV2aGxfK2Ae2h8xpd9r6Px5YHoNLm7WhDNqU9A9r4+nOGy3w5n7eE10W8YjiI5jc08ukwVyNFqbcZlF5H+smf3Z112kpitOLU6N6VRqE55m9imRV4Fj0ZdOPLEvrgrvBoH0VSzGIyrp2z3dTVycPAUGRr31LDH9sEbfhil8LIfmBfJnRVZdOuHmWNUT3cv2IG4Tmfc4kdCkjTOinSeXnivHFqThzMhQncQplj986Y1+vMtVcaNksvWBcpvxGrsWzDvmO1Ek3ydCoZkrYWJGCbyMwRNJxdCrjvLN0R3wT/5PflEZvwyzZqUtkll6jpwx1GGot0PWjGbI0thp+znyJlW0sykvTomMet8g4AFv9nwoj8hCJ/OLFOpD6RR7OyFpt54ERCT+Hkexc0+/rXw8XTEsoFppxRW7ZStRt1TW71nUaUkFeeJkrU9fePORbKynCKkJXgwgWsuJDbEkR6A/nJIZ4719splw25q44jXp2Vps9B3ZrDx8NTkP9Khi28SfknVVS6s8kzuFTzLGXTtzm3edPRPSBgizU9ZT6jBqV+v2suoIi9lpTbJyl7KCQmR/6w8fOhrxchvRveazKNq12E5Cz4SJxEDQuzJLaeQyTt3RtYVZsHozi5PiZrpm7s5z4YpRXvuC+4+l2qkN5jwgdGq2Y/NYkjIhR5lXQL/ulbij3tRQyxberDTD/9GKc3+krrwQ7BJryFesfCqVEWBl6cyqxMdaOoxITsQxOqUq88tuQ4dVG4anf8It/Y5FlCjz4qbB8Rop0grLBGzBaKNojNiEqQJIV1ZX3bMiuu1RIDB0j9/ul2mMDlKagomcc9bF7z3ik2rTUD9P7g/Y6+zURTtsyHTEtERsUYVNk2lr2ZUNEMDN7LZAQurEhJmzhq3OB1h/1JMLSAVAeOekmvQuv4th0HfNuY935po5LCVL92DE5ca
 uZsHxEPz
 yDteWvRa6wKdEz0X/Gb6FyiTssHuzjkkQ8/ffyOS9JITEll4YUWCa6jwuXNAoBc5kzkzfomPJqnltDochoOqg1FNYQiVbl/CRUqROpUkJHUuJRXWmZNMD9E7i6Efitj4TzqSolVxDHk9JrfWi2+lK1dS4x4z5YCOvdBsrRr1X4DT+P2J+HU772b2U+UZCZ3KHe1bdwTKNK+K8NYmo2nRSqjaxP5DTzFC2PMBs/7K3QKdHObo98bWcg/onhQzdX6+pBYl9eja/NxoEEc7MEryA1gAiYCmUCbM/QbOjHIX9mCle7nM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs essential file operations test (sysfs.sh) was extended to
test DAMON probes sysfs directory, by commit 14885da09b0f
("selftests/damon/sysfs.sh: test probes dir").  Unlike other DAMON sysfs
files, it is testing only a single directory case.  Extend it for
multiple directories.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 78f4badb5bebb..0f2ef462a6b6a 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -346,8 +346,13 @@ test_probes()
 	ensure_write_succ "$probes_dir/nr_probes" "1" "valid input"
 	test_probe "$probes_dir/0"
 
+	ensure_write_succ "$probes_dir/nr_probes" "2" "valid input"
+	test_probe "$probes_dir/0"
+	test_probe "$probes_dir/1"
+
 	ensure_write_succ "$probes_dir/nr_probes" "0" "valid input"
 	ensure_dir "$probes_dir/0" "not_exist"
+	ensure_dir "$probes_dir/1" "not_exist"
 }
 
 test_monitoring_attrs()
-- 
2.47.3

