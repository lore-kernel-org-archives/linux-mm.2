Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C175606A9BA
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 22:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=bTKCUpMg
Received: by kanga.kvack.org (Postfix)
	id 6816B6B060D; Wed, 18 Nov 2026 17:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633996B0611; Wed, 18 Nov 2026 17:37:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AC1F6B0612; Wed, 18 Nov 2026 17:37:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B32A6B060D
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:37:17 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C663160905
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:37:16 +0000 (UTC)
X-FDA: 85449702072.18.9328916
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	by imf08.hostedemail.com (Postfix) with ESMTP id B52AC16000E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 22:37:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=bTKCUpMg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3mSj-aggKCEIhqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com designates 209.85.160.69 as permitted sender) smtp.mailfrom=3mSj-aggKCEIhqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795041434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dseap2a1tzzPeaoigzCviLoXjiETn3csEuQBuadnT6s=;
	b=ulx/9ySvU9tIGVTveysJJ5nThpB7r7D4WLWsLM7D8aBKE4dseq8wj4/dr9YYoDl1pfQ58k
	HCfW/mETSDxOMNs0tfZS9k60ucKMzuSQV5UVQ1Wn6BS4/EINKcHUiEblQus/pR1AEJOQ6P
	baUSSPrqKKCpafyEhHO3R0+TPH3cfdU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=bTKCUpMg;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 3mSj-aggKCEIhqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com designates 209.85.160.69 as permitted sender) smtp.mailfrom=3mSj-aggKCEIhqexpegoksskpi.gsqpmry1-qqozego.svk@flex--dmatlack.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795041434;
	b=C1ynOYvQ5RP/TZPHJEKd411h/NkD8KkXTT/wOUjSGxXqvDBjMVDh2SV/N5WfJvgv6jDTQ3
	/1Jaaw5W2FIHtVoz7869K0lRpFS4JBF/5jF3lMiagK4J2kRHRFxsJjwaNBU4r/eTMzxh60
	wNuRnf+cbQyBz3MVJbFh9S+tOtM7qg0=
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-448d51840c4so1082122fac.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 14:37:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795041434; x=1795646234; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dseap2a1tzzPeaoigzCviLoXjiETn3csEuQBuadnT6s=;
        b=bTKCUpMgZRl93Uqd/VeUP8b/zDhiR6Jro5/dGezAc1b3Ij+5+/bnQF02gx8fMK7d4J
         N6wF9EkkPFxLZ+IQPjMHKkYdMu57KBW9oMKGWiuPweIid9BEbPRDyRjPmg3uJdSkD2G8
         PjKdWgIqyiHDpYcaSXPCBGNa1m8kArSz1R0mh9WH2rCwUExDl8wdO10ION7hD+292ojx
         RNEf1b+7f9qw586014EYJaiVvl1IIdxY6ajvzSS3ngL4u5LiP3/35MHGgIPDQPGj2pM0
         PI6v9D4M0QHws8h1dgpsRqhsmp+DOuC3N2w64to290d4kIBlIVIQft9Z547vUqy0rMSr
         kbDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795041434; x=1795646234;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dseap2a1tzzPeaoigzCviLoXjiETn3csEuQBuadnT6s=;
        b=2HMWG7HcycclflXxk10OSaQnlj4VNWEz/FniO9cyIoTHob43pSgm3kZyrt8ELG+NzI
         t9B1AU3rAzseVbZTTvBkJgKIrb0jO0H1zCVFCN2CPRRaYxuLG2QgPrOZQBH1EreyKH8w
         Bp+/XjNQTugXPc6qYjh7zV94lwobivyLMyKDv1mpAxmWNAoHu+BLYw/aJ6BGs3FHHdxE
         WsumST2PUXyiKo+Esn0tNQ1nnBl3QKh+fjJkWEaTbEw21DnYv5IMVyuVTZAz3PdU+/E0
         LSAj6bAiyQfz0Ra3dah9TbQ89I89HTsEQGj8ZnhxuuhX8jqrAfdFcCFOu/+1AH7/mPnF
         rexw==
X-Forwarded-Encrypted: i=1; AL+hErGkLIvSVOQgsIDm0dHHIqESM5idQOdJkNBeksEZbUSj/257EMfUWn/PVSzOYJ1w3DmLVbTIr4+oCQ==@kvack.org
X-Gm-Message-State: APuU4Z8RISVvM7NXT5/q+M0J485uJskX9ykxLkolgGQy+itp3qmN7F7V
	ZcwB1vCDVXCDTx2akwm2lraEPETfMbAvoPQHTTmKFTgNTjUHQqpmpwRnUcoS0/C5Pjz0uvx2aMp
	vOG/mUQNffdzuCg==
X-Received: from jaan16-n1.prod.google.com ([2002:a05:6638:aad0:10b0:620:20bd:b624])
 (user=dmatlack job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6809:703:10b0:567:f627:67eb with SMTP id 5614622812f47-5775a1dbdf5mr3136425b6e.25.1795041433518;
 Wed, 18 Nov 2026 14:37:13 -0800 (PST)
Date: Wed, 18 Nov 2026 22:36:56 +0000
In-Reply-To: <20261118223704.3286085-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261118223704.3286085-1-dmatlack@google.com>
X-Mailer: git-send-email 2.56.1.708.g77570a6a1d-goog
Message-ID: <20261118223704.3286085-6-dmatlack@google.com>
Subject: [PATCH v11 05/13] PCI: liveupdate: Auto-preserve upstream bridges
 across Live Update
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
X-Stat-Signature: oudyofpae9gkepry75gtnx4ui667q99x
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B52AC16000E
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795041434-546705
X-HE-Meta: U2FsdGVkX19ZgtyfNF+vQrli2C14tOCamflrXxZXQPzjXuxzF3WsVJJg+ikRhDbxX5CV836ycXw6QNDVx30hLeU2z4aau/pxzjpZxk3INTAcwxMM4ORPLcaVMDBOB2VSOzJoLLZQVmTlr+W3dzj9mDKpJnqVEBJoynOObazRpDmRKyXcnYpS/YZDdouw15arXEgLVjzJ1+9AzEMEniuEaLKr2+FeRzojyGPOP5w4ec3W2dxc2Ug9sWsg7fHyVRvZvnoeghiXfEF6nL9NmB9uaqhW7X6H14nuncrU2He+RbGYGQajwJvvpgB0l5hstJciOl9/sGMkwbth3GF2bIZVm4JTiDE959DZ4cxKN9GDiiSzTVHMcc3mY4s55fCT7TD5ofPzTkbzXomlJlOcXmV4xnJmpXrVn58gJDq48UUti4FpUN5BBuNK0qnQPgRBkQS9CdSacnaHV6eBRACKooYg2ofERx7Y0xM6hzPGHmngGthH9vUM1LmZ1ZIQ84hRzsWrBuP2ydhIOv4eK6pnhTYHxtV8farr1r+ri6SNFfkFH1NqzWnfVdulO+r2kcWHJLdGLFzoyGaHMqK6QdbeD1lZf7qRQnmm+ICkmMUKYl0hgD8pQuvRile7PArou0kBV07nQ0ixT8NGqVtvN78UfdWLUkoxJ04BrMzpANMiCLQWD5LWMUxZk5OLMDrCwdB5/EZ6BfV2ez7G/iiSh2uKr7M28CLPVipgNsWATe9eTHmROO8REw/BsqmQDQ4sO+8gTkK8jcCpuV0ff56YbUmfXqYD9x94DXWOAe7BPWD0VwrShEqSu9gavmP8dTpEExI2VEPfGYM+y+C0xDLJdRREW39iiyIG3ysVtcx4kqc1vMi1YlHU9Sx01z5CVh+CY9F4hiL8+RCkjVpjnPWJXvGuxJug3bTR7+IF2rfXQFhYputKIRwZPVqYne9af5wNn7XqUlj9cCep5/0m+pMgeSTaTxQ
 OV49AHa6
 OUiR8rRdhWgtdCp/1Fg+PJmirg+qzHE3N7BhxUbHXqM8gzIBpMCH8GQ3LU3pxN+C/Q1vtqk1Z8R4M1Q7pju0A2Ijh8C9Is7dL26ZJGh9k57NjQ/cqPqhnEDro4nLuQWcA4YI6GDQx9jZKmfaLePgwjOFiLqr92L3xwClLxHJ4srbTaNzI5EZxlfJCxi3giH7TwXW0pJeQuqWFw8ciFCFc7ikRymUrKunDFjOXvbFxvajSi2fD5FV+URCASB46SLO+Zrf72w5nnGINg/IKT5UCnwuFsj+Y8l0JtdpL6cq1M4J8sO1oCwt0UKKuVl7km7JUqv4pOcoKjxapcdF87DjyVynltCgoJlFI5OYHT2nW/OSERTWGvrBXPUBno2gCXFYirHfKOkthk+j6oJhKb20vqHHAae+iDS+R8nQqHzv+DenF9qsBgRlKx1cUquIOVpB6LvCxayxhu95HylCrcO1Q6QcVaC/S0lZ86NOAeQdKcnCjyruj0hEkcWONuOoRBmqzOmbZz5Ym3XQhfQZsuoLtnvyFdEgBDK0CoAD8W0NCXOGlZzsl/ERkvwP2C0HtpfNkCQ+3igv8YP4mBDqcBkTRDF2dRVshqO/BOacNMR0p2E44ZBiFao65zbt9tbW9O8+fFvUlY/l0v5XcMnlbfMG+19OsAMfzKgug1qJH0F2+DpXzOsHX1jNO4MPfDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Automatically preserve every bridge between a preserved device and its
root port when the device is preserved.

Subsequent commits use this to ensure that preserved devices can
continue performing memory transactions without a disruption or change
in routing.

Track the number of preserved devices at or below each bridge with a
reference count in struct pci_dev_ser. A bridge stays preserved until
all of its downstream preserved devices are unpreserved or finish their
participation in the Live Update.

struct pci_ser::nr_devices counts the struct pci_dev_ser entries that are
in use, so it only changes when a device's entry is allocated or
released, i.e. when its reference count goes from 0 to 1 or from 1 to 0,
not on every preserve and unpreserve.

Signed-off-by: David Matlack <dmatlack@google.com>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Pranjal Shrivastava <praan@google.com>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/pci/liveupdate.c | 125 +++++++++++++++++++++++++++++----------
 include/linux/pci.h      |   3 +
 2 files changed, 97 insertions(+), 31 deletions(-)

diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
index d1b4000c3e78..ad2bb73e1d05 100644
--- a/drivers/pci/liveupdate.c
+++ b/drivers/pci/liveupdate.c
@@ -122,7 +122,6 @@
  * preserved. These may be relaxed in the future:
  *
  *  * The device cannot be a Virtual Function (VF).
- *  * The device cannot be behind a PCI-to-PCI bridge.
  *
  * Driver Binding
  * ==============
@@ -137,6 +136,18 @@
  * bound to the correct driver. The PCI core does not protect against a device
  * getting preserved by driver A in the outgoing kernel and then getting bound
  * to driver B in the incoming kernel.
+ *
+ * PCI-to-PCI Bridges
+ * ==================
+ *
+ * Any PCI-to-PCI bridges upstream of a preserved device are automatically
+ * preserved when the device is preserved. The PCI core keeps track of the
+ * number of downstream devices that are preserved under a bridge so that the
+ * bridge is only unpreserved once all downstream devices are unpreserved.
+ *
+ * This lets the PCI core keep the bridges above preserved devices forwarding
+ * their memory transactions, without changes in routing, throughout the Live
+ * Update.
  */
 
 #define pr_fmt(fmt) "PCI: liveupdate: " fmt
@@ -437,7 +448,8 @@ static struct pci_dev_ser *pci_liveupdate_alloc_dev_ser(
 }
 
 /*
- * Stop preserving @dev by releasing its struct pci_dev_ser.
+ * Stop preserving @dev by releasing its struct pci_dev_ser. The caller must
+ * have dropped the last reference on it.
  */
 static void pci_liveupdate_free_dev_ser(struct pci_flb_outgoing *outgoing,
 					struct pci_dev *dev)
@@ -450,43 +462,71 @@ static void pci_liveupdate_free_dev_ser(struct pci_flb_outgoing *outgoing,
 	dev->liveupdate.outgoing = NULL;
 }
 
-static void pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing,
-					     struct pci_dev *dev)
+static int pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing,
+					    struct pci_dev *dev)
 {
 	struct pci_dev_ser *dev_ser = dev->liveupdate.outgoing;
 
 	if (!dev_ser) {
 		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
-		return;
+		return -EINVAL;
 	}
 
+	if (!dev_ser->refcount) {
+		pci_WARN(dev, 1, "Preserved device has a 0 refcount!\n");
+		return -EINVAL;
+	}
+
+	if (--dev_ser->refcount)
+		return 0;
+
 	pci_liveupdate_free_dev_ser(outgoing, dev);
+	return 0;
+}
+
+static void pci_liveupdate_unpreserve_path(struct pci_flb_outgoing *outgoing,
+					   struct pci_dev *dev,
+					   struct pci_dev *end)
+{
+	for_each_pci_dev_in_path(dev) {
+		if (dev == end)
+			break;
+
+		if (pci_liveupdate_unpreserve_device(outgoing, dev))
+			return;
+	}
 }
 
 static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
 					  struct pci_dev *dev)
 {
-	struct pci_dev_ser *dev_ser;
+	struct pci_dev_ser *dev_ser = dev->liveupdate.outgoing;
 
 	if (dev->is_virtfn) {
 		pci_warn(dev, "Cannot preserve Virtual Functions\n");
 		return -EINVAL;
 	}
 
-	if (dev->liveupdate.outgoing) {
-		pci_warn(dev, "Device is already preserved\n");
-		return -EBUSY;
+	if (dev_ser) {
+		/*
+		 * Endpoint devices can only be preserved once. Bridges are
+		 * preserved once for every preserved device below them.
+		 */
+		if (!dev->subordinate) {
+			pci_warn(dev, "Device is already preserved\n");
+			return -EBUSY;
+		}
+
+		if (!dev_ser->refcount) {
+			pci_WARN(dev, 1, "Preserved device with 0 refcount!\n");
+			return -EINVAL;
+		}
+	} else {
+		dev_ser = pci_liveupdate_alloc_dev_ser(outgoing, dev);
+		if (IS_ERR(dev_ser))
+			return PTR_ERR(dev_ser);
 	}
 
-	if (!pci_is_root_bus(dev->bus)) {
-		pci_warn(dev, "Cannot preserve devices behind bridges\n");
-		return -EINVAL;
-	}
-
-	dev_ser = pci_liveupdate_alloc_dev_ser(outgoing, dev);
-	if (IS_ERR(dev_ser))
-		return PTR_ERR(dev_ser);
-
 	dev_ser->refcount++;
 	return 0;
 }
@@ -500,12 +540,16 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
  * pci_liveupdate_preserve() from their struct liveupdate_file_handler
  * preserve() callback to ensure the outgoing struct pci_ser is already set up.
  *
+ * pci_liveupdate_preserve() automatically preserves all bridges upstream of
+ * @dev.
+ *
  * Return: 0 on success, <0 on failure.
  */
 int pci_liveupdate_preserve(struct pci_dev *dev)
 {
 	struct pci_flb_outgoing *outgoing = NULL;
-	int ret;
+	struct pci_dev *start = dev;
+	int ret = -ENODEV;
 
 	guard(rwsem_write)(&pci_liveupdate.rwsem);
 
@@ -513,7 +557,13 @@ int pci_liveupdate_preserve(struct pci_dev *dev)
 	if (IS_ERR(outgoing))
 		return PTR_ERR(outgoing);
 
-	ret = pci_liveupdate_preserve_device(outgoing, dev);
+	for_each_pci_dev_in_path(dev) {
+		ret = pci_liveupdate_preserve_device(outgoing, dev);
+		if (ret) {
+			pci_liveupdate_unpreserve_path(outgoing, start, dev);
+			break;
+		}
+	}
 
 	pci_liveupdate_flb_put_outgoing();
 	return ret;
@@ -528,6 +578,9 @@ EXPORT_SYMBOL_GPL(pci_liveupdate_preserve);
  * longer be preserved across the next Live Update. Drivers are expected to call
  * pci_liveupdate_unpreserve() from their struct liveupdate_file_handler
  * unpreserve() callback, while the outgoing struct pci_ser still exists.
+ *
+ * pci_liveupdate_unpreserve() drops @dev's reference on each bridge upstream of
+ * @dev, unpreserving bridges that have no other preserved devices below them.
  */
 void pci_liveupdate_unpreserve(struct pci_dev *dev)
 {
@@ -541,7 +594,7 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev)
 		return;
 	}
 
-	pci_liveupdate_unpreserve_device(outgoing, dev);
+	pci_liveupdate_unpreserve_path(outgoing, dev, /*end=*/NULL);
 	pci_liveupdate_flb_put_outgoing();
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
@@ -621,28 +674,30 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
 		pci_WARN(dev, 1, "Destroying incoming-preserved device!\n");
 }
 
-static void pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *dev)
+static int pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *dev)
 {
 	if (!dev->liveupdate.incoming) {
 		pci_warn(dev, "Cannot finish preserving an unpreserved device\n");
-		return;
+		return -EINVAL;
 	}
 
-	if (dev->liveupdate.incoming->refcount != 1) {
-		pci_WARN(dev, 1, "Preserved device has a corrupted refcount!\n");
-		return;
+	if (!dev->liveupdate.incoming->refcount) {
+		pci_WARN(dev, 1, "Preserved device has a 0 refcount!\n");
+		return -EINVAL;
 	}
 
 	/*
-	 * Drop the refcount so this device does not get treated as an incoming
-	 * device again, e.g. in case pci_liveupdate_setup_device() gets called
-	 * again because the device is hot-plugged.
+	 * Once the refcount reaches 0 the device is no longer treated as
+	 * incoming, e.g. if pci_liveupdate_setup_device() gets called again
+	 * because the device is hot-plugged.
 	 */
-	dev->liveupdate.incoming->refcount = 0;
+	if (--dev->liveupdate.incoming->refcount)
+		return 0;
 
 	pci_info(dev, "Device is finished participating in Live Update\n");
 	dev->liveupdate.incoming = NULL;
 	ser->nr_devices--;
+	return 0;
 }
 
 /**
@@ -654,6 +709,10 @@ static void pci_liveupdate_finish_device(struct pci_ser *ser, struct pci_dev *de
  * Update. Drivers must call pci_liveupdate_finish() from their struct
  * liveupdate_file_handler finish() callback, while the incoming struct pci_ser
  * is still available.
+ *
+ * pci_liveupdate_finish() drops @dev's reference on each bridge upstream of
+ * @dev, finishing bridges that have no other incoming preserved devices below
+ * them.
  */
 void pci_liveupdate_finish(struct pci_dev *dev)
 {
@@ -667,7 +726,11 @@ void pci_liveupdate_finish(struct pci_dev *dev)
 		return;
 	}
 
-	pci_liveupdate_finish_device(incoming->ser, dev);
+	for_each_pci_dev_in_path(dev) {
+		if (pci_liveupdate_finish_device(incoming->ser, dev))
+			break;
+	}
+
 	pci_liveupdate_flb_put_incoming();
 }
 EXPORT_SYMBOL_GPL(pci_liveupdate_finish);
diff --git a/include/linux/pci.h b/include/linux/pci.h
index bb500623ca3e..6482549a8417 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -840,6 +840,9 @@ static inline struct pci_dev *pci_upstream_bridge(struct pci_dev *dev)
 	return dev->bus->self;
 }
 
+#define for_each_pci_dev_in_path(dev) \
+	for (; dev; dev = pci_upstream_bridge(dev))
+
 #ifdef CONFIG_PCI_MSI
 static inline bool pci_dev_msi_enabled(struct pci_dev *pci_dev)
 {
-- 
2.56.1.703.gf848ed807c-goog


