Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F91DC44508
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:16:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3DB16B00F7; Tue, 14 Jul 2026 11:15:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F15026B00F9; Tue, 14 Jul 2026 11:15:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB57F6B00FA; Tue, 14 Jul 2026 11:15:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A8D846B00F7
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:15:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 37DAE160412
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:26 +0000 (UTC)
X-FDA: 84987731052.03.63E5858
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7C4A02001F
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:15:24 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qRcptz92;
	spf=pass (imf03.hostedemail.com: domain of 3i1JWagcKCOIZMTMRWLKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--vipinsh.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3i1JWagcKCOIZMTMRWLKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6euMhf7mogWwsfwAzliK6IQ37N0mgMRUyNxCkXOGnkg=;
	b=p5DLph3mc4zdN5nK95gI48vLdHacozn1iT2TGP9QYKKBiitcGJRC5l7I3GK3vOscn90adU
	d1wT0A1D7rCN2fpKYameMSskAQhdUA2SjyuxBjZXnqMoNjUFylPmH6HmytAJNdIyHQ1SXD
	t6/r8OSR85n847nCk9HWDRHqC7Den+g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=qRcptz92;
	spf=pass (imf03.hostedemail.com: domain of 3i1JWagcKCOIZMTMRWLKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--vipinsh.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3i1JWagcKCOIZMTMRWLKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--vipinsh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042124;
	b=17wWX7QkzOA3yfAraO4k+WOK3BC5JKvxOkL91N7mIi0Guj5j5HqnKiyfX/ip8brYioQ2qX
	pfTcciWlEOpJiOfHER3KGYUkzhIX1qXh5iPHhq5Jdh+d+qYZa6hiIHdZMLVOuy5U5aUCv2
	Zo5Ie1Ztw0iWaosWhFzDsPLGBL49H74=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-8482fd61e83so8628731b3a.1
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:15:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784042123; x=1784646923; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6euMhf7mogWwsfwAzliK6IQ37N0mgMRUyNxCkXOGnkg=;
        b=qRcptz92P118hUcGRs5xnCghzYwsuNbZsBQ+8KL/7wSQ0P1sk5+I62YZIFwCwt9sgM
         pIHzuseRaJtrXHkbegBhJk1BOOn1ejxpRO7NSi2+6kuJ0wN2gcj0914amTfIEbgjZ3pf
         CsHgubmDGvQTRiXpdXvoekWqO0ut4AkAFSsKoZqn5YudcqdyxU9KgA8d1lK30IXCbyGr
         xKDfxmfyCA/pLuk1HIli0jygbWMtwhmt022BeSPJDsZE91+IrIAB3X6e+X7GZChVKKX6
         5Qmd1dH4mcYoyvYRYIPvHtniuNIuu7KNiRlwIeQp880EZdwOUBc5NpksOySfWJjyNykE
         7blw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784042123; x=1784646923;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6euMhf7mogWwsfwAzliK6IQ37N0mgMRUyNxCkXOGnkg=;
        b=QHL49sqALk+wlCX4tcPPqUj/vcaVkjPzmzIl0oTNBga22DeLiLfOKEC2SE5AGkw+WR
         tkgyg+hMCgA3vqahfSAvEBml53aV9awpHZ5BkuwyHM9g5ommoCDCwME+MfFPUWgAgYRW
         h0U/U1GG2z7cLajXFMp/hG73E+1jqnyhJ+EEDZIlycqHmw/bh6OBHxzrSrmoqBBWn/Cv
         comV8l7/x2uJgR05l31UcWj2WKVHalJrkUK3zxvX9RowRB21J/UWYnLLZM6d2WbEO1kw
         0aJ4r1Q2LDGYhO09Kp6eO4bi+gYEVn+Na0sMQlJT4iwsdGZIRzcjarwWve6Qlg1lUY83
         S21w==
X-Forwarded-Encrypted: i=1; AHgh+RqfTg1K1CD9k2E1PpvYfaTX1hiBqu5yW3JxHGdUFrqZ6+EW9jd2dtgxmoxOoUxHYhrUUKw3Qr1F+A==@kvack.org
X-Gm-Message-State: AOJu0Yzqmp8UqVwEXAW9SGsZe8HkN/XpSdt0oNWC1nJaSjtJTaHo8d9J
	KTtAU/4a0/uJ3sPALG07KWYIGgAAqGPcK6BC2qdR+8MM2JDdQN4cyOOLjE5+E8Zcnl3M5j60u/c
	cECKqgEzYmg==
X-Received: from pful22.prod.google.com ([2002:a05:6a00:1416:b0:847:7fb7:7370])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2e87:b0:848:6dd5:f69
 with SMTP id d2e1a72fcca58-84a516062dfmr4085012b3a.42.1784042123043; Tue, 14
 Jul 2026 08:15:23 -0700 (PDT)
Date: Tue, 14 Jul 2026 08:14:58 -0700
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
Mime-Version: 1.0
References: <20260714151505.3466855-1-vipinsh@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <20260714151505.3466855-14-vipinsh@google.com>
Subject: [PATCH v5 13/20] vfio: selftests: Build liveupdate library in VFIO selftests
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rientjes@google.com, rodrigo.vivi@intel.com, 
	rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vipinsh@google.com, 
	vivek.kasireddy@intel.com, witu@nvidia.com, yanjun.zhu@linux.dev, 
	yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: oxjkqb7axz9ojogip8ztt4aiqcpxyycd
X-Rspamd-Queue-Id: 7C4A02001F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784042124-218214
X-HE-Meta: U2FsdGVkX1/2BU5rOOHshpBkmMpqE4hL1Xqmn2ogGk7du1FjETMueHMmJUTIsa7hgbHu7M6Ppr0JwML6C1sBxvLky6qKrLgoHgEjXcXwGGD6ej+8IVrvREwWPxjmuPAvZJ0LK0mIKJRQkHHurJmJc9y52ZSEPZ7TiIx6YGz6QhlBGny3O/KaUK+0ULTNqSxNOtwsdy5h2TehF1AtbVYy+M4ZI/oWRyyXJNnYjmomZhcJnoEAZ+Xu+xWsUcqtmJnvN4c81xv3I+J9an7fw3qqIiMGOjEGOKJxrEhitAZCwosgpqTGrzoKfoTo2BtcDsaT85kUnH6CNaInil1sdMEyu0V4ym5PXqtcg5AROtowvS/3D/a3p5hHEKXmbCDkoISrPk/5U7TiWmKBJHsV0dR3L8g050hf+oScc4NzOJ3ZQyI9JHkSK0QvdVlinF+Kv1Yb56CTrBop9uXALeNu7eetjZFjwq7mD0myCaSsHkyiPogUZnY410pkED5UhpE6AcyOrC44Y9YYGLtsGFnezBIDIhPLUrBUjDeo57i6bZr0df1CTdA1SfUt2Ouif+SM4n1GE0ldvzeSRwewd+hvzLzHmqroom5KM5l9A7tEVALlQTSsaUckbw10Qi5OgBpdMes5ufZaoRRZfVitelZQLqjcLvZSI4fCLgMOeqh+CmjZWG5sQd7aZxG6SsEQ9lEmro3wyBxJ3cGzl8SqTmiBRSVD7g6C+C4Uruo9HV4+/qNCi22/p0dgmwXzc/JrN3c0K5mptgGOuI+i2L1muftWDppkMkjUefR1ljECnlA5HY2rZz9O43eCGjSPABv+GzInsXehOCP8+VFwKtpyP4pTT7tkebDa9b5kqu5nGSxp6CrKga55WcHmJQbEv+k+kzlmLNx6XGvolZtKvfbWhgNqKllz3fdC9xoxtvtGRESFp5XCxm4y7B+ZBn45gby1rN3mwaDKW5jvwkTZ4XV8mY7hgs6
 l3NLJ483
 sVejf3qKXPg0Z/usLzI7sZbZiwaC4jy3scksGSGaYJfuQjAkVTQ1luP1Vw9KwUVw1JhqqxNF/Hgmhf3/s99+z7hoMoQfKjoOFXXrOSp3WA/DJPWTG2f+JP/sOtMDDOv+yRDyd0HQYKZvIJJzpoWezOUXYbSoUcUk97EcTxoacsPCvFM+GE7H6M6Qo7j8tabbHjO5u5DyQgjYzE5OdWwim5qzN5MSwWi1NNXcQI8+8h1uxJjKOhWf4DmqZG/fgDKDzhGKtB/5K8SjNVXzi65o10LUZF5uBfjqKzzPjnKGXZiMKioCzETSUnmrfX5e9UVOh3G3Mi16e5jPjCagN1HXU9lFGZhSePlpD8nncVzQWkn9/DNfN3tEaKTCwiu9AVoQgQuPjmi3uVfaGOYq50cbgF/7LlLo7q3ff4l1xqMqUVCKsmikUmHoA5toQ52TndNsv2Bo6MUxBusT2CbIjIzVS54Gux1hHhWAKI9QBdxCjyEv7HJ9D46vZbd0gyyK731N/gU02AWSD6pgWT9z0ga3Hb96OPh6v9JFIflH5n4xFmkPbMLncqMsQRWc/MrCMahZeVLqvrSX/aO1XC9vWei6dc6g/KA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Import and build liveupdate selftest library in VFIO selftests.

It allows using liveupdate ioctls in VFIO selftests

Co-developed-by: David Matlack <dmatlack@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 tools/testing/selftests/vfio/Makefile | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index e6e8cb52ab03..4c8a30f950c4 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -21,6 +21,7 @@ TEST_FILES += scripts/setup.sh
 
 include ../lib.mk
 include lib/libvfio.mk
+include ../liveupdate/lib/libliveupdate.mk
 
 CFLAGS += -I$(top_srcdir)/tools/include
 CFLAGS += -MD
@@ -31,14 +32,17 @@ LDFLAGS += -pthread
 
 LDLIBS += -luuid
 
-$(TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(LIBVFIO_O)
-	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $< $(LIBVFIO_O) $(LDLIBS) -o $@
+LIBS_O := $(LIBVFIO_O)
+LIBS_O += $(LIBLIVEUPDATE_O)
+
+$(TEST_GEN_PROGS): $(OUTPUT)/%: $(OUTPUT)/%.o $(LIBS_O)
+	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $< $(LIBS_O) $(LDLIBS) -o $@
 
 TEST_GEN_PROGS_O = $(patsubst %, %.o, $(TEST_GEN_PROGS))
 $(TEST_GEN_PROGS_O): $(OUTPUT)/%.o: %.c
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(TARGET_ARCH) -c $< -o $@
 
-TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O) $(LIBVFIO_O))
+TEST_DEP_FILES = $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O) $(LIBS_O))
 -include $(TEST_DEP_FILES)
 
 EXTRA_CLEAN += $(TEST_GEN_PROGS_O) $(TEST_DEP_FILES)
-- 
2.55.0.795.g602f6c329a-goog


