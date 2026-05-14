Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96672CD4846
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 03:24:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B92216B0088; Wed, 13 May 2026 23:24:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B42EB6B008A; Wed, 13 May 2026 23:24:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A58856B008C; Wed, 13 May 2026 23:24:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 939256B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 23:24:07 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 242E4A02B4
	for <linux-mm@kvack.org>; Thu, 14 May 2026 03:24:07 +0000 (UTC)
X-FDA: 84764581734.25.27C1197
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	by imf10.hostedemail.com (Postfix) with ESMTP id 642B0C0004
	for <linux-mm@kvack.org>; Thu, 14 May 2026 03:24:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=O2GvS9xv;
	spf=pass (imf10.hostedemail.com: domain of liuqiangneo@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=liuqiangneo@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778729045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GV9clvuyPkthNY9ct+wRWBAAYfXBWNB1V77YD8eBwdQ=;
	b=t9HU6z9zwij5L4ueqEB0GmYxDBV+MwcDxhfoaVysV9BBfmJx7Dzuk3sPL0lmeLsF6ECRG5
	DsM8joir+96YXmMg1SbjqDRSNHx63IMftbnhYNNJRC25FzPFKV1URQtSGzqpNcVV2+UQBV
	0ZdHXHb68FJxHRXS6bYYNsVnJv76yqg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=O2GvS9xv;
	spf=pass (imf10.hostedemail.com: domain of liuqiangneo@163.com designates 117.135.210.3 as permitted sender) smtp.mailfrom=liuqiangneo@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778729045; a=rsa-sha256;
	cv=none;
	b=i0MqRTsTjbkfjg3cCXm4pQFI8xVIz0Y1KSXyuxt1Cz35ksiHcBbO/564o1ohrbqopwbEWY
	IfVHx0yPCso8Cp+/mheEznpNZXDugXBBoKMcMNHAnuemkU9Xd7vjd/hTSgWNvaGX5iISLa
	i4dadsPcN8ITpkABVAcFqXYogRZCQjU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=GV
	9clvuyPkthNY9ct+wRWBAAYfXBWNB1V77YD8eBwdQ=; b=O2GvS9xvkUN39QzrIU
	ANW5aPrZOY7zrdH0JYwVhI5HxxCKz4RGGUMhwaDydOC/u5yXTHVc2oE8KRevjGcd
	ssUC34KcbwR43qctHbIrgI6ysvP68h51Tbb1flszfQRRKUdm0v+PMTRwEhjNUEEy
	UwiA903xXJ62TPCR3SO3NXbCc=
Received: from neo-TianYi510Pro-15ICK.. (unknown [])
	by gzsmtp2 (Coremail) with SMTP id PSgvCgDHz0FDQAVq7k7lEQ--.44394S2;
	Thu, 14 May 2026 11:23:48 +0800 (CST)
From: liuqiangneo@163.com
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qiang Liu <liuqiang@kylinos.cn>
Subject: [PATCH] lib/test_hmm: Check alloc_page_vma() return value
Date: Thu, 14 May 2026 11:23:44 +0800
Message-ID: <20260514032345.32256-1-liuqiangneo@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PSgvCgDHz0FDQAVq7k7lEQ--.44394S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtw17XrWDJFW3tw48uw48WFg_yoW3twb_ur
	47Aan0ga45JFn8Gr4Fyws7Jr4Fy3s7ua1xuFnYqrW3ua4jqrs0gw1DJrsxJas8Gr4j9FW7
	Cr4qyr13A3sayjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU189NDUUUUU==
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/xtbC-AT8XmoFQET25wAA3g
X-Rspam-User: 
X-Rspamd-Queue-Id: 642B0C0004
X-Rspamd-Server: rspam06
X-Stat-Signature: mritpytkjsppdb588rmbjoor6jen9gh5
X-HE-Tag: 1778729043-591003
X-HE-Meta: U2FsdGVkX1/0HyoBAUCXCl0LYK8Jic1f3u4LeuSvbtT/tF2kIzqWkwAy+3daNxt4BP4HNJXQSwhuW2kAF4hQOJZ2dzBvwvp42bd0hLivrbBAadYGDNiLtVhNmTL5yX/m5zQJdeVWlIhQvwxgVW74j5JJPPXAxPITAN5HFYYlfdUv/uKm5quRqFOeQcrTg7aC5pu1XIibZUK1Rxl2L4VxG0Wd7+A+vM0vVSnTF1M+scH7QFSOUIQL6oB/s0qCYBMNlM1+eWSl/ni1FxB6eeshgZhBy3D8AEENwSIijsauk/uUNfJNJFhiu8FUaId3XmajrofXSxo3Ya2IINi8OHKsXHyCoBQY8p5E3+2T839UPB/pkFmM8Z77jaOmju1ClvEllHb/kw/mLWV7yQYbuB21OhSR0PNEDpWLb1HoK+2n9L7UfXZ0fFZO7fTk44Ttpr5+fh4OzZ2jv51XjhDf6TEqBFPwAEGFzroIQ28BDdv+exBdMWBVt+fD3p4IaVi4oFaWSlW65dC1zjBEFQHMMYH3aWw/AGZ7FkUwCfpuShzcd8MvhAHR2Sk/FnGrzzQxpd7/akuAUlYXEIUsz2sgHMvvMSic404hK/c5RJApAFefSMz0g64zr7K3M0lnC0G5XkmBCe97/VUvu0twAM9JWryHkJQAawcsQQo0vAItLs5nuJadlqMbSXYBCAFwAKwjPD4r4z6FOYUYUjowRbfgS3iK4F0W2ElLgrBQ4c2fRQJQEY7B014ji9tqUT7rNqp1oaFMjJ2d3gPbn1SHbONm6ugkZDxj9cUiM+ALl4YxcQdIPnxNeGbs5qRpCg1QdZzawEiLBFSsGAX6FBaSD1FNV/7t3PojAWiEjknOyAP/eXdhEA7UQbpz/GUAnSsHe02ANSzJTzYEg6f9Dhn8RadyiCN8pqM1XuXESfKTBVBmJjWtEoTBSJkv45dH4yN8ZLrjobKDaljx0lXQZaP151PTyDs
 2Yfvm/Nk
 LActqWkFaMtz6JPYIzsprCYz8m0SDLteO9RiucSpNtnIUNVwpm1IWYMuBFBP2s8pbnExrnWtKybBqzIvjvrCp8DcSr/VqhsQ32h3IgtWz/30srgNjLHH55G6+2v9qUEHZtjwvk4m4CL7+LBfm/BRlPF+hr7aepMNo7/kPWYE+2/9MMXYiOBfVSl3QUfBxS/1DI1HGqdy6SKqfiGuuhMM/WXCOEqmuVmw2/uEXU6KQS3Ubylqb0n5fPjLZtIM1Q3xHC5RxbjFRRdHfSblwPZvTiUwWbXyYsiTZZ94ysY5gmHQ5xar+A4hLiAl/2snn1EuhjHtTECslVkJ/ZmOZj4NXSkzAjZQYZ25TYediBynDvB//sDs62d5BFcStHLgZ65LBlc/p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qiang Liu <liuqiang@kylinos.cn>

Return VM_FAULT_OOM if page allocation fails, which
avoids a NULL pointer dereference when calling lock_page().

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
---
 lib/test_hmm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 213504915737..f8b43d6eb261 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1063,6 +1063,8 @@ static vm_fault_t dmirror_devmem_fault_alloc_and_copy(struct migrate_vma *args,
 			/* Try with smaller pages if large allocation fails */
 			if (!dpage && order) {
 				dpage = alloc_page_vma(GFP_HIGHUSER_MOVABLE, args->vma, addr);
+				if (!dpage)
+					return VM_FAULT_OOM;
 				lock_page(dpage);
 				dst[i] = migrate_pfn(page_to_pfn(dpage));
 				dst_page = pfn_to_page(page_to_pfn(dpage));
-- 
2.43.0


