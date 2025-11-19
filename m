Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8320CF34D9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 953376B00C6; Wed, 19 Nov 2025 10:45:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B5846B00C7; Wed, 19 Nov 2025 10:45:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 756BD6B00C8; Wed, 19 Nov 2025 10:45:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 596026B00C6
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:55 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 260395955A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:55 +0000 (UTC)
X-FDA: 84127782270.17.8C2B960
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf19.hostedemail.com (Postfix) with ESMTP id 289081A000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=xuBDnkOP;
	spf=pass (imf19.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.42 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uk1lFWru0IGdhKwRKbnhtV9p6FImm0O6RRZYNI9uc9w=;
	b=T1YHwuyUN+YMQEGFvBtaSF6/0CBYLTXycJuQzJsfZIMzwMUJME9DlA/jd3TjKOP25JFHND
	G0Wz94VSXJJShPc3uMSwPA0N4xTkXu+3f/c8/iPPVx9nxC1P6NAP5Wd110t7NfWeXH2JCG
	q8fZ2r6p6YCMYlk1o9rlkph0Vla/zpw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=xuBDnkOP;
	spf=pass (imf19.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.42 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567153; a=rsa-sha256;
	cv=none;
	b=V6ziOo7K7vY+aLHlGvYxo1SsTizWohAZGXxBshNHJXmNfm9qZKNefXOJWtzb0pA+BEVx1+
	56yGhpyKUJ2LFcRXW+qUj0Mf3OuE/fcAUGGnOXe2CNTkPkIPsTjsVGq/Blkwba1spDQZJI
	Bpf4JsHmgniO7T2dRqCVNDI4X/pOFTY=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42b31c610fcso5924809f8f.0
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567152; x=1764171952; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uk1lFWru0IGdhKwRKbnhtV9p6FImm0O6RRZYNI9uc9w=;
        b=xuBDnkOP14tt8Z4xjN+jmMJaEdlBUBZu+y9ow9+d8DfHCyl8mm3tsyFa4NlPtwAv3z
         0cJZSpbaQhIfEzc41//VphHsIB4EqkwmabjTU33624Z6lpL7yB+EynExminwvVAG7LW9
         r2JFnSTJ8Scza580iFlMnPXanRZrvKKlcKVMAPHYLBSf7CEihmr1xg2ENFw9Y4J+h9a6
         HNLbv4saE8mqUrhWD1JZ4dw12amsZHkVXHjGw+8CpfRKPTZmD7tnwfhGGbVQ9/if9JWz
         6/762CO6YWxDHU5CEdFtHNQyBJGhOI81uuNwdfXX+1F6x7AZcrQhMOE3hzPhSYn0MVWZ
         unyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567152; x=1764171952;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uk1lFWru0IGdhKwRKbnhtV9p6FImm0O6RRZYNI9uc9w=;
        b=lJaWiCLA08FSvJr4BhEPOMV6RpGr0T+5Fq5ipzb9o8mavKlmxCwMLw90NlRZtakpZ/
         uHft/DxeN2u9Lpi+aYkppoOsF2a6dqR8F0nsvG+6fQSTqivaMsTl5Rf4SMuQh+AgY51E
         ztBm9kF1O6Tbn0zEOJsZBN/CTITwoMzUcZ6t46M87BgF6VhTjN+cfQcy6CTkpW3MAebv
         J4glQc7JcTV5C36F+0kat93mBapVKVode1reCPrxalyLWfOBGaqWVlzgiqxgmY17PeVv
         9W417z86M4mOQ0tzkiF9ea5T/wFctplvEvrPPJ/Ck1etlQsAgl3PAgAH/4W14OEHfzMi
         5htA==
X-Forwarded-Encrypted: i=1; AJvYcCXMlj4EgRQtXrTOZn0fAHEYq4kZF2JhEHyg35gvOrNkQVBK8obX54xS55kiqkwBWmLEkKZ/yHYn+w==@kvack.org
X-Gm-Message-State: AOJu0Yy2ZUt3k+Y41/XWp5DoIPxfV/VXqf331ZmGU4ZTNVU3J/2R7VRi
	af1YisJix5cNECSUDEN/VRxQC739g2YvDf7InEnwHCX0gKGzD7MNlWBIUTE0YVbTKyg=
X-Gm-Gg: ASbGncvpqskMXckJyhIVza8/jcCmJcG9W6RFUTZSVk9hgqi7zcKsIScvfgn+U+6reNo
	bX2PTwTbsFAytL2ChkzgNsSUlCR3kMOLroNWu2d1u+A2npPOdcCRCGVfc7rhcfqOLpi9s/KggjI
	CuXqURUe7SHoopct6L0iYVrpSeyjpZ3mjKu//DILYkma1BoJq0IiNxisedqH3ZVb14jV/zNEd+S
	/auHcnMUv/615bjMxko45okoLFMGu85ZZEuCyfD72y50T4MlwP8cAnyUh5HAE4cfTfo3AJ+CUdC
	AKyNf12tEKmBxs0hHINnBNUkBWulxJ9GS2vwRkwfG6xKAISYF+Y1+7pmMq88wx0UasVDxKTiNUm
	4iLSopHumOUwOjU7fji8Wtl89n9rC0IpjtFmNQj+lrDYkLKHJGhP7B5n8cpzm+CEJRWF2nLz+xy
	c6XBUbrCL68+DNPKlQDUag0mVgNowm8g==
X-Google-Smtp-Source: AGHT+IGiIxmeqrKKXMpyNCEgyddWcck0X4KYjA7E97PFt6A4ulW3WkSU04Vt6omGLvNuAQXzgiycDA==
X-Received: by 2002:a05:6000:2888:b0:42b:3ab7:b8b9 with SMTP id ffacd0b85a97d-42b5934db2cmr19180692f8f.20.1763567151698;
        Wed, 19 Nov 2025 07:45:51 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:51 -0800 (PST)
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
Subject: [PATCH 20/26] mm/sparse: Register information into meminspect
Date: Wed, 19 Nov 2025 17:44:21 +0200
Message-ID: <20251119154427.1033475-21-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 289081A000A
X-Stat-Signature: hebzqfupgk3f5hz13xb4redd9t7n979e
X-Rspam-User: 
X-HE-Tag: 1763567152-259254
X-HE-Meta: U2FsdGVkX1/p3oqO11DNY9G7CPgQRXvycNqm1V4dujUejoWTn8DwkK7IWm98/Opp/0ycCmKLN+wfItRYCMpugemXfyifjKfsYOHhA+SoK4TfF+2GFBSnxgrchHhZ86B4UlZbWXuMGwDGzMFZZCVzgwb3g5e2NC74fP26lT84L6TTWjJU/qNCQnfUXXcSvUssbmV4N8DVOzxjHifAxwq2trV2pstkpIoM0wvofVDCr4K5P2N7as2kEz4Goz6rl2QD6EeiHuteXxjcjxO9OYO2ZglVNVh2YrSSJahJ5RsdBEQNXnvUYxl3tP8xNimsYD8IPqWkIljAvWl+dEkzs293joFnu3ldCnDkxPh/IXr25rgp8uEgCHBO1LlQGkPCKM6IbJd6uC5378gETxFEKzww7gPdqZuHRNCERckX/Uolcsice/ilY7EzqdtI1eSX/uAvrAMqkIqRD8CtSclnUgqn1SCXH5SnuSMwhpTFfNUQjk9vmE+p1dXQXExiK1Vq0u+JGpzI51RqOz5Z+jtQ2DTSuKIDnuWnRMTsqkos8RrURoxknYgH3NfIxjXWAUZy40iC9YzvUrx9x9Zi9HvYXfhhBZ5ayxAj+Dvb2KHeFGOXsmel6pDae0r1IcJmcoZFWviEx40RNogMr8INDS4v+lhoJrmuNAMgjcuv3M9hBEIxWOyyIkQzG5h0BbCkZl0Gep7Hu/50L1j5UVtf4SF9Z63Sp4JaZhn4fv+/j9Zry60v9xBYVBcfm3SCu0ge316ppGTlsJxZJL9WG0NBmx9IuTFaEQmNO7dKfogFkLfnqK2eLQTastI/cwU63lPYGs/VwAl8tmgOsSxoBEuiz7KjOhwMvvDHSJ2YeY330chNPGA68zQXmeQZly3Yq+UAoUMDnBX+U4v5hFMBht+lDJDzVjX2L036nx4oy0kkAgnjMX7jbhVfvRyQiVfUr8w2lrBTw7ivFarEt5t1ob0xy14fA4W
 rzuV86sj
 4GbOfK44lA7EAVWOxUyBFyXeEUbk/plFMdj5IDPNObKAjkkEN+AxxQRXXMEtgp6HQVihGOqDPzGX68j9WFYD7xnH/98ot6sNIRMtrp0WhJuplk2cMVVh+II4cBX+DT6pLZoApywwiNruWIzPDwlsQw3HDRAjRlgpjctcA2C7lxERj+pLGNXK5M7QEsyEbFEiCFMqqtxL3IfKaHBcvVvAXEhdT37YR9iZk0VHIht4d1phZYh4rRpIBpUQeNThrUnO8xQYivzkn3Pu+DEdrNerpIFSiISeNpyEYd0so2qoQvcG7ee0QzSdGAck/dmlAGXh4iuhT+0DEfPIDJtt/nGIaRzAzN8pbhKgP6UswBj3j6+7vhC7/xi9woboHeUbUhjS0TBkJRppSC3+FfelPbn8TlAPiaqq0Hai4seFX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into meminspect:
 - mem_section

Information on these variables is stored into inspection table.

Register dynamic information into meminspect:
 - section
 - mem_section_usage

This information is being allocated for each node, so call
memblock_mark_inspect to mark the block accordingly.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 mm/sparse.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/sparse.c b/mm/sparse.c
index 17c50a6415c2..80530e39c8b2 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -15,6 +15,7 @@
 #include <linux/swapops.h>
 #include <linux/bootmem_info.h>
 #include <linux/vmstat.h>
+#include <linux/meminspect.h>
 #include "internal.h"
 #include <asm/dma.h>
 
@@ -30,6 +31,7 @@ struct mem_section mem_section[NR_SECTION_ROOTS][SECTIONS_PER_ROOT]
 	____cacheline_internodealigned_in_smp;
 #endif
 EXPORT_SYMBOL(mem_section);
+MEMINSPECT_SIMPLE_ENTRY(mem_section);
 
 #ifdef NODE_NOT_IN_PAGE_FLAGS
 /*
@@ -253,6 +255,7 @@ static void __init memblocks_present(void)
 		size = sizeof(struct mem_section *) * NR_SECTION_ROOTS;
 		align = 1 << (INTERNODE_CACHE_SHIFT);
 		mem_section = memblock_alloc_or_panic(size, align);
+		memblock_mark_inspect(virt_to_phys(mem_section), size);
 	}
 #endif
 
@@ -343,6 +346,7 @@ sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
 		limit = MEMBLOCK_ALLOC_ACCESSIBLE;
 		goto again;
 	}
+	memblock_mark_inspect(virt_to_phys(usage), size);
 	return usage;
 }
 
-- 
2.43.0


