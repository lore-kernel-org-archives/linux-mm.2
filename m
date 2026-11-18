Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F378D606A6C8
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 22:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=iwcgmoy6
Received: by kanga.kvack.org (Postfix)
	id 65CCD6B0619; Wed, 18 Nov 2026 17:37:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60B066B061A; Wed, 18 Nov 2026 17:37:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D27A6B061B; Wed, 18 Nov 2026 17:37:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0F9756B0619
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:37:26 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 82BA1A8505
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:37:25 +0000 (UTC)
X-FDA: 85449702450.29.0EF4947
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	by imf30.hostedemail.com (Postfix) with ESMTP id B97C280009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:37:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=iwcgmoy6;
	spf=pass (imf30.hostedemail.com: domain of 3oij-aggKCEsqzn6ynpxt11tyr.p1zyv07A-zzx8npx.14t@flex--dmatlack.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=3oij-aggKCEsqzn6ynpxt11tyr.p1zyv07A-zzx8npx.14t@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795041443;
	b=5edZ6LE83zuT0gBcqi8WS5vgmKn409lntGvkpj5yqFySwnG0ci3OOTdlAm+qoz8H7U6Qp0
	5Gnx0OadvIL0D4WyQcrk/X06wlWvDk8eWNaJfFF6MAPC1CNTZLh/NcQc28+x4jcg/eVvT9
	pZyse/RBDYMX03pHL2T9zPVewQ60vEw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795041443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1uW5sdRp5YWPj/rz8uudGhABXbeY/lZgJ5YVMOGqNdk=;
	b=WxsgPYwm5MvIxsWlFPkc4KOUClQ4SNvhP0o7KwrUcp/xoxL1xrZ+wkvLi3IdH3xoqFYF35
	FCZvue6DEkPrdYnPCf0/1DdyuamDPNf6uqOFeG4uEgDrQeFqDW7LTMNjwEpd9dXCCHOKKj
	QgYeXrrVbgeyhtNDdNDoHL0AXhioK7c=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=iwcgmoy6;
	spf=pass (imf30.hostedemail.com: domain of 3oij-aggKCEsqzn6ynpxt11tyr.p1zyv07A-zzx8npx.14t@flex--dmatlack.bounces.google.com designates 209.85.210.70 as permitted sender) smtp.mailfrom=3oij-aggKCEsqzn6ynpxt11tyr.p1zyv07A-zzx8npx.14t@flex--dmatlack.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-862bca06702so2134356a34.0
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:37:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795041443; x=1795646243; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1uW5sdRp5YWPj/rz8uudGhABXbeY/lZgJ5YVMOGqNdk=;
        b=iwcgmoy6fTRl2jt/uaLBcDr36pA7aOYOxCgcmSMGYMqq1/1LTUmDVm/ZUduxXSdfMu
         5MWv8p/Fqvf1OQKJl2dA62lnJ6Fzr1wP6uNVnXWhSjoEIYyPUcUaJnVehbssBOP5+OxL
         OlpY1+GxYMmI3fHcsd/qebG/TMQ1nrbFbrKgwm26sTlddU9Cv1qsNxRk436Bc/YYfo9+
         CV/aEFVa8jA8vikbG3nKrzgwZR/hCO/ShkJCJW+dAN1RGolGKtLsI7CEGOC8M7vlnbyA
         WaMu2S3wiysMx/uMMuvtf01jifjgcgoPQpXi/1KE8Hw0rSfhcHPhoemXXXTu6bHARfb0
         mAfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795041443; x=1795646243;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1uW5sdRp5YWPj/rz8uudGhABXbeY/lZgJ5YVMOGqNdk=;
        b=fc9fnry6JUGDMqrCSn2wRMiQwpAxP8CWyCrsWcmBbWtAUjSTi7IstoNTkdlS0Q9OIV
         JJWOhbvMKWUc609uZTopjLRSZfQWAGU7hXVy9j8YtCyl+hN2mRAyLjoaG6tsje3hNeiN
         clJHLudpxuXMsHQ9PKVvLtk23CfcPXX2YwIiFnKwp8y+D54wUvLTt5EEttACnH0Q4t5z
         vUcjeeEqTEVvXT2jNw7XVUWI0LRbiTY1UmBaF8OretQKBKQ4nLEm6XME8QZ6jlP8KVSP
         2/SNiNp9ZxMhUymFgyp7JYcqVDWEQ1IDWigNxRijayPNR86XynrASq7kLiMQi1eHwQfE
         qrUQ==
X-Forwarded-Encrypted: i=1; AL+hErHaz7UtH187eT0H1tI/jYzMKIZd6VADriHQceNlDBkUHnJjsgz0BQ+yPPMfUtkkeqXDA6ovih+BwQ==@kvack.org
X-Gm-Message-State: APuU4Z/j0lnmp0K/aJ2ydtMzKxB7ckdqWPoCL1i0aoUPHmLX03JLxKCH
	B2x91mRNXZhylDw65LaCj8RzwxecZOeDEyNE5+aX7gu1o5B6kDtEGFRFzKYatXNaQCViQSU4hUS
	wmXEE5sus/tSHLA==
X-Received: from iocou22-n1.prod.google.com ([2002:a05:6602:c316:10b0:9ca:dc6e:2262])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:182a:b0:4cb:f21b:6f91 with SMTP id 5614622812f47-57742936db2mr4808486b6e.36.1795041442511;
 Wed, 18 Nov 2026 14:37:22 -0800 (PST)
Date: Wed, 18 Nov 2026 22:37:03 +0000
In-Reply-To: <20261118223704.3286085-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261118223704.3286085-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118223704.3286085-13-dmatlack@google.com>
Subject: [PATCH v11 12/13] PCI: liveupdate: Do not disable bus mastering on
 preserved devices during kexec
From: David Matlack <dmatlack@google.com>
To: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Alex Williamson <alex.williamson@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Down <chris@chrisdown.name>, Chris Li <chrisl@kernel.org>, 
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B97C280009
X-Rspam-User:
X-Stat-Signature: knufuiezjsk19w39zp9ds9tpjy3r1wx9
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795041443-497110
X-HE-Meta: U2FsdGVkX18E4ABpcQML8hq/Q3hTDrKkh8Zwq/PZM/k18JfczIY3alGIy65xwZFyv9zCfNwEX5nzHGSLXLQyS6Xs0VXmHDSD7oDJtmk0kAinz1uAB6cbKh1JXcetAySWpVCrFRxmZjKD8pK1H2KHzeS5g6uwb1MFq2YCyx6+HVKzV64/mIOrQaatD+meflXuuEn0Lm8T4KpX0N+aCD8WrpcwMotHUcelJ/Z77VHxwj20QLgHmdjzMUxNZPKx1RWn92wqB6zPbzxE1RvvKnVh+rDhOEU2082lrhIfCtWZS/kz8N5ZHOUBOEzyztZxRuIDwY+9XorxJfns6YuWsvEwKeQF1bV7IP2QtvWvBZWfBfQZs1S8MEoNfG4RS7V4m8MmC1ELETidFLAE8EHnGVLHD8vRWjq2QFPs9rxPdksuyl544OwGKUwDHimc6DEBokRQf/2uA2CIEDVjoqtVyZlJdUTlN2jO7apKSl1O/9NlmrkWWRLtd0vSdO8+NR+a24EvE4h9F9etFgU4BefnP+/a0YXpbe2q5DCb2HerTUxnLUVjOszbWE9/XWWkVv0juDl6Gk7+ZSHx99xRNuONpfQZIRbg3vBZpM09KVU2Xvjv5gXwOmb7FavXRpSlfR5kVGld4fCYoTv+V3G2qb4qQzEEy4j0T1RmiKox1sEitGexzuvlA4CMqhOM09CTYDNicJuRzACDolNAG+vY6GXr1BdnhSeSIfnggBFZv1YiYi9o6yJpAQ11Hb44bDdZ+OYqvUI6rqQm+qwg6AWRO5VwnKZT9ON1AaPfFrIN6vEhnR4RXrBJTUw/FVGQYc+1NcoJsa74wk1oACauOFD3e4swBRZ47dYKUGcK1RfnQ4uox32r735Pvs+pv4W3KLIRnag9cECuaaHhmv0QftSpFX96KNJKRWW0P5HN9W2bZDUqzvw3TL2pn+VBwpGkDu9QKVGi0kYMJSD1P9EIhEloK+avHNB
 mdSvdCXe
 hkzPrZAy4d97RoiYBG4vF11nFe8xK0MGmszIKpN3qGL2hxTXpUkHZaCIZ5rVMbPOc7JXOxEdTGA0kBymp/JoVvW9BnG1IocxsHIDKC++3bqIRgizBl8o1f4yvJ8jqAavMiI8bUosvI32dMtnzg0P1+0KqiAqh7ffCIkKWrIzH9PGSfZj6YjVDwb5wAYT2wHyxPy9V3e7AkrGKO1lZggNba3NqDWCyimuyaBSHolS6X6TTUY+lJPYau2fMYX4reZOuM4ulIMeaEumBvuiPOnM1OpMADsP2a/wn+hE7xNBxhs40Cs/KnVBJyWmcSk4zdOxkosRmcs7j4kzAMcIWRb06nnJUJ9cYMhHzku8t15FcUcp1+sFbPq56AaMFL6RH3z35IuofpVWQ2TLqpyExRCgptuS5Y/wuiHo0WfGI1Qwrduut1YO5PNZax5auplWsazxQYT428DGm1eu1GdMNVjUu5Jma7lhjcW4ZCINwAMckiMn+YWVwMyH2IFjwhoSCiv0Cs1CE9dtvS7pEJjybZ3Zt1qoZVv/WsDe2JAlXtvl73UmaoGWtA+QYedync1JVYpqO0QBZxzOtZB17R9AY+l9IF22BBMwfeNdK5l68CBtp/Ltfq/WVzwzLt8keQykNLLFiEVanxzqcqENhRK7LsBUvfp4vlwzbU7ox/uwlayGc2G3neBHKyNiqPVjl/Et16CwXKCsgpVvmcg1s5S1cSZv+468opRExoXce4rP/ISkLNJ5XEoyyZzl8/so++Kgi+104tOw5HMsK9Cz1nJ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Do not disable bus mastering on outgoing preserved devices during
pci_device_shutdown() for kexec.

Preserved devices must keep performing memory transactions during a Live
Update. Clearing the Bus Master Enable bit would prevent these devices
from issuing any memory requests while the new kernel boots.

Because bridges upstream of preserved endpoint devices are also
automatically preserved, this change also avoids clearing bus mastering
on them. Clearing Bus Master Enable on an upstream bridge prevents the
bridge from forwarding memory requests upstream (i.e. it would prevent
the endpoint device from accessing system RAM and doing peer-to-peer
transactions with devices not downstream of the bridge).

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/liveupdate.c | 11 +++++++++++
 drivers/pci/liveupdate.h |  6 ++++++
 drivers/pci/pci-driver.c |  6 ++++--
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index e26d2f5c2338..493576119a76 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -196,6 +196,10 @@
  *    preserved devices, even with pci=noari, until all preserved devices below
  *    the bridge have finished. This keeps the preserved devices on the bridge's
  *    secondary bus addressable with the same function numbers.
+ *
+ *  * The PCI core does not disable bus mastering on outgoing preserved devices
+ *    during kexec. This allows preserved devices to issue memory transactions
+ *    throughout the Live Update.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -946,6 +950,13 @@ int pci_liveupdate_adopt_ari(struct pci_dev *dev)
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
index 03211dbebc7b..e0c21c1f7e78 100644
--- a/drivers/pci/liveupdate.h
+++ b/drivers/pci/liveupdate.h
@@ -18,6 +18,7 @@ bool pci_liveupdate_preserve_bus_numbers(void);
 bool pci_liveupdate_refuse_bus_numbers(struct pci_bus *bus, struct pci_dev *dev);
 int pci_liveupdate_adopt_acs(struct pci_dev *dev);
 int pci_liveupdate_adopt_ari(struct pci_dev *dev);
+bool pci_liveupdate_is_outgoing(struct pci_dev *dev);
 
 static inline bool pci_liveupdate_was_incoming(struct pci_dev *dev)
 {
@@ -57,6 +58,11 @@ static inline int pci_liveupdate_adopt_ari(struct pci_dev *dev)
 	return -EINVAL;
 }
 
+static inline bool pci_liveupdate_is_outgoing(struct pci_dev *dev)
+{
+	return false;
+}
+
 static inline bool pci_liveupdate_was_incoming(struct pci_dev *dev)
 {
 	return false;
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index 8b11bd3dc5bc..08b768b9e905 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -569,11 +569,13 @@ static void pci_device_shutdown(struct device *dev)
 	/*
 	 * If this is a kexec reboot, turn off Bus Master bit on the
 	 * device to tell it to not continue to do DMA. Don't touch
-	 * devices in D3cold or unknown states.
+	 * devices being preserved for Live Update or in D3cold or
+	 * unknown states.
 	 * If it is not a kexec reboot, firmware will hit the PCI
 	 * devices with big hammer and stop their DMA any way.
 	 */
-	if (kexec_in_progress && (pci_dev->current_state <= PCI_D3hot))
+	if (kexec_in_progress && !pci_liveupdate_is_outgoing(pci_dev) &&
+	    pci_dev->current_state <= PCI_D3hot)
 		pci_clear_master(pci_dev);
 }
 
-- 
2.56.1.703.gf848ed807c-goog


