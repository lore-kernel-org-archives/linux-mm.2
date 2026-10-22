Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624E46075D80
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DG7HU12f
Received: by kanga.kvack.org (Postfix)
	id CE98D6B0A2D; Thu, 22 Oct 2026 19:27:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBF986B0A2E; Thu, 22 Oct 2026 19:27:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B610D6B0A2F; Thu, 22 Oct 2026 19:27:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81EDC6B0A2D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:27:59 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B9C6612033A
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:27:58 +0000 (UTC)
X-FDA: 85351852236.20.6EE615F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id B3654C0004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:27:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DG7HU12f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf28.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711676;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mw8NuWe2zt3uYUYLmdslwurewyfFMdDfAeZucA82mOY=;
	b=vE+zzvFDnyVsZ8iJ6ACF/YHFfNJnqSi4v6DqoZuMxSKh64XEQ14oTSfv6EPY7F2QwiadK2
	Ohc4nVd13uLnCRs+b9X6FDfd6vY0s5W1BDrz0W7k4jBjhca0EKsgvygCUJluWXN801hTLa
	aXjV5QbZoONBZleGCS3X/NJrldmEq68=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DG7HU12f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf28.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711676;
	b=HVPRN8NkURrA6VcbS1QgP6EHVwcFqltmjHqm4ihzUiNfpHlHkqDmD+fEIr4pGz6+ETdpqx
	E5PIBtjB7EY4NnO1K15d9h0hUwwPjqg9Hksf792Tl1QzVB0zjAekAlvKFNwT1LFIkynDcO
	rJ0ZwB57sGoj86l6ER663syGeDAdadw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5195C60AA3;
	Thu, 22 Oct 2026 23:27:56 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711676;
	b=Ibj16u5/bIRb0iNZk3zDQYwojotUEHCdOPDwM0csqkXRoCYqMJkWWoGFIkM22d/L9HmJ
	 H8+eLv43Wroi2SUA7ZIAG1Ql12mOFkCwKIYsrH2aqe2KzodLBCh+gQ0tUhahIAM7xoQ0B
	 ilva1KVoiwxroJUQzUQiYPWyB9MwItmJRqr22SoubxP6FUD3stbaArNo9bWwEqIn7tLNG
	 dIEE8jlRoO4Ao7VBX0DMNkj8ctphqdjTgSx5NdNiqpy6lXBFfglYvhksbTfAVqBA/WfsO
	 7j55xDUeJjgnr5KNQEzUKtQH/0YOYnvvU9U9TZadmCFvVRMWHub5LslCv+W5EruxmyA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711676;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Mw8NuWe2zt3uYUYLmdslwurewyfFMdDfAeZucA82mOY=;
	b=gkp+MIEIIK0WwRwQBspHz0Ug3TYopEIJUeN3dWhUQTuM9/bO1Ppy32+rVnvo4gPsWFXn
	 Hwk+mpHHZJ6Li3Z60AzhnRURUqcd4XkBJ7bEi7C6Rvl5qAP51SuhqmZ22HyJa8waE/vzo
	 vl4NnRb8l4JTAxI032gN2WV+HhtjCvcpzIq1PtS619c5PBuoPFxLCtcxor610AtE2ewyH
	 fiNhHrMcS3aPZH1ty/kW403Ap7NUnTmo4pM4gBo8m7MijzOWi3wDSJkHSOvk8lgdCKa3D
	 y3VnETCptW5ALMXWbJlMQXAhp7wCqIwF3Z2YHXF9j+wuaR57a75C+AWYVu0Y6OgYD6w==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 2EB631F031ED;
	Thu, 22 Oct 2026 23:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711676;
	bh=Mw8NuWe2zt3uYUYLmdslwurewyfFMdDfAeZucA82mOY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=DG7HU12fCW7Ul9TeYaF8WXju1U3fRV6dSKP8Zo5SyWXPL3j7JLlHg7+L/oNHCHr3u
	 PfMIZDPm+hJZLPo79G1+eaDuIxHld/Ld3PQiqS6sx6OsVoAyio1fP5Az8P3N7LFf01
	 kndl3QAQN/aLegK+5A75g2IetIk01Y4KZ8O1zukE99woUtAYezf0zCf0sXDHYJtfSo
	 r3ZqFPuBvGItzEoIHNxVlTqII0VQOWp3WSP3IDu07XH/YWqf05F0gQohf+cMAR15KI
	 7ciKv0w0an7+IaghWduTvLXFxlnoiUzBMQE3ihz3xyFzLXguBYDbODnMnVDPNIPSRe
	 tjHuyjhOJ4FFg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 9BCD542062;
	Thu, 22 Oct 2026 23:27:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:40 -0700
Subject: [PATCH RFC v2 08/50] KVM: selftests: Test rejection of unsupported
 filesystem for resource_fd
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-8-5dd1dc6c660a@google.com>
References: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
In-Reply-To: <20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com>
To: Alex Williamson <alex@shazbot.org>, Alexander Graf <graf@amazon.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Alexey Kardashevskiy <aik@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Ashish Kalra <ashish.kalra@amd.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Baolu Lu <baolu.lu@linux.intel.com>, Bill Wendling <morbo@google.com>, 
 Borislav Petkov <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>, 
 Christian Brauner <brauner@kernel.org>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Connor Williamson <connordw@amazon.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, David Hildenbrand <david@kernel.org>, 
 David Rientjes <rientjes@google.com>, David Woodhouse <dwmw2@infradead.org>, 
 Erdem Aktas <erdemaktas@google.com>, Frank van der Linden <fvdl@google.com>, 
 Fred Griffoul <fgriffo@amazon.co.uk>, Fred Griffoul <griffoul@gmail.com>, 
 Gregory Price <gourry@gourry.net>, "H. Peter Anvin" <hpa@zytor.com>, 
 Hugh Dickins <hughd@google.com>, Ingo Molnar <mingo@redhat.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, 
 James Houghton <jthoughton@google.com>, Jan Kara <jack@suse.cz>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Jianxiong Gao <jxgao@google.com>, 
 Joerg Roedel <joro@8bytes.org>, Joey Gouly <joey.gouly@arm.com>, 
 John Starks <John.Starks@microsoft.com>, Jonathan Corbet <corbet@lwn.net>, 
 Justin Stitt <justinstitt@google.com>, Kevin Tian <kevin.tian@intel.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Michael Roth <michael.roth@amd.com>, Mike Rapoport <rppt@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <ndesaulniers@google.com>, 
 Nicolin Chen <nicolinc@nvidia.com>, Oliver Upton <oupton@kernel.org>, 
 Paolo Bonzini <pbonzini@redhat.com>, Pratyush Yadav <pratyush@kernel.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Robin Murphy <robin.murphy@arm.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Sean Christopherson <seanjc@google.com>, Shuah Khan <shuah@kernel.org>, 
 Steffen Eiden <seiden@linux.ibm.com>, Steven Price <steven.price@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Tarun Sahu <tarunsahu@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Tom Lendacky <thomas.lendacky@amd.com>, Tycho Andersen <tycho@kernel.org>, 
 Vishal Annapurve <vannapurve@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>, 
 Xu Yilun <yilun.xu@linux.intel.com>, Yan Zhao <yan.y.zhao@intel.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, x86@kernel.org, 
 Shuah Khan <skhan@linuxfoundation.org>, Fuad Tabba <fuad.tabba@linux.dev>
Cc: kvm@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, llvm@lists.linux.dev, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=1756;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=MKtSCk+ZsgV89o0Atosj30SncvaeVEKWTGxyjRkwt3w=;
 b=LXu+Ja9u5BkvgZlmzPdoqaK+INQtueJHsx2u2mHiJGo0Qpee/AO8GRK5ofjeZNlIF2IbkfNgX
 MPs2NATgGOTAyxWhfu7Nl1Hb2BTO+4kwolIttfLzGdtRCeA//sq6R6j
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B3654C0004
X-Stat-Signature: cgimig7tfdir6kixadkcf8gy6tgr881g
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792711676-738709
X-HE-Meta: U2FsdGVkX1/iAiRjY15p+hkWYhfc0dV7qcmvnSj8vq+TF3G106S+ROhLaI5sdNekRSTSyG+/ugfEYA8LiO/aiGwlC3hzFRB2dFtF/TxmasA6y6Uolf5Mxh9ozyA7PPgH2m3hSGVBF41LK3SSLTu7g3j7rd79SYkdvuHKLVYcp18rm/wk6WIGQz+OFBVTrEYOO6Ic18w0SMAEzr9XwMlDQjfb7ZnNEfHN73dxFLtQHYko4fTpWDhSSHivK+lUYiOGLT7XndecqmUOHL2W8M267Ow+0WIwY1l/JbYLenTFifxxGszY0Q/0H7jrZRvGL3O+y36f+3lnu2NQ5Z9ZNVDT+8QMYLUNh1jbouF/Ls76J8DkpDBg8bBi5dWE+Td7O3P5GBImzAyXHzzc43WeKU1HntQ5bcz42DBNcIu857RILNmK/2/R9w8OCaQYco6Mqlu1W66vxoTerHrVjSZLAhuMW2SipUohcpwdUmeAIzSghjrzQ1rlMorBXZFqiNvzsVO024XCeF8AZIR59dGjtb8kdv5hhtL9n6coP0VLceW3crbLRy4hOO4f++jSsWaYUJ0nDZrU48DReTHZzh0nW1DLed6EFxUr8LAxG7Euk1aEuXCsgM8grSxGvGt7te0HVttpwUCy1JUf5BrmQsSBll3spX2VAhrPOz1nAYaJNRCoY2o4vQr9BZcaCj+gDlOsdezphvkSizDG2GGfrPsYPkGI2hH5oUe0WV6td63lwRDIzjC6RA0eBZTfHZKi/fndhw6zWL/t0CukprwplX2adzPBQf+FFt9yhBq7NbtS01h+bglqNnkuE52h/mSiL2C7SCwviemSVO2nnZAz5zLI6LeNUOUBkbuWFrd/v63l6nHi3bTqGvAQ1qWjHxyUde5y47rzQLrBiSkdJI3m3MuMg5FcbePqGNXBW+hEGd5C/F8XoMrjkJMzuw218eAowsQWx1Nzl0raTLjElPSi/m0odUo
 pNlQ8Q5+
 ISoW/sHYNg4pg2LDWh4ZiduzhUXFCYbFxL0E28ZX4Ue8njoiHxBywsllXhlNPqODwqH9HeTJQtWKNJmwQqrhUhOnRuu4Bns+f+6GNwXcE6ljo9+kIabJuHf3URxs9BL4B0+hpozwMTCYmOJf4H0T+PGAus+3m6BKIGQsosdSd/nKaNwYFUZ69Th2qvr84GsjcvLJuvdw48UVTQYYm5w2uwwXBlqDniI1sA7RAc4sbSxovVBCwc4tQWKdMs/SS+yDCW1RB5IZl/aOoNtb8bQx8afY1LZ1AiqAFYKaW1f+5ghLsrMckDeC+u1x8Dik7Or16qJKBoDJHp5gUbxAM5ihyxskMvnqVYsU9E0S0MLFpa/4x/AKE0xM91ha1T/3zYQ3iTm7u3ZtLhRUWfC57rm+CXW9kXJxPWYMB94sULRi2uLNxjiU9Jzq+EZwQkYrAZd9zVot9xZArDsjEhiDKmTqRgvW0hjJAnl5/GjConRivLzVraSSPCACJqD1K7iz4s9kOSzBnLrXkY1lwwYRYtTlhH+tzWs+VB4pHNP2O/wmG9UQWT1akXE413/mBlQ9S6CiRCQYaLlpJqFoZCE6F7q6w5vUWTtonqZTowaE/
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
2.56.0.257.gf7497c7d27-goog



