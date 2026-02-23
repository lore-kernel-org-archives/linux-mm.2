Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2704FEEC2AD
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 23:27:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60B376B0005; Mon, 23 Feb 2026 18:27:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B9A06B0089; Mon, 23 Feb 2026 18:27:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B8286B008A; Mon, 23 Feb 2026 18:27:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 370906B0005
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:27:44 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C4B361A0343
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:27:43 +0000 (UTC)
X-FDA: 84477310806.03.A857E85
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf20.hostedemail.com (Postfix) with ESMTP id F32601C000E
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:27:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WfdexdTy;
	spf=pass (imf20.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771889262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+9xRDS+GbzpVTn5dJQsaYxoqI8Nli76XDWLyH8tQ4yc=;
	b=dmdf8vEp1vR1MR6+4GanO0cSBX2EXn6HErQTcIENOsblS5pO79DMJfOFuifADHzHbjM4jM
	9pgwaLL0iKZzkU7zcZiHUuLS9c3KyNn+Xc8K/KwzQ51l71qMXi4bbM9SfeWpXjnxmjxVOx
	NrXFSFH8M1HYXe7uJzxj7N8L6j09ui4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WfdexdTy;
	spf=pass (imf20.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771889262; a=rsa-sha256;
	cv=none;
	b=i/MEmZHw8LeLkX1bH7FqHqSnGCw+10w8TAB92jvV68s9poWqO4y2iOnGaf1o21E0BAiLuX
	4IiuqfxvYN4GO58tiFbymsiqXMUguvqpO0kzUdsIxhzHrOdhkmBB2tWKGcP7pQI+G1TYdW
	VP6lJxwtQJ4oQbtZwCcPCNU4Niy3sVc=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2a964077671so31955ad.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:27:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771889261; x=1772494061; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+9xRDS+GbzpVTn5dJQsaYxoqI8Nli76XDWLyH8tQ4yc=;
        b=WfdexdTyTgUUgbZwrEgy7B1rBkdI2yyFm4ACjACqgfRY5QcyTC2VEQZWphTlsJNZKo
         MsYnIb9YDqmGrM6J7tiZmobcN0jq/LeuCTpz8MKtRTKXYXcVsymscn78rkK2H1/wmPR9
         b1JabzPe4ZZuajREOlDDpstLYqEidiftEulvERr/1GgSiv4Hf1iJU6Kso0RpeLjTh7A1
         ws+zfPy/rQPyTbt8PLtY4EgQuNo6PHelGWY4oVyaKcQVS0qKigfNYsQbLrWTmHixn+pp
         U1157NqdhzHb0/ri31bpnX3Uymku0KTV7YVCQF4R1a9ymwVE1es9wBdaegMj7s/JWkuI
         eslA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771889261; x=1772494061;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+9xRDS+GbzpVTn5dJQsaYxoqI8Nli76XDWLyH8tQ4yc=;
        b=RLLAP45/A+TJ5dgR9czA1cJmTElnfom9sufrTTmOEcrmDPHzNSqzqATDK445Ny68p6
         45DrCXmIWypZ3ZWrEOARdKMOblGHi8TEXzmE80ZHWGgR6AujbWl8Bf48oqo1GTlkr/ag
         r60tlKiTijiBonXty1Y5PCnMvuY9hHJJWyPBF2e7b81rkNwfPz3FUv2RCiIP/2/Bdr+o
         /ak32BNSas4yhFWV6TM0u1vUSidZShVbHAbBFjJc3/TsV9uCpXBt+m7M3K7CFQ1sVfJY
         e/vC9kC2YYuK6D63OcCZmi3e39tmbxJiheX59jhcj/1atqAYWPRbWHig7gGcjAiOw+gr
         P8HA==
X-Forwarded-Encrypted: i=1; AJvYcCUS2ORdYSO6I6KWwZWi6oka+ecok8LbQAxZmMfXB0+GB8FwwP+kxjdZnjgNaxk+YJ1C/Ssr3TLqgQ==@kvack.org
X-Gm-Message-State: AOJu0YyUZ2FxpqjHYlc18waMI+RjWppf+YnPTM74zMokKKyJ2umailil
	Om860nJASX4eFbAvooHta9v2kiREIQzC0jdXrUq2eBxo0L5b5C76xKz/iIoY4GDNhg==
X-Gm-Gg: ATEYQzwcQqhieyqdPRT43xNN/uP7WQ5e1jkD7h10ftMv+eDeZ3Zdnu8dIFJwS/rh64p
	MZMiMD5wdFM6sXVloJw4wLJP3ALklPC8n2taC/S7yp/VuKvnP/4b2p35hE++EcYy6vOixbVjQxt
	CYI/a3OhtqqnouT9eT3PnGIzPrMXfls6o4QHxH72zBvimW/OtYnZqT5OLGF3c04/hpX+WoqB9ua
	yseRJNg4dvvsl/hWZmJ0m2CRArH2dfeCJfAel5qgzclIxuny8u+T7uShLtk/hQ+crYRy+V/zK0y
	xsmKU9Si0kabzN6QgqZfoZw9aqU74t6fkAGood6oeDlHNWz4SAaK1l46KMePfwK8LufjfeU+8k6
	s5TB37/Px0solqxsf3Eh8i5PaSzuu7z9MrTT75VFZtFz0YzadRjAFnq5uJsuylgEpxGjQfWnDnT
	PeeCLf0jVIZ85OIP4yP5opajfVqODCPgql4F5FEO2U7Mb7nQD3ByNgQLuOoUf4bg==
X-Received: by 2002:a17:903:1968:b0:2a0:89b0:71d6 with SMTP id d9443c01a7336-2ada34bcd22mr245115ad.17.1771889260189;
        Mon, 23 Feb 2026 15:27:40 -0800 (PST)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad7500e318sm81858705ad.43.2026.02.23.15.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 15:27:39 -0800 (PST)
Date: Mon, 23 Feb 2026 23:27:35 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Alex Williamson <alex@shazbot.org>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	Thomas =?utf-8?Q?Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, Tomita Moeko <tomitamoeko@gmail.com>, 
	Vipin Sharma <vipinsh@google.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 06/22] vfio/pci: Retrieve preserved device files after
 Live Update
Message-ID: <bz7mhzvgawf4loxbv74iodj6aaf4e2snlb7szgjk2lia2uxnhr@dcp3m3jl3i63>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-7-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-7-dmatlack@google.com>
X-Stat-Signature: 1fq5nkk8cjazxtk4cxxpej73uxt5jpn1
X-Rspam-User: 
X-Rspamd-Queue-Id: F32601C000E
X-Rspamd-Server: rspam01
X-HE-Tag: 1771889261-398371
X-HE-Meta: U2FsdGVkX18eRKy2eIDR01A1Dp+2LXYVk1TBSxGmIQEaIlznCCOIqutXn9p2WEdXTJsTCNjjrpEof2rGr62cDVnQSgDl09wLrnw5oBkNWfONqEPxZ2nsUIEkiDNaWqJF3d5RF/G1+wFRyF9fi2YwFO8yASNClD4A+HYCf9cw2ZZb3UBt/sLG8cCmSYUa7AsCN/M1kwrXWUlUmC5GhwSgrzsg7NaZuwJde5HRozNUoDVaZoiDnNyV2CQ6mjdQIpwpdW8NEbPLkU5U3IeA4VfLyfUXP73pOWCa+tjowR6UoDu/EgtfczmWmxekXqW9WHtvNce6+SbBxVowepJlMO5XtFfybZ/GROjffnojJ+EVjLl2mGhPAH4h3OdbrxTQMDf1/JDcVFEhbaOt1iCpAEBTsn7xzP3ElZ3OGzAm2d4SnN5bocZFHAV4wl89L7SS+zRbt4gmXH/bWVBA1L2DILsz9lmXf4c5z0/jfHcfJql7E9FN1hnpdIMUq7IMaibHyNfsRK2NHF02SuhOv+LCqIBvO/HnshnMj3TujgGEexqIgq7R7eDQHSXdfVpbR+HeilYXDgAg0vLTZNAeNzzR4WQxJbShD5d9PNb/VQiPezAPYXENLkYPDjiG5Inc5J7l7LC8h+X0FtFrTVyKGNxBwc8sOut/0U+SExKkgNtj/jDw4VQY+tNBFyzdTH4k8Cj4QNVSNTEx3ZViklBtZbR470sbr0kQUqX12FOJxxEP3viPz7hlLtCyca0pgBU+uQ6W/vpEtHIXcBh0DD3eyJYZXg0f0zkFaK1LddsD0gdEITPhlmOVXYW7C0vy+a4Nhoa33gkwvjJoUhjlG4qtwY9xqfhhMWb6S7Bva6dA+njVuEWcHrn5mTlXltjkTrAwXy+KpJreuO8FeN1RSjb5JorhPTrhq0jgHdSSZ1atkWRfdfYANBevhCiAJ2VU34He6e6iPRhGmNRYxORwhr4M2Ee0efp
 XOcDL6on
 WOaXjHGKDn73OcZA3UsCHUf/Sy5KbeuqVbNRXgkqUb/WHPLTuEBZBSurHREvQbnJDKO7ZLTPcsHY2B1ZT/vavuJlYILJLIDkZJyjtA6LTx12KbtFqF14QwC6c6zrhqwAuK68Bnm2iB6zDVIo7IMiflcqzaVG8mnl+JzIxpMCw9o8GBZMhPvq/6fRe3lvVfMANJhpbmSKdz5XtDUdlV0szETZ+4D3SRQj6uD+EW/K06fF7WaNhiZZDG5n0Cf7qEiZC+WvrFyiDTtZACuH3WTJaSeVjUrWlqEjfFtJ/EcB056B/cGw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 09:24:53PM +0000, David Matlack wrote:
>From: Vipin Sharma <vipinsh@google.com>
>
>Enable userspace to retrieve preserved VFIO device files from VFIO after
>a Live Update by implementing the retrieve() and finish() file handler
>callbacks.
>
>Use an anonymous inode when creating the file, since the retrieved
>device file is not opened through any particular cdev inode, and the
>cdev inode does not matter in practice.
>
>For now the retrieved file is functionally equivalent a opening the
>corresponding VFIO cdev file. Subsequent commits will leverage the
>preserved state associated with the retrieved file to preserve bits of
>the device across Live Update.
>
>Signed-off-by: Vipin Sharma <vipinsh@google.com>
>Co-developed-by: David Matlack <dmatlack@google.com>
>Signed-off-by: David Matlack <dmatlack@google.com>
>---
> drivers/vfio/device_cdev.c             | 21 ++++++---
> drivers/vfio/pci/vfio_pci_liveupdate.c | 60 +++++++++++++++++++++++++-
> drivers/vfio/vfio_main.c               | 13 ++++++
> include/linux/vfio.h                   | 12 ++++++
> 4 files changed, 98 insertions(+), 8 deletions(-)
>
>diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
>index 8ceca24ac136..935f84a35875 100644
>--- a/drivers/vfio/device_cdev.c
>+++ b/drivers/vfio/device_cdev.c
>@@ -16,14 +16,8 @@ void vfio_init_device_cdev(struct vfio_device *device)
> 	device->cdev.owner = THIS_MODULE;
> }
>
>-/*
>- * device access via the fd opened by this function is blocked until
>- * .open_device() is called successfully during BIND_IOMMUFD.
>- */
>-int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
>+int __vfio_device_fops_cdev_open(struct vfio_device *device, struct file *filep)
> {
>-	struct vfio_device *device = container_of(inode->i_cdev,
>-						  struct vfio_device, cdev);
> 	struct vfio_device_file *df;
> 	int ret;
>
>@@ -52,6 +46,19 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
> 	vfio_device_put_registration(device);
> 	return ret;
> }
>+EXPORT_SYMBOL_GPL(__vfio_device_fops_cdev_open);
>+
>+/*
>+ * device access via the fd opened by this function is blocked until
>+ * .open_device() is called successfully during BIND_IOMMUFD.
>+ */
>+int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
>+{
>+	struct vfio_device *device = container_of(inode->i_cdev,
>+						  struct vfio_device, cdev);
>+
>+	return __vfio_device_fops_cdev_open(device, filep);
>+}
>
> static void vfio_df_get_kvm_safe(struct vfio_device_file *df)
> {
>diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
>index f01de98f1b75..7f4117181fd0 100644
>--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
>+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
>@@ -8,6 +8,8 @@
>
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
>+#include <linux/anon_inodes.h>
>+#include <linux/file.h>
> #include <linux/kexec_handover.h>
> #include <linux/kho/abi/vfio_pci.h>
> #include <linux/liveupdate.h>
>@@ -108,13 +110,68 @@ static int vfio_pci_liveupdate_freeze(struct liveupdate_file_op_args *args)
> 	return ret;
> }
>
>+static int match_device(struct device *dev, const void *arg)
>+{
>+	struct vfio_device *device = container_of(dev, struct vfio_device, device);
>+	const struct vfio_pci_core_device_ser *ser = arg;
>+	struct pci_dev *pdev;
>+
>+	pdev = dev_is_pci(device->dev) ? to_pci_dev(device->dev) : NULL;
>+	if (!pdev)
>+		return false;
>+
>+	return ser->bdf == pci_dev_id(pdev) && ser->domain == pci_domain_nr(pdev->bus);
>+}
>+
> static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
> {
>-	return -EOPNOTSUPP;
>+	struct vfio_pci_core_device_ser *ser;
>+	struct vfio_device *device;
>+	struct file *file;
>+	int ret;
>+
>+	ser = phys_to_virt(args->serialized_data);
>+
>+	device = vfio_find_device(ser, match_device);
>+	if (!device)
>+		return -ENODEV;
>+
>+	/*
>+	 * Simulate opening the character device using an anonymous inode. The
>+	 * returned file has the same properties as a cdev file (e.g. operations
>+	 * are blocked until BIND_IOMMUFD is called).
>+	 */
>+	file = anon_inode_getfile_fmode("[vfio-device-liveupdate]",
>+					&vfio_device_fops, NULL,
>+					O_RDWR, FMODE_PREAD | FMODE_PWRITE);
>+	if (IS_ERR(file)) {
>+		ret = PTR_ERR(file);
>+		goto out;
>+	}
>+
>+	ret = __vfio_device_fops_cdev_open(device, file);
>+	if (ret) {
>+		fput(file);
>+		goto out;
>+	}
>+
>+	args->file = file;
>+
>+out:
>+	/* Drop the reference from vfio_find_device() */
>+	put_device(&device->device);
>+
>+	return ret;
>+}
>+
>+static bool vfio_pci_liveupdate_can_finish(struct liveupdate_file_op_args *args)
>+{
>+	return args->retrieved;
> }
>
> static void vfio_pci_liveupdate_finish(struct liveupdate_file_op_args *args)
> {
>+	kho_restore_free(phys_to_virt(args->serialized_data));
> }
>
> static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
>@@ -123,6 +180,7 @@ static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
> 	.unpreserve = vfio_pci_liveupdate_unpreserve,
> 	.freeze = vfio_pci_liveupdate_freeze,
> 	.retrieve = vfio_pci_liveupdate_retrieve,
>+	.can_finish = vfio_pci_liveupdate_can_finish,
> 	.finish = vfio_pci_liveupdate_finish,
> 	.owner = THIS_MODULE,
> };
>diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
>index 276f615f0c28..89c5feef75d5 100644
>--- a/drivers/vfio/vfio_main.c
>+++ b/drivers/vfio/vfio_main.c
>@@ -13,6 +13,7 @@
> #include <linux/cdev.h>
> #include <linux/compat.h>
> #include <linux/device.h>
>+#include <linux/device/class.h>
> #include <linux/fs.h>
> #include <linux/idr.h>
> #include <linux/iommu.h>
>@@ -1758,6 +1759,18 @@ int vfio_dma_rw(struct vfio_device *device, dma_addr_t iova, void *data,
> }
> EXPORT_SYMBOL(vfio_dma_rw);
>
>+struct vfio_device *vfio_find_device(const void *data, device_match_t match)
>+{
>+	struct device *device;
>+
>+	device = class_find_device(vfio.device_class, NULL, data, match);
>+	if (!device)
>+		return NULL;
>+
>+	return container_of(device, struct vfio_device, device);
>+}
>+EXPORT_SYMBOL_GPL(vfio_find_device);
>+
> /*
>  * Module/class support
>  */
>diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>index 9aa1587fea19..dc592dc00f89 100644
>--- a/include/linux/vfio.h
>+++ b/include/linux/vfio.h
>@@ -419,4 +419,16 @@ int vfio_virqfd_enable(void *opaque, int (*handler)(void *, void *),
> void vfio_virqfd_disable(struct virqfd **pvirqfd);
> void vfio_virqfd_flush_thread(struct virqfd **pvirqfd);
>
>+#if IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV)
>+int __vfio_device_fops_cdev_open(struct vfio_device *device, struct file *filep);
>+#else
>+static inline int __vfio_device_fops_cdev_open(struct vfio_device *device,
>+					       struct file *filep)
>+{
>+	return -EOPNOTSUPP;
>+}
>+#endif /* IS_ENABLED(CONFIG_VFIO_DEVICE_CDEV) */
>+
>+struct vfio_device *vfio_find_device(const void *data, device_match_t match);
>+
> #endif /* VFIO_H */
>-- 
>2.53.0.rc1.225.gd81095ad13-goog
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

