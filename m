Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 646A3CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9B236B00B2; Fri, 12 Sep 2025 11:10:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4A746B00B4; Fri, 12 Sep 2025 11:10:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A39F26B00B5; Fri, 12 Sep 2025 11:10:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 90B836B00B2
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:10:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 596ACC08BC
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:39 +0000 (UTC)
X-FDA: 83880934998.15.B5EBDD9
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3DDBE1C0017
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:37 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=nFqlmNeN;
	spf=pass (imf21.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.176 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757689837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ds8gslyRhEA90VqYYB6jUYRwIuKnqG3r9jdtCHu7D4=;
	b=sMnIzGQaErEeMBNpmLwqI4aoIPRrq/TWJczXJIfWlY6Fh2OH7IhQuqYc3YB9tkvPKIgmy0
	zJasmNMG+IEaJJKVAmlMqgwgyG149hcGeaWkGkeo5sEJY2921kMnAqQbexRIrwu4Uui2Pw
	HwHelJ8UI2TH3uFlt2gMl7cGl+JHQjY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=nFqlmNeN;
	spf=pass (imf21.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.176 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757689837; a=rsa-sha256;
	cv=none;
	b=M5BUQ5ijqZtOOrfNYqDntUEkuXNikt2YeyutTMvHvqdIIOAAb/8Ed8RO+Xs6PpeTaYEJ+n
	tpINqX62vo91Tb2Sh/leiGoTd24wAHquq1PTAznOcxpecMME1YxS2ElZizQqw3mDVs53G0
	JOmbPgLLq8CFPTkmveanRvUDOxepf+w=
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-724b9ba77d5so20265137b3.3
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757689836; x=1758294636; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ds8gslyRhEA90VqYYB6jUYRwIuKnqG3r9jdtCHu7D4=;
        b=nFqlmNeNFBufuEXGHm4Lzc90TgbMUaf+FKNPfGYFdCdPDfqoMgp9rDExL1uNmScEIt
         ZrYMuV6K8eZ2cBP3TeD85ZDMsFbiZnYW1XR4W4yPV4q9HvkmVMU8+0tC1XR4V6AJ5OIu
         ush/z8cjuGZKSKTq7tomJ1HZw180VSfMXGBFveGQ55HQrx86xhJeAC+7V2kjkAY0a1ou
         eD/Sa8MrXXgas29QBcL2vj6AmdPV2jB2pN5mS70OIPd3KESZuSBb3ibSjeUdhLMcgEHs
         GlZLZRFt8uu0XJSaec+hKY8ecPFdjOpwHOKoqbMs0eVZH7mwWI4UvSLfV5Nc6PEgAmgM
         aW9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757689836; x=1758294636;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+ds8gslyRhEA90VqYYB6jUYRwIuKnqG3r9jdtCHu7D4=;
        b=wogyIJ+haAuFAbYQQl/iPTJKaxHCUwTABsWlK8x3fafw7yCl04wUTNINSPg57YxY56
         kCjtinIM03Quuevz/dA0vc2M4ql4xlud6I+ftZ5pN6kTmNDhb24//1v5bWHEpz8cSTMm
         hQUXwTOjKg/g1pxeaHjiZ4/Clysvpu/WGHrA4CL0SjLoTM2dLv2XEDAElD/MXK0gAAKt
         +6n7QLUo/jgCorJXmd4Bok3fycLD9V1gr+sS9XXojaj/ucD0jQSZkhgUbNfs1r6FdRIG
         VfhL3rS59aSYCz6KnYiAiSIewKYxcD+rFEBEhsSiGiuFItyiXfmuv9aZGlqzzBu42xlF
         LgZw==
X-Forwarded-Encrypted: i=1; AJvYcCUtv6XwYxUYXsCjP3LsDPCmr+s+wjR6y9H7qxV+hqiZDTUa5iDzt0MYmLA8NCfYwzkeMNSyjDcWOQ==@kvack.org
X-Gm-Message-State: AOJu0YzwzGCqM/DBSSFtxbx3SdG5oQEmeA8PvvGj82bXu9OvxqEtJazp
	qBWx5E3U5nsEjK4lYb6yp5Ul9chrcGquNsE4GscjhIrboY9WwoKTK4aHGEWzPg5jFj0=
X-Gm-Gg: ASbGncsGUqPiJZrzRIsc5Z831dd9zBca13+y94AgSqGkrcISxp18q3Me08W5sruB16j
	uAEsGH3DIKPUtIUe2fGKLcMq8hrE0u1wM1r/Tav4G8tW01hL66uzUXqV3mon7wzty4nmOhIozDx
	wOdZhESjgmxd2MUAkvi1qaAm73sXNySCEce+NfX6TxQluNxNbdFnAM+/uQHBs8+DQ3wbdfH38tp
	aYK2fOdHbWho9fADqTJ2COkOClvRbLTpyb51JjXIgNrSrAa2evESoIOKOb9H1N7zGU6rPftdd4h
	JPHcS/cfom3KmyiWgdLCWto5JXl4PQlpoQ3b863O4fsj8+KuE37bc53ItJUCwYy0GbhCBpcDZjU
	S0C0RAIrnARVGr9W8BjGv664EzAcG7FnMig==
X-Google-Smtp-Source: AGHT+IGUk5zUSgxh+r2dAU6fmhsNlb1RTWa2J7nuwDb4l4jA+t4jqiomYFBGdZGHaaNJrIZspvEapA==
X-Received: by 2002:a05:690c:7286:b0:725:dc12:3004 with SMTP id 00721157ae682-73063d589abmr33964367b3.22.1757689836260;
        Fri, 12 Sep 2025 08:10:36 -0700 (PDT)
Received: from eugen-station.. ([145.224.119.89])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-624841586c1sm1302244d50.6.2025.09.12.08.10.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:10:36 -0700 (PDT)
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
	Eugen Hristev <eugen.hristev@linaro.org>
Subject: [RFC][PATCH v3 09/16] genirq/irqdesc: Have nr_irqs as non-static
Date: Fri, 12 Sep 2025 18:08:48 +0300
Message-ID: <20250912150855.2901211-10-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912150855.2901211-1-eugen.hristev@linaro.org>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3DDBE1C0017
X-Rspamd-Server: rspam05
X-Stat-Signature: h4dkeok98fmugqtqpamt3kxneqggu479
X-Rspam-User: 
X-HE-Tag: 1757689837-223544
X-HE-Meta: U2FsdGVkX19MIGoTfY1Cwwv7bYOFwZTNeZxWXEbwNGtTb+b7Z/OM3bn07d09xoyD6frMyGfVWud6vHn+sXZPuF2Pl9BKIb/DdbA2YPC54GYKPfG8cK7gpwGpWkpRPxtez/JFUcalgwl87fD1hXm6r098Rvjv7PMf32k9vzWH9bRISwzWi+IX6gPXA/xdLgiVtsbZvRVNs17FPOykXdPJaSww2h6rd/g25n/IjrSgJh9Ua0YfW7pdx2eFnOsHQqJtPtnWauEpMHB2MPQXv288bug7BcpUCzAYaOVU4OLw5PFKJSDvvafPF9aU8tkysAEnxpEB6u1xXjQ8fNdtiitCHJawiDhTxqYodpSTkWMa/OWvvrBjdkrAsdQuN5sAwJEXDG+7bddSdMmKBCTgk+d7cJDsbR6FMLSaglTmNtvgl9VpkwI0hs62lCoBWNIHg9qbR7oYcov9Pu7X0ykETtBPXN4QUesH7hkWsGuU5stuM7oA2baXvIVCbYeqJ3NwaCoJu0Ia6kln0Fqh5rHbDibCAl754gAF4CDPymZFvyaz3HlzluzguchB2hGiTBXOXHkRYrEhLmSfXSOvETPUtmyFbGuTlP334WUAcdRsf0J9rj/ybjjRLI7xV2SrljEsRZvEAPGlh+JWBHyErVomvdcnybwcg9KR27ePpIhuvCZ55eENr0dutTO8AcBGPupQzhHBHF4bo5LkLxojTaJopHRWCgcTXgZ9OkYvzrPJbesBeDLL2jAzZvNXPV9BIzVnTobBpe2WW5dq5s2J/iJymOx3gV6Mc0IXp66bf60CrZK7BogbVR5Y7qNgaKVticIBmmuDSQ/AN14vVN3k8jKyThf0fwj9BjK7kE0s1UeBI8UkFEiQNnImyftX+VsFvBTZ4Z/qnpiTeSv80P9JmLX1Fl+sIRH5tAVGpI1oxbN3qEJO3IeOhX8amUr7GBVqZNr5cit4dfY0/IHjrHR5soqYIWB
 m7am2GZ1
 Oz6fpS2kgfGKeNgrHMlKdE38Gimqw1K0KIx7ydNU4BpCOcwkPkNkici3g5ScWpmehQYfLOArmIGfCXA5suR8fZoL1g7nNnVG+kQ51oqjfMDQHQaNktDpfRFWf2FPCGb+JY1/LgmmQ7MqInm0ASKSdokyPhJpCyYiggmfSEmZOewiGTzskbNVKreI+qdL0D4glX8XR7nU9FkoaTbk7z55z5qbC1gGAPDgBPSfAD5x4StyqfBtwY3o0ieoaVzdlA6BpHvCdPk+CQe0Tldv+9lWwLbxsOeb5XUxu0W0/px1ZOA9SpB0x18TcAajTR5X/W86ZJ20zyd9z/LCZEOJY4RJ0Sn/kb7xwaWKDGNmqcBsnuOGbRVFrcP2mcZl0dKYz0gQ6+8wrGpx754QG0q4aGQqpBT1axw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

nr_irqs is required for debugging the kernel, and needs to be
accessible for kmemdump into vmcoreinfo.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/irq/irqdesc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index db714d3014b5..6c3c8c4687fd 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -139,7 +139,7 @@ static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node,
 	desc_smp_init(desc, node, affinity);
 }
 
-static unsigned int nr_irqs = NR_IRQS;
+unsigned int nr_irqs = NR_IRQS;
 
 /**
  * irq_get_nr_irqs() - Number of interrupts supported by the system.
-- 
2.43.0


