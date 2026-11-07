Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 054E36075A67
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jXiLshyn
Received: by kanga.kvack.org (Postfix)
	id D75D86B05B9; Fri,  6 Nov 2026 19:37:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C18966B05BE; Fri,  6 Nov 2026 19:37:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1BE76B05BD; Fri,  6 Nov 2026 19:37:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6B1296B05BB
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:37:01 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id ECD908026A
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:37:00 +0000 (UTC)
X-FDA: 85406458200.25.2FE5997
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id D6C88140004
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jXiLshyn;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011819;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=akPF8Rqd0NP4tJKzjNxFnOYnLuQsFWTXNmC9tcZ5B90=;
	b=N5/3QClNv+V0aQNBSmGJzBdrY/T0DbWlHw+8J6SRzQjVHemUP4M7xCvAA1X4anjBEfTAG/
	KJXY4GHPkxAPdrRRtcer2EF7p7Ztgw8oQdCAiciyzqn/Py9VgaKR2ZitIFVqfBxwLr4/nC
	+V+i6mrxg5F1ukFBuX65ASEh61DMFIQ=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011819;
	b=nvj7kUJFxHG30YaEEUFKDZEAzklMe7AicFXfaMKkhSQXdcLYFvDHOau8VELiu913nDFGT6
	vLi/88pzWC4EV9sAQfz17Leqzo5lCmd0RIMsGhTI/Sw3RQyMGjCFVWpCyUqCk0wvGJXDlZ
	mX/lWpjFlzPQay0VR4aeZVjkyIx5zJ0=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jXiLshyn;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 700B460E18;
	Sat,  7 Nov 2026 00:36:58 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011818;
	b=rCpI9X9dDe2locV8qN0VXeon/7oeKXhMx/OUMnAtjcKT8h9V5bdoS7n6iEIlumfjd0T4
	 fH4S5EzGKgQSxWVE/uXjPV5u58WltW3l9Stde+MYK29kSjsngWsKpipt6SqhyK400UmUy
	 iO2t6lrR1cux1migopo3thNMy4JAcl3B+ifQQw1SLkD56B4i8yMgFXjp3VdoVEHMndK0d
	 CgYTPuwrMljn4f57rS1BqNTvHeMX+xeLXV/X0ttPS6iB842ugC2pnzuH9eGKFFd4NsC7+
	 CbmAsGHgIDkE90o2ueFFF4L2ldcmBreFAJw3vuLam1ane17fu0cYRLWvBYD13MvivkQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011818;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=akPF8Rqd0NP4tJKzjNxFnOYnLuQsFWTXNmC9tcZ5B90=;
	b=ed4/aEHoGaKMOWOTgWQxbcXCqyCSvtt6bAzwRYKLSDGnlprBR2OJvMmXNJdkya62eHQh
	 oA36+UHDAl2VXcSovxiLy9Fp+TzwY0EQVN6cHslPmtOlj9bzYod1pLtVeqy34krfbIoLq
	 MrJ87xWppo2L8DREES+YA6wnEOyxGVG1+QUc3gaznioBFV3MBaTjcUN2qNtNyXKUrbGi4
	 X2sfjI2GYzKM1llrSUzj7wKJ+a7btjDLiYfesv+GsRSC6G3dLAOTG0YAVgTAsPqDNBBuX
	 LUNmke1s9UwF447CmrNJsCMXn57g+sXeBpuBDvxdYcdHYDajC/6BJK7pMjjLa2dglKA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 681061F008BF;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011818;
	bh=akPF8Rqd0NP4tJKzjNxFnOYnLuQsFWTXNmC9tcZ5B90=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=jXiLshynmjH+vfW3rFTL5wxzqLabHmxKCirdsmFJKIby2exN3faZ5OoCT63y0Kfwc
	 PUBqcQpd2V5iS56LtVBCDvZejt2IHL9IlUQwn7rkn2oLkKs1Zpd4o7mPyQjl+x/lsE
	 Fr/WCc/NFuybWWLBAiXPr2tJcwAVkZJKdUcU7CDC+WC0y1hFxOPt279MZPrbmm3KL3
	 FKT5GwODej81IUfmsaER91lcRZLPvrOVMZ+IYnSwNS2V5O6uzIUnQ0rwN5IRbn8PnB
	 BGiH4Vck2mtdzuy8fx/g8NOSrJPlx+sxBOvF2kNjf5OP8gtznznZ6Lljz5HBUyZGtY
	 jrvR1ZrZXbH+Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id E31A14794C;
	Sat,  7 Nov 2026 00:36:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:36:48 -0800
Subject: [PATCH RFC v3 14/88] KVM: selftests: Test guest_memfd resource
 pool sharing across instances
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-14-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=2262;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=Gtws3yU3EcBh1drSj1dqMboJlKnfe65yAU7eXv1PUw8=;
 b=OVfxZMrlK188RJKT14VUnpM99+TTasCQygc3Z7C8u4dEwGMREbDFiW6Wd7Pfo/6tGxJRdJRWf
 1hFExBp/dwhCPnzWJJ1ZBLuQ8kK3ekznkfaIsHb7pMrhA/xJLqcJ5Dl
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8w9h68436ig4zpq3h4b8imphbz6my7sj
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D6C88140004
X-HE-Tag: 1794011818-789937
X-HE-Meta: U2FsdGVkX1/Xl8OiMPDvacdOXYjNoVLmAG9y7db+j7DkWhWAgsUT5g3eaYLCTV6fXHWSU+iDly0qnlqE1FJ3pncSC6ljETsQCJ6Pt7AWAOL2wHseWmLVpKvTAByZeFvsV9lROM90Ys6DeQmbhqExpaO0SPa5i89mmR6brnuR/olqeXl1yfG6mhE5ExFh89fiFYSuaJRf9Hz/Mn4rJuFvccSe3gTppvXsUsjeMlVBsGXW9NEJLPQpBEaWaA8gU3pzY0sMMclbwLMnfktRs3gJ3OGPM2uTZaoPE1l64ysNgEpJ3FvJIhcOPKAUrUpnj7ka+VT6YTFfYRs4iOjsEnj5OhO9YW0GvR79OMZyu4ZIlusjE/54q6rmkpoPKWuNGlduQ+lrsYUErrbhvKChlsCdk1vPOtryDz7bbIf0H6bHWuKWi0wPb9yJ1xrhHHNO+N5DC909ogRQkv27eM4qR0OYO6TlkMtInWk018jOsYr1FV79zhWJ62N8iRIjqU0Rj1m64oSLqjJFNVPcNPw+A1jFkYGSv54aabsv0wt9pWdsuhpH4goP0LomkINX0NIs9LluEshGC3ROQpZYPW8NyaRudw6RH0znAQpSIdfw9gcm3vshhi1okcUworRPvEWpT1do0D9Q4qhFDgvsL5u5RahAZE/34lobOsf7+XtmQLbzQJ1s+DZbuGIwoW2dbdm0mfWlTvcnSZeO4DBYJ3+XaFl1x1qMJ2+GwES+nRMkq7eAKWu6X2WfSYUyYBq90diXqv2cmUOTzMaROTGV31iCGBLWsoadhem8RzM3UyrYUJDYcNPJv1OOeFQfcoPNOwKAMtbgT44UoyXWsKFhtBp6Ludeaqa/YVY74+WLjOS3ZcjMD9aIWlcejswoaGXCD2gggj7R+ZUW0uAoUC900oeQrCz+WsmGxOGTK7e/2n+5P7bpikhsPBJC/g2JaJhzJ8Np5NMfH6QzokoQfiY+Fi4JF71
 K7Eg09ek
 m2/WlE7eeMXupDyPkpAmBVnl2G1H16qoy8Sl5lKa6Nkzpq+Aw5MjMjXFRSXRNifMGcUZLL6H3ROf/qXVDSoqTHsWYI9MuPWfFFSp6pB1/OocK6xwAjkQ7Hgf4vvaLGVF5zmYE81Mpt0cyLtWE9SXbantQFuDpWWFKBKHX2va57u3R/u+4iK8M67uR+0HdJH2pwsRKAtWxFfs84ZIXZVcalyXQ1DDcBMSLLgsexlrm7tyCk/cNV6lK8xAUeryyM3oo3vZx5I6BKtsm0WdIarz34bktUPMZHPM+dyMm/CrpI+1Rnb4ILbGVfTUCnyC0WNHpqPbxTbOYezjF1XxM3uSNWmddfzMOugPhWNaI/e25g88iJGAWoV4JwLhVUZuXupRZMMCRB5lKDBBJXk6b7Xiep33lyyGk1b85qNgWzPI3KhS7dLFVd2hcPvFm4DaEhecXlcvj44hs1n7Yg4q5l7tKXxaXteiX0fF1CAAczr34C/fyzGidSw3m1n/BraA6ANyoo5YpZDiMT+s7/Radkks+4al0e5VbB7/wBulJey9ZZvk//Z7NYEZKVUUg1LFA21byn38skQD7DWxUKfPTzYJPrYcRErix/gr7GmOb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ackerley Tng <ackerleytng@google.com>

Test that multiple guest_memfd instances can be created backed by the
same tmpfs resource pool descriptor, that each file descriptor reflects
its requested size, and that they have distinct inodes.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 tools/testing/selftests/kvm/guest_memfd_test.c | 34 ++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing/selftests/kvm/guest_memfd_test.c
index 2250c3e9a583f..310a45b6656aa 100644
--- a/tools/testing/selftests/kvm/guest_memfd_test.c
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c
@@ -562,6 +562,39 @@ static void test_resource_fd_tmpfs_huge(struct kvm_vm *vm)
 	close(pool_fd);
 }
 
+static void test_resource_fd_tmpfs_shared_pool(struct kvm_vm *vm)
+{
+	int pool_fd, fd1, fd2;
+	struct stat st1, st2;
+
+	pool_fd = create_tmpfs_pool_fd("never", true, page_size * 2);
+
+	fd1 = vm_create_guest_memfd_resource(vm, page_size,
+					     GUEST_MEMFD_FLAG_USE_RESOURCE,
+					     pool_fd);
+
+	fd2 = vm_create_guest_memfd_resource(vm, page_size * 2,
+					     GUEST_MEMFD_FLAG_USE_RESOURCE,
+					     pool_fd);
+
+	TEST_ASSERT(!fstat(fd1, &st1), "fstat on fd1 should succeed");
+	TEST_ASSERT(st1.st_size == page_size,
+		    "fd1 st_size (%lu) should match requested size (%lu)",
+		    st1.st_size, page_size);
+
+	TEST_ASSERT(!fstat(fd2, &st2), "fstat on fd2 should succeed");
+	TEST_ASSERT(st2.st_size == page_size * 2,
+		    "fd2 st_size (%lu) should match requested size (%lu)",
+		    st2.st_size, page_size * 2);
+
+	TEST_ASSERT(st1.st_ino != st2.st_ino,
+		    "different guest_memfd instances should have distinct inodes");
+
+	close(fd2);
+	close(fd1);
+	close(pool_fd);
+}
+
 #define ____gmem_test(__test, __vm, __flags, __gmem_size, args...)		\
 do {										\
 	int pool_fd = -1;							\
@@ -656,6 +689,7 @@ static void test_guest_memfd(unsigned long vm_type)
 	test_resource_fd_tmpfs_swap(vm);
 	test_resource_fd_tmpfs_huge(vm);
 	test_resource_fd_tmpfs_regular_file(vm);
+	test_resource_fd_tmpfs_shared_pool(vm);
 
 	__test_guest_memfd(vm, 0);
 	__test_guest_memfd(vm, GUEST_MEMFD_FLAG_USE_RESOURCE);

-- 
2.56.0.455.g6c5a503b38-goog



