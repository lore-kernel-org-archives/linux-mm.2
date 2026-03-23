Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B1E1F4613C
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 15:47:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE24C6B0005; Mon, 23 Mar 2026 11:47:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBA1A6B0088; Mon, 23 Mar 2026 11:47:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC1C6B008A; Mon, 23 Mar 2026 11:47:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C14286B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:47:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5D0C91EC92
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:47:44 +0000 (UTC)
X-FDA: 84577758048.24.60668CB
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5BE941C0017
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:47:42 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="HLT/Je4o"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774280862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hs5AaukrdFZg+ZHq7Ly+Cm0DtzECAzYMSxHy8UfYBWo=;
	b=yg2CYTRd7lLXcdKBdyu0RoRoI9KUZw8vT7obxsedoVthChNWS0KpYGh1nk0c4nkm+ZdcP9
	HXLwaj84FaYigy4O91iZXzQcVrWcDxdE85AceC24adfo9Gic4mWCCrgDCg+IkqsXFPaTln
	rN1el/LEulnh/e3ID/9+Pob1d+yil8s=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="HLT/Je4o";
	spf=none (imf18.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774280862; a=rsa-sha256;
	cv=none;
	b=vIE7b6tRTeIWXOJRn2oHFpfkEBQ/ulZtSwVJ/MJ0xRo6MhVDAOpdI2XD29Zao7W0fUlQ0U
	lNLPO9sjUvJJGotbOkCQ7EvZnudICVnrmwWy1Z8ODQ3qLPqZupHKejwbQI+wj7AihpQFzJ
	7WLa5HVXY3hdVYC+WkAp2bTXvFHgS3M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=hs5AaukrdFZg+ZHq7Ly+Cm0DtzECAzYMSxHy8UfYBWo=; b=HLT/Je4ox9ntuJpC/sssziOdTL
	QfNnubHSQjyaukOdefaaxN2ZzCY8uIQy0CLWcPkpfBQ2QBnncSEDAY6z8v13+zcKC93E5o2zlZhtC
	PGpF0O5oytLitPWCEkdtnZJ5E7uWKUZix05I5nXzmbfKCiQUbz/Bn9xbJg5pKCu4AM62l3oHitPqn
	fZez9XbGldpYKaZEVygrHBJMLncJ1WfHSyEfS9frcEFCiZBonKvtFvRG9MI8nLMd0rogcZ7WmGrUZ
	8x8DRigVSc3P2St3Te/mYZ7NHMS3N9/MDRGWubgNH6oWl1fUI383oMsGXQqpFfjNC0jY7QABumCoo
	Fuoq84fw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w4hEM-007cwP-GF; Mon, 23 Mar 2026 15:30:13 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 23 Mar 2026 08:29:41 -0700
Subject: [PATCH 1/2] mm/memory-failure: add
 panic_on_unrecoverable_memory_failure sysctl
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260323-ecc_panic-v1-1-72a1921726c5@debian.org>
References: <20260323-ecc_panic-v1-0-72a1921726c5@debian.org>
In-Reply-To: <20260323-ecc_panic-v1-0-72a1921726c5@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=2978; i=leitao@debian.org;
 h=from:subject:message-id; bh=BRu/uT3W6S86Xguye/JZNbSsUnO3+bic+mN1VkP6A44=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpwVx91nh/3gITwRCtMZ5ICYhNvOzbysM6UGwey
 enOznJMOH+JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCacFcfQAKCRA1o5Of/Hh3
 bfKED/9ujb3DroZDcyb8s6MgZ+3XY+lG5ikMKCpF07sDNSQN0LJhSJCznXEz7BkrDK1af2cM7Kf
 0D21Po3IbonUhJ1Y89QYcsfnogwTj9ZJ/thC+Czly8SgNGCYw4U2YS3ACA9bsIvaYNmCy0fHuZU
 7WV71tEcS7jmjgnIyee/I7CMez1KyBcTlgKGW4KatexyKZvApj9rGb4XoCmZUgrcqJ0c/MMvuov
 t+M04RJBMbmcl2PKMffze2ndyL3mkCL0J8iWOCa7Wv6ju3rK+FarWgMFXrAloKtE3sHFfhsHMDh
 RDmuo8urdrt49GtdOeDoIRrfSelN6ADdZpj8yaSJJsGJSzkpMK2iXr2vfk8Y/L7vAeuZvQgkEv1
 TLjTqVyHK03mu77tXr1JdDR6mD4hOLi6vkprv23PMrdOtUlq4M8k8qW/lwpxaP5coTC/TRwgXOw
 EelU/iQBwspJfHxrNEL4kYYfJbTZpU0bxcGfuKuiwo18uVZ0CqAJ4bu4MqCDSn8/l0IlB3kdyvF
 OqXK9ZdddgmOoWb70d5rwKXoNkTk6HYZCJ5Ob51noTA8JRNY+c7WcabdFQlGQ00xmfDC52bgG53
 Car8ZDuQPSfcloFs9iuRLGbUsyFYSHgB8pxnMfj5tdCmjGttnr9kwHvTK2Sz32fLVSCoWXO7ZCl
 sxFNi/2wlv9PGiw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Stat-Signature: gm5koktkyai5c8gxikte6ooh8kgymamq
X-Rspamd-Queue-Id: 5BE941C0017
X-Rspamd-Server: rspam09
X-HE-Tag: 1774280862-283055
X-HE-Meta: U2FsdGVkX19i/1mTIHjmeS+ZAc9t5/l6l1GxD/Wa86uS8aOiomTsgBTtTaHKSC82x7kLtZzFM9SPRD9YqSVAdW72MjMgjt3jY2uVYTGdVj09s0WYOWBXMAy1su4QQv7DmESEpOCry1TXWYTYcpW8YbR0jHq7IynnW8eSdbCvFGPHUPRAORUPWWhri7SJSFIM86XWORNTZSx66FSxQ60h4pkey7y+Hl37JbWbH9XhXyXpJ0Lwqo2toJKsbCirEnnW6vczQhtBx8jRbsAHMgyOq5pqiEOYOU3I4OBpqvtvsg03rTb/qAcNZyaZmEFqamAwGxyq/1vUB3LMn49FRt0fHeE9j9YrnkEC8ITH+Saor75/n/8LDbApGGr2m6I7uqaAgw670UqXnYWUb+N6Ba/Dz3FPbT7VlkHtjImjrFI9MZwWjPxjpvoBqhSz/c06rCdCXQTixSe17GIGQHDoOxWIaJkWxAqpfNffO2njv/WC/MZws/jbswpKk2eOCCpFUWSlDn8MS9jWZhgkkL44C97lqEUkmjq6WQtTAxeBcEEOkW0ys5wYq2lWyICca9eHTxa5K//iTtI78pvnxJtc2ELS7fNA9Hor+sCDatEAx21hWSo0VhV9XsutAhCEhEPGeS6FCNUaZ5mkGfIRw+jS36q4GbZPYFZk2p5CGAx6pIoFl1KiRg5cVbjLaw3uIUX5ybYoYZGnTXWNUjb4jpiVjOTlHhPtAmpVWu9g/l62VUAGaAXAVdAw8gVasYJFEGIYl04zVmJc2TaHAyqLY3MPt2jVmnX0eB0KswcvDwgfPo5YpZd+MUn9uyyYkw5lMaFB8+ZigmwICttpexYcmQ0vhjqhnt57qul7Aa375thDvguoFd2aFGdiJcWkyIPMPFzDnUhQb5VHlMRDZC40jijS5onKCgbwzuSOIGqo5nJKPHoBGqQZIygahFhMiaKfnzYuJIx5kSuDUW4SxIpazVxRMUy
 M+p+naOM
 hzdVz1KxB/zxtKtXf+pY6Xq7L1ur9BEaBreCNnnnNYqNhhX6f20j4hf3o+g5jVyehZ+zoYvzWx5XYhlzWQTLU0VYToZSgE5OpTV2Z70aId1YyJwRzkUF3fZ+BefJFTWKa0NhgXI/l6ZnivxNcbSgyOOW7bq/itl5lQzfjTSkVuIxdoVazVqvE88UO/KAG96soXErjYcy1xFlt/mdG+c3ifBCzJKu6edYfzuqN2LIOAW2idu1mfygz2UXQZe72/kGkjX97U79Xy/xBDI84HctB5cOD9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When memory_failure() encounters an in-use kernel page that cannot be
recovered (slab, page tables, kernel stacks, reserved, vmalloc, etc.),
it currently logs MF_IGNORED and continues. This leaves corrupted data
accessible to the kernel, risking silent data corruption or a delayed
crash when the poisoned cache line is next accessed.

For example, a multi-bit ECC error on a dentry cache slab page was
ignored by memory_failure(), and 67 seconds later d_lookup() accessed
the poisoned cache line, causing a synchronous external abort:

  [88690.479680] [Hardware Error]: error_type: 3, multi-bit ECC
  [88690.498473] Memory failure: 0x40272d: unhandlable page.
  [88690.498619] Memory failure: 0x40272d: recovery action for
                 get hwpoison page: Ignored
  ...
  [88757.847126] Internal error: synchronous external abort:
                 0000000096000410 [#1] SMP
  [88758.061075] pc : d_lookup+0x5c/0x220

Add a new sysctl vm.panic_on_unrecoverable_memory_failure (default 0)
that, when set to 1, panics immediately on unrecoverable memory
failures. This provides a clean crash dump at the time of the error
rather than a delayed crash with potential silent corruption in between.

The panic is placed in action_result() so that all call sites that log
MF_MSG_GET_HWPOISON with MF_IGNORED are covered, including the hugetlb
path in try_memory_failure_hugetlb().

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/memory-failure.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index ee42d43613097..25bd043497195 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -74,6 +74,8 @@ static int sysctl_memory_failure_recovery __read_mostly = 1;
 
 static int sysctl_enable_soft_offline __read_mostly = 1;
 
+static int sysctl_panic_on_unrecoverable_mf __read_mostly;
+
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 
 static bool hw_memory_failure __read_mostly = false;
@@ -155,6 +157,15 @@ static const struct ctl_table memory_failure_table[] = {
 		.proc_handler	= proc_dointvec_minmax,
 		.extra1		= SYSCTL_ZERO,
 		.extra2		= SYSCTL_ONE,
+	},
+	{
+		.procname	= "panic_on_unrecoverable_memory_failure",
+		.data		= &sysctl_panic_on_unrecoverable_mf,
+		.maxlen		= sizeof(sysctl_panic_on_unrecoverable_mf),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE,
 	}
 };
 
@@ -1298,6 +1309,10 @@ static int action_result(unsigned long pfn, enum mf_action_page_type type,
 	pr_err("%#lx: recovery action for %s: %s\n",
 		pfn, action_page_types[type], action_name[result]);
 
+	if (sysctl_panic_on_unrecoverable_mf &&
+	    type == MF_MSG_GET_HWPOISON && result == MF_IGNORED)
+		panic("Memory failure: %#lx: unrecoverable page", pfn);
+
 	return (result == MF_RECOVERED || result == MF_DELAYED) ? 0 : -EBUSY;
 }
 

-- 
2.52.0


