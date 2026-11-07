Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2923F6071841
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kJBRf9AL
Received: by kanga.kvack.org (Postfix)
	id 9348A6B05BC; Fri,  6 Nov 2026 19:37:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 847DB6B05B9; Fri,  6 Nov 2026 19:37:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 763C66B05BC; Fri,  6 Nov 2026 19:37:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 418106B05B8
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:01 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C0832A7B86
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:00 +0000 (UTC)
X-FDA: 85406458200.21.EA4C113
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id B14D180003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kJBRf9AL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf02.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011818;
	b=e4jrguhsC/hUeXPmYQvItH8m7/QHh3L2r3addajuPYergfcVpLSmosUobjX38vleE4cdLp
	USrebjP0b6unm9kuipppyK1rcjT6EG8dCKZlTdHC4vT0v/FYFgL2v7+3+t5nEs8QCPuFx9
	eFq+0zb1JVv20JODgiQHHq4NGQA7Z58=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011818;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VLo4wSV4BvGJmZfunAX25yUFq4cfEBViuYey2K0U8Pg=;
	b=cJ5smteK2orJFg4LG4sdW8GMPSMmM6nJWpBXH7QPVcHFNkZkA7AvCtYas/UGzs2+b0E/Qp
	L+JkThCKeBRaQNpAmsUtzZFNZdx0Zs681Xhv/AI5bTxalQskgCkQ/ASIYRbgyXIqo5N4Ih
	0WhaUNI4Vb5j9KgXmTJcGlsX15S2BTc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kJBRf9AL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf02.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1357044014;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011818;
	b=HVq8nLAsD8c6Nf4hzdEj8wmcIqJTIbURRZn8uJgzUVH6znvcDuyaElcbFrEu9k4/RA7k
	 sHrgqDvFoUbc4/LEU9H2t0n5uAGGaOy8uxotKG4z2zIlJXpljLV0rMOJXmBLDEnVmgzQG
	 tnI2JEudMvE3pri155l4dfLjnqxOj4htKgTivq8zyYcAJomfdhOB6JZuYqt3qzxOEOb4g
	 V4rgpAHScysvpKulRMhVNz0PsSH0rGd4a/AIJRPNc7KEgJDYqeQH5zqXObH3Mx7GPvIuq
	 julFuaXb9KQEXZKSO/TbDmueTII3c8baMnpyYvZJoWPntK2m1ox0WbTpfNzWECMs3Fw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011818;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=VLo4wSV4BvGJmZfunAX25yUFq4cfEBViuYey2K0U8Pg=;
	b=HQB8wnP8+HwlrXSuye36K0yHABPb9B8mU5HkVGSZfR6Xpl4dGY3Y6oSXPbY5V6m7oB1Z
	 9Z/10VQJMcWeefARYAKgocidNc7+dgFw81oV12itRZ414rEG9Q2b4RomE1CXwK12mL5kH
	 Yw5nVHtAPE5AMlTe8qJispC9jgdi0fNdjbOsJyg/OaPgBS1lD8m4HIy9DDH1pBPg/Dxrc
	 1fV5kEDwROk0r6EP5EY7V88H3JontFt1wI8gTf4YBq13lVpMdQv8bbRzjJAEEo3tCy+2b
	 HyJARzdFKxgk20v5iN59LLzpLvMgcu/RYTA2dzJgGiAHZJYKO1JZ3csT75GqHx9xyZg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 15ABC1F008A2;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011817;
	bh=VLo4wSV4BvGJmZfunAX25yUFq4cfEBViuYey2K0U8Pg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=kJBRf9AL53hjDYlFL1lzfJHZby/p/ZCRNulfOFyCTsU2RlDMQygTV1wE2LeRwy76U
	 Hl1eLhdF/XaMemq+Q5tvhud6CCHMEwMXrlX+VuTCWJ2WR5ltvP+RBT4lWYQ0y2cQA7
	 efgjqVmoTkwrsKrNaUQAhRsvH2d0AMBsj0JQKBQkoU3e3VuVrIuzHFCJMkzs4D8g6p
	 5qWAIu83DBIndcutZulGfr+V99HYdPp1e/5KIdzYoHaSOiRpUVr9qeO2BaToGzdLQW
	 2R+0ED1wulxE2GEBOlcjetWCwXIk6+fSIGMonK1yAtsKC6hdHfOPfW36xMpviBsWdD
	 CqBhEWAhjYJ2g==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id A38ED47940;
	Sat,  7 Nov 2026 00:36:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:36:45 -0800
Subject: [PATCH RFC v3 11/88] KVM: selftests: Test rejection of hugepage
 tmpfs mounts
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-11-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=1589;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=zaKeMs3KSPAZ8XLq60eW5ZyEksb0RLvUfV4AY70LgAc=;
 b=zeNTQ7kWnwbnhgfRFPhxMCsZcOxq/l4xAVbQXp/pXp5aSFeR9lcN41G2KfoYyBwXFCzAiW0mT
 Lt5/IsQXI+1CtSyrPUglpGjVqkZIx/+5YtoHzvnxaiCI5O/YoQ6/TYH
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B14D180003
X-Stat-Signature: cfazbyz3gaaynetzb1uh6d31ssfctniu
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1794011818-311589
X-HE-Meta: U2FsdGVkX19N7QrDZY9hSVJlyq9JmBbFYsq3ibWevqMCWGE3rSq+0sJczy57voiubldIgxilZ2DWlkGfGq83iJwa/GGagqdJSa5IAlNPV6E54p8a81on2/ErkT/MVghS9nrU6ONpuu6oJcsGbqwhKmROUVd66CKFuL8EwXZ7tWzNff4KMBg/zlqBJo/MPGe/yJm5GfhH121RwTrZwBE5bkSlon/wvVcw8gwmyeBG1BaFMRKdhwhBlDe2LtyKse9qkZ8IN9g2cJw6C6jrMDBLbGEu+RHSoNXYUydaV5tDwi+83n8X7TBBWBSKh5I4ld7GoVYwzpLHYtJBLlXVxiYTIc0hOXQyleO6Vp9pxqleRRz2ziPTTLS+D18PA0ijJZiC4OwDD1Sjp+vJNn1pzkHLW8vITKNAQG51UkoNIIG7YUB/lwmy50a0kxPnVQfUz0G6KAiqXzxPpQXp+GE1pSv1aBxtbk02a7bpiuN/369fqdiX4im0Psh2UI/X1Gql27V9YWEqhMlRmb4GGvVkKZBDj6A2B+eVmvomw/AbVlHWP8WGbZzVT3NcvNWZB8lxaVImBMy05OLGGYwIVrpRRQaH9LPdBVUYSMClaTtxs3BwFX5ew2HLqssDy50hS++tKhS8UZPJrE+naJS8jaR3usnEL63Wm5iayIoFycpScQSXVvYEPchb+UFy0siEeLxeU8F/JhY6bY1iAUVaskSMMPJarNQbr7/2Cz9nH+IEnlF5ZMy6MIxhyrWFPBiApUbRWXRx9U886m1Oeoj+qX2t9bxK42l+3KomqPPWwzEmnRkeWz/VK9cpWrNyVOJE9D79bT0STUGpxymm+crhyr/mZVIICvjh5k0sozWdX1O7oSihX/fcThB6wgHCAaySqSgX4ooP/u0N68QFlZkVn3taImyAEm3HkaU0MZP6PkYXjhiVXUSTGUykIf39X5zhqkMTp1mqoMPzzE+R84oarKhZxGi
 FaySbPoc
 FryyiUZ50n7z8GLQzEETZEm8ruxldapUv4fSN70kQXfNdgUocgajpWcP5Zw6pkrI8LxTRBoJzEvXOTwWwyjRj//eybYPVemBFBN3T1cjgvZLDI9WZxOBUs50mKZ6bnfoSNe3AwBZeA5CIE6NTZ2FE4g/9Un7Kmju0aPn9Q62uLdY4Ctgsy7SUEiksavwo2Eqd5q4R/auGnsvy8ff7eX6TFoUGZdkNTpGri/GqaOGHfXQEe2pxIX/ToghnuOjE0x4oDHk00nxnSqqinAGS7I6PJzTVwZ5oeUEp7Hy0OxIgrtkL7yERZVrCw692RyTTlCPoYqh0DVAsK+/saluYpBsujKZbzCApPoZo0Flefh7RXYSjV85wBqvraUlbeRieMMnngRUbNFvY+W+vOPvPF8135Wo8o6t9LDDolD3coE3n0HczVtsS4F+vCwZqzDz8tkRgKB0OBzF5+OTjiNRws6rqaCuugezeSNjt4f8fAlGBU9LqYDiEtUn6Z1mFq0Kw5wEBUQKguswynDJezAXXBCBzllAO5eKG6XqJ9Lp2vIQ8rL7QFQ26qo8/WX8M0lR63X/gJYjg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Ensure that guest_memfd creation fails with -EINVAL when passed a tmpfs
resource pool mount descriptor that has huge pages enabled, as required
by the tmpfs guest_memfd provider implementation.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 205f822e10c6c..541d8cdd0bbf7 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -547,6 +547,21 @@ static void test_resource_fd_tmpfs_swap(struct kvm_vm *vm)
 	close(pool_fd);
 }
 
+static void test_resource_fd_tmpfs_huge(struct kvm_vm *vm)
+{
+	int pool_fd, fd;
+
+	pool_fd = create_tmpfs_pool_fd("always", true, page_size);
+
+	fd = __vm_create_guest_memfd_resource(vm, page_size,
+					      GUEST_MEMFD_FLAG_USE_RESOURCE,
+					      pool_fd);
+	TEST_ASSERT(fd < 0, "guest_memfd with huge-enabled tmpfs should fail");
+	TEST_ASSERT_EQ(errno, EINVAL);
+
+	close(pool_fd);
+}
+
 #define ____gmem_test(__test, __vm, __flags, __gmem_size, args...)	\
 do {									\
 	int fd = vm_create_guest_memfd(__vm, __gmem_size, __flags);	\
@@ -609,6 +624,7 @@ static void test_guest_memfd(unsigned long vm_type)
 	test_resource_fd_unsupported_fs(vm);
 	test_resource_fd_memfd(vm);
 	test_resource_fd_tmpfs_swap(vm);
+	test_resource_fd_tmpfs_huge(vm);
 
 	__test_guest_memfd(vm, 0);
 

-- 
2.56.0.455.g6c5a503b38-goog



