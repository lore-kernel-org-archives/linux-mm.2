Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAFD5CD4F3C
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 08:19:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CCDB6B009D; Wed, 20 May 2026 04:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A37F6B009F; Wed, 20 May 2026 04:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4925C6B00A0; Wed, 20 May 2026 04:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38FCB6B009D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 04:19:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 084738AF3C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:19:27 +0000 (UTC)
X-FDA: 84787098774.03.01E816D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3633C80009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 08:19:25 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dhrtBEWS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779265165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z/4rfPWQ5HkZJZbwpLmw5R+Mmu26rwOzXYpZdnVV9Dk=;
	b=mGDLmaEEw5uQkMO4Vp8uffP58uv8ckkc+K/tme+mTVGNDiT4ErMnB1yukrYPGB86IPjl78
	ENGL8zLmao9M2SlwUH6w2qI0qgklcGHdAtBAchizevS8xByPHmgJRkhJKtuPEetOYnKVUz
	gWWCHj6U4dJuLpR8QnqpX6F58qR3Dlo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779265165; a=rsa-sha256;
	cv=none;
	b=5TuxNAYrVeL193OCMKT8A3ZYo9WMdNA99OgOcvqzoZ7aMM5dkcAEoGpqHS5i0qVS9pWXfl
	E1gu8PzOIxn0+EloQgGJ64GWvg67P4Zny2qW3KnDDsqYo6JUdH24teEZT2V1zdjm2TiEyT
	dDhwJ+c01a1MN1bo1H4826Z4BL+aBmk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dhrtBEWS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 608214069A;
	Wed, 20 May 2026 08:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D39A1F00893;
	Wed, 20 May 2026 08:19:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779265164;
	bh=z/4rfPWQ5HkZJZbwpLmw5R+Mmu26rwOzXYpZdnVV9Dk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dhrtBEWShLy1GXu88WxKJts8sqyBs3VBaS/0WLRV9zaUqdWgXLHfayljVW97Fzzt4
	 7RtyF7wImuoFzhQU2h1L/9hdvim4iIBcz+tYzmJARLjMnGtyMGEVbK6TanLVgv5ezd
	 pl2W90AdTAhfQYtdHrNc/ZaD6QYOJsb+tmCa4s+FcbkkL1YVX+LulzmbDC0pnq4PMo
	 DOm/1SfLkw4tBV6zjcUB1mSnHQb6DFgEY8+1JAf3u3TUVlgsOTyhBBEs84dzpl+0hv
	 Io6iD2BfJBbqMYv94X1UXa0e+rWghxaGSLk/NiWOlAMkORwV4u37I9g6gA5eJAi3h2
	 jYSNBO2FU/hAg==
From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Date: Wed, 20 May 2026 11:18:57 +0300
Subject: [PATCH 3/3] apparmor: replace get_zeroed_page() with kzalloc()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-security-v1-3-831bd8e21dd0@kernel.org>
References: <20260520-security-v1-0-831bd8e21dd0@kernel.org>
In-Reply-To: <20260520-security-v1-0-831bd8e21dd0@kernel.org>
To: James Morris <jmorris@namei.org>, 
 John Johansen <john.johansen@canonical.com>, 
 Ondrej Mosnacek <omosnace@redhat.com>, Paul Moore <paul@paul-moore.com>, 
 "Serge E. Hallyn" <serge@hallyn.com>, 
 Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Mike Rapoport <rppt@kernel.org>, apparmor@lists.ubuntu.com, 
 selinux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-security-module@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1580; i=rppt@kernel.org;
 h=from:subject:message-id; bh=+ey+joQwrn1qEqiykmTx8dcM/5TMNFhXgYB3MVPrqgk=;
 b=owEBbQGS/pANAwAKATkDhibLDv2RAcsmYgBqDW58nz384TTzPZOUrhMG7PeyvhDRvKQD8RIHd
 PLEfs78XJeJATMEAAEKAB0WIQR45VhVpZkvn3TRr+k5A4Ymyw79kQUCag1ufAAKCRA5A4Ymyw79
 kTbyCACtJ9ZYDN3YybRMNR2UBnLXfQyIAs1SRXhO192EBvmpN0Vt1m1sNk+uZlH2OVV5dTRBzer
 ZUVu6/sROZL71OF1VFySzWa2xD3gLaKVlDyPHe7gMBIdFhQXjQSEkzNGbSjvJOMChXiBsUYfHoP
 8/amlGCtmTomdv0rSvCj0jqMgMKqzQRqkZNjEH90UwnQthW1EMjaZxKlluFPBguq2912ZX3N37M
 39ADj+W0iqAhCINM5YCk/d6G5x1kKmOGD0cVEdms7dn/8CLb7b/5BGRj4tIG1uoK+Yn+hh31hYu
 1+YvsR3KShRortBO77alQvQ9eR/1ZUROdSNcuV07i91Ita/k
X-Developer-Key: i=rppt@kernel.org; a=openpgp;
 fpr=B8E96E880C4A40C3C1255AA8C532392DE6DA7CE9
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3633C80009
X-Stat-Signature: hag1uqqwbopmgcww3qgc59rbxe143y1x
X-Rspam-User: 
X-HE-Tag: 1779265165-635639
X-HE-Meta: U2FsdGVkX181+y6ecdTP/bm9USUnRoCZgte+P/W/5Ih/2zA9VN7FiqDKyzdrcnEmF6ima7IfkvO2aTHMgGV9uF5SCTML+hRXvPdTIZBVGZ/iclg4wIgWoyhzQfD9+eIDkBGZ3Muz7/WAx26t+1dEg89i9GnpKPZQxXGey0Aj6VYtUB+dcYddFzxqTR2swB4NfuHScYospSROH4+3n9L2HEN5B7Oiz6CeOUcygd+flmqCrX3lZnivgYv0sIHkX8B1iMxZJ9efbZ8ekjIdh7Q9XVHbZMrdLlHePAJc1f417yOtQhUUMUm499u0ZHV+T5is8qtOcmykPlc3qUvaCQWw0wXrJ75WVrGMUqFneb94kls7sPFOcs3ReX2HZfAxsiaiLqwSI2AGh5DBmAuWXeB+Xn3ldGYsUZv0O6eQBGX1Aly3VDEBYoiBJUQ2G7MUsD/Qh8UwCMDRE84lTeHDdYWMNfVuSv7tOs2/BnskKhM9OFEBKpRCpLe3rc7WTY+I1bVSAaptfT/j36A/SAmbEZIj42QFatr46P5iYukGJdkcj1DQhIACIr+7yVr/JyeEyXp/fKrH9zW8UM62OlKgDGdSumxf7//k86yTPrSjUXeqjsOLI0G4ogCbp4s7lcqgxM9zqD/U+LrsF0Hjl0YKkSFrttguojaieW4oNMIZB4e5bzxXbRbdyCvVj0c2JKlt4i1hVFenRN1ykzygV/Cql514Rcche3E6yKKg3zHx73h7KYJsvRKAjfLaX+Ual0bAWvv0dCsenW94Numcv6EI6/yyFMoHPogYGSDTlATu18pFU77RdFLQM0X5b7iORXRQvA17B9Cvj7GjdGjsKzKTAK5/UQ8PYsFfMi1IDHOeaFFHH/jOmApikrjwabGYmJyaBQRerVLqZYn0lpw+5N3whi8RKrG/CsaigWsJTsabr4wL7D1UTCKFBJEQMwjxg74BBh1zpGZjlZqrAPUJYomtEn1
 6GiDGlPw
 +50rWgJJA7V1wBYgkP3bdu8gVKEW6aatmZseH2olIz7vGK+nyZAze2CQozugRtgVOFdnhqyYks2WVjBbv+s7qw5DzhZTJuJcj5KxTTGeg2vP4mJ7eNu2YQU1aLW4CZvxa1xVEguoLz3QYNA8g8kdUK66CClN0YYdjrPqJFYHZVeeRnJMoSa0ZjazkngbSDgAU53LBF8+YlTub8vEY8H2cD57weR80zRGeg4bdCtZ8zTF5o6hZwTz1Q07JNI5HFj8dEYPZ9b6ufKQYsG6wDPraPqxVFGTaMuZC0BfKrDjunRKLtuqO8bc5yB6EyGzOHQztlFCgbYYunQObuWGG1YkU3F1V6z3rnPzxVU95lOfPSNNO5DdqSFFd9yc6t5VEVw/ikNc4UlPrqCbY+E0lhOFdCkUwUpThYoATSunA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

multi_transaction_new() allocates memory with get_zeroed_page() and uses
it as struct multi_transaction.

The usage of that structure does not require struct page access and it is
better to allocate multi_transaction objects with kzalloc() that provides
better scalability and more debugging possibilities.

Replace use of get_zeroed_page() with kzalloc().

Link: https://lore.kernel.org/all/635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com
Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 security/apparmor/apparmorfs.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/security/apparmor/apparmorfs.c b/security/apparmor/apparmorfs.c
index ededaf46f3ca..e5c99c71e7ca 100644
--- a/security/apparmor/apparmorfs.c
+++ b/security/apparmor/apparmorfs.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/ctype.h>
+#include <linux/slab.h>
 #include <linux/security.h>
 #include <linux/vmalloc.h>
 #include <linux/init.h>
@@ -904,7 +905,7 @@ static void multi_transaction_kref(struct kref *kref)
 	struct multi_transaction *t;
 
 	t = container_of(kref, struct multi_transaction, count);
-	free_page((unsigned long) t);
+	kfree(t);
 }
 
 static struct multi_transaction *
@@ -947,7 +948,7 @@ static struct multi_transaction *multi_transaction_new(struct file *file,
 	if (size > MULTI_TRANSACTION_LIMIT - 1)
 		return ERR_PTR(-EFBIG);
 
-	t = (struct multi_transaction *)get_zeroed_page(GFP_KERNEL);
+	t = kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!t)
 		return ERR_PTR(-ENOMEM);
 	kref_init(&t->count);

-- 
2.53.0


