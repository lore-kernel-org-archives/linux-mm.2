Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D390E606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 23:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=Q++KfdG7
Received: by kanga.kvack.org (Postfix)
	id EA0DB6B05C1; Wed, 11 Nov 2026 18:13:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E519D6B05CA; Wed, 11 Nov 2026 18:13:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D41066B05CB; Wed, 11 Nov 2026 18:13:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A85AA6B05C1
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 18:13:32 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 546261A0426
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:13:32 +0000 (UTC)
X-FDA: 85424391864.09.CD9C7DA
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0E8CC14000B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 23:13:29 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Q++KfdG7;
	spf=pass (imf23.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794438810;
	b=Z3sXUk0D2naGjk9mo4puDqlsdsSKEkLCHsJCywVA9qItecYw3S39TA3AKKUDuZ7LjALxne
	kTjaS3C6ywFfB8GY5y2vgklcoL1AqkmF7nYb/3ijWa+cnt4FVDjwIYtWYf9MitXpTFgqg9
	BcsnRTREHxb85BpmO6negyww1wA0kQo=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Q++KfdG7;
	spf=pass (imf23.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794438810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fNZTcU8kaV95qVuAYwD+yfMjaSjFZEVMGsWNQ/HDHjg=;
	b=iTOVsAKzOaVihuCTTth77NmAfuBSpKhQ7v0g6nZf4k8LNMmiEGkO0BMwAQdLkfNszZRkui
	l4zg55HLVi/AvEeFnRKLRvxnIstD/8E9zffbID9+PFlI2hH+v1gKKPMq9RlkzqHvcP7PmX
	cqsbVyL8t2TxgJbg4L4LSQeUHQp+3Ek=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794438810; x=1825974810;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fNZTcU8kaV95qVuAYwD+yfMjaSjFZEVMGsWNQ/HDHjg=;
  b=Q++KfdG7C3tO9UR7nvI9eTUQNDy3ZHpYbs3E8cW5QFiCQTW9vyZ+Bg/g
   cjclg4agYHop/jKKRXDeYQ7HVAfz69B+DswSTpb0DVcF3CMCKvyjiW7Y8
   1kTKm/SEt22aShflXu/3f/TzUVGv0fh7RtNHyFTm+TLgQhR2lcaMP5kfe
   HQoXtEq3RafTQFdoTxlHlvHlmEkFYO5QURBHU4Rx0cjStqYoNMhqAC3Oi
   HHbOt0AQ4VWiTrqwvPAJcJdXqSmeiHBjHUvhzi0MN7qj4exHofwDYR2Ce
   DMGNxCEK/RN+/Sc/MRXqUbBu5JDoQqNQJhIZ2m1g+eJNWXVmlhL3FT8ua
   w==;
X-CSE-ConnectionGUID: HAuVaQVuTAS3XV7ARNUtwA==
X-CSE-MsgGUID: mkF+ut4LR0+PIOh5fGjlBg==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33533986"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 23:13:28 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.178:15790]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.12.127:2525] with esmtp (Farcaster)
 id e5e45bc1-0417-4c57-8468-143fe094e75a; Wed, 11 Nov 2026 23:13:28 +0000 (UTC)
X-Farcaster-Flow-ID: e5e45bc1-0417-4c57-8468-143fe094e75a
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:13:28 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 23:13:25 +0000
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
Subject: [PATCH 39/40] nitro_enclaves: Add NE_UPDATE_DEVICE_CONFIG
Date: Wed, 11 Nov 2026 22:59:43 +0000
Message-ID: <242d156c25da512f2edddb0bd3d2f34fe727721e.1794393491.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC004.ant.amazon.com (10.13.139.246) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0E8CC14000B
X-Stat-Signature: u4emf1jo8p7odb6kok6ne5qjf7k7zq18
X-Rspam-User: 
X-HE-Tag: 1794438809-273332
X-HE-Meta: U2FsdGVkX1/jYnqAjL5izL5myGKGrYrTp+eg8UVC1h2PStSebxAFK0TcbQINfJvP98mgmN8sQkuFrjA6aK7b3Pq7PAiglQ2SCxO1pSu8Y7AY6D7PLrEEDuyWEsTnJSAiTL/Uc3DIvCyaIYZGvPzKZw1WfX+bwSqqQo64/68Syks5JFiHhVtg2C2E2Btil0WVtZey8A5a5wrJ4xap0e0zQYoVJGvUanT+fdBbQloZOllaxXa9eyXRLC5QfBjp/8gOC4OvHwXk2AeP6jSJzmT4WC0zmXp3SvrWzGLjW6Ntou5mkqybs4FDz3fMI6Iq6nfk7Fu5mzH5wOo8j9KWxwFXwdyHnoFWU7UNyTC/N1gTZLXV0/NtcajMbFJWIabPI3U/hAx0TUVhPz7Xtw/dhV+1RomPglkYigVx0tB62Xjpq0DqLGULujm9w+uh64JhWX2glqemaGFjpwPsRjz9eLO4xWyttV+h1WZ/oXZbcS1e97pCXGjdk4kWwHTVqbU9yeRDgCExQMi3bOy5Rx2aqcvin82Twwvrze/pDWBxjXsgdV6KhUs8eT4tADclKpm/4nCqY2kTL3nEAIQzbS/zw9SVbk0GPLglpN7f2IDvt8FTRPbnro4i0aJ4QBFvUafgYYupin40QHM2qJSqujRkYi2O40NTWMUSOUom1Hz4VFP7P/GccwWPA0MDPKJ2igSqLsAiGcMjAUdPY4sI4WenjrtQ8nJ8M4b1hCgc2HC8OD+I8VaxowptRmfQ9H9FM2gSjm5Hgm3vsxhT2mWAbr1/LqGx9IqIhDwPFPw+zcRJUvSOYITrGypHigNButJGgLVVkuJEFB1Ez8Pd/ZQYnhvdaNvuG09qrqbrwrG7tyqMDcl81rIAxn5VrjNOSw72SfFo46YmUAknN0OogpFvs8aIfqBXLLVL8kYvkCVvKE60+v9o1Ngilf7UCzgj6NZQJ2PhWUnwaHF9ZriHRCG0FpRdHQ0
 oO73DAEk
 h1rfYllYdWPXGfFmucUoBYWn4F2e/2J8tUWsDpaBVL+xLIQXdlZgCXrbC4hJCD8BwvMjv8byxgkBjycX+4vYW0Dq1eIOxivXMLYXTgdCPmaXmPq5mNAT8BJi2doaZeUy6iEZLjH5EMRkLtMJQowqAIK0mMOCM3a3kZAlEWOo2zI4wFg8NwDF9zq9Lg/olAE9H4rZSrAyAQ+GKfh8zaFzjov4LPzCG/UNXYseP0EmboV3wyXnshJ40MeQj4ym1wTfbRn+FE+11N/qFxKQ1VeIE0oDrUaxgGHHFQ65kjG5gmI5DPUXi+x/tjr6AyZ5J6kn3yme7xtW/KQ8mXMxUwL+KPN2HhgOYyjOwn5PPFMe7Ttga1qn6CPf7AN8US2PSexeByV3P/0DwuMHeVCrzz0ATKet8CdkDQdLW0TUGrKq5BizTRNeElRKIPV1n5flNmCiZX+u6ntKB6DWouq2BwIJQ1kw3tL+gM9wMQjii5MP46s6F2awtQGd5XAE9fy3fjuAT1svbfTbjGjqToaAir4QiBX4dSNBVNy9JMNs+2RfAncgfmtKKiB0AONG0Cbfunlo+FxKNgHMVtGynsBgRLkrk24zvYHczOnlbvWze816PkLaYvOtWAyHDDdCwkMciRi5dDFqRuJE1LF7BPMegYmBa+OAb3eYJCfRQetlmy3hfKAXEx5sXXze6+iJjGwqVp/EhwdBlnWfQtuUpbEs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A virtio device reports state that changes while the guest runs, such as
a network link going down, through its configuration space. Nitro
Sandboxes let the device backend in the parent write that space while
the sandbox runs through an explicit full-config-update call, which also
raises the virtio configuration-change notification inside the sandbox.

Add the NE_UPDATE_DEVICE_CONFIG ioctl on the enclave fd to give user
space an API to call with the updated config space.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 113 +++++++++++++++++++++-
 drivers/virt/nitro_enclaves/ne_pci_dev.h  |  24 +++++
 include/uapi/linux/nitro_enclaves.h       | 100 ++++++++++++++++++-
 3 files changed, 231 insertions(+), 6 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index abbba71bbef06..a5550a6be86ea 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -120,6 +120,12 @@ static_assert(offsetof(struct ne_vring_call, fd) == 0);
 static_assert(offsetof(struct ne_vring_call, doorbell_offset) == 4);
 static_assert(offsetof(struct ne_vring_call, reserved) == 6);
 
+static_assert(sizeof(struct ne_update_device_config) == 24);
+static_assert(offsetof(struct ne_update_device_config, device_uid) == 0);
+static_assert(offsetof(struct ne_update_device_config, config_addr) == 8);
+static_assert(offsetof(struct ne_update_device_config, config_size) == 16);
+static_assert(offsetof(struct ne_update_device_config, config_offset) == 20);
+
 static_assert(sizeof(struct ne_create_vm_args) == 16);
 static_assert(offsetof(struct ne_create_vm_args, flags) == 0);
 static_assert(offsetof(struct ne_create_vm_args, slot_uid) == 8);
@@ -162,7 +168,7 @@ static_assert(offsetof(struct ne_caps, supported_matched_flags) == 16);
 static_assert(offsetof(struct ne_caps, max_devices) == 24);
 static_assert(offsetof(struct ne_caps, max_vqs_per_device) == 28);
 static_assert(offsetof(struct ne_caps, max_config_size) == 32);
-static_assert(offsetof(struct ne_caps, reserved) == 36);
+static_assert(offsetof(struct ne_caps, max_config_update_size) == 36);
 static_assert(offsetof(struct ne_caps, info_page_size) == 40);
 static_assert(offsetof(struct ne_caps, info_page_align) == 48);
 static_assert(offsetof(struct ne_caps, hypervisor_matched_flags) == 56);
@@ -217,6 +223,8 @@ static int ne_set_info_page_ioctl(struct ne_enclave *ne_enclave,
 				  struct ne_set_info_page_args *args);
 static int ne_add_device_ioctl(struct ne_enclave *ne_enclave,
 			       struct ne_add_device_args *args);
+static int ne_update_device_config_ioctl(struct ne_enclave *ne_enclave,
+					 struct ne_update_device_config *args);
 static const struct file_operations ne_fops = {
 	.owner		= THIS_MODULE,
 	.llseek		= noop_llseek,
@@ -3229,6 +3237,39 @@ static long ne_enclave_do_ioctl(struct file *file, unsigned int cmd, unsigned lo
 		return ne_set_vring_call(ne_enclave, &args);
 	}
 
+	case NE_EA_IOCTL(NE_UPDATE_DEVICE_CONFIG): {
+		struct ne_update_device_config __user *uargs = (void __user *)arg;
+		unsigned int usize = _IOC_SIZE(cmd);
+		struct ne_update_device_config args;
+		int rc;
+
+		if (usize < offsetofend(struct ne_update_device_config, config_offset))
+			return -EINVAL;
+
+		rc = copy_struct_from_user(&args, sizeof(args), uargs, usize);
+		if (rc)
+			return rc;
+
+		rc = mutex_lock_killable(&ne_enclave->enclave_info_mutex);
+		if (rc)
+			return rc;
+
+		if (ne_enclave->state != NE_STATE_RUNNING) {
+			dev_err_ratelimited(ne_misc_dev.this_device,
+					    "Enclave is not in running state\n");
+
+			mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+			return -NE_ERR_NOT_IN_RUNNING_STATE;
+		}
+
+		rc = ne_update_device_config_ioctl(ne_enclave, &args);
+
+		mutex_unlock(&ne_enclave->enclave_info_mutex);
+
+		return rc;
+	}
+
 	default:
 		return -ENOTTY;
 	}
@@ -3858,6 +3899,9 @@ static long ne_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		caps.max_vqs_per_device = NE_MAX_VQS;
 		caps.max_config_size = sizeof_field(struct ne_add_device_args,
 						    device_config);
+		caps.max_config_update_size =
+			sizeof_field(struct slot_update_device_config_req,
+				     config_data);
 		caps.info_page_size = NE_INFO_PAGE_SIZE;
 		caps.info_page_align = NE_INFO_PAGE_ALIGN;
 
@@ -5598,6 +5642,73 @@ static int ne_add_device_ioctl(struct ne_enclave *ne_enclave,
 	return rc;
 }
 
+/**
+ * ne_update_device_config_ioctl() - Write part of the configuration space of a
+ *				     device the enclave is driving.
+ * @ne_enclave:	Private data associated with the current enclave.
+ * @args:	Where the bytes to write are, how many of them there are and
+ *		where in the device's configuration space they go.
+ *
+ * The bytes are copied out of the caller before the request is built, so what
+ * the caller does with its buffer afterwards does not reach the device, and a
+ * call that is refused here sends the device nothing.
+ *
+ * Context: Process context. This function is called with the ne_enclave mutex held.
+ * Return:
+ * * 0 on success.
+ * * Negative return value on failure.
+ */
+static int ne_update_device_config_ioctl(struct ne_enclave *ne_enclave,
+					 struct ne_update_device_config *args)
+{
+	struct slot_update_device_config_req req = {};
+	struct ne_pci_dev_cmd_reply cmd_reply = {};
+	int rc;
+
+	if (!args->config_size) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "The configuration write is empty\n");
+
+		return -EINVAL;
+	}
+
+	/*
+	 * The request carries the bytes in a fixed array and tells the device
+	 * separately where in its configuration space to put them, so what the
+	 * request bounds is how many bytes one call moves. How far into the
+	 * space a write may reach is the device's to bound, out of the
+	 * configuration space it was given for that device.
+	 */
+	if (args->config_size > sizeof(req.config_data)) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "The configuration write is longer than %zu bytes\n",
+				    sizeof(req.config_data));
+
+		return -EINVAL;
+	}
+
+	if (copy_from_user(req.config_data, u64_to_user_ptr(args->config_addr),
+			   args->config_size))
+		return -EFAULT;
+
+	req.slot_uid = ne_enclave->slot_uid;
+	req.device_uid = args->device_uid;
+	req.config_size = args->config_size;
+	req.config_offset = args->config_offset;
+
+	rc = ne_do_request(ne_devs.ne_pci_dev->pdev, SLOT_UPDATE_DEVICE_CONFIG,
+			   &req, sizeof(req), &cmd_reply, sizeof(cmd_reply));
+	if (rc < 0) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Error in slot update device config [rc=%d]\n",
+				    rc);
+
+		return rc;
+	}
+
+	return 0;
+}
+
 #if defined(CONFIG_NITRO_ENCLAVES_MISC_DEV_TEST)
 #include "ne_misc_dev_test.c"
 #endif
diff --git a/drivers/virt/nitro_enclaves/ne_pci_dev.h b/drivers/virt/nitro_enclaves/ne_pci_dev.h
index 44491e451082a..74728d2a15472 100644
--- a/drivers/virt/nitro_enclaves/ne_pci_dev.h
+++ b/drivers/virt/nitro_enclaves/ne_pci_dev.h
@@ -256,6 +256,8 @@ static_assert(NE_MUX_MAX_BITS / BITS_PER_TYPE(u64) * sizeof(u64) <= PAGE_SIZE,
  *				device runs a slot out of.
  * @SLOT_POOL_GET_LIMITS:	Report how many slots each half of the pool has
  *				room for.
+ * @SLOT_UPDATE_DEVICE_CONFIG:	Write part of the configuration space of a
+ *				device a slot is driving.
  * @SLOT_POOL_BASE_DONATE:	Donate the base run of the slot pool.
  * @MAX_CMD:			A gatekeeper for max possible command type.
  */
@@ -277,6 +279,7 @@ enum ne_pci_dev_cmd_type {
 	SLOT_ADD_DEVICE		= 14,
 	SLOT_POOL_DONATE	= 16,
 	SLOT_POOL_SHUTDOWN	= 17,
+	SLOT_UPDATE_DEVICE_CONFIG = 24,
 	SLOT_POOL_BASE_DONATE	= 25,
 	SLOT_POOL_MEM_DONATE	= 26,
 	SLOT_POOL_GET_LIMITS	= 27,
@@ -502,6 +505,27 @@ struct slot_add_device_req {
 } __packed;
 static_assert(sizeof(struct slot_add_device_req) <= NE_SEND_DATA_SIZE);
 
+/**
+ * struct slot_update_device_config_req - SLOT_UPDATE_DEVICE_CONFIG request.
+ * @slot_uid:			Slot unique id mapped to the slot driving the
+ *				device.
+ * @device_uid:			Device to write the configuration of.
+ * @config_size:		Number of bytes of @config_data the device
+ *				reads.
+ * @config_offset:		Byte offset within the device's configuration
+ *				space the device is to place @config_data at.
+ * @config_data:		Configuration to write into the device's
+ *				configuration space.
+ */
+struct slot_update_device_config_req {
+	u64	slot_uid;
+	u64	device_uid;
+	u32	config_size;
+	u32	config_offset;
+	u8	config_data[64];
+} __packed;
+static_assert(sizeof(struct slot_update_device_config_req) <= NE_SEND_DATA_SIZE);
+
 /**
  * struct slot_pool_donate_req - SLOT_POOL_DONATE and SLOT_POOL_BASE_DONATE
  *				 request.
diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
index f8eeacd2e7062..4a0a8eb30caa4 100644
--- a/include/uapi/linux/nitro_enclaves.h
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -204,8 +204,8 @@ struct ne_create_vm_args {
 
 /**
  * NE_CAP_DEVICES - This kernel implements %NE_SET_INFO_PAGE,
- *			 %NE_ADD_DEVICE, %NE_SET_NOTIFY_EVENTFD and
- *			 %NE_SET_VRING_CALL.
+ *			 %NE_ADD_DEVICE, %NE_SET_NOTIFY_EVENTFD,
+ *			 %NE_SET_VRING_CALL and %NE_UPDATE_DEVICE_CONFIG.
  */
 #define NE_CAP_DEVICES			(1ULL << 1)
 
@@ -240,7 +240,15 @@ struct ne_create_vm_args {
  *			request and %NE_ADD_DEVICE is what answers.
  * @max_vqs_per_device:	Largest @num_vqs %NE_ADD_DEVICE takes (out).
  * @max_config_size:	Largest @config_size %NE_ADD_DEVICE takes (out).
- * @reserved:		Zero (out).
+ * @max_config_update_size:	Largest @config_size one %NE_UPDATE_DEVICE_CONFIG
+ *			call takes (out). It bounds how many bytes a call moves,
+ *			not how far into the configuration space they go: a write
+ *			carries its own offset, and how far a device lets one
+ *			reach is bounded by the configuration space that device
+ *			was given in @device_config. It is reported apart from
+ *			@max_config_size because the size of @device_config is
+ *			part of the ABI while this one is not, so this value can
+ *			grow without a new argument structure.
  * @info_page_size:	Size the %NE_SET_INFO_PAGE allocation has to have (out).
  * @info_page_align:	Alignment it has to have (out).
  * @hypervisor_matched_flags: The launch flags inside
@@ -264,7 +272,7 @@ struct ne_caps {
 	__u32	max_devices;
 	__u32	max_vqs_per_device;
 	__u32	max_config_size;
-	__u32	reserved;
+	__u32	max_config_update_size;
 	__u64	info_page_size;
 	__u64	info_page_align;
 	__u64	hypervisor_matched_flags;
@@ -806,7 +814,11 @@ struct ne_shm_region {
  * @padding:		Must be zero.
  * @device_features:	Feature bits the parent offers the enclave for the
  *			device.
- * @device_config:	Type-specific configuration of the device.
+ * @device_config:	The opening bytes of the device's configuration space, as
+ *			the enclave first sees it. It is the device-specific
+ *			configuration space a virtio driver reads, not PCI
+ *			configuration space, and @max_config_size bounds how much
+ *			of it may be handed over here.
  * @shm_regions_ptr:	Address of @num_shm_regions struct ne_shm_region.
  * @device_uid:		Id the device gave the new device (out).
  * @vq_info:		How the enclave reaches the device's first @num_vqs
@@ -1200,6 +1212,13 @@ struct ne_add_device_args {
  * NE_ERR_ZERO_REGION - The enclave's memory layout has a region of size zero.
  */
 #define NE_ERR_ZERO_REGION			(302)
+/**
+ * NE_ERR_NOT_IN_RUNNING_STATE - The enclave has not been started yet, or has
+ *				 already exited, when writing the configuration
+ *				 of one of its devices. The first code of the
+ *				 driver-only range.
+ */
+#define NE_ERR_NOT_IN_RUNNING_STATE		(1024)
 
 /**
  * DOC: Image load info flags
@@ -1426,4 +1445,75 @@ struct ne_vring_call {
 	__u16	reserved;
 };
 
+/**
+ * NE_UPDATE_DEVICE_CONFIG - The command is used to write part of the
+ *			     configuration space of a device an enclave is
+ *			     already driving, so that the device backend in the
+ *			     parent tells the driver in the enclave about state
+ *			     that moved after the device was attached. The
+ *			     hypervisor raises a configuration-change
+ *			     notification inside the enclave for the write.
+ *			     The parent holds the only copy of the space: no
+ *			     command reads a device's configuration back, so a
+ *			     caller that changes fields which do not sit next to
+ *			     each other either writes each of them on its own or
+ *			     writes the whole range out of the copy it already
+ *			     has.
+ *			     The ioctl waits for the reply of the device. When
+ *			     none comes, the outcome of the write is unknown and
+ *			     the driver sends that device no further command.
+ *			     The driver reads the
+ *			     bytes at @config_addr before it builds the request,
+ *			     so writing to the buffer afterwards changes nothing,
+ *			     and it serialises the calls of one enclave against
+ *			     each other and
+ *			     every call against the other commands it sends the
+ *			     NE PCI device. A call the driver refuses sends nothing, so
+ *			     the device keeps the configuration the last accepted
+ *			     write left it.
+ *			     What the enclave sees while a write is applied is
+ *			     not specified: whether the driver inside it can read
+ *			     part of a range, whether every accepted write raises
+ *			     a notification of its own, and what a write leaves
+ *			     the bytes outside it holding, are the hypervisor's
+ *			     to answer.
+ *			     The ioctl can be invoked on the enclave fd, after an
+ *			     enclave is started.
+ *
+ * Context: Process context.
+ * Return:
+ * * 0					- Logic successfully completed.
+ * * -1					- There was a failure in the ioctl logic.
+ * On failure, errno is set to:
+ * * ENODEV				- The NE PCI device is not available.
+ * * EFAULT				- Argument or @config_addr read failure.
+ * * EINVAL				- The argument does not reach through
+ *					  @config_offset, @config_size is zero, or
+ *					  @config_size is larger than
+ *					  @max_config_update_size.
+ * * E2BIG				- The argument is longer than this kernel knows
+ *					  about and the excess is not all zero.
+ * * NE_ERR_NOT_IN_RUNNING_STATE	- The enclave is not running.
+ * * Error codes from the NE PCI device request.
+ */
+#define NE_UPDATE_DEVICE_CONFIG		_IOW(0xAE, 0x2C, struct ne_update_device_config)
+
+/**
+ * struct ne_update_device_config - Configuration to write to a device an
+ *				    enclave is already driving (in).
+ * @device_uid:		The device to write the configuration of, as
+ *			%NE_ADD_DEVICE reported it.
+ * @config_addr:	User space address of the @config_size bytes to write.
+ * @config_size:	Number of bytes to write, at least one and at most the
+ *			@max_config_update_size %NE_GET_CAPS reports.
+ * @config_offset:	Byte offset within the device's configuration space to
+ *			write them at.
+ */
+struct ne_update_device_config {
+	__u64	device_uid;
+	__u64	config_addr;
+	__u32	config_size;
+	__u32	config_offset;
+};
+
 #endif /* _UAPI_LINUX_NITRO_ENCLAVES_H_ */
-- 
2.47.1


