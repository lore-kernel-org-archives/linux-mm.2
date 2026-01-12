Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E349DC9EC9B
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 16:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 523F56B00A4; Mon, 12 Jan 2026 11:18:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BAF46B00A7; Mon, 12 Jan 2026 11:18:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 389596B00A8; Mon, 12 Jan 2026 11:18:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 231156B00A4
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 11:18:28 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E5C0F1A067B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:18:27 +0000 (UTC)
X-FDA: 84323819454.01.D6179F7
Received: from imap4.hz.codethink.co.uk (imap4.hz.codethink.co.uk [188.40.203.114])
	by imf20.hostedemail.com (Postfix) with ESMTP id 018F11C000A
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:18:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap4-20230908 header.b=fa8dVWIj;
	dmarc=pass (policy=reject) header.from=codethink.co.uk;
	spf=pass (imf20.hostedemail.com: domain of srv_ts003@codethink.com designates 188.40.203.114 as permitted sender) smtp.mailfrom=srv_ts003@codethink.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768234706; a=rsa-sha256;
	cv=none;
	b=zay5nMX52SiEwOsXW9DhzuY24CWtmT476mwFTdzPDAnEZbgTnNNFPvqWb/HBS768KrfBN7
	GymvP5bZW+gEZm+6fNzuFnneMsvMB6f73eqftwn6mGgFFLOFmdQlMSpR7OtnTU+G2YKwe+
	9018NXl5bk14l4Xq87QduOFh4vcr27w=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=codethink.co.uk header.s=imap4-20230908 header.b=fa8dVWIj;
	dmarc=pass (policy=reject) header.from=codethink.co.uk;
	spf=pass (imf20.hostedemail.com: domain of srv_ts003@codethink.com designates 188.40.203.114 as permitted sender) smtp.mailfrom=srv_ts003@codethink.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768234706;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hjee5K0PvLG1HwB9aNicqxJtJ/+XY1tnsP3uN70nalA=;
	b=MdMIYU/wfdno9Pbu1lCEyUOiqcjuxelfn3wZnFQ7spCX4oCAXm13bAesmWDltYq6acKSHF
	7xaT2UTEzwQkopT/Hj0brN4TbkTp7PIh8cbKv5L5EckdmeBWoS6H82ti4Un7oXJ1mR+H7Y
	Fn+Zfo1w7DZauJvBZy8Yvkww5oVtt4M=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=codethink.co.uk; s=imap4-20230908; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:In-Reply-To:
	References; bh=hjee5K0PvLG1HwB9aNicqxJtJ/+XY1tnsP3uN70nalA=; b=fa8dVWIjLQm7wk
	DHEpEpui8JoqOzkcYkENnqgSkv9UMAGCE5sgJmSnNrDop5gEr0DolHhmPliT9HCbV6KdUR8DDQN2x
	PN8gQo4VCmnAmc6UtI0kAnhPiKMv/757QOaajL/TmnuSLXwvmkhI+ovtKI+b0U9kpWQHVYy1+W3g6
	27cqthiA57Y3HWrPcrbng2abV9uiE94dkccZuzGOM7jBaDgJA2ww4mitk/EAoDrCRrqi9O1fr6lxv
	N7l5ZGc+Lkv0IKGzlz5WYYAzsLdMKTSNG04DfjTeXai8bY6qC15UF6xkg3IfnrHH1mTx/fQe3Lh7X
	XySKRcneJArDCH1B5VuA==;
Received: from [167.98.27.226] (helo=rainbowdash)
	by imap4.hz.codethink.co.uk with esmtpsa  (Exim 4.94.2 #2 (Debian))
	id 1vfKcX-00FS5U-Sm; Mon, 12 Jan 2026 16:18:21 +0000
Received: from ben by rainbowdash with local (Exim 4.99.1)
	(envelope-from <ben@rainbowdash>)
	id 1vfKcX-00000002XIw-2gw2;
	Mon, 12 Jan 2026 16:18:21 +0000
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Ben Dooks <ben.dooks@codethink.co.uk>
Subject: [PATCH] mm/khugepaged: make khugepaged_collapse_control static
Date: Mon, 12 Jan 2026 16:18:20 +0000
Message-Id: <20260112161820.604669-1-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 2.37.2.352.g3c44437643
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 44tc9bx6bkwxeejhrpd8ywg1gf9jb1fy
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 018F11C000A
X-HE-Tag: 1768234705-911844
X-HE-Meta: U2FsdGVkX18rPRBajq9Trhva3jHJHRxxnystYEEQYmxDdAyh4fqqH0r4CJhV0r+xWw5waBjAfOzDH93kBqv2x0Ar+FVDUa9TIyIRtz2JUtWoUIZUTWoC0bRUhANV1xw2t/QsRbfzq+hR01ihyQnU28lqW+gJwYMqb2xOZq2VStntAy7Hzbf7t0I/xR2FsKJ+zvDFlJt69CgtOnzsUvujrYyi3vCs9yJMiHvI9iY0TLmkE3NExaxsZKpAmbabMLOnrd/GPVLeAYFqrjqUdDObUrbWi3o5fUrpFS/aWeeD+//hSoupWkiLccVzrSfZwD0//5aBh/+hvgu13APA5Lu1YrpfYEFHTWHI+T/MAPIVnJLC5fh92FGkeDVZNdnXhFKvVAexPveNg3EWJ1SXTB0I04PKuiN9ja7WPZ7LM88NS+NBFfEjmL7EoM7z1xYBSTnNLHPn82U3ssNMx5W857Rne5vk2eaJJ5BQ8b0qmw2CA+b2Sh/9Uf2RAqifVqnHkvwkifjZsffihES0ZNlraQf7nDcKDepNMkPDyWPTGtN3aA1z8MUGkbDjiaRv7eDeZrBASGv3qUJdOdvljczM4L+U3Gyrxtf5wpsa3ckauLJ2u6veQ4I+c91vrko3dEflpBT5hRsfdUlNgCYcRGS8QWkw0fCHGnRUX/0MffXYUHaf9EyXfI0aThQk1T6yeZK6Lf9wgkF+Yx0nPcCQVzA4XFBkNSEu6wCKtYMQNu09rxKzozmx+bVy6MMTHRWy6e21RXyqJoo3FX/N0/4lTixo883N2BeloaK9LQYYVRzv0HIUcr5CCRqpwk7hR6RG1rnu2dB2TrsZ7Ul3lmP9myA3VcFSOC+Wqp5iVE3rnlk1jeghw5ji+l5LuM/WEWcnhHQNtOw4VBCjGhjGAQoFC02ufzu0a1Neii77wtGoMQFhj/Zj7ioGtCdUT93RAvEhkX//yoiJ2W381y9KsxGqyqD+qDx
 8Qzn3cyN
 /FrgxpeUFK/6ctzlRCCWT9dsbKvqE3nr1Vks8c6sV3g16o9zNje72Sn8Czyoi2RZju5yl/RflaXGzc1vmy/tcuw/lQWkJJ1z0V0MwW/V+JKKEvC93Rr5sCHzg19oJjilDmVruV7D2lglZgJafY6rJcSmInifcjD2qQVT4tLLiKDttqCfZAhVoJuVDWePxPqhUUOmPJdsIgXDlpSsxH9RKrWueafL0Mafx6MZYNgvZ2sAkDhnjSw8h0VqXtN2AqSImOc8/mzlC9eZZBZmRqvsZibbjNM2+s+9/nhgeB0DAbbq7s90JPfaVaheMS8EQBZkoyPM3QOMKoOaCkFFQfVfLhMKxUdTf6pegPpxiCBljkO55WrrXgw5zNpygu85MWmU3FhhO+j0Jupt4gynAICTy98X+IEu29WWjSleDdWp80HPwyXFqnCCCsM83hcEhsrgZ0tmxER4pkG8hO6+HYq18WKW1ED+FkwOFpitKuFBQh+u/sj8nqKmY21u6n5glEWYpAUlXMZO6VkydhvCalLIbLv5dUQ0eYLOxGXfg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make khugepaged_collapse_control as it is not exported.
Fixes the following sparse warning:

mm/khugepaged.c:829:25: warning: symbol 'khugepaged_collapse_control' was not declared. Should it be static?

Fixes: 34d6b470ab9cf ("mm/khugepaged: add struct collapse_control")
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
---
 mm/khugepaged.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 97d1b2824386..c9bd0df632bd 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -826,7 +826,7 @@ static void khugepaged_alloc_sleep(void)
 	remove_wait_queue(&khugepaged_wait, &wait);
 }
 
-struct collapse_control khugepaged_collapse_control = {
+static struct collapse_control khugepaged_collapse_control = {
 	.is_khugepaged = true,
 };
 
-- 
2.37.2.352.g3c44437643


