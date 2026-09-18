Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE55FC982D7
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 20:07:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552396B00A3; Fri, 18 Sep 2026 16:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AD4D6B00A6; Fri, 18 Sep 2026 16:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A2936B00A9; Fri, 18 Sep 2026 16:07:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EFFBB6B00A3
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 16:07:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 86F21407FE
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:06 +0000 (UTC)
X-FDA: 85227966852.28.90BD802
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com [209.85.214.198])
	by imf15.hostedemail.com (Postfix) with ESMTP id CEC2EA000B
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 20:07:04 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a+e40NCK;
	spf=pass (imf15.hostedemail.com: domain of 355mtaggKCC4NWKdVKMUQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=355mtaggKCC4NWKdVKMUQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789762024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=siMAWwJv4yjE1eEtNkD6j1Z4yk/PjEJKUuLYDAAYM4E=;
	b=G0tnOT9SFG6ijKzJLDoL0PFNt92T7CzYJ+kb9Z/V5zDqKON3kkXqNVGHNalNjL4HkYsHkS
	XmeSMRvpz988gGwm5iga2yeNAQQ/TWm5RO19spnRCZBpDVauFyg39/7k7u4Y9kSqV8hCXd
	wvIC5WD9Fc9x7WSY9ajz7grY16teSqY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789762024;
	b=AhJdUJBzNjCPXkyszwNoclF1A4vjQmFZZcjzsJn+wWuAVoPTEFZrbCO4As7OD6exhGEQ1W
	GsSrc+0vohl/sUhUoVdwR9lFSGkPKmf2wKqYoGsotBv3Q1i4NI9fbFUe7meeAak6DYtoLN
	ZJB1HT4jw+9lzNJ1mH+FyWhXvaqrPd4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a+e40NCK;
	spf=pass (imf15.hostedemail.com: domain of 355mtaggKCC4NWKdVKMUQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--dmatlack.bounces.google.com designates 209.85.214.198 as permitted sender) smtp.mailfrom=355mtaggKCC4NWKdVKMUQYYQVO.MYWVSXeh-WWUfKMU.YbQ@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-2dc92350888so18274145ad.3
        for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:07:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789762024; x=1790366824; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=siMAWwJv4yjE1eEtNkD6j1Z4yk/PjEJKUuLYDAAYM4E=;
        b=a+e40NCK6oldiZqrwxedhlPz/3StJifPs0yKZNZ/QlIwqdnYfYkQBrHCN9CiBsBrLm
         GBPAX0gQM8mV7ZfPoXiattfmQaiQQxinkRt4zjAwDQKJgLOhK8iUQvQKxSTgFvMO8A87
         H/tmuMBJNDGAZSf+93UKIqU5FsKiyAGLfL+PgXdV1ZeaYTCtaPikOWaQHD5YETASDVSs
         X6B1Qd82C4v2LS+rkTJLPho4nbPkFFPUwBe/o0uklUQgv1CvTvZhNeUz2Ts1DCG+5X8j
         UNH6+Q5mYiaL7wiPQ9qRDo+EmKwmMjSF5BeS1yH7B5Zxkz4t18/x1QtTynw+LZCUkC3I
         i22g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789762024; x=1790366824;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=siMAWwJv4yjE1eEtNkD6j1Z4yk/PjEJKUuLYDAAYM4E=;
        b=JaLo7WKTwHROvdwAO9R7eRMZ5nZdEMfoLW2IL3Ztbu8P5zZdlfmga7sdqYebae5XmN
         /1iA2TWcyQGUjsiBlCy+AFwY+Kz+THpRoBQaCBuRls+5foYu2qodYLWUNhm6l8Y2TKm4
         Ufr19ge1NfAgkxpjbZyQ14OFIaKHOROf0Zc9KOrRoTzNbwvxANGWigf/PlHXZQH6scgh
         fQDCh7IqLZ1r+EIG33cqQolqguZdKfmC/R7vmV80nmUB3h+d/meTz4qLH5qGhr/RvTPO
         vMSQKJWjLWm45HwFZs6lfTHrXlV1FG3BKum4uQqbXThJAq9DkCdBDI0yIgM5ig9gaexI
         5vwA==
X-Forwarded-Encrypted: i=1; AKwUvBw8Zdn+7IKZJF6usH8ODAM2baF4kySJY7usxZiYeb8i4PhWKAojGiFtxsicNPjxkSrXSgRVFDaM2w==@kvack.org
X-Gm-Message-State: AFuF++lqakalMRdDJca+6NuC69Zwcheme37GM+/B1L0liOika+NLyLTO
	mN3Xg/Yu3l+g36R8M8HgrLmQ7zLWTHazvItqPyU6aU91grCdXELTsbpRDC1fELhFTzIjPX2KMDP
	0vrzY19+VZNYLXw==
X-Received: from pgbgf16.prod.google.com ([2002:a05:6a02:2cd0:b0:cc5:1124:470d])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:7209:b0:2dd:c100:a5dd with SMTP id d9443c01a7336-2ddc100a681mr6689305ad.49.1789762023439;
 Fri, 18 Sep 2026 13:07:03 -0700 (PDT)
Date: Fri, 18 Sep 2026 20:06:38 +0000
In-Reply-To: <20260918200640.887030-1-dmatlack@google.com>
Mime-Version: 1.0
References: <20260918200640.887030-1-dmatlack@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <20260918200640.887030-13-dmatlack@google.com>
Subject: [PATCH v9 12/13] PCI: liveupdate: Do not disable bus mastering on
 preserved devices during kexec
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CEC2EA000B
X-Stat-Signature: uw3iwbgjdjm8671fgp44ek1xd9wtjjts
X-Rspam-User: 
X-HE-Tag: 1789762024-150300
X-HE-Meta: U2FsdGVkX1/fnP5Zj9qAFi/eepXtg4BiNBeER+pnDRp/muKmXoGjjUMFBklbrw0u/WKwE6FNS7UIRl//MBzTXA7hZHxfJW9/MFBNh84jg8yRmeuDbkWgOIq5FC3d8CoO+aGmjSog+mx5xXpS9UtEA0QJejmYjWTlGtm61cgbYM0wdE/p5W/jsPc1WK2orhvxIQvAFpTo3CajMUr7je84EAoFRR0j0qnaSBgKLpjpFuZOJCdg2N9j/6WWo+M+86p84//dGhEpRIREDBAOV2uRJ+62aDrgH/dS/DieQ0MNdl630m4A2z91rb2tWsaWqQR2Yycy9t62nu19ZqMlYj/l+hhDCOdFS2MJbEjZzFFSfQpF/by5y8nxRCJt/IYFG0yG0rxeYAkkP9EEeizhPFgf9zKEGpzhpFGKB4oWkJIRtD1NnB9SqAjkz1oiAExocgV5hJmUqIsXHd5qRhx55KeRT3ERacdmEZQ6ZcBz5izRC0tfB3LmHPxctj6p0m48qbMFJBhrW6buFAnwJwcE2ZXShXcX42dmyu299X7dzfRhKNUNgi0L7m0uS+ebD84VZFB95Oa/Gn/amQ0nejxYTkmD+b4DX5cNiySwy7fi2xRDfMTB7GCVZIq1NptW8X3cQhOUGFy6z0T72Ljk0dUXRP75rkOnvdcsHYx4TAcCL9z2OEdHdStlxgHu3O+cpkoa9RpYzwMv39dyF41Q9Wd5dL/b96+olDmRhUaXapqfgy9L7FoD/WNgHvwFZBO4cbOfbUCthS/q6+aNZ9lxqjVWUPXr0PwfKqrBKOhQikYepvknlUh9XRSZnHU2RyczkdviSc4HoLovy7eEl9F2kroP3FVbixP82U6bEZE9hi5Fq0ZaGnXs9JudM60hsci4eiwZL7wYEP2UarrOAGUe5esS3bOTINFQqcN/Shrzd0TJe4Rokb6gmseyU1xipoKYa3BpinhrRyUEnVKZ/RW6EfQED52
 xRnb2CF+
 CWdU8MTfYUFP3KfPVsiTGFXdNcOEvEJSqCO8EGhqm7AzJpEEGb8yiseTgylHUI6/aSsR4p9UfIM+r2rYdn0QzY7OiOmVSBj8GP/LNLXNiZFiRoTHQE/m/mMMFQJTCmhlVK+JjqweoUMJk3phkfRePZQNRLWc9B/lGl8lrgJCZ9tewIsGBa7eAh7GULph52XQiixKL/2hS+RcovBOMtpzOwzeVT58/yKRSEj66pBQRvk7pKj7R+0+I5E2373ZqhOuRO8S1GyEHBj+Rn3zVO8Sqxib4SMQgkJbqSog6H2khYuAxuGxjwUAt3xge7043044FczX/0x1pRe+Ea1xY4W/Dx811zbgmqYDO80Pi5OB8z5gyE5Eid6KKVciK5ccoJ7JcMKou0b20qIlqys6L30X4uddMSd9aF59YOnK0A5WOXFTF4PlN9YLsH7320bublFWQjktyUKDgm3+DWqjCUaohkTt83F10PO4kEr0+SuhcCoLkZljKb/alt9GlXoKw9NwlcHcHUmmH/H1mn4v9GDUqUQFKetmG/9lBpx637DkPGu8vvP+d3IDaBvfv4QadQDg1zEzp8XowydNhtAwWkSboyy8rejUJIquO1baTt0M7LO4ZSOp0bM+qNOhf+24fNyHysDCf/WuR6rkE6bXruw5jkj6W8Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Do not disable bus mastering on outgoing preserved devices during
pci_device_shutdown() for kexec.

Preserved devices must be allowed to perform memory transactions during
a Live Update to ensure continuous operation.  Clearing the bus
mastering bit would prevent these devices from issuing any memory
requests while the new kernel boots.

Because bridges upstream of preserved endpoint devices are also
automatically preserved, this change also avoids clearing bus mastering
on them. This is critical because clearing bus mastering on an upstream
bridge prevents the bridge from forwarding memory requests upstream (i.e.
it would prevent the endpoint device from accessing system RAM and doing
peer-to-peer transactions with devices not downstream of the bridge).

Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: David Matlack <dmatlack@google.com>
---
 drivers/pci/liveupdate.c | 11 +++++++++++
 drivers/pci/liveupdate.h |  6 ++++++
 drivers/pci/pci-driver.c |  7 +++++--
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index 496ba74c26ce..51695782ed42 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -193,6 +193,10 @@
  *  * The PCI core adopts ARI Forwarding Enable on all bridges with downstream
  *    preserved devices to ensure that all preserved devices on the bridge's
  *    secondary bus are addressable after the Live Update.
+ *
+ *  * The PCI core does not disable bus mastering on outgoing preserved devices
+ *    during kexec. This allows preserved devices to issue memory transactions
+ *    throughout the Live Update.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -950,6 +954,13 @@ int pci_liveupdate_adopt_ari(struct pci_dev *dev)
 	return 0;
 }
 
+bool pci_liveupdate_is_outgoing(struct pci_dev *dev)
+{
+	guard(rwsem_read)(&pci_liveupdate.rwsem);
+	pci_WARN_ONCE(dev, !dev->liveupdate.frozen, "Preservation status is unstable!\n");
+	return dev->liveupdate.outgoing;
+}
+
 /**
  * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
  * @dev: The PCI device to check
diff --git a/drivers/pci/liveupdate.h b/drivers/pci/liveupdate.h
index 5aac19f7bee6..333ddd8f36c5 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -18,6 +18,7 @@ bool pci_liveupdate_preserve_bus_numbers(void);
 bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus, struct pci_dev *dev);
 int pci_liveupdate_adopt_acs(struct pci_dev *dev);
 int pci_liveupdate_adopt_ari(struct pci_dev *dev);
+bool pci_liveupdate_is_outgoing(struct pci_dev *dev);
 #else
 static inline void pci_liveupdate_setup_device(struct pci_dev *dev)
 {
@@ -51,6 +52,11 @@ static inline int pci_liveupdate_adopt_ari(struct pci_dev *dev)
 {
 	return -EINVAL;
 }
+
+static inline bool pci_liveupdate_is_outgoing(struct pci_dev *dev)
+{
+	return false;
+}
 #endif
 
 #endif /* DRIVERS_PCI_LIVEUPDATE_H */
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index dff60a03204f..c1ac2ef025e2 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -569,11 +569,14 @@ static void pci_device_shutdown(struct device *dev)
 	/*
 	 * If this is a kexec reboot, turn off Bus Master bit on the
 	 * device to tell it to not continue to do DMA. Don't touch
-	 * devices in D3cold or unknown states.
+	 * devices being preserved for Live Update or in D3cold or
+	 * unknown states.
+	 *
 	 * If it is not a kexec reboot, firmware will hit the PCI
 	 * devices with big hammer and stop their DMA any way.
 	 */
-	if (kexec_in_progress && (pci_dev->current_state <= PCI_D3hot))
+	if (kexec_in_progress && !pci_liveupdate_is_outgoing(pci_dev) &&
+	    pci_dev->current_state <= PCI_D3hot)
 		pci_clear_master(pci_dev);
 }
 
-- 
2.55.0.1082.g2b9226bbc0-goog


