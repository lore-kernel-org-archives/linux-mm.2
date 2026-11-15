Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 06A01606A338
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 20:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lzuLiX25
Received: by kanga.kvack.org (Postfix)
	id 1F67F6B05CD; Sun, 15 Nov 2026 15:29:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A66B6B05CE; Sun, 15 Nov 2026 15:29:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06CE26B05CF; Sun, 15 Nov 2026 15:29:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1D616B05CD
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:29:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 62DB5A8357
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:12 +0000 (UTC)
X-FDA: 85438492944.14.A2258F8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C15641A0002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lzuLiX25;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794774550;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W6sgrGq/PIPvl2dUtr0MUNu6vsfTRiTVsaaYrgPkigI=;
	b=0fGVJ+M7cb485LUeaDuF9DQ3p9HyKEwVeoURY3ZYZFfbvf4A0b7ZMw4uY7PqhzMDLDcZsV
	EZI/8eai14tooM9Ut0+72w65P6nuFoZgXCiAauZBHDjEPZej43fhNHHRRn5vbBRpAdIe2P
	dd3LiAfm9N1C3SWtLXWTdZfBmzbiXUE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lzuLiX25;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794774550;
	b=Y2uzpv02z59DrvAFIuil7uukH709ny0sMeNnrw7TsAJvRzQU81NhMVByr0V2Qlu44ZuGd8
	kosSwZ8UTBDiQGb8AGc7kTipEtav2VaY3oESX6Vo5qHKlLZpOblpW0XL780+qYtd4ppqPs
	4c/AzzgpXIwqjHNPVXnIbdHfOQ+/Geo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DD5B44CF6
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 20:29:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45A851F000C8;
	Sun, 15 Nov 2026 20:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794774550;
	bh=W6sgrGq/PIPvl2dUtr0MUNu6vsfTRiTVsaaYrgPkigI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lzuLiX25gw2GZjl9a/4QVtmg7J42CRZmnbhDZJul7b+jxLRzFDkvM1tct6l21Ny47
	 VprzVyjkd6DoKUoAGGKwe5LNMywgrO71Iz4eILsHyO2a415ux3XqYiEZ10bdeerlKH
	 3fI7ZlcPKahyuDSD9IJLXR+8tOJZ7Lyay1Sk///sr5Cksa89ps8G3RJRDDQRTaxH/Z
	 80JxaQUdQgHdaoRfpF5RW1GruSaiSbUu7R5a8sNDC6d5wlJ30LEpVbDceEEHtQmVAi
	 DJUFHQRXXoIUhi54P2+0UtsymNoSU8ysbNIXOVFMG3HaC4SKI6JtygZXhgudijaWiG
	 lT6YfcOVsogtg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 24/27] selftests/damon/sysfs.sh: add basic tests for admin/reports/
Date: Sun, 15 Nov 2026 12:28:42 -0800
Message-ID: <20261115202849.99134-25-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261115202849.99134-1-sj@kernel.org>
References: <20261115202849.99134-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C15641A0002
X-Stat-Signature: rrpju9fqotdpu9xy4df3zkekn77h1sbe
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794774550-176816
X-HE-Meta: U2FsdGVkX180TxFvaGdkL9mynsOB9TrJuopsQfuM8eRhzb5TDus5AsDrwdVKuVSE1SCobmujlfJwhe9dmeUYGqP5a0qCnXC9dS7Lcx6vVLrSej9lL+Du0sxQHulpLjCPUuitmvm3fCAPyjfpJpkj1RCx8DWZnbFIjYVV+v6EIj7CgISgM5LkPwj3P9zcQfTry+ZWAzA0wwwXG+2CXkqE42F2fPcjnV3riSDhywedPn5EohvLDFxnrna12ZnxwehBkcPparQQ9UGnDzQzd7BGD8hoZPU8aDlAx9RvlLEzF9YE+pC4Ww6fPyYjujmZof9iD1/zSyf30wlVp2OAqOgpG2179kzkS0spCkqhFlXTFDqld7S0viPP3W20r/ENbHxeiWwm9egYY8ulroid2quLzNNMsGXk8pkGc1XAJeM2E6zo6aBsp9J7VTpMRznfinQOBe7wzHMg4EMWvb3yqoDwnwvZt0EEeG02o8C1YOl+CR6NlU4XaOHpMRcvzw++5HB/7rHMstKwSicBkK9ULeiiMeI8y+iAo1ybEHILUp+ryOli+Yov+1QHTq7/eqjvwIjL6wUXBQPabiofg6Xk06CwyEZSFN1FB4vb49U+bPgJHARo7UT/b/xxBQ9vjKDYBJO3IbuX8Dl8k0U3H/C3YYrIFQ+9qyB6AHdhpMrYDhEEm/cnMpHxL473JYxNR1/8h4mci8P0Ug+2AZnSXBtHsbi0bL0sFhZ3s4/DWeTptnBsn/RBKE9KgYGtpU70kFqre6DJtCwIIYIr9qvZ7RJ8/9SSVqMGyAg1akMfqKP//4fsd+rxxNbic9Ysvb/ZgobHD4pw91KheFMdohxImAXzDHsNJDlVCFv5li6Pr+Q0i3uGiIGPUjeubisakeNweHqzrhdMGRAI4LIg9FLMjKOibdLbux68CRuYntYfH7BRX4wljVJBTSXM2Ad80Pmb2Zr0R9y5vr8Yn1gMY0OVVaCID0f
 4uWVefrv
 gSN54wDn3csR2/y4WIu5rLReT3toIUf1ZYA4wr/qQ8rKYxw9ONPYbXfwsEknGmvVVYLwCC2UO+3dQVaUIYcGLZ9o2+tYfpaqcx8IgFLyGVcZRVWvCWoGwjhI9nhHYSyAwKyIamQs07utFm9e95T/zDDyQBDFr5anHn6AJx1F3QOo+6Fw2WC3vl0IG/qsAsQogdgP9uO3WnNfwLhyvM6jyv2IpG9YlKhuogsrF2pnd6zfO6M8nCkVhPNU5ZA9ejf7iJxsamPbNpWVB/pISINOFKwui6sa1dKRuA9x9JMzlb5EVWzI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Update sysfs.sh DAMON selftest to cover basic file operations for the
sysfs files under the admin/reports/ directory.

Signed-off-by: SJ Park <sj@kernel.org>
---
 tools/testing/selftests/damon/sysfs.sh | 52 ++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/tools/testing/selftests/damon/sysfs.sh b/tools/testing/selftests/damon/sysfs.sh
index 1cc7ab2d7e22f..577953ee4e631 100755
--- a/tools/testing/selftests/damon/sysfs.sh
+++ b/tools/testing/selftests/damon/sysfs.sh
@@ -510,6 +510,57 @@ test_kdamonds()
 	ensure_dir "$kdamonds_dir/1" "not_exist"
 }
 
+test_producer()
+{
+	producer_dir=$1
+	ensure_file "$producer_dir/report_type" "exist" "600"
+	ensure_write_succ "$producer_dir/report_type" "user_report" \
+		"valid input"
+	ensure_write_fail "$producer_dir/report_type" "foo" "invlid input"
+
+	ensure_file "$producer_dir/producer_state" "exist" "600"
+	ensure_write_succ "$producer_dir/producer_state" "on" "valid input"
+	ensure_write_succ "$producer_dir/producer_state" "submit" "valid input"
+	ensure_write_succ "$producer_dir/producer_state" "off" "valid input"
+	ensure_write_fail "$producer_dir/producer_state" "foo" "invalid input"
+
+	ensure_file "$producer_dir/addr_start" "exist" "600"
+	ensure_write_succ "$producer_dir/addr_start" 123 "valid input"
+	ensure_write_fail "$producer_dir/addr_start" foo "uinvalid input"
+	ensure_write_fail "$producer_dir/addr_start" "1.23" "uinvalid input"
+
+	ensure_file "$producer_dir/addr_end" "exist" "600"
+	ensure_write_succ "$producer_dir/addr_end" 123 "valid input"
+	ensure_write_fail "$producer_dir/addr_end" foo "uinvalid input"
+	ensure_write_fail "$producer_dir/addr_end" "1.23" "uinvalid input"
+}
+
+test_producers()
+{
+	producers_dir=$1
+	ensure_dir "$producers_dir" "exist"
+
+	ensure_file "$producers_dir/nr_producers" "exist" "600"
+
+	ensure_write_succ "$producers_dir/nr_producers" "1" "valid input"
+	test_producer "$producers_dir/0"
+
+	ensure_write_succ "$producers_dir/nr_producers" "2" "valid input"
+	test_producer "$producers_dir/0"
+	test_producer "$producers_dir/1"
+
+	ensure_write_succ "$producers_dir/nr_producers" "0" "valid input"
+	ensure_dir "$producers_dir/0" "not_exist"
+	ensure_dir "$producers_dir/1" "not_exist"
+}
+
+test_reports()
+{
+	reports_dir=$1
+	ensure_dir "$reports_dir" "exist"
+	test_producers "$reports_dir/producers"
+}
+
 test_damon_sysfs()
 {
 	damon_sysfs=$1
@@ -520,6 +571,7 @@ test_damon_sysfs()
 	fi
 
 	test_kdamonds "$damon_sysfs/kdamonds"
+	test_reports "$damon_sysfs/reports"
 }
 
 check_dependencies
-- 
2.47.3

