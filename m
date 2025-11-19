Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3185DCF34D9
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 15:45:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66D336B00AE; Wed, 19 Nov 2025 10:45:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CEB46B00B1; Wed, 19 Nov 2025 10:45:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E51F6B00B2; Wed, 19 Nov 2025 10:45:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2E7106B00AE
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 10:45:29 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E9236160544
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:28 +0000 (UTC)
X-FDA: 84127781136.10.FF47337
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id EA9A1C000B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:45:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=OwZrrGrX;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf22.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.48 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763567127; a=rsa-sha256;
	cv=none;
	b=IFdGvdfq+zN2EZiQMCxQPD2yrJEYFaEup+29NkLIZgQ6AJil4CmexcAaIONmZXLBqjNOlZ
	wovLEGGlo9mTxuAW71rpiLD22T53SrYz8bReG8T5b/VM/7S24DuqfIx3RaHMLBN1ZaetUE
	Tu3LPSW7t8Sv4N14eT+CyPH58uY4jjo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=OwZrrGrX;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf22.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.221.48 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763567127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3irtgR9V6ILkzi6aCmzqNOzM4wzsrVUTWgR/+hcFNWM=;
	b=f1IXZ9mZuSyffSe8s+kaUnDy72UkpJv7Cuq0GfmQnChvO1MZITeL/USf6rpf8ckMKexsKt
	I5yer3QMcA0ElO7nRcO7t6cBk4+ZXEVIe0sHVAL0c/f5HXxDlC0gAvlkJ8KkJ6Y1pozf0s
	FB3fzG7iOfwqz8VXgmcEhEvcxmOgIz8=
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-42b3720e58eso6292310f8f.3
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 07:45:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1763567125; x=1764171925; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3irtgR9V6ILkzi6aCmzqNOzM4wzsrVUTWgR/+hcFNWM=;
        b=OwZrrGrXKH9vPxAkGjNH7xARgqxN/nHQsqHWs6Ro6UD02Ee1fvB8Jq1FN4DsHMev2H
         9C+buUAgrp6FVn9QJkErEvxCmDiju3JV2HfTqndUF9gRUb5IrrQtBVCf2kZAN0+lLmaU
         4bvU6qvlvjnaSIehuRcQyjS/XhNYqa/bZieeaorPKZKJHhdJti138RqO0nNWpr3V7hi5
         LHywMt9db8xzpE+yS7j8KzveITMx4j7Q0NjBxvgkXcbfJai67U1Bja0C+sgo4r7zS6Yy
         dhAAMP9Eg6MTa9XzccEcHIRa8EXks3ZoIk/7l+KCNELms3j11L8uiaGI5aotqGf+64id
         8K5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763567125; x=1764171925;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3irtgR9V6ILkzi6aCmzqNOzM4wzsrVUTWgR/+hcFNWM=;
        b=SjH3FaI/jGJ3UplhsITUhUPGrVPlQJ+9Q1yND5FhchBnpoiI0ajw7i6/Rq2boi61Mt
         d76BEmvR8f0Yl1kwf92I/1DV+fzM1gmdlmjbQy8QM4wK8Tdw1pwUToGLIKie2Ai7Oje0
         kP4qJNp/cX3XyEjf2UZRJhILAjWyz9bvGdY1X4JDYy/qVI2ErWM6w6xerdV+NBMre0k6
         /94XBRJL5Qf3pvK53EQyYjvi8PxiFNQz7UQR/GMPCfdfIy3wwCuhtHOzOH89pDn6W0YQ
         JxOAR0oSXsOckRrGbs4wnwtwV0nIMprkVBaJ6cdeT344JHkse2Y8TU5IwdV4KveDKHDt
         /ZCQ==
X-Forwarded-Encrypted: i=1; AJvYcCWX17UVO/uM8P9YOGBZFKFZ7O/zUBAsrY/sxQrUfEb4tk29AZ5A13jT155y4+z27exiqVeVCJtuzg==@kvack.org
X-Gm-Message-State: AOJu0YxI9yBbi5S6oX4+cK15ZiaxuJt/Och8fOeJh3k6N/xSRMpkP6pz
	x0mtAY1+8Q+lYDUJyYSUe///bAmKcpPiUs9xxsrGJYEoQu2ZAtBJ/wwmWtDtGZojxA8=
X-Gm-Gg: ASbGnct+m2uu9Lc28DSeVnnKUN23xmNC15KWsGsz6/sojxqUuazweWn5oLW8R2uVr8Y
	Tn9W1NIRCFHODU+IL6DcnbRdBeA3GMgZgt3fdb9RWo+RzHFNHA4mF6GtZImBRPh5YCoPSn6nNkq
	UuWMzy0ydFufYJ/LZaa2ZicNNKcqDZO6MVVRP/Ey3ixpGWtpCoI4LrlJrJzI2bIFkcGP4XbFySL
	gBqCLaRHSm3Xn8v/G2FOq/B0JoEYEfs1g3RuJkHwAhm1Po2oWttKXgfPBfM535yWBjgWfFxXAyk
	WhdiMh9yKhp5IFuf+sZ+Ddr2QA5mprV2C4wJ+jD3b6r7Qg1Zobeph/7Z/srAFljyzYheCBdtpBB
	NTOrr/K1x3eJq+rAOnHf1wjOUGz89q/5b8EypoUiaS8IyYQBL1WuQY+7t31etl00l8Ex+SGyYA9
	fPGA0vn16NBj3EQxQV4MCcfT+BXWBwaQ==
X-Google-Smtp-Source: AGHT+IH7OiMHuWdKqmUscjGj0hpAhy0+8U72IgAGXn7ATooehRTT7HxTJk0qp9VlE6dzqjBsHdcltA==
X-Received: by 2002:a05:6000:2901:b0:42b:3e60:18cd with SMTP id ffacd0b85a97d-42b5933dfdemr19022522f8f.11.1763567125510;
        Wed, 19 Nov 2025 07:45:25 -0800 (PST)
Received: from eugen-station.. ([82.76.24.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53dea1c9sm38765632f8f.0.2025.11.19.07.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Nov 2025 07:45:25 -0800 (PST)
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
Subject: [PATCH 05/26] genirq/irqdesc: Annotate static information into meminspect
Date: Wed, 19 Nov 2025 17:44:06 +0200
Message-ID: <20251119154427.1033475-6-eugen.hristev@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251119154427.1033475-1-eugen.hristev@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: EA9A1C000B
X-Rspamd-Server: rspam07
X-Stat-Signature: p77ux4nd3pdipmkzi31st4p155n1xgpx
X-Rspam-User: 
X-HE-Tag: 1763567126-866172
X-HE-Meta: U2FsdGVkX18fEUVXXIIeQgq4uFOFT1SeLogI2Xs1YygnvtCd5ujnCZ+Ho9FBD7EerIhAJUAAXXmXGSDRK7dzc7KkQRca5Pz3+toL+uOYsaaa+msolkolINqFcRTNE2WFSL9p/UkS3fJKdauPMpuhZJ3PdCVbWDJJSq+OPgTNIuy6QXYDG5giMRdipJEh0k3pxQh6IVKz+JWYQqF2WKj4WmIjN+GQtCyIWDjWu0EMKLXwbCDuKiRIqDkFFA6SGAvIeWeO/D4wJiOz6N4X49mQnDzh8pYsVgRdUj4Lmhu5bhqMPrkJ8Sflxm+67yQI15LSVoSKD0z+EX1Y1yGWY+EQ1rZ9OLyIjO/Db9O/B+yXV+sNbw6Z02AThJ85z0nMtI/3KZwE9Gmor9AuPPPaenBVoQZQ86Pa9yFWDknEUY6NzKKpDh7TWU9Hp03yritHjhFeR5ffvJMBP3QMTfdC6knQCvaTVHErKMy2omgUJ6gO/TzhGMEad1krvF8ioVlwoByhp8czSN5j8xQ4DlpXSNmDeYl9LGHBnggyil4ztRqLPj6B5yNyNo7fCrwObml751loKIalQbX1rS0Nt0TY2zboK0hp9YLE7rF40Dct3tQzDUz7kqgGlFBr+jNtv6RuJCjKmaR4HzltcaYdDXKkxaEaOmWPqXEx0vLNXe48uR7OT7nMKQdEPUxhCifswjvNxo9F2GWaT5nj+5NqyhYNPATfuS2+SZMJN0L4C5kbpjzja+Ol7qico6MGygVdwMfC0twAW6l5gaDmPvqEEQAZeviMy3CsFEo/PJn1vicdFaf91OdO4u/zvnncZcykogblr50ssMyWvlVqUnxdfsufhEKG+2bt5HSJ5DgJrfJ4nJd3sd9PzlKOf66k/9HYObtySLsL3w1amyRjCfWjLnIY5TJsb+lk01b1yAaLUQadMSE/VISNsoT8mYcIHMS8vOixxYuqOb/Fw7+VTUK0UdBdYOf
 pgrJlBG4
 vUN9reE8Mj6GUqCWAZd8ai3lOOvCAX55VHywBfGsU6RM7DmdREjUimyQbvpJqnENKo8udysQrweb4kUo0ekCDrNjQIeXYoexD5JSFJYcgKgXgfSSeg38hAcx51p9ASAcQOrHd+74Bf7rh3WMqFaMjcOxuQrScywBbwKviudE0L0K0adFPdlcegXcnMxBrtYsF1who3oUEwymKHN4uGWVYNHWAGDd/EUlWlI/msRcTWeojg+dPSbx4EGhuEB2plNF473wDZwRZ8jzr3nm74+G5XfCyN3EFVx392XyW+MibQj1LnNMK6ubOYDuHFXKmwfmwKqMdeYrS4pP1OqbIlMVyOar5nlhJIuDzZOW2XkBQQhEMOLHqPu1Nt4BrOZ3BcuvX6+eYoYaaBgOtYhqH0XNGzGyvphwRKHKwlyFU5CbCVId3C8lT+YVEsITgIsgXxbSNbPHHMD+XLyJVJNM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Annotate vital static information into inspection table:
 - nr_irqs

Information on these variables is stored into dedicated inspection section.

Signed-off-by: Eugen Hristev <eugen.hristev@linaro.org>
---
 kernel/irq/irqdesc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/irq/irqdesc.c b/kernel/irq/irqdesc.c
index db714d3014b5..89538324a95a 100644
--- a/kernel/irq/irqdesc.c
+++ b/kernel/irq/irqdesc.c
@@ -16,6 +16,7 @@
 #include <linux/irqdomain.h>
 #include <linux/sysfs.h>
 #include <linux/string_choices.h>
+#include <linux/meminspect.h>
 
 #include "internals.h"
 
@@ -140,6 +141,7 @@ static void desc_set_defaults(unsigned int irq, struct irq_desc *desc, int node,
 }
 
 static unsigned int nr_irqs = NR_IRQS;
+MEMINSPECT_SIMPLE_ENTRY(nr_irqs);
 
 /**
  * irq_get_nr_irqs() - Number of interrupts supported by the system.
-- 
2.43.0


