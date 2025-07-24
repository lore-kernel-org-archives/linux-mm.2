Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE450C83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 13:56:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E10016B02D5; Thu, 24 Jul 2025 09:56:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBF486B02D6; Thu, 24 Jul 2025 09:56:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAF046B02D7; Thu, 24 Jul 2025 09:56:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B5FC66B02D5
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 09:56:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 804EC1A03BE
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:34 +0000 (UTC)
X-FDA: 83699308308.27.958C1C7
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8363020003
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 13:56:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=jU7zcWeU;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf13.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.44 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753365392; a=rsa-sha256;
	cv=none;
	b=vrqOGqNr0JQ4gAUk8ew64OueFVuIb5E92WFbm4BbWMDwyELzvJYVIwZ9arNBjHbti8H77b
	2m9EujP5MmC70Cv73PX6A1IhaHkmydQ/5THJ4tCo8DHEdWWqcWoJOqg4Rn7zD0UrwR5bi1
	kMvBCnz0KXcFiLxYMEO8c72/wu0bh+8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=jU7zcWeU;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf13.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.128.44 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753365392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cFMrD7tjY0571sMCF+ur1VmM8eA36pvQygKXmIz05uw=;
	b=Xk5fCQI+ng7I9opUYeCXp8JBLl3rZKP4dLZg2W5ip/v/KFbr1kjG3beTjYxAaGy2rM5b9N
	d7lF5basRAzF1E+kKcqSeimiLikPvmr+XYiT8oqrKn5AA8B+XYOQ//hQxTVZK9JAiL4mVr
	GVoA7b+MEMvfoIJg6+BJR1KOgC+ge/o=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-455ecacfc32so4577585e9.3
        for <linux-mm@kvack.org>; Thu, 24 Jul 2025 06:56:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753365391; x=1753970191; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cFMrD7tjY0571sMCF+ur1VmM8eA36pvQygKXmIz05uw=;
        b=jU7zcWeUQzsdxMtv/z1VV00XDCiSio57AL0dMXLbq2V6bcbumkFurLyio98EvjEsAM
         hXB7oObRbJMlDaCuwrYGvslA+Ec64VLba5PdrEbZxeVKv+PY2VjZVBzE/5YFf4bZ/buf
         aQzXHg+zKeJEV7On7gv8YstAxRx+fv1yczzIWLV7+9OmXJTIC/Dr3SfGNnSl4DZtoYce
         3ofgtALWwGQZGHOxeLyuS7Io40J1JGRthOdIucMO8X7vOxKFRRawvT4UGwXCF7hny7rb
         HN71ktytVR6wY7XLBPCD5yi1L/6Ky0Bfw4SDP1CvV0W1h+76kSWbmfKYh+l3mwmNBmP3
         IMfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753365391; x=1753970191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cFMrD7tjY0571sMCF+ur1VmM8eA36pvQygKXmIz05uw=;
        b=hYiXxCCJg8kYGJ4kS8frRG3CY069eLjq2LACz7hxOjs0lAAWjp3wZY2hSUHB4hfbAC
         py2U/iso3tFdtZMBojgO+2CK8sqb97KQZEyDOySZcaM3f1rHwolktlMYcjVtzn98SnEI
         YT8/gQ68+MZzN790tEL3mjtHYlzHjYPzfVOxdXMY1OWMTUWktHVP81fKqqZE4JoB7Ne0
         kRprfC5K9RhZJj6mgG3WjBU4Krzz1asHStusp9wGOTJDKMpO3/j55aYmSwhdnvGXubXL
         f5p1i1W04J8oF0ENS2+koHUpRtE1niPxL0Ng8f12tPCZOagHkn2WxtAyY2slqNFQ2K0J
         2G2g==
X-Forwarded-Encrypted: i=1; AJvYcCUqQWIm7rfrnJ/u/sbPF7rluSsF6CKhuda88oooJv9tzvgMgWB5RZbvJpnaBMhh3wo5GPlvIuPkxQ==@kvack.org
X-Gm-Message-State: AOJu0Yx4IwB5W+jEhv7MlEOkiE9ajWCyvfDOPsaNibcEIHRXe0sFdBa3
	JcMbatdCJxhQ4/fn5IhBphFMOzXoGD87fW2phFIZFV2tg7nPMGRhc2V0/BuYqqSawEg=
X-Gm-Gg: ASbGncuQ7xAy72Uj04rrpQ7TZnZseO8MUTeYvRFqOV6jGkL9eoMGkqZ7XpcWjDsnqhe
	2lfTjwhJ379OHBTsCSM1/TFRExQ+O8nJtLGJJyE8Rqn6P3I1DfnIOAHGyZnpVMYVvzvvVeCsCmO
	GIkjnI7M1QELuZzvwHffSmxe2Bamk/Sgk3ttFHdGoMYXtHEzDSidEh9U0Jt6bp2/f0lfXdHvlpA
	Sw3Ef92uW35BwCVS+z+IIWyBhDyNgPIkIrgVH9+oE37Auomc/6ddFk/IbQmKwWJ4ywTeZNrUhs2
	68QTpsOjUUEnUMUn7be8WSMWfMew3p/MjKX82icOFNuzHU5ng6WsIAZdgabc060Nr6dDUiTulP9
	68TfVYYMHUEr0VUBqAauMCXsW1k/pxCbgyHHgwRc7OsQha12/bMCHeyzbdAogxaJGLEpelxjLwS
	yyJnNEip7aHU8MXVNah1fhX40=
X-Google-Smtp-Source: AGHT+IHYV/rdyT8foqBo51VlSPNSFrqLVd1yTjWzm4T+7ubMqxXGaXLoYsD4QdIBTbjTZBYyuCKPkw==
X-Received: by 2002:a05:600c:3f07:b0:456:1d61:b0f2 with SMTP id 5b1f17b1804b1-45868d80dd4mr72372095e9.30.1753365391122;
        Thu, 24 Jul 2025 06:56:31 -0700 (PDT)
Received: from eugen-station.. (cpc148880-bexl9-2-0-cust354.2-3.cable.virginm.net. [82.11.253.99])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4587054e37dsm20889375e9.14.2025.07.24.06.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jul 2025 06:56:30 -0700 (PDT)
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
Subject: [RFC][PATCH v2 10/29] panic: Annotate static information into Kmemdump
Date: Thu, 24 Jul 2025 16:54:53 +0300
Message-ID: <20250724135512.518487-11-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250724135512.518487-1-eugen.hristev@linaro.org>
References: <20250724135512.518487-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8363020003
X-Stat-Signature: qmihcfkde8zee9bfqg1qgeupjpmmxah5
X-HE-Tag: 1753365392-864186
X-HE-Meta: U2FsdGVkX1+uJyBPxDyreuA8etcx/hf2gWofIqh/rTFm3MzAfpgaZLnPfBl4oXoAW2NmXANiW/f3vcST8Qh+ritmu4mjiO77KinVR2FYfZnqWdGz0sXFHwqBO88qC2bfPoEY23V/N6zPC7iAfxlKcmX1Wvnfjkhqzn/ZyrrCDgKKjFrTrzzIIW0GhTwH2uaGNlLYU6FEZHDnXysDzmzJcZ6rTsJAybnCTopMq18Rsqb1BSOsLUnrRsMHlG9/dqnckYeDAlf/OD20w5X0kkthcS5nEaD3xbrhZ4etzzoO1q3xRPbib30wBh9SEIBHsk8BJ8SpthGq5OztsG5MQrCG7oXv2hD9Ufj3Gh8cBbNlHqckRv4jujb8sOwUmkbFfaang5Ng7WKcNW1Kt6EvNxQv3MCcYiappVggZHH2e6/zrQHrjuuIZJdH1VJF+tk8+QozlkExKKWCfiQr+ss0+0hDG0c6xksFQUvrTEIso0e1rIFip556+polb2FrEDOXrs1tX1HMxEz8Xk1yL3680aWXoVR9teJkuZfM58j2LvDOjDJdqM/Rhfx0mgqpFHgaId4Efs/jeHs36+0BYC4ryTP5dX3kyEPM27hOxUuO0882Lz94qeCi2QE+L+PDv/64SvmyUrnO6fMTGp6cv7QelH/Iwv3RE8yDFaOxsWQ6rabL0BOsUvw03Q6OTDDkSLDQUw8HKri1sgXcKiYNbboPlhyzRblwuxuA0wgyvtRsPUErLSpZsARSSodjC0S9qLlloxwwcUdB2y8Xves8Y+QxNqPiTO40x+KDJ6mtzc4h4y3aFZEUej/HsGOeQJE6KMeveatBf3ExoMRaPpuE52T903ItvNHYNMCbI8jEJ+Mfn/RFcAakoOrQ1fT4PLGeXFoUJvPo4CHW6ZvrBi4leoJrIDD1WZY/tIDE+OJMykj1BAAunworp6HOcfjm2NDvLCs2lHif7Bya3RkknFOwjh3P4HN
 USdx96/D
 5b/VUTU9/7uZHq8Z3vU1+nC0PnFL14eyvMqkpzqnT243oruhQ1S1AEgKtcLpwc/sedl+S3u3K40wJ/TQvl+acBGrxIdpnbDFyVXSKDylLCTcgke1qvGBLqvKfSrit1Fjrtb8Y092XKJc0cej2fX4ShduZKvN/sLRXUaNqHS9CqyTEgP9B2lOr/fMta49tCKNYA1HeTcDcn7JdD8SBJeG34HMurYnlZgSG5VvgvU2gSeiIpCZ2firnTdlSVJdvsT0a40WemJ2xV8FoFdS3lRKaS5ZAxhMQEE/29KSZl8i551WX/bzn6UV2LMHxJVn8uy1fZt/Tblw9mi0gOrUNO79ZM1qMZ8Y0l8USmsCi5Hik2EFD754=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into kmemdump:
 - tainted_mask
 - taint_flags

Information on these variables is stored into dedicated kmemdump section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/panic.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/panic.c b/kernel/panic.c
index ccee04378d2e..fb561a2fdb59 100644
--- a/kernel/panic.c
+++ b/kernel/panic.c
@@ -39,6 +39,7 @@
 #include <linux/sys_info.h>
 #include <trace/events/error_report.h>
 #include <asm/sections.h>
+#include <linux/kmemdump.h>
 
 #define PANIC_TIMER_STEP 100
 #define PANIC_BLINK_SPD 18
@@ -56,6 +57,7 @@ static unsigned int __read_mostly sysctl_oops_all_cpu_backtrace;
 int panic_on_oops = CONFIG_PANIC_ON_OOPS_VALUE;
 static unsigned long tainted_mask =
 	IS_ENABLED(CONFIG_RANDSTRUCT) ? (1 << TAINT_RANDSTRUCT) : 0;
+KMEMDUMP_VAR_CORE(tainted_mask, sizeof(tainted_mask));
 static int pause_on_oops;
 static int pause_on_oops_flag;
 static DEFINE_SPINLOCK(pause_on_oops_lock);
@@ -601,6 +603,8 @@ const struct taint_flag taint_flags[TAINT_FLAGS_COUNT] = {
 	TAINT_FLAG(FWCTL,			'J', ' ', true),
 };
 
+KMEMDUMP_VAR_CORE(taint_flags, sizeof(taint_flags));
+
 #undef TAINT_FLAG
 
 static void print_tainted_seq(struct seq_buf *s, bool verbose)
-- 
2.43.0


