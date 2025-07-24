Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A02EC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:57:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6950E8E0085; Thu, 24 Jul 2025 09:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 647558E007C; Thu, 24 Jul 2025 09:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BF338E0085; Thu, 24 Jul 2025 09:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 385658E007C
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F3B02803C4
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:49 +0000 (UTC)
X-FDA: 83699308938.05.41648F1
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0F401180003
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=RPzKoyAg;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf06.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.47 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365408; a=rsa-sha256;
	cv=none;
	b=nAuBwCr3fTThBczPTp55i+DgpeSGqGsrPbKhE7baGgr1kpVPkwhGZlhpo5cPy7AeXXHPNH
	oZZo/tm46o1WcjOtFnSCDsXwsYTBmg2Dmcw++rrtY/Dkvp8fAR1UxnT/I2HHItqhfnJqMP
	qWRZnRea6NBOw1aLv4MPYMHyumbtiXA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=RPzKoyAg;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf06.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.47 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=la6fP9HkJphfM0jMf+9F231C5ZYtMe+0kHUA15eBYp8=;
	b=yT2oKxLqT4g5RFlMprTahQ5+leoFtqSxcmIY/VNgr/LbJr94itrBXNuCvWjeVlB6d5/xQs
	/ED8lqUDpDiHe5GB3+P2fjk/Ybu6C8Utj7lBYhYlqxQSHjLCZNgTq65CtlxVlLOEKgS1mA
	g/tGQMO8l1rC3weTIDl+wghWKZ8Bh7Q=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-451d6ade159so6665735e9.1
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365407; x=1753970207; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=la6fP9HkJphfM0jMf+9F231C5ZYtMe+0kHUA15eBYp8=;
        b=RPzKoyAgcKv9IjiapFrFsTjGbES6rDbpqj0p7XKP8/JbhDdqOw64ALFKpFFmwfBCbz
         a3elEtkU2j5D1hqunAp0MoAe92AVsU304wXMI0szL7C6ZHryQKTCD4FWArJsyANu9apN
         EGrQJC9ErOZB8pt+bzTdyV0BCc2bL5LZphXC9bM8OHrZ9jF0kC7A+TnbJrhran7NV5zk
         m5Eitq9xJBybAFPpTNMDDNIwnSxT7rMrLlPSufqXAXzxI18Z54WJJYDqMpqOPrigkxHf
         6J+4E896jnk54EuqXC535wlZZMpafqlg9bv2zDQ1uSYthTxLVAedeYrC8Gl98GijKp8g
         PIBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365407; x=1753970207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=la6fP9HkJphfM0jMf+9F231C5ZYtMe+0kHUA15eBYp8=;
        b=PAKYun2Gx4d4H11sCNs+z72Ihf9lzGaDZBcJ296u2bYwcVRvNC9IPhY3pClMeLHuxm
         +7yvRs53zXRUq16sUQxoVdpI9qS7KeDa2sBlgfJaUfb1XCe5ZdB5UI3GeWk0KSekXRcG
         x6zQbFcRkCWWxXrlIkPcSHLoTOH7M7MQj2/+8OPqyDUs+NoTJg7uUnRk5/cMhToDJt3v
         jXtJ0692jYCc4R9dANxEVeeYrZLn+/rDjho8vorUrjyD04iovowpXJ2MfZIxTzG144UW
         Cf3hgARDVTdvbzwmCyaYVwq+NSApbRKXaVLcMv2Hq2AoHOTBlAgSPsp/0ANcd4ZiCmKv
         PtWw==
X-Forwarded-Encrypted: i=1; AJvYcCXCEy37shXXjqJM/j2DWw8a1Zgltv97ebgZzsNU9nJjhAplsgCyleI2bxvjb8nhS+b+ILp6yC7UZQ==@kvack.org
X-Gm-Message-State: AOJu0Yw915niRwuX8YbHDd+JIIrDF5KnavVbVe7He2+td/aDUjvOBYWU
	QNexJPj+zFySOgrvSDsmt4BaCexQ2juwNX35rs/oq008RbE4wiS5sAXV0ehhUaUPy+U=
X-Gm-Gg: ASbGncuuuH8HELnx4sDpK5vryMKcEc7YAN6Nllbrf4zaWWcOZXARn5De+2oPGmGrEqs
	U0G4muXkXZqB+bN6lvOYh+vWZOU4/Z1ske5NwawcCUGupzFIgsSe/40THUje2cbnHOS/0DMvILs
	wQgP0BghvB0RPHGkG+TnSv1w9LxaYvtLsug3Alw9K73uuTAy+6GrP7QCvdEfhY19tZkwwskdVDq
	xdYteYWRKO7cpfODviX6v1Ni+ExvQhtcDSt4NtvOiWPXvAI321zDKhPcuA7SJjZ4O0EBNsKD8XB
	x8GaqZqXhQX/duw4ejaPZKuGQB72kVogDXi+fLGoA/oI6qGLXRp1eAz+GgiUnxGAF6Z6tPBvCDZ
	gguZkC5NxIK1gel7SSIjK2EJQloFWg2dFMCKH4MfiITqbexPwcFacxdZa2xansI3DcmVJxr3ad+
	oqdRCMMZR+Krq9
X-Google-Smtp-Source: AGHT+IHN52iDsRUI3MC45fB2NHZ78a+PI04sVz+MJmf9Pj70BNaVdCA6rPCjq4NJ6xqIYAMwjrcKOA==
X-Received: by 2002:a05:600c:4693:b0:456:19be:5e8 with SMTP id 5b1f17b1804b1-45868cff3ddmr60788825e9.20.1753365406597;
        Thu, 24 Jul 2025 06:56:46 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:46 -0700 (PDT)
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
Subject: [RFC][PATCH v2 27/29] kallsyms: Annotate static information into Kmemdump
Date: Thu, 24 Jul 2025 16:55:10 +0300
Message-ID: <20250724135512.518487-28-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pmemsxgc9e7jjxpf4j6t4mxqxih1y6uj
X-Rspam-User: 
X-Rspamd-Queue-Id: 0F401180003
X-Rspamd-Server: rspam02
X-HE-Tag: 1753365407-168568
X-HE-Meta: U2FsdGVkX1+vx+yrMpiiS2Xe0ynXM322ISpoGt3v3hvI3W5tMTYu7Qq6ejMD9jyXnWfp82+j0BPIbPEyRi1/BFFcYW81lMRy4h0olzapOMA6rTjhAncpbBfW4LuiFbVozZ4w8Jd0dr8t1UDg6r8MHxCcx1YYPRx9cqHbDJlJflmqWKunScv781gBYvbkjx5jTD5B+paR6EyYBgT8Mx9bsN3oSaDUHPiVw9pBabjPE6oqQTYWmkMUNDb+IQ+TWkSNFbaYFLOQHnHb4ZzQAuWLxBLEpge7g/5oqs7Mn/TbmNeoHsYrzQ/b7/qkMxIiOKjOmr3FNez4/3jBldnX578fmqpVyXdYE5TKzf9V7keZSQjcrVdXleaoAWVQ0GOVml2igpttFlvsNO6AclRY/jmtwgAJR/0H1EyWqDlT7/A9PRY7Jvsfl00ZfRbtl5V8Um9pUJi7XSEkmXSO8UExZrQfMhgfJByWw9xepaYAdBBavGrVJEgP/42or2TyI8/i7aaQjjz/cPx4iMYK/3z27GfdTqk8Z73uOKMH0eW+0vfvgnUaA75YP4AaJk9geYAYCeC6v046nThogEaKo2isKp0H6/VMQLKhJ/xmPOfKWqMx+n06R4CDZylw7MzDLqgS1xk8phCC3IJDpMNsdv9eCj+W6vK4kCtwywWHMY8CRIkvsi1hK0GSPb5xBqfEbTLKJU0hnfq5KzhpJo4OPRaSDt6XDO1gGzCAeeqf/PnVBgpWY8uDrbUL220h2hmy9jLon9h848cK8HjPbs6VCE+hbqy4oRiccpjIb/6Am3a0IVNQT+r2FHg7irYaMKc++FNvw3yOxbU2v+kX3wL8BZFck8WGcaWHks4sbCbLgSt6mHNj793rTOcFGhi/mGHrZJtFe4obexCni4FgEns8Q3Uwd96mY4KxRPbKzribKPieN/dTFw591xyJJyVL837sX4YH0efuyovfK2PAR71IRlNSorM
 KELZauCM
 Fmafvu9iBe+lM79igNWoeaVj6GDXvv68V9uoHP8f/qUUrRbHBCY1qorkrCwyB18w9fvSYUNx4QxlxnUPltS8YpVG3K83Z8jLQY+0ffxWWAm6nuT6rUPnizzSEriRB9m8jqNId0+TeBbLB5L0RskHudfuusNcyxlINCSKkTV844wf/MD9FK1cBtm7KiNFHTU/ERV5AK4Hln/ptyfEmBVpUbFO6CLUMBFI2ujXR9D8JZ9Cpf/sAA5qdVbFfodaHH7kS6z7p8svZlVC+OX9rZmyTj3LKF/OHYLBXSTWkeYcZFBHznSA/Xq31P5H5HGeNOsdVcvzniwEtGOYZrXNMy20jmJpXWbZ/IKfFjqOrgd8DP5fY4Ovu8rEAPErwgrT8VOORiMokVHEBmydBseo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into kmemdump:
 - kallsysms_num_syms
 - kallsyms_relative_base
 - kallsysms_offsets
 - kallsysms_names
 - kallsyms_token_table
 - kallsyms_token_index
 - kallsyms_markers
 - kallsyms_seqs_of_names

Information on these variables is stored into dedicated kmemdump section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/kallsyms.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 1e7635864124..442dc13d00cf 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -31,9 +31,19 @@
 #include <linux/kernel.h>
 #include <linux/bsearch.h>
 #include <linux/btf_ids.h>
+#include <linux/kmemdump.h>
 
 #include "kallsyms_internal.h"
 
+KMEMDUMP_VAR_CORE(kallsyms_num_syms, sizeof(kallsyms_num_syms));
+KMEMDUMP_VAR_CORE(kallsyms_relative_base, sizeof(kallsyms_relative_base));
+KMEMDUMP_VAR_CORE(kallsyms_offsets, sizeof(&kallsyms_offsets));
+KMEMDUMP_VAR_CORE(kallsyms_names, sizeof(&kallsyms_names));
+KMEMDUMP_VAR_CORE(kallsyms_token_table, sizeof(&kallsyms_token_table));
+KMEMDUMP_VAR_CORE(kallsyms_token_index, sizeof(&kallsyms_token_index));
+KMEMDUMP_VAR_CORE(kallsyms_markers, sizeof(&kallsyms_markers));
+KMEMDUMP_VAR_CORE(kallsyms_seqs_of_names, sizeof(&kallsyms_seqs_of_names));
+
 /*
  * Expand a compressed symbol data into the resulting uncompressed string,
  * if uncompressed string is too long (>= maxlen), it will be truncated,
-- 
2.43.0


