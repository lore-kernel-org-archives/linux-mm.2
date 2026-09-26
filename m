Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BFAAC98328
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 04:55:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE3306B008A; Sat, 26 Sep 2026 00:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B941C6B008C; Sat, 26 Sep 2026 00:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A83146B0092; Sat, 26 Sep 2026 00:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 792C86B008A
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:55:34 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D55D01A07CE
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 04:55:33 +0000 (UTC)
X-FDA: 85254700146.02.8116FF8
Received: from mail-dl2-f33.google.com (mail-dl2-f33.google.com [74.125.229.161])
	by imf06.hostedemail.com (Postfix) with ESMTP id 1497F180002
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 04:55:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eJwTrllv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.229.161 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790398532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jIz/JN9ukuZDr8dYKEEF5/6B8MoCV6AQWav6EuakVBc=;
	b=0zdRRxEpqcRtZmJmtYT7aua+/DMIMhXzZ4LryL6T+f7cpIazG7EPyfs/b2t8rqBdGKigW9
	aWgvFeu2flMA6IdOS3kYduKzXjTSuFUakaAcLbso1ltd1zOLVdW7oHczxt8Q4ozuNojglx
	JQ1eo53TlP+lpfuugvvm52uWM66AqrQ=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=eJwTrllv;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of matthias.goergens@gmail.com designates 74.125.229.161 as permitted sender) smtp.mailfrom=matthias.goergens@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790398532;
	b=Gzc+uuh1FnZJz6Zy3lAeq8X9iUrmWr1SiXhWdkHN+2b/vQsIrG+5/iBAloJiXx58qTie8y
	XmgAacmoXjw2H/2hIIme4J38bQZ0uuW37MJ8vcAPv1n2DHLV1sQGX1Sd6KHaPIIFc3+wX6
	N8xljS8CIkaMPY2ZBySOnCSVGabw02k=
Received: by mail-dl2-f33.google.com with SMTP id a92af1059eb24-1438e88300cso1319808c88.0
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 21:55:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790398531; x=1791003331; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jIz/JN9ukuZDr8dYKEEF5/6B8MoCV6AQWav6EuakVBc=;
        b=eJwTrllvz9Uzq2F1rkn8ynMovC1+qJBfEY9Z+jak77oHgKt5MLolW6eEAr2d398R3z
         8tCN90tsDcGn5jxtoyh8IruCEbxWw0oUADtNKtejZ3Izbpsabw4FzJAKBJwwXH6GZ3FB
         SebVcItMg3JfmVfuSvTGwTfK6s7o8A9RbhqghIrlgh9Yoo1s2vXi5nd1BWUUN1NA5lDW
         B1qyMKCDT5F7qegkmg6X0VMUqEasKH1VOkvSlOcgDTaebjLnqmNfuyKnchyHqSjkOXxu
         luk9jyLYXxe2f5r1B7oO+GjHWOeC/7EBYeA68scSIlA03TgtrHuQppChAj/SYHVMv9lu
         dNeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790398531; x=1791003331;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=jIz/JN9ukuZDr8dYKEEF5/6B8MoCV6AQWav6EuakVBc=;
        b=ySdWo4f4oY8f/PuiR79b6rhW6wJzsYpFh7NFFigliAn6UWvCamYUlH5DmVq53VrmQT
         b26LMF/HOc/Ddgn/bCGnGvMuOxxor2FIYNC+BF8nItI6QfBEkeIqiw7kWm8GXnX0fZ5p
         SNqD8jNgeU1LHcEkFG3NMfUYCc8E4ZETg79CkMZ8HVyx6GJTutH8CxBaXXSd1uhFe/oD
         B05ylBvUg/0on6DbmgtAZnX/6WJivap03neGDZJ/5B5ywQwegPqZ7r3cJMlzaKJGAfHu
         ZJKspSrRI17iYp6jfhIiG2qcSHt5GHrsXs1Xq63N+ORn0aE5guyj5N2+m6Gcp8gNmNpw
         3R8w==
X-Forwarded-Encrypted: i=1; AKwUvBzRJud0gvAEmnPLW44BSqZKykG9OZA1SOe++WiEA2V9hG4/73T+HUiBCQZesniYzwfhD1Gr7Dhylg==@kvack.org
X-Gm-Message-State: AFuF++kNMo6yffVurnS3ehRYFvii63IXFVEhtH9J3YS8BA92e8SPykK2
	qAF6OTYhTNjN8AOLgEVDdlWDGVW/5OuEqQ9F2urIs0bCBEo3Gu6bEuGB
X-Gm-Gg: AYBFou1b8kYiyXGdrxIEmLrv8RjpDA1K/4zUh8CMf9Nqh0tc2WPuoVvmK/on9QhGS6d
	MV+CZD5GISykgHJRdezNiRVOcHlNGeUQpBiSp0TFChhW6ytvPeJuzaW8FXc2vOKeJMtSPWGMMYw
	tAo7+6JYuHrc6TUN/7x7BQPnnlJcF348oCCk8Eh6BXjoaaxGiIEBp36yExFjozwjzJ9MyoMBQOL
	oNQvJTxPCFY+C3fGg0o/ggJ+hr6fVHGmVH1yeVQC5yFYSGgsRau61FfjUzCgEbSdzxPcoVhKnfV
	TDjB98lZyDI0AAZEIN7hYZLkTlJuuZSHcLdGyDY4sNH1DF4/5/6My1kJ/8IjLyAMSdIX1x7Ip8Z
	AHOu/XKiuTnEyMn8tGKLGwN3zzvDRaPqqB70XynnwOwJlzAwK+OcmXJVakV/QFMr7eLRi4Hnyj4
	PXT9jN+IVBAPiJ9e0OMEOwZxbYN1GxSiJYoV2Z6fLYP56DbV4U5mTTPOSSqCDYFh0eTr1f2ezHi
	GFmivt9URKnCKtuftViXZy3FXiAPiaqOC8vVp+gr+ifhkBua563c64QgZVcgdtodtYU5C5oswQp
	obfk1IM/5tyKQj6vpvh4A0fbK+5R/j//xGtlVbv03XTxnGXOSJx+iDRJQSgIxQGoio/U+Q==
X-Received: by 2002:a05:701b:220a:b0:13e:5c8f:ff87 with SMTP id a92af1059eb24-146cfcdabe2mr2547964c88.23.1790398530493;
        Fri, 25 Sep 2026 21:55:30 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-145adcc5b00sm9334211c88.15.2026.09.25.21.55.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 21:55:30 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: Shuah Khan <shuah@kernel.org>
Cc: Matthias Goergens <matthias.goergens@gmail.com>,
	Minchan Kim <minchan@kernel.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [RFC PATCH v2 1/4] selftests: zram: track owned devices and report cleanup failures
Date: Sat, 26 Sep 2026 12:55:14 +0800
Message-ID: <20260926045517.3458413-2-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260926045517.3458413-1-matthias.goergens@gmail.com>
References: <20260926045517.3458413-1-matthias.goergens@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xuninf8ukcbeomm1zqttj4qdfu7egchz
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1497F180002
X-HE-Tag: 1790398531-36903
X-HE-Meta: U2FsdGVkX1/xIJXNwvxGJtAKvgbzw5d8y1N8mloEeQttFn0/SE/ZN0lrXg25jWmqEoUhbH0xSsQ0/34ZaffHDfpvEi/doZEfIxPd1xR2S+MWxrKziIQjCJ7LOcj5Zo+YEshJ2jMF76DtMNlZeODa2mjWrRR4+C9VNsozFxkmu2ESeELkmmw3CadHqdNRZYWa4q2wCgvDrxRd8x6gFZ6lO/Dx39b0tHyuVCXXflSqCMQ2uz4KwxfbKCRusbT6qz4uNNWOlsr35wrMQP33CjN4e1a67/fyx7xxMQ2l3MwjRWTHHAnprgUjdFqyVEDhoYpD2c4S584oqoalIiJjr2jkE+gfH5eZRf451Q2gfGdzULUu8mP3uuU3wnkMHScwItbjDH6+dAEVG0K291/MoJEbBf3MpbND2ATjyGgGTsseT2ixiaKtLsmthAY4gzJcHNa8VGieTzcxip9yZuBLCVDAS8DoCDV/gbs2UUEDXUoOG4Pk77Ud3U+Re29CMWWbh7xXRNmdT62lfPOyQTwpgd5Otj6lCRUT3x5OcpMrsUwLQhX21WFlobsrFtkJ9/vf1QLyVpVHJNtxESx0Z+QowJAQfjCa3zSNJIWuMKc4vvZ0O8kptageCPcQI5tuzwuODKvqOh/ebE0D20qHgh0qXZtW4zIFcl2qNj0CMC1cjFjvWj8g9LJl+114ptsXZLrLKmZgmIc2yfsCSQFq8ypVs1ChuANwLhYKaQGnZ2spZRDR4usNpeDgSOnkpGzKgSw9/0JU/56I47q7UUVbX0E6NJdtxTKa4zzJCaqALODHjYWPHCPBH6WG+IMxicVA0J2FMqvFiCLwxJO3GQAO1qG06DtXH0Qb0SCrc/Kfp6HmSzkPuPyLvOGqUO/Re5CgP1AX9Sg38F2PTlNl2Bm+BlR5RN0uP4iUrpKaO7ZzlV60LFkEohY/xi9/0RsaSrBrxs5iz+2aX2kh3BtWisYlQyKb8a2
 MuA5U4fW
 Pf+FWFJCUFTMYMlGyn7dFsi79MeD6KNwvfkLZP0LEcn8Bneq2l6bTCDcveih7OQzk30no4xbCVcNP63FzOe+kHe4CbpFPgSZGPbS+D+iaooH8j99G5okQRKzX90Q57pL8QPva4AoX5cr7oVmBKG/kVSRzklls/kPcGiODG80ix761tCVT4Sov5i1FVgl6corQx0q6gsliNTRb5lO+wiKKudPZMe2ycoAuAMcJjnqoqi7cSwhTnItWlRB51UvaaogU2h72UILd+dB/FdHuePqYFf3EQJbqCdUgXt4NfBEb/md+d/CO21L9u8NxYqnV6J9XNtb28g2R3P4gZRyWPKX0wATIBX3aixDXilNKUXyrfys8N0L6wwdC4BGM1J1e7F6lbyMs8iTPdKoW5yv9VGNLVXfj/DkK2fNxygQ0tDBXgXPetTmRw6i0vrrxRXoNfP418Fky40rcaSSUIw4kgkMcwoPhOT+hTluqqmygGXaalMvUfWgLqelLsBwGVT1caBI0nySzUFV62VRDLOJgY9+cXYpRi3O95M+Pj0UT90gXw5xyXbAVKd73kQwSS5DXArl6NVY2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

hot_add returns the lowest available device ID, which need not equal the
number of existing devices. With devices 0 and 2 present, the tests
allocate device 1 but configure and clean up device 2. Record the returned
IDs and successful swap and mount activations instead of assuming ranges.

Stop zram01 before filling after mount failure. Remove only directories
created for successful mounts, and preserve devices when swapoff or
unmount fails, avoiding deletion through a mount cleanup could not release.

Wait for udev probes before reset and removal: a worker holding the device
open can cause EBUSY. Bound these waits and treat timeouts as warnings,
since unrelated events can delay the global queue. Propagate actual
teardown errors while continuing cleanup of other devices. Preserve both
test results in the registered runner so zram02 cannot hide zram01 failure.

Propagate swap activation and swapoff errors to the test result.

Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
 tools/testing/selftests/zram/zram.sh     |   9 ++
 tools/testing/selftests/zram/zram01.sh   |   9 +-
 tools/testing/selftests/zram/zram02.sh   |   9 +-
 tools/testing/selftests/zram/zram_lib.sh | 161 ++++++++++++++++-------
 4 files changed, 136 insertions(+), 52 deletions(-)

diff --git a/tools/testing/selftests/zram/zram.sh b/tools/testing/selftests/zram/zram.sh
index b0b91d9b0dc2..b597cf186835 100755
--- a/tools/testing/selftests/zram/zram.sh
+++ b/tools/testing/selftests/zram/zram.sh
@@ -5,12 +5,21 @@ TCID="zram.sh"
 . ./zram_lib.sh
 
 run_zram () {
+local ret status
+
 echo "--------------------"
 echo "running zram tests"
 echo "--------------------"
 ./zram01.sh
+ret=$?
 echo ""
 ./zram02.sh
+status=$?
+if [ "$status" -ne 0 ] &&
+   { [ "$ret" -eq 0 ] || [ "$ret" -eq "$ksft_skip" ]; }; then
+	ret=$status
+fi
+return "$ret"
 }
 
 check_prereqs
diff --git a/tools/testing/selftests/zram/zram01.sh b/tools/testing/selftests/zram/zram01.sh
index 8f4affe34f3e..185f68471b7b 100755
--- a/tools/testing/selftests/zram/zram01.sh
+++ b/tools/testing/selftests/zram/zram01.sh
@@ -33,7 +33,7 @@ zram_algs="lzo"
 
 zram_fill_fs()
 {
-	for i in $(seq $dev_start $dev_end); do
+	for i in $dev_ids; do
 		echo "fill zram$i..."
 		local b=0
 		while [ true ]; do
@@ -57,19 +57,20 @@ zram_fill_fs()
 }
 
 check_prereqs
-zram_load
+zram_load || { zram_cleanup; exit 1; }
 zram_max_streams
 zram_compress_alg
 zram_set_disksizes
 zram_set_memlimit
 zram_makefs
-zram_mount
+zram_mount || { zram_cleanup; exit 1; }
 
 zram_fill_fs
-zram_cleanup
+zram_cleanup || ERR_CODE=1
 
 if [ $ERR_CODE -ne 0 ]; then
 	echo "$TCID : [FAIL]"
+	exit 1
 else
 	echo "$TCID : [PASS]"
 fi
diff --git a/tools/testing/selftests/zram/zram02.sh b/tools/testing/selftests/zram/zram02.sh
index 2418b0c4ed13..2420dda987d4 100755
--- a/tools/testing/selftests/zram/zram02.sh
+++ b/tools/testing/selftests/zram/zram02.sh
@@ -29,16 +29,17 @@ zram_sizes="1048576" # 1M
 zram_mem_limits="1M"
 
 check_prereqs
-zram_load
+zram_load || { zram_cleanup; exit 1; }
 zram_max_streams
 zram_set_disksizes
 zram_set_memlimit
-zram_makeswap
-zram_swapoff
-zram_cleanup
+zram_makeswap || ERR_CODE=1
+zram_swapoff || ERR_CODE=1
+zram_cleanup || ERR_CODE=1
 
 if [ $ERR_CODE -ne 0 ]; then
 	echo "$TCID : [FAIL]"
+	exit 1
 else
 	echo "$TCID : [PASS]"
 fi
diff --git a/tools/testing/selftests/zram/zram_lib.sh b/tools/testing/selftests/zram/zram_lib.sh
index 0d44d83888f9..4b134f70726d 100755
--- a/tools/testing/selftests/zram/zram_lib.sh
+++ b/tools/testing/selftests/zram/zram_lib.sh
@@ -5,10 +5,10 @@
 # Author: Alexey Kodanev <alexey.kodanev@oracle.com>
 # Modified: Naresh Kamboju <naresh.kamboju@linaro.org>
 
-dev_makeswap=-1
-dev_mounted=-1
-dev_start=0
-dev_end=-1
+# IDs returned by hot_add, in allocation order; old kernels use 0..dev_num-1.
+dev_ids=""
+dev_swap_ids=""
+dev_mount_ids=""
 module_load=-1
 sys_control=-1
 # Kselftest framework requirement - SKIP code is 4.
@@ -44,32 +44,72 @@ kernel_gte()
 	return 1
 }
 
+zram_wait_for_udev()
+{
+	# Probing triggered by device changes can still hold the device open.
+	# The queue is global; only the subsequent teardown can establish failure.
+	if command -v udevadm >/dev/null 2>&1; then
+		udevadm settle --timeout=5 ||
+			echo "udev queue did not settle; attempting cleanup" >&2
+	fi
+	return 0
+}
+
 zram_cleanup()
 {
 	echo "zram cleanup"
 	local i=
-	for i in $(seq $dev_start $dev_makeswap); do
-		swapoff /dev/zram$i
+	local ret=0
+	local busy_ids=""
+	for i in $dev_ids; do
+		case " $dev_swap_ids " in
+			*" $i "*) ;;
+			*)
+				# A signal can arrive after a helper activates swap but
+				# before its caller records the ID.
+				grep -q "^/dev/zram${i}[[:space:]]" /proc/swaps ||
+					continue
+				;;
+		esac
+		if ! swapoff /dev/zram$i; then
+			ret=1
+			busy_ids="$busy_ids $i"
+		fi
 	done
 
-	for i in $(seq $dev_start $dev_mounted); do
-		umount /dev/zram$i
+	for i in $dev_mount_ids; do
+		if ! umount /dev/zram$i; then
+			ret=1
+			busy_ids="$busy_ids $i"
+		fi
 	done
 
-	for i in $(seq $dev_start $dev_end); do
-		echo 1 > /sys/block/zram${i}/reset
-		rm -rf zram$i
+	zram_wait_for_udev
+	for i in $dev_ids; do
+		case " $busy_ids " in
+			*" $i "*) continue ;;
+		esac
+		echo 1 > /sys/block/zram${i}/reset || ret=1
+		case " $dev_mount_ids " in
+			*" $i "*) rmdir "zram$i" || ret=1 ;;
+		esac
 	done
+	# Reset emits another device-change event before removal.
+	zram_wait_for_udev
 
 	if [ $sys_control -eq 1 ]; then
-		for i in $(seq $dev_start $dev_end); do
-			echo $i > /sys/class/zram-control/hot_remove
+		for i in $dev_ids; do
+			case " $busy_ids " in
+				*" $i "*) continue ;;
+			esac
+			echo $i > /sys/class/zram-control/hot_remove || ret=1
 		done
 	fi
 
 	if [ $module_load -eq 1 ]; then
-		rmmod zram > /dev/null 2>&1
+		rmmod zram || ret=1
 	fi
+	return "$ret"
 }
 
 zram_load()
@@ -80,15 +120,23 @@ zram_load()
 	if [ -d "/sys/class/zram-control" ]; then
 		echo "zram modules already loaded, kernel supports" \
 			"zram-control interface"
-		dev_start=$(ls /dev/zram* | wc -w)
-		dev_end=$(($dev_start + $dev_num - 1))
 		sys_control=1
 
-		for i in $(seq $dev_start $dev_end); do
-			cat /sys/class/zram-control/hot_add > /dev/null
+		for i in $(seq 1 $dev_num); do
+			if ! id=$(cat /sys/class/zram-control/hot_add); then
+				echo "FAIL zram hot_add failed" >&2
+				return 1
+			fi
+			case "$id" in
+				''|*[!0-9]*)
+					echo "FAIL invalid zram hot_add ID: $id" >&2
+					return 1
+					;;
+			esac
+			dev_ids="$dev_ids $id"
 		done
 
-		echo "all zram devices (/dev/zram$dev_start~$dev_end" \
+		echo "all zram devices ($dev_ids)" \
 			"successfully created"
 		return 0
 	fi
@@ -112,8 +160,11 @@ zram_load()
 	fi
 
 	module_load=1
-	dev_end=$(($dev_num - 1))
-	echo "all zram devices (/dev/zram0~$dev_end) successfully created"
+	local last=$(($dev_num - 1))
+	for i in $(seq 0 $last); do
+		dev_ids="$dev_ids $i"
+	done
+	echo "all zram devices (/dev/zram0~$last) successfully created"
 }
 
 zram_max_streams()
@@ -127,8 +178,10 @@ zram_max_streams()
 		return 0
 	fi
 
-	local i=$dev_start
+	set -- $dev_ids
 	for max_s in $zram_max_streams; do
+		local i=$1
+		shift
 		local sys_path="/sys/block/zram${i}/max_comp_streams"
 		echo $max_s > $sys_path || \
 			echo "FAIL failed to set '$max_s' to $sys_path"
@@ -138,7 +191,6 @@ zram_max_streams()
 		[ "$max_s" -ne "$max_streams" ] && \
 			echo "FAIL can't set max_streams '$max_s', get $max_stream"
 
-		i=$(($i + 1))
 		echo "$sys_path = '$max_streams'"
 	done
 
@@ -149,15 +201,17 @@ zram_compress_alg()
 {
 	echo "test that we can set compression algorithm"
 
-	local i=$dev_start
+	set -- $dev_ids
+	local i=$1
 	local algs=$(cat /sys/block/zram${i}/comp_algorithm)
 	echo "supported algs: $algs"
 
 	for alg in $zram_algs; do
+		local i=$1
+		shift
 		local sys_path="/sys/block/zram${i}/comp_algorithm"
 		echo "$alg" >	$sys_path || \
 			echo "FAIL can't set '$alg' to $sys_path"
-		i=$(($i + 1))
 		echo "$sys_path = '$alg'"
 	done
 
@@ -167,13 +221,14 @@ zram_compress_alg()
 zram_set_disksizes()
 {
 	echo "set disk size to zram device(s)"
-	local i=$dev_start
+	set -- $dev_ids
 	for ds in $zram_sizes; do
+		local i=$1
+		shift
 		local sys_path="/sys/block/zram${i}/disksize"
 		echo "$ds" >	$sys_path || \
 			echo "FAIL can't set '$ds' to $sys_path"
 
-		i=$(($i + 1))
 		echo "$sys_path = '$ds'"
 	done
 
@@ -184,13 +239,14 @@ zram_set_memlimit()
 {
 	echo "set memory limit to zram device(s)"
 
-	local i=$dev_start
+	set -- $dev_ids
 	for ds in $zram_mem_limits; do
+		local i=$1
+		shift
 		local sys_path="/sys/block/zram${i}/mem_limit"
 		echo "$ds" >	$sys_path || \
 			echo "FAIL can't set '$ds' to $sys_path"
 
-		i=$(($i + 1))
 		echo "$sys_path = '$ds'"
 	done
 
@@ -200,46 +256,59 @@ zram_set_memlimit()
 zram_makeswap()
 {
 	echo "make swap with zram device(s)"
-	local i=$dev_start
-	for i in $(seq $dev_start $dev_end); do
+	local i
+	local ret=0
+	for i in $dev_ids; do
 		mkswap /dev/zram$i > err.log 2>&1
 		if [ $? -ne 0 ]; then
 			cat err.log
-			echo "FAIL mkswap /dev/zram$1 failed"
+			echo "FAIL mkswap /dev/zram$i failed"
+			ret=1
+			continue
 		fi
 
 		swapon /dev/zram$i > err.log 2>&1
 		if [ $? -ne 0 ]; then
 			cat err.log
-			echo "FAIL swapon /dev/zram$1 failed"
+			echo "FAIL swapon /dev/zram$i failed"
+			ret=1
+			continue
 		fi
 
 		echo "done with /dev/zram$i"
-		dev_makeswap=$i
+		dev_swap_ids="$dev_swap_ids $i"
 	done
 
-	echo "zram making zram mkswap and swapon: OK"
+	[ "$ret" -eq 0 ] && echo "zram making zram mkswap and swapon: OK"
+	return "$ret"
 }
 
 zram_swapoff()
 {
 	local i=
-	for i in $(seq $dev_start $dev_end); do
+	local failed_ids=""
+	local ret=0
+	for i in $dev_swap_ids; do
 		swapoff /dev/zram$i > err.log 2>&1
 		if [ $? -ne 0 ]; then
 			cat err.log
 			echo "FAIL swapoff /dev/zram$i failed"
+			ret=1
+			failed_ids="$failed_ids $i"
 		fi
 	done
-	dev_makeswap=-1
+	dev_swap_ids=$failed_ids
 
-	echo "zram swapoff: OK"
+	[ "$ret" -eq 0 ] && echo "zram swapoff: OK"
+	return "$ret"
 }
 
 zram_makefs()
 {
-	local i=$dev_start
+	set -- $dev_ids
 	for fs in $zram_filesystems; do
+		local i=$1
+		shift
 		# if requested fs not supported default it to ext2
 		which mkfs.$fs > /dev/null 2>&1 || fs=ext2
 
@@ -249,7 +318,6 @@ zram_makefs()
 			cat err.log
 			echo "FAIL failed to make $fs on /dev/zram$i"
 		fi
-		i=$(($i + 1))
 		echo "zram mkfs.$fs: OK"
 	done
 }
@@ -257,13 +325,18 @@ zram_makefs()
 zram_mount()
 {
 	local i=0
-	for i in $(seq $dev_start $dev_end); do
+	for i in $dev_ids; do
 		echo "mount /dev/zram$i"
-		mkdir zram$i
-		mount /dev/zram$i zram$i > /dev/null || \
+		mkdir "zram$i" || return 1
+		if mount /dev/zram$i "zram$i" > /dev/null; then
+			dev_mount_ids="$dev_mount_ids $i"
+		else
 			echo "FAIL mount /dev/zram$i failed"
-		dev_mounted=$i
+			rmdir "zram$i" || return 1
+			return 1
+		fi
 	done
 
 	echo "zram mount of zram device(s): OK"
+	return 0
 }
-- 
2.55.0


