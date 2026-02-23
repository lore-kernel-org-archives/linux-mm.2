Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E38FEEC2A0
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 22:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1E326B0089; Mon, 23 Feb 2026 17:29:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC8926B008A; Mon, 23 Feb 2026 17:29:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8D6D6B008C; Mon, 23 Feb 2026 17:29:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 921336B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 17:29:11 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 35FF3138385
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:29:11 +0000 (UTC)
X-FDA: 84477163302.05.C8235A6
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5740CA000B
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 22:29:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zLa6lUY0;
	spf=pass (imf25.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771885749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C8f6dXcdZJeSJ2qE0ghvpNFkqtAaZ6dotEKElaryP78=;
	b=c5RaoNMKAv1CdtnMnfhxxG69PsofT2ZX/UHXEnaZ4RrqR4koq+HA65EJC9w/pYDVjKY1by
	zA9aCb1Orp0pt1kptul/58JQA0cqAUbrIN27dKgcbRPx+ArnSlqDSbUj1yomM5xyGulzv1
	IiLSxzXEoqeUTYTqFimiXOEO9TumGE8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771885749; a=rsa-sha256;
	cv=none;
	b=cNOF7tQwd2vGuSZ25+/fCQlRYhqXs0tK/IEcVC4pf3Fv/VdZCTo4OuIgo0hqH2/VoiBlRW
	AZ/z7luDMnDjsq4pIL3GpPKKrrtTtXK4fpGiA/LHC3Ef9fvI8JKPnrdqUP/wy9J08vv4WM
	NSYxp1eMS0Uu737pjYOlw+YMVyAK62c=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=zLa6lUY0;
	spf=pass (imf25.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a76b39587aso30125ad.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 14:29:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771885748; x=1772490548; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=C8f6dXcdZJeSJ2qE0ghvpNFkqtAaZ6dotEKElaryP78=;
        b=zLa6lUY0Wfk84sCGIuNK6XvRq6q3nXi57NYd4+yvaAr1+Nn6kFm31qFyF2CmOV68XE
         zqgj9aC3DJR/C2Q+TXJxCQqPwhY0PZGpglNS6atJT1F1PybbZRssfaxz84HXCmRUzeVG
         HHzr63lZIp4ZJRaeH1lSVS96WvGHiqlp9ZZg4+Oo23PR2VHkLSmv1MwpqPRJUTBBKGrl
         KbPZYQZMHSeexvUOcVqcKrhxCIJ4m03lWRTm4QgDUBnwC6MSEPahiABuWTgSI538F43T
         kf2fLtuENYfvtcwmCqKgHFU1RpE7Bi0BdcL0F6Afn4p777acwmRX1JPqo+JyBj+oc7E2
         9/HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771885748; x=1772490548;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=C8f6dXcdZJeSJ2qE0ghvpNFkqtAaZ6dotEKElaryP78=;
        b=Fm9Jx1PdPdWtebbwIYmVMOKwps5oTrwIqPjeLLU1r8kiIamJyStMHNMXDKjdUU5UEq
         FR+77TZie44y6JDHXJAHEpH+JQh5g12FHcl6f+7ZWd9BIjOWLSVExIu85SfB14CsBi3s
         nS1XmQSNJXJKEYZ0KG9MJ5YVGJWnalb4Rzcfu3XjxY4nJjE4ifWK/KiSdqjSacav3CPj
         SxDru9xMUfGbbOtrSbQjYZqtcrIp7MAckmPWEZ7De5q2+ztiXLZbf+0Ulm/2UBqp/AKE
         UenWAEuz6ei89ebZEbhI0+rrn89+uXgJu+q53cFUgUyIoWjinq6WFDnzt81SxhKYD+qo
         bpqQ==
X-Forwarded-Encrypted: i=1; AJvYcCWn1tH0AlEbEeBXifhKj92V60wdRz6Et7R7iWENteDC+qoZVOklpHHFXVm6Tamgb3hEVhSAeSvEug==@kvack.org
X-Gm-Message-State: AOJu0YzL7gEijJm5Q72RrQp/574tPMzBhQdu6xnWsImvv81HlJCkB56j
	tSBrE51RnOiwjOEb3+dkSWGGFW2cK9//Yn3e23lirXWPFro1xK3BttWSAwzPweByvg==
X-Gm-Gg: ATEYQzznz+BVRC4RNedll4axXpR31b5T2LMMEy9HkR2mMEnVgTLtH7wEhjHhbcV4c17
	assY8y0N8G0gGc00JXZp9b+W9GVykQ2l+RiGcvThMkp2+R4Kavl89iUq4/jGbglyRQOt0LstO7m
	yPde/93yj5Bd0oyYUk3DKmVUJhpl/U4NJxpJ71EZkg0RjY7mP2SRF2pSjZc4GCgjBTTWlhUtEtH
	kOttU+XWYpQgtvtyOWjB9SHZx1oQC0+t/u8j6C1BtibIlEygCOAQOJDj9hnGU4YYew9DpP7IL5n
	GE/AlY6rl+fq35hvmTexRMyn6dRcgXDoUeOLFMyK+1wiyV1VxK0eYQCcz5tdoSltxPTlv36J1x5
	KoJvrjBGLZEZ6FEthve2qgur8UmC3Edxu+QqnI+bopsF5kVx0+BOCXtP0nS0fwM6U9YJ0l9pxXK
	baBdIRm+MXBCEsUa8pWIiJ8TsKwkLYNMuOlko0QXHLjTJaruZ8Lwt+KSe3VSO7AA==
X-Received: by 2002:a17:902:ec89:b0:2a9:5ef5:399b with SMTP id d9443c01a7336-2ada3497c30mr138295ad.19.1771885747713;
        Mon, 23 Feb 2026 14:29:07 -0800 (PST)
Received: from google.com (168.136.83.34.bc.googleusercontent.com. [34.83.136.168])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-826dd8ba11bsm8507152b3a.50.2026.02.23.14.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 14:29:07 -0800 (PST)
Date: Mon, 23 Feb 2026 22:29:03 +0000
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
Subject: Re: [PATCH v2 05/22] vfio/pci: Preserve vfio-pci device files across
 Live Update
Message-ID: <qshnqqtfg7clbcqoq45ei55wt6xt4z4xtwv5ehjyjxwq47cwng@n3vd3lxigcs6>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-6-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260129212510.967611-6-dmatlack@google.com>
X-Rspamd-Server: rspam09
X-Stat-Signature: 4kbt85q4u39q1c7j88o6cue174c18o14
X-Rspamd-Queue-Id: 5740CA000B
X-Rspam-User: 
X-HE-Tag: 1771885749-221335
X-HE-Meta: U2FsdGVkX18XVAqQ/9JfYQdXCW0rIbHzG6o5vlJGiLmi3XYI1X7YabkOO54v9inI4sVTLQSYAohTWJO0YLvrmv1K7KDDKENP2EN25SN4cAUAR3hlgVeA46ort+AdYU+lXKV/xrhS9pQ3Ej4czOQMGVcQ+9kUyvs8qslaNoOZg+6//wiiEkHdjqceKWqGJSHdKohwMYQ6TRrHSTwDwpsZv0pLCoUl2ItnifwpQpsT3LweDLZQslkRy1YoiJDwQ90N7f7iFzcBjl9CMiIDOdxIWrNC7NypTcHV7X1mzVNh8QZBSQQ2ojc4ImsFkGhQZ/bRaAX6TM4Oa+vP6XuLVtvPzD9b9GGZblSmnrcKxGJJPqbjga7jrjyusUMyOURLVuezhwg0jhVVPuJCglqnEc6HXFBY23hb9iPXSmdZzVJz7pcL7qtnC0SNEN+RE3wKKvDNJh6FaPXwEi+l5SjoASGQvvp4XhHIBj1vsK4QYnK3y/9yfBHQtaxUcLEiNQt5W6ubPi9l3ZEl+Q/Ae3w0E8uDCmC+Tab78pAxgTMg0XxqA/790Z7AELg0HFGvTBQb4GfpFbo0CE5Hi1kB7fdHCiNbSrk4Mo8e3d51kQ3+ooF4taHOatX/lnTBKQWSSHlusuFeVE0QwHG3OPgiyTFikoi22TTLh+k6GNdpepxFadDwVqKBqvB0qQUZwGHYkGlu4UM6BChW/L4nIKmjSFC8kPb9Q/vuCB1Bi2LX8U0cIoxjtOc6m48FIv14DD3cQHoEieeMpJP/kSwDlOglDgINj6tSMPQa/PVul/rEnbdhMcvrNeontSg8GfMbWywVR0syrGiFlpjk+5ClUDre/y6GbcnkrWLWpsmKEksGvHd6qA+j2cy1r323uO1JMA/ck7SHKXxrRP/9q/dErMyfjIJNFsWIm7PKeYyy5VvbH9mXa2NPH5syUYZVwIGoyRjhSfqhK0owddOXAPTOgdOjEHWfKZp
 QpXmHNTO
 LwJ3PhLIe/ThE8EWV9kpPEidLJoXHUfLOjYQQE/lgETdte5GoGjNm1Znn3+Q0IF3bhZ3UZyi9TgO+lIC/uXoQurTLY0scMKrpuPKjxW7TUvhTI/9rSh96x2T8APJfknpCO7ZG5KIkfwfWB0xtkY3dCudshbCE3A/etuGjjJQD40RvuonmfoiqAIMMjG6E562anQLdjtP6bpW2wa2E0B+JMoCLyMwybb+ov7ilVwTgrIs22+rZB0wGd1mLBNVn3w0vM8FNKfmfS8P8s4BhYq6X0z60fU3q/a64Nojo4GvVXGUtbnJOA8bJR33VmkI/9zA2+C9lkP4C/LtBAw31FbgNW0/7Dw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 29, 2026 at 09:24:52PM +0000, David Matlack wrote:
>From: Vipin Sharma <vipinsh@google.com>
>
>Implement the live update file handler callbacks to preserve a vfio-pci
>device across a Live Update. Subsequent commits will enable userspace to
>then retrieve this file after the Live Update.
>
>Live Update support is scoped only to cdev files (i.e. not
>VFIO_GROUP_GET_DEVICE_FD files).
>
>State about each device is serialized into a new ABI struct
>vfio_pci_core_device_ser. The contents of this struct are preserved
>across the Live Update to the next kernel using a combination of
>Kexec-Handover (KHO) to preserve the page(s) holding the struct and the
>Live Update Orchestrator (LUO) to preserve the physical address of the
>struct.
>
>For now the only contents of struct vfio_pci_core_device_ser the
>device's PCI segment number and BDF, so that the device can be uniquely
>identified after the Live Update.
>
>Require that userspace disables interrupts on the device prior to
>freeze() so that the device does not send any interrupts until new
>interrupt handlers have been set up by the next kernel.
>
>Reset the device and restore its state in the freeze() callback. This
>ensures the device can be received by the next kernel in a consistent
>state. Eventually this will be dropped and the device can be preserved
>across in a running state, but that requires further work in VFIO and
>the core PCI layer.
>
>Note that LUO holds a reference to this file when it is preserved. So
>VFIO is guaranteed that vfio_df_device_last_close() will not be called
>on this device no matter what userspace does.
>
>Signed-off-by: Vipin Sharma <vipinsh@google.com>
>Co-developed-by: David Matlack <dmatlack@google.com>
>Signed-off-by: David Matlack <dmatlack@google.com>
>---
> drivers/vfio/pci/vfio_pci.c            |  2 +-
> drivers/vfio/pci/vfio_pci_liveupdate.c | 84 +++++++++++++++++++++++++-
> drivers/vfio/pci/vfio_pci_priv.h       |  2 +
> drivers/vfio/vfio.h                    | 13 ----
> drivers/vfio/vfio_main.c               | 10 +--
> include/linux/kho/abi/vfio_pci.h       | 15 +++++
> include/linux/vfio.h                   | 28 +++++++++
> 7 files changed, 129 insertions(+), 25 deletions(-)
>
>diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
>index 19e88322af2c..0260afb9492d 100644
>--- a/drivers/vfio/pci/vfio_pci.c
>+++ b/drivers/vfio/pci/vfio_pci.c
>@@ -125,7 +125,7 @@ static int vfio_pci_open_device(struct vfio_device *core_vdev)
> 	return 0;
> }
>
>-static const struct vfio_device_ops vfio_pci_ops = {
>+const struct vfio_device_ops vfio_pci_ops = {
> 	.name		= "vfio-pci",
> 	.init		= vfio_pci_core_init_dev,
> 	.release	= vfio_pci_core_release_dev,
>diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
>index b84e63c0357b..f01de98f1b75 100644
>--- a/drivers/vfio/pci/vfio_pci_liveupdate.c
>+++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
>@@ -8,25 +8,104 @@
>
> #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>
>+#include <linux/kexec_handover.h>
> #include <linux/kho/abi/vfio_pci.h>
> #include <linux/liveupdate.h>
> #include <linux/errno.h>
>+#include <linux/vfio.h>
>
> #include "vfio_pci_priv.h"
>
> static bool vfio_pci_liveupdate_can_preserve(struct liveupdate_file_handler *handler,
> 					     struct file *file)
> {
>-	return false;
>+	struct vfio_device_file *df = to_vfio_device_file(file);
>+
>+	if (!df)
>+		return false;
>+
>+	/* Live Update support is limited to cdev files. */
>+	if (df->group)
>+		return false;
>+
>+	return df->device->ops == &vfio_pci_ops;
> }
>
> static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
> {
>-	return -EOPNOTSUPP;
>+	struct vfio_device *device = vfio_device_from_file(args->file);
>+	struct vfio_pci_core_device_ser *ser;
>+	struct vfio_pci_core_device *vdev;
>+	struct pci_dev *pdev;
>+
>+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
>+	pdev = vdev->pdev;
>+
>+	if (IS_ENABLED(CONFIG_VFIO_PCI_ZDEV_KVM))
>+		return -EINVAL;
>+
>+	if (vfio_pci_is_intel_display(pdev))
>+		return -EINVAL;
>+
>+	ser = kho_alloc_preserve(sizeof(*ser));
>+	if (IS_ERR(ser))
>+		return PTR_ERR(ser);
>+
>+	ser->bdf = pci_dev_id(pdev);
>+	ser->domain = pci_domain_nr(pdev->bus);
>+
>+	args->serialized_data = virt_to_phys(ser);
>+	return 0;
> }
>
> static void vfio_pci_liveupdate_unpreserve(struct liveupdate_file_op_args *args)
> {
>+	kho_unpreserve_free(phys_to_virt(args->serialized_data));
>+}
>+
>+static int vfio_pci_liveupdate_freeze(struct liveupdate_file_op_args *args)
>+{
>+	struct vfio_device *device = vfio_device_from_file(args->file);
>+	struct vfio_pci_core_device *vdev;
>+	struct pci_dev *pdev;
>+	int ret;
>+
>+	vdev = container_of(device, struct vfio_pci_core_device, vdev);
>+	pdev = vdev->pdev;
>+
>+	guard(mutex)(&device->dev_set->lock);
>+
>+	/*
>+	 * Userspace must disable interrupts on the device prior to freeze so
>+	 * that the device does not send any interrupts until new interrupt
>+	 * handlers have been established by the next kernel.
>+	 */
>+	if (vdev->irq_type != VFIO_PCI_NUM_IRQS) {
>+		pci_err(pdev, "Freeze failed! Interrupts are still enabled.\n");
>+		return -EINVAL;
>+	}
>+
>+	pci_dev_lock(pdev);
>+
>+	ret = pci_load_saved_state(pdev, vdev->pci_saved_state);
>+	if (ret)
>+		goto out;
>+
>+	/*
>+	 * Reset the device and restore it back to its original state before
>+	 * handing it to the next kernel.
>+	 *
>+	 * Eventually both of these should be dropped and the device should be
>+	 * kept running with its current state across the Live Update.
>+	 */
>+	if (vdev->reset_works)
>+		ret = __pci_reset_function_locked(pdev);
>+
>+	pci_restore_state(pdev);
>+
>+out:
>+	pci_dev_unlock(pdev);
>+	return ret;
> }
>
> static int vfio_pci_liveupdate_retrieve(struct liveupdate_file_op_args *args)
>@@ -42,6 +121,7 @@ static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
> 	.can_preserve = vfio_pci_liveupdate_can_preserve,
> 	.preserve = vfio_pci_liveupdate_preserve,
> 	.unpreserve = vfio_pci_liveupdate_unpreserve,
>+	.freeze = vfio_pci_liveupdate_freeze,
> 	.retrieve = vfio_pci_liveupdate_retrieve,
> 	.finish = vfio_pci_liveupdate_finish,
> 	.owner = THIS_MODULE,
>diff --git a/drivers/vfio/pci/vfio_pci_priv.h b/drivers/vfio/pci/vfio_pci_priv.h
>index 68966ec64e51..d3da79b7b03c 100644
>--- a/drivers/vfio/pci/vfio_pci_priv.h
>+++ b/drivers/vfio/pci/vfio_pci_priv.h
>@@ -11,6 +11,8 @@
> /* Cap maximum number of ioeventfds per device (arbitrary) */
> #define VFIO_PCI_IOEVENTFD_MAX		1000
>
>+extern const struct vfio_device_ops vfio_pci_ops;
>+
> struct vfio_pci_ioeventfd {
> 	struct list_head	next;
> 	struct vfio_pci_core_device	*vdev;
>diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
>index 50128da18bca..6b89edbbf174 100644
>--- a/drivers/vfio/vfio.h
>+++ b/drivers/vfio/vfio.h
>@@ -16,17 +16,6 @@ struct iommufd_ctx;
> struct iommu_group;
> struct vfio_container;
>
>-struct vfio_device_file {
>-	struct vfio_device *device;
>-	struct vfio_group *group;
>-
>-	u8 access_granted;
>-	u32 devid; /* only valid when iommufd is valid */
>-	spinlock_t kvm_ref_lock; /* protect kvm field */
>-	struct kvm *kvm;
>-	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
>-};
>-
> void vfio_device_put_registration(struct vfio_device *device);
> bool vfio_device_try_get_registration(struct vfio_device *device);
> int vfio_df_open(struct vfio_device_file *df);
>@@ -34,8 +23,6 @@ void vfio_df_close(struct vfio_device_file *df);
> struct vfio_device_file *
> vfio_allocate_device_file(struct vfio_device *device);
>
>-extern const struct file_operations vfio_device_fops;
>-
> #ifdef CONFIG_VFIO_NOIOMMU
> extern bool vfio_noiommu __read_mostly;
> #else
>diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
>index f7df90c423b4..276f615f0c28 100644
>--- a/drivers/vfio/vfio_main.c
>+++ b/drivers/vfio/vfio_main.c
>@@ -1436,15 +1436,7 @@ const struct file_operations vfio_device_fops = {
> 	.show_fdinfo	= vfio_device_show_fdinfo,
> #endif
> };
>-
>-static struct vfio_device *vfio_device_from_file(struct file *file)
>-{
>-	struct vfio_device_file *df = file->private_data;
>-
>-	if (file->f_op != &vfio_device_fops)
>-		return NULL;
>-	return df->device;
>-}
>+EXPORT_SYMBOL_GPL(vfio_device_fops);
>
> /**
>  * vfio_file_is_valid - True if the file is valid vfio file
>diff --git a/include/linux/kho/abi/vfio_pci.h b/include/linux/kho/abi/vfio_pci.h
>index 37a845eed972..9bf58a2f3820 100644
>--- a/include/linux/kho/abi/vfio_pci.h
>+++ b/include/linux/kho/abi/vfio_pci.h
>@@ -9,6 +9,9 @@
> #ifndef _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
> #define _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H
>
>+#include <linux/compiler.h>
>+#include <linux/types.h>
>+
> /**
>  * DOC: VFIO PCI Live Update ABI
>  *
>@@ -25,4 +28,16 @@
>
> #define VFIO_PCI_LUO_FH_COMPATIBLE "vfio-pci-v1"
>
>+/**
>+ * struct vfio_pci_core_device_ser - Serialized state of a single VFIO PCI
>+ * device.
>+ *
>+ * @bdf: The device's PCI bus, device, and function number.
>+ * @domain: The device's PCI domain number (segment).
>+ */
>+struct vfio_pci_core_device_ser {
>+	u16 bdf;
>+	u16 domain;
>+} __packed;
>+
> #endif /* _LINUX_LIVEUPDATE_ABI_VFIO_PCI_H */
>diff --git a/include/linux/vfio.h b/include/linux/vfio.h
>index e90859956514..9aa1587fea19 100644
>--- a/include/linux/vfio.h
>+++ b/include/linux/vfio.h
>@@ -81,6 +81,34 @@ struct vfio_device {
> #endif
> };
>
>+struct vfio_device_file {
>+	struct vfio_device *device;
>+	struct vfio_group *group;
>+
>+	u8 access_granted;
>+	u32 devid; /* only valid when iommufd is valid */
>+	spinlock_t kvm_ref_lock; /* protect kvm field */
>+	struct kvm *kvm;
>+	struct iommufd_ctx *iommufd; /* protected by struct vfio_device_set::lock */
>+};
>+
>+extern const struct file_operations vfio_device_fops;
>+
>+static inline struct vfio_device_file *to_vfio_device_file(struct file *file)
>+{
>+	if (file->f_op != &vfio_device_fops)
>+		return NULL;
>+
>+	return file->private_data;
>+}
>+
>+static inline struct vfio_device *vfio_device_from_file(struct file *file)
>+{
>+	struct vfio_device_file *df = to_vfio_device_file(file);
>+
>+	return df ? df->device : NULL;
>+}
>+
> /**
>  * struct vfio_device_ops - VFIO bus driver device callbacks
>  *
>-- 
>2.53.0.rc1.225.gd81095ad13-goog
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

