Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7137C982C1
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 19:52:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C266F6B008C; Wed, 16 Sep 2026 15:52:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C03A66B0092; Wed, 16 Sep 2026 15:52:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B139A6B0093; Wed, 16 Sep 2026 15:52:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8D01C6B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 15:52:24 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 67C2040129
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:52:22 +0000 (UTC)
X-FDA: 85220672124.19.9F73D62
Received: from mta0.migadu.com (out-132.mta0.migadu.com [91.218.175.132])
	by imf27.hostedemail.com (Postfix) with ESMTP id 429EF40007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:52:19 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XMppVooG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.132 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789588340;
	b=FMC6qcQ7bG3IpPC8o+bQGhIIsUCCSdaBO0eC3xMSwcR1hS7wdFFuPaHwNu3a+zYA+DC5rY
	QKJdP4JUhJ5pD+5R8bAMh7KuJOACeRT0ep7yPF4HfMjLJKHsaRolZPjr08ZAy/8tFy6Qtm
	C9ERlFzUdPzW6bW1boDr224Qj9ONbrU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XMppVooG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.132 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789588340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=qEXxE05Vz1mECyjiG7H7QDpx4t4bDBPJ33j6bu8Ell4=;
	b=FdWU2J/VPzzFfZKIoW63N9IxAOUD8d37HpK8QJ5+o+V5/y/8myrNEX2NoZwia3xT8yVxCX
	HotBiRa8fLTPGaFAxbi5BCFTHncasw1sJMi6WpArWLFAZvy39G5DnWN0oL8iXpN+OdFklM
	UoPyxw4BVMLORiGCcEnOmhOTy30WuX4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Cv6+EnHKlYEyrsTw5T5FznzsOfb6ghBGEkt+na9dBSs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789588338; v=1; x=1790193138;
 b=XMppVooGzETU8jB9YgblebsaikTyq9/mfrvN1CpRFTHD/1I4m7ceHY5qDGIRkRlGrgIuA1OI
 YfSORek/3tA26COB9UmrBfsW7XU8Qq5jOyy+KqHtLjoqOT16ndtjzUv7yfFN1Xzrf8sX7WHCKWI
 mFq48q1kCyoKsGvkTDM4nQKQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id a27f0a83e7a07625;
	Wed, 16 Sep 2026 19:52:18 +0000
X-Mizu-Trace-ID: a27f0a83e7a07625
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
Subject: [PATCH v3 0/5] x86/cpu: Refactor identify_cpu()
Date: Wed, 16 Sep 2026 12:51:58 -0700
Message-ID: <20260916195203.1099646-1-ihor.solodrai@linux.dev>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 429EF40007
X-Stat-Signature: cfefppweykoxhgqm5x8abhypqr8zozds
X-HE-Tag: 1789588339-495154
X-HE-Meta: U2FsdGVkX182JZkaakwXPfW4qExqNWGDXZXs0yxRdu7dQAoZTviYq/ENQkUkIgxnDDkpFEk29YM2mClL6D5pMrQC6AnCF2wdiTsqVR6br5kF8Uyo6E0JnjfYJcsQjdHULu+DG33Ky2IQ9ZiIjPKMQhN7YpApHn1IUlqd/Sxo3a/dg/sW2UFwwfwTP7QrE2pNJO+J1IexJM45QyZvWlxEm1tkphO6/5c9Zyqq+te9hpkH/Bi9SeyoKSjWdx9/sBS9ri2DWOFebmWWSXRwsvy27MNyRVkMGIulXelYjBqXPSZBCQ4hK01KE8q/LjX6D9CubrmnuCLEtJpUedWfhkeHWyWF0FDs3RPZgoB0A74OJL8ZQ5N5slKPVQNK0HJgXJ950ClTzE26ELbwtT96zg7WHn1vZ2JuITxYv3UXY/UrdCBIepVvmMWI3o+tQJFbO0yHxUopky0NM/0JfhFqJ6qlul0xHV5Q3UxFTlL+x7Bzmgp2u+PvGcCkg73boIgaDIYw+N78USKd7a+pzlTij7ztEy82uu/NFHo12Hooblbj6kO9GJOE5TeKHgdryy+gxEIeeaq3riy0oa0tdmps9vauzc79agKC73eNKV4HhPN/nlxOkPN1Fjgc0tRzdwJZA+98KpagNZbjxT0W4gw7C9FyhyOfFyZPIVigMryr85wqv72r5HNjt+QORxsbpOAYDl8WC9Ci6AAF7Ex9qVIuq+F+G7JeJacpuwzgei9S6TvHzqdynWvzLSblyJB5b/aDe5fjKjLclXHtsht+zZcgGoKNVzZMMwkvAaKifUcWHJoeTt5MQgJmQYdt1ZHw/7sWBX0uElLeVD/DSjsjivKxR2Ytz9PztcvGU1gxXbCdPGs8f8MZbyuPIAw85WrJPGbamgGwSKrNRGQRGajZDDH9F+2ewcJAvyBbQT3gzmlrlkh70QON68hWhDPJqbpVQtfO33eTz7HfpIcyb2NBG29Tpu0
 I+Y5XVIk
 SpHEH/a3X/1qS+tpncQzcwHtKC1SdLYpfIIuT3nJkopa/p2SdzopzphhMQbziamFxUpAKpXquzEsj8BQjOq4bDqZx3bLair+D6Pz0sv3HKaR3jsrF3fY+hveSE3gWDXk1g8jWeNF7J372w3Z7LK7IBUwtJ3ofO/QXQZSffGoSYzMsngRy0CTRPWM0U8ZZTtcFbd8k/9MdzTBn0gSfmmxeV3HZG9P+OgRsH36vrWJD4Ly3EvbSlXhP4/m1XHpLDO1J3SX8sa01YGeVVGnkqZgOi0nG8caID88TBSVpLrPNKi8KDbaLpUCA3tkwSxpfWxaP7q3xMsVkpYkrU9FBk7VCjlfJmvpD0bwOuCajzYJ2JYHOa1duk4Fxd/ZsKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor identify_cpu() machinery on x86 and then implement a fix for
a bug when cpu capabilities are temporarily cleared within an
interruptable window. For more details and discussion see the relevant
bug report [1] and patch #5 ("x86/cpu: Don't transiently clear the
boot CPU's capabilities").

Suggested-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>

[1] https://lore.kernel.org/bpf/20260610175651.647515-1-ihor.solodrai@linux.dev/

---

v2->v3:
  * Commit message edits on patches #1, #2, #5

v2: https://lore.kernel.org/bpf/20260814235134.3461435-1-ihor.solodrai@linux.dev/

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


base-commit: fd73f4a6659897191fa0d40695fe370925dd3780
-- 
2.55.0


