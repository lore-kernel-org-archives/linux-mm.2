Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2588960A2615
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 21:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=vk4tOeAY
Received: by kanga.kvack.org (Postfix)
	id 5DA826B038A; Mon, 19 Oct 2026 17:31:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58AF86B038C; Mon, 19 Oct 2026 17:31:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 390B76B038D; Mon, 19 Oct 2026 17:31:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0CC066B038A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:31:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8DA9E4081D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:24 +0000 (UTC)
X-FDA: 85340672088.11.05BFD48
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
	by imf15.hostedemail.com (Postfix) with ESMTP id D0F1EA0003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 21:31:22 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vk4tOeAY;
	spf=pass (imf15.hostedemail.com: domain of 3KYzWaggKCPgirfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3KYzWaggKCPgirfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792445482;
	b=oY+Li+x0q9HoAJLyklVo0vGJ+jvz7/Hv8m2ffDgcp0lvvSlV44FkUAdrmFH8FsC5hyvBXX
	EG5mNCQHc+4RmlyMCIKPeKjsd4Tk0jtjMJPDd3XJfUVQjetRnLsjwcdI1ac9b7pq0RIs9W
	iFe/01bqROK6vBS+JLVsfdmvrXhzE5M=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=vk4tOeAY;
	spf=pass (imf15.hostedemail.com: domain of 3KYzWaggKCPgirfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com designates 209.85.214.197 as permitted sender) smtp.mailfrom=3KYzWaggKCPgirfyqfhplttlqj.htrqnsz2-rrp0fhp.twl@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792445482;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C0Zll4v1/3YDrC6QBHjix9780IIPkFEga7v4jahmDjE=;
	b=fu6C/yThw2hsf3k5UUFIsMC8r1THLnAFMQc8OAt+Vlf1Ibf4ahEOBtRsk1WzUCGaI4tfbx
	GWmPAbubs43sYr6q5CdGusz/RyTwqDJ71ypvkzbbtwdCpGQ5ywC0hL1k804F+GL+vBiJVM
	+Vn728HQyH+hv7uRI8YXTYo4CSZOWBs=
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-2df8d1e91c9so36409225ad.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792445482; x=1793050282; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C0Zll4v1/3YDrC6QBHjix9780IIPkFEga7v4jahmDjE=;
        b=vk4tOeAYcD8Q7XKgH7D+iVu7aUd2pRZI3UD8saRofph7QTd1wfdn1ujPxnC0Plz2eB
         i3c0kBsd72h0qaNS0WFgSNYsDmv0N8JVVj/RsNyAoUFL+LmZS18P3TBA/Q69/QeXAHxQ
         yQQA1Q17wPzT4dRolVfMaaJmZ5tOieHE5rkaWESwD7KAnz449rUq6/yQuz8l37yVCqSh
         cdMQALQCgR2NVOHqBGJNQCtCOu/pXZoiBOyF2j4kFI6IhMfzwS8ukV6oJS6yVZU3aMfw
         BB5cO8/iLLF+WuOmUZLqFihKgIXAFQPwD9TVElRiXAazaGESAvfv22j3JcwlO6EfHd9I
         /xWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792445482; x=1793050282;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C0Zll4v1/3YDrC6QBHjix9780IIPkFEga7v4jahmDjE=;
        b=NuDm8JiHKGBDzAUMojGx95cHndj0UJemJx4i5Jk80NtPXG+OCVFUUcBLagvac42Qk5
         TJG9hDO8HpObwUtdO5DAkUlUfYhiAomi1dk7cx1PfeB39mLrQmG+IYdS55iADPQeVwEq
         zfneFsxSO++PxzYSzHZ6/dosBsJ6Y9LyVYgd67HyXwCH0+JC+let3Tin5B9TngInNto4
         IMJm9fzK30c1TCw+X2AWkLzOwEipXlhwqGHBG8VrrGo8M66JJah/bQQa3JHmCItGSYTa
         mRyg0ASpS+7A0eJQgPW/GlrN/UhbQw4LtnFlyasPwL1StFpgsAuC7doeVLK780fvC1lK
         s1Xg==
X-Forwarded-Encrypted: i=1; AKwUvBzD62fC0h6FOgevwHkEAiSQzMA01ENLQ1006/nXXsBMTouDjszXfEBGokN4YKyxQpGX59Qk/7FAwg==@kvack.org
X-Gm-Message-State: AFq9FYLgmTb+VDhgZ0nV3S2j7GOgsHHIYj1C1NNlJ203V6w4D9F7eOWj
	uCXWRxk5XkO1bsS9NAZP9EYxGm3+NTf3MRvRZR3+KB/pj4m0LLyBDL31dJZaWnMK0QxPgeYAkHy
	3oQKTVfGLWEGwhw==
X-Received: from plbbi9.prod.google.com ([2002:a17:902:bf09:b0:2e3:c3e:def2])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e84a:b0:2e9:4b65:368e with SMTP id d9443c01a7336-2e9a6d1eaa1mr80079565ad.15.1792445481409;
 Mon, 19 Oct 2026 14:31:21 -0700 (PDT)
Date: Mon, 19 Oct 2026 21:30:45 +0000
In-Reply-To: <20261019213054.3157159-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261019213054.3157159-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.0.212.g129ede20d9-goog
Message-ID: <20261019213054.3157159-2-dmatlack@google.com>
Subject: [PATCH 01/10] PCI: Factor out BAR sizing from pci_read_bases()
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
X-Stat-Signature: zgegtt58bj7uc11mfhph81urjz8wn3z4
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D0F1EA0003
X-Rspam-User: 
X-HE-Tag: 1792445482-556187
X-HE-Meta: U2FsdGVkX18DRgdJQ0cdDlMjgaXYWDJpUAEDe71II2uIsblkA5S0xv2Jbl3maLdVaILv1P4XxE6tatEYedpoK5vr/ocGXoIs2FWUHexCLIc0Ys2DRRoehQQvl+Xe/RH659i/afp/3TaxSKzuq1lHRKlvDyI+3EaMqVGeG1T5E6iMvEj5BPqjGzBTyy2o0/z+upsrI5J1LaEtxCWKiLWZFx5onuUgOhBk5/BgE2TAl1cfzAJdULox14bn5OBEA5BS7Y/Of6Q+IVcP54y14b2BdNXdhWIPhytt6g5NJ46c3nv3jpGBDazUAfL10jPF8jN3rjONfgDLZdWrj0EHxhktHNY7tLDwEse3N8gLKE5p9MX9i7RvnIoqn+wDtbeyFvIOXQzqhL2RWr/rOPEpzXjCi/gHi2vGlNdqRiK9DNGPmgrmKEBgpPkEQr/JUkaQSDmjaqS7lwHb5kZIvFB8p/JOzZ3lIvVElLzvxYGJakO/K+UvjEvfWs14go7G0iEgroGYQzhvUui6NZACLLG6kkkiTP5ocOPXtLQMSDpPYFb+oO38kSbsyFYWTjAceCXWu89I0BtbnCXbJf1aHUWBzeOSZahy5bBmfRgdlZLRBV9/JNtHXGPXY1pqmVJeJbT+679JuZZipL0Whdp/jSaXRgE6tZ3hZazByk85WvD/R/72yWiy64pvckf1bbvJsjjKszev4eIDBm2nuAUbz2wIt/pJqKdglvlsLz/k9XpfzD4w54zi+XCyWBT+mSboD0gVRdmRRzGS33zO1/aD82yXrPEzcQrjN8ytpqI7cwHdf1EfBh33Qfpn+sYIXwBzMb03ItQlNFb7TOJHLAH6pGNuPGjyD/iv9RntbyVlT5YN3NX0X2SyHmYUnydR0P2dlo6vrfEmM0ULWwCOI9QM4iFkQ5um55cPm6yIsdFvo34F/EyTL2SlAeb4b/lBPdKd5vRfjt7f0qAe/1AZNn7oXnIcj9U
 IHg1/bmS
 s06fcnqArw7fFd9GV1dKOcWC+at5heZAOQgzqW44C29cCrP1wCCGJ3PYVXkCJidK7OUDa7RJpZh1AzH+AFV+20Sug/vNMiMAZ30pvXVZHrhnmrJ6gSamGsi2CvFi3eaV0ElFEukdfVwSIr6omWTN5ooXOWXQcl59Dj+Id1aJBWjRp3YUSJAvFQ2lMvXdahn89H1DJfYah2j7urVXKIkU0fyFEAv3Xd9WDHwBdjJenTvJ06XjtAatUPAQaJ95ZsDnGdlGvTBsvIht2R3g/GFIZ8xP5r44LnhqgyadnIHI8H6via2hXZSUR9Q+P4N6Br+U8RF4vhUhbG6JOypii6YhDhvIXa/PTcDsTBw8TQaCY2KnEOH/vFrqt5UIlUVdtzvX2C2cIDWAuT+B+g1qhPaht/JIovw+xMBjhhcYLnPPRfOWA90BdT38yoypRdmeZobJrCb27DV2JDrSALH0GibG6vMLOr5P8IzCbpoZpjM0adJud94DmitlVP+m57FEPNe1kyzhGhTqIYGdMAtGRN9lLIPDRtTLdusw1mP1rMTyU6cX70m/EntJdyUb/6lfr0eMlKj9j/9jP25JVyM16TwTJzEUTkSx1naezCcKbQaqWYt9hEO36FgsWrFsaN9U9zwkSV5Y4+g3YM25UlTQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Move the code that sizes the standard BARs and the Expansion ROM BAR,
including disabling decoding while sizing, out of pci_read_bases() and
into a new helper, pci_size_bases().

A subsequent commit will obtain the sizes of the BARs of devices
preserved across Live Update from the previous kernel instead of sizing
them, since sizing requires disabling decoding.

No functional change intended.

Assisted-by: LLM
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/probe.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index debe0ad1ef68..9187f1d91766 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -323,22 +323,11 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 	return (res->flags & IORESOURCE_MEM_64) ? 1 : 0;
 }
 
-static __always_inline void pci_read_bases(struct pci_dev *dev,
-					   unsigned int howmany, int rom)
+static void pci_size_bases(struct pci_dev *dev, unsigned int howmany, int rom,
+			   u32 *stdbars, u32 *rombar)
 {
-	u32 rombar, stdbars[PCI_STD_NUM_BARS];
-	unsigned int pos, reg;
 	u16 orig_cmd;
 
-	BUILD_BUG_ON(statically_true(howmany > PCI_STD_NUM_BARS));
-
-	if (dev->non_compliant_bars)
-		return;
-
-	/* Per PCIe r4.0, sec 9.3.4.1.11, the VF BARs are all RO Zero */
-	if (dev->is_virtfn)
-		return;
-
 	/* No printks while decoding is disabled! */
 	if (!dev->mmio_always_on) {
 		pci_read_config_word(dev, PCI_COMMAND, &orig_cmd);
@@ -350,11 +339,29 @@ static __always_inline void pci_read_bases(struct pci_dev *dev,
 
 	__pci_size_stdbars(dev, howmany, PCI_BASE_ADDRESS_0, stdbars);
 	if (rom)
-		__pci_size_rom(dev, rom, &rombar);
+		__pci_size_rom(dev, rom, rombar);
 
 	if (!dev->mmio_always_on &&
 	    (orig_cmd & PCI_COMMAND_DECODE_ENABLE))
 		pci_write_config_word(dev, PCI_COMMAND, orig_cmd);
+}
+
+static __always_inline void pci_read_bases(struct pci_dev *dev,
+					   unsigned int howmany, int rom)
+{
+	u32 rombar, stdbars[PCI_STD_NUM_BARS];
+	unsigned int pos, reg;
+
+	BUILD_BUG_ON(statically_true(howmany > PCI_STD_NUM_BARS));
+
+	if (dev->non_compliant_bars)
+		return;
+
+	/* Per PCIe r4.0, sec 9.3.4.1.11, the VF BARs are all RO Zero */
+	if (dev->is_virtfn)
+		return;
+
+	pci_size_bases(dev, howmany, rom, stdbars, &rombar);
 
 	for (pos = 0; pos < howmany; pos++) {
 		struct resource *res = &dev->resource[pos];
-- 
2.56.0.212.g129ede20d9-goog


