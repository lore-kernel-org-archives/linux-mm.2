Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20938CEBF88
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 23:34:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 823108E001E; Sat, 15 Nov 2025 18:34:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D4FE8E0007; Sat, 15 Nov 2025 18:34:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64D8F8E001E; Sat, 15 Nov 2025 18:34:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C34C8E0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 18:34:42 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1BD4E12EE93
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:42 +0000 (UTC)
X-FDA: 84114448404.16.5999A3B
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5253DA0006
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:40 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QDCH6UPz;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763249680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eMpZqjn+eetCXAXNQY+bjgKy9hWait8fsWMBfgLawx8=;
	b=uTeacY+Z7XSQuZsg1i8gGASgGacLwXUHyy8b4HX1huxGd9pyvSTKS5y3RCSicW/uwAVET8
	i6mRVdMlaEN2gA3dMX8fic42admuuRLlh60359nPoJ4mLLd6mzHFJ57JZEK+aqlKcnbD2U
	yP04+5JWKNPc5BmPRUKc84qgKhTA9Yo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QDCH6UPz;
	spf=pass (imf15.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763249680; a=rsa-sha256;
	cv=none;
	b=AqkFHFHEG48elMNVbyxM3DJnwNxbPCcw/91DFXbSkRXbE/o+X2bzvKdiKedOzLq2d5nsLi
	NnDdRpBEoZUvbR+dNtPe/QJr4Px/alq2i4SDnc64/vNoQcC0nC2/JWnuk7Mv58g53X7G1Y
	R1z1dLNhh1twGlNYKabSMiIX277qBPE=
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-7866aca9ff4so31462577b3.3
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:34:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763249679; x=1763854479; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eMpZqjn+eetCXAXNQY+bjgKy9hWait8fsWMBfgLawx8=;
        b=QDCH6UPz59FIGvzfrI0+yByjaPwEhAmF5ftArb6KWEtlg9gO/yYmFUFQxcyv2CObEC
         ddZZEjwBd/3Q4uMSAQWfcTS4URJl55ycGdN8sUCAlhnynWKxi4WM5kWWhivbEH34WB+4
         cIfG4yCGOe9OLmoLB2pJ80dCE7nBE1+/wftAgOT0ik4DUFJwB3KiH/DxqNE+hjJhcTo6
         lp38YbicTtaUs4/m7xxHA5w3Go5bbnD6DhYYV978FjHeqtuhz8qNHL7ZVfb3ubm6PKwl
         OWWNjuWUPPv0693EWTSGT92gSWoSCa5KzNxVC6sWYGuk3mT+t/sb2hjvk2KToFVpO1VO
         l1nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763249679; x=1763854479;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eMpZqjn+eetCXAXNQY+bjgKy9hWait8fsWMBfgLawx8=;
        b=qxQTjr7kfyh9sXdQ9R10plnADRDu4fcwPsccJvksVOADIpqviQ82rCdAgC35DwKXDp
         70C5rOrdIDWj71l4i1BtyAa/ZjqrnFaOr8yOYPhEU/0uZjeG5qyykmpohsAjhXma9Ko3
         ZWZTYK09R9EktyqDmKe5XIqPQSThLko5Mz0lTG/+4wcMH+LvebNSlXd5emUXEZE2/ckA
         ZZ/rQG45b7y0SbNuqb1HDtc6wPTlfh+g2XYJlsFc4GyqEPBdnZ/iu0VU6gWKe4DEVn9d
         CEnK3w3Wzm4Mgc23ane8Ga0d26cQz1b8TClx0POHOSt+xLDDS9lTz5BnkiHmsig81xmO
         mJ1w==
X-Forwarded-Encrypted: i=1; AJvYcCUCXFRtyIFpqjn5QYEBUK0runuYq8fBiB51TYje2r6iWbnsD/3qjV1/l6YUjdC+Tror30c5hr4KVg==@kvack.org
X-Gm-Message-State: AOJu0YzMXjimFMyAI3uaMqS8wGq9UsqcKGE39YLu4jq252x+FiN6g9ZA
	z4kt8I9Wz+Avs2eJZ5TsWBDNYCnDpkwg0K4r0R+vESkjiIen/7496yWxbLrfg35POmw=
X-Gm-Gg: ASbGncvv0SKUxcDRIbCayLkbDSlgPEv67sDWHrjZwfRoAxpFvnIbyFCMHijBGLh+/Xt
	HxiHQ5z9WnCz/z9hTOuYhZH5XmHYinTeM4IYXFePKGoBr4qrTO0CyjDX/DojYpgZ3DZIbVoIIwq
	726BROZYQDnEhMHNvd+Sw8PKUU//lB3QPweUi0Vek0MvfC23i4xSS2jgp4v6C5wE85F+M1hWwNj
	qm3i6+Mn2pPGSzvQuJ2qHn+sE60zlmz/0NYWeybJJZz8Q+qlLtNDRsPoyAxw9qmKIWb+O0DNRjX
	Fk42cLZ/p2eUsAG/KqfWk44p1iEsHMGDvzDkdeam3L2bTMm8kb8wdhyTFyB9IjEqIyHUsCksCg+
	CUdY2z3J0rCUkmGYwA3p/HKwVfJ8dkGEeaR2wV+qXXiE1osB3wZCWSp4KqwRVCzGNpIAZMwp5/z
	Jr8qHEMxIApdz/tvvOmJmhCpR2q0SGhWXySAJcCVdMyZsJTQ23uwUk6crpg4k7hSyxRO3m
X-Google-Smtp-Source: AGHT+IFpvmU4rwVaUle/Xd4qMbKiIN+TYBpeyYU/cujp1isseucHsBaZ4L2SnGIl5nDP3gsBZTrPxA==
X-Received: by 2002:a05:690c:64c4:b0:788:1cde:cabb with SMTP id 00721157ae682-78929e2fd13mr69921557b3.20.1763249679369;
        Sat, 15 Nov 2025 15:34:39 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7882218774esm28462007b3.57.2025.11.15.15.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 15:34:39 -0800 (PST)
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
Subject: [PATCH v6 10/20] MAINTAINERS: add liveupdate entry
Date: Sat, 15 Nov 2025 18:33:56 -0500
Message-ID: <20251115233409.768044-11-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115233409.768044-1-pasha.tatashin@soleen.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5253DA0006
X-Stat-Signature: wn558rukxa37e67hg1s91idfqcdtb5t1
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763249680-706521
X-HE-Meta: U2FsdGVkX1/YWCsPEwT8CT4IOp/WuuxddYK+qPbmpUTUhBs+sBWjYyKDFTQviuHsYb4zbWIrWZmkvZWMFUpmcwDP7U5VsWR1cqmtJWC1YtHwfLcYrMff0NBZQ1mjW++lsJf0GgC1s/KNg/f3JZqzUy6mCgnOBFj4fPJ5TFVo51W8MFJAPkWuLT3BxssTe6OvLv5qincomkUco4Sb8fN6qYvFGmeD2m3u8loMh+0FD1ogRUdh4wuAxuwlhBiGVAhBFsP0lITGtoldocWmHdRwNM+YnNDgBrCs+ywEKpAPIMFUGWkVe/A4DUCOpwDh7dKZn2cFgcyzFBO+eu0Rb4uvsYVVTjX/fRZlmyBMoOikKFLob/6uv4yye1WnlXSxpIXSojOQGz+06T9VMd/n4g/fbrMG+tz0zQ929dNvNLz2jau86pfwUepxOE5w2fv1sqfDhVQKooej7vTSr7FZNdI8v2pjxMKjl9x3mtx7StiLRZPQO2isJZhzd9cxlQAkMnPkF61XpAe0/HtfThxSqy5GxRrBuTgYgUgDn086WDE1K7Z3cBS+S+8nDVR6cx9QHth3fZgJbRJHKE2zZDI8WdElFyj4P3eBJf9W70t1Ax/0ly9lABA7D+Gkqc/bCREN73qzIue2bGgvKXd1jo3BLoZCJSFxlxIyomy5mgAKBE8E1pmWKmgfT3b9g5BKNkCkkJ51smffqYTtKPr680VdlIA3q0sXnFl6P0+sxPVNCQeW2oo5tvAk1ktCUH0vnLdSvdNCjiLlHto0kiQytEOapQPhpoCmMXzeqWYubj3mAzUlxraKYdjQ9OLAQ0P4l//HmPjZQZIawOihMh6m4BcYvXI43w6CTJmON5A0zHLmNRtVGioRQtHewu3URPNHfrp2o8/83TiyOzlpkIl5Nw+cn1oHKKYD6yqvDOptW/Au0SY9ftZByIfGcBitkUJwx+5bb2vv3BgrZywzZP7HKwkvGUr
 MZeh/H2l
 wStzWydSuq3LCD9l26oOhQQ28zgYygU+GBSvG0xwGf2tp9vmIl3OVCKUXo4u3LnBo3NHJo3c1OIFab+83TGTEnvXDSwgxGdhCvTHn2gwCqws4HfDikRfqQ7Qb7mwnpEXbb2c0UuYSC2SAW1Zmu6LEdXDhUqi8Yl94oeJbeqt1Z8bSJrRJ+Y1Kj93LB9p6TGj26GfdrgYjCvrZJq/ii5ZadXi3434ac8aa3+sCHqFWJPIgKz9ONxCCYqt7veB/C4SxL8pkxSyCOGsz/0zwcd+91tngyAKwOFHJvMsX4IVkBAOF1Hr0StZhM0qbGSs721kpMDPLDF5TPBSAQpoaJknlcguVML7OfXKCskcr0p6mNfi2aJshqT+b0ycDBMlLMr04dUnACJ24zAB/NfvkF2cd4DAxyaMr6CUdmFPPiKOqc3WOXuE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a MAINTAINERS file entry for the new Live Update Orchestrator
introduced in previous patches.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 MAINTAINERS | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 500789529359..bc9f5c6f0e80 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14464,6 +14464,17 @@ F:	kernel/module/livepatch.c
 F:	samples/livepatch/
 F:	tools/testing/selftests/livepatch/
 
+LIVE UPDATE
+M:	Pasha Tatashin <pasha.tatashin@soleen.com>
+L:	linux-kernel@vger.kernel.org
+S:	Maintained
+F:	Documentation/core-api/liveupdate.rst
+F:	Documentation/userspace-api/liveupdate.rst
+F:	include/linux/liveupdate.h
+F:	include/linux/liveupdate/
+F:	include/uapi/linux/liveupdate.h
+F:	kernel/liveupdate/
+
 LLC (802.2)
 L:	netdev@vger.kernel.org
 S:	Odd fixes
-- 
2.52.0.rc1.455.g30608eb744-goog


