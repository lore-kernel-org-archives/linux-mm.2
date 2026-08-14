Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75CCCC5B572
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 23:52:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48E576B0727; Fri, 14 Aug 2026 19:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 465966B0729; Fri, 14 Aug 2026 19:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CED66B072A; Fri, 14 Aug 2026 19:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DB0EF6B0727
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 19:52:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5B31914028A
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:52:25 +0000 (UTC)
X-FDA: 85101526650.12.B1E50EB
Received: from mta0.migadu.com (out-112.mta0.migadu.com [91.218.175.112])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8DD74A0007
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 23:52:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hzjUZGZP;
	spf=pass (imf25.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.112 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786751543;
	b=U23+pg8rMIgMBpiDWgX0TJJ31dLZYJbvNIkQqOaF0IYy6nhRaIdqbBepoVaRnrmALdLz0Y
	/ikAYqrmt01U8uyqtQLGR1+/dUqtvUANtZEKtdhOgI0FG13KXoiXgfxWIBxFJBl/KaaJr0
	gaAF5UhmWimbEj9TNEg1bxxURxoNVoQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hzjUZGZP;
	spf=pass (imf25.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.112 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786751543;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=i7fjINI4wc6xnUuD3hs+PTYaqN/R0nnAWp1yQnMF40Q=;
	b=Xrh0zXbhuAmGD//OrqM1VlZH0DQN0c8/M6s44sXO07JsBfEMvxHK2Lk8KPCysxKA1uppUx
	Cems1L8ClsFqQy3JtZ8RzEqLTk8Y5Z7N9rfxiU1plrHkjPnT3l3dLd/h7XSWo4xrrndOoG
	/uoCel2KHLGH1o5x1hoN1J0zrjYCBRM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=yq/CIHMCUVnry977n31c6YewS1Nzi92h3o7DFyzp5zk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786751542; v=1; x=1787356342;
 b=hzjUZGZPgTDAYqCRp3nH7iE9jPdsDl3QlhgEDD9Wd+JdiOWbR5A520JOlrob9OcTPgNKNZC0
 6WH+vVIiBYo6u5ZmluHObwcQoJwU0glpCxkQNmr0UMr9lmtDYbOYZ92IFVfhG7Z5mVs2IdMowvW
 2MXvzMML6LkJBwx7esyHjIhI=
X-Envelope-To: linux-mm@kvack.org
Received: from isolodrai-fedora-MJ0FVMD1.thefacebook.com (2620:10d:c090:500::4:b8fe)
	by mta10.migadu.com with ESMTPS id dd5d91714fb7a918;
	Fri, 14 Aug 2026 23:52:12 +0000
X-Migadu-Flow: FLOW_OUT
From: Ihor Solodrai <ihor.solodrai@linux.dev>
To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ingo Molnar <mingo@redhat.com>,
	Thomas Gleixner <tglx@kernel.org>
Cc: Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"H . Peter Anvin" <hpa@zytor.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	bpf@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v2 0/5] x86/cpu: Refactor identify_cpu()
Date: Fri, 14 Aug 2026 16:51:29 -0700
Message-ID: <20260814235134.3461435-1-ihor.solodrai@linux.dev>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8DD74A0007
X-Rspam-User: 
X-Stat-Signature: p94dyrx95p7soe95ya3nc13kgh3yynsz
X-Rspamd-Server: rspam06
X-HE-Tag: 1786751543-306718
X-HE-Meta: U2FsdGVkX18Fej8dYhZeaxLE1w+wPDwtgpOYofE/XCgh++dBvJt0tiwgtqzG+TkWJ5cOx+31O/mp0Cd8vrzLmuOpqCY3yFVyM4BcOiJsZiN/0YfS/86NcaPiGfHYvfazIKMt3vzfnrkCeJXBQzP7Osyt36pEKJ6oMYgOLxyZ2OIlmv/bQtM3/ZtxnBoGVOHtM5OBZg1ON3yY7HaHg5uNcFFBS2hQSUOpYe3htUmeOvjbLkBctq/Yg/lr4rysapQmLpsIjcJS2kXdvHrek7I9p+6QKAAfIyH+KKv/PWGfoxRRpsO194TAQ7f/3LIU6TsRrW+u83oo0bjUUKQ1X0dRUs4Xl15aGS86bPUSxSh87icXLKqT4fasqsucylnqSJ/ICAVZYahasV1RFcHW+pFsx2Xoek11IK1tKMFzIs7hgOUi0feEsS0LYryOt+9XJX9r6s6lAO/SSSRSIt79r+CDW9aMN27v2Uf+ftIvaqh8qdNt5ENT7sK9NBTyb/vDjkLqFCqmJDOt8acSdGY2So2wx7fejRhjr5MvZwfYZFysd+ps03vsJvqG0z7MgpHb+JV7oJ/GwqU2IwiMpjQuK2RvdTsEveh9a/DiwZUguCvIHT+vzY8lf6erCFnb5slUpFF5a3f5JWkVNiLMBDijrtVjpHjVMGIxyId+/1saebW6jxShzAvp6H6tRVNeA7DR+U/bq4t/UI9EQTteY4T1iZ8s9T2Rl/lcyjAasQCRhioHt1IBC5jrqTsZXMZBq6u+vrhrnd5fLkMpzjeK8mH9LPFuvBw3/JZcWXb/CYseHYepAxrYZexkVErrAJwc9K/qxqZqJ8FZJ2xTLmE1V5geskKrUY/HA6GMH66nWUIu0tdKIe62elyWMX7ug++iKijFawrToRCy98nrCmMnpO/gNScY03850w2ot0ddmvzngTPt3qUWRA7Y8hY4Ap/9W14X5HKv8CJ72d9ps7wglSNEJjY
 jiILyAWH
 KIYU3UqNs7kGBMLcKhc/54kyxIzQcGtVAxPSV1yG+FT9cdjSvcSxHBLlyFwF5QAtztKxn1StsHK6EKUu+oKl9EP+tEcJSaqlNFDJQetkJdn6SQG3E1e0Yo9k4UpSu21gcmjiEp1lCN7EvFVHKWDp4RiBiN9Lr4NMstb/FPSsdaeZuO7XveMYiarnIafaf9jMHoGcRraU+4gdyalcXs5QlEksP5tQtAjmxlURdpduYiQgKUXARTfXIWmY2i/LRPWUFD1x30+NjdRqLq3NWbxonvYdBpHTqrppSDT0XYUjjNrs2Fy/ZC1FlLIY0cCq35jDHx0CgIr3LTAM0Bn77iQRkXmP8s6+k0xx/wJvTe41m0TWdJOD2tlLhVC35aA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series refactors identify_cpu() machinery on x86 and then
implements a fix for a bug when cpu capabilities are temporarily
cleared within an interruptable window. For more details and
discussion see the relevant bug report [1] and patch #5.

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>

[1] https://lore.kernel.org/bpf/20260610175651.647515-1-ihor.solodrai@linux.dev/

---

v1->v2:
  * Rewrite commit messages to fit more conventional structure (Boris)
  * Drop identify_cpu_32() helper, it's unnecessary (Boris)
  * New patch (#2): now early_identify_cpu() resets boot_cpu_data
    through init_cpu_info() as well
  * The boot CPU reset is now skipped on 32-bit too (sashiko)

v1: https://lore.kernel.org/bpf/20260704002046.3859585-1-ihor.solodrai@linux.dev/

---

Ihor Solodrai (5):
  x86/cpu: Factor init_cpu_info() out of identify_cpu()
  x86/cpu: Initialize boot CPU cpuinfo defaults early
  x86/cpu: Inline generic_identify() into identify_cpu()
  x86/cpu: Move 32-bit SEP setup into identify_cpu()
  x86/cpu: Don't transiently clear the boot CPU's capabilities

 arch/x86/kernel/cpu/common.c | 92 +++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 48 deletions(-)

base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
-- 
2.55.0


