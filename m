Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 387D0C5B572
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 14:36:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01BE56B0092; Tue, 11 Aug 2026 10:35:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0F396B0093; Tue, 11 Aug 2026 10:35:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFE346B0095; Tue, 11 Aug 2026 10:35:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B844F6B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 10:35:58 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2A1EF1A0456
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:35:58 +0000 (UTC)
X-FDA: 85089237996.08.187FE11
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id 794A81C0013
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 14:35:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JGttuWvP;
	spf=pass (imf21.hostedemail.com: domain of joyetamdk@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=joyetamdk@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786458956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nyOgrpKJkHA8gAiY75lnj2+ioe7jla8qo9VP71q6SwU=;
	b=U2nM8f+E3nXotNABVUmFV9ahkU3S+FRW8KQOJCewlZ2HSuAEV1i73SZrg/kwg4i52TjV9L
	9W+sxQGDMfN/HkindiqFfKUdMtsdLbHWMPSXoEoXoZoH3LrSKBZ+v0tnOMRJt0SV8d1Dnl
	/RRanYWkUj0lTITknvel+9QTeUfmNv4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786458956;
	b=2VaIBZbbnh5duhzPJTueeYrqMhRKJOy7bh8GSAAaYEdCP7A36LqTpwjg9o5ysHVavFf+7C
	9wJsc7/0BPBvtEsglRnGHzGWZu09q0GDrtzBgC+gWUVlA6Da12Q8TPkptcGkZkpkItuBE3
	X/+v3yI/ESV98FgP1rl5BGEHCSGKu/o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JGttuWvP;
	spf=pass (imf21.hostedemail.com: domain of joyetamdk@gmail.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=joyetamdk@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4954f5e8020so16600695e9.2
        for <linux-mm@kvack.org>; Tue, 11 Aug 2026 07:35:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786458955; x=1787063755; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nyOgrpKJkHA8gAiY75lnj2+ioe7jla8qo9VP71q6SwU=;
        b=JGttuWvPaJjyJgpN2uOGYhWPIe+328kDw0oQBz30TkXhCcoIZNjlgXDQHaJEkEft6Y
         wzvBZbkoaBVvgX9D9ezWQnUEIURHozxIqtehhmKTOUTC7JHY5Uho7k01FVDD7uQkW1n2
         jNWRSwVxEJiYDmli5eKE3W96OoncPVsHNU4FpYGcxV2lhfK2F9HPswN0fv6VIcJY7Fei
         3TBajNnfw5uLpHguqCnBSN4z5pw8AU395G17kokzuNXN0Vo7OQOjxhHdFtFj8zPCdXKB
         2s7K6JnMX3nDq/YhslztiPT6GoXNO9ztFBeEGlVmMjqqw8clsEz436Kz+EIFOjc8wENs
         d+eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786458955; x=1787063755;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nyOgrpKJkHA8gAiY75lnj2+ioe7jla8qo9VP71q6SwU=;
        b=DM6/dxQyRyBoNt2iyk5s0Ykfl5te8EoubWN7NifMjNJUZKruCd0LDveTQDcU5EKJCF
         xbxDc34GdordmrWjb+yqfIWaH+XQYVxnYOBG6GEIQ+OZn7yTX32t3KE54NmMxXOiTqqB
         gmAeCMc42qw3ArW3/OfNPquS6WHEOePyEZsf68hz7yI1bqlKmRTcD5npIeFL7n4WgydB
         QcziqqNqepLfZaKYXx0Yyy6RxvE3Az8Lqv4gFE1Z2/W84NSUMRZ/08wmqaufGX8LQykG
         5GwgZhL3SUfoDqT9PKm6aEYauWNcEc6mtovuQmy2JJkOQrLMNxLLl2ofCsM3a6o090W4
         S6DQ==
X-Gm-Message-State: AOJu0YyZgNAJsKzTqk2E82Ac8Cf6YVn8ccZGwAWmBcYAagBVTcGKBC64
	LdkUq1TGUWyBeS/gcxDNQxwJ21xRuaWT18RwaHl1uVcMgscjvCoxQNXv
X-Gm-Gg: AR+sD13b2GRk0KjI8ELKS+U/keP7vq23XUryVhv3uoS+EX7xkS3mDujCits6jbGYw5Z
	n/ykWcnYhDyKAOpVRM3Htoi7cTS3DorCLYHswx/KUsDRxjBk2IH4/SsuYSMb6DucGvUzB8WKHBD
	DDznnQSWjE31EF5+Jfz8tK5dPitTn7s5mi25IUZ/0b9CXNqZ89dVOL0r9FM1w5gWEy4V3Lbt7NL
	DcwApdMkSnFT9ZRgkgZZfA1+JxMsO74hyY0tjw4J0uBb5IxLkx6EPMnuwD4OsT/FfyLV0wBZOGs
	zxhtzwm16muoE8bFruYosvORvARExLc1NCHF6wAnlXV2ZP9GEmuzLeHU7H9SZhZVM9vQSoft8TM
	qBCfOsz6yuLiq2UL+btcfYAnj5xqUDhsGjOSyZXzbJU/A5Hnueo0n5LviqHPFB356hdncIQNpwf
	b6QT8SgndHkQDxf5xfW9hPS/MCI6dFtbkmeWyt/h55VcWjT2i2WT5FOtFVLtlADoxfckXRbaTq
X-Received: by 2002:a05:600c:3495:b0:495:4811:7998 with SMTP id 5b1f17b1804b1-4997848412bmr75446575e9.17.1786458954997;
        Tue, 11 Aug 2026 07:35:54 -0700 (PDT)
Received: from localhost.localdomain ([45.249.68.153])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499788a5be9sm74296965e9.4.2026.08.11.07.35.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2026 07:35:54 -0700 (PDT)
From: Joyeta Modak <joyetamdk@gmail.com>
To: kees@kernel.org,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Joyeta Modak <joyetamdk@gmail.com>
Subject: [PATCH] selftests/exec: add missing SPDX-License-Identifier tag
Date: Tue, 11 Aug 2026 20:05:43 +0530
Message-ID: <20260811143543.45989-1-joyetamdk@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: ujq3cydqkih6nxcp48qjdp31sxc1ant9
X-Rspamd-Queue-Id: 794A81C0013
X-HE-Tag: 1786458956-324652
X-HE-Meta: U2FsdGVkX1+PHxjRrzWYK9X1EBUsLhOTDCWkbO62G0JGJtCVQ2HWTpRx5+4xFsOzQMX+wS97+Ey/KuJekHFGKPVHCitvkgCh9IQOgmlIHqhg1N2FjJqpKYPShkGTZo8rV3JhOqxyE+25IHDYfIpCXsmM+Wgv2Tr25brLaqU2hyUEr/OgErdL6HpxuQMTdbi11aBpo6q7KwyPyyprzII9Nux1xvNnTeRWnxfRC9p21HEzW3+xmXMOCu5Y1F0mquPGiU6St47O71mpKykeHBe+/1xthniSMje2xuRKdtJJFQ0qYRHUF4OdOk7zwZj9b4YzEYsJxEhjqo0nxF6nttTaKDxsVnOW7yCPDZb3TfcZpKh/SbeLBrkMJjp3L03l2EgBEJnJTOuNKh1KkT9TXm9YkBfsUgxbASplldOfMQMDBFvpsgkD2+4x4ZG8kwmimEfnkPIT/e0W9uncd5ZAJODAHzXrILwVsc3loHXhyKU0eTcsVf5aos+IbJv0YMusQPpBSJRsnRKKfuaOF3Rkzpg6E5r18IDsjhATGpKxqF0946PxdMQR43Hsv55T7EFZ1dKSKvlHDpErnPaon0bGHo+B2819Gr7a5tT422bdJKUrY0xkayDe/aXI0pYJVFbl44reCbqHNjvs5el2rL/BCRMT0zwXvmzpa/BheqPce0qZD24j6/xUk3vc3cfCGRbds+tKs96Wzgu7M6T7pnns55OBMCyQRL4qIZfWPSJIOusbqEAPI/nHQaItwFDzlus1oJzlFHjOgesU8hsrcc/Rf8Q/n94SsMEgKso5BvSpNDMlgOJoXWLnrsJNEXHS3Aybyvh+kGcJtD1LyASU2Z860IeoMrPUJTvjlaNAZ6nflenf5XEJV4JXAJ8Fs9DtRPWYNXO9ohukMizHwmrTCEj9ugYT0A4Th/a/mX3rIFhs6nJASlpebdbLf2rUhpZQFq3omS4YwaJ0s0klEBh+Uqcitgh
 iykCxhp/
 0pJoIg6Z2ygV61/eTAqK3Itlf2a8bVD6pfOPd3i3v+g6+jPjqsuonVMoG5yyWHRXLlwxGIWmTBcuHfHZHVEGhA3iHq2eHtYgOflW1OjZmOSdaEKSL0d+NrTyAcMjbb6YReefmBE+nag7e7gtpqv/keR4FQfZ3vLy2dA6N1R9reDjwesxtWP2lWpV3qozvECxpvUCLOFG4WLcGACXsMfOF/t5du7tgys7FON1yczN3SPaXxIEsuL9k5RQZswcNXblp09zmmVECnHoY6jYmkXhy2e+36jOL3RiBW58NhcMJxZVNX9/3jknklHjk/WY7lTXqYBlHaMTZXZjFsjGH5SbEWPoHYhtYQ34bmmNa3wUkKJm6iN3cjRxNIYxEaLcFQyfyp6BwbKrgCSAr91Z8FERIJ58EwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the missing SPDX-License-Identifier tag to
recursion-depth.c . The file uses the ISC License
 as indicated by the existing license text in the
 file header.

Signed-off-by: Joyeta Modak <joyetamdk@gmail.com>
---
 tools/testing/selftests/exec/recursion-depth.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/exec/recursion-depth.c b/tools/testing/selftests/exec/recursion-depth.c
index 7b5c4f6d1928..a6c42a9b22d7 100644
--- a/tools/testing/selftests/exec/recursion-depth.c
+++ b/tools/testing/selftests/exec/recursion-depth.c
@@ -1,3 +1,4 @@
+// SPDX-License-Identifier: ISC
 /*
  * Copyright (c) 2019 Alexey Dobriyan <adobriyan@gmail.com>
  *
-- 
2.53.0


