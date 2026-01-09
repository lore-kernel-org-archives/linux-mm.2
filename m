Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C36DAD16805
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 10:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D069A6B0088; Fri,  9 Jan 2026 05:43:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB4D06B0089; Fri,  9 Jan 2026 05:43:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC09C6B008A; Fri,  9 Jan 2026 05:43:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A8B176B0088
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 05:43:21 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2BD251A0446
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 10:43:21 +0000 (UTC)
X-FDA: 84312088602.11.C61441D
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8D1774000D
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 10:43:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Th7qhJpA;
	spf=pass (imf17.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767955399; a=rsa-sha256;
	cv=none;
	b=MONmiwXx3jRbEUvusPF09q9dJ+OmdzgBtJz6bML3FmOG+iG3UHr804cpdoDLBTxLliatWH
	YVw+R1MP88XwFloytj1gFGQVHXmdVgtuN35Vn0L/41iEAFhZ6Qu21UcfET7vZAf2OXQ9kD
	N0wDozISZYgkFmyRkX3W20jMTLV68Sc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=Th7qhJpA;
	spf=pass (imf17.hostedemail.com: domain of ranxiaokai627@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=ranxiaokai627@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767955399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=UMSWWS1xemY2qzOpfGQyi+YC3F7gxVgrd+oftHsiSGM=;
	b=tIZjpEfGZP9TNr40E0em7JyIkNlkCwXH0OwCGaz8cZaHxbraGKkCblwAaHZ0NkSl8Tk5yM
	lRhuauctKXnhXTkfvQWwFRsym3GWvGYQ07jocz22s7MrKTrMccdV0+IkdxpdZ5rYcpzKqK
	be770Zx2mRWHXGNv/2aqlSrmSy5FhKE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=UM
	SWWS1xemY2qzOpfGQyi+YC3F7gxVgrd+oftHsiSGM=; b=Th7qhJpAIrAk3DDEpd
	x1cmCFonCnUnap0z9I64wocaYDT5kNojEw4/hWEK0k4crNmwaqqmoPh3RKiqTv1b
	yzgNCvbGaikev28ToeS1MjO3PthIPqcTXD6t/zRi4FNjWJ9cVbHNMWc2v+axcJDK
	2mxbSDdxZsMibYVZCnFvN2F20=
Received: from ubuntu24-z.. (unknown [])
	by gzsmtp3 (Coremail) with SMTP id PigvCgD3vxit22BpF9M4Kw--.163S2;
	Fri, 09 Jan 2026 18:42:55 +0800 (CST)
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
Subject: [PATCH] kho: init alloc tags when restoring pages from reserved memory
Date: Fri,  9 Jan 2026 10:42:51 +0000
Message-ID: <20260109104251.157767-1-ranxiaokai627@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PigvCgD3vxit22BpF9M4Kw--.163S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtrW7Cr4fXF4rXw1xGrW5trb_yoWkGwb_XF
	4UJw4jgryqkFnIkan0ywsaqFW5K3yYgFWjyw1aqFW3Ja4Uta1q9a12vrnxZry5Wrs8CFZ8
	Crn0gF90yrySqjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRta0PUUUUUU==
X-Originating-IP: [117.176.243.134]
X-CM-SenderInfo: xudq5x5drntxqwsxqiywtou0bp/xtbCxg+U4Glg268gtgAA3W
X-Stat-Signature: kduhug65ru7bdw1uwqfk9634w3afwdti
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8D1774000D
X-Rspam-User: 
X-HE-Tag: 1767955398-883679
X-HE-Meta: U2FsdGVkX18My1xvKGUOwJYEVZTR2JxjQ+gCwulUT1t0qKypGspYh5OYrHnsz+aVS3NMyOahTEdb0jzXPuWNVJs2bUqWOVWydTCRjmc9E184QVFQP4IWh11VlHdbRzWpK/PtL1HSPxUbL0eVnPKxMu1IXieLj0iRgefkSbwNcoimtClslHnbS32PR3bBL0Z4+dhpdwEzVmU6395zepBiMEjCBQGFbtXoE78ArOVTgy+ZwdhRRwAnQoeeqGrCgp77ePhR3mHiRehCaEgwkfMLVNQwoJ9Ewp81bSMB/OCnv+imts8efNS6s3oecKKB9u06d8WnKiEFa7qkViCZ1w3Tpo1Srr7ieoUH1ufYLX6SJdgMbPbQBGYiBzz2vYJ+tt8iwD5ol8gUyViV2SruN9ni991zLI1EHOX7nqwGtpulD58fIGxBg+PLY8cyU1vE4+ggQmLim1C+ECREuL4/Jh7QP2aEsTG8QnKe8yWmFWBQwyaxihRbPIXm5Sz90wb6f40OyaoljbUbfm9BJCbjE2JdYK5iuHZhIVnmOhySABoypvwWp4Jhabsj0q0YPQHYOewi4H2LRggEcvvoAPSjBib/uO3Tbk7FMEFML3GskkWfHv4ZtRXXfTntNEEObYp7OSAv+OkET0d53LODcSl6cA85eolIf0HRExRElg4qNKtSwIXjLIFii+NGbc+9qKu9BoxtjefK0QKoElymz5dBP4lcGQbs7m3UgLxtkH3MsBZ5ew1geqo18JpcVT9ejTZ4o4Pgufka9r9bzMosfOf0GGbz/EHZRUNWnCQl0l9vIsf8VePvWXuloM0UXLvuUoc+wKvy798tgNSoX9egZYcq46NBsSVkNZfxtdYXv1hyBPlynZ7QSQRyIlpeUY8tj3uRwuwK4XnJkqfxZQlYPAPnoKko6XPr9lBcvB7TUvhSaPEH0GYNbbpB+A6I92WSqaiW2KaL8kmdbLiEKsrDR8jKP7h
 S9jeJG/N
 v+/sWwMnUMZ6pAxPH1VgfY2Jbvo3tc0Go+0WwD5GIDcusY8D0UuPOjW6mfkzpV1JR9jp8l+XzmFMBefs8wLJOc4uasG6fO4q+rVkAcYCmxla6M8mPk2uyVvlo2ih4JPvFwWqq506LqHO1vd/Y7LT4FqE3Nu8HIXidy/vLX127lEWi4hvOh4opBzPORL3vFhjRrcRVXkdw7EXeyKPABfEG8+PYFtU6KIJsjSLZ1DcsXaoQM4z3SipkLfx898a1k/8yQW1I2SG5DiBoLm+GUHwxYsYchOk/JTJyEwp/loIhjMZonmcXpGenGVZFVoqpDQPkOCrP7ALLfvpa4OVJGcaXBPhj30Daeqpsrf65OjTtU6mMxAEEbXT4i3ojCY/WFXjyzZ5Lkyo9Q3eMlsA=
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
allocation/deallocation tracking and warning message:
alloc_tag was not set.

Add missing clear_page_tag_ref() annotation in kho_restore_page() to
fix this.

Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>
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



