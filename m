Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A094CAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:58:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E50748E0030; Wed,  8 Oct 2025 21:58:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8C508E0002; Wed,  8 Oct 2025 21:58:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2D3A8E0030; Wed,  8 Oct 2025 21:58:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB6038E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:58:47 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6F8E316054C
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:47 +0000 (UTC)
X-FDA: 83976917094.25.3EBA955
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8F897180005
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=gSt86yVR;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf24.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975125; a=rsa-sha256;
	cv=none;
	b=x4xAhXYmeAeBZ4r7SkZzdGcG0LucRZ8KxAV9TZohI6aCh/vZMknsCnzjVPT83oQ7Tj+3TC
	Vy8i3y7tMzG3bPjyw7s5eZDDnFL69DvfUFlL+Uj/TlHahd8kET3CxGbezBX5VbBG/so3my
	zhX/uYkds0drcWJQjV1GbiXybmDmSrs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=gSt86yVR;
	dmarc=pass (policy=reject) header.from=sifive.com;
	spf=pass (imf24.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.215.172 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MuPyEQssKNBDDveegAkkBylsREkSVusKsPA4YXKPGPk=;
	b=IG+jD3HKC1jErbIbMFuNjVGLIgIYPWGyhH0kYtWUixrZV6dqzXogpUpICfG8qofsqTvB0X
	c3I6gYWc7C/u3S3zFAhfYVz82XOatMRygpeQ0OkjtNkx3FwvfnAybp4WhpIwMACZCtwGyq
	ljbgnbWM3C5QaugD3szfOhGd1i8e+1I=
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b62fcddfa21so267416a12.1
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 18:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1759975124; x=1760579924; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MuPyEQssKNBDDveegAkkBylsREkSVusKsPA4YXKPGPk=;
        b=gSt86yVRkeDZuLEtAnqUdjMmhBNFPVgwFMnGVz8n2LDkK2OE5+W1FpWP3P3xXhXFPU
         +2btRQofH7XKUDw03WYLT3bIcaQP0xprh97c7gbGPcarRL2qvTYotNh+VotpWHDhy5vC
         kmVEZmVVV9OsW57Ya3aaIrxoNNTiod8HcLcCCcydAw3yoV7R+8C1eYCE1hiliyJMqtdz
         YT8OPH0LGxe8usJRRZurYb/LiCd+M57f7SspSD2AXQLzRtVIf37TVe+99nhwi/9eZSiw
         0qxNWIGgdSrvoQq3gCb7A0vZuGAH5fDvEcmff48jGXfmSQdj7Pq3SUx9HkmG7zNnToUL
         eznw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975124; x=1760579924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MuPyEQssKNBDDveegAkkBylsREkSVusKsPA4YXKPGPk=;
        b=R3MKHHTR1ieeq5pLy54VWWOLp4kSgCzHbksll/J3JErtlZx9W8ghC68L4LGcpw4LvI
         zkvYF/T3CKXBbYgqeWfuPh5hGOd7PvYmWrU3MW/RjvznJSN2I5G9/5dLLOFHgMncr1GF
         frlviZmwIkFLIx0CPHjIHWMOgI2RNV7WR652MorrotG6x36p91R8L4s6GWyluJsioB9J
         SKkcxPDB+tSZjKA50g1gX3nWPlZuJPv1I5AbNMNgxxKbKM0vTO4EKwIZyJ9Ti4Tw3R5d
         6vIAux6Y3DgdtB3qQTivLHQPxWO+4xxILVY5fwrrl/GzX5ZFmogTnRZ8PNOhWO/dGrnP
         pyyA==
X-Forwarded-Encrypted: i=1; AJvYcCW08LzeyKmqo6Hf+Uz/MndImusCOSlp9Gzx3Nw0tnHjwZZnnrQH64VFO6u9a8J9PeyeMuiqTTAdfg==@kvack.org
X-Gm-Message-State: AOJu0Yy/eZ4uMavgL2gfFuQPZZlY9n+AZhaUkVQDePDwaaAr403KEAOJ
	7p1pSFMrYAItohRhkY0w9uhbbyLZbzRyGpSjT9Pch8V7j/U6zeJjEX8cLSbTMdwEsfs=
X-Gm-Gg: ASbGnctHRpFdXJaqLGFIwhaGnAufqKmnOi46sDoSTmUvao5oJmCvOc40RqSLiiJuBnY
	6D+3Ngr9Ytgo1+bIekA7hNabbCMPBFCECKbB79l+8KUkzbmStc9BVPDTaVk9g++FXe2Wh10SGXS
	VOGq8hLwG6D5Ia8G7xV1Dx7/IGIlgM95ya64uf33FevFtPlacn04ChzFJMcomcKCyVlhjVKIkEB
	9Mp2EtLJMzQc2XqPPCAXeHOFSRLQgfCQAVrQRcePtWN6sN8wqRxAJX1o8U6GxXo7SeQouHii6VJ
	iicC9VvAGoX04NtERGNZkuEt4FuSF1CpNdYYCxnNm8IbbyS/S4dvZXfHw8YaD77KUM1GdnkT8PY
	R/bLIEhBf5+4U9qG4wyINuNESzvjnh/y23gwDaM4wy6fysZp/X/usTX1rygw399ZmHm0y
X-Google-Smtp-Source: AGHT+IGRcheU2fSpI6wPrIrcXh76/ZT2qeR3VE5CvtyhdddJOl/Ib5LW5D+YkzJh3O0sYVd9k5LTng==
X-Received: by 2002:a17:903:4b2f:b0:24c:cc32:788b with SMTP id d9443c01a7336-29027216103mr72693895ad.3.1759975124530;
        Wed, 08 Oct 2025 18:58:44 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de53f9sm11033585ad.14.2025.10.08.18.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 18:58:44 -0700 (PDT)
From: Samuel Holland <samuel.holland@sifive.com>
To: Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	linux-riscv@lists.infradead.org
Cc: devicetree@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Conor Dooley <conor@kernel.org>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Emil Renner Berthing <kernel@esmil.dk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Samuel Holland <samuel.holland@sifive.com>
Subject: [PATCH v2 03/18] mm: Move the fallback definitions of pXXp_get()
Date: Wed,  8 Oct 2025 18:57:39 -0700
Message-ID: <20251009015839.3460231-4-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251009015839.3460231-1-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zy48wy4cee8xukqzyp61nhwekb4yxg4a
X-Rspamd-Queue-Id: 8F897180005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1759975125-944413
X-HE-Meta: U2FsdGVkX19X7pgw3fhOBhMbvlhpCdRiKXrlUmpEHG0bvvkn0Deg+JEylWx88C8t6AMRL66ExckBb+rLCAHS7an36pzMYxOSR5oVGUBIAvDXqhtMQ1lEkMBvgM1UO5LxGuAu+WimAVpDM1hKmspcUsFufODCsOyO3I5ND0W9bFulxlq3jPWmSl2SsXRGNUbzkepNjQ2gzOZQNCe21QYIxrRRTkCvDMWMhhLE4EGQpX+viLTxTShiiyT0i3LTir5iyBr/t/42c9HF/vp5nQSRKQWzLbIhR77C7TXMghESWVpvqnRjXTYUvDBTounOIyPmQNz6roPG91eufG7lGlT+7vD6vV0i5eVyfaPotlKRdeTPJWFQQ3jyVQfTFDcApMgjOdSy/uwtPf0EJVSOicoxja2gMDdUi/FbMLRemJOyji3U9DkN7SwDhcN/2TqFN8aJj2w1faonkRdeC0j+s0WnP0SVm34GEV7PZNPVjiccyKiBW8vz9cVXxlVEhJPSmp1NohR5B6VwUq+N1cytVzzn6AyIjg3QA5UxfJYXQlp6HeMPLRSMP9Y7pi3IfdGIoU/GZoGuh62Uvm53L149MVfbOJn9k8CdrDVpjbW/5Nj7785LCr3mbUxym8yLvdEqQjwj0JnK1CHT3JtvJ36AsAoU5GnCv+tZRrsolLRR3kuuH83TySlDFkZcmWYcSdy9SWg23iVOYAKhDAdUXs0uCXAikSz9Xmfi88OIVpAckEusvhICaqRv82KqzbOOHGpUJxd4hPheF5Aw5pgnSi/CPYweSVUEhik3VxjCFXg6v3z3LvYTxXnfky/+YYW5Wg9iXV3IsEWxqmg+gJ0e0OiKFkpd5WggpK1hJb00+/25wq7cV8OXA0gX2ti16B1DBnPI0jcQozLPZSACQyWJgOhU5dZrhDMIFWjLS4BSa7YxtwRzknegVcV2Zb5ZvcYYzAvacPSXaOrr6NffUX6AKEi/cDm
 sxkXWd43
 /3BBQ6DehaPDJi6+AcoSyEJyErpqDtgHWt3MM6GL69nZC87RanIr7QWJOqMhjatrPIuIXPDWESSH1BntbS2jTtwmUZC0S1/qZJnfSc/JWe5m3ldrjqSuXWRKcR+5vmn+Li657JLtDYmaFlopLwMQdaQPpG9jVNENSrIqmgvrbjU3nPYywOKXELQsqeNUbQZ/qYPE67Wn8W6NXoD5exuii01fijCV/zfOLTq5lbFj+kCZo9qe8HBOAEwc7lUd5pvBQMtUw7DHjrs7vzcPUukrlGty9dOsVAZgfzeM55grvFFXZ0BPU2H5dMgy1xUvgsDJrpuMxxzO/OXCqfdPyvSFLWvdAoYl4GgLgIZOcWdhkfTmDOs4NDQsCgMoND65turEmhLsnyt/r22+eFyNL43fmEpbVJNHWqxibJEeHqOaL5QJeEnWvddArHt0joAUxjTLpOY00A+urViv7RmpCnm0vybzTYLm73CdY7OgnQj2kYVBs6hA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some platforms need to fix up the values when reading or writing page
tables. Because of this, the accessors must always be used; it is not
valid to simply dereference a pXX_t pointer.

Move these definitions up by a few lines, so they will be in scope
everywhere that currently dereferences a pXX_t pointer.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

Changes in v2:
 - New patch for v2

 include/linux/pgtable.h | 70 ++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 35 deletions(-)

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 25a7257052ff9..50286763b652f 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -90,6 +90,41 @@ static inline unsigned long pud_index(unsigned long address)
 #define pgd_index(a)  (((a) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
 #endif
 
+#ifndef ptep_get
+static inline pte_t ptep_get(pte_t *ptep)
+{
+	return READ_ONCE(*ptep);
+}
+#endif
+
+#ifndef pmdp_get
+static inline pmd_t pmdp_get(pmd_t *pmdp)
+{
+	return READ_ONCE(*pmdp);
+}
+#endif
+
+#ifndef pudp_get
+static inline pud_t pudp_get(pud_t *pudp)
+{
+	return READ_ONCE(*pudp);
+}
+#endif
+
+#ifndef p4dp_get
+static inline p4d_t p4dp_get(p4d_t *p4dp)
+{
+	return READ_ONCE(*p4dp);
+}
+#endif
+
+#ifndef pgdp_get
+static inline pgd_t pgdp_get(pgd_t *pgdp)
+{
+	return READ_ONCE(*pgdp);
+}
+#endif
+
 #ifndef kernel_pte_init
 static inline void kernel_pte_init(void *addr)
 {
@@ -334,41 +369,6 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
 #endif
 
-#ifndef ptep_get
-static inline pte_t ptep_get(pte_t *ptep)
-{
-	return READ_ONCE(*ptep);
-}
-#endif
-
-#ifndef pmdp_get
-static inline pmd_t pmdp_get(pmd_t *pmdp)
-{
-	return READ_ONCE(*pmdp);
-}
-#endif
-
-#ifndef pudp_get
-static inline pud_t pudp_get(pud_t *pudp)
-{
-	return READ_ONCE(*pudp);
-}
-#endif
-
-#ifndef p4dp_get
-static inline p4d_t p4dp_get(p4d_t *p4dp)
-{
-	return READ_ONCE(*p4dp);
-}
-#endif
-
-#ifndef pgdp_get
-static inline pgd_t pgdp_get(pgd_t *pgdp)
-{
-	return READ_ONCE(*pgdp);
-}
-#endif
-
 #ifndef __HAVE_ARCH_PTEP_TEST_AND_CLEAR_YOUNG
 static inline int ptep_test_and_clear_young(struct vm_area_struct *vma,
 					    unsigned long address,
-- 
2.47.2


