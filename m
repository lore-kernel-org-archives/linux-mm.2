Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A194606A31B
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 21:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=Vs1+swBa
Received: by kanga.kvack.org (Postfix)
	id 5DB196B0394; Mon, 19 Oct 2026 17:31:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B29B6B0396; Mon, 19 Oct 2026 17:31:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C9D96B0397; Mon, 19 Oct 2026 17:31:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1F8336B0394
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:31:30 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 919FF40817
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:29 +0000 (UTC)
X-FDA: 85340672298.05.2F3253E
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com [209.85.215.197])
	by imf24.hostedemail.com (Postfix) with ESMTP id D6FBC180008
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vs1+swBa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3LozWaggKCP0irfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3LozWaggKCP0irfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792445487;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+8+r+UgUrY8DXLFgmEvSoqHNnXfv9U//CDOtL9HGeYU=;
	b=JNCupjztKnXDetAE60AGPtvee2yqmgFQTGwpRWGRfV8L8sYdXqhnEokq/rK2X4Fak7B9rU
	ZBcOFASKDF6WPKnQm4X+YXde0YdB/Fjkef9a7A4L4+Pm8EmDJDGihRXlrN+KZJSA7gEEc8
	s1k8y8qQaKo6XRbqDo7+AAT3o2ryHFA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Vs1+swBa;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of 3LozWaggKCP0irfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com designates 209.85.215.197 as permitted sender) smtp.mailfrom=3LozWaggKCP0irfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792445487;
	b=VYXrSX9bae0zEvPh7MrDKVqa46PYr9XvirhooslaFYcRMV4j7rIcS70gjvUppctkqn8tsi
	TopxaS4aczGuP/EJEn3CdlYziNlIflzc1H9dcKCyTvmRKwvey6AfNrsw9R5aAfNBdYH2z3
	G+MbPST+TrcA0i5ikM9J/Ul0rhLVXKo=
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-cd67e98f68fso1724803a12.3
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792445487; x=1793050287; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+8+r+UgUrY8DXLFgmEvSoqHNnXfv9U//CDOtL9HGeYU=;
        b=Vs1+swBapoQnVuQ7rWw9QOOQh8BvbdeIpVpIubWwqRRCZYFMhUX7MD5BaGuVgpbpMH
         Kni64t29FzmCKDt88pR1krhzFC185Lqf/X8Q+VwvYIBLVXOruxUnDTc3050EAjwUrpoJ
         zWLIMmKz9DIOYFznMwZq8T4F/wi3k2YgiTtnCzrZ6ry9L3CHPD1WRkzgQdbFBbjqgaxa
         CnOqYV7r4w0+X/yWVR6kF9UWGFGqOrXJ74u3zOFZS1pV6zGTNluFR6jsVgkGAbsT3Xu8
         NGcW4wYanq2KkNUCIE21JnA+rc37MQ6tnYfXDkek8xyRyw0aPArebdVKxj81VydRTxHv
         IuWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792445487; x=1793050287;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+8+r+UgUrY8DXLFgmEvSoqHNnXfv9U//CDOtL9HGeYU=;
        b=LJRqlMI+ieTIV/ZAUx0IymLMPTD/hz9mlco32LtUf1N5NfjPJNp/oEjEwvw8+juiiU
         amHDnLjIlbDspb6IKpjThrSpXkFZcPqwz9yp+XjHp3RsmyHCj+r7wX3ldfw8amf9D+Ms
         Lp8c2UgdToW/a2pXeimxkoKienTlEDklmAwzZjxpjXVXwmPc1v2c94j7CImt3/kRsBFf
         dyAv+jItUmURhjTtd3WhzRspNYlH5w2fAYzO/qcFVDPUfjL35IhFYz0jdu8OApf66GA4
         pXfGdoP6zg/FQC/BHOfOjDznYz1m9wpMUt8pvenpPG5ijddrJU7vt2Bj6aODUVOi+FAu
         NyaQ==
X-Forwarded-Encrypted: i=1; AKwUvBzBXk1sAYG5g+SWZ9aH2gpJH3oee8whKsp/EfNhS0ctt8YMcqCzGAF03C6emw7rFLfdyB9r6w6LzQ==@kvack.org
X-Gm-Message-State: AFq9FYJ1pFCi2TmDzNjwmgbq0bjlFFl1zIBLf/4ZqabbvFKHY+YS7d2/
	MX6tBua3aFqizvh1yG70kCU3igLV/W2unALDaZJ5c908iSVTzbYkapEtwwqe3XD3126Gpn6IGOg
	Urwi5gmCCaMOy2g==
X-Received: from pglk6-n1.prod.google.com ([2002:a05:6a02:6b86:10b0:cc7:dd4c:a852])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:ac44:b0:3e2:1656:b7c9 with SMTP id adf61e73a8af0-3e226401953mr7453690637.66.1792445486484;
 Mon, 19 Oct 2026 14:31:26 -0700 (PDT)
Date: Mon, 19 Oct 2026 21:30:50 +0000
In-Reply-To: <20261019213054.3157159-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261019213054.3157159-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261019213054.3157159-7-dmatlack@google.com>
Subject: [PATCH 06/10] PCI: liveupdate: Claim resources of incoming devices
 during scanning
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
X-Rspamd-Queue-Id: D6FBC180008
X-Stat-Signature: kcd818mm4p4cb8kwxj7c78nfw9fhdx56
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792445487-123805
X-HE-Meta: U2FsdGVkX19zCLuNta3zRV5HOYU6ji1dd2CshtcRKP5HQTUsvlg+gVHdNeyBDXa+ljPAQhwX26N1KZEzpI5uCyPcSExzuy7wBa38lmyFkO06G8592WFAsGqaTpsh5vkl8e2LqaqHQGfyxdA7dqvXP1G120leclxd90ELzvkaSRgGHL6z0lFXe8CnNNlwO3Hg9X9EIx00XbhwGqDNyQNQPM22nS/K/emh3seXuoeW1HAdp1BAZuawZTfJ5W7nuDXEBEtKJ0QqipLAZoVLY3gXSsUBN8hv4RQ3VY+IJlJLKDWd3FOIi7ByNEzZbiawztNDFhvjhyZx3ZmMOInFlcI4da0wflbkcaqguJJJAQViyXPYHeqKOrNj9MPPXG9Hv0QbjcjTCSMl2tBfEFMTP1G2EKFeGyG+n7+VbikLqEp7qgTYH6QuZLuAroB8PYOEXkyKn/5sHEsBQGCCdmv+CZydzwpnhyhj59jyzT+s2H7BVOBzZ4qjJ38ySR7b8M1SFa6c0FttMfEwIJ1gWUteuva+h6hkyz5i+3IHfVkoUVHAwds9z+FwPAt/RPfgtxa398alKJ15++z+1Bj7qEByhmvKHxiRcJX4p03fp5XQHRl8EcqNy/Rin/H9Y1Yr0AmNRWwL6f/zaDFmiwTnoajpMlE4A/cFwbEUlyIjn5BR18NaqrW9VKbUHDmIRTWbhks/OkRMBJsP2OtZj27nxzB67a3LMdvsBPGAD4gCEEdHl8kHSYAKkrBixOMxvwFTQbvU8wc1TYwihfHFaDgxV3XbJaI7fdVY7Zm0sgo69q3rP23XLdNbZz1UqBUYLL2u689YBsITY4rel6pieGjnqK7T8F1QugBjbl9pZtioMpCt7z/wQ8ltZz3u8DruBdU9pN4h0Zan1JrGBHYCfSWcTfVdJfuy1joesmgHx2zY35kyj0LaIOA5rpUceiyfZ05oXi6+2m4qg8ycPD+E5aNiDzVoOtS
 3P+gpGnM
 GTbqgnuUphbN2+u5AcEUmgbgofZ887p7aOT1QIYrHYq6oC/KD6Ukz4fMZYxaCPd6PqW7TLtgj5yqb9UgGt9uBUOBIAMAMEJha9wWJ865vAd4PmmSvfcRijByrX/J3DX/65tcDe2pXDufWmhkzvcmbtF9Oss9Dhp4Q68UTSmyARmCwLcSN+Gt3/WhLV2GMEuH7dGGtLCodPmwTyuqa0jSvzcNOUUMjTdhaZzRDZuC7ZjJ05bWxXtKsFsptSHCuqGLW8AkcN1wRe/UP688ILkOQ2HuIvVQhRT0JYmOtHXI+qdkN0UOn6Y6orceTT8FGN6Z/wxzAZ9hF0N8KjJCeKIsJ5O9DSrhgIiV3rL4vX48SaydjNdZVv84RIj98nSTjstYXFdSdvpLqAS+ACmf3/mcg5Vt21JuOrHX+5Q+FWols7bKGrB1bJ0MuCA0p/ocLZyTbxUEq81kBIav68Qm4E7WIBIxCBukDbIJLrzrM+iY26AKmdmEZ5iPW7s1G2uM8djDkvfWxSw31Y5I1RCTdWmIMOgCJx9C3Wq9BSwgq5tghENdNDNKxvXhj2l0aKCGO5K9HC9ImGQ2cog+OGZhK/iUFY9eFugbFqjyb5z6S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Claim the BARs and bridge windows of incoming preserved devices, as
programmed by the previous kernel, while scanning. Claim them for each
bus after its devices have been enumerated and pcibios_fixup_bus() has
run, and before the buses below it are scanned.

This ensures that the address ranges decoded by incoming devices are in
the resource tree before anything sizes or assigns resources,
regardless of how the host bridge driver sets up resources. Without
this, whether existing resources are claimed depends on the platform:
x86 claims them in pcibios_resource_survey(), pci_host_probe() and the
generic ACPI host bridge code only claim them if the host bridge has
preserve_config set, and some host bridge drivers (e.g. VMD) never
claim them.

Buses are scanned top-down and all bridges upstream of a preserved
device are also preserved, so the windows that contain the resources of
an incoming device are always claimed before the device's resources.
Outside of x86, bridge windows are not read from hardware during
scanning, so read them first if needed. Code that claims resources
later, such as pcibios_resource_survey() and pci_bus_claim_resources(),
skips resources that are already claimed.

Panic if claiming fails because something else has already claimed part
of the range decoded by an incoming device, since memory transactions
that still target the incoming device (e.g. P2PDMA, or MMIO from VMs
whose vCPUs keep running during kexec) may be corrupting it. Also panic
if a bridge window cannot be claimed for any other reason, e.g. because
it does not fit in the upstream window, since the bridge would keep
forwarding a range that the resource tree considers free, and the PCI
core could assign it to another device. Neither should ever happen,
since the previous kernel had the same resources claimed. A BAR that
fails for any other reason was never assigned an address (e.g. a ROM BAR
that the previous kernel left unassigned), so there is nothing to claim.

pci_liveupdate_claim_bus_resources() does nothing if the previous kernel
did not preserve any devices, so the only overhead outside of Live
Update is checking a flag under the PCI Live Update rwsem.

An alternative that was considered was setting preserve_config on host
bridges with incoming devices, which makes pci_host_probe() and the
generic ACPI code claim all existing resources. However, not all host
bridge drivers honor preserve_config, it is a firmware-provided policy
that applies to every device below the host bridge, and it would have
to be cleared once Live Update finishes.

Assisted-by: LLM
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 99 ++++++++++++++++++++++++++++++++++++++++
 drivers/pci/liveupdate.h |  5 ++
 drivers/pci/probe.c      |  8 ++++
 3 files changed, 112 insertions(+)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 72ad4fd00f7b..ac4525568818 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -184,6 +184,12 @@
  * The PCI core treats preserved devices differently than non-preserved devices.
  * This section enumerates those differences.
  *
+ *  * The PCI core claims the BARs and bridge windows of incoming preserved
+ *    devices, as programmed by the previous kernel, while scanning and before
+ *    any resources are sized or assigned. This ensures no other device is
+ *    assigned address space that an incoming device is still decoding, and
+ *    that the resources of incoming devices are never reassigned.
+ *
  *  * The PCI core adopts all ACS controls enabled on incoming preserved devices
  *    rather than assigning new ones. This ensures that TLPs are routed the same
  *    way after Live Update and ensures that IOMMU groups do not change. Note
@@ -1207,6 +1213,99 @@ int pci_liveupdate_read_bridge_windows(struct pci_dev *bridge)
 	return 0;
 }
 
+/*
+ * Check if the windows of @bridge have been read from hardware. Outside of x86
+ * that does not happen during scanning.
+ */
+static bool pci_liveupdate_windows_read(struct pci_dev *bridge)
+{
+	int i;
+
+	for (i = PCI_BRIDGE_RESOURCES; i <= PCI_BRIDGE_RESOURCE_END; i++) {
+		if (pci_resource_n(bridge, i)->flags)
+			return true;
+	}
+
+	return false;
+}
+
+static void pci_liveupdate_claim_resource(struct pci_dev *dev, int resno)
+{
+	struct resource *r = pci_resource_n(dev, resno);
+	int ret;
+
+	/*
+	 * Skip resources that are unused, already claimed, or disabled (e.g.
+	 * bridge windows that are turned off).
+	 */
+	if (!r->flags || resource_assigned(r) ||
+	    (r->flags & IORESOURCE_DISABLED))
+		return;
+
+	/*
+	 * Panic if something else has already claimed part of the range, since
+	 * memory transactions still targeting the device may be corrupting it.
+	 * Also panic if a bridge window cannot be claimed at all, since the
+	 * bridge forwards the range even though the resource tree considers it
+	 * free. BARs that fail for other reasons were never assigned an address
+	 * (e.g. a ROM BAR that was left unassigned), so there is nothing to
+	 * claim.
+	 */
+	ret = pci_claim_resource(dev, resno);
+	if (ret == -EBUSY || (ret && pci_resource_is_bridge_win(resno)))
+		panic("%s %s %pR: Failed to claim resource of device preserved across Live Update\n",
+		      pci_name(dev), pci_resource_name(dev, resno), r);
+}
+
+/**
+ * pci_liveupdate_claim_bus_resources() - Claim the resources of incoming
+ *                                        devices on a bus
+ * @bus: The PCI bus
+ *
+ * Claim the windows of the bridge upstream of @bus, if it is
+ * incoming-preserved, and the BARs of the incoming preserved devices on @bus,
+ * as programmed by the previous kernel. The PCI core calls this while
+ * scanning, after enumerating the devices on @bus and before scanning the
+ * buses below it, so that the resources of incoming devices are claimed before
+ * any resources are sized or assigned.
+ *
+ * Buses are scanned top-down and all bridges upstream of a preserved device
+ * are also preserved, so the windows that contain the resources of an incoming
+ * device are always claimed before the device's resources. Failing to claim a
+ * resource because something else has already claimed part of its range is
+ * fatal, since memory transactions still targeting the device may be
+ * corrupting it.
+ *
+ * This does nothing if the previous kernel did not preserve any devices.
+ */
+void pci_liveupdate_claim_bus_resources(struct pci_bus *bus)
+{
+	struct pci_dev *dev;
+	int i;
+
+	guard(rwsem_read)(&pci_liveupdate.rwsem);
+
+	if (!pci_liveupdate.had_incoming)
+		return;
+
+	if (bus->self && bus->self->liveupdate.incoming) {
+		if (!pci_liveupdate_windows_read(bus->self))
+			pci_read_bridge_bases(bus);
+
+		for (i = PCI_BRIDGE_RESOURCES;
+		     i <= PCI_BRIDGE_RESOURCE_END; i++)
+			pci_liveupdate_claim_resource(bus->self, i);
+	}
+
+	list_for_each_entry(dev, &bus->devices, bus_list) {
+		if (!dev->liveupdate.incoming)
+			continue;
+
+		for (i = 0; i < PCI_BRIDGE_RESOURCES; i++)
+			pci_liveupdate_claim_resource(dev, i);
+	}
+}
+
 /**
  * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
  * @dev: The PCI device to check
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index 4c4104025a7e..98d23e217308 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -22,6 +22,7 @@ bool pci_liveupdate_is_outgoing(struct pci_dev *dev);
 int pci_liveupdate_read_bar_masks(struct pci_dev *dev, unsigned int nr_bars,
 				  u32 *bar_masks, u32 *rom_mask);
 int pci_liveupdate_read_bridge_windows(struct pci_dev *bridge);
+void pci_liveupdate_claim_bus_resources(struct pci_bus *bus);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -72,6 +73,10 @@ static inline int pci_liveupdate_read_bridge_windows(struct pci_dev *bridge)
 {
 	return -EINVAL;
 }
+
+static inline void pci_liveupdate_claim_bus_resources(struct pci_bus *bus)
+{
+}
 #endif
 
 #endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 184d93aa8522..a53d0077a08b 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -3155,6 +3155,14 @@ static unsigned int pci_scan_child_bus_extend(struct pci_bus *bus,
 		bus->is_added = 1;
 	}
 
+	/*
+	 * Claim the resources of devices preserved across Live Update before
+	 * scanning the buses below and before any resources are sized or
+	 * assigned, so that nothing else is assigned the address space they
+	 * decode.
+	 */
+	pci_liveupdate_claim_bus_resources(bus);
+
 	/*
 	 * Calculate how many hotplug bridges and normal bridges there
 	 * are on this bus. We will distribute the additional available
-- 
2.56.0.212.g129ede20d9-goog


