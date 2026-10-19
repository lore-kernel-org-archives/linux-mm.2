Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8779060A2608
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 21:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=kVLRlUZG
Received: by kanga.kvack.org (Postfix)
	id AE4C36B0392; Mon, 19 Oct 2026 17:31:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6D866B0394; Mon, 19 Oct 2026 17:31:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9837C6B0395; Mon, 19 Oct 2026 17:31:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6CCC96B0392
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:31:29 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E5B64C0495
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:28 +0000 (UTC)
X-FDA: 85340672256.10.02836E1
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1A0304000B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kVLRlUZG;
	spf=pass (imf04.hostedemail.com: domain of 3LYzWaggKCPwhqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3LYzWaggKCPwhqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792445487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rccGvdC4VDGY+kjlq/11HJtI0x1dTEfzAQPx1OmbdOk=;
	b=sSpV14MhNywLCGbwnnAIdik6p3/vW9QCnmQX7/l1P0UVZtwyUpeKawUALTLl+veinEjZ7m
	hS++sv1s8AR9XuU0vbL2XjTIvJXIKpAqjEbTMxiSNvV5jNjyImM4WccTKhQG7dS5TaW34A
	kD9BO71bqjXItm6v8+STFF7/VkSoxx8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792445487;
	b=Am/oXikQ0QUrPThPO/AKD1pytsQhtOoXI5A1n1vvKh2446lVc5/qQ7IxKg2C7fgmA1an5N
	rdxuPtR/P+8fKAFhT5XnHRsS75D42FnKSlaxBLvJ22MWtkrmxhm11GdwzbiPvl2m5i8aUA
	Yr1KG9gJ4PiShateLnvUGPBQyM/oUXA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=kVLRlUZG;
	spf=pass (imf04.hostedemail.com: domain of 3LYzWaggKCPwhqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3LYzWaggKCPwhqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e987ec84afso23017215ad.3
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792445486; x=1793050286; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rccGvdC4VDGY+kjlq/11HJtI0x1dTEfzAQPx1OmbdOk=;
        b=kVLRlUZGaG3Y9KTll+okDKwnt5pexKdjvG0tW1tALtnq1iK/N2KasdpkrTVYyGGiUT
         l0QUs/rJv2RrelkfCXZGGU+UItJkv14II3LZXa55uxfGcSBVeL7AG8L1uisi8x1hKwgy
         zSa1gSRoriIMFKX3fK0DReV76mP9HfuE875sig3hi/q8yrbMQ3Jax5gbmXVz7Jw6s/GX
         s81Fi3LtEgXAK1ai8w55OzEZyotZXsZwC1j9QRiTcnLeyHD3Z9PY7so/Kvekkc/bFR0j
         PSYTunC3tDX/nUm3TeitxWfmWho35YAWmyWXW6Cd5+nN2DuVx2etyrSMdIwb1NdRFTQJ
         wcOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792445486; x=1793050286;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rccGvdC4VDGY+kjlq/11HJtI0x1dTEfzAQPx1OmbdOk=;
        b=TKKuqasFTY6aWK3ztyGnn+T9Js10yKIFTXk0gGXhXgoYJRejJa37acjJf1/x7ruhAh
         sOSfBmrRLfQMeqNuB2rK2FI0dDRAWxihXKMFo0oN8T5NuLGJugHAoIgKZnR29WzABDEi
         sxeinu0cvd5oLaK76Qs5Sww3GP+6z3Bv4J4Yaj3YSb6fyTcva7IrDaLnMDeeW5Jh9j3A
         XRqxUHUKdDglYJiuQVvCT02R1My22Dj0xKGmx6YOwuhYstSOJvWRzIGKHh44uQgT7QnA
         qsJgOD/uwtUMOGOuGQFICcXWUA1W8W4304oV54TV7WV3h+tdN68EzU9KmIBeIXeTJN5K
         D4vw==
X-Forwarded-Encrypted: i=1; AKwUvBxJ35oiBK3h7y47n0+ugciqrp9BgdeDoHS9N4fp662Mna+IgPyVe33qzIeQ4/i66v1naHZ/9mk86w==@kvack.org
X-Gm-Message-State: AFq9FYJ4RDCDoLxE5lx8jr2HsDnlgUC6IihHlLyKAPIeunnLEztrMEkC
	XjGdd5e72uQD+zlml7aROOMWN1nPkWgnrd4YV957+BdccUjcEG5XNiu+SOeS2grct/rvKV6BwgR
	QLywgRzvhDYH+cg==
X-Received: from plok11.prod.google.com ([2002:a17:903:3bcb:b0:2e9:5b68:4b7d])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e949:b0:2e2:d02d:a173 with SMTP id d9443c01a7336-2e9a6f59777mr77394715ad.49.1792445485578;
 Mon, 19 Oct 2026 14:31:25 -0700 (PDT)
Date: Mon, 19 Oct 2026 21:30:49 +0000
In-Reply-To: <20261019213054.3157159-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261019213054.3157159-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261019213054.3157159-6-dmatlack@google.com>
Subject: [PATCH 05/10] PCI: Skip programming bridge windows that are already programmed
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	David Matlack <dmatlack@google.com>, 
	"=?UTF-8?q?Ilpo=20J=C3=A4rvinen?=" <ilpo.jarvinen@linux.intel.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Logan Gunthorpe <logang@deltatee.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1A0304000B
X-Stat-Signature: gsi9ohbwwyhngtppkotha7f5c4yshd94
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792445486-151460
X-HE-Meta: U2FsdGVkX18YEqlt/HhmWsfYhZxRzhO5hct5w0pUqBUH6HQp9io3kFKyhyoiablpRFayTx4mJncZXbrbsUvGKYRWLackldSJ2qclnjnEbxgJP6e1ODnD1TJ+X46Jgbni7IhQRuBY+FNXjCEx5+05uYZdXDE7bwIYwG1dHbfu2gKSiTBAFhsmgG9ryJ73DsB/jGKDVx21BoPcPf3OdNXAJA3D+DDojpG1lmLevhUZrIgIJe7v2SgGamTqQQw2wSVmyqOBhHN7P8FCyW5abh2cU04TgIdeR/mrD8KjHeAjzg6riqIK+8yj7VjwHqi/aYnh0jJP4pdexpxeCdjUzzm3i3g57xlgIq5wz+6RZ1A2luJdxGBEDRU85sKDrVIa1geBuptSCe8yV2rkcsahnBnBnWr8DeyBz/qXkU99oxcL9Rs2dRxOcvofd3xlj+SWo57vdScLhKr6T7MuXtQ4xVcQz6NPr3loUUZsTQXVkGOpI9PYHxFQUJYNHrQva+jzTZVaz+MDfuQAHHSCJsO10I1YD1gO2kZ1RTET/MOdfREAaT88ax6gyKCqd9iEgyTePp412DPj2ZET4RFOB+djPrht3Mt7t2Z3E2DSDJXrXmGmINkYaB4urHG+Zr0fMLARfOZ5JHxjyHb0dUXR2B/gyW/Z32F7LxSRH2r41mLmmdljHomL4gwpwYttH1LynDKaF8yxYihkWgxzBzcG6OrBzDvBUSRWUmQJuDCEVX+B7gurwYjeIqrwvbYDNFKHPEVCC1VQkO1/OkOGVfwvzaDAfNaeOlrSMqP1pZd3EoKdgND5voiyGwlxToB3SggWZOOkcgJbwf14+5hYgt2jc6YaEYKdrvRARFmd+MAf06C7trbI8vEHd1rRS4BSPCoTM7p0uFGYjbdT75TJ4AZpxjKw/sswIXeeyWbJINlh7KpJtP5W1gz73ndS4oAPm2eW5/GSbs5kMI28rZJhdcDdP+rM/L/
 Kyam1vXN
 8lpGB6+rxgpRx5KTD8qOFM1CzMVEcLjNPUtaUKgSR4xLSLgtbBawxL72lWSe1gEqje+YSnJpebuRZ8Z7nmH2k83v7MAkk30NgtASg+iGL4WAVnlUe/FnsaxPTWms40wCRofD/APlyP+LNnJH95XnZZfRXPoFKTuqG7XUjFcCoLXbZgXVIWbtZ+C7amlL+Gz6Ir9RCYZhDKeqIfYAGWA2PuuGecZsXg37jb+DUJ0tBf5NEAUl494rwmqa6Soj2sX8opJ4EoUdfOLtANjkBTNoo57yHN9ul6vsiPtiu1bbS9AO+KoVyyWiVdVRirpJu6/wgx9yuAZup4nC+gv5jvVnOnaiQDlh9Bza7BVh7CcMw6lYJ09Cfx56v+SALUftYNQspK4wuGl34UVK8YFd0mDMjZqil8ObjDNrpslnm5uU21GCcNvw/4w4uKHKXF3DaoTcxZSYiYDwcgCFevP3pjdnZ0HDbZYe2mUc0iC17nBfe9dRm0y5F+xTRYYohEY8IRKRlyw7ygg50pINH5w8+mmHz5D30j+0b5WiM+4Pb9sETe0MY+dNg4y3VYAnE3z1wc8/FDwYOnCpLQmDf55xMKwGUG7n8FQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Skip updating the window registers of a bridge in
pci_setup_bridge_io(), pci_setup_bridge_mmio(), and
pci_setup_bridge_mmio_pref() if they already contain the values being
written (ignoring the read-only low bits of the base and limit
registers).

pci_setup_bridge_io() and pci_setup_bridge_mmio_pref() temporarily
disable the I/O and prefetchable memory windows while updating them,
since the base and limit of each window are split across multiple
registers. This happens even if the window is not changing, e.g. for
every bridge whose windows were assigned by firmware and claimed, since
__pci_bus_assign_resources_one() calls pci_setup_bridge() on every
bridge that is not yet enabled during enumeration.
pci_setup_bridge_mmio() updates the memory window with a single write,
but skip unchanged writes there too for consistency.

This prevents disabling the windows of bridges preserved across Live
Update during enumeration, which would disrupt memory transactions
targeting preserved devices below them, such as P2PDMA from other
preserved devices, or MMIO from VMs whose vCPUs keep running during
kexec.

Assisted-by: LLM
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/setup-bus.c | 52 ++++++++++++++++++++++++++++++++---------
 1 file changed, 41 insertions(+), 11 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index e8c94aa1d3c1..4bec76950f46 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -799,8 +799,8 @@ static void pci_setup_bridge_io(struct pci_dev *bridge)
 	struct pci_bus_region region;
 	unsigned long io_mask;
 	u8 io_base_lo, io_limit_lo;
-	u16 l;
-	u32 io_upper16;
+	u16 l, cur_l, l_mask;
+	u32 io_upper16, cur_io_upper16;
 
 	io_mask = PCI_IO_RANGE_MASK;
 	if (bridge->io_window_1k)
@@ -823,6 +823,18 @@ static void pci_setup_bridge_io(struct pci_dev *bridge)
 		io_upper16 = 0;
 		l = 0x00f0;
 	}
+
+	/*
+	 * Leave the I/O range alone if it is already programmed as needed,
+	 * rather than temporarily disabling it below. The low bits of the I/O
+	 * Base and Limit registers are read-only.
+	 */
+	pci_read_config_word(bridge, PCI_IO_BASE, &cur_l);
+	pci_read_config_dword(bridge, PCI_IO_BASE_UPPER16, &cur_io_upper16);
+	l_mask = ((u8)io_mask << 8) | (u8)io_mask;
+	if (!((cur_l ^ l) & l_mask) && cur_io_upper16 == io_upper16)
+		return;
+
 	/* Temporarily disable the I/O range before updating PCI_IO_BASE */
 	pci_write_config_dword(bridge, PCI_IO_BASE_UPPER16, 0x0000ffff);
 	/* Update lower 16 bits of I/O base/limit */
@@ -836,7 +848,7 @@ static void pci_setup_bridge_mmio(struct pci_dev *bridge)
 	struct resource *res;
 	const char *res_name;
 	struct pci_bus_region region;
-	u32 l;
+	u32 l, cur_l;
 
 	/* Set up the top and bottom of the PCI Memory segment for this bus */
 	res = &bridge->resource[PCI_BRIDGE_MEM_WINDOW];
@@ -849,6 +861,12 @@ static void pci_setup_bridge_mmio(struct pci_dev *bridge)
 	} else {
 		l = 0x0000fff0;
 	}
+
+	/* The low bits of the Memory Base and Limit registers are read-only */
+	pci_read_config_dword(bridge, PCI_MEMORY_BASE, &cur_l);
+	if (!((cur_l ^ l) & 0xfff0fff0))
+		return;
+
 	pci_write_config_dword(bridge, PCI_MEMORY_BASE, l);
 }
 
@@ -857,14 +875,7 @@ static void pci_setup_bridge_mmio_pref(struct pci_dev *bridge)
 	struct resource *res;
 	const char *res_name;
 	struct pci_bus_region region;
-	u32 l, bu, lu;
-
-	/*
-	 * Clear out the upper 32 bits of PREF limit.  If
-	 * PCI_PREF_BASE_UPPER32 was non-zero, this temporarily disables
-	 * PREF range, which is ok.
-	 */
-	pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, 0);
+	u32 l, bu, lu, cur_l, cur_bu, cur_lu;
 
 	/* Set up PREF base/limit */
 	bu = lu = 0;
@@ -882,6 +893,25 @@ static void pci_setup_bridge_mmio_pref(struct pci_dev *bridge)
 	} else {
 		l = 0x0000fff0;
 	}
+
+	/*
+	 * Leave the PREF range alone if it is already programmed as needed,
+	 * rather than temporarily disabling it below. The low bits of the
+	 * Prefetchable Memory Base and Limit registers are read-only.
+	 */
+	pci_read_config_dword(bridge, PCI_PREF_MEMORY_BASE, &cur_l);
+	pci_read_config_dword(bridge, PCI_PREF_BASE_UPPER32, &cur_bu);
+	pci_read_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, &cur_lu);
+	if (!((cur_l ^ l) & 0xfff0fff0) && cur_bu == bu && cur_lu == lu)
+		return;
+
+	/*
+	 * Clear out the upper 32 bits of PREF limit.  If
+	 * PCI_PREF_BASE_UPPER32 was non-zero, this temporarily disables
+	 * PREF range, which is ok.
+	 */
+	pci_write_config_dword(bridge, PCI_PREF_LIMIT_UPPER32, 0);
+
 	pci_write_config_dword(bridge, PCI_PREF_MEMORY_BASE, l);
 
 	/* Set the upper 32 bits of PREF base & limit */
-- 
2.56.0.212.g129ede20d9-goog


