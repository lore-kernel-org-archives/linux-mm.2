Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4EE1F606A82F
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:41:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hazlIY6T
Received: by kanga.kvack.org (Postfix)
	id 84C7B6B05FF; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AE746B0602; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64D346B0604; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 38AB86B05FF
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:23 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D566C1A01EC
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:22 +0000 (UTC)
X-FDA: 85406459124.11.99967BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id CAF0940009
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:20 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hazlIY6T;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011841;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0nkKW4qaDx3asj2guFXILmxbH04Ei7Qw0v+PRGtBfmM=;
	b=Ivo0JNMzuAV7sD9tSBFLuYpD+htWaBvrm7WAZYXafiuvTeEsQ6KryLtVcDONlKMHs4uXuG
	lkHzfFbKplldSIBo3mtjkP+tkdg9Y6d0qBIGhwUvmg4Ig3hpBKAQCfGXBnt+nVkP5nlHOQ
	JbxVIE46H2ZiKDXwMVeyjJQUxU0QQik=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011841;
	b=AWhGuIhl42lw08rOKSXIwrmswR00QjOl4Cu5fUDM463fjdPEEVcWqihwsdqQBzsJDt2XZg
	Z4oqsmWjXe6JsgbsDC6p584YFoGRaC5mSIXvgY30LjcwMW0iK5Gk/x2DPYj4MSwxYVj7Y6
	PcuuhjWYQwWDKaS3uc0LacRE4TUeq94=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hazlIY6T;
	spf=pass (imf27.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D311844030;
	Sat,  7 Nov 2026 00:37:19 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011839;
	b=i3OjkfOEm6IXp1VyiCWIyLE8QFPCgCTpa9ToPd1NL9YXN/iV4mZfAp8VDWdWp83YIXfo
	 AFyYe52P736v5tjTqrEFeyuxdYDOMKejSwrTT0duKlszhQHP44b6rjO053RTbThhKGgdN
	 tAcfPI8G/BBLOkCho1W8jVEY4XYKaIphx/PMvTXC2QMemgHVAWylX8CPB17HOb2J1dQ2s
	 AOaVa7jCkaIzOY2okmZxzW3RtX2a4SUwv5efZFdP5fJXpqarjNLy516BFk+qBm2g3pXE2
	 B812GoLlHdSsT/uCof1lrZUaM1tIDszuoIa+a2hCPM0eUPaKv1AGMu4IvQdryWVFIbg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011839;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=0nkKW4qaDx3asj2guFXILmxbH04Ei7Qw0v+PRGtBfmM=;
	b=zrZ65MbsloqKg+o34ShyiAI9rC2PdFU0auT0c6t+rwvqRHuiVYq0Js7Kb9J1HpXZzwrF
	 M9o1X/LSpwMLqNyH44cx8gH38t7sLyo7qm9oOyTzw/SWaXNqGB4dRP16OYJ6K5KbnOyMW
	 SscE/01qzIzluMwEejpGYK8b3oZwxudmvxO4/GwNC2k7lrXSH9+VbLZ5DrqMSAJOdKbRF
	 PPWqatBwQi/yepuWx33Ovn9LmypTB/Ym+Xqo1Krim2rAV8a39AFJdF9pCYK+xC/SL0W/6
	 ObPtZsk0fJHicBdoPqkY0ZXGD+n/MQ/+fs5J6y2moaM5+21woDpqVTD08lddCQCZ28g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 420141F00901;
	Sat,  7 Nov 2026 00:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011839;
	bh=0nkKW4qaDx3asj2guFXILmxbH04Ei7Qw0v+PRGtBfmM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=hazlIY6TaUYJJBHK20yeEie7vDuC4nIuUs6rgF5AWjaAsWS2CR3tdgWF9zrpnxyfQ
	 dlLfxX/O+9rSMGB3ImgNqjX7jRPH8TaUg3lRxijCT+c6OdznXVyiyJrVwFWEK59Gun
	 SEuQlLLYn4z6QF2wQnJUlHlPrqTQSa249YP3JFjHvI+bD7ZSOJEKcY3Lp2hWCRn1Im
	 GkUa+f5Uj0W2D06vn9830RKJxd/TlXD0zUqdlfFW0ZUFlKoOZs7GKWjIbSQTY0/xPG
	 iak9/tablOE2/IwsA/R76zv8LkqFWlwwUXHlSSjeYMKEx/CKcdyBL5pBWIX7H+IqA3
	 jKFMSj8pbiIUw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 18F5847A3F;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:51 -0800
Subject: [PATCH RFC v3 77/88] KVM: selftests: Verify VFIO device reset for
 igb device
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-77-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=2756;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=jIcxaC8x28xPsLi5SMudkDfabTx4GIIOp8BRTMbwoBw=;
 b=22zVgyg/vzsiW0zlhJ3ne60GqMpiyEfDMQk6bsvNnD6uIZt2eSXJ3foj8SNHHIzAaGagwcB/5
 y8itLkPWPqaCVForcElwYW6W+a1qYjsL6jumqYkGxAoeFuJhkUTZucc
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: yn81ubgurhy4zckf7a7jjsu7jaair5uo
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: CAF0940009
X-Rspam-User: 
X-HE-Tag: 1794011840-378328
X-HE-Meta: U2FsdGVkX1+VPHvOSrPVSQsS0PPlI933fl42U8sdzqkE5XJmF+QYl3Uixf8KKuT77j8OobPdlS8XQjudDfgJygeeCVS0JWUOq7SvwN+PkhTKiapGdqVHDE6oCLZ3pAnllN5oDTXn9CYmUDGtffyRXKpOnViHFJGaoWktoYtennSDZwdnKlykdVCEcY5dS7KMxiVVwshP635c0WlWUISFC00unqA9kBfw42gA4cOOQpej0Eiaz+r/oD7xD3kHzM/cCYRLgampXvhelbKGcZwMjF/rrgKL0YENcvzcE/1egQsUUR1FT3QFOjptMSnGamtywFkwm+ji5h+UAxcuxL/sypyGW1TNzG4OU/MeDYmQpuSxdXy+PN6Fn9RBvmPAMpWaxFjbQ4e/ov5UkKsrmCE/oezwy0XYg/ECnFZ+DsQqIufPyb6wpsc/IlbwXXUmJ96dM0MYdkMICTVmwmiImZk4oA4RETxRmMTq5es3XCnsX1EjMhxLEfFbQpJALMP8V4swYImgg1CcqkZlFPHAxH3PF2Q18Z7J0QNanbWDvdh7vTz1p7qvJco8O2SgA/tr0+Ue0EEjJ3jgXdnqvbacYg32IMM2opd9csGr2SSFtIV7wQpPI4wpAXw9FIz5vD3GuyQAoRmkXfCyk8QTKRkTR1xeznzcbWdQwIy8dPRhvd1OBNBnyaZ51UNfL4pBaXf+cgn3JlgRjiDQf9EU8HwAxLKDlVxfVDGSNzFrTI2yb/i+gEEiUornfx5rrqGJpWwS2pMfv2tV0+qMuZ6o9KzphiP3uucjxmE3nwAf3xRZbx+4ztm7msEkeRjdXNiqcmvafhnxGHoN/GE9B2gFmc484RHT4PWBILwsAYbYcRwVY9gYLR8ZEUto6nOdSZJNr303ZWIwwQcrmVdy6OQdRRa3hdy5ad2nWqUgG0xMAkFr99SuS7E+Dzu5d8RDwvsaLFpU4LuUzbMqlafkQmJSnjHW9Th
 fZNbG/b/
 0F4DbjbkF4g5QEyNFbvxfgqwBIl0Vh6FaTeZBK37tlo4s6TVwKfpVwBAZZl/4LOAcigbtlMbUtyyXVyNh8DJu7ERPQaHY3TwWHNOmPEy2DzGGhgbD6Kd/N3TitcnOJtUhmlmqH1Azmsm0wjzb7ewFW+1AZagixWAsWK5NHO8UL6CA7Q1B0SJk8NpZPCd+UhTwnP9DIqvJbTrewxaAYfa2EhVJwCJfMrT6XycUZUyVmuVeiwb9b6Dy+/E/AvedEejCPQtq6UK9POob6Y3TGtvc2zdEE5lLwUSGVwZBrqZ98M3mNAAamr4yqYT1BUMaPd7P3CosD6JidwZNKMrjlOl55YwhmCxwmh8bOXaJraky+SD/nFBtm/wsS3QKcsWkD6str1h55tRpbiG/t0n7silzmLtrO3DREzT8tLjtQm3fm0nw1XKIRKUvUlb5bLO654pdFOLLGjdqw1Hlz+g30zwgOq+paxNwBU+tTKCUiRR6m2B/UDe/wOFfrJAlrs22pjzKe4blohIind2YkcRiJw998n3ZsrRALy/D2fcwxXlDP5nqm5Nr7Oys+pAs4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add a subtest for VFIO_DEVICE_RESET on the bound Intel 82576 device.

Configure PCI command space to enable memory decode, map BAR0, and write
a distinct test pattern to the scratch receive address low (RAL0) register.

Trigger a device reset via the VFIO device ioctl, handling potential lock
contention with retry logic. Re-enable memory decode post-reset and assert
that the scratch register pattern reverted to its hardware reset value.

This verifies hardware reset lifecycle behavior, establishing a baseline
to later confirm that resetting a device revokes access when BAR0 is
wrapped by guest_memfd.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/guest_memfd_vfio_test.c      | 45 ++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
index 4d5211b6acf79..91cba359e4392 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
@@ -331,4 +331,49 @@ TEST_F(guest_memfd_vfio, bar_mmap)
 	ASSERT_EQ(0, munmap(bar0, bar0_info.size));
 }
 
+TEST_F(guest_memfd_vfio, device_reset)
+{
+	struct vfio_region_info bar0_info = {};
+	uint32_t val;
+	void *bar0;
+	int retries = 20;
+	int ret;
+
+	vfio_pci_enable_memory_and_bus_master(_metadata, self->vfio_fd);
+
+	bar0_info.argsz = sizeof(bar0_info);
+	bar0_info.index = VFIO_PCI_BAR0_REGION_INDEX;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_GET_REGION_INFO, &bar0_info);
+	ASSERT_EQ(0, ret);
+
+	bar0 = mmap(NULL, bar0_info.size, PROT_READ | PROT_WRITE, MAP_SHARED,
+		    self->vfio_fd, bar0_info.offset);
+	ASSERT_NE(MAP_FAILED, bar0);
+
+	/* Write scratch test pattern to RAL0 */
+	WRITE_ONCE(*(uint32_t *)((char *)bar0 + E1000_RAL0), 0xdeadbeef);
+	val = READ_ONCE(*(uint32_t *)((char *)bar0 + E1000_RAL0));
+	ASSERT_EQ(0xdeadbeef, val);
+
+	/* Trigger VFIO_DEVICE_RESET, handling possible lock contention (-EAGAIN) */
+	do {
+		ret = ioctl(self->vfio_fd, VFIO_DEVICE_RESET, NULL);
+		if (ret != 0 && errno == EAGAIN)
+			usleep(10000);
+	} while (ret != 0 && errno == EAGAIN && retries-- > 0);
+	ASSERT_EQ(0, ret);
+
+	/*
+	 * After device reset, PCI Command register memory decode is cleared by
+	 * hardware. Re-enable it to access BAR0 registers again.
+	 */
+	vfio_pci_enable_memory_and_bus_master(_metadata, self->vfio_fd);
+
+	/* Verify RAL0 was reset and reverted from scratch pattern */
+	val = READ_ONCE(*(uint32_t *)((char *)bar0 + E1000_RAL0));
+	ASSERT_NE(0xdeadbeef, val);
+
+	ASSERT_EQ(0, munmap(bar0, bar0_info.size));
+}
+
 TEST_HARNESS_MAIN

-- 
2.56.0.455.g6c5a503b38-goog



