Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 40B72EB28D4
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:23:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7E2D6B00A4; Fri,  6 Feb 2026 02:23:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2C476B00A6; Fri,  6 Feb 2026 02:23:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955726B00A8; Fri,  6 Feb 2026 02:23:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 81ECD6B00A4
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:23:06 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3A43ABB01B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:23:06 +0000 (UTC)
X-FDA: 84413190372.15.65C01C9
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf25.hostedemail.com (Postfix) with ESMTP id 923CCA0008
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:23:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf25.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770362584; a=rsa-sha256;
	cv=none;
	b=rwpqiUK72CII6bgmmqRmwPoN+eO/mhsB7qZNKrp5boDDJEGeKPifWrGx7Nag1aAtVL/ibs
	6XQeHSjV1aA4GnRMwBCvENF+HiXgXA1pY1/jOXWeiLCc4/m54h6jSqJ/0jSzS4NqYYenK5
	4W4YY96+EHgh2bD2Zhe8DAXApvKK0l0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf25.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770362584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=eBuj0vbkTKKMg4MIhDhwhdoqmc/3ADOZXHdQ6lvA2iU=;
	b=YxcaJkpiHZTt2DwwVraxwVWW+W7rrLgzO55h/xxspCfSGc3VhShckQapVV7b2kcri+9ch1
	xpSDMUGiQQmC+xtCd2mmaY1/8wFXR9eJg6fcUcVmJ29wZ9Wx+fVUCntGrbxyZ1UiUPAHRA
	LzpvW1WYYJ6eEu7xTmk5gSVWvPqg+7I=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4f6ltD52f3z8Xs76;
	Fri, 06 Feb 2026 15:23:00 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 6167MqV2092085;
	Fri, 6 Feb 2026 15:22:53 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 6 Feb 2026 15:22:54 +0800 (CST)
X-Zmail-TransId: 2af9698596ce468-f88b6
X-Mailer: Zmail v1.0
Message-ID: <202602061522548871ohgXN8z0qq87sTSX-yZc@zte.com.cn>
Date: Fri, 6 Feb 2026 15:22:54 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>, <akpm@linux-foundation.org>
Cc: <chengming.zhou@linux.dev>, <hughd@google.com>, <wang.yaxin@zte.com.cn>,
        <yang.yang29@zte.com.cn>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?a3NtOiBpbml0aWFsaXplIHJtYXAgdmFsdWVzIGRpcmVjdGx5IGFuZCBtYWtlIHRoZW0gY29uc3Q=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6167MqV2092085
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Fri, 06 Feb 2026 15:23:00 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 698596D4.002/4f6ltD52f3z8Xs76
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 923CCA0008
X-Stat-Signature: zgqqmhhxhussjgggksm5f14c8apz79qx
X-HE-Tag: 1770362583-117770
X-HE-Meta: U2FsdGVkX1/hKUt0+xLehvHDqDZUg33tU+DC/1y1Lty4gxrzc8nXVaCt7JTXZpvdpPrjSUth91tGaktzw2//Buf5iNLUbfH8dlk9PvyXic2isNxCox5/Fo3Qvbaezly5MY0a+4B1sbOZYkTSsq/aJYy3ay+INdbNBfxf82tgOPUdHBX9jDgggAUvAlwQ2nl2i3CHjt0eOYthVaeKSBtcYaXca/gwTMhjyY1TlrzUa7mAzZzyn+fc3YhIpg0WMrWBeMxweNrCF5IZGTaD/B2XzfdFs3D9AFRc08I4BKgVSENBTi3NjGAhgpb8C135jCvv3rB5N542gCtdPx1tUxmSsnlmYOTFRYvp3jKD92pNG+W4ap+uZqDh6NH/ht4W75IfBIV17GhbEUDl/Aao7UV84s2VSMi5cxMSjwGQbIBqlSVrQQ1k1LGhT9Evux8kOxRUp44w48hd8/MzFEfTqBfXLH9cJBwtYbFygKNwSEF40ABtPcLV6MaRUZUiFOi7DZNQh/EKoHwszJ8/4bFSgxNNwPeT+ADPFJLZFDKXdi7Bi40usw1R5nOhiKp0tFTG5tNYjqqLtMNh+Gd9GgNuAssKuNHqPmRGX3MZINdJa/v3DUzH1e4KDz5BBBB9DaR9zipt8JGBOs2jCTTHTiu6CvMkDihVpsynduW1fnw+ujU0A5jvf/z6hcbBs4njuHoEL2LQ4VQc/urNy/GbxRKClQWeIMda7dn/Zu7JsgiGNuC4LXNiiqj1MIVSQ7PqN//FD2HP9/eI01Ubx3arn95uX115P5QzQvd4RLfx4bDz2QUTi0RLy989x/3x9OWBriN3mrS8A/qsL7vsLZE7Im0Mxhpu/NPMnTVnHIs1pho+RUogSMTLkVRnA4WyHpZFE17B+esM6upXozPPz3puaFnk0OetbE9mY2+OlwO7JyNLBQ/5s0Kle9jyVZXO/dpYPDTBDs2brH2RnKUdBamo1qxHJLE
 IUCoknmY
 SO1XmfWky/HnGt8kwOYfD0jbGe4v6NUqlkL4eTPIkXzhNGiQL7ZgOF66ZmkvYIKBb0bMCtpP5aI8TANSYvRtvmawtBJ1rqTe/cJOblRJP9Dc8rAeZm0YNPQYSjz78A8DreFZptNdUO0stfFr6DSKUgaaA8WevR1wnjcBWR3Ej470eqx13YxjUo035XjHQf/zkf0xfk4iitTkkXsn4xGWup3PTKlfttTRwLPtunjhP5Dtg78Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: xu xin <xu.xin16@zte.com.cn>

Considering that commit 06fbd555dea8 ("ksm: optimize rmap_walk_ksm by passing
a suitable addressrange") seems to have already been merged, this new patch is
proposed to address the issue raised by David at:

https://lore.kernel.org/all/ba03780a-fd65-4a03-97de-bc0905106260@kernel.org/

This initialize rmap values (addr, pgoff_start, pgoff_end) directly and
make them const to make code more robust. Besides, since KSM folios are always
order-0, so folio_nr_pages(KSM folio) is always 1, so the line:

	"pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;"

becomes directly:

	"pgoff_end = pgoff_start;"

The test reproducer of rmap_walk_ksm can be found at:
https://lore.kernel.org/all/20260206151424734QIyWL_pA-1QeJPbJlUxsO@zte.com.cn/

Fixes: 06fbd555dea8 ("ksm: optimize rmap_walk_ksm by passing a suitable addressrange")
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 mm/ksm.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 031c17e4ada6..c7ca117024a4 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3171,8 +3171,11 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 		struct anon_vma *anon_vma = rmap_item->anon_vma;
 		struct anon_vma_chain *vmac;
 		struct vm_area_struct *vma;
-		unsigned long addr;
-		pgoff_t pgoff_start, pgoff_end;
+		/* Ignore the stable/unstable/sqnr flags */
+		const unsigned long addr = rmap_item->address & PAGE_MASK;
+		const pgoff_t pgoff_start = rmap_item->address >> PAGE_SHIFT;
+		/* KSM folios are always order-0 normal pages */
+		const pgoff_t pgoff_end = pgoff_start;

 		cond_resched();
 		if (!anon_vma_trylock_read(anon_vma)) {
@@ -3183,12 +3186,6 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 			anon_vma_lock_read(anon_vma);
 		}

-		/* Ignore the stable/unstable/sqnr flags */
-		addr = rmap_item->address & PAGE_MASK;
-
-		pgoff_start = rmap_item->address >> PAGE_SHIFT;
-		pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;
-
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
 					       pgoff_start, pgoff_end) {

-- 
2.25.1

