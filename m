Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F55CCA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 14:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A23748E0023; Thu, 28 Aug 2025 10:27:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FB148E0006; Thu, 28 Aug 2025 10:27:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 938538E0023; Thu, 28 Aug 2025 10:27:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 80DD98E0006
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 10:27:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B7445701F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:27:03 +0000 (UTC)
X-FDA: 83826393126.26.EBEE785
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf11.hostedemail.com (Postfix) with ESMTP id 64B7B40016
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 14:27:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rVDfIS+j;
	spf=pass (imf11.hostedemail.com: domain of 3NGewaAgKCBEt322r3r9x55x2v.t532z4BE-331Crt1.58x@flex--cmllamas.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3NGewaAgKCBEt322r3r9x55x2v.t532z4BE-331Crt1.58x@flex--cmllamas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756391221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HjD5d97R1LAr1xBK44kBhUa1ACBsYphiOf/BSA+9IH0=;
	b=Is5nTNU4bXePIyoDxU+VRP9pU/vhtJWhxpMnk0gHMdAf2QuAMatxDE83bdiK4G/eb0nj1t
	JBKPx+ZKUnFZvTd+HHJ8CvbiQMJZAMkJQEUd8I9MX95RbUE2I4R6nMTpn+Xuo5ANQTopff
	DbLGPBtzn3sXKl5Ch5OxBSPHHLhKb6I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=rVDfIS+j;
	spf=pass (imf11.hostedemail.com: domain of 3NGewaAgKCBEt322r3r9x55x2v.t532z4BE-331Crt1.58x@flex--cmllamas.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=3NGewaAgKCBEt322r3r9x55x2v.t532z4BE-331Crt1.58x@flex--cmllamas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756391221; a=rsa-sha256;
	cv=none;
	b=RylHfXesZDXOlb15E7g+WmyektR45hcZuZIwpDkiSkoNNq5BR2fWdMq5iB+Yyy63rO8fiS
	icF+Zdd19M3h1s/p85Wa80xxjrTbsdW2NhJBQEyim1jHH4z8I6QzSDmCtVXowmNuGRXOPV
	KpjEsbG5bS3qJQNLVTXQZM3ih3EVU9g=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-32752f91beaso1295111a91.2
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 07:27:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756391220; x=1756996020; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=HjD5d97R1LAr1xBK44kBhUa1ACBsYphiOf/BSA+9IH0=;
        b=rVDfIS+jn9Zjuwtod8va0g6fexsJyAwfRNPU3WGuzgiF9YPIkQKYxSBJ4/QUe5NKLp
         u3n3QEefN5Qb3UB2Mm1WDK9EZBMIQB8M8Wiu/FIAuoFB80M58XQchIU3ZXgHDCvDSPaf
         eD/9Nwv0wTlCZRfMXemteI0jDuyVijg0eCYR9uJurFaEtj76QtJBKkKG82yHWiC6BO0u
         5Vun1u1mv9cgtuHGEdnDBGSrEOJRIILl0UPyvh6fK5mrEkYhq9vd9klTIOKWJrRisdYt
         pdquBls20xavvmzfAJkn8EOwd7X8bouUM+X4AAMZiy3xkGf5TVkfv8uNPju589s1J7Z6
         NOrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756391220; x=1756996020;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HjD5d97R1LAr1xBK44kBhUa1ACBsYphiOf/BSA+9IH0=;
        b=sglu0eAL4yIpo1K88VWF+iwdOlVjbiwWGpjuNzrBSqrduh0IHOFsmmk7ojHTLxf6ws
         9Lw2JpTMAhRRSHmFkGwTFMZaMR9k1Ykh9n3EGqAbjbPZnFmrzuV+sp3iDzLgNilkTiA6
         Yoyd2oJ4OMglyGOfjgHxlyKH20fYCO2srBKcFIwpv/fpd3dqKZGU6yHmjM4lX0Bs4MXH
         uiV+dnQmoWpFcPZt7R3aq1wPthZg1XcJ+srTqJyK+zthVjlvFWSn22MUAVIA881sFsB/
         l4idzhOPveOe0u5mi4dRA3iw8tsoPj/0PVgeKlWNYsVxFWtvydbP+zChv5innp/U4zQS
         wbnA==
X-Forwarded-Encrypted: i=1; AJvYcCXIPmkeegB8ZgozG5VppIDea5COwo9BzGE5+WwNVgemP17IZ4G6tQ98ONtli+T3GyJdhZbVxZbTfA==@kvack.org
X-Gm-Message-State: AOJu0YxDxz0fYZLTWY0yB0sqClZXYFUgFUY5iJxSAqjA/OerQB7KnXQY
	XOvLg/+qL3XuwnZ/VOvT2O5nAxgOxcKC6yBOsI9ITCGMq4BnpILsO6nfxoNLJDOgKXebXrsJ4ln
	rTA7vmR27H5Xn5Q==
X-Google-Smtp-Source: AGHT+IF9wJepfLkWp6Og7zLWkPVfPHbPoBbta1qRxO+u28C19vYypQNzFjuUung9UUyEScquLFDzTg6qQ/Fh1w==
X-Received: from pjbnc12.prod.google.com ([2002:a17:90b:37cc:b0:321:c567:44cf])
 (user=cmllamas job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:e190:b0:327:8c05:f89a with SMTP id 98e67ed59e1d1-3278c06016fmr6502149a91.4.1756391220243;
 Thu, 28 Aug 2025 07:27:00 -0700 (PDT)
Date: Thu, 28 Aug 2025 14:26:56 +0000
In-Reply-To: <8a4dc910-5237-48aa-8abb-a6d5044bc290@lucifer.local>
Mime-Version: 1.0
References: <8a4dc910-5237-48aa-8abb-a6d5044bc290@lucifer.local>
X-Mailer: git-send-email 2.51.0.268.g9569e192d0-goog
Message-ID: <20250828142657.770502-1-cmllamas@google.com>
Subject: [PATCH v2] mm/mremap: fix regression in vrm->new_addr check
From: Carlos Llamas <cmllamas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: kernel-team@android.com, linux-kernel@vger.kernel.org, 
	Carlos Llamas <cmllamas@google.com>, stable@vger.kernel.org, 
	"open list:MEMORY MAPPING" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: reqj7zaigjdtpsnxse5gfbmsk8uy3g1u
X-Rspam-User: 
X-Rspamd-Queue-Id: 64B7B40016
X-Rspamd-Server: rspam05
X-HE-Tag: 1756391221-727442
X-HE-Meta: U2FsdGVkX185vbgqvOzhM/F9Y7oH0s0XosDlLz1nHRXChrr80H48DNG0TyT2W7H6VFlI/Pvl0kQ4uOZvGdx3QWE2xedoSbRz1mafykSrS5t5RGrHEBQEfMRNuwnRSjLyjOcW78NaaqThspb1YapaLMLC82P9p+nq7F5FMfzEcUKVEYa5603N1wt365Al3JdVvSsEakKz6yaHje9ROaQ8K6rcI+76cG0Wn/GTnMa2kigKh/W4OrXFvnb+fo8ebLHuOJIj6Oz5drJAxa1Y05dhoCbZxzHiLsR2OvkxBBhtiUtqJE1+DTcuNN0siD5Tk3ogvGZTZ1pGktS6INLW1dRXTR/N/NYNQvlQW0JQqXt8qk82oIfUMTcd1QsY1dKwmigtcHSRJKrhHLsPKNKF5RUGgNokuPaKZoE7fAS3P6mi+z226Xut0HLCGybZPZfocOUYqPyLk+DdEV/Vsn5f97klQr8WejdA9DNGxdkpg2ujalL2lVwqvlNmQRjxYdIW2RV57VbFr/o7n2iNlIOifhwOv8Klf/Re5uZOAO4D9sjjCq2p/vpZDOd1nELXILFSnX5Dwg2TvsGI6i/+XUoMoGuDA4dsYJeODZ9lp4x3Nu89pNZbkAQj5YuwXbEQ7v2BwyGKGShrgx0ITb3j7wMfNP6BlXcgoAcPc3mzd6tnz2chA1Z05M2K9RbWMV4s7QwE/AMIpc/euciKWOg7egcWQIGEt7/TPZjgBMGn2hmoIsPshPJLhxVmPvVG76v1JINGrigbhHq3z5+IZQDOsFvC6sd3uCiEYb1fKgU/ZmNzQAQgXT6aLq5PrPyPRUenutW5raOuf7FU/R2jwlMzFGr1mUzfRFFXSMU4jCE/3vyc1U820WUzgst/b8M2ATgQS3+Vs1wzQR7aa8VOh059Rtj0dhZe82Prtx3CpWrUTBmGh4CprVDqPK5Eq8CyRF9HZ/Utr5ynioAiElwXub3fbWd+3Uz
 oE2xaSBi
 6Nutw2eRBLcR4tOum9ueiY0BfsiJfzg3iQJblodsdYtIq2/kPJIE2eIcu3yDhlWzKkURmeHd2znLQ6NxybTDGgjfN+W8o7OCJSafhQjXjrgAwx0jLZJana4v3sMy+9NsCXZ5+rbYJXu/BuiKZ9k+I6pg4Dg3PqQkzc6AG5cR7ePwUeOJWL9InW/3yV2Y8MxX3JPpRkqLe5YnM0TD9RFoEU09sTQS9LI0qxL9UhoHcP/iDBhCWO4A3TZyPZ+AqKpJy/9Aak/fWzGk/vqzp//Maa8LXYmPH/PKTWALBzQQrEvExV8ZMOicGuBAgs9Cj4Qph8K/ynrfsSfv4cBFXLNYb6H0H5203EJ01Imd4dzV/VNMSjle4Xn2BmtZseWjvWE5swBO7kZTCnwey7eK76zwBp48SZ7+TUc6vU9Jal5HhGCoixTanSq9tYAaLKWizYP/PKeSu+EymTaCS16MUokThDp6AJr1r1YccbVNG7AfxWSmNHEmMmWo5btUox2D/zVR/DATwOCKDX6kG3f9obNcavZJ0AlkgfNs8LfdjJRFxr2SGQoPt/d5hCTET3y9UClFGX9Tab8skv/FBf22TwWMM13v0Kgml/6FcyunTyAjJrjGPpN+HeR4LUcUXCogGWyfaDpdDlJydEslxe7mT3W7aS8PBeg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 3215eaceca87 ("mm/mremap: refactor initial parameter sanity
checks") moved the sanity check for vrm->new_addr from mremap_to() to
check_mremap_params().

However, this caused a regression as vrm->new_addr is now checked even
when MREMAP_FIXED and MREMAP_DONTUNMAP flags are not specified. In this
case, vrm->new_addr can be garbage and create unexpected failures.

Fix this by moving the new_addr check after the vrm_implies_new_addr()
guard. This ensures that the new_addr is only checked when the user has
specified one explicitly.

Cc: stable@vger.kernel.org
Fixes: 3215eaceca87 ("mm/mremap: refactor initial parameter sanity checks")
Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
Signed-off-by: Carlos Llamas <cmllamas@google.com>
---
v2:
 - split out vrm->new_len into individual checks
 - cc stable, collect tags

v1:
https://lore.kernel.org/all/20250828032653.521314-1-cmllamas@google.com/

 mm/mremap.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/mremap.c b/mm/mremap.c
index e618a706aff5..35de0a7b910e 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1774,15 +1774,18 @@ static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
 	if (!vrm->new_len)
 		return -EINVAL;
 
-	/* Is the new length or address silly? */
-	if (vrm->new_len > TASK_SIZE ||
-	    vrm->new_addr > TASK_SIZE - vrm->new_len)
+	/* Is the new length silly? */
+	if (vrm->new_len > TASK_SIZE)
 		return -EINVAL;
 
 	/* Remainder of checks are for cases with specific new_addr. */
 	if (!vrm_implies_new_addr(vrm))
 		return 0;
 
+	/* Is the new address silly? */
+	if (vrm->new_addr > TASK_SIZE - vrm->new_len)
+		return -EINVAL;
+
 	/* The new address must be page-aligned. */
 	if (offset_in_page(vrm->new_addr))
 		return -EINVAL;
-- 
2.51.0.268.g9569e192d0-goog


