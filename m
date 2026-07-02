Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21D8CC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:57:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6A1C6B00E7; Thu,  2 Jul 2026 20:57:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1ABF6B00E8; Thu,  2 Jul 2026 20:57:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE2CE6B00EA; Thu,  2 Jul 2026 20:57:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6C91C6B00E7
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:57:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5B1D8167A86
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:51:25 +0000 (UTC)
X-FDA: 84944578530.22.9B557E4
Received: from pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.68.102])
	by imf26.hostedemail.com (Postfix) with ESMTP id 25879140006
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:51:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=PhCUyCv2;
	spf=pass (imf26.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783014683;
	b=AJ9x05bdhOJTNNBUFoJOmevGoX/pKho1WrUjVnShnwZ6Q8P1COK62+u1FORHWH4isiWUkr
	n5fandVtFq6uaA1AqAFkxCGsRm3R9yhX9KgbHwaxBt2LAjCnsNFSzPvX+OHxXw0zewVp+I
	tHQORDZEWRJDiCu3Bs7aaW1QmJ3nne0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783014683;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mmK2zooHqLvAHzbEI5SDeIhxEVgl5YiYD7Pep1MMb4k=;
	b=jBiUo5DoXcu18wL4UN5ux4VEUJY5VOsJ4HuYGVpCucuUy6WoreByUVKSgx9kcxO41Whxcm
	l9x1f/fj6syH41IZTsA8g72PDCB8/jE9l+IvKDR3Ay8f1EGoIL2IWPe8DJVXhLJqhgH17q
	6SulhkOCA46O+TDddknzBc+KKoT0JZk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=PhCUyCv2;
	spf=pass (imf26.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 44.246.68.102 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1783014683; x=1814550683;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mmK2zooHqLvAHzbEI5SDeIhxEVgl5YiYD7Pep1MMb4k=;
  b=PhCUyCv2nC+Q4/rdBp1CrLZRfMGFJs/cgPFZgOk7LXC2pjGkRrpGBL2h
   CVpbVz8j3Q1WsMl19rTgUJMOZstZSiSgYPnvBKcbhNt/M/FYZ6awOo8Rc
   KyfhOtlYa/Zig7PfgQXeJ7mqsdQ2VWE/uSA65eH68Gk0cXNHSBNTKe3x5
   ic1A5nhdJNbdZs/JRlhviMfz6M1N2q1+DVKEu00inpFUWtNUCrocb41AX
   0tmIk2zi5Oic0YBQDH5JfDF8EmDjAm+z7UJaS/UXvHimAJQ21H6rdvo3Y
   KO40bk+kOyc1HfaE+VMiwK7lQzUvwrV1VRmVdX/XOYc88YX0hFeDusiZz
   Q==;
X-CSE-ConnectionGUID: HKUz4EBzTdic+O93pqepGA==
X-CSE-MsgGUID: DNQoA3ZdT9yO4I8VAgOujg==
X-IronPort-AV: E=Sophos;i="6.25,144,1779148800"; 
   d="scan'208";a="22963757"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-003.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 17:51:22 +0000
Received: from EX19MTAUWA001.ant.amazon.com [205.251.233.236:4473]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.43.112:2525] with esmtp (Farcaster)
 id cd19b220-fdcd-4ca3-8e48-99625866b657; Thu, 2 Jul 2026 17:51:22 +0000 (UTC)
X-Farcaster-Flow-ID: cd19b220-fdcd-4ca3-8e48-99625866b657
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA001.ant.amazon.com (10.250.64.204) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 2 Jul 2026 17:51:21 +0000
Received: from dev-dsk-sakacpav-1a-480d1124.eu-west-1.amazon.com
 (172.19.96.155) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Thu, 2 Jul 2026
 17:51:19 +0000
From: Pavol Sakac <sakacpav@amazon.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J . Wysocki"
	<rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Tejun Heo
	<tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <driver-core@lists.linux.dev>, "David
 Woodhouse" <dwmw@amazon.co.uk>, Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, "David
 Matlack" <dmatlack@google.com>, Samiullah Khawaja <skhawaja@google.com>,
	Alexander Graf <graf@amazon.com>, <linux-mm@kvack.org>,
	<kexec@lists.infradead.org>, <nh-open-source@amazon.com>
Subject: [RFC PATCH 06/14] driver core: wire device_ktype populate to walker
Date: Thu, 2 Jul 2026 19:51:06 +0200
Message-ID: <20260702175114.24659-2-sakacpav@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702175114.24659-1-sakacpav@amazon.de>
References: <20260702174033.32116-1-sakacpav@amazon.de>
 <20260702175114.24659-1-sakacpav@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [172.19.96.155]
X-ClientProxiedBy: EX19D033UWC004.ant.amazon.com (10.13.139.225) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 25879140006
X-Stat-Signature: dyhwofhkh4yh8qdbs5npupra98w53b55
X-Rspam-User: 
X-HE-Tag: 1783014682-829952
X-HE-Meta: U2FsdGVkX1+0GIinzkeH3UZmOTy7alUtSNutru1JEcgYZRKy/LOtGA87soIOIw0hGGzcYrFlJ862W0ReokMtdECR0BZEbhNt8lVoLn5EIiNUVq8R58yzuBBYqjMiqccNBR/Acik3rMAvr2+NcokKTNkTqPAJZP2Ca5Nu30tfTscnaYwxawXWOOHmRIf9a96uZ+ZqT9yXH4YMn6DQIY377bcCusYl9tE2JYnTXtUZNyFRx9JmNErc24lOYMdidzfLvx6wxtpqLASAUQ1Cj8MFmdWCCsk2rM8jUOwycBqUvcxPJQt5oGft/fsp0FtibpuNciihgq93LccnqLMBnnPhDKAZ7+ACoRms+OruzXZj0A0dFoHFE6FDxZz/Pi0MN2b+G0pNR8RzJkhQ8uGygvksDcUj1IGfi00S7zSwcGuFIiBEfP4bBha4NUL0VWLvSnwnlMJ73AxB1G2Hc9W+WEqoR19R8XIky4uuqLK8AgqFVhvsHGKSzH1JtjVQNodaWjFs3S4G8OVndP8c8GzMzlTxdx2ck62gtTylCgodno2DfD7AIgAen0PuCyBWzVWNAkVfMiqDf+e35L+52LzWVRoVvH7dDgvOTDug/hKmQTote70p5uyPL7i3IJx6ESa7CGK2wsZsLj+AJANM3wGYpCMO8v7mJOvZe0rLoC2o4EP/zlIHgUgdzOiCjLwdfYhhIWqmIneMZYfjFqR7fSPt2VVQQaU0Ex9poIF+L5EKdgLT0v8daSOLa1XoJ9cjxk5xIJwdiuaRR67HAH/RCcWKaXNbAkaCRQ9BJ8IfJqvJSm1Ytwc+VaXOQrFy/oAmI8yVM9hS1qNLR5GCUFyB7P67NrXWibaAqY6lZaW0BcHHKeQasMClvGFrEc4leWlGkcsnigyZ/ULPQgvbUqzXOc5jcwMQGjVJ5glfbTkc3x+u+JQXc3aeZJO7KExe984sCyKb+UPc0VKFJwD5mFoIRaUwUu2
 eiN1qJ32
 2STVGHfplzYIE83o511O5PLsRwWeqIBPhH3CT6ml/R6ouJXGnbHB0naVe2g0J2Z2/ccfCxlcquDMcN+HQKcjYYycHyYtjVgYuTZfyUmXap6fD6rpyT7uP10nxNi2PqG2jFe2mNxL654O8mRcFDGtEPsCxYZLKmL9k/QSQUSU7zpoaUATs+3Lx6U7ywduov309/HM5lBCvSe2E6qYiXM8VQW0gMIjIDMjINXY3/p1SiS6VeGck/q1GoYOBEiUb25ZtC8206UQZr8fVGvmk05aYsp2HzbQ3gfdeNxzfee00XLpENVQ6grlqXJacsBLKWjkVKHCQLQK9p01pbxFQkDcnOTnTTYLkKOC2q7+AtO19H0om6uf4NuxVE5bRm4ioLahjkOsCcGcEYRxmnS35/fQwZYnZ1zPUNbEAysPPhxu0g780ipAaDY3pq4fI6AoZswpXvtXHizpgbXedcOgMfHcv+SR8QUiHQh1FmTSSq8IpNvflfKZC26C0yQADAO6CLUzKn8D05ngwP//3au+95ugt9/bMbP+I8woBjZ0x6Ii8nhsuqt772brl0rC68BDxEzQPD2vYPn1l64g3vpIA6ydf0pOXUYC7Krdf31YSynctcEEJpAM6zix7EjEBAaJkr9QSRAeotPmFIHffGXd6tMyFI1Ql2HW4Y30QgpKbtM6ccF1oPUygpZRIp9nvZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Wire the kernfs syscall callback shape (kobject *, const char *)
to the device-level walker. Add device_ktype_populate_one() and
device_ktype_populate_all() adapters that dispatch through
device_sysfs_apply() over dev->kobj.ktype->entries (currently
NULL; the migration commit installs driver_core_sysfs_entries[]).

The adapters early-return when dev->p->dead is set so a populate
racing with device_del() is a no-op.

No behaviour change: the table is empty until the migration commit.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: linux-kernel@vger.kernel.org
Cc: driver-core@lists.linux.dev
Cc: linux-api@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Pavol Sakac <sakacpav@amazon.de>
---
 drivers/base/core.c | 50 +++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 46 insertions(+), 4 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index aeb4985eb8838..975b6e0c4dabd 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -33,6 +33,7 @@
 #include <linux/swiotlb.h>
 #include <linux/sysfs.h>
 
+
 #include "base.h"
 #include "physical_location.h"
 #include "power/power.h"
@@ -2841,10 +2842,9 @@ device_sysfs_entries_end(const struct device_sysfs_entry *entries)
 	return e;
 }
 
-static __maybe_unused int
-device_sysfs_apply(struct device *dev,
-		  const struct device_sysfs_entry *entries,
-		  enum dev_sysfs_action action, const char *name)
+static int device_sysfs_apply(struct device *dev,
+			     const struct device_sysfs_entry *entries,
+			     enum dev_sysfs_action action, const char *name)
 {
 	const struct device_sysfs_entry *e;
 
@@ -2972,11 +2972,53 @@ int device_set_sysfs_lazy(struct device *dev)
 }
 EXPORT_SYMBOL_GPL(device_set_sysfs_lazy);
 
+/*
+ * kobj_type populate adapters - thin wrappers from the kobject
+ * callback shape (kobject *, const char *) to the device-level
+ * walker. Both read dev->kobj.ktype->entries (which is currently
+ * NULL until driver_core_sysfs_entries[] is populated below) and
+ * call device_sysfs_apply() with the matching action.
+ *
+ * The walker traverses an empty table today, so these adapters are
+ * no-ops in behavioural terms. They are wired now so that the
+ * ktype plumbing lands as one reviewable unit; subsequent commits
+ * flip rows on without touching dispatch wiring.
+ */
+static int device_ktype_populate_one(struct kobject *kobj, const char *name)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	const struct kobj_type *ktype = dev->kobj.ktype;
+	int ret;
+
+	/* Device is being torn down; do not populate. */
+	if (dev->p->dead)
+		return -ENOENT;
+
+	ret = device_sysfs_apply(dev, ktype ? ktype->entries : NULL,
+				DEV_SYSFS_ADD_ONE, name);
+	return ret;
+}
+
+static void device_ktype_populate_all(struct kobject *kobj)
+{
+	struct device *dev = kobj_to_dev(kobj);
+	const struct kobj_type *ktype = dev->kobj.ktype;
+
+	/* Device is being torn down; do not populate. */
+	if (dev->p->dead)
+		return;
+
+	device_sysfs_apply(dev, ktype ? ktype->entries : NULL,
+			  DEV_SYSFS_ADD_ALL, NULL);
+}
+
 static const struct kobj_type device_ktype = {
 	.release	= device_release,
 	.sysfs_ops	= &dev_sysfs_ops,
 	.namespace	= device_namespace,
 	.get_ownership	= device_get_ownership,
+	.populate	= device_ktype_populate_one,
+	.populate_all	= device_ktype_populate_all,
 };
 
 
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


