Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F43DCAC5BB
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 01:04:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE0C78E001B; Sun, 28 Sep 2025 21:04:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A68368E0006; Sun, 28 Sep 2025 21:04:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C1668E001B; Sun, 28 Sep 2025 21:04:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 694168E0006
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 21:04:43 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2D61885836
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:43 +0000 (UTC)
X-FDA: 83940492846.23.C47A7EC
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf04.hostedemail.com (Postfix) with ESMTP id 728CC4000D
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 01:04:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eEbv1DeB;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759107881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qo+j6vvSs0kYXvlpvUfoWrks4CXynF5fRGFMBKVd5/I=;
	b=WGc/e7Px3R13t9XxPooy/31nLiX3EFBkDNJXSVXPiESbfeif6ghphU5BAaKXTDR+qGRhMD
	6Jh8AyX8vGgjfd6LR9xuFaKJmhdG3u7tCPOo14jtFL3+LjCPEMUPG6ed+DX4uZG1zLnRr+
	QlimCJFkOCfn8/vtR2b9aetPkb0jbXw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759107881; a=rsa-sha256;
	cv=none;
	b=SFs0ES2PlPJ+51dFTWBtA9pi/wLLyI1DlXlkb2ztZBiREHvpfKYOpH2IrSs3o5VTp1zMGx
	L9G9Amv+5Hxc1gOK45gLahJeD6JTDh9t3hHgFxqhRnm+wpgbIfBI9JCQnipWPUCJekp+on
	5xLBcPqEn93pMlvjvbHrho+ko6aeQ9g=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=eEbv1DeB;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4dffec0f15aso13100091cf.0
        for <linux-mm@kvack.org>; Sun, 28 Sep 2025 18:04:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1759107880; x=1759712680; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Qo+j6vvSs0kYXvlpvUfoWrks4CXynF5fRGFMBKVd5/I=;
        b=eEbv1DeB31qcyzjJNW7vbLJkqFvVh/zXSVOOSFdFYtAyUQM+A1NW+a9jzLNYNwmPk4
         f6uCZix4l6TrbICOlM2D/YJhpkg6sjSDt9Jtoyhgze8RBPM8yJty+AlUI7DLW5NQ21uU
         Ito9EF5FYjuKltBUWWPCdqhx5s7yZ9RRsomeWMjLGLzr9Kfi69ikkcuZyLGg7nfZVZlI
         hXSz9/ZLpA3y4oIg69n+/89pL8xwfLYZ/7FmX5J8MTUAwKrxCGVtgOBtNMEF9UZW5Mso
         pcz0Z9zLImQTl+wn5Avls7/1hM10YTtjmPYcwA1RA3NKItsuFNsKXkM5L9H0CvGYM11h
         uGvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759107880; x=1759712680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qo+j6vvSs0kYXvlpvUfoWrks4CXynF5fRGFMBKVd5/I=;
        b=Xa40WTtLP0p7TbRwzBiP2vFwiU59P0REH4eh/iTdpEQ5VoJN15gdiLxAyuBngtKTry
         g38MO5JuIwW9VAQOBWxB47cxaGHeA8TIrBNi5ti7t68l0kQzxyJyecpwudO1XMqGQbmz
         h0P+/28H5egq3Sl2IZ+09PDGe/oLRXEzL74uoIvF9bwn8nJxDa4YsBZsvJW3Z2AjAh5/
         D/16+hjhNR1zvmfswGNTulhNwadnuXYWSFecvwgHnhECRa/3Qwwj+ai5XYm50Zvo5HCX
         8UlQmcCGOAJuxXn6VXqLCaCEkEgZS9u2IZqspxO4ky/XqHmvdQ+IYOvHxo8wBDhamjRi
         vKwA==
X-Forwarded-Encrypted: i=1; AJvYcCXuabskmgomF8xhskNf+6rpLQVFGRaKoHzgp2R7mAxUN+kIQS/Ah2LDQPlQxPAN0MEYEXKo5YH8fw==@kvack.org
X-Gm-Message-State: AOJu0YytlCuS3e3Bko9W4jd2/4/iNAt769WtafcigkRhK/Y4YTDakM/6
	d+KO1NQlqJIo2L3vYKpFfyopuwDR/hHBLUDfcTCBRT7gQNDIV+qw0Louto4eaGsZMOg=
X-Gm-Gg: ASbGncv+nA0bOCgDeK/21iQtqDA6LDU8aOo1QUukWao/bBdzE7A7j++S64DdqbKO87T
	yArj60ft9P7F1Ze2t+whj5117pdDgBDtoXAqjZwQhE3cI753BZSuICPB04YT/gQ8/aXjE1CTg/b
	oojnrycBtnP+01vDLini/rhpyi8YVH+YjEwSzLtLMv/ImUFBJXXGFCmhSik04PonVZWvNP0FzzU
	C4+Wn1zkqDySxUlGOGRxAPXS75X2sa/XuefdRW6H+SRJ31CJFvaKpX4uVwmsJtM7bKlB6RTsabw
	aQ0G6WfMDdnxB5AAp8VG2GLyQdA3NU1mqwtm+vgb3MTW6+BABAaQI/5pwpJcjG9RUgTtOehgjJv
	u4yXCBmJCNvvWgnQZX99f+Y5X+KbNRe1jq9bdbM9xzsVKFN9r/xJXyPYyX9Q/bnmwaj6+IbK0TY
	lFrxQqKp8=
X-Google-Smtp-Source: AGHT+IFnn/Ai8Ev964hSNdZizcDfUH5OIiSZcW9Lxxs1D7Eu4fY6PuQ8Bl+TY2i03llueVLxiUozLg==
X-Received: by 2002:a05:622a:904:b0:4c3:a0ef:9060 with SMTP id d75a77b69052e-4da49253c74mr204367941cf.26.1759107880566;
        Sun, 28 Sep 2025 18:04:40 -0700 (PDT)
Received: from soleen.c.googlers.com.com (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4db0c0fbe63sm64561521cf.23.2025.09.28.18.04.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 18:04:40 -0700 (PDT)
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
Subject: [PATCH v4 19/30] docs: add luo documentation
Date: Mon, 29 Sep 2025 01:03:10 +0000
Message-ID: <20250929010321.3462457-20-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.536.g15c5d4f767-goog
In-Reply-To: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
References: <20250929010321.3462457-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6k4oqkzpa6m8sgmwzad94kify1wwhrry
X-Rspam-User: 
X-Rspamd-Queue-Id: 728CC4000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1759107881-141158
X-HE-Meta: U2FsdGVkX19bz99WKxsv8elCVinQI6T1+Ea1pziEuoEhGnZ66kBmiVG6C5TZ/rWFHT1QFj9MsRj1GXjMsn3fSi2z3mUNeBrf4iQEpjd+sGndZGuABvVgzAnO+BAKtQXs2staad0OmE2tGqzEV4bjI5BUv1SKmSSFqN5PDJrxFyoRceyHB7YpnVnJyKQ+XEhlUDERzYHVux81B8Rf6UKwS2ubQTXFA4c1/vndiJse37NPrtvMaB2A3HoYEBansfHakB5STgOtsiEGrKdeSo3KrCgbgaapADaT/z70ANumbMr+c5IA1c7TtgJDawInwFOj4MSSe3s9on5qX3U4riaJdjwyTq3ffkEDEupow4K8yB97qeMF/YdjJ8G/En92eDlm/raJXgF2a99XVBS58Xi7mvf10IUDQkwEIv5Xe7Zp2LyJzraWWjk8CaCMQQYnEZU6inofyE9UMdd0SeGp6NhnXKMlu3k021HPpgOAXpcegiLMJ2/r0Txz91ggzaIftz+DfGaUDEslrE7osOq3/5YzPUQcBQXFJYYRv5H3YpO1omqIUU/f2oLITMoYC/69C6IG4ymjZI/eInLczfQpHkHJXZyuLR/9nVlUbg/F2kjYXrhFz28i8J6VehuQK93FSbTIrbYMpod5OcVhmwFx11KoDeI4JHDlcQoLh27hIE7Mxa2im66VKvF2DVjkbmVbz5TrCetBeZxDpoi8mpyf4oa100I0/t1UWtu7fd04+LeknqG5yJwauLH2MiKAFqIURzYQbUgz8DvZ/GksJxv5uNUhnxfwsvdCr8/9ftPrZybnDO+mAegsKaJ/v+xu+YwqcwCF1ymYDtWRl/fA9MC1mw31tvitGunIxQ+0hExXFlMm90tZ8a8DXHUszKv5cDhLG4HeOiZmAEyL2iuqtkTP6enz+Jc0FlybgyqLsJe6m/c5iC2tWWAodiAED0jOPCeKEeAnFSyDfqOERCsNzS/2xnX
 8CMb1bbA
 sXGnjI/obdQmKTDJEGMOFp+kie2iWW9bjriKlFAvMAHhfliggvOmTCY2Cm6WWMu+e+oFWQEkGQ1f9SSSbrMIat7zbFw==
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
 Documentation/core-api/liveupdate.rst      | 57 ++++++++++++++++++++++
 Documentation/userspace-api/index.rst      |  1 +
 Documentation/userspace-api/liveupdate.rst | 25 ++++++++++
 4 files changed, 84 insertions(+)
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
index 000000000000..7c1c3af6f960
--- /dev/null
+++ b/Documentation/core-api/liveupdate.rst
@@ -0,0 +1,57 @@
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
+LUO Subsystems Participation
+============================
+.. kernel-doc:: kernel/liveupdate/luo_subsystems.c
+   :doc: LUO Subsystems support
+
+LUO Sessions
+============
+.. kernel-doc:: kernel/liveupdate/luo_session.c
+   :doc: LUO Sessions
+
+LUO Preserving File Descriptors
+===============================
+.. kernel-doc:: kernel/liveupdate/luo_file.c
+   :doc: LUO file descriptors
+
+Public API
+==========
+.. kernel-doc:: include/linux/liveupdate.h
+
+.. kernel-doc:: kernel/liveupdate/luo_core.c
+   :export:
+
+.. kernel-doc:: kernel/liveupdate/luo_subsystems.c
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
+.. kernel-doc:: kernel/liveupdate/luo_subsystems.c
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
index 0167e59b541e..64b0099ee161 100644
--- a/Documentation/userspace-api/index.rst
+++ b/Documentation/userspace-api/index.rst
@@ -61,6 +61,7 @@ Everything else
    :maxdepth: 1
 
    ELF
+   liveupdate
    netlink/index
    shadow_stack
    sysfs-platform_profile
diff --git a/Documentation/userspace-api/liveupdate.rst b/Documentation/userspace-api/liveupdate.rst
new file mode 100644
index 000000000000..70b5017c0e3c
--- /dev/null
+++ b/Documentation/userspace-api/liveupdate.rst
@@ -0,0 +1,25 @@
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
+LUO selftests ioctl
+===================
+.. kernel-doc:: kernel/liveupdate/luo_selftests.c
+   :doc: LUO Selftests
+
+See Also
+========
+
+- :doc:`Live Update Orchestrator </core-api/liveupdate>`
-- 
2.51.0.536.g15c5d4f767-goog


