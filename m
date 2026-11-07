Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01760606A800
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OWQR3ePD
Received: by kanga.kvack.org (Postfix)
	id 3192F6B05F3; Fri,  6 Nov 2026 19:37:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D1FB6B05EF; Fri,  6 Nov 2026 19:37:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11EAA6B05F2; Fri,  6 Nov 2026 19:37:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D90606B05EE
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:18 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 724471201B3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:18 +0000 (UTC)
X-FDA: 85406458956.08.36CFBA6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6F93240005
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OWQR3ePD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011836;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mCFMpOTu0j+6Ae8InLL7w0WPXWrYNgO/akoMq6zJJ7g=;
	b=xHmdeswbt3WZSqUkuS4jJCLGptuFEbtatp/aqQCicLMFE9sztS6+XT5xBn4UMVFpgAWDo/
	K3ppDDWm5F+THadobiURvccCUjv6lJ0iVLa9DfyT5tN5xxA+MkMRI57ym64l8rQkV+jsTc
	XDHG6LweOuq2rRCb5IMQiYhyswNYe2o=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OWQR3ePD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011836;
	b=sn0pZgtNAdz5GgMCYbiASAbZw8+g65KaeurzJXskiFDCcrT5P+Ntc+Qsp2MYwsQSkaKRgx
	Mq2hGI9TR+81E8eejyY0e7+dQU1kQpaJIgjPxw5BnJVIfcaiT/adLuW31WigbQqa+YcE3p
	kenD0QdO/YRBTEVjxoGNN6P2jnalqro=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 46C7F60D69;
	Sat,  7 Nov 2026 00:37:16 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011836;
	b=GI59OHI4jXTmxklcXJneelhHScY5T2jMzG0UpeHlq+0y7Hiqrd5oZFGLRmHwJVkb5j4i
	 cxyQuz7vBbLeVkAqas78eLHd/RK/c6J6uoH2x8fAkktG5Ri3MkuYHuhEXgvQjK7fJhoM5
	 83gWycD6ZnZKLKb2bWR28nvqvQh5b1pMoj1cF00o8imNXvtFRqYquScPlbC8la/60WVET
	 vEvvRvlGeCnYqnUQsWgkOEJOSaGWl6QgAuC8l3geuiBbka1TZ6hn/bSlVwoNVQ1D1PBoO
	 q7d9OKCZAj4DgXIjS7SuP+Hob757N9u0CMwF15Mjvjx0tHqX0tKD0+vfH8rXXPF9Tdw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011836;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=mCFMpOTu0j+6Ae8InLL7w0WPXWrYNgO/akoMq6zJJ7g=;
	b=Tq+6xslCS6y47JNvGGxfcu2urz4qqHFFvS2DECl3XSfGeNk8hSWRdtpMJn8Vr9n6RBA1
	 hdk8wroJfgBY1otigi8DhQKJBhjucax4rqJX2GkMGC2uAbTUQ1JI+VPF27ro/7ixDjcJz
	 K8uEkGjUTTtNZWBXhL8K/DX4vCzvoWKrhKfMh67QFrnpJlwGn6BiwO09H6H6JQIqqdIVg
	 tutQQskM8+z1+YkXP/Ds2zpKWNx++v8pOLmt/wilpVXPdsId8y/V7QTTonEqKvL51VDW5
	 wCgwQuE8ZUYwkHCHfG2lLFzSMhrIGmWtA60ensvS6mCdYI0ALuFP/+wKejg+9EO7V9Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D9D761F00A14;
	Sat,  7 Nov 2026 00:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011835;
	bh=mCFMpOTu0j+6Ae8InLL7w0WPXWrYNgO/akoMq6zJJ7g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=OWQR3ePDlqin4tx7NS6UiyORjBYsjzluakJzEl1OelZPwFAFJwgQ3vWQ05PI0TyfQ
	 Gnh5754Ha/+SP0OfqmM86dz1WBc5n/4donc22oxfxBv7LUTfbAJth9YLwm4vD2lSEC
	 lxCJAW9bkbyn/08xoKM1SkJcykBU9Se0T9LDt4H3vV7JhccZiXc2BRlhjpWKofI1G+
	 aV2zt4p1RsgKFJrqz1qpONtiJY0l/E3tk731tEHhiE+4tnCJQPh+DGFoR6nuMKdvUU
	 958C6vYrqMgRzz0KVXz+WN6po3nqVjWTMoJ2zR3VjfyP8f63gQyW5/uG4oDqkKl2O6
	 7/XhInxAr3C/A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id DF6AD47A34;
	Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:48 -0800
Subject: [PATCH RFC v3 74/88] KVM: selftests: Verify VFIO IRQ info for igb
 device
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-74-8484dde66a7e@google.com>
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
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=2686;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=AQWLCgcApEEg/jyplbDhTDq5B3XgkxkLe0iSGXinQCc=;
 b=lzA7mjrnsoNNt6rCSt1o1c7XKjGh/b3RZ9f/ThL79ZgoHIg/TBQHg/cOHoFTJNTQBhv4Maxy/
 eIA9j9nVdKwBg73IhGl+U9b+AJRUyfp6pwsh2i/u1ti2HRsFODVqhyR
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6F93240005
X-Stat-Signature: tp1yjdbteeboqha9qeejw6iuy87yq6a1
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011836-191139
X-HE-Meta: U2FsdGVkX1/D1Tfz1nghZGRQA1n9aLwCN8Xu4oWN8pdjwBMaNrlB4+CIkhT8iVR3xaIykSdqlOmxOMcQfg6oQpDLJ4y+CSPZsyPuAnPDcitAqSB1jVAKp1qvs77Qp/XWwzrBhaN7m3916P8dMRsszVL0/fVzUya2Fwi92/nG0n/unY7OGNqpz2Wem3kbxaqobUEVtEtRSwjtp1+eggdyGdm+gNaU4160++z9FjmKT/fwCbklIdoabOK+Aa1Lpmw1B9/s3FGtqSc9IDoGSO/4Z5CjVpdhn+tPxMakLltjbpz1vdkJP+BtDSlqrxQT985RQ/Y6YwHdL3BY4lvGvBh70jgT9+BqG1CcCsyC676he2pRzvFLNDC5eqxFAqUUJyTgwPke3jD9vn9ftwBZndXk4VpZonr9zdBYwqmgY4AjGqfZMz1yj9C5A78WQFDlIpw1i7rn+M2ojZp51aDYxuyRk0xMeA9PwGISplLpAdCn561s3fANiXZPhvOam6wamAGi1vRoYn1K8uT5XZgkGJX5muOGHrppgZoXocGdgKCx6e42QwHPPqYt7dsxbHQUQGPqray5F+1GW4dkBpcImrG9QjFm6sXASZLVaIxdL27F6A+A0dI4Nvvk3oR0yWdXNhZ2dDLWB/chckg8DMxM3nyGOUANaWQWHpHGiVAiAhMZRY1pLtOoEQvwt7U5jxp2jBB3ugS3xJg72vkQ8viQktTJ4UupSusO0uWPWXB1vZFN+3IyDBbpNZdxiTBl8oo4R4jIpcnidgpibcZofTWXU6cmP25bfvJqsYMT0Do8dgl8raRFyV29jFaEpssse1rPqdpSsFrJo7gfykMHNHATDmG/oEW3aVUmHQPIyz6nbLzmHkMBNWhl7B7XWWkN385mfXgEYQxgeHDEDGDXkwCq+e8/XtQK0Kb5EiBkun2q+JpZ185IwoX4ZLkAzjdao1Z0YBepJ1DGmy2io0ADN+gjFEm
 2Yv3IUag
 PQci5b2hpR6f+1U/CgdvXZw9Ov9j7Qyp3rClQo6euJWbmADylZWXUZi5H8M2NbL9GQF2txGYsUpdPs3DLE+C//0HB2atMwobKF2saVI4VKa6DFwebCwNdoCFXTENVbEHv8+1jPfhN0GUwFMQkJEumwM0aBTjukY6u5CGi2CxmbklDCkkztE0nCVZRM0rUNz/CcE4JDUxJs6XoDLhIc9PGjq4I6bCBhgoN04KDxGrE1N4nSe3VGh3sw/JqbCIeJ5Hanp107VbBp1hWwRqkEyITIueUr1z3zxz2mlNrc+YqE3yO0nYUQKx7SqLcFzSC8eU5zfJv6acroFCi3SCLnClU3ojBwrGL7ZhcvsEetojLHgz9gV7HMoPCeOD+UHqSYzGWkKmleIjIVTOU+wntnD/fc8rHerjJO9XYOITo7lssXV9pX8SJtsQKOaGb/AmljpJwXALLMttd3mpaIuYiArUnFD0tRyhCF7z49wiBM2jNMqIAvtEX6DUdBP8QczhEi6HkbgXkh3rhSFLKU280j4EorUzoKHOrpSlaaobKK0w5vVQk9vZikZZWSqFPyg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add a subtest to verify interrupt capability queries on the bound
Intel 82576 device.

Check that MSI-X reports a positive vector count with eventfd signaling
support, that MSI reports eventfd capability, and that INTx reports
eventfd support along with maskable and auto-masked flags when present.

Testing multiple interrupt types establishes baseline checks on the
underlying device descriptor so that when VFIO resources are later
delegated to or wrapped by guest_memfd, native capability querying on
the device descriptor remains unaffected.
---
 .../selftests/kvm/x86/guest_memfd_vfio_test.c      | 48 ++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
index c76abe6d45140..6525f392b3930 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
@@ -188,4 +188,52 @@ TEST_F(guest_memfd_vfio, get_region_info)
 				    VFIO_REGION_INFO_FLAG_WRITE));
 }
 
+TEST_F(guest_memfd_vfio, get_irq_info)
+{
+	struct vfio_irq_info irq_info = {};
+	int ret;
+
+	/*
+	 * Test MSI-X interrupts (VFIO_PCI_MSIX_IRQ_INDEX):
+	 * Intel 82576 supports up to 10 MSI-X vectors.
+	 */
+	irq_info.argsz = sizeof(irq_info);
+	irq_info.index = VFIO_PCI_MSIX_IRQ_INDEX;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_GET_IRQ_INFO, &irq_info);
+	ASSERT_EQ(0, ret);
+	ASSERT_GT(irq_info.count, 0);
+	ASSERT_TRUE(irq_info.flags & VFIO_IRQ_INFO_EVENTFD);
+
+	/*
+	 * Test MSI interrupts (VFIO_PCI_MSI_IRQ_INDEX):
+	 * Should report eventfd capability.
+	 */
+	memset(&irq_info, 0, sizeof(irq_info));
+	irq_info.argsz = sizeof(irq_info);
+	irq_info.index = VFIO_PCI_MSI_IRQ_INDEX;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_GET_IRQ_INFO, &irq_info);
+	ASSERT_EQ(0, ret);
+	ASSERT_GT(irq_info.count, 0);
+	ASSERT_TRUE(irq_info.flags & VFIO_IRQ_INFO_EVENTFD);
+
+	/*
+	 * Test legacy INTx interrupts (VFIO_PCI_INTX_IRQ_INDEX):
+	 * Must support eventfd and masking when present.
+	 */
+	memset(&irq_info, 0, sizeof(irq_info));
+	irq_info.argsz = sizeof(irq_info);
+	irq_info.index = VFIO_PCI_INTX_IRQ_INDEX;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_GET_IRQ_INFO, &irq_info);
+	ASSERT_EQ(0, ret);
+	ASSERT_LE(irq_info.count, 1);
+	if (irq_info.count == 1) {
+		ASSERT_EQ(VFIO_IRQ_INFO_EVENTFD |
+			  VFIO_IRQ_INFO_MASKABLE |
+			  VFIO_IRQ_INFO_AUTOMASKED,
+			  irq_info.flags & (VFIO_IRQ_INFO_EVENTFD |
+					    VFIO_IRQ_INFO_MASKABLE |
+					    VFIO_IRQ_INFO_AUTOMASKED));
+	}
+}
+
 TEST_HARNESS_MAIN

-- 
2.56.0.455.g6c5a503b38-goog



