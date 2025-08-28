Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 451FFCA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 07:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 941858E0019; Thu, 28 Aug 2025 03:35:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CA448E0001; Thu, 28 Aug 2025 03:35:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 792BB8E0019; Thu, 28 Aug 2025 03:35:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 62E1D8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 03:35:07 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 300CDC0A14
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:35:07 +0000 (UTC)
X-FDA: 83825355054.28.A0CE0AE
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id 79017140005
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:35:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SrnImVVI;
	spf=pass (imf23.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756366505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FwaUG2mqmSuw60xQO2PjnUcliyWKWlyIr1nprl+PudA=;
	b=nLZyb17xutlTG9VLYvzSaw2paY+3Zjw71b0/WpXIcHk1yPmimxmmXUesUsp4BD95O8iki1
	F8q0yGeXOD2xJ+Wlz5Gjq3GJ2ZRhQBFL1RX/QuTmAP2uwwq84ujjhEzFPX85vE+sbyAr/v
	XaPz70d/TJDfk5SqeFwI1K2ZWDZE6K0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756366505; a=rsa-sha256;
	cv=none;
	b=FIf9+To7/FKZ1B+bPfWk+KdfAXDFRUI/CFeK/U8BEJsjRCB75OZayFvGe5WhJKLA+VrCxV
	b0/ElLlSoWtvvX9PIAO8nB/ZyC0wc47uITxa5ZsDz9V/csSovN/NVeCnBdyx/6xkwkMry8
	Y3OnQ9ZXJMoWRm7erdINpttnAg73yBo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SrnImVVI;
	spf=pass (imf23.hostedemail.com: domain of wangjinchao600@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=wangjinchao600@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-771ff6f117aso637407b3a.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 00:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756366504; x=1756971304; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FwaUG2mqmSuw60xQO2PjnUcliyWKWlyIr1nprl+PudA=;
        b=SrnImVVIJ12SwIRCwiIftbg9vy0V+3IhwW+0BGxjIjpzzID9885mkJyR4vTu3FCjCo
         UCE7U5gWq0NaGlSGcTNSFsh1fgYP0Ncro+02eaIsXOlONabXEFgtQjR+IS9qlT3weplE
         aBngCzdGH4pqdmyrCNnyey3QSTyKCa0xSNZgr55TEPYzjSCedFeDTqdm9XUGBw7tj9Df
         sHhOpY9M0RAfNSB0JPflmc1vxr8xVzfwAeMy6XW1VxK55IlMCuzmpy/6jqqTUfxWHxxu
         0VpOMOpzbwd6/KBfBSxWt+lzVKObhNSIlVa+/HBkX4YBy+Ft6M63C66sBFW8o2FFL05o
         CuXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756366504; x=1756971304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FwaUG2mqmSuw60xQO2PjnUcliyWKWlyIr1nprl+PudA=;
        b=jJDJKfM4FK5z2pKyxOpvQQvVKdOa2sx7JNHtZQaqRD+TrIoLSbA34+8oalAQr5/wyf
         nqiNYfxVo88ly925u85Msclv2CrUl1UGRolZUvh6GwI+9HFGDyeyp3SFE1eOaply/21Z
         QhcbCebEkxQP/Do97zFEyzoTdAmjvZGZLlcDIqWcUXvTVuEB8T1SLUaAs5/CObHUArDf
         r+K4LdJ612W6EtgDhhgn2sQUs3Owy2S0HdNT2apo0PMUai6R57zBWjIFHi3KKVSCZVUo
         Z20zkLNvyZk2FczehOxNt+N4oZtKHnPNS3aGE4Qj7sJSee6EqIkJAf3AYENQATNNX+sq
         /v7w==
X-Forwarded-Encrypted: i=1; AJvYcCUa8HXWpv8s7vLLfQchXOBztHX6WeZtwfriDGMluYYNjdrtYAbtGmDghyo5zQLf9ypHCQn+U6Bkkg==@kvack.org
X-Gm-Message-State: AOJu0YzzeCSKMm+fEkodWU+qzX8+13FNFPXwEQyO1Ia5tlRnrt4g1KZc
	IkV/dJ4eazE4AEFKC8WcFkj0yU5z7qnmHIvitYPlbJ8tpHk6H1ATcfe1
X-Gm-Gg: ASbGncu9I63zkd6GALVEp6uCjNwWVaU34wGAS+MwuE5Ji0pvnKKpES5nKE8adQby0TW
	F0rrnZx6hSgvxaAeJqM3Ap2aJThaAJfKZ3HAFpnOsPQdzMGd6oS6Ro9JvSza3wFKu/HZg4B1Zs2
	aL8u+ZI37QvJIz4QBPeTYLIM6GSxyTnMpZaXcoiz5DKY4Zp0JO0t9VMbHIXNsStr5Tgqy2Loo1p
	P6tm0iUj8N9e/5JdkpZBxsR/t5EzYfYip5VBxxXpQxzf878CWoS28c4v3q7KmJ3gMIHFzB+wsZv
	UvLaBC7vphI/AOrGQAUuKcvpL1j4j4oJy0VdKoMEF5DDyDyE9QIFb/K1xT7HcO9/RjCTz9Tfe1c
	JqLoykW/8iWmddiojElIiQsZZk1TJocwMYAApEcA2hYIhlvSL7g==
X-Google-Smtp-Source: AGHT+IE7yqNI1wNfU3kqRgvdUB03Q+7fqxylivWelN8xwvP2fUBVMLhtkCKDyOOS3PYiCl6wvaTFUg==
X-Received: by 2002:a05:6a20:4325:b0:243:755:58b5 with SMTP id adf61e73a8af0-24340d920b2mr32588008637.54.1756366504311;
        Thu, 28 Aug 2025 00:35:04 -0700 (PDT)
Received: from localhost.localdomain ([103.88.46.62])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cb8afb7bsm13182613a12.16.2025.08.28.00.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 00:35:03 -0700 (PDT)
From: Jinchao Wang <wangjinchao600@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	"Naveen N . Rao" <naveen@kernel.org>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Jinchao Wang <wangjinchao600@gmail.com>
Subject: [PATCH 16/17] tools/kstackwatch: add interactive test script for KStackWatch
Date: Thu, 28 Aug 2025 15:32:49 +0800
Message-ID: <20250828073311.1116593-17-wangjinchao600@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250828073311.1116593-1-wangjinchao600@gmail.com>
References: <20250828073311.1116593-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 79017140005
X-Stat-Signature: f7hphfd7gm8mf38yw87dh4gnc1kdopkq
X-Rspam-User: 
X-HE-Tag: 1756366505-880577
X-HE-Meta: U2FsdGVkX1/nak/oK7Kane9n1ajhsGteTuz0XO+ZqL9g47IV3jVdReJ1z13smkrrpRbBGwszXuKJ/Oz4yTcfA0/feyP4NkOLHv6yQuBbeAlMMeyoU44Miv1FljfQ0h+uJ/Pr+UZ+tm0D+qbaFHpPMUdM5l2jyJpwpsaDnyO1u9M/fr2lFPIqzPCsShxMKoB3cQNoWdLtI5PK2/33mqESAd8DoC9L9R9wkFELVO2eZ6zo0OG68McDlqp9wWPiytb8ow7r8cxofPBm8jjuq6F33y5rLIQqXPzel1fVhVFTcZgr926rC6lMnNmPHE042FXIBpvSYjyFjFLQgaOn/X1awPB5dkB9i5J1Y4YvwK08Z2qtWSRGjvCubgEFtHklQfZma8A1msN4kVOZwrvaIAk1dDQ03JdsvPssYxH8R8o+pHefAn9bPRpncY3EzfzUMGlmHf6mvMTL51O80/HIi8nGSLN8bOBMSiAr32qOACnN0dYbC+mZAh3SNB3j6Sy9hTUks0hTTaw6TITv3Tua55DxA9nyLwXt5wT68gOoJrtvt62GrK5sqk8ah65ftgaqxw/qpK969z31vCXoF0CdVsjM2W+p8Jbm38cY3GmatsWqD5VJJEcTNv0x935Rs/ugOtzeef4CMR9gyiTonVmO9k/GIUTzhyq4e8p4NSmfJ8yQfFvkifC5QzF+6drHu9HZvm0sqCLFJI+9/FwtScCOAagXJAXvSegoWPUtaWUnfCwzRw/kD6N0Yq+72oxXo5Q3DBYpLgOIJlOOmttvFo2Vkke2EqXrxa+xmjKvcK5jkM6kqCsVcunHxi88Encsagq1Crzds6ChVQUz2saeJwvUFSDiLRaZji3X1fCD1+dmycPZn+1/OZIwrYFAIc6fxEa5nmtQo4/ZiJ2RT0b4dAsVCc67SWew3zJG7fG20xk+kngEIMfJ89IyJI+02yWqOFNoLZwxJtA1WT8razbSyvDY8Rm
 lClXgVIv
 Pkvqgp9ncAHHfg3FhtM75ITUFANsEVithwhcbom3bzaesndMMrG8xJVnAjw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce kstackwatch_test.sh, a shell script to facilitate running various
test scenarios interactively or via command-line arguments.

Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>
---
 tools/kstackwatch/kstackwatch_test.sh | 118 ++++++++++++++++++++++++++
 1 file changed, 118 insertions(+)
 create mode 100644 tools/kstackwatch/kstackwatch_test.sh

diff --git a/tools/kstackwatch/kstackwatch_test.sh b/tools/kstackwatch/kstackwatch_test.sh
new file mode 100644
index 000000000000..af0fbdb3a975
--- /dev/null
+++ b/tools/kstackwatch/kstackwatch_test.sh
@@ -0,0 +1,118 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0
+
+# --- Usage function ---
+usage() {
+	echo "======================================"
+	echo "  KStackWatch Test Script Usage"
+	echo "======================================"
+	echo ""
+	echo "IMPORTANT: Before running, make sure you have updated the offset values!"
+	echo ""
+	echo "To find your offsets, use objdump:"
+	echo "  objdump -S --disassemble=canary_test_write vmlinux"
+	echo ""
+	echo "Then search for your function names to find the instruction addresses."
+	echo "- Instruction offset: address relative to function's start"
+	echo "- Stack var offset: distance from stack base (%rbp) to the variable"
+	echo ""
+	echo "Usage: $0 [test_case_number]"
+	echo ""
+	echo "Available test cases:"
+	echo "  0  - Canary Write Test"
+	echo "  1  - Canary Overflow Test"
+	echo "  2  - Silient Corruption Test"
+	echo "  3  - Recursive Corruption Test"
+	echo ""
+	echo "======================================"
+	echo ""
+}
+
+# --- Interactive menu ---
+show_menu() {
+	echo "Select a test case to run:"
+	echo "  0) Canary Write Test"
+	echo "  1) Canary Overflow Test"
+	echo "  2) Silient Corruption Test"
+	echo "  3) Recursive Corruption Test"
+	echo "  q) Quit"
+	echo ""
+	echo "WARNING: Each test may cause system crash/hang!"
+	echo ""
+	read -p "Enter your choice [0-3/q]: " choice
+	echo ""
+
+	case "$choice" in
+	0) test0 ;;
+	1) test1 ;;
+	2) test2 ;;
+	3) test3 ;;
+	q | Q)
+		echo "Exiting..."
+		exit 0
+		;;
+	*)
+		echo "Invalid choice. Please try again."
+		echo ""
+		show_menu
+		;;
+	esac
+}
+
+# --- Test Case 0: Canary Write ---
+test0() {
+	echo "=== Running Test Case 0: Canary Write ==="
+	# function+instruction_off[+depth] [local_var_offset:local_var_len]
+	echo "canary_test_write+0x12" >/proc/kstackwatch
+	echo "test0" >/proc/kstackwatch_test
+	echo >/proc/kstackwatch
+}
+
+# --- Test Case 1: Canary Overflow ---
+test1() {
+	echo "=== Running Test Case 1: Canary Overflow ==="
+	# function+instruction_off[+depth] [local_var_offset:local_var_len]
+	echo "canary_test_overflow+0x12" >/proc/kstackwatch
+	echo "test1" >/proc/kstackwatch_test
+	echo >/proc/kstackwatch
+
+}
+
+# --- Test Case 2: Silient Corruption ---
+test2() {
+	echo "=== Running Test Case 2: Silient Corruption ==="
+	# function+instruction_off[+depth] [local_var_offset:local_var_len]
+	echo "silent_corruption_hapless+0x7f 0:8" >/proc/kstackwatch
+	echo "test2" >/proc/kstackwatch_test
+	echo >/proc/kstackwatch
+}
+
+# --- Test Case 3: Recursive Corruption ---
+test3() {
+	echo "=== Running Test Case 3: Recursive Corruption ==="
+	# function+instruction_off[+depth] [local_var_offset:local_var_len]
+	echo "recursive_corruption_test+0x1b+3 0:8" >/proc/kstackwatch
+	echo "test3" >/proc/kstackwatch_test
+	echo >/proc/kstackwatch
+}
+
+# --- Main ---
+if [ -z "$1" ]; then
+	usage
+	echo ""
+	show_menu
+else
+	case "$1" in
+	0) test0 ;;
+	1) test1 ;;
+	2) test2 ;;
+	3) test3 ;;
+	help | --help | -h) usage ;;
+	*)
+		echo "Error: Invalid argument '$1'"
+		echo ""
+		usage
+		exit 1
+		;;
+	esac
+fi
-- 
2.43.0


