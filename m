Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B74D606A320
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 09:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=B/tIkVxi
Received: by kanga.kvack.org (Postfix)
	id 85B4D6B05B4; Wed, 18 Nov 2026 04:16:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65BBC6B05B6; Wed, 18 Nov 2026 04:16:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45AA56B05B9; Wed, 18 Nov 2026 04:16:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 035B56B05B6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 04:16:21 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8AB47806A8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:16:21 +0000 (UTC)
X-FDA: 85447683762.11.546D923
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf25.hostedemail.com (Postfix) with ESMTP id EE178A0006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:16:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="B/tIkVxi";
	spf=pass (imf25.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794993380;
	b=AkW90Ny2oEE634qrAYzsTUKUzy67SigdhvG4kIrBJ7cPBHoy8JJiV7smybj2JqK1wfcU0M
	z2FqiUz+CbVkMaVaLYQ8+fTdNP2wHJOp5dHB8BoeS6r9D9SwqMBFD2g8RLo9RGa58L5Lsf
	ZZA74LS7KXtUurz2zNCZlY40WWULxQQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="B/tIkVxi";
	spf=pass (imf25.hostedemail.com: domain of cp0613@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=cp0613@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794993380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cXMHSSOYVw74OronUDzpBoUxN/GzmRZG6et2woHsVBw=;
	b=XMw2se19sIS6TbKYZG6dQY5v2oaCvVj1rTfXbDIGVevc3P2jZoDZs4y/q4fYR6HC/WDbYg
	ZpGkPmqGmr9Yqb9DSgm7i70bJfcAxYWVAu1HzWgclgYPFPH+UKAEvTHBhH7N2Id8WkZauu
	HXszLjVxzZ60CI/KkjaXCqnZ46bTaco=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794993376; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=cXMHSSOYVw74OronUDzpBoUxN/GzmRZG6et2woHsVBw=;
	b=B/tIkVxivco22qOAJ+uM8H8SMeUQh9SHkWAz4hapVNxoA0Ua7SeQEPLIBdPszFTQgpEuSUu7hZOgANNVZ5jXcmZCcDJsWFYa07K06SqrF8yabCiMpVQHAOG0/CM7ux+OYSPVxnc4FW/O5c4nUT2lR6SZekhBnqOE846chNB82N4=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R691e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=14;SR=0;TI=SMTPD_---0XF0HHbl_1794993372;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0XF0HHbl_1794993372 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 18 Nov 2026 17:16:13 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	alex@ghiti.fr,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	graf@amazon.com,
	shuah@kernel.org
Cc: guoren@kernel.org,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	kexec@lists.infradead.org
Subject: [PATCH v4 2/4] riscv: Add support for KHO
Date: Wed, 18 Nov 2026 17:16:01 +0800
Message-ID: <20261118091603.979-3-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261118091603.979-1-cp0613@linux.alibaba.com>
References: <20261118091603.979-1-cp0613@linux.alibaba.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EE178A0006
X-Stat-Signature: hjshj44co4bfnc75wboz9j6tx14y6ihm
X-Rspamd-Server: rspam05
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794993378-698719
X-HE-Meta: U2FsdGVkX18bc75Z8ySLv1OYrxIOmnOTwQMGksgZUwxk1hsLCwcEzQNKgHVUA06HYjfSVcZ0ZyDyVchZocUiE67KZFcAO7dDB5+PdH16YPItPzsfUJPc8xpiaX9ZBgSUJmvpazTzf1SJ//5CARru74owdAIWfHQ6tysW2Z7UQlg90OTacDsXSOblGoSCvxuS3s/bm4A3cmoN1NdwobVVP4P1f4HUv91Jvwlf5c8SQGMQWb7UUvImYMvIII8v19VMuOaCEaVma1haQ3IvQteyT7BQ9qHKnlvEfZBV5DidpOnZhTX6H87zGTS76IAkso4mxCq4acKbtexMSuGpt4qWJFT/RNS6m+3SLidVQAAPcFJd/GOhiuLXTMB0XJhy4XBLMIWTfuFSnqwlL7wKThJlO6dKtYapB/9djm0t2IqrbfygvsI4QaOg9JQ+wHFUfm1uMzUgKvgKsVbAYhns1YP9akACGc4rW/ykOC2oZIRjs3D59oeuCehazCLSKRdKvKExMp8+CIifEcNqcQC1FYOGInR/il78bSyZC1j6Mc8zb7DHU1eqY9wFdU6dpF7i3jZ/4kZYZ8JXUk0D7enHPCXWRQg4s8pNZRVnrAccQIPCvjY4saqBxpueRd+6pprgMCrEysykcbUhXbH4WnA8iCorYjruFky7dXWMYGj5sFWueL7ej5EqS4Jo8uqiNHyJZWI9ccHOsewU6jQ1ZmxVEWkLRMAAyofe8ekpYs4IiATQUTtnVFuSgNPElwAJwZEWqTLDmsIbaE2UbD2zWItwAezTfkR4fno+Q7sXDo+puFlI29shgG8CbFNpwjSKNK34dUveAx4kssGpl3QCJGQKMvyFk7P+PCtiCOndc4S3XjATwfWwvwTWJJ27/z04XoJWEwLP0jnyUxX6pn6dLM5G2udV4lQKIkJCRAEu0xDoLpdoIeJPNdzAbCtp9Pb0hCJKCz8wtnGYxJpVR9QeqOtoeur
 5LwcZePU
 9qnmIYSLwjIA/bzUqhlezQ7qc298vBK5O3pLoXMVCfQ8cbPoWEZOffbuKmUTEOD9JPtx+yomYMLN+OzUekczleBYXy6dmEbuStdNqSSiOor/DROcdXH+OiH9Bz2AZBRIU9CLgev2DtHzoiqL+z+HXLchAlfilbNP+yE3+qHsHGn5FSRoOXcZNgzro9VcmVwzzDulgkIcCaHnJGfjSr/YT9kxsR1feLMi7Eljiw+pexZEqQvONoBmbXqNPtfNJ2E/KRcMniEKRfsJiYcYH0feOkCaheQyPJOGy7cB/8reDROpaoNcwEwIEAPsTOncLA67JvR4gDctQuUQ0krRIm8oyQmrDsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The generic kexec handover (KHO) paths are already in place on RISC-V:
the outgoing kernel publishes the handover FDT and the bootmem list in
/chosen of the DTB built by of_kexec_alloc_and_setup_fdt(), and the
incoming kernel picks both up while scanning that node. Only the
architecture symbol is missing.

Set it to 64BIT && MMU: ARCH_SUPPORTS_KEXEC_FILE is already 64BIT only,
and KEXEC_HANDOVER selects CMA, which depends on MMU.

Signed-off-by: Chen Pei <cp0613@linux.alibaba.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Paul Walmsley <pjw@kernel.org> # arch/riscv
---
 arch/riscv/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index bde1f1885038..bffef6b903e1 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -1125,6 +1125,9 @@ config ARCH_SELECTS_KEXEC_FILE
 config ARCH_SUPPORTS_KEXEC_PURGATORY
 	def_bool ARCH_SUPPORTS_KEXEC_FILE
 
+config ARCH_SUPPORTS_KEXEC_HANDOVER
+	def_bool 64BIT && MMU
+
 config ARCH_SUPPORTS_CRASH_DUMP
 	def_bool y
 
-- 
2.50.1


