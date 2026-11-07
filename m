Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CE836606A819
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cjRjDf/U
Received: by kanga.kvack.org (Postfix)
	id 5161A6B05EE; Fri,  6 Nov 2026 19:37:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 477B76B05EF; Fri,  6 Nov 2026 19:37:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 318466B05EE; Fri,  6 Nov 2026 19:37:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EBADC6B05EF
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:18 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C17AA01A4
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:18 +0000 (UTC)
X-FDA: 85406458956.12.D39CB3E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7485540006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cjRjDf/U";
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011836;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s0F8jvacFzHXtq1BNYj1XM72iSeOawkyFa8eWHiNWfw=;
	b=mYY5FuOyLe7zvldjgT5UXHBrzelJaHkm+CpvaPCzhJyn4bwdWdYLU/NhAIHuoTzKGE5DNN
	y3GlsJZLfqM9uiX006M7SgmmfQcfDAdzKz+MYvFb1yvYqzDbhKTV+y1AQhhXY2RzdoemNm
	ckv8dxpjhmjskVDEufW3ZJUVap9DaGo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011836;
	b=HfJyY254ZSmNJTIvuxih2cyt2BKoOXt+aCcqi+wJeLVlAhPKnrqVsXfojoFSdcyej9ozB4
	ZUH2laMLaj+bbFfBqHXqt4Ghuku64BbfRmX1+zJELOU+GUDh1O5n9CBE/vNGHyMRbb1rhr
	pTDaB7Qw3p2gG0P+P6xfdshBNwrZTF0=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="cjRjDf/U";
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 41C7D43F19;
	Sat,  7 Nov 2026 00:37:16 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011836;
	b=ROLs1mGmGaXr4nf5VeW7xa4FI4ARw97o9g8w4Mk8n6OrZSg8GX2Ph4gEE3y85HJz3aqQ
	 cJsaG/CRZfOxrYrCSPkXsp6CT/PP02sXJws9G1y4RPrDf6SwrMstI+KsqPE4VeR5Ci/lf
	 vGUd2onDjiBvaj0rCeapFfzeeU93l8Pg2TwkEIXrtpm11zDB/X9Ch3tgMVPnf9QT44al6
	 R0GFoqhv1H3bWvAYtcNP9ycVi/je+y/wlokWpshBCFMlfcocEvM6ISvJJz7kLC1f2Eu4u
	 aS2hVxU+HlfCX0m/HxYAvOTefosaMqYbP9dUTrYCHrW4qx+ePgWoMh9aob5JOAa7jIg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011836;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=s0F8jvacFzHXtq1BNYj1XM72iSeOawkyFa8eWHiNWfw=;
	b=B+OkdPsHUv8ySdiYEuVCd4HOaAVFZlR7RUbdaghw0ZfAw3DdDbHmZsKyVxmd7NJnHAi0
	 yx+0/3SXYFXguDhF0q1U6AZcFkrTC1LbZXQ2tdG6iPtvZON9dJ/OMMSKTsIK7yQ0wBAZW
	 8cBKNtmHGDZF7u7CFyeZ0UfzjhwGzSOV3W+Mj8Ph3/O+FchJT6iGzvwrZ0v3tlNChXHfm
	 kn8xCb6QtNebwEfUVN1IcjA5g9aEZkNiZ78Tm5F+AeO6JwF/ZT33f/VM7htb9moJglZX1
	 27y64/foBL5hJr121aSWrdF8IATf3/ch8TBFYAj3R0iGnRlVgizrash67KmBn/tiEWQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 537A61F0092F;
	Sat,  7 Nov 2026 00:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011836;
	bh=s0F8jvacFzHXtq1BNYj1XM72iSeOawkyFa8eWHiNWfw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=cjRjDf/US9xa3V98KO6V4mH2o1LdydfcwvxsMwmk+UkSwxLoF3bix9AAFi1lzaVja
	 qRF1IFAD0pt5NU7eBEQtDsrKBMJcGVztW1hkCADtM3qr1zgcGGiDx4BbNtz97WSS3k
	 qLtOYWrvFc4ktIXZtWXvTvEinxQl9t4biA8nXcmHKITXdyoK16Af4nN/1Z2CvZPaGg
	 fnD0gJMouFMV1T3VmBAkeJ4RNcxbo40Dwk1BV9ps4QgR8RtpYoPOvg8bVVzzNFaxnQ
	 7TjnZzsf/Ii+ZNv9DvooPJ5KVwP1XXx+GqgPwrAro/7pngSUGNVWo4qN9Isf+H/Y0r
	 +/ZLTgbufeX7w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id DB285479BC;
	Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:17 -0800
Subject: [PATCH RFC v3 43/88] KVM: selftests: Test flag dependency of
 PFN_MODE on USE_RESOURCE
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-43-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011810; l=2495;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=EE/Gsp3+vkbnMZChnYBAJO/h7nnosq/HYGBfPtTEjSg=;
 b=QNfSEUjkf0mmaRJLidwIxGxZJjYboqSAt3/LrwLXP/KiV2nJmCAw/FG1dfUDbyKYK7iveNUQ3
 h7EkpJWjXFUD0P2174TJKMc5yyC09FzAG8K29bj7LwtBDRnjEvqoMxu
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wykdm3sb4fizr9xie5hocgt1gi8mrqa7
X-Rspamd-Queue-Id: 7485540006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011836-98374
X-HE-Meta: U2FsdGVkX18Gg6yRD8UeacxlNs7QdMXm253MU2RYZ7map/xdiGDOaNjwtyS0VPMguzQ9I72m4JOnrsvvgHn4qQb6jYeBslzcGyCD/SAk7kI1+leDVcsCA4MroQGVZZ6N+j/9hffctpiaKTEEY8VK1i5mCOLLdSP7f68FQvs+DQzJ4UkXAATBxgC1jouafCR9XgW36C8g/M7t53jo9FgBVpIndikGU/VeGwbcBYXC28MWE36I7uHaKu/cSpaONhVVatXn368M/qWzrRnbcej/xRumSP0SBmu9p7k6+Hhqp3AgdyfNUOvOiIQzsKkXgNwbnu8abundB3395cOW+qtU5IZPjdGeDRB9hIjh/bP3u+70tK0yP4bkYrVL1acdRNoj9pG34UjBeXqcMn/7WCA5EBd73kFTZyLUnTyB8fwiHUladJiEzH/unhpBQbysseAT2bl96HFbLXHkUO0DkE8URafx1BTxwCv0afrAy7YZR6AmIb3CSpOyezyMA80ChGqOFyGFeBW7OD736j8I9ciFbCvPt0Va+0ceL6eQzxNlWRA9TnAkXfoAUnaxjTsq/dmkxyhObqE0/9FODUSJym1Q3zZwYn8d7PCw1cpD8OnrlOl3TS9D5RbKuBIi15wM3iq+r32JQDrsFUV2XgDKTwixQd2AojysbNdHfflY01ekQbiUb5VNBR0kY4A5zeR60KazMar0zO+8m7NoRwO8MTYqih2atunXekUAcqVQCQlFymEElNCvXwbBHR5InoW8FkNUZjencXoGXlw37U1oGm9KMJzp+ajbbzpTKX1HjnQGkpKzAkNFl8GWpD3Zw7pw2lv31rsYpUwQi4ItGJ4PDV2n/a4Wzw5tk4zG3bRKMN/YEx/vganYCAIi1mLiCHSkRDYCftxrS8ZoLQI5NFOwCanFxLEp6sBlVgTCRzcRkTq6M8P7ypFeatlnbORDTL5crk9mb3IEsS4O30trvefBcZm
 BIyFydiK
 omI7T6Nmg8XmbN0QbjQfMtPDc7GYEMOeRdDEsdXsNYtL5eMmXQLTBk0EauShpqPas4T2pKdsKaSpBIJe6VIokFYULq88tBk+kug1aim29juMNt9NKNWyu1FPFGbOVsUOAwyIrcnxXaiWppBADObjcvgK8un2iPGrrObPlpzAASKIXgnrE9xctccKf7o3fNSyIOijxcm9zLNWIgG/WXXODkiAxNadseDQ97esI5E3jtAFmQfp2an+EMe5Pshv7EKO5gZVNqAZ6IXH5sIyOQ/Z6I5In+/nOkA7KAfCslN4/tS0/WXQ7HkeobLf7xedR2tuRf8oVIZGNvoRWNbODGAbmlzb4S3DntgPUP2CqOkgJAMbSB8nescnk4ytW7YrWOrUzOUaBKOCzdctY0mpcQpX6hHR9DzYAn/nG5mSrtZHG8Oii85pUhB0EN1g1mPT0wFdLkfKdhFTkdIfcrMSJY/D/49VWsaMCGgpwObQcYxCP1qG3OYJ+kClDYcoF6jgDl1dPhxJx3SrVbpZh1Esp5oXnr6uICoo+oUVgknS3l8/YwxRDVaH6FKGK50NiHiJqvBMEsOyolnA48cPx+LkQYW6t6DSgh+yCc7uIzAUMP9Hn/YexkOY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Creating a guest_memfd with GUEST_MEMFD_FLAG_PFN_MODE requires
GUEST_MEMFD_FLAG_USE_RESOURCE.

Skip testing GUEST_MEMFD_FLAG_PFN_MODE as an isolated flag in
test_guest_memfd_flags() because creating a guest_memfd with PFN_MODE
alone without USE_RESOURCE is rejected by KVM with EINVAL.

In test_resource_fd_invalid(), verify that attempting to create a
guest_memfd with GUEST_MEMFD_FLAG_PFN_MODE without
GUEST_MEMFD_FLAG_USE_RESOURCE fails with EINVAL.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/include/uapi/linux/kvm.h                 | 1 +
 tools/testing/selftests/kvm/guest_memfd_test.c | 8 +++++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
index 66c1f40b50c29..3ef7bc37a7070 100644
--- a/tools/include/uapi/linux/kvm.h
+++ b/tools/include/uapi/linux/kvm.h
@@ -1655,6 +1655,7 @@ struct kvm_memory_attributes {
 #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)
 #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)
 #define GUEST_MEMFD_FLAG_USE_RESOURCE	(1ULL << 2)
+#define GUEST_MEMFD_FLAG_PFN_MODE	(1ULL << 3)
 
 struct kvm_create_guest_memfd {
 	__u64 size;
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index cbc2f309664b2..fb9d50be2e3b6 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -407,7 +407,8 @@ static void test_guest_memfd_flags(struct kvm_vm *vm)
 	int fd;
 
 	for (flag = BIT(0); flag; flag <<= 1) {
-		if (flag == GUEST_MEMFD_FLAG_USE_RESOURCE)
+		if (flag == GUEST_MEMFD_FLAG_USE_RESOURCE ||
+		    flag == GUEST_MEMFD_FLAG_PFN_MODE)
 			continue;
 		fd = __vm_create_guest_memfd(vm, page_size, flag);
 		if (flag & valid_flags) {
@@ -432,6 +433,11 @@ static void test_resource_fd_invalid(struct kvm_vm *vm)
 	TEST_ASSERT(fd < 0, "guest_memfd with resource_fd but without flag should fail");
 	TEST_ASSERT_EQ(errno, EINVAL);
 
+	/* PFN_MODE without GUEST_MEMFD_FLAG_USE_RESOURCE fails */
+	fd = __vm_create_guest_memfd(vm, page_size, GUEST_MEMFD_FLAG_PFN_MODE);
+	TEST_ASSERT(fd < 0, "guest_memfd with PFN_MODE without USE_RESOURCE should fail");
+	TEST_ASSERT_EQ(errno, EINVAL);
+
 	/* Bad file descriptor with GUEST_MEMFD_FLAG_USE_RESOURCE fails */
 	fd = __vm_create_guest_memfd_resource(vm, page_size,
 					      GUEST_MEMFD_FLAG_USE_RESOURCE, -1);

-- 
2.56.0.455.g6c5a503b38-goog



