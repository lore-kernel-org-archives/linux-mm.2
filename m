Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F181606A339
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=i0vEskgw
Received: by kanga.kvack.org (Postfix)
	id 129746B0A37; Thu, 22 Oct 2026 19:28:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FFFD6B0A39; Thu, 22 Oct 2026 19:28:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0171E6B0A3A; Thu, 22 Oct 2026 19:28:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6A8576B0A37
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CF09FC0315
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:08 +0000 (UTC)
X-FDA: 85351852656.10.1708AEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9CA9B180002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:06 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i0vEskgw;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711686;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hRqhTvz9KoxMSp82jizp9y3sj+8BzvbmPDKN0C9J2o4=;
	b=nsFvI6ik91Fic34BiTq7xhncZAcBL/upMTb7Sm8oHH9UwupMmyZ0GU73BHam7LxWGMDgnS
	529r2+XbxgDPcUH4wdX+eZsTcrhaAnv9JmIA0K1BIQgZsBn2g0lr55bf0qg3TgpUeEuN+5
	k2uw4wEIBP3QVs9EWlFk7PfMl6bwM84=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=i0vEskgw;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711686;
	b=Q2NnRHUdloKxLuNSYgUd7uTM44gAP3DGInqADw7tZorUAXYMVFxy/NymVaDLYvegDqIsKA
	GW5/eCcAy/4HIG3BA1kw3GP4EVa6S8aJ5Xkwk7HWwxs6GVsQl/6VDdowTnsi3aiJsBKvxE
	Qgx5xFw9JRK9C4c/NJgzDlGHwv9N51E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7592E4479A;
	Thu, 22 Oct 2026 23:28:06 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711686;
	b=RuOyIlxBBKpnROkW9kK0haexW1r3YLVZC0+N4Vyi6XJW9p0gc57fTT+yKXK1Rrp74GFM
	 N97SXjLYG0ErqyVJkKUMJI96ilGbx/uBstpYFAHv0WVbHf+HP53PvXKSgdYB3y0A4nP/+
	 NaicGmyNDkwxQS1jy6+8kcM0ooMLMukG6l4vdxxEwBaubuLLdDvvw8W0rgu2aEoTIFYdJ
	 M6PQ0fRS2c+k6+hZInxPRjj389xpzw7N1+1SZktGrDceofSpiAoYArOj7+lUszQcyQMKn
	 Tv5ICJvQ+OmOZpdmiN7Q7NwHNXxVm8OtfkUmKccppbeEPuvjwbBx/XdnbseHYUA50UQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711686;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=hRqhTvz9KoxMSp82jizp9y3sj+8BzvbmPDKN0C9J2o4=;
	b=y9xNaCWi/OD4l0vDATgGUqq3qqSgN4atRhhdbrPJ7puGxKp45azReYzdRHqmhty3v+6+
	 Jkd49xKiPZ5UnAY/aXFjcxjI/99mBTxxtzVXb6+p9Y3/deZoDd5+6dmljBirjvwEyfhCT
	 tWpCpF9uk0ydcxtdIjF4TffbC5wmcDeUScmoGm/8jOrVRoy3t3aYSGxaxF2Q/O8prD2S9
	 HetupgJeaChzZ1Ep5E6nLvZKKsjVetr80OiGUrC0q5aDBvGSuLzgrbcwHUAhGBDzGxg6Y
	 Cm9XKiYhD7Kgqcg7R4Jf/NnS3LZUpYCimBTgvgUSlOgC+vGv5HmfiXtLEUug4LGQodA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A1E6E1F031E0;
	Thu, 22 Oct 2026 23:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711686;
	bh=hRqhTvz9KoxMSp82jizp9y3sj+8BzvbmPDKN0C9J2o4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=i0vEskgwoLz49RWPQFtZMXRFPoLr0RkM8F+Xd6LXqCZ3FgwH9G77i7jHxiS/Id3q3
	 EzVZW/l6MsLyqaLfn7j3Ua3iV9mvjxuazfDyDWXS/Ygao6pw8cK86uiO6gP21OX2WK
	 4FTtSDGjtgmul9k9TmRbTBxz4/9Pit9doGxCszRf5mA97TltcTSKRdboKfIh6H6tpC
	 JSb9t25azXs7v1TTPCVPtkdlqUkPh9xkAXxzrHN3vfNp9FNGUuz4XzO5fflJujKp4Z
	 Bl1Az7pU1nAZH4ajcltUlVwoDAfO/38H2oANNqB9uRaMK1zryghxQcIUiQJ9MpjqCx
	 j0wPjx/Qxrpug==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 8FA7D4205D;
	Thu, 22 Oct 2026 23:27:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:39 -0700
Subject: [PATCH RFC v2 07/50] KVM: selftests: Test negative validation of
 resource_fd argument
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-7-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=2102;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=jwRLScuSBr88rpMrKjxcHyT+PgJDDASebgtuulQ0YPg=;
 b=96oWiVXYdVXyKYK/6pIVx6tBM1zHA772RaK0kU9B4myUopfTmx7cJXnFbFqQQIQcb2aCyoG1v
 G0UA9Hrcf65AUNSju38e3lbbkDHFTljxEhkRagHttcPtMvn1VMy4by3
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9CA9B180002
X-Stat-Signature: ji9uymnjikrmux1qrdo8k4tysfd35nm6
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792711686-593741
X-HE-Meta: U2FsdGVkX18u0Sl6sD1cVR1FWr+v65e1NrNp+PzngYPIkql4fh8iVf5cyMb23AsWLM3/RQrxLBRuHG9eLuNTuH7ASZrvEUDRP2WzxGGKZbTDTCNQwbUGF9QLQZ5S+5DEHKADuQ6F479asgpBtBYnNKB2Qb231cD6GQxoYR7pS5FXbXJqA5giQeL3SIqyeJ+2ZU14b/+Pq/etsWzv3MfLWV9EaEYvZUsaogz4zsxjzlbtlmYcZOYpniyUs46qH7FmM4YvrbjW+pYU7NSMfpkwvjR7SkCa6aKsmgf59CZEbwlLXGyaYY27Vo/iPP5yoWfN915jaeq5cT8bVvW9Dl4WmmkyPSRcsOVkZ3HXpSZIsfUnaCKA0a/YQAItkSzlz1n0SsG68LTbn2x2mb0brixt6nflKxQJO+x8NgxHvVwVte5UOwxSU7FbjrfAVo6pzaGOo50RkHCla+X/S7bBgWBS4GjOCXsmClmQxlne6dhxdGJy4sWGIHxyd9OtX5cJafQeDfuRbR7pNB1QgddXecKnjRN0tz8L7zbfkqFrhifKiU4apydWEC2+DFJfiRe0PjYimbh6HyK0oDjdsV+cFAX/32R1cPVS8Bhj+s5AqL17n+Wk9PvUyyjEKnshOJ13Dvi+faaJFqdoxpQJf3MmT5Wb0FDkfC6XMvU7JGN0KGngdMkgQ5WIlSmCh48Bbww3FhM75Vp52YRA9Ls9fkEwelR6yWX5RoBWtbxEe9hCqZzQbo7/aqxuh+AepkhWFPAIOSKvmOFGjdYJBgRkuMa6GcMnWnGWFlkhUanMLCFf9XEzxNFH0BhF0ky7Wid0c0k/gSdD61pUZbogA8AMxBi4RQGts9vCkYU9Zhz7ud5Kbd3tGDe5TWxeKiQSnNMFHxhmhMIIR2GFh1dMUt5Mw82BMqIvs3OJPem64SYnzKELsXAjKQjBaJ/HmKwG/QyXLh72vfTTTrodN+vH9oTXWNIDgY1
 DrGgKi0w
 9alDvyaNhG+X/0kZDTii6VsNHYKjZUrUFzLMNLZAyfoPpNHUlJW6xG6pLgxnMhy+XCLV12Knd3r3eCZQeCXZ8/qmoAYnRJgLH/FACTxMPhLiH3/cncbyaPeQVdSJdIry4Uhs42Ej2XRZyShxWaYUdnfuwgbe057epAt3mHMtBvGQpn0OSD3ASnGJ7wsQBDVzNdbpOl38H9hOBpige4VOL6uEiGYBpWdvudTRu6FcZNWqEmFgxg7yxenSfNNTelQI4o+N4pg1B/E9/UfH0SoC+toNOsa8qHW8mtcbq4EunYNnHinVv0Wm7U191WsEpqyiOYrmxuoD29JxfIoISHLLQCjtpzo/QQV1h3rWQWEfMAlBs8mKXvRJ7BykegfrSUq0S/VQfOGjXYn+pgSgc1qCRPG4nsbhNFZjDEOLNjycGccViyxPQvX4fi+nHr199+9mGUgHlLZ4gIzo7X7V+DEg9Qc4WegNcaFEAhbF6KBAkRsciWLNv679bx6MfnKRJzc0fDAbFQOBi1vHx4WrLTpDzD8LPt78Tb7PmQpPv+3570SPHEan++47gRTbl2/qxQ2wC8MPOy1Cx+9G30oUoJEQ8a3UKbzTGa1K1rvPND8spXGHXCcs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add negative test coverage verifying that creating a guest_memfd
instance with a non-zero resource_fd when GUEST_MEMFD_FLAG_USE_RESOURCE
is clear fails with -EINVAL, and creating with an invalid resource_fd
fails with -EBADF.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index cd5df88bc6427..3313d306c0bdc 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -404,6 +404,8 @@ static void test_guest_memfd_flags(struct kvm_vm *vm)
 	int fd;
 
 	for (flag = BIT(0); flag; flag <<= 1) {
+		if (flag == GUEST_MEMFD_FLAG_USE_RESOURCE)
+			continue;
 		fd = __vm_create_guest_memfd(vm, page_size, flag);
 		if (flag & valid_flags) {
 			TEST_ASSERT(fd >= 0,
@@ -418,6 +420,22 @@ static void test_guest_memfd_flags(struct kvm_vm *vm)
 	}
 }
 
+static void test_resource_fd_invalid(struct kvm_vm *vm)
+{
+	int fd;
+
+	/* Non-zero resource_fd without GUEST_MEMFD_FLAG_USE_RESOURCE fails */
+	fd = __vm_create_guest_memfd_resource(vm, page_size, 0, 1);
+	TEST_ASSERT(fd < 0, "guest_memfd with resource_fd but without flag should fail");
+	TEST_ASSERT_EQ(errno, EINVAL);
+
+	/* Bad file descriptor with GUEST_MEMFD_FLAG_USE_RESOURCE fails */
+	fd = __vm_create_guest_memfd_resource(vm, page_size,
+					      GUEST_MEMFD_FLAG_USE_RESOURCE, -1);
+	TEST_ASSERT(fd < 0, "guest_memfd with -1 resource_fd should fail");
+	TEST_ASSERT_EQ(errno, EBADF);
+}
+
 #define ____gmem_test(__test, __vm, __flags, __gmem_size, args...)	\
 do {									\
 	int fd = vm_create_guest_memfd(__vm, __gmem_size, __flags);	\
@@ -476,6 +494,8 @@ static void test_guest_memfd(unsigned long vm_type)
 
 	test_guest_memfd_flags(vm);
 
+	test_resource_fd_invalid(vm);
+
 	__test_guest_memfd(vm, 0);
 
 	flags = vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS);

-- 
2.56.0.257.gf7497c7d27-goog



