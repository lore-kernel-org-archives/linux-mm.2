Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C396C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 01:01:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 932836B0176; Thu,  2 Jul 2026 21:01:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 908D06B0179; Thu,  2 Jul 2026 21:01:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75C0A6B017A; Thu,  2 Jul 2026 21:01:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3DD746B0176
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 21:01:25 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 008F98C36D
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:53:38 +0000 (UTC)
X-FDA: 84944584116.07.DA96984
Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	by imf04.hostedemail.com (Postfix) with ESMTP id CF7BF4000B
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 17:53:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=EYAVZfQJ;
	spf=pass (imf04.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783014817;
	b=rHNsixSzmIcaYEMi1P3iXFb+tbvjae180a8Gx70/BS6MWug/xN0sj5hYyZlt/qwkkL8AgH
	p/5y7IxkOTz8TGtbPkUXAQ2md9FZEMLn+FPj4UhWVCbk2fsyddmGrBFLth1n6HeMNu1I5G
	6UdNNGQqWAo2vZv3TBA0ZnbEUg7hy+0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783014817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YRpX/gFLnZEEqF0UusNAsTB0VI4hO2m7E7PNpCTesP4=;
	b=KHr/r4GEaAGFdb189XGFkYhddCAx3JaeZG1/iFXZw5mKbGhw68oxZUDbxnOG79AY27NhsG
	YaYE1l+PcPkEIoLSi6vGf15Dhsxc1N5ETReyoDyuR5ReNf+oZYw19bVeO30VZ9ySeDXED8
	R+9gDnw2A6/ucIeu1AMGEgTlxREztG4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=amazon.de header.s=amazoncorp2 header.b=EYAVZfQJ;
	spf=pass (imf04.hostedemail.com: domain of "prvs=6363c8db2=sakacpav@amazon.de" designates 52.42.203.116 as permitted sender) smtp.mailfrom="prvs=6363c8db2=sakacpav@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.de; i=@amazon.de; q=dns/txt; s=amazoncorp2;
  t=1783014816; x=1814550816;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YRpX/gFLnZEEqF0UusNAsTB0VI4hO2m7E7PNpCTesP4=;
  b=EYAVZfQJqkofcKZrsydxFQRmMWW1v46dDrmuNNp0BlRyo42JhD75tPz6
   HRcN88tXuMBXDmUBPKv1HxitFFJ4R4Mpv/7oEX5HpQF5PWtWArP7ZPIZo
   q4bwXmOYXXVlfl0N1/CCKYz+U8sTRkt1zc9n2k/+d9gxapR+GAuLbLXZ1
   wxPEEo+JajDI0ZORH+STwDGZWDxUOUafMkU5b+5NOoh3/DdOtwrxmcYph
   A7DWy46hmrBQlZn0zySswsOLnJQbD+J0ox/X0RLoH3DYw2QHeTv6RkD6e
   O8IZafCYryZuEDBYYw3GZcl/41IgPKAq0aiCUJN8dzB94zc10VBcoJ59R
   g==;
X-CSE-ConnectionGUID: j4bOgIWfRyi74UZM0kS6RQ==
X-CSE-MsgGUID: 2vZoHb/STCSR9QGYYJjDAw==
X-IronPort-AV: E=Sophos;i="6.25,144,1779148800"; 
   d="scan'208";a="22965770"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 17:53:36 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.104:5839]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.13.18:2525] with esmtp (Farcaster)
 id f5b15eb2-309e-43c4-88e7-579e7a4f8061; Thu, 2 Jul 2026 17:53:35 +0000 (UTC)
X-Farcaster-Flow-ID: f5b15eb2-309e-43c4-88e7-579e7a4f8061
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 2 Jul 2026 17:53:35 +0000
Received: from dev-dsk-sakacpav-1a-480d1124.eu-west-1.amazon.com
 (172.19.96.155) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Thu, 2 Jul 2026
 17:53:32 +0000
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
Subject: [RFC PATCH 10/14] PCI/IOV: opt SR-IOV VFs into sysfs_lazy
Date: Thu, 2 Jul 2026 19:51:10 +0200
Message-ID: <20260702175114.24659-6-sakacpav@amazon.de>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260702175114.24659-1-sakacpav@amazon.de>
References: <20260702174033.32116-1-sakacpav@amazon.de>
 <20260702175114.24659-1-sakacpav@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [172.19.96.155]
X-ClientProxiedBy: EX19D036UWC002.ant.amazon.com (10.13.139.242) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CF7BF4000B
X-Stat-Signature: qyoxiftj7cxedige9i9fxp69b8khye69
X-HE-Tag: 1783014816-590120
X-HE-Meta: U2FsdGVkX19Tou6lakMLT/kzkEQqyArIDf3/CIwah7zUsNeWXMCw3XEqxnySvRmp3ZdqrA6KF4ICr8KirSCkztUkw4H8He7Ot6I91voHJxqTdUhiFSuwN5BhJmz/5nfH/4m3AE+hJN+lF8emWvphfqR50gYLS1X2YKFpP6dy/9T1Lp/z3BXKDUc5l1cscnHPx5kxp90L5rDu0u94SFkzGjYMT4GraPnQqccqVcdxdMcKtmKU9EC3q1PtjMoCF0E+dOxdtmcmzeqeEcjDG50ljAgzk//KQ1p9SXio4CwCTz+IWpdSpfOBF/Do7/iCEmI4m/OG8s7pOXJAtBKtV+hLyyNRdl+0gR7TRe3dXinG3g36VQhDfsPPtICe1ipahIDU2datYMfbICmvk/+hEqxSg39lQwWXx4AhQhL6wMEBsGKt1IOjxcBOuT9BBlCPmDyLntbaiurhPu1lmwqYyjHs8/U8ECHH+jclwBM8kYvz0O+qu48OZnUeZLuJmz6tKEkXx40CbgC0azaxCWHdMUfe2Lbk+PoW6wsZLHIyZsgwly2c3d6rkaAPHcpoPA1bsNQlljtsC38JFBimMHztUNsEg3Qrz+Xh3dGMDkNlKhUjVXgqTsIt8bhjcOheFZQwN8Lm50ZpHciwHGKdIYdcODfqCWSqYrSlh58wvWznB8wRC3OaAGvicttx2y2YNOx+84efd4S5AGD8i9VjoX3/btrfStBED8lw7pbh6kbzJKanvVgFeJWHM35f28gr4imsFS+4w6VvguX2T0bKovpM6FCxkZMUlm8cCQMhj8aVF2jJZjBNlYIEVkmk7YRf1pQz5DKIifQCVIuJcN1+qul3mOH6cG9ERdVS0FQiReaP0+9wE8eCTaczeZ+NUZgovGr1YIjYVWHrMoDRc/xxLnqDIitfrZSlYLTeVWEACxZ57jIWZtkQUwpu4MnSVJAtmkxRduhJgNy9Uh7Cpf3JGsx3IQU
 8y4su8EZ
 YKVVjDbVAZCAvPc0FqaBDXZr5aO9N1NtX3atkI5TdupHG97Jl9pzmLUobQC5S5bjsRRJ08/30QPEQdrV7myMA3VK7fIPMrhy/wh+DLXdmmKTPFQ/BVldfxOHruYa6gmbptu53oaTI5XQSfExD1JNR7Aanf39XxL5luTfJOnGiFuoA3fo+WlofPYcYtryhV6doGYBEj9mM16M2+stXLKh7hVTXX857+C1anOmPuj3V+rqJeN2IwYzgFDYQDvNfYGQ1vVIB2fn6nxA9ktL51twE4swVEHY1FowNdbGU7nfkv2ntE/6vhoKqNuKek1PvQ/AmY5bc1rmAPI+DjvT/vjFOJQ44mABw//orFIN9Zc+rtpWe1nlXpm4F98lr4EmTqm0Urwi/ev0a9+cslKpNogSdo//RgkX3Cj9P2maND1pOUe1Y185GNBzSFFEtOsudWQNLwFPeRWzUzIWd8SOdghRlFa3QyqZGfXzYpHwY4OEUgqRN4I/vNT7CtRcOo6DI3zREqm+ldqIMD+T9ANIe+lHz5a42Mn4OwXa+Q2o2/jIUgWXjaxZE4r9mr4UD1Kg3+rgHYvH8/TiTVDewB66iC18ZGlxFPBuZgCJFv94RZWg7ksLVhDZBwSY+2QalRSZ8B7WRfxVWf4t9E8o1mRj0YY2PNmf63zrHm+oS27vnq+yJZT7CYW7SHfl66rltNFvvyiRD+QjstqCqH2M+Frs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

First behaviour change in the lazy-sysfs series. Call
device_set_sysfs_lazy() on every SR-IOV Virtual Function before
pci_device_add() so the VF kobj directory is marked KERNFS_LAZY and
attribute files materialise on first userspace access.

Place the opt-in in pci_iov_scan_device() (immediately after
pci_setup_device()), which is the single allocation/cleanup site
for a VF struct (Shay Drory, commit 04d50d953ab4 ("PCI: Fix NULL
dereference in SR-IOV VF creation error path")). Any -ENOMEM from
device_set_sysfs_lazy() rolls back through that one site rather
than leaking the VF struct, the physfn ref, and the bus ref.

Add an early-return guard at the top of pci_create_sysfs_dev_files()
so lazy VFs skip eager resource-file creation; the guard covers
both pci_bus_add and the late pci_sysfs_init iterator.
pci_remove_sysfs_dev_files() stays unguarded - its per-entry remove
callbacks are idempotent.

Marking VFs lazy defers the bulk of each VF's sysfs population to
first access.  The cost avoided is per VF and scales with the number
of VFs, so on hosts that create a large number of VFs it removes a
correspondingly large amount of up-front kernfs node allocation at
probe.  The nodes are deferred, not dropped: reading a VF's
attributes materialises the same tree as before.  Quantified results
are deferred to the cover letter.

No userspace ABI change: all files eventually materialize.

Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: driver-core@lists.linux.dev
Cc: linux-api@vger.kernel.org
Assisted-by: Claude:claude-opus-4.7
Signed-off-by: Pavol Sakac <sakacpav@amazon.de>
---
 drivers/pci/iov.c       | 19 +++++++++++++------
 drivers/pci/pci-sysfs.c |  9 +++++++++
 2 files changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/pci/iov.c b/drivers/pci/iov.c
index ec2fca8209593..5537c3df6f45b 100644
--- a/drivers/pci/iov.c
+++ b/drivers/pci/iov.c
@@ -328,14 +328,21 @@ static struct pci_dev *pci_iov_scan_device(struct pci_dev *dev, int id,
 		pci_read_vf_config_common(virtfn);
 
 	rc = pci_setup_device(virtfn);
-	if (rc) {
-		pci_dev_put(dev);
-		pci_bus_put(virtfn->bus);
-		kfree(virtfn);
-		return ERR_PTR(rc);
-	}
+	if (rc)
+		goto err_free;
+
+	/* Single-site -ENOMEM rollback (kfree + pci_dev_put/pci_bus_put). */
+	rc = device_set_sysfs_lazy(&virtfn->dev);
+	if (rc)
+		goto err_free;
 
 	return virtfn;
+
+err_free:
+	pci_dev_put(dev);
+	pci_bus_put(virtfn->bus);
+	kfree(virtfn);
+	return ERR_PTR(rc);
 }
 
 int pci_iov_add_virtfn(struct pci_dev *dev, int id)
diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index 5a779ebaee326..8bf3837204693 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -1777,6 +1777,9 @@ int __must_check pci_create_sysfs_dev_files(struct pci_dev *pdev)
 	if (!sysfs_initialized)
 		return -EACCES;
 
+	if (device_is_sysfs_lazy(&pdev->dev))
+		return 0;	/* lazy: entries materialize on first access */
+
 	return device_sysfs_apply(&pdev->dev, pci_sysfs_entries,
 				 DEV_SYSFS_ADD_ALL, NULL);
 }
@@ -1790,6 +1793,12 @@ void pci_remove_sysfs_dev_files(struct pci_dev *pdev)
 	if (!sysfs_initialized)
 		return;
 
+	/*
+	 * No sysfs_lazy early-return here: populate_one/populate_all may
+	 * have materialized resource files on first access, so the
+	 * per-entry remove() callbacks must run unconditionally.  They
+	 * are idempotent either way.
+	 */
 	device_sysfs_apply(&pdev->dev, pci_sysfs_entries,
 			  DEV_SYSFS_REMOVE_ALL, NULL);
 }
-- 
2.47.3




Amazon Web Services Development Center Germany GmbH
Tamara-Danz-Str. 13
10243 Berlin
Geschaeftsfuehrung: Christof Hellmis, Andreas Stieger
Eingetragen am Amtsgericht Charlottenburg unter HRB 257764 B
Sitz: Berlin
Ust-ID: DE 365 538 597


