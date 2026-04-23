Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3F13FDEE51
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 21:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75CD66B0098; Thu, 23 Apr 2026 17:23:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 671D06B0099; Thu, 23 Apr 2026 17:23:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EB366B009B; Thu, 23 Apr 2026 17:23:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FCEE6B0098
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:23:32 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F011212057C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:31 +0000 (UTC)
X-FDA: 84691097022.27.6E91227
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1D9EA140002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:29 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RRlFopUi;
	spf=pass (imf09.hostedemail.com: domain of 30I3qaQgKCOsQZNgYNPXTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--dmatlack.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=30I3qaQgKCOsQZNgYNPXTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776979410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hfzU9SNjvxnnqDKncwfyemtEYZFu8CMxXPZg5kqrMR0=;
	b=E67mf1t5NXLT+YhPZx97ItN7ZpuQ0a4DtnhpraZ/jovviFo9hYO0X1nyrXcnrihvcirLrR
	pwwIBt4H6mUc3ovmhU0q94frkvQ1R2nBRFhaohY7TTXUsLdCcpvaVuTLXvJk+uOCbBDD3O
	ewHaILyovCzdGk7Av/Jvf0HDr32kZH8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776979410; a=rsa-sha256;
	cv=none;
	b=D3WvtQs/LSchl6YR/QSEiFgJXWpEzZ9AWzAFmLrU1w6uIpsHtnbTJPP3TRtHHMuqZTebRv
	AvaP+rp+WX/wh5iLH+r3DB+s5Q1r5cdEDvyp55GKSWFLHISetDoAqLd23HLvN7LJ3TrhiJ
	Di+30JmDR7W3kQ9XIWoc0PExKiwOxMk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=RRlFopUi;
	spf=pass (imf09.hostedemail.com: domain of 30I3qaQgKCOsQZNgYNPXTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--dmatlack.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=30I3qaQgKCOsQZNgYNPXTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c79943d2fbfso1697741a12.1
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:23:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776979409; x=1777584209; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hfzU9SNjvxnnqDKncwfyemtEYZFu8CMxXPZg5kqrMR0=;
        b=RRlFopUixlQ8V3QTM5lZ+depyw7c1vOG5r98jNjsB3a7e293mYAq9cFKOsGMGupjKM
         oP37V8XTGHum4eCW8WuQurpszA43HU+/ZPYtHdHCShrSezh8hjzIJtyr8K2PbYVKb9jz
         ceFhLkgicYfClZJbZ7k4+Mulvud2nSU9nk3tKxTwHzyOmtH1+iP4/vM0NoapgeA1c+O7
         0uTCsY4TNH1mkKrEuLHJtvQytecbKGn83Utw5TIqThottR7Qgk+uIyq43c2YwJ9GTPfF
         Q7okcHzUjX2aYwnjyIZzUelqia4Sod/r4pT3fdt2Wrz2O4/WRXKB44uYa7X/yUEu7tTE
         8+LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776979409; x=1777584209;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hfzU9SNjvxnnqDKncwfyemtEYZFu8CMxXPZg5kqrMR0=;
        b=gxbQyBFFap2Uv3BJq7lUNdbAw8hGe5KZSiEP02eSj89oV8ZfioatX/grFgNRBIMB+F
         YLyoEpdzXPramDes6xxdGyV2QHZnrI8wJudolbUT/P8PT+/owT9PLlufeNlL9Vm1NVtu
         Kk/IXXBMb/nWg0QSUamoDsSeTvJliJzQEvOEw5CiUmEjdxUJmsF152HH+2VJxSOKzg//
         AMkuRY2TlhUds9bJAhGkB05VTo5aeh5e/TSB4o2QAv0gl0VT4/QlEqYox1sET3WobJ9y
         HoSABbgA6nzD3s5mfySi1DdLh5nFvLaK/J9o1wvcE735ZHAhLlfF7fNFYOKAygJ3+3rK
         XDSg==
X-Forwarded-Encrypted: i=1; AFNElJ9Ppkr+LwE5c4lT1hLTw78cH1/6ES3jKvsOsEaYLPuVnlIThsylhbxfcjVfuc5U/Eg1pjUKpWB+mg==@kvack.org
X-Gm-Message-State: AOJu0Yz1rzgkOGCPeTtXYc5YeiP+jnOHToNibVUicBTxhEibxr4ARnmp
	w4wkJgXF2LWHlFh9Z9vB9g0kK/SLv1/euIx+u19BT3nK/U3ifpHEBBRKKzhl0Waj3CBkYPh9EFw
	fJmwWKjCaiqWvmA==
X-Received: from pgbcw1.prod.google.com ([2002:a05:6a02:4281:b0:c76:8acb:773d])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:6d9c:b0:3a3:17f8:bedd with SMTP id adf61e73a8af0-3a317f8cbb2mr6879688637.17.1776979408708;
 Thu, 23 Apr 2026 14:23:28 -0700 (PDT)
Date: Thu, 23 Apr 2026 21:23:09 +0000
In-Reply-To: <20260423212316.3431746-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260423212316.3431746-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423212316.3431746-6-dmatlack@google.com>
Subject: [PATCH v4 05/11] PCI: liveupdate: Inherit bus numbers during Live Update
From: David Matlack <dmatlack@google.com>
To: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: oahiwtp99zkxdmw68o58ecw4tstyjm8o
X-Rspam-User: 
X-Rspamd-Queue-Id: 1D9EA140002
X-Rspamd-Server: rspam05
X-HE-Tag: 1776979409-845784
X-HE-Meta: U2FsdGVkX1/Pcc7wfamGSVbURiA9TanZhQ2c7WeoYo/7illHRFccKLKQebY4bX4C1PId/UwJ/mjjFV8WHdsoIXM8FO4t3gUZ2MEhY32YIcxFx8BptXM5uykvVvm+68JbyAsFQgtd8cP8svZy5rzZaDnpkWF0QJrsXxSIhD+zeDu5+Tkr+UO4YY/wDg/Ezk6FCrD+BPvZ/rtEgkMZ2T/js2d2M70qN/MEcun1m2oY2P3ClOSQWcFGNmshuOzNoTNEl20tIFmoWLqNqbQ+ITs2s3fKigeSsrF4x2SdVIhlmSvZLnXX6cJ9w4EaxA9ybRjvxIxX0Bq/kUzvCdocCC12GevQodzbVOf8XU791H3EeM/IcYuJZFJ97Z+jFJQTn6td+xD2FeTgCMjIIo6TgwfjWU/JwWpS2KRzMC3iGhBuu9N7Yh44dk9HoSKUtSnra0kfxrPgqhIoTJRgP3wN5rZe2btol7YsSuSUR4fTJJeodwLiZauxnk9dqMmZmSlx6pQri0xt4ZbNFXYneQsP/LfmGtSaALLmAHJFjDx3BkoQSjO+zq78Tkse8tR6A4fbkffw+EI/zYsVBSw3mEyezgkU5UfBQDXKge+7oXByGOP2N74oCIvXTE9rDjy/FuCgJix5cQsMiBwQ4ZVUaN8e6yOanj72lHEzqqHVzzppsKeYPGc7clfrZwEl5HA+5fUNZi7tvdGHSjG9uy6RPSaBf1ERJkzrLFEg40Pmxu3MIQCyHYB7AXKIxC8378abskwCCWjTIUqxVF20xVg6BL2/93welSFeXOh7el9i9J7YtTPnh5BiY6ZvkI3l7robrbAlddZTLWDTdgofbL8ZIRBlUT6ah1PleVWI6Z+VIzNSRSV6eyBrzU7nnCKPJeUPKLKl/nblY85XsawjlP3svRAm8YN0w/hAtLfmyXmIzHe6eKktPDpl+KKoaRE31NtMAH9U7mz/NeRgG9XPS5J4XafUpzo
 yH3OBAzo
 mnW60YS9soICqcOjT9VteEh1Eyo26Jg4sMdaH7mwhYSYQJ7WjQfQMr80tsEtcnG1wQ+b+8u1JR3tSKlb0v+gHxsmf40cb/MuI69QWPOIpl/nkdegfy8u0neAmEYcsOJ3HDP+aK+08scMc23oiyC/f7Qet2E0XJo7PUItEojFXobpy3/ejETXAYvIlpxqYRN+EhXDNGP+5U0d5qZWoXHIG4mpXhvT7v4ccm5x4piinEzhSDf9CRw/iMv/W27FHLQHgkMPIs/MPaiLe/at/3pgJqE9LVfyDnow1vbur9ekPd7lOU+I6K1oteFK+bleex2lBDKusFerXSymlTSSEcNO6xzbY2FqtbiAueE5oY4fGcNKIqdQ5aqTGq1wU8HchJzCqdQ//9WTtXsWL8Ymk0Dd5zEf0zAyZ0J+hdA5dAtPgD6Z2eA9ZrAcIfg0Dh0jjjA+8btqJy4txiSAzsjR3GNrgnu2VBkshzTOLnyQ2lmPW17w55kWatUBA6N3OOaiwTdsCSoScgcmpKzvF7H8wSfZETbQAG+rYTDtGPv3MaIGscpcLoOLCiYphfZgkuF/t1+Ry654mw1ZEkMdO6/Uyp2k9PiUL384AHQ09sRdGwAuSt+P3266PTcJa4DaopWDnC5mUQFoUKnKbD4nuDtIBiY+uDEiA2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Inherit bus numbers from the previous kernel during a Live Update when
one or more PCI devices are being preserved.

During a Live Update, preserved devices must be allowed to continue
performing memory transactions so the kernel cannot change the fabric
topology, including bus numbers, since that would require disabling
and flushing any memory transactions first.

To keep things simple, inherit the secondary and subordinate bus numbers
on all bridges if any PCI devices were preserved (i.e. even bridges
without any downstream endpoints that were preserved). This avoids
accidentally assigning a bridge a new window that overlaps with a
preserved device that is downstream of a different bridge.

If a bridge is enumerated with a broken topology or has no bus numbers
set during a Live Update, refuse to assign it new bus numbers and refuse
to enumerate devices below it. This is a safety measure to prevent
topology conflicts.

Require that CONFIG_CARDBUS is not enabled to enable
CONFIG_PCI_LIVEUPDATE since inheriting bus numbers on PCI-to-CardBus
bridges requires additional work but is not a priority at the moment.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../admin-guide/kernel-parameters.txt         |  6 +++-
 drivers/pci/Kconfig                           |  2 +-
 drivers/pci/liveupdate.c                      | 28 +++++++++++++++++++
 drivers/pci/probe.c                           | 21 +++++++++++---
 include/linux/pci.h                           |  1 +
 5 files changed, 52 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index cf3807641d89..f412a4b77fb7 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5156,7 +5156,11 @@ Kernel parameters
 				explicitly which ones they are.
 		assign-busses	[X86] Always assign all PCI bus
 				numbers ourselves, overriding
-				whatever the firmware may have done.
+				whatever the firmware may have done. Ignored
+				during a Live Update, where the kernel must
+				inherit the PCI topology (including bus numbers)
+				to avoid interrupting ongoing memory
+				transactions of preserved devices.
 		usepirqmask	[X86] Honor the possible IRQ mask stored
 				in the BIOS $PIR table. This is needed on
 				some systems with broken BIOSes, notably
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 08398cbe970c..6ef457ff9d08 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -330,7 +330,7 @@ config VGA_ARB_MAX_GPUS
 
 config PCI_LIVEUPDATE
 	bool "PCI Live Update Support (EXPERIMENTAL)"
-	depends on PCI && LIVEUPDATE
+	depends on PCI && LIVEUPDATE && !CARDBUS
 	help
 	  Enable PCI core support for preserving PCI devices across Live
 	  Update. This, in combination with support in a device's driver,
diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index c0a30d16d9b8..cf8cff134a75 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -93,6 +93,19 @@
  * bound to the correct driver. i.e. The PCI core does not protect against a
  * device getting preserved by driver A in the outgoing kernel and then getting
  * bound to driver B in the incoming kernel.
+ *
+ * BDF Stability
+ * =============
+ *
+ * The PCI core guarantees that incoming preserved devices can be identified by
+ * the same bus, device, and function numbers as prior to kexec. To accomplish
+ * this, the PCI core always inherits the secondary and subordinate bus numbers
+ * assigned to bridges during enumeration, rather than assigning new ones (the
+ * PCI core assumes that the previous kernel established a sane topology).
+ *
+ * If a misconfigured or unconfigured bridge is encountered during enumeration
+ * while there are incoming preserved devices, it's secondary and subordinate
+ * bus numbers will be cleared and devices below it will not be enumerated.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -354,6 +367,21 @@ void pci_liveupdate_setup_device(struct pci_dev *dev)
 	if (!xa)
 		return;
 
+	/*
+	 * During a Live Update, preserved devices are allowed to continue
+	 * performing memory transactions. The kernel must not change the fabric
+	 * topology, including bus numbers, since that would require disabling
+	 * and flushing any memory transactions first.
+	 *
+	 * To keep things simple, inherit the secondary and subordinate bus
+	 * numbers on _all_ bridges if _any_ PCI devices were preserved (i.e.
+	 * even bridges without any downstream endpoints that were preserved).
+	 * This avoids accidentally assigning a bridge a new window that
+	 * overlaps with a preserved device that is downstream of a different
+	 * bridge.
+	 */
+	dev->liveupdate_inherit_buses = true;
+
 	key = pci_ser_xa_key(pci_domain_nr(dev->bus), pci_dev_id(dev));
 	dev_ser = xa_load(xa, key);
 
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 938a28e4a7a0..fa26f4170add 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1374,6 +1374,14 @@ bool pci_ea_fixed_busnrs(struct pci_dev *dev, u8 *sec, u8 *sub)
 	return true;
 }
 
+static bool pci_should_assign_new_buses(struct pci_dev *dev)
+{
+	if (dev->liveupdate_inherit_buses)
+		return false;
+
+	return pcibios_assign_all_busses();
+}
+
 /*
  * pci_scan_bridge_extend() - Scan buses behind a bridge
  * @bus: Parent bus the bridge is on
@@ -1401,6 +1409,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 				  int max, unsigned int available_buses,
 				  int pass)
 {
+	const bool assign_new_buses = pci_should_assign_new_buses(dev);
 	struct pci_bus *child;
 	u32 buses;
 	u16 bctl;
@@ -1453,8 +1462,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 		goto out;
 	}
 
-	if ((secondary || subordinate) &&
-	    !pcibios_assign_all_busses() && !broken) {
+	if ((secondary || subordinate) && !assign_new_buses && !broken) {
 		unsigned int cmax, buses;
 
 		/*
@@ -1496,8 +1504,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 		 * do in the second pass.
 		 */
 		if (!pass) {
-			if (pcibios_assign_all_busses() || broken)
-
+			if (assign_new_buses || broken)
 				/*
 				 * Temporarily disable forwarding of the
 				 * configuration cycles on all bridges in
@@ -1511,6 +1518,12 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 			goto out;
 		}
 
+		if (dev->liveupdate_inherit_buses) {
+			pci_err(dev, "Cannot reconfigure bridge during Live Update!\n");
+			pci_err(dev, "Downstream devices will not be enumerated!\n");
+			goto out;
+		}
+
 		/* Clear errors */
 		pci_write_config_word(dev, PCI_STATUS, 0xffff);
 
diff --git a/include/linux/pci.h b/include/linux/pci.h
index dd6b26ca9462..9a602b322e3c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -511,6 +511,7 @@ struct pci_dev {
 	unsigned int	rom_bar_overlap:1;	/* ROM BAR disable broken */
 	unsigned int	rom_attr_enabled:1;	/* Display of ROM attribute enabled? */
 	unsigned int	non_mappable_bars:1;	/* BARs can't be mapped to user-space  */
+	unsigned int	liveupdate_inherit_buses:1; /* Inherit bus numbers due to Live Update */
 	pci_dev_flags_t dev_flags;
 	atomic_t	enable_cnt;	/* pci_enable_device has been called */
 
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


