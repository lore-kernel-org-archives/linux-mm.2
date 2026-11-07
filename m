Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 366E7606EE9C
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nK2zrUjr
Received: by kanga.kvack.org (Postfix)
	id 38CB36B05C0; Fri,  6 Nov 2026 19:37:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 318BD6B05C1; Fri,  6 Nov 2026 19:37:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206646B05C2; Fri,  6 Nov 2026 19:37:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DB8656B05C0
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:02 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 82C764022A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:02 +0000 (UTC)
X-FDA: 85406458284.06.81D6EE3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5C5D9100003
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nK2zrUjr;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011820;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9OOyDFvCTuGXq5yquXw+y8Fp6MR4CefxX7U/6uhjSYI=;
	b=8AzkhT65B54FCaw7JYOM2pJkv0P4RgtDC9+DNsJrVw5PfYKuwpJUMZ9Jd4FWpo+IGVbNuC
	y2lTZu/AB82vEBx3CI8L0wPl9RseURbR+/LaprTvsfuTkObMSLc539r8ZTqVpdOdgBBoLA
	MhLt2c6T5df2ZZoWKkfZq35WbmuHxEY=
ARC-Authentication-Results: i=2;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nK2zrUjr;
	spf=pass (imf14.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011820;
	b=wM9Saz0n4KphyQTuIo5vLh0w/tm7UHtnFgQhSLas/a7Q9KzBG1z0XezepX6ecfyeqBVrRg
	O/a7iD9MXOs8tOSeLWufc4eAUV8z458s1fXUgBIDKrZYHW6sc0sAfIarkm6bPcUrNsYRUD
	gOmrj90ZjRKPJTYxOzgxhhFbuMtwJnI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ACB6943FDF;
	Sat,  7 Nov 2026 00:36:59 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011819;
	b=BpJWEE76/Bpu/OGOAyY2F6pZlqk+xue0SA+Ul5knW/B9Xs6rEYl5VBxjecNm2fin5hRs
	 Q6+QMYyQH7qoLXLUnvmOLBrkNSFp26+d5EyoIzvFcnOxfI5KOt587pu5KCYrcDBbuttt9
	 ffk4/C8xek2svET8dNdhBJ2fMB9sS4MZaDYHWYIccd7rad7AxnGEOU2Pf5TAPYHwIoag4
	 d/XJWW6exeBfUuPw/wqejhG9UaZO3vqgPZaoVgSbT2c42nw9MgNqR1i99KUg0Gi/y+vo7
	 AwyuL8qZuD9NLGTTyM98UnanBsNzXouYK8jGG9bjtg8AduBp+PZMS+kPYOszlBnwYgQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011819;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=9OOyDFvCTuGXq5yquXw+y8Fp6MR4CefxX7U/6uhjSYI=;
	b=CZiVDPaKEDDBS7LzsfZEX9gsmv3pObtfU6pFHGWKPB7tbQfH5PutVsxpwwytRfxNa7nr
	 0Wq2lxZCPgwlVTMuVZFIOerJoMNMm7A5QXJHKJwq/LXR5GPRkNPNbzam59xjT1kpdfLU4
	 hzjM391CAhaeEa0I0j/vRvNhqxYPRFBA6F23Vsz2elv7sKkMfdEo/j8oDccJTiukzD9Ke
	 Zr6IOtFHDeXKN9tvvcE/yo8Che3BAFiQOqRQ9qZAhbPh+xRxqY4Ru2Dxo45Qp0NrXPndL
	 AzHXm9UaVKMFVG5uLoBs2K6OWsYOF7vSpYqC97q1vNQBOKH9sCWepEEwwbeRqzWvzQw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1ACA61F008BC;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011819;
	bh=9OOyDFvCTuGXq5yquXw+y8Fp6MR4CefxX7U/6uhjSYI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=nK2zrUjrxFTd9qFtkgVe6xnQXiIeN2e213qn/jK6wAfkBPl0tF+phmakH6eacm0qd
	 E+B73CFdvaH/uULTM7yopDkZI8VNzWXOh+AU2JV6b0/fkoN0IjEeLyNHjIcinAxDNF
	 yJFyObjs6SJG16KMvJDknv8bqD/9oQE+jIGXBOc7zklvkDDhTBvqsp84SwmWtuEgxq
	 WCBRzEoCMxCo5rLaAHWhp2XIUqYOXgNvct6njBLuHW857PdovHtSS8h2NGsWF2hcAr
	 jj7rfhPKNuAfs7joPqpATeeLLTIlC8By2mEudkfRvkwCFPQmwOmwK4OER07W86iq5B
	 Xdmwi0XeZKm4A==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id B94AF47944;
	Sat,  7 Nov 2026 00:36:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:36:46 -0800
Subject: [PATCH RFC v3 12/88] KVM: selftests: Test rejection of regular
 file in tmpfs mount
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-12-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=1842;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=zYxsNZnCD+hu0G5QQ3lbC6j/2PC+WQYN9K55T6nzbPY=;
 b=ySV106WA3UxzgQMwS2cQCoA6sf5fFrB3K9KXQtlXVC9kRWRixPXJMjJH+mrpv7XnI7hdOfeRS
 R33krV9Y6j3DcoWX5+p00ZKWqh8uh8cBdypxdO3uBbxoZ7hkl/lhevi
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 74jbmhskcrh63yz8oza8me1eq1a693dq
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 5C5D9100003
X-HE-Tag: 1794011820-649362
X-HE-Meta: U2FsdGVkX1+qtCxy075huGnHQr3bK5tpnzubL6VZq0goMxCdsr5n1Nz3S3TXGK5DJxXP1qILuuVJlLQs2/2Cjs2iiI01JaqxB5plSp3Hx+1lOsXG5BUpRPPzM26mohkoAObml9G+bwZ079hf9WBc4vcfzu58ICptOpxnXfJ/arPGvsNXDfF7UUFQnspJ4lCsfFVkPs8nCOS1fdQALbfpayrNQPtdwcGYByC6bcRtX6qRB9Co5/nsmFHQ3pozWSq6MZulDqNsYAE/z/NijspP8W8F4DkHz8Bu9sly+oqZ37nHQZleBWf61ygq6wm9UfLai6HXjJiyF54kQIK3sZxs26IVmQoumP3ZWYzv96Oye/NWevBR+fYyMXmyNVE9WzkMld7u9a0oTQ//D5E2o3LAmeJjTqMexdih2H0Nb4JaLU0VLtYNgS1OxQQ8PAfyB0PCEip2xa2ch6rpCGpJUzR7fV6YvrrnxGL1NxQoiYEpurXTAGeop6Ese6j1A/mIM+m6xBAC6xbQzAiqy9YrWtv63hvTdcrawcv3WtV+HhynZ142Rtpmkx0lSPW+882rbr92vt9Rm3o88d5Ly7zoAQT2ThGX0cbYzgauo1ISyP5Ri3oKT5y80U1Y4UBlc5upzlBJuXmJCpOZ86OXdxudnTPEN/QbVc3nxO7Yxar01t7bnSyS+Zu+SzQMxYZKGbTH9Iiiz6/gOfaB+tH+rcXnrvDe+QjQPwF6vaOkjrNCiZNnaFwGatLZlNhWboyMYLd5W1YsMxo5y/JXsHL7E+D5yUw42pVFzjAGT/Ju1RnvWSvvUZR79PTCL23PTVKKex/NMUyv//xeNvg3f8WA/FdY7vxwCg+5EsYBQ71dw+VGrFIxFVRMn1PrXKyysktWrSFkvq1OOOlQIW4Dm4fpPpbzW7gIt7Okn4c04Rva5sZKJwUGgWzRtMjzBgaSe0SDUXh04dU+KX9i5my1AprtR84J/Ja
 gtXLucQf
 x0TnB0vLLHIEEMxZCWTIC8BhyHGYs1ImUR9il2CAQ24aA8/Oslg0FSbBF0rYo45ZFHl2xL8nFoMXManxw+ZUuw6olxWY2qqJTZIaVy46TcYwxbJLD1iz2x26fclAXzulzjT7G4DkxMfekSBuT4ppL2jXSHFEGW0NvCOXQJJxnAWfXgafMa1GGrnZUCbRkDh2wcLjgwmKtxTq8+npdSlmOEv2fU7AB7iCRA4HUiqFGp/kif7svkr6wPWpcHUFCdzu9Alol1dBUyzDVvWV+Rj36jh/UwUxbujsl7dzxKM1yWHhT6roUoUWihVUVTnWo17zhOH+tiPPbgSemdMDJUD5bozb5Y2DPdTogYlcKOXQWboH62dikJxoKYSg6P7gETKkjej69gVaiFRO5XZUUmz9cBDm+kOf3RDtaYvLU9szFSUozHfjRJzFZCq+1pHuiHSvXTWjV5/iucQfEU0ihoGtAMe0hMNzDlWqrz3UCtFnLcJ3fFQaocNEomMYGgHNjpquJTVH3lCSwfNU/87afFdwUdA6E860vQNZYW1EVvRdTcm8k+ptvQa6CRMRTUg==
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
2.56.0.455.g6c5a503b38-goog



