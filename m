Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 188FEC5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 10:41:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8CE66B0300; Fri, 14 Aug 2026 06:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3DD26B0302; Fri, 14 Aug 2026 06:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95B3C6B0303; Fri, 14 Aug 2026 06:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5FDA66B0300
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 06:41:27 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EAA41403BC
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:41:26 +0000 (UTC)
X-FDA: 85099533372.04.1D32C05
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1611540008
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 10:41:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gvZR6r2s;
	spf=pass (imf07.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786704085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T8mxcnvDvKnoRI71UmDt8cTgQ8NQ7Nk1pqrLjzhBekY=;
	b=Yd3xDJGF2VYax27zz3VFOoNPqXJO3MfLJP0YX/qH++dWrDGKxVWntECK9CVf1CXDtS8BN0
	f4TrL07zW9bv6eRvPfxcMqr9KU8CIq8hymGq9rV/MI/hmtY7lQdvVl/AgfwckgGxhYn9lU
	N/2BiCaX8cFPNKDTzkB+l/P1PgljwUE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786704085;
	b=cpfBFLYTM7U2TONeWhCsq4fuWy9HoLEqZln8QHVJt0nsXpvzyBihPGvZT0FYErR4sCbZMS
	LgNacH1DxI3yTAaTmzjyLNBmJbUT8vk4z7IumzZEi0Vw17Lg1TMsGEX+ya6cUvP49oWxK3
	XvsTswZdEI2fADf7Lk8u2o7PzRJkOd4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gvZR6r2s;
	spf=pass (imf07.hostedemail.com: domain of joel.granados@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=joel.granados@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 12CA044F3E;
	Fri, 14 Aug 2026 10:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CEE67C2BD00;
	Fri, 14 Aug 2026 10:41:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786704083;
	bh=YHI3VBORAsd9SqfY5aar0OvGzZqdtGpSqI6smTfSLXY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=gvZR6r2sAk+83hGeBZm5n2MK5vP+Q1JS+FYof1FPUtkEr8K1hckh+rQfCr+iMnC0/
	 7OGsT0A727GWC48yIcVuyfkDCvsjvwhaUPykcg4Qozpy6ktL/k4i2ddt6T3ldiCSw9
	 xPc3tY2fdCn9UqUOuXAPIOnJ5ZZD5XsWsEdTFG+7bk027mB1uu+/HqmR+YdzbfLfp/
	 K+jmx6X/yCeCtwwoAWXVcD4oqC/4ey9tCvYTm6cXAM3TBAqo8suNZpTuTPJ5vq/UfU
	 aQ2wh3gix4NxPEg1Kchd/gu2uhXS9hoO4vCNuzZnvHNiR24secduk/o9oNxB5xWfv4
	 FFxvEb4AgApEg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5602C5DF67;
	Fri, 14 Aug 2026 10:41:23 +0000 (UTC)
From: Joel Granados <joel.granados@kernel.org>
Date: Fri, 14 Aug 2026 12:41:15 +0200
Subject: [PATCH v2 4/4] sysctl: Add 0013 to test partially updated vectors
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260814-lklm-partial_ctlvec-v2-4-9df50d26e477@kernel.org>
References: <20260814-lklm-partial_ctlvec-v2-0-9df50d26e477@kernel.org>
In-Reply-To: <20260814-lklm-partial_ctlvec-v2-0-9df50d26e477@kernel.org>
To: Kees Cook <kees@kernel.org>, Shuah Khan <shuah@kernel.org>
Cc: Jianlin Shi <shijianlin11@foxmail.com>, akpm@linux-foundation.org, 
 vbabka@kernel.org, hannes@cmpxchg.org, surenb@google.com, mhocko@suse.com, 
 jackmanb@google.com, ziy@nvidia.com, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 linux-mm@kvack.org, Joel Granados <joel.granados@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3356;
 i=joel.granados@kernel.org; h=from:subject:message-id;
 bh=YHI3VBORAsd9SqfY5aar0OvGzZqdtGpSqI6smTfSLXY=;
 b=owJ4nAHtARL+kA0DAAoBupfNUreWQU8ByyZiAGp+8NEZx7DhoWX+VVmoWYcszozrHrTSVyWWi
 NensKkTznzrsIkBswQAAQoAHRYhBK5HCVcl5jElzssnkLqXzVK3lkFPBQJqfvDRAAoJELqXzVK3
 lkFP5nkL+gOLrefeg7tdLifVFAOWe9dtn+spU/1WLrN/o+x2sYe9+IVhJQKAT8S1ikOZr0D1eNa
 ASVm4Sz9LPGPHEAUuF9EtwF6qqrWg/3ZNGYZ+X05idINQ3jROzIMrcxRglhxOCE+8MYZ5lwAume
 VeSpQStAWQcO4TqMHUs9CiJrvxHSS4AEnddKvwFH+AhN+5nahkgwpXHAvtvN4CXFpYpZlCeUE/Y
 gCRVJQ3ikhBtkDn5YOhXbPoiKRtqTnPiSEfG87ibN8hILuti4JAeuNrY9pzJuH4D3Clicp3hxsg
 LV3YL3CXAYi3oNKW9vq4SI+YGEoSOQUMEwfAI9fEDSI9XNEgNc3ENL7IfDDiWayX9crn7X/HD8C
 ILHDSwaMPOP/+pwf8GUE73GS6ow2R/Z0geldHXgpe/IHZopgMiwlcL3VzouyJm67V1bq7dSwLFf
 +d6DLLGQUDuYHBQk8Ds/ZZjVtQjNL4h8nRc26WCMiblkgBQzLFSAwZHjwBkT7ysaMoM8kGxwi95
 08=
X-Developer-Key: i=joel.granados@kernel.org; a=openpgp;
 fpr=F1F8E46D30F0F6C4A45FF4465895FAAC338C6E77
X-Endpoint-Received: by B4 Relay for joel.granados@kernel.org/default with
 auth_id=239
X-Rspam-User: 
X-Stat-Signature: enpf6qchcaomgdstz3mgksnn3pqck6yf
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1611540008
X-HE-Tag: 1786704084-833234
X-HE-Meta: U2FsdGVkX18k4auhejYtTGMASaNgwotcG11wom+FmgsEb1mhUvMigARYi/Otozs5gXKGz6TBarFgKEZcN63gDRRtU/9FeeXxpv7A/SJJYR134AgiKN+EYs+7POr6Zk640qP4AyhFSOHiqAo+ZY/uMrX3fuEl8v2QD3bUvFl6QOimRfXWRo208wESFtTgKdj583qz7+KRTEjK6awt559CA4b1iMIw0hmAXEmDU2FWONNwi3P+bGJWmA2VjmAhQwjBuSSwh8L+fdzK1NPu5LNd1dNeMvPTPwqZuB0KV52Y4nYMdqZNv3I6dxH8cjSa0mdt+y7INU1eTitE8xNgXyRMFv/5+ns9ou/pPavtDb90uoHmLRf7tRCvfK8oSPT1H9KmaphFqFqxi2r0JXpSjQqZmCSLM6mJM+usw3c32i9UczuCJAgLp9RGedFyVPEVBuGANlZSnlczlh06onMyULiNZgy3tYJNIkANLg25zOBl1STwmS5UoxQMJWrsuwwPFmz7AhDQZbdWKm5165c5b7pZsjDYSF9c7Gs68b8FUPZqWoWz4ZzTEjyPICkQuAd8sWSMDmSQ0lPBr5BWoUM5i5jE8BpU5e3tfrjfphZyCu6krRv4SkP66m6OssFJCr+I1nVcXcs0ViRWkiGXo5cAOghZRBUVaxj2pvw75KL4iD/kvqVWncapMf7xFChlfcglLIDmDQBGCG7RIbm6YGn6Y7AIhnNiOCS2lijxmPiMrNfGBMj18/dQwe74zYDDRacsx6dWpJPO61AnVbdMIccO6hRLDaKqpisUApx+kbcWu7v/Pusy9zlD2IrrdjBz4/ej7Tr3WT+NFeyXe9xQz7oMpvy1YHZK9xpXdqmdReTUmc1ykVlZJWS+9+wFzgIkNBI/Hnn7ByBdlzcPUlm/PILyhL4SiOsx62OyNLNYTT4LCQXpJyJu/jwYA7nxalBXTof7taKMpsf/l8w5Q1Cph5OMJXk
 bUmjPat2
 B+waNDQPnQIrI4ljHUoJThqZdcNtTUHU/SSogzxqDUlpKPBoqZijeHla6V+zXHXaUSWrc5Y+6AGk33IU+2C22bXJToN3AEp2f5AMrAnd1hgo3HyqMhup5nDC/1wS9b9g3iwl7LfgOcrdOJDV/UzXZYCUNhBO+sXsHEsEjI4DUdtwZzTVjIhtodIs8GQifv00o79eL6cQaxyN6ryY=
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
 tools/testing/selftests/sysctl/sysctl.sh | 60 ++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

diff --git a/tools/testing/selftests/sysctl/sysctl.sh b/tools/testing/selftests/sysctl/sysctl.sh
index b2d8bd9026a721e96c26be20069f7f87b06a5cf7..dc8674455284612dfe898944b886d856fb8ab3fe 100755
--- a/tools/testing/selftests/sysctl/sysctl.sh
+++ b/tools/testing/selftests/sysctl/sysctl.sh
@@ -4,6 +4,7 @@
 
 # This performs a series tests against the proc sysctl interface.
 
+# shellcheck disable=SC2317
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
 
@@ -12,6 +13,9 @@ TEST_DRIVER="test_${TEST_NAME}"
 TEST_DIR=$(dirname $0)
 TEST_FILE=$(mktemp)
 
+# initialize for individual tests
+rc=0
+
 # This represents
 #
 # TEST_ID:TEST_COUNT:ENABLED:TARGET:SKIP_NO_TARGET
@@ -37,6 +41,7 @@ ALL_TESTS="$ALL_TESTS 0009:1:1:unregister_error:0"
 ALL_TESTS="$ALL_TESTS 0010:1:1:mnt/mnt_error:0"
 ALL_TESTS="$ALL_TESTS 0011:1:1:empty_add:0"
 ALL_TESTS="$ALL_TESTS 0012:1:1:u8_valid:0"
+ALL_TESTS="$ALL_TESTS 0013:1:1:int_0003:1"
 
 function allow_user_defaults()
 {
@@ -196,6 +201,18 @@ verify_diff_w()
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
@@ -501,6 +518,40 @@ run_limit_digit_int_array()
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
@@ -880,6 +931,14 @@ sysctl_test_0012()
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
@@ -900,6 +959,7 @@ list_tests()
 	echo "0010 x $(get_test_count 0010) - tests sysct mount point"
 	echo "0011 x $(get_test_count 0011) - tests empty directories"
 	echo "0012 x $(get_test_count 0012) - tests range check for u8 proc_handler"
+	echo "0013 x $(get_test_count 0013) - tests partially update vectors on error"
 }
 
 usage()

-- 
2.50.1



