Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48796C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:32:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A7B26B0088; Thu, 30 Jul 2026 10:32:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F206B008A; Thu, 30 Jul 2026 10:32:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BDB96B009B; Thu, 30 Jul 2026 10:32:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0BECB6B0088
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:32:15 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 985511C0176
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:32:14 +0000 (UTC)
X-FDA: 85045682988.03.350B6B3
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf17.hostedemail.com (Postfix) with ESMTP id 97B1540018
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:32:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Ktvrwkev;
	spf=pass (imf17.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785421932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fZg3NypWeiAG1rQXABIWnvJg9OYo51SVkdRpl65CL0Q=;
	b=U+sDCl/lt5wfW1L3wS9ZLrn/9Ipm6rHO4cZ565Suc8vKhLJWGec8+xUD57RL/FelDZav5d
	M2TiptA/zm6BbVEembeLfeAHQzzghfvJ9koRVxzML4wbv/rwMAduw5yT5RQzwUQQYV5O+i
	42qkPeSfSeK6I3Dusll2jn43+sOJ5wA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785421932;
	b=Nzcl6j000jzB66/XGpsgC7jr8bQpN7weQukgUaDStsSw5Utz76fCA6vQG9bo9OASp/93G/
	iNan+BDgR8PoKM6L0KIfjd3wvIXEb1+qQZEKVNHCWuQQwjrsbLaMyY5eipt3sGHuAFS25N
	nKxd68qE6Ks/EoRyGVYc157hUuUuDS0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=Ktvrwkev;
	spf=pass (imf17.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:Message-Id:
	Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:From:
	Reply-To:Content-ID:Content-Description:In-Reply-To:References;
	bh=fZg3NypWeiAG1rQXABIWnvJg9OYo51SVkdRpl65CL0Q=; b=KtvrwkevBROWxgvSfKbVN/HVHF
	HHdG7F3Xw8MqE6DaYYHSAX/YDpOs41cFFxVbOTC5i/OF+ElazpMENKh2MKtxKBC7AaoPltAcpwgkh
	r5EQgOPHJySyVucjOMAvPvvxH29y9JP1SiXk2N/kF05AWDV+OiEdBs/pGREkOG9NpY9UyQWpDrK5M
	AKCgINZN2N5FIVQyT9znukX5HDhhZSb8sjPX0GTK6L+J2DFXp6NzV7VvjrBz1CMYNPPEyPYf1O4At
	+KjYRIwCVP0WEtIetkqLQuSR3X7GG6s8qUZXgqHOE6DWRIeHp06byrzXR+FLizyzUehvKMNgitUkx
	QzK450VA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wpRnr-009J1m-1U;
	Thu, 30 Jul 2026 14:32:07 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 30 Jul 2026 07:31:21 -0700
Subject: [PATCH] mm: kmemleak: default min_unref_scans to 2 for verbose
 auto-scan
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260730-kmemleak_hardened-v1-1-b0b20033b4bb@debian.org>
X-B4-Tracking: v=1; b=H4sIADhga2oC/x3MWwqDMBQFwK1czreBJL5KtlJEQnOsF2taEpCCu
 PdCZwFzorIoK4KcKDy06jsjiGsEjzXmJ40mBIG3frBja822c38xbvMaS2JmMrzZvvPJud4vaAS
 fwkW///M+XdcPHz3+zWMAAAA=
X-Change-ID: 20260730-kmemleak_hardened-e80542d1152f
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-d5d98
X-Developer-Signature: v=1; a=openpgp-sha256; l=1857; i=leitao@debian.org;
 h=from:subject:message-id; bh=FW3n3g5Zu0GcH8kK/SWR8UrAqasXcVRriqWmyVc67DA=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqa2BkvyBm+2PEJ2bLV5TJXV8zIFzZXzM/u6znX
 XLCx8CO3O6JAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCamtgZAAKCRA1o5Of/Hh3
 bU1yEACRNPCJB0vxz4hwLeqDe1NvxTGIY9NviJK0ewQSIJw5aQuFAlB0UvhYQ6Mi135n7pblzHc
 +tR457Wqpq0qxbHBYfOACdHLgJ2xdIfWeJSivl9q9qBNSC6uqNL/DpDIE9t3zdb0HAkSjEZDyFl
 n8VK765+eBrQiOPE8OM8hLkvgRk92SAJlI1lu02XI1jkdXmkTmIw620Al9rju9lAUqPCEWB59Cx
 5a+iOT/33AYrdjfyXx/OKeTVovh+8CdnYsTiOGoM7WMZv1q6oPgKJ2TBbprluUhcKLO8eemWoq9
 H5KaG4yf3438gAHAgEk4OpK+7IzrI/9Wuq1qsGZvsYZAiC2l4WkY0ojF+Mg9rkgJLlC5gyfAVYe
 UDOoe+Yd7a0NV2bwNZNPpnC46er0MG831jZ95uSUhLu3VdxUm3Trt8Kj3g/8G7XYQyveL5hXd2r
 i6itnAz7eE0MvohmJhabXgA1qP6LoNJf3sodL15xRLqai8f59kViZJY/4bBZc1IQ/zTtCkDcB9d
 PgtxnkvVnWZDpkW4PUKFrbGR+I/TXLeFC5KnLIDlOU8FopJTEhsbaArIHNo/i9Rb9SyYIVzgwCE
 R98ykugEe1wEgldMuFX0MCFwTXv0swUCjtocS/bWqtiVpaKO520e8QRCAljSvvXrE+WkXo8ELoL
 A026UzgMj0cAE2g==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 97B1540018
X-Stat-Signature: 7whik3dhwgxziuqbqw6um7q1aes85u9e
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785421932-624615
X-HE-Meta: U2FsdGVkX198VjgdtXplITjqK5GirPEsrr7int1thFUVviXWlwyAloKeshvixjBbmuPnb2M427/MRozCWSudlrv6dLhB7PhxhQ8aV51XlkFqX6re9tUwhTln6c19HKFA5lalDnRHA8JnCbyx8+DyBpaWF+E/saFrfPgZUxkqR+3Ddv2z4CcNVkHG/giDxP5Mo+H2fdg/yrVSM8OGq4BM4ZnQND1Cja2UwdZm7KVEC00yuJ4+eoVTYU+RVyqk/zTzWUDR+jWVS73SUeJRWfpmeLz9foPPt9cIDlfwmyMSYpJvd2OwJsuj/MTA4PKdRIsMDSz07JGqRE5XlhnaA14LDLNVkXdinw2yO9hEnupVuflDsuGkOrZgtbMTPFeQdOuSJ+dpZr4nI7v0jDroiEnf9Nr+4c4NZtFriiWeSPZqeeJ2z5oEdZzQhxU1Ml9p9DE88Dyn9FEZ5wLymBqPd5ArafkU2JiScfeTEIZ6SDM9ixMjUU5ptbbaPmJ7P5yVetC7WD9KxL3MM9r2ODbCGQI7T16gVvrMGjEC25SK/RtKdt2SFFvmlIVoZiCio2Q3Go0y2KNqut+G91NvkspxGuj/kQWOATJDfw0RfL/WGA8vgDFCnwblljN4r9hONrwT0qht3M6/qopX/f/TSog/hveqDcJKRTsrPtAmHqTeqSzCI1jSs6domtf9R64fnDnqA9L0IZ1XpZWGsIF6UjViuOm8CPA4jzA1axlytUvY3Yj1HI3gmyAF1qHY/e44MoYnVxMgKWvATI+5JziHZka9GbY2nQLNBcxSuRMa06Nmkc3akFTezKMqJOrwrKV6+zvLDD1mF7how9MFFdR4v4Pf5yPv3X+GBm/SY3OINmmPBdXIP4GSG3OnnapSSQwDzbRBEAklO71UY93yaHSjAVvIC6HSsrc0fM/9c+3HTruVQHVHSh4xodzBNcPEGZj8HApflZLZNnl9bPicYmaVgjf3zky
 qMi6NKDM
 IOf305JM6VAoFKR3+tod4CLkVWJYe8HH5HiheKQFwlhg1A0+U5Rgb7qtbwWmFoiDdHuBKnXqhmxh9sdhF4UyCveJ3y4ww6hktpdkCdBfCaFZlo9B7SlaWbPP/Hr6unwzwOZy3poii8vhqA/xCnml1mHycxA7wJ6MHRUNaCLqLmwp7tCGCkXDJmPWycQPSx/HsMF8CWYiQHNCiTbIt07qJ0kafqluczXnSsydP+w1XtKikQTTtBXGngMgitGx67oj8aJWGn+xpPJVDgjtteiP2qu4PJBNOM49fgOMZM32RKaO9Pqz7oDo7A+zJxPjxOSL6FEXWrkD+a1jn80k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

min_unref_scans defers reporting an object as leaked until it has stayed
unreferenced for that many consecutive scans, filtering out objects that
are only transiently unreferenced during a scan.

It defaults to 1, which reports on the first unreferenced scan.

When CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN and CONFIG_DEBUG_KMEMLEAK_VERBOSE are
both enabled, the scan thread runs periodically and the user has opted into
detailed leak reporting, so a second confirming scan happens on its own.

Default min_unref_scans to 2 in that configuration to suppress transient
false positives.

Keep the default at 1 otherwise, where a manually triggered scan is
expected to report immediately. The value stays writable through the module
parameter.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/kmemleak.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index f63dfacee7ca1..6c31e66915ec7 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -237,7 +237,13 @@ static struct task_struct *scan_thread;
 /* used to avoid reporting of recently allocated objects */
 static unsigned long jiffies_min_age;
 /* consecutive scans an object must stay unreferenced before reporting */
-static unsigned int min_unref_scans = 1;
+#if IS_ENABLED(CONFIG_DEBUG_KMEMLEAK_VERBOSE) && \
+	IS_ENABLED(CONFIG_DEBUG_KMEMLEAK_AUTO_SCAN)
+#define MIN_UNREF_SCANS_DEFAULT	2
+#else
+#define MIN_UNREF_SCANS_DEFAULT	1
+#endif
+static unsigned int min_unref_scans = MIN_UNREF_SCANS_DEFAULT;
 module_param(min_unref_scans, uint, 0644);
 static unsigned long jiffies_last_scan;
 /* delay between automatic memory scannings */

---
base-commit: 78bc8af4affb9a732504eb22eeac7d1e50883853
change-id: 20260730-kmemleak_hardened-e80542d1152f

Best regards,
--  
Breno Leitao <leitao@debian.org>


