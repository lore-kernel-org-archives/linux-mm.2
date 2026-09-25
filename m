Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 923FFC98328
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 19:30:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0468A6B0092; Fri, 25 Sep 2026 15:30:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F38E76B0093; Fri, 25 Sep 2026 15:30:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E75CD6B0095; Fri, 25 Sep 2026 15:30:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE1516B0092
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 15:30:22 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2FD42C033F
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:30:22 +0000 (UTC)
X-FDA: 85253275884.06.BF78D36
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6FF3E4000C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 19:30:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lY/jjOpQ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of nsc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nsc@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790364620;
	b=xE4Pf9U+H9Qeq8bgoe2ySCFZwq8WrtgM1/5ujXtlle6bJPvcIWffLPnBWRsNi6nomQq2Np
	8p0mQCx+lqsrge7vwnGwgHqwQRA6YbUfeCj9HVbegcx1n1k/JDx0gyAnPtTTxfGvzAdsi9
	rYQa27GoF+uexYznA6seBiHxhx6eAx8=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="lY/jjOpQ";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of nsc@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=nsc@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790364620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dA+hfa1kQZbaNVONmrZnwYeXHMn1vsq598ePpiU7B9Y=;
	b=lF/ExTULJgODCbBw5spdjzFcdpU9H7si7i6Zoc2exTPxMONFfewYDsg9c6D5xc4KrTLfq2
	d4gCmmMV5e0v6rEHUK0KSQszju86CWc4IiWJ4H7Y2Zhe/NzyH8ESK2i18qzqIVGCpP3Fu7
	sJmfLKy5xdboxXLZJC/hH5ssBp4pDdA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with UTF8SMTP id EDADD60261;
	Fri, 25 Sep 2026 19:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 33F1D1F00893;
	Fri, 25 Sep 2026 19:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790364619;
	bh=dA+hfa1kQZbaNVONmrZnwYeXHMn1vsq598ePpiU7B9Y=;
	h=From:Subject:Date:To:Cc;
	b=lY/jjOpQYa1WuC/0HJnPK8VazSYniOslQPwa1od00x1u7tvjLUR7olim3xn8VbDfA
	 5Z9Hvij9oxD4JOZ8xIbh59oglxLtsCjKcvCZe8mE+ApjXlxUA0VULcRk13YMT12/tA
	 RRsk0tot8SeD5gWXijB63RdP0r/9adEepl5UVyevMp2yDl6MMaFY4w7zoGpYmKeTdi
	 tB2hcarX8yZs9HcLOqpURK5vlE+3fkKN2WJvEaZBVL0YRaQj8yxLdX34VBcDooNCFP
	 l9m7PXeG+TllvhCFIzO9ELkGq7X6wWh89CG6LF5QMg3lrP/Rrnh+SnX3vw4P6uAyjk
	 qdUrb53rYZBew==
From: Nicolas Schier <nsc@kernel.org>
Subject: [PATCH v3 0/2] Move tool for generating initramfs cpio to scripts/
Date: Fri, 25 Sep 2026 21:29:29 +0200
Message-Id: <20260925-move-gen_init_cpio-to-scripts-v3-0-99c493f76722@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-B4-Tracking: v=1; b=H4sIAJnLtmoC/4XNQQ6CMBCF4auQrq1phxSsK+9hDIE6wERtSds0G
 sLdLbgwrlz+b/G9mQX0hIEdi5l5TBTI2RzlrmBmbO2AnK65GQioBIDiD5eQD2gbshQbM5Hj0fF
 gPE0xcI0Hjb3WqGTLsjF57Om5+edL7pFCdP613SW5rh+5FPqPnCQXXBgllO4kGtWdbugt3vfOD
 2ylE3y5GsQ/DjIHVVejVKaWZfnDLcvyBpu0+1saAQAA
X-Change-ID: 20260225-move-gen_init_cpio-to-scripts-9e89ef99e51a
To: Nathan Chancellor <nathan@kernel.org>, Nicolas Schier <nsc@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Luis Augenstein <luis.augenstein@tngtech.com>, 
 Maximilian Huber <maximilian.huber@tngtech.com>, 
 Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Willy Tarreau <w@1wt.eu>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <linux@weissschuh.net>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Askar Safin <safinaskar@gmail.com>, linux-doc@vger.kernel.org, 
 kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kselftest@vger.kernel.org, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Mailer: b4 0.17-dev-1f2f7
X-Developer-Signature: v=1; a=openpgp-sha256; l=3169; i=nsc@kernel.org;
 s=20250924; h=from:subject:message-id;
 bh=pDqb994ic/Z+6UXT2aao8EB9GiNe/BjSDj6U340lXcU=;
 b=owEBbQKS/ZANAwAKAQdSCnAWJhJpAcsmYgBqtsufqHVxTJCI0rLc+eABWiVI3ljpInqfy4sM2
 gxxruzB5D+JAjMEAAEKAB0WIQSHQTenhzckp4G+wsYHUgpwFiYSaQUCarbLnwAKCRAHUgpwFiYS
 aZn6EACtoEib3BZH+y5xRl0zD2V2yMwKvo5lxRBhdjAU39DdGVdrWBrpZtD88s6B48PRXbIVTzz
 6z3oGarFnGbDuaOP1lQLQvFUbmLY97a8LGv5KapqwOCjGppxaRXXaVayT5MK9wCq5fjDwgHzXk/
 +Z1qY/yPEGGVU6CjTWmqPH9nLHNyMyJyZnJTOjw+rI4NAkmT4bqwZc7ovQSjVsQxeLMdznQ7HVN
 rjMAb4DVAaNuAHZT6xwjNALqQ+zLKIdWKNBToesbHMIjJNGdhe2o3S1x3nJ1sDJje2AfkMNIDKm
 wdZHuEumebEIFqbtDJAcHL9CAJN9/PrpsVxaTs8mCe2Qbt30RgZyT7PFI3W070rRY03Hlcvb870
 pm+5svMdWB1m5zuBeuqG7QQLVsUq6fZlHS6kcELrNLCGrJJPo2c1CeiBxOocVVOjPrzF+dNh2bz
 jBWaMGNCij2OhNpZgD6cH3kPa90w0u+cNPuDDw6CruRuFc1keb+bptvLUdODnc9RLmVoFN1aWkE
 HM5wlVBYku/JnxHlhUDKgu/tKIZRiUE/7mQ5vKzgr6vMEboAEwR6uBV7AbssugNu9v4jVTqgl0W
 WrEwqtKHP3UV0Qc6inhSD/tEttFBEpY87DVNEjllvQUdUa4eJJtVDSihNY9phvp3uM/3klpfBmn
 030TuXssf+PQxnw==
X-Developer-Key: i=nsc@kernel.org; a=openpgp;
 fpr=18ED52DBE34F860EE9FBC82B7D97093255A0CE7F
X-Rspamd-Server: rspam06
X-Stat-Signature: fxooczbzq3z37faswnkczzt4c5b5krdm
X-Rspam-User: 
X-Rspamd-Queue-Id: 6FF3E4000C
X-HE-Tag: 1790364620-80087
X-HE-Meta: U2FsdGVkX18/BCBFaO9xoq1QnQDDQvSiFfvmBMtDnyD3cBrRsLE7mwuyTI6csLGBiIJAtMrABh5t58gJNm35gIPX7JQrwGACRSXjPISJbYPxocampHSrzGfmpYAe7Lz7ngXGJRC+6Uxzzlzvgfir0i3McXZX2bwQMap6cNLKMU8iq9UnzPxgibzFk4rfJ3s1ieFl7YIG5nCYS64N5doI7h5xQWuztRIOlIbngD0c6wP25+W73GQs4N85PJIEZ9VMyqUKiZNet5r95u20hIFCoi8hXVXwH95uCT+PSSaDyzoXLVWEjChriU0UQmUYvO9QDuSXA6jMb5craDQYa8REngcBIrViakVTPCeRqOYu5adHTSKmsYMh8PyRekjQeSsir9lZC63nATtEPsyeLjk9GETbBLdy5fIkR//6voC3FHQgwB3/8qVWR73PBU8hEKMBnPaLGjgXPAcrAxwGaWBnruhQipXrpWWnQvbXzIYJ0M2QD1XKh5aSXKHnWDWt0fykiaUZ31U0WRFJV354f0pnFN7/SaB03hC7ATeQE4JHulx09Abmt8rMMZq5oKC/yDGKg7eZkSYdAjDBCNq1TJdT7vgVP/HTfBrktYuCwxOQLPY/f+5DpS2B5xTL5x8HcD3U5K+/HoztE5mdSgb6Ebaz7Q9X+dORmdqrd5ZNViA/FgGydWwYK/8UpnLOJ86Gum6Ida9PmH4pZyZYipn+ElVpUvoIJweqdR0Fd9+RNS/EkvKgQn1O72OrW1797xhNKt5/3QJ+4eAqLMOsFJJMBbpbz5HWnirpnhbfJNFRl3I2L41YyT/l660kRcdAEoLS+WBO4zcRmn/cqXBKSglbsv0iAejCpENYss2uCC3DBPNbKGynRPMIALbn+UoOFkeAz5iNBXj4ZDbyCR9WdPspjr9DIEr1pDIoE5isByyEG53Y2n/GAj9B8Y+FNM+VdA5wpy8MRh6fcyoyy99B1Jz9gFo
 aS1MN2X1
 1iydFbst6eL0+pSRYwZz00Z1ax3Y27YqHpaFtsMnEeiYEndTXtLlIYJbh2FaGRqI02O89MUzLufR6AV1bNa2TkHbBfuzOnCxDCK7RVU9UfKvRqHIX9m6y03j7kAWvUjRZpMRSYhAPdpJGzoOKjzpy7/hf/8/CF5djZ2zzSUG+KCxasWrB3KPu92qiJF2f3YS9VdvtSDSsn2Vlw5Z2WjlIPpiQYp4O4A3bJIyClA8YHaJAIcHbo7aF4c/+BnAlxmbi8qRh84lz6NDfyu4MpAFDtUBn+P6CbWuCOa46hUSbIEgnc0+M1ZezIZdTiIe3Z5j/69mAjoVOpZ9lZ+Dypr2C69WGIy6CyjgszV69tdOifHn6Ewy9T7tcfXLkk3X+ZU/6Ue8B1hpUti0CPEu33E3jE2iI2B7MX3O0ymCcuFC+2+08QEo/kQVegTbIBiNQ41lDZhHA9CXzrbBsNIExw5K84y8mPYXhmdZT2MfjDUURAZ63on9nNYjIdSXMxVr5h1Qzh2jfqcggU45VkSwWvgo2Bwc/Ef0OBhTEp9/MIB0YW6zKzNR9ohcEj1UCDlL04OYhLZVK93LogaVog6vuKAPB/dSwvwGALqVbglGaqqr8GLSyTcSI1bexH6UJN6+BMF1P2VSnfoM1pCJa9cn75YAHarZ8xv5fF0SrleK4IpLo0AtGyhtqejLmwDYlM2SFQ026oeT9xAGo1s6EgEfnWIVkxmT5KY0Eo9YYMyap59lep2MG2NsT/UGln9oKOs2k1MsDjBYCsyiN42U+pWDd+uASp1sqelU1bL1T7yiBtkY11cyOMmNr62nKVnPQBJGImoVsJytCHywxWyETDf0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

initramfs cpio tools had been subject of several recent discussions on
linux-kbuild.  Let's get two minor steps forward by enabling a
top-level target for building gen_init_cpio w/o the need of a valid
kbuild configuration [1] and move the tools for generating the built-in
initramfs from usr/ to scripts/ [2].

Link: https://lore.kernel.org/all/20260220191150.244006-1-safinaskar@gmail.com # [1]
Link: https://lore.kernel.org/all/aSdrCFkUQup3qb-q@derry.ads.avm.de/ # [2]
---
Changes in v3:
  * Update various remaining usr/gen_init* references treewide (Nathan)
  * Link to v2: https://patch.msgid.link/20260720-move-gen_init_cpio-to-scripts-v2-0-26b7e15c7133@kernel.org

Changes in v2:
  * Build gen_init_cpio only if CONFIG_BLK_DEV_INITRD (Thomas)
  * Keep underscore top-level target name (scripts_gen_init_cpio)
    (Thomas)
  * Link to v1: https://patch.msgid.link/20260309-move-gen_init_cpio-to-scripts-v1-0-0c5059b1ec5b@kernel.org

To: Nathan Chancellor <nathan@kernel.org>
To: Nicolas Schier <nsc@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
To: Shuah Khan <skhan@linuxfoundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
To: Luis Augenstein <luis.augenstein@tngtech.com>
To: Maximilian Huber <maximilian.huber@tngtech.com>
To: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pratyush Yadav <pratyush@kernel.org>
To: Alexander Graf <graf@amazon.com>
To: Willy Tarreau <w@1wt.eu>
To: Thomas Weißschuh <linux@weissschuh.net>
Cc: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: linux-doc@vger.kernel.org
Cc: kexec@lists.infradead.org
Cc: linux-mm@kvack.org
Cc: linux-kselftest@vger.kernel.org

---
Nicolas Schier (2):
      kbuild: Mark usr_gen_init_cpio as no-dot-config-target
      kbuild: Move gen_init_cpio and gen_initramfs.sh to scripts/

 .../early-userspace/early_userspace_support.rst          | 16 ++++++++--------
 Documentation/filesystems/ramfs-rootfs-initramfs.rst     | 10 +++++-----
 MAINTAINERS                                              |  1 +
 Makefile                                                 |  9 +++++----
 scripts/.gitignore                                       |  1 +
 scripts/Makefile                                         |  3 +++
 scripts/Makefile.package                                 |  2 +-
 {usr => scripts}/gen_init_cpio.c                         |  0
 {usr => scripts}/gen_initramfs.sh                        |  2 +-
 scripts/remove-stale-files                               |  2 ++
 scripts/sbom/tests/cmd_graph/test_savedcmd_parser.py     |  2 +-
 tools/testing/selftests/kho/vmtest.sh                    |  2 +-
 tools/testing/selftests/nolibc/Makefile.nolibc           |  2 +-
 usr/.gitignore                                           |  4 +++-
 usr/Kconfig                                              |  2 +-
 usr/Makefile                                             |  4 +---
 16 files changed, 35 insertions(+), 27 deletions(-)
---
base-commit: 93f51579e7df248780214094418f205253383cc5
change-id: 20260225-move-gen_init_cpio-to-scripts-9e89ef99e51a

Best regards,
--  
Nicolas


