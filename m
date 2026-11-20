Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6D4E606A33D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 06:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=hPOqM6zX
Received: by kanga.kvack.org (Postfix)
	id A86106B00EF; Fri, 20 Nov 2026 01:21:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A36516B05B2; Fri, 20 Nov 2026 01:21:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94D046B05B3; Fri, 20 Nov 2026 01:21:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 744796B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 01:21:52 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E48EB160D7C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:21:51 +0000 (UTC)
X-FDA: 85454501622.20.A991CBE
Received: from cmccmta6.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by imf27.hostedemail.com (Postfix) with ESMTP id F19744000A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:21:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=permerror ("l=0 does not cover the body") header.d=cmss.chinamobile.com header.s=default header.b=hPOqM6zX;
	spf=pass (imf27.hostedemail.com: domain of zhujun2@cmss.chinamobile.com designates 111.22.67.139 as permitted sender) smtp.mailfrom=zhujun2@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795155710;
	b=Tu8qv96UDbwn7E5MeNTKueNX2ZJyEifgU0cg5JbD/iSdppF0jImSJ313QxkEdeVkGcDpJh
	6Juvp0tK9FuCFcPBGJ6DjYptfyy30UuI8R9bwfRZDrjzkTWfCDMxBHASqAPbXKNo7Nck2+
	uBGUrg9SmyQJcD335dmeCo/0xWoM+UQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795155710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=yOQQwiLmhHuqYCmPwMZzQ5zVewZ5N/g4NEG1AkPQvjg=;
	b=j7Zvi3DbYDIjgggWSuI07QbkRretbvD2CPdKEhfcrUCv+FBVOWhsJGexMoilTF5HDGCYY7
	SAK8QuFblniog/GJP6EtP0iLJF6MfOgcE9krR9tZt/p8EEuYH1xj4ZblhzFgiGVADuMx+T
	nXm5wVY62EIdoE4LVUV95CGIqvTyHmw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=permerror ("l=0 does not cover the body") header.d=cmss.chinamobile.com header.s=default header.b=hPOqM6zX;
	spf=pass (imf27.hostedemail.com: domain of zhujun2@cmss.chinamobile.com designates 111.22.67.139 as permitted sender) smtp.mailfrom=zhujun2@cmss.chinamobile.com;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=hPOqM6zXQ9EAsmeKSbO60Un5COTd+YvFnmBOjCaRjBCFRJzfm0P9VTXSdHAOl+8AHH6KXGW8lJMdf
	 6YdFb6OsPFvcD++SEFbUlFkl5L/BnAz5OTUBjWDL/V7OWqVjVqT0+caa/hVq76LgEzy5ItoTDDivfK
	 lq9eGOIx4VhrjsS8=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app01-12001 (RichMail) with SMTP id 2ee16affe6f40c2-00c96;
	Fri, 20 Nov 2026 14:21:41 +0800 (CST)
X-RM-TRANSID:2ee16affe6f40c2-00c96
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from devin-VMware-Virtual-Platform.localdomain (unknown[10.55.1.71])
	by rmsmtp-syy-appsvr04-12004 (RichMail) with SMTP id 2ee46affe6f4b11-18915;
	Fri, 20 Nov 2026 14:21:41 +0800 (CST)
X-RM-TRANSID:2ee46affe6f4b11-18915
From: Zhu Jun <zhujun2@cmss.chinamobile.com>
To: vbabka@kernel.org
Cc: hannes@cmpxchg.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	iamjoonsoo.kim@lge.com,
	linux-mm@kvack.org,
	Zhu Jun <zhujun2@cmss.chinamobile.com>
Subject: [PATCH] tools/mm: Preserve the final page owner record at EOF
Date: Fri, 20 Nov 2026 14:21:40 +0800
Message-ID: <20261120062140.98503-1-zhujun2@cmss.chinamobile.com>
X-Mailer: git-send-email 2.51.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: y6d5k8zakjxzgdqisyhzaonwehcn7fm1
X-Rspam-User:
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: F19744000A
X-HE-Tag: 1795155706-614587
X-HE-Meta: U2FsdGVkX18qSh6MEf+KK4PXQ4nl3wcFV7CBHheRCej7/gJCYBJgiYFFnp9ioY/eT/dR4I3T5E6IFPzYw4o1w4+SqKhhhv41NOTaNTMdpkvvB4ZCfZ1w1ydTYARlwjARtz8A8djE1IXQkwPSMQYwGLeKVLTlAq7zcZDQlSEA7BcgS86VOx3i7ENMQoVGGLlJwCXwcy9G8fLG/j9wtByaMkzww6yHh6bvgni8z+7XC/Oplymz8wl6ykZYicopyXnjeABkm33ek9Fgg31plmebm1VhqOb4TLZv0HGMW7EML8LLebNz7YPAP0WJHLjhHn8uqP/q0vtEdbYyq6sxtjbqNkxwFG6eyRAXtMsJlI00p4HdnC8jAGGkyLCUNHJRkSjW/Zr/Ig0w9oekskbU/REyrcLADL10esWit/rEQ9Gq0cHELoPd/mVh8uV7xyH6LYSKB9UibnPxe6F9eS9GX2nnkBAaRdEkYnQTw9SDyypPqRULD+jT6xZGVCpzCuoTZYB22hInx6T3H001jh8LcCDMlAstYer2F5JzvclzcDFo4ZNExs4NSV8IaeeNqnhDMueNHABwrOY1H3Ubpzx1HP6F4LSnf10koRSzyRzY9X6xFkzKdNc7dKeTZ4pu52afC/QfdrApXzyBbz1QSy/LnGJr06McxDqzRQjdmUvju1o0dk3bPM8tYbK5pHwm7wmZ6W1LJZWBY72CMkNe4k3IqSehX0pblL0CZt6tCwExFHKDpc7jUeU+Q0wIoFWNbuJXwjt39gqO7ZTaNRLVt0tDco6L+FnCJdbDwLZq51g4ViokmFDRSTD8iusQHaa+XMvjYNgXqkuUCp4fb1E8bl3t1bs5tBWhB8r0y+J2uSv0JuKVzErdbCXAyxlys+L/oUz44bjRsnIXdMe72EKomMpgZGMKZtsjZiCVziJFBu19TXHzyD2Xwa2oueVbeh9fag4v4EGyUkVW8p94/OPn5PHKPGE
 SzminDoI
 OmoS15WGwysFjJPlP12qqRjita81jAxBIERNqjqZlkdOJn/PaEkHpGHwVm0VfTATmn7rS9tXHhbYFr9x8FbMQmnKu65uVvnSafaYqpFSQGKtJ+leybdOM3hhh2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

read_block() only returns a record when it encounters an empty line.
If the input ends directly after a complete record, the function returns
-1 and main() silently drops that record.

Return the accumulated record at EOF when it contains data. Keep the
existing failure result when the buffer fills before reaching EOF.

Fixes: 48c96a368579 ("mm/page_owner: keep track of page owners")
Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>
---
 tools/mm/page_owner_sort.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/mm/page_owner_sort.c b/tools/mm/page_owner_sort.c
index 6c2ac5d9dc4b..48c403d3de4f 100644
--- a/tools/mm/page_owner_sort.c
+++ b/tools/mm/page_owner_sort.c
@@ -134,6 +134,9 @@ int read_block(char *buf, char *ext_buf, int buf_size, FILE *fin)
 		curr += strlen(curr);
 	}
 
+	if (feof(fin) && curr != buf)
+		return curr - buf;
+
 	return -1; /* EOF or no space left in buf. */
 }
 



