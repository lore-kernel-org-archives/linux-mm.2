Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C578B607F79D
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CTIuOzC7
Received: by kanga.kvack.org (Postfix)
	id 933A96B05C1; Fri,  6 Nov 2026 19:37:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 895DF6B05C2; Fri,  6 Nov 2026 19:37:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 783936B05C3; Fri,  6 Nov 2026 19:37:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4C2F66B05C1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:03 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D3CB5A027B
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:02 +0000 (UTC)
X-FDA: 85406458284.04.BCDBEF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C8E49140009
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:00 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CTIuOzC7;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011820;
	b=T9JgP9FPAWXHCpy2noo2Pn4tAoGngC95HRJB3Wcqm9lZVent4TC48jtwUNnNG1kG4AjsSx
	WTLnp6zcuaXBs/VUBY9rnSGQHSLEtg/ve137dGb+59f2eGIjO9CEhiYwj0Gw64Tydmf112
	OW6FjF/QkgrckBIYb3ltzawC8A5dIXA=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CTIuOzC7;
	spf=pass (imf09.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011820;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DHDksz66dHh+NtJTWgduIeFZwcvn0gYLuNtG7xctz0A=;
	b=XIS4qCwTD/YvG2bEsQm7wjHIRl7iCILBojfO4FFz5OO02jqKo1C3fLG+sR/NPrsjme9dcq
	B1f96YtBcecEhKRB10yPOXgGNBZnqGeh207Ii6YB+Vxc1P8QJE+EtBl421ZfvzOURpLn+s
	R1eG98XoCJg4E96pklYhDCUpUMtGsk0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5FB6860E17;
	Sat,  7 Nov 2026 00:37:00 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011820;
	b=VrE8rnsLnneuO/bg7C7WN9xssSN6Z41a8MHK6QtDbtznahHTUp+xY/6s/piUoA6iDuFS
	 UMP1HYDsKaksuvkl0LVw4J6E5p9tSuw2XXSYWbNONd9NsLkf7RcgklDHpY6i39WyjzX+P
	 GWkeiZEvqhR3i7kgsbL2EzhIEL9Eb4PKinRP7XW55MqIuZlwT9Mxzg9bWRwduOCV3wcON
	 I7CGBbSuirzlMiBnh+x+W62bHujKK157IJkez0pYFCRMaOw/8KqwT03Bq2JZEAOAaYrqb
	 z7+dnAv34QFGWWb/SgWhrrxMPTc3Lv9G/GSxIkdxjhWqb/P7OkWGNazIKsm7dIUOfOw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011820;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=DHDksz66dHh+NtJTWgduIeFZwcvn0gYLuNtG7xctz0A=;
	b=t+UKBIUBCUhyW+jCDAu64FNq+UL8IEbnTWgkBcHDmcA9EOaM0pyfVhdT2UBg6DCC/6PP
	 c4hWixr3Vs33Jkln8TWnQHrAvv//Q8aNXympyY9pTsJD1Iy/1NNrqBoN8kVlhUYCsN6ZY
	 7qA+ZMhDRZYPSh7powFM/2NkczLzizxZNB05AHEddoXVK0oliknm4NN374i0HdVruDcLB
	 rM2ULh0tLL4BBFJMVP1b5u+KzqCcJKUDD/kFMrTIlebQA+yM5eBVl6yTx0fe+3pgrPbIZ
	 vJOmNKuOV6eHaRN1wwFEmnxyFaC9ctP9z4Fhd5s46sCAHnf/z4/xpmB5KszwE/ZWVfw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 6539D1F008A6;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011820;
	bh=DHDksz66dHh+NtJTWgduIeFZwcvn0gYLuNtG7xctz0A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=CTIuOzC7SDVZweqYICC0sI8QCSlsYLBGCRg/OR391gwTSe0tNboBS9+LYmvpXPhpD
	 GPMPDUgscXyL89iR5dssXaGz3Jl+q4WR3oFK4vXeOFKkpXzO0zp7qgQAkjw3NcZr3E
	 HvejGNEfUYik9Il9ZhBGwRg+MXmBBF1rnwvVb3JNxXI6ZDbsgSJOiocqV5ibNln4MY
	 ozioR0AfrnVp3joK73/f9JoG9iSMhD0ghVgn06hzWZheEIUZgzicfmtfFLrwtlGYt/
	 WiSbJmq2fxXwbws1WzBx0KjzhA6PXVFh36evVeGO1y/Qy8bNxdaAptBmHhl1xFoSfs
	 fUrVb28INlxXw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id CDFBA47948;
	Sat,  7 Nov 2026 00:36:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:36:47 -0800
Subject: [PATCH RFC v3 13/88] KVM: selftests: Test guest_memfd with tmpfs
 resource pool
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-13-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=2627;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Qu55YepzOrkvcU6P+bNeN6dK+ZH4EE+CD9gCo1tRMPs=;
 b=1kdK6627i19vf9EPHPpEoGXhZEaTstbkmiKYLeec0b0X0HFFgMZ2ZRNvkGyRYgfjXfR/lS1e9
 BdAqrsrNbD/DUKfc1K2BQZoC/2dn8bnceObkJn7U9z8WcYqSyRW8UTs
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C8E49140009
X-Stat-Signature: hyc994jn4me1ahi985ns3j6ce17agska
X-Rspam-User: 
X-HE-Tag: 1794011820-544595
X-HE-Meta: U2FsdGVkX18iW6krIhIoqoue1U+0V76ZOSe3TnPaKxDqw125UPJAAjmBvtWm4ZpPzO8guvKY2MefnzFi9fr/q7+RX5d7vpW/FYWs1msitG2G+isg/DoPNsMwO3btYM2DMiRCqIP2hGAOG1E57I/fO0rEXTAxuWdpL0Y/Fyvvk2GXeHf3k15r473RmaGpThLkcidamkxsN3kXdSkoMshtNCzWO+piPHH25uvRCqLY0yBrz6+LyDYEDc8ulnSekgG591G3eVHsh/as644JEs6UteaXMO9OG4Eqtv0h1kk4QcmPl7NpkoKm1K5DR9MKDdkLY1kBxaax+HVuF4M6HaDJer4NxXWW/ElwCIkAUpT1zJr0D2Q0Do5ZJl0lzjzFrCZBe7DVCYml9NWDcivDj3o49S0wKDjbfr4pSg6cbtyBTUWLBF8JcIIo97KDst7yH/AB2QS3a+MoJwBYipT9gMxn1frWDueymllxtaY5gIXGA5Gik0u+d7UedQ6KXBtj3EMrnDheSLQE730EyEnRXJ/hvCwQvdvg+lxkQFiXX5ivcMlj51drLCEKitCqVmhX+wD+AH232WxFwmlAD923wmKM9pEBgTQWlaAuAARAJRKMy9rNwzVoqBoE+4Qr+v0U7QjNfHJTSNiQto4BiMrpZeVSUv3vmNHHifGPozcCRxFTq1f0cVeFGRKJWDK7Bqt4RanxKdvXcgsRVCCWMXTGx868dsU5e8tiMnqtA+lcxOxWK2hpJRg7Z5ngudLEdpCOOacMKaHJYNNYhfU8VtuLHYX1GE3OT8qhiyroS894nkzRZlOjZLsxTYXJ/J6jxBngOhiqpU0R1KHQ0nE+FTc+YuF7Uj8Jdv8Qhx68cD9lUAuqdl5SkzKmFzV/ZeJcDBqiaDT3zz7wucQ5He1C4YsrIpjfeEUF4r/yVG6LzHijE4xSgh0WgRaQH+tO8inOqoXl6WDO2i9KA7kBpsL5rpZykvM
 quZ4Kss+
 CoQh1FzBBOJCJZjc2cxhHjQcEj4gULHfXCWRiZOpIlGJzqQG1wy1VrYCyKgVRANKE/uUErHkPJ16rM3X7q96MTbDEYDULUzS8Vp8vsD7MshXmRQVMfWbumN72+qP6izHqF/Kt40vgPR8cyk+mUy8r/rKJAzAAli2O3nfWy4pGhA3Ihr6ou6iBNReTvN0+q3a6txGu23JIeHzashrdbl00/HPed0BEO/73l46BIfqJtPxSfkFN6AtRAQcXWFNRgEzyn9p2cBWe95VN4F3rx2nN/8iySPjhIZ/p+Ya/QMa6d2UWysO6XkbyZSoNH28OODVBuXeSiVPJSvGL/u9rt5u6v038CFiyVofHbe4T7jcNZ6vUpxK3rVb+8Ps37d21zBucfOhrzudWveirWwqq+mp7dgzUM/fmRmBpZSXXLLr7h3Tck2BsiHa5ZokwwplKl3g/ZTkYca3AI745goBh3BDBIm++0gW+XxFtAcTSHbXfjlpabXN81WNvDIe4q47TUOlXDqinH51ywroJ4DwvoUOo92UboJsMvTHB8CBq7VanwaetlstUZ+qPdNTmxTJ21G2sy5h6bVZgiX4pPAgII1wbXFzTXPU0XTQYo+OI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Add test coverage verifying that creating a guest_memfd backed by a
tmpfs resource pool directory succeeds across all guest_memfd subtests
and flag combinations, and reports the requested file size.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 35 ++++++++++++++++++++------
 1 file changed, 27 insertions(+), 8 deletions(-)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index bef1acead4a6d..2250c3e9a583f 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -562,12 +562,23 @@ static void test_resource_fd_tmpfs_huge(struct kvm_vm *vm)
 	close(pool_fd);
 }
 
-#define ____gmem_test(__test, __vm, __flags, __gmem_size, args...)	\
-do {									\
-	int fd = vm_create_guest_memfd(__vm, __gmem_size, __flags);	\
-									\
-	test_##__test(args);						\
-	close(fd);							\
+#define ____gmem_test(__test, __vm, __flags, __gmem_size, args...)		\
+do {										\
+	int pool_fd = -1;							\
+	int fd;									\
+										\
+	if ((__flags) & GUEST_MEMFD_FLAG_USE_RESOURCE) {			\
+		pool_fd = create_tmpfs_pool_fd("never", true, __gmem_size);	\
+		fd = vm_create_guest_memfd_resource(__vm, __gmem_size,		\
+						    __flags, pool_fd);		\
+	} else {								\
+		fd = vm_create_guest_memfd(__vm, __gmem_size, __flags);	\
+	}									\
+										\
+	test_##__test(args);							\
+	close(fd);								\
+	if (pool_fd >= 0)							\
+		close(pool_fd);							\
 } while (0)
 
 #define __gmem_test(__test, __vm, __flags, __gmem_size)			\
@@ -647,15 +658,23 @@ static void test_guest_memfd(unsigned long vm_type)
 	test_resource_fd_tmpfs_regular_file(vm);
 
 	__test_guest_memfd(vm, 0);
+	__test_guest_memfd(vm, GUEST_MEMFD_FLAG_USE_RESOURCE);
 
 	flags = vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS);
-	if (flags & GUEST_MEMFD_FLAG_MMAP)
+	if (flags & GUEST_MEMFD_FLAG_MMAP) {
 		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP);
+		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
+				       GUEST_MEMFD_FLAG_USE_RESOURCE);
+	}
 
 	/* MMAP should always be supported if INIT_SHARED is supported. */
-	if (flags & GUEST_MEMFD_FLAG_INIT_SHARED)
+	if (flags & GUEST_MEMFD_FLAG_INIT_SHARED) {
 		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
 				       GUEST_MEMFD_FLAG_INIT_SHARED);
+		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |
+				       GUEST_MEMFD_FLAG_INIT_SHARED |
+				       GUEST_MEMFD_FLAG_USE_RESOURCE);
+	}
 
 	kvm_vm_free(vm);
 }

-- 
2.56.0.455.g6c5a503b38-goog



