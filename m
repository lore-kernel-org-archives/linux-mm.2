Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20A51CF34D9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:45:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50D956B00A0; Wed, 19 Nov 2025 10:45:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46F3E6B00B1; Wed, 19 Nov 2025 10:45:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3104D6B00B4; Wed, 19 Nov 2025 10:45:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1AEC26B00A0
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D3EBF16053B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:30 +0000 (UTC)
X-FDA: 84127781220.26.2CFF195
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id C8FCE80022
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:28 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=ciFdpuOe;
	spf=pass (imf02.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.44 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tjfIjN6LzAYPexJPKxlzOegJPOplIDmw8UmBc2QBBmw=;
	b=URdVNiFQyZk3YANhD2WQM3hM2z+w6G0tGv/WWwxwBzJIssxCBXbVC9FJLKVGFlWHr62+kn
	UDNMbU52Tow4tjYoxSrU4w+PoqVnRcC+b4Q7peVPs/seI3fOebkT7WomKCHoy5WxU+rpiF
	X47mIv0LoyqrayiJTF9ulKuv0bQ8/RU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=ciFdpuOe;
	spf=pass (imf02.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.44 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567129; a=rsa-sha256;
	cv=none;
	b=JA3yXFQ0OTxJieaXotG6vYYSxynYOHtV5KDawFTB4kGfgk/j2KrKHrp0i2Oj0ZOadmEGP9
	7WuSSLJiym6MdtiaAGDm/l+ZsoqU4kbF+qgfGY2K1HNavjlGOHft/hjTTcXQL2iTQL70Fq
	ZWXXja2T7ccJtVX8P9cz9ztY4qihAA0=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47789cd2083so46998675e9.2
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567127; x=1764171927; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tjfIjN6LzAYPexJPKxlzOegJPOplIDmw8UmBc2QBBmw=;
        b=ciFdpuOe4uQKbzYZnf3uh2YE0q88w/GTl3fYaJLOqceXmljY9rqV71GRkOBu8PtRH1
         BFAJ8AdXmfe5MVHLhxQI93OLYXuacBNtbppbzSfqn7UXsNH0UFCvsugEuBgYSImzlv3W
         6ekBu4oWAF1Xrxwkzp5bFeViji6zDjiV4gJAt/y+dkDnB8iPtqXJoP7OzRcR4jS4PA3r
         smjYG2+jBR3DF0BT4MGzUjzjRNWkPo+aOvTlEs47KpTs34KWq1Yky0hv3qqLpuf7LJzA
         7u62RlVW1SQriYsBwIVct2M/6bg0Ji7MCl+2eDj+/mgiNN2mQKNHeV+XIjdtMdG2tU8K
         P2JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567127; x=1764171927;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tjfIjN6LzAYPexJPKxlzOegJPOplIDmw8UmBc2QBBmw=;
        b=VY0z5Pq5oMyWd2kPz1n5XNoo6IMTyWR0RC1IjYcPYbNl+dtU1oiw9Eu9dqtbcf561D
         p2Oek8MA6aLnex4yyL1ohM14tlLc5HBr80b6oC9jr3z2c5JJndmr0rL77eNC1LRu45Av
         aJK6kFSETxgvTtdJwcHOquAl/+4uCB7ZZIpIwaWWanQM3jlECiss351FlWMrDj2b8lOF
         oPMk2OYWtRkvPHsPOBPN/Jnx0Jol5cq7EY4dJFpiaYgppaomTamxcY5SIh10NIFrculu
         I1w/7n2GH2gtxu080o85E3hGgPRdIh53P627KHCaI4ozDWp3hPMmFJNyPf9RtJi9C2Ae
         bHNQ==
X-Forwarded-Encrypted: i=1; AJvYcCW7OGd7ZglnzuNiPXTxjth6PWXi7HWVJuoE2IEDH2sUEKCbiTwnU03GymbfeAfuXBlJG0JGu44p4g==@kvack.org
X-Gm-Message-State: AOJu0YyPWXRGBp15F3gMDuXxnqUIjpzuHlCFYYtNLWblIZ59acWB0TfP
	fQ4eEIJEoJiN8F+XHBOuJC+yeizgdhrfA4jx1bGf1zmC3tjWcUcEuYAZi+fJVcj+FTs=
X-Gm-Gg: ASbGncvYAI4+SygOUb8JLUs1GjY4yqCHd0+zqGppuSvvIjJI/hi+k91V4VIsSmO8+6s
	T/ujnZnOu7moYrNS0H9Yt6Ydi9PBpwRRzn0a+B4G6pTLt65qcJQ9wkyVqWRLx/QDfRasCBNqhfU
	HRy/IYPMmPZFDNIeQDlG6765HNg/b6729STiuYh9z6CqIM60ADaVl7f/uegOEbI7gngjyBLN3Q4
	6tTHwzD+d2Y7/MH6ZiwJoHLDRd78uvwwF+lTV2exjPqeTjiXwl72+IRboATsjU2o5Wm5u9YFVKb
	RJtZgjdupMBE3ZRjl95G3TgMkjvPwdoMLpmEoG1OKsEG7465E/ETgcAN1oGDfrefnNB6geDjknq
	8IvkdFMafjL2TSLEPlZyBNDs87aFfmoypzTNElDp3X+sfwzGyKDqmGvu2H5Dp0Sw4qug/kVfRCY
	s+V77u+a0ubisvTsCWfOP2T9knv2Rnjg==
X-Google-Smtp-Source: AGHT+IEfh56DkbcMOsGMiLrQQwNoxfW0lTNMGX96p1i+gi2+G5lC/DiQdo+bbBRy4PiX1VmL8kOK2Q==
X-Received: by 2002:a05:6000:2a0e:b0:42c:a506:9dbf with SMTP id ffacd0b85a97d-42ca506a058mr10726960f8f.39.1763567127227;
        Wed, 19 Nov 2025 07:45:27 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:26 -0800 (PST)
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
Subject: [PATCH 06/26] timers: Annotate static information into meminspect
Date: Wed, 19 Nov 2025 17:44:07 +0200
Message-ID: <20251119154427.1033475-7-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: C8FCE80022
X-Stat-Signature: 9tawiycapp8x6m9ry7wjtizawrjryg3u
X-Rspam-User: 
X-HE-Tag: 1763567128-442737
X-HE-Meta: U2FsdGVkX18ESAdKnTGWsM33NYe7RFi568eHhZdikv3RZrCxB+Bx2oFP3Yp5zAqyr4S5Rmpztfvy/nxMxaMA/TPfiUdiSMjBXcc8F98sx4+VwdynX8gK4Yo/RhRHWdS1H3B1ihDwH9t0OoQbn/jMOwbmYzsx/u+pwD4zb7OxAN7HQ0wcdrIOegOMKEef3DoL3n2iLfwHWy7UH1sVaFVZELvQiWKVY8qz4ERGkHrPhR1+atWhMphR3eccc9vghZHDj40I/3YOgaoneDna35+gTUxTWQsMb/eE3yFMQgUXb92qtIfnlwVjz6ebautoaErEsuGptgRTUABM/Pu4xnsKRW398I7L6A9gKX53a5GuZxgb9zRy1Y1f2WKcglPfFVqoXGSiGX9QtAF2sRpaS9xMtZp5DvF9KlrLd+pStV2Y3BMlmBxK27MxR8MdJ889n8ockSmXGPWj7IFKrkPWFAncu0Mz9SX26UyqskwtXzywqJHtveKeddbxXYtulPRcKzbxatH+vytydJIE/RxqEJd7t6G+aR+OK3/hSlxntDmqvbzUhsOaXIvA6K3Tng/paS5JVM9egFGJzA/BlNipF3NI8nTJAfwCgFFs6j77dmGAhHbtEJ+IXOt9Ta282vV+CxpZN2NMFBB22Lob4R61pcRsVdp4NXVTKlvtyBZDo7MRMF7AOFmgiuIWkVBGDUB+hmf75AEWOpN6DpTSbQyJwSW8vA3iJVyyHa2G+SsIy4A4+WosWjExWbYRZ3QtVVKQ3/bkrvAdmhOBAHxk/HBLUt/faE4SlM9rRLFAtDkd3iiYyaOXSjnwFkLtC2qQGQgz3pFnWX1j6GedTtA+I5ez8J6Zg5ZkU5Ughtxh9m5P7fslcn5jolDxWrjN947cB0AFzqbJoof9M7bcGs/xMqgnDBXki2BZ7ndgMhiKAkEG6xU8tT9+/vT0aXspLVbFEJTOuYRcMR7udCqnUqwarYIKR7J
 uDDavOHQ
 s/hbnB2WWwKXrGZxJZQGyX7k7Bf8NFEwEsHka8JjEHri/ABgJl0aawXbtzmlg+DOjXmGT3eTWVcuThuGeb+fznoWhMTqk4LUDoNHbENXnF7/PwG3snd2vG5WhA4/GiuAH1zo6cienlGl6Q55l12xSUxl3gsdJ6QWfmtxeu0DKGpoYSdHsJYKS9HpPFPgL/btNl3NZxxhQ1oVxIWUlzmG6FzXVAvoGtIXTCjX+m9i6Xr+C1bvzRKMjqYzyDPirLUG4LscDxhI6nFxtQ2QUFms67ohcivfwrgEaNl0dlr2fnG2nVIMPyBMJXTKoEHgZKGLtwayWXPPTYffmOGhZF0WRQmQnFeX6cYhcYvrJRWlAueBu4WSjsGQg1+0FQ1zklZB6bmqad0LuPIgShlHhLpN28t4/bc2gLwnNJu/cFnoGsLYjUuywerc8IZMShkOfvKXPYykd0JJo+kWvojY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into inspection table:
 - jiffies_64

Information on these variables is stored into dedicated inspection section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/time/timer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index 553fa469d7cc..c6adea734b93 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -44,6 +44,7 @@
 #include <linux/compat.h>
 #include <linux/random.h>
 #include <linux/sysctl.h>
+#include <linux/meminspect.h>
 
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
@@ -60,6 +61,7 @@
 __visible u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
 
 EXPORT_SYMBOL(jiffies_64);
+MEMINSPECT_SIMPLE_ENTRY(jiffies_64);
 
 /*
  * The timer wheel has LVL_DEPTH array levels. Each level provides an array of
-- 
2.43.0


