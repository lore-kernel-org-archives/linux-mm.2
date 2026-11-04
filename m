Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7AC2B606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 07:33:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=C2ZZYyff
Received: by kanga.kvack.org (Postfix)
	id 7AD986B05B2; Wed,  4 Nov 2026 02:33:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75DCF6B05B3; Wed,  4 Nov 2026 02:33:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674266B05B4; Wed,  4 Nov 2026 02:33:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 451BC6B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:33:46 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B15944067E
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:33:44 +0000 (UTC)
X-FDA: 85396621968.01.17F15C8
Received: from cmccmta4.chinamobile.com (cmccmta4.chinamobile.com [111.22.67.137])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0640A140005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 07:33:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=C2ZZYyff;
	spf=pass (imf23.hostedemail.com: domain of zhangchujun@cmss.chinamobile.com designates 111.22.67.137 as permitted sender) smtp.mailfrom=zhangchujun@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793777621;
	b=JzCvf8i/yNNs0L6c2ZJVMOFdbZY1Iqw+6kuURwCIneBsax79A6UJOPbPBwaPsI7Du9UpD6
	fYLxm2Xsieu7F6icjH/vkxjyiVtqbrITU8CllyNbSGTKkDkvd2hG/pSvYW08CiT9/jgfZ6
	bko4n4E8VKhzMe6l73+SJm6Ofo27hq0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=C2ZZYyff;
	spf=pass (imf23.hostedemail.com: domain of zhangchujun@cmss.chinamobile.com designates 111.22.67.137 as permitted sender) smtp.mailfrom=zhangchujun@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793777621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=puWXnPQV6kQ5h9omgYaR4jtMYGDqndD1i1z//JNrJKo=;
	b=KKHryxn/vPdBBMKn0tAt3uv9xHhSKF5ouzCiHtzAyELlJ9dHj1Ft+mwBb+nsY97/EpDt7h
	QDn/aUhJg1ZJ0iCa78SYwmmDuUy39MmpHH/J/9hIyshoT7LQxRTXjrIkA9vmp4mHnZEQZt
	l5z+TRemBd/XH8O70MJzy2191SNj034=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=C2ZZYyfffb+IROxU/52LDnM1oPZk+li0N9ruqwXXUXr7e07JZYvavM+sbcwKozREgswIGjHfFo954
	 jtSmnD/59OteSTzEjA0PyCmQadcFmFnhfyUCx+Lazf4tnviLsPbmSUr49/JlnP3b5rYhHuI4E4SJSC
	 NxzPqitNHLzcKESs=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app04-12004 (RichMail) with SMTP id 2ee46aeadfcc0e7-3ab35;
	Wed, 04 Nov 2026 15:33:32 +0800 (CST)
X-RM-TRANSID:2ee46aeadfcc0e7-3ab35
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from desktop-eb75daa8a6be458c-20260816004526035 (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr05-12005 (RichMail) with SMTP id 2ee56aeadfcab3e-19020;
	Wed, 04 Nov 2026 15:33:32 +0800 (CST)
X-RM-TRANSID:2ee56aeadfcab3e-19020
From: zhangchujun <zhangchujun@cmss.chinamobile.com>
To: akpm@linux-foundation.org
Cc: vbabka@kernel.org,
	linux-mm@kvack.org,
	zhangchujun <zhangchujun@cmss.chinamobile.com>
Subject: [PATCH] mm: page_owner: use %u to print the stack depot handle
Date: Wed,  4 Nov 2026 15:33:28 +0800
Message-ID: <20261104073328.1737-1-zhangchujun@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jh1434c5kuhpitcdfyfrpthqt1z6mmbg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0640A140005
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793777619-66136
X-HE-Meta: U2FsdGVkX1+RWWJR8tqNUzeJIt/f+oKktJKiMYyl9PGpZAvHt8O++fcVPTzORpKWYvSuQPy3k4v2CWQuNShKZoZyHQ7nlaJuIS9Um3TxhBCLDZFnvlUBDs1uBHzvz+SvQKVIusBKDxAyKjgrvobT8ILU76rxCzD3Bt2Wr4EqAYVFj5XK/Z2Ndw6BNxJtAscrD/a7Tn51yMngTvJQLbHSOP/mQaIIttec/hczp8/YbQvXkxfhOwu6zHvPTzkjipDVXt5pSnDW0LJG3mG6PJ8WiGT9T/ya++62VhqfRrWVrZY/FQBIRGuaQy9SyMQbbbst8y+VqtIkP3qMT7V+p42RsK6frdiTssE2fjvarxYqc+d11gy7uAZoSvTi75rOryV+ovYYHDIiQj5IsNeIGVg/h6P9IlKYlM3GYf1ntuYP88wZcnedTiA86OUzD+gLna67T6rKv/uilSi5w4Z05/LDk3jubeCEKYtNQNagPDcoZ9BkwQO0da2GVLv9QcQSRyRj3IOeqj9o3I2x52KdahU83Z2V8jKXSDm/S+3WUXr7PLRvdQV6eN32sWsSBt6co7+LfoI3nOCG4fe5csuNvYIy1P3nnmP+Bv1FjVyABX1ZO/7np3ybjnAVE7YWTZtl29N/ChIJNQeiTG1Zogsk4vZbKoP5+QEFZtu8FiNg+upm2GKPqWq5VLRBN43OQeck6RjYn7y+4Y5v2Sw6LdE1VSd9UHOrYESXL7mB/bGzC1BXzySOIrPnq/cvj3xiY/nKkKAgfN0d4LRhMMJ5LiVNZ3HZarQEDF3jTHZD8NBM5/CQczl27YG+14Td8KXNGCdNmAd+Nva5r4vBn069EHdw9Ckr2sFxrSM6tzafAe3NM1JAIsQZ3rjVEBTNFKcWThXBmGn1PC43lJLVBmFb75KnHVP29AUdx6oFX5vsVk92Pj1KYnKZtwByWKr7dDGv4/fB5MJBYhYpV1k5SUHFm+g/f+e
 n2KB/h3X
 6fwBdQdFAFKkdcUYoWpESHe7gx4phjVXt288PtF9cZk8hVnr0B2/6ulTuLh3zwmAOLUS0OhB9+HwLYDLUYHvABZB8P6LEJ8d/ovWYW+83YEHI2WQMkxSNP3EBmKzgCRuDm4La5kXkV4MGi9TXtEzP8YqXjWFCmjdtP9SrBIm1X/ezBsq8ShJfN/pf+Mk2Y5a3t6lH+/ntVQj1t5dkxXOd1WiqDF75GmOQWKTIRqQcG0/kmf8LAIw2ov4p9+4t5xPHDAsmNIk2gzw8hitQ+3HpqsaaeDvI343bERUMcfWnLDQTaDftTDYzZsdJQ2ZjouQsF9IgAhQ/tm9jJZQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

stack_record->handle.handle is a depot_stack_handle_t, i.e. an
unsigned 32-bit type. Printing it with %d may display a negative
handle when the extra bits stored in the upper part of the
handle are set, which confuses the users of the page_owner_stacks
debugfs interface.

Use %u instead.

Signed-off-by: zhangchujun <zhangchujun@cmss.chinamobile.com>

diff --git a/mm/page_owner.c b/mm/page_owner.c
index cfc31c92d765..02bb304b53cf 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -1089,7 +1089,7 @@ static int stack_print(struct seq_file *m, void *v)
 			seq_printf(m, " %pS\n", (void *)entries[i]);
 	}
 	if (ctx->flags & STACK_PRINT_FLAG_HANDLE)
-		seq_printf(m, "handle: %d\n", stack_record->handle.handle);
+		seq_printf(m, "handle: %u\n", stack_record->handle.handle);
 	if (ctx->flags & STACK_PRINT_FLAG_PAGES)
 		seq_printf(m, "nr_base_pages: %d\n", nr_base_pages);
 	seq_putc(m, '\n');
-- 
2.50.1.windows.1




