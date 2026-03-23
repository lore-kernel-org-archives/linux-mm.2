Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C916F483C6
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 16:17:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 534B86B0005; Mon, 23 Mar 2026 12:17:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50BEB6B0088; Mon, 23 Mar 2026 12:17:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 421B06B008A; Mon, 23 Mar 2026 12:17:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 300056B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:17:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D3CFEC389F
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:17:43 +0000 (UTC)
X-FDA: 84577833606.15.4603820
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0CE3410000C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:17:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=RrBpgySw
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774282662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KyGXX5+HJx34fkYM+Eg9zTm4QCG3KHrCHOBtah8R85E=;
	b=cEqvs+qPkbyLmqHbULUJnplsODGy2wP72DcsecbfpicWYwNseBKKVpS+g0+l2PngtYViuV
	m7s5i5br/qFYDo3hsEwtvmZN3oga1j459WiKxDcHmD9DLv3zTcbvYKwTv/W7zn3HtRF/k8
	d976y491qRyEYba/U7D15v7TLJQO52k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=RrBpgySw;
	spf=none (imf14.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774282662; a=rsa-sha256;
	cv=none;
	b=g8I4cK8NLF2HMRjuEdgbh0zVmHyZzu0CfzarXar5lJDZC0xK0FXdDO+rngBnT+meJru+zj
	A4pyEU87o2nafzMZ6NcE28NGS6vsWefAzNDsCf4L0n7EFtELDZ9kgm4Yw/Q3JaLunyh9vx
	GixdiB6i5GVSo0u1ou3mtBsuhaeoj1g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=KyGXX5+HJx34fkYM+Eg9zTm4QCG3KHrCHOBtah8R85E=; b=RrBpgySwdjAV3+WFL8Mru5P980
	9SQ4rhZSkDsOj2AC06ricxqYeCuzcnP8frnZvPhoHMeG68POl+066JMgStWe7nZwmkowZodBmZKek
	ls0OsdFPOqdBgQjTGFpyzMk32dkwH8+srZvwoZuUp8hqI3Uo+I5qfZA6+u1cVAGnFghtBxBv/4SGM
	NVILKMSpMFngQNz6XYrBj/jLAwNUX1FUDqMKTUuFS+mf8fUbRHKTO7I84qGQ5sbAdg7M5XyC1wczA
	qCFXWKJARagKGWdRqIurlMpP0CYkxQG4XyV/6gQ+te3fq0mbvNFuCjPouWPGP1SsWeCBZwIaIirFf
	IaUnVbSw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w4hEQ-007cwX-Ah; Mon, 23 Mar 2026 15:30:17 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 23 Mar 2026 08:29:42 -0700
Subject: [PATCH 2/2] Documentation: document
 panic_on_unrecoverable_memory_failure sysctl
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260323-ecc_panic-v1-2-72a1921726c5@debian.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2201; i=leitao@debian.org;
 h=from:subject:message-id; bh=jL377ytdCoM//Ho4ubP48OOIfsA/+ymH7ZOPYpJWWKA=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpwVx9mcJMRz348d1iYSLpK0wFK23u5H0p2MPTV
 Ay34qwVDoyJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCacFcfQAKCRA1o5Of/Hh3
 bWCwD/4umHrQNt+Fr5RoDabDdN2N48BqAz6131TiiU4X7zt4klDtfPB2xnQqS+9sLjngMAa9kzT
 wuAmSOGQnfT7UsZyMc/JkmutvxbYno8plRiyS9GgjHv52AiloMxFqKxsnDVJh1ifr6dIsyDv1NJ
 rPLcxkHijJBvpdDUdz59qgXnSV66sP85FfkKN2+f/QM6ftCMBdjB38EPjbEIXnIoYOhyg3G9OAM
 Fc/CUO/CyjLRBoly+vLX2m9oE5scQMbCeasRtMSeN/5eQOEmbixhW34b7nW+dWABAfdCRiX+abC
 UK8PMV0o8kJf8vX+7NtdcHyrJ79BEF+T7n1vc893/QjPi5cFzMW1/0u5esdzI5UQkLU7YMW96OR
 o/0qluJ7zsSc2dxuTxe/9RzPj4TWPjLD1Rm5VPoYLi1Dst1sR7/8a9QZRwZSoMnDRvgwm0K3XGm
 GkZkIY7+s+PI36s+IGF4VvC1hOuDSdtjL0dcVYTnvwOkMXKIlNpcsYKj2qw3+cSi7bNSudJtNhz
 Sm2UbW/PLzz6LdGt/JZB+sp448S+DIQrG1SLZaI33mLG6qSOicBW6+f1+EF22QB64fzjxW2F5hB
 uuqQx1PmMJ90+cKJ0eaPK2Rwg9c4TAHLWwwkmJKaYOgQB4hZQm9RL2gTdgf6VsCXFX978Ak0YZd
 5ViR8/D3+ttpvjQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Queue-Id: 0CE3410000C
X-Stat-Signature: f6fybuu51m4i6ddoaszn4d6cj3t5hnf7
X-Rspamd-Server: rspam06
X-HE-Tag: 1774282661-341794
X-HE-Meta: U2FsdGVkX18uyZJW3wrOvrBqajw806DNgt9V0+XeGG6k3qukSJq+myB+I0WZHqSk7o19NQNoS8GQt1WBo0Tu/c3R1YgZ25PvF/B/454C5IrmfUB77cB+ZH5mPPW5RbNve/TsNIMW0D7sZRAjRHa5BY4e0WBsO+aNUHKIfMAutpbyBX+5fMVF5JHWtTcd1R7PnpT5MTc2leaYzdx7H/VKze5VsrWkAnC6FMuLZDD8to5+70yN4vr+12qr9nEkuPdv7uIIJaSEfFkkGfhrslRj0PHIB2zM9A0Mvkh546jxpBDTC79s4ounPsM1BF+2qS5YhY2Bjv/qA9zWET6TXBLL58e87vk3eIyzHEa19AqAr9lUdiqGItXvxSkOe9gLolrHDvK8ekqSZii+ycA20Vm+/59NJA3GMrzxDKsssyjEnDhHg10+4V54RplfdTNROTssnfhFc5UekTcMMcj1mqUIHVsRgG0DwifTIEY7AXtmiVpb7yET38FPt6bOBSZV/m+VqTNuNIEdklUog5VZjleMy4nart1EURMREE0OpK8nCHGos2jjmxC/vrqQx0CAGSmnYHdEJqAlDJAao9RdIEGz+SXPUSJzc/CzLi481Dn0hXAp8kiR0bZ3jhz4ovYrEV3FJlVlSCxvmGadv+neSt1jlB06HpV5trJSRWj8+9A/MMFMWWDdJm8bvLmXbl0l0RgT9LleK9zjRO2IYWbw/UOdkPzM94Q7Q6Gi79ihB0pHpSTprwqYh5SBD0KxElDIpelj2hJ4EQ4MODER0ggy9byKg0F1ZJknWCNE3mB6COZEepwTSIR4hjns56QuDa0ob8R43BEAPK0iC0Y51Ou1ENV3z8AqKSmN1LCcnhth+7akGYkiWrqH+KfTIiuCHDohaEJUpkg5yS+9JoDzXt+7OK9+KXsJE8wTPbmGI3fwZlGm36FJzdrfmv1A4Z52reo/lD9UQjg3eFXI9BFlRAHZhFx
 5097Tzpl
 3Urlkll8c3pixeDZZee3TAmvibTU7xT8g5PuBHYli8ZNw1lj05CPCW+uAhAUcRvv6nY6PxLEROybDRRqCpjBad1lZINSAyl5iBpqWcVzQCbyX/TmQIqPIbIOWTOUCOiFDp8XMoDmhQhWh0VLCXOjxZg0cr/gVztK+EcgbqhGizfsLJc4oxvSVP6fcd3xCfLdbFkdCTmRP/mNQdhCKSV961yjo6wV5IBRdqTMaAqOHbj+S4bog4sExYiAim7sRfJ065hxvVMWCq8dHBwt0fBZ8dWcFQg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the new vm.panic_on_unrecoverable_memory_failure sysctl in the
admin guide, following the same format as panic_on_unrecovered_nmi.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 Documentation/admin-guide/sysctl/vm.rst | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 97e12359775c9..3310fb8272fb9 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -67,6 +67,7 @@ Currently, these files are in /proc/sys/vm:
 - page-cluster
 - page_lock_unfairness
 - panic_on_oom
+- panic_on_unrecoverable_memory_failure
 - percpu_pagelist_high_fraction
 - stat_interval
 - stat_refresh
@@ -925,6 +926,32 @@ panic_on_oom=2+kdump gives you very strong tool to investigate
 why oom happens. You can get snapshot.
 
 
+panic_on_unrecoverable_memory_failure
+======================================
+
+When a hardware memory error (e.g. multi-bit ECC) hits an in-use kernel
+page that cannot be recovered by the memory failure handler, the default
+behaviour is to ignore the error and continue operation.  This is
+dangerous because the corrupted data remains accessible to the kernel,
+risking silent data corruption or a delayed crash when the poisoned
+memory is next accessed.
+
+Pages that reach this path include slab objects (dentry cache, inode
+cache, etc.), page tables, kernel stacks, and other kernel allocations
+that lack the reverse mapping needed to isolate all references.
+
+For many environments it is preferable to panic immediately with a clean
+crash dump that captures the original error context, rather than to
+continue and face a random crash later whose cause is difficult to
+diagnose.
+
+= ===================================================================
+0 Try to continue operation (default).
+1 Panic immediately.  If the ``panic`` sysctl is also non-zero then the
+  machine will be rebooted.
+= ===================================================================
+
+
 percpu_pagelist_high_fraction
 =============================
 

-- 
2.52.0


