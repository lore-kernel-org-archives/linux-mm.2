Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624AE607BBDB
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:28:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WZu/L6g0
Received: by kanga.kvack.org (Postfix)
	id 443956B0A31; Thu, 22 Oct 2026 19:28:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40D146B0A34; Thu, 22 Oct 2026 19:28:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 286376B0A32; Thu, 22 Oct 2026 19:28:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAA836B0A31
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6A7F5160352
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:02 +0000 (UTC)
X-FDA: 85351852404.17.23A7164
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 489EC100006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:00 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WZu/L6g0";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711680;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xKkND232ckYcsr4WYPfohBQYeZlI+ZatIYYh6FT4f8I=;
	b=5nAzBuOmMBnmrzTs4BPGo0DWiscJN02kkrturS8sRsbL/UeoAIT/az1cE4SZpWBMhZWjc8
	JDCuFtWH8+tA/R8aZDRPvFwWmlwoE//5av8IPYAxh0xjuiZR9zIL4w2qbeysD1owMf5i1M
	54E7KH+NvxSEwvuxfnXaj7tjoSf0hZg=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="WZu/L6g0";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711680;
	b=Wsvkmh+vF9uEsObgczqaVlyBs5mDHlPhRNVoBZLnb23Djm8gKS+S2VG50XL9Bw/8vvCZsI
	9qPM0lROTUa9BHeCwUtNJjTdTB8eTAVAKBJBNBJ20CiA7A5FtDm5IJLF6/9+gQrYzGplAT
	Aqy9xshwcznxZoEpGuMOESNLmKgcuQY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 89FDE4477C;
	Thu, 22 Oct 2026 23:27:59 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711679;
	b=jlQ8FeHcIrZg3i14t+feFv4jBI24vp+P5Xu40zZzGFcM8k61AXVMtf9TobM1rh+/Q4BG
	 0G0CAjtjUu55+sQOosc2VssRNqr0mltTg21K+VpTPW39Q8NYn6q62NI5PA5IdvwRfb/91
	 pb+kDBR67hS0kOopbu1yRPSXodRQLFMSUAgN76eVF+M3SvQ60o1PRvy6t3U5SfouyqDvf
	 17uAe8gYFcaxWHr81QY2WPlUQaoTUVrKwnCNBwYsKRLRsl1/hMdx9jemhWXkeRW3Pcoa1
	 vrMcxj3bZz6w3724FNFUZZ+R9k402XftEFUdo9YZry3/EzCDNm+3WXTmkPCT4gW9KpA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711679;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=xKkND232ckYcsr4WYPfohBQYeZlI+ZatIYYh6FT4f8I=;
	b=aJAEIZuJjFop2LcsyeuzR02LJ8MLyB6teZRNRl1IMOsHePWZlrLPNM4q1/2heRA3JTro
	 kJGkpY22a/cpBK2BxSXZwLwXeiioxX2A3/LGekXpsVYIThXpX4g/cVkTS5ujJ2Ig8nwr1
	 I73gaWuc7ykFSuquhvPE97LqGF1J2o5C1fGASTm46HRnEj83VXHZwSCZBhlGqDEv1OdIT
	 GkxhBXLejbhTWHagzTle2IemRb4/I+plk+Q4M1i9cYbexDwzcseYIZk2j5vzBb4UYfxJy
	 Mu+16J8y/iR9Ho4Fi/6/0aAWeOJoZCuuOSR8+86VtNGmeGQOhYNyc+mnORnLVNknzxQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D1AC31F01193;
	Thu, 22 Oct 2026 23:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711679;
	bh=xKkND232ckYcsr4WYPfohBQYeZlI+ZatIYYh6FT4f8I=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=WZu/L6g04B0x88eXUkp7uzabGEqZ8zfhUjLixw+q8uZEwCEM83PfjSwdf9/FzKGF0
	 utQKhWHOykrBKC6IVrLwSc3gEnSuC5k7gcb22BtC07nH1wbYUIyv4g0WS/hBaQurCz
	 /D7xH73k03uv926siiqQFWspyahQm+zUEBpgVRPsLNgwtqVUvO1biQe2rwow/TdqNd
	 OX/HN9NTaPjwG9F4LqREodnNiBFrpJE52J/1uLEnCyynwHjeAmeaNIJGF7bIKuu4uW
	 gM/xz813h4bnRqVQGv8tPUVU5U/5raUqs1QrwcPa2z2fKUplUdEg86mb+WYL4VfujZ
	 9wY8UPX4YK28Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CDE3542073;
	Thu, 22 Oct 2026 23:27:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:44 -0700
Subject: [PATCH RFC v2 12/50] KVM: selftests: Test rejection of regular
 file in tmpfs mount
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-12-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=1842;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=pDE4OVnGboOSGiy8/kldBMjQFbPdRMO9/IEWat+ioPU=;
 b=GgWocXsPVabq+HYGkSW3vHTi6dWLrVAKmjkzMiyD2mhGGJyKDlTt8oY3GVzXJAo2KuFBE2fM7
 Q4c0wDndunDA0ktzQqq9tCeTM2LcnZf8TC0DtQkts4wTJuKL9cmRODO
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 489EC100006
X-Stat-Signature: gbyj47e7d39kk7s613xhi8auucz9d6ja
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792711680-587762
X-HE-Meta: U2FsdGVkX19UBzsGXkXjK9dnE5vyyBi8tU3UWpn8JcUfdXnIzwrrIoLdQom3Av7QC0vsqfCMOHN65+YuimlV2NDNr4zJevLcRnUTzuej50uBrjNgiMZueFION/aGcCF508gNTPk90y7gLoAoXjrSpPid3st2qZLQovtNxMr2KmyjtPBI4sXlAvc2wYN5Bn29DEROGIsh+o9p4kNJG5ImLfxUFrVw2gYybvERXa50BYOv5JH0KQh72RnNn7yPE2DlF28oDwe6AM4j7SQQ2MHy7MhFHvcZoPHpXLiCUJL7Qp4Y/YiQNRaiOsySeI+p6DoWaGBwjMF+NFZu45/mp6VmIKc3PLlyGaSBiKOUiSXBSEv+R19Lx3ejuDxB0kSAY2dUDO/iEPwizveGFc3faf/CqJ596JWLyGikoSla4z7Nxo6vVT8/4IgK69jJXS30aKRnNnYXuYJDT+3+FS8vbEdQRSutaibjopRZtMabDfdDMAndD14NjS1sbbMeNEpBMwSiCrBbFLGCZG1vnAlRvOGpcJNsrM+qg21HeSWeLG2EuXGyk19F7ePuCKTfQrDqQ9RFpyM7PqnbuseITnfk1seIvYUrtLo+siPc+JHr3N4UpeRG/EsLS6tDy2XcNBYHFNfiGGXuNcK+osRhNLq6s2f9+quamSQlhalRGV/mkmhGIto6zdNBp7lgjIaES90XLZQqBOC4ZFPp81Iq56tMJgIkznX/vtQyupJsriD72rmaVCNyM3lT7c8lVXo6p1oeGkk6Fzv/3rPzWopI6f5tbWmOnYtwOP2oyw4Dl34w2n6Zb0RR98UZgOWorXvhKzQgWJRp/uyATgXE9gUbINdM63qfi+GSDjOKLf2b5AOl33KgFTLFruEMim6GYBvxYScBfXMx3R2fgMoRflko6LawfUZtNF+l1q+SEsKLxxY1VrtcDoa4kUqVg6k+WBuuT1pPLH+w2UfQyHdXoZ7zokDwt1i
 rfflMDwN
 GFV2lKnVXx4L3QC7FXhFUes0wrNM3LUZBQNMkXRTFq1nLc8G66S8QZ0IZF0Lslas/XA6UD8G7OODWz0HrR5YTGvansy6NTc7sG+DfmnmeuqJ6FOElXvNkoTO43P6+wApMlu/hLI2ei+jNuCWCvCAgX8L5Uz9EzHJ/7AYLKlyhtNXd0mZjeLG0ExBgV2Pubrv2pbuovY0Duk5dPOPW/NOTNY9Q86R2f6N+wEDwd5oDFL8kAixz/cnfC6geuTxHO0hUTjVndGFKxn4GealZFmguCloJJXSOGTKkHtO483Bxha8LFf5CiWCnFwJHRZRAVT2jqnNI/8V1KPf8GMss2sNpHo1sPumIrkildJgNiFFATYuw3MabFJZj+aeQWlvXchmBv2Xd/Oy+vJ4z9DJZjfrRtwBuf/xME05kq9C8V7rVJ0JiYT6WHP3uaZ7CDdTpssOhB3rsDx0ja8wNMh8TgH5Iu/eQEtKejAhawcoTpIvc8cFvr7xwvzVr9GU48uJSsbm+TJpSISLHM0MtfeNwcnQ49DPKQBk5vUTvPNo0CrdKcWHjckEdg1j/BbfhXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add test coverage verifying that creating a regular file inside an
actual tmpfs mount and passing that file descriptor as resource_fd
fails with EOPNOTSUPP, because tmpfs regular files do not have
gmem_provider_ops defined on their file_operations.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 541d8cdd0bbf7..bef1acead4a6d 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -613,6 +613,25 @@ static void __test_guest_memfd(struct kvm_vm *vm, u64 flags)
 	gmem_test_vm(invalid_binding, vm, flags);
 }
 
+static void test_resource_fd_tmpfs_regular_file(struct kvm_vm *vm)
+{
+	int pool_fd, file_fd, fd;
+
+	pool_fd = create_tmpfs_pool_fd("never", true, page_size);
+
+	file_fd = openat(pool_fd, "regular_file", O_CREAT | O_RDWR | O_CLOEXEC, 0644);
+	TEST_ASSERT(file_fd >= 0, "openat regular_file in tmpfs pool failed");
+
+	fd = __vm_create_guest_memfd_resource(vm, page_size,
+					      GUEST_MEMFD_FLAG_USE_RESOURCE,
+					      file_fd);
+	TEST_ASSERT(fd < 0, "guest_memfd with tmpfs regular file should fail");
+	TEST_ASSERT_EQ(errno, EOPNOTSUPP);
+
+	close(file_fd);
+	close(pool_fd);
+}
+
 static void test_guest_memfd(unsigned long vm_type)
 {
 	struct kvm_vm *vm = vm_create_barebones_type(vm_type);
@@ -625,6 +644,7 @@ static void test_guest_memfd(unsigned long vm_type)
 	test_resource_fd_memfd(vm);
 	test_resource_fd_tmpfs_swap(vm);
 	test_resource_fd_tmpfs_huge(vm);
+	test_resource_fd_tmpfs_regular_file(vm);
 
 	__test_guest_memfd(vm, 0);
 

-- 
2.56.0.257.gf7497c7d27-goog



