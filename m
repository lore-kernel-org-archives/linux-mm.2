Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E73B3606A814
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KINdUHbH
Received: by kanga.kvack.org (Postfix)
	id 0816A6B0605; Fri,  6 Nov 2026 19:37:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00A796B0607; Fri,  6 Nov 2026 19:37:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3F1F6B060A; Fri,  6 Nov 2026 19:37:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A62836B0605
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:24 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 55E254027B
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:24 +0000 (UTC)
X-FDA: 85406459208.09.C35B3B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 401D7C0004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:22 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KINdUHbH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf10.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011842;
	b=AGEjixeYvzTUwkAYfpYP5+xIfl9Hs6jEn0dXWGUq6+GhOuGnrrgdFcGCQeDWy4qIX5gezI
	YE/xaWujCLdwMgT+ezHlQsDgFTlpRlmc8ABGvpPeCL2jg7CNwMDP1oHcEdiWrBSJ6xR3jD
	3zLWyOsB+ODIhk9Yw7Pj6bkI+VnFrOY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011842;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H8fIHxJ4J5OBMV0gDzF+bqbkZDbxtMyMoTFPXBOC3Ko=;
	b=KMtiUGuTe8IW+gpiHtPqyRknESJqaTqtFNoVCnhbFYVE3vkZA4QKVIRMtBY5GbXB1rERb3
	kOT0sBOwDZCnofnNSLPgDtavCya1YNvsUIHjgIH1STBZq5Ez0SvSKjuYLbczXgqf7AzYMQ
	zLH7p6ajWRdOaKKi71HM/m0zVxx2no4=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KINdUHbH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf10.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C5F0F44606;
	Sat,  7 Nov 2026 00:37:21 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011841;
	b=iEUBZkmeiK6TuGIqh7IFrbVL/nlicsvwt7AmqBNBGJYx/0dRUdFcAsvwUQZR7yIBZe15
	 ilGTUbL7G9Sq6PhfNoxmQysqUw6tJTGESEIZgBS9rHFOGNj0jTaEYaX203DF/+fek1Ss1
	 MRYFfTXQV0NalGe+udndx9b2dyw8y5LXRUivB9yhXmB78y6c7BPFAu8A3GqXXDCEDdt/X
	 zCiTWxyP3tdRCTiXzLl6TcUBWDto017ZYHEk8kY9ux7C5PilqZiYfLpYhUXs6nggG0d4L
	 BjbYIXsuTz78hhKJtdU7PKvM9BDuvDWCLlntzpxk+m/1Y1Z2u8u29OeUlbmxdWPBRCg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011841;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=H8fIHxJ4J5OBMV0gDzF+bqbkZDbxtMyMoTFPXBOC3Ko=;
	b=vpUb1Rym4v0vO8yLevY2Mga2x9AkkutdGzgbvqn3id7PQBsNQ6Ko6yjC05Ja/+9BMmdj
	 mMd2TxRfCPUOPirfMaDojAFcf13YBAwwnlsRNPIHq57i777M5MvCKo/Uezso2vo/J42DR
	 XcAZYcRSf1Es4d185IPJH6xkWatHD2qd1UZF0rkAbC9/G9yc9HBALPANkbdWCykE53LcL
	 UAcLccsxK5bZ/2S2xp5LshGMpBuZR8Acirorm4jgt9Ez0HNvIpw9emH8MOAl8VHf0zgJU
	 cJR2gDk2XeuTaZwYrUAKNm1OvS8itP1mAGbbE2ZXWK5aq+VdkUJY9IyCDb7J/GxsUCg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BAE0C1F00A13;
	Sat,  7 Nov 2026 00:37:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011841;
	bh=H8fIHxJ4J5OBMV0gDzF+bqbkZDbxtMyMoTFPXBOC3Ko=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=KINdUHbH7Q9eJiZ6pg2azrGbWxcKuXaLnE2T6kOumAANRaBRQlI5WtF1P1Z1FCdyb
	 IoLS1qnK2Wv2cBsLAeEq2ql02EurVkADaQeEbg0x1CCbLZoAkgjjbSQ2nOS+4kBNEd
	 nBM5lKQEi35FW0QHC/49G0gP2ePzc3In9NsGSegQRA9N6Q6W63WF1mD+5PzR5rNAc+
	 VcaGLIemH+6n9DCimHxN666W5wJYWPlT5VHA1pJp+vkAdGZ7zCIhvSAH4aIpn6S9qa
	 Syb36amyfIAXH5R4EGZrUTn538lAyFqJndo8Kl8p13dQBSDCF+jCuOip7dWSMEc2l+
	 wTGqVNX3P43hw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 8DF8D47A20;
	Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:43 -0800
Subject: [PATCH RFC v3 69/88] vfio: Dispatch guest_memfd read and write
 provider ops via vfio_device_ops
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-69-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=3723;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=jM77+UpFK8UZJ6Z/B9OjQwdxpmk38JIQhpdGHBHGDN0=;
 b=qZQmSdOhDsqL/VO1Qtn/xfjCgHVuDDCpM2sUtQnC+iJGQWbhQHH4tf/D2WJ0crZwfhZ+WoCZ0
 TPw9vQHWPJGBAJdDnviv0dQFie2JIrL5WljLO4Uq+bUnoXiRG/anEkK
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 401D7C0004
X-Stat-Signature: xi8zboox3381cwox59845yj6nfnsghiz
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1794011842-832077
X-HE-Meta: U2FsdGVkX19mj3hgFp3O6P51pih4og2EzxiRFwHlXzMH8F9OYOFJ2B9prQLrjyONcrudWNnuOBAHVr1vZcgLEjnIMbCotV4N8XefzTUkAe7Hjr9BW4GQGlgmJu21tCZt1EYbbvgtDjSiyxzNjikmWD51BZUBSMSOJy6NmQrgZ8h60lvmEtYBXzPt9zxhZ09ZaGyy7yxGMPMPmo86fqBQPaUF/p5diDyzo+jj7l2fVooRkM8sDAy/slpPERmMUL0n5dWfm1u2cD+DbOqVJyGoN2NU6vbQAsmcfRF7AKNBZNXmIHQfOD3qePipn8T5j3TOjoPvPed8JefqXb9iZFWEZpJB4WrtfkBNGgz/G/aNr01vzDkNB2xwEDlhnoq8t5uDh1hJ3SxB/MuhlZgGjmfNz+O3OjklCGLUs+SWZtJ8NB5lu6E+IRcGQ87ygfi71sR0XC6ug9ZJEuEqm91vp8r66GUVWTrkZ9x/u8wRXkldm35P0E9sPUOG4hT53+BOlVIT97ZYpmJkLHwrHu5SlS8WNLBpjghide+W4e13wHPj2u7UHmMCxj/EnJ0uPBQdHAuT8+soq0/YtSCDdxlv24LEzhYAIOQ3X15YdV5HcAgDvgOx56o/WrtrAzbOXHBeLv0TkKsNm0xGNI4niiE7ajRgStDY+v5FmClihlJSYjC2WoLaPYra2/8Ru28b3H969lxUL5NkIeSDKT6QL5VN6f9GpkwdytiIzJca/fn+UgyBjbPJW6YnUbXA+1BKGq61EFUDoeem6NCKIhkbePwk1xXnqC7LDMtJ/oE1mBfM+AnExqIu0vQ9jK/02fiuvZid28r86l+lZWiQlkQtZs8fmN4jynzUejOorb2Wh9dEfZb65MQFAywSZ99Z8+R/z7Yfc8UKUZCnRjZgLrAgRWLzH7qJ9vtGUi2wTlc4pATl6XeAa07GC9MEvpNT+IVMsgC7opUxVNa1IRnumQUSbi7KjBd
 eT17g7R3
 B6bjUboAjeS1sCI/f3iLJBCOF5JyrHTdRBbHD4WsdD90EYup+caF3+7pfCMMN3n83YGwwpLt3uv6HRrn1IEDmpxe7jvug2PfaHhZF2MSCAQXbwdxr7Mg/KWWVE8gEL/JiAuYgmqrvLrVFcFECvIEqPxc/cO72SafNRmvWALuURl5wq87hMpdc5GYmg8G73tyyxHKzWi74miMtN50jv5RTjaQ0OfbBi09Q+LsZBOIl/cfjau3oclc359uOQ+DMm2O6opWBlef/wlmY0BeVaqCBeGaOvwrilJgSrmr96VCeGwOU9hwNOsQX4PuAL9jFdpOpdho4HFtSE7LKvJ4+uy36Sd5bIR8lQhNDzsMiJEuw5agThoTEHUzpr5YAAvuD02epapext4V9b+W7anxGJTUXamrR/43mnlg7x3YlM9ug8NixN4CfrOYM890x9sMwXApYjk+TNE+XQg/3Vroq0fqC6HOOfCbzc4fGADmUZOVwM588v9akmtEreJOkuHxlVlAkKgT8nmlUSxsZFt/17aAlR4kf0WUQXiY23alwRPCSHPlxIni2qbNbXulseTV97YtaFMr5hBkR184iahUU/du+xUYJc/aTFGdZ+3JQd5xL74t2Ljo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

When userspace reads or writes to a guest_memfd descriptor backed by a
VFIO device descriptor, guest_memfd invokes the .read and .write
provider operations under the shared filemap invalidation lock.

Implement .read and .write on vfio_device_gmem_provider_ops to dispatch
to the bus driver's .gmem_read and .gmem_write callbacks on struct
vfio_device_ops. The callbacks operate on kernel buffers (void *buf and
const void *buf), as guest_memfd bounces userspace transfers outside
its filemap invalidation lock. Return -EINVAL if the bus driver does
not define the respective callback.

Enforce the partition between direct VFIO descriptor access and
guest_memfd delegation: query is_ctrl_plane on the target file offset,
rejecting reads and writes to control-plane offsets (such as PCI
configuration space) with -EINVAL so guest_memfd only services
data-plane regions complementary to what direct VFIO descriptor accesses
allow in control-only mode.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 drivers/vfio/vfio_main.c | 36 ++++++++++++++++++++++++++++++++++++
 include/linux/vfio.h     |  4 ++++
 2 files changed, 40 insertions(+)

diff --git a/drivers/vfio/vfio_main.c b/drivers/vfio/vfio_main.c
index 1c2811848c775..96a768b5ec71b 100644
--- a/drivers/vfio/vfio_main.c
+++ b/drivers/vfio/vfio_main.c
@@ -1650,11 +1650,47 @@ static int vfio_device_gmem_lookup_pfn_range(void *provider, pgoff_t index,
 	return device->ops->gmem_lookup_pfn_range(device, index, pfn, nr_pages);
 }
 
+static ssize_t vfio_device_gmem_read(void *provider, void *buf,
+				     size_t count, loff_t *ppos)
+{
+	struct file *file = provider;
+	struct vfio_device_file *df = file->private_data;
+	struct vfio_device *device = df->device;
+
+	if (!device->ops->gmem_read)
+		return -EINVAL;
+
+	if (device->ops->is_ctrl_plane &&
+	    device->ops->is_ctrl_plane(device, *ppos))
+		return -EINVAL;
+
+	return device->ops->gmem_read(device, buf, count, ppos);
+}
+
+static ssize_t vfio_device_gmem_write(void *provider, const void *buf,
+				      size_t count, loff_t *ppos)
+{
+	struct file *file = provider;
+	struct vfio_device_file *df = file->private_data;
+	struct vfio_device *device = df->device;
+
+	if (!device->ops->gmem_write)
+		return -EINVAL;
+
+	if (device->ops->is_ctrl_plane &&
+	    device->ops->is_ctrl_plane(device, *ppos))
+		return -EINVAL;
+
+	return device->ops->gmem_write(device, buf, count, ppos);
+}
+
 static const struct guest_memfd_provider_operations vfio_device_gmem_provider_ops = {
 	.attach               = vfio_device_gmem_attach,
 	.release              = vfio_device_gmem_release,
 	.get_pfn              = vfio_device_gmem_get_pfn,
 	.lookup_pfn_range     = vfio_device_gmem_lookup_pfn_range,
+	.read                 = vfio_device_gmem_read,
+	.write                = vfio_device_gmem_write,
 	.mmap                 = vfio_device_gmem_mmap,
 	.check_set_attributes = vfio_device_gmem_check_set_attributes,
 };
diff --git a/include/linux/vfio.h b/include/linux/vfio.h
index 8022adedc26a6..012a233a375ab 100644
--- a/include/linux/vfio.h
+++ b/include/linux/vfio.h
@@ -130,6 +130,10 @@ struct vfio_device_ops {
 					 u64 attributes);
 	int (*gmem_lookup_pfn_range)(struct vfio_device *device, pgoff_t index,
 				     unsigned long *pfn, size_t *nr_pages);
+	ssize_t (*gmem_read)(struct vfio_device *device, void *buf,
+			     size_t count, loff_t *ppos);
+	ssize_t (*gmem_write)(struct vfio_device *device, const void *buf,
+			      size_t count, loff_t *ppos);
 	char	*name;
 	int	(*init)(struct vfio_device *vdev);
 	void	(*release)(struct vfio_device *vdev);

-- 
2.56.0.455.g6c5a503b38-goog



