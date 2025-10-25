Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE0DDCCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 16:41:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5BA98E0152; Sat, 25 Oct 2025 12:41:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0C8D8E0150; Sat, 25 Oct 2025 12:41:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D220E8E0152; Sat, 25 Oct 2025 12:41:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BC6248E0150
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 12:41:18 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4C9F81DB1D1
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 16:41:18 +0000 (UTC)
X-FDA: 84037201836.23.9830373
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf04.hostedemail.com (Postfix) with ESMTP id 762644000F
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 16:41:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FVxTWDIs;
	spf=pass (imf04.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761410476; a=rsa-sha256;
	cv=none;
	b=ZsAjP3T4NvDgjQpo9vKxImpIIcuS8Nk4EWNfJCk/vBOD0OWo+vDkQrBhZnEnNgn1+kJSuv
	//Fgh01Vc/JLlv0Si0cnK94pzQ9ow/R7bB08HacSfoDhFscDr+WcA1iSc69YWPTtZM5/sE
	lEq1QGJC/cpITCbYi/OzJRUuW3q9mZA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FVxTWDIs;
	spf=pass (imf04.hostedemail.com: domain of yury.norov@gmail.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761410476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0GldqH8fEtUrzkHne1rF5BgiofNp7hGD1Vw1w37mqgw=;
	b=REeGjnZp0pSCUjH3YYjlwKaKBhkpFP+X3ss36SUIPKC8LYhnphjjHng2/mWLSaj9wc3ID6
	WnMqf59Ja5intit8+/by6e+RTTONQUdpfjlS9xq7z7AtHLjmHGVszGpe09yHEG3FX9FBPE
	hNi6BV3xNE7fiiTBLA/Tn9qc6+pvumg=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-89e81dff0d1so164302885a.3
        for <linux-mm@kvack.org>; Sat, 25 Oct 2025 09:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761410475; x=1762015275; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0GldqH8fEtUrzkHne1rF5BgiofNp7hGD1Vw1w37mqgw=;
        b=FVxTWDIshbglheHBLF+nOxz3Vs8kIiJOpBmtu8pJRy9kIPDBxcOy5q3+VV1Di02Wjq
         AchLPJ+dArVuAzVxWYH5R/hzXcYJjwdJn8xhuQLxAf1Y5ok0MG+8ZUsr60HhLrh7u6i8
         4gRMtkrBWXSIZs8EFfws/GUGmbTO8MxoAcftPlEmSmrp32eUJ5zkalSxRR9tgPrcfpzx
         JrNxH/dMce8+ebtVlv6v5ncZSNIqSbpbOROtMxY5ZxLTzEgqRhGKZhwUOJR4g9taPnBO
         Ea1nsgohZBZ8mhKrVHDv7omJXfjVICZWZ3weo8YcyKwTKchebXaL/51gWka5US36F9+D
         D4jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761410475; x=1762015275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0GldqH8fEtUrzkHne1rF5BgiofNp7hGD1Vw1w37mqgw=;
        b=tlvZhyNhvY3ar3+Q/gBWA7VkD+lV5sMspvVePPCIfw/5liwBLGv79aCR+eYssWVfPu
         LPCzkVPs6CsIGfNDJQET3UL5Nbi0jNB88iF885OXCklF/utbVIs8MLbQU4q9ulJ26Fcf
         aIWOXJPNcV6i6QXUgHHiOtYAEtIJiAuKT4+E+92e5YvUs6wwLgLmatRDfTdcABJ9aRLc
         FREMufJAaC114RR1LdqUVrIoOgrDHhjZ7mtvYY2PS4z4R4MqxjNbN0KiN27sRDkpZV4x
         A+xeSJUUwOsXZfPNL1MwV+odImeefFRoBlvbMfOUHIilvYXJQWjMdM3xNX04bFKsV3Ah
         Nn2A==
X-Forwarded-Encrypted: i=1; AJvYcCWoqsBI/3pvz4/kArD2gAf828Q80G5dIAjq/mbpyBTc9+wTC4fN1SvBnfujzqIjbz2Y7Dvz5ExIhA==@kvack.org
X-Gm-Message-State: AOJu0Yw4oYI0Tg88EpLEjurTy1Tab275ltG9YoWsWx419qIBf2elpexa
	EBR3R+TmtlW1140P7MIPYZiIhz6tSOBveKdis1c9+ot75TC02HLzwv6P
X-Gm-Gg: ASbGncsfNVszEXvS/Bl4LqogCiMfnPPBE7lv5fnillSPJln1Crj7L4LjhOFb/zV3HLb
	0Vzgt/TwcwaFAPm3eEs9elsZO1IU7hSaet/0AygbzQzZ7KYsli3c4o52Dq01BCfGzQQnfizYEU3
	/1LB1PaNa56yQdxvhYvZw8wKObeyJggSih5aUxUt5MfC6bkW9McR64uscQQj3CD509emWwYE78U
	CJQShyLCPp6Fm0RMi9AI62FxgvuW72PFKaAw8TPrWZhM9RKTQyagP1lxc0hRXjtID2xlbFWARQ6
	OIm27EJxEQt8sCv0Jr3fCLzzV0Zy8RBuHNbo8IuLRrcZoe7CcooIApP6baGJG37rWOJf7WX2pu6
	1J4xUxctp0u2f3AAn7LeROcBiuLhMQKV3UK50fP57jmlHWXNIU8lgVt9tPQ3g4rS4DJj9SHVqyX
	BH1cB4FI4=
X-Google-Smtp-Source: AGHT+IGJ5EoIFI83t52hIGo3M/2FHLwpmX4KGwa2Lw/NwuS3C1UYigsffJIqRTq4YJBeHeKmK7LHUw==
X-Received: by 2002:a05:620a:1a0b:b0:88e:991e:cf2a with SMTP id af79cd13be357-89c11e631cemr1286912085a.44.1761410475508;
        Sat, 25 Oct 2025 09:41:15 -0700 (PDT)
Received: from localhost ([12.22.141.131])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f24cd5938sm173525585a.20.2025.10.25.09.41.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Oct 2025 09:41:14 -0700 (PDT)
From: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: "Yury Norov (NVIDIA)" <yury.norov@gmail.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 17/21] mm: don't use GENMASK()
Date: Sat, 25 Oct 2025 12:40:16 -0400
Message-ID: <20251025164023.308884-18-yury.norov@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251025164023.308884-1-yury.norov@gmail.com>
References: <20251025164023.308884-1-yury.norov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: cr3gczj6msmz686mwrnkhnz39rkadir4
X-Rspamd-Queue-Id: 762644000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1761410476-444942
X-HE-Meta: U2FsdGVkX1/b3RvWtDzwOhvsqQZ9BW6QRMUNC7Kkte3yJEqQuxznWJEp9QHZuwJGBSUA2/xe9ijrsAVicDRQLmUfUkmgKorbUq+3/0K6pNsojeYiHrr7BGWrZ3I+1Hf8YntDYZrims4huwbmCrGFR0/2C9m0xLNAY5HoqtWqOLZqsvIxFkUIiLKlZx5x44R5hOohcZhKp0h1DYNftJJDPrI0trIDOz4D7MsdJVWq7pgbuOIp0n7dzALcZis2Em7zSqubkkioFaObDkJLBAlVxkKmEHaizeH+dX92xUNMFUp//CjEaWFBjD56kspQOU3JBIjX4q2ppN1Q/0EJI4OFFwfHzrMsWe5bvADWSmkPx5BPrDHTq0cOSScXheIy94GYvafCsY5a8KMXbE37p3N76ucPHlJl3RCZ+KerfAP4Uv/+OqMBXMg7RULUQuYvaZKuIq9JRwaaBe2YQ/Hg7BJNLgIMGsvb4J5Vji9DMSks5TmJpWHAwq7yQFyzmpX9n44tR4Drkl57Io5G55NpJWz33Sc8qHQNTcH7v30zx8Xp8saDzhi0gFBDzgBaBQSq2IMlUmwftwufC43sn1ueg9kKA3cQc4d/kAtLc7Ob/IKirgf/ulCxRpnMAIRg7mHUNf7/QVwmrcvXrU+1jn7vDqVDtOt1ocjaU3cEyLoYH5cYkpzyjKtC017e3UJpgT+7V4/OtXuTA2MnpuYcBW3tcofCeb4ZRW8DIS3biZMdNRZH8pjUlJ/AK5xllO9yG9IXqsXGctK1csjwW21YL6sbrj1yhfLXzJRnvOYEVeAHcl0PbO00jJ7fgUVSMrvwIWen5zR+vXwQ+75YCDxdHv6jnI+G4HQsvIhaW6GJlNbhPO0Gb13OIubMNFX0aIgjamVHkCgTjnVb0CjTbDtt92Ra3bDU5aFYttgkWXTk3vHoia7VzAi+t6mWjRpqQU8rNXoXHnennMTXXtuByhxYPIzY8fE
 DbmvM7t9
 8cWp9R+trbDGtKMM8eRU+ERWc0oXZXbNl0VjdWJWycYOeelXHCbihZZOHZ7yfZ7973B/zKjzB/kusKhw0Wo41bPrXLJEWOZt9q2kOP3KD2WMTSkvkQrW/9fmp4Nm2StL0fdegqkF5wRW4YYUMa4FwAJy5wUXHgCtuYYJm3oX008pWmByURuoqw+YltT9hQ+SQitbqSMEdYZWEIeFEGIj30VYnGMoCAM/gxbpmT7LfoukN69Pi5n3fWYUiYicDsZvnE3LSPK0AEsncZS32U51r4Oux7rWSPosHGPBHYrQ+emsILtCnoQKcbgYtVcX+vWMmcGIL+kS26x1+tsNMQ/eKP2d7jutnLvE7fQrJUEcc4OC8G83vrRLMbCxLMjl+X5eLkPjnDeUJiqVLR751AeXgrGJ/J1aluzlzbi7N1Zp8QH+2uKj8PvXUtyWeRuf+x31KIcHzmM+ZYnMkWVs+DE/E14IXlyZUd1hFcHHUwTVIUJOSR2GkNYbCe1+aSZxzz6ocfzBbgfLb1b6hxNTOp7z49kyJhAMu7Ie62RjbZYmB6RpRNE2PAr40tl4ZnpwJXp/K33c0+I6w18pvBP6B2RnzX67UQw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

GENMASK(high, low) notation is confusing. FIRST_BITS() is more
appropriate.

Signed-off-by: Yury Norov (NVIDIA) <yury.norov@gmail.com>
---
 mm/debug_vm_pgtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 830107b6dd08..b722dc3c091b 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -40,7 +40,7 @@
  * expectations that are being validated here. All future changes in here
  * or the documentation need to be in sync.
  */
-#define RANDOM_NZVALUE	GENMASK(7, 0)
+#define RANDOM_NZVALUE	FIRST_BITS(8)
 
 struct pgtable_debug_args {
 	struct mm_struct	*mm;
-- 
2.43.0


