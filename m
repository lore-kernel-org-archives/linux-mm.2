Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB899C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 11:36:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD5FC6B00C7; Tue, 15 Sep 2026 07:36:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CADF66B00C8; Tue, 15 Sep 2026 07:36:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEC3E6B00C9; Tue, 15 Sep 2026 07:36:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F59F6B00C7
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 07:36:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 11401803A3
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:36:01 +0000 (UTC)
X-FDA: 85215792522.03.8F0E43E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4A923A0007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 11:35:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DP7k+2oY;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789472159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b40qx/awPhHY3pAbyOLJ2VCQCA5LCLOxDhc9IZ5eVmE=;
	b=zB/Xv02kvgP1QANE1ExjNy5l8BSgCChQLHHKIaFhBn2isWVsYEmMaWGxDQFIQa3gAGnI5V
	svAJSYa0qmgPmTh9dn5y4zDkhy0MfuA2lhlteFPZDocLOWHhm6ZNlnayZg1UMRgfvmSCUg
	AMKDi3kXCLdOKWmvV9H5Dh8VxZ929mg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DP7k+2oY;
	spf=pass (imf25.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789472159;
	b=Ocep8aAlhAfxpLPKG0nuiHWh75FOf5nfuWcxf5OPLlTmnVoKyTYkxe14pal5htz2MyD6eJ
	6+MvY/7YUztYqqTK+UwZc642g19ETJL64HnXn7Ag+Cxw34Q2ry820TmB2QYSueJvkz9NU4
	OAki2dBgEBk69AMsHtmH7dkXMr8KQ3A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 95CAD419C6;
	Tue, 15 Sep 2026 11:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B05B1F000FF;
	Tue, 15 Sep 2026 11:35:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789472158;
	bh=b40qx/awPhHY3pAbyOLJ2VCQCA5LCLOxDhc9IZ5eVmE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=DP7k+2oYU08PDg3XHLYvBCrc74ArLylq263ZQfhfXbqRVkmDQErCOMCCjVwzRS3TV
	 Y8Y1vhMdhR6mX1rzdLqcAsmQNs12N3hdTVztl8RasOi+yrl66kgtJvAm30HiqkZulb
	 BeZJvaqfhTtzMk7k9vathecezVTk0f7HRyPRJBoxuaSPdxLiJQMLNsbQRaHiPb0ydM
	 Bs/kN8QurhjzxM80pFu9PHszrjXHegO9Dn6LZ3pRg5VWri7b/KneuctABvHx5t6aU8
	 tZLPUAdsUnZNPuONncunNV8jM+2yLhEhGWV0UDmSzPkb9+7dEf6jOyeVoYut8bPYY5
	 6Fs/9ju++IrEA==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 15 Sep 2026 13:31:22 +0200
Subject: [PATCH RFC POC 36/50] nitro_enclaves: install the enclave
 descriptor when the ioctl returns
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-work-fd-reserve-unify-folded-v1-36-4d5217d6b246@kernel.org>
References: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
In-Reply-To: <20260915-work-fd-reserve-unify-folded-v1-0-4d5217d6b246@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Jann Horn <jannh@google.com>, 
 Jan Kara <jack@suse.cz>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Oleg Nesterov <oleg@redhat.com>, linux-alpha@vger.kernel.org, 
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 linux-csky@vger.kernel.org, linux-hexagon@vger.kernel.org, 
 linux-m68k@lists.linux-m68k.org, linux-mips@vger.kernel.org, 
 linux-openrisc@vger.kernel.org, linux-parisc@vger.kernel.org, 
 linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, 
 linux-um@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, 
 io-uring@vger.kernel.org, netdev@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-gpio@vger.kernel.org, 
 linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 bpf@vger.kernel.org, David Airlie <airlied@redhat.com>, 
 virtualization@lists.linux.dev, kvm@vger.kernel.org, 
 kexec@lists.infradead.org, linux-hyperv@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=openpgp-sha256; l=2840; i=brauner@kernel.org;
 h=from:subject:message-id; bh=06X+neGC1JeQjfUMZrHZWaV7oELS9OsBJ6UQD7zSi4E=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSt1Knzubs1YsvpZZZH3i8+78BV7P4vtpYxKWmuZeMPN
 v7juhcdO0pZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACYi/YThf2b/jhn+T+e6nmr7
 eXfahbUvovRN4zg2RHUHPFri9vTunR6G/1ElTBHnt53eUxYocDY8j1mnxvWvpfIKaanlW1376r2
 dWQE=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4A923A0007
X-Stat-Signature: hhmq5zwou4waubiehdxh79ma697zon7y
X-Rspam-User: 
X-HE-Tag: 1789472159-99630
X-HE-Meta: U2FsdGVkX1/BF+eZ+XO2NwJmBexyQE/zrhl65Coka9xrXxVD5x3I7FBaW1pXHTgglfFpgNRX1kBSsCCFvKSPvRaSE7zURgICeVtstO5sRFPJCqszm7jknmeQTpDr/wfoBJm04b/NcrE1LH+b3Fdy8gTjfFxgfA3a8o8CVOJ7SL5pxSQU6jwsg9jZ6vMGHOeUpJLokCYwhkROvU0ee+M0DWTGQsdEmaLXkSLrhBbYCxvHdv/76xAZmQgfc4xk3pAsTNscuSAhnQdkWpxu282O0KJZ/yNOHkDB6DIlhMU0bOIEAXDheVoK6HH1rLGc7pdXC8ujJDl4HHepNEm0K/A7aTburntHIx/2lte0S+UsJqlXiMJ/1WfGPL82h8BiiS9w8kBkCAMy6ay/tnMBsEIPQxX5Mmn0sS86WqiygIIc2GJdycxSn6hHsF/kL4csjyVn+QT4GqB89qoiMN2m4Qcs/GXWr0JYQqt39sINVOlCRH8Z15biS8ZBuMDLng+WsXNBSzPJUJx5Ra59Wp3RFfPtQGvm5PLT0j1NcnqzESZ6w05PdKkptA/jBvhGTBywh8fsoZ5Zx5cNRpCt4tU2C6vqYjksi7jwqBswWcC8n2+NqdetUTAIBux4jUbWeDspZAKg+69rEjRFG3y4BcUy/5nazZG+VLhhpEXX4ML4MpyfmVn6ONCLGKZV6n2g9L0DV59o2zdUeAs7q/51lSeRbHb7Kd8eq7VrCPFG4XArgwHPF/NPQnh30/H7/YEd2tIbbraHZF42bd5kadG0KDdtAzqffc++FDYeYFzjIJbORm/+ZZt1Q4LWyvfhqZCziT6dGgn8PtmaPgV1gXk8ESMVF+HeLAGJiZqGweQapOGEl42mgddVk11HKPj4mK0/2Fc0rZnqPaPDUUpWu4drxXfigQAZuKkx9NSdbhg1iQAWm46yIRsa1zI9yudv3VUhjpGL86J3pqt40D4krEfy1CF95SM
 SVPkGEfm
 gjLp2NRu5mdz1nRi6WOAeNiaLwjtoPewpr0lQCoRmXZCFvncis79Emcvl/OffhYGpBzVzMwUJQBrUjbj2R2LvmtqJ9AOo2LjXUwd5w2mvBRoPNZtNlSqDpkt6KEetoRhG2/KDJj27mZQvQe/rXp3PfEYxgwInvCYDkF50d+E5R6pXFJvxXfHNJpBZGBC2WmQ30tU8zztKMOTQPI6aAxAp058p9icNg7eEr9YFhtGmQ4bF1de38nZb/f0qBuqx3Ou6T0atyrxO1fWOypwATZAJtH4nrPafyJKNIfHiFlwYspB4c7Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Rely on the fd exit path machinery.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
 drivers/virt/nitro_enclaves/ne_misc_dev.c | 33 ++++++++++++-------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
index c91300a73f50..93c3f00f5443 100644
--- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
+++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
@@ -1589,7 +1589,7 @@ static const struct file_operations ne_enclave_fops = {
 static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 __user *slot_uid)
 {
 	struct ne_pci_dev_cmd_reply cmd_reply = {};
-	int enclave_fd = -1;
+	const struct fd_slot *enclave_fd = NULL;
 	struct file *enclave_file = NULL;
 	unsigned int i = 0;
 	struct ne_enclave *ne_enclave = NULL;
@@ -1647,9 +1647,9 @@ static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 __user *slot_ui
 		goto free_cpumask;
 	}
 
-	enclave_fd = get_unused_fd_flags(O_CLOEXEC);
-	if (enclave_fd < 0) {
-		rc = enclave_fd;
+	enclave_fd = fd_prepare(O_CLOEXEC);
+	if (IS_ERR(enclave_fd)) {
+		rc = PTR_ERR(enclave_fd);
 
 		dev_err_ratelimited(ne_misc_dev.this_device,
 				    "Error in getting unused fd [rc=%d]\n", rc);
@@ -1664,7 +1664,7 @@ static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 __user *slot_ui
 		dev_err_ratelimited(ne_misc_dev.this_device,
 				    "Error in anon inode get file [rc=%d]\n", rc);
 
-		goto put_fd;
+		goto free_cpumask;
 	}
 
 	rc = ne_do_request(pdev, SLOT_ALLOC,
@@ -1688,27 +1688,20 @@ static int ne_create_vm_ioctl(struct ne_pci_dev *ne_pci_dev, u64 __user *slot_ui
 
 	list_add(&ne_enclave->enclave_list_entry, &ne_pci_dev->enclaves_list);
 
-	if (copy_to_user(slot_uid, &ne_enclave->slot_uid, sizeof(ne_enclave->slot_uid))) {
-		/*
-		 * As we're holding the only reference to 'enclave_file', fput()
-		 * will call ne_enclave_release() which will do a proper cleanup
-		 * of all so far allocated resources, leaving only the unused fd
-		 * for us to free.
-		 */
-		fput(enclave_file);
-		put_unused_fd(enclave_fd);
+	fd_stage(enclave_fd, enclave_file);
 
+	/*
+	 * The failed ioctl drops the descriptor and with it the only reference
+	 * to 'enclave_file', so ne_enclave_release() does a proper cleanup of
+	 * all so far allocated resources.
+	 */
+	if (copy_to_user(slot_uid, &ne_enclave->slot_uid, sizeof(ne_enclave->slot_uid)))
 		return -EFAULT;
-	}
-
-	fd_install(enclave_fd, enclave_file);
 
-	return enclave_fd;
+	return fd_prepare_fd(enclave_fd);
 
 put_file:
 	fput(enclave_file);
-put_fd:
-	put_unused_fd(enclave_fd);
 free_cpumask:
 	free_cpumask_var(ne_enclave->vcpu_ids);
 	for (i = 0; i < ne_enclave->nr_parent_vm_cores; i++)

-- 
2.53.0


