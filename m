Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EAE7606A82B
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IK/m6TYo
Received: by kanga.kvack.org (Postfix)
	id 5D8E56B05F5; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B0866B05F6; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C6906B05F7; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F3376B05F5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:21 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D5D191201B3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:20 +0000 (UTC)
X-FDA: 85406459040.11.1E2E9CD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id D529140002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IK/m6TYo";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011838;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pkX5RglPGJDEhnslhp8xP4OHF0T6ris68N5dtaSSV90=;
	b=uD3MX727gXNohaSIWFoFhBs16h35H+Q2A6WmkRwcj6ZKmkR15T048IlWnu7689eaL573hc
	Ip01dCrGUziRfiWrUuzr6JeNQxBrACqO/wk1lzNaqG0kvHWt0XA4DnohwpOn7zorHN7sUy
	0vS85vBl03TTplM+KvaRTrnzrtouaio=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="IK/m6TYo";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011838;
	b=J9Tf/jDl3OjFRcAkD9lr+g1WGCT5Da1e0h/yjux1VMlebgfQQtT4CTBBDlZxlc9SsDFrxj
	AHhUFzNVNInD11q2SQmsocg7XKLCjfvspLlO84TS959m8qjxPMClyK2Y1gtdBBtYdx/vKp
	A4TFiAhwys5e8r2OBiAbR5IDzR37DRA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AA41060F36;
	Sat,  7 Nov 2026 00:37:18 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011838;
	b=jIhZc3YtIfe5cGjupmPKguq3MIOc4IViaBNarp0kezszBSIFeD+vPD8seCd1Al+3SJEO
	 VR34ACWL7VVY8kCdC65950LNEgqgK1t+Ly18bwxDs5JBsTmc04v4dh+6cPoOy+LUtpDhF
	 nJmORB1n0eS6nCeZ9g27wqIPq/rXu7vM+0Kjcq2fDBsyVMOt3akP9k2chiNCyG8UAKJQn
	 UTzsv8hJ7DEa/H66j6Aq8t78biqBmEc0nIUV5QN7Rr2vqpfzJ2hqMunHEsEV0nznp5yzH
	 7cPKLI+RD0ckxbb/xKrYqV5c7dl6ZYEJCRheBpen4BrhwrmCgQmvgdVCL0UzQh12N7g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011838;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=pkX5RglPGJDEhnslhp8xP4OHF0T6ris68N5dtaSSV90=;
	b=znU0U+Bvk6MTU7HjAJKMKPgZMxkvgaHbhXJJOQhopEd4l3ntegVilnlcOKygdcedpREH
	 dRU1Y4TXK50KyaDv52X3RTTIl7V6EUcaH8vuRKYA57BOSC7sRaAbcVNL+k+8rOo3FpeBB
	 mzd5aaiah9WMFQ8JOZ7yHd2T+upw8XvoSTOpr1ooVRWkFQPsGYvFkU7425vcqD/RvQSUC
	 VeC4fktfigpFXrrZfYM8pxGrDhBaKMhNz/XCjOpjmSvcFCy36u+2alrlTveh75ZLgTEgJ
	 OM76TdLjoRpoEX0YpFSg3vsSnxkllePOTWARQa5ymFaFOPMdVADiDZmJOYDN7hFD+Dg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1F5AB1F00925;
	Sat,  7 Nov 2026 00:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011838;
	bh=pkX5RglPGJDEhnslhp8xP4OHF0T6ris68N5dtaSSV90=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=IK/m6TYodvJPSVDageZXSBAYTxQxbGrpYMBiiX865Fpf4W5Xl9gj22vVhvpjq0Ve7
	 bCe04St6ikuvo9AjP6+boQR7205VjcIvKyvfudmdaD/gH9zidXt+LF1/gDbsTxcp8l
	 r8BEC4wBThd9pPL8u8Xy9T9/0PHLU+fc7PUqhEB5HnpJAWFOwmw91kI45v5o1/tww+
	 KbSjbMNLOPJkZsZuK25UYWA0muMoflzeKQOTXbSznzaMQJnzMN2JAPjZGpvKk7ytKj
	 INtVQhNY88zlGGVQZtp0bOlJbHKQmbxSu6/7FUK0IBpZCKclHC8ot5C9pwEWX4kKxk
	 GMS3EHMSEy06Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 708A547A55;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:57 -0800
Subject: [PATCH RFC v3 83/88] KVM: selftests: Verify VFIO ioeventfd
 creation for igb device
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-83-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=2410;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=lOTB0T1ZgH2qBwxbzF1p5KVxU2nrnnE76xPmcwyhgYk=;
 b=dWWgKLHu4omBOrcbWgEzhyA8WgLPlocfMYQX0wM811XEqldFlmfdRwW/DSH6jtFRb5JzYUcHE
 Z8Q/wpLQ65VBYUKMm9/i2vELQblt1W1Vak0UmJun4RPZLtCa7JjWqVb
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D529140002
X-Stat-Signature: idfnht8k3gjcqkjycu6xk9qxj58er76u
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011838-19134
X-HE-Meta: U2FsdGVkX1/NuZFCdUNKolC//yyxj9G4nWxDtrRVuB5x1ZoqSnKMWfDcBg170423Q8YnBdX7op0eGigiLsbCwzuPm7yQWsBY0zR3NILJj3jjUyqMBb0xAhpO89ooyvi3eavOrVLcZXQQ89g6XVtJcj2/6w7fqZu42pHIhTRmAOoGJQJsZhI22Pr2b8tG9sslGAt9kcA8I0djva+QzA+5APG3A9YQRLGllJPuuZKqzp6h5RKHJs5dyNb9IYd6i2GWBvhyhEi1O5wz52akRXpjftYm0xTT/jkB0pfOQ8qawRa4Doj4zduQwuxbVPBS5j4k+qNkuBkBD4pu7CSQzhvI43Gtcq2IAwJhyFXIz6uBJzDGtR/ThhesJCdeBiqsQ0rmQGWwQlIi96l0X1mrNblrFpXNOojcfWyDrbDMMsk/JYn33Q+L1ft3qor4QW63cci8h/KW0EMqmYW3FNdPcI6TrKnL96fpYzEavXDgoCSv9Hheq2Gp8EqBHvJU/uaTGcK9gtY0YBzdJmxnUB/Qbdl0Fxv9JZZccBiIxYj8fwc7YCfe9xiqLwHnRaH2yzkwoycnvMGJZ5ekZyUSVSdl7cV6Yhf9X/o8S2YWHL6L/Ls3v+cWOXFJj7IHepKxHrrBCQRf9hEg88WYRTNlvqpJCtPKtyt4OedAu18T0PHe4M78O3i+e9B1u8kTVXbKlXbf3aPUJIhhr7M9DZDcpB+wmA+/ZTyks7hr09ZhhW+RHCmqbngzmfaIx7Pp1A4VvX1R471CsyW/8x16vYmjQY8hT73Z9Q9zPoSfaXIZuEJ/WSgNlMLaUjWwJ3Zcxfvc4tKBsxG554Ou0w8/4dg8E9JSddXWAEIV5nvMeqB0ILtAq8YiFUGSGScCbO9lfgvIy6YDOgMs45EbEHdc+HJskZoCWliIyuHYT12R++ElztEvKG+Pms2LOi4kS7GvqLOLY83TMO7491w9a8h+r7IlyeszTvv
 XbTOvE/6
 x8MEKhVZab0Nie0chfX9j43TmwNKjypT/VMhV0nWjdpWJIxjjdbNBR9O6BcDaZd12BYT3EzHzGnxyoDJib24w3I32gRFs3bJD85/37lITIEsECSjOfARa+fIdgsUT4EgxQhCl07SDAiDUqRpmm8PwRJWPZ76wUbAe38u9KXOJrWz4pWSYnohCNeLRih9BkbkK1IIY90mHOJijrP/kpCBKE0H+Q5PQjjqnd3U5AaZ7+PpFAHcJCvI2T5zkLZ1sj4wbTOdPF6diwRqBQC2E8BGy5IeCVRCGlC/JQadWg6yYWkPkNmvf1ahUETULIFsF+q0ozze/eN9oF4DQ0KmdxhlnDzl13Mh7XkRtQSjXf997CjJn3112Y94Bc3BfN5u+NocYzggaWT6s+g6sHl3uDpJ8PD1vf/8/T4tF0zXDWhr+OSoo4BaJcRvj9mMFa83rig9bs6tBstQqUkjjplW5hcsCXilRknPfN6v//cC9J8IW0u1RnMb61+yBL1AGKqcxIIb9sPy3CA20g3OpffBOs3DIT8EgXnXU3nciSjpSV4YCYQSp5eM2/n49WYhBHwD7k0QN1n/OEuQF4Kjm3Rb7Na3Sbv2j6Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add a subtest to verify ioeventfd registration and unregistration on
the bound Intel 82576 device.

Allocate an eventfd and configure a VFIO_DEVICE_IOEVENTFD ioctl targeting
the scratch receive address low (RAL0) register in BAR0 with 4-byte width
and a test trigger value.

Assert that in direct mode registration succeeds and that unregistration
(passing fd = -1 with matching register criteria) succeeds cleanly.
In guest_memfd mode, verify that ioeventfd registration is rejected with
-EOPNOTSUPP.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 .../selftests/kvm/x86/guest_memfd_vfio_test.c      | 39 ++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
index 46d325228bda3..dde249571ebc4 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_vfio_test.c
@@ -10,6 +10,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
+#include <sys/eventfd.h>
 #include <sys/ioctl.h>
 #include <sys/mman.h>
 #include <sys/types.h>
@@ -725,4 +726,42 @@ TEST_F(guest_memfd_vfio, dmabuf_creation)
 	free(feat);
 }
 
+TEST_F(guest_memfd_vfio, ioeventfd_creation)
+{
+	struct vfio_device_ioeventfd ioeventfd = {};
+	struct vfio_region_info bar0_info = {};
+	int ret;
+	int efd;
+
+	bar0_info.argsz = sizeof(bar0_info);
+	bar0_info.index = VFIO_PCI_BAR0_REGION_INDEX;
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_GET_REGION_INFO, &bar0_info);
+	ASSERT_EQ(0, ret);
+
+	efd = eventfd(0, EFD_CLOEXEC);
+	ASSERT_GE(efd, 0);
+
+	/* Register ioeventfd on BAR0 targeting RAL0 with 4-byte width */
+	ioeventfd.argsz = sizeof(ioeventfd);
+	ioeventfd.flags = VFIO_DEVICE_IOEVENTFD_32;
+	ioeventfd.offset = bar0_info.offset + E1000_RAL0;
+	ioeventfd.data = 0xdeadbeef;
+	ioeventfd.fd = efd;
+
+	ret = ioctl(self->vfio_fd, VFIO_DEVICE_IOEVENTFD, &ioeventfd);
+	if (variant->use_gmem) {
+		ASSERT_LT(ret, 0);
+		ASSERT_EQ(EOPNOTSUPP, errno);
+	} else {
+		ASSERT_EQ(0, ret);
+
+		/* Unregister ioeventfd by passing fd = -1 with identical match criteria */
+		ioeventfd.fd = -1;
+		ret = ioctl(self->vfio_fd, VFIO_DEVICE_IOEVENTFD, &ioeventfd);
+		ASSERT_EQ(0, ret);
+	}
+
+	close(efd);
+}
+
 TEST_HARNESS_MAIN

-- 
2.56.0.455.g6c5a503b38-goog



