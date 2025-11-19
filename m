Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD199CF3942
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:46:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E35216B00C4; Wed, 19 Nov 2025 10:45:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE6286B00C5; Wed, 19 Nov 2025 10:45:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11156B00C6; Wed, 19 Nov 2025 10:45:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A222A6B00C4
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:53 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6648814026B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:53 +0000 (UTC)
X-FDA: 84127782186.11.7EA1B9F
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf04.hostedemail.com (Postfix) with ESMTP id 613304001B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:51 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=DCT85G+m;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf04.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.48 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567151; a=rsa-sha256;
	cv=none;
	b=x99YPN6+lYNXbBRS4V4dRQ7201Xl+8DoxUlRTD3UJhhbSl05vNjpV7a+ivrnu36QmGGx8G
	j4RAcVuTD5d0Cg+qInvajAx5iqrPkM8flqVnBlHeVrgMfWW/zvC0xtkwQO1tUIQ8k+2Zio
	IhxT+j6iP7qw6L26EFkoR/GM3X5aF4c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=DCT85G+m;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf04.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.48 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TG3MkEScUQgKy+QWFE7rEK/ceT0KdBZscolLPvZ1jcY=;
	b=MNsidgGjlkHGoGFz/C88HWt8ygUgxBhp/PZj8yoydA/TzETdl3TpFpIs+1RWJJrqsn0ieX
	874H0gAzNrRBmoOBC/mgDs8BTyZi0B1KDCuAfZQYFHT2o0yNJ58hNXTyDlFoRV0704MGV0
	sIj72BP5G7IURZSLjgE9DYoELXSxHCY=
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4775ae77516so75161965e9.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567150; x=1764171950; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TG3MkEScUQgKy+QWFE7rEK/ceT0KdBZscolLPvZ1jcY=;
        b=DCT85G+mZ/O9HXq0sn4Wg2ILeKrsHhLg3K4jPGm8nUKe/G7sLirXVDyFULax3eQzTF
         njSb1rIRYowbbWS7+FCAKmMKk89Afo6cNtCrlNXt9pA5TqOuycBQ068s/iyszbc0vERM
         +FCpW0Rk9zQZrEx/qLSP4YJHy+4xLQY4Xrd9uloUihJCBqK1J5XRtwI9nXJpYt8kxh2l
         lJZp89XmCvf7+OEUkK1D+ukpdCZ6vVBPknnasjCXcoysbGq6rYHYOMHyNuo39+r/3caJ
         XG/zEvNfRFODnvocrk/BsiQ23YyqRxmjVwzYI64d/52G7+lV+flCxrSVNnW/DZtQDgI6
         MmmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567150; x=1764171950;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TG3MkEScUQgKy+QWFE7rEK/ceT0KdBZscolLPvZ1jcY=;
        b=gm7nHnEG0zx9ciqluN2pHsdEhBruji3bar/qzujU0scH486vdSVZ93/EHNSyICX/VG
         bo7alpfYhq99Efohl4P9LmkMlE/qgYl7TdzppX3tiiMRtttuo4uNRSQ/gh8u63kt9xl1
         oesYUxG+puOPWKGr3h/hVptrmsI4NMafsqVLXuTyzDbf+m2NTrFhd6u4R3HyRAcWwDQk
         Pj5Xjm+vfuxoMOJtzvr1TPYCn2dHuaXIsH6RA3+BFlm2qDzXUZrZrlr9SlluWwhCrpgS
         67lxBx3TjlxBsvMvxHB+OOsa6+zH+Ow81+tQIJsSPqkgtSb64gGmGnEVA/Pim3dIRwJz
         UACg==
X-Forwarded-Encrypted: i=1; AJvYcCXJNCFcr32Tj4OFovvPr4w2aQIlCTv3dkiMJO9EUGF1meoSjEKcavtP1C7PsewD4Tz7ckonY0Lb9w==@kvack.org
X-Gm-Message-State: AOJu0YzJzuZ+7rgnXGGNwwB3cmhz0wKcIDC8xRfalirVSc2uNEBEplk8
	1Xh7GSZSQ0J9fK9saBGUJT+pJxjfkV87pbk9+o2PcSwoi6+q/NdUzdsLY3q2zaAt8A0=
X-Gm-Gg: ASbGncv+XhIY0+JrXA5jm18lRxsEw9VtzH1WIV0c6edj/fVG9mjwG6eDKCOFVPjHRYV
	V/UN/eRTW/ZpcuU2jj7yoIm8fYXAv4MhamxGNWuJ083trkEYYVa29CrS/el2UatRRgWkukEfQY+
	W8ecjjFHfCQG4mY/BxHSK2677/QCO+r6J7AveFb86yxGTD3lgik9nT1DbMSINWka01cjA0MNdhH
	i35kuMpbMkRfpvkDv+c9/+GQZXHL72bUD9UGF6J60OvJPiBe6m8TTGQIWH1nO/QzFL1xxKxJJVh
	dLChelNyHoAu1jflVTompP5uSWzsRzcbJxfHJ09G8ADUJgb9uLOQdF+y4LbxAuPcw/9UAXjOJNT
	bXfKbCh/j2r/+dRnpgttQrWJxJwQ+eikQ+qzOCbpbx8s047jkJHrRtBG3TdwBrdqGjMFEOu1mjB
	6rZawoveXnoL6AeZGUt9NCp+dciAzNUA==
X-Google-Smtp-Source: AGHT+IHArpVzpD3LO0mA1+dNKflLF3LKgYCdBzRW5r7OQjPk30YRri90746lAxdaW694nNfBsFGkIg==
X-Received: by 2002:a05:600c:a05:b0:475:dc5c:3a89 with SMTP id 5b1f17b1804b1-4778fea881fmr202472465e9.34.1763567149948;
        Wed, 19 Nov 2025 07:45:49 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:49 -0800 (PST)
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
Subject: [PATCH 19/26] mm/numa: Register information into meminspect
Date: Wed, 19 Nov 2025 17:44:20 +0200
Message-ID: <20251119154427.1033475-20-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 613304001B
X-Stat-Signature: xaywoyyik4hfa9ifeyaqzj685ofdab7f
X-HE-Tag: 1763567151-887291
X-HE-Meta: U2FsdGVkX1/SRu4NwMOUJ3UovyGqZp/XVICNUCgLGrPadmgOON5v18nFLdwLjotWVv3lwoqFbeE4vtJuhY0zZEKLVqBrNDh5rK8BIWLFh62hoSyHPIyVtLWREwGJpdxj3pXAO24edXP2ZKNBL/Kh2cfwhFUGmgvtGNQUOhNSysE36hCohIISarAd5+q4w8mfI6cYRTfiyCtuOXW2Cf0ILXug39EpN44vOI2v2JZjJFmiRWHPYOvAnoYT8u39gambtFS/zAdJCEnMWgON2hrPH8pE6ubpiIgRZfW7eNnqFtY6mHQvDERRv8Y7yVu9mXo8KH5awPsBPx2y5RcKFlJa3jHiVvxvl0FRBWCX6UfOLKETJkIQGScPVVCTziectBkb1kln9GzHvWyMHJBLwyKpDSf1EEX5FxOvPiZF7febBNecnqYhVho1vg6AcSngVbrhIQlSEJUsIZhLrmNpn2fIcQZUOTSQzKniezO9VYt74unLLwIsLJlKcmZlIu8qOS5KeQyh8W/fzh2PREWiEc8VfvVG+wnsdqVFWp0Ln3Its9w8vt0qxRcTi1+EVYkf1TDzhlznSlMRbNWc2JVifc1ZDqEtatEzqeEdCvRE5Jk8Cc0xh4HK5DTf6uOgdf86TbFHZ0ivetZOlUbxmLqvyIEn6+8mSFrAoZnI7VCByh3eNGIqKsNFO0e+s6pdbKfh5D7iAGSm/o3Akef7vDMLzV8FVXswIwWajBzpc3SSpYRu/gXWGzw76u9vNG1OgdtDU7Bc7AQotMECpwCZETTzcaFpnFewk4MkjtHtmH8VKGO3r0SeqyfGRH6kLnWEfiy1JnljUoAnD3tnq02qlybVWlY+zrTcbmnUm/lBIABL66zsjTFmQ40S5rejShHOtVP9X5O6KvalKDMNY3lv54NKQR3NJAKp4K1OUPU4mD+7BfO5/Ij4Pu6xQIka+E0QkEEGMf2w7jIWrJYNQHAn3Z8WN65
 h/m8Dsq9
 /LA1xBhhT3SguHHAIantsmWCaAAS1fJlJBHBh2OYHGAzW5t0Uge8eGDlk01oS/BD59MRj+RHTk0UAerGFhoAPzLQcGVBVa4ctbtZAOpldwyeInay/QNgSlOl1WuJP3xD6+HUoLzg3FpEeM+ckbMGMPyH6kfzggi+SjALyXgOsEEk26K+BCwjUDYWvFD74oZjrRH0UA5Nzoj4HD8nIS30kw0cVyhND4aHkduCV0RXjZceqSVoBkR9gDsZXdvaTSFugf51GAuWQfFz87plpI91vY/DEAA9p8puItt9WfxX3w9iD7wYvLBDXH/irQyI6QVUzxr/SiJBKx9wZ0uKuNm6mmouiHAK+DjUHxnexrau1HemEt9C5ORDHEvDEXgQmC+jOQS+9fdq97zEMEJRFNo87Q/H+J5RyVEx1oVaZG7xpuSAayvsWerMtB4y0WH2e1acq0/8PDjCzqaJqVEw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Register dynamic information into meminspect:
 - dynamic node data for each node

This information is being allocated for each node, as physical address,
so call memblock_mark_inspect that will mark the block accordingly.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 mm/numa.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/numa.c b/mm/numa.c
index 7d5e06fe5bd4..379065dd633e 100644
--- a/mm/numa.c
+++ b/mm/numa.c
@@ -4,6 +4,7 @@
 #include <linux/printk.h>
 #include <linux/numa.h>
 #include <linux/numa_memblks.h>
+#include <linux/meminspect.h>
 
 struct pglist_data *node_data[MAX_NUMNODES];
 EXPORT_SYMBOL(node_data);
@@ -20,6 +21,7 @@ void __init alloc_node_data(int nid)
 	if (!nd_pa)
 		panic("Cannot allocate %zu bytes for node %d data\n",
 		      nd_size, nid);
+	memblock_mark_inspect(nd_pa, nd_size);
 
 	/* report and initialize */
 	pr_info("NODE_DATA(%d) allocated [mem %#010Lx-%#010Lx]\n", nid,
-- 
2.43.0


