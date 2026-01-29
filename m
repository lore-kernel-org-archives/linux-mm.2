Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB129D73E87
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 21:26:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 199BE6B00A2; Thu, 29 Jan 2026 16:26:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 150326B00A3; Thu, 29 Jan 2026 16:26:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7686B00A4; Thu, 29 Jan 2026 16:26:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DC6206B00A2
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 16:26:05 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AAD21160144
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:05 +0000 (UTC)
X-FDA: 84386284290.07.272D38C
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9F92640004
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 21:26:03 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="iN3EQ/hk";
	spf=pass (imf07.hostedemail.com: domain of 3atB7aQgKCE0s1p80przv33v0t.r310x29C-11zAprz.36v@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3atB7aQgKCE0s1p80przv33v0t.r310x29C-11zAprz.36v@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769721963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BqEhbyqURPyKNgE6Ne2XGuBboHLh1jY5l9yG8cIgxTg=;
	b=BsMo6UuduzfHi7gqaBm5B2hF6FQlf9swQF39OB0G6DEAPOTb2l+YtPMwFwXHGBlrpRrd/t
	P2HXmcyvoBaPM42tofjVYFn1Gw3UsSLdGhqKhLjHt2hSAlzE1EEiydH1Z7ygbQ1EQazR1C
	/QUsP9yBrxFRDDHX4/VsHxtk3AbkGSs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="iN3EQ/hk";
	spf=pass (imf07.hostedemail.com: domain of 3atB7aQgKCE0s1p80przv33v0t.r310x29C-11zAprz.36v@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3atB7aQgKCE0s1p80przv33v0t.r310x29C-11zAprz.36v@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769721963; a=rsa-sha256;
	cv=none;
	b=BTtfkqhXfYKdfzT0XhVK67FtSHVYouohlcIv+BGBNtG55jgPYaTpDfmW0bjifCqTVvgnG1
	40JNoKy+Ci4KNL974SL4QNQ/NdAWvJP6CyCWCt9KukuZOlyBdRSUIAuq5XY2/jArCw5P+g
	9opgv3tIAsXb+1p5eFh/7st9estvmoI=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2a377e15716so35010325ad.3
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 13:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769721962; x=1770326762; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=BqEhbyqURPyKNgE6Ne2XGuBboHLh1jY5l9yG8cIgxTg=;
        b=iN3EQ/hkQcIupWAoVoBUNu4RnZmvpaQ0a5E/SXIqRx4dneoVA8hFO8fh6cA2QaDiuC
         obnxJA4Qm7MJA7y4HrID8x4uImi6mCnIGGuEv5A6Ew98zEcxXEMR5828XKRxS4MEfkzJ
         fnmqbDNuDuuM1+hBfc+pkSRasyu6/IGsSsCyNUTxfoMRdhT1cA02JlJ9Ghed5pyop9ti
         1d4mdraanHkdt+dzcoa9holHLTGZNN7Ipiv2IAzGdfyx2aXxeWjDMzKddV2lI0hVuvC0
         WHRAr73hy/2MahIgSB64x+HrOBd1unG3ZPlhFdo1BRqGZ9rSKKjV5qp9TRc7aivIwd5o
         V7Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769721962; x=1770326762;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BqEhbyqURPyKNgE6Ne2XGuBboHLh1jY5l9yG8cIgxTg=;
        b=Zop0Dh2xgwhYztBzuG0dvgoHBFotUHyC3Y2ATXV37LpwblkWUD5/A5ZEmTm3xAJEwX
         SEc/yyJ2s76TecKqdNw2w4wEMY6Q/W2a0R89ERHK70MCkHpqTp0JYndq/T6EPHN5zCQo
         Y9GYiHPlHfkkbFxQJ8Ao8OK+fN0JB47mx3Go54ueSfB225Exwsn7m1bibL43dBTbpBHH
         6T4iNRv233R9hGuFQW5Jy7ZyYIh52UerV79iAPmekEPi3iLxJNK5n1GAtCZK/1T1mtep
         3dhlqLDk7Rd9Ct0it5n9B74a2RY+XigOIsc4LX2ywZwSKOvkU+DDAO1tSODwiGzbOAbh
         OujQ==
X-Forwarded-Encrypted: i=1; AJvYcCVW2TurFZlKuf5ftYDnEbE4zNaKGHbEd/ZQTcsH4Oid3b9HKJn9pchFTouX4xE0z1TYlzm4uie+hQ==@kvack.org
X-Gm-Message-State: AOJu0Yyc2g0iX6y5HjLKy/aYefXjm9ufl1J2CwDlJt4Nixgv8cw5BFMe
	/ok4zLTs4G1boFQ9aKsme8tDzJNYz5xwlb8E3aljmAzH+H2B7la/Zwh+ytjSB8kuUyM1/fXWE60
	ckix/dkE6JjQ4Ow==
X-Received: from plot3.prod.google.com ([2002:a17:902:8c83:b0:2a7:78b9:f962])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:bd03:b0:2a7:a9b8:ebb0 with SMTP id d9443c01a7336-2a8d96a7ff3mr3875585ad.19.1769721962280;
 Thu, 29 Jan 2026 13:26:02 -0800 (PST)
Date: Thu, 29 Jan 2026 21:25:02 +0000
In-Reply-To: <20260129212510.967611-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260129212510.967611-16-dmatlack@google.com>
Subject: [PATCH v2 15/22] vfio: selftests: Add Makefile support for TEST_GEN_PROGS_EXTENDED
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
X-Rspamd-Server: rspam12
X-Stat-Signature: beargxu9jc5f5q14dokd4qpwkwuys9x8
X-Rspamd-Queue-Id: 9F92640004
X-Rspam-User: 
X-HE-Tag: 1769721963-14465
X-HE-Meta: U2FsdGVkX1949FUUo/PlNsFDfrbE+rjPuLibHzKB6StvJVDg5FwBKIa/rSEyKyanJUjgNkzOafPZwdoOwJJewD9TFQ5ELW7HZYaNDRAF/N2sXEHNIgAeSnR/KqsExNjDO6uML/SMpUWcFhftuj68uBeWCa7FxVvB+7Lbfc/jo/1Pbc0hI1KIVSJ9XMHMUM1KN+R8eUcJ4pZ4ze13JyPMAwRwHaCNshMpK6YowXM7Q3eQk5HLd9P0782ciMQZGhREeyBHBbGavvSTt9wZZK+YkehMRDbdyUjByXR9dk4LH8jVuisk3ZfuOOIanSlxcQPv31G+0TqU/742uT5bq/dfw4lnkkTByaBLU7EvQyDOv8t4OitFcHkI2iWQ7OivKlhEnmxeMP4LVBZHAnrZLyO/VfDMt6njkL2fwgHD4IjKI2alFkwyAA/W2VYv7Xxx0pA+MhQAHgOwKtcZ2c6Opa1YLgdKN5psWHIhYTQjQD6B3kDBobTEnHyU8PsCbWW3MIWfHtzpxr0arUkiGcLpIjEIsuR8sD4Qnb+jk2SBYP4+I9jz7uYoXs3a/2E9dHhENtl+uEgnzfA0ZYqOVCN7PWkOugjhcq+uzBx6douGO831+XUHWNQ0kfOtbZa60o1TjjPLjBE2cm3KynBKqlPd2XODdpA6sIzkuVwPWWXTyZybkgEOnZS5bKfvGk6lo0Yi3Qklgev82DAX5lOIV+NE/3sAJodtxlTClsGsbAtJkf6x0ec7t+9F6M0WuEQlZms1R429YBLvBVxbFWxYyStMMcS8uGUBmaQeBK7RHrv8kNepwfCo9SnlnVodATGKtwlMzXwjIvxXBlsM85o8MsGWG8/0nUqMJ5rGhAFVLZKmsD8FWQrShZ6yYMD+HTKB48yFc/eDIHwcuD0XCSr1VLQq3IZcThoeNmjpqyCgiKU8AIJhmlXyl3PwkMUWBFtutjkPwDkzHHnkDyPH/NqdMzsIp9K
 n2/PJe5s
 RHzzMb1A/W8+RQovRSlHFlVMSwoBVd8GNsUCm8bADsfCZXdVa78ljfpKQf8hPa0xhpr0dYw1nUqD4TH0/tSVoGmtDZAwMsh+BcxcuNDc8BS6Xj0QNL2EHDYQKEZ/PDf++C7wIKVZWY0P48jwjV4UKyO21VIfbT0nyKNzA6C0mg2IqwKzllveWhRKzCaSZJ7YCebXpMHxwvXQPyfnXFxl7LdA1OO2Fkee1Vx3Ufv4GWbLVkOAUpemaPVj8CoyzyTL55ADmOfOD2Iy8z9oNr7vEIQgG9yPHPmrY1Yiy3YafOH8W35C3PlomEqJb+qWYvsIMw/EiLtbtG95mzFbdx6MIbgg3edTdoo63p+iH6X0cdtcdpkCV7wm6QHhGGFkpiMLiJcGqQ93inIvDi5+d96vLzrvbgtO/Q/LIbKTj8QyEYi5wMWzZlIhsD/IgGVAhPRdes9UdS/cRfevxN+KHZhtLkIfSwMEQkUiP4e1gh5YuABWpkyIAoyf6NJ5pknuVmUsvDdsW+YwaW0/k1H7U/LtOjJLORLKLhaVi2HmkTMnj5v0fpCnJvkXbMaYYDFTtJagjYTeWVrh6rJmJ6Ki9pQDpcnASNK+jCYVww4K/1+cw9Z+Kj84=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
index 1e50998529fd..f9c040094d4a 100644
--- a/tools/testing/selftests/vfio/Makefile
+++ b/tools/testing/selftests/vfio/Makefile
@@ -23,12 +23,15 @@ LDFLAGS += -pthread
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
-- 
2.53.0.rc1.225.gd81095ad13-goog


