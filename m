Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69C9BCEBF86
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 23:34:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B578E8E001C; Sat, 15 Nov 2025 18:34:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE05A8E0007; Sat, 15 Nov 2025 18:34:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95A718E001C; Sat, 15 Nov 2025 18:34:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 734338E0007
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 18:34:40 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 424644DAA3
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:40 +0000 (UTC)
X-FDA: 84114448320.25.AF3B658
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com [209.85.128.180])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7215C4000A
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 23:34:38 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Qjqwjiy7;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763249678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tXGZnSu70DIN08Y0wZgdajU/gnoj90NX2WHdQr/BE9Y=;
	b=Za4PGencgpdgRyG4Eb5ZF8ipBatHQc3JKht0ym+dg4vIhMEIOIQY5yITwEmnyG1BMy4Da5
	ARwhnHTt2K4p0VkM2CscPa4PQP8BpG4YDTnHCmV2mRI/R8fTD5SjSPx2sN6n0JK0L7tTQk
	4T9o9ZJE816oQet6TynhgvHi94QB+6g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763249678; a=rsa-sha256;
	cv=none;
	b=XsYVOzz0h0UV9ZIS+bhJON3cGL+akFQEK9JTuR0jcH/stSy6JJTTYedm1y3sYJYRzwTI5+
	h+qUxHLDH45Hl9b6ZiVuJ6Qe1lKh6o16YAOJ3niGQ4HqPkjw+FEuHQQXgBKTqihNZq0WRx
	zUs3tdDVflzu3py6qA/HSBgk4R9bbqs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Qjqwjiy7;
	spf=pass (imf11.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.128.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-7866375e943so25808957b3.0
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 15:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763249677; x=1763854477; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tXGZnSu70DIN08Y0wZgdajU/gnoj90NX2WHdQr/BE9Y=;
        b=Qjqwjiy7jcqgJUPfChXiFjClH3ImPBXGATy7ZbyIgP1Yf0ois1vve9Bj5qS0gvdFJR
         LV9OvA/Df8Q+q4DUovFNZWbbVe0vDyk31cGzzKdtgC4psNitFnP3NfsCzIriKb5axgKq
         JQggroEpsgV7oGk9I0lTzR2HcsTKqsNNQQaAPjaaz9wbHCfjUDDV1CLODioUizUebRqa
         pPXZ4PV1X1shnsDuHWj0+1OY1BrbAxjpBV8NwQQcFjebfiJOHgEhnIreYBPRlWo18HIe
         cFIUQlsnhNwix8zwpEDtJ2iujuwC1moAhMLkhAw6p8r6b9AwaX2kWqvqQU3kHQTyRij9
         cweQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763249677; x=1763854477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tXGZnSu70DIN08Y0wZgdajU/gnoj90NX2WHdQr/BE9Y=;
        b=qWJqeqB017BQmx5mN4PNBuDhSDohLKD4U3VAfXj3Ovp+UKq5nAfvbML7EhhOQNxLej
         bqQBe0TdrUrfrgmUBic2DYoyykbRJ80ogbVr0vmmWTc7QD/A+s9kgAO7V1G9H9j6OpwK
         Vpvx2h0wfZ0qxuqNGUSku24Wc0961xJArq6/3rWShdBmAtQIiOY8RnwgQhYpQXMzvqti
         UONQ4aNIq35caDmyjERkg+M2jLIY9BAs/dKT56C7Zr1yyA5Oac3XKuPuAiTNFHkh8J9U
         FQIGcn2DVarEjfm3QaU2mpHCYlinFLJ2t1cnehsb3EF8ikERj6WQUcAJ5wR47s0opWzv
         Y4/A==
X-Forwarded-Encrypted: i=1; AJvYcCXkX3ObjsFXJ+YH9h6E7hWbPxN2FfAjJteSjxasG5c5f4+7YBGQeMxkTlYxnH6oH68tS71+Tj/NNg==@kvack.org
X-Gm-Message-State: AOJu0YwSovgJs/zpPQxflPa7QKCc+t4yr2Q1lzN5H6ZJ+mH+hJzdsGVM
	XC40aUB/CcWV+ayNkZRaKiAaVnORmJvlr98lnPuYT9tPdekIVTU7VmYbRLcObzrv9fc=
X-Gm-Gg: ASbGncuQjgGpgCQboKM+H58ekhZjSqnDb35ePW3VkUcUSPZSkXnxDCh3QWBIqcRELw5
	nprrWZO6hicp8MDyE880gfT+R9o+ftrFikCs0ZGkW7q1mIeEWUxjnloWncasEB6GgGdGfF/ku1w
	j1FNZMfoJJOeL7SeXLZz8l4yEoT+VZPqDjLiUB/vG489ADkBXt0D0ljSp9DUrmc8wCz/PXi4R2z
	43ayr/tEMQCtjowzankq0RsUCVMzWUSlu8zfRJqNYc8ziBjniP/adL7wJFJz0jmoV2ABE5FT9lz
	lHCPErZmTU6jGwJb/ZRDyFl9nDrmg2TnEhb+sSE5Ri8MBzRK46kCk4qc2FLkRUArWEWJs9yVCWv
	eAELrwyjHeSXjP4Xvp/12r0LdoHoCqN12UNbZXMttkZHx3C51fhyAjp+LSIH4/4b4/bgU+pYqc7
	LKmnf1v386UiDn9DlDr03vwmhJtb+BY2xm5yfqyLxoSReQdtbNAnTongML4DCsCB4Fp129
X-Google-Smtp-Source: AGHT+IEr4ZSX5F0ShTJnhoCAiRSreIR9tV+TAE+bMcxkAeUYbXHH2oKIfnq7gg9dS89JT0P8DLy0LQ==
X-Received: by 2002:a05:690c:9304:b0:784:8286:fde3 with SMTP id 00721157ae682-78929ee3a37mr62160337b3.42.1763249677538;
        Sat, 15 Nov 2025 15:34:37 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7882218774esm28462007b3.57.2025.11.15.15.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Nov 2025 15:34:37 -0800 (PST)
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
Subject: [PATCH v6 09/20] docs: add luo documentation
Date: Sat, 15 Nov 2025 18:33:55 -0500
Message-ID: <20251115233409.768044-10-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
In-Reply-To: <20251115233409.768044-1-pasha.tatashin@soleen.com>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ugo888w4ye1seo14xc5sp13cafxy7cfa
X-Rspam-User: 
X-Rspamd-Queue-Id: 7215C4000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1763249678-218965
X-HE-Meta: U2FsdGVkX1+YK5wzvkFzfyF6PC5mJeg6OVZr8sfex4b4JIgiY0CuW7w+rcxGxmgG+6RB4Z+wsE7jlzeU6Rp2vhOz7f1u3fsUnggiil6KSsZvztJ/Ela3X6XzQABAzX1TWyiZGDXRaOxnhP3atlkru3SlbNcg1aU/h13jAdeNSK1qbd8780GwWpvyw0ze5fFXlnY5U7rfO2sqOaoyzGH8lSvqZLIIs9nvaWNgC9M8Nj1SksZAfuqxS3VJRF8IosZTeAloig4VWXpxvPYKnNFA5FvLW/PU1GVf1MaQlrUPIid/SU8pQjc4zjsl7iN/HAgSOd3UXxQ09bc4sP1ie2aHEQpU1BJkGWDfc+ZQffuuS+3iKUeIbv3W8MIPhzHoxOlYjmnNLIhh8F8fFCRncUpYzcII7Ibla8xdcJXVSHlDT2g/iQ7qviCmLGwPv+k4DW6UtzTSc/NEs+QquN4h3JO1CHEAXdtdzvA+H9tUzyF+MwsUwguFEEQ81n3GPSWSqf2vB6oC3x4z2FUkNX2VD88ZvHMR00QdzOl57lrxA8X5BtvTBIoVeOYlxI4PFrSy1xDoDR5sdrrZv/6O8aG4GKv0txhglylsttBRxx1Q03NKlHHerWBqM975UO0FENSkVVY2WDhiPTRGsAHQy/EpzvJfFJ4n1QCS3zH9MXogquWh1hJKTYFLtWOSViJ0BWs6UAAQQ3c6VUPRBMqTpB/UFgnxDrjz6nbW2EWLtkn355AZWGZu2zp7BZPJ6ZnD+AJu9QKMOwXmzr6R4qQyTn6QPHAMpjSbrFyf7wvwVn5kqNtwZRgdjUZ/9VZaeBPFaiut2lfGN/QENva6jACMyICQPy+d4jEXJ+VIc4ocS+xWjkI9RgaQ2pYNHAy4FJzG8O94CvDZXsXmGyHmcfEAycJge288rVRk9VLedZOkBJZmDBCaTFm9/6lqxwRMkfFPtYJH2vSwIickEJSrmcYCA+8pM11
 BsZK0RD7
 jVDKmJClNiDmvYwnCaAc5e3MdYa6hZkLhDUdlIshKDzGbqCYSwrIpiobOY0NW3+H27jtiQqxh8KC7UlRkz1ylw4l8tLRszesaZEUnGkOzBNqHcFlPMW5jvEUK9NgJeMTJ3/iws8OGadjWRfZl2nWBIC1kxpku/1kOJXmosyks/gKAvVYrkmlBBhv3nHgczqCoO0DMT3+rV8E5ELY0CioF8NTqG0ZQf1WDPEiwGAkLHf5VtZfvMzFk05Cr3teF5GRlNnAMBdBm3rzcic0RGwnbtrBYPs5sbS69NkaY+QxKqPkhMhXQ10NBhnwEf6HyrxJSySGY1Q2J+XiqU/cTs+G7sKd88mN8uWYkbrJtrVcq01NHqVR4X+P5vW9v7YUMuLfeAs4Wdy6ArxzWgwEkYKH5p3gL4ABCUaD0KrxxiScFR8XbiDSX7CfdFuRp3A==
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
2.52.0.rc1.455.g30608eb744-goog


