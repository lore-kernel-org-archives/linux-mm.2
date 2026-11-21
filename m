Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9185606A330
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hVYAiXcd
Received: by kanga.kvack.org (Postfix)
	id 509EE6B05C8; Sat, 21 Nov 2026 16:00:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 492CF6B05CA; Sat, 21 Nov 2026 16:00:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381696B05CB; Sat, 21 Nov 2026 16:00:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F4676B05C8
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:00:32 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 882C11401D6
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:31 +0000 (UTC)
X-FDA: 85460344662.03.5E6539D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id DBC901A0005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:00:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hVYAiXcd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795294830;
	b=cgaCoIemnObm7OkEgMB7RR+JZ9leSeneHHnTJv9BwFuMzgug9Ym2SsmGEXHxlGfxkokUmF
	7t0hPkoN0kRXQ71gG1JAs/UbhfioROANSSId855jP87+T9hYzxuQwugnSiSE+JSkC0KzMx
	CiUW7W6ikYAIuAG32lxB3d9wQXW321s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795294830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W6sgrGq/PIPvl2dUtr0MUNu6vsfTRiTVsaaYrgPkigI=;
	b=NLbpYii7L449f5uTSDOoplca8nJ/8MAYUIG/l1lh3aZJtYUzrW8E0eGipQCBji6sJCN14k
	zjtSUb1BtszFKhvAJ9Fnv9aSzWCWphl/c7xPG9h/ycdMLtQJ3HsUHj2iW1y0RmZ/kT1AM0
	RaMZVa2ZI3vaVRSYa9xOT60Di7SuWp4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hVYAiXcd;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B4FE861B73;
	Sat, 21 Nov 2026 21:00:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3491C1F000CA;
	Sat, 21 Nov 2026 21:00:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795294829;
	bh=W6sgrGq/PIPvl2dUtr0MUNu6vsfTRiTVsaaYrgPkigI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hVYAiXcdRBByp1AyymUjbq0o0B20zi+R9yO+B9MX0vn27z3uGVSxnz2vwXyrEs0Ed
	 rGCanXbvjfhQ660I7Tp6cm6JWM0VcTmi8Q2YJhYzOzJpm6Hy2RQjPH2/HMB8P1YblP
	 SaDuxOxYmVIxRMXJGB6shWjJNoXys+d7+ZJL4zn3IzgVjv+WObcTD1Cya/qF0OzXwi
	 9FVyUjvZ/AFw3JauRVfXF6mUeNmpN4wC9L7cCq+rw4b3skTJQaEXtRAbSD55Uvl181
	 ltC6SguimzDwWe3z/wfVaBdyB05kdKMdVR2o6JKSh0igfnAXQ2fz36Neu6NSr0Dsc9
	 s8Rd+vVMfi6+g==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 24/27] selftests/damon/sysfs.sh: add basic tests for admin/reports/
Date: Sat, 21 Nov 2026 13:00:08 -0800
Message-ID: <20261121210013.130397-25-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261121210013.130397-1-sj@kernel.org>
References: <20261121210013.130397-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DBC901A0005
X-Rspam-User:
X-Stat-Signature: khm394trpcr5j8fadw7n3qq59ei8cskf
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795294829-9536
X-HE-Meta: U2FsdGVkX1/UrL41pFoAGq8jkI3VdvVZWXKj2ur7NV88UPLE4d2YdONsld+l4D8li7L0aPJ4Br/voEepH6ls8CE4QEkkZsNXQ0r8pdbKP0DfScJxMu8bwI9z7imPbjikFwNH53YVzCyc90DxMUmIy5PTBUdQ8tkZEtOVNK1YenHeuBxXKL8XjQhzY8Az9RNy8eb34E5w86kzSSeNJnjolNoEV3hlyHo96wdGV6pjK/RQiDFg4yOIA5xn4jmR0sdEz9bwt9ahMnZJB9FeHCLoC+QHjac8giHUAZs6JZIxMV1mfaFP9uzmpo5XLGh2ivsTrZ9hQ+RaqaC1M287i3Zc/mBMreQoYZcJDO1EEH/99MQvYtkEzyfd6nmhcwqZibMkhCB4/m7peykY/ffNb+mCahEc+F6ZXVimmmpLDUvfplASDPHG31YjmBp7x37/1/BA39hSdBgaufSfChc9+E/Pn/DB1XYjPz/u1X7NVfZ9pY8R0ccMOpVuW9V8HSMPgA2vFrFz8b5mTsFa6/dH9ytZOWn+62jzS8FzpZfY4nGw8V2ry4grc/8evA6r1VtTpLI/EcUIkldFF3SoGmfsF2K4t1sRF3uYF32fxeU4KCKME2K+eawwwfJ/YT6FS8s2gtC4BHwNV4RrYJRAfzpHIVK9jXsj17Q0Oa+IiTSLxSRYHTkY7UDcwfOhvpRcqvMbfjFBhqNmQgDvTAu19T5dlsvwrzZ0pt6JHq5Ie34+SqZTiwMUI5qN09NVpL2oc+a5FQl8a3GAfGzrzPaGwpts/ez8F1vVGx4S5oYniZS66CKm8X/FgDTf639YCPh7hGw0EZwDiHaU0AfiFWVv2YRYJs1r00OSWcFA/+mvQJhQ/qx4eV4Bd4USGSeGOmYZYSHJ3f90bKMGTVzUruvI8T3iUSRt1ObWq6hsPTthGcSgXPFtblZAY6tI8hScWlGoH8QxDBtVMsAGhnP5idjZtri0Khj
 9Cejucbw
 jD8/gsKIvNtR1XUV/qTBNHx+0rHU0QYwruH8GOzEl+RweD9g5jm4DBYAIwdV5S8pSE6yh3DPY1x1WCo8hoT0rX9WFo23qrfSztmz8Wbr10Ax/OEr+ZRYuMq0migFikHO93NPj2GA2uTQ3tbKw/FGvfmU6YYbA8B6oI/iNqWE6bf7ifZ8uLduVs29jIOyM0gP4KkJx/CPwGOJ/GtB0kcVUfzCFFm1/iZB3FzAdBc8jYBXSqam+8bdNrUMuGhM/Sfh4+sjuj+WqRT837NX9axYgqCUvuyhTlS13QUhC0gumOjH1Q6Om7N2TcEYXEIywR4KLEyObk1qHH8ECVI8eRp+N7rVdxtoznxODQG3d9VivzeNomICbiOSGyj8JbDCDaQGua+6hP5xiNseOqdj9eTAtBS4D9bdhKS+4ZnzL2ucHrc5c/HCunVTi6AFV/r/rH0IvsmsnnaqYNDzdisI=
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

