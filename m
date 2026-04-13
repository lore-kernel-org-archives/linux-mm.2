Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A305EEBFD20
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 09:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 18DF86B0092; Mon, 13 Apr 2026 05:41:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 165556B0093; Mon, 13 Apr 2026 05:41:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A28B6B0095; Mon, 13 Apr 2026 05:41:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ECF056B0092
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 05:41:13 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B62594C03F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:41:13 +0000 (UTC)
X-FDA: 84653039226.14.39DA830
Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	by imf02.hostedemail.com (Postfix) with ESMTP id DF51680012
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 09:41:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of pmenzel@molgen.mpg.de designates 141.14.17.11 as permitted sender) smtp.mailfrom=pmenzel@molgen.mpg.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776073272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=LHvabTf4xxL4EcAhT89x912uEJ1jsXLrZXTOaNdoHuA=;
	b=cOWHeC5YtnEVo/kz1D7WeqIwSue1KSW7exlvj5h/9SGQMRscVTIPtQ6FEHRs1505AUzvoC
	YLGFk0JE7KC6wuvw5bVU+6o47GsVLFPH35ABkr7L9utZqTv95W07LjRit8HGFNYs7LhmQo
	YW1gqzTw6Htb3muajvdcuh6cmP5WJPY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of pmenzel@molgen.mpg.de designates 141.14.17.11 as permitted sender) smtp.mailfrom=pmenzel@molgen.mpg.de;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776073272; a=rsa-sha256;
	cv=none;
	b=Jb2Ejc6SqB95L+e5syznfpY+D28ctyQVB7iHb3745QW37HsVwf1oHMAlv7t7nQ2V16E1dt
	5os9Nx6nnoURrNyWbsn3nTqUKpz3AfZpbFw1YeW4zX3n0Um2bVmEKq9byZ5PKSuXWjNo2m
	BKayfm6+QWINXZ9U3aOdTRIzgLbM0jU=
Received: from abreu.molgen.mpg.de (g42.guest.molgen.mpg.de [141.14.220.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id CA3004C1A77F2C;
	Mon, 13 Apr 2026 11:40:46 +0200 (CEST)
From: Paul Menzel <pmenzel@molgen.mpg.de>
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] kasan: Add abbreviation KASAN to init log
Date: Mon, 13 Apr 2026 11:40:33 +0200
Message-ID: <20260413094034.6944-1-pmenzel@molgen.mpg.de>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 5heipxzfk63b1dx18b6jmbzi58pb3upa
X-Rspamd-Queue-Id: DF51680012
X-Rspamd-Server: rspam09
X-HE-Tag: 1776073271-960039
X-HE-Meta: U2FsdGVkX195SmQ+is7CSI3HFvfFSirAzfYIaNYXJ0BuiPXFG2A4UlOrlqh/X1ell0bsdlT2iOy694pKizeQYKg+BhbvHQEUan9NLA0HLN6JCXm3JHdMP1RQCnIhprlgqaPamrX1r80yFVDSW7NS8ui9S01Rlsa8JTBhsfHxjx+R+MUg4ce6irKU8f1l/tqoig3sru3fViZVwFIqfP/mohg9GK/sxRzUV789Jtz1rB8DGVLC78pHaN5VafZqLAAkoDhMHL/xq3uW78Zu+JFSkQqLfMyqZJBQDCcCNLaud7iaWWlWMglm20v+ngTMfqeUckBRl8K0khRwzxSXCpxBzO+H5dg3L/HNdRprcKAIsA/uBzQr+b44uHXSVbaetxBI5BqFVZSUqFYbfqqSIfFYOy/UNhKqwxjCvjdT/vRCifb0bGPHqPejcH1Z5NNKws4es//pDqRLTmJy0vT5+qUwixSDJKiO2fJQmtaOrvWXwRiYXTohHNzbRGkzEVeJQFyF20nvOD3OQCPI5/Pwbv4rMQ2dsArkTfUli4DFAmS/8R2w6tZF2D8mEOhOJ0RZYw6ou5GmU324wQHsOv5GcT0abXoDsy9yxGWoXuTrmlT+hTJwqW5MfmpGreteJ4MAJn68Y68unGP0BhUW5+XpBB85phEm/6L7rI16EWkQpd7/HeSnbwLij8XqQi2M6ckIByy/1qoyB4NdskHuddtrHiLvXExRTM8NGlG+f2dNBthyF/SLJFVyGmWpxKCQHAmcIzV9wY7UaUqcoo1qJT10wJERg5+pshexcR7bch5OVpmArxld9dM6NDFo6fofAhjWtSYvhffAEhcb6El+RPgzfdKicmaDsfbdHx0Uzb5+RstWivFZFKTf9FH5+6qYDKXobe7uHyvHLlW9UNmANlC8aNxfOkkGP6H+mESvoqMqtMYEZ0KgIBF1m/WWaGmJoceqBowj5mSbXZtlKgKL4Mgpixw
 /1sVspqZ
 7Dm8ZjhfgRJtzpI5lj/u0McwPW1zecDyWmjaXlQMSKYjA0gRPTtQqW5Q8Lj7052nc6eQwMsQ3EfDGkCBMLbKV9JXl2wiG4TAKoQPFzXU8d+HVqGkhuNyFcca2hOd/pRf7uYE/zvM9ShOWjS2gbqpEm78ryQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

`sudo dmesg | grep -i kasan` comes back empty, at least confusing me.
So, include the abbreviation in the log line.

Before:

    KernelAddressSanitizer initialized (generic)

After:

    KernelAddressSanitizer (KASAN) initialized (generic)

Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
---
 mm/kasan/generic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/kasan/generic.c b/mm/kasan/generic.c
index 2b8e73f5f6a7..1fccf7cc9fce 100644
--- a/mm/kasan/generic.c
+++ b/mm/kasan/generic.c
@@ -44,7 +44,7 @@ void __init kasan_init_generic(void)
 {
 	kasan_enable();
 
-	pr_info("KernelAddressSanitizer initialized (generic)\n");
+	pr_info("KernelAddressSanitizer (KASAN) initialized (generic)\n");
 }
 
 /*
-- 
2.53.0


