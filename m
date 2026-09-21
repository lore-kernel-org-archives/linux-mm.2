Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E4ECC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 20:36:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 364BF6B008A; Mon, 21 Sep 2026 16:36:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3164A6B008C; Mon, 21 Sep 2026 16:36:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205F26B0092; Mon, 21 Sep 2026 16:36:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E591C6B008A
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 16:36:10 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61A151402C1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:36:10 +0000 (UTC)
X-FDA: 85238926500.16.A6FEAAD
Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9562840002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 20:36:08 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sJUcYrW3;
	spf=pass (imf07.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790022968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=groqaSpL753eNcDTGAY1Cn/tLSUz1r+DZjsuraXcs+A=;
	b=ZgroqKH7+DLlmT4AS2hjSBa6OarWdcvSEM1sPPJ7hcW0AMiMF8jeXzRbUwmf2i+7SVRiLA
	7U+i4rdu5H9FRZT4nrFTUJrwCni2b8stq2pvu33hrgD5Q5ZfCUZSYkRlULitxy8xxck27o
	bWO/sHZUJVuTjLyiFjxt8Bj1YN+Gsnc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790022968;
	b=iX8KyfTuftoOjH4LwjkyJPJ/4QTdtDsxaLV0DYU2uKKoChbFkDwVswCOPrzrGiPQ/NGxVV
	A9JVETTgBzCBV/h8Vdwxy/pZjXOkPFoY9EYsOloGwnwoscjXNnV7zTy0F+tbM+ZENQPgqF
	QzqU7YXgEtRiC/j3hBKgaYy61wa4VY4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sJUcYrW3;
	spf=pass (imf07.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.12 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pz2-f12.google.com with SMTP id d2e1a72fcca58-86212a185dcso3971284b3a.1
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790022967; x=1790627767; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=groqaSpL753eNcDTGAY1Cn/tLSUz1r+DZjsuraXcs+A=;
        b=sJUcYrW3m3xaWWfX7TT8Vo/2OWsp0PVc7L/5k/uMIcxrT8NUXi+rmbMtyW1YTkglNv
         6qt+fkTBqadRux8YVzOpS7OZteLMS3ZFRi60bqtQkSvMfs7GaEXNvXgp83rQzRVZjG9+
         m7pcNrJ8aaWVkXqZ563nFpuE8nNA5Tj6DRpWQeQiHQVqunX/yEQLgcrxpWNsGZGqilbs
         uxZYlFEG4NesSqPqjlJhqEt3eh7q7vTUX86zwzfBDMythUJnilROYnQMlz0ce58N4hQV
         7lHDbyLPrJLGq9E232J5uHB3sJtALhoh4wWhYW188JVnSfGdgefNOUCtECy40NWBb/ro
         9/AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790022967; x=1790627767;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=groqaSpL753eNcDTGAY1Cn/tLSUz1r+DZjsuraXcs+A=;
        b=QQTaX1jdJAaAwUo+eizks6rnFM2TTbqJfxBlZtReYXPl/HQc4f/cxGLbfrfwQQzolJ
         eDEfQ7XfIDlBgvcnjCuHoAxqLIwUIgPz1vs4IodZQTzS3q9AXH1iS+uEz4EFwMW4XrX0
         iDSbP+YgdlppwZ2kP4EEdSSbRo16wFy14m/seB9CpIQME4gnbCWiOpatZ/IcNZeraTds
         xrGBJ2OtUiV5e0skrmG+2CtSQeQmXz9IZUmDanRmwlDvwkwhPkYZUlprG5zGat/elT2V
         NdYkYOczCU00x7DDyXIjgXCDTBGyWiYkp29mDLtm8eoeBt+z3S1MhDyxyf7SKVYitqMh
         VFIA==
X-Forwarded-Encrypted: i=1; AKwUvBymAAfdbZFkgsyegFBh2q7E10J0fnIHG1deVs6U4ootQM2I9svC2TFI92qn20vLEDAzJNU2euBHXg==@kvack.org
X-Gm-Message-State: AFuF++mmuOpyc9MLoQS5frQGmTYwPibtYKw6miPY57Qi7Og1mbCB2VGq
	HA0Qh8hYdkO/buhcUaHHfUZalkiK0afuUBjGVKuZZ/yp0gbJI9EssBPtBaiWxD8zWQ==
X-Gm-Gg: AYBFou16vs6w/z6NZJwHhZL6HxBD96sPpU8oLBNjj8I3dkmECVgUafMs+PdI8yDkCiT
	O3CQS5zLyobQkZE45O1MTZk2PEHxsqzWjEOQ05Bj+gtKTy7E8UXj1cAZoYWDKJniShDtllPIwH0
	B14oKiVfE/1KOs6TiT916mktaeRZ8D/ontWOeeWb4E5wmZ5myjGh/vo1W0cLldpVUAANoA2celt
	RsgF0eV0j0gTikEpf8helkDeoWsceAh+Rjal+q7AQGktdZvYXNv1FBpPfRGS3UW5GuIRqvLUk0S
	rMpintR4p6+DhMt82RsGwV/O9OS/MgiPIxV+hmo71MqHUI2ZshtS+c/Cuohk0B3SMRaibkARV+J
	HK21GZjaete/oWi9hkME/nzjFlZb82Qj/PVsRNAoBCptcYDvRs1A80hRtLBRQ9gv/d8CdnAZjrl
	sxNYGug2i4i6hviDsXoF7gYU9FHXD+oY8TWXQsvDBYW1V1ggiRbbQ+wJnXDt3REyZ2wM0nuPUyA
	aDanFCeTfm1q7nM/gkaMS/U8nSUOHhNnxjvjbMF
X-Received: by 2002:a05:6a00:2e89:b0:874:708d:b63a with SMTP id d2e1a72fcca58-874dea03034mr17531732b3a.27.1790022966708;
        Mon, 21 Sep 2026 13:36:06 -0700 (PDT)
Received: from google.com (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87bf5785276sm45140b3a.8.2026.09.21.13.36.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 13:36:05 -0700 (PDT)
Date: Mon, 21 Sep 2026 20:36:01 +0000
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v9 08/13] PCI: Save and restore the ACS Control register
Message-ID: <arGVMaxfwEw_PkXy@google.com>
References: <20260918200640.887030-1-dmatlack@google.com>
 <20260918200640.887030-9-dmatlack@google.com>
 <20260918191846.2f68b23b@shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260918191846.2f68b23b@shazbot.org>
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: ps3e1q7gokjdaqc5aam448zhdq3c6s8u
X-Rspamd-Queue-Id: 9562840002
X-HE-Tag: 1790022968-639323
X-HE-Meta: U2FsdGVkX1/oUQNSacBJhmHWFyXhJGcoEa0e9G/Hlh9pYd1gE9v907bnh5cMdVGafmUVOEpfA9AyA+gn/kK6Otw0n/KSTyABnnplRmAYiE/84IwXwVNQH2/0EkF8FuItgR2c5/0dKupLe9n2rKhnXZQPwsYFht1znvl69BbZ0qz2g4c1J5JrejFfjbtsvbPycuw4bg/nyEqzfv4JAM1gvHDzFljSWuclPoxJcF4q2C/rH2vYcbYDAUPYMYxHG3pnoL2a/Ny1CoFVCs7/JG/DQTwCyVKQLKBHKGw8KuPygtEZYpEo0qmdsKzY6O7AqLBMyfuKBOEJRfM9v4p1Fs/sH6kVisuopOPRO0J0KJ1WqT8S67CMVuSziE8sV0a10Eu571D7P0E4KgVHCKwVKVXiXmt1IGigU33HrhPFCeZSJ8t2n61apJ3scSfFlqtiw2AcocWw1YZAwFqmRSM+FgH5Fq05RK/GxT3tuoD28JhwVC+4OYXnOI8svxT1rmTgpTKqTEtTU1MB7f7wGap+AxpNwh/HgEIgj/BHaBm9eiczmlGQnkHunBX4zJYdQZxne7fAPdi3olopMQcflmni0W7zdMY+jVEow6ke+kyOs+CAr9lTIwRwuYJmzV2PM+2Zf5HdgkK5PMD2Nh62gX0hFzeJeieMjU8r26zKk/B+CjMCT/Z6eIQZA9PouTbVFtiG+V0wwFEXcbImZDQXBWGiuZ5tpYctqKemwXZX2au8WUUBZcl06Q2fX46s/GVuM8vSqsdJext/FcOdVVWo5QVfmdBcA1wOF82kLEhyVWr8K/rbpRiNdBDHy9uH31Jv0Bavhtpsm8n1HosH8IKih0SSwUkManJnRj85wzy6ZoQPeailjCdJU54HtXoIVlGSPCoEoai4w9eXzVCQMUGSVD2aNJasdkgmuSofJVXLBv5zqm9XUoDczhokBv+BA+4d/WHqT8ydWCvhkasiCr1ni0txnyJ
 5p835Jq4
 Ot+QFwkWRqmNLtze3qeoT6+EGYoJtjJuGplS9jPiwHXWy6HGLVflu+ZB9fiNodpqdTSIwLGkui3L+5oh/f2J3FvbStjYaebDo49VNzbCC6NXG7ogKQcBC5RtYx6CcgD92C3MCK0Qe20oZyyebHjkhRCBOkP1GVXDSbQ7Fz95AMBonqwXe2v/tcxhynb9A0N5QYwi75oIgezz8vzX7042YtUfWyjL3QO7C4AgwECXxdPj8jXAbmE1Ewoq1vHS+h9PanOGyidqywWLx03CyTdh531l3wl2L8wFvicwLI0d99PVAl2HD1DFdeD9ucUQwySievd3SGfVs56AMfsRTrA8aZaEW9Ton1/v+UsQJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-18 07:18 PM, Alex Williamson wrote:
> On Fri, 18 Sep 2026 20:06:34 +0000
> David Matlack <dmatlack@google.com> wrote:
> 
> > Save the ACS Control register in pci_save_state() and write it back
> > in pci_restore_state(), instead of recomputing the ACS controls from
> > scratch with pci_enable_acs().
> > 
> > This makes ACS symmetric with the rest of a device's saved state. Today
> > pci_save_state() ignores ACS entirely and pci_restore_state() re-enables
> > the ACS controls from the kernel's current ACS policy. As a result, a
> > device can come out of a reset with different ACS controls than it went
> > in with, e.g. any controls programmed outside of pci_enable_acs() are
> > silently dropped.
> 
> Controls, yes, but if we're restoring controls that might have EC set
> now, should the Egress Control Vector also be part of the save state?
> 
> Currently EC always gets cleared on reset and won't be restored by
> pci_enable_acs(), so we can lose both EC and the EC vector.  With this,
> I think we restore EC but still lose the EC vector.  Thanks,

Hi Alex,

The kernel does not enable Egress Control today or program the vector.
Would this be to cover the case where firmware or userspace enabled it?

Here is an updated patch to save/restore the vector, but I don't have
any devices that support Egress Control on my normal testing system so I
haven't been able to really test it yet.

From: David Matlack <dmatlack@google.com>
Date: Fri, 11 Sep 2026 20:05:04 +0000
Subject: [PATCH] PCI: Save and restore the ACS Control register and Egress
 Control Vector

Save the ACS Control register and the ACS Egress Control Vector in
pci_save_state() and write them back in pci_restore_state(), instead of
recomputing the ACS controls from scratch with pci_enable_acs().

This makes ACS symmetric with the rest of a device's saved state. Today
pci_save_state() ignores ACS entirely and pci_restore_state() re-enables
the ACS controls from the kernel's current ACS policy. As a result, a
device can come out of a reset with different ACS controls than it went
in with, e.g. any controls programmed outside of pci_enable_acs() are
silently dropped.

Notably, this prepares the kernel to be able to adopt the ACS controls
established by a previous kernel across a Live Update rather than
assigning new ones through pci_enable_acs().

Save and restore the Egress Control Vector as well to keep it in sync
with the now-properly-restored Egress Control Enable bit in the ACS
control register. The kernel never enables Egress Controls or programs
the vector, but the firmware could have and they need to be kept in sync
to avoid changing how P2P traffic is rounted.

The size of the Egress Control Vector is not known when
pci_allocate_cap_save_buffers() runs, as the ACS Capability register is
only read later, in pci_acs_init(). Rather than move the allocation,
size the save buffer for the largest vector a device can implement,
which costs at most 32 bytes per ACS-capable device.

pci_enable_acs() runs when a driver binds to a device
(pci_dma_configure()), i.e. after pci_bus_add_device() has already saved
the device's state. Refresh the saved ACS state there as well, otherwise
a subsequent reset would revert ACS back to the configuration left
behind by firmware.

Devices that rely on device-specific quirks to enable an ACS equivalent
keep that configuration outside of the ACS Control register, so keep
configuring ACS from scratch for them. Do the same for devices that have
no saved ACS state at all.

Assisted-by: Claude:claude-opus-5
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/pci.c             | 117 +++++++++++++++++++++++++++++++++-
 drivers/pci/pci.h             |   5 ++
 drivers/pci/quirks.c          |   7 ++
 include/uapi/linux/pci_regs.h |   1 +
 4 files changed, 129 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index b2879a6be5f8..e1c05866e2ee 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1021,6 +1021,106 @@ static void pci_std_enable_acs(struct pci_dev *dev, struct pci_acs *caps)
 		caps->ctrl |= (dev->acs_capabilities & PCI_ACS_TB);
 }
 
+/*
+ * Layout of the ACS save buffer. @ecv holds the ACS Egress Control Vector and
+ * is sized for the largest vector a device can implement.
+ */
+struct pci_acs_saved_state {
+	u16 ctrl;
+	u32 ecv[8];
+};
+
+/*
+ * Return the size in bytes of the ACS Egress Control Vector, or 0 if the
+ * device does not implement P2P Egress Control.
+ */
+static unsigned int pci_acs_ecv_size(struct pci_dev *dev)
+{
+	unsigned int bits;
+
+	if (!dev->acs_cap || !(dev->acs_capabilities & PCI_ACS_EC))
+		return 0;
+
+	/* An Egress Control Vector Size of 0 means 256 bits */
+	bits = FIELD_GET(PCI_ACS_EGRESS_BITS_MASK, dev->acs_capabilities);
+	if (!bits)
+		bits = 256;
+
+	/* The vector is implemented as a series of DWORD registers */
+	return round_up(bits, 32) / 8;
+}
+
+/**
+ * pci_save_acs_state - save the ACS Control register and Egress Control Vector
+ * @dev: the PCI device
+ *
+ * Record the ACS configuration currently programmed in hardware so that
+ * pci_restore_acs_state() can reapply it after a reset.
+ */
+static void pci_save_acs_state(struct pci_dev *dev)
+{
+	struct pci_cap_saved_state *save_state;
+	struct pci_acs_saved_state *acs;
+	unsigned int i, dwords;
+
+	if (!dev->acs_cap)
+		return;
+
+	save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS);
+	if (!save_state)
+		return;
+
+	acs = (struct pci_acs_saved_state *)save_state->cap.data;
+
+	pci_read_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, &acs->ctrl);
+
+	dwords = pci_acs_ecv_size(dev) / sizeof(u32);
+	for (i = 0; i < dwords; i++)
+		pci_read_config_dword(dev, dev->acs_cap + PCI_ACS_EGRESS_CTL_V +
+				      i * sizeof(u32), &acs->ecv[i]);
+}
+
+/**
+ * pci_restore_acs_state - restore the ACS Control register and Egress Control
+ *			   Vector
+ * @dev: the PCI device
+ */
+static void pci_restore_acs_state(struct pci_dev *dev)
+{
+	struct pci_cap_saved_state *save_state = NULL;
+	struct pci_acs_saved_state *acs;
+	unsigned int i, dwords;
+
+	if (dev->acs_cap && !pci_need_dev_specific_enable_acs(dev))
+		save_state = pci_find_saved_ext_cap(dev, PCI_EXT_CAP_ID_ACS);
+
+	/*
+	 * Devices that rely on device-specific quirks to enable an ACS
+	 * equivalent keep that configuration outside of the ACS Control
+	 * register, so there is nothing useful to restore for them. Configure
+	 * ACS from scratch instead, which also covers devices that have no
+	 * saved ACS state at all.
+	 */
+	if (!save_state) {
+		pci_enable_acs(dev);
+		return;
+	}
+
+	acs = (struct pci_acs_saved_state *)save_state->cap.data;
+
+	/*
+	 * Restore the Egress Control Vector before the ACS Control register.
+	 * The vector resets to zero, so enabling P2P Egress Control first
+	 * would briefly apply the reset vector instead of the saved one.
+	 */
+	dwords = pci_acs_ecv_size(dev) / sizeof(u32);
+	for (i = 0; i < dwords; i++)
+		pci_write_config_dword(dev, dev->acs_cap + PCI_ACS_EGRESS_CTL_V +
+				       i * sizeof(u32), acs->ecv[i]);
+
+	pci_write_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, acs->ctrl);
+}
+
 /**
  * pci_enable_acs - enable ACS if hardware support it
  * @dev: the PCI device
@@ -1057,6 +1157,15 @@ void pci_enable_acs(struct pci_dev *dev)
 	__pci_config_acs(dev, &caps, config_acs_param, 0, 0);
 
 	pci_write_config_word(dev, pos + PCI_ACS_CTRL, caps.ctrl);
+
+	/*
+	 * pci_enable_acs() runs when a driver binds to the device, i.e. after
+	 * pci_bus_add_device() has already saved the device's state. Refresh
+	 * the saved ACS state so that a subsequent reset restores the
+	 * configuration programmed here rather than the one left behind by
+	 * firmware.
+	 */
+	pci_save_acs_state(dev);
 }
 
 /**
@@ -1800,6 +1909,7 @@ int pci_save_state(struct pci_dev *dev)
 	pci_save_aer_state(dev);
 	pci_save_ptm_state(dev);
 	pci_save_tph_state(dev);
+	pci_save_acs_state(dev);
 	return pci_save_vc_state(dev);
 }
 EXPORT_SYMBOL(pci_save_state);
@@ -1877,7 +1987,7 @@ void pci_restore_state(struct pci_dev *dev)
 	pci_restore_msi_state(dev);
 
 	/* Restore ACS and IOV configuration state */
-	pci_enable_acs(dev);
+	pci_restore_acs_state(dev);
 	pci_restore_iov_state(dev);
 
 	dev->state_saved = false;
@@ -3532,6 +3642,11 @@ void pci_allocate_cap_save_buffers(struct pci_dev *dev)
 	if (error)
 		pci_err(dev, "unable to allocate suspend buffer for LTR\n");
 
+	error = pci_add_ext_cap_save_buffer(dev, PCI_EXT_CAP_ID_ACS,
+					    sizeof(struct pci_acs_saved_state));
+	if (error)
+		pci_err(dev, "unable to allocate suspend buffer for ACS\n");
+
 	pci_allocate_vc_save_buffers(dev);
 }
 
diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
index ba3c3fddddc2..037c1674f164 100644
--- a/drivers/pci/pci.h
+++ b/drivers/pci/pci.h
@@ -1095,6 +1095,7 @@ void pci_acs_init(struct pci_dev *dev);
 void pci_enable_acs(struct pci_dev *dev);
 #ifdef CONFIG_PCI_QUIRKS
 int pci_dev_specific_acs_enabled(struct pci_dev *dev, u16 acs_flags);
+bool pci_need_dev_specific_enable_acs(struct pci_dev *dev);
 int pci_dev_specific_enable_acs(struct pci_dev *dev);
 int pci_dev_specific_disable_acs_redir(struct pci_dev *dev);
 void pci_disable_broken_acs_cap(struct pci_dev *pdev);
@@ -1105,6 +1106,10 @@ static inline int pci_dev_specific_acs_enabled(struct pci_dev *dev,
 {
 	return -ENOTTY;
 }
+static inline bool pci_need_dev_specific_enable_acs(struct pci_dev *dev)
+{
+	return false;
+}
 static inline int pci_dev_specific_enable_acs(struct pci_dev *dev)
 {
 	return -ENOTTY;
diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 7aee30734303..e500c202d2ec 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5476,6 +5476,13 @@ static const struct pci_dev_acs_ops *pci_dev_acs_ops_get(struct pci_dev *dev)
 	return NULL;
 }
 
+bool pci_need_dev_specific_enable_acs(struct pci_dev *dev)
+{
+	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
+
+	return p && p->enable_acs;
+}
+
 int pci_dev_specific_enable_acs(struct pci_dev *dev)
 {
 	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
index facaa324bd86..66359cb94f0d 100644
--- a/include/uapi/linux/pci_regs.h
+++ b/include/uapi/linux/pci_regs.h
@@ -1023,6 +1023,7 @@
 #define  PCI_ACS_UF		0x0010	/* Upstream Forwarding */
 #define  PCI_ACS_EC		0x0020	/* P2P Egress Control */
 #define  PCI_ACS_DT		0x0040	/* Direct Translated P2P */
+#define  PCI_ACS_EGRESS_BITS_MASK 0xff00 /* Egress Control Vector Size */
 #define PCI_ACS_EGRESS_BITS	0x05	/* ACS Egress Control Vector Size */
 #define PCI_ACS_CTRL		0x06	/* ACS Control Register */
 #define PCI_ACS_EGRESS_CTL_V	0x08	/* ACS Egress Control Vector */

