Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AF8FC79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:57:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33A686B0092; Thu, 10 Sep 2026 08:57:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EB6B6B0093; Thu, 10 Sep 2026 08:57:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3456B0095; Thu, 10 Sep 2026 08:57:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E54AE6B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:57:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 58AAD1C250B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:57:03 +0000 (UTC)
X-FDA: 85197852726.22.E6DEF1D
Received: from mail-pj2-f1.google.com (mail-pj2-f1.google.com [74.125.227.129])
	by imf11.hostedemail.com (Postfix) with ESMTP id 86FAA40007
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:57:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AVRWZlZi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=diannaaav@gmail.com
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AVRWZlZi;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of diannaaav@gmail.com designates 74.125.227.129 as permitted sender) smtp.mailfrom=diannaaav@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789045021;
	b=lMaHOHBqlBoUPRC72wnAXNcZvPgnN5Y2hRbObOghaFD86dw6RexEx+mDUkfFyfHwsM2hvh
	a6pYC0ueThdYF8wVhwObc3hxLZ4uhPYQancRZbixpsTpGRYXgCGR/NYLM8wuHO4fAzH64u
	xQFv9fotvoJViXf8elUgyF7IGC1It94=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789045021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HVOi/Y3C1iRUwyA09cZKyOyweLLbf7+xSIA4QpyhUZQ=;
	b=a9QM8X8T6WGgmPyWcDrtJ8VkBThEG9EEb6MqxLCGuvB7ZgfZ80DLJq0MzNEJmfcCZ1d7Ji
	Vt8yWsYtVAUvh/GqbOIcC+E0izFw1V4p49IytPc8JRJ7t7wZWRc1sAWg6hVbg6jPERAaUT
	6vX74f9v6LNdHvUAQ53avHZs+OOF3EY=
Received: by mail-pj2-f1.google.com with SMTP id 98e67ed59e1d1-399213ef56cso3088783a91.1
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 05:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789045020; x=1789649820; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HVOi/Y3C1iRUwyA09cZKyOyweLLbf7+xSIA4QpyhUZQ=;
        b=AVRWZlZisJkGpZ2G5ddbDiJV+Ut9MIf5wk9CPuLLPASPbdlNrSYtNUVal+5pdH2cvJ
         1QT6EopfIzbvOvs1Fn01LnsJIiMq1rZIKSq+oQusQvpv3lzYhATVZFmhKXbzFets1Xu/
         ff1bmsHwNRCTVnEwZFzx9wqSSBsP7f/U0Qpo1puj/47DA3XhZS0E37bo6KMNyxLvaUot
         RqYArL7fHHZRrGqdPEV/jRsHokwViGKjiBov3x9jNUb171jINFS4eUP0MUjmvFxhTdGq
         JabVi9Iv57eGPOMi7jW3s1NA+HDapo3IJLRQaPSwTpY1ugDtF45nWSJ/cRTfYc4HATsX
         M5GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789045020; x=1789649820;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HVOi/Y3C1iRUwyA09cZKyOyweLLbf7+xSIA4QpyhUZQ=;
        b=Uq6c3kRO2/6KvLbY+AygJCd55JfqjTLsppRjFcruQ2lHLCVv+wNoh+hGTO+QR5HKlr
         XUzKD9gj6+azPFDCkhHarRpbDab9i2NLcWphEc/lCe2qSTeZmn1aVXw6eeUAjpSLvfPl
         8zQr6ofNdqhEttjWI3Q69csx7I4e2fS6LTDlt4XwyB9X+ZJeo0j96trOoNFvx/PCLYs/
         jYc9fhZJWI9XDCTv/0ci9cX87dXGH8XyTqHg8t9zrco9g2uw9mt1rcX1rsXvM3AUU6d+
         loHQ7FA+msuEKlwZZF6LBR2cPm9/E1b7B9oEtr08nukWJi5ZD/MMlOsydFMn77GOitjB
         vMmA==
X-Forwarded-Encrypted: i=1; AKwUvBzhQHtJzzJqfu4T+XbvPGCeitrr8qhk/7Tp24y3o5oR8Eg4aKMrX3CY8QKyo5o1aVH9IZpoh42kEw==@kvack.org
X-Gm-Message-State: AFuF++nKI37DXGpPgIigjWiGHYh9x1qrdfy2OOyH8Us4fGvwLAbVJJT/
	d5tJZoCQiCzl8cTDhJSjjqAbWge9mQdqQ8N+G1wZP9Qr/4BCgiwtCW3r
X-Gm-Gg: AYBFou13TclpNyhQMHoHSF+w3l7X/iEIIZ+gkWXLK8T1bYG4cq4nnU65GcS7XJBcmjA
	zPRewKvLMtf5tmiVpk4iSIFBsq6a4z2+rdAWBR03JD3A0sbgZm7+a89TEzu2LmYOZc1+if5QtJr
	6dSBZ6MDTso15LXCiCKUYgFi9XKjP1GxlNsBfzY4DU5SNsyLCEVdTRNePzVxjCF6nb3NEAWMj7Q
	H9Og+FhXg7otJmhbZTzdNBscbyxbWDX9Q25kdOgyEmP0voggtOe2p0LWoOa/b/FFcEbzd3VVKaC
	J2/J6bBFZ9fDK2DUsontTGEu67qcWsxMhCOxvthASYUg1B9XoEK7pTe6FnHh7oJq/50iwIUCSJm
	j7OEjXNhLGvVNKxhf1kkdrG/4xFARB4r8xAj0foNUegRz2Ou936rxgwoKn4rG21AcEE1KR3Ma6h
	gv0waXt+9hBPzd+Z274PoD0iurc7NCMqk4/LAU9nh+nzp9EkjbFGoyzVKAxUeBa83dV7Scpw==
X-Received: by 2002:a17:90b:4fc5:b0:37f:e1b6:4c7d with SMTP id 98e67ed59e1d1-39b26190c25mr61000735a91.6.1789045020263;
        Thu, 10 Sep 2026 05:57:00 -0700 (PDT)
Received: from fedora ([69.5.53.41])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d7e9014cbsm4800488a91.16.2026.09.10.05.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 05:56:59 -0700 (PDT)
From: Tianyi Chen <diannaaav@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Joel Savitz <jsavitz@redhat.com>
Subject: [PATCH v3 RESEND 1/2] selftests/mm: Reject invalid test selections before running tests
Date: Thu, 10 Sep 2026 20:56:44 +0800
Message-ID: <20260910125645.285866-2-diannaaav@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910125645.285866-1-diannaaav@gmail.com>
References: <20260910125645.285866-1-diannaaav@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 86FAA40007
X-Stat-Signature: hdz6wi63tuzp7kfjnf4yc3ag5xa8mhu7
X-Rspamd-Server: rspam01
X-HE-Tag: 1789045021-521218
X-HE-Meta: U2FsdGVkX19Q+lTN8TpoEnwoQbTQHcvNbxea4Ct+YIMQ7PhBWLKGHWk2dpwjPtBMD9CAPgAtBbwjXEOQ8lbvYaHcJXRKSzmH/cjGL9j82b0apWJKfrdITOADqqEzFlbBo4pZluatbeUYdvIE+dnF04mHGourIVIsniX4Spc3x9aun2QGubQORsr6k+I/fAY3fq8Bqg5IpCRTTJHecbdrBUst8bTe3mPpdeEEJqNq4x3z//C2Uyf0s1np/JmgNM4bJ/w3LAiHWi+mgzxWoM8hY9HeDFvy3XKOQPEJniVRhNjmGzgACpmo6+yn8AqCrvH0l/gky2ZmogxPtkkgLFmH1l/YSi3g/Fc7J5OqUzrAZJjq3L54v2YhLnku/Of6JD7teT4ZAzFFpYQUOf/N4listcKREsZ9ZzpIV0fiDifUN2IX7oklGbJ+Y6pwgBqtbeo52XmcPveg8G9NJ/OhDq2j2svrSheW1R7e6xAMmhZhQ1+Uf0izosOCvCFMbarWNA3neo6Ksya+eUIGKkQcBB+7QwZzyzbJ5Lq6R4dj5cv2mQfKItw+Ho8XLtdbzNjOwSbV+uBn3wIWFw7qKnxxHoVVgzyHHkKNcUNk5iroK44NiAKoKuRuF7FvT2BGiqIYYMjq1Ezkaps9Aof5rIZyksua0O5dNdnLD9Q4tPjukTBwPEhaqfJaIS0LJvaDYHYqh7T/52wQ6IPUR6E5UUyjIDT39gNdlr28qqFuPzwKssEyPdAosqGqLSd1+xLHJ0DPlOc18CaNJyZZeqjELB/oszEj6bmqbjppoE9jzKEKcNVlbYeyp2wX4UjuRuBlgwR3QDUAjOcULn62YnAFTtTddiqacuJLMtNVFonv2pHdlMycL8oppFpCyBQUKCzSEjvqW7W0l0K7hmtwPv97RyxKBMn+BSQFNbzAlHDN4TWAR/cmaXSxJnpnr0Hx+bFlXpbtSj5MLYqF92EVteOoa9KfqGC
 aw4W6N1O
 6HF6QDFhVtHRhjSISHboJACqhxUNuZjqg6THOKgntrunFMMR2Z5M/GpqvuRRO2SLaD82HgDjVM0CTD3k54hsDmbyH0d4pSFN/A7CHJNkNctpt0d8Hn/iYTOh4y4UsvnP1foJx2wjjL/NAa3Va6+T7fHTn3GozWerDZTki/LGADjH1NC9CFgNtWjwqUau5MHpf6LPqDPm23CBFCnVZPKidYv2iGGxr/QDC1OGodf6zl0TizIhARvWAevxXW23G9mo3ha4956l+/uVdy80C2ceYKFb+Ztw7SYaNU3e5wgOnCjt7YpX05dNsFjR2V6iCV+XNih/kAutse0ufSLX/8pMbjEd5szfIiM5q8U86xLggJEe59dl46eWR+A95rsMP5oodS2nr
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Tianyi Chen <hi@tychen.cc>

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
index d09f9f6a384e..9e62ab4c6775 100755
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


