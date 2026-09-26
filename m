Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A9A5C9830E
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 00:51:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 389A86B0093; Fri, 25 Sep 2026 20:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3159A6B009D; Fri, 25 Sep 2026 20:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02BA66B0093; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3E596B0096
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5EEFF1A078C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:55 +0000 (UTC)
X-FDA: 85254083670.28.F86C2CC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5BEEF80005
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U4HQpCbZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790383853;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3JEyx0x/ijAm0RuFYhPOpYek+zeDnQi/CMz1ANm6DS4=;
	b=sGyr//3rv50i8+MW1HfJyIlhagTD/QmwATKut/nn1e67m5OHa53nVYjYCATk4bryjj682W
	fOsc6MYdzA/YV+6/0VW0GtHasX517Du2Bav6Dq8HdvdsfNwWhQug/zJ7LT6r35EQ1Et/ja
	813WN+NBi05Z811KHIXrslCJO231vaw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U4HQpCbZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790383853;
	b=P1UaKvltCLZRCp6f1qbfJugulo2w64XUXi/m/rybvzpTrxpPWVqlIL0WqVif3qjfhw1WM1
	jy2Y0yeAu5+9Zy74VlsNfdOMUv43hYW6fRDF0GJXRR9LnmQkoBrCwCU6L/bqoYSa5DezHh
	lsWD9mCXOmsB96cZcLcSFsxWie/4y80=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DC9E8447BA;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AC027C4AF09;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790383851;
	bh=WcDRsHkmlxq31EOsgijIocsiUREamnuasZXvE6eFUyI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=U4HQpCbZK5DG8EZSGPYthln3S1ikiBLlPTp/6Imauraia0pHu6XggYsoik1z4O5Vm
	 G+bDso8dO019O5l7S2Ifzih21I+R5P+HgyJxOcMzfbK8xJQkyRO8j075vQeKAIoa6X
	 5rPiWS70iViKpVTPTZeHbhZDJuSnHcWrd6+9qX0Q2833c+Sgp/+3VUfNC0UK1URzPf
	 JlSvx0d+KYL7+e1XJD3No3C48qJjx6i0TVgunRaD52eCeSSlblhghvltTX9bawMoGa
	 Nxdlv2Y4bpCRW2PgYEIAWTUcITy0umn4q/5NdqtoJnzZG4nDatp/O4na8zFng2S5tx
	 rgYZN3potO+sg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9175AC9832F;
	Sat, 26 Sep 2026 00:50:51 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 25 Sep 2026 17:50:53 -0700
Subject: [PATCH RFC 06/17] KVM: selftests: Test negative validation of
 resource_fd argument
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-gmem-tmpfs-backend-v1-6-d36159822d18@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790383850; l=2106;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=iBvHnSmUj0NiYI2gh2HdRSLcUfZMIscuYT1+68ta7ps=;
 b=FmJHODI39gS8wDYTgZFvNQSKXaYtDDeUYWD/fb9mP0pf/vGXvL776WINNrhuTxNGtGgGFIwu3
 kp54PCvz2vyAlH9LzU8o1bP2LMsgZu7zqGDgKG8+EizfmBgpVE+lM+U
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Queue-Id: 5BEEF80005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 6his9bndzcrokzy6oxm5dicnca6zgp4h
X-HE-Tag: 1790383853-365491
X-HE-Meta: U2FsdGVkX1+db9jLEzPK7549T3qqrecB7LdEFNtmM3PgFaQ9CuwJbCCW8cMOGBMfzn75u0O+N6+o6qyV3YaNmzOw/I2wmZUwgF8ZCNDFqn6UE6OgQUF5rek9SPjDAwfmB7dmNJsF1yX8nfgADMAQ2xpAdgZdhq/MjhoQSqXfP7w7i4e9FDwkFTqrCSBFzhb1lz6RDiNx6j+tfuzub9GtqoWKVbtOQ6Do+ZpLCLNoYzMmuCdgsDB6jscto/bGK9b/QAEdhl6laZVPV85HMEjpHP3FAvHBVWUR0eQeg4MhlgXRV2jo2pkAKUqoC2e8cwxDiDiled6gtgjtYYcDiisMmqegaSIbmnmRSvTDzyZ2ACXox782GgJS0mIcddaWG0/vTKAzaR5G/CFPo+QyZTBMI0UYjlhSWWNrMMn+0lZdTdV4t5fHP+WZEYPEa0BnMQMIRLo6tAs1e6fU2l5OwrBRMbAV0SZ9fKoEOJs225jcQgrDBYg6SczsRH0i/+L+7c7+NCIWEwjEXtmMdwljYwVftzmXN8LbpN9XFq7vGac+oNhEWzXAHxgKkkakUUQtxp7hGsccA3ILOjxK9d8jQd2pXHalRA5HgjZF6jzjbvJSHY+pmRMnDR7DKTR5bEWaD0nCWUVQpFMGSUHfQAeEY2gP/IkHoK1r3waQxkHceqd0hYBFphVZeI+QndC3uBOwvC8zCg9dVyB5C+st01HiAMLe3qV8fzHuzGtZzq2PblWAM3oC6DeKPJPQf+1r67gkTwVBtuL891dH/IQccPBEKQhCgpMqQJnMZ5GAA33OpQGLRJXf4spSwT7xPPGUcE9yHJsDlbpm5R6fgoFFMddGbkiSPoXxiSfjO1+hi5yPQisClR15maZ3YnqMUDqX6xuNl0bN4Jqgw1djMDZvmCqbH5lRjeI9FWVOcfYY/OGnWnjaINGZOT+pQWwg/zq7IEKvjPrtY6XksA9/VodX1VqhLki
 7jvfkehG
 DOR2U1x6HJKtNLBEBdvU+heo7T/Zzp0pw4vUbG5V6PIkWGvtG5ODnvrSnIvImflD/WIKBQFUeNnr5O56ti9tNJSGI8YFdwa36Q3jS4MnOY9YMonBWbPoqxw08cTOrxnp9QHy9PP4LXDOXM4UagHCA2DnWg/P5GnRmzyR16LC0VjomOA5NtwJCQ6QwM87ckDxKnffTFhN5dQccASB0FXBMZ9omNvxBfIFRTBEWJ+M0S+F8dLpGKpCLcKcyyTe7d4tu1fLRst/T5r1NjwvESxlY0d5X9K5buxj/qgxiG71qRsS8qVPd7odvXINLsDk/fgO4bchndl0dvyvv2sla5/aJel/NLRCyMAf/7cV/92DBOqDbXSnn3GMZOffTmOjZb9AQBKq+LIc11eE29rx7QrJiwOOelxEQbvr2iBrLo7uhegUs+fDGBVw/WhzMOGsd0QwqmVgEpxJOXy5Lz3pzR9SrfTDxPBBLiL1tmjE1TT1iJUtZdVGpEkH0xQSH/DJqfJTO1auY/qN9Ul1bi+HT1gkrTNZPUlfVofsnoN1J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index 2233d871a38f4..84b958b9ef715 100644
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
2.56.0.rc1.315.gc6ed9934b7-goog



