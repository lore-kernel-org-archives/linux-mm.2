Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82D03D29DC7
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 03:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D94776B0005; Mon, 12 Jan 2026 22:34:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D417E6B0088; Mon, 12 Jan 2026 22:34:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C23E36B008A; Mon, 12 Jan 2026 22:34:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id ADBE36B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 22:34:57 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 299A113CC23
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:34:57 +0000 (UTC)
X-FDA: 84325524234.27.9134ABA
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf15.hostedemail.com (Postfix) with ESMTP id 62CE6A0019
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:34:54 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=VIzHpzDf;
	spf=pass (imf15.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768275295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kG53ciijNmoTnssyHfq8vIOccM9yp/KKrUz9IyCeyAI=;
	b=gFdzJvRSkA7aPqE9LWFUTXpPe+d6g7SVOh+vG7BiQM1lIUr925csDpxNxUUdBIu/a6oNno
	G/jtnBPtulT51cAIG4TORBTKnxY+q3HL4WXj7+iN4JUdAxVP/V4dZ9rKNt2ZP9RWDGGSQR
	REBvfXXiYeiaJ1oY8VUqHf2bVBBLI9M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=VIzHpzDf;
	spf=pass (imf15.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768275295; a=rsa-sha256;
	cv=none;
	b=UFh5I4L8aq5IR6pyRpZK/uDeRGvzIkVukfmTiopuEpoE/IrczbPH09Hhhqet0M24XUK2T3
	p2MdC39TQi5huSvVQykLCLXOUd1QvQgfoimBZWuoYFn5+aKgLMv5j3arb6CQ3df72DMyjV
	h9mnuBxhDirdRoc0fIGXSF9yrhPtZ74=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=kG
	53ciijNmoTnssyHfq8vIOccM9yp/KKrUz9IyCeyAI=; b=VIzHpzDfyJdSbzSux5
	I1/9+g9NxthwkYv7DqlCSW6qOd6sJCanUCdh2As/A6GDW5ij84JEAT8VgzQCedFh
	RRdbDg8LY+knitxcpFzlojQPjb/dVEnLt5LaszOodbmsifYafDD1mIQhYYr71Ag5
	J9VbKNuBa8Xq9y3xLFn0SknkE=
Received: from ubuntu24-z.. (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wDXrf0wvWVpTNjGFQ--.289S2;
	Tue, 13 Jan 2026 11:34:10 +0800 (CST)
From: ranxiaokai627@163.com
To: graf@amazon.com,
	rppt@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	akpm@linux-foundation.org,
	surenb@google.com
Cc: kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com
Subject: [PATCH v2] kho: init alloc tags when restoring pages from reserved memory
Date: Tue, 13 Jan 2026 03:34:03 +0000
Message-ID: <20260113033403.161869-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDXrf0wvWVpTNjGFQ--.289S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ArWkWr1xuFWrXFyruw4xXrb_yoW8WFy5pr
	y8Xr18J3y8J3ZrZayvq3Wq934fXan5W3y3Ja4Du34fZrnxCwn7ta97Za40qFy5Zr4vvF43
	KF4UXrWYq3WY9w7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piOtx3UUUUU=
X-Originating-IP: [117.176.243.29]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxhIve2llvTIqUAAA35
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 62CE6A0019
X-Stat-Signature: iyxwinidtdkwkc1ouubkmnaazn8bi3dk
X-HE-Tag: 1768275294-547515
X-HE-Meta: U2FsdGVkX19cFTMB5G6rBRzrDIjfFVVV67FivZzFcxqGAsL581b1iZq5a43v4g77SvF4dRfBLavwInCIH/2MnoNiHeoL3djnu1tJHG/bSaWM6G0mGLi/Cbe4euIfM4+W+4Uq3d2pm/cMjlVgUzxXK0nJ06Vtnn/faMJRbBvn8LifRQcuLDGPwOBZLDL8cS7uK7LoZbkOd/y54WmlZD9Z2EeHVaXJnPHkYLq2ZEWec/iLe//6PGYWpTkPxZzbkvixUBNl/wbUVcuTxuAA+vXzT2dA+9aMUHZlvK904isb0p0FqtfQB5ITB5g7Yanay5d2KrDiLBgSy2gW4yfx8+RZgA0zo+NuGeSEeXobPA6MkyvQ6qZKleSLYtsVg+BNeubXy4JUJidNfx9qzl++sglEMsmm7PeKjdziwliN7C6XjBcPILAl3jDMQ/OOruqL0UeuI07/1SFvdslsyev8/oIlMdKkwMszBOkYFoXdzscZF2h5IahXjH4V6w39gr13ZJVjQnLSooQwV4S45wooohyTdKgiTqd3pLe7KPmgjRMM2QM9GDjgWI5tE3RC4P4A9tyfqcozS7byTqUvC7wpC75wWjRNlc357UMRgQzVSN6WtScbiRXcsdrI2hgCasbgvhNdkfLmirYC8+ALZ+7D+bYBgboQUcPhLnTBLqJ2g9V/qGTcemno5srIa97MOps4g1dlRSZZSlIF0ganC4T5DorixTef01xdPnUulGIfHBjchJlTW4P1wr58cMvKhcwHAFVtTJ4GWohVKopMgGk/4IeDyhwi/lyGeOE4Uf00Kzo45Ma2EpwCJbIP6sCjQ2KYT868CeSJKKjeq4CvCAePaI5olcM//B9vQnzszkT8C0wiCFfr/L37TnLTOIo/TJE3IYwwQ1OtNj9Dn+5RgCpRXRwPoXFF4V8CGLU5EcWHl6rfC/R28d2w22CPyTQLTxWxuwfO58WOaQHs6SVMIF7xMo+
 LpOAeJ9z
 k46L4bRMEezaibzlfSICC55FVAEHD7vag3K4EmCFqvksPQUSuMx8IMDUVUWbK7k9tTEPlJ3/91/hHAvmhv1V8wpOFmjktGof7azaRzHiyS53M7zOfgmsmYoOmzhbjjbT1dqfkl9l9s1oj5fpqLEPRlWIkhneaSONlPExGoGTDRuGOyrJdKfBs7ZOqGLIwPtpdKaVKsZSJOMvd7xEyHl00H+GTJrcj9DMc89xbnzhtqlvJtGtv0rZ3gUCKcGP209dIu04VaJ4CWCX0jh0Z1ovGV+m2Qv/9nS39jNmrlBDQX5/iUJJi56JEuHT2DCsO19Np4uvSNtnU5uuLXX2kibprqpWIKD8LW4N4S+IfDINvt7TsD/Ydu4LFR+pzffJa3VsafTjoonItqsb2MRTA+CZoVvbMBnzvyzCeIpNb4duO/WqijfFT7rAlbqIe4WeXgufiTTT5
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Memblock pages (including reserved memory) should have their allocation
tags initialized to CODETAG_EMPTY via clear_page_tag_ref() before being
released to the page allocator. When kho restores pages through
kho_restore_page(), missing this call causes mismatched
allocation/deallocation tracking and below warning message:
alloc_tag was not set
WARNING: include/linux/alloc_tag.h:164 at ___free_pages+0xb8/0x260, CPU#1: swapper/0/1
RIP: 0010:___free_pages+0xb8/0x260
 kho_restore_vmalloc+0x187/0x2e0
 kho_test_init+0x3c4/0xa30
 do_one_initcall+0x62/0x2b0
 kernel_init_freeable+0x25b/0x480
 kernel_init+0x1a/0x1c0
 ret_from_fork+0x2d1/0x360

Add missing clear_page_tag_ref() annotation in kho_restore_page() to
fix this.

Fixes: fc33e4b44b27 ("kexec: enable KHO support for memory preservation")
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
---
 kernel/liveupdate/kexec_handover.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index cd6b3fb9dcae..2d47f2c50bd8 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -268,6 +268,7 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 	else
 		kho_init_pages(page, nr_pages);
 
+	clear_page_tag_ref(page);
 	adjust_managed_page_count(page, nr_pages);
 	return page;
 }
-- 
2.25.1



