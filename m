Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 306C4606A81F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:40:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Gkg95qY9
Received: by kanga.kvack.org (Postfix)
	id 600196B05E7; Fri,  6 Nov 2026 19:37:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D6E76B05E8; Fri,  6 Nov 2026 19:37:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 404356B05E9; Fri,  6 Nov 2026 19:37:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 07E976B05EB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A6692A7BA8
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:16 +0000 (UTC)
X-FDA: 85406458872.01.3D63D7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 960F3140007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:14 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gkg95qY9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011834;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JqskTMgaNl46ZMdg+IyWBpcGhKCkti75Weg2qkmW3SE=;
	b=xKN59ZI8jZq+gcGo5SN/qWJrtZ9W1WnBf6kkTK8BrxT1JiqKvpjFfH8Vhdr7n+NN2ApScA
	NhERTVhU4GqYOieMufK9Lm9YwHVTSxbKN8/u9yRBtHOWGrEGZLx7aVRpgm1ndHAB2V16i+
	isCDhXMjy3pg9omadY5JQpppGwfqPaQ=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Gkg95qY9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011834;
	b=QQMTDXn+jgrWypYx305F4/4mbrFw1V246kKCai7Jw3yi277Y3eAlG60+jypSzZl+6N7Pje
	4LATAIk57E6/p7+v4tXJWCd3ul4fOelQ0hNvnYpnB3P50+fVjbxaAqEvUzECEcd82QZz8j
	e/iFx325xfIBpD+IXEsyU1mf5OrEuzY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C30C41142;
	Sat,  7 Nov 2026 00:37:14 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011834;
	b=wzqe2BiAnifaLqnCfXJv0Z1XWGe/338nsGn3TRzbulfbRO1NuGqhuC5skeDaoyJuHEl6
	 33nWMy4HumMppUaPU3iV5EE6fZYJKvGp3mwp4zcTIII4U5PkT+ZTDJwGvnCQcJ7RVcn4M
	 QytBQwMxcavo0i35d4Lp3S+39Zlb1tm45rJV5t7UN5jrPseCVq3k+hfJgQL+MQRca8rFY
	 jjNr1ud1q6Y1+VqR1y+396Ysfb4jcnYLJ+Kln2kaFWZ4ZWDJih2hvrC9Bwq8grNrTmkWJ
	 HvI5dt03QronDJLbry1L1zFV+wh80PugVMyt1pvt1kZXNcSh+MB4+/6eND8YTgc6dHQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011834;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=JqskTMgaNl46ZMdg+IyWBpcGhKCkti75Weg2qkmW3SE=;
	b=lenw/XWGAXdx33K7y5WTCAF8VeGaLjvStelgD0akLZDOVXTLj+qMiy0pwSFXWbfQJxcq
	 iG/GkjKjOwXhA9z6VZ1Iw8WphlZ+B+hv3RdGOsh4QaoLbrKQ1TA8yqgQJMn2sIF9mDdd2
	 pOQ5ZUqfpBzdBrnv2hLKvVIF+6QQlBKXKinshLo2KkN0ETfOma06NVkH/nKbqn2wQELks
	 gtTFW8VfZB6dXrh1w5deGeiSsWvT7Oui5yZL2fuAy1HSheqPtmWjBMu84PoupXo93OIY5
	 /z4ikIHY9xB43Dkt3Tapy1/sRKL2okdkOZJqU6W8dd01WSofVve83hm++MTz95EUiyw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 3D5721F00922;
	Sat,  7 Nov 2026 00:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011834;
	bh=JqskTMgaNl46ZMdg+IyWBpcGhKCkti75Weg2qkmW3SE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Gkg95qY9crQQ30ElnyiUP6f8DPh9nJGYRCysh6qz8w3kazWtF1s5MyfwkjSrij3nE
	 jarDTkhPLvlAkBMGBuIRv/Ye7Mio6ZRwyMdJ8gkOJ7h1vl1HeyvRs3JpUYJS5SqLU9
	 LELBJbJbOXCuZwvPZg38XOC+RaFdLFGpPxJeUp+UmQcv1h4am0z7NtCXYULuvOssmp
	 YAmQd2xNtIBBfOV6ni8jCyohMyVNzPmdfM1NB+9Y0+dpX0gxvsAGc4TJsx1OzXlnNQ
	 NyEe7M9kKQe7Bl79sTGfw6rnRKrNUZSuoWYCHWbKq2TgFjbd4eJXJoEZq9AiijPAz7
	 nproAH9ruDyeA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id C5ACE479F0;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:31 -0800
Subject: [PATCH RFC v3 57/88] vfio: Dispatch guest_memfd provider
 operations via vfio_device_ops
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-57-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=4501;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=q2ITMkbAof/3UP+0FfKPWcVVHgQv4Rq4rRtRz04IELc=;
 b=dY2yZNw6w5h8twDc2KQFqIDSj+kEflkJIL6zIJOdYeI4Zfv9+RVf/WpjLyZjT9gdkhmx7PeRk
 h9/vQsv1G13CPj8w6oaoyFHRUaGfzC1xYGZ/akAfFW69XvPPrdEysLF
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 960F3140007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4rph9ejyw81cniic3ca3mhpn3q4sa6cz
X-HE-Tag: 1794011834-242892
X-HE-Meta: U2FsdGVkX19+SYh56iStrhZJQ7UBktzYU37In7MEdTIx/1QaLorVHmgjaaxPcME5dzJztk+yXpkWwQ4j1fyQtOoJSnfxd+eIZVqXN1kM8NjuWGf9s9p5Z7wNRTe7BqqkgtIxiBTpi6hYiog/Q50iGN3bZorN4kDXwioPAZvxF7lBQFd65yPcFr8KnYNsdwC5W3Rqk6yEqB9vUxRjf1CwEkxuDR/oHLmG+K8jqPms5ssbRQKyDkIRTiiDY+DkOEh8mu4l9cfHUlxJP/8RAAeRjlhnUy/WTZR04q5S5hhwcSxG7/gmS/l8TAK7P9WMvqxjIOehLgYIgXM5VFCIZH2sbe1WsPT7lif7ZI7Q6AfYe8Bl2LHXKjbjUDykAlkJRynzCYFmRpvTFbExwAdMu4nsEPsxr88a2pxAhnm2ZWTlyJa16jgljJXvKJJIZ2W++OJv8okH8QNlwm7wF7FMRrLA11UJOPX27VsZxolVdLcVUS+sZRj3FCwme+glHI+tGr3Uj7zkMNbgB3QLkIUPh6+kNnLvVmYaVoH56RT+48/Y4gL3WSgQ4se5sYYMiCDUzxxjHee08AVN0/t/XOhTAIjUJMq3L6A14SmCHyfm3zXd6eeYRZhbF6f8QkF0pgXXvTZZwy/0xbednV8wgoo0Ut2juE9aJ903aiRfx+MaxMUC6BomAJbYjT/m8Sn5YaO2qLyNbjOFXNLmxgY8G9b//MQ2OSJjvT8i+7SMqIsTrhC/R0Jmfxof1KgNOJVMM/y47d7357H+ng2ohsGSwpf9b6SuGj0JKa89FkLc8I5OULuBM8Cs41cAmXeo+/SPbwEwBBV2BzaXGQwMqYscFGfI0cLy6OhL+h8jrU4PWYkWFVB49Rbky3mEstV1MXIz/i59oMFbBxX+I7RjLCE6aXOYueH1xV7HjMenPw6ky5Vp9QKCKqhwhWilK5TEUH0b7P47jQZCjG2wVZo18Yd92+IyLia
 Kw3xaWdB
 1Zy/lXxm7s5CCShYvz389a3Boi2zu0mjIXUqBGkxhzRyI4fM7LNc1HoVshUfeFnMglymuOEqjQ3Xy04N1TnDMR/MPNM79a4t4nRp97QrqtZbxIjjT9uRQvzuA1hZVQDK38eEj74WafiHVUj3qkJZlOWdPKoytLQfa0vB5oiATCaDzGejGIoM7GgpNJxDvgq07kPYZVPq9/qsCSSYMbTjAsir3h2pV6HyqK1FQU/ZuiLrFKovPx1Cn17CL4V3LkxZRQrlBqWeIlTD1qkmzywqmqXB0t4NckgHHqmJMM0GBQTQcEnSgBF/PhXrugxCc45SZl2xzRNjACLAKohzvpMkXIZLqgrXV6aLLB9FY4QiNt3QJ9WXOlyZCeYNT0R5qtZ249a4Az1pknGoeuDVGcEitqPQsGoGfcZQdF/4mw39g4SylR+kRTKzjCCqYl9T2werO7QrVuVOVpGcXS6mBx4gbp66KJaAJe5cW9/ImLPbhd7sIMG1av1ZIEak+Fzl2Aw+tNw2Mziwjp4A2h85z1hcpWl1TxSB5f+DJ1JXZlkUCvQXRzwJzwkY/s1L0f0qjHn92xQi5KQr/CYbY4YNUkEY7e1VFzHCrjnxwnD6Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

When a guest_memfd instance is created using a VFIO device descriptor as
its resource_fd, guest_memfd queries file_operations::gmem_provider_ops
on the resource file to attach the external memory provider.

Implement guest_memfd provider operations on vfio_device_fops to
dispatch .attach and .release to the bus driver via vfio_device_ops.

In .attach:
- Verify that the device descriptor was bound with
  VFIO_DEVICE_BIND_FLAG_CTRL_ONLY by checking that access_mode is
  VFIO_DF_ACCESS_CTRL_ONLY, returning -EINVAL if the descriptor was
  bound in full-access mode or has not been bound yet.
- Check and record attachment state centrally in struct vfio_device
  under dev_set->lock, rejecting attachment with -EBUSY if the device
  is already attached to a guest_memfd instance.
- Dispatch to the bus driver's .gmem_attach callback to let the driver
  perform bus-specific validation and resource reservation.
- Pin the device file across attachment via get_file(), dropping it on
  .release via fput().

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 drivers/vfio/vfio_main.c | 63 ++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h     |  7 ++++++
 2 files changed, 70 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 8734ae9d06c2b..618daf8bdaf80 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1535,6 +1535,66 @@ static void vfio_device_show_fdinfo(struct seq_file *m, struct file *filep)
 }
 #endif
 
+#ifdef CONFIG_KVM_GUEST_MEMFD
+static void *vfio_device_gmem_attach(struct inode *inode, struct file *file)
+{
+	struct vfio_device_file *df = file->private_data;
+	struct vfio_device *device = df->device;
+	int ret;
+
+	/*
+	 * Attachment is only permitted if the device descriptor was bound
+	 * with VFIO_DEVICE_BIND_FLAG_CTRL_ONLY, ensuring direct region
+	 * accesses (read, write, mmap) and side-channel exports (such as
+	 * dma-buf or ioeventfd) were disabled from the outset.
+	 */
+	if (smp_load_acquire(&df->access_mode) != VFIO_DF_ACCESS_CTRL_ONLY)
+		return ERR_PTR(-EINVAL);
+
+	if (!device->ops->gmem_attach)
+		return ERR_PTR(-EOPNOTSUPP);
+
+	mutex_lock(&device->dev_set->lock);
+	if (device->gmem_inode) {
+		ret = -EBUSY;
+		goto out_unlock;
+	}
+
+	ret = device->ops->gmem_attach(device);
+	if (ret)
+		goto out_unlock;
+
+	device->gmem_inode = inode;
+out_unlock:
+	mutex_unlock(&device->dev_set->lock);
+
+	return ret ? ERR_PTR(ret) : get_file(file);
+}
+
+static void vfio_device_gmem_release(void *provider)
+{
+	struct file *file = provider;
+	struct vfio_device_file *df = file->private_data;
+	struct vfio_device *device = df->device;
+
+	mutex_lock(&device->dev_set->lock);
+
+	if (device->ops->gmem_release)
+		device->ops->gmem_release(device);
+
+	device->gmem_inode = NULL;
+
+	mutex_unlock(&device->dev_set->lock);
+
+	fput(file);
+}
+
+static const struct guest_memfd_provider_operations vfio_device_gmem_provider_ops = {
+	.attach  = vfio_device_gmem_attach,
+	.release = vfio_device_gmem_release,
+};
+#endif
+
 const struct file_operations vfio_device_fops = {
 	.owner		= THIS_MODULE,
 	.open		= vfio_device_fops_cdev_open,
@@ -1547,6 +1607,9 @@ const struct file_operations vfio_device_fops = {
 #ifdef CONFIG_PROC_FS
 	.show_fdinfo	= vfio_device_show_fdinfo,
 #endif
+#ifdef CONFIG_KVM_GUEST_MEMFD
+	.gmem_provider_ops = &vfio_device_gmem_provider_ops,
+#endif
 };
 
 static struct vfio_device *vfio_device_from_file(struct file *file)
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index c81373ddf2a9c..65dc2cb523351 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -74,6 +74,9 @@ struct vfio_device {
 #endif
 	u8 cdev_opened:1;
 	u8 noiommu:1;
+#ifdef CONFIG_KVM_GUEST_MEMFD
+	struct inode *gmem_inode;
+#endif
 	/*
 	 * debug_root is a static property of the vfio_device
 	 * which must be set prior to registering the vfio_device.
@@ -114,7 +117,11 @@ struct vfio_device {
  *             this device is attached to.
  * @device_feature: Optional, fill in the VFIO_DEVICE_FEATURE ioctl
  */
+struct guest_memfd_provider_operations;
+
 struct vfio_device_ops {
+	int (*gmem_attach)(struct vfio_device *device);
+	void (*gmem_release)(struct vfio_device *device);
 	char	*name;
 	int	(*init)(struct vfio_device *vdev);
 	void	(*release)(struct vfio_device *vdev);

-- 
2.56.0.455.g6c5a503b38-goog



