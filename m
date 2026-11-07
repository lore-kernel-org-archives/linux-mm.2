Received: from kanga.kvack.org (unknown [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69E5D606B766
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 00:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E51g07kz
Received: by kanga.kvack.org (Postfix)
	id C8E036B05B3; Fri,  6 Nov 2026 19:36:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C65C06B05B4; Fri,  6 Nov 2026 19:36:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7C036B05B5; Fri,  6 Nov 2026 19:36:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7E5F06B05B3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 19:36:59 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 168D5A7A23
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:36:59 +0000 (UTC)
X-FDA: 85406458158.17.1B8BA36
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id E204320009
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E51g07kz;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794011817;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gi8XuOW2wUclJkl6EeeCVIIm/en8gL+JZvwDfeVWmPQ=;
	b=SnAbCb0O2V0/6miujKr8Hwjp3U1x62JO1UhoZ6LMKPr3hnTk5D5B3dFu2WKbmVIVttDl+Q
	gQ3iNM2J+9je3YJP/mNX/D7L5Y9/AKA7C/3fofFdDjOcKCZQF0buYcC9KYo9eUZQa27VkT
	xiZyLhiU3GijlC2XqQ4gta1Mr34iP00=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794011817;
	b=X/5igpTavABnQdhPuO2deSmOxxrH0dIxucOLuGxuCpHKsQ43sbI+T3bQ82YJC+DVuf8mPP
	ffBcT4Hsktb/FryAiPflfYXYGbdE+bsHWrCchPGvlU2QDLUZZEADOB19x1ate23gbAjLHy
	dNimI7EhQwwQPr+YrftGWbMv7SFrieQ=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E51g07kz;
	spf=pass (imf31.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1D51143FB6;
	Sat,  7 Nov 2026 00:36:56 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1794011816;
	b=uC+N78YAWJ2VbMp/jBogGI7zF6vLHH7ZNBexkTBDSGyNSLXB4qaOU4NVF7jnjJIbwhvg
	 DbmcmYHBOm5PRHqS12o8dpnctUYK/r41Zsbq7LUMlXTdRzZXAvNcHP9PQ3dkQ7rBdSm+O
	 d7jzmJSo2dhh+IEX73Nvh92B16oYjKwpKqmoynV4xGPVCluYdgn5/98qDW5WjOPT73xFd
	 zgevrNZI1N078bKJaK0Zcbo2/pxuS+kA2J2HSKzcSjYBBo3E8aMytni1NF0y2FmKboO7v
	 XoC3xo03s+SEqfpe7dGIaJMW32ti8NF+wJzHUdNc9brH2Nk5sDbhyv8szQ4rMGmH6pQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1794011816;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Gi8XuOW2wUclJkl6EeeCVIIm/en8gL+JZvwDfeVWmPQ=;
	b=1UWiIFFZaSHmpldhS26+yzIrw4hUmFhxO7Dl7Z0TSxL/Uz3tKbpMwLzkL9yBuj8LxLdj
	 SV/Z7k+KizYq9PbTg/G4x7XZT3Js9UosCRfgtMc+CEtj07dbGOi0HI4gGYbbDgSc7cV+y
	 0TzgfRxtyYgNLD1zMGJGPp7xyGQbaXspNhyj6aZdP+i3I+8T1pOfTyxFBmSENltOHhhaK
	 uYFLaB9zMTDqXCMMeDvEVDhlX3G6ItULwOnSM4jqOPLerO7hFHl/RSJXHOa9cFokozee5
	 bdvA0iHeKKKflRKt7xOMrDQOzn/zrqdbh0x82YEfqejRDD2DQVFm9jnTiGPU9mgyShA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4267C1F0089F;
	Sat,  7 Nov 2026 00:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794011816;
	bh=Gi8XuOW2wUclJkl6EeeCVIIm/en8gL+JZvwDfeVWmPQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=E51g07kz9YvSZucHRjfCOVwSLbe8N1hBf6XGtUmqX6TGGe7PWVnoEAqcisjJuIbYJ
	 vRyvm5Jg0oGJYACor1ahI+Q/n2DDpqMGpgV4l2FDH7ciNC8M3r30Lo3uSd4gumuwyH
	 WPDeks8m118XFNrNe+OMQnrFbO4H9dGoiWw9LcSXpxfDKFwCGcFpHboCuAf2d4vpRS
	 ksR0YUcIE+xkxdDT7o7frhyE7LFeNIAXBTMNPRjBdLiE0+Fr5BdrJx7ydUFzdxxOw4
	 OPhqaDNoB+meYLrmY9+V+VrM0Usg2lpkJWYoookt5O4SI1iNaFWDJ/lnRpn6aRZ4Ud
	 Oybhxl5ulUI0Q==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 530DD47930;
	Sat,  7 Nov 2026 00:36:53 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Fri, 06 Nov 2026 16:36:41 -0800
Subject: [PATCH RFC v3 07/88] KVM: selftests: Test negative validation of
 resource_fd argument
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261106-gmem-alternative-providers-v3-7-8484dde66a7e@google.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794011809; l=2102;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=dKdQoJ+6E8rrtajy5+HMr37wBSZwSe5sC1LJJuGdkHs=;
 b=LxXhMdKPAOtjHYRtDSEnmO6i0SyBR+8ksuLusE+lUgxFRHpPSn5ekpfaFhOJgoQa3Kb6jOzAg
 RiLZHyldizYAfAkkTkilm4Hka1ub4SCVyl4AjywJN2UjejjfdHGfboW
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E204320009
X-Spam-Status: No, score=-18.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,RDNS_NONE,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: efykqzb6cnfafo4aycjsj9h9kwzjxrsq
X-Rspam-User: 
X-HE-Tag: 1794011816-338136
X-HE-Meta: U2FsdGVkX1/Rx0w68adhw57wKR5RM8CFtvMq1gaMC8euaPigWe0HRNDs6QeY5y0AH7zxPLX72daHfuXFdYkAZtP2jriQWSbpye1TjsDeAxokrO0LglqtztyEOAdyU8nVfBBNGVbfHdeX9FqbEilRH+khSbE77OOB/jMRUgWQ8xQUGyMWNqZbHneE4Jiw8OC/9SExKB94h7sCV0KJzC8jafZGofuefXWcAM4ZfBSe1SOTB5j9nafpLjZU4PbONhiDayLxovBKQY0z35iSQMy93aYbNbLshAWaDSdezb2IDOwbFsTjy6kDdxeSoxYlPeoEjuQZg0XlvxRUYlQCojc6x/M4UYYQphwtOXR5/dxcztxaGykrlhB8vPy+hmJfixYTuCG7MkyOjtt8z37G3Ms6PV5kb7WAYSpl/MNgfwUod5qCf+nEcJLZwia06u/IqtTZAnJ3J2NBVyS2zuG4dRL2WjkSvX/UfTu1vXb0eoBoY38WyYVMLqyl2r/6t711ZvO9w5YiZ87JW9oE5+TVPVXlRjES+HTk95nzy5/ZighJ6j3UEQk/EpDXmNq0GlI3BSypXaaOiUowc95LptZRMJeRlySru16dFbh63Oi+6ccs1yCsGHdi8vEEYh7aA1eDxBjZxA7HXDl41yvGtyoPeCFdwjbeqqE/1qyROTbdAW+EvrauD74mxREpHq9RunMw2RC9LqSDuqtSnICwPh0ik5RHXD3QtoUO93EyJJhp56wa5PbAMVmxtSu9H3sa9UpLUF0M/oS9WcxkrsEL1p5ekv3xExuFfTdHcRSV9HNkXt9NKITNGuhCONkPZHvJSik5i1UPGEFtK70TMEzDUzptNZaP2Qqwgqd/bukLCniBr9IH3oYIPSXHZxtmmSNKaGxGKaZPWoDdtD6a0cFlA26Ir6NN7EvuIexXu6cQtYn4qxSPlPDo6qEu1Zolx9/a7uwoBr/4Tva1SAmFAAvG+1jc+2Y
 4jxluxOj
 GNivWMn+fsH/1u2Fq70w23VCqySpugKq4cc0o9WYCPzi+RIDXeQzLoULrmsqVoz8Xau+Q5y571+uPfWg0hwhcxZSs6j2zX6D2VDiLmRC/zRnzxQRsmyMOkiE9yaScHohvcATBb2myQ/wuOoAmIf+XBfCfH3jEA89yR/lIYHyJTx4JUlFEVlKwuslWBBwQBJuYSr3V/O1p/33esJ55fEgQ55RpDsh7FJUhXywkqTlKlFQp97cvIh60cNgjTva9wpo+cvb7h5jq+mnzC7nzKfiDk/G29JGWv3Eao4PLHce9M/uq7RiJS4X7ybNEtizu7TOnsQDLsohV3KJAwypao4gAynaOohjkUpm0lc4rBDBto9cJIb6yQHhm8WnZT4UhmnVqSRp4s2BFZfiPepMjXRITQI9Z/bcYFI7EgOf9vwiqDgnmzdo4Y1VktuQnui+JHxLPQGrZ8yWTXNx6lPwvzDCVL/xBhdpHb+Unjict96HiaTtnoNjMJfBoOjQuE1eeNP3GaMtQydgCjSpA5PVxY52HNw5+5dB/vcVN7BYPD6Uelk0SGmB2q+JlXCcaeyn5NdX677xmg70j1o4JtS4nmv7ZffLz8M0yezNxbuoU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

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
index cd5df88bc6427..3313d306c0bdc 100644
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
2.56.0.455.g6c5a503b38-goog



