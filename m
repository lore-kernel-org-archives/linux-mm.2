Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21555EB595C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 03:29:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CE856B0005; Tue, 10 Feb 2026 22:29:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 57C696B0089; Tue, 10 Feb 2026 22:29:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 45DAB6B008A; Tue, 10 Feb 2026 22:29:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33CC06B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 22:29:58 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B99D8140225
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:29:57 +0000 (UTC)
X-FDA: 84430746834.05.E8F5371
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4FE6E40008
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:29:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=HceFhu3n;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf12.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770780596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Pofqhw8hhVYRB6tvSmJBYOSQQUpinLxB4MYSnGPSGU=;
	b=5MdsSHvxC0qdkzkrcnB44yHOF0/ACX+9MewMg9nkOQ4exXrhATUDeXAIcrTgEc2dNSW2Zw
	bWvhOFkMmFO5D8YLCIg1YFH1CklZajSQADWmdEscZmQJUG4wtPP/Dn+ni9TnjrbnNOpIl0
	aq/QRKPsHAgsfNHz7QMt9OQBqjbWLmc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770780596; a=rsa-sha256;
	cv=none;
	b=fVco2ZSDvopZJdhxRpVNDki38hER2icZapgz/jCYovkVoLgI2+Ff0sY6C2BYGlu/m4Eqic
	bphqfpMEW1tozbQOM7OL8SXLoGMqUvpNCKNAiI4hmqyD+ih9IVak0JBE4EeZ447P6f/ADb
	cdPyrH0NKFS2goPvOdSzsEIVpWC6L4A=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=HceFhu3n;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf12.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=2P
	ofqhw8hhVYRB6tvSmJBYOSQQUpinLxB4MYSnGPSGU=; b=HceFhu3nMRYyko5zy2
	oGVdYUY0A2rx3paMDWFBi9XZ9gwjiIg8O24PLF8VuWKOl55eHYKqAbOVAT3F4dbL
	pH55QEJ5DBwwZRUyml4unUKSe95YlbBuzIuqqldYwNKT9BijQfrNW9FRzHKNs9Fe
	cNcXtTlBJi9ctae7GjgsqBvmo=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgC3f96j94tpMZp0RA--.2981S3;
	Wed, 11 Feb 2026 11:29:41 +0800 (CST)
From: ranxiaokai627@163.com
To: graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	akpm@linux-foundation.org
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH v2 1/2] kho: fix missing early_memunmap() call in kho_populate()
Date: Wed, 11 Feb 2026 03:29:36 +0000
Message-ID: <20260211032937.208353-2-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260211032937.208353-1-ranxiaokai627@163.com>
References: <20260211032937.208353-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgC3f96j94tpMZp0RA--.2981S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7AF4fAF1rGFWrJF13Zr1fWFg_yoW8AFWUpr
	yfGa4fAw40qayjqa17J3Wfu34rK3ykt3W3ta4UC34SyrnrXwn7A3yIq3Z2yF12qr9ag3W7
	tF4FyayrW3W8CFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zErcTPUUUUU=
X-Originating-IP: [117.176.243.201]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbC7gZksGmL96afRQAA3V
X-Rspamd-Queue-Id: 4FE6E40008
X-Stat-Signature: xsco4txnqys9cusp96tdh9oxsnw4ynm5
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770780594-308658
X-HE-Meta: U2FsdGVkX1+KJ2VWK1Y+MvVqVkt4EJiX2S3KakKwvWR29dGpNRgwXDU5ibs1kAVN3GsVx1LLr6137YrHDwyp3dDKlFc3VTzB4VM9Zhqzj6RBgpEuon3MGOyxwVzk0r/dhibCEIRIgClw4h8w5CIeduJ4JrwmdQUz9u/EjpGWVji+zlX/ayY7u3gljoMa8MU9mvr41xpK1lbc8aA3zVYsWCn4c2xma159c7B+heHJX2i7yrIk5U7jz+XbbAWhcdP+44XwDI00iPz+y8uInTqRn0fYcIFztIvHj/UoXMUM5YjRcQW2h8TUToSyblg0Bu5E+BAKNYmrSsiXyio8RP/MuzK/FatABsqbSEinE182eulmNONPq1jw15u0CI2E8TQrAhZ55kEGXiFYnn5qNMfYreYcRmqF0B4+zTaxeRQMPqZNBvNBpGmO67OnEIXQSFglUqCK/q1p31qFzhTM97TY7hfbIpjcXblUcDdbxC8Fpz4zZA/uECUGHaJfD7v7IxvNJmqMTG7INty62raco6x36CvnZAqdANi7+/Shmy6hWRdEUZRt6eC2Ar2MNPm0I4YGprBrIATJJ1ppToZ0DFW8tXFiqPNFWpQvSLNEIykzU/1zjFUAdhUh94H9MGNdI0WO8/JmmxOieyrYxiJAUbwQq7wpSFGmy+bC7sbC33OTA+jTzLc9APOKT1eZWWtDXth8pIBezQRId1/fSTLucIa+NlkDaFSEDiYQ1iR+zJuTJxv1s1N9VFXXVjPSXkqmHCc86/iZ3VOoG28gPAgYps+mnWtT8S0Rvsesl8jM7CUPMUW5ECrisgdbqeRJvOPA+WLuUdfzA7uzWM3sTiiFPb+vg+CIwLeZ+uwOkenjo2D+NQXlKXUychLEqJ5D/ncya9wGyBBtqAfdx6bQjs5hvkVPMExvZOwXZxr9+ulVlF7l/nv01jNmEFYMc5t5mvidTvQmMasDny6R6HihxdVUo/C
 HTSJBVnx
 sG9FzDJes7Yt3YM7fVkTBBu/hvKt3PqQ6F7EHfq4dGv+pGkbb/ao+Fqm98HkUBsH0voIKCdH5YLy/Q4Ia4/oO44z5HVuVts5O35sZVEFov8mH4kDfKjcBbD2mCA/EZsbGUNU4oSDEQsTmIwujoa5oxcfaxCBftwOP3gTRYhFWwdNrKVapUgd9g2Pin/uqMJHUyklbRn2Mt8hEhqACSzZhJ2gXj7HwrzxZR9KoL1Kf2DMJrOkEUtsg3Vcu/zl0PJEJnriXWvBlbhZwD3+xvHONQaLC+w5kq76XCy/Jxhn3QyKtK9z6k/GOzIUKmzZuBGKMElM/+F6qYOiutrFCsMD2FU4bDt8GIakaV+Psllfo5fLQ7sxVQwPY8uv+C5eIFVP83ohieg57qYvzz1F1Y/38w9J2cVOcsFIYQNZXp1cYypsqGDuJDOY7JyYrli7v+L/Z4HLlTfVN/w613YrQzZY0y1e1ig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

kho_populate() returns without calling early_memunmap() on success
path, this will cause early ioremap virtual address space leak.

Fixes: b50634c5e84a ("kho: cleanup error handling in kho_populate()")
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---
 kernel/liveupdate/kexec_handover.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index fb3a7b67676e..3c705b08a489 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1463,13 +1463,14 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	struct kho_scratch *scratch = NULL;
 	phys_addr_t mem_map_phys;
 	void *fdt = NULL;
+	bool populated = false;
 	int err;
 
 	/* Validate the input FDT */
 	fdt = early_memremap(fdt_phys, fdt_len);
 	if (!fdt) {
 		pr_warn("setup: failed to memremap FDT (0x%llx)\n", fdt_phys);
-		goto err_report;
+		goto report;
 	}
 	err = fdt_check_header(fdt);
 	if (err) {
@@ -1529,16 +1530,17 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	kho_in.scratch_phys = scratch_phys;
 	kho_in.mem_map_phys = mem_map_phys;
 	kho_scratch_cnt = scratch_cnt;
-	pr_info("found kexec handover data.\n");
 
-	return;
+	populated = true;
+	pr_info("found kexec handover data.\n");
 
 err_unmap_scratch:
 	early_memunmap(scratch, scratch_len);
 err_unmap_fdt:
 	early_memunmap(fdt, fdt_len);
-err_report:
-	pr_warn("disabling KHO revival\n");
+report:
+	if (!populated)
+		pr_warn("disabling KHO revival\n");
 }
 
 /* Helper functions for kexec_file_load */
-- 
2.25.1



