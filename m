Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B33E2C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 09:56:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D61C06B0099; Tue,  8 Sep 2026 05:56:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D11296B009B; Tue,  8 Sep 2026 05:56:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD98C6B009E; Tue,  8 Sep 2026 05:56:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9390C6B0099
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 05:56:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2AA24804A4
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:56:00 +0000 (UTC)
X-FDA: 85190138880.03.EAF928D
Received: from out-2uec-a117.jellyfish.systems (out-2uec-a117.jellyfish.systems [63.250.43.117])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4AC77C0004
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 09:55:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=KM+HATLl;
	spf=pass (imf10.hostedemail.com: domain of hi@tychen.cc designates 63.250.43.117 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788861358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F3A3Ti8zHULaJXvRQhe+IOMxiiKMtUoHgOGnDhRSZ4A=;
	b=BLVtG2MDkNo6EUPe2HzfVVgRrU+rWY/eZk7wwGiD8A4W296xqK8s45AXzMVoWzMYBNchFj
	/+d3QXYNJ0FcejwtehQ/KSBoqb0vGpo9YHKliKftQixQ49zrBCZt1d/+LCpF+hMziaJaIX
	7ll8+jUKH8uRrotk7vWVGkgkq2psf4g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788861358;
	b=UbQDJUr6BjqLIVF2/6VofCGdhhwjdI0UmFx6kgCTmLD/kv3klgCzooiaeTUl1NbGcn0yix
	ZJ1rYjhMK4efpSu1Kn7EHF67Qo3LeaSTLWAOM4p/MUlyP267clghmzNP+GFAKwwP1BOjbX
	K9Dj3uS2CeB2UI20NcsKRpFdiHPFU6k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=tychen.cc header.s=spacemail header.b=KM+HATLl;
	spf=pass (imf10.hostedemail.com: domain of hi@tychen.cc designates 63.250.43.117 as permitted sender) smtp.mailfrom=hi@tychen.cc;
	dmarc=none
Received: from fedora (unknown [69.5.53.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.spacemail.com (Postfix) with ESMTPSA id 4hfK7p3czFz2xMb;
	Tue, 08 Sep 2026 09:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=tychen.cc;
	s=spacemail; t=1788861355;
	bh=F3A3Ti8zHULaJXvRQhe+IOMxiiKMtUoHgOGnDhRSZ4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KM+HATLl/00pp1TKFH+uuYnLDrMWkAQhZAz4OLB6hGUg/JZF04lHzvDhuT8w62o1b
	 wpYFKfZLv82MXPqka7i99mVNrSCM+WAKrzPdWu9EjoAXArubeRPSPKVPCIxiQ2bfYt
	 qHaVq/KoSiZ2F/JGwb+oAAylwdIZJm5TCk5ceCcCU+/MYa5gjpaFXQsjh6SrBWenSM
	 3v5iKsOb+LL/A4Q/AVnhEg0fHUuE0TBAqbGx4uoNx+id3l6O4KAYyFzWIrpPMOYWjC
	 puWR+mpAIflz0/mrPeOi3whEqXIUKorEty6qBzxx4KHni4kOgep7U2HqkG9KDz/t62
	 HhNugY2aKGL/g==
From: Tianyi Chen <hi@tychen.cc>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jsavitz@redhat.com,
	hi@tychen.cc
Subject: [PATCH v2 1/2] selftests/mm: Reject invalid test selections before running tests
Date: Tue,  8 Sep 2026 17:55:32 +0800
Message-ID: <178886112560.138404.14562368683011041790.mm-cli-v2-1@tychen.cc>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <178886112560.138404.1278745290043112298.mm-cli-v2-0@tychen.cc>
References: <20260906135444.749144-1-hi@tychen.cc> <178886112560.138404.1278745290043112298.mm-cli-v2-0@tychen.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Envelope-From: hi@tychen.cc
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4AC77C0004
X-Stat-Signature: bk8uu4bp71pr6ben5ffdfeeboupox17g
X-HE-Tag: 1788861358-428991
X-HE-Meta: U2FsdGVkX1+YUgiIgsAEdjwhNtSwUPa9M0g/WsyqC5Z48kVEE95G8RwnpgNK6yEAxmwxf3cTNFEsJYXw+3BLdRhcUevFhHVBPF+H6M8+WPs+ZTFP4FlR8E42YwicErwA20zcIbFOfbn/jjOZ1lBQTBB3Sv7HbuwwS00tCJiziV6rsap4p183dTG4XaQrkQ9Ht1HQHthgIFIKgxRtBjJ2CXp7WXOcdfhyXGmG3B9Y3qSIQRzfJ5y0BdAnTUC3/VQqlm7AhhPHBdI05GomdCSICwnYaK8RZL1Y9ZLkZ4FoZXXUKc6fu+5mV2zPJhl677w1fBLsMKfLqj7xSY4dpgGeWE1AHBYbigLWh0iMlRRBRIdewDyM1q8773lkuARJZlIk3iwAzpp041EQyNApcAqC7w2eBGk5PrZvp7DOs5VUjagQ+X8NYTBcrz7Mtt5X6OCChpzAAbe5bAnWPPvZ415WV7PvMZe2wi3rBmNDV+F2wc+OTg/Jrm6eddvF4Yx2B8He29V2+UXwEdkfQDBoCl3MUWtc8OOnDvj+pPDXed0Muf2ZDVUkb9cEFY2jGaDpyAZkBm3etVaHQwerxd3DOs6lEtvMXFPx1f1oXj6A2uAmQeBrSOjkEs2lq8ZFKlqXWLikAArA+bpNl1PogX5M0tA1LDioFUR+8e3f1jLBkXntWrIz8KF1szhXfpNhtccK1EprPVgko5x+sBgLZdle6QgBCxi7USu2ZZqgApB9mpstehR/3+3v1GREMWlGlnCZ0twR9e0HfRtrBKE+6MrblNMMaBzVpox/cVOTZ8h2UZtXnL5LbZGHBFbpIlT/E6IVILdaKuzRAVVMlsrlceMYBlf9GwLKWu3Bs6X0O7H1czRR8zEF7hxVb+j5xUj4GxWhjSglCefIAkZCoYy2jVnOCj6lQnTgkqEEC1JDp4ERmcZp3wx79ekqTPJc5Ib1qAIvrzzJzNls0L6gZoP8th5kJHW
 EUf5Ev7x
 w3R+BZAhy5bQsazuUesOc7QELHNlcGkj/7Wi8Eo9luQSJJ1un3xV0ukCGPvb7Ev53yTcve1Vvan8GOmjapDAvG4jS1d4DwSA/eYpc61niL9lPTyIDEPOYgbGDmmAYMtQSfWV5vEF81dJwx9QCLlGjp5qVg0StPe+mQvqgQHOufe3xqmmuPXpc9F+WFd+8YWtzybfs6UEJ8c9ronNIJd58UUfRZluc0ZmhUzxk9czBfb0XnjgxalsrEo0O1Tsu3/K7Uyupor9UBf0qdx8e+vht/MWbZ+Q/EfgYqoSAfLkO63P7VlVrkZbbnv1QfIUfCeer1LVwUzAu+cXq2zWaVWLZ/Fid/g==
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
agree. Keep the default selection for an unset or empty VM_SELFTEST_ITEMS
environment variable, and preserve the existing standalone default value.

Fixes: 85463321e726 ("selftests/vm: enable running select groups of tests")
Assisted-by: Codex:GPT-6
Signed-off-by: Tianyi Chen <hi@tychen.cc>
---
 tools/testing/selftests/mm/run_vmtests.sh | 27 +++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/mm/run_vmtests.sh b/tools/testing/selftests/mm/run_vmtests.sh
index d09f9f6a384..836c7454cba 100755
--- a/tools/testing/selftests/mm/run_vmtests.sh
+++ b/tools/testing/selftests/mm/run_vmtests.sh
@@ -96,26 +96,45 @@ separated by spaces:
 
 example: ./run_vmtests.sh -t "hmm mmap ksm"
 EOF
-	exit 0
 }
 
 RUN_ALL=false
 RUN_DESTRUCTIVE=false
 TAP_PREFIX="# "
 
+# An unset or empty environment selection keeps the default behavior.
+VM_SELFTEST_ITEMS=${VM_SELFTEST_ITEMS:-default}
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


