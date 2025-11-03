Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11BD0CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 06:59:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66B1E8E0023; Mon,  3 Nov 2025 01:59:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61BE18E0015; Mon,  3 Nov 2025 01:59:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 531518E0023; Mon,  3 Nov 2025 01:59:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 402E88E0015
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 01:59:23 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A5EEE1401CC
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 06:59:22 +0000 (UTC)
X-FDA: 84068394564.15.FFDC29C
Received: from cmccmta2.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by imf08.hostedemail.com (Postfix) with ESMTP id 896E7160008
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 06:59:19 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of zhangchujun@cmss.chinamobile.com designates 111.22.67.139 as permitted sender) smtp.mailfrom=zhangchujun@cmss.chinamobile.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762153161; a=rsa-sha256;
	cv=none;
	b=vcDkKk8PfMTIXPsHXfvlyoUU5/Z6ZaRODEWwKG4GIgCV7202oA5hg2guY21h+TNzpifqlt
	wA69Lj7LiFFHjblRZ7EMDln8K58py7f7dRAvxTJuu0naUTG1gjT9XhmKQK/ENhFHqFMCPo
	XMFfgAbZ+RAk1WfgyMKZKPYGQyZ+lTQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	spf=pass (imf08.hostedemail.com: domain of zhangchujun@cmss.chinamobile.com designates 111.22.67.139 as permitted sender) smtp.mailfrom=zhangchujun@cmss.chinamobile.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762153161;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=8+zwHYxLxejwCJwYPz4PWby587pXN55vsfl1JA9beq4=;
	b=XDnBRpl+ArKlK8cr4LYdz8C9KO58///d5P23yLzLfhBj0fSGuSz1kjuQNP2YNKn5kPAN/y
	3No5F9MBJ2qzjKYXcahJRGO5hdI6E2FeQsu1qbr5QqdIsaNenD1P+0enHhD0V2fYTns8/8
	mM+rlzTUILNeMdRDe16zL2i7C5ReLfA=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee5690852c22a3-883c5;
	Mon, 03 Nov 2025 14:59:16 +0800 (CST)
X-RM-TRANSID:2ee5690852c22a3-883c5
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from FHB-W5100149 (unknown[36.137.216.21])
	by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee1690852c16da-c8307;
	Mon, 03 Nov 2025 14:59:16 +0800 (CST)
X-RM-TRANSID:2ee1690852c16da-c8307
From: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
To: akpm@linux-foundation.org
Cc: vbabka@suse.cz,
	linux-mm@kvack.org,
	Zhang Chujun <zhangchujun@cmss.chinamobile.com>
Subject: [PATCH] mm/debug: fix missing space in case statement
Date: Mon,  3 Nov 2025 14:59:09 +0800
Message-ID: <20251103065910.2196-1-zhangchujun@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: iqrprbnmoq9jcypewjoh1jt4fgbgod8b
X-Rspamd-Queue-Id: 896E7160008
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1762153159-721822
X-HE-Meta: U2FsdGVkX1/cZARYNu0tSG89FDVTWZcxSLxdv1Tvdh4gVyPYhqZnGPHkamqGcgM+3nsh0Qd0HSKZ9XQj1f91EQAR9LeINjv/R/Zlo7Sf10yx3WqpwOdmezW7oe0mYzyBfpcqkSgXvE2xV7ZH9urPSCbRk1BamROqTwM7mwsLQGDtmokeRnlBM75COBGQtsZSz7wd0ohrg/oSOgDlNdu1JuZnym5NPSz6H28lMthoZwMEg9vi53lTZ/EuV8IcipqlOQllG2YzBlp6RFPswzKW9Dzm3vT54M88HiDUMjG3a2EHFFqfWOzyy04lGK9zPxPu6C+vlP3tZl3EZOs+cRi7fNZg5I8OpEFgWZhylBJ38ogTcc/EfOhrM1vAUOLhIA3AKyt0lPYyyoIlNSFqB75VL0AjyQqWsID8ux1mC6Cr/3sNowwdkmlobcg7QtwZDxeWVGad7x7JIRkQwySZohF+XsNLCzk8KkWQPBjXGL4j9qrJY3hsj6WPl7rg6pHMkne7YKAEmM5eINXsRv5ynTS8zpaSuWT+3PT21+lyfCI2r7rDLtySe9nETJr3I0C/Os2JGARe8wdsrYZgnMsL4yt5MXG14dbyzeWMRzqMKFuyoeN063fU1r+HtpAKgOeEL5Rp7ZRXEQxswZvhFi6T8/uet+9pQ0ApmYd/HhcWkE7SXgU5C45HwW4BLN9rq7r57l72sZc5ibByQszETx4lz2AAOym6fbtYSwJn3tQKv6phAVrfzOAb+/s2qZsk56Ra7iZ3A8njn/YuPVJStmVpBaOZBT+twfVUMTrK4yvdHK1Ue5Bo+xIdm9Twru20Z8ZV6eymhw0wdPYp9KbDrsBE87sKDlraF4SZ3B6riC9SibKgNWlItcumcEcvHdXTglrUreDq76hCU4DQYlejJ1WP42fcgxOJIFdcje9Gmmlfx8UCYH6F+fhJZknmJbZsdJYcfqUONSV0xYCvO1lDHrNqQIY
 IOWuYVGt
 OGQeLgL1WdxusvAeOLZGq0ATGLojb7gD5HWQO1fiOdcJmgqu9xLUHJYnCH8iFGoqGor7V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the setup_vm_debug() function, the case statement for 'p' option
is written as 'case'p':' without a space between 'case' and the
character constant. While this is syntactically valid C, it violates
the Linux kernel coding style, which requires a space after 'case'.
This patch adds the missing space to comply with coding standards.

Signed-off-by: Zhang Chujun <zhangchujun@cmss.chinamobile.com>

diff --git a/mm/debug.c b/mm/debug.c
index 64ddb0c4b4be..d860864063be 100644
--- a/mm/debug.c
+++ b/mm/debug.c
@@ -327,7 +327,7 @@ static int __init setup_vm_debug(char *str)
 
 	while (*str) {
 		switch (tolower(*str)) {
-		case'p':
+		case 'p':
 			__page_init_poisoning = true;
 			break;
 		default:
-- 
2.50.1.windows.1




