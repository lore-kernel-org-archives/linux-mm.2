Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42C53C5B572
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 12:19:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 792DC6B04D7; Thu, 13 Aug 2026 08:18:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 744736B04D9; Thu, 13 Aug 2026 08:18:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635166B04DA; Thu, 13 Aug 2026 08:18:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 357866B04D6
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 08:18:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B5EE91A012B
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:18:53 +0000 (UTC)
X-FDA: 85096150146.22.F524BF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id D18DD18000D
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 12:18:51 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LYpj97qf;
	spf=pass (imf06.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786623531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UkGZkCkwAn1g+rojR3eUBE5mp8ZcfnQyrhiZgcLoHB8=;
	b=0W7BFOn7/7G1H2yXXecKC53oLv3Jh5npjlm0XftG8XxUDxsWE/MywZtBWUqPDgOic8H+TS
	WB/s+aY1Aw7HyvRNZ0BiLWd8HruDTdTBbcnH3iusYdw4S1IwAAyU+6ZKdjWj2su+xGkBc8
	f9uI8ZqGmAfa/EMq1YlCi6cdFqgihng=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LYpj97qf;
	spf=pass (imf06.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786623531;
	b=5zFJqX/4FLb2P1eKyHSUsXzDg1fLW7ST8K4QWntnkuD0h9H2Pm/1JKfUCjun8ciLvK4Sz2
	kkELLWDoDvrU+Tk6J3WfP9cXf0cvaVCG4rLzWLMg7+IWXB7UZba/FCNkA+M6Oxe/WrhKvz
	AWVuUPDrA9fXVO4zzFtBPKZnaOj4/O4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DD3D044060;
	Thu, 13 Aug 2026 12:18:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9A813C2BCF5;
	Thu, 13 Aug 2026 12:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786623530;
	bh=bx1auWMjtQ6lK77Ub+fPqi3tw5TQNFTmgBgtSoVMeRE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=LYpj97qfq8/4uunncx8KuPwgfOXjs0rw8uGLRmuA0F2V3UcGUpxgxD4AKwel7bz1d
	 DMtFMIyBQBIl+0Pfn+WkV3cwPWGM2uCVrKUlLLSmo4ROy1rXWkLyyh7ZJSLbjfTBm9
	 tJDRiGXg/UH0cBGqHA+r1tIk2ZYAke6omkHZ3TiwqukEjbXq0r0Ezp+YFnTKsH/kad
	 Xnilsn2tzu8BwXKEfEEdXE3PN1U3bEf31Hhgb4X8letqE2utERAgGDdLTPUW/fa7sX
	 ek38L6kKMGFSakv9HEHup+yqs8rJ5hy9OLhXJRHj7NwxCi1vnKpB0+MN8CzQy96WwW
	 e1sL7uNXBh+8w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3D6C5DF69;
	Thu, 13 Aug 2026 12:18:50 +0000 (UTC)
From: Joel Granados <joel.granados@kernel.org>
Date: Thu, 13 Aug 2026 14:18:40 +0200
Subject: [PATCH 4/4] sysctl: Add 0013 to test partially updated vectors
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-lklm-partial_ctlvec-v1-4-df9e51c13704@kernel.org>
References: <20260813-lklm-partial_ctlvec-v1-0-df9e51c13704@kernel.org>
In-Reply-To: <20260813-lklm-partial_ctlvec-v1-0-df9e51c13704@kernel.org>
To: Kees Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 linux-mm@kvack.org
Cc: Jianlin Shi <shijianlin11@foxmail.com>, akpm@linux-foundation.org, 
 vbabka@kernel.org, hannes@cmpxchg.org, surenb@google.com, mhocko@suse.com, 
 jackmanb@google.com, ziy@nvidia.com, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Joel Granados <joel.granados@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3132;
 i=joel.granados@kernel.org; h=from:subject:message-id;
 bh=bx1auWMjtQ6lK77Ub+fPqi3tw5TQNFTmgBgtSoVMeRE=;
 b=owJ4nAHtARL+kA0DAAoBupfNUreWQU8ByyZiAGp9tigf0HZ/SOSipnWglbugNlaMER9isn8Ln
 HKjGsYXnp8SHIkBswQAAQoAHRYhBK5HCVcl5jElzssnkLqXzVK3lkFPBQJqfbYoAAoJELqXzVK3
 lkFPa8gL+wVFctfUarU/BECGG+yem97ZpueVfSLV32B2PJJKmFL7c6BeArL3+nFK66TgrYUfEDI
 794BeoxGMD2zXrMWvkrt+ynKROFyKvwTTEiUXIy/2RLYaYWMfIHBlDpFhIlgxYOk+JRBGtZ9lCT
 jKEGmr8rUvShwgJ79bMF4GiJ2DyCL+FcGIA4ZZVAsYkaYocp3ryyn25z6J1zzanLyqnGBayYCW7
 4RmOuwTSD6qkmUE5kh9XezhlQhbYW639iHxhLnDmGS4tQ/nIiLrXIVTUdK5L7mVI8ikNwgz+Kz7
 /r4G32tJLbnV0q3aDiA4L7tBUUWlWO9/0vAtXw52FtmR5APUyDHPRntB9K9XN/IV5EZFxiSIhNe
 QhRZ/0aJjRBQf9lgKmyd2kTFs7VHY1gLNnJW0URRuJeCryne0K3vqm+zKpnwFs59ZLD8wPftoYZ
 MaG77XNioStWHAwaTevL7oRdTTv+C+DNryBbdYAxsSZcc0CC+0oew2BnXWGTWrnjwlzthSD8Vs4
 +k=
X-Developer-Key: i=joel.granados@kernel.org; a=openpgp;
 fpr=F1F8E46D30F0F6C4A45FF4465895FAAC338C6E77
X-Endpoint-Received: by B4 Relay for joel.granados@kernel.org/default with
 auth_id=239
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D18DD18000D
X-Stat-Signature: naaij41qyoc97damjho8qi5jfxethoie
X-Rspam-User: 
X-HE-Tag: 1786623531-272753
X-HE-Meta: U2FsdGVkX1/NZNRAeN9/w+RQEQcDirIXpflvm30xFJ/2ye6iAJ/NIVRi4kIfUTo5FzOz7WkU3m/mMQhKcq7/Xkm8jutTGFzo+CfJ/pBj/JTEEJZBbkKOQ8+yo3plsBH86dOD/hT8NN8nQopHjP39wFbwosq4ikK5TVDGgERYDl4XzCaOEkPB6mVzS+3lDMYfo6YgUI3JTIQSkCRDKX9aUgB0zC6C9JLPlPmj/jVsOvtSOa98oBwUrQs453a7lHbESDxgclynehF2kjbUeWmiNU+3VYpLP9wlpxpnVEfmGfdZDH4PUETEShghSu2cHlp3isfn8yioG0VpbWw+iNrBw9Lg+gJElC0WE05QLy7xXa4wuu2E3DlXsugLRkLV14CPKNj+ynlgXJBvgUU0kU9lYfUNVlrbN1KcqittbVK7IJH5YOTdAzgGkDwz+yRxnw93aNtdYMnba1klHJvzBSKaZVl/OO2HHreQsSgl+PWFnFtr9gjUSwZzd3grt/cJN9K0OraK7twpPBhzW8XqMSq+QRbmalEDvX9dzMXQcqRo62TuS5dS5LutsrWH0qLk45UycBR8LCNvi9B8vKZ8gNF4PWpcOTRgNz/3lC1hYB1AeAsE+ugRoMavDW/vgXnAhPr0ztAR+CxeXbo6OvcsXFliWP/LBJSqTiMgJlPLUqk9Ae1v+pM+xS5b4dJOEOSGzEqwrYv3hPZWMA4Uty81gG8TdJFd6CsWL5G5mSnsSCYYtM/uw7OZLCKAKaLprw666mvl+UT1fxCGYaq4k74hW/RZ4yVTyJx/a3Ac7ehk1jCFPkkcb4WsCfuzk2jbbu+OCHfyi9Ln1Wb3Y1uW+puNCEbUWf6vH0E++/HindShRUfRiTeOTu080X9fUHPuYFG7mIh8w8SlA77QquLz/WBofLZ1RQ41PbUy3Zwt9Esgh+Q/0ShnnHBmL1FghPQCuh8zt8TW/IEEINwfEd6JIVAi0kC
 Gr4+M65D
 EVgNFsZIT5GKWtdg77Y3aqKsAqjeWwRiB97MMTHUDGMSRSOwBJdZhUF7/gi7RA9nWtIke/tSeOyEvrThzAqXyYY6AT6RAgMGcs8C+doibKJBcbXL+s/sg2zmA7XXuTYIWi5tNs5EsvSiiQ1aZtBTqZ1KMcT1yaQK5Uoj42cfz/NM8X9ymIyDuVy+dgCKp0pyDX0vqoVtyRo2BiqGnN1M6D3MVPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add coverage for partially updated sysctl vectors with test 0013. It
makes sure that the sysctl vector is unchanged when one of the elements
is not valid.

Signed-off-by: Joel Granados <joel.granados@kernel.org>
---
 tools/testing/selftests/sysctl/sysctl.sh | 57 ++++++++++++++++++++++++++++++++
 1 file changed, 57 insertions(+)

diff --git a/tools/testing/selftests/sysctl/sysctl.sh b/tools/testing/selftests/sysctl/sysctl.sh
index b2d8bd9026a721e96c26be20069f7f87b06a5cf7..fdf3d2fb0a2ad23a525d3205577a06d7d97576b7 100755
--- a/tools/testing/selftests/sysctl/sysctl.sh
+++ b/tools/testing/selftests/sysctl/sysctl.sh
@@ -4,6 +4,7 @@
 
 # This performs a series tests against the proc sysctl interface.
 
+# shellcheck disable=SC2317
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
@@ -37,6 +38,7 @@ ALL_TESTS="$ALL_TESTS 0009:1:1:unregister_error:0"
 ALL_TESTS="$ALL_TESTS 0010:1:1:mnt/mnt_error:0"
 ALL_TESTS="$ALL_TESTS 0011:1:1:empty_add:0"
 ALL_TESTS="$ALL_TESTS 0012:1:1:u8_valid:0"
+ALL_TESTS="$ALL_TESTS 0013:1:1:int_0003:1"
 
 function allow_user_defaults()
 {
@@ -196,6 +198,18 @@ verify_diff_w()
 	return $?
 }
 
+# Verify that an erroneous ($2) update fails and does not change TARGET
+verify_no_partial_update()
+{
+	TEST_STR="$1"
+	echo -n "$TEST_STR" > "$TARGET"
+
+	if echo -n "$2" > "$TARGET" 2> /dev/null; then
+		return 1
+	fi
+	verify_diff_w "${TARGET}"
+}
+
 test_rc()
 {
 	if [[ $rc != 0 ]]; then
@@ -501,6 +515,40 @@ run_limit_digit_int_array()
 	test_rc
 }
 
+# You used an int array and one of the elements is not acceptable
+run_int_array_no_partial_update()
+{
+	echo -n "Testing invalid array element does not partially update ... "
+        # Expect failure because of 3rd element (abc).
+	if ! verify_no_partial_update "1 2 3 4" "10 20 abc 40"; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "OK"
+	fi
+	test_rc
+
+	echo -n "Testing out of range array element does not partially update ... "
+        # Expect failure because of 3rd element (greater than int)
+	if ! verify_no_partial_update "1 2 3 4" "10 20 $((INT_MAX + 1)) 40"; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "OK"
+	fi
+	test_rc
+
+	echo -n "Testing invalid first array element does not update ... "
+        # Expect failure of 1st element
+	if ! verify_no_partial_update "1 2 3 4" "abc 20 30 40"; then
+		echo "FAIL" >&2
+		rc=1
+	else
+		echo "OK"
+	fi
+	test_rc
+}
+
 # You are using an unsigned int
 run_limit_digit_uint()
 {
@@ -880,6 +928,14 @@ sysctl_test_0012()
 	return 0
 }
 
+sysctl_test_0013()
+{
+	TARGET="${SYSCTL}/$(get_test_target 0013)"
+	reset_vals
+
+	run_int_array_no_partial_update
+}
+
 list_tests()
 {
 	echo "Test ID list:"
@@ -900,6 +956,7 @@ list_tests()
 	echo "0010 x $(get_test_count 0010) - tests sysct mount point"
 	echo "0011 x $(get_test_count 0011) - tests empty directories"
 	echo "0012 x $(get_test_count 0012) - tests range check for u8 proc_handler"
+	echo "0013 x $(get_test_count 0013) - tests partially update vectors on error"
 }
 
 usage()

-- 
2.50.1



