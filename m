Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 021A7C61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 06:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B8656B0088; Wed, 26 Aug 2026 02:42:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96A2C6B008A; Wed, 26 Aug 2026 02:42:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87F546B008C; Wed, 26 Aug 2026 02:42:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 65B946B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 02:42:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4EC8F80299
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 06:42:48 +0000 (UTC)
X-FDA: 85142477616.09.3D769D7
Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7006B180003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 06:42:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=DHRKPQP4;
	spf=pass (imf16.hostedemail.com: domain of 2028566723@qq.com designates 162.62.57.137 as permitted sender) smtp.mailfrom=2028566723@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787726566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YUpYaXsq4mZSk10zKNzRlgByEYwJ8plN45XXrDI+0IM=;
	b=hiCECGiwhsK92Jz0qxG59s+mF8O2Zl7Jen2HJJLKwIJxb0j39KWz5YvtDhWfyLHAGGBNn2
	+6bgk3zXcSmtFQqmRYQ0FwRPFIZ5KvRpZUWAd/RilKL1KjLUwH6QCWd6BnfU9OEh1sXD2e
	qE/SIUe8LPpsjmRNU5V5Qx+qE8OEejI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787726566;
	b=MRLlNU8rn9HIqV6yoziKheURAX2Lx8YogWGRmXfW5lplYu/qVBod2ti7sO3treSx5maBgj
	WW804zrmK6bjDmu6jP3y8fuYQ6btl831Yn5SYF6C/Ubwi+K1+TuzKCV/ABpKemUMz21nRO
	K7W6hJvz41a3qA/3tfafYqgEeKbJ7cc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=qq.com header.s=s201512 header.b=DHRKPQP4;
	spf=pass (imf16.hostedemail.com: domain of 2028566723@qq.com designates 162.62.57.137 as permitted sender) smtp.mailfrom=2028566723@qq.com;
	dmarc=pass (policy=quarantine) header.from=qq.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1787726559; bh=YUpYaXsq4mZSk10zKNzRlgByEYwJ8plN45XXrDI+0IM=;
	h=From:To:Cc:Subject:Date;
	b=DHRKPQP4h9iIy7Foz44tzZCZDBF3rNx2fzBgmo4xmHrxVgegHSEEHmPNRVMRtKa+/
	 01Djao1np9BwikzUYzn1I4N5v8hvEs9T/QpvBo8Z3ASKuYGmQg3NOWesTp3NW8DL7X
	 x9oQmOAA/owL0OP8uXufUNhQvzjhiXVU15E5JZFc=
Received: from omarchy.tailf00a51.ts.net ([2001:da8:d800:b00c:4e1d:96ff:fef0:ed21])
	by newxmesmtplogicsvrszc50-0.qq.com (NewEsmtp) with SMTP
	id A9D8585A; Wed, 26 Aug 2026 14:42:29 +0800
X-QQ-mid: xmsmtpt1787726549t1igdanys
Message-ID: <tencent_E313247AB9048C22740CE2A4C1A9FB04070A@qq.com>
X-QQ-XMAILINFO: M1rD3f8svNzn45BTT3DW3UQls7PinerMEppsENTGy5OKbg8FQPM5cGJR7saNjy
	 HWIMBcrI7sb6yYYKzwf+sqzjSTitEPCBaMITHBDiU2xdhdHa9UiIgxCUkqH4dPqUC/GbKVWyjObr
	 oFVt0B8Fz664FWe8GhNkT44RKzvga2jTRixr+E+hWeeY5qCpoCyKbm4usJjCB45V8b6Wbtvq79Pl
	 GVDFW6VrMBv8cJ66Si+EUNiRnzVEvSFPlbalWGGrdoD3y5ERt5AcwAyd+iWyPzQt8OtywMkE8T+0
	 tRmkAgN1ZmJqm+X2Tv9832y9TYN5sMA/5WGLVKrIM1EcI/Kb3Kr23at1Xx+GDVw5982pmQc0mSim
	 Njrl8Q3L5Eo+S6yNcVm32mAU4wFY3Ow3M6cDEKoLWhPrhu/EhT17Ge2zMIaGaQtEsQMkSA8BEqrE
	 Y0gRxu5Hda/6Yx0Gq6Id+BwmfGJN2Tfa8Q0ZEXLWYrXpsMrsg0fu3Na4a1rQPBn20powol0WfvBt
	 JSf5dscQiDVcNI/TQCBTQTMkAapKhM/dYXhsul354d+GopEojv9p6Vi3wdJYqemXGfrsZ6AVLZ0r
	 e4CAHBu81klD8609VLR+D4SqmANQ3jtrW2mrkTdr4ZpAaR47ibAZi3xRg+APZCdjAicFe58ogq2r
	 DMltMS/24wxHlVh3v9K/EiAsT0BBc5qS1SrzLH3fJlMFIfvR8lnR132NJwvBLAJepDhoujzA/tBx
	 Qk+jIA9nM+iLnrXR0cIUs0YO3H8de3zEMtfWxeBt8vGh+V+NLYYjoMeDAyXzAQesxxaghOTgtBW8
	 Aa+UrzrdvX9NMd3UKsqRlT0D6YsDgYS3N6eCTfz/QV/Uw5ETuAP1r7nPyVAD6peTHkJorblSwqMf
	 qt7TVGPpfquFwtNrMPxLOn1GlcbuT5Kp1En3r+ygasyc40kZIloASN67tf7R73o98iTdzSTgh8Xn
	 WWfjKGWKDmv6X/aWpzBOmG66fcLK1akXN3aahLEI6MsC7dkV3GoF/ojKD0BEHH5evp6EC348bSCH
	 4tE+iTxO61lC7Z/SaAAKGwQO3jP1byWuoYwJvBaXrr5eKVeDuM
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
From: =?UTF-8?q?=E5=88=98=E6=80=9D=E5=AE=87?= <2028566723@qq.com>
To: kees@kernel.org,
	shuah@kernel.org
Cc: mic@digikod.net,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	2028566723@qq.com
Subject: [PATCH] selftests/exec: Fix check-exec-tests.sh with O=
Date: Wed, 26 Aug 2026 14:42:28 +0800
X-OQ-MSGID: <20260826064228.67490-1-2028566723@qq.com>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rdeea51qxhjdpreoxx8d5p1bd8mj77ct
X-Rspamd-Queue-Id: 7006B180003
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1787726564-154030
X-HE-Meta: U2FsdGVkX1+z6n71owYfTHeOB4KkjwobBMJjEHZAUzI2hgWeJfApm29/RsGAbRsKpTd7XlaIrqEJ+T2mbp66Zdhal4pwo0nrEH/nqNb6QKWDno/IikfT1q/LTvN8ELxq+j5TIqdC17qZvW1zeVzr0EXEtGuuzzRWcWsY7/0WCs5Auv9yEoNdE/Fn9YhhjuA5MvtL3jilGUiq3s6pxwXMZRNaqaImeFyi2qnuaYAnPod9uYIR2SDPkRU0fDRtC5m8i6heZwg0vAxrMhai6p1Xdv5m6WC4uVUdAZmBNa5SBaMri23c5U5aptj9a7gQjwPZGXRui2bDsuuaRQbGZ5A2VcQ+A0NwsPkPnJcuHWLhPkNjdOl+3UcGLUOkaoAgY/VEm80TtwWNBSOEyc7/QGcpzU8lmqONPwfBLexMXBxmCD7/6aadmWQrN+IBaARQU9JwhZe099oDcBf5zHBfDpGOtsYqjpWRwBNHvDReXHpH6cdh8FsKap5VL3WQt715TFOQMX32x6+hyV1f4ge/Z7P4DE2nkx9H7XM3m9J6166SqCLhRozSJvR61M2vR4EVN+OdhXrA5AHdX18iPVk34Tg4eaz/LneoznrKoNqlSTDFIdQewOP3f8rRJUIrLwNlpJsKyzkbBdOXvPWskrJChkv2IK9bng4kU+D6ojPSkv0Nsui24rOb+hCqKs5UYjB46DkW3apKI6ceKSjAeaqdxm1jpZVxi6SRlDK5pDlFYETUNoC0wyWLkOGIe/ZNXOiTSNMODDA4oyUwAmQ2JG7TZ1xM3cSLqkgwFZ58MzBOFQmV6UAiGgvRN2cviclHsw7AAql6xvF4yJEy2E1GkskOnMIZE5AJvUoGodwS/spZXozjrPWpujoNQTgPybibnKH/fmyVrRdWba38yCDeyFe7cvqYSVeCO6rKEteczJdnzF4YjTDgTSf1ThNqwnQloia84MpAeyxOpSgSfUTHv856to5
 6VHzK1oA
 skpqiaN8QGoR/jZEYuFrjAjioSziSyulw+ShGXcb4e6UxyXpt23/A1NGznrFk2DHYnCMmIj5/V+VpFkMltR3Zc+0yoFEBRIHkV7bhh3Ma8GTLGv8XEvVusZ9jP04F0XkXQv7TiyKaqR9bbBDKJ4o7dtPnUVG6LbcEd3GAiBS43mqFCTWLoueqrdJhMJ8xFh6JSYvTJ5zDNd4v+0YCfGVPpFl/NtJ6nFk6IJDmepd9IyhFN4Y4gAt/EjGDkpt9eL4x6NLz3wgnRfKZz8ncAcW5GpBRPG2hosnLcRmRyW2PJouSP93vG44QiQh95w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When running the exec selftests out-of-tree with O=,
check-exec-tests.sh is copied to the output directory without its
ktap_helpers.sh dependency. The script therefore fails to source the
helper and exits before emitting TAP output.

Add ktap_helpers.sh to TEST_INCLUDES so lib.mk copies it to the
out-of-tree layout.

Fixes: 2a69962be4a7 ("samples/check-exec: Add an enlighten "inc" interpreter and 28 tests")
Signed-off-by: 刘思宇 <2028566723@qq.com>
---
 tools/testing/selftests/exec/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/exec/Makefile b/tools/testing/selftests/exec/Makefile
index b640af8f02b5..d16ad3d32770 100644
--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -16,6 +16,7 @@ TEST_GEN_PROGS_EXTENDED := false inc set-exec script-exec.inc script-noexec.inc
 TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir
 # Makefile is a run-time dependency, since it's accessed by the execveat test
 TEST_FILES := Makefile
+TEST_INCLUDES := ../kselftest/ktap_helpers.sh
 
 TEST_GEN_PROGS += recursion-depth
 TEST_GEN_PROGS += null-argv

base-commit: 45c13f3f9e3bb15fd89ff2864c6f627a3b4b4229
-- 
2.55.0


