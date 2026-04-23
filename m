Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9A2FFDEE4D
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 21:23:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38C646B009B; Thu, 23 Apr 2026 17:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316A36B009D; Thu, 23 Apr 2026 17:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B7336B009E; Thu, 23 Apr 2026 17:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 07A5A6B009B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 17:23:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B47781B81BF
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:35 +0000 (UTC)
X-FDA: 84691097190.06.3658D35
Received: from mail-pj1-f73.google.com (mail-pj1-f73.google.com [209.85.216.73])
	by imf23.hostedemail.com (Postfix) with ESMTP id C940B14000F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 21:23:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FdIDmFdS;
	spf=pass (imf23.hostedemail.com: domain of 31I3qaQgKCO8UdRkcRTbXffXcV.TfdcZelo-ddbmRTb.fiX@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=31I3qaQgKCO8UdRkcRTbXffXcV.TfdcZelo-ddbmRTb.fiX@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776979413; a=rsa-sha256;
	cv=none;
	b=ef6irMFn3oKQg/yvGKQIHplQVZJ0i9ioC/fX1MBQXhskq9sBn/T2QhnGgx493abc8fhfjA
	VhIDswH1e5Ue10KEIDzY15wv91mgTsKIJriB7FY5wvpuG1k8Kxh9uhTj+FCnop6VT5zrnr
	cOtevnfFDS26gRMvxRmJrTR8z/rz5dE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FdIDmFdS;
	spf=pass (imf23.hostedemail.com: domain of 31I3qaQgKCO8UdRkcRTbXffXcV.TfdcZelo-ddbmRTb.fiX@flex--dmatlack.bounces.google.com designates 209.85.216.73 as permitted sender) smtp.mailfrom=31I3qaQgKCO8UdRkcRTbXffXcV.TfdcZelo-ddbmRTb.fiX@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776979413;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ys4uatxpJYM7Kl1KgUYRndxIbkLNusGMab4h1bmL7Us=;
	b=LFaPwVUAC3LmUzmKlOFOOGxCsRGtPtKJUx/oXNh8rPsHwlg8eQvZL1zFWhepr95/gqkGTq
	4yiJiAs1LmAHYoWB3Ng8ZbOMfIugQ+sLqA8/zU0eWk9y/iQVr9qTh+WaE9/5IarIEoS3b5
	ZZ6Mi/c6DaX6xQ2jQicInqqruB3K4KI=
Received: by mail-pj1-f73.google.com with SMTP id 98e67ed59e1d1-35d9278587bso8317598a91.2
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776979412; x=1777584212; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ys4uatxpJYM7Kl1KgUYRndxIbkLNusGMab4h1bmL7Us=;
        b=FdIDmFdS3n0DZ2Y8gHuRA3OCiV7GQNurTmboCOKBFZVoou0lLHV+5epKI/zpmEx0jP
         XODxGzxaSCby5oG6pv0gwkRFKJS+YuOR4++Fr5A0e7kFIPLjfaRA94MXNS34Egr4s62E
         aVsauHuYYsMAh9BX7JhLikArhh/OZvH4JCJxJ1D6YzENtfuWJfHnq529FST1iK6l66jg
         WqAqdm8yHOKWbqky3tLWovfl+XGs4YvxHl2DyVQIkzQJYmxrYbD3lvU3oMU/L2oWGvz2
         awPrEGrdcpqOySTxU89+RUX0ZnokfHVtdBwT4owbQx/iCDjvgiATHn7CixQiFBtFzSDZ
         gz2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776979412; x=1777584212;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ys4uatxpJYM7Kl1KgUYRndxIbkLNusGMab4h1bmL7Us=;
        b=kDSlbnoqhKLLkatNvlMPSPifeWI7SLmMqCoDM2HxRzYcb/SzFekv6eKVKNiDik3K+Y
         zhUCnU4sDU82soMOtwp2tsAeWatjg1hCET89TOJcjUspYwLN57KK3s9vZFVsfuvjKx1F
         KsJ/YCOADgZY9TaRmdxd6FIgTki5NgiFMFAP+XoV4FVlukGCGk2+Se0KTuHJayf9eRYX
         jvt3ggmWeE2JUcarXz9Ql12pVrImYnYQfArMeEZuTosZgrd2axoYuRQKm1n6gwxG+ybX
         BnM8Yyki7cTrDCi4UjLM2YcR458aezaNAYnZ8E9Ev+l6DVSK9TkJItLzO3l1XwXXDe17
         oiEg==
X-Forwarded-Encrypted: i=1; AFNElJ9Fmb1hR4d0oyGTJLaBcNRdAyfz7NRuGN4d5Mq+O6qHCqRrYEnieH7MEyU4IZoBaY5MIwp7qkDMLw==@kvack.org
X-Gm-Message-State: AOJu0Yxdfv0DXVYzeo3QKPH0CoH1uqdRb948Veqe+XghJT3lQGuUqNGb
	jhsNKpDN2DL49jrdrGHx6whfEoQdf35bfw0Ct6TLws0GnQJTOmLwZiXCrqwVDb8FUK+N+kO/iRo
	O9Ge+k2nJa2gOtQ==
X-Received: from pjbbj17.prod.google.com ([2002:a17:90b:891:b0:362:b5ab:9cd3])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:51a3:b0:362:bb93:f25e with SMTP id 98e67ed59e1d1-362bb93f462mr8872524a91.23.1776979412273;
 Thu, 23 Apr 2026 14:23:32 -0700 (PDT)
Date: Thu, 23 Apr 2026 21:23:11 +0000
In-Reply-To: <20260423212316.3431746-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260423212316.3431746-1-dmatlack@google.com>
X-Mailer: git-send-email 2.54.0.rc2.544.gc7ae2d5bb8-goog
Message-ID: <20260423212316.3431746-8-dmatlack@google.com>
Subject: [PATCH v4 07/11] PCI: liveupdate: Inherit ACS flags in incoming
 preserved devices
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
X-Rspamd-Queue-Id: C940B14000F
X-Stat-Signature: r1butphtjmehdujkypqm6jyfkfeoshy6
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776979413-72272
X-HE-Meta: U2FsdGVkX1+BSgGzv2oVRnPa/jdBAjnq6WOdD2U9oOLCXF4Jc9dCL+FgZzo8sgED8UTFOyCrNzcmtlUeyexzWGShCfGYE2ZPAAUkxBQb3BeR+XUWCW6k8WYzUQycm3mys6sJzO/08M66AM82vHPPxzdEbv5fSAQIF+BbN/fPKenR9wEBfrJYZFpn+5tkIMNyL72jkeb+XDfcGUM/Lero1Gn87Jse4HG9/XTBvsW9ojkgwZ1bQ7A1JocfjpunaFyYiJGQjRwnLMHmfeom22SFlSo984LTnMBQ8/ue0FN/7jAELvIZejent0jmolIsxxuA5xp652Ni0TUT2p+WduCRuSGwB3Z9aIqKAUgOeK/rXQxLupKg1flXlxCfGqoJHtuBLnIUmyFMiAYhu7OskU4iFxgs9r0iUDnZ79RwFjsXg+m9JEz8ZSviomi44y3njiRR16cmcz4I2cpT5NHDGsRYE11dubmFu6AJ5HCsVSuvxrHGigkZocD1ljP3d9LBjABCBGD4Uxf6rLuvvKd2D2UlOJn9OlCuAnBEoAYTq+b6OO95DTY/ou3WSzVHMSMHM9v9jAJ57EhBEl7KfidFGznjIttKxxVCjMhbiqrT2YSTZyLvkQrJ/IZ/zkrn9uiRJlvFkoEUwA/zu2WqoKoifp0l4ylpjnDQn9tlJeJq9VNP7pxjfLZUFk9vjXBfxJx/C9yuC5h2h/Nif+R+eADim7eMdOATTYsXEZCuYKb5+2miBR1eCMXV3VhfrYhcmOebx3pncpLwS7Kho9Y4sZ2F4pI4JfuZghupQFwgLLL3yx8t18eLJG+thiEfHoMaUDJcEudXo2fef0iy2+2eMef4ZvRpuGRRYHmE4GkJoVi0phnXyDtQM/KsYbnipZ3MKW4U7FUvlJdsMqMisXP2zJ19SW3sjCsdgnUfRE3L+Sd98+HUTPCrog94rPaM0Fv2SljejYp2P+LTt1+TmHxVhjkNSWs
 E6F88yDd
 NoE2gjcgB3fFD+dPsj0uIlWNwwb8wAuX0a46DsLcVvZCPLU4YcxhjlzAWWOUvUmcI3QWTRr50h/PFSX8sDYZgNs0jkDF2SUZXQn2HYFL+qcUATPy9f1WIT+D0O+9eW+KxnDowQwvtiMEIgbWi1giZFkLxmB3a0JAKrQf95xTEp14Vi+8TyxLVUw5EURzdM/AZJf/v15RP0AO+1zoacgMEQZGKZQ9GFXkfgvD09tLHEEW5jKMHgGK3pHfJ7GRL+7Y8l7njolQPb/lpn7NQiKvSNTbKKxn6WfHTTwn2DtAEYNQ2aLe3JzpphEAlVfrDUGZ5SSHu1S04f4Pte9OBpYTJk6mnFKcjZ5sqHL9cT2FmSOfR3bAM/cCMKq+QzGqNqK0hNgb8xuoqu9uPIp+b8aB457kFmbOUukDuevR9GnXJe0sy3IU3DtNZ1NaywNEuMmCI6inTNCDRo8PDFxURvZjbBx3KXLUc83VU2ATcd3ax5aFpfOL2JNglsazIOckLP/IxOJNhsy71RWiN28cuYUEpAWWvGiPnbeYgj0Vv/OV84MYjzo0FrR2cKVPODxfFLGTeZ06pCC3EYv9GtHQbYkG/6aeFThVHuX/Pb2kJvm0+9GsmlIB9Mh+tOrs7isXTREYh0hPu+WRcBeVlrxI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Inherit Access Control Services (ACS) flags on all incoming preserved
devices (endpoints and upstream bridges) during a Live Update.

Inheriting ACS flags avoids changing routing rules while memory
transactions are in flight from preserved devices. This is also strictly
necessary to ensure that IOMMU group assignments do not change across
a Live Update for preserved devices, as changing ACS configurations can
split or merge IOMMU groups.

Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 10 ++++++++++
 drivers/pci/pci.c        | 10 +++++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 88125f9a2c6b..a9a89f7bd3e5 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -118,6 +118,16 @@
  * This enables the PCI core and any drivers bound to the bridge to participate
  * in the Live Update so that preserved endpoints can continue issuing memory
  * transactions during the Live Update.
+ *
+ * Handling Preserved Devices
+ * ==========================
+ *
+ * The PCI core treats preserved devices differently than non-preserved devices.
+ * This section enumerates those differences.
+ *
+ *  * The PCI core inherits all ACS flags enabled on incoming preserved devices
+ *    rather than assigning new ones. This ensures that TLPs are routed the same
+ *    way after Live Update and ensures that IOMMU groups do not change.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 8f7cfcc00090..e615b7c3e430 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -1017,6 +1017,15 @@ void pci_enable_acs(struct pci_dev *dev)
 	bool enable_acs = false;
 	int pos;
 
+	/*
+	 * ACS flags must be inherited from the previous kernel during a Live
+	 * Update for preserved devices (which includes endpoints and any
+	 * upstream bridges) to avoid changing routing while memory transactions
+	 * are in flight.
+	 */
+	if (pci_liveupdate_incoming(dev))
+		return;
+
 	/* If an iommu is present we start with kernel default caps */
 	if (pci_acs_enable) {
 		if (pci_dev_specific_enable_acs(dev))
@@ -1041,7 +1050,6 @@ void pci_enable_acs(struct pci_dev *dev)
 			 PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_EC,
 			 ~(PCI_ACS_RR | PCI_ACS_CR | PCI_ACS_EC));
 	__pci_config_acs(dev, &caps, config_acs_param, 0, 0);
-
 	pci_write_config_word(dev, pos + PCI_ACS_CTRL, caps.ctrl);
 }
 
-- 
2.54.0.rc2.544.gc7ae2d5bb8-goog


