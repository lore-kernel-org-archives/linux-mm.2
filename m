Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF560C83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:57:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 842A16B02E0; Thu, 24 Jul 2025 09:56:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F4ED6B02E2; Thu, 24 Jul 2025 09:56:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E24A6B02E3; Thu, 24 Jul 2025 09:56:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E4A06B02E0
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:40 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 121E01DA939
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:40 +0000 (UTC)
X-FDA: 83699308560.17.6132822
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf10.hostedemail.com (Postfix) with ESMTP id 25C50C000F
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=RrZJJy6H;
	spf=pass (imf10.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.48 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fX4Svte8gqoaTLJ1gLDVO4a7qJdtBtTgEqouOAtsRZg=;
	b=vo3GfC9ikewApaOTE2xE8wASJMNSsDqWI/+y9SpfluhfN7qWW48xOvAZMz8eWT+yMmKj3e
	EvEEIAG58P57HfFYp3tEjGIboaADoAe9sujjw4/6xDeQxLLyXtz0GFx5phpoGd2h8W4slO
	MM24CsVno2Tm662VQyFZPVfBoVDUHgs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365398; a=rsa-sha256;
	cv=none;
	b=GBKu8lT084TKBQlwgjRDSSB8fcj0WyIxUyXAI9TwChHpQMRTKy0FwHDPc01ZHqj9etQJeA
	7glUViZmxiaaU/TjZy3p5dguaMQYrkAYYW8qNjEyASwL7aVpXnGM4/UCnl0gT3yfuUkh5N
	O3lo+bVlRFmc22fr4thTj0w88iJqFXQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=RrZJJy6H;
	spf=pass (imf10.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.48 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-45618ddd62fso10931385e9.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365397; x=1753970197; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fX4Svte8gqoaTLJ1gLDVO4a7qJdtBtTgEqouOAtsRZg=;
        b=RrZJJy6H04nAt/0RURYmTLOVshRiKaVWpDcDLhedKaUzUh445Om+k8oa+FKzruAOFC
         AtN7cIVaoUK2bQYqxikKEXwyIKCxhPnN5t4dUt9g4+kbVcAeoNKvH8Kkp+tc+I55fC3r
         iKYNQcrM6vKfglXJheQtJWEcipB9Hl9Mi1f+nX6EKKiC4zDcz5bRW6jbT2TVJSWLS58q
         VWbOtB7VigITPYXVJ9ffIGQhTCGfC6WQq5UOOrHT5yJ/xz64o2a9qHtlwecufk0elTkJ
         xlh+EmhVGRE3VlfjorInboxc7dkKdKGUWPb9k70RV1a3b+oU6dJBul5la1ehQtVG0wP4
         NRmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365397; x=1753970197;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fX4Svte8gqoaTLJ1gLDVO4a7qJdtBtTgEqouOAtsRZg=;
        b=bZs1/pCUypMj55Rw0HY1dT2LL5r40dm3+zIvVixBioETGWP6cYWBeZnIPBbocjHy7m
         dkgYrlLiflelOzJMRVElVUG0cSIWQNNotTkJwwMkIk/ZnmtQNZeYeEuwYBjqQ1Y6DyKN
         TnhoICdbl+N9VNtVz2LO9N0Sx5t+1yyH2kg+PkllelQtsm1bp/Ei+iYa0LWW+IdNuGxU
         HOc1VC85s7u6n66TeTq9WY5IV1BnNYbmv1qstzh+ouw0p9BNgG9n4l9FPued0o9qsOlY
         iXThVC2RubidZ/hjk9dGdap+y2Gwt97HeuG5TzTIL9QcNLqdZpufZ7a2V7VHeMwSXC1K
         r2SA==
X-Forwarded-Encrypted: i=1; AJvYcCXcn0x/g3zpLoDBjM4UxI8z3cQTZjcrxY3f5CP59RMnyL+PrzeyLxUqQNvFLj6aT00BJBmMnskqxA==@kvack.org
X-Gm-Message-State: AOJu0Yw2t4BpVPhxpp8peUAahQfue4a1vdZTVxWtt892cnl4W9Wgxatl
	TAUxQ0KXeiVy2v88vLUa3CyXdzzNJCPgPv+XY7emlSEVwfsEarttqbx6ZNDtNv5xOO8=
X-Gm-Gg: ASbGncuVyz+PzuFbnyVsfaHKPvoRx7Gzud2QfHHHE+gxAIyY3pMenIZecpWcXpQpNYG
	gkW6vJLo3Xvk5w31n909Bsxd+sptDVO4G8yzT3UxM5fuMEOeidynTZHvzq76dvQgOV/U2jpIIwn
	4TH+xMxyIr9GUjASrNr9zWYldWe41JjE9YpAjpkuxtGfsboGm0Zzmbotz4oaOvnkVKL/jgD0YOj
	Yh32yCICuMjTsYW2Wazan5R4cyHPk0QaksKivDjxH64vxcoPuBhZbwxvWI5BdRi5PRDTdasdimp
	PlXBOciqyFvHpHt0BX2Rwz3nsQJBTMvc/f6AnhNXBw/qJbAFjTHbtNi0m769ZSnRCBEp+yyy05U
	QNc18VVwTpgArCZuhb/MC+0L3oVvn6xIlvdL1y0KYwp3waZAzWTX2GdxJd2sWmlc06tdhMrMYlU
	Dgo5voZ33aL+wEYmCnvoAPHtg=
X-Google-Smtp-Source: AGHT+IEQVvnmK8e1EDhTYEG0c9433X/scuppejD17sDlP6XiymAvLgXWbUNkWttS4mn1l7PUSu9quQ==
X-Received: by 2002:a05:600c:6090:b0:456:18ca:68fd with SMTP id 5b1f17b1804b1-4587118251dmr22564675e9.10.1753365396747;
        Thu, 24 Jul 2025 06:56:36 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:36 -0700 (PDT)
From: Eugen Hristev <eugen.hristev@linaro.org>
To: linux-kernel@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	tglx@linutronix.de,
	andersson@kernel.org,
	pmladek@suse.com
Cc: linux-arm-kernel@lists.infradead.org,
	linux-hardening@vger.kernel.org,
	eugen.hristev@linaro.org,
	corbet@lwn.net,
	mojha@qti.qualcomm.com,
	rostedt@goodmis.org,
	jonechou@google.com,
	tudor.ambarus@linaro.org
Subject: [RFC][PATCH v2 16/29] mm/show_mem: Annotate static information into Kmemdump
Date: Thu, 24 Jul 2025 16:54:59 +0300
Message-ID: <20250724135512.518487-17-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 25C50C000F
X-Stat-Signature: mrgsdxi9irh864q86k7ss4hyrcy6cq1o
X-Rspam-User: 
X-HE-Tag: 1753365397-185056
X-HE-Meta: U2FsdGVkX1/K/G4O4z/7HOodZG0PecB222r8oi0PZjLhQgWL6wL46TQ2oQZEwfzaBhiDlRs+AuVDANFdIhrijWv66EVmxcHkqt/9Iwyun518liMa+lFfAJukj6b30JDZ5mQz1eNlOcw41CfQ3xTwYiNjyx0U+N2Cx/hzsldcGrSoNeuFIUn1ClKy1/LFgLy1tDvEPm593RxHElUqhN/PkXqPy4+hmqY6bqmjWjaklF2hAU80SbHcW8ixToPbcOBNab9yzHuXknnAiGUPsN4QWDzrCC9xiZfHCqTEPzQHjuxABNxStbKb8Q1HLCzOKI8a2CWPXip+C+3d9KBcRHMEYKX/yemuJC04X7KC57nWD2uEd4iR1k0CjNrdKRF2t+x+g1h9YlJoOGyP4cfuJ6CF9QB/ZqwbL3iAH3Fb1RJak+AOTpbf/ROArv9jA+bHQHDIPhnl4RRfZtwEVtjFOBH+xgkNAh2hAk6z2jkAzSrMaa+nRFhxMLv4aOTZGQOjaojGKm2EbocpdWSeAVZtZIwcoiz7H8MzgqQLfov9V+ZLZHDW6Q9+5ED+EGcFVnoFVCI2JUX3uvHPESl19O1Nvu44uTTE7gpaEGwy8abZPra2np5qeIojxOzCOYAU/5Xtmx3+fpfvmj4aemyToE0OfSeFLWPUINigL5bciaw0UCS5S9Y4lTRP2G6bCzWy2+0ds1Hp0ooO+2DAjwV4C0DZ7PPirHgGGZDWcHyiVD+dPx69c1aUhVpfGJKX4l/KQQVOBSQeVNr5A+kXFxC1bQAZA9Wt7bp/037acKDLXEeR3KzNR3B1rMQZvfRcQB2vriKawmWwupnHgkwRpfukf259AH3nv/L+bou+mpJvii/WRbza0pGdNWZQAlNSLU3H2mK5Z4XefNAgVKrZSeYr15mWloMcAAJ6Zh3qHvJcU6g+KHw9Z1tcY7z3lRobrXaFEQXfjCv4OyIs9BiYZFuPEfXZwVV
 mdIHFPQA
 yYYVaFcSHuo4ssgUXnBPztRT2XPbQ9hGRA9gUD5r9DN73TLtC2LWLT3RzOv+IcqFMKKpKyDygjT5leN7qaeBK9mEZD4nE/Oe1cZrjt45QKW6aFGpDBSgj2uQJBVcOUgtZG/Ue4MY0C8bN1VaFCUJORfmHMbTP3wFOgUxDBOxk2AVTGCdLlK7YYNAPQYqVTCxZcLDTlfdf/hctNeh9+A+4ObUeo0P25cCTKPp6298FgZWB2TtjStkHwTDpTyaRw90Z/E8YLOCf8uDWZBafh3xBF6NxiuxSiS/kL4ox2n50Xd6zLO4iuIzcyZsCmEJca7uw5Mbo15K51XKLguUF0GVNg0FHEPX2H+OyfwlVit7tYG3T1e0Sd3KTBlPkX3jnV5ASeib8j2/kHW1HCSVaN/2Fv2Mu8BZLrXZASUEbXg3PU8z8lrcjhNNr7dNam16Gjg2n0P/g
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into kmemdump:
 - _totalram_pages

Information on these variables is stored into dedicated kmemdump section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 mm/show_mem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/show_mem.c b/mm/show_mem.c
index 41999e94a56d..93a5dc041ae1 100644
--- a/mm/show_mem.c
+++ b/mm/show_mem.c
@@ -14,12 +14,14 @@
 #include <linux/mmzone.h>
 #include <linux/swap.h>
 #include <linux/vmstat.h>
+#include <linux/kmemdump.h>
 
 #include "internal.h"
 #include "swap.h"
 
 atomic_long_t _totalram_pages __read_mostly;
 EXPORT_SYMBOL(_totalram_pages);
+KMEMDUMP_VAR_CORE(_totalram_pages, sizeof(_totalram_pages));
 unsigned long totalreserve_pages __read_mostly;
 unsigned long totalcma_pages __read_mostly;
 
-- 
2.43.0


