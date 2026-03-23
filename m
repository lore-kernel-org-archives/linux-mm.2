Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0A5BF532C1
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 00:06:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66DAF6B008A; Mon, 23 Mar 2026 20:06:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61DB36B00A8; Mon, 23 Mar 2026 20:06:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50D3E6B00AF; Mon, 23 Mar 2026 20:06:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 409F56B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 20:06:02 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E1EC31A0D91
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:06:01 +0000 (UTC)
X-FDA: 84579013722.13.0359BD8
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3304312000D
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 00:06:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=O7FGtOwC;
	spf=pass (imf29.hostedemail.com: domain of 3stPBaQgKCLUYhVogVXfbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--dmatlack.bounces.google.com designates 209.85.161.73 as permitted sender) smtp.mailfrom=3stPBaQgKCLUYhVogVXfbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gw5NKF4E66vyohb8n/pa3diZrC0/+CJM8Skon/TvWYk=;
	b=SzWR8PMzeGpMu4tU54Tsk6XcMkwXSx21SGvyFCCOwVfDSok+07L+a/eFKlHy+lLnWGbYzc
	yKosUTdvRDVcZBVXJ3UI1gHlQhiuZfZ9QmIRitPDcL5bWjha9Pfbbk180d2II6vMHI6hpM
	QALq33y3MFlqqP3ml3x88XcTUcvpd5w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=O7FGtOwC;
	spf=pass (imf29.hostedemail.com: domain of 3stPBaQgKCLUYhVogVXfbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--dmatlack.bounces.google.com designates 209.85.161.73 as permitted sender) smtp.mailfrom=3stPBaQgKCLUYhVogVXfbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310760; a=rsa-sha256;
	cv=none;
	b=iNWO3I2bo+nNYresizxlRJF9UUncf2hKei2Bl0sGbTU+V+POt+kwPlKaqQ7/FEu9GXmpLP
	GLQaowyrEAXkz3BvjYNmM8orccFWEu/w1T37HhD4wW1XlTcb3060ujaMQ8QiK+IdDtKskE
	fcsIdT6WEtAwwerE5EqNYWQdeponJiM=
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-67dece24dbcso9906384eaf.1
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:05:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310759; x=1774915559; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gw5NKF4E66vyohb8n/pa3diZrC0/+CJM8Skon/TvWYk=;
        b=O7FGtOwCR33uqlgE80gxW6k3WM/arT0TfSLLDPQo/5lT/tTDVKVGpuDkK8lEamS4qb
         /ii+V8AckP8X9D6sFOp/XN1UPtc5kV1zDumNYQiFiVMEzOCz3lFXaP9Q2C2tB4La2Kcs
         YDgUVwgGbFU2sCgIg8i6A4BnvmfQ0zNwREP7DWFWRCLv6y0WIQ1rMAn2wpm15E1jHJxl
         ftFga+i6JIA+eGDh1qVeUH2tOJIaFHPhJCL/DveJW7UqoLk1acdUgWHjbjTNwBYsT3JV
         fxuRLJUM1BMt+ECdp13k7aAypcF6sn8/kvwg7zIx6HUFfJ1Z08RDJjanTgH7EZz7+omG
         garA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310759; x=1774915559;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Gw5NKF4E66vyohb8n/pa3diZrC0/+CJM8Skon/TvWYk=;
        b=Mufd/SFfDcdj9By/30ZxSMRssacJ4QM5ZmfDkX5E+dG3c7uTEvxCtlMeO5/ILyHq4L
         ED7Rfkdbn5XJT4coJWaL1PYFgyWvUS7W5zjcnGyzT65aoBRsJVCzslPBpOiYp546Ow/G
         WX/Tm1Jn9A8gweSnMBOcvJCoAqt5puuJr+E2J0/HobrAD1GNBbUsIAnCY4YgmywPLPNG
         dx4cKjhj2DPDKhyIEAaFiCo/sSKOnTJ0JbeLeRYRi1JRCYcgaZ4/UflR8hpNOAduZkKN
         6+jdegUOIVa00No8EAu9YRyPMQnAWDoFgIwllp8hnoFypamkOdH7Wd0MYyP8CDWgGzMP
         1r/g==
X-Forwarded-Encrypted: i=1; AJvYcCUR1VFRdUFtmMUZroRj/XIHleG349ySK1Z9qlIIzs6YIiDGzpphsY+PLdqTK+aXVn8MG3fC341exw==@kvack.org
X-Gm-Message-State: AOJu0YyF5gKPSHDJEYNbZDiKtI3MyY6GfPMYsUfdt2lOAcWGnyrpxKf+
	3mr5wI/9hjeWJa8YnLexKZ7WPd2B17JcmlQNMPkGx+0Tqyoehv9023cEzDUA88NJerDSKyLwzvI
	86cdGsdVX0MA40A==
X-Received: from plar5.prod.google.com ([2002:a17:902:c7c5:b0:2b0:5a1f:4fdf])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d507:b0:2b0:5795:9ead with SMTP id d9443c01a7336-2b0825e35e3mr130027435ad.0.1774310322445;
 Mon, 23 Mar 2026 16:58:42 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:57:55 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-4-dmatlack@google.com>
Subject: [PATCH v3 03/24] PCI: Require Live Update preserved devices are in
 singleton iommu_groups
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
X-Rspamd-Queue-Id: 3304312000D
X-Stat-Signature: 1hhsk86qb7k833im5uhxgfbw4o44y9zk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774310760-381241
X-HE-Meta: U2FsdGVkX1+LSmOusDInjeKbLcGxiMUN9M4TR0kSkgH9wTAqzsfjQ4Aqh4Kdt8f6sdFDgbELoAwyHFh0eqVHXE+0AXFa72TunorE9ApvolMnbR41OW3q4Eq+Mq3metf2JMMtpkmH8G5ejGdXnaFI0LsSZ7k1/P+hp5FIUuBcQdAhUCjgAf4o9pS39074r0hmleHrLghItD1JV/kPX4TtuldP18NKVZXf/bGXerNKZsr0/cyi8RcF8Qz48a452PbpV26X7BczZOfnoBgA7JSwpq8ikhUAJo8s1H9O1CFtcEbMBq9KIYHyE/GwpLfysPvJOVwdhkKOhdCeFzK4hS04ZAAszmXFJ9N8xlntoacUCbey8UyK5i3S+UVOPRB1s1Fd2AeAyzRooOBxqd0Zb77+nme/HjEYb9Who1GvK3bDkdK9gEKV84qE2hSeRvqlTc86hl/3ro6wSIseF1hcGnRkzsSh+TZgyfYuKS+g/17DDqX/YcvTz2e0/QgRfr2Nq1mS41Xi073vKeMdjCjNfkDXwQ4qRBo/Pwaips34WZySU9nZEeGeFdrQn1pBitDHYbSzUZ0zyg07rpwtBJfBTrw6RsRlbZlGsNicNCIAvMVClG+1lyCNgDG86Mi7pFv9xxY1qJDZNxnHvdvUd2roPJYlDS6a8kxp6DNqN5E95bfe+Nj5mOSozyzQKTVtS4MegriLZb3cQqJmZrSnn9wsWY0eZAAfvzVss844qpJtcHTYD7F1Y4PEBFRSV/KB0DppS+K9DCzsL/qhImwcQi7toPpViWET+jXKeJsUWDLcIDVDYRrd+ZLoTGFPORIlMVk7Xgm/M7MdcxeppDedF0xPDa51PNeqHmqhm4mV+aNv92gzAYT4Ra8DLXKlZ6B7/CoMwQICd+YNCWEBtECaiUbgV2VIHGChS3/tBJl2+5rlFExIMB7tv7h4RmwXxBdjfd3CMqUBoNLEgpt6ClPXEOG9/nn
 mwNHJTfF
 8TE2m5NY8wSfY10rotzHg5mkDKYGVoLJannbcht+5iCNSyy7jM/GB6AcHmZZK8g4taVZUxmuXvYqWp7z9neLMsCsz5gyDbvcotHUtFPK8Hch/bKTKq+NlyYQX7an0QAAsgzahtRVRW+Ce/0NDPZOXkvqvm6moMyM0mMMAPCd+oa1M1ry0wurVWB7ZfaHoZF7cs3NReC7V2dqxEYhmte4isHr6sFuARV6zszE1ZcNpfJGGw32ypVD/D0ln4L5WumNbwMXPSt2pk1ArBKK7YJ2fbzCGf2elGPX5AU8XW2Gl9o+3Lh8adahsLIAD6nV4kRBb2UVgHRiEfMi8brW8zt1D+4KbQdaNvxEyDcTxP+sydkJFRoh6lmFr1Uj0qi2NcCtzIM5N6ZeAMWsAuBd732LN3CCWEM+SixJkzXb3nX1KIiToFxLHi2n+NwxUW7lqWdRXL1IlEY2TehLWjqkdu3iSIkhRWR81jqIt7YsakUmByyf6M9evfuMLv/u5JaBH++5hR5LpyXlYVj/lFByqBH46UZaIBY/AswzbVOgvjXXbpRdIQZ2sB05d+Kgt7cmFuIUNi4sAT9PdqwCvXQSAcOl2KKrm0iPAkugSnfiCzwCYGnX8aNVJTFgoI1NY4GnS0KDzoLSlX54IjYymnsHYZIK6czMbcqxEF4BAr+TNowgQCJLEox02yZYn2qQh+c2KobtV8stcwQVtTz2UImGNn9pX+qzcWj+4hs0NxKrrnVMLzSYxLFk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Require that Live Update preserved devices are in singleton iommu_groups
during preservation (outgoing kernel) and retrieval (incoming kernel).

PCI devices preserved across Live Update will be allowed to perform
memory transactions throughout the Live Update. Thus IOMMU groups for
preserved devices must remain fixed. Since all current use cases for
Live Update are for PCI devices in singleton iommu_groups, require that
as a starting point. This avoids the complexity of needing to enforce
arbitrary iommu_group topologies while still allowing all current use
cases.

Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index bec7b3500057..a3dbe06650ff 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -75,6 +75,8 @@
  *
  *  * The device must not be a Physical Function (PF).
  *
+ *  * The device must be the only device in its IOMMU group.
+ *
  * Preservation Behavior
  * =====================
  *
@@ -105,6 +107,7 @@
 
 #include <linux/bsearch.h>
 #include <linux/io.h>
+#include <linux/iommu.h>
 #include <linux/kexec_handover.h>
 #include <linux/kho/abi/pci.h>
 #include <linux/liveupdate.h>
@@ -222,6 +225,31 @@ static void pci_ser_delete(struct pci_ser *ser, struct pci_dev *dev)
 	ser->nr_devices--;
 }
 
+static int count_devices(struct device *dev, void *__nr_devices)
+{
+	(*(int *)__nr_devices)++;
+	return 0;
+}
+
+static int pci_liveupdate_validate_iommu_group(struct pci_dev *dev)
+{
+	struct iommu_group *group;
+	int nr_devices = 0;
+
+	group = iommu_group_get(&dev->dev);
+	if (group) {
+		iommu_group_for_each_dev(group, &nr_devices, count_devices);
+		iommu_group_put(group);
+	}
+
+	if (nr_devices != 1) {
+		pci_warn(dev, "Live Update preserved devices must be in singleton iommu groups!");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int pci_liveupdate_preserve(struct pci_dev *dev)
 {
 	struct pci_dev_ser new = INIT_PCI_DEV_SER(dev);
@@ -232,6 +260,10 @@ int pci_liveupdate_preserve(struct pci_dev *dev)
 	if (dev->is_virtfn || dev->is_physfn)
 		return -EINVAL;
 
+	ret = pci_liveupdate_validate_iommu_group(dev);
+	if (ret)
+		return ret;
+
 	guard(mutex)(&pci_flb_outgoing_lock);
 
 	if (dev->liveupdate_outgoing)
@@ -357,7 +389,7 @@ int pci_liveupdate_retrieve(struct pci_dev *dev)
 	if (!dev->liveupdate_incoming)
 		return -EINVAL;
 
-	return 0;
+	return pci_liveupdate_validate_iommu_group(dev);
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_retrieve);
 
-- 
2.53.0.983.g0bb29b3bc5-goog


