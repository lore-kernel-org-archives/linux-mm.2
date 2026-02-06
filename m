Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1BC9E9129D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 04:31:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C973F6B0093; Thu,  5 Feb 2026 23:31:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C41946B0096; Thu,  5 Feb 2026 23:31:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B44186B0098; Thu,  5 Feb 2026 23:31:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A6F9A6B0093
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 23:31:56 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 384C31B2C2F
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:31:56 +0000 (UTC)
X-FDA: 84412759032.16.CAC0775
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf24.hostedemail.com (Postfix) with ESMTP id 56920180004
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 04:31:52 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mSAH2xIy;
	spf=pass (imf24.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770352314;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qr3LVoOJqpEYjoT7a1xDOpnKMJ8q6Fi6UAoB055FyKQ=;
	b=BVE4ERgLZU5r0CsUU9C4l1QZppyuGr1fzrdRQgR7290fnrk+FBT+00rOvfIRKKUdvdI9rA
	3MdCF8UuTmKSYP8IM1ybO+6t8CTMtU9nN//IdyGkkPp8rly0ZttinCD1WtbgE951iVTd0j
	xZ5ON04Q4R9icBrzvH0A+ZWCpFClTk0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=mSAH2xIy;
	spf=pass (imf24.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770352314; a=rsa-sha256;
	cv=none;
	b=7dnmijCpBSx+jg4RN6kIiKoXMRyGEuRkOAysgaWP5oVCs3Golpvy95hDwEN9i93jPyoKWd
	dzUzy/KlBlVzYedbW++Dr/uFOw1ciQclhKOmyAeNGil7SSthPTVb/y3Ot1sXl4GlyOHrhq
	nKXj9yiPU7EUJRU9b+lihcHAJMPdjx4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=qr
	3LVoOJqpEYjoT7a1xDOpnKMJ8q6Fi6UAoB055FyKQ=; b=mSAH2xIywMiN4NWJgL
	oOlitNnqti8W2haqwcBKXPNlMx1EiG7SwjW2jaRZuCxYTK/j/a5sd3GunkLRLm/o
	NBSx4t38ylHfmq1ihvSmVXS7ELxqMcQwF15NHKXOx5w8jVxh1SBI9/C0bODLhaGK
	fNdM0czovFKpu2KxaSMOyUe5U=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgC3sLWbboVpASh5QQ--.27597S3;
	Fri, 06 Feb 2026 12:31:27 +0800 (CST)
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
	ranxiaokai627@163.com,
	stable@vger.kernel.org
Subject: [PATCH -next 1/2] kho: fix missing early_memunmap() call in kho_populate()
Date: Fri,  6 Feb 2026 04:31:20 +0000
Message-ID: <20260206043121.197564-2-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260206043121.197564-1-ranxiaokai627@163.com>
References: <20260206043121.197564-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgC3sLWbboVpASh5QQ--.27597S3
X-Coremail-Antispam: 1Uf129KBjvJXoW7AF4fAF1rGw1xtw18WFWktFb_yoW8WF4fpr
	yrG3WxCw48Jayqqa17J3WxW34rW3ykK3W3ta4jk34fAFnxXr1kuFWxX3WIyF12qFySgw12
	yFs5tayrW3WkCFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0zErcTPUUUUU=
X-Originating-IP: [117.176.242.230]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbC7R9+ymmFbp-e1AAA3R
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 56920180004
X-Stat-Signature: 796f9wb7hhw1pzpncdoh19rwgyg44z3u
X-Rspam-User: 
X-HE-Tag: 1770352312-26432
X-HE-Meta: U2FsdGVkX1+KnrcgtsJdDUAMJEbNetdNHf+2F21+iamEW8hRxaIfKY9RhY68QWrPgUDoKMjXR+puc+u7wkPwn8/UWYOtp85ImMXXa3OagyEpXghG2Pw+0Sd6PD6x7+Y2OyPBrLdZyrd8bz7Ltp8HL8wOP7BgEMEzgmQFt5gfELCiS4J0SqaE54SCApv79ZKYWLid6eaVMN1yl0Nj1YYl0iMRBzD7xO/TFFHeTR7vRiUqz21WoLH5w85ZiQMw3Q/kXxY9GMS4uGjdh6MW+T+twp90470QO1lf9nPSdAK7MPPLKd8mhEMm1Kk5bQ62wyAO/KpXl8gcv4TLspUAsN3XdInGfDOev1AnCbV2WTXWX8J7vvn56qzps2QviXwT/Ux2VyJiqS/DK+FBqRYTE2NU4EYOukIEqXWRnaqxYbejcAyxbmlHIo1vYri5ZLJUGpxTrhhvypYdlW7Uu5MyfqL+P3gc9ovSeMxfxmMZpzEM3dhydu/cTrrJZkRkm64/0f7/ot+k6ImKs+J41wLnfS+i6ELkVY5X6PLazlPjyTecRUOnLUrZF0BDCkUpP6X5KtYKtME3v8degvV4D93TtU6GZRqRoCewx1pArIU0gxev5fhb1Z7S69SfyMgsyqzQsWkWzZGAJNxyCYPJgH7jt4wyj2MAMlBmlupPZZFxQ7nmmempAFq8J3JuW07xM0ckuVaZWF08wmg8YTSmpNoSDTpm1450KFhXkqcxnVw6Af65d40NodiBdIXnCc6qFQCbVfMgu0aQLJZMwdt3d21kPOu29BffTIzMLemURDuZmc/z/y38i7gB4zrxOjueDlDtcgWLe8EFYID+Wled81/w8v9C7D0c2rWVFJ+E7ASr4miawRQsyYcQ5jZnP0VLhZGBfzHS8NrzgryNJVyOzxHOvF2idC1DCa63YslcIpQll5CEuZy12i+vzPXV/xHZHUoQ3MkYJE/OXEUpXgwgB03tC0o
 AkUBkcO2
 eMlXXODC+j57joNrd4YkQjI+ozUrMRAB25ydHIFXY58rf0arG2KKpAQf2c+BviLNrv2LUj8chPpoB6b9OBZhU6y4EV6FSjo1kGYce2O0LkYJi55aaMJ9UecoD9x4pKKZMuKB74NW6g1hQTzQ1+32h3g4YDOhMlXuMbhO+1VoUCuiHcst20/kYYhO09gvcCHrwPxfyPkqkA3KBjUckEWfKUzD+pR2sdPf9paTgOu1Gm27FuivmWS5z2nnxYkJVXNfLf7yVNXJankH7c5wEGkSqfp6XZeh4V+bEzIx/8mJIDxPgoqVYFOJ12ngbU19Gg5CyPrHWSQBJ5zJrQE5r2LX6e86Wt5xNkm9zykHcvZrNG7nUAa1kawOjh9nvGPHesIyaGERqHkunX+NT3clLT5KLE+oURrrQ+w0JPW1ZxnasBKG1MZOzcNnuiVYTF1ir1P+920rCWbj99JFDNgtGcf9Kf6/J5w==
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
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---

b50634c5e84a ("kho: cleanup error handling in kho_populate()")
has not landed in upstream, so
Cc: <stable@vger.kernel.org> is unnecessary?

 kernel/liveupdate/kexec_handover.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index fb3a7b67676e..76b714db175d 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1463,6 +1463,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	struct kho_scratch *scratch = NULL;
 	phys_addr_t mem_map_phys;
 	void *fdt = NULL;
+	int populated = 0;
 	int err;
 
 	/* Validate the input FDT */
@@ -1529,16 +1530,17 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 	kho_in.scratch_phys = scratch_phys;
 	kho_in.mem_map_phys = mem_map_phys;
 	kho_scratch_cnt = scratch_cnt;
-	pr_info("found kexec handover data.\n");
 
-	return;
+	populated = 1;
+	pr_info("found kexec handover data.\n");
 
 err_unmap_scratch:
 	early_memunmap(scratch, scratch_len);
 err_unmap_fdt:
 	early_memunmap(fdt, fdt_len);
 err_report:
-	pr_warn("disabling KHO revival\n");
+	if (!populated)
+		pr_warn("disabling KHO revival\n");
 }
 
 /* Helper functions for kexec_file_load */
-- 
2.25.1



