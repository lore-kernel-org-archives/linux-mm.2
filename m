Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BE73606A81F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LN9e0/At
Received: by kanga.kvack.org (Postfix)
	id 872696B05E3; Fri,  6 Nov 2026 19:37:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8229B6B05E6; Fri,  6 Nov 2026 19:37:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6BEDF6B05E2; Fri,  6 Nov 2026 19:37:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 39D106B05E2
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:16 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D154E160210
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:15 +0000 (UTC)
X-FDA: 85406458830.22.6C40C26
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id B979D40005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:13 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LN9e0/At";
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011833;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7u/xUqUjSpG1uHVLTmzq+uP5uQjAYFobNAgMRyNfitg=;
	b=Ip5JeNCejIWMlLazhug0HVlLifLrqHwRGVWdGc31+W7E3R2Qe6gvgTKs+wWR1Lxx6qHf7c
	DUGkws8/2mt3KLwE4Ug5Hp2/gWQJk2SLigkD8RR6HoUGfT2lxxFz7lCQd/ZAdW9JiQ1xlc
	bm+2foHKeoPEYToaMQBflsj2GTmI5c4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011833;
	b=fwnabuzAYjHGsYtkBptkZnj2abxg5JcTfHkWzdb6VmyAgkSAv76tVDlfIVtHFZ/QSXWj1d
	IEbwt59QLbP59YqK3IyykOhffv7ZThc2kpe6tkgoc8d0h8dJ6/BMhlsRkx9fjVbVXC9Rv0
	OM0TkJOlhd1LXeEt0/yzCNxEYDlvtgw=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="LN9e0/At";
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8CCE84017F;
	Sat,  7 Nov 2026 00:37:13 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011833;
	b=KQ7Pa95P+RuYFA3R/MlXuUG5Q5TMXlvSi9HyCZkGFDaxYMVDSfsOYo7+p4BCGzsxML/z
	 riiu48h7oL/qriWC3kOxA8VRK8/AN00iLh0k02dOF3mUUTTV3DqYF1ojctF+CAqgjGSiI
	 8RcoHXeDtY2QP733RJ7p+3xtgcBj6VHeI+TC85O9uk0H0O4/86RgKjnvdm7/jV+teUTmQ
	 vxJ+ACCT8gBSAq5+sxgVdMtnKgsQ/vQ1/RomkQXt5/1HIWyCjoxOZ2hsXjuhgDhYbkiMt
	 OU4y6YAvDksK4gGJx/yDOiiRzTX7VkITKUBx2Fnzg7MNnB54hka/P+PsNAMJnW3rLNg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011833;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=7u/xUqUjSpG1uHVLTmzq+uP5uQjAYFobNAgMRyNfitg=;
	b=Anb/xznNcUqNJlEFcqOxyVh6fJ37SopfHjjqNViv1hlh3sFLz67CBkEIIOxow9ni5ra1
	 7HOapqsPqrJ+WoHjm7uRrVxGHDgiMkVELPjwPMvzjUIujDkT8q310BwaAa9A9okRonEj4
	 gZPNFmEO1N0dQMC4EddH1ZtKkpV/0AobthOKFXl6Hn+atVlz5NW6kJBsRByIzu00vvuQY
	 HzS8IPea+WAKEKzZezOmOTZW9BTROhhhO8IY4sDDArVGic1wHB1FNn4GaNQ38hnuC4YK/
	 6YajYahUOl5TxQAGEEneiOkPAbfaJm4D0Eidmj+nZA5CM6xJKLQthtj2wkF2lb7UtYQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7815C1F008AB;
	Sat,  7 Nov 2026 00:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011833;
	bh=7u/xUqUjSpG1uHVLTmzq+uP5uQjAYFobNAgMRyNfitg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=LN9e0/AtB7Izb4lqha7xs8FLfETDMlx/1nrJ7pTkRXq1u+n8796yPJra24YFlq+3H
	 vrD7PybLJjSPbpQe6+n+3qysUlG3Nbyu3iiLWC3574iW++Py0jeswshs5HwfBlr9Mt
	 ZFmSxAh08jHjFZdem3eUeZqMPPCD/WKCqS1BaF9JoFUFROVo+W3zuvfEMJ+3D8XVE8
	 dTpxXj/WlrnsY85LycQuNwE2nhfatfyBC7tsPuLkcf2kEW0LKF7EhOU2G3XGR+97y0
	 VtsTIXhNAJKkbpvtW9DvrHZLicPC3uCO7bjMIi3z90JwTGcs41DlnehxcTJFfYYcXf
	 m9KoJ1oheNBMA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A5F77479E9;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:29 -0800
Subject: [PATCH RFC v3 55/88] vfio: Track device file access mode with an
 enum
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-55-8484dde66a7e@google.com>
References: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
In-Reply-To: <20261106-gmem-alternative-providers-v3-0-8484dde66a7e@google.com>
To: Alexey Kardashevskiy <aik@amd.com>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Christian Brauner <brauner@kernel.org>, 
 David Hildenbrand <david@kernel.org>, David Woodhouse <dwmw2@infradead.org>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jianxiong Gao <jxgao@google.com>, 
 John Starks <John.Starks@microsoft.com>, 
 Michael Roth <michael.roth@amd.com>, Paolo Bonzini <pbonzini@redhat.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Vishal Annapurve <vannapurve@google.com>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=5176;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=OPzfI8FY9YTnY7U//Qo2HO1R07AW0TxEMrDt75CQipU=;
 b=yxGBfLn330m/QlZKxV56D9+INpmu/vb92BX3fIJN1BHK07X4RoQNHQmNHqFgxcPEyc9f3OrFI
 TITTtiAfEvkBiWVgqH/0/MljlVFSh1dt4fWyaeiRAMfq00Gn4JmxuQ3
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 19mhgu7uqyp31n4ckf3h17nji79rdk11
X-Rspamd-Queue-Id: B979D40005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011833-598358
X-HE-Meta: U2FsdGVkX1932I7dBHyZzduYEM00UsGirbCBtbzJJD7S2zkgZ29SnRQTnEs2dOzeNS1h+6dNaWvEJBssS36id/uz58XUq4F8YTE5ckTpwhoziVj8WDn3V4QZ745tTmQPE6V8uiG63/8uWojRDtsMUdpxMnv9H8WdhkGv8k8AyWfndFj1Ea/Y/q8XmbxxdwJGZ/gW4mtIJ+eLqOudF6Tf30z2q5QVqFFXWslD/mW1iAPmWtr0VA/CLkS3+1VRGEZ9+apR9UKj2ZCAWsAb/CQoKxrJb2jChTcJ1DfM9SRNmFUSs0QRLyNL2hMDYW2N9dlcQxWxzpLWjsnY5QxTdgNj2bl2h02ALS7/ogWFuR+NAoCe2wLy8/q+IjA/uxbkILJsaJx1G+KF/ClQcBgykmpVClQG5xNmbKYkmDTyx7G80KgB6foUWL5LKF/C8UPBZnct9iWN49YzyLkHhVaNWwCy62gT42rXx66i1JH0BJTd/Nk9lvAXuNnXLQg/IuJGGDuEHMXboxViD8R/ljv3nrhC1XOTb5rUCWMJiUOkEU6Wl+3GjhKds8/ieqKycvhRJIOmv7Q8sCW+dVUg2OgghrbExsEVcc1s6ucUiZixLMj63rUs4FE6f6/DFQeHnxL4F3quqIrniW7zbBZPAKQbERqqw5nLZWMsCG8sP9qrI3xgCj5PKLh4RZX5hRKcE+YC5tz5DL34jp360cQIhNvB4n/StSxeIHzO6McssxqwN7iXkuHlPwc8QSt19fgixhOAZ9T6cJTqP03Bctm7kNeOPG4CFIPUrkaRRd1jYalfedgP3qfZdxlXBYVUcxem3/mALBQBFDE5fHR9CrDeIf8gLscrGSCBS7G8NoYCWDTDfvAClVCCVPD5bJszqlHKD2lZSgmZo8yOw85R0uc8xkEhmMyNnz2qB6epGkdCx22QodxUJDr0FqUCh1MXq4O8i2XAoP8EMnZ1qYFqJNVoApAwynv
 KGtHElV2
 MFVRDv8HDN699lGK+SuUU6SiihjJYzccOrqLnmAIrQl3E1vqsG/kJuJFY7Ciy/r/O4tydethdHBuW3d6nMxuoKn8b682T4N262ny7SJ2wJ2EYrz5l5NweK2NGLVaTbyFn1/xFt4X3A3S/Ac5nQt1bzQbY22s4e2f/2qjr6KqRZnqr9Z+VHt2WJvKKG4Xmw6OpY2IdItasprzPbUZmf8FGLO+Mujw5vzbX3oRifsilNaIxXClxrWcOQqRYgD5PTAK+/uIx6cg4Cz9XO2EZRnDuH/zWUNSkpZU8FbPzaWYgU/niIscqqSKILDP4VLuPqAW/pJEWoqI7XKz1T3KGHL1Rv3v6JkWQnBCNuNbCRJ0WaQ+GHlxP2RFLmRHaXCsI/0PBuGJOKu6upG8pzYm7dB1Aj5kxoMISakan6Of9fuy19KpQduMUEQPlm/XVVK172kjr/k4/x7/cCM/IzIQXhgWDITajawTEoNA7tr2bMfRUpUvjqP8JZx4HfxZZpoUCd9ISKnpE+GxlhYV73H1QU+gclLI2Wf+x88ODjgNFArMocy1pkJGAcA1OU+FzlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Device file operations currently track whether access has been granted
using a boolean flag, assuming that binding a device always unlocks both
control-plane operations and direct region access simultaneously.

Upcoming support for control-only device bindings requires distinguishing
unbound descriptors from descriptors bound with restricted vs. full
access, without introducing multiple flags that could get out of sync or
represent invalid combinations under lockless release-acquire ordering.

Replace the boolean flag with an enum representing the access mode so
that the entire access state continues to be published and read as a
single release-acquire value.

No functional change intended.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 drivers/vfio/device_cdev.c | 8 ++++----
 drivers/vfio/group.c       | 2 +-
 drivers/vfio/vfio.h        | 7 ++++++-
 drivers/vfio/vfio_main.c   | 8 ++++----
 4 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index c1c26d7a9aec9..19be3947fc74a 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -125,7 +125,7 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
 
 	mutex_lock(&device->dev_set->lock);
 	/* one device cannot be bound twice */
-	if (df->access_granted) {
+	if (df->access_mode != VFIO_DF_ACCESS_NONE) {
 		ret = -EINVAL;
 		goto out_unlock;
 	}
@@ -163,7 +163,7 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
 	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
 	 * read/write/mmap
 	 */
-	smp_store_release(&df->access_granted, true);
+	smp_store_release(&df->access_mode, VFIO_DF_ACCESS_FULL);
 	mutex_unlock(&device->dev_set->lock);
 	return 0;
 
@@ -185,10 +185,10 @@ void vfio_df_unbind_iommufd(struct vfio_device_file *df)
 
 	/*
 	 * In the time of close, there is no contention with another one
-	 * changing this flag.  So read df->access_granted without lock
+	 * changing this mode.  So read df->access_mode without lock
 	 * and no smp_load_acquire() is ok.
 	 */
-	if (!df->access_granted)
+	if (df->access_mode == VFIO_DF_ACCESS_NONE)
 		return;
 
 	mutex_lock(&device->dev_set->lock);
diff --git a/drivers/vfio/group.c b/drivers/vfio/group.c
index 185f359f75d38..0a33e0e025bd8 100644
--- a/drivers/vfio/group.c
+++ b/drivers/vfio/group.c
@@ -217,7 +217,7 @@ static int vfio_df_group_open(struct vfio_device_file *df)
 	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
 	 * read/write/mmap and vfio_file_has_device_access()
 	 */
-	smp_store_release(&df->access_granted, true);
+	smp_store_release(&df->access_mode, VFIO_DF_ACCESS_FULL);
 
 	mutex_unlock(&device->dev_set->lock);
 	mutex_unlock(&device->group->group_lock);
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index 2eeb526a8da58..af2b8158b40c0 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -16,11 +16,16 @@ struct iommufd_ctx;
 struct iommu_group;
 struct vfio_container;
 
+enum vfio_df_access_mode {
+	VFIO_DF_ACCESS_NONE = 0,
+	VFIO_DF_ACCESS_FULL,
+};
+
 struct vfio_device_file {
 	struct vfio_device *device;
 	struct vfio_group *group;
 
-	u8 access_granted;
+	enum vfio_df_access_mode access_mode;
 	u32 devid; /* only valid when iommufd is valid */
 	spinlock_t kvm_ref_lock; /* protect kvm field */
 	struct file *kvm;
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index ea8e6cc13c457..fe126e137d5ca 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1349,7 +1349,7 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 		return vfio_df_ioctl_bind_iommufd(df, uptr);
 
 	/* Paired with smp_store_release() following vfio_df_open() */
-	if (!smp_load_acquire(&df->access_granted))
+	if (smp_load_acquire(&df->access_mode) == VFIO_DF_ACCESS_NONE)
 		return -EINVAL;
 
 	ret = vfio_device_pm_runtime_get(device);
@@ -1397,7 +1397,7 @@ static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
 	struct vfio_device *device = df->device;
 
 	/* Paired with smp_store_release() following vfio_df_open() */
-	if (!smp_load_acquire(&df->access_granted))
+	if (smp_load_acquire(&df->access_mode) == VFIO_DF_ACCESS_NONE)
 		return -EINVAL;
 
 	if (unlikely(!device->ops->read))
@@ -1414,7 +1414,7 @@ static ssize_t vfio_device_fops_write(struct file *filep,
 	struct vfio_device *device = df->device;
 
 	/* Paired with smp_store_release() following vfio_df_open() */
-	if (!smp_load_acquire(&df->access_granted))
+	if (smp_load_acquire(&df->access_mode) == VFIO_DF_ACCESS_NONE)
 		return -EINVAL;
 
 	if (unlikely(!device->ops->write))
@@ -1429,7 +1429,7 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 	struct vfio_device *device = df->device;
 
 	/* Paired with smp_store_release() following vfio_df_open() */
-	if (!smp_load_acquire(&df->access_granted))
+	if (smp_load_acquire(&df->access_mode) == VFIO_DF_ACCESS_NONE)
 		return -EINVAL;
 
 	if (unlikely(!device->ops->mmap))

-- 
2.56.0.455.g6c5a503b38-goog



