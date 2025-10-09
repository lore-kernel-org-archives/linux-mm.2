Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F21ECAC5BB
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 01:59:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA9428E0056; Wed,  8 Oct 2025 21:59:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 996468E0002; Wed,  8 Oct 2025 21:59:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 835D58E0056; Wed,  8 Oct 2025 21:59:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6EDBF8E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 21:59:01 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2A96C46107
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:59:01 +0000 (UTC)
X-FDA: 83976917682.22.975CA8B
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf11.hostedemail.com (Postfix) with ESMTP id 53EE94000B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 01:58:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=CxrWeFK5;
	spf=pass (imf11.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759975139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hsaEY+Rh/SX8Cp9wIkDltmX8vYREKpu310o7cjQ17zs=;
	b=E1Gyp/uQ4ED16Xb3qtjElWuel5pgen9cQf4i67tf22Mt++zgYG3h5fIGy8s7G/Ry+DlXtQ
	IR/8bXN4m/goEDnn+M+FLvuBC+JhebC3rl5x6rmNqFLbmH945jm4r4CYbCwLwqBFkvja1E
	lns+pE9CTO1wRO2BR9qzxEDi6FwVd70=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=sifive.com header.s=google header.b=CxrWeFK5;
	spf=pass (imf11.hostedemail.com: domain of samuel.holland@sifive.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=samuel.holland@sifive.com;
	dmarc=pass (policy=reject) header.from=sifive.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759975139; a=rsa-sha256;
	cv=none;
	b=t0Gp48HCYO9vfhoWMIWp8hPw8Sh0NE3Wa0q4gJ5NgUL7E9kHERAq8Tw8Dg1x55uTIuI7EU
	wY4adSipnIQKPm4O8Z9xp3ZPbZunujtRbU2fVybYp5z+auH1xgcqVOEF7xikG2pS4LXHtK
	KouvIFZXnxTpOCCpZRluYyDqh3Yuaic=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-271d1305ad7so7152645ad.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 18:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google; t=1759975138; x=1760579938; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hsaEY+Rh/SX8Cp9wIkDltmX8vYREKpu310o7cjQ17zs=;
        b=CxrWeFK5BIc+Yv+OztuNKh+ozkmpFHvOI0S9jTu6U0qtKMza6v0DVC0GejJvI9z5mb
         OiiwiTsNjPlkG5Y3wQN77eo+UK8+Krd3Y6JvTRSP083x0Z4h0/qW0bKwnewdeK3QJb5R
         zHMm20EVNwv5PGNk4nhxa/3oyGoOcuC5cUlBQ4K376yFX65j6BuelOnJXGIxUA87bEIr
         lpkEVecfNTGNnXgU51XOWuprvevO2/7Yca+Y0LNkzNFJhy8Fo+R4a4jaitZ+ZDMP5+9J
         o90edLMbEwI8LxKuJxy3CrcbvSusFbgbCPFmuXtk/k2Vop5qtAQ3sjxohZ17+1Uv1GlQ
         +Kbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759975138; x=1760579938;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hsaEY+Rh/SX8Cp9wIkDltmX8vYREKpu310o7cjQ17zs=;
        b=gtp/7/fDy9KGFfx2wTZHkT08t0CjRH47FhZgCgu49qELlX2VJk8NOLQfUCob3/ghvn
         N6XiZLys+HmirT1lhQybSJrd6/Fum79Qpa5OxPNUORC72Enmha5M/b3btJy0m809LV19
         KDH+FLOamhCOY3AnynBPp4IU+9sYlEbhiQPnzaSqoSIokd2O9L8XFHcldpotZTKW8b+x
         a+OZVmIVfu3KJ5rBGfE0GGTvv1NyiimgVrfTxyiZ5J9G3E4OjTEhbX0+VFnFNUueFkfH
         vW1UjBKu7MoBWJV+cz5hBpAKiUxJuEI3hZE/ji27mcwwVLnX2llRcgJ4Tt+5FVpB6fXu
         Fk4g==
X-Forwarded-Encrypted: i=1; AJvYcCWJOyc9n8iDU7dhbnAtME1ICZ9OA42y8vnStUjoGgM0YCmG4u7yL5AXwRY3bNyUt7xeQEaThWPBxQ==@kvack.org
X-Gm-Message-State: AOJu0YyKeFKZNwXI0bFdrUuCB6K0ZHr7Ign6aviV6UeRH7WJlLhrsB6R
	jbWANqomaZr/nrGvujq3LhnrpAvbTx56FOcdTM1Scw/86QbaoXBa5N8ZG7jrg5Ab3zQ=
X-Gm-Gg: ASbGncsZRCz0G7lxd1wISkR2Z1gqCtZWysdLSaruIEIozvFU6Wp4rGsqG2LB2V49CSX
	7Bq0+kxv59plzEY5fbe8l9O86bF20xY5gmjzwBn6R6lqCmhZsCwHdnAoIWplNlYKcbSn9pFmdAK
	kFxPNmXYm3wQppxZ5EL6xDYy6kH6fvxnCrgfFYjVqr/Utcewp6Xl+8q5yjcwLXeZLUqaibW37ND
	5bpJXaWz4qPV6IKyKk4zGQGrZEwlcFlWRUzDeJrAWEax8IbQBDix8neicvIU8NuecuYNdOn6YXL
	Ujyxs7QuAUASiYZ5emYfrTe3wGzcStPFzPxtJmaqw7Eci7f3lUNlzD5jb3sV7rQOxjqtju6qjbu
	62OXYaQrfVQ6+92Lt5f8wTwYZIdbP1mmTNJp7MAcYbvbTHSifwFP3KIh9zHc1SFWmVrbc
X-Google-Smtp-Source: AGHT+IEK6h9ymUfW6feQoPDds5nddPhZXwbaTwfv9f5LhAo3XesBm08EFRVtNsNefL2i5+3bnakD+g==
X-Received: by 2002:a17:903:3c48:b0:268:f83a:835a with SMTP id d9443c01a7336-2902741d091mr61417485ad.60.1759975138296;
        Wed, 08 Oct 2025 18:58:58 -0700 (PDT)
Received: from sw06.internal.sifive.com ([4.53.31.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29034de53f9sm11033585ad.14.2025.10.08.18.58.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Oct 2025 18:58:58 -0700 (PDT)
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
Subject: [PATCH v2 14/18] riscv: alternative: Allow calls with alternate link registers
Date: Wed,  8 Oct 2025 18:57:50 -0700
Message-ID: <20251009015839.3460231-15-samuel.holland@sifive.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20251009015839.3460231-1-samuel.holland@sifive.com>
References: <20251009015839.3460231-1-samuel.holland@sifive.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 53EE94000B
X-Stat-Signature: tai86gcpo4tr9gm1brt7uzq45ops7jej
X-Rspam-User: 
X-HE-Tag: 1759975139-486046
X-HE-Meta: U2FsdGVkX1+PsSAddLRkjm9RbYDFbN3ouf7k8qGxf/0bvzvHCj+jBECwNmr0PexHD8AlXcd176i+h0GDknydAfnUYBgUy6SUdpl+6pzltgRViHBmK/c1lNgmwcS4qlLA9H+RFXTtwPRDuwhWie9HhOoUFHL4CgrQKUq9t21vmAuoeJNtSL5g8UvDqLtRnxwAns8wstck1arhP75eVWAv/3sAy3KxJqWMEN2b28uLlvJeZ2SyiCsiWRiBArH5AmtqfI+UfU6Lnla//WNuK7mNW+f5LdqsH0yHB6IqFd8TO4y1BKUGpp6VpiJpR9auOON+vb+6Lx4+Ygd1aX2UFTHVmfvjc1mB6EeaZIEjf66+FyTovZcqEA6Z3s9JJJZsC9bwgU1n04YGkh46AcuJ1GGAjBRH1BcIBynBwiPMDqz0qaUJ1lxnhBA8ykVOrQQbTIbZ3m696KtPKS0QXeiNiS2XHD4SQcA1eaMn8WV9gxnz2U/UJVc1QS7U4kKYTJX27f2xiDsJa93X1fH13m2McXy6wuLRFFX5I4sWoFZMELfsoIVeTBuSjwvTtG4pHdDptLMo6Fm3WMEHWKaLqy6wVbO30dV0ihSB7r81byLmxfm3KhnB9jiFGDkAB3eybKje/tJwgJ/KeffQbE2Tf0Chy8p+9Lx8mxGCXSVCu5KwnFCjn2JR0I1VzuHbXTJrfhkeDu592qCeEk+qooB8wj3/795/KbOF+L+Ic0HJl0oWuHP8DpYbO30p2zmesSTQHAJrmiKynyrIgqtJDtIxrKFYJVseNb1x8WBoKHItkmJAJ0Rit9hoxqPBR4GpsoPdoKvJ3uZbar8UrOwzJDSaqEyUSB6IWNXtjVmbAZCoGoRATuT54zg3Jfua7Cne/YUPbZLWFIDN9CXcpVKd5WmWJ6aqLeyMsBwQcReXm/1Ju96K0y8+8gQyk+E++Y4m8WkEWsDfndCTBrPYK1Hgcbpdt8IZSMs
 d1MyzcMr
 zZxpF0KMOrg8ZofClf3OBo34liwAaj+0dLGWzYDvGn+DucBYYPKqWiPJCBlTlV+nTXq+O9i/7OoURpYWU2C3Q0mAQdFyTGQEPzOCJsJAl8VGrFi4jsZh+d5nf/uWUYRHYtnxepnqDvGR8mMWno1+9usWaBAurhtGorUBHlgwUrZ/pJ403gsc3NtI4yB3xaIScqi88ddF8itL3qTFZpGd3nH12o+Mzt7HaBsrazNxVserblOYYvF1y/SH3AXSQ86h1hp2XdrEKV8g0wOGQy4UcbRNGenw/QmNDUIaBm/1gGAScqf4zm5qd+WBri6aQpkX1oznPrcVhuA0QOoCliQDGcdlg6TrZfU556TT/W1FqxEGG1gbFIINy/UplVVi686S1OGCNM2uJMtrqP0awFUzVTheidw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alternative assembly code may wish to use an alternate link register to
minimize the number of clobbered registers. Apply the offset fix to all
jalr (not jr) instructions, i.e. where rd is not x0.

Signed-off-by: Samuel Holland <samuel.holland@sifive.com>
---

(no changes since v1)

 arch/riscv/kernel/alternative.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/alternative.c b/arch/riscv/kernel/alternative.c
index 7eb3cb1215c62..249ee55d05475 100644
--- a/arch/riscv/kernel/alternative.c
+++ b/arch/riscv/kernel/alternative.c
@@ -121,8 +121,8 @@ void riscv_alternative_fix_offsets(void *alt_ptr, unsigned int len,
 			if (!riscv_insn_is_jalr(insn2))
 				continue;
 
-			/* if instruction pair is a call, it will use the ra register */
-			if (RV_EXTRACT_RD_REG(insn) != 1)
+			/* if instruction pair is a call, it will save a link register */
+			if (RV_EXTRACT_RD_REG(insn) == 0)
 				continue;
 
 			riscv_alternative_fix_auipc_jalr(alt_ptr + i * sizeof(u32),
-- 
2.47.2


