Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C951CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 06:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C2698E000C; Thu,  4 Sep 2025 02:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44D088E0002; Thu,  4 Sep 2025 02:23:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EE9C8E000C; Thu,  4 Sep 2025 02:23:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 11B928E0002
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 02:23:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9374BBC969
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:23:36 +0000 (UTC)
X-FDA: 83850576432.16.3D5ECF5
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id B8D001C0009
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 06:23:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y0mOdcKp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of joeypabalinas@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=joeypabalinas@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756967014; a=rsa-sha256;
	cv=none;
	b=AUQrI+Ixu94zSF7iEoBQ1JOamouq7HuQa7VP3ELurzvPumynQJxsBi+k+ve2cpxdCWSIJS
	mqw6yiopQjmvWVrWQ7ll6EkDoFG3xWEhfTQf+dXZdkhziEqWR40L5HXJWjGvP+vIgt/ETr
	OSQTx+HbMSbgizi9rNKOz/ByaJobMHE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Y0mOdcKp;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of joeypabalinas@gmail.com designates 209.85.210.180 as permitted sender) smtp.mailfrom=joeypabalinas@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756967014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gqScMWwsIOO4FF9xXYpH5H8Qrvhh65CN828Ff85nqcY=;
	b=tLM28wuJGEPILNi0wAzic/6nyA8+Vu6jQWJnMsVpwH/0v9BKbGXKpdy/IC9gAlLPKoeIts
	ircmhUGDH36yz3ignIQeqbC0nJThRJMoZdqKktiRe6tPecTSO7/oO50QLIZ2B7Y25qC+/9
	Vp3qjgxEpRGcd0vofp5YCJXIpIlCxgA=
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-76e2ea21430so55414b3a.2
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 23:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756967014; x=1757571814; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gqScMWwsIOO4FF9xXYpH5H8Qrvhh65CN828Ff85nqcY=;
        b=Y0mOdcKp1SzEy2Ai+pFBthWesY1WBBbbqJGtRP0inxj8F233yIHZJZDeaVyg5BKd5p
         m6540HJnLVhjoZywg4u45u/m3tp1UMk+KEG64su7NCViv6djtZPyjdsqhIoJXcrOkonI
         ZvIbAtoFy8Wj/E+o5CtlxY1mn6V/32870K3RqV+hYo9O/n8FJHQ0fbl/ANsfGv6qdRxX
         2TXnQyJq90YxKqMShOZDk5i66q/2YEGBzMkZ2Bwg4PqlrC13PGkKPROhVbAj/j/6B9Xv
         AMfFCZ3LpQQ9rGfnyXZ9DEORNCn7lKnelPzZ5It8mK8zLvHjK5gmZemboPPT3kvgMPxb
         j8CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756967014; x=1757571814;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gqScMWwsIOO4FF9xXYpH5H8Qrvhh65CN828Ff85nqcY=;
        b=J13yKr+fE/aS6m0FvEs3yLmPcfvwBkHEdeaJ0IOoYtZ25YuS+wiQ0N0uZgSiSifNWh
         aj5ruYfAmj82s69I81kSj8Pl/wh3N12s1xJ08ffnyA8k7MmnGykEOdf749zYBahwqZUC
         anDrxE1ASDIub/ijMPxpWUf7AuG3tDLRElwUhlGVa38WVJUy1hLffiLHpX+r9mTs094x
         U8LhyBlbF9L4lRLn9AumSZvwyKc/ejSyDn6FyjGI9ifNd3gtmKaPG9l1kguYzSB4a3DL
         E2k4XuO1omdcrwPa+JbHlXVjX4uyqPOgIf7JzmpWNqDWErxjP8bbiGzxrnAamKs0+GrQ
         KAQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhsqZEt7alzPXutlFPSPYGAPRc4BXifT0BcjtYwWM2nlXgN/weKdoc72LF0SUNagjcB8fqhRx+Dw==@kvack.org
X-Gm-Message-State: AOJu0YxTj3zYELW3fHwG6VBBTYLaOHvQY9fZAFqqmbGzt5/ARG74/TvC
	oK8MM+JCimIcCQnIBfMUqgS4dkdTLi0IAKEHarrl4y5HhHfhHS9j+ej0
X-Gm-Gg: ASbGnctfOBW+yHPjzCVIp32NHWIu2JjhbUarU2uxmWDJZhTaeU7zvFMYkzFbN8WsLTV
	fIQ6SI+0smht2wAJbcSw5B80Dsst45sbYUrvEP3LUBmIr0OCHS4b7y4HmSCnOMAR0ZHhxmLnHGm
	ITzj2U0Z6hhpANtVDFPAivadmfCTZdaEFbNVXucv6VBFkYCGBeFGowgmLgItpCqKtydcKI7A3gK
	rDPOc5OxcBSvUUUsm2i6iLP7+ns6BFDn76coWND00ZtPuDlkAWxkDNQUgcHFtjF+3vJYniU7mub
	j4TzszVbVex/m5PK8MV6Q3iQvQcer2lmJOsZfcrqW/Wp9SHkDXt6/YEzUFCgCuARJMNfIMDeY0D
	NE60k4i/X7IAhnABeMvxtbQVQ+nWy18hRtgnQAQ==
X-Google-Smtp-Source: AGHT+IE3MI26sAwnImiGvLQXuXNemBNftGP4w8LXCGks2pKBnCEqIde5OjlQ7uQs5W6tzYw0B9IWqA==
X-Received: by 2002:a05:6a00:2290:b0:772:c3e:58ef with SMTP id d2e1a72fcca58-7723289dc3fmr13880730b3a.6.1756967013538;
        Wed, 03 Sep 2025 23:23:33 -0700 (PDT)
Received: from hobbes.T-mobile.com ([2600:70ff:f833:0:8e07:c9e8:902c:6ffa])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7725f0c4008sm10198397b3a.35.2025.09.03.23.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 23:23:32 -0700 (PDT)
From: Joey Pabalinas <joeypabalinas@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-hexagon@vger.kernel.org,
	linux-mm@kvack.org,
	Brian Cain <bcain@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Joey Pabalinas <joeypabalinas@gmail.com>
Subject: [PATCH 1/2] Hexagon: change "a mm_struct" to "an mm_struct" in comment
Date: Wed,  3 Sep 2025 20:23:25 -1000
Message-ID: <4c3812e5903e4e91587eff3c37b7aee4b35ddf20.1756966290.git.joeypabalinas@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1756966290.git.joeypabalinas@gmail.com>
References: <cover.1756966290.git.joeypabalinas@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B8D001C0009
X-Stat-Signature: xzq1fci489fjicqgmjajckmqk9rqub1e
X-HE-Tag: 1756967014-266443
X-HE-Meta: U2FsdGVkX19XJ3PhHMsZqMwyBfyhLvahfdvHzIyDjq5u4B6GAhbC/drxgnlLY2uQO97W9KV0kkVMd1ZVSYk5jl+MhKuvzlBTSvRfPk+mwdXgxfbs6812EhKeAx42Szj6lLJCOvuGkki/HCJiv/AHYkcs+8lSAcHCqzc0eYno+oucIVmmN/0SVgjBo6hD63jmUJks8fKcoaWx3jiSpBS6gCYO2gAGKiFyVfX7uqGNtqQPX+xMkAXJ7r7EZakQ+I1fE336vdqp8FAu4lhVNhY+yJXFmuKd6Olce50bcGxUn2B6nz74fIHEAUk3IvYffMqQQx1JGSTGn3Le7l+yK9ZtM2ToFa5dkLigH103mZ5G8WvL+rKxoaEejw7ZnD/sr/ynvHsZFvGdpY/wbExkTKKc9MTBYIynDSUq+dji7anSOKGQKs3KzWW5bakEopPRwSfnETApqSLfI4FaYIMIKvNNLHu/A4Nerz0PAHE6027152I9O5n9vMGAifRPF8vcWmgxSsGxyMLC77PT8mIzbsLf2QwaSOwKUVISi5E4yGLJJqcynkvJ3lkrZPl79+lUJ70DCaTO3r9DqwKuhWois59obBcfhx3sZqorGUIr1BriUTQH5PUBchbs8Ui5OCaYuOuGvH2PIiDLk0R60+JhJW8CJXDY/3wYgMxMcc8Nuu4PLD10HRHKdr0IvKyoiZhoX+uC2cWHegl7jdD6kqNedcwOvCjOyzbiAhjSoEPGBEHz34Tl82yxxPPd4zxScPvBMbNYyZNdjM4yej5XwxDhGLc2bhiH1LhNZVhXjY1LKg7PFgyfu71wZcr5e4jLODUfr7Mm6kdptKuJesAfN1unmkC4/M3ToZNnWOvNYgReuxrZ48+UFolqZ23oYDy1DbBcvFGCDC6W9PNgV9TkMrDGEycuHkv1q4uZ5zpVqaAF5DxNsC7e6NST6rp/P9uPTPfbMaeWrNwRUwPsGX2+zB4DYjX
 I1zf7D5B
 Y5FfvJFOVuiEUWj/6PJXYCfaQfsjNVRBquwLBf5mTqh3rgxgwdUJ6BBxApsRxHHVKokfQETK1iadlN0rpyRbkPr8Cg3B0QoG62YSq3ekd9NkJBd6nHBLMNwqqn7g/YLt2ktQF+Wl0gvSux/vdxm1Qj9wALUcYjMNkwKbW/MXCYDDSI/EHNQqLeyPXygjib30QMfm8bDc13Z7wXRhKDTPp76DFqadIQ/BHOiYaLpmL6GLW2w3ESUM1McF0jd2pBey7vQOFjNBhuTl9psoLhGOQamXVsl4oVFN775vkERwoAEtkDCWKqJPMt26pf4JINvkadrjAdHg/Sa1rR3UiWJ4wPL/zDadjF/HiOE9ST7UKgthjqyZg1Vie8LX28qaQHxljq48SyA4N0yE8unwiKH6yXo9FREnPrY2znYbIKtdiB1W4rpEopF+CDazmmuMX34WhhM3BMrx8qYU2ssc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The correct english is "an mm_struct" which is used everywhere else
in the kernel.

Signed-off-by: Joey Pabalinas <joeypabalinas@gmail.com>
---
 arch/hexagon/include/asm/mmu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/hexagon/include/asm/mmu.h b/arch/hexagon/include/asm/mmu.h
index dfa46660d695bb65b4..ce784218dc67c92a94 100644
--- a/arch/hexagon/include/asm/mmu.h
+++ b/arch/hexagon/include/asm/mmu.h
@@ -7,11 +7,11 @@
 #define _ASM_MMU_H
 
 #include <asm/vdso.h>
 
 /*
- * Architecture-specific state for a mm_struct.
+ * Architecture-specific state for an mm_struct.
  * For the Hexagon Virtual Machine, it can be a copy
  * of the pointer to the page table base.
  */
 struct mm_context {
 	unsigned long long generation;
-- 
Cheers,
Joey Pabalinas


