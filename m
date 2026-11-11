Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7562606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:07:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=ZyNUBywD
Received: by kanga.kvack.org (Postfix)
	id E95866B05C4; Wed, 11 Nov 2026 18:07:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6C696B05C5; Wed, 11 Nov 2026 18:07:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5C516B05C6; Wed, 11 Nov 2026 18:07:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A51096B05C4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:07:19 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 356791A04D6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:07:19 +0000 (UTC)
X-FDA: 85424376198.16.3EFCEB6
Received: from pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.26.1.71])
	by imf11.hostedemail.com (Postfix) with ESMTP id C84E740006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:07:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ZyNUBywD;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf11.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3g1pMQLPHr98q1xN/NLmPJ71j1vnyryRJ4kaKPk0b8s=;
	b=0xrKw6zViQktuXEfwrfDcndRlX6AuyIsTpCtW307VvfC4+fO+CaWEVowbwi2HohSyDijM8
	9yHeW8yBofIaSIWi2worSibU8y09F8uuAs68X/n4EDSyShak7ddBv+rDrGbssZj619j4Pn
	7eycDdeDj7TdZRo6/eUVy7pabVeIhLM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ZyNUBywD;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf11.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.26.1.71 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438437;
	b=Ldd91qjkfCCfqPmmd79f5YlU1nb3fEWwzagTst5+lCV/F9eIauBubgEybJsjIb+27XV2sy
	yTo4qsDu7yx560KG/oK0872DQdNrL1XRDP/YbxZFLAqLOmxvJzWVKuvDcRunTGCY8t52Dc
	1m6bsi4NoQ1cLF+7x1mxa6HdX3hXLdg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438436; x=1825974436;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3g1pMQLPHr98q1xN/NLmPJ71j1vnyryRJ4kaKPk0b8s=;
  b=ZyNUBywDaSF4C2jU1N7vf7ONiLkyRZqNaYENrFqqJ1s0GYUvn/I9Rh+j
   ZbdijwJfbee7qJPXe4AZh1bfYXFf1f69Q5TUlL4zDUIOOJWu2esTD2cvo
   52rMUrdEvyPyaM+N+DkTwDYDc7h1xvbjsGmsTYKypE9GZ/14npwl8Dwmj
   KDta4iiCJcbGEsonza9fMPfO3fMUYuXFq+lH+ulwWyZ4CC/MtTmoZ79mh
   qGYfIdpzKko/1xigHXQykYVGiBfuGxWoagea475Vy7v9z09+b2OGbkUVY
   lEt7aqfnqJvOu9sfj0fHC7ni5ungm7YfEbqwXxOwwkQnBzkCKm/uii4aF
   g==;
X-CSE-ConnectionGUID: sdNAaQ/RS6uyQhwPPdvBaQ==
X-CSE-MsgGUID: 86yTFcSKS86ncNlQuzZReA==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33789722"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-006.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:07:13 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.48:6522]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.31.142:2525] with esmtp (Farcaster)
 id 299b9647-441f-4247-a855-65df5f6a012d; Wed, 11 Nov 2026 23:07:12 +0000 (UTC)
X-Farcaster-Flow-ID: 299b9647-441f-4247-a855-65df5f6a012d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:07:12 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:07:09 +0000
From: Alexander Graf <graf@amazon.com>
To: <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>
CC: The AWS Nitro Enclaves Team <aws-nitro-enclaves-devel@amazon.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy
	<robin.murphy@arm.com>, <linux-doc@vger.kernel.org>, <iommu@lists.linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Mike Rapoport <rppt@kernel.org>,
	<nh-open-source@amazon.com>, <linux-mm@kvack.org>, Jonathan Corbet
	<corbet@lwn.net>
Subject: [PATCH 28/40] nitro_enclaves: Add NE_SET_NOTIFY_EVENTFD
Date: Wed, 11 Nov 2026 22:59:32 +0000
Message-ID: <9db6d42bdf77370c94a86d4098bbd6a71dcc1e7d.1794393491.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C84E740006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: omw87eozotjj4by7qgsuqad643mzdwup
X-HE-Tag: 1794438436-606388
X-HE-Meta: U2FsdGVkX18m+IlH50AoRUe3gk3SowyH3WZMDZPpaV5F4n3unpiW4Tsg97Y6Vs/J2hmp5pWfL0WyIxyfWqor4hCZiu7wWG+N0LgciWvzahiO5qQLK/xLNCQm6YCCJNVjyP9eDbgS+fIUQ65L0nMu09nE9x4HizNfdr0n74oeNVdYDwuETuZfxHnrTo3oHuVEofDZqrl5l0r/zlGEKQUKmPXbC+gcVcrcK+RPlCdk8BCwAyiXrLhXqCXibxGMFE+JToz70b1I2cv7LdqJdhNTuggDywFJkyEtECjKhwI8jzDh5NhYpOGbv+87skwyI9nbXEOnAsnglPGufjOh+fftnUd2p1Uazj+q0Dcyp2rIv3Bzb3JAYPPNLxfymiXxV62xauGo7/5o2u+9zSldUmH41DRvahCj/dwtTejIgN8xz2PrB5I9Odn9pN3auIoxnP0+/H6171tOK5SZsOxECsUC4wkFvLaWao4++XOoViGDSAwRBZr2fmhv41LxE7OHBS3l52i3Hw9wIOuACRegwIkEgT82edsKYQfl6y9M/IPW9oWBUcqt2sSErHifZKzsugXJNtyXeDbJrILHZ11/SSREtg4QaUr+ASnVlx8Vr4Gx0PqemYD2GpO+G5KMa/+XwJNpIzpKCl5vy2DwOAR8QmBPcKph82hAFWvBI1Xdk1CpKuvDhLijuJf5FvYwARLBHhyfe3+IotT32oM1MG/nR7tKsllizfyRr8sDqUQPh85sfu71dq/+DEGi63uHBSyyhVbd3eui3wtwaxHQX0LyQGKGL7Klu4RfG6jhxuEgZ4Ez4cG7LTOHhbQZoSn+3MzO2eqA+AMUHUbxzK4KEJv6xgu7nGyLY8B29wwqjqsMJ5kccHf/cSaxN0mGRTUXQBeSJbAX2/21t74FA9KXVmYsYuxzreY6sYDSuHW4EKj/XksHRoyENOqddp2mBixda+QIRHpi4PqEzC9bKJuVC5OyNYv
 dMPPhLKQ
 ABgCT7P0fwjbmB5Dwf3VTf4LPIW1k1MoowIIxPrfT/I0X1mhybmc+vZRBGB/cCUnFu83gc3Dd6V6b48MYptSLZwy9WGueXE7wt4oNzoFGx1kFPZ5i2ZoxUgCNtuE+FzhtyWxGJboZnCQyPN+iFXY3Uku2JDzDzYKiUDN7Amy7PTAsggS34yLQicRUuIFLv4CakTDKEg867XUb7MsUFgPTo0Zxh9WjCkfwFM3Jx0/wgMtM0cyyzHfE5IyNuhMEKdoFXvA3S+Os3JwAQhFSBkAtg527Ojl4eQEO0WPSs/VKn39qPz77Za1CJxlkMB9Ib6S98ps+6RxBKOIdlLM6HvPeYg/G7uyXubwImOsIOGiEBEY30rkQJJjaCyANi0qxI9p+0t3jEJ0c+5aG31ghWYrJMIUjKxqFN88PEiUGiSuJmef2NN/YIAYTck5FDDcfhl5OdnNHNoO5T9/fxUWIBxCe2lc4s4YIg8VvxMlI2H3Vrokhv4fxkIZ3DkDI41CHTxYN32HgnnOMfFn9CmVdrRBPmNvYgDb/nsCvTBnhbYcKinXioAAw50+wX9U8iLfOQlh8CfYcmrQesoWSQrz22q6daoOsQvS8ICIsohLUCo+CTG8LPnxmBYQ6bZGLsh98Vh1Ca2jWgRO17wLcGL8hKMIPyPndb6Df6RjsnLXTXXjpYb/T2gXN7FE9Kfk2S8SEAWPqxZwU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Nitro Sandboxes notify the parent through the interrupt multiplexer
when a sandbox kicks a virtqueue, so that the device backend in the
parent can wait for work on its queues on an eventfd.

Add NE_SET_NOTIFY_EVENTFD on the enclave fd. It binds an eventfd to the
notify index of a queue, and the multiplexer handler signals it on a
kick. Binding again replaces the eventfd and NE_EVENTFD_UNBIND removes
it. A bind delivers a kick that was already pending, and an unbind drops
one, so that the next owner of the index does not get it. A notify index
is device-wide, so a bind only takes the indices NE_ADD_DEVICE reported
to the same enclave.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/Kconfig       |   1 +
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 418 ++++++++++++++++++++++
 drivers/virt/nitro_enclaves/ne_misc_dev.h |  31 ++
 drivers/virt/nitro_enclaves/ne_pci_dev.c  |  41 ++-
 include/uapi/linux/nitro_enclaves.h       |  66 ++++
 5 files changed, 547 insertions(+), 10 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/Kconfig b/drivers/virt/nitro_enclaves/Kconfig
index 7b2456cdbb9fb..c78a5c654a241 100644
--- a/drivers/virt/nitro_enclaves/Kconfig
+++ b/drivers/virt/nitro_enclaves/Kconfig
@@ -10,6 +10,7 @@ config NITRO_ENCLAVES
 	depends on (ARM64 || X86) && HOTPLUG_CPU && PCI && SMP
 	select CMA
 	select DMA_CMA
+	select EVENTFD
 	help
 	  This driver consists of support for enclave lifetime management
 	  for Nitro Enclaves (NE).
diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 7698c7210eb86..bc78580bad475 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/anon_inodes.h>
+#include <linux/bitops.h>
 #include <linux/bsearch.h>
 #include <linux/build_bug.h>
 #include <linux/capability.h>
@@ -17,6 +18,7 @@
 #include <linux/cpumask.h>
 #include <linux/device.h>
 #include <linux/dma-map-ops.h>
+#include <linux/eventfd.h>
 #include <linux/file.h>
 #include <linux/fs.h>
 #include <linux/highmem.h>
@@ -48,6 +50,7 @@
 #include <linux/types.h>
 #include <linux/uaccess.h>
 #include <linux/uio.h>
+#include <linux/xarray.h>
 #include <uapi/linux/vm_sockets.h>
 
 #include "ne_misc_dev.h"
@@ -1773,6 +1776,357 @@ static int ne_start_enclave_ioctl(struct ne_enclave *ne_enclave,
 	return 0;
 }
 
+/**
+ * ne_mux_drop_bit() - Take the bit of an enclave queue out of the bitmap of its
+ *		       pooled vector.
+ * @ne_pci_dev:		Private data associated with the PCI device.
+ * @notify_index:	Notify index of the queue whose bit to take out.
+ *
+ * The handler leaves a bit it finds no binding for set, so that a bind can take
+ * it and deliver the kick it stands for. Once the binding is gone, the bind
+ * that bit was waiting for has already happened, and the next bind of the index
+ * belongs to whoever holds the queue by then, so leaving the bit would hand one
+ * caller's kick to another. It also costs every later interrupt on the vector a
+ * lookup for a bit nothing will claim. Take it out.
+ *
+ * The caller takes the binding out of the xarray first, so at this point no
+ * binding for the index is left to look up, and the kick this destroys is one
+ * no later scan could have delivered. In the other order a kick the device
+ * recorded in between would be left with a live binding and no interrupt of
+ * its own still to come.
+ *
+ * A kick the enclave raises between the two is dropped. It is a kick that
+ * arrived as its caller stopped listening, so the ioctl documentation says a
+ * release leaves a later bind of the index no kick to collect.
+ *
+ * Context: Process context.
+ */
+static void ne_mux_drop_bit(struct ne_pci_dev *ne_pci_dev, u32 notify_index)
+{
+	u32 nr_vecs = 0;
+	u32 vec_rel = 0;
+	u32 bit = 0;
+
+	/*
+	 * ne_mux_teardown() sets the pool size back to zero, so take the size
+	 * once and do the arithmetic on that copy, as a bind does. Reading the
+	 * field again below would divide by whatever it holds by then.
+	 */
+	nr_vecs = READ_ONCE(ne_pci_dev->mux_nr_vecs);
+	if (!nr_vecs)
+		return;
+
+	vec_rel = notify_index % nr_vecs;
+	bit = notify_index / nr_vecs;
+	if (bit >= NE_MUX_MAX_BITS)
+		return;
+
+	if (!ne_pci_dev->mux || !ne_pci_dev->mux[vec_rel].bitmap)
+		return;
+
+	clear_bit(bit, (unsigned long *)ne_pci_dev->mux[vec_rel].bitmap);
+}
+
+/**
+ * ne_del_notify_eventfd() - Release the eventfd bound to the interrupt of an
+ *			     enclave queue.
+ * @ne_enclave :	Private data associated with the current enclave.
+ * @ne_pci_dev:		Private data associated with the PCI device, taken by
+ *			the caller so that the release runs on the device the
+ *			caller looked the enclave up on.
+ * @notify_index:	Notify index of the queue to release.
+ *
+ * Context: Process context.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
+static int ne_del_notify_eventfd(struct ne_enclave *ne_enclave,
+				 struct ne_pci_dev *ne_pci_dev, u32 notify_index)
+{
+	struct ne_notify_binding *notify_binding = NULL;
+	struct ne_mux_binding *binding = NULL;
+	struct ne_notify_binding *entry = NULL;
+	int rc;
+
+	rc = mutex_lock_killable(&ne_enclave->enclave_info_mutex);
+	if (rc)
+		return rc;
+
+	list_for_each_entry(entry, &ne_enclave->notify_bindings,
+			    notify_binding_list_entry) {
+		if (entry->notify_index == notify_index) {
+			notify_binding = entry;
+
+			break;
+		}
+	}
+
+	if (!notify_binding) {
+		mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+		return -ENOENT;
+	}
+
+	binding = xa_erase(&ne_pci_dev->notify_xa, notify_index);
+	if (binding) {
+		/*
+		 * A handler that looked the binding up before the erase can
+		 * take the bit after it and then look the index up again. A
+		 * bind of the index can run as soon as the unbind returns, so
+		 * wait for that handler first. Otherwise its second lookup
+		 * finds the new binding and signals a kick the unbind drops.
+		 */
+		synchronize_rcu();
+
+		ne_mux_binding_free_rcu(binding);
+	}
+
+	ne_mux_drop_bit(ne_pci_dev, notify_index);
+
+	list_del(&notify_binding->notify_binding_list_entry);
+
+	mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+	kfree(notify_binding);
+
+	return 0;
+}
+
+/**
+ * ne_enclave_owns_notify() - Check that NE_ADD_DEVICE reported a notify index
+ *			      to an enclave.
+ * @ne_enclave :	Private data associated with the current enclave.
+ * @notify_index:	Notify index to look for.
+ *
+ * Context: Process context. This function is called with the ne_enclave mutex
+ *	    held.
+ * Return: true if one of the enclave's devices has the notify index.
+ */
+static bool ne_enclave_owns_notify(struct ne_enclave *ne_enclave,
+				   u32 notify_index)
+{
+	struct ne_device_wiring *dev = NULL;
+	unsigned int i = 0;
+
+	list_for_each_entry(dev, &ne_enclave->devices, list_entry)
+		for (i = 0; i < dev->num_vqs; i++)
+			if (dev->notify_index[i] == notify_index)
+				return true;
+
+	return false;
+}
+
+/**
+ * ne_set_notify_eventfd() - Bind an eventfd to the interrupt of an enclave
+ *			     queue.
+ * @ne_enclave :	Private data associated with the current enclave.
+ * @notify:		The eventfd and the notify index.
+ *
+ * Context: Process context.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
+static int ne_set_notify_eventfd(struct ne_enclave *ne_enclave,
+				 struct ne_notify_eventfd *notify)
+{
+	struct ne_pci_dev *ne_pci_dev = ne_devs.ne_pci_dev;
+	struct ne_notify_binding *notify_binding = NULL;
+	struct ne_mux_binding *binding = NULL;
+	struct ne_notify_binding *entry = NULL;
+	struct ne_mux_binding *old = NULL;
+	struct eventfd_ctx *ctx = NULL;
+	bool rebind = false;
+	u32 nr_vecs = 0;
+	u32 max_bit = 0;
+	int rc = -EINVAL;
+	u32 vec_rel = 0;
+	u32 bit = 0;
+
+	/*
+	 * ne_mux_teardown() sets the pool size back to zero, so take the size
+	 * once and do the arithmetic on that copy. Reading the field again
+	 * below would divide by whatever it holds by then.
+	 */
+	nr_vecs = READ_ONCE(ne_pci_dev->mux_nr_vecs);
+	if (!nr_vecs)
+		return -EINVAL;
+
+	vec_rel = notify->notify_index % nr_vecs;
+	bit = notify->notify_index / nr_vecs;
+	if (bit >= NE_MUX_MAX_BITS)
+		return -EINVAL;
+
+	if (notify->fd == NE_EVENTFD_UNBIND)
+		return ne_del_notify_eventfd(ne_enclave, ne_pci_dev,
+					     notify->notify_index);
+
+	ctx = eventfd_ctx_fdget(notify->fd);
+	if (IS_ERR(ctx))
+		return PTR_ERR(ctx);
+
+	binding = kzalloc_obj(*binding);
+	if (!binding) {
+		rc = -ENOMEM;
+
+		goto put_ctx;
+	}
+
+	binding->ctx = ctx;
+
+	notify_binding = kzalloc_obj(*notify_binding);
+	if (!notify_binding) {
+		rc = -ENOMEM;
+
+		goto free_binding;
+	}
+
+	notify_binding->notify_index = notify->notify_index;
+
+	rc = mutex_lock_killable(&ne_enclave->enclave_info_mutex);
+	if (rc)
+		goto free_notify_binding;
+
+	/*
+	 * A notify index names a notification across the whole NE PCI device,
+	 * so an enclave only binds the ones NE_ADD_DEVICE reported to it.
+	 */
+	if (!ne_enclave_owns_notify(ne_enclave, notify->notify_index)) {
+		rc = -EINVAL;
+
+		goto unlock_mutex;
+	}
+
+	list_for_each_entry(entry, &ne_enclave->notify_bindings,
+			    notify_binding_list_entry) {
+		if (entry->notify_index == notify->notify_index) {
+			rebind = true;
+
+			break;
+		}
+	}
+
+	if (rebind) {
+		/*
+		 * This enclave owns the notify index and, by the invariant the
+		 * fresh bind below upholds, is the only owner of its xarray
+		 * entry, so the entry that comes back is the binding it set
+		 * last time.
+		 */
+		old = xa_store(&ne_pci_dev->notify_xa, notify->notify_index, binding,
+			       GFP_KERNEL);
+		if (xa_is_err(old)) {
+			rc = xa_err(old);
+
+			goto unlock_mutex;
+		}
+
+		if (old)
+			ne_mux_binding_free_rcu(old);
+
+		kfree(notify_binding);
+	} else {
+		/*
+		 * Bind against an empty entry so that an enclave which asks
+		 * for a notify index another one still owns leaves that owner's
+		 * eventfd in place.
+		 */
+		old = xa_cmpxchg(&ne_pci_dev->notify_xa, notify->notify_index, NULL,
+				 binding, GFP_KERNEL);
+		if (xa_is_err(old)) {
+			rc = xa_err(old);
+
+			goto unlock_mutex;
+		}
+
+		if (old) {
+			rc = -EEXIST;
+
+			goto unlock_mutex;
+		}
+
+		list_add(&notify_binding->notify_binding_list_entry,
+			 &ne_enclave->notify_bindings);
+	}
+
+	/*
+	 * Raise the scan bound of the vector the queue shares. Enclaves bind
+	 * under their own mutex, so two of them can reach the same vector at
+	 * once and a plain read-modify-write would lose a raise and with it a
+	 * queue kick.
+	 */
+	max_bit = READ_ONCE(ne_pci_dev->mux[vec_rel].max_bit);
+	while (bit > max_bit)
+		if (try_cmpxchg(&ne_pci_dev->mux[vec_rel].max_bit, &max_bit,
+				bit))
+			break;
+
+	/*
+	 * The device may have set the bit of this queue before there was a
+	 * binding to deliver it on, and the handler leaves a bit it has no
+	 * binding for set, so that bit is still there to be taken. Take it
+	 * here, after the binding is in the xarray so that a handler taking it
+	 * instead of this path finds the binding, and after the raise above so
+	 * that such a handler reaches the word the bit is in. The handler takes
+	 * a bit with an atomic read-modify-write on the same word, so exactly
+	 * one of the two consumes it. The bitmap words are the width the device
+	 * writes them in, which is the width the bit numbering of the handler
+	 * is in as well.
+	 */
+	if (test_and_clear_bit(bit, (unsigned long *)ne_pci_dev->mux[vec_rel].bitmap))
+		eventfd_signal(binding->ctx);
+
+	mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+	return 0;
+
+unlock_mutex:
+	mutex_unlock(&ne_enclave->enclave_info_mutex);
+free_notify_binding:
+	kfree(notify_binding);
+free_binding:
+	kfree(binding);
+put_ctx:
+	eventfd_ctx_put(ctx);
+
+	return rc;
+}
+
+/**
+ * ne_enclave_remove_all_notify_binding_entries() - Remove all the enclave queue
+ *						    bindings from the device
+ *						    wide bindings xarray.
+ * @ne_enclave :	Private data associated with the current enclave.
+ * @ne_pci_dev:		Private data associated with the PCI device, taken by
+ *			the caller so that the removal runs on the device the
+ *			caller looked the enclave up on.
+ *
+ * Context: Process context. This function is called with the enclave
+ *	    information mutex held.
+ */
+static void ne_enclave_remove_all_notify_binding_entries(struct ne_enclave *ne_enclave,
+							 struct ne_pci_dev *ne_pci_dev)
+{
+	struct ne_notify_binding *notify_binding = NULL;
+	struct ne_notify_binding *notify_binding_tmp = NULL;
+	struct ne_mux_binding *binding = NULL;
+
+	list_for_each_entry_safe(notify_binding, notify_binding_tmp,
+				 &ne_enclave->notify_bindings,
+				 notify_binding_list_entry) {
+		binding = xa_erase(&ne_pci_dev->notify_xa, notify_binding->notify_index);
+		if (binding)
+			ne_mux_binding_free_rcu(binding);
+
+		ne_mux_drop_bit(ne_pci_dev, notify_binding->notify_index);
+
+		list_del(&notify_binding->notify_binding_list_entry);
+
+		kfree(notify_binding);
+	}
+}
+
 /**
  * ne_enclave_do_ioctl() - Ioctl function provided by the enclave file.
  * @file:	File associated with this ioctl function.
@@ -2230,6 +2584,22 @@ static long ne_enclave_do_ioctl(struct file *file, unsigned int cmd, unsigned lo
 		return 0;
 	}
 
+	case NE_EA_IOCTL(NE_SET_NOTIFY_EVENTFD): {
+		struct ne_notify_eventfd __user *uargs = (void __user *)arg;
+		unsigned int usize = _IOC_SIZE(cmd);
+		struct ne_notify_eventfd args;
+		int rc;
+
+		if (usize < offsetofend(struct ne_notify_eventfd, notify_index))
+			return -EINVAL;
+
+		rc = copy_struct_from_user(&args, sizeof(args), uargs, usize);
+		if (rc)
+			return rc;
+
+		return ne_set_notify_eventfd(ne_enclave, &args);
+	}
+
 	default:
 		return -ENOTTY;
 	}
@@ -2415,6 +2785,27 @@ int ne_enclave_free_slot(struct ne_pci_dev *ne_pci_dev,
 	rc = ne_do_request(pdev, ENCLAVE_STOP,
 			   &enclave_stop_request, sizeof(enclave_stop_request),
 			   &cmd_reply, sizeof(cmd_reply));
+
+	/*
+	 * The notify index of a queue belongs to the slot, so the device is free
+	 * to give it to another enclave once the slot is freed. Take the
+	 * bindings of this enclave out of the xarray the handler looks them up
+	 * in before that, or a bind for the reissued index finds the entry
+	 * still taken. This happens whether or not the stop went through,
+	 * because an unbind of the device tears the multiplexer down next.
+	 *
+	 * A handler that looked up a binding of this enclave before it was
+	 * erased here can still be running. Were the index reissued under it,
+	 * it would take the bit of a notification the device raises for the
+	 * next owner and signal this enclave's eventfd instead, so wait for it
+	 * before the slot goes.
+	 */
+	if (!list_empty(&ne_enclave->notify_bindings)) {
+		ne_enclave_remove_all_notify_binding_entries(ne_enclave, ne_pci_dev);
+
+		synchronize_rcu();
+	}
+
 	if (rc < 0)
 		return rc;
 
@@ -2437,6 +2828,9 @@ int ne_enclave_free_slot(struct ne_pci_dev *ne_pci_dev,
  */
 static void ne_enclave_free(struct ne_enclave *ne_enclave)
 {
+	struct ne_device_wiring *dev_tmp = NULL;
+	struct ne_device_wiring *dev = NULL;
+
 	ne_enclave_remove_all_contig_regions(&ne_enclave->contig_regions_list);
 	ne_enclave_remove_all_contig_regions(&ne_enclave->device_regions_list);
 	ne_enclave_remove_all_mem_region_entries(ne_enclave);
@@ -2445,6 +2839,9 @@ static void ne_enclave_free(struct ne_enclave *ne_enclave)
 	if (ne_enclave->info_file)
 		fput(ne_enclave->info_file);
 
+	list_for_each_entry_safe(dev, dev_tmp, &ne_enclave->devices, list_entry)
+		kfree(dev);
+
 	kfree(ne_enclave);
 }
 
@@ -2686,6 +3083,8 @@ static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 flags,
 
 	init_waitqueue_head(&ne_enclave->eventq);
 	ne_enclave->has_event = false;
+	INIT_LIST_HEAD(&ne_enclave->notify_bindings);
+	INIT_LIST_HEAD(&ne_enclave->devices);
 	mutex_init(&ne_enclave->enclave_info_mutex);
 	ne_enclave->max_mem_regions = cmd_reply.alloc.mem_regions;
 	INIT_LIST_HEAD(&ne_enclave->contig_regions_list);
@@ -4255,6 +4654,7 @@ static int ne_add_device_ioctl(struct ne_enclave *ne_enclave,
 	struct ne_shm_region *shm_regions = NULL;
 	const struct ne_vq_wiring *wiring = NULL;
 	struct slot_add_device_req *req = NULL;
+	struct ne_device_wiring *dev = NULL;
 	struct ne_contig_mem *info = NULL;
 	LIST_HEAD(regions);
 	u8 buf[NE_MAX_VQS * sizeof(struct ne_vq_wiring)];
@@ -4346,6 +4746,17 @@ static int ne_add_device_ioctl(struct ne_enclave *ne_enclave,
 		goto free;
 	}
 
+	/*
+	 * Allocate the record of what the device reports before it is told
+	 * about the device, so that nothing can fail once it has been.
+	 */
+	dev = kzalloc_obj(*dev);
+	if (!dev) {
+		rc = -ENOMEM;
+
+		goto free;
+	}
+
 	for (i = 0; i < args->num_shm_regions; i++) {
 		rc = ne_add_device_region(ne_enclave, &shm_regions[i], req,
 					  &regions);
@@ -4438,10 +4849,16 @@ static int ne_add_device_ioctl(struct ne_enclave *ne_enclave,
 		args->vq_info[i].notify_index = wiring[i].notify_index;
 		args->vq_info[i].msix_entry = wiring[i].msix_entry;
 		args->vq_info[i].doorbell_offset = wiring[i].doorbell_offset;
+
+		dev->notify_index[i] = wiring[i].notify_index;
 	}
 
 	args->device_uid = cmd_reply.add_device.device_uid;
 
+	dev->num_vqs = args->num_vqs;
+	list_add(&dev->list_entry, &ne_enclave->devices);
+	dev = NULL;
+
 	rc = 0;
 
 free:
@@ -4452,6 +4869,7 @@ static int ne_add_device_ioctl(struct ne_enclave *ne_enclave,
 	 * the enclave, leaving nothing here.
 	 */
 	ne_enclave_remove_all_contig_regions(&regions);
+	kfree(dev);
 	kfree(req);
 	kfree(shm_regions);
 
diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.h b/drivers/virt/nitro_enclaves/ne_misc_dev.h
index 4f695f1410aec..57e20fe3ee1da 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.h
@@ -112,6 +112,29 @@ struct ne_mem_region {
 	u64			userspace_addr;
 };
 
+/**
+ * struct ne_device_wiring - What %NE_ADD_DEVICE reported for one device of an
+ *			     enclave.
+ * @list_entry:		Entry in the list of the enclave's devices.
+ * @num_vqs:		Number of entries of @notify_index.
+ * @notify_index:	Notify index of each virtqueue of the device.
+ */
+struct ne_device_wiring {
+	struct list_head	list_entry;
+	u32			num_vqs;
+	u32			notify_index[NE_MAX_VQS_PER_DEVICE];
+};
+
+/**
+ * struct ne_notify_binding - Entry in the list of enclave virtqueue bindings.
+ * @notify_binding_list_entry:	Entry in the list of enclave queue bindings.
+ * @notify_index:		Notify index of the bound queue.
+ */
+struct ne_notify_binding {
+	struct list_head	notify_binding_list_entry;
+	unsigned long		notify_index;
+};
+
 /**
  * struct ne_enclave - Per-enclave data used for enclave lifetime management.
  * @enclave_info_mutex :	Mutex for accessing this internal state.
@@ -139,6 +162,12 @@ struct ne_mem_region {
  *				so that the device keeps the page after user space
  *				has closed the descriptor. NULL until
  *				%NE_SET_INFO_PAGE is called.
+ * @notify_bindings:		List of the virtqueues this enclave has bound an
+ *				eventfd to.
+ * @devices:			List of struct ne_device_wiring, one for each device
+ *				%NE_ADD_DEVICE gave the enclave. The notify indices
+ *				in it are the only ones the enclave may bind an
+ *				eventfd to.
  * @max_mem_regions:		The maximum number of memory regions that can be
  *				handled by the hypervisor.
  * @mem_regions_list:		Enclave user space memory regions list.
@@ -172,6 +201,8 @@ struct ne_enclave {
 	bool			has_event;
 	u64			id;
 	struct file		*info_file;
+	struct list_head	notify_bindings;
+	struct list_head	devices;
 	u64			max_mem_regions;
 	struct list_head	mem_regions_list;
 	u64			mem_size;
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index de96d68906bbf..a079abb2b4618 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -580,12 +580,15 @@ void ne_mux_binding_free_rcu(struct ne_mux_binding *binding)
  *		   has a binding for.
  * @mux_vec:	Multiplexer state of the pooled vector.
  *
- * A bit leaves the bitmap by the same atomic read-modify-write that decides to
- * deliver it, so a bit this vector has no binding for stays set. It is left set
- * on purpose: a queue can be kicked before user space has bound an eventfd to
- * it, and a bit taken out of the bitmap on the strength of a binding that is not
+ * A bit is delivered by an atomic read-modify-write that clears it as it reads
+ * it, so a bit this vector has no binding for stays set. It is left set on
+ * purpose: a queue can be kicked before user space has bound an eventfd to it,
+ * and a bit taken out of the bitmap on the strength of a binding that is not
  * there yet is a kick nobody can ever be told about. The bit waits instead, and
- * the bind of that queue takes it and delivers it.
+ * the bind of that queue takes it and delivers it. A bit is cleared without
+ * being delivered only for an index whose binding has just been erased: by
+ * ne_mux_drop_bit(), or by a scan that took the bit and then found the binding
+ * gone.
  *
  * So a set bit is consumed at most once, and exactly once if a scan finds a
  * binding for it or a bind for its index runs. A bit whose index is never bound
@@ -598,8 +601,8 @@ void ne_mux_binding_free_rcu(struct ne_mux_binding *binding)
  *
  * Context: Interrupt context. Called with the RCU read-side held.
  * Return:
- * * true if the scan found no bit it could deliver, false if it found at least
- *   one.
+ * * true if the scan found no set bit with a binding, false if it found at
+ *   least one.
  */
 static bool ne_mux_scan(struct ne_mux_vec *mux_vec)
 {
@@ -626,8 +629,26 @@ static bool ne_mux_scan(struct ne_mux_vec *mux_vec)
 
 			empty = false;
 
-			if (test_and_clear_bit(bit, (unsigned long *)mux_vec->bitmap))
-				eventfd_signal(binding->ctx);
+			if (!test_and_clear_bit(bit, (unsigned long *)mux_vec->bitmap))
+				continue;
+
+			/*
+			 * A rebind can replace the binding between the load above
+			 * and the bit taken here. The rebind stores its binding
+			 * before it tries to take the bit, and test_and_clear_bit()
+			 * is fully ordered on both sides, also when it finds the bit
+			 * clear, so a bit taken here after that attempt sees the new
+			 * binding. Load it again and signal the binding that load
+			 * returns, or drop the kick if the entry is gone. An unbind
+			 * waits for this handler before the index can be bound
+			 * again, so this load never returns a binding made after
+			 * the unbind.
+			 */
+			binding = xa_load(&ne_pci_dev->notify_xa, notify_index);
+			if (!binding)
+				continue;
+
+			eventfd_signal(binding->ctx);
 		}
 	}
 
@@ -661,7 +682,7 @@ static irqreturn_t ne_mux_handler(int irq, void *data)
 	 * whatever the bitmap holds, so such a bit has an interrupt of its own
 	 * still to come and reaches its eventfd on that one. Scanning again,
 	 * reading the bound again, delivers it on this interrupt instead, so stop
-	 * on the first scan that delivers nothing. Stopping on an empty bitmap
+	 * on the first scan that finds no bound bit. Stopping on an empty bitmap
 	 * instead would wait for a read a bit no bind is coming for never gives.
 	 * NE_MUX_MAX_PASSES caps the scans either way, so a device that goes on
 	 * setting bits cannot hold the handler.
diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
index 6f83a8b0762b3..ff1b32e380e7b 100644
--- a/include/uapi/linux/nitro_enclaves.h
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -1061,4 +1061,70 @@ struct ne_enclave_start_info {
 	__u64	enclave_cid;
 };
 
+/**
+ * NE_EVENTFD_UNBIND - Value of an eventfd field that releases the binding the
+ *		       caller holds, instead of naming an eventfd to bind. A kick
+ *		       the enclave raises as the release lands is dropped, so a
+ *		       caller that binds the queue again gets no signal for it.
+ *		       Any other negative value names no open file and is an
+ *		       error.
+ */
+#define NE_EVENTFD_UNBIND		(-1)
+
+/**
+ * NE_SET_NOTIFY_EVENTFD - The command is used to bind an eventfd to the
+ *			   interrupt of one enclave virtqueue. When the enclave
+ *			   kicks the queue, the NE PCI device raises the
+ *			   interrupt the queue shares and the driver signals the
+ *			   eventfd. A queue the caller has already bound is
+ *			   rebound to the new eventfd, and the driver drops its
+ *			   reference on the one it replaces. A kick that is
+ *			   already being delivered when the rebind lands is
+ *			   signalled on the outgoing eventfd, so a caller that
+ *			   rebinds a queue an enclave is still kicking can see
+ *			   one last kick arrive on the eventfd it replaced.
+ *			   %NE_EVENTFD_UNBIND
+ *			   releases the binding the caller holds on the queue.
+ *			   The ioctl can be invoked on the enclave fd.
+ *
+ * Context: Process context.
+ * Return:
+ * * 0					- Logic successfully completed.
+ * * -1					- There was a failure in the ioctl logic.
+ * On failure, errno is set to:
+ * * ENODEV				- The NE PCI device is not available.
+ * * EFAULT				- Argument read failure.
+ * * EINVAL				- The argument is shorter than @notify_index,
+ *					  the NE PCI device shares no interrupts,
+ *					  the notify index addresses a bit outside
+ *					  the bitmap page of the vector it shares,
+ *					  %NE_ADD_DEVICE did not report the notify
+ *					  index to this enclave, or the given fd is
+ *					  not an eventfd.
+ * * EBADF				- There is no open file for the given fd, which
+ *					  is the case for every negative fd other
+ *					  than %NE_EVENTFD_UNBIND.
+ * * E2BIG				- The argument is longer than this kernel knows
+ *					  about and the excess is not all zero.
+ * * ENOMEM				- Memory allocation failure.
+ * * EEXIST				- Another enclave holds a binding on the queue.
+ * * ENOENT				- The caller holds no binding on the queue to
+ *					  release.
+ */
+#define NE_SET_NOTIFY_EVENTFD		_IOW(0xAE, 0x28, struct ne_notify_eventfd)
+
+/**
+ * struct ne_notify_eventfd - Eventfd to signal on an enclave virtqueue kick
+ *			      (in).
+ * @fd:			Eventfd to signal when the queue is kicked, or
+ *			%NE_EVENTFD_UNBIND to release the binding on the
+ *			queue (in).
+ * @notify_index:	Index the enclave writes to notify the NE PCI device of
+ *			the virtqueue (in).
+ */
+struct ne_notify_eventfd {
+	__s32	fd;
+	__u32	notify_index;
+};
+
 #endif /* _UAPI_LINUX_NITRO_ENCLAVES_H_ */
-- 
2.47.1


