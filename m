Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 166BA60A6F53
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 22:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=TbFol5Tn
Received: by kanga.kvack.org (Postfix)
	id 03F986B0618; Wed, 18 Nov 2026 17:37:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F33076B0619; Wed, 18 Nov 2026 17:37:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E22146B061A; Wed, 18 Nov 2026 17:37:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 932976B0618
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:37:24 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0A496A0903
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:37:24 +0000 (UTC)
X-FDA: 85449702408.16.8125420
Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4B96B1A0003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:37:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TbFol5Tn;
	spf=pass (imf19.hostedemail.com: domain of 3oSj-aggKCEopym5xmows00sxq.o0yxuz69-yyw7mow.03s@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3oSj-aggKCEopym5xmows00sxq.o0yxuz69-yyw7mow.03s@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795041442;
	b=dUum1UlO59kW4G1Ccye4zMoSKPy0L56gbsnJW9G88bFJUruK8YJO76BM/mjKol8FeJ/vwC
	ZBsbAxzhmevQgqDzrQYJek5ybJ60lxio3D92Y9l5TL7QVDcsg1qjfhGtZqejMjNPwSUSop
	vae6FCwkwbqtjypLs2A386OUfCLv13w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795041442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HNkkfP2cevkFVfIGomWPdBlTDGkki6pISPgO29QlZFU=;
	b=GO6vE5dmsSgB/woxDmel86vgCy4q7FKTZQfEOgOZp+7NWLuHkivQHpnFzbk+4m3N/VMqvz
	su8TEnSI3wiB8ixNNVL2NhrDwzaLnbLMrYb7p9N41pszeSOa5IXqn8B4q6M9pwRCFwKPmh
	RmAcOjhtAirwUqK+MElosVLIYtJg4fQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=TbFol5Tn;
	spf=pass (imf19.hostedemail.com: domain of 3oSj-aggKCEopym5xmows00sxq.o0yxuz69-yyw7mow.03s@flex--dmatlack.bounces.google.com designates 209.85.167.199 as permitted sender) smtp.mailfrom=3oSj-aggKCEopym5xmows00sxq.o0yxuz69-yyw7mow.03s@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-5587351d419so1163869b6e.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:37:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795041441; x=1795646241; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HNkkfP2cevkFVfIGomWPdBlTDGkki6pISPgO29QlZFU=;
        b=TbFol5Tnz6TRXzvSAJtON2MfxhLLbvhnsDJ3EAbk+KJ5E5qJNOLXJx0Q7YwD8pacAs
         pu9z7RBybwedJs6mvUE8EsQapiHJNA+bml+8CFfM35TjoaZBH4CFbAiojTRWrWcT2fwf
         FnH0z7TufXyTL9I3fQgsc6PzVOUBQvKXT4LjzkVL1GcVk4e/K7YDCWgE+B6X6r6O1jyF
         gy/M0SEpYfUztMzBjcidvKxYiNV4bRIwBpujRv4qNH4CbkzSd+nNECrN7/chw9/FiVNu
         a2acmXWsE4jAo47JAJb26g7trK2rw0RxT/7eXVaqm9XrD4QXXk2h0gjsr5qzVEg7132S
         Srww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795041441; x=1795646241;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HNkkfP2cevkFVfIGomWPdBlTDGkki6pISPgO29QlZFU=;
        b=WSqi60X/Q73nt54YJfE87unLeXB4GiHun7QEE0KBhhZ1O22AkUncArhaISe2fxk5zY
         6RbyFFThtYWGDXOxbJzKwJVi5yrdlpHNlTGecNTA36XFKVG8Xuh3VIIJMfMTdFV5Hmvh
         0+OSlHb3cEclMKRz4xh8GrVNeINB+ndmz5/8zodNIFM6gSX3pVpVhJq42i/vNH5/LqlT
         gL4DmcUy45MlQOe8tQ/NYXEVq7j+m2AQU7ixAJTMq+OVuCNSEdkattkB5dosL3X2f34W
         FTGXaWV8Pbg31FMF3fy43Jhnl5BbYpNIoMaOyQfBX7F6uNXTfMw9FwbD7rCwIRzRBEIi
         WByA==
X-Forwarded-Encrypted: i=1; AL+hErGNfD5MHOVX1ADIK91P878dGltLBwGH2kFY+wW3dwDToMnTPMEtyGXqzv7h/W5Kz3ylRFIpIajcCg==@kvack.org
X-Gm-Message-State: APuU4Z8wqEuIsvXdJzpt/mGxvmK9gTpuVISQx3ZH8s9dtmyOHO3PXfye
	YSnzfSC5TiEbOS9206qEMXXS+LuiL1f1elHqafhqYMeZLf4P+g6m8YOiZfT9jB4jR7QfGsf45p/
	4qJQn55coERKe0w==
X-Received: from ilbek7-n2.prod.google.com ([2002:a05:6e02:4f07:20b0:549:da41:90bc])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:3385:b0:4c4:9f7e:92ce with SMTP id 5614622812f47-57741723d34mr4740022b6e.38.1795041441133;
 Wed, 18 Nov 2026 14:37:21 -0800 (PST)
Date: Wed, 18 Nov 2026 22:37:02 +0000
In-Reply-To: <20261118223704.3286085-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261118223704.3286085-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118223704.3286085-12-dmatlack@google.com>
Subject: [PATCH v11 11/13] PCI: liveupdate: Freeze preservation status during shutdown
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4B96B1A0003
X-Rspam-User:
X-Stat-Signature: yo8pbr4c4rznekfcnezhc1kp54m5sxkm
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795041442-907543
X-HE-Meta: U2FsdGVkX1+bl8dRXNA9WS7fbmAqXVEffrf6k3l6R42jBQtNvG2iOTBa+OGv+EDOaFOuWERsxQLrdFYrkDILNyqaFJKzyXT1xdKqAHQZNMW5Oxt9rX0t6rJXzTb2AN3n5arC/MEi2RZRDsYT9iPcH5sZRAtzPhs1vTw0nwXHOmpwOTglYy9d0lHZ7cbItthuqRUY94wvvtPONOfcfPCkaV+jp7YTK2NQAXip11/JmMYzWQ9UGDcGwtc2cr53X6I4dixKgOCQRYin5eAFsovlGma8XH33IQPS7Aod/dUHuaJnM8UF4dMqkRtEEtT9oIStKQVs1gFQ7qnPPdbu4HJQZGFwNwObU/GQ5Mo20CmyRuq005Nb5+P5pOvZzebmLA5DRf1SLCCimJMTFKYZY/kJxEm3bnasFBmNxwNlte159IHXjM6uF7yaFLj6ZgoXpzuocPzWlI9IaPqXmzui7NAMPyTMw+QKFmeqCi+24Yq+cViBwoCMTKkpXLjeZUoIBvd82hql0ttP/F6fUrkwWUvLcGhk/+/nyOuNgK2Syt8REMUQteOGg7iExm0W77oQPcKZn/fLUQzNll+hLsPHjnpky7RqMI+uVjipD3eZRqhQ1BxdBlah5tGW0xQZXSWVE+0/4qC71ucnjq0H2XUoKz26zI/4KY2d8/2OJQXXgYwkGY+EviR23+o76cwBoLOuH/2D74Ge9ExCMdqvLH4heNyaiyrBfLNnRFyUS5520ypvLc+VRvMW/M57BBxd91z8c0rQRO1zWyTnXoY+fO1z6SxwkzjLwnVn3+EhtKT620K2duIdmX4HPpklgq6uOC3slkLrVOZLvGz2Z25sYmZFlOe9kBCtbrU2G6V/rLo9RTrFyCZv+nCakp9FypGSGJbQu78GetbwMJTmoAY20oGOjlDEFkknMie9VsS/0BJZybntGqNqcHRl1u1UvXDFghPcLHKY6EB2+RZKETPp2pn6I/g
 Ey1Rj0DK
 OL3M2b81CWEC3n0o3+/x8m9M7oexXg2fzATDcqOvW6El8z5fdqZFhcIOPI4FFodjSf5XnOB67iXx+eofiVfe7BFkY2BqgNaLetcHHr1fzhkkXqTLyLyJqi9bUZ4zZ5Wgls5e+BXAyrv+IVpKT/knmH22cUBp21H4RT44szNovBGeko1aCkcjQXsl+VD3nM9ZhK4LSqEoYEut9uDvF21CLPEzj669NoffCyCBEDBJ9qKT/GXSwzvO6uS47nLm3CQu+Yt9hO7a6dWLjYbBLsVIfP9sfmyy+bdOfTWMOLKCjRFlN/qM0iZpVQyuvdfFXSAeGF2Q/IJolQ/MpGiqwwMBtQkqbapdPQPgQxEPf7a2tMpQqHOtb2rExbj9n+Q7bpqQhwsU1gg/+mDe390zTonIrES1ZPNXAaEeA/Zr/6O1Cqi+mCzL+3FOLRiP5gsgKsqMJ6H1FSkQ0S3N9qYU3LGTCPq3r62tx953eUb2i6brCJIaP4mpDPXebX0uZxg2gpuAa8LJpSY1kqXeugGanAjgh7lYQnDtwAc2T/lUyYMHbJzd4gc5osFBEmHQJiRf250rzIEgjwXRVfkkHhxxiz8rZfkq/tEcumKV3f6Y3/mijwXKyd86qFJOEx6fGFem19F5RsixN8eQeYFwyDxLNtnPasnzfkPNvfV6Syp0OqtZBr5497O86iO+WAuWh6exC1v7aq2gN3ioFFqZp6SspcZOoFO30Femk2GIYf9TXRdDSAi/ttoKvbw3mg7Qs/5wPzYZ4nPf+bWUjUSLLZBo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Freeze a device's outgoing preservation status (preserved or not
preserved) during shutdown. This enables the PCI core and drivers to
safely make decisions based on the device's preservation status during
shutdown.

The PCI core freezes every device in pci_device_shutdown(), not just
preserved ones, so that no device can be preserved or unpreserved after
its shutdown starts.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/liveupdate.c       | 19 +++++++++++++++++++
 drivers/pci/liveupdate.h       |  5 +++++
 drivers/pci/pci-driver.c       |  2 ++
 include/linux/pci_liveupdate.h |  3 +++
 4 files changed, 29 insertions(+)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index a45ad86370d5..e26d2f5c2338 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -126,6 +126,9 @@
  *  * The device cannot require device-specific quirks to enable Access
  *    Control Services (ACS).
  *
+ * In addition, a device cannot be preserved or unpreserved once the PCI core
+ * has started shutting it down (pci_device_shutdown()).
+ *
  * Driver Binding
  * ==============
  *
@@ -520,6 +523,11 @@ static int pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing,
 {
 	struct pci_dev_ser *dev_ser = dev->liveupdate.outgoing;
 
+	if (dev->liveupdate.frozen) {
+		pci_warn(dev, "Cannot unpreserve device after it is frozen!\n");
+		return -EINVAL;
+	}
+
 	if (!dev_ser) {
 		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
 		return -EINVAL;
@@ -569,6 +577,11 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
 		return -EINVAL;
 	}
 
+	if (dev->liveupdate.frozen) {
+		pci_warn(dev, "Cannot preserve device after it is frozen!\n");
+		return -EINVAL;
+	}
+
 	if (dev_ser) {
 		/*
 		 * Endpoint devices can only be preserved once. Bridges are
@@ -784,6 +797,12 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 		pci_WARN(dev, 1, "Destroying incoming-preserved device!\n");
 }
 
+void pci_liveupdate_freeze(struct pci_dev *dev)
+{
+	guard(rwsem_write)(&pci_liveupdate.rwsem);
+	dev->liveupdate.frozen = true;
+}
+
 static int pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *dev)
 {
 	if (!dev->liveupdate.incoming) {
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index e1c1d2fa00e4..03211dbebc7b 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -13,6 +13,7 @@
 #ifdef CONFIG_PCI_LIVEUPDATE
 void pci_liveupdate_setup_device(struct pci_dev *dev);
 void pci_liveupdate_cleanup_device(struct pci_dev *dev);
+void pci_liveupdate_freeze(struct pci_dev *dev);
 bool pci_liveupdate_preserve_bus_numbers(void);
 bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus, struct pci_dev *dev);
 int pci_liveupdate_adopt_acs(struct pci_dev *dev);
@@ -31,6 +32,10 @@ static inline void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 {
 }
 
+static inline void pci_liveupdate_freeze(struct pci_dev *dev)
+{
+}
+
 static inline bool pci_liveupdate_preserve_bus_numbers(void)
 {
 	return false;
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 7efe808cdf0c..8b11bd3dc5bc 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -21,6 +21,7 @@
 #include <linux/acpi.h>
 #include <linux/dma-map-ops.h>
 #include <linux/iommu.h>
+#include "liveupdate.h"
 #include "pci.h"
 #include "pcie/portdrv.h"
 
@@ -559,6 +560,7 @@ static void pci_device_shutdown(struct device *dev)
 	struct pci_dev *pci_dev = to_pci_dev(dev);
 	struct pci_driver *drv = pci_dev->driver;
 
+	pci_liveupdate_freeze(pci_dev);
 	pm_runtime_resume(dev);
 
 	if (drv && drv->shutdown)
diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
index d45a5b524909..bb79348769b7 100644
--- a/include/linux/pci_liveupdate.h
+++ b/include/linux/pci_liveupdate.h
@@ -21,11 +21,14 @@
  *                set up, i.e. it was matched to state preserved by the previous
  *                kernel. Unlike @incoming, this is never cleared, so it stays
  *                true after the device finishes participating in Live Update.
+ * @frozen: True if the outgoing preservation status of this device is frozen
+ *          and thus cannot be changed.
  */
 struct pci_liveupdate {
 	struct pci_dev_ser *outgoing;
 	struct pci_dev_ser *incoming;
 	bool was_incoming;
+	bool frozen;
 };
 
 struct pci_dev;
-- 
2.56.1.703.gf848ed807c-goog


