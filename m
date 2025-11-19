Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BD7ACF3941
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:45:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92C246B009E; Wed, 19 Nov 2025 10:45:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 903686B00AE; Wed, 19 Nov 2025 10:45:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A95A6B009E; Wed, 19 Nov 2025 10:45:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 652986B009E
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:27 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 11F27140550
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:27 +0000 (UTC)
X-FDA: 84127781094.14.648AC8C
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf06.hostedemail.com (Postfix) with ESMTP id 486FF180013
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=NatCH73S;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf06.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.54 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567125; a=rsa-sha256;
	cv=none;
	b=yie5i8/LmVnXf8hAInG/Lc/3Df98Q245tg2wb4ooPIu9aABH7HYe1Ln4fAPcAGF5UHS9iF
	FdJVbvUIIjE4GmQv7JkV2xvhtIXj4V+OTaogfdpRw1eR4cc3DIdrN7sQL3c9WLEH9BeMU7
	O86MoWmTu3fWosrjuRSJ9TysXYOKY7o=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=NatCH73S;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf06.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.54 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567125;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NCvJkYlF4keL+Fd6f7hwRGbLb7cgm1v1S6Qn3Ctc9SY=;
	b=i2PU1A1MFhwN5IDVBzeuj6/oCa6yotBM7tlDEwGuPvPPJglmDQWDuKP0e8szgDlNijWXvA
	9NM7IJQ8tdVCxiJiImLEKNHL8hM2DYC2KUAvzY+2Fem40IH3F/zprGLhhPkZMxAG9BVHvC
	mLjjlU6RKJ7uSyO4qklnn8NqBugjJQ0=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-42b31c610fcso5924298f8f.0
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567124; x=1764171924; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NCvJkYlF4keL+Fd6f7hwRGbLb7cgm1v1S6Qn3Ctc9SY=;
        b=NatCH73STmrBKRcTL7zG+UaNZbKDWWb4TXHXNjhJiI9blnsh1ymAfWdJ279sADw7EG
         1X4RRmn/BMBrRZRe+WAl+pfbJQ3a5yG5hKRHhtwqb6FzqEMLlymOd27RK7KdfW8/pUyr
         YlfwHDifGAVkLgbqb6jhnz8sBFXiuvK3AhWwm5m5zdQXhHDvdq1ggAhWpBM+c+MCfHM7
         Sg12ZerUa1rtjBCvrJ0qw5NW3wOYb9HxdIyUiPCk68TzCsPCCJrTbVdIyM6ILzCd4x57
         z8yr153/ISzgBw+K2w4Bh3zjBLKrtu+nIStWnCDKB0TorQvy+de9aaFG8d2/g8YCZuko
         Ux8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567124; x=1764171924;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NCvJkYlF4keL+Fd6f7hwRGbLb7cgm1v1S6Qn3Ctc9SY=;
        b=fwkB4RjStCbM5bvmnBpZyBjildqcBYhgZyPIwjEWitz2KMqtc07gv9vwoumSA9oOTF
         oj0JRDB+90CsNnaCSmrgK+YqHoE5iUuX0gnV0cQK3OjSF3yq1DC/TKV541dzUkl6LKno
         vDFh2o+nMNNNMl9pGU8n6nqNeo8/quIZTPcKPEqmjnMUQD9JnOmyw84EvND35YYgWLod
         LKpy6OiJ9EDPsVda1PhGjb7HGBybkUdwRR79FyRtZ3CGEFOeGnZL2ll7El2avWKGjCE9
         SHS4iVgO9QzyhqCdzlltl6fU5jD9LnMUuGrqJODhjpNTNzhba3U8UnamtKFbJC1T0Woi
         TRnw==
X-Forwarded-Encrypted: i=1; AJvYcCWI3VSYJJUfTHaFEKUzMJqgrI2ayWeKPnBPo/eVCUDKKE+/qtAdb/4oOSKpw2SnLIo3wv8woNdRCA==@kvack.org
X-Gm-Message-State: AOJu0YyIsiB9Va5rlWmlEuzBxcIzEdbjDd+Pie9ARcXlW2+OlSrCn5Y0
	pvILLifaanDTk8fHuw2bzqFz70cZpmmsqPFb3xvrRdWKpy1muZlAiSyX9mYqzJZFh4Y=
X-Gm-Gg: ASbGncuV5VYPAZnkwH16FaTWoZAaK48Ci4TOvx5yvCv1mGPQgZT42aYPp3b7bhEyi//
	kW0JxeDIdbrC9mG3DD6PVn2GF+x/dWlLNOHVOYFgC20fpB86HEHhOz1Hy3lk1CL3OAd6BiuHmR2
	254gyLJr5zviSvq4InsMMPhJ6hFt30bWh80hp6/0HllScVUTukpYPwb6ovJhuSWR2d0uFc7i2PJ
	BaSZXLBnTQ6kKmIOzCSu1cUTD3BW+KWzbi6S2hplsXiYaQYWi8Rw1YK4WRtDfCVPfRhfoE33txA
	i4TR8CwP6V5aKfi4JvjeOYoqS4IZgFITzXzqE7Z/AOl8W0RkACsKtmW3cmHwhZtlp0DDPkAefxc
	vzOOEp/lsQJr6du9zJ3IKP2qTbTG2q4Tpqh3j997iE+nEq9VWMUPMNepHcCf12N4BJO6YLC5qZM
	MHFx3wkc+c+QwdjdYWmWERINZdeTiEsQ==
X-Google-Smtp-Source: AGHT+IFVCfX9pNo5qLPfR5wjMBWTLaRukJCHurtJsWmWrjGoOxpQq2PCC7itN5NhSfJZMSf9UOyBtQ==
X-Received: by 2002:a05:6000:1ace:b0:42b:3366:632a with SMTP id ffacd0b85a97d-42b59386ademr21562007f8f.39.1763567123749;
        Wed, 19 Nov 2025 07:45:23 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:23 -0800 (PST)
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
Subject: [PATCH 04/26] cpu: Annotate static information into meminspect
Date: Wed, 19 Nov 2025 17:44:05 +0200
Message-ID: <20251119154427.1033475-5-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 486FF180013
X-Stat-Signature: a4y6pfzn1gnweirjyawppe9rurcnknpf
X-HE-Tag: 1763567125-661693
X-HE-Meta: U2FsdGVkX18U67J0uw7qLvI6xQRZ6VP1t7l7ZzMg5E3aBw8wQ6HrqgxGEjiu7YANYmWbecuX4y199zWdFWo1mjB1PvKvxGTFndUt1S0/0sDHTtodKiSVIAt1X/tu0VdzkAFuh/SQluk76Ovuqo8EBTTH577ufXldAYh1PpreHghghjjFKPOjE6eU+07wrKSRDI3FRpw2+bU6BaU7EBZ6P8R5oXoNgLP2chGn1gfg7L+cxf53W1+ne0s3kOmD105WpMvAZGkOAlQsN4HbDmhkcUPwHt34Yg9IZKSYZt3J5saiUO4A9FNS9qSr8m1NgF8FrwS7GOB5LRqtyvjb74Bwsib+4krQKsTYLoRgRlcG5AfLK0rBB0p3iuCtk9wsRgfbz4AmHUve/wX4EA8gMQdfPyONs0w3UdIdsCkyqPYtHP6rPcSvfSyByu9cjb/0zZpOTDEVyXxytYLHLIeMJ4E6nwKOxRNKQ08tim6DQ68ctB/7Ce0mrGUV8sAdTaS+LSB3iIRfRYj4ghFXr76XFR5VzXo3Q9usIr4p4I9qvOhXnboH0kFkOeWKAWZaqvxs5oNQACUY3NyMrOijdKYdW+FP+uh3L+JceceEWwUDPNqWSNEZL+ykIimyKEZgMD1DsClBUAnWy1KXosJe/+XLkD+65BS3F47kn0MKlbs6qoozcwSoeiH+KVNIi1gSoskVw8skD60yK6H64pZ6cdQRihITiqkRCywlX1KNMlTeN4N5c/aKlsyBEdpSA/LB5DDlaO51yewo6WlOziQasw++9miL4rWbyHMHo4MH8U88x45+bsU7h95OUHCXf/WMsxq4RglWQdffE7Q2UWpIevpAW27KIwe0osDk8WRPFxlKCrGSdIfiPX+ftPfZQHqrJ2QMcRdkjcNPq9Px8WORYCwOM0l9aD72e1pbKN3fmS6+TJpkfm7R3ZyBT8QrFrslgirYgBUR3GtOBqPReiioZhImTuB
 HflWHEpU
 WkNVYLlUS+ZJyV4bvGsdENsP7b8adjHs+JWH2ANgD/VqU/tT+gC3oLUXlDlPQxwSlnbjKJrPBbRfCwqpFC5qfAGmiVkQO8f96E33JoMT0piCgdFw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into inspection table:
 - __cpu_present_mask
 - __cpu_online_mask
 - __cpu_possible_mask
 - __cpu_active_mask

Information on these variables is stored into dedicated inspection section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/cpu.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index db9f6c539b28..1f2df5a5b9ab 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -38,6 +38,7 @@
 #include <linux/random.h>
 #include <linux/cc_platform.h>
 #include <linux/parser.h>
+#include <linux/meminspect.h>
 
 #include <trace/events/power.h>
 #define CREATE_TRACE_POINTS
@@ -3089,18 +3090,22 @@ struct cpumask __cpu_possible_mask __ro_after_init
 struct cpumask __cpu_possible_mask __ro_after_init;
 #endif
 EXPORT_SYMBOL(__cpu_possible_mask);
+MEMINSPECT_SIMPLE_ENTRY(__cpu_possible_mask);
 
 struct cpumask __cpu_online_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_online_mask);
+MEMINSPECT_SIMPLE_ENTRY(__cpu_online_mask);
 
 struct cpumask __cpu_enabled_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_enabled_mask);
 
 struct cpumask __cpu_present_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_present_mask);
+MEMINSPECT_SIMPLE_ENTRY(__cpu_present_mask);
 
 struct cpumask __cpu_active_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_active_mask);
+MEMINSPECT_SIMPLE_ENTRY(__cpu_active_mask);
 
 struct cpumask __cpu_dying_mask __read_mostly;
 EXPORT_SYMBOL(__cpu_dying_mask);
-- 
2.43.0


