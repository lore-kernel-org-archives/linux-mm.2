Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BB61C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 00:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ED1F6B008C; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B76B6B0092; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 758586B0096; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4FEBC6B0092
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D1DB21C366F
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:54 +0000 (UTC)
X-FDA: 85254083628.06.F32E754
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id DBEAF20006
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UspMjIxQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790383852;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UFnTi6C/pzgh0Llcx9gRgElHgydpdUPwdjDK86Wbzmc=;
	b=2oPKLeiRfCRoIZalqBGxacYOlGz0pvfz/SzD1HMuJjE48X06FaQGlC4OT6qoYcHyWejzRh
	hgAwNq+Lkwb7weLItZVVyDMjAXzbVK19XYqFBhq82CxjAOb5UZGmwsHNcx+QAxBLd+D8+1
	5MxLSV55/vwTgUL0wUVl1Eo2GYL6cAI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UspMjIxQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790383852;
	b=yuOHFF0rcTjwQI38aBmy+Y0LIae/pEP9coC32y+AzZiF7Q01nLLl8zp8kncdap2UV/Frbd
	AzVs+0WfDV3xqd//97gnaAq/pp9TwoERLORShfVQg6DalHBprR/+/lvW4Txt4XZBA4BHoJ
	HDmhGhHS/KjFQUFecxoimMSQksNiDgY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 00C8360514;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B91C7C2BD04;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790383851;
	bh=mZ6OpaKM8VSu2SUTDptmmvQXAdF/0DN8J0W5GQhjVxA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=UspMjIxQEFvLsiPa9D9JSrei2wJz1ci0gFONIhtAqb67tNFtAT5mLgMCFE/dSH/BB
	 ZOmZDz/RyUGjmGAitUGHv0I22Jp68jtWVc/gVDn+5ZWrpcP/kP8gYBxkt9HSTo6mFj
	 PsFMRlr2JTrPguxNGQD9PDc+PJWCKaMcs75jihPYuvTygWEMfpJZUqQSbtIF0Aofkj
	 DZ6EFz45igxPuiqL0zsK7RA9FaxomxQZRG5Ceis+7cwuatYA2KleYQ4wBm3Bz/wkw+
	 9L+HNygzTF8LZY3DfKoCFwESTGhlcCE0g2W/HJCeOnGJxd8ZiytYlmIwNZ0pfzg31r
	 Uy8ALX2tguiHg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A14E9C9830E;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 25 Sep 2026 17:50:54 -0700
Subject: [PATCH RFC 07/17] KVM: selftests: Test rejection of unsupported
 filesystem for resource_fd
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-gmem-tmpfs-backend-v1-7-d36159822d18@google.com>
References: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
In-Reply-To: <20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com>
To: Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>, David Hildenbrand <david@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <shuah@kernel.org>, 
 vannapurve@google.com, erdemaktas@google.com, jxgao@google.com, 
 rientjes@google.com, fvdl@google.com, jthoughton@google.com, 
 tarunsahu@google.com, pratyush@kernel.org, fuad.tabba@linux.dev, 
 Gregory Price <gourry@gourry.net>, David Woodhouse <dwmw2@infradead.org>, 
 yan.y.zhao@intel.com, michael.roth@amd.com, suzuki.poulose@arm.com, 
 Christian Brauner <brauner@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
 Nicolin Chen <nicolinc@nvidia.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
 aik@amd.com, aneesh.kumar@kernel.org, Vlastimil Babka <vbabka@kernel.org>
Cc: kernel-team@android.com, kernel-team@meta.com, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790383850; l=1760;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=c84B6n44NVtK2sHukMLB5KU4J3iKw7GkSZw3Puqe1NE=;
 b=mcUInbCP1l8RBE0LpSG40yF7SVS0NuEdAcubDuydYZGl6HTZiLO6aKz+MNMBBt9W88whJp98Y
 rYy1PfGCdV/CUbRH++lB6miMh/H7JzZ5SsHOreuZCnL0q9f+cNQcqzO
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: DBEAF20006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: y3rfpsjhoxttjrniikjqkrufdj3epbqx
X-HE-Tag: 1790383852-601097
X-HE-Meta: U2FsdGVkX18sm0Wn7dfnAsVDWBA8JnfYQy4QKgpsfr8Bb4sYW+FG9dwnMfKIQZqqwWQrp5f/EEu87HqYCbwUbiOAp0xNyX2HT/B2l+WlhFz/4fDMrLPGQ/OWCCsS9V4nTZGlZ0kTgnWdVmUt1+5wrCcFucrE6pEja+8fH+Hm2t2ATVb0Dr5V6dnZdJ+vBduzPArLYFlYGlsNIujJ9683jbf4i454WPK6B+xnC1m5andBJpqx6ytqFFk7az/w/Zvrq0LGb/eql+fBmN8DUcA9YWerHklQgV/S4Kp5vg1qtyR8aVDLLLlMGMyeHaOnWl56msb1RYQYZqNYKWsGecP0Uze9tLibdBprDZnwfTHN0Cgpr/8W0dZ911Ojw0iqOmJyoUV6yV2m3l79LvpJsv/qbPqKIPY1LK/akcXRHCKKpLaBSeuO/H9EKmQP9+IhXDPVECBFEcC6Bp7djtDTyB6Rd2XwQDZ0EgHZjHkT+W8AkzxOELp00dduMotHs/5YYVG74SoqpokvOXHaD2FC50c9oQS5FlEgEJGMQPJPPEp16Yh0WKR2bgk6Tyr1PsYkGH4fOcB405IQ12Xny/yIyavoScR0aQmR2reV7KZorpAD62hCAMABlhbu88364le2yIs38LlOLPvExQi1+AQDzK53L1hyt1yAsIbWViwStUlkWcLlqEhcmnJI5ePQpOkd75VBILGj1oqQPBA5MsntCBDD3oUHNfDO33Hf3arG24zxJR5ruXQQuamKd2ZZJ7eU0f6hd4e6lAK3W9UR+j6nMlL0eflOxZrF1/6IFLckzWOIl5cm8jqCYwrZXBzetAA9AG9E7bKT5jOapGKztpLFdXav6bnTCX+aBlkiTwqS5Hy+T0NNsgS7n5A1xZ62CLGQmCA/euCKuFhHePI0O1VAmyi0Ox763cntNIZr6gqInMUDNhFktkd/hGhNBFD3pSdyrckYiWBeeZbyXnfURu079JF
 qNghDQk0
 CKLzRMFTeqDngFBszs6AQUInHR0nnCVxJkQJ2iClZ/BMJfNzcpHvtYcwQJHTvuWMmUnUPXVXwoo09xLxylNkhttzyj78KFgvgT/ZJkOwTfRJ0NHNsvVswIvInbj7QEeAodp62kdnTfOl09YEDFXUdraPOYQqh73bHDE1y5NFKhUtw9+1xUnbFXhRqxhIq8kqNSC27dZmKYWvsrXRbwkkawxtpDO2QdzlTd4+ZKMCzWzHfyB5+FxjIEjizWT5WRxViLRB4esqYk8lVl82g1LkKR5fHVlmv24fH6kyZxLtJKaYcjxkKv6QFp1NrMTjuUGNSBKBPxEElobB0q5UbPnvpHYfjHmlOFsiat3+fTAYITs1bdj0S76AV5MQl6HYcsJI5DRbvR0DTcDF81J9OG4ju6fcfNunB40lxokwGjyLfgat9q+O/cQGcn2qGCaRzozXRE3xyEe8j2oDTd07yxbjvb5eVzEKlbD37i5WL0xTDORNvkj+2KjpPzVP+61t0o5zOs6rnw4JLEGLeLbQdxxo8Q2z4aw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add test coverage verifying that passing a directory file descriptor
from an unsupported filesystem without provider operations as a resource
file fails with EOPNOTSUPP.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 84b958b9ef715..31bc74c4c26bd 100644
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
2.56.0.rc1.315.gc6ed9934b7-goog



