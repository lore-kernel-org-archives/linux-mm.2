Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96371FF8875
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 23:31:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0AE3E6B00E6; Tue, 28 Apr 2026 19:31:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0859B6B00E7; Tue, 28 Apr 2026 19:31:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDD936B00E8; Tue, 28 Apr 2026 19:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DF2506B00E6
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 19:31:38 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A574C4530
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:23 +0000 (UTC)
X-FDA: 84709548168.13.DDEF630
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 19CE3A0007
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WrF+40OJ;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777418721;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yTAjCTtkXKbFXq9w4+65aiRu/gyS7mXVovVZmREQfyw=;
	b=X5dvaHau5OfxRYzwfZZTvecOFg0vNSa/R+8LyrTq6nX91Rbim4s+pVgDrWp1vEqlUwwGGD
	YPswbLc8jCOO7qG8sL9fG1b6XloMy1QboVDpCBF8RAuWE/Vf+/Sua+CQOQBCFnAPNhlqeG
	U9HM964ka0e5CbiQksrgdO0rmNZ2FsE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WrF+40OJ;
	spf=pass (imf25.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777418721; a=rsa-sha256;
	cv=none;
	b=BuJFdgZOlMtfz1YgVzKZ1cJ//14wyL2mJmnMzr8wqefKy0IxuemQNrLridG8Qr56HZhQzD
	H9VaF6UT+tuU7djTz6XOw3j4mLITW8MuqWwYrJA3gAzzMByEQAz9R8bvKXYLTQtc00xICr
	/uA/Se0lba0pSmn6Nqu6qxm3IOWjizI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BB5E60181;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 335F9C2BCC7;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777418720;
	bh=Nf2uujmY9VcGyGCk6p4BfNja9Ll9DL7iKX2wZF1qGok=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WrF+40OJeQqWWnSmUHqpMz3NFp9zHeX5q9ij7o6oAPIS4XEJZOG8keQzgMpuXb5zj
	 Wqkg/urSXGlB/2vGQJqwSMbBsCMmLrGYAs2zSkEXEcsdP4wLy+cbLgTCSCpV8MwpkV
	 icSfPBUIFSYL+6v8mCnnVbWQvXwmsR1ND6XgJuhwVd/C6wnQ/3N89jgObvctEekx5l
	 NwnnnitD+95TGli4j2lvygH7r9OAKloP76A+uWf53wEbt8cmGkZfiQDTbeFoWpZsg2
	 cH6yGyhj8zkLefU3HwA4/Fe24NXDjkLWkhdSHRILrMZBoszWR8ST3AaUMhelWF3Hxd
	 xzBeQ8NielxTA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22A65FF8875;
	Tue, 28 Apr 2026 23:25:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Tue, 28 Apr 2026 16:25:30 -0700
Subject: [PATCH RFC v5 35/53] KVM: selftests: Test conversion flow when
 INIT_SHARED
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-gmem-inplace-conversion-v5-35-d8608ccfca22@google.com>
References: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
In-Reply-To: <20260428-gmem-inplace-conversion-v5-0-d8608ccfca22@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
 brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
 ira.weiny@intel.com, jmattson@google.com, jthoughton@google.com, 
 michael.roth@amd.com, oupton@kernel.org, pankaj.gupta@amd.com, 
 qperret@google.com, rick.p.edgecombe@intel.com, rientjes@google.com, 
 shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
 willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
 forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
 aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
 Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
 Masami Hiramatsu <mhiramat@kernel.org>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Youngjun Park <youngjun.park@lge.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
 linux-coco@lists.linux.dev, Ackerley Tng <ackerleytng@google.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777418714; l=1651;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=d3diFsGfXmDo2adM4qAr4NDT6FCtct/he0WqILialfA=;
 b=F2ouDv5e83vQrUQe+V+yDI0Ntg/VBAboJtH84k8Y287idIlHcPCLvX47Bctui/LXKS9D7iBMn
 7LsbwypaN9wBM0XghTDCutRLzAiGYO5GECLGthQFpEKChNvrFoy+hi4
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 19CE3A0007
X-Rspam-User: 
X-Stat-Signature: 74ct6zqnziqs176txsjrxekck6w9r1fp
X-HE-Tag: 1777418720-744562
X-HE-Meta: U2FsdGVkX18De6JQpuhBXJlgHLEMNYT+VWUhqZ6PvpEwPKoSUBLLlTJ2WVMGdXxW48Z4FNK35N9A57N11mgF3vxxzKAYnwJH+gYs8mO50cIACsZAD2xGYr6t+P0cUgHhf+uNn6sK5KYv+vyXQGl9apTOW11b/wwi+NhP2pGk5wQlDRT1Oy23YPsMYHV+SLd4gpygOem6sVTA48QM298V802KkZFD2GnHIznX4sfVP6mwAuYzMuEGEtKuvXfN6nabmcaMn5WefRouxWRQzqsMFaBog14WbM+abfUWZqZWvyaP/0LUB6O0jQGnlC+8pGpAPMJH45YO8odMavrlCuHgW7254LW3cjtxYckiCpkAN0JlCL9CTZRViHY2MxMdtqwC2Bc5LL2dBh3jYeZ0NAbZeX7/CkTqjCuw55q2sep45DoZz47kaHyEUZG/9cF3wsNXs9kyIOwDbH+p89XV1o2hZo5RudXVXvzOnt3uowjb180WcEngxBFYQAultOYb8Oiz1cAGplMAtBqOf/QhJn9W6wsGzQNY6U4BjinWfNad6BGv/ACj2Qj0KxdJkP/nYj0YypnZ7fblfl6wOixCc/RV9vWbA3iHFY4a41AsILoReeEZveohShXAbFWtAIvYP83r/IxgUHHcArA1DTP1UVzG4ciwX4IriTVcS87uP4Q2ZFoxJG3Uy16tBWncVJILkCbubo7HhrJyTiMLuy6YeX/Z0yCzlQ6wtgsyAPxVwnPBB8HwnAvsWlm6qMLyonmiyBUH7V/fVNo7ylWAkiDNtAfpdo4LXSV3W02D0ka3lnA8Z4VsSxr75yMeDdufFJRUj9WeBJnbeR+/cOBwhg2E/6oFlyJgiq2lO+h/SfOuU83MhsP/ldm1GB8wDm4B44XF9thmhivIa8Ry8v8GnGs8uSk56wUuubtKmq+NVTbRpMmyMTBcdJYC3pkAsboNz5wikdUVzvytwi4GSBNwHlxapUX
 uqwrhpsL
 wgREgUB60ctGVUNeU+3bFo0C6hdg/YWI+8MIgBr/0GN9ntbFcByOWyP0FXrKJ4ZULHTTI82GGChDv/jmy54+BonRmrIGSUlLlOieVKJCt5urrctEP1cLZRLcnm2q5g06KJFqH2zDgourAZp33+mixD+qp5Ft8IQaFoPAqvOx+ey8cCT2D+1gQ7hL84sivFxS//JAa7bzQ/CCJutwg5PDJ5pMc4N+PJ9yG5lOB8WLY1nC0LuvLUxt7VhVkPC/HzzN8n6ho+Zw3DG2ag8SAcuILh+wW+e7Hb4TcizUuYQ3+0/nVs2gMcSvwxFlokcsCAvoRDle39g0IN4rnBblkY8A+niQDBSuJyqtTqg5pGHaJGG9ZhcNUH1v5Utzl3d5pvnvsWLFxTsMn+n2NKLTm3TmhcYcP2AXz2Pn/yaEWcm3NBs0D9OQp3YBL15AnnuF4xR2Myrrz1UzZfuSmtrNrGaqpzvceP5+K+n/wfv1GesEYGUdfkEXMWrqebnz2YA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

Add a test case to verify that conversions between private and shared
memory work correctly when the memory is initially created as shared.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../testing/selftests/kvm/x86/guest_memfd_conversions_test.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
index 1299935689e5b..40ac1b3769af1 100644
--- a/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
+++ b/tools/testing/selftests/kvm/x86/guest_memfd_conversions_test.c
@@ -99,6 +99,12 @@ static void __gmem_conversions_##test(test_data_t *t, int nr_pages)		\
 #define GMEM_CONVERSION_TEST_INIT_PRIVATE(test)					\
 	__GMEM_CONVERSION_TEST_INIT_PRIVATE(test, 1)
 
+#define __GMEM_CONVERSION_TEST_INIT_SHARED(test, __nr_pages)			\
+	GMEM_CONVERSION_TEST(test, __nr_pages, GUEST_MEMFD_FLAG_INIT_SHARED)
+
+#define GMEM_CONVERSION_TEST_INIT_SHARED(test)					\
+	__GMEM_CONVERSION_TEST_INIT_SHARED(test, 1)
+
 struct guest_check_data {
 	void *mem;
 	char expected_val;
@@ -192,6 +198,12 @@ GMEM_CONVERSION_TEST_INIT_PRIVATE(init_private)
 	test_convert_to_private(t, 0, 'C', 'E');
 }
 
+GMEM_CONVERSION_TEST_INIT_SHARED(init_shared)
+{
+	test_shared(t, 0, 0, 'A', 'B');
+	test_convert_to_private(t, 0, 'B', 'C');
+	test_convert_to_shared(t, 0, 'C', 'D', 'E');
+}
 
 int main(int argc, char *argv[])
 {

-- 
2.54.0.545.g6539524ca2-goog



