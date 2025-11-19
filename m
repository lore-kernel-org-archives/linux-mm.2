Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA087CF3942
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:45:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 272FB6B00AB; Wed, 19 Nov 2025 10:45:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ADDB6B009E; Wed, 19 Nov 2025 10:45:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 04E586B009E; Wed, 19 Nov 2025 10:45:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DBBC96B009E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9A9984E763
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:23 +0000 (UTC)
X-FDA: 84127780926.04.A197EA5
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id A8F79C0011
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:21 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=rsyZuvnz;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf10.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.53 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567121; a=rsa-sha256;
	cv=none;
	b=dftK/BdLO8kcFPnGGB8M99OB4wECqJkCFES+fM+DED6gs5ygSeG2fvHTvq+CZEWPsB0lu6
	yGmaRGG9TEhJCY1VW+vOAHJ6PF9A3o24ARXmNOG+p+HJWsNTLQfjIsnNwg22GVBku7HNoU
	oseQ7fwQFLyuHZhr6vKUKtndW841444=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=rsyZuvnz;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf10.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.53 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IgUegTKLQ5c0JCFFEcjPGQkSMjLGl3oe1WVgssxW3WQ=;
	b=LUlyC7XYwYwPNfXpRKolsgLfoP/6+6MKkpz/RBIeeYEtV3INrv40lp0+Jl5bv/HwDS5Qq/
	Z+qqhLrsCQmKQf+LFFKC8kSxCfPyqijAtg31safjmfoaHg4SGULx1L6I8I9I+Ud0rMupRE
	lKGWRbJ1IQblstXgERHBf+NYjarggy8=
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-42b3c965ca9so3588217f8f.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567120; x=1764171920; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IgUegTKLQ5c0JCFFEcjPGQkSMjLGl3oe1WVgssxW3WQ=;
        b=rsyZuvnz4ZgJ9YtXBCXNYmcDEJdWvRKb3gqtZAZpEd8mOtthkVLt2uLbhPMC8QX4JA
         CfGpYc5kH6TPl3m1SV8LveMirP3W4c1scB5eyyJCwgs2E/11GEUVnopCePc/Q22l75XH
         U+iZCmGlqeULJ1CL4KiU7LUCPsCKLOk0vbWAOSSTlF7nZIfHoQJtlZM/V0bFw+OpGiTu
         KPDZHNEf/Th1fLdNnCKEDfkYOAMfPDdHb0mgfXPy2d+hp/ACq9Qbrveq3ubbdG94TYpr
         8aQtu3sKJbqEaw6XnXdR1W5nAqfpeeMflRG29KslLZpmw+g9rX1iRHXteTNmipyu8sQ4
         UASg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567120; x=1764171920;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IgUegTKLQ5c0JCFFEcjPGQkSMjLGl3oe1WVgssxW3WQ=;
        b=suiENkJu/aMuT42hfgdsqGDr7lHULcKvSVP4bjE23LStk/XkqdKsOfLpC8jBhucaEv
         Qvsg+00urcwzm9yR2e809+zhM56xAaq/tZUxFTlL0OCFlJPVYzeNWv9VU1H++O7eIfJy
         txnmB6SUsk4mGCEwdkoAHjA6gPkdijaWQj7TG6UnRBtn1lc+2GAc/mN/0ojhqHY0wUyL
         c8rUzD8GkBUwsh0kl6JxUW7bZRJML37LH5Ghd+XK3zR4vk4hYSqAaEGDABwP+K4TiWFw
         Euz/BGBoPYpnMqgyzFtSK0UdwEubX3hv2vUHimOD1qjikX3JeXNXL5qFWzpEZW1NNUFr
         RkFg==
X-Forwarded-Encrypted: i=1; AJvYcCXkj9hnQfpc7WcjZQGIJCBorBTRS0wRvCPK1B35NRALSJzFskj1KqcsJvpjdDfibOePYyy2IO19nw==@kvack.org
X-Gm-Message-State: AOJu0YxY2452hpHGIDRwzCdiq4bTY/ufuz68OA9GcltayrQ86UqyRGzZ
	iOmhM3ossuOaYjoj2BOf+i1ImqrmuZvu2r0xY+5O0PL5yOOvD2sqiKa/zi3Rfbf27E4=
X-Gm-Gg: ASbGnct4bQOipBZNdeimWCnnno1BPUA/1Tvf95oI8THC6dlko1fkBGB+7pYvv3BfdSC
	TDhVTJ8xS8VHyc28TJtTmv4Z/OjFYB1vWdk19U6TX7YU5ExcaJvFZ4LQbzrtXRYGme5K3yX3eTg
	AMjhhgTZ7C6at4bUVrod/Ly5HkPqH02JTAZs1IWB/H5Ef3u/Hhq3zC7ZlI1vIWBbX8NjONEYMvf
	pn7eGXLnZpW1u3vWP4/XVZBMX9V+VugyCnChfbS5EKmaXU8uL86LttXmZs/X3iXn4EaTFDr9r+r
	MQ70Ah2C+VR/Mq6fN3yPJ4axDXSCWQkGyw+6LTmSDyDc3Xqvkq4J4Dz6Y2bz4saDXFq7mZn+JiW
	YtMWSGzZjq65HMxu3+/SNUXMcB9Fzj4d5HgM7uC6Z61z3Miy3ZUCNRXboU+6dG6vXhgepmlIogu
	46A1Mo6/BQ3A3rxkkvu60Q40BXJcAU9YYCZzDzWxWD
X-Google-Smtp-Source: AGHT+IE38LHRCo1rRgXHbp1dPmtNTHQzc/1FY0jCSEqGBXN/4naA4QLiTpPfAdRH3ooZXhi3gOLsPg==
X-Received: by 2002:a05:6000:2087:b0:42b:3ab7:b8b8 with SMTP id ffacd0b85a97d-42cb1f5d859mr3485815f8f.25.1763567120163;
        Wed, 19 Nov 2025 07:45:20 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:19 -0800 (PST)
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
Subject: [PATCH 02/26] init/version: Annotate static information into meminspect
Date: Wed, 19 Nov 2025 17:44:03 +0200
Message-ID: <20251119154427.1033475-3-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A8F79C0011
X-Stat-Signature: 1yiuoxxrjgnfz8iiw8z5c6ky93ajg1ya
X-HE-Tag: 1763567121-651701
X-HE-Meta: U2FsdGVkX18aGsp/6XMtvgza0gOmqWLQBsxcXPvo2TYiXp60U4Z4yGsdgt3EL/pRINBAQlEfGr/rO5svTSp7q8r5P4oSLjPpJYKoekjz9RS9NGI/i9EZ/+R1s2Gaht1sSpyuVrb6H2549PM6yNUn6WYF6X2waAMnQHHL8X0J2nyqVsdP5NC78er6USHTaEXmoVTeDR0khFVbxsp+8j7mTXxQB89qa4KQrul08U3pZJbWcmYHqNx0JygEm1sBGpevIan1CYbbCeyO8cxcSZ6PU6hbpz11fUGEX65ZoUAYZ/64cf4/Zi9GTgAu/b1dk48Pp+TNF9u1ZdWSkmW4hdwdRTpnw581C0s6YQaMdvfUcOkqtBRpvr+AjdIGOIeAr7iZXuixBX1diYVZ9fKzaKiAKUEvVIzhCVu2+x2yy/sHD81yYM2HbThokEEsHkH7df4m1hi7j/PPwKPJz43x3ptkJwuS/pH3HfKfuDUG4ZURNXIzNskvgzgQ1KXVX62BtcVqF+6fDGUUevizjWpLFjqtzt4e/To8YUz9uQGM3vPvr0NfKKJdgXJ0c6rm1cjB87tQchrHWktbzWIcgwMs9AjAjfseZ0a9C1ZTn6QgVQ1KQLb4750fCWxrlsr9go2cPGfvZhulWMRCkmg1QeJcDDuKN9a2ybIClpQvbc2+xHHWo0kzHjToEmCtkwQFTPuWMA2qRXEalASKJTtvmHrYK/Z8n8+gR1AD2lWweG0cznq6eSFSmIFr8tofkVoACvvqv3J37m2/I00ro+lMjUKUymmavmDt+Dh0SBjr/j7C8e8pU/YRXHvi8GE4wrUHysKpY+4x4AOZquoBDGyS04JyEkwB/ZTCaQSgY20D629UWDRnG9l0N3Ulq54NaJ1bXd3cJiTUqnM/7Hq2Q48H49MmrLHa1IMZsF71J11U+il1JbVnnDQZW9lExOrVxIF443HlX8sQGlXHtiPIaf9gmwcyHcO
 KBVAsGsp
 i2L7HSIwgs6mcdodnF9wMIq3LgXdPi3/2QPkzaIAzs1oZOAWhK6h05SkdCDtkjryC97PxtjCDG5rbaeZWTnJZrk6Q5f/HOlG3w5FXhcC757VG6VWxirDCBOO+SB5t14EQYLfQ3Z8JnjI9Jd6s85aQ3uJ3/Qz8RN3BoGtXzIe+d9Y/sLRBMnTSnegvv2mPzp2bEd5RYp2q/6HtMxFZgQbaPy/uHs93TflL53QtEnGXFnzIw1L4TLbQq5k4c+f0ebn9YSAtnLKQLBpo3uVHrfP6kg5byFyyL4BqCYaNbZhNB8NQUPfn40hE9X40DC1XmiBB25YwlObaAggxipNrLWvou8bh+vqopsKj9qJVhrQDd3iSfjpWIvScFsOK7/Xtqs6PBGmKcwqF3zXXsLBM15eS2ZPva6EzF2a5pb6B2TvUyPvMBg8Svnefg/K67oiAUxvgpgsqLzxaRxVWG3M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into inspection table:
 - init_uts_ns
 - linux_banner

Information on these variables is stored into dedicated meminspect section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 init/version-timestamp.c | 3 +++
 init/version.c           | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/init/version-timestamp.c b/init/version-timestamp.c
index d071835121c2..6f920d0e1169 100644
--- a/init/version-timestamp.c
+++ b/init/version-timestamp.c
@@ -6,6 +6,7 @@
 #include <linux/refcount.h>
 #include <linux/uts.h>
 #include <linux/utsname.h>
+#include <linux/meminspect.h>
 
 struct uts_namespace init_uts_ns = {
 	.ns.ns_type = ns_common_type(&init_uts_ns),
@@ -29,3 +30,5 @@ struct uts_namespace init_uts_ns = {
 const char linux_banner[] =
 	"Linux version " UTS_RELEASE " (" LINUX_COMPILE_BY "@"
 	LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION "\n";
+
+MEMINSPECT_SIMPLE_ENTRY(linux_banner);
diff --git a/init/version.c b/init/version.c
index 94c96f6fbfe6..eeb139236562 100644
--- a/init/version.c
+++ b/init/version.c
@@ -16,6 +16,7 @@
 #include <linux/uts.h>
 #include <linux/utsname.h>
 #include <linux/proc_ns.h>
+#include <linux/meminspect.h>
 
 static int __init early_hostname(char *arg)
 {
@@ -51,4 +52,6 @@ const char linux_banner[] __weak;
 
 #include "version-timestamp.c"
 
+MEMINSPECT_SIMPLE_ENTRY(init_uts_ns);
+
 EXPORT_SYMBOL_GPL(init_uts_ns);
-- 
2.43.0


