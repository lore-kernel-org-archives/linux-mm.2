Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 357F2EE6B46
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 19:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 612EC6B0089; Fri,  6 Feb 2026 14:13:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CA536B0092; Fri,  6 Feb 2026 14:13:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C8C76B0093; Fri,  6 Feb 2026 14:13:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 325976B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:13:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C85A2573DD
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:13:10 +0000 (UTC)
X-FDA: 84414979740.14.1367532
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id D8F12A0002
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:13:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=dubeyko-com.20230601.gappssmtp.com header.s=20230601 header.b=R1rD3vdH;
	spf=pass (imf15.hostedemail.com: domain of slava@dubeyko.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=slava@dubeyko.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770405189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Bu1z48KYD2GkC4sgRYY/gR/q5v6MBccc8TbuVDHZ7mU=;
	b=19B9FtGa68kYoprrf854m133WDE+3cvd3y1ow/QhyuOUtIucy5M1vkKtrM6ZBwHUctIi+R
	7VEZGO3HDYxK6ZMu4ikHg7YXcRbyR0uepMSqVy6uwMFcZPLDB5q7AdOTuOBDV3JbN3oyQl
	Qcr8PLeZJMk9Ddr2W4ScdGFJMW6IDMc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=dubeyko-com.20230601.gappssmtp.com header.s=20230601 header.b=R1rD3vdH;
	spf=pass (imf15.hostedemail.com: domain of slava@dubeyko.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=slava@dubeyko.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770405189; a=rsa-sha256;
	cv=none;
	b=bbBXASOgJnje/I5q4/dinnkS5aXtfJMZQksLkK/hw/zpc7WPpxfh8qCVNyJVP33BMT3ah0
	k9OpHQs45b4BtteUKSSS0UF0c/5PPkA+e/b4eQh+vg7i8F/R7zSwea4Qhz8TrhE6RbP4KM
	A0rGIPCcuPY5U7n0X6PW2R4SUTtGyl0=
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-794d4f11a20so10197157b3.1
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 11:13:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dubeyko-com.20230601.gappssmtp.com; s=20230601; t=1770405188; x=1771009988; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Bu1z48KYD2GkC4sgRYY/gR/q5v6MBccc8TbuVDHZ7mU=;
        b=R1rD3vdHBXPeQ/Z9+qb2gpkffOY0TniAR+8CoZ2fne9uBHa6VjOc9kXTFmb3FnkqkJ
         jjHON5bvDVYrIbx5tZYPAZRLKFmuQl+Lt2HxyL27XujH6ZISGwwl3ROvR5rz0Kf/SPx4
         2rveG2Vtp81kMquu4CSUuKPjjNn4kp5YMQSkwMjI7oxDHa1uzU7FtT+mTxZlD6ZqYwmh
         AT9GptqxAR3PX1QOzPBQIWRValqMx8mMsBxNYuE4uFt+aMQBPswiiDLXBbMGxB6+gOGG
         nFulMZVbRnF/rQoCrnnVoefZhDvPXHR2BUXC8k7hOYMjDwME/VdFE7al1FEt+piBYrST
         rISA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770405188; x=1771009988;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Bu1z48KYD2GkC4sgRYY/gR/q5v6MBccc8TbuVDHZ7mU=;
        b=JOLsEzWgQgtmNohEaaIqzko7JVxjhfS9Uqmp5KWJwYMqraUb6s76U29XEnk5wPDshX
         NDnBt/9VKWI8yBkgdRCvQMvlQvBwzCc8ebyCPNHxlKYdKNvBoLIy0ADrs7NhDaiI2T6P
         w4XuWNfO3o3sOJ8jVcUhDAIu1l9a8P+Lf3ewlI1OACzc2RXV+JWdGQfMdX6JjCjxZaeZ
         2V0MgUYB1msFrumLjawvyPJLkEdecQoBp8HyhgpkZJsO3u1S/4aly5ix/wMiCkbYM7iU
         mKsaBfkBU4wLhBJzmxXFJaxZspUy8I2EynDepAN2Q1WMo8mJ9xWVQY+Y5Ju6DdjFMBrz
         ADcg==
X-Forwarded-Encrypted: i=1; AJvYcCXv52P0+g3OFgMZLlui5EzSArzINLTWir1TyT4bX7oZUrqciyG8F5C9uK2kk5R7DEuWPTFA1i71GA==@kvack.org
X-Gm-Message-State: AOJu0Yw83Yq2vVbENphbIYi/nWpZs9qjNRSGUoO+L/jCGymkQoI5h6TR
	XUWEdaGoz7HVSP1+PvGFvP1DQh9N36vcB5RseMLgKSZbvUUoD8jnRti8lLtyM32rPPcW+sNcDdG
	99fUr0x4=
X-Gm-Gg: AZuq6aK5hwkj2Z/eCDR8zqvcHaayBXrR47+KC3qTPdZqjMtJb757S3n3qUwPlBA8yGc
	qWkak/f1v6u9C4bhklIYp2aE/gFHwLTUnISgbJRgbcpi+f276OC9IjyB1M/qnZ+24+iICPTi+Pm
	7U19dsx/FPt7BHiaOnc+m1MNE7IaUPX5wAMoF9/1RxyKn+VjLrnOIrtw9At5qrE+vdSAooKxn6p
	Oon0HiWv8VwktDrTlLAf7BUsXmy73sm68u3jBh3xQcgvRAPoFGoxb5DfVaHz15Xykk2iOx8rhwI
	kgx0Iix8w1o7WqZX4P0q4lval0j+aV3/2Gavp6oYHrwAJCFFzrHkpktlxD7Y9A7e5CMtRQ8CU2P
	VfPaofzI0msPqtvQd6fx5xkgKt52IKLydUduhep0bnDRvjVDk0ECBLFCKMEc2E6AoUrg9YbLmI6
	/iV3TV8ukaRz7PFXZOAPUsCIDhXGSsy97FbT1A0rAMxedjYT4J8ZvRLkLCb/BSGLkRjdiV/cEJq
	Sl6+JEAZ4zB
X-Received: by 2002:a05:690c:4510:b0:794:e3c2:f338 with SMTP id 00721157ae682-7952ab1a634mr38039097b3.42.1770405187694;
        Fri, 06 Feb 2026 11:13:07 -0800 (PST)
Received: from pop-os.attlocal.net ([2600:1700:6476:1430:9fc0:ed7d:72bd:ecd1])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7952a28697fsm29051277b3.50.2026.02.06.11.13.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 11:13:07 -0800 (PST)
From: Viacheslav Dubeyko <slava@dubeyko.com>
To: linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org
Cc: Slava.Dubeyko@ibm.com,
	slava@dubeyko.com,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 0/4] Machine Learning (ML) library in Linux kernel
Date: Fri,  6 Feb 2026 11:11:32 -0800
Message-Id: <20260206191136.2609767-1-slava@dubeyko.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: wpchanhqmh4h7p4sw9swhefui3iredu6
X-Rspam-User: 
X-Rspamd-Queue-Id: D8F12A0002
X-HE-Tag: 1770405188-239009
X-HE-Meta: U2FsdGVkX1/gQ9IypTuP6HP0U2mdm0B+66/wm8aQBFWIE8dr7zWfPy9yT+4wNBfTqbzIs0fOhinYrk5gjZaVs3n/sXbEwkJEUXiQoRojc5SGRGTQO+/2Qd8Zz5L4u9AS5JWXJOKQkEuV6LI9yEEPhz8JaerCDMcIJTd6pvhGDeN94oT1zy5FM49J5Zv4xrBEQbYydQDv7Zhz1Q2g/T57XQ/WrTiBTEsuDsIoFvCIDaot8ElE9V0EesIYxmEm9n1xYovvR4hY/KfpqcYyXm4LqZUFfBEozFOKMjDQ3WPiIV/SUDZJJ0HNx4Pii7+np3aFQqbf1fBNLbeREciXxbQYvWj/t8dLOaL2N87p/1g51zXC3M1vSBpkFvpbpmkDyX/M+ofAXodQjZP4AdV+ZFxqf12eY18T3V7wZrgN2GSdf4TEi43p2aPxpgrxLjk57RJqagWpEH9YKVbk6Mgle7G3AfqUAXQNkjNNSIZBcDlJ0h4oahnnHzoo69B2Y0gjSUg84J+bBKVY1EnWQgRXpVM+eOFM8RETETlHkDcaf5N1O2jtDb/+AKbYS3O5m3CPDf0vXTOW4CA+oAoU7USKMlwLdXfZr6dKsHr4ir0YpRZf6Q088YiQob4dVZS/mB9tsicxaHkzObXJUPav2197yovnWFY8/iVzU51ZQ1ZcklEIW++rLG6BBObZuTsfaiQ3a00Pjfs3m8K2ZQp4hqTye8WqaT8T3bw5dVWdufzdaBSrEGBjduWu6ZdSr/OJT0lvLXEKUh/K06ojNs877Sc90bN7wubW1jvcLdJ46OjsKh8LW9dCxn+rgj6SrbLXZWvH9EJ10KKWjFkXoj57zVEXUijD/IlPAgza0mNvyKZ6jPEnRroHVfMzwGByu2lXQOFARy5luEJk9M8ZsrvwMmnjeyp4373s2pb+Z8u3HwAwvBUxNk/01LXNtM32OPIMUGozOqJLBX40aYS2l9Od23Jb6zw
 roXTude8
 U3q5w86DyWuzud4V4TlFTqLbbfRdEj7DoLlS6TfCjrQBDPP+fRSxN3sKg+wePTs6ewrRDmAORff/LZOVn8PtLahPRFfXutsZ+Ov6NDpkSJfiDVz+6nKVnBSSJN8QUSzLnoNkf76BUv+TP1k8JjGRKPE4XwiMI2bpL4Elg9cZtQJjxS2Ec8G00L64VL45ZLeQsXhFsS3qDOLSyezLjFprgYJMeHUuj90nZZkoImVrD5FmRxhoN/ZqZ/QOxj/VDqwo71Wi7Adydq3QiRovLh1ngFwfPIkCbPsBmITOetvFmZUvyoMrGs4wtIiq02dNCTVO86gMp+qHrzL+DSWgZ5xuISBUSbzgUu4bdaDvKx1UknmVAOJTgZZNUpDi5OpL1D9XxieYiewUl9ezO9FVzQMRka0W6y3P66gVPMjBhsB2bKYIKcTtM1Zkxa6FFyVuzdcWVkh8T+yCXJRiiZ13n6ig8BWcv+KOkjcIo1jK733Jv9WT7B8PTgmKhKs6DikS33+dxdO05p8DTBBFe3BOSvXSkjPLM96l1qWj4vQPyBoK22Wi1iRI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

This patchset introduces initial vision of Machine Learning (ML) library
in Linux kernel. It is an effort to define the ML library API and
to elaborate the way of running ML models in Linux kernel.

Linux kernel is a huge code base with enormous number of subsystems and
possible configuration options. Complexity and changing nature of modern
workloads result in complexity of elaborating an efficient configuration
and state of running Linux kernel.

Machine Learning (ML) is approach/area of learning from data,
finding patterns, and making predictions without implementing algorithms
by developers. The number of areas of ML applications is growing
with every day. Generally speaking, ML can introduce a self-evolving and
self-learning capability in Linux kernel.  There are already research works
and industry efforts to employ ML approaches for configuration and
optimization the Linux kernel. However, introduction of ML approaches
in Linux kernel is not so simple and straightforward way. There are multiple
problems and unanswered questions on this road. First of all, any ML model
requires the floating-point operations (FPU) for running. But there is
no direct use of FPUs in kernel space. Also, ML model requires training phase
that can be a reason of significant performance degradation of Linux kernel.
Even inference phase could be problematic from the performance point of view
on kernel side. The using of ML approaches in Linux kernel is inevitable step.
But, how can we use ML approaches in Linux kernel? Which infrastructure
do we need to adopt ML models in Linux kernel?

What is the goal of using ML models in Linux kernel? The main goal is
to employ ML models for elaboration of a logic of particular Linux kernel
subsystem based on processing data or/and an efficient subsystem
configuration based on internal state of subsystem. As a result, it needs:
(1) collect data for training, (2) execute ML model training phase,
(3) test trained ML model, (4) use ML model for executing the inference phase.
The ML model inference can be used for recommendation of Linux kernel
subsystem configuration or/and for injecting a synthesized subsystem logic
into kernel space (for example, eBPF logic).

How ML infrastructure can be designed in Linux kernel? It needs to introduce
in Linux kernel a special ML library that can implement a generalized
interface of interaction between ML model’s thread in user-space and kernel
subsystem. Likewise interface requires to have the means:
(1) create/initialize/destroy ML model proxy in kernel subsystem,
(2) start/stop ML model proxy, (3) get/preprocess/publish data sets
from kernel space, (4) receive/preprocess/apply ML model recommendation(s)
from user-space, (5) execute synthesized logic/recommendations in kernel-space,
(6) estimate efficiency of synthesized logic/recommendations,
(7) execute error back-propagation with the goal of correction ML model
on user-space side.

The create and initialize logic can be executed by kernel subsystem during
module load or Linux kernel start (oppositely, module unload or kernel
shutdown will execute destroy of ML model proxy logic). ML model thread
in user-space will be capable to re-initialize and to execute
the start/stop logic of  ML model proxy on kernel side. First of all,
ML model needs to be trained by data from kernel space. The data can be
requested by ML model from user-space or data can be published by ML model
proxy from kernel-space. The sysfs interface can be used to orchestrate
this interaction. As a result, ML model in user-space should be capable
to extract data set(s) from kernel space through sysfs, FUSE or character
device. Extracted data can be stored in persistent storage and, finally,
ML model can be trained in user-space by accessing these data.

The continuous learning model can be adopted during training phase.
It implies that kernel subsystem can receive ML model recommendations
even during training phase. ML model proxy on kernel side can estimate
the current kernel subsystem state, tries to apply the ML model
recommendations, and estimate the efficiency of applied recommendations.
Generally speaking, ML model proxy on kernel side can consider several
modes of interaction with ML model recommendations: (1) emergency mode,
(2) learning mode, (3) collaboration mode, (4) recommendation mode.
The emergency mode is the mode when kernel subsystem is in critical state
and it is required to work as efficient as possible without capability of
involving the ML model recommendations (for example, ML model
recommendations are completely inadequate or load is very high).
The learning mode implies that kernel subsystem can try to apply
the ML model recommendations for some operations with the goal of
estimation the maturity of ML model. Also, ML model proxy can degrade
the mode to learning state if ML model recommendations becomes inefficient.
The collaboration mode has the goal of using ML recommendations in
50% of operations with the goal of achieving mature state of ML model.
And, finally, ML model proxy can convert kernel subsystem in recommendation
mode if ML model is mature enough and efficiency of applying
the ML recommendations is higher than using human-made algorithms.
The back-propagation approach can be used to correct the ML model
by means of sharing feedback of efficiency estimation from kernel
to user-space side.

[REFERENCES]
[1] https://lore.kernel.org/linux-fsdevel/20240605110219.7356-1-slava@dubeyko.com/
[2] https://www.youtube.com/watch?v=E7q0SKeniXU
[3] https://github.com/kernel-ml-lib/ml-lib
[4] https://github.com/kernel-ml-lib/ml-lib-linux

Viacheslav Dubeyko (4):
  ml-lib: Introduce Machine Learning (ML) library declarations
  ml-lib: Implement PoC of Machine Learning (ML) library functionality
  ml-lib: Implement simple testing character device driver
  ml-lib: Implement simple user-space testing application

 include/linux/ml-lib/ml_lib.h                 | 425 ++++++++++
 lib/Kconfig                                   |   6 +
 lib/Makefile                                  |   2 +
 lib/ml-lib/Kconfig                            |  18 +
 lib/ml-lib/Makefile                           |   7 +
 lib/ml-lib/ml_lib_main.c                      | 758 ++++++++++++++++++
 lib/ml-lib/sysfs.c                            | 187 +++++
 lib/ml-lib/sysfs.h                            |  17 +
 lib/ml-lib/test_driver/Kconfig                |  22 +
 lib/ml-lib/test_driver/Makefile               |   5 +
 lib/ml-lib/test_driver/README.md              | 233 ++++++
 lib/ml-lib/test_driver/ml_lib_char_dev.c      | 530 ++++++++++++
 .../test_application/ml_lib_char_dev_ioctl.h  |  21 +
 .../test_application/test_ml_lib_char_dev.c   | 206 +++++
 14 files changed, 2437 insertions(+)
 create mode 100644 include/linux/ml-lib/ml_lib.h
 create mode 100644 lib/ml-lib/Kconfig
 create mode 100644 lib/ml-lib/Makefile
 create mode 100644 lib/ml-lib/ml_lib_main.c
 create mode 100644 lib/ml-lib/sysfs.c
 create mode 100644 lib/ml-lib/sysfs.h
 create mode 100644 lib/ml-lib/test_driver/Kconfig
 create mode 100644 lib/ml-lib/test_driver/Makefile
 create mode 100644 lib/ml-lib/test_driver/README.md
 create mode 100644 lib/ml-lib/test_driver/ml_lib_char_dev.c
 create mode 100644 lib/ml-lib/test_driver/test_application/ml_lib_char_dev_ioctl.h
 create mode 100644 lib/ml-lib/test_driver/test_application/test_ml_lib_char_dev.c

-- 
2.34.1


