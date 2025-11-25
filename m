Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B8CFD0EE0D
	for <linux-mm@archiver.kernel.org>; Tue, 25 Nov 2025 16:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 736E26B009E; Tue, 25 Nov 2025 11:59:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BB936B00A0; Tue, 25 Nov 2025 11:59:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 423A46B009F; Tue, 25 Nov 2025 11:59:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 35EAF6B0093
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 11:59:39 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0546B13A753
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:39 +0000 (UTC)
X-FDA: 84149740878.07.A84C408
Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	by imf04.hostedemail.com (Postfix) with ESMTP id 3790540004
	for <linux-mm@kvack.org>; Tue, 25 Nov 2025 16:59:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=js8ZRMUU;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764089977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RKFulOeeZC8khoIo0yKZZlpL1Ef0ob1cKcWS/buX2aU=;
	b=Ha4fa8wNNGlIdpORo8FmyiIFRWxd7aEIgRZKE0DuEeTCEYRy9XlaSb8n4rtRNKOJaSsRjp
	ICeEmYhY7VePgyp93tl1dOf86vAexxSILyDMdmYuwKd0k9m0ROlzzyJwOofbmUEY37WdH4
	GS4eR8B+0p4NZJmEB+6S5pEeEbcOEKk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=js8ZRMUU;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf04.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.51 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764089977; a=rsa-sha256;
	cv=none;
	b=1Qdn/SvUmOjVhPm4o3jZ13g4FM+0hSXloi454WT4sNcFbJQOcO3xkfvezBRPoNAih5bCTP
	ofeFLqKbg31wfJ2UqMX2nt8wPtRicmZ+/Vijr22Y0v1r16LZ9BzvYioHB6GKepHdY06veD
	3ixKyalr5/cy6d4nDyXpcC+CN6PlNoo=
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-6420c08f886so6390033d50.3
        for <linux-mm@kvack.org>; Tue, 25 Nov 2025 08:59:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1764089976; x=1764694776; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RKFulOeeZC8khoIo0yKZZlpL1Ef0ob1cKcWS/buX2aU=;
        b=js8ZRMUUVKWaylCixprOxhLbBQpjDEhkO1SYLxS7vYJM2N7LTwRgFaUFhZkDkX6Ykh
         5JQukIvmDjmGz9COwS2mv0uvqobHgcmixjwxogsVo+uZSS63kVyx0vAatG5zUv4vSno2
         HeDLU1tEwULQsA1Wb87hDEAwjIxSFgSWKpBeHQhBs5P8E+YtfFqoRsnKSMiU+gYKoDeS
         SSco7ae26Rp34FviwonXnxWSdKi5afNR+yAVtrAzw5g1Ygx+RsntGbVtr1hzQCLOtW6x
         Qa9N3lClUFyCrLcK7U/Nd5CnCdWgA4XBE1NP/AFRbw4NIcJyuPUyYvjDlynTIKdqHJDU
         vXUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764089976; x=1764694776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=RKFulOeeZC8khoIo0yKZZlpL1Ef0ob1cKcWS/buX2aU=;
        b=E/PHtmH1B6vdaiRzHRiZ4tPMlYEb9urmY0ZCjqzV7n+WLQtnMB3R5suKRvl1pIyRBc
         hk/SmA6rX5Am2JLPMrQFrU6DIibVF1d8W5dB7k1VvqhsVjd88Qgm5Y9htzg3Zf95pu3p
         dNkHb8HMLwck3m/ZzinzuHonGtTD4Z4cqqpTnVHvlpPlGVXEqeLErxc0rk8Fl8AAA+UX
         eFH4c8ODkFHCAJys1Px5xQTnXx9+IaHT50pTVxOYZ/1m3muwi9644NdMO6IyJC0u7c6R
         oXHvHgXQAZ5jdUd2YzGa5Vwb/mFq6AWJEnVoMlUwe8jVqY4o7tOqsuzhuBxtZfqtFBMm
         roPA==
X-Forwarded-Encrypted: i=1; AJvYcCWBS+cH6Ti2vGdhilmzdDb/TO6wsPm6EgMwgSZgHfpOMgmDpSVZjUqlyXdPbmEX7JRwOK3b5speaw==@kvack.org
X-Gm-Message-State: AOJu0YzA79QeHA1XEixbktG43Zk7tZhYZ5tB1Xr/f6/znky/3amajcZc
	gFAAoCl7R3umJ9D991XuNNUb9bja4kfsVXbliJ9pVacIttOgWU8SWRqFmcjSclntOnk=
X-Gm-Gg: ASbGncv+jFqo6fJireuDrGKhfx4qcD2Xqcl4/IKzwpv1viXkCtBU6lrbyXpIU6i03jA
	eYHlMmH+3W2nsi1jj7lh1CcjZGt1gNYBSVMozQcoBdsz+CZ8aGlop3hUeUe0hqyrZBAANUVv7xZ
	1tPCXtShgANWtZxuxy/cfWq2V8LfNU6QdukVYWe18pE1y5rz9K6xxtKVxUwoL+tp5/65tHvj7dP
	2aF9VLPMCD7gaEsAtHP3xcgepqseD1AxTdca8vwQSEYnfaMge6lLM2GhpoWzfJmdTeRHULQTWyW
	rpP7pAiYp8dEFNdZPaZfj65syfC4DnivVz4ZDWQfYyttaEF6xv45U8lHjRhgMTkOnctiY9pOUel
	tGuuUVPonZFhTMweSbVt+3byAE99ViwlNhRmBbwfC7OSpo0g5LCxmMcrXA66zczPU8laT/fABOx
	weCp4RLAxVKCf5sNlGbI9njDJuazKUthXXmmGN2CNeVD/W/0+9RJuLKahnWPCDyS3ZMVp6c+P46
	Kk=
X-Google-Smtp-Source: AGHT+IFFyrvPeYSGKaZ2gflHxpJKasjuM+nfTPdri6fpn7nF6c9WwHVJYxBbdaTgAkmoqf3bueMENQ==
X-Received: by 2002:a53:d057:0:10b0:63f:a3d8:1b0e with SMTP id 956f58d0204a3-64302a3aa73mr10362858d50.12.1764089976255;
        Tue, 25 Nov 2025 08:59:36 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a798a5518sm57284357b3.14.2025.11.25.08.59.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 08:59:35 -0800 (PST)
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
Subject: [PATCH v8 15/18] docs: add documentation for memfd preservation via LUO
Date: Tue, 25 Nov 2025 11:58:45 -0500
Message-ID: <20251125165850.3389713-16-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
In-Reply-To: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
References: <20251125165850.3389713-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3790540004
X-Rspamd-Server: rspam11
X-Stat-Signature: 3ydxgupgyx5c4pmdywxifndjtc7pr1sw
X-HE-Tag: 1764089977-608049
X-HE-Meta: U2FsdGVkX19u6MjaESxriz9pDJBCfzjGTsf4qnVsmk2vhqJQCmrAitGQjA7io6ljALh0erR8LBBpko+bkfWmEaRvqJwkltPTcN5ebE2QGEmUi3qqYtiVyy5Q1sSihnkD5RabTwAbhQvrJMPOsVKFS4jJvaTYY66iAGAAuIR+wLYsSu0ZXBMNzT3dZHr7kYUxfC/79yLgpiPExoQTVJ8fKNLIz34WmzTwGIpilQD9Ve6VibHvYfbQbPTWxH2Ms8Y/3vplI8YuNCK8yEAr7F7hA5FST7RRh+fYMW/5rM51zLYgYYIPKwJUz4urEjMJJILSPjNasgrBfNcQyRNB5gUOiYRqLxC7Uf4OVaLoDx7KMJ/UbvHz3zivXBlDe+Abmkhb6gzEx+KpF2HXMDMOctLvuNzGtWnAWvvzDNWe4pPXNI3Y41Qlz7y+et5/Wve74jRvhTNSHQ0WDwSrTnteMNjKv2WzonNX87NvyFsey9K3ik70gzTtRCFxNjs+2l0hcl1ZWqA0XiflljQyj0BF632QZtF18IIe7d8n1GgIlDQC7uxIcxSZ0ObxiueGOan6jl49GweXNyDgXJx5q+h97woylUHAsvcLO+fd04NzzKv6Vb+MLjUIBpqw+dyI3sD3nV9m6ewt7AW1uu3KaGqQWxWFZnXxCi1o/SeWFx5g2qdPms00mQjo0r+g9arPIeY8HQwYauU4dAK/FzOiCDiploxWsZz18JTFkRLbC3b8HQ0xC2w05hwc1hBndGvOcMHvaMIih6XlAI2QQ2TZIZt7LYY4+Bnz/s/MfF9KtB3o1/TNSfIKvGbqrob8WfL8rE8J7JzUfGn4Yujpk2LtDRRYzoSXEtSDqiCAPpFS66a0rGzuHktZjNJjcjQ3H4q2Y8jVbI5h+vds2yREDqjPdJrYSwq+PUQHwpzuzgtKQzU/oeNvzpIcSSd9+BurQYylYMPALTx5f/DET5BUKL+e7G+IWfm
 zokSbj8K
 q+0GGAxo9jXf7nVIoDHLNmFAVbVan1Va4cEU1cMJ0Osg9LFpn65Wntqz/v5TkGwrNHZJBg/yGuVWSKIcSwIa4/RmMcxqpBNzB9QWudb7hw1CciPY2ynJRdEGRA3jofXTKZCztjOs+Gu6dctvl9ohBUzLKoFBD9qVd+zZMKNaXpxeBl1SYcihnnL/c1WV4HTDWM6wc3c/iotIdcvo+GR5UrFlrdr+QW+JAcsaKfmRW5lwYttWOJKIAJBe9u71FIfuDXnI6YxZmO8TPYcWTGPXBzj0FlUEWOmP0aP5ZV7iOH1rmALfukcTFxGqoG59kmXJ61ol2l1dP3f23uPC0f8GQ4GGb945cAECcAMvjmPEjaXy0oPx6CVdL3BfQRB/noDdSsvV0hTXJ5FRt8D7yv2mI1IJXT2kLpawgERqX5wmcg6eHcP4sxO2DD982o+NBFntuRHEQW1YRAxBbAeg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pratyush Yadav <ptyadav@amazon.de>

Add the documentation under the "Preserving file descriptors" section of
LUO's documentation.

Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 Documentation/core-api/liveupdate.rst   |  7 +++++++
 Documentation/mm/index.rst              |  1 +
 Documentation/mm/memfd_preservation.rst | 23 +++++++++++++++++++++++
 MAINTAINERS                             |  1 +
 4 files changed, 32 insertions(+)
 create mode 100644 Documentation/mm/memfd_preservation.rst

diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
index cca1993008d8..7960eb15a81f 100644
--- a/Documentation/core-api/liveupdate.rst
+++ b/Documentation/core-api/liveupdate.rst
@@ -23,6 +23,13 @@ Live Update Orchestrator ABI
 .. kernel-doc:: include/linux/kho/abi/luo.h
    :doc: Live Update Orchestrator ABI
 
+The following types of file descriptors can be preserved
+
+.. toctree::
+   :maxdepth: 1
+
+   ../mm/memfd_preservation
+
 Public API
 ==========
 .. kernel-doc:: include/linux/liveupdate.h
diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index ba6a8872849b..7aa2a8886908 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -48,6 +48,7 @@ documentation, or deleted if it has served its purpose.
    hugetlbfs_reserv
    ksm
    memory-model
+   memfd_preservation
    mmu_notifier
    multigen_lru
    numa
diff --git a/Documentation/mm/memfd_preservation.rst b/Documentation/mm/memfd_preservation.rst
new file mode 100644
index 000000000000..66e0fb6d5ef0
--- /dev/null
+++ b/Documentation/mm/memfd_preservation.rst
@@ -0,0 +1,23 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+==========================
+Memfd Preservation via LUO
+==========================
+
+.. kernel-doc:: mm/memfd_luo.c
+   :doc: Memfd Preservation via LUO
+
+Memfd Preservation ABI
+======================
+
+.. kernel-doc:: include/linux/kho/abi/memfd.h
+   :doc: DOC: memfd Live Update ABI
+
+.. kernel-doc:: include/linux/kho/abi/memfd.h
+   :internal:
+
+See Also
+========
+
+- :doc:`/core-api/liveupdate`
+- :doc:`/core-api/kho/concepts`
diff --git a/MAINTAINERS b/MAINTAINERS
index 425c46bba764..cabbf30d50e1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14473,6 +14473,7 @@ R:	Pratyush Yadav <pratyush@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/core-api/liveupdate.rst
+F:	Documentation/mm/memfd_preservation.rst
 F:	Documentation/userspace-api/liveupdate.rst
 F:	include/linux/liveupdate.h
 F:	include/linux/liveupdate/
-- 
2.52.0.460.gd25c4c69ec-goog


