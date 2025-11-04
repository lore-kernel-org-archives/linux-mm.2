Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE2EACCFA00
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 06:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07AF98E00EC; Tue,  4 Nov 2025 01:29:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02B878E00E7; Tue,  4 Nov 2025 01:29:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAABB8E00EC; Tue,  4 Nov 2025 01:29:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DC2468E00E7
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 01:29:08 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DAB7B942C
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 06:29:07 +0000 (UTC)
X-FDA: 84071947134.26.2BF47FD
Received: from cmccmta1.chinamobile.com (cmccmta6.chinamobile.com [111.22.67.139])
	by imf19.hostedemail.com (Postfix) with ESMTP id 67BE71A000C
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 06:29:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of zhangchujun@cmss.chinamobile.com designates 111.22.67.139 as permitted sender) smtp.mailfrom=zhangchujun@cmss.chinamobile.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762237745;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=Kwi75LdpcJu+ck6mwpnD5F5oc/DeRwlNrjl8Vm03mVI=;
	b=AS0JTKnlrG4xVVjfeL0i/IIy82HCdO/0qS0eLzcOG5ogQr2r7nSnPqUqnx5L+inhuwWcH/
	g4/K42c5ecWqKUbuEztrby1H1DGkPWxKnKWx/2zByRfDJB0blOxLPxBr8yTnGa7efZHpZd
	Aa/d6v7cRUAgm89PrvCBLb7Ipbe1KHk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762237745; a=rsa-sha256;
	cv=none;
	b=XhArf4Th+3Tag+MbCbo/Wtk7Ag2U9pzAgKdbReWeXsUkHOEd/SA5p24wtJfdgeFlLPymgQ
	QYGgNo+48/yB2hU5qUHmUaxTsmw5eUru4mjEZ0+GOk5mbB/CHklXEoGzQFs7e1B4qRXxR1
	LvaAAypej34L7ZTzihgS1r92lZmNFCU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	spf=pass (imf19.hostedemail.com: domain of zhangchujun@cmss.chinamobile.com designates 111.22.67.139 as permitted sender) smtp.mailfrom=zhangchujun@cmss.chinamobile.com;
	dmarc=none
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app01-12001 (RichMail) with SMTP id 2ee169099d2ce1e-6381a;
	Tue, 04 Nov 2025 14:29:00 +0800 (CST)
X-RM-TRANSID:2ee169099d2ce1e-6381a
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from FHB-W5100149 (unknown[10.55.1.70])
	by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee169099d2a49c-f42fe;
	Tue, 04 Nov 2025 14:29:00 +0800 (CST)
X-RM-TRANSID:2ee169099d2a49c-f42fe
From: Zhang Chujun <zhangchujun@cmss.chinamobile.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	david@redhat.com,
	thomas.weissschuh@linutronix.de,
	Zhang Chujun <zhangchujun@cmss.chinamobile.com>
Subject: [PATCH] selftest/vm_util: remove unused variables
Date: Tue,  4 Nov 2025 14:28:55 +0800
Message-ID: <20251104062855.2468-1-zhangchujun@cmss.chinamobile.com>
X-Mailer: git-send-email 2.50.1.windows.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: buc715dxpkhu3p417c5xn3rcm96c3h34
X-Rspam-User: 
X-Rspamd-Queue-Id: 67BE71A000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1762237744-777737
X-HE-Meta: U2FsdGVkX19VSQZQXVLjtiDY+fHRRP+ktdZig5+QASkZtCzJSsc4igiBNPVpqKHrzwDRpSLdYxnft6Ov8QRb31VxFBbPvhJ3UKLBthoFaEXvnR1iIQU2aBMjT9JOOjN64LqxRwK1+3nCILiUate3kFmeWsID5IRcwhm5WSXnvS3ulPSwwapMnDfNtghXH+mCuLNQY8MExWsLdeVCc5SSXJ5/P367pVcag054aeaHa27Xx0HDqkd99gH7vJl0PWxmUSJDhM2TJOgHgbw3mJoj/bivV6U5X8ALGsO7TZ3KyHiwvKB+uzpdXNmMw1HH/xp4KPsr1EHcaPyI00jjAlkxSc90upTgtqm0kwwy9rHTklzRTHtz/akKo6THFQlEIXL7JlowsGWt11EKCpL9VjnVxS4K5COLfVOBDOI61lZFDBQChHtmCrAmYF/+tWly1lb70EL7en3RAiBdzddLyB2smgVr9mY5rKrcdZbIXMKedul/hB/eAPqBryVqVYIzZafm+T858eiV5CNBG/VXSurI6oThRtRr2XDEQZCAuxj/iS3mloUBnLRFfETKws2IYFOLzavsCugFpllleftd9zSPT4SaMa+CSnio0G66ZNEMvBAc+Jl0Khc/qhcn0r26EtkTd45NZH4MDulsw1fjSpMOvZSKNddXUBa8e63I5v68q9hEn4yIDu0Zqz3OTT+Wbb88BFbqjxuVBj3zzBWt9MJkPp9EkUCiV8Zot041yI6VRrvJ0ZPkJnttNnmR1d+gEkxz5J1afBek42+AuA5uFrwsZUZHGC9iaqO+lm7MenkOTpgAqTCa6VAzY8X6rL6Rki2RRaa16neDvtkpktA1WZqRUNzSKkBUtuHmkr06cSHIfig8YGNidSjLIyaDEzyeZfhrzTXu63MXgnE77g3Lb55HIFO5SutSjxp6tmqCczcux1VHMxmSvv+UgFGDL0kcp6qvD8deOquSvJ1XDm42SWj
 1fkCRMwl
 iQa6/XkxywgeAgzJBOirWQ4fUpJ2JvoIY5RIo+ayjgzsmdD8cmpe3rNwg6cX1Jzg352cG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The global variables __page_size and __page_shift are declared in
vm_util.c, but they are never used anywhere in the codebase. This
patch removes them to clean up the source and eliminate dead code.

Signed-off-by: Zhang Chujun <zhangchujun@cmss.chinamobile.com>

diff --git a/tools/testing/selftests/mm/vm_util.c b/tools/testing/selftests/mm/vm_util.c
index 3869e68bb8b5..3983c368edd2 100644
--- a/tools/testing/selftests/mm/vm_util.c
+++ b/tools/testing/selftests/mm/vm_util.c
@@ -17,9 +17,6 @@
 #define STATUS_FILE_PATH "/proc/self/status"
 #define MAX_LINE_LENGTH 500
 
-unsigned int __page_size;
-unsigned int __page_shift;
-
 uint64_t pagemap_get_entry(int fd, char *start)
 {
 	const unsigned long pfn = (unsigned long)start / getpagesize();
-- 
2.50.1.windows.1




