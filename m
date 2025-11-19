Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74CE1CF3941
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:46:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9B66B00BF; Wed, 19 Nov 2025 10:45:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB0FB6B00C0; Wed, 19 Nov 2025 10:45:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A0C26B00C2; Wed, 19 Nov 2025 10:45:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 82AC46B00BF
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:46 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4BFD7C0517
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:46 +0000 (UTC)
X-FDA: 84127781892.15.6A6A4DF
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5DC0DC0015
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:44 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=tuKLbIOy;
	spf=pass (imf28.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.49 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VVYkZ+YGVFmg/wGLFr+Mopllp1/vePaMucgqpmR/GFM=;
	b=OhgTMeGmWCPYE5NQKEijB9zDqU08CeLRqVg/GxD9vEKcpHWLfJAgkKWWsORThFovd3Avcb
	l6GmYQnTZR0zHOn7IqIGxTm0HNmCrVvDDazx+ZKzJaSIE/3Hsva3tbNrGbImLYwCq5Qgxf
	/Q2BOSnwY0hoR+NuoPgZHezJEFePQVA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567144; a=rsa-sha256;
	cv=none;
	b=rQoFmPrpWs7jO4WKzWv5Ey+KU01KKxw8VrY6Rbx+RAywVrLEJ2bckMO+msYKpd8PqcqZd+
	Dwn952aHt/ETv2soA4n5B+w8/Ov/ZVVQ9dlTMz+mT6qaiuNqfurRki2Y4GPfjZQ/kDFWme
	RxXv8pJ3kJlab2A6qdQ1DHmNk3LkDM4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=tuKLbIOy;
	spf=pass (imf28.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.49 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-42b427cda88so4949243f8f.0
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567143; x=1764171943; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VVYkZ+YGVFmg/wGLFr+Mopllp1/vePaMucgqpmR/GFM=;
        b=tuKLbIOyOkgMAaTr4wRRtleL19Iybn5VpsQhU9I27FzurCavmz4ULKUprUcVwJDSeA
         VhHQOORt6LNQIy/uwhykQxQ92AaleX/v+xOwWfA+/69F9jyK38oYmLac2oExdT3RmoHq
         WG1kBvqH1e+pg+6Q8SwSf3JT/Q/GpWL5/kzcmfQ2qAynMmJQe5R0GbhZ0BOBkU37xOB0
         nnm9NaIYBfcmqskC0ce8i1Rj24JIEyzX3QfD+DAyqqHrPox+/OqUI9QyJvaJO7UELBtK
         B61zW9vza992w2BKJUMUJt11bUzJYEk+0ZMH4T1jcJchbcGIcHSXv+xA3D1gJAS1rD5N
         TF1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567143; x=1764171943;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=VVYkZ+YGVFmg/wGLFr+Mopllp1/vePaMucgqpmR/GFM=;
        b=tTueQ6cxTO0ryhNbjIWreUTSNL+f8YrMGMmTZBDMZr2cva9MRc9evSDYeJintt9YFB
         qTxYllSoCgkqoBPyolQZa1N/gKpPcz/A/4bHFnFw9U6qgJbW57huMMGJeD5TMB3NKCsi
         zpWT4KEQ1mxkYredoiHpxvF+/Kj8d74tsHP4kT1FY++tkiHBJS1GLIqarp6tUex/aNs5
         gbXaturI/0PgpMvg3NJiudOIyLf3VP1njUZSwK1JO3m4mQodiBsdXtQslpKWnojNYLPI
         9PIgWwHtx/m5jT6m7d603UKVddpwe8FUfPbo/jk7I6deYQa9XYdeROJm/v087khfo7FA
         JWRg==
X-Forwarded-Encrypted: i=1; AJvYcCWvFeherv7Xd9MSRIsz4UsedizzOwopZ7HBbZTx7j6Al4JZkvzx8Sma/l2BmXcknDWft5C8wfZfKg==@kvack.org
X-Gm-Message-State: AOJu0YwPiugL+ASJbMgbVoClpXSgXR5qEAkB6+E9fukRzqANH70cqdXp
	JCuc9xxWsjdTFndyn6xPETfkbTq13poEKFbK7TKA+xrdyu76O/R5wHtT4weJPrqh2PA=
X-Gm-Gg: ASbGncsSVm97kGmrZlRfa7aBCb+Al1pS+3Gn9UfrkWsAhcJ8/ijZqeQTe4f/k6Hg4r2
	0aQD5kptzOSx8sWetfIv7W8CNJ3fYUyUqjjrS4XvA1OtB4LM4FLNkTCd+pqmStRagCsXBg3Y2Rr
	hQ92Vm5xEe1Q5NNE9CiulsLaZzKwIM8F84e/gk0aHRjFuVb9C9wC3sdjHT7XzPJwm+Sh+IVNDZ3
	Vu6Zvin9z51XdXMg0I9i0Mtit3WoDOhvJ75uDe42/iaEFj5JR1RkTfpPafqhDMfLO/zTMhtSg1F
	xr0LON+YyJFhITf74OkIYU1GxrkS7EBs1PxOGhT2xo0k/t8CGqApD01S2R6FVX9K54UXnYAE5bN
	2PTSkt56jzRVuT1rOKeardaMiCxrl6YVOKCmmsNz7gKDTqxIPz3OjRh+ICjQfyIjy69q4fjQYHl
	+KMnKHAhW8+vADXVGHMy97AIZrRhlLJQ==
X-Google-Smtp-Source: AGHT+IEZRkUZWC9WWo9OX6jj9I/ZWQe6urgV7WqPXknOd3CwNTmQvHOBkmKtLsoZT2TI4A/OTOkOYg==
X-Received: by 2002:a05:6000:200f:b0:42b:3806:2ba6 with SMTP id ffacd0b85a97d-42b593394b4mr21022814f8f.25.1763567142926;
        Wed, 19 Nov 2025 07:45:42 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:42 -0800 (PST)
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
Subject: [PATCH 15/26] kallsyms: Annotate static information into meminspect
Date: Wed, 19 Nov 2025 17:44:16 +0200
Message-ID: <20251119154427.1033475-16-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5DC0DC0015
X-Stat-Signature: xtoqex1isf3f1js71aga6aroo8ria9e8
X-Rspam-User: 
X-HE-Tag: 1763567144-120256
X-HE-Meta: U2FsdGVkX1/fltf2PhpBVRpm8kSBwh4FDjNV6m7umh7qQTOFq8nWS4diy0DMZXyzWCdJA/4qo+lJiEe+OYVVPLR88wJ8AtlN0EZUzXeTCV+1fvJtXMTIubyOGEibI7dMdJFBZ58GCv4is6vLzpgLM0jNXcU5Lvgi6kp14r2ewtOv4W/GnekbZLNY4JDr48tPRdRPEG4YNLDkMrgAr6Born/JSG8uQgw+3MQG5ZbJE9SClOkrRVxju4nXQmUu/Ge2hYpb1OLkEvc+age+9GONIN0y6AC0U9cADwwWhkQ+HTe5awJM58OJG79hamBNlQfW5tkZS0teYoSBM8C16VUHEAt8WFLVuhzyvdLJIkzldtmg8o3Ea5pA+U3kdbCiHrJhv3/CLaJrjOP4anTu4JB5unTz2jD4sBlMNiEtMJ74Gqnr2R7Ls4+ogSCtWgX9Uk3uTFPwXri7T95R2ApamvtzW0xSy7B3Ots3cM1QYFuMCcwvIO6wXBOCL9RYOQ2NTb+4atnpKL4bjgdrRV6TlM0m9PaeflUKKcP5VMglHb2kHHYZ3io3pRkAYTjuqlhU2A3EmhaIj0XnVGN2p4123t68JzreYZ4RVIuyvp7qxsdf2OxsYBw6TPv47mHneW5Zq5SeoIMf2EOt6SbAMC59rJrUjp3tXFVjaidYi88nSoEn0PTW+NnznEEg4v1YmYBG9OO1po7Rb8TOW3Z+ZrSvdYTfRSn2kzabLHfM7XOtiaQkicDx1Gk7sqQc/49aA/znRZ+2AM70yPrGvuLniAg2vz7JOxKqo4QNDgvmJKdHGZF7OhqgwMtBHsB2FSxKtT2jwdspU1nUJjBo02tv0FrRISCrkNl1ExR615idPqXXpTXSe3y5YWVZi1zRtRk2a8P4ODzpDq345q813AhkvB+a5sBd3TkNQGkAtCldeCn/I1d/hrtI7fdThaL/aFGIvlUONG6pvRZrkAzWsX+ce5pFV0S
 evcJV6NP
 5IbgQ5XCsEDJl87cEsVpum0kOLg62nskY/HedsrJx8GaF2PqBtjuh6xhF8bpZbZT27Eo9mKwx/5IoLflZyofXAQojGTfBCdMAzxTEmcLTlhZytDdr7MBwEC4c5mTeYRELuw8Sl4lpw4OGAm0W1v8jAh1U1ZaJ8CLUaN7a1Va1Mq8HhFZ5zEnY1M4dclTKzcSorRuW52WsbHSL7DCNHldbEryECx4lfZwoZBD5+vxBupwEnD6JLuHu+AoS4tdkveM7r4UmSeAIOhMBmQzBtuxSz+Fj86kF9Tenc23wp+kHPtPYXpTaggxITcoAoUHy+sClCd3zvfOUMnjenQgQjHlXonBJYrRWcQy+jtCRSgWe8j7jaPTY9s3MZwHyQ3DQYa6CP3gqOr7kDP7IuiiQenXuOFiTq3vwYamCTsCzmCT8oFgxRzGNAXVESd999ltrVaHbGBl8TYTNa9KC/+U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into meminspect:
 - kallsysms_num_syms
 - kallsyms_relative_base
 - kallsysms_offsets
 - kallsysms_names
 - kallsyms_token_table
 - kallsyms_token_index
 - kallsyms_markers
 - kallsyms_seqs_of_names

Information on these variables is stored into inspection table.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/kallsyms.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
index 1e7635864124..06a77a09088a 100644
--- a/kernel/kallsyms.c
+++ b/kernel/kallsyms.c
@@ -31,9 +31,19 @@
 #include <linux/kernel.h>
 #include <linux/bsearch.h>
 #include <linux/btf_ids.h>
+#include <linux/meminspect.h>
 
 #include "kallsyms_internal.h"
 
+MEMINSPECT_SIMPLE_ENTRY(kallsyms_num_syms);
+MEMINSPECT_SIMPLE_ENTRY(kallsyms_relative_base);
+MEMINSPECT_AREA_ENTRY(kallsyms_offsets, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(kallsyms_names, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(kallsyms_token_table, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(kallsyms_token_index, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(kallsyms_markers, sizeof(void *));
+MEMINSPECT_AREA_ENTRY(kallsyms_seqs_of_names, sizeof(void *));
+
 /*
  * Expand a compressed symbol data into the resulting uncompressed string,
  * if uncompressed string is too long (>= maxlen), it will be truncated,
-- 
2.43.0


