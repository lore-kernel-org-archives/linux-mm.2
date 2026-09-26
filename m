Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E987C9832A
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 00:51:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D1F36B0092; Fri, 25 Sep 2026 20:50:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4004A6B0099; Fri, 25 Sep 2026 20:50:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18BA16B0092; Fri, 25 Sep 2026 20:50:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C3FA36B0099
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 20:50:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 43357C078C
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:55 +0000 (UTC)
X-FDA: 85254083670.22.142A475
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 67D6420008
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 00:50:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="U4E/LiUX";
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790383853;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8wey71XcpFWQmVAH+VLici8rnAI6Ip81nuR/QYqXOT8=;
	b=Tz9TPSvDBT5nRKjOQ9usicXtX7gW7BufCfKVvQOI4V9+6hWo/VKsq1xNWEcEknmAkA6ghE
	uPT3iedvKryK5Hc1utCovQwZ/03b8H8o4v2g0cbIAUqlRe9XuciOdDDWCbpSaeNeKhZLyA
	YfnxfRaow+7jD3nSjFZmtxjz3+jSk3w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790383853;
	b=IoCYRsUEdG9zQkIstxHIQmAuYMylTjGCtdNXhPhlLYhx1d3PAl1XXesCNOvhL2A37n12Bs
	0BEANZpPeE1VFWfZFHaXVPO85Sc92wr+fsNfncg0Hlj9EJh7iX7QHhawmRzovOF3B3weq8
	lWaKCecQA529zOu/EjNQ/I0dVxy21gE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="U4E/LiUX";
	spf=pass (imf03.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8EE3B60A66;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 576E8C32781;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790383852;
	bh=5/cQzYd8fqzTOg8mKWSvdV8HZjeJHOyZjj75J5Oa7hk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=U4E/LiUXSVubNsZ0cfpAqoFV4syPvEb+WrEFI89clDttYWAycljBoK4g4ANa2dC3E
	 muBC8h50A72YId3l81sRTycOfVRTyRYHD3NeCoQ67JlTRYx1fCqroHFDRiN+vhWBZG
	 J4T5qwS0/kGVsP5nPZZ9U5PkUEAV7l/j/2iSx0F/lA0W+b6k3xze3h6A0sa3BGC3DY
	 WgrDs31RBTxnrXmLsyvnloj6ehGKOj453q1I2llHzuBfzPr0UvHyPE7BfjISD8QV8H
	 fqVi0tzpHH714e96bYZDdhrMxbLtqriN/ikDL1eZ2nBhT9vykEuKr6sUDmCMtrlM42
	 FSknee/AgKEfA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43991C9832A;
	Sat, 26 Sep 2026 00:50:52 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 25 Sep 2026 17:51:02 -0700
Subject: [PATCH RFC 15/17] KVM: selftests: Test that shared tmpfs resource
 pool size limit is respected
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260925-gmem-tmpfs-backend-v1-15-d36159822d18@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790383850; l=1071;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=LYaWdpJzCkqMc0cwd4SOwmT9cG2Uo3iISC2Ej6mccuI=;
 b=v+92DC6DUz9lNIvijcxuMoxkfc5r4UqB10ZU3FgF47IUvXWKQgYCrNJ0XKHWwuTdC3dPvdnG6
 4hdrV4A7wTyCiqSPEQCx+DYbg1gp+gVq9h06KzPVPQuzQCx/iv6FIN1
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 67D6420008
X-Stat-Signature: pbfbkk5ophyzqi76e5biq35acc3yiky4
X-HE-Tag: 1790383853-268660
X-HE-Meta: U2FsdGVkX18+NdkAyhPazGU26mhkYJtWM+pmgjmjBdvRGFyWtBCmBtbVkEygO4ZhplwqJNpp0uZ7ssUeG+ihEQqNVmt3QELebT2gP6NxaOpMGLvwjn8Vti3tc7wTOkm7HRlwZFBM6MVUgCexbXPxlrUk1nbNzg1gZ4ZxjTXM25mjpv84yhj2lNn0ArGi5TmHE9dJBo6COrl7TKqNwTDkevlH7w94J+VqQGhzA13j2oovru0C/91cqJI5+azzkWV4bfJlvClscB+buq2QEL/Hh62MLDu0mtXhLw/GnhF60asPe7nlIaMbekwHjFQkut4nYnfZ1BkgkhZ7BXe2/4xAqXtrQKXOsWfdViZAiVhWaJSTr3ipd2YOVI1uMQtpLsgUUCZcG8pB1msanJHg13O4LYauILMl2gOm3ccuJQgRzuI/w1Lm+6iA4wzyD+GM/SrOjqwM9JFsWLPMr3fuZWAaYoLdfubdLKOviwDz2fUqt3DeC1ISnsFkc6YRNF9p6gjFfzrSRcB8zq5nZ7+b5th0BZAsrbD1WYUHLfU965uYX09ehDrBBKWFTAi7Zg+vaaebzIyNEqwbkHXA3f5QNb8gr4zxYgt8orV6bU+VTV53WjK3+UmEHG20L5sFWnUDmnxdMcD1xr+Lk/1+aUSU8+4oPwCmVoRlB1cie02nyTdK2yqRugBUwMGAnU8ryNzfYco2wS2f+XRT1eo2+B4cTs4GUHrIrJExXqjsM+UR5HrFWLSSlcR2VOCx5ZPs5LhYUMJ7mhCohok3/yUUOoRKtWXsLdVEIYGrDbqO1UKAEKaLyl5x5ThaI6RoBsy3EtofCEPMuKwLKNluJUWQ4QkbEm4b/M5IbyNhqWtljm51cp6zMj+2pvvTwFnY/j3Vi/Si/xKc9ponrTWymUvnqOodX3D80KrkEiud6iV8x9mkqiXugeZt/KdgKMo1xBPDe33qeiyUBvf2dlbhsWhIuqVDvmp
 H9ULe9Nn
 rkN/362eS3pyBgYgC6Yehlds4r51vLIhvCkmlcTX1YOhrTsNVUISOl6o0tva5nRwvb0+A4gL2rarPykjjQdHU3mLJc0AS7HSpAU82x0kirBtYT0/xOU+8qrENO1/qa9b80okT5g2bj/LsRGZkpQy7HzohvUonrkPGINvhzsa4BdUFOAwYH6VEvBp6jvfu1LfogSi+T5JxZbnOdCCdY2VOJxsfUMq0+uBZKWbeXz14jsly6uyQy6wSdSoLlxTemqzhTjYabNZrtpo01GMjSzpfAvvAvGbv4fby+Xew7Ben5e+SuomV/Gi1KviCgj9SxAi4q0xNe/X3eK2AbiNP+UMhwfdaJkv++PpbkITHOOpaDZNn3zqMn80eZK7G/hycMcLuFsZf3y9tP+2uDwkBq4xXrR+mOSiWDTBmoUokQnw8sKZkGVSljzVCYFAV2XLO0mYiDS5gbtH9CjIPW/w9Tmbo4aa1o6KyxnOANOGZql3+eilGqBw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Verify that allocating memory across guest_memfd instances sharing a
tmpfs resource pool fails with ENOSPC when the total allocation exceeds
the pool capacity.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 4610eeab39be6..345b41c912a18 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -587,6 +587,10 @@ static void test_resource_fd_tmpfs_shared_pool(struct kvm_vm *vm)
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
2.56.0.rc1.315.gc6ed9934b7-goog



