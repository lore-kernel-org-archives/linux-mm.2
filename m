Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6ECC5D19501
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D69666B0092; Mon, 26 Jan 2026 11:08:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30A16B0093; Mon, 26 Jan 2026 11:08:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C544A6B0095; Mon, 26 Jan 2026 11:08:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B47646B0092
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:08:12 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 64AA4140839
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:08:12 +0000 (UTC)
X-FDA: 84374596824.20.DCACC1B
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7F440C000A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:08:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=soYnZAFu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769443690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wD58s7Afm/VpqSfRj+q5T+RmL4WmAdEhDa4vBZoYFyo=;
	b=keEiLRzNcw5i6GDwVBdrGRsZlNqX9JtG4Y0JKbIyjqAljwWsBExvVtC7KsvAOheNUMmUwR
	x43OXsUfBst18TuB1Z8MmE3d/tVC6lx9sD07dih0YxuKvjjvBOQianGHPWXgDESYAb3A6T
	pL7eFPDJkfXeZTG+nJ43dcuJZ/PFp0k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=soYnZAFu;
	spf=none (imf10.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769443690; a=rsa-sha256;
	cv=none;
	b=UAoPLsXIhg6JOljjRY02hRIlIliqXsupKa7COVYiN75sAcs4zQT98JKZaz74B1kmGCTgc0
	XqckkN7X2g3ylBwMkLo1tkVsO27/op83CWxwN1cxeVkiO3GY/d/LN2w9gAqQvz0IQh2MvN
	tWc4jku5L8HDjnKb3fF2Jnvbcfxe7kY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=wD58s7Afm/VpqSfRj+q5T+RmL4WmAdEhDa4vBZoYFyo=; b=soYnZAFuPhU1DxNnsHIw5UePTQ
	a6FXz3eyOoC936m2ACmAu9h/bYT69r9a6FJkP5u/k8yIwyw4lDlocxXTrhrEOxQmn5IZZHzHTKgXd
	jJYDjTiSrC48CAIgY86GknFCOdTNCJr+jmto+pl/ijgnrxE3gMb2vLTDGDjb8+4BCegUjjcVqxlsE
	QapioKiqUz+On5qkl0WtwX6K80gtpXX9fDCQt0pkROmlusOjAyDfQBYX8b0K8eiVlkED2/NSsJjs+
	fu/zDA8SfFrx3kMoT44WLucMzOsil77KxgDd7m2mmtKf7vYTG+vQQWIN+MCz7AFbinrs2zrO5akJG
	P6FvYxbw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vkP8H-00GI7w-Im; Mon, 26 Jan 2026 16:08:05 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 26 Jan 2026 08:07:26 -0800
Subject: [PATCH v5 4/4] kho: document kexec-metadata tracking feature
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260126-kho-v5-4-7cd0f69ab204@debian.org>
References: <20260126-kho-v5-0-7cd0f69ab204@debian.org>
In-Reply-To: <20260126-kho-v5-0-7cd0f69ab204@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, rmikey@meta.com, clm@fb.com, 
 riel@surriel.com, Breno Leitao <leitao@debian.org>, 
 SeongJae Park <sj@kernel.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=2407; i=leitao@debian.org;
 h=from:subject:message-id; bh=LPIeB1HXx7yrXcJ/f/iPyLV8CRN9XseGBN7nDn4O/z8=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpd5FNsYxGYOfmgeChAKbgeCeJ4Qsp0Qy+6Zkp4
 dy+wiT4aQKJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaXeRTQAKCRA1o5Of/Hh3
 bT06EACm9JDRKk0yip7QtOwGH/xtGviLyn0x0lI5qHFZZWp/yqdNbU8HOP9iETSZuG/x1Tjn0+t
 5wWTV05RZgrHkuZX3izl50nBeBf4TaWcMcYT+HojQG10w77/61U7/ZX/9skWqlbyfS68KrgAfGZ
 6p7IfV/c99GbqvTo++uo3Q9aygJQ7lfkBdOMAFCC4oYMiP4CCGdWVsmNAzfH6K3RnYSL24QKHxc
 0mmmkLaZnceiRq9U4spubZkyXtIP+s4Ul2zxOEXYBOQBcvCmGFCC6FPfYoi15Tzxe8sC/EIzZQX
 4mYzZ9S4gT6QDj8L/FToall4nJr3eCua466cKVXuD2KAP/5Ns7RJTnbfMO2WH6LhdTmrlKEYK77
 QX+WNSWjlXAzAsRh6XJ4IeRwUzhPDYtcLRblq97HB+Dw2R7O/tGM/QXcNiN66jXpYi2Ww14Pmnu
 yFRucwlpyVrkCsqOLuFoLa5EkMZONFYPUTYkWQLk7+VV7vQqS3A7/N2wIndlp4P9CLNSJK1yiCA
 CJ2ASYS8X84qZyg5UvZSO4ywk6UhmVdbMZrWheyFJ7ccGfggPxuocfWNsFPb2PRJDrCpnutsQ0O
 SoRrEEJkjnuY6dqwX8x1+Z5d3nf8RjSpga1r6jXGq0ApRL53Ho7IN6JHQ3Q8St4MqPN6CN3Vu8i
 qa1gXGhv4nZSXWA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: x15psw19a75fyrqcpgkmz9ckzbdi5477
X-Rspamd-Queue-Id: 7F440C000A
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769443690-732577
X-HE-Meta: U2FsdGVkX1/TgTmfnR+7Fg4A2HbX9FMXNmxaaxRe6PA0+FTmsbrNDVBWW71Inwj06O7vhW6g9QAS60rO6Mk6hhZWRjNKAtnDlbp9S037hhuZm5ybjH2Xhc5UF6MoPlxPw0m8XkdXrXfdyah2z8/aPQwYhUtfwRgUgpLLb8VqxhYExEZuG05JtBgeW984fUGp0OKjSpikyPSnvAV788mZy3IzPojudDKEg476UDtRJejFYuXbF+oQpz1mjcPS98t0j3OBIOs8BvFN+lfvRYRhakHadwp+7hcyDR5bW3pDvczC75hVwhry2yziCNsGmZtksT736yxdK3WgKwPZOpcXtH02MrK54M+r/WXslElqiBo5tMz+KDyhgCiVCFGcAsMnimDIrPadTxKmeEdLj4i0lWmoxDkP9DC/ZjHO8pSkTFg2z0F3rBBkRjkr9en+hmvPsYcpL6C0spldFIdRMmoGH2TA+zINfhaNwvytMLOEXgdwzNd3Ekw7/Dvtn1Cw6ODTc4SkZWbdXaJgnoWVCmwBuCWu2Abww0j3RNdItnhEMfCGf48Ozn3VuVPNvZ+9N9u9oH0BGeGM3KGaOXb4E3G7dawYzuFAMpltNbM8kueEozRPQsc88dGYaA6qZoF4L+aBpiOno6LbFYQwNF6oHr6Vmjj1uh2OOm7JHNjXNcZpHl/HdmGv7FzMk+xxWsLGWH6zDCrnhxGDbMGD41LbSY0+LRF9BVvZKxss34OeT03MCd7VxqWjP30KoX19k8tLmnsa/ygQrPonNZtAz2veFU1W3L2hn1p4/W1ayX4Gq1iWqjQhijAv53++NC3bz/ZnC13mypWEghm4+MvT375BfvYC/PCk3aWDPfa3fPaBH8xyZoalpQL9vggL8OBuKQ1xn9aaA/cnh9JVAgmZCDnjFbV6Lvpqm58qKVGCKYJJ7pBmJgTb3ylzZvOFIZNIfR0m0tEQ1puMF1TO7CCs7ly9GDQ
 twOC4qer
 XhOvL1LGNomaOnwl2zeTrn63dYLMgIQcFGwxviADl7bIuR0RlDb8aH4fC/X+YT370yUK0i7UcBTVPKxHr5NJhQ3EA//+pB4AfzWvG1KxpVDLD6uKQrdOXHd5li/VvmAC9piyfF9sDJ6dcfeBKwKHk8c+AHmWebh8AzPFahD4tGnjT481RaMgVKuLPlw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation for the kexec-metadata feature that tracks the
previous kernel version and kexec boot count across kexec reboots.
This helps diagnose bugs that only reproduce when kexecing from
specific kernel versions.

Suggested-by: Mike Rapoport <rppt@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 Documentation/admin-guide/mm/kho.rst | 39 ++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index 6dc18ed4b8861..3771e764bb513 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -62,6 +62,45 @@ You can move the system out of KHO finalization phase again by calling ::
 After this command, the KHO FDT is no longer available in
 ``/sys/kernel/debug/kho/out/fdt``.
 
+Kexec Metadata
+==============
+
+KHO automatically tracks metadata about the kexec chain, passing information
+about the previous kernel to the next kernel. This feature helps diagnose
+bugs that only reproduce when kexecing from specific kernel versions.
+
+On each KHO kexec, the kernel logs the previous kernel's version and the
+number of kexec reboots since the last cold boot::
+
+    [    0.000000] KHO: exec from: 6.19.0-rc4-next-20260107 (count 1)
+
+The metadata includes:
+
+``previous_release``
+    The kernel version string (from ``uname -r``) of the kernel that
+    initiated the kexec.
+
+``kexec_count``
+    The number of kexec boots since the last cold boot. On cold boot,
+    this counter starts at 0 and increments with each kexec. This helps
+    identify issues that only manifest after multiple consecutive kexec
+    reboots.
+
+Use Cases
+---------
+
+This metadata is particularly useful for debugging kexec transition bugs,
+where a buggy kernel kexecs into a new kernel and the bug manifests only
+in the second kernel. Examples of such bugs include:
+
+- Memory corruption from the previous kernel affecting the new kernel
+- Incorrect hardware state left by the previous kernel
+- Firmware/ACPI state issues that only appear in kexec scenarios
+
+At scale, correlating crashes to the previous kernel version enables
+faster root cause analysis when issues only occur in specific kernel
+transition scenarios.
+
 debugfs Interfaces
 ==================
 

-- 
2.47.3


