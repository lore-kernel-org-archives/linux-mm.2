Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5920F531C2
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 18:29:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E69C26B0098; Mon, 13 Apr 2026 14:29:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E41886B0099; Mon, 13 Apr 2026 14:29:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D30746B009B; Mon, 13 Apr 2026 14:29:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C2AAC6B0098
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 14:29:26 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0C019139CB2
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:29:25 +0000 (UTC)
X-FDA: 84654370332.23.A26C050
Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	by imf25.hostedemail.com (Postfix) with ESMTP id 04577A0018
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 18:29:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=Qm0jaSwT;
	spf=pass (imf25.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.171.202.116 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776104964; a=rsa-sha256;
	cv=none;
	b=cfS3/57e+TleNF+QgWRy1MyAPMfFm2cIwhGiRLYQFKt4qMcMHitfOdtMwQi2Jlrzyxyhoi
	GpZZTxVuJenfPZGtV1SQ8Lj6ZzuiCxprS7l3X9g7Vy8zFYtNxILPBikHPHPprSSF7ypJHS
	bKVXkeunVtM+nzAaR3gjnfg8Pit9uzQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776104964;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nPa2ZZONaBOGLFMfEfBDzaDZgsD31jakJQraeqbgRCw=;
	b=isD2Rl4nrZ2/xV5IsXzdS5gItlg8skJdnYfGrtio+WQiXlpsf/s65ErA8DQyl6L8SMz2So
	qsY30KOkZee+3CXWgvQCZkpel3k2vwJtgVQZsBCwTXzXWPMWhcFm2gJOVHAeSUaaf5H8zN
	UlyrlCmotV++9DTLKcON4K2rnarWycI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bootlin.com header.s=dkim header.b=Qm0jaSwT;
	spf=pass (imf25.hostedemail.com: domain of alexis.lothore@bootlin.com designates 185.171.202.116 as permitted sender) smtp.mailfrom=alexis.lothore@bootlin.com;
	dmarc=pass (policy=reject) header.from=bootlin.com
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 792FDC5B1AD;
	Mon, 13 Apr 2026 18:29:59 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id C3B5B5FFB9;
	Mon, 13 Apr 2026 18:29:22 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 001941045055E;
	Mon, 13 Apr 2026 20:29:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1776104960; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references;
	bh=nPa2ZZONaBOGLFMfEfBDzaDZgsD31jakJQraeqbgRCw=;
	b=Qm0jaSwT24/GdK/EsyzadjCMRmdSwzojdFiBoEhz9mF9mr7uXKqUeMuFzrXmwZ8OzPseYj
	rTiosoU1qw/9rhsO2QAeObwHnb3U0BdA/GKu2X7zqF4XwbXU+sdENJYYJMHV+epMpE+WAE
	5wXX4mFLdnQpzrapducllk94LpMksGi5QQSsfjn+ECbIMOEFADC7qab70hxaKQz0r/EyiW
	+qT+y9jj+fwS4YIkWHcExGPabkcLddCDpfG8oxYqSCHg5OjMFegpaJ+esDIoGjiCGVX++x
	o1cerD3IbFhwDzv5lAIPNVJ37KUVFvTRPwtdsH6wD3ffqjvZudD30QIMdhw1KQ==
From: =?utf-8?q?Alexis_Lothor=C3=A9_=28eBPF_Foundation=29?= <alexis.lothore@bootlin.com>
Date: Mon, 13 Apr 2026 20:28:46 +0200
Subject: [PATCH RFC bpf-next 6/8] selftests/bpf: do not run verifier JIT
 tests when BPF_JIT_KASAN is enabled
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260413-kasan-v1-6-1a5831230821@bootlin.com>
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
In-Reply-To: <20260413-kasan-v1-0-1a5831230821@bootlin.com>
To: Alexei Starovoitov <ast@kernel.org>, 
 Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
 Martin KaFai Lau <martin.lau@linux.dev>, 
 Eduard Zingerman <eddyz87@gmail.com>, 
 Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
 Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
 John Fastabend <john.fastabend@gmail.com>, 
 "David S. Miller" <davem@davemloft.net>, David Ahern <dsahern@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Shuah Khan <shuah@kernel.org>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, 
 Alexandre Torgue <alexandre.torgue@foss.st.com>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: ebpf@linuxfoundation.org, 
 Bastien Curutchet <bastien.curutchet@bootlin.com>, 
 Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Xu Kuohai <xukuohai@huawei.com>, bpf@vger.kernel.org, 
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-arm-kernel@lists.infradead.org, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, 
 =?utf-8?q?Alexis_Lothor=C3=A9_=28eBPF_Foundation=29?= <alexis.lothore@bootlin.com>
X-Mailer: b4 0.15.1
X-Last-TLS-Session-Version: TLSv1.3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 04577A0018
X-Stat-Signature: jg7zm7sfsw3e69b8afksf4pdk9fizpy7
X-HE-Tag: 1776104963-453024
X-HE-Meta: U2FsdGVkX1/mBTWcFYtu8rPeL3ugVT9Rc3XPXGWYkMvm0Jdu01nE9oPH94vXrkpJwIOWWuPTLOkno13D9Pve6tl4c6yKWhSIdDQueUeb3h75NfbQjbB/KIsYH75nLZM9bYH/7UHaOgslu62s56CSjM0xerGETVZbPzcrk40gfNHiH173tfZZeCLKOgdDFVXoE4tJU2sVh3mXvHrGDr3uFWHZAesb/rb2BO4F29h/exopTtnMJQjnATj7JzblUds6VbLGW6VR1llcEbwwvMLnURnE7ILCkAh1zEqH1c28mfUBJq8tibLVM4Mq6u3JrB/IqXSbN4JAWK1IfN25g8xxS6NF4GHJM8tR3fEUIige/Xsv9z0VrzWqnceyUsoRDft6Vrtx7oddy6Qq2YoEX2sGkiVIhEC7apN5Hpr8SZvRhk/bV8vE6/UT6sb+PvAueWds8XL5bqdw5eEa2h5TOzWDpaJQvcq604YdhtDorNWiJA+VhFweNUxu+aFSs9pKuG9w5xe5HC9n8NhM/xg51YFD6l9F9mhUe+s56Ajylti19hWvhQboXgxB8zO1++SySLfvk8hjc6dGtrtS4uZ5r/eoPFPXSS3dJh+iiZn6fiCd4aYmAj6HP52t7cmBMrbKcVX4y6t92mJFPk7nWmWZWTWGjgY7JDSj7VNgtmghd75I4NM9BWdQv0CI3YOZ5ypwhWU5s/xH8vICFLZlFHYMLup4ameXSJXiYp333xUIrL7ZmXMyiwsfkx/4/vAK2BXBYeGkypEySakEZrLmFBvMbYMaBEfFdfDbMUmAQQ66+A5QEyM81QSkpoxWKozgYmvR5Lg2ZSTfWdlXkOXRuPHfG3o4X4qDqjAUxJoG7yIlPoZyWTXD6h9+nt1uGcrgCZGQFRS0cWhVxdDmlObankdEOtTgj308jSwqhuH1VqI/svy1RFY6b13lNJQt4EC0jGM0+ADi7s2zyE2PMp8ff40HQYm
 jroFSU0X
 mtvqwVRR0ROHCkAIJ8pMBhzJSO6SEt3YuIYPbclgTcJLFo8jBnitRon6UjUU2Q2XYoyUyvtPGOtfTqDXGKDMnkuXjgmJu2Rz7bdqw+taIlkrx9Sj/d62B4is6nCqHu3+wNRJN+i2jg3rwsGi8AWYmMDccmwVZmvBLo2ZsP18ebAAU+KWIe+VhP+tjmlsGkJ4TetEh7l+asQWiskZLvhSfRC46psrb/UPZKJhRAfO8eYoaTyxDzzxn/BPLhxBQb4JcubqiqjjlfcOfhqGo9d31wp03q6EImbAgycmUK4hofTQ7sDPaIAhIJvnmZWryXgtRh1SwgeHS7QNyh8GgNVtlRePoB7ht94PSnXXqsCSrvQcr5VF9b1ao/9zAqjGU/mQaRIkqle/fdzSV7xompTrrAv2VfLvvLChkOc43Hmrq2oRUedR1h3Zvg4Ujqcqisd6bTrQsbkkdDJ4CSvi0R+c5JqCbLyfE1YXPL+bx8Jo3sYhtGeB9/Ev5XRlljg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Multiple verifier tests validate the exact list of JITed instructions.
Even if the test offers some flexibility in its checks (eg: not
enforcing the first instruction to be verified right at the beginning of
jited code, but rather searching where the expected JIT instructions
could be located), it is confused by the new KASAN instrumentation JITed
in programs: this instrumentation can be inserted anywhere in-between
searched instructions, leading to test failures despite the correct
instructions being generated.

Prevent those failures by skipping tests involving JITed instructions
checks when kernel is built with KASAN _and_ JIT is enabled, as those
two conditions lead the JITed code to contains KASAN checks.

Signed-off-by: Alexis Lothoré (eBPF Foundation) <alexis.lothore@bootlin.com>
---
 tools/testing/selftests/bpf/test_loader.c    | 5 +++++
 tools/testing/selftests/bpf/unpriv_helpers.c | 5 +++++
 tools/testing/selftests/bpf/unpriv_helpers.h | 1 +
 3 files changed, 11 insertions(+)

diff --git a/tools/testing/selftests/bpf/test_loader.c b/tools/testing/selftests/bpf/test_loader.c
index c4c34cae6102..d2c0062ef31a 100644
--- a/tools/testing/selftests/bpf/test_loader.c
+++ b/tools/testing/selftests/bpf/test_loader.c
@@ -1175,6 +1175,11 @@ void run_subtest(struct test_loader *tester,
 		return;
 	}
 
+	if (is_jit_enabled() && subspec->jited.cnt && get_kasan_jit_enabled()) {
+		test__skip();
+		return;
+	}
+
 	if (unpriv) {
 		if (!can_execute_unpriv(tester, spec)) {
 			test__skip();
diff --git a/tools/testing/selftests/bpf/unpriv_helpers.c b/tools/testing/selftests/bpf/unpriv_helpers.c
index f997d7ec8fd0..25bd08648f5f 100644
--- a/tools/testing/selftests/bpf/unpriv_helpers.c
+++ b/tools/testing/selftests/bpf/unpriv_helpers.c
@@ -142,3 +142,8 @@ bool get_unpriv_disabled(void)
 	}
 	return mitigations_off;
 }
+
+bool get_kasan_jit_enabled(void)
+{
+	return config_contains("CONFIG_BPF_JIT_KASAN=y");
+}
diff --git a/tools/testing/selftests/bpf/unpriv_helpers.h b/tools/testing/selftests/bpf/unpriv_helpers.h
index 151f67329665..bc5f4c953c9d 100644
--- a/tools/testing/selftests/bpf/unpriv_helpers.h
+++ b/tools/testing/selftests/bpf/unpriv_helpers.h
@@ -5,3 +5,4 @@
 #define UNPRIV_SYSCTL "kernel/unprivileged_bpf_disabled"
 
 bool get_unpriv_disabled(void);
+bool get_kasan_jit_enabled(void);

-- 
2.53.0


