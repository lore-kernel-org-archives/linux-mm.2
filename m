Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22BDDCE8D7D
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10A658E0010; Fri, 14 Nov 2025 14:00:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BB348E0006; Fri, 14 Nov 2025 14:00:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC5008E0010; Fri, 14 Nov 2025 14:00:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D80A58E0006
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:00:14 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65C511A04A1
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:14 +0000 (UTC)
X-FDA: 84110127948.29.905FF70
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7A2BA160002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:00:12 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=iGAQNozd;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763146812;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u7XVvQovi1B87PI8BOl3fRcDQNVRDW1j8jgntLzdzQ0=;
	b=VgAI6iocNkwcb8gt7WJCKde7pB6AkrAaey2V9QqhlR8waiY+bdE+gJ1spluvUoPiai9SZt
	HhMx8oRwRtEYLgYLmwkRHg+fn8S0uKkNZxHpdqrqjLvtKNoVKBFK9RVDuM8+LmFSTIRfIw
	uvrifQuL4dG5pAMiPkSb+4yYrd9SfFA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=iGAQNozd;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763146812; a=rsa-sha256;
	cv=none;
	b=v34HVGY3LReLS/eD5SaAdzrVKtFB4wURvhmAtwMJBsOLJWZR5QPgr0g8qY6znaUID6MZll
	0PGRbgANILrEjGUoM++5lZXkDCaLPmrrJo2sOTnqjRckqtPCzpa3oaLw8sujzk/TXLsGLS
	VVjljJW3/Z+Wriua+5yfcR+0ceI0ric=
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-640d4f2f13dso2271167d50.1
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:00:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763146811; x=1763751611; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u7XVvQovi1B87PI8BOl3fRcDQNVRDW1j8jgntLzdzQ0=;
        b=iGAQNozdWUn7NsPEbrUzhqWAB67oeFfHXNPoMV1QqcIw4gGZQ/JUAOEsX0hUIeU6W9
         A9Z7L4tc2SRoW9DuuxzbG6jOMVJEiUldRquUGrMSpIkeQy4cSDvsArZF1bhDGXSetf9k
         tVC/simrJlKST/xiDxZDdyPYIU7RkrAkUF0E1Ztvpa3mUw5f2nTg6MdTC7B0cOL/DHDx
         TdDhoTqqgEuPsLC1lXRGUUFMKsBnGnzWusZ9R/naYDaeV6d2kZSmuUFxSkv7tIH7M1rN
         dRf/8jx2m9rfFRilLb3c/P8nCRT9fBqfpLByNmsVAskof07h7+fdozOFOVW789B7E15U
         dW4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763146811; x=1763751611;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u7XVvQovi1B87PI8BOl3fRcDQNVRDW1j8jgntLzdzQ0=;
        b=bUWN82UDFc/DC8Gv3SXAj/BQ8t4V5cito1LWXOOLyect3aN/KpMiWEgYmOuNRUoZ28
         xlgMLXXemM7A1xMloRfLMbwRMk/NzT51n/Nv0YWKkx0S7CDzjvp0D4uJ8BpQWJC3IVQq
         tPFvllQiwxyFhKaY183N/nVJ/3bKXH2CIdqK1SG2uM4jbnydTOiyJg2RXRb5q1MDtoJN
         5JWlh7X6ehZCuHVzqiVcJoExMHyeaOQBWoHLr4ChQESn8PrcK1yk42ThL+bHOkxeiRqa
         oPsghzoJfRXcOA4mMt0D/MnX+os/+i47PhsQSHwLu5g8DLzEehb0Smn88U5xJ2ewqq3y
         Wp8w==
X-Forwarded-Encrypted: i=1; AJvYcCWbdjnJPNYRYtjBo4UwxNz62fNqtWIrYEKjo9w3eeCjTvDLjnLpJVEE/2Mp8IkLNX82m8kz/zWmyg==@kvack.org
X-Gm-Message-State: AOJu0YwKhgU8NLP4+xrOs066ZDt+o0Kbcqe42LwmY51MnilouJkz9RwM
	XZC3zkcAFFvb+tvFUWm/0wgulq2OsWKEbDhxp8sySLiBNg46ziq2NhsglT//sR6IhnhXohngrNR
	S0HpW
X-Gm-Gg: ASbGncsh240G/bcef3TO25CiVX1cby0Gnnd1bI2lZUB6W0lQY2+gEGSzp3ovpOXrWIE
	ZxD1CLRWImEFZX8a3AR7/VS56rXQRow58+Nlwv8BY+VVkjsgQ1I3byBqSLVGjhS+zuMF/yTFIbO
	l0+QzoqYAIUIedtotO1TzyU/jtISee2DCQBvJvjw3cPbozy7W8V6iEiduLzLlCW7zdM+KD+1zB1
	WqY4Ypbr2AtMhJLkUpdzFRRakuSedV+usV/UC1TcQeRshTe/fbvOShm6qcmWlnEFEpyEYQwx1B0
	unLsejwtVkDrnnIvlsM8oK2JO+c54ZpI29Klf15KanM7gVBDIT87erBnfym+b0bOwJsbKf9WxH4
	GqBkRt2KK/nEER9l2OAtBmsHtM4pjgYd5VOl7qZRSreFBtXi0nbjyDlU0N2z4AL1UtAAXUvw+72
	CG1ks48ae5GJC8a3dFFi+GdXgeoBwGrrFZqIprrkO9ojaHjBChmbr3+HlJAYVA1Xk+MwLb82Itm
	ehqfVK23CRG4sG/aA==
X-Google-Smtp-Source: AGHT+IF0iKCWHE07PgWFg/A1CwFMxmaP8Ueh0K2652mZRWA2JKfJppAhp60Gzd/8KnWhTuvrWjbQjA==
X-Received: by 2002:a53:d048:0:10b0:63f:7de1:7acf with SMTP id 956f58d0204a3-641e74e13cemr2926186d50.22.1763146811446;
        Fri, 14 Nov 2025 11:00:11 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6410e8f4f2esm2014058d50.0.2025.11.14.11.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Nov 2025 11:00:10 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	bhe@redhat.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	jasonmiu@google.com,
	arnd@arndb.de,
	coxu@redhat.com,
	dave@vasilevsky.ca,
	ebiggers@google.com,
	graf@amazon.com,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	kexec@lists.infradead.org,
	linux-mm@kvack.org
Subject: [PATCH v2 04/13] kho: Preserve FDT folio only once during initialization
Date: Fri, 14 Nov 2025 13:59:53 -0500
Message-ID: <20251114190002.3311679-5-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
References: <20251114190002.3311679-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7A2BA160002
X-Stat-Signature: sice39xf9p6ptfrxpsnq6otybgx4d9az
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763146812-185355
X-HE-Meta: U2FsdGVkX1/YopMr9oHyMYs127CxCeoBtp8pBOa34ruZDHwhwXZ6B8obr2vtNLqerZMCD+531wmvNZBXctYUSPP5XcONDSymla1hD2tle3mE2oMZ3pgTZtE/maoVWuzQTghn9ejqdfEt9cOLL0NLWJspvHPCDjA5NUW4spxLENq/e/nCaDOvCi4Ccrxr2XZtaKNPv3ct9tPtzQ3/vjX0IAvtDl/6xb4pZJs/wn6QfVf/RKu1e4Q1sjd/mckmaCrUNAvGjPB4NnvR6kGZOH33hrn1VfDN1uVqTS0+j2ckeisiFIYc+2sLKj+DXkWXJ/2obzZ4IaSVHAwKxExqpZ5IN3vjq+CfER0LvWJ8G4OB2Np5EJYikg93k2vVt7VpoKmLwYMhep34XH1w/fYO+Q0dYBc+nYDCzcEOFr8P4EzdCr0eZFjNPvEjtJjgGRI4IcW74P5dJtP18p630VZH1Y0lD1JYbrxscPgIpJ2q8GrqL8yKY2URtAzR4UFcRPfwxgfGAnsZlKP/tK2/bhOC4mgl1uozpjkXJeHz4gkUVueC1dGU+T9bz9dGpsNEa6602d6N90UOA9BTTV0uJGP5/TVIq0t6mTx5lxFOU8sTMRHoGX0zI7r4ABo3JYSv0KsOWDSZ7Q3pjm1C7DtbOVtrh8p4wCfIbXhmtkHDFsGlbArnL4lhuGvRMJIfjPRXUWnkygMmJwzgUMXaPFXVzHocoz3H9iMWoNKt6rkDMCb1whGc5IkZneQgH8zEAMMcYtFbAFh0QnbYo1J1iY3JSq8k+lVTpeI2YIDeUww63uE3KUezesU8g+V1gX3IPO5dGFIC149c5AcSQD7ql0b9ATFfCi6DqoE5us13gV0/FutvLqXPuwj9LmatU8DkS4h169o8NfCAziBadAufhN4PjFQXFyCEPtjxPBYg1xQhIjJ3iU1wqWuQiyytSy5f4gh+mcMlfnLFMy9AKx7mgAFCAcFqnkx
 JUdItH+9
 KkbOUKLR9GiuFZApzCH2+uKQmFrLfZSH66r0K36gOLM7sZ+gWZIBAsiHMFJRPVsHTN4qT2JUprudZImfoO0X/587HE1H80JeUIUR+YNMk+t42VHM50b++QBu1rEgRYuzpb7eZLVWf48ykymldy6YF7uFum7jTkicOHOSVbC5vET7upzcZJk0oOXwNNQCJb7w8+lW4jv+q//5jl6uJqKjK0hlYw8bhtUljP47zyKTsrG/tsKHH65gupROi3v7BHcF/D8mNAjwSJE+huodAdgsUx83a/YcHC4PQTbQv40OvjGdPYFT5RBT790BgTRDqY+TSCPdh0dWWi1L8r/dQWHNQRLNH7Q9rbfe+1cei
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, the FDT folio is preserved inside __kho_finalize(). If the
user performs multiple finalize/abort cycles, kho_preserve_folio() is
called repeatedly for the same FDT folio.

Since the FDT folio is allocated once during kho_init(), it should be
marked for preservation at the same time. Move the preservation call to
kho_init() to align the preservation state with the object's lifecycle
and simplify the finalize path.

Also, pre-zero the FDT tree so we do not expose random bits to the
user and to the next kernel by using the new kho_alloc_preserve() api.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 kernel/liveupdate/kexec_handover.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 5c5c9c46fe92..704e91418214 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1251,10 +1251,6 @@ static int __kho_finalize(void)
 	if (err)
 		goto abort;
 
-	err = kho_preserve_folio(virt_to_folio(kho_out.fdt));
-	if (err)
-		goto abort;
-
 	err = kho_mem_serialize(&kho_out);
 	if (err)
 		goto abort;
@@ -1384,19 +1380,17 @@ EXPORT_SYMBOL_GPL(kho_retrieve_subtree);
 
 static __init int kho_init(void)
 {
-	int err = 0;
 	const void *fdt = kho_get_fdt();
-	struct page *fdt_page;
+	int err = 0;
 
 	if (!kho_enable)
 		return 0;
 
-	fdt_page = alloc_page(GFP_KERNEL);
-	if (!fdt_page) {
-		err = -ENOMEM;
+	kho_out.fdt = kho_alloc_preserve(PAGE_SIZE);
+	if (IS_ERR(kho_out.fdt)) {
+		err = PTR_ERR(kho_out.fdt);
 		goto err_free_scratch;
 	}
-	kho_out.fdt = page_to_virt(fdt_page);
 
 	err = kho_debugfs_init();
 	if (err)
@@ -1424,9 +1418,9 @@ static __init int kho_init(void)
 	return 0;
 
 err_free_fdt:
-	put_page(fdt_page);
-	kho_out.fdt = NULL;
+	kho_unpreserve_free(kho_out.fdt);
 err_free_scratch:
+	kho_out.fdt = NULL;
 	for (int i = 0; i < kho_scratch_cnt; i++) {
 		void *start = __va(kho_scratch[i].addr);
 		void *end = start + kho_scratch[i].size;
-- 
2.52.0.rc1.455.g30608eb744-goog


