Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F94DCFD2F6
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 03:13:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D14B6B0010; Thu, 27 Nov 2025 22:13:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A93A6B002A; Thu, 27 Nov 2025 22:13:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E56B6B002B; Thu, 27 Nov 2025 22:13:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 816146B0010
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 22:13:05 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 50748B8525
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:13:05 +0000 (UTC)
X-FDA: 84158544330.14.E79B331
Received: from mail-pl1-f195.google.com (mail-pl1-f195.google.com [209.85.214.195])
	by imf30.hostedemail.com (Postfix) with ESMTP id 761FA80002
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 03:13:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ncfz4sEn;
	spf=pass (imf30.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764299583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kGL2VMPMFa8R+g6JKXrGDSEsUVYbVq9e7DRPdheTEI4=;
	b=nWvSjayWHp1MztunQpL1jd+lu6Mdy0NdI7KWfWT34xs6UhLlyZMhGGLY4p2rXQ9TnN36+9
	ECFlY5ffhYiSUvu9nMiE55VFfdDzEYqXI/Rdlr8W0ibqn4RJAlDv01db0HwCLCbofUqyTV
	+iNrgOo45Edn7pjvEOz6vKt8EUppSjg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764299583; a=rsa-sha256;
	cv=none;
	b=mFKlLU76DsMHzLJ7SGFEKpQTMYJr9BhzTNvvzdwiM/bGvdhbSKRz6lgG5hLk4JqzqDceMC
	dwXoBFceST6dIRoUw5BRww91z4SjAr4A85gmQaifHdeuq8L9GnRUzbbBtbPqV6WsJnfVlG
	dou/4c2YsLXbOM75r78+d4D/SFXnHck=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ncfz4sEn;
	spf=pass (imf30.hostedemail.com: domain of zhanghongru06@gmail.com designates 209.85.214.195 as permitted sender) smtp.mailfrom=zhanghongru06@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f195.google.com with SMTP id d9443c01a7336-29555415c5fso16906765ad.1
        for <linux-mm@kvack.org>; Thu, 27 Nov 2025 19:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764299582; x=1764904382; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kGL2VMPMFa8R+g6JKXrGDSEsUVYbVq9e7DRPdheTEI4=;
        b=ncfz4sEnoSo5tAh6WGjfq7PIdkzEERjVo43gy5HG/tFubULCS8x6323CHCBb7QJvXS
         hkaqMrLrVs/0NabSsKSSQi+isS+3Vxx0MtP8enC3WQh53NtPOYEy63h536Rq6i81bG7s
         U0tYnMck3a72Y3vN18ovr9+f+3ZSHO+1WF+CQ4tF3hpFucKZ6jVFxV+To42BIsUJir8+
         oH5c+b7zNWJVexl8SMmRGAQrq2MYfqTEDu2lmfGQn3ZmJwCNUw/eHc8zpYK+mDtosCH0
         xqkiTcEVXB0bj3T18txbt/YdaHyw4zgcAq3b/bbYn0XfIxOwHodCEUO0MnUypdim5YU/
         qQ2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764299582; x=1764904382;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kGL2VMPMFa8R+g6JKXrGDSEsUVYbVq9e7DRPdheTEI4=;
        b=rHzMxSG47nHkvoMePi5vbrjL+P/EpRQTxOz5sjAxM02VM0fU01s5GEPm2gdq9Vax+Y
         Ml1P5hwEMaMrSUx/XyIQwwyC1npdeHHDOAeDjLnHrtp4Ln3qUiCaL0DdhDZ4Y+NrXJh9
         z3Rn5G+qzOCwaLD6QybITn2bLDh4GKhtsSFd8Ucbz9MP+LpVMsHHYX9PCcLHPGrGIbNS
         cdSZxix6U42bPRe/NGQ9xcaUY9Xvtt8r0gOcwRKcnUN+ynue+goKvRdmvW/C0Q2Q52fd
         uwtcwbu0QiUM0b5VSfIlEVjt+XPbyJSF2/i3af6G2vUFpgCDkQvVp7UFGpgYLw+I5h1G
         vfyA==
X-Gm-Message-State: AOJu0YzhhqAqFDDGtvKnBJAsZXIrbzBl5272+A/pc7fGJKmls8ziZ4DU
	X7EzoY8fTE89XkhnZZBWhaENrj7T8GoqFjs9B9bKWpXVRNHD2mQCy9AN
X-Gm-Gg: ASbGncsUv0XKfcGi6mJxGHvk2WNs7swpgtFxxeb7zOeNxB4pDQx6RNSKCqocXQm5SCT
	V9xGy+nLwvRsThFlMeVnnB9oZ4rCza256mm7He9czng6aKUFyw673/ZWOFfApKP3wEmYxjfcGBu
	YGI7PjZ63Lcklp5X+27ga1oGok/E5Que531L1Q6QkEcWu1oHTjXnFHsjPcqVWXhYzLgrai/v/mC
	AUbSBgOZF63cP5PAx+gxIGxMPdN+j07nG8ZUWQ8xESGeyE0mVncx45tXJnvvRbNWPK+ISJMqcHl
	FSNhdHaQrVn/j6CJnFajitd6eJhwaWVWwASyj27+iLB9WtJW2pbrglS8NwNP6rtfIOHSGizGIIw
	lEAkrK6m3B3CdrWuu0xZBEjDc2ciQQDiQfciLmzzZ+iW3H2FIc6xJ78kqaaOJ/aF5k1tMeRiZkl
	DsaxTrZ/fo5t9aHDPx6p3OLTGRn3RuB0P267SIaw==
X-Google-Smtp-Source: AGHT+IFO3Qtu6YGB56UoXogoMpEAtR4mV4R5vs3RIIh4n0plscvgAihdnr/7wFahZAc/A1wHqxqldQ==
X-Received: by 2002:a17:902:e545:b0:295:8c80:fb94 with SMTP id d9443c01a7336-29b6c6f1516mr261806555ad.59.1764299582259;
        Thu, 27 Nov 2025 19:13:02 -0800 (PST)
Received: from zhr-ThinkStation-K.mioffice.cn ([2408:8607:1b00:8:3638:7863:b439:f5a7])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bceb29fbbsm29576855ad.49.2025.11.27.19.12.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Nov 2025 19:13:01 -0800 (PST)
From: Hongru Zhang <zhanghongru06@gmail.com>
X-Google-Original-From: Hongru Zhang <zhanghongru@xiaomi.com>
To: akpm@linux-foundation.org,
	vbabka@suse.cz,
	david@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	Hongru Zhang <zhanghongru@xiaomi.com>
Subject: [PATCH 3/3] mm: optimize free_area_empty() check using per-migratetype counts
Date: Fri, 28 Nov 2025 11:12:42 +0800
Message-ID: <cd98e89b8b609bd2781b2d24c721a59feda83ec8.1764297987.git.zhanghongru@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1764297987.git.zhanghongru@xiaomi.com>
References: <cover.1764297987.git.zhanghongru@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 761FA80002
X-Stat-Signature: 8gt8k9ex4snnu9nkwc1z8xzeomxno3k7
X-HE-Tag: 1764299583-510198
X-HE-Meta: U2FsdGVkX1+XFCLGpMmg8qljLC/kWoAFa49bM431Xf93eQ50/ZMHC5ppYexU14IwC71Q6gchw+v/GH3tyksmgJ6o02/AXaZu+S7jpiWI7ukbFBxEUg4mFSCtJvQV+CnxzIq8ynUZFYLU1o0qzXALfYo2PvqNbHG6vFJY/PvIvDpGRrZvpIWGPZQo1mO68BVua2steS58wo7e1gdS7v8zRJI84u1XjpdWzy/Qq5a4Z052TD5wkMPiM8VpFRgSNv+5h5wi9GER2npMI7GvMJf21nb7NMnq4CNyiGsnf5K/BDAZOMLDIUoaIJAS0xqipKEYpHv59IJ8sg/4H/CIR46NQNsQ/9G/6O1dgsyr1Yk4B1PyAltsbsEJL2yCFsyj3hwYvu/zAf1KJd75/QlxcDmY9z5H7JUiPBVyOTKT3M69ObB2oY+IT8OrhVL5S/YimuSX3UYU8k1FGUdufYx2L24xdalmxgtrVDOKdV5Hf95j0+Q/SgUUFTI/WPdCdMxlLUF5n8KKk7sNAHuXSYzUisVVamNbg1L7AoOPIE35xy8Q4JPJT5ItvL2q0hmEnWzJ3qMNzHpA5ARt5qNXW2Xv4WBCd/UIfQRG5H+Os0AW3+IDvj3VpgVFCt897tu76/SFDPfQmquQ3+Y8UaW6BuA7tiNmsd4Z1VWCNnR6AREI0W7WcvrCt9uR9dTcWZGpxgIf8aAnDvd+KjQjMx291EAi/1/Nf/gJ1/ttoIqMJlooc9IvIMTiKMu4qw0KHoGmwT6wJkmyQUh2FAAUHxyeHVIkQ2ptqIJviC9I/PWjLMJdlTO34x+zCqKibDeKIozX01NuzQc9Dh7DcDSidzaVks8aTHW/jNEqnTI1v1zprA3cHsU4VFDD+LjWNHZg9KTIahXmVBJHjXEjhscXIfVinA4Moqdwbn6E50OFDWFwBHiykijRse7lRurdq3dOgBOADCoA7T9kd0Qb4APlV+3ycKwuzcG
 f6uKbb7U
 pojY42SXSOqmTRP/etPFwV383GAZwUf2OD5fnMHzzJEgSqKV65TlLQJycTQ03O0VLoSy7IdUTxfUgRqHjX2EIX4arkAJPATP1z0fKo97oFAQ1hGotrmNOS17SxeObwOnOIdX6w538XxPPazDrZFV/NSfbgY7roH7QAWeEv45Ta1JMr+31xf+VhmgKIvQ/+PHkz3/V06gQvYUXqT5sETWBcNRY4Cthzdp/ieVHWQmjSv65apNjPuxEM1fs6EFMbxqQzrftF2GG42S71PI/SKCJz5QH3dqgCMZgNsEKnVAEtl5w6xkY8iebx8OvF7wVVHCSxd+50W3hxYx1ZRHcP7VW8Z0WZ8QlJiNrdVlEK3ctRErhqnfFoGLaSrsbpFFrbUW9BSa2AB3vXjlBvF9JQ+c2gzqoBIorwQYoMa/WSTYTBW+/Iu0DIYjY7kga6JaXA/LYI7lUnmvmBl9xeK+wQUh/uxPK0iipq4tAgFlveYyv7PGWA6Se7NJRq5gtOOSzOBRAOR/8ixqSWKraltnONxqBOwEzEn1McOXIQF3R0rQKEj9vkBpgM0h8/bMNjyuxPhE1XAI/asC3yIoIJnE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongru Zhang <zhanghongru@xiaomi.com>

Use per-migratetype counts instead of list_empty() helps reduce a
few cpu instructions.

Signed-off-by: Hongru Zhang <zhanghongru@xiaomi.com>
---
 mm/internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..7759f8fdf445 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -954,7 +954,7 @@ int find_suitable_fallback(struct free_area *area, unsigned int order,
 
 static inline bool free_area_empty(struct free_area *area, int migratetype)
 {
-	return list_empty(&area->free_list[migratetype]);
+	return !READ_ONCE(area->mt_nr_free[migratetype]);
 }
 
 /* mm/util.c */
-- 
2.43.0


