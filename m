Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6532CF34D9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EB3C6B0027; Wed, 19 Nov 2025 10:45:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0789A6B00BD; Wed, 19 Nov 2025 10:45:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E347A6B00BF; Wed, 19 Nov 2025 10:45:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CBDD16B0027
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:44 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 910484E74D
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:44 +0000 (UTC)
X-FDA: 84127781808.30.BCB431D
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id A875A10000A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:42 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=t26X8JmE;
	spf=pass (imf05.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.53 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ERGSngcgAQCpMTKH+vT5ZfmIUQiWuwubvJ1CKsgHOkU=;
	b=u6xUazALVkQCWgQIv0LpdMVYgJGvdrFivImrZiWgr513Rf3gbJJU9K/lwxSlXf/MWh0vHL
	c66OVyvt7ny+YwxNgAbJDukg3NcJ2HXGbQnfn7pjUMYgxnYC91O+JTJImGjqC82x0vF23r
	8n7x0kQiEaelP1YJHkl+0d+GUMbOBnA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567142; a=rsa-sha256;
	cv=none;
	b=w1mwmfBNWUd7O+dkz/S5h2jiLsI8TgEBuwoeHAvvUrCRZ67IViWNpfLH/Emi/CWhY86h15
	C489g668WMw7hzWpZMrcWi1zR71iGjAwwPuC7Gi9PI5PoA71pWSvSn1rqNf2V9fb5fVLmB
	agCEFjfs1A5KMcYEkc0PKTa4THNDjcM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=t26X8JmE;
	spf=pass (imf05.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.53 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42b3b29153fso3747784f8f.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567141; x=1764171941; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ERGSngcgAQCpMTKH+vT5ZfmIUQiWuwubvJ1CKsgHOkU=;
        b=t26X8JmELihNYJkytxlUGBjQm3244ALF8EwLQoqXM9oJpP9SWOIyBhd+ufT7+KJM2V
         cjxTNqkkApT5VJgONToQPNvodHBFEDx1Z7054EESp7PNAs/nljptrFKS44zg4BsNo2zC
         M7AlUmH2bHDqhqrFbzkmKto2FyfxLfvmGpJ/f8/NGWcXUSTRtxjwfBlGLkPZPyTU6AQu
         ypA8lfeZplJBWGqplUFsA+RYUBbGRg/ZQRjeLlvSI3tgyXGKHuTgVQ3y9MF9bIfUAMPL
         uN1x1B3voLuh7oIRudvzLEOIM0HkSDX7RlzxVHNAxA05RjQHD9hWmvqacf2cvP9Q5r0J
         ixcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567141; x=1764171941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ERGSngcgAQCpMTKH+vT5ZfmIUQiWuwubvJ1CKsgHOkU=;
        b=E3BlEGR87DkRw0UxIML8w/S3hUAXEqfLtUM7GpG4GCcBfPz0K1ulrUwLvt5WKdiu5r
         enmc7kNqtXrBO865S6gp+CCO+NLek1UVwkokjsrQuXMHtsEY5HMbaLycylv6LOcclxqt
         UxzSbK0/nz2Rdd/rutA0jjeKvhHkGEPZXuR5PSX/4sPAKztmtYD76URt5tits1KDCOBV
         MMo4EuRWp+ZQJvwFOa3/trfeEelLHWisJEQ4B/9c2uRXAp3gII72xO+4MXyHPzccl6uT
         vVZ1YE42xdh0/jOlHDSwFG9k47He2wT68WziL6vX0dAb3NoKYjVIkUfmwFq1fK2XlRgT
         b10A==
X-Forwarded-Encrypted: i=1; AJvYcCX+od+kueRtePnw7Dvxm2JHSn1YtPJ26qNzzirC9RbsxExoX2ZFiudeQIqGBvfDAIU2Jm6RwGXGSA==@kvack.org
X-Gm-Message-State: AOJu0YztBl9g2MmkvyYDOVM2lpfEM9mnKEemRcbXgDOAWgsz3epRnbxr
	7N/5M4QKQiHc4Yqb/H+gVxxAvGSTVqOytdaqO1zwi2gVgLTz3AAy4nJaWpdyR/ujGwI=
X-Gm-Gg: ASbGnct24U7cfLageX9ElkVKBLJroZ4TvrD+hq5LkJJaxmbo5mmZE/DwjDOaQrGYiwC
	sh/dMsXNI8Xwc/Wv7GNstuZwvQiNg/j0Krz+RACj9+I6wIs7A1mDK3LE1KFD5JQA9swL+e8VnMa
	LdVPfrGc8HkgfQt8HHmxfNnwaSF6t/bgXq6jZ8kg8gCjjp5LwWO1a7crZBJTeUzIEEb7XXhZ02l
	DRzupGQH56W/JWU/qE1EdPZgDiamoxRt32NLstAoMnBQsVhl8TYhTNLJTt4+1MElH9Ww0F8yJWH
	Y7dBWDqcspeKfSN3BJ3DYkkY7CPzZlfQO62oJjTL2jWZ7reW76PeRsByeq6iq4HRpNA9Nrh+cN6
	6KU9NvR4lvlrE+nX+qC0xG+8p8OWin7ukD0iIjeQgnsH0QAevbuQuMw83H5Y4CLfaOSCzipNm8W
	pEDwmmjCZG61bWu7GdrolUBXRbX5vZZA==
X-Google-Smtp-Source: AGHT+IGbRbXBdWPtS8s2pezZSC/ny/HyWuyG8gk1o+dQWRtSU7DtMYRlEtgHBlikDrn4myL+c90Kfw==
X-Received: by 2002:a05:6000:2410:b0:42b:3978:158e with SMTP id ffacd0b85a97d-42cb1f9e99amr2655929f8f.30.1763567141134;
        Wed, 19 Nov 2025 07:45:41 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:40 -0800 (PST)
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
Subject: [PATCH 14/26] panic: Annotate static information into meminspect
Date: Wed, 19 Nov 2025 17:44:15 +0200
Message-ID: <20251119154427.1033475-15-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: A875A10000A
X-Stat-Signature: u9a55czya5ounuitisgprn6imjabciy7
X-HE-Tag: 1763567142-305889
X-HE-Meta: U2FsdGVkX1+nOLLyX/wDFG/iHBhGoQwbz3KL1OK73TXp6Yu2IItzdOQvVYEoA5vfuiD+7xmKiGXc5+T9uwDkq/KlXstKcRJZLkQj3hNdfh+d1u3lOShbocVNHIrHEUcJQPX1OcpaM/tZqSa0O8o4dBWoa9laDY2HF1HveiU41uLQkPs1VYuN6m7sVmopp1QjAKwkrLSc1eKyv7w900OhC/oymcuQAMHUrPJkYMwVap89BMUPb7X7S1p/C1PEbazGjzXSVZsYw8ZH67i2V9QB+Jhg+JR/ErNwjdU9AzB6yj11SZSLttF0W7/F8SUuIidAvO3zPHqU2WFCRr4cEjXWmmi470v+d6zXxPP8tMDGcjd2T0svD6xbKHW+INa0WP58Nd8rCSRaTySmkYunGl/2fJJUM+3fmuQeHPQEyXNieS7VmlNS5Witu/4YhjF9GzcKhz++lV6NHujjmgXICYA3NdRCKwNvOMq48NJFgMfbsl3+iyJKipBcCfeobxmLv3i5jT8YxwX2rBp5dwR8tTowA9URofZ6wSnOrJ/Ow5YzqBsQNAvIe+1BPlxfaHahMDS0jdUk4SGp6b8FmOOUEI8Hl14sKahTZXgw/FvYhnRKeolod54AgIGkncSgcqxaF8whssOqaLI/WzNwB+iCnxub48oYiGmP2xWbHB2hjowMLS7JyPCquRh19QaKFoWg/cUbET3DY9Ew8yVN78m3/DkLQTDPmCvOhQBEVrCk2VwHZXp9WSRZtxA4JWw1ltSjyQcQT4qJPhbWlCaQkn1EMFbePhyGHD3iX4kg+rxwyVUYfKFVEJucAPp0XMokZEuJlbfhonq8yQBkb9lVNxYzaHKrV2mPC1rEdNCgOfmDW3EFHkTq7XlHZmyEGnSfSn045PC0MQIVI6EMxuhN5WRxxT7RAlA1f/sf8ICKj5fCH4pZUx+cEfNwEiCVOO62d/fNKEzNPwdJ1knthgu7LOeU5dh
 qgBI9vaZ
 RDups3uq6eXBPhopATBv5OSswsPxDNCtVWdILMQJU1ibts8QWDn641FnkuZ74xkqFyVda1qWufiBCtsPIenyT1qVb6b1YvAoVkr0yxw21TFMky8r+yKxrSxGBHKniHCe3MwRJXAnjhA7/nLj+XlxQOlhR2d22I2k6pTPDUKOCLIu+J3AD/r50OP4PTQvCajxbDiV4mLNkVbU8VrTeFWhlYb0O9C9wXibTWlNk6ts4UPRNDro3JvtmC9vGHsO3TC6LmxUuL9YsMkf+p12waf2U+/ejVMQpKMA3geZN8HGNL6khXS1dMJG4u4lLjQ+yAlKdBlLFUEs1VBndU8gB5Q1epMSoncDYBqyt4jpjq6e4N7bAWJpQxNXnIZqYc6yOJMsIBx5wbnUtTdw4C6hwE8F72xqQW0ujTF/kM9uL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into inspection table:
 - tainted_mask
 - taint_flags

Information on these variables is stored into dedicated inspection section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/panic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/panic.c b/kernel/panic.c
index 24cc3eec1805..e99539e18054 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -37,6 +37,7 @@
 #include <linux/context_tracking.h>
 #include <linux/seq_buf.h>
 #include <linux/sys_info.h>
+#include <linux/meminspect.h>
 #include <trace/events/error_report.h>
 #include <asm/sections.h>
 
@@ -56,6 +57,7 @@ static unsigned int __read_mostly sysctl_oops_all_cpu_backtrace;
 int panic_on_oops = IS_ENABLED(CONFIG_PANIC_ON_OOPS);
 static unsigned long tainted_mask =
 	IS_ENABLED(CONFIG_RANDSTRUCT) ? (1 << TAINT_RANDSTRUCT) : 0;
+MEMINSPECT_SIMPLE_ENTRY(tainted_mask);
 static int pause_on_oops;
 static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
@@ -662,6 +664,8 @@ const struct taint_flag taint_flags[TAINT_FLAGS_COUNT] = {
 	TAINT_FLAG(FWCTL,			'J', ' ', true),
 };
 
+MEMINSPECT_SIMPLE_ENTRY(taint_flags);
+
 #undef TAINT_FLAG
 
 static void print_tainted_seq(struct seq_buf *s, bool verbose)
-- 
2.43.0


