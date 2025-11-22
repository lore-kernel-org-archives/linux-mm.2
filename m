Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43671CFD312
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 22:24:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8BEA36B0096; Sat, 22 Nov 2025 17:24:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 870C96B0098; Sat, 22 Nov 2025 17:24:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7157F6B0099; Sat, 22 Nov 2025 17:24:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B9166B0096
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 17:24:29 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2AA391A05EB
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:29 +0000 (UTC)
X-FDA: 84139673058.09.3262D04
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5F53710000E
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:24:27 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NPUrd8DY;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763850267; a=rsa-sha256;
	cv=none;
	b=v/hYzSLp2rVwxfTmwLdQoItQ21yI/apPCaQ7G7pLmpXKyC0tLvzKTXIinJwATULgkAuEXm
	3zAlk2Pgl1CignjwR7C4KikrY2dB6nVkvD9o2ReKN4jys/LcESYsQ7w1HmmJiK4bcqcPyi
	Ggl491fmtMWFwk+tr9x8vlQhZFYe3bE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NPUrd8DY;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf14.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763850267;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8oZaYRe5g0R4lweOQLAK81RG676DLPyUWLh/z30V3oE=;
	b=Ual7XNVKC1FoyrditT91ILUzdH5P4cPuQr3yOlwcXNklhjsu4O6jyJrxSLgaGfAofWr1dJ
	Sgn9SZH8MJQmtHga86v4uopcUhBL6POFZCUf8ue1Q0XFcdPhLtg4JWsp5WX9Yu/rGJ29Mw
	1nLcG+munsaijFtmbjpQAp9N8396Gq0=
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-6420dc2e5feso2470011d50.3
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 14:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763850266; x=1764455066; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8oZaYRe5g0R4lweOQLAK81RG676DLPyUWLh/z30V3oE=;
        b=NPUrd8DYDonmxTA1lwjBR3QVAhelHenOXlwDkK/1PxoT+WOzp0vtzqMrx0qBZ764vH
         OpUZx1kVsSsosBhid4EHqvCJSXEf3grDU8XfxAAZQAzqlb8RZDhXp8/egm3q6rezbVCm
         QPRy/NYA/BJ5uDpixGuBbjBW54AE7Pxedp1zVpg5FoVC3EVtpvTD9pc4TGPr0THCPqTZ
         5eq7+zVciTpL/p0+vTo9RZwwsW/Te+LAZeLIlO0SIhHSuEzg9LFW/k1Z+TEDLXF94CMX
         mNB6jUcHzDV+GT6NnAKppCKsR2sXSVmOtgJbb1dykdgVOjvmbRDHmu9mSUfJy2xCEJkT
         hB2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763850266; x=1764455066;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8oZaYRe5g0R4lweOQLAK81RG676DLPyUWLh/z30V3oE=;
        b=Ao6CvDqS+PVjWGPMTXy+h2kOr0qriTHzXWYKyTA8BFT1KEyFxfeYhFlXs2wZIufifL
         iusFU4r+1eQZIH4ovfWF0/ERLFYTkjkwkF0UZLyus12w5bUMrYjlqBEfHDnjS9eOEsuH
         1CywdXYxqqDhEK6Tx31LOqbCzYRLQaOD9aSPJq1WxX2AMct/qvUPOcfn3CtM3KAWh3op
         IeiEGPZ5v/GiVl0vjL+2HcO05Nd8krtltTaBho6cKrTgvpbcGTdCUODwMPwuYRbQxpdT
         lWa3RgeIZHsoMZKW+Ojrl91W9jB83udWBaBFNQD9PMuQXa5djLG4lHyy8diVzCdAGFcc
         EUgw==
X-Forwarded-Encrypted: i=1; AJvYcCX9m14Lmt2RpZ9P4Qr4FLYVQUfrXP8NREbCYAJmLJCPq0BjqzCr+1dTbhfxQ01LxZuoIbDCL9urwQ==@kvack.org
X-Gm-Message-State: AOJu0YwDZ5uGYY9g2LgV/ZLOsGm1UIwa68NfbAqy3Ld1DgWTDdBrGHxo
	4/LQ3/5Cwrbh+SgVNZ6o1ZqeY40aZo/hs3/8s4f/ioESFbycD7Z3n3gAdQRG4LZjjLw=
X-Gm-Gg: ASbGncsqCeTL3gihkCHcO+npLlkcM0VY9yIgjm7HjSICbhRvUykhKy2oGBO2eRdeQKu
	SymS+38bljSCmRIwGPn/977KcRl5wcDLgGerB7Cp8BwJfKIjVxVu329TmJ35fPkvUWmjarF2/nM
	1Q/q5/DOgE+0azGoZ6aMqMl7fpi8DRET9Q4uWM/he+4gMwhsZhnipuWuHon1UFW3p8p0a8SJepl
	DYe0m7nAQx1zPL8o8rH8H78F9ZTOwAAmMkDt34ojfrY7qG5B+py08NT1NuMMTBHidwfWpQ21gZh
	qgcNkB+MSnMVN7nMx9hLDTkkXg/bfW7RoSxxNOtG0RAhU8CrMzxvZPL3W62UNRu/xsHZDqTRLA+
	PSQd/SkB3JumCcd4cLEMio95wWhs9Cm+eHTE/tvtAOHvbd0hMorgSXyaKcWfvS5yKZMIZq7BLq+
	RL65PvVtOp3agTjVNCwig71opFpXDXNlfzbEi72KrIgbanR07+DgvuA4uC/M/corBcxZW0NFf8d
	wIg0XyUVy41Qsb7Uw==
X-Google-Smtp-Source: AGHT+IFA8xiqyidX6vSHxt0Fa6KY7zq1D81H8XmTPSjBAk/TG7qP+fvxB9otYVm16cp+k+p4xO9fVA==
X-Received: by 2002:a05:690e:118d:b0:63f:b634:4224 with SMTP id 956f58d0204a3-64302a427cemr5083872d50.21.1763850266314;
        Sat, 22 Nov 2025 14:24:26 -0800 (PST)
Received: from soleen.c.googlers.com.com (182.221.85.34.bc.googleusercontent.com. [34.85.221.182])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-78a79779a4esm28858937b3.0.2025.11.22.14.24.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 14:24:25 -0800 (PST)
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
Subject: [PATCH v7 15/22] docs: add documentation for memfd preservation via LUO
Date: Sat, 22 Nov 2025 17:23:42 -0500
Message-ID: <20251122222351.1059049-16-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.52.0.rc2.455.g230fcf2819-goog
In-Reply-To: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 5F53710000E
X-Stat-Signature: 88fzm4sru9th1zt5wohpbg861wqam5je
X-HE-Tag: 1763850267-370343
X-HE-Meta: U2FsdGVkX1/Swz6EpzRAqPaq+Lh2YH7g459RSOfuvLGLikNxRgIiD8JMgtVwHs+/XGc8frj4UJjVZujkXP6KJPa85mG+S3TiJfyvvX+F21TpipkTdHdyDB08HNDWZ/GKtwADqDB3/Tm/jWj390EMO0L8mhrQZ9iuJp14p5pMs4p924yiGINZKoIJyObmretIkOkPiXmIIO3pfe+AluMhus/H0Eim4dhlJwjXcBxFeRlJjGAZuiWhyTBZ0VQVsxeEF+y9Vtl989twpUlpvbifhJO4l1LHl6ihDdIDjBVMJJA5gOYmBsv02Dnldedx0WTmzEX+A7EBj/1+Cn1gGEOVgOL39rxKxRuRzlzdV3T9i3I8Ha07FPt/pPdYg3G/xVl2efK1bW4koDdV5xJhvP7WZPpMa0b3S+E1Z60qRT4W0+rE+eAEkmvJWhC+5mOITFKbiGv5G4g+zFHJIQ7tXBTmzBWOSapsKu41teJTPYgCHywbwuzZtDh5IOCa/eTiJtEVCP5DTx4WhIJ+SbvnSOutO0XePfxhF99YoNRSlw30MoFFrff7c8g1bJtNrCPwmq2HjrKdcNqskEJqNdyuSNxdBevGvYYFy8Gbw4QTiwcLmIub8HryhqKOj/NqYV6gfIVhq3XbYVmKvoqbxXIEnu1Pnkc+WmrP335UvDH+4qTJSh5IvAaDMBTs42P8mjlsKzB7umX3sOvg+rx1ioQ1v3UADBgd7+ZeZqB7ttadqdzLMg3dBMiFh/JDARIFEvk23+5mFFdNUzu1WY3WiPx3iwWMi7HnAJMo9CSQLzoTaDU+1vaiGedBkIdfj/bQhezHtIkkBCwWBHIgIMtqVTlsk/8e2aSP/qZOCp33Q/XjF01KEREzyfmC0Z1RxG8p/w/Hr3L1zmeFYX4beITJNpOn21IZX4lq/bGza6+0hi3JkohC4jTf00ZUWdk1OMbEo9pR5kc+4ogiMQnIPdwAjJ9sB11
 3Sy72jMZ
 COE0HNISnEGnWdNYjNiLWemP6z9gZwM5tag20Lz4hC3oNkcqDfyzQDSeUOImKByMch3yfKPa3cliSZz6ZHo7oyj+LYP95UGPS3CSvqfrqDyS2X5M+8UNPF5Z/m/P06e4aRSp/8IpmZA8pwFaygH12YVvgBbC2gG4Q/dTLUwkVIXDlyL3hZ67/1BsEPP5222BViQWPzh/Py22SrfRXtODlCXHTKYUG9bnp/t+PTXE3PV9MQsgN6tUjs/Zp3C/prLjRvN+yy9wudpvwHeca9GwrCOeupIt19L3oyugwNM0L91hrC0pPlJScZXY/eyJD3kEaCm6n9MrcPaVPoM6a65QSVWsbLvIIJR2YJUkVeUF2qJ0cMcC/8DwSRPGpfGQgamszMuY8mvBriVF1fDrLz4Kt1RdGtQL4KEl48fc+0vkO6opYDs0Ijl6CcQVtFmjjlD2pWUVokSDptSXubEI=
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
index e1f0c13d5b4a..b776b625c60f 100644
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
2.52.0.rc2.455.g230fcf2819-goog


