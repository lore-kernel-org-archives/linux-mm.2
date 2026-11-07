Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 753FF606A808
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:41:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NXxRtu60
Received: by kanga.kvack.org (Postfix)
	id 2F7976B0602; Fri,  6 Nov 2026 19:37:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22EB06B0604; Fri,  6 Nov 2026 19:37:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A8B76B0607; Fri,  6 Nov 2026 19:37:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D44066B0602
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7E13714016A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:23 +0000 (UTC)
X-FDA: 85406459166.01.DB5250E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 71A59120004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:21 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NXxRtu60;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011841;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M1cXkOgzZjDMJwHRh87UzeiwzMokp065wJbSjfeeioc=;
	b=erQudsmb5t1jehGC1fOe/zURutca/ZlvnumLmB+PwUXYUzCzd4bvq7vt1A5bhDHcGtDuIS
	f4NPwpfVHOO3Sss40W4j4DIk8eNFBgONyrgzYl5aIgp4DQY5dwHi5Ej1dZuMndL0GuS+or
	igXm0GuI2gJasb1aHD/wrobDPRvptZ8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011841;
	b=rouo5X2aHQmB4PrQDS0oz6iEF7URX6KqibOcXJHs5GmlT8W2EY5lUg2wt73huWVHu2L6O9
	n+4sV3IKdegYUkAGMJPZi8Yzc5p4EZtGFRTCLQTpjaZ6bo4z79ndX/K1Wn7EC0OtxvOfRT
	kcrMLKv/Q1U0BadHruJYyiCoRWadAtI=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NXxRtu60;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BB3A44620;
	Sat,  7 Nov 2026 00:37:20 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011840;
	b=BXXAr0Ytr0ihc6QOLCaVjWx6dsHGfm0vjxYYrWCpNQ39r9uvPzhucCJL4t2yRrZVye+r
	 uoTvdMPZyoti7VuGBnXmsebYHPcs5qKq3IZzfswFXkIsnMAEf3k1SqZ1VMlCtA/rOK0wT
	 GAwSGI2WfKVbQYnt1bB711mDU+Hsjemt5BbUeLsM4D82KFIf+iZc+gEYmlE9GieSRf57p
	 CJE4vNX2RomW5VVLJSlGAA6NPqWYhDt4m13QqKaRuv1aelvohOkucsyP2cgsw5C0T/AeV
	 84qfISAVikhwpJyhkGPoNikKbeQt6m9bLioKymwCb0XXGwctbNE8CEozeVhq8G51UQA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011840;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=M1cXkOgzZjDMJwHRh87UzeiwzMokp065wJbSjfeeioc=;
	b=IHum0TXEkhMnoSEe8xdw51h5zyxd+dcB+q2Ca4xWO5P4/kSutpVD936q/E+YfSDLDHcr
	 SSw37qTHWc4nm6MzgsGyE5KGMGBq+ScKMboXuo4ouigRlgLEkWd/vEsQ+uuPl8wHVVyLB
	 2IoERIxJm2U7F1fSF+k8Ys4RsC6B+spuVP23ZTpuy+Xik19LemP62346u1XI5zN5L2DjB
	 Kjojw2tgfw1pkPJ2bJHOVOgmUW+np1Hq2S9PXGqbx7O3ja9s0OQZK1CaweebVCHzXXn56
	 zvoKd+BFuWcTE+IOGhMzrqUCTn1wpkCnwpBKdE1WEY/Qv8XqQp+l9WbjT/oSIgp5j7w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A01471F008A1;
	Sat,  7 Nov 2026 00:37:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011840;
	bh=M1cXkOgzZjDMJwHRh87UzeiwzMokp065wJbSjfeeioc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=NXxRtu60BWP44qbkoD17v5SKSPpfy6O5yo6f8smG9mbfn9ef3nc72RIIyUOOKpjsB
	 Xp9CQ9d6MgSeYAy+GNZvkoA3kMD/p9DyDPJO0JXbetClrMzIZE2SJwR36CDCUC7OwK
	 s/oJlpfm6ksO24kCbGQBQWaop0O+nzZjFbdo43yUTzzibVWrjoNqiGKDJyXQR7hcEa
	 yloC6oKLfIrhIj1RrBMW6dEQsZ73+UCdftbkRLglWGo5rIqe+Jjfxesc9aDrISaDGK
	 zZPVXwU1iqB7wtds57HKFpOyVwS1OWyYqx0WmGMRPu3WyELZoLD+AUSQOh3iy7uzz+
	 vqVwlXURlZehQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CFF4C47A30;
	Sat,  7 Nov 2026 00:36:57 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:47 -0800
Subject: [PATCH RFC v3 73/88] KVM: selftests: Verify VFIO region info for
 igb device
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-73-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=2549;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=mrWvs6FF7l4LpcTEng8nbYIsnoTAo2jJxDhGuJ9QU+g=;
 b=wY395FIuwjLW/oJNaiS8f/FOkSCxKWTmBujK/E4H3vKhDyLPEibe2RUJEOyL3f7zZZ6SQEXMe
 pVDqo0rakbqDQ8XO4K1/+VBsAUIcnImILMrQ/YDvpu/qskpIqC2kMNB
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: tnidxagy7bbudyp5amq8f9njmr1g53w9
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 71A59120004
X-HE-Tag: 1794011841-997142
X-HE-Meta: U2FsdGVkX18ABkV5TFV1j+bkJGzh19jpf2ZztBOqIrTBIvOWNmNmc7O52LeiwT55tDQJjZDHTEdxHBV0iDloXh9QmTyFKAdcc0mz9O8/FUnlyFnsezkjSPVjwDy1sp5hbpfvySKL0EfN6HxU6uZsKgS7dSXtlW4H6GULi+YcPOvfTZZgMCrh6eB9mxHWc0uYqdtWXxWDNsCb7RtbQaongE8mdYlxzUet/w7TcES1IPKfYYQLqrLrGvYL9Utc6Asvveo09j34mihNVGdYRrSE4v9PksPa+3VelQzKlLNuIL/LPLlXUlOQ4S/txkCAHb4zDQFEc4gULRLbuF1UGVMNY52P3bVnS+n3uGx4j2gIylJqnfApf7SHYBd/+45OrSghJFS9GekqzO5+YrbyX5pYGp1GtjbKH7DYEJB1PVlOvrmdtqcUN8ceHoy9JZljXf7DSxgM7Ft+/bo7f9LL73mSOoDTUvBdk2HZC8nlZz8vvCXSGkPWKsdqcWxyyoGKnjTYDJqxPpLkKmoiHKGFHzb4mBKmiPFZRZZDWu72MdTRk2GgkDzbtrEALN6NgQt+OCG1KbyJTA5iueQVJocKoPn/dEY2WJy0MF7n31XrCkkIKsd5HLkeSIs8N0H5G3gPDRCB0l45PDqDWKzbjuGNJOTPQpn2Yc8YO5SgCy5fw0K9nS/7Y2uvyr5rqFPsGQWCZC1oWe3HLADHf6CMNyg3ZjadMQnThA7MCOrOzQQfumsJ+JH0F0UlOWqPVNn892N/T2WHUmtRvnM5ClIHPsTkB3xAMOSljaWVDk+2w8MmD9pTP7ROB3S2AbRuSgqQqdwExxOIcYoR/IVgmtJxTnF8LFNtRCpiItZkfWLSvJ/50PiroRG7OY4KNcvd1zATyCqUH6Jn8TShDpeqxl9ffOaYyaJ7puzsnPUfJkRMJ+OT5RA5dhpbkjRkJMYvk9L9l6D6d3HSJtEunctGkiW6wsBzOVE
 3EwPXLmI
 UtnhGsuNalZTVKuuitDDcCT/2DkuA2YKZ1PjijVIUyIwB+vn4+ZiNTMvipUZ3yfIgbE1ptrgeJg9xH127yA8FzyRqzRX6n7le6nWKf5QjcvP2hRDcP32SLuTt9eqe/rLDFzMaoDwqwxlJCusr/RI7AKwKXeuGTHTx8gqVaaOgOZGu15Jgvm8tQlpXjJ1Z9KUUEKBsPJy0RH2hQnAVLlGcfXBFRUQCHxARXYUXc+1GUirMAHhQySXiyGaGaJwwBo/ZHATY50L+iJdteuLGE8UpROL+ZhsIoln4+sALT/vUkmXkNRiU+Udcz+Di2XngXGvWTJe5F/XNp9qyd8S1clO3046PwNKIbKVD6O28jF/aY9b4TSPzkAXFdtF76qmsOD5wQ2tVrh+RiWlmhxN8oAr4zCAiS9JdxQtkQxo7BpyqejD3Kwzml2i2C9ofOALDLhZ+U1pdLW+8AJZ8KlXvEMiXFMkm2hWYYyessIm/eUc5yCxwEPeCmup/Oka+lYO5n3YR034h1Kxaxm9HIe+yL4n8cUiw8ZF5rONsT1ELsr3fTfxfOZoQRQW2gF0mXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add a subtest for VFIO region info queries on the bound device.

Verify that the operational register MMIO space (128 KiB), MSI-X table
and PBA space (16 KiB), and extended PCIe configuration space (4096 bytes)
report their exact sizes and expected access capability flags.

Testing multiple regions establishes baseline checks on the underlying
device descriptor so that when VFIO BARs are later delegated to or wrapped
by guest_memfd, native region querying on the device descriptor is
confirmed to remain unaffected.
---
 .../selftests/kvm/x86/guest_memfd_vfio_test.c      | 38 ++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
index 669acc6058b5b..c76abe6d45140 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
@@ -150,4 +150,42 @@ TEST_F(guest_memfd_vfio, get_device_info)
 	ASSERT_GT(dev_info.num_irqs, 0);
 }
 
+TEST_F(guest_memfd_vfio, get_region_info)
+{
+	struct vfio_region_info reg_info = {};
+	int ret;
+
+	/* Test BAR0: 128 KiB MMIO register space */
+	reg_info.argsz = sizeof(reg_info);
+	reg_info.index = VFIO_PCI_BAR0_REGION_INDEX;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_GET_REGION_INFO, &reg_info);
+	ASSERT_EQ(0, ret);
+	ASSERT_EQ(0x20000, reg_info.size);
+	ASSERT_EQ(VFIO_REGION_INFO_FLAG_READ |
+		  VFIO_REGION_INFO_FLAG_WRITE |
+		  VFIO_REGION_INFO_FLAG_MMAP,
+		  reg_info.flags & (VFIO_REGION_INFO_FLAG_READ |
+				    VFIO_REGION_INFO_FLAG_WRITE |
+				    VFIO_REGION_INFO_FLAG_MMAP));
+
+	/* Test BAR3: 16 KiB MSI-X table and PBA */
+	memset(&reg_info, 0, sizeof(reg_info));
+	reg_info.argsz = sizeof(reg_info);
+	reg_info.index = VFIO_PCI_BAR3_REGION_INDEX;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_GET_REGION_INFO, &reg_info);
+	ASSERT_EQ(0, ret);
+	ASSERT_EQ(0x4000, reg_info.size);
+
+	/* Test PCIe Config Space: 4096 bytes extended config */
+	memset(&reg_info, 0, sizeof(reg_info));
+	reg_info.argsz = sizeof(reg_info);
+	reg_info.index = VFIO_PCI_CONFIG_REGION_INDEX;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_GET_REGION_INFO, &reg_info);
+	ASSERT_EQ(0, ret);
+	ASSERT_EQ(PCI_CFG_SPACE_EXP_SIZE, reg_info.size);
+	ASSERT_EQ(VFIO_REGION_INFO_FLAG_READ | VFIO_REGION_INFO_FLAG_WRITE,
+		  reg_info.flags & (VFIO_REGION_INFO_FLAG_READ |
+				    VFIO_REGION_INFO_FLAG_WRITE));
+}
+
 TEST_HARNESS_MAIN

-- 
2.56.0.455.g6c5a503b38-goog



