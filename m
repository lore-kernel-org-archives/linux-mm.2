Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C34EEC982DD
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 28BA96B00A7; Fri, 18 Sep 2026 16:07:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 242D76B00A9; Fri, 18 Sep 2026 16:07:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 12BD46B00AA; Fri, 18 Sep 2026 16:07:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA1576B00A7
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:07:07 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4570E807D4
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:07 +0000 (UTC)
X-FDA: 85227966894.01.FA1D1F7
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8CF051C0003
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:05 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aH87O0Fr;
	spf=pass (imf21.hostedemail.com: domain of 36JmtaggKCC8OXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=36JmtaggKCC8OXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762025;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P9IxdwpsNG1RvdTFOh7VCNlg1Z6K9O4n/2FHxAEnlFE=;
	b=Z7713G2OXUz1svlKGt0Vmwga0VvtNP4TsQQxFot9ykKRRpXKAO1l9QRA9sXIvZaApKgBU4
	ik69d7w/TCYRRMRzxLwqNB1iAEy+Gn5awC4rWP9gjMs+eepJG6MdceaUXMkJPrnsfOMGj9
	p5GXtfG0Zd2FjxMC8/7iyn5EpErnNEk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762025;
	b=5rFwQvjPObem5G/QpzAK1YPisyUKrGjf6p4YPLpOUqq2/meM3cmsZXUmZUriWmLfdwZzUU
	3m3ivzKWw96ExDdGLkTafngdnMbJrlZ1kp4opKKbQ1OaUGJMH5o4dl1EWHOD/pmGSk5adY
	Qt2RGWmI9ShtKPg6v5sKi5HT3ylI7U0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=aH87O0Fr;
	spf=pass (imf21.hostedemail.com: domain of 36JmtaggKCC8OXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=36JmtaggKCC8OXLeWLNVRZZRWP.NZXWTYfi-XXVgLNV.ZcR@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-39e3dad7ab3so1600861a91.2
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:07:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789762024; x=1790366824; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P9IxdwpsNG1RvdTFOh7VCNlg1Z6K9O4n/2FHxAEnlFE=;
        b=aH87O0FrIL/+6zEeBbRVZIi2E2lILRG9JdNHK6YPhDjBAg1rUtN/PDUg4SrarxFZDM
         thdp3Noi+ylqqAFpEBZhOf3IajylUpEyhQd91/5qcflzi3Ff9WkHI996UHygR+BRv7oB
         jyvKcHpMEl6aZq+VDhEuTvW1/IpgW339Wc0O+TuHFX4XjP5rs2xg32CPmi8EtdQT+Cg3
         dL48Pd474QOHeoFxafRzT6iBH/a/1HUXYdULmkRQa226SXtZx4Czb+uDLWmf0VN58IsA
         v28IaoMnSdAALmPSyRtWncnYj6CZF3Lj8sSJOyCx4czH3ahYOjNtzRDUyxeXeILzu5jp
         jweA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789762024; x=1790366824;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P9IxdwpsNG1RvdTFOh7VCNlg1Z6K9O4n/2FHxAEnlFE=;
        b=hJCPYs3o+uoUQaC4ugdE7zEjpaENqnHmyJYQ02BIrQUT/704m9fxzf2aCNfNa4FAUL
         YLrYLmV5AALX2xO4SJl113p/NuPA74aai8nNjx0wTs42/5JkyMX3zlTXP2c9tklbrToS
         Jv3Emd+0GxEF2+u6BVkuf/wHO0TCMYgMsnOQe3wtbPYPL3R1cgRKA1G2eFyVmg6jbXVz
         Rzdyy0fhfeXqA4/pyKJtNUrRjK7ENL/leMWxKK/qH1AvDNBYIo4CBlzd1u/HSDcj0RIO
         FLmWabAntheKSbP+b+tOt/fESC1hY940lsafMVgsmJ7ziL3Lequ3WycnQboCQ0cEz1nz
         rEQQ==
X-Forwarded-Encrypted: i=1; AKwUvBz/Pb0tl3xB6xFiiB8k0ZOVNjqMLUl3d1aMveJWU0vgOVwFxS/94oHfYwZ0ghNrRITjBfON96k9SQ==@kvack.org
X-Gm-Message-State: AFuF++nhmlzmNN8u3OAVGHEZPKgBzlSjJ5f+Pi0p+imgjqbikQUUYAWh
	/RHDYO/0yMPOSPw6wQG0EPwx7KryCmMX0m36Uybk0R1JNTLrtl2MLcG6rkSTr8ewZScbSSzYcn8
	5bAiRvORgCOUVxA==
X-Received: from pgbeh14.prod.google.com ([2002:a05:6a02:256e:b0:cc4:b44e:9200])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6083:b0:3dd:64fa:5520 with SMTP id adf61e73a8af0-3dd8c4287dbmr7496380637.9.1789762024286;
 Fri, 18 Sep 2026 13:07:04 -0700 (PDT)
Date: Fri, 18 Sep 2026 20:06:39 +0000
In-Reply-To: <20260918200640.887030-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260918200640.887030-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918200640.887030-14-dmatlack@google.com>
Subject: [PATCH v9 13/13] Documentation: PCI: Add documentation for Live Update
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: r8aif3ggdawbg53isomt5af88fpfsucr
X-Rspamd-Queue-Id: 8CF051C0003
X-HE-Tag: 1789762025-505324
X-HE-Meta: U2FsdGVkX1+pgzuXXH9lzlupOr7EuEnZ9kXUUEuygsCZOXBKGY6J1N/IyTWap1nof8l/3yQQk3qgFUiCElTwtx3KXQMHkfW6n+w4fH8OBbG6O3r0CjO5hq7rvj+Xn4sZ6HRPSgFP3Fcoy16cfa3rt29x4/yZAm+kdLKZZoZo/wn4U/fDxgX+bBSC7RlWStLPFehSzzVIJXUlJWCVq7cnWwofDSCkmvsi2QkymRMJsqFcjXUqlOq6lvRVAYiguH/A1RDgKJWXHKyPkdVcjKhDZiSUD6RVyarqyXpb01KOlViuFe0Xk2rmxSCwBHYhYNRG58PR0He9QnzivNO5nb6mFD7Jk5MM/0bzuCt1YEQpuge3QJnYYjHaR6EkL1tfFqbSyXiIbR3UxkCDZfzKHtxkaSEcXS4PCDMZR77HB872qZLvuWmWmbOrNhzrqFFgyFzqFP3I/pS3k0xCvaktnjUbbAxcESQq3MIPZkkCwwJUtX0007VqXROmeLSG0VDIJgBIN7giDV6LClgMdvau3SAqGToKcXsUCUUWflEnrJhIUNmYbO+TBcGRsVg+8Lgf9a0z8pR9vTkLykas0gYzh7Z4FZFHptYYeW4rCwQ1DxSJ4aboOatpR0T00X5EKxcvdK25rMr71wYMZun8BgbXBCWkMQxLoeBACgOrvPOkL3NjnTpchuWwyu/90Z3v3YCpAw9OlwFZ3rBWOIWonEY0SNgYX6gOMKiiIO9XdGnpk0Jh9gGGjWadkFTlCGeM4x2NgOOmS5CAS4lNBvLf1Klkci/Ns+a6245mz+fm65GoPdUr96anXVj6LYh8R/gYVEG6EBPY1wol3KWaeRck6wJoNr6Q0V6QnAmjKvxhyy9xAU3YzlbpMFgZfGd2LdeV8LKPZR2zsxx6u6n/36C6QkVy5DHQCDIlEV5cLQp1t7SW/YRwozVZM1c/HqM8o0viy1QtX38wTNTLAH0siL/ucgDsr8U
 WzB6KY6U
 pN60Ob5/QXDWoUPtEQ+1EwyeoEd9oRXve7QPjp4Rm2oNeLtMxG+wodD68VrGi/M3+a0tyk1pmbXvL5kKelUSXTOofp/hIZ7qL7WoLeUCLwG0Rx748tEYKDMbVQm5atUH8iNw3NQ9XgY2cshJf6BNSZQ9AURXSZvHfwDboZIur+LwVd1wYtpIJ+ykF1WaFLuH4sGpZkJoADN47N6a9ShqpJ4pHooBfR7R8vMbXrV6UEHxLgqSbxf4EnGJ9yeZ8y00rgll6LVm6UJkJ0gF5jMG72u9ej4z9M/uP+mFLYs6Qa5eWyhpwxe93PTWDowpKCPyat9mQu4f58sg5tO0JkKXd8TkP1Nhh+ZYOSRC/sDH/w5f7xG8DyUtOgExGvW/VZ0BLGPYeQFqtnx6l/kwfhaQa6Gnnq5hOC3BN1S8LlR1JjH+p51R/oW14p/TM4gB0QVteBjV8ORz6YejBCmBLrDN1s2sgV7tU6bVU4q24noau6DLv9xttZqwnS9yZDAfL6HNNc9Ra55rr02YAp/iUsdqvIJYXouxL10XILmmE8VEJ3FBIYK3Ws9R8v/tf6wNmAPFhHBB1z3FqfN0KQcoo0PL5MisOfKFwJ0haWThikmEqPfu/8MwAtg1uIkvKbCjPfEf7OZcxpn3vQNJNke+fW3j3zLaXzKXPbrOafaV6F/NiD+ER2Io=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation files for the PCI subsystem's participation in Live
Update.

These documentation files are generated from the kernel-doc comments in
the PCI Live Update source code. They describe the File-Lifecycle-Bound
(FLB) API, the device tracking API, and the specific policies applied to
preserved devices (such as bus number inheritance and bus mastering
preservation).

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 Documentation/PCI/index.rst           |  1 +
 Documentation/PCI/liveupdate.rst      | 35 +++++++++++++++++++++++++++
 Documentation/core-api/liveupdate.rst |  1 +
 MAINTAINERS                           |  1 +
 4 files changed, 38 insertions(+)
 create mode 100644 Documentation/PCI/liveupdate.rst

diff --git a/Documentation/PCI/index.rst b/Documentation/PCI/index.rst
index 5d720d2a415e..23fb737ac969 100644
--- a/Documentation/PCI/index.rst
+++ b/Documentation/PCI/index.rst
@@ -20,3 +20,4 @@ PCI Bus Subsystem
    controller/index
    boot-interrupts
    tph
+   liveupdate
diff --git a/Documentation/PCI/liveupdate.rst b/Documentation/PCI/liveupdate.rst
new file mode 100644
index 000000000000..96b1d7f5df3a
--- /dev/null
+++ b/Documentation/PCI/liveupdate.rst
@@ -0,0 +1,35 @@
+.. SPDX-License-Identifier: GPL-2.0-or-later
+
+===========================
+PCI Support for Live Update
+===========================
+
+.. kernel-doc:: drivers/pci/liveupdate.c
+   :doc: PCI Live Update
+
+Driver API
+==========
+
+.. kernel-doc:: drivers/pci/liveupdate.c
+   :export:
+
+Internal API
+============
+
+.. kernel-doc:: drivers/pci/liveupdate.c
+   :internal:
+
+Live Update ABI
+===============
+
+.. kernel-doc:: include/linux/kho/abi/pci.h
+   :doc: PCI File-Lifecycle Bound (FLB) Live Update ABI
+
+.. kernel-doc:: include/linux/kho/abi/pci.h
+   :internal:
+
+See Also
+========
+
+ * :doc:`/core-api/liveupdate`
+ * :doc:`/core-api/kho/index`
diff --git a/Documentation/core-api/liveupdate.rst b/Documentation/core-api/liveupdate.rst
index b3c689e633c1..2bce2644eba2 100644
--- a/Documentation/core-api/liveupdate.rst
+++ b/Documentation/core-api/liveupdate.rst
@@ -74,3 +74,4 @@ See Also
 
 - :doc:`Live Update uAPI </userspace-api/liveupdate>`
 - :doc:`/core-api/kho/index`
+- :doc:`PCI </PCI/liveupdate>`
diff --git a/MAINTAINERS b/MAINTAINERS
index 3eacaa98775c..5d1b58271989 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21055,6 +21055,7 @@ L:	kexec@lists.infradead.org
 L:	linux-pci@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
+F:	Documentation/PCI/liveupdate.rst
 F:	drivers/pci/liveupdate.c
 F:	drivers/pci/liveupdate.h
 F:	include/linux/kho/abi/pci.h
-- 
2.55.0.1082.g2b9226bbc0-goog


