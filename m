Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 415B4EB4906
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 11:12:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93D956B008A; Thu, 12 Feb 2026 06:12:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E7E86B008C; Thu, 12 Feb 2026 06:12:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 814AA6B0092; Thu, 12 Feb 2026 06:12:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 713036B008A
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 06:12:25 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DC4C9140780
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:12:24 +0000 (UTC)
X-FDA: 84435541008.06.2561E14
Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id 584AE1C0003
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 11:12:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=FVCG87nM;
	spf=pass (imf21.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770894743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n+rpPjxDD+Z5fIPDrZeUxPDcng3MFwzbjG+nEfu3iEU=;
	b=t/m4e8qBbwzWeHTtRqOWO/2X5sos20vXN4fKwssbgWKVdQtrA3OU0JYrU5xCPWzJ6tw0Ch
	sJC7sDrzu+WQj1Zg6kvuF0fGQM7Gr8zY/s0QrxbRBnW3Nm0VDbGyzg7Yb4gMLWvgP+ONpn
	uB1FPa/U0D+NLhmCKLSKOmh1lXhq+WA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=FVCG87nM;
	spf=pass (imf21.hostedemail.com: domain of ranxiaokai627@163.com designates 117.135.210.5 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770894743; a=rsa-sha256;
	cv=none;
	b=ejTW4/FfyQMMEuz/6P8LRBTZrlGXYjVbBR/8yA6vrlkfark3biKFR9dT5Adyo1ScvnVjCZ
	+yjUXM7ggxly8qct0OI/BwtFnjdTHOTQ5i5R8tSs/TTSm7o30nSZoJ1QQiE/cS1PgaACMA
	fuzGZAyrlkU8jFpiZhpvwupCEKLQWq0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=n+
	rpPjxDD+Z5fIPDrZeUxPDcng3MFwzbjG+nEfu3iEU=; b=FVCG87nMyScfOr2n5l
	gVJn1xmndnPEpSJOd1HeBD+VoNDjwqFhPuIiZs02qMOAur+ctfVt2Di422iUdDMf
	acEY50DaM1RBFpPWIZj4G1ixY6QE4YGIgJnl42SgEhGOziay12m+KwPV4JWbCSJZ
	XyIDiF6ryBnXOyP1cbIXHzMFk=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g0-3 (Coremail) with SMTP id _____wCHZLl0tY1ptkijLg--.48890S4;
	Thu, 12 Feb 2026 19:11:53 +0800 (CST)
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
Subject: [PATCH v3 2/2] kho: remove unnecessary WARN_ON(err) in kho_populate()
Date: Thu, 12 Feb 2026 11:11:46 +0000
Message-ID: <20260212111146.210086-3-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260212111146.210086-1-ranxiaokai627@163.com>
References: <20260212111146.210086-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wCHZLl0tY1ptkijLg--.48890S4
X-Coremail-Antispam: 1Uf129KBjvdXoWrtw1xXw17Cw4DGFW8XF4Dtwb_yoWDKrc_WF
	4xtw1vkr4qvrn0vr1Yk39avFWrKw40qFyqv3W3JFyxt3W5tayj9a9xZr4DAFnxW34vkryD
	Arn0grZ8tr4fWjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7xRAJ5rDUUUUU==
X-Originating-IP: [218.203.227.87]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbC7RlJlWmNtXkzNQAA3G
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 584AE1C0003
X-Stat-Signature: 4xczfwayqemnz7qtxb8ckxiimupdj3r5
X-Rspam-User: 
X-HE-Tag: 1770894741-687550
X-HE-Meta: U2FsdGVkX18xTquDhMcciarw8/QW9GIuJDkvsifs2ArcrjNzNENYsA3/SYDYpdmpdpJ0Z04bm3v08h7s/ZSxVecHLxBxsgU3DlbJiWpTYeT/07imTd6qa9h1QxRy0PY+ytpHjVlFrTZk+X8lR/m0lWcs2gkjZC8eGaYsvqfLsf1zPV3y3whpkQWVJQrWRVrfcYwu6yv+OFrAhdffeYlxIYEiFftvyPn+sG6yonUANdKFFA4DH2nFJX0FK+7R4bo6D8RfetF/g+gYq4iOPYBpLDITg0aFS37e/Yiv+wjM6RX6ZG15Lgtd4Rvwkk4ht7y8yT9f2Jzz/0heftpMtPaO9EVI5sb2okDSLBnHaakyenWajBZF+T5+4xx4mSmJ9pHrSjpQrSA/E95GpS9/dD+5EhOyZDEZFzdI/F59D25vJrVbJgl11gzujb+HgMjmpQYBDFnLcwaotL/4vJNt/7WNTQhEonkWCKZlW7n/ns7ur9tP5poINnaUoBCnwG4oMQjapX+S8wG3XfViJXfUjAgOGLyAig8x06GYaGpCs1R/zduNmXGO+hQkAWtcfVet8S1OolPrTKCrTcKmZo7IkBf0WMvS9rNr5UKv9PKL5OLo7DhvJe6SFQ2dD40HWrLaPr8fZV2r0nyfU3Dg9tRTA3pQARTIhHcCn5u+o4w6ZFJAGv/Wqg+UOKEjYFBlzOiEowysGp8KLFeskKIxDfp+E3Y7j8h5LrqC2+9ewN3LOuDFF/0Q5W2UBbKAv3t7sR/R3GtqcCArqnyRn5XrJQSB8WSOnoYmhIn9KFioFjvI0uxSkDeuZM5+kYZzTvW187RYu/O+Tu/BlUq/imoZ5PbWVi+mxT8W4DAPYKeud2aqpcKM+iytoUfMxMyD1kv22N4mOv8PTArmu609iG1IkHpAsrvMjtvPm1bOnIzrOm/Hw0eiW0jWazsqi3pNoVcitWY+Xc9lGGecU7cp8fK5OpqlxLv
 v8kvX/Xp
 dBE4WwMb2VO5RobZHfgnxQaFC014ePUNtWZwcjS5O5S60zxlq2Gkd75xoyYB07n0/4PhupX8S+1pzIk6YLuqMOGfoKez4UmecYHjLA7YU4M+NBLmfHh+LTbnBePtsiUnzSmp1Ijwvv0GpTHR8RdzHuhPm5wSiXW4Asvg76QDoyQINAA0/EDeXFsBwBqs1nUGoI6Zp1sW+0VaiDsmhZMTc3U12dMiGskeVFM5YIg/59tcn67uYZhjbC2knY7IgsLPoCK9yorsJAWPbeTF2pnIcKj3qdRvqC1b3WHsv/MYrHsCW5NlCqE4UDFxldofDwiZMU5xmCtwjWtlAT5OED0RVq4REFnau3YTDq9Dw1YSnw8pXVoe915ZeO3LMTVXuEFBchPp2JKeaEyJw7a2lnaoEVaHZQKsfY8JCBP5AykO+28iSEPphWBz6klvHetMOlArNwcDXygy5q/XWozH0x4fcrVEr0zH5gOKAjB+HHfQIqW3Z48VdcxQ6DGyY21P0LJKytHwqcRLax5PsjjFsrEUluhxuWKbGBQGettjSPZx4M1W9hsaTdH1Pr/lctJBtXo12+PN94DbMpFYcnYfMWiYeraqclbHEgntIXRo6QEc1ONKX2pI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

The following pr_warn() provides detailed error and location
information, WARN_ON(err) adds no additional debugging value,
so remove the redundant WARN_ON() call.

Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/liveupdate/kexec_handover.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index af82d8862dd7..95601623b4d6 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1507,7 +1507,7 @@ void __init kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
 
 		memblock_add(area->addr, size);
 		err = memblock_mark_kho_scratch(area->addr, size);
-		if (WARN_ON(err)) {
+		if (err) {
 			pr_warn("failed to mark the scratch region 0x%pa+0x%pa: %pe",
 				&area->addr, &size, ERR_PTR(err));
 			goto unmap_scratch;
-- 
2.25.1



