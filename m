Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AADDD606A335
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 07:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=sa4fun2s
Received: by kanga.kvack.org (Postfix)
	id BE8666B05FB; Fri, 13 Nov 2026 02:23:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBFB86B05FF; Fri, 13 Nov 2026 02:23:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD6DF6B0601; Fri, 13 Nov 2026 02:23:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8CAB46B05FB
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:23:29 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BDC451A0465
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:23:28 +0000 (UTC)
X-FDA: 85429255296.02.468F543
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by imf19.hostedemail.com (Postfix) with ESMTP id DE14E1A0002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 07:23:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=sa4fun2s;
	spf=pass (imf19.hostedemail.com: domain of zhangchujun@cmss.chinamobile.com designates 111.22.67.139 as permitted sender) smtp.mailfrom=zhangchujun@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794554606;
	b=3rCkLCHdZ17dE2oOiHJEZw7n74T6Oc4wfJqX482bkgrbeDrsEAmMdlS1HuN4g801Gz4TdN
	LHYhBi2zFqrF1iNM6qZIPXNxWIa+nRPUHk8kZ9wNVPRqkmc7IABnyCytuVL3GvwlikWHuD
	98+xpv1ccbtCSBVtNyJeJsRGoth3VSg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=sa4fun2s;
	spf=pass (imf19.hostedemail.com: domain of zhangchujun@cmss.chinamobile.com designates 111.22.67.139 as permitted sender) smtp.mailfrom=zhangchujun@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794554606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NSvdMR5bdC0mD53YVwx+Xa6vtbAjmkknNO818XljrCU=;
	b=W4FwfU0gCXuSbcXZP/qMOQPzqHBCmBRFeBMA0Y8Sz6fP/feN9If+8wKH/JTMvGcoHm0axf
	RUsvS+ozGIMWqXHXfoKPrr+PIWkZEgSJUrq5P1a6zUNuhVTQpN3fshELANGJBNLS1oaQsS
	tS7LreIHXSgUytpIIAIqLraD/UZry9o=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=sa4fun2sOSH1mEAmixHIQZ3KOXxE71AcK9LfQ+DselMOwOsz1OJE1Q3kZD0hsIkonXZWTGXJLwg2s
	 U7ZITf914PPDRlX+WwQkuwBO/0aX9o4V+ngMYfsl4ZR8G29jY5NZV+/j0RGDNgWXJsTpIirkB274It
	 YHjUiiphg+S72cME=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app01-12001 (RichMail) with SMTP id 2ee16af6bae49f7-c4fda;
	Fri, 13 Nov 2026 15:23:17 +0800 (CST)
X-RM-TRANSID:2ee16af6bae49f7-c4fda
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from desktop-eb75daa8a6be458c-20260816004526035 (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr07-12007 (RichMail) with SMTP id 2ee76af6bae3ab4-1c302;
	Fri, 13 Nov 2026 15:23:17 +0800 (CST)
X-RM-TRANSID:2ee76af6bae3ab4-1c302
From: zhangchujun <zhangchujun@cmss.chinamobile.com>
To: kees@kernel.org,
	shuah@kernel.org
Cc: akpm@linux-foundation.org,
	richard.weiyang@gmail.com,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	zhangchujun <zhangchujun@cmss.chinamobile.com>
Subject: [PATCH] selftests/exec: check malloc() return in execveat concat()
Date: Fri, 13 Nov 2026 15:23:12 +0800
Message-ID: <20261113072313.1723-1-zhangchujun@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DE14E1A0002
X-Stat-Signature: kh63rz68c4eowwxc4coa7hz7em84uk3a
X-Rspam-User: 
X-HE-Tag: 1794554603-245294
X-HE-Meta: U2FsdGVkX19Fqir2M7uSbXGdbusD8gxjGm/FDK5KbGXAtrug1GCmqNf77rVsYqrM9sb1PcXD6X4U5UAwmjNz9Yq3lh2vIp/7+N4BiRM/LNHVIbBtCgrr/P2spvJHYooYRYmLCoejaCsYValWN3qRS6iZ+8UQI6zamvlXweEaGw+dxp+gLW8jz7Oz9WOIGoC9eREnrFsQj70ksC/xIKv1SKJpHbIFow8t7/sHKJ603M/DiX8C/m7LlHrV8Jz0tjvaR+tWd8O0Imc49UYYaX1aII2Tmfv4d/5lyF642UmpvataK9ssv2V086ijjpgVq0pz8JhkY/VsPfPBUHgaoJaf/iVL3GcyCbmFw/2x7zx7mcpYRUM9O+IzfVIlkbmZtA4yJGSMpdYal7FIcTClJZJ+V4+r7WXsamOP63j0p+f58MIC+eoPSNV+nk0x4hOP5SD5iokKITApIFDyeum6qf1lIGJ2y76+bPOl6OxHhncssgDfefOax2f/KdnAQkawiusgzqb4sAMUHOcNQiPAnnMKlT9J/A6CI1dNCGJc11vbZipngWiUOoH349zvcRYPLJ+uaza3q75JENkx/eI15N4/n7t8OJx6UxvWOp1oV02oazraxlzDFy5KGJ7+mAxOSDS7yJFHJxov5QRltVAL8GxKYs4Ee+a4HtVO3juhnk7Qr1UBdv/XCY41DYqsMvW/zT3VxRWWSlkeX3IMeCDs/VJ4B3qm1vXRPjxMbDLVAVMpMs3nQTYz4yCet5ll/5k9T1kK8Uc5KNQ+ELY9kXCaG+IrIPJ0MsfMe7L+vuWLrwyh56UmFx+GcXEO9fFrtAx86uaJEwa1mQwcGT4qSTb22J5LGne7GhBIlEyB+IdQj0RPjhqJAEosAGqh/OzC7ERTL8EqY23l0zAvwQE0h/TvhLe/e8I+o8BU2LWI6JK2d1ltW7wIVvC+AiQW0iUYcHCkJOuLXtdQ2CH2DHs9zfb0aL2
 SEUaAMpG
 7F6D6/7mTuuzFA4YmzfFlbbOtxlZ2ZtKJ7Kkjt0vx42ZP0w6GcZ0iCGgrlNqmGw4YX5iX5gWY1+FAEfGHvHKW2EaLMAgxZpBPX87/MS74JIUjP5YI3COYkdyUt9CGF23rCzJ/AdzWis2fLWPMnhCQWql7pWnjj3TS/DZRHx3uHkwnlUayL4hEOaTXMjtC3zzOt/7BjGMOud0LO3oRrQbTtlODCa/UGLBj8n+NwNI5abI+2klFtu/RTLOQeEfmZGvV6WZOir0P1IZdncTxOVACVy7LP0WbRzNwG52UWZa+aDEaF/fS5LTsXwhNKTGLWwJTMYQoSBwlmKPPtmD2EBeDLTwbkJxpQJ7S34l2DPngBMUASzunU1GKvywh3UgSiLpudeLS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

concat() strcpy()s into the buffer returned by malloc() without
checking it for NULL.  If the allocation fails, the helper
dereferences NULL and crashes the test.

Check the allocation and exit with a failure message via
ksft_exit_fail_msg(), which is how the file already reports
unrecoverable errors.

Signed-off-by: zhangchujun <zhangchujun@cmss.chinamobile.com>

diff --git a/tools/testing/selftests/exec/execveat.c b/tools/testing/selftests/exec/execveat.c
index d37c068ed5fe..b70844a7a13c 100644
--- a/tools/testing/selftests/exec/execveat.c
+++ b/tools/testing/selftests/exec/execveat.c
@@ -138,6 +138,8 @@ static char *concat(const char *left, const char *right)
 {
 	char *result = malloc(strlen(left) + strlen(right) + 1);
 
+	if (!result)
+		ksft_exit_fail_msg("malloc failed\n");
 	strcpy(result, left);
 	strcat(result, right);
 	return result;
-- 
2.50.1.windows.1




