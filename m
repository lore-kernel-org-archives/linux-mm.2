Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBC74D3B7E7
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8694E6B000C; Mon,  8 Dec 2025 01:29:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A53E6B000D; Mon,  8 Dec 2025 01:29:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D5FC6B000E; Mon,  8 Dec 2025 01:29:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4ADE46B000C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:29:57 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1413C52F4D
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:29:57 +0000 (UTC)
X-FDA: 84195328434.13.43EE534
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 79BC480006
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:29:55 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hJbqzxQ3;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175395;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s95R6Hh6was1wv7czFzQ1MIp0SiF5h/6rFW+0rq5uXs=;
	b=MaD+K3Ym1/Lr1E+fyxpf1dXDK4pinSfE8sKyJt3VrUAkZ3GxddXXSgpZEBEERTFGaH3+1K
	0t7mvmvn9s073niyedYQvmKtsY56rEWhzYKOhlsttyXJSH3a/eCfBfF20aaaw6jmy6au0U
	FT3mkW0d7LUV4E2jgToDQh1kx+HzUCU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hJbqzxQ3;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175395; a=rsa-sha256;
	cv=none;
	b=1TMq/xC5AAVdn3/m/LBK+sc38KzxQl3jGHnXd6T+nRQ9G+ZyXfSmByVJIMou3ygvr/81aY
	CsF6lrrggxDkhplaup7y4WX+jA1L8NTp3EtU5MMRsJNfQ0FAIId5Oug1ESvNZG7Vxjvkb4
	OR5sLn1RVa0wGnlHBikha2SXaT/9mUw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8451D444B8;
	Mon,  8 Dec 2025 06:29:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74180C19422;
	Mon,  8 Dec 2025 06:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175394;
	bh=kFi2QDyr9gKqWX13ZWpeGzoNVnWkjkenFzPE2s60nLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJbqzxQ3L/kD9luw3CSq8MIwgYAnTHw91s3JR6CQxPmXpWLZDk9ucr52+clZQuhB4
	 NPONyYD1/kreuAywtWnRDE8VgpdBCJWBg4QYHlRImB7iid3jVey8RsDS3PRnBgLSlE
	 bBD8C6Y8uyKD5vA2xbaYihb9+wTBEPj7j5pc7Q6CJGSgO19ln82nPsM/qv0n0Dxbwq
	 s9uHC4Kw17oKl1ssnFBk/gwkiCI5Fm7bvaxxebxjNleC1964qm3R9Iz6rcqIBp7VjF
	 XxhxBmyInnw+Ud9km5Gp7nIosOoMDcLIbfDGy7sKPcU8CJ7jPpEvVRhIUEA1wvVFf9
	 M0sudPLy74hHg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 04/37] mm/damon/core: implement damon_report_page_fault()
Date: Sun,  7 Dec 2025 22:29:08 -0800
Message-ID: <20251208062943.68824-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xengtxe4iiefz193pi1uxn31sib3jz9s
X-Rspamd-Queue-Id: 79BC480006
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1765175395-709225
X-HE-Meta: U2FsdGVkX1+pSTemqgNmwqh2+zBWEtNPPax/4rXjw1/hxQfBm6X3CO9A//ZOK3Q7mCp+XjayZpcqGHMz19I9CC+rdpaJXYuGpgbSDgIQ7iIMe1qQ0zI54uxgzj2ulAUGIuFTISHolzc64EQfURSOBuinm5HVHB9S0Xb17bYm7AFzcYiL7G5GvSsEAcS3uLvqqkgQ42zeoEialwJClf9ll+EXsDWArN6lujLziZovvo5E1T/mH5ykqYoIRmU/RHIv5p64FiznnELN+s06XOWO50RouOhtHxaC1p+unUHvQ0mozcMUFtb4BAFQYKbk1lmuAuXrDOALlq84T3Jdl/9Z4Nhh6eiElyHPQ0PYVU5f2+rZx/nj0qnNhFDJtpJ4gDaXHdEvE8fKexiGUdyhml1I91gfxBbzDtx9jPUIh5zA3iTwMJLOlCdVkuXHUvprR+sO0LU1npkEBNK6atq1qIQui8ebRP/gy41RJJ4mVXIhBmU1EktNuK5KtRtSjRkwtfY2uLLHmw+gm/kASm2KFN85X183rF6rf1q4/6QP9/rBv+uM7hPjTBHKzqM+5GvE/UOILWzsgTYj79LxRQochIZ9u/UurRbMwgIji4teC4ouQSC1twFZ4z+o4W52iVZvjZpDdpw7a+3BLhNe85jmDj856zjBXnWnAVor6MFOxd72B1npTHNz8k3DP6P/dM+6hE1Bv9QYJsP2YYEMncU9JsDhBlePZs3Tg+KGcBvm8/qUOtbwiP2Yz+07WIfOb2ax5pRjyasqY61bU5GVGmgyn+KtgHCo2NwLGXlYceTaf9TnA4NpyTa8y+Cpiv9qS51FU7Dhzv45HmswHPUwuv4zywPF4/P5bfMQlKezGZ7eneWkdQQ5Xlg6BMSBdjLG7COpcdu/Ddt2GhbQLg+2ir+zTlzPndphGfWkmveNZOt3QKsO0j3zh0unU40wbpPYbaYmdOmEX4B8vyr1/43a6t31t3O
 Mgyb2Y4k
 Oz9BoZ3wK+M0YZKEw32HrKEFMMa8MzWub5ZxcrMHqC8QA+HW7r2dzrEfT4xuE6/jzWGc+Yn11UFzxuoqsk0Y/c+m5lep5y2yq9vFe1espPf+WxN84XZgD3/qLyz2tzmHouqwMPTDFbFxfyoTsxO/DLojaO3IByBt1MXEu71/rcU5jM72qXzZnUosKn6XnR9n4JEO3uT50ri/HPi3suXn35ckXwNeNnyNxyt7C/EGNgpuHZ6ykhm9WhTweu56tzhuP2wq2Cu8NM7FvJ9XSM20k3b+Fbwl+eTxfEtU5R+MoHq3X1NfRxYJ8zheFXTgOqaW6ves5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement a DAMON core API for reporting page fault events to DAMON.  It
is a wrapper of damon_report_access().

This is a temporal hack.  In future versions that will have no RFC tag,
only damon_report_access() may be used.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 10 ++++++++++
 mm/damon/core.c       | 17 +++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index b9359c76a6f1..b8ebb2aa02c8 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1017,6 +1017,13 @@ int damon_call(struct damon_ctx *ctx, struct damon_call_control *control);
 int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
 void damon_report_access(struct damon_access_report *report);
+#ifdef CONFIG_MMU
+void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd);
+#else
+static inline void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
+{
+}
+#endif
 
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
@@ -1027,6 +1034,9 @@ int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 static inline void damon_report_access(struct damon_access_report *report)
 {
 }
+static inline void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
+{
+}
 
 #endif	/* CONFIG_DAMON */
 
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 89305d42e116..296117d5e7f7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1579,6 +1579,23 @@ void damon_report_access(struct damon_access_report *report)
 	mutex_unlock(&damon_access_reports_lock);
 }
 
+#ifdef CONFIG_MMU
+void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
+{
+	struct damon_access_report access_report = {
+		.size = 1,	/* todo: set appripriately */
+	};
+
+	if (huge_pmd)
+		access_report.addr = PFN_PHYS(pmd_pfn(vmf->orig_pmd));
+	else
+		access_report.addr = PFN_PHYS(pte_pfn(vmf->orig_pte));
+	/* todo: report vmf->address as virtual address */
+
+	damon_report_access(&access_report);
+}
+#endif
+
 /*
  * Warn and fix corrupted ->nr_accesses[_bp] for investigations and preventing
  * the problem being propagated.
-- 
2.47.3

