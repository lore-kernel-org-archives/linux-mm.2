Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6F20CAC5B5
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:04:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2030F8E0017; Sun, 28 Sep 2025 21:04:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18EC58E0006; Sun, 28 Sep 2025 21:04:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E612D8E0017; Sun, 28 Sep 2025 21:04:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CB1B08E0006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:04:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A1872B7426
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:37 +0000 (UTC)
X-FDA: 83940492594.13.7E71FC9
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id D6D3B180005
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:35 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WMjxQusW;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107875;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4673JtxFCCWFxWem0KySHim/AVBmSFNvOtZj4TDhxZ0=;
	b=pLO1WItAeUmtDytzcSrYERz6rqHFgtvpPR6rSqkFJE4MAszKJHVI0oYGHuZgwod2bzRPlc
	fMs6G+dEg0iHPyzE1hTzfbKe7hGt7Ayy9pQjx0WRchKQayl+l5tvS2Qy5JcYwwcS75yj6q
	EpIUKzApBhM0ZFAuryoepuyRM1dV4Q4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=WMjxQusW;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.178 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107875; a=rsa-sha256;
	cv=none;
	b=MnrDV6Yc4OiNtbeB+6DP65rQepeTyZRbF0hWPamjY03HxEyd+IF6nLKQ884keW0Gt0a1km
	wg0SkYAkSz1YRsWifNhYov/vXWPIIaGgedjRxW8+StZCMxtjZzMY9GL5NbpEtiV0FXsqvx
	40Hw6irVG0eHsfmj+ppaxDJ64iTWVqQ=
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4dce9229787so33646531cf.0
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107875; x=1759712675; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4673JtxFCCWFxWem0KySHim/AVBmSFNvOtZj4TDhxZ0=;
        b=WMjxQusWJpg88mu+RzXSDyCdPx5oD6DlWkSr8GDEYAaktWx2dQ4mMIm4Hbzsq3ED2+
         zu/4KfrumQG2N8kNsjrzwUYHmGeNtL7Uve8fL3g9Vy51fLKwdnD7KiInCpCRy13nNK3U
         tkmi45Xy0s/FULYAq6OsEpaBilLb/cxQQnIh/7djvKfb4BGs7ivwnUx9l8dq0v8e6DjU
         9xqStBnDHgO1p30lqhc3CqWkeP/+3IbNR/wASybpA9SjPNgLcmDeSMfiiCutCt0BP3FT
         RkaABkMQw4DHOBm6NlWhOpcht//q76i7VM0DEUBC+VvtKbYFaZ9FeFwshHUFW2js8A2C
         VcFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107875; x=1759712675;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4673JtxFCCWFxWem0KySHim/AVBmSFNvOtZj4TDhxZ0=;
        b=g+ZW6ZLoTLW2sQ0uJqn0pH58xpWmDY1yNTEdVYEth+IAVeA87YlizDKhRlLWvQ4As7
         6pEJbC7J4Gc3+inesLQ1tGDb8vc8AcUczFZ+jTtVPXmGwPH6yOCz9SE4NJp4DToA1uD5
         jmgJgRcvzpbHKWJvBMk8r409qprq+L12d1iR7GCgL5i4UP303XXkS5kEJ5PrvbPP8c9F
         8xAr4iy8EHiTKuC1SlJq/8AsaZ0MZSCmsFB3j/qFRNW4zva0KLeiPxwzRY7gxi/y46Ml
         Iv+PCjCCqgWdMa1fjnjVm0cp5c+jPB88ZyQu+YVBe+GMiXf5klzJxRBqH09ZDx6ngCzP
         PQwA==
X-Forwarded-Encrypted: i=1; AJvYcCX16beJyBXdYt2mo5crI6UM3/l7r5Lg5TEDLCGxK+LK2q+qlpy8N+2HHVUw5XUD//J1uLZAOUklxA==@kvack.org
X-Gm-Message-State: AOJu0Ywz0DRKrl13GSgCUABdQgdtgWZG0QriajzyWrcS0pMPNJxhlL1l
	v9CKIZRr8v9SIMmDsLDlfASXCA99eQSsmR7b6NtriLnNnPBTPPEAQiMABbSNHpJWWOQ=
X-Gm-Gg: ASbGncusA+sqF6w1YCwnS32O+dKdT/sBwvYSLqJr0ji2Pz3G3oXjrmPgL8jQk27st+f
	WejQulShFKujQYFofLZMULlT07IykbIpZO4VCiczjSaEQn8KlnCXFhFhZmRRZGwwhyeMy//R40V
	uoiAUvwLj03XGbRvRA//32oJIiED+dF18KQFXfGaHYBICEqi8TEF15Y8sT86QSdrhnoSoDjZ8aT
	nKz9IzITjFeISVqQq6BGf2Fz5ll7cJcfN/oeJMCuUYwHV8fv4uHANsCWOVhlLqV2U4PQtAZQuIp
	EZuOebKD8Wlti5rRosBafrjXwIbXHbeB+QDckXUARVFFqmQMULL1vC3ttAvj1OFaIK7bhB6iocY
	2Enhs3F2TAZy8Gvo6vxW5W6VzJDbaRYjwObVr69Csrisx2dspAM46v04FzFyLzdZvZE3TE0NIwF
	I5QPY2okMHT1URHsKUcg==
X-Google-Smtp-Source: AGHT+IGDD1FThqyz2U7zZsapceDkvp6OYAFPiCrTNFDU7CmxN/gojkNSulBOcc5jk5r12Vod1QdZCA==
X-Received: by 2002:a05:622a:5c8:b0:4e0:b5ef:2ba3 with SMTP id d75a77b69052e-4e0b5ef2f60mr33122951cf.37.1759107874548;
        Sun, 28 Sep 2025 18:04:34 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.04.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:04:33 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: pratyush@kernel.org,
	jasonmiu@google.com,
	graf@amazon.com,
	changyuanl@google.com,
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
	chrisl@kernel.org,
	steven.sistare@oracle.com
Subject: [PATCH v4 15/30] reboot: call liveupdate_reboot() before kexec
Date: Mon, 29 Sep 2025 01:03:06 +0000
Message-ID: <20250929010321.3462457-16-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D6D3B180005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 9z31bnqcb914jkznrmemb9qpk3pb5no4
X-HE-Tag: 1759107875-781177
X-HE-Meta: U2FsdGVkX19cUbbJiFcbvyZk9U36VLkhEXxvtWFGo8c55toXkvql3oewLzj13lwPl9GA4xnLFuKppxGdzmD02YuzjorG1qeyYVEF/wRKXYrE6n5aKmHoNutmjKoqw6rVJucZrj4LmF1iIIrM1H+RLHVDiZfoK9CusOgYVCANM27r05XGsfyXEgcKN1oPL0Mlbz55NADlJktlMT2FaJ4LnkXeOzxbMsX9JmwTm+HQX/VcVYJmzs7jYucbLNzaVlpaQPr1/bl8egG5JR/DNLpVk7WDoGYIRTzxnSbwOiBqNN/Vup3WnCBhaVLN0A+ggnrMUvFH03i1UkWmrcufy/XSXcPQ5vnYmP9e2HI403FXmRQmkirjDWtspIiH3tOCMhp6a6IS/V+BfeTqiKepTEOSUqXEdHsRGUVwYi7zHsjBE2K9at4w+J0DIAHTtjz6CRLzzB/H5FEBkY1mhNAi8D85iLHBHMPMcAi+uF/zfCc+W74uoWEdkd6PXzrYWFv/bq1yLLGkhjjpB/i0YJU+PSQUvnrzw5MCv+iWPjEOBgEAa+jfK0MMabNProOBRPkQcZ/Zw+LdM7egAqY9onCnI5QF3enFJJmOQ+wOXIk7p9XIBkE/ZdRHUALz/ZUjSGaJ8LoxEKQyH5FwbGGEMXKd9//EdHMbHqbmnFHyzKJRmYLL1cZ6fOe0c1Y0TrXkY5VfowSIFi9KgDzBltIT0y6wirgLcSagncPN7/NeiNazz8qv45Tq1LJXJBn8+/1s2G5ceoD+PFyKKiqt9P60iEb1rxvO6N9plkvqF1uS3cA/mFggsfbePShfqhal0oWZ33Afy0mm6ZPoDTkbs1srFwjrr8Mx3FLwFigh/zDQZhl5W8EP5C3oDAkfj+uJdZBJYiHtcC0qSddErz7q7YUDmk69FmXEIvvr3w8/eO2zeFpseIvtjjcs3PW7LZ72MO/cibFj7VWUuID3eArlRek7D2/HnSP
 TKnNFrov
 ny7riX4b0fnyhyib5u9+mb56qE+Sl2ehlcsniXfX/U71jxzMAM0Fo5XTpbXPYh2YQOoSKEGtKBnuSOGndEw9ce2psPGgx6Xl80dKEnG8hN+ChN4q/GS4ODZBQqb28OSLOUlIxGGYCgVBb0fxIEG15ZAAX+doH39aTP1VXTWE/BgmmIK4OMVIAufL3b/oelW6f+t1cI/39Y2geBosXdtiFG+f27BDYaKBZ7C8uGonK/uZe15j3M7ro4lWl9EpbHb1nT8kflPsmDO86JQ2TOc2desAPHakgDPRD3FyOImE5dM2YRdhaEpK5Do/TvtgJc73Kwxh3G6TF0wsc1cjZE9/Ksb7LtNa1o6ZfUyZX8NAiHDzg7AXkddgW6lXIgHd3HdQ3Cx25xk6tBiwqD6A/AFmWAa25hhYuV/9Q5i39EO/6gAa3QxsrSdQ2W5L/wEbELYxeiT/Ryjy/qgaxJL6xC0Z3obOG+arktgx6jqMVxrvHezaVGVJo7nY0k6EqLchGhsDxB1Z3WRHHIbIWmO8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Modify the reboot() syscall handler in kernel/reboot.c to call
liveupdate_reboot() when processing the LINUX_REBOOT_CMD_KEXEC
command.

This ensures that the Live Update Orchestrator is notified just
before the kernel executes the kexec jump. The liveupdate_reboot()
function triggers the final LIVEUPDATE_FREEZE event, allowing
participating subsystems to perform last-minute state saving within
the blackout window, and transitions the LUO state machine to FROZEN.

The call is placed immediately before kernel_kexec() to ensure LUO
finalization happens at the latest possible moment before the kernel
transition.

If liveupdate_reboot() returns an error (indicating a failure during
LUO finalization), the kexec operation is aborted to prevent proceeding
with an inconsistent state.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 kernel/reboot.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/reboot.c b/kernel/reboot.c
index ec087827c85c..bdeb04a773db 100644
--- a/kernel/reboot.c
+++ b/kernel/reboot.c
@@ -13,6 +13,7 @@
 #include <linux/kexec.h>
 #include <linux/kmod.h>
 #include <linux/kmsg_dump.h>
+#include <linux/liveupdate.h>
 #include <linux/reboot.h>
 #include <linux/suspend.h>
 #include <linux/syscalls.h>
@@ -797,6 +798,9 @@ SYSCALL_DEFINE4(reboot, int, magic1, int, magic2, unsigned int, cmd,
 
 #ifdef CONFIG_KEXEC_CORE
 	case LINUX_REBOOT_CMD_KEXEC:
+		ret = liveupdate_reboot();
+		if (ret)
+			break;
 		ret = kernel_kexec();
 		break;
 #endif
-- 
2.51.0.536.g15c5d4f767-goog


