Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B6BDD73E8E
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:26:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23406B00A1; Thu, 29 Jan 2026 16:26:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDB906B00A2; Thu, 29 Jan 2026 16:26:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D85D66B00A3; Thu, 29 Jan 2026 16:26:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C81156B00A1
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:26:03 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A4391B7E4D
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:03 +0000 (UTC)
X-FDA: 84386284206.04.64AAA62
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf01.hostedemail.com (Postfix) with ESMTP id DCF5540005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iS0a9LQ8;
	spf=pass (imf01.hostedemail.com: domain of 3aNB7aQgKCEsqzn6ynpxt11tyr.p1zyv07A-zzx8npx.14t@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3aNB7aQgKCEsqzn6ynpxt11tyr.p1zyv07A-zzx8npx.14t@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721962;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dy0UJfAzqC2Uv0TXXgbyaGP8I7SQ7WbjV2I2sUTFK/o=;
	b=VTXNqRqkJmUZFI2uhSOOtUQ3fMbVB1qisZ4KcZ/N4I5dhvYEmlGkpv8QLeokENtutL0l68
	Tf2seNpYoj7OkmT5/x56KTftlDkpPN00XeEbeJkhk0A7PPQ54LVKOzYdAOvJ4SkkDDvq9s
	ws7H8D2MyoyqZ5uriv7BSFfPWH/a4xA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=iS0a9LQ8;
	spf=pass (imf01.hostedemail.com: domain of 3aNB7aQgKCEsqzn6ynpxt11tyr.p1zyv07A-zzx8npx.14t@flex--dmatlack.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3aNB7aQgKCEsqzn6ynpxt11tyr.p1zyv07A-zzx8npx.14t@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721962; a=rsa-sha256;
	cv=none;
	b=Twq7nnMDtCpNqfEQN6SCso35MSG5f6Wxa+0dUzki8ngJS78shEOpvXYlCX+YUgRjvdzrBB
	fVIKsgfxAlozSYK5xNgl55boqHrluUePehXWzX7w2jo4PreY7YYrRomTcMAdKYR3SQPcO5
	ybhq9ScyZgvwkVhEysixq73p76OYirQ=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a77040ede0so15035665ad.2
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:26:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721961; x=1770326761; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dy0UJfAzqC2Uv0TXXgbyaGP8I7SQ7WbjV2I2sUTFK/o=;
        b=iS0a9LQ8NPaB+OLK0Pxw1U82Lrsug8D0aZX4LdTVuZromjv/bPYkv763aDQt9cPaXm
         AMG26gSE4mJm4vr3x8ipS4/10AXKnL4limIJVrlqlYtVEB+yNgVCP2LYoqt/AeV17tbz
         8Df5npdp7jxD81nrQu8lgHEooUAv1hukjZQDHbgs8UcwpoMAkSn0NuG+EzEKx+VrgfQz
         7njZarvWZmA+MtgE41+0uXzBRMJk5gygytfWXUfeasR1ZxhuOfuygeJq4osluM4d75Pk
         z311vZRMTfGQq6glUl5hEO4ijhSuKuXoJlBe2wKmjPmsIuTQfbtRxqnXWYV88IGyY9rR
         AIqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721961; x=1770326761;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dy0UJfAzqC2Uv0TXXgbyaGP8I7SQ7WbjV2I2sUTFK/o=;
        b=C5kzGRV9sjQebxG8pKtYlPUd+hJNN8ohfnX3KNZvGt617HeY2BMtP8y7zge6gBNAKM
         j4iRQ0itdJKmfTBke1gjQ6x6nfABi2xPnKKiQi+xOz4ERPng46Wdutk+4uiLWw7akNGa
         XWnfDFpSwty8COydesjaZqjNOqC9AOdxoQInB3UFNYTu85OV2i36NB/uGBIC4ioWgzRJ
         mobq+3wg1OZBj/3pGxHA6jTME8zcfoBVqJmQYadaY5GLLpzZWjLL2rvxF6ur9aBBHs2h
         LmHNjgmocSHVvV/eij8xO/G65+LJsSevAZms2zEZvYAY4AvEOpH5a42BPsH/j1pBPeLV
         8AUA==
X-Forwarded-Encrypted: i=1; AJvYcCWKkV3juMYw0pVAVP95aT59i43kNGyCBeSagR5V3nNbM44khkAAqiVk9L5hVhXL4exYB96/PrJYFQ==@kvack.org
X-Gm-Message-State: AOJu0YxffhtE7M2rq06ZgHLj1fTSIIsjETDOZFHyvMU55HkK220aE23N
	hWPuVHc92v26jvanc71H0n+H6DpBjvrd0251it/BEDZLrkcYInhA3y1r5io++NSBdu3DCNDjhSo
	FkY2Csa5HQLOkLw==
X-Received: from plrp10.prod.google.com ([2002:a17:902:b08a:b0:2a0:8ca0:1e55])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:290d:b0:2a0:dabc:1388 with SMTP id d9443c01a7336-2a8d990adfcmr3786725ad.28.1769721960616;
 Thu, 29 Jan 2026 13:26:00 -0800 (PST)
Date: Thu, 29 Jan 2026 21:25:01 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-15-dmatlack@google.com>
Subject: [PATCH v2 14/22] vfio: selftests: Build liveupdate library in VFIO selftests
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	"=?UTF-8?q?Thomas=20Hellstr=C3=B6m?=" <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DCF5540005
X-Stat-Signature: j5r8myse88jymk37e8zg1j84e9nemxkd
X-Rspam-User: 
X-HE-Tag: 1769721961-658201
X-HE-Meta: U2FsdGVkX1+7zEkm42nDGUPvRWNpvhiLYcJQ4shWqL9j85EPExjiC9eTh5rFjU1weWkE7ZywOZqgjiwNwia3i4eYDuZpnlQ36/1ROoYxwnBggVGlqvnqy0oktjAwmiRms6XAWUp+v/LVuiAAKntme3WiC/aTirVdHqZ1oVLLHeKeTEzN9cUvIfOA5LA0ZLMHNApE3pxFN804EIP5MV+sgc40Hale2ElSLv9yqfxWKAM6CSLSYRR5C3yzFGM32SOrY9HwlJn+Vp2p1fUdvthlWWk5CelStEGooVWEXus0YbyQa693ZRDYA0/lt3PJxxxaqB7o/NRSmbi/sWjrW2OpA2FBVyiRTrKrfELjZAzurRyENWrTdCLbUNeAzLSww8TBzcDv74CrXz6rsP8BCQJYdpycU4pp/xbaOjZVjNQK1VPBiv2bNx2bURF3Hkwc0n/aZhEEVdblx4Sl5ZLGi/YvbEy8AF2qbiLu9pinBv/ZsBOc2fq7tQuDoJzTnQ8k0f/VdO0HhAR6Kn+JRvRo//4OAJrwSObHHyTVwKhlrpi2qG52YHpI8yWd8DsUMJCpCgkXP+OgrvT7EIW/HESWj0IrAe/9RW0nCyqxaYgE0pgrJyy2I1pFKJhvO8nCnioB+zeHHnehvvjFVm1oj3V2ZmR3MpdRQ8yIyboM6vfyKVUa+TOV82KO1xVwlJZUeEdrbPc3LmGUcvh2B1KoOtmv3bCVn6YaGZjufbChF7MErhEIlvlWbPQaf0o3QKlYsdCOWYor+okdg9uhcf6nuKf2rHwR+x4YzpGM4vsolsBT6cJ3R1BnZ3Zbqc7jAv3dFdcd7G+qvzfPWD95k2c0WNTFbU8IffRTCfPjE/LJdWMxoCYn3K9efzrWs5DRkf8A35hv3kBcGdeX7447IHO203IxXthWC/y+UntlLyMxpUN1PiXgjGWqkP50YOZ577HLLPEQqmbFkVL0guj5U3dvFnyL4U4
 CM8FIr9/
 GXy62JulvB2FY9mGHPehBuBDs2FW5I25UxVl0e8Ckv/icUfkQzgE824OKjh07GkdlUY8Jz+OCk590aXxJ2oYX9E0pQJR8Jc6TOTbrZxWxJPWQeZfqTNck05Utj3Z8KkYfA40u7WgtNY+1mI1R88F9nZw+jbZdd2aqINZKL2dk2sG/VZYvkBPbwydSMVIODHV8dF43IWr4AiEpkmn7WwsuUdU4qayxdMh85oG+4VWKR+CX1ejjzB7HLM8cMkC/ZfNP6denishHGLg+WHh93c0n4fR8cHQHOs2TatOcG8aPDs/LeiuBGMjBW7P9mwsdhpRajpg2HkhCmPNmoDvX+iaku8XEWDLrzCsWhIzY4YtgzZ/KvZnBJhxw8X9b4gLrUjsTazv+CDXcH8rUQFrWzhyV7qvGNAkwdZACfAw8fkOhYu+gFibJudw1Y5NcOikNkMs4bYJaHqUB4gnB/oneae8Bk+PrhYViuyXY9j45bWR356oz8tcyxRY67aF8NgU1FFXMbiuLSXR3dHFsuvWf4yXjxRAU7GSioE3jT1HqKs+rWDALh5DEev49RfGriA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vipin Sharma <vipinsh@google.com>

Import and build liveupdate selftest library in VFIO selftests.

It allows to use liveupdate ioctls in VFIO selftests

Signed-off-by: Vipin Sharma <vipinsh@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/Makefile | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 3c796ca99a50..1e50998529fd 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -12,6 +12,7 @@ TEST_FILES += scripts/setup.sh
 
 include ../lib.mk
 include lib/libvfio.mk
+include ../liveupdate/lib/libliveupdate.mk
 
 CFLAGS += -I$(top_srcdir)/tools/include
 CFLAGS += -MD
@@ -19,11 +20,15 @@ CFLAGS += $(EXTRA_CFLAGS)
 
 LDFLAGS += -pthread
 
-$(TEST_GEN_PROGS): %: %.o $(LIBVFIO_O)
-	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $< $(LIBVFIO_O) $(LDLIBS) -o $@
+LIBS_O := $(LIBVFIO_O)
+LIBS_O += $(LIBLIVEUPDATE_O)
+
+$(TEST_GEN_PROGS): %: %.o $(LIBS_O)
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $< $(LIBS_O) $(LDLIBS) -o $@
 
 TEST_GEN_PROGS_O = $(patsubst %, %.o, $(TEST_GEN_PROGS))
-TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O) $(LIBVFIO_O))
+TEST_DEP_FILES := $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O))
+TEST_DEP_FILES += $(patsubst %.o, %.d, $(LIBS_O))
 -include $(TEST_DEP_FILES)
 
 EXTRA_CLEAN += $(TEST_GEN_PROGS_O) $(TEST_DEP_FILES)
-- 
2.53.0.rc1.225.gd81095ad13-goog


