Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48570606A6E2
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 22:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=KBpuW8hY
Received: by kanga.kvack.org (Postfix)
	id 597F96B061A; Wed, 18 Nov 2026 17:37:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5213C6B061B; Wed, 18 Nov 2026 17:37:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 410DD6B061C; Wed, 18 Nov 2026 17:37:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E368D6B061A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:37:28 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 786D41C4327
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:37:28 +0000 (UTC)
X-FDA: 85449702576.08.91C260A
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	by imf29.hostedemail.com (Postfix) with ESMTP id B5AE8120008
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:37:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=KBpuW8hY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3pSj-aggKCE4t2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com designates 209.85.160.70 as permitted sender) smtp.mailfrom=3pSj-aggKCE4t2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795041446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vtujdpaU40al4T5ZdD8VivFKSuVoB9aJ5CGlvJ4l578=;
	b=OG9RHOhFKbZILNEFiEz4FKkJMFFcggzpmpUSBSyM3bc0sptGGLLSpO6nETq/mFJTV00nMP
	L8H5O4wDhJfD2x1ILmhi73y2Sn1UsahXwTqlF686vQNRM/0cHSuJmgj/OTirjzHJdN/pyV
	BLFNlmBYtIguaJ2+NYdxMG474nooY/Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=KBpuW8hY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf29.hostedemail.com: domain of 3pSj-aggKCE4t2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com designates 209.85.160.70 as permitted sender) smtp.mailfrom=3pSj-aggKCE4t2q91qs0w44w1u.s421y3AD-220Bqs0.47w@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795041446;
	b=hm/OfPznDLW572lUT0HV1+iz1EFRZw/9YqQsXWZNHH3Yafs0GB79RBUnjZkNZwfDbwyvqR
	D1mt82fPbe9WFWjlfRVBpOQcgVjFvjWFw6/Nx6WXW4aDVKFddyDPVpbt1MOxfSEp9wTM05
	erwWYwPmqtq7ux7b9Gpl0rwCKLPFBzY=
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-47d75bcf3ebso1474033fac.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795041446; x=1795646246; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vtujdpaU40al4T5ZdD8VivFKSuVoB9aJ5CGlvJ4l578=;
        b=KBpuW8hY8+OPY+lQjMf8YwUCBbSd4KlmCEXb455xgE0sWAbSshIOceopuqimemQoiD
         Tk9l9sX5b7tSmWxLuJzoLGR3dVIch685zZicuGofbzSzOcHMhqkGGN03QqZlCFwX4wcs
         IHV7lzhWSkUGKTGaQ3eaUbOQGtW74rRVm3hvCPV9wji4qnZ5fXKz8SWJryLa3ouNq/Vi
         w6SlQnsC9AT6FhuAzRHuXownXmDqZwg+f5EHp0uexFv1P6tE3hvwq0vvwGW4ra3eDPcM
         WcCpII0j2WOEyNOsyNxu3wfV5kv8ykLGCo2WkjOTLviAkCCtFFzAcf1KHDrlvCr8IKQi
         HgjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795041446; x=1795646246;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vtujdpaU40al4T5ZdD8VivFKSuVoB9aJ5CGlvJ4l578=;
        b=06hmXOUh8OPnsQVnbH1zHI3vwLAzetDkRGpbazAUKhYuTTFpK41ngV7grKZ5OZSekT
         wMvp3P/leTwTrgC/GmLJ1LdbBygCRoPnpJz6FghPfFY8edsl89SFZl5NZiW7jcBBagHi
         /W1G6zAtQb0KtRbfzOjSITbIXylGdrMXamyl4EAiYraFhumVEwurd4uq678OaF1QSmCv
         00EXEa1BrCTMYiKklZOy9RN517xElAQPXOUpRCYuo22TsxAKnsZCmnaisTT1kVnwFz0d
         3EFtb/iASYPFAdDzuanMMXO2bIun9yUgUJ9YlcskE4WjiuukZSaOvdt5+rRqQyLFTIC0
         i6QA==
X-Forwarded-Encrypted: i=1; AL+hErH5HwipdAv8hN/Hhxbx0SVC57tmk2ZYp1BJWsv70en4OTiX2zaCqYcww5rErErmp5bbuRg/GZHkqw==@kvack.org
X-Gm-Message-State: APuU4Z9mtzEJVZqaGkKlUIj9w7UCj/72nYSfYfzMMQJ76SacJMGaESmp
	MskG2K/ux696zuJ18h0H/l+HJVLJVgqFv2IyTh+H1wVOlqIqLp2xfpBqZZY3u1mCPZfwwvU89jZ
	hEgww8D9xsvib6g==
X-Received: from iocre7-n1.prod.google.com ([2002:a05:6602:87c7:10b0:9e8:de6c:a5a3])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1925:b0:55c:888:30ff with SMTP id 5614622812f47-5774240c0a2mr4971244b6e.45.1795041445551;
 Wed, 18 Nov 2026 14:37:25 -0800 (PST)
Date: Wed, 18 Nov 2026 22:37:04 +0000
In-Reply-To: <20261118223704.3286085-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261118223704.3286085-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118223704.3286085-14-dmatlack@google.com>
Subject: [PATCH v11 13/13] Documentation: PCI: Add documentation for Live Update
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Alex Williamson <alex.williamson@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Down <chris@chrisdown.name>, Chris Li <chrisl@kernel.org>, 
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
X-Rspamd-Queue-Id: B5AE8120008
X-Stat-Signature: gqkgi1dni57xagfg9no53jaksmowyec4
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-31.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1795041446-474283
X-HE-Meta: U2FsdGVkX185NqwClp+WIIGyyIPxa3Bk4YkYhJ4MxjDZKIMHRKu4uQjEHOWV3xOAYrRgPIoJ8ZpxdOUYwJgT0gpCUIy5uVcy1LBzv8ZpRzp/CfLmvkQdlwPGTKa1Q949Cq0IlIH6yDT2jTctYbzOxIpC9EKzldg3uQ3H2Et+u/SG0Ilszxsk13FXSRq8zujnR/GJKlxS658N4iILwlfv2+aFyt/19spff4d0gXrg+fGsyGfYJUnxuQQNTdNpgVRms4GBMygd9TasxOhiK1HjiysuPT9I7HPh8USVIe9T4Cn36BSAPbisJ0jaf0hvNfiR4BlID3tFU8QIT+aKYn4na8PZEUlwUGbEjr0YUGQ41IjxI0aBgBq9AxGHE+mXJdNiJmvaA6nWsqmzCoxM551E0R/XOMCfkS7fSc1q3MwR1XPiD2nXdlA/KgiZb+sDB2eFbAdGsLbNaXTi9sBR0QQn4Fceuw7ypkAoChrg0XnuCbJNcgxqMovBYiX7xqRuTbL6liGwqaCOCN8tV4BQKezOo8kZoGzRUk+ATKdCPok7HP/F5Qn4uTrO/dlGrj/Xa4lbWhEUPZdjm1i0cYLtZfZaRe3wQZvljcw8/4g9MCWOn2WCyUr7P6shR/o8qU3Xw/kh1P4PggBy7WQdC7LUj64VM4HduBwIhKH0nuTVx2xX+qMagEyEL42cHdTgwjFFhI2x6q5Sj7FixFuWzYDyACXXxYy+MJV0izXDp4qsy3cG3rNcrzxX7FVBGYX9e0cfN8F7VwscEn5nX5zlOZG7b0btX/JJNgDihCLQBq2FtlUyaWKvx7cySCW+ubKCoHWdpDJx25eK9A7NmK7lRy0pcy0ywpoC6bZS340i2tD/4XMJoS8u3fwPOpB+XQERAmAC5xXBurW8qR7mMDvyggMsEEr7A5vE1LPWiXxELB4nYHSjvEcoia/TWSTDDqB9nnCSaod9zGvKo6P3WThk7fsFLh7
 8wWnl3pI
 Xa5SdmlAB3SDr15JckQhaUzkXBgdlwkJiPgy3P6l/dbSeEv07OWtm7dkSEU0eDWeCiJumVhOH0rHEdlHKzSKb3Qz+Qm1bU21EOhQay+cFykWlgI/rqDJt3CBiMHDhXE5PiSYdh9zd6mqtpQl0yE6Au3+J52JFwaDohAyApCuXaqr/aGM3TjCxUegTj9fMasoZ/2xKuMJFARJmEbL4VsyFhybY5Keg78j2kaD5aG2m2ff7aLZqU6A8H+yXuhMOC1re6RKxy7Scb1KqGZ69sRXGrlWfKsMFO42LcSQvnKHv2dk1Df5a2ThtKQBZrTmQmrfZW0Gu4CTrCynsUK7Ccua5+On/539QgokYTl6D6zW2CamEPuolB4iGfTHkaHUt74wka5zkaBpDaOeNR8KE2HRyoRW23eW5ayUp6zai04FcmbP04NUT3qgUnT1NT/3H2tarl5I5cfUr+m9CqNYDVKQSPRW/vI791AjS1AExfNxmY9doD1/IAwmC3XXQHSbbL6IkE2XZ0LxGIQl+zsAkbVTAiCz0T6hZNK+6vD7KGjeFwwWLRbKA9jmJjZ0HyjtcvTwpVunxrZdukt1ZUR4KdpP7jYP5d33V6D6DY6XTxhrrxxpB5wJQXkR9mHitILpp7VlbfhxEz7LsYM/b9jKT71CpYtZKzp8AQ/AiwUZa1Xutd9zr9HY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add Documentation/PCI/liveupdate.rst, which pulls in the kernel-doc from
drivers/pci/liveupdate.c and include/linux/kho/abi/pci.h, and link it
from the PCI index and the Live Update Orchestrator documentation.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
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
index 6b7c5f3a64d3..1572f6c905aa 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -21554,6 +21554,7 @@ L:	kexec@lists.infradead.org
 L:	linux-pci@vger.kernel.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
+F:	Documentation/PCI/liveupdate.rst
 F:	drivers/pci/liveupdate.c
 F:	drivers/pci/liveupdate.h
 F:	include/linux/kho/abi/pci.h
-- 
2.56.1.703.gf848ed807c-goog


