Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79ED0608D936
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DJioMraV
Received: by kanga.kvack.org (Postfix)
	id 1E3906B05D9; Fri,  6 Nov 2026 19:37:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11D756B05D5; Fri,  6 Nov 2026 19:37:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED8476B05D8; Fri,  6 Nov 2026 19:37:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE3EF6B05D5
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:12 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7880E1A027D
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:12 +0000 (UTC)
X-FDA: 85406458704.14.9D00C41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6AC1240002
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJioMraV;
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011830;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Yzu0WztVZO+I42F3GOx4nhxXNzyLzizDuJSmvZVdpqM=;
	b=iBOdzrknGSh+s7wO+Rw5kTmu1ufLWgse4vQWHmuUnbfkAqgIiI1o0bJQBG9jeZlUVgLyaf
	qlQgqHdnoKhkAO/Yvk4nQVY5TIciaVa1zswFSg/9WhmFzciueSJzNZBfcq3+4DcZ5trmWm
	SqIi9mshPQ0m9/Kprq63mJoQp4CtHYg=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011830;
	b=Wr53BnyNnLzvKR1uL2+kWbuyyuKKQY3LLApB1ndm22I23E4da9RjzLwMxqMMCR2/H2osJH
	Yxk2epTD+UoXrykeRrjtSIM5XiOar4MtSbC4FHUWxOj+DI69SIybfMxYMgpVScQH8iZERB
	ql/Q8VdIkubYmnLmK3VdGQdX2LUlnxw=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJioMraV;
	spf=pass (imf11.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 14EDE43634;
	Sat,  7 Nov 2026 00:37:10 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011830;
	b=rCRlGsA1YpmmA1FRBvN4SooZ1a6zVr4937AWlbQ11i8e7hQLthx7cnT/m0TY3+rjisBZ
	 HZ5dzuA/amsoq52lEI5Vi94wyCZYuIvc2Z39Q/NC51bj61+lRVpzZs5rqoROCqilQPBpH
	 7VsabId1hBFt4ce6eGcTkuYtCunZn3JSdDQ37lcUZLDuxeT7EBzeCRgOOAxy5mnYVILBq
	 27//4/guiRRi8ZlIJZlcuJMgXXcAV+Q/vn4vf9MvR8sKl/sASkpscgyhpYktJ/hnxLAyW
	 WwNRmKj2/qqeorvh9FZ3LpuICdNOaBU32grC55r0L9v/+LsV1HjV8CeKg1qrML6Kt9g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011830;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Yzu0WztVZO+I42F3GOx4nhxXNzyLzizDuJSmvZVdpqM=;
	b=OPkiYx6t+0S1JM3ggmfFju5qqxB8FJGNVVfAMjjQ4D6bUDzkcSPq86p3ifnBnsCM1CBY
	 85so+dPDwfoEjfwGi7dQ+rLHUSiGjjuTtmHgg8srMH5JRVH/RsE6p2HZB5shvipOLTPUN
	 0Z4RFV1uCb55tA7Ad3P4/Y8yhggDiYlL3kO2U7PBbUYm/9fnpWDgjd81qFMYg2U1QKKiG
	 QQDkfL8CMWLVWOHnufQ5RrRFhBLhnTBA7XjfM2qsNKx8ZwzF5veN1OEbSUf+FvrXAKxPb
	 AvXnnnut5LReP8e5wUpRjt6h0hOjKQiyE6JdM7NPhdwJa9jn47IZxQ0o9klPyh2Gsqw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7FA7D1F00900;
	Sat,  7 Nov 2026 00:36:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011829;
	bh=Yzu0WztVZO+I42F3GOx4nhxXNzyLzizDuJSmvZVdpqM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=DJioMraVOa3WcBIC7iAEv8B5su40kFbIpqHrqJB8T13ICiQ7PCuRGUETY+3hu/IT3
	 GcgEkn/e8EwkD8tXSTSHTWJty7928OwC/dGAmdBxC8OYvWO4Pck2W4BYzv1Y0wLWED
	 dt8eRqgdAfc4rtyfQfdtAEY4bNDa+qCUxdwsf7qaP//wKVviffqmzoOGtNECRIdW7R
	 ZMcqo8o9AFruMoZE5T1n/I0pzyyfwKk3XjUTZULvSz+sAQzxVaFSgEXcclpjWBL1Aj
	 hItMBJL9iHQ4GmfKcUKeO2qK59w/r7tlqUAz0Q0pinsEHU6xzspLs/U8SFXdz+YLzx
	 iX2NltxOIvcpg==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 14ADB4798E;
	Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:37:05 -0800
Subject: [PATCH RFC v3 31/88] KVM: guest_memfd: Set VM_PFNMAP on VMA in PFN
 mode
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-31-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=1105;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=bgDskVh5mQ4qf8kZnnMpcc5wqYuHuhwtZVlrwhGpftw=;
 b=bJSGIHIjI8Dun3pnzzwKMZBEVyIeNKBR6I98tBOsF6T1Tze7EzogHxlnUyHvxeFc6sylwP9tC
 RStTsmb8zUGD1ktql3UfDaKz0Idd1TUrp9o5uPxLSI7y9s4cXsdLKOq
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: bzezo56wsapa8b583smk6hmjbbo1cker
X-Rspamd-Queue-Id: 6AC1240002
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794011830-718412
X-HE-Meta: U2FsdGVkX1+1Rx+DQoZQMf3/irYjPqrJPQS4WfULoQNIK36147uDl8Kw4BO/+KWlcKn1OCkm7dj3suGRqChXIb3Guo12PuSEADJ/8RAqpKz/uH6mIJUtD42krTzvOIcQWNCgFyujeAbC9RmnYDJS8W9lp7G/rGJGRcEl2iPKQyyGpUluS9wQLcAIHEa4eCBKrQYwm7jBnMglsFB4/Ad7gAp7wQ1nCuljB4X0Gsgu+a79kn/zottdHZv9+E98Dt5dyl3HceOTIj8wBYZYzqmaBgPNGh3ebe8jx1K/A7mQtvjHMh3RXeChzX/bp8quLVlq3UQx+4i3HXunNpyB1rT9n4xUGbfUcGvYrlsicKEJHu1oSjE84/w9kicZtbj8rw3FfToUCyyxeXmbpIwZ2XRCHl364FJaxGbTeKqHyP/9jxUWz4jvpn9SRil7p4EdfLMkQisgFIJQqpyNZgw5GqZrXKJfLXUS+6jTq1CfGqXMJivo4mQgfFLt/wKyBIormxisoIFq9FJAc7kWdEoxj/233wKLnkiRVLaeOhoNRmc3mt185b6U8m9DGzhFm7fdeDFfG///9G86nInilmEl4Hc1WiHNq6VQXzg9zFf2T9I3HpXVI4xWuW6VYx49yen8iwaMFSpwOskp7wPYI0nR3Ilzj6LipAXh/2wknkFte/q3fSDHTHfwOPmShYCw268DHWOim2mzTVNY+LkUbN14Q4qA3hBYRzlJgDgrjV6yY7xaOqqIXb9pvDs+nWDaHzWMrZE9aSwcZz3UVUFI92y6Jj5jQsS8lQ99Q6FZ3S17S8b7qGSiCBesKQLUeLut+TijRi9p23hKJc+IpmvAyJIBSJvdF1OnXMA9eFLUGE+rp+s8CNqFLJ98Rp+wM8WPcCW+4lXZT5xCUMoFFy3FFLkwm2mHzcfAFMwRyPv+uh4D1JhGxWocowWs4ukcISo4pHdKMNMr0nqngeI5TwKw1ipUsd9
 6RvEjt0Y
 AAiW3J2A4mE334iRjmA2NS4jV00N0p56PHJQusttIRfjkE7RrTBwyxmIYElZgDxdlYqRQePePofQ3IeKlsiS8GTc/eEMxLaNESsHx0R++/vEjdf7nzpkbm5cuUA26ZA8lrMe0xCFfZdQEKB9inxNazCY78nLE2izZaDIhLdDxT48XIvghki1wERyptQbLDmRyiu750Al+6oG9bh0PrD/nCzuvvTBR+0g1e97jI4Xg+KmIllaN+CTGdxqbg1CvwkniRWrCD3pziNgEZKJkZbFi7+mufCgdOUYklFvfivLC3H4vMwDius/MzDg0WS/y8M90PYXaENKve+zkTFNoMkW7ItqBavumM3yMrL1tqVbXhk6/NPOrXkcPNFSbY/AFqewKtuPoSKeYVD82crA4gpBGXSpUarDkMi6MxfHZrNkz5pFCQvz7YPIQivwI8Fk5F9L5TuqHVexBFfdJ3kuP6Mk1rzfL6LEbPfRS2Fl1PuPYXwm/Kqi9ZyY876q1/1ZkU7BKVZs4VNy5vNFsC5P+GfC2EqmTwOPT1NNJSwCLiZeOdWS52WceJ+O8bZbv6NQUIlqvvn6wWqOalYDr7y03ZTQ/KpY+BMGh5K8w9Y3nlGK275WQsLE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

In PFN mode, guest_memfd memory is backed by raw PFNs rather than
page-cache folios.

Mark the VMA with VM_PFNMAP when setting up the VMA in PFN mode so that
the core memory management subsystem recognizes the mapping as PFN-backed.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 virt/kvm/guest_memfd.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 180418c65a1ae..183e15775523f 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -652,6 +652,8 @@ static const struct vm_operations_struct kvm_gmem_vm_ops = {
 
 static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	struct gmem_inode *gi = GMEM_I(file_inode(file));
+
 	if (!kvm_gmem_supports_mmap(file_inode(file)))
 		return -ENODEV;
 
@@ -660,6 +662,9 @@ static int kvm_gmem_mmap(struct file *file, struct vm_area_struct *vma)
 		return -EINVAL;
 	}
 
+	if (kvm_gmem_is_pfn_mode(gi))
+		vm_flags_set(vma, VM_PFNMAP);
+
 	vma->vm_ops = &kvm_gmem_vm_ops;
 
 	return 0;

-- 
2.56.0.455.g6c5a503b38-goog



