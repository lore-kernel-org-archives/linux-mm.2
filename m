Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B915B606A800
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m7pfeM3C
Received: by kanga.kvack.org (Postfix)
	id 4029B6B05EB; Fri,  6 Nov 2026 19:37:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 38D7D6B05EF; Fri,  6 Nov 2026 19:37:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 203FE6B05EC; Fri,  6 Nov 2026 19:37:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DEB3A6B05EC
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8B9FAA7B98
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:17 +0000 (UTC)
X-FDA: 85406458914.01.AF4D1E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 87C2D100005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:15 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m7pfeM3C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011835;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6wRWk8SUsr9o1299jU6sg0RVdITVU5jt1ij/qu8YelM=;
	b=m5JdhG4jcum30h4naius1PzbtQFYAM53hzENsnXukn9sc+yHjOcjQMasaHstx0uI3ybf7g
	TZ1RDgpwHEiOmGkvhKLNjUwzH2oUvwDJgTb0OCd0yFn/Br8gAFV2Io+GFUDXzLo5N/QbRf
	FGC5S7ki832anZ8z1UIh74+pqSQWAyk=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m7pfeM3C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011835;
	b=uJv4Jd1aRhgw/X/RcHywX9JXrOTVvOF+zaJhuj7sE+TIvTZmVRPdTSAiHDRwD2l0eNPUUA
	mHXXHprDFSsxJMWPldFYh3h26Qd0BFNz3qo/vm4rCMAoOO9ewBzqPCm86FkTosH6hyPmNj
	89HijYxhspF1aK//tuqqAaX6kH24eaA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 51F7C434C2;
	Sat,  7 Nov 2026 00:37:15 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011835;
	b=eRqTQeigCoaKiRVjlMS2ezJqZZ2i8h6Gnmj0G4z/b1+WKmqVNQJLrViSobMypoA8yzf3
	 b8Ylf/St/zj+Zp9IAfRNBBtLE8b9U+GhFugUvhrC1/MYDlH+HfXhfZ3xlJ8OimcefKJOn
	 yDqzjqtEXJZFAnWWIRQYqiQAafHA1Nspx6peTBpv0yBEO/oUz6rsjacB3FDkF7rTziMB/
	 bRqIHHMt6JXrLRbO+Wf9uio0vPZF0a1EotrxR/Bgzk6kECxPfD/+q2kODNDOHrYiu3j5J
	 gm62De0rkPjJ8tSorgGLRZscJ6cfjBk/+VUCCwsPz6qa6XsObqGd1gBqnViquUL5rOw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011835;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=6wRWk8SUsr9o1299jU6sg0RVdITVU5jt1ij/qu8YelM=;
	b=11B0eKtnXpQ46KweTrhMI73MtREzeZ5GBPniIzD+evRK/+Oh07SUMHkE8ScMr77uxyvi
	 jBa+oWCuzZHAw500XC49Y54TZbGgh/zdrdmtnmxsEKKRDBfKDWdOYoR+UowMHHUJDrw7X
	 3k6KkOVVqNU9RbbqEszEoKp86DZ3PeTbdWHyVMZsh+cXMXxiW9S98Oz5kYhxPvmvDOxme
	 rgwK/FSlQZYogVqjzNg5n1D4NptlYqooFWf+KhHiuViPozKMD2YTKWoNf9lrBpaPfW6S6
	 +HthF2lW7bMqXiRG7mFS99QdCBsBSRPrQa/bWyhq20pAeOS4ozq4YsB1PkKaL1W+e1w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 071BC1F008BF;
	Sat,  7 Nov 2026 00:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011835;
	bh=6wRWk8SUsr9o1299jU6sg0RVdITVU5jt1ij/qu8YelM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=m7pfeM3C3SU1kVsS1r8Nr/gcGkalVgvMdwOUaCq6ReMQaCIIBN4Lb6UHEUZnIhBnc
	 pnLNuC/PNu7xM9wjGdesx/gJ+ZUZneqVnDnhT/cj5DDPemXwP4dsQ9ksOBZTX3jgR8
	 7CGv5wjIxO2vPIAuGupr0ds49QNSNOJh/u+rqViv0dJ7clvve8RUx8Aq2jCEfvk7tV
	 WMA+U/Pw/ag9/wxo1AApshRgUVqOYSJkIgC0TgEDi5PW3CgzPn90xSnwnJMBIw6VFj
	 oORdSFzFoLsZjl5Hft0JEoHtZQFC+7CBst7zh6/2Fr3PdikfiMpT8Fiznn1RU91DT/
	 r4kjmASLzLyhQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B62C2479ED;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:30 -0800
Subject: [PATCH RFC v3 56/88] vfio: Support VFIO_DEVICE_BIND_FLAG_CTRL_ONLY
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-56-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=15060;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=nA9E5PspOX358dTaDE5Jo0Ok53XvF21+z9RrLI2Cs9g=;
 b=d1rn3Q0Z089HvpgCmEW5F9Urqt89//NRRDqKud9/JtnihqBE7GnI8YxYIAT9fHZKukfwpcu2O
 J3SyCgk5nK0CRne/vbSjkYx6ezahtmdtCww/JB9IjHSpdbXDS1yV0oi
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 87C2D100005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bkkrgfosxech3j9a5c6f5nkpc7xchezh
X-HE-Tag: 1794011835-869122
X-HE-Meta: U2FsdGVkX18Nxt/Jfyn55DBmNKM/JHTO6lp9VsT/J/RdTnXdDp7yNoroQFldrE1HI4ca7/ou+OUrL81zpInnRBu31So+MOXxVtCE73zLEgMwhHhuB6oL7lR6UsY9KvN1z5BXbtYBa6mTMjz0VooU1SSw+ZtvkH0Pu8M+Kh6hUDxJvw0TK3HOJ9RgBQTWC2mOa+spAIUe0WCOAfA+pyyJUWuRYvf4FxeU9DaARM7cnS4ECaoF3GQBX/HpjBKD5NEZsOk9b3s8+kItfxORHV77nT9oAkd5+WLXXVO8jhmQDTa5Y8tV3Yj3z86yVNjcMoNu2uuaeQMC6Bk7QdNfQ9eBtfP+8ObXNa6BKcJ/b8o9vgxnekEyaYsviygofaZsQiyij43bIXeFpDI8V7DfOeVpEM5Un7WmwFToO5tzdsl/fcdMPbXI7JxpoJtnSnCPJKSPkAGWuBYIWzzHkIjjYxWDn63R6nmLnmPC90hrLxBRvdqf+Hde1VaWTXPPq9HSLVg8xsw4XG4yKeKk4ezHkgpMnMJx3qTdN8+wvZULYYcZNkX7P81nZMhj5BCVaZcBU5dB+MDALyl1fSUF892GPDwDuLddtigYUKSFx/YCRe34DF3AyB+opP1kjoGDOgY9D3H0g/8RIPlHCp9D9fSOt8n00chRfaQQy2EJKqJt6LmeZJiuNTFRp6pfed7LvIPQ9wtm14vnXdpV+D18/H7L1JPORQgSldE7RlXkHZq9w7RYHYANd1XkyA+sJicrDc5xhx3WyBFZWtCFHzd6/TCNhmkbjTBNUCoKUO6uevu3/WbPdy6i8+460bjtYT091l0T2eCcNnVqaEKdMWOrRdbQW4khVkdIt+4od9bVBubbKq8kr6I1AoXq/8oluiVEdKhYZGBMUeqA5LmhzvM/gTdPbq8kHn/wjzBHRrwm5L40dH4/hhNqKAsId3RwuDeD4DJTU8+od0j51XNAUHrNXYX8+4Q
 4zP4t+H8
 N55PBGmIuWtBafCKm1GMfOGNt6A6RhfhCX0kWpsKkcLGuFO6Qjiw2X30mpLGKUnlkIaEStYozlrUyrsjln8zn0EjRBPS80itMwo1NwV3eN47wepD/a3Xib4i0JRt3CxRWwej6ITPkX3IR51NYkU3kM3mC99R1V/ue4D0x0WCwMD1qc+bsZQZQ8nhQ4xs3HsX7RY2fl+NSS6iqLXMf1dDbIJWmhgpqaBSldxid8Gyls9PrvmPQAgJRlR9HixJkoQ7lsgVhporskBlyPid4j74k+8JeLmYkazw6aq6aMS3f7vluSaxFMx92u9wgpmdxatydhV/TkKH6peZLgOJVKR150iOOfqcRGUh4J3bri5ntBjZ8RbP9FpMF0PNAsuT+w9/DKSuCMAVPeer33Cggexr3koAqP5kmFAV7uA2Nor09iA+qm97OsuToieQY2UzAa73900pMlY4L6xf4JvGJ51Ihug+OxRbu49C9u8X7yCy60oPABd6S6OaNMJnrYbtGaYQ0Klyr6IPUqxF3Jhdr+XiFdSb5hS06elNan7JMthiETYXWKYkfPOd6RsL6pGCZrUEjBu9DkUwmyymTQTRaK3X6t/XPBF1I1qHbhdkpIso2TyhlClg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

In preparation for attaching a VFIO device descriptor to guest_memfd,
mappable device BAR accesses must be mediated exclusively through
guest_memfd so they obey guest_memfd's per-page shared and private
memory attribute tracking and revocation synchronization. In
confidential computing VMs, converting device pages to private assigns
the physical BAR frames to the guest in hardware protection tables
(such as RMP or GPT). If host userspace could bypass guest_memfd via
direct VFIO reads, writes, memory mappings, dma-buf exports, or
ioeventfds, host accesses to private device pages could trigger host
hardware protection faults and crash the host.

An alternative would be to override the file operations table on the
open descriptor to strip non-control handlers, or to block region access
later at guest_memfd attachment time. However, overriding file
operations on an open file is racy because VFS caches capability flags
at open time and dispatches file operations without synchronizing
against pointer updates, and deferring the restriction until attachment
races with concurrent memory mappings, reads, writes, or exports on an
already-enabled descriptor.

Instead, introduce VFIO_DEVICE_BIND_FLAG_CTRL_ONLY for
VFIO_DEVICE_BIND_IOMMUFD to restrict the bound device descriptor as soon
as the device is enabled for use by the bind ioctl, avoiding any race
window:

- Unconditionally disable memory mappings (mmap) on the descriptor with
  -EOPNOTSUPP, as memory mappings of BAR regions belong to guest_memfd.
- Add an is_ctrl_plane callback to struct vfio_device_ops to query
  whether a given file offset belongs to the control plane.
- For descriptors bound with VFIO_DEVICE_BIND_FLAG_CTRL_ONLY, gate
  direct reads and writes using is_ctrl_plane: permit reads and writes
  to control-plane regions (such as PCI configuration space) on the
  VFIO descriptor, while rejecting reads and writes to data-plane
  regions (mappable MMIO BARs) with -EINVAL. This preserves
  control-plane register configuration and virtualization outside
  guest_memfd's filemap invalidation lock while guaranteeing data-plane
  isolation.
- Disable BAR side-channel exports (ioeventfd, dma-buf and graphics plane
  export, live migration, and DMA logging) with -EOPNOTSUPP.

Control-plane ioctls for IOMMU page table management, capability
discovery, interrupt configuration, resets, power management, VF token
configuration, and bus-master control remain permitted via the VFIO
descriptor because none of them expose arbitrary BAR memory to
userspace:

- Capability discovery, IOMMU attachment, VF token setup, and bus-master
  control operate only on host metadata, IOMMU state, or PCI
  configuration space rather than BAR MMIO pages.
- Interrupt configuration is mediated by the host kernel, and any BAR
  pages backing hardware MSI-X tables must remain shared rather than
  private so host-managed interrupt updates never touch private frames.
- Device resets and power-state transitions do not grant userspace BAR
  access and coordinate with guest_memfd revocation before changing
  hardware state once attached.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 drivers/vfio/device_cdev.c       |   9 +++-
 drivers/vfio/pci/vfio_pci.c      |   1 +
 drivers/vfio/pci/vfio_pci_core.c |  13 +++++
 drivers/vfio/vfio.h              |   1 +
 drivers/vfio/vfio_main.c         | 105 ++++++++++++++++++++++++++++++++++-----
 include/linux/vfio.h             |   2 +
 include/linux/vfio_pci_core.h    |   1 +
 include/uapi/linux/vfio.h        |   7 +++
 8 files changed, 125 insertions(+), 14 deletions(-)

diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
index 19be3947fc74a..e5b04e531ea97 100644
--- a/drivers/vfio/device_cdev.c
+++ b/drivers/vfio/device_cdev.c
@@ -92,7 +92,9 @@ static int vfio_df_check_token(struct vfio_device *device,
 long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
 				struct vfio_device_bind_iommufd __user *arg)
 {
-	const u32 VALID_FLAGS = VFIO_DEVICE_BIND_FLAG_TOKEN;
+	const u32 VALID_FLAGS = VFIO_DEVICE_BIND_FLAG_TOKEN |
+				VFIO_DEVICE_BIND_FLAG_CTRL_ONLY;
+	enum vfio_df_access_mode access_mode;
 	struct vfio_device *device = df->device;
 	struct vfio_device_bind_iommufd bind;
 	unsigned long minsz;
@@ -159,11 +161,14 @@ long vfio_df_ioctl_bind_iommufd(struct vfio_device_file *df,
 		goto out_close_device;
 
 	device->cdev_opened = true;
+	access_mode = (bind.flags & VFIO_DEVICE_BIND_FLAG_CTRL_ONLY) ?
+			      VFIO_DF_ACCESS_CTRL_ONLY :
+			      VFIO_DF_ACCESS_FULL;
 	/*
 	 * Paired with smp_load_acquire() in vfio_device_fops::ioctl/
 	 * read/write/mmap
 	 */
-	smp_store_release(&df->access_mode, VFIO_DF_ACCESS_FULL);
+	smp_store_release(&df->access_mode, access_mode);
 	mutex_unlock(&device->dev_set->lock);
 	return 0;
 
diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
index 830369ff878db..3dc232ee65491 100644
--- a/drivers/vfio/pci/vfio_pci.c
+++ b/drivers/vfio/pci/vfio_pci.c
@@ -155,6 +155,7 @@ static const struct vfio_device_ops vfio_pci_ops = {
 	.ioctl		= vfio_pci_core_ioctl,
 	.get_region_info_caps = vfio_pci_ioctl_get_region_info,
 	.device_feature = vfio_pci_core_ioctl_feature,
+	.is_ctrl_plane	= vfio_pci_core_is_ctrl_plane,
 	.read		= vfio_pci_core_read,
 	.write		= vfio_pci_core_write,
 	.mmap		= vfio_pci_core_mmap,
diff --git a/drivers/vfio/pci/vfio_pci_core.c b/drivers/vfio/pci/vfio_pci_core.c
index 6757054e9d875..907e6ab024acd 100644
--- a/drivers/vfio/pci/vfio_pci_core.c
+++ b/drivers/vfio/pci/vfio_pci_core.c
@@ -1680,6 +1680,19 @@ static ssize_t vfio_pci_rw(struct vfio_pci_core_device *vdev, char __user *buf,
 	return ret;
 }
 
+bool vfio_pci_core_is_ctrl_plane(struct vfio_device *core_vdev, loff_t ppos)
+{
+	struct vfio_pci_core_device *vdev =
+		container_of(core_vdev, struct vfio_pci_core_device, vdev);
+	unsigned int index = VFIO_PCI_OFFSET_TO_INDEX(ppos);
+
+	if (index < PCI_STD_NUM_BARS && vdev->bar_mmap_supported[index])
+		return false;
+
+	return true;
+}
+EXPORT_SYMBOL_GPL(vfio_pci_core_is_ctrl_plane);
+
 ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 		size_t count, loff_t *ppos)
 {
diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
index af2b8158b40c0..62c5cbb77a899 100644
--- a/drivers/vfio/vfio.h
+++ b/drivers/vfio/vfio.h
@@ -18,6 +18,7 @@ struct vfio_container;
 
 enum vfio_df_access_mode {
 	VFIO_DF_ACCESS_NONE = 0,
+	VFIO_DF_ACCESS_CTRL_ONLY,
 	VFIO_DF_ACCESS_FULL,
 };
 
diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index fe126e137d5ca..8734ae9d06c2b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1231,8 +1231,23 @@ vfio_ioctl_device_feature_logging_report(struct vfio_device *device,
 	return ret;
 }
 
+static bool vfio_feature_ctrl_only_allowed(u32 flags)
+{
+	switch (flags & VFIO_DEVICE_FEATURE_MASK) {
+	case VFIO_DEVICE_FEATURE_PCI_VF_TOKEN:
+	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY:
+	case VFIO_DEVICE_FEATURE_LOW_POWER_ENTRY_WITH_WAKEUP:
+	case VFIO_DEVICE_FEATURE_LOW_POWER_EXIT:
+	case VFIO_DEVICE_FEATURE_BUS_MASTER:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int vfio_ioctl_device_feature(struct vfio_device *device,
-				     struct vfio_device_feature __user *arg)
+				     struct vfio_device_feature __user *arg,
+				     bool ctrl_only)
 {
 	size_t minsz = offsetofend(struct vfio_device_feature, flags);
 	struct vfio_device_feature feature;
@@ -1255,6 +1270,9 @@ static int vfio_ioctl_device_feature(struct vfio_device *device,
 	    (feature.flags & VFIO_DEVICE_FEATURE_GET))
 		return -EINVAL;
 
+	if (ctrl_only && !vfio_feature_ctrl_only_allowed(feature.flags))
+		return -EOPNOTSUPP;
+
 	switch (feature.flags & VFIO_DEVICE_FEATURE_MASK) {
 	case VFIO_DEVICE_FEATURE_MIGRATION:
 		return vfio_ioctl_device_feature_migration(
@@ -1337,20 +1355,63 @@ static long vfio_get_region_info(struct vfio_device *device,
 	return ret;
 }
 
+static bool vfio_ioctl_ctrl_only_allowed(unsigned int cmd)
+{
+	switch (cmd) {
+	case VFIO_DEVICE_ATTACH_IOMMUFD_PT:
+	case VFIO_DEVICE_DETACH_IOMMUFD_PT:
+	case VFIO_DEVICE_FEATURE:
+	case VFIO_DEVICE_GET_INFO:
+	case VFIO_DEVICE_GET_REGION_INFO:
+	case VFIO_DEVICE_GET_IRQ_INFO:
+	case VFIO_DEVICE_SET_IRQS:
+	case VFIO_DEVICE_RESET:
+	case VFIO_DEVICE_GET_PCI_HOT_RESET_INFO:
+	case VFIO_DEVICE_PCI_HOT_RESET:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static int vfio_df_check_full_access(struct vfio_device_file *df)
+{
+	/* Paired with smp_store_release() following vfio_df_open() */
+	switch (smp_load_acquire(&df->access_mode)) {
+	case VFIO_DF_ACCESS_NONE:
+		return -EINVAL;
+	case VFIO_DF_ACCESS_CTRL_ONLY:
+		return -EOPNOTSUPP;
+	case VFIO_DF_ACCESS_FULL:
+		return 0;
+	}
+	return -EINVAL;
+}
+
 static long vfio_device_fops_unl_ioctl(struct file *filep,
 				       unsigned int cmd, unsigned long arg)
 {
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
 	void __user *uptr = (void __user *)arg;
+	bool ctrl_only = false;
 	int ret;
 
 	if (cmd == VFIO_DEVICE_BIND_IOMMUFD)
 		return vfio_df_ioctl_bind_iommufd(df, uptr);
 
 	/* Paired with smp_store_release() following vfio_df_open() */
-	if (smp_load_acquire(&df->access_mode) == VFIO_DF_ACCESS_NONE)
+	switch (smp_load_acquire(&df->access_mode)) {
+	case VFIO_DF_ACCESS_NONE:
 		return -EINVAL;
+	case VFIO_DF_ACCESS_CTRL_ONLY:
+		if (!vfio_ioctl_ctrl_only_allowed(cmd))
+			return -EOPNOTSUPP;
+		ctrl_only = true;
+		break;
+	case VFIO_DF_ACCESS_FULL:
+		break;
+	}
 
 	ret = vfio_device_pm_runtime_get(device);
 	if (ret)
@@ -1371,7 +1432,7 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 
 	switch (cmd) {
 	case VFIO_DEVICE_FEATURE:
-		ret = vfio_ioctl_device_feature(device, uptr);
+		ret = vfio_ioctl_device_feature(device, uptr, ctrl_only);
 		break;
 
 	case VFIO_DEVICE_GET_REGION_INFO:
@@ -1390,15 +1451,33 @@ static long vfio_device_fops_unl_ioctl(struct file *filep,
 	return ret;
 }
 
+static int vfio_df_check_rw_access(struct vfio_device_file *df, loff_t pos)
+{
+	/* Paired with smp_store_release() following vfio_df_open() */
+	switch (smp_load_acquire(&df->access_mode)) {
+	case VFIO_DF_ACCESS_NONE:
+		return -EINVAL;
+	case VFIO_DF_ACCESS_CTRL_ONLY:
+		if (!df->device->ops->is_ctrl_plane ||
+		    !df->device->ops->is_ctrl_plane(df->device, pos))
+			return -EINVAL;
+		return 0;
+	case VFIO_DF_ACCESS_FULL:
+		return 0;
+	}
+	return -EINVAL;
+}
+
 static ssize_t vfio_device_fops_read(struct file *filep, char __user *buf,
 				     size_t count, loff_t *ppos)
 {
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
+	int ret;
 
-	/* Paired with smp_store_release() following vfio_df_open() */
-	if (smp_load_acquire(&df->access_mode) == VFIO_DF_ACCESS_NONE)
-		return -EINVAL;
+	ret = vfio_df_check_rw_access(df, *ppos);
+	if (ret)
+		return ret;
 
 	if (unlikely(!device->ops->read))
 		return -EINVAL;
@@ -1412,10 +1491,11 @@ static ssize_t vfio_device_fops_write(struct file *filep,
 {
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
+	int ret;
 
-	/* Paired with smp_store_release() following vfio_df_open() */
-	if (smp_load_acquire(&df->access_mode) == VFIO_DF_ACCESS_NONE)
-		return -EINVAL;
+	ret = vfio_df_check_rw_access(df, *ppos);
+	if (ret)
+		return ret;
 
 	if (unlikely(!device->ops->write))
 		return -EINVAL;
@@ -1427,10 +1507,11 @@ static int vfio_device_fops_mmap(struct file *filep, struct vm_area_struct *vma)
 {
 	struct vfio_device_file *df = filep->private_data;
 	struct vfio_device *device = df->device;
+	int ret;
 
-	/* Paired with smp_store_release() following vfio_df_open() */
-	if (smp_load_acquire(&df->access_mode) == VFIO_DF_ACCESS_NONE)
-		return -EINVAL;
+	ret = vfio_df_check_full_access(df);
+	if (ret)
+		return ret;
 
 	if (unlikely(!device->ops->mmap))
 		return -EINVAL;
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 0cc91c6f96d2b..c81373ddf2a9c 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -97,6 +97,7 @@ struct vfio_device {
  * @pasid_detach_ioas: Opposite of pasid_attach_ioas
  * @open_device: Called when the first file descriptor is opened for this device
  * @close_device: Opposite of open_device
+ * @is_ctrl_plane: Check if a region offset belongs to the control plane
  * @read: Perform read(2) on device file descriptor
  * @write: Perform write(2) on device file descriptor
  * @ioctl: Perform ioctl(2) on device file descriptor, supporting VFIO_DEVICE_*
@@ -127,6 +128,7 @@ struct vfio_device_ops {
 	void	(*pasid_detach_ioas)(struct vfio_device *vdev, u32 pasid);
 	int	(*open_device)(struct vfio_device *vdev);
 	void	(*close_device)(struct vfio_device *vdev);
+	bool	(*is_ctrl_plane)(struct vfio_device *vdev, loff_t ppos);
 	ssize_t	(*read)(struct vfio_device *vdev, char __user *buf,
 			size_t count, loff_t *ppos);
 	ssize_t	(*write)(struct vfio_device *vdev, const char __user *buf,
diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
index 9a1674c152aa2..1053774d2d659 100644
--- a/include/linux/vfio_pci_core.h
+++ b/include/linux/vfio_pci_core.h
@@ -178,6 +178,7 @@ int vfio_pci_core_ioctl_feature(struct vfio_device *device, u32 flags,
 int vfio_pci_ioctl_get_region_info(struct vfio_device *core_vdev,
 				   struct vfio_region_info *info,
 				   struct vfio_info_cap *caps);
+bool vfio_pci_core_is_ctrl_plane(struct vfio_device *core_vdev, loff_t ppos);
 ssize_t vfio_pci_core_read(struct vfio_device *core_vdev, char __user *buf,
 		size_t count, loff_t *ppos);
 ssize_t vfio_pci_core_write(struct vfio_device *core_vdev, const char __user *buf,
diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
index e41437fa17ad0..ea62d4e72d3bd 100644
--- a/include/uapi/linux/vfio.h
+++ b/include/uapi/linux/vfio.h
@@ -926,12 +926,19 @@ struct vfio_device_feature {
  * be provided the same token as VFIO_DEVICE_FEATURE_PCI_VF_TOKEN provided to
  * the PF.
  *
+ * VFIO_DEVICE_BIND_FLAG_CTRL_ONLY restricts the bound device fd to
+ * control-plane ioctls and non-mappable region read/write access (such as PCI
+ * configuration space), rejecting mmap(), read/write to mmap-supported BARs,
+ * and all other ioctls or device features with -EOPNOTSUPP. This should be used
+ * to prepare the device fd for attachment to guest_memfd.
+ *
  * Return: 0 on success, -errno on failure.
  */
 struct vfio_device_bind_iommufd {
 	__u32		argsz;
 	__u32		flags;
 #define VFIO_DEVICE_BIND_FLAG_TOKEN (1 << 0)
+#define VFIO_DEVICE_BIND_FLAG_CTRL_ONLY (1 << 1)
 	__s32		iommufd;
 	__u32		out_devid;
 	__aligned_u64	token_uuid_ptr;

-- 
2.56.0.455.g6c5a503b38-goog



