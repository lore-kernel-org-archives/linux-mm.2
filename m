Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E4C4F532C4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:58:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 020D56B0099; Mon, 23 Mar 2026 19:58:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3BBD6B009D; Mon, 23 Mar 2026 19:58:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E51056B009E; Mon, 23 Mar 2026 19:58:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D33326B0099
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:58:47 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 644E213C275
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:47 +0000 (UTC)
X-FDA: 84578995494.29.7B600D6
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf28.hostedemail.com (Postfix) with ESMTP id 952B3C0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:58:45 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SLRLb7kl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3tNPBaQgKCLcajXqiXZhdlldib.Zljifkru-jjhsXZh.lod@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3tNPBaQgKCLcajXqiXZhdlldib.Zljifkru-jjhsXZh.lod@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774310325; a=rsa-sha256;
	cv=none;
	b=yDX86Za6rAku4oOQqwg/cJuQ5Y1IK3CZChr8WKsCrNQwNgjL8kOATcJ7XjDty2aL7aRxSX
	ksS269SUeZ4luvOZOw2UcYpwzXUNJZMSflddwHFEyw+EvUgfaTVvhdIwPkFw5rQHq6pP2H
	PgK/wQcwUI/iTA5ssGyq6ONduP6c+yg=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SLRLb7kl;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3tNPBaQgKCLcajXqiXZhdlldib.Zljifkru-jjhsXZh.lod@flex--dmatlack.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3tNPBaQgKCLcajXqiXZhdlldib.Zljifkru-jjhsXZh.lod@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774310325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g7UW0RmcLc1SB8VXNrTH33hzd4ZkDSbd/G4mL4V5lhA=;
	b=kz59GSLXNQhxU8Ls+vAsaZGcLHVPl749JcxjYfjKANjej7bsEpdGN2eTrn9r7eHhQMc7Cf
	IdL/h6H2SJ2eceqVb7pbW4cKla11taM7ACYcSExYZI2u2DLnNDGu+FY3vX96eJrkCg+6qK
	Hs5+mPVXyTVp4BhjO3XKaVxmy4togHc=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2b079b4a8c3so3137025ad.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:58:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774310324; x=1774915124; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=g7UW0RmcLc1SB8VXNrTH33hzd4ZkDSbd/G4mL4V5lhA=;
        b=SLRLb7kl5l+G/tOeFd+KN/v8rwDNRTOEC0uIC06QkijqmaQsoew6eVRYmySjc/C0N/
         5WREVSeUUdnv1G6mZ7kU7furX3JJdJF6xkcjrqIX01+yR8lT/BsoQrUP2JsIpvrwH2mK
         w5jZETLmBAmre+VDw1rjYRibezSCdylASn7g7Ql7EZtOEGUbexpmg1/Z1j/8bgHRW/lv
         rh6sunRry3BrkeFlpmBt5AMGK32m5W6tOzG7aHa1s1VE6l2IjrBPbtXtN9m5KPKI+Mkl
         +jTeRHl5Rbmx7ntEXCpnd0n4rd4cvbVt7vf0rt//cPQANu5bhfUDAcMT7ZnpixP6E8j0
         X3xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774310324; x=1774915124;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g7UW0RmcLc1SB8VXNrTH33hzd4ZkDSbd/G4mL4V5lhA=;
        b=W8f+u0EQjihM1tUuoFyOwOuKLnVytfPT8RAw2QSpiNza9B1B4+QYPYZIGrUb/M612S
         btb92NNsBiiFEXIgHdfSrWQHxFXy8VBHB58wlJF8i6U1ea8mwn3Xj7alx2U2RCIVd/wY
         5Ng4LRNqPNbfW0HWl+Mdt05ZJX1NB13gPVpDb1xR85dwiKTjmfUrqkku+3TymHUzU/ig
         fI9NGP+YcMfqTaXBM4Yr4xCpHPMyDaRgHcil5MLfvH7NcaVTP3JMNRFuRxM4/0spWlea
         vPHwD2/K7MhQ+LmC2ttmz9BvdrniwrxIz9BoxaNTW6rRlNB+GbXtz/VkXn+xT+3AInj6
         B5Tw==
X-Forwarded-Encrypted: i=1; AJvYcCVIKoZqAxN01VZI+ToBHnQ1nNNsCz8/0Mh+CqdVdmKe2qgOFFa0GmQ08kwb1351noUfHzj7LrTo+w==@kvack.org
X-Gm-Message-State: AOJu0YwIIWWe4Tfr6dfLem5z8jwXJ0CpiVVDwinc+XdOKFJWTqejRoR7
	pgF+aSf6YqRnUcGlyK9Tj6Zyydw/WwlknwIvcDRgN/ZQkgV6+tJYe7YVuY7y1r6BdJQMyH2s/6D
	dIuAiEW98eW1Kxw==
X-Received: from plbjx15.prod.google.com ([2002:a17:903:138f:b0:2b0:5b78:8e47])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e54a:b0:2b0:9183:ce1e with SMTP id d9443c01a7336-2b09183d6ddmr75835585ad.30.1774310324185;
 Mon, 23 Mar 2026 16:58:44 -0700 (PDT)
Date: Mon, 23 Mar 2026 23:57:56 +0000
In-Reply-To: <20260323235817.1960573-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260323235817.1960573-1-dmatlack@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323235817.1960573-5-dmatlack@google.com>
Subject: [PATCH v3 04/24] PCI: Inherit bus numbers from previous kernel during
 Live Update
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Mastro <amastro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Arnd Bergmann <arnd@arndb.de>, Askar Safin <safinaskar@gmail.com>, 
	"Borislav Petkov (AMD)" <bp@alien8.de>, Chris Li <chrisl@kernel.org>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Feng Tang <feng.tang@linux.alibaba.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kees Cook <kees@kernel.org>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Li RongQing <lirongqing@baidu.com>, Lukas Wunner <lukas@wunner.de>, Marco Elver <elver@google.com>, 
	"=?UTF-8?q?Micha=C5=82=20Winiarski?=" <michal.winiarski@intel.com>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Pawan Gupta <pawan.kumar.gupta@linux.intel.com>, 
	"Peter Zijlstra (Intel)" <peterz@infradead.org>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 952B3C0005
X-Stat-Signature: b76n4iapsctrhqupbccbfm8b54d61fca
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1774310325-755466
X-HE-Meta: U2FsdGVkX1/NB5gXCyi06DwLeo2kRju2ndKH3ETL/w0xdLDdoFbXOEFrcsmkTQB/6Ir/LhxUbgxng0ILKYExTpnRcQx0hODGBRJfeFc1gPGog/oaqHC8sxyYKJojrpPbmXQdvDIaMq8XqCfoK77i/GE72qpLqit5EBZ2SM7Bqs2XcEYgARrkcryhC4v64l77ke6pEIoH1TH1eSgOalJS3clYbHW2quBIztgO870c9R7MgzYQe9E5mW9LbA6EUk0JF9k4bt4OVjtnk4DbxTMBC/bBMjUmlSGgURPpfsCc9ZpHDT4ziv2dJhSAg3U/pqXBXbhHHsTbi6FgsuiRZodNVDKTd2fIIKK6KnqgElS2EeSALW8SiodMrj+GWi8qHHzvFIf75XA5vlUyIZ11LXGG0sINz/zkNI1gJwkfgfvdxWHYivSFfGhN7ATlRNcsfIemTPvVYl6hlk5GYztPaAJUoniVeM6tOSGsFsdURUCrLQBCoyxS9/NnYBPwSzCV0N8yutBjzswj1IvMWRsaezlN+52gOv0zptXi0oUYpFJJyRpxTPXPywkGqgHY0I16U6dmOEY72Zl1zHCUDS8bkVnZWio9XxNQKIMlqnV2B2td7XaW4wwnJYyImiv3VK2GQvLNFTjSH8SZwGHvVc4Wc4LCdTGSv35TuIl/676Dc214CTtL9dYYGR+QE2jwTYi9OUz9LMsZ1OPLqX8iH2Xy6De3c8aBgCJqPzb9l8PbuN+gfL77weZtVjx48FfNDnLVxepAQ6Rq6w8Y4UNJoZBLTZYdfgyqbtHEDTKp5ZCdpN98P6xeaDO+9JIJl/CtHejWKN9+2cqPmoZg5fXFTkoJay6tJPbTRnncl3yOvlq/mEZDY+j7PREo6ldgjGT1JhtFi5Kik68KF+bJICOd2detP+c+Dp+CIp3irhpJVwJ6sR6T4QU53csPXCbq7N1YeCHP+9F6FfKmdp4gGu2YbOSpSbQ
 /ENYLFoH
 ls3OEsZq+XbZ1aOpRfKAnWFGzsSZyjEP9drz63s7yoJcUx0hLzQJKKmuxOdYA7xxS9lq5MN8lnGCFr0DQtMJAF+90Fk42VssfwkGebSQw2reWuXBaWK1plHXGsgPMCR5FJa07YoY9+QXPyl+cQ1/S+QnKvoBRc7jbaT1irKeVzcN24F5KdSo3QGnrGPoiP7apfx6bInI8KrJpP0TW87+PkAvWrMYoR+ThwE0zUjG8BKakYg/CedWvfDRM/NykdIiqMzwJyQreyLoCScRu5n9YfPehvfoZ27iCvxFvuGkXRstyDhQx/l7b/6tE7ubFE2JmNmZ1kkl2JMK83hx67vMRIuu/hAO0h9B+P2DjrUw+dmE+RLaQAVJwp5Aebw3bNn0hAu5UvSozuXT+J7dZT+/vPK1TFIuFWPeuMc7QCpLyvNz2UaW7+rKH0vq7TZTW+pVMk+yjTqW9AIiwau6d9G0tqbetmiqtselUXVUz7cBTfJohaO0jz8RfJ9DfhB4sfoyHInh6FhnJB+B4dT76ZL0nA+kr3E2bth+8EXHkU41awX0aEkB4N/8yChOWkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Inherit bus numbers from the previous kernel during a Live Update when
one or more PCI devices are being preserved, even if pci=assign-busses
is enabled.

During a Live Update, preserved devices will be allowed to continue
performing memory transactions. Thus the kernel cannot change the fabric
topology, including changing bus numbers, since that would requiring
disabling and flushing any memory transactions first.

So if pci=assign-busses is enabled, ignore it during the Live Update and
inherit all bus numbers assigned by the previous kernel. This will not
break users that rely on pci=assign-busses for their system to function
correctly since the system can be assumed to be in a functional state
already if a Live Update is underway. In other words, pci=assign-busses
would establish a functional topology during the initial cold boot, and
then that topology would remain fixed across any subsequent Live
Updates.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 .../admin-guide/kernel-parameters.txt         |  6 +++-
 drivers/pci/liveupdate.c                      |  5 ++-
 drivers/pci/probe.c                           | 35 ++++++++++++++++---
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 03a550630644..beff9f3f8e3b 100644
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
diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index a3dbe06650ff..c1251f4f8438 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -84,7 +84,10 @@
  * Update:
  *
  *  * The PCI Segment, Bus, Device, and Function numbers assigned to the device
- *    are guaranteed to remain the same across Live Update.
+ *    are guaranteed to remain the same across Live Update. Note that this is
+ *    true even if pci=assign-busses is set on the command line. The kernel will
+ *    always inherit bus numbers assigned by the previous kernel during a Live
+ *    Update.
  *
  * This list will be extended in the future as new support is added.
  *
diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index c60222d45659..165056d71e66 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1369,6 +1369,34 @@ bool pci_ea_fixed_busnrs(struct pci_dev *dev, u8 *sec, u8 *sub)
 	return true;
 }
 
+static bool pci_assign_all_busses(void)
+{
+	if (!pcibios_assign_all_busses())
+		return false;
+
+	/*
+	 * During a Live Update, preserved devices are are allowed to continue
+	 * performing memory transactions. Thus the kernel cannot change the
+	 * fabric topology, including changing bus numbers, since that would
+	 * requiring disabling and flushing any memory transactions first.
+	 *
+	 * So if pci=assign-busses is enabled, ignore it during the Live Update
+	 * and inherit all bus numbers assigned by the previous kernel. This
+	 * will not break users that rely on pci=assign-busses for their system
+	 * to function correctly since the system can be assumed to be in a
+	 * functional state already if a Live Update is underway. In other
+	 * words, pci=assign-busses should be used to establish working bus
+	 * numbers during the initial cold boot, and then that topology would
+	 * then remain fixed across any subsequent Live Updates.
+	 */
+	if (pci_liveupdate_incoming_nr_devices()) {
+		pr_info_once("Ignoring pci=assign-busses and inheriting bus numbers during Live Update\n");
+		return false;
+	}
+
+	return true;
+}
+
 /*
  * pci_scan_bridge_extend() - Scan buses behind a bridge
  * @bus: Parent bus the bridge is on
@@ -1396,6 +1424,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 				  int max, unsigned int available_buses,
 				  int pass)
 {
+	const bool assign_all_busses = pci_assign_all_busses();
 	struct pci_bus *child;
 	u32 buses;
 	u16 bctl;
@@ -1448,8 +1477,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 		goto out;
 	}
 
-	if ((secondary || subordinate) &&
-	    !pcibios_assign_all_busses() && !broken) {
+	if ((secondary || subordinate) && !assign_all_busses && !broken) {
 		unsigned int cmax, buses;
 
 		/*
@@ -1491,8 +1519,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
 		 * do in the second pass.
 		 */
 		if (!pass) {
-			if (pcibios_assign_all_busses() || broken)
-
+			if (assign_all_busses || broken)
 				/*
 				 * Temporarily disable forwarding of the
 				 * configuration cycles on all bridges in
-- 
2.53.0.983.g0bb29b3bc5-goog


