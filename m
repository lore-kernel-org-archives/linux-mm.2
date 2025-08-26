Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBAE5CA0FF0
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 20:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 865616B02F3; Tue, 26 Aug 2025 16:56:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83D5C6B02F5; Tue, 26 Aug 2025 16:56:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 708468E0105; Tue, 26 Aug 2025 16:56:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 45CF66B02F3
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 16:56:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 07119B6C9E
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:56:37 +0000 (UTC)
X-FDA: 83820117234.18.350D9AE
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 60E8680006
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 20:56:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d15yLtoy;
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756241795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QhymPbMl1maujeQhGMIXlLhMPhVkZ1BpuEab9k3C4eo=;
	b=RNnpyOsvwGXHDopCRyJhB819qwZr5HfUdRCqwrDKLmd5haj6qVGU5DunKnBeQqddpGsqXz
	lSF/PrYW5iIDYaj6qtCetj9KyRrEsPdF61rMflW6H/4J5nG+bVothzjjiL8p+EWxjgySiz
	ry844yR25G/VclcCVffHUn9bD2hDLAI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d15yLtoy;
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756241795; a=rsa-sha256;
	cv=none;
	b=FbvflIC6NR7HhT8O0ZCmTbYLw1EnFIcJfFTtpSk+w1PcjjPkOjr5mGmhI6xInGnnbR7aIF
	ea+TgF5iJVFL3gT4+YnYceXdmaE6UGs6S0bqD2EzhuMwvqXsRdLjLTtvn0mIDSnCdZTZA9
	zRA2tq+vOEOhnMzUf9B7jDcYbRvoTNc=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-771ed4a8124so2247465b3a.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756241794; x=1756846594; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QhymPbMl1maujeQhGMIXlLhMPhVkZ1BpuEab9k3C4eo=;
        b=d15yLtoy529vGdB8YaUN2nfmpYoS+yAkZgnh5C6Xce4muXLAIl6z3MLZHflF65tTZy
         uhFHNum0bsf0ZB5qqd3OtGwJQeqjEgpVU8m2ZFu/+lW2Gdc/PLAGDXhGrgtVj6p0ADZr
         jlUReoR1t21S7Oo8gUX50hD9xMpixrahaFRY4tXJLyn+vR0f74w/NbieMmsXQpdSh3fu
         R63B5/RvoKdfssgLnlsk6YnPycJKvkubVPJY6D+qw6C0/q9PgYy62OMqADSD/OC9/AHi
         D+5LAjROvpjj5dDi2HI/diyd4HVlsE51csONV4ZXw9wkTuLKnTXjIrL3ybMSiD0+roCM
         0c1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756241794; x=1756846594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QhymPbMl1maujeQhGMIXlLhMPhVkZ1BpuEab9k3C4eo=;
        b=nFWJuxkqx2bscAPq13DGkDJswdx8FNMK/DC8Mh0NyrwmN09s3S2FTQEylJLSnpVh8V
         YCF/aFqSmK0Sgta36tPpatXVlRMeMqHTRl41xBr8njFEa534gDpcmVM65p/EXRngUCtt
         5hgeMLmV/xL8e1m3oqCpMnyxPItlMDkEwq5f4ATJkYpT7p/FkKVx1gHmba7OAELMoKnB
         qCvfcfEL5wr9vR9ORQ/UgIABHig4HAe1kfge8hB6moNuylnlpXxCEJqt9wnpoOfk0/CE
         aC568TnG8GSErx1raqoYIVhjcTUzp0vQW/lIa2wW02IwwwnHK1D8/FB9OsayT6598/z1
         MByw==
X-Gm-Message-State: AOJu0YwzPm7JZpCr688hfT3QfT/eQlx6NryOE9Nqub0201h77MwPX161
	RfCmK/suIG2vNdz106DvtzsR6MLKhJQ+pWPhjRJ4Y2bjZD7XjlVIhevA9FY3pw==
X-Gm-Gg: ASbGncsIx2fQ613YLntdS5kQGT5b5Y6rBSWd6Rhww2Y9wDDGEL5yMZx4oDIlNbmjviO
	lm9hmmFgy3OwGdJXLYngjEqCWDEbLOpLJNPv8/bMW7QXpSduRhogfxETMxe+Amlt5X2F1J7U2Hf
	xwwgTjDY5/yir9/dodOHndMnFYF5THbVL8hZhrhKbqoHZf2gWiO+M5NCdj67WqcWRdpVmERET3A
	ldCCm0xBSkS47I8PTxlCyt7zeFJHhrUpxffiqC8FU4WRXfdHzLqevLAi6HdDRi7A3TE78BkvPP1
	dXMtFEdy+JZvoH+qYByA2LvSEy9GCuOFa0ITdsc0iAjolKT11iGcfwH7XQZ48LpZUQV43kL+2Y3
	pawTQfdMWwKNRRYEhrfErCeu2h29j8YEFaOVfScgFZLThJNetk8iV4NYayX7PKHTK
X-Google-Smtp-Source: AGHT+IHyoITETX3mMO6OFZ+cbZSRTX/76LzPMEuMpyUTUsY4GlXP9qWB1WRt/5lzMarXBlKb/H7nPQ==
X-Received: by 2002:a05:6a00:2441:b0:771:ead8:dcdb with SMTP id d2e1a72fcca58-771ead8f33amr9122485b3a.8.1756241793611;
        Tue, 26 Aug 2025 13:56:33 -0700 (PDT)
Received: from fedora (c-67-164-59-41.hsd1.ca.comcast.net. [67.164.59.41])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-771e814cbccsm5817935b3a.35.2025.08.26.13.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 13:56:33 -0700 (PDT)
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH v2 5/7] powerpc: Stop calling page_address() in free_pages()
Date: Tue, 26 Aug 2025 13:56:15 -0700
Message-ID: <20250826205617.1032945-6-vishal.moola@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250826205617.1032945-1-vishal.moola@gmail.com>
References: <20250826205617.1032945-1-vishal.moola@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: c5iynpd4z6wxui35pnhy89kc8xztwghw
X-Rspam-User: 
X-Rspamd-Queue-Id: 60E8680006
X-Rspamd-Server: rspam01
X-HE-Tag: 1756241795-894728
X-HE-Meta: U2FsdGVkX1/eBDp4l59mZCK6ZZbQjVmI24yrczbwW4oBWeH8tqI7IboOAs3sgCDdC2Su/oF4m6oBGvnLMj71Xe/GOoAf0RDqywGudwhd7sN4qGDxcjQ6EXgXaGveW8FtaKa50yOKpDmFzrvX4Cil6p/yFiPlBxN0leW1y78c95gDvXcb236JG4KaMrkkNEjSZS72Zn8SwIMz8j1xPRxHfXwhs6TL348ttoqFQK768ZCpW8odQCCAmaYd22ma2YbyA7p6A7wk3j2fJ7Yxt/l73wI+Uy4eKmlFeNcg5GOY29YtpqN3A0o+tXfz4S6038c3lg826geTU6kc/N1s3OrSZU0yfIsDWWtW+jE4GB1qcdDeg45eRLN7d6KhmCp/lTO7crUE6Ih2vQtQQdJQP9hsJrkz8x14voupPTRrmeyqFzYm6iaKvEHPmOtv3ZNeROAmJI8QIrmP8pzN2sUcqTq0srx89P1Vd8bi3OVT3pJOgLWyRpM+ADqY2mmIhGrJXwRUIOTA3UksJNQwfCwz0HMscFKfXJE1INySC2KLPKeGqJA0l1kXuR50pmcqZhNLOmww+oYuT04kCfNjA/4RJCa9wjMH8Ymnk5edxGya0sRtZ0+8Q2fQAQVv34RhUHeZkNNsQBsjYe51fQje+lW3lkuG0U15B1huP0obrUcK+VT/LnKGaQS1CyeM6odNI4P/OzfJ9WQp1stvssd2LpIRKsnCYGBVjBNQPZOMH2YGov914X1TwEqRMevrzic2/0Tjgg+eKj5CQSJRHXoyJpjyfTuGD6qtHc6P7BaEgDzdGBdUtNcbUCJesJkITVwdLQ1GX1nSo1OG2sJ85xxfqDJLAOrUUgKVF7Y0s0CNtrdQXsM6HHxeN/3DqlID+IIDhJWcSb2Q7eZ8i2L8aIwpKPARefGivSLip/LbmrVlk2xnYYK5rv4R+5QvLv+HUT3nAiCIUMK9QGz6vb9wgCDY2kncpf8
 9jhrAEXW
 OvdVN7jqkrLQA+zPOq3YwzWNNNZhFHF3YN7ml1+X2L3x5d5+2OI9DaiRHo56LxwGrQCTSgGvzimXPXaHhGpt/m3Kw1ja4rk5ubC6wcokr7FLCvXMDUuOZ3l5ljaguzdMKdRz4iUf91J+UxV/A3D7qypxlJ5Hjj42i45h4ONnfwTWCIrBO7h5gjDCQDZz3rovpW03Gy0ZNfpSiG1g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

free_pages() should be used when we only have a virtual address. We
should call __free_pages() directly on our page instead.

Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index be523e5fe9c5..73977dbabcf2 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -780,7 +780,7 @@ static void __meminit free_vmemmap_pages(struct page *page,
 		while (nr_pages--)
 			free_reserved_page(page++);
 	} else
-		free_pages((unsigned long)page_address(page), order);
+		__free_pages(page, order);
 }
 
 static void __meminit remove_pte_table(pte_t *pte_start, unsigned long addr,
-- 
2.51.0


