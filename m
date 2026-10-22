Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46804606BEBE
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 23:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ax7kjaLD
Received: by kanga.kvack.org (Postfix)
	id 9B4286B0A34; Thu, 22 Oct 2026 19:28:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 965B86B0A35; Thu, 22 Oct 2026 19:28:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82BF26B0A36; Thu, 22 Oct 2026 19:28:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B5136B0A34
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 19:28:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8FBB01A034D
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:05 +0000 (UTC)
X-FDA: 85351852530.24.F9CF5E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7C0CD120009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 23:28:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ax7kjaLD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792711683;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SFdMQT7RD1BLjVi7Ab5eCk5xGexiV+/iCJCFEFzCdRM=;
	b=cyAwuDzPzIgPYATLLU3RUq8QNQDj/BX6Z6yGKi4rnvoEyhnnTRj/KT5421UNE3Z70E6mbk
	+u2rzQNoflybFEm8UeCly1IeMwAermuMPdOQl9ipCsLqqYYR4LO77YxG7NpfaBqFYYyD/V
	E3E/ONczwxHmV0qeDEuKsCeicXV4rTE=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ax7kjaLD;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792711683;
	b=fxZjjCrvHED+NzxWfGOG4E7zAhgtWqtcKnP262nclUf88VgPhnoQ/rSWW75BpJd0XgiOjg
	iKCnB2CYejYAFj4CKihxRu9lG/qliWw9VsZ+OajP3zLSw9LpVc1/bky5Us9Xid2WN0C9ac
	JV/DxwPbCZKGBqoXws/rZHoElQsusH8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D501447AC;
	Thu, 22 Oct 2026 23:28:02 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1792711682;
	b=JIBzmE3N9kSkTNa5igaCbfVumYkfGfh8lUc8b2WcdJ19v0GiqVatNhOlqYPE74BfRYRi
	 GXmTfv09VuXnCp+SnQu2/8bto1/py4dKnkfFnIAmDW8fZ8KVF+113wc3Ut+9aIfqZT+HO
	 YquRILnyBSMtb9PNBDJJTp1u34uuSmzsuCYDlDnC2pwvy9k9IEjeMvi6ux4UkU3ZKqT5k
	 LUZ08U0ZhnpLXQF14AP3v+ciMehvZHygfXa89DM51Tc109DdyZtu07VZHIdDfnVIByiRS
	 GeS8ADJsKxs6EbenyxGg7r+t7L1+Dxh0ore1AxtPb9t4XQrSmqClN6IJMfQb9K8cujA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1792711682;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=SFdMQT7RD1BLjVi7Ab5eCk5xGexiV+/iCJCFEFzCdRM=;
	b=Ox8XH9s5eoix5QXKNxQirzguuj51DXZR8JX4YG0wdKht4DVfhvul52I/z+0ecny4Ou0c
	 MiI07fHR92g1HZJkB1djaUNql404THik9CfYAqO0KaqBDWxNamOJYq+BngdMJwDm3X+dJ
	 kXL4k3Wm64wvJlP85k0HmX5teYOpExz/BvAcsHOIOhTAu+W4PXTRqwiWJHBM5fD92dVwo
	 mdTh8R35+Z7WriL40DY7NBCPWCkC6xIGbodCChwRCCL+QaBODooi1m5oRJPs/8rgcFB29
	 s//rO+47TkbwnxwTQtVWOMDnirvwZMPlrDetzREoggx6UQu3MgicRBQ7YNjH6N0YIpg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B6D301F0119F;
	Thu, 22 Oct 2026 23:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792711682;
	bh=SFdMQT7RD1BLjVi7Ab5eCk5xGexiV+/iCJCFEFzCdRM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=ax7kjaLDGnEXjDfPRTML6M4rMu+iY3z/jEBafbjfeMRaQruuj7xhXL71sA25dhKnE
	 KVRjXR/EbDnX1h9WjO8qpkjmDB38FtwzalE/p7MVcIhroTDllJBEVGLiIzFXdXjVSt
	 D2543jpHHjMpIuD0IW2Jew0yXxS6hlUrPvu1BHuDqRYQ8Ci8acG5vlJw/VAhuT62gD
	 BSZpWoMwPdohR1gMt9Rey7M0ihuB5iPW5iql5r9oTe5oDR7tTaheRD7wNHCMpKmNKR
	 bD7qX5pFg3iYe42PIwpKjmm/tWsVEXfJzmAdQ+F1Aq6e3nOgUE0t9UL8iTEYjqSnC2
	 g/lO8i0WgpmzA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 07BC042083;
	Thu, 22 Oct 2026 23:27:49 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Thu, 22 Oct 2026 16:27:48 -0700
Subject: [PATCH RFC v2 16/50] KVM: selftests: Test that shared tmpfs
 resource pool size limit is respected
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261022-gmem-alternative-providers-v2-16-5dd1dc6c660a@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792711665; l=1067;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=AQwSKZXbF8L/tHqgweqYig9l72GDNK/MpFua+P6X8zs=;
 b=Ix5H+hGnyoYH44QhEgu0GyppTZeI87NZ0i8CAhkmNXUohK1DTTmtPG1CNQeel0FhoQmoNccUc
 awsMx9bB7tVBkeyCpQkk3kfTmR1/3L29+gJM1r0yvmt9sTiCVc5Hiwh
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7C0CD120009
X-Stat-Signature: nrz8pczatuh6415oxbge1o36z1oycsii
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792711683-652074
X-HE-Meta: U2FsdGVkX19mcfnArfVHOFQvJO9WlmHr3nRQQdsDPQErrT58HuA81MuvL6URhdlvqGZ7KNE3VMOcXhLcg9JECAGjVkFvlcRKRnv6gwLMz7rm4CdKyYdgf5akfSIjnOGxmP4Bgjo9ud09mY86jYZw9zyvx0H9md1h4x8GxweM0lkFhbaUCKlWN8L6gKgi2WtQqR0oVFWCtxMGrVQpzBwrCq25ZDAAKEBsChU2sKvdtxC7YeC7AC1wStVQSfLiqcetP1gMrwNSmXLtrs2TuCQu6gEE5fTU6l+IbFu57oG0NK1h9JYFtA09HwE0RSg1NkkS9VBErfx35HlKi30QY5bpfLCa6ekRBTKvutTyo7HaT1XPnhr3FMTShX0eomLvGrOqjm2eEdEy6/T98yatKA4oUQsjqIBNMaczg4BjDxCdv8D4xyik3XLhiqrAla7i2FBPix/cSK18/Zjn+v1qCRooUMHkbyiQZ08xW3M55B66mV4Ym2D7pOcy8ibFCEi4YA9pFQosXeSlIqRJ4e3oWVq1JrvZd3ybtceuu3f7U6rsZNHB3Cjer4Iw+098BhmlxalDgeFhEX/kofqjEGcEO7hTDnEqosIxR15kGiqeD6lRLqW4PZ0KR4duLjMAFldeIflcWmSRFZQUcTTGxAZ/wb7nODK9B6lFhHyi5v9JaegzpiwiT0FIHhZIL2p1qkTEnz9Fnhuk82/PFLQ53No0f4BhcBahjfWmhdFqtFwn80agqu+EF0eGVvyAk1PoQ+vn3ovQSsVqjl6CuJvbFyi489nn1wZ36elcLNGEglAMIhLfDR0XL3NM09sO3pgqrTFTLZ2ZUOdtr3q0pFaofufutIv69yOoPo2wm6NoPvttx4obRUz0z081Ig/jyWR+J51XYJ5YhPgD8RPoyaDd+eQM7vud9pV6wq7E65vpIeidIw3Xd2HynM8PzoZXLhacTUlf7jsRpetjyxdocylr5gNLXUO
 yXQlvHV1
 oFFCcsq6JUwDBrMAcq20v6MdLiUOw3GkyFmdF0StQN/pZCT32v2JLCusvYbGVZyjoF7+9cE0YWMBQbA4MQpvufzOFqh9etV3qWzFcCcU+RE/WYT+IdK9V0itlbpQ4vENzCYxy//Gr25Xit58bHCcBpOu42WBh2GHWuhiZlYMXCIg3NHtWaSm4D33dBl6qt1xo/oPJ0Gb0kmnqXPFqc1F6sYmnH7/1BxYmFUQghMRZ0PUVnNUqjKqGlbQ9I9GHn/581/Lr8JMEJycPOMolY53DEFkGAP7svjSRsHY1au3wtfQomFAfK7PUVsv0gACj2d57qH3AAQr91gaIQmEkzZmP9wIZ6oneSC64YIhS2NyYEGWRwrPqkeY/B9QjgfvL4uKjWM+RWVsyzfvBzejXFSwAx7U37/V5g0OLOb20vPF3kjuTyvapJYdhKZUVL1zg7Le4utVHIW+eHgljtLqM2e/g/4DQYqFH35OuOuQ8EKdua68rCod5J3FXC5dyfW/mC2MHxmelW5HBDAufihOMXaZSe1kz8TX6Q8H44t/9GEKExUe1Vb0Yivzll9Z1EQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Verify that allocating memory across guest_memfd instances sharing a
tmpfs resource pool fails with ENOSPC when the total allocation exceeds
the pool capacity.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 639b1b0c204ed..20de24ad535f1 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -604,6 +604,10 @@ static void test_resource_fd_tmpfs_shared_pool(struct kvm_vm *vm)
 	TEST_ASSERT(!fstatvfs(pool_fd, &svfs), "fstatvfs on pool_fd should succeed");
 	TEST_ASSERT_EQ(svfs.f_blocks - svfs.f_bfree, 2);
 
+	ret = fallocate(fd2, FALLOC_FL_KEEP_SIZE, page_size, page_size);
+	TEST_ASSERT(ret < 0, "fallocate exceeding pool capacity should fail");
+	TEST_ASSERT_EQ(errno, ENOSPC);
+
 	close(fd2);
 	close(fd1);
 	close(pool_fd);

-- 
2.56.0.257.gf7497c7d27-goog



