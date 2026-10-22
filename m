Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25CE46074BE7
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QtDIDBLQ
Received: by kanga.kvack.org (Postfix)
	id 40EA56B0A32; Thu, 22 Oct 2026 19:28:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E69A6B0A33; Thu, 22 Oct 2026 19:28:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 238826B0A34; Thu, 22 Oct 2026 19:28:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E18AB6B0A32
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6BFB3A7D22
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:03 +0000 (UTC)
X-FDA: 85351852446.24.A4FD363
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 563DC140002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QtDIDBLQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711681;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oTeaqFa1HXg+JOfpK9hboIAMw/2sySo+E4rGYwzL0fo=;
	b=Au3gCuedKTzJNFYvNgYgv4W5F43RXmcKuH3qMTEZB6xlvtox+44ZFVU3A4u285TIAfsEXq
	zwu5Hbwoqoy5t6JVZ9i4eVis7rZPyYKQPOc40v2pyVclbGcMso9Qonr/eL30rQC6daFvw1
	+nvAPrKVLe9ZxkeCE0Tf5ARB1zx4/jI=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QtDIDBLQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711681;
	b=hHKGYj7hYL+usmt9mqM4qx4i+dH6mXSkLftk50kaniajprLGd3Xv0FAC5ydckX8glumAWs
	zcN/Hn/BGVbKAGUyabB69mvDsNNGmlFHXM93RWiQJMp1WvueTyrw2a1SAtLlwIuwNYywhe
	J/AIZ+f01Iafj8yKhep+dOd9+tAi8eo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B74D1447B1;
	Thu, 22 Oct 2026 23:27:59 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711679;
	b=gZxVX7yxlVT/SQnHBxnr/0owW9BOQwqUlR9YHnsCPKotHQH3LBLz7MyEr7VCo6Smgcsf
	 Vj6QSAuN164RdzE9VVov2qlAaJ7b71fJkUQnKA1zXRyj8A7rdFOQMDBkKD0jb2tF3qgfq
	 SDvkHBkUVpwXJK59T2Rc3M+yC/K7osYKXw8FfbW2EjxFUnH0CfYYx3L6Hf4bHmSxWXne2
	 oRwOL9kO4jTuDy83JlBvTiGETuPU4BTdKDxzxCIdlVYZWgFltKm9bXLudc4bTdLo7YewM
	 nmfYrUvZlFdXROGaqce3Lt8V2yA2oEdC/EcODCQnWy6dNuongJHUAGAoa6F7rjWD5sA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711679;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=oTeaqFa1HXg+JOfpK9hboIAMw/2sySo+E4rGYwzL0fo=;
	b=zyLi+fjhZmb7XWUI5V5uGj2d2i/ozzteS6rEC+rRtDlqBKjthWkDuL26YQ/GPfXA6rJ9
	 k7FGGWd6QUhtovNaOKNgc03BeIfkt+CwmWamw/Ff0tXwzdUSlPZogkUqifmJQ1/VD1o2y
	 qSCzcZC4Stp3E2Qs1ZuOi5LKIQKbazkMNOSFVBFtl++VN7Kq022lyXY3maXV/JTwtS+z+
	 KkWPRgWn11mg1xwNs4EHYOE/hX7aA9GQKd4NiEHMkVfLtO/CVojj2Gnt5hYeFCaYKOFJb
	 /T+OoyrIhPmhCu7PDzKF5j0ug8qBu1NEmxTlFrNUHUsYnzk5b3HwLjfo3sOeSr/1a1Q==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 948411F01197;
	Thu, 22 Oct 2026 23:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711679;
	bh=oTeaqFa1HXg+JOfpK9hboIAMw/2sySo+E4rGYwzL0fo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=QtDIDBLQ7sLdDRf8rJcCkxflN0zkuMMWTtksNGNCRlWJS7z7mJ6fJpjnyY+LN0kpP
	 2FGOxZkFgpOkm3w0IRHsLIg2QdvEK/eYUHlqAi9bOQHvfrKvU4PGCwpn4nZL0ODgIb
	 tyQKpbkSlO7BTh1QbFbDBauugiPpjrRI36CPQH4HttmqgTpnK0P1pd7AbRRYx9oi2W
	 W/U7jPTv48nw4NbKJtTBBt5DDLYN6KcI4AlLMMAXHXOiAO5HQ9vcYMS/n8cOrSlFil
	 ieczMLiZLFIaKUgNXF8RhpFThIvopBc6WtHiGxxT72RCFHQuqiLxcvTeyiMQ8xNn6E
	 vRVcj9RkrWRdg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id F02124207F;
	Thu, 22 Oct 2026 23:27:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:47 -0700
Subject: [PATCH RFC v2 15/50] KVM: selftests: Test memory allocation
 against shared tmpfs resource pool
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-15-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=1933;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=6KatK9dzFsYDMnh/WM/jXUR/ewN8CiU3pBTeSrOUg04=;
 b=/P+rFa6MKAfQ2FTprf3qC1Fg/EKnBnijzsSsQS2H5G5qu40sLn36wx0KQjpfUJhsF9CA7l2TL
 bew/od/tWxCBRVJTmLYmpanhJYxYOMXUjYVGl6TYFsFTaGw8xcGDA0j
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 563DC140002
X-Stat-Signature: yub1u7hhn3hzo9yeuw6f3cpcfz3ierej
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792711681-143240
X-HE-Meta: U2FsdGVkX1/+Zud9qTMauykZZS+tr3HXJy8vXexIEnNTvMnLxixPd/3Op0377Pg4hBwF38PZO8zCmfDzH46no+M7OEMu98eQ46aDjS7gzJbFBUozD5xUdnM5PNy2InCC+WAJ4z6Gm00RCGBZKn0uYQ55WPYYfz53j33TYketenVjtAnTQVyfcxm6HBLn1jZmjQw+pdSieWWP+WkayoaNdViOqop2N/K7Twkola5nJtMSpAuflM1NmJ7k9hJcLqNVhte2QY9QuA1QPiXzP/M7B5glpPUsCfWdOBCbwECRKu9573iHD4bdsO9uWdJmhLr3BF805hk80GT9IP4EfQj3Wcylg6xF2jlAMN3+mrp6OscDrk22KKtWGk3QjIxiadwYk1Gnp/KBBH60cY7VUTbtH1KucfoykHqGVGjzaWD2S820WB1nN0wO0t+7Zhw/+S1NjSAtRlvq77Y/n3z3WLeDfXy5z3q/vTXypBOBscFsIAGbtE8eZxtnQb+P8Vh9+oxs9c4mGQl0XEoEyOlCw0XgvXU45681QV4Vb1oEJGq4UKYN+j6zQWKlgLUpjC5oMR/9Zg4IorVP0AjdtOIQdBiWI9y1abbfK2ZqQkksWlXgD2h8KtPSoRWsflASL2dckmSam0VR05LmvW9q0nUC79H0XiPFKFDkTGPZbj3OR/QMBkTjd9R1vGThS7aWa8ayxqjm+Ytx+F1wTCogyGv6yxa7WWuS0LyoCvuAPxMH9S9CyUa5VvXq4Lrkfd3id7EQ+pwpDpFCfyJxk0qEiZ3s6UeTa2NZgGvhx3Cps385VkcI7fgZ29Zm9QZ7WhzVs5Wms1Vz9U+WlLKRlxRCkaLnrePM7Hp0piMvg4hzDhGvT2gLof+fF5DFo2r4Enb6iOUXH3o+NCKfsz3xXu5QQzZ1bPhCpVCNtADnGv63HwwGKWyeqsrKC5afeclAM/qnmwMfrBmHinQWnxu+fmIJYanb1cb
 QD8NCbNG
 HYyym/0RPcEkqz5n0UiDdPaZJTk0qrBEZCL5hNcjKrXAdRMHoz3DcujdV4h02K8/qba8EzJNKJMYuuK21lKMGNrCvtp59sV6QgWIfhyjuZtnH+nIiU3c5qXbYlv6Jqxu0PqQp2jbTo16oF9oOUbkasFNZlwWXl8a1/OPqYSsrT7VviMwOrEh6RvMaCMD4LyHF73SePQxwJU0BxJcwYZQ62ua0fnwsOGVpOlphGx0uAqG7vBgaTjHlSlekZ3HWdMA9hinEXJM+rgJQMZ19uLM8eKyeR7eh2Xx4WFrE09JVFUbxAWmVrIRGlpwJQypR7jM11edgo7cDpPcvltkt+2uT4W6XyLoerQM57QgXqoJgW5J7Olze5NAMcthkIRDD3SMDlLyL0o4NlY8cOoXBiiEuI0MGaD97+WToIhYvss47afYlodvqfLsnEnNkZ7sNvzdKNYcMDfbDjrV0a5CBiLDAlpTTalhRlN75XxAHuvoW/uYemNG4l5NrRDiC1urGxTze3t9PZCd34sKO/9/00VX4kysypbZKGvC7aARf49Lu+U/44nLLj13uDO0frHvwEHSmUoirXSVYQTZCMkXvQbkE1VRfCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Verify that allocating folios in multiple guest_memfd instances sharing
the same tmpfs resource pool consumes blocks from the underlying pool as
reported by filesystem statistics.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 310a45b6656aa..639b1b0c204ed 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -18,6 +18,7 @@
 #include <sys/mount.h>
 #include <sys/types.h>
 #include <sys/stat.h>
+#include <sys/statvfs.h>
 
 #include "kvm_syscalls.h"
 #include "kvm_util.h"
@@ -564,7 +565,8 @@ static void test_resource_fd_tmpfs_huge(struct kvm_vm *vm)
 
 static void test_resource_fd_tmpfs_shared_pool(struct kvm_vm *vm)
 {
-	int pool_fd, fd1, fd2;
+	int pool_fd, fd1, fd2, ret;
+	struct statvfs svfs;
 	struct stat st1, st2;
 
 	pool_fd = create_tmpfs_pool_fd("never", true, page_size * 2);
@@ -590,6 +592,18 @@ static void test_resource_fd_tmpfs_shared_pool(struct kvm_vm *vm)
 	TEST_ASSERT(st1.st_ino != st2.st_ino,
 		    "different guest_memfd instances should have distinct inodes");
 
+	ret = fallocate(fd1, FALLOC_FL_KEEP_SIZE, 0, page_size);
+	TEST_ASSERT(!ret, "fallocate on fd1 should succeed");
+
+	TEST_ASSERT(!fstatvfs(pool_fd, &svfs), "fstatvfs on pool_fd should succeed");
+	TEST_ASSERT_EQ(svfs.f_blocks - svfs.f_bfree, 1);
+
+	ret = fallocate(fd2, FALLOC_FL_KEEP_SIZE, 0, page_size);
+	TEST_ASSERT(!ret, "fallocate on fd2 should succeed");
+
+	TEST_ASSERT(!fstatvfs(pool_fd, &svfs), "fstatvfs on pool_fd should succeed");
+	TEST_ASSERT_EQ(svfs.f_blocks - svfs.f_bfree, 2);
+
 	close(fd2);
 	close(fd1);
 	close(pool_fd);

-- 
2.56.0.257.gf7497c7d27-goog



