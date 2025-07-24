Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2339EC83F1A
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:56:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D6736B02CE; Thu, 24 Jul 2025 09:56:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 339106B02D0; Thu, 24 Jul 2025 09:56:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DD1D6B02D1; Thu, 24 Jul 2025 09:56:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0C22D6B02CE
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C4B8C1403ED
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:31 +0000 (UTC)
X-FDA: 83699308182.25.A7FA11C
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf15.hostedemail.com (Postfix) with ESMTP id DAF11A0007
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=p+vYXEkT;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf15.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.52 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365390; a=rsa-sha256;
	cv=none;
	b=pNyGb1pyoqWo/bvevqlYRbufg3tvi7Q/6vbt0WUbgZ4dkGGSSjufHC84btYORNTKX/rITn
	R78RfKVeq7xrjZfFj2IdgQiyPuWmFoSVeSlA42JWuhu9pN9rYdc2jpRpkcCkc/rFKyCBNc
	9f90f2mlO7OACtLQxe6e3Jy3XWSvXZc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=p+vYXEkT;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf15.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.52 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365390;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o/nDqiXo0oPmiwRgkXmDbqPxo4RR6UizLNSv2BWaLmE=;
	b=3m/qHdzLh1vjg1VDcS6VnbZZjJWK/7V08P9+lfMnHiI52sT8EIU3vkQ4TYz/zBR1B+L9Vx
	HI1SOQI3TW7hYXXYYlOBzka7yH8lP8d8Usv7Wr4YIK0xnQxsiA1m9MA50fV5SrMmL9c+7D
	ZaU6XfDnrbVyXJhttCGkLlXrI41Qbzo=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-45634205adaso5029875e9.2
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365388; x=1753970188; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o/nDqiXo0oPmiwRgkXmDbqPxo4RR6UizLNSv2BWaLmE=;
        b=p+vYXEkTevBOoK1owlLmk938dTtDFxZRYUHnGK6cDiILQyPytF96ePWubyhnsXI/Wx
         toJkU+AhOgweUUG0/bccmjltqTGCWyW/2RKMjulNs4gzziViF1L3DFyXjIkRznig6TfW
         ZszotLtz9cAcXzbuhzbK6YBXyIgUC+uIb111glUD9sjahfRlEz2/y9hL9yUZ+Eq3AvqB
         YnUjZdHZdmHPUK0w4xFNdvrd1Jn9MFAv9TTvQw05UKLqF08JAc1BNVOiNlijhbUVAMEO
         Df16ljB2AFeygo9FkVOpaKX5yWuNy96xfGWpFeHEw3V1sc8lTCikdDrdgKR6pYDiN8Mc
         TlmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365388; x=1753970188;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=o/nDqiXo0oPmiwRgkXmDbqPxo4RR6UizLNSv2BWaLmE=;
        b=ZV3VRBw0UGgWTbJUTga4/xpzC96tyBnHegUcySJNSJ20OfhgI6iaxmWRTUdt5cFbkn
         bpL9sGd1wXorMRlNpFsQvbTLHUNZRl+CpzMoiav4Qloa3wFWFbC3D3zECYMDUEKy4+kl
         x5BveUq9bbv1nCb/5VDw2qnDOlYcg92ym1wTM+tTHEz2zeTbcCspLBr9Uegbg7dP2Qmi
         ttW9AVwRGP4VdPmmsjIPus5wPNTc1b6gzbpx0ODahstRtc6p9vgE3dXCzFr65ttNLvnv
         YV6D5wK04624M034EwGRXizp6mUe9+10d0QCjAMvjXNOtqiPUM6S7ho7lr3lfW/5/I5r
         ORrA==
X-Forwarded-Encrypted: i=1; AJvYcCXhCV1PCsb5N+aNOuEeJkt9KZarhtXMoqtezzfWSpesyYQT4Iquhvrn+ghDZDXN7aL6iPwpIrr48Q==@kvack.org
X-Gm-Message-State: AOJu0YxIauw8Atj4i8Wh+/t0vwuGgd3eUm/vupWpLmuMBZG3fdJHyuar
	5CBNYKgRSRG0t9xyI6Z2Eg6VIZBnAKVL99q1zRIMF4hNJesCbt1AxSnTzfu4+V4FYPo=
X-Gm-Gg: ASbGncu0Y0Z6skwCthPWsogm4jOBsY4tzEyHRFwdnXMMH3kx2w/v/Sm6L/BfAGEx2xK
	ek3hMkQStu+zZa6n3vORF0g9zSuAPLiyiT3wI7Z/qapuV4v8TpH9L83j7H5e2W/9L/Vj3a7JxNU
	Kd9EKIDqDdKQsbjz3B1pgcBcRL+Re06hNkvHdJ4Ls7jC3TsTRa3gTmHxlZm+ABSUAgv6sjhs++n
	geUzHwNYpIf7SFv2TgRqZv+Owpoqv0sUfyvx9tQtddC0EVammyefh4wFJA2KUnFlDqMPD97iSLm
	82ffS4OvWrE9iu1y3QybMmFU900+dTl1cSsF2WWjPXRWzrGVcZjD17MdryN0wIyZzZfCGT4TWBn
	/N4dPYLLe93Mzrpd4sVXxKK/BgAGbGHC3F1qxMWQiO+NytXIwq8mXZk9pfYtWePw+btAb7aOWaG
	DLPJ4C3TMK9fs4
X-Google-Smtp-Source: AGHT+IFsfIJWNObH04glJtR4VMihBKDX2X1KMe4027IfQD5dai+xqhfpETfw7nG5oExxx5Qg+IUmng==
X-Received: by 2002:a05:600c:8719:b0:456:2ce8:b341 with SMTP id 5b1f17b1804b1-45868d47860mr71077715e9.17.1753365388431;
        Thu, 24 Jul 2025 06:56:28 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:28 -0700 (PDT)
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
Subject: [RFC][PATCH v2 07/29] init/version: Annotate static information into Kmemdump
Date: Thu, 24 Jul 2025 16:54:50 +0300
Message-ID: <20250724135512.518487-8-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DAF11A0007
X-Stat-Signature: mqts3866xktzkxieh4q17qrum1rzwonk
X-Rspam-User: 
X-HE-Tag: 1753365389-482873
X-HE-Meta: U2FsdGVkX18sqH2yZvMPNSMQnc0UrwQE1/4rXgbkBlPBItWcxKTc68mAO1AjNctgFvQfBTWqbibtUDnDeqIT9lMV4fe5Gg9E29MJLrW4nTKXb2uwR5ui6YnxkTCmzJQemdLW+weV9JTjDEhlGZy45wxNyWr5CxgfI4W1wgv0+PDeK0K5XyBpOdPIe3dlEOio8GHUyfQsIQ5r9CpSEUCqrRilL6lVkgjmiSpWAsfdSOp9CDNK3Y43IGi8kHxvxEZnXbxywT2yNEhzt4NX9XklJhzQf3DOa7R4d4XBOVKZkyHybUKMt/qbJ9Dn48PW7QIGXfPuO8d0Qctqp6bkowGU6FWpImHB/JOAVtn3LJEqrqxPbzDgcb0XEW4nLvmc8MTAz+bsGG9MlpDl+ElaglIclqHceVDaPds4Ryk/mMnOgR41HysY6ChRwm57ZL4nd9hA1hzQiPNNkKn0QxZd31s6Mr0E7OpKTljL6fTzLakEz0IPLurV0Mr3kGwbR7XSNmfmqTZJezlNvkpSag88Ok16tRwPeEQ9AmlvJqL+71bHS4oGtfXUFVfBEuR9Ek1JRxTB33weers84WmGcoXn0Jfm8JEvWxZcPafvJ9mFm+HH2Kke32zTaHuSMyF9LHv8vtsxbkn7EQXunJTN0j/nsmZYY4yAnbuemSbdwvCvy2NMiTYBq9SsOfyRvAJnG6F8eEJysPyV+750cD5FbXCyi/DqdD06ug5kcIGiZAsSZLj5WCejp3QqosYGbnXNKDXMUWEp/Q/eeGVA1eJNNefnSNGGrQoE9TNAGbTRhZRcZIMBsccBfxwZZ5w2Wt4DAOQNDxKGCrdH3rz/+BsFXm8OaPxKKcRoEgIV0ooT4DO1UQzNJEr/XychP6c0+W4dRrk1UhrOJ9Y02EGIsyctW2tymzlmhJpsTmUKlKDgR2zWbn8zHuiC5y9GpokOOdNLldzFUocNbtMYVd1eAD7wyEBQjIz
 WHXj9/Gh
 sDl6eypm8G8WDcLsmoTL/eEsEp+diutcIpOd7Wwja8Jw2x2cMni8T00rYgx0hiK/6eutg/HHp3OTNpZA42JUUuVvj+QOANOIwO3LQ4v47kihwHZST8s7ybqD1+mRB0eCsCttEZVhZuAmVXRSLHH6ASKe5NBU0UyS1/6DXX9yBG5sipueUFr94elwAIUzl7rO5YL89TjmaRVK5+M6xjKAT2V8MiP0HhQwr0JkFKajFLktEHh+5bXwhBfXn/hR+N/UEEN7KZkMg/aV3ValL31SW3ZO/kgMpXH9QWAHgzYQz8UwU9AXHMt74zkPdG5jMlXHIsQF8Wh9GYvtweG0GrfFK0Q5eRwwOsqOEqnKqBKcLaIqZjA6SOD2utXVafAwycUrfQ6kWa/IkMt/5DJY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into kmemdump:
 - init_uts_ns
 - linux_banner

Information on these variables is stored into dedicated kmemdump section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 init/version.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/init/version.c b/init/version.c
index 94c96f6fbfe6..f5910c027948 100644
--- a/init/version.c
+++ b/init/version.c
@@ -16,6 +16,7 @@
 #include <linux/uts.h>
 #include <linux/utsname.h>
 #include <linux/proc_ns.h>
+#include <linux/kmemdump.h>
 
 static int __init early_hostname(char *arg)
 {
@@ -51,4 +52,7 @@ const char linux_banner[] __weak;
 
 #include "version-timestamp.c"
 
+KMEMDUMP_VAR_CORE(init_uts_ns, sizeof(init_uts_ns));
+KMEMDUMP_VAR_CORE(linux_banner, sizeof(linux_banner));
+
 EXPORT_SYMBOL_GPL(init_uts_ns);
-- 
2.43.0


