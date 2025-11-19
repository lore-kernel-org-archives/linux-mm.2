Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50CA5CF3942
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 115CE6B00AD; Wed, 19 Nov 2025 10:45:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 029776B00AE; Wed, 19 Nov 2025 10:45:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E32F26B00B1; Wed, 19 Nov 2025 10:45:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D320B6B00AD
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:27 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 557DA160540
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:25 +0000 (UTC)
X-FDA: 84127781010.12.C49AB2D
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7591A160011
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=FQF09QYH;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf08.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.53 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567123; a=rsa-sha256;
	cv=none;
	b=UHqGG4KIPv6o8lEP/a07qxNkdCMlp4Ycl0PD3+86ZutXQBTTwKBN1DytC6iG26qCCGzRaw
	RaTqXMcPBz3+Dju76DxvNLd9g5PlKecMG+dj/QgKPakWVKfEsZf5dFECl3PfB94KoQkoXA
	gfxTx5bEGVxZb0jeGYrnImVWBMaZLF0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=FQF09QYH;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf08.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.53 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0blJpzJVpLViS6yP++1+Q3N2n4IWObMjESar9bHwcO4=;
	b=ADxvqKrycYs/kJPNFvtgdBvmgAADHhKG4xkoNgRJisTtRX4WdhvWZHRa6v32WJpGc3FTQW
	wGb9+sv0lMrqpy0hTvmZjD/GN1WTXl+xx+8KGwM/Zmw/LWvmbbBRHl3fNOJ6mSNycLlLir
	WYadCn9BsTmgOm9bbYwpWIdh3oRrjx0=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-477a2ab455fso38459475e9.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567122; x=1764171922; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0blJpzJVpLViS6yP++1+Q3N2n4IWObMjESar9bHwcO4=;
        b=FQF09QYHUvwL6SluIPJsS9ErFVfmMqaZdoN2Su9JWYkaUB8Wv49EHP24XKvVHG+l3d
         1BitiVi+HMxMqcRehO81yt3NJf49TKKOGjcmUWl8hukdvkxgDVKPwLB4VjZcPXfOJ8W/
         qELrk3+vvV3usFFADTn4cVdcd0Ye+jytKmb4WtYfNsTbOcatMRjw/w2RqKte6dTKYqcv
         0L9FUmu4Ny1CFdCH3+MfMbowBz+MYMDUXsuPUaZpmzbJLh/MNzmRNxNkeL7jNn87U/uS
         GGVT8gUxjtlI01CZrZgiylZKuYI6HVCjUmujtOzLaAstaZE/ULSRDQNNZLGFv4J8YpxH
         xk+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567122; x=1764171922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0blJpzJVpLViS6yP++1+Q3N2n4IWObMjESar9bHwcO4=;
        b=l4p+0RlNMc65zRloWOmUjELrPfeR79yZPKMvmKxCpRyyHJ4x1idVj3hsrmIvHJ1Nyv
         9Fx3e6M3Qqvr4yxxeDFOQnBBzABNj5n4xYWHaU3S5rpgMw71mcTY3ULCrEsAptqQCMBg
         d3aufHjQ0+TX4eKJwioIBoqNwVmzHnxHsWgymnE2aWHkvM+gRpByN/6ixR7puMBgFsyv
         /m4RlLbeZmgPDFXBISTi1agclubL+uVYoW16/3aHWynHYYo7UNjZhMIUonpJA3Q4Q/YU
         7qSKMSLCKIVBv7fL4ChLn/3ugjEzOz542m3aN9QF5hxH+AR1d6yMoIvoAUp4DR5jRpbz
         bVaA==
X-Forwarded-Encrypted: i=1; AJvYcCU1yMUJpGnMZc71v0vlcJ42vv1U6EFBhScOMShCt7aCqgebUWyWWjZ0sFOeJT80IR2JpQg0tJ+BDQ==@kvack.org
X-Gm-Message-State: AOJu0YzQChoAamoEvyWnKl0/kV+OC/txvpLmnYB8SfAmW0JrRsWizLvv
	Ei9e8fkGEQt0XqSLf92lwTvTC36Cygv2BLKg+NiFtO72ALSAyqjMdvFe5+WzOLm6c/+PEXqYDSo
	nLUxCv77SUA==
X-Gm-Gg: ASbGncv271N5cuL8vEAqAuq7cw/VXXsAiPWzf+8Dc/uLJCxTprGzMmSjANItXgXIB/h
	bLDhAtAPaGFt5Bu5fXtgOYbkDM3AVFx0DRgBfvv5T4E6kgfDToa2LSva3rgcDB6S7MTOanXV+Dr
	oOnEL9PPnVRLutxzWUiMOfPtrPvvAuuEdP8VQ9dH/PBnptFRSD3GQM0wpxsV/YVsSP2nBxoQyXX
	kNFACoa4eXLyxuA5Q0X7FDwDetYZ1KwXY7xXNFPWfunlApK4lw4DWOa2dHfbHlaBjS2Xqt+pEMk
	vyC54YymN052NfJaKT8KvoGFAonUXc7VfH7aoNGLFijtvSa6OADiwLULRZcsZBpghuJVNhyRPFJ
	ITgrOKZYCix+GeTKdq/+fSHV6kWgNoDeJP4zL+MjKEImRnUa0Mo5vPbk8+BsGGSdWzZFLEOwMEt
	oRdwQIKG/cqGqRE1Hkq2c=
X-Google-Smtp-Source: AGHT+IEf0A8SfCPAIU5Y+01ECXL2jbadglpozgNAZPe+3fJhQYPBk8r7h45IbtadEb3Wt583O3k4NA==
X-Received: by 2002:a05:600c:3587:b0:477:58af:a91d with SMTP id 5b1f17b1804b1-4778fe522f3mr209598755e9.5.1763567121930;
        Wed, 19 Nov 2025 07:45:21 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:21 -0800 (PST)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com,
	rdunlap@infradead.org,
	corbet@lwn.net,
	david@redhat.com,
	mhocko@suse.com
Cc: tudor.ambarus@linaro.org,
	mukesh.ojha@oss.qualcomm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	jonechou@google.com,
	rostedt@goodmis.org,
	linux-doc@vger.kernel.org,
	devicetree@vger.kernel.org,
	linux-remoteproc@vger.kernel.org,
	linux-arch@vger.kernel.org,
	tony.luck@intel.com,
	kees@kernel.org,
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [PATCH 03/26] mm/percpu: Annotate static information into meminspect
Date: Wed, 19 Nov 2025 17:44:04 +0200
Message-ID: <20251119154427.1033475-4-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7591A160011
X-Stat-Signature: c6oc5fojf6y9o845355igwypc56w94ye
X-HE-Tag: 1763567123-97455
X-HE-Meta: U2FsdGVkX1+JUJ+nFY8vN3UJG+fwv0PWBpkoM8Ca0c5MbNX/6Eveiy5/o5IMb5wSU/XqQXPuLm3ptY65EdWt5jcHMD9seUi04udfFwPAOyt5Nvw7WF5evNp9cVTWkWfwIGtAq4QkbsxvB3r6t3HJ3A/mO4DY6R1sIZpiQzpX85g4AsJ0KXsO+zWeskJLmmcdy7py1jaPAo/1sbXR3TbEWINSHP8BQOI6YMMymn4SK5cszyk2uDMeRY3bZeIxbb0eXkUS4oyuqv7Lm/v8dWDSLiVuGuHIRJtncxdXGqW68qj7J7OaKM9WrdrU+DeSodjSHuRhxPqTuPFxvsWGnBPzqvhVfaXY62WkRWfvQaqKr9qH0868Q27ZW3vUqVjEY5MvVX7Z90Gku+M4DqGiS+YUT3Ax3rwpynyaKgI/A1edU22o4jaVQMzd5ldZNlnXxgNq1bUHx69Tnxe4KQPP0aY4BSGQ6twtfZ62iux2Go02z/YskZ7ulBN5BJcBITmZO1vwVFZA2CgXWOpI1thlUlSgzaU4i4siU96/XDR7GZWol5VNHsLojfp1xPCahURexqkHttFw+IEA4pa3oMa9nFjFAEpw+6ye+mojH2333DkSjwTMUtWHe3vcZNxvWyBEe+zzJ0iTcf2PQG6y7sdKCsmtIsv+Znp8McMZ9eJT4s74nhfvzk4op7HShuf3BE3ZU/UiTHpT/a8EKnwU4yuUGsjg5qRrBZ6tNxdcLwk+7Ec5WfQ+7bMSA/nuG7bRSezDhKG/KePnyFLuqNtMLPYAMOH8p7hK1o/21G5RkHyPPwXQDUwtK6vhVnFKemcIJO7YxAJG7m1a2F8w0SOvywZ/og8T3t/ZBUuZ904la4/LwWq+KAM3Qzov6hqfXU3HPbIxjdXcYlHibyJAKkbReVvfR6h804A0X7UsSVp71EQ+YNvjS3yJX/uWvqKwCBvjWgfFec6OnvamYeHK5y03VeuhxHB
 9IooA7WC
 IAueMdwGoxMsrSr2mqUG8iDYeANM788gyMK5s/fI4emPkA6osKhFrxYorzWK3YPOjWoyzi7eMGKfIRFmSfRXJaQF2Kn8iw/YNAjFM8pX1FOMothjLIcDwyNVLOR5tg2maeAZcswSXk/N28d3HLa6lC7Zen6a8rEYav5Qi5sebIWrpgb0LBP3ZR+ApcWXguq8gc34YNODHi2zWcQK4YVIaYgrYLL5EF1dcEz1mBtdtV6XZVhwldjAtzYjiS9tFKNpo2LUs0+OfkPCTBDwA5dCKgkHry85QRHEZSAxMTQoUHDsKUYnwl9X1v20eI6LUK43e+WaaTCURk8gPGYBiYHo90NPFfMnHG5dUiYc7VJJ9kb2aGGjq9SbmYFbkMAWWrmchTdyxRfMeKv4se/xrn5gOqlMXsEcFnmbbO0ybJ54fdyypZxTQ6/qmJ8ftgvt/KW54lv+P/aas1ClJeTY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into meminspect:
 - __per_cpu_offset

Information on these variables is stored into dedicated inspection section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 mm/percpu.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/percpu.c b/mm/percpu.c
index 81462ce5866e..cdc5b30f6a99 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -87,6 +87,7 @@
 #include <linux/sched.h>
 #include <linux/sched/mm.h>
 #include <linux/memcontrol.h>
+#include <linux/meminspect.h>
 
 #include <asm/cacheflush.h>
 #include <asm/sections.h>
@@ -3346,6 +3347,7 @@ void __init setup_per_cpu_areas(void)
 
 #endif	/* CONFIG_SMP */
 
+MEMINSPECT_SIMPLE_ENTRY(__per_cpu_offset);
 /*
  * pcpu_nr_pages - calculate total number of populated backing pages
  *
-- 
2.43.0


