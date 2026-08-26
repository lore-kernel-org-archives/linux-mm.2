Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D80EC61DB9
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 01:56:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E4E56B008A; Tue, 25 Aug 2026 21:56:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 095A76B008C; Tue, 25 Aug 2026 21:56:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EED286B0092; Tue, 25 Aug 2026 21:56:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C81296B008A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 21:56:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B246B160242
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:56:07 +0000 (UTC)
X-FDA: 85141755174.15.C227EB3
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf14.hostedemail.com (Postfix) with ESMTP id A6048100002
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 01:56:04 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="T/1+U5Yk";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf14.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787709366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bfrmAVu4e++vOnet6QKHoVDty2xQwaSXpCPJyD27j3w=;
	b=Pl8IzAv/tOnabFkEkAvY1zbu9LSOtmcCVNNFUGSVM1CKjQsIk7MqABcDf3RtqUg/NbuMZk
	IpLTNTWbl5bldWVnd2DbjSc/RbX2wEJjFDAsF7xCUrBEgbgng2PwqYvmn0llaqQP1/Wfi0
	C5/cqwudxnn3WhzhylCx+LLJ87iltFQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b="T/1+U5Yk";
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf14.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787709366;
	b=Utgu7SGhpJBvirARt5xdqcdF/YSbuAGQEEm7Iwhi2ddORbI05hnC6wbP3Qx7mGTzNx6Fjf
	TFQwxW+1VhzA3rkZ7knOJ9un+O6Y4CKV1mA/vgAKD++TqAU+TYPYMuZq6HwasNLa88oHx7
	z/efjHO34GIY5Dm7GMCp58e9fbAyqHk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=bf
	rmAVu4e++vOnet6QKHoVDty2xQwaSXpCPJyD27j3w=; b=T/1+U5Ykh971uLC6AR
	rr8Hbr0kePL/BQb9nRRHDl0+mftwgDuSwysUZE5jQKb779Qs0trIU7GCqZC5PpL5
	CO2gJp23xE/tuU87HcwcR2CCjJEz3AA+/QOsIKvcqfa66d4COoG0EXGh1YUR0v2g
	CElG05nKd+BlJ05TUCjRcKR/4=
Received: from XLL-9950X.localdomain (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgA3bqiSR45qNEB7PA--.60452S2;
	Wed, 26 Aug 2026 09:55:31 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: vbabka@kernel.org,
	harry@kernel.org,
	akpm@linux-foundation.org
Cc: hao.li@linux.dev,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Longlong Xia <xialonglong@kylinos.cn>
Subject: [PATCH v2 1/1] mm/slab_common: reject zero object_size before calculate_alignment
Date: Wed, 26 Aug 2026 09:55:06 +0800
Message-ID: <20260826015506.3178758-1-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgA3bqiSR45qNEB7PA--.60452S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7AryfXF1DZw43CrWxWF15Jwb_yoW8Xw1xpF
	W8G3WDWa1kWr1I9rWqyas7W3yrZ3s8tay7Aa4jyw4UZ3s8Zw1kJ3s5Ka4DW34fKryUGay3
	Zr9Yk3409w1jyFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07U6q2iUUUUU=
X-Originating-IP: [39.144.46.203]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC+BY1LmqOR5ZCSQAA3L
X-Stat-Signature: hei7dw8zwkg9tbp9na6bmd9ez37jjbr5
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A6048100002
X-Rspam-User: 
X-HE-Tag: 1787709364-432211
X-HE-Meta: U2FsdGVkX18f2cpl/awcuEx+hbOUkkskQ7Pl+nimLTXTkEJQgCKnI71uBVzFxko9wil06uVSSBAGwYIhpUGwvD7XbKjtAgYqKm0vsOZLmCHtUIlSeScEtZUwN4JLc9aLVfdz+ugYfQ/UHF4HUqWI1x3h8LhtwHiJEaCJOuEO7zcl2k5dRiC6j1JK2a/wlWSnvPaIq5VYwe9xoARHAqsK3T/mu+tNJtYV+J1iR1VmI04snWrvULO2gF+UIAQsXonA0Aw1u8yamoUuwNBusRaPw4jXeDWEUKsIDOj1edkjj4m0cBWRel6TfKhTiEW+l2JFUSX7Uxo7c/xLYa5INmXPmf7X+OBOaKFz6pzgEh75WZcYPikz912VtN3kPaATud48bF3PmDHRjGyjq/cKk1uoVWW90VsN8VCJ3aNg8Y2CuLi5b7NHjHivlzxKzvczRE/p468BpFigxGDzAoIwfLQiw9ksy6nx1S9LdhRIBczt0WUzbxfwn9xsTw6UPIRlf9BeqYoVR8MjDJlWE8tFjEVCrh+yp0EU7D1gP27lE08yRIf/DIR8Wfd6F7BPBw41eTl/nnDvsF1A1Zx4HYp32H07V+Kpv/ZuS6CK8Uk9Bm+3tl/39Fll52Tsi4czzNWAIw5g3baIRSLMr7ngiGLGEwX6ZRSavHD/8oh6YhUocYTOPVV/MQUnP1+bs4QxGMJ54nPwBQQe2VPKPveLWmzqtRX1WxRrmtd+wyO8ckM6446Lx7w/KVAOTrJGWSgNqh9Xm/DYWpbJRGcnDcluqB5znsCQ5JGFaWaoQxavEG505/uYmbbybMGPIj+1gMx1om7YJw1T5CV/qXxoBrS9wWrts3OBSgueklmXfNf90ZZk4fU1KwznlzcRkCjYCIDQxXeQKYBpTyokxQGkw+icVmGvOkDErz63MIwIQZtKQ0a70gScj8STmhcZN/QsGJmVwp1TtvNGa/QBhRvMyJCmWxkKsCF
 Jv5FtaLk
 DtDsnA5mjLkfyLp2e4G6TJBfqDycWg51behvICwGmKkXsFyhVZUpg3n879Na5CLip5DT1J2nzqXJ6Ci9A0F5nq5BwtUrWJIoDCk2zOtbOK2ujsOcg0cYuXicr48AOConXURGa0EwYs7Jp/WGZ1bQRotKKerYbP43W2hjKcxJk44yeyGcXRGxFdo2O544Oc8yd3Aao1d7eVgQdZQ8eyMe6Q8lJoEfHUHEy5HBL2APTEJrltw00W2rXWOmm05y7k4u7JdBGVPANPZXjKSYE3fzuq1Hy5k7ChK8As8hDAr14gWpzlYafAGbSfM4wNr+4/NI8xuCAft/GXa1gbt+mnPlDiuQIiV7WBuRu36t9f67au3Uz6lowOtYKQbjdp8H+Rd8dwYUZMGyw/SzHGZBqiIHwJKoz2U1p9v5pcKxhOQpujMgoDBZUrKVPVAVAwLmAyEc2LFOuXQLt9bR1HjnERGDLYqt+bpQUv3ICkV1DWZqGN0KLAr0LZvyTSUSe+pOMBGM7RPW0ptJ8s6FVMTw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

calculate_alignment() with SLAB_HWCACHE_ALIGN halves ralign in a
while (size <= ralign / 2) loop. When size is 0, ralign eventually
reaches 0 and the condition stays true indefinitely, hanging the
kernel.

kmem_cache_sanity_check() rejected size > KMALLOC_MAX_SIZE but not
size == 0. Add !size to the check so a 0-size kmem_cache_create() is
caught on CONFIG_DEBUG_VM builds, where it can be diagnosed when it
surfaces.

Suggested-by: Hao Li <hao.li@linux.dev>
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
Changes in v2:
- Drop the !object_size check in __kmem_cache_create_args() that v1
  added to the always-compiled path, and keep the guard only in the
  debug-only kmem_cache_sanity_check(), as suggested by Hao Li.

Link: https://lore.kernel.org/all/20260824092454.1693745-1-xialonglong2025@163.com/
---
 mm/slab_common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 95ddbab290d4..e205a99d85cf 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -102,7 +102,7 @@ static bool kmem_cache_is_duplicate_name(const char *name)
 
 static int kmem_cache_sanity_check(const char *name, unsigned int size)
 {
-	if (!name || in_interrupt() || size > KMALLOC_MAX_SIZE) {
+	if (!name || in_interrupt() || !size || size > KMALLOC_MAX_SIZE) {
 		pr_err("kmem_cache_create(%s) integrity check failed\n", name);
 		return -EINVAL;
 	}
-- 
2.43.0


