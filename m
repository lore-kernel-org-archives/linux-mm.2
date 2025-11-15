Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5C6ECEB2D2
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 23:34:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3ACD8E0024; Sat, 15 Nov 2025 18:34:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D03498E0007; Sat, 15 Nov 2025 18:34:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2F6A8E0024; Sat, 15 Nov 2025 18:34:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9CC8D8E0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 18:34:56 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 611BDC0815
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:56 +0000 (UTC)
X-FDA: 84114448992.11.AD938D2
Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	by imf27.hostedemail.com (Postfix) with ESMTP id BB2C04000E
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OSXUjEXQ;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763249694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fTOw5RLmNkeRdWzsM1mSOCwBuPeRYehGrzOUVePWwho=;
	b=eq/V8JCZDMoZqnfW5LpTe1JrnuCa588RkyB1OMQjPvONZKynGmiAY3IafyCz5RKmqrcfMY
	0Z3hbvMx/70hgNjC6Moh1sVHHcasI8xWRlsvqPF2mGgQwigf/T5Tf0vdDkLLtpSDkbIOON
	hs8KuKzNs3mqriWsjYBffnZmr2VNpQo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763249694; a=rsa-sha256;
	cv=none;
	b=VcrX0oEPmoLwNY79FXWjfEKMPbxB0XM8z159mGsV+FzRcdYW/+Q5AJlASbsminz16gEcCw
	ef8GICmYTUWsm4VfzgCvXx88QwBtIwS6czRxgVCs3ePkORunAWxNek0ulLY7BhS92dXrPP
	NPdLz7ycuRrf9zETjp9MFimPZ/YAeA4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=OSXUjEXQ;
	spf=pass (imf27.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-63fc6115d65so2975010d50.0
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763249694; x=1763854494; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fTOw5RLmNkeRdWzsM1mSOCwBuPeRYehGrzOUVePWwho=;
        b=OSXUjEXQP+ADBmVTtrrwxoKrHun95Q4qwR2FIQeRBd4E+8bdn1TsJaPsjHOqwIgUOC
         cqNpy5rst/k8ujmvP8Qck9wKGo03un7NbFy5OeP6CEnsqNF10FzjEphOFNKBrzFPK768
         Hn5bqDDutPyXxDIMnoJInkINLkag5zJsIa4S+gt9y0a0E+fydoVCtapwIfkQmcffAWbO
         XYo+PWfPwiszg2StD97s/HGNYhy1VB6HcfOZxroPLcDpDw2Uls74ScdW8Pbj/BIKY6W8
         tym/WFdWth+FDeBytBmTHzvic99n8CEy0+6uOefmbDJ2ntttTvuTrPJlSvEeKrnwMD3b
         R0Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763249694; x=1763854494;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fTOw5RLmNkeRdWzsM1mSOCwBuPeRYehGrzOUVePWwho=;
        b=GOlMnmYTphwdFdF5m52O+8ILDWLSOWBwv9y/12aWC59XMBjH9Pkx+ybaxCs5kDdoP6
         6U2mpqaNgnySqjkdT5WHWr1InozFsvQ3nHbslvc7G2fykNPlhQFQJNeL2IHYSWgI7MXD
         AWMZhV1Pr/Sq5pdOLCRjfmGIMvEGTvyWC2ZtJnczmhBCPV4DcTzwN4eyHazgTyIt3uVm
         s8sPun+8p2Ddi+CyqaZOEWWrOUQHLoFOcjo/PxX9+BGS+mVcPteWrRDC9A26aKRqwKwX
         1f/V/fXWCpaCAkbDXj7jU0P12+5/b/GsqVJSrJnIrel002EwNAFORvib0wOk8yK/AOxB
         hD4w==
X-Forwarded-Encrypted: i=1; AJvYcCVrEagu4Rt+pdOLjd5tL3d6mHra8nfOyCyW4Z3T3HsWQ4Pzglk5p1R5pGGda0D+wJi/+R8s9oWilg==@kvack.org
X-Gm-Message-State: AOJu0Yz1Stm8ERzFTCbxWvViziTgTYC77Ma1INQ/Itw01vhZJa03Ykif
	KpY68rAmcWWzlJiEQ+L2aB0NGTaiPcvxiXH5rdWNFMwwg1ZWFQRJ6CBZK6++CpQUV3Y=
X-Gm-Gg: ASbGncswgFUo8yThxd8jECfZVFtnmbRd5+5AsmdBgVUfjRhnG0n8q212blEpAczXig0
	7C9OlncQ+l7zdfn0XOivYhw2zMfe1WLJdgL+uy4ZUCb34Afvdcf3I7Q5dv5nglt4GtghU2Wt2Fa
	R6C0ZBCXn7MuU5LUKZU62V4eG9+PK7YeQ/AcoDd6iqYR1vy+bJLA3UxT0EazsGRII8f/Tfby/li
	siQPBdpLB+/gnW8Of/ufq4/UpYeEWMNnIifaO8TyW8ZDBazCzj8B9TpRtYwt3w13GaTC0kD12jH
	SMvjunqCMKmbKOCxjtEM0/2UA6lsK93jyU32BA69Mrf33R+gMyks5oOAbppQQQpI3lPw/vbIkOd
	rGSxWJ8KLAjM7pUk/WE2Qwuvalu7tl3+LZp029WVJznhTKaXEC33eeYa495L92IK8AxoM9i9qke
	qKmKwB+a9+e8ZW2nM6Bz9McU1o+p7zO185gkzMJqXmnC1hYKiJ2cv5KjpGv6dqKg3sqML4dvMaB
	vbyM3k=
X-Google-Smtp-Source: AGHT+IE86X5p/xDAl3c7gipm+lk2CKoWWGbQ3TowepV0QBeNnwP3lOoccaKcpzs5yPfF3BpHdJYzlA==
X-Received: by 2002:a53:d006:0:b0:641:f5bc:6944 with SMTP id 956f58d0204a3-641f5bc71acmr2800491d50.72.1763249693809;
        Sat, 15 Nov 2025 15:34:53 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7882218774esm28462007b3.57.2025.11.15.15.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 15:34:52 -0800 (PST)
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
Subject: [PATCH v6 16/20] docs: add documentation for memfd preservation via LUO
Date: Sat, 15 Nov 2025 18:34:02 -0500
Message-ID: <20251115233409.768044-17-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115233409.768044-1-pasha.tatashin@soleen.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: BB2C04000E
X-Stat-Signature: 7x9x6zm4kq7pw7j5oax6gcynpmh11bux
X-HE-Tag: 1763249694-417541
X-HE-Meta: U2FsdGVkX18erhqWuE/KXnNV7lFimX5R1YH75zDrzKTZBNqb8oYnc1UPnF+h6Ue3sYjrztMIEZsJldT0r4OpDkBDGYNEEMTzAXlCl6EyJ9BMLjGayf04VBFhf8g4i67fmIRI6VihelORWjU5bD3zb6vnfQZH5qpcFnnMN0+WUfMKaP3I4FQQJcVMw4H9RaBF26xqIPR9N+G16EfuAqnUnG5SXrIuiqowyizYX8MTEEqZFYjJSIAhjF8gf8a1KwkspNO0aasz13qNK9Wa3OAQt/MwT5bYiKLbJu6EGPHeyP39TpJE4h0MP0ZrEimPS15O38XjlldYcrXtBX4hoU812QLas046uMBZX9SUnC6U4btPjKgCTgXeyb5ZL9q6NX7iReKXzI5HsJa6ucCW9ktyA6ttEW/tX4hNjCQzVr7jP0x6r4IIN4LH5x8hB3Y0rU9fARyOgxaNQ/OZSNoJNtXHFmJDGnYPFOtp7uhn7Dy0NuzJ7UPtJMH+jIyR2LaElOBscUGNuSkbgHBK706wGukgIDPTYNuBWu1r/k6zffgJYAPlofuaFeXPBQ4H8zi8aDQHXqBJPLOI26FpT9Buv38IeX3R8SyfZVc3ZcI9FrSRpFCG6XuaISAFFAYY303RO/sy3frq/dCpycn/Nw1Aw515XDqC3yuZjFNLpP3YNaXYlQdciZQS46cPiGUZ2L/FUcbm+jR+F5xDxMkQXcDUB67rzM+2fzFQZv+3zyuJ6ytu9aYo/NO5oq/OppByXw8UXKqDQI7O22mt3GrtbHpfOO9BCglsQIS57NQ6jz5GtF1wtsuImCxhoWO7+gLm6xw/bZMCKyPDVTiZNcBwUWzlCN9TOdtzXLxea2tQ7kp8A8GDXyFJHqoTWi5UaKup5v9UWCt6EfcAfJT0RLMuWVvz5hzTtIn8x78zmauHtZn3X5+6uBAG4dGsYzaIQsx6TimTqYNks8/GAVHsvDLHn26I3Mv
 cylwwZ89
 oW7QtFxuHgDTxLuf7sL+rHvPY46j4Ni23RRGiSsO6anfG+w/0RzhCkKLdNg+QeT9X/+1TQdztOvZz5MhSICGrcJomLXZHbRgg1A9wUUg/rkBYQWSz4rsXAGcSXA==
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
---
 Documentation/core-api/liveupdate.rst   |  7 +++++++
 Documentation/mm/index.rst              |  1 +
 Documentation/mm/memfd_preservation.rst | 23 +++++++++++++++++++++++
 MAINTAINERS                             |  1 +
 4 files changed, 32 insertions(+)
 create mode 100644 Documentation/mm/memfd_preservation.rst

diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
index deacc098d024..384de79a2457 100644
--- a/Documentation/core-api/liveupdate.rst
+++ b/Documentation/core-api/liveupdate.rst
@@ -28,6 +28,13 @@ Live Update Orchestrator ABI
 .. kernel-doc:: include/linux/liveupdate/abi/luo.h
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
index 000000000000..4f09c3921893
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
+.. kernel-doc:: include/linux/liveupdate/abi/memfd.h
+   :doc: DOC: memfd Live Update ABI
+
+.. kernel-doc:: include/linux/liveupdate/abi/memfd.h
+   :internal:
+
+See Also
+========
+
+- :doc:`/core-api/liveupdate`
+- :doc:`/core-api/kho/concepts`
diff --git a/MAINTAINERS b/MAINTAINERS
index ad9fee6dc605..6ffe4425adbf 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14470,6 +14470,7 @@ R:	Pratyush Yadav <pratyush@kernel.org>
 L:	linux-kernel@vger.kernel.org
 S:	Maintained
 F:	Documentation/core-api/liveupdate.rst
+F:	Documentation/mm/memfd_preservation.rst
 F:	Documentation/userspace-api/liveupdate.rst
 F:	include/linux/liveupdate.h
 F:	include/linux/liveupdate/
-- 
2.52.0.rc1.455.g30608eb744-goog


