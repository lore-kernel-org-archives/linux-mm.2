Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09154CD4F21
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 02:53:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34FAB6B0088; Wed, 13 May 2026 22:53:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FFF36B008A; Wed, 13 May 2026 22:53:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 215806B008C; Wed, 13 May 2026 22:53:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0EEFD6B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 22:53:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4EE9B1603EE
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:53:46 +0000 (UTC)
X-FDA: 84764505252.17.D9F4B52
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf24.hostedemail.com (Postfix) with ESMTP id AF43B180009
	for <linux-mm@kvack.org>; Thu, 14 May 2026 02:53:43 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=UL8J9iPl;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf24.hostedemail.com: domain of liuqiangneo@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=liuqiangneo@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778727224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=sj0OVl41nVZux8MonM1pdcOWpZksVKbhvt53cRYip9o=;
	b=D8Q2mYjT8DVEHJRwbBfvAYlvawZDV1tYO7vxZyF2yCiFYdvDXPoTStTrP2XLeZA/y72xz4
	jEh+BuThWv7IRdrDP39GR2m5Zn35xoo8Tv6OM+H8UgM3geFWoAhwXQqGU7/agSgl8VXFsf
	gC8rvy40mrmvnKktdF2em5yw7LaXj1A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778727224; a=rsa-sha256;
	cv=none;
	b=GCywxKkvHr1gdBEY7OL0lSo70f7A1n9sRmsNIqWp+uOLso9dt+JCouK7oq6tjgoZ6NhpDB
	3HvKnOmCSdYIOaEkm8YG14IwInHoWdagKXIetV7+ngNaOlsK5yKpGpnx4vX79X4AR4hAsn
	cEUxotSfOXTnN8m+z7qBrpBjtUgE14M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=UL8J9iPl;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf24.hostedemail.com: domain of liuqiangneo@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=liuqiangneo@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=sj
	0OVl41nVZux8MonM1pdcOWpZksVKbhvt53cRYip9o=; b=UL8J9iPldTXuiIktEX
	oDWHPCX8JIV7rZBrvWNNy5iBOjTAxMNF9eGaLYIt9hBQPkAOhXVVOjs0AGMudcuZ
	RkYJefw/ilJOCsAJicBgRHx0Hxij1O8/cYCpmkQogEr4B8X4L/DpKF+UABMVvmjk
	SuN3BpSvRBuem1xNZR89jpibQ=
Received: from neo-TianYi510Pro-15ICK.. (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wDX75EqOQVql_fuBA--.3458S2;
	Thu, 14 May 2026 10:53:32 +0800 (CST)
From: liuqiangneo@163.com
To: jgg@ziepe.ca,
	leon@kernel.org
Cc: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qiang Liu <liuqiang@kylinos.cn>
Subject: [PATCH] lib/test_hmm: fix error path in dmirror_devmem_fault()
Date: Thu, 14 May 2026 10:53:27 +0800
Message-ID: <20260514025328.21175-1-liuqiangneo@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDX75EqOQVql_fuBA--.3458S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrKw4xAr18Ww4rKFWktryfXrb_yoW3XFX_uF
	4Utan3uay5JFZ09r4xAws0yrZYyasFya1xurn2yrW7W34UXryYq34kWrZFyas09F48KFWa
	kr1Dtr13Ar1SkjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU8Qtx3UUUUU==
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: 5olx1xxdqj0vrr6rljoofrz/xtbC+ww1lmoFOSw5YwAA30
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: AF43B180009
X-Stat-Signature: a8n1a6gc6mez7jwmxnxbkyp8dyhkyciq
X-Rspam-User: 
X-HE-Tag: 1778727223-258926
X-HE-Meta: U2FsdGVkX18qRf60fs2BU4uT6RHjnVM/IxFYXTnUoPRv209a+abMpcr8/xTOAGTlUo+iPDSowPdLIz/t72F9JMro5ZtdcLwo3raDoRVB+Z8wKFoINoEXGZ+XJ8mz5yXD63zKw9lT8P3TEHx05/7R8XJiBlB1BeikIZklTSeMNDQsFjERZo0Ig60FeJb+dKh8Q3dQzX+4MRjfOUPph9gmvTSi2gXaS4lc4+hBYercXik58uzLV7VSTfwcW8D5PLIzqeBbwiU5IZS7Kqw8twM0hWp0hGr+F+x5amIFy5+8CxcAfyCMgmTlecYKIytxZhp9eitrH8tJsSn+5ZF2IMNsCS1vR0H7zQqIF+ADBKjD9O8ydJ0N1+JtrAGL13zpuJvuDgmYpi0SgOoYXtKi4ZsR8bxaWFaeb7EoEhjDa+pr6DDITIkeKIrRiKYQaTIoLMCMrGWNCSHUcCR8T6EkXbXNwxatynZHE75rXYODja6s77E8XXNeSmEEuMx+1Ei62ThFgH3yo4kgVFfKrma8uhAO9HwWa18bSZ9E0/SwHPbDUPZGvHPcp1ujHZ02//PM3C6hBePfFwdxgtG+Z+ljo7z9up+vSXokKb57FM7+e1Kj68Ab6yUOAXiAIDlSJCLEyw+3hNLQUISCsaTz2CTtt0tMg99EZXahQCx0oSycDqgTEmoviateQKkEeC+Rpm+uQ0dl9BXuvPZ9dsUsr/pp1ZSagaWNpq/E3AJIRV1VxQJBXcyM5Xm02WQqV5MppkDR2UbOyxDScAutzBXap2AwZwYHPT+v491TTuGoWVv2UBTtWiA5uVMIooV33g4sLeUTHq7aV1G0qWzajBrA/1WnH5A77fp9eGR7RYTMS49gy2dh6gmDeZH6rTE6oCR2amxnviQcWpbIoMXztDvgYVda1/eAkKlLyLFRHXM8az1EhRFEOfRa+yKj1/j9KEoULwscAsfTLSiCaCwGi/bIKbIR2ZX
 Xr20IZCe
 KPfmRmzkht+tjy07gbfdEZDyE0UOrCY01xGfXkqloNTpm2n4QRsB1Qm1kpUYEn4xGsuk6JsCwxAxaCiy1DtYPlv6kbfOTeHP8NJZAj3Hqda75myC8L5ZXEILwvH8/7lqJnTLgDjKspOhWG3s9QQ14T8Fh0p7zOGjztj6Mq2rqrB4ji2lWNUz4vJdxZhntHDsvrhZ63foNOJu7SwzGojEIT5m9mtE3jOxcvwJmiC9vgjWp2RWPGSn6Ha4pgDexi4uKwmo05K7igu0ctpq/Z26W3zN/LiEJGleCAfbvcK5TyrRxQV6hVa1JEXNzkq/+0lSllcB1XAzFXx6ZKRAa1fyQMpd9DP1qqFy7X/zfx5dn+Aco5TVuRLRyAdxxjaDa1wvQsJGA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qiang Liu <liuqiang@kylinos.cn>

Handle migrate_vma_setup() failure via goto err for unified cleanup.

Signed-off-by: Qiang Liu <liuqiang@kylinos.cn>
---
 lib/test_hmm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 213504915737..5430ef97bbe0 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -1679,8 +1679,10 @@ static vm_fault_t dmirror_devmem_fault(struct vm_fault *vmf)
 	if (order)
 		args.flags |= MIGRATE_VMA_SELECT_COMPOUND;
 
-	if (migrate_vma_setup(&args))
-		return VM_FAULT_SIGBUS;
+	if (migrate_vma_setup(&args)) {
+		ret = VM_FAULT_SIGBUS;
+		goto err;
+	}
 
 	ret = dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
 	if (ret)
-- 
2.43.0


