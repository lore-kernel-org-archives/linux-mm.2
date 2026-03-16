Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FA20F46453
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 11:56:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A6F06B020C; Mon, 16 Mar 2026 07:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9517D6B020E; Mon, 16 Mar 2026 07:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 871626B020F; Mon, 16 Mar 2026 07:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 71EBB6B020C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:56:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C0DFF89140
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:56:33 +0000 (UTC)
X-FDA: 84551773866.09.7F3C24E
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1354B100010
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:56:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=dDQO5U45
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773662192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BIYteLscNbuJ8M2TNSr6zCYdcchlP9A8lbucS9J/eKM=;
	b=2ofCMhgQTd5oxy8Or9w9Viu0J+larE9z5P+UOn392421aLb/rB24enxIfyWsSPHt+gwYUk
	uk1+ncdgEjgCIsuvhk9zwMXAWZ4EocBiNT4RTXDeHVIp3A8qtJguGsHBPH1X+j+FqV7b4W
	2I+WFwLzWL9fRcES6n4u0W02Ufcngkc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773662192; a=rsa-sha256;
	cv=none;
	b=7cXslfcis6UK2YL1fGnREcjqkFqi/elnXE9YPdmitMByaxxNknA2DDpEd/espCJ13jb6cE
	vLqbb1S7zCkz3ykvT3qufjPpylJMIJC/TvHIJj9BI7ApwHXwU+oW2wjX1fHOUTzCdy7XGB
	xY3rRogqUHjlm8Z2MxcxlOlxAshL6Tc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=dDQO5U45;
	spf=none (imf05.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=BIYteLscNbuJ8M2TNSr6zCYdcchlP9A8lbucS9J/eKM=; b=dDQO5U45OCJInWUfMljGpNPgtG
	RwOlhLLZ/NVovVcj0BZxiSxD3u++sO4Yk0hEPH9w78eUOSub5y59p3743N7mO61WsJNaiWMt1XLCm
	51I0YretIcEO314uOiH1306FlRQxx25idisr0wDsQi4B3zLwmNNN6SvJWiw6joUTXDvsiUEr7ez83
	pD0aCItoagki9+0ZHpllMTrHb2O6+F2JDvwac6dx/KNevobmOfoL+7O7yNqK43QltNEBdZpoJHviW
	HFNnxNjmFDLKtPkJBTwtkrlCcqN7P1aQVgCeN/vHnpLtgHOvy1gIPZgTkHDAAzeXte+fCih66Ukeq
	40SgN6Vw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w26Yh-002600-Pc; Mon, 16 Mar 2026 11:56:30 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 16 Mar 2026 04:54:36 -0700
Subject: [PATCH v9 6/6] kho: document kexec-metadata tracking feature
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260316-kho-v9-6-ed6dcd951988@debian.org>
References: <20260316-kho-v9-0-ed6dcd951988@debian.org>
In-Reply-To: <20260316-kho-v9-0-ed6dcd951988@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usama.arif@linux.dev, Breno Leitao <leitao@debian.org>, 
 SeongJae Park <sj@kernel.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2537; i=leitao@debian.org;
 h=from:subject:message-id; bh=Hlw5chBPs/GGmVd2Vfxvsk1mq2UGfEKb5hoy1/gHS0w=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpt+/R5Ez+Wu4VpdqaIcba4CabNLUTikRuvc4JA
 kTxLX2vZ2aJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabfv0QAKCRA1o5Of/Hh3
 bZAvD/9v6OGnwOodgkswz4dXFI57BWYERIzbFFV8eyQEWwpYnEMvn4ucpEsAjnFtM3axRJvRZUQ
 zgtWrLUsGbsh6s/uzr7aNyorRMRMZgHtV2uPH9CwOzzeSuPU9KA+b/wg8i3QvsxKGYL3Twxp4Ma
 YnpTsVVYeOOzWRRbB4c/FmljQfVDpxkAvi33oKRYKxNXLQGJIZ1ffcnocBeVekqBJVWfltzSbuQ
 j3T6H8Lyyr7Iim59ZGeCACPdS1u/8vAz/zhFTIBeJxx6UCsdlpP5zK41ydlaOSAXoAhYtEckezK
 uuq2wrS5CdfYOKvH0K8qrf1qz0hxOseu3CVyOOgr4F/on1fmXkIpzh6+Gnjk92u9/W3UBho53HW
 QyXG6m5ZyBm+GWLTt8JbKCSRgTNIqwbC1bG2G9k7/CmhKDvWYI3eFkWfB9lTCQJoG6krEE74cTp
 vrhH9++h8XWFvj2Dwv5/xf8m9AltqFtKYS75RbhghrDxk+67/lWWVi3WDjxRhsmTgc/YgUyKZgS
 jkvyiMIDMiN8ewfgrfc+2myP0z3x5fNixbklx5B43LKvRLj6ulHHoxfux8nnIVjdoJaMo1ojCnB
 thkFsdEdhNDenMvPgUz4OfGYQNQGTicZumN3qLD+HWWKBxqrchmwlR2ByMqljUd7JUmu+csnS4n
 UHR5TfwPVACncRg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1354B100010
X-Stat-Signature: fu38kqemhyfxjrg5hhhfamscp366sh95
X-HE-Tag: 1773662191-448562
X-HE-Meta: U2FsdGVkX1/wZ7qmnRPeOoP52R/9WykQbgP8pYY6nmKcLCJVFWZi8J9Xg00NaYqVVxMjGRfRseSd0BMMJaY2SYnQMq4hf3VRGTFP+oqmhLqqlZsrFn/jjMgwQWgwhNhOMxUg7TWTyFNY21pfe2bSkst1Atu6r636ggYtCYhGRiAqXkCfzYROdHbtUuMsZICij2cEDXupA8EqXtk8bEV+wI28PKXq+DJ7+iGfF9uOMih4RoO/bYmBp4V0vBVpQQ5aSoiC31PX0DE02XLvjW1YqqnjTCVnj2niREdWFvrK1w1/m6jvpdtyrGCgaofXjSlcJ+cFRHLWtGf5uS0SGDCMarHjv97O1ayQAiF3g5VeuvmHRRkvGta8CykqGHD0k1MYOgXV4QcueQ4GoMkLj6cAJq/VsODmC3kUZxU8BkJ+Z8NDISYIv0hH93uDDrMEi67U6xrBrse11UGXXCsl+duNORfNC1nLFBClkPNZuAYTrJO+cTgwt9BWrenY3j84OiAWGxa9AEnwcuSR04q0o312owBPUdjcqZoe3eFFD5iid4nmIb1iC6OpnSzA/DYHBghT2XxZE2cYxjSGW/IeOMQ1EsC6KT+62RkbbKTD7EM5Qr8AXyu8K+eYoBs7a6F44YlLak5fLc+1NkpjySvT+MxZ5ERbhzUWSG/d8EJVkAIFBUCn8FUigYwzmnV/pj/Wgi0kyy91U/5Mldz3dPwIulqu4Rm8/LYJQI/UHRNR4q+CuEzn70SEJe9Anb86mCxw0eAStWN3BlvPINXHhGV1aBEU9Iw+PrOnzKiIUAbU91VyHrTSxJbwUsAovQ==
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
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 Documentation/admin-guide/mm/kho.rst | 39 ++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index 6a4ddf3440465..2c26e560bd78a 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -42,6 +42,45 @@ For example, if you used ``reserve_mem`` command line parameter to create
 an early memory reservation, the new kernel will have that memory at the
 same physical address as the old kernel.
 
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
2.52.0


