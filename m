Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 092A3C54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 22:11:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 170E36B009B; Tue, 28 Jul 2026 18:10:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 147706B009E; Tue, 28 Jul 2026 18:10:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 016866B009F; Tue, 28 Jul 2026 18:10:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 793686B009B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 18:10:30 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E378EA04CC
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:29 +0000 (UTC)
X-FDA: 85039580178.28.ADB8E4B
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com [209.85.210.198])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3AA6D40004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 22:10:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S+3T+1+p;
	spf=pass (imf07.hostedemail.com: domain of 30ihpaggKCCMCL9SK9BJFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--dmatlack.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=30ihpaggKCCMCL9SK9BJFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785276628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eD4DOqSzYhDJFPWVLbqkFG2KNi5FrgpbXUF+ODWdEds=;
	b=gSP+AuBNpNuZqor/lrEySB1wGDGfCYT6duJdX8SlJ7zTj8wIYeTuYwpGzuplaVMIaoUsq7
	tVeL946QN2OsoTaXDdPHTGs3EBntBl7BxZOJ7VDo5VpVt9sUMwUvU9APH16Rh0XSIND2Md
	Vh9NqnlLSBWOldIbWJXNT47Zx7TYUis=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785276628;
	b=kuAQUTns/jcM2yRbTMmacDb6VLpajdsxpeV5Y0hI0g7Jd6AcDVezDjsKkUM72Gu5yfa5RT
	QxTIvlstzSQM9ny+7cG/2kbjZZkVKZAu3t093D6PHWkQSOAKf0StIQusC/c1DDQ9w/kExd
	FXVYkiJaA+TPkZCSE9rwwvvImOS2QyU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S+3T+1+p;
	spf=pass (imf07.hostedemail.com: domain of 30ihpaggKCCMCL9SK9BJFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--dmatlack.bounces.google.com designates 209.85.210.198 as permitted sender) smtp.mailfrom=30ihpaggKCCMCL9SK9BJFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-8486ffba174so457571b3a.1
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785276627; x=1785881427; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eD4DOqSzYhDJFPWVLbqkFG2KNi5FrgpbXUF+ODWdEds=;
        b=S+3T+1+pI/dijrHWJnOFYf/sfP2xcXIBQHIy4o61YKUkxYQ1VCt7HQ1L1o+61eY7Go
         cJQ+lIwPTPjq0yDWPJ6Ye1khIQbjLCs72Z4loLA4Afd6itAVFLS0bBFn/j1YYFyapjlD
         R8A41Pziwn/7UQy6aRmNqhRJ1J8FFtcipP9SNjlib5upbyrHKaSckZzIMk6Bx9vv6Jmn
         yk6x7XMA36FSgNpxbCO5pCjyb5WG/r6k9dZHldwhFkicoVFw9HBb1U4thsupVVNQtFWw
         YC7sm6SgK+5B7bJMIoA7j0L7zhB5KBfUsh1G6WW9bV5fJxSsDdwpOd7JhOd1Z7yCxgOM
         3bUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785276627; x=1785881427;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eD4DOqSzYhDJFPWVLbqkFG2KNi5FrgpbXUF+ODWdEds=;
        b=Xr8a5zujvW4uRJk6CaFRfDdXxu8QEbPR6wa2wzV8RkE3qIXNdN+VLlsNz2peUIRD+h
         TeYUp2I2aTNO6UQaqkSEOBwp43pvFYuUhxl7eI+BVfDR4/921+07aobDT/GTJqhVq7Pc
         uTcgqa2D6JcF19tOQ0uKRUfcJ+L0D/uPO/+8bX4RX56d4M1+aP8KIIGWDcQ3uJnLId8b
         eBruQp4AE+x6G6lAtWNy5fYhzGw8+QtrEd9KwklwGj8thyrB084WqswwCZroPHl9Minj
         gBX0u/6ONjcLqjOpzR1PbUc3bzd5IyncsfN3J9IJ0UTu0lVW+IIkNfxDurCUYvO7ewyq
         809A==
X-Forwarded-Encrypted: i=1; AHgh+RqGm4+rZEo2/iK+WbAFNx0ejUhMPX1be1yeo6LEKpbJC3OYlRrrJgYhjL/Pz/cerqB3zNDJCcZsEQ==@kvack.org
X-Gm-Message-State: AOJu0YzVMphXwdu+2Fytq1foe5EkTjdVP99e31I2loeb7TcDPmvVePoV
	BR3wL5CTvEFqQOcp0fNNZ1Z/srLcZlMs5uQ+IhOVO8H8K+sjf0Gb0f2nEyHHLmHvOIgHM1YmtEa
	6lIJAvNpmasnadQ==
X-Received: from pfoa1.prod.google.com ([2002:aa7:8641:0:b0:845:ebfa:4051])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:23cb:b0:845:363e:12d9 with SMTP id d2e1a72fcca58-84e931f6a77mr4252240b3a.3.1785276626749;
 Tue, 28 Jul 2026 15:10:26 -0700 (PDT)
Date: Tue, 28 Jul 2026 22:10:01 +0000
In-Reply-To: <20260728221007.2098560-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260728221007.2098560-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.487.gaf234c4eb3-goog
Message-ID: <20260728221007.2098560-8-dmatlack@google.com>
Subject: [PATCH v8 07/12] PCI: Refactor matching logic for pci_dev_acs_ops
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
	Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3AA6D40004
X-Stat-Signature: tipwbdemc4gcpfsbpkmq8zry91pwhzz1
X-HE-Tag: 1785276628-499970
X-HE-Meta: U2FsdGVkX1+5EPGSJ9N2zIdy5SR9F+xSLO9mxTtE3UtUx60MlyKRs30QYXxodVy9AhQ07CosTk+Gr63d7WY/lEZrOgqkvQ6iNsWJcjPKpRwBRz8OnKpP76Y0+W/4DLYiujnJDnXyrG2gnV5eOi0PH6jAwRul8rHtIXWPmkA0Pq08vsNZc853Kn2fco7ynDW3L0bDdtmQbWVCRJyfsItKDAwH77H3RoQgDXZTW0CjI9ik6AJ36r2MvAk6eQLW2g7zs9SQWsz+L2Wm1PDNqNCvzTKSINrOkdG/PQTSvawFubvDoGvxFhSuQsWs0iXjcwEr6YTmrsjiYjdLz7szUqtgBYM0nTXbniouRCzpQYq0So8281bc7s8x5NyI2+qHE9s22RDbQfSONcVbOExmWJ8cgALz0DkOjkFWwrXC131AB3iU+gd05uuvBmKbTWy2kv+78qHxo3SZMFwJxZ7b6mSOsKaZhGodtopmMLccdQ6L5Uwm2QgOwv/N2Dls3FWgJMKNGEEoR4eOM0NNH2Sfsy64Or8QqOSi2+iZ1fhhyP+qHA4OFrabUmLD0TzgfuUA2WB7+gFMwi9JCaEBxLyowTby5MolhA4dhMr2vjOYE93GSZvedCMCul0AFCo5Q4vAhjGWMtXfkDwwxMfI4Rzqv3cJrezKSTFdzZmDulJm7KiyruiNMrX70L2y+bQCQ7GVFzms+2JVLkITeCbmhOhVT3YCRELFQRkUzwSVLdbagwKoq9oWHBVXurKQmD9oq6fVamR4UqJtHcv1BLMAmeO1lQWEaqFvl2BzSzagggdRs5wV3hWXxK+yaXRVNOb33gW8ERJOUTjWeTXN54FUSl52qAA5Mfwss0QACO41FQX268M+oVlv5hhgd8MTh3BlkPIqNxqnWdYS7L8FFDaNV0mjTtUOcs5xVUC+wu/jHn6uQVPCrQD0Q1IzsbUzjy67ODkkL7UfCju8PLXXqjoGLv1+D18
 XAdJhG7P
 f94jSvzs9+Ogibihv/7EvEPnmD+UsiSnYLNSUKKIlTtEoF3umYI7AT6GrwUojyEXZa+NKf4bPKxLuLIeBaHrO56k6K0YEYcU7QQu0QCvg1LzRvT6V8gxV/ice6xlo0eMiJEKZ3PDcG6Nhy4+vVluKb1pMwJUknVtMgQO2mre6yqFxG310kccVo9005MwI0T25dhT2sXZR9gTVA8wd4zEDKRI7dZ/VFAUfwNaemIORsRIcwggWBVxk8VEaZe5gjvlLuzsVyRex3oplsUdIygpBqojUkY0IiXOlvXSylW8AQxn3FnjTLqEH8x3KpBnMiPaMcY0N2xqg4hP9lbCo86XMBdfQUoh2F8hBJGQgMCw8a/Sz5JAhDL2XudxKHvlUNCfnrJZqWsBBG4dEfdzsrYbkMkiba6bajDOp25hBpi01tsUIbsIyYzvDKqulXL568HlWRFOasl9KqtIHKyqo9Nt1clP2Fntpywhrtjv6rB4kGHnra6Hy5l4lqjhrpQBocf10GKIr8iFs6i56OdkMhIS7kXwVd/xcic4HAllqkHnDXab/igkPG3qWh3qF9E0U3vz0ZIgnpxwNx5H7A2sgqk2qlHb6FcNbNfAbDQ7Q4xf/D1rf+6t1haOKS/KCYBlKuL/VivMec7gC6pDscVZSWgAgMMQvcoPQELcoqr1eAmzVEV21MMjDY+/+DEt62Kk/loLTl9KE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor the logic to match devices to pci_dev_acs_ops by factoring out
the device matching loop into its own routine, pci_dev_acs_ops_get().
This eliminates duplicate code between pci_dev_specific_enable_acs() and
pci_dev_specific_disable_acs_redir(), and will also be used in a
subsequent commit to check if a device requires device-specific
enable_acs() during a Live Update.

No functional change intended.

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/quirks.c | 51 ++++++++++++++++++--------------------------
 1 file changed, 21 insertions(+), 30 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index b09f27f7846f..7ac39ec2843e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5374,9 +5374,6 @@ static void pci_quirk_enable_intel_rp_mpc_acs(struct pci_dev *dev)
  */
 static int pci_quirk_enable_intel_pch_acs(struct pci_dev *dev)
 {
-	if (!pci_quirk_intel_pch_acs_match(dev))
-		return -ENOTTY;
-
 	if (pci_quirk_enable_intel_lpc_acs(dev)) {
 		pci_warn(dev, "Failed to enable Intel PCH ACS quirk\n");
 		return 0;
@@ -5396,9 +5393,6 @@ static int pci_quirk_enable_intel_spt_pch_acs(struct pci_dev *dev)
 	int pos;
 	u32 cap, ctrl;
 
-	if (!pci_quirk_intel_spt_pch_acs_match(dev))
-		return -ENOTTY;
-
 	pos = dev->acs_cap;
 	if (!pos)
 		return -ENOTTY;
@@ -5426,9 +5420,6 @@ static int pci_quirk_disable_intel_spt_pch_acs_redir(struct pci_dev *dev)
 	int pos;
 	u32 cap, ctrl;
 
-	if (!pci_quirk_intel_spt_pch_acs_match(dev))
-		return -ENOTTY;
-
 	pos = dev->acs_cap;
 	if (!pos)
 		return -ENOTTY;
@@ -5448,56 +5439,56 @@ static int pci_quirk_disable_intel_spt_pch_acs_redir(struct pci_dev *dev)
 static const struct pci_dev_acs_ops {
 	u16 vendor;
 	u16 device;
+	bool (*match)(struct pci_dev *dev);
 	int (*enable_acs)(struct pci_dev *dev);
 	int (*disable_acs_redir)(struct pci_dev *dev);
 } pci_dev_acs_ops[] = {
 	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
+	    .match = pci_quirk_intel_pch_acs_match,
 	    .enable_acs = pci_quirk_enable_intel_pch_acs,
 	},
 	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
+	    .match = pci_quirk_intel_spt_pch_acs_match,
 	    .enable_acs = pci_quirk_enable_intel_spt_pch_acs,
 	    .disable_acs_redir = pci_quirk_disable_intel_spt_pch_acs_redir,
 	},
 };
 
-int pci_dev_specific_enable_acs(struct pci_dev *dev)
+static const struct pci_dev_acs_ops *pci_dev_acs_ops_get(struct pci_dev *dev)
 {
 	const struct pci_dev_acs_ops *p;
-	int i, ret;
+	int i;
 
 	for (i = 0; i < ARRAY_SIZE(pci_dev_acs_ops); i++) {
 		p = &pci_dev_acs_ops[i];
 		if ((p->vendor == dev->vendor ||
 		     p->vendor == (u16)PCI_ANY_ID) &&
 		    (p->device == dev->device ||
-		     p->device == (u16)PCI_ANY_ID) &&
-		    p->enable_acs) {
-			ret = p->enable_acs(dev);
-			if (ret >= 0)
-				return ret;
+		     p->device == (u16)PCI_ANY_ID)) {
+			if (!p->match || p->match(dev))
+				return p;
 		}
 	}
 
+	return NULL;
+}
+
+int pci_dev_specific_enable_acs(struct pci_dev *dev)
+{
+	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
+
+	if (p && p->enable_acs)
+		return p->enable_acs(dev);
+
 	return -ENOTTY;
 }
 
 int pci_dev_specific_disable_acs_redir(struct pci_dev *dev)
 {
-	const struct pci_dev_acs_ops *p;
-	int i, ret;
+	const struct pci_dev_acs_ops *p = pci_dev_acs_ops_get(dev);
 
-	for (i = 0; i < ARRAY_SIZE(pci_dev_acs_ops); i++) {
-		p = &pci_dev_acs_ops[i];
-		if ((p->vendor == dev->vendor ||
-		     p->vendor == (u16)PCI_ANY_ID) &&
-		    (p->device == dev->device ||
-		     p->device == (u16)PCI_ANY_ID) &&
-		    p->disable_acs_redir) {
-			ret = p->disable_acs_redir(dev);
-			if (ret >= 0)
-				return ret;
-		}
-	}
+	if (p && p->disable_acs_redir)
+		return p->disable_acs_redir(dev);
 
 	return -ENOTTY;
 }
-- 
2.55.0.487.gaf234c4eb3-goog


