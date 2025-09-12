Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B0F2CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 15:10:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8B86B00B1; Fri, 12 Sep 2025 11:10:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B986B6B00B2; Fri, 12 Sep 2025 11:10:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A883B6B00B3; Fri, 12 Sep 2025 11:10:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 974956B00B1
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 11:10:34 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 63B37BB9E9
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:34 +0000 (UTC)
X-FDA: 83880934788.29.C475EBC
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7FEF320011
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 15:10:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=rsUvwlql;
	spf=pass (imf13.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.219.176 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757689832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b1ubFmujdan3yUawwr3ZvZLjd/mUy6/pR3VRzzGBTTA=;
	b=kQ9HYWiUA/GLxrRle4y/r3xntmXKCJ4W8nwMqIGd2lV8ZzJDaXJjWmpAf7DemNUt4qwur+
	B292pqN0OyUzACNgNy6RpZPBBI2wS3tIfxjsK2FKJ+OAsmvnOjxMIUwUroYm2vo8zIhNUo
	4whcpYKsYgWAbGtETHf/EMx8E5M5KYM=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=rsUvwlql;
	spf=pass (imf13.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.219.176 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757689832; a=rsa-sha256;
	cv=none;
	b=OxFWEW9w4E49PtTFQbZCRcmd2qXYiADKExIxD36ZlC+GJGcLZVVyXi8jKx2bTI0Pw1f4bp
	ncCWsLV67dGHQrNVrXDY+Av8SKy/JuXrce2IW5UxS/qxHmHzlVY4isM90ieAIGHPKKNmdC
	7yk/8q4niCeCN9qIYWm0pGrejCp7uRI=
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e96c48e7101so1629354276.2
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 08:10:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757689831; x=1758294631; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b1ubFmujdan3yUawwr3ZvZLjd/mUy6/pR3VRzzGBTTA=;
        b=rsUvwlqlDX5yutCCJTamPJA4q4XXnCGhaYJSBxUuC8RwLYKQuDzaZIscVA1/FF8QQH
         CLu4hiDlaasPqD7bHvcoBrGyl1CskfxbsvhFv+TG1UtSBSVLZ0L/8reaiSidLHNJFiBN
         jqmuuVA2xxNB2uX/NBaSNaFRY6yom3CWaLc+AhsHeN5OlUQIGq0GYQr/ZFFB6XUvRTQ8
         jJpeWrN3PJKu004UWQdgarOzn1w5epoCwe8rguAj1Du4Nvx2C2anceV75L3zDuQmtTvy
         5COdENqw371QBoNVFSGW57kA6+KWrJu5I+5356ji8znGNQ9ZV5PG4y8t1AfDWH36JXZL
         hOjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757689831; x=1758294631;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b1ubFmujdan3yUawwr3ZvZLjd/mUy6/pR3VRzzGBTTA=;
        b=KTDuymXSC48J88ZntveRB2vhsSr4CrDbz8Ex97dlU1mLNACLtFeSsGOxFsjPoc2Gve
         lWGSi3aLmm3RQg0jvHxT6dUn4lhrUcSWsUqDVFk+4cPYSDK9lu+bhBklx3TtA/txXW/e
         Ogzw3eexDyq1BoIN9EzCplQNrslqNXSNU88q2P09l/S2PpW93DQjQ/ZFtjCsNUu5Zb8T
         lLbF6QTB6An3mhTs2LqatnxGmcwL6AOcQDcyQqlqk0q5PbrXN1gqPiHqmkWwwTGwPaH8
         ahJSJVWLcR0j+Y2/YpSPVx9Nip0NBGRI3Rp7cZtZ1NINv/lN6Rs6ZfqgU8Q0dX4Xjq2N
         5/aQ==
X-Forwarded-Encrypted: i=1; AJvYcCUhlh7f6eAHG6RhVzINca00mmmnUkOud43bX5y6N4+KSw/cDwz37/yJDgySGV+iACbFDQiPD5W5PA==@kvack.org
X-Gm-Message-State: AOJu0Yz2FrblQmkjd290Sw57Sge43iYaLExG5gNCSMiRIu8RZN9Hec3y
	oLW/naeNjS/TbomCyoTnGoMJXfqUggLcvrKh+v35laZYCJK9weiLsC5MrDGpikgSTpE=
X-Gm-Gg: ASbGncsQA17tjZiwbIFDxlTGI8j/mBWislWOEC86AiE7M4aozJjsJHagpTYBByRmCPq
	dqYyOFTcoGCH96RX04PRLBWOgaAfd7CTyvVLG+ffMbr+3z4TAqCimch9dXLelXUBmaAHhNgfuRB
	EL0l8Y/5+IT7kOEu0fFZyaP22awWTlf9w//6IIvZ08dIVU8dNkTtRlilJLxtiHolclmkrGyhVkM
	wP/6KmseHKul9pnD4N0xBkjtQK833uANYfbwK/kK5qYis745SL0kSsDesG7Oz/DHhnkQqGN5jNO
	IbOoFA32h7MsJRS7lnMRyWjXxEBKnAzWhosl060W6Gjh+WdWEKl85lA3cNYivKcUcvoAfLD0N6Z
	AMEp85YS5GuciYo9h3GhOVP606KxOfRONDZuikraTRYKE
X-Google-Smtp-Source: AGHT+IGQPX6y0JKi888sfyXxAah3q3fQIwu7cpMyf9JJWf5Y6/yYrim06D3kAGSOfpN7Gh01tRPdkA==
X-Received: by 2002:a05:690c:c08:b0:72a:2d15:a2a2 with SMTP id 00721157ae682-730627c9015mr33553397b3.11.1757689831515;
        Fri, 12 Sep 2025 08:10:31 -0700 (PDT)
Received: from eugen-station.. ([145.224.119.89])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-624841586c1sm1302244d50.6.2025.09.12.08.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 08:10:31 -0700 (PDT)
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
Subject: [RFC][PATCH v3 08/16] init/version: Add banner_len to save banner length
Date: Fri, 12 Sep 2025 18:08:47 +0300
Message-ID: <20250912150855.2901211-9-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250912150855.2901211-1-eugen.hristev@linaro.org>
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7FEF320011
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: x9dis5goksxrkuc4uf3rbhkc5y6jyx6h
X-HE-Tag: 1757689832-550502
X-HE-Meta: U2FsdGVkX1/6u58Niqto4OAmC9ZyMcuf0QfdgTO/hEhD4gCsbxd44fS3/ZTTQ1kYn+bJblPJQKyX4PeyMB28q6+9D1O4UU9257awSJYfrYv6uzmbw6AN457bAihA0+S6VkqevAq74fssb2KtJFx3Lgsf8s9A2p3vYUWxiXKwowvsD4bz2ySMbhAHto6HXprw84J7QEnn26sAv2KNlPrxlP+VmBmEhsnKQDQipyXdwqGy6xsY4wz+yk/+2wuu3MfmKMyxMULUaGHnE28KAAhmBUQm3xqyovRKpT36ZvE18ENClSMBUGAFz08LSw5srcSnRd64uWOSNEHxDRJIVujO90wYLhrtbUaW/Ps+v+2lZXM2HDf+KnrFPiMxmWSPH3k+5uR3+wdFXR1QPI75UyN1+W4rt2IvBpcfWtjGtxuhpJpTjFLuju23UtUxgeW54zs7HTUTUUBpi+2e9SSos90B+ucv5vgPYSpYukfrwbrEb4KFSEIMWOD1WZO3gxaUlyvStEJNh/mBHS6tlX2kni7vUgZYHwH3h3e4Sqh8iooK6G3lzldqV6jBoO/M+gqV6pt0Y9CZp/XyY1t7A5jN7EWXSbMBce1HXbnGjaEWn1p3GFbrwNtgPyhf/o1Vhf/1kZwjNl1oItrRHduuy6qL7qxS0Hrox/5m+/n2YeB3esfVD4n+sBmJ3iOh79WDvwxUL2QQhjhgUcvyswUFJBcDoEjsWla+Vf/e8GV5mXSG8kE0ibbEv0vRVrW1R+neRVLvyTm7dXEiSVTf5NnFC/nB7OpCRCVW2BQE2iZH7+n18MYjj0OcDgm1OM3sqd3/T47gL3LE7Xc9GSwnkpto1Kr+Jsd+UiWiOTAhKE9LQD2aN1hwon8k9UZEmzSsDvITY67bia7VFZnD9J3tWHmAXxsJx60jpEalIksKu9LBF8yrMyFHyZjtIc6yp1qv/5iVai8rsoWq9ncr7IMkJUd3fT+boy8
 jdXBix/1
 +tZ4o5Y2qFxfpKdtDDAEvkzlfbrZ1QhOTfAMX1Sv1CccSDHkOiSKLBsYUUKnT+zJkpAZ7sfv5yUCqakl0o2PsZ/oiAW+RmFVmeiczMSw5Da3BAIM2pLw2Sv07SbD/gs12x/KVbszstqoac+O2T8s9OGsFnVXkvetbfDxnJdUFAqK9uRK/b0zNNBJdUGcMmiESNuJDG5haFsPRHv4C7iSzpgyusMpqSW49uFJFcEUoWpCnSL+UTdHGu4SAONL+htKuXR2RErtyd5paT9gz7ftta+KyIQYSjy0xfCFT6mwtBUtOHG60Nv+YU3N9kwRXiA47P6BeLyiu45HHYas=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add banner_len to store banner length.
This is useful to save the banner into dumping mechanisms.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 include/linux/printk.h   | 1 +
 init/version-timestamp.c | 1 +
 init/version.c           | 1 +
 3 files changed, 3 insertions(+)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 45c663124c9b..5bc617222948 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -12,6 +12,7 @@
 struct console;
 
 extern const char linux_banner[];
+extern const int banner_len;
 extern const char linux_proc_banner[];
 
 extern int oops_in_progress;	/* If set, an oops, panic(), BUG() or die() is in progress */
diff --git a/init/version-timestamp.c b/init/version-timestamp.c
index 043cbf80a766..1fdd795be747 100644
--- a/init/version-timestamp.c
+++ b/init/version-timestamp.c
@@ -28,3 +28,4 @@ struct uts_namespace init_uts_ns = {
 const char linux_banner[] =
 	"Linux version " UTS_RELEASE " (" LINUX_COMPILE_BY "@"
 	LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION "\n";
+const int banner_len = sizeof(linux_banner);
diff --git a/init/version.c b/init/version.c
index 94c96f6fbfe6..68d16748b081 100644
--- a/init/version.c
+++ b/init/version.c
@@ -48,6 +48,7 @@ BUILD_LTO_INFO;
 
 struct uts_namespace init_uts_ns __weak;
 const char linux_banner[] __weak;
+const int banner_len __weak;
 
 #include "version-timestamp.c"
 
-- 
2.43.0


