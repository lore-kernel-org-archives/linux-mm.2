Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9DE1CC6B1D
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 16:26:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD0E06B0098; Tue, 13 Oct 2026 12:25:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A80FC6B009B; Tue, 13 Oct 2026 12:25:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9225C6B009D; Tue, 13 Oct 2026 12:25:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62B916B0098
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 12:25:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC895160D38
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:45 +0000 (UTC)
X-FDA: 85318129050.08.4152EFD
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf22.hostedemail.com (Postfix) with ESMTP id 311A1C0009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 16:25:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="gmfnv/kZ";
	spf=pass (imf22.hostedemail.com: domain of 3hVvOaggKCNI1AyH9y084CC492.0CA96BIL-AA8Jy08.CF4@flex--dmatlack.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3hVvOaggKCNI1AyH9y084CC492.0CA96BIL-AA8Jy08.CF4@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791908744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gB4Ik4s4vBOpi0f9NA5ZP8iCM3imb0TW7qQ72X4ybKY=;
	b=smQY3MsDL1n8YEGQfaVtGDjn0g1BItWXAemwalT4Jg3KZQfoaiQqG/wYmhNKqRo+GL2cd/
	qynH9bz9wGY9U6tBB0TEWHi52x82K98iwWWZJubRiRigmY0y8sBCqtZYACLdzOEDU4RHKa
	BpAwocp3v/Gd9HmGAaKtjmT5drjsSKc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791908744;
	b=8je2y9JgqhYuSIfIKKtdViGeWrSrPWRVKKomvHrVb1FpDEbGO1/zwf9IdAqsIYg0N42ysb
	k5y9hmBhu0pj8Gi0rrJ/KXHNRmcCA35Xn+PsN9vyBehwo0LORnN2ilrRMcQjxzo8s3JmH8
	uDYMA1bcUWG0irAs7/qlyrRS/RShJ3I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="gmfnv/kZ";
	spf=pass (imf22.hostedemail.com: domain of 3hVvOaggKCNI1AyH9y084CC492.0CA96BIL-AA8Jy08.CF4@flex--dmatlack.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3hVvOaggKCNI1AyH9y084CC492.0CA96BIL-AA8Jy08.CF4@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2e827b3a6b4so46955245ad.2
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 09:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791908743; x=1792513543; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gB4Ik4s4vBOpi0f9NA5ZP8iCM3imb0TW7qQ72X4ybKY=;
        b=gmfnv/kZHNsDQROoeGI5sYTm4IMfFN3rMo3u5AgdJDEh8DljjXz4Hki2txdNABOOX3
         3rVpOfPw5VvcMlwd5EuJmsdrZNtSeuoyqiq7nAh9DK3WYfCcuuD9aPrQi/LpcQa5Gpkl
         kfYr84Os+TwkR3RrHaV1PRz9KexYymsha7tf7U07q5StVYAWw01TwYvjbLoxG7i2eJeA
         99VdDcxPC3SnxuRmcTsjeA7lpfSCltS3lzUs7Y9zWBbIV+vRKjJXfqHl56H1MrqK2/sN
         9ZwQk5CpwwPFemZLiQXW5kw3NZ7dYWXS3j6Ulj3LfwonJqsHflhMyVQtE9VvFYyY8uZ/
         TgIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791908743; x=1792513543;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gB4Ik4s4vBOpi0f9NA5ZP8iCM3imb0TW7qQ72X4ybKY=;
        b=U/hpVPjqLMSg3A0xxzItkWXh0o8qoPOyaHWILNIRgB9/XV3S5JvYb8UKnscOxQd7Gg
         MttCpn29bQBzzRastzMqJWOmVWeNjHRPqFK1myG8SDGFDVGhqk42t74P1j/jk7WamUII
         gEIEP6dXzKQUmt1j/+8w6k38w13JKWiH3Wx14qFLWBrQMEbHUnw8SlU1000y5C4HVdne
         tRxguEukWHhEmYPjeAb93j0cOqDHA2j3+3/QWVVHbOTEW6OgsfNELlftYeE6cD0EynFT
         QwCm48JW3fSy+3DAIF7OFn+OZcGfGLoh17CddM0ZqYxBlLkr+k9vquvWCrlcv16OYysk
         DgDg==
X-Forwarded-Encrypted: i=1; AKwUvByB9S3un0yebCF6viovcsKYJllfTg1rbm6y8OQnN2nAeqq9TaGvekBfzfNLYvChQc5TKObiqypKVw==@kvack.org
X-Gm-Message-State: AFq9FYKa7VtLBsgCJzEYn67x+Qs96x/J44Ye9yOGJsePDVf6cqLHCiHJ
	cKS+dDeCR0bP2sfm0PbSfXmb2wF7+d/W/9uKSgeKlMxJxSUYhpisNpGYCDCxI1zv+CGEHvmHf+0
	lFM5GnHyR4/4yGg==
X-Received: from plbx1.prod.google.com ([2002:a17:902:ea81:b0:2e5:d262:2f9a])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:2987:b0:2e4:b37a:d583 with SMTP id d9443c01a7336-2e842cf5aadmr102428285ad.61.1791908741304;
 Tue, 13 Oct 2026 09:25:41 -0700 (PDT)
Date: Tue, 13 Oct 2026 16:25:22 +0000
In-Reply-To: <20261013162529.1928093-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20261013162529.1928093-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
Message-ID: <20261013162529.1928093-7-dmatlack@google.com>
Subject: [PATCH v10 06/13] PCI: liveupdate: Preserve bus numbers during Live Update
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 311A1C0009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 76hffxbcnqmcono47tqahecy3gyy81bp
X-HE-Tag: 1791908744-22408
X-HE-Meta: U2FsdGVkX19X/lw1e8q/ftArDImfpXj0HuZNcrlY0nwxiKzv/2tTKsMHVWsn8SMHs1xJgmBJNG+e5FPyynhbA+Y9zbbLMvqoHDsLuAomHHeH/DZPX/HRthzmcPEGz4jdifDsr0e+Ad3Cr7u4JSGiOXIi+wwmFwduZja7woLOCU/sfBpfhzkZ7z1QOrZCSrDQD6GCPlCtD9xszH1nTAPN+qhHmb8brH6WcbIP+KP410/CaGPocMqgscgutmb1XtSMoKPjfxKlgkBlSJUBsoE3Q5PvDyrp3gyZ5YxGtDkfO/dHNlG6wAPUKc/fTxOaZhPtSth7o4GIWaa6k6aAoPPeHNFsqh68yumO50FY3JqTZ5CFpUTz+g9z3Jfoto+zD813fugFQog64h0cY5Fi7PelWsF2HI1yqJkohKylVcFHGYSPb4QmvW2/2PkXJgvcEmLaQ/4fByuIHoHrStB7yyaYyDqlZ5QfZexDp8uBjZE2GLOtO5rLiQY0PhS0eEfS5JPjwXldSGn3rSmn97W+5KxS/oAC6VwBupxtxFqJScYxi5571GHlTgdQy0GrAqNt+sw1LG+/btel9mZEBM/NZCw35NhHfMXSqD0ShsUhnsaMt3+Yw0ps30miIJGXQI/0oYQoG7Gyom6lez6RzGKiD2GlkbtfPllrwtoDnZfv/4HSwsUO61FQkWfbqvvPkoyNnH4XrljQW3W+KCIuNc1FzHmKZ04UnehqB5ESmW28KQefS1Au5dh+CVkOnmc44zhTkmunkQCr+JqVn4OaLwCkI80rBV8wIfOAD+OA4Myy6Y8xBQomcRe4TlrYkL47QQL2V/SFMqAXUVwQlEmE6m0fkfTSfDXZGR2w3RXHd2GFRFiSuEdT5Rb/WCEUPLjLNQdfjq4VxxlFoE39E4NseN4Da5GN9771pvIs2t56RTGNVJMo6aDiA1cqY/AmwUDMoE4sOW+zWuFCxkqEUZPZNsRZwW3
 1NgND01u
 xwBJZ4KoiLM2/ARBZ7whrxi3j/yY+jH7FyBDNfWQ7qz4AaQF4kg1cT6hJtN4a3jatVUJ2/1eEmibWG5n5YmKBQ2aJdvSl7mLMMH1H9hfcRFUphScLaPQP8ByeZPSTeqG78XitPz9PE7ZFjtGvwAQIt1mv6ScmZ7a28FApm5YTHhwbzKSLg01Q7trMlniQKv8uskeOOkes4R1Ijl3k7Y0vf+fcUxjgId3FXQFu+6oNu24yPOZAycS3gpcQaBedxOgyynK1sRmBhgCXJmrfNLYRwRgrD65av44rJLvCVV5xCoQ4LHeUJzIP6bCfueWWUPho3qeC1vLh7o46MdTC2AsfAIvqEnU/SFS+lvesDHewev4MjzRHQqHlccew6C+6ictQE/nKgb1BZenYnzCe2qBY3WU/nHfh+Q6orSuZX2Jnr56BC2XIM9E7K/fvty6ulVC5GC88nKq3HH5GVARZgRERIwES2RR5NA8BMzTfnd+Si6uQCE0E0mVH69acjWA0HUqEdfsEMi9bxBWdMHCC3yceQ+Ead+DsyRFBNKQ9tynDCH1ZBrswfk797wZDqWX60eq0K3W9NiFvd4emMD1q4cDEI2U/NUBMdTkYYUQ0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Keep the secondary and subordinate bus numbers that the previous kernel
programmed into bridges, rather than assigning new ones, if the previous
kernel preserved any device across a Live Update. Do this even on
architectures that would otherwise always assign bus numbers themselves,
e.g. when pci=assign-busses is passed.

Preserved devices must be allowed to continue performing memory
transactions across a Live Update, so the kernel cannot change the
fabric topology. Changing the bus numbers of a bridge changes the
RequesterIDs of the devices below it, which would require disabling and
flushing any in-flight memory transactions first.

Apply the policy globally rather than only to the paths that contain
preserved devices. Bus numbers have to be preserved above a preserved
device anyway, since an upstream bridge cannot expand its window. A
global policy matches the scope of pcibios_assign_all_busses(), and
gives an answer that cannot change part way through the two passes of a
bridge scan.

Bridges that do not have bus numbers are still assigned new ones, so
hot-adding a bridge keeps working, both during and after a Live Update.
The two-pass bridge scan guarantees such bridges are only assigned bus
numbers above those already claimed by preserved bridges.

The exception is a bridge that was preserved but comes up without a
valid bus number configuration, e.g. because it was reset during kexec.
Refuse to assign it new bus numbers, since that would silently change
the BDF of every preserved device in its hierarchy. Also refuse to
assign bus numbers to the other bridges on the same bus, since the bus
numbers of the failed bridge can no longer be read from hardware and
handing them out would let an unrelated device inherit the BDF of a
preserved device.

Require that CONFIG_CARDBUS is not enabled to enable
CONFIG_PCI_LIVEUPDATE since preserving bus numbers on PCI-to-CardBus
bridges requires additional work but is not a priority at the moment.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../admin-guide/kernel-parameters.txt         |   7 +-
 drivers/pci/Kconfig                           |   2 +-
 drivers/pci/liveupdate.c                      | 114 ++++++++++++++++++
 drivers/pci/liveupdate.h                      |  13 ++
 drivers/pci/probe.c                           |  11 +-
 include/linux/pci_liveupdate.h                |   5 +
 6 files changed, 146 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 68647ff4bdd2..7eabf6320abf 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -5170,7 +5170,12 @@ Kernel parameters
 				explicitly which ones they are.
 		assign-busses	[X86] Always assign all PCI bus
 				numbers ourselves, overriding
-				whatever the firmware may have done.
+				whatever the firmware may have done. Ignored
+				if any device was preserved across a Live
+				Update, where the kernel must preserve the
+				PCI topology (including bus numbers) to
+				avoid interrupting ongoing memory transactions
+				of preserved devices.
 		usepirqmask	[X86] Honor the possible IRQ mask stored
 				in the BIOS $PIR table. This is needed on
 				some systems with broken BIOSes, notably
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 8af20f558086..16fbd4212e0f 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -273,7 +273,7 @@ config VGA_ARB_MAX_GPUS
 
 config PCI_LIVEUPDATE
 	bool "PCI Live Update Support"
-	depends on PCI && LIVEUPDATE && 64BIT
+	depends on PCI && LIVEUPDATE && 64BIT && !CARDBUS
 	help
 	  Enable PCI core support for preserving PCI devices across Live
 	  Update. This, in combination with support in a device's driver,
diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index bffb3e1d8b2d..8d5ad26e948c 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -148,6 +148,32 @@
  * This enables the PCI core and any drivers bound to the bridge to participate
  * in the Live Update so that preserved endpoints can continue issuing memory
  * transactions during the Live Update.
+ *
+ * BDF Stability
+ * =============
+ *
+ * The PCI core guarantees that preserved devices can be identified by the same
+ * bus, device, and function numbers for as long as they are preserved
+ * (including across kexec). To accomplish this, the PCI core keeps the
+ * secondary and subordinate bus numbers that the previous kernel programmed
+ * into bridges, if the previous kernel preserved any device. This is true even
+ * on architectures that always assign new bus numbers during scanning. The
+ * kernel assumes the previous kernel established a sane bus topology across
+ * kexec.
+ *
+ * Bridges that do not have bus numbers are assigned new ones as usual, so
+ * hot-adding a bridge keeps working, both during and after a Live Update. The
+ * two-pass bridge scan ensures such bridges are only assigned bus numbers above
+ * those already claimed by preserved bridges.
+ *
+ * If a preserved bridge comes up without a valid bus number configuration, e.g.
+ * because it was reset during kexec, the PCI core refuses to assign it new bus
+ * numbers and does not enumerate anything below it. Assigning new bus numbers
+ * would silently change the BDF of every preserved device in its hierarchy. The
+ * PCI core also stops assigning bus numbers to the other bridges on the same
+ * bus, since the bus numbers of the failed bridge can no longer be read from
+ * hardware and handing them to another bridge would let an unrelated device
+ * inherit the BDF of a preserved device.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -168,9 +194,13 @@
  * struct pci_liveupdate_global - Global state for PCI Live Update support
  * @rwsem: Reader/writer semaphore used to protect the incoming and outgoing
  *         FLBs, and the references to them in struct pci_dev.
+ * @had_incoming: True if the previous kernel preserved at least one PCI device.
+ *                Set when the incoming FLB is retrieved and never cleared, so
+ *                it stays true after Live Update finishes.
  */
 struct pci_liveupdate_global {
 	struct rw_semaphore rwsem;
+	bool had_incoming;
 };
 
 static struct pci_liveupdate_global pci_liveupdate = {
@@ -316,6 +346,14 @@ static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
 			      ret);
 	}
 
+	/*
+	 * Remember that the previous kernel preserved devices for the lifetime
+	 * of this kernel, even after Live Update finishes and the incoming FLB
+	 * is freed. See pci_liveupdate_preserve_bus_numbers().
+	 */
+	if (!xa_empty(&incoming->xa))
+		pci_liveupdate.had_incoming = true;
+
 	args->obj = incoming;
 	return 0;
 }
@@ -624,6 +662,80 @@ static void pci_liveupdate_flb_put_incoming(void)
 	liveupdate_flb_put_incoming(&pci_liveupdate_flb);
 }
 
+/**
+ * pci_liveupdate_preserve_bus_numbers() - Determine if the PCI core should
+ *                                         preserve bus numbers when scanning
+ *                                         bridges.
+ *
+ * This function is called by the PCI core when it is scanning a bridge. It
+ * determines whether the PCI core should preserve the secondary and subordinate
+ * bus numbers that the previous kernel programmed into that bridge, rather than
+ * assigning new ones. This is necessary to keep RequesterIDs constant for
+ * preserved devices issuing memory transactions.
+ *
+ * Bus numbers are preserved everywhere, and for the lifetime of the kernel, if
+ * the previous kernel preserved any device. Bus numbers have to be preserved
+ * above a preserved device anyway, since an upstream bridge cannot expand its
+ * window. Applying the same policy everywhere matches the scope of
+ * pcibios_assign_all_busses(), and gives an answer that cannot change part way
+ * through the two passes of a bridge scan.
+ *
+ * The incoming FLB is retrieved while setting up the first device, which always
+ * happens before any bridge is scanned, so this returns the same answer for the
+ * entire enumeration.
+ *
+ * Note that this does not prevent the PCI core from assigning bus numbers to
+ * bridges that do not have any, e.g. bridges that are hot-added after the
+ * Live Update. See pci_liveupdate_refuse_bus_numbers() for the one case where
+ * the PCI core must refuse to do so.
+ *
+ * Return: True if bus numbers should be preserved, false otherwise.
+ */
+bool pci_liveupdate_preserve_bus_numbers(void)
+{
+	return pci_liveupdate.had_incoming;
+}
+
+/**
+ * pci_liveupdate_refuse_bus_numbers() - Determine if the PCI core must refuse
+ *                                       to assign bus numbers to the provided
+ *                                       bridge.
+ * @bus: The PCI bus the bus numbers would be assigned from.
+ * @dev: The PCI bridge device the bus numbers would be assigned to.
+ *
+ * This function is called by the PCI core before it assigns bus numbers to a
+ * bridge that does not have any.
+ *
+ * A bridge that was preserved by the previous kernel but came up without a
+ * valid bus number configuration, e.g. because it was reset during kexec, is
+ * left alone by the PCI core and therefore has no child bus once the first pass
+ * of the bridge scan is done.
+ *
+ * The PCI core must not assign bus numbers from @bus while such a bridge is on
+ * it, including to the failed bridge itself. Assigning new bus numbers to the
+ * failed bridge would silently change the BDF of every preserved device in its
+ * hierarchy. Its bus numbers cannot be read from hardware anymore either, so
+ * they cannot be excluded from assignment, and handing them to another bridge
+ * would let an unrelated device inherit the BDF of a preserved device.
+ *
+ * Return: True if @dev must not be assigned bus numbers, false otherwise.
+ */
+bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus, struct pci_dev *dev)
+{
+	struct pci_dev *bridge;
+
+	for_each_pci_bridge(bridge, bus) {
+		if (!bridge->liveupdate.was_incoming || bridge->subordinate)
+			continue;
+
+		pci_err(dev, "Not assigning bus numbers, preserved bridge %s lost its bus number configuration\n",
+			pci_name(bridge));
+		return true;
+	}
+
+	return false;
+}
+
 void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
 	struct pci_flb_incoming *incoming;
@@ -652,6 +764,8 @@ void pci_liveupdate_setup_device(struct pci_dev *dev)
 
 	pci_info(dev, "Device was preserved by previous kernel across Live Update\n");
 	dev->liveupdate.incoming = dev_ser;
+	dev->liveupdate.was_incoming = true;
+
 	pci_liveupdate_flb_put_incoming();
 }
 
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index eaaa3559fd77..e5d2a19d2ca2 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -13,6 +13,8 @@
 #ifdef CONFIG_PCI_LIVEUPDATE
 void pci_liveupdate_setup_device(struct pci_dev *dev);
 void pci_liveupdate_cleanup_device(struct pci_dev *dev);
+bool pci_liveupdate_preserve_bus_numbers(void);
+bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus, struct pci_dev *dev);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -21,6 +23,17 @@ static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 static inline void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 {
 }
+
+static inline bool pci_liveupdate_preserve_bus_numbers(void)
+{
+	return false;
+}
+
+static inline bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus,
+						     struct pci_dev *dev)
+{
+	return false;
+}
 #endif
 
 #endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index ad7fdf0d56b6..debe0ad1ef68 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1397,6 +1397,8 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 				  int max, unsigned int available_buses,
 				  int pass)
 {
+	bool preserve_bus_numbers = !pcibios_assign_all_busses() ||
+				    pci_liveupdate_preserve_bus_numbers();
 	struct pci_bus *child;
 	u32 buses;
 	u16 bctl;
@@ -1449,8 +1451,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 		goto out;
 	}
 
-	if ((secondary || subordinate) &&
-	    !pcibios_assign_all_busses() && !broken) {
+	if ((secondary || subordinate) && preserve_bus_numbers && !broken) {
 		unsigned int cmax, buses;
 
 		/*
@@ -1492,8 +1493,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 		 * do in the second pass.
 		 */
 		if (!pass) {
-			if (pcibios_assign_all_busses() || broken)
-
+			if (!preserve_bus_numbers || broken)
 				/*
 				 * Temporarily disable forwarding of the
 				 * configuration cycles on all bridges in
@@ -1507,6 +1507,9 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 			goto out;
 		}
 
+		if (pci_liveupdate_refuse_bus_numbers(bus, dev))
+			goto out;
+
 		/* Clear errors */
 		pci_write_config_word(dev, PCI_STATUS, 0xffff);
 
diff --git a/include/linux/pci_liveupdate.h b/include/linux/pci_liveupdate.h
index 710026ada2d5..d45a5b524909 100644
--- a/include/linux/pci_liveupdate.h
+++ b/include/linux/pci_liveupdate.h
@@ -17,10 +17,15 @@
  * struct pci_liveupdate - PCI Live Update state for a struct pci_dev
  * @outgoing: State preserved for the next kernel.
  * @incoming: State preserved by the previous kernel.
+ * @was_incoming: True if this struct pci_dev was incoming-preserved when it was
+ *                set up, i.e. it was matched to state preserved by the previous
+ *                kernel. Unlike @incoming, this is never cleared, so it stays
+ *                true after the device finishes participating in Live Update.
  */
 struct pci_liveupdate {
 	struct pci_dev_ser *outgoing;
 	struct pci_dev_ser *incoming;
+	bool was_incoming;
 };
 
 struct pci_dev;
-- 
2.56.0.385.gd3acb90ef8-goog


