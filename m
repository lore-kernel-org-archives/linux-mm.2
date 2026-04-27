Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 291A0FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 15:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 67C186B0092; Mon, 27 Apr 2026 11:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 654636B0095; Mon, 27 Apr 2026 11:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 568E46B009B; Mon, 27 Apr 2026 11:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 454F86B0092
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:46:47 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5A3BA142CA9
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:39 +0000 (UTC)
X-FDA: 84704735598.19.A0B4EE0
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf16.hostedemail.com (Postfix) with ESMTP id 00DB718000F
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 15:35:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t+jp7mBh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3R4LvaQgKCGA8PB9+EGREMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3R4LvaQgKCGA8PB9+EGREMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ardb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777304137;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8F3kASMqf5BHYl2gzcA0DgWEOwzoo2uBq3thfdXqJMo=;
	b=wksnmhhzr8FgjArpiTQzJcw5WN5JlA1HJOoSnX+CfM/bn11TxrklCtXuzM0aZp4GlKl+Ip
	VoEnQKRRcLGvCNWUbnSBnuK8t2QI1aLEQcwQxw+mISaYlPURCPnKUnpXm7Ijnixa6fbxyK
	eEvQaSkszDnGNpZPPS0jRZpJIbzYiks=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777304137; a=rsa-sha256;
	cv=none;
	b=De55ZL9jV410NbVvCauABzPoECG+6xegKDDL7XzsO/wPTQ5WoszYyKlpSVQbZaBzmI+nWi
	cXr9AtNkTmy+Qa0D5RrBhGSgLW6RHy48OBJWmbXmljTAYIqtO75sQQeBrDglSmMtiZm1iN
	le+TrIOaBGoDueP5IX4GrNSV7uDmdMw=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t+jp7mBh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3R4LvaQgKCGA8PB9+EGREMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ardb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3R4LvaQgKCGA8PB9+EGREMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--ardb.bounces.google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-48a55ecc32cso58152185e9.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 08:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777304135; x=1777908935; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=8F3kASMqf5BHYl2gzcA0DgWEOwzoo2uBq3thfdXqJMo=;
        b=t+jp7mBhV3lKBF+Eo9iOr4iYoYSlC6fDV5Am2TDbpG+pNy6QGlaH2E9I8Tx7gKBrrt
         cofSE6gu1qE+eQbWbGootJyE9AUiVuo3VcHLPZHw2YwaUSQUo9SulbVkxtcL2YnonNAm
         5tbsHkR5Qmj1Nem3dQz+6e4Y95yGEyR5PqqLWT5p3ZzfhuxlAXq8w8wD6c6gimkiitMr
         vwxlD5tIqrrt4Xx6e6jfr5W7OG7IITn3QT+wLar2JuWFiILFyGHqE0t5xamGSOuSNb8V
         jF22Pa5Mjho1gRiXqWrsKF3M/F6WBkyETQmn8iVMRJDzmdg4f8XubJv2XezlD1XkVTvX
         6Jzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777304135; x=1777908935;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8F3kASMqf5BHYl2gzcA0DgWEOwzoo2uBq3thfdXqJMo=;
        b=eZDe+u+zHk3kdHvV/Zis63Tdwwbqa4/D7KP350Xv2LKK3JH2zfqWOY+VJROVvaiX+5
         rPbRygsZwVhbTaDS6KNsvJXdX5f6pEqs1H0VakL2gDqB19x5rhoifT2XKCBA+TEootr1
         GIpfmla+1xmu/xgVovxFCqwB44S8O+hcUK3a7FEfQL+Cl/JTeG6JRLlJzAqjOnX52nV9
         8EbG+30eCHvkVXg5sAf+Z9bBgoWEiATpO7XMb3jBVF5d5A03+hCrXYtNClKS+M25q7N/
         AAp4hHywBvBcNBftzg8o8VLGJfXgp0dRhqonDsVzJzqJAh0rnJmwvlW1qOVc/8YADRcZ
         VHFA==
X-Forwarded-Encrypted: i=1; AFNElJ9ZyCTHVj6zJRYgzw6q5yKji91jInvPhf/Xp/MApD7rbMfWGcwGY0nfPmZ39fD0SCq+c2B8ytIS9A==@kvack.org
X-Gm-Message-State: AOJu0Yzk19X0L6vm0xhL9M/R+WqQdstTzR8I+H0n2+oJknRuZBKcivgy
	tem3rQsSbtutEnx/KX9gG8Xr2KAolL/8Wexn0Ft8tuEFx/U1N5EGCiZ4vh3Vt980OJ0BL2wl3Q=
	=
X-Received: from wmbh12.prod.google.com ([2002:a05:600c:a10c:b0:489:1946:b592])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:1e28:b0:483:7903:c3b1
 with SMTP id 5b1f17b1804b1-488fb77fbf3mr626097515e9.20.1777304135240; Mon, 27
 Apr 2026 08:35:35 -0700 (PDT)
Date: Mon, 27 Apr 2026 17:34:18 +0200
In-Reply-To: <20260427153416.2103979-17-ardb+git@google.com>
Mime-Version: 1.0
References: <20260427153416.2103979-17-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=837; i=ardb@kernel.org;
 h=from:subject; bh=FjvXC4Bvv/morAQPM0ElYAlwegkzMza4j/YwiIL/yF4=;
 b=owGbwMvMwCVmkMcZplerG8N4Wi2JIfN94++NX3ll/ZiXVZap93TO00rsSY3MY/ndJRGotvX3m
 Y9v23Q6SlkYxLgYZMUUWQRm/3238/REqVrnWbIwc1iZQIYwcHEKwEQu/mX4xXRjUvDxfwUKzSeC
 Qp+sfOS5rfhfFteH21tOH9i1KfXn+g6G/9lLOeQeqzgJu68KXXDhuUvujolfrnt0PsxjVi7vjpH 14gcA
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260427153416.2103979-18-ardb+git@google.com>
Subject: [PATCH v4 01/15] arm64: mm: Map the linear alias of text/rodata as tagged
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, will@kernel.org, catalin.marinas@arm.com, 
	mark.rutland@arm.com, Ard Biesheuvel <ardb@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>, 
	Anshuman Khandual <anshuman.khandual@arm.com>, Liz Prucka <lizprucka@google.com>, 
	Seth Jenkins <sethjenkins@google.com>, Kees Cook <kees@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 00DB718000F
X-Stat-Signature: ji7th9zqwwc653npsuii6swd6tkn97xd
X-Rspam-User: 
X-HE-Tag: 1777304136-32243
X-HE-Meta: U2FsdGVkX19vzmqn5KYP5H9KalRGC7u+k0uP5h1333ao+cvqIg0B+uir9A0ilxPiruBY13SRkQ15DE2p9VAGzA5uqx0okOVBojAdkPph83tdGEFdu9X0gSD/RnGWwtwTP13TCRnpoaHhF65oB43tgzpTiPjHUlaEyPo2AN9CeXXxa3bcc2+my9bUTdRQXIJ4mrFOnGlJcsbMRYzh6QDqB3WslKoaQTiGsvmXOpd7viB8mlXwpmgYzD9i59Mhu2GORDV2BEhbTvpLHve8ibOZvfV6nCQk6tQdgRMt6pG5ZeZhnl6KpJWCP2pN+x3mjQlqNpMEAG8EaMZYvPfSCm5tBxbehjONG7ltGkOJZZOcj5GrJAUtM/2KygjS3HFk+qnISzLpOIbLROKb21gfJ7zS1afViGPkrD/hj/IMOCurDISdoHmCoHiaig12zeITRP7TphKoa68IbDNeXQEbmL5az8mVlQEpCNsxR0BZ+EOw1PyoAz5WxNpxOeY7fRcdE4v1lHKxr6jRjVpvnkCKUrNCMmgwy5i8emRLRwr2BCHoyMpOVFNm/Od7KwrfdWnsSZtu1Nhrzg8f2H+2cW0J90e7+1CmX9G9Z0tk2ia0nUPKs3pXJBiUhY99WQORlRUdI9M6Lg362m4E8Pq6iDBC5rgdOxfNigKrkQtKdsKhUhZtPHl0IrGuYrnYPhBXyK1R/+BTjl4+oPgj3vubk5umVvT9m8h1dja7CjTtEYOQOQWuQQ154vqNILXm4T+Q2Qy6Udm0w+4y4nK59sSQBW297R++YmDawTzsDV9MnQviSAfoyAPh0EHZX89s+naw6IUYEqU2LRfKydfVbq8dj7uH9trD7Fq5rB7fJRkBVbEcw/a28bEXb+GmD0AOQmpzxIwbELxNkngW0WwE+aZcuw3V4Y7wQOQjhqS5WHacQ5tMPT0OUlgJQ9ooWOONH1MC+8YuouuhfOhzVX9LRfAS8u9SvI1
 9zSC1Cs0
 KyD3ymTaOEEBLQlcolrGvpkl+mf15uioAzTDrbxH8JRhdQt9Orny44nLWCIkr0AroxRmvxfN9UHbU32+Eu2hpYrnZyfgp/9uD3G/saI6gJL7gncf5nIjfywo7Lxofh7EQTi/bmJ3wir6QTBDLXEIS8dS3NM9J4pJTTdyBUjYDxW/pTQnXgijahB3xuRneGWWI7B2t6xzOixjUd2B8tugKQ8iShddCD816vQmPlOjVOymP8+F62bZ4iWwh2tAnz24w5ZkhBe46bYxCd/pUP4KUSlziFGQkq1oSkaHxX68jiX6QLRsl3OioHSowOl0EvVJ+2lCfog1JjaEkCCLkMCIjtmVfwwsXtplTw2EEQbBY0emLbvg7HFekwQ5mmhdUEjwkd+tOM6Xeax7yKllFUw4a8Fw0hZKbmw3g4NSE8UDuiEvt3eKqBNqdfW9qIDsmnsckIYttWK5CW/uU6iD8X0nYB4Z/LENb8sp45QDodjcC9j9Ewjtgl8na+QiAbklFcO5Wx5dTTnPNEY6/nOsvAQq5/mm/Smi/uVgKgazMZeOYuTS+2FFdaBK/UE/20C/Q8bb6ZQZd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Before moving the empty_zero_page into the __ro_after_init section, make
sure it has the memory-tagged type. This is needed to ensure that
cpu_enable_mte() will be able to initialize the tags correctly.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index dd85e093ffdb..f084993024ab 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1049,7 +1049,7 @@ void __init mark_linear_text_alias_ro(void)
 	 */
 	update_mapping_prot(__pa_symbol(_text), (unsigned long)lm_alias(_text),
 			    (unsigned long)__init_begin - (unsigned long)_text,
-			    PAGE_KERNEL_RO);
+			    pgprot_tagged(PAGE_KERNEL_RO));
 }
 
 #ifdef CONFIG_KFENCE
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


