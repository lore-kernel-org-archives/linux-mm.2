Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81D31C982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:07:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 042496B00A4; Fri, 18 Sep 2026 16:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019946B00A7; Fri, 18 Sep 2026 16:07:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD5696B00A6; Fri, 18 Sep 2026 16:07:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9B59E6B00A4
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:07:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0DE1A1C3114
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:02 +0000 (UTC)
X-FDA: 85227966684.26.AAF3218
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4066840007
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:00 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UXQeLW6d;
	spf=pass (imf07.hostedemail.com: domain of 34pmtaggKCCkIRFYQFHPLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--dmatlack.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=34pmtaggKCCkIRFYQFHPLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762020;
	b=UY57UaZLu+hhuxiqLMZhzIX3baf1uRNLW4yi43OiziejPkKnCd4u6ZCGkZD8LeR7pMZAfz
	8kllGLByv9axKURbtH2Hxy3jxDt/9YX40NyVclzPbBnZkMsIWcylX5+vvbxi2ZpS2LQOWB
	JwuyDryHAJtP1/aaX+MGFCLr19WV9VI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UXQeLW6d;
	spf=pass (imf07.hostedemail.com: domain of 34pmtaggKCCkIRFYQFHPLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--dmatlack.bounces.google.com designates 209.85.210.197 as permitted sender) smtp.mailfrom=34pmtaggKCCkIRFYQFHPLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xo8UJHtlxlUvwILpRPy7TNgBxku4CDc7VxpXGrQJEKs=;
	b=k21eY4Xb3RN2Wm9vXpEAOdVfK/pf5u/MHbkN6k0hpSNL8aQmnB6ljY254QksR9OcrCoRpY
	BSCkelvyXaKgYm7uh0kz5yn5IKKk7hfcCN5O1cawomplzWCAyFH2aJhUtMecYuHxmoE8Fp
	46/7WU7KgEvehumWuwlaVLRk9gNpyvY=
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-855f662439aso2317775b3a.1
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789762019; x=1790366819; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xo8UJHtlxlUvwILpRPy7TNgBxku4CDc7VxpXGrQJEKs=;
        b=UXQeLW6dfOf/fiU5B+Y6/6+9BXTq00i3UZ++pRvyr7WzE97N+xzAmk6griSDhNNM1J
         mKbngy8uX5kglN8LFxDEm/FP2l520z7MafkHYfnewtCs1MSZMjZ/NkkB1YnyNFyH4GMN
         FAJu2v0UHVqW7FZf6HheV7kH91h73w5OkQCeYJGLvul7bN0vHE8zV+eVTehDmqGO9Xzj
         XzwHwlKmrXiiQo66i4Vv8e/mltRhPZOjvmSxhD3cFZye/jZW90d1h3+LlIfFj1u0Ck/e
         CHf1457QortHeAOoIbb+9KTCTHfMFGkU3PHZv7PPyIc2nqjKojxdU0ZtYAg2cpsgqdsq
         wMrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789762019; x=1790366819;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xo8UJHtlxlUvwILpRPy7TNgBxku4CDc7VxpXGrQJEKs=;
        b=HwfL1gZ1aQFzPlf8omyUejnb+hKEmtf5IrS48iqNgzbYclk9yKCQYzCBqRGlmoHDh4
         /RW3dML5uZYSnhefYg9WgCjV6CyPpC1b7CLbpTUfDELUc7MTS6CEfveiGxAj0mMQ13rq
         LcMZWfSIFtzWPnlJNzjpc2oceN4Ut0hlt+sUyCY8mh3EdMKLAH74TfZ36Dlo8SnZk7K/
         aQ1dpUoSS1Hxj2eaNUEAIq1qK/TYVx73JEO19dyu62vAgF1kxFoKsk1X5/NTUg815p7P
         qL8SZZa+UhtdVYmNnNr+akwJgwHMO0KtH+/ptFADgtYQhWfdsfpcXn8XACr2vb+P0u74
         79FA==
X-Forwarded-Encrypted: i=1; AKwUvByPff/8rX5JvigCMeVkwVe3rG7oEI8qq2NlDpe0mrAl5xaZWZNFFeH8Hor8tkDUT63pal22g4FSDA==@kvack.org
X-Gm-Message-State: AFuF++kUBFzypkb807piApA/sdGFo0T0eb823AYWUzhmcBf/6jTlv1j8
	agq0x7mMdipSca/OTsvd8u350rdOgdnX4qbx/iWpAOaLPLU32dMCkGY/LR6lheKUHB5T+g1RODR
	tiVulMwQtbuTdfA==
X-Received: from pgbck10.prod.google.com ([2002:a05:6a02:90a:b0:c92:460e:4f73])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:329c:b0:3dd:a197:ede3 with SMTP id adf61e73a8af0-3dda197f83dmr1008455637.50.1789762018870;
 Fri, 18 Sep 2026 13:06:58 -0700 (PDT)
Date: Fri, 18 Sep 2026 20:06:32 +0000
In-Reply-To: <20260918200640.887030-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260918200640.887030-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918200640.887030-7-dmatlack@google.com>
Subject: [PATCH v9 06/13] PCI: liveupdate: Preserve bus numbers during Live Update
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4066840007
X-Stat-Signature: czfmxoq1omrmf3rq6ixfanx5imzccszq
X-Rspam-User: 
X-HE-Tag: 1789762020-940138
X-HE-Meta: U2FsdGVkX19fnYZW7/BvBrT574JPZdwhWL75JWwn7YCGOnmH4pYV6jzaNYJD4iAZl09DzIveJKKakFdkBOn+0YSGWEH+wo3x6ReotVLvoBAxdCERvjH1zwH+YX++SRwM8S+Fz3tSDp+rhm5wVqFYrW/Z2H3zF0SojEEF0MWsNjJb6yN2fZrJTIcuflurb5ihw1w1FJM0SnWSWYST6sDslci8a1JU1+huuT9nm3E89oaBFQO1LtNH2CLz1d7cMffoF/3zk/sxla22l4YFtNfhDshu1a9+NzVlnZ5hjj6UAObNUPu0XxHtpLFQwOCrnfpi1QxYiFVJXWQS1UhG/vqlb5f1t4DCi3IS4uUBzQ4Z7XHNd7dLtfGg4zRf11l10wrhslX3xe6S/J5/tVGXQlwjksLemSzimYQxNUZsxlI5+1OBWKI3gXG1SdUbB3kIzb9eeVTGnXh2adrpibq7cBZD0F2/Yzgxent1OiYUfHGYYSTagXP7s3NMAkoeU/B8K7Bm5Gq1V9pGB8DXsiBKWoMRo6adTZ14iEmvZ3SB1BE59JP/M+uExkHiIowFYPxP8fZjwQGDFWGYgZklj6pxtfbdb3V7xvlQNBQRr9CNQRMf0ROQMyIFBfzupBya8xxaBTHFK+29g7ZRQZ+qOjnV2HTuJUDk2T3T+z7z9jHNhjV/CotR7rSpikgX59ZGLqM/WJP8xh4oQ29lgohL8y9pYgsFnE2RYc951M2P1ZxFtlkk26963K2TYaoX7fTugmqR6dvSvIYSJZIgjE818PaBZXyTer5gKQN25m6BaAuP/3aqeNPleEknLzOj6fuEbv77hnFVszacXVKD0mvC4peX5FS3iCHxcQKDLmW1BHkHCrUP4/NhzvfJcu1sjSz0UM5ws5vOcoIgggvxODrR+ZJZ/zvar3gNBWnE3cElaB/ea037JR2AEKxIJO5UcvhBueda8ov6+CM1tZjj1x/yG+fdKMX
 A+ztJRbN
 B1tNE2dLrNASIsxXJoy1IW1ppkVJeCuVGdRfuEmv6G4QaM1vzEdZSNmEwswZRQqXGnLa/PfGF0l/JK5uSHL2VbtplsCi3u4zrM+wblvqQh5dj4zGxWD3Ii27OLuki66GUrzKY0QTRK0jrSzBd3KJshHGZJJjanottwuMeVrjx5ziw2I1Xa01VogOKFfIt/wP4ISd9hnKYIhC5pMWSkXoVnjWH5jXw78ugDMCj3oIfXJL6KtwP9VaCNoJ8dvQ7rJLO7gra5iKDvmmIJgwI/vU6gEui/+VMIeywO108i0MNQW2Q2e7Ny4a1Np3K1YB7szyPRCcLMlnbbE6c2Gnyz1H44/0RXzPQIAg126ncvT6QFyROmt/lmIqrm90g1Jc77/wPvKMvPIMrswxI4eqjaBfZspJPasbS/9AU73VgHXEHZ7ak/37GwJRnKxOn1X/4kYHl4katH1ZgCPTGvCxvPwN7i6Dr8MBFwUahk8NcPwaT5A4h233+rcQk/Wb6E424utR1/wATaVC++bjc6b/Aa1ppgjXq2VitFaitWN75unhXlaDNnw9fNHVBtC90M7Bf94hGOUbtUglPI4/L0bOlBBDAsttq0eG3OZuv6QPP
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
index 825df024eec4..686887a6c8d9 100644
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
@@ -298,6 +328,14 @@ static int pci_flb_retrieve(struct liveupdate_flb_op_args *args)
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
@@ -606,6 +644,80 @@ static void pci_liveupdate_flb_put_incoming(void)
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
@@ -634,6 +746,8 @@ void pci_liveupdate_setup_device(struct pci_dev *dev)
 
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
2.55.0.1082.g2b9226bbc0-goog


