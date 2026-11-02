Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D454606B1C8
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Mz475sms
Received: by kanga.kvack.org (Postfix)
	id 690476B0659; Mon,  2 Nov 2026 10:37:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61EDB6B065A; Mon,  2 Nov 2026 10:37:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E1706B065A; Mon,  2 Nov 2026 10:37:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1BD0E6B0658
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:37:28 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6406A017D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:27 +0000 (UTC)
X-FDA: 85390583334.22.81AC3B9
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com [209.85.215.198])
	by imf19.hostedemail.com (Postfix) with ESMTP id DD5DE1A0013
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:37:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Mz475sms;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3NK7oagcKCJEG3A38D219916z.x97638FI-775Gvx5.9C1@flex--vipinsh.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3NK7oagcKCJEG3A38D219916z.x97638FI-775Gvx5.9C1@flex--vipinsh.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793633845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Co3UjJyFEnZJpTpwZDKwqCjGC43bvHMJxy07QdLEStk=;
	b=Sxv0cXrIqsaDHy1Jwc1ENFr8ntyiIwatHXrmXE2PGHHM4hLAViMebsoypEyi8UL607SBlu
	c1nNkFhwDYw2YOGd5qw7AEz0hxyq/HiFg6BS4AnQhH3ssdMU6TvmplSWfSd6reEsHpgRhB
	KXUVRVm4iWVZ2UkL3zIASORHcgvM/Qc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Mz475sms;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf19.hostedemail.com: domain of 3NK7oagcKCJEG3A38D219916z.x97638FI-775Gvx5.9C1@flex--vipinsh.bounces.google.com designates 209.85.215.198 as permitted sender) smtp.mailfrom=3NK7oagcKCJEG3A38D219916z.x97638FI-775Gvx5.9C1@flex--vipinsh.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793633845;
	b=IV2PEzDoa4p4oc7aP2xKxVISGK8k3ARkicnKwjXOdrPxNNSjpIQNtnx1rdTFaNEC3GKEga
	7u3TvKcOV7LmVBGPPLpVobna5nOewaAxRM7lE3QHFldxtF4Nd7qyZQDzH7aJSXT2+cfmrF
	sIh9Xap5+FBQUq/+IYkHuIRy4iKo6Ew=
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cdacb64970bso1576524a12.1
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793633845; x=1794238645; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Co3UjJyFEnZJpTpwZDKwqCjGC43bvHMJxy07QdLEStk=;
        b=Mz475sms74ADHAlcbOatnR2THE8hC9eRt/k4mKwMbr/2KDGCDHg2Glc//o7JdJQTDa
         iq8+WIxdZ0B9vwCAhgzq4wn//LlH0jaFxcHa0gM/IrfVWzo22EWYFHQm/AQHjvf6ysZP
         3koStGbRMDlpQs1J2sLVZwVUyvF60jN3YbUyVg0cQi78Q66mhLFYFoLTWUe36dP3kA2/
         LkxGSXsezgeu/ZeUpcFz1BslhYyOSoPluxX9k2whywP1vkh3SmHsCKGcBi/nOiNoVJR/
         qxoOxt/2dbZOesq559u3niH3XZmhOtU3SKGjxjJ7U07MvpJGgbppTfpyrJJqwMUdybcd
         ZPLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793633845; x=1794238645;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Co3UjJyFEnZJpTpwZDKwqCjGC43bvHMJxy07QdLEStk=;
        b=pmwhrCy6qv7hF5N1XK+/6iFipc8NtYAW7IK78J9E/AU0vAZ705CQ6/6WDTeXzWCnVp
         VIaiRn7aGVjZ2pxOiWSVvZRjz1H0hoFXzrTYitixhleOihQy4+1Ap9U0SsXG0WprsVk5
         A193pqcZxdefiHI4jqdGP2H8IdOXJWBJTYPRU1c1KA3eDaQnZv7Ab3mFyAfNb9hXMAjn
         hExQRDyHEBy2hYSii5/Uj1B/sk3vj5+MO81REUO9AlwcnbLcOZmKTRqhQO+Mf/+rsMVK
         INLJuk/CD76vQrZnEpvz+VjdyVHbGCz+GdyMT+V8c+m3ncl4ngyS7o9owSPu4C/2jnb3
         6p7g==
X-Forwarded-Encrypted: i=1; AKwUvBy5NHkX7KlXsQXkuTJxJgTrEqAxrXfxa6G6MAHWvZLogEtQ0nMxj1qnzCzpesGzLGuOuBg3F8Pz+Q==@kvack.org
X-Gm-Message-State: APuU4Z+ZirPGCHnNCZpsaGW3uKPWcZ8+lhzNFX1qsZcmzRegFXOofQJg
	H3uALPiC9+A/0K8XGWOtKwhEdDTqEmEnCRSy9W7mRlV8BpqsuvAMJBW354jguHvS0fEAt5cLL4N
	6205NNB9JSw==
X-Received: from pjbir4.prod.google.com ([2002:a17:90b:4684:b0:3a8:74c5:5a5c])
 (user=vipinsh job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:3887:b0:3ac:97e3:73a3
 with SMTP id 98e67ed59e1d1-3ae89574e10mr7137697a91.6.1793633844535; Mon, 02
 Nov 2026 07:37:24 -0800 (PST)
Date: Mon,  2 Nov 2026 07:36:52 -0800
In-Reply-To: <20261102153656.1431701-1-vipinsh@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261102153656.1431701-1-vipinsh@google.com>
X-Mailer: git-send-email 2.56.0.317.g454f8302e1-goog
Message-ID: <20261102153656.1431701-24-vipinsh@google.com>
Subject: [PATCH v6 23/27] vfio: selftests: Add an attach() driver op
From: Vipin Sharma <vipinsh@google.com>
To: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org
Cc: ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, 
	kevin.tian@intel.com, leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, 
	mattev@meta.com, michal.winiarski@intel.com, parav@nvidia.com, 
	pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, 
	schnelle@linux.ibm.com, skhan@linuxfoundation.org, skhawaja@google.com, 
	vipinsh@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: DD5DE1A0013
X-Rspam-User: 
X-Stat-Signature: 8o3qrdse3wdhtoyc77jphj4fwiwzurzn
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=unavailable
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793633845-933859
X-HE-Meta: U2FsdGVkX1/CHtkoLelKZ1paoUldPB7WvAFz4jhsShgD/98ArOfopAgfqVIl0dAfex1A+0gXhomOsjYSnk92y+gVV490siCoMpOYO2bBywvm7RcF1Wi7Ytktkyf8HqUFvPD/WzPAfztAhk5RHns3ZAo3J3OYup4Ka0IyqDwTefik75GiU7F7QYmZFGt+QNjL5NwP2GzJ52d7ziqw7ujtn5cQz7+zLU7gOJa3s6BkcvCkfptoPBxX1QHwcURyDfiLZRnf9h37lX0E2g4AAD/UKXAGOdO0zZrN8vLx8Ddefz5Jy38TiisJjq85ygi2Iebflmg00jf1914Eht5lrvqjdYi5ytsYyoJB2AMf4DrVssJUEIUHVMQ80pbCCU26UHPiqov9mBN249QPzMl04A31EqN6vx98ib0YFqfsgHYVaH+b0briEuzCOqXO66ED94EK/cndeRxvDBaPMMP96AaJ8fbIYXnPZ7guLyWRZTFjAKesyX9YH+WOI5KGPreajcPOOX+IeIj6lVylEoPCpXHkbIv/6GT0rOZNReiaiz/tKwDIpHI1Oa0TreJTxEO0YYK5fjwkwLOaYAUJjTmjm3uGQ09R3vNAlV+Lc9T0g/FRPqZkNCAYrxHYf8xCE6ANsE6574+0vxzWPIT2j4cm5uCVwCAYtBe3LoEi5gAy+E8Gmy90ewlzOLUBlifh65MTDyZUu3pRxsU9wnKnN0Cu+y8OQ9kd6IpCqqsKI3B58t22Uwd+HCL1wflEb3CyIJ95LIIXPDY/0slLUDF7ljWBLk17u1NRMBxJxIRAy7KhAmLo9YU9u6PY0vxn/pScdhFKpLqJbeiOXodp3knDyVIyKhpflVAQcVoXX0JWF9ziWPeeKMFqbj4g9v1FyyBsKa5Mvkqam8Tfu7UtslZtQ54OdyDLAA83hzLStLeZlees6aTqAxLtSH7QxtFSqlflnPYrYLCqXCa0boEeSe9Ign7YAuw
 gbloMS5C
 TCXWBCMG+IN2/xGK8GB9UJcBetRtXHngY6lE27smdrDwZiJanbuF8iAtEW1BBsL8Z+2uPVs43Uekd9LgKJuGKnuOWV3zNf6o5OSKxbYJBX60SjZ55O4TM6gfu/uAbUq29wBSck7XXVVFj9YNQsM95uzKyq7GLuLttUPiqyIuOZYCuTOcR0EH0V0S8zKNICQW7ytcLn7BjYy5jwT8nyB9RGwR1XOxMuftOmBM2MfNxeWCMglSV5/3IYPINqpJzt6ejUHAlsUiti8VB4pZTyqPlTOvyuIjPN1kd/OOV0V4zvs7sv7v9Fqg+8e9MYRlXzqcF3XoeR499uBA1S5PVLgQDzPdzrchTFpYotcSP3RInGVuKi4YREHXpvVkFMeFE2T5rIYEKNGkjpq6cWnpxYbJklJKHBD7ry/YYwgxrtT5cHJX4tHGlc7u6F+790A4e4SJ1kTI98FFwNOkbFWeLSewYKtlcMDEWkInUIg5F+UYDmTUO2/LVK7vU7KLZTi5bVK08E5fa3b3Wb3uwc0nUcxAY0bkh3vvv9QRx1GTdR8UIT+NCRYToMyb/gMZ755xQRvIeVNZgSCBW9lGHlLvLFcNWZhpiNA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a new attach() op to vfio_pci_driver_ops and a corresponding
vfio_pci_driver_attach() wrapper to adopt a device that was already
initialized (and optionally has memcpy operations in flight) in another
process prior to a Live Update, without resetting or reprogramming the
hardware.

Implement attach() for the igb and dsa selftest drivers: refresh process-
local BAR pointers, verify that the device hardware state and descriptor
rings are still intact as left before kexec, re-enable MSI-X, and set
driver capability limits.

Signed-off-by: Vipin Sharma <vipinsh@google.com>
---
 .../selftests/vfio/lib/drivers/dsa/dsa.c      | 35 +++++++++++++++--
 .../selftests/vfio/lib/drivers/igb/igb.c      | 39 +++++++++++++++++--
 .../lib/include/libvfio/vfio_pci_driver.h     | 17 ++++++++
 .../selftests/vfio/lib/vfio_pci_driver.c      | 22 ++++++++++-
 4 files changed, 105 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c b/tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c
index 19d9630b24c2..2764ed4c67f8 100644
--- a/tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c
+++ b/tools/testing/selftests/vfio/lib/drivers/dsa/dsa.c
@@ -215,6 +215,16 @@ static void dsa_register_cache_init(struct vfio_pci_device *device)
 	dsa->max_copies_per_batch = min(dsa->max_copies_per_batch, ARRAY_SIZE(dsa->copy));
 }
 
+static void dsa_set_limits(struct vfio_pci_device *device)
+{
+	struct dsa_state *dsa = to_dsa_state(device);
+
+	device->driver.max_memcpy_count =
+		dsa->max_batches * dsa->max_copies_per_batch;
+	device->driver.max_memcpy_size = 1UL << dsa->gen_cap.max_xfer_shift;
+	device->driver.msi = MSIX_VECTOR;
+}
+
 static void dsa_init(struct vfio_pci_device *device)
 {
 	struct dsa_state *dsa = to_dsa_state(device);
@@ -236,11 +246,27 @@ static void dsa_init(struct vfio_pci_device *device)
 	dsa_command(device, IDXD_CMD_ENABLE_WQ);
 
 	vfio_pci_msix_enable(device, MSIX_VECTOR, 1);
+	dsa_set_limits(device);
+}
 
-	device->driver.max_memcpy_count =
-		dsa->max_batches * dsa->max_copies_per_batch;
-	device->driver.max_memcpy_size = 1UL << dsa->gen_cap.max_xfer_shift;
-	device->driver.msi = MSIX_VECTOR;
+static void dsa_attach(struct vfio_pci_device *device)
+{
+	struct dsa_state *dsa = to_dsa_state(device);
+	union gensts_reg gensts;
+
+	VFIO_ASSERT_GE(device->driver.region.size, sizeof(*dsa));
+
+	/* The device must still be enabled as dsa_init() left it. */
+	gensts.bits = readl(device->bars[0].vaddr + IDXD_GENSTATS_OFFSET);
+	VFIO_ASSERT_EQ((u32)gensts.state, IDXD_DEVICE_STATE_ENABLED,
+		       "Device was disabled or reset\n");
+	dsa_check_sw_err(device);
+
+	/* BAR0 is mapped at a different address now, refresh the pointers into it. */
+	dsa_register_cache_init(device);
+
+	vfio_pci_msix_enable(device, MSIX_VECTOR, 1);
+	dsa_set_limits(device);
 }
 
 static void dsa_remove(struct vfio_pci_device *device)
@@ -420,6 +446,7 @@ const struct vfio_pci_driver_ops dsa_ops = {
 	.name = "dsa",
 	.probe = dsa_probe,
 	.init = dsa_init,
+	.attach = dsa_attach,
 	.remove = dsa_remove,
 	.memcpy_start = dsa_memcpy_start,
 	.memcpy_wait = dsa_memcpy_wait,
diff --git a/tools/testing/selftests/vfio/lib/drivers/igb/igb.c b/tools/testing/selftests/vfio/lib/drivers/igb/igb.c
index fd9e05d77ea4..3f9f631a5977 100644
--- a/tools/testing/selftests/vfio/lib/drivers/igb/igb.c
+++ b/tools/testing/selftests/vfio/lib/drivers/igb/igb.c
@@ -224,6 +224,13 @@ static void igb_reset(struct igb *igb)
 	igb_write32(igb, E1000_IMC, 0xFFFFFFFF);
 }
 
+static void igb_set_limits(struct vfio_pci_device *device)
+{
+	device->driver.max_memcpy_size = IGB_MAX_CHUNK_SIZE;
+	device->driver.max_memcpy_count = RING_SIZE - 1;
+	device->driver.msi = MSIX_VECTOR;
+}
+
 /*
  * Program the device into a usable state.  Split out of igb_init() so it
  * can be reused after a device reset to re-program the registers that
@@ -372,9 +379,7 @@ static void igb_hw_init(struct vfio_pci_device *device)
 	igb->tx_tail = 0;
 	igb->rx_tail = 0;
 
-	device->driver.max_memcpy_size = IGB_MAX_CHUNK_SIZE;
-	device->driver.max_memcpy_count = RING_SIZE - 1;
-	device->driver.msi = MSIX_VECTOR;
+	igb_set_limits(device);
 }
 
 static void igb_init(struct vfio_pci_device *device)
@@ -400,6 +405,33 @@ static void igb_init(struct vfio_pci_device *device)
 	igb_hw_init(device);
 }
 
+static void igb_attach(struct vfio_pci_device *device)
+{
+	struct igb *igb = to_igb_state(device);
+	u64 iova_tx, iova_rx;
+
+	VFIO_ASSERT_GE(device->driver.region.size, sizeof(struct igb));
+
+	/* BAR0 is mapped at a different address in this process. */
+	igb->bar0 = device->bars[0].vaddr;
+
+	/*
+	 * The device must still use the rings and tails in the driver region,
+	 * i.e. it was not reset and the region is mapped at the same IOVAs.
+	 */
+	iova_tx = to_iova(device, igb->tx_ring);
+	iova_rx = to_iova(device, igb->rx_ring);
+	VFIO_ASSERT_EQ(igb_read32(igb, E1000_TDBAL(0)), (u32)iova_tx);
+	VFIO_ASSERT_EQ(igb_read32(igb, E1000_TDBAH(0)), (u32)(iova_tx >> 32));
+	VFIO_ASSERT_EQ(igb_read32(igb, E1000_RDBAL(0)), (u32)iova_rx);
+	VFIO_ASSERT_EQ(igb_read32(igb, E1000_RDBAH(0)), (u32)(iova_rx >> 32));
+	VFIO_ASSERT_EQ(igb_read32(igb, E1000_TDT(0)), igb->tx_tail);
+	VFIO_ASSERT_EQ(igb_read32(igb, E1000_RDT(0)), igb->rx_tail);
+
+	vfio_pci_msix_enable(device, MSIX_VECTOR, 1);
+	igb_set_limits(device);
+}
+
 static void igb_remove(struct vfio_pci_device *device)
 {
 	struct igb *igb = to_igb_state(device);
@@ -578,6 +610,7 @@ const struct vfio_pci_driver_ops igb_ops = {
 	.name = "igb",
 	.probe = igb_probe,
 	.init = igb_init,
+	.attach = igb_attach,
 	.remove = igb_remove,
 	.memcpy_start = igb_memcpy_start,
 	.memcpy_wait = igb_memcpy_wait,
diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_driver.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_driver.h
index e5ada209b1d1..09603eacab4d 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_driver.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_driver.h
@@ -28,6 +28,21 @@ struct vfio_pci_driver_ops {
 	 */
 	void (*remove)(struct vfio_pci_device *device);
 
+	/**
+	 * attach() - Adopt @device as init() and memcpy_start() left it, e.g.
+	 * in another process before a Live Update, without resetting or
+	 * reprogramming it. Memcpy operations started then keep going and can be
+	 * waited for with memcpy_wait(). Optional.
+	 *
+	 * Only sets up what is specific to the calling process (pointers into the
+	 * BARs kept in the driver state, MSI-X) and the driver limits.
+	 *
+	 * Must be called after device->driver.region, and any memory the device
+	 * was told to DMA to, have been mapped at the same IOVAs as when init()
+	 * and memcpy_start() were called.
+	 */
+	void (*attach)(struct vfio_pci_device *device);
+
 	/**
 	 * memcpy_start() - Kick off @count repeated memcpy operations from
 	 * [@src, @src + @size) to [@dst, @dst + @size).
@@ -85,6 +100,8 @@ struct vfio_pci_driver {
 
 void vfio_pci_driver_probe(struct vfio_pci_device *device);
 void vfio_pci_driver_init(struct vfio_pci_device *device);
+void vfio_pci_driver_attach(struct vfio_pci_device *device,
+			    bool memcpy_in_progress);
 void vfio_pci_driver_remove(struct vfio_pci_device *device);
 int vfio_pci_driver_memcpy(struct vfio_pci_device *device,
 			   iova_t src, iova_t dst, u64 size);
diff --git a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
index 5e65434d2318..b4be2070342f 100644
--- a/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
+++ b/tools/testing/selftests/vfio/lib/vfio_pci_driver.c
@@ -40,7 +40,8 @@ static void vfio_check_driver_op(struct vfio_pci_driver *driver, void *op,
 {
 	VFIO_ASSERT_NOT_NULL(driver->ops);
 	VFIO_ASSERT_NOT_NULL(op, "Driver has no %s()\n", op_name);
-	VFIO_ASSERT_EQ(driver->initialized, op != driver->ops->init);
+	VFIO_ASSERT_EQ(driver->initialized,
+		       op != driver->ops->init && op != driver->ops->attach);
 	VFIO_ASSERT_EQ(driver->memcpy_in_progress, op == driver->ops->memcpy_wait);
 }
 
@@ -61,6 +62,25 @@ void vfio_pci_driver_init(struct vfio_pci_device *device)
 	driver->initialized = true;
 }
 
+/*
+ * Take over @device as vfio_pci_driver_init() left it in another process, e.g.
+ * before a Live Update. Pass @memcpy_in_progress if memcpy operations were
+ * started there, to be able to wait for them with vfio_pci_driver_memcpy_wait().
+ */
+void vfio_pci_driver_attach(struct vfio_pci_device *device,
+			    bool memcpy_in_progress)
+{
+	struct vfio_pci_driver *driver = &device->driver;
+
+	VFIO_ASSERT_NOT_NULL(driver->region.vaddr);
+	VFIO_CHECK_DRIVER_OP(driver, attach);
+
+	driver->ops->attach(device);
+
+	driver->initialized = true;
+	driver->memcpy_in_progress = memcpy_in_progress;
+}
+
 void vfio_pci_driver_remove(struct vfio_pci_device *device)
 {
 	struct vfio_pci_driver *driver = &device->driver;
-- 
2.56.0.317.g454f8302e1-goog


