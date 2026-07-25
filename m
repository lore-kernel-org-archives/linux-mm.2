Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29BC8C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 18:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67F426B00A1; Sat, 25 Jul 2026 14:26:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6305A6B00A4; Sat, 25 Jul 2026 14:26:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4841C6B00A5; Sat, 25 Jul 2026 14:26:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0AAD76B00A1
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 14:26:36 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 870EC120380
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 18:26:35 +0000 (UTC)
X-FDA: 85028129550.25.3BBE000
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf25.hostedemail.com (Postfix) with ESMTP id C491BA000A
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 18:26:33 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NT6Keh+6;
	spf=pass (imf25.hostedemail.com: domain of nsd.project.dev@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785003993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bgiBPl+4CC8BJ96aRSlhbbIqzt82+u8UvxwlbobLLI8=;
	b=uum4dcUaD7/vGwHJ68BMCWH9/gam/tDv4aCfc4iNWowb3QK3XT9D/lf284weQ1nadyeeZf
	Sevh8e2622s5R/fVhYypSAhGp8o6Ydb+8UsnEu4qRAsZ90N7d2kOtcwqv8P4h2F/vihS5y
	WvIJDm3yVXr7IxY/jN+7Ut2gvaLbitc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NT6Keh+6;
	spf=pass (imf25.hostedemail.com: domain of nsd.project.dev@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=nsd.project.dev@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785003993;
	b=FH58hhHifzSk/s946IvYxqRZRT+P5ZLuCDy0JZTLFhoArQNug+hz1uTsrSVC09EG5rYf9b
	dcBEE1szKEvLAp0cNXCtt4nGWIUBCNsFMTSICatx28kwnYpNrGZCU7EBizyEn8WeVZ8thW
	ibIL89DWw4SKrEt9hnf+W8CSx80Z7wg=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-49548e01d02so7591995e9.0
        for <linux-mm@kvack.org>; Sat, 25 Jul 2026 11:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785003992; x=1785608792; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bgiBPl+4CC8BJ96aRSlhbbIqzt82+u8UvxwlbobLLI8=;
        b=NT6Keh+6OhsdznuRub21UHoWzHGOoRekQnfcU5UprRhq/MAYNtW1CtyxlSwKeWxdg7
         mmp60kF21ulclPr//QD6d/7WP2y7DYG86yzZlwLOTBmDsqzEKTuw0E2FD0XAsMKohyDh
         LlBFEBRsB9ZdvP4urZhlSpdcYxPCxTmoKUD/ojc4dyfg1VDHkVL6MBz7pz0ZuVy1cWit
         Gg1O7EBtjsFk/9PPREyoyCBDq2Uwyma3Omo4EBHLKbIXJnRWxeQrN1gwKHDJY7zj1I5C
         41fyBGZdz99odJDop/Y/aZtmqOyfkDwTvNovUnbqWAF4P/gwA1NHdEsI25YrtEpghTHj
         jiIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785003992; x=1785608792;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bgiBPl+4CC8BJ96aRSlhbbIqzt82+u8UvxwlbobLLI8=;
        b=pS3QGxuoHStS8r9G2DinyZc1BSe6Kbla8RRWzsavTeaspbQKibV8RbQfSzbjWp3gqT
         /1vbcV7jP4QsvZVNSNjZrxfHBM9e7fo8mts5EDmzVFZ93gKIVuoHKWPdN/ku7yKpFd/E
         0kpcrlg3QooMKGQLSZRk3a5+c5BaFF2OWfTakvqoq52LeBv+yoW7VOdkBeZhaGzggGWr
         iVnpDbYUx3zFCKWTkizo5pTtPswv+jgRiV9YHrvdCiLcUm3rePB4IfuaOyqV0JTwP15U
         QsJFW7f28x7+WkONSa3Jh4E7G02CbrDxmwiFdn5ONUEji2cSClt+r64jWwo+OLKOIBWR
         wEoQ==
X-Forwarded-Encrypted: i=1; AHgh+RoXGaZcDTF1Ictpednuo1fbx78P20HOqJwuLy1AjacrfE7KK69/gdn0kEVzVwsAU0HgdA2bxcHhHA==@kvack.org
X-Gm-Message-State: AOJu0YxCsbbCauvTS/DyLesWckFljmFtdp8aeO52bXZG7NVe0SUL2qoJ
	Jshz6bf1P0SPgwUBpZMeeyNZEg119z08yvmd5ni1LiBiGYf87cfjvVg09eofR0Sp
X-Gm-Gg: AR+sD11Z4rTMseT1ApXiVJ1vpjySu0Yxh9kbJWo9WFdH96C+pil+t5rho/hwmNlpBVp
	mIDkyyx3FGA9tmqjHTeMOs3O6fQGGaI1BVcDUGkQyQSBRP7hkbE6e6KR/K119WDTWncHpPpG4GD
	aE/c8QZ4JPNZJGC5yKAxWGWim7KQlLcLErScoE6D6ZCfYsgoW69108ac54bSoitKOW0UUX4b4cq
	WMdG+XHAR/5cu4XvuDFgmFuDr1TSoUrpQ0pF/voh2paHP6RHPncoJGC62oF2VFemwNYLAcwOJM0
	zbzVFMqY2HVa1Vu5SEFWioxwZIjlgh0ZwU+Lor9oFgnnAYOHo/6Ogg6PosxvsPHXA9IyU0hWf35
	VoZ06KSLzu45Sf2i98Zm6NPrB/SJL1+zrtyq+Us4zK5XYqc6wZjNfO6sWqG/eHu4OZbm7l6f2e3
	kah6YJlvg0nhb84aJ7mw==
X-Received: by 2002:a7b:c3cb:0:b0:495:607e:5ee7 with SMTP id 5b1f17b1804b1-496b571fef8mr25075355e9.17.1785003992490;
        Sat, 25 Jul 2026 11:26:32 -0700 (PDT)
Received: from localhost ([178.241.98.184])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-496b49b2ffdsm83976835e9.15.2026.07.25.11.26.31
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 25 Jul 2026 11:26:32 -0700 (PDT)
From: Ayhan Aydin <nsd.project.dev@gmail.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: nsd.project.dev@gmail.com
Subject: [RFC PATCH 1/3] mm/filemap: Add NSD prefetch hook point
Date: Sat, 25 Jul 2026 21:26:26 +0300
Message-ID: <20260725182628.221603-2-nsd.project.dev@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260725182628.221603-1-nsd.project.dev@gmail.com>
References: <20260725182628.221603-1-nsd.project.dev@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C491BA000A
X-Rspam-User: 
X-Stat-Signature: 7esscmx6bf1fdexqdujdy1ni5mf8i3tx
X-Rspamd-Server: rspam04
X-HE-Tag: 1785003993-651578
X-HE-Meta: U2FsdGVkX1+RP1n9zrfEAxbZb+JelGj73kwOmJeciBJccwGB54Fy+KPBloATj/MXR3N90+2Gz7yYjC3CCK/0gMlFJpfS0+GT6D+iGwj2ofPa2hwC4oIVIAbfETJrsxn95ZwYzc5oCCopU1EVYQWeJX1UGPuo4HgqRpMOuRdKaBnRdZEL6LYWsYyAU8eNa9LzPWIjmEr5DC83hHRcMXm158UfEQGwXPXH6ybVDWSzoVz8JylAX+yC6/HpXd3AKHWj9rLAj9vuHjNYLidmtM+/ay3ak0fD6DhwV+hz5nvbR/fpps1L1ZHdc0XUg83DnmOzMlyplIUKT7LbcGPQNsvODOVKA3pG0Mqw0DFiCwP5+d8pbUkA3INERz62My0L+0pPfe3qf/bDmgfTzg3A/88MwMSNAz0xduz/GssCZ6Ex0EF48C9nOMiVh2gsLFAYLs9MDgyEZKx3sst+SZHgRwQWb7t2tGLkIImxiWuTFS3Gk3SOdP+OWfws/hX/9YW6eGIkzA2meaxV2pgPkFJrnHF3m5LYK0lcRyurs7qcf36EQjU33ncnzYG9x71g1K6RUAdo7z+e8mi+816qHgiB/gCZLM7r+h7EQYJfoEuR5Vl9n32w7JCMUGpPLwZjPLnbTkhR1WJ+BAaS2+up3qOcPbTxjpRQWr2FE8uSO7dyKvM7ORKmUwX1nNUwRDhoAyeHlYYc9mALTXoqtO1FK29Vu8cCMlAyvhAzR0HyPxK57OfICVfqlG8NLDQL7WG4inExsQgmL+EviEpbd2SFMFpntENSbYJ8w8+sksrdWxZlSvU55aGAiK7m/3uPFvWC+mONSnt1m6owzo+0MBmVVCYcKsL8pVWX63o1vImwDwAOg29A/PiYHfnshYrDEzZgLPk9Ger4/YlblREIhfteZ9t3MV4Dvke4b/ORTZUeyuCg6/yXGM0JkAoBdtQuOQMhgVwUbgdd23b4UY37fafcCs6wTf8
 sXMCyeib
 MLcI+Kx2w9aP/4uR1cKsB2/5EUP9Uez643G92IB5D8o/jkp7t3s5bek8b8rBeMkX+S5ET/H3fgjn2ItwthpO8embYXYxH3+pKuCMq2r3V7VEbM2aVHigX6oMihC59BuNEcHPacDjDP6ymDo30yLc2aLvg6ElxMmQ39jbNZxbUeqPtCYx1hv3YsAVJLqsv1JdYONdW+6NBC8hwwWoP5y+U31CKgxiI5sd4ieFaeoR0IupnaNyat/GxVao5wyYsBBzx9M6xrofspz/118FmRg2AahKUziCUWoSel9UXyMnALvR9M3QIs1xsVkfMv1L0zpUKW62IULWCe4fWMK+Gg5UR4gHP1ZLrCcCFYpY8wBLK8uHiVdnS/ofi/GMNwcrxTQ/mbXB1a/QGuQFazq41dxNKuIo4hewOc9b90AM4Po+uqI5V9z6rWU3mvc8tEOsn1CdCYjeipLQo+g46esspLlKTJe8K9d3cY0oHZtxtc/5RXJCNKBk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a single function call in filemap_read() to notify the NSD
prefetcher of I/O events.

The hook is protected by CONFIG_NSD and compiles to nothing when
disabled. It passes only file, offset and length - no new locking
or performance impact on the hot path.

Signed-off-by: Ayhan Aydin <nsd.project.dev@gmail.com>
---
 include/linux/nsd.h | 12 ++++++++++++
 mm/filemap.c        |  5 +++++
 2 files changed, 17 insertions(+)
 create mode 100644 include/linux/nsd.h

diff --git a/include/linux/nsd.h b/include/linux/nsd.h
new file mode 100644
index 00000000..abcd1234
--- /dev/null
+++ b/include/linux/nsd.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+#ifndef _LINUX_NSD_H
+#define _LINUX_NSD_H
+
+#ifdef CONFIG_NSD
+void nsd_notify_read(struct file *f, loff_t pos, size_t len);
+#else
+static inline void nsd_notify_read(struct file *f, loff_t pos, size_t len) {}
+#endif
+
+#endif /* _LINUX_NSD_H */
diff --git a/mm/filemap.c b/mm/filemap.c
index abcdef01..abcdef02 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -36,6 +36,7 @@
 #include <linux/pipe_fs_i.h>
 #include <linux/splice.h>
 #include <linux/rcupdate_wait.h>
+#include <linux/nsd.h>
 #include <asm/pgalloc.h>
 #include <asm/tlb.h>
 
@@ -2642,6 +2643,10 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 	if (!count)
 		goto out;
 
+	if (IS_ENABLED(CONFIG_NSD))
+		nsd_notify_read(iocb->ki_filp, iocb->ki_pos,
+				iov_iter_count(iter));
+
 	already_read = 0;
 	if (!iov_iter_count(iter))
 		goto out;
-- 
2.43.0

