Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4948CC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:36:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 609966B0096; Tue,  8 Sep 2026 07:36:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BA1C6B0098; Tue,  8 Sep 2026 07:36:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CF2E6B0099; Tue,  8 Sep 2026 07:36:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 301726B0096
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:36:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BD6F112051C
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:36:48 +0000 (UTC)
X-FDA: 85190392896.10.1BA9C40
Received: from out-utut-a203.jellyfish.systems (out-utut-a203.jellyfish.systems [198.177.127.203])
	by imf06.hostedemail.com (Postfix) with ESMTP id EA2BC180002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:36:46 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=gJYWApL4;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of hi@tychen.cc designates 198.177.127.203 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788867407;
	b=mPr+evAfB/qmFDm9OqEPcjoyLQMrTT9Ba6X9s6k3ZFoE1yTQOYLvz9HmIOrwhxat/ZW8bM
	0QQE9+cuRNmtHY6ZAfmNUAMTG06qilGc1WdZ2hgLDvatRDzT36N41rjFBZlH3JenHrbuWW
	DPAMm6Wc8NGu79B0VxIi8CAxQ8BBLqY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=gJYWApL4;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of hi@tychen.cc designates 198.177.127.203 as permitted sender) smtp.mailfrom=hi@tychen.cc
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788867407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fowGtSo4keHEiT0zYg4Pfeko5C54sCJezMZYgct1Re0=;
	b=2agKqGA9FAL1/SDWQrx12JI3A0FIayzR3WhngNtjpcQH2ejgBHaqOSJ+sWqIJgauopruEG
	0+uFCoTk9jpoJEJ/xNNvK3qq8SZbfj3j+ZaSoK2VzTYROqZDjfZpX2w7drd7HCaCvB8gSE
	Bc57iSWD3CCfolj8orlK68GsExtF5qg=
Received: from fedora (unknown [69.5.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hfMN34TN0z2xTM;
	Tue, 08 Sep 2026 11:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788867398;
	bh=fowGtSo4keHEiT0zYg4Pfeko5C54sCJezMZYgct1Re0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gJYWApL4OND87Vj5o9dvBAD1fichjnhyJVB4V5/cNG0mGKeJDQObGBSrh+PwthyRz
	 a1S2KHSFYEUIBTBnenmV0w6wGXSRrc7PK0Fy+RR3kppjOTOCKpr0s/9sqylGDV1PbU
	 JSkilBHDXThFMWva4DF4PZp1FEYABJpTwjnmXS20WFVgrEcD1WYcYFAGxXGDkh0Vm3
	 ZMNAXmCs1EKY2NCd7IX3pLr8Qnb/bFf1ep6RErPZ3bQ68tLHBZ4f1q5r3gxUKm1xIx
	 WoI4RLv53+B72qF349l/ci9j7khFd3KaZq7lYjIXHHz6G6aTlgNIgoO43XG4J8sphu
	 OUHuiPIyvhAPw==
From: Tianyi Chen <hi@tychen.cc>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jsavitz@redhat.com,
	hi@tychen.cc
Subject: [PATCH v3 1/2] selftests/mm: Reject invalid test selections before running tests
Date: Tue,  8 Sep 2026 19:36:24 +0800
Message-ID: <178886723357.170332.5955105537334716651.mm-cli-v3-1@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <178886714088.169611.14957244271354428473.mm-cli-v3-0@tychen.cc>
References: <178886714088.169611.14957244271354428473.mm-cli-v3-0@tychen.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EA2BC180002
X-Stat-Signature: kbz6b4swwp94bcisrr6eq8s8x5i4boqn
X-HE-Tag: 1788867406-967373
X-HE-Meta: U2FsdGVkX19Kq47h9MWFrx91H2pogUKR7jYnH+2SmvAD7odB0uttbGNqrFD7Zr1F0j4PwMxZD6f1p7mpJCdosJW8LVvCP3j1VukiTvfBs3ih65TRfYcVhMifR7jmthiCi5JC7R2wRQaZz+Kf47+r2nugnFm9LJ8Yuw8BUrnuboZ7dootmENV+bmhCVXVEZE84UdaR3sBQr9H4B1eT5YouRgPEhv4EySkHkSyQgkJnm8drRNkqViow8ZIAOTUgYbhA6D6SVSz39okj2RK6FxgdvlKn/ZXOSnNWzk/PEIMvXuPaIHMn/v1C4lePwO62yorazWcsmnDJHBUxJQy4SsSdPEZZk2U5iOFXp4e1CK6Cjm6rqB1CPARAGf513v+BPDBZXJUh4n8M2Uux0FxOhkTTABoV+x/Waync88JhhSNEut9zVqfcIA0tZYNCVR+2ZAKORy88pVC8msFgH1vcD+/3U8BS+VW/VA/TPqyL+aM72s5ueUEXsUktqQuHGoi19zAxP0Z/B2vOdoWUotokwBKkTC9jjIK3IQ1r+ffdN6TsLZly3IfjepffU7NXjkTU6LV/7D7eQKpWHhYxSTTwktfCEQS7fUcjIX5ytof7iq2sd+f2gKG6m1Gb2pn9xHygE8iK78n28TJ/WBkbt35luryMfkPd38qKCKRqVoCLo0h6tuari3EwS8D6BtzEq8txO8fgtmtXYb8WslavhpuEJhF7hofSXRdtPiiS3Raipq9O5/z+7vPcQRG3tvyCZ+v3NUBcggLp3Wb0c9g6qz5TFtYKuFZsIda5NbjGiE9sJU5hh7Tm/kQWdx/RxwKj0Bl9f4F93boI9uVj8r2fJdDVVzBcLYHo3kbD4REeorLKa0sqslnJCHAeRyCZ4l1XbqS8Zg/ouX54NDb3XczxqnxKiiTtFrEgAWkvkXMMlB/AsBQSJ2NvDl8waiID8y8NvcCvhjCBA/8e9W4N0FqXAgIbJQ
 Zga0PeIH
 TTY+Z4Iljk2GjAVZ9lJk1GIOuJEOPTovexFyhqhWingZO/NUd6rcDnQ4LpBaYyI4qq4udrIprrRaRW3rELGPDUf/+Nd3JW3Q89xSoX8ZABqrB68RGhRIz0cS3G/XAI5+ixRjuSCZ5vwG20dlvQpUi57tP9RLxN0DTODCZ7dnE3UXJDBiSy9IEpZXMRvvCIkHzBEh+uIncNbtRr5gRIVslz+aqS86nih9MVmYClnk6GmtDguoYph0MVPHvdEUIs2ozsaQp63HaQpmFB2j6AH5kk7usuu1MQsrA2q1V8YsUkhQ8QHh6lF4GQ7w5vy9xiWxvac0S67COVatZtMnQbbDwYw5r8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

getopts reports unknown options and missing arguments, but run_vmtests.sh
ignores its error result and continues with test setup. An empty -t
argument also falls back to the default selection, while unknown category
names can silently select no tests and still reach setup code.

Exit on getopts errors and validate category names against the existing
list in usage() before any test setup. Reject empty and whitespace-only
selections, and normalize category separators so validation and execution
agree. Initialize the default selection before parsing options so only -t
changes the selection.

Fixes: 85463321e726 ("selftests/vm: enable running select groups of tests")
Assisted-by: LLM
Signed-off-by: Tianyi Chen <hi@tychen.cc>
---
 tools/testing/selftests/mm/run_vmtests.sh | 26 +++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d09f9f6a384..9e62ab4c677 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -96,26 +96,44 @@ separated by spaces:
 
 example: ./run_vmtests.sh -t "hmm mmap ksm"
 EOF
-	exit 0
 }
 
 RUN_ALL=false
 RUN_DESTRUCTIVE=false
 TAP_PREFIX="# "
 
+VM_SELFTEST_ITEMS="default"
+
 while getopts "aht:nd" OPT; do
 	case ${OPT} in
 		"a") RUN_ALL=true ;;
-		"h") usage ;;
+		"h") usage; exit 0 ;;
 		"t") VM_SELFTEST_ITEMS=${OPTARG} ;;
 		"n") TAP_PREFIX= ;;
 		"d") RUN_DESTRUCTIVE=true ;;
+		"?") exit 1 ;;
 	esac
 done
 shift $((OPTIND -1))
 
-# default behavior: run all tests
-VM_SELFTEST_ITEMS=${VM_SELFTEST_ITEMS:-default}
+# Normalize whitespace so validation and test_selected() use the same names.
+read -r -a selected_categories <<< "${VM_SELFTEST_ITEMS//$'\n'/ }"
+VM_SELFTEST_ITEMS="${selected_categories[*]}"
+if [ -z "$VM_SELFTEST_ITEMS" ]; then
+	echo "No test categories specified" >&2
+	exit 1
+fi
+
+if [ "$VM_SELFTEST_ITEMS" != "default" ]; then
+	# Keep the documented category list as the source of valid names.
+	valid_categories=$(usage | sed -n 's/^- //p')
+	for category in "${selected_categories[@]}"; do
+		if ! grep -Fxq -- "$category" <<< "$valid_categories"; then
+			echo "Unknown test category: $category" >&2
+			exit 1
+		fi
+	done
+fi
 
 test_selected() {
 	if [ "$VM_SELFTEST_ITEMS" == "default" ]; then
-- 
2.55.0


