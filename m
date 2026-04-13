Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC0CBF34C49
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 13:27:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A4BD6B0092; Mon, 13 Apr 2026 09:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37B6A6B008A; Mon, 13 Apr 2026 09:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21C746B0095; Mon, 13 Apr 2026 09:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0BC606B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:27:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B37231A0180
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:27:05 +0000 (UTC)
X-FDA: 84653608410.11.B44ABDE
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf26.hostedemail.com (Postfix) with ESMTP id D521114000A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 13:27:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=GoM5tt+g
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776086824; a=rsa-sha256;
	cv=none;
	b=Km1Zl1mkckZIr39o0LUdLhKnGL7zYL2IAY74DK/Cac8gYJBXANB06NyBTWwYGwXivLUjm5
	YT6aF6rxkquaKlgxaAWjuelJn/mGGoT94fkarVafSpSGCaFdFIqEDFdo2U+hKmUxciYuY5
	CDHyRbYnqLUCBk28ZI8NX1+x5N/UkQQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=GoM5tt+g;
	dmarc=none;
	spf=none (imf26.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776086824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=glADREE+VEmEvXEBjVhecQZeEIPkFQqH+en5bctHaaA=;
	b=LZ6tVkiM3H+ege3oBsFtSxgrPxFcuRJUYTCYtPo6yVvpCUhy8L3iBaMNrzsUS/RB3AWpV8
	Gp7lN+/NPGEhOSgqh2NiOL/2eGLyItCzT6dN9arfJm9zLGgwMRvj48mCndc+w2cXTAZIKd
	zhdg/8vAqE4rBlq7DERWiqsYxG2TEE8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=glADREE+VEmEvXEBjVhecQZeEIPkFQqH+en5bctHaaA=; b=GoM5tt+gkJHHCFvIY8VycuA09j
	dx6RZ3UWH1pXUr8olEKT6e5C4EpFAiJmhCidL3pz9AmJGuG8/uOghmWuwCQVue4EP6/cehujA2ZzM
	MB93Yk6xGSLy5LoZI+qxEL3LSMlMIN4iqtQJcDg96G+rLgTm7zVrXler+RVhQt46PRTkCyQPZYojM
	rOZnHtIi1a3nH34iT9JEdyOSzMMjOrIQ5EBm8jtBHsGRLjtoQPCoWeppd/5iuInMTJX+osJViQx1d
	PbEpxQWmfoeYj3SMJgifSMRQ7Sr8KDWfZ+xk6vtHQHFWRoTvGmFNsu2IoVeyDMKIpmf8qFdgHfYZc
	/UL015ig==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wCHJV-00CKEV-1k;
	Mon, 13 Apr 2026 13:26:53 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 13 Apr 2026 06:26:34 -0700
Subject: [PATCH v3 2/3] mm/memory-failure: add
 CONFIG_BOOTPARAM_MEMORY_FAILURE_PANIC option
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260413-ecc_panic-v3-2-1dcbb2f12bc4@debian.org>
References: <20260413-ecc_panic-v3-0-1dcbb2f12bc4@debian.org>
In-Reply-To: <20260413-ecc_panic-v3-0-1dcbb2f12bc4@debian.org>
To: Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-doc@vger.kernel.org, Breno Leitao <leitao@debian.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.16-dev-453a6
X-Developer-Signature: v=1; a=openpgp-sha256; l=3040; i=leitao@debian.org;
 h=from:subject:message-id; bh=bjhevl0rGny8MBH5z4YjsMVd08Vv7Qa3pt9kmLqdPhg=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBp3O8OF6tcX6PKJIBNETopoLJS8dwox8KQs2U4y
 BFoRT7EAtuJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCadzvDgAKCRA1o5Of/Hh3
 bc8MD/9AxahVhWW8Xw4b1CRGc/JOcFzM8uT6pxI5EuHMeo8DCmrD/HLeYtkEmbQzqvIkvCPqiLv
 CvCim+4708mbhR4OP2HuM5+ojhiZ2FWhTT6fl6KVvVFcjzboF/3yRynwezzQtEVNNF2rsjsqIXL
 LnDH/M7W1LH7BbiKy2GzzcqLooGr8+u1Cs0NorzgATzvrw/nHd+Xq6O9m+j34H56tG3nYctQj/k
 faKtHcQr7swEdAPFypQXWDCG1OgoOpzNOMzkz/xhztftSluBoyfeA/13pspc/+PQeVC71DTrfd9
 juJMe5Rmu+SoAdp5MbPNuRU3BOQvqwIgsJ/u6GbXeJUa31TVR+OlsicTlRaVlnTBRy/0MlWOKXF
 bIrNDWWLAImz9hN2G66hqMmDM++3pagzs38I7C0NvTcP5y4/ngLr3DhIvuJFICgooWuAqZJ7C+z
 Z5k+e0mNVkTRRoc9IiufcU2AjCIknGJo/X+WuAV6qPI/Y5IrfjrxpWLHNW1ssjm6OZpy4o0ENM+
 5NMxSOBEiSKEvJK4IdK0Poe7/i34DqFGt0hLPnAJbSjkOkXP42qZdtrauXu29SswtCxCteLLJEI
 cyleZoYrTMKo1w74d73f6Orn9HDOS40Ejfi9TXRWuMVYAPzucjeUVVwIVX44qO/Krc0xZK6f3Tq
 +Hrh9IaHgpTB4lw==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: D521114000A
X-Stat-Signature: i6jwxqztm17kso1pxqj73r3rtsy8fm4g
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776086823-422673
X-HE-Meta: U2FsdGVkX1/H22WiXaLlHqvnfrT3cSiYSnHzxlgihbvvAxaelCENB6BxmGkEQxZDlx2K0sPRFrLx2FLOAABGXFnYs5mMHFRRsA+eJdAxeAsTBLNYtScVGBau7Kav6L/UYn82hiol1Hq87vCQMTu7Y6r/d08LvjFF8BIyg6TAdMeS+bnv2GnvKhyWn87745BmgqrC5a4+Cy60OAe7m39uPEIAwrTAXnNfwe1CQdf/44w+HKbdEwRcuvXy3l7Q4wzj3dzkJZ8YsDrYkAMpGvOm6C2oi7o8qEfj96aYa6tmdHaBhuhesXO96DD5/KWkCylW6+LhRN14Dodq+hgxml5faOYBA3x1i8fN7S36WDJ6t8s1K/TbsFZF054Xuow8h/7v7fBMu9uh+meoqr++r4KG14Jn+0A2pB4Yv0IEFLnzhu/67/E8Cz7GHxluPwBWf/0eV2CwH2nKk0pHw+1lHrZbpj7vpAfBs0AeyPsjG3yaJVP+s1QFzKHVCxDZp7Z3Ee/AMgu1qRUCM1NVmTaa5MfXc3fBRHYWCkzsrLEd17gxWwqR1/J9aiDPCJ/jmy+gBWUsSrBCf+2xn/4Ic8th5XNrPYgdEBA3N0fJWSpx1WldfJQQ53kGQvqHiKdM4mVghWdWunkblslbxiO292AdrC687siVN6w6lTivKpKPR93/ZiEgGtaCP8HzGTwUyjs+rPtCKBuhJAyodKYLjPwxZniovFxxsVAZhk1WB7wpjRKH+DyctIEUJ4d0WsJooeg3bUf5jvarYu+Bkp9v5D+izsAss2s+qokeecqkplvFsy1+EsnewZlbNNb3zSCcPyMsG3493J4zgRRyLzfvlIkKzrfF9Ze1yTvmbckcZgI37+Wu1cRoaGgKkwkFqzXm8QJ7JPDxMzL75uSp3XRoSC75dstoFKvMDz28pKJHfUcC31c7n+bEbSP9KxSoEaGMPBkOKjAStt2uTHZ+98TOh+2gNIY
 zvQJVuiy
 UdUAMWePgTKH4N2LkHAi6MaN0lZ237p1Xhk6Z5qc0E3lD3akR60IcgAgLgSle1czB9gWiY0JnQjuJxqXoN5GFg77G049SmFmI9NRj4QvpI9giW/DRwlPCf78apEO+GTuLMrfBbipkMGiDQckOSidXdRGf+zNwPMEX6NLYhkQcQjCSEQy6sQpkTHPLW6arwhWNv8cz3wNadPki8kfvgw0XpmKqqQGY6siooX3oM5N6uioS2qQ0KQSA9n8p0EOtY1C7mXxlpYEStQwP57cjgLMe1lnVjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a kernel configuration option to enable panic on unrecoverable
memory failures at boot time, similar to CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC
and CONFIG_BOOTPARAM_HARDLOCKUP_PANIC.

This allows systems that prioritize availability over recovery to
automatically panic when encountering unrecoverable kernel memory
failures. The behavior can still be controlled at runtime via the
panic_on_unrecoverable_memory_failure sysctl.

When enabled, the kernel will panic if:
 * A memory failure affects kernel pages that cannot be recovered
 * A memory failure affects high-order kernel pages
 * A memory failure affects unknown page types that cannot be recovered

Examples of BOOTPARAM configuration usage:

1. Building with the panic option enabled by default:
   CONFIG_BOOTPARAM_MEMORY_FAILURE_PANIC=y

2. Disabling at runtime even when compiled in:
   echo 0 > /proc/sys/vm/panic_on_unrecoverable_memory_failure

3. Enabling at runtime when not compiled in by default:
   echo 1 > /proc/sys/vm/panic_on_unrecoverable_memory_failure

Similar to other BOOTPARAM options, this provides a balance between:
 - Safe defaults (disabled by default without CONFIG option)
 - Production flexibility (can be enabled at build time)
 - Runtime control (can be toggled via sysctl)

This is consistent with the kernel's approach to other panic-on-error
options that allow systems to choose between attempting recovery or
failing fast when critical errors are detected.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/Kconfig          | 9 +++++++++
 mm/memory-failure.c | 3 ++-
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/mm/Kconfig b/mm/Kconfig
index ebd8ea353687e..596f24a872ff6 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -733,6 +733,15 @@ config MEMORY_FAILURE
 	  even when some of its memory has uncorrected errors. This requires
 	  special hardware support and typically ECC memory.
 
+config BOOTPARAM_MEMORY_FAILURE_PANIC
+	bool "Panic on unrecoverable memory failure"
+	depends on MEMORY_FAILURE
+	help
+	  Say Y here to panic when an unrecoverable memory failure is
+	  detected. This covers kernel pages, high-order kernel pages,
+	  and unknown page types that cannot be recovered. Can be disabled
+	  at runtime via the panic_on_unrecoverable_memory_failure sysctl.
+
 config HWPOISON_INJECT
 	tristate "HWPoison pages injector"
 	depends on MEMORY_FAILURE && DEBUG_KERNEL && PROC_FS
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 852c595aff108..cf06960b4d069 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -74,7 +74,8 @@ static int sysctl_memory_failure_recovery __read_mostly = 1;
 
 static int sysctl_enable_soft_offline __read_mostly = 1;
 
-static int sysctl_panic_on_unrecoverable_mf __read_mostly;
+static int sysctl_panic_on_unrecoverable_mf __read_mostly =
+			IS_ENABLED(CONFIG_BOOTPARAM_MEMORY_FAILURE_PANIC);
 
 atomic_long_t num_poisoned_pages __read_mostly = ATOMIC_LONG_INIT(0);
 

-- 
2.52.0


