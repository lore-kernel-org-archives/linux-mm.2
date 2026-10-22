Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4394D606A754
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OYfEKZNl
Received: by kanga.kvack.org (Postfix)
	id 82D126B0A38; Thu, 22 Oct 2026 19:28:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8064F6B0A3A; Thu, 22 Oct 2026 19:28:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 657A96B0A39; Thu, 22 Oct 2026 19:28:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E8386B0A37
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:09 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AE4FC16035C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:08 +0000 (UTC)
X-FDA: 85351852656.07.CCB13B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A5CDC140008
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:06 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OYfEKZNl;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711686;
	b=qKCo5xgPZIJPN08w4IYK79nzOgWoVh0rblqBNLWXUFEOh9SM1fbDmxSc16LDET/7eBzF3w
	c0NcDaXgkuagXz0kSesazQ0lf0DfG0HOXPInRoy4LMv9QiKL60tNlwdade8z+3lLt+mLSM
	JTvVfPhAFbqZYbS2fEEP+WrgjRhaStg=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OYfEKZNl;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711686;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X78HZyiy+58c3BPVTrK0KZrqYrh6HOK3w406pYK3FkE=;
	b=8G2/ou1I8B+WVN5Nc3vfs5EDS+j+HIxFygtCXN9G5YJLRWbyxSVd5NTUcJptQcGy6desUq
	euf26/3HKnIccozEPZu6Nvx/YGWDW9fNJ+advCSZduwHtnkjUl3zy/T4fcr0GHO9HLP+61
	4lpRH1FX2mIXlE7L6OY4F5Cx1vFoqyo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 525CB60AA5;
	Thu, 22 Oct 2026 23:28:06 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711686;
	b=EB07UqtfXvZH5Ii46YRIDKWJhFHFQBPU0cMd4LgoPobykZklQdOL1vYwdJJILWKY227O
	 eEtoshzV6fs0VqTCiwvmgYdh+TcZpzSfDkIBoIfA3qe3ja/Qx+fZaJCAfXjRO3sz/1Sxu
	 OJ1Eg4WpLRn0XYK0unXu5nkPfcSzhg9Pw5E1ZaNxgei+FPl1gkQKFFJKrIgVGQ3Kl2IoH
	 hWw7ku9h+kjjsrwSFepixfiXF0l4M0ZhX9zj3fQiPl9PnBioo4DF6esh2lb5J5Yfy89vS
	 CwiuZ3kCXtHTXFzUZOVExzMzBcTf27sTEjFaI8YqPwhiEfbY/husPY6HXt0+KeEBlbw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711686;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=X78HZyiy+58c3BPVTrK0KZrqYrh6HOK3w406pYK3FkE=;
	b=oU+hm5R1OfvXg6USis0TJncSFYGEUaG3PysdoWW+3UBJNsk41upxACl4S6WWzyDs7pJM
	 YYW6Nto07ILWDRSKUFpHonc3uxzdyvtG1mqfZGzRgGwkKCcH0obJwlcUOmxbf1n2nWyOx
	 tUrt4lPqQICv8ta8EfYnS3toLejRmfHZTlOJgKc53jZ0DZ+1ONV3sPqBDS4ACtUmQJPlN
	 ijpvCFvWmA16Omv+9vH75Y5rx2PzrqP+b2lHvqycnL7dznajNQTkDRBsy49l+7usUQEpz
	 es3AOAJIQ97hQ6fTootdeDqIyQlrVWHKg6pe2/h4cxral1po5VH5txT/Sdrs2dHxn4Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A358F1F0119A;
	Thu, 22 Oct 2026 23:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711686;
	bh=X78HZyiy+58c3BPVTrK0KZrqYrh6HOK3w406pYK3FkE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=OYfEKZNlRerju5ZLailmMHqnTafkjJ3JvD7biWegxapcy6w7D6a8DeMrBj3mABKIg
	 rYFuMU5F25iCdg0ngFrrFqRot1htDr9TY8JiAq+gu3nDGjVfrZLOu/NUJUOriS7TLZ
	 mr1ZCmHw/9ZwGnZx9xEOdg3zhWhvUMZ73GAa/Fnz4gknlO07j5LgK/NetSmkavTIzi
	 43xjCY5fV5P784e+BVzkEXRcF9EecFg5w/v6tz2OqA3/LgIBNs+q0yXv/uV1p6jced
	 KMOyFMKMRxv2pBXz9XC7d3/NTZZ1amvZ63q+HNCyZB1D2Se6S0pOeYsyKYByrKTuAq
	 ayfeUU9oSFzuQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E44894207B;
	Thu, 22 Oct 2026 23:27:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:46 -0700
Subject: [PATCH RFC v2 14/50] KVM: selftests: Test guest_memfd resource
 pool sharing across instances
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-14-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=2262;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ERP4iDESBKgfDl/D301xPUqUKAaFSqS72fvQfnKX/h0=;
 b=gvjCvZAEyO66fTp0In1v7/io1RmdqagQp3azd1KuvLFx2EEQWQ+zwcIrXBb1QeYYIN79KZH/b
 +xAxv/FNmj2CuJ4wHpNdy2Gn/eP0swfzaVfF0JsmQKnxtme4/XQ6llm
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yqmyg5p8q9dn4nsxud5btb884kfos61m
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A5CDC140008
X-Rspam-User: 
X-HE-Tag: 1792711686-899204
X-HE-Meta: U2FsdGVkX1+X9FjaGGH3C1lEgIf3MUOuYNzo4pNPYvIUDAZ/3bTrS2ungPajrQCaKIksVEzW9i6wJjjW5N6iAgxaFWOTgWzAH/FOIv1gh4Lc5AvV0gLLW9oCc1yf31aei4+FS8Hdy/N2smiKGxXN7ZDvWm39Us5Qe34J4/z4KmDTsK/6kZDQfH9JvE5G2Olpt5b9PF5T5z1lG2p1kwsWh8F7TXzyNIs/lZ8GCjz5LpuoYmeAg41yf/8fOb5j6a4taFIAfTYvQi+8WE6j+qGZBMu3lUYh/7SjDC+mK7krzBgo2sHJ+QMC0Ted6hOmXhvyHASeUZVU2nAq6IOEAD1E+IDPj5GPMx9i8ti2HuZtDBLdB0W2Ve5MHrHsAyLXs0KOJFgZwKJvgbw6SRliCdaFY/31JW0g67vcyT1xP7o3uks/1p4/Pt6Jjy+zdukZYpjHLBpoy3YRAhTf7GS5rFj0bYCCGYuAc5mub1MbhoCEprMWAGwdFkqan42AtqQ4GBwuYm6HtQ+AjQKmTRcbZDt8ZvNJTb7B/3AwPcKmkc7YJLe58iHVI2wbV3NxEeMiKkBUeIvn2cQD1udjfehWT6l5O3QXjxRBQnRB1qU126NpoQqcNGh6ckEBB0cBWMMcoF6uPcxp3GnVaIPQt2dsh1ee2WlZCJiTGf0XJ/t4fTPlI63rK2E2lsn9Z3jR4OnNfUMODnQQp+MttengNpkzL2TWZRomA5Gt9bdS+WJUncOvFIK+GSzn/Gbsp2myMg5pDrh0cG3i+6bRA6poEaBu038v9jzrVVP2FUJozCL08YbRWMxhudf+lXxbFtTi/4ZPw8mYOm4NW6AXs8PGehWCuTObqqCvsXCEA0GpPeVddFo9541elEp8/ii92aK5+zZjNDPXrpnpMppD+u2nNi6rcvsT3PLbiW2gsy4qlv2yJaEs2l4pYQdhEUW7XkIbC5EK6Y97u0ON6sJJT0IY2oKUyvJ
 s/LN3nLH
 yfICH8OVdvVwI5LyI9AgM535FLd16O5txZJBGsZt8bWq8yWoNPYc9ChBhsxOxgcszWYipBOlAXx45UuUElPBjG99ycVEkG9EgHhwysfLZHLosZBCVF5Vhu+nbr143ID4j23B1X19EBWL9nUM9gzWmfbkcopeAzht7taEiUf5J8mhEDvgLO0w0jlWoapyM3uz7qBPpZclF13Q7+D1JREHrOTl+SFN99KgUByBycKEwXzWRBLt1pML/46HfkKpOpMpK5wEbBxbG+mzDFSmeo+K6aGzHWlj1r9vyDmjOaZAcZluuWFxceGgVB0SpndCe3lx/Shijt62LByZQjS6OIgFZqG6hVaR4s9To0DUAm+2d5xqk3Hrws4rOCqVqA4aFoxzj6M13auO9RJJc2x6ED+/F0ZtWfooGRthbaLsva1yYhrnTJ2ffVaeUlZYe1P9mYxA5SV6B6ggJ3hWFEM5HphTVzoxljPEO+R9cFQtjaaNQaHyDWRM4duPozQ4g5CCUChVCqbLOuKFGt3HSVsBhNK5t/Hk0uBEorHVY5dpc5CPClyYigQrT9tretANJOvSFnKdO6x0GXhI6yImYjX1mEpcsH9yG/iK8xltFNdHP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Test that multiple guest_memfd instances can be created backed by the
same tmpfs resource pool descriptor, that each file descriptor reflects
its requested size, and that they have distinct inodes.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 34 ++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 2250c3e9a583f..310a45b6656aa 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -562,6 +562,39 @@ static void test_resource_fd_tmpfs_huge(struct kvm_vm *vm)
 	close(pool_fd);
 }
 
+static void test_resource_fd_tmpfs_shared_pool(struct kvm_vm *vm)
+{
+	int pool_fd, fd1, fd2;
+	struct stat st1, st2;
+
+	pool_fd = create_tmpfs_pool_fd("never", true, page_size * 2);
+
+	fd1 = vm_create_guest_memfd_resource(vm, page_size,
+					     GUEST_MEMFD_FLAG_USE_RESOURCE,
+					     pool_fd);
+
+	fd2 = vm_create_guest_memfd_resource(vm, page_size * 2,
+					     GUEST_MEMFD_FLAG_USE_RESOURCE,
+					     pool_fd);
+
+	TEST_ASSERT(!fstat(fd1, &st1), "fstat on fd1 should succeed");
+	TEST_ASSERT(st1.st_size == page_size,
+		    "fd1 st_size (%lu) should match requested size (%lu)",
+		    st1.st_size, page_size);
+
+	TEST_ASSERT(!fstat(fd2, &st2), "fstat on fd2 should succeed");
+	TEST_ASSERT(st2.st_size == page_size * 2,
+		    "fd2 st_size (%lu) should match requested size (%lu)",
+		    st2.st_size, page_size * 2);
+
+	TEST_ASSERT(st1.st_ino != st2.st_ino,
+		    "different guest_memfd instances should have distinct inodes");
+
+	close(fd2);
+	close(fd1);
+	close(pool_fd);
+}
+
 #define ____gmem_test(__test, __vm, __flags, __gmem_size, args...)		\
 do {										\
 	int pool_fd = -1;							\
@@ -656,6 +689,7 @@ static void test_guest_memfd(unsigned long vm_type)
 	test_resource_fd_tmpfs_swap(vm);
 	test_resource_fd_tmpfs_huge(vm);
 	test_resource_fd_tmpfs_regular_file(vm);
+	test_resource_fd_tmpfs_shared_pool(vm);
 
 	__test_guest_memfd(vm, 0);
 	__test_guest_memfd(vm, GUEST_MEMFD_FLAG_USE_RESOURCE);

-- 
2.56.0.257.gf7497c7d27-goog



