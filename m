Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C79B6CCF9F8
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 21:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7FB98E0017; Fri,  7 Nov 2025 16:05:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D141E8E000D; Fri,  7 Nov 2025 16:05:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5C2B8E0017; Fri,  7 Nov 2025 16:05:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 95CDE8E000D
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 16:05:56 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5B50E13B586
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:05:56 +0000 (UTC)
X-FDA: 84085043112.06.8E040DC
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6C45420005
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:05:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=D38c4fJY;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762549554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eGX1JNngtcEnINGvpjjZOvPiM15RTyTbrS+2qficDEY=;
	b=jAy4izTxrnY8T8MEqkdNjNGWQJGLi+TU3Bg4qzDXhAOfLKxPoPNFLTgu6IcCB4HySEpIBk
	OF8wPeCdBdG2DiLQ3dXYgIjkK/6flQFz/QrD8mGrTHLay39klCDY/mul/8iY1VDPZ8iILd
	uinJFxV0J9jLRyy3siQL3CwLiA2ZRn8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=D38c4fJY;
	spf=pass (imf03.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.170 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762549554; a=rsa-sha256;
	cv=none;
	b=SC6FTsvaFqAONDFlyoxTsx65XvowRSeWXWRHcLc4nzjdKiA4I6aMP3E7PnvosePp2+PeCo
	omu8W0H7kMD3clXoYeB28W/1TsDmzptr9THY9uXrSkjkoFUYrd47Gd9rWG5dLK4ddBltAV
	PhJ4fDsbAr2DloTeHQl0oXm4FZNq12M=
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-78488cdc20aso12735017b3.1
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 13:05:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1762549553; x=1763154353; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eGX1JNngtcEnINGvpjjZOvPiM15RTyTbrS+2qficDEY=;
        b=D38c4fJY/mSBHzcvbuhD1G2EcR1WgS/pZ34RU18zj5QpwEhDD2hTdniAgggK4kMoc7
         k0VZEY+cEoJMJ1MotZ7S5v5tlc9QihcHDFtEJe/mp6JlYK0KcNR96N+pi8bPriv1mco6
         SsYuiVye9/Bl6LP1L6KUyUoRioPlksndfqAtWsEdyRFCFMPaSjlupHn2lRJqrd1zFpvY
         DAgLUPEDBiOllVPIcg7IZ/t0kcOTdYrlxd2xueAOWq+YepdfgiL8t8/Sehe5xXmwlman
         Mi9+x/DpQFPh1/mXx8sojaCAGCjy9j//TQAW7Dk7vF+P2Hddmzyo34lhjm/6qdlb/U7o
         ZUtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762549553; x=1763154353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eGX1JNngtcEnINGvpjjZOvPiM15RTyTbrS+2qficDEY=;
        b=bB2iKnxGtw17iQY/RexurQsIqZRYDA2fxbpE30HktJ8k4+lTzYM67q9+909NS+jzox
         JyVkIS8SqpW6ehQcjc2A222392MjcO/P9zZVh7+/5JxN4KOw9HV5QAd46/krG1pDRLoF
         nMR4ZcvScZWeCDcLfJL12gOEg7UlJLGzIOZR7GNPwvMNmIXNnZfSMGDcTSYvYlTaO3kv
         xcIMn2ap2IIIdyZGMwDDbBOEI3UOGrCGGr3hrYdpmLTzHoYvsXpoUHhSMcLLAGp8wTi2
         xJPUubR2xcrFrOqFtFiNUplEqoK6veOqVP6Eo8TpHYWryw105PG/UvOvOsvN0SKktaDo
         YnHA==
X-Forwarded-Encrypted: i=1; AJvYcCXMVnFjpPEHlYs6MGsXsgEfw1srEW8iGeHXugahHWsnHVMuJciMgyKi3sOlpzIZSaGI93TTB5KkNw==@kvack.org
X-Gm-Message-State: AOJu0Yw8/3w/IuStXXKQ6rUx2ama5ZaH/tVa+6vedzhQSU1t/2G7wzkj
	g7hcRqnaz+v9wJBRl6Y0I1S3gEmnTIj8xS9iYQg+aBpH5tHqVfOoERYOVW1EopWsLC8=
X-Gm-Gg: ASbGnctuGW58GLUk/x1d5b6dbBVa8Uv81Qd9eWR3k+pYU+g41fK5Y1Ap+vvAPMZvoM9
	ghhEYtbS760stNfe/lM70NseK2xoWG5vuQwtl5NvyjpQocK2eJ/i8jBoQN4N+ivoFNUCKikslcz
	5SQ6RAanp93WhhtryOA3OjoJWs54mesQw+3/8bq2z321aab8F0XhxXFxygX0OOjyPYHujgCCZpo
	St9I8Avca03mZWKYXOrSki6k9Pgjndr1UEW/trXvyYKlMC871Vbp5/yEQVm7EcrTMO8k4dscUbY
	svpA+jhoeG9TdvIFLd5ox/36vcBPVldlsOPu8yKFrTdhFYautnTHZ0LuxSa4S4mHq/tHOa0X+rf
	0ApTtGaE9m/O7HVRCm8bXdtmWNA6A3sngkdCqwlfmGmc8uZy/cqT+bL3W9fjeArxOiBxhyM/lJk
	ed0wkPlMBTxiJ/kwxWxx34jvCbta0wMHTh4lpPuZKn2BgGvlgyWOoWCrtB4HGaItEKPN5CRAD3Q
	g==
X-Google-Smtp-Source: AGHT+IFbkLlhQosQFQ+WdXArr3gHVo/6dHC8xvUgFjTdDqpIfNT6vGARK5zq5TsgxqtRCa2zCH7RmA==
X-Received: by 2002:a05:690c:c341:b0:785:ec4f:3c8 with SMTP id 00721157ae682-787d543901cmr7438187b3.48.1762549553481;
        Fri, 07 Nov 2025 13:05:53 -0800 (PST)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-787d68754d3sm990817b3.26.2025.11.07.13.05.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 13:05:53 -0800 (PST)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	pasha.tatashin@soleen.com,
	rppt@kernel.org,
	dmatlack@google.com,
	rientjes@google.com,
	corbet@lwn.net,
	rdunlap@infradead.org,
	ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com,
	ojeda@kernel.org,
	aliceryhl@google.com,
	masahiroy@kernel.org,
	akpm@linux-foundation.org,
	tj@kernel.org,
	yoann.congal@smile.fr,
	mmaurer@google.com,
	roman.gushchin@linux.dev,
	chenridong@huawei.com,
	axboe@kernel.dk,
	mark.rutland@arm.com,
	jannh@google.com,
	vincent.guittot@linaro.org,
	hannes@cmpxchg.org,
	dan.j.williams@intel.com,
	david@redhat.com,
	joel.granados@kernel.org,
	rostedt@goodmis.org,
	anna.schumaker@oracle.com,
	song@kernel.org,
	zhangguopeng@kylinos.cn,
	linux@weissschuh.net,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-mm@kvack.org,
	gregkh@linuxfoundation.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	rafael@kernel.org,
	dakr@kernel.org,
	bartosz.golaszewski@linaro.org,
	cw00.choi@samsung.com,
	myungjoo.ham@samsung.com,
	yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com,
	quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com,
	ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com,
	leon@kernel.org,
	lukas@wunner.de,
	bhelgaas@google.com,
	wagi@kernel.org,
	djeffery@redhat.com,
	stuart.w.hayes@gmail.com,
	ptyadav@amazon.de,
	lennart@poettering.net,
	brauner@kernel.org,
	linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	saeedm@nvidia.com,
	ajayachandra@nvidia.com,
	jgg@nvidia.com,
	parav@nvidia.com,
	leonro@nvidia.com,
	witu@nvidia.com,
	hughd@google.com,
	skhawaja@google.com,
	chrisl@kernel.org
Subject: [PATCH v5 11/22] docs: add luo documentation
Date: Fri,  7 Nov 2025 16:03:09 -0500
Message-ID: <20251107210526.257742-12-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
In-Reply-To: <20251107210526.257742-1-pasha.tatashin@soleen.com>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 6C45420005
X-Stat-Signature: o5eerbjfk3zmhjirk4qrk8s3u83wfs7z
X-Rspam-User: 
X-HE-Tag: 1762549554-551029
X-HE-Meta: U2FsdGVkX180CZhZXISjFaVtNmW3xKKzPX+Jw7i8eA8S5mre/R5YRc/EbgPBBrhmP2xyLBSGZBxzEMKg46APX7EkW7RHwYfNMfqHlqqe/9buPGp4eXDoQVEvo/Rs+3pMNLVlsI2jlbiOgu+bll5A1jQqvnjxrZZB4PZhE/pNXvt3R7oAWmNtkvaRS6I4kSHTnzjRzkmz5bafco/4dNBI2/T/ICP4eJnBCVsSXvtPR6HvbsCwvvkyiVBie/3+5n+ukoEBsyBQiFxHbU0tU4cvX3Q6/Y4Cwy+Ad+uUyEyp9X+8mXTGVUwXPHG37h6TDT3fFTFY6fIE5vCtZepE+x1h7vtq51O458LcwetCZhw+28p753FzFHt7aew4FkpOYhiQNWUlEoe0BYL1lhMunHbkkfRhF3BPTTyPW+gSO0JVtzr3i/p8SuENkRwcMWXsJxf0E8idPOYtwkv++Gp74SFfvdK0lNMRUzSI4VcJoDhxJEnk7vqKOM2eB3wmcW4FVuHXjcSHjqrTvEw2ogPeYlVNDdiyloBp8IPrARJHuvE2f7M73cipMinQPz9nVB42h+zbSiNw7i0HlDnTVc0b8nc1PxLSwcnAwuzFoq0d6PsZZ2k2i8LcaY0AQq4/GUs7g/Q2SRRzHHz3bgstauyplIbNrgG+kqRTkM4OXIuL2847063+IRAbgYIOo7YU97n60m0gtQwuBToGB8weDFo+k1iEWF7GjC+Spx8h24jx9vnfaREkFONxqqJ96fsrUtEWDuFhORFfyPC+A5vRrSldBrqkEF5vRYIKKskabO7DO1wbk2hHco5SAYlOb7x83jO5DaIB1Rvd3QL61y/q2s0VK7nS5qGB2c7h8MdJdFX0XEQfXpYR1JXNs2Ru0Ek80nwq9nLV9rTffrTpuO0O5IF8Ux8jwDmuNdjapc63+q5WbCy+F9F5kjez2jd3NqM6Nb0dFvqmF8cq/WwSfT86mKIhaSL
 Ln4BWDPA
 HlIk2QnG+ofJ5Vy0Ptf4wWyjFtDswxEA6hLkuYA3yQtnc0eI0JF9cmY5E+mRQuxpuBXrsqV28i+jL4GrhnKwYnWcZa5LvOIetxHQMZVNTRl3HPcYzMLuRqQSYaWIcOUuZ3oMfJZVg9U+QQf7frrsgPo5WjWH0FBbmxiTzA78CSeonvhaT+6VF8QAGkYX4b/N0fdHuguxBa/RFEqbUXGoPQdkfyZi8Z81EVtrb85KFdjuQpZRwngjQ+qcz2gbTUeyeMx3YVvzyoqGDHf434VxgONIqEB31zKfY7W/0EPFCbw0q9iMtP5ZJFeXeyGDbdCm7NOo5KwrLNWWasCsNkJWKtcQ5CiKYHncPuOyswDNuxQsWK0ZksFQmbCh1qA/YabTvVLsq+XDHQqpetxY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the documentation files for the Live Update Orchestrator

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 Documentation/core-api/index.rst           |  1 +
 Documentation/core-api/liveupdate.rst      | 64 ++++++++++++++++++++++
 Documentation/userspace-api/index.rst      |  1 +
 Documentation/userspace-api/liveupdate.rst | 20 +++++++
 4 files changed, 86 insertions(+)
 create mode 100644 Documentation/core-api/liveupdate.rst
 create mode 100644 Documentation/userspace-api/liveupdate.rst

diff --git a/Documentation/core-api/index.rst b/Documentation/core-api/index.rst
index 6cbdcbfa79c3..5eb0fbbbc323 100644
--- a/Documentation/core-api/index.rst
+++ b/Documentation/core-api/index.rst
@@ -138,6 +138,7 @@ Documents that don't fit elsewhere or which have yet to be categorized.
    :maxdepth: 1
 
    librs
+   liveupdate
    netlink
 
 .. only:: subproject and html
diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
new file mode 100644
index 000000000000..deacc098d024
--- /dev/null
+++ b/Documentation/core-api/liveupdate.rst
@@ -0,0 +1,64 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+========================
+Live Update Orchestrator
+========================
+:Author: Pasha Tatashin <pasha.tatashin@soleen.com>
+
+.. kernel-doc:: kernel/liveupdate/luo_core.c
+   :doc: Live Update Orchestrator (LUO)
+
+LUO Sessions
+============
+.. kernel-doc:: kernel/liveupdate/luo_session.c
+   :doc: LUO Sessions
+
+LUO Preserving File Descriptors
+===============================
+.. kernel-doc:: kernel/liveupdate/luo_file.c
+   :doc: LUO File Descriptors
+
+LUO File Lifecycle Bound Global Data
+====================================
+.. kernel-doc:: kernel/liveupdate/luo_flb.c
+   :doc: LUO File Lifecycle Bound Global Data
+
+Live Update Orchestrator ABI
+============================
+.. kernel-doc:: include/linux/liveupdate/abi/luo.h
+   :doc: Live Update Orchestrator ABI
+
+Public API
+==========
+.. kernel-doc:: include/linux/liveupdate.h
+
+.. kernel-doc:: include/linux/liveupdate/abi/luo.h
+
+.. kernel-doc:: kernel/liveupdate/luo_core.c
+   :export:
+
+.. kernel-doc:: kernel/liveupdate/luo_flb.c
+   :export:
+
+.. kernel-doc:: kernel/liveupdate/luo_file.c
+   :export:
+
+Internal API
+============
+.. kernel-doc:: kernel/liveupdate/luo_core.c
+   :internal:
+
+.. kernel-doc:: kernel/liveupdate/luo_flb.c
+   :internal:
+
+.. kernel-doc:: kernel/liveupdate/luo_session.c
+   :internal:
+
+.. kernel-doc:: kernel/liveupdate/luo_file.c
+   :internal:
+
+See Also
+========
+
+- :doc:`Live Update uAPI </userspace-api/liveupdate>`
+- :doc:`/core-api/kho/concepts`
diff --git a/Documentation/userspace-api/index.rst b/Documentation/userspace-api/index.rst
index b8c73be4fb11..8a61ac4c1bf1 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -61,6 +61,7 @@ Everything else
    :maxdepth: 1
 
    ELF
+   liveupdate
    netlink/index
    sysfs-platform_profile
    vduse
diff --git a/Documentation/userspace-api/liveupdate.rst b/Documentation/userspace-api/liveupdate.rst
new file mode 100644
index 000000000000..04210a6cf6d6
--- /dev/null
+++ b/Documentation/userspace-api/liveupdate.rst
@@ -0,0 +1,20 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+================
+Live Update uAPI
+================
+:Author: Pasha Tatashin <pasha.tatashin@soleen.com>
+
+ioctl interface
+===============
+.. kernel-doc:: kernel/liveupdate/luo_ioctl.c
+   :doc: LUO ioctl Interface
+
+ioctl uAPI
+===========
+.. kernel-doc:: include/uapi/linux/liveupdate.h
+
+See Also
+========
+
+- :doc:`Live Update Orchestrator </core-api/liveupdate>`
-- 
2.51.2.1041.gc1ab5b90ca-goog


