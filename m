Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E6D7D3EE66
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 13:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B79CA6B01F3; Thu, 22 Jan 2026 08:28:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF9A76B01F5; Thu, 22 Jan 2026 08:28:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A6A56B01F6; Thu, 22 Jan 2026 08:28:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 838876B01F3
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 08:28:34 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 44CFA585A4
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:28:34 +0000 (UTC)
X-FDA: 84359679348.04.8EF957D
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.3])
	by imf05.hostedemail.com (Postfix) with ESMTP id D7B84100002
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:28:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=dC1wa78e;
	spf=pass (imf05.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769088512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=e+6gDoaU6sjJYiXvvo+102yEP3zTOi6BPXPONrmdz8k=;
	b=2kcnK4XqA4IY4K6DtfHX+Z70zoCRBrH3hWeWKa3p7rKLWMGspK/QlKSX3RYGduA6utIfa7
	OqcQOGICKdKWxbduWNogbFjOM+sYRnJmFEXWxrPtr3DKfuhks7IPc5CrPyYqSAS0Tn3g2U
	l5myuArhU2FaM1OUc4KZOtD2jAKO3Yw=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=dC1wa78e;
	spf=pass (imf05.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.3 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769088512; a=rsa-sha256;
	cv=none;
	b=FdXw2Ar+kS8cUpcWjC9Nfhb3iadbzRsyPAp4RSC55q0HUxTsNbuHcjGV2vxynCYVondmDd
	1wSuWZQX6oxe3o17QR9wosaDDgyYCnTCHoiDKrbIIy06+pC4I0YYdawHcEXAcmJbNyouTL
	s/H5J3q15qyMDudACgZWPcKCq6PJplo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=e+
	6gDoaU6sjJYiXvvo+102yEP3zTOi6BPXPONrmdz8k=; b=dC1wa78esyeMyra8fB
	Ue5iSWNlHlVvxuY3NcWOQse2SSMGWXKuMf6PBV/dz1nnHH2I/C4v74o5OT5qoye7
	M21pKWJm/hmqwHr0UcNJiKjxzX+ocJ4dj9uLykTa1YoKx5Hnu6EcPpzUexqLwxjV
	BNOA1Ag/wMheQnO8B32WwAWEs=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgAnE2TOJXJpoBt0MQ--.31S2;
	Thu, 22 Jan 2026 21:27:46 +0800 (CST)
From: ranxiaokai627@163.com
To: pratyush@kernel.org,
	surenb@google.com,
	akpm@linux-foundation.org
Cc: pasha.tatashin@soleen.com,
	kent.overstreet@linux.dev,
	rppt@kernel.org,
	graf@amazon.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	ran.xiaokai@zte.com.cn,
	ranxiaokai627@163.com,
	stable@vger.kernel.org
Subject: [PATCH RESEND v3] kho: init alloc tags when restoring pages from reserved memory
Date: Thu, 22 Jan 2026 13:27:40 +0000
Message-ID: <20260122132740.176468-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgAnE2TOJXJpoBt0MQ--.31S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7ArWkWr1xuFWrXFyruw4xXrb_yoW8CFWDpr
	WUJr1kt3y5JwnrZws2va4vk34fXws5C3y5Jasru34fZF13Awn2yas7ZFy0vF15Zr4FvF48
	Wr4UXrZ0v3WYk3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x0piFdgJUUUUU=
X-Originating-IP: [218.203.227.98]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxRJ0wGlyJdLrAwAA3n
X-Rspamd-Server: rspam11
X-Stat-Signature: 3p7sqcyieft66hxkodr4cyfy8w6gyo67
X-Rspam-User: 
X-Rspamd-Queue-Id: D7B84100002
X-HE-Tag: 1769088511-168821
X-HE-Meta: U2FsdGVkX1/qdYzpJZDVo/YaM3rdy1fechNKauc4qT/frq6+5X4IwzjHXw532QrNzZCDNgxoui1wjvFnqYy9ESd+UK9Ls/OO00G/C7B1S1vgzhw5dNVZ703Dh1R0dIcn+gdByR8S88LAbu7kMTrryv6KnowX4g5InR8QvyaAoIao8rxSCNYzW+8qz4GN2AQgiDopfZiW7q/Up/2LeBgwxPIXq0mDXJAIeRJ2DG7jYBl85VjXJknZkMXbjponVduesdn5KYjpN3WssFIpVu6xwVvEccJQczHkYYeQy1rxdNXDyVImsP0HbnAySQtBVzLpxaxvjt0lknSnudBup7j4XLvFEH8hcDUZeubUb1cCvNYoHYQz/J/6tuCwGjeCPtGZW6mcbmNJOzSGXQva/WtF7Nlfyh8oNP+rj3N635dwJkcxhRB2BGQ3egvQvFD4HohAOlyIs5mPzp0AYEZKGAe3883UWVuYJXfEotdIqsmVvjJ7CRYOOdBG4B6PBDfUOZ9fRHHoQslJG3qkSzuhqWiAQWyeeOUgb0JaNZBK2e7xnaOKxmVaniGb3Fq/ahuUAAD8rA1Koy/c1WuJpqMyZHll0umqWQJxYJrGmxd2lb1TaN/yb8fUjwpMycEBsFSrmDVdZoX6F1MeshVwMXyYVR1xgH1Sjn4dzATcyTPlypoChTm9lSMtcgzSerenFA2PuEB5/byp+jRL85dKZg1O6VOcIeSQeyBU0b9u6YtHDOa77cHGD/l4tBeIqneZZ9NM7Yfcz6Jc+1dIziLA5Hd//7qOq7mUqSAD2zWgjAHHzfUMqqmZCj2PHEg7EwL38vcB2zinCx91ZtHyt31t/1Aw3XcjRcGYOfPziPv15NILxGIycnpRK8tCjAI5k3vqlOAC1nDa3NXGmSWdpO1hrIfxAgLpWRAGlx2AQ3KqU096osr9fZyZFXQS+3weF/9x/x0mVPimJqrPdhnCfYOtI50LPED
 fCAD4oHH
 SA4o6rXCP2BLAPLKr7/PPcUMevXh+/Attf1fDqZU4wDAMR26fuiBNRsTZ7KAeg3dPXwpvFmDq1TWgv1Vs/LzP20tNzbY4uHZPqmczMMkKHNFndnWdXZbbelGiRXrVCzwBSnpMN3OuALxJhWEO4fdH8e5Ye3i7U1c7pAFAgavB8HFgbZISHwK0DzanX967o2LPqN1o2u3Oak/vq5ud/4rMPGvqmwvMtXn4tbgLGewOh2LTyc3VHGsodtqM9ZwQ3q6JQ1Ol/pPFRiCarq5DMrDI3ArnuMlW+hBCCUpX32qlZqdBFqTrCPTBpzwNPvV9e1IBzqWHGKAvACYyy+6iDBZ9+iZ8ML8HWpLjm/420Vg8KqNnxmpfw1S8kGRaMBhXnyHmwOg2nsID6K64t6jAjDwl02mI0q7E9GUNGPv2DjlicvkbAt9uQaX9SvfYE+8YJ2r82XiDtygYh62S7VPySmioRhgnnH6GaKQU1YxdbKIEHO18mM5e/RsTBUHhFKtfwHpYJLJj
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
Cc: <stable@vger.kernel.org>
Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
---

v2 -> v3: 
 - also call clear_page_tag_ref() for non-compound order-0 tail pages

 kernel/liveupdate/kexec_handover.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index d4482b6e3cae..96767b106cac 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -255,6 +255,14 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 	if (is_folio && info.order)
 		prep_compound_page(page, info.order);
 
+	/* Always mark headpage's codetag as empty to avoid accounting mismatch */
+	clear_page_tag_ref(page);
+	if (!is_folio) {
+		/* Also do that for the non-compound tail pages */
+		for (unsigned int i = 1; i < nr_pages; i++)
+			clear_page_tag_ref(page + i);
+	}
+
 	adjust_managed_page_count(page, nr_pages);
 	return page;
 }
-- 
2.25.1



