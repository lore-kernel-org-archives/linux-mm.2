Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB65606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=mjXniEWD
Received: by kanga.kvack.org (Postfix)
	id A4FFE6B05C6; Wed, 11 Nov 2026 18:07:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A00EC6B05C7; Wed, 11 Nov 2026 18:07:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 916F46B05C8; Wed, 11 Nov 2026 18:07:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5E5256B05C6
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:07:51 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D367CA049F
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:07:50 +0000 (UTC)
X-FDA: 85424377500.05.2F1F364
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	by imf21.hostedemail.com (Postfix) with ESMTP id 849F91C0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:07:48 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=mjXniEWD;
	spf=pass (imf21.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438468;
	b=B4Txx19gAIN0NK0SNuVippAeLTw0famK+o0p1ZM/B87AhcUs3O52OW55O0+5dLv547dTEy
	6DnKe7oeRpZk3IfazDapQv24r4GhO730mXTx1kB2ozWVZ3vg8j6W987vvcKrjIJrvbNVBg
	9UTJrAM5sp1zRxT2cERR0plLb91oQ3M=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=mjXniEWD;
	spf=pass (imf21.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YI+xwxK91yLq9AqwLK+2Jfov8Vn7uJsFM2qc/TcD+q8=;
	b=s3yyuKSHsXGHhYQE5xDXuVkXsXzsn2jAAFi6giO3u+qXBmkOQLWK3JqRCrdoB1WqZZ0fZN
	xOPQMU9pryeFttTtTrbzG2KrRroulv9d/ITqT4Ldap2uZ+Z+kHoHYiKH9z2DaYasR70tGY
	+CfPGZ5xR7TKsH/rGe9eTRJL/5J64Gw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438468; x=1825974468;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YI+xwxK91yLq9AqwLK+2Jfov8Vn7uJsFM2qc/TcD+q8=;
  b=mjXniEWDR8UDtUl+RmCnxJE33z7T11+AnRvYDO3roal03qf5am9G0YyD
   50PMC+xw+Nzno4Ao+4Qe6wy9iMYegAk3OIiP0M0Ryv04s0iw+Ts6/59sf
   gs2H1sHa6l9FIp3Pa9UYHwmpfxdxQexFv28EhO+6PK/9cTzvb8e4tbfh8
   Nc7NacCNRJHIiN0pZCTEPfil+Y6dLjjvgWx8gkq8V7HsHdAexBXVrVADt
   skXCUzKMYi8Bqno6HK58NEQMrRCyXY5EUdtY+EjwTP/MUe3jezazNvXuA
   KrSRKcGouyvLyLAyXCupH5vWcWPKm7Fg7g48vybRaH7+p5t+q1+v+lDx3
   g==;
X-CSE-ConnectionGUID: qC2rSK8SQC+u5HOmmrVYGw==
X-CSE-MsgGUID: 3XGB0BkJQbyBIvH0D6attw==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33533664"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:07:47 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:7122]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.34.255:2525] with esmtp (Farcaster)
 id 0f86f7d9-eb20-4b7e-8481-9bbbcb461490; Wed, 11 Nov 2026 23:07:47 +0000 (UTC)
X-Farcaster-Flow-ID: 0f86f7d9-eb20-4b7e-8481-9bbbcb461490
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:07:46 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:07:43 +0000
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
Subject: [PATCH 29/40] nitro_enclaves: Report the device's info notification
Date: Wed, 11 Nov 2026 22:59:33 +0000
Message-ID: <2c69a8916a5da01b8d857c366c1fc0253572750d.1794393491.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: nif1nukdf6nb9ww6hw1c3pqkzabw961d
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 849F91C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794438468-154907
X-HE-Meta: U2FsdGVkX18muErKOWIqQDX8fKsom3w/EhacHZjPDAWSEF+yxO/bTG+eFSZZbjY8OBrx2oeuivx6jzmP1t1BDOF71S46rGX6FxTdJHyD29C9nYXc5Nua0XbgGZRx8RrtLJE07NxNaoGVuLodkJEO8ZngxDOmfjwSJ4UsPnZj6cFbpMlL5li+XKH6Y6okjWVFNnRiYercMEU+ty9RO/CATXwwEYeN7VEPEioOZtmb/t8zEw9TNt5XwrZiYFkXG8hS67fdJXQ+WspGdD8DH6pqgasXzKUDMmqOFwMl96BU7u8K7QfUjoLqBuAtUj1Kt2yaeeL8HAxT0CczpqnByf0PoDuJfBcqlt/v3Zmck1URtJIv3F9eimMf0KW+r/Nrj3uZWwpC6Xi1a3SS4RTg+ehXdS8D2lQjQAlBlkf/EELarpVR6/Ga87fqF31xK2jjNHWUXNc3S0lWfFIN+S3cfnvIGEv+ql4b2EXJfHRBB/11hWL3TktMxzBdr+RGiVqP1H04S++oPwNWbx9rfTduGV75gpVHr7MiDAIBygBeAK0B/w2eG7mzgxBRCjTSbPlTrAug4mWQySQjLB+OyS38n3WutuhSDyrpFRtZXLhe5b+DtjIulDw9jxeuo+Y48yZ537m/n+EwLzxKMQXBAIeN689PcLMhkHhqMf0NrifguF1ynCgGNEArsbUgxbBJ3RlLs/lIduTDLGf0WKnbVrkUu93FyGPwjXiah1UB+dJp5nks4PvJro7OE7ENivgs9O9xrvqTkpm77v320IQtD8sOZYvYuC0qQ5uomcdxu90zRQkMbk52SH8KrtcAkWIpBcvXjrKO6yLCGvo3oHkR4Qzy0/mhMbw7svU7IFwdkvQ2UjeqPz0Oa6aX2CZdOLxdh8YFE8XgnBOj3N35cqLHvyVw5I/vQgrdeT8QPB0lpyhM4cqC+23qwqYNbpcGe8giYXD2VBRceFGhS1LMnr70aSxUeGU
 Gm7fYpgS
 UnggpTgbEojz19pRFpMhtCNRNGlqZSAQCB6BPrJM4T3tcxdpekZ/Rrb+vDZbcVo0hiel7UWdMZ6NS7f0bQMhXANXoTk3oc3dDsFZXzcBhk5I6I2ITtG/EQzya/J8PMOkQ4IiWA2bwQmBQAkCfRm1rSfUV1axZ9uqnggpUfqJAZl81pGP6iCG9WW5zWZJ77Nx+MrOaq+7bmYg6PbooXB48Lj4f2iqgGt+EdQVMe6JuEoTCSJKOi4wYQHE4i7KKG2TSVtG05ciWrjyYDnIVTaAAw+4amNEu7G9OCjsXRN/b4ON0Cc8w8nPe37tIoVXYiTX70o0eWbIy1TxGJ+ODkd6pW4GVWLXqKct7C9dOuBzuxPmw1TjB7X2V12drMkgVD5M5uQ5Fi3666VbZ8ZVZFb9AFHbjPrrQmIlp5ni2GJmEp7kuDL2eruuWPXostkRdfPBIsJEdR4nZToxSZx5A16SFf9EgfoQsQ7YbKk9R4ouqnVyHNg8KPhpS3XUTpGpL989fkJcE85ZRmzQiQVcmoXmjZI6u+6NE7EWjJ3/TNcyNZFe/6UwJGl3MqrCzmgiTcGypH0ofBh0zHm9MK8gKK0z0Cs+g1uApXSuUpH1gs1JpSLn1a8lH7rgh3KP8WVz2VY5EvyeYlibcAVj/fZmhgICcgqmtFxH+mtPa7PqSguii7lt9lNMzhdsuKvRKDJwv/cMdoN8sBGLeTi1Hbus=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When the device updates the entry of a device in the info page, it
raises an event through the interrupt multiplexer. User space needs to
learn about these events, so we tell it the index as part of its
SLOT_ADD_DEVICE ioctl response in the new info_notify_index field.
It can then use it to request device update notifications the same
way it listens to VQ events.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 64 ++++++++++---------
 drivers/virt/nitro_enclaves/ne_misc_dev.h | 15 +++--
 drivers/virt/nitro_enclaves/ne_pci_dev.c  |  3 +-
 drivers/virt/nitro_enclaves/ne_pci_dev.h  | 30 ++++++---
 include/uapi/linux/nitro_enclaves.h       | 77 ++++++++++++++---------
 5 files changed, 115 insertions(+), 74 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index bc78580bad475..d47fc8b514bcc 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -1777,27 +1777,27 @@ static int ne_start_enclave_ioctl(struct ne_enclave *ne_enclave,
 }
 
 /**
- * ne_mux_drop_bit() - Take the bit of an enclave queue out of the bitmap of its
- *		       pooled vector.
+ * ne_mux_drop_bit() - Take the bit of an enclave notification out of the bitmap
+ *		       of its pooled vector.
  * @ne_pci_dev:		Private data associated with the PCI device.
- * @notify_index:	Notify index of the queue whose bit to take out.
+ * @notify_index:	Notify index of the notification whose bit to take out.
  *
  * The handler leaves a bit it finds no binding for set, so that a bind can take
- * it and deliver the kick it stands for. Once the binding is gone, the bind
- * that bit was waiting for has already happened, and the next bind of the index
- * belongs to whoever holds the queue by then, so leaving the bit would hand one
- * caller's kick to another. It also costs every later interrupt on the vector a
- * lookup for a bit nothing will claim. Take it out.
+ * it and deliver the notification it stands for. Once the binding is gone, the
+ * bind that bit was waiting for has already happened, and the next bind of the
+ * index belongs to whoever holds the notification by then, so leaving the bit
+ * would hand one caller's notification to another. It also costs every later
+ * interrupt on the vector a lookup for a bit nothing will claim. Take it out.
  *
  * The caller takes the binding out of the xarray first, so at this point no
- * binding for the index is left to look up, and the kick this destroys is one
- * no later scan could have delivered. In the other order a kick the device
- * recorded in between would be left with a live binding and no interrupt of
- * its own still to come.
+ * binding for the index is left to look up, and the notification this destroys
+ * is one no later scan could have delivered. In the other order a notification
+ * the device recorded in between would be left with a live binding and no
+ * interrupt of its own still to come.
  *
- * A kick the enclave raises between the two is dropped. It is a kick that
- * arrived as its caller stopped listening, so the ioctl documentation says a
- * release leaves a later bind of the index no kick to collect.
+ * A notification the enclave raises between the two is dropped. It arrived as
+ * its caller stopped listening, so the ioctl documentation says a release
+ * leaves a later bind of the index no notification to collect.
  *
  * Context: Process context.
  */
@@ -1828,13 +1828,13 @@ static void ne_mux_drop_bit(struct ne_pci_dev *ne_pci_dev, u32 notify_index)
 }
 
 /**
- * ne_del_notify_eventfd() - Release the eventfd bound to the interrupt of an
- *			     enclave queue.
+ * ne_del_notify_eventfd() - Release the eventfd bound to an enclave
+ *			     notification.
  * @ne_enclave :	Private data associated with the current enclave.
  * @ne_pci_dev:		Private data associated with the PCI device, taken by
  *			the caller so that the release runs on the device the
  *			caller looked the enclave up on.
- * @notify_index:	Notify index of the queue to release.
+ * @notify_index:	Notify index of the notification to release.
  *
  * Context: Process context.
  * Return:
@@ -1909,17 +1909,20 @@ static bool ne_enclave_owns_notify(struct ne_enclave *ne_enclave,
 	struct ne_device_wiring *dev = NULL;
 	unsigned int i = 0;
 
-	list_for_each_entry(dev, &ne_enclave->devices, list_entry)
+	list_for_each_entry(dev, &ne_enclave->devices, list_entry) {
+		if (dev->info_notify_index == notify_index)
+			return true;
+
 		for (i = 0; i < dev->num_vqs; i++)
 			if (dev->notify_index[i] == notify_index)
 				return true;
+	}
 
 	return false;
 }
 
 /**
- * ne_set_notify_eventfd() - Bind an eventfd to the interrupt of an enclave
- *			     queue.
+ * ne_set_notify_eventfd() - Bind an eventfd to an enclave notification.
  * @ne_enclave :	Private data associated with the current enclave.
  * @notify:		The eventfd and the notify index.
  *
@@ -2051,10 +2054,10 @@ static int ne_set_notify_eventfd(struct ne_enclave *ne_enclave,
 	}
 
 	/*
-	 * Raise the scan bound of the vector the queue shares. Enclaves bind
-	 * under their own mutex, so two of them can reach the same vector at
-	 * once and a plain read-modify-write would lose a raise and with it a
-	 * queue kick.
+	 * Raise the scan bound of the vector the notification shares. Enclaves
+	 * bind under their own mutex, so two of them can reach the same vector
+	 * at once and a plain read-modify-write would lose a raise and with it
+	 * a notification.
 	 */
 	max_bit = READ_ONCE(ne_pci_dev->mux[vec_rel].max_bit);
 	while (bit > max_bit)
@@ -2094,9 +2097,10 @@ static int ne_set_notify_eventfd(struct ne_enclave *ne_enclave,
 }
 
 /**
- * ne_enclave_remove_all_notify_binding_entries() - Remove all the enclave queue
- *						    bindings from the device
- *						    wide bindings xarray.
+ * ne_enclave_remove_all_notify_binding_entries() - Remove all the enclave
+ *						    notification bindings from
+ *						    the device wide bindings
+ *						    xarray.
  * @ne_enclave :	Private data associated with the current enclave.
  * @ne_pci_dev:		Private data associated with the PCI device, taken by
  *			the caller so that the removal runs on the device the
@@ -4675,7 +4679,7 @@ static int ne_add_device_ioctl(struct ne_enclave *ne_enclave,
 		return -NE_ERR_INVALID_FLAG_VALUE;
 	}
 
-	if (args->padding)
+	if (args->padding || args->padding2)
 		return -EINVAL;
 
 	if (args->num_vqs > NE_MAX_VQS) {
@@ -4854,8 +4858,10 @@ static int ne_add_device_ioctl(struct ne_enclave *ne_enclave,
 	}
 
 	args->device_uid = cmd_reply.add_device.device_uid;
+	args->info_notify_index = cmd_reply.add_device.info_notify_index;
 
 	dev->num_vqs = args->num_vqs;
+	dev->info_notify_index = args->info_notify_index;
 	list_add(&dev->list_entry, &ne_enclave->devices);
 	dev = NULL;
 
diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.h b/drivers/virt/nitro_enclaves/ne_misc_dev.h
index 57e20fe3ee1da..0df403f0080e5 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.h
@@ -117,18 +117,23 @@ struct ne_mem_region {
  *			     enclave.
  * @list_entry:		Entry in the list of the enclave's devices.
  * @num_vqs:		Number of entries of @notify_index.
+ * @info_notify_index:	Notification the enclave raises when it has changed
+ *			the info page of the device.
  * @notify_index:	Notify index of each virtqueue of the device.
  */
 struct ne_device_wiring {
 	struct list_head	list_entry;
 	u32			num_vqs;
+	u32			info_notify_index;
 	u32			notify_index[NE_MAX_VQS_PER_DEVICE];
 };
 
 /**
- * struct ne_notify_binding - Entry in the list of enclave virtqueue bindings.
- * @notify_binding_list_entry:	Entry in the list of enclave queue bindings.
- * @notify_index:		Notify index of the bound queue.
+ * struct ne_notify_binding - Entry in the list of enclave notification
+ *			      bindings.
+ * @notify_binding_list_entry:	Entry in the list of enclave notification
+ *				bindings.
+ * @notify_index:		Notify index of the bound notification.
  */
 struct ne_notify_binding {
 	struct list_head	notify_binding_list_entry;
@@ -162,8 +167,8 @@ struct ne_notify_binding {
  *				so that the device keeps the page after user space
  *				has closed the descriptor. NULL until
  *				%NE_SET_INFO_PAGE is called.
- * @notify_bindings:		List of the virtqueues this enclave has bound an
- *				eventfd to.
+ * @notify_bindings:		List of the notifications this enclave has bound
+ *				an eventfd to.
  * @devices:			List of struct ne_device_wiring, one for each device
  *				%NE_ADD_DEVICE gave the enclave. The notify indices
  *				in it are the only ones the enclave may bind an
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.c b/drivers/virt/nitro_enclaves/ne_pci_dev.c
index a079abb2b4618..cedf828240214 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.c
@@ -554,7 +554,8 @@ static void ne_teardown_msix(struct pci_dev *pdev)
 }
 
 /**
- * ne_mux_binding_rcu_free() - RCU callback freeing one enclave queue binding.
+ * ne_mux_binding_rcu_free() - RCU callback freeing one enclave notification
+ *			       binding.
  * @head:	RCU head of the binding to free.
  *
  * Context: Softirq or process context.
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
index 0dbce83cb06bd..18aafe8111a67 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
@@ -559,8 +559,11 @@ struct slot_pool_mem_donate_req {
  * @add_device.device_uid:	SLOT_ADD_DEVICE. Unique id of the new device.
  * @add_device.num_vqs:		SLOT_ADD_DEVICE. Number of entries of wiring
  *				the device wrote to the info page.
- * @add_device.reserved12:	SLOT_ADD_DEVICE. Bytes owned by other
- *				commands.
+ * @add_device.info_notify_index:	SLOT_ADD_DEVICE. Notification the
+ *				enclave raises when it has changed the info page
+ *				of the device.
+ * @add_device.reserved14:	SLOT_ADD_DEVICE. Bytes the device writes as
+ *				zero.
  * @add_device.vq_wiring_offset:	SLOT_ADD_DEVICE. Offset into the info
  *				page at which @num_vqs entries of struct
  *				ne_vq_wiring start.
@@ -602,7 +605,8 @@ struct ne_pci_dev_cmd_reply {
 		struct {
 			u64	device_uid;
 			u32	num_vqs;
-			u32	reserved12;
+			u16	info_notify_index;
+			u16	reserved14;
 			u64	vq_wiring_offset;
 		} add_device;
 	};
@@ -616,6 +620,10 @@ static_assert(offsetof(struct ne_pci_dev_cmd_reply, alloc.mem_regions) == 32);
 static_assert(offsetof(struct ne_pci_dev_cmd_reply, info.slot_uid) == 8);
 static_assert(offsetof(struct ne_pci_dev_cmd_reply, add_device.device_uid) == 8);
 static_assert(offsetof(struct ne_pci_dev_cmd_reply, add_device.num_vqs) == 16);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply,
+		       add_device.info_notify_index) == 20);
+static_assert(offsetof(struct ne_pci_dev_cmd_reply,
+		       add_device.reserved14) == 22);
 static_assert(offsetof(struct ne_pci_dev_cmd_reply,
 		       add_device.vq_wiring_offset) == 24);
 static_assert(offsetof(struct ne_pci_dev_cmd_reply, info.enclave_cid) == 16);
@@ -677,8 +685,9 @@ struct ne_mux_vec {
 };
 
 /**
- * struct ne_mux_binding - Eventfd bound to one enclave queue.
- * @ctx:			Eventfd signalled when the queue is kicked.
+ * struct ne_mux_binding - Eventfd bound to one enclave notification.
+ * @ctx:			Eventfd signalled when the notification is
+ *				raised.
  * @rcu:			Head used to free the binding after a grace
  *				period, so that an interrupt handler which
  *				already loaded it can still dereference it.
@@ -707,8 +716,8 @@ struct ne_mux_binding {
  *				capability, and with it the multiplexer and slot
  *				pool registers.
  * @iomem_base :		MMIO region of the PCI device.
- * @notify_xa:			Enclave queue bindings, keyed by the notify index of
- *				the queue.
+ * @notify_xa:			Enclave notification bindings, keyed by notify
+ *				index.
  * @mux:			Per-pooled-vector interrupt multiplexer state.
  * @mux_nr_vecs:		Number of MSI-X vectors in the interrupt
  *				multiplexer pool.
@@ -789,9 +798,10 @@ int ne_do_request(struct pci_dev *pdev, enum ne_pci_dev_cmd_type cmd_type,
 		  size_t cmd_reply_size);
 
 /**
- * ne_mux_binding_free_rcu() - Free an enclave queue binding after a grace
- *			       period.
- * @binding:	Binding that has been removed from the queue bindings xarray.
+ * ne_mux_binding_free_rcu() - Free an enclave notification binding after a
+ *			       grace period.
+ * @binding:	Binding that has been removed from the notification bindings
+ *		xarray.
  *
  * Context: Process context.
  */
diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
index ff1b32e380e7b..4f2ca77f1b827 100644
--- a/include/uapi/linux/nitro_enclaves.h
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -590,6 +590,9 @@ struct ne_shm_region {
  * @device_uid:		Id the device gave the new device (out).
  * @vq_info:		How the enclave reaches the device's first @num_vqs
  *			virtqueues (out).
+ * @info_notify_index:	Notification raised when the device has updated its
+ *			entry in the info page (out).
+ * @padding2:		Must be zero.
  */
 struct ne_add_device_args {
 	__u32	flags;
@@ -603,6 +606,8 @@ struct ne_add_device_args {
 	__u64	shm_regions_ptr;
 	__u64	device_uid;
 	struct ne_vq_info vq_info[NE_MAX_VQS];
+	__u32	info_notify_index;
+	__u32	padding2;
 };
 
 /**
@@ -636,6 +641,12 @@ struct ne_add_device_args {
  *		   reads them from there and returns them in @vq_info, so a
  *		   caller learns the interrupt vector and the doorbell offset
  *		   of every queue from this call.
+ *		   One more notification is raised when the device has updated
+ *		   its entry in the info page, and @info_notify_index names it,
+ *		   so %NE_SET_NOTIFY_EVENTFD binds an eventfd to it the same way
+ *		   it binds one to a queue.
+ *		   An argument that ends at @vq_info is taken and gets no
+ *		   @info_notify_index back.
  *		   The ioctl can be invoked on the enclave fd, before an
  *		   enclave is started.
  *
@@ -648,7 +659,8 @@ struct ne_add_device_args {
  * * EFAULT				- Argument read or write failure.
  * * EBADF				- A region's @fd is not an open file
  *					  descriptor.
- * * EINVAL				- The argument is shorter than @vq_info, or
+ * * EINVAL				- The argument does not reach the end of
+ *					  @vq_info, or
  *					  @padding is not zero, or @num_vqs is
  *					  more than %NE_MAX_VQS, or @config_size
  *					  is more than @device_config holds, or
@@ -662,7 +674,8 @@ struct ne_add_device_args {
  *					  made for another enclave, or it is
  *					  %NE_MEMORY_PRIVATE, or the regions are
  *					  made of more runs in total than the
- *					  device takes.
+ *					  device takes, or @padding2 is not
+ *					  zero.
  * * EIO				- Current task mm is not the same as the one
  *					  that created the enclave.
  * * E2BIG				- The argument is longer than this kernel knows
@@ -1063,29 +1076,35 @@ struct ne_enclave_start_info {
 
 /**
  * NE_EVENTFD_UNBIND - Value of an eventfd field that releases the binding the
- *		       caller holds, instead of naming an eventfd to bind. A kick
- *		       the enclave raises as the release lands is dropped, so a
- *		       caller that binds the queue again gets no signal for it.
- *		       Any other negative value names no open file and is an
- *		       error.
+ *		       caller holds, instead of naming an eventfd to bind. A
+ *		       notification the enclave raises as the release lands is
+ *		       dropped, so a caller that binds it again gets no signal
+ *		       for it. Any other negative value names no open file and
+ *		       is an error.
  */
 #define NE_EVENTFD_UNBIND		(-1)
 
 /**
- * NE_SET_NOTIFY_EVENTFD - The command is used to bind an eventfd to the
- *			   interrupt of one enclave virtqueue. When the enclave
- *			   kicks the queue, the NE PCI device raises the
- *			   interrupt the queue shares and the driver signals the
- *			   eventfd. A queue the caller has already bound is
- *			   rebound to the new eventfd, and the driver drops its
- *			   reference on the one it replaces. A kick that is
+ * NE_SET_NOTIFY_EVENTFD - The command is used to bind an eventfd to one of the
+ *			   notifications an enclave raises, which is the kick of
+ *			   one of its virtqueues or an update to a device's
+ *			   entry in the info page. When the enclave raises the
+ *			   notification, the NE PCI device raises the interrupt
+ *			   the notification shares and the driver signals the
+ *			   eventfd. A notification the caller has already bound
+ *			   is rebound to the new eventfd, and the driver drops
+ *			   its reference on the one it replaces. A notification
  *			   already being delivered when the rebind lands is
  *			   signalled on the outgoing eventfd, so a caller that
- *			   rebinds a queue an enclave is still kicking can see
- *			   one last kick arrive on the eventfd it replaced.
- *			   %NE_EVENTFD_UNBIND
- *			   releases the binding the caller holds on the queue.
- *			   The ioctl can be invoked on the enclave fd.
+ *			   rebinds a notification an enclave is still raising can
+ *			   see one last signal arrive on the eventfd it replaced.
+ *			   %NE_EVENTFD_UNBIND releases the binding the caller
+ *			   holds on the notification. The ioctl can be invoked
+ *			   on the enclave fd.
+ *			   @notify_index names a notification across the
+ *			   whole NE PCI device, and an enclave fd binds only
+ *			   the indices %NE_ADD_DEVICE reported to its enclave,
+ *			   in @vq_info or in @info_notify_index.
  *
  * Context: Process context.
  * Return:
@@ -1107,20 +1126,20 @@ struct ne_enclave_start_info {
  * * E2BIG				- The argument is longer than this kernel knows
  *					  about and the excess is not all zero.
  * * ENOMEM				- Memory allocation failure.
- * * EEXIST				- Another enclave holds a binding on the queue.
- * * ENOENT				- The caller holds no binding on the queue to
- *					  release.
+ * * EEXIST				- Another enclave holds a binding on the
+ *					  notification.
+ * * ENOENT				- The caller holds no binding on the notification
+ *					  to release.
  */
 #define NE_SET_NOTIFY_EVENTFD		_IOW(0xAE, 0x28, struct ne_notify_eventfd)
 
 /**
- * struct ne_notify_eventfd - Eventfd to signal on an enclave virtqueue kick
- *			      (in).
- * @fd:			Eventfd to signal when the queue is kicked, or
- *			%NE_EVENTFD_UNBIND to release the binding on the
- *			queue (in).
- * @notify_index:	Index the enclave writes to notify the NE PCI device of
- *			the virtqueue (in).
+ * struct ne_notify_eventfd - Eventfd to signal on an enclave notification (in).
+ * @fd:			Eventfd to signal when the notification is raised, or
+ *			%NE_EVENTFD_UNBIND to release the binding on it
+ *			(in).
+ * @notify_index:	Index the enclave writes to raise the notification with
+ *			the NE PCI device (in).
  */
 struct ne_notify_eventfd {
 	__s32	fd;
-- 
2.47.1


