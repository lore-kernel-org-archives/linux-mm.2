Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10A45CFD313
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 22:24:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 451696B007B; Sat, 22 Nov 2025 17:24:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 402D86B0088; Sat, 22 Nov 2025 17:24:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206F56B0089; Sat, 22 Nov 2025 17:24:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 087306B007B
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:24:18 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id CF8534F44D
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:17 +0000 (UTC)
X-FDA: 84139672554.01.81F2167
Received: from mail-yw1-f172.google.com (mail-yw1-f172.google.com [209.85.128.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0CACF1A0005
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:15 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=F98Kvl4w;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763850256;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xzrSObhj5Wimd1cdYGg31ZDKZ8HgVQz7p6sm5WUy9Y8=;
	b=V6ZtbwpkD/sEKeVjPw/oFHxGcmHCcTUx+ANKgumZ5dSdYlRSR3EBdrYZnZckfjHCiLaWXb
	eVenWgsF4bdyRBQNERzJth01bypvkL3c9jH+3TX7sPWx+OobN9/6VVXeowCi5REk9L8II1
	GZQcPyXjellrVUlR+0g9IHjet8tyPy4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763850256; a=rsa-sha256;
	cv=none;
	b=g58fYGec5a2E8YWdeo+3Db1Dfgru4qHYwOxmhTyi3iq4d6prdgwoL4XgW3PEHbaxLKdbgb
	HG4z1CAIBhDIH0S8dxIg3Tr0GoOyCZz/0FwfUtvVvGdiSl1rowE6g+LNfvu5diDBTVQcGh
	gtHalILmlA+1k+ZGISgAZZqeuEn4anc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=F98Kvl4w;
	spf=pass (imf19.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.172 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-7895017c722so30365757b3.2
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763850255; x=1764455055; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xzrSObhj5Wimd1cdYGg31ZDKZ8HgVQz7p6sm5WUy9Y8=;
        b=F98Kvl4wtgbxUjA+Ma6kvoGEZ5aVVvZ7Pa+t2xvUVRu1EVdQ/gUD6I1JuK0NTjulju
         wGefM8w5cTguXJoHUs+rf9luAleNAx0qpSfy5S9XZrFCdmdhDJt6UTnlYnvjqrobiydF
         OCrHyzW+bG7oBDGo5b5rP51+v74XVv3lMwVvGJpJadYrhBeQ7ff5zRjoFLeWYKkt8lvA
         ZYOV9EoEm+kjyg58DX9AE/72vALP5tuQRNd56v1OfR0Pkkbyh5jZTxEnHFNHL5Xei8hT
         oOfiHxfIpzNQiPesALd+w+bUQZlghFGiEvMuD6HaD4+bqywQBSN8/Oj0EIotLeMvyPj/
         SzXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763850255; x=1764455055;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xzrSObhj5Wimd1cdYGg31ZDKZ8HgVQz7p6sm5WUy9Y8=;
        b=gp87DmgL9U+OxfAfr9h72s7hF3fzTXs/bavpoJ1IlhY7Zg8oOqskPidnsg/1rQW01p
         2dG9+VyfgXYe4OB4IYWyLHQtslJU2TvFvsahX8j7q9Zsny1afr6w/3atRSa5JQ+4bCir
         j9e+fA5HlPAFmu1155SfXMagT8umYTGKv6eBB2gi9Oa5ZIAheqz+vnJLLtigPuAT80oC
         iMJn8yrJwtiuhlkkSUjjX/0Ql6YW29vmAjNvKKGcsy0UGPXGstg8Y605gBC2kh371Yrj
         PTJs7C/q8MJFm8yRX6Q3v5Scqt5qCJg7bBGVJH7B2VHlx3ife+eleE35UrxkjvYm52RJ
         8ddA==
X-Forwarded-Encrypted: i=1; AJvYcCU9JE6Vw2PRzNzF9FLDWFi0y+Nq2oBTve+5jyz7wl996W6jo0ziUC2iHBxeNoxheivcTaC+9vPKyQ==@kvack.org
X-Gm-Message-State: AOJu0Ywj13c5FO42BAaRS8+Zb852skxmlPHJQ0zrX40tjaigiaCdjLJ4
	C13zi/E1hBwECvJnsmIOV7DObSsoWqPxiv3WFhoSXBtzEjPN2uPHIq/iftaL0a7mhPA=
X-Gm-Gg: ASbGncvWTX1GxLucmG7s0Wm/lTn3XOYW8+Vpkrmas5MXhYl1CPXNctJHXOW8irPUyw+
	ea2hlf+3+F3xKMS7xpSe7Mjm43D9X3KmxuXOifxlWsfCDpDVG+9lESRuzl1DN1gfyvynucjF2Qw
	JtN6MjzPgrMfIc7i+OYPyv0H6z3JAE36ZMmVEjbZv70VQCrMSXDtBWwS081M9pJQRMO9dZIVPJF
	fA/xjoPG/pKR49Rm0v9Ly3OvMd+YWeOQNoKz21pS7nhin4TX3jfTfFf2rZqlUyqOYZeWrjwQoRV
	kPPU70U/018cTcLQT0PvuuKjiFheX2vdPsPoBnelR6qv+K3BWSssK/LWWYLfhqfq0Eq5ubWnhBR
	G6Qk9IGyfe91uZJWWKSgve8QIyZaD3FtN5aKK4UcRCBYzcIQz2bEVYkw18WkLNO7vkVVr1I8QdU
	9sDB4kREv32HMpraozEloaiZMMmJXxcYOgv4KU5YDXvrJijbva5tusGMVjvyblZ3BTm7VEPdgEe
	l6+93w=
X-Google-Smtp-Source: AGHT+IHKuSAjgrt1dxDo5oomNcqBOfqdLocHIsya6Qr+JoT/gAP6yZKLlAopzeyv3C1y1/iPUXwmuQ==
X-Received: by 2002:a05:690c:b99:b0:786:4fd5:e5ce with SMTP id 00721157ae682-78a8b541204mr57832467b3.37.1763850255139;
        Sat, 22 Nov 2025 14:24:15 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79779a4esm28858937b3.0.2025.11.22.14.24.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 14:24:14 -0800 (PST)
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
Subject: [PATCH v7 09/22] MAINTAINERS: add liveupdate entry
Date: Sat, 22 Nov 2025 17:23:36 -0500
Message-ID: <20251122222351.1059049-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
In-Reply-To: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0CACF1A0005
X-Stat-Signature: d966sbbnsmzy5ttuiqs5h83ctnx1cemw
X-Rspam-User: 
X-HE-Tag: 1763850255-362821
X-HE-Meta: U2FsdGVkX1/LX+UnfbVIESvl2cxweRgThtwgW2+g6dVwuMCnFdD0D1BSS2wtANPGxSroiqcYVq18wkZq32MT3816cLSFBY/uu5xSHDTWnhYShKvXO8k2kT2p6bU4qXyXr2qggU0xtIc+Gx/P5//a4rkPTa/9HUaEX6ebriQj33UcVh4+YNuC0MVpMvfQnF9TFl50uINnNHMUTO2qYvcZaHZlvtNy7wTzMhzEQ2LIlJqyvk9XGdjH/87lpy1FQ2W/gOLMBvpQD+iFSkPwHJ5hlmA1kh7fyq916YLgs4j0MNkYRwW4cSJ1ap74h/tnzDENV7R3BwJwYtf3JllNwMZ9WzjPthXf2pHLOr61Az1C+JRYJn6oaDhk8Sck0/i2+C7h4U2EpxfmzC3/hO0lH5fV3q4fIrsr5dBaKuJRwEH4MRba3FrPZ6bqfeqyaWW3B73uz/hwckymwnbmfriXjqRk8K/pKemfLj+dk7JsNYHJOkK2hJ8WfFyt5SpJBXnviyJYN5TSu/5gvuyLKfmggbyhUWfOYuf8dLsWm+u5POvcMWzjvCK1FIbT7OyQFKAoSVA+/2eGsFoWDzdpFoA5VdEhka5jKMd9cDGj21pNCid07SB0XRxSsCPZoYQH0X3wd3pucsyMHtWAAmx71kexfauJvHM75vMshCqi/5Cstv3+BUxVxNGqrW5pZlU5oOPSznPMRaDOkkg0oHC/24bz0m//+EmnXI9qohTiUenIKM9GZWjbiIeDjcV1BJY2jbLrqxz720Ui1Hg6Dem+G+Rd/o/QZLwKcPsFR66i31Vd4af2bpDEGzopEV86SUQd8YguBW8ptlUxum+R22IcAu+tAVfV2eIusrkdyD3JcgCEdnWCCzfgeafuTxSdtTmW80du8xaWd8wwe857UJ6FNj/JDYiSBh725R6Yubb6iW4UmNQ6100f4utlaAg5lTbzqNoIMrLY0obdyn/GklsE7Y17Orr
 58UtGly4
 VbLnnses9Gbc3VznCG+9oa9c9+l8EYD2HQShB1+q+wHtExqSC0LXBs+xDIvvslSchlAY2ZcSeEL/p9P6m7xYWqTnTDfa+QkagDffPUvRFqThb1D0FqZIp1obiz6Bw3cmXxOu76Cnq8f3QsOvG1jkDzVmLzqwfpZCM0P/xbyCaP7GAY0vmRfR1/7xzvU1s9wyTaQ4QH8IewF5GSx6QSL/g8BjFXMQ+mQvmygNy3+y116J+S6Gats1oChwXJCMo4h3S6L3f3oy7cjXCtVPTjmJvD8lDkQVSAMxEyjEIydsU1ht9M9f4M6RizbQeyNxvsdpNGvUn57ycf16OmkfKvbx6DChOwCxHf2iIHwYIpc4U+V1TsrvGSFiH1DSNjN/ou1zBQS1e7VFzhrQFfR7M+bnH1GFcROFqcVFobkhziD45r1a4y6M=
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
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index b46425e3b4d3..868d3d23fdea 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14466,6 +14466,18 @@ F:	kernel/module/livepatch.c
 F:	samples/livepatch/
 F:	tools/testing/selftests/livepatch/
 
+LIVE UPDATE
+M:	Pasha Tatashin <pasha.tatashin@soleen.com>
+M:	Mike Rapoport <rppt@kernel.org>
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
2.52.0.rc2.455.g230fcf2819-goog


