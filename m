Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6750C88E75
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 15:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CCF06B00AA; Tue, 15 Sep 2026 11:13:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A5E26B00AB; Tue, 15 Sep 2026 11:13:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BAA46B00AC; Tue, 15 Sep 2026 11:13:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3DAC56B00AA
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:13:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4379160447
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:45 +0000 (UTC)
X-FDA: 85216341210.14.D01209D
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	by imf16.hostedemail.com (Postfix) with ESMTP id 40C38180005
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 15:13:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=UVmvvAI5;
	spf=pass (imf16.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789485220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gJgHhRIIl4KWjmYsJrJ/t66qyeCS0JmraOWC0c63NtU=;
	b=EMjGBO169zs3DUS2RXWVazlwJacmcdYiZ1utzUhNOYa09qvBql6AwRXbmj+fIxUsSdoSer
	o0Ku6+M5iTqLYA6mfPNLjZfSo3vWDbEzfse855NDiSd0abQN/wmXXTtKsbqMzKgxCdZfFY
	7K5OOJjz1oy8BUg6pGH4pL7sUp/fBY0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=UVmvvAI5;
	spf=pass (imf16.hostedemail.com: domain of xialonglong2025@163.com designates 117.135.210.4 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789485220;
	b=hR/VgDP57Ni9AELnRuX3maYPQLidFQRHqOn43dZJo4jiC69kBTseybkFLnv3+LI7p36yF8
	BLwZFVgwkTIPv/zx/czjb4LTNvbzUonTbIKy4kDn4ujCgQFBCrFG00LcV94GcLcOiCmBF/
	6LsGFZEc/y8dSV+AM9+22942so/LVtw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=gJ
	gHhRIIl4KWjmYsJrJ/t66qyeCS0JmraOWC0c63NtU=; b=UVmvvAI5t10QN5X3v6
	G11JA/ARxS71gpWQSiyxu19Gtx2IvaPkMNgHxzRJP0NShzLduPdhNE2jNtp3IWC2
	XJmGEOXNzyK63B6TgWUI4MHXCVjIRUoQ7Z26xOv4C2NM2Ca4oHwlrij4bVntb0gX
	zI+XOLS50aS3gDi1RKSm5hAWc=
Received: from VM-0-3-ubuntu.. (unknown [])
	by gzga-smtp-mtada-g0-1 (Coremail) with SMTP id _____wAn2xWOYKlqc0VUAw--.40469S11;
	Tue, 15 Sep 2026 23:13:23 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Longlong Xia <xialonglong@kylinos.cn>,
	David Hildenbrand <david@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 09/14] mm/ksm: move the no_vmas label out of the if block
Date: Tue, 15 Sep 2026 23:12:23 +0800
Message-ID: <20260915151236.5200-10-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260915151236.5200-1-xialonglong2025@163.com>
References: <20260915151236.5200-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAn2xWOYKlqc0VUAw--.40469S11
X-Coremail-Antispam: 1Uf129KBjvdXoWruw1fGF15JF1DXF1xWF45KFg_yoWfXrc_uF
	yq9w1kGr47Jrs0kr4DuF43WFZ7Kw4v9r17uryjgr1qg348tr1kGrWkCryIq3yfKrs8KF97
	GwnrJF90k3s29jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU0eRRtUUUUU==
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC2xNBOmqpYJOGHAAA3Z
X-Rspam-User: 
X-Stat-Signature: mxxrrhsog9uwducoy1x6tsagqasui9s8
X-Rspamd-Queue-Id: 40C38180005
X-Rspamd-Server: rspam07
X-HE-Tag: 1789485217-726034
X-HE-Meta: U2FsdGVkX1+g8dp7ltKgQsBouJndy3UdScy5mabkrFzaZG5OZ4qR0rrOLQ4v5ZnjCj1XGTYPYwxYq09yNC+e5c+UUh1L5HCtgoDiV/ICxnObLRupK05pPpquAI4lgaEl1UV1scaU0Pb6WBj06WyfDN2OEUskfQMGqXtQ+U/LPxIfbbpVjoTOeHQdwXZ+ih4h8IUaJeQJcKYB25Mq5fg+kOQaydPtIcD9uk+rOLX55kjihgqG7IVJmaDVr4CMDZVwWPRAg5P+Amm5zHbKsd5VL8w9dL1hYvrvVCDXRzyqKjz3PGR1oeBJDEvXD1iGZC2CgQVUMUsRdEOdPqS/LnnTKLSHDdZMGQlYncCQ81r48v4Ln4DbzgIeeHIWXAhWcXtsKffA2Ree9U2ZgVYHMoKiaI1fDzHcXED3j/x0ERhrIs3T3nHPDr0GKBX29wZhkg5SkWCNjKCiunBAmE6TZ5K2kZx2IgCW4bAoj0avwbGE3/oHFf/PuampDYlDC0b07ibrmLORB/e5COAWSaUVX6+77E9LP4R2mgWA4UC7YcJTTR6I4s7+N8ieYB9Pso0ZjlycqZkhPg4OE3YALFQpKWLBFNBmFXyrhnz0LUKgLhV4Ld71tuQSPdWSvzFr1rqNbv27isLFwVBHO5sN7dE3iBuGh5RL2k87iFYLrE0BcOu8ft1V86CbVY0uio6mVZHwiKLZ339LSw50Z9z7pQSdXhzONmTluT2SWixAJIEjDOuQS4Kh2LMxT1PTMtUc6cM+VSx5WnngRtd6xD9PcbzYM95e18FATkGgCnOz+ZdZBAyyBH7gMXc+BuN7ryMyRHWzK7gp/vAnxVIjhuaZsdaBf377y0IiIC/KLU4U8iVSbInxL62+fvP2PjNBCkvLn9M9LweUCOhYFwCeKDrpjAMJuBeNcinXzjZGdZdmwsjvdBWXDPeCriYoIeF86LNKKozIhAzXs1Eg03KRT+8zOtcTEa1
 ocKQ82K6
 hSfmhd4o2VXxQgByyGxphf21Hiqn4zPaI16dvAbbFB70/mqCLnvgntiWK+//A7FwIqoplRNds6bT7keWf0Kyn40XuHSOnnsACbMScUrqLQ+yB79mrnxHnLuDyyEzB+wWff8V7q5X179txAhVninqEkspW0oH0c3CNfDpZ2E+9svYCRcwf8A6h16OVDM16rcNquQl7CJxNLQMSA+Ua+RC5gnO6+H2MB7O7V88KxpUfpNKH8GZI6RfFP+J8IqLouuv8qEBYrryQmHmF2OIybeAoPlu+Uf2MdWTUbuCBHm66yTEQbsDM+go6M7HJKDVFid2KnCFEa5NIxlFfXzgaz2kwgpImSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

Move no_vmas before the if statement to avoid jumping into its body.
Both goto paths have already found ksm_test_exit(mm) true, and mm_users
cannot rise from zero again, so rechecking the condition is safe.

No functional change intended.

Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
Assisted-by: Zcode:GLM-5.3
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>

---
 mm/ksm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 1733b23cfaa2..59887a2b4406 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2760,8 +2760,8 @@ static struct ksm_rmap_item *scan_get_next_rmap_item(struct page **page)
 		}
 	}
 
-	if (ksm_test_exit(mm)) {
 no_vmas:
+	if (ksm_test_exit(mm)) {
 		ksm_scan.address = 0;
 		ksm_scan.rmap_list = &mm_slot->rmap_list;
 	}
-- 
2.43.0


