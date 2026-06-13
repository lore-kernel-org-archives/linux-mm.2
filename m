Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B2FCCD98D9
	for <linux-mm@archiver.kernel.org>; Sat, 13 Jun 2026 05:10:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 071506B009F; Sat, 13 Jun 2026 01:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F130F6B0005; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1D836B0005; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4CE186B0005
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 01:09:59 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D177B8D165
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:58 +0000 (UTC)
X-FDA: 84873712476.03.1DDF846
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf09.hostedemail.com (Postfix) with ESMTP id 08861140007
	for <linux-mm@kvack.org>; Sat, 13 Jun 2026 05:09:56 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Nos2WlW4;
	spf=none (imf09.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781327397;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MZHJrCjRIjmtPr++aWYgFPkpaIkTjbAk/NLmMP37eM0=;
	b=TERxsCMV/nRk6y4kzjfNzmPLKynZEWqQPUFkIIjKleSmKAMeGkNRIGS+vG0EudxRSGTCtC
	YlcEVqitTPe+yzjaXNDUczdcWiZbcmnTIlctw3v6+282Tk9gYGq4WVoP7JjBSsvoYtFv9k
	ElsN7uTQRBu+mSjN8PPsidIUk0Nlp8E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781327397;
	b=49hvvhUnXl41KpwkZXKw8nvkHMRg5sLXaLsayTztTj5OkaAoVOcn4O7F2OEx0vQaeNv8dp
	0Ec/bRyAH8KqDDjNC4hOxjVF/MWt7pIeBDSsZNEpm/jnBONG/ZSpRPdNg3Ppz5Xr6eC4ul
	w3XxMYsRkf0hu+9Zo50/dARYR1DnoGk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=Nos2WlW4;
	spf=none (imf09.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=MZHJrCjRIjmtPr++aWYgFPkpaIkTjbAk/NLmMP37eM0=; b=Nos2WlW4avhTR8+u6YCwvP8d+s
	oR4tk0eASVMFp1JK9z90AsQc9iVzAv8lJ5g6Oq3V0cswhjNaSsW9udD7a0LaIfU79kijFMTINaMEw
	zzhY/WUIgnBhvlQgiIVZqOoJayPotZl3XKxvKhMKSlIuQWf2fMe0wR0jnBdUFSsrpmkHYzYVJfRAI
	26CVSNTzEp4CASoQ1Zvj8vEFN8HewtZCSjEwHJnFUHdfUwgApdM88Cw4bjYogzaQ1m1CP/0zlSkqc
	cEi6Cdfuy0iAVYXFU44xyp59MDfZ1D+yM8lO0WInLgTOuZDlW34XCmuoZyv2pdoeEz/LCddifL12j
	IF5WbyQg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wYGcz-00000003aTL-02av;
	Sat, 13 Jun 2026 05:09:53 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: linux-mm@kvack.org
Cc: Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mjguzik@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v3 08/10] make seq_file_cache statically allocated
Date: Sat, 13 Jun 2026 06:09:49 +0100
Message-ID: <20260613050951.855141-9-viro@zeniv.linux.org.uk>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260613050951.855141-1-viro@zeniv.linux.org.uk>
References: <20260611171425.1671254-1-viro@zeniv.linux.org.uk>
 <20260613050951.855141-1-viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 08861140007
X-Rspam-User: 
X-Stat-Signature: 1jkj1m5z45jfbxhsfdjczipaefynhf6e
X-Rspamd-Server: rspam08
X-HE-Tag: 1781327396-529744
X-HE-Meta: U2FsdGVkX1/6dDHB55cHaEJzvQckzaDV+jAYtHaweUkNAVptySjH5wG3aKVIfkcRZQtIW/m8FGHkn0TxzGQQH0ZgxOLqObYFYtwQ3nOOpTl1FtZgYjxyPY6JA2kU/4Ks3PqIoMzqM6N2wx9jEpU1MzxbfL0ay/MV9p6czZneQPOFlXIXu+OWuTZZASkmF5oQRLdlnNwtyXo3lDA6CYjmUxQDBDYaa1TIanlrnEKtMTVaI/z6UHVwVbOdyTKZEZXyaVsXA82+ENofS56GWkpttbBsp4rP9ALblhPcPSA5wGyUAbYrVuTuZzPKtbkTXv4z8+dfVomTCqP6hMvVL3sTsgrTvLo6B7/d9WgUDIJbiMW7zA7/Ju48al4OgXez2WuMKJBmJRbjbevXXbsAZF8E5H2TTaPVBWGUjswVt1RAQtmf1PjNAth71U20FK9GaPfRFkbSMkAjK6ryGEP/Dx4YldIgMkGXLhBdd2eOx8KJdxLiXvm8NEOdaaOwJ6oxMQQ+Fdvai2VWCbuTNQUs+gkak1tH3Eu4FFwpA2JN060+HU3fmIL62R3md7Qw9BqwLBR99Wnw4VVJEeZc1Zqka1NHD60XO8aUmCSXwACLLeE34SPdAx6g//F8EmPZa4JU2THVbLqUGumGYrYuRHbT7j+rk/gHR6WrXGiBw2dYmEMWGER0INi4kr7fVvfEOghxOsecY6DEG9WbRaNgx34f/GDRFL3gxBFSsJ3Kp6xxc2wE8T+8CWaNdUKnsGDOvCxTlGLJwT1+wARDNbRi10V/wrSJdrPAOxAITspwKgzpgRYWWYYkiKBf47dqSTQM47u9yPS2TuDU5Uvma3e/2RiXH6q5fdDKs8nAS2W+awk7q4Reno+rzw1nvYiqNCzLbssMYKzIQhiIH3Gs6d/W9QNPHHAcC9pRijj6iNCO7OqLmBm30yZsy+ANkvfkulr6/6Y+uZkAIepAJe4dh5a6VKKqACL
 7c3RGw6B
 QnrM/UtVDZXcMUNzDojXoV+fxv4GVFal21Cf9nHsSlI/Fg0yByvSkZ8KcyCOcdgE7335pdOY4c/w0qJgEvZHeRPS3mTtnzBkP2PRoboXYGPJcALXIx8u7kHcxlD4x4MyOLycX+x+1kYel7RBYV6VyPOnHPXQUw2NCg03Nc111JrTun3kV7pVzfUInkH2EtLEG+l4zP8odiQgqSvESR4O8Sp4YWjUH7ZUtCk3iA0x5btnKRNVOzVv09jBh9CwXFKhPeZQSx4MMSMeEVFFb8mfU8xy1QOr5oEjLz6IYczlh9b6CjYhliCYfYIsrAxWZUw1FyEvj5Lrjt9mpYihh6yVVIluaK3fZgor7G2WHUVQpBWh8UtWA7F0rTisnrmgTrcvAAKSu3yDIw6H1zlahLQj6kjtxUq78PFGdU7XYs9NhyxWNa3IfGkuDnMjQpTpCxWlhiPi1wAnkuLigPKcDRqw20z+MJpruGx10M5CB/sTdAYPdv20sf4amPBHzCA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 fs/seq_file.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/fs/seq_file.c b/fs/seq_file.c
index 4745db2a34d1..7cb40ae83f9b 100644
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -20,11 +20,13 @@
 #include <linux/printk.h>
 #include <linux/string_helpers.h>
 #include <linux/uio.h>
+#include <linux/slab-static.h>
 
 #include <linux/uaccess.h>
 #include <asm/page.h>
 
-static struct kmem_cache *seq_file_cache __ro_after_init;
+static struct kmem_cache_opaque __seq_file_cache;
+#define seq_file_cache to_kmem_cache(&__seq_file_cache)
 
 static void seq_set_overflow(struct seq_file *m)
 {
@@ -1140,5 +1142,5 @@ EXPORT_SYMBOL(seq_hlist_next_percpu);
 
 void __init seq_file_init(void)
 {
-	seq_file_cache = KMEM_CACHE(seq_file, SLAB_ACCOUNT|SLAB_PANIC);
+	KMEM_CACHE_SETUP(seq_file_cache, seq_file, SLAB_ACCOUNT|SLAB_PANIC);
 }
-- 
2.47.3


