Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77C63C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 09:54:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55DBF6B00B2; Tue, 30 Jun 2026 05:54:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 532A36B00B3; Tue, 30 Jun 2026 05:54:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423D36B00B4; Tue, 30 Jun 2026 05:54:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1196B6B00B2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 05:54:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8D49D8B7A1
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:54:18 +0000 (UTC)
X-FDA: 84936118596.11.44EF89E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id F229EC0002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:54:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OLjspud0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782813257;
	b=PcQJgcc9+B2Dv7fVs8SMKdIIvD44feyhIpcKcnUjRPfCQ5oz0olzDf/BnlG6UZPazjbtAh
	6CAu2LEzGAQvaLXFxCv35/fxDFqvJ6yxXFKrElPkMiItJyoAFIStujiG12huNF6IEq+bIM
	WyoA4lTFv8ExF1rHK42t+so80IxpLyM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782813257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tDWSzv7RoppnHctFbrBaIWKAcSqdkcgi5jg8Rh3cBZs=;
	b=jC5pReUMopX6X3SBbub00kWCHh7dCwAOuIWiArEayl97/dzyEwqlyf8NrXX9ODbl+XHkGz
	8haQFE12myMHIoUHZVVJjbmYBSTNk2qDM66NuAOcGjaDjkm37Msj7/cqvN/ctTp0Xoc0Tn
	1gXKgK+sl1VS1VvbVOhGfS4/TsjouI4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OLjspud0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9CD4D60120;
	Tue, 30 Jun 2026 09:54:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C1C1F00A3D;
	Tue, 30 Jun 2026 09:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782813256;
	bh=tDWSzv7RoppnHctFbrBaIWKAcSqdkcgi5jg8Rh3cBZs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OLjspud05wH0xID7dRcY2NJIexfe6TCXUemwCduf0Vy+chqbhhkQ7gG5dlaYQ4m/r
	 CJUzqy6WasN6z5iJtw309PfeNiRRUvHRUMBhMHxvEP62IBmOZiPPCqTZoQzUEPO/SF
	 oUKFCy3ELtWxDIGprpwimD/EzPjo2vPNtBamztO6REHLxmEPsSdPjQILpTaP5gXYcd
	 MBPr1QKkNyT1g/4Tp+uuhn0fFhS/7vN8d9ThdyDgJ5276E+uMUz0xQI28mRqdh7qMl
	 fYfNlN4nNdbwpeYAozuuj0WcdM9zxjHtgrM7AbhIQXMJAwsEtCkLoHjKk5IgtmOPFX
	 fnySvfhrirZgg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Tue, 30 Jun 2026 12:54:06 +0300
Subject: [PATCH v3 4/4] vc_screen: replace __get_free_pages() with
 kmalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260630-b4-tty-v3-4-a8476c66c582@kernel.org>
References: <20260630-b4-tty-v3-0-a8476c66c582@kernel.org>
In-Reply-To: <20260630-b4-tty-v3-0-a8476c66c582@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Jiri Slaby <jirislaby@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, linux-serial@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F229EC0002
X-Rspam-User: 
X-Stat-Signature: mgare75s69cphyfig56paaim8oih75yc
X-HE-Tag: 1782813256-30378
X-HE-Meta: U2FsdGVkX1+F9UhJrlbXzPq5UQN+6Xckkk9zrfTRbusw/Y/+Uk51uy8fL9WR+tgJRTOf8ZPHq8qvaMHQeSu6K7SCy73v1jmipDkgvwUcvmspLvOZGQsXX5ZN+HFVDi2iRwpheo7PgICqItjw0ouOreiq0T+TUhcLmK1JCKMXA07C+JQcIDd0n7ryWvrHjMoMxeepAu2lUvFeVCLPEg938u9BOzAQVL7VXAngNxVTICz0T4gRUQEJuV6bp47RPM7cOUSI0s2cqztgRMWj/yoG6iQsjGt3uRraDvk7k6IhIwDDNUGwPn16rDfaFBFXB6mFNWERbcXBbR1mj2qXce/LUM7j8XgKchVvUsGdKudasNXVa0+q+2uiaiMl8CDunkVrht9CMBRSPneSpxdrExlx/MmZT17MuwwdcounbuZmkLu3225YmfcrPI8FDnMK9+VfN1LJ1rNKXzl0tUiBcBMbBHykmPL+bZlz60+dzdN3Fu5GS0KDiko5Ztk8K91IOECMMM+ngUn+c8TtgA2a2wm7QLuDI/r92aFka94Xj6RZo8NR7Qft3LjAcz6D4p5RUs1ALSNpNBvoNN2VuPm2pknvK6SvFw51RmBlML5dD5KR+KVd712WDsTaS/9A5hpmsc1Pf4lHWnYzIHg83AE/6M5oF95TDQhHfA0/sgnqK8+TaeBZOuflvC0QpAaS7gS71lyr1wOKk1M5+uJRkMLh1KWnsa3+O9hkaTFhkv+LrijU8hvve1SczKfNdp3FbS9ZFA3vjhbMFqszXnVT9mNxo2JD32CvGXBZtQIb0esdyUpvlqvVtwkJHy0tA+jnMWZnRS80QrScB030/X2t8X117HI757EWmHLkFJcbQ/KPQvIZIITrLtEozUbuJUnbMb9NaxKxoT3G1AVsFFMm4NOosggyaYOVy4ppocz4Eyge6bkxbSRSwOwuLJaeLlYtY+KiY4h1OxGm7AHAVRkmAeIc+Zl
 Bi05vp+b
 DNn6AE08j1kQi82IpinGOdjoPnyN5NKxi9X5OF4zrWU4JDepR9rDINTlfK4kf3GJN/FSJJmWDnTMULUF9ilyWoxNrv/OD/N0UID4it808UkorkOFjdTODoC9HXHC5GP8gW5A6+mmHEHhFt0WOXhoId0rLpEiUIhAmkutI+Zy/TreK1+mT1OzXOF8mXIYTQFtuYG1p+iCShG8+pAMbQ2XlWCnH/44UK8yR2JyWBkSBoMiayYEXF3ee4fTvs+f4iD8dlYY5OSCrvfjwLFpRzVYAZSBF87mRK+zFqPk5REpGWZacu0Bc+NCK7/AjWA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

vcs_read() and vcs_write() allocate staging buffers with
__get_free_pages().

These buffers can be allocated with kmalloc() as there's nothing special
about them to go directly to the page allocator.

kmalloc() provides a better API that does not require ugly casts and it's a
modern way of saying "I need a page-sized buffer"

Replace use of __get_free_page() with kmalloc() and drop unused now
DEFINE_FREE(free_page_ptr ...)

Link: https://lore.kernel.org/all/700c5a5f-3128-4671-99aa-827ca73f5cdf@kernel.org
Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Reviewed-by: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 drivers/tty/vt/vc_screen.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/vt/vc_screen.c b/drivers/tty/vt/vc_screen.c
index 7d40eacc21b3..bf1502fd5bd4 100644
--- a/drivers/tty/vt/vc_screen.c
+++ b/drivers/tty/vt/vc_screen.c
@@ -53,8 +53,6 @@
 #define HEADER_SIZE	4u
 #define CON_BUF_SIZE (IS_ENABLED(CONFIG_BASE_SMALL) ? 256 : PAGE_SIZE)
 
-DEFINE_FREE(free_page_ptr, void *, if (_T) free_page((unsigned long)_T));
-
 /*
  * Our minor space:
  *
@@ -371,7 +369,7 @@ vcs_read(struct file *file, char __user *buf, size_t count, loff_t *ppos)
 	loff_t pos;
 	bool viewed, attr, uni_mode;
 
-	char *con_buf __free(free_page_ptr) = (char *)__get_free_page(GFP_KERNEL);
+	char *con_buf __free(kfree) = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!con_buf)
 		return -ENOMEM;
 
@@ -596,7 +594,7 @@ vcs_write(struct file *file, const char __user *buf, size_t count, loff_t *ppos)
 	if (use_unicode(inode))
 		return -EOPNOTSUPP;
 
-	char *con_buf __free(free_page_ptr) = (char *)__get_free_page(GFP_KERNEL);
+	char *con_buf __free(kfree) = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!con_buf)
 		return -ENOMEM;
 

-- 
2.53.0


