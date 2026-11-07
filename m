Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D4F16089FE8
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KxeMzZvU
Received: by kanga.kvack.org (Postfix)
	id B08D76B05D1; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB9B16B05D2; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 932836B05D1; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 642D16B05D0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:10 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 006F21C30B3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:09 +0000 (UTC)
X-FDA: 85406458578.04.A6FC7CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id DEE9240006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KxeMzZvU;
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011828;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zb9+5k0IUwH2cT00AAZTFtNkxkhXFYPW9HN27CYbDL4=;
	b=AAFI9ttpjnjsXmOblw5y2hyqrO5FlvuJf5bRCjM/vTb3bYWHSiujHMc3PXG1K75Gc47jfm
	eF7LB07ScnxYiGzOKEdMNgGFCP+q5NlLZGRP4TB04/40SG8xshH0ooRQVhUnNkZu0xHfnv
	5x4+T+HjXIdelSYUofTpX9afeNFjZ+I=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011828;
	b=IhcFZRjgwD2NQFOHREW/zA1kxIg07qefHDJQxcTLrpY9Q5X6mIobXP3BRYmtSIKpE7/jbj
	InnQ8MoBAzoEirYhs5/cHdpWTAJqH1owE7BUbPSGBJqTVGtdl411ENimhUxWgKAFNMPVW0
	qK1ptRkimwbT2xyUgHW80oobd2qxyZ8=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KxeMzZvU;
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 17B964429B;
	Sat,  7 Nov 2026 00:37:07 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011827;
	b=aWX3Q35/7a5A5/Ijl+tyTdHXI8v7ZaR+4J8Y0eDa579riyBESTCisS+t9EZp7g1RGzID
	 tUcK2LUow8K6EW7htPYp9dn9byPZaXwrYdehQXh+VAqMgmJ8DDtFHboct/ZXxXrlLRjTH
	 kht3qA2T+4Rj9aiqLjdB/kpoEBP8Q0bsNeFlslWv3HpYUbDAJ+bkj4YSFcT6vOoKxfwt2
	 TwSxUz97OVjQJqO95zszOnDkthUXH5KbkbrkACmqfG97j+/F+jtoHF6lMYR39L65QbdTQ
	 XxjmQZZH4xF6HE+VugFT/ilp3P2ZYSEguIdW/ccLxnEXOqw2EmIkbLBpvflYfOuVxBQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011827;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=zb9+5k0IUwH2cT00AAZTFtNkxkhXFYPW9HN27CYbDL4=;
	b=faplxL3OCtnY5hXU2kAHzLIGBSThAs6mfgK3j2ZrUFEN86Bp7rfyRvX6afbX+kD0CmCb
	 It28Re7UgJ+168COA45sDtsUzCh0xKNj+wmDPdbH0AXDZCaEdXxZ0u6z0ux8xDBgUITGH
	 vmed8NYBsJjEKsj0ydmPrWjsSrzjNTkaftaJGyLMp9qYIvzEhGGL1++qfZv1d23XBE3Nd
	 9GoR5PzEUcuEOjM+mTZKBBb6s/Z92qxN/1il09Fm70dPoQdGSbU7M1dFZ3OvEiXdnz8qG
	 CyMwPBWFDI8TuRJVLvg8au1kgpNF5F3W1qmvSLw/Fx8ZGdkjoutJr2SrrbPtwNQ9vhQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 496541F008A7;
	Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011826;
	bh=zb9+5k0IUwH2cT00AAZTFtNkxkhXFYPW9HN27CYbDL4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=KxeMzZvUVygv9Ea8tcUt1Dq8CspODexD7Q2DFav1TBSwV/SOiXkbtyLHw2ktGsY9y
	 pWbvDhLJqxKLdThAqlXC32fb6UAY6tjFyvaMAnyui8j1qywEAG3S4l2sh53zk0waFM
	 9lDo09uxdIAiEBOV3Xj524G6XSJebVT0Fc8HwK4P16scXw47T0hBekTacp3bgi6Lur
	 xnXD6ast3SbkD/i4ukK+ujeascbGmlQwNXa+qHReCd8X9p2qt8ZoqCOOaPR2bry+UF
	 nMEDwnODG2l4TSvH5DlA734x+OazCzfmAauQ90A9oe+wb+2YPQY+I51w7xUlKvWlYx
	 kpjn8WwoihGmA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 6BC8B47934;
	Sat,  7 Nov 2026 00:36:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:36:42 -0800
Subject: [PATCH RFC v3 08/88] KVM: selftests: Test rejection of unsupported
 filesystem for resource_fd
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-8-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=1756;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=0ahPMSc6GtBF8lWLRrGCjyFX000iueLLA9MpljWJTxQ=;
 b=PvnkTfeMSI+t3ucJfNd1mZ7x+KS1+9FHkGY+aR9D7rUyf4LZsXEbHZeztXx+YOAdA17lUmiQF
 NZKrEo072OSCPtKiqKZNY7dq5N9ZkuAR+ZEAyjf8uJM6EpZh/pKJboe
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: i95h995yn3nrkft7qje8ekz63x95exsk
X-Rspamd-Queue-Id: DEE9240006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011827-363225
X-HE-Meta: U2FsdGVkX199W5Q54YbVMTk7EphNKZgpJcFb54cnCtg17GTRHoB3D6jOFx5ZTzEvDAVLTjYTm1Pq42hwoANBmwFuupmK56mtHS7NyxKYOUrR8kM1bnxv5s5QtMJCBDv0EDFRRKjBc3Heum8K/I1FJ4pZ1moYmPa1SinDBNy9CZa7U9RH4hOctvUzr9tCTAmPiAtobUOvpFPtYEpqp5d2RgHxCwIfei9pbwPWKbCsTaV3Cf/aOkCyUzDbyKJJt+qfpcUKpQ1twF2WorHlL4VsCccGRO8Y8vzvQzF4x1vCkzw5oAQq6e1LZcbEQUfxoLTY1Y+rtEFWqNlFiHYuxg2l5pgAlDTdyH8upRTRECS8nJidIRxuGSJNN4IL3tfR2hrd18wdZ5XgoUJUa4uNo/XENKNE62h/qkWsITAv2irye4a1BrGVcR1leAYFoG1Jn1SqQJCRYcZ45xliPEy4fYyjrQu39TakBF+Xwk6M0U2Ay+6A7PHVBlmHwMQppa0SU+bkEnKURBu+2HqqCjFmphwclVl53iBrz+lp6lhVvXmVFrz9mkNeZnqzudtOGhi+eZ1M3UjtHmVzH6MGZpDRNDjRl9tXOlvr56AsDwl8F/iTIGllN5jcJsDUFcMGVKBHc1zxYLtq0I9eHOwq/vhXWsllxLCitVVaKwgDEm12L+iAVLAJkdfAEAs9OyIvUZdSbF1hsSiwXPE1I8temXjjC0nU0FjccqzWBSRBq75YpfAWv2dBXTddg+My/8+eNN9xTghG0gTesQLz1s141DfxIX/Uzs+MmcYRsdVI1D/NJFaL97jMjtP5E2kMnGhZgWGFZRw1EWWgIGfdiwMDKYGvx0WrJpblJzoeeHEz6U1ZoVALGP10BC19MTYNW/alnoQEeHsUT1+Zn+EMG2hv3+jo/8Fe8WVRGPq8MVQ+d2L8DUIIHj9vCBGtcVHBYzJQ3Rv8bjw7ViofELuhY3R1ErJBaNz
 a+V2KGl2
 sKoiadEeHXzj3DX0xupZ8yxwPJyBfAewxwup7d5LDhc0Fd+cvtGhgsYK1I3UK91AFvUxSOxD8qG0OUykskBK9ObtnQbnf4TvP4wIC0SxTNk8BeeUkCzeEBGL65aUUE24A8QD/a35RtKxL/3P2dKFtlMRjz+CaOOcn0yPPX6kCMx+JsTmYtp6zeM5uCBu8VtA+6AnVSzf9o8brYkHqL8Pyqwdslvmbnf/BxA/PE6AwkKh27U0CvwsPT4p7ZkvjIxJ0qi/Zk3msCrAY4VdVI+IwU0fpJowWsSOv2+uSsN8lnFU8eKKj8IHJYZc76phMQeAECP+G5jpkH36NIILOOgAhiYo9L7Awph1VHvyorvOiO/XEWFsPfHOgviGZa69gX+EGhJEd6cGIyOp3Ow813B7f3QFFXZ9L5ryKXu299k0KhAPFhvSTrQoWVecftaBwMzBddx9HHCML7ejN/tKbInH22C6ycaRKXjJHbblUC9sS4+/8TAKz7rlzcpT1pSBhp3w5mpIZcRc6MYisgBDT3FzjWijIcjl8wacZvRlhcPpSMnasQtD3oAF0JZhxxgUZ1iIWVCWfBEIxJzMrwkW51pKOAG7jrGmi399rZq8i
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add test coverage verifying that passing a directory file descriptor
from an unsupported filesystem without provider operations as a resource
file fails with EOPNOTSUPP.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 3313d306c0bdc..445396860d819 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -436,6 +436,27 @@ static void test_resource_fd_invalid(struct kvm_vm *vm)
 	TEST_ASSERT_EQ(errno, EBADF);
 }
 
+static void test_resource_fd_unsupported_fs(struct kvm_vm *vm)
+{
+	int fd, file_fd;
+
+	/*
+	 * Passing an FD from an unsupported filesystem without provider ops
+	 * (e.g. the /proc mount root directory) is rejected by KVM with
+	 * EOPNOTSUPP.
+	 */
+	file_fd = open("/proc", O_DIRECTORY | O_RDONLY);
+	TEST_ASSERT(file_fd >= 0, "open /proc failed");
+
+	fd = __vm_create_guest_memfd_resource(vm, page_size,
+					      GUEST_MEMFD_FLAG_USE_RESOURCE,
+					      file_fd);
+	TEST_ASSERT(fd < 0, "guest_memfd with /proc fd should fail");
+	TEST_ASSERT_EQ(errno, EOPNOTSUPP);
+
+	close(file_fd);
+}
+
 #define ____gmem_test(__test, __vm, __flags, __gmem_size, args...)	\
 do {									\
 	int fd = vm_create_guest_memfd(__vm, __gmem_size, __flags);	\
@@ -495,6 +516,7 @@ static void test_guest_memfd(unsigned long vm_type)
 	test_guest_memfd_flags(vm);
 
 	test_resource_fd_invalid(vm);
+	test_resource_fd_unsupported_fs(vm);
 
 	__test_guest_memfd(vm, 0);
 

-- 
2.56.0.455.g6c5a503b38-goog



