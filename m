Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95A63D0EE0F
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:59:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70A4F6B002D; Tue, 25 Nov 2025 11:59:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61DA86B002E; Tue, 25 Nov 2025 11:59:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E7176B002F; Tue, 25 Nov 2025 11:59:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 35C526B002D
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:59:16 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF216583F3
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:15 +0000 (UTC)
X-FDA: 84149739870.30.59453D6
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id EA21414000A
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ep+WJxDy;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764089954;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=04W1U9tqhM0nKxenqkng147mrDWDs9iksZrUOMH/VOs=;
	b=cJcHGnAmJOq+omN/ILfUy4P2N+uQNYnoZK2RM1Chf5DCQ50kihbJxhKA5CLXbRFB6QwNRS
	Nt4RrupOjI60ng1NU0VMqFKMIVGFC0RanCC9B04T/4XBj3I4/3nBIwTpqillR4YjL4IoYJ
	EZ9NlMNLrSdH14sSBbYt6XmnHr753ag=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764089954; a=rsa-sha256;
	cv=none;
	b=P3FNcoqikw+tjbhp3FUi86lst+vQAsRjFTMvD91W+7XzimLMWjsbOdvdYTW8ugGfnbHVy6
	VyjyXWNZYmYxur6/NNkP1zNehgWS978TUlEkEXxvAyAPdhluXyd09DYA2WojYZg82/ryJG
	kBrRkaXzwDUBVeix6pD/7EnIGZQbnC0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Ep+WJxDy;
	spf=pass (imf23.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-786943affbaso41180367b3.0
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:59:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764089953; x=1764694753; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=04W1U9tqhM0nKxenqkng147mrDWDs9iksZrUOMH/VOs=;
        b=Ep+WJxDyZnZMPLtWJgtdXsvjcAMc0sXUYomK6GQDqUFPOr3eD7Nbv99IPh8cY3BQ+1
         9m62l+lWoZftar2nK+QGWjibhmZkMdg6aD3wjbQsy3uRfEBs9v4IsbMAm80hqqn83XcL
         FP3UozKZQR6ZdaXLMYT3pnXp3lvIC+B95d6G98RvEDkafx/2tA8G+Mec6sGDMBgZ8rZ2
         0GetAmL+3SdD7AZ1stQ1Ld01SFB1Cizp/m6EKOqHLjEeC5T6RtaNeI9lKMybT0AL4Tb3
         efrm2gdjvxb31taytY6L0+Rdi/9K85pyy2LX66MmfUT6tjiu2goB2nx7GN+Y1WsFHQAW
         FO2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764089953; x=1764694753;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=04W1U9tqhM0nKxenqkng147mrDWDs9iksZrUOMH/VOs=;
        b=ja6zrw7dk16VX8qsw99mIX41L/4UoUeFX6xzBybUIgoJzeCVWcfPNcLz3K+bRVSXxe
         Il7UBu2DU4qtjo5g8a/zcV9rxYzHjEEwK8NxkcI1nDHSvECIPM/4kA32RFN8p/OKkwH4
         xAMO++pofBnKcEbOeh8cA6/oy++sTHHL4mnbEd1JiYqq8oqiz43DhSMtpl2X1sXqwK+B
         U3K70mmqaia2Hom8ISYzMPrpjQDNRRD8zXTa7lf12f0d20lhbSgPiEp8Yf955eW1hQYI
         EwOA5iS/3VPQLVfUdBUCdU2BKBW0VZnER0OZMmIeYsRSlWijo9hIGQoOdb/QnGNIVqBB
         ellg==
X-Forwarded-Encrypted: i=1; AJvYcCWKYTOqOO4QwbR5Slop12XmJ3GWMbqO+8KKrikarReTGhGAJ5GAjQiP7uUwk+n/JvT8b30zfE7RDQ==@kvack.org
X-Gm-Message-State: AOJu0YxKYZf0lwyiP9iX7KyUQgR3JdHIVDewyOmTNGF9WHl4jlBHhaBz
	aXNRWjcnc7yI4I58/IzNtANuowQRIzuV6p3H/edZUI+oYb5Bz6Bwr6ANsY477DklDKY=
X-Gm-Gg: ASbGncvj+wM6WuUOXGwECt7aDfkQmOHj821t5cbQXy7marab/YdJEyQ2zuFn1x6LKTx
	XGQGZE4vcJBRKyxXOP0ZuYPHiRRG5MBCGUkXLdCQn5L64bHc4KmNs9XH3Dxy4xfHsCvu4sZLZ5c
	HRTolsdCS9P3JHyv8BXks8EhwIGT9N5/8XbixM0Ik4pfgaRPeS17mEYvmiT1i55Qw1l4Hr1azzf
	LYcn2Z9QL8v3DwCK251fT/qebZHt343fcUgIQFE8p4rcLLGGr0O5SfuiK5NXFlTvFC0WQBwJd/S
	/vVNclATmCMmOh5tP6O42YbCIPofCjJLFHf3ZW3Ss/GTKeO96a6hguORjFuiwwwK9kk5H4RqJkZ
	z61MJ3wKCcteuEDUyP617PO+77JcO6rpLo3OJuNGaD8owwIXMsm40U1E+vQVSWUZwwXm7jjJylV
	9lfELGlqpg5fz70EUBD55yEwHS4Mep21XsOb8uxhM5JlOokINeeLgflJRHwMy8sfYn
X-Google-Smtp-Source: AGHT+IG/VheigjnnqLhidQQho4WaPxQMBWl1KDbGTnAN7GCTM0241MCFueP/x+zM5U+5JuAeLMQRDQ==
X-Received: by 2002:a05:690c:84:b0:786:8a95:1e00 with SMTP id 00721157ae682-78ab6dacefamr27675197b3.10.1764089952872;
        Tue, 25 Nov 2025 08:59:12 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a798a5518sm57284357b3.14.2025.11.25.08.59.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 08:59:12 -0800 (PST)
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
Subject: [PATCH v8 08/18] docs: add luo documentation
Date: Tue, 25 Nov 2025 11:58:38 -0500
Message-ID: <20251125165850.3389713-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: wdbzahwutw9ff48x5ahfgbuacdstii9b
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EA21414000A
X-HE-Tag: 1764089953-446188
X-HE-Meta: U2FsdGVkX1++H/76Qw9tpSZak9fL1fxpmaFoV9LsdFrsfF/uFjJtglX7y178h+IpwFTYWvOE6RKEvgCjtm+3S3HvYEln5sAslxuTwd1G2AYSRcOU4rc0yu0FFDYxVhcdzuY2jHo+73cJcG4lV1G4s2GP12HGkYuHO1IIzl0oSwJKUXt5Xr8y0zR+0tXTHnkWyiPS2bls4xyo8ZfNm1ic38LyfLXoA7CTBgWlLPwwLTjqsveL5VZQ7mH6py1ukaROjvEsS6V4NZ+UAUJ75BQI9NFYGPn4jTiH8xAziffX790K3ldJEo1qdlkMLSc4i+IU6PIOmhhhO2RBis9WvKtunJlSpP/JxGRdRZKzhQKGeVZnWMIqOirx1rSv7/wew1LjIYW4voQaVtsLN2O8wfu1jIOECEhROhbM4YZ8z3L8wdh6JjOMZ4cradXBGPBWWKchXSGZZ2ZvMjaOeZ6JDkFpirkBfC+e3vvd8ACyzJGyXuLwIigvHLHdTR9qe8ZWrfTe4tHSi/A8+GVCuMjl5f8yeGkqQmpCNb4HnhHQbJ5oUh07Rmdn+a10jUaVkFaOVcYMHYsQSuXpw2WGUfK7Z2IRcGebw6z/2Q4CCZv6681yfU4W6dHtztSGhagjCTVksqT+buX+EpdiyIrue5EFhVqUgf0ij8Lf4rVh0v3BL9pyjdtFZVvuBIvnjR5r/vyBgTuPgx42KrCOmZVHErAmniBvpzDUu0C26MCdZzzaxE8l9CMTfusqCndptUD/m5xo1RfsxQEUpYh67IAZUBlJlKDZYe3VHK0IjjrPvFmpmgNPCznju9yGVizyc80bs3zmmchkMX32UGQ+kLCixLwgQVwSgXGSrJ/eddNDmfzsvez0euitPsul6dFnsnNdnEitH2TC22Mgx9AaJQtsGIsd3Kpr4x+p1GbQw5jvxKOycuGq2+eEJpbk7xJJ75wAbsrzzMGfkuka4738yyBQX+QuXjT
 rzjZqcMN
 ThZ8dvwT8mV8moPBLdxv07WZkfF8A3K1iX2IS2PovwPQV3sT37vabZeXUXMnlVmJ2yE/ZaLuadFw9dvTcL7NKES+Aj+JWDqswnedkzq4HYa5Dm6DvuenIcLQgTSLuxtkAx32DSBgAwhmAiQotR/OWQ6DlxSn4f9MEr+s4q/MzsdDNqM6W/UK/YQBcRLqnRJMjlLGrhlBVxLiow07O7cHwuGW2EePbPXMSAULy4zW5Zs3MNZkdeLq18ke+DpB1hapKjbLnVlcFJx0TMRmreeeoTzhguIbiOCMhjQ4LwOd7yxafDoMoVhLQaU6rHoJIMumqwcp0hYBxzHZkODkdSBhM7qKkt07JfavuBY8gv53f8PLm7W6Nt2+QUsgtja0hkigdtjkev0LXkTR6o/xOS/oPdPxrG0bgcDdqx3IT3FSpzWUpN+Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the documentation files for the Live Update Orchestrator

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
---
 Documentation/core-api/index.rst           |  1 +
 Documentation/core-api/liveupdate.rst      | 54 ++++++++++++++++++++++
 Documentation/userspace-api/index.rst      |  1 +
 Documentation/userspace-api/liveupdate.rst | 20 ++++++++
 4 files changed, 76 insertions(+)
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
index 000000000000..cca1993008d8
--- /dev/null
+++ b/Documentation/core-api/liveupdate.rst
@@ -0,0 +1,54 @@
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
+Live Update Orchestrator ABI
+============================
+.. kernel-doc:: include/linux/kho/abi/luo.h
+   :doc: Live Update Orchestrator ABI
+
+Public API
+==========
+.. kernel-doc:: include/linux/liveupdate.h
+
+.. kernel-doc:: include/linux/kho/abi/luo.h
+   :functions:
+
+.. kernel-doc:: kernel/liveupdate/luo_core.c
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
index 000000000000..41c0473e4f16
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
+.. kernel-doc:: kernel/liveupdate/luo_core.c
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
2.52.0.460.gd25c4c69ec-goog


