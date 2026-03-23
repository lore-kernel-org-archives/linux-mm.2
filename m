Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6A51F532C1
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:59:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 292B36B00B5; Mon, 23 Mar 2026 19:59:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 26B676B00B7; Mon, 23 Mar 2026 19:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1329A6B00B8; Mon, 23 Mar 2026 19:59:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E8F596B00B5
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:59:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B37295D089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:10 +0000 (UTC)
X-FDA: 84578996460.16.A85CE18
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id EA890C000D
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:59:08 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RrZcChtZ;
	spf=pass (imf28.hostedemail.com: domain of 3y9PBaQgKCM4x6uD5uw408805y.w86527EH-664Fuw4.8B0@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3y9PBaQgKCM4x6uD5uw408805y.w86527EH-664Fuw4.8B0@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310349;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7enZU/vxLy/6ohUczG3HchuR4oREBV6X1oYMwMHYNIE=;
	b=TM7xGwxokJgDkxVrqr67+6zvIe0JcDqGFNM5iatXNDz+qZK39DzMjTE1uY+lupJ1Uu8HDT
	dMgaaMg2i7Qk8vMbXPg2jMpaO6oUX9FOY2u/P1uJkacFQLOlEBMUYKTtYLv6GOn5u3Yy1v
	FVmlo7xOefNiKufMTNBc+ss8HYFGXQI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RrZcChtZ;
	spf=pass (imf28.hostedemail.com: domain of 3y9PBaQgKCM4x6uD5uw408805y.w86527EH-664Fuw4.8B0@flex--dmatlack.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3y9PBaQgKCM4x6uD5uw408805y.w86527EH-664Fuw4.8B0@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310349; a=rsa-sha256;
	cv=none;
	b=Rb+diCsyYuyAgIS9VXpXGz3OvXwMFccONr6HPB4mflFU+iJHZPUTbi/vvnYNHWKPFhMNIq
	kVzTciDzSQztgRm3eprQDVtYBuEqhx3A7xhbkymkZB9WUETzy+hyR95h8RZLFpHrqX+WJh
	19ArpuPnX6AUkpDI6fi91UkyRBuNyBM=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-35b977ffbcdso744529a91.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310348; x=1774915148; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=7enZU/vxLy/6ohUczG3HchuR4oREBV6X1oYMwMHYNIE=;
        b=RrZcChtZqy8h5F7l3hVbHteOD5ygYQxQX1uafL4O4NMibPlu1ZbI1tRoLgfviZlkGM
         U+QKMXnMvb45zP1JOOO4BPK97ZtjbyEq49iFv5e7/y58LnGW6QQSd6OW5Tcjvp7hm2h8
         HcJBgKa9FC3X4KYvlnSqCsxOkxoPRPyIXHWMppN5upy49hdiji7k6/Z+RYVetAnlfb8c
         5G8FhOFCdhH5nMelSmfo1vCCqLSq3XPSAF1xJMZWmbR7Zc9hjAIsWSFm6xFrNr0Y0P/v
         CMwfi4BLy8YAHHrkDJr1rBOdFX9qvcv9kyVkQQDfYDs1dvct5cp9q0el8Hs+7turFRqq
         GHvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310348; x=1774915148;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7enZU/vxLy/6ohUczG3HchuR4oREBV6X1oYMwMHYNIE=;
        b=PlMHTRdHLkpbAFiVFo0Np6MJ2X/dgNIPKXpXkOOHGpmafA8SjfO4nXIePwdx/tS4U0
         gnkUine8VZZOQb1n7Y7WGYeYyLq8+STSdb4b5CIs5VIQJuOq2Plh9xyXndRze/c07jy5
         kwUCLXhPnkxGWH0XOqTnKC4bnnNB131mBwbxJY7kTYsHXbgD4s59qUxMxbafQf8FWVIj
         6QwxSrllEf08xHEZCQ6YR5A1Mq7qlH9kuvjSNWG5ZpDsT4F4gJGkHm2bpJt9uTD6h5GR
         lTiJLEMsJZOrxXV3h+Pk2IGQ5gKwuDolW1MtI66R+VjU25kzIJ5+88ZI0iAAJBiINd+O
         oPhg==
X-Forwarded-Encrypted: i=1; AJvYcCWrUHs7wKmcMLur/YeVgHE/SUOkSVafi1vyUM+lJcvmp6k3c9U6feKWQLwZx0whuDKwUncHJjCtFQ==@kvack.org
X-Gm-Message-State: AOJu0YxcUEh4db3jRZFvrYX0Vq8JGEFlP6RDx/OP/X9Ceq/yhfdairoJ
	HMN5FTwT7F0PV4a6qknxnE3BARZ4thHRLamfY8A1I9t1WJcZVJlJoFUwoPe4it8XeyABqHhBR3W
	4viSZS9Su5/K/2g==
X-Received: from pgbdo13.prod.google.com ([2002:a05:6a02:e8d:b0:bac:6acd:8182])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:6a15:b0:398:7855:1596 with SMTP id adf61e73a8af0-39bcea6ed94mr12817264637.10.1774310347510;
 Mon, 23 Mar 2026 16:59:07 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:58:09 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-18-dmatlack@google.com>
Subject: [PATCH v3 17/24] vfio: selftests: Add Makefile support for TEST_GEN_PROGS_EXTENDED
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Feng Tang <feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: EA890C000D
X-Stat-Signature: ou8p4c8747necgrcy4anugbg7xkz7r9s
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774310348-259396
X-HE-Meta: U2FsdGVkX1+T7I76skWayjlU277hBR5cAU/J3Z6I0zmdwpKYNysuMKrvfn9KQfQn/fsppgJffe9J17Yebdh/BCC4vvB5I07DZmHPGfYE3RoSK9bJu/LeyhTKah2A4mfaopwjC/zjFvz7mCWxmTLM1rgcUFrnhby5b+yFcN3nAFuTrNnL7QT8ObgUlKbzP7o5LfwoBslwoycq73VQ5+ck+c9d3VwjTrVhR2xlSm7sasfVyQvJJYX15ZX3r3Wj+mfTvo2AnEFuF6GpTI0g5jumbZQzNRhEQN0eNoRmkf9dL4c++HmxSA4G2F0y1S7gpduzmR50IT1HKjzoDge5S36B4PjOcVL6YpJVEvmwdaiFVYWU/OCExDyryNUYKzIitQbVvT66/xP8y/iEXQNC8tbDrUoKlgNTmKxyoP52ESEEyTqeBtP5yTNDxe0XD0DwzLJDA9NvFu6/9DKzeSzZAviQWouCtmX8Cb7IEcV4M3GFB8JvZX29fzMyRx5cDyo5vlSEdb08EBdPOUZAhFawje1gp+bjwMYB5jhy3gNdAvsJZgZAHVuXmHfXescx7XbYPLTm11S4P6KC36blTUb9WPuNVZ0jhNMuTx9N0p1WHGq+PyrTtpYu63NASuGWxT+KEkEkl5e/BgO1S5CBw1chmX0I3rJc8stm7Df9F3euxs4fBlQlkH66rWj4xLydaEFFOPfsgeFDRoob9hbiOmlLOEWtwqCoUMg4lgfHiGJwvLntv29tNiVRbE53YXh+/SO21qG7UVEBk9RsS3aC9q1WAIt5+uArNjlUg3eCqCP1i9gXD8ShIgjokK92pJrQZ8Cy2WtfBvbWWqDx3D59o1LttpcvIIhcjf724/nJbENFHOaSySgdkH0HG5Rg9WPlCPLqPmyd82b98uDYOcTNN3ikfB3AJwLxB/53rz65VCzqJvGWo1UnxbtkK0j80cWg686uTesaW3ilVw+ksehTIrs+Rm5
 MF5WyEGt
 CCx8c0i0gXUIVMMw/C/pESTKhOHCFNZ/GsosM5lS1z0RQOa4US9xRviaT5i5bcsroMey3wWWOHouG4HUva3Lb8hFJR/nEdFzhakEWMEh0PrX2ohhp7rmrCl92pxDvt3s0UuExKZiR7/jYhXKUgI4QLhDc0dvdTCGTzdtursyIkpGzdhEOXYGCDNv1Lf2o7rtn9tRwUQ3sfHEJ2JRnJa4PortnEMYGqQAenodlP9U+6CR96qd0b2ot6abbpA2UZJliw2HqBTxjipMI3umGebGpnLQPJdE1/6XOpVNpGGg9M6g5QkbfxhNoVqv7MFLpO0OvU6qjfiLnXxFhF6UKIB9qcnsfa765lFV1VJh+Ntd5nyomWDahy/txahvqgtBympAIHpClghBJ7xrVnx6xTSkOrLY423X2pc8X86kCQ/kKq7DeiEcqdBJJCbtoTBas1sdvgVW/dtoWp6MeplTSJr8KCeOKq/ejuoFomHbn13Kp1WSuN7NronfX6qejeKiTOb6i2fXzIeO4SqpYOFlAFqyUs6uQGui0+1GF9BJjif5f9JFglQ6Q/Y9nzKFyO8wjx6Jy5D/MDXCNvSKU9noh0GneFWEAunU5helqnABy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add Makefile support for TEST_GEN_PROGS_EXTENDED targets. These tests
are not run by default.

TEST_GEN_PROGS_EXTENDED will be used for Live Update selftests in
subsequent commits. These selftests must be run manually because they
require the user/runner to perform additional actions, such as kexec,
during the test.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 tools/testing/selftests/vfio/Makefile | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/vfio/Makefile b/tools/testing/selftests/vfio/Makefile
index 7f3c94da289d..9d5e390a61b7 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -31,14 +31,17 @@ LDFLAGS += -pthread
 LIBS_O := $(LIBVFIO_O)
 LIBS_O += $(LIBLIVEUPDATE_O)
 
-$(TEST_GEN_PROGS): %: %.o $(LIBS_O)
+$(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): %: %.o $(LIBS_O)
 	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $(TARGET_ARCH) $< $(LIBS_O) $(LDLIBS) -o $@
 
-TEST_GEN_PROGS_O = $(patsubst %, %.o, $(TEST_GEN_PROGS))
-TEST_DEP_FILES := $(patsubst %.o, %.d, $(TEST_GEN_PROGS_O))
+TESTS_O := $(patsubst %, %.o, $(TEST_GEN_PROGS))
+TESTS_O += $(patsubst %, %.o, $(TEST_GEN_PROGS_EXTENDED))
+
+TEST_DEP_FILES := $(patsubst %.o, %.d, $(TESTS_O))
 TEST_DEP_FILES += $(patsubst %.o, %.d, $(LIBS_O))
 -include $(TEST_DEP_FILES)
 
-EXTRA_CLEAN += $(TEST_GEN_PROGS_O) $(TEST_DEP_FILES)
+EXTRA_CLEAN += $(TESTS_O)
+EXTRA_CLEAN += $(TEST_DEP_FILES)
 
 endif
-- 
2.53.0.983.g0bb29b3bc5-goog


