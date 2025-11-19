Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A0ABCF34D9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:45:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4F2D6B00B1; Wed, 19 Nov 2025 10:45:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFF016B00B4; Wed, 19 Nov 2025 10:45:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 952596B00B5; Wed, 19 Nov 2025 10:45:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7EE116B00B1
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:32 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 41400BA138
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:32 +0000 (UTC)
X-FDA: 84127781304.15.B82FF24
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5204E1C0006
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=bt++1kWL;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf18.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.48 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567130; a=rsa-sha256;
	cv=none;
	b=iz7JHEQaDc9bxBAQTrBEDe2Op65G3qbzfmmnMgnapc0zF8QnhD0mA3WDzanMU3wGtjhuHo
	hm1jENbeNLhJDbzwqh49+7ss9tRRdMXBECZMnbbUg0kZBzPSc9gHIl4qcZ3m9j8RnlDJLj
	Ci4sKaDNBfILKTxYnXaZF5zPcm6QQ0I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=bt++1kWL;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf18.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.48 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QgfZoRmCPzcZDOEfTe8kWXd16fGbdAbRWXioprv0N44=;
	b=bmHpdiKrqBCT1H+VY6RMKDCcObLbdxwxaHM1zSRG931XT0FN5f+c1GmtPv9MaUTVVRd8PO
	K3qku4JSrEryQ0qYhm+mA8MUj6N/HWai/29AmD4SXefbHrOsXGUzjHyBHOFV3PIFLDqfgQ
	nOwaAN4iJ5011So3uk0IsRcG5Xf98A0=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-477a219db05so25822615e9.2
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567129; x=1764171929; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QgfZoRmCPzcZDOEfTe8kWXd16fGbdAbRWXioprv0N44=;
        b=bt++1kWL5AYofmH5QGub+MvqOdJjvUSMytiZgSfonhmvM/LeQjmlXTtVMZt6AmrFUx
         X3hnkFXgfNqqtH7EcdQACvsF9nbi2pOVYpTb0WFqcPrE1g7Vgbdsxc2T49TZiTRsso0H
         Q598QneTG5TeMEpEIh8at1oynNTEktRE4iP8D4pFKN1zwukzDrzqb2fBco1VdimjQ0Pw
         TX0l7rr0nRS2E76uRkFP5A1YkLbaPD19yxsnfK6h9xck93VcMJh0JQFI96CoKFLU+iuE
         io9k1wX9HPIRsJj1HfgNmEt7JRCEN/oyUocAdiaWFnkiDN0QW9rhh4jy60043U8UJ9uQ
         jwMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567129; x=1764171929;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QgfZoRmCPzcZDOEfTe8kWXd16fGbdAbRWXioprv0N44=;
        b=NQcyUDQfVVGcIz6M5z2NAwu0lf6zddtZvN+CMiQ7kDmr+L/Ley2Jh7d1flZL+j2qJ5
         tzrC5cCWwUyjuFAj2q3VTHPfY48pgaRGv/8Ul30RvZiQcOKZaMZSWSYLVasNzeC11sbW
         UOq4DtR9j8hXti1R1amR/w2kn1McsFW7YGIzvYegCVBW5QbBRo6FJKDHNLGvxFxSHZgS
         hpxqE/il6k3x7hHuu3hKHOchQLmHc83QgsgPMMxuGR5cXL4M9X6FHkthWleYeOGbi8Nl
         DqE1pPMMMPLPnWrjbjEcW+W0rQdOcX64tMW08asFAk2Fm20X/PyS4yq9Fve4tbyQhBzV
         d7+w==
X-Forwarded-Encrypted: i=1; AJvYcCXwX4PSoNsUKWf6KYH9F+MUGWBWfm8hPEuZoGHpNXSgiM/9ke2MQyiuGX3VEtVs95WY+/ZeK50aWA==@kvack.org
X-Gm-Message-State: AOJu0YyAOzU4k6zQunq9DxqBYMbWprJmiAV1biJHZt10aTEg85NNNROO
	+znSu2V55fJRS6RxDkxAX8LpPZzefSzqxgSElyLpztd2dIqnfpMi0A5vWwx94BwnwtY=
X-Gm-Gg: ASbGncswMIOdMnHpGkSyvHK0MmGZIbdd+qCOqhU9ZkDdq1mtOwKAFMgn+PLkCtwpy8/
	B3BQnBtphhrnHd6yCVBcs2cslTOhr09QgqAZPzUSfvPdcV4xBp+ItX32FDp9qRXSX6J1n3VmzgU
	QxIgHTLvleumtrFYSe4/77nFaOQBcx8/sZJTjFJJjC2d9O5DgJRUxTfv/bXuNcvmLK0ntue5DYT
	+3Tibe58vVSugiNcdwxW9LY/AKu42t7JlaZPEvnpFsvHl7wexlVGNoT2WWQ67yCXbWm6MNo2V5Y
	F5YsspkDSI8oeQ5UD6c5ljsOWUEe6l2QQKUMg2YfIpgkyZJSr+arEo93TExyy4qpqW7dU3T+LQr
	ZvR2yTcbczo8cFZIFLavU08gdpf8fY+Ft3F+rKISgR6o0i1y2hwhjRcQPQNVJpxBnOgHPW2TGl4
	4BKKpl0oKqWTcPxZhrQOS9xX/6GiMJ8Q==
X-Google-Smtp-Source: AGHT+IEsAcddfcsUUvEjJGVD9iD03mMaqDkbeYnd/gOudjAAgUoPc2H5D0xayvELD1uec3MJtxxFcg==
X-Received: by 2002:a05:600c:4585:b0:477:54cd:202e with SMTP id 5b1f17b1804b1-4778fe59a0bmr205474775e9.2.1763567128896;
        Wed, 19 Nov 2025 07:45:28 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:28 -0800 (PST)
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
Subject: [PATCH 07/26] kernel/fork: Annotate static information into meminspect
Date: Wed, 19 Nov 2025 17:44:08 +0200
Message-ID: <20251119154427.1033475-8-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5204E1C0006
X-Stat-Signature: si7ucnx3joq46yhxgndjhfmfc9j8qk8o
X-HE-Tag: 1763567130-265475
X-HE-Meta: U2FsdGVkX18UW4F2pWqbYTOO5aS5G5hnGjGTMeKvrvhEus17RhOndhiUadjk7H/KZPAowWw8VMt8qi9t3QMtURf2qi99PECRBlVL2wiBzhF8/XbVOJL733JI/70Nn6sOUtJVn9nE8QI4GWIZR6hsI+foUUeX6stnoZVJB0JAwanYYWdY/lexEcWHw9Q7daVDaob/39jHr1yJB8mJG6b6lpgnXBQ+bVzmk44QT5zUd9apJtj2cUVm8j5nkrUYo8DYZ1op3hBPsUgfXfaoqizCWrRPWPniDaauCXgIuxdM6h4z6d09jQcbHLwnCnVkKcapGhDegvILJxbMGwqvVxqJsdAz4EhoQIZZXNciSXqeY1s7HLkYfhHLG8Nxxrlmwxo2suQeTGUHpdpNt8SYVZxU/JjW9smi+ouB3iqZ+Z8jjFRNKo1htJpsFkkDJLjxojhLohIIr3tzdMBoGXPhkcTBZT/rch1HDG6aKkUcZtumnFhh+xMcqW2DPBTo5sDC1LBEWIo8Z77dfy9596MAOUoujgnaJ+0mZw09HRXztsS4p0zIQbVa4Fp96d4gw8u8DG/FRAVDWx0fnR6XlH+TOaZcyC5ICig/msXHE6E0ejViFN9dUf5vXQG8MJxHWAOY3o0WMbqF3UBBq4i8NQ7X+RO0Rp8OOONpBPvMSL/aQOKLbaFtw3ULAMwVLCpGnxX05SYhq8/VerM8wI3EP9bLR7OfJKgZ0dxpBVSWCRBgXrfh+GVCvlbmqCCCTdJzrlfpaviljc4XsVZ8hUWIpFitb3ou+TJ8vd2EfWPQcESgTqfo4JyFlBbtuBNz8BMpe9gX4jAHS48EImufQ0cjCW+aFpu8jw1lOty/8tq1Gjbnpi4rEUMYIXpDTq2GkAk+GxCV4vNgKosCafjSWLEa65ppXsv3lFNAqKDRM0wt+v/P9syhbTAg0eb0x8pwFHToZ+8KjuUnHP8msxLWrQJGmd6UzFY
 rmiCHGjA
 cB2gVl/g49BQEWUMVcDpqN8kUq9Jefh/TaleZ79XQwLwFKM/j83+2jbCZjE1WEa6JcQMoEm0EaFzR/rasVVMzE5GFShl4feav5KgRfEwNd6BGcFiTl5zkOUXSVjmviBjWCImDZqtzvJSSINHxBYwHM6oL0WJrdBW2F/LIPsC+vWyhdcK9maYDOrNChMnCGtVjSAvMaAnRNXI94nLy95Mbqk5q7n3JIP+ZLfmWd5MfGqytUB+odk0CTVR4vXA6vfYcU4ZJ8reSJz9z0sSqda3+C2tkBXIRVA1JaYO1yImbIc/Dh2OHHFZn2Xo13QaZ1PKwQcfna0drXdvj4xBBYJ3s2I1qsvFc+Q1BzaFSLh1kkuz3hw2kav8d2lCZ7LRHx9vY3xVpB8Hjotk0oIQWoCrUENY+/7A5MxzvenHt//m7UOh665i08hDhPw76G/ZH1FvcXMAscX2UwztojdA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into inspection table:
 - nr_threads

Information on these variables is stored into dedicated inspection section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/fork.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 3da0f08615a9..c85948804aa7 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -106,6 +106,7 @@
 #include <linux/pidfs.h>
 #include <linux/tick.h>
 #include <linux/unwind_deferred.h>
+#include <linux/meminspect.h>
 
 #include <asm/pgalloc.h>
 #include <linux/uaccess.h>
@@ -138,6 +139,7 @@
  */
 unsigned long total_forks;	/* Handle normal Linux uptimes. */
 int nr_threads;			/* The idle threads do not count.. */
+MEMINSPECT_SIMPLE_ENTRY(nr_threads);
 
 static int max_threads;		/* tunable limit on nr_threads */
 
-- 
2.43.0


