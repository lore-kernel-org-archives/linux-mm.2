Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 141CE6077DE0
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L2qAsoJi
Received: by kanga.kvack.org (Postfix)
	id DD2CE6B0A30; Thu, 22 Oct 2026 19:28:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D82B66B0A32; Thu, 22 Oct 2026 19:28:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71636B0A31; Thu, 22 Oct 2026 19:28:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 937466B0A2F
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 155C7802F1
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:02 +0000 (UTC)
X-FDA: 85351852404.02.25C06FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E07FE80005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:27:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L2qAsoJi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711680;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zWZPNhlVhHIuHneGcp6Ke1BtZSCn8SBM6DWKl1LXrLo=;
	b=CvqUmjwg02BHePtdLHVHsFSW+lwiYWyGtIPZ6TYjYlVDlTb5KfB1J3iRccV8FugylfG71/
	uG3r6yCnIdLKzvMmyYAemCL5Q2Z4RYXy7OmTIEE3G94yJpji07Xgppj34AQEBFrVvcGzK7
	6aCuP/rN1Agl99WfFAPn2kb2X/BaEE4=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L2qAsoJi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711680;
	b=SQjkfcrvn1Rv9C98AOkhh0aHFOUjnwuENbEyqpZrQps9CtprVuposZOQ6ofsEH3ohCZBNu
	2PBbZRs4TJSCdkwLfot8fb+haiDa30Ja2ldcO7iAKbbvH+ZfMJp2+UiclyR55C+m3raO8x
	oin5SIIBmIwelw2TmoXjwfTgZl61oxA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E3DC4479D;
	Thu, 22 Oct 2026 23:27:59 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711679;
	b=AG9YZT7iV/nBqZBeoBGY5/rljHnq9FnIFsTtzKgbofjxRnn6wlp0cNWCK1FgxofHqNKM
	 a05sn/KX/4AJOyMx4nr3OCi8Z8BAI6AmilmoXWTyD/nA5ct+9+DXaSbAmlM7ExmWvxuCI
	 D1qoxCChiKnf5gDvVVgmk6jEMLxC7KWXn/Ek2Xcnbxg/IE3VtJp5uKFh17ENpJzJxy54U
	 PeCszWunVrHFZsKFBuKRnXi1XYdqmn/hta4NpPH/qXq7jp4TIFDy+pBB2VWwuDd3L7m5j
	 Pj7Lpp/fchdVh/xSy5gth/tL8q9xzFWfqA/Mql/qSbvD+xKLSOaQjKcu3ta5VfzbxIA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711679;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=zWZPNhlVhHIuHneGcp6Ke1BtZSCn8SBM6DWKl1LXrLo=;
	b=y8DR6msRM5lSYvSba0622zOc5Z3/gw++3Z2z1ejcrx+5d/vVbcw5mCG+FZlV1x5KJkyp
	 DbzolAVDktScY9qOGq0pqi2rWBDi6M+5+vJWBi74GwKh4+UaGrDPVgivwaLWPWNq1I8rM
	 KXJ5ySprvMg82ry4coi1G7ddRRE+TN38gYFdKPrzJTo9oV0AyuMlrRAWXlhgaFxv4GWR5
	 QFtH5OAXmqsQQpJQRNjlfh6dwNdMWjSXaw/dPooS4AoiAF8FT1CPQE4mwXlkjAOgF0j1/
	 1JHCVADwFCCYRoCInLt8Asyj+K9yzLn3rdlceNAhL5qMs3+dOrrM5anPJnslHI/8EVA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 79FE51F01180;
	Thu, 22 Oct 2026 23:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711679;
	bh=zWZPNhlVhHIuHneGcp6Ke1BtZSCn8SBM6DWKl1LXrLo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=L2qAsoJi3Yw1xzg1+iEw/4NyGOK7j4B0vEy46cKE2BW6vvLfUlhZRnDvk4uqEyqC7
	 jTm0hkR24QjQPa0yVRX9NDcR23CoEvOy0qWx2XcayTrZ8h1LK7VlH32EDzORq8Xb0W
	 gRR9pnD9Nc7EV59IhoJY8yxjcM9pBe5bduarOW+qznCox/xwRq7mZR+aacmgOHT4xf
	 Vqb0DUsKknCQWeGSW2e8rqL5vZSTW2qV/IOrbnR0z5ovGF64MwIQX/kXlEjFVlvmkQ
	 X3ultXOpji3BcuTiTlFx/1bupYwnSzyNkRBzzcsX20f3Xu4zeBl2369kgNrS5LXDh2
	 NcBfugKj12clQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A8AEA42067;
	Thu, 22 Oct 2026 23:27:48 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:41 -0700
Subject: [PATCH RFC v2 09/50] KVM: selftests: Test rejection of memfd for
 resource_fd
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-9-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=1909;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=qTja1erI/Lan5wmGs9jbLgcIfoZ3cox1rPf5vW4srgs=;
 b=rew4+7ZZjD6ryhzcWU6m/IEO4Mn/eGn4S6P1gpc2Xyar1xtPPFqbC9vU2tNnvjWrBnFpovP09
 ++QGuwuIvWnDng1N+Ovvgujyhlo+c7XuMKrwUcV7a74mJEw0lbWBznt
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E07FE80005
X-Stat-Signature: ssrdkybjfb3api7hhkhpuyd4f3qtf9ck
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792711679-192603
X-HE-Meta: U2FsdGVkX1+oHvne34/EEBYqnJXrstxhKHBkwDgqtxPcxlnLjjMD0brSNytYd18z9PlbrRNbUSdofdtxJudge5RRI6B4ZKEp5sZ0np8R9OHfEyNi1ckr8rwUMBLkMnr/nvn6iISBQIgUvE9T4lHDJ5FZae/bXGmk9EZd21gNoeLiI3qiuKf5AbHwtINeLx0LdnqNcQMtkg5XGsapNomBxaHe8jiVjOH+vsrUC9aAZx5b0933l4ubzyY/6rPeLQ9VC87XEp3MKE11UXBAhFZqChcMp1kzlkTD6CmcTKR/RyTotYXuekxN16PkA5FXA1wW8DSlvFTdtUJGqyQxLwXU/K4cDCvo3y7DQPrdobb6lsT0CXkg4F6xT6fD7XKeiz1d1kaoApNAAiZIQBZ7czrxTdIfWv+oDHy8l7WE+LZDKbw1/bMEUy7bBCkxPJ3N4eevkGnOjbmF8UTCh5UNxXL9BjDLMq1uy8E+V1YbZkBRo175nnBnRqS/U8AjF1097fhAYsHgPdPpaoGZd/fh7hfdgBlOyhzYLHSB/MwOnfri01CbLPyit+jICumA0vxtysfWTJovT+Ch/sR2MC0sfzmWOgTHHJnuBvRObn+bRCgd13b3FaDjULjkzV2vUq6vy7+00mkz1MYMfBmVrc72D9t6BpM2HjG2g0tA/mEaS7AXoWf+z37MYOYZL9sbW+JNbhl/7klxCFeJg1ecxR+VyZRtqHZndw0Iu5wM5JBw84RjAMIvcbmKJvVtL51jLtOjeY5CorgHQy42GM8CrFJQGNhMtyAlxlo8E5Eh569ReyWnwdIKZwVeAhlTrB9famHp1XelJiLs0AIoOG4W35OiZ+Yx0dRraMQciPhMCCt1dGOR3VGjQY2OVgnEmRGSpUD0VRQMDAWsup5hxtBKcQHQJyf0sAHvaPWx09RhiCOrVzl0qUKxa2IQZgUvENi91GC/qK6UqagPEO3ABq9mz8GATwC
 QFguKK94
 33AWZrgOz3zPVrwwaz6tf4IbeA8L123YlmHhtiHe5IJaQugavPzmeAjKM9MuNtqwkVfPL3rTKZfVKPYmdQPayXkhOSk0FwGOoHYG8hnwDjjvtzSMm/7jg742FYnTx7NH76NwoG2Q7dYRaASqobLC0Ew7UOSMjivszq1zQJvuSf6rM/1yg+q79qAGXbgNTl+6kVuhm1wRZF3OZfVexVU+zsjmeJ1ZndPf6zybdy5bMTxpem0L5sJDC8wDVHHBuAHGk8ZKApIo/vFeIYwXZ1sxE3Lr3vuQZ0yD66YSLQdwjYkuFNRO+spCeeFXtbvYkDvAazg89ksnoyR5HpIk1j1Elhbp2ng/IaIJCTsDzi6n3nqb2c4b8n4m1NO6O3QDRCsfz5juMluEmTfwqmW9SxhwUvXJ3IjnNsby9r/C4sS84CYcULC586u1+KxbYfyOb/vThxIQPYPJM1EqpYaIiHUYWdq1nIteGxwjs2hlI57UOPuXtgLaU3UU1gARQLv6yrjkP1cuoJRufdc/R8+zUMqx8rgVxiIX5xlgTyaLz/gsnXigGJ7Iz7V+xbZvN4SoNCwInOPY3BX3e2jN3kbhGs5canF8tdlRDd5KqI6n54u3XDalauW0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add test coverage verifying that passing an fd created via memfd_create
as a resource file fails with EOPNOTSUPP, because regular files do not
implement gmem_provider_ops. Only directory file descriptors representing
the mount root are supported as resource pools.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 445396860d819..d62ae23256083 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -457,6 +457,27 @@ static void test_resource_fd_unsupported_fs(struct kvm_vm *vm)
 	close(file_fd);
 }
 
+static void test_resource_fd_memfd(struct kvm_vm *vm)
+{
+	int fd, file_fd;
+
+	/*
+	 * Passing an fd returned by memfd_create is rejected with EOPNOTSUPP
+	 * because regular files do not have gmem_provider_ops defined on their
+	 * f_op. Only directory FDs representing the mount root are supported
+	 * resource pools.
+	 */
+	file_fd = memfd_create("test_memfd", 0);
+	TEST_ASSERT(file_fd >= 0, "memfd_create failed");
+
+	fd = __vm_create_guest_memfd_resource(vm, page_size,
+					      GUEST_MEMFD_FLAG_USE_RESOURCE,
+					      file_fd);
+	TEST_ASSERT(fd < 0, "guest_memfd with memfd should fail");
+	TEST_ASSERT_EQ(errno, EOPNOTSUPP);
+	close(file_fd);
+}
+
 #define ____gmem_test(__test, __vm, __flags, __gmem_size, args...)	\
 do {									\
 	int fd = vm_create_guest_memfd(__vm, __gmem_size, __flags);	\
@@ -517,6 +538,7 @@ static void test_guest_memfd(unsigned long vm_type)
 
 	test_resource_fd_invalid(vm);
 	test_resource_fd_unsupported_fs(vm);
+	test_resource_fd_memfd(vm);
 
 	__test_guest_memfd(vm, 0);
 

-- 
2.56.0.257.gf7497c7d27-goog



