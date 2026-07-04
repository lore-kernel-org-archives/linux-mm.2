Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50D35C43602
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 00:21:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A5076B00B6; Fri,  3 Jul 2026 20:21:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 156716B00B7; Fri,  3 Jul 2026 20:21:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F12286B00B8; Fri,  3 Jul 2026 20:21:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB51E6B00B6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 20:21:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 38C851689FA
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:21:13 +0000 (UTC)
X-FDA: 84949189626.26.32ACD52
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf03.hostedemail.com (Postfix) with ESMTP id 72BEA20004
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:21:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HcaGkuOa;
	spf=pass (imf03.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783124471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WiUU8XneX3wvcz7OpmI3CTa/dG6YwidrHTie7rRQSHk=;
	b=xMhIesPIFjRYk0gNLoXxXXt4uw1u1p/019rDnUFlCMlgfBPFMJvj2hqLTif+vnR/xGamZc
	mcuj1BXxLLk+dyqpFc4Y+OjZCI7rtBbBiFMcNHrcHIEjmSUwKuyx46Y+Dbkb553VdEE2qD
	7I/QyrmO4XJBeosoaQg/uTuk5rzJlE0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HcaGkuOa;
	spf=pass (imf03.hostedemail.com: domain of ihor.solodrai@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=ihor.solodrai@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783124471;
	b=yl33e6xKhqlpXVotx0AsRKOWXHhI1FMU7aUk7Q5DPjs2pGdlGV5ckdfmxTTkNMz2J4/XbF
	bK8eY5Z8UNwYtVHAQ0nljvByLpAbX7gmpAXLtZhsC0SAB7REP4mzQud8dF9jM8UntJquZh
	tNNMd0CNewE/A8ZIgSO64CF8uEBL06A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783124469;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WiUU8XneX3wvcz7OpmI3CTa/dG6YwidrHTie7rRQSHk=;
	b=HcaGkuOa07EpTs7KKOWH02bgZhWCBWxLbjhy8OjFqA5IBd/aw5BDMW+iMnkeBfiZQySvJR
	6ffc5jM0Vqk1Nn+jkZeC/nOxJDtE3tmBVuoi1fKn4T9zhgOLkRi+wq9wM2KI9bnaCdqAX6
	KFj/Tmvnm3kep/RgJHs8aEpNgIlxzXY=
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
	bpf@vger.kernel.org,
	kernel-team@meta.com,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/5] x86/cpu: Factor init_cpu_info() out of identify_cpu()
Date: Fri,  3 Jul 2026 17:20:42 -0700
Message-ID: <20260704002046.3859585-2-ihor.solodrai@linux.dev>
In-Reply-To: <20260704002046.3859585-1-ihor.solodrai@linux.dev>
References: <20260704002046.3859585-1-ihor.solodrai@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 72BEA20004
X-Stat-Signature: deap5ite3hgpndx3wwxfdgbxqh1ii7ou
X-HE-Tag: 1783124471-146435
X-HE-Meta: U2FsdGVkX19AbO2MLQY4pkNa4QrJjuMHxVnNtUZ9BdXoUWGnQTQ9gmR6phkxr32ShUUs11xJCCIU1lj1XQBwd8OSNdtQnI14uK/wxDjk+D0Quq1Zo5fQGVy/UB3MHegY8swv81zzsxOvyyvVssUCPSfIMy3vPMriCha6meZROMhzPk1hHbgNeBsnBve66HyU0/yH/J6T+Hx13lZ2fx00HFohv//OrRn6NC5sz44t+TDcP6xzAf5SVxrgYUYWef8epiWKzxsZCnaxkN1o6PJL1zioGOw4rsAT6HUE/4pe5sgoFe/3hq/5oGaLIVA6H/M7oyAxRlwGRAu3D8vTLoTWUEZpWkVB+SePui/GAI8YfN5yhMpobkFnGfQKnIGtjRYW+ww/+esME3iWyjWBoVFD6cQRmjwZdqyL2zECeY9F/vd0jMeab6BA43l6eBIjBndr44qyULsXKQAsK/o1818mCASZHx8+oqXUa9StSfvxM4v/UNBjdQO7o8pQ2keJXx4XxFCN3iNYNgMCLwH7e3NVP3AoFNBMvtDedI9+BHJdPqjUDBOge8nopGGms3zPZitt3NqTaDlg9ESHiOjig2jybik/PnSxX3qLqFf+NUhHYBVzoHJkJKNGWvXsV/o2tVuPi9EPUV2dUimU4u7owYbVbXHDkhOCl6SADlZ2Y2CbK/Q21UDu7OISnsACABWkLijAtJo/JM/d7WneVMAGn9iTjS+0Neu1s3oThNgO5FmfdOwVcT/QGrv5Glw5aPlEX/WCAcQ2Kj0iBJ9RNg4wJkGamafJbL6r7VKVQ9H5bmLGRPru5qzreWR3EahQxWqNflMQlSu94nrjqlTPX+8VaUlg0k3fnNw1NZ1nVX1YkCt1bPMTam5mHD+wGhnYoI5zl0d9ouBiqtswxhWpeH4Q/d/uqLJDXB1GzSH7rY0A4aJxbZSttALpymeNPIwKNmh8kNbVSxjORBOyOLxsWVDDT6i
 xVOzZC6Y
 aHvfDqozIpIR+Qieu5e+gFylleSR89PfHe9WAXGTg5+aGASTPa90xeP35GzzaSQqgeRtW4jA2CK71c3+kyvowBOs5rcwyPMELHR+8+YQczDpEkCVFa5wjoTB9kZPMKQ3v+KOwIS0ip+CgJwik06mYdYg8JehgTqJZDy5AYGP3Fx/+Xphm8EQAEKcVEs64KPehxTyM8bN7ZRJ+MYOxHcEbNkbiT1w/esOuJ6Is5B1fCUH6fk2LoCz5wEHmyI52fa0GI7Td3ixG2qfs0sBQhwg7K9+pOPo7hbwdsrTSiimfuwkDq+hyV+V3VSJTfKNJInGLkOv1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

identify_cpu() begins by resetting the struct cpuinfo_x86 fields to
their unknown/default values and clearing the capability arrays with
memset().

Move that reset into a new helper: init_cpu_info(). This is
preparation for letting the callers decide whether the reset is
needed.

Signed-off-by: Ihor Solodrai <ihor.solodrai@linux.dev>
---
 arch/x86/kernel/cpu/common.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a3df21d26460..505ce329e821 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -1993,14 +1993,8 @@ static void generic_identify(struct cpuinfo_x86 *c)
 #endif
 }
 
-/*
- * This does the hard work of actually picking apart the CPU stuff...
- */
-static void identify_cpu(struct cpuinfo_x86 *c)
+static void init_cpu_info(struct cpuinfo_x86 *c)
 {
-	int i;
-
-	c->loops_per_jiffy = loops_per_jiffy;
 	c->x86_cache_size = 0;
 	c->x86_vendor = X86_VENDOR_UNKNOWN;
 	c->x86_model = c->x86_stepping = 0;	/* So far unknown... */
@@ -2022,6 +2016,15 @@ static void identify_cpu(struct cpuinfo_x86 *c)
 #ifdef CONFIG_X86_VMX_FEATURE_NAMES
 	memset(&c->vmx_capability, 0, sizeof(c->vmx_capability));
 #endif
+}
+
+static void identify_cpu(struct cpuinfo_x86 *c)
+{
+	int i;
+
+	c->loops_per_jiffy = loops_per_jiffy;
+
+	init_cpu_info(c);
 
 	generic_identify(c);
 
-- 
2.54.0


