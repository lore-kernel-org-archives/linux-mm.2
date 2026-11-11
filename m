Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F310606A88D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 22:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=ebvVVFXc
Received: by kanga.kvack.org (Postfix)
	id 84FF56B05C0; Wed, 11 Nov 2026 17:44:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8015A6B05C1; Wed, 11 Nov 2026 17:44:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A3B86B05C3; Wed, 11 Nov 2026 17:44:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C0686B05C0
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 17:44:04 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C6239A0476
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:44:03 +0000 (UTC)
X-FDA: 85424317566.19.C3DDC45
Received: from pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.245.243.92])
	by imf26.hostedemail.com (Postfix) with ESMTP id A1E62140003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 22:44:01 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ebvVVFXc;
	spf=pass (imf26.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794437041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/cubfczVbnds8zP6oBlBcF/d/gJnxIwiCtc/tjxJ3hg=;
	b=u1cfvx8RF5eCnrYpgZNtyyRG4qmcsmjnprJziG3GwXmKn6/iyiO4ZGwFgzTpm8bQitLHJZ
	BGkhneN9Z8RLlTO4dxxCBMZWCridcZ+H0RZexlcsYG8oAKguEH5OKJeusNoVOtYP8d7RFg
	MKMYcfjqCm2+FqAm1LHXQtfM8wrGh4U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794437041;
	b=LFx9tGCHRcSTro6GDhGDIuK+hgXQG77iDhZVPFyYZOqdLVgmnTigYa7e4TMDGWkWjbJFvh
	aTt/5Se4l/6KHPHHPvkD5tEF1XQzZmnpB4a81zQZFJtkhmyjFp2GcQDBJTpBbVy8fNL6Gm
	469cKqoCVT28G7pegKOBBR9ZHPVYDxQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=ebvVVFXc;
	spf=pass (imf26.hostedemail.com: domain of "prvs=7687a31a8=graf@amazon.de" designates 44.245.243.92 as permitted sender) smtp.mailfrom="prvs=7687a31a8=graf@amazon.de";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794437041; x=1825973041;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/cubfczVbnds8zP6oBlBcF/d/gJnxIwiCtc/tjxJ3hg=;
  b=ebvVVFXcvWzmuzjkye+nt4VrwCY2I/7V2dx+J4uvpwoGgFVClOEsOBlD
   iRBQkOgvFFzxb/MwMGj/+EOaRWNYYVq5lHd/IeTpUc9BbY8nhRQf6yF4x
   LLdFpBkv1mtPImzmacaemNW7HvLPMZSu/9lLdSgampxV2T+4q2yaYZs1t
   eAWJ0qVVXOKSaN3hmajp47nIrsztHYobnah+TeLiFp++GK1T5VTCzNfD9
   R4k3ASEbu+HmIOGWDWoA1lZKu+vWrxO0xyPTt/hu0GWBPPqJYNjihwvXt
   mdzFfUDwXcFnOMnD2JJtQcRgofkR+Ni89dF9gRyp4LF40//RKjBPWKtqv
   w==;
X-CSE-ConnectionGUID: Gf4HsB+bSWOzc6SvbrsRUg==
X-CSE-MsgGUID: jkQaPXZKQimMvYS+zj3VKg==
X-IronPort-AV: E=Sophos;i="6.27,208,1787011200"; 
   d="scan'208";a="33273359"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-001.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2026 22:44:00 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:26886]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.55.227:2525] with esmtp (Farcaster)
 id d4e831c7-c721-48fe-8fab-b625d5675814; Wed, 11 Nov 2026 22:44:00 +0000 (UTC)
X-Farcaster-Flow-ID: d4e831c7-c721-48fe-8fab-b625d5675814
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:43:59 +0000
Received: from ip-10-253-83-51.amazon.com (172.19.99.218) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Wed, 11 Nov 2026 22:43:57 +0000
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
Subject: [PATCH 10/40] nitro_enclaves: Add NE_CREATE_VM2 with a launch flag word
Date: Wed, 11 Nov 2026 22:41:55 +0000
Message-ID: <1ef9f5e8a25e0ed11754e1def76ebd183a819c06.1794393490.git.graf@amazon.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1794300002.git.graf@amazon.com>
References: <cover.1794300002.git.graf@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWA003.ant.amazon.com (10.13.139.47) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: udzzayod8kpjnfqt4iwdt3de1zr77igb
X-Rspamd-Queue-Id: A1E62140003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794437041-448223
X-HE-Meta: U2FsdGVkX1+j95jSVAsRjsYn8Ox9AXmRKYh5VY6249tSwl0LggUVb1ybq8d96QlddlYl/m+zzU8fm0yU+RsYqflZGvArFRLZZtgSQ1sIdaSEE4ARmUzHBzIyYWeqKjoPMSyS55hGccTEAISDmhXeStZbrBXpzEU8ZxNQxcGBke9vikV5ZopQbo5q6BzNxznSKU8HTUu7+Q5z9aC0DMPkAzGSaufkTF6EG1kpDhfEbjJ9Rew8Gm2ECbxqpN9iyctzEktKkdBpWpMaDrqn9HhefZ23zFFcmoqR+6hF6h7T7ysyGC3F/kASL00OO2dCiaVXN4uxwcB1FdPnmePAn4nwbQ5J8P83aXZVwp0ZDA/X/fkxTZrg5iTG7x/gTkpL9EnoaReNvPl1Tp6DhiyqccEAgPNkp5e3dqoyzfJMjJaouY8p84PUxNT9BRbjYR1UeCGGFQeoFk3e4nw3HmXN51DXw2HGphO06J8Ski95pePZBaF8/nXAUO/quPKED5Kp5yGNwLAGxYe6JnCEJf7lmYYO4h8NJtKm/7qmVba8p7A76f6YCEyjSPgzrPXTc51NuEyHzJVeBFRRaJ+4QN9IPdFvqkyIhQOxYdEKLqITPKj/Sx4smpnJrZSNHVu+w3KKUlDgeIAPAeQcUJQmHTQqhGuV97y1K9U0OwskXTqnHVRQqYN6kt6yml0BymClG9nr2fYC0xclPn0QjnuFX8HyMaJXF4jtlDLZ1LoqjceUdkRWPMsw37WeC1ckNnPlzh2dzzNYDL3/2cKED1QdML6mjominQ1o0nP1ijoz22vEAA8NL7g42if27X9Tk+miUuKRms5IDu4pRh3A1g+ey58kN7tMBAjC8iPkeH1doiHtpmBdjszl/7WK8qLXsSkZ7aRdPdQyozniaUNIndo4p8wae1Xs4dDjFyjBwYwau8uxLCoXhqksrDuuyYjX8ozfUPfqsIrY6XH51Aje8ZTDw9IqfLE
 LzfJuq88
 tLTEs/xXSUpljel0kFvSYWXBw9NRKEl4WqqQ9YbwdSTsJQp5rwBqQy5E4JhzffsfZvn/iIe9uHxwvOzi/pUme5XjPMsI+drIDx2n8AfR+GxOqUrCRKagD7jF3ycw+vYQAIE1Kmdta0tL64QsYLypQSD5UhFpqPToj7aPcitWvHQAvs2Gr9BRHAc+i9A/8p7eMRsL1jlyuqlEHMtkNQUkT2NnxRtZ8MRWW7d3TuBzXmUY30XyqYQ3QmNscZowNfK/7wir36N2AxPL2y+YItFIgp/hADYemysSAjKs37kaXpUd3EACBykTXd5wqsSoXqTHBvMBIc7BnfOZFHSxSIbT8X3ZWu96y7JFZGr9oL3Apn8Hlnj2CjmcJ7GS62FGfnt1lEe3klHW0j3GyU146NPVOgX1fVeNN4mtn9Qzteo7KCW884lB7ID0Qfb/k2KNe/Z5zkZOcAJkuvG+QaWWIBrUGqS0udYoB4kvyQtuNKbAw8gz/ixvCaPn/ldevJH91HEh71zEZtuVBDvB5b0Lj7jwY0ph5ONwHZLZ/RTd0rC0fKcydZwbRFgzsYgsMd9D50a1nn63Mw0Ydj36ODR/wPNoEWnO0iNDZCDxsDqPTfbTBlJrEclx8+1mq42aan3IggzLxIykj6KgVU+CKep8W61Zlhwa33OqrP0c40o/cb5M0xo7gvU2/lSqk8/1s+9S/GbZInaAA6VuhljMuUm0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In preparation to support Nitro Sandboxes, whose properties the
hypervisor needs before it allocates a slot, add NE_CREATE_VM2. It takes
a word of launch flags for the slot. The slot id comes back in the
same struct ne_create_vm_args.

No flag is defined in this patch, so any set bit fails with
-NE_ERR_INVALID_FLAG_VALUE.

Signed-off-by: Alexander Graf <graf@amazon.com>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 53 +++++++++++++++++++++--
 include/uapi/linux/nitro_enclaves.h       | 48 ++++++++++++++++++++
 2 files changed, 97 insertions(+), 4 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index 38345ad7c7985..68c497df4f14b 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -2452,6 +2452,8 @@ static const struct file_operations ne_enclave_fops = {
  *			  enclave file descriptor to be further used for enclave
  *			  resources handling e.g. memory regions and CPUs.
  * @ne_pci_dev :	Private data associated with the PCI device.
+ * @flags:		Launch-time flag word from NE_CREATE_VM2, or zero when
+ *			the caller used the flag-less NE_CREATE_VM.
  * @slot_uid:		User pointer to store the generated unique slot id
  *			associated with an enclave to.
  *
@@ -2461,7 +2463,8 @@ static const struct file_operations ne_enclave_fops = {
  * * Enclave fd on success.
  * * Negative return value on failure.
  */
-static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 __user *slot_uid)
+static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 flags,
+			      u64 __user *slot_uid)
 {
 	struct ne_pci_dev_cmd_reply cmd_reply = {};
 	int enclave_fd = -1;
@@ -2472,6 +2475,13 @@ static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 __user *slot_ui
 	int rc = -EINVAL;
 	struct slot_alloc_req slot_alloc_req = {};
 
+	if (flags) {
+		dev_err_ratelimited(ne_misc_dev.this_device,
+				    "Unknown launch flag bit set 0x%llx\n", flags);
+
+		return -NE_ERR_INVALID_FLAG_VALUE;
+	}
+
 	mutex_lock(&ne_cpu_pool.mutex);
 
 	for (i = 0; i < ne_cpu_pool.nr_parent_vm_cores; i++)
@@ -2626,7 +2636,44 @@ static long ne_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (ne_pci_dev) {
 			rc = mutex_lock_killable(&ne_pci_dev->enclaves_list_mutex);
 			if (!rc) {
-				rc = ne_create_vm_ioctl(ne_pci_dev, slot_uid);
+				rc = ne_create_vm_ioctl(ne_pci_dev, 0, slot_uid);
+				mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
+			}
+		}
+
+		up_read(&ne_devs.lock);
+
+		return rc;
+	}
+	}
+
+	/* Extensible Argument ioctls */
+	switch (NE_EA_IOCTL(cmd)) {
+	case NE_EA_IOCTL(NE_CREATE_VM2): {
+		struct ne_create_vm_args args;
+		struct ne_create_vm_args __user *uargs = (void __user *)arg;
+		unsigned int usize = _IOC_SIZE(cmd);
+		struct ne_pci_dev *ne_pci_dev;
+		int rc;
+
+		if (usize < offsetofend(struct ne_create_vm_args, slot_uid))
+			return -EINVAL;
+
+		rc = copy_struct_from_user(&args, sizeof(args), uargs, usize);
+		if (rc)
+			return rc;
+
+		rc = down_read_killable(&ne_devs.lock);
+		if (rc)
+			return rc;
+
+		rc = -ENODEV;
+		ne_pci_dev = ne_devs.ne_pci_dev;
+		if (ne_pci_dev) {
+			rc = mutex_lock_killable(&ne_pci_dev->enclaves_list_mutex);
+			if (!rc) {
+				rc = ne_create_vm_ioctl(ne_pci_dev, args.flags,
+							&uargs->slot_uid);
 				mutex_unlock(&ne_pci_dev->enclaves_list_mutex);
 			}
 		}
@@ -2639,8 +2686,6 @@ static long ne_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	default:
 		return -ENOTTY;
 	}
-
-	return 0;
 }
 
 /*
diff --git a/include/uapi/linux/nitro_enclaves.h b/include/uapi/linux/nitro_enclaves.h
index 16515fe27b692..8e43be9a0a1fa 100644
--- a/include/uapi/linux/nitro_enclaves.h
+++ b/include/uapi/linux/nitro_enclaves.h
@@ -46,6 +46,54 @@
  */
 #define NE_CREATE_VM			_IOR(0xAE, 0x20, __u64)
 
+/**
+ * struct ne_create_vm_args - NE_CREATE_VM2 argument (in / out).
+ * @flags:	Launch-time flag word (in). Flags select properties of the
+ *		enclave slot that the hypervisor has to know at allocation
+ *		time. NE_ENCLAVE_DEBUG_MODE stays a start-time property and
+ *		is rejected here.
+ * @slot_uid:	Generated unique slot id associated with an enclave (out).
+ */
+struct ne_create_vm_args {
+	__u64	flags;
+	__u64	slot_uid;
+};
+
+/**
+ * NE_CREATE_VM2 - As NE_CREATE_VM, additionally taking a launch-time flag
+ *		   word. The flags carry properties of the slot that have to
+ *		   be decided when the slot is allocated rather than when the
+ *		   enclave starts.
+ *
+ *		   NE_CREATE_VM continues to work; calling it is equivalent
+ *		   to calling NE_CREATE_VM2 with a zero flag word.
+ *
+ *		   The argument is read with copy_struct_from_user(), so a
+ *		   caller built against a header that predates a field this
+ *		   kernel knows leaves that field zero, and a caller that
+ *		   sets a field this kernel does not know is refused.
+ *
+ * Context: Process context.
+ * Return:
+ * * Enclave file descriptor		- As for NE_CREATE_VM.
+ * *  -1				- There was a failure in the ioctl logic.
+ * On failure, errno is set to:
+ * * ENODEV				- The NE PCI device is not available.
+ * * EFAULT				- Argument read or write failure.
+ * * NE_ERR_INVALID_FLAG_VALUE		- Unknown flag bit set, or
+ *					  NE_ENCLAVE_DEBUG_MODE set.
+ * * EINVAL				- The argument stops before @slot_uid.
+ * * E2BIG				- The argument carries a field this kernel
+ *					  does not know, set to a non-zero value.
+ * * ENOMEM				- Memory allocation failure for internal
+ *					  bookkeeping variables.
+ * * NE_ERR_NO_CPUS_AVAIL_IN_POOL	- No NE CPU pool set / no CPUs available
+ *					  in the pool.
+ * * Error codes from get_unused_fd_flags() and anon_inode_getfile().
+ * * Error codes from the NE PCI device request.
+ */
+#define NE_CREATE_VM2			_IOWR(0xAE, 0x30, struct ne_create_vm_args)
+
 /**
  * NE_ADD_VCPU - The command is used to set a vCPU for an enclave. The vCPU can
  *		 be auto-chosen from the NE CPU pool or it can be set by the
-- 
2.47.1


