Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EF1FC87FDA
	for <linux-mm@archiver.kernel.org>; Fri,  8 Aug 2025 20:18:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39FB36B0096; Fri,  8 Aug 2025 16:18:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3289C6B009A; Fri,  8 Aug 2025 16:18:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17C166B009B; Fri,  8 Aug 2025 16:18:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F14FD6B0096
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 16:18:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A4F88804AD
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 20:18:13 +0000 (UTC)
X-FDA: 83754702066.01.B072E31
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id D2445160006
	for <linux-mm@kvack.org>; Fri,  8 Aug 2025 20:18:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Dbtuyt6G;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754684291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v/EURho8HdzYkRlNQqj4Jp25lWoftNvoIKLrAmtRbxc=;
	b=dcmwJ20mw8M4wbbh0QlzlP1qZl+fdTW3MxK4mHUqh6tmVoPaeZrQkRMYWeCR5TAfv0qSqy
	9eGm2+RVwz9D+2pCo20REFwUJzDC+eHnZlCl1jNw0tJFg3DbCe+0JQ0Az1/UraqZt3jm/A
	gFtvo/Pp2U4/NUbxyOCeHWmw9//Ucb4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754684291; a=rsa-sha256;
	cv=none;
	b=g8zdbDKiV+BLAdk+yJTZUaWceiPdiGygUywb46Asq1hOVIbDbuCltr7ky08c/2ez/0yG60
	25U+Yny6P175zEKWi+jend3RVy6/fDMdJTq7zLqL6URkNXH82Nq/yd2wHBj2tKZ/oLDI5h
	vK+iaqMFynXFC2cAIheUiz11tBJBjfg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Dbtuyt6G;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4aeb2e06b82so13918611cf.2
        for <linux-mm@kvack.org>; Fri, 08 Aug 2025 13:18:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1754684291; x=1755289091; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=v/EURho8HdzYkRlNQqj4Jp25lWoftNvoIKLrAmtRbxc=;
        b=Dbtuyt6GKDTlSkJdwGndukvqbLU/4fqQwPpU8eKDRsNUkOlDxm/SU7IIEe2fpcuS8+
         +23ZiVzKh/rhmA/R7u4KC563XotaFvybX4RghbzQgJnyzesxjdr6hTo4ad9y30hRTLx2
         UXYzc3Ks4nPfL7vNeELxyBegftXKAfkYoIpmbrgHQmLehQ7w9LUQrjebIP9S4Jzh4iXy
         Sd4Hb/hR5ef8tY4bfiL29rbQEzpbAPslzpbgs7lNpm2jABIhQggXdWCcNcoLH+SjieZo
         9gma/xAr0T1E49IxCjaDEQ2cLxmfxlUWvWLN+NwP8cSiZWH46I+PYQCKiyt6JHp2RZqE
         ocFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754684291; x=1755289091;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v/EURho8HdzYkRlNQqj4Jp25lWoftNvoIKLrAmtRbxc=;
        b=iJYzt78M6rFexYK2c2hx6f7Rp0Jj2mjdopyVx8+3SwlRdlCN5/To0tJzwSi5AQx12p
         jk4z+S6ayyoLkGFYePe/XxlkWqlVPpYaOoN6sSjy2aZ3OMlKtjQQ42TxU7C21Re2O6L6
         fqbCxdEL9Q93c8sJ9f6IZ98gDaeHNHvtjtFX4Funfsk8oXhy4vGoeWHArDp7r6tDoYm5
         632vfjcrGYZxzsXL0ySFQ++kgdKiV3iEe9ba2vHMi1KDPeWXhejQekOjbRD2vKQY1bVv
         jJRhPp6pF2XVB9bko/xlm9sjS2N5CHz/ahkgz4+T8q0jUHLledi4TsOO7xfFQgs7zeQU
         uyvg==
X-Forwarded-Encrypted: i=1; AJvYcCWlAYx1wMfbg6BP2IXONS5s3uXUjZWNO2cFl/V23SaDt47yoWS2pI7HDkkqsactacmR/f1UDk+9sg==@kvack.org
X-Gm-Message-State: AOJu0YzI5II6MXSeqFMeEDk+uc4ROl51xZuVRf1258KR5CbgwWIUaVZ/
	xqIlJ6WHesgbOQ9/dAAjMfVdUdUwQYNt75XqQcxzUWTJrSvPV+oWrWWS9futtnKGIr8=
X-Gm-Gg: ASbGncum27c4UEG3J7VYlA4pKTLdhhFRNx1cODxa08fvWEOYk0JWhZjw8OdATVA+l5J
	2U6s1JvaxHRjgfIxdvEFmt78/ojNxuka7cpYKHeqB6F9tu280UcxKJ6FDALQZ2K5y5vAPlpJo7v
	rev6pLOe3EYgthBSituRg+zr4TmleR0M2/arhO/wtf1Pp4PO3Yo/Nr35co2X/c23HCf77YV+gLn
	tfl/Y78/3FJr1PPUX/mqsC5LJPFiPzOxPElbkFoy4j08tmcfl/EJipG/edzLyPiKMbpbym+l5/p
	e2eCjIiDSm+B7+48ZThaoT/zBpZjmZkTYVgLhWHaECwykqxvNOo3ECdC8C0KoiHvHMBT8QRhPxN
	+XtBxOpjtRYwxGAeGHE17fGY8ja6mzKNrlU8LWUXhyeLlH9lg5hm1GAgfO3O49PZzRymWy1CF6w
	xYUfSXy4jh66kX
X-Google-Smtp-Source: AGHT+IGRsYIjYMDPHPWyETlwLlG2Zy30jh5DmGcJISmzXiHxweHbcXx7yy5GDLFSE/EbxlmscbGNTQ==
X-Received: by 2002:ac8:5701:0:b0:4b0:695d:9ad0 with SMTP id d75a77b69052e-4b0aed0ba35mr50986991cf.3.1754684290662;
        Fri, 08 Aug 2025 13:18:10 -0700 (PDT)
Received: from soleen.c.googlers.com.com (235.247.85.34.bc.googleusercontent.com. [34.85.247.235])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b07c80ddbbsm59490131cf.57.2025.08.08.13.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 13:18:09 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	changyuanl@google.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v3 2/3] kho: mm: Don't allow deferred struct page with KHO
Date: Fri,  8 Aug 2025 20:18:03 +0000
Message-ID: <20250808201804.772010-3-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.50.1.703.g449372360f-goog
In-Reply-To: <20250808201804.772010-1-pasha.tatashin@soleen.com>
References: <20250808201804.772010-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D2445160006
X-Stat-Signature: 91yocndhqn97dexx6jk45mjcm5o9ceqd
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754684291-156628
X-HE-Meta: U2FsdGVkX1+/0HP4qoOUpP+Dr0E6k/TWR2SvgP/p2hjxAekBB2iU5fzMplwmUgrvGLrbGQteJfPSzB/KQ3XZrkHiYMB9TEL9NBfOgzoPBr0Ace19TsNx6GoHfwYSyhP76zbTWtCuofIZdvYBkqz3Sle0HzktYZffg9N/2cbRaujPx3RnfbdINV7Wd73FHvdhfjguYeQOE+sZvTeGGsmTpWUoHULAhvlHEdg5eyOxB9ihpDbd8BgFZb3871xoHtHsFrYChcaoAYGB2okLD9tnC8ukxRlNL6kb6t3vk/87I4sy2az3E4icIMsmcF4EeR2fAF9P1HEp8tX2VD2h3emV6BOTrAszjPjEFRnN3CGma8isYovy6O6YCAQO+u1QjC5GEt93X+izuvdd26xTZcYd1VZc684lppEBEF0PntayZ7pGOOp5yexnIVf28sx+NJKDTpQitG9YjGiO7lvh1u66eTBHLfbz4+vmKyMYv04xI0wsK+1OOHmuunG9/lawq+HP33eNMAgdvHByJK+4JeHq0QNfzXzBqQuPe+yN4rgZZB97TX65QUfiZxTV6ApFPTmSK1lcNiUbUSJ9IPTIFFkg65zL0iBkKs+kUw7Wjm/ZvcJKb3bqgMKv2Phf7J4fgHZWomqv53fdq28SXJMAWvEoigvDFUAwUeadC1xDmOHtv2pnuepalLGqP28wPDBBVfSvcKuD6fJpSCc8HN2OSIemRwYl7NbYa9W+B8662EYoPrbdB0s12cKdFfN3Aan349hgrThBnGNMlK3E/Fo+A1GEG9haoyrjC/QVvKJculfZPzm8u2MItD/kuhPI5j7RaaqwPLRYScCjA0YMSicJ/7KuwLZLSnFfXsoUWbzrdjiA7cDcqhq2dtVYrrEmoBtcmX/UXnNQCl9SS8vGmj1vxo1ji2Ax1m7UMH27j+YaTxsrWscq6RUKFxA7rQi1wNCfsh4KUVs7D8CzPJ8dVUUp/b+
 +QzVKs6j
 pymeCwx3RQ5yDYvEIk6JuUasJeB9REh4uM9fdqCWkAMqXxiSI/jPnWFeObRjb6uP6BBhHrbSNntRodpXj+PL3gcqIj/B/m22ObP8zRW1VYjrXMpOeNDVE1SGFm2Z/TCpUYY13swNAcC6HIy5dkNXb8dy5l7/zDLesW9xtYumg8GW6JGdq3gkE+3t0Dpj4GgHZRlbAEWhlogMIUUL6ipRS1VTNZFQQ19SjpsGb9jflOqvuPyiYEPft4/N992M+YRYEFM7ZsaDzhnWlxqFMKIztdokNfUllAiNKHS/xu9LWX43cK5X3ZnEfRvv4kA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

KHO uses struct pages for the preserved memory early in boot, however,
with deferred struct page initialization, only a small portion of
memory has properly initialized struct pages.

This problem was detected where vmemmap is poisoned, and illegal flag
combinations are detected.

Don't allow them to be enabled together, and later we will have to
teach KHO to work properly with deferred struct page init kernel
feature.

Fixes: 990a950fe8fd ("kexec: add config option for KHO")
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Pratyush Yadav <pratyush@kernel.org>
Cc: stable@vger.kernel.org
---
 kernel/Kconfig.kexec | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/Kconfig.kexec b/kernel/Kconfig.kexec
index 2ee603a98813..1224dd937df0 100644
--- a/kernel/Kconfig.kexec
+++ b/kernel/Kconfig.kexec
@@ -97,6 +97,7 @@ config KEXEC_JUMP
 config KEXEC_HANDOVER
 	bool "kexec handover"
 	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
+	depends on !DEFERRED_STRUCT_PAGE_INIT
 	select MEMBLOCK_KHO_SCRATCH
 	select KEXEC_FILE
 	select DEBUG_FS
-- 
2.50.1.703.g449372360f-goog


